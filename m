Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7043DC9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FAD6B009F; Mon, 12 Jan 2026 10:12:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CED096B00A0; Mon, 12 Jan 2026 10:12:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCF206B00A1; Mon, 12 Jan 2026 10:12:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AD84F6B009F
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:12:40 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D25AD0D12
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:12:40 +0000 (UTC)
X-FDA: 84323653680.06.BDD6BF1
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F62A80004
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:12:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=LQCQ5efj;
	spf=pass (imf02.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 188.40.203.114 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230758;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YYOeAonOSx0MWhdZO7OeAWnJQ8quZuGJ6ofsjgtfNYM=;
	b=VI2SIJG0WNl5VJKT9w+8VRt/G1wLSHZh+8MnRIWfKbtiTNeLsZq9U46NHewgBL7Hmn3H1G
	vnsJYQJtF8+zbfVsBdEIY+22421Gj9NuCNpkbv+GYfTTokozj3m4ZnAapvHlEUqSf5jpig
	Xg/SoNDlFJ1ToFwHlgpSUuuudH346/Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=LQCQ5efj;
	spf=pass (imf02.hostedemail.com: domain of ben.dooks@codethink.co.uk designates 188.40.203.114 as permitted sender) smtp.mailfrom=ben.dooks@codethink.co.uk;
	dmarc=pass (policy=reject) header.from=codethink.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230758; a=rsa-sha256;
	cv=none;
	b=qEo6NVX26svFEXMTJme+fFfqYmMRYYFnTVBuWd60MNzBnxa7mLOCiLvx4pFgYtya39tvZb
	3cdjVCbpHzTn1MDOHlcembqhxZvz09+NzKtZkHIhWCy5ykxgiYlg54JXKG+btVmvQIWUua
	ISz+34zM2+lES+/YixBtSy6WrQwfias=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Reply-To; bh=YYOeAonOSx0MWhdZO7OeAWnJQ8quZuGJ6ofsjgtfNYM=; b=LQCQ5efjW4ZsVrhf
	DonAiasN6qtEWgnM7PXsHwu4ptqv0TFMb9K0U6ARXbguwtF1hPlaRthLqCQ4oABH4XPqaePWJ822u
	xdpNSGmOcEI8MQcPDbdTn6T/Eg/7AV88TjAXMJjxmpk7MOxomKmhkyVhuTheNz0/q6sR2kvvebmK9
	gXHSJIj+/EJpX01fG53rCBbG0sGLe69U4u6i9hVSvLiVIn1FY7zaIOoB+QidvPT5pfzSFm0GnON6Y
	LEaLMLm3qJfiXofxbrfnCkqn02PlyGTImHS+W4vJbAD3s80V1UoIR6MfiwGZh3ys60lmqAFTim5/T
	QpHEyH8fn9naXlfGBw==;
Received: from [167.98.27.226] (helo=[10.35.6.194])
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vfJas-00FNsJ-Hn; Mon, 12 Jan 2026 15:12:34 +0000
Message-ID: <bb039bce-03a9-41bb-a806-65dee5739c8b@codethink.co.uk>
Date: Mon, 12 Jan 2026 15:12:33 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: numa,memblock: include <asm/numa.h> for
 'numa_nodes_parsed'
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.or, linux-mm@kvack.org
References: <20260108101539.229192-1-ben.dooks@codethink.co.uk>
 <20260108105220.f1577b1c1709319e83760699@linux-foundation.org>
 <aWNnyDTTRoO2HKnD@kernel.org>
Content-Language: en-GB
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
In-Reply-To: <aWNnyDTTRoO2HKnD@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4F62A80004
X-Stat-Signature: su5p8hzucmsnrrwk8rbcqc45c97feuhk
X-HE-Tag: 1768230758-499367
X-HE-Meta: U2FsdGVkX1+JzZ6l2wKcHo56mntrZmD1CXmAFKUQKDndBmaApZMFVt7wbezcijvCGa+WpbPKLhwSjQS41UodOLIa7YRTb1J3w/I73LItoYXEf8DCEtoEF6hzy8wOub5zJBrVvz6Pm3uIl/QGP6qwPM7RgkVVQwjjOLYc2Y4qpjOYWbCHNcySazl5ZfL78br5DvDuXGKvg1hawY/2L+IfXeZqmvGdj59IfwWaBn4+9zuAmbAXT811ItjPbXTUyovV+kpUIKupkYikdl7FHLKsmZES596b5RkotPaeTlp2xXsOD/bEs+YFSbVqQHlrrn8puC1mzNkVYwyvIE4iyXB3ZAnCD7/iuLKdgaKBHJu6blQLtWLafY5aLGcGvtEiE1vrHMxUrYMaHnsp8omXqATJT+MaCkKFh75B3bAmZtD5DQFYTzhTgqO5KdEejhgoIiDRbTx8dMBq/yJ+z1upJX2Qm5PpEf4XSc45U0vzyC6EACK9h2sE2ssdvgPp8ogtDhUadCyw6q27qc6lOM0pf6p18xWIONX+dJJnpXu2iXrJ0UO3ze01OXDI2wZXRIGebkTajIfBTXAZuF3BFyEKSWWCN3Fc6DLOm/LRG1qgsLmjyFBH8Mh1rnVrL8Dorh+wRXDPHYHXfWN59kHczZnBzIb6mwe2Bl09plqcj0Gfe+27zlGVhUh7EIfDRRpbk/es0lg3nAMAYSTrzIFjZblQFweDuKGYW768ldIPrTmfOw8t+96BUJYi/n2gZRM4ikHnuvzCrXOPRVGetMNFLiHaELc4lvDL7v9IBh7BkotnHUehHl0w22tr0e5pJCTByOdipcyz7L3oIFS2q6RCrck8OtL0Ej81wEgc0orUy2LNLzwCeSJ0OB0UhoGC3Ds1wUAYQJ6DVE4JAad7ywli5K8XPTRRwsFourXF20YHY1NAsD7tA3wYDnj3+QPRYovigkwVqsvSUJ/t3oiuVE00N+yMz4y
 atdoZKuT
 CJSig3m1CTZfwx+1sXE3Ez34L86CC/MaGDKScb5PSIx7VP92CsdmLNv5w3x31KRT7uExPivKE6CCOmaby77lQcbd2x8R0V8CQB7mdi3Vs7DijQh27h7O5dn8iovun2tuzwzIigStRhRZD/yOFu3/aAWhTjeoPPX9vvrsa4S47mhRA+lY92eya6NWG9gOkA+TJyaT2O8XgutjYCmps+gdbbzbVx5PjFrAjJ01V0BQf0yeFrWwaYIG7LtfJREm/l0BEqnhxWwOqDnP39GxNnmgAVDif6gkvM0QckMHwkiivevYrIAIYkNfdwD9S1l04PqN7Gdz+fki9apaNFDS6t3UsK3uyyPkCUXNcI1Ya++sRAgBKCBSPI7r5QxrOCCmfTIZY51UnIoypuvUpFGkBc5/+HaOXqasuGY+K6R/0XliwES4Ufq0Tvec4tLmVqfx5HB2uzM9vXNU1VToMiDdt6xwfifTSkMHD7kmx4RmQIzlaWR6fsrXyCxaUIw1UH5KtSZetEUJZ9v53WA+RLlUBgSppDuiOGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/01/2026 09:05, Mike Rapoport wrote:
> On Thu, Jan 08, 2026 at 10:52:20AM -0800, Andrew Morton wrote:
>> On Thu,  8 Jan 2026 10:15:39 +0000 Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>>
>>> The 'numa_nodes_parsed' is defined in <asm/numa.h> but this file
>>> is not included in mm/numa_memblks.c (build x86_64) so add this
>>> to the incldues to fix the following sparse warning:
>>>
>>> mm/numa_memblks.c:13:12: warning: symbol 'numa_nodes_parsed' was not declared. Should it be static?
>>>
>>
>> huh, I wonder how that snuck through and survived more than a
>> year.
> 
> Probably most configs include <asm/numa.h> as other header dependencies and
> Ben's config does not for some reason.
>   
>> Thanks, I'll add
>>
>> Fixes: 87482708210f ("mm: introduce numa_memblks")
>> Cc: <stable@vger.kernel.org>
> 
> and please add
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

I think I was building the riscv64 defconfig


-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius

https://www.codethink.co.uk/privacy.html

