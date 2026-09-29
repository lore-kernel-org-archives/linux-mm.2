Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF928CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 12:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F05F6B0088; Tue, 29 Sep 2026 08:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0936B008A; Tue, 29 Sep 2026 08:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6466B008C; Tue, 29 Sep 2026 08:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E42D6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:32:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5F0214046F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:32:53 +0000 (UTC)
X-FDA: 85266739026.18.45F892A
Received: from mail-m1602365232.xmail.ntesmail.com (mail-m1602365232.xmail.ntesmail.com [160.236.52.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id D7F278000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 12:32:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b=gzhKioD1;
	spf=pass (imf30.hostedemail.com: domain of huang-jl@deepseek.com designates 160.236.52.32 as permitted sender) smtp.mailfrom=huang-jl@deepseek.com;
	dmarc=pass (policy=quarantine) header.from=deepseek.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790685172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0SVgsWU1lSvWpVjmKROD9e89ZMTCMvum3N438FqEq8=;
	b=ZJvf2nqRCcKDCkyhAMgX4aJjatQ0DybeZozl3ufz2GdipWL2oRonNRb8LfMJx+0VEIuAgX
	G5aoN6caSHxmJ75gNCQ60SP0rpzGTPyEsightqisJqVkPJIW6yhoo7t0A6iwqcKEwPH8gc
	oUOJAiAwfW+8R21B1HBCKGV3LBMgH/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790685172;
	b=gFLm8Vpk3zPJKiRz9FpXAlUEycKxPul025Ua57fBFPcV+TZyFUPLY0NH1rjVnl1ABpTKEs
	3VjtiMdCByBmzxNDQPbnjB6BVz7tLKYC1PtL7M8Ln/WeCqszTsUpFj/ius3oERK1Q9UZ8A
	9jR2rSpl7l+E/abd+J3zxXqEROf2/j0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=deepseek.com header.s=default header.b=gzhKioD1;
	spf=pass (imf30.hostedemail.com: domain of huang-jl@deepseek.com designates 160.236.52.32 as permitted sender) smtp.mailfrom=huang-jl@deepseek.com;
	dmarc=pass (policy=quarantine) header.from=deepseek.com
Received: from deepseek.com (unknown [61.164.44.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4f821470c;
	Tue, 29 Sep 2026 20:32:42 +0800 (GMT+08:00)
From: Jialiang Huang <huang-jl@deepseek.com>
To: lance.yang@linux.dev
Cc: baohua@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	kunwu.chan@gmail.com,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	mst@redhat.com,
	ryncsn@gmail.com,
	sj@kernel.org,
	virtualization@lists.linux.dev,
	xueyuan.chen21@gmail.com,
	huang-jl@deepseek.com,
	xiang@kernel.org
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Tue, 29 Sep 2026 20:32:41 +0800
Message-ID: <20260929123241.1408414-1-huang-jl@deepseek.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925054408.10431-1-lance.yang@linux.dev>
References: <20260925054408.10431-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0ed272b5009cekunm228468aa65c5b2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSEpDVkJNGEJITUtNQ0xJGlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTU9VT09VSk1JWVdZFhoPEhUdFFlBWUtVS1VLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=gzhKioD1B1uZQpMFbOo3brtYlrSTQQuk4RhuZu76oYFOEoxNc+2X0r83h+DMn8d0wDnVxAUyFWufPZPvawOvTRF0WwSWL//a40fpZzwYpaDzfSRnoMiDU/mIhuKP0h+ZpRi0wpdTIoXpnEsWJsZZ1n/Xo3pTBUOA1UoFtNrs4JA=; s=default; c=relaxed/relaxed; d=deepseek.com; v=1;
	bh=O0SVgsWU1lSvWpVjmKROD9e89ZMTCMvum3N438FqEq8=;
	h=date:mime-version:subject:message-id:from;
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D7F278000B
X-Stat-Signature: riai3s6wqk553popct1mpwdtykrue4kf
X-Rspam-User: 
X-HE-Tag: 1790685170-600825
X-HE-Meta: U2FsdGVkX19mvQkJHnJfsaNVZnDe95NvsjQGq3NOup2uXn0i8dZvX+J9onkfMeKfj/2W11MoOTP71Q8VLNEt7Dff8NEEbheGfL3JJlkXuYlqu7QGcyvpZ32xNGYmDTLVxRubsb4CmpjhoBBASQstIl1fSe1O2Q4J8bVuRjAaM9yZFvd6WIL/t2zghLRjBycGKr5q2Utah6xwSSTcZnkVAROnAwH009L1YbBnqZZFxH8Qg3bXJfXMy1NsGiF0pbIzeELJbvN1kIzE5N8k4l0RME/pFYhtBy+DlqvZPTtd5Ka4xPdS/ACY77361XyxWFE+Xxb5+rL+uuF1XD/2e98fghLMnqBIIR4mbPpVFjzmwx3ZohXUXDWSqKDdFCLvuH+HJhFk2RhuKfRX+2b7RGeh4/kK5ElTfhy4TvORhMkWA+Q9cswnb/cshjMjnS0O4CTZI82IhKgfPeoXV9XFW2WJrTLG8kgcKS0fmi6QOTHNC726Z4mj47jO1CD2WmS1kN1jiCiFXxc3HxxZU1OZrt9i+B7dFj74QyUz4A0L8wD/wu107L8ss4LbVSAc0M7/Y6PPSVOAaYEDzaIjY9AuetVHUT4u4DE8O2cFn0lincedPQde0N4RV/hYgxXo5AnxH6m90/nKxxkkP088lFyRNSM+HB447YXYfzaJRFB/1W5B26G/aIEFnQKbjLk0RsnEIM3gI5RESTFIdrqtDKmLFb+rAyHYRVfPpPuux1GloLUI5HujFpwcjDux0rPyPOFXE/YV4b5JFSsQdu6hPCdFrss6rMDBUafg6uV6opBnxPjNn98HLMYrmLpu+flz4gbDE/a8DRhBiPEjx9hT6bDlta8DUUgwyBfKMWCnQJbwLuA0h3C0gsuOGXQfolPVfwhOl6drl5X9Y50UjBrJddUUkD+pqzJ9Kxcf7lbzMGCRSmz69EB71lyylQ1amGygDsItR9Uqh1kkwepoiHd2ATfP/En
 dUhcbCcb
 6AVmKDosTOPxGH1rHNnCCel8s805HeIO88OYN0UW88pignBVHxaBAFCCZwv3U0c7vNyzHYEFHzqcG5vLymSkDwoks2TsMT58kUx665RUxV+a4KNF04OkMY2xHLjMBBXn0GwnKc37iRTZ/wtTrq9b9IA9qoJWkqhBXmlxS8dJUoiapGadEGl+ZwLdEy59EzliYAHeD5CcVsCmh/VoRzI7wcH8/kak6k10rdnTVXHg3FfLDLmkxN8mVCLRBSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I'm an engineer at DeepSeek. Thanks for the discussion, and thanks
to everyone working on DAMON and virtio-balloon free-page reporting.
They have been very useful for our workloads.

Gao Xiang wrote:
> It can cause sync 4K faults on the host in the worst case

This is one of our concerns with virtio-pmem as well: moving I/O onto
the page-fault path can introduce performance trade-offs. The other
concern is the substantial struct page overhead for large images.

For now, we enable virtio-pmem only for moderately sized, frequently
used read-only images, where there is more opportunity to share the
same host page cache across sandboxes, as Gao pointed out.

Muchun's vmemmap work is also interesting to us. My understanding is
that it allocates private backing for struct page metadata on demand,
which could help reduce the upfront memory overhead for large images.

For disks without virtio-pmem, DAMON with virtio-balloon free-page
reporting lets us reclaim cold guest page-cache pages and return
the memory to the host, without those virtio-pmem-specific issues.
The two approaches complement each other in our setup.

We have not yet fully explored how best to tune the DAMON and free-page
reporting parameters for our workloads. For example, the kernel's default
free-page reporting granularity is 2 MiB, which is fairly coarse:
reclaiming cold pages does not necessarily produce free blocks of that
size. We still need to evaluate how finer reporting granularity and
different DAMON settings affect memory savings and workload performance.

Best,
Jialiang Huang

