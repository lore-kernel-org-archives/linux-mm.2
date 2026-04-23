Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFC7FDEE51
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4AC6B0088; Thu, 23 Apr 2026 17:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65056B008A; Thu, 23 Apr 2026 17:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AB36B0093; Thu, 23 Apr 2026 17:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A6DFF6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:49:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 512691C06F9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:49:07 +0000 (UTC)
X-FDA: 84691161534.02.BE5E457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F66A140004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:49:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HOmq8lRA;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776980945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nujJS2BoozftAoryi1Z5f2y0D61PYjd4fv1c5M83f8Y=;
	b=TyOkXAw+4nLyTzJ24L7n+TngR+rV15pAtIWfqw0aODgAbVKCyP6Bo1F5uCCw3mpS4QrmEm
	nFK9bflEK/PJgDUblH18Lb3TzGo4v+Bxuo4MEwBu5wg8SdQwTgb6wr2p0S+LQaFzWt2d+Z
	FqPHOwynjG2pOFnf72Iz6nPejwk6BJU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HOmq8lRA;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776980945; a=rsa-sha256;
	cv=none;
	b=EGn2U6+cSTQDm3oG4RySP+X/T6gB46KKbGGo9b+JwdZog/KV8psB8eins1a3zGXh8Az7eZ
	lIfQfOE7ifK7rEz0ShDYTyAGamuad0SH7k0avidpuyDmjcjrTlqFLV6eoBCZklzBSH5WoZ
	kZUjc0zAQLHUsbDwylB5FyCZI+btzCM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1975F44317
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8156C2BCB8
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776980943;
	bh=P/MWsaczqkhvhvCm3TetzydIWSeehSFXSjf6AmPzRbk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HOmq8lRAd348jGfBf2LCuO3Zv4Y5MC+MOUJmucc7R7opCOCYhsQaHo5fm2BIBfBRx
	 7+o/f3uTNiOkiKmbbQ9DxVCVD1/2NWe8nocTGohr6TzYAh5vo+5ac9TTGa2A+vMR8p
	 tamLLRZnULnXGHBJt0DZi7t5e1P0Dt+NhbsT9qxFlapShySJkFT1lNLT49/XC8WxfQ
	 VJct+3/dYFdQ7WWemI5GSIICP6s4xNWDDHeGIn4k+jzuF0Pr/QnihIrkdzgLDzhUKr
	 omd1ykrU0crh83x7/piUG0H3Om7pysW1H+OnAemimATR4vUwHODD2o/rRCi2EqMAKn
	 hGHcu1Bi8Fx7Q==
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-64e87a81639so6604248d50.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:49:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9oI4TNba8U+RktIenBfTDeqpEGi4bMwdJ/d7hb7G0xgu1l2I43sGoY2l160P/WDniPqXxccTEVLg==@kvack.org
X-Gm-Message-State: AOJu0Yy2pE9lEh1Yube69QX8rVvgKZ8lUXmb0UcuIWu2TE9SlqGl7da/
	iPACvDY+pA3+BZJEDLe9NsfYAwf0D8FsYlKxByhpTdbEPHomhd5bh6fMl9GjFK1QLnO0MsymPRE
	UhVfsyRdXj2pD/V7Zg2uQrsqpyL8nEPu7ikWcwjFwAQ==
X-Received: by 2002:a53:d015:0:b0:653:35c:c60b with SMTP id
 956f58d0204a3-65310abd401mr23075208d50.54.1776980943250; Thu, 23 Apr 2026
 14:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260417033951.1111038-1-baoquan.he@linux.dev>
 <20260417033951.1111038-3-baoquan.he@linux.dev> <CACePvbWZO-=Nwho9Hfk-2HpuggZyb+Yt306MdA4X_icAt6+Z9w@mail.gmail.com>
 <aego1T9d6PVudYqj@MiWiFi-R3L-srv> <CACePvbVHgry4oeXeouML1YNscpuMNSXSnBY9wd-McDUar4tG1Q@mail.gmail.com>
 <aemF6D3Do9FQYUOF@MiWiFi-R3L-srv>
In-Reply-To: <aemF6D3Do9FQYUOF@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 23 Apr 2026 14:48:52 -0700
X-Gmail-Original-Message-ID: <CACePvbUih1E7cypNwPE13Xf8tMzYG5sjLoPO0+Yt7V0uL4qt+A@mail.gmail.com>
X-Gm-Features: AQROBzBvVVp7kQ2PrX3CYiP2T0Prn_UbVqXPUhqkdRa2YfhfyABwjIltE60enuA
Message-ID: <CACePvbUih1E7cypNwPE13Xf8tMzYG5sjLoPO0+Yt7V0uL4qt+A@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, usama.arif@linux.dev, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4F66A140004
X-Stat-Signature: woas5wzet4hof5ukfni548yuaq4byfm8
X-Rspam-User: 
X-HE-Tag: 1776980945-854697
X-HE-Meta: U2FsdGVkX19hwYcH28tJvD1kW+PQBRPfkpRabiWaifrpIlbS/TWd3bLhiR8I1cfG7A0nFoXrKNpSvMcSRs5zbgkPcq2pYiK0fp49+mOJmE5/9sTVWV4/6X+1f4X+6F+fVLVaYl74x/SXIR+WUwch/wBGVjS6ENbga8C4vVUHdF1i0+FvhMtLo2aQH0QitXltb6nFN9ddTzj6ZmEsakbk0WY2FOLYCxLN2RIeXOgrKMtsTlsxF5CdsWMj/td3a9POMzpZQe9lyvTJf4j929nmrjnmKmjqv9s7/v3fDLub2fyahv14mibRcXByHJG6IKEQOJHomD44zg0UfShHDMVahKYf1lEUMAO8lbPqdYoVNHeqTZTnTBB1p0lQiujuII/K0guLrLYa9aV3DgrzXWRLP8VLPkK+QilbMklgj/MCFsXGBzxodR2Tny5KuyThsLmEAdhAS3Ds3l9FpKK/Ybj93/vwAQIFA3tKD3glefpC3sfgnNEHgrcBPN+Ww0VaFz5ohDmSThM5nQqfrXwNeOfLx3elaatKmaS5ek2yAh/YIFYNC6E978XADZ0luSiXiGd9lOor4zH0b8yMN/907UZbPOa305wGCql6E6LGrqOt90OM4c3aToAvBCgcbidh2HfWLSxCAx4xGRfV9mJ1Hmsx/b1hjr5ZY2mlppy2jEMoeZtMZ/I0doQqk9fnVZEgshlhelq3zGxg5tsz8uW4QLBYeSiuRXKLiJHGBttz19HRpU7UqU+EFXU8X8gxWTzMrRNNZvMjWrPkLyJ42toMijV3A3pBY41J7XU1xNvRflwAJjGzVO7gZTjiAfSQRfjxoiEzjL0fHIIt2MFd8wBOvxGLkIlgvqA9hwQdE8ZvI0mrYzU/uXxkrp2+CntkGBQYU0A+rXeS/YLuH8Vk660p8lzZlXEvVzPFRKEoNQ2ssuvc29C8n7VnzXJtNqYK6oH/oQTx7TmfQKnT+mMCLPpAQ9J
 OkmSsCdR
 JNKIoNx82OZomb5Hj7D+RIe8P7H+gGIPEsi9mVqa+Y7mbnLmx12v6aoxFU8qyYX8xIxhj9EzxrD5S9uuKiaQJWmziQIHduc9yMII4rt1Mtx3WRcAlT8uYx7Pl5SicmYBMsuXdvrSPzTU1vMtNQwiWzFJee0HzY6rhVosare6socOIpBP6+AK08S6g4hIL0uLUiStQ/J9ClN8aAdI6jOa37gkpYnk5URUea4iJJtQqniXReyxB8oGzLibFjFnqgW43OEcW82I223BbQcsPAmVixAtJKD2Yl07AbaYusJyP4waksI3iIp9IMbrti97KlfhApg67T6g5fuuPIf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The incremental change code logic looks fine.

On Wed, Apr 22, 2026 at 7:37=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index af81fa212f1e..7644049a0919 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3518,10 +3518,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 goto bad_swap_unlock_inode;
>         }
>
> -       if (init_swap_ops(si)) {
> -               error =3D -EINVAL;
> +       if (error =3D init_swap_ops(si))

Some more nitpicks:

I think some compiler option might warn about assigning a variable
inside an if condition. I suggest moving the assignment outside of the
if condition expression. As it is, it looks very close to "error =3D=3D
init_swap_ops(si))", Some compiler might warn, "Is that what you mean
instead?"

Chris

>                 goto bad_swap_unlock_inode;
> -       }

>
>         si->max =3D maxpages;
>         si->pages =3D maxpages - 1;
>

