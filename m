Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6FA4CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011DE6B0006; Thu, 28 Aug 2025 03:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BF26B0007; Thu, 28 Aug 2025 03:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41806B007B; Thu, 28 Aug 2025 03:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6F596B0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:31:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 537C71DECDE
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:31:55 +0000 (UTC)
X-FDA: 83825346990.19.223A360
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4520A40008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:31:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CY5ZiitF;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366313;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuV0vIwmYzbGp0NvCAEdvEWsqc4i4ounAUIZgXtsn78=;
	b=HsQUfG7DIOG7tHGgcTdWYTkfzaivo2gOtbphwGjTm+bLRH6MeI6ywcgYIAKUYDiFKMPa8q
	xuzjSNZjCIYQ12D39CCOQM1qCGwLPc8JDE/L+e8BOFYGzMaPN73Pv6ANBgSMzKNzbV7Yso
	Z5EaabCm7V+nMX/OCbToM8fhQOKwJoE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CY5ZiitF;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366313; a=rsa-sha256;
	cv=none;
	b=ONx5ky6T0Q4VWB0WB9pySBaYDP6GFESMezdb7yhhFyjYgAcpqVkJYD0XtSciJMclorGlLT
	tT7vdBBSB2PtHMcU0ohSHUwgXn6g6z7cqrd5Yq3Sn80IjZKhoKp5PTUH/Zh2zpNO//7uRG
	boFRGayOKXiuq+4NYYVMrMVPSPrgSsw=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3cb9268511bso371678f8f.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366311; x=1756971111; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuV0vIwmYzbGp0NvCAEdvEWsqc4i4ounAUIZgXtsn78=;
        b=CY5ZiitFcpLeZBUTRJy43+fRpSZ5RuF4XHB8jfU5QPbEwtN9Gy94UNMD3dO8k9ZcAx
         o9T+SN0XUxZ+bd812G0oBRg6ep94vr1dtAznMsr3gC3rQ3KJ3MR3PoBfR8+c/jKKLkNt
         IfxsNHU5+2TO4R6xdPBj45S0I5/f/9FdxAShmsxa6CdhylqY4d+W87pQKS6O81IpB+Ya
         zxNUA+aAs1UWsYLzcKkIdxXEVn8c2xSftW/5ka/lNb2r1/Iq/iTAtA08mYFwWDENIvq9
         Kz3BM3MkdDDgJINE40FdXVGtCtcKiiodTkh27cIDld19/GbXQd3dz00kX3eFOIb0jtpE
         B45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366311; x=1756971111;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EuV0vIwmYzbGp0NvCAEdvEWsqc4i4ounAUIZgXtsn78=;
        b=D3Tk41yCZn4Qjj6THnxHvA5/0gfkNxJXOtAMfWrS6d//NS2YMUINK/MVXpOKFPKU8K
         HjPAGQHmpGS+7/MZCKGeJN+aCPFs+1L2UmURrgowRdZGAx8rxAOVJIgjwlQT+ve6C3gl
         /G22pI0s7snP/NZnbXmnElU34DlAWfThhtSZnq37gtIuVS0gQZRtSc8/XPYNN5ky+/F7
         WS6MYPf7NVWfqAVV3IfAcJbD692lS7JG3zU+Alvp04oSYfw0/aDxI/dGm6FK5ka8ZpK0
         toPYQupi6NnqiC1S/i5SKforC0utKfKtRqok2Qi8Wvtj7UgpjyCUoVfPIanABFeZhG26
         iAgA==
X-Forwarded-Encrypted: i=1; AJvYcCWOE9fOb7yI/QpLhqADjnreYBs4m6bW0LriiqDSYHAF/BAGH2fteCOMFo/bJyYX3ydsaxoxaGl57A==@kvack.org
X-Gm-Message-State: AOJu0YzEfBxkbnSG6j3qMICC6DYgj+HlyGQnNAXPUTQAIEd9FX4Rv7M5
	UTaWHFwYVLneAg6cVWRRPXasuLrHur8ZJKb1ZaOoZVUFsGgVJ77Y8k45
X-Gm-Gg: ASbGncuST8S92cK94c6y5YQKDi3XQgqC3NGy9JQFcNEIjWaQjVO+7skRhDi+1ZsfYJ5
	unXa4ZmQqi5zUSdMHQNENXTalPY+WpBaqFhJwyz2OzaQbAlGx5nlPxX6Ito0VOIvPxiVKupWhkB
	9jhq/KrEXhmoSDzcGRmZf5scywkfvIR5jHoRGh4v2WEfVrPx6eKXfJYrJyb/I2E8qcYzna0drgq
	hU1D6jKphamGDdkQhX3XEkAgjz2aSCScZKYcHtlHVde6vaLvvqemB2E29hscq11jbQm8Zb/C0/N
	0HKfOJ6fDA29BuMCMecPQ4Z8dAUtL5IsfzN1EAmTMpWnsHaO3FkOn0ogCLX9rZDQbzpp7aYsVHm
	0O77z9aJk6VCfMl/hAjJ0TkIsbM379UMTg84m
X-Google-Smtp-Source: AGHT+IGYsCTFAB2u+mO+a+/7YQm7WCRYBnf/bqNrDbgJHuGpC+AeSLNYygCiHCIag3yJJPklKDadWQ==
X-Received: by 2002:a05:6000:2891:b0:3cd:96bb:b948 with SMTP id ffacd0b85a97d-3cd96bbc28fmr1837267f8f.47.1756366311260;
        Thu, 28 Aug 2025 00:31:51 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c9c9324dc9sm14883755f8f.3.2025.08.28.00.31.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:31:50 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:31:50 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	SeongJae Park <sj@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 06/36] mm/page_alloc: reject unreasonable
 folio/compound page sizes in alloc_contig_range_noprof()
Message-ID: <20250828073150.jyafkufvkjfqwp3f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-7-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-7-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 4520A40008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: frhyqdfcd99y91etmzccqebmxjczw14q
X-HE-Tag: 1756366313-116608
X-HE-Meta: U2FsdGVkX1+YLQGyIQMhwAyEGH9zU+N+dGsQ48nWcUvyy4H+THu+VgEYzKcqxH6nTcCjIvNm/CJsOlssCMjR5/h0ovWazt7aFRuLEtHdoEs1LzY0RVgnVrunB2r1bYN/5YTP2Csotynw7bU6o/8DBVQof0JTiGyrUaoOHOEPZPmWBHg0mwcEDmzmTH6tJxTCpZrx0uxYaU1nSo+rikf1200P4Tj9FGkj8ebPxR++bZ640K4k7w8eMjRuBnKR0Ll9cMlb84Dc2wMN9pU6Tjs7apMHvoP+q6qKcBWmENHT0rNqlEl0lcDgVssTY/xJ7+IMw5+39vKXJYYuuCwvHogHAETPKNc0ODiTnezuwhCQigd+rIk3TimQWuN/sfb2LWp9NPnqx9qgfYW239+hbBEK28e4+IVZ0yG6GT3hmqJLkSCTHIgPPjmfUNJE2IPAd2qMy2TRcLlJYYPsLDhzw75MtJJjqWflv7e/BsUOEDanJ9r+VIdj1tJTnc7PpMsgM5OlF0cBY1NodJYSmN84+JnJixqKwsIWL5BrwIEJRo3ZzqQZvy5v0H7Vk0CYvTzxYOemmJZPwzrxcgleT052MiKKQLCK5/6Jb4UaTjQ3g2Skijia8/YWJMcD/zmMKOn3aA769qhOX6w5ExUaA6tm2L2ybmnCrZ/hPVODbE6dv+K2Lf/cKa75qR9VJjYk2nzjaSLt8LIDo8GOQWew7EWnFCTRlR3TiDDjsa2fbNOWGu69zIuvaqKsinpdMNHLQjhosTNJwYhhWXobfjANS6unLXOkWTQ7HqleURjo7uMM4rHvX5H09TTKCKL44cSRTdpLswRR04+dq+xYgkhA1RUdjT+C9N1w/HlXAtr3ccPR9N6G7ofZgxFlkXf8M4W1wVdiRJKvMjmNdN6NQV0u35pp08cdHGgFV9/qnlI546oW5hIoVc+M+bMlQcmlLak/quwad4HKl74m6kb0U01D9RpS++L
 3ik3yvvz
 VW1wTzr7w3d1w1yIj+lPDKrQulL3zoe+4lfer0Mk2ylezzxNOd+4Iuj+HNjpMt0O/06RC0gIWPZ7ADQEObwU2X46EWtBZZ1FEj3UmW0BrQWmjchv217QFtJtnT/FVRdBmQAaOCaV81Lsd4/7OOyAvz95g7QZRSTx8oQfU1mFJRyeemlXCXYkls5dYZ3d43nD8quyZffI4ZJAAD0gEi1W21KQrM4dzhhmFZxUU+ZoQnE/bGxk7S2M/IPgwDu7myt8pEsPaiRu0+/MFgHrfOoTVf5DCYu85sEieI1//UYjA1SBZ1dokB8jr0RmUHqMrZ+FjQz5LEvSzjqVlGWPyX9t77Vfo+TOrSsuKI6ebhguPAxbpLjQDVSHdrWSy6ERGbAOmAe+2pVHphQ4idYwxLejWlIUaSnyt71YA7atnW8Meytgi/TQoJy/E6lohvXjSAmQyGKa7hANxZJ6o8aFToBG0fI7I43dfkSl22AR3H92NSiri6ydICWZ0IcZkMV9McT6OrFrdq2p7Wdx/azsZ6VCpiJz58NthHyORtrBZIQ3u+n3Z9c+crDcE87s3VKofiE+0mB1Xb0huvBGykJWVnFrbG1MK5bfSx+pSlEqd/5qvOw/n+XrdyBD3kHWLAjpH+3/DowGj2QIsVN+0ug5FkBIqilRa1gcjCLGnvmgxIW2OTknADnYyO7MO1ittbBwUzuzMpX3BoBvjNPiN6+hUVHrYOm/IGl20SXlR0440adZU5nIX8wBofLNl9flEaICNv3PM1Dh3BwZR3+QwzFHUdWNYBYOZ+bGh3aUQpll4wwB0Qy3uzWs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:10AM +0200, David Hildenbrand wrote:
>Let's reject them early, which in turn makes folio_alloc_gigantic() reject
>them properly.
>
>To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
>and calculate MAX_FOLIO_NR_PAGES based on that.
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Acked-by: SeongJae Park <sj@kernel.org>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

