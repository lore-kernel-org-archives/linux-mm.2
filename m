Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0CB6D4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 09:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD246B0005; Sun, 18 Jan 2026 04:50:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40F06B0089; Sun, 18 Jan 2026 04:50:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D336B008A; Sun, 18 Jan 2026 04:50:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8125B6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 04:50:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA67216029A
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:50:58 +0000 (UTC)
X-FDA: 84344615796.27.90BA19F
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf16.hostedemail.com (Postfix) with ESMTP id F0523180002
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:50:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=Rl41jstB;
	spf=pass (imf16.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768729857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjrARzT1x9RSEOtAqTJIPIYYj0cQ534uvRgkdy7YWtE=;
	b=jQD7GgMvrFar4FF7jdBO93aN7Nw2zrHypVGtDTLmJKdBxZfpcizb9N2t1acgLldfq93f9I
	zKZAr0LWvCiW0kCmeRoDyAOSzpSI2NpcajGYTabqrG+stm0DpJsZcrH+hm0v0B/QvJGTIQ
	ZZRyhtPmZzjTPJscpFSc9QfAZw8pSIg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=Rl41jstB;
	spf=pass (imf16.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768729857; a=rsa-sha256;
	cv=none;
	b=CN8Z9Q9Zq00t8D6r/3AcOHrUomkJZhUNfCncAMkjyfA7Z9ceX16Om+gWb5j3sxvfs+0b+T
	Jpa/CUN+cPziyo7pl0JXJCbNsmtdaPd/7zYHlbCow57l9VBwy9W5rUaxWI8RQjwU1EgWHj
	1CN+r40RhRw22wfEn7lxBtZevmY61pA=
Received: from 8bytes.org (p200300f6af1d960047d77347aeef488f.dip0.t-ipconnect.de [IPv6:2003:f6:af1d:9600:47d7:7347:aeef:488f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 1BEF65C16D;
	Sun, 18 Jan 2026 10:50:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768729855;
	bh=8PTSJ8pfJPlmOwYFvGwrXK5b9UqaO4C/h0rYTsruiqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rl41jstBxXOX5c8HRJDBTxD4sOcPT7SO7m9rB1WimfWEdpH8/PiBpM4ZaiU8Rca8q
	 NQ2hnP/8BOBr5vIRmkHeqa8pVUqJsHvBGOBHlkDRDR5fyKuNGiUW4PILXfr45/bLIT
	 tU7umTsFvi6wfCWuOXB9Cie83xWbzHywUblnRuvb+x+YclEJwL+12/L8ackb1nBwWL
	 y/KtUqEy3koDjic3Uf6qFlIYEaD3ClIcHXfsKmDgOfVtSl4uXPnAhk+rH3a8K0SCK9
	 23nFhgJb6M0SJwNhzmuNJWYvq7S4yTnd34usNf5lOHI/+cfR6ABaGniHNrunaK1OgI
	 iUjmcWclgqs7w==
Date: Sun, 18 Jan 2026 10:50:53 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Will Deacon <will@kernel.org>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Boris Brezillon <boris.brezillon@collabora.com>, 
	Robin Murphy <robin.murphy@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Asahi Lina <lina+kernel@asahilina.net>, 
	linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, iommu@lists.linux.dev, 
	linux-mm@kvack.org
Subject: Re: [PATCH v5] io: add io_pgtable abstraction
Message-ID: <swz2lj4xhs6vjmjs56aj5u7pbk4uaqur3cqt4zoybqrx7yckg5@ifu7j7i2fmco>
References: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113-io-pgtable-v5-1-7ed771bc3d8d@google.com>
X-Stat-Signature: dt5qu5fjh8pu93nksuapputi5483r1ga
X-Rspam-User: 
X-Rspamd-Queue-Id: F0523180002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768729856-81064
X-HE-Meta: U2FsdGVkX1/bBJ+xaQa10tZ2+/GvaR3CuMGbVNij+Ux/gmgbi1A8jkhs24RLPB01sJhB+CfL6HD1a+XwzQs1Y2OJyRK/kn+dkDY+W3PuHhbUfcBLBNqPr85+Z+lG/eg5M3f0D5F5btmsqzu5dn6AaRzqmAtF9uU205vP28OfxehFMGhbOfC9LkWrLOHLfHq2Xmr8LrZ6zqjH0mUsp2GYiKXY8pBUN586Ks3Et59u7s8XlNv2x1P8dsDRu86HDkudts58719SQNg9ai+MJCOmNAqI9zRep8ZdjJpVR59F/LzRFqcl2sauGtbsvLfSRcNRPrp6ejzarrO101usnNjQTEmNLy4P2brgh4pd5mSd+jI8Gt0RrjcQuzU+FyKiLwJgmcs2K0PVmQso+lZpmvXlxEih0e7+HeM8jqq+JoRL7hlEgUU4O/DJBKPGBIWl9cMuZre4gJC84lA6Hwy2iYdXdrGXRVIltpdQe6M44NKD4Qvcq501baqH6r+x4cXdluEjcK+P4y0TJl66X9R2NwpPn+dXP9EyAD4q6NTvGjpFuD8J0t4I+xKfFF8K10U5SsxUOesYneA1Kean2nXayrxuJzfjbNwRvSN9cKTJ9+/E7FDEg3KDUqWv+7JRYKiw4aiwfv6SGMIN6noQA6FnTaq+JPDtebCS/cm8EUrObcYdCTLRUowFGt3REIAuV8ay73c9IXma898no2bAOB1rXA1nMlEXEnD8dXwEsVpT0lI28TvrG+1k0JZbgUdipas/2OoPkRaqUlX528Sn7jvX+Ba9y/eiq6RrrpI4afmChdfntC8TBVMXSYm58w5CZnE9IPviCNnrfOS2pSVlXG6BZ+HCWnyQHWPh+U0Rs6A36legLgoaLdPPH3SX54cQu4gl33KZwhWNnFKkn+LTh0VMlTV/Z/FASeqbK4hsvvJVJ0UvUCqBMo9iKGFmxhW/774oOfeu0cnbn4vQInjIlr6fyb5
 vqPFZDFK
 E87F/gBC1vSLry60M/wbG1ORABn43Wvi98BDaZPuHnsju7x0wAAizolWPT2TtJ6o/c2Lpvm6uyQKbNVGfKvQLuEu2E3rKapgVipr3nvtHf/1oECFkNeK/MU8F+9tXJpXnTx8+oUN3I3a61X7rYCqERqRiefCuAjRZlzClziMpfhKJ5XTgwdksrdesTpG8H+OkUkCw6SrahaNOhUqXsvmkXdFaZDDT9GDC6bhywgH7fF+Df5QJw6FoMXKyUkw7HMkvOefRaJ/kO4/w9CCavoB10LAtTZXi3vUktG7A+sj//PNXqI9YQB7dz+BBr7ONAvplUD9tiBI9fikVxS4nJEX4zxC+x33wAeZfV4fHV/OKV3a2/tEeqLKelC2i619bcRYQWh5d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Alice,

On Tue, Jan 13, 2026 at 08:49:27AM +0000, Alice Ryhl wrote:
>  MAINTAINERS                     |   1 +
>  rust/bindings/bindings_helper.h |   3 +-
>  rust/kernel/io.rs               |   1 +
>  rust/kernel/io/pgtable.rs       | 276 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 280 insertions(+), 1 deletion(-)

Thanks for your contribution! I'd like to queue that for 6.20 but agree with
Danilo that there should be a dedicated iommu directory under rust/kernel/. Can
you please move the file and send a v6?

That directory might some day also contain everything needed to having full
IOMMU drivers written in Rust :)

-Joerg

