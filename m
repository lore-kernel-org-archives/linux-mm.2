Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEEBAF8D750
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 14:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074CD6B0005; Thu, 16 Apr 2026 10:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 025866B0089; Thu, 16 Apr 2026 10:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D946B008A; Thu, 16 Apr 2026 10:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB0356B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:26:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F2F113BBB5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:26:41 +0000 (UTC)
X-FDA: 84664645002.04.FCA1C32
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9FC8D100002
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 14:26:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YAFiOq/y";
	spf=pass (imf05.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776349599; a=rsa-sha256;
	cv=none;
	b=dUbaQQ408PkuG+WwKh/9LEzmKclt1tlC8iu88UvJeSK2dSeamM2TMbG2dew3xmyBJV7xZ3
	zrJcROXTi8YKRs+kDLsM396ScoyQBvCQ4xtXFhWhjtS/1kH3mNXPrxSgmdll/CYenklqUF
	txb4/xe9vP9dcMpXpbCezCJP+bwkaLY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="YAFiOq/y";
	spf=pass (imf05.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776349599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XWF6xDBwzNdm18ji+1jjnivSj1pP6bYuXUs6j3C7prw=;
	b=cxM9b+/BR3P5E29pseV/cnAYTb63jXKZGyxJ6KHLeNZkC7n+MD5hoay8bFc9p2M2RVoQiQ
	Nj8XwH71UOQzMubre7y8aKFscHi9YKQ6XUk8Pf5nBwvbif1BtBbyDGVihjr/3IdVjX1zms
	+pD01DWKu62+TTpmm8W5iaKKTJN4x3o=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b45cb89f7eso30920595ad.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776349598; x=1776954398; darn=kvack.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWF6xDBwzNdm18ji+1jjnivSj1pP6bYuXUs6j3C7prw=;
        b=YAFiOq/y9Z66SWD4XM5UlICbIZ//8yKo5ZXjtxT4fnyaYFC1TJ67ux62YX6/jG4uh4
         yI0wGdKXRwN/3RiDyGgl+1jL41Phnf7K1UxcaTyjR1Sv/mUJkTEDPd/wQ3FHuOHca0pu
         wKSUOVzFPcIdDZdp4ponpGAdpTVuW1ZZtG+eDf90Bp/Kva1EMdZMnxVuQ7ymVSf40MZE
         mPbG3Z1XBT/Q5s5tLNDsJbJ0BFqyEXqsNxMH1Ph4GyTrzQJDOIuaeRtNVg32mn3gfQWE
         6TxtudtHhDdNxHHTel3m+P5ApDGCPDRPJKTrhHvXiXjeOREUfXKDZmBcWOrxnjbHcqGU
         yhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776349598; x=1776954398;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XWF6xDBwzNdm18ji+1jjnivSj1pP6bYuXUs6j3C7prw=;
        b=m5M7QE3K0R3/iwwSym+r6bQrcyALSptwStfxXGYZvlV4/Q02y8Z8GcKcPQ0JXOtySw
         hjrcVTZsYQ/YaVh7NTmX5B9ZXoF8C7bgLWRWrhWp8CFx78iVVu7vuyrAc8Db7SuAr2JL
         TRgDxuG9GF77QNGDueSg9paSj8Y+Rj+1ow4+6qCxChXuJAkS9ppLhZp+DJbMUYMPPXFb
         SQsMVyJ/IqlKCY0CyJoLvYnTuyuCZ1ga12BV+V9zV5THWus23NfEEqcxJPr5xhI7vzcV
         xgURf/7UjCHqJfNqnjzNiVPQz8VYWrn2k4OYjU9KrN2lBPEBQ9cfdKyPE/CFfFNnxZOj
         lCDw==
X-Forwarded-Encrypted: i=1; AFNElJ84wrRaTIK/Kbh5IPTxIFAWqFdEuE7/BADxnImtYuPui1NbNoRFLYF2WGqGovqucJTZSE93bxLgeA==@kvack.org
X-Gm-Message-State: AOJu0Yxj3583siznCmng+yIwAuDG6veZO97N264LVPR9RSlcOzPY+ys7
	Jx+uch0WD1WvXGW6zez1zrVSbeR4vjXayZVP0u8vs6qPXOrkz52vXicQo47SkA==
X-Gm-Gg: AeBDievr89jXqk/tfEbtKpKKIX1Z7xBcUbxSxop86azvIYjAAW6j8hEA6A7x4ihxtzl
	eyuGkVzZhRlyh2OrOYqFSOYwXEMuUNQ/aOQqn1Gv0aLlyVPrc3UmgXksPQv5d9pfjKZdY846kCR
	rE+MbFjvPeuv0uRcbni5YjDmW6BNcqWjCXDfC3XzGo4S285qM0mj6xsJp2tK+ksdsKt9gQJszyY
	4KRiXOEyFwAfi6Qd4ceMnJUbb+thlRoJLKn2pGNojGj3oS+e0Lnm4uYRmyiu2Z1t4YGcPj2Xr7M
	LI8c/JslwwR/uGckXelv1vebzNT+kAk6+mk80a63p6hSKiW73BhaE6Aj3/pUWSjvBI9w6u+piaK
	czvJY15g2cEkJ7og6pdmPsLR09zz1p6qd6kPBWx6w4TS1rZ68fcmydepFX1+6lpAcdyNRehtwkk
	c0plqoRqCwnuDH3gWtfsQbj2uBCFNz/ORk+TT0/fAC3b2JEYn0Cqouxkz9rjtj2hMIYPT9Xhot2
	uW4qUpLn0aEi1P5jW0kIf5/a7wgOeP6k9sCsafCtQ4t8mBXkWsEJ/iLJfoH045G5p4=
X-Received: by 2002:a17:903:320e:b0:2b0:606b:6fd3 with SMTP id d9443c01a7336-2b2d591d2e8mr245162915ad.5.1776349598297;
        Thu, 16 Apr 2026 07:26:38 -0700 (PDT)
Received: from localhost ([2601:600:837f:c470:1879:8422:922b:e5d3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b478142565sm57547615ad.37.2026.04.16.07.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2026 07:26:37 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 Apr 2026 07:26:36 -0700
Message-Id: <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
From: "Alexei Starovoitov" <alexei.starovoitov@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, "Harry Yoo (Oracle)"
 <harry@kernel.org>, "Matthew Wilcox" <willy@infradead.org>
Cc: "Vlastimil Babka" <vbabka@suse.cz>, "Peter Zijlstra"
 <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>, "Will Deacon"
 <will@kernel.org>, "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>,
 "LKML" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Waiman Long" <longman@redhat.com>, "Mel Gorman"
 <mgorman@techsingularity.net>, "Steven Rostedt" <rostedt@goodmis.org>, "Hao
 Li" <hao.li@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Brendan Jackman" <jackmanb@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Christoph Lameter"
 <cl@gentwo.org>, "David Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>
X-Mailer: aerc 0.21.0
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz>
 <aZAWGwZP_Z75YHKt@casper.infradead.org> <ad_cqe51pvr1WaDg@hyeyoo>
 <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
In-Reply-To: <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
X-Rspamd-Queue-Id: 9FC8D100002
X-Stat-Signature: c85439j4uzghppi7bd66daphtjm8d1u7
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776349599-905338
X-HE-Meta: U2FsdGVkX1+CcqLv1meLZ2+T4cu5/CVGJtCObyc1If+YRtxEWI9DNycTKJHTJD7RGYNv/FjcHt1vKpAjAcWkTnkmugmy47ihb4S1PDYv2DZ3Dz5i9QLOUrXac5gor9dHRpquXP+JczZ4aQsyi5gGQz8As+szlFpJIE7XC9Zic6NuDVrUZIbQ/C06uEGDHPoThq8PY8JKQPO4IfiwPY9cJpJxVzIlEG42zBV504VoEfw/cPPb1MPS9N6hTMSwIIjdTjo/wOU4XQiQADe850wmww3nmGmIo/QqV52lNrpsWecHphkOPgbB640l3uARgXkGKAY7iDOgoEdZyAmggoKXCRsYFQcVUiWg4zMSdCrhLYH7hsn3eNwnI0yuP/aU+al9E7m3LCw0xPRS0TyKVPwrmj2jNCyJu+QYIWs25zmg9qfn1c6erAVi2gZ/uP/z9li0ok+DUOqXHTTk5tbKovDaJuL2L9IPXQ9OmeRVCT4HkziIZ3NKG2eqN+mlUYWhF1tvM6s3boU+FZ7yEra9zwJ3D7jM+we5f4Qyss/Me3gX9sJ/h7Qmh0BuDtUdU8q0SYtmJFRi35sJw1g/jC3IA1AmCOXai6zS6vkHR5E3zXiYmwPDZOF4gXqlbyHWHbY16N12h1FN3jAvedG9Redv9NMyfswK0S4sGHrje+bl3t/nfTbaim8Idc6rJi/CTHHHjN0rf56Bkjf87MX8f3iMX/UOajpREsIxgYVdeeKfLEZYjCtLZ1uOavG80ePnPU/aCLbPVJN1qy6DW7c+90qQCYGufYBbMo3pq1A0CDsx/RjvMFlBeAUTs1yViR5UuH3eEYZVQdR1194wW89u58ZSkKdLJD6/7A77f434z7Fb0GMhdoiEkoHf0552b6Ofa3cwyrQ/HT/uBcKMRQriExRl42Wo3KuFsjlVPAXdsniPP5mna8BUBng9aAPNFSx6bKKRXfqXuDxLu4ZAbxZKzNdfHFf
 cB191wsw
 u2OFgMlJknilLB+w1zDxFjdgQLqqAsrM89lgNTUmZDzE2zUIUGvlR/654AC6j/k+PDEqYm2nNP7DL7k+OE2siHAssZampFqJIOhVUZ4uDyywahwZuLEPcjHcS422suR0yqvOGnTaxcsVg+vJlHjp8A6ni4cjHw5UPFoGViiXNVHEGEkAlMTtuRvDneKsraO3s4j/eZoVbB+m2VgtMT7AMjM2ksIpMyfsF0ruZc8czEIcQbY0k9rs8d+wA0AAQqYnMPv6kVD8VKa33QU40uqV8kfuyX+iySgvTEvET45hnUWAIQ2UBQEFcLzGhU/M9vwRI9je5ogn1V2uc8pe7LcGRjVz/aMIEdEa1k+hIGovL2OD/7RGIKS2xL99HkyXPmlLLgvLX8PEayGfzCLQRjVfmSKceTaw6cEJDTdzSsJeOnzQcdrrpzzGL/gajALm8+zMhUtLFyrA5aS/t3S6d7KMrrnhZcpSrWR83TfO497lY3JnEcWeUV9LDu3uXafjnX0Y/Op3WdARU3VlHh498ttFrQsofBq7o8RwpN6+cL4mdVbQ1Q3UrXaUtd/BLsFLQhPg6yR1v9Oc2KZ2RD6ezOdp4ukjQbZuhdJbghB7RHlHi2iqXLh0Cx5+uQvfUnhuc3l3ZY6TRAAEm1ROUkDTxkgZIqbCBKLSE5FkwJAClsdfC9Z8WkEFVxIM20KQVjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Apr 16, 2026 at 3:05 AM PDT, Vlastimil Babka (SUSE) wrote:
>> I think we need a special spinlock type that wraps something like this
>> and use them when spinlocks can be trylock'd in an unknown context:
>> pcp lock, zone lock, per-node partial slab list lock,
>> per-node barn lock, etc.
>
> Soudns like a lot of hassle for a niche config (SMP=3Dn) where nobody wou=
ld
> use e.g. bpf tracing anyway. We already have this in kmalloc_nolock():
>
>         /*
>          * See the comment for the same check in
>          * alloc_frozen_pages_nolock_noprof()
>          */
>         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>                 return NULL;
>
> It would be trivial to extend this to !SMP. However it wouldn't cover the
> kprobe context. Any idea Alexei?

Yeah. Totally fine with that. Certainly better than "special spinlock type"=
.

