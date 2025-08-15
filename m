Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D797DCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 19:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7661A8E020F; Fri, 15 Aug 2025 15:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DEF8E020B; Fri, 15 Aug 2025 15:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B388E020F; Fri, 15 Aug 2025 15:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 576528E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:12:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1E986134550
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:12:20 +0000 (UTC)
X-FDA: 83779937640.13.7E8CBB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8A296C0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:12:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J1Wf/ZXE";
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755285138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lu9jgtKZ2T6q2pUpwqYFZSMqFoGRmsTEkHfvg0OMTMg=;
	b=fFVPR7iH9Ssnad/f6tTnsvagM1Pk46gfSli1JF8J+YOqaDR34y7/T7GF2aSqzXLk6kIIqY
	J3AH4+je1jNOG0wO2MpoA+Q7YKtVoOW17KalHhnRzTrn12DAnRG2mNmHgUxJvjM0oawgBs
	eV/kGsfSLdLAE51TuShlWCHUNi97RJs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J1Wf/ZXE";
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755285138; a=rsa-sha256;
	cv=none;
	b=WEAhO9mNBrqrF2xZKNZKE+nXHYKrTPMJO65xkbivkVUPBtKA8aX3Qu7Km3NachmT2GRBkX
	wIifpKgHSIF88dsdMvmkzo9C7GHUTFiD3JC4nk2DLXSL6MBlcsKjAWUcGPCgV8E5aHqFTi
	Bj/0O+uLVTfrAw1dQTUhLnYsnFrM63E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ABD91613FD;
	Fri, 15 Aug 2025 19:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D19C4CEEB;
	Fri, 15 Aug 2025 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755285137;
	bh=sgy3dyxSlAQCYlsjTTTaZzqp/r732Zhi3hClnc2d2XE=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=J1Wf/ZXE40wrscHg3EpaIQ8FJkb+AASxnoDGlfqVtggrISCz/2BfEnDuXz/xyB0rh
	 kWLqUhsR+UJnQ7Ss3blz44+txjRXf6UyRWci/7GWp57DFtS1SFGL72CtSpA+I3U52k
	 iq3nhg/LDH/YXdRGwHizWq9eeAtayasNM9ke4nFtjKT3F0/eV43KqsII0XdFMM4+P/
	 EPf8s71I0cVF51NBPJFjkFTjxdUStTXF8BaSNuHpmFKEg3wC9JfchE+OPzkajvReLt
	 DB9nL1FIT/bAq3lDojypd+tbuPoqsIRjXMU6IYFhOY4mV52OEVQTX5ULiXUiDpOV2j
	 OBzN56y9X0HWQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 15 Aug 2025 21:12:12 +0200
Message-Id: <DC38NDRET9NB.31UDI8FHB7WAY@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 0/2] Take ARCH_KMALLOC_MINALIGN into account for
 build-time XArray check
Cc: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Matthew Wilcox" <willy@infradead.org>, "Tamir
 Duberstein" <tamird@gmail.com>, "Andreas Hindborg" <a.hindborg@kernel.org>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
In-Reply-To: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
X-Stat-Signature: fhm1hkxxe9oewzsxoo85u9jjy3swyfmb
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A296C0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755285138-692124
X-HE-Meta: U2FsdGVkX1/kjWtPD/XN3buM3XLXRETCaJS0lXGMVIssqTPelgy2xHTNG6bXa0wVfpRDxGZFaY/g+YUTLEBK2jEINL8QKHg0umJKvReMKZSmxhHShWnQoD/zYX/Q5lJC1TPN6m1hP1o4bM/7oIynl7IFuMGEJBBSkmV0nVSUlryxVsiFfyNmmsegQ33Ye7TPruGmOpgT9G7ov22/KXBpaNvh+8rF/cG0w3lp8Z0PxF13awPF/3NKiFpAoYZom7IHEimaM3pEzzEGPkm3MGizJUfHmbBhCUi7k0IrG7bgKrVbqxidO9VBn0GVOnK1GE7C+W3tWvJCSUUYBOW8DByqoJk+xpBynaqFeDY2fr0EES2dEW5CcKAf8H8m7Kar3icvt33hDLkx3LfBGVzlDQzU9X0RJAv6dJOVO/43CXiCA6whAf1LuiNF1WAyiTp0+CI4PDUFu1fbA0FDOKfAMB/xK5ROvX/CpeQyJL/uHEpUFzsJueUOLlX1xjUd6wojhSs76g+vpcPZ/o+5zGty9w+Uy5OJP5U17aAlTs9pfHN894YWU+NIMI3+djUJREqnzkOUnXP+c/BLgF23jx5ZRNYN7XGI/DpGlNjUyJGCjaoBRQFSiNwkTPmjSjMhgh4CTGYyUo8McvJq8liFCMywPR49+lHn7fg2b2Q33ZHtFkKTXAbf8JfRkKGoeSRPpaWZf1hWyR+nQghSPXcefkdM5JktMH2r26WSz48leF4gHlwEUrGrPxn83K8KGAOD+4kM+z3gChKyYMyCYoqZVuHvTusR9HeaLmej/a4hhNBpBGYTEOWJ5/UKFHwSAgxCaXPamW67hAjYWwdYSf97xegbv9Unbm8jx6mA/0QKdwrLQKOGxOsEHTY0mbQanV01bHf2RQyv9c5IutyEO+rM3BSy/d1UuvlmFHwlCgRmFlhPzMfYEo7aVgpOMbXEVOp9LgN2GysY7S2GfjkxZ8Ki7gQiwje
 QfH+BufV
 uolyIFeQe4I/p4UzkzVSVhKLpi7wgLp2vBIHN3TFmF+DY5FmvvO/WIgoB/TSm9+u0WnvDr1FfBIHnAzGgFJNMZlSZTIBvMxSHvnb3aaaFF4uOgpEZY1oVYl6SRFoNqW+hiQb353mx+xTVPfNpUcfHEyPujjxJ+823w8viUkRf6QECCvVHHIlbaxgI9aF1iFiQcqVT39WzbZPgcvDp10Y0y8Y37RBAqtnk2BRSbD2FUWuucEaMjse9Jb3Mt+vTr/2vhKJw+4ZBnoSoSBxVTmyFpwxn4k8cTufqXqnO2LHfvMZxucydYFZblmk2Fkn1RvHeIHeWGwfwVRGsRMPIYErb4TdrDd6esvM5jxe+scCvYdR7/A8zPD/lN9EXXcI9LBf/loueW6PI6PSl+ifujlAq0MPZeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
> Alice Ryhl (2):
>       rust: alloc: specify the minimum alignment of each allocator

    [ Add helper for ARCH_KMALLOC_MINALIGN; remove cast to usize. - Danilo =
]

>       rust: alloc: take the allocator into account for FOREIGN_ALIGN

Applied to alloc-next, thanks!

--

@Andrew: Just a heads-up, this has a minor conflict with your tree, which
should also show up in linux-next soon.

diff --cc rust/kernel/alloc.rs
index b39c279236f5,907301334d8c..000000000000
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@@ -164,7 -137,15 +164,15 @@@ impl NumaNode
  /// - Implementers must ensure that all trait functions abide by the guar=
antees documented in the
  ///   `# Guarantees` sections.
  pub unsafe trait Allocator {
+     /// The minimum alignment satisfied by all allocations from this allo=
cator.
+     ///
+     /// # Guarantees
+     ///
+     /// Any pointer allocated by this allocator is guaranteed to be align=
ed to `MIN_ALIGN` even if
+     /// the requested layout has a smaller alignment.
+     const MIN_ALIGN: usize;
+
 -    /// Allocate memory based on `layout` and `flags`.
 +    /// Allocate memory based on `layout`, `flags` and `nid`.
      ///
      /// On success, returns a buffer represented as `NonNull<[u8]>` that =
satisfies the layout
      /// constraints (i.e. minimum size and alignment as specified by `lay=
out`).


