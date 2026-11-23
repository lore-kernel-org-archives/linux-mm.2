Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52D6C606A321
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Th2i2qeV
Received: by kanga.kvack.org (Postfix)
	id 78A0C6B05B6; Mon, 23 Nov 2026 10:44:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761816B05B7; Mon, 23 Nov 2026 10:44:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6781D6B05B8; Mon, 23 Nov 2026 10:44:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 503A36B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:44:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2D35A8634
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:44:05 +0000 (UTC)
X-FDA: 85466804850.05.55F2747
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 472B7180007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:44:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Th2i2qeV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795448644;
	b=rIK5+Gfmg4pAY9u48AeDYqLtPvdNOz+BetzwPPn9YQk4voSSd4AKXE6urzfwd2nd10eV3b
	koxomXgNSW9PoTFR1aoc+QAPEupDNjkH3IgxdQryTBnerFwVe2w7gAy5CrOmBspsujPEDv
	RGkIX8Nhwy+uEksD8zjOFvKdXJxvvsw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795448644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3SOCtJoKICNsA1ttJ020LJOorIPqLqxhGmSDBRPhw0=;
	b=zpdAex3qpaPZPbRL55uY2YCF3jy7NKnDSpgIg8MVUa8TiDu4HVeudLzrbo6fWgE+yGaCnU
	naqh3PkGfxyuCP1IJRii1laDskqw4e9NaZZC8Jv29MfGGJqx5luOCkom0Kg6l3TqCI5jbd
	9KcpsE4XzB5MtLSNn0/90lCTCdydbyU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Th2i2qeV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FD196222B;
	Mon, 23 Nov 2026 15:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221481F000D8;
	Mon, 23 Nov 2026 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795448643;
	bh=o3SOCtJoKICNsA1ttJ020LJOorIPqLqxhGmSDBRPhw0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Th2i2qeVV+3UqjBguZyjAQDAFIoyWMKuiTL1pshJSMujAM0dt1bpZ5xTHBOavBkOk
	 co26wj1mVHb+tbSpaDj+K5PYIKyN4KJ6y6PA1OoUMqE1Y72nP6Jj5KPCWASS6LIdOt
	 u0XRu7SxOWPk2gI+seKgn3UIHB17yZ7/KMGOtTD2/ZCFVMLDenoe0Vnxa40BQbXBiD
	 XOwlIVBBtTBUSBPAnP5GzwNlfZB92FmEeGSboGEOZEX7Eonc6UJRnsXBs6q0GynV3i
	 cd4p04WMsmf8iDFjqrlsdUwWrgxzqq55jhOpQdp+yQgumL6zE8NKlN46AnSKosU2QE
	 qG2RHrINsTPXQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Andreas Hindborg <a.hindborg@kernel.org>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Daniel Gomez <da.gomez@samsung.com>, 
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>
In-Reply-To: <20261120-xarray-entry-send-v6-1-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-1-1f69d7385f70@kernel.org>
Subject: Re: [PATCH v6 01/12] rust: xarray: minor formatting fixes
Message-Id: <179544862191.2286374.18027596474344839534.b4-ty@b4>
Date: Mon, 23 Nov 2026 16:43:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: hbcb6nesgmucpoug6haqw8c75uqk3gt6
X-Rspamd-Queue-Id: 472B7180007
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795448644-291754
X-HE-Meta: U2FsdGVkX19beoJlT21Fj+nJfYOnt6Umw7VXTZ6LhLTt1cK8Oy5uyTgYh5Amsq7H6OJhIo+3keoKA9r7//Lt3NL9vnfUgn99UpL9wKt2/Sn8/b5XAEhcGirt+Rt/GvY1ivDM95WJB7o3PKd86lF5NBEo4wf7DGd99aq7stv/tzSSDmREB7Xq129P3ywiFqhF4CNGkVG1X/gpYJJUh+lBlDGZTgaKTv0ipOLvXAwDIeSBlhVvoo6pO6SuFOkc4nWihVEOHseSgrRjOSFBWNMFEVrCfa0sfDUoCHbKlZFwwfNNWtag+hhp3CvnuGqLnoKHymUsb8ekAl3cizB7AnolDiWL/S4wLYf5Vg+qpL8V3QdJjc1R2jw/XsdPhC69YLuVigreJlXWCflhkCDR77zp/08MS5SVGhFIZEX4E407OFDLb3P6pAuBH+74Lyc3Hhq6vu97ITvEpU0nwCQb2pxSG+rHITqWdzIZuOnlGsUTfGsrwiGIKIUvkQOdFWyiteAl9csVGw97Qgr685mbDmlEU6kRtULsQp2mdQ6o4HsZT8GDnFiA5gWiZIgCpPmUm88Oj2MKDgKxZnCb5XqQ/SKTe1bDBk2Uw3benA6cIVzwFF2+Uy/d88M22i3v0QvMH/OviZ7AQzE8WK5YD0y+tFvNuaPgrTrBwyByvofHKndcmsfg2e7raK6ZIOSODAwy5iByxRG6rY3o90mECFmW5AjQDR3r9yrHOqLLpnkpLJ6aMO0xsm4L4pAht2msqec2dRAF64KPvIzOIG3Ah0d7juEV34Sb6GibXqlzLgIvowczUOwjDBP9wcYkOLvf2hcdd6AXjovRXhE+dQS4+37GMSPVnsm9hlS9b0I7hxcJNXo3LHZ/3sdNyhUCDqUjT3gwISdDgGGVZqy3ZRm73B/MphDwdvDXXMC0BzzOebz+MNou0zhAQJmgvvoBNsOVMnwgZN1e1UTDM0F7+CR6F1EsjfF
 4OjFyr/A
 MwKjvz13JYddyF4Y0u3c23vghwCgVFoBfb8WreRKGf3POme3M1GV662PsXJ+3zh3iSgLZbPAuLiRL0EInhoizjwJzwmnjW1E8/1CiaVAls+OuPBccSDHighhiEputHIJvOnHCNAENDly4v6KOcq6O/Di04xU5KduOar17tBSRjs+WMM4tZI6dWOGF9dh0/hynQruFJ9P9+bd59gBLHtZup5wzfduKnYbKw2zGTTbCqEopvrHDuBo3a5zkMZHblfGdLu6iXeUn7OFPfcVX5Ht/eAIyQaWL8JiQEYYAiAbcPDdrW/lRuzrUImqhnxwz6Vr8eVDLZtvbPPQJcLLCu9HgrnZsb1yY6nFPydBEGoNz8Y1ezpcoWEzGr+rRehFmCo9yn2at2NyGQEnZhpEDKQNpg/DdgJ/Zn/wgVEm30wyAIbUtc2omhNoIt6O2lG32Y/T3XUMtnXpnPkGSKit6jSH2sQi/bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, 20 Nov 2026 14:10:12 +0100, Andreas Hindborg wrote:
> Fix formatting in xarray module to comply with kernel coding
> guidelines:
> 
> - Update use clauses to use vertical layout with each import on its
>   own line.
> - Add trailing empty comments to preserve formatting and prevent
>   rustfmt from collapsing imports.
> - Refer to the kernel crate as `kernel` rather than `crate` in use
>   clauses.
> - Break long assert_eq! statement in documentation across multiple
>   lines for better readability.
> 
> [...]

Applied, thanks!

[01/12] rust: xarray: minor formatting fixes
        commit: 62cac56c118c96bf2026275a0edc80f1b3a87375

Best regards,
-- 
Andreas Hindborg <a.hindborg@kernel.org>



