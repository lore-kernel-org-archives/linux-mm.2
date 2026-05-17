Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73601CD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4216B0088; Sun, 17 May 2026 14:37:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B586B008C; Sun, 17 May 2026 14:37:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1506B0092; Sun, 17 May 2026 14:37:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA6066B0088
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57BA81A0654
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:05 +0000 (UTC)
X-FDA: 84777768810.06.A077CBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id CA3A81C0007
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJKsRJoY;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6Aa5eKkMwUelI5XkyTUXX01aoQYDvyJ7WRwvf6ObAo=;
	b=qKLeFAWu4Rn+QMSklQeWhWEmecaty43c6xEspcF4dOLNwoonXN+kxDxcqu/v22qqrFqPZ0
	CE3Fqvf6YzOsZ17aniy+pt+oCYqQ6vGk4d2wdXyeVK4inICH/CK152BfzL1ezvDJQ3GrmD
	Iz7YuF6Zx65Z0yH0Vfsc3MBILKmzrzA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZJKsRJoY;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043023; a=rsa-sha256;
	cv=none;
	b=sgY1dMMLq4QEMKY+tPrcE0zHc1nU5WN2Hb4bpGCq6tplArA3qCQ4sznb3ObLVnNQkrMy1X
	4ib6XRXQg7Y49tE8lHPUODAzsqLQ0/bDAwnlWGclmBvO0d6p55U9IVUas5+s8/kB9IyrY0
	PnvKnRrShlmetng3kmCRnOeNsrGBGXY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1ED1C6001A;
	Sun, 17 May 2026 18:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8FAC2BCB0;
	Sun, 17 May 2026 18:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779043022;
	bh=C+SyJKDLu7Bb/+Y2+23ar4XFJMGe57MICkLTUWmQqus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJKsRJoYbsMp8e+Oodzd2DVfcMy73uE4Ln23GQaU/fKTFrbejdbatIIMTeegftDQW
	 1SqH+2mwthlzpr7tTchvLg4f7iofCT8UChl7AP1nr1UHEcDp2FLEJPlIgzJ0nvmWT7
	 Q+PJNlR1Bte9prfsQKNuREHoLJXm49whuzTTG+p0kQI9JVIAnq7J2GE6KsBqtQRCCa
	 53B9HRtymr2nH60XjCW4Rf4k7F3YCqWeVQ06B6lkJcld/1lve/+aLgl1caw4671940
	 a1ZhdOu4LJwWmpVwggYkYPB+oklX9hZ0ZF1GQE3MQja22U3w/YwmKIWtcQjeCuTm2/
	 vY4+AwFfHU0kA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 2/5] mm/damon/core: cap effective quota size to total monitored memory
Date: Sun, 17 May 2026 11:36:57 -0700
Message-ID: <20260517183658.4510-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516210357.2247-3-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CA3A81C0007
X-Rspamd-Server: rspam06
X-Stat-Signature: b6pis45bhqh1gjkie4eem7wwo8y9a1mz
X-HE-Tag: 1779043023-254994
X-HE-Meta: U2FsdGVkX1/rlDLOXpqGpVJCB7DQBEAKNvciXhEGU777RiUyI0Ms+TFgGgQdjsu/k9XSeOnV2JfL0Y93tk2bYcVxQjL5qN//noy6iCuQbuGqgEqFBrBYdkeHd15KmxyF4ULpNTSSw5di3dPYibWLwwnI9SlVcB3xiFTTe58usxvFZRPX/TwRBJXFfb/Z4xL9ZxSZdIn9XqoJ8fANx1WUGqmmGOrqEr7vB4Q4c0TG5Kxg6PLN4rx85PQ2Vr70Zo3sS18nr9GjrQkwThACTujQiNYPPNGhRA2L5RUOM0OWl/j/R3nVQb78I/byxmbegw6hsCOPmbUrZDj4hPGnqu2CedtudlEFzvqfydG/izdMkbjIjNr1voRliY6cL7e6Z3/VRifkhnah93q2hJw+5sSOgHpWP9DgTFBTw5b0rRzYbNMYEms0a9XQ8hRKhFDlzdBej3AoWel+AJGyxpKOWWIVUpWWV+KmD9ZqG/KFwF40zTEiHI8MmfWpvosVbawXDwii57Bs+G37PUjOZGmXg3jPIG9vLDI5jHlNx6AtNRDRQNugP/QiZgsAeb45Zuw22LYEh9aPoUcMKfap/6iHqvrq3ga1hty0xvNro08w9R0slfIuY14WeU+r/9aGfbh4s5VLcu093XOXSGHrvIMDf8TkS8WXHAOvDzJt9HxwlBBJJCF3+5QK9/ITVKYhKKyl4tEEOh2fr5zpCMNHoot0znk16ZHzHorIhpkW4wOLO4ng5R+36DmeeCz6amzo1YODCw86yHITe0mMVbqX0yoOLvmBB0E59MLTbhoCCkwLXy1PZ1Ik6mhU6CL26vvg8scCN1Eg905Iqc1tpjr4CFlziAkX+YV+v1erdCkIe4dCwqdfbixY1P5vYF8q+qPJQUBFaP1jvcGZcPTQcroWKL/Ktz0BpKf/xVhD0Sa89PsX8ONwMxqt4KeDDV/Ca0Pgxf3K8l+wFnDXNXgqiMGDaCv8urN
 qU4xcNin
 SvLY6SAqE/4gS+fPc2ytK//XLFxm8idlrvYo9vrohccvsuQIuPyYg2gRm2px40/eBqBc28vrmoaW8ER02d8Pawtdh6aIszT6pyav5Kkd7P9KxT0+HwW781aJ9j/qtpm7XnHhzC+EEBQZwdCU/t2M+nvzOqxOCUqKZh487PMaT106qwMMWmjA9xDeyGTPyShVqPgD95OLIyIqUi26OssGRr4mbrKxmAIVJwoct9fhqMqy2r7vtRsbOh35+X6/jsGQSu/NShsygZASMLGu1Qu1IjBbJF74cdIQYuaSE5Rdic94P0rSPgFlXsSP3Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Ravi,

On Sat, 16 May 2026 14:03:54 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> The DAMOS quota goal tuner can compute an effective size (esz) larger
> than the total monitored memory because it integrates over cumulative
> deltas without bounding by the actual workload size.  Once esz exceeds
> total monitored memory, the per-tick "remaining quota" arithmetic
> stops being meaningful: any scheme can apply to the entire monitored
> space and "remaining" stays positive indefinitely.

Nice finding!

> 
> Cap esz to the total size of all currently monitored regions as a
> final bound after all other quota calculations.  Add
> damon_ctx_total_monitored_sz() helper that sums region sizes across
> all targets.

You could also make an arbitrary cap by setting the static size quota.  That
is, if there are not only quota goal but also the size quota and/or time quota,
and the different types of quotas disagree about the real quota, DAMOS uses
smallest quota.  You could read damos_set_effective_quota() code and kernel-doc
comment of 'struct damos_quota' for more details.

So you could apply the total monitoring region size cap by setting the size
quota of the total monitoring region size.  Could that work for you?

Adding the total monitoring region size cap makes sense to me, and I think that
will make user experience better.  But, if the size quota based cap works, that
could also be handled on user space in an easier and even a betetr way.  If so,
I'd prefer the direction, to reduce kernel code complexity.  What do you think?


Thanks,
SJ

[...]

