Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2980606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 03:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KWaFSMrp
Received: by kanga.kvack.org (Postfix)
	id C42786B05B1; Tue, 17 Nov 2026 22:19:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19F86B05B2; Tue, 17 Nov 2026 22:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B30B36B05B6; Tue, 17 Nov 2026 22:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD956B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:19:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3C2F1A0656
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:19:39 +0000 (UTC)
X-FDA: 85446784878.18.19A24D1
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id 490C420002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:19:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KWaFSMrp;
	spf=pass (imf31.hostedemail.com: domain of 3SBn9agwKCM0v0A1BF1Bx5t6z77z4x.v75416DG-553Etv3.7Az@flex--chriswiseman.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3SBn9agwKCM0v0A1BF1Bx5t6z77z4x.v75416DG-553Etv3.7Az@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794971978;
	b=X1RI4dnYITeev46BACVDie/Htda9HGp4gpjzJPOOvLKW/gOSoMM2ez4HnBN8n75dO9Hfqt
	/nMDPknm3Fcp+O4uRFmby08BWC7o5VgDwA/jr2qpNeyeFECaoAnd83u5HAengoLudnTvPr
	G65KRRrABcAEiS6MVjFonnb3ZkQHifo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KWaFSMrp;
	spf=pass (imf31.hostedemail.com: domain of 3SBn9agwKCM0v0A1BF1Bx5t6z77z4x.v75416DG-553Etv3.7Az@flex--chriswiseman.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3SBn9agwKCM0v0A1BF1Bx5t6z77z4x.v75416DG-553Etv3.7Az@flex--chriswiseman.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794971978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHnNDDFVc/Jbb9T25AViGkeUZ2CVD8Ckp6mVqsJ9Za0=;
	b=GzL+dO7t71jwjEOrVhY8ahEHAKUXn1s1bvARLr729VNZlU4wPK5BBH4FlXHCWeNGu0DBEC
	mm1ykjMlXypnByeaH2KgGNVFHfwg8Ctmlyd4KLC5mGwwtHa37y2pptXa5K5B8gmiMxnNeq
	utCBGKjqkg3u3ld1g/RPf20p9XvEMZc=
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-1a5005fd0f8so1050460c88.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794971977; x=1795576777; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jHnNDDFVc/Jbb9T25AViGkeUZ2CVD8Ckp6mVqsJ9Za0=;
        b=KWaFSMrphEqAsFdfuY7oaHKyq2uEcrxSKZKrpl+e+iodaCOxuxZ5whjQrFTUF5ZC/j
         wb+DRNULPURySs0sjUUsMK8T2kd2w/Y/Vic6qc8GTt8vJtw6bVAlOdrlZQ8qyg8CdK5x
         NPEFE1Xea12S6t0qJunrr8WFPcpVmLENqp4hcPQdjQ9vaizmMEMAHVlUXhG8prhmcY5a
         1xSDH0/l8MI2KMeq622I78CD102bwN9CMbdeH0qyacC5bZqHMY0rCVC8k8mIpYLr/GBT
         t8KOZl7IUkik9A4vd2x3QQIIfBeGznzp90f3fupUpNAc7F7VxutaPlXbtAeCNkSE01dk
         i1Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794971977; x=1795576777;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jHnNDDFVc/Jbb9T25AViGkeUZ2CVD8Ckp6mVqsJ9Za0=;
        b=hyksttOtNe9hKAW3ejuo/+oA3AD/Jkmi7lU2AbRKeoF8t6tdFiQppj7qvwkuduw97C
         b9z3RjZl/ah1XJenKhPomipLtr+FSI/gUF/eGBWGTZDfmEcuX+LrBxlscxFk0Uynow8T
         7TNRnLqHyty7mpu6wcz3LikTdNv63n7IyO3xa1UwuhJkV0ZD8Rel3U7SUv24hDBuPhFk
         HHaytmgjG0EMB8YDTqgLooMB7zrVSppWqvxvrdqM1Iutc2jyMz7p4UiYmKJigpGIE2No
         pv6lN8vhc1c0YPdU+E88qTXeQZxxOyYafBsrf36qqS+RqikS8t3nZhzUU28PM+QdlrBY
         Camw==
X-Forwarded-Encrypted: i=1; AL+hErFcSdSVTAbXApnSJOXmFjf3sT2gZMNlWwcbCAmrvJzMOM5Zt6me8NuJohiL2x7m7t7dZWEH8b98Xw==@kvack.org
X-Gm-Message-State: APuU4Z+UG09xJFWDcmQnIdSKrHoHCa8s9OjELCDM2k6amv+XJ1BFgJND
	IWHlWV0V5l0ldLjuHs0DM8tZCLQlX7pGpp3iufYpJj8IdDfHnApetaQoF53FDEn8RWZsg52E5Mm
	N1T6cz0sTDdGTnebQyzJwuUYL4Ztx2A==
X-Received: from dloo22-n2.prod.google.com ([2002:a05:7023:a56:20b0:1a1:ce17:436b])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2204:b0:1a7:78a3:bda8 with SMTP id a92af1059eb24-1b543c25a69mr1958847c88.27.1794971976348;
 Tue, 17 Nov 2026 19:19:36 -0800 (PST)
Date: Wed, 18 Nov 2026 03:19:35 GMT
In-Reply-To: <av0L2-OtxcWpQ09m@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <auwOBaRtM9p_Wxfx@google.com> <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
 <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
 <avVVRYkIAQnLC_Yu@google.com> <18e8fb5c1c4d127f.3137322e32332e3235332e313736.289d37.0000sendgmr@google.com>
 <CAO9r8zOtL4t5pwQOE=SAWeg=k2TkhtNXgV6CJJGNTwuTebKpBQ@mail.gmail.com>
 <18e8fc17375582a2.3137322e32332e3235332e313736.2a6db6.0000sendgmr@google.com> <av0L2-OtxcWpQ09m@google.com>
Message-ID: <18e9058097a70f62.3137322e32332e3235332e313736.3e9981.0000sendgmr@google.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
From: Chris Wiseman <chriswiseman@google.com>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 490C420002
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 9j6gdiqyb8a8ghfj4agimsuos3dj48hi
X-Rspam-User: 
X-HE-Tag: 1794971978-709651
X-HE-Meta: U2FsdGVkX18XFj0W+XmstxSQEZsAnhG+z0Aze4nlBjPKvRzPlJXPLnqW6V/Rlr13+K1mnyp866fY41uWCAw5bJuz0C/C0bmuBOM2tVLaqlL4Itg2yn1crQa31W7i4C7pq+t4eefaQe9M5WM52KCjWh6+0JiBPWDm87kMCJVPojk90frpd8Ma3THRhfUuLHrnBQdAi5UnhHcc3ZbFLRvXXMI62yU7b24zgLd1Qk1KBnUEmcnLpggtS5oKhqr3G7WOwzyofmkFcfSGxIVGkeAqlvE+SXbPhI+EsoMgYA0KIJ+Y46RscaLUf8s2eSnSzt7Dxf8XVxpSsO3CE7xM8tDPWbJaK3Cf6qPAuqX1H4r+ymbedx4gYCsESQ/GlsM/gmDy2Q6DgtvG7hxi3U4mRwYICtO1teIr2ikfIdbPkYNQ/Rhj53kMjlGw1dRWBiSAYxtsv9qoZOltym23E250t5cbOtxxYJKDZfpXHdju4buNsXsTpz2Emo6Ydz4Xet52WQLpGOAB7djQ6qRCPQGJeI4yDAM/DvSKitdIcLjhe4tCUbMmV00XLJSukILhtULgU+WqU0CJO4iPklPqKN6HOnHkTjE5S+pFltZdmEv+dvHhKFZn6M5qkBr1Lbp94pxJnp1IsCT/RT//1WRUsjEgvMcRvVeB0VFT6i0k3DXp1K/vaLseQ/M+VQaMkJnfM7Yi9iVXRGSbSCVtePln5E5MXgHW5V3mANSaXzJ4FFN59pT37VBoqJKoReVJMTwTXqFxQko96KcSnPLUeyCW5oSqzDK2QHbtCQ5SmnFoX/JVv0bjcQgVBbsn7QfQ6iaqQppTk7ER7Q1rRRYTnwpciBsxQyua20Cd7bxSabm5TO4LcSAfJjFxvmKBYsGBBi/5B4vvYouL9vOMoEsqPpVtdxq1SOp6x4IM4h3J/zcRzaXbJcVKzsZPjM03ke5jW9f53wleDczVW6aHh9XrxRiBXl8KRe/
 QXaLIYoK
 da5Grvjx8KHjVpKJm9Rxxr/IZ5s1xhJu3UZCt28UGYabVkhtN0WuYbepxj0MUTOXohcPUWB8eOhjwFgIIYtnLBRb8Zv3bjN+KYuxFPlW0bov4xwAJwyeCHb26yw8KmucbpOsDTCyxJxOV0rKRXeWCjZX5+TwI50aTWrtdho7a35MnKkNK8sdyBMk7tD9bVcd9lE+IohxsLu24G/JEOp3BNxykHoUwV97/2ztW4l6oEl+15g9TzBOmiTEyliKbQVkKLbPO6QgVOLuLOj7umf4mFmMfkSfr0/Znw4pF0krgU+Bt4seVceQ1e2ypTzfv25aEsxNEPwZKwYfZzo6uc3CWdC6Yrd1812/F/juSKLGQ3gyoJJk/onfAEbhtnwvQJcZW4Yw/zIa8AfOYn+J2iCM6C2Yb6yl9NsuiUzrr2KRoi34tVuXkv/fCthLI9OAHabXW+wTkiHzA8WoD8ZGp85z4/5BiCMXqN+/u4GCG0aQ1i201Q/IJSLFNJfMfqLMW6FK73KCKwm239fAjjO/jSBDo7ikbAa7wTaGYHom/LoyR4LKrg5HqqU0are7Yt7e+81yfRxiXJa9T0nEUJAX/t8dOf3cNqUfnRfHA4JM1IWsqRSJhigLl2JBugESZIYNsX/N+07M1eGM11qmeBweBz1XxT+MmW65M8H72uyJCvZai4MVJFhv5z1qhKIglfiee4T0e1wOJHdIxpr4xUK5TM5RgtQ7HLo5lKDlMrinHb4aNs7hVLsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 11:25 AM Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
>
> On (26/11/18 00:27), Chris Wiseman wrote:
> > Nhat / Johannes / Sergey - good with a 2-patch series that just removes
> > the zsmalloc shrinker and adds the unlocked zs_can_compact() pre-check
> > for manual zram compaction?
>
> If there is no shrinker now then does unlocked zs_can_compact() matter
> that much?  I assume zs_can_compact() is now called only from external
> code, so it's not expected to be executed nearly as often as before, or
> is there some other reason to make it unlocked?

Ha, fair enough - started this whole thread trying to shave 70 us off
the shrinker and somehow talked ourselves into deleting the whole thing.
Definitely not worth adding lockless reads just for the occasional
manual zram compact.

Happy to drop the pre-check and just send a single patch removing the
zsmalloc shrinker once Nhat and Johannes are good with it.

