Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C880BC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D09BA6B00A9; Wed, 19 Aug 2026 03:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1346B00AA; Wed, 19 Aug 2026 03:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF7186B00AB; Wed, 19 Aug 2026 03:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4416B00A9
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:57:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F625A049E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:57:25 +0000 (UTC)
X-FDA: 85117264050.11.8D3AF39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4F6CF40005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:57:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XclZTENh;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787126243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MI6YQwP4SWJEe9zoMRqOZtzYnGrY3Rx8FpYxOJDFbeM=;
	b=6i4Id7RyjRYJ/RbATfEY4B3mo2gTgiwsQIjRX9+heUmG06EI36iTF+SBgBQkFWn2j469f/
	ACVsVqGAfLDLRkuZkGm5RV0J2CIiFZGwlRNzFZ+hfaAHp1AqkHhWySii5mPeegvQXSuIaN
	KBYH/QKSyv69J9hf89R3x7/uenZdU2U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XclZTENh;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787126243;
	b=gTAMmhTyXbUftAvdDmkFtiDhn5MZCJBnkRygVW/cs2Pr32Z5DxvYyhsWiVfL0ixg5xehWc
	8vmX9XNIJIScJH6jWkn6Ec5PC3W82qAq4ODmUcMIiXWloYb18i81x+i312GZ4zM5sCbeI8
	Ng3Y359rbWjJRmePHCJryEAiKkvmEdU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28DCD41AD7;
	Wed, 19 Aug 2026 07:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F67F1F000E9;
	Wed, 19 Aug 2026 07:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787126242;
	bh=MI6YQwP4SWJEe9zoMRqOZtzYnGrY3Rx8FpYxOJDFbeM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XclZTENhz4WuwaHYEbQt4QCMy8qz6n8allqXp109CpNeGNQuRxbrm2KAesDgES/Gm
	 HU8Qmct9zfEMFub3+Rc9FHj8GhivKIbgCpzmRKiLvOGbsTHTNOcDq6g2J9iCVolevJ
	 iyowr83xc3X2mSv0NU3ksdaUJE1UfPwjAKXy2q8YU8mtrW2ujRFrL4r9epR28CTVZ9
	 b7fDFWpRQLqqQriqnckobQ04hyOQs9j4R3Nrl7MOJipq8Jq5hb7HzhBQMKxGT8GfOO
	 oIM0AfINe6xqwdqpbbx8l1E422TJwoW0FwuIUPB0uv/CDbqWIewiJM9+LlB4vKzf39
	 TUy5KR9OXVhPw==
Message-ID: <41da530d-c3fb-471a-90ba-ab4d9b58829f@kernel.org>
Date: Wed, 19 Aug 2026 09:57:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/57] mm: add pte_folio()
To: Rik van Riel <riel@surriel.com>, Kiryl Shutsemau <kirill@shutemov.name>,
 akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com,
 usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de,
 rostedt@goodmis.org, mhiramat@kernel.org,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-2-kirill@shutemov.name>
 <905d08d102e56a026a5ad69573c507d2d9becc37.camel@surriel.com>
 <c05f7bfb-c84b-4c36-8091-5ec7721a658b@kernel.org>
 <edcebef940c262a83421666de67e8a07ca93e85d.camel@surriel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <edcebef940c262a83421666de67e8a07ca93e85d.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7s59xpz93muujf51u6pm8pbzdmnp7ybc
X-Rspamd-Queue-Id: 4F6CF40005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787126243-488008
X-HE-Meta: U2FsdGVkX18W/YZK4sgJ7N67UMlATSQQ0GjGL+um/A4J4seok1QQzkbDwjU25Weu3jByEd/+JL1lxi+Q1CZZevgC5ZkDIL5FA5ijWGhjfV1GVSMmdRvftgjz9qjFx681oPwunrLz0cWG7QJMfp2TRZbxRAwlP9BGmLqngb4AQgRZvHBGbs4UjJ0psyUSynY8sjkwNTZonfcqrukUVDRMeY8c8DEgy3wE7jIsWpD02Z3Eq0eZh5rt+7YE8m5fJCOBY8yqGaRNdewQkmh2rjyK379JvKKnVbul6OPhA6+WQNm813gamsE+p/rmDCwnO54oaAzYg0Gvcy0RaR9SYoCiwQD8Po98wv5bX6e25+EOowm/jWuWIoOSBPKzUNLpwT7uVe+04op2NWMnowojpvIUhzP47aFMXlBNE9HgUiTHu+bGHrelXZVuAs5QTjjfC9c44rD0q8ovN99LJGXb6HFvrUykAKut3cqRZvbmDDjm0mNmcE2d9fnwhiUjvVpQFXYn34X7FZpTit6exWaHoyCZoCOeN65OPIyZD1lSYqUnCaEk4ww6CXlBbn2F9HMSTK7TZDRoipE6cLPRBMSBKPdPVLgRrmoZAuUhP8ruqXOUemQyOTJmiOI6siPLn2gS1YGgcRZg25cSI+SWcUxZMGP89OB06W/+uOqBNukLhQdKIBxYnlBsitVxdsVdbk16c96zMtsrBvLVNGnf2lDegB0BNBxVIUwn3tH3JTV5dqli82MjE3TkQS3KTuBAwsN+zHOUcRy9vI1xidmX5XJpi3pb2oqbYPReGZyFmxFfsTLm3LEVwZGw2dxJUsN3m2OckACZbt2Wgcu3rZtPX1NpMRBGVEGSwFXE0ftr8cE4R7nokftRa/zw9wBmNgCOoqlOBqvcvYahvEqvACkgrODzr8pEklVKSLF1CSOd4g9UjWHRi4fX9ZwfHNasOkPQLZKoh96Hu9AX0Vz6WmWrjUjfV0S
 Lb7UBn58
 YYdqwY0OimjrjIdb2bTzC8GMCcouqSuA4ERcidflB/oEYIhu2EFC5wxAcbS/S/+s9mIgEOVv6rk5xhto+4IwUxyUmtFJ/EFgqU6KCnxKumiw16Rbk6BB8VoBkrxnaE+DZ/29FxL9rgJ1POU2ayNRIR3uyXKbt1ox6MrXKduQExTZbEaM5SdUywhkKGjDSBP9/gCBul1Yg9EKIEPRIs2+axy6K/hSx4yu5rMGRQOVC+J4abIH/cDaD1POTFKhH1CHadkP8/JZXMn/nRf4Vu42fj8dbbGS8bP8qpS3L++7/CBdpOqZdqdAWlR1UMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 22:04, Rik van Riel wrote:
> On Tue, 2026-08-18 at 20:13 +0200, David Hildenbrand (Arm) wrote:
>> On 8/18/26 18:38, Rik van Riel wrote:
>>>
>>> Oh nice, this could clean up some things in the
>>> get_user_pages code too, when we get around to
>>> tech debt there.
>>
>> We really need the page in GUP code ...
> 
> Ugh, indeed. COW can create "holes" in the middle of
> a large folio, so even __access_remote_vm() will
> continue to need pages.
> 
> I guess we'll continue to look up both page and
> folio in that code, then :/
> 

Yeah, and it will be more fun once we decouple pages from folios, because then a
page_folio() will be allowed to fail.

(more GUP work, including in GUP users, is required to support that)

-- 
Cheers,

David

