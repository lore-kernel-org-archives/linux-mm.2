Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D0FCCD19F
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 17:13:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD8B8E000C; Mon, 20 Oct 2025 13:13:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84F28E0002; Mon, 20 Oct 2025 13:13:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C17E8E000C; Mon, 20 Oct 2025 13:13:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B84E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:13:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 34465140259
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:13:22 +0000 (UTC)
X-FDA: 84019138644.22.A080704
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 487A5C0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:13:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JRI0Y+FU;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760980400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RGI6Q7BTAs/HMJAhH5ug/+5JV+NNvoV5bQjyt72+yc0=;
	b=B7Re7ucofe11AAOiVuu6wz+I3PxyOtY5QivtQQt6eRaZs2tsbAKseDpvIaVrNmIgIvIJZh
	e/50eJFsMlGrUuZRSJmZWhdrcMyF/Mm6kbEZ61o48gX/Om6/DyLy+dIXBUbtfrkg91LCcz
	mid/uw+c6fqZYkh8HtVppwxjYiUwbLw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JRI0Y+FU;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760980400; a=rsa-sha256;
	cv=none;
	b=F0O70tiOY3PZy7IKjiCpfVT7qQEKRkPSLv396UqK9/KVpClCQu0ihYrLLlHv0yDUlUfgaz
	fS3t0cf2CiKOhI02UTh85lV06uipQ3WC5xOaGMlnXttcnahYmrFQsivR1LREmmrsT5bWQR
	OOZpqdKSUcwdfjX255DTvnCo3vVAUL8=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-426fc536b5dso2486130f8f.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760980398; x=1761585198; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGI6Q7BTAs/HMJAhH5ug/+5JV+NNvoV5bQjyt72+yc0=;
        b=JRI0Y+FUJMO68IJ3ZMLsWc2RjGY3g+x3ADNfsCPHhJmB56pDGSGDfk88M9g/QJN1it
         5n/X0fhfAM5vkUh0kkVb5blYzIi2TgshXjHL8NcdlaX04giYNsG+S49KvKClfLd4C8cA
         lhZMKbJYwkwdkwZiou+0ykwCmqW//Jk41SFJhmF88BV8P+e0aRcrZOyni/Ppqb06mRF0
         hPACZ+DkTY9E2pE36Y40GCX8I8ZjrAiKonwYwP1sCinVXS6jvZaO2r5xkkEJq5Bt+enQ
         uG2y2Zuzfj8S78ChGMa7NrZtZFJ1wvrn+dZY1Wz3xUzWf9Hl0SM/Fn6rASjuOu1lWWuy
         vc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760980398; x=1761585198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGI6Q7BTAs/HMJAhH5ug/+5JV+NNvoV5bQjyt72+yc0=;
        b=onGR2Qae3Pala5EA19/VbY8JB5MLc1BDwac7ujLLeiAlRkv6eYV6jY2p6LQ/Mnf3Ly
         Rg2OREC+V6OgW/hsgJZ68t7HRctprLatVR+U8NAjZ54gUfKTnBcKvyV+USFyDvflcLYv
         o6XkaAXe1E0N36fduA+/xcdzVyzFeiqyPvSDpqB+kSFb/hN8m/inFlL0kDzyOyLjOLZE
         ZbZl9XRySnUj/ADiYrAowi5uyNTx0z8bG9+i1T13je0SAY1XCGdED7WNp+ED46IIK668
         m2jvfvdKfmaUiiaAYm9uRRQxx9Sx7ckhsiFxGJ9tD7wtFFLMoQ+YpI+qmqgrYOunJ6tE
         r/wA==
X-Forwarded-Encrypted: i=1; AJvYcCX29VFWSrsl5RxZVKYUN036pUa4iv1ugnffcQX6ru5mRV4zMGW89MsePVNC0aJ1bGy8ZbjXqAEtPA==@kvack.org
X-Gm-Message-State: AOJu0Ywp4cIS5nZH6htjNc7+ZA89nYluboVmdVjIL77wX/xHHQMbCFMO
	PXCAps38qJ/zt34RpukbuCOv/k+bnKfbaBlUIToHxBcicSTnnJchr14pTzx0E60DMm1U9h7DYiW
	PZwFd07sjrNErkYcsKkQfTGrlR4NpWkg=
X-Gm-Gg: ASbGncvs6aEY6jwje9KtF/LJc6SMgNQeQHAHmlsKxbErEbIQZzJDJeu3iWNwd7BZT/a
	ToGBao73tIYPR1I/4mwlA0CgYtfbsDbdBG2t0CX4M3VtmqciS9P23liGqFJcTt2+QKmp7bYW+j9
	gnbs6hnTp4j53rwcnPZSrVlmjixSzIsmCG2HFMVKsvoPEk/2CSmmAGuUVA8x11bmzrBtw5bGtgY
	wQAhEP6A9Gye8sZGIahJ1P92LfY6w/r1tkiWhjJ0h38+SYomR4rMey+FQ==
X-Google-Smtp-Source: AGHT+IEodoyCQ4s3ezeiwvbSuedTGQrnQgPdmuDQggu8D72dLZWaeRuVepbyTu1eDOJWleQ/3mxUOhbhAORfmNTXRPQ=
X-Received: by 2002:a05:6000:2f84:b0:425:7179:16eb with SMTP id
 ffacd0b85a97d-42704d87ee4mr8625832f8f.17.1760980398375; Mon, 20 Oct 2025
 10:13:18 -0700 (PDT)
MIME-Version: 1.0
References: <20250929172724.75108-1-sj@kernel.org> <75584276-6d30-4e35-9e59-e084c60d1c5f@linuxfoundation.org>
In-Reply-To: <75584276-6d30-4e35-9e59-e084c60d1c5f@linuxfoundation.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 20 Oct 2025 10:13:07 -0700
X-Gm-Features: AS18NWD-XcABY9AYH26aivrP7s7U2VJn_xaY3Jej0bnRhuMSCHP69gzanE8702w
Message-ID: <CAKEwX=PBrcPnEkEhWQn_CTtT04qaKY2WsWXjDSSyPUGX4yY-sw@mail.gmail.com>
Subject: Re: [PATCH v1] selftests: cachestat: Fix warning on declaration under label
To: Shuah Khan <skhan@linuxfoundation.org>
Cc: hannes@cmpxchg.org, nathan@kernel.org, shuah@kernel.org, morbo@google.com, 
	justinstitt@google.com, nick.desaulniers+lkml@gmail.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, david.hunter.linux@gmail.com, 
	Sidharth Seela <sidharthseela@gmail.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 487A5C0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xrkzn7hp56bg8eyxkfuo4ispan4nm7st
X-HE-Tag: 1760980400-538638
X-HE-Meta: U2FsdGVkX196JluMIjDLcDYa5oQ/sNO94f2/9khtv72FH3SXqpCRnOk9O3xohEx8x59URDw5LDRrtKu6jCgt43+o7mqdfgbaVxmpYqqETJH4sDd+x5TUo+RSRVTue4pYnPoeTZ6n5eyTO90htMLTKLfYR/IBJGEHWOn0Bj6XciLbxSq9PJPIPLH3uM0i6TNMJL5lt1cg+2BOyfH7C7RDRq6V47VNBOjBneu1VNanpz6AsJqQBqQ10mQULC+uqKoitD2kzdq+WL2IvLC9EnC7jSyD3KsfUbCUGagbllDfn0kq1bvBfVlMtJM4vg5BgJYLZ1X0MDzN5c6gCztPCrClfwDO7aN68dc82MqpbYxnuui/PMae+TSPJw9aMcAusYW9xCZXu2V+ZUuh6Js7EfYYPDGL1+Xg9QcYJmnFOZPOrQkW2j0do44M1B/VbZE/7agpqrUkbqPpWD6YRJ0QJsPGTqg/v9MHKqTetMSSV9032pRisbSKuYO/TUGRLFxOYj1iaFFAQLF7VhrhSr1iadLmMARAX6M43Em3fuv5DDkdSzgu873pY/A8hlWkRF+Fx6vkfq5RBmUijjgvTjopPkTwxdveu2OauTxW+1U7u+YqfnsQlbNhUwi2GI/CZE7qAdakCgxXOoEKjOoGL+Oaj6rhBGbAKv+X6Mex+OWSFGRL6YM36izWI2343bDLcAjFPMMk4IoFc7prAh2RhKS9h2u/sUOXkICtHl+zbW6k+VCUCet6inEo9QkFMMotBX+lJqu3sQyGcileBZr+3Jk9be/st5wabvoEdvZ98ooGRIH2hLkcIiS0+lUN5rIdszPId63vl8Z7mjG5+S3W4MFBnjq+fYqMunYdeX7pUSzSPsYfhN82i9kHnze9CS6JHNpz3SrBmYkiK53W1E7PLKHQucc8nsyiGsHQTDb0EF8l4JPsOFON/SxyWn5o+UJut3RtkwEIOKBb1JBbeHECJaB5QQV
 /g18CQcR
 tF3RQMyJsThNwoAimE2A2doTkn6I8lxfDqbPDG/HmxRcfA4haWdiGxbBwQgd2v/qZ+Etn1u1DwFvxwxMdJjt4FIcDKKPesk4lSzt87PwLBUEQBmdUzFLcJt2mWG3s8NHM/j8Dr7xR0o/HOJQSJKt2Gz3mmVUKb/v1lr2lKzS2KECpjvjtqFP4TDG1BMxy0S8YpEzD77nsgQVL2hksxk6fmat8bZLdH+X3SuusNL+smeG9cvUz+3h5ukeBO+8/MWBuIKOBV5OrUDm/pUkPNpKFtrdBeNnXzSSEl72iB0VKiNw2oLV8+TqfMPqX4BAdT0zkAl2K0Fp0X8Vi5Ata3HPeecOEKEraAjJGVQiJxeragyTwWGz8ayAChDUnA0tay/sfzGRcC+rknXzmFX808W2Gkj3SCjEKDvXSALVN7RroqTbsK1v9iB0GSge0qOwYmU1TmRtqm81U12gErB/68h/4uXNPSIb+njvp/cY5YoGtBeSFNvZ0IjByYmDaK2H+jQ/0QyskYLBhRyhIiVs4XW/cRFp7pfV04PvaC1H+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 1:07=E2=80=AFPM Shuah Khan <skhan@linuxfoundation.o=
rg> wrote:
>
> On 9/29/25 11:27, SeongJae Park wrote:
> > On Mon, 29 Sep 2025 17:24:06 +0530 Sidharth Seela <sidharthseela@gmail.=
com> wrote:
> >
> >> Fix warning caused from declaration under a case label. The proper way
> >> is to declare variable at the beginning of the function. The warning
> >> came from running clang using LLVM=3D1; and is as follows:
> >> --
> >> -test_cachestat.c:260:3: warning: label followed by a declaration is a=
 C23 extension [-Wc23-extensions]
> >>    260 |                 char *map =3D mmap(NULL, filesize, PROT_READ =
| PROT_WRITE,
> >>        |
> >>
> >> Signed-off-by: Sidharth Seela <sidharthseela@gmail.com>
> >
> > Reviewed-by: SeongJae Park <sj@kernel.org>
> >
> >
>
> Johannes and Nhat,
>
> Assuming this will go through cachestat tree
>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
>

Hi Shuah.

LGTM:
Acked-by: Nhat Pham <nphamcs@gmail.com>

