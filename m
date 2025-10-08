Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEE51CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 17:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A41FC8E000B; Wed,  8 Oct 2025 13:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1CD8E0002; Wed,  8 Oct 2025 13:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E1AC8E000B; Wed,  8 Oct 2025 13:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 789858E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:59:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECA1588128
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:59:43 +0000 (UTC)
X-FDA: 83975709846.15.676A59C
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0BE7918000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:59:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3jzRWUc;
	spf=pass (imf24.hostedemail.com: domain of vpetrucci@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vpetrucci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759946382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W4KMzvetLm4Fr+s7TfComD4+hPnzZgOsbtBlAc/YQSE=;
	b=wf2wr58u1ACXeRFWyI+XCsM8nuh1hxxJAoK53menBbGM8qdO5BzGGBVL1kpBFzt4j+BKWu
	2o706Sp+M93V5wmepe6AWHR7n7LT255JdXMYhaT6QXaTEa0n6dXmNBZHpuz5/pJhZm3cBX
	S91zzRYpnLtpnl/6S05BYhC1OI1bDoo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D3jzRWUc;
	spf=pass (imf24.hostedemail.com: domain of vpetrucci@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=vpetrucci@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759946382; a=rsa-sha256;
	cv=none;
	b=0GmsjwHfXlhiHOvoX8dFd9EqO6AgpwMGysJ0BzcyIHj4vqchl9tNYUFQYqXDhwT/hyYmgP
	BRaCvjKgL3SSRh6iOhyTU6SSi9G0JA3Gv2Kg2bDm2ntRmViRL2Qyap6hTGNvNFm6HzGFru
	42+DajekfjJO+OEeMaZ9EjJHKSXjtPM=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-46e37d6c21eso928125e9.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 10:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759946380; x=1760551180; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W4KMzvetLm4Fr+s7TfComD4+hPnzZgOsbtBlAc/YQSE=;
        b=D3jzRWUcK1LfnpPTpbywPK3ZKpRQibF0BcT1UgldSV5eu8nKG7u1a7eX0XxaaTBHZ2
         izzenzHjDIGWXs5YSXK1ZGSd6EMvwVZF4LIOmYm3yx5eYvX+BozV2RMTL4r06KbQgySj
         bkAAm0YaQSxOAhLSEA6sB1nxQnWmPWn7dn++8XUhIUP9SEiW5u0VPoizymj8AEqp6pYo
         F+Y45lHrP+l4Z9+q2ksfQ8D7IQmCSiUwkQHTIB23vtb6wZ+zwtMRPbrEpNfK0IW98JgS
         Nbe+SD5h3SUewr793Dup+qEv8gBgjK/q1Cq9jqTCrAdu2wvcx8UOTBXHKkB9kYKVShzV
         n0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759946380; x=1760551180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W4KMzvetLm4Fr+s7TfComD4+hPnzZgOsbtBlAc/YQSE=;
        b=vePobQeDFd59HQKzuUzHwSOIYBCMWbzU5v7nAQTTB0x+GPAr91dbbnKtAn1IRyLiP1
         HIik2SkswdUtL4DLiqHb7Bcq3CEetEpGCBw0AioT0pdOc89rNUW+4w5MGRlGuosid4ph
         NjhTqQJL525C3oSxMOoAL+1k8z2skYojVvNAYuOaKKNX9RbtfyoH0HtFwfn5afEaGysL
         XUAUPJ8pkbac9fIo8RSZ/Fl0nnaqfRrnUXSckeFf+gIwNXBE2NmCHNSgzzJOj6XIB7/Y
         MeKsmS1qzjjahXWxpUfTC3qBI55Bbfb30jfVA77tETwXU0IVADYnllghqdymFRpK0PiU
         FpZA==
X-Forwarded-Encrypted: i=1; AJvYcCW+6YlK2sxu+jx7Zjb3JvxPy0nX1deUlMXhTBw0t2mkpWs3z5nPieHCiA/E4kUXSt2q5tmGvUXrcg==@kvack.org
X-Gm-Message-State: AOJu0YzcMxQ2ewPw7b70GMl2cNjPgTc+pU7x/eT8AAFob0JMIeYmLSls
	x/EXNSTjvHkn4HXk+AB0hBZiL5jLRT7Lmg4ewmtVMTorWm3bdBb50Q9wT82SxcplVH0ld5GdB0A
	lm7mSCv8Fw5iBA4itNtmzxhfYmegO5OM=
X-Gm-Gg: ASbGncsCa3BoXrvbrFXwAvPyfyTdqkfVE/viiqGiaH0WPuU84Ge8MzTPRnu+1D4OWXw
	8GVakGMB7dmlST6A0mw00BnR95RrybzeV7mHoPhszEEIkPuZqKEuqfnbhL7U61UA1ZTQwDpqj1o
	o0pH9EGiZLLnavSUxvRCvzFhZIr9IhxDQ338yWR/wjoZqtQ+NWHb/3+M69Z7hJVQ0evHnFVYU8Z
	SI8mHPcuUJ6jUUwhJnvgBNqb6dqjkMVJ7dmbYVS5g==
X-Google-Smtp-Source: AGHT+IHtL0KOVOKNLlIeSlInpWJTE/TPrTabMwA574I5VxH1lyBXgMOecBg0iKJOGtptnGSTnD9bSOmqK3DPheF4dX8=
X-Received: by 2002:a05:6000:2681:b0:425:7153:80af with SMTP id
 ffacd0b85a97d-4266e8dab65mr2663968f8f.49.1759946379883; Wed, 08 Oct 2025
 10:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250910144653.212066-1-bharata@amd.com> <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F> <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
In-Reply-To: <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
From: Vinicius Petrucci <vpetrucci@gmail.com>
Date: Wed, 8 Oct 2025 10:59:01 -0700
X-Gm-Features: AS18NWANBul6dbj_HkmY5fIi05_D6Oecvga0iBOa6pPxhI_sCfcpoYxSf9FgW9E
Message-ID: <CAEZ6=UOXG2Ju9P4-gYKnzZeyV2PAQoCA70QtmxEBJ-Dqc=0tdA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion infrastructure
To: David Rientjes <rientjes@google.com>
Cc: Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>, 
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com, hannes@cmpxchg.org, 
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org, 
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, 
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com, 
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com, 
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com, 
	balbirs@nvidia.com, alok.rathore@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: y4nyz9sg1tpohtkme561qbk9qsdm756r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0BE7918000E
X-HE-Tag: 1759946381-815964
X-HE-Meta: U2FsdGVkX1/SUMSJNZiRwXoxcISUf+ud2P3zFCWfY54pzQDwtllR4enLDg1zIW+BdfGetFDLbxhW227zqmPPcdzjY/0M+pETG0VqinFlXsTIwuuVQG5Mu18AOF/HOFp4BhKRfFOCa7LwrhQhG+m+B1e2IO/VtB4ln4Z4CW0yovxKv7NARSwIZusr5b5FZQjv3ZMMwvvriT264khcC19m5A+lC7YLN2jY9ynFu26orfwkjy/A/deqfTfBiIVHvNDOQt8ApyA04QObkjKcks26jPQLm4iE2vUgV3kOQzlmFZ+On2wpcePpwzepT+0zg37SF3QsP8QfQVT3QL1WAInHLS9UYzUT3MdmkOZzSOfAN4Yynx4gHBPXxBlQQwOd1WNCkhTinfKgyCFSg8CAkGTG29jte45m61o7FmiAHeoD1XZUuF9YlZLRbcwzADoIy/2+SeQBYEK4CHhkyesCd1/5bKBOoCPvrUKizS07H+umMWYhWiyoneM/TqkXII4eRy88VhDc5DVVE3edRjgpSFuGD0hH9m3vrV6XqVCyMEVBHFhX+cyYVR/2onDENYus+b4ZgsRv5QBEF7hmxbKK4lIbGM5TCaofYn/t1t+9RRJPuvgcqlPgyAd4d/BZUIFtHiefWhmfkNVklkxdeVYkdbuH80d6JEJ2EkM+zX/ORY4P8D2CRPsrnnbGvEQ0AnxaO7f8XN2eBSxVTUpFFcWofnOvHGe/Cx54jc4dIAwgZmhLZ7nm48qhxnxEYZTFJaDVp7+kOl8mh3RZ1u3sekxLmcNP8wnCEOh5XYc2lEqJXP33XJdTkSU0/+JtGamWkbO/ASaWQW4+CzSrsuAcWFe7OPUuSroZfIvyvl8YkAqcxpD10rIHyFwL4kwEO+43IMfcHJhLAcGS0mcKfoXANjZvSZQJQoceVd4WiEF7t6edOtoTXS/EsN8VFPQTS3KSg8VvtCIPB6vdb79qiXMyzMWxXKQ
 ACsFz2xp
 MWuwTS/UC23UcOEYV2RrhlZrQ7HFck1u2PpmA30g/5NPr5lvIGdD1gWGf9c9z4x96zvn2E32iDD919x7Bg7t+d4xdrsDXxWuWINGCcrNSG5be16kYgGKpeBuJplC2StNSwhq7gDQTZTrE/AQkYAPCKZnMjWG7z7yT7hZ4m0cjLLY/WSTL4nHQKuJEKe11eLPcXFtuTqeV9PihThiNDghqVk+5e+OoSwqneEi2C4YUZGZk2SakzTsjMdGl7sYH25ie1NiqlRK6vkzJjQ5WT590exgeqK9jPmdB39XnXB49Vrg6oxqMOsCNctR2c7AI6t0TT988UHch1l5CkA+6IV0cUImwmBzU2duGeYIUJ7E8ine+i4CproCYmyYUN8JQl3JZdQB/P1ohVI9amK7FaddrTmJf37YIw5WGXpGeDkVSBNVRB1mfGKcBIZFH+lkRFL1Hsvqvq5cz7Dcu7WtM28Qnqu+LQD/tME7M5F4S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Tue, Sep 16, 2025 at 1:28=E2=80=AFPM David Rientjes <rientjes@google.com=
> wrote:
>
> I've been pretty focused on the promotion story here rather than demotion
> because of how responsive it needs to be.  Harvesting the page table
> accessed bits or waiting on a sliding window through NUMA Balancing (even
> NUMAB=3D2) is not as responsive as needed for very fast promotion to top
> tier memory, hence things like the CHMU (or PEBS or IBS etc).

First, thanks for sharing your thoughts on the promotion
responsiveness challenges, definitely a critical aspect for tiering
strategies.

We recently put together a preliminary report using our experimental
HW that I believe could be relevant to the ongoing discussions:
A Limits Study of Memory-side Tiering Telemetry:
https://arxiv.org/abs/2508.09351

It's essentially an initial step toward quantifying the benefits of
HMU on the memory side, aiming to compare promotion quality (e.g.,
hotness coverage and accuracy) across HMU, PEBS-based promotion, and
NUMA balancing (promotion path).
Hopefully, this kind of work can help us better understand some of the
trade-offs being discussed, support more data-driven comparisons, and
spark more fruitful discussions...

Best,
Vinicius

