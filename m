Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5152C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19D86B008A; Mon, 20 Jul 2026 15:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB246B008C; Mon, 20 Jul 2026 15:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2C26B0092; Mon, 20 Jul 2026 15:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 833E26B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:22:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15F9B1A026D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:22:29 +0000 (UTC)
X-FDA: 85010126418.11.36D4A78
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D843180004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:22:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RF8KOPKp;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784575347;
	b=VjMsPjSmIzq8/yDtxnkcG4tAbjRZkcbRU5sQSofaSUcigRNePccdZ0oN2pQYvIWTKH8yv0
	aLu46taXs9TuM8+e8F2Lg7uzlvTmQ6AGFP+1VdRM7phZ8LC9jVuiwcNm5SX/dmfLIyQ+rZ
	vCdvgb4vvmeLK+SxIfxewfTNVYqeQ2E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RF8KOPKp;
	spf=pass (imf06.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784575347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=buSulj0niMnq8+3SEkE2va6OH4OHLuTOlnVTBykjR9Y=;
	b=VHFRYhft5jXjJScm4dS2lx4x2yOrXL4JWxm2kjbZs5ulBDgWwJ9uckCI4x6FO6AJ2Fmz+3
	bjr1GXDg5G9nsqN2KuD2xubcXdeANXgri9ehA+pr5eubHFQNwLv+UNa+Pb46kFbSiqNZu4
	+Fzl7b89ECcoLXzYjSbneTnrw0b/8lA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=buSulj0niMnq8+3SEkE2va6OH4OHLuTOlnVTBykjR9Y=; b=RF8KOPKpqr5W+Gi68jazESixL7
	yHKrPoTrXZEm/XxyQKZo3DMkebc2werCHOBh7p0MrXnVVg/H5E48HFSW5Qi+SOw1yjZ0bk7tx1ixq
	gdOP9Usu13lStgDIxxPtVhDdF/k/1e4qd5zi0Uroeyl7xyijJHsaHNr2Cni2CwnXZPVbVsNOOA7N0
	W/hiIYXCI6rCNZeruFI7+7eN3hOX+m9i5fZcfTpqU78boC743lxmEJ11bMVIrbV66hLMull0tdRQd
	EOAkkRiGl+Ap7hvS6Vu6iPtEGkcsGCECbPzQP1yU269JAiiteqgB1kVwd1GVnguZGw7We5/d+MFyl
	1anKhC0A==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wltYs-00000000450-2U7y;
	Mon, 20 Jul 2026 15:21:58 -0400
Message-ID: <f32b1d2d272e9eafaf0a68be236c84a0585a62e3.camel@surriel.com>
Subject: Re: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 	kernel-team@meta.com, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes	 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,  Alexandre Ghiti	
 <alex@ghiti.fr>, linux-riscv@lists.infradead.org
Date: Mon, 20 Jul 2026 15:21:58 -0400
In-Reply-To: <e9703d2e-f815-4d96-b5ce-074aba281f76@linux.dev>
References: <20260720115741.239657-1-usama.arif@linux.dev>
	 <13ec2603d5cbfdc493939f182b71e5133c26af54.camel@surriel.com>
	 <46dc1b58-f2de-492a-9da5-a5c429c19a10@linux.dev>
	 <51c0025d2eb885ff1f4775e4d9ffcf34f478f378.camel@surriel.com>
	 <e9703d2e-f815-4d96-b5ce-074aba281f76@linux.dev>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Stat-Signature: 5be7cjx9f3sejti5traa77neosthyjrk
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4D843180004
X-Rspam-User: 
X-HE-Tag: 1784575347-923110
X-HE-Meta: U2FsdGVkX18dMLOC4oGl3YMP4WuzgadzF2uQWT1ssdauSW9L+JoLSTV3u+FkoKyPXHmr2eIcfdr8ezEARI/eb0GVqzMy+YTpEas3T36XxiznMOFDrXY1umDMVqLuNRZg1IKI4W768vOXtMcCJF5KyglDVc815LNXpKtznVkLXIKEfaqtdoTZRrruKY8ZwdKiQHsttJ0WXJu3ZHDy16/JxpxIHoEAnVXMzcuauWW9URyN5WJcrsH9aAIWWVxCIsESyp984O6lwTwoBfV4VZ6aAHTRJeywH0lBGNLt0F/OdrLKsLVDpFzRGujUqlrY39nWTNhSCwcb04vQB1pBnUdU5g8gY5oNGIWM0oQajDBmLQk/JQs16bu6M1bILuh893On0LhIEAKozT1T5IXoxk0eL4l1RYx6478n71BVBNdOzvBO2shT5KTAGh7Qvc6AypK9wXQakNdxoacj/K5SJVgZm53eTagjo93PJJ10wNGjMlJ5BoATfl9mxokhqPE7GRhNxBsK9jDaN4bQ3yhoQUjLaEeTXOsOgsQUNk/nPbIrxTuiNAPPpZxVnVRuDgHYyykLr4Qw7IfQDt6lEnk6sRnhrmLdCTB6ybHsvrGXeqN9kjGexr8i5t3mJSOBWDr+xMXydVrV2Ny9s+2bUDTajbFLr2y2hckEHsuPFcbZBdmnhb8n/ccXCm3iq0z42amCjTWNI09Is49PQDmvtI8T2RsgiH0mmnIlkHc4NUUlOPKStMGtPNfVULop+2cn46ho8ch70YetjfMCzUOVA/8Tli5eFQCN/3ZIXxZMbyhO7B3TFcbFYnOq8asBpwc7jPX7ArklO4WmFRgIaY/RULH8eDTmLQkXB9VhoTf7H1mR0kVj8LkouAg41xsFsoDfrBbEr1lDWuseVBO/1Z+VXUr/eJFixm+f2qbqJ5/pkjClhT+bnI/i4xVyvtaWKGVgbo+Ys1TNZjCC93tyAsmVdAFJVbE
 AZfj8f8F
 hTLUwcr3uQTo0WJIAKQ09ikBRapf1JCXAHrQw/bGcuickBoIsPZFkP8K3Xh8gs/W4//5yxgZQxq8H+ZtsKQWc0PJLMPca7oXPien+CpaVOn0kp7+4XKEIHa+K7bHC3PwUk+Ze638FWX4o4rMAM9tYGioxaq1Er8t1z0DeFm4x/0uFsmQt7lMcb8UdYNG4GHKtqESuSIaYTq2YWm2CTHCBl/h3WspunUiDKcRJ41MRtbUeU5IugmXJzSHMxEJ1BtsW35O4v5PsHjecqHnFCoPtnmbIlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-20 at 19:46 +0100, Usama Arif wrote:
>=20
> So my understanding from exploring this code is, and hopefully
> someone
> in CC from riscv can correct me, for example:
>=20
> Tagged pointer:=C2=A0 0xabcd000012345678
> PMLEN 16:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0x0000000012345678
> PMLEN 7:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0xffcd0000123456=
78
>=20
> The target VMA might be at 0x12345678, but applying PMLEN 7
> to that tagged pointer does not produce that address.
>=20
> Previously, the order was:
>=20
> Take mmap read lock.
> Read pmlen.
> Untag the address.
> Look up the VMA.
>=20
> Changing PMLEN takes the mmap write lock. The read and write
> operations were therefore serialized.
>=20
> The new order is:
>=20
> Read pmlen without mmap lock.
> Untag the address.
> Attempt the per-VMA lookup.
> Possibly take mmap lock later.
> Continue using the already-untagged address.
>=20
> A concurrent PMLEN change can occur between those operations?

I suppose it could, but what are the possible outcomes here?

- We fail to untag the address, the vma lookup
  fails, and we fail to access memory.

- The address is already untagged, maps to a
  VMA, and the access succeeds.

Are there any others?

The VMAs of the process need to be in the bottom
part of the address space, right? The part where
untagged addresses sit.

For things like /proc/<pid>/cmdline we should
automatically get an address without any of the
high bits set.

For things like ptrace peek / poke, BPF process
accesses, and others, I really do not know if
those could get tagged addresses...

What are the failures we need to protect against?

What if something comes in with a tagged address,
but the process disables tagging while that
something waits for the mmap_lock?

Does that reproduce the failure case, without
any locking changes?
>=20

>=20

--=20
All Rights Reversed.

