Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE91EC79FBF
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D368B6B009B; Wed,  9 Sep 2026 10:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EE56B009E; Wed,  9 Sep 2026 10:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD86D6B009F; Wed,  9 Sep 2026 10:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9126B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:50:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8D5B1601F4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:50:28 +0000 (UTC)
X-FDA: 85194509736.08.40C39BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5FF9A0012
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:50:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbWPJbvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7NW1dyCv3G0D7bIn12FoZMla1H+5gjuosuam4xeba4=;
	b=1n/L35uTqKUVezYhCSYauGNXp8TkZPtt6v/ekfNQTcKeiaNEMFoD5Oj2y9URHS+Lzhy0Bw
	yvYfR+F1v3zPnC0DeNp8hGU7OTNKQnWHO5A+r3zZAe3yAeZK1GPJmbSZCSPsWYEnssKMX+
	pBqMwUzVGxmv5sHc8dmdRmJ2C2fWQRM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788965427;
	b=nk5OGG7b7a+TJCCrh5AlJcHXbbDy1Ndx/hpDJh6f8t3wTFfT5BBibBsNKAU/I91SR/uN3z
	rArIkcGjGUuQ4teK+6GAHBwDqs/WqeZ5xiOSYW/LKZK+WbgEcq94rqcHm3VBy+Cwp/w6cT
	X17us3HeZYh7761rL/D8YwJE8dNsGnY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nbWPJbvV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1399343E83;
	Wed,  9 Sep 2026 14:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022F51F00A3A;
	Wed,  9 Sep 2026 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788965425;
	bh=d7NW1dyCv3G0D7bIn12FoZMla1H+5gjuosuam4xeba4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nbWPJbvVOQ+CPwv6Hp/8lwgvFjb4p+ELID0HieRw4+6j5xXH3JJ5ahBguXi46Gx6y
	 YCpXZcL0VbRNXRP5BQasUDM5GQ6v7oNwPCgn7lnslr2nmtHigjVmfCT71qHX0UMSUu
	 DLn3vsrLpgou2R6aD91Kd3pj07eD7eiXWXiAI+Y3QnLgl0YmhDZvpsDgzi6K6FvUi6
	 uVg+L1rYDqIeP6/RPf5yjYzp23I0F7WLAkTHY1jC5pR+teiPvo3yqQTQ1iI8RE3IlV
	 IpSSzuVaNTLi3nvi4PcFuFPL+UjK6tlNm2D5hM0fk/g2pZ0AmhqEUX9i9SCxEuIJ07
	 vtziN/dZmaXEQ==
Message-ID: <08c2d8b3-da89-47d9-87b7-fdc179ec4793@kernel.org>
Date: Wed, 9 Sep 2026 16:50:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 14/14] mm/page-flags: remove PG_private
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Jan Kara <jack@suse.cz>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dave Young <ruirui.yang@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-14-6ae22f9d9272@nvidia.com>
 <d8e9b629-4198-4281-a3b2-d54445201fd2@kernel.org>
 <1BF58667-A9AE-48AA-BA04-F02FB6D5ECF4@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1BF58667-A9AE-48AA-BA04-F02FB6D5ECF4@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E5FF9A0012
X-Stat-Signature: xp3z97h7rt31takd9jn3bhxrciumh4et
X-HE-Tag: 1788965426-332262
X-HE-Meta: U2FsdGVkX18W2cM91yAbR2ygqk0ymRaPnTXqonLq4jb68FXEGbYxI/ZHyJIJMyER883nHKXt3eDSuWAu8crRv+hydvbeBl88hfiKVilYzAA84wkz2atyguROhJOoOb2d/pvo/lXWn4SrKvM40OV1D1tRg8Kv1JBN9NL4MIspp0pJuEtQkA4Vu1KysU4i0azXW2EjOnr8G6nMhT04WWm+7NzzrBVzY4t4rDEA/vwzVsiogBMDKlCiNS8JDHWCd9gAzpQEQbDTM7Af3PGvYg38mwz0z3bZfipXjOFSdvXD4eb59/H0oBnplfSU3G9a8jlQIZPX8G0r/j83biUTvLei3oxAfIelUhxjRFtce0QVez1VG3ujQug6nFHh9JDNy7PpcZTYLJ8JhifHBhWEZQ7bw5F/v3uAWrzGQ1q8j06WMQAsZDYWxLr6pCiA5qkEY4kTW010+59EVo7/LJwZHefaRhmtR/DTW1TVSUqrVbdnpHNuDsA1N6swgZr/iBWV9WKNOztbC6UuafkWLLpjVLLq6rvPkk1P0SADL1F0gYCcv6AIMowKFdx4cLkMHEByAfO0iZcmsiAsRwP5NxcRFmGvdDhjBikLzOKIRyzzAm45+6BBacR9SQEtHVreVJjxUNShPD6edtHjqLsCPB5EUC/5Do8pdAYZ8XHrO4cTlk1W/w+0PVKk+CbcZEt5HDKfbKt8hwM6CI5JeHfqexJmgTJ0ZSkpQeLzpV6oc9M61u8N/PlJ/3lw0h0wVoF/HDyImpww0lM9hhkhsPwIYsHlyWfh74pfASNxJzmbVXWBGaMDURNf4OdPhtSylL7NUgp0vVJJbYDrWgkC93g5ZPbDEM8fTwqTnKOwIYNepCxq5DLgg1X2gPtyDnL0yoiltxXdG9s5wLon+t9xF4Sc85QDs21go+ZUgWUMWBWGr7GFmUF1PIhLolrT/KB/iiQLLubbagT5y7mKumHxvHv4XC50hiR
 0Rikd4g9
 XP/3iyJvtAOXHDtwGymu/kXXFx9fygX5yvDYOhpML4ctlWgE/CuWWQOb1zmORMdGMVg0/jY5YLHnsQ+PcwLHulc7EzeRHkgEk5EaTyFqizrTjF9GStY59JUxIx97DVXk6/zG5lNd/EzHf++gBtDtCpt2JXy8cN6vnMwFyeZO72yA+7uA15J0eJ8wnsi6fiXt1cQ4EpW6g5e9RRKvBO0JA3hsMR4fwgiukJX89kW8/oD4YPCTcGvCiPLf0w6ZunOw+XZo9OVgUquV5rI5lehIbO0re+bYcpDBzsyjA27YCM5V/86wlQ73AL5yw/rAsioUmQx9zBZd7Smhlrk49euPTU9m7KzZoIoD9XYJIS8C6VbOcQ0Arg3nTUgZ/EHcbo5zMiiAvo0xhWR6uHBSWAa0rliyNDwuz5jjbnS8pZu+J1HKrsAqrWrFWnlF4LA7qsgPlkbxS0rGDl+abng6CvAIQBQIVvw83+hcM8pq/wcochgxA5ATAwmjvBc6JA7B7eXU2WpBaal8Xg9j7k0dnxmJJE0Nwn5xvhIo9U55MANhg7fTDtKTtXxVTC/9fxegsix/Dk8wf9iSLH4jn4TgAcUWjUsmDngxcJRkC790naJvShclpRgGJO1kP4oruO5ut1VPVlU7uMUhRSejUqNZMEaX9jnKgzz3+GM0QjQaL3hPzS19W28m42FxZ3OQiZl5C2e6iuaXMEX5xx6cA8K63kg0lJ7bjM/19oaKWWfjXuYn+ry2b8UXagM0Cb0g6OVLZOtPR66hIXcol0HNuN5KKuSzFj6igJHgubrgBvbSgdkB2foNIZ6+HujaPJmJ7XURGLocfSM+Obgi8DbuMKhwjDrT6Mgu7SoQsoJHZlCutnxtGrnvbLxo8sUgM+T88kdSHWPSxwBUCLQT2Li6gh1TTZ2EQhc+lIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/9/26 16:48, Zi Yan wrote:
> On 9 Sep 2026, at 10:31, David Hildenbrand (Arm) wrote:
> 
>> On 9/8/26 04:56, Zi Yan wrote:
>>> folio->private != NULL indicates a folio carries private data, replacing
>>> PG_private. All PG_private users are converted. Remove PG_private and
>>> reserve the space as __PG_folio for future use.
>>>
>>> __DEF_PAGEFLAG_NAME() is added to show __PG_folio.
>>>
>>> Also update files in Documentation. hugetlbfs_reserv.rst is outdated and
>>> left unchanged. It should be rewritten.
>>>
>>> Assisted-by: Claude:claude-opus-4-8
>>> Assisted-by: Codex:gpt-5
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> To: Andrew Morton <akpm@linux-foundation.org>
>>> To: Baoquan He <baoquan.he@linux.dev>
>>> To: Mike Rapoport <rppt@kernel.org>
>>> To: Pasha Tatashin <pasha.tatashin@soleen.com>
>>> To: Pratyush Yadav <pratyush@kernel.org>
>>> To: Jonathan Corbet <corbet@lwn.net>
>>> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>> To: Jan Kara <jack@suse.cz>
>>> To: David Hildenbrand <david@kernel.org>
>>> To: Steven Rostedt <rostedt@goodmis.org>
>>> To: Masami Hiramatsu <mhiramat@kernel.org>
>>> Cc: Dave Young <ruirui.yang@linux.dev>
>>> Cc: Shuah Khan <skhan@linuxfoundation.org>
>>> Cc: Lorenzo Stoakes <ljs@kernel.org>
>>> Cc: "Liam R. Howlett" <liam@infradead.org>
>>> Cc: Vlastimil Babka <vbabka@kernel.org>
>>> Cc: Suren Baghdasaryan <surenb@google.com>
>>> Cc: Michal Hocko <mhocko@suse.com>
>>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>> Cc: kexec@lists.infradead.org
>>> Cc: linux-doc@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: linux-fsdevel@vger.kernel.org
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-trace-kernel@vger.kernel.org
>>> ---
>>>  Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
>>>  Documentation/filesystems/vfs.rst              |  6 +++---
>>>  include/linux/page-flags.h                     | 19 ++-----------------
>>>  include/trace/events/mmflags.h                 |  3 ++-
>>>  kernel/vmcore_info.c                           |  1 -
>>>  5 files changed, 8 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/Documentation/admin-guide/kdump/vmcoreinfo.rst b/Documentation/admin-guide/kdump/vmcoreinfo.rst
>>> index 7663c610fe901..5f1df6d080508 100644
>>> --- a/Documentation/admin-guide/kdump/vmcoreinfo.rst
>>> +++ b/Documentation/admin-guide/kdump/vmcoreinfo.rst
>>> @@ -325,7 +325,7 @@ NR_FREE_PAGES
>>>  On linux-2.6.21 or later, the number of free pages is in
>>>  vm_stat[NR_FREE_PAGES]. Used to get the number of free pages.
>>>
>>> -PG_lru|PG_private|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
>>> +PG_lru|PG_swapcache|PG_swapbacked|PG_hwpoison|PG_head_mask
>>>  --------------------------------------------------------------------------
>>>
>>>  Page attributes. These flags are used to filter various unnecessary for
>>> diff --git a/Documentation/filesystems/vfs.rst b/Documentation/filesystems/vfs.rst
>>> index d3a93eec3945f..dec7816303c6a 100644
>>> --- a/Documentation/filesystems/vfs.rst
>>> +++ b/Documentation/filesystems/vfs.rst
>>> @@ -649,8 +649,8 @@ Writeback.
>>>
>>>  The first can be used independently to the others.  The VM can try to
>>>  release clean pages in order to reuse them.  To do this it can call
>>> -->release_folio on clean folios with the private
>>> -flag set.  Clean pages without PagePrivate and with no external references
>>> +->release_folio on clean folios with folio->private set. Clean pages
>>> +without folio->private set and with no external references
>>>  will be released without notice being given to the address_space.
>>
>> This reads like it would belong into patch #13?
>>
>>>
>>>  To achieve this functionality, pages need to be placed on an LRU with
>>> @@ -674,7 +674,7 @@ filemap_fdatawait_range, to wait for all writeback to complete.
>>>
>>>  An address_space handler may attach extra information to a page,
>>>  typically using the 'private' field in the 'struct page'.  If such
>>> -information is attached, the PG_Private flag should be set.  This will
>>> +information is attached, non-NULL 'private' field will
>>
>> Same here?
>>
>> Likely this could have been restructured to cause less head scratches. I'd
>> expect any documentation that refers to PG_private to get removed before finally
>> removing the bit.
>>
>> Not the end of the world, just a bit confusing while reviewing.
> 
> Yeah, I will fold the document changes into the corresponding code change patches.
> 
>>
>>>  cause various VM routines to make extra calls into the address_space
>>>  handler to deal with that data.
>>>
>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>> index ce7fccd90367b..7b7783c0a5216 100644
>>> --- a/include/linux/page-flags.h
>>> +++ b/include/linux/page-flags.h
>>> @@ -44,10 +44,6 @@
>>>   * Consequently, PG_reserved for a page mapped into user space can indicate
>>>   * the zero page, the vDSO, MMIO pages or device memory.
>>>   *
>>> - * The PG_private bitflag is set on pagecache pages if they contain filesystem
>>> - * specific data (which is normally at page->private). It can be used by
>>> - * private allocations for its own usage.
>>> - *
>>>   * During initiation of disk I/O, PG_locked is set. This bit is set before I/O
>>>   * and cleared when writeback _starts_ or when read _completes_. PG_writeback
>>>   * is set before writeback starts and cleared when it finishes.
>>> @@ -105,7 +101,7 @@ enum pageflags {
>>>  	PG_owner_2,		/* Owner use. If pagecache, fs may use */
>>>  	PG_arch_1,
>>>  	PG_reserved,
>>> -	PG_private,		/* If pagecache, has fs-private data */
>>> +	__PG_folio,		/* Do not use: reserved for folio identification */
>>
>> Do we really have to annotate it with __PG_folio ? I'd just keep it simple and
>> have the comment. That also avoids __DEF_PAGEFLAG_NAME just for this use case.
>>
>> (sorry if this was discussed in previous review rounds)
> 
> No one complained about this yet. :)
> 
> I do this because I do not want to change PG_* values after PG_private after
> PG_private is removed. And they will be changed back to their original values
> when I add PG_folio. That PG_* value churn might be a headache for kdump?
> If I add PG_folio the last page flag, it can be a one-time change though.

Sorry, I meant that you just use

PG_folio,		/* Do not use: reserved for folio identification */

Without any further churn. Or is there a problem with this?

-- 
Cheers,

David

