Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D639ED277C1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 17:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D0836B0005; Sat, 10 Jan 2026 12:48:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17FF86B0089; Sat, 10 Jan 2026 12:48:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FBB6B008A; Sat, 10 Jan 2026 12:48:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E774A6B0005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 12:48:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 352F5B73C1
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 17:48:36 +0000 (UTC)
X-FDA: 84316789032.24.64B97A6
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 50C7340005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 17:48:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cM/t9/x7";
	spf=pass (imf11.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768067314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqIAwsSkH1LRn7DpHN+juv5RfTbIQFu9fzTgJJtz8f0=;
	b=JSjcsv6EL38dTjp7a4/CcepHpp1ZcahKb76TPVAUSsboN+DgB+EnKa88MIWf6XtI0qTtvZ
	aJZCrCTB6o9MvQMZNE4UslXkLMDLdxYsEAIX3unVRy0t/x9BnwtRA3eNwQtMxEvCGx8GQe
	2sQOuF+2VWn6hAGay548w1ExeGFYftk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="cM/t9/x7";
	spf=pass (imf11.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768067314; a=rsa-sha256;
	cv=none;
	b=dUyP2/YzvY1NH+iawGMXev0bxtFehv4l27UalsCvenECxGSjtHp01zHieck8cdnIu3p4jg
	EKqb1TrgvQGU6nywf1QpHBZWvRlU49mMSIsbFz7vKSj+TwEe3mLAYjUyR0l2kmSEF8ofK9
	oZwbpSYtloO6fWEe29axN5hoDy1UgMI=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8ba3ffd54dbso781541685a.1
        for <linux-mm@kvack.org>; Sat, 10 Jan 2026 09:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768067313; x=1768672113; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iqIAwsSkH1LRn7DpHN+juv5RfTbIQFu9fzTgJJtz8f0=;
        b=cM/t9/x7v3e3kOSDioO2bdhJZuQr+x6KAdbKwfbyfXUE5I77bTBZfKqk4OThTY2Gou
         EqiYUOesxn2/ZjATJpHsYwOYfzQC7ge2tieeMsjBo78XkEhhKMnk1IIhhxCwdXz6KbGL
         OsD0z4kyj+1KbfrVfFG98fs+OUI/uZUWVZ/A5+2L/P2QKeinYOuLj2zDRistwi/eZFCE
         /tH/eq+iokvBZ80GDDZXAc5Cz1hvp4YMuMUPzhVHKoR+q71QXTbcppCX9E8DxPfaa1+b
         LnqqZ8shcUPhi+e6RC2KKPsTNHLoKCykluWUkgRYpv+J9C9igvnJFYh7z6FcjTWjEB4/
         sbww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768067313; x=1768672113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iqIAwsSkH1LRn7DpHN+juv5RfTbIQFu9fzTgJJtz8f0=;
        b=EDN7WaOxYm1xsjaw4aGrPZjnJ1vHYFWEj++LYgzNryQJUrYcNLUQ/+JVcD7bM07fUL
         CiLm4EsAY+TnfGeevHA+xj7pS5CSvD+tbsVUQdG04ZWpD0uuupVHr/riTf6cLG3rMGv2
         DV3kBLnx8yC+mosiJrXXPiKwyfu5+fh1t09ANGROSTWO1Kha0RUH7Q5OsUSmdu11nfjz
         NAwjv1n0JgAxpqrxludvQecXFvRtW9f25yTQEo1gK7d7kUu+h7XVK4AW/b+60TfsWsK7
         +gCKJk4t7RvKrUmAOqrbPRr0gfmp+yJlLHHM2TJnOiFs4svyheRLzEIQaWhi8CqVe9SI
         mnrg==
X-Forwarded-Encrypted: i=1; AJvYcCW6Di+d/iFYt4kpPkdEN6RnDsIsdTZrhYjmX9b3TBikxtExxlPl/mBbAAfLG+KGYh8KjQ53gNwyYg==@kvack.org
X-Gm-Message-State: AOJu0YyhL51DhW1d2QtHFkNlL6bJuk6Bf7oYqbLvPOfDD2dBBHUclFPB
	UjRRC8DDuuZdtFwglDU8SsVKB3koi6RBYIt6bdbytOPXejIQFDMlDrS4Udr6vQ==
X-Gm-Gg: AY/fxX5L3GkDo4cp1uudIbfT7fNtHmSm5gJhNuh3RCLQ0MuCUMa3FwYyNJWkIR/267p
	rUoYzNMkDGXQJvX6Ycl0w+QSJXDEV0KiCj4VALiMfVa4p0hCzZL3ukSReJG/yuTP1oUKA1sEiTU
	XyjRPdZNr1NVFCqYiOTcdyxa4wkzo5TF+0bD8a8dH5ZuBxL+Z8KUJTz5+QZ/DKWyGmo5QV8ynL6
	C62te94REQHTZCTnmsasffSRC4RF+lxJVuCulI9H2m+w0rW5PpdqiIgqjdRu1074Hn9bJZAsBdE
	+/DWQh2m/4ItshNkrfpzb6OhLPfi6+lftHBv4BsoJ5oyGKl6puYmKScCnFyYTQPsDDo31IakMXp
	TFlCqa8M18OnVm4/rBAMLNOdlE5q+pR+6GhXA7etbEGrFvEfAUl8+7784mOsJQbKVI+s3m6v2Vp
	OVuG4u9WJh7yfQi27um0GIkUrguXc/spJA+/lipqoEJdke02ktAxk87xiPZ9FsRcUMDBf3Rebii
	8YUswboMA==
X-Google-Smtp-Source: AGHT+IE7ltzgQjoPiBN4Yv2Js/6C6/LS6t10HZYVZxNM27qcbS1X+Y/3pfVEOz+ccq0rpo3AXUIhkA==
X-Received: by 2002:a05:6a00:438a:b0:81f:4ce8:d641 with SMTP id d2e1a72fcca58-81f4ce8f745mr183507b3a.37.1768060842363;
        Sat, 10 Jan 2026 08:00:42 -0800 (PST)
Received: from server.. ([103.251.57.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81f36f88f4bsm2513245b3a.36.2026.01.10.08.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jan 2026 08:00:39 -0800 (PST)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: jackmanb@google.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	davem@davemloft.net,
	david.shane.hunter@gmail.com,
	david@redhat.com,
	edumazet@google.com,
	gnoack@google.com,
	horms@kernel.org,
	khalid@kernel.org,
	kuba@kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	mic@digikod.net,
	ming.lei@redhat.com,
	pabeni@redhat.com,
	reddybalavignesh9979@gmail.com,
	richard.weiyang@gmail.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH v3] selftests: complete kselftest include centralization
Date: Sat, 10 Jan 2026 21:30:27 +0530
Message-ID: <20260110160027.128949-1-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <DFHI984SEFV3.2JL88CLHNT2SO@google.com>
References: <DFHI984SEFV3.2JL88CLHNT2SO@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uadgj9j9hpyg91kmwdfkxhu8breg97bd
X-Rspamd-Queue-Id: 50C7340005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768067314-340866
X-HE-Meta: U2FsdGVkX1+9wDyVX2lIenUBhgv2qGFmjHeDcoL3WM0aQCSQ5j5Kjx6ziHvBRqjIZuMd8GHq++f9L5OvGgCe5zlfV5/LxefHvGBVoXXuM4VVA68pWj9qt/fP57qBXXOIqfvEXs2HBZbtWxTn0sSN9yDJvAo01OH+jaJ4X80xDdWhOOqjT/PaZDFqqDfvTfpzh2B9ZjFusUI3AG30PbdxQFcRvao3K+BYg6DIrFJ9+pXaqlwwDD1twCK9PP6QPyiiD0byEWagDIOvNVaYd+dzDiGn520HxaMqKqoTNSRcdxXWK/+fkqP8b7PGxgM9yUQd9bU4WX480tP79tGl7P/Lm1Y0tSY89CpPcLyG37vWeQYCxJtAM7mjWbfJ/zwKtiEZON+PiKkJ3vSnZiv02k4WCcw30zazSOOPWVcfRjHLa2JRaGXrdQykciYkhul3iu6FSjefDLmpfSm59eeOG2qhm4Gqe3a0FRmqlByPgJq52jb3pcDI00L8EfbMKGYC6loO62ut/bHVwZqasTIkVVUhusYLXkERY0yZre07aOh+bah7L/ieAePZrulJLmGVz1eqKKaeDmUPGZtMt987ProF2laH4C9qCmkC/xQY5IVLhdCpzsSGqaIvfxg7T5IT0H1/T1NNhU0/nwgptOGvUobIOPNGLnRkXN84tu3AdKVw10kXXOVyg6I4Qa//BMIWs7N5Cao1DSWE4ozKQlLQhkh0e5b7UaaL8pbN5dy8P1eop14tWjkNI2rOjWh56fh01ujtburY1oZgwVDpdW5OilVW+UKnC96fag5LR3BXAC67ScVuYh5NcyLFLX9hNnypq/dVHkWWdu5c/mrUNKqhUusV8QtwQqWKqF2CR1Q6ED0g7VhliBy7aHCIO33TMPX4nzdgrmjm65REjjxUa3jLH1QEM+Vde3bTZ4s3KPa49PZItAPO0G3SH35aATCM7PRSe5XyZ9Osyhstyvfjgyid1KY
 /rlMa0K7
 xNvEKy+Uz/TYHQXMrvV3WjPhv0v9zxvgvnZ8ieReG2Ab4LC1AlRO4dmf1sbU067mHRq/9GApLSzaRRURO8xjmCq8oOg4+cntwetS77c3UuwFTzEWw3Hdck9du2TRxQ3cwYNjvH28HIZG8mi73BKMmazydBw7QEjJn6DDOmfrwWoUrtBwsascOmQIPS0Ic0w7MnWCb9cRZsCL219oZVoAiPA90mh1pPajiYT35AVeugWvSf6vwvt/0rvRUBj9Godm7QNN0lv0RnTYgTy22E2MWUxV8ZltNVyUWKLQuquj5SqmDz6txWxayFQJ+NFrwyqH9cGIowaVP5PHxLKg2yHITsCkn3PyjkGS5FifQTxQGK1hebN8r5JwPD7/KBd4o5DOH1PesURz3ooapJ2tefGE3+31LmJZr/gq7nWCCtrawXeFKTFuqWJP4X+RItkuEumxk5QVfcskAQuEveYVojzDtuUwHm/Bb8fi51La85rq2qrhrXazoi/XQr23VN1lExnoHZUFccatM3jytqmVrtdDghjTlKbfbP4prFm+EcHGIf5SfOt/Kyab4ukjr+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Brendan,

Thanks for the report.

This issue is caused by my change that centralized the kselftest.h
include path in lib.mk, while the x86 selftests Makefile overwrites CFLAGS
with :=, so shared include path unable to find kselftest.h. The fix is to
explicity add the selftests include directory to CFLAGS in
tools/testing/selftests/x86/Makefile.

I have already submitted this:
[PATCH] selftests/x86: Add selftests include path for kselftest.h after centralization
Link: https://lore.kernel.org/lkml/20251022062948.162852-1-reddybalavignesh9979@gmail.com/

it has been tested and confirmed working.
 Tested-by: Anders Roxell <anders.roxell@linaro.org>

Once that patch is merged, the x86 selftests build issue should be
resolved.

Thanks
Bala Vignesh

