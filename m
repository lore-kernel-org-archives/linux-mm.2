Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51B42C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102A86B008C; Wed, 23 Sep 2026 03:37:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B4206B0092; Wed, 23 Sep 2026 03:37:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0B1F6B0093; Wed, 23 Sep 2026 03:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE82A6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:37:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AB938070E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:37:35 +0000 (UTC)
X-FDA: 85244222070.13.B5A9A4F
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8452320007
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:37:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=m2w7lrCm;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790149053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YBlfW8eP60PhYp73autqoOChF6Ibeh/Qn5gQHJ0sRlw=;
	b=zWdx6Z0++Ineq1MZ4G6FW6pBS5LQ415OlFWEM85f+bTusHZiUjNrKZmhxzKncl9YXYG3ia
	fciX0B/BhUU4W6AeK4IVSA9L3ROYlbADjCzvjOs3uFhAEqpXMi7LlWbJfhpmL7X1yL6Kom
	4jaLoOQftIR7gPWAPkuzWASH1H7Vy04=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=m2w7lrCm;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790149053;
	b=i3H4VWu+ouYRwb/QMYsuj5Ut6BOPs/Pb5uD9pU2wcSuFBE9lx5BSEmdbupNjCmiFtWA8hD
	/khVyjeyZqlSYp+b1UfuQW04/8yObdUQKZSrRZz355L58PodNrjyfuEhBUPqXCi/05gGGe
	sMn8rHFxtBICETfRCUrLwRXTBGr85rI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1790149039; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YBlfW8eP60PhYp73autqoOChF6Ibeh/Qn5gQHJ0sRlw=;
 b=m2w7lrCmtUG3Ip6qeNEha/+6K69JOrljbzSx5mLUaqgEqUuvKQ9ehKE+qwNLcF/6/g1REx
 2xKloJmIAOc5Kr1IbkNT34tIn8pDz8ZEhO3SarOOs7vENQUZjJGVlDMTQUAYirYDe188Qq
 k++CnXNs5ustxGgsCvMMcRvUkfM7XlG14PhU4JyrLYv8TKRKPrS3zeTHVaYt45XOn6Z0u5
 nQuXYpcN8zI41RmcWxI46TaNfzih9irs1uyEPKwHF+lTvjWPcbSbGOA1K8OTyamqnls4s/
 0um/TfyapCjBnaCuH5cPzDxEbCuSQBLfoPsMV1XKVXPwL/x8DL1j7PPamS6V6A==
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<aiqi.i7@bytedance.com>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Date: Wed, 23 Sep 2026 15:36:13 +0800
Message-Id: <0c6688d4-7978-43d7-9421-43cfa6230c94@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <20260922190041.d5d983ba6fb1475e40568eea@linux-foundation.org>
References: <20260922090749.24905-1-lizhe.67@bytedance.com> <20260922190041.d5d983ba6fb1475e40568eea@linux-foundation.org>
Subject: Re: [PATCH v2] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26ab381ad+4ea906+kvack.org+lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Stat-Signature: tdt19r73khxz63kqcxg1ynofoyf8iia6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8452320007
X-HE-Tag: 1790149052-775118
X-HE-Meta: U2FsdGVkX19TCnPI7vncj1Pp0pX4+TXwqRiGcWhMWdbJ5HMIHJntW5UxD5nu5fo0rZT0SQtJ73Gd8+HYZY855lacmLuF+OqsoECg5Uk6iLlNQdjQ3FDxcNoXrY+nEPuTwpelh0ATopTj8lAByGJxS+L7SYN8ZUhDNZBuj8FvM/J8s+s8T76FvRtnrRw4Xmk5QDYVr/az5AMpcHjf+GHkb9cTcwnsWAG4zSZyMzv7/EtJekNxdEun9BuPu9rt5B2Pzvz9mqWcx2GN3VZ8kXdUrBr9fNFluLJaHo0SaHdU0KtTKR+vIxMjcCaCHo1sYFv6/osn3WTlAGndH1fGebpLW6YIkmmOWBGQh5sB6Mq+jNXLeUgKaJNFGk7zntWZ+aR6IIXoLZ9A8dx0M0A0SE3XIg35oIriwkH9ee1kkv+rcWqitxBhEFl5rMyOq0KgztaxIauPmA3NXZvQcMHSXdYwPPKAMy/pZwdej4GAms4jQlw7zRS8q6bVmxahzaLoRMYsk9pUStlBaDipaY9K5Tw4aqUNunDaVefzj+x1nrK2+T7m7qWC6ulXjMHmMXBJi0QJLKhLU/rO3RKRW3S2gS0eHi6MR2I+G9ApF56690S5Y+6bVFG9/GYw248KCzLmX8L5qpNevXVnCjNaA3IXn7R/Vv6GzEm3bZyaYbXkXYMiAL2HKrOjLNaZqF0SB0SQ2KVctgil5w/c7s11yKOX5WTYq7lyRzja58t1z63GDjpoPZDHGaan2GPlIZ5EoO3b5nKz0cfghmtvO+an21K1z5gKGn5RD3oDAjA1jI0h30SWYGNoYrv5gaLrcd1qurevK61Ayr8R+jdNa3P5nxzSa+JepNy/axcwKK335JPy9os/hefgVY4Yu9kE7fMhQ+jgUimMiK0NXeyFH2N7K9tsfQewGs9qWSl+4hxkNDAGd+We6TrXOEpxrazIu6/Lau3eM2HhoVeRcrpIxxNGRKuDjqR
 tdtlJWmF
 18y1k+9qxu5b2Rmg+bbRJRHI4sACwpJSV6IsjTg9JvsYCxJHm5aRf0mRSVomwuWRB0sR11pBHZvDekc9Djvk4dGxOT/XG92jiQRUJiC0kVxazWBxeYd32f3QaUSKb+u4PN7/0Qechx1SEionqyXaCPC1g8PUSZ4id+U7zjV/N/qxpR8V9DnysW4RQZiY20mv4K9Hs5ZgXkKNCs32QHJmFNcnEb4fssfagxdeQxlwyWXc3vQwMGVO2VRMXcvpBMWfM0ZG1Jdzxiuy4gvaWNXbaoav09ShiB3mvyIV/qqBbtlvxsn4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 10:00 AM, Andrew Morton wrote:
> On Tue, 22 Sep 2026 17:07:49 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrot=
e:
>
>> Hugetlb currently expands MMU notifier ranges to PUD boundaries whenever
>> PMD sharing is possible. That is only needed when huge_pmd_unshare()
>> actually detaches a shared PMD page table, because clearing the PUD
>> invalidates the whole PUD-sized virtual address range.
>>
>> For hugetlbfs hole punch, and similarly for other hugetlb unmap paths,
>> a shared mapping can pass the "PMD sharing is possible" range test in
>> adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file has
>> never actually had any shared PMD page tables. KVM then receives a 1G
>> invalidation for a 2M operation and zaps unrelated secondary mappings,
>> so the guest has to fault them back in.
>>
>> Avoid this by remembering, per hugetlbfs inode, whether PMD sharing was
>> ever established for the file. Set the flag when huge_pmd_share()
>> successfully populates a shared PMD table. For the hugetlb unmap paths,
>> skip the conservative PUD-sized notifier expansion while the file has
>> never seen PMD sharing.
>>
>> The state is intentionally sticky and file-wide. Once PMD sharing has
>> ever happened for the file, the unmap paths keep the existing
>> conservative expansion. This avoids the no-sharing case without adding a
>> page-table walk to every unmap.
> Oh.  It's not feasible to figure out when PMD sharing has ended and go
> back to never-seen-sharing state?


Yes, it is feasible.


I did consider a refcount-based approach before sending v2, but my
initial version looked more complicated than I was comfortable with.=C2=A0 =
So
I used the sticky state in v2 to keep the change simple and avoid adding
page-table walks to the unmap path.

After looking at this again, I think the refcounting can be kept
reasonably small.=C2=A0 The updated version uses a per-hugetlbfs-inode
counter for active PMD-sharing attachments.=C2=A0 The counter is incremente=
d
only after huge_pmd_share() successfully installs a shared PMD table, and
is decremented when __huge_pmd_unshare() actually detaches one.

The share side can run concurrently under i_mmap_lock_read(), so the
counter uses atomic operations.=C2=A0 A zero count is used to skip the
PUD-sized notifier expansion only after excluding concurrent PMD sharing
with the mapping write lock.

Sorry for the churn; I will send v3 with this refcounting approach.

>> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this patch
>> improves P99 QPS stability while punching pages, reducing the QPS
>> degradation ratio from 7.09% to 1.45%.
> How realistic is this test?  IOW, how much benefit can people expect to
> see in real-world usage?


This was measured on a KVM workload using hugetlbfs-backed guest memory.

The workload performs policy-driven 2M hugetlbfs unmaps while the guest
keeps running.=C2=A0 The important part is not the policy itself, but that =
a
2M hugetlbfs unmap can currently be reported to KVM as a 1G invalidation
when PMD sharing is only possible, but not actually active.

So the benefit is expected for workloads with secondary MMU users, such
as KVM, that see sub-PUD hugetlbfs unmaps on files without active PMD
sharing.=C2=A0 In that case, avoiding the unnecessary PUD-sized notifier
prevents KVM from zapping unrelated secondary mappings in the same PUD
range.

For workloads without secondary MMU mappings, without sub-PUD hugetlbfs
unmaps, or with active PMD sharing, the patch should mostly preserve the
existing behavior.

>
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -921,6 +921,9 @@ static struct inode *hugetlbfs_get_inode(struct supe=
r_block *sb,
>>   		simple_inode_init_ts(inode);
>>   		info->resv_map =3D resv_map;
>>   		info->seals =3D F_SEAL_SEAL;
>> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>> +		info->pmd_sharing_seen =3D false;
>> +#endif
> This could use a slightly modified hugetlbfs_set_pmd_sharing_seen() and
> remove the ifdefs.
>
> 	hugetlbfs_set_pmd_sharing_seen(inode, false);


Thanks for pointing this out.=C2=A0 I will fix it in v3.

Thanks,
Zhe

>
> Not very important.

