Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82341109B46F
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:38:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53F86B0096; Tue, 31 Mar 2026 10:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04D56B0098; Tue, 31 Mar 2026 10:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1ABB6B0099; Tue, 31 Mar 2026 10:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FE5F6B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:38:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4DD32C3DEE
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:38:39 +0000 (UTC)
X-FDA: 84606614358.29.FED51DC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 22E92100004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:38:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wv1cbtad;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774967917; a=rsa-sha256;
	cv=none;
	b=q2Rutsq9f3j5ns2N2wMxl4R8BlHv7prxl/+k82uuR2HBSxOQVUFkvV+laFtAvqnJEONl2Z
	VOqJheGcpX//io2R4P3JTZORgodtxxYU3jqAa1i1XHVf4LFUTCR2k1eJGWf6+SUCUv4A3E
	96IFmrRYut1nbbLDcDdSrDm20Vyxdg0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wv1cbtad;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774967917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHBK5RTcHGLUApVZiHj/Q/LEldgau7IiSnUjcS1LBic=;
	b=Kl48UjZX5JQwW0RC3kaRiobCt1G2BuF3ykMyAZbVFBmDDBV2bgdlpI3PBBx4HtaKlz10ZC
	BD3V4ywq92fUTum4wmfNQY3694Z7Sk9W0YrdpDIMAZDpB81OZLTGT6a6Dubyp5/PS32XzU
	nnXWGNjKqU60ySZxdOgHqrdTDrMnVgw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774967916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SHBK5RTcHGLUApVZiHj/Q/LEldgau7IiSnUjcS1LBic=;
	b=Wv1cbtad7x3HjFQzQcrGo7knI/9yeJyuQ8dFMCCXXnxNnYEW3H7fTqfD4qvMiuh6FyTGQZ
	M0mPzYLRa5j3Gdz7K15rN4wbmoWfI4t27iqXbqGgNWoMZX0tbSIPQAZflIzhApe59S9Yk/
	8DduwNt9rM1kv8VABt8EzdQv8ImZS84=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-193-eVd53RCqMKiPhEyAHC9y8g-1; Tue,
 31 Mar 2026 10:38:33 -0400
X-MC-Unique: eVd53RCqMKiPhEyAHC9y8g-1
X-Mimecast-MFC-AGG-ID: eVd53RCqMKiPhEyAHC9y8g_1774967909
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 14F8F1956065;
	Tue, 31 Mar 2026 14:38:28 +0000 (UTC)
Received: from [10.22.80.26] (unknown [10.22.80.26])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1756030001A2;
	Tue, 31 Mar 2026 14:38:20 +0000 (UTC)
Message-ID: <f24641b7-a177-467c-9554-e2ff188ca23e@redhat.com>
Date: Tue, 31 Mar 2026 10:38:20 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/15] sched/isolation: Implement sysfs interface for
 dynamic housekeeping
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
References: <20260325140432.GE3738786@noisy.programming.kicks-ass.net>
 <20260330114620.104027-1-realwujing@gmail.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260330114620.104027-1-realwujing@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: t3dd0U10IZbmekC6KLov1qWdvBds3hAGWGyoCCYibCE_1774967909
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 22E92100004
X-Stat-Signature: a35tfrwxutstj4cpudrup7ze9kbdi1n8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774967916-956420
X-HE-Meta: U2FsdGVkX1/IzmRFcRWbqZMXP5ZUD3MbOzfFAvH8btOLJ8lvkg6uvgiEcRrgjan4Q5Ds/vUDLhotFF67HRJuYIw7Nqd2fCzIZGj3RBRKahCpH5OlRImKx4PWNX9hRFII6UTZsmDeyMTy2Xuu20VvEFlBe31mSYRt14O0IRFcsetVyxyq4ickKpC/VbOxG20K8F/pZuvOM/mTTSx1/of7IvBLle1escy3pL2LvLMspdiMJmGT7HG8q3nOS+ATKBCK8REqv/yAJ9qsmgOU9oIyM0Swkp3uzaCtWnOdxo6n1OHI1jS7v4lEB6TsOBUcqoxKBMxmbsd9iJYG52w5X7acZDiyqYCG2MObWxGKRj/TSA/Rc5CPFY0jeQVfHmWDyBlbaTHZWYr0QPtVO3Icw4Vie9VH0Mdl/+0XXpqK/INMFXRcQlY190+TQGsFNLfsQe6fblCsldtejM0SPvXGdiL0PwQ78FZFZJSfa3hj1b27MrPtOvZtOEWwltP+7qPpDFSaKfBXpx7xgizx27zJZw0um7bpV7A2XI59leFhNnbGcP4UbWfOeuTos1PMcmS5v4/kQYq0vXZy9lXY1I1xcefzSNPrs4DcXNNP3IOqt1M8LwS13pb+L3i42WwTnaW1qHIzIpgwex+h/h+qMRMbDNbdMCMi2ipKbw7l+iJHs2CbvTgvdZtShoRIWc8uDL3ghqoW/UOeJ7LyYuOtXcQRp6Eg3iz4htREbWwijGRmqCkNejR1WPP0yo/NIFN8i8sUv8wA7eUDUPaTadnHCBv10RMgFe9rrCdAmt1Kb/gIE50Xn8bW/o0Cg47wu3pREdJSA7anPoAXLSt8/a5YA0b4m74jCR7TYAUBERlRlD/jbnyT3X6wfO0Rpz+DNjYojNpVq+nqjYto8bt8EE97Xx9MGtbKRg21ZP0l7zRKSsur+UZh6gJVHWzqgY15sfdjLOOTPmIhnJUFdacIxuPYFF25arc
 mmC1woDW
 jtEGd+cJzb7NBnQlvSAUUH0qQRWb43VG1XGS/RFI+VGBpCEMOTTNsnBdFALrGDdKjuyRFyeqyMS9O8H2AMuOCbmtgJ0OaeID4YlIbgpjCmrnfHRd2Bq4dICBLz0wlJ/dreIOs2ZE0H9spxN3H8Gizi1HmFPy0LikswO+4BNunzSPCdOVYiwyiZdo8Gfcqep2aFsRJBKwVLaA6uCivvGby2i2wCuL6lDeBOm4zpSGyRKPjPa92dkUwzojQvfHXckVmwtvMJ0FBh4Cr820FoKRfZYjogtWIwTbfM2QtPOowPFrk+TNZPkujrR4BG6NQ4yoItSzgtl5Jmrne0BYD3R5kFGp9NW1zzL8Wy6ecl9Ans3ANfs2+j/P4psw9bgjMftg1lzPQgpuU/a6+XuA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 3/30/26 7:46 AM, Qiliang Yuan wrote:
> On Wed, Mar 25, 2026 at 03:04:32PM +0100, Peter Zijlstra wrote:
>> Why? What was wrong with cpusets?
> This is the central point of the architecture. The distinction I was
> trying to address is:
>
> 1. Task Isolation (Current CPUSets):
>     The `cpuset` subsystem (especially `cpuset.cpus.partition = isolated`)
>     is excellent at managing task placement and load balancing. It
>     ensures no user tasks are pushed to isolated CPUs.
>
> 2. Kernel Overhead Isolation (Housekeeping):
>     Currently, `cpusets` do not manage kernel-internal overhead like RCU
>     callbacks, timers, or unbound workqueues. These are managed by the
>     global `housekeeping_cpumask`, which is settled at boot via
>     `isolcpus`/`nohz_full` and is static.

My plan is to extend the cpuset isolated partition mechanism to isolate 
other kernel noise currently covered by the nohz_full and manged_irq 
boot command line. That will makes the HK_TYPE_KERNEL_NOISE cpumask 
modifiable at run time. It is not a direct modification of the HK 
cpumasks as advocated by this patch series but an indirect one via the 
creation of the appropriate isolated cpuset partitions.

Cheers,
Longman


