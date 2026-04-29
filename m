Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E14DEFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 09:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119FB6B0088; Wed, 29 Apr 2026 05:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1FE6B008A; Wed, 29 Apr 2026 05:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007996B008C; Wed, 29 Apr 2026 05:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E54FE6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 05:24:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 991CB9196A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:10:01 +0000 (UTC)
X-FDA: 84711021402.20.DA814D0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id C472D160012
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:09:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+MvByLP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777453799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5GumiqFIt/ECkKTfRRSYkr9aPUwrDRN0+fa5HLkUxU=;
	b=r6W/M2njswh2BQJwiyqx1WMF9R/kKV3Kuh4V8MvdyIKVaUt6upNm+ABoOti5mIF8nyjY6u
	swxetZBGL3ZuMNHOwDdk3y+fPab4wWnjetvwOBbiNuqsTx25CMfrAJb5kOBhuuiTqOA8Id
	FoJ9xwtv+FMpshWBqJ8PkirXO6NFrY0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777453799; a=rsa-sha256;
	cv=none;
	b=Tcmju8Jnt1ajWPqIuCmoHO2tVb16lI7I/5Qbs08/QjFhVAys+ltdG2dOvRAzoGc6f10nek
	cqN2L5kgAxPPXMOy22P/Jig/51Udz3G/BKRt33fnBjngIa6btF8KXUpVJbXowScuPcx+6N
	zf4i8FnG7WUeXgGvx5lCpcDTA45Awwc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z+MvByLP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D49260018;
	Wed, 29 Apr 2026 09:09:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CA9C19425;
	Wed, 29 Apr 2026 09:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777453798;
	bh=U+qtUGkVcFIOlc8S8UBttfIQrvSv8Unx0HYdPMMzu/s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z+MvByLPCyLX3thXV7RgPBjsjmxkuAXCIy4GXER9SykX7CHrlgSjjUZyquB4KqDcp
	 jE6yx5hmr/1rBMFnHAQeb4njCzfxnDS9Co6U2mZwBoMBNYEkTNvqPRNWu+Qd+DIyyr
	 HWM4uamBtdonUqzUYZM5AzY8WIBP3Q6Gfu2ml4ehQ4kOOLyQgQeMAwj23hqJX5T/hE
	 E2ZZlTeKtyQ10nWnUmrbLFCRU15KsZQIGtahN+iRUNNOFYYOepadE5UHGhl5Dd0Jow
	 3SJ9urBDneMgL5mF0Cw1Z+3nieDQZ3O47aX5O/vbcVAbyuPItDIlozZqV+nz4/CdJG
	 RXiuFE/4QctTg==
Message-ID: <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
Date: Wed, 29 Apr 2026 11:09:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: Michal Hocko <mhocko@suse.com>, Minchan Kim <minchan@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
 hca@linux.ibm.com, linux-s390@vger.kernel.org, brauner@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, timmurray@google.com,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <20260421230239.172582-3-minchan@kernel.org>
 <aesg-sj6_VmXyqxb@tiehlicka>
 <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com> <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka> <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka> <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afG-4hq7Hr62Uu6J@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C472D160012
X-Stat-Signature: fdj5pbrtq77qbzy3e1xdffudfeusi7e1
X-Rspam-User: 
X-HE-Tag: 1777453799-302760
X-HE-Meta: U2FsdGVkX1+s9Lm2Gt6vHFNkHhQSJJQAqpzy0p0hP+2YotFcSoYHTRIXn73lIE0yJBsj2OllEC7g5VzRexxfy29FmqY1F05/6PbbNEyDhNmWWh1mL6jlecHoaKyal5ZS7nItsEG8zWEB+qQ0WTDsmDSKyMLgXR0AJHeCq2mK5B57NMDqbKExsdXc5Cu9O6xG07//ABrOi63eRuRRUlatG5V3dDz/EO2IvNwz1IZ01qThq282GDtVApYukJc8lYZaFk1JEubq/bI7ro9ulMGVkc3nm4Q7cqWOBF53DvjkdFSiuapXGB+/qSnn7eATMUlg4k66FUOjNsNSAIHBVl/cCTQzwHsdsnWybT+hp4OlZGxEtZ0fvXKmK9E3nuPGFHzbdQxr0czI0kOPhjyvouf0nZK37o9v0vsV1KWzElqMiJvcmli/T7/ToimF/ALWuJg0czoj32dtTAYZfx0XX69HZqvA+8kpMmC3wUEsR/MGsi+YuagO4lxSuHubpXP7c/MrAQAw4a9AMO4AE0er8ptntJxo/P35DdCT1EhizR8aTV5gBh4S1o7R2wkI5kUTSx9EEW+rlJlTsRO0CmSxSgZGwpUbmamzlh1PEcZY2EeP7dqobFSkWOCT/IgF/KxQEk6hN8P5MZlsbkgXxThKKy0ZWMRRYFhyDZgPmpOxr/NmoaKHmxL7ed2eL0aZb0pJYZbMK9g2iPmkNZmXafkAohB3V3x120fB+FixFe9uZY0Ugy/BaAAESlRe2DklzVSsd8QtxGS82lguU09fSpT/4OiaKfCP8XVblid7tFeRJvg8iooln4W+mkCTSN9QHtUT1sLFJIBWpsPsTn/sLHMrwuGtBM9wYjYggtgg0X4nAdUyl5OJ08S0kpYVKuOvPG5Qs0itRliWWlL/0Z8YXHxxMK14u421TQMafS/uniV75xV1SZHAP5Jga6P8mu8jE1+MIjRXI+MbEI0/PM/pbIdeatx
 HzORtL37
 VsNlX1thN8p4Zl+svmXfhYsgVmTSK3zCBlKmf3MbbAPjhJUbQK/rsS+iSGtpZTSoJYtON0KcmJNTqW4df5rGtbn1E98ViGBqyQ5pM2+/hSCyg4tIfcoLIjsXsACoICjY06rLrseR3Qgyhq0mLv8dGfVcQV3BN3qZZ9Ad/UDOiGnXkWINohwNTu2/3cct7RrujjavCZXMlsGoM0wdsKyrIO+ugLSIf7KREIIIGrZ22dSPwPtxeSH9olWOW1bysIxzTh5TAo5VqR/aNxxgBh0CJk3Fz8Fbbgezxc9cURIfCE/Uiv/wx7xjylgIW4A/29UKvlUVZZz5UviXc0Hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 10:18, Michal Hocko wrote:
> On Tue 28-04-26 18:19:31, Minchan Kim wrote:
>> On Tue, Apr 28, 2026 at 08:56:36AM +0200, Michal Hocko wrote:
> [...]
>>>         DESCRIPTION
>>>           The process_mrelease() system call is used to free the memory of
>>>           an exiting process.
>>
>> "Free the memory of an exiting process" implies all memory, not just
>> anonymous. User cannot know it will free only anonymous, and I am trying to
>> make it work as intended by completing a symmetric reclamation path.
> 
> Page cache doesn't belong to any process.
> 
> [...]
> 
>> >From cf292f8f8ead8df9161aad342c36633ffa90257f Mon Sep 17 00:00:00 2001
>> From: Minchan Kim <minchan@kernel.org>
>> Date: Tue, 28 Apr 2026 16:39:06 -0700
>> Subject: [PATCH] mm: process_mrelease: skip LRU movement and expedite clean
>>  file folio reclaim
> 
> I will let others to discuss this. I maintain my position that this is a
> hack for a very particular use case and you still seem to not explain
> non-Android users of the syscall. Anyway, I will not repeat myself here.
> 

One thing that got lost in the thread here: this code path is not
process_mrelease specific?

We seem to end up in __oom_reap_task_mm() also from ordinary oom_reap_task_mm().

There, we unconditionally set MMF_UNSTABLE to then zap_vma_for_reaping() where
memory can be "reaped".

So why is there "process_mrelease" part of the patch subject at all?


The only other scenario where we set MMF_UNSTABLE seems to be when we run into
trouble during fork(). CCing Liam, I wonder what it would take to remove
MMF_UNSTABLE from fork code now that we handle some memory freeing while
aborting fork() "more elegantly".

Unrelated stupid question: would things be clearer if we could rename
MMF_UNSTABLE to MMF_OOM_REAPING once figure out whether aborting fork() still
really needs it?


Back to Michal's original question: I guess the real question is the interaction
with memory reclaim that would just collect the access bits beforehand.

-- 
Cheers,

David

