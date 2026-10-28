Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9D95606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=emohGdJv
Received: by kanga.kvack.org (Postfix)
	id C602F6B05B4; Wed, 28 Oct 2026 11:03:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10A36B05B5; Wed, 28 Oct 2026 11:03:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00476B05B6; Wed, 28 Oct 2026 11:03:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7ED6B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:03:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7175B14012C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:03:55 +0000 (UTC)
X-FDA: 85372354830.17.8E98138
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8A7D240009
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:03:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=emohGdJv;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awGn2E34n5xBoC2fXIOuNMr+45oeRxGM6R0LvPLWK+U=;
	b=EYftMtDHvgVUUZzdUgmGVCPHoziF7v02FyGsiMahSibnyiUGPzHEFG6M9q211O2heGlkJK
	8eRZr/Z4WhIvqkdFtR7WWnxfg1zu5afCQ0XemwBaYVtg0KVGVRM0ppZnfaBpi5NswUZUd6
	ZsgcT8euwKdi7WppeyJmgmYbsvPtxkM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=emohGdJv;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793199833;
	b=nLHFECoJH+3FNqZboCKTJZGRr7lmY+HaYhIDp78UWFHN1TLVDGKueDRFJfjMbqpvJ8CrLm
	lwXUd2x+vD5lPy8YKqTsnciaT9gdFluzbXYBHrNiXlL5OuJNWYheNJmtK3iKvJaYObsx5Y
	R3px0eC2CiJjQ58Wym1tdGpAziT9rsU=
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7ce645a1c6aso654635137.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:03:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793199833; cv=none;
        d=google.com; s=arc-20260327;
        b=LujXxSG+zrN6ojECaNRNzMKNTMeAEdl9AcY5xU5lprHQFovIr/RMZLsclpwvG3FKX6
         U3/yOsS9sDqiE25NgMgrNfOfgX7T0dRMgfUtcTAiB5s5DXUBVG+8AwWdU01Bgf55l9zp
         2oogCKus/4oZeZT+Pgb8VA+zLk8RtUBHOOKzl4Mqm+JMSoUDuxiDJ0SodSibSry9T14c
         U+NJAxAKspPCgOHfaVZyA984qhucyIgGvDfvo3cUtzmWlQFCiToulAk2oZTlE0KD+qEx
         U4CYcpO9JR5LYzoLCZfBjafLtjygJez0RyYWmYzA6VgsGTVzjKlOJeIBxFRIjGzwSHFg
         Vqcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=awGn2E34n5xBoC2fXIOuNMr+45oeRxGM6R0LvPLWK+U=;
        fh=hVTrP0oH+qXSsePyHnZiGSMlwg0D41RXCXuoxj/S6aU=;
        b=B13zaR6A801ZvbeqTC5TRYmAChuCA3ikZ07VSqSsJmO9CkeZu/jsTyrIbvr8EHk7Rc
         fqnzQSUOmrRmmy0zVtufYx/krKBZKcI+HNWwIT5TDOI6nMTcgkNN6KqdwIS8n+o3KL0N
         olWVS1cKWI2yj64YglhMLqlI6yA7FSHsbNLIP5RI9pbei/yJ6tDsq6cvY4C403GWSTWN
         idSE4cxPr84QjLzk90kNZWAHoZKwX7PJT3KEcBSI+3EbSGmLkK4sbFt+psSLirlpzaYt
         p0yDbTOCFEMXZ75dF9TNHdQKYg+7HWoeCupYoTn2XcbmIr+ou6Txz9Z6nJ7IRJ/0txBT
         6NJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793199833; x=1793804633; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=awGn2E34n5xBoC2fXIOuNMr+45oeRxGM6R0LvPLWK+U=;
        b=emohGdJvrMhfAO2zp6T7FAzba70ZB3eJ/9Nto1Lth1Nwbv/m+qprGNheL0tJ5VkV7r
         Eq3CzoKbgOeQEjl0eo/CxdI5aMIgpHxxQCXX09SnV9G1BI1+JJx1paqoeQ3HzMXqqlS1
         9W2q1UugAkfH4IO+KQ2DHJvzw7UOumDpVDXpT+5cRKJ/2sB3lTB+pZddPSr6DhTaCkoi
         J2MKV0riSsVmvO1TaolygEQfD9TaBKoolX20cEqNhfxXC2aNe2oxMRn8VKaf3w7mCGg3
         rOcG35C/UwMK9nxHwbeNDHhRQsBfdoP8R/E43h1xHJN/HiZjus6Ai7NFGhMjO8+delgy
         /tVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793199833; x=1793804633;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=awGn2E34n5xBoC2fXIOuNMr+45oeRxGM6R0LvPLWK+U=;
        b=cAU++JJwt60ui70DkkmAXb4YOlWXHUk6+CHoy88EcbXKtxJ23pU39ci0BPRNxKYyuS
         7Q71nrKEp0jkOFGES6gd+yorYPD3afTrJGfbeOnu8ibbKo2NEzV9W5wuuRwEcEYkqxgn
         QAVRWdk7JCsweJUyb+GeNPsXIRSTJqXMAWK/X5RXWuLoURzUmKKOBphI5UfzUbSOekbt
         mTYYFmIkbBS0r7o0RpwerFJV2YOpwiwRICiuMY8GVpqxqut+s4/Lt/QymAMnJqq8BVdj
         pPbwg43aFqXXQ30P4iaj+xO51YEEm5mFXyirrl1l/Npimxpy4rmIGwZRcKmZI5VH6P/8
         PBuA==
X-Forwarded-Encrypted: i=1; AKwUvBysRgVVPVYkxNIp1+8tyuSemBYeUktsIIpflMJKCFl6Anlcdfl0JntoDrFhQpX+W+o+ux5u5SDLPA==@kvack.org
X-Gm-Message-State: AFq9FYJA+ovsIhoBawlY++4dquvfHH4A/unDblTFBxyO2Jh0qiKtHkft
	uyHbhjh95AZi7s/GYZQRrDVfoYcOzSK4kTGNwSh5KQg58yka9QtB/qoj+5Ni2HCCc1nDhBqk/+U
	IJqsVoah8R0VsGucne5YtZeLuKrFxVBg=
X-Gm-Gg: AYBFou0mMK5SMlp+jGi/wWLIGyqmyRlyjQd0iPEfjfJ7Yp74jwgXi0b3DXGNzjiJ4N0
	y/d+g1NCBBH3BKQP/D21+RRI7DPYMCQnuzpIAboKTd2M7sQ0eIyh8t+AdbeDv58dbpTAavwI1Yf
	0+M8beTtUWLsYdW6T1dpr3OrzOIuHmfMuiuNeBOYVfLWD5IxF74n4NAxKaYdKcF30RrynNO2hpu
	HrhAxfgWn1ETRWgJZXLnU9hkFrh+M/0KhQqhnn4D0QdS4xNYQVmhnx6u9G6ClMoEJ884HRV1LnC
	7eSNYUyC4vUuPoUdgDhgTpKwW1kt6YUylKVsiDn2GqrDtPR1/9Qu088DeYgd9jjFKadhxSZeGSW
	SLGpSOoRGm8pwT1FK6mNum9o94S4lWwYZ9/ybrhWfkWJEx59jhPHVArRvw4pl6lCTvT0gMFlv+d
	/vBczHMvhcwlZtv09DWRgr+qiSpOKJ1g==
X-Received: by 2002:a05:6102:448f:b0:7cb:bb33:8413 with SMTP id
 ada2fe7eead31-7d03a417ec3mr1297169137.9.1793199832560; Wed, 28 Oct 2026
 08:03:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028041253.74839-1-lizhe.67@bytedance.com> <20261028041253.74839-3-lizhe.67@bytedance.com>
In-Reply-To: <20261028041253.74839-3-lizhe.67@bytedance.com>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Wed, 28 Oct 2026 11:03:40 -0400
X-Gm-Features: AclHuK_0y881Zt-9WzkHkMimi_VBCkr1qyy4N5JRQ7yKOQQhsOVN3bLe2ggK2js
Message-ID: <CAN+CAwPM=-sRDypP0+ZxX8_CziBRjXbxKEE3UZGLzkmOWrajNg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] sched/numa: do not feed tiering promotions into
 task placement stats
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, bsegall@google.com, david@kernel.org, 
	dietmar.eggemann@arm.com, gourry@gourry.net, juri.lelli@redhat.com, 
	kprateek.nayak@amd.com, ljs@kernel.org, mgorman@suse.de, mingo@redhat.com, 
	peterz@infradead.org, riel@redhat.com, rostedt@goodmis.org, 
	vincent.guittot@linaro.org, vschneid@redhat.com, ziy@nvidia.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A7D240009
X-Rspam-User: 
X-Stat-Signature: m7epijbyha5mcr6o6mk8jomaw1eycyba
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793199833-562755
X-HE-Meta: U2FsdGVkX185oojj2VgvsVupz0YWCjRjtAAKlhsPJFwDpX/YcppKUuU6pMKIxQc+yx66+JOddaC6E7ulGgAKCaJA+gIl9kvHDV6//LHJ9YZpY7estCMRXy/1nTCJLyhQvbCHlscvr0aakTaCybSOEA0FLj4NQW7GrK4kGrIqdeog/1kJZwp8Ct8nvlkJEVNDKQkyfm15To1lLeOMq8heCM/hKxDXtEj8yleySR4n96kPzzS2GRmw5Q5JnIFX46OaRQATuULRffjHlWgHYJ0+ZHmuWjnhuZ+yunz/qPQVDEu09SVRMbkTdr+Pp0ANunlTgm1+6NzmozCK3hklB5oxgM0T23EJmfdb4viINENoYRBGiJ3KeYtozJSIAfvJVMUxlqBvrAdp6W9Zu4XZ2j/Jq0Yf5UDq4m/AKj80pcN1cIEk6AKTx3FABHhOe3d+8HCKv9ft3FY1iYI88fGYS8g889ogZ1j+/xfBIZpHNO8r7mvZnitxa/haEnhY6DRjlZf+6NBUxbP999whiEUc8Mq8Zy0whn5i6Q6wsygtBDFbSKtCKQBe1cL4MJkfzk7XbHtSKsurRnQ42LLIKV3IiQMIaHL/hBj9qe4FjALDL57J9zY/78TmKfzKAstz9+FaxHRngmqj6tNwOayiLSsMzf+kRN3TqDSvyW9EAEKlfNUt/QZ0sOKgGpTjZY3XXoUz1ZGtoF4CdLUPwI+75fB4Gx3GSRoBrOUyEosN/FDNRY1EPJ5bm2QyPJdMq6v0pivmXq8StDbblizpCdC6MYv17c5/0yDQ48Svgc3sNhXisiTlAnZGRLtbMbdNcS0gHpok+Vac4yUdW8t3srs+WhcZKN84f7RZWSRtJNOBnKhBW8uvX2BihwSfDfoV806EVFyNECf1W7pGHu58zf61AJBcwofEok73QZ8kDbU+7tL0KdlyS4E6eG1tkuuOAe5lKtYAjMC6LLgbkaUUK+67hPeUf+F
 mXqDADKt
 PfTmnfwc59zGTKjFgSItz8KjjqOKV9solSdt6Z60N5Efnuv0LQfbRVmKxTMGNii6UjYy7lJWrHvVMhnpW+D106sk6MaLhlq8ZhvbCZzw6vQbgAoxZZ8+FS165aeRoMQd+F5IpZXlLoAynNpCrbv41WHrg1qmtfIEPd8FGBm0snydEJ4GFpUx1USLfAfrBX0DmLW1psHgvfMALkTdAUZYl1vGD4gjhEuF9UFDUek9T+CsAIP52xRyjbGQ1SQLjJb8maLGAuBje5hstXYnsrh/P6bi5zO8IXM690DoNLQSPTXPWFkPRhS6AAiv+0a0m/nLL9WjUUFqOAVDJnTxaT2XW8BNelbfZD+v1QuPzXFxioQKlxEZh2txi63VyiF4Pu6dBEJ1CF1PX7miekRt26G8FbjgBR/PF9qkoJ9qF9rw2pZvIJ/A2di1iKMkvSt40VBfMNDJZnH4i+BHGVZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 12:14=E2=80=AFAM Li Zhe <lizhe.67@bytedance.com> wr=
ote:
>
> NUMA balancing has separate mode bits for normal task placement and
> memory tiering. In memory-tiering-only mode, NUMA hinting faults on
> slow-tier pages are used to detect hot pages and promote them to a top
> tier. They are not normal task-placement faults.
>
> For slow-tier folios, memory tiering reuses the folio last-cpupid field
> to store access-time metadata. numa_migrate_check() therefore cannot
> return a real cpupid for those faults. Before this change, it returned th=
e
> same all-ones last_cpupid value that normal AutoNUMA uses for a first or
> unknown access.
>
> That can make a memory-tiering-only promotion look like an ordinary first
> private AutoNUMA fault. After a successful promotion, do_numa_page()
> reports the target top-tier node to task_numa_fault(), so the existing
> slow-node skip no longer applies. task_numa_fault() then accounts the
> fault in p->numa_faults and p->numa_faults_locality, and
> task_numa_placement() can consume that sample to update normal task
> placement state even though normal NUMA balancing is disabled. In other
> words, hot-page promotion feedback can leak into the CPU placement
> heuristic.

Hi Zhe,

Thanks for the revision. To me, this looks more like a fix than an
optimization, since there really is incorrect NUMA balancing behavior
happening that could be visible in userspace (unintended
task-placement and related accounting). On the other hand patch 3/3
doesn't seem like a fix to me despite the name, since this one would
mitigate the incorrect behavior.

How about we pull this one out of the series and submit it
independently with an appropriate Fixes: tag and cc:stable, and
discuss 1 and 3 later on? Unfortunately this is also not a great time
to submit new features or behaviors as we are in the middle of a large
merge window, and there are a bunch of fixes that maintainers might be
busy looking into : -(

Regardless, thank you for the fix, Zhe! I don't have a strong
preference on the ordering of this against pghot, but if other folks
are concerned that this could create more churn, I think it would be
reasonable to wait for patches 1 and 3 after we discuss with Bharata.

I hope you have a great day : -)
Joshua

