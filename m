Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95152C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3206B0088; Thu, 24 Sep 2026 11:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763B06B008A; Thu, 24 Sep 2026 11:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 652686B0093; Thu, 24 Sep 2026 11:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 375CC6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:37:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5D11C03DB
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:37:32 +0000 (UTC)
X-FDA: 85249060344.17.6C64EF1
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECA54140008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:37:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jM+3qviD;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790264251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36sy3YZJoi15KsekhCcXhYJyq8gSbQAoHXpfkXanlH8=;
	b=NkvRvBPq0ssRQun8cE4FjnTzrKvSzBNUaEqzfi3BKX97f3c3OV3w3/9AcPHc9Ydh0dzqDQ
	TOFv2pIsp6ceUc9mrc/rWwlVCcGi7weyT0q9fm54xr16s5V1i/zJd3cDS8IwclljiTdKrr
	ZBhoa265EzwNP7uPsfi8JVmUPQQ6kPs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790264251;
	b=gECcfQ2NFiVcV202Rx2GDfM8Rj1tSUJzFd/czyX/R4P8dx54+vgK9ZBp/CH1aGVh07MX1P
	LqALzuimB4XMPV9YfdecbsnfAywCAoQiWDgKL9165vT7WKltat3C5SGp3QOcEip2j0jG9t
	RUXi5U3U2OzpxNBqMjL5lNFC/7mCT4k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jM+3qviD;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-90e9ad1a373so7466376d6.0
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790264250; x=1790869050; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=36sy3YZJoi15KsekhCcXhYJyq8gSbQAoHXpfkXanlH8=;
        b=jM+3qviD602uhABp7+zS1vyL5S/wsJvVPftcbxHGw5OCeR0xiDeINDgjO7E906vmax
         Xrff0IuzngygPdcObMsSGYw+QQl8cC3nqWfJO/bl+qYMnTpi/3VSYRzupYUdnhxIsdYi
         yRGbeYoGG5lSJ5J3mPNpVl+UtVSKAjjcpzGs+zPgNHwkXZyTaInDu9QNkbGnoXKhdce6
         f3auw41YkPxFlJO35uwfgn6Xwy8JQf+o/IVAQe0ZtuUDDp0vhz9MUU3uN3i2Et7w+DwM
         qLleAyn+KyaknJCqlI1GNzAtpfzEGg54Hsp/P805wX4m8q9lCpvsHYO8ndPD+7Z6z8OE
         wm2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790264250; x=1790869050;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=36sy3YZJoi15KsekhCcXhYJyq8gSbQAoHXpfkXanlH8=;
        b=mCecoK4Ds+44nSrBwke0qjCMMNR1HhmjYBJP+Y5z9ejuSBO7aQ63rPAEAOlq1t88eu
         Nqe3NtlWX6RojrEkYsn2WI6kHknUR1B8wkGzA/MCfQfBSCXWkjKR6Md929BTEDHgEYDN
         ietfEnkLDteGMkYdUr+eM6o5hSVsayNJaoCNEpKkMUAKwu0BOp4K0Zu4j8S7wdSwQEBv
         +TtYWRi91CAR4R1nIKaBXinkoCwipPIEjmPLCHcLzJSEvpNlZztrvzOU7R60BAqA2fDi
         1HIZ98fQkJACrDYTSGj8+z5SayOF9f/4++VsAGRYeA610XxFp6jdpXXMSv5zYbM4Ij16
         f8ig==
X-Gm-Message-State: AFuF++lfSyFgf5GgGZJiA25ykWHwSf8B5W3+jH+KuhROXQH6iIzOwYiC
	6OOSzwNkMMbIgxbuh35kaFFthXYm9aZRvH7noFy0aVzDD5rrY5kWfsxq4MAoJ9bh61w=
X-Gm-Gg: AYBFou1ZMIUG9JFR2sBz/GNVgPSCIOAf1543fP2Z0VCMnKiBYj3T1onUXL3tYYjPU1w
	z9mBGDsqDxnvRTKB1VOGHOHd/sQm4tpRM8Zgs86ZqSH9F2hccTGJF8A8SsNqTfXQJpL5idWR7kh
	eAw+xHuSPkCiaZIdgUAIXZBrvEFVlT4nZgzb/wdK/Qolim7kHUXT8CRyM//yz7+P/JWbLfJyeeS
	oEC3q30bVO/4snIy/ONVAOgoxhFq6z8A9bc+0JZ7Y2Mpl7iXOtixu+gHwwaax46sFpwagUcDy0D
	IFNGq+DKwoNML0Z8hQdWUm88yQI4Myp/aL/UBSo3LIc16f2U04KZrzhkB6I5CR9YpKcxA6UeNcO
	aJXVr2rh88DxzIectLCT+sYFB3zO5yjBqSBuseAfJM5on5fPJl3W1h45QViLyrT/nXB5cWSPYpc
	SxtVLBy2oe087OVK7VU+QM1wGKIBo9qKGOjDFsBn2+9SfqnnDRFbS1mMCviqPA3IgQKH1SVG1um
	b/LzQsKMureLTSaqYZCqzH8z6hxgvtJBLHjbVOhXqnA3vd2/AKz1Do=
X-Received: by 2002:a05:620a:461e:b0:939:319f:d6e3 with SMTP id af79cd13be357-93c3661afe0mr289242585a.5.1790264249896;
        Thu, 24 Sep 2026 08:37:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c29e070dbsm392841285a.14.2026.09.24.08.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 08:37:29 -0700 (PDT)
Date: Thu, 24 Sep 2026 11:37:26 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, 
	hannes@cmpxchg.org, shy828301@gmail.com, raghavendra.kt@amd.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH v3 2/7] mm: allow shared folios to be promoted to a fast
 tier
Message-ID: <arVDeAId7Hb-2RvD@gourry-fedora-PF4VCD3F>
References: <20260922182928.2199090-1-gourry@gourry.net>
 <20260922182928.2199090-3-gourry@gourry.net>
 <f0cd5c54-deca-42e7-bc85-1838dfa917f3@kernel.org>
 <arUtcPIw_FaUSPv4@gourry-fedora-PF4VCD3F>
 <e7f48cc6-be21-4ab1-91a0-df0e3a6ec0b5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7f48cc6-be21-4ab1-91a0-df0e3a6ec0b5@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ECA54140008
X-Stat-Signature: eyjpcfgnzmcqh9wedyddrt73rj4ywfby
X-Rspam-User: 
X-HE-Tag: 1790264250-362986
X-HE-Meta: U2FsdGVkX1+GqJOsMKED6IzJPGu4altZdZXGooMaeEFwHDoRL4YlVno2pwLYoaSue8RZlTogHxTdLZnh+8AX5qo2bAFEVLBej83MDRYY1ptfAyn/YeNEcvK9Q1rD3A4cxbDhv94BEzMznyDnKykYna+rtUYzaQKlVIZ2JtBh0P69ndhkxmgfNvj/xH9241cJ37q8xOWNG50X1h/4RtpqlnqH4ZoBd/SAUHnxNuX86O23C3JjCnGQ4D5NDnb6dTzARQ+HJ+7qelpoGiysA/GUOw2Rc6X0FXxAQ7OveRDzPUo/bjBe5nB3ZBG7Od+VpkYqwpyB7Wt/xzurnAb8Pzxyff4+5krL0e9++kSaHLRaKbQH5VzIboR3IkgiM7M30M/40UpDxIkbWELHZVrIUBS1xNWnUGDKsnhH6rEgiVwDJOknarc2q5cX1TmoAs2LjncH6iV+jkM0GHy6+5q6CT+w9+TsC5ho+7mS4683+ec6siJgh0KRpXYamd7KcdXlivDyLpJKM0FkecNl1p8Yv4+YE97e6cvgfNt13abqdJNEae1rS4BFUmHjlT7pSaSrnYdtNnQPLg3J2xlsKCWAQ40h6QM1MVbS1FUkbuW6SsOTDlDRVyIgJ+E2esVWse3v45OdeyMsinZBGhgF6pPNy8yMrJKboOEcBzsf+uA7sJZy2DMCKSlLyc96b89lYLqT/bs9O9bMX9Wp7QOp2BQUyz+Dnekd57cMPvLKSKmSAWiMPd3nGpXU/0OHtRcx48XLuawIPmqrRWVvSPd28l2tLZ/e6HVc5IgrGKsiJ6cnGYuR8Z3ke0t3HX+1MA1uOocBsq5xvllmExutvFokLkzxl2pFal98rlzTMt79O+A/fIptcIbdkOuQHWwPfYBWS1Wwp7sT9ABKAZL/mXndCzjtRTdBNejig3T/BJy28vlH2MnlyidPkSmjU68AV0uzsVCvHQVhiJvy+O4bhx92KhCrlFQ
 NKteEPDy
 hlTls2Hjw6BtapVYcjAknQXxl/c5+mQVh3yXvRbXBSCn0lh6XNa3ESbEzoLqVRTR4ka8OGrZ7bYTvYQnqmBcGZSLgcHvZ3Hk13XP12DwEZB0HzANe9o1mpA9GBKwQo7Y5NuqG0KB1P9thpJEX1yVicAnlCUaYw5R1617Se2L4clX3pJhHqdHgaD+EqDWTpxOoFSJn6heBWR36NSjeBUD4uQCrtdTcx23/Mft/f6+TdpwiM/KzNSgsu0Rl15UjPLCLT+5YuHH/Jycy6SMd0YF6VnVJ/5pite6FcwUWLVeo27qya5cWFThQgMOCKXM9xL6VdxiyQ1/wUookTdXVOx39vS47LPCy2jKzp71rxOu1u9MJ0al+Gg3t9x0oyefexLzC4wCXklgw86AA95CRvFY7Nu4A8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 05:32:22PM +0200, David Hildenbrand (Arm) wrote:
> On 9/24/26 16:07, Gregory Price wrote:
> > On Thu, Sep 24, 2026 at 01:59:15PM +0200, David Hildenbrand (Arm) wrote:
> >> I wonder if a better name would just make the comment above (about memory
> >> tiering) implicit and make more sense of the sysctl_numa_balancing_mode &
> >> NUMA_BALANCING_MEMORY_TIERING) check.
> >>
> >> 	folio_promotable()
> >>
> >> 	folio_is_promotable()
> >>
> >> 	folio_numa_promotable()
> >>
> >> etc.
> >>
> >> because that seems to be what we really test with both things combined.
> >>
> > 
> > maybe:  folio_numab_promotable() ?
> 
> Works for me if "numab" means numa balancing :)
>

Sounds good, i'll let this rest for a bit before spinning a v4. I think
the rest is pretty solid, but there's one other sashiko thing i need to
think about whether it's real or not.

~Gregory

