Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0585CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1FEA6B0088; Fri, 29 Aug 2025 19:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF74A6B008A; Fri, 29 Aug 2025 19:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34586B008C; Fri, 29 Aug 2025 19:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B204E6B0088
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:36:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44CD4BC325
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:36:27 +0000 (UTC)
X-FDA: 83831406414.06.7AF14FD
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6983580007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:36:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6q1yaS0;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pyvu2xGKVlWNaiEYBrfW6GEFqLeb6YKaM9SHto6H6I=;
	b=PhWWvhCdl+LdlTBhM07wszrlSx3KXN4udHGrS7HEGBFGp2k91UkYtCRXdLKP0JwgiZaWvO
	d3StWfOtUJV8GNkILy1ngGfmpC5gUcEcIRHRTVTZ5esw6XggoP99k3/AuYnjUxwTknP7Fb
	dtCpSwmlVEC3P503e6BXvDSIT+iloX4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K6q1yaS0;
	spf=pass (imf30.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510585; a=rsa-sha256;
	cv=none;
	b=YwH/yxyApCh7ZwQ9clGS+fjducGV0Wsb6uQETysKhYSOrmQoVrf6lr5cNC7pEaWT20YYmk
	+p7Jm9npoQF3cyH8VlQpzwFDu35aIGv22l5vHQQZyWvIRbGFGX87CaMYURXVzCSYGQosUo
	AW1hBuIHWbQb13Dp9Lo4lN3jt/Et61c=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2487104b9c6so24395735ad.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510584; x=1757115384; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2pyvu2xGKVlWNaiEYBrfW6GEFqLeb6YKaM9SHto6H6I=;
        b=K6q1yaS0KQa2v8+7PDhgI82V0NQo7YsbW+HsA/TWH88rB2iTkVM0Ke4cUSfjk6G8Ng
         WmBc8TPeV8pDiK4y9uf5JxabSk/JST5AVc3S0Nax8Wv8VNFv/pFJdCRk2F/cOjQjEjf7
         jvAPc5c3++if5mZrvxVEaKga0uENYW0Y8bW2c1WP59kzduUDyYFSUWaBQSDD5Q/NzMy7
         MfkDjfAZbUuhoktjdrOLZwpNhBLVPmZJp4nvWkx25Jbzm7N9rgByYdna+Q4gG7QRpNLm
         wvhucbetu8hF8cGKr8diAyrccJjcAXGajIkgx0aaWIh/KB+aXj6GfRqGGFdYgDtDqjF8
         xNzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510584; x=1757115384;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2pyvu2xGKVlWNaiEYBrfW6GEFqLeb6YKaM9SHto6H6I=;
        b=mAAd3yFHGkiFh8OEtAlH77d7BpdFL8laLjie5ky2mfOI2OQfio/N5FrQJ/vFdKbALD
         m4Ghg0VAELG94o3Kc4ioNjEtoAqrxn8qrQOWegDxoz0BgJ3koTG9j1OBcdCjFaJv7GTZ
         EYUvo3BayZ9In4YMagBjjMvOgITX5fY2AwS0u7wm9bCGqjiSGWXFmq91VN61jSCuTAF8
         Iu852kdydjYSuf11PHszFjiyc4x+XQCugZkxSaQq7vj1JGY/U3GN9UuU/f+F6MYu53vk
         rClHkshHD59/R7YOZUD7QcDnf76aH/iAqFrKzrvOINOAJdIHTvVMBmJxL+dx/AkZQZrp
         5K/w==
X-Forwarded-Encrypted: i=1; AJvYcCWnLFep3/LsAEIzh/+prB4DNkcJ4NQK6lFjaqVEd/QjQ4L26Crg6p3gsf3civ17EmXDY5WTOuubZw==@kvack.org
X-Gm-Message-State: AOJu0Ywwf17DQd/bzbhyqJo1exfZNqo/fhuzq2IevOOHByNighKArVx7
	7MDLsxbxP9OntnPf2OXYSMKEd18wsgdvfY1xEYTJyxjtGmVhJ69LDbYV1X0Tnw==
X-Gm-Gg: ASbGncssv3M+mVHr1MOwkxq5I76U4yRFnyNVfNTVmwZdTb7cF1emNvtVCkPWU+XZt+R
	dSU/FiJybqHfJb44z1TIMEqcvczG9a5OuuN/Zx0wwJK8Shrh7TbDfG/PPz0TkgugEvnSq4AXtwT
	uL6Rpvj8YYZekCYZ5J5322DQQC0ydOFY4GUy1BJl+5fVIxHgqfkLGW/gRj2q7RJuodokp3Arw9W
	YRSeStwUoh2GgH+EUpaNuoMAt5ZajDQUv70hGcsGIuhy3v2mbcspY5qcn7elgtwfIsw3vpBUkiS
	yTE8ddrv6gIBLt5zcbS3rxdb/kKq0YucOAWsp+4VP5pspS+cbVWN24nVr4eGXcjsmiS2xsci0bV
	o8QGemyDs+RIOt6fQXWPxUh3szjzUBd8t8fB9zbKkpm/hVSkUCcvezA==
X-Google-Smtp-Source: AGHT+IHoj7XG0pCPW2nnB7qndBOFkXszkOLOhhVnZ6fRs9lOoYLbsN3EfLhNuZ7C+p0VkOQeRoAeng==
X-Received: by 2002:a17:902:fc4e:b0:249:2caa:d5cc with SMTP id d9443c01a7336-24944b0d1famr4223155ad.28.1756510584188;
        Fri, 29 Aug 2025 16:36:24 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249065ad59fsm35658045ad.123.2025.08.29.16.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:36:23 -0700 (PDT)
Date: Fri, 29 Aug 2025 16:36:20 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, david@redhat.com, axelrasmussen@google.com,
	yuanchu@google.com, willy@infradead.org, hughd@google.com,
	mhocko@suse.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com
Subject: Re: [PATCH 08/12] arch, mm/util: add const to
 arch_pick_mmap_layout() parameter
Message-ID: <aLI5dKVl_7bPqB57@fedora>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
 <20250829183159.2223948-9-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829183159.2223948-9-max.kellermann@ionos.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6983580007
X-Stat-Signature: hdernyhmyjgt7wcxztxfqbzq3bar64dq
X-Rspam-User: 
X-HE-Tag: 1756510585-269418
X-HE-Meta: U2FsdGVkX1+6aDEYKlU0yRFpiO2DHCPXE9Ay30RnmlWn91H4EWubZbn1QV2mEnOaKt5HBspVLJPnJNdF4ZGyTCyfj5hEpGH/ZLuceeo6kign+k0ef4StAFdd1zVGBdXkfVdYQuwRWjMxA5Hc65KcUxC35J2Ew6LmCnFqPHx/72iuKLzZFDD+052MaNGOHPtF5rX7qSN+TjtwtjOhXwqA2Oc9B5F9NeXEeqKzfhZzV/JAeHh9jjdQjgVDfK2hzXVEUhQFe7rGoLMZ1Sxlm1SBoaYtirVTFp98K6jgWnWLv06QyiUKuWuQTUpEh7BLcoPwIpcKdeymHAYHvn6zh9dAfC9ftvenrkkxqOVMOz9pa7wvgHCTuKHvCdWTIhSeR3KhtHJwwiT6K0xZiq3ojuSFQQDyRVM87/8NILan5Y1REBepukW1UrTxMIIXRgUpi2Ofb36WqXnNVWqNqSTm+s3rUB2TpOUb+MEr3QRsueP883ilu6EhMJ954QVObDoJpaFTxjeyw0WQ80+PLM2wKe38ILt9G+L0qfVF7/YJo/bxcUpGFENT3FILyIB64alLLq3LuRnx1nzo0Y8kZ5IZIrUaWY6x8TDlMqVxiZ3qnFEnh4heWQVmxUWsaMnFHk6HwOD2ef+9rLsNq4VUwbJCvFBm2CRLNWygb1p6GoGN5/xOYJYB2WhjvybmzbaXb4CHCIadQ6G1ad1I0gaOQAWwN+quXP1S58d4X2iIA9n+86IXKk55VmcawNe7rS4VYGUwl9yPr1DbWEXeXJDBVKwHkCgL96niUQgAfVp+O4rJ84r8KE+9eBNdO5Qd9cVcIR79/HBKLksUQSeAAiBy61x4GKFcX1HdaK2Sn8VZuP0j/zRTxcpPTX1adBtgjOuXWRouKmZF3tmw8k1PaG9QcHB902zfTdrwhj2jaB97PpNtQupdAMkHmo/uejyPslaI0gWMAV9YatvdP5D3tpp0wVoBMbE
 HR6ndTZc
 wobDlYlNKv/1+BlqsbBn2gGKILQdyfB7sWQGLQQipz9Wm1BGuBDDT7umcIlVc6zS/ti/iLICjG/pmqNmGsAJPEMy6wE4SQdfJ6ENaExW7FK4FSb+wpuRgfajJ11NqSpGH9DVc2mtXHZG6h7ubOOKaHFhZVgh4/uRYO+KST4JgXvlGAkvbMYSdOU/besElRyKlpE4/r3pIPtB+gfUBiRh/KuIYgxdxqLo8CGYIXUzW1WTFXcCTRo1D27gJDSfK2Kkyh747bpVGotPXkVuS2/GtU5qOMYlhh/EWYi2X7XH7SFduzvj38l6CM7x9kscwAvDXG7k8eZESInDkX8n+zWMdnclprZIQp63t//UeWwZ4eoHuKrUSR9KuR8C7RrhKK4qSIons42NalqNMfYjaR7Ofz1fN24eOWMtgPW103mRk01vBCZe8q2r4BIxjVATlJi/Oj0NZ2q52DFqAxWa3wCw5vReKqlx76CfXB7zIPuRZdp4Q6zWv335oJoNrS5X4udc/HSmqbjac0FJuGHo8KVbiP/1gq27v1ebLX4Blt8HiDJYjPM38/L8lRp1mZnEfdHuqHrN0jAl8eJWiAU1VO+cGV4kX7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 08:31:55PM +0200, Max Kellermann wrote:
> For improved const-correctness.
> 
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  arch/s390/mm/mmap.c              | 4 ++--
>  arch/sparc/kernel/sys_sparc_64.c | 2 +-
>  arch/x86/mm/mmap.c               | 6 +++---
>  include/linux/sched/mm.h         | 4 ++--
>  mm/util.c                        | 6 +++---
>  5 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
> index 547104ccc22a..767c5c26f9a3 100644
> --- a/arch/s390/mm/mmap.c
> +++ b/arch/s390/mm/mmap.c
> @@ -27,7 +27,7 @@ static unsigned long stack_maxrandom_size(void)
>  	return STACK_RND_MASK << PAGE_SHIFT;
>  }
>  
> -static inline int mmap_is_legacy(struct rlimit *rlim_stack)
> +static inline int mmap_is_legacy(const struct rlimit *rlim_stack)

Thanks for splitting the patch into all these smaller snippets, it makes
review a lot easier. But this function should be part of the 6th patch
since we'd want function signatures to change together :).

Once moved, feel free to add to both patches:
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>

