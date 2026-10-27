Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 557E0606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RYN2vzKs
Received: by kanga.kvack.org (Postfix)
	id 425546B05E8; Tue, 27 Oct 2026 13:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5916B0869; Tue, 27 Oct 2026 13:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0786B086B; Tue, 27 Oct 2026 13:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 04E876B05E8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:34:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DAD5C09D7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:34:27 +0000 (UTC)
X-FDA: 85369105374.12.9D3994E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 00C2B40008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:34:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYN2vzKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COdQsqilLLQbumWXSPatN4LDhJMWTfOp2W8kqhDBWxs=;
	b=X678QAi5bcXRoN6lE8TjyZ9s7CPm4s9bN5LUS1kNUu3Ii/nUimbjrlQu1r66fjnfwdiEFx
	jE3+TyZRlmmV0yHU5eC0b3j583Q28lNoKchcWkkPH4ULOn9CSCVNOTwop8VIfqvHjLN/FB
	SqsxgD9agjpRZnpH6OrxJbflHLW/0OI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RYN2vzKs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793122466;
	b=6+Mms9LQGcY0+9EQsw0ft5jjxvSoEN79dV6GEBdf65/HQmpQHPGDWc0Xhy3IM7Fh0KMcLB
	4IiIuonfch6ySL0dWqWifFeVOsmgYvPa2V2gUDsV5gxX1/EVh5jtDlc35qEO5BQRsGluRS
	inXXRHK628Hk/c5sKdElJ573GfpJt4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 74AB360142;
	Tue, 27 Oct 2026 17:34:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30B81F01825;
	Tue, 27 Oct 2026 17:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793122465;
	bh=COdQsqilLLQbumWXSPatN4LDhJMWTfOp2W8kqhDBWxs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=RYN2vzKs4ZkzsggRNOd5345Y9RmP5xJuwIVm9w6r5x3FAJg1HBumtJ7kzq7Zk2Byv
	 NJLY3MTki5J/jgMKffKX0MJUDmrh7Mj9/0LUeDWRGFT9PKDun2MDUk4bswpvOBod5/
	 bNYMieVVAxa9BIH2qgUZj85frA0Pfn970M2GP/0jc91EGPQZNOIAGmiPNiger8wclo
	 ufyI4lp/osGtIkHDTUYogUM4fs20J692aYPNRbVq5x2xvqh4gPgqRcUB13BB9b5qSK
	 oNjI1xXwG20lYigNS/pYDFW4KUWITLyuatPQ7hVvva5pYJEnM36h88Ce4pzq4aw8J6
	 m+957JU9t5eOA==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Gregory Price
 <gourry@gourry.net>,  Zi Yan <ziy@nvidia.com>,  Joshua Hahn
 <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,  Ying Huang
 <ying.huang@linux.alibaba.com>,  Johannes Weiner <hannes@cmpxchg.org>,
  Vladimir Davydov <vdavydov.dev@gmail.com>,  Michal Hocko
 <mhocko@suse.com>,  Hugh Dickins <hughd@google.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Lukas Czerner <lczerner@redhat.com>,
  Carlos Maiolino <cmaiolino@redhat.com>,  Christian Brauner
 <brauner@kernel.org>,  Jan Kara <jack@suse.cz>,  Daniel Verkamp
 <dverkamp@chromium.org>,  Jeff Xu <jeffxu@google.com>,  Muchun Song
 <muchun.song@linux.dev>,  Oscar Salvador <osalvador@suse.de>,  David
 Stevens <stevensd@chromium.org>,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  William Kucharski <william.kucharski@oracle.com>,
  Chris Li <chrisl@kernel.org>,  Kairui Song <kasong@tencent.com>,  Nhat
 Pham <nphamcs@gmail.com>,  Miaohe Lin <linmiaohe@huawei.com>,  Naoya
 Horiguchi <nao.horiguchi@gmail.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Chris Mason <mason@kernel.org>,
  stable@vger.kernel.org,  Pedro Falcato <pfalcato@suse.de>,  "Kiryl
 Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v2 04/14] mm/shmem: honour F_SEAL_EXEC when an ACL is set
In-Reply-To: <20261027-fixes_shmem-v2-4-86a00952acb9@kernel.org> (David
	Hildenbrand's message of "Tue, 27 Oct 2026 14:03:09 +0100")
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
	<20261027-fixes_shmem-v2-4-86a00952acb9@kernel.org>
Date: Tue, 27 Oct 2026 18:34:18 +0100
Message-ID: <2vxz7bj3oxnp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 00C2B40008
X-Rspam-User: 
X-Stat-Signature: deh5rrsoqiixnxq75w571desossmimka
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793122465-519695
X-HE-Meta: U2FsdGVkX1/iy68o/8N/2FdaJYJn932Bs2a+1TMZfqOJ82gCZAT6ozXb5GFOFPrHFxAyQhD+z96hzTH9NbSTHw8zHAvTw8qCJuCvsSY8Wyk2rCpRNVKALgUhVcGS7y8dVX/fvei86rElqF/c7fHa1HgCFkzQSzianiiafoO7mIN/2PkipsAKc3djIP0okGMZ9Aq2sF3etjHfWPgzAf0JiXuH9flyPagNVjIii6UGl/T126B6ujbOZEqzNDAuOshQya5o+/lbze89Azjzqa750/l6AthPM8n+nTKHpD9OXk8pCSEu8Au601E+/0yHJpdrKAZrq6iRamJgp3zAS5iRJgvjNDpPCVj8YWLPd515IavUjVcWJzgoUyk5Q0OILd4VFBeR+stZNRonqW9c/6YqU3CinY2OdjfGoo1+ZmybPwssDAT1/sIIh2Kp/p+jV7NkNCGyMpNfIfQDH8/BEOiyQqvLLbWbJphdZh6R8EQNrv8c+Sl1oJl2/Sq1ixrSyvHqlxDYsTTuwHi2MfyD+7Y/bbDf2Vj3Po7fEb6VeR7BiFBdoD696kftpFiuOyk87Ingzp9DNZD2ODDn1SgSG1yPpR3kV2vMoC5kfgJqQhIPpfmko84L4U4boo4FTn0sDj0f+mIDhONbCqV8dPopY/Ac0u1YUkdhtq9eMLfnvexiOFUzzhAs9SQL2dNQEcf83oBBZHqQofWjV9BWGiYtGHLZoKnUSOKKjU8sJBZSjf0Ypy8htJ3Yp1I1S2DvDOe41AGlrlYJAe99HgyYlecR1H/b+mfMLDpEziIKIcrS2q4bHNLifk4oAo4UgBVFQEzE9xCo9Dmwbmsl6c5Bs4SfSrofKqujRzPNe+nLxnqLd1ojCxYreaUUqlq20mtJYB5J8nQia+v/MlBGAYLLoiKYlM+J9inaQXFexMugoi5+iBd6hU8W0yOTNx9mbQ/A9rNS5EQTNudvT+saPLa8Ic6kqpe
 XEUAU88t
 KvLHGth6Y8o0DxRmFDeLoLOoW40OyRVnyzv7JlvvNvPnGNQ34NvzdWjXofaZ0Tks6mt4Ky1iI7cwdgdsIoB6btaUGibppVSsMXQQbzJszPB7Kv1Ptn1K9Bf8FUTFf2Wbj+jbQRBdsNp6HLIbHXoQDTm96IIKE4MhTHKGBl5sJ5Bpd/59r7rupWeqYOQjZp7gUW0szdP97YJV/UlCj+G1hEFInpwlGdmNZwNsfiFIJ/4ljWBcAsVAXpPzbj5Gyzn2m8nn/esZ1AawzX+CJdaIp5GrN3/y2KiJRPsRZy53RR6qWAtFQ46Pvw05EDQegd8gmPEdn3L+j0F/43Q8+WXwyaN3o3VZDS99zCWP1jyfyQOgghJfS1xdw/XiuJr7KApnDt/MR6BLWb0W3I7F5RIsWJI9ts9iqE7/Zh0M9M6Ejljh79Zztihn3Ug+m2aaZTuEVIy645xhgQBEbeaP94RF7h09Y5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:

> From: Chris Mason <mason@kernel.org>
>
> The owner of a memfd sealed with F_SEAL_EXEC can still change its
> execute bits by setting a POSIX access ACL. With CONFIG_TMPFS_POSIX_ACL,
> this lets an unprivileged owner make a non-executable memfd executable,
> bypassing vm.memfd_noexec=2.
>
> simple_set_acl() updates i_mode directly, bypassing the seal check in
> shmem_setattr(). Add shmem_set_acl() to check the resulting mode. Share
> the F_SEAL_EXEC check with shmem_setattr() using memfd_check_seals_mode()
> in include/linux/memfd.h.
>
> Fix generated by an LLM and sent by Chris Mason in private.
>
> Fixes: 6fd7353829ca ("mm/memfd: add F_SEAL_EXEC")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> [ david: use common helper; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

