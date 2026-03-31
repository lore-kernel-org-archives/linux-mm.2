Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 744F4FF60C3
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 04:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B086B6B009F; Tue, 31 Mar 2026 00:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8C76B00A0; Tue, 31 Mar 2026 00:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980966B00A1; Tue, 31 Mar 2026 00:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 817E66B009F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 00:03:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B67871608F5
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:03:45 +0000 (UTC)
X-FDA: 84605014410.09.58C4737
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E838D100004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:03:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nz1g5H+j;
	spf=pass (imf14.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774929824; a=rsa-sha256;
	cv=none;
	b=uVEowTJcfoHD141li3Y3HHkSUp444yBlkFMOYPgWbpPjhPU91InZdan5TSndKhxo/OY1Uz
	BU6N8S4KsWinTMrpD7tdrAf3tiW9Zb+OCMbAUYdjxJcVTmiWx7T91lhL3KwouaRDl+HSmi
	rqGA5ru28Bc8TkGEu/i3NyfnBvGqSvU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774929824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhQhsVlHkUdp1u8lVh/yc5BWf65vNXkGXbfUATcYfMM=;
	b=xeUYPhmn29Vc82djbRc7zslZZschDe/5sFoteCTwttCQk9LzRvcsp75+32R810ZaVAGvXN
	voFihVNJLrEM3px9rbBjr7vw94Zii2AuEIm+8zfp0NnRruZJY2s4Fk+C6ufYA4T8+qxD2D
	d5+wthEB+iHUfXKCbKgWu4dMbra34o4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Nz1g5H+j;
	spf=pass (imf14.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774929823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OhQhsVlHkUdp1u8lVh/yc5BWf65vNXkGXbfUATcYfMM=;
	b=Nz1g5H+jOksC0fQ76pHe8PtPRS14t+ZBtSc0YJ4blcw++jr5jt6e1wXO3Jesyj2Z+YVSV+
	7xQ3EiaiJIoCdy9+1qCbnCHxQk2cL+wvTT4UuaZhB9+//d6eBUZOYnqtGW1DOfip/RKWJy
	5WRaJJy9XL/MlcRbDPGLn4aJ1zEsVQ0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-638-5dWhUe2xNV-3EvUixeNarg-1; Tue,
 31 Mar 2026 00:03:38 -0400
X-MC-Unique: 5dWhUe2xNV-3EvUixeNarg-1
X-Mimecast-MFC-AGG-ID: 5dWhUe2xNV-3EvUixeNarg_1774929814
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9322E195605E;
	Tue, 31 Mar 2026 04:03:33 +0000 (UTC)
Received: from [10.22.64.128] (unknown [10.22.64.128])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 21F9E19560AB;
	Tue, 31 Mar 2026 04:03:27 +0000 (UTC)
Message-ID: <18473552-2a97-4da9-9f44-ac49d4131004@redhat.com>
Date: Tue, 31 Mar 2026 00:03:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/15] sched/core: Dynamically update scheduler domain
 housekeeping mask
To: Qiliang Yuan <realwujing@gmail.com>, peterz@infradead.org
Cc: cgroups@vger.kernel.org, akpm@linux-foundation.org,
 anna-maria@linutronix.de, boqun.feng@gmail.com, bsegall@google.com,
 dietmar.eggemann@arm.com, frederic@kernel.org, hannes@cmpxchg.org,
 jackmanb@google.com, jiangshanlai@gmail.com, joelagnelf@nvidia.com,
 josh@joshtriplett.org, juri.lelli@redhat.com, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 mathieu.desnoyers@efficios.com, mgorman@suse.de, mhocko@suse.com,
 mingo@kernel.org, mingo@redhat.com, neeraj.upadhyay@kernel.org,
 paulmck@kernel.org, qiang.zhang@linux.dev, rcu@vger.kernel.org,
 rostedt@goodmis.org, shuah@kernel.org, surenb@google.com, tglx@kernel.org,
 tj@kernel.org, urezki@gmail.com, vbabka@suse.cz, vincent.guittot@linaro.org,
 vschneid@redhat.com, ziy@nvidia.com
References: <20260325140053.GC3738786@noisy.programming.kicks-ass.net>
 <20260330114516.103451-1-realwujing@gmail.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260330114516.103451-1-realwujing@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: PEzCZnARtR9gW-pI5PvrodW8O6uvf1Apf_n9uknT6kw_1774929814
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E838D100004
X-Stat-Signature: ei51qs3u6egp3rorktacq6kpjmz547ao
X-HE-Tag: 1774929823-378054
X-HE-Meta: U2FsdGVkX19Cbi/xSdfTUmMebITpASXvKhNBRVVQHXRgG58/IBc1oJ/xVaF7ynGycfEK0nhYmPAyPekDHwaGlyuxHnHWPvPPAjp5ejEe8YQA4cJE3pQWlC6frKLUdN/5+dVz3bB0C3dErEJ++ZepcTqQOc1DDSlIGYz7p39np2auDl4RMGejNMIu//ed8k332aIG1jLvOAN2vV13v/v1/6frOUNQpAPxgxJbM6WzGWMvePTh+AvkHFEZ4w53pgFtNPkRrqfuWkhyHG+1/bVEq73NXKgtMMNycIfqSztyF3TAYZcJyNfl2JvbMU687micjPfStZbClp/y7a6sxsHGji3PW4a211AabmEtEbGcLG7SMcQfMXxeUmvaPtjzUeReRzjPh10ISlf+ou44B8jr0eO6vkZuWSiWJ4JjdRwbeYvBR+CVekdyhQvzsqSBHFptAQk/Vpq57i+grEKuSB9sE2JPgE81k1s//+y1s2pVFYYm+C6OXez/FIR4gO/99azbEXbZwzQ6kLueV8WW/QrUUrZBsMs6OWj6Dut+DWaVU9HHx4Jn34zNoAdxL07eMym02SJXdGVDkQsWCKZrPVxnCFu5krJ+BF53jdHIuNpcB5sskLpH4KNjWmdPXFQK3yve8bvUzWU/oQwqdJg0sosmYpirgdALxDpi6cu6e3/XXgcnFdWT2pOns2jBrh5J+NWuKoBxmeJRvzhlbdJU5Ns0ljxI2/ZQ8YUDnRgE8xW1eQjsIMkmPX4ZXaw4lQRe+8wifHR+HGmuLq3yZFzollrJMrKeK4MluQ5tZYn5uxfMPM7ZkKuhjsKvjHJ7QpGv4Nv7TlLZ5tIDNPQyP2F8L0HxHtwkTfucTmOPXvyaQTKRTXIE2fsrMPskwMWWOCTa1NrBXSdTYGWa4c9vD6g+TJSDDloi4IHltXkjwX3nZ/3P/ne3drgyP7UTB7DyzNvM1NUrxxSo1tWGby6Z+nYjjvu
 y74zTsBC
 1TBI7i9EKnjhqd9iqGnVpg0q9xl/veS6vnbGLz/0WK7LdgLzkpM8wwTiLXOo8mE4Ob8dobuc1GIjXpfMSLYrUy1BzbpOljE8Vufy3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 7:45 AM, Qiliang Yuan wrote:
> On Wed, Mar 25, 2026 at 03:00:53PM +0100, Peter Zijlstra wrote:
>> Sched domain boundaries are not static, they are easily changed by
>> cpuset partition (v1 and v2 both support this).
> You're absolutely right. My description was imprecise. The goal of this
> patch was to ensure that the housekeeping mask for scheduler domains
> follows the partition boundaries dynamically as they are resized.
>
> In V13, I will explicitly integrate the housekeeping update logic
> directly with `cpuset.cpus.partition` transitions. This way, any change
> to the isolation level of a partition will automatically update
> the kernel-internal housekeeping state, avoiding any parallel management
> logic.

It looks like your patch series isn't based on the latest v7.0 kernel. 
With the latest upstream kernel, the HK_TYPE_DOMAIN cpumask has been 
updated to dynamically follow changes made in the cpuset isolated 
partition setting.

Cheers,
Longman


