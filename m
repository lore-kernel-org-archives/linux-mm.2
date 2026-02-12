Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD670EDF021
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 03:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1823B6B0005; Wed, 11 Feb 2026 22:11:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130D76B0089; Wed, 11 Feb 2026 22:11:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1CDF6B008A; Wed, 11 Feb 2026 22:11:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFCA16B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 22:11:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 857DAB9D1E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:11:48 +0000 (UTC)
X-FDA: 84434329896.02.885624E
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 76B52C0002
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:11:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WKVj1PUp;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770865906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FFhGBD3AhdKqNrATKr4zHaapfoCV5LSiIWI9pbeugw4=;
	b=hggxrnzOb6qooPYpzZn3hthlkKMAjuN7VpbFRnEEFK67Xty0G6jnEmtYWsdkkyB3L99xPo
	0XC5GRCg8nXOc6c6IVdjS7zUvMWrkMHj/6+IHBfuPpPIrXORaw1k24FbdtunzsrKfRvOqy
	PVexVpoThpMJwSq9ZpbZUbRsDntDGMM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WKVj1PUp;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770865906; a=rsa-sha256;
	cv=pass;
	b=uCYrM2EBEIU3NNiKAcDd8M5DbrmMnoNTrQ4PXTkCrRsd8NiApYjnxfKT0GyvCEfdCyq5B/
	KW0A5z3pQ+ZPTAeBP1DhHsFy3r/HNvaybADHVc6mHmJYbef/nfJN+91XgOG3XIs9NnBG7m
	eURPcVFJhv2iqKS34V2StvplpoV/Nck=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4806b0963a9so26445e9.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:11:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770865905; cv=none;
        d=google.com; s=arc-20240605;
        b=O8id53QgqSicmvVo/GnH8NoTCAtedyg1cDjkW12/o6EGPmV9nd4gfRNgQjwSLFYaIZ
         aKvYUwij2T0xkXb9rP446uykDjEg4oMHUbbUGeJe5ynE6Wedc14I+3iDd8O7g2ZyOnqs
         JecWTkJZSivXWA6lW5ZRMiuetdPYn01vNTbcOnC3ebukpxClEWkGACX7/37V8VlJPIVg
         4ZsqHxwBLivggcdOH2N7FTFRoc+f/UKZ2oG+f2MEi6bXcwMJA6VPnx0/fQDyA7xwousc
         AaT7ZYP2D+/fD8W2keU+59ibw2Ldu9zccKlTs8iQg3yD1cStEW6V+rC4RcFzSsfx2R7u
         U1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FFhGBD3AhdKqNrATKr4zHaapfoCV5LSiIWI9pbeugw4=;
        fh=edh9kdJwehCF8q2IvYPVbBwvZcnxS5aIp9e6pgImWj8=;
        b=i3QsMHYh5Ukoo8zC4Es6BG/HQA7YPmDfBH6f8WitZ36o8cbkPe2EnR1T99pUIKRyO4
         X7jAuyex/MQNO7tZIcvXH2bt+0MAn91NuupH/zfeWF91LOs8Zs4ko2tMOsvOWX+XGWHB
         jSSuu+JwH1YU/pG4+WMfq/ceedOdawFipshjA55svyBqj2/4H7MERShBjZ+T46v5FMqA
         39LuaN63yNMEF+W/M8+8J30Ab07+hyMYZ7tkoBZpVyYARqqj4+NpBoelOQl+thvWZZyR
         cl7gtJIU2OjAO3NDZo8+Jz/bafeRQZKNeo+X0/lCt3rIdZIzWcqOdiIcI6Oz2mCjbAku
         hfQw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770865905; x=1771470705; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFhGBD3AhdKqNrATKr4zHaapfoCV5LSiIWI9pbeugw4=;
        b=WKVj1PUpb90UXMnJSHO5pUgSHEEgF9knv0uENf4CXJjS8RA4MXLwmrsnVMSBPcCXCO
         k8VrpJDTEEsq/wC9+/FWKhroHLLqvia8KjZnswSqkBdhueyFkm6lcQyvSWQgfD5ZVjC7
         FEW4FI6Cl0aDeqVFwiEFxFt5YTISJV+3E0rvnAX2JVPcMV95GOmYsAPL3XQZMkgn0ARe
         jx8Nt1C5qt6R1v7Kdzt5DRq9s6z4ujaldedTq9FPgb7nnfSTDOA1YBXaMuRQ5YncyUf3
         1LL6rfSUQfYqGZJACaHJmGqPwJUfdSOkHddPi1DkOLbYUnfxrC4/eylMbsxZF3MUern4
         LPxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770865905; x=1771470705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FFhGBD3AhdKqNrATKr4zHaapfoCV5LSiIWI9pbeugw4=;
        b=hj0/leO736kqJK27cy6MF6Vlg7/1gUBhPZTSQbq67auXzXBStlp2lOo7jmy3O4hmKn
         qXI3DAY3QtRaXnR2//XmofBl0AZMHBnyD3hAv//qYkaftTI69gUj+b7r87B9OTWkMCi+
         JmcV++1m8BOzS9a2s1YV64NwGsuyWrLPEOPyjcqO1wAucxoZ82jh4X218rnDqr0RFK0k
         +gY2dCnnMG1cc+G6/2F0k2XNZSytnQV73FiqlPeNQe2hyXomReCS4HLKt77MN8QqgF4B
         QQCxN3cLaidKl5QkPWb7lUKeTcrugOJ8CxMGdSuBh6CrfMUVU4NnmruXR9evxYt7EiHz
         G84A==
X-Forwarded-Encrypted: i=1; AJvYcCX4SIKebDory1Q22JESAG1Xa8kyVQH3Xxu7jM2wgGUUWL9I9/05aPm35KEKMwZYq2t18ohrp7j3hw==@kvack.org
X-Gm-Message-State: AOJu0YzMAHBCt3kU9GujAjMbN/FlxtfwwVLdCf5StaFWLub0yGMx9ZD/
	G4xusgujXtavvTOuYiFTZbfktivBiraYwLoDjt2lKWSB0GBscCq6DIky5efgVwfo90xeTOlyWbh
	skMcoze/MHTsUvmOXNfj0ifiurJa7uslp0d/2E3lW
X-Gm-Gg: AZuq6aLdJUcQuzw1cWKYVh5lJC6KVKZEDIIE0t+FXq34bW2+zvDQb6fVQGTXeBCEtVn
	XWHnmAMiWwc1wUB58lZrKMw9mAQMY5ilyC9SiIzG2n7zGcSnedtQ2qyB1VVAVq62vIleFBJOfs8
	qZCHLieFG++2WOvWmM3q5mo76UOE3VnMrnmDIE9QDOfgHbVd4q+TCJp67gB6se7YdFfFL+3OiAP
	RrI0U/9DUc3Ki8+ID2idOmAy10Xz3Z7x8QkhSJPY6YQuIDNJuITxviiTFANZQjsK6e/zibOakXL
	M3F3LSnyZCK3wOcfPl/cI1EqeUOYP/BhDZPkKZRt
X-Received: by 2002:a05:600c:5704:b0:477:76ea:ba7a with SMTP id
 5b1f17b1804b1-48366d4ce09mr192135e9.3.1770865904372; Wed, 11 Feb 2026
 19:11:44 -0800 (PST)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-3-jiaqiyan@google.com>
 <5c4927af-120e-4c6b-9473-95490f4fcc90@oracle.com>
In-Reply-To: <5c4927af-120e-4c6b-9473-95490f4fcc90@oracle.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Wed, 11 Feb 2026 19:11:33 -0800
X-Gm-Features: AZwV_Qi3lwPEjdm2Mw887DAZh3QRbXiCmUAvRWCHdZdEClqeZBM3MxkXXhz_C-k
Message-ID: <CACw3F51CdeGzTRgmFgoPA3GxnjUXHHhBkCj73pS+kEMhQ=XnNA@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] selftests/mm: test userspace MFR for HugeTLB hugepage
To: William Roche <william.roche@oracle.com>
Cc: linmiaohe@huawei.com, harry.yoo@oracle.com, jane.chu@oracle.com, 
	nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 76B52C0002
X-Stat-Signature: uinz7ck48dkuzgork3tg5ijzc7ba87si
X-Rspam-User: 
X-HE-Tag: 1770865906-940724
X-HE-Meta: U2FsdGVkX1+5bmHBY7TapKQ9R/kMHy1tRCMAe/g3TW+9+CXjrXftguidGvSyAfc6mnHPLBlZyV+eWQOgt1xI+/7yHML3RkDyNr8Jn5fQlg5YYfiqzefqKDM0OATfnCLKt2csWJi8wPmalGlSBxt0xwTPQ7ePJOLjs4exgv4IoA23uJCmGmaUSOEVzQS79mqYKSQigll3Z55zm+HWAqeoi7fbB+GVU0iDnPWRdCH6VCKfcsQgllg6QDMe5gAcqRsSfOUiDR1pQWQ4qn7+FKRgvz9OZAYMmxtMnAShC2NCtApOxakyXJnlLc4k8rmjyH+0d2IjBECXrDsVt94FC93beJSQSykM98bo2gHClRfOSkHkOA2McJ/ZuSavDagusrX8im3Td9JD/hXo2S6nsKnmUZr/DL2ue/NE8tkrBXrR6Owdp0l1e1BzaZl0xLmZ3CTrNzlQIyNvLluC9dEsF/6P84NijVM3XqD9FQ1u03SPkY139l4UnZKEOHn7GVqt5AH72ZtvyPpc6/eJnWabpcRuvqKgiwtd5cvtOTyOTjj1SA+RTc8pXFyMG947zrRWaIHiENqKkMfAl73BIVrRwZYXopoLQN1XzDJIuOVDl0qEhFOnbXU4wWR12zquaLqlO+S7E1YfUwmuCEFEq08230FxJI0dyZoTAYRAza01HBJz0Td4bY17pVx/V1eAd3c1UXStEvqm0WORUiG1rdpCrwXmUr33dCejfknXDsauThXLOuP+y0/xYKTR0qpae/tVEjIAXL5iS5NbIxSFcg/JNpJ+ohCPK9EgYvRZG3w7OrBKn/8PTHdMHVZlK1zixUCpt6Xy+tcar3h0HPZb79JgFnzfSKAAQu3BqVhY5zuHvQHH3RXGyVR289EzfqpvS+tM9YhbmWCs8LR/5hmn90zt0lhA491MZ4LkZ9vpJkVh8dRwm7vg5Jd8Ua4ByZJaPiaoo3nX2sFMp0YqCrF7keP5gep
 OGxyfFew
 xJYBCsLhdQwodiK/7M39L396nIviVb3EUXxQXOMe1SUrsyU2EkdqXCtXJsqdogzB0lrw5n2aO/e6CpptPBx/X7L/M/ELTKZ59wzR7drLUUsRHrJZRkbez8BwEY/df1PpQtJUfbPOelLEmLqBmBDlKqzleAdunVpXxhnYMIau2xFRirjCKeBGTjc7WtcjH8lWwS5PiMLLOgbBnsTc+5KwyzlcDLcBhLT/rO+V8IQIVG3o2qMRJ30t76tONoQOmdMXYLvUBGvKWRoOyKQySYnJF0nCAkUF9fcb7MScY7M9WKeH9yc9THtN4a1OMvKMy3hK0XUL49R1Cpl8IbAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 4, 2026 at 9:53=E2=80=AFAM William Roche <william.roche@oracle.=
com> wrote:
>
>
> On 2/3/26 20:23, Jiaqi Yan wrote:
> > Test the userspace memory failure recovery (MFR) policy for HugeTLB:
> >
> > 1. Create a memfd backed by HugeTLB and had MFD_MF_KEEP_UE_MAPPED set.
> >
> > 2. Allocate and map 4 hugepages to the process.
> >
> > 3. Create sub-threads to MADV_HWPOISON inner addresses of the 1st hugep=
age.
> >
> > 4. Check if the process gets correct SIGBUS for each poisoned raw page.
> >
> > 5. Check if all memory are still accessible and content valid.
> >
> > 6. Check if the poisoned hugepage is dealt with after memfd released.
> >
> > Two configurables in the test:
> >
> > - hugepage_size: size of the hugepage, 1G or 2M.
> >
> > - nr_hwp_pages: number of pages within the 1st hugepage to MADV_HWPOISO=
N.
> In this version, you are introducing this new test argument
> "nr_hwp_pages" to indicate how many of the pre-defined offsets we want
> to poison inside the hugepage (between 1 and 8).
> But is there any advantage to give the choice to the user instead of
> testing them all ?

Yeah, nr_hwp_pages doesn't seem very useful. It was useful when I want
the test to run in two modes: single page vs multple pages. Let me
just make the test to testing 8 pages.

>
> As a suggestion, should we have this test program setting or verifying
> the minimal number of hugepages of the right type, instead of relying on
> the user to set them manually ?

Yeah, I agree, we can just run for 2 different hugepagesize.

> And at the end, should we try to unpoison the impacted pages ? So that
> the lab machine where the tests run can continue to use all its memory ?

Good point, we can include this as a test cleanup step.

>
> Thanks for your feedback,
> William.
>

