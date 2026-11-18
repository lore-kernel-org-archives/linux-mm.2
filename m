Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BF9606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rb/GMiZm
Received: by kanga.kvack.org (Postfix)
	id E07216B05C4; Wed, 18 Nov 2026 10:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D90FE6B05C5; Wed, 18 Nov 2026 10:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C583B6B05C6; Wed, 18 Nov 2026 10:33:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 956A06B05C4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:33:00 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32E0D1607CE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:33:00 +0000 (UTC)
X-FDA: 85448632920.05.1A5F654
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5CD8080010
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:32:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rb/GMiZm";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015978;
	b=cp89Fz2qJLnSxs0A8qSxDRuDtBNt0Z2Hmlg25tAIh5e4ggMKbMDaxgN4CiKjkzUzLjFEpZ
	cOWAflzr8DcUydLuMGp+63CM/fs8u8IYprZ06YtORBHF65yRIJzVo7Ngux84b/dhTMXHNN
	MmbU6aRwRUKRINAJZZO/1ND1gP6s/Jg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Rb/GMiZm";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+MpmiAPVSNOMODlIUH/rRrCpeyRccmS8EYDCXlOBkiQ=;
	b=xaTlYMzyVHp6OmqZopsVMGiQUW85icrRiPFF1fheRxELyBRtLEy7P6JQtZqjy1IGo00DYa
	LD418oTR/UL44Ju+YVDLLcvQ1jmYPYboakG/r0puJUCVI0tgflYomdpoqfSsWTIFbRWEWy
	atafY4ARpX2pZu2xh8BSKDe+5ytFdHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B1C2F46280;
	Wed, 18 Nov 2026 15:32:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF561F000C6;
	Wed, 18 Nov 2026 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015977;
	bh=+MpmiAPVSNOMODlIUH/rRrCpeyRccmS8EYDCXlOBkiQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rb/GMiZmoH/oEZ/prkmXhUbm3LTPbJjPeQ8WwHnjUdihoSviBg5H6PKTc/6g4K0qg
	 lNQC6QsgvBDvMU6XeKzROa7Rcgqqi/tM5ZkvSz/FDMs67gpXpiTC4Ic81U6NuPoOzp
	 RXKLdMAp8OaF+1LBKf89eruO9Am/L8+OMNH8ehMggTnskwjuoObp26Ge4FsyyIJHav
	 siAOOZr4tVg1njfZTl0HhyzUb1o4d1S7/McqJiYVokydNtiiuaAhWIaW0h0VbiccJu
	 VUv8D1b+GgV9WX2VVYw0C7VbmW1pIaSiFjvjhW+wetXes3LhDKHalzMulVk3femeDE
	 LttntKJaUpTVw==
Message-ID: <d1fe5a36-e6e0-4109-bf70-5582278ad653@kernel.org>
Date: Wed, 18 Nov 2026 16:32:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/13] mm/migrate_device: fix ksmd oops on a migrated
 KSM page
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
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-8-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-8-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e6s7s7neidqct93ptfu7joafxbn36bew
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CD8080010
X-HE-Tag: 1795015978-82948
X-HE-Meta: U2FsdGVkX195k55oydq/HEaRwVAslabJROB9vv6qfMm5Ev5LKZk5epeKKza9EjdGm+tZ1M92rg9juscGKnzgA4wZDuS2D8FcClEPhhgC11eRBu2VMJBm/25zJI2AsYAbdRGeohCYJvSjSfTGLJWFj+2j6rCEe0DFLjxxkFa5IeYJsdIYkdy37ZK/gzYJiaLPxr8fPwbzzM0b6bbFCB0T76f6klQnFi672pFnalOPopt8lKAaRPQvSQeUOWYMibw/CsQ3r5BZd9SqCpD3aWLkO//cD92KgTvtbCQrGHMzrDi9VSzOYdvT5navN0dphUdn8z65wO8XdYL6IZuGWFj3QurOYcV2HHzbkumEV0eWLFBbJdBqPcZaAvv6BFdlFcRwPBwD5YjNcZMnA+Qx8eK1OYdkJillRMDZI+hK4En+alpCzPa+KsXeNy6fXkgCxyt4fcSSycJ/O9PX2sFyTO7xum99IYHRk8jr2G0kEFFgGFbMQ0MQriNUD/gvN673GLjfavQnHyihkZXetYwrzTIHKqD8eevxEExvBQPFugDLBk9ae4L8qAWapqd00c5KWfDPdqyZ7M6Kc/tmsHMcNcsKC5EDU8VFISN9dKySzBkz0QLL+K4KJlRz7etxRU6aWh1ADO2ZJmpN11B0bqCpJyLbZuEMa/ofehpihuTGHibTjfHAfxwMPkDel11AVjxJQb2bbyJlnim+6fwNlCI0RSFi8Nq4eCiiD1aqxB4af0XQbfxYwxyKo8OT5FEobb80FSUlWlAgbww9G8y7tNHSNaKKMPtBlmq7X8qut0M17LC3IIgfRtt2mGj2SeAu8/rx4+FAkyGMzhWHgmABfvbnWWE/ZrQDuFfF+/bN2hQHdyfZmrD11BsIZmZ81qs9qkkq4Wi7rJx/1Wv/x4kBDlVOhqn7wZp/ysCGgjeCveIjAmLUtvLHg+52u46/JBP575OipXHDcT/5gbboYcuaXNqiZkG
 wZNvcQAB
 oGkVSN/PVZ5ctbAKezNNs8YapFS7vJDzWPAaMm+XXzE7wq3i2hvySCkC4zTemfMhLzbLuf5Hef3lxqxjAaXZq87xJrS4t8kp9ltwvu1OhQtDCwLrFYDKdAysfM2dfqwz93h9ZshePsB2zumXH6RIHe4IslQjk4JDz4JO7n/2UlPDJfFAzuEFYQeJOCIH/JPIkzjGUZyPZA8fUny10JNTTDS5qoxzIQ3XtLA55MudukJ4bFE4MQy/JxVgSzEJcB4ouoj8Jg8vOWksE1OzzovpQ9Mby0RQYfMPLDt2rJTSN20ArFKonZaI/i37JjsWzcOHgdtwIhvKxHyGQNsPlK/K+4vAEAM/53l0fJPqIjYkdgI94SfQtGr0ZEZtLiNAssoKmdLMUtvBFVeeenMfnqBsgYUNteC9DAU8MYOwGznZHCn9q4VQWdmTTmQK/0OGV23PVI+xGY2Vvc7JzSrvZsT0lSfroVVCcGoACV+ez3jNeV1n38HI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> After a KSM page is migrated to device private memory, ksmd can oops,
> and KSM then stops until reboot. A process that maps the page can also
> loop in page faults when it next accesses the page.
> 
> The problem arises because KSM doesn't know not to try to look at device
> private memory that does not exist in the direct map.
> 
> In addition, ksmd skips all device pages when it scans, so it drops its
> rmap of a KSM page which was migrated to device private or device
> coherent memory.
> 
> Disallow migrating a KSM page to either by explicitly testing for this
> in __migrate_device_pages().
> 
> Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: tweak commit message, comment, also refuse device coherent ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

