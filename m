Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6960FC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 04:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B026B00A2; Sun,  5 Jul 2026 00:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2295C6B00A4; Sun,  5 Jul 2026 00:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139D56B00A5; Sun,  5 Jul 2026 00:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCDBC6B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 00:10:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E8281C7D9C
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:43:55 +0000 (UTC)
X-FDA: 84953026830.27.9971385
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6B7D8100006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 01:43:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GXuKFGlJ;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783215833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ClCdwY4WLBrRhb1jFVnTBUMjMcoy96ASFZKvBHLGJE=;
	b=DW18As4QtpnLztCiMsMSLdXrrrxChnqA+DTHdPqFGe0luc7+bC7y4krybHIUIrg95+ODbP
	Dfed0OGbq7cmXDhFrNwU13H37Cgq5TDgNLVl8pprhLg2JfySSrwO/eX0RdZCxM6p0QgVKH
	1sZQMkKN69+xKjzv3IELQZmtpT1EVUI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GXuKFGlJ;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783215833;
	b=k0gMn47N/Vwtcfa7K/zrcFHGzqbiqnXf0jD4AM2ghqBy6fvIF1pmFlf7r5N7pkMaoUc4Yc
	lMf+/hZMeKlR43lLaK2tiZI8MSW28YormFvsqFC3e4urGMqrDRbsgb11n8P5S2YXdttDGv
	zmNfNF87Z0b5cfx9a8q1z3L73vxKCnM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EAA06111A;
	Sun,  5 Jul 2026 01:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264F21F000E9;
	Sun,  5 Jul 2026 01:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783215831;
	bh=0ClCdwY4WLBrRhb1jFVnTBUMjMcoy96ASFZKvBHLGJE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GXuKFGlJfVE4+DoMGMPcDt4kOCdmKLggF774XVb1z6bjjiu3YWwR4F9WreovqcnyH
	 UAhhJy8n9CaYUsR+gR0nSKr3eG5sxw95Rdv6M46FqKk7+NTHwx47LIO1qMGvJdT53s
	 hJucP0bCWoRaRSTC8ppO3bdPUBMRj0ferjXLfCkw=
Date: Sat, 4 Jul 2026 18:43:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com, Baoquan
 He <baoquan.he@linux.dev>, willy@infradead.org, youngjun.park@lge.com,
 hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev,
 alex@ghiti.fr, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam R. Howlett
 <liam@infradead.org>, ryan.roberts@arm.com, Vlastimil Babka
 <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, kernel-team@meta.com
Subject: Re: [PATCH v3 00/11] mm: PMD-level swap entries for anonymous THPs
Message-Id: <20260704184350.d6f008ae410202a0a7445b91@linux-foundation.org>
In-Reply-To: <20260703173903.3789516-1-usama.arif@linux.dev>
References: <20260703173903.3789516-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mfmpaxtyohq1dnfscpmmdqbfoj8mfz6h
X-Rspamd-Queue-Id: 6B7D8100006
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783215833-197161
X-HE-Meta: U2FsdGVkX1+wng8LrD0R9XXz5pyLeQx63GwQJ8n6O8c3vSPVk3UOTAU+pbL0E1AQUiHi0hAdTRz736E2zAkmvpGgw+flXV6UzPCutLYOL7taxZpqHoyNWeiguIpTDiKXJ/Q2bSuZ/4rkEep4/NLW5eu1SkA7z+DrEIG3YHBihD4WTQbwvchfNcWYy/9SYgDiaTyB94OwRrGSY9wggDZ3dYI0ZeFT4FLofcJBqxSWc167ySfcu38iBmsr7g+5o1rYbyjmNBvMa9JR04bg698BBlGtUWknTUw79bUCmAK1CJIH8+9dgoa35pwxjx+bkD1/1AZr9ChQ6GYrHDKAXmlevrlrEdnTs+zAh7iHcbiB+uNMosGjAAuJXB09vAZkEnP5fC8PCn0Xj6b8P8FbTYKrTcQrPMgz7ww4cFl6/xZN10Fdolv7xQ5z6TKOQgaLCUMcA3X3Qytjy/naTD74CAd3IcWIzKmojS3owrU3pLSbPE7ZUgqSKzr36t5RP/WhuwaMi7Un9/cU1Uxz/eM2w0x+8BzsS22AAa1qM1N4xsaxC/jBYyj1KWgnnqm3L1maj2yc14B3r0am0HILrqqllu0fwBlkJzyHh8H9oiPgF4T3fOH0BKRaGj3sMwN2sACwSvE9dnInPUM/sTmU61sl/P/wNTq0k5xgWQrbDEYmqOwCOvQfWFUZSVShg8riF0iJFRe64SegLBXGxnGfdIKFaGcfoe/nuMHOThRk+Uss5iXry3D3BD42TocySHQXQSKqM/8uGudqOBpzLXBUt6Pxm2EwbJ9LJ2wBJzcyu3DKKa9/Qa4pHNkdcC83CIe6qn5DuykJpbkb9zEXLhcW1SwPHfA6OWxrv7OjKrrYxTFM795ZpQCWrSmoONGKm4jZmOLGKWNPeeBGWEWIihtyyLB+YhzYn44GUUDCtNkL5hjfcgjiUrkVpLTtYzspi2DCprgc+3xAcz9fxheX2UtEhX0BCdu
 LvYjY0Fk
 UPibT9uCWqY2EWJkkAn8EN0wunNdwsfxREHvMw+Slbnbqo4AVg1/tMP8LHyTjorqPGR6JQmykreTXqhAZ1Oim1aWRYJWMQkknumyhMzALWN8VnUYikkFqY/8ZdS8XvzYcwd0xn0qf8MTGW2aiRkFeTm3l+F9BQOtSNw1cb56Karm/TEOAl5o236mXt18pkGXV/cMkz1St7Y78te4y0LbIv89/Gxzx0mKEDMCSbke1p/ArbU8NhkuTvzGI1J4X3NvP70Bxe/P+L4nfUIeeFOJwWPnDR47Hn2PAW0V2kNmSavf7LhpZTo0Yp6ODlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 10:38:17 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> This is the PMD swap entry core series. 

Thanks.

AI review said a lot about the new code.

It also might have found a bunch of issues in the existing code.  I
looked at one (move_pages_huge_pmd() passing a stack-local pgtable_t*
to pmd_migration_entry_wait()) and it looks legit.

So can the people who work on this code please take a look?

	https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif@linux.dev

