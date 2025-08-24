Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FD7CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 14:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0456B00CB; Sun, 24 Aug 2025 10:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89866B00CC; Sun, 24 Aug 2025 10:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A76906B00CD; Sun, 24 Aug 2025 10:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 881596B00CB
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 10:07:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5CB7813AF
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:07:34 +0000 (UTC)
X-FDA: 83811828828.24.39494A0
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1C37F100008
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:07:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BbA7zvTt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756044453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUELoFUFEP5UzgVaaNNxnVfsUEOMPizKcUEsIpXZ08U=;
	b=hKj5qsY7nCGTYKaIp0CP5DV3vv4PxeLBGBrBMtL/pCOLjVQ9RhLQYdGbGGDECp6GmFpwPR
	IJ0OaKrQTD6P8IQSgElVDXcc6DqSNGEGl4LOqLjWhEBC/c+4sIevXdwFmPUt4UH80F7y58
	WiYjzHzZ9Wr81FSBCQect4KgS2Y4+lU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BbA7zvTt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756044453; a=rsa-sha256;
	cv=none;
	b=tvJuTowwoqgKRgFDBi7FadQYYaT8CzcmalJLLVFo4tYxL1UgZE8xjMl4xD5EFPGb4Wk8sz
	nSzqk1cQmYy44k84ZOPLDrs8iQY4ForAtkNnJYA3hGjJ2I5KZgtVSZLD2NCYkhaysUR+qh
	zQ39jq8VKwQwTfJZO2eLIztShrNTHP0=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b4717593371so486888a12.3
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756044452; x=1756649252; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lUELoFUFEP5UzgVaaNNxnVfsUEOMPizKcUEsIpXZ08U=;
        b=BbA7zvTt9t3P/AHRHbKfgyfP6tiWAkyehxpKs/74K0vzCT9jGjH/S1BXy/O6nHGNcQ
         k1KfCJCY/rzFlNf/0Du+3ZMhCp9YeOUBZqtTGAObL+dDvGzmm8yTKR8PFZkpjV80RQLH
         6z50scDejJxnsguAUhjNXSDrqnVtrxgUPZQMoB/IYt1Ue+v3XBwq5NXyObprm6wydcjZ
         OsqZYLYE4Y+aQ0KmXaldaNbnX0OxjQtUyx+4V7xcc8MFR8Xl1KH0ji/YsSfts8fZf4B6
         lp7DhX6T+XZiXpGoRCGkKyjjRjZbsZEinZ1yMqT1QGgVCuDOliZeqmQVtqdmWqXwJBvF
         YI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756044452; x=1756649252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lUELoFUFEP5UzgVaaNNxnVfsUEOMPizKcUEsIpXZ08U=;
        b=izK22IhenUw6tZyT3jU6nHImBqwDUz2ONr28oSYzicXjEKanRvxru6Vs47FPJlopT9
         iMIEFxJZ4PvmCc8tuERnOZJ5mhoLBmgCq1UsKASrtgaMOUk4xw1kGh1xHiZiSQb3Ol5Z
         +Xz9hSJRg7hSV8shVXFYTyfp8m/flRwELIQJBcflnuMOZJHKnrPoM4FEhhI/dGrR92zr
         RFor0TjLYKFW3KuxfjeeaVrVBsQXhIDtgArWzp7Qf0YYqJ922A/17ka95X97gVqUPIoA
         RShEFBuDqS6+vZkeGIVOz7J5QA+VJH/ZD25YpoivIynGrLKDnvZy6ZFabbcHW2N91ZoC
         L4NQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8oRDzIhODWU/FQ0Y0CUezVf81uSbjyAVNBJLKtyJb/4NMjHHDISrsVUt5gVa4gG0SGqb0235U/A==@kvack.org
X-Gm-Message-State: AOJu0YwbiZiKeEAyD8IriJOWzgtJRRISWQze69MkuoFsvyBXYYfwTJTJ
	0xDrn6QnPm+vVIrbcDuiMsh5TZxwX02bb7Hryno0CHRVq279wX6s01KlyR6C/9oGPJa51BDDXA9
	4vpDPdKbcyG3YqXxG6TCNWn/3jw6qv/s=
X-Gm-Gg: ASbGncs0F3E8t6lHtVioUB1L8x0711FS7HioSGdS7TUojgqTNlyZlpOv/d0H2vZOtCw
	ad1JDMOFPsnsFdgPEY2rfTrdm/xNybm2Yg3fFe9diOueTsSPBf0NLup966xqcHZ6yBpQZMukA13
	ve65sKTvstXL+tXCA6x6cYXkvaa3TD/hsnQlad/hBGGi1Jiqzsid90a2+RgmfgEVp1ign9x/g0B
	bOFAC6i1OxGio5DAEg+X6B5Xkw+srGfH17YD92CKyRKWUDWyhqR2XYEHeOimTeaZZf80o/UZFSo
	ff/1B/6vSLUiGdNjAlM5ID2o6w==
X-Google-Smtp-Source: AGHT+IHBiSK3IgbOAUrwW1xdDFa5wrf0+mgCTyPnctivvoo4NRrmmQP7Wq9YYqtyz/Io34yuczVrJX8M2JoGFz6RscY=
X-Received: by 2002:a17:902:cec7:b0:246:c843:6e07 with SMTP id
 d9443c01a7336-246c843713bmr6435385ad.8.1756044451766; Sun, 24 Aug 2025
 07:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250824120656.208978-1-dakr@kernel.org> <CAH5fLgjkqcyzoZD7PP2i4g4r2uqpdbDKVW5hLfm6c9ysbxkPuw@mail.gmail.com>
 <DCAOH44U57K3.2CVDYWF8MJBWL@kernel.org> <DCAOREAIJOR9.2N5JW0SC9YT93@kernel.org>
 <DCAOZLKAFK8Y.43MJ1XPUJ1OG@kernel.org>
In-Reply-To: <DCAOZLKAFK8Y.43MJ1XPUJ1OG@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 24 Aug 2025 16:07:19 +0200
X-Gm-Features: Ac12FXwnQf3QORiB3XEfUP2FXjiaYv3vFlXfdEVSEekf6wgvktBn3kYEmZrNO9k
Message-ID: <CANiq72=Xp-u16fboZJvdRZCveRtAJLSTsiJMMDXsd2saKCU26w@mail.gmail.com>
Subject: Re: [PATCH] rust: alloc: add missing trait item MIN_ALIGN to Cmalloc
To: Danilo Krummrich <dakr@kernel.org>, David Gow <davidgow@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>, lorenzo.stoakes@oracle.com, vbabka@suse.cz, 
	Liam.Howlett@oracle.com, urezki@gmail.com, ojeda@kernel.org, 
	alex.gaynor@gmail.com, boqun.feng@gmail.com, gary@garyguo.net, 
	bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, 
	tmgross@umich.edu, rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C37F100008
X-Stat-Signature: 8md5rx13aoahxokepxitaagfyig488i8
X-Rspam-User: 
X-HE-Tag: 1756044452-426494
X-HE-Meta: U2FsdGVkX19E0JuTs1biZvrok347IBIcUI6pK2Dz0EfQYvvcj4COR3G/cPqXLQiqfBbpgHqz2lT8LhWrLo32NT5Q4sJxgJsXLZ/5moCICmR8QL5W2qOGeV/8TeOIhHEhHQ4d42tFj81SO+vKuPlofS8PO8OXcFsMSg6V0Ub5HrTXE8iZJbhe4UGDTmU4Gub1UzzQpxesdxC0qE7JxHKiFm8NsvQbuXTqRhzKM+Y1n1pDU7l4qV2Y037I1NsclIH5Oxx5tAMw0jLvn6f2wabQh0obbRBPsZBFIFRdhk9R1CcOJsvulMv8y01kszSAl2BIivOsJCEmNX2VBifiUy11WFb4q/c2HScHDy7o4z32QM6uRrCt8tVfHjVADDWNtoNgWxyyLQbdgQXoJCLwrfZJzVGfAq/P/HXyi4CfP8Xxa5GzabAZqHSQHbZ5YUqSdZQK1Te/TNtlHci0yOf0gllDtIdhCFfpLhB6z/sLzo+C5tSGqF2+z79tLyRcWKzXLifNDooaT7pBejJauQRSctbmgrZARKXrJg8ZA5TklwNBDs3x/zG6owYT1tuoBQmW+ok08WNH3p1zC4vK2e+hp34JaMfEN9f+OHvrD3ySQ4J09J+93e/6GDtFlhtkhr32JjC0mDseGt0xEdxN11HEpOsn3pPinJNXlTkeCXxfiY+8CRDr2uMdyEf4Uf/Co9bHysjQkqXeY1yBB3N+o4sSJ8XEtaah19mw0Wvw+Zq06XX0Z3RrVneaS/dzbwWbLGYd1cgwX20IBdFqB2TV0J+6pKx8tiJInLZ3aXx91UA6J520KNa+IevXJOgnEd0YuRl+JHioTcoFc+/lumwMmGsqE1jRsbin9WsHEVeelkySMcA6idsxIxDd6nOgNEG7wyfafHx/8w+tZqpGxSFldOwMz8EG9EXJWoZ/tfazF2qiMbgEGYN/IzsWZwkoJqwJG+dXrs/FjVYMrc6HdXnEBkzL35B
 ktjU8SxS
 dfD2Gss9RFfeXXPCEtlXJtutQ9zRQB6wOARVwOMzeu0srV4OHGj551JCVQ0ugMZ2eVj7w7nU5gSXl7UeMDVTMYq9AS9n775XlpsaedL0lhNMuwDTFW/F1VTW+dEHzTSH4tYl5pO7UYxd5uQjDrac4dtSC86C6E+Qg/Wynq/y0dSHAGnGBnLkfy3M1jQ+zR/fv779oJcakITlTACV7k+/Cek6WvwfmcB9/ZVR6Wl9QUBsYL1gWenMZOVqaV+TKemVO/plQic5tdL4Igh5pPV6OT3tplBjR8pvqyyZvsYM9tt1lvuV5jnxp9opsJDp/5XcMnAsmYIgojiUGwyqJppQzxi8C/xVMAO30fw1BB4hqIKh7xrDkeiNfscStBMT9YLCrlyzqOYfXuMHy9CL2qdV4/uEPcdxLUPHF3KoB2LDP9hTh7tbwogiAfKlsvO9+3Le+InJEsNBekcc/q+qklbx/upby2B3opmAzsItCC/12XiOsZg/AHn0epxFQiP6EBq2tC3cvM26SHq0kNk58jaa0WofU1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 24, 2025 at 3:29=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> Actually, I think it's better to just do it:
>
> Miguel, mind if I just apply [1] and [2]? (Just recognizing, probably thi=
s was
> your intention anyways?)

Yeah, since 1b1a946dc2b5 is in the same branch, and David already
reviewed the main patch too, I think it is easier for you than trying
to deal with all this otherwise.

(Whether applying or rebasing both are fine I would say, since
`rusttest` is not a big deal and the chances of people bisecting on
that are low.)

For the other fix I sent that you already applied through DRM, I think
we did the right thing, because it was not `alloc-next` and it was
fairly trivial, so it made sense.

Thanks!

Cheers,
Miguel

