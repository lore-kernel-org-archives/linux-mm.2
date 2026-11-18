Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87CDA60A2602
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ObJGyse0
Received: by kanga.kvack.org (Postfix)
	id A2CF06B05B4; Wed, 18 Nov 2026 12:15:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A04896B05B5; Wed, 18 Nov 2026 12:15:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91A076B05B6; Wed, 18 Nov 2026 12:15:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7286C6B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:15:02 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEE5B160828
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:15:01 +0000 (UTC)
X-FDA: 85448890002.26.2F9599D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B9EC100008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:14:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ObJGyse0;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795022100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbPVxoxfdmGztrFbfvbxP7f4LGo/LFsskgdu9AUgwZI=;
	b=1W92EZXvJgOKrQM2Z8MHOynV4JmK1q/DCPtEk85M6RntousrYvpDvTvF8UpEfe1SpU6iFp
	ZPiQDUZ5l20JpVIVRRFVAJrO/mGL2Vxq52OS8YQ3oAP10lwbqxjJZ8zyoRtwQwWDNzmmtH
	VYdmhUuBzlyJ9nS3HXgCq5bQIagyHhM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795022100;
	b=zwtAZna6j9ZgTscNxSnA+CkOKocsMSievKGMM8lH5oqvhyjQ0ClSfD6GolF7powW3zhtX2
	0geIdoHLVcVO8r+63xATlez5SR4oMSK5P8KrJX0W/a+MF+1Sd4lfoa+GVo9BRKCVXWLZdH
	QUa0f0rwRKwxy3ilbxNdZSSTPV8qHmg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ObJGyse0;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 786591477;
	Wed, 18 Nov 2026 09:14:55 -0800 (PST)
Received: from [10.163.128.4] (unknown [10.163.128.4])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CE0A13FA7A;
	Wed, 18 Nov 2026 09:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795022098; bh=5sXytsRGFlO2BU3Kh6Jfrdi1zyqcGfoU7pV+yaj3NgQ=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=ObJGyse0OCTPhtZf7rFgkLxKTCVvvloJVnn6RePVP/IphpVVotf7tAexh1rIz4n9D
	 I8itCqr9/ZieVJzN4+0fPTt++ubUiurnd5IKE6/8vOjlZBBcWBpH3p4fTUdmvumzv6
	 8+03ZM5P+Je0fdgfSQhhy6xOAIWs/XOcinnbY8Vw=
Message-ID: <27ef4d8f-f4fa-49aa-b166-8335ca6f5898@arm.com>
Date: Wed, 18 Nov 2026 22:44:48 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 0/5] mm: remove unused functions
From: Dev Jain <dev.jain@arm.com>
To: Shivank Garg <shivankg@amd.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261117-unused-sym-mm-v2-0-2f845e94dd50@amd.com>
 <f3219880-c944-473e-82cc-bd6b4196badf@arm.com>
Content-Language: en-US
In-Reply-To: <f3219880-c944-473e-82cc-bd6b4196badf@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9B9EC100008
X-Spam-Status: No, score=-22.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: himug3r4rdn6kiaq4tmq8t7goea1pukd
X-HE-Tag: 1795022099-230756
X-HE-Meta: U2FsdGVkX1/7Rk10tlS2VSNmZ25NzTTW9Ar7Za7ZNmzKMOG6zZJbzLfxVvyB1vPe+iRvzNTEqWvpak/R5cEisZjod68katT6XEIMLn9yEeYdJohfub+foFmw+eaiiNf4B45NBqbRNOychUtC6QAAMArW9WKDDb4yRdjuDYRsx4zGGG+TnSEr5cuzOrBORuNPf8+MX4LLfI54Y6WW3eELheLyLSDZFK5AAh/wZYsMVn2c0LmNX2oSEUgaAeeq3J3ms9v7Y2Ger9JexWTOic5Wgo628g+/Rw+VUM2y7B09l++Yn5iZj896sKQg5kf4GEWkuuQikyT9MTuhpmlMIBDfsH7P89/XX6VIcRYKuKvUhpuuKo3hWqE8lGIOvBHoRcjgrgCUemECr5/S96qRLskskx37ZZxPR4FaiwPfPHh1oChGq37rr48CgIlhED5sSSATldjG0CbYyxbzuwC6GjaeSd6z9e2r5LQD/ESBtCH0WDuV8dtMtLmKKrmrAs+RWP/Y7v+0dVVIXXrZKYHFC9A6hedLu9Lne/6jMrFyOKkUZAoM6IkSU3gCNNLIY2H5a8D5TR8h4JwhWV0gMEZL+0bSjlQY/g/GX5rZd7MhPZTpAaadrGcvucJzWr9cQTtflfXq1mM68HtQLSjL8xVQVijcPQz6ESct7e9kyfo9nQ976Mz4LsbeB5ZhaaTE6/3dDjJRQpuvG5TJRmue0eZmNYP/2j9h+5BFZqzZUWYViq7Oks3P0qmX2S6AlG1QQBOmPnOYNUWvOVtW9lJ7Iad5WEaXr5HkMlYT3YePXQoSGuKz4JoLgxU2p/Wdr5LISuwEJrAWqzuSI6rhU4sfsvQWMJRLlOMVzDmqm3AW1NdgUWljzN5NPL4ClrlRXtUUHQzBCIGHo863FYswIRMPpiSYmU/bPL27kvKQPwjOzDhJ7KVb9nhTdj0qn9VnAkKDMJpEnW4PEdkKx2fG0WgenZrSHZa
 tiSRMhwZ
 KuxYPh4wuTVnWZDr65s98x3D2BE8UQqL0Iqi5467vYPCFxtGABHSR928hBEt5p7ZCWpxEFzs2DWfLGMWmBxGsTRTSrU+r8JCHjNeFDDTp26t1Vvqi2z/mmP39lSJtyw1KCPfHHG8XMze9Fb6VRb0DShPkW6y5tOOPlTX5X4guWsbkOSLCS6uDtEjNmG4/d2bFUdZgoz9QD4jVhJu3YGkd+2TbYf386i9IlSZvbu6El5Z2sK4eUDcRDibaHFsO/N6vbzxzn2WX3uOAxXE4FlcuYMv9c5NmedjEJjE5LtYMVkKDRpum0GO/cvjRbmyhu0GtRywwl5dYkTijs/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 18/11/26 10:35 pm, Dev Jain wrote:
> 
> 
> On 17/11/26 12:46 pm, Shivank Garg wrote:
>> This series removes five functions and one variable in mm that have no
>> users left anywhere in the tree. I found them with the kunused scripts
>> [1], which I wrote with LLM's help. The v1 cover letter [2] has more
>> details on the scripts and how LLM was used.
>>
>> Changes in v2:
>> - Split v1 [2] up by MM tree, as David suggested. These five patches
>>   are based on mm-new. 
>> - No changes to the patches themselves.
>>
>> [1] https://github.com/AMDESE/linux-mm/tree/shivank/kunused
>> [2] https://lore.kernel.org/r/20261026-unused-sym-v1-0-82ca2dceabe1@amd.com
>>
>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>> ---
> 
> Okay I just recalled that there have been numerous cases where people ran
> scripts / compiler with flags etc and sent patches to remove unused functions,
> but maintainers rejected them citing they are there for a future use. Here
> are some of those instances:
> 
> https://lore.kernel.org/all/20240907021506.4018676-1-Liam.Howlett@oracle.com/
> https://lore.kernel.org/linux-mm/20100211052247.GA15392@localhost/
> 
> So I think the commit messages need to do more, they need to prove that the
> unused function was a genuine oversight.
> 

One way to do that would be to mention the commit and its date, if its too old,
or, if it was part of a patch series but then the author changed their
strategy in the later patches making the function redundant, etc etc.

In patch 1, you remove mapping_clear_release_always() but d73065e60dcc 's description
implies it is going to get used, which is confusing. Maybe we are missing
a genuine bug, or the author forgot to drop the stale description across
revisions.


> 
> 
>> Shivank Garg (5):
>>       mm: remove unused helpers from pagemap.h
>>       mm/swapops: remove unused make_guard_swp_entry()
>>       mm/swap: remove unused folio_to_swp_tb()
>>       mm/zsmalloc: remove unused zpdesc_lock()
>>       mm: nommu: remove unused heap_stack_gap
>>
>>  include/linux/pagemap.h | 11 -----------
>>  include/linux/swapops.h |  5 -----
>>  mm/nommu.c              |  1 -
>>  mm/swap_table.h         |  5 -----
>>  mm/zpdesc.h             |  5 -----
>>  5 files changed, 27 deletions(-)
>> ---
>> base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
>> change-id: 20261109-unused-sym-mm-8fa76462573e
>>
>> Best regards,
> 


