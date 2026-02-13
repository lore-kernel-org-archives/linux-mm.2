Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3794DEDF168
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 14:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48AA06B0005; Fri, 13 Feb 2026 09:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438946B0089; Fri, 13 Feb 2026 09:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 344B06B008A; Fri, 13 Feb 2026 09:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18FA66B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:26:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 919D41B445C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:26:18 +0000 (UTC)
X-FDA: 84439658436.01.6E279DE
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf24.hostedemail.com (Postfix) with ESMTP id EA2F7180017
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:26:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=j7PqD45M;
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770992776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WxTduzf2yw11XLl9LWryJtmFhCxf4ZXNOC5WaFzXNA=;
	b=j7mRMKlK4LTk3twaNUuHyo4iY3tnjdEnFtcTV8m9Ir3dWbUk7HVxfMQVwIhBljnXt6BIZN
	lkzHQe7EL9x7MuFYtUCJ+WiON8ktT48a0WC3hT+9uL+6OZgwDoKzU+gUOx9pjk0zin0IVy
	wz05j5abhKqq1XnDWoCtmtHR/12gcus=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=j7PqD45M;
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770992776; a=rsa-sha256;
	cv=none;
	b=Yv+A8joB8e3hGTHAi9OVJWPHqgxYgQqyyLezE0mBNdf49of0qJk6k7fWHkE2ZXava6HX6/
	wZFmBSjjyyUrHYjpV6YD7j4EAUzpnGr9p/PH/at2/+m1u/6qgE/Aie0m7tLbfp2bzFfMl3
	9sT2ySDV3MjnA71BrJrKcfww+6dXXL8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6WxTduzf2yw11XLl9LWryJtmFhCxf4ZXNOC5WaFzXNA=; b=j7PqD45M8mqtAPftgrs3JShGuZ
	uZykIkreokT91r6p5826aiJL+XTjhPOWTjBAV1yMnJbfOu8q9sC0zRX4kLn4QcCsoFaNQtGZpzqgx
	wDzrDys1LsY6Lz/omDFT2gpYBalS1drwT0CwiAc7glYzTWtUUmfKTHgm3dMkkMNa/p2Yme+n7yYXZ
	i+h9oD/HNaw4tmwNt08weZpy3wcGofFYWnkOQbG9YzzGeHEJ1XG3likxYLsTCG8r73itxNBn526E/
	97KvSHdcbFwOAen4ELbjM/38VS+uf/6eBQKFonJDkMzBE/DGkNKt/Y8ow3IleLuc/oP+3wGwmOQFw
	V33S5qjw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vqu7V-0000000CKkR-0wdV;
	Fri, 13 Feb 2026 14:26:09 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 0BF0A300969; Fri, 13 Feb 2026 15:26:08 +0100 (CET)
Date: Fri, 13 Feb 2026 15:26:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Alice Ryhl <aliceryhl@google.com>,
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
Message-ID: <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
References: <20260212-page-volatile-io-v2-1-a36cb97d15c2@kernel.org>
 <20260213095557.GS2995752@noisy.programming.kicks-ass.net>
 <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873434u3yq.fsf@kernel.org>
X-Stat-Signature: x173wr6rc6k97fz8edobd8mznw415p4b
X-Rspamd-Queue-Id: EA2F7180017
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770992775-414387
X-HE-Meta: U2FsdGVkX18YZRmi+t9edmoStQgTYrfTiapSId1Jsn+gfHs7HaAYCQWt+qDjTJ5O25R446KLUA1aeoDL4DVNdkmDseaLUkGaHg1uWYAs2B6fk8hD0KoQMgNbhzfxTokij+pyCqcfRlodyHbejb+sLhOtgl87cHfV6kaIuw898kyTWvCFU2Hpw+gIGlt4koZsAlwwUWBR1Nj291DgDbRhnlICd0Ntnu2oYZr5aIdCMXklIS8bFSUusP72fXeDb/GqlpowI6bR1fCgJJ9GG9Mehyzgh1v6sAx57DN92h7rhX+U6Yw1zEHoghhZFt9aVogFNEYibBKc+2ExZgB7ZYAeEyX53hp42OZ8IAxazDqfuFVwgrk4hm0eH4puNHT+XMEnPTZX8yCx0ejI+tjlFugDLZIQ57/79yEx/JYYtFBSECHSlT+lrHiN/Q0CtP31wU6m4etOocCpFBX/925etf68tNpCaBJIW27aP/GpejEqpPpEjk9Jsn+w+EB+UqDAb0X9xsyG39A/HWU2Kyrb0D7Vm8RW2/nXjJudjxgTF2AcOyur6xinLCnSlzABfv2Mf0G3KdkNLKXEMwHFK2+GPYmo+N8fb56R0ugNsYO0PQeXY6RT85Tp/iPSmRVLP8DlH9dNZf6Loq6fa6XwWwkVmKfp1u4h+1+Z5kOEUByxZLBIU7Vy0EOOtwjsWdy+50LBLkwUuJasBmMHvX1xS1w7antD12Z5br1PVtHEXtoU+BldCaZBLr7Xbukua5kgR1V2d2HkCoOM9KcVR4/jOS4eZt+oBSN8sAHJinAHMSL+mvnIT9IEo8ZgwkHhcHKceewaTB6EWUfH0eyrSBhAUO2It4vAqv8162HcUpAD3vjNbEp/HJC4GfhZoavJKXrZjYbOennubMXHA7+cw+6s9giyo4O7igHhaQPg+t/fo3m2pwgFPCc+nKSdI7ZA75AkcCJfIb9EDqHclBESGCDdKlrS6ng
 AdtIsE0h
 FoGnABQtgTgKY/+WJs4PizNCNN37YNG7cUZJf2/il01GSHOTysVYmunOtWkG8ZUcLDf0D1GG8R4T0OBP8dvRh9WwPxTK1H4YC1SaO5FB1Xe/HZ7CbRKivh+MGga6/eOzLGkFv7qwcqdLRdQefd9dUZyrQMBcb+bskNqNGKBIK3x4fEb9xnQiMWojXcchqXaC/g58iol7/pRmmUc+DNfWcVJw7D/cZwsBiy34WrzVI3/2OeHkIDEDnVH4s+RXEX6jhfCXbyoicpWUvYy8lRXdyUfti47iKupo766Oh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 03:13:01PM +0100, Andreas Hindborg wrote:

> C uses memcpy as seen in `bio_copy_data_iter` [1] and in the null_blk
> driver [2].

Right. And that is *fine*.

> Rust has `core::ptr::copy` and `core::ptr::copy_nonoverlapping`. I was
> informed these are not safe to use if source or destination may incur
> data races, and that we need an operation that is volatile or byte-wise
> atomic [3].

Safe how? It should just copy N bytes. Whatever it thinks those bytes
are.

Nothing can guard against concurrent modification. If there is, you get
to keep the pieces. Pretending anything else is delusional.

Suppose the memory was 'AAAA' and while you're reading it, it is written
to be 'BBBB'. The resulting copy can be any combination of
'[AB][AB][AB][AB]'. Not one of them is better than the other.

No byte wise volatile barrier using nonsense is going to make this any
better.

