Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0CEC79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 01:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0624B6B008A; Tue,  8 Sep 2026 21:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0137F6B008C; Tue,  8 Sep 2026 21:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BBC6B0092; Tue,  8 Sep 2026 21:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8ADF6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 21:14:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3BDCA4F55
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:09:09 +0000 (UTC)
X-FDA: 85192440018.29.6107291
Received: from mail3-165.sinamail.sina.com.cn (mail3-165.sinamail.sina.com.cn [202.108.3.165])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9A2F01C0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:09:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=uZzmhvOi;
	spf=pass (imf21.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788916148;
	b=654U+2V9n/XuBhm4XaELjcO9p3VIVIgjbU5bqteejvOuEOGkaswL6ro12lc6Eiwz5QZEm5
	f+X+hIAvmTKaa1F6F1Jjg4hbR0ErxVD5D63DOvLWvEyIdyu74VAxIkUARuVpGjU9lVK3nj
	9NHmgLJ2Iu3wsNdU4qHtswt50af5DEQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=uZzmhvOi;
	spf=pass (imf21.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.165 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788916148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHVS8CUETuqc99kyRiaPpcp6T76S/sIyd8jzjUtNfVk=;
	b=vAzL3eHUNz6bMM/emRID6NSHAhxraRyTEt7NcDL9wMaasVakmXONzbiY8zRr6XtMgtBX2q
	0IjlJPf7qLqZr2hgr2vCkc2B/b6md+bugatRLagh6kJYcdUOwSKp3aa+VG9fG2gqyXpyOe
	Tt3SSH2CouhNwgAoFkWX6/wa5VWX4KE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1788916146;
	bh=aHVS8CUETuqc99kyRiaPpcp6T76S/sIyd8jzjUtNfVk=;
	h=From:Subject:Date:Message-ID;
	b=uZzmhvOid4ISGYd3nFWGYJBc7CTaaB21nTYN8BWcYENrN1pE3b+Aaypc2uIeI8Kus
	 ZL3HPgIRT/qH4mLK7lhsz1KHaZrF3wPAc81NV/3FDXzoyfVwDejAoK7HsFK26Vcc2K
	 YuMLJeCEhZW3wEPHBb1liGz8RSv4iTB6JFicF3OA=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.194])
	by sina.com (10.54.253.33) with ESMTP
	id 6AA0B1AB00002892; Wed, 9 Sep 2026 09:09:02 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 6773796685274
X-SMAIL-UIID: F295AA5A7FAC4670AF833F38B4C45503-20260909-090902-1
From: Hillf Danton <hdanton@sina.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	lirongqing <lirongqing@baidu.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for vmap drain
Date: Wed,  9 Sep 2026 09:08:50 +0800
Message-ID: <20260909010851.613-1-hdanton@sina.com>
In-Reply-To: <aqAZ4H8mauWw4JVM@pc636>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9A2F01C0004
X-Rspam-User: 
X-Stat-Signature: 9juf3oe419jbxggpyzj5rn1cjao3bx1t
X-HE-Tag: 1788916146-838480
X-HE-Meta: U2FsdGVkX1+69LEjilqeOWkG7i/+trL5/zR/YqVDljuoZKh+oAAKlzcszdR9Iub+oir8uRJvnYE64kYgVUoFrg9iIqBTBg+BHxDeSDWdiPyx9m0lVCvFGv02jQvMRWtpTv3BeYbhklclsbJ+U1Azsj2LfVAY00lCqFtrp5gHYh1/xlm1Xp3M+QCiYUzCx9SRpvTQ8O2XBonSM+3WnRWQiYtjtDCmQVylIv2+pAtM6gtPyW57rZv502IjKbb5pQjF7jM0SBGBRZeZmEvTlb97HcCOPXB+0eyLnk4CNMjgmAPDGnwMeclfqilx3JZjgZWxB+Zn7IYvugqsNaDZW/oomM+I92plInfcG0y+zMV31dc0nZmCqHvZ8C4x95QgBTeQ+iUIfkqntIgfwnC74BlOiTLJJkuOp0LTra+GNE5LEqDJh5uHsPSmj8qU3a34tEcoSQzkKAyDMo2aJE9n/RHrsFpuUv77yytzwBBeD9WMZ5+84wC6ENZ0XNBeqvJ4ZWdnrij+dVoKGpg+RwI6xIL5h9btYSuGmDFe7O39mG3X4AE73l2dCZmdfcb3aUJt9xHC43CsP7eoah3VR1l5cGhE3TEodcJtH5iOs4/eTriJA3aPlg2kr6aBsKsHZJPI7kgfU+ycJOAyFL/9UHnYXB9frYwl0Rexk6FlRCFmJDzpEyHyogQoka+zvqDkPvWE0cUZyZu6Y/VzPp1dInr0gqwUNBDJDgg0egAK2w7xtIGKWuisBAc2FcmCn0UAELVs2SklKZ5SFkDvbAORMJLc7xHy/ffF0CqlYvWbypVqj8wYUKt4Zj5/U4WYG0qPCGzaAsxlhgaw54aM2NlWMFqE98oPUABY8sGN/HBmH4W3UKFwz7+klTWQbkg74u8wInBNb0L7yvgz/cDSQGsUCCadjW+VAZJ6geYpdZt257lwxyVttvn9t2ruHl8q5Swt39KbVxUYnBLXKp5G909Bpm2JEfJ
 Ek8gVdEl
 hXzkllWUaKESAbyEng4CaGq9uBdWyJg3rNbnSgsOGKIj0F93sFzMPOqs5bP9hFXAE0mL+8MXx4VH8gUxUm5FTYcUB+wY5I+EJNswdQQXcrYv0EVvnGtxci6P3RM0sUbJKLydTZcGq5ukQAjSMFL+P1CA/Da2l+u9FAHd/lGW0Vl+xz9hVsYhGOg9cmCPxgKad2MgIiAGDVd7KdhMPQyI/a8OsEKfcM+rxE4yN3W5fRAURKxyosIVGkRzLATmsKTmPDV17rkaAzDf1iLxbBYQwisbkpq/X/6NHJ0/pzOtFrXUqI/ZAlb7Gm/3mkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 8 Sep 2026 16:21:20 +0200 "Uladzislau Rezki (Sony)" wrote:
>On Sun, Sep 06, 2026 at 11:50:24AM +0800, Hillf Danton wrote:
>> On Sat, 5 Sep 2026 17:27:17 +0200 "Uladzislau Rezki (Sony)" wrote:
>> > drain_vmap_area_work() function can take >10ms to complete
>> > when there are many accumulated vmap areas in a system with
>> > high CPU count, causing workqueue watchdog warnings when run
>> > via schedule_work():
>> > 
>> >   workqueue: drain_vmap_area_work hogged CPU for >10000us
>> > 
>> > Move the top-level drain work to a dedicated WQ_UNBOUND
>> > workqueue so the scheduler can run this background work
>> > on any available CPU, improving responsiveness. Use the
>> > WQ_MEM_RECLAIM to ensure forward progress under memory
>> > pressure.
>> >
>> If the dedicated worker will run for 4ms on CPU2 before the tick irq kicks it
>> off cpu, the system event worker on CPU2 has to wait at least for 4ms to handle
>> 200 events for example in 1ms, the net effect is the same as the current scenario
>> where 200 events wait for the drain_vmap_area_work to complete on CPU1.
>>
> It is scheduling decision. We do not want to tune any prio here.
>
The difference your patch makes was checked without prio cared.

>> 
>> Different workers does not help to dramatically decrement the micro seconds
>> the drain_vmap_area_work takes.
>The problem of current approach consists from at least two problems:
>
>- doing progress under memory pressure;

Though in general a long running workqueue work is a wart, exceptions exist when
mm is tight. Just like kswapd that becomes a cpu hog, it is the right thing to do
for drain_vmap_area_work to take more than 20ms.

>- do not schedule all workers on current CPU and let schedule to find
>  the most attractive CPU from its point of view. For example: less busy
>  RQ, less energy consuming CPU and so on
>
Nope as UNBOUND has nothing to do with cutting the micro seconds the
drain_vmap_area_work could take.

