Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A07606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XJSi/vmL
Received: by kanga.kvack.org (Postfix)
	id C69826B0871; Tue, 27 Oct 2026 13:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41466B0873; Tue, 27 Oct 2026 13:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B588E6B0874; Tue, 27 Oct 2026 13:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 910016B0871
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:39:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28836C0AAF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:39:02 +0000 (UTC)
X-FDA: 85369116924.13.6567A88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 991B780013
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:39:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XJSi/vmL";
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793122740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cBJI2nnIkywytYzxR6H/QQFOPTi1qFD5/ttRLHdX9w=;
	b=WtipHBr64WnceCQz6iUVX5q+Hd61t4u0C7hgep+gzscpiMKbz6hZ8pHXPs5o501wGw9YrK
	koCis1+xg2MrAzoJ5OozjChzPzgmwCyy/h6qj0sRxci2dGS1HqIaO/GHGnDyHMUAuUwk3/
	1ozDNbG1pqG9GNY1Hfo8dny258PR8W0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793122740;
	b=SzZDRAo8wGJgQOkgb1TBrPDF7MB2NMmiasfs+r/pR3LXzNj8GrZF0gRuJZolJ6XBx/jQBN
	cMG5MpyTTkHV2kYNZIaNQZQf2x66LJVu+LKldxpIOhXCUh1oYAa+tI5eWJEnE+FG8CHjxs
	nlR73sO9r5ntG9TCo2FHJ9AE1Ww1kS0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XJSi/vmL";
	spf=pass (imf30.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BFBE043DB2;
	Tue, 27 Oct 2026 17:38:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAC361F01825;
	Tue, 27 Oct 2026 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793122739;
	bh=2cBJI2nnIkywytYzxR6H/QQFOPTi1qFD5/ttRLHdX9w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XJSi/vmLDkwnReKwKmEX4JRALl4syw+iIaeGn0uJWZZMKBFHHtHiF7enafrQ9woRP
	 yoSRlydCDwzuwwl/OCE+bZzKi3TXFoBvcoJ7/8vdphLqH13Vv4flItJXCKhApdPjX5
	 1fhiuCB7uODos7v0qtlUXi9BUb8CZY6nWHQ8JhpV8fhP6cfpK7Sb1TnmkbRqOB7ra7
	 8cu4ZAjnKmBA7PU8Ne84zg0Cmmg3Gh5PgrGF7ASspqYFeRa0sOzJLgYGuukSpK0FBJ
	 qjrKoONkCB6PmdFb5kmfDuZmQRqF1xnZH1d8ct2sQ+Bidhd/moOzuhhrX9Swacz4DS
	 c10ssfWxCS0og==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Viro
 <viro@zeniv.linux.org.uk>,  Christian Brauner <brauner@kernel.org>,  Jan
 Kara <jack@suse.cz>,  "Matthew Wilcox (Oracle)" <willy@infradead.org>,
  Hugh Dickins <hughd@google.com>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Zi Yan <ziy@nvidia.com>,  "Liam R. Howlett"
 <liam@infradead.org>,  Nico Pache <nico.pache@linux.dev>,  Ryan Roberts
 <ryan.roberts@arm.com>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Lance Yang <lance.yang@linux.dev>,  Usama Arif
 <usama.arif@linux.dev>,  Kiryl Shutsemau <kas@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Mike Rapoport <rppt@kernel.org>,  Matthew
 Brost <matthew.brost@intel.com>,  Joshua Hahn <joshua.hahnjy@gmail.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Ying Huang <ying.huang@linux.alibaba.com>,  Alistair Popple
 <apopple@nvidia.com>,  Kairui Song <kasong@tencent.com>,  Qi Zheng
 <qi.zheng@linux.dev>,  Shakeel Butt <shakeel.butt@linux.dev>,  Axel
 Rasmussen <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,
  Wei Xu <weixugc@google.com>,  Baoquan He <baoquan.he@linux.dev>,
  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,
  Lorenzo Stoakes <ljs@kernel.org>,  linux-fsdevel@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  kexec@lists.infradead.org
Subject: Re: [PATCH 0/3] mm: allow freezing mappings
In-Reply-To: <fcb7b786-53e5-49bb-8505-63eb8bb4e836@kernel.org> (David
	Hildenbrand's message of "Tue, 27 Oct 2026 18:35:51 +0100")
References: <20261027173031.763213-1-pratyush@kernel.org>
	<fcb7b786-53e5-49bb-8505-63eb8bb4e836@kernel.org>
Date: Tue, 27 Oct 2026 18:38:52 +0100
Message-ID: <2vxz33troxg3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 991B780013
X-Stat-Signature: 98qxzmw9caa3goc6biyzp96cpq9i63uq
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793122740-243748
X-HE-Meta: U2FsdGVkX1/B4P2MHUzXrPokAXySgK0zTtea8iYRjfnkwDzZPDR/CLKAbUAzZlLlNEqc1u7S8PnK5ncy6bN6HBN5AHeatY4PkRG+x3AVTOYEe5t/sr8nqkHJze+Lzmywm3jNcnLpxioTuFXjt6eREDO7SSNAc7IFA1IMprApVRpF/73h2SRoNOKq1twOjyRwRJtPW5U08G4u16WxW+BKVTKVZvu7NNRS6Yxvi2CHkoS1OxAnSn2BkBoTrUX0fqX+1xDczFPaFl4pAsxC3Z0PI7ddMoWR940zXd/ECQtHZWUJFzdmlHtQc1oyNx52VnAFc7cEBdVJOkFD5DDmaLVe44CbhOU3xAotCB+nBEKifWhNKI3ytjDS9RbU2fudXQlX6G1wIOXe0dcI9MWvPI6WGG+CkVvVTfzk5bdHdYumznwqzoIIjac+GK87+RVVhjw1oADam0Qrusw+BFA8NP8Y1wnZ2MTZHSFXGMb+K3jwKj5w7Np7x5BVfrtaZ43SEMPzhEQpOqfqMnRXUuZBGLpU4AxgbMRnMvascdSahDdRdxR1dNBO5v/6kzUI7ojaFKhIbbdVT0KnVxGwPy55NuAUi3CZZ7QMElzAH9+Y5n/kec+IrA82l6pWwg4nOAtW8AdXQpQ6SuRfcwjLpOnX6/KSXSV0pMqgHDIeFQsTQcHSBt2bbYRL0VW4uhcpy929HeQB7WzyCZ6heGY2gST719SJt4Sy3tutxIzN/QqFE1oZ+EEo9J8RCyrcDo88Cgel+JgBUz0Kl0KuOz/m7T749OCzSP/5VhebhDdjvvlKnJAiW2BkUEfIJvoYvXZYyvBRgmRP1zqEY22+8UHuELYKUQCZ4f7Qfd/QD93JKxHt/OFRVzKfDag6YNGO9PLAi3DQO2xlg6gT7TF/KBlKr99TtA2VS7dUyfEcdtsTB3SQD4kI4M62wfAqO64OsDBAzSKBA+rwv7GwyyDl9R2QE0aU5SZ
 kfdKrnvo
 pIvM5dD1Hg8UcfRC1fFUMe3airVNuG3F6mUGxmPXJCxpjvxX/kC7GSBcvrb864aZfsmL2+ZR16zf+/Mu1lkWIcWwIHlXJy9MbuiwXsF92wO9NUexzFTsshPObaTlYk+voSMv9Sk6B5U6RYDp7l591OEX/PRd4PN+Q0fLvwkixFwMJT/UKMFOpdu3Z2aFIeEqRa/dIUKS7zCNCxZARPx8n7OFhudKMOxVTFqgDeItfLhs9QXbs7lJmF3vBfblCjUQ7FncwDrO6iBpe58ndCXx9UwF6X3OcyTa6Q8aiRM9Cx4ACbTxKO1IHrqcQzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27 2026, David Hildenbrand (Arm) wrote:

> On 10/27/26 18:30, Pratyush Yadav wrote:
>> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> 
>> Hi,
>
> Hi,
>
> we're in the merge windows and focused on fixing things (apparently all of the
> kernel). This is not the right time to discuss new changes.

Sorry. I thought the MM tree was open to changes in the merge window.
Please feel free to ignore this until you are done with the merge
window. I can also resend it after -rc1/-rc2 if you'd like.

-- 
Regards,
Pratyush Yadav

