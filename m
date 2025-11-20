Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9D3CF64A0
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 00:49:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9626B002C; Wed, 19 Nov 2025 19:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76A446B002E; Wed, 19 Nov 2025 19:49:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6802A6B0098; Wed, 19 Nov 2025 19:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 586536B002C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 19:49:45 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF65A13B31A
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:49:42 +0000 (UTC)
X-FDA: 84129152604.01.D14771C
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB3CE140008
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 00:49:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZyYNNoc;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763599780;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFzHXxyk6we/pBImLIWglgwRBcWEEHpcqfaS4xxBUvQ=;
	b=wDlUY30jR9geC7C4x1CzMJhnd2J/Fq346FL4qAvtVnl4gbpJQcMhhWNUrd5JiqafAN/Njl
	kXnAZv+3jg1QD7ZoZoCmwY/joRyGf4JzzneZAx0D3Uv4GY/D+krO1qC6zheb4Nan4TJySW
	F76VOtkX0V40Q0LlGClVSalj2HHjs/4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BZyYNNoc;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763599780; a=rsa-sha256;
	cv=none;
	b=6/y18QKlQu6/VqB0BUWcvZp9kpW3ymDKeB+A41oZ9uzLMdCJZif2oRggQ7yK/4qBFDsYjr
	/Cu4Ajm7aa9ZiXlhK2aEB+whF76V0PeirzsrlaBi+He/ykiKxmjeS+0nDP46WmM10CUij8
	0wRTz1Ls/KI6Yv/k9i5Z3VOb9yxkmo0=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b472842981fso44922366b.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:49:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763599779; x=1764204579; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GFzHXxyk6we/pBImLIWglgwRBcWEEHpcqfaS4xxBUvQ=;
        b=BZyYNNocRC+FmKyjdMgqKdJwAZtwf+nFXUxONwAFVxbm2UmihTvMruVeU39Mvk3pK8
         ZoHuOiQofml3Ay6owtsX8nmkLb7guiFgG0KaatS0koJmfniqaylM06GCw7X1gpoEVUS+
         KT8jKoOdlFq3TNtwi3ZABdIsMGPLuzIssbkZ9Cijcl03Y8OcRjUZBQ43NzOgw91UsGQ+
         MbMWufVR84aNB9zoUuvq1TPj2nPhJwsO5ryRDiQwP/j2YeN7tSVc2cg2A0ke8pp0eGVX
         92MmH+HZJx7WDW2SkVfQP1/8J1Oa8GW+CNIDS2AFWpuYpToFxrkG8sgKp6C5ov1LfYn9
         JVIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763599779; x=1764204579;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GFzHXxyk6we/pBImLIWglgwRBcWEEHpcqfaS4xxBUvQ=;
        b=VyBxF2n6BgIr9lB89aYSyeK8JdzCs+ueu0mfOEyFzzprYmZWw6xQVtx+T7e1BDBMeZ
         2iidMPv7uDepFRLdhDEXmVgn5sUFI2t/ug7L+Du6/RfEF+DvHnX+LoGy9N+XBQ4BTXhM
         G7XlLAuBTLPRZXB4IpaDsRcXYcNC2OMK4NS8mndhZ2Whloz0EhNLD4hd3krB1YwGopNw
         GNwJZtiBibf39fsnXMpSHQeYg7n+ZImVbc7eJ9n4DUX3tDf3+vwr4J1b9E3DRIEUdOJI
         tsJyAYqmJGG1Sj/+T62a710DYzpYHyqeK8a0nr7p3xdzwF6HPWMMv9CjSSw1r1uGU6eG
         +5QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSeIpE+YPqHrOP+3I6BSrOAr9sgFN+S0vzjSpELfDVfSrXCY7Q3DVtWcd1hRwYln7ICtya7hAf8Q==@kvack.org
X-Gm-Message-State: AOJu0Yz24sIOKgZpw1svu7WgaaaPXka6UbUpJii0ptpya7NjjzKLyvdp
	nPgUuMnubLXJFvEBqqUdrscd2WatlyCuVqPUAzj97QvpgTEuH0jnbvhZ
X-Gm-Gg: ASbGncs74H0Ihs/AXSwfcX3LJ7D4Oh7xuegsvCvOQRMdg6eVnaTk4d6o3w9NtCmoNAJ
	lTqisopDHKAeMDyKZ4LHKbQuaqMAkUT+CmWUbdyORDHjbjbOEILBfTCmexRSHPxhQstikg5VFkn
	SsygeSuGP6jQyJ/lQ5xmqmUNkn4w8k3f3qwlKdDrqS/2LzWRMRWZwx7UP6Q+GRaL0MCNzUn7QkH
	FK7AeYqGaNgbxhf3Nvt0aQa6DKs06moAZlMImf1XXNKVbpnDs3yTJ+Fdouke6TodGkeqS5IzicQ
	H0wNw9vjrKKbrBZH8XogR168ws+d0o+t5bTK/1tqhu2iMsJw8vPdXJfZIcxkXHrIaxs2FUNQc6X
	3ifoPFbkHzWKCK6gI1grKi4t5LQZm3kNVPrSjO9bKj13P0KBnIpce3HggEnM2FXXgtUl4YG11hM
	wUIQgJkmqtNCYMxQ==
X-Google-Smtp-Source: AGHT+IHpPW7Sc9vCqGKgvv+ArrMlVJXYKQRzM7WdUX5uPBrdUZ9D6nYP09kf9RuD6MHojf9jBsaXlQ==
X-Received: by 2002:a17:907:2da5:b0:b46:6718:3f20 with SMTP id a640c23a62f3a-b7654f300f5mr129118666b.48.1763599779148;
        Wed, 19 Nov 2025 16:49:39 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6453642d3ecsm797235a12.17.2025.11.19.16.49.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 16:49:38 -0800 (PST)
Date: Thu, 20 Nov 2025 00:49:37 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix NULL pointer deference when
 splitting folio
Message-ID: <20251120004937.lkczokv5mdo6dy4u@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251119235302.24773-1-richard.weiyang@gmail.com>
 <20251120000312.xasxdzmmztvp4spa@master>
 <20251119164650.e5ac7e3b5fa6062016652149@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119164650.e5ac7e3b5fa6062016652149@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: AB3CE140008
X-Stat-Signature: t7hsnt5at4k4jhmogxygr9eek81psgqk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763599780-523833
X-HE-Meta: U2FsdGVkX19BQHNolDJdM5nB1VRINYi0XOiuZ5wg3kxyfJKpugv30+Unf65YczQoMDUwKyhldM0qYDTRyrKFwuVq7VCeV0BJrGD2svG7Kfu21gb78y59sC/kubtgWne/9+hUCMAL9g2m+IwlLdg/ACkKsc2aszwyYSq1H3/yDV01oIv0PMw5ymllSK8vQ+HWsa2COY3+UliFgv78biVcvk7x0w4Uby4/3DOmXKUxKc0vBITomJaL6q1D7MdL8Jj0iKVkhPn3NKK5+Nf+UmXxVpKbHvDZMgFfsS/SpMF9EMySW1Sd2ZWRYEVnujMo/GxoERgC0MfAsBB3wPj79HgcxzZtG/34FAduL5WWPJxe0iUM/4HXq76dXbD4Kvfwr6wo2Qp5Fpu9tqb2B9Oer551/ARbDWVRk69tk6Rl8LIpgy/qNcnWDKgv7qhUXgwh6Thm9RPLvR3XV4bPljHK7POCaZrKmRDAVh3z/HfbI+eftD6Qe2as44I8C7jPZDAQJtvRus/76hvg1y4fkT0PGR0divrdZvTDEKekEB0aCQLdNQdQ0fGzjbR0dmC5C0igIqpzJSorMH9kTPm/sF1QY+gbhsfpE04Uq02dMY78ahprufYu06b8tvnaLxTpW1XRSdkkWpzNzMmkqW3NtSpOIgXoK4TPg4r2vmnJHcmxWh5dVRm+fu3ZGVZSDK48Uwe4swjAU4vEsNFg+lmaPYJqiuZc5KH8ir3AbzM5fEspQ2XNHNRxh9eqUenOES6P6fTMlL0Ku+mDHNKc/PfzeOUvBvHWtmqNKQSzVYt0dwmPZQPfREalLcGjsxkC58jOa1bcmCsqIE3oeBouA0eWqA7Lz1meQc0J+ollfUi/wdCsL193Jt4uaEgvE2D379d/0p97Gd5inLRY/rLNS6rjj4/eMFIyiPfBT1wHLUzFTqFxEbDjpIikc1AA3yzQLtFhSrqHVjXbUIuKFTaJ9OBYXjnjf3n
 MQKpcdNM
 MyXD+zz/FM5ZDGqq4b7w/jcJbxZPVedEsarVLvAWMoe0il2LOXdWhhxgoxanTB0IHYfQeiXhTdHSCugJs0IL9yHVmpqBwigXRrlvSt9t7G/68ZwcWzgh3f5dr3ADEnD6IlgRBXfmYGO+BUcvD1CGD9vlWIcL0fQwYvhUPWX5IPb9x2fw0pFONY7BPzZ6fPOnaJxw2nuJmuiHaahyH2K+x5jscVDneN2V+zMxM+sM0ow+9oZb9T4myP3FZXa6M9OCvOPgJ6ZKE+oXuvdqhg62jhN3NANxFJBOUqjcLP45Jr4zG2oryiTPwh+AY3jVd7pl9TM3jwGNdZKyMU3YkQUjiQxfupUBw9DdUQ3wE90K8U7aPFrCNVs/eSfbyjmzY/feNk0uf00OjiwCsGf0nTtbH87TNR9JAEPzSaT6+3JLVE/KcMD7I0N0aGA4mOD7gNh3q11G2nJMjevvXlUmcfLqMeXF+N0iBZgCId35nI8TXR2k4RDI8QUB5nX9tFASlHV25l94U3UUtnIidQ7rRwEfhkspl9dUnlP5jLXFKqbVDqluB5iG01h2NupryExz18BGo8/nTsu5ivMGAAF0ITS0SLiBT01OyEIXMiRq5R/MFQ00Nm8GqEkzdtSPH0AeDxDCrhprDt5vhgPMyamv+TOiQooZRQJllCouyivEqmATboEapIpErHDpg22p8xtVMODpMJp0K2Vh9Qnx6/Gj/63XJiXGCpE0iHFYmK1c2apHLFMi3gXQ3EU4nMSo0aH6SMoud/k8DE7ZT9162JJX9iFvy9R6ea3DSX/axu8B+NKa9PRqBNtX2bnbqx+USqmbyDfymFSMqBIP/uVDrXYovNcDHpRMM0/Op+j4KLqXYTQ9+E0/4AO6DCTUJ8qjT3SOwmiKhWGJT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 04:46:50PM -0800, Andrew Morton wrote:
>On Thu, 20 Nov 2025 00:03:12 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>
>> +	 * TODO: this will also currently refuse shmem folios that are in the
>> >+	 * swapcache.
>> >+	 */
>> >+	if (!is_anon && !folio->mapping)
>> >+		return -EBUSY;
>> >+
>> 
>> This one would have a conflict on direct cherry-pick to current master and
>> mm-stable.
>> 
>> But if I move this code before (folio != page_folio(split_at) ...), it could
>> be apply to mm-new and master/mm-stable smoothly.
>> 
>> Not sure whether this could make Andrew's life easier.
>
>I added the below and fixed up fallout in the later patches.
>
>If this doesn't apply to -stable kernels then the -stable maintainers
>might later ask you to help rework it.
>

OK, got it.

>
>
>From: Wei Yang <richard.weiyang@gmail.com>
>Subject: mm/huge_memory: fix NULL pointer deference when splitting folio
>Date: Wed, 19 Nov 2025 23:53:02 +0000
>
>Commit c010d47f107f ("mm: thp: split huge page to any lower order pages")
>introduced an early check on the folio's order via mapping->flags before
>proceeding with the split work.
>
>This check introduced a bug: for shmem folios in the swap cache and
>truncated folios, the mapping pointer can be NULL.  Accessing
>mapping->flags in this state leads directly to a NULL pointer dereference.
>
>This commit fixes the issue by moving the check for mapping != NULL before
>any attempt to access mapping->flags.
>
>Link: https://lkml.kernel.org/r/20251119235302.24773-1-richard.weiyang@gmail.com
>Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
>Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>Cc: <stable@vger.kernel.org>
>Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>---
>
> mm/huge_memory.c |   22 ++++++++++------------
> 1 file changed, 10 insertions(+), 12 deletions(-)
>
>--- a/mm/huge_memory.c~mm-huge_memory-fix-null-pointer-deference-when-splitting-folio
>+++ a/mm/huge_memory.c
>@@ -3619,6 +3619,16 @@ static int __folio_split(struct folio *f
> 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
> 		return -EINVAL;
> 
>+	/*
>+	 * Folios that just got truncated cannot get split. Signal to the
>+	 * caller that there was a race.
>+	 *
>+	 * TODO: this will also currently refuse shmem folios that are in the
>+	 * swapcache.
>+	 */
>+	if (!is_anon && !folio->mapping)
>+		return -EBUSY;
>+
> 	if (new_order >= folio_order(folio))
> 		return -EINVAL;
> 
>@@ -3659,18 +3669,6 @@ static int __folio_split(struct folio *f
> 		gfp_t gfp;
> 
> 		mapping = folio->mapping;
>-
>-		/* Truncated ? */
>-		/*
>-		 * TODO: add support for large shmem folio in swap cache.
>-		 * When shmem is in swap cache, mapping is NULL and
>-		 * folio_test_swapcache() is true.
>-		 */
>-		if (!mapping) {
>-			ret = -EBUSY;
>-			goto out;
>-		}
>-
> 		min_order = mapping_min_folio_order(folio->mapping);
> 		if (new_order < min_order) {
> 			ret = -EINVAL;
>_

-- 
Wei Yang
Help you, Help me

