Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D17C6CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 17:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B818E0058; Mon, 25 Aug 2025 13:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3798E0038; Mon, 25 Aug 2025 13:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1206C8E0058; Mon, 25 Aug 2025 13:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFCDC8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:00:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 999CE59242
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:00:14 +0000 (UTC)
X-FDA: 83815892748.02.595B708
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA298140009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 17:00:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZUra9uhh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756141213; a=rsa-sha256;
	cv=none;
	b=UXt2S3FewutiUBoFyG0Ggs9JcA4fE/tMj2Gp7HufsHV2G6fNBSIQVDP6CC23yHccC9C6nc
	Upm4usAsTAyq60eHlitUTC+X+r/X7CszV5QiriOHNfbQaVeOEtCEhs8z5BF+C0m1qmgKiS
	xwCkIkp9Yrk+nsjJRfj/Bez8Jrw6ttY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZUra9uhh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756141213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6uJo9FbTXrzowr8bEe61nZYQy1ZZH3tikDVmsKo+eZ0=;
	b=sTha1imwZMeAv4owGvCd/pRSdFE3tyoxq9Sk7FEyMr4lpUajXBDC+L8eD6ZaINA1QDEOBJ
	Uh8tbNxSAUqhO/5Is/68cenlvn5LNfnou0cEyqqEMI8FLcmQ/QO2feYrb4W+IFj4JAEdER
	RqOfl92mTx3jQ86JI8JstUAYHzkHwa8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756141210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6uJo9FbTXrzowr8bEe61nZYQy1ZZH3tikDVmsKo+eZ0=;
	b=ZUra9uhhuroF/AWQrMpTXqdJomo2gUtw+oC8PyZGUMqGcCITfRywK7cZOklUHO1xq4J1h7
	hXSNz+75AFa0o+inHBTr9VWOSw85k4C++U7huvSKbrcCyrmD0qkCwVh3Ow/Wx6VjYnW+UI
	7ASd9pZu8gDLNMnaGJN1d6iVB4yLXr8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Kumar Kartikeya Dwivedi <memxor@gmail.com>,  linux-mm@kvack.org,
  bpf@vger.kernel.org,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev> (Martin KaFai
	Lau's message of "Fri, 22 Aug 2025 12:27:48 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
Date: Mon, 25 Aug 2025 10:00:02 -0700
Message-ID: <87wm6rwd4d.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EA298140009
X-Stat-Signature: y3mid3xsa1zzbhufgzhi5b599ttnxpbf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756141212-683803
X-HE-Meta: U2FsdGVkX180vYXx+pAO+b+XJSu4zdZpShHOE+5J9w0asIP8stnkjTcUPWUQGAhJ46ac6m4LhYMTfA54HQN6M4wiNVOU0rYifX4IVmLU4rqxZlePhWAmB6AIhaUTb25bQnCp6IiB6Rsh8ucKu/8SwfqrlMNBvGwWvrgv509zq+8k9nJwQWAlUrlM/pG/ZCmWTKTgUC+ptpSzijDilQtRs/rqS3Qa3Qf/nDmGnc2+pb+KF3WQq0SgVzmLEUg2spELPWvNjmrBOITMOjnlAsYrWD0/YCgSgdKPD3D54XmMJJmgF1PdyTOx7aVqVUgnEgD2WZ/EibvWGAkDae4OMV9maX5MAB2zqS3cUY4xnP9oq90GRxhiB+4Zk8pgS/40zjn1o/PjWUpG26Fvudlez61BInMBBC9AZd8YA8rMJL3djxg1FUGuX4jYsd7+xnJdHSYK59j2ovVYuObWeyRXKV4Bb7A9WuzKJ/aCZbbS+/iUBDoIJvD50XgiOF+DZy9DVKzK326xSQCJxOApV7RIyqmNz6mibXycHvCaE04z308DDmr+b3uxfSOn5Dtdh0CkIUoiUuoxywYsUB55Mypuryga5ErO1RXcV3xl0p/wDI2FLOJfP6tz2TlIoYIK52WgNqgVxAWWyZlPT6rUSXeV57y5SLzyJgikVk9gctN4ftH6ibJcCaDZ1WnVmDP3xN5CgGFgxc20V3fqz/LPx7HdJN2wNSglZ+zOA2hrv7JXLz//NqwHXcbL/lE4OZmFTQMckkSPUCF95b9O/qmf74Vjv773R8lC4i/ac76GVQ9H/mMW6jkOFhCSMqzo4Vqhgj0ziNp0J+LH1Qsg7EHt0TNJW8TbYjMaVawpfmf0c7swA96RWvBjTKCjMnTAwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 8/20/25 5:24 PM, Roman Gushchin wrote:
>>> How is it decided who gets to run before the other? Is it based on
>>> order of attachment (which can be non-deterministic)?
>> Yeah, now it's the order of attachment.
>> 
>>> There was a lot of discussion on something similar for tc progs, and
>>> we went with specific flags that capture partial ordering constraints
>>> (instead of priorities that may collide).
>>> https://lore.kernel.org/all/20230719140858.13224-2-daniel@iogearbox.net
>>> It would be nice if we can find a way of making this consistent.
>
> +1
>
> The cgroup bpf prog has recently added the mprog api support also. If
> the simple order of attachment is not enough and needs to have
> specific ordering, we should make the bpf struct_ops support the same
> mprog api instead of asking each subsystem creating its own.
>
> fyi, another need for struct_ops ordering is to upgrade the
> BPF_PROG_TYPE_SOCK_OPS api to struct_ops for easier extension in the
> future. Slide 13 in
> https://drive.google.com/file/d/1wjKZth6T0llLJ_ONPAL_6Q_jbxbAjByp/view

Does it mean it's better now to keep it simple in the context of oom
patches with the plan to later reuse the generic struct_ops
infrastructure?

Honestly, I believe that the simple order of attachment should be
good enough for quite a while, so I'd not over-complicate this,
unless it's not fixable later.

Thanks!

