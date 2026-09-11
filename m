Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D5A9C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C4A6B0098; Fri, 11 Sep 2026 09:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC5D6B0099; Fri, 11 Sep 2026 09:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E2B06B009B; Fri, 11 Sep 2026 09:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2D9D6B0098
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:33:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FA59401FE
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:33:31 +0000 (UTC)
X-FDA: 85201573422.25.3AF2FE7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C8657C0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:33:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiTVlcZ8;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789133609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncu6ec8eT9DbAcxyd0iWWwPt3S/kddThKenFXEHMxhI=;
	b=Yb9uYYE/3WrojiRfr6lE45SF4F6rm3IHJ9f5JNLNIPfCCRBzwUX4pJON808UMCKlIEP7Bl
	5oXgoTYtdxMKkEAvtVCP5AmBa5YIl0kuAzBq/OLaUe8gr59OllBbCbVdv5NoEO8gEKKJR4
	/gHBAJkzA4DzvPSMVZaeCMzIXTfCqNA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NiTVlcZ8;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789133609;
	b=6JtWZGZU02fqioGNZh3AeXuiXn7bPwoxrEoXEvP3zdVKHVUqLJmaMTJjr7QCLeY4sYDKAv
	7b24YuZk2oPnLDG2kUd6SyT3O5r4JpM7cIBgDAxo80vH5GvXk3pnPbR0vAmp5K0xqAniHc
	auVmuNBD/UZ8TBm3x2kDT5V0lhZc1cY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D165A6020C;
	Fri, 11 Sep 2026 13:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522F21F000FF;
	Fri, 11 Sep 2026 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789133608;
	bh=ncu6ec8eT9DbAcxyd0iWWwPt3S/kddThKenFXEHMxhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiTVlcZ8udwhihsn5Yc6rp5/JYS+E8o6tyz4qA7zT5HIhe8ubYfMnd+lmG9SRIzx2
	 nggHtW+jBhoAgXGpER5ny4Z0Xb4xj+Sq1NpkKFkUz6EE+72gdg3X/Pu+BFUsbvZCIP
	 gx+2Ab4QF+7EzemyoRZnpKwyw9jTMwBVTe3RITK+CPohGDdy0DVgoaeufQ2u49H5Ap
	 ktoaWQ65dY7cX2sQOY3VAESmvh9wHNCJwVemAB7fZjD7IomyxkuFo5foSGL4XsG5l1
	 1M+NaJidWuLfTVPXg+M02Eu+LcJLmE07ji4ctaMPC2wjZGBBTg7fLCyAOgbxbW9kO0
	 qZNd40RFBzFDw==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH REPOST 5/5] mm/damon/vaddr: support pgidle_unset probe filter type
Date: Fri, 11 Sep 2026 06:33:21 -0700
Message-ID: <20260911133321.91720-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911020118.37585-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C8657C0007
X-Stat-Signature: 8h3hjtmx1134mg7w11hjqyhtjr6zj5j4
X-Rspam-User: 
X-HE-Tag: 1789133609-389289
X-HE-Meta: U2FsdGVkX18tcX74oEjI2uwnY3DdI7vaD+7ZYH+JQcZ7LcQdqqpi4VGIbTvAYDhMAhD5Y7Joo/qXF6366FiXZVs+QkaQRgYJYQlJDOA6VSOxIfUWwxuPAolX67qtpcoHahxMqY9F0073qVuI/Onh3Yem63zPXhHXVWgijjwGuc1rT6mSzsAQIVa13l+ef9I70V7oHMGMYhbqUQjRGER9KPFQAwnogCv1UzUkSkOsHE7pBcZQMJFOnFgwdXhXMvEQ6fwX0rGLRLaMPbZ2lOI12uFZ1TjSqsMPYfspZrB1YLMPYnAgCZlpEWfEFJdkLEVAVXQfHsy5pDvdwjSOjclnLDtSZRKbpXeaGnx3TS+Cxt4jsqTTYH+h8FAiA59gQSkjxUiVgkh9WahhmwXPr3GVbUDeUNvLBmXwHagcCofrOULGYaS/Cr0zYDSFtT5PHIOzeaJADCKRMWbqYqozZHHGnkjK/vJ3+jSX18RUlAvlY6USeZJj2KFKotz4b8qs12x8g6mjaiz4adqhzrXDjegPqF58tHzGI02u90xpNPTDqSAFLUlDWwrNC4PcXJCccLb0jIZjTCJXAfINpuw/t7uvCIj0SqyA6w4UOGk3C9+rRb8/fuK4/GWiwnsCc4wVbB1vK88hHcKa19+EJVe5b0dwLb9LDaiaoErZQdn+RCXkQo4q7oN5LirROwQJ0gDGQVUBeJVx5uKtJk46ogmCkBkS7sIh94h/bZNmbS/gVqrtZO8GGf6LEE4vB4N2wU3OwHGmJIPyD6rVCW8s7UT7AozLVhcyBaL1Zh3shk6kkSMQWfQU0XcfTKV50IxisGiqcre+2x2Wjbg/xVV7dgMSCAztnKpujppNukJN3M+5aiNkxa6xnSTGi+0y73fdFoyvObADvl6+vZWOZVNOnbCvPDQBpgYZ8OWnW07DloeadRTqmtt7j0EvAYV+U1rPnuDQdJegzMJ5ir0OHf+SPZQjT1F
 eAYZKfHM
 xLd3s0dM+JDtlnHg9q/gcOwf2B6f3PHtdWmtlB6bHOi3uBAXp51dy9X+NOXHC9ITKf9RE2LSJvnMnauDcmt4BXgXbts1Wsb7dj68hV2apdLJVaDRqvhK95pz/kZjUlz1s1rv8uEfIq0FSLQPEgt/aIRBJ34Ui0bofogHa9ZfITjScOHiDe5tKoMolDOh9fiHYvtFDeF1DGDcwtN3zr6aSbrBrQ5sv6yYTmEeo2XJ+UeeWez848hsYAlAuHyqnP86wVhmZR3bN2UVoYCIOd4uUKVVPvS9LwfsW3Mf0x3t/4J3hn1bqmZ61z3si2scfRsogdHIg5gJXp/eYgL/ATmmcfByqllQLFZrt116boalkofxduzOC/MTuUvthloM0mDJJ2+2HMdQ1BEbIovX24xzoamntVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 10:01:10 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> On Wed, 9 Sep 2026 07:04:07 -0700, SJ Park wrote:
> > DAMON virtual address space operation set (vaddr) does not support
> > pgidle_unset probe filter type.  Add the support.
> 
> This looks good to me.  Checking the PTE or PMD young state together
> with the folio idle flag and MMU notifier state follows the existing
> vaddr access-checking model while making it available to probes.
> 
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>

Thank you for your nice reviews Lian!


Thanks,
SJ

[...]

