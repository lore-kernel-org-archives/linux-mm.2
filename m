Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06ED5C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 17:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A936B0098; Tue, 22 Sep 2026 13:26:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C5056B009B; Tue, 22 Sep 2026 13:26:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CBA6B009D; Tue, 22 Sep 2026 13:26:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9DC36B0098
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:26:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 485D440566
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:26:48 +0000 (UTC)
X-FDA: 85242078096.04.9961E4B
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf22.hostedemail.com (Postfix) with ESMTP id 53538C0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:26:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=JbKTe1x8;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.231.204 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790098006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZsMda0uwAQyf/r755/L9LfI3ibTlAaDp5ifNzI89+Ro=;
	b=j0U16lisyzcUX4FRNS1JZG7Wpg69MuQGfP8ORog0Vs0+FJ/HuHObc/Sxo2Xy9rQd2Vi8bp
	mQR7W6XQ7YsuwS81VtMEcteLazCNZZcDUbR8JTP9EBDbQX96QOuXbRd+0dqCr/e3SVOHfv
	WtumV0L3wKi6kUAGxAAQ/05LPZiZBAk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=JbKTe1x8;
	spf=pass (imf22.hostedemail.com: domain of jgg@ziepe.ca designates 74.125.231.204 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790098006;
	b=v/OItQzJ/kkyfLDW8Zli/FxHI+w2FHJMw1cDbpjwQIAremjuBJlu0e4XJe4pX17iX6NHOk
	uwPwiKvVIkNNCTb8q2n0VdYHirVmSpRJnIplObZsVO20I8OG1QYaIvYEa8Ylx9R2/3Bc9k
	NKFdHYX6m0tcknOw+eb19sDY/dujylo=
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-7f4f0d298caso164073a34.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790098005; x=1790702805; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZsMda0uwAQyf/r755/L9LfI3ibTlAaDp5ifNzI89+Ro=;
        b=JbKTe1x8Sxmz7AWjGAbN7rY4jheIV5OOZf5QGYe9MLiRhZjWH85X7XWxe+B/RmsyO1
         L2pBHTHjmWTcrAG54ZNHseZKlr2na041vzlkiXFssFoixRFntV9fB0Ib0Ap5Jpu5Z9Of
         EVFFtZjTtuWZiJEbiIc42v8A37GHWUGUBzxgarfLSU6VQCRe9YhDCSuiYLMs9MaJ19zk
         cTa09Kb6/3ZLZV9ae5dtIY1d16Audk/M+aUZZ98/xynZn8rQPDwLq6WCHgMMJmoh1oBH
         s8apPLqjH4wFFhKIV0nOzpI5FPkFwZIfrAFHH9P0Q9UCO5SrgREoP+K+mV3NuutVehk3
         ilGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098005; x=1790702805;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZsMda0uwAQyf/r755/L9LfI3ibTlAaDp5ifNzI89+Ro=;
        b=w4wDQXFjWQZYEw8ypxXNn1ogOq0eL825lYzDqediZMzmibc32HA2tC/tsz0uE08GZU
         Jj7Ux+0wHMRfMUUjLwwm/aOYCPGDogFy5WSd+eWEr6AQMJtmXpt18ZCmBI8ENsZ+9WWG
         /Mdlb+1/TvHhtLZziAITfUI1RMurwFCFL1CUUOG+9ta4YDRENiMHqUvyZaASS9bxgNI7
         kPKCoQ6rmI7KmmkHn3lKtdEHcKOpk9ZB5j1SF53bUvlofJw/zI5oGzVbXQCejaz+JtGP
         +eFWjmq5ATGYnZT6NvsKib7NzW20E8qy1xQYyCT4M8LgiRwC13BzGXPAFLMD8aAfBdnW
         QmIA==
X-Forwarded-Encrypted: i=1; AKwUvBybcWfT7nGu8wG2cpBmmuWGCZWAM4bFA1hM3cJQT2Kup9VU1A0SHYKa/3Tgu/YPCR9EnYVT/cG0Nw==@kvack.org
X-Gm-Message-State: AFuF++mrfaDZb1dIUWHPw7cQJPoHFXlvCHS5Aa9X7E/0f9A5WkmSNaNG
	3vVM7/ET1Ujb+D+4kWrG1ZUIPVMGejbLtwqlZCHwBzwTe/o61GqSfNSd74EYcfFb4pk=
X-Gm-Gg: AYBFou2lQSodYWXowJH/0DGOraOHBAti5X1Wil9dyxPZx6aBUDw8d3YZ3Ak9S/aM0s9
	zG4Psfz1/P92FeiUXBgQQ6rFnkLXrnWxttzHpbK63KiiAsE4g/E9Gyq31fhrPXvjsi0tAQJLod9
	9dnRQWaTqnaJGSAy+6MAUwbYnrt58JQvOyfCIgmNCgnj25NcAZQKJHEePbQOgAKvYdoxaeUTTYM
	gktHQUXLnnIlpp9jXD+jnpEFYUFFASWqRd2DnyvYLOwho+1ukfRxBplnxTakV4D8i2x36W64MF+
	TGHEJWwdn+zeiDjhRJUFFKiuM9DVWf5inARBwvYodMB/WEfcYl+73163ohrFR3UfqNL0AuuHzDj
	h0sQqTPFmy1R5md891+aIZlHL6/xGL4pZlAGdnbn/uVKNPpdI59UBwNQ1HHzySCjuu3h1TSZGSe
	vgpr7snSzPIyAUE8ZIn/5jWAsGhXDWEMVh/YEGiuqcwL93
X-Received: by 2002:a05:6830:82ee:b0:7e9:e488:3bce with SMTP id 46e09a7af769-815f0071c0bmr324985a34.6.1790098005310;
        Tue, 22 Sep 2026 10:26:45 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-81603fc79dcsm103564a34.14.2026.09.22.10.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:26:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x93id-0000000AWlt-1Oeu;
	Tue, 22 Sep 2026 13:51:47 -0300
Date: Tue, 22 Sep 2026 13:51:47 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	christian.koenig@amd.com, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Message-ID: <20260922165147.GD1540250@ziepe.ca>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
 <20260921144847.501151-3-aneesh.kumar@kernel.org>
 <arKsFofudnTYpXj1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arKsFofudnTYpXj1@arm.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 53538C0006
X-Rspam-User: 
X-Stat-Signature: z6jgae1nbqa3i8i1rc3k8w33m38ssc7o
X-HE-Tag: 1790098006-252928
X-HE-Meta: U2FsdGVkX1/LF/mX0P8NiEDPk0gTuXQmnkQarThIX9FqEaTS75/GEKp9wWSotM7pldmyHen9wwC1/KwxTGhJAs96Ifkm1kmo6yOx3jRqInAmjOUxPO7lKwmGWX4ol+3cMVesqaDnkd1ThYWQa8MY7RebINmJDFWjykWRUUgCdwh/06XWAJM0rVhkGYs4t0fNczxjWXNqpWZ/NG9iG3aXn5e4sRuxIoA6GEeIJPLm/0asAC2z56iFCpfMUoeAexvkmPEGNjEd8X337dup05vYdMlppm2n6E7RtBWmpNfQtRz+VfcTaA0q8yAI/Eiv7BYVE1MadcYcZVxBk4hEDM7m7kfD+d3tQCaQepT5ZJ3bWkcPMXwTG1d08OdnWHcR7r889754Ttvu/T5JzEphI+36zJWsmm4h2ehOEIFImwfbxOMjWkeHyKPg8NXe27g/BsIl3BUWl3eGdrSgjfELi+Oc6gQtr8dWNVUSuzbE0BqylHeK+r9Yed3bAwF95Ycdacc6lusJ7l/yZPljaFEPsHsbxq5TnzldCyDy609803X2cWokvpF4YeF5VyfqpqlHrkxrHOR6sUNmpTKC4OB+ZdCeccpG79lV2DOxkKiPDvfY7UrWWl2R5nB+Gz+u9HiSpd9VhNmDDvo6o/gyHgzG8QBJgKWrF3heCH4pcRGkc7lKjDbwo2XBxI4m079tx8cTBJrEdhgrXMjw+A1NI6brSW/H2TepPB60l08jvp651QCGuPemDkKh1sg0/qJx3fJrFPU9d0r1lJ+DQN5QamF1yDKVnk2pHlcJCvdrEK+c8oV60tSrp5I6y6E6Ja2hbFBUJtznEypHqg+wv18oJslbMS/oU5ClcpVACfyGjNmFOqx8ATXDNrSQQ1FT6giYG+b3S01mlvwmcMtAOKszdvsv9iFs9NZ0w7UeU2BvnyeU7EQoFWLxc484Y/8AFrKgzlFHmU8qn8gSLDNCpMqaC2nkGSo
 An3zSPsN
 fWbQ1PWoWmzaaBB2l8fkKq9C38DaUoZ3SitmxdxQXG3VjkLiYGniYF6MlMeExnwWpYanlVmsHCIE6xdRpIwznE8W/RGf8nZHGyu/I1o6OqgnvTBojJd2rX0swtWQNjDiIzSAfrUU1NkksVKrbBo30pq4IpETfQZRRMusZrAcZdx6jjX3uZzVq00sFzsRknqP+CjMI3XvxgMz1UuCCTgCCxh6RcEOnG+IqGLhDgp9wRaOnA5QMJOD4CPQ0QwYRzfNmDj/fzBMEeuTtUPBDpVijya9FP0lKAhTBte05
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 05:25:58PM +0100, Catalin Marinas wrote:
> Does the memset() post sharing logic work for pKVM as well? If nothing
> clears it, we have a small window where guest data is leaked to the
> host.

Same question for RMM? Or did they define that the RMM zeros on these
transitions?

Jason

