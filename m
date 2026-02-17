Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADF0CE68151
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 09:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD836B0005; Tue, 17 Feb 2026 04:13:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8AC16B0089; Tue, 17 Feb 2026 04:13:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B6A66B008A; Tue, 17 Feb 2026 04:13:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 89E0F6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 04:13:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCC9F1410F8
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:13:57 +0000 (UTC)
X-FDA: 84453386514.17.1908B41
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id CF1E680008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:13:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LgU9Uc32;
	spf=none (imf30.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771319636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bpz6kpZK58PNbfjvjbENnuef7qg2CcJqKgDXTXChao0=;
	b=ItAwbxutLC1NI2Uv6yYX3dLaHyQQbC3oUoWqa5fx9SxlCiQw/zwGR9tq2pLLdnsyh2niFN
	TBMRF+U2z5zdJn4NRyzdC+rORO43T++h3NDNkmkg85DHw0inSZ45F23i7H+M0nSqMh3fHm
	+4YcoVb/O6ZEBRJxz95AWOpRrNTfKZE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LgU9Uc32;
	spf=none (imf30.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771319636; a=rsa-sha256;
	cv=none;
	b=6fdXU/+YDUXDwUQIgjDcJhYR2x6SFKS0zmSJH2+Xdq0uompL5Mf0pw6+yIuxk8pmkzUS3N
	bSRwx72ew0i3ZLdzAhdJEuXz3JNGs/8LUaO+fxnlVF6E8SsGpuIe6Apt3AdfAzdoqja1Rw
	YZ3+R/vfxO47QabpvnYSyKzmASUg9sU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Bpz6kpZK58PNbfjvjbENnuef7qg2CcJqKgDXTXChao0=; b=LgU9Uc32rxTQHqrl3KbC3iSJor
	sqCBxXQrEp4zol+EzLpdwxpkbNbkYdRrKANeC/Ci5SyRsp+dvRyaNzKXPCvFt01RVHW7vNdU0+/f0
	/hveX775oGy5me42EuK/JAqlq24CrfY7TeHa6alsuXjaZFktRZf4E1nL2O5RB7u7cDWQlVawtgluB
	domniAqF+wDeSs3v82XxXSWZRQZBMFwVJbcDUE/30VyD6uxVhVMm9HSLYdm4vGom/S2XbiKYP67bX
	Bm4a3R8yBZWLhCCS8TfYo6jnOOjGPZImxp1tXiFvmmPuckMHw43/8Yhct1vTHTqgSojQnyznW18UP
	D2uGZqvg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsH9R-00000004Cqk-40qM;
	Tue, 17 Feb 2026 09:13:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A3CB2300CDE; Tue, 17 Feb 2026 10:13:48 +0100 (CET)
Date: Tue, 17 Feb 2026 10:13:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
References: <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh>
 <aY9PBfx3RRV7rXZ5@tardis.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY9PBfx3RRV7rXZ5@tardis.local>
X-Stat-Signature: yx4mezwwxjt6cutnzcaj1pmjgo5q1jst
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CF1E680008
X-HE-Tag: 1771319635-203201
X-HE-Meta: U2FsdGVkX1+VJbf5CPJWuI13bHhDuagGXn+QdQ44KCCB97KzxzwIoq+fhHzkUPbFhTxwDd1VyWpnTnCoIo31yvNkg2eYypMZAs5JRemUl7q5XGxehQsMOrJCrTU6pWoXsjlklRZJhnRvp6Dz9Uea4PJ9dasqiBNzFp3UQoWAaeeDkMZqINBahBPiuVQihvjCyUogky8HwvQ6Fdb85WjRTPk9C1iYpGaYAtjiDamX2HNcIU+FaXAj9PDYwBSb4QQyI0VgjG7rbuJYTfHT+6Ld4yZ0uzieOcPjuPnMVODxwRlLd1tqfqxfukA52tdCKTH+TMxEJr3nThL96iIZDCS/GccifpwtrXXXyyvAIbbTQRppIBID/Rt1RwbLEIoBPE614yScjGaahG89Now6W2H9rm4xLoZtqX5WBkm2Jbadq2VXsNH3dstjmAHIzrGOww/sK4tNCi5rWXy4KwLs6cAIs9SxJahGNT07ObdBsEFM7WEzQXjv0zTLv8DlSk691LhI1XukkVbnWiLhShR6T/RwPtBxoynhTSL5QUad0IrjGYA8nyh7/ViPj/2qg6oeuAl96/8BC1leNNmd4BCpjJa2XU2XBFS4GhvypmVvScnuZvi2/1piTGh/Jki/hnGsMldmSxgm8eHdnEowE1mHnHWGwf9CTMvBLaxx5DWAkCV7KValFQuzYxzMC1V09mF+0+614lWC9qBvyPeP7WKjxpq/XEVmV3lFQwdYibv9oL0eGW+35Toyl4TDeTCO2AJQR7IAj3myvtrnwSfeZNx9Zi7IYoIjQ+BcNqlkejQtMxvoCIx1+jh/1R5BdYrnd8Lb51HnS/BaxAWz0lJ4ptKxoI3V/3yu83KfoW71diO2IKCDfBVtKhpQmUqTSHUEDzoWp6lNacunxAR1fsHO0fXg2JbSIFoJcPr+9/rSuc4K/toROEFOxSCRSL96wHov9fLHaZtMM/KHWNBp4NZn6TJ/q2Q
 aVx46Kid
 49+D4e8h/5DxpcTUCkvjuCtIsw68ZFCjQw7RZqKIHbsk/IP5qcfLnYRVo7qCfkG18SqklFqZSz2D6eGLuoELdQpdz/fwRcDXL0Rkgq4ePvy4FnX8M5M9W0oBt25rpzsJyCs2dBClfSeIrHfS36Q5yJbSeR9MKqI6X0Mor/uGQcHSFvLvX0wMaDeXijKsTJhmPE5+w2+08Lm1nZRKwYihvW94btwe0UA/bFcbfvoKGbSaEtq3cd7upUwXmMumju+VR0gc6oxzAuyWVwtSmjZ9RabnVGTQpRNcJFP2O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 08:19:17AM -0800, Boqun Feng wrote:
> Well, in standard C, technically memcpy() has the same problem as Rust's
> `core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
> are vulnerable to data races. Our in-kernel memcpy() on the other hand
> doesn't have this problem. Why? Because it's volatile byte-wise atomic
> per the implementation.

Look at arch/x86/lib/memcpy_64.S, plenty of movq variants there. Not
byte-wise. Also, not a single atomic operation in sight.


