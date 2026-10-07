Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC65BCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D6F6B008C; Wed,  7 Oct 2026 07:53:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A6E6B0092; Wed,  7 Oct 2026 07:53:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB116B0099; Wed,  7 Oct 2026 07:53:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5C416B008C
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:53:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33A8BA01BF
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:53:35 +0000 (UTC)
X-FDA: 85295670390.05.2A5F369
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4948140008
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:53:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tE2Qkrq+;
	spf=pass (imf11.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791374013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l11SxpTuwANf57f5KsVOqnNNhjMstDSs7fMcPi3T/OI=;
	b=0yzqj2nfKWFOsLDZw2uUvrNE76Ne0trkBofXlUes3mkH+K86q8LjO8noJhG6DekQvarAQk
	ezqJTejYbQLZ/y7rW6nn/Ov8T1F3xxMi5sZB7pG3LTbOBQbeEhj2G8uGtCUTDSG7R04zrV
	J4AYDd9iypTSLS4N8dO7P9F9susgjtQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791374013;
	b=8hXrixpu1dzCTB0ohIMX8ZgK5Fq2MLO0BfyLmOY8EyiRtDYQKtPiClkljHminnK1eSS1cI
	Pvw6i91kAinQc9nWLcsholo5X749iVefKYnAlYBLqTxmNL75T1in+NEeJFxKNKuu08bWXs
	LpvMx2wo+hbNK2K6WKBbqr9tGAKujWU=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tE2Qkrq+;
	spf=pass (imf11.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e4b5d94277so11576615ad.3
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 04:53:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791374012; cv=none;
        d=google.com; s=arc-20260327;
        b=BNmJg/eA/yS+7iMA8s/FaX09i8NfRidEr9mmbsf7zwOFsyGuIlKTjaltDSe+qdnS3U
         mF3LGnrsFCV3yYpuW7/N9kf3Gy23GBfAphdao9JZAPm8DNBcknOJYTkIFjnfKnN7SfCY
         J9pf8e/ZtzdDU4jB2FUomD4QY/LWI/DFfuCpulya33/8Od1MzyiHl7P09jIkAo2YQzLT
         aFk4N2VG+3Dqu0PU3mDq1Z3ScRD5J9k8/lugwQE2UQdbp1X6khNua3Eh15/bmRELiewV
         YQG2I/WZfeFhMDCzSTTQ235qSaaidD8RPnqgWEnRCIarMHnbSKrM+BcSecSy3wMdrGdJ
         b+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l11SxpTuwANf57f5KsVOqnNNhjMstDSs7fMcPi3T/OI=;
        fh=qfUcpN/kyy6kxg+SqVUPIzNxNrhM1doove+lYYiGPfo=;
        b=DPwG2XdKLF2tLMScaZ27+qEXekqAgotJB/LAY/HLBC2tXvbuW7FN2JwJSVybjsBOXs
         1a9wn7iHOH1EAZXnDcFOLmBfAOwsDXacuuYsD8NP6F8aitubl8J3f/O2GMoR2qNraZKI
         /KqaTNEHC0Garb+gDwW2UOeBtJ4uAFb2TOzBUpruki8oaFI5BTVP3JvDys6qRheb+Sz0
         5CVKNBZDvI+XthiNOtGiBJXCnw4zf4flm+z4WoWvBsWgZkuz7vz8UHPBeG4sxYmY/Bt3
         9rg6u7GLOjij74M6jb464cLy+6c3dzpAl2xn3lL8WOY9iCG+pIo0sKrONCoKmxf7VX1R
         olng==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791374012; x=1791978812; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l11SxpTuwANf57f5KsVOqnNNhjMstDSs7fMcPi3T/OI=;
        b=tE2Qkrq+GzmLC/z7ki5FPsOEEAkB6NNcYhr4pLycJtEHUprZxIMLid3jWrLgwkX+hP
         sq5r7V5CKzuSfGuIn73VSVd0U9da2vKijv8mY02JaB0sQo73AH9Xj8557Tc0IouJVxJh
         3z64CBcpN7ocja/PZwhVEj4jjVqNXyQRJMER7LfWefRguiEZXsDo1zUmyMxG3N6buXeQ
         hs9gwOY1cHD841v3X0J4LQ3YqWueU+ge6EYDQR458SctsTRXKdWboyc9hK98e8+oahVG
         XSGfHIeNZOC1BdNcWdSkYgcfa5w7rZZLdcIRRnIXX9BhmA3g431sXNI397ebbZ75OfRO
         tDzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791374012; x=1791978812;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l11SxpTuwANf57f5KsVOqnNNhjMstDSs7fMcPi3T/OI=;
        b=dw1QA3ShitY08oZ6yqa5Nqeb8RutC7PQDhIO67wGpr8O2CBKvn8TOYLt43ULFul/7H
         9l7Sjc3zUyoy052kK1u1sUP9rSH4BYdtnXtsehLaUEMp6ZOJO8krUbbkRucpFz47b/ro
         B/ehQcpy++hZG2+xl62WuEqQSaw//NeyaAmL+lJHO0RoVltkvrlAWVb0D1C/IbzaIN9c
         rPfZVW582rHHtGwrYTa6h2p6IgdvmaMSRmAbIcfDZluNjqlMoZzWpKeZmTYOUqXlBHeO
         RvRtvtwGGmukOCr38Yj/fXcJjDD4ObF4UyUGOf+3YoBbHXWTVL8wcJ5Sk8Vf7EwuvD8p
         bYqQ==
X-Forwarded-Encrypted: i=1; AKwUvByt/b1FAy3o9E8hoDvep9hRghCXF1q8PAL5P1d0eRVgBgJZTqex6cw3haxJskO8cS07rWVyJ0WLvA==@kvack.org
X-Gm-Message-State: AFq9FYJoeKyy21qNuO2VI2BpLxpYDVxqE0Tx0dqUVoakB8kBINNTXE6O
	T37B9f9ehrXKkUG6JZ6h/tsLgLI9yByzmfC68VnkqJKLVXIeBCWhD6V68+Dl1Ak+HZwhwTWyxIc
	Xkwy1MsnzQrgPrhY9n+fJ1aWVevTuuzs=
X-Gm-Gg: AYBFou2bZ/biwQWhZAvl5ZS0FA+SnmYXXnk0UnXXwa+j4dV3xzG5ZyqccNmu1UIw9SQ
	XOO57Rzi4jEispRs9Z0lb1Q6m4SBhNBcNBdOrDdTlPaK2/e2UlNC8iKygSJdd9Mgmj8ZabtIW53
	JpWjXkKQ9d/Iq3r/DWwfR12qaTrffBNrtbJWL44WkvN4xDEbAntyUSSGI6CqCMVBf4vNp6rnusT
	CXF5ervyHwEdONLlyBcCNFGDvvx4v9HFDQxvVty4ERbqxVFvWFirrc1ys2cbeLDCStXWgMZoPUY
	uPaL1yG/zN3HbXQKoJ+AFgjTHex9FOpdOaQwTwJZrjyYA+PDpJxawyov5ra+/xwxK8qLuYgPOCU
	C9Qk4Nut8
X-Received: by 2002:a17:903:110f:b0:2e5:c563:c0dc with SMTP id
 d9443c01a7336-2e600509c23mr20094385ad.42.1791374012035; Wed, 07 Oct 2026
 04:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20261006061549.627-1-adrianhuang0701@gmail.com>
 <20261006061549.627-2-adrianhuang0701@gmail.com> <311d97da9ba4b870ef03aa412586b751bc7da3f5.camel@mailbox.org>
In-Reply-To: <311d97da9ba4b870ef03aa412586b751bc7da3f5.camel@mailbox.org>
From: Huang Adrian <adrianhuang0701@gmail.com>
Date: Wed, 7 Oct 2026 19:53:18 +0800
X-Gm-Features: AclHuK_APIuynXW_Vvb6ZGIqmtWSwMFkf9exrzESzLpquCiFRKPp55oN2AWzJJY
Message-ID: <CAHKZfL3z0-fVa7HhW+J5E0RdEUoR-E3wMFYmQ6C0ZQh7t1xoGQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] Docs/admin-guide/mm/damon: Fix various typos
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, ahuang12@lenovo.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4948140008
X-Rspam-User: 
X-Stat-Signature: w6665eh311k1c7gr6afj1wcdpz3dfsnp
X-HE-Tag: 1791374013-545948
X-HE-Meta: U2FsdGVkX1/+PK5wMfviXVkcL8zC9ET1BhR93H7xFVXoFjkbMSbpkCeEd5cnuWg0aEW1xIX/8fKZp8NI3EEUHutcfm4axeaED0c2xIuNXD3u4Mje62eZy4JwHDYtNTBDQWpn0xKFPmY1fqDlBEex1fiJuCSaQv5riBJaJxsyWmdEKKZDWIgQiLJP2M24DdgH+Wtz7ZlCD+35pZEohfPhps+rQJMmDukJwbMoMou8hH7nC5LJTufw+FDEOR5Mm4BkiFV6wOcz4D+QnZK0VR1kkf+f2ilg+KWeWoJzWO+3CUSwenJ3ifu89M7fP9msNhrzfuEDM/+KTbPw8vRJMwxrOAFNXiP43WGFvi6ZQR36nXdvPT+F8l99XzhOJA5gervTBNSeHebGhLMQVNYjErrKsP1OZuESMEfGNggPmWe/cdwGIWUNB9OsAWCur4lzr4Xl2x/MTLd52BOVfeOk3Hhsycs9g+XINuT8q0WyeMjSAcNqHJRGYCwUlZ4+UpKvHwLDydpqzc8Xxn3U1T/JLPare9j1UQRe8J12m0TEGKjADC34DqyE0guGNTicolVGWuh2u1PYEus5V1u78l7SWWyht/Va+Da7jdv/dkGz+eBgulEZmTLVBNVgNOTpWJemDwtTGywc3Ku6Kg38JfuzY7mPOlkss5wjLVOTmVJVlMFZtdbVRTDFTSg7JKIXw5OZbTmr4FrPrH6fQ1H7Lu8LLPrucZULn4jAoWG4H1JiIOOjk24nIP6OuWHnUTeL9co9/dfg5x7bZBHTcW7mGd2NmIsSceQ+Sb+YHO4a/RoJxow41udAb9hlC4FPiCPVtOvWYquvcrru7zybsnZtmuKaMNzW0O0fOveYLLNw/FS0G9zfhlbkqCua0HEIWEJflXWlAxoIXsogva52utFgHoKQWx9QCfZP7yT9Jyi9mQnO+oMjcXbldhSXmoHFaZh4r1mi9wy04VXVv4s2yY/SPTI3OdY
 vM1bm9Tl
 pC6yGx46jeWyL7cBYim6G9y/7tFGo0RBqcGcjW0gCnilG4aP2Po9xvRgRinCfqYrFAeo6Z1XXI0dtTV89M5R22JQtkpKqwGGkM/Js9pM/twcwHOtmEKw2K5h8Qa7xZ/oijPuvFfllAdfIUx/2Ag66adkT80MOEc77Pzf6aarRD36nR0ReSaQ4zWIuQiYC4AdNgCvJu29dnRN+GB81FyVqDSBZ6EadbJeUF/Hn3zHqAsWVSL2/gl021jkTJ76rew1Z1llu4yvIslrsILjrqmUEi3syjrrljl3aA14psO7hWSGNlk4YMvkkaJgtJpjNdFpqcYDt50ftVfyBoLGugPMOosIL4vpe6+braA7XqFnHMWNPP7H3pQKXaBGOhidL8jpMXdHsf4TYX8jp/wwl+nR3BcKTAFiShnaNofrxisOBWTb7I/YzmNfbwrxI+uXdB9yqlSxiinGgFVXPK+g+xeARLTKArAujxuuEv/HfafricT5z0A4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Manuel,

On Wed, Oct 7, 2026 at 6:30=E2=80=AFPM Manuel Ebner <manuelebnerli@mailbox.=
org> wrote:
>
> Hi Adrian,
>
> I have read your patch and the affected files. I have found
> a lot of issues, non in your patch.
>
> This got kinda big, so if you don't want add it to your series
> let me know, then I'll make a patch on top of yours.

Since you found those typos and grammatical errors, I think you=E2=80=99re =
the
best person to submit another patch. The credit should go to you. ;-).

Also, as SJ suggested in the previous email, please post another patch
to fix those issues.

Thanks.
-- Adrian

