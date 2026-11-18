Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF2C0606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jY8tp64O
Received: by kanga.kvack.org (Postfix)
	id 0B85F6B05B6; Wed, 18 Nov 2026 05:39:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06A9A6B05B7; Wed, 18 Nov 2026 05:39:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2D06B05B8; Wed, 18 Nov 2026 05:39:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA7C76B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:39:37 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABCC014066C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:39:36 +0000 (UTC)
X-FDA: 85447893552.13.870A018
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02C6C100002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:39:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jY8tp64O;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794998375;
	b=GLVKkUdR9c2ZivqotfB+DL0BCFMgtzWwxOuIvhK7IQSNU3skjKsEBqD5uLbtHb/dj68x48
	KcieTLQUo1EqIVqzBXo43DE5iT3kL7Fnh3Fc6KENSSCH+23Z5pk/vtbI47OljHyjurT2Fk
	f0Qym4ORhMt3AOsUAwvCQQxFHi/XU0A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794998375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJRTdguElXmssobv0TOrC+vaUaZVEoXzykiJehbKQIw=;
	b=Ki2cbD5tAfra8Y73lph2s+HgPHFxqM2HWh/aVMWehaVUh3uyuUjAwZ8GX57IMu5CpNn8Fc
	XVZwSYSg/A+w2I/Y9cKxMkDeFl5sAcDMKRcxI3BwziIXTJ4g/LC1Gz4X3Sy9oqK64b30Ds
	13ZKtb/v52+h4XPDggyUMYbH1TMe+nE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jY8tp64O;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E686C40597;
	Wed, 18 Nov 2026 10:39:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF331F000C5;
	Wed, 18 Nov 2026 10:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998373;
	bh=cJRTdguElXmssobv0TOrC+vaUaZVEoXzykiJehbKQIw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jY8tp64OXbgLEBnbVdFjcaoF+43vtl+BqJoqBlnI9pAgGz3zGtHvTQjxkc9uCZUkQ
	 sDeob9S5j2PG6O9HoQ0tcJY8M24yz+CrtOk9kXBCrGVr5vY+7WoMCZTMVhvejFNED8
	 iZlORyWbmqdkpfYXSD3e1vHTsiq5liI5yY7jmCoalgiysP1Eu1YukOZYoOdLREb+3p
	 kVYqfCpfVN6Hn0eaSeh8Gl/2v3K2eimXhrbE7dOw2czndjO7BD2JzRuJqrEqB6rTQ+
	 qJAESJxOmxpEMlIXxMQj1MaTmaLE9erT6XwM1qrSrFYH4LQKIS1yLiEOyeCnHXGaxX
	 /MeOtSIO5w1iw==
From: Christian Brauner <brauner@kernel.org>
To: Christian Aurich Zanettini Martins <christian.aurichzm@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261103002157.219277-1-christian.aurichzm@gmail.com>
References: <20261103002157.219277-1-christian.aurichzm@gmail.com>
Subject: Re: [PATCH] fork: Don't let copy_exec_state() fail before
 rt_mutex_init_task()
Message-Id: <20261118-ketchup-normen-klatschen-d155bd8baeb7@brauner>
Date: Wed, 18 Nov 2026 11:39:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-04696
X-Rspamd-Queue-Id: 02C6C100002
X-Rspam-User:
X-Stat-Signature: 915rmsrbbqqukjpz4idqf7mprosok8zq
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794998374-512836
X-HE-Meta: U2FsdGVkX1/6jfSAWA4cyJRiXx06IHdSssqdEj3ZQpe/5Ntcm4jnToKkZq8rQi6ajq0InobYNyEomQ7irIPuEcgySW8h1UC1zJqERQEGo2S/AM0ox2uAfaA3Ov1Q8hILQZxkwmRYChVbin+fAlrW3vUFNbn//7gmsGS60rrRMJPt1LeU3+nyJB3L1DeNggCgfvYysp+8sztXlX18NQlDkvbQVKBGM88ZOWOjFP9JYdNrnfqu1idhY+ea+BUcrLZ/r13R/1tZNRjS45rFKgTGnHsyq8vcCttUmy+rL25K8ZaZj7BqvxuyVi4lJeSNaTGUYlX9LpQNtP1lCOXuyyIym1yuknJxhfsHyZTc6dV+JiJfSmF95+6dP2KK3t5nOOYzb4RN++CdstTeYm0Oj8hpAtv+IZrY1rSMB+Uemk5s/HSmuF46l+9Ctx3lwRrZLbmn6MMnlb4kqRYSqKtnq3UkpEPbXl8Ty7BnM+GogUe7/gmbiBznGJ9noiMJZkHVebFbUjqfitHf9Ub3vNXgRMrUZCQ1tE5s63Fs4/etdnEXzMGaKj6XOxp6B0Ad99upwxeLru+VK2TtrNJ4Yritzc7nzc6Bd4D2ZCsFEKCLt6yQxRGjtt+gPGe+fHlHIuaNb37+YUsijRSiNBz6gFAACRdcEepeUbmxBfkd4xaLe5IRGd+FQE56WsNjDVWtU/CJM5XtPoslFki0wI3Hd5cQAsgzLV60RSapXm4z3oNt1v6k+WlVxzzL18FaZRJV/utvZVE8mpimsQFgsccZ7E0HLddSoCqcfvYVejfp7d2FMZWGwMqHIJwqYGmgxObHdcCz3icrk+vfvpQaDNRyv7MhvEEJD+7pnoqodzUJdsfiCuIE0uMrEwwZbdJ0iVE2/mo38c4Q6CIwbAlkibu7JL6w3+aw2P+xl8s37CGdD7Udoa+weghXyVTJOs2G27lYMwPbiacvvkLsI4QeDJoTKXv4kFS
 gE2YiDkN
 ibgZ/4kfkJioraSGM66ZCIohowoNzBdEWFsTMHnEp1qgKgUYXVDQeiQ6rWJ9c7rAEpspN/lmHZC2x9jhBBxPG/0s78g2d70PW7xS3CAkoSaWPE3nn5E0gTgFaQhePv6HKCWFkIcDAn6iHu/v/rge6Xehxkork45ZQmlMkIF/NSvbDxjEFF7xKVQgLkvQTiodxsfIypehpYiNA1nfohc3qOwsJHFHEiXvo1wNHBeqe4V62t7VuBYK0k68zfV7VYQJq5WvIKOkx8REexFy5WHUmR4f91xlNAnlUVh5rgGufBC3hbcirnRP4fGzqTstUgW/QOJkmCAkRGPeOB8+ICe2mE9ZFMDshauvtnOPVLd4XXP9GTxjMNp6+Il3E69d6Tmqfv6NiJcw5+UwhkePL2Fn7e5u17dEE1ahtHktWklPsvYhCuYfQpl4bjig9p6D1wUyHJ8naoEj8/KtUw4mjhB9I5pjYTWntE+qcCiLk6ut1ItUUMg4D3kd+hPRnZ8lwu+mdI0XWOf7MNwo22XA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 21:21:57 -0300, Christian Aurich Zanettini Martins wrote:
> Since commit 6b1c66c9cca9 ("exec_state: relocate dumpable information"),
> copy_exec_state() can fail before rt_mutex_init_task() has reset the PI
> state that dup_task_struct() copied from the parent. If the allocation
> fails while the parent owns an rt_mutex with waiters, such as a
> contended PI futex, free_task() finds the parent's waiters in the child
> and warns with CONFIG_DEBUG_RT_MUTEXES=y:
> 
> [...]

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] fork: Don't let copy_exec_state() fail before rt_mutex_init_task()
      https://git.kernel.org/vfs/vfs/c/b7cf4cd1f76d


