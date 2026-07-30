Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C648C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:48:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B1F6B0088; Thu, 30 Jul 2026 08:48:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CC696B008A; Thu, 30 Jul 2026 08:48:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB8E6B0098; Thu, 30 Jul 2026 08:48:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05FA46B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:48:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83F1880139
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:48:00 +0000 (UTC)
X-FDA: 85045420320.30.8817A69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B26E340009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:47:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o09DWJ22;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785415678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j9YnKQEuNyY3l6FqCLIt8DO3maEUsuk3WKolE6H8NO8=;
	b=1kkoAp550NpTVFmuhD1gF7XtqTWgtyGB+KmWtGBy3vjwt1elzYIIdttbzyHvl4VSUZ1BDQ
	YEkalVwA3KdsCjHw5vRyi/91evA8kUHN5mNrIWL5o+42C4Odzz3B1I1HLOIWS9glz2RPN2
	e/BvFlv0ru4GCbkU/wfKP2rJZr3ntx4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785415678;
	b=bnJHuaMxTS+UHgGDELafJCVJ2VYbiQ8XPZOCOmHUQHQXaxbHn26I5MIG50qEyXcvzltpEY
	aMLomP4y5Q0WTl0HOj9LePuAaMJZNXWycVY8dEj6j4Dd3MS9tOXghDes3DdvnRNmb4OFdi
	yYlcXISmv+RoE5y2wXVVqSCY2bhMReI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o09DWJ22;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9EC943948;
	Thu, 30 Jul 2026 12:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3CE1F000E9;
	Thu, 30 Jul 2026 12:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785415677;
	bh=j9YnKQEuNyY3l6FqCLIt8DO3maEUsuk3WKolE6H8NO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o09DWJ22Hv5sHflnQ1KniaNaofyCHe2ZxHKC48xizG9lN7TljgWIskyagAIXb1Bfl
	 YC9oZaXML51B5Vh19zrnY46RxqekLzZB4LTnj6+19iR+CcSZYvaN6l0MYN5QrMBoL0
	 Tsynq4042P+2BCJphiI9H6z36IdoXTreK7b2+694Yoy0yC5oG/THF7LA2lHYPZijgK
	 NtH7OX5WqDi9hbgbxupM4wvzpFZ8o9Ke7Re+gD+O0FPj8ur9kU52Ea+s0kVMDYxBX7
	 IlXGBs6CPlA8n3BoN/PgXPP0cz7aR9WQH1WlF/ZgNei3MFZE6v5c3FOlvWQlbvfz2J
	 /x/efvJVmWLpQ==
Message-ID: <86119f7f-bd70-428e-a6e0-eea7cc907bbe@kernel.org>
Date: Thu, 30 Jul 2026 14:47:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/migrate_device: Clear stale mapping after freeing
 swapcache
To: "Yadav, Arvind" <arvind.yadav@intel.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, ziy@nvidia.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 balbirs@nvidia.com
References: <20260728062832.1107127-1-arvind.yadav@intel.com>
 <8d50f94b-6d95-4967-aa1f-2c14333ffd85@kernel.org>
 <d2480581-52b5-445b-b56d-af1bb9d71608@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d2480581-52b5-445b-b56d-af1bb9d71608@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B26E340009
X-Stat-Signature: 4xz8fh7dgqdygw9darqqiny9md3myi4e
X-HE-Tag: 1785415678-491447
X-HE-Meta: U2FsdGVkX18sqY5Lrr+klueAe9rHGWGNsmGcx9SG/71hO1GsazDQpIkCW/NJBQxD8PeGIsb1WMHEGCssEyjhJUCrARNspGXIsNJItgEMuSUuJtXT2/svXeosAQCP0IenbxUM68cI6sjwqUo1du6advM2vwgMxLLfISOrHv2JoMR7aqpVnIPZhV7U1IuNT8dJ9DpDX5xqxEWminJlyU/nHasgNrG8IAv/RiK2VjTUILLIJ+10zfpCypSYdC/Thn+87Mws7FY1reWSxC2hNYF5GM9metOuZIMIl6B3G2UX5WRiS8ev4gLQbHOMTSzw3T873rRDcMV3skcpCq/An5hdaLUDvloKiWbzTnlmSq9L87PtYuE/1QBhZcVx5q7OSoIdwVYJphtXveoUjTIUwAHEe21NKrVvwzdsP3w2TtC/xbId5JFm0WTAAngVJlFy67n88zzIheD/K8f/Y/CMjM8X0D/bSvrL4WfKkq4Tgqs9rVjAc09V8D0Hwc1kFACAmbWL/+cKMhLgSibMtsJstcGwzW8xGLM30/Hi4vGZQFrKz4Qc/n9AzdLxx2SJ6mzwDLLC+w6f9AqNCKM9/5VN7+ZeaUCzVVJvhwAY0xfsa5KP63JW2/VAKKz501gx7M0TtIB4lFpKTxXNuPLUDXktnRiKz8hwz/4QhLJIMeEj/wcwDyEQc6sJA4s+cuTkEb69MeFjZ83K5+q3B5IgiwjVfRIHCweHrf/8t6B9fImW9GC7Les5i6YMLTx+snyEZAxHWvCOJE0UIGkDc8Fl+NWQpW7apEvAZYVObkJVxzw4FmSqzC+Oj64USJr1+PtOJDeNb/moakMRZYffezEZmIQcZMGQlRMHeznYvdmf+mcZBLSuB7+J3bW7qUf1z2Ey6cYwYjovO1CbqPsLASZY13Uv3BF85iJy8RRlMqpa/+lZUk9c+PqUlTYS7spnL+Qk9Xe+HzgKuuGvhIU+DWYVKlelyzr
 9ipS9Bjw
 ZRVcoLemJTMQqueGwu4BmAUJjPozgxSxOYymIYSjWaeOo1ofifluC9ASRtabhpa9RAN5PeY2ax1ibb9uDrCH62Y8aEnH8NZo43Myh/pUfvaibHUJHkTLaY8ET6qKkBnA2u8Y3s95MIwJ8CvoxNbRnMW9r+g32Y0EwwcV1M4YDZaS1U4hlrHWdU+of8jFO+MwdUwaMPGZm5e7p6KHT7BRPAFIWja3rsTNIPBDIaeV8RssykfpdXITr3msk48JippbiVMqOZOErStoleRiqcGPqYAQaDKiAhs42QuVPusjkl3OrxAS0OKyEpjY9UiYfa175yiKPr0t+nIYm6vF/1myrmFSB/VM3A8GELUxQiqZ8aek0dKMkNY0lVvqFHFX65/GcsfaV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>> While this looks good, I do wonder why do we have to supply the mapping here
>> at all?
>>
>> Is there a path where we call folio_migrate_mapping() and the old folio (folio)
>> does no longer have the right mapping attached?
>>
>> It would be a lot less error prone if the function would just obtain the mapping
>> from the old folio.
> 
> 
> Agreed. I will make folio_migrate_mapping() obtain the mapping from the source
> folio and update its in-tree callers. Since this changes an exported helper, I
> will send it as a separate patch in v5.

I think it would be good to understand why we currently pass in the folio: was
there ever a reason to do so? Or why do we pass in something that can just
easily be had from the source folio?

But note that that should be a follow-up cleanup to the fix.

-- 
Cheers,

David

