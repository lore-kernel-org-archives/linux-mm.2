Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A803CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 04:55:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E4F6B002B; Wed, 20 Aug 2025 00:55:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FA06B00D6; Wed, 20 Aug 2025 00:55:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEF26B00D7; Wed, 20 Aug 2025 00:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC8636B00D5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 00:55:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 894BD1A038B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:55:38 +0000 (UTC)
X-FDA: 83795922756.02.F29C9DA
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9C3A8140009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:55:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HHcMRMXW;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755665736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a3QLAOJYZDBzu1Z4/ZnA/ZtodhCvpRb/hpriExXSF6o=;
	b=z/wGmBcpdAVRdczogdGLHN6qNe+Musmkevc6mQxqJO2Q/JLjdnIRcUocuzgtAjnyfhyLs9
	O58+Sl62PG8FiYtQ3F1jsmPWnTUnYv5fLWmbVWCW80AFf//jdTntSACgR/0gC5BPkdiBj5
	TF0Yo0UQqSPgBLscfPmh23f0Ft+PrII=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HHcMRMXW;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755665736; a=rsa-sha256;
	cv=none;
	b=iOxkvJcblEO96/KbCezWIeQ2GENK3hSsOnpwro5MvYjOn4TLeI0CFJ0fMSfrl74UIzyeqy
	8YBelD8YjIPjaZ48NJxHJHK2O2Ik2Cuyk6c82mYPqPQgWz1biIMsGcDZpCTAibWy3PQK3T
	X+RgZRtUDcjYium5opxwgsIG/HlffxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 951595C62E5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19F8C19421
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755665734;
	bh=8/ecel6coNf4uRcsoSjGxroeWHJANhH34L20ONLZsCk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HHcMRMXW09/ZHyIxyuflpZFRa/kqPw11/gYcz4wcRrp5d1E6ukRIcnY/W1BOTf4Ts
	 R00ZicZxyE548miv72/wSIom/Auvros2Xcrb8smZqQ8d9wRQGQXz18FWSTavAeLN24
	 UcwI/UhOuTfpdg6MhNm4mtBjpZA4i5UN7C+5N4ljAhD/PWp5w1mBuNG4mAyClzh/fU
	 WfBgABzKtakxQGQjWdBTogrmZprn1NyYFkSMnyOG47FrZuCbomnCut+hFktcnSpYUw
	 ZBo04sgSDDzYQ7nrMthHMjq+w2mZWBSknCEwZXeVZAYc97H1OMnhXjOi6PcO5FE0UK
	 BwIh60gamPclQ==
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-459fc675d11so28285e9.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:55:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUCMXdSv2mqZPi0Wa2mFzvvvJPDdqN8eGOMqZd9ICXGf8DGxG65zBlrPYYsE/oHKjOUD/zas293Kg==@kvack.org
X-Gm-Message-State: AOJu0YzQYpwB1E1G6GfblSN3nkeu+KolV+cO1AJ5vdxfD9vceXyc2GCO
	52z7+xSR2xncDUubYzIos2X7HQ8oCDKSeXu2ynPtU5r/4MmLYiko+pDF8JdJpf1Wdsk8o501SS0
	OnrziiNWskXNcIF1v0uQuhN1ulXQ+QIibT4R4xa2X
X-Google-Smtp-Source: AGHT+IH024zqFBB0pYMG9UnGJoj/rOLVe3ZmOB5UPOMDvOAWoOoyAtRYfd2BCsDsJM3UbRe0N84oso0UFp3FJ7C0dAc=
X-Received: by 2002:a05:600c:46d3:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-45b47743f88mr1123885e9.2.1755665733534; Tue, 19 Aug 2025
 21:55:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250819193404.46680-1-sj@kernel.org> <CAGsJ_4ygTv1tCJeuF43NhRR4E0kiMLpk6i8c+UHoUMt6LXykww@mail.gmail.com>
 <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
In-Reply-To: <aKUi7hvcaK0h0oMg@gondor.apana.org.au>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 19 Aug 2025 21:55:22 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMepN=-HPp3xqvzNxfrtHZp_2DwLp-b=rMRpsJ=mgKSJw@mail.gmail.com>
X-Gm-Features: Ac12FXwHHeNsRxjdjpScCgLpGAs7xED92MNZ42-dt7hDOrZgQ0ynOsyqaYsS7XQ
Message-ID: <CAF8kJuMepN=-HPp3xqvzNxfrtHZp_2DwLp-b=rMRpsJ=mgKSJw@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Barry Song <21cnbao@gmail.com>, SeongJae Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9C3A8140009
X-Stat-Signature: f6iq6d4e44z3jgopito67edj7nqmdun6
X-Rspam-User: 
X-HE-Tag: 1755665736-803549
X-HE-Meta: U2FsdGVkX19NVSCtUUSmq61oGl1VKa42k++7BJcejogSyX0hBvk/0eTKiynV+p+rHpttDA0C9Oh0ap4OgO9r66VCwgtrd3TrHujezoVOcXJrtM6h/8N3c7+AxvJSbnz0ZHYuRVqkp/jeN8AWTwcHpRDEAalbWjguYSaszAC9t2QoVy7pUIrDmUREg9apn8AVYOFNTOWEDJGt3ZqTHnlM127Tnol094AdpAJLpPjB66gYqG8/aKpdApBuuXbjBdxbR8wMw+o02jvWUMNqnjzMsI3kC0hjko2KfxT7qGE/ySaLQuSfIiRW1vO778jmFjtKYObMlLfnc8xm8LtTtj2iUUedvYnNCdguEAMGUYfSjERuAKwOb06CGKd9jarK5nWuqcoCSqdZzNaijEpuncaspLEJW7yA9JNaB41fQAhsMfmhz3EXtbx9dyRyAMf2iwsBZInj1U87DRK9OqjEU9800eop1a+wQYzhuucNQf9Oyqie2cfe7DayjZkYr8JByQEHn0cvDtVQzXuVvR2sXhtfcuFMn94uEYR0VtLm5/DItw+DKg3oak1rt7Q13IV7I8Be/NiEV/pDK3O4EaoYzYskqfcbHfQHwlcVxauBA7vA+uSPZIMIDmsAyPOAm7RlirYrZp/ri6GZvMotLsk1EBGEKHII2lePnyB5kbcLSzeP2abh1FCVyOPAiSSkGez2Oc2XMGiJM4/fbxRM5lCQhVxYgbEQ+xN5IJYu7o7b4VwnVyDErQv/DlEZAwv9yieka/FIyjdsJ8wSnapq8o8xt5GxsVuwXIRPxJ+uwpG7am4C6CyTokx3hTmpC5rfcUXXOEgeaF1dIMlwG/C2Wdsm0Xp7R57TxecoqxoItlkiHsETgObxcSiLGVXqCeMKOj8QgD0HHHoglbFxD6yqEf+pISeNEZ95ihYLWAzMNGY5eZIseSKAlViILYwtRKI+DKHIISO+92bFZ70JJIMmAjbm3aj
 JAED6B/Z
 nIBfPuYw7gpFxhc2sVHEfsbh/SkOv/UEwgl1q2Er9nRBJXhP+d96Mu16esOnqYxO/k5mQQ2WbEZ0n+Yb0V03u//rsRTPcWMFKqkvaOe81+TOQl9Rka5vzA98tNXJr5ZXfHnId8s2LL6oipB4zVu7tn/hzvzlBFaxZvzGS7SWNpAbROIu1d6YaW+xQZ3h7HxnHSc0Fre61WN0kGJoc3LgFOc73FWlK6XU26/tBvfFjwMAwzQVb8ziPUAhIusGGxCi8yQWq0Uv5K64SomhtpVN19I+1DZytlljYOq93rflTPXv2lYTMu3gl4/th2nKycoJFpg/XG6bfVylvrAW/tRbz/drYfMiv5CkT+Z+gFPWXxIPWdriK8xzK+hiUK2Uzy5x1vnS8x/an+lHHYto=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 6:21=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Aug 20, 2025 at 01:13:13PM +1200, Barry Song wrote:
> >
> > Let=E2=80=99s sync with Herbert: have we reached the stage where all dr=
ivers
> > reliably return -ENOSPC when dst_buf is PAGE_SIZE but the compressed
> > size would exceed it?
>
> It doesn't matter.  Software compression should never fail, and
> if it does fail due to a bug, that's not something that the user
> of the API should worry about.
>
> Hardware compression should always fall back to software compression
> in case of failure.
>
> IOW all compression errors should be treated as incompressible
> data.

In that case, you seem to suggest that the crypto library can NEVER
return an error other than the dst buffer is too small. In that case I
would suggest the crypto library remove that free form error return
code. Just return true for success compression or false on failure.

It is also strange to return a freeform error code and declare the
caller shouldn't check on it. Ideally the caller shouldn't warn or bug
on it, so it should handle the possible error other than -ENOSPC.

Chris

