Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB155EFD210
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 09:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8EE6B00D1; Wed, 25 Feb 2026 04:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286906B00D2; Wed, 25 Feb 2026 04:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15EE86B00D6; Wed, 25 Feb 2026 04:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 011A16B00D1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 04:06:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A14341A04F4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:06:54 +0000 (UTC)
X-FDA: 84482399148.11.3AF39D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id BAE91180004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:06:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PvUihXvx;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772010412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RliNJDMPHzMaCR4/F0Oj9BKYQtfjCgzIq+mkuXnfmjk=;
	b=8dUzyeBETl/H8dcaQdhbNle86SJh4K/MlTy3ivwOBrIk4Agm/2SE+3yfldqzFNMoQfjqsa
	3S8UNK/noxGvm9of/3s6dX8VoatFBneiYzfVCP3Hhv4VbzkyoY4q8825TINtPY06fK+3SV
	3hgnUAzZBgqD/21so4Kj0p4MixQtFeQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PvUihXvx;
	spf=pass (imf24.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772010412; a=rsa-sha256;
	cv=none;
	b=BjxDnMI2dvfudjkBK3GaN+pJ/sTPsmrW6yCIZu+W+ojwqCoYR40Fw9AhCL5WrCuVdSHtiU
	kn2uMqDNATksVfPCuGszVo+2jzSq+FTxKl8c6VuhipI3V4Teq9xvTLkiEWld7FZsBUK071
	zYsWUugq+b3MWxmCn9BmfckarwpgbfY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772010411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RliNJDMPHzMaCR4/F0Oj9BKYQtfjCgzIq+mkuXnfmjk=;
	b=PvUihXvxMngPOlexf2Q1r4sPkcWTa3Od6zfjgG1LGOtEH6D8INaePdKGFuXzRGaNOiX2zR
	h43vAHFsEW304ri6CSh3XPD7OZ7Lt4QjUFT900ZfXDYLlzgmiFTaxv1HzZkWHQrAZHoEQT
	0I8JoxP1D09Q8AOEueIFmQr0dXQ7wxA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-130-6nbU5-zRMO2AiVEw27LReQ-1; Wed,
 25 Feb 2026 04:06:47 -0500
X-MC-Unique: 6nbU5-zRMO2AiVEw27LReQ-1
X-Mimecast-MFC-AGG-ID: 6nbU5-zRMO2AiVEw27LReQ_1772010405
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7ACCB1956068;
	Wed, 25 Feb 2026 09:06:44 +0000 (UTC)
Received: from fedora (unknown [10.44.32.38])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id B05BB1800352;
	Wed, 25 Feb 2026 09:06:37 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 25 Feb 2026 10:06:44 +0100 (CET)
Date: Wed, 25 Feb 2026 10:06:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrei Vagin <avagin@gmail.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Christian Brauner <brauner@kernel.org>,
	Shuah Khan <shuah@kernel.org>, Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Jan Kara <jack@suse.cz>, Aleksa Sarai <cyphar@cyphar.com>,
	Andrei Vagin <avagin@google.com>, Kirill Tkhai <tkhai@ya.ru>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Adrian Reber <areber@redhat.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 2/4] pid: check init is created first after idr alloc
Message-ID: <aZ67mwBEbRtdaWp2@redhat.com>
References: <20260224164852.306583-1-ptikhomirov@virtuozzo.com>
 <20260224164852.306583-3-ptikhomirov@virtuozzo.com>
 <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CANaxB-znXjfh5s9ro127TGONsu6PieuaJ1vB3PMVFeV4Eo8pkQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Qgf0tV2lO8c8aHxNGhYAuEzDMvTbDIz-HnBHZvM8K_g_1772010405
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: BAE91180004
X-Stat-Signature: 8m8u8yohbipkgn75k6r4eycwa3pfb8ak
X-HE-Tag: 1772010411-291824
X-HE-Meta: U2FsdGVkX184SqzSQcFicyl+X3LFDaH/pHA1YBc771LM094lQtBzWfJux4SfOaofB7N071znPdqx/iebuvVrNt+wSe46IHRFV75zXphphHVRSf1FSv2EM00CqaUs3IwfbdgO6be/XH67quOPTWForWWVklxo7+fdgwyLN76ZB33rJcszSZR76jgfGO3pZ7PQ7kS2Rvz1fbrN9EOdsBhMDyqV10W6o1Q9vBXLMF2/rrAvg2WpfNP1NWB8D0J0sf3evTTdz/Sr1nY22jjKVGiuUZWTSqmKEwehzRQ4DUuHc8aHPFhGMz3b0ZFtmCUD3utBaRedvDuDzyD2mgGYIzXfKMwZ7FGEPXefdlHuw31wqyzFA5oSmQdmoUngghKKcTMbfU2SU7lFTNdYTpcihD/M6g7FiLiyCsRD9QWrkDlubZA2YqcxGnCNkyLiEfKSK0ssgEg4Czi5s8EX9QY307Y1sIXh0xw1CQbhRIyu5hy9UUjfWTqRAqqmEbbYjqBvebKMjUhzZMUuiNXKZpfUy/x4s6he9ZfK+4P4u+N0ee1g098xB5/aQo8R6r4QFybRbpyJg7TWM1xbTFzJusgdkMGrvCL+EYoRYYt/FCJ6/vOzQtRQEFmd3HyWMr9G/oHnK4J81omD97f2C91kJaJxi6D1qNaHd1QL+YV0gF0FEqRqDyqncNjC4VVOdOBj+bGKa49KB6jnm09/VyjZwUmVFkxOpSrUW1uHi4JlrDGAPjtvsz3IcyiZGd4rn87tYjIurVRxLi5byrcpLpph+xjsnrzdpJS6tPjsLtEC67Gk9R+DPXw3DBte3Ff2C+U/vOuh5HoB7yzPLESVe2IG+SohF3/Z/leFHaezHBlmgspTK/1AGR6OkRLlSwA3uGUbMwNHTBO6xvsJBhRJVcAoZkSG6m0C+LM2Sc8F3vEcOEFxEfQCEUBi3c0O91l0GQjCk0OM6hYp87RnvGSi/ih6lA9dWXs
 lcNxlw1o
 Mwu6c5gmpfQphyNlnsRxrqNLXnE8Vk2DzmvVIe2lOv0uc6U2T6svxMTMPaNAWEJNaN137qlitsq9SvJDvesDVLt+SJw6OTJkbnwdduzvkM3/SEVP2voe5dbYrGysVQ0JzlodBSq8QjhQpM8msVN3geyvk4o8oGDmIR6JC8xaxv8qhYRT/gSjAHDDoKFAidbi5t/OS3pfSoBSkgjSEhGx9G3qQY3d1aQVWhqX+yVJwhbiU9LFj5GuxgJr9uTVU+cXvXTtl+wPcyGgRWVS4bjEsJTh5My+C1R6eC+s46t+Ut5SrGrEO+PgNVRcAg96eCFMTzcf1vkotAq0iyrymiExYR7hdApzov5ViSTWDHmQRSPIun7mOSXbBsNakBo+zTcxKOO5fuEwz/avr680mfxsa1C5wBctp1cUh8hGeKR6n4K/VA4uFjEuKq9/k2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/24, Andrei Vagin wrote:
>
> On Tue, Feb 24, 2026 at 9:02 AM Pavel Tikhomirov
> <ptikhomirov@virtuozzo.com> wrote:
> >
> > This moves the condition (tid != 1 && !tmp->child_reaper) to after idr
> > alloc, so it not only covers that first process in pid namespace has pid
> > 1 in case of clone3(set_tid) requesting wrong pid, but also if idr
> > itself gives wrong pid for some reason.
> >
> > This could've been the case before this patch, when creating first
> > process the alloc_pid()->pidfs_add_pid() code path fails, so that the
> > idr->idr_next is non zero anymore and next process calling to
> > alloc_pid(), will get 2 as a pid from idr_alloc_cyclic(). Effectively
> > leading to init-less pid namespace, which is a bug.
>
> I don't think this is an issue right now, as we only allow one attempt
> to create the init. If that first attempt fails, free_pid will disable
> further PID allocations in the target namespace.

Thanks, you are right!

> This isn't directly related to this patch, but why do we check
> "ns->pid_allocated & PIDNS_ADDING" after allocating all pids?  Wouldn't
> it be more reasonable to do that right after taking the pidmap_lock?

Perhaps, but alloc_pid() can drop pidmap_lock and retry, so we will
need to re-check PIDNS_ADDING.

Oleg.


