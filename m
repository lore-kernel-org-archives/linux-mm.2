Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38650EB26E9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A9286B0089; Tue, 10 Feb 2026 11:44:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757056B008A; Tue, 10 Feb 2026 11:44:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6804E6B008C; Tue, 10 Feb 2026 11:44:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 521996B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:44:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27B1C8C19F
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:44:56 +0000 (UTC)
X-FDA: 84429121392.18.D262A43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 773082000A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:44:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5cIAjV0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770741894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSplslQth4HakT6Lf4hfia4DuU001LaXkJo8b0hRA9U=;
	b=Up7Ioi2uM+OTvljZBf2AVIK0c5ysCs+HMqIIWu2gtszObhigQpWqGx3CZ57ZmHsBA1yFv3
	BOD7d//tZATHzq6geYlXPbo5/MHF5cNzLpEXe96QjAm+wa5dtbedPN6AFja2IRvoxYHCGb
	Iz2Fbqr4v0Jz5nvPw7Qpt4wJAvBIFPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770741894; a=rsa-sha256;
	cv=none;
	b=7EogCLI0NflqBoFUVevzaT6P2w4XtTrVF92ytmWxgLcZ/CRdmv/42RBLwNMwd4nE+pFAaU
	+b+4b2jRQP3gEaaSSkAXCRCzNcbjdXhHlUMf1z/3xAX06xzI/49J/RsighL/+52PjVjL9i
	hTYz0bi28OwF5MpnqDH1gkpLmHsLS+c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5cIAjV0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of da.gomez@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=da.gomez@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F14560097;
	Tue, 10 Feb 2026 16:44:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F198C19425;
	Tue, 10 Feb 2026 16:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770741893;
	bh=ORE3cLC1BF2Tpcff5rGilSnuUUkcmfnBkr0UpJFyaho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t5cIAjV0w0eD3o/U5mUoo0u3nku/rYzUWjSKXhM2/DL1t+1YrAP2bGDy+6xOyTnhX
	 KAQhWxdiByuJpc48yB7KFtG4nS8BD3aNUPFJPuq3TlQ/fmRbUSkadxjBtmuIdzamwm
	 eX82YuhwxEzllhbvIf+xGdiUBVcbdPUGL3ngw1eFAQ+VEzHB+lLiuzo8xeLyqSxinp
	 gH+OKsMXE9LsjfFSknw5OEI577OLOcVlsxd7P1sX7NrNsoS7S/VvxIcokb9aZq82sq
	 KRsZvfc9d+4oZrBRU+W1LJEPSkr4KUu9EuxRS30uJpB2MdIHXs3cOTsJfeoFFCVH04
	 I/ddVaMz1z71w==
Date: Tue, 10 Feb 2026 17:44:47 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 01/12] rust: xarray: minor formatting fixes
Message-ID: <aYr8WL_neMB3Crt_@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-1-f777c65b8ae2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-1-f777c65b8ae2@kernel.org>
X-Rspamd-Queue-Id: 773082000A
X-Stat-Signature: 6e1ooif5ru3dfr9e7hk7jb6ke1no71bq
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770741894-476906
X-HE-Meta: U2FsdGVkX1+qGk3yvuyZHmHfpxoY9DE2inTFnwaiui3TDjKWc3aAI1iW9ZBY8gE8Z41PYWcwp4gFqMTK/gI7mOPKf5+/0+ntiAa8BPixCNqveMiQIpA84JFgf/J+bPS9BzoZ/exKv7ohcRXAD1EJfGHFYUdRTnNWrRFJnF7yaUhyHiz7qPC6qsVe0D4shx58ywI3KTrrDGfIGXEugJ3yTpvFgXH8qmnycvM/f4/O1LVB3HhrXGIplD3BEgTKuupSHxhcl46FQ03tbfkNwoRZCOfpcSfXq2coZexYfQCwymRz1xq1SRTxI2VJ1aONEhWB3Y6eB0gZmQEoqtI0WnsJnT1qYqnDEdBkpzHrmYJP6qVWqRDX3C3fRf/DihjDpemvNlgP5FYWOpOvRzUhi9dqQDNnKFk+pl3tQTEbhjI8HCAWFydf/RHKsR5iGvRzPot4nJSZfWFfX1qZ+Z+mMbr1AzMmWsVf5uCCMcHhhnH+bTp+nBM1CpHhnTBfUL5hdttcansy/E5G5L6Ltcd9TX2LCrs637EnUD0jSZ0m1r7pRz9PMBCDSKGpqt88WIS1Udt8oIWNjv85689hWRzJMwLOeyuijLa0rHIyfbp4E6nX7j6eK/kHOc702ILZprhD7i4nGb4vU46c/N3zWPd4zgzdOW/PBbjXbsrxBr7pmpIh7ajjQQgo9/7We/ZhGtmsmpdTXJ5j6NF7iY3cTBgzsXbcDv+nlE9ofOiZTlkBwE+oEjmxUFdbxugNxdsO9ALyyPBNo9rsz2DK6OdWNJM7MLU6nU451Ko1/QFGpD1JVLQ/D0JTNhUWuID7RIA7priBBkvvl/1aQwuIXTZzZUvLgERam75OMTxz/jTk9OyiMzsG52yAoc6Oa6vaGgRlCsNRzvWm5/XUCSb5ZDAbNqQJkiEiN4qg1cnbeg/cIGLSDdGWmyzlUuxB4Ra2q0M74S9U6vAU2FYZu2wlmAeqWIkDdXp
 3/WP1c68
 uKqcQR/5SCmBjn/qh7NtW5q0bHhOOjIwplBAOdAXc6V+OXnix9tKbotVvgUcZKs4PYoFi7lts0uCSAYzFCO71kcjCAi7ZHI4YF5bXTUV1pi4VDR0nYp2in+YwTQc7BjrsNJE3hpH/w+j52aj8GHISMAWQ3wmsOaDVwVv5CfS2hE+AlqA4pz9axXJCL1Gs9HtfEfcxNJLE76yWu1xtJ5ykuKMH1aOh8pkjPza6L5IZBmdHeShBOUk5w9oD9FAOdy1WWoPG+R9KP/rlUsMQWqvS1dHuR/SYZHiPlGV7vpo9tgJcTWoe3lCr7UHa+KGJ7IkaXwtYjK/BVSbbgw9VjVJdvqY0LfRpwmF2ypccfWxFPyxGFLMjbrIQP8OY4NAuRJ4dVTiLvROsU8QE7jus7Sxy9jkFeUqutO1aO2fzXDKVDH6VETBTpX+5Hba5dk8p1VtCePaimRYHFZmYZeg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 15:38, Andreas Hindborg wrote:
> Fix formatting in xarray module to comply with kernel coding
> guidelines:
> 
> - Update use clauses to use vertical layout with each import on its
>   own line.
> - Add trailing empty comments to preserve formatting and prevent
>   rustfmt from collapsing imports.
> - Break long assert_eq! statement in documentation across multiple
>   lines for better readability.
> 
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Reviewed-by: Tamir Duberstein <tamird@gmail.com>
> Acked-by: Tamir Duberstein <tamird@gmail.com>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
 

