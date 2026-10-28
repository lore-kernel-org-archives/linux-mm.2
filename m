Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71257606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 01:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RAAXiMn6
Received: by kanga.kvack.org (Postfix)
	id 78BBC6B093E; Tue, 27 Oct 2026 21:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73BCB6B093F; Tue, 27 Oct 2026 21:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6521F6B0940; Tue, 27 Oct 2026 21:44:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4065B6B093E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:44:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B5651402CA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:44:11 +0000 (UTC)
X-FDA: 85370339502.07.09DBBBA
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf02.hostedemail.com (Postfix) with ESMTP id 308BD80005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:44:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RAAXiMn6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793151849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1Yu6N42P3Y33cQOaPOhdbLQI9uq3/XR1N32rLOEFTg=;
	b=E+biX4iJo0K5IOLy7GDXQmnEzU2X7xbDEtZNj0zVoO70qIhjBxq9Kak+Ory6eXlDHWNzZS
	LOoxUGIVorTyjusUqajiUqBy+I6WrfpcGNCEARhS/KmDxiunW9qM9om4C4L8NyWe86wrB4
	Y+KyDq/oH/qUEGce3JNsqvT7sq+q8LQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RAAXiMn6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793151849;
	b=sqlLePEjBKvXmDEB0PzkeBmT4okgXb0u3l0aRMCGpA1TC4Qyj9RyU71cfBw75V2QYqpJsZ
	60SvvSPN6PGycqhQU4RFYeaHlmZidFjvLWq98d85o44Iqlk3cZAZ3VamK+GjY8ku2py3zJ
	AIY/KNfDq9PKzF1bE/vItOb0ax0q8+w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793151845; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p1Yu6N42P3Y33cQOaPOhdbLQI9uq3/XR1N32rLOEFTg=;
	b=RAAXiMn6qP/RV192I7TMssizvmDGYJMtx7aLr+jFH6U4SYlci7vG1qaDZA6SzSKt7F9hkPiNTW7xaRXrRSZZq/mnMsu5W8YlPfLiMyC0bIHE76skswcBfp/BsK+S435rnH/j3sornKoUGRhPnqUCRv//ee9hcj0zDTXESEv/8+E=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=22;SR=0;TI=SMTPD_---0XDfI.uG_1793151834;
Received: from 30.178.68.22(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XDfI.uG_1793151834 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 28 Oct 2026 09:44:03 +0800
Message-ID: <00410d2d-c082-4ef3-9eb7-7d7b5d3ba964@linux.alibaba.com>
Date: Wed, 28 Oct 2026 09:43:53 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 mkoutny@suse.com, david@kernel.org, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261013031221.1997194-1-qinyuntan@linux.alibaba.com>
 <8fe2314a-ec7c-4ff0-92cf-27f7f8c9c132@linux.alibaba.com>
 <4C44AE80-1642-4808-ACF2-896E4B84EEAA@nvidia.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <4C44AE80-1642-4808-ACF2-896E4B84EEAA@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 308BD80005
X-Stat-Signature: t49y87e1jnsfg3whidwmnb4f3dkfncz1
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793151847-506612
X-HE-Meta: U2FsdGVkX1/uJxPj0LIb3AqRq7Qd650TyJFLNp1fvNaMQR+jtv72Z6mD10JZJm3vTc5DVOjmub7jTNgPGMJ0V18RaMfAnF+2+VIoSFNf6T7YvhHNRxDlkfiXmoqH5UXxNsnLEVP1ptkshImd3pbfQ/7ZRRFQLuGYwdT0xfq3giA5ULoHHVemOx9MpM3KDzW3bfITIRxcObzztHnVQ75kr34qCHOeSCGOnrC0WSsYFdlO2iyVpuAaqLyiqGCdfUG0cZoOTZvDS5WgjxxokJ3nH1nJKv+RjDPVCG03l9+n75aN+vYNCX9HfxS8Pew9kdays5Fi1tfYdN5jEr1L7fE89TR96NjkVbwcPhiU6u6oT698eSere28Mx/LLkX9O0EgMN89oiohFd2drZX6wecuQn11Kdshk+5+AYzsqaHGjEzf3cI3mG4uImOtbXh647wh43RAW56p0jIWTV3h1eI5oBrOhdUClHH6GxbsujGGYeYU11yFf/N7DAs6x/BpcwpCc2saIPdnqdKXsLiIu+m7+NUbg3oOYYzu/FaA9oT/Jz0LtuWCHKa5ufidOPXcv8wiQQNS0VSY92154OqkmyoCYl4jnxOPprVwAjE9VEf/NgOUx9qSWzzPGVnl3LmG0370sI5hRIV3ab+MMB5THHn6K7XzeX1nPpocwjlIrn+BjAX8ZkVyhoU12zUR4ar8x0ACkyBSKYqH0zOSbzm8AU6hGx2LoYBZgzNqv5L1g19HfuJ28AtA+ymKblJh6Axj2cbAnD+RYaBybNSKAH1RrVyKtiiLTQFZ6xK325xomrInr2Nyg/MdXja9lQPuIIq79zpaMb0wL853yra1YSMsJjomkB8zQ99I/951D1n5CzHxpm+8v8pnj/yix9noCCwi3IM/ol1MF9hofj0aufyRrUA7WEXWMt4TEaiqkzRZzamH09tX05ldzQJ1vXMsSkJIkJmUuMoVHA9da7HVej1lqWZe
 +jhuTB+8
 EVYrl8fLVAybcKU8ljEh0+aSaByZAhqDmoere6sfLjub4XuvErPO7B70RQCESZrnb83/lS2MrkFMgtLeCSapwbUY3oQfzjgIS5+GGqXb1GQoTkBjxijlumrqsZQwKyOK8TIA9KgJBx3niiHLCOxkwXnyo65V+wc+g/6TjGUloIxBZ4GzlsZCeRrfYKNWVSadqjFctwVsUmAKYDsYCBCAhaQKaO+rTgOpYKa8Pgc5LchH9HwfLrJqeHdz36mmrPTlXspN1kDf4Mi3GwNrAJceZgMo8Y+IMCIXAhU8ubVobIP5IcRe+Uw9GPz5ZevMF1ShqoATLeTAk9aBxde+xQh4ete+/Yw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Zi Yan,

On 10/27/26 11:04 PM, Zi Yan wrote:
> On 26 Oct 2026, at 2:26, Qinyun Tan wrote:
> 
> People are currently busy with reviewing various mm fixes[1][2].
> Hopefully we will come back to this after the merge window closes.
> 
> [1] https://lore.kernel.org/all/20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org/
> [2] https://lore.kernel.org/all/20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org/
> 

Thanks for letting me know, and thanks for taking the time to reply. 

I'm happy to wait until after the merge window. Please let me know 
if you have any feedback when you get a chance.

Best,
Qinyun Tan

