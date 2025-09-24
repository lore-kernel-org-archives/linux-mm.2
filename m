Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 673FECAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 01:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82618E000A; Tue, 23 Sep 2025 21:12:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A315C8E0001; Tue, 23 Sep 2025 21:12:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946CA8E000A; Tue, 23 Sep 2025 21:12:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D7ED8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:12:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4921059BEB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:12:55 +0000 (UTC)
X-FDA: 83922369510.06.6064D4F
Received: from r3-11.sinamail.sina.com.cn (r3-11.sinamail.sina.com.cn [202.108.3.11])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D7CD140002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 01:12:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=X8607Efd;
	spf=pass (imf23.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758676373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F3Vev1S7aV8UUtT9qzzcZZdbgYkh5ZuQnEAJO6fFqg=;
	b=K237uSMi8KoRexJq9R/jffgLDoiC+sb3r3rvc6/cuKIZ4CyNmdl+5kiOp3MW8a7LgVcci4
	JFDA3sDRDhJSQ7FnEeZMbpgisuq/w69dFjgDAYfU9QDvt4tT/z3NJSnH0GQ4itfObW41Va
	k63zN1uR3C05tiO5MZEcIUwBXVAt5PY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=X8607Efd;
	spf=pass (imf23.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.11 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758676373; a=rsa-sha256;
	cv=none;
	b=Yluvbze8TFQU7Hx9ahgWdmuoo3y4BlEEIXZOS5xDwGTa5KUWjnBfqIsRA/rtcd9Kqm2leJ
	fG5eIssIgQq/xvcsx18hgayGt654vJfW6jwiNRAX6uFGr9pcFbM5wjQvYjroEygmN6LhWF
	JNGX+Mg2Ih4iqmWEjrecKg6FUtoHN8g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1758676372;
	bh=8F3Vev1S7aV8UUtT9qzzcZZdbgYkh5ZuQnEAJO6fFqg=;
	h=From:Subject:Date:Message-ID;
	b=X8607Efdu+ixsllkUWKEqKwM2hhn8RROQJcGgrSr87BJNOq5gGfwbIUeW1HJp9Lqe
	 H0OkuY+SVKzX36At801GGlwAMrsqaXmFrbFnPGS1/yQjfmydcyiWaZ1JEaqFqR2uKD
	 cp/nrMCWCB6Xw+3XaYjz13HD9L5j+TZsWArLbKzg=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.236])
	by sina.com (10.54.253.34) with ESMTP
	id 68D3458F000026EA; Wed, 24 Sep 2025 09:12:48 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 5722796292116
X-SMAIL-UIID: 3BE03A43A15B4C7999275EDEE5C853FC-20250924-091248-1
From: Hillf Danton <hdanton@sina.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	multikernel@lists.linux.dev
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture support
Date: Wed, 24 Sep 2025 09:12:35 +0800
Message-ID: <20250924011237.7568-1-hdanton@sina.com>
In-Reply-To: <CAM_iQpXMjFs4LmpRVNqxeBnFp4KxEfgi9cB_Jwuy7VgOSqTfsQ@mail.gmail.com>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com> <20250921014721.7323-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6D7CD140002
X-Stat-Signature: m4murnnupuy6swawfrzwbyy6cihdjizs
X-HE-Tag: 1758676372-175347
X-HE-Meta: U2FsdGVkX1/HYSG0gWe7RJU9z8NemdMxRBf05C7lS+aYiozlNfcvGaV4qraeuB4XIFDJlef1paqMspbBD6pFO8pGvnKoS+EhLfNnmOjr/pSm/15NIjIYCPXJ1RJ8t9MjtQFFLyMzz947VBi6vMrzNHqYgID68HmyTtATYX2amVBviTO0wKO87YL5kYHleYI5bDBml7BLtTeIgShMGIA0oqwEay0X8Jjo18+Ol/evWwEdvPQF5J+xIJawT7M8qE3cHwzHx96dgDLai/t4+fRE/RHNqDgl+ILcDz2PSpmDKrWvDFP3Eph4Fr+hM1t1YYAdMLx2lkKP6Ee7cZRt5CfSvkE3ayjQgKBC0q4NeJQps06G8nIisQk6EnLgRug4ZJuQrRHRCobJBHKJKvzh8ZYeNpISPvP538z+fkOqfOV0G9jzLU2qxg5BZaLb7Z5fs+lNQyKGxmPDX1guD45+KaKMzMGt/I/c3FnmwpjfsUbszceS3lVr/E5teOFbrpG+crsSIYo0uR0DVz/O2I4XzC5RmC/rRqSBKzzkC+qUMiT71fx0D72ILTW0axqY6fehwK+CMXaPcACQcXk9f/2Hcu4MGbv1DSjlhS6Lq3fnUtsWjwTNUG71KzIJZs8Rsx6Zxn8sipI1Xey2Ux7NzbAhuXagGhlL4h+cCenCxwKbc2mJqm813k0lQ2kx1+Hjtx4vaYzgi81/ukqTQULP0mDnGM7y3Ziyj1FM3ku54S/wWxzk+bm/v3wZvno84rSjVne05IySNwN+bXzvoeSN9MDZcRJWnjVMPUNHaZ0Sz7G9Y6Jm6Nc5CBwzMevhbmQ1SykTPchu9HYvKejXtHw7JnS9XGvQMzjXYE3V0/ISP44DiTOuCyMGEvHBeAYqqyCqvxciXRm6g3roEMgWx40YHgtYa9FgBQ128HnyY7WehUkGYoa+wHioSvX8w9g0wXVZvDjSyib5cPQc33TrWuKG8+zICzI
 gHaTXOgu
 foHnUBpzv5iUTJCTyX+1GWPykdsiKW4NXdm3Wvs+YCc0kwI77gskjb2xYd6ezv1UGDf3oC8Q+Z1GkXYyiW7r1YdA0zIZ+jol+ghZJq870a3pJILAObOGQinQcs4tX5Gj8+fspNvlBLwh3oX3RSK6ZUuu84F9LdP96Nzs19l5Ms3DvrqSORW+fvilu325sKdXrvdOtCVEqHi1HclQtVfYAoL4IydeDFqBaM1r1tASh/fF34jP+MyN2Ua3Dxm9QMJB9ekhOE4zvJA4hGX98e7tMq2jm6CFBcNJd7MhLS23Q1Wjw27BpIyR5wJoXV5SXZGr8eF34dVWJ2v5ep8AR8kLWEB1IJoisu2EcvygrN4EU9TBJfxCFgGpePmsMggoxQqPaUolR2GnpNfbhD4GIFjoy8TkeZCKiFK0aMuSuJPaOTSADm2pLDW1EqbPykw/gM74jiPxLLV7IzHrruJ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 22 Sep 2025 14:55:41 -0700 Cong Wang wrote:
> On Sat, Sep 20, 2025 at 6:47 PM Hillf Danton <hdanton@sina.com> wrote:
> > On Thu, 18 Sep 2025 15:25:59 -0700 Cong Wang wrote:
> > > This patch series introduces multikernel architecture support, enabling
> > > multiple independent kernel instances to coexist and communicate on a
> > > single physical machine. Each kernel instance can run on dedicated CPU
> > > cores while sharing the underlying hardware resources.
> > >
> > > The multikernel architecture provides several key benefits:
> > > - Improved fault isolation between different workloads
> > > - Enhanced security through kernel-level separation
> > > - Better resource utilization than traditional VM (KVM, Xen etc.)
> > > - Potential zero-down kernel update with KHO (Kernel Hand Over)
> > >
> > Could you illustrate a couple of use cases to help understand your idea?
> 
> Sure, below are a few use cases on my mind:
> 
> 1) With sufficient hardware resources: each kernel gets isolated resources
> with real bare metal performance. This applies to all VM/container use cases
> today, just with pure better performance: no virtualization, no noisy neighbor.
> 
> More importantly, they can co-exist. In theory, you can run a multiernel with
> a VM inside and with a container inside the VM.
> 
If the 6.17 eevdf perfs better than the 6.15 one could, their co-exist wastes
bare metal cpu cycles.

> 2) Active-backup kernel for mission-critical tasks: after the primary kernel
> crashes, a backup kernel in parallel immediately takes over without interrupting
> the user-space task.
> 
> Dual-kernel systems are very common for automotives today.
> 
If 6.17 is more stable than 6.14, running the latter sounds like square skull
in the product environment.

> 3) Getting rid of the OS to reduce the attack surface. We could pack everything
> properly in an initramfs and run it directly without bothering a full
> OS. This is similar to what unikernels or macro VM's do today.
> 
Duno

> 4) Machine learning in the kernel. Machine learning is too specific to
> workloads, for instance, mixing real-time scheduling and non-RT can be challenging for
> ML to tune the CPU scheduler, which is an essential multi-goal learning.
> 
No room for CUDA in kernel I think in 2025.

> 5) Per-application specialized kernel: For example, running a RT kernel
> and non-RT kernel in parallel. Memory footprint can also be reduced by
> reducing the 5-level paging tables when necessary.

If RT makes your product earn more money in fewer weeks, why is eevdf
another option, given RT means no schedule at the first place?

