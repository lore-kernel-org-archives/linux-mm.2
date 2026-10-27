Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F61606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 06:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=rGzDxTun
Received: by kanga.kvack.org (Postfix)
	id 7A9786B05DC; Tue, 27 Oct 2026 02:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7324B6B05DD; Tue, 27 Oct 2026 02:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FACB6B05DE; Tue, 27 Oct 2026 02:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 33D356B05DC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:35:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A57B6A0983
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:35:34 +0000 (UTC)
X-FDA: 85367444988.22.45A8E16
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id A120CC0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:35:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rGzDxTun;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793082933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nvhgt93DuTR0pQyjU1IKAJtbPg/dnqsaG4i1gtQPJHg=;
	b=EqXwgdYW8gX9C/ckPLuJaVE2mGQ4uu3Mf4aUfx9EGVNuVGXJaJcHdO23+XEWk+USvsAXaH
	WIrJ6mzPA9lR1kUziwsi2mZTl8Mq1EOe9czoamGdbBtM17t6kHdmBlU/IBDj35EGpkPFG4
	Gqs61We1rAA12//hbPL+L4FLkobB9P4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=rGzDxTun;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf22.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793082933;
	b=pSew9DSIDRba/KpHYbxj6qS8pSbLXFt5t3vNDYyBORaug/ItozKYP55GDv54TL6QUcdM4o
	7fFivBGl6ykne08ceQIV9TAg75lG0VplJ0MEj/JRbVEtzl9xDo9BwMoPDFH3p/TDXuLonI
	UzLPr0NKMpEaxRLcjPejG8W0MJanWC8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793082926; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Nvhgt93DuTR0pQyjU1IKAJtbPg/dnqsaG4i1gtQPJHg=;
	b=rGzDxTunTXcSAMILCqJ4WIlDsEJUMjYaztyg0jnPg131oxoOtdc+g9Mz9lV7UWjPp8SjoRuJNrCJFkwuhzOfOx90imDMP/2ha+aDyZ7q9Gg3r59ZedXJiWqEjPwAtXO0QOy4+TFqqlRqwv0Q/euLFyT02c1nbszRRHyDmVqdLdI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=32;SR=0;TI=SMTPD_---0XDcvoox_1793082923;
Received: from 30.74.144.191(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDcvoox_1793082923 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 14:35:24 +0800
Message-ID: <d1b55973-306c-4a94-88a4-642581bdfdf3@linux.alibaba.com>
Date: Tue, 27 Oct 2026 14:35:22 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/16] mm/shmem: preserve data in clean folios when
 splitting fails
To: Kiryl Shutsemau <kirill@shutemov.name>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-9-703206d5fa0c@kernel.org>
 <at-GrQNgF3V_tL3w@thinkstation>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <at-GrQNgF3V_tL3w@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A120CC0002
X-Stat-Signature: rnfq49jqujw76jc9hbmyq5df15qgygud
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793082928-476800
X-HE-Meta: U2FsdGVkX18JCDppiuU7A/Aw5mMCts70BIqTJ+VsdKgZ9KvT5Ei6k0OqiyoQ01CxwxgKVnzCs8sA0t1LYCOGBYWQEihOucZyV/LpvqYVPUN9sni5DCPNVKYlmRYOg/6GxriC2nvT9HHFHGTgk7zvC+ZTBvGGSMiFE60D3xtiPX+SWhbDKlblQdE0kDhA+ygRAxDir48c8nhxgiTsF2QHL2iLe6a9GUucbKMuRHsw8+D8zqBujMcgJmdurWdqPz6sLFoc628GrVXOcg2lXwN3VB1EOT4i/kgPyjWuhwph5FDUUqRQBp7QokMjAL2UMCyVPAUTN9uWbTL1TxfVzF/As19GdrvOKAZ6nLlssa60qpfQSihG/9WcCNeFjpwfejQ++NygzN2TXzirvhJDK+eZtIrbSAqYjtgFuqYjuuk6FeX32k257cR8qKNxd6Ugs/69LE0FUq8claun3LlOADjA4ZywvIihwyqRiRqRtOL6qgQ7vKSfcXh8PzDt+sBsiCH6iPl9rYXKrviia5Agz6dOOv7uNEf35z12NWOUPQP6eB0eV6qmE3960HNIytmH0z8BJIbBuj9toHawwwZbYAPS45KbelwGcHVBwQOIxr7LYriWrylSY9C8E+OQvFI0UpiIRYxb1alxO1EnIaKg63PBBszDrMq++fukOsCRZXqRk5pymp6g04xT8t3LGfUqNS4qeC+2tSjhfUegcq2fNF/Ox9OA5gcdW0IMWeXadSrYpPOyXyw1xrrW1/ZPy0BealuZ60QTgbAwKag7WNRUyxt1MlTC8+rWo9ZFri7vAZ1gq4lGFFAglHe6VHPtqODjd8ioz0I1AP0nVSs7CD6y8ViLvgV9zGtY31Wr3hWPPvT5qSRHxkxBYXMQ93qfqJUWAAEdF0d+szWBmDyxAf/TYwXdCoCrzGgwzVeFcR+m6fLXogLyG5BL6ooIvbOqLLtinY7xpFsAEN3L3tY6KCBeUKO
 csqnbYOA
 gf0ugaDGj5Y3n2Exu683Coqgz+NmRcjnuCIAyieyL56aIIa2bXXgr1lD6rT6T1seT3vZxAA10ibWYMk8nX4zkjwpK/m+rJWcotdKE1l2Ki1CELshTcUeROq6WFLRXhEqSFNNSnJGjqtjgno4ooHlttCoL/gioOATG4NU755fvnJ3lw6l429FuStL+CBA9ySXeUguFFS8paHmAWMeY4E6fRgPUifxGC5ueNJo/5ZaGqhBTdhCF5DpsqBbEamWTDgRj+RZvu0ktlbE4BBMRGm5PwUjsxcC84kWnQEv21d0L+pFmV84B/QJ8ui8SR0yHTk1DpyeejrZ0yqWCc1WEZtdEVthd3EBpbOLLEkuhXYOJirEJxTz4VRjl1BWmoYaNEwK4dx5XooKOR4BCDXE6Br6t1r6L3jaMLqZcG1pEHTYaOFG2mMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/27/26 1:12 AM, Kiryl Shutsemau wrote:
> On Mon, Oct 26, 2026 at 10:40:42AM +0100, David Hildenbrand (Arm) wrote:
>> From: Chris Mason <mason@kernel.org>
>>
>> A shared writable mapping can have dirty PTEs while its shmem folio is
>> still clean. A read fault can install a writable PTE, and a later store
>> sets the PTE's dirty bit without marking the folio dirty.
>>
>> After shmem_undo_range() has handled the boundary folios, a concurrent
>> read fault into a hole below the new EOF can allocate a large folio.
>> For example, on a tmpfs mount with huge=always, the fault's offset must
>> be within the file, but the allocated folio can extend beyond i_size.
>> The final scan then finds this folio and calls
>> truncate_inode_partial_folio() without marking it dirty.
> 
> This is hard to follow. I asked LLM for a diagram. I think it would be
> helpful for the commit message:
> 
> CPU0: ftruncate(fd, 3M)                CPU1: MAP_SHARED, tmpfs huge=always
> ─────────────────────────────────────  ──────────────────────────────────
> i_size = 3M
> shmem_undo_range(3M, -1)
>    first pass: hole, nothing to do
>    boundary folio at 3M: hole, none
>                                         read fault at 2M+x (below EOF)
>                                           PMD folio [2M,4M), crosses EOF
>                                           writable PTE, folio clean
>                                         store to 2M+x
>                                           PTE dirty, folio still clean
>                                         vmsplice(2M+x)
>                                           extra folio reference
>    whole_folios: finds [2M,4M) folio
>    truncate_inode_partial_folio()
>      zero [3M,4M)
>      folio_split()
>        unmap_folio(): extra ref
>          → -EAGAIN, PTE dirty bit
>            never reaches the folio
>      folio clean
>        → truncate_inode_folio(whole)
>          [2M,3M) dropped
>                                         read 2M+x → refault → zeroes

Thanks. The diagram is really helpful.

>> Splitting normally collects the PTE dirty bits when unmapping the
>> folio. An extra reference, for example from vmsplice(), can make it
>> fail before that step. The fallback unmapping on split failure excludes
>> shmem, so the helper still sees a clean folio and drops it, losing data
>> outside the range.
>>
>> Mark large folios dirty before partial truncation in the final scan,
>> as the boundary handling already does. Exclude failed-fallocate
>> rollback, which must discard the folios it added.
>>
>> Fix generated by an LLM and sent by Chris Mason in private.
>>
>> Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Chris Mason <mason@kernel.org>
>> [ david: simplify descriptions, adjust comments ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> The fix itself looks reasonable:
> 
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

