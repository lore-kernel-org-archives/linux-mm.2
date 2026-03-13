Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E91BA103E305
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 15:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18FC06B0089; Fri, 13 Mar 2026 11:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166AE6B008C; Fri, 13 Mar 2026 11:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09D8E6B0092; Fri, 13 Mar 2026 11:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF6566B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 11:40:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 949E0B6FC1
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:40:23 +0000 (UTC)
X-FDA: 84541451526.13.A39C871
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id DF48240013
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 15:40:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nKbp0tik;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773416422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwb/Ix5jC1tAW+ErobqQ5iF4F/G3peyTxTbfmU1XGjc=;
	b=z5MkG9bz6Ef5NC7xsQv+yFPCCWv/Oj1rw/LBIi7Pu+5ZZ8HS8xBFPpCot4V3vg5lI9l0bg
	wLUVVSC6LC/vEBThIyq9DJYj2pX+DmLvt5CmUGoMlvQ6+pDsfzVUUmnVgNi7FaX9Q3Ak/X
	7ZrSsGBd5EsArELEB9DrBVw+UZxz4xc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nKbp0tik;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773416422; a=rsa-sha256;
	cv=none;
	b=ST7AjXbWuSYRxZLKRV94PcEanegcxWMfUl+mNgIes/o/Rwaksn0n8DbzXH++5XHvs5GWEU
	vfXLLu9llwOiDVnYis3rqZagP7/gbE25wb1/KjGG0wtl7i4UIn4kNgOT+GQyF6izTrB25R
	Fmjc+m20TzqRASPruWc3oAjZtQCtiQA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1A754440E;
	Fri, 13 Mar 2026 15:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34723C19421;
	Fri, 13 Mar 2026 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773416420;
	bh=pwb/Ix5jC1tAW+ErobqQ5iF4F/G3peyTxTbfmU1XGjc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nKbp0tikNz9cHqTQsUNTiVm08JCp0gVeXxTbxWur61UQyg3WtGaOpohGDd6s/y7Z3
	 ZnuwtK8eylQDGefKyEv03T2+UtutBIOS9k82FoLHMeiNOvOVimuvRKVoWBhnEn20oH
	 E5z+pdhcfRtTz58G12rgvz1gtHva6r1wZ5yIn16DWAprc1TCk9e5f+S7r7LMNMjTHa
	 2Q0fsGlz0boe8NpUN6Ds6vaAN+Z99RiG7h6XIDLQCN3GtzMrg95u/BNAzLvBvPXMy6
	 3AVmfDK3p+Qa2Sjrz61SDOEsWcxrLouEUPs5FPq06yBhSPhNgUzVQtt/qBJcK8pL8g
	 Ljv2XJ1QO550Q==
Date: Fri, 13 Mar 2026 15:40:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org, 
	david@kernel.org, shuah@kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH 0/4] selftests/mm: skip several tests when thp is not
 available
Message-ID: <68b17560-3033-472c-9638-a2e2058529f8@lucifer.local>
References: <20260312114027.634559-1-chuhu@redhat.com>
 <abLHz2qjdeNqdFaZ@kernel.org>
 <abNZmiL2C7KMQM1t@gmail.com>
 <abQq-Mt0p3vz5rQm@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQq-Mt0p3vz5rQm@kernel.org>
X-Rspamd-Queue-Id: DF48240013
X-Stat-Signature: xxw8h1kp1yru36dxtbor4iituoa5aju5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773416421-105010
X-HE-Meta: U2FsdGVkX193aqqOc1C4I8feis0tV3nZm7YgBk/GT31qbhS9OL1ZAotT7vuHfd5cphz3p2HaPcNx9ldklJbDRih5LAotiRmsKeeOhzuvnGV3ipK78F68SpB42HlANQf56bT6yznO2jmK33MrOc8EkIB+zePSaHqVhUPaTZ20koBTXdI5aepOliLy6D9WwiRvR6mtgTZM1aVLZyJ4fie25krYSQtTKIzm+n10SFZUjl0+dL8pO7YcasDDFf7S0q3eMkoTCgi0RwOKhs5mvjsso2Erf4hoLOMmKuDH5gM5dLdkUq1d5CyPOhoW5jP1NaJprz+0TwUt4IR9r5cRnJ9bHfVKx2gMg3gbp+whsAYrcbuNzABFJ1mDuUFSJHY27YQ8aPsTXOjBG0mEMuw282mOwy+bm/wD/fdTEtHKJjEa+rxCoDFJ7sk4dlIEPslDJIqRnH41YDTp22/eyCEu+5BeYee65zxgbSuU8cUXy1WfzErNDaXlox3ycgZEpPQ546Rh6P9ggOEl1t+w3+hALYNSsnR3tIPVTh4524om5apXu6Xu7tFNaIoYTY/DHA4s9lE+ZCYIqBl6GJ+osg8XE1QaE+juYnBbqVO+gr6fOhNqMLajHWRZclKWvSGvcmzQWoi63Rug0DZ0NeFj573logmRZRwCz1xpY8ut1LePlIwOcNRAbFM/1mpGnHZ0G5jd+dT4eWoZt+Svq/0aHxrIDeO5EG+VAItZadktm/cH6JOzu67uIeZ2gsxziV+JZBY6XNbSqkrOS8qO9bWO7E/1hq63s5Zuc4yfjdDB7Ke7Q1wdLpM3Ey0YO30uyvKem167HlGdPHbQ0omKnldfuHJ3cxUJMPq1VPGk6JdhalwAe+bY9ivyhsqnPCswyzjfwabWjbgRCBWZ5jq2X6HyR+d1u1KfBBj+GkSEmvMlyeGPi/uzmZ4nAXIomLzoDp33/6Wa4T7ddWK6Z3yaR/e03tUd9la
 7Vat4ZNL
 ROuByjulCdXiUpro93o5xrqcTe9tU+SiU63R0dLsaN6Um2OGZteBcz74MPOAcEO5zqwOp/JscaOl7lTOkoBYHb/629wwg1uHOaiahbyebwGaDJq83fBpdSgbP3ufX1z1lsVd45vc09/Sr9n2vQIK8OY/4rAmwS0QOpe3UTnnkWJTnCEFMjKVBe/BoJMH8xWYS3aN0ssveS/5Po9Aujj47L8HIAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 13, 2026 at 05:19:20PM +0200, Mike Rapoport wrote:
> On Fri, Mar 13, 2026 at 08:26:02AM +0800, Chunyu Hu wrote:
> > On Thu, Mar 12, 2026 at 04:03:59PM +0200, Mike Rapoport wrote:
> > > On Thu, Mar 12, 2026 at 07:40:23PM +0800, Chunyu Hu wrote:
> > > > There are several tests requires transprarent hugepages, when run on thp
> > > > disabled kernel such as realtime kernel, there will be false positve.
> > >
> > > I presume that when THP tests run on kernels with THP disabled they fail
> > > and it would be a false negative rather than false positive.
> >
> > This is an interesting point. I'm not naitive speaker. I just learned
> > from AI. It really matters what we define as 'postive'. I presume 'postive'
> > is we run selftest and got a failure report, that's postive, not thinking
> > as it's thp disabled kernel and a 'pass' is postive.
>
> I think that a passing test is "positive" and a failing test is "negative".
> So a test that fails because of misconfiguration is a false negative to me.

(Ostensibly native speaker here :P)

Yes.

False positive = the test passed when it should have failed.
False negative = The test failed when it should have passed.

Cheers, Lorenzo

