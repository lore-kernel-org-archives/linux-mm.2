Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9788CD5829
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 10:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03B316B0093; Wed,  7 Jan 2026 05:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29816B0096; Wed,  7 Jan 2026 05:05:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27FC6B0099; Wed,  7 Jan 2026 05:05:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D35DD6B0093
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:05:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 676711AA6AE
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:05:21 +0000 (UTC)
X-FDA: 84304735242.08.5598299
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5825100009
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:05:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdYAnRH8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767780319; a=rsa-sha256;
	cv=none;
	b=gALOjAojWUmLXrfDPUS1GJFUFHYmZchugjUi99wJHhAK4ZPLT3DYw/uHzij9GxzFrPkTP5
	/DIPM0pEhXlcuDbnCJf47NfuM6BB3V1vTgAswe5ppwRWnsU2Tiq1CNZwV9G4AA0rzr9li+
	Mp0WLFAkHgchmSyQtYQe+CngmhrQvbU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VdYAnRH8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767780319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iu97QiSq3ywxpCKSUp2nAd+CATJG7zJQBoHGp1JnF/o=;
	b=qliU82KV1Y9YHUDLwW2NxaDz0snrjhGIv1A9xnCjUSAcviRpuFw37dHfnlysog0gE7gFl/
	eWdDliqzAxTLSFkajaRAoUy4oeDSRoJ2t9rHmbsDrijLREg45eGr7opcmk2dbIHzcE9O+U
	4IvOJhncUVkzMQEGZd2WTisu6UHpbcI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76AA6418AD;
	Wed,  7 Jan 2026 10:05:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09118C4CEF7;
	Wed,  7 Jan 2026 10:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767780318;
	bh=6b0Ia4FBMtdG/AVptJiOoygDqWfM74AUH10sV2SFuBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VdYAnRH85O6gLzZy0zTYi4YShlSfdLMpLTdb46LuuNIU5TtN/SRGIccbCW+Ua6B44
	 QPVCE9xS2DyUniq/VxcP0bA5RvJTafU/iIoFzPk68pxPpZkVVYD7VKVFjKLJnLwZ01
	 AhW2b7IP0F7xiCs0OsoOXLdNp55g1u68WNf7QDnTuf9+5T7ThLBZB6MMKkFG+SaUyG
	 8s1sPI5lWGc4jrhkfHBPeBWkI8acQXbY4J4L5TyKeMu5hawjtT7QOWEyQJPnMqGGtt
	 nW7G8XzNQoSMIA7Jmr5NCO2lyuXBsCKxkeOJBEW135kliJD69SG3y8CSDQCLIZxAOl
	 Vg88HMlZeMzAQ==
Date: Wed, 7 Jan 2026 12:05:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Lukas Bulwahn <lbulwahn@redhat.com>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: adjust file entry in MEMBLOCK AND MEMORY
 MANAGEMENT INITIALIZATION
Message-ID: <aV4v18hvu1OublI_@kernel.org>
References: <20260107090438.22901-1-lukas.bulwahn@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107090438.22901-1-lukas.bulwahn@redhat.com>
X-Rspamd-Queue-Id: B5825100009
X-Rspamd-Server: rspam03
X-Stat-Signature: drqr1a6dc6974x4g6bth6zwkicy7bzhd
X-Rspam-User: 
X-HE-Tag: 1767780319-442666
X-HE-Meta: U2FsdGVkX1/FJ7YLXFwNSNw/7/HBCSiJCS1qoqcd9LvLQfokebsplPETd7bxBi5g1SMaNM+rI6vLIH1ouQTh47wg+n96H3MynuQLOjfqTtNsH8kLpNXecyZ/7m0UnPvrlYwWr7hAXncyBGZ5hKc5buBkixn210TwhRytIg4VlRUibRAJ29LlkrtvjDGtu6GfNn5lgv38tLevCz0g300pa4Vx/B+vocHGny1pFmWO5o8sJgcUS4A97qRIyS/mOQhSU8ogLdJ9wQTKkJKoEdSrEMipOl2DW3Etx1nPXyOo64itizxJrrIB/l7idzIEnOWAo4PmBUkZ9Lm1CB+tTH9VxN7rqfmPekuVf2fW2rMXeHHP+QWeW7De/KZ8qVXDgNkjKnXGeWw8/gewqE8GB3mrhYOVVKfe6xa+4iakVl7NHJee0+BxDO1fl7nsSqO8JiYtqA6Y2ImeejJj0g917pokhpGlKEs4Jy0Drov1kS2A8taAqC1s8QFPpL0CkKa3Q4TqKXmf1Q2PXeayk4yxwCFNLN7MZDlkBWZ4t9xiqBkVDGfJn+l8CVWgdBUuAakF/SGqy1i05MDfTS3Yp9rQv17J8QmwsG4eL6gyuAxlSQsupeeyxfdf4D8YjC8781wvw76MYz5LHpqKit7HoVA3z1TIkOVK80PirwFRsOzmzySm5UmSJnKHOfd44oF1tMs50VWxMucnKDloqClHtbYVym3DgzpWaRvyiuxcafqybNviLaOhEtVGz2ETXxp394tQYH0Z0RCOxTYDEv3n7K5XjnEJDQACo7DJ3DaaOg8YY7oWXEFTqfIAMZE74sDh5IcXLt7Ick4k3xRqpJVMW7tWNl8BrN9GsYs9+5IS4d90ZMsVreXaZhhSxrMTkGJeceHdMs7yOmkosZYWnM5DBayxda31Ep3C2WYJiHFpcgagVpuBJgKX7k+algQ7qTfozMO7aB8xfoqWRBxK8fbXTjdxPAO
 3S+N27jf
 hBRKZdnI6fydUKenWEdRCKepgyUFNxKc/QROgX916Fx9eo8m3V9kBi9lRIXAIiDNzlQUH7YfFgj6unaflg7y3lQIDWZ+KjRXcOMzLHMpam6p7lwNuYxl4No0DxkTLYkgKBvnK3VRDGpJQqkp1uXLpRr29CChgd6A9IHRpOahoknkNO2VnB0DU8+9D/bYy+2lGQ+iYPCyOLCyPd53ijrNcP7BllyhnzYwfVU1qB8SpV26fY/XLDZm4eokTDdvoHrevgp2MNHmhrI/D32Ued/QpTuI5Ao2sOKkhyX1+eLF+rCUbf18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:04:38AM +0100, Lukas Bulwahn wrote:
> From: Lukas Bulwahn <lukas.bulwahn@redhat.com>
> 
> Commit e8d87911a204 ("kho/abi: add memblock ABI header") removes the files

The commit sha will change because it's on an unstable branch

> in Documentation/core-api/kho/bindings/memblock/ and adds the corresponding
> content in include/linux/kho/abi/memblock.h, but misses to adjust the file
> entry in the MEMBLOCK AND MEMORY MANAGEMENT INITIALIZATION section of the
> MAINTAINERS file.
> 
> Adjust the file entry in accordance with the changes of the commit above.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b28650893f2b..1ec85c68dd4f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16454,7 +16454,7 @@ S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
>  F:	Documentation/core-api/boot-time-mm.rst
> -F:	Documentation/core-api/kho/bindings/memblock/*
> +F:	include/linux/kho/abi/memblock.h
>  F:	include/linux/memblock.h
>  F:	mm/bootmem_info.c
>  F:	mm/memblock.c
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

