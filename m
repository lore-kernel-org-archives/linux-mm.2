Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E605A10A62FF
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 14:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A4686B0005; Thu, 26 Mar 2026 10:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1556B6B0089; Thu, 26 Mar 2026 10:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B496B008A; Thu, 26 Mar 2026 10:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB6656B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 10:50:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95C92BDE94
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:50:16 +0000 (UTC)
X-FDA: 84588499632.02.003C7B2
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id 492211C0012
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:50:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IdiFuC0f;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774536614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgWenz2yfYiYc7q73jJe54zDtEsKEqUtLMnFcbZ2Nnw=;
	b=6QYY25fiNLfSwMs4NE5rOAidfSmVj4tQr4W8YgNFONxpkuTVpTnPIQqluOqB/ni7lJmHVn
	xODcl9qEcc4Q6hViV2Z+HeBvDmBjxS3Ff0d79XVmFaEqoErc335v2g1P4TC8i7CUO1MQ9c
	t2HSL4CdwQDvwdnzaKiik2BsxxLHiX0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774536614; a=rsa-sha256;
	cv=pass;
	b=U5yHAM3EaKSal01FAQW8ROqp6c+yVVeFZ11Jjksdh6adiJ4VlXTKBfTBoish3TCbMpMV9/
	oYgH+SMflz1PUeiIdTUOtf1LMTCvvnLJLg+ExzCFd4TD5lp1HC/e0EzFDQgjltCeUKstVB
	ALcdatPZHsnFJVG2Qqb7QR9IhFegnvg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IdiFuC0f;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-66132b22182so1418136a12.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 07:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774536613; cv=none;
        d=google.com; s=arc-20240605;
        b=YH6yKfaXao1PjEZi5AZf++02SXDTBk+umE1DVKyhB5XqjOJDfYf6jtN/+vAnIqcgnq
         k01buPQJzxOFyuVvdPDktiuyE0B/3HY6SJ350aasUPBH2Jdt04MqO6bBt8UuL9kPKU7x
         x9WY8GhrMpn3KyWmJjJrg4ngiNWCCMlP3Qmag2r9QiPzSnfG1KXEw1nui33bXFXrUUaN
         o3e8yP/zI6QfpVr5wWF8lqUVMff3v8RqFvFR04/zSdxQIfmUpOP/LDtOCC+fDlOlDphP
         4gXxPuBJZe9nOfWaHDOfs4dNTf16VPnrLhq0f1SklFL+4tB++7kvew3VfTfAn1TtB2Tw
         MI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bgWenz2yfYiYc7q73jJe54zDtEsKEqUtLMnFcbZ2Nnw=;
        fh=2LtFAi+FLyjcu5JUo9FE3x5uDHriuIXOruZSmPjSY5o=;
        b=Waa67Ux9Sy+eTMrjXsjqfoolYn4y5qdLeKf83NZlyMLwimxQtnP600qfXa7TE1GC/q
         c9OKVHORL2kLrztrrXfNw5Snuj8wCrzIb7wpqzacS9ZkUT6qHKaz5117cJVFiPXrOL3N
         Kht6w/hGVXYr+PUxabyn9P2FOBciDCSDN/uZtEonaD7qdeltbrlOvxHcC0VUDsiMjQrC
         M43DNTIWPVisPUP4Z32cvTWVWOoVYTx4DtR4aOEyIneRihJVdFIzwfyXvRt4CHgkUILA
         xcU7+gGtrE73a+ZpOEj2qQ73YoIT4hZa1VzKUJw81HLcFomWnHRJ/3+B2xCEd9JC77YK
         CdlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774536613; x=1775141413; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgWenz2yfYiYc7q73jJe54zDtEsKEqUtLMnFcbZ2Nnw=;
        b=IdiFuC0foQzzlmiGLRbuMU8QkrJkjDC2N5oYUOXxqgMfXIw7Rdqh1ux32cwmLOTXRY
         RmBCYXYgC3Ps3yXlJZ7pJowpRGLvdtSbdgyA1hPiahbBv9Z6WTu1O1A++YWvjGjhR02W
         YsZ+MSJg+gmrHkE/ugbimeLRudW9m5G9AfNl5HNkRo7DNFJT4C8rXTztGeb+VaVS8poM
         SV69hK93xGvnJa3babRwWn4CV4Uu3N0x74KbWZRXjadbu4g6BToJTQuEElJmE213p6Ff
         Bx9u51k28R7eb04GgmbQqmOQY2613FWC3GEK10OANEIDHcSwdG4orZqFh+9V/YeWwyCU
         1WyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774536613; x=1775141413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bgWenz2yfYiYc7q73jJe54zDtEsKEqUtLMnFcbZ2Nnw=;
        b=rFWjzl1l1s1GF57vzTjCqEPQhtqrIG4kBbm5XEfK1MSnwkZHu3fFQ8v6R7MwkKEF+m
         mrnVx317gN8xQaVNMkMhNQxV1JrqfkzATdMPTvkEOOU2Kt/nttA0dxDAfYcem0jEtSmW
         08vEC+/AaVmVIFu9a5BqC85ONTVQ4Uucs5K1BBUgKmoRugeZLHlXBdtWeOaNSQ2091Y2
         zSl2hxfXZiH8jtRmTO4kHHjTIXPFJDkTWdsRwVBvguP8g4pMJNriKphcdwLiU3Eg/O2Q
         iJDTDEMKxzbPJJYRUm7q5Fl7B7rosCA/N6IU7sBRUDWmZhu6tSU5rYYNMr8tXmK1015U
         G5xQ==
X-Forwarded-Encrypted: i=1; AJvYcCXPsOWqOMAq7XfIBcxEDmJH7I5cExTOkHOR09HAqVWL1WtLpgqbbzIMwTMGJ36dlDLeNDCXcaotLQ==@kvack.org
X-Gm-Message-State: AOJu0Yw0SdLq8G1h13baG3VDyqGCONJhfvyMtvd5RSf20mujS5l2vEDQ
	3WFwWUoJwxRhMjiLk0IxoO4TvSA33xIsFWFyu3AqPwzZ3372QbpUkLZtrBqVdn+/kDB9x6qYBJZ
	Dbc94nsF1XUAhkAjqC+vKvdUJkdO4uLtenFQqWmf/kw==
X-Gm-Gg: ATEYQzxZT17FLyEiSH+7i/8zNSsAS5GkA+0fVxN3XgdNS6qMz/bRXm3cEGUDDpVCVyl
	dN6cHbpVhNc7UMyAAjVVbuv1mNZA88szwosRfud7DCT+xGMNywVZoeP/I95YLfBdR1neIBggtXw
	pT9kH951+XrxxhufIGL5PvlhFchS8KucfQyAoqW4n4mufFhCg5oSzyC5wwfIldTuPR7bOsnxUrr
	xlNtNu1/+OM7E22WKEr0+b9tvi+oasqk3jPMep1K/KqvFbpGq72GQrDUmnX9X5BMbyVAqG6JUbg
	kcUOf9kTNyE0VGbSTJSu95/0wMZFlICJr0JLWQ==
X-Received: by 2002:a05:6402:3593:b0:66a:53a7:8d35 with SMTP id
 4fb4d7f45d1cf-66a826737camr5012088a12.14.1774536612600; Thu, 26 Mar 2026
 07:50:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260324212730.65290-1-oskar@gerlicz.space> <CA+CK2bCiqCg1Tt0WgP3KszrK96Qahcgfyfige4eUQOkMVyLUqg@mail.gmail.com>
 <7628da0465cd09bfc16bf9353f37045c@gerlicz.space> <acT5354RhFpOm-qU@kernel.org>
In-Reply-To: <acT5354RhFpOm-qU@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 26 Mar 2026 10:49:36 -0400
X-Gm-Features: AQROBzBj96j8ceWb0wHsLG-3jOA1awdDgI5nY0_V7wYgIpsMauqCa-vPY7MS37g
Message-ID: <CA+CK2bBvyKvv4=ptNp5iP-vo4txeuN=heA-6tNyu83nDFOPU_g@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] liveupdate: tighten handover cleanup and session lifetime
To: Mike Rapoport <rppt@kernel.org>
Cc: oskar@gerlicz.space, Baoquan He <bhe@redhat.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 6hfdkbc5hck56p9s169ndhkrwyynpusd
X-Rspamd-Queue-Id: 492211C0012
X-Rspam-User: 
X-HE-Tag: 1774536614-870645
X-HE-Meta: U2FsdGVkX1/41UlNfv4jqbFoSRmBX2m2MoR8ZpfRGp4/j58hvErFEXHrWHa3lMKS8YVfQGBZe1YpIw2A3Z0QciJzkOh3S0Pg0VrCsU11D8IW/NJr+fAEJWI6xRdjt3ZAIJws/IHg4Jyi5de+vlBOQM7Sm8gs2jQjx9Zcmq3pkBm2e4+ycJnZtsSf1haT2OiNtUwJClsQ1qUfO22Ig/KIj1II7uf/SYlbodnfah9OFoH2Ytv4UxdIFcEeWxxpUer7wDk7dvhuJFTzSHrJQDwL7eZzToBIps/GbY9Hi/1m4MeykI6U3aHm/gVSbXL4RvxFQ6clflr+G9CB2tG7nPImKFBRzZMLn/mZTrhUOkeW+JMGqvfBhOB3LIqmyziHEAzItyIONwr1gXE6euzp2aTOlNW7lH5c4rLs3pL++5ZrMCHD042jayWYnUZHLZg1YNpnS/2nSXYDxi4qtTcZTKg1LQSH9khUW1PZn5Gf53m4xtjSLyW92ygQZZPWFFHehFacgw1L4aHHmmi934adGelgGSSSokq7KdKFYGIzN594xRr4+9vn+Yni60/wb1V99iXxFfg+ZPKc5reka+YUtrEc+3nzhJKS+wjwXcUHtoIJ8YzF1gh1KS0E3NL0FmYIVqemymZdipBGjxuZ4jjCPYyp0gF4GlQO60ar4H1wDWH5+Dltl0YEccZPO6BYRX12tx86WzcV3xLRYlJzs4HGJn8R+3kBMz/v27FwA1V8jZ1FWLqUN4ObrRAIb5bmIgu+02CMDCVB467TVKQ7IuCMwq0e3HUX9oQWq5ypdubjSULStSRpUgvm238nlHcEivCYffQh1FJFIO2BVm1wskEyZZwbpK0VOCvWUrqiFMjZQWeBQhVXGa5dbjvj6Wr547alucZ1EHN4eHscWF3ebWBLXrBF9QgE0aTVTLyhH0Uiqc+mmN9/2/XA5922L8BNobRmYhibvqpeKDeqLCSFpqQQOfB
 dZzLudQb
 TZzDH4rKf7JULEwC5VUxE5ybsXEWtEZeuX60EGCM9YXBXxkjSpi+Kc4O1dXjvzAydu87BL0l/9TdnzprXrx6IlB35o7IS5EmG9vUvWPRrmbaUSrjgRfDXdBwiJxjyqj/jBrbkpHZADDntnYyCF52qhszYJtjuzAj68dkhybZSRl+gXPsbpqKFsEnrV0C96lSIogrPZLaqfCPstUTVLOmmBtU9LoyvZqridXI1wf6Kzqh3X4fjuzUrsy6A9Y0GJOEVUdbfChZ7YNA6c5RBU4zkXiCPeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 5:18=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi Oskar,
>
> On Thu, Mar 26, 2026 at 07:47:03AM +0100, oskar@gerlicz.space wrote:
> > On 2026-03-25 14:38, Pasha Tatashin wrote:
> > > On Tue, Mar 24, 2026 at 5:29=E2=80=AFPM Oskar Gerlicz Kowalczuk
> >
> > Hi Pasha, thank you for the detailed feedback and for sharing your patc=
hes.
> > I understand that my previous version was overcomplicated. I will rewor=
k the
> > series to follow your approach and keep the changes minimal. I plan to =
send
> > an updated version later today.

Please take a few days to manually review the patches before sending
them out; no need to rush them out today. As I mentioned earlier, it
is very unusual for a series to iterate to v4 within a week.

> When you are resending please make sure to avoid deep threading of the
> replies so that all patch emails would be In-Reply-To to the cover letter=
.

+1

>
> > Thanks,
> > Oskar Gerlicz-Kowalczuk
> >
>
> --
> Sincerely yours,
> Mike.

