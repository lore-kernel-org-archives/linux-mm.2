Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EFFAC98321
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7EE46B008C; Thu, 24 Sep 2026 13:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33D46B0092; Thu, 24 Sep 2026 13:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CAF6B0093; Thu, 24 Sep 2026 13:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1A9F6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:44:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DA561C1C11
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:44:06 +0000 (UTC)
X-FDA: 85249379292.14.D70441E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 99CCC4000F
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:44:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjE6HOZw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790271844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5ArNHwcWBYufeUUVfio+CIuoxR/jqyATroHG0bR84M=;
	b=zpbMlVYosASHSvLl9wwQ0Ag0UQRgckqY8WCpqCj/QCbAZ027ymSWc4OiKadZAVsqExRCCH
	AqC1NsN9J9LbK6XiggLe+dw6EOc2GnDJ4NTnY5w4gjgoTDDOYh/daOvrN7xWBP2tYYVzKm
	xQ8UTj4tI6+AXnvk4K6bWuSGfSkT7+w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjE6HOZw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790271844;
	b=2O8eM2GIfaUe3fVjGYnT+7DNtZ5aRTIdECvLU/oX+n7q6Gt6uULwI4dJ0lOtZ4TML2ptXS
	JUI52nnPxIMteV6I2GLO7vVM8MOT0V9LD9YTPJ9MnoWo0fw90rT8pX7JSDtPMaathBE8yi
	e5FDwRlrgAAI+VISNxhOTFj8UaK0XQU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD3F6601DE;
	Thu, 24 Sep 2026 17:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2CE1F000FF;
	Thu, 24 Sep 2026 17:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271843;
	bh=J5ArNHwcWBYufeUUVfio+CIuoxR/jqyATroHG0bR84M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kjE6HOZwwa76LjlkLbrEhuPY/o7DtEJn2838HLsIXizDlIg8RxdGP/Z3wdp8BS4lR
	 IsttGq6WSgWnsMwk5daXedqSorQjYOL8cufdC/ylS5+YmUaROYI9t1nG1fDjMFph89
	 Bmq3Rtu7gHua4XS1uNeYGn9vHUOcXkmTDLb6dcB0zSKI/z4h1APbXYb6/LTyc1x2QG
	 9XSN3eaGiRTqSD9/6tyW1Ac03hYTaV97ok7qIqOZJjJQrWKQkCddo1oORA0QKCcUo6
	 x6DvhdgaI+Fam4BEYorPHPtL3vNZ0pipjEv9Gew4yHxax3Rul9EHXi5JtienoSJwIh
	 qqRMVtV7pj5QQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org
Subject: Re: [PATCH] slab: Remove slab_folio()
Date: Thu, 24 Sep 2026 18:43:58 +0100
Message-ID: <179027177493.3334379.10149005639146922303.b4-ty@b4>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260923183655.3364885-1-willy@infradead.org>
References: <20260923183655.3364885-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3o8z17t3dd8ee7jbyjdt8kji7zoduzi6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99CCC4000F
X-HE-Tag: 1790271844-491938
X-HE-Meta: U2FsdGVkX19dvLE4IxRlSPBBLe9qlJFiIuTvw/wpLkPNzLrg3OKqWuVuCBmytqdWyX8DB79oqWnKNZiR5mR14pllFV20vF6q52MHgiz/BCiG55DS0WDVLfxV65K87tn+4UsLNIZ+aFwY880uX5uXMVGv1MveR2kfq/icuAx9lBXBVoUSJaSRZ+kn2gm2r0qNb+7SInftOqMMB3AxeyXi0sLW0MXpPZmWxnxCe54IU8aL6jDcoAzzy80P9OT2e3qrMknwjFbz2aq4n/YcEtpH9pYdjAvhgoFCslIq4iGOT7PaZHl28zbyEbFyi2wa2BHTFuDZp9lGbk5k9XSCAkpCFexJPdNsLurjSeOcmSFcAjtwDSJJ7Q+6qD4IS4QExy7j7WR4oHFyhBkmjjVdfWBjF2YZEVIClPaYeY5TOVhcPqF7OZ6zie60X9gs7fZmdz/3gnH1jPw9uMNT44BG1HaZM9y02qfcG+Y2ddP7dL6Xnd2szDqy+nEMsdFinEEHubAk4tJxck/ACko7wEd9Gmz862zwJ34ykGywMgX6AZVB6Haj/gfjIN2dRH2wvnUfBcCiTnk1/D/4aaog1h7+NJzAFN0LZgpwbN9iNbHPFUDJNZQh/dKi1iaTQw6s0+4Z7xwRxIcDLgKj7WGR+4WkMCdazGJdhGhmQrN/DGZ2zQs0V2hfORPTAV/vLBAb7LQOYuON5VEsikPltAeMseE9cT3m/ZeL002onoUysHIf7XW+OoIyp8KHSrGzizyVpUOGYd6GKm+GfWI0hxAdUwAYveeuEZh+REwG1CtEw8QmZGxAqd6v+y9pLjspMH+S/uFL7x1rVKCMgj08Nj2pQs7PCVi0TAmTaWi8k+YvjSKFivC2zL4wpOl34AtRMkRaE/EDQUNMSpdLLUtiL7mtnJubGYtGNnvOpBf9jNnTrqPQrE63kIpi1Hh2/EaX/cse/i5Z0dFYJpg9UL0dg7g6+9UvABO
 EIr2V801
 jCS2CQBIhFTFcqViS9aVGmpcub5l3H4H5oaxh+tDMngVwGyUvhG7tvY/+bYHwD4eIbtnaS8U9bCRUi3sHT1jRhXGbpCWzb425jNSnKcs5H6vy7WGnETDRIK/5EelwFCHKZm7ZBMh6BenKwbZ3DLWJ9frnoCo8Wk16tFZFsm3Dn/hto/skegxzQGsOq7zMKtSc9FP332KBQXtXaY5bLB+3rmWYQ0o5vC2mWbdc8h1tkTlLoX4HBEFN+FM6t73i+r8IugcmqvZ3axlLUuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 23 Sep 2026 19:36:51 +0100, Matthew Wilcox (Oracle) wrote:
> This is the final step of divorcing struct slab from struct folio.
> It's still tied to struct page, but there are no more mentions of folios
> in the slab code.

Applied to mm/slab.git slab/for-next, thanks!

(Adjusted "What I meant was:" part)

[1/1] slab: Remove slab_folio()
      commit: 662d8eb097ec7514091bbcf5d0d776890c3d1be4

-- 
Cheers,
Harry / Hyeonggon


