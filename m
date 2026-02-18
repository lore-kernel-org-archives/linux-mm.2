Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 081D1E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D836B008A; Wed, 18 Feb 2026 06:57:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA7D6B0092; Wed, 18 Feb 2026 06:57:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6CD6B0093; Wed, 18 Feb 2026 06:57:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C89F56B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:57:14 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54C34140116
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:57:14 +0000 (UTC)
X-FDA: 84457426788.14.C32BE59
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 457BFA000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:57:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EFbhtgLv;
	spf=pass (imf25.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771415832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtcVewlOpPdOn/A/YdF2EeUU8KcsXzWyfjr5ho6fnU4=;
	b=3/DMFaHWXPJdtzAF275vkJri5PpcymP+fpReOZmR8WrMYaLhlTrcqbE3646J3rRycAdRuo
	YsW5DfbzRD/5MxJcmifgDSL++H4aAXxDjWUDEwmNKh/7zgqYhBUlELwRjoDYkU8b46FlDC
	bj1G0gRxRebx3zYFdsEYpmKquy440n0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EFbhtgLv;
	spf=pass (imf25.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771415832; a=rsa-sha256;
	cv=pass;
	b=p5ye5FIDrpgZoKaCUrAg/ajG5XIY9Mr3yb8yiLYVwvwWyPcI8G2QC60bR5ihKnzcTm3N5d
	eHNvaAi6eJf72xJqcOEhtI0hbz2UH4z3dxVUiiyqK5N+r+GdveT6/9bEstZ6KN7H0rUCdJ
	SKwVkNMrIEmwFeJf3vFTnDkcckV32EA=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2b86a9613d8so509792eec.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:57:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771415831; cv=none;
        d=google.com; s=arc-20240605;
        b=EiHMWMjCtNNqiGlV1SeSrmSw0ce6IhnavPm8I1Lamm9hzY8EMSC0qj8Tdl7j56eCwR
         A9amKTg+Rma3DfSm2BPzxcp/R74dhGXxtqwRjhmSxKdR3yKzCuhAa29YLuuV/gFjUyS5
         GaPMNpC7xlYHG9jz58W1IflQ01SLiI0kQni3ZJcAvz61bFORt7wCc+CHwPlmSfOatn1w
         48KL8pLwtMWPfZho2ZSogx7tthPSO48bJnSirYmOSUYWr6hj4om8bYH3nKasGAjXw7dy
         7KHNItoFu/xAciPNPfo6q5uhvoDETieXE3IBAIdy2MG3wK2H9RbpzptYI5RzWmpf9siB
         tjRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KtcVewlOpPdOn/A/YdF2EeUU8KcsXzWyfjr5ho6fnU4=;
        fh=Cl4AxuRT5HCvDL3RBmoB9ccUTZYJBagEi1MbU3ngtgk=;
        b=f5sfPItc1hq6t1Ss5/pooGHsrYtmAcDqEXHd1O6XcbS18nLWGIc3I5Po+fNXMQL8Qs
         xr4Yt+M1ztsOO0UcsTM+pQ+Umao8b5Njb+DonWDGumvSVSJ+vn74qL+D69YDlRrismHa
         ixFx5H7sGKPI64e6PxHUyxQxtuDyi24ieRho9xL9RAgUVc6WV6KwSD6QioHwkC6AK3V7
         3V/XtJih+aBro2itYPfhWoaqdUIRoSz5yxGoNFgtGCL7eEf8bgRn5kHvkFbUefm24Icp
         4tlEXtVFluxD3KZinR3N3KZQRujnhZ3X6xkIa+1aTwqaQud7pEIaS6Lf/OAGK3Q5PxsV
         1+mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771415831; x=1772020631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KtcVewlOpPdOn/A/YdF2EeUU8KcsXzWyfjr5ho6fnU4=;
        b=EFbhtgLvXfzrtDsv0GJC6qjpvvfXNZk/+XPNQaGffZP6VtTSlwENSRuVkvcL6mqfC6
         keXp5+8yicHfWHGtTljMCalGLzp+eIIayno5wpgxK+TBF3JlKg1f/BOCnW3Mwl90g2Cg
         y7vI0oySFBy+iohqKJh5HlUmtF6uOwpix4GaO2VVJWCbwlggNES9l2FuVkMPdIS7CBZx
         gWa4WX0EWa4JSD/EVZsFaQGLsL5hZHdIQ7jvm0i0twuYwlm1zPWC79m50X8TibKxhYQ7
         GXiqYoSx4bLDhSBtfDeGH1KuYk0Kjfp0ulJyy7yeIpjY4eqwCEr/Yym3xnKIfZ3zTgsU
         NpCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415831; x=1772020631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KtcVewlOpPdOn/A/YdF2EeUU8KcsXzWyfjr5ho6fnU4=;
        b=ASyOWekEmweTl+rChC5ltEWgbZsZ6srtyja1LqxQsoQ7g7rhFJRUsA3B0SRmQvdM9n
         V1cNHipeMIDg9FE6TC5TlW/kbe6qPZXWYFBRWIRXUBaTLvWN/b4vj1oYvgu5iRX+CjTq
         p3j3+WWckpi9CNZ/HPS8zHBqytNy4CqhvGjVmg9bY1CodUenWjY12NKh5KpSHxM3VUOS
         deAuCXwtf8ZhPi2jMkuzMwVgnz6Mv5jR2NDmn0QXfm+F8HLXDXq6yumJbgqOenNQIo60
         DLCGEWeHEmxZvkntYrSJGGHLCUsuyy68/fKaMzgLz2C4uO2sejIJNlk/8ExHEmKNvo1z
         RV2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXWQsjoMMBYiFqnKRb5VAbOOTq2ajw5c5tMyN+0gz0XAFZcJvdIClKfZi/IrswNb7KhjgCcvygR8A==@kvack.org
X-Gm-Message-State: AOJu0Yw4/BhaMjFNZq+j2DxC+NQLgx5zDWtTz5AO8RZf/3hGeYgXx400
	leqWLUFaKowlTrQjx6PthuxxOh0j21ncf8RQhkgfTYfUYxA7NrmtktXeK6AbpIc53HnywJI1gxL
	aDA2lBHLB+G/jDjCUFz/CHGXw8KfBsW0=
X-Gm-Gg: AZuq6aJwk/Z77BsD+cq5Af8dpKR+pUTPkb0GTCyVO89SVvO2hUIqUVI5QuG3JUJO3gW
	ywmUS3+p83ShPloFB3iLkJK2+1Orw7hR2XMVT/8Xin46FRSmkwaSNM+fZLpGp9l7jNRM7mF0OHD
	j83f93goXHkVNCiglpDl/uxp4SdMbhjfADJ5mogr02ueH9IE8GfA8COKjqSvFCChHgiUPJ/JA0l
	VxIRdHyWYqqm+TpkUik6zGlwe6U3R4sEjRJur05Mm1jGqxn33gkI9EV19Drwb7/U1ljS/iKiiYf
	L1eTdChe/0Pg3fPz4CsuaChoUvkVNSG+o/17B9vsKalTWcraxMiD0cyKLbHj+QDNSS4NyWu2TRk
	i1bcOfF9WoVTb9fIv3bWEQevyxKnG6JOgJrk=
X-Received: by 2002:a05:7300:2327:b0:2b8:2082:5bc5 with SMTP id
 5a478bee46e88-2baba0da25fmr4290106eec.5.1771415830789; Wed, 18 Feb 2026
 03:57:10 -0800 (PST)
MIME-Version: 1.0
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
In-Reply-To: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 18 Feb 2026 12:56:58 +0100
X-Gm-Features: AaiRm50hToXgBrb4YdoI6g2TqLtBaS1_xidHsii392EXlW0MJCp-m0oWjTwIcQ4
Message-ID: <CANiq72=5r2miRm6GWszb2gDNi4k5-RZUzvdOdFQ3yyndvmHbAA@mail.gmail.com>
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
To: Andreas Hindborg <a.hindborg@kernel.org>, Benno Lossin <lossin@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5tjxebs9jczott99fwrwa5htruwn46bh
X-Rspam-User: 
X-Rspamd-Queue-Id: 457BFA000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771415832-457005
X-HE-Meta: U2FsdGVkX180jmOP/oPtu/WXwgOlkQyn8w5rzdQlUT9UjwHe7mO/aJoJcIy6Y9Xte8O52nn8y3vUsd/4Mg2hFxsiADKkN7mab8uPwM1OlGLOznzzPSgsvR7KnyaDjnWFuUZ54f9lBAIsca2KEJ1HTIk46X8qREHqJtSlDIvP7/k4vqh0MA2v77gOK2hkcEe9AGKdWcdZyPo5eWROspA5nyNzFWTu0cnwTc62e3lTcnpdc/0qpIvGNFWxAklXAckDy+l6786YWrjmhTjQ7A9SwURTknChgDX83i5vrUtnDT4y3+6CKDhBKaEeTIbeLGZjJuoyfB/L59PVWOlsz86upeoWyGvy45YTiSCx0fmUSBdC3sJg6e9ntQstLjcavI9omD2x1dN3HPoeSHGe0q6cR2U/nk8H7OCzRLE1Mg2vikBFKT8tfM09tZIqesqGKWYzwNY8l8kDrF5ioH/K1gExC8g0y6izFVzR7AoLP5pi0i66ATi9ssvGYlAO1ror5mq12wFRhWzqmmw+361yDfMUt/q8QpST488OsOw9tAfQ8bvulYtORtxm0XruEN/ZNdxT+cdPVAePbQ/9S5SuQeiAAWGwlzdrPT7N4pfbnwivTGsEYcz5J+vw+Ujyt3FhHpkcGzxWEfgfeqbfdVNgkBZdjMKSIrPS6jj89en6NmMQvtXMUfKX4fMFRvaB+lF/3tKlEspsfuL4lT6Q788RxMajoyZ/MClnXg9MMdfjutgkMhaHui/20fGEoLX74L2RPqNLlUR3N1MraDEmSLL893sug+z0CeSM//SWyV5xUxy6ligHLLsTxGv1k/uwQPVVLpkLPwpjFePZI8+QSzCOc3qEVTamtnXibAflKWs5Bw0az0imoI9ZC9YP6hlFe+TkGvAqXroh0avmUnUkiwkhLBJFngvBGK0vL2vGzxEzswVBF57/nKvfR4nAQgDRGqAhiOj7PNaf14Mm6jbosbjyitU
 7FpyCOKF
 sPaDnJCeOYB+o3yMIju+xB8H4W+VzQNRT/iuABJ8qfLEmOQjhKBSulCBWmR2R+BdaugtMF8+JhFCwpSMRj+AMoJaFv91RKHDu4hqMM+NUeu6zEi2CfxpD8pEuELlI1cjWKi9nBsNMjlqG3AP7ujn4fl/aoZAzk7HWidn4Aw5c5eRVJxQJCHDaUQMABKWPezWtlQqtdVbcq8mABkaUlQyio5it6DnJa7qK4Fy/crG3QieTinfOhIGLNgFqY3/vQhVakuRhZ9zA3spPOqq3ywAyPLX+1sSR6NY9ws3ZIe4+57y99QCEaZZ3ZfqXF0vRZYTka0Qmuj/j7ywN66/3RGsNpnZtBDoc1M6s42sBvqStKx4EXhl5GwI04NbjCtv1FyYHn2G6Bnt/XnUUtPQPSvI8vxUPb3+rRiH2I/LE3Syac3frTV+RQugaAnToUr3ZE6ZU6V3HL3TgxSsw7AdOU4me31zA/6PaiYpZgg5C35M78KGWL70Q5t4JVYQ57v/ylhpHcFJ/pb4bW77EbGXm2e/HzscSQXWjZXTWVKFrejcePM01dkfon2da4LMZM2reU9aZM7Xaq+xk/rEGntV5sSMY711p4+rrSbKGjikO9PlLfFAvHCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 7:43=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> @@ -282,6 +318,7 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: u=
size, len: usize) -> Result
>      /// # Safety
>      ///
>      /// * Callers must ensure that `src` is valid for reading `len` byte=
s.
> +    /// * Callers must ensure that there are no concurrent writes to the=
 source memory region.
>      /// * Callers must ensure that this call does not race with a read o=
r write to the same page
>      ///   that overlaps with this write.
>      pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len: u=
size) -> Result {

Coming from:

  https://lore.kernel.org/rust-for-linux/20260215-page-additions-v1-0-48277=
90a9bc4@kernel.org/T/#md120cdea73132fc698bf69bf3d69287c2cb28449

Leaving a comment here to avoid forgetting: I think the new bullet
point here and elsewhere is not needed, i.e. the first one uses "valid
for reads" which I think is meant to already exclude data races.

> +    /// - For the duration of the call, other accesses to the areas desc=
ribed by `src` and `len`,
> +    ///   must not cause data races (defined by [`LKMM`]) against atomic=
 operations executed by this
> +    ///   function. Note that if all other accesses are atomic, then thi=
s safety requirement is
> +    ///   trivially fulfilled.

And, for this one, Benno said perhaps we should introduce a shorthand.

Cheers,
Miguel

