Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A18CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2478E00FB; Tue, 26 Aug 2025 15:37:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90D26B00B0; Tue, 26 Aug 2025 15:37:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80F98E00FB; Tue, 26 Aug 2025 15:37:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C61EE6B00AE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:37:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D7871602C0
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:37:33 +0000 (UTC)
X-FDA: 83819917986.09.CC1E60E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CEC0814000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:37:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756237051; a=rsa-sha256;
	cv=none;
	b=bhaU0bwMD0GBhXE2OjiRcqf+5lFrv4o7+0NEn6tWBrVrLaOuTx+/4StfEYAopdqwD7LdkJ
	bMyJnhizB1S2280WNdv4hhdsUUEw66nDHlsdgWBs3QdOSzrJ1QihKX/FkQrmUS9icJhoBC
	fagGjohmdq2lSVnU8bl5Jzfkp9SXpjU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756237051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BfGmMAoezQc5DK5kMx/5G44xYw4KZvjsu6kro4fq1cw=;
	b=bWcM2jZe6zD0TKwEqpBVDlCQdaZY5TByYTM8uoQg9l5sHeYZNIb6loDZuYYj8XsysGrVGF
	yooFCSDv+5+9g/8Psd8q9CLjJeFymZaB0VIAXoibE8D5BC0jBWsahTkdIs33ELcvG3b+I2
	ShaYB84HsXZMwuLLPjNxgsL3o3Tbg/U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2A0543E9C;
	Tue, 26 Aug 2025 19:37:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28118C4CEF1;
	Tue, 26 Aug 2025 19:37:29 +0000 (UTC)
Date: Tue, 26 Aug 2025 20:37:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Waiman Long <llong@redhat.com>, stable@vger.kernel.org,
	linux-mm@kvack.org, Breno Leitao <leitao@debian.org>,
	John Ogness <john.ogness@linutronix.de>,
	Lu Jialin <lujialin4@huawei.com>
Subject: Re: [PATCH v5] mm: Fix possible deadlock in kmemleak
Message-ID: <aK4M-2ZWN3aq7mwx@arm.com>
References: <20250822073541.1886469-1-gubowen5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250822073541.1886469-1-gubowen5@huawei.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CEC0814000D
X-Stat-Signature: q6psfumf5nscy8uikrwc7pb8jwcg6nxw
X-Rspam-User: 
X-HE-Tag: 1756237051-320932
X-HE-Meta: U2FsdGVkX1+epJjbBORE9hqy6v6HZPlCoYVtvvuBfbzHGI8kN+SYi1TgLLOK6NQpmHk8Rhf8AzQ9w6sEG5QxRScyLlGwIIutlYLCQ1DKvQpYiQpCCcrzWQqRIgQd+Z2SQ6HT0wDLgDgDfui6YOiy4aGSLTRoocPevkpKgXuin9YVDXZA6j3l9CRVT7kEMdzgmusbOdfiiCWCZWhyL0FWGemDyXZ9wltHe11vPgl2jyAHl05ZTYtOOfJlx1zXdSCBLGjVvq9YhhXo+n1R/rT/FsCf79LmbDPabUyIz2L1rsyu+ownqDy3pcJhq3nDVilArwTegMirlvpYAhwAng/4dEAJUKYt5WVqtvWCSQ+eg/sM6GjG1SRr8VAliBVVAQZPjtxbIGsf4Y23yBEMSjJB1xm6sHGPCAAWZAgpMOJhZqJKflWhbWSmazOkiq50JtHmEKWPKAzRIMOQm0Inj0+aGhmD0NZccrdr1rabuEPP/i4UP/v4k51g+V0dOSMObCs2YfaarSXJj0r2Q8QWxV7deTklkFu0Pf4Zyh2Pwk1ZMFO1UiAYVxrLPSpd+006UC+9S6I90UCD5QpIK4xc3BKgb9v23qY3d8cV45xRLDWgtaNn/4AdAPUk6T3tWwfo9bWCS3IxX0Ot0iAkldYSmD5iVTtjrKPH0mTVzkr+KopOkU7XxzyS+RBOzQ7KtHmuKdGG34gO5vlmqDro8ibJS5fz8d/WsuPAgX7K0WH5Efpp3oNQdBzwt/K5MCYJuR8GaRL7sd7v3LrP7Se3BEYzpzakAZE94QFKeg4CBTL0wl4+g1LRU8xFLj6NXTb1g39KRppKTebPJB3a/dpJTFMh4bQ2x518Cfy81VwSOSSolCc+eqcG+32z07gNxGifAZAdfwIkf7SHawAAC6ui7c1K2D4S+7o3/cVygAilICffjIPNVFj6T9cHbXVgdoOyImDQRvXc+OC0Qfdk65EddkWyYzR
 9HV2Inou
 i/L85ttV26MMAcnajCwGuXt50mVPL+2f6xk3rIu4bqwtI4Hv016thiXQobi++VoO2NCh729jTIxWM8Rdgc0F3bFQthzdFE5R7mNlEOM5AAw6m485sBkVURJ/nJhIOxftbVnAbGsxRQ93WOuVDLxX8Y19LHxdQSgN8Kg17NiQG5sUQL0Ch/GghG781S02vwPK067ymT3y6+wERmxsk6j5IcwgRXU+c3Y203hxR1WKuOQB5j4CPBHk65AvLtW0ce0iAENCKZ7u3SFV86I+vVyuHA65vGsvKCsK1dqKMRWI/02IxYGWzNnEbMsqtGCtfs3bBfvByb5jRyNkSBdTrijLNAV1lhwLwSQFEbtgTmXYI4fB3Trn0Lq/lEnuVtvS45pQXz/UR6/Ki81AioJPj1V4JPJ3B7of771GuxtLzgk6DNq+WIuKnDAeeSTMJEgqv+jn9lmzPZNx7ROlz1dujwFIb1udqZ84h554BIerim2NwaC3NlP4YrEYPN29kfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 03:35:41PM +0800, Gu Bowen wrote:
> There are some AA deadlock issues in kmemleak, similar to the situation
> reported by Breno [1]. The deadlock path is as follows:
> 
> mem_pool_alloc()
>   -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
>       -> pr_warn()
>           -> netconsole subsystem
> 	     -> netpoll
> 	         -> __alloc_skb
> 		   -> __create_object
> 		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
> 
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided. The proper API to use should be
> printk_deferred_enter()/printk_deferred_exit() [2]. Another way is to
> place the warn print after kmemleak is released.
> 
> [1]
> https://lore.kernel.org/all/20250731-kmemleak_lock-v1-1-728fd470198f@debian.org/#t
> [2]
> https://lore.kernel.org/all/5ca375cd-4a20-4807-b897-68b289626550@redhat.com/
> ====================
> 
> Signed-off-by: Gu Bowen <gubowen5@huawei.com>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

