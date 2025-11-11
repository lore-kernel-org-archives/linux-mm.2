Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1493CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0D28E0007; Mon, 10 Nov 2025 22:23:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8228E0002; Mon, 10 Nov 2025 22:23:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5088E0007; Mon, 10 Nov 2025 22:23:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 324338E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:23:51 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D289012CDF7
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:23:50 +0000 (UTC)
X-FDA: 84096881820.20.6791213
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13852100002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:23:48 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPsgop1U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762831429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dRsaTINzsimOU7sZV8eoCiJrcZgmp+6Lp0gB2Wv5aQA=;
	b=ppmo3ITufjn7HTmUoOZ09M1jX1yJQsztXENQKvWRt/kcxQjEzi4M/S+7O1emglDpnigJ1j
	e6DADD8/TWy30gnsMXtM3+Wgn0Y9ade3W3sxu1lsaEdiNQTWrQKlzNGSx+h0Dchc9YOJO/
	cHZjhQqwKuKJCJcuzqjfRJDI0Cdpwsg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762831429; a=rsa-sha256;
	cv=none;
	b=UYMlZnewaLl7xlBqBpWk+pD18JfvrVAI8//N0cdUmWtAEJxzF2Lmha5+C8atxSLeH9YYmi
	jYSXo8sN6AebestVc5Luk/POyz//G9Q/fO0rvubd2QW07ydESuT9GAPOP9qSugRB6ejx6N
	ZXOROi3Z4GzJuJdYsPvwJ0NXg69GDVI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UPsgop1U;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <8ee2e132-6f80-4da5-a03d-820e4031a9fc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762831426;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dRsaTINzsimOU7sZV8eoCiJrcZgmp+6Lp0gB2Wv5aQA=;
	b=UPsgop1UdM6iVCJKMcwkLQQY5vs0SziOL+3tJ/VISeF+lny1aY3cMPROrx3D8xU1Knz0m9
	plXApivp7nUGBs1nBOpcQsteaD4gZ2IUmuGCzVATmlxxRxRqknAme7SMVjU/wDvlKfS9zp
	TplEvHow7j+IYgpq+bQVD88BJ3XJbYM=
Date: Tue, 11 Nov 2025 11:23:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
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
 <8d6655f8-2756-45bb-85c1-223c3a5e656c@linux.dev> <aRKqm24Lrg-JnCoh@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRKqm24Lrg-JnCoh@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p76qprhk9okmz9x6ar81si5rhjw1wap4
X-Rspam-User: 
X-Rspamd-Queue-Id: 13852100002
X-Rspamd-Server: rspam10
X-HE-Tag: 1762831428-615909
X-HE-Meta: U2FsdGVkX18WbC8MOXXk1Si2bk5Me9GZ5mvZtAA7uv3fVGsmoDYJV6qDik3vxYRhxt7BoTh64sE5/SIEuWqK3dRld4hv5mf9fkN+RgI0tQrXaZy9jphbEe89VakB1Etoj666sYqjjgf6qblQnzuxvdY1VnUp0Gpvx0BvtplPP3+Qu5D/PfuKkU2jh9pTxVTkfhzDiyEMOpoHZAVQT7qG37NHGGCXAFTmXo9NHWvKEyS80SKIlBd2v2d3bg4Y9CQrjL4DScXmHuGUY9FgIDboGB6CMFmK3Arm8klMdJMNH1UiaPoYKb15FMPEfEKk2oWOBEO+UTgs7avcOtOHbLzwfAlznp1+cIiSX3m9tJFguCWYv7IZ6rxPMi4HIxPPOndji2JUDV3Ez68RZFCq4MYmGxPA+vI1vEivuQybiDVoVbndOfg2uDFjhrKuN5at/6QxLWTK1uZNVLk5Jvr1c7+Uc1XFyp5+HuRBXON/F7Lk09T4DSyLQ4vDsdV/QZ7mT08jd3gd5sV/8Q3sKaKdVcZNIbGBApkun5asTwM7MRYYiKTlvBFPYxEd+SuepmcSlLHTE8qb1nZ3aivn+Gn6rKH5b0/MSK2MRKznUZlVUuI+6fkFt5zVXXXxsWebe6E+JOu22lpQmJCWOCX9clrCzqIhlbD7+ZtY4UGhRtZdJZ7ys5TiNmv/hwuMLILHuimM7eaFoDeLjiC774RggcOwhuQSv3KSc6n4OHuEByNuhtvC6aPX5Bt4HzZdwg4feY1BUQKId+vO3unwg8EC4gn/eEyjQMYxBxzHaN0xUX70QeJwJN7YVYCWrVIkSx5iL68RVHDEHx36XUaPvebnIq109PCTwOWB2yefJ/zhS58z6GT3etxGAQESYo3vcpKtW928+vpXaDBAyUJgSC8bVaenywdRrMqb+cxDnTB8VVuRKH4IcxC6Ewks6ItcDfVb/KyhudAEGpfM0vnSYISeyU8PUII
 7iNGRP39
 YpkkwiK9pCE6i7f2ek08ZeFxhgHer5PNz67WZITyMtTnOlBQ/Qpt2tUbj2li3WLqzEUYvoY8Ov0z57sUhLmpBAwPOONngKuI+d1CcpAlCqq4vOTEq3KlQz85l2//IlLWTJ292j8q7uj0UiUVehZQ/mO9EiQSZZlPEC4FQ/cbS3AOBXWtIapFk77bojdcfPaeCJQYKpcjhmlmqUMQEy4MOXrWMoI1u+D5MSPcZJcuOJW9BqzDJVcDpAVEprvtHwma4dIke
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/11/25 11:16 AM, Harry Yoo wrote:
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
> 
> Hmm I was going to say it's necessary, but AFAICT we don't allocate
> or free memory in hardirq context on PREEMPT_RT (that's the policy)
> and so I'd say it's not necessary to disable IRQs.
> 
> Sounds like we still want to disable IRQs only on !PREEMPT_RT on
> such architectures?
> 
> Not sure how seriously do PREEMPT_RT folks care about architectures
> without HAVE_CMPXCHG_LOCAL. (riscv and loongarch have ARCH_SUPPORTS_RT
> but doesn't have HAVE_CMPXCHG_LOCAL).
> 
> If they do care, this can be done as a separate patch series because
> we already call local_irq_{save,restore}() in many places in mm/vmstat.c
> if the architecture doesn't not have HAVE_CMPXCHG_LOCAL.

Got it. I will ignore it for now.

> 
>>> Let me send the patch to cleanup the memcg code which uses
>>> __mod_node_page_state.
> 


