Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D14109E55B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6F06B0088; Thu, 26 Mar 2026 02:48:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A79D6B0089; Thu, 26 Mar 2026 02:48:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFF366B008C; Thu, 26 Mar 2026 02:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA2386B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:48:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72952160C15
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:48:31 +0000 (UTC)
X-FDA: 84587285622.02.D6DCE5E
Received: from toronto-edge.smtp.mymangomail.com (toronto-edge.smtp.mymangomail.com [209.38.81.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id BCF38C000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:48:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=XxwiZltz;
	spf=pass (imf28.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774507709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vatpyTHCvApxrpdQIC/dp3cKCrlOiEv4QlZzcoloOko=;
	b=albsNa5iWzmZOipt5FPZzS+cMYfIAI/3NlRN1i7BOu9PppSOAHiR5OLP3cq7gJH+uiH53w
	sZDcMUzHajTrk9Uxu1W1FhY72iIL33RhLdqJGk4G32oJpYBIUPIspGK7sjEltuyMHrZRNZ
	YvJ63BQ2uIdN+3jnNWL/23vSv/o1dus=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=XxwiZltz;
	spf=pass (imf28.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774507709; a=rsa-sha256;
	cv=none;
	b=NA71eoEeTj6a5ny/E4A2JcBtSZmVEGWFEDWiTCSSBA4qQKQ4CXSHlEkg4yqWi2fwcbHCSO
	yQD1WoTGwFwn+da5yTPd9FHk2tKrsVWvjz2yXp6WsB/A7G5X3voWTcebr9ZXoXTRyADF7D
	TaqOT2VyNIDDq4BVzGee8k6/WXNBEdw=
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTP id 84F925D9C4;
	Thu, 26 Mar 2026 02:48:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774507692;
	bh=3EuSxHtkudq5kGLqdpvQzp2LofPCcj5NY0hFbWKHRwY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XxwiZltzYTzUbZgbJj7WdHS/IcmTagynFNvDFKTtrfQuZJwGK7TMBAd2aZttyswUD
	 JL5uX5IcAlO4lplY7KVS13SzRnfYndqizuE2LkfdAHuHuw6A4llsFC1YcQKFvNG6ai
	 r8SwfWUgtWQ/JQ/HUrMw7PncyoE+fbwoSCv+/v88=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest
 SHA256)
	(No client certificate requested)
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTPSA id 796195D9BD;
	Thu, 26 Mar 2026 02:47:04 -0400 (EDT)
MIME-Version: 1.0
Date: Thu, 26 Mar 2026 07:47:03 +0100
From: oskar@gerlicz.space
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, Baoquan He <bhe@redhat.com>, Pratyush
 Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 0/5] liveupdate: tighten handover cleanup and session
 lifetime
In-Reply-To: 
 <CA+CK2bCiqCg1Tt0WgP3KszrK96Qahcgfyfige4eUQOkMVyLUqg@mail.gmail.com>
References: <20260324212730.65290-1-oskar@gerlicz.space>
 <CA+CK2bCiqCg1Tt0WgP3KszrK96Qahcgfyfige4eUQOkMVyLUqg@mail.gmail.com>
Message-ID: <7628da0465cd09bfc16bf9353f37045c@gerlicz.space>
X-Sender: oskar@gerlicz.space
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCF38C000C
X-Stat-Signature: btsrq4goz41utbzwgqz7nez4kdcc975n
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774507708-763959
X-HE-Meta: U2FsdGVkX18m81BLVMO+I4PG5IASECSBZtu9rs0F8siPXyz7/VS9aP4fdZTnZ0+P6GQZQqxle2SWx6rRTO+7w+8H8GY+2qMQgHeD4aRlpGG9v/Ic1Q/ec2lbA+mKU/oolMoOducQno8Q5kbYtFA6U85LAAi5V18jAlUffZ6/lpkZdHT2ZLNW8nBlaLpvE6RiIG/Pr7SvZTQ/ZUEfK05c7BQt1WCYMYmKKA9bq9odkjOQTphcrV7OsjhIyUOOy8pKRrIerxXAOt+4GEFioalwL1oJ8xYj2LQfeOPSJ8HVuAEK5OLWKYOdKo5KiOh+9gkbSbFm7DR7ddSp7709oB+JekZSpCyiikucYvT2mV8D3DD1ZLgAzAFRe70sV1Q6NT92EsztHYhA+XKBJpAwrPqXdC3oHaCgK/IHR3HD88YMVSyWR5N2HksnBotV3N5yOoQSja6249wdgPkD8H4YsqLG5Rv5m+0phc2K5cXC1UMLa1vxF+qmYGHMhBLpHg3liYLPgrI5INQqaHFZcxVVHr+1ywF+dOwkN4VUKB6/+WyIieBJ36YbE94Pnk3UytUIiBTHoryJvR5XH8Tt8g6H7Qoe7859Ts/31wrjUIrRPBV25jrgb7UkJ8HZA6MH20HP/aIAyfdfoeA6SW3DFqrnCFj+8tukNoAIDdZcUcaY9/IE4lle6RDkuyJu2Xv55n64NxIy8X+RLLcBXsyoMMtF+Ku5RYDNLKn6Zk17r+/h7FTE2UvMNxEykOPN41wrO4+1WUBjrOLGmirKXcSWVv5rxELdfaeGrU/i+mwNwb73C191O2g1Z5+lOt6GFBshzUAyeEYcCHqpHVdPTqaG4TSlUAsMbwszLI0zUZnk1374EZiKAlB3A3a/YRpFag1O/JuxnRz3xcR66v+bupR9suej2ZWzqTkcuQZLgJRdo54rSPArTWlKOi8iF4FQEcLaCrRfc1Aqv85yek/U2CwuN7cJlph
 kcv1I4xO
 ImD0hdxyf/BtaTZVl4rjIijKNjPFNHOt3CCuqPoBG66Z78+fSKa7F49HhRu5o2H+ixsXpREdQyWcTfROwWxCbTuFvS7J+5deA1ibfBlJ8PdTPBEIxY4JzDFt+ECTqv4/HsUYudeiB8prt1ViVmF6P6cafMOuvGkO5IaC3tFP41bsE3ClO7uz5P2DjxKcLBUywsjSrTR0b/sBnA0gtMXAC1ujpIKAOIyDTWghNA3Hw7433fVYP5DE8WbS1zpmZPmCwdLRdBuyk1rYwyF/JkkPmnNyLYHtHieAgDIlcKki7OI/KcbMGmO/n9hIQFVvvkB9jOmK1mg0WM/3xAo1/Qu3EK4sFUn7Jw4HU4vFmiMvyS+ftSkrFi9QXQENpOQrQafHT37WfK/dL7BjqDhTfEwWeyYK9wzHb3uu2ZCx08VvnBXv6Re8/U7tXGi+JSdPI070Db5MvMc2Y2YS9t4k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-25 14:38, Pasha Tatashin wrote:
> On Tue, Mar 24, 2026 at 5:29 PM Oskar Gerlicz Kowalczuk
> <oskar@gerlicz.space> wrote:
>> 
>> Hi Pasha,
>> 
>> this v4 keeps the simpler direction from your mail: outgoing handover 
>> is
>> still driven by a boolean rebooting gate, refcount pinning of outgoing
>> sessions during serialization, and session->mutex as the serialization
>> point for in-flight mutations. There is no return to the earlier 
>> closing
>> counter or a larger session state machine.
>> 
>> The main changes in this respin are:
>> 
>> - reshape the series into five commits, each building and standing on 
>> its
>>   own
>> - keep incoming session origin immutable and use retrieved only as the
>>   checked-out bit
>> - make FINISH and implicit close consume incoming sessions without
>>   reopening races through retrieve-by-name
>> - route deserialize failures through explicit rollback paths for
>>   sessions, files, and serialized memfd state
>> - validate KHO-preserved extents before walking serialized metadata
>> - harden incoming FLB lifetime and remaining teardown paths
>> 
>> Patches 1-4 keep the core session, kexec, deserialize and validation 
>> work
>> separate. Patch 5 carries the remaining FLB and teardown fixes needed 
>> to
>> match the final tree.
>> 
>> Oskar Gerlicz Kowalczuk (5):
>>   liveupdate: block outgoing session updates during reboot
>>   kexec: abort liveupdate handover on kernel_kexec() unwind
>>   liveupdate: fail session restore on file deserialization errors
>>   liveupdate: validate handover metadata before using it
>>   liveupdate: harden FLB lifetime and remaining teardown paths
>> 
>>  include/linux/kexec_handover.h     |  13 +
>>  include/linux/liveupdate.h         |  17 +-
>>  kernel/kexec_core.c                |   4 +
>>  kernel/liveupdate/kexec_handover.c |  22 ++
>>  kernel/liveupdate/luo_core.c       |  16 +-
>>  kernel/liveupdate/luo_file.c       | 237 ++++++++++++--
>>  kernel/liveupdate/luo_flb.c        | 116 +++++--
>>  kernel/liveupdate/luo_internal.h   |  14 +-
>>  kernel/liveupdate/luo_session.c    | 500 
>> ++++++++++++++++++++++++-----
>>  lib/tests/liveupdate.c             |   2 +
>>  mm/memfd_luo.c                     | 160 +++++++--
>>  11 files changed, 934 insertions(+), 167 deletions(-)
> 
> Hi Oskar,
> 
> This is a NAK.
> 
> This patch series is still significantly over-engineering solutions to
> straightforward problems, and the patches read as if they were
> mechanically generated rather than thoughtfully designed. The sheer
> volume of changes (nearly 1,000 lines) is unnecessary for what we are
> trying to achieve.
> 
> As I pointed out previously, we need to keep this simple. For example,
> the problem of preventing a return to userspace after a successful
> liveupdate_reboot() does not require inventing a new
> liveupdate_reboot_abort() function. It just requires placing the call
> where it's the last function allowed to return, with a simple
> exception for context-preserved kexec jumps. That is a trivial change:
> 
> -       error = liveupdate_reboot();
> -       if (error)
> -               goto Unlock;
> +       if (!kexec_image->preserve_context) {
> +               error = liveupdate_reboot();
> +               if (error)
> +                       goto Unlock;
> +       }
> 
> The same principle applies to the other issues. You are doing rewrites
> when targeted fixes should be applied:
> - Sessions mutating after entering the reboot() syscall?: This is a
> 14-line fix [1].
> - Destroyed serialization race during liveupdate_reboot()? This is a
> 70-line fix [2].
> 
> I was hoping that v4 (BTW, why are we at v4 in just a week?) would
> include the patches I already provided, along with similarly scoped,
> minimal fixes for the deserialization path if needed. Instead, I am
> seeing another over-complicated rewrite.
> 
> Looking at deserialization, I am seeing, you are deleting a comment
> that explicitly explains our error-handling design:
> -       /*
> -        * Note on error handling:
> -        *
> -        * If deserialization fails (e.g., allocation failure or 
> corrupt data),
> -        * we intentionally skip cleanup of files that were already 
> restored.
> -        *
> -        * A partial failure leaves the preserved state inconsistent.
> -        * Implementing a safe "undo" to unwind complex dependencies 
> (sessions,
> -        * files, hardware state) is error-prone and provides little 
> value, as
> -        * the system is effectively in a broken state.
> -        *
> -        * We treat these resources as leaked. The expected recovery 
> path is for
> -        * userspace to detect the failure and trigger a reboot, which 
> will
> -        * reliably reset devices and reclaim memory.
> -        */
> 
> You are adding a bunch of new functions to solve something we
> intentionally chose not to solve. Attempting to cleanly unwind and
> release incorrectly deserialized resources back to userspace is
> dangerous. It risks security violations and, in the worst-case
> scenario, customer data leaks. A failed deserialization means the
> system is broken; we leak the resources (make them unavailable) and
> rely on a reboot to reliably sanitize the state.
> 
> Please drop the over-engineered approaches. Use the patches provided,
> keep the fixes minimal, and do not alter established security
> boundaries like the deserialization error paths. Take your time to
> manually self-review your work, do not rely on AI to do everything for
> you.
> 
> [1] 
> https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/commit/?h=luo-reboot-sync/rfc/1&id=d47b76707c4f352c3f70384d3d6a818e2875439a
> [2] 
> https://git.kernel.org/pub/scm/linux/kernel/git/tatashin/linux.git/commit/?h=luo-reboot-sync/rfc/1&id=f27a6a9364cd0a19067734eeb24ea4d290b72139
> 
> Pasha
> 
>> 
>> --
>> 2.53.0
>> 
Hi Pasha, thank you for the detailed feedback and for sharing your 
patches. I understand that my previous version was overcomplicated. I 
will rework the series to follow your approach and keep the changes 
minimal. I plan to send an updated version later today.

Thanks,
Oskar Gerlicz-Kowalczuk

