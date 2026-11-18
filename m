Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D79606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NZAyN23c
Received: by kanga.kvack.org (Postfix)
	id 533496B05B5; Wed, 18 Nov 2026 10:35:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E4826B05B6; Wed, 18 Nov 2026 10:35:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB766B05BB; Wed, 18 Nov 2026 10:35:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6756B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:35:52 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 765FBC079F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:35:51 +0000 (UTC)
X-FDA: 85448640102.24.FC2C012
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 86925A000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:35:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZAyN23c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795016149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2Y0uksBfonBwzOwNmdjxS0BTSWKi5CUHrmpAZqGpVc=;
	b=X35G++y9tMkYo6mmQfXPW6A0NJEvMmveBUfjfEvETRZWqB9x16lx1h2CBeToTuYwTjEhtG
	FdQAk6q1wqtZhhR8mNFC3ZbG07zsLGCqaDF79E5hnZFMXX8ZIDgUcWFnS3KNaUsrpg3E3K
	8LX6oK4XTe7bsLxdppSNMZqUBhxotig=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZAyN23c;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795016149;
	b=8bC1xGKRAJt9uvkFrvbxpp6vKxjDNLovXfRXG+KLnsn3NbKzDOlbKbdKac3rDn6/3zfq/1
	ZIBx5397WyV1dktIBwO3oWV2EdcQlrDsYyXXcp8cGWnjx6CI0Df+L60WREkdo1Pz2eFko1
	SVrq0RnxfHrhas8UclPYimS9a1sdB8A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF5F745E3B;
	Wed, 18 Nov 2026 15:35:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFC11F000C9;
	Wed, 18 Nov 2026 15:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795016148;
	bh=t2Y0uksBfonBwzOwNmdjxS0BTSWKi5CUHrmpAZqGpVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NZAyN23cS3UbJ/9rD5RcMSWPahxbPftycUeQarC22xj/dMgCMTu7gdUdRL+AzWI48
	 HCddOA12zv+vmSsdyWZpk8mMdvMjbFmBvNJWu9HONh1itqoLdq2yRfvkPBgZW3Sawq
	 KGsDf1kaN9hWptbz0OxDnSIN++gAZYla6Pm5+uf1yO4sHyQpD1QySJzpN/egZnjfnr
	 9OsGsr0KEUxxsUNSRQrAzAMYOeTadzDFqgZG60RhJ4WNV98x/+Eu0G1DGTfPFJXG9j
	 RPci+KnUD8+8dVTBkG0H8TFal/Pg6WlQy9aQkcPTbvtyvW8qSNKx0o6JioXBGHbcRX
	 gXtJuzQKxIVWg==
Message-ID: <90a961f5-e488-46de-8872-0e1540eaad4c@kernel.org>
Date: Wed, 18 Nov 2026 16:35:32 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] mm: batch of (urgentish?) fixes in oomk,
 cachestat, dev-migrate, percpu
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
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86925A000A
X-Rspam-User: 
X-Stat-Signature: sjybb5ukf4ik8qud4onx9ah5641xdams
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795016149-647715
X-HE-Meta: U2FsdGVkX1/3tn1FPhYRBf4Fnqtw6Ky+hcif7iQzKtGYMLvMHUUKgArvkIRfN1ew6afpJZHqke9vDW9R6UcuqMj5D9yGP+MGJNcLPa4+ZZxzcQai7oLCzUxIB3qReqHeh3nDvRrS6TcORZMxWEJFx0hxTjM0qX1CLPd0jEizVAuwYCj9IH3h3ftk2BSghKL/HDqbfbay3x9VrrbY90rod02B6jE/n92WwYSleszqv9foQ3RMbQdIMzqYvw+YnwH8zJRLwVXGv0LHG9+cckVYz6RXPwIDHZu5aAW42R/4wL5Wsp6TLwRUzSgfHDxEEwlhYdTgL8vfP0c7kPrC90byxeFBfEBpIjhcyD1SYMWAkDKfSNEqCO+ZxiPSss5to71hTQN+FOS/HrYzX1CTxNG9OpJSpi92ZUMqrV6124u2a1VxJ30SDbtUZPD3UBrU73ovBQMTTVaw1Qr1Cuw127X7yg6WyQQrcXM/Ztk0uCNIgmF8CfMmwxTBuqyOd2pTBVM263nP7ShsmWqlgdZPdp2JMcD1R7wfVJGfAZmqH911qrAlv9Uxx2ZinOPKCcQudARNxpfzFyRFyheKTgRJfWIuODdWj73Nj7+Ida6ZZ/GVDWZYmEfWW15GgcUzTJTBPmyfBcgxMU3jyiKHpI0x3NSmYg0nXHFTSJePBbLmyK6k2L/5oB3W2UFPw2AKkoiFstr0kBIanVrhROAhor7K3/0CPiC0VGzJ2CnY2baFijw5f20nBb2MEp+4GqjKWu8knHV6NTEKO57ONSTjuAREOB35okSKYkuecJTuQfYs2GhbboqPJeYhJb8MZcQY6J9asDS82a4MyTcrKS9we7GbXp1rABE3Ky7wrdSKwN+AEwUFrZi9jP4w9XERjRxi7yMaIEqUwJHc0SzxeCvUeGnjOam09lhvHtA45mYdIHIrwB9pm6sSwKLJoKj/6ykbiCuebFsR9eeQNn4t5CA6g7UpS3Y
 I2JGNt6T
 5erjKMh0xurWopd/n4DowOrN3nV9NaGUQFBgWD684LARo6JALR7njrFjXJMudxGRIaFHa0fqvbkEPOLxGjf/3dMJ3OtVG42e0i5n6TVrfQAA+13Yqpn3QDi08nHNvMUZqRA9tRAhPONGwLyjV9gLnuBGnDPxUmjbTSe2yGSZxUiKIiThyK986qb8ogEO3dee8LBOEgf4MDxwRr0zOxZB3nkRGV7gr6o1qQjdd5IfZLydqNqMpkKyr+Pd8PuFl1b4O3379SxkEvdad3apY+88tevqckGa4XVJQyCo0fuJwpky83o9MmAUQi/ttQ3K2AHWDRfkgu6TD16wILM61AbpjvFbYT+To6s88VNfG2pYwOgiT+rAbEzzyB0IUpFO+ezJglkzzx2hy+4LjyuPAy/TCndO/Kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> A bunch of fixes for oomk, cachestat, device migration and the per-CPU
> allocator.
> 
> These patches were originally AI-generated, tamed into upstreamable state.
> 
> Some are more reworked than others. Those which needed a significant
> rethink are submitted as mine and marked as Reported-by the relevant
> original author, others are smaller edits which are annotated as such in
> the usual fashion.
> 
> Please check for correctness, sanity, and whether the cc: stable is
> warranted (I have not included it for 3 where it seemed unwarranted.)
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Lorenzo, I would pick up the migrate_device patches now.

Which one should be fast-tracked upstream and which can wait for the next cycle?

Use-after-free, shadow stack and out-of-bounds write ... look rather bad.

-- 
Cheers,

David

