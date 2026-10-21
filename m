Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC5A606A324
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 07:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=BLrygvfM
Received: by kanga.kvack.org (Postfix)
	id 7CE096B0659; Wed, 21 Oct 2026 03:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77F116B065A; Wed, 21 Oct 2026 03:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E146B065B; Wed, 21 Oct 2026 03:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46F6F6B0659
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 03:46:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C830C40345
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:46:18 +0000 (UTC)
X-FDA: 85345850436.02.877F9B6
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5EEC9140005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:46:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BLrygvfM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792568777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UsgCJpn8EzeKkLQx/vx3qRMApsmab4c/NyjKdecWpLQ=;
	b=IwiZGTNBHhWMy0FUgrfPaVGk/MOag1LjPDKsMmGV4cXcZE9DdMG56B5H3GeSd8Znsqjmvk
	NS/p5VW+FL2To8FBB8MwkY3aL5zUI7Bqv5uOJwTF/bX/w4dHXtlUfjUKJQWVbadFLNiXfT
	r6s/vFOtOeO/TYenG8tCdwCQX0vp9ec=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BLrygvfM;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792568777;
	b=0lkQMkdk242+V9s6oOhNP2OB7qpIJxo1Mj6BmRDCLhGuBO2gkgbmxxc4RO8ZqTsTvdp3L+
	GfJ7mg8o8LIiyog9o7Si3vcahTOHryfIC0nMIAIJPPSVYj/YHuAq3joeDZ/pVFSkbdPJZW
	b1oXlb/Vs/8dQtPhe99UviF0fASvKok=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792568769; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UsgCJpn8EzeKkLQx/vx3qRMApsmab4c/NyjKdecWpLQ=;
	b=BLrygvfM/P0H/s6l5wlCrsdjotjcQjmZuoo/q5gVAYz8kevRa/E+V65l79YweNorkvDbRiZZ8QJN2XgGDDj8HJwA98f+zZvGQAbrThtGl82XCokSntz8DVPR2ufyOLXR3giGV7j3nYmWeRG7+ot2amxfOnEtp7D+4o2tcrXvj5Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDFhPZN_1792568765;
Received: from 30.74.144.135(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDFhPZN_1792568765 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 15:46:06 +0800
Message-ID: <6462de1a-b141-4f20-94a8-973708a71ba2@linux.alibaba.com>
Date: Wed, 21 Oct 2026 15:46:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
 <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
 <6660d3bb-3485-4c34-8734-3ea99df920f1@kernel.org>
 <02c9a968-92e2-49e2-bffc-74d264a5c911@linux.alibaba.com>
 <f7735584-e020-4ee1-8afb-2b5d580cfa49@kernel.org>
 <b1a9b500-0ddc-4791-9e1f-00087e367426@linux.alibaba.com>
 <938e215b-a2fd-4f1a-b4c5-e46b8af0f00b@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <938e215b-a2fd-4f1a-b4c5-e46b8af0f00b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EEC9140005
X-Stat-Signature: 6jjy93woz4486x6cndpca4ad8z6s6gop
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792568773-973606
X-HE-Meta: U2FsdGVkX19pwsqiEJmNA3zUEJF9HnQnvwFqFylPnV6akC7Nm5YrG05BqIrJICkh8npJOSylq1+vLtJcyONYlZHXvWA/G8KdjkZdbhuRLeNKyN5Scbbvi2Qjd7oZIwSVoQmSCXB9Ib56EGbJS9x2xxR+sXnxppdcx0kIGG6JZcyoZoczJjvbYoyFxF/GF/Dn+I4RU+988RNbi4317mWgSZvdVbaow+I/EDDdWPKJ//vDhlyJKEyvMb+z1r8qqQRvV+c+hJlvRPmporjCGvxOJEk/R99iyzp/MbziyT1+7lPhFrfubHQ2mRaSM7wsH4TpFJsZ1m7rjCDCEtgtl+6nMloMSoCpWHbBx6DC5kweyZXtEP2QKiaVb+NWdn8A+gGFeRsoJUNFpgWMFQ9ORrkvVIeoF6bIAuRYOMYssO8l4sLs1cAw/iGA1R0wtOLdbUkGiDMAqhsmgnlmO9x/Hapz9uZY+YX53BkWT+R/ePWp4nZvCds/U36SKxccAsIZ3hVX4MyqDYfWyc79givEf8lwG97p5mygC2LTaehwVNlCIv2JkSeUkVLaQKczeKDHo5gacZ1+YWpFS307HeLHsOb0Ad2RzPvcxAOm27JrlhB2YsVVjQ9yxrzuACbz41BSOFYzDvGnff5/Chz2vW4Zz3mv6wjQEGkgyfzJd9Ayk0bPQW2PgN9+Mo8eTSIAM7XMUg++1M8ouaeRQMWXzX/XgqqGDTxWDE3BBm/HaG9zVK9w83EumkVEozYtWyraWHQhiryXreyP09Hnj83s575dLDj/tcVgVLS7qCde2HF4/8B6D/XUvQhLnEiq87VMgPR4LYjFkX8SUp9G1oZ80/0ZveipgDsJfILKxpam5vMCoj0wg1k2wPhrVgJnH4zQMke2k3k8gSKd6SHG7K6S/4qid9N3t+SA3BdbbzU7ZHaY0HbrataH9NC4rmrQASOBMOGTk4T048uNAekA0wTVY4UZNG6
 gIfXonkm
 uuASwIa7aYYVoq27cRNYVi/5nSru8fA84H85o05UsM44heHKRlkMj77CpaExyvOKKTPvYKOgXXHsQwYjdfudowwLkc3LgUfBxkzNemVr1GtI5iCvtSRUPk+kM8hNc/4uw1K3uMy2uUrtPvERkyvno1LVRo4pD472+kE7qxJ53YwLCNWDE7pSF3HQ1KbS+ZwcCYu1Ob8T24JxsJfYFSGjqCqONLUKyk0tYVyfzl4aSoSdY3DstYksbL5iJS0ECKZKL456DnOPylAQFPvpxtgVjs7wNCHbag04bJSrI14W+/BqxgbeJBFfm7cq/l/bMLjy2lPgck4PBDsT0vLvnt3rU/UPYVecQEZAzG59R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/20/26 4:36 PM, David Hildenbrand (Arm) wrote:
>>>>                   if (pmd_none(*pmd)) {
>>>> +                       if (details && details->single_folio)
>>>> +                               sync_with_folio_pmd_zap(tlb->mm, pmd);
>>>>                           addr = next;
>>>>                           continue;
>>>>                   }
>>>
>>> We do have another sync_with_folio_pmd_zap() user in page_vma_mapped_walk(),
>>> does that one need care as well?
>>
>> Good point. But I don't want to add page_vma_mapped_walk() changes into this fix
>> patch. I need to analyze all callers of page_vma_mapped_walk() and the potential
>> races. I'll look into whether it should be changed in a follow-up patch.
> 
> Yes, please have a look. I am 99.9% sure that we face the exact same issue there
> as well.

Sure. Add it to my TODO list.

BTW, could you take a look at my reply to your concern about v3 when you 
feel free? Thanks.

https://lore.kernel.org/all/179c26ed-1764-4e5b-a7ee-047ddabbfea1@linux.alibaba.com/

