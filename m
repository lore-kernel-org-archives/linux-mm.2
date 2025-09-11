Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5AACA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 947D08E000F; Thu, 11 Sep 2025 05:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F8348E0001; Thu, 11 Sep 2025 05:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF848E000F; Thu, 11 Sep 2025 05:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 653718E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:21:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2910B1A041C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:21:12 +0000 (UTC)
X-FDA: 83876425584.18.250F6EB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0795180003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:21:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EYIyv6sW;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757582469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wx2VuKFN5l2ZKUiBY7O9oVouFRhc9i2w8paZkQJvRtM=;
	b=IMfR8on9Ts2k76H+Imue5G47A1SnFBduxYhtOt1ryAfU0v7FkvfTY0BzcpZIT2+7irAIDL
	oRhM33z8Bb/1TGTTAgtDY0kXeY3bmOyzoyPGu5jDZtWukNtf7bPzobygHxnCD3x2WHLXw4
	NKRW1PgmHEgIrauj7I9zfu7uMDoYjl0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757582469; a=rsa-sha256;
	cv=none;
	b=7TL/lMd5VDit0ogq+6aU7ai9YKDcbzVX2w0yLwcBWvIFs1MxtMqaLpw0bQO8h2ouq/zLyO
	gW3HkDzOLswTEHdodIE3u+RZ3Ngmwm1+xCCIbhG1Ftpx8HaG5fTWqqj/Wu36RTSz0jTkZz
	T2grLnB2hA/5oteew0SHCWozgzFpiHg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EYIyv6sW;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757582469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Wx2VuKFN5l2ZKUiBY7O9oVouFRhc9i2w8paZkQJvRtM=;
	b=EYIyv6sW60cP9zjjJ/xdw9Ic2sBdDK25T1QxL+u6cotKtAbEs5rjPHZnQdNGVcsptbuBP9
	LKRLposkfiUIgTnxJ3uftIpTJMfa1uAwZg+5sn5vTN/Sgn75tONgoq5lWzXmRgJkzkQcot
	xk8q17CX5D8tyDoFcufofIm+tvKJ2SI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-0C3fOxOhNc25tB6HRUBUJA-1; Thu, 11 Sep 2025 05:21:07 -0400
X-MC-Unique: 0C3fOxOhNc25tB6HRUBUJA-1
X-Mimecast-MFC-AGG-ID: 0C3fOxOhNc25tB6HRUBUJA_1757582466
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3e424a186fcso302942f8f.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757582466; x=1758187266;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wx2VuKFN5l2ZKUiBY7O9oVouFRhc9i2w8paZkQJvRtM=;
        b=LLkLNtQt/owP4oVV/c7FDLoaGCwcEkCd1ZJ+s9a50N8gVKJJWwK5QhNLUHOLeMtG3m
         OPV29VPrpJAz0J6rFBvB8z0AlINW2i/JRX2nhuW9HqWubdu64jWt6qhf92K8LgujZZSN
         1On8g7igKzmbFqtNuYUs5gVzKZQOTF+twNL1r2Rqo2DPLBov7YxabKT0kOg/qIkVyKkN
         pf2Fy5qH0FbeGTGFB2r9v5bDBPa0yZGmozmkl+2IFnuj8apHPIhiayqWKdOrT9TNMa/L
         zYCc2BvG+2FH9K32BTRZfJP2yfM6RyjIROnIQ8TICWWyVsGJb2XsV8i/F4muC/zbdsGt
         /CLA==
X-Forwarded-Encrypted: i=1; AJvYcCWdMNOHj89O5+TWBDBwcJv8HWnCqsIv3grO9JGU9IRuc7WMJzjYIJDhYeA3UcPgFZICHPpEc3TcYA==@kvack.org
X-Gm-Message-State: AOJu0YzoArlFKQeexbeEEGLaFAxESJQxhPqa29ZeMmt7GV35LT6GMERU
	QGLABXksGuCaO9YgN4QoBajw/hO/q0TsH2ievq6heZFfKZizEDtOqmy8OkrgApeTXac09+pEHrY
	bjYHmmGKOLNCM4XQSTDMILEuFhyp6zOGejh4wfpYetlfPJHKRzIcB
X-Gm-Gg: ASbGncsSVoZJtTD8sR14/tKJE3MB6fLuDBPkc9pzcQugG3+eNJr5HxLC1pCmaMsLikt
	sl9RYI5eV9GJlShj24uet4cn94SMm7d7bhWlMPe66eZrMgPdoTzU3PwVy46hdakrnwDDR2EouKi
	BHa+9jTr/1beIYxH64v8ee/tcYZAVoLTS7KeK0TLAKqRmyVNyG3O6e+Qknzva4+e9idXlIek0Sc
	NSzly948Nw9E78+IC7ZOf5ICrqozNdNYdOPikLjbHpyfIjFXckmSz30PjW+eLU4SJxT3Yjv4PvB
	uxBG/fqGSC1zb/ELOtRqbqQeJ092Hi9gZBL1+DjTCtGYuv751EeMi/IX0Olh+hQBSbC95E6QYNk
	ARUKxtAOZsmo5bbdl6R3CkEt1SjLbpTCa9ftf5/wr4hawgEzTJG46M0I4+OLxmyJiDOU=
X-Received: by 2002:a05:6000:178e:b0:3e5:4da4:d883 with SMTP id ffacd0b85a97d-3e64392d44fmr12834678f8f.32.1757582465813;
        Thu, 11 Sep 2025 02:21:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHyUavJICeyqztmPEQghHdLocWjpJqN/HeJo81P2eWSfishVTQf6+EKdsobdy2aaseNe4rzw==
X-Received: by 2002:a05:6000:178e:b0:3e5:4da4:d883 with SMTP id ffacd0b85a97d-3e64392d44fmr12834646f8f.32.1757582465337;
        Thu, 11 Sep 2025 02:21:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e760776badsm1739785f8f.5.2025.09.11.02.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 02:21:04 -0700 (PDT)
Message-ID: <e58b16ea-3018-434e-9eff-eb6cdeef4429@redhat.com>
Date: Thu, 11 Sep 2025 11:21:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/9] mm/mmap: Abstract vma clean up from exit_mmap()
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com,
 kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
 chrisl@kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-3-Liam.Howlett@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250909190945.1030905-3-Liam.Howlett@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bDhZi8kSr-y_LabvIhytIH2aYgUPOa329u8MgmzUaeE_1757582466
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C0795180003
X-Stat-Signature: 6ai67fe8kix5kbjnp7x1u9za6yknps66
X-Rspam-User: 
X-HE-Tag: 1757582469-354696
X-HE-Meta: U2FsdGVkX1/ZCtvzwi9e1RETouWER8esYXZrx9eSjfMzPqwEkAA04+oac4KWWP3+CsuRADZirorc3Vvnyqim6zRWdqjUGT4+d21oVDpnnfNnEm8t0Gc/LUxlCdn+mKKVVU/+g/OiNag4R37YmRyYkmpwoAsLW7QM1wroP/9N/IJSsLxkr/GrCs/zOFzfATZgbG9H+faDCE7W3U2l68M2kfcqoCHpQWY2SyKYaFuGHPWWh1erMXXxVTr3AMAEOb74uRVxeAgMOF7mLEnY9zzWcNu0iNnriDFwdPgsTuQwP+eEJw980YKGzfySQdhpqy7XNbSgxzyNUvI3PuiAN55y/BhfoMLS9WAd6xGQusO3TgvikccGr4KsvrvTh5TFjZcdJ+xMxX48ZZjWCtcaUob0VHqrkKVZo8RvXtaWaW1Di40UEn2NAWB2DsmSDHoijc17HIYwvPvtI1RCwHwsCffIHiymhTDAl1YHM03v4qWAFtFtLboKmfRLbQ0cIjam+ZGFC9wEx2xKx3+jXRK3dgDKT3ehRL804qlgUPhKt1B/43iKtSpdpksxmx6/6k8/dCzFKcmSJLLxbXV3JrVtUUsz/AEPyo3ZolICeQIkQKHHa5E3RAtwJ3I5RYBDtyxkovwQZzUACNq53nzgo8qCsg97qJ155PGxzojluuivWOtI2RdEcupbzm3uqK0yyUSZtsVrVGwNK+Es8MWVHFPnnfCQb15RTfD2T/eIQdpSiho7FJOoenhIUdLsaKAOAj7jCFXFyFjiGsGz7ofQT0zYyZKi2jckFC9kSy8Ot7ru6qdIiUBV0JB8tIOY6n6inz+xv094tNoC37tHngQLETnyWyj5F1xL4Od6jQac7GVehiVqb6/N0Ze/t4n69xkJX5SZ560hCPdWJ6fvI/iiPtjef+p5svyBhkq+TJAJlead0er7GXpksLdTQYA1QD22BQAL67G7oZjdIgJEpGqWkr5K1h8
 WFo+SnaG
 sGRnWZPr4OL64AtMPu9bRSzfiMsLw9q1X8OZ5gdxdhSvgCnWQyZxrgVjjDcjNZz8TOTb5BY9T91Ls9jJarVNPUhMtKq9G+JEy1n22wO1eNoT77AOoChHOLfM6Jqg/KhMF4oxDp82wxczY11ohNe3LwiuZNSOra+0gFJLMGU+U93ylLPpmwtIHWDY4E+ZZA8LPEpj7HnsYmA+1+XrNk8Y9eKqxKXOPfHlFAmEicHKd3VfKLFaP/tiNfOdj8N6sKjO8Mi9ujuBm9+CYBmlHG1arFMXhwLEHxUJ8wZIvUVvH7WloG/7TFKwOf0H0ByYZ/XsCCwd3T4mILrJgINKn1iPQg5NN7EpEh+iTDB17/7yQc7UqRJyTKYwkPH8rn2WODDum80sevRSXF5+Dn5fyfiah5+lxXI0g7ylSV4H25gidzpP+tRIWX1NIIiYAXOW8QwlFsfDw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 21:09, Liam R. Howlett wrote:
> Create the new function tear_down_vmas() to remove a range of vmas.
> exit_mmap() will be removing all the vmas.
> 
> This is necessary for future patches.
> 
> No functional changes intended.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
>   mm/mmap.c | 37 ++++++++++++++++++++++++-------------
>   1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index b07b3ec5e28f5..a290448a53bb2 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1250,6 +1250,29 @@ int vm_brk_flags(unsigned long addr, unsigned long request, vm_flags_t vm_flags)
>   }
>   EXPORT_SYMBOL(vm_brk_flags);
>   
> +static inline
> +unsigned long tear_down_vmas(struct mm_struct *mm, struct vma_iterator *vmi,
> +		struct vm_area_struct *vma, unsigned long max)
> +{
> +	unsigned long nr_accounted = 0;
> +	int count = 0;
> +
> +	mmap_assert_write_locked(mm);
> +	vma_iter_set(vmi, vma->vm_end);
> +	do {
> +		if (vma->vm_flags & VM_ACCOUNT)
> +			nr_accounted += vma_pages(vma);
> +		vma_mark_detached(vma);
> +		remove_vma(vma);
> +		count++;
> +		cond_resched();
> +		vma = vma_next(vmi);
> +	} while (vma && vma->vm_end <= max);
> +
> +	WARN_ON_ONCE(count != mm->map_count);

I would just do a VM_WARN_ON_ONCE() here.

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


