Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60BEBCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 20:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A54658E000D; Thu,  4 Sep 2025 16:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C1A8E0006; Thu,  4 Sep 2025 16:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9693D8E000D; Thu,  4 Sep 2025 16:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82DED8E0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:08:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20573B900D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:08:43 +0000 (UTC)
X-FDA: 83852655726.09.972296F
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 310AC140012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 20:08:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRLxsDng;
	spf=pass (imf09.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757016521; a=rsa-sha256;
	cv=none;
	b=K7SmgNrkllkgTaJ3VmoDQxK7IwRrcM7Bf3nJ8A/JEqJjJS96A+aefO12r6zPLEuZI7TrNm
	x09DlWqLMmEj59il59tycJTSsthClww2JzU0LB+iaJEbMf+GYBjDPveOGNw1EEI3cz8d8v
	6Ls6KXSkeIdzwH7Anw8BdvRa5k4YC3k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRLxsDng;
	spf=pass (imf09.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757016521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gv63X/vQm384UIbEqWmqDeqv2bYENAIp/s5gNmTAzz0=;
	b=znqpiTVEe4InluJpIgYkJQDUDdMbMu12fbm+qnJMWm2nqVk+LQ9wq4LMowULwIzKpLh/yV
	UUv7wODXYB6viaKODR2/BpLekGGe2IbOabk7N53FmwphRAiVoDHCp6DMxXW9+8t5+oAJui
	1swlNNpzZBwAmggDzeFBWGAfyNukUCY=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-329b76008c6so1145423a91.1
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 13:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757016520; x=1757621320; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gv63X/vQm384UIbEqWmqDeqv2bYENAIp/s5gNmTAzz0=;
        b=MRLxsDng+76ybAWTKm/92LvWj/AEY6D9iAtgh7x43Ig0Qo2thzLSNrXRzaNtRoxjKv
         xS1POjiq5NlpYuzigcfzJknSxPgUXyUyhQanfvCOxzDiFTeDffQW4mtAjkANsfsvPmBd
         fY5dl59aJl2NGfdRGsygoi2NN+0+6hFMiEY4ogPh8qR4uu6t4FhKSozJx6JP/kZVjQHc
         fkIilvYVxR7iYb/c3c4WE5ou39n4CbFmqEnIhBxm8nzdtHSckWN1wqy5WlfTg9PFblFd
         WnmTmZUlJ/fdRcfWmSZNfVb2HkRQxAqujN39S+NNR2Zf6eUw/ErvvOCnZqxbPAEnEsUy
         AESA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757016520; x=1757621320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gv63X/vQm384UIbEqWmqDeqv2bYENAIp/s5gNmTAzz0=;
        b=kvfSkWbSMwHTusAHG1h2sDIMZgKL7/R4W4R6YJS6k5QVbYWycUmzwlMxhmbeaxSU89
         yD53SORZVhY3REPo2rjanJrVe78O9w4tRXaU2/fV+9vg9grARcblWXxVUUar6FX5uWia
         8XcnnaWW00+0EOynmMjZTTUJ0VtO2GKMhcsdLKvz9Xv0myH2OVKzMyI+jvN/8TF39bSC
         E1dZGlGcNZnWqH3MxOSeyCm/EcPvofD16mnLvwRaLFrLEfs2sTabufmI7yyMTptr805L
         rC0yG8y/0EGEvIkT7Kfqw9LibTFSGc5L3OnH3DHVLkLWQm5J32UH3Qga0f3z1QEXIDXI
         8Y2w==
X-Forwarded-Encrypted: i=1; AJvYcCWdAEBdf2sH0E/V6JQLv2yl2SlS7Ws8CWoXKTW9pD612IlBUjjm7D1jggVAUKHxNYXdekk6Hun1Dg==@kvack.org
X-Gm-Message-State: AOJu0Yy4+TefePZbs7UtWovfGggyPhY0Jh/qLfZxDgmGMD3dK5REWiUn
	2R7MNLj0UtsCqhZ7P/Q2mSeTLprGkJzZBeQfj1MDeOKEhVW9t88s/OaWA/wY2ZlUKdvH7Z3IUKX
	eQhggYhNETdq7JsEB1fOxs2Axo4I/vnQ=
X-Gm-Gg: ASbGncvsj5U1QKPmFc5CLo90exBA1TZGUSZtO4gNK8T8jF1SF+HgxN57X10rGll6kQx
	cQxZ3j+1D7obJVazgLDiumvEM2Sh2fkcLCfIZfr63RgbBjqmbF96J7Wwyp4MwgWPvzoash0z/+2
	2ZSmxXhvnjrAEBmc6Chp3HpTVVUyL0z0OJ9i7zqLMJARmnEQW+Qd/c4hZqe8tzy2wk4Q7ly6UpD
	JU36WgQviJYtuCXNQpo9hBYcmr6CjqpUlkF8g==
X-Google-Smtp-Source: AGHT+IEjqpitfY8TXIZND29ig5PdIMIT2psIfhUSF8teXLvL/cYNO29iq6xPwr5aBLoyY+oSK5RDMQ71M/Oej/pf6xs=
X-Received: by 2002:a17:90b:3811:b0:32b:6145:fa63 with SMTP id
 98e67ed59e1d1-32b614601acmr8171223a91.4.1757016519877; Thu, 04 Sep 2025
 13:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <CABVgOSmZffGSX3f3-+hvberF9VK6_FZYQE_g2jOB7zSMvVuDQw@mail.gmail.com>
In-Reply-To: <CABVgOSmZffGSX3f3-+hvberF9VK6_FZYQE_g2jOB7zSMvVuDQw@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Thu, 4 Sep 2025 22:08:28 +0200
X-Gm-Features: Ac12FXydPL4VUvPU0jz05GoorbNVB63dfkWSac6PClpHYbvI5-ih43lt8hTBuT0
Message-ID: <CANgxf6x2aPfeP8gz6wkKdTZ5q7PDiOYgQDfEYW5Mh37YYTZJ-A@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
To: David Gow <davidgow@google.com>
Cc: ethangraham@google.com, glider@google.com, andreyknvl@gmail.com, 
	brendan.higgins@linux.dev, dvyukov@google.com, jannh@google.com, 
	elver@google.com, rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 310AC140012
X-Stat-Signature: fan84bj7qbuinmhzfojgyrfagumhrji8
X-Rspam-User: 
X-HE-Tag: 1757016520-127991
X-HE-Meta: U2FsdGVkX19SniyF3ZMWwul70dtodrEJIyoeRJRqiWKvBHbJb0+B8N6MIdnkWdPsVtLYIuua+IKfhVTa6d+9GARaSL/46CRW1rD7upU4/vdaSKFJhmMU3i28IpZQ+hwCrj3mGwijaTnYvJC2fsQG1opMvn7wdqnDNEWPaN93o/8z+MND2TPfy8WC0c2JvxbpvoU8gcZYwDczp2C9zCilzvOXcOTalqbTEf5G72IDLfp9brjNtQZZpAUIe4ZtVL35a+UwHv65cJqU/zdmIGagmrcuuFho6yrDU8/OGngx3X/aBpXx/IGxoO3Ibsn7RK8GEDFbIBAMxccn/cLHv+0kQUC7ixIMLohbpmGAW8Ue3GllMjl53R+2SNWJ6TKk5j8xpjDkpBDNv5MAx6rI5H9nldLL9k1TIVbA4nRInpE8ctrcL1vuBgJl4ezUKlqVx/SMXCDeURSTeg+lwtCD8KX9dSXyuanbXVlw+ijKvjT4vyD0MvqBJc4A9IA5I7HEWrp/HjFMI5qUKwaT/7WBPyXndPajM8uWh3scNK3XER6XI/GXXYzleDnaCXfCapVydlqzmndFOkW90bwGr7FA0b56dvAOYg5xp2c5yZLBRsLA+EvJ0P9xV1Ba4EjcuJQ1mCYu/1H/rHfg0bnDw3LKbstnkIvr8bigY6sNXFYHNl8dODRIJYiQhMd+2v7SYtXkIFvD3NAM0OWiId/nKpnQ4I+1fysVIvIOQbCuOd3Db526BIPLl6ai9yT3QPPW5j3z84nGbUz6XI0AdzA/2c+kbjj/rAmKTsUWhEr1A4qCoUjiJ+BCIfmsOVhNfXZpEONWdp42QusHyG8RyQ7nVOKHJX6GOwT4WmIOUmDTMOOTI9KwQbQoijrIaWjzTYr4eVYDLjpos+vDwOR5lTBLPAsJ46PB6ClHUTrq6J9udljsi3mNN8LkqcmndsT1277jrusnmSCQ81TFOe2YU2y+0IYUqFh
 8ln4QJvu
 IZWnTggcuIv8Et3OloZOK7E4ls4CCITuNEJme8r8LVm8AROdKW9y2uinJcWssHFUof0RdjOHaqTJ9eL18yGs3zoYfn3A644OAcKvkegDwHManbc0vJMJbTAPAUH0eb7apS2sCmC/5aQpsJVTwU1DHSX/aArJ3k5f2Ev+80vcF8ZKeS4s0S+FpGXWOBSdI/O8eGlcaEUx4TttAKOD8CGS3nJKcPZRziHbpEgaT/glEEOuiVP5Q/u8lofPC+2iQh27qYJ00dEoLnTf6tqYVRHQsd0ZUuk9dNGShxV6q35PBeQNnMkMZxyOwlMTjvYdhGPZO/qiR2f4gnCTOqMS40l11CMvRCpGn6F2mkvq4ZEr5KuPx5aTAZvC7zpYmDqMNI/9XVtsFCzICa/+3ULwqVh/9E8onNtYuaN9RS9ax
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 11:11=E2=80=AFAM David Gow <davidgow@google.com> wro=
te:
> Thanks, Ethan. I've had a bit of a play around with the
> kfuzztest-bridge tool, and it seems to work pretty well here. I'm
> definitely looking forward to trying out
>
> The only real feature I'd find useful would be to have a
> human-readable way of describing the data (as well as the structure),
> which could be useful when passing around reproducers, and could make
> it possible to hand-craft or adapt cases to work cross-architecture,
> if that's a future goal. But I don't think that it's worth holding up
> an initial version for.

That's a great idea for a future iteration.

> On the subject of architecture support, I don't see anything
> particularly x86_64-specific in here (or at least, nothing that
> couldn't be relatively easily fixed). While I don't think you need to
> support lots of architectures immediately, it'd be nice to use
> architecture-independant things (like the shared
> include/asm-generic/vmlinux.lds.h) where possible. And even if you're

You're absolutely right. I made some modifications locally, and there
seems to be no reason not to add all of the required section
definitions into the /include/asm-generic/vmlinux.lds.h.

> focusing on x86_64, supporting UML -- which is still x86
> under-the-hood, but has its own linker scripts -- would be a nice
> bonus if it's easy. Other things, like supporting 32-bit or big-endian
> setups are nice-to-have, but definitely not worth spending too much
> time on immediately (though if we start using some of the
> formats/features here for KUnit, we'll want to support them).
>
> Finally, while I like the samples and documentation, I think it'd be
> nice to include a working example of using kfuzztest-bridge alongside
> the samples, even if it's something as simple as including a line
> like:
> ./kfuzztest-bridge "some_buffer { ptr[buf] len[buf, u64]}; buf {
> arr[u8, 128] };"  "test_underflow_on_buffer" /dev/urandom

Definitely. I'll be sure to add that into the docs.

