Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8FCC10F6FD6
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2323E6B0005; Wed,  1 Apr 2026 11:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E36F6B0088; Wed,  1 Apr 2026 11:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9ED6B008A; Wed,  1 Apr 2026 11:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EECFE6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:10:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F5191B8CC1
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:10:54 +0000 (UTC)
X-FDA: 84610324428.16.D80F6AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DB26A180008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:10:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oGe/ULv2";
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775056252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fvrb+r+i6H4Y6w7OkE5w7uiB17jZPmQpsq6JyHjXwH0=;
	b=zfK4iiJdu5K9AZM0NN5gYc8oVOj+z7TqDSzT/HrnpI3jEFiTVw/nbzeLBEtCen/LH/vuZp
	VRLEJNedTYBQjZkuM+gtUeDs+AqW4p2+ASzAXl724QCJrds5SDjza5/tAr0OgslJ/ViftU
	ELW/SdC2wVnWJBUp4HS9CfckAhrNl2k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oGe/ULv2";
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775056252; a=rsa-sha256;
	cv=none;
	b=Md5jcxcvW4NGCXBAE6OFIBOJFmXndaQ4NxEFXFnCYS1K/wGaCupL/8qLMioIoAjMwHJJfZ
	/3XFQqrvcilkUMhD4+mjZ2K8a80HumyI4eQJ9S/fJ6yAFGUtt5mVTkPCFJrEMzMb6Cvnfd
	NXvGkTPSHxg9UPSnTbKe2QJ4Pw5FjyA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 412DA600C4;
	Wed,  1 Apr 2026 15:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D18DC4CEF7;
	Wed,  1 Apr 2026 15:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775056252;
	bh=olLNXQNPSNANzm/RqYjvnGKwcWnramj8uM7ajoADoRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oGe/ULv2hjYXCL9Z+63Ugi+kE3bHkKWyIG21yK125KIIcvhfKiPqos/3ZNHZuvqJs
	 mW4LNL1CzE+zvMoeGJ9Ide79iokyxq9Eb8HEWmQUM9aU4JNjZCNUZ1HBfBgEZ95HTG
	 tmyzemIMQyzfvR4GcTW+Cz3FbK0SEbxVLMpJU0T4ELm2/XwxE1FguEqT06luE2pQ7S
	 Znn52y8bTzQrhNM0QrXYo59A3a1vvR/WWbEFBfz8L1EaFJH4Vqcg73vO90HpH2st4U
	 0oaglNsOJhFgPx5MP4O7JSnmaNmpZ5gJB9o5I0TPNmrZf1PJM7mY0WPpxBB8XtZQLI
	 VizLhu7wrrb+g==
Date: Wed, 1 Apr 2026 17:10:49 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v3 4/4] slub: apply new queue_percpu_work_on() interface
Message-ID: <ac01eSIlZIA6EVYC@localhost.localdomain>
References: <20260323175544.807534301@redhat.com>
 <20260323180150.335869265@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260323180150.335869265@redhat.com>
X-Rspam-User: 
X-Stat-Signature: e3gaqyyprnoyp4qan3hdphwk64yh3bck
X-Rspamd-Queue-Id: DB26A180008
X-Rspamd-Server: rspam09
X-HE-Tag: 1775056252-247426
X-HE-Meta: U2FsdGVkX1+sedNfPVyI0KW2FyaJaG/RMhf/lSUUD5JXpjGE2Kwa0GS8BWqtmg5W3TBkj1cOYPETi/53zObGTAfevkJaqRIwcEGynQJkLfOpXby7sFS33cEtgwOAQXV6ct7vYYoI7esXlNRUTdwJn1SPAKde1rv5zsrCJ3DXIFPWbA4kMz+4fiSar3H7xdRWEH8DmN13PxEK4Axyo6wVbyVfQp7Yj5mnkEyTeMgk9CEZKfH64ddeqV5+8PWk71UPGpKwbxVI/M4ApriY4WMchxFwxPk0L7FvkQKPSbA9aA98TrJOpB0IDMs4PlE701c2ZSk2VskhS2HRJCrLe9h5WQceNUF8/PVd1xHDp8lprRYAAdPsT2VYGyDgc3VUA7gurfTmOOEND5peDuN9zSM+I8vQI6XnsCRFSmAdFA2Og4hMwl2dDIsavNFmGKv8WohQVkbMh+tteRnERe/ZzDLjmPlduBpR0ieEwere+u0tD0nABK/OZ0yMdO7bq3JxeZnG3d5ANTCsTZ52UaM1yfBXRDrKQANk3scDWnHzxBbWPrWRN/rcwyzgcxPGPWupE5VsRxyaWjqclFaG2qQLOS34TkYPRi4elCI13QylQCqDMv8U3Sjka55MYhxTcbko/DqZbLAautp8Hky43I81WTQEgzp513IFpsjxa8ElcqFZkV8Op9DawVR2o4ALJFj29E8ckcXZOvI6JbpND/mcm9suC/BnvpAPW3xpkAP4YKhtGLaDlfSDBvRnYzQtTSj2T848J7f6PAj+pXhYF7mM2kq3ywv1jMRzirZUrz1L/EZt3ODrnWJ433jnfZ+759HteiK0XRNfAlixAGN8IcWkI32xhEd507FNP5+vGoXzQMIqgDFjpqYM6HwS3dcSNiyVfPU1IpfzYzRD//SIt9Uul782vY84epf98Ue8liE/QNQHACqIYE1xh7q++Vv7fyanHzX9vKptEQeQCMfEVmQEI9/
 5OMmZSqe
 ExDKPA0zGYj/gq2JK2TpFtu25iQ4T5ypiqni6Eb8lpoPhB0SkumQn8/qMqW+yY0oUeliQUaQyAYvaXANvP/jHtphdcQOSvb72fivdKe3DeVJanAXSxDGxDBHlRMGcYfvJrQIaR67WXnUmSEn/sL/iIa5VCqgA5kdLVShDh+Y60mb2o2t+cqFyU7Qb72hE95UXVsl/Wfkv30DKLviooXWqjk6ZG0sttYI247quUNI9cvgOl7PY7CW2Jetx+GKSUf7MkPQQWUoUZTXpk/IozKxosav3J5N1k8zhcJG0VqsmShWbOLtVO03oz8+ZU4rjQ2cKcTw68b73F9Y6w1ekewkjSTvSbGjCN2LR22xBRknm3BJf4ypg26b57/6LaQRDtLpRbEEHngsnBsFtpwkwdfpiy580FDk56AYjo27WiP8wyUq/foM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Mar 23, 2026 at 02:55:48PM -0300, Marcelo Tosatti a écrit :
> Make use of the new qpw_{un,}lock*() and queue_percpu_work_on()
> interface to improve performance & latency.
> 
> For functions that may be scheduled in a different cpu, replace
> local_{un,}lock*() by qpw_{un,}lock*(), and replace schedule_work_on() by
> queue_percpu_work_on(). The same happens for flush_work() and
> flush_percpu_work().
> 
> This change requires allocation of qpw_structs instead of a work_structs,
> and changing parameters of a few functions to include the cpu parameter.
> 
> This should bring no relevant performance impact on non-QPW kernels:
> For functions that may be scheduled in a different cpu, the local_*lock's
> this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).
> 
> Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Again I can't review the details but I'm fine with the approach once
the namespace is fixed.

Acked-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

