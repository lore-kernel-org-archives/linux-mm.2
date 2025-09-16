Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79980CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 00:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE30C8E000E; Mon, 15 Sep 2025 20:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA938E0001; Mon, 15 Sep 2025 20:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7C68E000E; Mon, 15 Sep 2025 20:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6458E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:11:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D071C07D9
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:11:16 +0000 (UTC)
X-FDA: 83893183752.15.8A401E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9DB7A100005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 00:11:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bfrvjN6A;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757981474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vL6h9Q/ZDSFaVKpiaInafvTNcWEpN8qP8BUvOhXDR4=;
	b=yCKcVuEd3vx4lqYOUc9Y8Ud4oqChEeBZdUUZKBbmphshkjU+p1U+kO8A/0qS1nQxZHOgWn
	1M6kcFBnLs2Mm/olUKPD7cXrMSTSgKceRlk6TOKqLwRm7U+SXdpEAOJvP5/j34gLtEKF0N
	NDIWQRNo44FzhEVqTeXgwwJIMtPcAPc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757981474; a=rsa-sha256;
	cv=none;
	b=dLjFJhCw9PG6Y812pIX2zw/ufXLhCfJR4456ltoudLDJeQ5El5yAPcvunwQ8HwvIVlg2b8
	0w7iuqBjRUEYQFZHGfHK4w1UXTlTmV154+xRpMdsMW3P2dLcfAPoZaaw1wyNLB4EDmH0eb
	n7ZbKNMFKa+dk/CQ+CZe/hgn8L4Jtms=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bfrvjN6A;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C955D60054;
	Tue, 16 Sep 2025 00:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5625C4CEF5;
	Tue, 16 Sep 2025 00:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757981473;
	bh=fQf0ppc42EwsOf0ekWpZyi02hc7MO+o0unxS4+mjbmQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bfrvjN6As3FbUsPhLt9BCR9kK5UpprOa4pIBTdb4pS8bHCS6JXgKAEY41LwWtgB46
	 tvMb718/Mk96EUkT91bK54C8a3Jq+5PnN7ZGUwl8SQeDE8RTaK29+cpHVbPxbDsZk5
	 QOtoOJH/EW+xxZgvSjoejTWo3UQRemd8Vk/oKUH8=
Date: Mon, 15 Sep 2025 17:11:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
 usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev,
 harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com,
 pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters
 in /proc/allocinfo output
Message-Id: <20250915171112.f71a7606a7f9fd3054662bed@linux-foundation.org>
In-Reply-To: <20250915230224.4115531-1-surenb@google.com>
References: <20250915230224.4115531-1-surenb@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: urh5nn1ifdgpijex5c4z6bnutkfwgptd
X-Rspamd-Queue-Id: 9DB7A100005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757981474-123556
X-HE-Meta: U2FsdGVkX1+ZTmQbL5ROX3gXrkxdzPnZkRS9ghxmIPVRLP+6aeorV72JJIAHKfWGqgZyRLl4Byy+r1qwL6wdlJoiyBurG6Nu5LBJFqovNfESqHO2d4MqckrHRoRe3/rUSii/ATQ7VeS/bRSEU12N7/sbwSV+gc2fjP/7PkKPmUyxacRquZAXsl74CaMJ9muiqA/jcYPTx4QzsAwjOZ+RhcA6hCjPpW8+E8JWt97+0GgLi47+5PbdxH3cBb7HtC9a+gdPJWI+wAg7pIzFCOyA4YwyIf3b6twycZ/yKF89NxzsssZIoLiCSX8j8YJeLvhxHmSYtw5+EVzZ8chJXGil/GPonnE2MwQOLOyCA5jp5CcNm8C1TKFLwl3Mck80SpUqptGO2tHgHr9xAKG2SMYPlvdw/aCBybGtTOpg5mSK+lI1wuKJ7+FJU56+WnyCnR8Nv8j6mkqKEN4N+jA/dkAyqMB7jMvd36PY7sXN6LvHMA1s5aL3BDsSUP0+rMoeZlbbP43GNAwAre+AXINEKNcLWnKMT219ioG3dIu6ruiPDzaevLB9fKxyLAd8e3yH+jbGiTOnuWgJ3EB9hh/lqSbyqwZqYNs6NhqaTBiCO5Y+N9Q2pP+iosi8V59ySJg9E0d10ytoGU5g7y4amMe/vf/yWw+eth/x7qxcwDLhlntqI2irBMatGuZlO3jAyjMlU5nanowOugGajmAyntfoa0Y7e51d74xoO0I0QNX8zshI9NJdo+eGEhYGKrzxtzZzUcA3M+asHzGXYVh/f2Vm+MFoWxiqNnWvFcSBx8vyPCsP4Mh06kUxMo2FWXMp2bJWhsyxUiU/qmkzISD6tI+KK9a7UDYBMHoUz0IKjnSTDvAzPgf57v/ZtbiVE3ShXM2nbzAMud6C0S/sJP3QKVMP5hNq3mIWDlb5UPahYv+SrN85EfdyKfZALU6L7WtlS041TxXz9rfhXlmiLUx2ORV8fFe
 nUCn1nte
 G5gBBr2ZK/xQrROpcRmQs5gBU0RZ67cHGPg0cmsKWHLxxRoTE6yAAg2x3JxCficE8QjdPPjNQqtxEfRhDDt0afcXbXnwaAJ+bJGZihzWvEFhv/S5Mw+KgPQwVjqtBRLzgzigD1Zd4XC/4wnzvCq61GEsfwjsa/qe+DxBvAFi+a9Hc/v9Og7NOlSz5V26vzL8HtfeUrMhx9aMXC4an7wlgIZnUGLa8tBzfARilkBydE5ve+hnpazA9ZKn0XHi/ZrxqDGise4jfEP/hV6NoXkEPI8RbSCvqGI3zDXcYvStjHNAYP8Rc4PjA1XZfCJo8u5JHsrm4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 16:02:24 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> While rare, memory allocation profiling can contain inaccurate counters
> if slab object extension vector allocation fails. That allocation might
> succeed later but prior to that, slab allocations that would have used
> that object extension vector will not be accounted for. To indicate
> incorrect counters, "accurate:no" marker is appended to the call site
> line in the /proc/allocinfo output.
> Bump up /proc/allocinfo version to reflect the change in the file format
> and update documentation.
> 
> Example output with invalid counters:
> allocinfo - version: 2.0
>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
>            0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
>            0        0 arch/x86/kernel/alternative.c:127 func:__its_alloc accurate:no
>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create accurate:no
>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
> 
> ...
>
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1009,6 +1009,10 @@ number, module (if originates from a loadable module) and the function calling
>  the allocation. The number of bytes allocated and number of calls at each
>  location are reported. The first line indicates the version of the file, the
>  second line is the header listing fields in the file.
> +If file version is 2.0 or higher then each line may contain additional
> +<key>:<value> pairs representing extra information about the call site.
> +For example if the counters are not accurate, the line will be appended with
> +"accurate:no" pair.

Perhaps we can tell people what accurate:no actually means.  It is a
rather disturbing thing to see!  How worried should our users be about
it?

