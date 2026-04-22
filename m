Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7583CF9EDC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 12:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7BB6B0088; Wed, 22 Apr 2026 08:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 887BD6B008A; Wed, 22 Apr 2026 08:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79E236B008C; Wed, 22 Apr 2026 08:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 678586B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:44:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C8D6E2B0A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:44:18 +0000 (UTC)
X-FDA: 84686159796.12.3ADF5C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 703A820003
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:44:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cAd4B67E;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776861856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/lCen68XHl4PMvA6h4/jwc0Q1Yn8oPk+aLtQahQoBk=;
	b=pmD71AvXVwBmj5NbKaAFfxDtVR5kU+rD9K4hcZADp9dXRKt0mjnHI3E8lADJCO8B/y7W14
	IWTZWaenKEt6r8VSln3GfS0baVpyX/YthIb9Thh977p4fAhNbWpvl8w6ojBR4Mw/RddD5n
	B2hEqeT93qsC/7W9IRqKzzQGlRmKgFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776861856; a=rsa-sha256;
	cv=none;
	b=pQBtFG/KtB6F6xdrXEIqWfwKLI+5BQaKUmSD1H8xBoFkDCWivhCPAYGOLavDEA8aQmzCrg
	xx4hHnw2i7VenEEsZI1IM1yLhptCTmfzCH/EAIPjigeWHqJFh7RTXEQ2QWUwCT5JqhKGXB
	uRczAoIGibM+BQ0Ecwiusm2u8ghSGR8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cAd4B67E;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 888FB43A90;
	Wed, 22 Apr 2026 12:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DEBC2BCAF;
	Wed, 22 Apr 2026 12:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776861855;
	bh=9cHl0diwcKEB3vKav7ioffl/oS3DH9T9PGGKHFP4t2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cAd4B67Em+JJDgKcyZfqfbJsIn6GwDz4NX21pCWwKw3XPI1UNx1sxeWE+UXws8/Xi
	 4pH67x6cv7ZhXGsqXFdDIThIyN7gLW6dx3XFjTsl4BKllpD2ONXKnwK/iz4W7eTX+n
	 FrfB8aDnaetxKdZ/XtrEFyq0CbTazRLtuvXcfeqf0UyIzrPLoFpzku3cQdqIjHNOUN
	 HJpBv2aKjMVSRy4hgojh5oZ1aOGvXWZmOevAe4iphMxM/JtwYhf2sj4LmlqbMdC74F
	 nOrfURh7iKZOIne/h1YuMxfmN5ePHGckgEOWNU+GFrxf4UkuBQxScgd0cVzdNyx8lU
	 V4wOOn7KexChg==
Date: Wed, 22 Apr 2026 14:44:11 +0200
From: Christian Brauner <brauner@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] fs/coredump: reduce redundant log noise in
 validate_coredump_safety
Message-ID: <20260422-naschen-einbog-ed4f52ea472a@brauner>
References: <20260410080918.2319-1-lirongqing@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260410080918.2319-1-lirongqing@baidu.com>
X-Stat-Signature: kbq8dtbs5xxja3g9h7zf5rszuyz3qyxc
X-Rspam-User: 
X-Rspamd-Queue-Id: 703A820003
X-Rspamd-Server: rspam05
X-HE-Tag: 1776861856-369852
X-HE-Meta: U2FsdGVkX18sbQin8BT1gQnQy0r83A3/hMGhda9fsLnLL4l/RxXUa0MjrjA69Wo1EYIoTkz82Z2LTE5AmECPnzV/LMCehJ1sQszMcP8joIuCF7VhhEqClNzTmIUNHVLCpCbBsJMkyf0Z0bc4qeh3ukWRz2woVUZ0cSRpDuBR2gPJY09I3vC9KerzWYNsz7PLPulOnFkPp4mrA6PtcM3vvVALNBNCeXKQv/RgvxnTgm24yNA9fF00Y3ia54asJk4Fi6lrw1HK0MPu/ZFSzyx5JF+dAWKKdKB8XyUrtc6aTmwBw0x7EpA/9/20LI/gKKUcH/GSz5I7O9Ke7Rvc5dHvifXr5p5ZWu5M6JpjAK3nBtFeSXJdzCsR9EfjIHb77k+3UEbjmSVSwBtCHHtJzmNM5v9zOuRBPwP7lF84sl7NzvL5Ua+ixueseY4uztYvUkLqG5dLscoJdpTFWuVVQeCMlSzMGIgtBpJ/52lQGaXTsaVgBMFuU3EI4xyFzVypBDt5TopO+x79toWz6SrcAZzRU0SHFDskPkhrarWbagInHuQ1o5HmYDtbQFsHnnkpg05+pVhtyTOCxqFdNLKsGii4r4ErHkp1vKYYjSzyHfSDbnpY/iMPxJ1nVTeD4upR91HnOoj3Jr++VVYRT/nBrDYsNnkqyWAvow8YpNcRG91svy7T71f6icwZ2qXULCcCThrevMnQy9Zvjj6JQL4vMc51IRulgREvPL8xveIQ9H7fIEgG4M2mkOcWpPTewFYXDmgEo4Utr6jev27GZBkqHGSdR+aV+1E0MMR2dfen/vIuxQ6sv9u2GMDhVpSkJduO7TgFUNBOhCkj7GA5aMXUviMJ/Z8b7WUGSoRI3gfJ3bsS8kqaHMvyYpj39ZAnh6Z5j4CLZEc4eLNU844iLmWetS3ptRSmBYweV6LHU5mNLJoHzP6GVVulahFzYhmoIjl4k2ASQql4Ui4+UqcMioTOKZr
 EvwVMzvA
 4Fe2TdAELgRHOqV+9xg2IVhc+MtM9chGLCRk4oAoLkkHqt3OFQCUpD+48Z3EgtSo5T94wNDqQaB73/vxqNZCkUqoo7DfdHs2yxSpuu+U86cte23j85Slh+jnpFFYCgrUIY2m33Rnn6kFIIdroWGOP7sKul/kGI2coDCylN5iHmpQbZh4qCpMUlhcv+zkp+f7BjBsph0Lc1Y5UtYhwQG9JohuqSDWYiLM6V5wJXSsQ1I3sncB+LfPfKb7BimdWpFlDvoNiZDpaBWD7uqxbD2uwgKWiwEf5xR7tNljU+TB28CaOOAY5zpK1XY6LGdUPBdUM+FPePgmq0olus0CHegaQoIDbMUVHeUpN8blHMVLFYLTJ2H6lUe4Wvq8Hmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 04:09:18AM -0400, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Currently, writing to 'core_pattern' or 'suid_dumpable' sysctl nodes
> always triggers validate_coredump_safety(), even if the values have
> not changed. This results in redundant warning messages in dmesg:
> 
> "Unsafe core_pattern used with fs.suid_dumpable=2..."
> 
> This patch optimizes the procfs handlers to only invoke the safety
> validation when an actual change in the configuration is detected:
> 
> 1. In proc_dostring_coredump(), compare the new core_pattern string
>    with the existing one using strncmp().
> 2. In proc_dointvec_minmax_coredump(), check if the new suid_dumpable
>    value differs from the previous one.
> 
> This keeps the kernel log clean from repetitive warnings when
> re-applying the same sysctl settings.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---

That warning should very much serve as a reminder to not use that
completely unsafe pattern. So no, move to newer coredump infra or use
absolute paths, please.

