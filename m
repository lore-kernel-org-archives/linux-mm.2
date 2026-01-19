Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B761CCF2D1
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 09:29:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC2916B014B; Mon, 19 Jan 2026 04:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F856B014D; Mon, 19 Jan 2026 04:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E7E6B014E; Mon, 19 Jan 2026 04:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B45EE6B014B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 04:29:56 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CDEB8C359
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:29:56 +0000 (UTC)
X-FDA: 84348191592.02.964ED68
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E5061C0002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:29:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=XBB3+nws;
	spf=pass (imf20.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768814995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5+xJdnzeFDynxJTC4L1Uu78jo9995a+Z8+tujOeLKc=;
	b=ZDMrp43Mfb/dum57hfJ6XBx6+71srQiTFK1qlHM+lY6PUnW6R11xo2aA57TMxov1UIcu8N
	nFwYJMhBKUoz2hyKZJtbP6OnZa58QLNuspU6fPx1KCJyfiekFclePw+2nCf05fzcI2td1R
	YoMOPUBK6GY5kIwnFSZhkTsb5SWJfCo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=XBB3+nws;
	spf=pass (imf20.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768814995; a=rsa-sha256;
	cv=none;
	b=DYkF+qi77TGFMfrE4PQ5bNofSvMTBxAjGrFevaVUb7oXMOVV7P3a14Mou3qHZud7i2KFVh
	AUxNhYL4Yzhf441AK6jlA+ZqDA+v7/jTX8pH+VqOVpA2ka6gEwLRidltZkNw9OAprYnFot
	1Dayrx4eGhdlcFZhg8diteRY3LDJ7C4=
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id D3A475F66E;
	Mon, 19 Jan 2026 10:29:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768814993;
	bh=OmaA48PF+aapLbo0XX9BQ2SwdV9QU57r0NNgj482gLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XBB3+nwslOlxvH2r0ONrj19bvLyQ6WtMJ+Mc99P308UvnrrcI7U1RHRqEkVobDC6M
	 6W4PpLU1BERoC/Zcmv8ZZo+1+dY6wd+md6a92BEeTXQnC+t9AFzNewOYizMvzna3ox
	 Xv91ZZ5UROezfB+gv5pwicqQpAfmEKa7fHP7k6/UecPtB59ao0DJlgRPOx+uyQJkvB
	 VknC8ZkDb7sA1H8CJFSCtnCs7vyvT4ZMJjnp2UjZfi4b8G4hWxjbF1DMzPtF6t0ZV3
	 k1f9fMH9UVWbcCid+NC2asTt1tqgSmk6luOKXngq5u0g7HJd2KmZH+nX9Tj0fhNT8W
	 Udf5vnVbIYJRg==
Date: Mon, 19 Jan 2026 10:29:51 +0100
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
	linux-mm@kvack.org, Deborah Brouwer <deborah.brouwer@collabora.com>
Subject: Re: [PATCH v6] rust: iommu: add io_pgtable abstraction
Message-ID: <l7ww4wkdplczyuiqqrjn7nx5jf7fn6ffl4hwfn2pyls3wy74uf@gmmufe6ncy3j>
References: <20260118-io-pgtable-v6-1-423846996883@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118-io-pgtable-v6-1-423846996883@google.com>
X-Rspamd-Queue-Id: 8E5061C0002
X-Stat-Signature: 536ufhjxfg49e4wtnsuhkqcmn3d8hdje
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768814994-911451
X-HE-Meta: U2FsdGVkX18C1PKxgnpCc1ul1B4EeubQFRO0m/tmZdoDLhoue+L28mm+K6AV7U5tGHj36HREl8No77k1bGxILP7dYONBwm1q139QXRqDJC5nrhfXCZI/IfA6ynyYZkYnm2nGrDwYxp6fc9E7mhjpNNtm0iBrj+0/uHzndWfW7ZzJbvkJlypUzRXWQhv1tF9rj8oaMi+NqqAJ9JnKFr5A2yilh+iPE0Oc6mONmP2tbp77twi0PWx+vJCpcRdaOKPuIj02VeeEKMGAjKUxMDTWw8gcgGHBeA0XVJFPMxPByIN0wHlsFnMiF+3gzVPfRbxRRS62zUjq04pBsGYB+WpuimBaASKt/0QUFtziqCnT6iiXqQOYhRfvU/WPyHRMUX/qYh0aUzJ7TP7FsOfTJ7jSHfAmqWrOdkYfXUFHTn+sqgdLA6SXffqrjgSYVp/Tu/p6xhGFTJU+afaI1CHwVOz6EOOzZ/N2IfXgqqL1t/hHIe0gZv88QKHQmR7sAiItVejOdJ+SXS82bbjpko7T+fPpAJuSAElChwmH2dOmW8ZjS+VJpdvHDQcuqen/FPCRbtfXeLi9YvMpqdorad/kwc1X8jpQEGsovPap/iMPK9cJTPfmmBy/UkLYajpmAXtHYLc+g9K8wg9n8KI5hRuAPJo3buPgVOFuOn1MBrSKYZnk/sGo3VTaqWMuJ7rmkVrfAyy8zi8ofvRiduQtHkn1G8/3ZQiYBBDflHXMtrZUTInrbRAU3VCwhujkmDKU3R+oTyJ9P0QIlAXcN+NqZmincaQ8FzLuioP/7YAhQlY211wr9J/4bAB+LwSZ645hwVQR5cELw2C3/kbGnUj1bRS2CQt795BVeFaSjwBDMYPPUR+dknTjm7SfhLsnE0fOoMpdtrBFyCOoE1/aLLfpSpLtjb2ljKVEns4ihh2d+M4slf5hVsSmsATwoZkGrQlPXJHoq5Dpj6NAFsAlufnkPO7au1A
 I2zKNZeL
 /6Sd7GXz4dDbLnptpp0Yvg3RAU2xn5OkiwcvXOoAzwVhokW1QMzFybuta9ZGpRXNn3M21GsnNDUTCDWk8/hsCTbfBLk1KSdQ6lq/wFP6hbv/ZTliox/G/92Bg1Qs3NC86IkNXpjrm0iCDQ83CgwsWiTKaxxgFeKqLhfKwGHMri8MRdToCNuiVrH0hQFeFHQqYxDy/ZccUpuEs+OtvAh5eAP0QB2x7tDTDO30iAmc4pkJL6v8LtwEz4/cPrmQeyJVLISmmQUPUIVIld/xBQTWTSZO/g5Qsn7nUUvQw//pO5IFtNCpFD2GXBR6fQ3HTiz/ozy/XqRzKXaY01kdQu/rEFVj8xln3rXH7B7ITdduwfU8r4yU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 10:08:08AM +0000, Alice Ryhl wrote:
>  MAINTAINERS                     |   1 +
>  rust/bindings/bindings_helper.h |   3 +-
>  rust/kernel/iommu/mod.rs        |   5 +
>  rust/kernel/iommu/pgtable.rs    | 276 ++++++++++++++++++++++++++++++++++++++++
>  rust/kernel/lib.rs              |   1 +
>  5 files changed, 285 insertions(+), 1 deletion(-)

Applied with Danilo's suggested fixup, thanks.

