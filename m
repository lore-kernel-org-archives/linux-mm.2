Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69BC1606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 03:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Lxmpmq12
Received: by kanga.kvack.org (Postfix)
	id 3B3EF6B062E; Wed, 18 Nov 2026 22:56:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365726B0659; Wed, 18 Nov 2026 22:56:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253D86B065A; Wed, 18 Nov 2026 22:56:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27F46B062E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:56:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86323408FE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:56:08 +0000 (UTC)
X-FDA: 85450505616.01.A342094
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 544681C0002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 03:56:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lxmpmq12;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795060566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BkbJSF4aY5DwwRvkf74HcCi1x+58qV+mJKy0JwfSO5s=;
	b=jL8liGhbaaWuRK6IoqvHzQwKcbsV1r3xtlcymOda6FnBl+7JtwFF0KN1EovN8+iUh1HiGZ
	mOQ8wF6ct0nk0g8P8mt1l9BYxER2OIkiFrAJJvfVrgdo3wl82XLU8GOHhWCpGcUWagsSFV
	0gqJ96FYmrq+BzlOgOKZ0Npd/boeE80=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795060566;
	b=OWe+Lpp/1GYnDu3bpyfoduqo1Fg2hLsnYu1Vdt6b23SPeL0330w3TmJpZGH7CSXXDEZflK
	9kqvO17o98/xKCyBGSiizqz5cw7q/PUAP58tTgKyq59T+xPkvWjp/n+4ocZbhSHDCV8HvU
	k+kbY8W7tkH7vLmI5f39C3sGtxS/tkk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Lxmpmq12;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2515B1575;
	Wed, 18 Nov 2026 19:56:02 -0800 (PST)
Received: from [10.163.128.149] (unknown [10.163.128.149])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF1013F632;
	Wed, 18 Nov 2026 19:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795060565; bh=WWLj3TJuHvOcKDydq7vUx0XFf4zQYs67gD5nDNDmk5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lxmpmq120iVYYZpt/BMW/eZVPiMYER6b0FkFrrXxHMi1YgKpd1d1xf+vlY7aF+pR0
	 cKuB88IF/zv8zJtYN00aCQcv/3txCn5Wyj8Pwmml1dGuxUrDAT5nKyKDr5TuDudo/o
	 7nvwwmuEopoV0sXNOCuHnVRmjZkofU1kozzBSzSM=
Message-ID: <5aa0c814-b3fb-4588-bbf2-fa141235c8bb@arm.com>
Date: Thu, 19 Nov 2026 09:25:55 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 0/5] mm: remove unused functions
To: "Garg, Shivank" <shivankg@amd.com>, "pfalcato@suse.de"
 <pfalcato@suse.de>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
 "chrisl@kernel.org" <chrisl@kernel.org>,
 "shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>,
 "willy@infradead.org" <willy@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "youngjun.park@lge.com" <youngjun.park@lge.com>, "jack@suse.cz"
 <jack@suse.cz>, "minchan@kernel.org" <minchan@kernel.org>,
 "liam@infradead.org" <liam@infradead.org>,
 "baohua@kernel.org" <baohua@kernel.org>,
 "kasong@tencent.com" <kasong@tencent.com>,
 "jannh@google.com" <jannh@google.com>, "ljs@kernel.org" <ljs@kernel.org>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "senozhatsky@chromium.org" <senozhatsky@chromium.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <f3219880-c944-473e-82cc-bd6b4196badf@arm.com>
 <27ef4d8f-f4fa-49aa-b166-8335ca6f5898@arm.com>
 <c28c2ab82afa2cb3f331f1f3b3b20159bc7767b1.camel@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <c28c2ab82afa2cb3f331f1f3b3b20159bc7767b1.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ujyx86s8nhcqzcgi1d8k7ane4za5fr5p
X-Rspam-User: 
X-Rspamd-Queue-Id: 544681C0002
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795060566-637328
X-HE-Meta: U2FsdGVkX1/XCunhbm2hk4/TtFl0UoCRN56zGI7mTg/hyoxaLZwG+99dfknKXcQtqIwNEieXYIY1sSfwR7eOJ0lzCao0ysDR99tRcTalReTkj+eSrbkmu5lKBNd0M6Mz8R0F12PDsMuNAqJjykDWVMDB/UQRE76L3qJZjZO8bychT1jw1lgGFSjz49mwae3YSOCwfMKDaFJYWVpwU1kcYUclI0wrfbfcJ00Iex8oT3EQIbCAWElKoWzExxqveIQZuPdHtO4YESlRUywZkMMU1ujURmB/OyLzFiwH4zBIwfuT333C6dQrqTN9RE5GA+Aixc3moTl5/Uvg51zdD7UDa9kPsAfAe/MxjTQMCudwv4CLFsoBlPoKDwl12E55Jyj1Jd5tozy3G7lHJodueH2E4/T0hAMSlTdV7JC0VOay8Q+33hX2/XcMY29aQe8LTUdx16Pq1wOIxBLA5m3dGg62IRTBBPRKRmXx2QDYtsUSKDz+9k5Hb1iz0CnvykGvHD6bbaXs4FwBg6FjHP+PYGMLfZUpeDzkCkMut8sLQG0TWHDkr8yEFcyLqBQTE8aRwtAzwyyMJCh3cvUMgCwoTM/7fR+ie32W0UOyWJEWE6U0lvyh3whxnt0TMSaPXIrdqmJpffrolSwWD4RGlU6t+p4fQ7w99XggJxh5e1Jq5LXWjI5mM3NVCbh8h4QA5w/GcI2IsWZ6ZL3OdkBjPz+95ZqJK71Cm1gWi6CZ9oKID7A2Ls4vxmvXDfKZmdZ4lKut1q9v5mtWU+FzJi5+BXXHClIqiG858gpQM/opOVcrH48VHSAIa3kwk+sNffH3xYe2UUGizzBwCywDS50mMJy7dB0e+PCUT7ShiO7t0fCNM6lYdH8coCv18Jb1+F/T7nILyFB4sx3hgNtS/+pG70J9fGH0QwVF4PqLAYJ1IoSCW+saOBsh1pcPHGRWBFaej+AdhDi9SVKKbYbh+gZ/PayBDMF
 Q/uQC9rs
 9Wgpcxn8IFEXsJ3lo+pOWK0jZQRHY524lgfDNy/yH2SILG5RQWUjCyCL5grB4mDMznspbdYZjmMATMKwygnYVodO8nwee13rYdtodv++Tr20PQzXeSiTWiD6LZrGHKQZKHXl4swGlOOyniKC/Gce6hEwgNc5g5Yy32y1H07RxIu4vKXy+8QrVFxaYSguA963maodObrkBw5M1cXLuGO+Iv38jWiatKEbWvp6HvsFdIZQhJivR3GqZeeebZHprQe+qHEgBqMXe7Jdu2TAXlItJb2M5f9ENtNT7gw4K5pcG75JMtGBn28TfF7nE9ZstL7ZqWL+jBMv6osJSiLN0t4nxNlJMsp+kSU7s1UTbzqpFC+iFu40pztUojgJSF1DtdRP66T2VXCcYepe23Isc8IdG9FwoPCXsXfwPMgY2S5pCaYZZb+Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 19/11/26 12:25 am, Garg, Shivank wrote:
> On Wed, 2026-11-18 at 22:44 +0530, Dev Jain wrote:
>>
>> On 18/11/26 10:35 pm, Dev Jain wrote:
>>>
>>>
>>> On 17/11/26 12:46 pm, Shivank Garg wrote:
>>>> This series removes five functions and one variable in mm that have no
>>>> users left anywhere in the tree. I found them with the kunused scripts
>>>> [1], which I wrote with LLM's help. The v1 cover letter [2] has more
>>>> details on the scripts and how LLM was used.
>>>>
>>>> Changes in v2:
>>>> - Split v1 [2] up by MM tree, as David suggested. These five patches
>>>>   are based on mm-new. 
>>>> - No changes to the patches themselves.
>>>>
>>>> [1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
>>>> [2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com
>>>>
>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>> ---
>>>
>>> Okay I just recalled that there have been numerous cases where people ran
>>> scripts / compiler with flags etc and sent patches to remove unused functions,
>>> but maintainers rejected them citing they are there for a future use. Here
>>> are some of those instances:
>>>
>>> https://lore.kernel.org/all/20240907021506.4018676-1-Liam.Howlett@oracle.com/
>>> https://lore.kernel.org/linux-mm/20100211052247.GA15392@localhost/
>>>
>>> So I think the commit messages need to do more, they need to prove that the
>>> unused function was a genuine oversight.
>>>
>>
>> One way to do that would be to mention the commit and its date, if its too old,
>> or, if it was part of a patch series but then the author changed their
>> strategy in the later patches making the function redundant, etc etc.
>>
>> In patch 1, you remove mapping_clear_release_always() but d73065e60dcc 's description
>> implies it is going to get used, which is confusing. Maybe we are missing
>> a genuine bug, or the author forgot to drop the stale description across
>> revisions.
>>
> 
> Hi Dev,
> 
> Thanks for the review. I agree that some unused symbols may be kept
> intentionally for a planned future user, which I checked for before
> sending.
> 
> For most patches I had included some history, like the commit that
> removed the last caller or the commit that added them without one. I
> missed that for mapping_clear_release_always() in this patch and for
> make_guard_swp_entry() in patch 2, so here is the history for both:
> 
> - mapping_clear_release_always() was added in b4fa966f03b7 ("mm, netfs,
>   fscache: stop read optimisation when folio removed from pagecache") and
>   never had a caller. Earlier version of had called it from ->evict_inode()
>   but V4 dropped those calls as unnecessary [1] leaving the helper.
> 
> - make_guard_swp_entry() was added in 7c53dfbdb024 ("mm: add PTE_MARKER_GUARD
>   PTE marker"), has never had a caller, and none has been posted in 2 years.
> 
> I left some symbols out because a posted series adds callers, for
> example folio_dup_file_rmap_pmd() and folio_is_pfmemalloc(), or because
> they are one half of a pair whose other half is still used, like
> kmsan_poison_memory().
> 
> [1] https://lore.kernel.org/all/166924370539.1772793.13730698360771821317.stgit@warthog.procyon.org.uk

Thanks! Sounds good, you can reply to the individual patches with the additions
so that akpm/David H. can fold that in.


> 
> Thanks,
> Shivank


