Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2C5FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 04:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0446B008C; Mon,  4 May 2026 00:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90966B0092; Mon,  4 May 2026 00:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F5D6B0093; Mon,  4 May 2026 00:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 86B756B008C
	for <linux-mm@kvack.org>; Mon,  4 May 2026 00:02:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B7051C08D7
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:02:04 +0000 (UTC)
X-FDA: 84728389368.03.A2DCFDE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC43B1C0010
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:02:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FZtVZ5+6;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777867321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+5Um6TFBnBOiuOAmXBNCCA71a07CLbH3rgRCp2jTGs=;
	b=jNKGfkeS/yzUfQGWy2dbyRf/rJYbvZRHe5TiQ6V1UCrkY82CyjEEwbdi3ikFOkCgex5L/3
	rtZUF0ejyDKJYIAqAT8tJ2+7daUYcI0YZ4jLfUj0Jl//btuTEtAqHh5otimfb6F66W+gLc
	7T6k8p+XNTMfaEHXVbOj/AQUdN6CjZk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FZtVZ5+6;
	spf=pass (imf18.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777867321; a=rsa-sha256;
	cv=none;
	b=xFh75Pe4BlppbdE/9+GkNCiTWeaebRy7IB4NYnF6DzvV2ub+fjAxe2Y3vIhK0E7/Ob9/dT
	emENZR1+KlXSXP5LctJObxg7qOwHOWQrOZYEg/y8IGsaVUeM7lUIu4qCwi6CtvASUwtkS/
	yRdP52V+y2r6Roz1f25Rwz09THJ4omQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777867321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+5Um6TFBnBOiuOAmXBNCCA71a07CLbH3rgRCp2jTGs=;
	b=FZtVZ5+6D9hakk6rkrQTKVC+0gkXMp4hGqBw8wDQEP0qTTHHv7DtojvTaRwoT+8FaLWrE7
	YzRUepCFi3/iQMrAw10/QE5vk0wiYvJrGFWL4clLRsMEhnHlVr5LWti/MP6Wi3EVOm2D2j
	BJ88Jt8vN8tcQHrMZgEmlaJvlTl78eo=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-213-qJhxrk52Pd-qERDHqGlqfQ-1; Mon, 04 May 2026 00:01:59 -0400
X-MC-Unique: qJhxrk52Pd-qERDHqGlqfQ-1
X-Mimecast-MFC-AGG-ID: qJhxrk52Pd-qERDHqGlqfQ_1777867319
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-7bd5c9e1826so13042967b3.1
        for <linux-mm@kvack.org>; Sun, 03 May 2026 21:01:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777867319; x=1778472119;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m+5Um6TFBnBOiuOAmXBNCCA71a07CLbH3rgRCp2jTGs=;
        b=OiFPeUKjb0Vx3GvB5ssY/hjJngqxtoS5yZq5+nkN+P59QvRVD2ilj2vo5pSqT2l0cd
         vOchJbIly6H6SmzdYpQZODr+kkZwSWuuaQ1mZ4nKAdKdLUoJnzDLhImW5bQ3U3/6tLrH
         qfD/F02WJQ7W2e4mf0MshmEDwgHXy/PWgEiN4kZsBsP+YaAJ12nSk/6t9DX/PYjoXBk1
         TZzVnroyLCIGBXESsIMI6ktOcYcZoSCNAHANzWSdjqACj5OTSzkCTod1nl3Su6vdZjag
         0qPpIfwh6Ms2u3cpBtCsGUdMs0r0dmzbY/mp1tGiMfmAYQy+OCmVmWLjdd/ZZGZY1Rci
         Ubvg==
X-Forwarded-Encrypted: i=1; AFNElJ/iPc8ROFNubTa6/xiV3cZP/UrwK0V27D2ACPJupxl7/yQGLZ1695yghFSK2cFc2Efq9WGAmSITEg==@kvack.org
X-Gm-Message-State: AOJu0Yz1gdqQJNB9XTE/MFXbS5pE96OnXZ7bNlhsB9Mh8qd1e7pV/5M+
	1UYOBhoHPW/xAfc/NnLwvaGn1G3ZWyrYuCCSsVzq9G1P7hQrElk+naV2Zyhgng2yQUh/+324Es4
	bng2s1faO8sUwYd5A4g+yz3RsLnJLbz9TPKsnUI0SRNWSSGvqGwy9
X-Gm-Gg: AeBDieuThak2I/O8J9MbzCjQvSReEqzc7/tBtjJl15tzH99WnHhOdTyoyfXs5OXLmNO
	cOAISpK4zWC/zgs5RqmyviMEWTSDsBrEDh7XoFH0lKuCxRNO4J6rfjL1VjFlb0N2yi5lzM27XYY
	WoU0agBkqoz8UQYVgU5GK7jWjMr1WJg4KVZBXedmwNoa2n160vXKhSJ4TOuYquOF8lO5zpK0hum
	XYPk8mwdfjvNjrxJS8AK4HRepnAPeibHnyxPfsybThV3qOchTKF96AXPM5jRrL4zpYMpQCmfGKn
	Tg1Cc+eRaqap2OnDvOCOo3gBBdZ+nh71V8ZnS4A3BwV6/xrJGfkTzc/2Uk8SzVultlsGeZFIx/b
	kFvAMoa6i7AwRkjWjKyL2wGyJH0ymC4Ru8QzzOzfsUVGxMMqhjVMyx/wWA7wobjcs6/4=
X-Received: by 2002:a05:690c:289:b0:79a:b440:5c8d with SMTP id 00721157ae682-7bd76928ceamr64734327b3.11.1777867318933;
        Sun, 03 May 2026 21:01:58 -0700 (PDT)
X-Received: by 2002:a05:690c:289:b0:79a:b440:5c8d with SMTP id 00721157ae682-7bd76928ceamr64734087b3.11.1777867318535;
        Sun, 03 May 2026 21:01:58 -0700 (PDT)
Received: from [192.168.178.105] (78-0-206-107.adsl.net.t-com.hr. [78.0.206.107])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7bd6654e464sm44456777b3.14.2026.05.03.21.01.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 21:01:58 -0700 (PDT)
Message-ID: <0c385b67-035a-4f66-8f3a-febd68a9318b@redhat.com>
Date: Sun, 3 May 2026 22:02:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 05/14] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429153538.727855-1-ziy@nvidia.com>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <20260429153538.727855-1-ziy@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PYkIcl_BAYSv3VxmvYsGMAfgWIcg740-5Gdb2Wh1to4_1777867319
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sko4mwibbdiczco937xwakmjk8hh4iwc
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BC43B1C0010
X-Rspam-User: 
X-HE-Tag: 1777867321-863459
X-HE-Meta: U2FsdGVkX19++L+NPjNSyjq/cEVkITCXVoOxKgys3kWg8lzRpAanAnnGAuE2bCtbozrU/tJiAjepjT7Cmw7EQfSXk8GA01v/eE/v1W/jwhbEJXxY0oxLvKBtKCcFQnxtwcgsTLXSDtFr9HT9g0iaMvjHFWPjttr5etymoT4YlmOYcpImS322hbK4QkO6Vdtr65XcD4Pa2slFSj9QiUENBF3UjLGls/u7eAMJlwY6DwLy/NvbnN4BPp+Xr3dyuH1DPZgoNMQF2PqP5Wl4Y7dN4Cvxh4oi4AxVsxnPsVjwm3goY97sN5PavPlQC0puNKW4d6pqa3CzN0dc2Y0PXvYwwbs5ZtxbPNxArwnPsclPFNKj6MbkMilii5lO70cTq1cNHIBHZBJoLoVDujArcO2qpK6Ei/rD4qKTnTgmcVMjW8VeiooCzxJ4By4gFmR4tUgeV9rCqB4LGXqLnYReUL5BzIA9XDH9XE9Z5/CA18/HSPlxmuepgwmjj1yuzPF14Hp3nEHf0NLmyXd8gkfg5HgJ1OJvbvGMOOWx3HXQ/oDMAc1ypxvh0bGYZFSUt8Dq4rp/AcZPOi5ln+SEmX8s1LGqEJxoCQg5FoM69cnP3LkKbunUUDxVjhIYFohllSqq0Ec64fV1uFTESfbfan1pgW676L35PExV4PeA9vH5VXhGp4rySnXPuosIXdark9iQL0mUxTqmbmqDWg+xeMCbkohk0u848T2DhLjow9XpLxwHTo+E5GsI1sU1y3F4YuFMFxLeRH14oHCM31CzcFKA8Cy0pogzdEjYGYFnPSV0yOaPt4F77IFl1ccsMEE7c0vmjqXn7C0W1gWfZVcERYVdXewMyW1KtoE2zKxmw6uH0YE3ZmtINfh/mGFL5L1WT2P8ycQhBz0Zyjcj62LOpZYcAH3rCEXOUQ+2/t1yI4N+aaBnkUUt0DtaIwSJShW959SYfilHEsrcXdM66ZXk4ZKPjE1
 QlWD3Fxm
 8fhBa1Q4T55PQw+n26O8dUA6sBs/xDLnM/mWGzSlK3paKiI6iMpz/fbBceHkQ0zK3oX4e6yk0LkHY8s99BxiBORR+rqFXrwqHLIO7InJBQPha1f4TFoKRnXg2NvLspPEMZV5nNsCTdRRNXWKNFR7VDymhDucBZaZTQ3xqlZHQin8N8NbHwBWnox1+laRKMeQfaIzhYK1ydNGO9TZ2j1m9NhmPQBbC1snP3MxNAmlaNDA7fnjYo/59XIVGXeozhrPHJec7NOcGHpDUbX+miLydA8y+mbQnLsXTkEsD0JQh0Vc3WHT8/CEaKW9XDIhXgMz9TpJMQAenGtnHO0XYV0dvzXvQZSqye0AnkMUmXhiMzv33Whx2cHt77ncRo2yxxu/+sKAnYRVWy1IY4Vk8rfkS5uOsmqqyphh4sgydmhd2uNGzqj4O83ZPGT4ZSr9ocqoPd9dY/zLHDIRTdiGdByUezFdEBvPI2R95vKjHqxS+cVunlkhLd/x4xBtZP1mxKHv/E7qmgg9msX1kLlHuWk9rMP9aujxnIhRwKGpLfZc9N2iRWkkPC0GHTZV1lzg6jVHotPpb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 9:35 AM, Zi Yan wrote:
> After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
> khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
> support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
> so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
> mapping->nr_thps, which its safe guard mechanism relies on.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/Kconfig | 11 -----------
>   1 file changed, 11 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e221fa1dc54d0..27dc5b0139ba6 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -936,17 +936,6 @@ config THP_SWAP
>   
>   	  For selection by architectures with reasonable THP sizes.
>   
> -config READ_ONLY_THP_FOR_FS

Yay its gone! Thanks for working on this :)

Reviewed-by: Nico Pache <npache@redhat.com>

> -	bool "Read-only THP for filesystems (EXPERIMENTAL)"
> -	depends on TRANSPARENT_HUGEPAGE
> -
> -	help
> -	  Allow khugepaged to put read-only file-backed pages in THP.
> -
> -	  This is marked experimental because it is a new feature. Write
> -	  support of file THPs will be developed in the next few release
> -	  cycles.
> -
>   config NO_PAGE_MAPCOUNT
>   	bool "No per-page mapcount (EXPERIMENTAL)"
>   	help


