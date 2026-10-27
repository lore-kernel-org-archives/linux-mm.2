Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E693D606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AHb7c9jI
Received: by kanga.kvack.org (Postfix)
	id B49796B05B4; Mon, 26 Oct 2026 22:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA3E6B05B5; Mon, 26 Oct 2026 22:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1D76B05B6; Mon, 26 Oct 2026 22:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A6886B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:00:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E852A1A08DB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:00:40 +0000 (UTC)
X-FDA: 85366752240.28.3542E84
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf02.hostedemail.com (Postfix) with ESMTP id BF6B680009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:00:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AHb7c9jI;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793066439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61EMy3PxdhOnTqiU4a11IMUTpSK9C5NCBlrut8+F5ww=;
	b=7KminCe2W+OBUMcFmCnCTzrvnzWTrBMf7fhVsImdgbxBZ4ATE8zUoHfpvRbF/CARNV0dm6
	N3k6eUdNsI0qt3zh/a35A/n5MVvFfHOiBgWx2noyICaO0dGJifeqaR50J0qNXKJc14EYtX
	pRTA3yB2o4S/+Nac5kn4EyQKU81JBqg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AHb7c9jI;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793066439;
	b=Ktm0036r5bsrRk7Dzv/RahH2vkiA6CYGIqpc/ZictfClVY7D4CR+Uz/FqNBqR94r9MABxF
	MWlo39rhCku9n/9XjKTLd9JJFkPyqy+X3OyFIPWNTTgMPLRwY2jQ07ZkfXAr3enr/rYn+U
	1XNlIA3Ekkox+W83ckTpRsrz2KgloKc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9hGd5bdxaApA8fOAUJci0gnkMmtc4JoeFUWrum7neb0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793066437; v=1; x=1793671237;
 b=AHb7c9jI6fJaZTY9DEFHKvuiPzxN1jQk5MX1ut1uLonBxIqyB3ybx8rUmj7vGkp+pOAFl0d+
 ihP2UjRABao05oZ3Jkc7m+LWvtx70ei/+pAgwh/Z1SwOXY0UmFmo3vSGYeIAP7qz8QMLIPDNq2W
 0v+kuUkUzi42k3CyFAGr2DP4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b00388d84bf8f0cd;
	Tue, 27 Oct 2026 02:00:35 +0000
X-Mizu-Trace-ID: b00388d84bf8f0cd
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: joannelkoong@gmail.com,
	sashiko-bot@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3 1/3] mm/huge_memory: scale thp_underused() to the folio size
Date: Tue, 27 Oct 2026 10:00:28 +0800
Message-ID: <20261027020028.46469-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <sashiko-outbox-183933@kernel.org>
References: <sashiko-outbox-183933@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF6B680009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ka5egmbiu3mw56jehh1mh1aziyt4cbat
X-HE-Tag: 1793066438-687573
X-HE-Meta: U2FsdGVkX18xX4ipnPyxXsccPQ2mvI+i+9OMzsQZpIcYJbLc/HVCS3Rk76rTPKAkFuNvTN2HM2lgyR8cN7tyQdTAl06BpJGpMo2u2YzlNd0tlVyjkRp9/wIwvVhHF+zf/OEoKqXRDWH2wxG4nGM92ECEz/l4rgQgq2EgSlwkqIZPzl7Cvb0BYDKpvh1MP7I0oGW+QRyyqCxW4Ml2KuWcqWLVZrUYcqTM3/LgYWBeRXAKmW34adFZpPazpI1eMQZQZzBD89pHt486Nk0AAaVdXILoiFQI65zZKVkU/IgwXb0uJ2A3uXXv72spDlE804b0mPnQLeZbqCSOCBCf8cf2Vf/bkJadyjuMiD6yf15nJWYFsQtZJVUjIwt/4hpwZ5mgadBAcrkn3CquPVAdAUwUfL4OdLLNbf88WCrKAYnizTPNNy+iLcoi8VdQBJigbKIDoyzX9Y0iDYZef3s20x+dYe55Mw5L68prHwirZ5QT7hoGwaBLG2aI0vzQez2ifWA+B6H2XmTGun5rpccXmB3hi8gTxgo1XtA/miJSxVC4u8gFEqSYXUHcppKuQUv3ZSN/QRO4n1MgXUPF3mM73869wRibRG+x7KBdhTHsdaihufp7p9ymbIft4cPkQPyCZv07aZflsbk6ZYYcDsSCXcrAIT81cubVzBcsL2px1rAx7cI1HQ+HuFiZ2lWMgBYLkMjmfLB1gyIw67ioHY1Qqi6+fglJqryjLYAl5QNAMCgPe5RwLhqEoKNWLMmotRiPKrIS31TorucqrVq3KUGPGK2Dq9pf2A8UaCbUUwbo+u5j8oGE/vqRWZa7UkxClvJSpBCX08AUaKenR824aF86OQE8U5JRC7lOF/TXFqKTL2NWzGnshXl25SnB37R44kPHqyIabta1X0hlzaLdkXF3/WInxOy7Caam6EhvLzKNAlO4GRxsM17DIhRePiDP9bi1p08tei4LX2vCpIG44txCh4o
 BdjC5axb
 VKZHCAd8lAeoVSpzPQouwPhZilHVFAwEQCdBZ2L9NuaVbZDg9ul2/2rattAAWEJcfKaO75e5g1Z9W59xaNzo52pF+7Gjy4f/LszugjzuQogRXcia6ssGXMpk9b+UWIyWFtQ17eWZvBuEQc+7UzBoLcb2Oe/qxmQQFM0HE9Mk04HD8SOij89bZ7JFZvg78nStTTjgPUue/XskbRgtxOcd5lrU+kTyEfQCrOppjZjMoTGHMMsgtm0ZngOzjx3pI7Bx/wli86iAuSZUzCi28zXsN74Bk8dIGuPrPwDSVX7mdVxOrKI8jJNG7cAEgXaVvTU5DUyf8E3u48cPCwIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 24, 2026 at 11:01:50PM +0000, sashiko-bot@kernel.org wrote:
>Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>- [Medium] mm/huge_memory: wrong rounding in thp_underused() max_ptes_none scaling
>--
>
>commit 56eb0cfccba9e5e4276f2a8250815399987bc848
>Author: Joanne Koong <joannelkoong@gmail.com>
>
>mm/huge_memory: scale thp_underused() to the folio size
>
>This commit updates thp_underused() to scale khugepaged_max_ptes_none
>proportionally to the number of pages in the folio rather than assuming
>the folio has HPAGE_PMD_NR pages.
>
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index bd44d58e86845..218259940f24d 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4613,25 +4613,35 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>  
>>  static bool thp_underused(struct folio *folio)
>>  {
>> -	int num_zero_pages = 0, num_filled_pages = 0;
>> -	int i;
>> +	const unsigned long nr_pages = folio_nr_pages(folio);
>> +	unsigned long num_zero_pages = 0, num_filled_pages = 0;
>> +	unsigned long max_ptes_none = khugepaged_max_ptes_none;
>> +	unsigned long i;
>>  
>> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
>> +	if (max_ptes_none == HPAGE_PMD_NR - 1)
>>  		return false;
>>  
>>  	if (folio_contain_hwpoisoned_page(folio))
>>  		return false;
>>  
>> -	for (i = 0; i < folio_nr_pages(folio); i++) {
>> +	/*
>> +	 * khugepaged_max_ptes_none is a number of pages out of HPAGE_PMD_NR.
>> +	 * Scale it to this folio's size (rounding up so that the folio is never
>> +	 * split when fewer than the configured fraction of its pages are
>> +	 * zero-filled).
>> +	 */
>> +	max_ptes_none = DIV_ROUND_UP(max_ptes_none * nr_pages, HPAGE_PMD_NR);
>> +
>> +	for (i = 0; i < nr_pages; i++) {
>>  		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
>> -			if (++num_zero_pages > khugepaged_max_ptes_none)
>> +			if (++num_zero_pages > max_ptes_none)
>>  				return true;
>
>[Severity: Medium]
>Should max_ptes_none in thp_underused() be scaled with truncating integer
>division rather than DIV_ROUND_UP()?

Agreed, we already use a strict > comparison, so truncating division
is enough here.

[...]

Cheers, Lance

