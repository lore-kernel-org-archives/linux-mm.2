Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E84606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RWHqK3S3
Received: by kanga.kvack.org (Postfix)
	id 267BD6B065E; Tue, 27 Oct 2026 05:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F876B065F; Tue, 27 Oct 2026 05:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156036B0664; Tue, 27 Oct 2026 05:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E13266B065E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:53:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70FF18090D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:53:20 +0000 (UTC)
X-FDA: 85367943360.09.6B8C2C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id B965F40006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:53:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RWHqK3S3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qb/Av3iFxq2T/XinHqpaMyorZTBvtSl0sjYD9zEFaGA=;
	b=vhXyHeSozIqSyDCK8OcmioLd7oA+pZuGl0hj1Eobaw0oL9DffsHPRB6bGWPOmGeQzu57Tt
	fTdZc1dj+onXiDpRjuvRyFPv6eE7CRpfJG0kRd/oBZ8yZZ/m/ERBfEzwtQeE2LGEhC3v4x
	13v1YzX+kjB1AIevwOnM4qzOUA2326E=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RWHqK3S3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094798;
	b=qAay+B2//d2kjESODLDzRQKuKo1FACqGThMjP6t8JNzl+xWs/WmREnWZ2vPjYRuT6bT8kO
	yD+5/51e+l8Y6ggSzTLLVUSrw+ybD7FX8aFVcLhkhiJlQGw4U19ZZV13YHUc6eWkGpOmXt
	D61VdvihWirL1QpS6UYwGz+ytXboLaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 477C06020A;
	Tue, 27 Oct 2026 09:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739161F031E3;
	Tue, 27 Oct 2026 09:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793094798;
	bh=Qb/Av3iFxq2T/XinHqpaMyorZTBvtSl0sjYD9zEFaGA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RWHqK3S3qatsdfVyfkwJd+wmD6PBE+gLSXhLcog0Et/IwzOgkm8aYa6gQI9jitp49
	 bYl3JbBm7vyk3NIM1Vati07UdXPc8CkCM/lMNiC3R26e2tV3ZiMiWfrZL+lO6C3MAw
	 9iddEyT16tjnC6r//StpgqZQfQicqQq2qaSHsxv36YsbsEshJsOl+gIHVdn7aF+yTe
	 27DLMb7VBJSNSG0PTk5Qcs2g0LwY3qTQaeJZQeYRZXSggYTtOiPSqrVdSi6p4jtoBQ
	 eITXrRXA7giOLSBJsd3XqFqQeV2aJjDEO4Df9sjqXgi+zFxpQecINrhcroxQQdES+c
	 N2bjhIrEcEGSg==
Message-ID: <ed59aa45-0ce8-4e5b-8a19-b5323fbe7864@kernel.org>
Date: Tue, 27 Oct 2026 10:51:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/16] hugetlbfs: enforce F_SEAL_EXEC in setattr
To: sashiko-reviews@lists.linux.dev, Andrew Morton
 <akpm@linux-foundation.org>, Gregory Price <gourry@gourry.net>,
 Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-5-703206d5fa0c@kernel.org>
 <sashiko-outbox-186003@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <sashiko-outbox-186003@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B965F40006
X-Stat-Signature: peiumr4zcfnse9438n6xsw9te7fcbdra
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793094798-29835
X-HE-Meta: U2FsdGVkX1/8SeCljOkT78kiIMU/D91JDVBQM0ex3KVny5BxFdPne4mhmcl3TkfWvmpUY/o4+f2Du+v9OxKRAhrRGK4iJhn/vgB929uAmmUJrIId28rOE8JEhjSk1aBOkD5jxAzNm5jULUaQ6pLey+b9CQ9lOIRAe2K5+o9Ju/gGj3vqsYp6U1KjVc4IExh+2y778RyIXHZ5uTLw8TQq6w5Txsd+xDPwxsmmx6ih7AB9thGPQ+zPCu4nxLO/E/KvjpMXmGZl4837SwWs3yk9rWVr8ezSgyhVkDOA23BcdOjR/H9F4r03aG8lPa/rbuZmop5vXPzbJSwzuyw0/Jj/NcqsRHimW7VdpUiNNe90hdYPBP3N3lEEqw2GyMR6vgJDeEDNPOFOrYnl0gkSvejChecKo9oMAnieKqTyFHEzPGMtmpVSVHjTeLjg4WUX42QdgvLIKfD8XI4YfQkGJo70K7OLOiqRsxIVtbyObEqp17n4KgFUjkBg4FR0g/75bUivKuaGW16nSs6IJO/8OkyTQ6A1yCnNLh1WDTwuf/bMWw4ik2Vl5eIHp9MNLoqDWcKgKt0ixPA5rTqnAu3HKYQF3Py2BoGyU/sbzhI0Z1PQqLYTD+y+8eQIVzO5yMvuSzsYJe/bH3c437F0TuK3tNyaxE3aqV0aRSU5LbrNbf4YhiIZVCAnruG84TU2lyIYKk6UmqQUmarBlj8VeND3Jt3LTEL67iqHje155wDioJN1mAFqN/jqx1ElLRu5iCUQOM+SPMEDqYcmji1mzY+eMkqXg8v0Ts4QQTVQT3pMes+DtH+wj3ounOilqGbtZfxKOmKhHUOl2udL8NInBS6F+oQiWcVl//OAVpQHvLQIJGT2elXq1/jLG26XWlgH6qP9s30RMHdKEdgiPjewrWT57YriG7EK8ylwZ7r+SbSdTp5au+7TgZIj3bv5BlonkQedSwMZwzGrOUc1NsBPJPkZ0sb
 NHcdpURG
 3/DnbNaUJBcpZ/4xD1jkIWcY45M4knrRSnBhU/+lJ2J8w3WbCY6R21BVcGxONDfz29CFhEsDeXX1UoeQgr3lmkYFtj/Y19mb76ctpCz84YfGO+o9KFNgblgVyqUKZy0Y5dt9s8+vxG65yhyjSg3U/VoW7wbLH0zTNQ5WQeXKIqDEsS+E6ikjJ/HerBMVedYQ/RdwrZL/QRCaPsO/t9XUF8XdocHlI2DA14cls8QqLReLlb6936OT+0TyMsElvuDKXwy+bkm02L5/zvnhLZWL+P2AC5qAPVyajkCsgjwUcH/sLtgP9vC6RRVzwETIoQIji+djw627iJuoLKeIP0q1ExdndX1mDFqhNG/Vi8hNzhhdfwUPFOQMKazsVirQEqH7gekuR8ilt5C/NyvT7ckn1hKbxTm0pYXS3nd8mxOZ4HzLevMexJpaRn82l5aq4dftSf6QUjJ9HVeS9/YjVVMBcvjIWBQMzmUUOPwQnIqdCJPZvpLxLrUOf58AmtAlJlxfYlkcxsfxQhL4nkyfpMJvSYEUBEucreP2/Alu5f6TSOYB9qVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 03:22, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] hugetlbfs: uninitialized info->seals read in hugetlbfs_setattr() on root dir
> --
> 
> commit dfab7a0d71278312f805e82ce52518a8ea2f538d
> Author: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
> 
> hugetlbfs: enforce F_SEAL_EXEC in setattr
> 
> This patch updates hugetlbfs_setattr() to call memfd_check_seals_mode() when
> ATTR_MODE is set so that fchmod() cannot modify execute bits on a hugetlbfs
> memfd sealed with F_SEAL_EXEC.
> 
> Link: https://patch.msgid.link/20260629180247.2343229-1-eva.kurchatova@virtuozzo.com
> 
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index 6656807ce4377..7f5c3962b5d56 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
> 
> [ ... ]
> 
>> @@ -841,6 +842,13 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
>>  	if (error)
>>  		return error;
>>  
>> +	if (ia_valid & ATTR_MODE) {
>> +		error = memfd_check_seals_mode(info->seals, inode->i_mode,
>> +					       attr->ia_mode);
>> +		if (error)
>> +			return error;
>> +	}
> 
> [Severity: Medium]
> Can this read uninitialized or stale slab memory from info->seals when
> chmod() is called on a hugetlbfs root directory?
> 
> hugetlbfs_dir_inode_operations wires .setattr to hugetlbfs_setattr(). Unlike
> hugetlbfs_get_inode(), which sets info->seals = F_SEAL_SEAL,
> hugetlbfs_get_root() allocates the root directory inode via new_inode() ->
> hugetlbfs_alloc_inode() without initializing HUGETLBFS_I(inode)->seals:
> 
> fs/hugetlbfs/inode.c:hugetlbfs_get_root() {
> 	inode = new_inode(sb);
> 	if (inode) {
> 		...
> 		inode->i_op = &hugetlbfs_dir_inode_operations;
> 		inode->i_fop = &simple_dir_operations;
> 		HUGETLBFS_I(inode)->resv_map = NULL;
> 		/* directory inodes start off with i_nlink == 2 (for "." entry) */
> 		inc_nlink(inode);
> 		lockdep_annotate_inode_mutex_key(inode);
> 	}
> 	return inode;
> }
> 
> Because hugetlbfs_inode_cachep uses the init_once() slab constructor, which
> only calls inode_init_once(&ei->vfs_inode), newly allocated or recycled
> hugetlbfs_inode_info objects are not zeroed on allocation.
> 
> Previously, hugetlbfs_setattr() only checked info->seals under ATTR_SIZE,
> which is not reachable on directories. With the new ATTR_MODE check, changing
> any execute/search bit on the mountpoint root directory reads info->seals
> and can fail with -EPERM if the F_SEAL_EXEC bit is set in uninitialized
> memory or left over from a previously freed sealed hugetlb memfd.
> 
> Should hugetlbfs_get_root() also initialize HUGETLBFS_I(inode)->seals =
> F_SEAL_SEAL?

Shouldn't we just skip the check for directories?


diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7f5c3962b5d56..293c7965f4894 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -842,7 +842,7 @@ static int hugetlbfs_setattr(const struct mnt_idmap *idmap,
        if (error)
                return error;

-       if (ia_valid & ATTR_MODE) {
+       if (S_ISREG(inode->i_mode) && (ia_valid & ATTR_MODE)) {
                error = memfd_check_seals_mode(info->seals, inode->i_mode,
                                               attr->ia_mode);
                if (error)

Because sealing of directories does not apply.

Thoughts?

-- 
Cheers,

David

