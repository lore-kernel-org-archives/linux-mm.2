Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070D4CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DA8A8E0149; Wed, 27 Aug 2025 08:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B8F8E0147; Wed, 27 Aug 2025 08:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C83E8E0149; Wed, 27 Aug 2025 08:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29C048E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:14:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D02A81DD5B1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:14:50 +0000 (UTC)
X-FDA: 83822431140.24.CFC3DB6
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf26.hostedemail.com (Postfix) with ESMTP id 89BAA14000E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:14:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf26.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756296889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yG7480RqKLX1PJuDP5QQCS0vMQ3rUqFw1a56aOnsuXc=;
	b=b8oJqZ6JrhBi7brA6NdN6uJLamRj2qoKVpoFS1XC9lsKldzNtVlY1Z4EL3k9TiazYAfGoc
	OhhRU1CmbVLciNiu+rd9JHfMLjeyL0/QxaHSCfv+GY7nCETj7uEGExSmXsbFKV+10s7HzE
	Ro0UPrKGLGPkY6F33mrOeaVAm69t2BE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf26.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756296889; a=rsa-sha256;
	cv=none;
	b=rzVYC59/yew0rUTvU/8qjMxw5RFL5DpXCznnFCe9JKeoSlZ7dMmWGUhVQ31y/KDdkc3yUG
	FXleXmIjr8pphkC5FxmJtqCp13rFs/hkVlkAacENA/L17wVvUZ4U293Lilkm99Ovbo0rOY
	un2HpHx2dCOWwGOQBeMxns58FJZmKb8=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cBk3h0zcJzYlHYL;
	Wed, 27 Aug 2025 20:14:24 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 20:14:41 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 27 Aug
 2025 20:14:40 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <lorenzo.stoakes@oracle.com>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [PATCH v5 1/2] mm/oom_kill: Do not delay oom reaper when the victim is frozen
Date: Wed, 27 Aug 2025 20:14:36 +0800
Message-ID: <20250827121436.10795-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aK71W1ITmC_4I_RY@tiehlicka>
References: <aK71W1ITmC_4I_RY@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: c15zb5gf6forjjo5pyg8897crdbkw7eq
X-Rspam-User: 
X-Rspamd-Queue-Id: 89BAA14000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1756296888-833458
X-HE-Meta: U2FsdGVkX18y0B2OqNI/MW9OQO/zH8WWrmELKFVyYdSwZQJesuoMC1uF8vQPswM3iSaRyqtyhkeCEPx77xUs6ypzACZHr4qAdFbQh/tqz2bPfxv3k+OOhnt0K33H3Bqclm9QyqLsqCzrvfJdtIocIyzknKw1WC3zjtbHdLY2+8V893UeUMiYJjurP57OjeU21foFBcbd+7Ezrs442jZJO8Mj1AVpP0EqR4AOikTBz81DL/mZPH9ekPJ44V462aq/jHm/p/J7Jb1fsh//QlA7v8tYNYRe3e0CDNEwDLGTE2PrK5IiWVk16OICTzLebtylJlwy40h2U7bPj2fKTZfQvHi774TqwVXhvy6B+iydpEMIq5OgiqNcsfQqYTB+Ik7EkjShhAXPG/v3ZH6AOBtPoxAWuHOb5nIGilj4m5DAQDlfXA/ReN9LtVNI9MS+jD4W1A2wCkEEj16rqmn9l8ORUvhNH5Qk0J3ZBW7wzuiNv5kiGGVtJznwkjsfQQsy+JBxTBbsbw1K48kDWn0Lu23YMf+LwTUGSCxETJMQgHPf1Qh5zcDvQoLlROcOruQRahxBZce98lBTotqBB2LEoqul+8ZzMrXqOfeUPFn5IlKFsByzCrqxojOVnLCO8Za6pOsY8YnrTjFFsompCuKM3YV3RS+AHLITv5hg25iHXBsplIav9pJcFuWOMnqpxPPN+hF5zMeAO7QkMEBfJ9au7fzYFFtiKVtbM/telXo2JDvNpEfMnOwvyW/sNkbWe85v1HC+Y9sHVWjlY2Vof0+rV5EZcNXCSsoiBPC0X729NXvClClPHQ+uBmvAQx+iudZD9S6q0bxLw5dPW/d6eQXFUtuGhgUUbFhBywfLLnJWb/v9sjqJkNssGEr0CK23ZXzdLBCa+V4EwaZRYm7mXNs2hIdarYF2shkC64sOt6tEE9HgXJlqgu+vdYTy8HF6dsBoXYtdojYHoM2Far1XNtZxHn0
 h40QSPFW
 O5z5g8EO+B4XrLiyPLH31gtp8e2G9/5j0FC96p5ZcQP8PfrKiaJ2GH7JBiSja8iVm5zhe4/aupR9iKaLaVgQ9GvS06OByrjLTKayTMaet6rN/FlF1xC4AZn5xCW8Hg51FoGoSU0CqYM5GGcTOoaid8vTpOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon 25-08-25 21:38:54, zhongjinji wrote:
> > The OOM reaper can quickly reap a process's memory when the system
> > encounters OOM, helping the system recover. If the victim process is
> > frozen and cannot be unfrozen in time, the reaper delayed by two seconds
> > will cause the system to fail to recover quickly from the OOM state.
> > 
> > When an OOM occurs, if the victim is not unfrozen, delaying the OOM reaper
> > will keep the system in a bad state for two seconds. Before scheduling the
> > oom_reaper task, check whether the victim is in a frozen state. If the
> > victim is frozen, do not delay the OOM reaper.
> 
> I do not think this changelog captures the essence of the change really
> well and it suggests that this might be a performance optimization. As I
> have explained on several occasions the oom reaper is not meant to be a
> performance optimization but rather a forward progress guarantee. I
> would suggest this wording instead.
> 
> "
> The oom reaper is a mechanism to guarantee a forward process during OOM
> situation when the oom victim cannot terminate on its own (e.g. being
> blocked in uninterruptible state or frozen by cgroup freezer). In order
> to give the victim some time to terminate properly the oom reaper is
> delayed in its invocation. This is particularly beneficial when the oom
> victim is holding robust futex resources as the anonymous memory tear
> down can break those.
> 
> On the other hand deliberately frozen tasks by the freezer cgroup will
> not wake up until they are thawed in the userspace and delay is
> effectively pointless. Therefore opt out from the delay for cgroup
> frozen oom victims.
> "

Thank you, I will update it.

> 
> Thanks!
> -- 
> Michal Hocko
> SUSE Labs

