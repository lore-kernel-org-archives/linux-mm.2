Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4CBBE9D814
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94676B0088; Tue,  7 Apr 2026 02:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6BA96B008A; Tue,  7 Apr 2026 02:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA89C6B008C; Tue,  7 Apr 2026 02:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A2D6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:52:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CACA1406C6
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:52:45 +0000 (UTC)
X-FDA: 84630841890.12.013173E
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9444A40010
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:52:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FB9sNIVL;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FB9sNIVL;
	spf=pass (imf11.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775544763; a=rsa-sha256;
	cv=none;
	b=G5/sp64C7Zz7UnS25uq5mbM8KPPBQuJFO9J3xjQ7SKAMgrHZxXY8XZHu9QnCpzs2Q+6qlw
	SztMP30rU2HQQDwcfrycM9kBSwNYEDa6Vyuc735BCBpYw1ERJTtv5uFaFQqB1hz+M4Fb61
	yiJJtsY8IdXlzOlCBx8XqD2+2JsXoiY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775544763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+YRbn5xz4gzMbT7dbOS4IA4ueE8oXOrYHLytz90mcI=;
	b=XBHbBXOTAnbmAPwkrvOIoVdSYmT2XScrY1K5wHelbA/15fq8Ew5YSZiCcMic3CwlhJDHV/
	jQenWR1CfK7hPqefvnq8ZHdmKLKCpQE7pd/MDzVKLtPHhd3BmAn7r7qmCgw6o3lsExNcbN
	iAYvOA+rpqeYMjoCmcuMRuvH8c7BYN0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775544759; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=4+YRbn5xz4gzMbT7dbOS4IA4ueE8oXOrYHLytz90mcI=;
	b=FB9sNIVLkrzoQF4E5z2WfPJo9q4aAcPoBszFxmFABr9BlZOgDc9o1f0aW05EtRFKJSgOLF/7CQzw0xRQwALN6ugfr16ToZVGW7EDmRjqBCO4MmYhv/8hfvhg0X1P7XidDWp/5EJf3IxONozNb/BD+M/SlSwt1SuLTIFXKQuJXAo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=39;SR=0;TI=SMTPD_---0X0azT3w_1775544748;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0azT3w_1775544748 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 14:52:37 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,
  lorenzo.stoakes@oracle.com,  Liam.Howlett@oracle.com,  vbabka@kernel.org,
  willy@infradead.org,  rppt@kernel.org,  surenb@google.com,
  mhocko@suse.com,  ziy@nvidia.com,  matthew.brost@intel.com,
  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,  byungchul@sk.com,
  gourry@gourry.net,  apopple@nvidia.com,  dave@stgolabs.net,
  Jonathan.Cameron@huawei.com,  rkodsara@amd.com,  vkoul@kernel.org,
  bharata@amd.com,  sj@kernel.org,  weixugc@google.com,
  dan.j.williams@intel.com,  rientjes@google.com,  xuezhengchu@huawei.com,
  yiannis@zptcorp.com,  dave.hansen@intel.com,  hannes@cmpxchg.org,
  jhubbard@nvidia.com,  peterx@redhat.com,  riel@surriel.com,
  shakeel.butt@linux.dev,  stalexan@redhat.com,  tj@kernel.org,
  nifan.cxl@gmail.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [RFC PATCH v4 2/6] mm/migrate: skip data copy for
 already-copied folios
In-Reply-To: <3e1f520f-e3d8-4ef2-b474-ca4e988bbf2d@amd.com> (Shivank Garg's
	message of "Fri, 3 Apr 2026 16:38:32 +0530")
References: <20260309120725.308854-3-shivankg@amd.com>
	<20260309120725.308854-8-shivankg@amd.com>
	<87wlz1zlf8.fsf@DESKTOP-5N7EMDA>
	<3e1f520f-e3d8-4ef2-b474-ca4e988bbf2d@amd.com>
Date: Tue, 07 Apr 2026 14:52:30 +0800
Message-ID: <87pl4bfej5.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9444A40010
X-Stat-Signature: 5szof9mynsddpuzbd3b1yhz7crnr7xa9
X-Rspam-User: 
X-HE-Tag: 1775544762-826847
X-HE-Meta: U2FsdGVkX18TJGXjp3w+hDSMl0QVj22PUQLNr2gKLqGGIKAm2YT9EUFdEcLBUiF2iyg3fAivSZ3LV+CEUkLqweg8+tzHajkQAfHwdlsiKoSsKN5WMTooQxnY5cvFcQlE8CItAFRgt/pqrxs5lc1t62njlJ87EfGhxGZAYeFsiyZ4/6nd1xLch4ICttgvBk/gFyaZEMjyf/aHuZohJ1LgrZQJ/Z/lUhrTaJJa7tRAZkHr6zT10Evqb9+6KHq9EpRWnmfSrQMy2hEh+otoncozIbrY+3qOnynEXZys5Wl4ccXmlU33fZfKbuDUmphct2Us33Ba9m0g9s5tGRqf0h5+zs7ycLEBfGNceWQQuUxtm7XiMyrmg5AhBF/tXoLBuEcWkt4CV6gxjHkeSNq7xcx/s0LQwWOnQTWt/PbL99Vp+Dp04aHQKiwDJ8evgIuiD5m9x1sGISl3YMNa0iny4EP7wgF/sRYUOL6A9bXZnscAdhch4CD2CfbJumLsLtyu8fJAU1JfOXeFVNsyXWSuprsQdVsQ57KJZ+VFGeqFWTSaM2Pn57a/cKOmFEc8yJkBi5ErNZj+DI7UAtvdNVTnMPoYtd6B7Tt/6N+tVcYoJPXXtDU2LfHqRXsLvUCv9SyTSkHyjwfh4M+Eo2vWkiGfp1CfNzxhH9lXXiZ0ZSglyJz0D9r+OWSNCbYv0HWG2ihAXlf0VFonLi21Zxidvy+Mav4O9NLbG/R4nRcEptXjOzwYRzlNcAxqOeSxxECx6SAw+Cff6s/yG0sK7avjtBgXW1dlWbvUPVWgK+l7/tV3l6Qh5AHCfMpNkYpl/ShxgLUwGawkTEjQRLXa0LQdDo9H3UhfOagaUD9io+C8TofLe4YXoIm/FbEx9BuZedlCaNDlVv9UDEEFNd7jb6tjszAn0fMOzQ3Y8M8tif6rOi6UdLJpZxyUTgoytMMDEybja8/0tbw0sikDi8ytLELtg+tQXOO
 Ri7yEQ95
 +Py0lkgJxQj8/0CtSyido3bobmF3um06ONud6Tbnn5Y/UVNsDRnxXsSDA06Wh+aVnmPil7joXGVtwx+WFoJtwTRy36XFiOzOGwpbsSaTKnG9p3Fly/RjHJzQFlXXPR9K7WsYqSl4czHaHCbNvXlh50QiSO3xugmuF9RiU+b9zthLw7yxQFhuPfnw5cZ8O03sqDBzCz/69zL5gvRE+V4bixNCRnysH1q5WoiWTy7PLaQWpbIFw1yS8T6aoehvesROyspp27faquTrP0S14B3gMMptkMSTI3aNEedNb4MCyFVWVwpVy8kFOe4sNiOu6LlCTFpLya0qLZlI//qe782ueyt7dQ7iiWwCIMa3PnNWU0HJAugGsG0p+hmI4Vy2XJ9Pxsiu1bgZ+6aojb2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Garg, Shivank" <shivankg@amd.com> writes:

> On 3/24/2026 1:52 PM, Huang, Ying wrote:
>> Shivank Garg <shivankg@amd.com> writes:
>> 
>
>>>  static int move_to_new_folio(struct folio *dst, struct folio *src,
>>> -				enum migrate_mode mode)
>>> +		enum migrate_mode mode, bool already_copied)
>>>  {
>>>  	struct address_space *mapping = folio_mapping(src);
>>>  	int rc = -EAGAIN;
>>> @@ -1096,6 +1114,9 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>>>  	VM_BUG_ON_FOLIO(!folio_test_locked(src), src);
>>>  	VM_BUG_ON_FOLIO(!folio_test_locked(dst), dst);
>>>  
>>> +	if (already_copied)
>>> +		dst->private = (void *)(unsigned long)PAGE_ALREADY_COPIED;
>>> +
>> 
>> IMHO, this appears to be an unusual way to pass arguments to a function.
>> Why not adjust the parameters of migrate_folio()?  How about turning enum
>> migrate_mode into a bitmask (migrate_flags)?
>>
>
> Using folio->private, keeps the change self-contained in migrate.c
>
> David suggested adding a dedicated unsigned long migrate_info field in the
> folio union. I'll switch to that, as this is cleaner and avoid hacky use of ->private.
>
> https://lore.kernel.org/linux-mm/27b1b602-129f-4bc5-a553-386e8d1f5d90@kernel.org

That's good for the original usage of folio->private.  That is, to
record migration related information for a list of folios.

>
> Changing the migrate_folio() a_ops signature would touch nearly every
> filesystem for something that only core migration cares about, and does not look
> practical. We can't add to migrate_mode enum either as currently those values are mutually
> exclusive and ordered levels of increasing synchrony (ASYNC < SYNC_LIGHT < SYNC)
> And there are checks like this (cc->mode < MIGRATE_SYNC) or  mode != MIGRATE_SYNC
> This could break it.

IMHO, code readability is more important than limiting the scope of
changes. The migrate_folio callback of most file systems shares a few
common implementations in migrate.c. So, I think it is doable.

---
Best Regards,
Huang, Ying

