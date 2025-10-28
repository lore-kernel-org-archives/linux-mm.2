Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C816CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 16:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02F480179; Tue, 28 Oct 2025 12:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA2E8013F; Tue, 28 Oct 2025 12:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17AA80179; Tue, 28 Oct 2025 12:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8588013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:20:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 677CB87E84
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:20:48 +0000 (UTC)
X-FDA: 84048036576.14.D19889D
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id 90EB3100018
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:20:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JYfk+FKC;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761668446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1Bzn1s/zljRcvmyCS22gE0OJ0NnMFMhi+daqWj4zl4=;
	b=xUfkt1krlf47ZRmdD8/YWSKP7WkGv8Ki2Wsh+m44PcbyQ+vZj84y5DDnhKZUXkICpvQQ90
	k8g36As9F15zOQzR7ljJfe9EctBxXDpaIUXKh89KRZfDwMLgdFXiiVYITylT6dvlZlkD68
	PUyLm3HpSfGJvyKzuATb1LxuINc44o4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JYfk+FKC;
	spf=pass (imf05.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761668446; a=rsa-sha256;
	cv=none;
	b=IJl03R8U3Edpsxa3zoM3PFhRkAGQ80bOgP1nUpjbCukv5yUnze3mGbJEqkwbxYNASeGpQg
	aO9WeX0qymIRwcn39w6ocVLv/RyEspXfxhKWR+07DAeu092H22Av2fQ/yNN8snNvog1hvn
	MGLDJ8hdw+yceXuuBLJpeEjAn6Zyxik=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761668444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N1Bzn1s/zljRcvmyCS22gE0OJ0NnMFMhi+daqWj4zl4=;
	b=JYfk+FKCUMOYMGJgaGlJf9TmW/4P0jgdth++YnXfK+QdAEhpOOljW1c48Q+XvhndVmdBS5
	OmMYmRRYsEbZ5eGbXAF2c3q+ui9LlFAkh+tWlfZXcQ+7a72N3erlgGJq82bEi3gaoQ5vMk
	bCDUD+3f/LiC61x+0iHbzTwe1H5eCFo=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Chris Mason <clm@meta.com>
Cc: bot+bpf-ci@kernel.org,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  ast@kernel.org,  surenb@google.com,
  mhocko@kernel.org,  shakeel.butt@linux.dev,  hannes@cmpxchg.org,
  andrii@kernel.org,  inwardvessel@gmail.com,  linux-mm@kvack.org,
  cgroups@vger.kernel.org,  bpf@vger.kernel.org,  martin.lau@kernel.org,
  song@kernel.org,  memxor@gmail.com,  tj@kernel.org,
  daniel@iogearbox.net,  eddyz87@gmail.com,  yonghong.song@linux.dev,
  ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 14/23] mm: allow specifying custom oom constraint for
 BPF triggers
In-Reply-To: <a1d4d200-5a35-4990-8499-6dc7ea6d65ac@meta.com> (Chris Mason's
	message of "Tue, 28 Oct 2025 11:58:50 -0400")
References: <20251027232206.473085-4-roman.gushchin@linux.dev>
	<634e7371353c8466b3d0fa0dd7ceeaf17c8c4d7b274f4f7369d3094d22872cd6@mail.kernel.org>
	<a1d4d200-5a35-4990-8499-6dc7ea6d65ac@meta.com>
Date: Tue, 28 Oct 2025 09:20:36 -0700
Message-ID: <87v7jz3smj.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 90EB3100018
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f3h5zn4zc8wdtxzwx4qc4chuoexfpent
X-HE-Tag: 1761668446-230578
X-HE-Meta: U2FsdGVkX1+3q/x9VVMWAdPAS803FVNly0YeX6xqFt3fLniAAcsp9umiCiQzOUms+CTCiGyKepml1Tayv05oYJDlg1dxZjR3x+ol/tkqA8lLcYvEiK8986f/N2GGEaq111kBOkiI4U+qrl43H13L5iAr4K3+S6Cvpi2ntP0ccM3DZIvMiPKYJ3yl//a2HqhsF/StLaJSuhTA8DeX8kLcTMgVWv3Es65009KhcZt+LDOmjmFTUIR0Wzd0uImB3d4ifmMpts+QtarBF9qPFi3U35GnZux0S8i3NpjX39hWb6XG0XFFFiFfNj1n9k3ohxgh4xMRdNNogoURkzDG6SGQNbr3Ja9kX/IdKQ7RLglbEAJLiu/MZUT57cM3FkwoO6Qu+T+yXSExpevdvA9keF8JhxkGxa0qSS0WZjARBvUnHx4f4AZrkN08crWRZU90J8SVFCY0C0EPFy327vinZJudnAUR/Pu56CayF1Cyl8mRXx1d1RZviGo+5No9o6lVIuLcSZTz26QAqVa7TN6kyK//mjTa/rPXV7R5iFVvWrzUxHzmKsg3EHbGhMdraQDS6EiCeHyfl1o5VQM5zuKvvN1rei2fG/oZPI/xEpuEg0087NISeA3C6c7uRNDmKlrVDLLKwFhC/EPXU33hJR7IeOChFp7Zb+LVkDL8GZHIaVEXLbeeQ9NkINm6ACBLtEZ7Nw4Jx90Fvu/Oj+2mhqUh9dvmsjnZjl2xTzwyuie4ps+e0jn3xwO51Ev5oM+R10cJvSewvfFEeuKcVJcrBJaGwSvlUomIVshysWgySD/JAeZZSu8gthMNbeErhSZrysy8ktKMyswiLCVZMlTYIwDfGjjHz3BLGAIhgKYLaIlDuSTWe7GqtC/rB+XA+ESWqCsxsAXZxT+a+wl47RIkeQugxbQo1eRaNuVl9NkWmhlOIjKjK/egzSq/jIIZAAg1wNIyE0kzptw2aQUuZPf/8rGsX0E
 I4Yi2OC+
 T0PeCazUeoxl6KLjML1SzMkxHnvUn1w2mHnQ8MbmAM/mQOANtXGxn8+heUFxTipJcK7R3xZLS4t7TuChPm9G6h7Bej9SJ0wYuW71a3z9epOR2AZwriSXS0dlrii8fQmD5YZY2Z1Uej+4NJLPl//t+dDnsStvhA6kOtVZn2D0Scwq4R8xDbg5U64rKubH/s653/d3E19k2muBFNpVhrch+d72LH53ZdnfT8iKlxyv3IQdtjZBTIVQ2i+bVM/oJochNSTPZpDLXdqf0bQuS4ihKCLLEGfzc77UZwI0H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chris Mason <clm@meta.com> writes:

> On 10/27/25 7:48 PM, bot+bpf-ci@kernel.org wrote:
>>> @@ -1350,11 +1367,14 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_control *oc,
>>>   * Returns a negative value if an error occurred.
>>>   */
>>>  __bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
>>> -				  int order, u64 flags)
>>> +				  int order, u64 flags,
>>> +				  const char *constraint_text__nullable)
>>>  {
>>>  	struct oom_control oc = {
>>>  		.memcg = memcg__nullable,
>>>  		.order = order,
>>> +		.constraint = CONSTRAINT_BPF,
>>> +		.bpf_constraint = constraint_text__nullable,
>>>  	};
>>>  	int ret;
>> 
>> When CONSTRAINT_BPF is set in bpf_out_of_memory(), the early return in
>> constrained_alloc() prevents oc->totalpages from being initialized.  This
>> leaves totalpages at zero (from the designated initializer).
>> 
>> Later in the call chain out_of_memory()->select_bad_process()->
>> oom_evaluate_task()->oom_badness(), the code performs division by
>> totalpages at line 237:
>> 
>>     adj *= totalpages / 1000;
>> 
>> Can this cause a division by zero?  The path is reachable when a BPF
>> program calls bpf_out_of_memory() and either no BPF OOM handler is
>> registered or the handler fails to free memory, causing execution to fall
>> through to select_bad_process().
>
> Looks like the AI got a little excited about finding the uninit variable
> chain and forgot what dividing by zero really means.  I'll add a false
> positive check for this.

Yup, it was *almost* correct :)

But overall I'm really impressed: it found few legit bugs as well.
The only thing: I wish I could run it privately before posting to
public mailing lists...

Thanks,
Chris!

