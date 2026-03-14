Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97DB107BCEA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 00:22:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3722E6B0088; Fri, 13 Mar 2026 20:22:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3536D6B0089; Fri, 13 Mar 2026 20:22:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255DE6B008A; Fri, 13 Mar 2026 20:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15B2C6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 20:22:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9DD761B7849
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:22:30 +0000 (UTC)
X-FDA: 84542767260.03.C1C3FC2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 81F08100004
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 00:22:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X34+SOTg;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773447748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uT2tigehu5ZKWMcc7PVmJLvJTOYRhmuCPZcyVnDXUW0=;
	b=sBPbHieE49/IIpxq6xdXbYeuF1+yipGB6SRWA72LUaIEDiRCxeXN/c58DXB4kAQSKhrTKD
	ZDyZ12ROqKn/Jhj9wJGLrkC6iL/EGTZSpCZSqAVkufXjDVhk3xySRWXFvV818L3aIvDV3t
	4oRJHcqr9hsdugbjqbGYaqR54As50mI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773447748; a=rsa-sha256;
	cv=none;
	b=wUTb+8j8PJTNuA23YzoMM7cCA+m3JV7Q9KHQz9CZ10YL4bjsISO4j3SSLG+aeIbw0XQzVY
	yrye6tl/CAh1sHCoV10kizBnA6hQ3+lDswl1rrmT1M9RDgwZpuoRRLiojg79bUckYmXC0R
	TuPz8/VfsvtTqML5zc+4OALEC/6MhY4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X34+SOTg;
	spf=pass (imf05.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773447747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uT2tigehu5ZKWMcc7PVmJLvJTOYRhmuCPZcyVnDXUW0=;
	b=X34+SOTgbN+4FVCnHRcAVNhIFlodKAvX/UxNgxabe0DXcu57PEGmvqtL4OXEDM4PGNYsR/
	SB/rVeaZD9cRmq9mwn3+yXuHFDpf2JiNjZlr8TvzpL28B/83dA+OAmVdp/5Chr2/ypTUxr
	uWjjZ8JitduwllBbSMKUQnhYz4iEPYk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-463-5ieO_G_cPgSDUQ_rrj16QQ-1; Fri,
 13 Mar 2026 20:22:25 -0400
X-MC-Unique: 5ieO_G_cPgSDUQ_rrj16QQ-1
X-Mimecast-MFC-AGG-ID: 5ieO_G_cPgSDUQ_rrj16QQ_1773447742
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E8CD195399E;
	Sat, 14 Mar 2026 00:22:21 +0000 (UTC)
Received: from gmail.com (unknown [10.72.112.67])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CC01180058B;
	Sat, 14 Mar 2026 00:22:10 +0000 (UTC)
Date: Sat, 14 Mar 2026 08:22:05 +0800
From: Chunyu Hu <chuhu@redhat.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org,
	david@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not
 available
Message-ID: <abSqLYQ_1I590KLB@gmail.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <abLHz2qjdeNqdFaZ@kernel.org>
 <abNZmiL2C7KMQM1t@gmail.com>
 <abQq-Mt0p3vz5rQm@kernel.org>
 <68b17560-3033-472c-9638-a2e2058529f8@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <68b17560-3033-472c-9638-a2e2058529f8@lucifer.local>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: R_JsXr4X9koT_Rm1r3SpG6nBwoqvI2o0MTLwVYlVxfA_1773447742
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: ysc1xhsok1j5ybubrof6qeza6cxdfyb9
X-Rspamd-Queue-Id: 81F08100004
X-Rspamd-Server: rspam03
X-HE-Tag: 1773447748-231021
X-HE-Meta: U2FsdGVkX1/zBZxFgGnySHOHwHxSlHb/2J1deWCghheDGPF8GxQJge7OF3lctg8Sq9U2A7LLbp65RH8SsNj0vKgHQMuSjNUVm4Y08e8XVriGT54L73bFb2bbSvKiDIM/QxXA9MTc9hitI8njSc+jWDJvG/unhHNlkDfODFWuUNjeZ3RmBCiZwVeF2+fIPcUhxF38COh6r11uAQbew8aD/W1HoxgdO3FIpjUvC61PochANJxRTHV4OoloQj8KH70fkE+nfOadATt8e1kP1BbKdZzglNW9w/5zpxNxE78YrFOI3iwnWENmO54UmEEUIhL9FWoEM+ZZXcZwJqECXISpCiSTmZwf2LHsHNKmLaHqz/7WNKK2ai+CORiYyM7Of2/DDaFjpd9RYrgA/wFK0LAoU0JEftPUVyABTib/xyI1x0OygtLj1Jl3/d7BBMuXQ27R60P+yzUNJMoKPcKfLfcXYzzNaSGfTA3S05aepRTYoh4cHiNnxhW++uaHRyKYAIJil5+eVz9ilzC4FP9M/5JvdXECJZOPJJ0+rNBuWbRpYZCHdLnFIirpHRTaT/io8oOKVZ8BML0czpZpWyx2mGWqEfwEu79U/ncFhVwvMxwziM8OhWsCBprRFmZGeRNNX8Y9Ibx9r+0OSW145+TLGGB+ALSzJDlmmK/TRJbBVMP8UnQ/5fNSIbrfufNz/slB7BDYLh3qM0vimBi51aRlGz1WSqUlLgrS42tLIxu8gR5PuXs6CiKZzR+i7k4CLY4F5XMLcwNK6eofrcx4qjOpMmFqF2l6sXPWM8NDccor4mv0S8Nt02TYyTfMSh4rsFofWLcUTxMNBy6ObagJB94/qQrPjq9XYeWw8brGg2eOZeZvEGyOsPyx/lJin1UW41rQNhl0jkVq7523FSGU0/LXj5ShnBh2XlWsDI61O8wwbnq/2WV3HAQNuwZHgE+1h4VoorpMeLc1G1M9nh1fCRGOV6Z
 c8eIJqh8
 ZYSGkKOTZVdVbDCUrquoFoN3Xsq0F/zTuVz/IxavoM6o4VZsqVXfhpK1nsCN1diRgH4VPo2IUnGuN7v6GiTXl8vC0HkqhZeyDXdRQNCXxGUhT6E+/doY01ou9FcXVRjxWWPbPWNYLmoRdzIkM1BMU50myCTrZyPVl0FVohTmOH0wQz5pKIxZS9MPc3skrFCsyp66/ORThSoUjgLYIQHCISJq0u5BVYiM506N58ChheBsdQ0ViP/Jom5fpu9KUJXPPdf27ZcDJuuADaDtb+sTc1LjLVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 03:40:14PM +0000, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 13, 2026 at 05:19:20PM +0200, Mike Rapoport wrote:
> > On Fri, Mar 13, 2026 at 08:26:02AM +0800, Chunyu Hu wrote:
> > > On Thu, Mar 12, 2026 at 04:03:59PM +0200, Mike Rapoport wrote:
> > > > On Thu, Mar 12, 2026 at 07:40:23PM +0800, Chunyu Hu wrote:
> > > > > There are several tests requires transprarent hugepages, when run on thp
> > > > > disabled kernel such as realtime kernel, there will be false positve.
> > > >
> > > > I presume that when THP tests run on kernels with THP disabled they fail
> > > > and it would be a false negative rather than false positive.
> > >
> > > This is an interesting point. I'm not naitive speaker. I just learned
> > > from AI. It really matters what we define as 'postive'. I presume 'postive'
> > > is we run selftest and got a failure report, that's postive, not thinking
> > > as it's thp disabled kernel and a 'pass' is postive.
> >
> > I think that a passing test is "positive" and a failing test is "negative".
> > So a test that fails because of misconfiguration is a false negative to me.
> 
> (Ostensibly native speaker here :P)
> 
> Yes.
> 
> False positive = the test passed when it should have failed.
> False negative = The test failed when it should have passed.

Ok. Thank you for clarify. I'll use 'false netative' instead .

> 
> Cheers, Lorenzo
> 


