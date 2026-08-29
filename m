Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46383C61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 01:50:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE0D6B0088; Fri, 28 Aug 2026 21:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39EE96B008A; Fri, 28 Aug 2026 21:50:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5186B008C; Fri, 28 Aug 2026 21:50:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C7FB6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:50:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83B651C21C3
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:50:09 +0000 (UTC)
X-FDA: 85152626538.19.7A2D55C
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0380880002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 01:50:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+vtgKxR;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787968207;
	b=HgspMzB/lBWelvr1dS3DyH/zBW1Hr7UnFUUmlkZk5T7CO6UO56OWtZNpYuKbp/HYvVCf+G
	3ob0DKiY3q29XbNC8KutHlQoMAQxhWEvAIUAoa/OCahqtzOqOVUHr8OkMPG6kT1w6I56qm
	O+Fxo6p9cac6Gra7m2M/4WaVJcf0qEQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v+vtgKxR;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787968207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3Vp+PyidmV2KfIrQxD0bN9wMnJa3hoLN6Iy1W+CIfw=;
	b=DHwXYFjaIv6HjkVkOKNC0nJ9sY7lWBID0iqsl02fsT7hBdcoBQ+7/kM+LYwz3freLbsnPc
	/1rgAJD3irz2kFK0Rdkj1qSiRXdYBxFnall/e/Kuc8eWMx0An0o64Z05CDwbxejuX2+LE1
	GLTsRttMkP3Zj7xuqOHzKsK2vQ7ybK4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/iqJD9g/AaG1YjZFJu2Q3XSOJAmhV2Z6W0ipXJVXn84=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787968204; v=1; x=1788573004;
 b=v+vtgKxRBsYMITQGo0/pSgvKElzZbwHg3I7UgC+mHhsJ6eHpf0D1nndc/K4HFtw6Wp++y+xf
 vX0yVpafU2qEKOjmKNBfykROwoUQdpbFLcIzPhNdM8x819iupUtRtF8guypqlzzonKKdAs+ZpiY
 R/NgW1luFthpytQd52a5C6cE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c2ecf192b3279494;
	Sat, 29 Aug 2026 01:49:54 +0000
X-Mizu-Trace-ID: c2ecf192b3279494
X-Migadu-Flow: FLOW_OUT
Message-ID: <eeae0d48-4d50-4dd4-9e16-b4f9902d84f4@linux.dev>
Date: Sat, 29 Aug 2026 09:49:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] fs: fix missed removal of
 super_fs_objects_eligible()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
 <3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
 <20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0380880002
X-Stat-Signature: pio3onikarz5ey9s7e86xq6uro3x9615
X-Rspam-User: 
X-HE-Tag: 1787968205-764103
X-HE-Meta: U2FsdGVkX18v05516Rj3+bYBIfijtPe8rNzQlNtb5QnBdwF6OG0R70j2puoCQEQCqt8zSD+FrDTPnDc/T4vBFWUIBEtXuU204ymVK03YEYxO0tjGKtpzyqeOL96SJ3ktF+yeosDO1sj2nB7sMDOjQpuJYIkRfDGV01XU0LY8Mu5SKgEJfxs3kviBtWyAO4z9rV0j3XASc/GKUd3vffbKyirzYLvx8yrcGFD1FQ5+gtj2ymVuXldkThnjlSUZ+lp/ozrYyx9x/Ld/8Xiecb3IoDC+YBST+dykE3U12dVGEEUqGctKl1YJVT3g/wgGTWOndWqo9gLRLWikMt8Q0qB6RobHpgy3yT0RTHhrA+f2v6CyEPtP1LHvAhXyfnpNfzvjIejRQhvUlvfaO1LVc3+TtQAgsUejbITa99cikCXBLYeU0NBHpX/OaXGxbM01CyeyOR0UH58AGDTHiIFAOo+Tw2kPRT4zBn7LaACagcyJPss/tm4weVRXaWPiuPNu1tSTq+g67MOZkGEtvzLqcH+i4iO9vt68kfCnbk+dAb5c6xT4PwXtPhVMGQLlU9hemF9G0p/PjMadFP/F+1pJpoYyAwqzYfsrH2pp0RbWPjGH7xtP9FA9u0ydXSLDPTkI9Qkdh5rjxJ7SUxBspy3VzxvIfi2YPtkFt9eJI4/sHDR6Ysqagx4fUWofiMjTnFLRXr3IxO0bsD7XRG2iBLDp2TkXMOYnnb0CUgG1KX6D4Jl7PvYSDigqD9k8aMa5n4wx6Z3CtjUe4Xv2qXn9beRkamr+j6MiGjvtpt0UuEHvYtCXQzdn9B7F8AQeQLdLDSx6RvMOzr2wBVtawFhRXgLKr9ya3IYBE8zMIUodTVy7tFvRqrwv/zh8p7ve7hfPRnd3ZO0KcfBSzcP/On7X+13nRh4D2hkm2T9yO3StAlHvoEkcKQxTe/zCYwDluh/QMxr3jJBLQSJDMIJbbubAJgm7bhc
 HyUgwoWq
 kkQ5Ghy6XW+wp2a1GFyw0x7D6znKYyJCvBPRV7ueG1zxSnlSdIVmRKcxl4XTzC8WntRsBEu2UbuwbEp5MzGEYBym0TwzR+UnNxR+nuReC0QP8cLmFhOsRsrfE4iaS6WFdZEC/VXBHtFIwPAkW+KcIb+wmi85dj/3e9KXS1wvOPSw8M6osZ/F93Pn2foOB++b9kP0FE7LQZiiBwGpENA280FWFbBj+TwzyuwmFNNwJ61cH+cS4gf01+s3tRIpsesFKGNuH5PKf5yUQpcsINKLi+IHYm8YavS4zCUXJz8qsmIRXyWQnN5yMjcAIh5bzPGewdu+GJIeoyfbX+w4NqpJCFTLDZLT31fNuSW8FvBkSW8y8O0upxRLFZxfDtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 8/29/26 2:41 AM, Andrew Morton wrote:
> On Mon, 17 Aug 2026 17:03:25 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
>> individual filesystems") forgot to drop the super_fs_objects_eligible(),
>> just fix it.
> 
> Oh.  Why?  Please can we have a description of what's wrong with the
> current code?

As I replied in another thread [1], this fix and commit 0ef8faff490be
together make up the complete patch originally sent by Usama [2], so
they should be squashed together. Without this fix, all memcg-aware
nr_cached_objects() will be skipped during memcg-level shrinking.
Besides the newly added memcg-aware shmem huge shrinker, XFS will also
run into issues.

[1]. 
https://lore.kernel.org/all/51f48626-c38b-4cd6-a826-92d107ae35bb@linux.dev/
[2]. 
https://lore.kernel.org/all/20260715103516.2410175-1-usama.arif@linux.dev/

Thanks,
Qi

> 


