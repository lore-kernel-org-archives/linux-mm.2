Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73CA8CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 19:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715758E000E; Mon,  6 Oct 2025 15:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECDC8E0002; Mon,  6 Oct 2025 15:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602E38E000E; Mon,  6 Oct 2025 15:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 490A78E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:44:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE5D9BA347
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:44:13 +0000 (UTC)
X-FDA: 83968715586.25.F2FA353
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6DD82A000F
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 19:44:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YXC6qehU;
	spf=pass (imf15.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759779851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wGa1khmqjJj9bjF4YHyiBRIwvpz0W5HQJnKwC3Xec8=;
	b=x3WybActyq2vEkbvI9nwYMVE0hJIqbosT3wtyznpHv2HvC93sDarxReMXFJj7VzUJRPQQX
	lwKOvb3KG+wkESFLZSE+qtc+f6QPzn9rELhHwsAKcJ1X4mvHB00XQD6JZfeUfMggMqxZKn
	QVRUnYUvlSS7I02ve5PQ3G9hjtaZHPM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YXC6qehU;
	spf=pass (imf15.hostedemail.com: domain of alex.williamson@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=alex.williamson@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759779851; a=rsa-sha256;
	cv=none;
	b=6PtEEKF32WKdDsdjC/ROJJz+yTJhkuYrkpD7tWlfxQLPkUmH7HXSIEaFP98ek+194AR+FU
	+h/yln8J7gLCD43TTSSclnjZ6un9L/yJRgOelrSUlSnTgJ/aHh3p5dK+D/BmXH6DsWx5ST
	arjKtvCpycVgO23wE8dPMl5zbawP1LI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759779850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2wGa1khmqjJj9bjF4YHyiBRIwvpz0W5HQJnKwC3Xec8=;
	b=YXC6qehUc0PAWu0/wWbWrPTISfUyyOFHE1q2G3hQt3BzUhHFaCLr6nSrfUZ+JbFq/vA9EU
	7olu5K+2GOG0vYtj+cpzwy/ltwyySg7cIRz34RbzZbdN5eiUliVujeYSW/PBI+ZB5YoAts
	OoEm1a9tx6l1xZUm767c47VMjXu9c20=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-TfbXfMoNOFiGlp3j-KTdMA-1; Mon, 06 Oct 2025 15:44:09 -0400
X-MC-Unique: TfbXfMoNOFiGlp3j-KTdMA-1
X-Mimecast-MFC-AGG-ID: TfbXfMoNOFiGlp3j-KTdMA_1759779848
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-93bbe4e1444so18023239f.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 12:44:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759779848; x=1760384648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2wGa1khmqjJj9bjF4YHyiBRIwvpz0W5HQJnKwC3Xec8=;
        b=o98LH/sThNpvKr3ANo2WjdnVZJIcw0rYdbIiydXiumQKNi+pY9lBfSvP2HulVIeqB3
         XRoL9hzTN0X2QODvePHEL247tJFCzIcxZlAHFQAyyhjBDBTRDIp80z6+2XgKNncpEXmJ
         mF/uGdKCDfODLBeVVoeGwW+BlijtL4EIidH0jB/0LeH5MsH2tiwIhgh/9YtY0UO8I3dr
         Zvr2typY2aqDKziYvWVv0PJXmnKQpyo3NXLyKB8jy1g6dTJZ9pGKm2FPJH41HtNplQ+I
         6bjV2Ub8kNAd5FxWYQkdu2jnoeh+NCUyZUjA182xltuTcljVtrq80KBN9osQZ4bxN67S
         KqxA==
X-Forwarded-Encrypted: i=1; AJvYcCXIBjQ889FMjoTqpOtuUSNOgE3fkvi4WGaEuQC+jBcqlpNkK5Fy3IodyMdUV7SwvP+Q+q76DfGYCQ==@kvack.org
X-Gm-Message-State: AOJu0YyeTTZkRc235WcN1NKFnekmowHoJ9iSoPmqS+OHNz5j7K2XhOAz
	zk8hZHDuJiJVclOOQ1SgKGMlUcwq3Jg5iNjlXwCriY+YLeu72dgl4+AruH9lBXTiWaG/PV5K/wF
	SuJJ66gvngyNlWDOg6kUFZdm7HfZhysm6XqZMy/zuv6MQZ6AdPtNu
X-Gm-Gg: ASbGncuB3JnSU0xV8qycqSszzeCahPwA2fJm7j6kp7sxuxZ8vPO4BDy8riHiRSA8T2F
	B7hByw6L7N+N8gVfPEpMWaWVNLLUtsBFYioH1e1Qq+8MPdfdVvnkwHNNa6AroLysZpFIeSe/rro
	GSG+MxNEHs9nIuzqDM1nBuequVaSR7v/FlgNhtypq49hVTEkQLsXbSeJxPOw0ef+A3PHiYysmbA
	PBezzOQfv4vDUv+z3P01J5Tdct07vUgzHj9vYPmY3UrZlv0hHAhvpewNe1we+X3WCcXHP1xSqiw
	EbWZm5wXN7V9vCUvI91crIMMdjtN59t/R/BrekFvTzDyel1U
X-Received: by 2002:a05:6e02:1a65:b0:42d:83cf:7eca with SMTP id e9e14a558f8ab-42e7ac22325mr72392775ab.0.1759779847761;
        Mon, 06 Oct 2025 12:44:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGP3jeeIHRl2mMwYdvEFxNykrksErfJmwGRtKCpaf+j231lfST62tdr+GVBef69fSN82AkhxQ==
X-Received: by 2002:a05:6e02:1a65:b0:42d:83cf:7eca with SMTP id e9e14a558f8ab-42e7ac22325mr72392665ab.0.1759779847294;
        Mon, 06 Oct 2025 12:44:07 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b2a490bsm56406045ab.38.2025.10.06.12.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 12:44:06 -0700 (PDT)
Date: Mon, 6 Oct 2025 13:44:03 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: lizhe.67@bytedance.com
Cc: david@redhat.com, jgg@nvidia.com, torvalds@linux-foundation.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, farman@linux.ibm.com
Subject: Re: [PATCH v5 0/5] vfio/type1: optimize vfio_pin_pages_remote() and
 vfio_unpin_pages_remote()
Message-ID: <20251006134403.4fc77b97.alex.williamson@redhat.com>
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WhbASRemP3l1iRS9k9DQkpVw9acTxDzzanIELFsAM9c_1759779848
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6DD82A000F
X-Stat-Signature: gr5tqg3dw4mufo3gckyabwr8p63ikfdn
X-Rspam-User: 
X-HE-Tag: 1759779851-589489
X-HE-Meta: U2FsdGVkX19xXqL+bJPL0WvLI5OERL8B5X82ExYGBdKNNhkl2HOJL4WQdVxwvMZilM+ETm5c00bK65O06xbulMQSqQjRAXuzpSl+uiV5IUvwJ4KkQo4se3QX7RvSqPo0FwwGrtmIDmSljsR4ASRCddG+kYf5c2rESO8KwP1W3t0YMognSM0xdcPA7ZYuKpFAdLGlNHiBLKyLeMZ1UftVY1/eVCr9jo3BcfXTWXlDKvVNvQx6ji1ODpBkYRpUgUbW9e/tekieS0zhrTFl/+K9POweOnkuU7nAytxjY8w8Wf8dtnPIxJz3Y20hrgcR0+NEmI8TGfufDiV9SzwukXwSr8eWfSw8T4cEpMUZ30WCHXez0879aXIMJ9GrGjaJojqnoQOGkRuypNUaYQ3T/ZVG+bQJHeR+HuPNsZ6vRNC0aaVQ1w4naPx/X4MSd1/ZWziI7XM8J8e/NV+B2QxXUBf6aupk04Pj/FS5DMh8Y8j6V+Jokrc5q2yyhcoAfTmTVdQDpbeKuIN3039rUSeL7yirMml0wMr50/VF+SBnyOhvER3MNIsUC/Z96fODCtfuFXpFaA27SGz8JQjQWxcvlwTiZE22gGK6PSpYgkGLlJhCyNtoTadDj/+DcMfyyDX4VMfZoC0kqSDUVawbvqJHlSvln8lBSswWyp8lv8eqggrPonVE+CQnchAs5INFFHV6kUnCQuwChPRAAAgOhxPnF/k0kF9cS/806Q0J0mlDxD1OV6kFXO6iUe7vicGCw/FTm95cQatQTFN9vHEDauaPJJNQ2hULbLkk4HZ3LqmCxxQRXt9T+LQeEvBMEbjCy4/vJK37hPVGCEZSTUKUz+bCWwpjfpPQ743K+tUz4tB/3ln+AfoqHErM4Vw72k4DMPh/TdDywxieNrsCOh35f1Emn3F/ryl5JWIL/IZ8fGZG2HDK6edmRvKzesn5CZutlbqCu0Aez/hG1NXy7i35kTIjmF0
 wiXR49W6
 V9nN5eq061FyYAjmVQenS+hxiCinTBw0x8m3Q6xHSaElSVF+v88yBqWxzcdhn3n8ylXEbBx7S+j8BvKib5p/iJjxs7z8gNn6uOHM7T9f5Ns4zeekKg9sUm1h7ft1rYyjx3IPxdB5f9LCvhcTwmORpwMHiM6M3VjBW8DO0oaAIWFgWL0Cnj6M8Xw4vvDkrdMnCzr6k+3HCOXwPzIiuz94kWKzrcajuQ23qtQgPikY2TmaZuZdsGKIcpmd+DzSo4EJEYmmSuKqN5OrL/mGILBJeuDDa4/sm5WoHgtFeZdLEpE3AX4jo9T9F1HSS/xKxNJbCL6L/mENEjphlBrpzhVFmFFpIZNNk9l0bWFyzpiXTOlCxvLfGqEblkb8DgyIRmiq/ogOrXKooSXaR0jz2Qt6H/m4SrfObMNCkM47hAOBtQerhz+ldbgsWBtbJMMLTcSMty6Zb9dHm/E2tolawOjpeOkcZa81BW/XkWOUu7iPuwGT6tnQo7ZdtInASeHHXKqfiumAhXPCvlrFF6bwYq4xJKie5eq+kx1F07M0oF2B7u+xb2licRDk7qY2Ihb4OHkvj9c1ctB36oabkVQU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 14:47:09 +0800
lizhe.67@bytedance.com wrote:

> From: Li Zhe <lizhe.67@bytedance.com>
> 
> This patchset is an integration of the two previous patchsets[1][2].
> 
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significant
> performance overheads, especially when dealing with large ranges of pages.
> 
> The function vfio_unpin_pages_remote() has a similar issue, where executing
> put_pfn() for each pfn brings considerable consumption.
> 
> This patchset primarily optimizes the performance of the relevant functions
> by batching the less efficient operations mentioned before.
> 
> The first two patch optimizes the performance of the function
> vfio_pin_pages_remote(), while the remaining patches optimize the
> performance of the function vfio_unpin_pages_remote().
> 
> The performance test results, based on v6.16, for completing the 16G
> VFIO MAP/UNMAP DMA, obtained through unit test[3] with slight
> modifications[4], are as follows.
> 
> Base(6.16):
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.049 s (328.5 GB/s)
> VFIO UNMAP DMA in 0.141 s (113.7 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.268 s (59.6 GB/s)
> VFIO UNMAP DMA in 0.307 s (52.2 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.051 s (310.9 GB/s)
> VFIO UNMAP DMA in 0.135 s (118.6 GB/s)
> 
> With this patchset:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.025 s (633.1 GB/s)
> VFIO UNMAP DMA in 0.044 s (363.2 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.249 s (64.2 GB/s)
> VFIO UNMAP DMA in 0.289 s (55.3 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.030 s (533.2 GB/s)
> VFIO UNMAP DMA in 0.044 s (361.3 GB/s)
> 
> For large folio, we achieve an over 40% performance improvement for VFIO
> MAP DMA and an over 67% performance improvement for VFIO DMA UNMAP. For
> small folios, the performance test results show a slight improvement with
> the performance before optimization.
> 
> [1]: https://lore.kernel.org/all/20250529064947.38433-1-lizhe.67@bytedance.com/
> [2]: https://lore.kernel.org/all/20250620032344.13382-1-lizhe.67@bytedance.com/#t
> [3]: https://github.com/awilliam/tests/blob/vfio-pci-mem-dma-map/vfio-pci-mem-dma-map.c
> [4]: https://lore.kernel.org/all/20250610031013.98556-1-lizhe.67@bytedance.com/
> 
> Li Zhe (5):
>   mm: introduce num_pages_contiguous()
>   vfio/type1: optimize vfio_pin_pages_remote()
>   vfio/type1: batch vfio_find_vpfn() in function
>     vfio_unpin_pages_remote()
>   vfio/type1: introduce a new member has_rsvd for struct vfio_dma
>   vfio/type1: optimize vfio_unpin_pages_remote()
> 
>  drivers/vfio/vfio_iommu_type1.c | 112 ++++++++++++++++++++++++++------
>  include/linux/mm.h              |   7 +-
>  include/linux/mm_inline.h       |  35 ++++++++++
>  3 files changed, 132 insertions(+), 22 deletions(-)

I've added this to the vfio next branch, please test.  As described
previously, barring objections I'll try to get this into the current
merge window since it almost made v6.17, but was then dropped due to
disagreements in the mm space, then blocked by merge conflicts.  Thanks,

Alex


