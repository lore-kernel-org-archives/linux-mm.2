Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE19B606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PEVXg1NA
Received: by kanga.kvack.org (Postfix)
	id F190B6B05B1; Wed, 18 Nov 2026 10:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7F46B05B3; Wed, 18 Nov 2026 10:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6AED6B05C3; Wed, 18 Nov 2026 10:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8AE66B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:32:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06B251207AF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:32:13 +0000 (UTC)
X-FDA: 85448630946.05.777FB07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2859D1C0012
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:32:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEVXg1NA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzhI44GUXY0kG5+XemeJo+l/ioZCGN//mKUp3IL0c+M=;
	b=xXiwtf/lB6nJwB3BkHuQU8AmE0dINlADKxNQS44whmGaaMA0/HOzHUZK4aklgf4GGgb55x
	TtR7MDSSbozsA/bpcWz9xDFHBK/sJK/+1v7zjvDYuDNgS1I3mGXR5h93VYeal+bk7gDpii
	sIuBmRk+jGebXscgvNzrrbmePDXZM+s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEVXg1NA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015931;
	b=r31F7GCIXzFH9bVYQzd8k/GtjAtJlOtjt4f3IpBqNEISuAcrBwwvXlzJuP8Q1BEiuOsMVi
	SsolOdfBErgIdqV8/23AP966ht5DRx7K7VekB6Q+CzK5J78JdGVa1GiQQrDQ9us7qS6+4L
	MuX7xyWWMKnyX6+V70TYWFyrubUT31o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 459B046137;
	Wed, 18 Nov 2026 15:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F56C1F000C5;
	Wed, 18 Nov 2026 15:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015930;
	bh=AzhI44GUXY0kG5+XemeJo+l/ioZCGN//mKUp3IL0c+M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PEVXg1NAl8AaS4XRZvjTZEyQR99R6RzFKI+94RBwwdZuSzRxiVBl7OYuOoU5oDE9P
	 lnw7yHbCisMbC65Bg+9HaVme93wOy6D9s0V6PBwZ/fTvzTqi9cRjy/QQKrF92vOENa
	 WtePMA/g07fIOBOD4QQkL3pSxK5bnQuoM171u/cuwG4Y/1i7LVoWUNNKpPMFpZA/hT
	 LFERVHuEDLjqalMUr5cN+Q7C3SCzuy8mjlRX2WQBBGJHtvn1EKJkxDtge7T2hGGYyb
	 Be7EvRH6dkgU90LiFEtkKvBqQDBamU3JNJYq8iuZNlRpoO7YiLISrUP/Z2ZmT7SP6c
	 FMxrqfGQM+SBw==
Message-ID: <5650b972-700d-44d0-87b4-029f0327eacb@kernel.org>
Date: Wed, 18 Nov 2026 16:31:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/13] mm/migrate_device: look up fault folio after a
 split
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-7-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-7-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2859D1C0012
X-Stat-Signature: zjj4kmrqzwca7nngum3u61efmb6jopx7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795015930-318419
X-HE-Meta: U2FsdGVkX1+gYOq81diiw/6PKxufV8mooGvkfQkSVNML2C0SzIWCB4UZCcCvjqwR+pmrU40soFIEuH46GJklBEZwLaPX/NN1CnrE3tZ3jJoB79Gp1VBvxBtP8be8CM/amTyMdD1xOoHkJcEZkl4YH1jweqYx38gTQelVJyWNXNDFBFjUP6pgFLue3zHjxlF3r9isHeZl3mMWybb5ypYIn7gp5pfxzI1kUVsSYvETswC+j9j1qS5sq1CGwc9U8VIm1xL4zujVU+088uTUeh1vKzmwKoyJvWm0twGyI35fzRhkE4NaweNzRc263k8gAPTLdlfYQ0jxllqf+QtvlM1QvCM3x2FoEqosvzaq/Ntt2BdPU3YNATIQingxsJecapxFPWx2Pe3B0au5bfBfBVk6IpQ59dRplJ9rsSdOb9iAPGsDAGk10HPnlXuw/GdVWgniP+HcvWiWqYtkNcynVEgPrV5C3JnkpoXU3roMWn3lYz3hyvM6y4AmRJSJBMcVLh6TpGeQnRmY17fVI9rKOlC+/XabjeOn33b7OvkVsES9QVjYXQ1wx54VZ8o1jXRVEO8uPquTiPS6HYoiQkZyd6477fy5bS8MJCArZ7JlM3zQyWe+CAgb3XvbSx3UTzJcx2ju4CZy9/zT8PHMmzZmXKfb/lRLimOkDymz09U+rq7vFVX128s2vVgdxNL7NPWEAG3GWuejEEnVJiiR7N0Bjj5lw/Gvbz6CSkJ7yovzhFwqJzathtb6ssfO/PByRrj4WJmKEWq/qyGP0eSCCCakxL+BPb2Knm+dSeLMvdQ7hVgmWkXkj74slO5bKmxK/Xcdb0jvKI4oxuYZMt9nqUVDcgrZNEiNh8BCmvK24deTbW5VbkheQLAFHsaRZYqBEw7j7GFMSj0uvwMDCu+Luc1TN3GTI043XZlgrhYaHC5/BehjrX525fcNuJvBIDaKiD176dC1uACj0ptx4rkGI+ZaOrJ
 +TNgBQOl
 THm43rMbm4ApfzFolNb38jKnW8WJJS4DVdaIOMt+ugZ35km6I78UcujS6aGzzn7VFz2Qe8srSB+l3Ri9jWmYP434tZqNpVrluPgfJF0PzOVt36GMGfgJzFNgJsCek+jLk5TYuTfsT/pTndrpXE6xsKflmjgIsBSN8i2TvwFeKnO1M0KBF3eZ9U3HmEmwcr+n0QQbKKgQu5MKW543s9IbD94aWJoxkuI+EsWhkeuZdrJWfrThBEXeBS7VAHZNC4CwuLH4hVESjBsrqc57jxuYDp2d7nG82FCQBHElyBPU3r4RH/ehiq98A7s+OY2zNZK0/2vTnXafK5Q4RD9WhY66CwKkxDHS8A/em91Df+HVazl8CnlnANGq6GLwfLf1AZQCPcOENE39rRX85+GhistcJhBXYsNRh1LdDPADVcZp3kzcjAfDPgfaos2ZPtfM0NchiHUCQX79rSEVpx170yfbTmhvemmLTCyWTOVr9qT464rh86L8vbytyTgN0xKJEhHLMjW1fezHm87t8/E8glNwbQ4FpH7oiMWWG4tfsgoIfDoYaEos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> migrate_vma_collect_pmd() looks up the folio of migrate->fault_page once,
> when it is entered, at which point the folio is locked.
> 
> The fault folio is assumed not to change after this, however if
> migrate_vma_split_folio() splits a PTE-mapped large folio which contains
> the fault page, the fault page ends up in a different folio.
> 
> Resolve the issue by looking up fault_folio again after each restart of the
> walk.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: pared down commit message ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

