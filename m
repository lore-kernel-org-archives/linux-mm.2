Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C348ECA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 14:42:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE296B00C6; Mon, 18 Aug 2025 10:42:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496206B00C7; Mon, 18 Aug 2025 10:42:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D36C6B00CB; Mon, 18 Aug 2025 10:42:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2BDA26B00C6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:42:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A52F913930E
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:42:16 +0000 (UTC)
X-FDA: 83790143472.08.C924C59
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id AED1C100011
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 14:42:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LZarhbnq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755528134; a=rsa-sha256;
	cv=none;
	b=DzmLqUn/G9hq9LpsXg7F/XtXEwYrvfHdjgXpnBOF5BSI9NpYkNYIW4scq/x41Evz6m3Fzn
	NGbvNZI9io9KCeAfaIG+sHNR2CQ3Z00ojq6Qj+/S+ui2fPyTkbD1+uuDOJk4Y7yPXWBpF4
	q7tQyd86DrQPDi9vQciKfLTc+GAMRRc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LZarhbnq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755528134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VylDR1oWkJ0EiX1c8eLC+dJ8zDkBar7+OrlY7elEsc=;
	b=EJa3zTCRK5a31BaK9bd3HE3SmEyXlevtCFWeG9NDWTgL2bcRyc3PBFUZoupf8amw+dOxgd
	UcymsxNz60G6wPWZhGJd/UzHiatzgdqVtmhq2uNk4cH9C7kvDVIIb5H9yRgaRV8jdZ394f
	Ezw2+4ve+ZOtb77FoKv8tRIOINMd3Lw=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9dc5c6521so3012663f8f.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755528133; x=1756132933; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2VylDR1oWkJ0EiX1c8eLC+dJ8zDkBar7+OrlY7elEsc=;
        b=LZarhbnqqzAf2qu5tad8qDHrUV6bvcTa9H6nGyXVsE6Bjf70lDmazyGAoSG2f/7WAw
         5huY78uXTYE6TiZP76Oi3kGwTKbWQTt71CXsNDqPHHS3l6HL35ReWStKM7bUjKOYJaev
         DzZyDf3yOaDhO9MoKYamseg+8TtDI/PWydrguTOPi0iLPZaCHtU+jU36z+WQxJyez+a4
         gU1HzCsVv04HcLsSawPppPhiilumGUMk22H0vdP0SZtgopkvlf5a6eT3dqupYzODbYNG
         n0zE7fohQo+nQA+x3UsToHqtD4gOO6kjLRYCaaAdRVf+0mw4Q5K0zqHH8wF+0oq7CsTG
         3mAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755528133; x=1756132933;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2VylDR1oWkJ0EiX1c8eLC+dJ8zDkBar7+OrlY7elEsc=;
        b=ivRMzOPP+xbRn2SqqeJDa08F4qu4x6Uxo315Nt8rJlHsAP4vNlYOeso3s6Cox3tuGg
         mHDFdPIHsBj/+48tJEuc10z0yrRqnW7Gvnrc2Dlc5VR+dqpQdvhpx2mn5dKGyD+znb6z
         W/3ipFUJ1gwf51ljq4cPzLOvmbxrd7gigxNjVdqENE70CbiHh4o5unQarpILTu5Twyx2
         N+LbNFPx4HGDlAaSWBzx7shaRXqbcCz9P5HAJOcjgTWoD04QtgiPMa5ijpbKR5q0hB+/
         hy0rX1U9aN5VRnmuugMrN8O+yWgCBJ0Dj5nRPEI0RPPRTNB3kSVSG7+xBF4K5F6eNcJk
         q94A==
X-Forwarded-Encrypted: i=1; AJvYcCXI4Zagldx/1+b9wE0SAqvklHKXnLFfG875A17QQ5WLoB5MJLVTi6Vfj09SlGwJTeA82qX8D0Gbcw==@kvack.org
X-Gm-Message-State: AOJu0YwjFQZCbzCRadgcIRgjbsTluYPpF5ihcqypScw5l6qOidpPLqFL
	mGH4e5ZXuW0/p1A/ABujTe2smjYXoi2Iyo6UddBEuvjRW1Kisf9xpLNvjNb1M+YpyWyBGHcG0rH
	V1z4hQTOr373sbTFm5Vw4wKibglVWXmk=
X-Gm-Gg: ASbGnctCCkod4qndtAm0uzv2HoBewq7SoYOkwkFAHDV4QoG6tRqul4ftSlZLvVScnV+
	r9MCLxaByRdFRKf2e/FNaKly2nhmAc9AjoXRGnOa+xryipDS6JNV/VrIOoRjLkRrWm/bnQgvA4J
	jF9w8szIJ6+7qYfoiffk6ux+2Ybz13flu6qYusBf+LtXZtQeEFZN580rlCfTwngwPWUrdbTx9v+
	SP6pA4ATA==
X-Google-Smtp-Source: AGHT+IF6uyFUGlyDCHbyGxLbiebW15nl1dAN+7KqllTQkgQUSLDjBnckdQ4PrtuCjAiIJxTGaqJ/sn4x3b+8l/vlLUI=
X-Received: by 2002:a05:6000:24c5:b0:3a4:f50b:ca2 with SMTP id
 ffacd0b85a97d-3bb6636cb19mr9221513f8f.8.1755528132931; Mon, 18 Aug 2025
 07:42:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250818075051.996764-1-yeoreum.yun@arm.com> <20250818075051.996764-2-yeoreum.yun@arm.com>
 <CA+fCnZcce88Sj=oAe-cwydu7Ums=wk2Ps=JZkz0RwO-M_DjfVQ@mail.gmail.com> <aKMmcPR8ordnn1AG@e129823.arm.com>
In-Reply-To: <aKMmcPR8ordnn1AG@e129823.arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 18 Aug 2025 16:42:02 +0200
X-Gm-Features: Ac12FXwekbsyapeljRABB8AE1hyjZDIfFB0HZbnsKW56XSmgXNqVbJdHAoiUZKU
Message-ID: <CA+fCnZd9m3WBPimikuxSMNar-xbDaNFNQEJ9Bn=8uCMe-uYHeQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kasan/hw-tags: introduce kasan.write_only option
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, corbet@lwn.net, catalin.marinas@arm.com, 
	will@kernel.org, akpm@linux-foundation.org, scott@os.amperecomputing.com, 
	jhubbard@nvidia.com, pankaj.gupta@amd.com, leitao@debian.org, 
	kaleshsingh@google.com, maz@kernel.org, broonie@kernel.org, 
	oliver.upton@linux.dev, james.morse@arm.com, ardb@kernel.org, 
	hardevsinh.palaniya@siliconsignals.io, david@redhat.com, 
	yang@os.amperecomputing.com, kasan-dev@googlegroups.com, 
	workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AED1C100011
X-Stat-Signature: 7bp5xjwfzyjjq44j9r4rz4m8jdp5t6wd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755528134-754590
X-HE-Meta: U2FsdGVkX18sIFRKfYfTTl7aOr0umEC3pLHhz2SjcuFC6NNwCEjA+dzhImWFBUsqHoHgSQETT8r8KJv5bvP6BIKc80czzILDU8zdOGhfCvLNCyJMIp8QlqqrJ1z92qYjI/nJqcEpFa2MdwFn0uRb4ip2NvIeThqEKlnOsrj7Nuv+tcncKXZABil22uqiZr8w87sH5edZL7T7z6uLCQayeRshfQ27N0MoLM0putVeNKz0dCRTwtvJEOQ1P6YwmqvVuqHlv9kdT68/w3oT1pva/fm4SgFn4noMjvvtXgxQMvoz6QVeP9rEbUzHxOrdSftd8NjljO5KqxLNll7+b+cz7U0ZA6LNOPqTOlIVLT7WJ7QYCscfyuAVO7Uf2eGpIXxzwZFcNfCIpvPtklwUgyOxGjEF7bMec8x+1ISI4GletLM7Kt53bpW1Hjzl5hL5MAYmYE98iCUHixuJ+TrnEq/bXxPFD9NJJfBf9t2RsocAXt/qk3EkU1Ust1b1find6hnYyJmIWagl6AMehzG29mLAfAmYL3X8TPuHDNUjACaAq8eOz4brjvpLj/AY535eXGrojMOV5im7EQMkuZjM8/xgsspWMGPDA/agrqLzSpuVSL7cU3tA3RzzJSIcBbxqy0U0aeYG6ESCU9b7+zZG03tgzilfv0IMMLVvDvR+UthWjOs/sxO8ZywpqGvaDLzq125hSHSb6CwGYApDhkWtYP7Q2mpVbCJh1HkonYBhau3CZJN2WiP1gzqQ1Nh3abK/ZMoQ8k7SuG6MCt7G6FnApZo277PmTJsOtQNFnqVdRBdJPR9o9QT/ulNtvhwtHCAw2F6tDiUnIxOM0vzbVgqPtM2sX2FrQJ6TwT/1GekARUrTdD3vm7p6tgQ4ma+gayvwukrkrOhrSSe653Ja0Thd95WTSk+jh1wXlxZDFj7Qc4/TgoxiFEtxoJzsltlEtZ+XdWJ9aHVyagUMS7JGpFnnZv2
 UDaMN48G
 bMTb4maxLEcB0nG3W1/ZpagC+xduajYMdGH1ZADQ+Et5QP1RsBMOGCzlEavsmRoI8v4vhrUUamslD7gpPwgHa+7or1GL8ucUwlmDKJYLgyKitCMtO5Nc1ybY7+0kvzEt4qUS9vxEa8ytgcC06cGzHBrnkuTPS5aeNOVf5FjJMz8RjtbsiNyyetOjBaH1nax57IWDHS8STKzlwFSMoaFPcWqn16PUN5abFIunzQ05OwJITuf7FZHRxExpkPkyBot2ZcVVSjl2TcBFWX6jcMX+WhIA36dZcuARc/MzJ8gVn+P3/7LcVV0lgQWGZtO5+Ctn5QHiURuW4V8RXbV3jOUa5rH7IzRry+B3l12D02+LfxgviBlPOACRUJBdngfWAMgxvCgd68LPUn7dCiYLfaaWPHsu+pExoxTRnz0+jOwRPc43t2VbaM3K82J9pDlMBzztQvEOWCzti6cqIK16weYRQnnudyXGKBu0ejAELzQ6bKO2D82GEaBjbVAVZ0KiRSMw7w9myGMr7JwtVhRSuHK7m5LTDpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 3:11=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> > > +           hw_enable_tag_checks_write_only()) {
> > > +               kasan_arg_write_only =3D=3D KASAN_ARG_WRITE_ONLY_OFF;
> >
> > Typo in =3D=3D in the line above. But also I think we can just drop the
> > line: kasan_arg_write_only is KASAN_ARG_WRITE_ONLY_ON after all, it's
> > just not supported and thus kasan_flag_write_only is set to false to
> > reflect that.
>
> Sorry :\ I've missed this fix from patch 3... this should be =3D=3D to =
=3D.
>
> However, we couldn't remove kasan_arg_write_only check in condition.
> If one of cpu get failed to hw_enable_tag_checks_write_only() then
> By changing this with KASAN_ARG_WRITE_ONLY_OFF, It prevent to call
> hw_eanble_tag_checks_write_only() in other cpu.

Is it possible that the write-only mode will fail to be enabled on one
CPU but then get enabled successfully for another?

What would happen with the current code if the first CPU succeeds in
enabling the write-only mode, and the second one fails?

> As you said, kasan_flag_write_only reflects the state.
> But like other option, I keep the condition to call the hw_enable_xxx()
> by checking the "argments" and keep the "hw enable state" with
> kasan_flag_write_only.

Assuming we keep this behavior, please add a comment explaining all this.

