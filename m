Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 176B6FD375C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FDEC6B0088; Wed, 25 Feb 2026 13:58:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC296B0089; Wed, 25 Feb 2026 13:58:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456346B008A; Wed, 25 Feb 2026 13:58:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 310CF6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:58:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF3201C8F6
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:58:30 +0000 (UTC)
X-FDA: 84483889980.03.8B1FA29
Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6D4FC000B
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:58:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TgAc6Zfg;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772045908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArROPpjnJzj85QG9odZcXqmuIgynPaSR2+psVn75qQI=;
	b=643nBeSqTtxV3d2BqyBuz/h2a5dfCn4307iAbullYBG3raKKvbBgxncIRb5E0NV1o3/RWN
	tX/AjChDlEZviTOxJylrcfd2c5wocrsPJm3puA/3RP1CkONFnqiC9j75ehjs/KgqrDmatd
	ktiYoIz0MtmU7DDzjL/lEI0Dmx7nfmU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TgAc6Zfg;
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.65 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772045908; a=rsa-sha256;
	cv=pass;
	b=8D2Jx1SxFHlrGb7nhheUOj2uD4S97DL3VQd5vzKs45galAhZXI6ZRyPyyccsbZv5ido7mF
	ZsmyK2YA0kXDpwyFfTrZCCUd7noy4Yf+b1fsEQbheZJkw/wRmrj/a3zuuDp9UGfofx5Bwq
	iQaY88HF14hhh6loLUSvAS64DtlY4+M=
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-126ea4e9694so3945076c88.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:58:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772045907; cv=none;
        d=google.com; s=arc-20240605;
        b=PkIGfKvffEEv3B+jo+Q9JXWLzIFoelrSDDkUSYptN05dfwo+0t8y2dJdlOxyUUKLCn
         UUzSScDW4Z4vKk8VKhyl377aD6f1JhXfTtfhBs4MhapGzVltJ3hCBRMs8ZF/nd7TSyL9
         9u18ezR61vdofFuIS74SVa/SX5n/N3Ih2G3Yet9G2lb9M8bOXHgo6OQ4YuULM4M6ETSk
         TGLTYlMRbLWGwFMZxx9FMI+cnf45ParYjTogvGwk+iLLWl90veXvTsJ9KO5u3SN4KqwF
         l/bSyOErTEeyn95f5TjTQBIsZkUMVsCU381T1++y7Fkg9yS8EW+VThtes8J2MTPoiNs7
         KdRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ArROPpjnJzj85QG9odZcXqmuIgynPaSR2+psVn75qQI=;
        fh=DW9P0m11V/TWMAIg54upU+0baKZ8Uv/7/djjq6euU8A=;
        b=ZAwIzgo+gvKO5//c7MLFuViRjDWe+OpHwpLjd5JoEptzDoLpxLJfpiHy+bAgAfXHAW
         5ahIaCh9j5Lti9kW4X8WLqiUICRv9xAARusBGnIa376eMcknLEWEjwvL2nkb8SULP2nM
         DXSKVIC6QVlkw0YX3J5tmCHMXxqLwbiVYRnhPno5r5iI4s934AzL0IBC1EhJnypxtvMi
         BP6dg8JOzSH9H4n26BAamJjhCPY9ifVIqZMloRtahNvPMGuBkoLslox+d9WJR7LgtRC1
         J2XRtj4Fr+CJYzfxDJTiHEfUoE2Glm9bSHjSwgg9UBIc+uFcY1OYMZOC/kzbGDJFyhmH
         9FkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772045907; x=1772650707; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ArROPpjnJzj85QG9odZcXqmuIgynPaSR2+psVn75qQI=;
        b=TgAc6Zfg1FZW3o5B0nfYuG/GRniRAqFc6t+l6lRf0Cx85QuIoBVke9bpYtegUIn7Zk
         2iGar5umvqczlXUqIFhTgEyZDsi9uMt2W2xBQTGpFfUUc7ErJIeK9tWOdzzFm85R/Hne
         XVd4VvSM/aZcfRcGuZqCQZfAHg9PycvpnWf5teVJhfNOI1q/WTc6Uuc62B1KCP/u2lkY
         BHb9DHT0DaSMGxUuWmJoahwOC1Q4JaVhoUmFQ/PtuLduKIOVM27FOyY8wZNyJCyR7uGg
         554UpAhutS8qpGzsE4U7x+GHSeiOj8TLjsN9H8SNZzHKU7CTS5TNIAiY4kkl0w6P6hWd
         YnBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772045907; x=1772650707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ArROPpjnJzj85QG9odZcXqmuIgynPaSR2+psVn75qQI=;
        b=mtGU5I192K5jLyofCTGjPT/Nn+j/2bAcipHVdFdldEkbKng0Ec2j/6TgMHBjuONkJj
         10WrWixYino7/SI1xzprxBT4bdguesmgayKT8MnJJ9AZmjucyBc35mRS51LZcmBQcg1W
         S6+3hQWMksLOeq22yGd6ExfuX27vpWLuXe49LRbdl6XrFvde9HXaS32slG2GuPJ8Sdh8
         faKSO2xXhh+0IoJxMKK6KESX1IjNXpj4qm2q8HcDETnCsrNczM3L2+UIU1dgiy3K5uoB
         lQ3Xx5UHW47vRshiRt8Fzn4v+zIeN+t7ver0G4vd1L66IRWBeSRmjUM1SNqakh51TdKc
         5VUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgzGAcbTNSC1NiHERss0vkAi6q8iTTNaSm+Cyc2JocrLukG7e6fZToSZ8eFx36OzlLsZZFLM5bng==@kvack.org
X-Gm-Message-State: AOJu0YyytMATTWufNagrCpyTZDHYZLm/dNiB6JzQCrT5H507SbEfb+AX
	ouQu16FE1NJgY0jKhXyz2Bx6U59p9Oh046cNjJTtMFUVmogve1vZYHHtVM3ccMGHsFriTrHCgk2
	/r7dBMNa9PW2Q5sbReDv6kpd2XWOWEQ==
X-Gm-Gg: ATEYQzzWTB0L7ldoh8jtve7TIFWtgBWyl07NHAI5bUjSXVPx9UyaD0iWyTi5wryEZsH
	PJG4m66Cw49OHJfpGF1i2nuDz7xQwkjkcNXed9IHRYm+szIzAPw5TMwZYP+uj/70sxM/DPn9x8A
	w9t2YIwBiWY9VGX4LuqrFT1IZrBeS1E64p93U52WmVkPKKAlNoWaq7MHwe6bVuMl3ubbunvzEjO
	EtSGrW9XoszIm0yLAwRpMaBxHNWyPkHD0dTZjXOOJXi0LYbaYLbaw93G46bH/c2jo4rVbz+Uu2C
	/CRPl/4=
X-Received: by 2002:a05:7022:4589:b0:11b:ca88:c4f7 with SMTP id
 a92af1059eb24-1276ad3fecemr6585546c88.40.1772045907494; Wed, 25 Feb 2026
 10:58:27 -0800 (PST)
MIME-Version: 1.0
References: <20260223123232.12851-5-ravis.opensrc@gmail.com> <20260224055451.58713-1-sj@kernel.org>
In-Reply-To: <20260224055451.58713-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 25 Feb 2026 10:58:15 -0800
X-Gm-Features: AaiRm53tTS4j79q29YaqOt6DqbWcBTOrpnxU-5ZG60LfsiyErPqmfboGnXJ-bZE
Message-ID: <CALa+Y14yVxW+NSP6-G+93yHFLKhFhvKMQowGUR1MBcPgvO_q-A@mail.gmail.com>
Subject: Re: [RFC PATCH v4 4/4] mm/damon: add PA-mode cache for eligible
 memory detection lag
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4tbakfohnc5aykkp4qfyc7ohn9u9phah
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: D6D4FC000B
X-HE-Tag: 1772045908-480346
X-HE-Meta: U2FsdGVkX1/8Lt6dF2902Iovkg6VC9CVtUvMcNUs4VnmnS3Zo6zazmWWjiWbm/IK/IvDaio0MP0XkcGUpmTSMpXgqIcXLXx/zJC3JCSUrbWmTGo0Xu3vbnNZgkatS/dvkeVRwD0Z/sXqEz8sBtICWzQqvgUCmLEp4EKAAe76ajubdUyX1Gz5MBBxXcjaLSBmgthIPUyFPlqHUxG0T3rqMNogoiXBXWoq8vR4fKY364GxtGAm3iDdXJT34BYz9lwAVnBqqkK0eNGDm6TBG9DwTkiCi984iraWDRDVZ1/0Bgvs1TlPuBIqW+lCK6/pwLjfRTQbBvdxxIsZ+bVnrPTKKl1U+Go+udlAInGFt/P0a8v5qR6ItOUpFU/kol9VLBfOrICFS++CU0XF99OOCD6zcvs247Z9iQXs4V5OL9RxPqMYew6AMVaED9P8icDyvzFrmp8IGUB9eZXkIbR2N7bHrfLsRqP4andWxC2u2WsEzviNxdt0Q1sJTFe7/eByi8r0/T4ttyawv7/kCcDmESYU3oZzc1K3M2TfgzLpb5g75/mE0vetuZ2e+pNktlHgRnpiCmqkptKqXAIa8N/FWmjyvQylRTt4PligXXVw1ErDNSltWFr3kfhPs7LkPEZhrsP78pk8uSsUWZGh9T9tIgzER7/fvKP6Fi8VFOE5Ks4BecMJfjQ+pRPAcblwOvLq+9JN/uQpzCxFs9Tvpryzer8feru1fwN/Z+32l0kcWCT/YIy8D3fgqiBxhve4nlRfWJKKrcjqr0sqGJmEg8udJ1Z/tlxe7aF7RjjUtMth1kgkfqAls0JsCX10+Pd4ZWbZn7fOGq3Jvr7SRkJkq1GmBnxcCS8HLUEQdbRe9QVP+xSWNi9iR8njQyU7n3hQQjnh4Z3LEOfGGRyVWqxstyqDWuF8/rVtwaE/4v0HiKiMQhl/rgVeLhDiw+ugTQs6H2A+04VVOiNDHgTlCQL7Z9yaAV+
 Bc6FUhOJ
 QnuKaMwjD24I1kUi9r4kxrsKEpKMv6/DfFn5hUedD/6vMNtcTEYMNG993cWWS6XXxlXC6IxD413raiyYQtaDI5ieymHY1qsA52eZgy5CPcGSKMZisuD+4ipKcxiUpby0Mp2y5NcNt056p5B7EQXPa16gWJsaR8W/rkv5IvbqdqKS22M2OIG0bzlazvkHA9Qbe+hd+6d9yEiq8PDaYvkZt3C+RsAJ7GvQrsjEDJSvm9NBeSQjaZuyg+clKMwvj+fmiL1mPW2TSqE24RoeLK8XN1pQbPBKN40npdTcKB3CPucB5oD0SWe/sRPTiuTKXHV4zU9d99PxowWZd7Wv98cqZTr1LGC3/y5cB2aeoXipuImH9157RtUX4z/nhqQ7SLnbeVRJNxt6Yo5nyWUBfZ0yMIxHzB7ujlAEGIMqK2hUWloP9/RARVgkqlmrgayGHl+uBVxJA98vzjA+Zes/SyPkEojXq0wM1eS79gRtaWeqttVZPJUBB+PYIs2MC3NmJIw/niDwyiGMiYSB1sORoBfXzlyjreeedl3zUYPjNzfuMGA7UJ33O4AASFdDXqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 9:54=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Mon, 23 Feb 2026 12:32:32 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > In PA-mode, DAMON needs time to re-detect hot memory at new physical
> > addresses after migration. This causes the goal metrics to temporarily
> > show incorrect values until detection catches up.
>
> I agree this can happen, and could be problematic on some setup.
>

Thank you for acknowledging the issue.

> >
> > Add an eligible cache mechanism to compensate for this detection lag:
> >
> > - Track migration deltas per node using a rolling window that
> >   automatically expires old data
> > - Use direction-aware adjustment: for target nodes (receiving memory),
> >   use max(detected, predicted) to ensure migrated memory is counted
> >   even before detection catches up; for source nodes (losing memory),
> >   use predicted values when detection shows unreliable low values
> > - Maintain the zero-sum property across nodes to preserve total
> >   eligible memory
> > - Include cooldown mechanism to keep cache active while detection
> >   stabilizes after migration stops
> > - Add time-based expiry to clear stale cache data when no migration
> >   occurs for a configured period
> >
> > The cache uses max_eligible tracking to handle detection oscillation,
> > prioritizing peak observed values over potentially stale snapshots.
> > A threshold check prevents quota oscillation when detection swings
> > between zero and small values.
>
> But, I feel this might be too overfit solution for a specific setup.
>
> >
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > ---
> >  include/linux/damon.h    |  45 +++++
> >  mm/damon/core.c          | 421 +++++++++++++++++++++++++++++++++++----
> >  mm/damon/sysfs-schemes.c |  30 +++
> >  3 files changed, 460 insertions(+), 36 deletions(-)
>
> The size of the change is quite big.  I'm now curious if the problem is
> significant enough for this size of change, and if this solution is only =
the
> single and the best one.

I understand. The cache was consciously separated as patch 4 because it
represents ONE possible approach to handle detection lag - not
necessarily THE approach.
My goal was to share what was needed to achieve equilibrium with my
synthetic benchmark workload,
while making it clear this could be dropped or replaced with alternatives.

>
> First of all, I'm curious if the problem is that significant.  I assume y=
ou may
> seen the issue from your test setup that you shared with the cover letter=
.
> From my understanding of the cover letter of this patch series, however, =
you
> are testing this on a setup having two complementary schemes.  And you us=
e
> TEMPORAL tuner.  The motivation of TEMPORAL tuner was for setup that not =
having
> a factor to move the quota goal value without additional intervention.  I=
n
> complementary schemes setup, the schemes becomes such factors for each ot=
her.
> In the case, TEMPORAL tuner might be worse in terms of the size of tempor=
al
> oscillations.  I don't know details of your test setup, but I suspect the=
 use
> of TEMPORAL tuner might made the issue bigger than real.

That's a fair point. I chose TEMPORAL because I wanted to move the required
amount of pages as quickly as possible to reach equilibrium - essentially
"migrate at full speed until target is reached, then stop." For my multiloa=
d
benchmark with uniformly hot memory, this seemed like the most direct
approach.

You're right that with complementary schemes, the schemes act as factors fo=
r
each other, and CONSIST tuner with its feedback loop might make the detecti=
on
lag problem more manageable through gradual adjustment.

>
> I also assume the real world people may use DAMON with auto-tuning mostly
> because they don't know the access pattern of the system and assume it wi=
ll be
> dynamic.  In the case, even if we perfectly solve the issue, some of
> oscillation will happen.  So, I think the issue in the real world might b=
e
> smaller than that we can find on some specific test setups.

Agreed. Real-world workloads with mixed hot/cold memory and dynamic access
patterns might behave differently from my synthetic benchmark where all mem=
ory
is uniformly hot. The uniform-hot case is essentially a worst-case scenario
that forces continuous oscillation regardless of detection lag compensation=
.

>
> Meanwhile, the node_[in]eligible_mem_bp concept makes sense to me.  I'm w=
orried
> if this patch is unnecessarily delaying the progress of the main change.
>
> So, unless we have clear evidence of the significance of this issue, I'd =
prefer
> dropping this for now.  After that, if the issue turns out to be signific=
ant or
> this solution is proven to be significantly beneficial, from your next mo=
re
> realistic test setup, or from real world usage after upstreaming of the m=
ain
> change, we can revisit.  What do you think?

I agree with dropping this patch for now. Let's focus on getting the
core metrics merged first.
The cache mechanism can be revisited later if real-world usage shows
it's needed.

Thanks,
Ravi.

>
>
> Thanks,
> SJ
>
> [...]

