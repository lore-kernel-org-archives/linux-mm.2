Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0456FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3252B6B0005; Mon, 27 Apr 2026 04:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEF26B0088; Mon, 27 Apr 2026 04:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A4B6B0092; Mon, 27 Apr 2026 04:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F084C6B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:06:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 955151C0951
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:06:20 +0000 (UTC)
X-FDA: 84703603320.07.2BBC0FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id A693EA0002
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:06:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2t8kzqx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777277178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyJnzCbJCaCo0POCR8DUoeOUL/6HRtburuYKoBBv15E=;
	b=01hjlVUI8wwQT6SwlI4GLLcbQKmSeHfMawz8XBbMdvlCeKpS9Akw3lhibore+NYw9GgpW+
	t5QyiNXAGwxov1PUXayNAbMxZ5O/gUSmEYzyjrRR//R0YQSmsCGdth8wzIGgAFBLEX1vrC
	PgEHuJJDvEJGL//ZEl+eDq2IKg6feZg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777277178; a=rsa-sha256;
	cv=none;
	b=eWDpAGZco1hcmfzMwk144C5rzYxpIENR2uUaSpTayf9+jKtP/f68jhr5p3SD4Fy0/T2pjs
	LR/+0RLO4pbYGTSHh6iAj3chPkLpVAEAvu3kFEKT+6FmjxwTieGqgHTx0z2IzCsPjE/kfp
	U/G5GVZMUxkKcQQtRjQ0TP72z0SXAJA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g2t8kzqx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AA5C42B8F;
	Mon, 27 Apr 2026 08:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85CAC19425;
	Mon, 27 Apr 2026 08:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777277177;
	bh=AL1E4Adq2PIOW/A91Vatqt/l1w6K52dJEV/Y71qWN1k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=g2t8kzqx8vmMdRBX237gzVsvhp4YeQG0hyJwqWNhyD+BNaIu2JVhl8NgGt2/VuzEy
	 DYsRObdR2R/37JaVsGF6XFQjkcaJ6kgXM8VDIvx8g87a0uYkR8GTAFbxuP2xgFDaj0
	 TyFJRyuIsZ9bYcr1jLzPfJqMI5hnuQe4xC+1c2wV/ZEIeIgWFwFFeInviigGghXnki
	 +dUR6jU7l9dR3CONroIcNwg6NF7K1oZ1NwvjSDIb1aZSmx32bnSXkgHxlr1yT4aUeq
	 BV+sQ1qlzjf/58IV8br2f3kpBpf+NpO/6iGUicKamkSoA2WjWzq6eLwx9lHmG6RjcT
	 937RrvkSaOT0g==
Message-ID: <4899bbfa-4d6e-41ff-9318-1872a6b91afa@kernel.org>
Date: Mon, 27 Apr 2026 10:06:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-4-ziy@nvidia.com>
 <74D4C50B-CB20-45B3-8E7E-E9A499701F61@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <74D4C50B-CB20-45B3-8E7E-E9A499701F61@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A693EA0002
X-Stat-Signature: 971sm9jazzss4janigdyiqy8dt9yc7ij
X-Rspam-User: 
X-HE-Tag: 1777277178-453878
X-HE-Meta: U2FsdGVkX1/alLT5VeX8ydTJAbg1pWAuREXzuxbczGPZd2Moisg8iRY+38i97WEUAhnjbJ8D2pJtFJwmJfukjJyHONUUUGoBIPdxT5sOgZIIeEecctiI9yoym+vlceUWxkOLwYz+GOuGQA3ixM2rFs5XxkW8mafUUtUgpXt1oCD1ZUFYj5qFh3JS/b3eW6EYeSqAlxDL0mYsaHLepiJBIn95gkdqT7zoHWRU5yOyyRhnfb5LWsHcD5ybb7mdHmqnW5yNOkvXRT7aen/26tDsMB0igUQCN8/dviRfRXz42j5niEd2xApbX+GKGh66J5vdAtMQ7oTfzNbQJy80/4gslcGoZuNiMUb183OvHV66VRCnBpTtix9DgB3MM1G1dp1N9k8X39Yw1TtX8pmYvVceL2C7+qrkKCDcRVOB73A6vJgK5kqXxoRWI7qoJ+V2NV21SmqjQMmyAGFdfRey09g5F3KL9pPCTY1ZZB7rkkwkliY/pAODtMbDC5Ho3wb3Mo/VXfaNY3joBp3DLfrAWoj52rAVppsLOK/DtDu3x347LAG6SI2cVXUa1PNKiDmVXPyFm1RcDUBVTzlCwyL57ceczxtFSZF77FsPl6hyye5nT00X25DFigyt3SPl0VByGp3MYTd+aur6+q/W8w3ijQ7rzby5kEbIJoORjcdAu2ix/XoBD4mZkUxGWVNz9d4rdTsiy+hIxDpcl+2JcOj3id0Bt8COJBqOljprAcm95yboVsxgsQSzLUfqsOssbmBUs9ny7jdOyx+z59Ooslajs9HqmWmtYhOCHUDMYny2QvoLFOlLXCZcBkM/v1dta6DF+VrNOv4cS7IEciPKEsOGy6Ne0OEQYvw63x9fBuoiz7xcpW4+cOXReYT/FTqWqhWYpYZ9WyjdNmi5qVG9Bh75GmJbQtG1b/EkaBuX6X7aKyWJq7sGN86Zb54dBpZrzChOZ5KMYXTaVMlm5UFBGv8jyC2
 vffmBxng
 2y/aDYntHwSAnfSmRi+PNE+eI1lpI1gO9FmR4c0HvRXCHgVXf8S5BZxzKEBf+hB2BpAgGDISxk/JvTU3TePI6TKePKL//BxIUC7JCGoLSiYJgRnlVc1qiiqHRWVArTs1mxMXAPDei6p8utLZXjeQmdTrSV0t99p2+I3MF2gdxFT5S1Qt1QolN1W/XxYovnombKn8JkklUaBK/8F7lH42e1T6CYi6U9NhprOhg5PBngqMTdSyjUi3I3f5Ey7aXNT/23amukxKJAkXIQ+IoFNAOE1cwqizAAatLtbNS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/25/26 14:00, Zi Yan wrote:
> On 17 Apr 2026, at 22:44, Zi Yan wrote:
> 
>> Replace it with a check on the max folio order of the file's address space
>> mapping, making sure PMD THP is supported. Also remove the read-only fd
>> check, since collapse_file() now makes sure all to-be-collapsed folios are
>> clean and the created PMD file THP can be handled by FSes properly.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/huge_memory.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 970e077019b7..7e9cf8c0985f 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  {
>>  	struct inode *inode;
>>
>> -	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
>> -		return false;
>> -
>>  	if (!vma->vm_file)
>>  		return false;
>>
>> @@ -97,7 +94,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
>>  	if (IS_ANON_FILE(inode))
>>  		return false;
>>
>> -	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
> 
> Hi Matthew, David, and Lorenzo,
> 
> After some discussions on irc, I feel that we probably should not allow
> read-write fd for PMD THP collapse at the moment. Combining with the
> filemap_flush() under folio_dirty() check from collapse_file(), khugepaged
> would become a kwritebackd that scans pagecache folios and writes them back.
> If we limit it to read-only fds, at least khugepaged would only write
> back once for the pagecache folios from these fds.

Makes sense. The comment above the filemap_flush() is valuable :)

> 
> I am planning to restore inode_is_open_for_write() check in the next version.
> Let me know your thoughts.

That would be better. Do we plan on handling races with concurrent writable-opening?

Or could we simply gate the filemap_flush() by a inode_is_open_for_write(), to
not have it turn into a kwritebackd()?

-- 
Cheers,

David

