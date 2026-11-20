Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2358660A2629
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 16:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P60bn+OJ
Received: by kanga.kvack.org (Postfix)
	id 34C626B05B2; Fri, 20 Nov 2026 11:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FCD96B05B3; Fri, 20 Nov 2026 11:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213686B05B4; Fri, 20 Nov 2026 11:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F14616B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:30:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7618D40F90
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:30:45 +0000 (UTC)
X-FDA: 85456036050.09.4FDB5C3
Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2980E8000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 16:30:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P60bn+OJ;
	spf=pass (imf02.hostedemail.com: domain of bradley.morgan@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795192243;
	b=l2tDT9ntWZtTIQMag+rpvGmyldm35iAl/03C9p+iLrvdh/GhE6Q30mQyZKo3gm5ufF2SD+
	yj8qClW19tFOrizc+HrNQUDPWH90MPekR8gYfIZm2FMn4iunc9cXMjaCxKZi66IqTpC15g
	C24BRLIdsV5w88KkNUlmygdHJV4s2IA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795192243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=Ve3nZc6CfK+2Pt/EccX7NgGEXSozela6oGxYTNkBW4Y=;
	b=hotM9rC+xYQ5s/zEv6E5EARPtKSaeoOV43/AHNSQRKd0ANCDtjQQ8b7p4LHKMsoiUuNDZy
	g6rBvTXd0W4L7OnZvlhSQnCqWhrD3kwXrirB8PaHvpUY9rjwCMD76susGPMflFiNOVK5Ph
	Bdx/KNoCHGM5kxGsSZa2RIDb9maGV+k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P60bn+OJ;
	spf=pass (imf02.hostedemail.com: domain of bradley.morgan@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=bradley.morgan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xEDXCHS/YWCWxkLlT2J/pwSodE2KNpqOe5MEs15s6Do=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795192241; v=1; x=1795797041;
 b=P60bn+OJx+z1SO/r9rJa5vhUrpgrL9hRoJp9EgItolRLoRdvIU9NCqE/g7CZ5eeRNVmFLJRV
 bQTdQbdrm4GsEBk4ItVnWkTjQh/GGwDYglY58TTpBD8qnhrFPcrmnrK80I5PjZlGWHXFKH/mY8w
 ykGWAtOMIWig1jLJ+tKrAUxU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ea5d9678c358f401;
	Fri, 20 Nov 2026 16:30:34 +0000
X-Mizu-Trace-ID: ea5d9678c358f401
X-Migadu-Flow: FLOW_OUT
Date: Fri, 20 Nov 2026 16:30:31 +0000
From: Bradley Morgan <bradley.morgan@linux.dev>
To: brauner@kernel.org
CC: arpe1618@gmail.com, jack@suse.cz, jannh@google.com,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, me@black-desk.cn,
 oleg@redhat.com, viro@zeniv.linux.org.uk
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_0/3=5D_pidfd=3A_use_one_helpe?=
 =?US-ASCII?Q?r_for_pid_namespace_visibility_checks?=
In-Reply-To: <20261120-work-pidfd-pidns_visible-v1-0-0e82d08469ae@kernel.org>
Message-ID: <B987F9D7-912E-4714-B54C-B17F6F4A639D@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: 9qtgsbo4hawgj3kesy7w64m6axergzmh
X-Rspamd-Queue-Id: 2980E8000A
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795192242-326918
X-HE-Meta: U2FsdGVkX1+Fya3TeRZis/X8dIvzkgzRWQDzxHJuNrKwHcsFarEnzbPuKPd3i+6g6kzwdmeiFJQfF7gMy9GEBlLGSpnYWHglFCFbmPLTAi4eL+l+Lg9/mefqSt1ayuZQCpq+tHMFRxjMp3aP8vrK6CBL8EnTRXO29IPkAbs3O8zpbUzQFMv600r5SyvEIyAMuA6xa0gdK4xAu1JdLc1wKdZYTMsArPypwt9bnTxKNruMAI3XbuePetAZhaJFVBYUXu6TL9mROh90ts2tFlQ4JYqvakRpULoVmhzELzG+L/nhB1OmZD9fExw+ho1TGL2j2NB/0T1VWvogAf/duw6nasMgpk8hsxJ/5Q9E1rwjU6iWorEWctABH/8MuBPm1ucyg6s7wtkT7UJFCS/7TsOhoG37r+T/mlpyBKCySOHig8fFadmnyYSjOAAAmzSdWwYZvRa45RP4PFuylP93TxS3nd0wD84pWNqDzZsN07xExJkVdwjXzmIrO5n0OoVGCSSicrHA9m/Q2EhlugptTSTws0yZueNf4ubC0q5x5mAVu0eLLkpwJ3rDGM6sg2U6TJaTYHqYvexya5RdPPOeWW7y60q8mK6XbwZ9ioVuWO6piJj62Qe/dAm5wFfUbpeDh22TqJP7Um+JyvI6mI0RYeC1/Xx/dKy8/m1PJc4lk1KkaK4+UDMq+IvzzbDwYwoMBo1icO5Plx7yZupDx8+NZ51xVL8UHB6cyxJbpvaqdPvWG5k/+9aaFdJOtUGcO1iLoQ/++jLP53f5uX6VYVrU/PoljDlAQLeRNGku5wdTO39GGMJlgg4ezwLuGhH7PGFZYLxJcCHyoNfjLhT3I+ckcb552v0DeLP6j//k4FiTCMbwRIpcg2yUJZ2OcX+KuGOzKJ8D8RtMU3W6OBYGhHoHqq9vR8LYyrRW7nCv4uYs7tJ3+jVwfXhp6C8BvIySVtbfCazVDvIRkhJMcYlfclPRK89
 NRqr86ou
 CIs1OjiQOUGjiQKQS1aA51/9cR50d/KG1cHxXeBAWcKLlT10jwjllueo5/RfIEAcs/gbOTGtsbdU+MWe9WD2cLDrZ4kt+cIWXp99Cp2+OA4XgS59ibht4Tmvg+Ar9YhwRoFpsaeLz7+ie5lerw+l3OwcEhaCANsST4ovhPHqBT6ERTq8OCHZmaqMRyQby5jgmKu6t7eBwk7b/U0cmBGlGQBZp974rHwJ2uXJoTztPC10owG947qCWISbKUl1fUEJCka2uWiywVKOTk+cztuOZS2fBiMQf4Hu7u9s2UYgqHr+CuLaIqLQA1d4t5vOz9/dUItwqm8jixN5ZT6XGxOmd2mGOnlfD+jj1YRXLfoqiYN2gleTAZI0FHEAS2qe0o6ez8Qaf1JjfU2W89yiUx/2ynzsFJP2Q4mjtuQ2jWXvt+EqJ8nOw/UXDSLRGGzwV3QCS9gf72M54CxugPwmvKd3CePMnV2rQlUuRzBSDQSTPivMlaBt8Q+d+I498idzPJJE07vSAyWCSnwMZk34MSd3tO0KHgLlkSd0zTHrZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

>Christian Brauner (3):
>      pid: move pid_in_current_pidns() into kernel/pid.c
>      pidfd: convert remaining visibility checks to pid_in_current_pidns()
>      pidfd: restrict pidfd_get_task() to the caller's pid namespace
>
> fs/pidfs.c          | 12 +-----------
> include/linux/pid.h |  1 +
> kernel/pid.c        | 31 +++++++++++++++++++++++++++++--
> kernel/signal.c     | 23 +----------------------
> 4 files changed, 32 insertions(+), 35 deletions(-)

Reviewed-by: Bradley Morgan <bradley.morgan@linux.dev>


--- Thanks!

