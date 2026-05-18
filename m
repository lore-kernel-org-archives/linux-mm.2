Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0630CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 123556B0005; Mon, 18 May 2026 02:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FBA26B0093; Mon, 18 May 2026 02:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037B66B0098; Mon, 18 May 2026 02:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E79896B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:35:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8766691A17
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:35:14 +0000 (UTC)
X-FDA: 84779578548.04.9822B62
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id E0DE480002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:35:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tRr2S94V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/C0N+arb+m+gSg/I2si7mCdkIVLE2rJyxV1HRZw6aU=;
	b=o0RzifmIcx7xFOvM5MMJGBk8PJAPjeSMe7ld25fdVUszuEZV6Z9u471Tfccq1vxFDF0/Bp
	E4y40s9gQkgt8k3tG5HZL202Fd11H7NdZIsS59QaY241LyM3p31VoBi9colVbXvJVBlJDV
	DPRYrKM0qJPs58+f7GiJcNGSsbSuvGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086112; a=rsa-sha256;
	cv=none;
	b=E69j4EUYPeSoRnDzDuBoJRdps4JUNkDh3W9a2k/Kq3PLRJLj7bCOV80GvxqcxhnmxLnW7V
	Eqhvg3FVD5bGfe6ORSsrjiLfRBlHeWzZ8Qc1UemjmjXPeXhtg3xcVzBfSLJD8qhFnCsd+1
	tKmQDHdsjPl0R1o4T6X2zsuWYXCPSeM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=tRr2S94V;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf30.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J/C0N+arb+m+gSg/I2si7mCdkIVLE2rJyxV1HRZw6aU=; b=tRr2S94V/9gzkNxaEsZigw7CRn
	ByDQdsauaw8n8Rw+ZzhUJrUF8Nep+ykQ3Pym0rdPeSuD30iHYhuzyWCTMr9y381AMGBrjZkiMb52U
	Wtr8ynjQcVsHrGspB55IwyZ0We+wgvtXb7cnzPztQwsn5DrlixMUZeqvuW1rfptGEQlh4KqMMF0g0
	42nUDqRFZlddhLdXlqS6D1T57VENE/rzvBYEdmE9FZ97zbWMUEhKuu8B/GYFNJZm9FUeuWknKvPzO
	LYDiwUH2FnnayMhb4kMAMzWDCJOUcU2bwdNCmsjoGYGyMTW/oSsGTPQCDHPN8Ngpz71JNecyEOjkj
	h4ACJO9Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrZE-0000000ERUo-2GCU;
	Mon, 18 May 2026 06:35:08 +0000
Date: Sun, 17 May 2026 23:35:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Janneke Nieuwenhuizen <janneke@gnu.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ludovic =?iso-8859-1?Q?Court=E8s?= <ludo@gnu.org>,
	Rutger van Beusekom <rutger@reasonable-sourcery.coop>
Subject: Re: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
Message-ID: <agqzHDqPIBGuhtFg@infradead.org>
References: <87se7stpgy.fsf@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87se7stpgy.fsf@gnu.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E0DE480002
X-Stat-Signature: bij4h8rg9ubdwbh45agrzeitpjjmpydg
X-Rspam-User: 
X-HE-Tag: 1779086111-51109
X-HE-Meta: U2FsdGVkX18W88Y30rmuYX/6hGLyohe6O0bpFugqYl4t1HTlZLhZMxpMyTTNRrDMDFvYna+nfYNhE2qPn2XGlaU66TC6Lgi6fuKQSBuhIL2jZkcHR6/cc91ZyRmWZSsutCvvzbmSw7lLrYxxp6Ky/1L8zUrbr2wskUDBh2mAuMEBRooK3qp9I1Wae3U51rt4Atoosu3CaTh/+9yweb2tZl1zOwKffL9qQsNAngOWQXK77y50ZZ48cJqiraWpcHZEp7p83CIa3gSGtIg88P9GtYptt9cxLE2y/dv/KL/7+zRIXcl0OCT3waUJkAgWZZb1oYUal+Ei7SoQMFIGR7Rc4DV/k1ZVm7WgI9iraQ8M1dnd6J9vKr+oDKjjTETsC452/6yhZTOhq450bDgNdHaJg6V3YQKM1kien6UplFpbqyvM90QbSsoHn2Vdx1TOYudTtosFc3q9EyKnJEoroLm+sW6nsGPv4cbYbxDPqxTY43+vSGFPCeBwivFSWzA6LEQ2nwLHrwadZ3h/TWqy+PEoAk3ieHIUR9TKwWTgLP1C8WhokVa1bR2ESuGxn64K6c+3dnIAF15yM5Nif0YVEyV5q9FF9D51+ZEEmhkvT91I98Hi/te2ENPwAqDqlNQp6uNr4iypCLkHQA3fNCc5BwP1Pch/MvHdkZKT7W9PtM3AlKYaZSHCBEsrJNl6iL5dmk4zPuPw+Y8DxDxDnWE/zrKYJDBt98KMXwmqNVn1w6Lw6l9AQknQRvynHCdShWTSzlOoQA1NnVTuvrMTOFq820+ftuQL1OgyU4pWb4SnD59kbaRWUBVLGMheSnF9Y9Ka2sDGrMC8pKV2szej6KNtZraspKPkBobKSGemF4Hi0WvqVv26tfLDWbSSLOsP/MC9ErIJUJMui52WjjhPqJdnm0cOhAMjGyQ6hPK5dYne/wCWwCJud5AuU2cLHn9cK9tyY5JtVMj5g10a7QPPFY8Mlrw
 sifgvAc7
 2v2Mlc+ig46h8jhTAecE8oc8KOTwKIojVa8OCnDKy3Sbf4IE3QVg4WFgcjApD3BeHHgp9douD8aXa+uVbK76+oMBb1j4mbnRxBf86KuZZ/Lfnfih0qo2UGeAinhB11SJWaXtNrKJynNT2+MNqh1vVyKVmT0EhPPEjnpB5z0NqBuOlXGaYZkJA9+I6vprB9WOSpzBMl1ywmBEMGl2oqHDizlkoSv94dS/WdnwtpHeZmVl7SlaQ/wzFbWxVQ5KW0rOD/NhmFTLRyPVX2LrkHpmOLjLlADeOnxZ4FRdzNXvNWkdQrtqH5oEAi2fHmUAV+A1BotTr6g8fYGffG/p7w464j2QxKzlrvIHLzcrL0n5BEP49mSt4V2+TIMycoZr8fQ8WM8caBi2/SqaZoT2Eq5z1xzy6EnPVa0a/bwNPK1TcClmU3HSFTf8MDyv09irrdFAf5Wr8e/ThRlFG/H3ftI4KwAnNcjSzZbmw+l/MRvMNPMz53OsOJpSpFktnsMBySrjeBOcOUd2Ly6NCXoQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 09:58:05PM +0200, Janneke Nieuwenhuizen wrote:
> >From d8291d06b67db045033664fb440f59001d7755a1 Mon Sep 17 00:00:00 2001
> From: Janneke Nieuwenhuizen <janneke@gnu.org>
> Date: Fri, 15 May 2026 10:12:30 +0200
> Subject: [PATCH] shmem: support xattr gnu.* namespace for the Hurd
> 
> The Hurd gained[0] support for moving the translator and author
> fields out of the inode and into the "gnu.*" xattr namespace.
> 
> In anticipation of that, an xattr INDEX was reserved[1].  The Hurd has
> now been brought into compliance[2] with that, and so has ext4[3].
> 
> This patch adds support for reading and writing such attributes from
> a Linux tmpfs; you can now do something like

No, making bootstrapping a hobbyist OS is not a good reason to bloat
the Linux kernel.  Please patch your bootstrapping code to just use
a user xattr instead.


