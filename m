Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704B7606A338
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=KMKXHJm/
Received: by kanga.kvack.org (Postfix)
	id 974A06B05B5; Sun,  1 Nov 2026 02:08:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94BA66B05B6; Sun,  1 Nov 2026 02:08:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8616E6B05B7; Sun,  1 Nov 2026 02:08:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7C56B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:08:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C8A1114086A
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:08:42 +0000 (UTC)
X-FDA: 85385672484.05.08F7CDD
Received: from mta1.migadu.com (out-51.mta1.migadu.com [95.215.58.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id ABFDB140005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:08:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KMKXHJm/";
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793516921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkyFPxHdMr8VD/svuO9SwwzAL9XDCMj3MbQCES3rGok=;
	b=bL+8raGK93IYga6m3aQpKpsqO1sTr/zuFnGwjDYEFImVoEcFZ1zAaEYwMTq5MvEFFPAupE
	fjUzoNT02d+v+7EMFfW2yhXvORBazk4gdMruTSQ4yUJsFympNWekXWTd9FsE12hwZFLFaD
	dzdhdIgEtH0nmymTKp7EHNfVA7aT8DI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793516921;
	b=CRA2YF/VMPlwmRX/Fgw163S56ChbsNmKUhOzJeL5wOWj75w7RI4vr3R5ZU9XW/Pm7V5pV6
	vUnwHkSuVYXdKrlmkySWaNE4kWDXn0oAhjxScPhDF+TELjtVx5yB3JayGzAmO0WwqkU0TG
	iwZ53+JgNEBNbtcfI+PznxROMiuVNy4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KMKXHJm/";
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.51 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=237fh+P6+tsOas/EETdM8oy9lOZa3289Iwq/LFSdwHQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793516919; v=1; x=1794121719;
 b=KMKXHJm/a59z+4diB0DgMxWfGBs9ql+WELEuvIAPDc32JjEjbPIoMdYHw9IOo0jSgMC2TldQ
 jKlIZCuMGA0JHrN3qmur6hig6fOYl45r8ZnEWhhBOY4HCA4VzYAv23ov4484M5r8Gmhum0hfPjs
 hCpeY1g1KUV1GdrCxva5Q6F8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 64230bdbd9a72431;
	Sun, 01 Nov 2026 07:08:39 +0000
X-Mizu-Trace-ID: 64230bdbd9a72431
X-Migadu-Flow: FLOW_OUT
Message-ID: <2f429ff5-76bf-48e4-b6ac-3db0b9bac498@linux.dev>
Date: Sun, 1 Nov 2026 15:08:32 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/12] mm: hugetlb_vmemmap: make vmemmap optimization
 folio-oriented
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, James Houghton
 <jthoughton@google.com>, David Hildenbrand <david@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <20261020115824.823278-8-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261020115824.823278-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ABFDB140005
X-Stat-Signature: wtagb4cha4q88zab56u5cedxji93q6oe
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793516920-602337
X-HE-Meta: U2FsdGVkX19RfxkbSFhmSlRqXNXa5/YttvbSN8swGREZOyGHJruFVviY/k4wQQp8kxrA572vESYBEW+z5jfYLvsATjjY/gchlwX0RS0CW3ooFHjBuOa5/6Y/bTCFhoPcg6RJJVYkW9aUE5giJeXFde49V7zkUGDCwPCQFYXrN0mLDz7IbhOxT1vWYuL4Xq1O9sySFg//Y149u0wcT4gxuXVfhvxuSgsHM1jlTe/17vjKEXYoJA0FzfzgHBwixCka/Rpa727lF3s5PE1r3APQAyV959oLOCEU0WSTdor7XGt4eJdtTA107lBrd9B7uA+QfmLQR3vaSPUgA6UfYiaKXIpdGEjmsQzNIhTbEASBhKeOaFBXgK7ldj4k3nCClcejW+lP7SwvZLSq5yE3kuko+T/kGA3AgP6bKA2SW2ktCuGPnNDJLutvst0letnUDA/zvncL23ND4AWx7FQtcmYoSy4BSfYmgfSOaP/S+KcAFqnQSc7c2VEA7YBXKJq3r1r5fknw1AzVKhoxEPBGoYOCZJhFBzSwQPX7Y66gTCrzJC2PHqyVtX2SALKtA3yGdpRKSyLX1zThD9dQbR4HKZuVo1WOKjojnkrGjuw3mbN6Lwfu5fpV5tJwm7I0q3+hmPnDC4Cqb0aMngw+lcCEEp3dLduLjaYWr0FWqb0+b5rYC1ayJ/vgqEgFjYJeEhY7RAt6lPEFOK0gwYpclhW8+1l7BsUmY45L4f8VEfh9/4gdAr/Ec8UpALfFidG+mHNKpy8FsHPaYGwb9ztNFg/xBP4rr7cXaiRwodSCYNzwibAWecpXMys6DKTmb+Xd9TrGPxv6QbodwpznH1gy3LTQyDnf5J5/45j6gnv8QTA5D7zwdtUCC9ycPVNYvGnIFez8hzp+FDkUFb17arW0bdU2cWM88o+UgBG4TDI4JPnb4QFqFprOxlbl50oHRettXBA6KzN3C1IWY7sCr6RzS5Sc/v8
 N24FLMbh
 kO+Y1bnMu7buc0NTEHsYY2hNtMwqMSaF2FC0SzthEMxJo0vZXe8h1IDrZXyK+Up8Ljs36lAQBMZOWw8dV9Br9dgyDh+lBqooWOnZ5eivWok0v6/SzxyR7aPqUXq2hfN1a6kU1aay7QOj4ElwlM1XlBN6VZ6DHCeh8pyYPLSHZeccZoRp8KYNI3Hmf0sXwRsuBf1QHDLAb/TjbQ5pb7uD6CAedqGfaJgxs9x03MWX+dVBFsrXbykxjhAAuHJdZNdOG48P6OMUcvdQe365zqxQCBaXepsq4WUhkCY1BZNEwMv6Rxj4Ecq4C10tRBHGuqcOZjOCQ093V7PFaKaUsVBN+VOZgEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 7:58 PM, Muchun Song wrote:
> Vmemmap optimization operates on one folio at a time, but the current
> interface exposes a raw address range and requires the HugeTLB caller to
> prepare part of the operation.  This splits the common mechanism across
> layers and obscures its natural unit of work.
> 
> Make the folio the unit of vmemmap optimization and move the common
> mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific]

This makes the interface much more solid. Nice cleanup!

> eligibility and state in the caller while making the remapping code
> applicable to any eligible folio.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/hugetlb_vmemmap.c | 67 ++++++++++++++++++++------------------------
>   1 file changed, 31 insertions(+), 36 deletions(-)
> 

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


