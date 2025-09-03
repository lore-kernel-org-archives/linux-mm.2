Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97551CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBDC8E0003; Wed,  3 Sep 2025 09:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93CB8E0001; Wed,  3 Sep 2025 09:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1518E0003; Wed,  3 Sep 2025 09:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8F38E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:22:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 422091DDFB5
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:22:29 +0000 (UTC)
X-FDA: 83848003218.07.76C254A
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5BDFB20011
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:22:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ue8O16bd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756905747; a=rsa-sha256;
	cv=none;
	b=GsY2OajJfVhBKMYS3V8GqY1PSg/YhL4aVTXLEaU1wNmvUVKvldO8FZIWZL+ZLlKrXPCJAC
	Vs1gPRAKrPByj99KzliqkMGCILanmxMv9+hi54o1wjK1UgN+03D0ioCaVkwoWd8oHF+lWS
	1Bj5jwy9IVGyrBnlkHAbtKWNpb/n00U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ue8O16bd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756905747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3/FvEb2tmp04THrfe7Q6R4Z9tV9DSLFC8M+VKKCGW8=;
	b=k8/LAGql7VrlpqldlMC2ydYldjV/cFRAXFJ8fVaSHAiAX7HTsAP9ERM9vSzKOab+Y474it
	u1L2oMowNjEGWohqhYjfzF+bezOAnEsXQiGtlrtq5NKSPGeSXioIGldNN6/2JX2Q8FOyOB
	SFANSlJHSyq8m8e+CBpkAjv3b8pd0qc=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-45b84c9775cso26714205e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 06:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756905746; x=1757510546; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+3/FvEb2tmp04THrfe7Q6R4Z9tV9DSLFC8M+VKKCGW8=;
        b=Ue8O16bdESKzfvnzMmEFV3IYvQqNqPVjKO5Yd4oY7H1i+1ucrps1gJ/28B7F2UIcnR
         mBdHAxdKqFI20D2UOMJ7iQ4H9QZ4E+cgZE1Dwkzg5qMeCeaXG2Uw4c3ZOTdLa5e9dYbf
         b+Vjd7xZ/KSdmu+VVm7Tx9rYUE1cP0KsXi0/a+/kN+zW5QtjW+1zTNesr2LiQ/5HU3yP
         HJE2Xe5aHzMbkwmp/NhN+UUogQlDv2b0npaVy32lwZ4Qwk27Mv7cy0FWe/2kndpJlJbR
         Ra3d4VoPsnLWhiPePqhTgEgAFMc5mtD6HTLBCI+Tk4pXizpacz737rKISC584MNXAvOY
         0NEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756905746; x=1757510546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+3/FvEb2tmp04THrfe7Q6R4Z9tV9DSLFC8M+VKKCGW8=;
        b=hsGSCLQCTceH4iR9tZm/YbKSatc4yAj5U+ukSYKiwVIzkYsUDEVs4YMxnx4x346bLw
         vsGgNjEjaR+aZbcB/ZACbMNflwSodBOd7LMQocwTZlH0Iy6lkE298+Zor83iyUqfQMge
         zzeA98e5URUf+U91RW4HWU6iyL5EmlmBqkJlUJYk1alBykSHCmsgXiiAwrjA2ZmVaW4c
         6eVUpBbmr8xxFr4NCkUVE0tiyNLEkgTFbio+xRfGDlwqCOYvPfW2tey/mofb+c9X5WHx
         oRyw3GSnrhWBe1ndwA7ujOdbbDJJaifFtblyD2scBBv3GuAtibnTql4W6wYQul+0q1iX
         1LIg==
X-Gm-Message-State: AOJu0YwKsD59lErD2UbLrmuWxGsvo0gE7jwf0pDs/L3A6N9S4yI1pl5H
	SzZH3k0e5jq0df51EMAfAP3duox/Ozk8QIqfSZ4gPJMjKuD4vgqV3B7UBmqiJMrTcJW/LhQcMXx
	dwnGeocSRk+2vd/PotAICMaJp8bRfmr4=
X-Gm-Gg: ASbGnctAKa+XyerpVFcsgMiRtEWdgR45/ofPsH+amtSYhHfC2pk4KajqW6DBkYPzBcQ
	b/EpYVv79OweYGpo0tQ9NMw8uIwlvLgZGVICcoExBn2YSDKa9s5IXzYUrZivuicstFDfnc2T7Km
	SF23yBoqfnxAKkPO0RL+udQt09diPtINy+9UegUlu0PjIjfJJDyM/waWXjLAwevNIwrkzRgSmIz
	L6r3BtF
X-Google-Smtp-Source: AGHT+IHTlltZP/PiYSefk4BiHHXMLghkkMyukGhjP2TxeCsHmSWWTRuInnnO1putZr6sen4D8zESFOr8o1LvNPk4oE8=
X-Received: by 2002:a05:600c:c8f:b0:45b:7ce0:fb98 with SMTP id
 5b1f17b1804b1-45b85528677mr134028325e9.5.1756905745452; Wed, 03 Sep 2025
 06:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250820053459.164825-1-bhe@redhat.com>
In-Reply-To: <20250820053459.164825-1-bhe@redhat.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 3 Sep 2025 15:22:14 +0200
X-Gm-Features: Ac12FXx6JqZw2o7u1Ppz_iF81kfxsSp5T4xMMmvHYDtA-FZpsjtY5aXsfqZMrYM
Message-ID: <CA+fCnZdfv+D7sfRtWgbbFAmWExggzC2by8sDaK7hXfTS7viY8w@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] mm/kasan: make kasan=on|off work for all three modes
To: Baoquan He <bhe@redhat.com>, glider@google.com, dvyukov@google.com, elver@google.com
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, vincenzo.frascino@arm.com, 
	akpm@linux-foundation.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5BDFB20011
X-Stat-Signature: ajwhxfhtitoay5cz7nqa41xad666pgxx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756905747-625158
X-HE-Meta: U2FsdGVkX18li8BhmRaONawZK8gwpgv8Kbll1Je6eTxnp6X87NPf7WOlq2sydcXylFo9oh9F2le0qGvd43S8lFWUFRQGvQB/cw2+CnTc7SnDJG7rdSt3oigbrF1qYERHy8Y0Hu/LtygwPRvALU2ALv7qj1XUy3n3fJcl16QpJALVpXeoexTNg2F8RV8BWE85y6oZe1jtKEjSOjMh35Ek54brCA3AbUXRt0hyR/Xeiz6S8dCUlHS0QDeaU0Z1afYbvvuebh+D88UpCiSN84+IEr18ke5IkHmIRkopFQssGW6uYa4BVDRZzATwQ7YL5g7L/Fr9r62rThet+3WJuQTC+A/jBsklj2fKhMWMmy1thPlW/8+lFibhHexGnKTqfVMMSuHE/Sb8WTiChmtQxdopyC8aN+1hRDbQgjI856QkHlu3wVecQ8QiQu949T1MfGyo1IWyMClZKrC6ufx5zdFuKqWzXBqe8MVelrUa7gCo6Ut4j/bZ0VmG64lDj2OU96Ws0Th8HWAxmj8FUMLYiEyGQLKTNeWeER5omCYYHcbnE1pG3AWrW0mqhG8O6D0INajCvTvlr4Qr0Tk1GknW5p2s2BXd9/KTKpYDytMdVmIYhhxL0Gs+CJndrq0PIgUxeMm4kwkMqSihSgaFSBXLgirsqBpiooGoAPugpJT4+K5MpfZ4/5odbGpHjS5BMrYcpRrLxrQ4D/gmeDAtXpg8QIJzU/DH+ZIl02wOFKZ0/P852RmcetuvFtQnVjvocvjJwLGn9Ib+ynl8JzY9PjfsjPpPI++HsWYE7x5t4nxIOY1kXKiRQMYqUikrh/QWT5TgjEca2GamlK9QNIjz4009ubk2zrFj+5e3jjzv5TNFtm3Jo2jNBrzzx5rA4kCYD/UFb+UUvnlAAhGUBB5b2RvfYjoFcvhZ9yUJ2HF8CTxvfjUUuZqpL4Blqyhgm5JSBNZIYtnImexHcopO9fxFq7xgpOE
 YuKprHFy
 5uYIP2gZBlv1nrov7fus+2bUjZB7G3hhNquX1OitqPvFiq4FHVhApYplIlUnh2eU9iipvSkIpEW03/tORn8t37RDTp7Daexij0zmYKyFYQUkEsYFNTnCyt/nbEG3+igDKBcwnNVzpfV0Yq0607KfpGfqhMOM/WW7qkgwYYKOR7MJKJg6A+LN1AAqVXcBLtAyRgi9sU1eCE8MsIlEOU14dnYaRi4B7ZQ1TmTCyJNDsAFL06KlLKZLAGhDEMpsglfKJnAILMA/ScgXHlgdBQCMSbhWqD5IjKQuYEIXtVmOMffJKSPyRMhTuYKGbQTo8DAqUTbVsv9fHXh+clIicL55g248DkEh3slt2Enz9khF5IQmj5suAY1xLBYbGuQRibE2g11ml5gBeKLRwSklNo+/1XxSv/PLSCdezcDGI/ea26cXwfaTL+L0satJ5BxbicJtiUNb4u47kL4r04ksht/ycco7R5BJT4pBt/VpsaLlUz6yq5RbibZZQ1Jn6dg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 7:35=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> Currently only hw_tags mode of kasan can be enabled or disabled with
> kernel parameter kasan=3Don|off for built kernel. For kasan generic and
> sw_tags mode, there's no way to disable them once kernel is built.
> This is not convenient sometime, e.g in system kdump is configured.
> When the 1st kernel has KASAN enabled and crash triggered to switch to
> kdump kernel, the generic or sw_tags mode will cost much extra memory
> for kasan shadow while in fact it's meaningless to have kasan in kdump
> kernel.
>
> So this patchset moves the kasan=3Don|off out of hw_tags scope and into
> common code to make it visible in generic and sw_tags mode too. Then we
> can add kasan=3Doff in kdump kernel to reduce the unneeded meomry cost fo=
r
> kasan.

Continuing the discussion on the previous version: so the unwanted
extra memory usage is caused by the shadow memory for vmalloc
allocations (as they get freed lazily)? This needs to be explained in
the commit message.

If so, would it help if we make the kasan.vmalloc command-line
parameter work with the non-HW_TAGS modes (and make it do the same
thing as disabling CONFIG_KASAN_VMALLOC)?

What I don't like about introducing kasan=3Doff for non-HW_TAGS modes is
that this parameter does not actually disable KASAN. It just
suppresses KASAN code for mapping proper shadow memory. But the
compiler-added instrumentation is still executing (and I suspect this
might break the inline instrumentation mode).

Perhaps, we could instead add a new kasan.shadow=3Don/off parameter to
make it more explicit that KASAN is not off, it's just that it stops
mapping shadow memory.

Dmitry, Alexander, Marco, do you have any opinion on kasan=3Doff for
non-HW_TAGS modes?

On a side note, this series will need to be rebased onto Sabyrzhan's
patches [1] - those are close to being ready. But perhaps let's wait
for v7 first.

[1] https://lore.kernel.org/all/20250810125746.1105476-1-snovitoll@gmail.co=
m/

