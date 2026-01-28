Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45A45D3F099
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 17:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE8D6B0005; Wed, 28 Jan 2026 12:09:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7C986B0089; Wed, 28 Jan 2026 12:09:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9887E6B008A; Wed, 28 Jan 2026 12:09:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 88CE66B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:09:33 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FF7313B9CE
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:09:33 +0000 (UTC)
X-FDA: 84382009026.29.DC1C177
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4267D20011
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 17:09:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8wjMU6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769620171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woWMphtL6JI39vS+sSkfmxpX289n9hduE+Y0HRvqh4Q=;
	b=1uNSN91ROzVnzZmnP+4MIvejPWSBmZkY9fAA19ySnVAu9VhIX1xwx3L7GiiM5og2byyr0q
	P69/Q2NymOH+o5CBhfYNqAFFViE6WQ7LxmUHeAIRdPNbh7GgFrex4mv8V0rxy5ZPtEHN66
	1Ec2+PnosAGEEMFo5jc7RHtrhx8olNQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769620171; a=rsa-sha256;
	cv=none;
	b=SuAXe65HApS5/X+kd8WUKBYxgXs02JF1ZXW3Fva4XkR/sQ5nE1Mz8+Odty+MgxwrbeBfx1
	rvHhPNkO+9Q6cALBu0U02DiKOvoDPPmz1Q810mcT/IM/ThC8aMQp/ow+A7zH8Tmf/osDp5
	6a4AtFtRMAjZNJlH84yBSodBc/oPNKw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8wjMU6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50E8440A72;
	Wed, 28 Jan 2026 17:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46680C4CEF1;
	Wed, 28 Jan 2026 17:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769620170;
	bh=KurgbNWJTQ5kVHItAijM0+vAimABKdpO5fQ58fGqS+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k8wjMU6KKCSJVYIslvoWlpQaHMY61buvhCnSS/F+Tb/GAgRL6ZFcfVnRfFpGN3piZ
	 lf+UnGKnTP/KNXPiESmk7aYop4ZXirYbtEFuk6JZmlx5AvyHwxonlWvTKyZUbVtZN8
	 jm817GKyixqiJ/03k8xHG5xT/I8a9J0hqrmE0xqdymMNSzFLinCJkw2vVz8LqAi9b+
	 3pKQ9dzb9ClYFTyfZkDm5hHjpRiBVbaoaB0Ob29wmVAf/m6MIIubYiHPTGlT8ZmQou
	 1geRIM4fXZQFQTqacXgTvGZOM9/nMghsZrcqM5xeRFSh3UxjUL51rIcm9UJ0hnqIbX
	 3enB1EVt0RgWg==
Date: Wed, 28 Jan 2026 19:09:22 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: cma: Fix stub for cma_skip_dt_default_reserved_mem()
Message-ID: <aXpCwkEBZMMmDAsR@kernel.org>
References: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128-cma-fix-stubs-v1-1-e07a077d5b33@kernel.org>
X-Rspamd-Queue-Id: 4267D20011
X-Stat-Signature: kpe3ueuejzm5j94pyq6yqxmgrouicsdz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769620171-67475
X-HE-Meta: U2FsdGVkX1+a8I4A5IhWgMuoDkx/ASlf1L0bZHoQBhKEnsgnboVGz5rCFixD4z37O3zgBmtJCqNoFHz1iUYQ0Co0ifthFn5XYBHYv3uLz6QEeAERd7R+5t07fQ9H7ydstjBQGmBlYjBtRyvQxli+WtK94sM2E0gaS7hmf71i1ALNIp+h+Yl7l96rHRRPCFv8u/LicmzX56ZVYh52PMcDTcnSl530RRhLwL6UkIQ974+exumWusOCMYAYFd2sUJSfi8LR77zeg2ywtIeLsyTyXDvvsQ1KI1ULK6jzz2WP4Km3zivtKsqKlOSrRpbJYmY5J+/Ng1tj3cXR4DvL2R2GyZ4MdsaKmxTLIeYFApQpLYXaJHJac7yAQhoGVp8OUNe68hKMqY2ZLB9T+7wjMgU6Plq+vA/+alW2AjE7o2jfJWaC7EO9YX7H+PmulpssjwRpU9GuTJLqqlrpXxjcMMorKjECdKoCvqrbzc/LAecE1RUrsOQwMFHYaKBq4w1we/Y5oXYMKPfIc7qB6nFHhj+0cLbaqgijrGrPj5x4cmG6/wrqOZjk1a/JUIRXuzQmlkVNFjMMq0W3JhEgfLmMlkmKz/KYVQ8BxaNq0lGXNbXiEHRn/nXrjz7qHGco6SzF9bLYQOB+cRpCmkIJDw+okEqAI3eJ+JydrccmRI8a1WhR4zmFpouYdDa5CjhyVWyulyPZKRnqEYVI2ZoO5TfzvyvqyTeqdTbebW3uaG1QPWE3X1ts9AsoPlcZze6U1G4bdmJwYJTloLcxQkBYmcwG27LeawlfIDZIsOmO5mc6fugjCVAdil+RmOlg+mdaCjZFWY4T/8/+N5AjVzUbWofCl0JsyK22Gt3YJSaH6GaL3i6GhirCcrCvtfawDpygkT7whIKd8dtJGPQlQ91Ia0TkeflGLaQ1FXHbLnID1oekFC+TtbSsfFSPomWebpGKDtjCsHCGixGIoD7UQYG6PCCRkjt
 Pzxu6Lih
 nCryb+n17IZsQNzujFx+1oocdmPBJNFT8yVxcgZzQjjqi60YR6TxsoUT4ACZ1NkGNFlQ2fJc1OZrLCu3DMFNLfkOZYgKyzEsRSwRLx9MV4GKPYFg0aw8MmQguG6XXutQqe+2xtITX/gYSm95xrfX8FtYBFshXTfhFJtQlDqQNEeQT/CnpZb4+opet13RRgAJz9f+gRK5h7vWTLkWal0rg+XoC0nsnSRuoDifeOtcs3iYaeZD9j0AygGu2gG9zyLfLYagZ5ENCyT8ZTThMiXXgyD7b6iRC4CuSU+FLz1IbinkW3VeYL1d6ejl7GjpcM/SoK6Iii81bHUWtkOjqrs6UuLcuvBFrxRXGqWwLaBa7YdW4w1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 04:28:35PM +0000, Mark Brown wrote:
> The stub for cma_skip_dt_default_reserved_mem() is not inlined so
> triggers build warnings:
> 
> In file included from /tmp/next/build/fs/proc/meminfo.c:18:
> /tmp/next/build/include/linux/cma.h:68:13: warning: 'cma_skip_dt_default_reserved_mem' defined but not used [-Wunused-function]
>    68 | static bool cma_skip_dt_default_reserved_mem(void)
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> which are fatal with -Werror.
> 
> Fixes: 26332ae848f08 ("of: reserved_mem: Allow reserved_mem framework detect "cma=" kernel param")
> Signed-off-by: Mark Brown <broonie@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/cma.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/cma.h b/include/linux/cma.h
> index 0bf408360641..d0793eaaadaa 100644
> --- a/include/linux/cma.h
> +++ b/include/linux/cma.h
> @@ -65,7 +65,7 @@ extern void cma_reserve_pages_on_error(struct cma *cma);
>  #ifdef CONFIG_DMA_CMA
>  extern bool cma_skip_dt_default_reserved_mem(void);
>  #else
> -static bool cma_skip_dt_default_reserved_mem(void)
> +static inline bool cma_skip_dt_default_reserved_mem(void)
>  {
>  	return false;
>  }
> 
> ---
> base-commit: d0d97f0b2b2b4633022dfaef4ac08af0b7917efe
> change-id: 20260128-cma-fix-stubs-26b13ce1471d
> 
> Best regards,
> --  
> Mark Brown <broonie@kernel.org>
> 

-- 
Sincerely yours,
Mike.

