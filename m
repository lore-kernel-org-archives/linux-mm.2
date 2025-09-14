Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0E67CAC587
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 14:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7A5B8E0007; Sun, 14 Sep 2025 10:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E51E68E0001; Sun, 14 Sep 2025 10:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67678E0007; Sun, 14 Sep 2025 10:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C4B858E0001
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 10:17:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54F5013A9BD
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:17:07 +0000 (UTC)
X-FDA: 83888057694.10.9D879DA
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 87D0E20003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 14:17:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757859425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Es6H2lO7gOvLDqyTkEGFIhb7usSXVx+nm3I9aJ3O7G4=;
	b=s5czXo9/7Si/ncgBCBsp3q7+bLCMrA/PoImZZ4tGTZnOg2+bgWbM2Or0vtxei7Bn2OOm0l
	MpBN/tVMY44JEbZmbw5IDqqPZW9tYUSPj1yZr5PiiridOdJpbB93nJkTTHuwcRFgeMLL+p
	7cdbYIyv6Abj2yJwOrW1RKUq70Srb+A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757859425; a=rsa-sha256;
	cv=none;
	b=nA6A6XoTILDyGYeGS9dtwXY/5dLXCLNdrBG4UbV4/ZpQpMewnEnrj+guUoDVOMt3I233bg
	JOV1ykY6h+jsJ3p1KeDtxLSAG2dciByAIND3Q+2F9nkpl6EAXdjpvsxjQ8GYSn+ic269DW
	/6I3Evpp3l/5nKzsfvT+0gpcqIaaY9g=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cPqwp4k00z5BNRd;
	Sun, 14 Sep 2025 22:16:58 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 58EEGlgB079444;
	Sun, 14 Sep 2025 22:16:47 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 14 Sep 2025 22:16:50 +0800 (CST)
Date: Sun, 14 Sep 2025 22:16:50 +0800 (CST)
X-Zmail-TransId: 2afa68c6ce520b6-07523
X-Mailer: Zmail v1.0
Message-ID: <20250914221650565s-lRvSTFZ5aDNSMEDFH6s@zte.com.cn>
In-Reply-To: <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
References: 20250914000026.17986-1-richard.weiyang@gmail.com,ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com,cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev,463716f5-be12-4d78-9432-779e3f11460c@arm.com
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <dev.jain@arm.com>, <richard.weiyang@gmail.com>
Cc: <lance.yang@linux.dev>, <linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>,
        <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <npache@redhat.com>, <ryan.roberts@arm.com>, <baohua@kernel.org>,
        <Liam.Howlett@oracle.com>, <david@redhat.com>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vbW1fc2xvdDogbWFrZSBzdXJlIHNsb3QgaXMgdGhlIGZpcnN0IGVsZW1lbnQgb2YgaXRzIHdyYXBwZXIgc3RydWN0dXJl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 58EEGlgB079444
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 14 Sep 2025 22:16:58 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68C6CE5A.000/4cPqwp4k00z5BNRd
X-Rspamd-Queue-Id: 87D0E20003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: oxsw4a3g91syfd5pp6hu61r5ftrytpug
X-HE-Tag: 1757859422-725923
X-HE-Meta: U2FsdGVkX1/mwstB9zK0tXRlWdm28MizNImxBWMATlhy4CZG8TzvxVSYQzO/3B3HHov5rh/nRinFeZOSYy9kZT/PEjwS0QGm4Y0hc2TYpVkl5eBr87Hg3eI5nsveI/mU59QRq2SQlnVpbGapMPb5a+ud2htDdcDD00RWBTuRssjy8Hg/ucgIRI7RZIpOvjKy/8wHHXeIwvZnAgNunL3l8tKA7+KL7U9IvH4YrFYRJXCY5N+doJtXzP0UFhdmkcSX7MgBYEu4xNUwy4A+uAmmcvH6S3LtGdmlfkP9XAXr9nMvpwTnTp8Y0h2VUQwgcZiLE4+DOR5loVPH05kiW0NBDEIG2kTD8+o63FuFPy+Uq3vrIUb+mVyiNnRv6kRB6XSg6lEfQx7b5NoSKh1EVyl7jjB4FohSk2Nbd6CJmI3Quzfe8OwiwLAJtpxc6bwclo7GQu8uJ1mXxicsMTQpAIGsRimxZ6aHGcSf0B6rxanx4IlS8a+U8KVj912TwLd4CsMc/QG0T18dQvPu3/n1V5244MLyo28tbs6Ck4x7M+THczul3HmWUhTOHR2HrSJMBUe8VIm7XAXunOoPzkbqyS4jr+5935GsEMQQgQmY9sZL1IPfsRtXRcBcKHfJ0wd6jS9cddeAW3Y80lEWdxQL3ThDO5s0YUFPyQ9B1l1FXR6eGpQP9oUdVeh0nUgLjll73MtYqsYwjcn6D7AGSmnbo11FHA42+5uoZSoyNJbT4jkMLhKGN6OrIWkE3gu8G18nT6lx9goUE5p1ZnNxFebWcFZJmiLB4b5NDNLlAHVLFWZkElx5PvQBtIJGZZNhwXWSWWjOQtXHs6JnZ2CPbGdZ7udTxeNcT2HGF4DnAdmZLrqNJVa+hbNXDWOvVNcXu24n0k+bVI17HaAK88iNyUAeVN2hLdISSE29KQahC43oWbt6ihWuvGr+hlxaJkHFJXynuIh/5VfO6eNXQQHs5OVEAHV
 POgKTUqd
 ao59sIDRMq26AETOYA0RT55hjNBNSybOwjvzTqsvd2EOUZAMRaVTgQRMUKSt4CqOeyjgvmuIOANDIXP6f5Wn3bNZDIGz9RufbanCvOIK1UJJyqsG6577Dr7dJY3+mVyDVsfCUQmsq4WY0Hw9ncmICjm3RxLJpCjIv/DuE7Af9R9l7OIpPIRbcQ52UPwhbaALwZnaICdwU26m/Ub79VPZjm2NVk+RPm6mrhAkyUZqbI2hrQaKoUTUPpaR7ixPzh1rDTDCjn94+tR8wwGVg3Z4nS+2aQc0S7naOhIrWjVZeflo3fjcYTTna0qLi0w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 14/09/25 12:33 pm, Lance Yang wrote:
> >
> >
> > On 2025/9/14 14:21, Dev Jain wrote:
> >>
> >> On 14/09/25 5:30 am, Wei Yang wrote:
> >>> When using mm_slot in ksm/khugepaged, there is code snip like:
> >>>
> >>>       slot = mm_slot_lookup(mm_slots_hash, mm);
> >>>       mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
> >>>       if (mm_slot && ..) {
> >>>       }
> >>>
> >>> This is only valid when mm_slot is the first element of its wrapper
> >>> structure, otherwise a NULL slot would converted to a mm_slot with
> >>> negative value. And current code thinks it is valid and continue.
> >>
> >> Shouldn't you fix the code for the case when you can't find the slot
> >> in the hashtable, i.e slot == NULL? Like, if (!slot) return.
> >
> > Right. For khugepaged specifically, the slot == NULL case in
> > __khugepaged_exit() (only user of mm_slot_lookup) should probably
> > be treated as a kernel BUG for new.
> >
> > But I'm not sure if the same logic applies to KSM ;)
> 
> I haven't seen the KSM analogue, but restricting the position of an element
> 
> in a struct to make the code work should imply that the code is wrong in
> 
> the first place :)

The same to KSM. The slot passed into mm_slot_entry() could not be NULL. Even if NULL,

kernel would panic due to NULL dereference in the subsequent procedure, but it has never

happened yet. 

So the patch seems little significant for KSM.

