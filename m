Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3394CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18BCA8E0046; Mon,  3 Nov 2025 03:46:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13C788E002A; Mon,  3 Nov 2025 03:46:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 079338E0046; Mon,  3 Nov 2025 03:46:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EB91A8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:46:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF41713C012
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:46:10 +0000 (UTC)
X-FDA: 84068663700.14.F3876CD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0B58F140005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:46:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762159569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8EBG0cAeOa+rJ+Hd4u3oMDqYsMEeVpOobbNDC8uWFOo=;
	b=wGLIDExL5Xn0h6w/M1GQtckzXWgLVqSV5lEOl/PtZc9vx1SV91EFIwuzPEDSVor52h1gHP
	gzCkuFYZa/nSJ9S8F9ctNvW3Q6MeUQWlrM1zzGdgDH9BORGOJYmGdvPG9GQ+Fa/FDpEmlz
	Eac2OR95jAoDk2Mxr03NKowTw4PKHKs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762159569; a=rsa-sha256;
	cv=none;
	b=ERf1S1Z29pSKiL8IBcM83Lme6zcBSvGiBGzUr0doTx7JcSkaD9GkDt0RrylWf9pp2iZx6b
	ZDJ3lrVxme6G7UuOUSGFLsTeLESofmVCjmwpkkP2Gsj0lcMn2uRYzCKfDB74TY3EFPgu1o
	WL1NBdMmF178Q0ZIkp/dUpe1Pd47U+I=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5E8F128FA;
	Mon,  3 Nov 2025 00:46:00 -0800 (PST)
Received: from [10.164.136.41] (unknown [10.164.136.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 90F333F694;
	Mon,  3 Nov 2025 00:46:06 -0800 (PST)
Message-ID: <99ae735d-a412-4b5d-9890-b7c03cf02756@arm.com>
Date: Mon, 3 Nov 2025 14:16:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/debug: fix missing space in case statement
To: Zhang Chujun <zhangchujun@cmss.chinamobile.com>, akpm@linux-foundation.org
Cc: vbabka@suse.cz, linux-mm@kvack.org
References: <20251103065910.2196-1-zhangchujun@cmss.chinamobile.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251103065910.2196-1-zhangchujun@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0B58F140005
X-Stat-Signature: 5n4hswsfsrnjpbemgtpnrmxqq4pz7jjc
X-Rspam-User: 
X-HE-Tag: 1762159568-445073
X-HE-Meta: U2FsdGVkX18ntOybXhl6PpljqQzx4GV+yHBbOUNluunzgQJESevGXPsyd/V7xWiU6NH/ot9gPUbbG8QiaCsPTnvQAQ5YDB4UBaceKDSR6dwAyqkyW/Mx9aIYoAn/XGrsu1NXx5Ll9j8k59qOESwf6YeHu1+VeqHq1WrYd+c8VbqOi86OYBtgYDtX7x2kvpyv1Am5bDwsbaxUm1M3kRviVfylIIAYAZwIQzgrmCdKzPXWF/b+tMa7BCGRafA+4sjD4SxxAGGNkvvFlNuApPyzxt0dUMpWHEaOprXNEXcAZT5/aJzE3NlXgyJ20xb25ArcY8RPfMHo+IAOtE8hWRky2ug2n+0B4YkSGWXnLRUqafBLd2l2ahJEnARNt21g+BFtvl5HZnOff/8juc/efuZTw/UXgalur133PAS6oeDRYtH9MhOFBmdpK6sDZgf7GEnya177SAxCLX4t1RQ0mmjf3FX3Eq9lBw80uS21nNunIn0WlOiPEpQu08R5fLywz7wGPla4KFDaGBcYpYB1eeLbqsEZd7CTbOmESjFNXAcfxJ571SOdYC33gu4H9jfL57pvh3fSPSa2VdZafXO92uIgPX7YzF7rl5/oa6C3LPV75QtrLPbg5yUqvHiXgjqDgGYqhj+q3ZRXMwQa/0PTGojwuc6G0kVIgzt1klJCFOAbC/a0OyiCT+YWJ8USWPEepevgw2p7O07MAsIFg+WxKlw8iCizGnOOe1qfFRpEGLeVRPzegPBU1h8XpKUZJZdDGRMM9ukO0R0C+7v2d0U5oqZVVRb1QLB1gDKsDssego/rBl8u4hrp/3RaL9Y7JWMUf69qeFrNEpLJ7aDE2X9iMz+0v5VnZQ9oZJujvDHBrDm2T2KnOBZjhOI6r43mMxGZK0Wv4UhFx4k0DuJaNVL9tGzen/I3SfIgr1dhWWP3OvllY0gmeprdREHrsrNZbGz7rPVy+qYCTSLZRtj6B9zk+XW
 AEn6EFeS
 bErBD1qykbPevsZp+Bs4pJ5j9U+in5dzkW35YXVfrG9GTN81C7Mm//SOsbJt+ipG/XRpmUU50GuFIdzqEOdwqSkYDwbIPdZzdWAjIDmgAZvklFcOKqWV3HbAKhMSm4Ff9UmWUTx3gM6JvxOCPuqNOedfMG9RhiGwe7nJXFAyQLiG9RzlOk668G7s1yoFYOA1EkiYRpFpLjgjQMSb7LrS+0SxgWO+UbiNdOidz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/11/25 12:29 pm, Zhang Chujun wrote:
> In the setup_vm_debug() function, the case statement for 'p' option
> is written as 'case'p':' without a space between 'case' and the
> character constant. While this is syntactically valid C, it violates
> the Linux kernel coding style, which requires a space after 'case'.
> This patch adds the missing space to comply with coding standards.
>
> Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>

Reviewed-by: Dev Jain <dev.jain@arm.com>


