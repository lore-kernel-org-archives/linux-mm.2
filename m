Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EDD8CAC5B0
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 23:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2025A8E0002; Thu,  2 Oct 2025 19:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9CB8E0001; Thu,  2 Oct 2025 19:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116FF8E0002; Thu,  2 Oct 2025 19:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00C108E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 19:16:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 71B9114057E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 23:16:39 +0000 (UTC)
X-FDA: 83954735718.15.37CB190
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EEFEC000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 23:16:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZY6+iofw;
	spf=pass (imf22.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759446997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ja9Bn6P2KMK2i3cPP4zfsONf+zHduNfLue2PhQDsu4M=;
	b=yWQoHz7R93vWyz4ISwTI7+Rsyd9KmbQZ+eFW91VVbjrC2H8nd0BR3vkMEIlu2sD9RHztpo
	n/wMDBUxvsfvreqc/0ynW25KPwF3Ml+wyK6ro7VnHxT4X2n7rgQwZEakAdnu2CN8fjKk2C
	TrIjaV9DVj6GlRZeOAjODnQvw5MmQF8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759446997; a=rsa-sha256;
	cv=none;
	b=1HoWLIabx79lCn7v8tKPnbJbP9bhbSbtGShcbcf3ZtT49iZUtNBFlhDzGKziJMcMHmC2zQ
	M3wKmDJKb2UP1Ksx6SzkdkuT8MdWsxJ3F6sxmX0D8APueigwYO9d2scMaqu5NHp7hbFkgj
	4CdqozDYZ5RvCj+WsfCbqrNaWaYgxUg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZY6+iofw;
	spf=pass (imf22.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2697051902fso2064105ad.1
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 16:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759446996; x=1760051796; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ja9Bn6P2KMK2i3cPP4zfsONf+zHduNfLue2PhQDsu4M=;
        b=ZY6+iofwX37NhEioolhlogMDds1g8h9JrHV10jcllo9JR0drfRwNJAAvXKvd5DV0rB
         sGEQvv1Mt8FEyLKAwoi5S09sQfTIBHuqquHeHDcnr+cOoDMa4DyXUTkNYSmVFkYnJkYa
         NfQAXKhO/nGvlJvnrF0gAQBA2bmaS0hxYSSnr41xXXu6GBBjCvgkMKbThKUr1axKQMgE
         Il9PMnWaCAZhaUcQjpqcHT0rlH4ntlVHYxrjxTC90qy4HOJeB87vJy5ZUEyJA0jOkMRF
         H9tk/WhXacTlT9Wha9m7BPhV28QOdYGhscGAuszTC3e72jsy+9uVsFPJdhA+c6RzEYsW
         WX+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759446996; x=1760051796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ja9Bn6P2KMK2i3cPP4zfsONf+zHduNfLue2PhQDsu4M=;
        b=p8dfxdf72SzUrC0aQA4zt6E+0OsG61vwEGuYYqDgwhGBH5tT0vZMaORxNpBQGrq7oR
         FJI6uWBFH1ZPeAG1uOR4znvNQfhAfQlWufXpS01eaUEBTvXNvG9hg7wxB6VJ8PoIQf3q
         RTyNE3sYsjbewIwtUeKsrnp4J/tZ0oBSFNnn5sRK2bi4S0mnt9EKb8acZrtPaWtkWres
         xTaRNnvesXaRATA8wMFN8+FTYOvzAsH3RxQelgQXDrg09k/Gsrs7gwi+BB7yLG6MaRSx
         nGJvmh88Ec3aQjaYujIojhmE9SB28St54ZwsqX2VRUTg+5gp164+qFp4qbXMi3s/X6Dr
         cuwg==
X-Forwarded-Encrypted: i=1; AJvYcCW756qeDoY/DeBFdezs6JMCh36P+uP6jbmYXEFGJZgqDgz9KjkyfhjV7VSMeyNts+gEwLI0AKs3BQ==@kvack.org
X-Gm-Message-State: AOJu0YxgikkYaWfVeEyLq5THFRKP9bmX+k91db3rFQrGoWyTJrhtdCfZ
	06Rs2UD+tDgfbM2iTGXi31DsE6eKuTOV5XLTW5RA9+MGzrAsM2tgaufyGXzKpDWBvED4AK+sZWI
	kpYAKDmSG9F4YmnfHm3zHVPldBEG3xC0=
X-Gm-Gg: ASbGncsBydgjUCgUdIPfL/qNqxEXGgGkcMREft1+nH1E/4RqhkEO+AVoUrB97DmmnUK
	mzoAH4iZO56ceenTZ8tclXIFLg4qlmwUuR/IWLdwp7pIUJAf3snbHsnJbQg3lRMYFwwmCUzDAuK
	G9ZkWl60jL1P0hvkHeSBKmsQrAZPeA6uIXWtXNctQbBTYnkm8oNC3gRlzO+NrJCMo2N6jJV4brI
	lKleZjcInTTQVh/4jfcczk8PALTaU3UKpw2Y/RkIHY3A4oxNWAIENt8YAysl2QOAw3gECgfFSIx
	vhB0rD7wffvCLSrIyKN/Hyh+KPunmtohh/IIPw/jMPaDYGjkSw==
X-Google-Smtp-Source: AGHT+IG1jLZozgPgBjz8il0nnl06KAhRwEmfM28KR42HSA5o1aegNp29hlxSwQoCLtlUe5qlKk2pHpNiYMz9bK5H3V4=
X-Received: by 2002:a17:902:e743:b0:274:944f:9d84 with SMTP id
 d9443c01a7336-28e9a7b381fmr5957375ad.11.1759446996485; Thu, 02 Oct 2025
 16:16:36 -0700 (PDT)
MIME-Version: 1.0
References: <202510030449.VfSaAjvd-lkp@intel.com> <20251002141925.ab86656b1d50f6e27f216209@linux-foundation.org>
 <CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com>
 <20251002152753.c756678dfdcf739e2fbf74f7@linux-foundation.org>
 <CANiq72kWWPAZ3gq2ktMpVeMKpWOU1nAmYi-4d-BgbuDti77ggg@mail.gmail.com> <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
In-Reply-To: <20251002154323.ca15e98421255ae2978e8d6b@linux-foundation.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 3 Oct 2025 01:16:24 +0200
X-Gm-Features: AS18NWDlCUFdClL2tm6c6Fg5XnZ_OVsyL104Y971QPgVO4IBNtdGQLs-NKBaHY8
Message-ID: <CANiq72=u2Zm+MtArPML9EhQyjB1u-OLKe_NRf-dHv25EKA+qEQ@mail.gmail.com>
Subject: Re: [linux-next:master 13069/13300] error[E0425]: cannot find value
 `VM_MERGEABLE` in crate `bindings`
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, Jakub Acs <acsjakub@amazon.de>, llvm@lists.linux.dev, 
	oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9EEFEC000E
X-Stat-Signature: 8mhzixpi9z6n6u5aszoofsb49sx19gzi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759446997-309552
X-HE-Meta: U2FsdGVkX1//d5ham8QGRdIN++mIo8ws5rzG0+yjChl6iHfCUsui51dV/Whyv8QkP04py0aeu38jwrvTB8rdI1Uq/BrejV7KheJWjZKnAx2f4ivnsJvgwsHCIEX9jYT3dWI3qI0DzYMSHZ8Z6ZKZXxlapY9ICaxYspDiDeLC/eNSRUd3J4VMvx/dMbE1KT5L7aJoITJv9Y/CgFV7yS3jCZknonrQ18b4hRinUjUuH9DsSDlStNJ/mXqhklRCMV/wG6CZ5x+/XP7WNQ9Olm6UaMEuBHDiqMKOrIsKnF6Wz+bJ30FrFv0EyhQ422qxGrG9TrFUlBAHzfW2g2PUP0pOztAxwjPUb9AeMbLjnaUqxZEiqqhFO4ZaYbtA36BFQ4/BvascJjNzl+DKuDUq3TjLLECbD0tD+2DOG4VSWntNUvK0Mepf1ybVzkhlhY/dAjp55erpGVxpLD63Qzc3jiRRSEyT1iKJssuJC5bIt92O3wyd6MkSInlIMrsFr9hR0gDdCprB4uKnMppDoAusDoydnICL9yZD6GhEtsfFHKDW01jxClwi39zond+4RO3igb/4Car/IgYVa0mKZISdMBLlvowvy10mheDJW/QXqS3DljzHfpsHG8kCwsf60GuEYFNUVXR6KMlrWWLYY4BqNWygWFlOoYs34mQl4VvyqyPwsfl/Lj5h9PCJSEwmRYOpy/D1o1s0tb5bFYb1MKB30uikF+wxwuxUnewAGizKakYoqXD83h4EWqJ7fum9CHjsSZ4qk5battTezzmEvvO9wkvZBkxFwMbSYeCg0akPyl/vfNxamolqzKOGC9oQnarvGmoXck1kKfZcvIsUnXrai+U16eh4o2WdI44kd4PyFje2Y3dkyYSEe9O7gi1LbEZlArN0BVXl9bBuGv8o+d7930yT0e5s3AY6NcQcwXGxhTDGibsJDWam85pyjdrnEVsiLixyWvqM6fCavhTzCyVZydw
 HlIY+oLg
 jjvUOlTTYZg0/mqK4FbgSSa8RJt10I5XeqVYwaSz3XGD7pq3W2YmjA+Z7A0LZg8ZsjR7uABhJdKsK1DSZmdOAp2hSY994U69FP+9MGRxKNF5oPuhMFCbTDWZlS1URbg7iZcLmvhnR9d/KI5VWAMfuoMch8MW3gko/AYH59eyIeHr/6Ah//MTuJcxJFNAV4DNhltST+ezDPM/IGciVHgnJpdYdl4jN7hTyuNorrTQhJOF+KP+qUcfWLGlpt4rE3Pd/ol1HqRZpKQCuT4d/XtSxi2bAPKzCfqvK1aPLRyFTeLrJOA6j4vXQIvYbDOWx7oNmfv7p+OLWIa+GQje2K/k69KudiJokfLRoIswzKRLXQV+NBDJjT6yACLbZf6chQAUFv8j1HkD05FZFJ0SAzVJDgicgEEor+WgXokCI/prFP56lS2wzRWkQbYTHeC3ADi59fXnWLvMRIJEAuSqp8x/aw+XjiTbRI0MkAWQ1dEWjX6A0HekSIwvBiW3QeIFjjXxOIGP27hCrBHDfeMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 12:43=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> Thanks.  As mentioned, today's linux-next is where the problem is being
> observed.

You're welcome -- yeah, I see it in my one of my CIs (the
rust.docs.kernel.org that runs more often), but really, I think we
should help you enable the Rust build -- you take patches for many
things across the tree, so that would be very useful...

Nowadays it should be fairly easy to enable, i.e. even the packages
from some distros work.

I have build-tested the patch on top of mm-hotfixes-unstable now too
(since I don't see it applied yet), so please feel free to pick tags
like:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Or even:

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>

I test every day -next, so I will see this in my 20251002 run and will
notice if it doesn't go away.

Cheers,
Miguel

