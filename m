Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9F6DCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 11:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73AA6B00A0; Thu, 15 Oct 2026 07:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4C0C6B00A1; Thu, 15 Oct 2026 07:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8F866B00A2; Thu, 15 Oct 2026 07:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB46C6B00A0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:45:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F220C0991
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:45:14 +0000 (UTC)
X-FDA: 85324679748.30.816519B
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf02.hostedemail.com (Postfix) with ESMTP id B79FC8000A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:45:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iwKMRuyB;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792064712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=td+2C/ZqZ0tJOzbidUjih2kVEMjBQk+gP/LTrHYJ9ZA=;
	b=wta8Mx8f5Plsv1NzGfs0bX7xcLhFZ/1VOi2HDaU+Q7BMu1rUiksVgsxUBYepasl8I6Y1Ty
	YlAzA8wZpxBq76uZ8H45GjtqiCJBGN9inem41NoSHWYNXP5XWhiNPU/BLjkcX2E/grvoHL
	q/DNpwIXqXaZvRLkr4lsZ3gfwAS7fQw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iwKMRuyB;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792064712;
	b=UjOMAiuAAbrhUYtHTN+BKLmCOL5eCG6W8zwy6uxJnmvhDmINNYh6fgW30Z7qM2zyil2F/B
	OieygmAc+ro+L8BetOw7XGbdHFM9OhZb/BdxVNGnexo+uBIb0WLBoe8ySoBXKCEWNRLujd
	Y0lbaXVp3ZGBvwcAIQssCIWFr38NHww=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792064705; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=td+2C/ZqZ0tJOzbidUjih2kVEMjBQk+gP/LTrHYJ9ZA=;
 b=iwKMRuyBVJxC9RCYYCPJvqQYmOqnh7J9TH5Hro6Fcc6VG3T6Ui3iROJoDGYCyPsXwJmaFP
 pS2Ho7t5nOOc/UzZp5WgM4qBSspv21RDXwcJvSX+WRI0BuE/OrW/qoc2tPWiaKyUYaAAsB
 14f+DuWCr/FRfdIZXDE7nZGRbrbWE4CiYFkqGBb2wg1SykCVslXIisVichKLGrft/HRmSh
 z3FMLZtnQCXllguzJTpogzAooHQxVJ+0seJ65QmRCqSdAphoQXxifUsKXXjiETViUcV3En
 vVgd1yX93k8m9zqWFzqFHLGhx5l2mIlkGSTCP+9phw6Rd2eVDgWIoZFdcRTY5w==
To: "Gregory Price" <gourry@gourry.net>
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] sched/numa: ignore preferred nodes without normal balancing
Date: Thu, 15 Oct 2026 19:44:40 +0800
Mime-Version: 1.0
In-Reply-To: <as-D8ff7oXKX_CwF@gourry-fedora-PF4VCD3F>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, <mingo@redhat.com>, 
	<peterz@infradead.org>, <mgorman@suse.de>, <riel@redhat.com>, 
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Message-Id: <5c26465f-3100-4f89-bacf-b395e413ed35@bytedance.com>
References: <20261014094347.99157-1-lizhe.67@bytedance.com> <20261014094347.99157-7-lizhe.67@bytedance.com> <as-D8ff7oXKX_CwF@gourry-fedora-PF4VCD3F>
X-Lms-Return-Path: <lba+26ad0bcbf+fa3ac0+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B79FC8000A
X-Rspam-User: 
X-Stat-Signature: 93383qzdfu1f9k7hrn53ipuw3kj4i154
X-HE-Tag: 1792064711-354638
X-HE-Meta: U2FsdGVkX190EC5seKraPIDYOW1kq97FQZVaLyWUzTQv+x6D4EtZM4RRAV9LeoyCDOd0Nakx80fA/8KipsEfoh+FiR4ATNNLq2WFU/glu4tTNKmc7QNHgSST1yuNFu2mE5iIimwMTbN9aJrUiglUE31WzIRa3YXMY6bRR3P0mRIRyaMa+h7u+zSoJfZrgToWhJrWlv7NANWodvYtsSqcJ0CEiEkHCLDaZJBAK1mxfPLuDSt0/Z1cvg8hNFIKQQTSJyC7eo5FPu7e/N1RkMCRia/XCfiVPWF6sUjzSJygpILAkS2rHM+Gmu3UxzcjAKoA1jBqo6Cf7G2nzqZFMmKzKqo4akVv6MyBy9gqolVHWb0Se711YTq6oVEFSWQNQWuAF+Aao8FV3AbtHJYA69iymZaR+5/rplxAdd6EMPvTwY3oEy1jPxT5PN9/0LXm6mY3C5yZ6SmYjSbQIQKxK44YHbEYO2ojeOIkjr5vrPTZpThlge9pU67sKAKaDLiCAb0cbK7l1AvZiugz4WQpe4dCT12OCZMDnIktd4efX5wGvWZXOMR0nORYuEacKRXTzxS1FS76nt6BWJM8XYYLmY5uyVTcOXCr8wpscVayaQWToTWYIuzt8vi8vdRCQFqghXuGohvDwDeTfb6XT4/DMF9YX7pLUDPIxYH6HWWkw6nRMLMhl+0LnrCQU9iBLLjabi5bz4AfOzGif/3LnTnzrjkMjDrBl0qfBlhgFYecUefx0VSrSLmpz+OwrMKP8pTSg88u10s/myhxiP71yvl9UZFBSi+JAb0u2IckR2d0jpduO/AHKUBeHDqp3xXLfrRo8/ShqNHFvqEpFHwlJ91bei6M8L/WtEDh51vJ5oMAzCeX1dZM3iUcvCC0RmPLy8Kxt7g4hKXG4gpsSZ5SARmyW/hhKHL+YopIP91hLx6rMYTdNUlXx11o/XMYugrC3px2HTVEAU6Tnauke64VV1SaFBD
 Jzmn40+O
 mNw1fY5FEym6V+PyHxAVrGjn1VGD9BsEk0j2lxAegzCclcpbCsMC5HB16oCO6neFdirAh28m/yTNOLV3YZrS6KGsxYJlcdvqAxCJYqkOjXcrqBF2zbK2IONgTh6eu6XegR/BThMDD+DPKw9ZN1/JjVxEqGZYzVj9wyS7p5lI5nAv2UNk6dyIRJHxon2o0NLLfmPpI43iU9xi29rY5fXcZ4uf1XVsxqgZtk/7v8yN/T5i26r9bAnft9AnmtSEFOAT5mfFj7L8yQ/gJaOPECOFtNBe+JUcc6S/05sxpA9XKmZVbzDcOYUgNXts0sMC1vx63JERMyOeFTAVoYYzaaxObxBdBDWClfvxRxxaq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 9:30 PM, Gregory Price wrote:
> On Wed, Oct 14, 2026 at 05:43:47PM +0800, Li Zhe wrote:
>> numa_preferred_nid is normal AutoNUMA task-placement state.
>> Memory-tiering-only mode uses NUMA hint faults to drive page promotion,
>> not CPU placement.
>>
>> Even after tiering-only faults stop updating normal placement statistics,
>> a task can still have a preferred NUMA node from earlier normal balancing
>> or from previously polluted state. Several scheduler paths consume that
>> stale state when the NUMA balancing static key is enabled, including
>> explicit NUMA task migration, sched-cache preferred LLC and scan CPU mask
>> selection, load-balance locality checks, fbq classification, and wakeup
>> group selection.
>>
>> Add a small helper for normal NUMA placement being enabled and use it to
>> ignore numa_preferred_nid when NUMA_BALANCING_NORMAL is disabled. Keep
>> the preferred-node migration retry timestamp update before the normal-mode
>> check so accepted non-normal sysctl states do not leave stale retry state
>> behind.
>>
>> Keep the rq nr_numa_running and nr_preferred_running accounting unchanged
>> so runtime mode changes do not make enqueue/dequeue accounting asymmetric;
>> the load balancer simply stops consuming those counters while normal
>> balancing is off.
>>
>> This does not clear numa_preferred_nid and does not change memory-tiering
>> promotion decisions.
>>
> Same feedback - need to present user-facing performance changes to show
> the impact of this change.
>
> Sashiko also has some correctness feedback.
Thanks for the review.

For the performance side, I do not have convincing user-facing
performance numbers for this patch. Similar to patches 3 and 5, this was
written from the code/semantic correctness side for memory-tiering-only
mode, rather than as a general improvement for normal NUMA balancing
workloads.

I did not see Sashiko's correctness feedback on the public thread. Could
you share it here, or ask Sashiko to reply on-list? That would help me
understand the exact issue and make sure the next version addresses it.

Thanks,
Zhe

>
> ~Gregory

