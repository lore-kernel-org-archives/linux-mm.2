Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38816606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 00:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gINnAD2O
Received: by kanga.kvack.org (Postfix)
	id 111026B05B1; Mon,  9 Nov 2026 19:23:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C2DA6B05B2; Mon,  9 Nov 2026 19:23:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF3BD6B05B3; Mon,  9 Nov 2026 19:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE0CE6B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 19:23:31 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3863BA8598
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:23:31 +0000 (UTC)
X-FDA: 85417310622.30.89B06AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6F6EF1C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:23:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gINnAD2O;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794270209;
	b=G7Cs94bVcdaWPXvX7Z2x+E+Cfn39mUAK0tExFmtK2VwtCwF/A4qOk2bBbJadF291+wpKLF
	dpMFFP1bj66SUy8gJT6sgBKwl/qcSbud7iD5+xuCzaMl/brPN+nA49VY3aSxEeSD8skr1z
	UnP6xyQhCOrgEBfUuy2SChosfUdSzIc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=gINnAD2O;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794270209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Or/iwEJV3s6/OZb+G94Yla/RPMj3Q8ZsEYH3A6tdUpY=;
	b=Hgj/A0YZ3nWLrx+jbsTvymUijjEwBwMeZSsO7WkYl0I/PIw18hvQ7pAxQjiVfPXjQ/vF7g
	KmUGBa7umKta+JiT2RVeiql3oQD5xJudDW3VZsAsj7j7MK8TfloYvFgmChkhd7Zznm2/4z
	08+Bt6smIs3tXVmt4oYdEajEXrCNXKg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED04361142;
	Tue, 10 Nov 2026 00:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFEF1F008A2;
	Tue, 10 Nov 2026 00:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794270208;
	bh=Or/iwEJV3s6/OZb+G94Yla/RPMj3Q8ZsEYH3A6tdUpY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=gINnAD2O6rE5FAzCv2/fDxSlenMynl3hkBpwj6TR7CLiVWp0H7UZwY8fxSgt7o+j6
	 NsuZro4PlPsnIG7yIZu7YGjdNXd8v9jI7dVMBfQMkEkycWL7Ky72sR8RpznLOLG5PY
	 eeZTWRwZcOu7MeeO/st4JcoP4f34QlO1yPrnKGZE=
Date: Mon, 9 Nov 2026 16:23:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Mani Tofigh <mt4022@columbia.edu>, Zi Yan
 <ziy@nvidia.com>, Mike Kravetz <mike.kravetz@oracle.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Miaohe Lin <linmiaohe@huawei.com>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, Frank van der Linden
 <fvdl@google.com>, Chris Down <chris@chrisdown.name>, Joshua Hahn
 <joshua.hahnjy@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Kaitao Cheng
 <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 0/4] Subject: [PATCH v3 0/4] mm/hugetlb: Fix CMA
 parsing, flags and usage accounting
Message-Id: <20261109162327.f1477705ec4374b5a243068d@linux-foundation.org>
In-Reply-To: <20261106100521.30099-1-kaitao.cheng@linux.dev>
References: <20261106100521.30099-1-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F6EF1C0006
X-Stat-Signature: nwin8qco6wu15wjmb83au7d6jcfw4ab6
X-Rspam-User: 
X-HE-Tag: 1794270209-452581
X-HE-Meta: U2FsdGVkX1/SdyOwbET3SZ48GpYGxovdqS3zOeMSe/tU+iyZeSuBfokfMu/HwA6dqlCOaM1snjUVkHXcxBPU0u6bI8u8q6FVm2Qsr45HqsNpQLwOteNH3AF6YkWOJhvUa62K0XQtEouaJPZbPRlO55V0iZpjmGPOH1XcqqFqSLugho6vxkutr3yLxfY67EZxKfp36KwkpdCRse3RZ1/R0SZY2Rj5g7S8OXlKFiU1JNEf7OoWoTwlAMudRTIySQm8IJhOpP4KZg9m1rQVS0sVeM5bz9cewumCw1Vf3c/yJHD90UZEDIDV61AJ9SQuDx4ZrTIFz2wCF5Ck7vyMnJlbz4UvmKVfMNX6lvzs9J+CEmvxyK0vVVGNcE1GOS8MY9Vqr88AdFhcpFh29h5eZglSxp2kkxAyCflG4LrZ1W5OmYI98tkALRvR0zRhuiRt9sFPauJ3zvpxiwagiNE2dctvHPsKHalHoInoqUC0L7a2BoV3ejzaRH1T670jv1hkqWWwEvYEVKmRP2IBHsCmUOksIrajLqJ1W7slblmHLy7QROsJZajUog3eKdAob3/HLSuwf1ut5XQyZm+eL69CNBv8YEsVfeU49NLEi3tuCPWvEtg7ZF/O7sr11BO0u8Vay48eqFYGB1P3ajPcIgPFa7ukFCwVEOUoh79l2kOedNzgGtKPXf4p18dPSqV6XfS39rmkNsy2U3VneHawWaBDMSqDNhau5yzQ9V5+5YXD7CsFXMpFoGfFrJMgrP+FAwsUzE27Wz++9hCEoMUKkxt9i846G0mj2zAl8cwqz9Ccn6RZzKHlIhWryQn5CUm2zOQ2kd3NN1+Dhi3YE09AOFaoWT1aBJ+VrYkMevFRj/DmRcWt9Wl70qjfl9LU95B5+iLAEzADSviRQptA1ua1IzP9A421d4S2Diqwegwn1iAt489K0imus16or1AwoQ+D9afKCu2+sNZyke/ClrBFG+pbnGQ
 IlFaKjGP
 w9z4UcwMC2O1GH+bHLGfKTsYuNrRC8tBKA+xO26aDk4XzCLSNYtqfGw9lmDv4hdT8CKLAzHFS/9aotdBQ2kxHODIWhqdcFdalXM48YyBWhrFfe8emKdvGDgx7JRVf4GGz4ig7P5bBZ/waaVCu4YHawN5gcDYCU7v9qku7BFGyNOa0/JYmhZ/2L+QKSj33QYQUj59buM5RtnKpZ/CLtY97yf6jzoqqCMK88+c9MOD4OpKgsINU/MVSzwAPFw8n83nfYvMuekkcuAnSAkNnPtYahDJKUuMlCmeeLa6uCW1iCsZU5B0bpL5ZjL6mGX7ZMlGYYlQQtkDmHnHsumM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri,  6 Nov 2026 18:05:17 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> This series fixes three independent HugeTLB issues reported by Sashiko
> and includes a follow-up cleanup of NR_HUGETLB accounting.

Thanks, I've updated mm.git's mm-unstable branch to this version.

> Changes in v3:
> - Retain patch 3/3 from v1.
> - Fix code alignment.
> 

Here's how v3 altered mm.git:

 mm/hugetlb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~b
+++ a/mm/hugetlb.c
@@ -1450,9 +1450,9 @@ void add_hugetlb_folio(struct hstate *h,
 
 	/* Callers must clear transient flags before returning to the pool. */
 	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
-			     ~(BIT(HPG_vmemmap_optimized) |
-			       BIT(HPG_raw_hwp_unreliable) |
-			       BIT(HPG_cma)), folio);
+			      ~(BIT(HPG_vmemmap_optimized) |
+				BIT(HPG_raw_hwp_unreliable) |
+				BIT(HPG_cma)), folio);
 
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
_


