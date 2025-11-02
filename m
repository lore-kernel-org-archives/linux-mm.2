Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2764FCCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 20:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15478E0005; Sun,  2 Nov 2025 15:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DED4B8E0002; Sun,  2 Nov 2025 15:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D03148E0005; Sun,  2 Nov 2025 15:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C173A8E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 15:54:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6F384BBF00
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:54:39 +0000 (UTC)
X-FDA: 84066870678.02.E5E1D22
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6BC044000F
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 20:54:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FAL7bBL+;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762116877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSoLTMn7D7wRI+KcjGWMGJNZbmIDanYc/C6CsZGY6C4=;
	b=reYZff+pdM/F6Zve8LSeiZozHttH7Z5sXF6CkudzXyjtQ3jDQxCRRdpE3T8C2fHhtYs1Rr
	i7RiAWKKEPTqMLQ6vl51SVDggKtEnQ61hJ+ss+0mNPJotPsgM1A/FqqtIH9RM6V+QnF+3j
	+vr0mJGjjcKLiu0rbjj3FStKhVz0a10=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FAL7bBL+;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762116877; a=rsa-sha256;
	cv=none;
	b=ozroIIyie/PZLA+Cjmsft1gdejhtKbLuTGo3T/Nr9i4HQ+8yf15Ui0/F7TcJUdnI0z0nbN
	NAtJbcfVxOfzwlylP8RYkkU+ULJ0HahIYDWYfFsSoUh/x+EoR5IfCSX6wcQwEVaKy8Tcf2
	9fU6iJCTB9A6wE9EOFbYLO7oysGfhcE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762116875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vSoLTMn7D7wRI+KcjGWMGJNZbmIDanYc/C6CsZGY6C4=;
	b=FAL7bBL+C4exDYR5oCnLVtwAWj+9G1H9ZgsdMgNY1fT9EkYaCt1Oyygsfg30HqDWIOTChr
	Drhu3O+o/jfQzjrcQwvyWMuxQ1W4mQNaTYonOereiy54CtofgwkshbhVvMobBUBKFZ4/6d
	EroT4lTO5LUCSggGDgSv6KlmZ+MNLtg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrii
 Nakryiko <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  Martin KaFai Lau <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,
  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 00/23] mm: BPF OOM
In-Reply-To: <aQSB-BgjKmSkrSO7@tiehlicka> (Michal Hocko's message of "Fri, 31
	Oct 2025 10:31:36 +0100")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<aQSB-BgjKmSkrSO7@tiehlicka>
Date: Sun, 02 Nov 2025 12:53:53 -0800
Message-ID: <87ldkonoke.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6BC044000F
X-Stat-Signature: bj8qn4dkn9c3jhq3ti56d5rpn6jeumaa
X-Rspam-User: 
X-HE-Tag: 1762116877-26051
X-HE-Meta: U2FsdGVkX18BXj8VPECWaa7IMbmGFhK6LedGiwy2uGN/HVRuz9sascyr3V5+ec/d4WEJwcIX2zxzzxvK5jEjSrPflyUWyTEJUNW3s6fcaM0waWe4TyPf5MoaQupLmyXvq/HguZUDj5qkiatGLuX3QHqJeSDT7n0v0mgzbbCmz25Kd2vr9mIhw/kehZZEHysRhqc0MpMYC1iVUxU+/qTH0r5uyBGY4Or7fR288hD09R8SIDjnCjApBOUwAdTpKv+N+3LVIU03li1VgF2nB0eW0s6Kb5HqueBN2oF09HufH9UFsH8r/mpV9SE+o+jvBn0gve1uzuaerZMGU85lguM9zSIV2+0hUWGmMdYGeCPoTMYyIkLToHR5IdQbYgQtivXz9vDpG6gF453c3LAlI7RUyLMRrhqMMj96UTn3xi7CgVOS8ILa1SY1Uf3lgxjrd9a0FX78R4k2ET1Qh2FvcGvpX9bbXH3zhyh12A+PD6FFKVJVy5PDZQ23noc3UNOjN83A+7gyfvDF41GpkW4BV/+ziWJHP1mxiSK9MbLdZpdGR5MnTTTjyu/PnupX6pOTAsO7k2XKJ/e8U1OkuWghLybz7W6/kYP0YuH3EuEYz9AsJNLM7/Ju91hw1x6p24Y+148LjUqh2Ud2tAiLJM68l/77ZHiYTziVaFsU4XLZEMivRgfFB39gZfB+KPG90V48L8dtnp1DqaCnq8j0oScoiD+wB34QIhhBCjj+slwhVIfEApXWcoLt5t/XEdnBjzB5jfkmMTMnsluI5HYTrF0HIhxepMkHk6q4PUrZqpBHuzrpzvuV8+96EsgT823XKgI4pIxWyilpUhYbZfdmnJ2lDRQ7rvnjB7wmoIDjTRr9eEmIYwxo5QFVjKXneY5q/2001sxpN7Bdd7fXeZOCh2zF9J6bqSSHxTnh/8g4q9v1uHY8EhQpv4YKJyxblzQPUbaWEJHT87tLppX39v/RJ3gKLFb
 RbFYiuNZ
 taq7oYICO1KbOYksxPT41g1E71IvmPu3r6qIN21mK/FwAkHCMSnX+ijBVPwWTq3drJBBpdZ1AnU+a410/eqdiOmVlPj+xBMaHOsU548kOH2zI8kSNrGehMg6axFEAJIZr2j06RioC/VT5u/6l3mAzWLI96G9Jc5fVbgOX5Y8t+NZGIyOh+oGDkiBEHzHwvf3mw708b5jNgJciTylAiH/lLq5dJlpoOTDq2Xr80lbhxT3f8S6UqkaZ518hqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 27-10-25 16:17:03, Roman Gushchin wrote:
>> The second part is related to the fundamental question on when to
>> declare the OOM event. It's a trade-off between the risk of
>> unnecessary OOM kills and associated work losses and the risk of
>> infinite trashing and effective soft lockups.  In the last few years
>> several PSI-based userspace solutions were developed (e.g. OOMd [3] or
>> systemd-OOMd [4]). The common idea was to use userspace daemons to
>> implement custom OOM logic as well as rely on PSI monitoring to avoid
>> stalls. In this scenario the userspace daemon was supposed to handle
>> the majority of OOMs, while the in-kernel OOM killer worked as the
>> last resort measure to guarantee that the system would never deadlock
>> on the memory. But this approach creates additional infrastructure
>> churn: userspace OOM daemon is a separate entity which needs to be
>> deployed, updated, monitored. A completely different pipeline needs to
>> be built to monitor both types of OOM events and collect associated
>> logs. A userspace daemon is more restricted in terms on what data is
>> available to it. Implementing a daemon which can work reliably under a
>> heavy memory pressure in the system is also tricky.
>
> I do not see this part addressed in the series. Am I just missing
> something or this will follow up once the initial (plugging to the
> existing OOM handling) is merged?

Did you receive patches 11-23?
git send-email failed on patch 10, so I had to send the second part separately.
It seems like the second part did at least to some recipients, as I got
feedback to some patches from that part.

In any case, you can find the whole series here:
https://github.com/rgushchin/linux/tree/bpfoom.2

And thank you for reviewing the series!

