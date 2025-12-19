Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CB7ED711D7
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998A66B0088; Thu, 18 Dec 2025 21:51:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91BD56B0089; Thu, 18 Dec 2025 21:51:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8278A6B008A; Thu, 18 Dec 2025 21:51:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5F16B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:51:37 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11622B9155
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:51:37 +0000 (UTC)
X-FDA: 84234695034.22.1E4C8F2
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 68012120011
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:51:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXUnWFOj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766112695; a=rsa-sha256;
	cv=none;
	b=3aMicY2KPsxfPWR65/zmgb7joISptBZJ+sH7LX8AmU0iyMxbXLnWdWB9rTX2S6dIW0If2T
	w18/mpnx3CoPgzG4OBkz3pTGlJuigbftKIBW76djuFAN7qWfvDXKi5+NivATht0IHth+fR
	tGjPzXefFf77ebp/Foirt243f1Upp/I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXUnWFOj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766112695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZX9EdKmymQBf6dTDpGNXCbWaUIzPPXzTY2GtSXhpfr4=;
	b=OVtWvFUXb3P84kuOE18C9xL3/v6cnHXH+wBdb4k5NvpRxYzallSt/LbQG5Ny7bSEW4KSqI
	2l5ijBJJseywkFZj0cpXyrdqIVFmKEFlmCPPyxBvpMEoChsLx3o7bJzeY4KtMGxgmSLuIf
	RJFkxIF6s/HzsScSZLIg4iUh8O7QNXg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766112689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZX9EdKmymQBf6dTDpGNXCbWaUIzPPXzTY2GtSXhpfr4=;
	b=lXUnWFOjmasnyhi98G8wHqdqJ411bv16T/4L+YoejiUdO0fpW3TqnCGHIdx3f8yFsRwk8p
	YlyVWZh6UBZJZbW+pajOOEUocfoYU0Gh4BzANXLTw1MDAeXqTw393pirs7nOpCh/RPGfw+
	2sxUkLngcYgWoIOn9ZZa0Qsu0+18rZg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
  inwardvessel@gmail.com, ast@kernel.org, daniel@iogearbox.net,
 shakeel.butt@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
 andrii@kernel.org, martin.lau@kernel.org, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next v1 5/6] mm: introduce BPF kfunc to access
 memory events
In-Reply-To: <cf8d48e8bcdba2515366bc8b6c85f581ca3d18ead24db9cb3ba9b98db252e0b9@mail.kernel.org>
	(bot's message of "Fri, 19 Dec 2025 02:21:40 +0000 (UTC)")
References: <20251219015750.23732-6-roman.gushchin@linux.dev>
	<cf8d48e8bcdba2515366bc8b6c85f581ca3d18ead24db9cb3ba9b98db252e0b9@mail.kernel.org>
Date: Thu, 18 Dec 2025 18:51:23 -0800
Message-ID: <873457b2vo.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68012120011
X-Stat-Signature: ktmojmwgyyhc3c3ccuijsg1wazc8w88t
X-HE-Tag: 1766112695-903715
X-HE-Meta: U2FsdGVkX18qzz3GPNm5uhIfI/dQ2nPEL8dXdBFCQkkuWtpKK7jOG/5RqXq4YLRFJPUEIs1HEUgs7b9dx/vnTTqtrbCen1ZwqPMqbggWC9Rzuk0AVgs7agf6cc+AggOPRClO4uxkY9F82w3GAU9CwhHoC1a4FUedz7HmevKXzN+aWIUFxVIEiUvnBA6GuSePvZqPc90WQvSWtATf/H+pLU4a6/QSD2J1kbaY0bnaUrt+lrE4uBvA8iDdosyDcaiHZiMnyA4J4DFE/mgJ3NrV7IyIO8qPq9rqDLk83hUrZdKzdTScLDWQ+kSZtxkDiGVTEO6S7zrjE1h3e4AFc3Sfd03hcbueMEGhW75v5AmI7eVb1GhT/Dc0jCZci8Ks/+FpLR3rZargUrLEyOUSgbd2VvubOljj/znmTQ9VNbxHA27iIo5Y7CaaDPS/3GsEHtfnEhfwhMmmUzFAR9FALiLnOZYYsdfWtpMvEl8nQtie28CM7tuhKnDRwdxzRDRKHcOddDnth10b9lgkFRhtzSnqsnIanU0ydl0IUnPQrgqm/17+2m7U8S4hL+CFv46EUGBbANyubv5YlYq0pEd4i98Vc1L+8SGheSgKn+2ikDpnDRC1vPEGLBUxxC5dD0B5wT+V4fWenLZbooeQO9bBaH547hYuW0Fp/0D4KlhQyQADeEjNOMuuULlR7s8u3vQq1ufhj3jgjls2r+YFw7qFxHErnZ8dobAgpqqkDBTVUU6/SuAHeMQYV40zD5gzTTvOxCsa/fi+28IJka8YQx57NoGvxCMkIH5zqaqfkNyJ2nxau+Nt+xzTnW6OK0P/DPUPSKLNAy3+V83u1sIKaV9Vtz4xCO1qmBwNer3z4JyL5PLAON29acqnIcTheyOkjBYV6XjGmI3dsGerp64lP7uXTkxzo1UYMYCg+s9HGTmn8HblvR8OtsCr1D+p/rL2y+kx5eyqoGjlI6SJ74VOQOqtYVy
 /AkMQ73D
 c+NpvN8wkWfztV6n0MsM4A21MFCG+ZSOPy/016B14QmCLL6K4c2gEuzx3LLl7K/5ksI1QvPzk2fXmc/bnC3mNSOQ/rVdpVgcEw2T/6gL3qGohW1U3EhjjDq5CdrI4vE6hwegB4ShtR6Plr1JKHsWzJyQcu9O9brBGcmopepF/oLj/ljXoM5RKrKKczufsx4YrejISAh8apq0ZbSElXrwV7I5EU9BXyiiyjbfE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 4d9d7d909f6c..75076d682f75 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>
> [ ... ]
>
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
>> +						enum memcg_memory_event event)
>> +{
>> +	if (event >= MEMCG_NR_MEMORY_EVENTS)
>> +		return (unsigned long)-1;
>> +
>> +	return atomic_long_read(&memcg->memory_events[event]);
>> +}
>
> Could this cause an out-of-bounds access if a BPF program passes a negative
> value for event? The enum type is signed, so if event is -1, the check
> "event >= MEMCG_NR_MEMORY_EVENTS" would evaluate to false (-1 >= 10 is
> false), allowing access to memcg->memory_events[-1].
>
> The existing bpf_mem_cgroup_page_state() in the same file uses both lower
> and upper bound checks:
>
>     if (idx < 0 || idx >= MEMCG_NR_STAT)
>         return (unsigned long)-1;
>
> Should bpf_mem_cgroup_memory_events() follow the same pattern with:
>
>     if (event < 0 || event >= MEMCG_NR_MEMORY_EVENTS)

Same here: the check is enforced by the bpf verifier based on the type
information. Not a real issue.

