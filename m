Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE40E9A05C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 19:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4746B0005; Thu, 19 Feb 2026 14:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC446B0089; Thu, 19 Feb 2026 14:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB356B008A; Thu, 19 Feb 2026 14:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 374D36B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:03:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AABCCC22D8
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:03:11 +0000 (UTC)
X-FDA: 84462128982.26.AE8DC18
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id C696720003
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 19:03:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YjHL36mt;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771527789; a=rsa-sha256;
	cv=none;
	b=0gn/GRK2kAYBIdTmbRf4AqmeX5Z41/HX+29nHR1RxgNdMyObFxSJuGekhCGbpTfGuMF4WT
	8oEMJKvAb2ceeFZOUVg1dVEijtivtb33dRZTQge039YpYY43WBZI8FzektdMwwgqf8dmfM
	gAktMg5c34JTn9kbNqdI9M+9JQlv984=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YjHL36mt;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771527789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmKk/By0d6RKmDgMTzg9/YoIMJ9w8tE5cRbcyNJk3j8=;
	b=jx/3miBhhrPHwbS5nydBmB1A7RFaHqrGKDdAzt5dca/ZxNOQyLs9vVwjQnXibwscjWjIMx
	yba4vj8a9C0f8ikLTJtwIImpbwQmILsFv6+y8TuMeVKVqiLMt7aooEQiATBJqQ5nXxPSO6
	faSc0Sn4undWvn+jBokQPgZOHfYQ2kI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kmKk/By0d6RKmDgMTzg9/YoIMJ9w8tE5cRbcyNJk3j8=; b=YjHL36mtvhtRzCYsI+V5P5uuIp
	Q2Z5GxCSp3txLFabtIID5JbibUZj01/UMa4E9XnvT8UyoZakfM41p64e9GtKQ7JmXmO5d0zZDKaVm
	c1M5RtX1yhK7kZDyE7NIWiws3Bv1J2HlzBdeji39nqr5XO4eqMCg0EgZIhjWICEa+FxaRArgViB4f
	NJFnkQW+fQLNZseeDDgZnltzTnY8JBQ7rWIVagxDUWkUEIZ3eQhDNCiCnXlCRu1Kd/J9rxcEaOsSC
	KI582Epg9HYQRYAqcRJzWUlEycRzyp2tVdhh6rLY0P0+eIgdBtnr9pLMHZqY5T5ZwSpxk8sDCaTQJ
	+wCwPrvw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vt9Hv-000000000n1-2Xsr;
	Thu, 19 Feb 2026 14:02:12 -0500
Message-ID: <0c81121c23a9b1016425da100f11cb31feddd7ad.camel@surriel.com>
Subject: Re: [LSF/MM/BPF TOPIC] Beyond 2MB: Why Terabyte-Scale Machines Need
 1GB Transparent Huge Pages
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>, David Hildenbrand <david@kernel.org>,
  "willy@infradead.org"	 <willy@infradead.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan	 <ziy@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, 	lsf-pc@lists.linux-foundation.org,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>,  Kiryl Shutsemau	 <kas@kernel.org>, Barry Song
 <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, "Liam R .
 Howlett"	 <Liam.Howlett@oracle.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka	 <vbabka@suse.cz>, Lance Yang <lance.yang@linux.dev>, Frank
 van der Linden	 <fvdl@google.com>
Date: Thu, 19 Feb 2026 14:02:12 -0500
In-Reply-To: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
References: <540c5c13-9cfb-44ea-b18f-8e4abff30a01@linux.dev>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C696720003
X-Stat-Signature: mxyonhmur1fctkpouorgzyuwx9j5tqsj
X-HE-Tag: 1771527788-279460
X-HE-Meta: U2FsdGVkX1/zvXmJfndxTptAwSTctqMQZHV8BzToGWh9LNDpD6jFqovlEt3QZotDwXksABqgyoStjPN6Fh9hRr1Kf1RCIx4Q6mJQGiGwjGsvXhuxI5WXidk7Vt9Q2J2NuqXvRU+ZgRtNvqShUREFESXDZ6J28ph3rZOmKB5z1Svya5BMEGKg2nF5NCjghrWfmhpjjOECq9B3eP1sLvJdwv5HcgiIhR03ZEORZoRsNvK2vp7hqZkOh+aSADtxG7EksRlifzr7tf/OZPpP4JUo2QVdChALrZj1InNx5PFfXLYcfvLksmY0TWMF+a1g6JIyBvGMtrr8DFF2KwS7jeWw4H0AcKZBb9Ns5twzU8/Gfo3bMiOagQfFOIb3yGj4XqyVj3XRWJsQRdvDKk5quts0hFEQ+oIyxrn6R38VZKutJpTJlQZIiNrsaJhwEfPWE3kfoqmp1S7Yh+l/dHf7tBx2EcfWnlKoRqtb0LNJh6kHEmwgQsxJ2YbGJFfFTt2tlV0KZe3YtmOMALqbGy/ZhnmdYdhBM0utSOjZXr0W8fOUdG8Vjx5ELC+c7uAPvUXq+crwcHvpl3pkBAmE6FQCW+vaoGRQbizD9e4UWBT96PE2+MoHHwLCBHeDmAQ2CGMw+y1hBHrkZ2t5YPpGYTNRDKftjp73/FZ2CM2n1EE1Z+M5s+zaOkWsSXbpGcYn3E2HlMb8OgQbbcnlBa2r3+POEdtoJZAW0Ndtd8yBfi2wKounhd26RyyNIwcEpRKG8sOqW7dx9IxLTNPh3m027Om33cXCzg32h7XtJOrNZ5MSvZgfFUNseF4cZkWao8W+kzsYGW9MZJp8I+de+n06R+ePz111dQCE8dOLMzKYO1+mU3gj/Zyb3a+hTNM+BI/e5UvJggOnofIuHK1X6l+OXN4bOSHRaiyVKfOtXImuKaGyHkzlysNu7oQCopKUmK+CDqFW3mftSrq06jliy0sC8wEmIXG
 SeEI8Bd4
 5cbcpbvxSL016fd2KhJKUrLZXdpFd1LQUOMVwNg4+nhczsYA1MC9opw1nlxW4Qcdr1xxqSF1YHxF0ZpGirvkg0J2xKoP8lsmzCVjvwzTqwRJQ6FxpVFATsQub6HLLJMqD6nAbC16U1obEYmfWCWGshAx0cj/ga+N2cy3E1vl8nHqcmVbRUb7tTCSJ6x1tqg9c+9HvK/8wNkJOFouZHJv2rJG41zxieEPurDuukaETKL+shtQUBaIgLQJIEpj5d7FS6V4bfFEuo5wMbj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-02-19 at 15:53 +0000, Usama Arif wrote:
>=20
> Is CMA needed to make this work?
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The short answer is no. 1G THPs can be gotten without it. CMA can
> help a lot
> ofcourse, but we dont *need* it. For e.g. I can run the very simple
> case of
> trying to get 1G pages in the upstream kernel without CMA on my
> server via
> hugetlb and it works. The server has been up for more than 2 weeks
> (so pretty
> fragmented), is running a bunch of stuff in the background, uses 0
> CMA memory,
> and I tried to get 100x1G pages on it and it worked.
> It uses folio_alloc_gigantic, which is exactly what this RFC uses:

While I agree with the idea of starting simple, I think
we should ask the question of what we want physical memory
handling to look like if 1TB pages become more common,
and applications start to rely on them to meet their
performance goals.

We have CMA balancing code today. It seems to work, but
it likely is not the long term direction we want to go,
mostly due to the way CMA does allocations.

It seems clear that in order to prevent memory fragmentation,
we need to split up system memory in some way between an area
that is used only for movable allocations, and an area where
any kind of allocation can go.

This would need something similar to CMA balancing to prevent
false OOMs for non-movable allocations.

However, beyond that I really do not have any idea of what
things should look like.

What do we want the kernel to do here?


--=20
All Rights Reversed.

