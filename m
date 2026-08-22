Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8572C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 19:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846676B00A4; Sat, 22 Aug 2026 15:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7956B00A5; Sat, 22 Aug 2026 15:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1F26B00A6; Sat, 22 Aug 2026 15:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7A56B00A4
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 15:56:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1E9FA2ADE
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:56:48 +0000 (UTC)
X-FDA: 85129963296.02.AFEC5CC
Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	by imf28.hostedemail.com (Postfix) with ESMTP id AAEB4C0004
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:56:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=XLYnl1nv;
	spf=pass (imf28.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787428606;
	b=rsp1Twg67OIIR1RbYlRnGA2kUr64giiC/LZ9XXXcwHzbQgtNFmG7t1/g6biVzbNaY8dddd
	MnExQ9C6VEfXfW+i/7zT7JM+zAMCdexc822qURKg5BpjyTv5JvX82RG9rymdTOJco5vDNJ
	OUts0HNvacLQzzo3kZ8If++N7WiTc9g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=oss.cyber.gouv.fr header.s=default header.b=XLYnl1nv;
	spf=pass (imf28.hostedemail.com: domain of jeremy.jean@oss.cyber.gouv.fr designates 51.159.188.251 as permitted sender) smtp.mailfrom=jeremy.jean@oss.cyber.gouv.fr;
	dmarc=pass (policy=none) header.from=oss.cyber.gouv.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787428606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGyAzcejuZn6RAjVa/a1UNl3aOmLKX5vj1xgrjkiRNA=;
	b=2NGT1cmsqfYdArPLu1RI9iVnlDOrMlERpeJg9JStRyf2BhfK0kdWxIH0/3z7BYcCMpf/GC
	cWjpRd87eAHLTry1RwVe7EHZpIzUVE8WHVGd0spK9LbqgZAIwyGNX4bl/6oeap2ur0C8bS
	O01FOQxnW0OJQMK19H+1awAs9MI0fmQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UGyAzcejuZn6RAjVa/a1UNl3aOmLKX5vj1xgrjkiRNA=; b=XLYnl1nv6UUUvlELTQeZvW4pui
	DMX01V18BZs9ybR4JQXvUV+CyznC7C/NdNbXuLElV5Az0CbGzp1kZ2B9W+wzj2Ns3yhOHeDXH9t1v
	sBiSsQJmx8nsERV/QO4pVlrMLExageAKF/QIIoKhQJtwy4F2Cw+/Y8YuSmg/5BEJphF/3vudK+j3P
	wzTe2uc3L09j01V7KbfT1kYowLCd+HyfyaKDEq7C9qSUtslrSguNpD4l3L+hiTV6qd5n5NCyNUElu
	9Q1u83rQkquN+Vtott5JLxKhM8Iphw088YAibCrYorlHDrta+nS8WBv3kq22WVGrfo5GBOSnhyxFg
	3pRbi6cg==;
Received: from [::1] (port=48334 helo=pf-012.whm.fr-par.scw.cloud)
	by pf-012.whm.fr-par.scw.cloud with esmtpa (Exim 4.99.5)
	(envelope-from <jeremy.jean@oss.cyber.gouv.fr>)
	id 1wxrpe-00000001M0l-1Mi8;
	Sat, 22 Aug 2026 21:56:45 +0200
MIME-Version: 1.0
Date: Sat, 22 Aug 2026 21:56:44 +0200
From: =?UTF-8?Q?J=C3=A9r=C3=A9my_Jean?= <jeremy.jean@oss.cyber.gouv.fr>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, mgorman@suse.de, include@grrlz.net,
 bsegall@google.com, dietmar.eggemann@arm.com, kees@kernel.org,
 kprateek.nayak@amd.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 vschneid@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2] fork: initialize function graph state before
 copy_exec_state()
In-Reply-To: <20260822112248.1b7e1b1d@fedora>
References: <20260822084927.547141-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <20260822112248.1b7e1b1d@fedora>
User-Agent: Roundcube Webmail/1.6.18
Message-ID: <7ca3c3808b2820d058b147aca6be92f3@oss.cyber.gouv.fr>
X-Sender: jeremy.jean@oss.cyber.gouv.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspamd-Queue-Id: AAEB4C0004
X-Rspam-User: 
X-Stat-Signature: etqdbc6x6apydonb3ig8ct8ghcrdh56w
X-Rspamd-Server: rspam06
X-HE-Tag: 1787428606-476057
X-HE-Meta: U2FsdGVkX19LwKk6O7D45vtLrLQH/yYBnQeQMI4ZjzXEUsVxFi121YatbB5TNxpIMcwllkSXKD75DJjffjbsOA00LFGmT6d7WUeOeswWVGC5MSYFvPMOHCxEmnfX/A1lIfMYt9SFUIs93W1LzQYN+OgTtf7BxkIKhmzih2C6UbQjdyl/C4iw7UFw4kkEmCXjDziXe4TxXuTBo3dUSOzzJS3FpzegFAPa2oxstaHYVO0CkwjbxCTmecv8HF+42TKT7040MVgcsG/9ypfjCVRgchILMe35GvOxdnEAeVhi6ND0r1rMoRP9O2dcUUT93oKxTnkxltPFvnFzFWk6wiyitgPztxgv+xjRN2YyNLixrNXGSR1TqfwvlLWjY28ZAWOWNbhUyNqZ0Zhr6K3oTy9Z68Bf3d4iPtdjgEaBs2QzOltUBbx1+VZYX15XEzQl6x4OJrkpHJeLGxKmDFF/jE2DMo/zkWFm1dl1uZw8xm2/Y8rWbySk2CM7Fbh75PaeizDNyn5wlm/Le7qcBVa1/7GbEFVHTJa3zQqQ8picyM8/fl1kxXrsXrO6IpU9YVxeT7gNeXd277ItXQfEzguamnMENrIuX79fONIorPFP+pRVwin5kYmgQQKxyxjrkZrP3/PXWLDC/1AU3JVLrv6lv7E/qYsJOnOlILCIrUNrzxoibjlrdlMMLF1mUOPOXU6ti0iXLrDg6E0nDM4B7xXFeB6KC/T7VP+2D02gCiKSw96S9cZRlLZzNrwLiyUDdoBCP40wircuLJTKbJGRrTTdJHRxOe712PdqZ2V1mh5ZDfel4US4PSLVg4wybsO2sUk0YtH+7P1/o2en2kXYIkrKuS53i4bmbR/TEj9hGAIKIWWcZXse3cZhZM2ZpTDK3GfUdyc1zVnQib5W9+EqjeMQuVHmcMDHYLQzCvOtF7VUSx1zk1rFGglHgeygdosE0pGP13R/4b7gu4pQShzWcCo1ob4
 mQfqC1U9
 vxBZhS+/23/fB/lNJ8FddLyLoFPyEbsBzXTiQ/GE5C6dTBtxnngjukdP8m5UCfvb4SCjBNbg/NrDXhmW2Ebg+d8wj8ysOj4KvkwcZNJzVq/56zc+RZO4IpIzZNUwOI7tSTTkb+LtoLoHIRSMZnwIkeYL8kBqTBNh4OAzYDbCYh9TModeVZJTX2cZ1gVIeon8Sr/FvnCnpbaS/wnla+Gq+uaId0C7Bdha1K7fOeLgO0CNVnsIiKIiXRuBHsD1PncNYCsnprPr8Y89+WPIckYwYVHoXT6tAdTWmMOdTCORoHR3oAC2ZCF8M5pLkey1lIzir0eFLkVijEaK6V/Sp6Ax/80qOAOdDzScyAw3wnrj2rmXZ1Zpg/O+BqVAHnCVOhz0nL1bey3D67ptqV7D5c0LTeXAbmHETnTTtUKcYGNAAC/T1WVTVsat0mYbeHHLv7MzbhNctpIgGDZPekRtHm3qBO8umAbO/w7s67EFwzcBu+InMYfGhTpNmTdluRbJKSA/rA8bxFAXKLbByld3/QCFQHlX6H1DZ9+7UDLb//n1RrIU1BmMM9lF8qFF9cUu9uGbhA+DD/xnUKO8oIR2uVfwU2pmSeBcI4TUhX9buvHMk0IQSTxqKjsiHslx1vtl5c5eXOZmOb2Y402LdmCLbqjyNNoeP0YDk8ub0CgS6gPJ5/+BtMLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-22 17:22, Steven Rostedt wrote:
> On Sat, 22 Aug 2026 08:49:27 +0000
> Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr> wrote:
> 
>> dup_task_struct() copies the parent's task_struct, including 
>> ret_stack.
>> ftrace_graph_init_task() clears the copied function graph state, but 
>> it
>> currently runs after copy_exec_state().
>> 
>> For non-CLONE_VM forks, copy_exec_state() allocates a new 
>> task_exec_state.
>> If that allocation fails, copy_process() reaches bad_fork_free and
>> free_task() calls ftrace_graph_exit_task(). Since the child still 
>> carries
>> the parent's ret_stack pointer, the unwind frees the parent's active
>> function graph return stack. The parent subsequently accesses freed 
>> memory
>> from function_graph_enter_regs().
>> 
> 
> As this effects function_graph tracing, please resend and Cc:
> linux-trace-kernel@vger.kernel.org so that it gets to the proper
> patchwork. It will need to go through my tree so that it gets the
> proper testing.

Hello Steve,

Done. Thanks for the feedback.
Let me know if I can help more.

Regards,
Jérémy

