Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096A7C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 17:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94526B00A1; Fri, 26 Jun 2026 13:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44976B00A3; Fri, 26 Jun 2026 13:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33EE6B00A6; Fri, 26 Jun 2026 13:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 906BF6B00A1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 13:41:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1ED01C320F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:41:45 +0000 (UTC)
X-FDA: 84922781370.06.9344844
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16EEE1C0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:41:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ivD3KYox;
	spf=pass (imf21.hostedemail.com: domain of engineer.jjhama@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=engineer.jjhama@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782495704;
	b=E4FGNDvx9XH8VK2nYnlRMqcVSrDM/mDq2if9xQxbSz2iAKt7YxLNc18i2mt/cIizLrWrA2
	/bTXFNRhJhMRjcoxp58N+vRb2NFqLNjehfEDirUPLHlb/pvgx88N55IWla3rSFkdtwcd5a
	dWOsWce8Ha5TTs2bykaRp1pXxFzVQng=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782495704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLP12Tvnhxz7EW5GQyhj6jTfDrZDZZGaLiZTc/gpe80=;
	b=tq4QWyEfAwFSn9oie3yS8YOr54l2OQf3VEOXaMJJ55Iebm+wY80iHSlg73K3j3KIUK4sxg
	sE8shSu1gsCUIxRDuVZ5ygKv46/q5loM8Oa73YN859hhMkHy8PG9ox94xFC42uzr2lj5lU
	D8lh31a5RBHb411mwojAS6vvxqN+zWU=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ivD3KYox;
	spf=pass (imf21.hostedemail.com: domain of engineer.jjhama@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=engineer.jjhama@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-69d8f70cb0cso1040673eaf.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:41:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782495703; cv=none;
        d=google.com; s=arc-20260327;
        b=Dm4mX9tIa8BhpFCgpq1+rbszgpsj1UOXT8IHK6XJWS4U770pbXWeki98YsAJe7p2a6
         dzODgyIfoidvdIFlqJSIebBAJB3bU523LI1Fv2JgOhDxUF/piZczhRWKiw+j/p/U697v
         j470z2chLzA4+/ZF/Bvq1UmPNNB4j3a6VcIn4TpG/kaguP2wBXCvDsHnkVacDq8FVQxq
         +YGhN/xyrgi2h/xq8LVzK4c0EUsN+CiI2b291flmTIWw4Fa6WZj4MTK0tGGrcNar+FDZ
         i2X07dS6iwwvll3LSZpDQwE79fWwKO6rtGVjW9K7sQxYH/pb74Drb7ciKBu1ws4q7vmp
         45gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jLP12Tvnhxz7EW5GQyhj6jTfDrZDZZGaLiZTc/gpe80=;
        fh=GKcyMErBGPX9ZbciDLTT0+iNUQJax0ttYicmgyyusPY=;
        b=Bql7dZWy6JFHQxb7GHnBLd7Gs78jFetwgaH962zS93Xp4OfEL7ZW7+3I4Ot6f3sfxB
         zUMv9yARp8uLWNb0tcMb0dzSrcg4if3dbEPKuRUXJn1hUeHMw0l10WO/LtxXdVlmPRcg
         Tagm0763pKCWe1sXWQFJe9S51GhOTKVXGS0fVNREzrOvQIPP/b3RrR4su6E/1bAbpdmn
         CVt3INXKm+LMFDW2HY3Gvi0KKu+VZxCY/GIYvQ6G70hVDYRvooV4EdBhcGoz4uUnRXwn
         JMG/Hwtino0uSjgQ59TuhZuXSw4UhbxsjRsbeuAIvaq1lBSZ4ywJrdm6w5UuG78x/Gc8
         5lAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782495703; x=1783100503; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jLP12Tvnhxz7EW5GQyhj6jTfDrZDZZGaLiZTc/gpe80=;
        b=ivD3KYoxmBhZOz4VnLH4hQ/dh1iAE8lvARuDjF5Os04JPsik99leQI9sLF/B+2Wk6U
         TeSKTlDqwM18fqgHEEcMOqrFxSQBupaUhAObUpeuyjSs0edhmqsf3/ghRfe9CmSf26+j
         8JioorLc9U3TXS9pTJTuUUdWjp7S3gZiCtTL/8Elg5DPhAFO3JdeIB2b4TeWHZi5Ef4N
         HmrCFMd7CZjJRJ/6ypic05jaFkMi4p0hgWGUJT5yjRBkum9OV0vaiWP6PYnatoo+2+8d
         VOUEf6mPHYZegAoR9B2i0krMKfvHz5SfBuaORvUPrzflw8tZlBAid8/VqUGec4Psmo1Q
         Etsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782495703; x=1783100503;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jLP12Tvnhxz7EW5GQyhj6jTfDrZDZZGaLiZTc/gpe80=;
        b=OLznb4LXuBPckQgpH8CVI/PnoHiLF3sihvpYAC84g+ygaob2jeQOoNNFHk6OI5/loM
         V4yweHGTcU+vUOwKohVsaB0WR7oODobXspuzvPIiAUMUTcB9EKpp5oXLpr8EW/kcNhSl
         WG9pUDLkGj+4Ah2OaYVOSvyHdeJZmBJYiaCRfur5+Ss755GA84eWYRrlg5oogLQSALfr
         si5owTd4std7gNFiu3wiR+EyT80IgugJ9VBswRpe804UthBmzmrpYNai4qYUzvoV+UkT
         69QQlId3aE3aCqff46S7S9/y3iT3jdpt2B+WOLKjLwMWXedIDGLv83V1JPk85D8rgxH5
         cDPQ==
X-Forwarded-Encrypted: i=1; AFNElJ8XKXM4DseeF2FWjw/aR9PuKX/mI2v337S0D+HhvmO5xB6uNUnUazyQJWTWXi0B+nPWjrxPlPr4XQ==@kvack.org
X-Gm-Message-State: AOJu0YwPcdu077UzOfvqiDmhBXJzsfOUWsspmt8eKyV+2fMpUhe19oZH
	iTGDyYOvFZDC44nyC0RnYFgmZnSIm3LhPorxQzRJY+x9WJ/WqcHz0oP8DxfwrpVVvwTWpFfpZcb
	BFSFiru6/WAoaXmEJcJqtscI3DE5haQo=
X-Gm-Gg: AfdE7cl3F3ean2165P9CwP4ltYSrkJbQi+jt1MaoE1/HHnzgdRwj8uLQNMTKHe2IbCD
	fxMgFeDw9UbIMwkf9Wv/zieaHDcGrzGQ8YFsvFXjTnuft8mXez+JKN41MdjOfr85iXL6mKX9PJT
	XH7cqTdBdbPa1v6aZth4uOPM0IkCaEH8+VXTz9g8uV+8xcazLU37VJGDGesmSlDla+Z7HV9yqym
	ZvzgvSG/fZhTWWDnEs+NgL4K5CgNFnkkAZnD249wxhhkhA5M6kvyp2L6/K+O3IP4X1AFWcbrdUd
	D/ob1JWsb4VXRrIdp/CA//Zi+smj4GhgKPpxIhP3RBYUX4uqX719hKm0gZ68FaGloqld7bWCrxs
	7qaEdTmGSSSwjjorQyvqF2aKV
X-Received: by 2002:a05:6820:a0a:b0:6a1:50eb:d520 with SMTP id
 006d021491bc7-6a150ebe0e1mr877474eaf.65.1782495703089; Fri, 26 Jun 2026
 10:41:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org> <20260609-rnull-v6-19-rc5-send-v2-10-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-10-82c7404542e2@kernel.org>
From: =?UTF-8?B?7ZWY7Iq57KKF?= <engineer.jjhama@gmail.com>
Date: Sat, 27 Jun 2026 02:41:32 +0900
X-Gm-Features: AVVi8CdvARASe7Bopjeo_gHK1uUJA3mCPHieQrToP-jIjvw3vAaNLMrYIkVgFqI
Message-ID: <CAGAB667mVuECQDwYDij5PcZ-fvqr-6womuRCHibrwiR_wP=YDg@mail.gmail.com>
Subject: Re: [PATCH v2 10/83] block: rust: allow `hrtimer::Timer` in `RequestData`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, Benno Lossin <lossin@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Gary Guo <gary@garyguo.net>, Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Stephen Boyd <sboyd@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: muj4wabhunt9xzc49s66kwtqccjpk4rp
X-Rspamd-Queue-Id: 16EEE1C0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782495703-725816
X-HE-Meta: U2FsdGVkX1+ekgg9SnD0LnZNPBLIU4cfeFSbiEqsECygMe7JQJyEy8PubaAYkJ3+0QbtiZmH95AtTf4lixNvei8yb0RkLkq9RaxT2Zp6cimnFDI4taRD5O1aghhWYRiKJqWm8qk9yOmVMJ4JLRbcm3Qydj3/ajUaEJWrCLG3jVJ4dKhywdZ2c5soTy1zTrw7eO8nta4XRs3RFsrYM0hbH70qybgmI6imlbLSQ8XqtLTckmb2jslAShshIw0KKH6EvhIfc1X7IOWKTjnvS/wAf52RNybUPsr0WIy7gP/ZIlaUnaYYL3qnGtWh9VZMnwh75asskn+6V0u/aP8ZUSPguHzKj8DV0x3Ft9Py8pJbTdo4gvoFqcwyDtW3b8TjKnFLe7PyJEL7tcS9RVGSp2LNlmMm+Zx5ZsstLvASoCxSexFpxsSTsaewvuqqm+HBSgG3jR5CQc1kGrarB60Mo80HYG/k7Yws/Vbcv0OBvS+1EzNH1+/3XPJYXvjqB7egIRXCSvJnGivHBfETVDUs2HfHVf7VdVdQYeW3GveryWiqN1fdJifmsKS5pIEZxVH4+8VLhA5G7/zb5vbQTbab5SkQE4vuAZPS5cQvlO+c9UwGe+ZuejcbITOYo5pcGwE3Bo/ykUEaoYiirSr8/vDe3CyoQ5TUI/AWSJddVpXc01LtO84BM8uF+vJLSCGyed+d3q436AuXz6AxjLpGMJQrctQciRKogE7sItCNziYJbzxoP1F6mHr3h+doHUFyGSfiJSnCjMewIVk9GScwQ2miUhHMefTWilq99fxCXH/jI/AdvupUTbkUTFg8Wo1nGCfPnJAMcGx1akZFRzutkA1JDQc6pXoWksrXl47I9+HBhw0j5lZrEsgC19NA7Eq3PTHX15B/y9q17pQHhMSok1A7Op2jLXnUpfKvm07jY1Kapbph2b4AyJoms06RmhMgo5xe7hgRfUUytsx/GMl27Yv3sEF
 l3ElQe/k
 X9CPRsoafKHyQigdOGH/tZiH1wqlDDof6WX/ioxmjRgGl+dHl1+PxQz96QrcfMxiaNA5A5s43DxF0rLLzOtl2D/VIdiNdhrAW+gfnxtRxunfFSIKKNq4TFZgn3cM5tsWfqGgxWMoBzvShF++PRKz1UaG/6oiLcOtPFj0X/U04P1fham8oLsRvf/rQS0Rmj9a0gYLFWm7/l7ETcMeLcNZj3uwDRC9QucRbf00YAcVFiQisXSr1Do68MkF8brinwRFCTYN18iqbrCdjC0Ko+/qBp5VEEH44GkNWJrV3HOQ1PCE9wQtVzn5lCHavUdQkWZWKpCBf7bBHWj3AhY8F2wLfAdOB+22jAmtsW+QNFxHpaOnB/tmyxLax2jIv3ptPU0Mrl8oRozxtBFcyn+6CxMcE29aXS2PD3InuP3kG0QMbCc/kIT7vPntI5fLloH4FknPSHZYX3lssOGeTLbheawKAkxZqrbVosFr3N+l9ww0fakebsz+G/O/+qGWLU6fjJy92idluc7yR8euoTANZaRcSQuxoBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=EB=85=84 6=EC=9B=94 10=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 4:23, A=
ndreas Hindborg <a.hindborg@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:

> +    fn cancel(&mut self) -> bool {
> +        let request_data_ptr =3D &self.inner.wrapper_ref().data as *cons=
t T::RequestData;

I think this trips clippy::ref_as_ptr, which is enabled in the top-level
Makefile (-Wclippy::ref_as_ptr), so `make CLIPPY=3D1` fails here under
CONFIG_RUST_WERROR. IMO core::ptr::from_ref() would read better.

> +        let pdu_ptr =3D self.data_ref() as *const T::RequestData;

Same here, I'd go with:

    let pdu_ptr =3D core::ptr::from_ref(self.data_ref());

I applied both changes on top of rnull-v7.1-rc2 and `make CLIPPY=3D1` passe=
s
cleanly here (the two ref_as_ptr errors go away, no new warnings).

Best regards,
SeungJong Ha

---
I'm not a regular reviewer for this subsystem =E2=80=94 I just ran into thi=
s while
building your rnull tree with clippy. Let me know if drive-by notes like th=
is
aren't the right fit here.

