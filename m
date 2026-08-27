Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71AFAC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 15:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCDF6B0096; Thu, 27 Aug 2026 11:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A4346B0098; Thu, 27 Aug 2026 11:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5942F6B0099; Thu, 27 Aug 2026 11:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7C56B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:02:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD59E160459
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:02:19 +0000 (UTC)
X-FDA: 85147365198.04.965E27B
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id BA1B440002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 15:02:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ewMq1ixY;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787842937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Bf7BegkUo5SVTaJjTfnH0NRee4RexFhC+XH1o5griA=;
	b=Oh8kANYWXrnhFOpOcWYo/fNUXrO0PargsIrePzd5rFcdVaLOSzVVPYa/hi+CkwU4oBK6AZ
	/3vUmne7SBrM1Ar4Pm/5PtECxtsxX+mQ6MfhIo/DCyCUQaej4+/6NPHi1ii89fnH/ts1hO
	9sVafa0I+NTtY92zirjlmjkruDdwZ/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787842937;
	b=jP6Xk4xm7G+ZEqaDi9hFL6M4tRjaAdhJr7i27oNE6UJGjHZnQywaZMakFY4CpxoqXY6GDv
	jce50cxernI0R5VUUYd4+mMYqQ6PCwS+Slk/rDHIicVHkuveFh9YR7MxOQKjhpoK9VaA5d
	Cp9fz24YZQ8xID0JtRTap2hayP0ENLc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ewMq1ixY;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-85a50f6a7f7so25699197b3.2
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787842937; x=1788447737; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9Bf7BegkUo5SVTaJjTfnH0NRee4RexFhC+XH1o5griA=;
        b=ewMq1ixYv9LtmpH7dgVUZtfpt9d91AAbMPBETqVCg74H5EsMCGuh6siop+LXr4deAp
         /4ugjzteWEMDWrNzQKlm336b+KKMeVr7ou4oJWFD+vElRAa954gnf57Hw0qHuvtCv1KW
         sCJzXfyFvNirhyaMGQsbI7gOkaNk5dRHWNQaH21ySxIiKvXLQ90X3T/YwLII/XZMvcK6
         IlLU7538F/WTO/k+lWYX55qyULnJp5KKUMe4MH99LXjPNxWZ3d32P7BB+kIBWRp3P0iT
         6+Vj5fMiySJBbdrwsmdNjeesfz8ZE3a3v6Ib9AOJmwyoxgNokhzy14SySzwQte6JIeko
         J+/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787842937; x=1788447737;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Bf7BegkUo5SVTaJjTfnH0NRee4RexFhC+XH1o5griA=;
        b=VNCpz9idrlPuYbN8lXdIU9lSzFWxuJI2RZrMhc+mfcSBIRmqTyHiWHVAByXe9ld+0H
         FuLBnRdrZGGPLAP0Am2gFFS6+r/h/5gxz4gfhN4TmoQhGjgJ+Jk+T4zOa5Ib6rQhcKOK
         emMuK8+2mzsn6CWIYbi+oE24L1hb64Ukk0bvu1gFCGFpvGn8UksC3IwDex8ecmBQ1XJC
         u4hm+grYabgHXrs6QbzHUYfnI7VuJ+LIrp+nTBm9WXBa7hDzjqvEkgAOKCntTt6Q4rP2
         4cjKOiletUoY2uW+UVByILFDmXLcC4Clf2KE6qbZqwq4AnkQOnm+/cHEzI3las+785x6
         MjKQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpppp2iiyCtiDA5DbioJYkMWoIlCqu1rIWaQZ9r3X5Sc2ZU0zsBg1NNVJdyKfTMyyZlXQSCVGLbQw==@kvack.org
X-Gm-Message-State: AFuF++muMIsQ5R3OCejPrrjntJWspt2tegGSW/00cfoP79PLUcbgRv93
	6dqNCd5icxawktL5V5XDo8sc501PlzyM8umezKIfKuldfz+J29gnE9lqGgfARbHBQW4=
X-Gm-Gg: AR+sD12qUFatynr1SI6xGgpfbVgrT8oXaxVwqjBXekMaC/O9O+tznSXBRE2G8Jv3ebP
	r8otqGJuKMzi3fHU8RFXshDlRgBFl6IPQP2iFjf8QhJ0FgAfq+G5EG6smASQRXqHKlnxfTqkuTh
	jSQ7yXt0GQ+p7G2iJOriC9H4I7Z5epzS0onrrmLDJJjyDxy5QAc/7blDTZY8qq2HUDLKyGecJu6
	qn0uCkQKvo6cWojbRW1Iif6V4xKy+G3/9YlfZliwPGA9IiV0LdXDY6toXorPWtt7WkM1nUOwlB5
	A3sknOR3kNveqJZp5IEPvpUTH3bgiq/oLuM1LdDvP+ipRLqm77nD8fb/H+iqTqmPk8I998GKcU7
	wohFWWjhKpeXI0CC1v2QlJIUHFrze73936oDH0fzEyMKR/YL/c0mT6Kc3QiVktSlzTofRRRt7ha
	DqYqZUJj4qWt4SiSXup/Xlx908rITRmj77yBLBNBcA4KR2LZhDbwrBzm4ZyVjJ
X-Received: by 2002:a05:690c:2702:b0:820:b89:52c6 with SMTP id 00721157ae682-8574172ffd2mr75025547b3.33.1787842934644;
        Thu, 27 Aug 2026 08:02:14 -0700 (PDT)
Received: from localhost ([2605:8600:200:1a83:fe59:7385:2855:8588])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-85b626ec6ddsm11363877b3.46.2026.08.27.08.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 08:02:13 -0700 (PDT)
Date: Thu, 27 Aug 2026 11:02:05 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	usama.arif@linux.dev, lance.yang@linux.dev, ziy@nvidia.com,
	hughd@google.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
	liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
	ryan.roberts@arm.com, balbirs@nvidia.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH 1/5] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
Message-ID: <20260827150205.GC3004@cmpxchg.org>
References: <20260826162101.1314941-1-kirill@shutemov.name>
 <20260826162101.1314941-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826162101.1314941-2-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA1B440002
X-Stat-Signature: 4ztkuueqa8985cmz43eajk1dkdu8euzw
X-HE-Tag: 1787842937-127736
X-HE-Meta: U2FsdGVkX1/L3E6Z1qFBeUciFFjAGbum50UF6eY+qO+GtKHZaq06PImhU1wpN1c7RMWibXX7PLNzUQoVm7ST+ZjO3/USY/tqVcCjzliS+aTW6O2BaMZOGzEcMZ/Hvg0lQ6eUqh3m0sx+7zhdPEG0gTdeb45IgRm3TX8OG9+OI1216k2hwSLagx1hl2QrQTCU0Ixz4Z4XWCQeZogdvYq1KB8Fr6Qec3B0vS5DdEZJLMRGyP9DG1i/2lS+7GBvlRtEdauS4vT0bAzZ94sO7O9S9O2GAuocJUontOVc5WEKqIXryTxelg+7NM8zbkBXAz3BQB+RvSIBJ6X7T/wbkMuxzsxdB44vdLKIvHaQjCDdRHFik5QTSosKaN0QWG29txPz2g84NjOJ0FPqgotG/VNLEm4qngpuFBfJOdg6xXFFQOUvUmnsQB6bHAlLRCYRdqzZZm3ddenUv9ssPzBfqMBRvEF/3xKNMCI9RhaduMgD8X/9CGZgQHXI7qZl44SrFt5ASg2tHu6YbHuLx1aPfmpFzaDMMUuwOapngK0bnYZtfHOpfWcwYZlOkzfQQMAApys2f+VglK//mUcfSpip48Id2UbHiz1aVrYRQfvcqfo9Mv85Q9Ac9AJAl4T2SWkIZCaNgPZZCbrv4bxrtm0Usl22xugy8m34+mxmkTz0c9l2Trja/BFTMtMkor8NgYjPllIMazqcNl0rao8P5VVBSyyNmxmjEg+4E1Jowlpl85OzezlloKM/ZwqtmxQwMzjXd2rSwWZHOpIMVluaXX0YrWJOmKQHQk8TLylVu353qdCeyhaVsnNosbAcYFvmtONlQbKp0yb/EuIHYPd1rUzP7BfKvYrD1+E5VGbFlOccCA/ty6o9LTJWyIILvvk7VG0RuW6JVo31UYrCsQnXe9UkWQBW/gFgr2aBu1HQVc4TlfHcGI54wsd479qJYtMbsX8G7dBcOKsd17E3PrPbmCUzOXz
 3r8iYrBK
 vl5CVXcgqyYnCJRrQENrSXVs5Pgt2y0Ia9QUwFFwP9O7s1xqizs3knCJ54EoS6ZB8YDAeWsQF5USqh3M0LEa+pNgxW44XUGvMouEBn9/+v7ba7IhqJWYOd1PXDck8xx2YEy0VNkFckc8ClvbuKbpNUwqjZePrrPIPg/HSMw881/rvJsPbveNDlO7N68XNxUuzmkm6OaM5ytiGyDrGJiJR6gSNYBBnVIof5gSK7y7cHCrSq5VSfPK/SrzmpPUxDp3CpCwQ9/1mqOnLjvRT+QjC4VHJrPkrVmsancDVo/nj/Czd12X+opDaQTzMcxNj4jO/Z3w9vFiCP2wu/stc0ocvQGSpfPJHJbgODKONl3E3L/WioHXuVYBLn0wpPLBT9+FykTUI3TcNRi69/JNZPwlXVn8qjsVkQDVEpw56jaFtjezJv8k5EiOH/UoodYewWeLNDeOBfVZOizuVRLBb4MZXHeaJK7wXm5ZWcKGV+nC1hYdAWwuxIVz5J0uiYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 05:20:57PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> deferred_split_isolate() probes each queued folio with folio_try_get().
> folio_try_get() failure is treated as a lost race with folio_put(): clear
> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
> the folio off the queue.
> 
> The folio_put() race is the most common case for !folio_try_get(), but
> it is not the only option. Another scenario is folio_ref_freeze().
> 
> A zero refcount in such cases does not mean the folio is going away.  It
> means "don't touch me" and current deferred_split_isolate() doesn't
> respect it. It can lead to unqueueing folios from the deferred list for
> no reason:
> 
>     CPU 0                            CPU 1
>     ---------------------------      ------------------------------
>     freeze a mapped folio            deferred_split_scan()
>       folio_ref_freeze()               folio_try_get() fails
>                                        folio_clear_partially_mapped()
>                                        NR_ANON_PARTIALLY_MAPPED--
>                                        folio off the queue
>     give up, put it back
>       folio_ref_unfreeze()
> 
> The folio is still partially mapped, but it is no longer a split candidate.
> Nothing queues it again until part of it is unmapped once more.
> 
> Skip the folio instead: whoever freezes the folio, owns it and owner is
> responsible for its fate. It also covers the folio_put() case:
> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
> 
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Link: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

