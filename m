Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC1C21099B59
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 01:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C396B00D0; Fri, 20 Mar 2026 21:33:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123A46B00D1; Fri, 20 Mar 2026 21:33:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 060626B00D3; Fri, 20 Mar 2026 21:33:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA8856B00D0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 21:33:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81E7F140501
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:33:32 +0000 (UTC)
X-FDA: 84568347864.22.85BA4FD
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8FD79180013
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:33:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rky+Jqsr;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774056810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vqCvjJm0bWKZTBGX1/5T2XI0o4s04odjPkD7DfRdD1M=;
	b=ikHzz8cXFaBMuhaJUX9+cn/72t2XDb7f3AV+oHriaUKtwPmoQ9q87xBHnrKKVXdNzbOkTu
	XWdfQqd/F+Ee6jT08giN0IahI3n6qMjaqzgSTOPqnNkD6BvEYEW3nvDVdhABPq5GGO3yoi
	YUxoAvDHNwwQOXyixeOxhkTNRXOnevc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774056810; a=rsa-sha256;
	cv=none;
	b=0nvRFRhfogWMlEKZXjz7r0nH2BUhakginy34PHmfaXmQx5riWrLZB7zh7ibqwPtfdw/k+d
	XFrYi6FSyW+2oKy7c1k1AqFovgVL6ROG84JmRGVdbNUXu7C8Eo3xPd3Hx2KHgCB3DsXZCx
	akHVLnoIc/wPvnR2Fx6rE0iev27oja0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Rky+Jqsr;
	spf=pass (imf06.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82418b0178cso1330257b3a.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774056809; x=1774661609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vqCvjJm0bWKZTBGX1/5T2XI0o4s04odjPkD7DfRdD1M=;
        b=Rky+JqsrHxXNS66+3rwQk22aEUwTf51Vs1FvIl8RuKZLOoqov8qPmaEU5ZYX08/5g9
         EZBr2ZhgthIBAjBcOfFslOW6CCOCihZE35+iGcD5ZdeVL27lBDqBFhjoDTZzAoFkipHf
         rj+LlQfT5wizfWpR/daYIFbSZrRoegOYlcNuocgvkWkCaFkfgLN8wPJYp8dk+DE401rw
         HOGw1WpjAdPePwB6GdBYQk7RYNuEeO0m2JA/SBwm40L7f+JFxqUA9ksylbVIWf4/S9YM
         yEkauBP/rNIZ71zuQ35HbA07R5gGJpMKcCuI7raMgcZVBkY7DFoh5llIPB7JcvzR5J/H
         IUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774056809; x=1774661609;
        h=content-transfer-encoding:mime-version:references:message-id:date
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vqCvjJm0bWKZTBGX1/5T2XI0o4s04odjPkD7DfRdD1M=;
        b=AlxXrnafvU56BqERSQ2rwkICDSd7phmVfYSW/x3mktgFWxZvIz0I49ghhDXI/PXtgH
         Wt71n/xqKFOi1y9GCKuFBpFrRfiEDWn4J1a9n26dPuOG9H0nHGL+ICJmJ7BIM+P7ddhD
         XyyAMK01URdx6+MDxO0811TlDtHBW9ailOMiULKbRcforZpPAzHdt1BCaR6Ke64TfYlP
         zxQUNgncjwa5umFTtrlM+asBKNyxXURHqreNgCokqOqkvVH5TNjRNTcHqNZ0L9259qKV
         aYZJ9v3qaXhqvuzsPUJeUE5NlpiG8z/OhUmLAQJb7ZK6kbpao3iDm0lyGdsKb7pXf9Jt
         Cv1g==
X-Forwarded-Encrypted: i=1; AJvYcCW6yc9AyS4HHmmnnMb9IEJLM+oHqu/lhwdlsK2R8pqvTbYCNF/koMwjES+o3xnPKZzuo4KCjptmvQ==@kvack.org
X-Gm-Message-State: AOJu0Yzxva6QbVK8rNa7jIOexBR02SQH6bXjCz9mAmIoQopN25ttXQXf
	Bd1f2wnZ0/nR0Eb9O9OZZ2v3Ohuk3haKmBEiJun0GVwmZhVKCkPZqhN7
X-Gm-Gg: ATEYQzxxtvGcArxz8My3eYjUGS9I1HtesgptFkL2mgjm5SZHBmu1qxr7e06Okhd53Ia
	Cy7tzLUjpY/NW35RlSH368cPDwoy/42G3lNzOC16Cab+KiMxaoQSZ/xSRgFDfKqpX//+db8U7Xg
	79uo8PDeY3CiVk/LWreSJKq130Fk4Mwynk1YeEEF6i1A2q8uCVxM5y/e0PnbhaF+S6T6vtyC8dR
	GysrSuzWHyRPGvB43TKTSV46Y3myrBsEKFU09jI2h9OcmfZ4j1392eWMIUx8G9H8jr9mtZaEakA
	m41+uNc7fYsX8LC5r5RWiUzZNL3f3TB0jG+mUaZoCrjsNW1M/TTcdIQwjfXS0OXTclT5CTXukf8
	h3g4tmt2EWNBQJ5UaJuepp723ujxo2PT0nVyGGxKmE9cCyi9h0bJh8vzRZQqnSteXQVUUsPTmyj
	E1Lf7NwtPkFtx28ORLadp0fA==
X-Received: by 2002:a05:6a00:1397:b0:824:3bd9:aac6 with SMTP id d2e1a72fcca58-82a8c25fa6cmr4148762b3a.16.1774056809329;
        Fri, 20 Mar 2026 18:33:29 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03aa9fc6sm3253724b3a.7.2026.03.20.18.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 18:33:28 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Harry Yoo (Oracle)" <harry@kernel.org>, linuxppc-dev@lists.ozlabs.org
Cc: Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
 Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Michal
 Clapinski <mclapinski@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, Steven
 Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Srikar Dronamraju <srikar@linux.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com> 
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in QEMU on -next
In-Reply-To: <7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
Date: Sat, 21 Mar 2026 06:42:41 +0530
Message-ID: <h5qax9x2.ritesh.list@gmail.com>
References: <20260319233745.GA769346@ax162> <abzKcGiRSR_E8lLN@hyeyoo> <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com> <ab1J9ODkX5iChu-C@hyeyoo> <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com> <7a8faee8-0eb5-4e58-a6d5-ef711791e3f4@efficios.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j31c9xsdma3c1fm33jpsuzmshrjst6ks
X-Rspamd-Queue-Id: 8FD79180013
X-Rspamd-Server: rspam03
X-HE-Tag: 1774056810-169705
X-HE-Meta: U2FsdGVkX19qCnqndx5EEOu9SWm7C7fdIiAijBXTg7gbZpzjMDNXjpvI6WCEvOwHQXkuNtFEUE5xMYFxki5VY57fPCXJhvon8n9ScTIG4cztm3SNJPaU2AOMym0T1zadQSUkXiuboFSY4Zwdx4fQe1e18nKc0IeX7D5Kg3uuLH83AtPl0vQNY57RpfoDyDU9ms9fCiPIhsRTlPfE4dmSZ1HKEYEBgPt/nn8ssI/iFndFnrTu3yd3lE9yc44zhHlj8XX9k0Wy8MPMLoXkVdLp8+hSx9bkogz82e/E1h1BXhoUFERxMSlJcnA+9cOnLiAr8zT/MCuSWnfQkc3RlKytPn9zVceRPHeNixxTsOjIl/vtxSjymw04H4ByjbYlg/0RlhzILyJNS3mWM24ESlpZ6tYOn1nOMNax2OmyXGwOL7sHOAAeVQzJBpfUB9NlwjAhmilqMTJ6Sn9w+07V70BL10T/i0D85hrMEQtG6D5prb+K4ObFUsfvhAdEGKWv17A+84ckOjG5AuBplBfQOgshBz1MX08AbVUge5BSXASq84c84TdTfAhO2+XPEtgcthGdbV8SUvxkbCJ/v79Ork3NdxmD+iXs3uBFRjc30Mwa+1FuLsjLh+8V89HON+ytyk7H/vbTNxCCVNbpNGS3wKcsiFdsfCumerAMho8cwdwu1RW9d0YZpCnaN424BEUyOPERsAHpf3Z4xkKDocLAH7yxVc4EhwMRuOiGQhF1tFFLUGsQ4NvmQjlYmCRKiRlFccdaYQtXyjKMP3ZXNSoEWy+QSV1Q2kPf+GXccVL3WTqRpWBcAyVAiLArxDpFEhq20FFfPObS3E/qkIMKIYxBwj9Wm/oJzNYWY647hNsuqco9nJApBg5bF++seZ6LAOvuWrL7DI2XBuLTUAmkW9bKNNlBZziFp4XRiwIH6yOzqc5Phxh0GTdZMSMQrfWba3C3n04LFGKjfGRchcpipqV/RC6
 9EN3Uci4
 KzJ7q+2K0WwKx6Jq5C9lUh17I02Tluy91yCAxGfmmBAIp1bbVDfUFgD4jUt6jCwbaAEW5r4gZBbfBciGELbpJyjphNRzxXXv8BH8aIoIb0gJyQZSX2D8v2dikWWjQY5Th93Nggd+NMln5j5QaYax86ynUK6wKTI67SKLxmhFE+gql0AZqGPlSFCq7NW3qttp2e1bynps/YrbMZQ6ood+AMsg8lladw5fjG6Vwdxzv4z+UrecTYVYhpGSs6bpNHdPPR1bqXY32IVqcgx6MCj4sO5TaZFoLRpiRP378x6b8ejBLZAx2rAIKsMPHVX883INRlEA0dzOkeRQnZ2yJH7tUBVPpe32TVWK4NoevtTA9fX7IMJZwFr3aZUjvDANkYm+MDNesnKxUC9qh5sgnwN3hyyNSwuWMK58SR5HZrYW+RLoWD+ogGXZMEl+m2n+wVYlD6wnPDYgR43kd4TgZSx8TeyXYtR2dgkMeefyQjjerCa+dAfGdkaQNFJ1daqYUvPcm/avqMDIIwRzZ0nA9Yj+XHTXDxQkGOZhlcO2I/Kxeg5nibD3RHazXLFy9NS05dy7t77CflzuBppT+cpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


++ linuxppc-dev

Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:

> On 2026-03-20 09:31, Mathieu Desnoyers wrote:
>> On 2026-03-20 09:21, Harry Yoo (Oracle) wrote:
>>> On Fri, Mar 20, 2026 at 08:35:46AM -0400, Mathieu Desnoyers wrote:
>>>> On 2026-03-20 00:17, Harry Yoo wrote:
>>>> [...]
>>>>>> [1]: https://lore.kernel.org/20260227153730.1556542-4- 
>>>>>> mathieu.desnoyers@efficios.com/
>>>>>
>>>>> @Mathieu: In patch 1/3 description,
>>>>>> Changes since v7:
>>>>>> - Explicitly initialize the subsystem from start_kernel() right
>>>>>>     after mm_core_init() so it is up and running before the 
>>>>>> creation of
>>>>>>     the first mm at boot.
>>>>>
>>>>> But how does this work when someone calls mm_cpumask() on init_mm 
>>>>> early?
>>>>> Looks like it will behave incorrectly because get_rss_stat_items_size()
>>>>> returns zero?
>>>>
>>>> It doesn't work as expected at all. I missed that all users of 
>>>> mm_cpumask()
>>>> end up relying on get_rss_stat_items_size(), which now calls
>>>> percpu_counter_tree_items_size(), which depends on initialization from
>>>> percpu_counter_tree_subsystem_init().
>>>>
>>>> If you add a call to percpu_counter_tree_subsystem_init in
>>>> arch/powerpc/kernel/setup_arch() just before:

Even though powerpc is showing the warning because of VM_WARN_ON_ONCE(),
but this looks more of a generic problem, where use of mm_cpumask()
before and after percpu_counter_tree_items_size() could lead to
different results (as you also pointed above).

Looks like this is causing regressions in linux-next with warnings
similar to what Harry also pointed out. Do we have any solution for
this, or are we planning to hold on to this patch[1] and maybe even
remove it temporarily from linux-next, until this is fixed?

[1]: https://lore.kernel.org/all/20260227153730.1556542-1-mathieu.desnoyers@efficios.com/

[    0.000000] WARNING: arch/powerpc/mm/mmu_context.c:106 at switch_mm_irqs_off+0x1a0/0x1d0, CPU#2: swapper/0
[    0.000000] Modules linked in:
[    0.000000] CPU: 2 UID: 0 PID: 0 Comm: swapper Not tainted 7.0.0-rc4-next-20260317-00008-g5585e414f073 #4 PREEMPTLAZY
[    0.000000] Hardware name: IBM PowerNV (emulated by qemu) POWER10 0x801200 opal:v7.1 PowerNV
[    0.000000] NIP:  c00000000008f3b0 LR: c00000000008f330 CTR: c000000000090e20
[    0.000000] REGS: c000000003cb79b0 TRAP: 0700   Not tainted  (7.0.0-rc4-next-20260317-00008-g5585e414f073)
[    0.000000] MSR:  9000000002021033 <SF,HV,VEC,ME,IR,DR,RI,LE>  CR:24022224  XER: 00000000
<...>
[    0.000000] NIP [c00000000008f3b0] switch_mm_irqs_off+0x1a0/0x1d0
[    0.000000] LR [c00000000008f330] switch_mm_irqs_off+0x120/0x1d0
[    0.000000] Call Trace:
[    0.000000] [c000000003cb7c50] [0500210400000080] 0x500210400000080 (unreliable)
[    0.000000] [c000000003cb7cb0] [c0000000000ad850] start_using_temp_mm+0x34/0xb0
[    0.000000] [c000000003cb7cf0] [c0000000000ae8b8] patch_mem+0x110/0x530
[    0.000000] [c000000003cb7d70] [c000000000077f30] ftrace_modify_code+0x114/0x154
[    0.000000] [c000000003cb7dd0] [c00000000036a690] ftrace_process_locs+0x408/0x810
[    0.000000] [c000000003cb7ec0] [c0000000030584ec] ftrace_init+0x68/0x1c4
[    0.000000] [c000000003cb7f30] [c00000000300d3b8] start_kernel+0x680/0xc44
[    0.000000] [c000000003cb7fe0] [c00000000000e99c] start_here_common+0x1c/0x20

-ritesh

