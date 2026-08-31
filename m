Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A227C624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FAC6B0092; Mon, 31 Aug 2026 12:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 027576B0095; Mon, 31 Aug 2026 12:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E80F56B0096; Mon, 31 Aug 2026 12:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C1C116B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:22:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 502EC1A01A2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:22:01 +0000 (UTC)
X-FDA: 85162081242.16.3B6938F
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 760224000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:21:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CxByr3Ah;
	spf=pass (imf27.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788193319;
	b=DNKqwTEy7j47ZZzzzVxB40lQa2T1X2zI+JPxPTcbBVW1Pu1rnepJOQK7Z91GS00tJAUm+o
	HJGxYMZwccpJubM/KDqw407rNVKvf/CH1PwNFd5mo4CPwoycYwIcln9KKDxwaq8a1OVPXW
	nVOpwnVLs2QLKpwT3BWiu6gAjvpQ+EM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CxByr3Ah;
	spf=pass (imf27.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788193319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
	b=1DxQu3ffKrgXXJJLJ2VrE7ofG6BWW00u8utdKai8pV9SshylLAASc0XBC8djuZ94Jlblrc
	odEn0OKzPfaU3t2c9fKaIjVbCnpGi36TBkTtGvbkCIMCe2qY0xxZxWDKktTPmcKMaMN6UF
	6yjMPzsfczgYGZo3jff9m4+7kK7Zyxg=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38759bcd877so3584542a91.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788193318; x=1788798118; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
        b=CxByr3AhqZ9YtfgveEXMQHWjI1AoDQl2EEbcmYe6SdBLbMfAH+UJiYL/rr1JX5YZg4
         gT1X3Qs75lE11GQqvTFk8YUyo+lh2O+eFuzvZjCty0tn3N8S/70/usEKrXwXwx2RKUJV
         RXXAwnIBO2MOaAPIXKE53qtY+szqai+/mi4gJT80dgfPcSZSRXBVrN6ZX9YNgaOSfiw8
         PbBOtnvkdAR31+Evw6GES2KE0HBKIbu5wYvoabJq08Ye2noJZlBGsJdNqZgpoWSyICOJ
         opudthGubAqXpoODXGTQKA0W9tNnZPEs+aCVMDhvb1of9l0LdT93ihfWWpZJz9FYEP2z
         lIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788193318; x=1788798118;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4wASPUEGd3KOv6Fdubi246q8cZj4P8D3ytyUATn9DWg=;
        b=e5QeuBRdXBBWWLKup+HU5N1RnpF0WrGo9zrS4tWFNF8MiNuyOFHg8FE6Rvq9rwM0dy
         2b3kk9KTxXMB48XnRxTjLuqkSWpvV8u3G+ViizT1PPsaHlbo9XkHkyqkd7h8dflu0hAq
         s6kI6k+nKNhk5SFb8Gzgtw2B9/x68M6z/3yVHoRRl9pUE8bHeLy/yQQmjlE96mCdj6T0
         dWQQ+dak/5KL6iTM164xXeAS95yp77vY4pDQPJkJ4BYvyt4eGxDcAviGPxxcIuPQ8sZs
         oGQYp1ZnuRxfF4187nVaaSZWc0pHynSKQygzDmwn0L+8VwPCvaFCIbaBszv22ZoYoYeY
         Vfsw==
X-Forwarded-Encrypted: i=1; AKwUvBwENzpRhj8RGdKX3r1Ktc1n5J5n/jffVSmJI74AmgJuN5oSO7RTKMBtQDSLNVlMk+oF5aKFyLbBYQ==@kvack.org
X-Gm-Message-State: AFuF++k1h3slFwDLfFetxLgcqmri+oroyWKYJzFMUqP+YjjLaCY4YNRM
	7W1oqxaGcgi+ArWwqWt4CXTzOROjr8nfMTrmv9/O5Hibq1Uny95YT33q
X-Gm-Gg: AYBFou139YnLNkH//42E/4sdMiWQ1HGtGn0o8BigTmbnjhd1zWp6kCHZ/YVIvKWK30A
	eca5rezwh7GNqwj11BTaNNnzKGULJEFJ6G9sFEjYsjloLUkGEITwXbs/oZsHxzNLF7wY3pHwhwQ
	62HhZ9BCzHegplnwjCeIX9t4if/amhD9MoOwKv5wUqWPfLjX2lP26Ka9NU8V9H86ixrlHpOMAcJ
	/jSrzC02VhSgonnlmEJFoBTnHGgja+cmMZRzal0z2IgGiRa+mMALMbuuVFmOUS7IPHjQ+w7mzKY
	/qZGbHWVWy5w0ogVRyAiu9FJcyLN2vZEsmYB2PfuOOAnMDJ//VoIr7mgj/WbrM4npEySa+nT3IN
	9r0K3XFD0hqZbjyDEUjQvvBxrPdxrQPMCXYDvleIHjQED6tHCyK/TuS7D+hHADtfkYdXXFL2/5m
	Mn1gSNb+N9RvXRZ6dNv2cgEh1n3mWb17i+0EPFCE6kNXoTU7VQffwkD1lKs69GfSwLtNo/ifXEo
	z2xXZ29gxKg/4C9UTU=
X-Received: by 2002:a17:90b:50c6:b0:38e:97f0:aa4b with SMTP id 98e67ed59e1d1-396d1017316mr43646750a91.13.1788193318003;
        Mon, 31 Aug 2026 09:21:58 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:21dc:72d0:a033:17f7:ad44:4f35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3990bd1b395sm308743a91.1.2026.08.31.09.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 09:21:56 -0700 (PDT)
From: ThangNN99 <ngocthang2710.1999@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	ThangNN99 <ngocthang2710.1999@gmail.com>
Subject: Re: [PATCH] mm/slab: don't use kfree_rcu_sheaf() on PREEMPT_RT again
Date: Mon, 31 Aug 2026 23:21:49 +0700
Message-ID: <20260831162149.8035-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
References: <20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 760224000A
X-Stat-Signature: owkp7ufb9tnrpdt76hj7zttjtkktu54d
X-HE-Tag: 1788193319-4900
X-HE-Meta: U2FsdGVkX1/K4LOfEbsQLOtnwGTVmiNyohbigkswCmgpheGr7gayN6v/ZefynntCWHqxLCLQzzzZWoaaUqidfzwGFV3lxKySeoRvGQ6utHjdn/8uVe1cFg07PxScDOwP+qzN3yBR83zRJMqz+EcWJzWXf4wxPOugN1fsYpxlarZFZr/5t90//SDCkOT5Z2+w8CkuhB0vaCO4yN1D3u5K561Uf4VuFtIbaYHXUv7YuZ2jRqtitFtOqTgCqdsSq3VMT0fdDVs0AQRuUotlF741n75bDnc3AqMETFrJfWnqUV1I3o9cPHaCApklsqV2JoQsSj9wswbKsE8ZWCGHYUKghS4kPweWlkWwPLB0+nUG07oqm1SVncuFEhwIIkvcBffDDHsXhZ/rs3rg1MGpcRi2pbYizN9p8h59CHvxIXUslSNQGlH45BnCzJNNOzGtolbGCNO4fP7pZ4Rc1qcJEe88TXZHL2Etp5ym/xDijTK7NuRXKh9PLKVAX8UXZR1xKw1TpiG8jvGuZN+OlDwFHlA53bsQ1STKh4fPn1ez5YJxJI2Jn2fqiqqyFTeohFGig2ueDC1Z3BqPOqfdf+NgqH5Cqf1iqwe6WYQr3DkM3FOcmkGKwlA+SrEQ5twhwftjXVaY2uxWUHGlJBZJiCvkB/I8HvMQA6wUvESak7o9Vu0nVV4rQOvfnOkJQ7ug5cTP5jp751E9oXxMlZCNa3SFkH3utVdUx0axmkdzCWWVP1pu3birvZDrtD09U8s14u3EojrvOrQ+DhJNQZddxOieTcD+Gh2xWH4h93fUS0a1OsZHiRe+eRgVcqQD/lFsDyzzbgRSIFBqMAQKTMwIbZi2nDYbBvzmsS5730AF7HLZjOVguhfaH3Fm8CEwkqD3E5dUvWN7Wm49Sly03FkY9Hm89fIxtH//EJHLH54NcLxtNMQpwjW77vFWp3f5gnOqnErDT5oIOl6KPuWy6p3P2JXlfKY
 fDtDpe5L
 99Z7l4bkxFAR2tLY18k5Kdgm/c3LCF3/cLuQVi5UucopdkMujH8vAo0Rcj8UUp7Vt6uU4zAJgx+NiISSQLdE2lm7buyUeW5ToOvKeyCtS+GFD8aHmM4aIGj9t040gPtqXawr2kFtPXkeMknWzei2MccQCOAI3y6vR7aBvWi2heYYkXEvSqpU2L2EfsQEBscAE7NBOUJ2FODL99PDXUDPaM3uHe8fYtUUBWOFQHc3KVBBWqoMDH/dyCALanq14uIWUASzzwKtLv2XwoQ+SUyQHmVWVsrTB9j5sU9Z90kxAjK8kqbqgOj0rR3Nxyb80CXHWDaP/d4P/dC4oJST4OJtrDguAxwGtqmL9HO0VGMftVTF174Hlv7YKNsYdBXqPoBSR7z9zzE5nVATJLgr1ecTbcs69HSow4JETS5dyUo0hX8kwsptVqsz2yTORPj5l//CpNoIZJUF02o3VUnOkMqR/y7SMbPMihwxTbGr8QugSugbehdZCc06ugRU+kOrlWv+g009ziUB6BkKjVZOexVeAb5x6l2C4/ssunM0VNUg8fBWn5eQFSi/xjLoe5KA22fZRcSD5CZj7pzqZZas=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks Vlastimil, this matches what I found and is functionally the
same fix I had in my v3. I built this exact logic (skip
kfree_rcu_sheaf() under CONFIG_PREEMPT_RT in kvfree_call_rcu(), same
dead-code removal in kfree_rcu_sheaf()) against commit 08dbfad3f504
with the syzbot .config and reproduced the original splat with
syzbot's C repro (writing "off" to
/sys/devices/system/cpu/smt/control to trigger the
__balance_push_cpu_stop -> select_fallback_rq ->
cpuset_cpus_allowed_fallback -> set_cpus_allowed_force ->
kvfree_call_rcu chain) — confirmed the exact same lockdep report as
syzbot, then rebuilt with the fix and confirmed the splat no longer
appears while the same code path still executes.

Feel free to add:

Tested-by: ThangNN99 <ngocthang2710.1999@gmail.com>

Thanks for picking this up and for the pi_lock/waitlock explanation,
that's a much more precise description than what I had.

ThangNN99

