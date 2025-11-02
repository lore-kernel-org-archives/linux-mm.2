Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FE4CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 21:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F3C8E000A; Sun,  2 Nov 2025 16:09:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907378E0002; Sun,  2 Nov 2025 16:09:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C0C8E000A; Sun,  2 Nov 2025 16:09:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6F0118E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:09:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0BE0513BF40
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:09:58 +0000 (UTC)
X-FDA: 84066909276.22.D111556
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1C55E14000C
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:09:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BCSFaMuD;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762117796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAXmeX2vGz54XSwHtOTFcyqmVp+LVbdN0KySc9/XxCo=;
	b=aWerUHF2D7RsVBVTp9zIN52ZUtXF9jP12SJzKbuVXnEiiK364GG9Q8auXpeOGk2e46VR5W
	EPO5lRDSb5RIFSpeNdm0KfCwBT7cuQBGTA/XzE9ZoE3UUPbW8RKaGPfXiiRTTC+y5ZxyOr
	n+SFhFDZVuIlLxTV/Qq3wF2thGM7TcI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BCSFaMuD;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762117796; a=rsa-sha256;
	cv=none;
	b=y3V3df8/00c1wHxKd4Coc9cdcrf/c5OdzYOPJ8aJc3qkYbotzK+1Y0p18u3icNr8CahI8E
	DK4iPqZullJchWewm+j1ryEiI+mpw1cGAbM1ZwZSuz+UKbaiHufKhh6+UZ3IBeSDpWtrSM
	ZNDDGHb0mGh+7kWsCVOQQe8C+Zpj+Ac=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762117793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gAXmeX2vGz54XSwHtOTFcyqmVp+LVbdN0KySc9/XxCo=;
	b=BCSFaMuDWZvhGuK3M8jq73iXeeCw++xgqxFM0RIJ0Q7sBeTHlERrN2x/JruaS9YJ7nwza9
	h8gqats07cT1iWF+GU7ixYeWQ1af+8OTumPHVZQv16AYEYIGEGDXeNSyW3cwdckNKSigCR
	N6U0l8Q6V03D9uy8bYqtQaixkQHeODc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrii
 Nakryiko <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  Martin KaFai Lau <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,
  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 07/23] mm: introduce bpf_oom_kill_process() bpf kfunc
In-Reply-To: <aQR79srdPzyUT9_I@tiehlicka> (Michal Hocko's message of "Fri, 31
	Oct 2025 10:05:58 +0100")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-8-roman.gushchin@linux.dev>
	<aQR79srdPzyUT9_I@tiehlicka>
Date: Sun, 02 Nov 2025 13:09:45 -0800
Message-ID: <87a514nnty.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C55E14000C
X-Stat-Signature: 61fgwj9zt1mudaogpfradm7wdf4de4wk
X-Rspam-User: 
X-HE-Tag: 1762117795-140017
X-HE-Meta: U2FsdGVkX1+EBvMMptFhUOf+LFzNZnqP4j8wnfsQZykLUr5VtgerqNOXMdfpN08dCJorajzP615UqK2G/DvL8aZhvLBNaw34NYhPQ55mA0jcrJdb/czpanlR+KRbrVljM31rV8vyLrJhsMPtRK86hTwTa7bYwGQ8ExuUPISK1eQtp9xLVUw9NkmCpXHuJNt9pMzRvjSgT/G+RCUN3JQoFkev148+1m1IWC5rrn/1Dv3WCLgHcZ/EWv5XLJ5dvpOWVzUYaUn4QEwkep0+VQPctZLBBh/Ww7BaR9ZmL34LHixRVurkMrBYMqkmvNfPmQx0PIRWAgHtf4czU4kF9Z0KuPH4riZtIk9FmVRaq51/rID4ZZgkIsT91EVOvtOrcVHRiEQm8suLScmbIQr1lHEZJzt5tHt9TtjUXvKKGYi+x/5e0SXMEI5XOp2onA+QcMLZ9ForvZiPF5Wj8zKlxRq4hEgLch9SYk+dPRhNHUGDeQnWDP4e2l+N1XIBApuBoMtJ3tv/l9rmGjrJXL6CUfbisOIKlsnzTbO4tVKL9s4Ruq1iKsP6gLdbRwXHRRDle1fGpnqs5bhRpZAzyskSJVVHnvW7nJWwNOwu/EDYpJx+tRqV5eF+xx9adlrOtQwhkSaurjyVjHblihQDPSj/JCIyXHgGEmOqTt34P8CY4RTV7uHlGNVcVYXk7YnUSwf7/voO5AV+b4vcV0HEpDw3xrFBGKvLahz8zoeHG/9SFcNrIRngik3POUxauW19EYlC8GlssK9mcyUDa8Z5SdLj5+PGrW6/odJD7mN2e66v7Xq5R3QXhIeVOnBKo/U0Wo0ShngEh/qYlwd094CFpsEdxiI7vof/DewCBBTvFMDHdTSjtxLgu5+l+P/tC6ZL7RpJPciemDWUGjplQLTNGA+duqhM4ILTMPYteOaZkU/BVsD25FuRJeppeTYj7WKD+1u/2/1V/fGlIjr+Fdq98v7XtsL
 lOeh3hTB
 N7aRlcBK0qLA7zYcmOxFLfvP8uyYUGoh77cz2ubL91zlqHK+jT87ePO8t3mxLNwwONTvMwmuy9vT4jjjtoLdVWabB7foSJLd+AFQCVLLfhGN+uJsVvj0YI464rlpxp1Ly4hsVO8w0W/ur8np8jjoc4szWx6ClhYLkdEuhg8bvgDYxgZIBGT2BtufMlRTq/nxbFwirFJo5noO/4aK6AaJik2SiTJM9so6wqsGK8FK6c7PO/GqwbFM6nfbR/1M4jqfGavOl6UQfDLYAG8s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 27-10-25 16:17:10, Roman Gushchin wrote:
>> Introduce bpf_oom_kill_process() bpf kfunc, which is supposed
>> to be used by BPF OOM programs. It allows to kill a process
>> in exactly the same way the OOM killer does: using the OOM reaper,
>> bumping corresponding memcg and global statistics, respecting
>> memory.oom.group etc.
>> 
>> On success, it sets om_control's bpf_memory_freed field to true,
>> enabling the bpf program to bypass the kernel OOM killer.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>
> LGTM
> Just a minor question
>
>> +	/* paired with put_task_struct() in oom_kill_process() */
>> +	task = tryget_task_struct(task);
>
> Any reason this is not a plain get_task_struct?

Fair enough, get_task_struct() should work too.

Thanks

