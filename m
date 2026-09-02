Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4E62C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:33:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29AD6B009D; Wed,  2 Sep 2026 11:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E00D66B009F; Wed,  2 Sep 2026 11:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9D56B00A1; Wed,  2 Sep 2026 11:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A54D46B009D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:33:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 470EA1A026B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:33:45 +0000 (UTC)
X-FDA: 85169217210.07.2853817
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6608A1C0002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:33:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EExHSgcl;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jAwZDI989FVdGKLvHqYjpHzJ0A2k3qSizrEVsIJoGK0=;
	b=VoC8Q43yFJcHM6PP3sNaycbtKqYtbg6JXoog7NuZ36R0IcNf9tnctxSdGQsboZyy5b975E
	UNts/Pc9q7RIEmjz0v9BDppaTK5ZbcGWJdXzwLy/gCgElWWDwBMUujeO4WzX+Jx6Sbc2yn
	+rYeW1TMAblwbsRY0O3aeRs9LKK0b2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363223;
	b=GHAc2dDGj2EmydN3lPWI/VGba3x2/5MehXOjHmdkrUb8eSq4nvXaHCt7ODCNxeLvN6ORuj
	0EgrFW5R7OmOk8a22o6QgIaVDpxccPPcv/wfDgHEo7F5DHk4CEkVG1yqaIthMRn93cpTUI
	I8E2sa25iFBTQdQha2fIuDWAtK9p6nQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EExHSgcl;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-39647184c73so2359453a91.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 08:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788363222; x=1788968022; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jAwZDI989FVdGKLvHqYjpHzJ0A2k3qSizrEVsIJoGK0=;
        b=EExHSgclu3rpMNQaqiOwe2scBzkWX02k9zbkILT/oW+abU+DAKSOdv/eJb0KahpgLp
         ZFK6RZg8PyuR2I5t834TB+HeH5e0zw6rcIdcCwa8XJ42L11MTrpt7OwIxmKTNuB/Qnl7
         FYlq48bOB9xSODhzL7lS7Oq+xJDjdj8M1TX69zSt5RHrMpXFrtyJNgPyFSPwWA9tmrDV
         IWgwjSyHquDZ6vnFC6zjjDKZdJEdmJT9+8CfZ2Lhd8eRuGJqDMDemVYQJTARLZrZa9/E
         EGsOU/SbBDqxhQKJQOfaOWgL4+IoB8LOtLUqXpLakwZblO6SXiFwExoPzEhxkbpwH8PG
         TWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788363222; x=1788968022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jAwZDI989FVdGKLvHqYjpHzJ0A2k3qSizrEVsIJoGK0=;
        b=rbaoEDbdNwpVSl4U0tDrOy85toaYQC1KnoL19Rvjjm1ogHOFLEE6hKfZCtx6IyDgm9
         exZPFNnYBctwrF5BYa8570KnuhFXXnv04gvBAlKFyl/LEBHoGnweZbIJneB7++egebp7
         O+Tp2cqugvitt5GL6QEEAI9uMuoPGNUPypVlD60CHQpmoKmCemVJq3+yrGfQkDN8xCgF
         FOETdj/0+Ss7W1t/Dka4mFep/287wiqWH1SUC+VG3dFatxJJqYF0fRY0gds4OwXnLQ4v
         7CG+ujz1ml45tOXm/9y9K4yYNGtXQYscyHFlevDygrrcHAdrOhn1c4mZWznoaM4VtnbX
         BE+g==
X-Forwarded-Encrypted: i=1; AKwUvBw5pDs/cAqu5RJkKPDxuPspIarXbx9WW7DJgggLwUbVURnscfWausTPPU8q+6cQrDwVkppmvdq5cA==@kvack.org
X-Gm-Message-State: AFuF++kAi3Pt3QAy5BeP/9YGsx7nrEGgkavmULCR3kS4ojEPL+4eITXb
	H0XL/aMikEfwUffByENUhaBTRj9qrB4kBd509OGBv3v5l5LhN4upFni2
X-Gm-Gg: AYBFou2G/aWuR8VTYXmq94W4EPzG2yQ2AjnCJpJQ71xzoTF/RcteZr+KkR6cqPuqmHS
	b+inXKby1AMm2kpilR70xwIDsXJnoqGWOr93XW+p9lwb8TKWHNnSVpvcqUpcCAI46LqvmI1TO6S
	aBgEfE5Xsq/4d/2H1LLX2X/SNafv/JJtxuRRhs6XIJbFPrlfyOrCg3CYbrbw/aLAdJ+hBbhDK9B
	VHugi2Qc15nNTgu2ChXFar4wXXjhIhK4mbZxBS4xct3pfnOAuDszAduH9ltUO6OEquWBtYl/Kl/
	S6vO/YNqFZ8PGqMrvbqZvTzO41lavoOIjjAHgDwWthVDG29kCMt+RcKx+aCyAMhrIhdJzERJHNN
	rgzb65bF0VI6/PV7UyLiAbWABGrhjZuaFWzGgeMw1eJ4fmHZjhEyR3OQ3xQCnwMURLJ1Xldy8+G
	R4fn2gjYOrnRu0twoa7jkPNl8SpkWQ1qOK8DPZ6RIbEtjm6HoQAKDtr/IyGl4=
X-Received: by 2002:a17:90b:2704:b0:398:ba46:1d9f with SMTP id 98e67ed59e1d1-39b0860c252mr15953a91.13.1788363221587;
        Wed, 02 Sep 2026 08:33:41 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08627417sm4966a91.12.2026.09.02.08.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 08:33:41 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 05/12] mm/damon/sysfs: remove probes number validation
Date: Wed,  2 Sep 2026 23:33:33 +0800
Message-ID: <20260902153334.4034394-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260902143706.88115-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6608A1C0002
X-Stat-Signature: pytytekrdwnufkptfnecxxtt7fffn9q8
X-HE-Tag: 1788363223-440322
X-HE-Meta: U2FsdGVkX1/rVWpWjkg+R9WH6goo7t6+Tl6FcjBL5FK/x28184izdP4E67sQP6HeqBM1PtzdT+yES5LjV0i8jQyQHOe8It708MZhHY7CdQQ6rHtMvFypgadIFlGP/t8cE1GWSXENQBQuRjCOrM6K0Gx2hyIInKHlHpv2HNCNi7NcI/myBYkLdj78yag3rAlj6jPLfHcbEvGJedn3B2tWLtPbzx4Jj25bY6S9vd9RhRAB+QT6eZzilkAGTdqRHY7Z5A2NZANV5R1qW123iAHGA5pQdwzUwKVqn1Cc/GM7LruJpcIcQyOIonJLQEjhjLNj3kQ48n22SzWoR+fIafMjyDqQQNPaAmNkCPK43KMib5Oypg8G79YUab7XrG3fLOuDaHiOOLW6rGRAB5LSuUVmMcWmZWCkjKsC1OEbDK4Ibn5bUq+94PTp1AjmulwxhLtOPiK+tu7zO9AEWMIBjCYUoJQc41tXEWp43V/hxINCklxinY9659sJuzOKsuWWF4poENqRWNMVGqpGvlujmH9UQUtcajBeX5bRK0uU7JiarJanSchYGI4ahOkHjjaH6j5YTPNLE687mQdk7R7Jx2xyNJfYDBUMnn5xd+pKnh0SZq+VKBpoUo2nmP2NYA8bm9vjE8lQTWUqDtjYse2yw+7xrA32VV1In6NdHtI8pQ5lXmhhWUPUyYUHy0CmNYqLWzZ9S+TQ/SwIABgRJhUYBX+IMpdB/I2HZxqAFrfEPq86+sWoZCQaBFbbwe9C1FcREpqT1hHps5ad2/cy2jbPqDIiRRKV4q1yJvp3pl0p9VijpVUX6o839Zil+fhcmYGdIMQqair5haTDsSdmDzNwuFG6NuymImIEZNNmFOg3ZST5lnm3Qq+MgNlhYtEUJTD9vGXk/xLXgC9hhSfX1KMxbfkHFcmU8i1nGfHt744yI+rBDm56P+n+ZKfLz6srtWsqsmop1T8v4MxhkF5Y+Gn4N3/
 ls0E9R7G
 aNmFADkAqKlR++q1Gj5wO4OnHdYwuksP5cMg9yidNybSvOnDiZTAiVBYDEKFSCN2b9eSSs9d0HRCFD4XVRQH29uaNgZw5XF1Z0m1VI9uHd4yOw3Dzm3rZ+vSnE1bq84PMnaaBrm4pLQmOR2o6R77xGfgZCe8HavjIec8jpStXk9n4TWyJktrNrUH2XqDBIH6mGs6XlQckTlDnyOkH8ozqTdtbciCX/Ah3C82emgvgQ+RgN5dE9tibvXtHDNETt6b2ndI0xjyCTRmLNHwNu4Dw8BWYLnj5GxBIsG64UI84jjc8oohJYk3lzP17cYC2bQ7ypPyfYcq4bit1VL5gf+nyPpEXx+/SQf8Phmx1RowrygDfhoHQEg5UW6bliczczYN/g3Ok5wirtyhREoMkO5rQdOe5ArLeYxZlxOnVLeEDfTzNyXfO8P684SKSEPwlveEpxBOV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 07:37:06 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed,  2 Sep 2026 22:07:13 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:
> 
> > On Tue,  1 Sep 2026 22:47:38 -0700 SJ Park <sj@kernel.org> wrote:
> [...]
> > I was wondering whether DAMON_MAX_PROBES is purely a core invariant
> > or also an interface constraint.
> 
> Thank you for reviewing my patch and raising this question!
> 
> > 
> > With this change, sysfs allows nr_probes larger than
> > DAMON_MAX_PROBES and damon_sysfs_probes_add_dirs() will start creating
> > probe objects before the configuration is later rejected by
> > damon_valid_probe_params().
> > 
> > Since nr_probes directly controls the number of sysfs objects created,
> > do we still want to keep an early check here?
> > 
> > I agree that the core validation is required for non-sysfs callers,
> > but I am not sure whether this particular limit should be duplicated
> > at the sysfs layer.
> 
> I agree the user experience may be not that good.
> 
> In my humble opinion, however, keeping code simplicity is more important than
> the user experience here.  After all, DAMON_SYSFS is recommended to be used by
> another high level tools like DAMON user-space tool (damo) rather than human
> fingers.  The user-space tools like damo can do the early check.
> 
> Please feel free to let me know if you have any other opinions or questions.

Hi SJ,

Thanks for the explanation.

I agree that keeping the invariant validation in the core layer avoids
duplicating the limit in multiple places.  Your point about DAMON_SYSFS
being mainly consumed by higher-level tools like damo also makes sense.

My concern was mainly about the temporary creation of sysfs probe objects
before the configuration is rejected, rather than the user-facing error
message.  Given that the number of probes is bounded by the core
invariant anyway, I agree that keeping the validation centralized is a
reasonable trade-off.

Thanks for clarifying.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

> 
> 
> Thanks,
> SJ
> 
> [...]
> 

Sent using hkml (https://github.com/sjp38/hackermail)

