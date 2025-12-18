Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7077DD68BDD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE1F16B0088; Thu, 18 Dec 2025 02:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F946B0089; Thu, 18 Dec 2025 02:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BF16B008A; Thu, 18 Dec 2025 02:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8701D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:36:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39797B9AE6
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:36:25 +0000 (UTC)
X-FDA: 84231783930.11.D61244A
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4620D140012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:36:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UkpSymSK;
	spf=pass (imf26.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766043383; a=rsa-sha256;
	cv=none;
	b=NPB1cOU1+SKvjXt9c0XuhqNfNk9rNiyi8agXD2zQP/NuBmiCpth2dh/SAuNVdH9PDqsAW6
	ZSIlSElMBh75lnA1c1wbnCRz5nGUUCzyOP0NLW1IezOqkDIOvcsSsStw/Zipsl5gLV1R4T
	Oq/RjTkVLaGUatBMcVlPyDtlekDjmGQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UkpSymSK;
	spf=pass (imf26.hostedemail.com: domain of kdipendra88@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=kdipendra88@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766043383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aIek/r3ZvSZ4NS7Eu0mJEJ0FiVX1NZ7Td7KyjtnmOU=;
	b=CLoiibaznGBMVeD7pNGcVEWppAC+u2mm3EEAlmPXUDTE/losthTYm+LPKj9lMJtFs1a38E
	+nibFFbprROkqFHNW2N6Yx24+qufharSDwTMSWLNmxmz96IEvROf9GPh4ZklAFyG3nk7m9
	b2O4ZUDiltRBnv3pOgJAOPrlHbTBdwM=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34ca40c1213so311052a91.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 23:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766043382; x=1766648182; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4aIek/r3ZvSZ4NS7Eu0mJEJ0FiVX1NZ7Td7KyjtnmOU=;
        b=UkpSymSKVvS3z1b64yMgrixbyrKtXBmLWgEEAg4DHcOHkJCjIw8sHUnRd6tVKm2/0w
         MfyfIUXfCU4z7xMH99iTVpN4dWaZxWwaoL4CwbCrISic5ecXJn4JURDU8UwwVloJMow9
         u5iTnvOTOR+hq4R5NS2yVx8Sh1jpPSRcFmrYss1qkJu3DPRAisDH52Z2ygK2IBWHqqWP
         ans7AgW4w5pf/UOpfFjEdgexhMbid6xzcSoKq0+qVmna8wYCrO+ZwoRIPVEHpBtj69jd
         kRRNQ8OpZXEAd50QVeKtF7gfSv62QbO0a/NlP5RjAzy2ETfiMaXi/HlXh9vKh6PyVDbq
         uTNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766043382; x=1766648182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4aIek/r3ZvSZ4NS7Eu0mJEJ0FiVX1NZ7Td7KyjtnmOU=;
        b=racm22Eqfo14cu5cvdbyWLBc7YBZzsddey8Hk7xmypGcM+A9Hioz2GCKms/+tfPgcm
         YISZl9m/WavL+D+orbb79L3fu0wDjimd02XgP/gX+2rNKn7/3Jm+yCA+uwmp4Jhzca18
         ZCmV7BZLSfgWKbvk+0Pb0pmzzsRFh3kJOqaAXc3ROk84mYT6PA3Hu6yk1HfR3hlB1DgS
         azZQ+l7Qw7a1WVVuTldHw4QIONk+C4/c8PRQbLxnDEDhGIBHaFvWP1oZK7J4prhrZw0y
         85j8uaNHcKvp8wlZ3ToNxVetYX9odc9jXBtn4UPVtupewNsflXvGF0U3+ISyS1B866OJ
         gobg==
X-Forwarded-Encrypted: i=1; AJvYcCUpjm67OT0FFoJ5u+TtdUEkYAH8BmJ5OKTsiiw6oTBT0UNbcfsf9STTKgNH7MHhBmm+3c3MeETfGg==@kvack.org
X-Gm-Message-State: AOJu0YxliAyc2yA19w16LDXMo5CrDXhd7aZGoh8D8OfVapI6LjjlQMJB
	kCKDj3k4RAr18joaD2I97sfRKX5xCi+5DJKTcehBb5Ie8VwP9yvR/V4K
X-Gm-Gg: AY/fxX5KMK/6hiczhp4EVCPaUJKrbhJJoMRugYeUgNbPdq9ohlgPxCqcBEJKMbasQY8
	Tw1zj2OJsIbwbJuj+J2pOkYbH2ypI3oFutG5AfGuSi63D2JcOAzUtbnl8gra4jwhoXBI6HL9LgM
	hbVeEw3XvQU6aHuCga73uCH8vpvyYdSW4awbX2nGJrgBspHYo93EqgWTb+791q+rhTQLoCxDJjh
	wEugFxFL53diqby3M0m4ZHWUdTOb/QH8ejkGrEe1U09eqjt1xcQWGHP54iLLaotVWoetyVA6bf9
	64MWEuu2VueBrDsAjHqf7PtNc4M5hPkX5oxz/HA2KNwSIv7nUmu9z84IwIi/JyMuIX8VG6pHvyV
	6qbSIJnm7Drw1jQod7T66utbemUkS0RkGVHE6WcFO98ytjsBhkY3930srecxPizHT2SGpNTXoj8
	Bo0/2o7TrK
X-Google-Smtp-Source: AGHT+IFvKKZA75dhAyRaTORAr0HnIA2q74dEctLS6i9INOz8BbZ7JdbmOc07paSWeFTnByMaRQX9GA==
X-Received: by 2002:a17:90b:2b4d:b0:349:3fe8:170d with SMTP id 98e67ed59e1d1-34abe3dfe12mr16325954a91.3.1766043381960;
        Wed, 17 Dec 2025 23:36:21 -0800 (PST)
Received: from ubuntu.. ([103.163.65.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e70c932casm1627169a91.0.2025.12.17.23.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 23:36:21 -0800 (PST)
From: Dipendra Khadka <kdipendra88@gmail.com>
To: shakeel.butt@linux.dev
Cc: akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	kdipendra88@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Subject: Re: [PATCH] mm/memcg: reorder retry checks for clarity in try_charge_memcg
Date: Thu, 18 Dec 2025 07:36:13 +0000
Message-ID: <20251218073613.5145-1-kdipendra88@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <hibelxfvkdvm6b2a6vmgdmwcne6e2z2hrshshacepgedduyejn@7kfdegbmwyvs>
References: <hibelxfvkdvm6b2a6vmgdmwcne6e2z2hrshshacepgedduyejn@7kfdegbmwyvs>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4620D140012
X-Rspamd-Server: rspam04
X-Stat-Signature: uutamdm9u7emmeac1gtdu6m7h6sk1bb1
X-HE-Tag: 1766043383-390120
X-HE-Meta: U2FsdGVkX1+RLUxNBtgQHwRA9K8GUwtOneIlAjta1z6PJojtiRhbkpagbyezl0lzsCFjDqcqgg2uo7bNprENkkHiW/6Usi4pjqHikLI8bsYIB569LwCQGrqWuBZIsJ/0aVT7IQdBC1Fau1oB2yps7MHGRJ/F8OpyLeqScZRWejTj7Xvf3LmQkQeMl5mxhPATuProEwX85/FwRPeJBQt9m3G951bCmFNos0tgnLqSPxNH6o9eZIWyrMEvWFwla0CnXASLdFrcNHRX9x2Ne8jeXVamDUaPNk0CohpMwSKygUnYBHLX4GnIVhp1Qrj5tJAfCo/Tnsp8TPqz6uAd18WDx4Z+fetgVkImVXCXncUaBWjO+0LtY8hSxSQecT/RnpjFybxybDFsdwguIt7vGpGmZALbXAR5dwSqzLGzWcZfqKrhQMiQ9vLDl6p3pJ0FtYzfWtEpgX7peco86/occwcqIy8HiqHv1yaNmTkS+5WLXs2whhBDAKsHOT1xvyoGPyR9lY5DG7rAX8tP1jCZ33rJtKGJSvStsDi4CK+Lwtvcf21hv25E8XgHL1/IaD6QAAJfpPr9odDYTzuyPJB0EAyknRFqm8a+2n2TymMEkG1noMyjvhUwGPRNSZQ/oo35xICmr6FhJpUyUfQaJdPfK+iLSnWGuGk/BGz4H2a9KTjTGtV7Hzufk85lGyiXU2pjrC4D4ePdryANIqI3oq75Yp+VNv7Iv1MWC8CHFY3+j7YEl5YwUSUKujfucijUM1iBVtnXsgiaI/xk4jAE/W2as1unZ639CHdDmBHK6jcEGdw1F72BQDpzgLV5Dn3cwuM9KdVXR65iVkpGLJNdK4weIiDkXa8qqFbs/18iQC/qwegZ5YZ3SHmTgU9FmSN6Afeki3gr596yRx4jiJ1cHhv2nAniBGXX4anK/aDR13vWlE3iaLEunSXvQ8P9GDD4mFQpvI87aMj3a78/0d7JZZXZQ74
 +GWn/ZO1
 FbPV8sm7JbNj4Bb1NkBq8N7mWZyKXUIsbu2JNJXHU/xyuld6V/Qi4NAmSW5CBtf0i6sM1eo9xHMkmm84EVxf3M1fpB7SeHgp7BnwXxOJkVvVu+wGT0Pq13S6j4W46+3FQk/JOip0bhftmSqsxDb9pXyAvQDDNhL2p+NkkplCfMnqsV4q3z5q00TLG961ahwS5JFHeCV6Tj4wa0djMDfntTuBH7tP5WFte4/4yQTgrnUa7tuB++8DwlOM6EtV1pzATAyb9JJArzob7BBfqGnW5PCzbBBhqBG0xziehydJUI/npFUId2PMUgs82kVvRZHfrRVXA1Yb0p4pepysV8HHfKzIvDETjUOOorzF/fdc4qjtEyQ5XfGbEdh8MI5p4GJWsTLxk/Icll+EM49xQEW83UHjEGuRN0cAksOLDwuepmqylRL8rgzSaqKDvXhymnV7tJRHSDosA917/oAQiY4rQs6JEMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Why hopeless?

Because in this specific path the allocating task is already the OOM
victim (TIF_MEMDIE set). Any reclaim attempt performed by that task is
unlikely to make progress for its own allocation, since the kernel has
already decided that freeing this task’s memory is the resolution
mechanism. Reclaim may free some pages globally, but the victim itself
will still be exiting shortly, making retries for its own allocation
non-actionable.

> Why optimize for this case?

I agree this is a narrow case, but it is also a delicate one. The
motivation is not performance in the general sense, but avoiding extra
complexity and repeated reclaim attempts in a code path that is already
operating under exceptional conditions. The early exit reduces retry
churn for a task that is guaranteed to terminate, without affecting
non-victim allocators.

> Since oom_reaper will reap the memory of the killed process, do we
> really care about if killed process is delayed a bit due to reclaim?

Not strongly from a functional standpoint. The concern is more about
control flow clarity and avoiding unnecessary reclaim loops while the
task is already in a terminal state. I agree that this is not a
correctness issue by itself, but rather an attempt to avoid redundant
work in an already resolved situation.

> How is this relevant here?

This was meant to explain why exiting early does not introduce new
failure modes for the victim task. Even if the victim still performs
allocations briefly, the slowpath mechanisms already allow limited
forward progress. I agree this does not directly justify the reordering
by itself.

> Same, how is this relevant to victim safety?

Same answer here — these mechanisms ensure that the victim does not
regress functionally if retries are skipped, but they are not intended
as the primary justification for the change.

The primary intent of the patch is to avoid retrying reclaim for the
current task once it has been marked as dying, not to change OOM
resolution behavior. If this rationale is insufficient, I’m happy to
drop the patch or rework it with clearer justification or measurable
evidence.


