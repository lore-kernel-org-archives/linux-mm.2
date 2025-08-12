Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FE2C87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1799690000F; Tue, 12 Aug 2025 13:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A128E0151; Tue, 12 Aug 2025 13:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0871790000F; Tue, 12 Aug 2025 13:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF93D8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:58:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6310E14014A
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:58:53 +0000 (UTC)
X-FDA: 83768866146.08.CEA2CCE
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 54BDC4000D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:58:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVaDFvjS;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFgqOdxV1F9ejz004iGryJ3qWW5B6GXnUjljpVgqkLk=;
	b=j4MwZcig0sO5bEmZQwxMTga5B/gLynt5rKERvnFXLEsZSzVw+HQn1OaF6513M+JqaHfGdw
	pkVyRm8AuvrXBuaimv1hTPjxlKURQVRK1VT80Tt+/fhaS/CN8sJbpdJC40c0htVEENrC8P
	QiVRX+uxdErF7cBvl4cZ4zQfvQ4Rp94=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVaDFvjS;
	spf=pass (imf17.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021531; a=rsa-sha256;
	cv=none;
	b=0ERPC8JxGB2dlTJUc3lpxtfBU9UebMqPoMcNq0jqF60E8OvtiZnwOq/nMANScp4tp1ngRP
	Uvef/bRjtJcfvi/TNGX4LCCPFtuBZg5IZ3w56HfdLv6VRCNXnHmn7CAJof5L43ZWfFGbLe
	jn7TdvGtPyW9/O/Z4GmH9kw+6gjXDAE=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-459d40d16bdso37406435e9.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 10:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755021530; x=1755626330; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qFgqOdxV1F9ejz004iGryJ3qWW5B6GXnUjljpVgqkLk=;
        b=cVaDFvjS2ZJuxuPW6L4mL7tBAtce6RgYpB0qMAgaX4xJDr9ZVsOWBf5L3SljzFeb9R
         2PK4zKI22A7JG4mBYUv0mJ95Jd/U6w8Gy+QkNWst9uMF/rWQiMydGJv6vVzWrZHga/N9
         3M+1UUUjZmhbb9GogYgB9dbGjVxEoCHXJPz5XuO29ExKad14nNlKgJ0WHoAdf1kIE++I
         Ykwa1kjScAjfP4PJVNanLj+8NgdKJ8I+UrTlSiP0p5kSpFKA/PGzICONeIuLdA4WNWhM
         LrZNwtpNDdTnhHhJEiIF2/KqGkbcXgGX/XgyZrqewfO8UXAkyNHaOv+xd8/CRgHjHkKp
         Cakw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755021530; x=1755626330;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFgqOdxV1F9ejz004iGryJ3qWW5B6GXnUjljpVgqkLk=;
        b=NaSkd8tEbkAY2toNCCmH1ykbdvFG+uoxUNHvkW6/Zi27wn7KaG7rUFJqDn9mvPKKuU
         IljwHHWiP/MjxGvci6FaybpTPgu8txhTg5knC3T1SApT5dRdNTWxJnv2Cd/IfwJyVKL3
         r4Jq/a9qAKLuVICDNaTki9qPyB9Q4D+aXcKNcRtFQLF16L8sEM6Q3Fs5mNlRhl2HBPmS
         24bkY9E+DleQSuDdZx0VoBJ7AxUz48YPHCqpnuO5weE4Ctg0Nvwtd1WcnigOtQVJ23Bl
         NbNQXhg8ZVhgYtKRpBCi+mvC57vwecP+KS7U9D1L246cvth46ZW1Z5coFEIyG5+m1PGo
         HJjg==
X-Forwarded-Encrypted: i=1; AJvYcCWVzVp2iia9u7YTEQo6BbNp92OWIXXEG5z6TgZy6HEyMnnJsuGWDEifpenfg/d0QjVLztnlsY2ljQ==@kvack.org
X-Gm-Message-State: AOJu0YxoHSAJJ4Fel2135s0GRaQh5jl2N5ZH02rqXHr0uVm+GE3OBMNl
	VFHesy1VRnCUUGZergCuQ04i+hXb1kArZGQCINT4Smqfz1WU80eAwUkbqFuAUm7+cTzEuDaTKnI
	qBMu5HgQ3B1CBph/thN4dbapRr6qviPI=
X-Gm-Gg: ASbGnct4d6xZXN72L9t24WVK1nvCfLqwuvqI0WLXvG7+UN9nBaJFN6nWc9pKehbgT0D
	Y3yiVZVhNaXIKJYrptc88ZlWy0XFSAf2E93dHS10bs9LcdjJVPGueOQDF/6XAWrWrfWkYSXatNV
	ZrRZLRaU3ieiR9lv2K9GlegUfBpxsmY8kOaDfy0ggxRPQodsLivvLIeb9rzJeDwZHUpBLk5K9WV
	ueh3hLXfw==
X-Google-Smtp-Source: AGHT+IGCSqi+u7zPAKJbXiVle6HBw4vaddTrUBJW1UYwaHGnh/4m0lYlidEl1hsmzcOBFaEBgHl1CB3LcKFa24raxFg=
X-Received: by 2002:a05:600c:1c01:b0:458:bbed:a827 with SMTP id
 5b1f17b1804b1-45a165b7b15mr660355e9.1.1755021529570; Tue, 12 Aug 2025
 10:58:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250811173626.1878783-1-yeoreum.yun@arm.com> <20250811173626.1878783-3-yeoreum.yun@arm.com>
 <CA+fCnZeSV4fDBQr-WPFA66OYxN8zOQ2g1RQMDW3Ok8FaE7=NXQ@mail.gmail.com> <aJtyR3hCW5fG+niV@e129823.arm.com>
In-Reply-To: <aJtyR3hCW5fG+niV@e129823.arm.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 12 Aug 2025 19:58:37 +0200
X-Gm-Features: Ac12FXy555KMqM9sRgAgjXOVEGNZdNcePtQ9D4aII7b1VUPGHKMWOpB_9plVIlw
Message-ID: <CA+fCnZeznLqoLsUOgB1a1TNpR9PxjZKrrVBhotpMh0KVwvzj_Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] kasan: apply store-only mode in kasan kunit testcases
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
X-Rspamd-Queue-Id: 54BDC4000D
X-Rspam-User: 
X-Stat-Signature: qb1cwkw46muggowtuz5dmgkgpydpgnaw
X-Rspamd-Server: rspam09
X-HE-Tag: 1755021531-219040
X-HE-Meta: U2FsdGVkX19r66NN5oCKqETbqyV2PCmpQvhiAqLAKXt36UrUxy9W2Zz6iOVmRyRmnPa6whd1BR3zRFdx0sE5pCCA44PUMgCfTIIrKCeas+RB6/XjI2TnGYppviWicQOFJk5CoFNFyI0BLlIgcwEvqSkCnMtn57xHX5qPtsocuS23x78lLRSEbp5CmXLQg1tprqdVoeXnqp04OHK6jJmnZ2EGBufnqgnV9ks5K+lmhtudgkwzzA6EXawfQZD9yHG766facuzUGBqyM2jWRpjMhvgNou2bXusBrNVS+WG8Dnw9vecKlF6qJSVotwjXAy9AEhQjJlmb13OTPLRH1UL/SRcBSvbEhXQ+Q9VPKF4UOHsjuqBTXKZC+SDcX1p83BykKASqivOgcNmtiMQwxCS2P2nA84yv6dICpnAjgjjxikYomvnyOI5vsjo8yfaf7Q0+9trPm35CJIAOFSAx8VFcbTcRQ/AKAtwPwuko6cwSgC0E21U+2IcuCMkmJEvL1cQX8FWN7OAYiqk7C3GC1uwcq8A+v4MBkHj3zn4InESNhcZvKv9GY1nUHMroIb03YEBZV03U4IYo9GIg1vVN4Qk7I2VuaC0Lo/jmI+HykABWTIi3Whj94uFtaEa81LyuaNZStRd76Paat5L3/Z6LDnv8haxU01H95YcJ/11ubQIFc/vab0WSjKXlNFGDMitWqhRJd6Dth5kozNFNmR+Hp0nrHQWaSLI30yFT0aSy/n/oJYIgtJyetoQScxCcr2v06NjbQ2RcBdTh8lKr3BO7npiwUQn2NqLzG/6yi9XLPK+9jfFapS7aBuKfOXiBF6MZzzMZiGlsKE73vHt5vCvRSO2kCzEVE166F4Pj4/57gT1DyEhfhWboZDHnNCx6fQPdmnk9MJxnq5nksE71o5iA+sgLEpp/M/RnkFpXcNkPkSkqQ/W73WYJXut1qX+XvXWYPdZOQT0sK9AdDwN114ijOFG
 9hcM6GKp
 5e8elpeodcrQA6lTpKwwDkIbunzweeO9Dgb12bvr9bzHKBHius1MtOJ0jJQlTN7+rSKmEwrYSWCDh0yCsGp+3eEjRw1RkaU0fY/ntI+1SFX4s1G6ws1X6s/4bHENjepbxjtG1WafezgJUqxJFRIa6hlyEihGwvmC/CVvcVn50t+aB7pDip1t/mL8qrQO6GLE5nZA7es1SJh445cM4Sc6Ra5EjxiSDLLTLxOdH09mtle9AlQWiiaQYZW9nQwaFBY6Uh+RSmY27gZiPRTUpT8NVd5kj3v7dZjG6XXw03nEQ45/eojWYn6q8GKIboBMlgXPDV9OFiSqM3g9LjIOrghrqJiwLsp6iYkt4wriTR4HLANFRtvYX2C3X5CY6cjmpFDRHoFwhEWUrWXWyl9WFsr/7rLCoyPfuO2qZ+NZN4RMxegonTYoSXagAe2DND14DMKUrvbExa3QuywCFiHKf6GHdb0CdcYB/334GG5DYSbwhv1fokDFipiwLIuTHGGhIaEmIxfce
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 6:57=E2=80=AFPM Yeoreum Yun <yeoreum.yun@arm.com> w=
rote:
>
> > Right now, KASAN tests are crafted to avoid/self-contain harmful
> > memory corruptions that they do (e.g. make sure that OOB write
> > accesses land in in-object kmalloc training space, etc.). If you turn
> > read accesses in tests into write accesses, memory corruptions caused
> > by the earlier tests will crash the kernel or the latter tests.
>
> That's why I run the store-only test when this mode is "sync"
> In case of "async/asymm" as you mention since it reports "after",
> there will be memory corruption.
>
> But in case of sync, when the MTE fault happens, it doesn't
> write to memory so, I think it's fine.

Does it not? I thought MTE gets disabled and we return from the fault
handler and let the write instruction execute. But my memory on this
is foggy. And I don't have a setup right now to test.

