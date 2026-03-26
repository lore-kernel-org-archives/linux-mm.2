Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D09109E55B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 06:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BD186B0005; Thu, 26 Mar 2026 02:47:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846D96B0088; Thu, 26 Mar 2026 02:47:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73ABB6B0089; Thu, 26 Mar 2026 02:47:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B85D6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:47:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D121A5C6DE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:47:32 +0000 (UTC)
X-FDA: 84587283144.11.0A8E8F9
Received: from toronto-edge.smtp.mymangomail.com (toronto-edge.smtp.mymangomail.com [209.38.81.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id B8D52180004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 06:47:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=fapLmS1C;
	spf=pass (imf16.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774507650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n7isdfrqjLl4oRkGVkjigFFtWxBai5gXnoimO6gOWXE=;
	b=h4LlX0ckAepI966beYqpwMTOSNsA/sX/Ei5S1GBAeT2rBJ9DDNfRJOKXyyxxpMIZ60A/hq
	i/wj0eGi9/6pmdOxsOBz69HXN0YK9ohE6+BTQdQ/1W7kDl5Nf3UKhscR8nrLyQfbzcCSvh
	ZQJwcmX9wwcthB90a5gNhUj+63zLpDo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=fapLmS1C;
	spf=pass (imf16.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774507650; a=rsa-sha256;
	cv=none;
	b=3kKtYNzeTA/CeRtKcLhlf07ya6esIliK63JtP136TwTvLi5l01X6JYecy8+9eAGm8dYt0p
	HJV4Hnu+u4to3UiIptt5EYLcR+sYcDonz1qZGZkZbdeI8iGrurow4aeqwONkMSF6Vs42Tu
	K/KtN8WXNKLx2fyQ1qfuVMXQ5jZLjbk=
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTP id 6F9455D9C1;
	Thu, 26 Mar 2026 02:47:00 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774507620;
	bh=bAXOMshbJhQGZ5ZyyPvepWgn87EqYBruY6YlzgtvPQ0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=fapLmS1C/M/jQxsPcnjq+DOgpFyxPADZ+rZCkITfFoqsxWN0TdSWfM3XbcelVvhnn
	 QdbWUcRmr/PMwEPr7Px41Pcs0COZQioKBioSXWTPNjJNltU+YAWpfwQS5RLPlKYMCa
	 samGEIWtFzvAtCkXCBkmK0T9jhTsKSyHpBSnIAvo=
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
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTPSA id 6A03D5D9BD;
	Thu, 26 Mar 2026 02:43:55 -0400 (EDT)
MIME-Version: 1.0
Date: Thu, 26 Mar 2026 07:43:54 +0100
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
Message-ID: <414949e275fcecf58cddaf422fed0b1a@gerlicz.space>
X-Sender: oskar@gerlicz.space
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: btsrq4goz41utbzwgqz7nez4kdcc975n
X-Rspamd-Queue-Id: B8D52180004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774507649-821587
X-HE-Meta: U2FsdGVkX1+LXUVBTFARZliLLZM/mpSCZpuaK4WR5fek4VJJLvgwtAU0+pZQ/NDtTqj0fH5HMzCzADCUhocteR0N7mlYnBzKx6VeUMrvh6DIk4TeZrrCyC/iyNg0U1yqP2s1JP5tn4CWkoQoizF+Y2mnZy8i4qlGLXic4BksaU9C1FFWx5WtfvTUlREualDckoljHetCPFsKIaDjE33m2BWRi8w4bomZfQBnRKpltg8x5oq7c4eZhPVseSNN8QzJ/Tix//Z/bTKWJx6tZvV0hSj9Cjeo/Q9j4RzQwAIo5p9O+mU1K5vUsGlxOvxqjX3E1c8V5kJAXnhMp1FQBx1jYC3tgAKlo1/PFytfPif7Qwr81T8OZPFysfKAqw3wNZd2gygzMYzgjafPzGIUYGq/c9jcP1H6pcoVUTvUYXLagriGMzjFVpPayRkjLIsVK6sBTo/jT11g4GzaVuGXSi2E7AoDXYHjWcDd9jctJVU4enZOLXYdJYnUYwV1EET4pnPhdOULMHpawQ5gxYtlsnpQK9C6Nps/MC7CI7LCGHnDZc/uxbVHDzdGVRGd6KTX9a1KDJ5X7foGYnpaC3o9qn6dn5p9/iina6n770mwNOwqvjVsknW6xg1HUE+dLjYCz6U3EUepSLkXJ1egKCjnjbLa5MMqm2wHlYpB83a+tgK7p/NJsqr3N0azIQHYzIyhCZadfbil8cZt7OHHdEUm8cAB7QkF384DVM6koi/iDSaWqq7LSIYc+8eeGSr4g37IAHlfumsGIdqRHwJJAehXINCVTxp/ZJDiFYE+rxzDmhco3pM5GlXSzN6fDGPqgq+tTVJ1uen1K9+j11U+eP2gTD+S3P2qJJFxNiCDZnuPta3OJBHEivwm0D3szX0vd3+kvWZq3SNS8d7APXP/K6HFdNQvFMlA93oZKl4/+X83DHKaW3U2T+hkIdYWT/QGoqDPL0rXDreXeCPPuYtbxt3+7Rc
 Z5QBfKfg
 AcSYBBrzL0FJmRnQ6UM8tx0IgCSXTmXIWazVvt8S8p7xcLD5edXUnlXqGuP+ijcoN3x9z1OXtucbPYy2/GjUC3dQteAr6sX07Ok0zCFXlrAGNEfeLOhLf0tWcTTr7ZJcxJYL0vfK8chk1WduMGO5wCi65Om6vJ051KlXSMBgjhHf1EeCeUn9tVdOIMKBpzcjdb8F3hkJCcVt3LRlD8Ac0ENYvGYjfMmt4Y1/uPoG0Gqzfhyv54OHbDd0M70yukUY6tYAu9QkWv+A3fxNvEheplPtKdCRzZSP6X3uC/vCxHmMuIzF5KQ+8WOKrcGYVhNGgxrVRAB+VaH3NIgKvdubD6o9FUNwI6EukBzHvciTo4F2dvF5/7wG+TLGVWARQhsznB2jpvhn3Fo9k3FiNHIE+CdWJP5UfT/YyiU5/w/k3apPuxG7HG1aizeePkQiaD0Aj87Vg2dd6JPihpTo=
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
minimal. I plan to send an updated version later today. Thanks, Oskar 
Gerlicz-Kowalczuk

