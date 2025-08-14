Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6183CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 21:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D4359001E0; Thu, 14 Aug 2025 17:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AAA39001D5; Thu, 14 Aug 2025 17:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03169001E0; Thu, 14 Aug 2025 17:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE1EC9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:27:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A41F117B0D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:27:00 +0000 (UTC)
X-FDA: 83776648200.27.61CA2C6
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf19.hostedemail.com (Postfix) with ESMTP id 65FC31A0004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:26:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lN3Oi23C;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755206818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdjyiC9t2sFnVWubrduW9TaZqSWryaWv42jY5Hi7s4A=;
	b=o/qdjlR+gKwOg9zCVbFklJ0JIx/RWXcDb7o7pErgqNfV80xm9PqZq2iebjW9vQcGALso9M
	lpvt18EPCVtiTtSlNiqKzfzqoAJL2Hmqp9KpQ2pqRvtnrbSsZmZB1nH238rmFx9t/31Eek
	k8edw7iEK9s0dpDkMlP6azNeB4X0TG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755206818; a=rsa-sha256;
	cv=none;
	b=R9bMJ8gfG2ll+sIOkTuCKcMiCgFfMCbt7tTrvdyeFNx8EcvA30Zo6/lpJhIiMzdoo0IVFg
	g20lv1DT1P31hpAEZFTN//MJTkjgEyz5D/mY4uAMz1C+zSg/vMRhCZr4ZJHWmdwgfoxr/6
	GVzXlmoLjkFmxI1o2+fNoIosZ6QUrKw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lN3Oi23C;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3b9d41c1963so761779f8f.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 14:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755206817; x=1755811617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdjyiC9t2sFnVWubrduW9TaZqSWryaWv42jY5Hi7s4A=;
        b=lN3Oi23C1tlFFAcP/KQqD0dzNGZe6GZVt/lgNLuopIXz+FLZqGgSZS9d4hrHnji9hO
         OxfL+yjalDLtSc02DVG5TdRG2Xo1eDQxmVC+ZH1MZfLk2ULKpDM2g9QaR+LgljHJid3p
         vSTdfI9YAp56bQEfdLY/NBjY3Vz3YHLYcVwNATsqNe3HFUB18pw1sItLoypKC8a4A8y9
         rlTH1TgJo0A/5F3Z1n6pCG1AIC7LvrN2hDCji1wNE0YveNaz0wXwt6+DOx+XLJyxqrdU
         c/BiFQ5z0KUwEItF5hEkoElK1b+dgCDdkPRw9HMGCM0L/mJvB8uJ3UFmoSVPEqV8DfTV
         6Q0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755206817; x=1755811617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QdjyiC9t2sFnVWubrduW9TaZqSWryaWv42jY5Hi7s4A=;
        b=P3OvhX0cYXUZZydR67bfQPhrvqSnZ2rkrt7r+DWi5FdOYrrxrYYaCMtFawSQ7KiBh1
         VqK+BygjJxVup/EHU/aRRgWs3JdRy2JAzPGXqihU3GT3AclyBb1gkyB/KkU2WWSWMcS+
         zU04JD/LFznh+g7Fd1lOESVHN+JRpf0ef2lBaaDR+IgVMSDR2hk2niCrUs24IzELA6Cb
         k2M2ppl6MSV0eY1EFVKAQBA756iRCbniu8sBQLxFxj+3cCTMmAj+M3M4ddGS2ZKspQJK
         Am+cfITmHJKywoEQGoDubcyDjGbng7imlNNofc3lCW3axVzwqZI6xISaiiwIIrUHeMzg
         e/kg==
X-Forwarded-Encrypted: i=1; AJvYcCUbqCO08vy09xitFCB6ToKFUTZQeCNWJ6+xJdki9y7kPM/2EIJY6Y9gLmDamn+yLTHHN1rZWmTkEA==@kvack.org
X-Gm-Message-State: AOJu0Yx3wJCwEA416/mOvXyUNWud6hMd70FIcD2jLsYbvy99IaETLkB/
	Nzh3C8TxAiUtiQRhe+i9SWOF08VIQ3Vqh44HIv79mBZmLOlsVGPY8MoS
X-Gm-Gg: ASbGncsjNNiPOk9NUlH9k3RIpQXyb+tUbsFBRQiZKlMJ7PZUZ67f6HYwlb9EC3hCSNI
	Z//Vc48QwJa6cnBiRvMxptfB/I18qyG37YKiGH2A4xK36L7H2JcoR5iNeqhFU06BxQVTDLx/my0
	EQIxqj58GmvH8hGiyDADNQNTqX4JLeS7YVXM09ik2g5ZsGAKYlimVS3+aMEF1hfSbkVz+2o71dA
	vnbNmgf54pZZZDw11oYTiVlgA/XWIBirRoVeBaqYP6jiTXDNr3qhIYoeDl19GoSKm41+Iu64X/m
	uKBshwhzzCCY+thZ2FlMyVvGnpy0dFFT7tcZNOJKJGyf8AQuDlgSqFcT1IXfzVyjGA/Y9TRFVb/
	/tKxypNA+RTs5VEAUCQl7MUe/B4mMTCaRAuyVAtsyETt6jjnVZYclxItjelRG
X-Google-Smtp-Source: AGHT+IGEklx+oeMWF1vXpOz6vHkVD4MYz9DztWdjDoQHv4oIdmzSLGiJHDTuR+2qvmRGK+UOqiIskg==
X-Received: by 2002:a05:6000:1a87:b0:3b7:9564:29be with SMTP id ffacd0b85a97d-3b9edfbcbc4mr3472504f8f.49.1755206816591;
        Thu, 14 Aug 2025 14:26:56 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c4533f1sm52559367f8f.42.2025.08.14.14.26.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 14:26:56 -0700 (PDT)
Date: Thu, 14 Aug 2025 22:26:55 +0100
From: David Laight <david.laight.linux@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Qingshuang Fu <fffsqian@163.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
Message-ID: <20250814222655.0384e05d@pumpkin>
In-Reply-To: <91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
References: <20250808072106.153449-1-fffsqian@163.com>
	<91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 65FC31A0004
X-Stat-Signature: qbbbu55gwbf1oqsx6czg1wyoxrwu8eew
X-Rspam-User: 
X-HE-Tag: 1755206818-690039
X-HE-Meta: U2FsdGVkX19Pdye2+knIRtRY9nz+zYdqkFJ+YNc4tUIeMQHB6dl2PJIiMUsaRGmX/btMGTEbPBi5E6lcWhwFdxvQu81wO7mjRbufSRp4lTcUZnw6p4S8UBNoRmZnaN7GplN6BjspwsA1BW4XhD3iZyP7VGQeoRUkAAgjE5IMMBH0ihe2QxKlPcOqkhlYgucZAoWiI14a+RXvm3aYgLgl42UsaGEM8L3VP0UYLJ0qAm9iceX+4bPPeM8gRTYoTT5iMxrUQ+Y3x0I6grclxRk7VcW2MkTHaFa4Ape+ycLU4MziJKmihKHC/P8npoBgKt7riM3ifd3p17YRkXrlBRf+kJ+5QHFA0Gtac4gzECeDwI/MZqbJmN1Y9tWA5pWdIvbKHSjsbbHf0JHLc5OJp+9eNBnkaH/VP5Ii9xwrKQGljVF5SaxCr8L4iIkYQNbC2jfmlKguqEW7YRk9SoRK8hlDofyu9/h2DQ+TTVClb0x0DbHllDxjE1vvouU2pUnB20SuZwYOGcn7huZ+wgMYX6H/cmp6E6/XqkyW8XyJsb435qDf7p1Pr/MnYkGkOlSF9wNxxTcIsEPzZ2W6ThkfvYfRq9OS8bplnDVZCaDaBAAJK+z4oXhtow40XC8S96jL7T+NpLQKxN1yG4DWP8zoPIyA86jqDScodx1C/y4xhlE6hdHVxCIozR9p1t/3d3zD96Ei2hZCUO7vDtu5yWRBMpD0FTnaL+H5edON7a0NiQWyO6KNh9x0Ph5PbGNiiezfKseiWdeTqQl1ehG1+iYR8tZLSnmlOSFbI8aaR7ZKipHh8eM+x+KsoZfDBI5E/y3KIRVHvv3Vh9zBaYkRIx0AjlmLMyy/fWhouM8QJIsnWZuTS9IetXpX0rQujh3dUQdNWX5PO/JvO56gwqpZgGSCZCJQk0QzxhmF0nJEZkiqIlw3uomC2SULilxFoxCGiddPn9kQ64L8BQcslmGDHmNAyLC
 ydUoW0nS
 uuVKSggx/wjftFORpLHQxQNxqtWIxp4NjnmZbF+bjma2goI3XdVfMkbQHBbL2j9M8AA4E9vpKcH/DHuc3fviMZp1oXc/VmKZiZDhBgTNFVQYh5PSFhvxmCnztP7aDH63BrwT+B4+b+z9GfrkwQLs+l+/wJDF7+kmHNTLiq8tCMXbaxDk+ZcmfLyISkEasxRTMxoXh8Uj9L5i4QjKJvG443+IlXHSVMG/ZfsYeIE9FHMNNIBFI7SKGCqvrChHpMoO1GQOMyglcTqTPiB14sHBGlpUz3mBFGWQsGyExgYMGkRB7oziSCPHyZ6kUz2d/JSerPZjKARt+2pGdyh66K5UicqqL47E2tzHByscc+81xdS7OK7P88jCdcZj/ETsxr8c+runPvpCH/sJLDyXyeXDjqhptZwZj80b8ZrPmuptQ4XuUUow9moZRQtYBfAXjzyePb0tVLNJkoYCe6ZvDypkeQjpoLQTBPD4/G1S9IFBVLqD9W4CkxaPGMxh9og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 Aug 2025 09:35:19 +0200
David Hildenbrand <david@redhat.com> wrote:

> On 08.08.25 09:21, Qingshuang Fu wrote:
> > From: Qingshuang Fu <fuqingshuang@kylinos.cn> =20
>=20
> Subject should probably be
>=20
> "mm/vmscan: fix build bug in read_ctrl_pos"
>=20
> >=20
> > Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1)
> > is int,but MAX_CR_TIERS is an unsigned type, directly using
> > the min function for comparison will result in an error:
> > from mm/vmscan.c:15:
> > mm/vmscan.c: In function =E2=80=98read_ctrl_pos=E2=80=99:
> > ./include/linux/build_bug.h:78:41: error: static assertion failed:
> > "min(tier, 4U - 1) signedness error, fix types or
> > consider umin() before min_t()"
> > And MAX_CR_TIERS is a macro definition defined as 4U,
> > so min_t can be used to convert it to int type before
> > performing the minimum value operation.
> >  =20
>=20
> Please use empty lines to make the description easier to read. Also, I=20
> think you can simplify this heavily.
>=20
> We should add
>=20
> Fixes: 37a260870f2c ("mm/mglru: rework type selection")
>=20
> BUT
>=20
> this commit is more than half a year old. How come no built bot=20
> complained about that?
>=20
> IOW, what compiler are you using and why are only you able to trigger thi=
s>

I've remembered that this code has shown up before.
With the current minmax.h it is ok provided read_ctrl_pos() is inlined.
In that case statically_true((i) >=3D 0) is true - so the 'signed' 'i' is
known to be non-negative.

But as well as 'i' being signed, the entire loop is silly.
To code is called with a 0..3 to execute the code once (actually in a loop)
or 4 to execute the loop 4 times.
The abstraction is just wrong.

	David=20

