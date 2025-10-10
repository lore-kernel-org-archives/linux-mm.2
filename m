Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE60CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDE68E00AD; Thu,  9 Oct 2025 21:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E528E0002; Thu,  9 Oct 2025 21:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 545B08E00AD; Thu,  9 Oct 2025 21:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB208E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:18:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA60184016
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:18:30 +0000 (UTC)
X-FDA: 83980444380.02.86B572E
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id F171E40006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:18:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QWR2JFuO;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059109;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HuuNyQUeQERuEHORqqgvkbAzAvdv3OChPVUcQyJiiVo=;
	b=yohs6f0qDeBb8dX12U2BadZrKbu9fZNinY0dvkP6uxjeyqiDZkG5EJyGeNxLZOFN/SDqrl
	mlehDaJSs+Qwue5M416xcq01MLYeLmA5l+w66NQ30o4jzpJKhVNYehM5rAvxHtb5UpzU9B
	cZBVyH6zXN5r66gv1IZy98VicD+LJxQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QWR2JFuO;
	spf=pass (imf27.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059109; a=rsa-sha256;
	cv=none;
	b=KXHN95ZV87rIyYPDq2W4wVVbbA97AXgWHaubcZYCeL0j0Q67QC7qPpBiSzpxykoznITeiT
	y9NBiNJLY6o5xiMZmafmBQKrfbFmovEGtx2ZmjCfAIo7BOHx4pfwHbkKXYdyKPzTpVTzmy
	Rv8ITX6TiD088cAbdN/qml3irs8sGCQ=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3e7cc84b82so296969666b.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760059107; x=1760663907; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HuuNyQUeQERuEHORqqgvkbAzAvdv3OChPVUcQyJiiVo=;
        b=QWR2JFuOw4JZ9PwdDOAMeMqPq7PV7Dc7c9ThDkqjSU3XUQI5F8zgBvPKeeuokVaV1s
         YzevPNM4pcBvkO94+uKT/QHhTIbpl7FbFw6JAF5HgqcYdqxEIZ/ucWu3bv5f2Nv2g/85
         9KSa0ziy9jHaQmyM+LKW/wtIvm2BdKh8RFnXnP3PUhqQP9QW9m1mYmy3gNuwNQw9F9vy
         S93Ee7u2yhEg1uEKkX+j3AAhwKY9FVsSwN2p/jrdGc6Utjjj1Y4zU2pxlNpe4NjDtooU
         F+k3fnPfxDidrwR/bAlBDCdv1eJGkqgsMBJBKWvKbHOy67lymZIjlG43/CgNst4XWHpq
         RZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059107; x=1760663907;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HuuNyQUeQERuEHORqqgvkbAzAvdv3OChPVUcQyJiiVo=;
        b=nNzsQh39L8Fs0mRd3dEGMRhviL4LDQHGT+ME88neN+UytfFwsiHmao+NXXjI4PJ1xB
         Ol/S1AxfTMZwHx2E+R8yANKu4V5FETQV6XBiSWAjRjieBy+pq/SJczyv3Rb1g2QoDOCk
         nnC5c/eEz7GiFmpOZsf8fbvX+55t16PZIhcnNUU1YGY0FCNBngfyS2MJBMjBA0uTtIpq
         Oqmqeegsq041t9hR0NkOWy1sptklbtmkdztTO0sQzxU9n7qZXuIUkutXRhfwOu2X8eTp
         nLGmLeR3bmDwXLcaCnZf0RDwhbqxEzmVK8K60yvjYBjd8wfw8diMvNU3CEf63wWB4hN7
         kYYg==
X-Gm-Message-State: AOJu0YwFtYvEGKrtpkZMLFRRvFH3WB/ezavgzrzQ5XnAkkufVzml9jNv
	WgM/yiXD6ZbMYXPURrJP7U/tL1sl/RDjN9/hMZmxEZJqi/J544CG53yydStdYQ==
X-Gm-Gg: ASbGnctHrx+w7ncqHtooE8e83ufqu/BXxsu7+5QLpA5rf6Qpr5K/SY4dS6mR4Ha58f6
	171MR/FTOwE6ODY6PygGMRQ9NIrcNLVEaJ/dwSdARZIAPvmym8V1TKcp7QEa2XcfZ8rtmltV5Gx
	d6TqmzTLOUfIch1C/wi2UK2981OX7c6HAOXa+0/FsFL4nbkYhl9M6ANhY4DXClxfExv/7HchglO
	aXZw0BueKb0dy+R6QYsSpTXs1/+WCb3mkx5c2Fif0WEyjUfgCsNrPxn8zbndBsufDht41livnXN
	fbWg3z1X7mt243e1X6mkkwr7FCt20k0SgtWTWUvxT9XEq97kQkRu4XZlDepRtEA6MFd2CGbNNoF
	6OCjIkXW2RjwmVqh11tSzh0KKRiDl2YKf7OKm71S8tq2VyA==
X-Google-Smtp-Source: AGHT+IHWcmsznp9PDr/fojGUBUEOr4Rw6hfIt6/AHC2pNuXs/i+8fxKhoUZc0yew5l7JtAhQWD9juw==
X-Received: by 2002:a17:906:b118:b0:b54:981c:4072 with SMTP id a640c23a62f3a-b54981c4627mr476068166b.11.1760059107197;
        Thu, 09 Oct 2025 18:18:27 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d971ec69sm97255066b.85.2025.10.09.18.18.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 Oct 2025 18:18:26 -0700 (PDT)
Date: Fri, 10 Oct 2025 01:18:26 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Replace READ_ONCE() with standard page table
 accessors
Message-ID: <20251010011826.4wv6sb4z3sedpabu@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251007063100.2396936-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251007063100.2396936-1-anshuman.khandual@arm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: F171E40006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f3jebyow7fxwey3rtykcmqddoc43zj6z
X-HE-Tag: 1760059108-210950
X-HE-Meta: U2FsdGVkX19skWyoS4bRaJh0xn9aTlkCTAIKXrlf7Sdumz24Bx4bM9Mx523K1oYtsXWa+HQLDgda0RLoHt1MJLYStOUZARPc4D4cNKzevdjbuatlujxc4wZ9nxHHXHX+ALnB2p95wdjKPham4fD+b1SVnVmbdrULASACZRF/e+oY1vkpQ73gKX4chny5LJ5TKBc8nObI+6gg1IwQefXHXqEYFExsEVMx0kuFKzLea4XacXYdk9zK6jIW3AbalvDFsPmM6JkJkThtslDuLY2U3dfRLmvm4cOROLswrH0W8vXhKW507bqmEqZThEV9L295OdBK6r9yKq+W5UNLlW2eBvUowMdoiCoqeoNE25Oq2uNx9a7MV2OwaELqBW7eyWQlZRaTifyQl3oZ+Q8a3BE0hDiP7/J8EbZ3sz6uy9bJ/EO1LtNZZXIW3lM/CrDBaUsA7o1H3KEY8d+wN781LONBP6QOjC8y5QWUrT7N2FYb+W60/02zlAfQUYRYt5FtZlRy9DTeHu1kHih2C45JPmoBhIzZAy/PdPVllHcDCzpwPWWtr8QzBvDmHjllKyyfiJENu/X9JS8mCEvn3PYXMvIsHpo8G2bAT4/VVKhJB3oH+QYYvNag5vOskQlRMjkbM6qNqz8q/4P4vk1vRhmMyerDSbYu1CBH4FTLCr98+wwrUV8jxxyIFe8HB6EdTCjEz9NbsETjmyzGEkg7lxLzQt7vpsnNQUF/TaxX840bcrwgXDQ7Mx9kYg6W64m6Btu9Pigdu2kKENtS9lWvlqQGp7J3BO3d2+w34pd39HEh41eAyPqrhyA8FMBgIZb46Md4s2JyhavXmmA3lNrD1F3AeWVjoI3a+LHrXu9VFZvsfzkwUOojIUBrlMj6eWB0Tj/KlPamUlPWsk21GHi0HBr1mftkooq9aHh+uNfJc4AYs23C00sz+lWEpmeWxSnMCU93WkqBLxwnX7dRqxC3huCflI/
 eJjopBp7
 H0KUA/+tdP5iG702sEMFI2t9/y9KxCFphhe7zcSyTxLMsOcApSjgfj8rdLwbFR+2gpMCqbF4jjxLDLPo2+ePT4jc9icdh8uQZSaarWQpMtOeOJOW+JDRJmql66q7VUAYp0loNjJuUFmPdiudXm1s+5V24hTqTB80ubQhmrE/g2A9ftNEb22txYjaVIvMQ05Bq6UcFyBJnXtKU0POhq7dru4h6xATi7x5LnwquNuG2PLSXRAWJmv1AdQ2h0y41VdeiCzEIs0mN3TCtniSfJ7fWe01WPQyiYR5H2MlKooaQ5GnsWeqp5UqOi1bcxiHvVKP92XUhJuMZyfnQjQFVnWxAa4jaWVda5gBX4NZMn/QuqT3P2QKmOmLvptgmfDFxY3crQdtcI37uqIAYixXv0xmG9d4GcKAnr8HdwoJzJrcoKznQpvX4NE5wVzA14c8Mk4X1BT2qbPwcjRZfh0F43ZYq43pIXMbWEEjDAFmqNUccgZqIB0SopAuZwfV2CpMoLhUA5LHKRx4IcfsSV4CWZ8UHNGRFmyW01syI+Zj0WxhKvrXDQvPda+RyPtnmQM2mIfJlToCOHozdvP0rVtXUrGxL+V2UONwMmZH9opA1n4wXEtJugnCEFk6XIUoghwaeBclCugWLg+Bajpwn9sdNo7qGHTD+aKEU+FIWwZODyWHCVUVNmldEeQvuvIqOTPAMHYiu4eno44fNIiW4qRfCeWx/PMrmbmD5kJyBsQ7DR9Cp/WNSwhIwmmHcuRNbhTpxiXlLlyhkcIxg05qYggMe96/slxoKNELWJMVKTbBeaf+HXCJ4U4Ph39I8Yk79gJNAadq7OKXWI6BWHjnQMFmwwxU0H4Nqg7MUSfUQOayZObQN7aYQTv7JiSbYe8HLwxeju+9KP4j8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 07:31:00AM +0100, Anshuman Khandual wrote:
>Replace all READ_ONCE() with a standard page table accessors i.e pxdp_get()
>that defaults into READ_ONCE() in cases where platform does not override.
>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: David Hildenbrand <david@redhat.com>
>Cc: linux-mm@kvack.org
>Cc: linux-kernel@vger.kernel.org
>Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

-- 
Wei Yang
Help you, Help me

