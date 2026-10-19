Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2253CCCF2DE
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 14:16:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013BE6B0275; Mon, 19 Oct 2026 10:16:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2DF26B0279; Mon, 19 Oct 2026 10:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43836B027A; Mon, 19 Oct 2026 10:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B99126B0275
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:16:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B8DA1C401A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:16:33 +0000 (UTC)
X-FDA: 85339576266.14.93C747A
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2A0C3A001B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:16:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="i PUEyMz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Zi3gaDNK;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792419391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5BDBmKtEvtgQjQjsp2zDIOZYhK/Nfvm1AAxcyduDQo=;
	b=exmslrng6j7u+kdVSAZZHfZtesJY0gtn/itgXL7itG/jayds7BQFWSmN9hdsdJfriwJtCZ
	MIvRg6jLhx17kuFLzmsrpd/DNPUKRNV2S3l665/84JnBYgg4Aha7Kn3f3AHWj51+tKyIce
	Mq5s5PpPP3gCDADlNdGLYd5OuFj1Nrs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="i PUEyMz";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Zi3gaDNK;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792419391;
	b=tqh1wEvDEzUU5IquvAVnExm3fuuQtZn64zOxToZW3dJo5juTN/v9BN6QoMzXHKjJL0wbFG
	mG2Uoe0RjHitCE1v6VKuly+19juiKlu2H4SqU5TC+OOx8u2epqjrghm2w8zT7QhAiNm8MG
	shG8yU5vLg53ahRW7VKEi9eiM+jq1Ak=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id AB8C6EC0226
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:16:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 19 Oct 2026 10:16:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1792419390; x=
	1792505790; bh=E5BDBmKtEvtgQjQjsp2zDIOZYhK/Nfvm1AAxcyduDQo=; b=i
	PUEyMz41tGGTyXZgZSQTk3tQ0uit7mVOJlHNzgbSb1c8j7DOZCXO1u+BdDzGYz97
	wIW87Vr5MYxmqp+AK5NI7qhudA3OaR/vvfEdljJZhjrMs8LVYk10GCvTaMi4HjhG
	A+jlSPkq/KYRY89vws4ez08kMl2LBJCvvATr4r1lhOPJJW0liaTVqwdcwFn/APqW
	iVTSgwhGkkrH3x68tRn384mZLptRJNeErwfp0bS3L4Xjrqw40lvV3WABi5l4r1mu
	WHloOwU2QT8uJyykR08dz2Zz63J0m/ihTCVpc4mtxoCjm/Zv4MQ7t+VVIhLghruv
	tx4v/lWXePR2yDMqpumyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792419390; x=1792505790; bh=E5BDBmKtEvtgQjQjsp2zDIOZYhK/Nfvm1AA
	xcyduDQo=; b=Zi3gaDNKK/1HNVYk+L/SRqTqEq67pyVr4++dxjfC1uiUzKCZRi2
	2u/4A9mhUnbx2P9dfkMxJAsn/NA7o3NhRMEZJsHhgqtK/ORxpbueUFF5SYBt+sLq
	77IBiAhaGxfnTDAnI6rjRA8SUbW6Z8sR/XZQdqh7RdSYQd/JXG0zL4oxsTF1tBRL
	rZwW6WZpyLsUwgztVyUI8+7G6HbFDn+GOPfHTqftO7BWVKmVQLkzC76osA3+gQQs
	yzEwyLedmfSrilkxfo8oFs5iN5tnKuHp1kMrJAfE3Eav7Po6tvXL87UjfUnMMUX0
	/KP3JX5kYhrDlYcuUPGtqY0fOau1tVcC5IA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792419390; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:RPlUVMmBAnYZNRFcqV2Zm+Vp/OfqQIIQbeSdVImDWKwio3P
	EmtMZ96Vq7gy0677y6f40XkyKbSDrjqDXKmaOFVrCeZRDfFPH0nisireKBZanorZ
	Lk52Mrg6NF6VedomJS0n61wuDanWuVPqduSf2zgXb/VU8mfkIT0JHTSHagMPNCg0
	094aF1HQSi4wzv4V51UymTf+XU3wM0V6kziM1CnZOZuIJocdSxwyxdL78CvNhbJR
	0U31lWIL70zsQWRUT0N7ti13QeQPY0GXjRlaXnhFSbLOJxZWYE9OoKaz+Z4fn8VV
	pgO+G4H6qagejoFnGFxuEREFdE04lX9dL0+nO4w==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-08; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:Z7CgK+L4iXGjNVXlHZTfLQbOyoaJ7CM9F7sgZ4RrVV8=:u6jcQh8TG/zvY1ya1u+1OUlNtq84z7U924g7IErDvzs=;
X-ME-Sender: <xms:PibWanY3pecYEIXZMQUBxUoGLV_YQB2V-9DoLX6wL7Z3eekquJ7-yw>
    <xme:PibWan491ki2a-0mCIl4cdrcxvSjzruQZjhLaIq6uXWBCe2RWF-fng1WTKsi01CO6
    QjvhcLfLJfGOUiomH4SRjVR2dbOpYfAzzuePWu8bHKdLfG5EcwYahTQ>
X-ME-Received: <xmr:PibWank7RZVv52IieIK5vrNqw2hTAcdky1b9yqYN7X8izerUALpFcqBR-WM>
X-ME-Proxy-Cause: dmFkZTGB/LU2Bh7x+KJneHJ/5PiltiMSyEIuSO9AYIXICItJnqBtVMZLJSzSJj1leOgzXj
    f2ZyTkNsJ5fPKk4kK2aaQb3smMOAtMxwEC8xuXQv2OtWSxqzViviQS2MxNw0LcMxPOkyhJ
    tmRO3CQUjYdJiR0u0Ol3BV2j9l+Lx4KCHSjZes7R5cTl4RaTGYF2CoHt9dLU3e3t+Pv0fg
    2Dnb7UlYbTq1KneDfEAa4juMViGCIcOM0xjdsxY3P8LIb9Jw1xxbLu2oiVzjZFBrJ0jSpl
    xfxUBSJQf3iajVLNbCb5cz0GCqlZLkql2JIh9JOrLMf6hG8ARPRpAtvwrbaZrUPd3hBoV/
    Nw4/aKf0POdQCf3nsb3ruUIlScBIvseQ8kJ3MJBT3sDS9mcwQBKP6DuiUylFmrEJFqmfcI
    lCRsM1NxfgsiSmdIix9zPO+NkhfxvrME3K50iuVwvBqfBo3F7S//y0WbS7nUHRMmZ8HKi2
    ojxbCdsvGXgB2UsMJUxLc8IHqxBC+VzWQNcbNE63I1mmHsPKuWa+5FMbZ1UWlRExjvmn7e
    VA+1wEw2Zp/tTQPOhA5aCEKra4dKEecVPNr+6+0ZK0T0r29qoymPucZqdQyRZvV9VISIGr
    GeU4xro8+rV2oQQUq1Cv12gTLubej83f2VerwHPrlFtXP54u4W5luuPSy8kw
X-ME-Proxy: <xmx:PibWalG7NJCuwvM1fOd4Gy9IK0l_nkcahkUsQeHMDiHbJmBjGf5dyw>
    <xmx:PibWajEjk1A2hzHyw3kD6ns_Fn2JBA4_ns89eHIwzMydt6A9ufIdNw>
    <xmx:PibWal0hD7pFBBrRNa_SCVSrS3PiEBe-Qc5zDNbNEiCKUhV2Whn1eA>
    <xmx:PibWatdZQZpS6pX0TqcawPeJ_z-bowepjnoBh27qaJADwIq59nPICg>
    <xmx:PibWarBiky5cA2rEeAp8U-6cQKFzV1NqY-C7JjKH6tB8SZ4hCioRo8Iu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 10:16:29 -0400 (EDT)
Date: Mon, 19 Oct 2026 15:16:28 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <atYk-TcWs056Mz_b@thinkstation>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <atI0edrmeiRuRtNQ@thinkstation>
 <CAHk-=wha6UNEv+7nVi9zSxa4p=4K-HNMZqxMR-RcspjPTxYp6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wha6UNEv+7nVi9zSxa4p=4K-HNMZqxMR-RcspjPTxYp6g@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A0C3A001B
X-Stat-Signature: jginri4dc95uiobwtxhrab5b4nbx3wh6
X-Rspam-User: 
X-HE-Tag: 1792419391-953122
X-HE-Meta: U2FsdGVkX1/mx2+370ollnH/XVCVgEloLkQ++nsxdUND4nacvgvIJJYLwfW53TeQDSRJC8ORstytaYhyZeuzNO6/7I2yVy33Z/sAuseaiD2xF0bPqItrmi9C6n5A/NV+b2bl40b6gmWj2ALbE+40Lax1Mt//Aoib1UpHf8nHOEH6HkLIM4zhbVWDCYzUwpid4QJsUFzqka8dcOIEXS6Ra16aotYAKgiZem4GLVYm/DTlK1mF8MVZ3NB7pEmRzq94I8NE4LAG0B2Njm586PJxDqmjbPBZQV+B+gbOTQUNHWvxMuifXP9d6DlVmn74XQxDqiCGK4dl/eU1WntL8+NdTbVLUvYXAVgl6TwyCeZktEUtwlpzVn9VSgfO86u2028rPdukTiGdcEyCL2aWOzuAIuDJEQkyQLYGdhGj9rkj40xwCtLfAeo0uGlbPs/IxnCgRT27SqqMrN4iQFIrU+8GlbR6CAwUi/MNG1woTm40B43lYKz1pk4RBe+WiKE0fuJadDfp5ki33ywoTtP8BsF0zryjMbZgyWAE4+qc3tKSl0v3IkcLpqQ3y2v2/sXNCCu/6jR/ffmo/YAkbWDR6W8d8bgIfOEWdTP7J6m0QDEcOWw9aT3l3N2vUfBfp6aqOGUijRtmipCN1RxTIn4QT6EOc5KAlHj6tOKuWKrN8XxNM6dgnkXLJXvHosql6CePCroIWkIVViZk9Clw0gW6UqYIllW7ko7yLjF9sivwa6Rgq/NZAl8OONfXL7x6JV0vx88hrIuqwBDuG66qlCFhT4gvU0bKxHLHU864YJqsyNu5YIouZtCt4/IL5OrcAHV+ZIO99aMS9xUtaQNF47IxVj/SGkKha0xBdYTUFAXFMZXbsyR3VjALshXUYCZDgyhzJxZ5ChHH1zPVULudApLdcDKKvl/Q3qVJ2GgXqr78N/iztj4cXUFT3shUKP3c48Zr47lzg4m/D5AglHhzULUq4FB
 zcDpqVw5
 FhKGpugh7ErVosxdpqLuvfzoBbgflkOH9d3hyld+YKbTGl5RAhbohl6VyMg2BdZc1ULHHkDpGA8YABpQcDLCeFcfD8iNlU7UZNe6ztftjiuPRsNO/dscOj9kp8lPLPOInRQJ4tM2O11tCKfhcqDApxeAOBFI7o2TKhBuwJAk7XFJYHSsp9Bu2NYeURzIEPmRtrw6i5U8AHxw9Qj8kUPypRzKPjX/Nsv34ObeGMqtunXaqITZCzH0cLmj71iWDcgvFySv3kuMVTqCAHUz6XvERKtivrEwDfHVqNAirGCy2bRhhCmRE8tQjqCJ24f8FYItdraYnb8oK/orW+OSMIFlX8xccatcDuvgVqxrhMPFS+xuETnJkhCRe73E35i2eKB6UqCMdGppH3Xv54I1AUWVlce8TipDp78mcxgkaRDfQTZpJangV4iShT434yDWk3yijyWcqHuNvU75PEvk9fcQwXrrtM4EwPgj575moJeQAeiWASoYD8C8E+z8T/1B26DKefuP5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 07:47:48AM -0700, Linus Torvalds wrote:
> On Fri, 16 Oct 2026 at 07:40, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > I've added a cutoff to the lockless path: if the folio is large and the
> > read covers more than four of its pages, leave it to the slow path,
> > where one reference covers all of them.
> >
> > Sounds reasonable?
> 
> Sounds eminently reasonable to me.

I realized that we don't need to re-lookup the large folio in the xarray
for each index it covers: a large folio is all-or-nothing. If we found it
at one index, it is at all the indexes the folio covers. But we need
*one* more xas_load() per large folio, for the last page we copy: the
folio's size cannot be trusted without a reference, and finding the
folio in that slot proves the range is still its own.

So I dropped the cutoff. 64K reads of one hot folio from 64 threads go
from ~93k to ~1.37M MiB/s on huge tmpfs and from ~572k to ~1.36M MiB/s
on ext4: the cutoff sent them to the slow path. Single-thread large
reads stay at base.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

