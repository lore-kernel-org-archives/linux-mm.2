Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA77C624C6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 09:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125A96B00BF; Tue,  1 Sep 2026 05:29:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AFB26B00C0; Tue,  1 Sep 2026 05:29:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB99C6B00C2; Tue,  1 Sep 2026 05:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C60D66B00BF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:29:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44039802E4
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:29:53 +0000 (UTC)
X-FDA: 85164671466.06.926ADD4
Received: from mail-m82152.xmail.ntesmail.com (mail-m82152.xmail.ntesmail.com [156.224.82.152])
	by imf12.hostedemail.com (Postfix) with ESMTP id 20F2F40002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:29:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.152 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788254991;
	b=YpkzfyhyjSWJtwI1d4BetpCcwCytxZ8qT6LuQDTeYQPYNymVhlsPgsz/QUAhW7ui5UCS0o
	P6RhdyZ7SBppkJ7pg9TcrsLL5P5pM+knpZWSkKD2w80PunSy0f9ekbdblThJeOiUaWEFRw
	XVkdu0qRfZrUOQ+toLnUw22KnmKeG9E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.152 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788254991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mwViPoRe1BlelYURxdwnl4OL58oR8ddJNz4zBu7EIjg=;
	b=QcVZY2Dst5fA/8eYRCPeoPo3OKH1Rgpbyf5pjOuqXjbb1eewzUnFXTOaptokQaqtKl9zz8
	FQXC1pXFvl9zOVL7GJPo9+dg3FRTrWh4oGug+KjcsAtds6Dqg1/mpsqVaDwXlXeffPQl8n
	65nq7UNrXSOVl0i/nTTSCYJbzscJQUU=
Received: from [192.168.0.59] (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1e8f18a64;
	Tue, 1 Sep 2026 17:29:44 +0800 (GMT+08:00)
Message-ID: <53e17480-31bd-4c90-aac3-6542b88ffb95@easystack.cn>
Date: Tue, 1 Sep 2026 17:29:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup filtering
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
 <apEx0wT_hWs1Q5Wp@gremlin>
 <20260828113654.d01abd8baed3f73e87506eb3@linux-foundation.org>
 <9fce3210-3548-4df3-ae00-730b666f5d57@easystack.cn>
 <apZ99NHTmNI_nIwz@gremlin>
 <ff7d838c-8ea7-4a91-86bc-f6899970cdcf@easystack.cn>
 <apaG83-HCFTuASQ_@lucifer>
From: "zhen.ni" <zhen.ni@easystack.cn>
In-Reply-To: <apaG83-HCFTuASQ_@lucifer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa05c4d99040229kunm324655a22845c4
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCHU9IVksZGhhPQktNGktITFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVCQk
	lOS1VKS0tVSkJLQlkG
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 20F2F40002
X-Stat-Signature: dpqd7pb84b11rj31remo8ipb5ti7xeqo
X-Rspam-User: 
X-HE-Tag: 1788254989-847858
X-HE-Meta: U2FsdGVkX180pBy4TYn/ISOqDKA7e5i2dBKx8v1vBY7DvFikB3TVWeQseu5knPAOXhyZpC6dKfVdhfyX3c3oXdwP9R9lm9bOCJXQIR9Yc5eCt9vOGzwGk4EPI5kI/T2VdG6iVh5+b/fpeYCgbtfgA4lCuT95zWwcshXboLMt1vhFuIDbrDxFIKLad7nHkfBMqulkMGK+m8qHD/5mIMkk17+k2yKIaZJBncdpCHj78lSSz2TumlGwCe2bZ0BgIIgaCn61QQSwO817IJ0SMH7SiN56BOJjiO4gSXvTi02E5A86bzJhAxe0S6t/jnX0nI/pMHiDYTKS51G6lmxVl1odGTxDQJsXNSvu4xRtJbQQ6tLA4v/1CmvhnpipxA+ehQWZVxWbFU/yFumTaEjS5sQUWd4XVbuL+19xuz/CqFILM7bS2kOJawfzBKCqbf+R1Sz+u1nDY7+6NwIiQhVau3uMrR1OyADbpJH5U6DSb41SK7g+KdMrpo/fdDU/sd+QyMR6o1dd5TGtZEg6URfeGg2JjnA3SlRpO4sbN5NpZ9kHhE5Ew88Q36OuHctJHmicJOI6REYeMryTDiQF4pOg2fJDZmh3j3kcFbJKce7YUZM+O6zvtT3ISiIjr8bQYYHCsLOb4/HaAtlftyNlj5mAVNCH2cxtSOEbj0IrTmfXtar6zhnoVx7QEyE94+zY7wik7S86A+rHUKv/Ybzat9ZbPYuEokn+B6rObOXq3w1lg3Yw5suG8nvBOs6Yvj2ZmarjjalS48jqF+XbDk2he1+JlvSRa6vHkLSA2n8RSrQtpvDH1HVgwq57xkJAfFchNxM+vc54q2P8q3+ddm+4EQy/vmnczNGtwyTDTiRSzmUpxDcMFyzBV+gy1EAzTTckQlP2VnkLYTIs3DwatnKQvLln5LublrlM2UtKXg9/FCTzN4JMuzQraUXehRI9ygB2Cd8qoOf6SObWQ6nBoY+ZITLYq/T
 zNq6t0CF
 DZIitTmxmOOPMl/z/BgI6rhD1JtGm6gQcJzW3ePDTG5uBpyZiPNkEHoD21ZlVlFkx41HijnLdIdt7BFeoDcpFXQXY+fXVLrXtJ1COsEE+YGAw9byhLxYEDoQfJCZ2AIkXsSX3xA8y0kgq1jGJTJNVi/mzG9XbMyDgoumsk9gHNzOKlA1c5MDmqSpMYfvtLRP8fqeEEg4RbYjU3qsj71//Y/KX3aWtLeHHvoyM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/1 16:10, Lorenzo Stoakes (ARM) 写道:
> Again you're failing to reply to kernel email in the usual style, and it's
> on you to figure out how to do that, not me.
> 
> Reply, inline, to what people have said to you.
> 

Understood - my previous mail was indeed a plan document rather than
inline replies.

Sorry for the noise.

> Do NOT ask them to read through your 'plan' document and give yet more of
> their time to compensate for you not following basic kernel procedure.
> 
> I have done hundreds (>1,000?) hrs of review upstream and I have only seen
> these kinds of 'summary - plan' emails since 2026.
> 

The timing has a simpler cause: Sashiko itself only started reviewing
patches in 2026.

I would normally prefer inline replies to review, but Sashiko did not
send any mail into this thread, so there is nothing to reply to
directly. Its findings are also heavily duplicated across patches, so
a grouped summary is the more appropriate form here.

> I am only asking you to engage upstream as everybody else does.
> 
> Since you ignored it, I ask you again - have you used an LLM here? If so
> follow kernel procedure as per the documentation I linked.

No. Every patch hunk and every fix/no-fix decision is my own.

> --
> Cheers, Lorenzo

Thanks,
Zhen

