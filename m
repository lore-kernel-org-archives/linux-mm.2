Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32DF4606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 09:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P21imY+g
Received: by kanga.kvack.org (Postfix)
	id 5305F6B065F; Tue, 24 Nov 2026 04:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B9F56B0661; Tue, 24 Nov 2026 04:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35A236B0662; Tue, 24 Nov 2026 04:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0766E6B065F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 04:47:33 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AADBA7AAE
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:47:33 +0000 (UTC)
X-FDA: 85469535186.27.3F29280
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A2F2720004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:47:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P21imY+g;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795513651;
	b=pilxmBjTUvdcQD+za4kipRH2kPHCWiDDcd4UMXuS2BIKo3E+DxBj+pmRZj+LcGp4toI1Pf
	MhycZvdFTah1eCFDO/qNbDZTX+zVC3+iEmbNyWaOxFNZNfOp0dGkIhGnHvnnCrtdNIsqms
	rUfTDkzY8kreQmWRrjLeFkgXZ5+LMHA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795513651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BE5LNOJgpR9371JeC5ubWrbf/K2t8V/MrLNI+7kIZnU=;
	b=qhbg7xGmLntHJlDpFPItBPPcnw+KeTLNZvfhH9fpYf1OSkLgehuYM0ZDePa4lxzczzbQDV
	KI4Xn9CtNE+xZZDScX54nAO8fAXruJBqcKne2JjyKEyRg2HgxrIF+J+mu6o8plfYcspoWc
	+J/wySIM5fVv2yUmTt/ecmIAmMqJ97k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P21imY+g;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D0818442D2;
	Tue, 24 Nov 2026 09:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7271F000EB;
	Tue, 24 Nov 2026 09:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795513650;
	bh=BE5LNOJgpR9371JeC5ubWrbf/K2t8V/MrLNI+7kIZnU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=P21imY+gWhrYCpeL/HiKbV+EYfI2Wx8PC7+4DSG+t3BwYqFQfayWh74rAYl2eJwsc
	 /pps4EmuqT43Ahbu7j7pWoxc8SVjTHgzOT7F4EuPOtozkAt14zJXbqcsQNhruX9yCQ
	 nP/NJCvh373cAS+Pot/J5GWhaMRDho39Iq0I+1NEFphF4407BvED0vNACW3HHwIfQF
	 NLhf674Q713NGMRmtpf/3+XzNCufwPSiI1dm+OsE18odtnWpwtRadgpY1oZV6rQLt9
	 TGlp7VSzF/1cO+cLsOKtumRZJ2avSwVW72e4cSHWVFtrk67QGXiKTVL2yMTQ0mC05E
	 rAFN7XX2B5pgg==
Message-ID: <66e5f9e3-17d4-4635-8919-c67ed562f9f0@kernel.org>
Date: Tue, 24 Nov 2026 10:47:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] mm: fix deadlock on the folio lock when migrating
 and splitting folios
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Johannes Weiner <hannes@cmpxchg.org>, "Lorenzo Stoakes (ARM)"
 <ljs@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
 Chris Mason <mason@kernel.org>, "Jose A. Perez de Azpillaga"
 <azpijr@gmail.com>, Chris Down <chris@chrisdown.name>
References: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261124-migrate_reclaim_deadlock-v2-0-03cc147e1e36@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A2F2720004
X-Stat-Signature: 1ocemnswgz6tuzqa7851roszgb8s85f5
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795513651-36901
X-HE-Meta: U2FsdGVkX19RX9pMTMqRaW5ykLcsjv6VojNnd2ifyh8o0Ql3nAVOjkGEPZa13kQ3/nCNNWWx7/Usy5LqkzNGBV49wQhuQO8AsnZEO1Fly8A1Hv6ZHrd/4YMSMb94Ccpd+t8LkfVHkreE3aBkT7SA3mivUSngdHBPichI5Cwi8DXGQL9ZRRai11B9vptPww7IcCayYrR5foqy9wdrnjaRU6GurIVydyzLO4w2b5XAJ0Ryi4FC40++AHqV9o9Cg5/LyojJMVXCY+giy4O4YqV0s8ALNUWyKmezUZwSN6A4Reuepsn6mLQQLzbj9ikYaqyrYreP7d+HiL/ePHRuF5t8PxF264a/ZZq82avy9BqALW8NJkjR6qD/jZctZOml8uGujYbsWQIyq68VsJuD+3cK+DLQPeOjTDEi6k954CfuscoESUdf09/Y3YPiMlY5qMQtHwlfwbwAggqohm+p6GHoOnvRxUX4eHItEkZpUDaC4aGh/YxqX4ESYRaD599UbstIJw5c8bzUOGTHc4Nl/s4jjszy6rC85mlgAcvw+EBsgPBZPkBloK4kGxUrBr2EoSPylu7avJHDnUgYDUnuzAvZnROjhpB+QojImup41plNG5Onqw1y+R8DzIWbBZmMShDwQ0vUhEFQCSSoZQerMzJMLxxkxirQ/2JTQKLdLNk8n8g+Ovr7KIv+6pSPwq06esLf+x6OxjPsf+cQ+CzsUw1B+jpB3hOA0pFh8iUSkLPsRZa3vOeWpxElBUIZkA1W/Vz/pIyno+bENSf5ZcGsjryy89AEDbt7kwJgkRNFyFBFaS+6Cm4ktZOCFZZd4WLEQOMUxoVGa4UbR9NO4t0opB3Q+fim0QXaDXKd9Z34FG1NjpMd+xHEtoKdtKCcdKd8XEUG3Z1zQVxU/rZ11nTjFG/cwbiHv56neZ2gfdAtdKh2wCSRFmSukuMbXaT79jzzizPKIuIkGmndpbgr++Dv673
 A/T44FaP
 tuzx0Wj3FEizBgczOucEWMTgb1z1+tytDOQ9WxVi6/OOgH/34N0BSx5KFjXpCb8kwLJ3UnPhivZvRg+f37/qnImqk/+Ce2JoCkm2TViaXFyLlyY4n9LjWie1mjiYbbAtJeL0ccCljaBFWSFh/6v94Mu+TXk3eXHibGKlX+OBKnbPWFMSzlnP8dTGIbpXqa8w74gTMS9Hc2GJGHNWRY7Fctys9Aey6/0WM3cys7o4zwwL7tDKEVXKqMxsuOKAjjdSXg4WrT12FzpX3DtnvZ/mARHY/+PNlyQd/YkJLrzRwrCJ2EnBtGtXxyxyP0UXfP87IoQsQNRxvPyIzVO3LnJMhGeg7N/NfEcFVjebRrOKejw5lzxmsYhl3elY8uwaoqYtxJLVASmd+YBSYnnhY19Yc1Dgzg8Q77N25Gxa082SP3/0X3QF7eUo40pShaGdz+re0gbKLYvWPtScUuJTKE3JQdA2d+IaEJNur4aQLdGZCFJ+xzq9/QHghTv3WJ8vAtVLZRCJz7ZDSG+vjU9kKkYmrWsSWsabRT+lnuWF4A69STHxumUCrK12wr11e2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/24/26 08:56, David Hildenbrand (Arm) wrote:
> Whenever we allocate memory with __GFP_FS while holding folio locks, we
> can deadlock on the folio lock when triggering direct reclaim or
> compaction.
> 
> For example, evicting inodes with a populated page cache takes folio
> locks, and if we happen to need one of the folio locks we already hold,
> we'll deadlock.
> 
> FUSE makes this example easier to trigger, because it evicts inodes on
> the last reference. A similar deadlock with FUSE was recently fixed in
> FUSE [1].
> 
> Let's handle folio splitting by simply running in NOFS context. We only
> perform small allocations, so it doesn't really make a difference.
> Interestingly, this also fixes one of a handful of possible memcg v1
> deadlocks.
> 
> For page migration, change the code to allocate destination folios
> without holding folio locks, which is in any case the right thing to do
> to reduce folio lock holding times.
> 
> Some of this might also be fixable using Jan's work on deferred inode
> reclaim [2]. However, that is not stable material, and not allocating
> folios while holding other folio locks is an improvement on its own.
> 
> Unprivileged users can trigger this deadlock with FUSE and
> mbind()/migrate_pages(); however, it requires multiple NUMA nodes and
> quite some luck.
> 
> I reproduced the original deadlocks with FUSE and made sure they can no
> longer be triggered with these fixes. Further, I ran the usual migration
> and folio splitting selftests.

@Jose, could you find and fix other cases where we allocate under the folio lock
with __GFP_FS (and direct reclaim enabled?).

I think at least do_set_pmd() might have a problem when allocating a page table
through pte_alloc_one(). And I'm sure there's more.

-- 
Cheers,

David

