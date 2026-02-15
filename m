Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FC10EF586C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 09:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA446B0005; Sun, 15 Feb 2026 04:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7F16B0088; Sun, 15 Feb 2026 04:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889966B008A; Sun, 15 Feb 2026 04:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77D976B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 04:25:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 216A28CA60
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 09:25:53 +0000 (UTC)
X-FDA: 84446158986.19.5E08FA0
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 19683180006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 09:25:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ii712g/K";
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771147551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cp2egGe7A+xniAsFzI055+qZuvwbdrgsdOk3oYEIpjI=;
	b=GVyoUc2Utg2/8fY0tX2guE+zBnytFgFlHwkcbxlNiwEdc71J7fEoxu5Kq/iqUFXHDb1KP2
	sapnt5KbV/SHjCocpcw3vzArUnYlIwpgFjKWR0VesguF1CFmqx2n/FdYYuJevFSw50CjPA
	/LQjoYwJwXmipJSIprGa6g7B4YoOb3o=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ii712g/K";
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771147551; a=rsa-sha256;
	cv=pass;
	b=oyPef0Mx8tDad/GF0TqVeSdw9h9LwYWji/AeHJK2U2EKyePQsZHXQnVPEdkGAxzPmzOjiT
	w2X/dSkPMH/AElCyhJAau9gphe4ETHGtEaD0NjB5kYFwS12UIwqDHNDkIfeyuysnBXfNAK
	hgzl9wJkZyIvur0AEOQwYv8NIjFfMaA=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65a2fea1a1eso6332791a12.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 01:25:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771147549; cv=none;
        d=google.com; s=arc-20240605;
        b=f9RhuT723dM8/5i+d8eSDdPi812XknFJQZRXuTSTzS497/a4n5JJZopIIWYSSvFFh7
         8wm4Tx35CwUQUDIEQ187wdDXVeAac4BNCuQEKu243orYBq5WJBUgmJ4wbYRQw463NHET
         zs4Xc+QiNwIQNif1ZEcVNpaV77R9fzWB5Jkvk4Ryb1L+KWbC74R8Kl6C2mlliMwWyfyl
         jzaIuacYOZxisZlHO6WLK9U0Bnr4TCyFTX1XXLHGfQZjx/TcoHTFTtHLN+osYDu4RrhM
         BDAdhNGh2Cq9NPOW5Jul9jlvKdD4yVQ83M4A2hvQmdTVIi2FoZHG25upImNvX2+/Ea6a
         h4Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Cp2egGe7A+xniAsFzI055+qZuvwbdrgsdOk3oYEIpjI=;
        fh=rO599tKgkbJIonRmdFjMLwPNLkEbgXs4bjOUpZH/gco=;
        b=CwRXBDb+0zQBE4itX+JWeuyFdCac4uQwmjbilLwRbSyPSPH7hwQloL93ygTinF+dsQ
         HGCnxkkUlmRDBEt6eW53U5wGhgnPmb08gvHb/uuoveDV8pK9wpcy2RyY0lorMr9tEETo
         r6Iy0n0/BTNoNv4rXQwajBiCxXI8E767+ZLGRrnB+LvrN/4rknUpA31oycyQ+Vecxhwi
         xjQeZtITVyGkCqaKyPN9UiN7sp94Ebqx+88Gff5TdFlgi6HM3rET1fo7LsVeEFa+OLTV
         RpK0XRjdbsvpkijIx5yfoG0xFd1snDC+z+l+FnQWTEu8A8Mc0RmUu7bPz2p554BJRx7g
         UELQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771147549; x=1771752349; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cp2egGe7A+xniAsFzI055+qZuvwbdrgsdOk3oYEIpjI=;
        b=ii712g/KdwQRLq2BNGpI5xVoQyvOIrNXlxMek2412fsQATJKd71wjbr+rCep+ECc6r
         j+H2KQ4kykgjRcv/SA7bjMNmmBMMOT+fDUwQWRK2BaUqyTY1pbksIkFGYtCTrsNdUUfx
         ifQEyoHFwSugGL4S7JNhXCIF02b+upQXz5JI+9E/zHml49Jw7F0Dtx+ne1TOoYqEnknU
         RiZQcvhHNmfXuABsCo/hOgGiIqZAIIsFIl6UfHHQsQWJA/Trib+U32BAUSVAuVcPnv8c
         D0NlL+8XeZRV+0Gg/X2O2CEC7cQ6b/Hr9RdMCpUggbdZku+VYUh5i/slccd5mqCq8RJN
         Iv7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771147549; x=1771752349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Cp2egGe7A+xniAsFzI055+qZuvwbdrgsdOk3oYEIpjI=;
        b=vRaYvdTMhIyHbsFTOPwQpqnKk0tl9VVWnGDu3/FBy32o/6qGwPAB7v8phOdDkL1GCJ
         iS61xbw1rV7dPtQPIT5UkU3Q80aTNQuAQh5hEU7s1LRBtEeYEfLiZP+PqO7+XCQCHbgm
         aeat12eQX1SwOdzP7xgtaApBRF8OQ8iur6T6khVyLc0yvURMrEgEoH338894D+VuSryC
         3tBZ9csBTS3TIj+jafs5CHhc3GqHvdlq4LUw0p2vfaykXvqNHa500Bh0o72h9rfVMbsl
         EWQ/vYge6b4INpNMuhkPg3roXULLI3RSCdsDz2Yo+KE90WL8Duek4+sWgxtoJZwux0Ly
         dQpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/ezUUJOo936g9rwJZQfGXwtYKwT+shRh2Bty5ageIG2V6sMVSLxfrbIRSIFjSpiJq5G2z5ZOdQg==@kvack.org
X-Gm-Message-State: AOJu0YwtRaxyToJ5e40HJxTbj6U1CvJ4h++huEpzcIOdJCeiqqOcGKzv
	6MoHznUzq03rxv8xeMDiMpjFTW1fWtmA8RGRyXxBier43B3fgX7i812pROd3qhRzE2sF1XEkUmt
	HlvPbpo39pfzeVyL700z5Oz49tDhSRZg=
X-Gm-Gg: AZuq6aJEGK6HALOFP0hANnmXwLEv4RM+mrrvlrLoDuhsXmyNDApqBBsE/JLVJtgwAhE
	boN4frpzdjdBZlI5ew/Hi9L0qKWB7LRqDA0BqudWmCxiAdzIKHO/gKJOrLiMEMFqRNwxZp44Xiz
	hobHRKFKqGQTBeOFeo9Mn50hJ7NaeYI5GXw6FEoctFgx/ntja5pDRggE/nzenq4akpbVZKrHupU
	53JoLRWG5kkcxgpzzaBYTIf2xmlw5+ryKmUhhzv3tSh5zCbUz/ZjpnhLdawCL5rtq3p84HdcpJA
	+4jwt3dX+p5W0XGMD2pEQcSx+FchlDrzHsG28NJn
X-Received: by 2002:a17:907:9701:b0:b88:504a:f386 with SMTP id
 a640c23a62f3a-b8fc067a9aemr286740766b.21.1771147549096; Sun, 15 Feb 2026
 01:25:49 -0800 (PST)
MIME-Version: 1.0
References: <bug-221055-27@https.bugzilla.kernel.org/> <20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org>
 <aYt4RwxqH1W_zHez@KASONG-MC4> <CAMgjq7By=prRMh2T=i-T2cV3fZX+oE+YM0H4zHMXwSscnhbZmg@mail.gmail.com>
 <f743bc48-b576-471a-b679-28a792822cd7@gmx.de> <8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de>
In-Reply-To: <8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Feb 2026 17:25:11 +0800
X-Gm-Features: AaiRm52t5gquqt84X14WY-wF0yKI0XXs6jWRQ7jmM7SjrRn7-M-rG_mwyISNzuM
Message-ID: <CAMgjq7BMLQhq52bet=+JOcmd+MRV_+dPtjuwjziLJkMsqYjf4A@mail.gmail.com>
Subject: Re: [Bug 221055] New: Hibernate image write 10x slower since commit
 0ff67f990bd4 ("mm, swap: remove swap slot cache")
To: Carsten Grohmann <carstengrohmann@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, bugzilla-daemon@kernel.org, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosryahmed@google.com>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 19683180006
X-Stat-Signature: qhm83cmgja69yrd417m7fqxhqzagsens
X-Rspam-User: 
X-HE-Tag: 1771147550-585078
X-HE-Meta: U2FsdGVkX1+LXtXa20FDXULuXc/THlRUnM5pyIMqCfP0KE1E/ck8mSd2PvoX2fevgvXia2Amq1hDjlrjqyAuXVfkq2W9oIG/1tcFoF6Iaf+IafCyBi7uiLUufGJQ2vjLhAg10QRZR5d+KAHNGlKhrAfzk4isctBofSrbBe+Laj9HPQdHFQnYPoaHlGTTePk4mbfdFxGUhFg99m9Nx40JPZY7/yuBS/GJLiAr/YA7VU3X+uX0woa4xZMUUQSEZWS8/L9s0gx2HQtqohHROuPAPswmYp650VqYF4eLHlwpxNwFTlLYjiByLFg+HaOH+OfYewqlRM9I2J0xImfXkMxcq7wQ7jxxotGaNUOWvxD3nnp60xY8NuHwS59ZnsKgtxBfxXQIu01mPfpo4b1R7IMAiB425MzAdkt9T9RUd/DtGs21F3sUeu9/uaH2ivJu7Uo7yJTOJ1AuAny7lRItNAi2cdSNIze+we4lYYQdoKyqFFhYqeYskt12dnVn4UuHyj6HOS+W3g9/h6VQobmnESZ9E4Xsb3s8GNMwXAwcZNzzieHzgRVi3MkC6NtIdou6v6pqmfZl15FoPX+Pq4ADcQfhv85AtJ3UJGzFhVJz5HIELPMgxPRyCiY/7VwAGvgPGIR7Vxp0Q7ajC409dXJwvDQApIYKoIjuW+dBtCmags++AH5muiWlH+8mh00QzieZvt441ivW5fVgZu9DYi1zri0dxtR1y4B+/7bFKGWfcW+tdHjda4Y3QPvskkT9mFjMUCPph1hX9Yw1t3v/A+LLa7MJYRDloWlJQ4t9sp+sBTF9n1/LtsDJqL8+1flfpHJY+PaL9TrDSKKm9TZ/Ndv96oV8VlAp/ZxdOIh4ql91HDzWEWpkpsf1rAT6ytqfJAOPi235Sh9Z4wQX+uWNaym+OYYhuIEqJ/0MeGYmehQbvuZsOhOyS8Fzq3fcjHxR41kCa1ygmtPFd+vaDVOfYvYfUAc
 tQwy9lPJ
 8Q0RReTWITQ/FT6KMbPVBodtZha+6TOeDraiss3QP8EsQP0XYQKPycR2Dz2otcI45wAT9tWMj/bcnPFoen7cGNaz5G91nB/LBDNyW+PJq0khB7x/SQ2VBJIrHFgk98PyzeggYZzhw2zUTNNJCx86ToTjLoGiwP5q6phb0l/4ZJDLCjbKgypUGeEIeHfaxF21rRx+UVekhxkYjeVIAKg72pQFtKDGcJMuatpePKN8NSetkgLnAx2gln7TeQh8hp7gd0XIW+cN6WS3fHxN3H7w8w0BTM/IKfJ2M7rTQZYI5Ri0KWnORsn38nGbyPfA6ICnzKbbdxBiYtdQWtJRU+PToEdH8/+p/GMxWjmC/oe71ppGH0DZ0fg54tLNMvaL6zuuQhWanh2XMIBPIbVigXluV13iZVvfOBZqrAyYHZTn5Uw4bYfOSyeOCH9FdOKAHGcniurCH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 4:56=E2=80=AFPM Carsten Grohmann <carstengrohmann@g=
mx.de> wrote:
>
> 12.02.2026 21:37:04 Carsten Grohmann <carstengrohmann@gmx.de>:
>
> > 12.02.2026 20:01:48 Kairui Song <ryncsn@gmail.com>:
> >
> >> And can anyone help verify this fix? I'll also try some other SSD
> >> later
> >> maybe that's only reproducible with SSD that have very poor 4K
> >> performance.
> > I'll try out your patch over the weekend.
>
> I tested your patch with the current HEAD from git.kernel.org. The first
> run is with your patch, the second without:
>
> Date:     2026-02-15 08:29:33
> Commit:   770aaedb461a (Merge tag 'bootconfig-v7.0' of
> git://git.kernel.or)
> Kernel:   6.19.0-20260214-153617-09922-g770aaedb461a-dirty
> Duration: 35 Sekunden
> Result:   good
> ----------------------------------------
> Date:     2026-02-15 09:01:25
> Commit:   770aaedb461a (Merge tag 'bootconfig-v7.0' of
> git://git.kernel.or)
> Kernel:   6.19.0-20260215-083120-09922-g770aaedb461a
> Duration: 324 Sekunden
> Result:   bad
>
> With your patch, hibernation is fast again. It solves the problem I
> reported.
>
> Thank you very much for taking care of my annoying problem.

Thank you very much for the testing! I'll post the fix with your tested-by.

