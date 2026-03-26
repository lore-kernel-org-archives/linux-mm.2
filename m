Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7592310A88E7
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:14:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2E36B0005; Thu, 26 Mar 2026 13:13:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AB326B0088; Thu, 26 Mar 2026 13:13:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1846B008A; Thu, 26 Mar 2026 13:13:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D64C6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:13:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 00D2C5D4CD
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:13:58 +0000 (UTC)
X-FDA: 84588861798.25.03358C8
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02C4914000B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:13:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rb7VeVjF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774545237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q9olrJwKlMERMQc61vOT8vZB7QpsPZJixmRhhkJf9iI=;
	b=JJNiVFeIblAvZ0D63zUuLERcw0rnz1xJVNq6nposRFSajIoID7LJOSJ/QN8S4q9JBNwzuH
	gXWjx0kjaG0ATEoTW6dAq8+LAS6tzf5LBh0tfviC8lG4nRfsy02yJLriQ3V4OuxW/EPLpC
	UlySwM4Vzh6z5WXiskd7bwZKLp715Ug=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774545237; a=rsa-sha256;
	cv=pass;
	b=SScqPm0SeNDu+OfOqBh6dq3dB5T3pUoPDf9XmREX9VQ8vPMqYm9jargm/r+6yDJBOxo8W5
	BEMExdcWbkoy5coNeZK65A7hAoK81rhqThnUbhbPpQvs6adzXyDSBccCxh1OZIdUC2WzAP
	1zEM4pRgb+nMcvj2F1Aq/4Jaqxrkl+I=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rb7VeVjF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2c153272250so152314eec.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:13:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774545236; cv=none;
        d=google.com; s=arc-20240605;
        b=Q9Heggem92PEKqjMkJXiB4Axuk11IMXyeVFHUUMySU1ZZaRypFA3NI2aGHSCxlgl55
         IYdXmNeRTcgrVp5bwPDciosFXmyD0Ywd7n72gQy+FnBOpwe3gI/S4fUIr6iHkTIGRn8+
         xTFFIYz1u/74wxgKowuRYxbrbaTmmpg6oknYKU1LjxlzZxZezm4iaSjt+8yEfl8s/oap
         3zla/f7zXkksplSpKUR6hvmBeUkvQ2ijUSIJUhGZQotUb+A+8z3MsAVLXtA5gJVYdSYb
         YMKdBAON/aesuE7CKwF5PecvoJ6QbQTetuJIWiD82bTJDE9rNL/XW+LzLKRygAJzEDjw
         g16A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q9olrJwKlMERMQc61vOT8vZB7QpsPZJixmRhhkJf9iI=;
        fh=A+AElKoepSQ/XGnY1ItRbE7KT5mFBH55rPupOyvf2tE=;
        b=NNw8/CfgrUzF4LibNzH5V7J6zheqGoLGtyEptRvjjJ2sypsSC/MeAkWd4lBbsbh1Rv
         fmvNTpDrns7PlLYUf6H6M2dL6kI82VsBnDeJnqBd0C60cNZqVGOqnoXdGCzAJAHIbmHb
         k/iuMG3XcBHjFte3kSqyMqA2+AKcGVMrRDj0Mp7OLWB589h69RsruYDI5gTz12YXgFhw
         rFsTBc9obcfwGetUGh6Wq2bzDeW54ufCRSgg4hL8bDPsJh+51WCVmx0mLfme/m7yYFYh
         3TDwAQ3GkWw7Y1Ypl8Ld84FRZdGatNKRtW1kUxv+29RYoYNRr1NXE2aucYNfjZuEt2n+
         vA6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774545236; x=1775150036; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9olrJwKlMERMQc61vOT8vZB7QpsPZJixmRhhkJf9iI=;
        b=rb7VeVjFesxhp9uXz02xmyvbhmh3seQTed396PXj3Dp06Npe962mpmqkaa0F8Dg25+
         tdqO6lcN6/6eDG4/MZFmHoPATHqZ2TNzScodKwoBfLpGekggsYDOmv1qJImQ7UX63kL6
         2BJt3dB5w/OODF8GA8TVgtwx0dDJrCxXIHx1K/VNG4oFy/sifJFM/fHhT79+DSQtx5de
         hnMLVDqR4zY+uzPUM8s4nV1lEwehQAXcPdmk2uDRpvZe/NiyfV0CCKbu3GFhm4uztKpb
         cijUgqm2UaV+0d70uVmmF7mbsFP4+63fylAjusdRwzMJmvZO6eGdw5hFvhVpVgDQUHug
         IYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774545236; x=1775150036;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q9olrJwKlMERMQc61vOT8vZB7QpsPZJixmRhhkJf9iI=;
        b=evRSt26phFeaaQDBCmaLpCxXRdT2Ago6Lhmu3zARI/cbFkOMLAFiZTm63QKLmRXqMx
         CN1BFbDDUcgcY5cyfQM0ecs00gfDySk/ShLmnMe6blwfUq0hJhl8xSH4ckrUuMG2V7V0
         nlMrFeGn3snYR+ElRkfEP33fcm4Z3HOuJZ5LmF1pSLVLP160ydeT2X1XDn+is1QjSqI4
         zN4x824kzaSqcXX3RSSGlfLALj1goJDgEPpcR7P1bWA4YPVzvTOCTlTACWXWO9X62Atb
         LhXmvWxtVFHmPz22ZSqgf/3okc9GUgXstmhcKXMMNE9RdQxpde0Q9FZGtBMzcoLNiqCX
         3eVw==
X-Forwarded-Encrypted: i=1; AJvYcCWxYyIBmfbctVpq9pbLkf3vcbYqk2OFOyl8hwsLDIPDsxsnKhlFA9Zg4bRYiig03GVSWgy3JFhSUA==@kvack.org
X-Gm-Message-State: AOJu0YzHeU2Lra5UmMzmblHPUze43w3Kzkh2pNs227UEAIRarwvhctD1
	eTJ0kb27eKHOgg2LBOZ5m5ZqufkwrNd9gzYG9Oid12I53lS195UVukfOea/SdWXXvrmhkCtz5Al
	oV6rV4i3dG7ijav0wkk7K7RKjvQSBeHw=
X-Gm-Gg: ATEYQzy8yiFVL6dH7+v3zNEVUYoydlk+sMJkuyBwAotZsU5+mltXT3PQ5PBsoy2wBE8
	jCxMbSt7OFX1zTxn6cAUIBvSG3MLNHBSIwUtwfuOvpFcDfGJrOItauAdgT9LhiJnVyyVVJfsf98
	U5fr8BqyNd1/1C5tmdDb5p2lLLiMRLd87PF5US6ySAohDMXFGGYKYmItp0qEfLn48wbSnTP4x86
	Ewu88o4UDkwGD7/kkXcoS32tWB8ciCBslx2z7jJXvL5F3gaOu/Pctx/3phXzBQjTOZN0Mb8JPd4
	Gh8WpS0tOIHZosRB/gOA3ljPx7gfjoZzjrdHmEQ32L/nw8TE3Smz4Q4EpyElzZ8WJgJiTwyT2GP
	m3ukzReUyQKQS8j6ondCDPzE=
X-Received: by 2002:a05:7301:5f8a:b0:2be:140c:bc2b with SMTP id
 5a478bee46e88-2c15d282067mr2407895eec.2.1774545235402; Thu, 26 Mar 2026
 10:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
 <20260322192159.88138-1-ojeda@kernel.org> <20260326024226.GB2302780@ax162>
In-Reply-To: <20260326024226.GB2302780@ax162>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Thu, 26 Mar 2026 18:13:41 +0100
X-Gm-Features: AQROBzCjsVmkmyxhYBQlcnjNfjk1drusXCGXl2NpoBVYAfyx4urVLgdrjE0kdQk
Message-ID: <CANiq72kyFu4StTPbobkPBSMYxNa5T0uErkLj-6mRvwOquEsgSA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
To: Nathan Chancellor <nathan@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Alexandre Belloni <alexandre.belloni@bootlin.com>, 
	Linus Walleij <linusw@kernel.org>, Drew Fustini <fustini@kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, soc@lists.linux.dev, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, David Gow <david@davidgow.net>, 
	Russell King <linux@armlinux.org.uk>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	aliceryhl@google.com, linux-um@lists.infradead.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, a.hindborg@kernel.org, acourbot@nvidia.com, 
	akpm@linux-foundation.org, bjorn3_gh@protonmail.com, boqun.feng@gmail.com, 
	dakr@kernel.org, gary@garyguo.net, linux-mm@kvack.org, lossin@kernel.org, 
	mark.rutland@arm.com, mmaurer@google.com, nicolas.schier@linux.dev, 
	peterz@infradead.org, rust-for-linux@vger.kernel.org, tmgross@umich.edu, 
	urezki@gmail.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 02C4914000B
X-Stat-Signature: 97xzkqmbfk4pmkjos4tteybiigebp1q4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774545236-186104
X-HE-Meta: U2FsdGVkX18+sN4xAH+N6pddFCwUbnZRkYGWfaoIyv9IsZp+oWwdmmEzq+726PA2oW2e32TdBks0wF152qWQaCYvUntJP0Dpakq8OdbYuPBn4nhf/wG5kAmORJ8rmCQKtSkJofVOk4zSZdyg3+WAckJj8rccjnU23f2J2+3wwFIAWxZPfxdywMO3Ow4CRrsRzOeWppOsepmW6OBuDBdNPNhhIWHMFJkJx1Ch5G+6G5/cEWsImshMQiLXiJfQQfhxXBcdzcIMmn456S6Dw4ZGU6dpKio/Vy84T1s6kK7/53ey3miVVGxQm7T3+VXcB9yUV/mjUQ+SY7FN0992xfhGklYIwEEgSa5z7QBnDY8iZg9OQcwA7+OuhruYe8isiW/qyqmpAbvBm1Q77QRd/1W6dblB2oD/KzI6Vo6YzQdM8IzXltW6jJxprD0OYPC3JhqZQsjKTQxr+C2arKKroAlgE0P3bfpaW5tIN+gYAY0Y8j2IgJvJ2tyrN80FEfgLl54Tmw1Q7o7L7UphsQ1VQcTRpBdQwNeRhhMjC/sXzuenW0tpwaId25E2VInmvJfOuyqnl81LlBLzVVab6x30eNO9mPeZOdOuRQGtqTd6VrRYAR6oEAE/LsmB/sIiOwFiqEXCbnHbOUTBmBLj/d6PRgI4gMBOuzzXhc/FVkGG9FVE3AAwHfaqLdnB+c9HdysbTPYDyxyNriqT7TauW3o/MV8BLjqyxwHUEWhva8MpBOErk3YFenonjo4ET2q3wvrlIuoKCi+tI1t9k+humgROLPDG+alW7675YobXFeKvQ1sfIf9bsJRi1vN0CHvGYZWxtJRLY3+RSlHEWCqm5fG3fzR6UyqV3moUyOZL7XmB5Co7GuC3DJFV0+h9wx7CTAjCpBm/qP+xa/D0gNzpc1WLmrnzFu/ENDucqXhkkPYtG+qil4arFKRplqbw3uijiLE4o4Lbmwaz7ipNm9OwAh+qj5e
 WkeF/Bya
 tYxDuTjrw9g+KPYXETymoz6PMdXzObRNCchC8+0OuaTMzO3wz20H5MZUhrK9gjAGrFMZbJbu3UIJTkMPdn1gCZ5c+zIQV7SbcBArVvIrEkh/sPk2xyMB9YySD6Io4OEbvHJPsSYsNCmyWg6Gy9aV5TLriqdrSxcliPVcnIKWO0Qb+8vPC+lqoB5FSrhs8pVRY7k/IXbNscu65355U1KtbXYT8rozGPdL7XQLKL0Le4wefCmV4eCLAZ8lkN7wpLAf7aBcaQYlVsp4pNskDlPD1C213PqypGriOxCpbbj7xCjB7cosRviDYzTxIhTeGdr6mhSfzacjID5CH5G4usakYjrYGRPsXclsIML/uWpc+fJGDtOYqxtePYgO+fBWaXTaIxnzG1580eTCUIIgRIsrfIajDGzY+4bqmzM2lufYeKqcMC9A8eaPn32D6NJWjwmWbZFeAow/5aPChhrL3wsGbIcpljQTkDI/P0J7IwN8TEQ3zjnf1AfMvC1XOTHeobDB8vzJY4mA01tUMKK6oEJUoOOOXoC8/zcj4aDtBi0Abuae6/iGeomtT3mTh57Jo7Jf6KXj8o9mvGSukArUg+8z6V3E3R33CdKtjS5MJJdEEIRcUGLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 3:42=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> I do agree with some of the concerns that adding an architecure
> dimension to this is a little complicated. I would rather try to flush
> out those build problems with patches and keep it enabled for all
> architectures. At the same time though, I understand that enabling it
> for the "tier 1" architectures is a low barrier of entry for getting the
> feature upstream, validated, and distributed to the majority of people
> that would actually use and depend on it, so I ultimately leave that
> call up to you.

Thanks! I agree that it would be ideal to get it clean everywhere, but
given it is experimental and that arch maintainers should likely known
about this, I think it is best to start simple first.

In fact, let me Cc the x86 and arm64 maintainers so that they are aware.

My current thinking is that I will add:

  depends on ARM64 || X86_64

and try to land it this cycle.

My understanding is that this will be used at least by Google, mostly
for Android (and mostly arm64, but possibly x86_64 too), so I think at
least arm64 will see some actual users on an ongoing basis, i.e. apart
from the "synthetic" testing I was doing.

> No real concern on that front but .gitignore has a command to run when
> modifying it, which will require a !timeconst.bc in a
> kernel/time/.gitignore file.

Yeah, that is the exception I mentioned. Initially I thought about
putting it in a local `.gitignore`, because local is best. But another
option, with a different kind of locality, is keeping the exception
close to the rule, i.e. in the global one, which has the advantage of
showing us all the exceptions easily (and being able to write a
comment for all of them at once).

I am not sure what is best clearer, but I am happy to do either:

    diff --git a/.gitignore b/.gitignore
    index 3a7241c941f5..3044b9590f05 100644
    --- a/.gitignore
    +++ b/.gitignore
    @@ -13,6 +13,7 @@
     .*
     *.a
     *.asn1.[ch]
    +*.bc
     *.bin
     *.bz2
     *.c.[012]*.*
    @@ -184,3 +185,6 @@ sphinx_*/

     # Rust analyzer configuration
     /rust-project.json
    +
    +# bc language scripts (not LLVM bitcode)
    +!kernel/time/timeconst.bc

Thanks again!

Cheers,
Miguel

