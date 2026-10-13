Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FBCBCA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 03:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26DB76B009D; Mon, 12 Oct 2026 23:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245586B009E; Mon, 12 Oct 2026 23:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B8F6B009F; Mon, 12 Oct 2026 23:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EACB86B009D
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 23:14:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5BADEA0B4E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:14:12 +0000 (UTC)
X-FDA: 85316134344.14.179F7D7
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7E8EC40007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 03:14:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fjitPJwM;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791861250;
	b=2/krY0rBiXE7viSivDl70IVGo1ti1td3QEz4BKToJKoGeozOWR0QQlJvQLWatQgVmRcMD2
	C3ZTkTJuSyP3SxEwlfpsuXOE/oRGpBzHZehjGDgHE0hitRQbeIURJcvyOrxyaoKKNLHfPT
	8LAQAfrQLOkYSuvbcyd2IL29/ODfQQk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=fjitPJwM;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791861250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22LjuzCketjlkzgPm8qMqIEkXwfSP3UnBaL4SB50h+A=;
	b=EdXS8gIl0WEqLFr4JahCQ7EObc0T/1ynszJ9x6EEtmkfKbP78RXgXCmRu4KP4da/RQKxWb
	XSG0QjcL/qf7eItffgTAPuilHIOaFTRyKc9IGl5xUJ+rnttshhCy7DFhmvd8Y6NsVZlsqW
	lOrBZ3a5HHHnstM7QAQDnzjiWmwcM9M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791861243; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=22LjuzCketjlkzgPm8qMqIEkXwfSP3UnBaL4SB50h+A=;
 b=fjitPJwMGer1CFveE8wAMhQdtPxqz/bPkZL/xLGwoOLVN37NdPJcwR9D7X+e1Reyy32Q64
 2tbrAcFTULrWKrcl41V9uFua51pLxXgxoYAxpovVWYBUt/OQ0EobOnsV+5FIkP8a1YbbPC
 tcMnqWJn61XtUjcf0Qd6pXW+eHQxT8Abl6JSIq8vt2CVxF5156Pk7E9+ONSxn/+0Z475GY
 PLjWEW3wS5+jUP+cZ1BWY4UjYxKf7zIepHKWVsbSxScgqS6kWKNXOaCw1e30AJlOh5erg/
 THknBh9GFjelc5K0KK+DdApXuLhgUtEd5e5YPlRBt/qBoX5IF6EA3D0vqwcYxQ==
X-Mailer: git-send-email 2.45.2
To: <mkoutny@suse.com>
Cc: <Liam.Howlett@oracle.com>, <akpm@linux-foundation.org>, 
	<aubrey.li@intel.com>, <bsegall@google.com>, <corbet@lwn.net>, 
	<daniel.m.jordan@oracle.com>, <jannh@google.com>, 
	<juri.lelli@redhat.com>, <libo.chen@oracle.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>, <mgorman@suse.de>, 
	<mingo@redhat.com>, <pauld@redhat.com>, <peterz@infradead.org>, 
	<pfalcato@suse.de>, <shakeel.butt@linux.dev>, <tim.c.chen@intel.com>, 
	<tj@kernel.org>, <vbabka@suse.cz>, <vschneid@redhat.com>, 
	<ying.huang@linux.alibaba.com>, <yu.c.chen@intel.com>
X-Lms-Return-Path: <lba+26acda1f9+250790+kvack.org+lizhe.67@bytedance.com>
Message-Id: <20261013031333.10208-1-lizhe.67@bytedance.com>
References: <ldyynnd3ngxnu3bie7ezuavewshgfepro5kjids6cuxy4imzy5@nt5id7nj5kt7>
In-Reply-To: <ldyynnd3ngxnu3bie7ezuavewshgfepro5kjids6cuxy4imzy5@nt5id7nj5kt7>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [PATCH v2] sched/numa: Introduce per cgroup numa balance control
Date: Tue, 13 Oct 2026 11:13:33 +0800
Mime-Version: 1.0
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7E8EC40007
X-Rspam-User: 
X-Stat-Signature: 91r8ryapbyys7mifep3ax4nscga1r314
X-HE-Tag: 1791861248-794520
X-HE-Meta: U2FsdGVkX1/9P97Y/1Q6R0My7qFH7W0k534DfScwzDxNbDwFM8u7vLDYfDPMa0F+Hvv7j4+IEL7FUPYfqzGSQIPzPfFIFRQgEZtV1kaHyJgXWrrRjxprkNtlD4BE7PNXbzmGp7oTFJMexRV2s2+4QgljKCwdaHc46VnH4z+qAkdwEO8c7z0YCWrrd+ZrVjXaFw8V5P6GftfBEwLdrYjnX2uv3wkE68vZbo0U4htv3ONfzHp2eeHeBaPiecks2VxZodsj1FkACbBPrej+SuFV88T7nmSulDZvuEn1TIM6BqJBG8xqXUs+u+Corc4OgFnFzj/oAsmjkZHIoCH2HkpBaKV6V+Cq50w4+o7ajP3DFDqgGIzfKEo3r0nXNZS07bIxDB8cv5AMc5wm4oBSkZ7PU10vIsjD/6h8YpKWaBgVsKeM2LyEBKHDv7oUqGtR+WKMPLWnMyj1KNIyG/q4iyQ+/eJjtsjgzUj+csraSUx61fZug7RHmlVtOtIIOy5r3MNt0d9km2G9daVcgorFUxWoMP+tPeYDNWPepPJ5l1oICdS4NeNONTX8avqRPNpv/7mha1QRX1YdK8Dh4mgRZrK0Iu+WhleggDgkGPbfJYGD/PVTMwxN6reY78P17oLOMHcDybMWVlG8rEzrJD8+sXcTGHbGxdbbMGTv5PtXoloZTyQBFqFregvU5Fkx96GJxo0oUQbV3myG6rMpz6oRmSpylXcX9hVwNsALzd7DHkPaBFdiUd9d/X831fPyySXrV96LFIAqS0vBGvQsnSHbbSOjRYP3kFJNnXvbxpACp5rvpMslsBp1Bp5krF1AMaWt+JHQ3IMfs/tBtqlzG8aqxJG1pc4UwjUJxEtRQl7NhdlvV62AYTOKDATj1dBbvYZiN7RiaGkbM1w4Y0db+rY4JndEv/gOdTX3OduFGt3cz4upvSM1gnWh4b6ZAEj4rN8t0DDUAz5YC8bwQdK13z+2YSY
 XjTXn42F
 2FqZENZpr6vMofq1O6QbKcDuu3Noze5XtQHTEtTF9CSXMKUv5YSoBVOlp6t1NyAPYQKGGIOlGEKSSU2LeUvMxFeV+td0nnaUiQxKQ6ijXb66oJ5+f4X/q6uaACgJ0k1o9RiG+dict2X7eW/kI2XuDH+DW5ZLlk475bZ4Ogh8qhN1A1sRmyTRFdEurNs+AnFK6qQz/hultVaH3bggVVHrBe7g4T1s0/Iws6mh8JQGmhZpDyBexXujreG163HG57/CGEUAUMj5zDU9t446ZCV8eigtlM28ZChOYNwyShrKtPRDuWnj0zhle2ItcnDTRydHxzJZsem2s80qQ3icJjNoevaTYMDrLAvK/hN3HgstKJAD3BllWfswbAmuxFFCV34XF6DlAuU/kAcqY9o5kk5wKtgqn+WeRLk2uuhbQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Jun 2025 12:19:35 +0000, mkoutny@suse.com wrote:
> The balancing works with task granularity already and this new attribute
> is not much of a resource to control.
> Have you considered a per-task attribute? (sched_setattr(), prctl() or
> similar) That one could be inherited and respective cgroups would be
> seeded with a process with intended values. And cpuset could be
> traditionally used to restrict the scope of balancing of such tasks.
>
> WDYT?

Following this direction, I posted a per-process/thread-group prctl()
series for automatic NUMA balancing control:

https://lore.kernel.org/all/20260908122446.56708-1-lizhe.67@bytedance.com/

The series keeps kernel.numa_balancing as the global hard-off switch and
uses a weak two-state process setting: disable to opt out, enable to
allow participation when the global sysctl and memory policy allow it.
The configured mode is stored in signal_struct, so CLONE_THREAD threads
share it, fork inherits it, and exec preserves it. cpuset and memory
policy still define the placement domain and VMA eligibility.

This is intended to cover the use case raised in this thread without
adding a cgroup-local NUMA balancing resource knob. Could you please have
a look and let me know whether this matches the direction you had in
mind, or whether you would prefer a different ABI such as sched_setattr()?

If the direction looks acceptable, I would also appreciate guidance on
whether the current series has any remaining blockers for being picked
up.

Thanks,
Zhe

