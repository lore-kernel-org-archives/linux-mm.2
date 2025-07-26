Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 250C8C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 16:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04D86B0088; Sat, 26 Jul 2025 12:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB52E6B0089; Sat, 26 Jul 2025 12:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAD86B008A; Sat, 26 Jul 2025 12:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 88D036B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 12:23:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A56EBD322
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:23:42 +0000 (UTC)
X-FDA: 83706936684.24.3A26E5D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id E76DB4000A
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 16:23:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EQYktzuZ
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753547020; a=rsa-sha256;
	cv=none;
	b=v+wXkL544VEZyI4jQLa/YDXp1YIYldYY5DbF6coYH2J+6YxCSQERoiiTrZ3crJOUT0xCHw
	De5pU7mf26t86iJs5oXwIpqvufueMGZ/A6slFqHzjNCRAIvyr/lsPb0mdz7afdbucCKbxq
	MYuaF8QdaREYyZK3vko23Y7tyT0Kr0M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EQYktzuZ;
	dmarc=none;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753547020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCelaxmFLQrYbCRGNGoWn94+fWTBVluOpP8vBuCzlJc=;
	b=Qfz6KOUhqcVhBniWabGJXoPN1Saa0EDWMYhswqLHGH7/4DFWgQfwmzAvahQIK7DdGiN6+p
	WWCGzSXRT//2HABqCv0d60hs9HSMQBz5tNNe3s6SVqq7WBXocEY9ZOkwCpThxCrxSNFzSA
	x300eC0YEsXEW3aQdt2Bo15fCy17pao=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BCelaxmFLQrYbCRGNGoWn94+fWTBVluOpP8vBuCzlJc=; b=EQYktzuZkvxfqM2Q5J90Ab3f1F
	O9AUhlPVOrtk8aRkWbDVX3IDvRtAHZWLdFBHj2bTbx7gtaMJuZQpBRWSdyDMNFW9Q99wVjpDjV3nY
	PHDpijOGz+OcpZS1A1azojnxk7gLfymJqZ6REW1+iwlZopuwDIFBFi5Hh1ImSkxA9po3ule/SCxdO
	xBgTTQvyCQxFN2LCfQgMcByZoKLTBpsxOi1uLDVlLAfhIDCO6SYcXuxvgAmgB+PI2DJwDJtAJ38IU
	aAvtCvxWMdZGInv8FNsLkEW3UYrJo6rAPbS+yFMkzQOzOJGdO50gnu8oUK7sLbcC8jDEyH4AR4kqR
	XxKa0Igw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ufhgC-0000000Ft6W-15qn;
	Sat, 26 Jul 2025 16:23:24 +0000
Date: Sat, 26 Jul 2025 17:23:24 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] rust: maple_tree: add MapleTree
Message-ID: <aIUA_HFLXMYNxWDM@casper.infradead.org>
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E76DB4000A
X-Stat-Signature: 7mna6ibciyi16njitkeh87dkcw8ydzch
X-HE-Tag: 1753547019-533361
X-HE-Meta: U2FsdGVkX18ysZ+ytgLVvCcmfZei/NnRQ8EGJY15S9NrDoARGkpTZf/Pi6AZXVRNngrlDHJQvQhhExYIMnbjJkOVDPrBJwzM++wQlDe+oCjOpBZcQ7U9hHbGce/6kW7mW8jXW/1tqsCd05EaEDh+LV+i7v1zesNQfbNQX5Ny0x2NDNr2XLg2BiyKgze7NbNb65Ro0gOdqxm+ILLbqKJHRD4pKU18mvv2F0B+oak0YF26fcOf6HPhV6Ce6J9Y0HIy3S4SEjH1sFI5PO7ovM6D5PRT3zkeTUxivT53DvFYgbZ9r5Ui+M7qRkcWeOzLLWXQXW/dGT2LwHrrEpkXKXwqXik05O99tcxDaBm0vOnuNSYybIyvLeio1bgPGKji8GEMqu5jYO61KkK0gsiOmvnxn4ZpRWdJF52V22V7EEx29CEnHReL5VvlZpj7UzeeVCIQjorOOsb/9IcyVnfKReYXJypymACQoZuKIX63bTt1YyBTAtbWJByKL3oC/jgrahqrJCKqGspwEqtlu5jUNbtE1ZaVu86rrVvbHAkbejXzL78HAWGLb7H7u93txc4LKYNnnBVzJ+GZtEskslFZOWWSG9DNEiU4ISJyfdxiM6pcxzSKammFYuwSFmbWaToxoh1ANxsMVShRMnK42jGK9QNByHgHZrK+sIQ1ZEuKwuHmIu4cvU21vtep2YEhN0QxupOxloNJ422ownIMPTkTX7zZM5FxDaCxqgpslyiTipjmtkdKZLhgp6EBkawQmqGz02HkzU9tlKkshwjE7Th9PfkvHBvP8mVvgurj+MUvLGG41exWROO54yRmiBS3p0OPX0wnVoICNON/+0T/f9f9mcA+VAlxqYkQpEYnlsZQ4tZuOTS82+9RHPSwRgIfCIQ8gY2rsBW93HdsfirNlNzTCdxH3DdQaR80lJIv5H4lYZUaaZ2kF1VHOZR09lCus7Tc3a4MSsN6xQM3bwRHcqnA/LN
 QCVAaf8G
 SmcxpjBjNM1vTXjdM3Cw8ro2ISeagIM5JJ0ZPAC/QxOD5wVmW1YrOyyyM5in4PTaKOGZeWqqPSz8HaOvnmmCBsMdWSzY6bYqYNdhs1T0SQxd/7cPCvBAL9QlmHEjZgiPic4rv6KoEw9fNdQI1sWKITupRMclE7Wn66fTWwzTaEyVM909Zn00KgCP6knItF3jgTD3o91RrQezsSNUZNkdlt2h5dQIpz8mpPsqeP60KawNLFCfY+9medxBFz3eWYKx9PqbI+z8oO2N2Bs5ehJq57riMnaL4rgw2pEpXIkIWVQ8ivI1Qjgg/DBbqqNcMWZlPNJUx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 26, 2025 at 01:23:22PM +0000, Alice Ryhl wrote:
> +struct ma_state rust_helper_MA_STATE(struct maple_tree *mt, unsigned long start, unsigned long end)
> +{
> +	MA_STATE(mas, mt, start, end);
> +	return mas;
> +}

This seems very inefficient.  Returning a struct larger than two words
(on x86 anyway) means that the compiler implements this as:

void rust_helper_MA_STATE(struct ma_state *masp, ...)
{
	MA_STATE(mas, mt, start, end);
	*masp = mas;
}

so that's about 72 bytes being memcpy'd per access to the maple tree.
Sure, it's stack, so it's cache hot, but surely we can implement
the equivalent of MA_STATE in Rust and see a significant performance
win, at least on read operations.

