Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CCC4CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325726B0255; Tue, 26 Aug 2025 09:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCE26B0256; Tue, 26 Aug 2025 09:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A236B0257; Tue, 26 Aug 2025 09:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4866B0255
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:01:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D55DB1A073D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:01:57 +0000 (UTC)
X-FDA: 83818921074.10.8CF9C39
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8964310000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:01:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf14.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756213316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ip4sOkqceZtMIpztHMcNThGVo6Dps70RQjoBxtpRFkI=;
	b=b1YSYAWLEQUbv4GjURZk+0BfNFuGCxWv5a2x+R5WXpnNfjy0wkkzvuLOSVegOoAM1RMfMN
	7XkjG/HyNna2HnjVM3QCjphbvsd9Xy3QdaZUSO3XpTSJLUO2+pNvVQNdZ1jLeO/og8jbKT
	TfpQ6UTXM0hLxuy39M5LjRP3xMK5fA4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf14.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756213316; a=rsa-sha256;
	cv=none;
	b=aEzntZ4RgCGdAdkWtT6sArKn8sagCIciZ4vNcZdITPR1h4XzDCg/WCD9DLBzZU+Tj1DRGg
	Vvb+o/29kaCwSc4t7JVlc4rk5Z4HMeM2AG3o9IwcBlSjOFpUsZNSiFTlYRCa6Qwj2A92A1
	hPcQygdBAYoJ9luH+sXkq3iXpOXB75o=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cB78X5XsgzYmVyt;
	Tue, 26 Aug 2025 21:01:32 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 21:01:48 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 26 Aug
 2025 21:01:48 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <shakeel.butt@linux.dev>
CC: <akpm@linux-foundation.org>, <cgroups@vger.kernel.org>,
	<feng.han@honor.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <mhocko@suse.com>, <rientjes@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v5 1/2] mm/oom_kill: Do not delay oom reaper when the victim is frozen
Date: Tue, 26 Aug 2025 21:01:44 +0800
Message-ID: <20250826130144.21522-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <jzzdeczuyraup2zrspl6b74muf3bly2a3acejfftcldfmz4ekk@s5mcbeim34my>
References: <jzzdeczuyraup2zrspl6b74muf3bly2a3acejfftcldfmz4ekk@s5mcbeim34my>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w001.hihonor.com (10.68.25.235) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: zorzc4srwm6a9g4jrymm13zq8i3igq5z
X-Rspam-User: 
X-Rspamd-Queue-Id: 8964310000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1756213315-158497
X-HE-Meta: U2FsdGVkX1+hNPRbN0i82gL/za+tuj93mkaB0RZkWoQnxL5ivhrqEVNcfgiFtbWwVlwaNBDiLO26luJ+JgPv/Vj9EZu6HjTeqBbgjwoxztr63Q6xBHJSsnA+b7aa5gas4awvWiFsiFYF6uPKK6Blxm2DHDeRYZWxQa9SKmkpRl8QhojiPmLdKMEwBrGLPX0ChLdnP/mZfWWbjFNdd6wx/KDAbgIcIk/bMn53smVEz5EQQEIfg/P1xp3kw50HP3UE2uHUcJjy291QEKSqJRjh7Ey3DXjrT+NPo+fw2po7QR7OaNtG4EoMM+ZKMvY90PBIekJ2YHpmhdirp+QJyNeNZJ3rQkHt9ytBqTfPSzpF82oR6Ah/MC5q+DVYA4hacJzv68tNZofzhVozfGP/2TUK+miQW1C2EdQo3yuBm3pX3j4yy0WJlQtAFx10vbrZu1MCAsIXVMWos8wmzIjh25r6lZ2i4HbBwdXR0RFms7gY2J4EARpsAYzamaQgY8OkGLzFan0ionBOGs2Xr3DZWzxW2yBGSQA9PYJM0ppPRG5+VRyKCL7u+MJ77p1Yk7DRrSeJqFRGMoDthXz3Y5MLriqRrwSeHyx3Tj859rWeItsucy2PGiOgwH01F6YLy7uoPYPhmt/SiFESVEsJHKcnBUoNGhQL/zsBwTVw1EfVChjFhwEYFavkHeeZ/OZO75TlDM3ZUrB9NZHaRZ00NPipzFUdNCsT6bv0iwdMeOEz2k4RSbEKiosy/K9KRXD9SImN4prGXPnEjWAbegSdiglN9gMl+AF7mxkUC0qFSd9b+BZN1flrWcGuafQWR03yx/YDZ+EgbxkopRvQDjphvzyKaFfu0idmTSE/mWH52BDEtPO0VLjT9pda6NjglRM5ZbZz3BBTBdU5BZzMKXAweJxoSDIh4JZZN0b/AWPpTW7NLBd2WwbF9VViieBeEVIsM00oUlFSekrvRYE/i/V362vZteR
 +Rvgaku5
 tz1o7ZqkMZGJPARnV3vj9hG5xfm0AA0rdolQeqeZGOleKQevP9Q3vnf6S55GLrnkzQQXCbZbbhRpSHFcIB314KxABq7mE/mzFCU3nsA4b+4aK/BUH3vA/KW8Wfn3QwXZAhFeGXEj6gi5cpDLtOzYlvcn7nyajdgWHVqyizgD2EiwFdpRxxVpunK4w7b9/90itNFQOgWl/+BwfUDwsaTXyVugxWOyuRriBpClZoNPj1ovjFMv+wkM4Z0wv03kulZi5ox+gx3sL+oQWf4qKJHYzoOBOuB9V1J1Q5ANv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +cgroups
> 
> On Mon, Aug 25, 2025 at 09:38:54PM +0800, zhongjinji wrote:
> > The OOM reaper can quickly reap a process's memory when the system
> > encounters OOM, helping the system recover. If the victim process is
> > frozen and cannot be unfrozen in time, the reaper delayed by two seconds
> > will cause the system to fail to recover quickly from the OOM state.
> > 
> > When an OOM occurs, if the victim is not unfrozen, delaying the OOM reaper
> > will keep the system in a bad state for two seconds. Before scheduling the
> > oom_reaper task, check whether the victim is in a frozen state. If the
> > victim is frozen, do not delay the OOM reaper.
> > 
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > ---
> >  mm/oom_kill.c | 40 +++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 39 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..4b4d73b1e00d 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -683,6 +683,41 @@ static void wake_oom_reaper(struct timer_list *timer)
> >  	wake_up(&oom_reaper_wait);
> >  }
> >  
> > +/*
> > + * When the victim is frozen, the OOM reaper should not be delayed, because
> > + * if the victim cannot be unfrozen promptly, it may block the system from
> > + * quickly recovering from the OOM state.
> > + */
> > +static bool should_delay_oom_reap(struct task_struct *tsk)
> > +{
> > +	struct mm_struct *mm = tsk->mm;
> > +	struct task_struct *p;
> > +	bool ret;
> > +
> 
> On v2, shouldn't READ_ONCE(tsk->frozen) be enough instead of mm check
> and checks insode for_each_process()?

Thank you.
It is mainly to check the processes created by vfork. I believe no one would
put them into different cgroups, so I also think that READ_ONCE(tsk->frozen)
is enough. I will update it.

> > +	if (!mm)
> > +		return true;
> > +
> > +	if (!frozen(tsk))
> > +		return true;
> > +
> > +	if (atomic_read(&mm->mm_users) <= 1)
> > +		return false;
> > +
> > +	rcu_read_lock();
> > +	for_each_process(p) {

