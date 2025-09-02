Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2FFECA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 09:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0632B8E0001; Tue,  2 Sep 2025 05:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A756B0022; Tue,  2 Sep 2025 05:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6B418E0001; Tue,  2 Sep 2025 05:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD4B16B0012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:22:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 13C3958A30
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:22:15 +0000 (UTC)
X-FDA: 83843769030.18.56462A4
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0EB1940004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:22:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ursulin-net.20230601.gappssmtp.com header.s=20230601 header.b=EUiLUstv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756804933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Be300C9M54HN2j6qqn3KzILYOn0Dm/rUn/s4aJntRQ=;
	b=VYmcgFmE0f2wli53yMlVghkaPTs9Bz22kGth0Gd3/tCH/oTrNqbeZbEBr99ubheYcC7X4C
	Bqwtx3HoOOvwqbYs3S97oNP0l2VH01+cIbXNymmK2Juaufj2UjquTNQwgCQOnuS/8Xn09h
	YVLb4IiUxh2XIYRDGFIiVBkGku730II=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ursulin-net.20230601.gappssmtp.com header.s=20230601 header.b=EUiLUstv;
	spf=none (imf12.hostedemail.com: domain of tursulin@ursulin.net has no SPF policy when checking 209.85.128.48) smtp.mailfrom=tursulin@ursulin.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756804933; a=rsa-sha256;
	cv=none;
	b=cGZKTO6xZsFcFuEm54j9jd7Xo/WWI8tnB6z4ZCSRKXBK9OxSXO4PbfW+dRH2WcW0pydA21
	NDULIbXScJkoq6FpWBALfhhQ5ogx5vo1S3d+y74+NljoYQLQHgIc61Slj04c4fDYHquvgt
	U+MQE11Q69saP0i8n2vNsIfwueg/42c=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45b804ed966so15860075e9.2
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 02:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ursulin-net.20230601.gappssmtp.com; s=20230601; t=1756804931; x=1757409731; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Be300C9M54HN2j6qqn3KzILYOn0Dm/rUn/s4aJntRQ=;
        b=EUiLUstvNA/aNuun3lWl/rNLolURNF1oxm+EdiFmhZY4cEobR+vYTfOjfW7z42AAWn
         kpu6YFb/bD1H0t0k69vjpBwP5ULWkHE1Npc4JRd9BEN4SYacK7jS7bTVnS2pDMXL/WyT
         aP8PCX1NCEARtu4BHgUgV6qVVAD/JfQn4pjHfOVeaizdMx3UYE4LdAAubZCBZaoioRlD
         MmdawuCaelc6Oj4QM1FG72U99yv28BsIMZgqnMAe3utZg57jSyab77j6oRjWtDiakm02
         36guiK5GQw2Kw9IJBJhkiTtPm0C1FSMHUhckd8qn0OOvMXpw8KRa0Bg/zMQyEJoJiowT
         qj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756804931; x=1757409731;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Be300C9M54HN2j6qqn3KzILYOn0Dm/rUn/s4aJntRQ=;
        b=Rx8WZYTYJSWM6VNr6Lu6qz9Xxnv/IgDnGDxdEX9bulEzrEPkFjr4WFqK/4jHep5n1y
         Y8OMUH35H8camdjdivSjLXy3/gtN75mEqBN2Pcr9F3CURGNa8q9xRXAvJR0NJE9OxSPZ
         x9//Snit16XgT26QtvimfSiciAoKJBHdIpmZsF6ez/xOoV/s7u2D6HRC8m8+GTfIHI37
         kNcw8e7UNoPbm89MXkYA6i0O5CFS+2J5uJem0jYlRgilD1cLOq5y7yGeuEIm3p8UCZ+B
         eByJN/IHS6eC2omjaT0ASDqLNm9PFVwAqjOIo8Gt7ND0qY5H8qAfohjj4Limn21tHF21
         tZJw==
X-Forwarded-Encrypted: i=1; AJvYcCWaMdwpVERcIxPfaJYDCliHJEsyWfLOriUIvkqphXOFSc3rO+xoEo6GO0sIbd61n2lcIcPORKxdxw==@kvack.org
X-Gm-Message-State: AOJu0YzTw5oN4WX04siNXgSr9TL3gQQ0j0mi9sy6TLDBzy0PzajwqNOv
	mQ2MGp6x/yeu28AqMqVaRilL3Ten6Ru81zkWTte8kZXVlI2wXyngFP+RfXJ0h5aVvSA=
X-Gm-Gg: ASbGnct+/axnxYdrSi9Qs1d6c8fpO8hSEOdWGNfFPNHGsIifpLxfqp/PLflNhLLwj+w
	RqgCJCPUGtpRTIuWoyxRonWllltF9by7KTbFL/9U9cj4X3G37GbxBRHQrvu+nUkjI43j+m/LjR0
	kH5Y4nV8ZF0hVzTc9E/OUIxpo/MTKMLz0EYaXda60lq6kq1wA3UQov9oVo2mDCNYvhhAH9MU7Kz
	gr61N5Hi7V+g9ZMr/otYyQmRG2xWwxD6rfA+7SaEf1BRY7gMwpsA6+LtV+nndDS3eDBhfNnPAqQ
	V+J403vJ+o/9iYjvwXYwKECOM53I0nPirfqbX0eHV2pGwgZwFpkYMZB78+coJWawCi4mukEpJlo
	zN/KTdw3Lts9Mm7ZfP50yUzqg9g+mDI7C7bk=
X-Google-Smtp-Source: AGHT+IFjGWdM7r4OC2xPYq10JBW42QzIVS9ISDbv655toZnOdc57tKWSkMByc2ni755H7QY3mBnVYA==
X-Received: by 2002:a05:600c:a04:b0:45b:7d24:beac with SMTP id 5b1f17b1804b1-45b8553335amr94619035e9.10.1756804930815;
        Tue, 02 Sep 2025 02:22:10 -0700 (PDT)
Received: from [192.168.0.101] ([84.66.36.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0b9402299sm17994846f8f.18.2025.09.02.02.22.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 02:22:10 -0700 (PDT)
Message-ID: <4bbf5590-7591-4dfc-a23e-0bda6cb31a80@ursulin.net>
Date: Tue, 2 Sep 2025 10:22:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 26/37] drm/i915/gem: drop nth_page() usage within SG
 entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-27-david@redhat.com>
Content-Language: en-GB
From: Tvrtko Ursulin <tursulin@ursulin.net>
In-Reply-To: <20250901150359.867252-27-david@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0EB1940004
X-Rspam-User: 
X-Stat-Signature: 8uxqmtgwfh18jffwwud3rnk1r7nsu1mt
X-Rspamd-Server: rspam09
X-HE-Tag: 1756804932-786900
X-HE-Meta: U2FsdGVkX1/D61g9ixFurQgdIEe3upPrzToAMpebQhQYHyLVMrdoQylhNGbZPEuaDh3qSoFAB5Q8/vHvnIa37Zptt+7tvksJSjjsbaPPj3pzfQiP0zNFxES8TFpEOGupLVn7zDE/FCIBNaHZMTJayxNJiOR9NmNsgoLWmu9TkYdwqVi5wLILRTeav9afxQ25hjeO8I/NKoTKLOTjhFLFBopMfVEF/f4V1ocmtVLfOKtPPKfNWgHkk9MJCuesEyhZnH6HUYrhJlnUlv4fq75tK45JXrdj2exdwJhzqVtJNugSbCaMtvBFzk14YDZniWwvTJu7XhOxG6BkbE0myuo4FX2eA3A308hEFnydUe4GOyF0/NsUun7nKVPc/eaXmEjF7vXU0qhBQ+w1rJApBADLAQL3pTQ98Kc2bI25kFcmCOwTLOvk07K3vrfFONhAG65LPE0RCzrrlHQ39CiQy0t9uE/ZDHAOVm63RR3y346GP2a+s7GOeHnlwzAAqiLZyBhNYidXjvu1LSC+mHFUEMAWqWuipoNfFiEY1TXmruulBSeZ54U+QZgkfSN5dJrMqkfqp0v9Ypj3Q504X4sW/nJVv5tMXkb9rZO25/D1tclm6BIcLH/we9kYAHT08R23LnYYNqvHDxuPbdfIaxb0TRKDjg0tGGscIty3SgiaRPltvvxuT98fhL+Dw+G+UjAbLRDV78JwyfMYKFfHDKhmz2Ie2AoSOZdl+uC8kJtLUsc6OQRIQdX+0KmPTG53+U410xu9fEzKwJJzQxB+XkNo2zm5jo54XysU1LvU1XWPEHx3d6qDZRwLnE28nB9dqFeVw/8dBdI7ZO/gu8LAhxm/Va0FZsQs0d+Pu1uQsviBjNPJBmhWO557iRt8PjW9EP/4zpja49WeUUs688ACPdJ/aF0ox8EmSi7mi8S1THVTJYu/8LQ9QTvjCnSslUXunHjtfixZgwcLuC5vTX4PRe+4d6K
 BgWIG43u
 IwRuxf0IGCBQxQ2dYMqoiRi4jV0SABmZPNk35gqkdLuixRBuUCsp1Rd5eSgYc1ftw0/tWn9MO4I4ThdHbaoBpCa4qSFwmR+V6e7vv7xkqEylUX7Y+jxRDLWseXrnCNPzqcLj0MVlxd83hP9uxVNbVeGrp364qouD5xpVOXFJS5EIv/vdzlYxnDwTbAkgUD3Ec3vzNkqX6lC4vBLA4doOckxbcx7DDbjtd/tdO+J7dkExp+MrhCp537p7heLKYThrmyudDCmgpKbMel+uz3vasR2AaedsNFsySZEdR2Wu5VOr7kvz11rJyf5Omkv3kg6U2d/EEw2AINFDy+noBTEFs5S25bvQaELG077SHtp9gTjM0t3Os2ksudMh//rp1411n7c9bAbSSZTJVxxTcdkfxcKa9NhSSYyo+0qFoHY0jntgtxZCQZyeg37JrrNH6fVI8XX7n8YNBqKq/xqgJ0Er9wk87FQrRXqkDcqR/PglKQQWBHV+9fG8yKDBxQxylBfhxdgrhCWtrMDw2T8zs4k5BpfrsNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 01/09/2025 16:03, David Hildenbrand wrote:
> It's no longer required to use nth_page() when iterating pages within a
> single SG entry, so let's drop the nth_page() usage.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Jani Nikula <jani.nikula@linux.intel.com>
> Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
> Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> Cc: Tvrtko Ursulin <tursulin@ursulin.net>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>   drivers/gpu/drm/i915/gem/i915_gem_pages.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> index c16a57160b262..031d7acc16142 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
> @@ -779,7 +779,7 @@ __i915_gem_object_get_page(struct drm_i915_gem_object *obj, pgoff_t n)
>   	GEM_BUG_ON(!i915_gem_object_has_struct_page(obj));
>   
>   	sg = i915_gem_object_get_sg(obj, n, &offset);
> -	return nth_page(sg_page(sg), offset);
> +	return sg_page(sg) + offset;
>   }
>   
>   /* Like i915_gem_object_get_page(), but mark the returned page dirty */

LGTM. If you want an ack to merge via a tree other than i915 you have 
it. I suspect it might be easier to coordinate like that.

Regards,

Tvrtko


