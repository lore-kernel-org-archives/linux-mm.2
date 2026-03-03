Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA6AEC1436
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 12:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10E36B0144; Tue,  3 Mar 2026 07:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE9356B019E; Tue,  3 Mar 2026 07:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4D96B01A1; Tue,  3 Mar 2026 07:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFAAC6B0144
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 07:07:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60B621BF64
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:07:24 +0000 (UTC)
X-FDA: 84504626808.19.3590044
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9765D40008
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 12:07:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=koXv92vt;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772539642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GEamnsKnviIdhVg/tXlg0bwb3/+Znta3MDE8yxHJSk=;
	b=dtcjuw/JSN4nPOt2n/U3MLK8ube3dSrEJXP2v4uGSrrKi93KeLzT8zlBNzeljX1CgIsKHR
	exPlN8iAKlwK/nAXx/UOZsuMISmBRtGwDcQ7S8Wc17PkFal61Cskg4b4XqQmttLBcc8DbB
	fiK48zXBh+hYFrDPE+8/VbW47oAy+Os=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772539642; a=rsa-sha256;
	cv=none;
	b=UjDdNo+h6CELVKdJXiFYJFJJZQrBEZmA74PausYhL281/r0drDDH/tVNHUTBRNHYtBXDPp
	569SBRM4tBobfeUocdj56FRJczMzAegqyof3ECFs5ZblDtI/S4dM5LI7luNVJteoBAGTJ2
	mwoiQzfTbbutdbUoZd9emlmB9V4+tzQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=koXv92vt;
	spf=pass (imf04.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84D2643982;
	Tue,  3 Mar 2026 12:07:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C156DC116C6;
	Tue,  3 Mar 2026 12:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772539641;
	bh=OftZ/sLQ3XZObtm9KS4DhoduNw0kAtMoQOE5FA4IaC8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=koXv92vtg4amiUxo+E0FB6Q3wlqRd/moYmVlVgLGl7KJOBS0EykVY9kqZU7NFKqHr
	 tRvIT9kMlNhDsdj3OMQC7HhyrjIpMSValH9x0h3dPWSV5xf34IRQX+SmlTTPwqtioR
	 +06E3876eK5keDwI2Lb11i+IP1Ao24EDQ4CvjqsPG/u2Yx2NNakh9XU43tGQFmuXmI
	 I5TTpYK8CKiWUTj1AwrzsGgpQkyRM+ExYcM9CxP/EKkZ3N467fynD2n/Gdo+efmAb+
	 IrPocPEyo7xpm5hS1PZH5l0WqWOBRIHz31+W7HoiceCqxmODyVutSVGM1eOS1uZZuY
	 mhDLmhe3bfgBw==
Message-ID: <9c10f799-907e-47ce-8ffb-e196ab0bee7e@kernel.org>
Date: Tue, 3 Mar 2026 13:07:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] Introduce QPW for per-cpu operations (v2)
Content-Language: en-US
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras.c@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>
References: <20260302154945.143996316@redhat.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302154945.143996316@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 74tddiz33jqg7anouiwxoz71i4i1jagi
X-Rspamd-Queue-Id: 9765D40008
X-Rspamd-Server: rspam03
X-HE-Tag: 1772539642-457276
X-HE-Meta: U2FsdGVkX1/KrB0x3T5GkmpQ3EZyIWTzJn7CLQB86HR4SFbq7NzZkyAiF6zlcsSBFkULDkFLZ0LUPxCShp089mFUF4HXuY8OcOiA/D9vrO9IIiN1BsQ76ZuGuJm+BxthfAhCDyTCnQ+tGYR3mk79Xo7g8w7oLVjLYlTsdY0bjC4adf7G/sH4AiuuJnDLzbwLz2CKBVj1eLcfOYIMVfM+I5S9CJXKJJPW4dT5cAEN5ynQ9S8DUJiNRXdaLkJ/+EnnM47rUXGsyb7XIxgwtsWKNTP3XOdpgtmHEN8wMd3FDUaIiAJYoPPU0xFR/9eML+w0DhxN6HVKfIuHftTf4T7PHIp2PU/3G8go9k4ucaRzJSabmMFKJZBZuK+o2ZsQAHt3qn06V2X7P4SekgOS7wOsaLpoVNIPtzf9MOlZXizd6xGKY2M+QVA98jTrgkhDztsyZqHmpd6im0StKUTJQpo4MDFQEb1DqB5JGFZpUp+QoXh6DdbJSA+G3wANrKro3R1qRmJRa4T4tlJ6CLTsPCIPj6+RELE6q7eihbGhHK7JDWU8VJbpDxu6XH8URpKmMrBmjn74y6MqkdjSA5NhefdqZNd0Gcj2KQwHe2UsJVYpej0auDIkCB6J0CAsPBBD7KV34Ylgger4XFGG5VUU8yxvORtWOB8fVk70C5AUrYbl928pMVMeH9BC/wxNLaQ8Vu2MkQqgqdWC0tEcsFi7eHDHxRDoZKoZ0i1XuKIAbB3uuGwzyv1iRQf0zuFvZTjvozTxbIWRBk6Z3lEqXA7z3+9KX1oNUIylzcAfJsx1j0sxXeDz7LKPeEMw/lyR9xRn1d5yEkQTfg4vuDqLSspUlbv+dXpM58cJ6k+I20rCTFUp83Oyj0JrmioNlHnOJWMc7uVze/wGHw1+D9h7lPwmrIyArMNaVhhiIpVXTDSHX+C+wTT9yhn1ZsvQ4+24XC0fPFW0oTzissOlwpUzege918J
 uwmpusKE
 mqmUmBgQGyt/OArmIW5GNaxt5X3w77r2HGR+oTTSE1bjXO2wHVf7fWx98xreIipNX5G0LxNj65wc1ggzK9N2M+Apwzo+YH8ev+s2zFkFR4NU+sZ05XV25WweW71HttU9iRblUP/CR/ct9wmULozdCantKEvPwaVoq+xBfUbXlkd+ETQlj8RJrA27NZJKsxi3uoY5xCMG3h3HvijEcoGg/bNiADTG+dTnH2rheePRkDkK5rcZaB6TmUtqyhCD2Hleh8JyfvSCnokzl1KcY6TbYxOtJyaTTek4JbAi/R6At3y6JeS0gz2WVqB8vjVbRKq3T4BvmMQ+XIWFIhqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 16:49, Marcelo Tosatti wrote:
> Proposed solution:
> A new interface called Queue PerCPU Work (QPW), which should replace
> Work Queue in the above mentioned use case.
> 
> If CONFIG_QPW=n this interfaces just wraps the current
> local_locks + WorkQueue behavior, so no expected change in runtime.
> 
> If CONFIG_QPW=y, and qpw kernel boot option =1, 
> queue_percpu_work_on(cpu,...) will lock that cpu's per-cpu structure
> and perform work on it locally. This is possible because on 
> functions that can be used for performing remote work on remote 
> per-cpu structures, the local_lock (which is already
> a this_cpu spinlock()), will be replaced by a qpw_spinlock(), which
> is able to get the pe
A process thing: several patches have Leo's S-o-b: but not From:
You probably need his From: and your Co-developed-by: or some other variant,
see Documentation/process/submitting-patches.rst section "When to use
Acked-by:, Cc:, and Co-developed-by:"

