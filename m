Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B33CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71308E01FF; Fri, 15 Aug 2025 13:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21CE8E0001; Fri, 15 Aug 2025 13:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 937FE8E01FF; Fri, 15 Aug 2025 13:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8014F8E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:07:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 37F64B73CC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:07:03 +0000 (UTC)
X-FDA: 83779621926.11.77AD724
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id ED8024000E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:07:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf17.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755277621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qmtGF8u3VnEQktRjzCgXQV/wBb1bBInpYEUXB0Nzlg=;
	b=HVJgAzUhXzzTkZtWyXTsYsstOrgECYvzZk8CkLG3eMmBA0mnVaMYWfD4VYBkHd7V4E9lUY
	b9CU4CgD0YMBr442zLHKxlIpNP2Wrhn8wym5Wos81WhnScpWrpgmgUyx6hvUCOgMGUe9Mc
	l1Y/y0et/fkyzaIzKPjsFwhla0CWgyU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755277621; a=rsa-sha256;
	cv=none;
	b=6RTTUf+d8cx4naDSC1Sf7jVjZy7zqH7bmSvjLVSnk1CkkvTyee3wZcQ9CKOdHBcfty1lfG
	axwcCSEZG3FKKPrINyzfDVirPu67CnBS7nu+PRATcm5x87+TPm/lHPyzxUxFXrK86zxOLA
	SRyxP0me0z/Wy3k2h7Teh8+1PWf9lEU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf17.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4c3T6b4gYzzYkxsP;
	Sat, 16 Aug 2025 01:06:47 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 16 Aug
 2025 01:06:56 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 16 Aug
 2025 01:06:55 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <akpm@linux-foundation.org>
CC: <andrealmeid@igalia.com>, <dave@stgolabs.net>, <dvhart@infradead.org>,
	<feng.han@honor.com>, <jsavitz@redhat.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mhocko@suse.com>, <mingo@redhat.com>, <npache@redhat.com>,
	<peterz@infradead.org>, <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v4 0/3] mm/oom_kill: Only delay OOM reaper for processes using robust futexes
Date: Sat, 16 Aug 2025 01:06:51 +0800
Message-ID: <20250815170651.11457-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250814161345.b2ddf7120dfcc420c3199e67@linux-foundation.org>
References: <20250814161345.b2ddf7120dfcc420c3199e67@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ED8024000E
X-Stat-Signature: 4qmiry9nsiqdnmopr8c584zon3qk4rm4
X-HE-Tag: 1755277620-23131
X-HE-Meta: U2FsdGVkX19+DGn5j9KACTrBNGuF4T20coC/7SHJtGnfl8ZSuvvKsLVBlXVbzOk8hbb7YbyUGSw3CjiMzvSou/dNR9UB32uWiP1VwspXmGKNizYXV15KF99DmnzJe/qV3PtRZNmiy2NEWfEXJYO+zP0/vxiMtRJ13/8qTeoMzJ1vdazpU1uYQeirFfYZQWAx89hIgj2mALYuHF+sMknKTBKZkR7CwlGg2cBkCidKmlq7MX5tlz8Dqwa8pbf6B670NHWFe5fVinEbOZRlpvOrisRa/rtCfQTJd45z8+T3AtIvi2XzVpVFrKrfbJYvk2EBqvSxfNE7nQmDeTJSlTrfJJy8uBLR4DHV+EFkc3wNadcdFo/jASsy27NBummNu4b6QxlaviHv7PpvmoZVYH3JOJx5neBIyaBm8fjx9R9neiPRjEOzhC/0xZnfuolwfAK6VDKavhkzVIx0V64/ueNXu71/6HJY7nZ+KdHW4I+Cx1RN+HU7PXc2ytYb7DfPxTbRji0yUl0sbA8DTygdDXTZCp3H9qvgO5PKfDRFYYIgU0QoBl2ehDrqe09CvlV06/GsTkQUl60Kn6pMij6YGdU/ofDBYEsx8zwaUhFncY7pOf4LgyNqOj8npnpDusJcj+yuxvn8/ysdZYUsVqcJ38pl60zsJjDf3MLo6HwHTD5blJ5MlGbXpLMkvIfrm0IxN66RzisfLaYC6sxaWNyBnUSsS/dv79ZkBVGg6/gZWUNk/jcM7JP0w3y7R+Pho/GxWGuKrorpuCZeJhf0klRCreSBhcjbg1CT/sf+nImPxbcOb89ldc9YLEUxqt3BsDRu33yqdeTQUNF9UR8ScOXRoX1GVbPMQbr/dledrFH0sngW/kw5OXtRehMOiXalXSUAYsQR5Riw71suKksIOeQiThoCwjHiJ42lTxBnJPdHfssGL2siNAd7/r5rVVGBJHiKBgpUNiSoobjoNAsiCJ023SC
 nYgj35Ub
 1SHnbEJaKyrmRKBZG2w7TGTk8mfQrJ+hzklDvXVB2pobZTBg2DInMeXGxmL44pZ7KhtQ5PRmmN0ozB3yoeFiDXownV+dDi9H4cnzaSmB3oH8TpRRYLCrhTVN+zOgQhkSt7hLqrZP0r6HN71NlqbasNlhg1WNNz49yfIntXAgDtctdnr4RLWGCBktRN3PpZxSurZwGoq29+pRnWzQYuw7LJ+Gb8Kue+gLRwJwH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 21:55:52 +0800 <zhongjinji@honor.com> wrote:

> > The OOM reaper quickly reclaims a process's memory when the system hits OOM,
> > helping the system recover. Without the OOM reaper, if a process frozen by
> > cgroup v1 is OOM killed, the victim's memory cannot be freed, leaving the
> > system in a poor state. Even if the process is not frozen by cgroup v1,
> > reclaiming victims' memory remains important, as having one more process
> > working speeds up memory release.
> > 
> > When processes holding robust futexes are OOM killed but waiters on those
> > futexes remain alive, the robust futexes might be reaped before
> > futex_cleanup() runs. This can cause the waiters to block indefinitely [1].
> > 
> > To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1]. Since
> > many killed processes exit within 2 seconds, the OOM reaper rarely runs after
> > this delay. However, robust futex users are few, so delaying OOM reap for all
> > victims is unnecessary.
> > 
> > If each thread's robust_list in a process is NULL, the process holds no robust
> > futexes. For such processes, the OOM reaper should not be delayed. For
> > processes holding robust futexes, to avoid issue [1], the OOM reaper must
> > still be delayed.
> > 
> > Patch 1 introduces process_has_robust_futex() to detect whether a process uses
> > robust futexes. Patch 2 delays the OOM reaper only for processes holding robust
> > futexes, improving OOM reaper performance. Patch 3 makes the OOM reaper and
> > exit_mmap() traverse the maple tree in opposite orders to reduce PTE lock
> > contention caused by unmapping the same vma.
> 
> This all sounds sensible, given that we appear to be stuck with the
> 2-second hack.
> 
> What prevents one of the process's threads from creating a robust mutex
> after we've inspected it with process_has_robust_futex()?

Thank you, I didn't consider this situation.
Since process_has_robust_futex() is called after the kill signal is sent,
this means the process will have the SIGNAL_GROUP_EXIT flag when calling
process_has_robust_futex().
We can check whether task->signal->flags contains the SIGNAL_GROUP_EXIT
flag in set_robust_list() to ensure that the process is not being killed
before creating the robust mutex.


