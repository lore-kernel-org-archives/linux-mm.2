Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1793CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D6648E000E; Mon, 10 Nov 2025 22:25:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADE18E0002; Mon, 10 Nov 2025 22:25:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EB638E000E; Mon, 10 Nov 2025 22:25:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 008968E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:25:03 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8637F13AA2C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:25:03 +0000 (UTC)
X-FDA: 84096884886.12.DAC30A7
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf13.hostedemail.com (Postfix) with ESMTP id C98B62000F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:25:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ogFJes54;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831502; a=rsa-sha256;
	cv=none;
	b=KE8C9i67aXnWsuezgt/32TOvEl8g3kLwa0D5p8G4+ChZbTdzr4NftMQCWu2Eny2RrasOmq
	PHlyqIF2kV7gH/I/FOCOZMI2RUSdHN0KA/31EhcVDwpELTwOuFc3yswtKIcMgg3EtDk02s
	osAxp+aO5XaznR2JWTszbZy8MGuorfg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ogFJes54;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HakIRat1LMkIofrDpBtAbKRxMTQrzWYviIUr8PQmSMQ=;
	b=puYLB4LKS7/CU6W3644DA+P/8BpC0q7Z8gQuI60HXeKnzumaEnAXG8VEMb9ebVKRKld7cB
	3iNmNseFSHhmTTpacPTjdDcQmD7Quye+mjOKPwxPqTLH2sDQRV61tlEY2KoTVQlTPO/P5v
	jIt+6kpMrM4K3/Dvj6ONRc2rx9KWsw0=
Message-ID: <1a6dfda1-380d-4e6b-af72-4e6257838c08@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762831500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HakIRat1LMkIofrDpBtAbKRxMTQrzWYviIUr8PQmSMQ=;
	b=ogFJes54pFGN05g+xE+mxRKl0VVn+YgldSLppe95wFlyb9aBoDjP+jF+JbbB1/Q27r7zkF
	YEawhKNCho3YnnN0yEOB5fjIk9iM8KO0D5HOr5PC8rt+yhSwKVoiQ7IggLJr1XK99JhtrJ
	dprOCkMUeB3Gj3cHItXB2SOg41/a2z8=
Date: Tue, 11 Nov 2025 11:24:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev
References: <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry> <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo> <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
 <aqdvjyzfk6vpespzcszfkmx522iy7hvddefcjgusrysglpdykt@uqedtngotzmy>
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev>
 <646pwrc7sxan6wlwndjyu7upx32fkd7bv5vqlut3tjt65eeyby@23efyxvpg2nx>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <646pwrc7sxan6wlwndjyu7upx32fkd7bv5vqlut3tjt65eeyby@23efyxvpg2nx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C98B62000F
X-Rspamd-Server: rspam07
X-Stat-Signature: 7ixoip3nt5fbwiwxjsraaas58yrugkq7
X-Rspam-User: 
X-HE-Tag: 1762831501-711241
X-HE-Meta: U2FsdGVkX18pDVqXfpVsrhuZiK0jefYRvZt/FMy3/IDb72ZV8JFTmFgrr8hwiHuuT/wtUPXAiO0qCK0+ofQDreeWjZUf2A7ftm7ma/8p8y5oi5aO/FXsd96iA4ZLjUX6W/igzKA6uL44lN37mvybsGVVz8tnncdDk3QQNKgPhxWrHzDh59180FapQxEm/x3mknV7xgwejjdmPQxjezrjxdSPWpx4o2Y1XZTL24MotPZJPWr55FMZ+SW/XnUo2vOR3g7uw31OVzEMtCbZZWEXRRigHQfAoy1rgpuRC134JEN1dru4QiOMoaAsR1RdT5FzcsXFsxV9oyC2ysYWVHyAjFJLwGajcY1tLtCg+sjYTfSAaAHfY5cyzZRIjJleAKhJTaZr06tInhLnR5eBPyDcfCYdfGIoH7c76BxLLfnFWa+LYbBIFJTEhb1ykB1iOYtEFf/sjXeGOgX+gFWT9SUJE9ENy/m7Fp0MxXmYbLHZQi2mzrrPkLSxttrOuTV7zuTFeVM+U4XLs+WHdwx/iqlp/h4sA3QfriyijwwUcMcciosMhNwVPi9y5FYvbj971HmKkNAWyA4XOQ4OoZT7Z5GLXlxYOtppW6NogSEtvL0tQOAel9o2syXOVKhCCdbvZIbVJeTFDwV0FDgpneCzj+yn4e+Nm20PUK8LManZZDhmjC+krWlYeP4dQGGhTtSOLDFBvWqL6yFf9huKzvK+CvX8urDy3RuM+M/KT9B0ZnfWoDvTQie0AqIptAE/ns664BIFh+OOB5Kwn14WMNXOyFidBoyJUSfQBLwtEC7ugi6C5O5g2ySyWU1iOGkdHMIE1GWlIJ7voSczXjiMC6S26UI+8qvN0JQYiQScRv9aQEQPJB4YSXNENOwq+dWwTuy4JRmiRQB3TSd9x8AmaOQ7JptyNkBHFFXxRVHDAyeY+bB5dKRB7E+GcMWeaZCDmozfVm6ONReWb6G1wSSKGC5FnbM
 HPcXr1/T
 cfWrDrxDAtFlBthyEfb88qaizc08hwXEKwSoJhmb7xjQ8O6VxdbP+J2RQagcdscUGXDdK/m8fzrMzve1wyBK23fq8yh0+x7x64ZEsMOUbCEQLvuu5jZ1NcoA6P5NZe0fNqxQTNbiPiVYJp+pzZ4QMEAEeBBERWAdnNX+WvgjtAe9A8ccnD7/yRSG/9oFSVFFG8ryVkzkdTSMoa34iLiGbrvi2JqpKJJAis/rEM6HlX/1adxDQgJDvooM5YmOHf11pTWXV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/11/25 11:17 AM, Shakeel Butt wrote:
> On Tue, Nov 11, 2025 at 11:04:09AM +0800, Qi Zheng wrote:
>>
>> On 11/11/25 12:47 AM, Shakeel Butt wrote:
>>> On Mon, Nov 10, 2025 at 02:43:21PM +0900, Harry Yoo wrote:
>>>> On Mon, Nov 10, 2025 at 12:30:06PM +0800, Qi Zheng wrote:
>>>>>> Maybe we could make it safe against re-entrant IRQ handlers by using
>>>>>> read-modify-write operations?
>>>>>
>>>>> Isn't it because of the RMW operation that we need to use IRQ to
>>>>> guarantee atomicity? Or have I misunderstood something?
>>>>
>>>> I meant using atomic operations instead of disabling IRQs, like, by
>>>> using this_cpu_add() or cmpxchg() instead.
>>>
>>> We already have mod_node_page_state() which is safe from IRQs and is
>>> optimized to not disable IRQs for archs with HAVE_CMPXCHG_LOCAL which
>>> includes x86 and arm64.
>>
>> However, in the !CONFIG_HAVE_CMPXCHG_LOCAL case, mod_node_page_state()
>> still calls local_irq_save(). Is this feasible in the PREEMPT_RT kernel?
>>
> 
> Yes we can disable irqs on PREEMPT_RT but it is usually frown upon and
> it is usually requested to do so only for short window. However if

Got it.

> someone running PREEMPT_RT on an arch without HAVE_CMPXCHG_LOCAL and has
> issues with mod_node_page_state() then they can solve it then. I don't
> think we need to fix that now.

OK.

> 


