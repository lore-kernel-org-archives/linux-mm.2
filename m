Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07B52F94CB7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 01:46:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214106B0005; Tue, 21 Apr 2026 21:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D556B0088; Tue, 21 Apr 2026 21:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064FC6B0089; Tue, 21 Apr 2026 21:46:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAFC66B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:46:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 814985ECE5
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:46:35 +0000 (UTC)
X-FDA: 84684502350.27.69C126F
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D6E514000E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:46:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=InhC2I7W;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776822393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WtLKhpy2zmxEzkLBRuem7DAZe0cRQ7Pw3b6A7VAcH8Y=;
	b=EfISHfdTaUg/cuKn0ihgoF38tBXIz+RVllRuCP/bewy8JaOYioebSa090DMy/6Maa7dTes
	lncezCQugvK15hQokx78O/Ke3exHx5kB5SLxOCOk5z1s5v0RR3kbN3+ECxfHU4uEUgzFLC
	3u/T7lQTbSPiJ/Cx+AkCF8/ckHKXM/4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776822393; a=rsa-sha256;
	cv=none;
	b=Pe5tN5cuMxUs/vXh9MLJG0GH0H/4PXgbZuohv0xJ9b79/JI54kRDsXKKDWmnDXGdsiY3Mt
	48G1orqrMkA2YFnBwSBHSaapCyQzIkRuNE2SIE7v8JzDXuP3ZyrSBROLyfTu3DURMjQsrU
	iBx3qJDr2YZGXbU9CwU76q/cS5/whNY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=InhC2I7W;
	spf=pass (imf09.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776822389; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=WtLKhpy2zmxEzkLBRuem7DAZe0cRQ7Pw3b6A7VAcH8Y=;
	b=InhC2I7Wqn20H9f/F2ndy/mumTlZHqlInC5w7ZI32TXHUXK45J6XQ6+3V2H3f3onDNP27n5THYsTU5oPMqWGU/KHcjH13j7uvq/zjlShItS3fl3s9R42Ejr1g8dmYqFEJDvSIvpXN35+iKk/2vo5cWTBeoHev450OKm4TuMKOTM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1UPB-9_1776822387;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X1UPB-9_1776822387 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Apr 2026 09:46:28 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: John Hubbard <jhubbard@nvidia.com>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc:  Andrew Morton <akpm@linux-foundation.org>,  Lorenzo Stoakes
 <ljs@kernel.org>,  "Liam R . Howlett" <Liam.Howlett@oracle.com>,
  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Zi Yan <ziy@nvidia.com>,  Matthew Brost <matthew.brost@intel.com>,
  Joshua Hahn <joshua.hahnjy@gmail.com>,  Rakie Kim <rakie.kim@sk.com>,
  Byungchul Park <byungchul@sk.com>,  Gregory Price <gourry@gourry.net>,
  Alistair Popple <apopple@nvidia.com>,  Axel Rasmussen
 <axelrasmussen@google.com>,  Yuanchu Xie <yuanchu@google.com>,  Wei Xu
 <weixugc@google.com>,  Chris Li <chrisl@kernel.org>,  Kairui Song
 <kasong@tencent.com>,  Kemeng Shi <shikemeng@huaweicloud.com>,  Nhat Pham
 <nphamcs@gmail.com>,  Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>,  LKML <linux-kernel@vger.kernel.org>,
  linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/2] mm/migrate: wait for folio refcount during
 longterm pin migration
In-Reply-To: <51168a90-d6ad-4429-8043-3dfdd81cb9a3@kernel.org> (David
	Hildenbrand's message of "Tue, 21 Apr 2026 18:00:28 +0200")
References: <20260410032333.400406-1-jhubbard@nvidia.com>
	<87h5p4isbb.fsf@DESKTOP-5N7EMDA>
	<51168a90-d6ad-4429-8043-3dfdd81cb9a3@kernel.org>
Date: Wed, 22 Apr 2026 09:46:26 +0800
Message-ID: <878qafix71.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: pguyo4x13djqq69s5pjbwn4egtcq3qpe
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D6E514000E
X-Rspam-User: 
X-HE-Tag: 1776822392-530088
X-HE-Meta: U2FsdGVkX1/r28THmTzBdd7KW9um5ryClLyZI1Kqvqi4cCriyhdsJZHSmx2j1xCzxYCAAlMOCEvQZcgSqGBU7K4f/SrA6SFPF3VJvHrqs492qpTNpubmPqotlQ1AI3qGlPEHPUnq+nA5UO729iYu2ZSj1PFYpjIwgT69XCp5wmyZNzZLlmihVSEQT3K/5UNRsVGjn0ShtDnz+wRDlWVqFo38nnfmG4wp3FBksQFesLzRURRd3y0FrXIOPHQQYG2fU2wpOJ3IihG13JAgqfazSSGaSqrXXhXQk8Y5yvY7qlrCGA9vJ1KeV7vjJsA1ZHfxwo1I5vqtC0ApOJhXAKfxgDLFAyu8oGVzfltEJ+NlPnq02qVP1chNumURO8/DzzwbltXgQdp/indWQUEKM24sF/v2W3+bi69C+MJnMz/8mBjk19U+VNnkO+jlgqG1YPlixioK6/baGNiX6QR+zI3mt4VwupQhZJfArUiF4VJrSHWImdz8RjK2QTBDM01650wgQ03oJHldqZMUtATIutRm2xFfINQCN33rQhvEoBJGOwKjE2RwXqxJdvdH/gnH9JNLPJu299eXswd0PXkCHO245YZPPeov0bMpUUU2FhpFigRIADlRnsLSN8uE22CPFZoxgE0+RA7H2SdYuX/7mB+fTWiCOSi+SO9e99257X5vNiivYcJz6NrS+8wBYuJ3VKY1UvQ8wkdl6MHw6thuuSjtuDah+nTZJt1KrG5PLXVG2SCMK4sAk1v2jETZAnOo/dWndpyk6e4Bpzu8VannKvH4vehqW2ZBndxRQV66bQOCyXaiepo9Xx7ifehCzYvHAor7svN6/kY2T8L+MyZnj5oAaUKEJW9VJDuuuKKXFBNCxrym4wpwYoUGw82/wXkWUFXq61gBDB3X/V6MLuEs9ws2zT6mkKfhVKwKe9cF8YoKOMHOgKfC0pZbAozCwYvwFbqpXStnBX46Sje1jydNkLn
 /hAfOAKj
 WWs/CPCDt+GUXLOLJYUqfQeGgu55g1mUQ5VGm4kXc6aKMtwLYx8Qew5BWNc50DLbxIeJ8EeDt1kjWtPcYPUpDrJBY/vRzoVdUX9AVxxe2LdPKyQTPj2rLvxAX1oo64fxny0Kegh94thnVE1I7+L2YCQFbrrU54/eqa1zDopH9RsGt/WfwFe0/q/qiiKR0oXh+CY57jgg0baQTTfaK20I5dw/iqyyzPYvkTP3zVb+sdSVmGiVR9XZIiM9zZ8l20D4VrGfw/aSOtCwQrd49W7lmSZ4e8Q5p2x4BwCBXQ5oqtQQCTvIx0+U0Kbe65hSkNZEGKxxIi3OjhNYaOzABSnC/afkkb4mwxGAAgh73SGETz8vOBlu4KVBHbiLSbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 4/21/26 11:19, Huang, Ying wrote:
>> Hi, John,
>> 
>> John Hubbard <jhubbard@nvidia.com> writes:
>> 
>>> Hi,
>>>
>>> This adds a bounded sleep to migration so that FOLL_LONGTERM pinning can
>>> wait for transient folio references to drain, instead of failing after a
>>> fixed number of retries. The wait uses a one-second timeout. An
>> 
>> Is the one-second timeout appropriate for all users?  Do some users
>> prefer fail-fast behavior instead?  If so, should we add another FOLL
>> flag to support a timed wait?
>
> We should avoid a FOLL flag to affect that behavior. FOLL_LONGTERM
> already implies that things could take a while.

Yes.  I am just not sure whether one-second is OK for all users.

> So we have real examples were failing is even desirable? :)

Hi, John,

Could you do some research on this?

---
Best Regards,
Huang, Ying

