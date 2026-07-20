Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BF8C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555886B008A; Mon, 20 Jul 2026 04:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 505CA6B008C; Mon, 20 Jul 2026 04:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CEBF6B0093; Mon, 20 Jul 2026 04:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 148DE6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:13:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9966CA1002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:13:45 +0000 (UTC)
X-FDA: 85008441210.30.B3E6A44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id EA08E20008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:13:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8IgDzk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784535223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lz64nxvRHnxb4ksQjjT3naqJCvqJl53tkNdxM+mLsqc=;
	b=zaJtfk0vRQbXdAbXf504ErY0eOr9UmNU8QJWIzbXmrXENPM1Ca5yGQgeUEGuOlv7LbV1pq
	7nygB6F8gyIZl1IMjVGHcHodE9QNxNKOAiXl7BBfq2A1yjN2iWZgyFX7o0duBMm4gOqEFk
	ZCXw7GVzPAx2C6Mj0+m+mIZleHrhIIk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y8IgDzk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784535223;
	b=TzWFf1dpcGyUkqJO8/UeJpTArPI9xLQnGCTb4lXVfFYgLNwaVFLVKa+90WwlHeF95CnVoG
	2/nfBaK2g1DWPPp2W0lJYXA2U2hfIO1qNACSM5eTzv1u5eCL3tjSW5SDpMSC8A19/1Xfk7
	huSBmJBi9OCCVd5HKDzP/Rj1sSn7TVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6A82A60103;
	Mon, 20 Jul 2026 08:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B988D1F000E9;
	Mon, 20 Jul 2026 08:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784535223;
	bh=Lz64nxvRHnxb4ksQjjT3naqJCvqJl53tkNdxM+mLsqc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Y8IgDzk2B+MRXLL2XaNtPhyozX76XtuObQQNMZJidmsfE9nO6ezXK0f6/4cGyJO10
	 Br5bVrxUi32jEYAjgLMcnl1c3XE5kkVK0INSHZEzrVp91vhYvaBJaL5GQtdgTBJHvc
	 nYSNPH63+iswtNlH6B3B1qA8LdkZrgM5OB2SwxcqUE/lmOegjUy4b5cZuWx6z352wF
	 oOVO0nmDfMhou0iACJzxNpkFNI2Y7buBrxmcAlgGmuGMilZKyIfRlqachpVf5wJ/FO
	 EWEgOILoKj0eS8/FPdcvp1cRfxSwI9TDM3QB6UmKBIJerYhGyaW1jl8x53phv5MJxh
	 wfglJVo9v8C1A==
Message-ID: <d1180a70-f4b4-4c22-9ce5-881cb0e2370d@kernel.org>
Date: Mon, 20 Jul 2026 09:13:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/7] mm: defer address-space teardown of large exiting
 processes to a kthread
To: Aditya Sharma <adi.sharma@zohomail.in>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, imbrenda@linux.ibm.com
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260719185409.409685-1-adi.sharma@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EA08E20008
X-Stat-Signature: pwbyparodh1fbjzuudt7hg5a99xiupkz
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784535223-478417
X-HE-Meta: U2FsdGVkX1/FNoM8EMR2huNHabYSgTsMgvN7OhHvqmCObgx6PWNusOT/Hom3ZEktdoKXhzuv/+Lgzbp2V5/sgUhrmVYeVYV36xjJDpTSrKHwQjlll39MMsf9Z200nmg0WVrb7fFS6beY5dTJ2EgrVpLrRcwKliHqvc2mq4GqtpQB4RiaRB/Xx77M2SMFF2azkexwD6d8SI33TzwdbpEGIVmMjg3nQOb1fnd8WtwN+TFhrGbJ5uZEbKGmsby9pLDvxHwthCU3J/4ON+qXh6tiRCykzuU4nfMcHCJDjrWVQ87V2TfzlvtB0cXtkKgDQo+J4nEJKIqdjKd2JbvD/pBp7v9qsBHI8jKjQMe36EjWdYrJZMUwZInwHkygs8nWPxI2NMl25+kLfCRNnzVVCvYaYg88HTr/GB/6MPrwsPaksswqxUx9exAb6kwyIb6qH0/abmRKF0cly6F1Zi9EfGRGHQAONrUCLYFpG+xBLbqiQ+KaeMFvCPLzCm1PpKZvajBBtg+dtZYFnGqZ3AxIAWjC5Wj1J6hoefCl0Ep+upqTkIe4lhxDexSGwxpdpTikwzGLdlPQgblyXOdqD7O6F9jUGllfoPEUtlNcL5VjVhukR6yxVM1NP9P4pJmB0EMEh36X6wgxz88nq20ihUx/xFyt2+GXepNDOelwKic82EpWbKbahBPvM4mnAIA4w5wNC/HIWYJGcmTScYapcItdpu7nYt79bByQndIzqcYmpkG90eHlxhQbJgDm09mMSab1cBiBelXkdAL8tYhRbTasBM88SoNHLddeyQNvnuMh9u0RVL0XPXbD5u2Cy5bzD0Cb0P1GW3g6onEHqd1qRHKw9QE2vMqbOGqD0diPyBijYFTclePeNPZWMB7Ha+dHKb3uLHt903dhL8AGugbWQi6OeRNIrTrs+dA+SoZ81vbdMMEN7UjGRS3gnUZou8HKbIdvIQ0ZkRTjemesWUX5CnusKS2
 LiqFwMuY
 V7yK83mLhzrYN3j/IPNjPJNGFV9g7N/1I+rQmkQszQ9nIjkNtoFKgUcxP4ypXaFPySjAXc4sW6ntg5JuQaD1+TifBHL01hUuKplZonbshgkfK5mBtDGG4F/NpqRmQnKZhcjDIB+reCpXZzrl0igMATDMlTun/yWULmCrNxsfWxKNHyNWmc8ZwrikNJCwvbUHuonES/KGDp56Hq+p7k3hD9SVv0Je/dFWd7nSDkP3TXTJGg2fetmdENVsi4RQHx0UUqGzl7tfjlE37xAcaYE0atvW+P5qLrV/v3AmAnXXvcrj3U+2J2K/3OQ355IbQaOCrU0yJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/19/26 19:54, Aditya Sharma wrote:
> Address-space teardown on process exit runs synchronously in the dying
> task's context: exit_mm() -> mmput() -> __mmput() -> exit_mmap() walks
> page tables, updates rmap, frees the RSS and drops file references, all
> on the exiting CPU. For a multi-GB process that is hundreds of
> milliseconds of exit-path latency, paid by whoever is waiting on the
> death: a supervisor's kill-and-respawn cycle, a shell's waitpid(), an
> orchestrator reaping a fleet of workers. On the test box below, killing
> a 16GB process costs ~280ms before the parent's waitpid() returns.
> 
> This series adds CONFIG_ASYNC_MM_TEARDOWN: an opt-in, default-off path
> that defers __mmput() of large exiting processes to a dedicated kernel
> thread (mm_reaper), so the exiting CPU is released as soon as the task
> is reaped and the teardown runs off to the side.

QEMU has an rather short implementation for async teardown using
clone(CLONE_VM), which is IIRC essentially the result of Claudios previous
kernel work you note below.

So nothing got merged because the problem was solvable in userspace.

Without something like CONFIG_ASYNC_MM_TEARDOWN in the kernel.

[1] https://github.com/qemu/qemu/blob/master/system/async-teardown.c

-- 
Cheers,

David

