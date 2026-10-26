Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB81F606A327
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=shutemov.name header.i=@shutemov.name header.a=rsa-sha256 header.s=fm1 header.b=V7jA5GL8;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=Z8TGrGcn
Received: by kanga.kvack.org (Postfix)
	id C030F6B05B4; Mon, 26 Oct 2026 11:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABD76B05B6; Mon, 26 Oct 2026 11:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9AD26B05B7; Mon, 26 Oct 2026 11:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 766296B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:44:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C48FA059F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:44:25 +0000 (UTC)
X-FDA: 85365199290.16.CE7DEE7
Received: from flow-a3-smtp.messagingengine.com (flow-a3-smtp.messagingengine.com [103.168.172.138])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDC4740008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:44:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V 7jA5GL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z8TGrGcn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793029463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsBzCvBBi1qFDcBWHy9H79d/yhN28jLEiEbY1lNFkTQ=;
	b=VPTqeQ3UoTzpGFQ5GSYagv0nCAOX6XmDO9gKeLb/KLWXqf5hYaxh48SXhvQob0+yrDrSzj
	CnpW5aF7K9/ehagmRg7OqjSCLkzXLWbSZ/0DSUg+TQI5vh2gdlUm0chMTV5YSkVa6R0rHN
	hmexqdPzteoOIFqwsjPvq2oTHOzq9JY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="V 7jA5GL";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Z8TGrGcn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.138 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793029463;
	b=UyKqlqDM7pbypMWp5mWxMW3adRfCOtCvUKdfNKpHcXtRebD3Dln+WbuoMBCdYfuzrFX13E
	eabGtz8m55b4wyCRAudf7RMlctZ50XNE3mN2IcpzXDCEDN6a12Q9W7kyZjZ2KSLY0jv4TV
	u1iTMj8G8TpynriA/O+UNYXSTI2x/lk=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailflow.phl.internal (Postfix) with ESMTP id 435B41380288
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:44:22 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 26 Oct 2026 11:44:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1793029462; x=
	1793036662; bh=MsBzCvBBi1qFDcBWHy9H79d/yhN28jLEiEbY1lNFkTQ=; b=V
	7jA5GL8gC9YVR4ijRaAinUcl+AZfdJTziwrn0WOtfO1ft0A1UQagGKf3u8bQ5Pnv
	+aBMqH/UJzEdd0YTPBG6bD0Jc4H0uP5rCnv970Lsg+Ur1abpFK1Fh/uzWW4CYiWg
	QrSMvWEkKkqxRkH0SoPxOyHFL3i1cZgZ/+6gCvsOAJG+GfdxQxx7nxaWJEeTAHRL
	DPF93ri5kB1iD2ndgo5/UWH4xyN7p5dunh3Atjz3zZ/7jElvN6M9NoTOdInxtL1G
	L0IKYvEtwQVjJD/O88fe+aXL/U2U1dW5qA4W7PYqRbLy03xsgfTH56JLeoLFHsPU
	Gn3Lj0kZB7Twc9EOtx6UQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1793029462; x=1793036662; bh=MsBzCvBBi1qFDcBWHy9H79d/yhN28jLEiEb
	Y1lNFkTQ=; b=Z8TGrGcnmqMmQObZXRtGFSxzZEuOQX8GssEByugATGxet8PT6Xe
	Rj0ymMJhUfNlHxINVs9+A9FnBy+BE4FPaNYvYa1AIF/t4haBwCZVkDNb3MYTyo3L
	fpDTCSuse1JfKpQBSCzpK5GVIKObchSV/M+glfsvpOSv4KA0eVWl4o6KRZIUz2lY
	jg8vXwQIGAx0EGfS6jacFQfQ6pOHB5KRMPMyScF/+IMXCYdbLeMC0+KlrcN7BnNu
	+XDxwpMoOd62/fq4M/DNoyoxy0JUmLdkMnRUjH1z6UI+UJXL2W/uE32lkSXqZPm3
	pojz6ngWgGF6GnBbv8MrdkV6PTcsbjgq+DQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1793029462; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm1:rsa-sha256:M35YA9H1ydXmBHd1w4GGSzWdQDQJsG9OCSPE8uHOHb/TaTA
	pwUSZXlYFIL/NjiiDXf2TQ/ExbRyhn2jgXcG5DY+gUPVbtqvXApUZsA7mygrX0GJ
	Y951xFIiOKwqyzDfuhzLKBVn9Ko3T4D+s9+rvZv05ylhRKIwx1MSR5yH1NKc3aOC
	aAF5uKly6d9x7pibT0UrixDDzsWUvaTRFgBMpiGP8GMh5eomgYMTM4McEJzZpvSb
	zrRA/3wpadIyLlwXwu5HXIKBgoYysTitdJfp14eD73LkwTvWX+BnuvKlm0C86i1B
	CkxvKyqlRUcm9z0BPIRleEYDQkP++UV0i410N4g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:XotbD7fpvAzzCGWJuVhuktAumN+rvaA9s3fiyUfgY6c=:XqKWWhJxA+x9auqNjWAMnDG+H0yfN8OP2NNOlTPpJU8=;
X-ME-Sender: <xms:U3XfaqfcFJS0ZSBxJN2FgyWyDG7MpcXSZ-rYZBadLQNCLAQ_LXgiqg>
    <xme:U3XfamDL34hubBKFuP9_R_0CsYhct1O6wftrt4GTHjfbdNpAUP8vDlj9Gc50LZBGZ
    GVzPkg2jhVxpKrXL9_Rn2khpzmCql6PEsYL3NMNYIjlyL_wj0uPeKs>
X-ME-Received: <xmr:U3Xfaqr1hivuVR2k_d94m95f8QiHnS6SpoigYzePW9IuXgmma9fZVDVJ3fk>
X-ME-Proxy-Cause: dmFkZTFJ8xjKxkODpSRRf7sUfgHfvt8g6PK2A2CrYeOjgirOm7AGaGD409wBNtw8s2ifQN
    6SNZlN6LHupXBZ7ClSTK+Va3BkAQr266ey67CD+ar2qxSF2IkJuTlQkn2siFRjQh4V7YzE
    RvxeuwfChl3oCpci/8krcX+3fg0RpcmlMUWMTWOL4+GOdTK9SD0e1JIbIWu3SAVX3c+cY5
    CJ4+UQY1jew0wuKOivp7/2GWJwqBUI8j0Ol5fvjPRXkVAl5K9NqBFefrOGaE85oyEYr8ls
    1J9kXundrAU2oj8ls/7OIxgbvr2IaC/qngmwAMw1u+t8SyL7jWthmDAGSMFWDIjux3Ebqp
    NVW58DNZcRuPP4M5p1NuFhTCINz/krI2McfXo/RIP1JlNyTFRDiWCkiQ87EG3wCil9LxSt
    DY2Z+HjW28ACzgXrfS/HPdvMd09KAALKTKvNtqu3L3ZnMhLDWQtOD7u36KnM5NVK8iQ/zw
    o0FwWC5xllWhu2zJdourhf03u4iFjRga12NdJ9VYm1c4ffKSMkHeNF8JKTnYPYXgGcZ91x
    RVGz29s6mkkOkHj2qjbFAV1Aev4EnO0bUyGQO0FtdxK0+Ppk+sFUmTsn6MTB+xkguOlDCA
    KAPRQQZ9+Zlaq4HeYxlSOsUT3aq01sQIGqOekcVMbDNRirLoW8QmsIkUitJA
X-ME-Proxy: <xmx:U3XfarTevoH8emebj-6ycB_YK6mvmGyfe8R601CeJwb0j6FC2VbEAA>
    <xmx:U3XfajdchqI6AUO5UIiwUvdYKt9jUgZeWb_mDiQWe7PyYqSm7ay1Jw>
    <xmx:U3XfalQCcYBMaW9CexLvdEboJGuEHWIAHeGEKYGm3FmvpM6afKbSTg>
    <xmx:U3XfapPE5WhN66cKsLgIhJhLYMfIJEIrAw_hJc8JqNqHcGJcft_ErA>
    <xmx:VnXfauoHkdDQBJTFO5-RfGEb6OoR3poF7CFMC1MEudXeqaXg8DERCDaK>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 11:44:18 -0400 (EDT)
Date: Mon, 26 Oct 2026 15:44:17 +0000
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 01/16] mm/mempolicy: charge shared policy nodes
Message-ID: <at90mp4ffsuas-pR@thinkstation>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-1-703206d5fa0c@kernel.org>
X-Rspamd-Queue-Id: DDC4740008
X-Rspam-User: 
X-Stat-Signature: 89iyg4x9ri19q4agwzhrnkbhdu574qy3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793029462-76819
X-HE-Meta: U2FsdGVkX18BQ8VEb0V4bmjtJXT8D4HRrBsLEWC0jNvR/F8wROZr9jQhEKkPB92BzGa/Cx5Sx9qyWKjHPQ2wFbiPnvZuxBkRbRuHhOPP5j5zG9JJ2Hp66OTOokO+EfenEvb1KjOWniJJgghdFDu1xh+onDGScm2ZdFDQJSS7WRx7ww5gDnvyfrZnxAjR74D2QuFuIoSm2pUwUGGgnAUDsXskcCLKP/o9P565b+luFUjGze5prGK2b6V4mpktSxGTei2rP+ac7P73LGSfWt/yqMN5NdMpiq/uAbh+25OdhiOep10KPRH0UOD34bDcamnYuwwVVo43ariyXyO6MXFQ0JnCo+h7CLf8mGucWN/XLAWQzOoa8aM94ws4I8Zg2zFWntsRKHMLlPm90dXrE+Rtzg/LA3u4NDPPJxTyh8p+qll6lyuBsIVsWVfb2uFUMgNm04ljPyJOztKQZb2TrH4uA5kPF0SsaUMrlFehMFG0g07bhkaK2TSY9grPu88lbywoFic84bo/7GhV0NB0IS7TVGPG/PZCTx1EaqBMY531jlDzPDMAA+H71LmMV4C36GuKGUnEh9U9z6Jhe/bsmA8VvFJR3gcabogeSLhpOFUi1nCKSh9nFWUK9I7Eyw3D0wOpTSG9XjjWU0f10R0lpr383NYfr2S0Ph2Yb4ckECljOzHSuS3muD12UHiqkNQP7xXN2Nz/ZwO3rqAg9xYIF1ZXhiwJ5lpjBbetA5H54JZqkeXUuFnc7cZdy+9OQYM1P6Jh+utnt5l9unTI4FmJtEk1BJTRKUkpsXqobA7xiyL4vDVVz4TX/cTfJap69DM8J8zn8oyHVUJlRT3jJbJyH9Yw2Nxb6dWBn5AQ8ezpKDDDgvinJJjqQQWwTtG90CbqK3csZslt5QnVTveihMSlmWAnA9XVg2NtBdBYks0xt5QzFu1r7WiyE3RtAIiNjJ65ccgA6DcKkPtPhjexUb6Bxbo
 PaXuma0O
 hGZnwyOANnAc1NEZPwj08nYbojneg/jhf0Zk+8DZEcnzFOMKj+F20ukncQuMqf1ltExvWlzSauN5yV8wQ2+dFPunJvKhWyRFyaCbnpPDWpSktYMJ6z7htrr70OR3iy5Ub7ZYugMX/vsi10PBMMm78jc0XDdBrqoA0nEKe7LiZBNdaSNMv9rpjT4q0VF+Yd7KpB2mEgRIfo2AIuA2KLARaqBcIFIV3+e6CwcmP4JnBO3xhFnbg+xVLRJeDxl3SG3TSPkOmnij43CfAonXFvk56866bObGE3r90erEdGUvWfuiMn17PjHnHY1UfyEnBKPF+6KC3o8SgiMyfyrx+OUAOK6sJUfQEDVx7yZ0G66De9PEXnagFgLxBN4u1vFOmrQfhctI7F+Iv3afQszcRy6VNF+f3Uxkc8LJuiY5mIWvtYMiwQJ7xmddyoR43AR4XchyFY2i0vzLVo/UAiJWMr16pJGmMxcPUvZYttkqI2RlYLfg3H4UbLId7Z7ABHn+oBqKHvvEgr9jAfJ/9UJomLRpm0ABkE96wuv/SN0LtuTUgw+9KC4czdxp2B3miWPNbI10h3uMH8+CVnkQFFHBTDbHQ49j51hogBRXREss4jSRDg00zhwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:34AM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Any local user can bypass memory.max with mbind() on a tmpfs file, and
> allocate unbounded kernel memory.
> 
> mbind() sets a NUMA memory policy for a range of a mapping. If the
> mapping is of a shmem and friends, the kernel also stores the policy on
> the inode, in a tree with one entry per range of the file.
> 
> Each mbind() on a single page of a mapping can add one shared policy node
> (struct sp_node) and one struct mempolicy to that tree. They outlive the
> mapping and stay around until the inode is destroyed. The tree is not
> bounded by the file size, so the file can be empty.
> 
> Memory that user space can allocate must be charged to a memory cgroup. A
> slab cache does that for all of its objects if it is created with
> SLAB_ACCOUNT. numa_policy_init() creates the slab caches for both
> structs without SLAB_ACCOUNT, so they are not charged to any cgroup.
> 
> Reproduced with mbind() on single pages of an empty tmpfs file, from a
> cgroup with memory.max=8M: the global OOM killer killed tasks owned by
> root, and the machine panicked.
> 
> Fix this by creating both caches with SLAB_ACCOUNT. This change implies
> that mbind() can now fail when running into memcg limits. Further,
> the policy_cache also serves task and VMA policies, so they are
> similarly accounted now.
> 
> Note that per-file limits are not really helpful, as the user could
> simply use many files; having limits per user is tricky as well.
> 
> Fix generated by an LLM and submitted by Chris Mason in private.
> 
> Fixes: 5d097056c9a0 ("kmemcg: account certain kmem allocations to memcg")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: smaller description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

