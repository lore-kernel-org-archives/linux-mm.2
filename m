Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0BFC8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51BD26B0005; Fri, 29 Aug 2025 05:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F2D06B000C; Fri, 29 Aug 2025 05:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FEA6B000D; Fri, 29 Aug 2025 05:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7C26B0005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:00:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B83AD1A0608
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:00:11 +0000 (UTC)
X-FDA: 83829198222.15.645A466
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 613894000E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:00:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=egCHoD49;
	spf=pass (imf12.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756458009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRfid9eNRN1IiYiLsnEKYQu88MjmvxZl3zgdA6RmIhE=;
	b=FfM7k5F0tfOGM5Yzhau+qj1osYUOaqTQhYVhsOKfXffsg3szeaN5+roKo1vUiX4Q13OeSN
	DbNGCJFJHDEJ7I9eVNZJWU5vBzsUG6RenBeXK7Z4yLLvlENi2Ien2ctqda6LWdDqhuJIaj
	ehpOUmMlIzNqGuLODgl7TvVTbj5Bzyg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756458009; a=rsa-sha256;
	cv=none;
	b=UaJ9FSJ0kiqjIYL5l6qi5NGnTVtoMr6CGcgWeTgJrXIONUv5kPZP9oKfkYOOeuXJuRYOOL
	HxLGjChm+CFXw/4uzRnqIJS3Vf7gne/WreS5l7mRPXYotft1ke78I+M5ujdHR2pf5Bn1Nu
	A8wKwogky2vrmdhyJpCRp/Odu4Rg0pA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=egCHoD49;
	spf=pass (imf12.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250829090004epoutp0437234d1212d4b6bf3ddfff4152f1da9e~gMT_6h5KD0981909819epoutp044
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250829090004epoutp0437234d1212d4b6bf3ddfff4152f1da9e~gMT_6h5KD0981909819epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756458004;
	bh=uRfid9eNRN1IiYiLsnEKYQu88MjmvxZl3zgdA6RmIhE=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=egCHoD49xR6PtICey0GDtw4Sx59Y7VZ4nxmF9kVPG855KI8bIk1gqEXodlTOF9RRf
	 u+i31C5oz8l1xOSb1cDjYRZqZUyUd8EyVDSJhUD7BAEzON/nxdGDj+7xhU9FTVYYlU
	 3Pt3ARQk2w2GfCKDhMpfbEvlhydzmq3zfweJMdOQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250829090003epcas5p36bada7713dea2fb6f6cc6883fb86363e~gMT_Hgm1i2928729287epcas5p3p;
	Fri, 29 Aug 2025 09:00:03 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cCsfV5rzjz6B9m5; Fri, 29 Aug
	2025 09:00:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250829090001epcas5p1624018975802eceeb655e76bf63d152a~gMT8VfSQU1933919339epcas5p17;
	Fri, 29 Aug 2025 09:00:01 +0000 (GMT)
Received: from [107.111.86.57] (unknown [107.111.86.57]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250829085958epsmtip2c5f994338290c8c07053baa5737e55fe~gMT5u6ee93040930409epsmtip2G;
	Fri, 29 Aug 2025 08:59:58 +0000 (GMT)
Message-ID: <77291508-cd85-4889-8502-73eb834e543c@samsung.com>
Date: Fri, 29 Aug 2025 14:29:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/1] writeback: add sysfs to config the number of
 writeback contexts
Content-Language: en-US
To: wangyufei <wangyufei@vivo.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Lorenzo
	Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Stephen
	Rothwell <sfr@canb.auug.org.au>, open list <linux-kernel@vger.kernel.org>,
	"open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>, "open list:PAGE
 CACHE" <linux-fsdevel@vger.kernel.org>
Cc: anuj20.g@samsung.com, hch@lst.de, bernd@bsbernd.com, djwong@kernel.org,
	jack@suse.cz, opensource.kernel@vivo.com
From: Kundan Kumar <kundan.kumar@samsung.com>
In-Reply-To: <20250825122931.13037-1-wangyufei@vivo.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250829090001epcas5p1624018975802eceeb655e76bf63d152a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250825123009epcas5p1573496e2cad2f58d22036493e5af03be
References: <CGME20250825123009epcas5p1573496e2cad2f58d22036493e5af03be@epcas5p1.samsung.com>
	<20250825122931.13037-1-wangyufei@vivo.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 613894000E
X-Stat-Signature: qijtqgw7n6qjooip87sfqatyoa7bohuz
X-Rspam-User: 
X-HE-Tag: 1756458007-323080
X-HE-Meta: U2FsdGVkX1+9DDu+Z5fTkcEIGdlIR0420b33fv/OuO1IVrYUmx//+vIuU48qa2oJ/7Czv/PHIhQq8V37ZYiKW72UeS5+wmJOT9PJVnY+bzfJOGMNKXMM7iB3Vdz3KbEMnnNEHA6uQtGDpF5drxaIsdOzRWEFKEWf98HtdkvpuX31CNi2w2WjCdVZ9AVwVMtkdaDGKBPN+Nt6HH4bO5bQVbhKwmyf6BSvBnoOc43nvx/QUOtGTUx0+HKmkRNb0uRG4y66BFxVmISu2zwhdfulLMm6vumLuA57N+X7BfsrKmyDxevQMTY7fPz/jHYoZV2zqmgTtmlHMOoHIPX4xgEXlLS4bxQvIknlLDlVp1O7npTOCZDG03QI/OuASNbplkoY1n54OOeXZXe7kp0RzUGiaxLdQOJp+iWwjLj0rh6dpMtzdi1PLD+3L7T3h45dJLMJ2rYvrju34BHP8g87fF/y1CTp9dxK8kdLARK3mWe6pgCI4kLlXVsUK3cLBIL/RyO6jjvQppA5vAkx1Um4vifPGSFUfUsSuRVfi7snhVXGQDDHthfeYYeCQjYixY9P5cg+O3UfbTwve5UpwWdYVaPu6BkMziAo2/+gELGD1xJUunHAqAPiddwDD+FvBrsQiGZusAIQkLWDqN0AMB3/kiwzY1jVBv4sTXGW3+4QnrhB0TElAXRVUx5bJRALLAEsoyQ2SgcCDxK0lPdxxOKgBYkLjKrLH3iiG2A5DUyprJW6haA8CctQb/1q1DzMuzuWp2A1neAme0djQYrPBqac6vhTkgdvhpMNMDWUG1uNhqZxq6REQ/ShPbSkIQYOYVGSGVqYhItkw4vEPj5lxf6PQWS2+saNIRCADRHw3+P2rwnSeR2elX3wBCESjbZkRacG4StHLxVJ3ZyHXdsUWjj3i0uwsoxPqwF2NDt7gci/KObs0qtBOvY5SC4/aP5wTs8HvkGXX7mTVWyH/plevu4fN/d
 3DvBwQmy
 pt51/X/QhHytJ0x12Va5xgQdkeS3T8E8SzBKV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/2025 5:59 PM, wangyufei wrote:
> Hi everyone,
> 
> We've been interested in this patch about parallelizing writeback [1]
> and have been following its discussion and development. Our testing in
> several application scenarios on mobile devices has shown significant
> performance improvements.
> 

Hi,

Thanks for sharing this work.

Could you clarify a few details about your test setup?

- Which filesystem did you run these experiments on?
- What were the specifics of the workload (number of threads, block size,
   I/O size)?
- If you are using fio, can you please share the fio command.
- How much RAM was available on the test system?
- Can you share the performance improvement numbers you observed?

That would help in understanding the impact of parallel writeback?

I made similar modifications to dynamically configure the number of
writeback threads in this experimental patch. Refer to patches 14 and 15:
https://lore.kernel.org/all/20250807045706.2848-1-kundan.kumar@samsung.com/
The key difference is that this change also enables a reduction in the
number of writeback threads.

Thanks,
Kundan

> 


