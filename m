Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2E63CD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:16:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D990E6B0005; Tue,  5 May 2026 23:16:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49D76B0088; Tue,  5 May 2026 23:16:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5F0F6B008A; Tue,  5 May 2026 23:16:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0E076B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:16:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 475411206D0
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:16:14 +0000 (UTC)
X-FDA: 84735531468.19.8E34EBB
Received: from mail-m829.xmail.ntesmail.com (mail-m829.xmail.ntesmail.com [156.224.82.9])
	by imf24.hostedemail.com (Postfix) with ESMTP id 758DA180008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:16:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778037372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MQOL3riKKKsduCR+g8DIe2jT+mKOpCFV961eyNkzwko=;
	b=rbxFe6WBnOIVcjXdr7ZW+2/qSfaFSKk5F3U7MNRS1eABgbfT5ipjOB3XKJLZb1xpr9dqxW
	NXaFq8vIIpN00EmuEDpNSONXNsR0PTrdblnjKsDKRZhRausW5G2UA14Li9dPNWO76+cMlg
	bt9IJbKF3TVTlIdbUEjvY4BFv3mFzeo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.9 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778037372; a=rsa-sha256;
	cv=none;
	b=db4Nu1mCoKNUHLF5yzDtFVUI3oKzXBpP9Yb9P9NMw9q2SVR9S4OBlJp4DAwWSCRhqFDEpa
	vjNJAfLEoEuJtBN8m+eqQ52QDm0qFQ1u1/8wsNp6rXF2/pi7vERfPmzKidVrPNMAmOemlE
	nF4b8nn4UMYBi+ynp2+bYkbyO+qCtJs=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19bdc5e48;
	Wed, 6 May 2026 11:16:05 +0800 (GMT+08:00)
Message-ID: <0f0d9a2d-47a9-4150-ac97-83a92ce8c048@easystack.cn>
Date: Wed, 6 May 2026 11:16:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] mm/page_owner: add filter infrastructure for
 print_mode and NUMA filtering
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260430163247.13628-1-zhen.ni@easystack.cn>
 <20260430112245.be3189f09bd6a71970a74746@linux-foundation.org>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <20260430112245.be3189f09bd6a71970a74746@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dfb4919cd0229kunm77ae86b41592a8
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSUJCVhkdSRhOHk1MHUwdGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Queue-Id: 758DA180008
X-Rspamd-Server: rspam06
X-Stat-Signature: zr66f1j578mrwwe15jbmxiwbmb6qm4dw
X-HE-Tag: 1778037371-270816
X-HE-Meta: U2FsdGVkX1/aOsgJXHI06J/dwU3yssZ1TP2ysjAYrjqlbR61Bas/DLUjpKY/NP4V3Lk7BPUjSCkIbOEM73AE3l+Pze1rHEWT4H8ZB/N7ITZZhDWK5aN0XkuvTFGg5GWRihzVRuOlTdBq0huXjfXeqkWLt9VML8qPhhTTvhAi8iFyIcBJ9aRJ/Kjsuqur/WceqFEIdIbD6LwxlE1lOEDUpe1y9cyF2uijxMkAhUiL8KnBXt54qkXtfDRzYJSQOxpQf8GIubK9xRI8MOmleC6MQ0dMkl/0k0P9Tf7x9EFX4Wqfi4DKjHYhWwS0Wsv2Tbb115H7X1Vo4/5WWp3QI21VwJ+tfrRg1qoIkVaFLWOYclWlO3a4cl/Lvh1v/rpZuNyeTDStciKolEYqvUHnXMdfy7V+ewHCwpbo56FIo/mYpQR7DNyxg3y3PvJ2wdKm+6rhzWf8O7olAMXR3nkgCWDmEbCvft3Get9KbAzNCvTeQ4hJ1p3vFOrFpTJa7+FnxwSJDSZFAQ7cDYOJjVaTLBpHI3mcKpc0xzHkqrp4EPlTIRkN+zJgpuLRq8k3iqIV0TOYucjBpKiX2l5gBl5DY2xDwKiWVQBcsUPFHYdbTGunuOJgAY5pkAqQHTSIGXSxtpQUrBa28wwRfpUvSQJwmNheIySkSx/sCW6RwHk/lB+TvRKd1Q5a4pH3g3CO2kIE8g4+MQQGmAQonL2qo5BgQtIsLFBj4TbTAXCMJJj/baHlY7fesVOh7nDzGQfgXu4vyn/3CbBN0/8zNgsYiq3o/5mg8NzBs+XvSpmqfPnrJ+O3VCUXXfTbdnBITda/TtT0E3FGOIhfnTZRgCWHQna/1hHtHPf0sPyCunyZjUCypuIJS0yOdUDp/ZrErdU7jBUycQk8hxpCKXRQp5/1j8vzoNZZ2WNgVIM+R5lNmghvDRAgOo05YzxoSGT8LnHZG3l2C4nkEm2AdXQP4ZcNJrZ7xdb
 tL/kEynf
 I+FQDeAg3u+DBfzhScLyBCXJTYS9xf1q3qW8liCeCGA6Jxv90KeU9TZGqVNLXIATnx+zZ5dI/iq3efHuS7MDg0ob32mS9TA+qh4WJ4viCnedU/FSVtqyVQeaYyqjrgK9nTZyYSXmr00v4QBMkdVnuOvkdwMBjFfZ+OI2viRqrvT+3+GC0rrEoz03l2moYufpbrX1Uke0FSopJCVi/2EumdiBLeY+AwPHkx88ATVKE2YdMlhnzsw88MJYk2Vr7k1LDseZ5mUCI8ZSPAzGDG7XgNRA40fce/6Ng7KTQyhzDG/XaiMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/5/1 02:22, Andrew Morton 写道:
> On Fri,  1 May 2026 00:32:44 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:
> 
>> This patch series introduces filtering capabilities to the page_owner
>> feature to address storage and performance challenges in production
>> environments.
> 
> AI review asks a couple of reasonable-sounding questions:
> 	https://sashiko.dev/#/patchset/20260430163247.13628-1-zhen.ni@easystack.cn
> 
> 

Will this cause KCSAN splats?

While the practical impact is minimal (debugfs interface, infrequent
writes, torn reads only cause temporary debug output inconsistency),
we should properly handle this to avoid KCSAN warnings.

I'm wondering if using the __data_racy qualifier would be appropriate
here? Something like:


struct page_owner_filter {
     ...
     nodemask_t __data_racy nid_mask;
};


Is it necessary to evaluate nodes_empty(mask) inside this loop?

I'll fix this by moving the check outside the loop.


Best regards,
Zhen

