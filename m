Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11C1BC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0186B00B1; Wed,  9 Sep 2026 10:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7056B00B2; Wed,  9 Sep 2026 10:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060176B00B3; Wed,  9 Sep 2026 10:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D90966B00B1
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:10:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3299EA3F58
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:10:21 +0000 (UTC)
X-FDA: 85194408642.23.227EE00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5B7891A000E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:10:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBABSYKc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788963019;
	b=euNjItWc14i/FalT83HoBWzzew/SZg/xfkDG1fPxOEFJsWVh/T89OmAnspypeoaQ3Qbr+G
	w51wZqWR+Vrh4KNjjlD5gRaGbB4KijESHxm0z61TXWLjqsoeJkaXZuCzvPM2gTG9TBcIjd
	ebRR3jciRoSeNGE524Wph1PRtRr5KQc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nBABSYKc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788963019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOXZ86V7gEk1w7Bapk1GcuFyX4Hl3hOcDoOjdyQuqEY=;
	b=TANZMwgPPC3oqKBg/kk/yqIp45oKit2XCmVRNIeKVDRpVnpWQo0vm5caXpHWjApe6p7ZE0
	Irusxp3JTlm5DBhvo0WmJKVXa037Qkx+Z4AAncgsJ2z8F4WCQvmOmM8CNafuhMt5sWZtjU
	K86c4QJW4ZC06l8BtIyJ9GmbCpz2U5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD63560214;
	Wed,  9 Sep 2026 14:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B391F00A3A;
	Wed,  9 Sep 2026 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788963018;
	bh=pOXZ86V7gEk1w7Bapk1GcuFyX4Hl3hOcDoOjdyQuqEY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nBABSYKchY7wcnJtyWy+cEItvh9ka1L52TnNXwFAU4EET/ki8hhcXOhw+Pd8Wt3YY
	 mNiN5x0pVLb+FQon788ytN5uc1wRvO0WO9aiypMyHCm/osQKYAe0lqcKij3KdPog62
	 duGllUAgxZloduF66dypFkpugBAimsXFAqzRVoHobcM8q69o0S9gyk4PKB6GWudvch
	 x/migNK60lqqxslKNKOHXLOfooWB9OWgVRzjuvg8NB1JtyWhGl/4v+31Pl7ytIh9CG
	 yD7Lm4Dfon72msbCyIxhMgJnCyYiCbyqeaT4mTsMJYIpxw3QBQy7UuLJ9VfjHSsfIB
	 uPFy+2LGFiZoQ==
Message-ID: <30e544c3-eada-4f08-8971-aa07d6b38ffb@kernel.org>
Date: Wed, 9 Sep 2026 16:10:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/14] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Jan Kara <jack@suse.cz>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-7-6ae22f9d9272@nvidia.com>
 <eefbff2b-d619-496e-a977-52062da90f05@kernel.org>
 <DLA3KHC5R6G3.22TAPOVQ1589Q@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DLA3KHC5R6G3.22TAPOVQ1589Q@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B7891A000E
X-Stat-Signature: 6a4tpstok4s3ze1gibjm1h3huqhst7qq
X-HE-Tag: 1788963019-433900
X-HE-Meta: U2FsdGVkX1/0CoJM0PPFQlcpqtcZz9ESSLb0ZYt//Qg2LvAu2mQ8z2WxQQdUOvvVIpk8CceaaFItxgJe6BXo8BrgngM0p/uTR+gRpe6W+xK5RghGHE9aG++2kDzi9sH612RnAc8IPJoHi1GOgAeOfkvvKpBV5qjkw/a9zqC4H7AvHQFcEFDdqPdcam+JUuKUTOP7F9V0VuCWSP+RJIif7QlNbPs+FdM/Q4hm8SEkl5j7c1ZREfHfsqUI1SuL4HGFrZJYvz2mmyffU4imOg1DRCQBB0RYdj1X+Gd1gY0jMVCSQ8Q3Awfb2MdSdtHUP+kIc4UPbuigN8f6mkCWBoppb1ipVRG7HxUsdPjqECuPDkOyQPvQN8RV6mviFZs+GyxOOLT91IcUNIV/THBavD83S9l03vzTcxWAkSoh2nvzGJycC1f1XuoruhhLzjYbHhT/s7q/xovgbmegjdVlEdq70ndq6Fx5Lolelxgm+vgvD8HzNBpTZRbMQD4JECeGL/7+bAfHDjlSVU9brZ6eXLv316c6h0NJytXrUMokS4l1Zwq7wt4g8YDmssjYKXeA1gKe7ZnnIB4pDSKbDTUG9b8yEY5mFVer3frw+mmWk88I9bPrQT+mMfIOFqPsV3YAWLLsK8BBaiIrAOpKaBVPn+TGlWWejP74icvIOvV1K/ZnYLM0Zd4/6nf2pl3x3rIk7aHjNp/STek2fAOyEL7ji+CLZFgIqkWXYse/Iu+vhwKf2MKAJ+oFL68Q8jmkKdBCNRJKApLOCzlV1AdlUKhoLDZszGTfAjuZZvs4V0z3O6D+UF6Sn/qKMEWp6U5wnBMTeMidiCmOoAV0FXJTRWlg0X+HaYHFFuj8/iLy/xC5L9+CeCc7w9l/jXNydIk/htKRYEKk5bcbLQ6MteFNRsJ3MBqjH5k8dIC/gWQjyp7f1zvXZmGUSB5aZFt2dESxmFT4g2ZHyc5g9iSVO9Ess8eWDWE
 bhAkI05B
 ZPAIP0V4cgag19gY1XebORxTScOcdgfS8KHYx85PU0u5XokRcueOfRgCa1c0tmN7wupspN4EoVHM4qtG1XropknIYDy+qxobtUfLUTOj5WWzmvZ+q/M/AFqOnU05Jy+m+9lAg7qZYvuQfS1q+fNzkwoiZxHC4U6JS1XAPJVhSrjll8rz6cVgt9TBXl3l+rX+Z76eukTD04K/VYqwOfEHvSUNRbI/1z7lgw0+WTQfiyg5rbqGe7e20vZfcIMCY3SQe4Ir67w7y7a96sWMRq5w/GySDs38bNZOOM6EiWdToVQLW+/uqMqG7eMU20sZa4d8IMPRpjC8mS1lYAxhAD6M9MJnSDQA7vH1ZaeXRz/MZsHGR/Ql8lE66lTR+CnKjTvg0HHpOnkOFYxtE0I4iDzVR2xKq044oPwy0orvgvTmYgFA4f8ugH5iKWUJNEhDUIbaLv2+IcQA7lTDVuHnako1NH3/AUqNdHYl2C0v2TLVqUfDfoIs1sk3bPe08NGTLbQ2uXXCkerySM+bU9y5+QOslk9Y6CufL3+kGjO/GfcnO/zhmtF4eBaRQyZeu8E3fGuvb1diXK7YXc5w6L5JFHX/V2H1mhPtZzjbOxikM0g4V5znSA63vYvYkLSoQH5r/S0/+w12QvKAVXBsJigI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 19:05, Zi Yan wrote:
> On Tue Sep 8, 2026 at 12:04 PM EDT, David Hildenbrand (Arm) wrote:
>> On 9/8/26 04:56, Zi Yan wrote:
>>> erofs needs to traverse readahead folios in reverse order to achieve
>>> maximum performance by
>>> 1. reading all folios from readahead_folio();
>>> 2. storing the prior folio pointer in folio->private;
>>> 3. traverse from the last folio to the first one.
>>>
>>> Add readahead_folio_last() to achieve the same function without using
>>> folio->private. __readahead_advance() helper shares readahead_control
>>> adjustment code among __readahead_folio(), readahead_folio_last(), and
>>> __readahead_batch() by checking new private member, _forward, of
>>> readahead_control.
>>>
>>> It prepares for a future commit that replaces PG_private checks with
>>> !folio->private checks. After switching the checks, erofs's use of
>>> folio->private without bumping folio refcount can cause unexpected
>>> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
>>> reachable.
>>
>> Ah, I was just about to ask. So it's really about folios never using
>> folio->private manually (without the attach/detach).
>>
>>>
>>> No functional change intended.
>>>
>>> Assisted-by: Claude:claude-opus-4-8
>>> Assisted-by: Codex:gpt-5
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> To: Gao Xiang <xiang@kernel.org>
>>> To: Chao Yu <chao@kernel.org>
>>> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>>> To: Jan Kara <jack@suse.cz>
>>> Cc: Yue Hu <zbestahu@gmail.com>
>>> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
>>> Cc: Sandeep Dhavale <dhavale@google.com>
>>> Cc: Hongbo Li <hongbohbli@tencent.com>
>>> Cc: Chunhai Guo <guochunhai@vivo.com>
>>> Cc: linux-erofs@lists.ozlabs.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Cc: linux-fsdevel@vger.kernel.org
>>> Cc: linux-mm@kvack.org
>>> ---
>>>  fs/erofs/zdata.c        | 13 +++---------
>>>  include/linux/pagemap.h | 56 ++++++++++++++++++++++++++++++++++++++++++-------
>>>  2 files changed, 51 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
>>> index e1e25ca0d1904..78fd7d980e957 100644
>>> --- a/fs/erofs/zdata.c
>>> +++ b/fs/erofs/zdata.c
>>> @@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
>>>  	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
>>>  	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
>>>  	unsigned int nrpages = readahead_count(rac);
>>> -	struct folio *head = NULL, *folio;
>>> +	struct folio *folio;
>>>  	int err;
>>>  
>>>  	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
>>>  	z_erofs_pcluster_readmore(&f, rac, true);
>>> -	while ((folio = readahead_folio(rac))) {
>>> -		folio->private = head;
>>> -		head = folio;
>>> -	}
>>> -
>>> -	/* traverse in reverse order for best metadata I/O performance */
>>> -	while (head) {
>>> -		folio = head;
>>> -		head = folio_get_private(folio);
>>>  
>>> +	/* traverse from last to first for best metadata I/O performance */
>>> +	while ((folio = readahead_folio_last(rac))) {
>>
>> Intuitively, this should be called readahead_folio_reverse /
>> readahead_folio_reversed, thinking of list_for_each_entry_reverse()?
>>
>> 	list_for_each_entry_reverse - iterate backwards over list of given type.
>>
>> or maybe readahead_folio_backwards (which matches the forward below)
>>
>> But I'm not a readahead expert :)
> 
> Jan suggested the name[1]. It can be readahead_folio_reverse() if you
> prefer it, like Jan said.
> 
> [1] https://lore.kernel.org/all/332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc/

Heh, to me _reverse() is clearer; whatever people prefer.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

