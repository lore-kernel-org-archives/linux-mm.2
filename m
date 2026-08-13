Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D32D0C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 09:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64866B0438; Thu, 13 Aug 2026 05:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3C8C6B0439; Thu, 13 Aug 2026 05:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B547D6B043A; Thu, 13 Aug 2026 05:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89CF66B0438
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:11:23 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B04714043B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:11:23 +0000 (UTC)
X-FDA: 85095677646.17.06D56B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 60F101C0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 09:11:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGk46W7C;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786612281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhXWTtJUsDomL6egy5QoaaI7sPJon5+7fAgN83W6CcE=;
	b=yqa9pqbUnhYat9DSIpC7hJuuRFfw4TzgAB4AurVBE2nC52HVcFqiPrcrCAwcZr0yBR/mty
	GfUhurlFKop9ZuXKkcEzlFKPV08CeIOG6u+ON7kMYuhcYoDoF558jVQbjQKdk7AcDWr+ax
	R2ZBVrY4JCi8gwX53/x2hlxMxHNTMCo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786612281;
	b=Sq+JmLGgDigmE4zkLxCLw5e9vl7ZBqoLKzUQ8gnBYZdbhKsfLlXeTsDBOJ+xuWgfH8IGWZ
	3oAISMCmtG0W9ioB+JcrFp/KBlRAfJj37umCf6x88VVkZ5al7i0ZjzggOOhHuEfR1NHxFA
	JrnqujezKNcjuG9U0PwzvIWGSXdegq4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGk46W7C;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A116D600BB;
	Thu, 13 Aug 2026 09:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261431F000E9;
	Thu, 13 Aug 2026 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786612280;
	bh=NhXWTtJUsDomL6egy5QoaaI7sPJon5+7fAgN83W6CcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cGk46W7CzHl87LeGZ183G7a45BrctM3x0Us+3/mOn9K7e9MS+E6OEnH64n9FUszCk
	 txrylxrL3gzurCwA1wyu9o329GqI1EmjsYo4h42Sl4fvy4DsaVntIWIvLRBdYK+xDV
	 BXGcaDm/ZYJNUhmFFPMhApu3xPhHQHk0z/2Ohy8DCJrcMXFuz44RYJWRVcTFF+32G2
	 y/NAueKR9EOHCtqPX6VKJ17/+GtZyVBn/QJfD1Hkk9ssqTXe/BM+TqaT7W4jX8H0jW
	 YPXNtsUZTQwJHiy2vGdrjHxb7NAgM+hvL7xGzb6IyEZVIWNNLYst/7d1Z3xHddlR7R
	 wJk2+bKmzKqdQ==
Message-ID: <837c2e83-ad5f-42f5-afef-5132e02fc19a@kernel.org>
Date: Thu, 13 Aug 2026 11:11:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/Kconfig: allow user to select MIGRATION if
 MEMORY_FAILURE is enabled
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, bp@alien8.de,
 byungchul@sk.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 liam@infradead.org, liaohua4@huawei.com, lilinjie8@huawei.com,
 linmiaohe@huawei.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, matthew.brost@intel.com, mhocko@suse.com,
 nao.horiguchi@gmail.com, rakie.kim@sk.com, rppt@kernel.org,
 surenb@google.com, tony.luck@intel.com, vbabka@kernel.org,
 ying.huang@linux.alibaba.com, ziy@nvidia.com
References: <0dc4a8da-b2e1-4eaf-bea7-070b38d6952c@kernel.org>
 <20260813072344.112797-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260813072344.112797-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: jfsab8n75r4xthi1tb7d17tj7abgbfur
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60F101C0004
X-HE-Tag: 1786612281-886857
X-HE-Meta: U2FsdGVkX18GfjOOctAa8AG1Tal8rKAz3PDAz1JpXwLEy1885dWFmLHxqme9Joh3miIcokZIBEOjhr9/jP6S6WRdNPsO+kBiLybRX5P7ttOKqHPmyE6OSVceFOzGCa2fAmoI/2mW0st4p34bIW8g+v+6HI9iszZD0b3XQO5utVIzJMtwSVHRHfLsd6he3loKlj0i8XgQN0zZRWztqbDszzfg7DPhM0ywh+1vFGL5BdbzUiqC0sbhUHi9vV71Kz668z7TdO1wOCt9iH1XtZpiGsfymU/K++VsOllMMNt7K8YNVViThBS6gUQD32RFCOLzveWK9VUjO/IVOpQOXW3nFG1b/jZB7MpsuGXEMRsBVtggM5iNiNAUya6MoI2CYq5LZhuNcYfBNObXewcoT4DqQU2Eupbc+u2ZfGdFNfHShm20dSLtskLfFDM00SB+62dZRLBOBS9PH5bAxEzKcCZmi51rmzU9mVU+fZ+UqmEp71ZrDH9nHQ71ibUdOYvVTCxqKbZLTjfvOf9Gv3kM9trAUV5Ybbg9P4eNyjYDP2GmNgwOWml7G0VV+VEYdSPA03e9KLNraOKJFvITof44BMMJJlmomsROTgJbbF0BhQ9NRAUWmKyIizSRpjO4GMZVJ/CPPHpl3jJjFUg6XWF+kL8vVp9tYFXfMuq4uZx4pAHWpdcX3jRL9KDZz7stGdaYz2nF8FOz5zABcWeK+89q0EmFo6iL9ysYfrRY9uD95PnBz12JSqGXvE4JmIMxTMV/Id4XnS6CSxMpGh7zjOXo/zpZ8+60PPYEtNL+ITA5MrkVHUTJe055wX/aztIL5K7uRnMQ+sw8tFCD2bGup1u1mpkEDVZV+LnRzg9DB0BegHmhS3QlkriYClHsxW//xnV4erzrYFz6y6lJ4L2/6XvQPMVYMZbQe16dQqLZh9x+q4OgxKhExqGn7EPvyyS1R3PqFcv63b2dfl8y8dBcydVtcO4
 o2WTNeTm
 Y7BgyH0FtAVYEqLGiMPAIHoiFSTLzeVuqtPbfJLfuRoJAwTf6s5HtM5gxG8KLMKgkvF2URegmveF5b3+AcijN/+JPnYGqhR/xc1VtfG4h75w4hgnzqK+5ybWGQ0CWwjQQqneQOPlLX1fc6YEq7Mn+jXzsaSo0xv0e6oTmn/NI09Vresf5ggAKXXWOXUMYMeXGc3YyQYYR4yDbfUHOIAVqfDpVxgXClILjIRJvkLAQGa39zrIN4JfYx8uNHgVh474NT89k4NXjbVv9ZXLg63/9xBy/140GWDb7piPOizFqPTC3lWY9VWQuPW0SJxxrQA5S1TrLvu+xrnO8AklqTD09q18aWlNi87BFudBW5KNaTQI211z2XOFzKblxpT50SR/zfOAH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 09:23, Xie Yuanbin wrote:
> On Thu, 13 Aug 2026 09:06:07 +0200, David Hildenbrand wrote:
>> Why add a new config option?
> 
> I think this provides more flexibility in configuration, when:
> 	CONFIG_COMPACTION=n
> 	CONFIG_MEMORY_HOTREMOVE=n
> 	CONFIG_NUMA_MIGRATION=n
> 	CONFIG_CMA=n
> 	CONFIG_MEMORY_FAILURE=y
> Users can choose whether to enable migration, just like what commit
> 6ebf98d71f9b509e833e ("mm: introduce CONFIG_NUMA_MIGRATION and simplify
> CONFIG_MIGRATION") done. However, it does add a new config, which may
> confuse the users...
> 
> I think that just making MEMORY_FAILURE select MIGRATION is also a very
> good solution, and I respect the maintainers' opinion.

There must be a good reason to do something fine grained like
MEMORY_FAILURE_MIGRATON, really.

So if there is a use case out there that absolutely doesn't want
CONFIG_MIGRATION but does want CONFIG_MEMORY_FAILURE, we could discuss it.

As really only softdirty needs page migration (IIRC), we could also just put
that under a separate config that implies CONFIG_MIGRATION, like
CONFIG_MEMORY_FAILURE_SOFT_OFFLINE. But I'd rather avoid that unless really
required.

-- 
Cheers,

David

