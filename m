Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49B84CCA471
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 02:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 325038E0003; Fri,  3 Oct 2025 22:00:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D5EF8E0002; Fri,  3 Oct 2025 22:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EB4D8E0003; Fri,  3 Oct 2025 22:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0476E8E0002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 22:00:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C046453FE
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:00:50 +0000 (UTC)
X-FDA: 83958778260.23.7B033A6
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 413CD120002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 02:00:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xw4hpKXq;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759543248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrJAE+yo+55T40YTks85z53PnQfp5DevLHkYvHmgTnQ=;
	b=VJHGvbEb9qmfSQNAI3RgMJdgN+au+0ypFRqBhKAUtiKIUI9qWWeY0Efazlpoqf4DOghVUH
	tjBNojjDTrtwLHW5athXSc8XhU00fPVHp4bNJ2qwffr96SScW8j3gC26smY3cLNI5Cyoz9
	haa5FmOlLdJEW1ERBc6WCZnl3kRcnoI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xw4hpKXq;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759543248; a=rsa-sha256;
	cv=none;
	b=bJ9iaj3IkvovMw64bDFpVGf3RpCgUSC7s2iOqKQgnopM4CIdXcBDXJDNcUWf3ESlz+bK7j
	G1774TTz5datWPcs7Q8x/3r5T7Tb9Yea++NotUGJKAKhQ5CcCW+32yszZb9wuyOUNvh8Pm
	9lvbZk7iKDT8R134E2+Nu27zuUw3fTw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759543246;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jrJAE+yo+55T40YTks85z53PnQfp5DevLHkYvHmgTnQ=;
	b=Xw4hpKXqFzlpYALq1quqLQ0CrgqfXLsoU+klxVxSFx/6BeI0RA/lStu0wl6FV1/Cac66YU
	Z+tDA84oMUHOtigtgnpGL/AZK9FnTEflgh80gTwvNeYCAhyQ4P6Rm5sduIEaax3qyekls8
	37UbTTk9UN02+a8ofiCmGlIuwdVJMUM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,  Kumar Kartikeya
 Dwivedi <memxor@gmail.com>,  linux-mm <linux-mm@kvack.org>,  bpf
 <bpf@vger.kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,  David
 Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 01/14] mm: introduce bpf struct ops for OOM handling
In-Reply-To: <a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev> (Martin KaFai
	Lau's message of "Tue, 2 Sep 2025 15:30:04 -0700")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-2-roman.gushchin@linux.dev>
	<CAP01T76AUkN_v425s5DjCyOg_xxFGQ=P1jGBDv6XkbL5wwetHA@mail.gmail.com>
	<87ms7tldwo.fsf@linux.dev>
	<1f2711b1-d809-4063-804b-7b2a3c8d933e@linux.dev>
	<87wm6rwd4d.fsf@linux.dev>
	<ef890e96-5c2a-4023-bcb2-7ffd799155be@linux.dev>
	<CAADnVQ+LGbXXHHTbBB9b-RjAXO4B6=3Z=G0=7ToZVuH61OONWA@mail.gmail.com>
	<87iki0n4lm.fsf@linux.dev>
	<a76ad1e9-07d5-4ba1-83e4-22fe36a32df0@linux.dev>
Date: Fri, 03 Oct 2025 19:00:38 -0700
Message-ID: <877bxb77eh.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 413CD120002
X-Stat-Signature: sy4d6wrh7zas5mdssbc5xiwjdh6oskdk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759543248-181495
X-HE-Meta: U2FsdGVkX1+irrpUDewCl0FycwTb7YddUYkx62TLgqED7wDSYHmA8dISjUSbt0z2AJXk2pRrDL437XLkAaQGuXmkN2Rw4ZeAVTLAjHtfTpcf6SGuSk5lTqZymvubMFRQRosvDWPtyTlBNReMywjUM9Gs7MQgvNDDezSjDv1kfRLVUxk+zImKTo1BYOeP8G1KdL24InWs/4lb1FgemXepaTQPYCK/8yHZd5KYARFnhuHcScVbq6O+JkxvELitRP/TO2SuT88BB8eJgn4NEGrOX7m+rrKqWxkI+ZxshpkDfaQBYeN92aJv26bi0DbT5mzkA1gjAktF0AgVH+jE+ULy8WC8W8zJyj5AIZ72r8YiBTFNPEKvViVbTJdAptb72Rt5sz3Wzr06gxJo7qS0wDNbrreTc48l4wNyTUwpD+a58Cu8Xs5LJNCyaL7pb/03LOtHlhH2LyX4r+ElfH1vgUhB2k3I6shgcLyoURRINRu0muEccu6CVOg9XFwll8BDrbEvYO2kRIuhD4WL4WLB6wG511NJX9p4MpMGoAfjzOXrtCfWSx4YkvnlQyQfdPStpxhUXoIB3BNOCU/oa4Hi1Ii+t1OAk7swoOejV7RS2yURsdG3ZXm/DpqDStQm7yabQ+fMt3znf6wrcmItSdEC9+08Pnew2jB96q2rvYti1lvaQU0fR7RTp6Tp9WT8fSiPVaebvepMGYttAUFsFNrYmQ8PGWY0oGQ/wSc0ajCGCbSp6jFpaxt1tudRGy+LNQx2h/i2hZt28TzqM/C6NLaByYeOlfpkkEYNwvnnn2VTlMOcBJWBbP/9F3Rm3eEfLo5liahK230YFW940xpvOesaAhvWIq4E9ZT8MasffkTKfOpjU1NnP4DPVa5A+HD4FCgkNSltHwTvRqhNs4JLWvOUhGPzrxgqbz6VHVRmwmPozYyEnk7q6PewU6QIiLlCsJtbEmEQU/sZlpMfLLqFalutPzb
 VANDXE3q
 TukpKkwDO+qbUNwj/lLMl+fR4bWUErIt79aQB1nHcUveaCcaVZQ8xjNNzILj6DsetHBAmnLzehczmnSICjL4hkc5gfHbLpaCSR9qACp7F9OnsNTiiKA/CF1k0cmPoIQaaRyiznD6ADkn/1cnNT+RnYz5MVWcQujm4itjR0wZM2ezX/OrJ8cUoN43ogpzCnhSOFqRk8086KfHSPNagqPTsWnt8ibSsIjsbEISA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Martin KaFai Lau <martin.lau@linux.dev> writes:

> On 9/2/25 10:31 AM, Roman Gushchin wrote:
>> Btw, what's the right way to attach struct ops to a cgroup, if there is
>> one? Add a cgroup_id field to the struct and use it in the .reg()
>
> Adding a cgroup id/fd field to the struct bpf_oom_ops will be hard to
> attach the same bpf_oom_ops to multiple cgroups.
>
>> callback? Or there is something better?
>
> There is a link_create.target_fd in the "union bpf_attr". The
> cgroup_bpf_link_attach() is using it as cgroup fd. May be it can be
> used here also. This will limit it to link attach only. Meaning the
> SEC(".struct_ops.link") is supported but not the older
> SEC(".struct_ops"). I think this should be fine.

I thought a bit more about it (sorry for the delay):
if we want to be able to attach a single struct ops to multiple cgroups
(and potentially other objects, e.g. sockets), we can't really
use the existing struct ops's bpf_link.

So I guess we need to add a new .attach() function beside .reg()
which will take the existing link and struct bpf_attr as arguments and
return a new bpf_link. And in libbpf we need a corresponding new
bpf_link__attach_cgroup().

Does it sound right?

