Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 460C4D358CC
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 06:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43DB76B0088; Thu, 29 Jan 2026 01:58:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1696B0089; Thu, 29 Jan 2026 01:58:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0136B008A; Thu, 29 Jan 2026 01:58:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 15C106B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 01:58:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3AD8160737
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:58:43 +0000 (UTC)
X-FDA: 84384098526.20.8DFC736
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0702E40005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:58:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FdGG5wVb;
	spf=pass (imf07.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769669921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amjRWMpaEMjLDf3MZKS4cBxTUgjJdzny4u+rmxhl3fo=;
	b=cwMCIuCYrmjdw+wEpsqhSO2SAJJpDE2pf2kSFB8pTl01aZ6YMEbZrn+Y7OFAvSF2+yidPj
	9WVrdzFsLf5rYEkwT8eZYS7hIIvHgL/vcQjyjc1gJO8qFs99vadj5BzeIQDL8Tc/tz8+d4
	LvjJLRaNib0yHKoj+9t1UZm1CC32YxY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769669921; a=rsa-sha256;
	cv=none;
	b=JMQ76pZ4ffCwSk9xJVxy1VTx8aYtKVTsTJ1wNkxStNsHVEmhvJ+YC0yFJFXu7XjJyQQnoF
	wdyZeINZciDaslnTq5kXLNbuhbLsaSlESDKVBc2ivWzzazD7qEqnHzQ5wjsUUkjHTxMzIQ
	prnuY6StzL0a7V4fD6E9ilMMBpDdtWs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FdGG5wVb;
	spf=pass (imf07.hostedemail.com: domain of zhao1.liu@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=zhao1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769669921; x=1801205921;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6q9ecXOAduobTNUC7At4SbfE2hkxTHIZg3D9BGnKiuY=;
  b=FdGG5wVb950wI6jmOFIZ/5uebXRA3mae/8Ukw7UYjI0b64DHmtnNVHEG
   Ytq5lidTJJjshEv7TzDhLa5769ZIvLBi2rLdlr5p2q21cGyMeG/95dlXb
   f7SvGxO0aGtiyRQsseihFrAD+ekQeB7xTAu5LpRvRGdLNE650+CfSQJ07
   K/b6dRaqPGqBtQuDI2rfpP0nGBWFuZQ+YGRK7ke0fvEwvTRHhsmveKvO7
   MsME9Q4I/i9Hndy7DBDWVk68JNijeB3d8Lqq7WzXyPgMqpVKqikLLzu0E
   jD5U2RK+PatMMhq+pKiCKmlbO3mp38I8WkV8SOkaNGbjyX3R6KvFN/gZN
   Q==;
X-CSE-ConnectionGUID: X5+JIJurQ/ukQ8N/eZKiGg==
X-CSE-MsgGUID: PSZc9e7+Rf6kxKbCUL50dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="70793009"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="70793009"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 22:58:40 -0800
X-CSE-ConnectionGUID: Ph1sbCvuRqGMBhv8WnM2IQ==
X-CSE-MsgGUID: DLGKmnjlSyqn8GrIn4Qipg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="213360551"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa004.fm.intel.com with ESMTP; 28 Jan 2026 22:58:35 -0800
Date: Thu, 29 Jan 2026 15:24:27 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Message-ID: <aXsLKxukv60p3QWF@intel.com>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
X-Rspamd-Queue-Id: 0702E40005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: z547qszgc3w5ge8f9mppkmm7mop6jpi3
X-HE-Tag: 1769669920-262715
X-HE-Meta: U2FsdGVkX18IDC9xcBYoIujYLWE60apttMVvxVA5JwUtUV60t+URcZBzOzBoCi7h7QPrkbO6q2iwwip68uLOpAjsmDEXAksInc0RuOVzS1v1c+YuFrbnSEway5fFYwKbbhINbiH3RjLL6S1C2qgRsu63d6Dl1e1fmUykOMDtzO2SZ/cKRLe30hYZ9QtBes5W8EyUR0gaylAb89tGLDDYnW5Vm1QoZyjkQ1t5Qy4yYfdfYHXRF8MEtDV7DJRlm7mRuMQ3QbafNfJvc38Wy0aL10CrqwInS3ZRoGLL10WUj7LmLgPQFKs/WPIDRiw/XzOzB2Uoajdkl8DSFKshoMy6zGmv6kA2quJdDp5iBXuoaHUfqFhgBynykNZNCO7q61U/bxeZ6V5ZJROm9AehBpVzKCyl5FVceACcvxxI34qpx+Q73mEnAs1ooI4LzzT241GGdbKzAxOP/D+d78zOCID6QtBdwEGrTcXIg7wbQAekyx7zHg+P28XJEcYiJ9B09ROWn7qdiB7MCtCqar+2aZoavtiKAohuflEmZ6FVX6uy1TAKJ1c5dmlg5N5JdXIxr/K7uMIHSENiGkmeZCcTtMJFRnN/iE7ixyF/qYDzKHqfDV+aWI0W5wiSPEA6tw5d0TdPuH8xitQAvbnjo5nqhGcl+kWzBRPxBbIWq2WRooe3FIZnqMle+IvsjK3VDCuc9bW/C2I2ie3zqSqr3XUHc3NJSmvAu9HZeNOGyyU5dd4my1vUWBfLHh+DxEaYDR+Qxbor/TsExrw71vW7Ue3QkXlUtQWoVwFRtwzr8m3zRb7seU0FwIh7PlcvAfh0jVu8NeItLakRujjVNf0u6ml/wMYWfvcVeALndd/H8PJtQrRs2kihlAnCwhUxW3WSRn/6C8boVuJzFnQdVpgEUFuY/Lj/EUMd30d7wNxwJ8dnLCFnN9S/VRiqMdO7LjhUpxT8bWHZnwLdMfzzxtiK9i6os4s
 NY/pmHPO
 oip9hkSSzUcw9gVB5Wypasd1z9SJufjutHqwQzHTEJK91NODsSsuVYzPABHbHddmXp8Q51ze8gsidpF713+CwBUO3MMeQQd/4nLuztzNU6yZFIi3aNxGV5PIL4e/4K8hILrjrA6r5KdXiWeB0BpdhaFd0rr1iI8dlRA6yzKo945nqrtq/I6fVq5kdaMfCmQlkJ2MUg2EECrDe5gRvwImZS4Xd78pu9wOg1zhXw+hCJ1CIU1/fOXfRMDVmfu3Aw0eSMJ28D5vN+1UVV6o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:44AM +0100, Vlastimil Babka wrote:
> Date: Fri, 23 Jan 2026 07:52:44 +0100
> From: Vlastimil Babka <vbabka@suse.cz>
> Subject: [PATCH v4 06/22] slab: add sheaves to most caches
> X-Mailer: b4 0.14.3
> 
> In the first step to replace cpu (partial) slabs with sheaves, enable
> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
> and calculate sheaf capacity with a formula that roughly follows the
> formula for number of objects in cpu partial slabs in set_cpu_partial().
> 
> This should achieve roughly similar contention on the barn spin lock as
> there's currently for node list_lock without sheaves, to make
> benchmarking results comparable. It can be further tuned later.
> 
> Don't enable sheaves for bootstrap caches as that wouldn't work. In
> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
> even for !CONFIG_SLAB_OBJ_EXT.
> 
> This limitation will be lifted for kmalloc caches after the necessary
> bootstrapping changes.
> 
> Also do not enable sheaves for SLAB_NOLEAKTRACE caches to avoid
> recursion with kmemleak tracking (thanks to Breno Leitao).
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  include/linux/slab.h |  6 ------
>  mm/slub.c            | 56 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 52 insertions(+), 10 deletions(-)

vm_area_cachep's capacity seems to be adjusted to 60 and
maple_node_cache keeps 32 as the args setting.

I still use will-it-scale to evaluate the impact of this patch, and
performance results appear to be on par with previous ones (*) - doesn't
have regression on my cases.

Based on the results of previous capacity adjustments testing, I think
it shows that the capacity of the maple_node_cache appears to have the
significant impact.

There may still be room for optimization in maple_node_cache. As a
general-purpose algorithm at present, I think it has achieved its
intended purpose based on my test results. So,

Tested-by: Zhao Liu <zhao1.liu@intel.com>


(*): The previous ones include 2 cases:
  1) w/o this series, and directly based on the previous commit ("slub:
     keep empty main sheaf as spare in __pcs_replace_empty_main()").
  2) w/o this single patch, and based on the previous patch 5.

Regards,
Zhao



