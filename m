Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FC8CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127616B0005; Mon, 11 May 2026 21:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8736B0088; Mon, 11 May 2026 21:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F306F6B008A; Mon, 11 May 2026 21:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E19196B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:46:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C48F120302
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:46:47 +0000 (UTC)
X-FDA: 84757078854.07.5BC8684
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91B75C0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:46:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="XPycUiR/";
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778550405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lCZrJmWcgeI9f/ODZSMAog/jo8dLcJSiPNdbUjCMAEg=;
	b=yuXGRdPP2C5Z7GLrdJXWbWRbxvSAlgLp7Sx3P0BQjZ47BOIn5r0j/hG68107tdS1qWQi+K
	kqLEh59r/g8y8C8rbodYzNDQ367gNV/ZmRetw4sIXexP0sQVi2yaSZrCe3dFYi7EvBEAvF
	1CQNmckASfOoREZNeaZUy2cn+b+9ARM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="XPycUiR/";
	spf=pass (imf28.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778550405; a=rsa-sha256;
	cv=none;
	b=06lYdW6lJEv+SclD+fCcH+4isjUiRn40lCSMHC5TTatgvjVvFRcVEB6RzrwiwuI8pC5lv8
	gG4/lMAN9J8GrGld4lVlWkToCWBoxZHvrzcltsxTTaiw4fFSubVC6ZMEl40RBnhOfZ28H3
	v4kmVddbhxqOVIB3TEZMPfLA7LOyVDA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1778550400; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=lCZrJmWcgeI9f/ODZSMAog/jo8dLcJSiPNdbUjCMAEg=;
	b=XPycUiR/pjDy5bkHBj21szV88PKxaP1TcxgrSNUIznNaBxLkBkmqPPvB3fRm0FEwpMUjND33hG4WTflB067XokhCxLxPfYBoCePW0j0siavOOYhJtuCOEA/F+uFcMuXSF9uaFIaYlByMYvHgKBwDDjYlWMh/Fo9vkzgtdeHp4UE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=44;SR=0;TI=SMTPD_---0X2oYqmQ_1778550348;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X2oYqmQ_1778550348 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 12 May 2026 09:46:37 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Shivank Garg <shivankg@amd.com>,  akpm@linux-foundation.org,
  kinseyho@google.com,  weixugc@google.com,  ljs@kernel.org,
  Liam.Howlett@oracle.com,  vbabka@kernel.org,  willy@infradead.org,
  rppt@kernel.org,  surenb@google.com,  mhocko@suse.com,  ziy@nvidia.com,
  matthew.brost@intel.com,  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,
  byungchul@sk.com,  gourry@gourry.net,  apopple@nvidia.com,
  dave@stgolabs.net,  Jonathan.Cameron@huawei.com,  rkodsara@amd.com,
  vkoul@kernel.org,  bharata@amd.com,  sj@kernel.org,  rientjes@google.com,
  xuezhengchu@huawei.com,  yiannis@zptcorp.com,  dave.hansen@intel.com,
  hannes@cmpxchg.org,  jhubbard@nvidia.com,  peterx@redhat.com,
  riel@surriel.com,  shakeel.butt@linux.dev,  stalexan@redhat.com,
  tj@kernel.org,  nifan.cxl@gmail.com,  jic23@kernel.org,
  aneesh.kumar@kernel.org,  nathan.lynch@amd.com,  Frank.li@nxp.com,
  djbw@kernel.org,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH 0/7] Accelerate page migration with batch copying and
 hardware offload
In-Reply-To: <088ded16-09ca-4c40-ab23-62108c342588@kernel.org> (David
	Hildenbrand's message of "Mon, 11 May 2026 17:19:18 +0200")
References: <20260428155043.39251-2-shivankg@amd.com>
	<87a4ub35ja.fsf@DESKTOP-5N7EMDA>
	<088ded16-09ca-4c40-ab23-62108c342588@kernel.org>
Date: Tue, 12 May 2026 09:45:48 +0800
Message-ID: <87ecjhwgc3.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91B75C0005
X-Stat-Signature: 5xwe3u7dteu74mj5gaw3oskp8ukadfoa
X-HE-Tag: 1778550404-857450
X-HE-Meta: U2FsdGVkX1/lHw9inZMLVDEkdFCcPWmsRafgtoIIWgsNHZdY710/P8RgF8HxNTTy/qcVYkj0AOdpU2Kw2hTykcsKRQgyYCvR0rdf5cscyjUfQ+Q8drhPHIt83Z4BV/kyfXDzXtHfftzvScQXdjwYn3P81Jr8JNRpv9K9NTtwcYKdSg1SBbDSCxTkvOfnahrpdya957Q1hojMAbu7s7cmgEurib6giftS7K8/FphtqfM/hmM75RGRS1DAM5tfKsCkcpjol1ORsSShlWI9Wxxu3H1I9JdhCRRhWEfLPuEsTEFfcraPb8dZ4lEj0g/PzM9D5u1ALjd1k2VEa+cHNnQ9xfN4py92lAhSTQfVXIlf1jROwvG6GmAyz+kzygOYhi1CYLXt9oPzL49cEVuwJg4145txwl3k5688g1mcQNohTXX1OHXWi/uojt5EALV0H3L7JqODbW8/Ek6nmpdoVdXYFdqCpC43zjBcXjkTg0FTmcppU7pIRE5kifg4NBYtA8chrrGIAdpB7wv3rT1Wekbw3UKgaWZrRv+stsumFyW66oKgHoiKMzVwFVA5jUs7vrLfg/uMhtyta4aeXMA6xDBCpIUn64auf7yrWdvo/9bRJOkIN//rHqM724DNPyW+fCtJ69PJEVbennGdtbyLYeC/Md981ryoviQZOaOgAgY9zcsI+je9NjwxvqavJNWRm/KzkeA5DO1fGTq65io93BQiTtWwBXX14yIqw3dwSw3Lzhc2VUq2U17SsYbsQj+HPSA64i/HbCq3srlLMAoNdcKmYSy1JozD9axFxWlxNPaT9bb6BY4xOIhzFMtHsFeNXUdHw+9U+ELVaF4zIZeXSr9ia4sDl89bn6tDhhwnrLwSo0XYPhh9zJQoSbIMaaGthEXwqqudH5Frork2DiMKPcvwmn4nZGONrL4YPsZmOOvIMvbTmUhfxc3W6qGOhRwwkYsB0evKEE3Kc8/KsZN5rk8
 NE5y8vaT
 p4CNfNqi0geM3z4b1aTs+F6+cP1EhdHavcSwtSBLYZ79ELPd50cuXeI8b8wIBMWE8AAbnf67DySHIthykHlkoLRmtpbTU8qcx8NM0zzhmRkpN8GoSIWCfLPaSn8gQ0lyHp1XjHR2Wsjse+cOZG74Tj93hc/uW/BdGd4BHRGt2pUsbbYh38vxEQVbABNpf571cBhrtgUk3JZwlk3+jHKhjr2vaUXcI9Yx/X8R1GoTEmsJVHTxnJlZM6nPjrehdWrxCeX1J1UgKO9oMBAqx4/3qbjWIuWddjlQL7XT9X9XxY6uj0/T5SVFR9w7L1QENR2y1jZRcSWFsmwVMseNM7ujMufJHIPujZml6r+/K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

>>> ---------------
>>>
>>> 1. Should the batch path run without a registered migrator? Patches 1-4
>>>    are self-contained and use folios_mc_copy() (CPU). I have several
>>>    options like making batch path always-on for eligible folios, or
>>>    giving admin an option to flip the static branch, or keep the gate.
>>>    I'm leaning toward always-on.
>>>
>>> 2. Carrying already_copied via folio->migrate_info vs changing the
>>>    migrate_folio() callback signature (Huang, Ying). I went with the
>>>    field for now to avoid touching every fs callback before the design
>>>    settles. Happy to revisit.
>> 
>> Personally, I still prefer to change migrate_folio() callbacks for
>> better readability.
>
> Can that be added as a cleanup on top?

It sounds good to me.

---
Best Regards,
Huang, Ying

