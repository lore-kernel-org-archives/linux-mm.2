Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E01606A32F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 17:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KolnCTI7
Received: by kanga.kvack.org (Postfix)
	id 3C1B26B05B0; Sat,  7 Nov 2026 12:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3712A6B05B1; Sat,  7 Nov 2026 12:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2878C6B05B2; Sat,  7 Nov 2026 12:22:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F33416B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 12:22:39 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72FD71A03C8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:22:39 +0000 (UTC)
X-FDA: 85408992438.27.8183D5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id CBE6C1C0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:22:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KolnCTI7;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794072157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XmI8rWYPQf/Yk3+VD2zo2YslLq5vKVW6l7UCq9+Iu4s=;
	b=t9oM642fUMrmACHdyDhJmrwKdJSBiPIiQ487DJK0BNRNaUnzBJc/v5kN56BUfskKsLztdg
	TDFOO4irmG6DeuqKHnQba3zpUlMhyPhfxVAnqZwNosyt/WQFZtEsd4NlvUAOcGPCwhTVRI
	DsBg/WuOZfgCXi4+DIkgab15d9wr6Ec=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794072157;
	b=MXp5J9SUXrCkn9ia03bkNrX+nbgFt7xlCJIAloa0ysjRx3NAhEY1yr6CLqPghk5OGKSmkR
	BisRXWASu5fkhsE045Md+sPvqErsWFjU0nPdB/r88RmviUX0kZSl6RH9bZL7Fq09mI154S
	jHaz8rBdUN7tcw4TsJndrCdjMBb9DbI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KolnCTI7;
	spf=pass (imf20.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F243B413EE;
	Sat,  7 Nov 2026 17:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBA21F0089F;
	Sat,  7 Nov 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794072156;
	bh=XmI8rWYPQf/Yk3+VD2zo2YslLq5vKVW6l7UCq9+Iu4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KolnCTI7SaK31zca7v7wy2Mycrmz3EJfGWSoHQT+xw4wMvA5veAkZQyAzR0RHLf53
	 7z0w2Y1hoaKGxi6XRZfkLKShmaUF9YXKLnTCvVHVorxctr/2riWCRhVYDHO6JUDsb+
	 /txQnwAPITgzg67QQgZLuuhvC4TDhau41rQl1Dtom+Utzu4v7VHiNwoZu0/cn0y8/P
	 PLwkFVCeoUea5WmCr0NKAudWsjpf99WGVzC3JmNDIMMiNqWVwtxCRaxhwoowmDT/Lj
	 FsIWGLvtajb3oBbBnZA/TWCD+SHD/vs+w/hy5dKGnepbpDYnrmj8WXDbUyZV3nfOeW
	 odC6ug+HnuAgA==
Date: Sat, 7 Nov 2026 18:22:28 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org,
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 1/5] powerpc/mm: make
 vmemmap_populate_compound_pages() static
Message-ID: <au9eVOrRrnRNLUZb@localhost.localdomain>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
 <20261107043122.25650-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107043122.25650-2-songmuchun@bytedance.com>
X-Stat-Signature: qhdc1aoksddrxph5zhan8f5adrhj545j
X-Rspamd-Queue-Id: CBE6C1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794072157-458567
X-HE-Meta: U2FsdGVkX1/0KY+aQiYJzB5sLe4vQKz+bfOwR6MJPC1tOOI9NQpdHWM548AAa0YQ/LpJZWvCAGmvp+5PqIBJSDZs0Sgb21rbiwRCLEWomUvVhCFIWRiyHDM+ZtWoC98eNI9dRhM+XjdKjIjRAMRyY4jgvp6/+Uk6h8wr4J4a6MDH0VWWp9+9bD4re8pQ2Y/hVu7bK6u9gSjxqmzMIKue0vV/4vD8ICJfmf1mUcDKvj9Drts4CkrxsueEFJ1SQ1BhNe8xHMY2Jg+eUriBcpuHsKK59eBEFpbjp2ga9WA3LFlwOSrudfUxjY5R8UtHMkcul5fW570ZGUMPFrQmtISMYIwo/Q4dHOI0Sq4hzd/S0DWqOkLAYt9dQZ6aL0FaQ5w7d5/NkqCjQYQcv0UGY0Lh5IFwHmANi8c0kWHsWx7Z+/ZCOil2Pd39MYjvOWMGQF0A2JOn0uwO24maIU4NouaeLR0sv4S/5i+wcl+3oji3hbRMBfVjPfmDtHityvFkQDjWiBfFIgOO0nkyKMT8Guvm0ynRm29ObY6/g8ev5Bs0sXTcKOGveqw6Ey2txpd5zrCrr6rYOtUg2f77RYVV1AQEh+T5eWm4tz7RYt2jXhCVSjGuRABPwAiggVBx19VWLmq/eaXTyAHB5tYMdsjqrCpiLAkcMYbD9wdHJtOtfFbvPyz8ctWluO2ngK7CtlJ+04U4FvUaWQcg+SQsOul0+lLNkkTdgQwJky39TQrgTd+7lofnJUDLmaIxgXpsNCvUCmTtpgp/sSBOSW6jFtLlWY8fA/sRESEi5uH/cfNskhaVAOnLHFALoGDI3Zy7CNgTt3GM8Fv84AdxGLny0lIApi33o1gpYnAukdxpBpKSUeoyjmiabf/2wq3F4nSwy1Djkf113etwE8DQzByTUilwT0tjKXJXUJv0AbgHh2aBs4cBFgjrafR/faq5YAeWa4/5mOxhLidkcvY0fMkF5CtRIvO
 3DDr3zbe
 98gZkXKz0m8LRf5R+iFB9t/k2Vjz7D42k5tQ2EdA6n7MG+Hio/WkSxfFCrN3wy8MYz6T3O/IX/pIyIqbdYFLFQC4kRaXgwM5bBOewn9U08gGWcFfPWxm87t44NJne0B+C449y0O2QTWBfIAWhC9WJmCGhp+ZjlrxYsMVgCU4lwgbKXrIqgMHDlFiPn42WAeaSF77rAadyQkCd02VeeSQPWOXg7GtCDEp8nDufhu8BVokodik+1QNRprw5/mQ5Tom0lhcNANBDtBKI/E5ZgILK5aYXi9f33TLMONglrZRImeU19FI/sWbTp/FQYwMiMzS51OVwfC9qMzLJoPZ3tUYeqTvRGg4GYq1KQ54/6HkvAYXm0VsnKULkW67RYDMLenV3D8z8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 12:31:18PM +0800, Muchun Song wrote:
> vmemmap_populate_compound_pages() is no longer used outside
> radix_pgtable.c.
> 
> Make it static and drop the unused dev_pagemap argument from
> its only remaining caller to simplify the code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

