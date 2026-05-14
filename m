Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE504CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:08:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E3B6B0088; Thu, 14 May 2026 05:08:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076336B008A; Thu, 14 May 2026 05:08:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE1D6B008C; Thu, 14 May 2026 05:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFDF36B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:08:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7933214029C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:08:22 +0000 (UTC)
X-FDA: 84765449244.16.0260114
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id BB9EF40013
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:08:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QAgTfnFp;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778749700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/3eJRZXmPeJgjsdl66pfXOtXDBzINDk7PkVrFSfPubk=;
	b=j1v9fy09M8Ii7bIwhUpu0cTwWBMh5uHvsjkMi2ilGK9t1JALqkKOKpLg65FewaN+0N8NHj
	glZxWf9EQq6yFDIPER8iACZwUD1n3yIiJ36FPRiy/SliDzozUo286YvCSm0lIkTt8asZsq
	eLCYCKqx+WIfbtfVIoVXGsdskuxbKIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778749700; a=rsa-sha256;
	cv=none;
	b=GmoJjRZoAyDguArEZbDPUzBlAEcF8JNkc8a/AxML4uSwwhyGXVTgzRCIVMcDL7iyuZ3nFO
	axawqOtL3ZooqtsqTG5Kt50dyYoHHqPRuAuvstBeGlCNM2w9CxRnScpRbYOkKCvz4xorxB
	8vZsnRwkXwZYGDFjEqxj1U9WOhmS6hg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QAgTfnFp;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/3eJRZXmPeJgjsdl66pfXOtXDBzINDk7PkVrFSfPubk=; b=QAgTfnFp+8VyQ7uo5CLIiP+FF8
	RXHqPKgHkl+aUG8Pkxlt1DaSlyVQRjI5+dYF02G362oBSPRBU3i169G1XZIQ962XL85BwMpBWLxby
	YfbTb7NP2vQQGV2TRo2nR8pCvI+90EeXSdL5G7ZxxEREp/JzP75ja1x8tu39J5XJL/6bgZWVWb9g1
	pkgGnp3+Rt4kd7FW758wSlb0vbIQl3+0OV6A3P6qCgrbxGVKtIEyGbprVPJ8D6dv7Scg0FzL9Z5o8
	p9DcqK7NRWPRMZ+cfaGzGgVEPLlktOWbdwuW+2eSFLjsa04R4WWBCqU99bvWyPoAnXF/43A7jr5kh
	Rpi5JGdw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wNS36-003pSu-1r;
	Thu, 14 May 2026 09:08:08 +0000
Date: Thu, 14 May 2026 02:08:03 -0700
From: Breno Leitao <leitao@debian.org>
To: ranxiaokai627@163.com
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, 
	akpm@linux-foundation.org, ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v2 2/2] mm: huge_memory: refactor
 thpsize_shmem_enabled_show() with helper arrays
Message-ID: <agWQwpjkYOKA5bF-@gmail.com>
References: <20260513094508.50888-1-ranxiaokai627@163.com>
 <20260513094508.50888-2-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513094508.50888-2-ranxiaokai627@163.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BB9EF40013
X-Rspam-User: 
X-Stat-Signature: j994xgnb9ngdsrkmhodqhihiukkygx5j
X-HE-Tag: 1778749700-463581
X-HE-Meta: U2FsdGVkX1+59s9MY/pFKgVcl4CVpCxrgFK3EBOJRSdpNe4JK6FHEDbh1WSil+g4jsuDpXyCwIchR6hoyZN8RMQIXTeyDl+H9wlmQK1kA7KSd+qXgDcUwDFar6NW6ksHGhIE9B2Ue4Eb9YpuAwDAnE/cHKVo/hE/99/wucjHjh3Ke+iABBmeVYW+c1zFvnVZ6pUk7N+0PiNNBR0DFdILyunxHEW61fXzvriOuzdlZZ0UA1Vobw3DF9AI+4C6LQpsFHP49ABZPHayrFBROKHQiIuhu1RtwEFR2WfrP4oH4zD3xVmX8witZLaHrLy9QJeS5yOjvmqDspkZq1hRrMoV3ROyvdJ0v/PhI+8tBxJeNGdiAlH5fVLTj06pHJAX2nNtTIsYHCmAvg7PowH2dKFu5deTu3CRc6+3dEqF+8nPhEG865yuEls/rMyK4Ag03CT7m1Mo/eLLAHSo7wHmDhkCpF0LERXmcKj/55YPatOS4woX1s0+yRHqEVsiuzh3kER+IpIVMMh7xU7V/o/NQXSQVsaLhzUgxHObTjf7hohPjsHOk9n8EVTGM1tv4FBq7p27xUMvNRnO7CT66CHCxuxFmJuFkf2rgrkN1W0ubxPvppkZLTQTgWMltxH7Fg1rrlsfFOCoka0odEASSv1KHFE4YyPPHmXR8xD0A+E6zN174eCIz1ztFrv7aO6lIaSlcFTqChvmrrrXmq8UYe1ZSoiPG9mhI/mfxm6xawAb9+7vuINzSmjQn6OpnZaKwk3YP3HDw7RMzAjFN8m2icOwG/KiFJn8hu4A8Ag91es+C7yziYzG9xVEdfwTurn4Mz/PjMjbTidxVV2gM8j8pObGMKao4vB3MuUoOuBsavDHkNwZmLU0J+WpNu5v/ruErFZxtP5efAO7fOeriFjR9Bp0MtjXpeNQfmRlKVPcHyGG/qbjRRIjZmoUMc+faU4aB4x6/73h2J3GMFHbeRSKCnXTKWg
 BiYQHeD7
 HC9uK7PkoklZQS+uzKjSuuplNpYx13VNvm/ls98WZPv0cEMcfX/GbIGX88177hqiSIoFJAjF8uGPWI8GMkbDLqN7iq9asm/mD6fE3DzN+SgD+IflNgGZWOugfXUm0gb66GlBOW59sRyXcauRoFft6SxqSRz/qg8J9qMh9UuZbLKov1lfl4K2djP3yL0HfUriFKXqYlEp6DlIan4y/xL5qCTPxtTaJuQVZCl1NmMbLV5GGpGeXH8W48pj911CIIeEdGc4xbuv3spRrKjrmcCXL6pBmFTlb/v0WbmwlFrFOEiPMTFYxNpps4RzegShtd24fK4ldYVsQwReMumkOYnoUAFrk6ISbEnqvGxkdE+9Ntl5k+jY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 09:45:08AM +0000, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> Replace the hardcoded if/else chain of test_bit() calls and string
> literals in thpsize_shmem_enabled_show() with a loop over
> huge_shmem_orders_by_mode[] and huge_shmem_enabled_mode_strings[] arrays.
> 
> This makes thpsize_shmem_enabled_show() consistent with
> thpsize_shmem_enabled_store() and eliminates duplicated mode name strings.
> 
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Reviewed-by: Breno Leitao <leitao@debian.org>

