Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E998FCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 00:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7936B0005; Wed, 20 May 2026 20:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E3F6B0088; Wed, 20 May 2026 20:54:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CBF16B008A; Wed, 20 May 2026 20:54:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EECC96B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:54:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D4C91C145B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:54:24 +0000 (UTC)
X-FDA: 84789606048.22.B790097
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D97AE40005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:54:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLDTZ7tv;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779324862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d5rrceoElyX5Z7gN8RAFnZkqlYkvBiY7YEzCkRbKFSY=;
	b=hBtXILqLbMM9HPIJcXqI4exnCfj5hKZ0L0XJjuVMDsISf+a99zGWFpqu1BYYcKoVguFTWE
	Z9r/PJyVDgTGiGsl7hdUtOdnYLBuw8igRaIXEkhzONwjWpStbipOR6VI1XJx79LK0SeDVP
	/sqOvK+Gl4bSuwEO0X6xXEiI52ZnfFo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TLDTZ7tv;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779324862; a=rsa-sha256;
	cv=none;
	b=1PWbbP0Q7sLchQJwofskgT3l7n5+VTH7u7bSF0iKAH3t3jQFFtX2PBs06tMkNTlVM6EJ8F
	Oro/B3weWvf5ziG0d0bWKMDKKewl4icDDQVxLz5F9tSWKQd2MamPWxrNeUcYqMBAuvZHfx
	nA0quNNiZYfrUZEAQIj1+ggHNE7gFRQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4197F60098;
	Thu, 21 May 2026 00:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A191F000E9;
	Thu, 21 May 2026 00:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779324862;
	bh=d5rrceoElyX5Z7gN8RAFnZkqlYkvBiY7YEzCkRbKFSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TLDTZ7tv1tDWuAtn0VPJQOSMRq5/v2oWgVQFs23mffgGQ5iJdHzzRLW//6/Tbagjt
	 2WtVpFXgN18Q8mgVs56Ndi9uKqXkcFBXBzQImiZJMqX/HtHNURet4wknWBI9mJwnoR
	 L3bHQin5DKTOjrTyYcD1+V7T2D4OyqrQoQCppwxMd8uEe64Hdc4RlAhOgXJCoapgSR
	 8I1PJ/XQs770h0OyxxRVezwM+21rdKDS9hXXJyauDbrfKLOol8cCrQsmOFK8cWEUOh
	 hTAesDW5zeZlns8HUYLUSiyUa8wZxDpFDR/xfmMwrGPOlKMzEb7i+r3Sxy+KS5D9xM
	 pkzoYD2vSpFPQ==
From: SeongJae Park <sj@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: close fd on write error
Date: Wed, 20 May 2026 17:54:18 -0700
Message-ID: <20260521005418.84818-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520020336.28914-1-richard.weiyang@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qy48gcjehbq7zfri4qyekob6yokxtdby
X-Rspamd-Queue-Id: D97AE40005
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779324862-101959
X-HE-Meta: U2FsdGVkX1+wXvMjKLFQbzl2+AY6G4hVQ3Mxw5FUvZrqhvYqrCP9AGcRB63tLb4BnhNgfLq9BggqynlY2+HM07bUeOuW0uLGkOTQ9KmctEmh/dVdt481J2wLWMJSTVL1AeRkFNMA24FN/l6ud7ZEAjniCczMQWc8xxAEggKwaIGbaGO2w9ZAnmB9FhGC6fNdrR5s5a90HQnGKeQAuyweQ9UdqwNhjMSgkxBVn6l5QJhHpFh+7hLhUhmvsQ0JZfOSbMCKMhyoLHdhIIHMCgH7uRtll1cN0kZCVUeaa41RLV4VCjcJTsUcNtwhkpfiDTa+qhhoMpnIBnmmrt20Mj3Q8OrcmDbx7EBDGriR/fIyUic7JviczjYzirsINQvcCdhLfZr9sruHHv0z7wLyQeBVTp+joM9FUaCJ6MqBoqTKavXqLBooXKE6kAuZqgKeSkKpqAcVwK42U+pTt61faqNrCATVCzYkjkdAejYYkrvEPqJspMJUsul5TPaJQPBWtCgsiaSkaFRXJNFQJnSpdHoJ+iwz6/Z+nuVV1M55+wa9cMob1jeeGJ3rHozfK6oFLkIEY2p2d+3RKfk7fAAsS01SyOTu7hecfxo8DLhkZETCZM32dZcrD6Pw9Pm6C6mPDqRIvGPyn7CXKTSvHcwx3j1PnUgPrFyn4IdWTazJotfuTCpts6v79M7ds3nm+5VW14eaiGV4Q0KmyC8QRxrMQTsHe2a07tJ7siS1DC8H9buj3m5vdY/ffH9lGbstO3pX+Yo90zB5RNup5krl+W37nadvqJA2dIkDOTAslvm8CU3+IiwX0B43bySaSDxDPnBTBOx+OFMK4FU8VeFD2av3XNPCqaKdmnqNFG+AXTekVeA/GB0gWACYd8pbgLnoEIIRVULHRQcvEC56ktM15dh0npcvuJ86bMcX3nVm3M+SY40Udhs/ebBz4n5gPPTfaDZ3H9+vC6gSmFIqHR4Oy7TBsIw
 Fhh1GKxE
 PeYkJMz0EgEg7ZdZ2CiDtCdomBkL3Stik4X/8wD4PraLlVCrItA4zi8W7updTtp5tEofk6C0caxIufkCirl8DlLrThWGflyjHK6cy52hj7/zd+xTAUYg5nj6C0Kvbqu9ISYhmdXRZR5cOXOVQNgvpy95L+HQidNAEe0kKT5H5qjaiW3elXu18+3UPlWVCc9YP/6THtXVsp9Xv2oPjPc7HR6hMIXpRi5nGVaA4A1rsdJy7W7iDoefqybhl6ZPXiGKB+yLWgOzp4r7XeUvg+rWhkMSjfjxLy9u1FDWR2WJyo7N9qCMqdwnhQio42Bh3aG0G3yWp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 02:03:36 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> When create_pagecache_thp_and_fd() write returns error on
> /proc/sys/vm/dropcache, it just "goto err_out_unlink", which left fd
> still open.
> 
> Use "goto err_out_close" to close the fd.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

