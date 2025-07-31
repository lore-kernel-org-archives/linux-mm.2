Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA3BBC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 09:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D3776B0088; Thu, 31 Jul 2025 05:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6840D6B008A; Thu, 31 Jul 2025 05:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599B76B008C; Thu, 31 Jul 2025 05:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 470636B0088
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:03:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDD661DBF01
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:03:02 +0000 (UTC)
X-FDA: 83723970204.16.50E300A
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 50AE2180002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:03:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b="e/0ZkerW";
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=24f4CS50
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753952581; a=rsa-sha256;
	cv=none;
	b=eD4L+VcoUOirLF3wbZtU+Fv442qlUXcmUh3qdbify3csKss4OxRgCqMcjhPqcLuHPFUpAu
	CDivrR7ut4vG115x8/Q0bnbIQBzFVkRVtz/i0zfyFgdSBp2F2QCib/JGd9G1xd5dyC8Qfv
	bBjrWn4Y42IUAhSalHlAYh9qoJcyC2A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa1 header.b="e/0ZkerW";
	dkim=pass header.d=konsulko.se header.s=ed1 header.b=24f4CS50;
	dmarc=none;
	spf=none (imf06.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753952581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BwiugyGiIx5huwWXGhp1Gaxm7XgAQiVNO4WhfBafE8=;
	b=3B8tqUsnyYRABlkzDezhBNJAYS+VTLxrtt486i8UI8pJdov5Th2LEVUo7ScuqpW6aoP+ic
	8CAV7Bp8g3PznE3BiWg6rkDkxQNr0Y/NVmkuf6aL3kZvzcXMtI5lsQvqr382Y+p9NvYMAv
	eEJxnY2WZLC5ejvleVG7NZLLoVSMPkE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1753952578; x=1754557378;
	d=konsulko.se; s=rsa1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=8BwiugyGiIx5huwWXGhp1Gaxm7XgAQiVNO4WhfBafE8=;
	b=e/0ZkerWldZOJhyo3/TNKzQlyQwDWSN/m8zXlitwCXnrR+wG+qmSEqSaHodl8x+XmshVpWl4zg6DU
	 Jf1Rb6ChBQ8hoVKTkpzYFz29jcnxVQ+9Xoh0CemHD+keH9kdizHHIsPh+KTfqEiIHl1uOrqhO50bxJ
	 REYRelU9ufsTV7QIVSiqII3DTovBqwLvZIF5yTvR+ZFkd1XdlfnaJx4L6TtVy50eV/+WO1lXvd1g7x
	 CZOmMHmOID250oilyVtZgMagshmylzUruRzOzhkbPRBIbpR1VmSiTrx0RCcQWVbw55ZnASQ3TZN8YG
	 vxwXpZ8Bk4lYEXJuR40QklGd6jlpolA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1753952578; x=1754557378;
	d=konsulko.se; s=ed1;
	h=to:references:message-id:content-transfer-encoding:cc:date:in-reply-to:from:
	 subject:mime-version:content-type:from;
	bh=8BwiugyGiIx5huwWXGhp1Gaxm7XgAQiVNO4WhfBafE8=;
	b=24f4CS50xBjUkRcbBmrVztFzUeo6tMFD47Di0TF9dCJJwkK5aDnTsR71NoAxweYI7Q+NCT9HWK1vM
	 x30J+0ZCw==
X-HalOne-ID: 25f7a752-6ded-11f0-b15b-d510462faafc
Received: from smtpclient.apple (unknown [2a01:cb1d:9264:6f00:816e:7fc8:3908:5295])
	by mailrelay4.pub.mailoutpod3-cph3.one.com (Halon) with ESMTPSA
	id 25f7a752-6ded-11f0-b15b-d510462faafc;
	Thu, 31 Jul 2025 09:02:57 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.200.121\))
Subject: Re: [PATCH v14 4/4] rust: support large alignments in allocations
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <DBPO1RQMZDH2.2WFOZO0X4DODN@kernel.org>
Date: Thu, 31 Jul 2025 11:02:45 +0200
Cc: linux-mm@kvack.org,
 akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org,
 Uladzislau Rezki <urezki@gmail.com>,
 Alice Ryhl <aliceryhl@google.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 rust-for-linux@vger.kernel.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 linux-bcachefs@vger.kernel.org,
 bpf@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Content-Transfer-Encoding: quoted-printable
Message-Id: <933C4F7E-0E14-4C6A-AA18-ADB21CE1953F@konsulko.se>
References: <20250730191921.352591-1-vitaly.wool@konsulko.se>
 <20250730192101.358943-1-vitaly.wool@konsulko.se>
 <DBPO1RQMZDH2.2WFOZO0X4DODN@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>
X-Mailer: Apple Mail (2.3826.200.121)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 50AE2180002
X-Stat-Signature: nh7kusknxk9r1ypocys4cuufdyxchgmj
X-Rspam-User: 
X-HE-Tag: 1753952580-224671
X-HE-Meta: U2FsdGVkX1+5GoMLs0tKMnT+X0a0Xj9a0Fw3eV4/e83hY7MP3/p8lRv8T+lh5tIAHPB1YXfC3kqifsXM2g7x6KdidVhuFBjidXiHsYoulNeqI+vm7UpsbptiDpEfR7IRKhXQrACvRxQgVLn4fiLlmyGGem/2xYY4fjxmvLb0hEwA1t1a5MUpTMmZ/Xt2jfh++M7PuyrFZgBaBMHMc46xZRGZ6PmM3XPQXbq5UX/lnP1RIrx2ZeRL3zeJf8bljcKb2zGl0yKnPsiKzBGRIjuD0uwfjTe5jcFunYXK214yn/HyGjSbFDEjyhY5d1WhnIRyH5BXs5LMMx/kwHrTk1nP2wkdbhlqerEnxh1IgWUtVtOVHjOYXIiylHNyOLuaol1g7ncP4J09X6Ei41UekY/zD78GZI84yGV49m3GzbZFTsheabjbVJhgaUSBxFTlbrC7YVMYWrHTqLos1gj8NKKU6j6MWnJAiJhZtQaEkVXSz+xr9AP2fM4B1zdlgExgCrHHgaZAAc72OZuvlBAfbs8rcfVvsAEZ6yiZ+JJf+/zRS0WuxrA82gSUSyI4fSRhvXtn5iolswd2ng0PEi1vfyhp8ullhVHnBSVX20ODbuzSZEv9BRC/WH9QJtN+e286ODkyuKMmflb0dTI2q95tXdPYwQw9DnApWlHwXj2hipcXEyarymnLjaGLgSiYeKOJKCnJH4Vb78LSHb39IvVV0IB8PzflsCHlFknQPy0gndzB9kSaMEdp44UJrHuZPO+SycDXn/OVsQikfwsjGsTy32EuV+nnuBBcx4GB1ZvZ/X6a1srf+Kpts2BdkW+Ml5dm0fbMbyVxIGCsM+YL2/oKWAHxagSwZ4lv3xl1CNeOrvvkCBk4hKuP+NUg8IQskfEbHAfF5aGZGk2Av01qnuJQ2HpLdmKlEBg7S57DT58vYfxpOFsGrer5hTy9Kh2IRYIxhLMgC2j/3E++Uwgc3eCrGQ/
 lSP4u9KY
 85q1ztTuHXstDv4/pf7i663jD3DFE9OUT+TVQqEjDzHONQZ3gl58JdwPZKZLTDRvKoSMbpKX7e/8cUZOW5lR5FImtR7vNjUo1C7OwfiA8zxeuJWRtH6/erHo6E/JqJ7f4fawgPgRzTbhyVaVpSXvxPXrFsT5GDFIspPuWzZQfvqyOaFivFAYLT+vDNWcmVyY+tPRt1qGIT/dg14E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 30, 2025, at 10:18=E2=80=AFPM, Danilo Krummrich =
<dakr@kernel.org> wrote:
>=20
> On Wed Jul 30, 2025 at 9:21 PM CEST, Vitaly Wool wrote:
>> diff --git a/rust/kernel/alloc/allocator_test.rs =
b/rust/kernel/alloc/allocator_test.rs
>> index d19c06ef0498..17b27c6e9e37 100644
>> --- a/rust/kernel/alloc/allocator_test.rs
>> +++ b/rust/kernel/alloc/allocator_test.rs
>> @@ -40,6 +40,7 @@ unsafe fn realloc(
>>         layout: Layout,
>>         old_layout: Layout,
>>         flags: Flags,
>> +        nid: NumaNode,
>>     ) -> Result<NonNull<[u8]>, AllocError> {
>>         let src =3D match ptr {
>>             Some(src) =3D> {
>=20
> I think this hunk should be on patch 3.
>=20
> Also, don't you see a warning when running the rusttest target? I =
think it has
> to be _nid, given that the argument is unused.

Indeed, thanks. I=E2=80=99ll respin the patchset shortly.

~Vitaly=

