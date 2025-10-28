Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD03CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 18:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBFA801A6; Tue, 28 Oct 2025 14:09:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B39C80199; Tue, 28 Oct 2025 14:09:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C982801A6; Tue, 28 Oct 2025 14:09:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC0580199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:09:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EFEB913AC06
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:09:43 +0000 (UTC)
X-FDA: 84048311046.30.C7E8B7A
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41EBC100012
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 18:09:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ub1SN/SJ";
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761674982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpykUOb069QPLVeJZBbZFKflqnV60wvcTzlUbFCN+mA=;
	b=qCyMwE2tK7G8lA42zQreBjNOViCY1z68ZYmi8ISRuxWfkSkcGnfYciw6sDyXE11w6Dua3x
	ZlQl8mgNI2R3GikUP/RhFZr70wCG4oQMQOm2nBvNrhuxdzuhe6n1PnLmq5n6RKnm3J8jJM
	vIT6gQ1LoZCoOGu2tEeCbfa+ChT7C/Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Ub1SN/SJ";
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761674982; a=rsa-sha256;
	cv=none;
	b=7TWRNN9TgWa51sz5c9vzH8Qke1d+x0ngwNiCBIJHV4ZWtMrN4c3vJFAkmlMeiUwa4gEyu7
	XEKnVy/YnNc7VMHGAMAn5GRNNFJl9U2/WpS82GKCuJY6uI9X78d7UONSJQ9zJRConG60NV
	gA3iKhirldmPNlZR84t7nfWmOT7+uuA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761674980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XpykUOb069QPLVeJZBbZFKflqnV60wvcTzlUbFCN+mA=;
	b=Ub1SN/SJ7bZTNkNA7Mkvwc3LqkUUsEhfF8JeXFibIJIaiIBhX9asAWfHtE1uuPJ2oPqr7Q
	Yu7c/Wy6sipgogjiJN5d6YT4oOnNFHX8T90X3ykir9AQyVjr/adaQh270IdhWWXzIgVaS1
	OhTFaT2XmNcW8sMgw2wYNnQNfgVGO+g=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrii Nakryiko <andrii@kernel.org>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  Martin KaFai Lau
 <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH v2 15/23] mm: introduce bpf_task_is_oom_victim() kfunc
In-Reply-To: <aQD-RvxrX8_7QtxT@slm.duckdns.org> (Tejun Heo's message of "Tue,
	28 Oct 2025 07:32:54 -1000")
References: <20251027232206.473085-1-roman.gushchin@linux.dev>
	<20251027232206.473085-5-roman.gushchin@linux.dev>
	<aQD-RvxrX8_7QtxT@slm.duckdns.org>
Date: Tue, 28 Oct 2025 11:09:28 -0700
Message-ID: <877bwevqxz.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 41EBC100012
X-Stat-Signature: 3gk7fshixsbpno795gnueicomyhj5j8q
X-Rspam-User: 
X-HE-Tag: 1761674981-747191
X-HE-Meta: U2FsdGVkX1/n/8YXsl/rpk9NHV0FEAfvzFKlh8gwcKrz9D89fmYmVa3OcqtPRBrh9P4VVCeRFjUSUcqbPv+ymJmNhCzO3kG9lyIv/Z81s/tacrNNdWemBpG/GYfunN97ezUA9U21emfnkLOHBJRo+4xviUY0jfrcM2W7nESvhabGi7bjE3gXPaKhw7/1FEgrtj3ovynbwk81C4at2TmMqfWlFZS2HCLzP4EruZ/vK3a6/CB7lKNERn7X/tDmJUX305af82DAWSsXrWLOBFsRLb/5EP7ieZDPCvdkdeN/mfReeqXo3a2ZVkEnY4fD7TCGAA/Q0Wd4nwQgpbAYcVChBOPH/129wsdgjFNXI/u5SsoQu7BoQAwVUTbkBGikYvoRdBPU283RkQGVBKBdf0BhL/EuME3M1AX5PX0Ug+UrlMfyN54fM5xF6pUb+TGEvajroqYitdQfsqeIkd3wo7WMaktGuSOGy/kIyfJyI1VEEwrZ6lvYCu54a8O9NhUqFM9LQdNiY3ETaRxStpvi2Tm8hXecAE4SGIKujYNEY5aHNpNIenYS2AkZyIvAHSQ0PasjQSvsDRf7xnJBMwKLQRbirymMohJhAz7YXnOjoxKvWpne4MtWZimjY9BMfEL96yBXZAOL/alA/lv+RKOaVyGC4z5PDE7zRDhEz8RypzpxkgP7IbQKMnqiJ4rxiNQwpE3/RVJEkM+wdXhQpY2fDH+TJlxr+gL8KXo3a4wZhxMIB9i5IVx49Yq3ERnHXxOXrgJiZMBdPVLTat3sxOWXj5JIeJoUXiIuofMih8iLTRzVYYMEzZQ/ZBsqdmEXEF2m8wuCDeAvIx+oiAZIWFWj2Ts/88VfqEoFLroaihI0VvEnc2wGogqdHZkbq9RoBYsyaoQ7ARjW2hDCAwilLqYK2gPxOQ5TEgEUiuNS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tejun Heo <tj@kernel.org> writes:

> On Mon, Oct 27, 2025 at 04:21:58PM -0700, Roman Gushchin wrote:
>> Export tsk_is_oom_victim() helper as a BPF kfunc.
>> It's very useful to avoid redundant oom kills.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  mm/oom_kill.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>> 
>> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
>> index 72a346261c79..90bb86dee3cf 100644
>> --- a/mm/oom_kill.c
>> +++ b/mm/oom_kill.c
>> @@ -1397,11 +1397,25 @@ __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
>>  	return ret;
>>  }
>>  
>> +/**
>> + * bpf_task_is_oom_victim - Check if the task has been marked as an OOM victim
>> + * @task: task to check
>> + *
>> + * Returns true if the task has been previously selected by the OOM killer
>> + * to be killed. It's expected that the task will be destroyed soon and some
>> + * memory will be freed, so maybe no additional actions required.
>> + */
>> +__bpf_kfunc bool bpf_task_is_oom_victim(struct task_struct *task)
>> +{
>> +	return tsk_is_oom_victim(task);
>> +}
>
> In general, I'm not sure it's a good idea to add kfuncs for things which are
> trivially accessible. Why can't things like this be provided as BPF
> helpers?

I agree that this one might be too trivial, but I added it based on the
request from Michal Hocko. But with other helpers (e.g. for accessing
memcg stats) the idea is to provide a relatively stable interface for
bpf programs, which is not dependent on the implementation details. This
will simplify the maintenance of bpf programs across multiple kernel
versions.

Thanks!

