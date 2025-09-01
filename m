Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54553CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953528E0022; Mon,  1 Sep 2025 05:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9040B8E0016; Mon,  1 Sep 2025 05:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81A6B8E0022; Mon,  1 Sep 2025 05:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4178E0016
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:31:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 211A81A0759
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:31:09 +0000 (UTC)
X-FDA: 83840162658.03.B647D06
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6B1B3140007
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:31:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756719067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mQtwfj6tlVQEyb5J45/JnW0/FV8wINZDk1gp9AyXTHY=;
	b=ACoZAtB796cYruIjIrer8fxrRlX8nUX0KfkOFs4nsYkdS6RX6hiINs6H/qBGOgQdOrhHvn
	Z4vlfdb8AOb5kpV0TJ40BhMMbNhbfahZGqIkBxslszEOUNr4bgqANf1Q+Ee9Pzy7abM11E
	EuQm8N8qstL5mAG6GjYDyYx7tGtPy6k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf09.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756719067; a=rsa-sha256;
	cv=none;
	b=0gnsL/LmTJk3Ee2nYGKWqUrn8CVawiysFD+cwf5pF2V12oyY5Uz9AgaZxmk79ntYIrYBSt
	/dzSMTVVxVM4iIg+HVDGXrKMJe8vK2FQJcSJ7EmWuZFQjb+99nxMk5KSxA/rMbkdako7gT
	EquA2m/mGmIxrj33D7qLhFiZx95wSLk=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cFkBT61rLzYlFMN;
	Mon,  1 Sep 2025 17:30:41 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Sep
 2025 17:31:01 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Sep
 2025 17:31:01 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>,
	<fengbaopeng@honor.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <surenb@google.com>, <tglx@linutronix.de>,
	<tianxiaobin@honor.com>, <zhongjinji@honor.com>
Subject: Re: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the victim is frozen
Date: Mon, 1 Sep 2025 17:30:57 +0800
Message-ID: <20250901093057.27056-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aLVKYz6C5bXYG1v3@tiehlicka>
References: <aLVKYz6C5bXYG1v3@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B1B3140007
X-Stat-Signature: mwnb14roiefyq6zyhatturgo3k4p7op1
X-Rspam-User: 
X-HE-Tag: 1756719066-991710
X-HE-Meta: U2FsdGVkX1/mLUirJJKOn2Jx83SCJhouIl0W3U0QljSFfqbtKYcOzegzAZAKc+fNX0CAjV/GyqHeVzPCstkNSUaYYpLFJb+HLVWsK6SBNFrrfmk/lQS/NqlI20hRt56EaR6q2IEHHxN46K3UDPQe/0sFtSZbDKtYokAuSs6inptFG4b0nGd7SP9y/UmLuhwx+79gAP+WVhf+xowbZaF5M9/UBLbDNb7wPVgLYW6mGGB7PW5zR3cLAVxQDP0W0wAjjhWWNvnXNW56izR/aOIyJ1O97o/ho8Vl1QdlSVJ9/w77B/lqSZ0LOnVI3MR5dbDa6/TRiEVtIAC8utyZBdhWzCWp1RBEPI6M5CRnwK/Gdv4qCSymSQY1GZFzB6s7dFTzDTZ86uIBBX7dhUHkWp63DEyswAXkdRRUOf79DhZtxsifCWsukOXRvhR92Zov0jvLhcemC1z5YRs53ea0dulZunmS7ZTbjJCGiQon2Jiy9bNIskcQ/1ZDRd2fxLK0zy3f1Ll2ookg6VK/71Jypv4Ds1BgEaSX8E+aysWiuU4If67zObFkukxKU4YhUnQ31vTtlOu1LrF6pqZQe8cKLoeeAwn5koCUYiHCZH4lHW9nZ1Wyn2nhro8ezgb5Fzqv0zXIdgmUqXdr1u3Xz1yo0Mi4JG4AZHUoVvv7hcljpDZbDRB+jHUIAOUJBGbV0cWgKZdkw/NWqsPdYdYp91jubBOrM+7NIYyY28PapQeiQ2E3hqcjxy+e9AWEBhSRSoWl4VaiLabO1U49scz9CiPwk/VjVnqqYttQrk7u41vhBrii+HwlNcZGVr90/rEwtxuKUT9iuihpoXSZXLzHkO7IXDENNRdzFQ/5bEWnyMAb7H9Mh0l9IlHLQgFL+O8LAaHmHR2JtOFvYWaVq9AYeaSLZrTTpUpKvkMxC0jd5+9Q3VKEAODnmNbzI2rGcbvStXqv03BQCDlNIgGI5RM7HCqAhxg
 TxblN9AJ
 1G/J2pTFMrNgoQd48Y2LJYWDsJ/55Xnu8K0IwB3eQNukzEK85UUERxMTK/oIS2iR4YLVrkXN8w39mMisQpq+3jy76FuDjwqwtdNLhOtVRfakVYib6+ZhEELEPv0aoW9blT9f9VVxlFGkXmiGASI4bH27aCUP4Fl9JKyJboWUz5RgFNMSX0rzNOb/G7U4aseMc19VKKaksdTmumBtLD5lsUzvgEOzmt03mhR7Jm5XJtc3W9e2yRMzp5ihral7VA/cTWSNQ3vtJ5osI5SBhq7yCYEoiiXLQpOuqzh1ku5vDaNLh4EdJPgfVMlevE7d7UAT4mPMaHpMjkaK2Eb9oHG+IbDPsMRbGo3Kda0tP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri 29-08-25 14:55:49, zhongjinji wrote:
> > The oom reaper is a mechanism to guarantee a forward process during OOM
> > situation when the oom victim cannot terminate on its own (e.g. being
> > blocked in uninterruptible state or frozen by cgroup freezer). In order
> > to give the victim some time to terminate properly the oom reaper is
> > delayed in its invocation. This is particularly beneficial when the oom
> > victim is holding robust futex resources as the anonymous memory tear
> > down can break those. [1]
> > 
> > On the other hand deliberately frozen tasks by the freezer cgroup will
> > not wake up until they are thawed in the userspace and delay is
> > effectively pointless. Therefore opt out from the delay for cgroup
> > frozen oom victims.
> > 
> > Reference:
> > [1] https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u
> > 
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> 
> Acked-by: Michal Hocko <mhocko@suse.com>
> Thanks

Sorry, I found that it doesn't work now (because I previously tested it by
simulating OOM, which made testing easier but also caused the mistake. I will
re-run the new test). Calling __thaw_task in mark_oom_victim will change the
victim's state to running. However, other threads are still in the frozen state,
so the process still can't exit. We should update it again by moving __thaw_task
to after frozen (this way, executing __thaw_task and frozen in the same function
looks more reasonable). Since mark_oom_victim and queue_oom_reaper always appear
in pairs, this won't introduce any risky changes.

 static void queue_oom_reaper(struct task_struct *tsk)
 {
+       bool delay = !frozen(tsk);
+
+       /*
+        * Make sure that the task is woken up from uninterruptible sleep
+        * if it is frozen because OOM killer wouldn't be able to free
+        * any memory and livelock. freezing_slow_path will tell the freezer
+        * that TIF_MEMDIE tasks should be ignored.
+        */
+       __thaw_task(tsk);
+
        /* mm is already queued? */
        if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
                return;
@@ -711,7 +721,7 @@ static void queue_oom_reaper(struct task_struct *tsk)
         * If the task is frozen by the cgroup freezer, the delay is unnecessary
         * because it cannot exit until thawed. Skip the delay for frozen victims.
         */
-       if (!frozen(tsk))
+       if (delay)
                tsk->oom_reaper_timer.expires += OOM_REAPER_DELAY;
        add_timer(&tsk->oom_reaper_timer);
 }
@@ -783,13 +793,6 @@ static void mark_oom_victim(struct task_struct *tsk)
        if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
                mmgrab(tsk->signal->oom_mm);

-       /*
-        * Make sure that the task is woken up from uninterruptible sleep
-        * if it is frozen because OOM killer wouldn't be able to free
-        * any memory and livelock. freezing_slow_path will tell the freezer
-        * that TIF_MEMDIE tasks should be ignored.
-        */
-       __thaw_task(tsk);
        atomic_inc(&oom_victims);
        cred = get_task_cred(tsk);
        trace_mark_victim(tsk, cred->uid.val);

> 
> > ---
> >  mm/oom_kill.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 25923cfec9c6..a5e9074896a1 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -700,7 +700,14 @@ static void queue_oom_reaper(struct task_struct *tsk)
> >  
> >  	get_task_struct(tsk);
> >  	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
> > -	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
> > +	tsk->oom_reaper_timer.expires = jiffies;
> > +
> > +	/*
> > +	 * If the task is frozen by the cgroup freezer, the delay is unnecessary
> > +	 * because it cannot exit until thawed. Skip the delay for frozen victims.
> > +	 */
> > +	if (!frozen(tsk))
> > +		tsk->oom_reaper_timer.expires += OOM_REAPER_DELAY;
> >  	add_timer(&tsk->oom_reaper_timer);
> >  }
> >  
> > -- 
> > 2.17.1

