Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A31CFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 05:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 225E26B000C; Sun, 23 Nov 2025 00:03:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD706B0062; Sun, 23 Nov 2025 00:03:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1147F6B00A3; Sun, 23 Nov 2025 00:03:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0162C6B000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 00:03:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95855140AB5
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:03:23 +0000 (UTC)
X-FDA: 84140678286.06.8657088
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id C41C31C0006
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 05:03:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M4yI1jdd;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763874201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AybJ5UMIELXHMKkOiZS4P/7hCmalbEtDzgzlu8wV6aE=;
	b=N7vxq5HD8Gzqk8uLnGQ3rrpboenv1lL8ehDZf1b4DziWRe71CjT11sdAtEvPpHbqmgt7K+
	AQOm6fkRLQSdcEOmJ3c1i7N1pPZW7eOQ68DaPD8G2WVT4Ov4oqY2IaVmy+UhRJPo/sai5R
	iELfT5UmB0EE9Ehj4parz4JH4h5FO0s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=M4yI1jdd;
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763874201; a=rsa-sha256;
	cv=none;
	b=RVlVKKM6SeoN64VLmbCaF8ohg6k9Bm8lNvDfPYqQ5wzsQ5QIIbbrJ2+YJcsD8H8ZBpuwZP
	pEVqs1Khp5FO22xJig6XK+QjV1ZcKOzldJ6z49RFaf/6hMzDWQKDHb7Ny7i6yVFndv3jI8
	8JAb+I1S9x+jSI3wcOotzC4/B+iS6uY=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-640f2c9cc72so2501989d50.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 21:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763874201; x=1764479001; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AybJ5UMIELXHMKkOiZS4P/7hCmalbEtDzgzlu8wV6aE=;
        b=M4yI1jddDK8+h0xoWJJvFqZge3wLDmG/Ed7LhoKbAIED4+Rl3IqrCblnuqPRLwGF4Q
         5yu2NAbC+qbX/SS5wpfx9fQ+Aj3zrR1kB6eSGog/gdmLv7j8zz1jg8Fd5bwaMEgayFWs
         2ppFgzmAxVPHigAZ8O6Ey4vXiLstXB1srLzCs2JOY9hto4kLgt+cxmcfHsimSyR/Mkc6
         eTfMnfIMa7I8waoVhGNgaJhMAU6Xn8tCkYAdo8NyNiqRILkClKNVMwjFpaFL1XB6ZA6H
         2EOtVWgJ4RBL1qxV8Wgk86DQoAx5ZJ3BnQYGfghSGLOA88j0aLERax6oIJc2g5Q4NoOp
         qj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763874201; x=1764479001;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AybJ5UMIELXHMKkOiZS4P/7hCmalbEtDzgzlu8wV6aE=;
        b=lewhtubrj4gDVo2vb0cegpLL5Nyb5MWqU7bbqXdH3DnSWEWcjEIPJtrNtSRfIjJfA3
         qpns7G2JG/I3i8pchLwOJ/+Zuw9IDveaYTyYflsQOeMTdbZv8TCT5oN1cQ/dAK12zqnD
         iLvfR2jdDu5IciyYtoDoFfQnyCdCYKStWM1ruQTiXIgcX74dXcmN/7dA6Q4mS6D5EgMZ
         6wx9PrAmMnOZ5HivmG004O0KTWYSxFZMSGvI6rbS2EI5Kr7rlZFnJnoU7ojJEfUdnHpG
         T5MUGkZ7+pCQmJgYBI3PvyPiQlrU+xOxOd9Q1qZOtnZq6Py+fmnhH9za5V95S+fHHizj
         67tw==
X-Forwarded-Encrypted: i=1; AJvYcCVfY395/7WDKMXyG2QTausp+ZjxH9EJKyfvB0UF8HcCqYEP2fjau7ERb/KDrcw0k35+7YQ/W4Nkhw==@kvack.org
X-Gm-Message-State: AOJu0YzykrBiEfRPISsGZBocyV0Kdt9pNGwqw2zwx0o3bTTib4TF2cGr
	CMMnZspZJb7ylUmpDF7zwwA3njkue7pkpWDrp/VQLmcxBFF7eOXmcAtycxxKgo+sDA==
X-Gm-Gg: ASbGncs/wyLUoyydWO2ouEbuzEsfkld6Z1MRQXnXjPoYnX5WDwe6PKmJ2F894e5mrwb
	kORINmMMOJv7g34XX40kvYVHcO/uzlzc53JavMJ/DpUNT2/q40w5+880o/3eUOmKM9SVfNnaXpU
	wmstYk/ktTpx33vYfx1s+TLuHzKADaiVqlzXmDkSe2Ha2sftgLMu6zndbUb536RHjioXcXrOxJ3
	0ik0qXDCkBPOFbsgayUNC7gisHpbIindIaUhtR1NV8FNa0TA84pJZGVVkhv/K88WcBXAYYobZ6F
	eAuWUr0UKBx8D+nZmA7kZ8REHffL1hEYJ2pBerDNCUKuUA7B9x4HVwlogAz++f12uU4qATQ5VGY
	HYRmlTdR6uM5+8dxKL/3brbkwL9o/JkO9iYDaJZdhcfrbNEdJFtG1l3lKvxDk29JQZUPrQqJzR7
	ZoBJvsIRSLJH3mN0hZt6yzjXbt9Zvv242SM4VzfAnL7dpEpZFFz9va2nyeJOdy/quuRqHXBdE=
X-Google-Smtp-Source: AGHT+IEGYdrSAwd7pdkxvSFlcS2lnDuIFTNgH1d7JgF0TaanuJjWvyfi2Xk5mNvHe9lUCvVeN+6cmA==
X-Received: by 2002:a05:690c:3391:b0:787:c18a:189a with SMTP id 00721157ae682-78a8b47adedmr122662667b3.14.1763874200410;
        Sat, 22 Nov 2025 21:03:20 -0800 (PST)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a799410e5sm31505917b3.48.2025.11.22.21.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 21:03:18 -0800 (PST)
Date: Sat, 22 Nov 2025 21:03:07 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    Deepanshu Kartikey <kartikey406@gmail.com>
cc: hughd@google.com, baolin.wang@linux.alibaba.com, david@redhat.com, 
    muchun.song@linux.dev, osalvador@suse.de, kraxel@redhat.com, 
    airlied@redhat.com, jgg@ziepe.ca, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, vivek.kasireddy@intel.com, 
    syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com, 
    stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/memfd: fix information leak in hugetlb folios
In-Reply-To: <20251112145034.2320452-1-kartikey406@gmail.com>
Message-ID: <a4319c8a-4e81-00de-f184-844348d85681@google.com>
References: <20251112145034.2320452-1-kartikey406@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C41C31C0006
X-Stat-Signature: gmsdkbaqhz1hx8xt5e8mphkoaadaphjx
X-Rspam-User: 
X-HE-Tag: 1763874201-517714
X-HE-Meta: U2FsdGVkX1/MTw795nGpVu5sCQTQyLZELJTTdaKFCYpYOfh6VFTE11cg8WCU8Z9v/Wz+sT2SdwKJwT3OUR9eLhT/ry+RpqapulmUeG20G2ZRv8yQrh38TY7pNf+erdARCpHhy5NUDYS3Y5Pws1peQQNGb0d2DKE975ym22zQ9KuqKDC+/TLCdtkqCgFumnc/0C/C9Qt397KX2LLaGE55qEKDfoOYbIj9pjbJL8rVmkSF4AORiO6tw++MTBIKMOCkOr6OTj2o9RGe4we9M0xnJjieZXtOBvYatKJ57scAGYuIfcS6brwdxSnVHTskrUp5VrntwachceovNP+D0W9HStem4V5nurG04lezkfLOnjqTfHCy8288hNQA+bEWMvIsv36QYR16OkmFH3u3jFwXU5615s7La6W4F3d34k4WaQzItSvLUXH0eQNuzh4CcfE84twROrShWGhfIWcQ8yFsXi6f3WaftMFi9JsYFSvPwlYxv9GAfprl2f/UlSOP+88kTHXpCXq0+rih19VyS/wJ0DJhA5QmkDnNsVfC3bGo/gRe1zUaO1NSYtbAwUyMtZSqWYniJ254r0ra+605qhNoHbTLNxX1jErQbA1WUHbYfiO8ICw3UOxXQwtG3CYh7UVwKK5oiTfCFOu/EIeK/dyx/SH9KrFfYusNFCUeK0Ratz/T1xW69wvFdrGjAZ3f2VciSYtq7yG6bOSH1korH5qN+GYYXaClBmGkvWu0QCDSNbH5QlBCOeTOztbPPQp0q3+rbKezGpRmIA+ZGTopwvvFLCnCtEpUj2vaNMxBvEzIcwT+yrDsAmNZ3cUbiZ7+G1TVOz4bWiSpYfLGyXn3bEUbcTg9lNP89YeWJKgpeYrbUHVCrytxuoTpckKka/Uls4SyAbh/Rs+56qEji2sGQHGjl9YfcPVSzLWRAiT7+JWRhzUDz1IHMPGbqSurNCIzO46UwX6+1OT0bfJoSNqeU4U
 s1sWiHpl
 ugVPnpthK5GlcQCxqnpp4g6bWYNvvXPB28z1+5P5qv2Um/PRczf/92hqHBYoKzKexAtuIXpwcpYwev/SSEczIKFHYxnb16Op7L2H/GD8WQ4Ohh7F2q2teW0QKgUiVRqgxL50RMuPvIQlGD9D8iIbp2AbbDWNkdSfeQle/gY4s5kIey5iSJCvKTIb39fVlaryp58XRLZUK2Wk0DGh7Gc8Xcv0v1a7NCP9JSyaij5lZ1y9oXZQBhMOqMUo4TCWU8f9Xb7gfHg3fcUthR3BLt44jVCDvSjETbjdnuZlZ9xBfch3oYILNkr7caRTg0+zMhElHe1gQ9HJxMlhU913YsXGvezjSJ2BiOyTbTpSgvaCncD/fEZ3EL6Mec5qVITiz+0MPVwivIFYo1tQnROGBbgMUyWWTTFBKggN32gt0rVBgLCDhOIyuVwWHxMJSlt0QIfCb0IUOl0hD1la3slu/Y22x19ktTt5f8tYQmou1ohDD0BCLnnMKa5ZQWq/feHv2fP9jlINAn+4am97pLi2MrLw+TAINrVonKpvObTsXJIIYs3HVrTepOdOR9xFu9iqMX+N9SS0XisylzPPVWGz6cGK7Ikovv2R8tdWTAExZcBMIJVPn7UwgcO4194xcO3muTg+R0dUv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Nov 2025, Deepanshu Kartikey wrote:

> When allocating hugetlb folios for memfd, three initialization steps
> are missing:
> 
> 1. Folios are not zeroed, leading to kernel memory disclosure to userspace
> 2. Folios are not marked uptodate before adding to page cache
> 3. hugetlb_fault_mutex is not taken before hugetlb_add_to_page_cache()
> 
> The memfd allocation path bypasses the normal page fault handler
> (hugetlb_no_page) which would handle all of these initialization steps.
> This is problematic especially for udmabuf use cases where folios are
> pinned and directly accessed by userspace via DMA.
> 
> Fix by matching the initialization pattern used in hugetlb_no_page():
> - Zero the folio using folio_zero_user() which is optimized for huge pages
> - Mark it uptodate with folio_mark_uptodate()
> - Take hugetlb_fault_mutex before adding to page cache to prevent races
> 
> The folio_zero_user() change also fixes a potential security issue where
> uninitialized kernel memory could be disclosed to userspace through
> read() or mmap() operations on the memfd.
> 
> Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/20251112031631.2315651-1-kartikey406@gmail.com/ [v1]
> Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Cc: stable@vger.kernel.org
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

Acked-by: Hugh Dickins <hughd@google.com>

Sorry if you were all waiting on a Ack from me.  We're agreed that
the comment above __folio_mark_uptodate() could be deleted, and that
it would be much better if this code can be moved to a shared home
in hugetlb later on; but for now it's more urgent to get this patch
into hotfixes and on to Linus - please Andrew.

Thanks!
Hugh

> ---
> 
> v1 -> v2:
> - Use folio_zero_user() instead of folio_zero_range() (optimized for huge pages)
> - Add folio_mark_uptodate() before adding to page cache
> - Add hugetlb_fault_mutex locking around hugetlb_add_to_page_cache()
> - Add Fixes: tag and Cc: stable for backporting
> - Add Suggested-by: tags for Oscar and David
> ---
>  mm/memfd.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index 1d109c1acf21..d32eef58d154 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -96,9 +96,36 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>  						    NULL,
>  						    gfp_mask);
>  		if (folio) {
> +			u32 hash;
> +
> +			/*
> +			 * Zero the folio to prevent information leaks to userspace.
> +			 * Use folio_zero_user() which is optimized for huge/gigantic
> +			 * pages. Pass 0 as addr_hint since this is not a faulting path
> +			 *  and we don't have a user virtual address yet.
> +			 */
> +			folio_zero_user(folio, 0);
> +
> +			/*
> +			 * Mark the folio uptodate before adding to page cache,
> +			 * as required by filemap.c and other hugetlb paths.
> +			 */
> +			__folio_mark_uptodate(folio);
> +
> +			/*
> +			 * Serialize hugepage allocation and instantiation to prevent
> +			 * races with concurrent allocations, as required by all other
> +			 * callers of hugetlb_add_to_page_cache().
> +			 */
> +			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
> +			mutex_lock(&hugetlb_fault_mutex_table[hash]);
> +
>  			err = hugetlb_add_to_page_cache(folio,
>  							memfd->f_mapping,
>  							idx);
> +
> +			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> +
>  			if (err) {
>  				folio_put(folio);
>  				goto err_unresv;
> -- 
> 2.43.0

