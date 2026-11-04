Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 685C160A261E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 21:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=YlAYStas
Received: by kanga.kvack.org (Postfix)
	id 2A18D6B05B2; Wed,  4 Nov 2026 16:53:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 252806B05B3; Wed,  4 Nov 2026 16:53:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168376B05B4; Wed,  4 Nov 2026 16:53:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA4FD6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 16:53:25 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A143A84DB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:53:25 +0000 (UTC)
X-FDA: 85398788370.03.D25B801
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 66B90A0002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:53:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YlAYStas;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793829203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOYXXvAeGQUSKg94QWzYjLTLmtv76jOGX9YU9MzItx4=;
	b=bFWHTVaIU/51aYGM/ocFYYNZiMQABZg8m05AAfQghzwWWIx+EE6+gV6llsxXhkK3D03lfT
	x74e+qwfclsxH4bFgVD/x7OGqhoaDK3TasFMzGfK3+QqNjVG5lqIh6J+pLqwUPmhDm7wp4
	ZVqKk+b0o7rSUdk2QrReMKnLtfdwH74=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793829203;
	b=VJyLEeTCiWFdzrZhMu/TgmwjqvRVU2h43DQ5uhaKhYnkxbwleDDnobp3y4oU7q0nb4bMIm
	MserrkHWk3atUsK3NqIrEjny7fNuINuji3WGN92T603wbHGv57JxkgzJZ3L5AtlX5f+vjI
	HnIIOJXYmrTKKgEC4SroFGm9+B32gX4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YlAYStas;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso1763490a12.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 13:53:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793829202; cv=none;
        d=google.com; s=arc-20260327;
        b=ORsl/ejaGRxfeoZqvQdeG6LzC9BqqSUj9xql0TJkUIzEtR6EV5PF+Sw3Y+ubiQlwE+
         wGj2kvn7O/edBlFKev3iETeVEImUP8DRQFw2z+UzJXKxMFxX/W7IgIwMO5nPomIcAGDF
         9bZgLC7jHmdFu8h8TfZvH3s/YMJw5v9+vWDY6Lj59Zej+Bgt7nQ+tfyS7W0z7b6Qghfj
         volFlQBVESYQTOqiYFjMvtSvafMiIcVs/l4WP2gVB/NlRkFlbY37keEC8pDm6xzgx4gp
         MiKz9Y7TwCz1MjomUVSJiedcuJIFR4z6Uw6mhcVJWCc94P4YbDlPWDh2x1lnYXSasqxJ
         zcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AOYXXvAeGQUSKg94QWzYjLTLmtv76jOGX9YU9MzItx4=;
        fh=wr+K3HRLFL4URVQkqhx169+QveVqH/7QPeDUBAqWQf8=;
        b=i+gbvIROulkFg1K1CQDlz6ouCHS6B/lu4eZ0GmQr5TBgFPobp3RVk/W4Gt/WuPvh/6
         iGbGh109EBL5DfJen/o3tnjMXAtIi62vcB7C3GnzB8ASA/LyJIax4+wM8BQsyZCDg4j8
         cGwejaw8SQa6G7NuZQainbD3to5Y0EoYuMPhJngZsmyGhNZ+noMbHjfP+ys5+B4fx4WA
         L2/3eeRhsofT52qpuilmI2xL/DL6TXaluRc+3CwlPYeLGNBHguJJNMh59MbGz27DcciH
         BeRp4lNXigU2hYeWtaWlv3OJs2n4KSjNQBF3lHjfwuWeCtC2NzFxlDYgQphqp1ft4X1X
         UNSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793829202; x=1794434002; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AOYXXvAeGQUSKg94QWzYjLTLmtv76jOGX9YU9MzItx4=;
        b=YlAYStasygWNvfEiGohDbdwofuUd5yNSGu/9ZD/fG5v1waBoEPR+lQJ+T6nReU1c8z
         YXRjHryTwyJhZishL1PxSVKR/M99bL5nHSeO8ybccsPMM61GAlVsg26DExC2ie8mYN53
         mZvvKV5Jy2YiZm+B+VNfDBkz394urvNUadMhZcs8GR3upBYn/5PKfk3v8bEx3PQNjsVd
         vImkbRGqTpv5gVsveaZjmqwFRdp42GktZ/sSKqv9m3bcfoSriPiFwdadOi6bODECOPmn
         wrwBYBTeodeu62rt7JSQqO+PhfNVyccWSBtQkKdRpykKva66b/cdFnXypfrR5JHdJZzX
         bXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793829202; x=1794434002;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AOYXXvAeGQUSKg94QWzYjLTLmtv76jOGX9YU9MzItx4=;
        b=hbRFETjKWs0K2O34mnIltEvWLvyzml8h+spfiXjWJuJ1aqNsayIDhi/ryAfMcdtVM4
         GlbSpEjKjC3WvX6/e8cCNgBsoWgNV5MWCbPa412OfQLNwfm6m52jyysSIKJ8emLWbWYv
         gLa451j+9qybXY7LfnIr6Py6XmsZAaZqensWKau01xkb2OlsiZBYKTwzTQQv2SG3c0u5
         UXOZg1Xml2r6/9jBvldCuhXaJKBfHisw5RdKu8ZeRzEu6NIGJhTP5t0ncqf9waid+dDh
         DuzDknhJN/otytFw2+oC5oEyoboFmMMCaz3sLMZ12svXUtKjv0TqyvP5a9Zcec0ShcEu
         Pcsg==
X-Forwarded-Encrypted: i=1; AKwUvBxpp65zRWjCcvQtXPvzNpSAQcrq17Tr6/+8HR9QNqnuOnsknWwx1KPKbgMMjkIbXNYl+rChEYxy6g==@kvack.org
X-Gm-Message-State: APuU4Z/cRsJTpwMif+ygrlRvN2qZoW5Zhelm+XM8cmIgxPr8JVup8EBg
	jurn8qkLFNQ60SuDw+UHHM3uk2jSfpy/4khRBY8ikXkYvQ8HJviEYAL9GakwbCvPFo7G+MXvndI
	fMbkGcLfBkasdPRaeL2JGuG+095PwdaUTaNbPM7aSCw==
X-Gm-Gg: AYBFou0YJ1BQxvkKWWXVSCem60w50dnEmndksTtpjPFC5S/78CRJvJhVguOkl/6oQSR
	0unF8ljIEYF9gbRRxEqgmRj1KK/G+6FA7M7LMvhYwFbXkYjEyMJK3izAuXtjge/pIgPED+vq46s
	yL57x52hCojHV5nI7PBmsFE9mWktYN0aFMsYoDclDBTXI5RUL5IjwCv8Dqif/TbhDDe7tuny5O1
	E95WbRkvVNZx0mfjX02a3QI1VFY1vpkmCKfsoP/nxtGzB615U5WJT1cwMV0vuqIJ3Flp+4q1TXz
	g2tqQhhbJO0W2PKyGAOVChig7Q0/sO34UV/X81QYaammrpQz8YT4r3slpANdgjFzMIiOYh6qt1L
	Pdhx9b9u5LFDglZylLAWxs57Ce1fgz91dvJy9UAoaMEZk32xlvtfVjIr9hxAmAdsvuyvs
X-Received: by 2002:a05:6402:324c:b0:6b1:c7d9:b631 with SMTP id
 4fb4d7f45d1cf-6b4d4877be2mr10211433a12.23.1793829201753; Wed, 04 Nov 2026
 13:53:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104162352.140836-3-blum@kernel.org> <179382570401.2089669.6201187990672133004.b4-review@b4>
 <34a03ed8-5b75-49b5-bfd5-e5cdf48dbfd4@app.fastmail.com>
In-Reply-To: <34a03ed8-5b75-49b5-bfd5-e5cdf48dbfd4@app.fastmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 4 Nov 2026 16:52:44 -0500
X-Gm-Features: AclHuK-s-sl_kRxXOrDtbT9-CufQHmeS1snyHVWmWxn4YyNWTQWbPewzEi16i1s
Message-ID: <CA+CK2bD4s_qn7Scat_B9vya+BoqkJdNTy=iYY4JoHNAzY9YaoA@mail.gmail.com>
Subject: Re: [PATCH v2] kho: Remove redundant 0x prefixes
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thorsten Blum <blum@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Changyuan Lyu <changyuanl@google.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ftkshg8ngg1bpgxiwt81mpbteipbyjwo
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66B90A0002
X-HE-Tag: 1793829203-23453
X-HE-Meta: U2FsdGVkX1/9oZf4VsPNicxWTbL9+qSvEYPOoNjl9FEk1xokox/GkHOiRkxYjgf12rXUSMKvzKCgKfVTd4pqNR/K9YhKZ5ryCSNHFHlJtyLwTW5WhSdgu7x5wUTRbJ8jKzCV9/CU0rWh96pOdggd8WyzOomFFtvJ4ZF6xCLADMfAeHED+by0evOKyRyB5VYldtt6ReqyR2WkEi/4iI7OxbMXI4qAMOHfRWGuZCtCIB5FGW7pGFhGwsTzTr2wbFequci6/9I7kO+bfwkXZvBeilmtQGVlRQB0bh5oCOaL2NFJDs/h/NO+Vw7wJk+TCOHKnWoSOh3gvqH+FkR0WZKzRhsEdeJReXIOfgDDzEACOJeBCuUDdm287ibiq39la+PFC+sdCgkl7LQJfDd+w+BiEUQ0F8W208oD6siYnvJFULgB62zHMZEvlhYy7OBeJeXGrEKRfUhXs29tvlyQPeYUEyhMWJkcIWkf8C8/hME41jb+uWEX8Sigf4/63Gtp2oozVqT2sZ7sFHHjB8qmxeQyAl+G4Dovs03aKqy89HsSfzoUaA6yBRlZGD+H5cEr+nBQZZ931pKGCOBsaySzwwgzQQ/+jZp5lmJEAQ45LlzUZ/JH61J/ls7CZbidimUytdYWB8iOUzbygTQ2UBWKF5nRRXSuRcMVI8EdxIHIyWWSLZN0t821Nt7rd+GtNXaRd6EzlX5CprmKYeE6kmb+8UkTUvnwlkavqXYkFH6//s2cp80AkzfHpvq8SF4kGdGZL+HR/3qF9smpDLllFYf9ucmaEhguUdMa6upkbL/X/R2by0KoceCaWmiT/WD8DB3AhNq8MlIMe5V0LAtTqH/887yM28fr/9LBBLMcxftgNyiQ2k0KVt4VgObShwtDdns02ad+CaR7nqZgESPM3z1l5OAFaR36l+Z+4aQMvtHjE8jT8Cmo1yOOTNpy/wVFAo51AeJ58XTSpLfULOg7sDPWoE7
 LFQS8uZ0
 3rOp0YM6YD6z1nFO85sgzHlsME0z0y+eQRH2do1FAryQjZm7wBojp3i+xHQtf0vsvvYZdlN9WrqhlSyfa5jQs6TT678issi/bN6MvtT59pJtG+86IOD6kuK/9UqzKx4NsXzz72m9Qba43FWLmIUOaDauBzlyvCucrk19eUm5F+lnBAYNAMVfPwL0yQN8h6GBPRE2wfdlEbbE/f6oAJ9UvNk8rhueYpq16hHiP5UnNTvCkysTEp7GTon4KSb9zNacv7mFU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 4:00=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Nov 4, 2026, at 21:55, Pasha Tatashin wrote:
> >> The %pa format specifier already includes the 0x prefix. Remove the
> >> redundant prefixes to avoid printing 0x0x.
> >>
> >> Use phys_addr_t for size to match the expected type.
> >>
> >> Fixes: c609c144b0e8 ("kexec: add KHO parsing support")
> >> Signed-off-by: Thorsten Blum <blum@kernel.org>
> >>
> >> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/ke=
xec_handover.c
> >> index 6f1f55fe3181..6a7600a0a7d5 100644
> >> --- a/kernel/liveupdate/kexec_handover.c
> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> @@ -2010,16 +2010,16 @@ void __init kho_populate(phys_addr_t fdt_phys,=
 u64 fdt_len,
> >>       */
> >>      for (int i =3D 0; i < bootmem_cnt; i++) {
> >>              struct kho_bootmem *area =3D &bootmem[i];
> >> -            u64 size =3D area->size;
> >> +            phys_addr_t size =3D area->size;
> >
> > I am not sure; having a variable size of type phys_addr_t looks strange
> > to me. Furthermore, KHO only works on 64-bit platforms because of how
> > our radix tree is designed, and we do not plan to add support for 32-bi=
t
> > systems.
> >
> > I would keep u64, or if using %pa for u64 is still an eyesore, use
> > 0x%llx for the size field.
>
> area->size is also a phys_addr_t, so using a local variable of the
> same type makes sense for consistency.

True, that makes sense.

Thanks,
Pasha

>
>       Arnd

