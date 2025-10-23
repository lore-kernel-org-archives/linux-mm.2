Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5343BCCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 15:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8838E000C; Thu, 23 Oct 2025 11:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862A38E0002; Thu, 23 Oct 2025 11:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729E58E000C; Thu, 23 Oct 2025 11:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0E48E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:29:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F7A14929C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:29:58 +0000 (UTC)
X-FDA: 84029764476.14.B544871
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2537B80007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:29:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761233395; a=rsa-sha256;
	cv=none;
	b=ZiwWeMHIU97w1T0XUIKwCSH9GKWWDw8h9uhG7W/Y7vhfz6caXZ8TLy0AwwYTUvLO2nV1wi
	ZUMAqk2gYHqF5881blnGBpdVKsEFCVXswqVhsIvnq9otLuGJWFYRmN4Xy+xRO5KSSOqJBb
	EKs55TXe8ObTVXG0oV7V4Qfw2cTCvgc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761233395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xzg87PImVl0TcxwxqG35NSwDrsxUgNXKDg5WjAFakYA=;
	b=J2fKNcrtl7F733xIY+Zf8pQQ8l/QYzkyIBzCtMzLhH8UgspOtIsY2N395lv0YlddZAHh3E
	T5kKBVPDtiJensAlfWhv9fbXQ93sXHiL/PuowURHajEmRvMRyRtDqMuMLxJcsKyRz0gzPi
	qLnuERwgl0qjEsGo4AYz9IcLG2OF1nM=
Received: from mail.maildlp.com (unknown [172.18.186.31])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4csqgB1897z6L50b;
	Thu, 23 Oct 2025 23:28:22 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1AD071402F5;
	Thu, 23 Oct 2025 23:29:50 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 23 Oct
 2025 16:29:48 +0100
Date: Thu, 23 Oct 2025 16:29:44 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Gregory Price <gourry@gourry.net>
CC: <hannes@cmpxchg.org>, Yiannis Nikolakopoulos
	<yiannis.nikolakop@gmail.com>, Wei Xu <weixugc@google.com>, David Rientjes
	<rientjes@google.com>, Matthew Wilcox <willy@infradead.org>, Bharata B Rao
	<bharata@amd.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<sj@kernel.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>, <yiannis@zptcorp.com>,
	"Adam Manzanares" <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <20251023162944.000074dd@huawei.com>
In-Reply-To: <aPjyrAo5LdC5pAqv@gourry-fedora-PF4VCD3F>
References: <aNWRuKGurAntxhxG@gourry-fedora-PF4VCD3F>
	<aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F>
	<CAOi6=wTsY=EWt=yQ_7QJONsJpTM_3HKp0c42FKaJ8iJ2q8-n+w@mail.gmail.com>
	<aPJPnZ01Gzi533v4@gourry-fedora-PF4VCD3F>
	<20251017153613.00004940@huawei.com>
	<aPJZtQS4wJ1fkJq-@gourry-fedora-PF4VCD3F>
	<20251020150526.000078b6@huawei.com>
	<aPfWePBq8d3v979f@gourry-fedora-PF4VCD3F>
	<aPfXloRQgplusnce@gourry-fedora-PF4VCD3F>
	<20251022100950.00002785@huawei.com>
	<aPjyrAo5LdC5pAqv@gourry-fedora-PF4VCD3F>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100010.china.huawei.com (7.191.174.197) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2537B80007
X-Stat-Signature: z6utsooddwphjb943ht7ora1rsse3ime
X-HE-Tag: 1761233394-777936
X-HE-Meta: U2FsdGVkX19rBWGJJCdhCPQ4GqW6w63MswIv7I5uIJO4LogNeLP9Adw/nnLRXM/Qjq7R6fFraso3kVKqg7OcC7QJ7RkHva0ItWx4GUZSv6VkjTBfrQaia7D31UaTHquLVHmCPOyElbjU9sIPd8pAc3FP8e9ykXqT0F5ROpESDKOt1Y76qHXrSW09G+0Odk5g1xZgdbMg2jG1XiBQttM1cPu5MjjGp2/GkDPC0+SnkG1AYTGjfKhW5G8HB1ZRCVBi5mpp3mgf7UcfCPo4Us8V6yIKR/J+GysbnaqI+EJdANjyXhxaxanoaXUQop6Mw6H3WqvQxAb115l1kQIDRioiz0LANJ80l7ERfqSkvs1Cik8Zaj4Hb9G3LiGpeh5tw7nPVT+Mwway8hslgs6FwB5VlwMpAKPoRXQAuvYTb5VY7UBkE/8UUBbnk0Dt1p/uIriRAOtIUgSoSFFtkwPDO2x26i4cfX7kiFbKkFepwQLLIu9lFltNCJtNDydhXvn034roDA4K+Uyt7siuUvLEEnSBaOageejMd4wmxTa9sMy0Zb1abDC8UK44OdIHfw+C/JjE4B9hHZItL4SBgUOBTbu65ZSEFFXGaqhC54FCHhsExYNKrLPxhUo8rAXj/Cm4/jWOBJXotWkKOLcFM/SJCYwmSwIekG5SoR46a6JohVpP3GhVcoFgpog7EctNtIX1wI0jY48pl1uBdtlJiMz9VY63rw48n/gPAJhUtcdJ44c9elnzpXjf3jKm4+y2VJ7GOk5KlYw4okNB8fUVXgJJ0OTBELoJS9wzGskFJEyI923mOJTBSuCa3nYUFtv2WruIIG8kvEobh9KOmsnSvl4Xe03plw/L4HxSISw4dAoELaqQl9B4V4Pjy++72JUBY3j51U6j2YezW+Zx9hqhfR/jy2xVMxI5HXsLA71NiRFqWqPsxzRoLO3SyVykN4GTus/TEtWPW5ZjXyP38DGhZiQAGJG
 1F5l68VA
 8c+m15WPLyGnDxMSPcRRULnEjTVNPY4UlFcxdz5lbwiRpXmpIPkUpLcOXJ/omRSZKwNKoRyZANrrq2ngiYwpt4DgH+b82/PK42NPdFRhyMszzHa7kkwQ3XEZMsiJRdOmes/mUGEuG2NMdq0HW6FlMoseu+LM4GTW+7qe5Z1dtCpQnddGlVoO8N0jGjk72NlV76czcVoNatfsqyTY5VDkat/mcsXdlZN0z6/7uOg7kVHhjWysEwltTdqegMr52uUkvfNgMT+bbgU1UGRhYUyOjiqRr1CMcO9tksKt+olKn42eJTU6kvUnmYWz3qSuH5mvtzEULpMKbPbKFfpSs0jvz5aF5wSLdEpGOT7n3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Oct 2025 11:05:16 -0400
Gregory Price <gourry@gourry.net> wrote:

> On Wed, Oct 22, 2025 at 10:09:50AM +0100, Jonathan Cameron wrote:
> > 
> > My gut feeling is the need to do dynamic NUMA nodes will not be driven
> > but this but more by large scale fabrics (if that ever happens)
> > and trade offs of host PA space vs QoS in the hardware.  Those
> > trade offs might put memory with very different performance
> > characteristics behind one window.
> >   
> 
> I can't believe we live in a world where "We have to think about the
> scenario where we actually need all 256 TB of 48-bit phys-addressing"
> is not a tongue in cheek joke o_o

You think everyone wires all the 48 bits?  Certainly not everyone does.

> 
> That's a paltry 2048 128GB DIMMs... and whatever monstrosity you have to
> build to host it all but that's at least a fun engineering problem :V
> 
> Bring on the 128-bit CPUs!
> 
> What do we name those x86 registers though? Slap the E back on for ERAX?
> 
> > Meh. Let's suggest people burn host PA space for now.  If anyone hits
> > that limit they can solve it (crosses fingers it's not my lot :)
> >   
> 
> +1
> 
> ~Gregory


