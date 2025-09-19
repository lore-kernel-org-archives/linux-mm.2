Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 403E3CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 15:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F473940008; Fri, 19 Sep 2025 11:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CC3A8E0019; Fri, 19 Sep 2025 11:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90904940008; Fri, 19 Sep 2025 11:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8066B8E0019
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 11:06:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37DDBB8B46
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:06:40 +0000 (UTC)
X-FDA: 83906326560.27.7CB4AC2
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3FDFD18000C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:06:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r2V+/YKw";
	spf=pass (imf16.hostedemail.com: domain of glider@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758294398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wq2abhQipyX+QwuDbNp6dgczc/zpKuyCE998M/az7IY=;
	b=yW0Ct9dZ71MBZAhPEFE3iWnvVU09SmLv/29JvTmRv1a29weqzQ3MSbiJA/NTO4tLr/Pg22
	Q4NMiKoakuKYtXJ7Q80VV32dC/wfl4g2Hyp2p3RU0psv22f1OdU6l/RRu5LNlJObyFsJli
	JGyT4KMtvjz+M1MINfj2ElG6O8hwmOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758294398; a=rsa-sha256;
	cv=none;
	b=5wrAJug0poYAgSuem8nmgmnj8oYDbKoOPII4HHB/IInrSN4ZtYr1ghocfZVKMN7oTHJHug
	PhUdoCLaC7hfOTiIEgHd7r9tl2BfSZbufgotSLhS9ZpH0SYEezTC1Zdqgx7OJc8dI923cN
	D245nk0xPPjW6ATaQ060Ehy6cpXRgzE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="r2V+/YKw";
	spf=pass (imf16.hostedemail.com: domain of glider@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b5eee40cc0so22114301cf.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758294397; x=1758899197; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wq2abhQipyX+QwuDbNp6dgczc/zpKuyCE998M/az7IY=;
        b=r2V+/YKw5MD5BoimM+nZqGuRzeKov2fK8MGYqKkg35VFRh/8ddx43IXxeVL2iTMEHE
         GZOIhbBvzkuy1/hMj81C/bB2Wg69Lj5mTPYonp5KRrvVSHyaq4sktcTT1FsdS8wrxLV5
         w9fUlcaloYCItJ/W5sX0NLKYA1StBHfrkHeRLkyGxwP7uFVBaZ8hvJca+iVsVoEyWnay
         cyNBmPY+GREq5gsK+hfq2U9qF5cGesvU9kjv8uUqT7mD/ftlkx1MIamy6HeZrE7BHNpA
         UMrO8Kfl4eSfKgpLT2I5zmWsHHu9B9j5xSFCBjjXdqNbnE8rxoOHEuhr2wiTfJVvPBzl
         UM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758294397; x=1758899197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wq2abhQipyX+QwuDbNp6dgczc/zpKuyCE998M/az7IY=;
        b=Vd5dmn9e8KNWBTilJuf38PGpIGWAA7vmcxn0Y9N27dwIkAt6qu8lwt3vVHuO3rKoMo
         4uCuID8Ys/Y/fffcLJOrkzKw03u8BEg1pNf7BFZynhtvVzNR3skdeSiiz4+3tIzcWfgL
         8zyYT0sSfajfl5Cf+XEXPhx3wJsLxsxvqHMYrRbHoD3MD2Jl8kH7C/WPKaQwdHIdRlvM
         mjIYL41It1PwoQ4/frbYTCoSa13EKbaImdUTGXrBe1+5D4KbxkBhjx56NmHsbDyH8OEk
         doVPD4q42x37gLLl8duHBBK9ZS4FD+Q/oEvTyDK9PwqDaVMWAUP03qCSgPA2FP5Pm8Cg
         twkQ==
X-Forwarded-Encrypted: i=1; AJvYcCX72Ci0FIs5PPvDNoH83qVZ/tcBet0mqEUktsg9gENxGIm5maJNONWIda656YJRwModxs/AcHO+jg==@kvack.org
X-Gm-Message-State: AOJu0YxMh+mf7ncwJAfg9Eagqu2lv2ve40eghB7TzzVwPGZ8GMymMfT4
	DJPahUlMPvmMb9Yt2Et0FkSautQMO0GY8CCSt8s7Y6nSs4ENluNfVBKVQLubGRR7VHd9fm6Kr2O
	9q17CAc8nEJCh4idCivM/Cnqg5myHWY1WRW+XajbV
X-Gm-Gg: ASbGncsp++BpBj/6gP6Y7+quzhS0S+6daysztzA+eP5o+RVq2x7waLn5lT//uRfQr5i
	Z8LEOkK0bA1+CHTMI24s54A+8z+1Elmz3aa7+877DeFt4e20tXDadGywbtrhKoSPdshAwLouCZe
	3A0wY7B4iU6pJcEhNm0BvQWk37o7G4pX7+pBqr6UiUhtR6rxy0KB9PbBRAZjZAbC8Jv4uAAzBX7
	m8cNciiL3hpXDzT3aS2G/HLYm7tnRuPc+u+3Q==
X-Google-Smtp-Source: AGHT+IHAZGtVHgR/T5vgwj/kVG3d+Xvhn85HcOAqMoUr6UVAzkpi/OktlLCwoHTesoJWJTkkDQIa4OfoQDwjclHUNCg=
X-Received: by 2002:a05:6214:212c:b0:798:acd7:2bb with SMTP id
 6a1803df08f44-7991d54f750mr32395906d6.51.1758294396642; Fri, 19 Sep 2025
 08:06:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com> <20250919145750.3448393-5-ethan.w.s.graham@gmail.com>
In-Reply-To: <20250919145750.3448393-5-ethan.w.s.graham@gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 19 Sep 2025 17:05:59 +0200
X-Gm-Features: AS18NWA5Hk_dVmA1agOSIAGh1dzuifFPUnlHCTY8eojJWXc2mgupvfI9rEJhlqQ
Message-ID: <CAG_fn=VXNBH-1QDAy+xR_ubUr0rZxmPBpFWov1y+7a65-mtGmA@mail.gmail.com>
Subject: Re: [PATCH v2 04/10] tools: add kfuzztest-bridge utility
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, andy@kernel.org, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FDFD18000C
X-Stat-Signature: y5t3q3c83ihiadqmqgfqeenbwa63f1gs
X-Rspam-User: 
X-HE-Tag: 1758294398-186415
X-HE-Meta: U2FsdGVkX1/2u0c4aKlf/sTjAUa+GCLQts7/5WFKBnIA5E1maV2l9KOlXeFOtv6EF4cpo9pCN23g75YpQKK8VlwevrUTJZY7kH/yiUiFBgSNBKi3tFUlxUHn0Ucxpfj0M3En9+f+DXghAUGSv80WOjqv294LG7QN3/uSKL9JwbOmF7JXjUArZlD/IpuCtrVHoXeSTEh6jGMTSnVxApVgGXb8qktaOQdEdz6S3Vp8gZ/GEz/HX4l1Td10cFb6HlWfwngG+txbplSAZlgpD69AJhHL1KSxjPQglE/7iQu3T7d3ulJ5sFadeyK3cH4MozSAMy3oMtAR1V86wval8zU1P44/1F2gsgJlnXwHm4GlxS6pZb/q8HBXeKt3utTtmpwASim0f/LsITZm6hctKfoG3b9pzfsRyhoGYpgCJkON1rYiYHevnyIg3DYe2Drf4P1AF3OL3gKCq/NC9q6PaZ2GOQQFejN93yQsAzXktVl0Ikrqabpv/PcgP7nQKFJ3Ah0EkH4qZTFi3SgKxeVeQS1l9MUZY/HZAXFSLUWvNtRzn96GxEDaa53p/g14sC9uq+WQHPFyX4LmaVzKHhGBEKQnXSWNdFUJ/fUEeMGTKKaAie4WNQLV1uF6HtORe5NmAMiC71/GDrCzMZ+ZCqGLLh9Tfv4Q3RZjQfRxua53Eb2J2j+cObbHjgl5p6BrlhIuZ85G7T/GalVehpTLom4vrt3wyiz7EPfB9OBe4hilPvAMaZMISmrLueuwS7mMCu6iP6dx6KX5RNB+tbBPT2crcynaccg12Kc0Ay6KXbnGDjjsI50ef1l8AW3hjKDNNj3cuib9xY84bNeePH67MAvUI9TumWdcsgmvMKieQ61Y81xOS9PscILTRJ4OUFT3+/GEHed1cmLFFC9xtre4ul9t4Kbay9/y/sqHA9jR1pHr+e/enGg8b/6YyrlYX2vB+fn1tz/k60JFB3tw0pHPwJCw6iY
 DnotFy9B
 xOuDJfBBcgSPM+t1uQvIzt20bOrGMsj395STnCUlmT7q3LTHDFjHawsz6XYTxPX8k66+356YKoRlLNjhh8ij+qNcTIWZEJd5n/2o1ntezPobONLaqknKrFYz2jOmEl70HQa88IDnj9SyIFSafU12HHgiC92In7miIIo6RzfRR2EyLZA4aURts/uOcBoqffIK0mahdPygzVCxBgwaELBoTIW9uoiXu3khAU5ztW7dvgrxIQBYP9QZeE2umfAqtlKad4cMfTpH+UrLMlBqVbPCu2ScgHw0r0dR8NTvq9+a2UtK5+MegMi3+P5v5B5GG/cyuqEdb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 4:58=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Introduce the kfuzztest-bridge tool, a userspace utility for sending
> structured inputs to KFuzzTest harnesses via debugfs.
>
> The bridge takes a textual description of the expected input format, a
> file containing random bytes, and the name of the target fuzz test. It
> parses the description, encodes the random data into the binary format
> expected by the kernel, and writes the result to the corresponding
> debugfs entry.
>
> This allows for both simple manual testing and integration with
> userspace fuzzing engines. For example, it can be used for smoke testing
> by providing data from /dev/urandom, or act as a bridge for blob-based
> fuzzers (e.g., AFL) to target KFuzzTest harnesses.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

