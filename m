Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD19CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F53B6B00AD; Wed,  8 Jul 2026 04:19:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4196B00AE; Wed,  8 Jul 2026 04:19:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76CC56B00AF; Wed,  8 Jul 2026 04:19:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46A126B00AD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:19:07 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D0A6D90E1F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:19:06 +0000 (UTC)
X-FDA: 84964909092.10.EA08242
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 189F4A0003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:19:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdvyZCiv;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783498745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ibv7LCs2MM3+w/kFVTxR/YXvtZXmrajdpEtg3xzhNI=;
	b=ckT7ggeSxoXRQQ0w3ovhSGsS+I76X0vm6+jNIMENhmvpprWPSJNhyN/FcIsGYOS+OOnJDa
	+GDi6HhMvDamkFe6wATcrmV64zKIX/dPWeiQ2M8Il3Imd/fF/yjK5RAb5C+xir1FkHn4Jd
	+DFbx3a9DDxRyQqtLuWDP0A8ctsSd6I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdvyZCiv;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783498745;
	b=2EHqXJrfiHXIH9F3RyCsPwFqWVcEGdAjzsxLucHgtPelPrq+LYd7PKU/AM5yavyqrnVl01
	8aZkdRzrjY47cilmyq7rmOWvZpi9slUuFJDgoJPAlTecRuW9SwV2kfFbq8oUqX64lAVZZU
	HGFHTa+1LxYGhog9uEJd5lZKV/drZ1k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EE5F439FE;
	Wed,  8 Jul 2026 08:19:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0161F00A3A;
	Wed,  8 Jul 2026 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783498744;
	bh=1ibv7LCs2MM3+w/kFVTxR/YXvtZXmrajdpEtg3xzhNI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=QdvyZCivxwxR0DFbpJ1rgXihEOh17TKP220D8PE5i50uviCdTcweWA9BRXhJZrrtE
	 jxez042LVDm0uhhANf/fDYgSKifyLhsfhUCTpFGKhZ1jb8G2bbfIGWXsJ2a46rXDNT
	 SiFDqt216OJiwUS6Nr0NsKBZXCuWq23BUSehnAsoq28Fwff3N6j9/eGHvcDVXLnTCc
	 inH+VvhGivBL7wQiWxbDH7AgMaX2WsZH0c4Ap31INrrz8vu6opOLC35dX7o7MLOtvt
	 HwvgAJoclfP0kbGSytvjaUoB2Gb6sMJKxoPljtj/tGOku2i7/xdo7sWVXLIekkjg1B
	 MXvzn4BWOSP4w==
Message-ID: <5c73f9de-01c9-4798-9c08-960ad6435476@kernel.org>
Date: Wed, 8 Jul 2026 10:18:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 00/13] mm: rework anon_vma and remove
 anon_vma_chain
To: wangtao <tao.wangtao@honor.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "will@kernel.org" <will@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org" <kees@kernel.org>,
 "luizcap@redhat.com" <luizcap@redhat.com>,
 "zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
 "kas@kernel.org" <kas@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>
Cc: "hpa@zytor.com" <hpa@zytor.com>, "liam@infradead.org"
 <liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
 "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
 <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
 "jack@suse.cz" <jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
 "harry@kernel.org" <harry@kernel.org>, "jannh@google.com"
 <jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
 "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "matthew.brost@intel.com" <matthew.brost@intel.com>,
 "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
 "rakie.kim@sk.com" <rakie.kim@sk.com>, "byungchul@sk.com"
 <byungchul@sk.com>, "gourry@gourry.net" <gourry@gourry.net>,
 "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
 "apopple@nvidia.com" <apopple@nvidia.com>,
 "pfalcato@suse.de" <pfalcato@suse.de>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "damon@lists.linux.dev" <damon@lists.linux.dev>,
 "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
 "ryncsn@gmail.com" <ryncsn@gmail.com>,
 "jparsana@google.com" <jparsana@google.com>,
 "dvander@google.com" <dvander@google.com>, zhangji <zhangji1@honor.com>,
 wangzicheng <wangzicheng@honor.com>
References: <20260707063308.29176-1-tao.wangtao@honor.com>
 <08c001ab-320f-4676-830b-8e4ba6a05dee@kernel.org>
 <b00a03d62c53430ca22b3f3c5e5327b5@honor.com>
 <0e8e5a28-1111-4b81-b04f-b81e749eb3dd@kernel.org>
 <f640c89d9722462098bf1b7a0a6854c2@honor.com>
 <66e8d008-5eaf-4a9a-9cca-e9b2bd8c9f9a@kernel.org>
 <104a258dcf2f4e4387199b62a66141a6@honor.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <104a258dcf2f4e4387199b62a66141a6@honor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 189F4A0003
X-Stat-Signature: runtf3atjiutcrnfp5dcjuiwqbb6f6g6
X-HE-Tag: 1783498744-96342
X-HE-Meta: U2FsdGVkX19RnwFrZWQf46xmBr9qk2XDrAH2okbos87MDCVNihvQRFTN71adqi0B6UrQslOqZVwXUbQSnZNVmu2NPqAhUA5ECTAwLsN96ZMJJTHdtw5M/lt+a6BTMENsmB/ftpvQYu30MjYC/fmpzzY4DljSVP11vURP6sL58e6fV6vBp49ZmjzGccSWorVsA7iVvD7nC2FJlKtAZDVq0CebeEK+Ef7g2ClJoyNOZSnLBeDSIBdCq3jrh7ZSjlaLoOvgq4qDwEBCHOux3cUevizjRmWipOGFt+ws5z+O3UwN8t2t5YsV4+YL/yv67eP1fvrV8QWIHjLoEor5V+xT7sr3oJfl5NjfnfZe7MIw+fBGErcE14DJ4Lc1/hgUy5akTYC2nTnJicXAxL5GufyFMYJEfboIJvm4O1auRbDHMKWvQAIyy+CNVoqdIksUzwPhbjG6HUbXChFQa/IzhIwuijnZWI0n3QorwCCFzr4ssauXqkH6hhaI2moHIfDpj0TI390+GfZ9a+G11QiN2U/AYTGnjvJgvEdLvCFAEXhBjEt1F5kolpjb/7w9txM9gqBR5Q3ZwwNUdJ8O6znoFQPY8LnDwZq0SjdNEC3yWdRdsNuF6Bwpgq7XERfw9KuxuSXH0rJiZLza55xEX4Ku3C1KIbSrVEiSxTRMr4CEAGsGbMAbbg65iCY6efvsAtg/hpCle5i9qUkb2spvbedl7+aCe7vt7JCXqz0Vn3hrLoh9hOWg6t/52D5ZtxuI7Y45WgXjRoq/2D5/bKkDvhE0D3lKOlqEcO+45E0PMxZt2aGcQM13UIr9qhUtHr9Bs66Y7hhb0H1Y702WxHjPRFr1XJ4UQ0bJAA8o5ep13zP/ibOgbdpaQ7hsUjKSSJpApx0l5EgdJVoiNToXcICDq4Fgf9V0jnSc2VBAIvSb4SQlrJH229gK2fmtUaKihK8yELOpEKlops8v4HAB84op9rD9eXC
 KSsnc1rM
 ZVt4QvMDQSQ52XBLb2SYo5OrhHf1SWDe8t7ZMOjBaT3qoM+zinolSmNE61TuY6y54rMvXRC7hYxWvEqgVckIMp729qHyFWD4CbvYJSCin+0IzjYBsO+x1Y4vkbyhUy+25czqEzBYVzIP5NrdwqPSmuB37XceC4ZHBDMLQ+0dBnEQpTul3ReNKjotdn7dzPgIFJYnBteFIB4FvcQz+E4gkFNLb/dlaDXMGfK1eFyYBZXjRw1V3bLuxP/A3jv1vq//UdjzgIHRkDzQgyVA+GWTDb1EEx/Ef9wQYLskJesaxcPELL7qQJ/NChZf3e7pB7k18diQfsgz0AIt8WkCUrfIs61/fX6Sy1OUj+3sN5+5rR8s5cFd7PbG0BduWveDqGkD4NRgw9F+3OlJlFeTzX5NADDKuYMO7niUzC6NDnSlZsLFpPeDqVU9Qi0hpwAqNHmo5zpK4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 05:26, wangtao wrote:
>>> At first, I thought I was the only one who found anon_vma hard to
>>> understand. After reading your earlier email, I realized that many people
>> also consider it difficult to follow.
>>
>> Right, that's how Lorenzo started his work, trying to replace/remove
>> anon_vma entirely.
>>
>> So I tried a different approach and implemented
>>> anon_vma rmap using a simpler doubly linked list plus depth mechanism.
>>
>> And this is what I don't understand. You were told that Lorenzo is working on
>> removing anon_vma, yet you decided to work on + send something that
>> reworks anon_vma?
>>
>> Also, I am really curious about your expectation: not having a single patch
>> contributed to MM, even worse, not a single RB tag or anything, yet you
>> rework one of the most complicated part of MM repeatedly using other
>> complicated approaches, and immediately start demand technical discussions?
>> After sending an absolute horrible v1?
>>
>> I really try to be a nice person, but really, am I dreaming?
>>
> 
> It’s simple: optimize memory usage and share it with the community.

Yes, and you can work on whatever you want, and share it with people as much as
you like.

But RFC literally means "Requests For Comments", not "hey, I hacked something
together, maybe this could be useful at some point".

-- 
Cheers,

David

