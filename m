Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D36D4606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 05:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WvaC4FsD
Received: by kanga.kvack.org (Postfix)
	id 3CFA26B05B4; Sat, 31 Oct 2026 01:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380126B05B5; Sat, 31 Oct 2026 01:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDCC6B05B6; Sat, 31 Oct 2026 01:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EEB366B05B4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 01:59:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F8F31208C9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:59:08 +0000 (UTC)
X-FDA: 85381868376.10.F2971DB
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	by imf09.hostedemail.com (Postfix) with ESMTP id DE980140002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:59:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WvaC4FsD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793426346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wHHnuTTmSOXbH6E8lHg0GEvp+GQz96PM/IlXLU1wjgs=;
	b=Dj+Zg6k/2EoP7SOHFHOFO+ydY11lRANngHlsHQzJNS9IlvIANjsHuYQwjFia/aQ2YL2jfH
	KPvF8idvw6HJaluB2sERAYsJoMm3Rs02nY20UTNSWOJlWAHzB/mU/rUDH0lXZ1N5IrU4f+
	FyvpzTkqjzO5Y5DCk2vf6Mv9i/bbwJs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WvaC4FsD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793426346;
	b=EiqzsnY2zmUQr1C/uTGBmCi12yZYegxzvGlBLrFL3d8d1McZg5i5RlRY99EkrlW7/gSCy5
	i2QZRuUrcWugLza7h0XTfsA51hZ5xEcPr5SxsaeFwgV1zWlg3L8DZThBxbr3792MJEmHFb
	mla/lvgMsRsyarZhVX3c7DVerJUVYv8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=r3xzYw939vN9vzH8UsK6AomPfxJthDwVeWo/3xRQ2Fo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793426343; v=1; x=1794031143;
 b=WvaC4FsDcAHQ2NQ2JuiHYy56AQRK9rpDlaBUPZSd+xgQihu0+x11PWIm4iqwRFyZyy1U2XAd
 No3BIBUDoNW7w/V5YVqDdoRSxK0L8ZNvB0OPSou2EJq8Y5jatu2VQdepv+5F4j7PiwSI/BjV5Zc
 4e5m+WqcgzPmPI8SJmGlTm5c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 14fc0ff97d323868;
	Sat, 31 Oct 2026 05:59:02 +0000
X-Mizu-Trace-ID: 14fc0ff97d323868
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: muchun.song@linux.dev,
	david@kernel.org,
	kasong@tencent.com,
	ridong.chen@linux.dev,
	baohua@kernel.org,
	sj@kernel.org
Cc: hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kees@kernel.org,
	peterz@infradead.org,
	jannh@google.com,
	pfalcato@suse.de,
	hughd@google.com,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	willy@infradead.org,
	jack@suse.cz,
	ziy@nvidia.com,
	lance.yang@linux.dev,
	riel@surriel.com,
	harry@kernel.org,
	apopple@nvidia.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	osalvador@suse.de,
	minchan@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	youngjun.park@lge.com,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	jgg@ziepe.ca,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	josef@toxicpanda.com,
	stable@vger.kernel.org,
	usama.anjum@arm.com
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking PUD and PMD tables
Date: Sat, 31 Oct 2026 13:58:38 +0800
Message-ID: <20261031055838.60138-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <6FACF8FF-F943-45C8-BDFD-3AFB5C060E0A@linux.dev>
References: <6FACF8FF-F943-45C8-BDFD-3AFB5C060E0A@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE980140002
X-Stat-Signature: 9iy1zmdopafc1n7yigxoxwmage3pgsct
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793426345-881563
X-HE-Meta: U2FsdGVkX19mn0hvFluzl8Cue9T1ebfAVA0jEt9gcl72z/swPUbFcv0PGXYPvhQE5DegPp/g83LlW7Vo2KUhK9/CHrK+vp4OUegWl+OTkkpJKDU+pe3RoPwVfbAxgXtr/hCYaui6/yTfMMroIv4MRI23/nwtUEvYF5SszfBZQlW1/P5vW8RicMURSywYz2uIvE/8h6bZee+RxD/GJ0T0htkyxfyTuIxK6UMV1cWPuQcIxXMdD7FlsNnpiCHEABOqHsVpoc+HmcmOHPvj3jSY3o9JL7WEIMjZz+NW1sGdR7eCNX87OxuW4a54Mg7xxlXtGT6UaZj47WirCJkmlSX4DUK0OInp2qNK1Hl/16CIlHFuFa+Sb+WvCsG5UeBlof56wXdJ6F5xGbvv3FEEM2QIM0hUKoNQOjVpl8bCQd6Bl+Ldi0UuSJLsczqUvvlVf6IH1cEOfF3dR7rD0ODbszqssp1VbSgsYtOudcXcrrXU/LDEc9odQQHP2jjVz6FcBIx12SCFdNoQV8DmGxIuaiEkJxClJANEnMbi/1lR5R6SK69jwNVJCss9buU6Ic7Eg8kULkneLVOG6TIfvLy+ofZtCLVUT1Lt2h+ICg4uznJQjesjLr9Cnty9aPFcxV44MP8U5Iv3Nds2NFnJH1dFcV2zRKfIuQFVcEgNLkWuW8a25/QZ1XWa1bq/c1ltrpxAnf5BYy1FsH0Px1G3tt+8/ZD7+XGOQ4kqALyHJknyb1IZ123O+sUai/p+Gve7sKVjm3UVBUtd2SP0rEhAIV9rH4nXLMrCMDkT6yCH/eNTWF38RIkiq6U+G9y9nyAvTL/9/UTEXiYh/bWxui3Au0QUxOk+LshQvehM9ZJBgPWwa6/w5k/H88BJS8f8fbW3DRWFiiVEDl0QPw67Jed40E/XDBtn2RHJv7GhsEWwXIs/tlcCUdUR7LK1hRwD5huN662JRFOyrctl6ykbFbpTrV7Z7SR
 HXGfJ7/G
 TVEclGwd5fECBNNzw2G9UZNzKvZ/GWSZ1ItY6b75aYkx/bPdz31n6A9BgFYsiEke4G9o5586Gak3JcPnr4t0ceGGro+ABjJZA793EwNlMJeMrc51yHreyx/bb/rIWwrA5N5QGj3F361v+g9Fr3nignDISRzsynfLSe5hK5WiNewe26MQ1qoCGOk82V1tHTViwBNzkbgqlBf+K8d9/XfGVA4KlVLhzai7Ipje10WiIpROcy6IfRwYgnhf1IQAGPsUaxmCi0Meupqke85A++swt/cN177r0F52NrnWrQ2JhJv7xu45hP9nMXFBQADIYphoT1NxHzk+KTfOggQSwEXA+IM0VFhbhX3UthOEJzp5d30un+v46vAjD4Kzi9HRZTy5z6FosORbOf/3teT8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Sat, Oct 31, 2026 at 09:46:37AM +0800, Muchun Song wrote:
>
>
>> On Oct 31, 2026, at 09:41, Ridong Chen <ridong.chen@linux.dev> wrote:
>> 
>> 
>> 
>> On 10/30/2026 6:21 PM, David Hildenbrand (Arm) wrote:
>>> On 10/30/26 01:20, SJ Park wrote:
>>>> 'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
>>>> But I can show there are already quite a number of recipients, so I'm just
>>>> noting here.
>>>> 
>>>> - Brian Geffon <bgeffon@google.com>
>>>> - Oleksandr Natalenko <oleksandr@natalenko.name>
>>>> - Steven Barrett <steven@liquorix.net>
>>>> - Yu Zhao <yuzhao@google.com>
>>> The CC list was so long that I limited it to people that area either a reviewer
>>> or a maintainer of code.
>>> MGLRU not having any real maintainer is a big problem; because that maintainer
>>> would know whom to CC.
>> Agreed. FWIW, I think Barry Song and Kairui Song would be good candidates
>> for the maintainer role.
>
>+1
>
>It would be great if they could take this over.

+1 from me too ;)

They both have been really active on MGLRU and doing great work for quite
a while. No doubt they'll continue to do so :D

Cheers, Lance

>Thanks,
>Muchun
>
>> 
>> Both of them have been contributing to MGLRU consistently and
>> substantially. Barry is currently working on improving aging and fixing
>> the swappiness-related issues, and Kairui is driving the MGLRU-FG
>> optimization work.
>> 
>> They have also been active in reviewing MGLRU patches, and their review
>> comments are usually to the point and helpful. They have been looking
>> after this code well, so I think they would be a good fit as
>> maintainers.
>> 
>> -- 
>> Best regards
>> Ridong
>> 
>
>

