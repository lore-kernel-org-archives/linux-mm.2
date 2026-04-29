Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F9BFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D354A6B0095; Wed, 29 Apr 2026 10:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B946B00A0; Wed, 29 Apr 2026 10:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C221F6B00A2; Wed, 29 Apr 2026 10:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B20C16B0095
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:43:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 583711C0388
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:43:33 +0000 (UTC)
X-FDA: 84711861906.20.8854230
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D824C8000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:43:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DZA64DGd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMHYvLIEZUKpZgFTXwdf+A1Vhw+Yb9KxrwCYQMievwc=;
	b=g8CTmBELF6uTigu+p8wrajPrhvgts2AGkvODjpCc5vY/X+2LaFrMM04aOst2c5bcuJnr0l
	epDiCjZWEPJqA1ITilCNO8Srv/SErkXR53rDb5aeU454k88ImJC517As3DWQHqEUxaDyJh
	dUb4P8xnaAgSbO/h1iB95XJ8tGW0Zpc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473811; a=rsa-sha256;
	cv=none;
	b=DVAoUoU7MOEh9KTXZ4nqvMH5eVOS4NQm4SpKVKRqqIaAHwmgIQm3hQlyBKmgRJAk0LdAxe
	pklrIB8lZMAt/aG0tzycONlwBbAd+jvR3ea804G0SJ9HMKxNrKdEAbMi/DwTkXvg7v6fYy
	XAsJrMyKKAuf+Sf26m2LkBoM5x3HqOQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DZA64DGd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777473809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OMHYvLIEZUKpZgFTXwdf+A1Vhw+Yb9KxrwCYQMievwc=;
	b=DZA64DGdgWXti8xJLNZC2ggguxBYSBGuLQvNVgk+rCvKGCFIgFuxUhmDmsKK8H2UaNw3AH
	uJgTOMD2InzPz3v5XkelRMtKexuPV8xEMmvVTw2a9EAM/XXp0/pb76u968ytQ3nSjmrZQS
	DbRf1LhJWfC2pYxvymwp9rQ6ed7b4/4=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-r4Th4ZHCO8Wx0_Xz-5TFbQ-1; Wed, 29 Apr 2026 10:43:28 -0400
X-MC-Unique: r4Th4ZHCO8Wx0_Xz-5TFbQ-1
X-Mimecast-MFC-AGG-ID: r4Th4ZHCO8Wx0_Xz-5TFbQ_1777473807
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-79472373f48so233465767b3.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:43:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473807; x=1778078607;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMHYvLIEZUKpZgFTXwdf+A1Vhw+Yb9KxrwCYQMievwc=;
        b=XKp6K9SHegSs+l3k3tZQme+fec6Kyi+alvKLC+An6+SjwlPgXeQwBf0NXNpQJvF2k5
         HfSoRxcmWZkKG9GoyAuekQE+NGngx0fcnnFc7w5lGGjO3O3XDowcR1hdyuznCg42HtS1
         i21ma/vgBScq/nVdXXLoQKJl9FeG7HqurBzDO9+uYWB8Etae6X4sHBxCIX9o03VG2rLS
         c5sVpifeNy6pmPhavMYhk0NwVpVNJUiI6Vz/Lsk6HQKM5rzM6sQ1s13Jwy8n5O06W1zV
         f2ofC+biran+3dZvA6DwUN/bwUAxmdtc12FAq2pxYlnWDurwDGu65jNn+4MtOG/7glWA
         TfPg==
X-Forwarded-Encrypted: i=1; AFNElJ/F3vVU2LOnnpGwUo9FechXvQn2OgfHpz4LJa0PAGJKWiDT+TXAK1Hr4E2dw2/cTQjvYc1/0dHr2A==@kvack.org
X-Gm-Message-State: AOJu0YykA5dW5P3INHEZBGwuu7Q24n0gxtpPTg96Yu6reL5R2VUxLUzD
	wDrSRAu5AhWr8+5VdIBmoqN61+Sv8YbKtbjw+BDnHgWBWW8Z1FDURf0WEb04S6S/XqUlkHWC6ei
	VmDNe6rszfA4mGmwJ2bc4oCeZ0eQrwyh6HYl96eyWz1hiw180iveOMoGnhI2VvcOD3eki7FV8yO
	CU+KrgqMv6F7kxFTggCiggMEX+SGA=
X-Gm-Gg: AeBDieuyvKWGwcsxa0pM40eCMmRvr0frix0xuHK9SBcNAN/hVoTNFqRs7963IlAS2A5
	9jTL4v9s6Jl+1JR416dvgZK78laKS6ZUB3pOYaqEIbyGKyeKtri48SOy6Bc0CGXIz8DRCJd1P+2
	bCMY6RFhemM3CbNbzVuimkCb9wu8KgU9xmLLb7P8rLItqDfSigTjeWRdUP0gMcEvLSSIuzL+ewX
	YXvoSizPqqfFiHXWpCIAPqS3/glqIwY9038vYAn8fL+peUvAtk=
X-Received: by 2002:a05:690e:d58:b0:658:1e1d:b8c6 with SMTP id 956f58d0204a3-65bfb71083dmr3655661d50.44.1777473807290;
        Wed, 29 Apr 2026 07:43:27 -0700 (PDT)
X-Received: by 2002:a05:690e:d58:b0:658:1e1d:b8c6 with SMTP id
 956f58d0204a3-65bfb71083dmr3655616d50.44.1777473806821; Wed, 29 Apr 2026
 07:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-4-npache@redhat.com> <20260420131549.3673619-1-usama.arif@linux.dev>
In-Reply-To: <20260420131549.3673619-1-usama.arif@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 08:43:32 -0600
X-Gm-Features: AVHnY4I1QOeoIsPtdFMRgostIrIoED-4ANNwkr8mXezmIk-ShLJX3AJsP5h7kD8
Message-ID: <CAA1CXcBSic27LKezu05-MNZ__KgKiOu2o=ftWhfCks33ts6pcQ@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 03/13] mm/khugepaged: rework max_ptes_* handling
 with helper functions
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -VtcM7YVTzPcuUJB1_kVpbAFucYtBTjvrvDI0H7_8sw_1777473807
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D824C8000E
X-Stat-Signature: tqdw1j3yamq4ifrmk56num4bahy9naan
X-Rspam-User: 
X-HE-Tag: 1777473810-66659
X-HE-Meta: U2FsdGVkX19TS+LVOmPcbOztzMrRg0vLh+z8Tf75VSB6wJy69kc90EeIdzIwBaZMAouKtQ9w8f1Dl/nE7NUmo2id38VnGBYyimWmHGQpFpn1eLXnJMLpRqDgGHxijrVSGCpruwM74EG3/kMYoAlEryeu5vpUSFPvcMnyI++8b+5KZoDyxToiCfnNwaETTZ4ECrskmRRMO9n2Jx7zFm5P0GOAF75yr3QiVdOnSFzT3mE2wstDt+DgTA8v8/wggCwea2lo3uXiIAervI/HYXsRIEN+KA/1Mw87ODVWmqaDzO+muUyXOFEGvImWYM8m867nB+yFQKwgJvYH00POgJEnQgUTVrvn/msAqNubsICeii8kPiu6CHpsmVbdS1+QdKyRusxGFZRLPGOylkf6xKaCtVMlG6mdYCZE3+Gcz2dWVbnUunnUIWKKptZk+LlxySNaZI1VESQMYd8t+9lXgmCrIuv+XkSvI4ekN7lWdL2M7fEnTnbDopJApxAdCkle+5cDyXJjXxax1IkPl5JyuQi9rimKAH3fL/KoO1j1jkACF718AvCSHGrFYiJTSE/FDXKLTe7zqa+TIDZxkaIvtoc9qCXZ0arHObkP+UupuvTxORhvoaxuKKeYOguRegNGKQ60aVtf2AZjtK/AM8L6Sti0pMUAYzmexHXMWy96R64maWISrr+HRxV4GY6ZQ/pQZFDmd29MaCrZxYUeFV+2jsUW/oxjhGdHZixYjejYTaD4ZZEKDxaNWUbrKWUlui7ix+DuL9jcrfv5qmS6mgJOehiADzQR1YiHYdwBv71vwl90k6LC7xhHY+4uolvNcTzd3dZ6R1QWux8PgkCz85PfdqJKzXf2QcZDRJNx3V0ewo7kE3+ukOYPPv/KwlihtwW9k6ycQnZpryZNGhZV40c6JSKd60yENkypMtQkczuFBDkvTDxcIkv731rfdRFRcK5//jc2On4RLpElddL8JoTYBVe
 PUVc3h85
 tc/EOl2fHmes41958GV7j55iMI3xQpR6amUfWd5TmtLsRj4n1LZveculqO7jsEq2XHcX3LR+5vA/GoIA+n6DC6eqvTBa7XRaYoYSsbtrv+ZJyAx15/wCL17TzqGcU6+LDEywvtlLI1QjkQR/LwN6F09WpfjmvSoCYC5Y02bw1GBjsWCf7ho/fqmFSM64a6S+43heAZ4AlC7LbfIvQ/siRhhu8ETfForKEZMDEbU6AY91KlQf9NHFhaWYuKhZCOEhxiTvg/jQE5NqYMmtvx5PR2Ge/fsNNTGHPofHlvRVcOBgzBRPoPl0n9rKcAWozkELzNHHyOObookhjD3N0/Ds3l5ZAsNn0Dt8loJEdknvGWLFET2Rlc2D8TNnoLcs0AwTP/jcOSCbJbAunbTyl4EAW+711+RoZjsGH4GMKJ8RR/KiYyIKphXa3xRCaW6sHgdE/zU7Xt5Pcf3vhzOONOB9zKNs3JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/20/26 7:15 AM, Usama Arif wrote:
> On Sun, 19 Apr 2026 12:57:40 -0600 Nico Pache <npache@redhat.com> wrote:
>
>> The following cleanup reworks all the max_ptes_* handling into helper
>> functions. This increases the code readability and will later be used to
>> implement the mTHP handling of these variables.
>>
>> With these changes we abstract all the madvise_collapse() special casing
>> (dont respect the sysctls) away from the functions that utilize them. And
>> will later in this series to cleanly restrict mTHP collapses behaviors.
>>
>> Suggested-by: David Hildenbrand <david@kernel.org>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 114 +++++++++++++++++++++++++++++++++---------------
>>   1 file changed, 78 insertions(+), 36 deletions(-)
>>
>
> The old code re-read khugepaged_max_ptes_* on every loop iteration; the new
> code snapshots them once per scan call. If userspace writes the sysctl
> mid-scan, old behavior reacted within the scan, new behavior uses the value
> sampled at entry. This is completely ok IMO, but might be good to call out.
>
> Also might be good to write no functional change intended apart from
> above in the commit message?

Ah good point! Ill clear that up

>
> Acked-by: Usama Arif <usama.arif@linux.dev>

Thank you :)


>


