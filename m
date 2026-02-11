Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29B55EB5965
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 04:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297236B0005; Tue, 10 Feb 2026 23:18:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243D36B0089; Tue, 10 Feb 2026 23:18:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1503E6B008A; Tue, 10 Feb 2026 23:18:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 016FA6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 23:18:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E437140228
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:18:56 +0000 (UTC)
X-FDA: 84430870272.14.B9AE0B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7CB1920002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:18:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770783535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GoNia19sE5JxJTF/7e9eEhNBEgLtCnk0qUI/60l/U14=;
	b=qi9Yt/18aKY34wMz4fEn33R0W+VEa+j+7PVBbeSiN4pSrKwDoe5bs9+WgScgB+VLVJ2GGW
	9v+0F3zW2QguLqxpRz9K7PnqtNQ2AZHrz7fjZjpTXcwwBKks8fX4HUyLs9BF+Dl0STkEoP
	NIJkv/JiMn/ldo8QUIobGQ4a/vpq13M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770783535; a=rsa-sha256;
	cv=none;
	b=ij0sYVO9yTCSFpt8c8gfXnkc305hoJYlljvUspWlLrbAZmvV03qJoBFIP3+4GyfDdohIS/
	Rt79l2Fqn98zU4tghn2EDDuq6Ru24jAWD4boKWPfEcR4xyDfHoG7e74AMkxLncqKH2Tmpv
	UrjXCLOSMf6NZHnGGGpXAlQcOi/Ste0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1667D339;
	Tue, 10 Feb 2026 20:18:47 -0800 (PST)
Received: from [10.164.148.41] (MacBook-Pro.blr.arm.com [10.164.148.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ED8933F632;
	Tue, 10 Feb 2026 20:18:49 -0800 (PST)
Message-ID: <52ab55c0-6b70-4afc-866d-dd505ff3e85b@arm.com>
Date: Wed, 11 Feb 2026 09:48:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in
 do_anonymous_page
To: Wenchao Hao <haowenchao22@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org>
 <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7CB1920002
X-Stat-Signature: tryoa1adgt86qgc94u6oyojs3t3dkzw8
X-Rspam-User: 
X-HE-Tag: 1770783534-916420
X-HE-Meta: U2FsdGVkX1/vFnXARo1MKY+NW4/ey82Y6CXAFjD0Bso2xITJUp/JiWmXPQ4o49i5CH2HslQMzF9Z+SZ5JUo4AMC+oXIF5lsF33C2fk2MA+LCZviC1/D9t0PoJq5p0XzcGHBSqBvRdsKhIyQlYNCWDJsP69LM6TKT8hI7zOxkY3jcIRNlZErATAgRwWhfw6C+Cjy+48UKvNrmJvALp5tVVTo0yXWo+stQUNvLh0d/4OUlg1xmAj+mRitQZ+KSCGHbDwAldFLjv8QFmP2RDkl3HMZrR10rnG7d4rygErsksgpS0/jbBAcM+mlN/zsl0uBZwsqMM2N3L+eW3kuL7Ml5kW/bzaPW3vv4kQ836ZFlSmIU0nps3gDyyWIebNN02tnLJeRfPztzugAckTrojIw69tsNF83B+5kW/1TQSs2/9VDrnphxj/mBXUeTE7l2KnEJsfNcxrxbyu/cygHgIS8BnSZ92o4erjOkPVP0y1TLNKoRpi/hEUJwKA/crbqEz2gyOlgzFpxZ40sXSVm5Z1/z/y1BhbIH10AvNiG0jSgD7Lql7S+5Fn+bnsA+0GKV2cJ+9N0gr4Se4F8oV2G+vuaLnhRhb46POhjdtnHJWB/VYyvKkR2LMnaaLu2c+F9oApNmMRF4Jagm8BbLosV229r2RYA/ni6cph9QpH6dcQXEnYvZIGvGChYTIW9YpSbfx5CAmnVC/zgL1hs+i9LD3pCasjLjVVR4Rmyixb8WNU/xyD1+3bBzrVE1LEt6gCB6XRp0NtVBP7Zo1U3d80COn3DAtsk9yOeKDz1wZIlbodmWUDiJxIL5owdQUoOD+KMcTD78cTSFuamiQePPjEy1763r+uVX6psDrCHPdLOF2oZ75F7SA4hjQrCJ+UEanD87mJKul86jPSa4z2GKdLdI93nqiBmjqEos73Fmv9nIWNZvqypfGXndsoVTBtlicTWXe9OZPyVheXMeuufJuxO3ALw
 SnQmzfMw
 N5P7cErpSZmq1OO/+nCJgC2qBEmQy/7F0IW16EbEgSc5RkzIK7dDwJYZi1cprl7c4t1l+9fdg63msjV06eA8ZAn3E8guPef10sdduKvtyvpaz8P+/3nokndvybqBZ5B5fUTVgxoDIo/AI5Mb5EUQgg5Mg/ZH+zOTb+QPsnMRyB0Fin4JkpQVuUzNY5TdnDsrbhXi4/Aolrw1DjYHxVEH599pqiwpde20QF3NQykQVVZ4TElKr8qM3DIC2Juh054lvcKr5RQNpAxdXfxLnJYeAITNl+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 11/02/26 6:19 am, Wenchao Hao wrote:
> On Tue, Feb 10, 2026 at 5:07 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>> On 2/10/26 05:34, Wenchao Hao wrote:
>>> When do_anonymous_page() creates mappings for huge pages, it currently sets
>>> the access bit for all mapped PTEs (Page Table Entries) by default.
>>>
>>> This causes an issue where the Referenced field in /proc/pid/smaps cannot
>>> distinguish whether a page was actually accessed.
>> What is the use case that cares about that?
>>
> We have enabled 64KB large folios on Android devices, which may introduce
> some memory waste. I want to figure out the proportion of memory waste
> caused by large folios. Reading the "Referenced" field from /proc/pid/smaps
> is a relatively low-cost method.
>
> Additionally, considering future hot/cold page identification, we aim to
> detect 64KB large folios where some pages are actually unaccessed and split
> them into normal pages to avoid memory waste.
>
> However, the current large folio implementation sets the access bit for all
> page table entries (PTEs) of the large folio in the do_anonymous_page
> function, making it hard to distinguish whether pre-allocated pages were
> truly accessed.
>
>> What we have right now is the exact same behavior as if you would get a
>> PMD THP that has a single access+dirty bit at fault time.
>>
>> Also, architectures that support transparent PTE coalescing will not be
>> able to coalesce until all PTE bits are equal.
>>
>> This level of imprecision is to be expected with large folios that only
>> have a single access+dirty bit.
>>
> Thanks a lot for the response.
>
> I saw this description in the ARM manual, “D8.5.5 Use of the Contiguous bit
> with hardware updates to the translation tables”:
>
>
>> If hardware updates a translation table entry, and if the Contiguous bit in
>> that entry is 1, then the members in a group of contiguous translation table
>> entries can have different AF, AP[2], and S2AP[1] values.
> Does this mean that after hardware aggregates multiple PTEs, it can still
> independently set the AF and other flag bits corresponding to specific
> sub-PTE?

Yes. Hardware can update access and dirty bits per-pte. It is the job
of software to aggregate them.

>
> If so, can software also set different AF bits for a group of 16 PTEs
> without affecting the transparent PTE coalescing function?

Yes. See set_ptes -> __contpte_try_fold: look at pte_mkold(pte_mkclean()).
We ignore the a/d bits while constructing the next expected pte.

>
> The reason I have this confusion is that there is such a description in
> “D8.7.1 The Contiguous bit:”
>
>> Software is required to ensure that all of the adjacent translation table
>> entries for the contiguous region point to a contiguous OA range with
>> consistent attributes and permissions.
> It does not specify whether attributes and permissions include the AF bit.
>
>> --
>> Cheers,
>>
>> David

