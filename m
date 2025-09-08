Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2541BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8285F8E0011; Mon,  8 Sep 2025 07:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFC58E0001; Mon,  8 Sep 2025 07:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73CEB8E0011; Mon,  8 Sep 2025 07:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63DC48E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:33:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30B1C11B25B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:33:12 +0000 (UTC)
X-FDA: 83865871824.01.153CD9F
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2756DC000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:33:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kRT2hkhn;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757331190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vn4jY7Xjd2fdDYa7yxhH+NTKe/jBHKzgZ5tbZmQYF4k=;
	b=7eWwppmkZSnLMxpTKL7m5ci13QBMoYfmhKRd8Y7kt8ZTu35QfzVahQql4EECLe58n2u+pd
	lUVn4VRHPXjPUNf5AdoLAeZfMYY9XNB9wrYDiQGf1zMwhB5c9bvxRZKvT70pEzTSy8dfwu
	IDcIbZXdLW1BxpKc9znRcoatPWrWGBc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kRT2hkhn;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757331190; a=rsa-sha256;
	cv=none;
	b=VU/A2LDEd8cfU58CO80seu/o818TEzIeFm2Ke4KExZOzLcFIRgmzFo3ThKjw7H2PB52Yz1
	ZoNfaUFPVZnsjDW/mCnezYJ7W8Iz1N5OT0ogge9ze5sphdfC4FNbxVlcq518P50Lj75z1r
	xHrhbxtjjODpxQPQWXq8IDZXyVBD51k=
Message-ID: <b92419d3-c8ae-47b0-b9f2-0c0c46057cf9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757331188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vn4jY7Xjd2fdDYa7yxhH+NTKe/jBHKzgZ5tbZmQYF4k=;
	b=kRT2hkhnbQKFtxIl9NrbFTgJXv0leQwOgL9BNmlffAtJSdBHL+TPh+NyWFYcX9BpGYC6LW
	uyhOlGipnNbSwVgRBnVr6+n5N4iJvakW+FtPX9EpP+WnND8XdZbd9p9XmuK+xLiJcBlEe1
	I29E+1GW0ycC0Q3vOwIFKohpFa8gafA=
Date: Mon, 8 Sep 2025 19:32:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm: skip mlocked THPs that are underused early in
 deferred_split_scan()
Content-Language: en-US
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@redhat.com, Liam.Howlett@oracle.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 usamaarif642@gmail.com, ziy@nvidia.com
References: <20250908090741.61519-1-lance.yang@linux.dev>
 <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <niywtremc5kfhs3lenmfxvbiiizyexnaw3m25twedmzovfoeno@lk2o46tfdklk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: cisi73wp5snh7kypxgp5o6w5s8hx8r6p
X-Rspam-User: 
X-Rspamd-Queue-Id: 2756DC000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1757331189-803791
X-HE-Meta: U2FsdGVkX1+GriRlUCSdonz/o0D/bK9xo8BsbNjtQsIgWm0Hs5X/yj3T0FJMguADTNpAmB/kezCmQ361fY5U7xjiEi6nv8DKtWG+9ohtQnPOegLeOeesKtONyCyWbNgvAtyaZIZq0uGBiuOyCpIjFC290r9Vi7sd/a/2C5U8aPOaE4qbDFB69JtL9SebxYyCEkWYZ3xTm1o5ngbpek0b5h8eiAupD9dLjgdoDdvUXHV60sXGiLrcMfBcNGUe5WwhpXuTs0gUlwnpInbYm2TgUVVa4TRFMnE4uk9dOefeCmSHvVThaOP6/OfOvYwZkFbRUqvBxEcoPm32hf31mumR9YqkuzlYpZXe+A4SWQBipkv4urLrMwWhh+6jCu6F2j76Wn203P7e1+eg1YqKu9AsKsDi6daJkJqht9A+mKJmGS3LuWPgQ33rnI6mMe9sdNAxmMerRkKHIqqDE0wmO13SVZhiUGLlCxHtcULkz0QTvi4UO10sEErLg3c55MRzFdT0uXyUVwATzxYiAVw+r3vdVHByMDgXqQt8/tnur32W/u5SLoaCpqW9wLZe2pw3bpXxjNl0U2N4JDq9oDnaGB969tAuWfZ0iWHsgzoOtoOPmWdp54qMrK8S+ThFgcMZXltsKII9mAEqICy/uE4bgb5KmHMnyRqrsbNqXcYKDTk1pdVRBprypXWcoyOlcN2rp5whu9yaUBRLypL5rLv89foeDrTp2CbnBMXAmOSMkB96hGQcbMJVk1MDeb0amdRf/8TNUdUl69w32SX6/oBXVYXCWpq95jjNyabMVT1AAlT4sZGh58viL/Uv05ceGC8CKmEosnX3aI0sYqVeTBzuInOwSB92sKWO61TK/Qh2QTXve4mKxPIkWFa548E5xVO2+T6QA30Xbg5EY8oqd9fnIkHvJyoBVjLq8eN8PLxmBkSbnidIvWNXrbpg1p4Yi6CGqq11VgxIaZkN9E5CAz0Io/H
 Jf0ZUDlE
 1nQgSx3w+wxu44YMLeM0q7EF5dHxsUPfZF8I+QtLQ0B4R5oFZEQhNxduFGsD/uwdhO/9IEGGR8scv1fsrWrVr852yFBihPGcF7bx+bO93r4wTdTXjPdj43ES+OKQNaU/cL9KzPxwaV9TaRQPdGnNXc4lQHpwJjmVtRdJaOA7KC7K6FNP4dvjhkvOyCHlCNEbYJ1MZPRYoh0lhwfbMxbA20b+1kdhRPs+vjfUfMaf9jIAnOEI+NpncPB3FlJtF9npuECCcEEKL+TosgvBWlj4hnB0DlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 18:38, Kiryl Shutsemau wrote:
> On Mon, Sep 08, 2025 at 05:07:41PM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When we stumble over a fully-mapped mlocked THP in the deferred shrinker,
>> it does not make sense to try to detect whether it is underused, because
>> try_to_map_unused_to_zeropage(), called while splitting the folio, will not
>> actually replace any zeroed pages by the shared zeropage.
> 
> It makes me think, does KSM follows the same logic as
> try_to_map_unused_to_zeropage()?
> 
> I cannot immediately find what prevents KSM from replacing zeroed mlocked
> folio with ZERO_PAGE().
> 
> Hm?

Good catch!

Surprisingly, my test shows that KSM is indeed able to replace a zeroed
mlocked THP with ZERO_PAGE(). And MADV_MERGEABLE allows a VMA to be marked
as mergeable even if it's already locked(VM_LOCKED) ...


