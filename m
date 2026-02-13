Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4C9EDF16E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 14:35:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292356B0005; Fri, 13 Feb 2026 09:35:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23FD76B0088; Fri, 13 Feb 2026 09:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F556B008A; Fri, 13 Feb 2026 09:35:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07B8D6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:35:59 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C93558BF9F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:35:58 +0000 (UTC)
X-FDA: 84439682796.26.376E61E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA25C4000F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:35:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SpgTSiou;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770993357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NK+YgypWNu/fcoY8YLKG/o15be3Fp0W5wYo+Y4JNt2g=;
	b=zsj2LZIk+5fqY9RSlpefaEbSu6KuxdsrC8bsBSDisZrd2D180OZ/JL5mU23vJSz6HUe5Vz
	ZMXZt/9I4Aos91HdjfyDwOCwTUNNkdPTAHqW/s22O7xOvTiePKhgfSyCAIlxZComaNrZl9
	38AZgtqot7xkynVYq1Qww3M1pQl0Ls8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SpgTSiou;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770993357; a=rsa-sha256;
	cv=none;
	b=loAxspsSz5/wK8U6Aku12PFs2Tnove9qZ8hTrOa+cE2okfrqHtz8hwiCe5tA0tXhyAfSZw
	Y9HQ10Rb67h2N5/xK7vE/+BDq75stYYmxNlzKYUfc0Z1FvIYnS8YwdAMU+JZLpqqxhQ92m
	AQ/rs5zQrhmIparbZB2hRMXt5/HJuAw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NK+YgypWNu/fcoY8YLKG/o15be3Fp0W5wYo+Y4JNt2g=; b=SpgTSiou05sIQdsCcM8qJvwzLL
	YJ1gnl1i2b4HvgbsVmqUAf5wfX9B2ezKbQLOf3SEXOTjknPqdeKLAvm0uIRDX1ugN+8j4gvhDCbJJ
	C9K+bDlTg/iB3RrK+sObRnjxdn3eYnqQD36aUcQd/AQmxZz7qVfYNvjBMrpY1zZyiGeDykScXy6YO
	TcnMrmOlkfGDygHoeJELEx/emxZerUN3UJTkknEF7YnU5+/CGRYjowIVDnL8sOnOZ0ojZZBME0vSG
	5pTjO9AwOMDcfG2DQJjamxgsiKy4tZ6db2R37vXBeFK4rwH3Re+c1jgYNWLwPpHP3FJEo6X2LCXm9
	UC2t1aIw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vquGu-0000000FqYz-1OEh;
	Fri, 13 Feb 2026 14:35:52 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A61CD300969; Fri, 13 Feb 2026 15:35:51 +0100 (CET)
Date: Fri, 13 Feb 2026 15:35:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260213143551.GW2995752@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <MJX-TLnHWp9yJ9t7suTC8ExghroIz2g2epZG9Rmp6l-9W7BylahrPTqXQBI3D0EUah4xdEt3UXh6ROBa4LdEDw==@protonmail.internalid>
 <20260213112837.GT2995752@noisy.programming.kicks-ass.net>
 <87a4xcu80n.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a4xcu80n.fsf@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CA25C4000F
X-Stat-Signature: t4occ8ei9dce5tw4guhjkda9wpbcrqe6
X-Rspam-User: 
X-HE-Tag: 1770993356-514970
X-HE-Meta: U2FsdGVkX1/0OAZCDT6DxhTnsqR/A52bvwT3iqyHsMV3pauu8ulfVNpuGIftiAtN+zKxJzGTaoJWo7tYRwK7tLUfNbvOmPIWCggQOuAB2vwRMijffQyh2lNAwTQcYOsx8yyJwxmjo1un7SU0jEtfSdMOs4RiErdyToLSq6ErVUoiHANVQHfde5OP2RfzMO5G1072Aa/+LQldThUeiEUM0kbgmBiHEa1CotmxChdv2FKG2P4kP//+uf9PsnCXrAVaK/EpzLeaLr39+xO+pHoR+rn5MuGrjfqj10LTQ3FYOXkn+mHHEt/+Q8ApMLuFuRFQmH2nL70W5oL2Xk6fAzPav33L4kg1GC51XPtHdK2q2zGoJQ1CjH5j8QSpra8X/lw8FK/KCBI6yu0x+Wff9rgrNpFA9n15q2R9zX+freshbrAUEkDSeLxE5/XBujDlyv/bXKK/22lqvi581MJjHYRMIs3dIf8CuAToTaJTNT5ttlPtrNyh6VLv92291V4cHmi0wQeQvhXdEHX8wtWvwAqBxiiSaGKwYNPJyJ+YF3BwS8aA9+a+0Hq3fDiDhjeUXgSjnBqsXkelqaUWhvTxTm7uqA/IYQTZvvePc9rLi6xrUXObo6voizoUiWdBf7lHK4MAxB+8f9m3xrdvwqC9ePvKtqyEpLtiD8GA5x50KGeBv7LU7jIXmWx6TnWfm2tiU7Ll3sIUgMH+2EMoFYmpExptAsF8Q+ZhpxI7ua4bCZnojIospvuhRXU8bZKj08YjJOQVAAh31kElxjrdHdF6M7E6qeJvSf1VVfr0PsxDsBrXCWzqoSC/FQ3CnOdeBVjq2xsMlHo9HtwIVPYfemdS78K08abwZtBxKh3nmxbTIP1K8TJD3TYjypml7nBtb4lG4OtvFN+YrFscTmXo4+Ho2DzlKb7bkYMHbxpjksVxtHOpO4NvdXIwS0mzv4gshYArOtZpmcSvFhNEkRPEcDE6AW3
 /sFN5DPt
 uJHzw8nCPAhBLxqHgDxLZpQXzL+tjhyzrQE2VoTNIPMiylWbtW2gqWHUn/gvY4/Z6GSxQEfwO/1o9g/S9Z7iC7Dqf+Fg6D1/AI6aOFhRIHkoyRtKUljJ5TcDOe1Ybq2MekUh1juKRmrc2xVyAUj5NuwxAfJSb2VvqkzytOJlVv9KG+miZvxZbV+4j+X5JmPeGBQTVDPvNKtGerV2Z9q2Ug3KTqT0HFDDS2PJVqidIatmsoTXRsadaSOzo8sRtqZQ5o/S1Wnc4SazrcYEuPReNTsK1Ny1BD/rNP1q1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 01:45:28PM +0100, Andreas Hindborg wrote:

> > And same comment as for v2, none of this makes sense. Byte loads are not
> > magically atomic. And they don't actually fix anything.
> 
> I am curious about on what architectures byte loads can tear?

That's not the point. It's just a byte load, not an atomic byte load.

Unless you're thinking of using load-exclusive or something along those
lines; but that would be completely insane, nor actually solve the
problem.

