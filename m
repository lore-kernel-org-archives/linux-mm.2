Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE7D7FA0C31
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 05:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277366B0095; Wed, 15 Apr 2026 01:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E4A6B0096; Wed, 15 Apr 2026 01:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18ADC6B0098; Wed, 15 Apr 2026 01:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0764F6B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:54:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACAE75872E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:54:26 +0000 (UTC)
X-FDA: 84659725332.27.84069F0
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id C6436A000F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:54:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eXL/xuVz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776232465; a=rsa-sha256;
	cv=none;
	b=KaUHXH6SBdivQp6Ps4n8DGlyWUIgk+s7Kaap8nyjzEH9o1ChgcEoV9XMK9OTj1+mjvvjjb
	OB1QQzDSWj6a1WHZRj1vRskvbHNWqMNYd95KP4LZZ/VmOcoR6dBPv0Dw9UKQowesDGnD7T
	qDw/BL+uomv5rwh68Dmp8ih04UDi+ww=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eXL/xuVz";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776232465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goM4TbNKzPkSw4+mRWT3apYDp0FWr3JgrOICL0Dn9Zk=;
	b=8c6olV5uw2av9ZfqQ2JoU498iQD82eFFZwiwQbzNmBsPpSLvyMH68GF9muMnB0WH34nvqc
	mMwFmP6uRoydpmJuaARoOIoMN6bEd1WN74JV7CM2nKm8v8lUeOz70uJpAIxSw3dF2zbN1v
	o+axH1lvPdPfQGuWrIBDwkboTrUsvto=
Message-ID: <170b0c6c-387f-4317-967d-2cf02e86621f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776232462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=goM4TbNKzPkSw4+mRWT3apYDp0FWr3JgrOICL0Dn9Zk=;
	b=eXL/xuVzwxTkYb1o25oNEMo/S0RPJLv4k4Esio9gAu3LbRFeyXiS/s5zgPyFik5yIdbFuI
	4cicOycxb+L1gU4PLKMKNiMf18lpDbD62v2bcVJYdgsoj17b4s7j3H2zM+iSJ6iyrF/yl6
	3hmgbuqylqbpFLpo3IqfVLezf/YJnnw=
Date: Wed, 15 Apr 2026 13:54:16 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] mm/vmstat: simplify folio stat APIs
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Ye Liu <liuye@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org
References: <20260414091527.2970844-1-ye.liu@linux.dev>
 <ad4-kpPTPqOuDF_E@casper.infradead.org>
 <6c0ab55e-a687-4ad1-b18e-b4ca97305a44@linux.dev>
 <ad8NKAxUAP0RYP5h@casper.infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <ad8NKAxUAP0RYP5h@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C6436A000F
X-Stat-Signature: x3sfx5jby3cnybmofhi5s9cp9gsw1wyt
X-HE-Tag: 1776232464-539561
X-HE-Meta: U2FsdGVkX197d68fFX+9XE1TMK7q9Uz3+BxcqQ8SHZSa0jHCbgaahhgLcZcyANL1o8LbfQ6qrm5wPE01XsHiNsoJqf+RP3FBPuGhYFHDT+nL8tXuKc0i6CjJ8vATiZ5zcaNTvQzRWjcqC+lzC/hRjb79C8Sw1mAM4FhgkmMJq1YY6J+qJjazDGxCnUdwt2LuNx8/6/wRYoBsdp+z+N7zRBJxcPgUZSAfz2+9uFSKeQ8Xb2qMffkycezpBqqP4A22TRZ79HwBEX/yrMj6HNpqQB4y6QESgrqwLkZJ2XscUZ6dz36JB515ef8wHlEWSY/zqmRGKf2TaHITX8VodrrJq9BZX28KAr8GNnH3+rb6HLciPDJUd9DIy5NVruIqctcFsbLz20uN6yVLNpIyUaGHrzTyM0HTFNDAgXqySnxv4hHi2+aB+g5h5tKdDhBn8BcSBTGUCOFzvIiFCBSsKyWknp6cp5LkfK32P9NBn9L1l+Z8VjBLW0nxPsPBtkxrtvWKLj/PHMBDGdjsJWQ5L0yq2tzzjWo677TSMQ4BffqltSVd3GsWPJkgaATmgZG4P2vuiGMmM6dL3p2o3TltRdG7RA3zE+f6oXqhb1IbstR6PtNwgXVBVXFvV0Hqckk/wMcicsLp4KsoC/sIr316b+ClCG2aKKBXW7TvYaZQh9I2unZmlhS7snogPKgWRqq9yvDC0b42Ej0C8Uls3MG43o6Ymm5Ru4AfEjpgko/qxu02857CotgDPysLgG4HeU+5Hsrecoy2t4fwn9HiMm+BZaxLP58FF2Gb6Rnv5n9AmIxp27jG9RZL7cea8FUwWD0YX+/Pef9rSvJRxrwQ5Kxuf1HderyHCej4pFIDnq8FGOK+Zh7BPGD5q3uLjEnU2bEKyOAuCz+r1EwtTWyB6DShFjQk1RJx7k/YBJr9L4sVfDDrQ2QCbJ2mLi3YOoxAJl6luhuA4lUeUO4dt723Mzj49P0
 rUVuOU8S
 jL5xp7Fkj+HKj19v+vEmUbJ6Dt/0QqcBW9sfywZElHmC71OtCAewYvXVaj0+53XUuoV/5lIMFOF40bNR9/IlpMp5O2SFWPO2ucCf2xg91m+r4LGO7sqwb/i3ODTR9aMWAEHZlAE1lXQdantTxd361s6GijnFLPJxfpjIBWraPkFXD54fzvhbM66r5T7HYLcz3HbMcKfexQ6hTa8HCL6qTYB4dgF9NK4K+fH5JLCvgvYWxKfM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/4/15 11:59, Matthew Wilcox 写道:
> On Wed, Apr 15, 2026 at 08:47:24AM +0800, Ye Liu wrote:
>> Thank you for your feedback, Matthew. I acknowledge that this change may
>> introduce additional calls to folio_nr_pages() in some cases where the
>> value was previously computed once and reused. However, the new
>> add_folio/sub_folio functions provide clearer semantics, explicitly
>> indicating that we're accounting for the entire folio rather than
>> potentially partial pages. The overhead of recomputing folio_nr_pages()
>> is minimal in most scenarios, and the improved readability and reduced
>> argument passing outweigh this concern.
> 
> I disagree.

Thanks for the direct feedback.

-- 
Thanks,
Ye Liu


