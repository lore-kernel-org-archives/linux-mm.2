Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF965C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 20:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA708E003B; Wed, 23 Jul 2025 16:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A3508E0002; Wed, 23 Jul 2025 16:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE7A8E003B; Wed, 23 Jul 2025 16:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0DE8E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 16:01:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8267E1601EB
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 20:01:21 +0000 (UTC)
X-FDA: 83696598762.01.0B42A24
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6FA6BA0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 20:01:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4sJ1qiXo;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753300879; a=rsa-sha256;
	cv=none;
	b=7Xygvfx/cAdYpCj7wkw4/hDNrbn8AfO2r8N93kkHGGHXLGyNRSzCvFc5DS8FlbLDvys1SA
	MNOKquqhbL7+8HW3NhfyZBcxEBejQaeYTuZ0ty5a3PuHaxWhWAfT0zh73tVNKWrLqEdC4F
	SUdUoXOSz6GJx+RYjdlob/SmQSv4sbc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4sJ1qiXo;
	spf=pass (imf25.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753300879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmfqhyu9vL1PIyA4FAolJ8zTTEeu0mpAwsXikAz/bGo=;
	b=sX89op/uZG7VFyc/Gzyo1qMkjzH84fVEF0aqhQG92rgsOXG0ZwS8xBdZx4DAJngbQawz2m
	vMMR+/lvziEhhhZW5LE9FTjxmKeOuaBf6gE4Mbt0IzDh2U242LXeQb6D5JtYeIe9e6sWhD
	iL8lJV6ZGieSWawDaVHfFy4dJPU1vBc=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso524a12.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753300878; x=1753905678; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mmfqhyu9vL1PIyA4FAolJ8zTTEeu0mpAwsXikAz/bGo=;
        b=4sJ1qiXovTj/wdkQNes7Feg60ZbmPhqtxT62jyrJ9N9ONlmuHZqFYE8xB77aPwiqLK
         7/e0ACziMq8Xklf4gQ/6/tTLRNSSScamZ2jE1DR8CfoxS/mzcvYHm+e4cQFMCKUYTd6Y
         OGyktcscVgYAtq4b6RWMbx47rFOa+az3u0NvzuwDmWIpcrskGMuEpJdnMysEfy6YI1Oy
         tZuRwnVg9QulETRhzDdLD1lCn9NU5ZDbTHfhXkvxcqTM7kMdSDPzyYAaoECD82cCBDHo
         WzTy+yegZqg8gS9DH9arg+Qn8gv7bU/CxHnWrH8pIOZYAB3r3MVaLNd7xMry/TXyUzYG
         wlBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753300878; x=1753905678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mmfqhyu9vL1PIyA4FAolJ8zTTEeu0mpAwsXikAz/bGo=;
        b=spTjZ+l6xOKo6b7iUbjtBH0Gy6nMKh3FGwHemZEF3CBT34yCtLhlkeSx+u3FsvjEqB
         Vnu/ii/50AHUUDWrZ8eZwIEqUY3OLwOkT8dHXnmw1WMyQvc+bRgSglCV51PajADS5/hn
         VnFp/W4tG+/ufSWcNJ96Y2krVyJ3HjxGXlc2lXcqaVtBI7z+u4AXinv1Gr2eDcqqSfcZ
         cENGJe8VanNAkY0qf148WDGX+HKFahz+B5Do21JEHYqzEJ+4iKzxgkoQVmVr7K5SC2ov
         jWdHlM2BqiYeK7GshIko3pgBsU5AQrMu3lyjDNTCRKoAvRlp7/zKwdS8YJy3rNouWsyb
         SXUw==
X-Forwarded-Encrypted: i=1; AJvYcCW2kLXPj7T6WxxhiXloIz3zbPvkRvZzwRUCEsEoYACzvjlK46N/3DVlH6xja5GDcnJD8dDVCN4mMQ==@kvack.org
X-Gm-Message-State: AOJu0YyfnNcpmh2lgoR35yIx7Vsj55paixRx6BJYpMbgDHas0Kn2VG77
	u+AFUdnR9gl3C9sKxTJccwHISI1Y1hqB+Qt24q1wE8szO1ASBSFtOHkhPPMD1l3j0OKAo3nTUAy
	1Az22bSBfDQhznVzhUK2bFuB21Yy/m66HZAcNY4g/
X-Gm-Gg: ASbGncsRVaYiz59adpqeB/qx7Q/qp9ZhUxDyRwMw1Ca9beIsZ9GWqHcGC5DJWI5X14/
	hSY3taSwTGNiRemFNcNW9Ea+D2kEyMyiMvDJ5xBcqCUO8bgoYvsuxjxTybKtPrd8PdS0oZlr2W9
	GSLtZMyMTYqcSjEGwSv9M4XAWOi4TeHl8buYUehjTqLgYofSIfpdedBBx+RPNWX1Y6uVuyd5azc
	PUj8awwaHpROadB4+ggJadYaM3UJrMnVqA=
X-Google-Smtp-Source: AGHT+IEyXGTWR0XZZte/eASlEm7qrI06sVh3iGjpWdMzm8/vWVFxkQtUydmt9xCTl4XoHoqeljjoWTaB4r+v4tgfXVM=
X-Received: by 2002:a05:6402:290e:b0:60e:5391:a9e5 with SMTP id
 4fb4d7f45d1cf-614c50e54camr10227a12.5.1753300876951; Wed, 23 Jul 2025
 13:01:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com>
 <16c97e30-19c9-41e8-b73b-c0b3c8eceff3@suse.cz> <CAG48ez1qhjQNHC+3572udqVWHTANFpQ0ngxn_4ZDC9F8NCXsFA@mail.gmail.com>
 <c53b22c3-9f7f-4793-9d10-f4df861a3e32@suse.cz> <CAG48ez2cGX3e5bqgcw0OEnho29+YhwG2eOrHRgNwGAA_Nb65nw@mail.gmail.com>
 <28e1fc65-995c-4185-b5c2-7eb001312698@lucifer.local> <CAG48ez0KE9bfFJ+yAMPUAj=_hcNRfes3=nfQd7Rv95TSnHtUCg@mail.gmail.com>
In-Reply-To: <CAG48ez0KE9bfFJ+yAMPUAj=_hcNRfes3=nfQd7Rv95TSnHtUCg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Wed, 23 Jul 2025 22:00:40 +0200
X-Gm-Features: Ac12FXw7CgyRl7JjB9ySJ0F_t8x_hAcLmfJ4tfnYlheNfb0W0Wn0LvVOrf4lVAk
Message-ID: <CAG48ez0782x2dqa5LrK2cf9M0_Q=Gvo5tXsUFQDtyK00LpcvyQ@mail.gmail.com>
Subject: Re: [BUG] hard-to-hit mm_struct UAF due to insufficiently careful
 vma_refcount_put() wrt SLAB_TYPESAFE_BY_RCU
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6FA6BA0005
X-Stat-Signature: 8x8hr1168585od3ubuzdbzggbo9o7u5f
X-HE-Tag: 1753300879-579184
X-HE-Meta: U2FsdGVkX1/do6S6+Go1lFst2uhufJ9JTNWWA4sQa2gfdTfH4Tf195feMwNAWOT8841ySBiLYu5OzUQ/Ng31X/0YpA6kQIA8u8jBt/3a9/4e/aClNDYyl+H3LIRny1xSp78ougp1EU2RgGImMDemTSkcUCZdL/bEt1s2mxt7CWGSUqq42v56cI+3n6sR7YUuouzA0YaKVSQu75YnZZbgP6QP6ZmuGBjxpfuKTRqhdwNoAhLKJxD0KFB4IarzkYEqF8daqS0ZNXnjFPzMBk50rmIDbsE1ngu0YOX6OkONX7ySAU6LrROrw9uo6GSYsr0QYNqAgHioYZrWkTVFqaQ0laeQKSfG3sx1Q+rp22MkyQObx9F0Z1qgOtKy7TZOtPp4M5ILaszbk8uD4Czf/2igZ42dRhPwdwh0LfzG0NH9+PwYIjB6lnfcBpXX8e6tDdEehbzrPwEOq2ob/i+DDKq1KM3BIhUUaauYSAFYkYWXuB19hCPIllKnQhownNPrcV80XY2QLZzFau7Cq4Ymfk8/Rw3PDaO2dcwPzo1PB8MrxpXkU+J+crPd5kkbI51SE3MQDRuP0CcsH4Vxtjku2iUQDfeIhXxha/zQcLJYW1bPAbX1I8CB08O/f5w9HYTA0dhVPC2zbTnJuzHMU4sn51tkC1MGwPTMo/nI9+bRWt9TQUoMSz33GGl/Er7bDI4eXd793UbkqgK+mCLeEirjZwi4cYnsEEP9GDwXGjCp2whRQU/GtvNCeGEKPGav+qFYzbdA71Mn4UMvOsIlIAFvGGMlx0cxfWyP6hEAIbszq8fCz+t7vMokPv/oIR0wJ40ZEEYtK9ww7K9HcjJ+nPhHwgimBBpha5W/R3h2Bu3mG0rAnvkXUHGsOZMHSwX90n8BmByRus6DVX1vhdD4+y5xxE6MQqgSACzXWqH9MC9z2hqG9LDkern4oTf9u0c0vaeTB+lh75oxV5XlqjCW9kSymLn
 sh0JIny/
 9vvgvGCH39qQxIKfrR2PYxsojuaERBptyzVmKW1Wp2BGVlu2tpMTyh4ItAs25i/9IUS43qS6LDchYVbofNAmV62B0JuaEHzsSyw/fKUdXzD8HMGUki9pclS1BXnH4NMS203iafywcVZ0aj1EsPHrjC5jrvuOTcZYdnW4glMOhGgkZmOiWOH/M7o46mbqi/+ocZX8wKE/tn6v3hCWAr4gSG4UKNvY/mTYzgvYmiXopFFXtlSIkDR84n4geX1xjiVr/0n4k+Zv65EKtwVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 9:52=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> I'm not sure if I'm understanding you correctly; but yes,
> __vma_enter_locked() waits for all the waiters to drop their
> "refcounts". (It's not really a refcount, you can also think of it as
> a sleepable read-write lock where the low bits are the number of
> readers.)

Sorry, that's not entirely true, since an attached VMA has a refcount
elevated by one. It's kind of a refcount, and kind of forms part of a
sleepable read-write lock, it's complicated.

