Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DBD1606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JLRsA5zy
Received: by kanga.kvack.org (Postfix)
	id 797C56B08B0; Tue, 27 Oct 2026 15:10:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F746B08B1; Tue, 27 Oct 2026 15:10:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685146B08B2; Tue, 27 Oct 2026 15:10:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4656F6B08B0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:10:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D21A3409BA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:10:50 +0000 (UTC)
X-FDA: 85369348260.18.009C9A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 156541C000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:10:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLRsA5zy;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793128249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxw22+dUBVHsNmkwZBBvZhpzn7DjpEcijhpCagz+H44=;
	b=PyvE9YepHJnBFVhxGnqtC2ESxr74WuIfnWCuqBvVRNj6C023B62tLRasUAyMFeCT6nLgkn
	A3agIhLLDHPa7X21g0jZqf1fkh3Zjg455eHqTju2UT2IIOSQDjdMF1sSzw2afVIyv9GVb8
	yNb3O54ZE2uXoKqh48R2aTWBqh7Taco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793128249;
	b=EsWCXSCmAOtM7L6KboFCuGwEmInU94/eWBlBL7fhCIGp72H6pwlOCuV+HAfp0BygOvQ93F
	DOsSF4qvWc38OdWQSYdehTuIZC6bKtUMtRBADGxpWseD/2Y1eg6xPP13AAz20m3KEKUlOF
	+fklC2nuS945JLMWEADqZdVlwhe++n8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JLRsA5zy;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5BE46021D;
	Tue, 27 Oct 2026 19:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF241F01829;
	Tue, 27 Oct 2026 19:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793128248;
	bh=gxw22+dUBVHsNmkwZBBvZhpzn7DjpEcijhpCagz+H44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JLRsA5zy6lBMaJmnj1OuZDWK7USr/fw9H52uehWRrOa/1j8WudtcfkokPA36DPpQP
	 S0rcY4Q/4pP+YF+byKiwleEgDfpZwaUDVDm4L7dPRJIfN292VDlcwOc90kWkBxY6b1
	 Mi8DZt6gPGhhyfK5+ZRUlwvd29AYr89em87D8L5KbOI1ZjOc3pnjoO99WUhQdMSkwB
	 Kd8v2WIYlELKJVpxwWEEssNQoRGjucCE81+gjs5//M4+n2M/ral1GW4g4bdGx/h0lV
	 9ntzmhQGFkbsCzUTDYBHkrEOBWleeXSGrd95OomWvfwcKf7/2yVImSsxRlxqZR1HRK
	 AiDKFUxA3cIPA==
Message-ID: <3d5e6a17-3ca5-4e87-baab-f349073ab8e4@kernel.org>
Date: Tue, 27 Oct 2026 20:10:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/46] mm/filemap: read mapping->a_ops->free_folio under
 i_lock
To: Rik van Riel <riel@surriel.com>, Andrew Morton
 <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-6-6f74bec9a5bb@kernel.org>
 <f12ffd4cf8933452ef13adae55d6d238a3069235.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f12ffd4cf8933452ef13adae55d6d238a3069235.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 156541C000C
X-Stat-Signature: gycgjr9p3wtt5xfrjnn5n6ji4ufmi7gr
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793128248-215658
X-HE-Meta: U2FsdGVkX19Yq4qdiB4cK18oXn6duArylJYO6cKn8RmL+NAD6B1wIQTb210F2NLJN4EoGSc4EqK8Z5LlikODosGtjfZU+60zxV0VZcFMiaIg2yC4o0jTJuYiirUrr1WvZPcOb9wcEA2HgxQyITgcckcFxJzcHu9BjdH1M8ZW/bBYpRvRizFOg/xaAUCwVoIqXXev/p6ZBEz1IqGAoTmFRR2PGnFgy1SqYGVaozwWZY1iuPUKQkYK4FjqBRHxYeFVJDc5kqWptyYB57Pck8PDqyWV1iGleWx7d9d407asHRoL1p53wbXfsZdS026tT3YG0n7bb+fWFanHOJnG/gN3amnpy+goxFy/Y2F7GYG/uzIelYV/7Q2ALcHa/oNOon9cMS5OQUmJ+5VhyvPQOaUTi7hzw6//EUcu+zbzZyhJotMR+b3FavqRFw77fb+ydUnRdbA07EhYuLhM1HKFseUm3FHSdDO4c2K9IJkJOQaafIGev2Xnz2PbaLXGYeq84KQ9bNCLTr7Ya2QWji5OCqBfQf+nznbfIJDGnLWLdkwWM4yGsgkHAO9FcvzOdHCAmg6nz8v6SrhvsefNfBACQLRSABrQzCCTahUCHCZARxisNU3rvoMzCjzhv1oNcO+lmK2FZq1BGgvUW43Qpf9rfYOJxk2qRw/kxTGloy7LekNIGt7HktBvthKOfjy5JAJdt5kZVdOf+4c/DHgVUjDwDHz/bupuZQKx1SzqxkQ5dNACrZzMTGwXWYaNOO2jN31ZVbZMHUjNmqXKcyHNEWsghS6NbigGooAFGFSfAr4moaADqVU5ulqulm2q2hexQUSe2ZgXJBO13onadQKqyi0h8GL/NHLU5wp9MsPto0iJa24LDZbSItD6iKMJeA777WM8EHGuW/UFRDsGZcOE63bIwrcWMSBLX1dwqcED32Siru0JwBcQ+uqklmJJQtcA1OoTFAA2vF6bZI0dyoP4f4+RwP9
 I0QaN4EA
 aVnomz3MtPjJLkqA7HP4VshrX2W0zpdIThx3rW+8pDPVLiMnGX7KyOENCza4+mO9ysukTHTdPHKje5CDnLyuMCLIh4Wsaj+G1mdjkdYy7TVSdracYLQe6iehJnr3xzTE8vlQTPAdkQ299L6YN3hloK4xJ78Fhv4jBoveh0RxZlr+521/dTi4v1kOouY1GXfP1zI7Ezj1LUV5l2D8LxjlEM8SpFkKPi0mA6wfwB3FcXsdw23HgKIItHWNmc/YCf3pJvT8S2dNwzUFJLp5Y2nA+9A4PI2uoOXU//4mh+ckanjtjUXgQHeD2sXbSAUg76xnNwIegepKKgCSpf1c9muSFHNDNyEdDngDPKVcC/NWL4ss8o1bNfh8xnvVZ8bk8VAS2TS4sDpNls/Zsktt8IdBlZgQtw/PaBYrS+qu+q8DSHCTLc9v/OgBAkJfhbo32NGKwmlKM2osP/6Imk/3vfk1HJV6nUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 03:43, Rik van Riel wrote:
> On Tue, 2026-10-27 at 00:17 +0100, David Hildenbrand (Arm) wrote:
>> From: Josef Bacik <josef@toxicpanda.com>
>>
>> The bug was found by code inspection and has not been reproduced.
>>
> I can't say I'm surprised ;)
> 
> I see clues that a most bunch of these issues
> occasionally happen in our (rather large) fleet, 
> but not this one.

IIRC it's mostly memory_failure() only that can trigger this today ... so not
surprised :)

-- 
Cheers,

David

