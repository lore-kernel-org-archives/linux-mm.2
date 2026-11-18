Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8810C606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ut7sEqU/
Received: by kanga.kvack.org (Postfix)
	id 7C7F16B05C4; Tue, 17 Nov 2026 19:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79FCB6B05C5; Tue, 17 Nov 2026 19:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6016B05C6; Tue, 17 Nov 2026 19:27:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 333CE6B05C4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:27:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8AD0AA8278
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:27:11 +0000 (UTC)
X-FDA: 85446350262.26.4568679
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7FAC18000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:27:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Ut7sEqU/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 33PD8agwKCBEty8z9Dz9v3r4x55x2v.t532z4BE-331Crt1.58x@flex--chriswiseman.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=33PD8agwKCBEty8z9Dz9v3r4x55x2v.t532z4BE-331Crt1.58x@flex--chriswiseman.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsHVmlswq1n5zq4kG8Bif2auVAICBU1MbvOTG3olm7c=;
	b=TWDUu72sDTvEiZUKcImW98d48pRZ5HG9wmIioAPJTIQfniE95OKhjFiKu/QrErWSeLf8IU
	jAl1zU4hCSoAj8Qbby1Zf+6wOER01ywoEa8HhYqf1f7R2GChriFsuZKubDFD2tGP3nF3B/
	j31pxHfMAES2yxUuDYIemBZhK8Ani0I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="Ut7sEqU/";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 33PD8agwKCBEty8z9Dz9v3r4x55x2v.t532z4BE-331Crt1.58x@flex--chriswiseman.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=33PD8agwKCBEty8z9Dz9v3r4x55x2v.t532z4BE-331Crt1.58x@flex--chriswiseman.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961630;
	b=1ARsBgTxn1qRghQQt/yBaOLnxeQE2kGZojb4Izfh+Ulbby5JZOdA15khlffLhsPW1vFysk
	JC3HqN3menY5zYEPwvUoatX8///NTG/hHEYoh8Ud0O1nCY5Aer4n/b+/2W0ZHR/PEfwh7u
	d//x6aDr1pPe9//j/N0+e/83prZ7PVc=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36f26e6abe9so612077eec.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794961629; x=1795566429; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PsHVmlswq1n5zq4kG8Bif2auVAICBU1MbvOTG3olm7c=;
        b=Ut7sEqU/xSp5MUrpXpBOpok2teL+owwu8I782s//dbXNYUFcumKa3nUBfACT8oBGWc
         GQt1IGuJVIiYkfpDExETwMmclfrIH+NAKuZRumb+0Pk87ENQ3lu21SQYR4UFor6nXouc
         0qXLtgb6eQTsrxzrSpEGbXip+g8McLUk9W6s+x7/yO89RbUz4OyjdKWbgmKBhx4lAEgn
         BlhHj0l0GEiAtCnSgZX1nrmDBAi/wEy2sUWjiSv8fMMjBSywo1xHW50HUbxLskprtDG6
         viQn6oqrePPlyba0uVHkeWynsYooQc2n9/DRhrJq/3+TO7duTPDjZY/S1qdZpm3HoZMV
         GfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794961629; x=1795566429;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PsHVmlswq1n5zq4kG8Bif2auVAICBU1MbvOTG3olm7c=;
        b=WMb7QMfC2TvNAWmC6/VPyCt43pC1SATRomXA8M1Z3QnVoNI7JXAYG+efNGKLSxh19H
         pt//cN/wgYpsusvEXWuB2d2dkBenj/uIN9m8c8JdVLJSmjYxPB4aFLHM3Bi5UV8OpeKG
         wy40ZYH1esevaotf6eTb9WHI2hiIzX6eXuFByOIFPlkkKgZvO8BqmZLsWv/fWsIqCc1h
         +AG7d1nYgTQzRyLdrs/i81Z13fVQnVKEwE2J+7iklHftHa1F2+qwdtF/oXL5VJN/OIPo
         uYdNcU17J5mzUNdcF9tsUansB+2NDg3MR3EQ57b8b6emQgimuhQP7UZ3HcYjAm66xKvF
         09/Q==
X-Forwarded-Encrypted: i=1; AL+hErFeKl9rSm+N/ker+2I6kiCwMQODedpQy7aFS8mHcrlQaK2YDCj+aV4hzPAgpbkyeu0P0xaJ1JSsLQ==@kvack.org
X-Gm-Message-State: APuU4Z9YtVbY2cqHmR+Io3Wl2MF2QmMF0L9PzwifdYJ+u6eAMWUK+70l
	FwvKGpzzlttwzImQBclHVcJ4cXurBiu4KpUAMm6w+z+fxQ/rHwUh26JpUP99shtTsLSnKj9XuZI
	1jblaISA/p+Kkh3CY1dREdgWpb2B2Bw==
X-Received: from dybut12.prod.google.com ([2002:a05:7301:e0cc:b0:342:c2e6:20f7])
 (user=chriswiseman job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:7314:b0:381:a3bb:f945 with SMTP id 5a478bee46e88-38280a386d4mr1424912eec.22.1794961628155;
 Tue, 17 Nov 2026 16:27:08 -0800 (PST)
Date: Wed, 18 Nov 2026 00:27:07 GMT
In-Reply-To: <CAO9r8zOtL4t5pwQOE=SAWeg=k2TkhtNXgV6CJJGNTwuTebKpBQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com> <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com> <aufPMirl4cD7tz0X@google.com>
 <18e4542967ebdd10.3137322e32332e3235332e313736.1dfc41.0000sendgmr@google.com>
 <CAKEwX=MV_xEUvz91pz6uc4qXWnWOUDtXZ2zASdNVOBHBLeA60w@mail.gmail.com>
 <18e4ebf806e937ec.3137322e32332e3235332e313736.1bf52a.0000sendgmr@google.com>
 <CAKEwX=PFdgEbba+H3fEnJFDnfkxCTsvuHEb4numVwJRaiMgwKQ@mail.gmail.com>
 <179384102494.19062.12740032892044628762.b4-reply@b4> <auwOBaRtM9p_Wxfx@google.com>
 <18e529a5ab0738f7.3137322e32332e3235332e313736.873cb.0000sendgmr@google.com>
 <CAKEwX=OUt4=wqDLiPvYuiTnkpuZYnszkuNQScNR93hHhVPRRGA@mail.gmail.com>
 <CAO9r8zMMGem-LTJQseT5xSSBjfr3UX2gzG_ftpw6+KF8m9v5yw@mail.gmail.com>
 <CAO9r8zOY1E7gCYnJZAfKvyHcbj8e2WVuXMqsaPGPsKR4-9itsg@mail.gmail.com>
 <18e53459a8013078.3137322e32332e3235332e313736.12c7b6.0000sendgmr@google.com>
 <avVVRYkIAQnLC_Yu@google.com> <18e8fb5c1c4d127f.3137322e32332e3235332e313736.289d37.0000sendgmr@google.com>
 <CAO9r8zOtL4t5pwQOE=SAWeg=k2TkhtNXgV6CJJGNTwuTebKpBQ@mail.gmail.com>
Message-ID: <18e8fc17375582a2.3137322e32332e3235332e313736.2a6db6.0000sendgmr@google.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
From: Chris Wiseman <chriswiseman@google.com>
To: Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Wiseman <chriswiseman@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D7FAC18000A
X-Stat-Signature: g9dygrhpfy74k8qcff7ttxw3jpgt4shh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794961629-917299
X-HE-Meta: U2FsdGVkX19LtlliSwbMnJKXh1qSBkI+yddtpXKdDTBeJKTJgbNX70C/Q95aCF4oZsyc0cEeylvIpJphm7htwIFZcXSx46ZXsBitLspe+wz8+8bm1k6t778WJrjiaVDx9t6IXli/9mkKbZ5HfcBCRpYMbTml5xouSzcdeA6JkfOG5wHw6FUQ7uAdIIlh/srJmiSkYPhStm3zP5jJSYb9gx88UO9YhAsttjTKMrjGIdJXzZDBFf0i+R1AnIq6NgL/xY2nxkSfaO1jOJpWCv1dAGffmXlclHemtrLaEVUAH9pTEtw8d8eRXI8VVsPCbPHHMd6nWZni2hNq/ldn1trbdoCANv3X7AR39xu/JxQpszDPYL36GoPNRnAi4M9oOaW+TB50XWtieCgOc2eCdwWTdR0CRgZ53QMEKvpSt3fe16dEvyFqX+bpHeISWWBG1IZY8y0rEnvOFbh+E9Fu0aPukR8ZjUpV/lzc+qR4IqNZP4c01ScRivNGmrPlxkwltZK2is/7Om0BdWEvhrXm/0napUCBjxkFhEj0a4li3JU705dsCyAhxL1g610u4sPJ9QtT6FHUQU90h7wDvpyTSwuUhwGopjwFjMi1SRZK7RCRxYgWOxjl2ChzAUOyYJeaIW76j/wyv+I9ckHS5jGg2oY6n9+BMpXaXlVOnYRnqrRS2wKPAVX5ZiYqefZdus7JH27kS2lOPuSwXitnLY1le97AxNqNgwSMhX0z3VBQzp1/QFxo3+Sz5/QHm3yTHliOvoekgaCfdagwjnn6XuhekTOFopItp4/2kYJa4hspfiygrB6SbmXY1jsBl9H3Kw419qXDLd00QpIfCmX1xe6ZDotv1LXfpiqF4MJcESg3TLI0hhHTbkdLPbKBIHMrw92liwKKO595rgUbJmnH9ktL7kTb9+bE00J/pXD+nEJfywIymCCHEsKXa/DCa+lH6z/IT4fp/SnDD7u7lqVVtvxq1vQ
 jyDnpItC
 Jw9JjRmvNXzou3gmNZeawx/Arp6szzCVf8bmrnSa81XH5agPj3QexgffUhp8bBrG66etKpIBceFYujO+UaW1/70aY4AfHROyg8AhbYv3SZe8ou1MWasZVvxrWRK4aIPbOaT1pyDdR5Sz0et2fO7cts0D5gWMIpZclCma0zJGu9clRrcWE9ehufPnqucVO7D0IZpr0zFPyA1fwX+zgWac2erDrJIyKq0OYEGBQsUsv3uNUbUyPgDqkJ3tXjWsf2jyZJAEeNacsudfgl3OS7lhSaqG50khsoSpOJeYh3AIJfY2qotfLV503Q0sfUkeljYMwmQOtY/AhcEV/mdoST1WR/AtQ97tCPbpZZQ6lSiSg8WmfqMdciEhPmSCAuQ/PbJpdMGuh0K0CgkiMERQ2cvxeCw5GMr8LUoR84PqS5rZVipPSQBrBPT/WyTI6yBdbFFiS4TBnPgRaYwbdE6gf8mlPcauYzCQSyeR702JpsNIw9sa5y534xV+70yeU1bvLbtJ5L9jRjZZEH8Oef/ukiiVyKmDzeBAb+3MOnqw4BIVbtgCyTjVfFqoVy+fTRM4lpT4f49JKO1rTfCPT/Ef5PrFXES4E7T4X0A2qFZ6c+a30WY7UI0XrUXgqA18V3Aphsc3o1FNnUsz7xvnmqX55J6MTl3WlscFILE0eoR108tHdTzGhdqbPRCSBCSugxjsXubtLmkdscsYG5HSaPZJO5Mbt4EkCBNnuaqHaSNbZXJ/4XN7Bb5ukf+ZMSDhCbcnCgmM8oTui
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 4:23 PM Yosry Ahmed <yosry@kernel.org> wrote:
>
> I would rather drop it right away, but I am fine if you don't wanna
> bother with zswap.

Works for me - dropping it outright is way cleaner than adding a
Kconfig knob nobody wants to maintain.

Nhat / Johannes / Sergey - good with a 2-patch series that just removes
the zsmalloc shrinker and adds the unlocked zs_can_compact() pre-check
for manual zram compaction?  If Xueyuan doesn't grab it I'm happy to
post it.

