Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA3E2CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A617D6B00E3; Tue, 16 Jun 2026 17:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11956B00E6; Tue, 16 Jun 2026 17:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901196B00E9; Tue, 16 Jun 2026 17:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D1126B00E3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:40:42 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C06618CC84
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:40:41 +0000 (UTC)
X-FDA: 84887095482.18.B54E450
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id D53638000C
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:40:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="E/bskc+h";
	spf=pass (imf30.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.222.51 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646039;
	b=CkjevIQtGvHU/FWk+v1g3Ozk2WAdcQWxjDMwJ+oa+pjEKm66q8xca3vcq5DRGDKNA/lqn1
	34KRgh7L3EQfls97VLulJq95UhFzzQ8devReTeMh9HmGcwoN+n++oDimyjHBI7nq/K5d4l
	VW2NcpdxV4hehjRn+Gx0BJdWJk27c/4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="E/bskc+h";
	spf=pass (imf30.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.222.51 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io5Iy60EaEehs/SAM7BmWdrkxxubi4IFixGkO8CA9oY=;
	b=UhUWHcCeVeUpr16GBKONanAzT1nh8PgxwPLUr8HU8xxuoulUdWQr/MUR47hgy0FnjISp/e
	kLKx8xBRS5RqV9R9DkhMD9ajkK8//ONIWxLmIR75HMcnxxLK9vRGiH6UWksHoaflAwjDNe
	jspwTCvBdg1gvfvMrvoKVrgW+kCiHdk=
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-96358d0a024so3287478241.3
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781646039; x=1782250839; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=io5Iy60EaEehs/SAM7BmWdrkxxubi4IFixGkO8CA9oY=;
        b=E/bskc+hSqMe3LLSTZhlhbJts0VvG4hEn8H1mXuMay3hHC0EQFXH5K9cLBStK2YcbR
         +qYXwmTAv87JUdQlznr+px2yRQ9rlqxvQXLOLLx45LBJdUb49rsJBMS/5LZhenbQbuBe
         SYp1mwKj26HM2BoEEfH/QFxllZP97ah7LgENdCAluO11aSSW0UzIKukGO1luC7fVJirN
         Kh6y9hxpp7ntryhmkY7wQo3x/5qZ4ix1XZTNBAa6EsySD/Uie1Lb72XbFMRL/wBGGDMz
         YU48OmWGGFD9Xq73pbcuipVEy3xVObbTkQEYsOQDMSaZeOLl0bvGrbtmTOQtsS6evdAW
         sBwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781646039; x=1782250839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=io5Iy60EaEehs/SAM7BmWdrkxxubi4IFixGkO8CA9oY=;
        b=KAsLc8gdJBAV9vWejd5mMtGEGbl5kC/vi0MsWwx17OpRYx4M51ZCEDliqYzNiTdNxD
         1RiH1dldFsWO6cPTjk/jruvMF5X0KCqvUY9rwXifkV4feiS1FQRTIJ//ruah3IQUuG1o
         Kegfy+jxoj4r1Qey+Bhq5fcLJTowfKGQdNYM9RGeR2vrtHG6StQti2USTwvVgb/Wnork
         BZFuV9b2Scj0Ej6HI7xqISG8RVbAp/5pX5MPcay1JdMVgsgw197OSvFMCPfy1MzTSLlg
         y4IfhOxPlWjpLtwinTS4pvCCiaGfbSomsdq0zAvtpM6Ye4Ftp/2hYvSZDajoxcAvTdSD
         KYUw==
X-Forwarded-Encrypted: i=1; AFNElJ8Df28qLt7JH7HoxFfMu7NQqJZ8T5gTpNPff+/P9GIIx/nU5ujhvBJH5WJsovOqF3l9zq33gfT35w==@kvack.org
X-Gm-Message-State: AOJu0Yx+kF3YJr7WyapA3qFvAiUTrx4shIf42fPrx38wE4F3zjA9imt9
	9VACkUqZF1mLalFykD2DuomEJhxJNmXqhg5iqcsgO2ObQppd2IipoZN1yWCcrfj8
X-Gm-Gg: Acq92OHZ/MOX7ByrS9XKtbhcAfti7gC2QlU7CLxEHGCwKwVHQWF8v0iwexO8frErjXw
	n9/f//tryEq6PtC/60ogwcK22t1yNpGQpAyHPSULGatIjqo0JaFCQdwgOhgVnUUiQeNjM+DTJYF
	/z+PF2D6i8TM4IeUvNH08PQ5GlG7Dac8DkFumF5w9NkHf/FKseNnuFFs083cZPKSbTM2Oo6eQxK
	TfNaE4GC196/rUe0fgEHXZ9SD1iq9H4VAsObl60WLU214K2xPqNiDktlrvuYE4VqNTKsTU3xZNP
	GoFog7DTBvjMv4MC+heYb/OH3k8HbV/WxH1BToVu7Pf6OE1oBzL+FdhF7lmbroz3cGZxuAdS/eg
	l80UuuYj78uhgVY48QKJcAQEmI5a9YNIxKZRjhzrsbsLk3vLJQWWAQt+k1P9kIt4fxitutmcBIs
	mzX49EpcIndbjt/MHpbrWZcsu1kQxVJRMqZh564aJRbXWhaTD1MgWdoliu4AZ3W68=
X-Received: by 2002:a05:693c:3742:b0:307:26a3:75d2 with SMTP id 5a478bee46e88-3093551c319mr9101525eec.7.1781607435657;
        Tue, 16 Jun 2026 03:57:15 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e489621sm18611115eec.6.2026.06.16.03.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 03:57:15 -0700 (PDT)
From: "Guanyou.Chen" <chenguanyou9338@gmail.com>
X-Google-Original-From: "Guanyou.Chen" <chenguanyou@xiaomi.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	chenguanyou@xiaomi.com,
	linqiaoting@xiaomi.com,
	chunhui.li@mediatek.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 0/2] sched/fork: fix timer_slack_ns for children of RT tasks
Date: Tue, 16 Jun 2026 18:56:54 +0800
Message-Id: <20260616105654.2451405-1-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522131000.1664983-1-chenguanyou@xiaomi.com>
References: <20260522131000.1664983-1-chenguanyou@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D53638000C
X-Rspam-User: 
X-Stat-Signature: s4u7o911kjqcn63aefb7qkajhyq1jd57
X-HE-Tag: 1781646039-216128
X-HE-Meta: U2FsdGVkX1/BG9TKYnfe4IeXKwTw9INuAojeP3IegpgbABdF57m/h/B5Xj8MBG/Od0vgG6zB3E3jWV1uWWoCHIRmk6X/avKxAJDME669XC9TBlp9m4zNPU1OugiHWzGeSGnkGxzwgxENzN6wR7DqiXqRELT3OtOOlkehVJYUQ5lNKRH6Zy1aPnlckIQozTN9R7ROHHa/UhBk+cpc2GsdyPv+RBMQ7OIynTsdOzlBkGaOZebujreEu5qfuYP2gdbqqaFRFbeFD+l5J1Mi2pgxMx66FbASbjnkd0ZkH3W436/kS6VRY2WZHKbJwUA2HfmtAglsn1sgOKGsgZR/70p5Q6Qxz53gZyc6bJ5gHkVFcAe0oe8/ZwZzIR9JG/+yrSnSVUqw2UpXYKtjljf8ia+aKYbRN/4mVY2IxQ81hRXfI5xyvqsT27sZo4gnLz/Yo9HtBJVUXQSNrTwtatRPo4N2TVbzyOhYYbRLpXJmfAxondWVnBbVJYiSAv6zxc2G7PcTpCMi8DTvYTJBlgQLQ0n7uepinK2Tfm84jjnUL08sexQdFEmdXngrfaUyoBcfZENa5/lJpWJIC/C0AKffn5mi9XUrcUhs8TeJQ+v5GOx1jee3iVgbm4xqJNZugMhCT47CnMWCPHCClGAdZueejKHylrbgFGUWjzqWM4oZEDoaTR6WyRqnIDc6kdLMgGHRJNAadjIG0xZq+nvgyhEZwe6HPOikZjJw2JbgngmSQugAea88Zp0wTN2xGBf+rEQfqqM0nA8j1+zHI3POu2nsVZ1BKZmoS0b97PXlZ5qtjgTQK3/S1n6uMhzl+JbRonTlI2U8dLOkoHQeLfbYS882N+i4Tern+L+B89pJ9p1Xe2rutOaMsx9Ki2NF6f15D0KZv0o4VoT3vxQa7AZ8I3UtbQAzP7E2+Jyp2E4tFGOVaNwGU+Dt+1di7AsgWbi5wYKNDOpbZ8V8zO7Q4HeRZX0LxpV
 i+o4L1jo
 m7Cq9mRPAcr4QWSP4Rx6j/qmRCBkvwXcGqAbYiLw+dhHJd+zdf+l2GZt0yRJ7cu0T09GCIcwNAtsYIChRyoY/ybAZhUbxlzW8EOarBFVjlyyQdRxa17K/nPzkvnUOFe/wYUD2W+p/AHzahBQxhROdnV+SaFXR4mzUHfVmELVz03hnoYXeAVdDEfg5iZemn2Hhsi7QToPXX7lMlUPglLPg9sfFPqMURlgjskZkbzt8nmD4wbku10MHBNnuD3jH9PK3M/mdjJv/w1u1DuSMYN4lpqdnTiKF/B/3cavJybEgyBEm4zrC6B3BWkrHj5ZCxH61ZlJO7chyMSjmvWdYzGS/ypvv3wiP2+OmYseBXsMmjL3qXjaKteUf3LHwCQuWqhdhQ2qKKim/FEuU1Khdzi0pAauEjMs/XjgzzYJXrosjWeAQYlAu2ThEYCf/7sumlqTF3J6l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Peter,

tip commit 63c1a12bc0e0 ("sched: restore timer_slack_ns when resetting RT
policy on fork") restores timer_slack_ns from default_timer_slack_ns
when sched_fork() resets an RT/DL child back to SCHED_NORMAL. However,
without fixing the inheritance of default_timer_slack_ns, the restore
has no effect in the common case.

When an RT task with SCHED_RESET_ON_FORK creates child threads:

  1. dup_task_struct() copies the parent's timer_slack_ns=0 and
     default_timer_slack_ns=X to the child.

  2. copy_process() then overwrites the child's default_timer_slack_ns
     with current->timer_slack_ns, which is 0 for RT tasks (forced by
     ed4fb6d7ef68).

  3. sched_fork() resets the child to SCHED_NORMAL and restores
     timer_slack_ns from default_timer_slack_ns -- but both are now 0.

The child ends up with timer_slack_ns=0 and default_timer_slack_ns=0,
with no way to restore a meaningful value via prctl(PR_SET_TIMERSLACK, 0)
or sched_setscheduler() back to NORMAL.

The patch v3 2/2 of this fix is at:
https://lore.kernel.org/lkml/20260522131000.1664983-3-chenguanyou@xiaomi.com/

Could you review it? Without this fix the merged commit above is
effectively a no-op for the RT/RESET_ON_FORK case.

Thanks
Guanyou

