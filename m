Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421A7C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 13:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C3F6B007B; Fri,  1 Aug 2025 09:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECAC6B0088; Fri,  1 Aug 2025 09:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02706B008A; Fri,  1 Aug 2025 09:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A012D6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 09:20:28 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FB0E140115
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:20:28 +0000 (UTC)
X-FDA: 83728247736.24.67A003C
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E08A1C000F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:20:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754054426; a=rsa-sha256;
	cv=none;
	b=dkYecRg+2K1j6daJZvvY3nMCGQ+DWLbqXN3lmIIyMSLUadFTAxPO6Fcf2U/ZYQgT7wZtDP
	lBQTK7d17RcYhGXhkhAM9084Bv70D5FlaaC4yP4+3w26GYqW2K74WDe2Hz4FZgmRu4VA20
	WDLkCoOSA/FOBEOu4Vi+hUhRJCKmQys=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754054426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ByBf6uw0bBUlufyX1fp+ANY+puYoAEXM+o3XJ3HjUl4=;
	b=hQLmUn2J2OB5q6RNwllIHp+sSJMPNPujNipm/CUTA1ORv1l3fwjcGSLdTy3jIShzk/HaEo
	UIUTDOkhGXDrVD4lcwRI3LbrlqstimMxohnRkZdQiouZj6KSJaGkM83CIWTbjSMcGdKuTU
	Q88ZC+bE3JAfFSy/2pj6llG8npzPSjo=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4btmhJ4wDmzYkxQc;
	Fri,  1 Aug 2025 21:17:20 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 1 Aug
 2025 21:20:18 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 1 Aug
 2025 21:20:18 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <shakeel.butt@linux.dev>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>, <jsavitz@redhat.com>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <mhocko@suse.com>,
	<npache@redhat.com>, <rientjes@google.com>, <zhongjinji@honor.com>
Subject: Re: [PATCH] mm: delay oom_reaper only for the process using robust-futex
Date: Fri, 1 Aug 2025 21:20:14 +0800
Message-ID: <20250801132014.5740-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <u3mepw3oxj7cywezna4v72y2hvyc7bafkmsbirsbfuf34zpa7c@b23sc3rvp2gp>
References: <u3mepw3oxj7cywezna4v72y2hvyc7bafkmsbirsbfuf34zpa7c@b23sc3rvp2gp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w001.hihonor.com (10.68.25.235) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 5E08A1C000F
X-Stat-Signature: ptsfmyhum3bps71cqhj3xd14nq8qfssr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754054423-214396
X-HE-Meta: U2FsdGVkX19R0S2VN4Hu+GWHuSF/kRBf9+iP8mAG8ud5goJ70ogWtc75bR/txBDleEYDohKjZEZA0XyikQ93ypwjaJiR3ge58bxtJvlMN+WRqSifUWyAFiu6J5du+xVaUeEc/5yayB9uyhFdCMc06akkMXHYmQnXWOHF+TXGmj4Xf+dVzaiQH7ncnB2Mhi2Xzdf/n/fhMdrp3XF8zSoyYAkKrvWdl43DdFGSH+LPK/hGr3uSLkQrigV5WZ4w30r80/tNTlHjQW2wEMtN7tR6YcUNkBM+lXuz2B/lnyrj62XYPzD4QBnEkM6tvjwqsFKmrE+o8iNrQKLrltV5/KZVzdnFhwfA09ga78tKzWvYTmtQuX4xL3Pk0nl9YUKRnMP3Bsn2ZAyaOfBG9jOLQEtaQXif6pt4CrHM1O1EfZwZjRtLsUOCGc/NkrEm/+1gNeog3+DJuzXw4iNayEZ+gapXQi9di3mUsAUrMGr+kGG9aKZsUYSiA3dVooKm4gOy8aROq2WM8lOXSwiAjdKwa8WoKZP6AAS7wv8sXx4g+gKKfbQkKGupQf8A2Rc22UNTKvV9Nn+eehQhYP8KUs2Zv/ANQSnLb2zqp01MnPtc5nWZKbJviNEpqtcD4WaUEqwQjSbyITVDHGCXMV3vcEeTiVfKRgIWPlRXhoFjxSynuC4L/vfEl5YtkbgcUQeLe8Ncdp7MdATCQRV9waLwlTlDH/mWfW+zXY2FMGxdVuWs92QLqvdI8tyAH6k1u9UR1Kk+T5hjlg0rUhagRr/J0l4QQ80hJbqDd4ZztiCr+NF222IEWJcXLd7lpXNxVhzgpQ9Ymcn2DsNt3CfkOy7CLDRT31NjRbFYL66V7QusPfLZ5sR1/Nls4UC6XajvFKETalh2qyo7NfH6Doe/XgJrgvLau/gRH21qfiwQnlJHvP1VparWamIMxunxWKehpa0ZwfxF3GpZPmNVrExKky/0/tRdE6t
 jIjfPZDn
 jlg7N52ra5MFKvEuad6QUde/O9hdKxXGz1A9xlX/0lPZPM3ZqoMx72xLCf8rdzViW2aPkjqdKiSP36ZSnTYQinOmHAzweGhaBpUza9Tz9eckmXzlHuOKABXJnHKScYae0ZALvx7QVJWSaWAxBE17Yi0h2cFpGwFsj0vF+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yeah, it is enough time for any process on Android to exit within 2 seconds,
so the oom reaper basically does not work.
Currently, we have not found any users of robust futex on Android.
As we know, adding killed processes to the oom_reaper queue can help
free their memory faster.
Delaying the oom reaper for all processes might lead to less efficient
memory reclamation, which could be undesirable.
>
>> 
>> But I noticed that many processes do not use robust-futex, so they do not
>> access user-space memory during do_exit and do not run into the problem
>> mentioned in that patch.
>> 
>> So, this change delays the oom_reaper only when the process uses
>> robust-futex, letting the oom_reaper work properly in more cases.
>
>The direction seems reasonable.
>
>>  
>> +static inline bool exit_may_access_user(struct task_struct *task)
>> +{
>> +	return task->robust_list || task->compat_robust_list;
>
>Here I am not sure. This robust_list seems like a per-task list and we
>are making a process level decision based on a given task's usage of
>robust list. Can we have a scenario where some tasks/threads of a
>process does not have robust list and others have? If yes this can cause
>similar similar which the original patch tried to solve, right?

Yes, we definitely need to check whether all threads have a robust list.
Thanks for the reminder.
I will include this fix in the next version.


