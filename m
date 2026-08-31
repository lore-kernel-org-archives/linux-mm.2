Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24BDC61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 08:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D42D6B0096; Mon, 31 Aug 2026 04:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085646B0099; Mon, 31 Aug 2026 04:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6176B00A1; Mon, 31 Aug 2026 04:49:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFC996B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 04:49:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4784A140411
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:49:51 +0000 (UTC)
X-FDA: 85160941782.29.BF24367
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7787B140008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:49:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FaZekYeZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U0RHUkeCK2+wI7g+xlveFyXCiygTgGH8M2YKQRICDbA=;
	b=IjdmMgyMyRx+mjib67wN1LdLryEqPxBN0KBwoaOC9KAx8lC23ydlYmSSzd1teLIceXlDM3
	Zx9igvfRXAtsHQ5K7DxNDUqDR5/8volYF08PGRTNxhgrYkoOSX4vGY3AyYKNfn8mldZI/2
	93vYRPwRNtUAw+RfBYPpIiCKGtcQ+M8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FaZekYeZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166189;
	b=2nK+USd8uf+9HA9R2E5k8WxomExgjvrhkme+ZLevj3s9R3sGRTU2Fbw+TlSWEIktnQNiY2
	4k6McM5Zshq6jUqBOga4Zd2kcBJ2Z2WZXlHSKJfxoLqQ+YjGVgcv0p760RVVKLiIDgcFwP
	ZrA/3f5Y3MyvXzQXx+/oW7lNNPajh8Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90E7E42088;
	Mon, 31 Aug 2026 08:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8873A1F000E9;
	Mon, 31 Aug 2026 08:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166188;
	bh=U0RHUkeCK2+wI7g+xlveFyXCiygTgGH8M2YKQRICDbA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=FaZekYeZ0wFn0PLi2UeXQLR+DZ7Ga92WjP0iO0y3hPuhr7su7CkEDkn33bWwnytSy
	 bqfIgL6Rvjq0S5SBAEUGLQx7m56Qtzy1v1x0BCgLs8JTn59a05Qv/61kCQttaR5FwC
	 YK8Ew7IZDm5mKZIZOXrACM/O3Hd4VPjUO0iNW/CrvH3+p84aniky+0n76MgfvfEi2x
	 Zbsd+LfZzInCbDD3bgwwXSgCnoyLUGMWS0X87UtMiUPqI/6dGX4yKUDx6YF6soUTOE
	 luXbDuWAdjKCDJnaCAzS4n8PEKm7feSkY70ckwlXke+xvNMjIPhfKeAH6WuZjRBYoK
	 pT1ZRHj5evrxw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 0/3] pidfd: add task path ioctls
From: Christian Brauner <brauner@kernel.org>
To: Chen Linxuan <me@black-desk.cn>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, linux-api@vger.kernel.org
In-Reply-To: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
References: <20260831-pidfd-get-paths-v2-0-c59ea6a21b72@black-desk.cn>
Date: Mon, 31 Aug 2026 10:49:39 +0200
Message-Id: <20260831-tauwetter-werkbank-dramen-b37eb4025283@brauner>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1813; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RZsKRXUZ5MHkySOQ0pr1OGOzLW4PFVPPjI5FsfQV+lQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNdVCtzLdnsxG4xVH55O6X/3MWT28u6stlL3/36Y9nz
 sMr/3++7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIBTsjw+0H/otM9kquFjxX
 qq2ymFcwSzPDN64tZGXTnGtv3k+b8ZDhf4ZlH8PR9v3Ja9p6IlIU38x3dXzKfuFz2+O+CwxaSzy
 WcwIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: hjxohkihf1w8zb4zm3qabzkskkm86keo
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7787B140008
X-Rspam-User: 
X-HE-Tag: 1788166189-326600
X-HE-Meta: U2FsdGVkX1/GMBEnAg2V9mVLypZaKzBAAmwgyt80YK+fobNmnhgsOBm67A22JxlYnD6g88F1c8LdpN75eE9kCI2SDhB5fgtTO9I6xzikIhLLQjTxw347LYTM+HUr9/VV2ryXkWnuWjuKIPxSeuZN9xXWqo+q7NkTrilR7BBMnYaquoBlp2nVvfJQLy1tU+/XGtfwWy1V3jd2IfNQRexfzPuEiY3w30A+mnyWiA7xTSuXc/3rgbpHykJok9v4bXSZ0VQifPYpWLNucXdSMXrTJWoQQkJtExmjNHOW+TRmSgbiInNLL5LY4miR9l1f/KPkX/l9Ywo9FoEMvD0BONa9JhY5L9Rhc9seHHWGXAiTmRmyDG8Yv3VnXmZHrS8CivbEnQFJFPIpLFEwyHVFYw0uk+kdFic6Bsgf1x6m6pLDjoWkIsl/SddAOVN7t6frFFLLSG6T/kQrWMB78VAtCb4zgtyq70wf0sWgOj8GwYDjNlXD/NU4a2Ko//xX/Yb5T77IMr8NcuSno+KD0kuLiJeq0Zq0zCyBnadPHSHevvH1m06xY39EZlZOYzK8S+KdqAZPv3ZIXwzm4lSyOjTXthIxzG9G2b63MWSVg7vfICgmIntAvEgNnIxc8wc676dWV1UthR7OHH7wAT9Sr3lWjZn1v/wigpNBAQofvJb4hzc28TYyJ7GSQnUGMI4GxhBEifaclpWxWaCjbQkR81yfuvjnN+aNRazAmj3JNPTo8HMVWKohxYqyivWq2h11iPrU000GYbuVJYFnSQ+GqfQJKij0RIpuQdkzYzHQp04qeY14cpW4yMnrjzkCr1B7yIB7TTIf4c7gnWynmfJ3GTgqmrwH9EFUqpIFszW0yuEG2L5FN2KX0sCLsT7aZm510JSZTpZnGRg1UOT/v4rasmcoxF+OcuORcb+70d9oV0HRWL7x4PJQ/RDlQSzNCT5Iby6f5r0frNwzJZA3HZO4o5JsXvQ
 SCGFP7/w
 K23K4tbbvz2v+OZP/C8Vd/yKopmoRODzWM2LRV2iO6GhZZ/WciumQeh/Z9DCcRxw7E2bQ+MHML4FaIQUA54aDbAUQZlPhIkF5ACeTObgx0ACz8KwpImdRlmpZ+Hz7j3IInJT7vLUl8pEo//BS+0XzWhO10dIp6VgZRhJzXtPUxV052w/zWho2EeaiCrv4W1dxOtbgCDwIAK5Gd1+DSPsXpZEDuVavMnvSbo3WZeEw4avJ55GTiCpAWrUM76R45CAFtUFWhwHr84JPeJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-08-31 10:59 +0800, Chen Linxuan wrote:
> Obtaining a target task's executable, working directory, or root
> currently requires walking procfs symlinks such as /proc/<pid>/exe,
> /proc/<pid>/cwd, and /proc/<pid>/root.  That makes the operation depend
> on procfs being mounted and visible to the caller, even when it already
> holds a pidfd for the target.
> 
> This series adds PIDFD_GET_EXE, PIDFD_GET_CWD, and PIDFD_GET_ROOT. Each
> ioctl takes no argument and returns a close-on-exec O_PATH file
> descriptor referencing the corresponding task path.  The new ioctls use
> the same ptrace permission check and nonzero-argument rejection as the
> existing pidfd namespace ioctls.
> 
> The target task is sampled while holding its exec_update_lock. This
> keeps the access decision and the task-state read in the same exec
> critical section, preventing a concurrent execve() from changing the
> credentials or target state between the check and the use.
> 
> The first patch factors out helpers for acquiring referenced task paths
> and reuses them in procfs and AppArmor.  The second patch introduces
> scoped cleanup for privileged pidfd task access and separates namespace
> lookup from namespace fd creation.  The final patch uses these pieces to
> implement the three new ioctls.
> 
> Signed-off-by: Chen Linxuan <me@black-desk.cn>
> ---

I really have difficulties forming an opinion on this. So this sounds
very useful but it has implications.

Right now, pidfd ioctls are available even in situations where the task
in question would not be accessible via procfs, e.g., when procfs is
mounted with "hidepid" options or similar. So this would expand the
surface of operations you could potentially do.

But again, I do think it is actually useful. Adding Jann.


