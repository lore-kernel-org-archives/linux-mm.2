Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26C6606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 03:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C233D6B0970; Tue, 27 Oct 2026 23:28:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5086B0971; Tue, 27 Oct 2026 23:28:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEA406B0972; Tue, 27 Oct 2026 23:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88C5A6B0970
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:28:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E52A80B70
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:28:25 +0000 (UTC)
X-FDA: 85370602170.23.02E4F67
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2363040002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:28:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793158103;
	b=Xwo8gs7ddnqok69obP3sdn62tuNFDWiTI1t4J0vUqus+ObmjYRAXimaCW1I1vUD6fIvbKn
	fk/PEgJDwuxUszbkJW+c3E7jmtfaSyJYNGgxZSfPdI4CCfspnZ0Fe7k/6bXa19OQTHYhe9
	IwTPxJMIdIoh4CSgJ5n2PnZz3hZs7/w=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793158103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YJ3VR/lK3Ypr21j50V93yJLpph7b+1DNy2JoCt6wc8=;
	b=uiWTjfReOLh0S6aHREodBXoBJO7qUAd8tno73yG4FtG735rQ8lfMChTSIca9NEdJL6OH1B
	gu66L6V8aRA9+C8e7vVlVShUQHgyFklfnCllBuXlySLoSx3EcA10b3FRMr5L83iiYnDDS2
	IkkwtfO4D2t3wgURoE9KWjJaZQOY2cA=
X-UUID: 9af36daad27f11f19a56ed5b684f684d-20261028
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:31f716a8-b266-4c03-b4bb-6ca6c94775cb,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:6,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:6
X-CID-META: VersionHash:7db8b62,CLOUDID:8bb064e096f5666a3dae38e6f9f026cd,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|136|865|898,TC:nil,Content:0|15|52
	|99,EDM:-3|-100,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9af36daad27f11f19a56ed5b684f684d-20261028
X-User: wangxuewen@kylinos.cn
Received: from [172.30.70.102] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1539901823; Wed, 28 Oct 2026 11:28:12 +0800
Message-ID: <4496ceae-5973-48c0-a2a9-7247f59de9c9@kylinos.cn>
Date: Wed, 28 Oct 2026 11:27:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/shmem: trace swapin results and order fallbacks
To: Randy Dunlap <rdunlap@infradead.org>, hughd@google.com,
 baolin.wang@linux.alibaba.com, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, corbet@lwn.net, skhan@linuxfoundation.org,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
 <20261027094014.2432692-2-wangxuewen@kylinos.cn>
 <f34f14ca-21bf-4ae4-9e7b-da7f72d1b134@infradead.org>
From: wangxuewen <wangxuewen@kylinos.cn>
In-Reply-To: <f34f14ca-21bf-4ae4-9e7b-da7f72d1b134@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 996ww3meimtxs8jjfc446kcxdhgcuoa4
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2363040002
X-Rspam-User: 
X-HE-Tag: 1793158101-381636
X-HE-Meta: U2FsdGVkX18oQymY/s0xopjBPTrBlQSuaU/W6bcrUZanYo9a1eWkaMoK2Mu+r2MC6CXgvyDKZqFO2ig0vDXdcQGLS+2xMrNAZnOp52koD1WgF/JCUIpdCTk1goOsYBK5FvzN6LSy4tTdn6iylSKwlIb0gX1NYy/sThZAgI9GDJnlWIL8LZxL+kpkVzvwuc1qn10sLJm6zSO2IfMTc0vHqWC/1Zq5Iar2SlqyDG00AiWxJXksK+lcy8pbiCMn3BVvtamcD7T0rsJyPLoIpw8o81QSANLewfP1cn9lClKE8eiaVGqEt78m5Dk+CX577hyS0I2xVWFICGV8XneUfPY6XFl9bqirompBil3L0z03HwYjuKyAWG12t468bI9pH8mAxhsB8nZhUySGg1Mp3Hn1eRlH8rAg8OJyBLGzl/WL3ldLNyurGsSC86wUOIrbf3EiBMY7KDGQYPKaELQSqVui3zFzy9/sV6tExVxhopIPtKRxkHCy0ncOQz3QU4wZ+8AfMo4bavnI2ajpQCkWTXTq4lQh34UEX0Cw6566y3E/fPFb9N01J2r7ZE2LyF6Cv0MCVAxeZrhbOnQwZZhQFNbFctXdew+1Ohj32rEP6wsjmHNVd8j/PNddGcDasE0Ph8eyXmpUSBQsNZtdQVOwgcMZqSyVNm/RuQpsCyd8PAT1rGA2Wi3G/XJ/I58H+whNXNZ4IL6XknTe0btPT3mGP8gPpJzjlQZPYF8Yz8gAZ1CxrQ8Co7RoQ6s2q4sbq1q5qg1/NwN5UxfKRcHO0xSKY9odfQWazmaWzpjKAxIV6O38YcgwZtKRozuAW2i2R6uT/1SvHL/YZ2HOPd+4/yW97LEZgRJbEURR+LrVUJvAmwc2eD4xF363H5O7+JSuDnP9DMjUzOBlYXf4QI6/lttDJp0mDPjeGA9QobnOtq5zEmbg8nWo/uBsvZTBtkjNGfeBSQXGjXFsrLk2Sks0eWClzHg
 uLWQZr67
 ItfSOukW5yePJt5TrLKIxEk8pH/2JqaIJEyZLObCT9hyuc5E8RandmRmwf5ujEG4dPDtG10sBx+iJxxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Randy,
Thanks for catching this. I will fix the title underline in v2.
Xuewen

在 2026/10/28 07:55, Randy Dunlap 写道:
> 
> 
> On 10/27/26 2:40 AM, Xuewen Wang wrote:
>> diff --git a/Documentation/trace/events-shmem.rst b/Documentation/trace/events-shmem.rst
>> new file mode 100644
>> index 000000000000..45da82761360
>> --- /dev/null
>> +++ b/Documentation/trace/events-shmem.rst
>> @@ -0,0 +1,73 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +Tmpfs and shmem events
>> +=====================
> 
> Underline is one character too short:
> 
> Documentation/trace/events-shmem.rst:4: WARNING: Title underline too short.
> 
> Tmpfs and shmem events
> ===================== [docutils]
> 
> 
> 


