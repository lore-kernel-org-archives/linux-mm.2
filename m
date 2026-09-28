Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97529CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 20:40:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02AB76B008C; Mon, 28 Sep 2026 16:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D506B0092; Mon, 28 Sep 2026 16:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34326B0093; Mon, 28 Sep 2026 16:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B663F6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 16:40:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 316CD1A0309
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:40:24 +0000 (UTC)
X-FDA: 85264338768.14.247EFE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id ACDAD160006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:40:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GwpH/rQq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790628022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=m8gNHGeN9x3rygoOMPou+J30yRI3f3dCJdb5tsXJA8o=;
	b=YopNzTfkForGDczDbXcT7qgJUeAkba021/4vGWPU+209UoI9RdPUE8/v0TIry1GnyaXAO7
	tP0KNIsq+gcXl7fIyuAvL7251nRbdP7qhJK7ZdkU/9W0I5aIemYOl44xhsneUT5ekiL1O+
	5JnJ+GqJ0clT/RfaTmeephpds9ST3vY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GwpH/rQq";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790628022;
	b=XGvOPNmgMHDJHUmJDth928jc1NZzm3GNzNpT64TxmuDbCnGahwpZmIEzMFYZfQnS5zSz6K
	Has6/D2NbPmoSk9Y838q49yXVCDEFRq28X6NrqhzW3oj6WM3mkQ8dP5GuMVYY1A0XRNzOc
	Yz+j4U2A7DjKpzII9u6u0gaiFDZ+L30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 462E2600D1;
	Mon, 28 Sep 2026 20:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0621F000FF;
	Mon, 28 Sep 2026 20:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790628021;
	bh=m8gNHGeN9x3rygoOMPou+J30yRI3f3dCJdb5tsXJA8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GwpH/rQqVv024QcgJ6u3+OLqasWshPI5N2UHnxjNm/VTJaZ5eseSEUd7CIaE1i3i6
	 opCPfoiVnbc0CRgpybqTMVFg/t4qbQwgFsGNMa7sPUQCgf8rjhmuFCg6wnWW3qahi6
	 0dg4qW44ZgyNlBqrHCoGiNOqtTAtwUN0ex+qMG/LkEmSebCBiLp3Bm0iwB1PJHYuZx
	 zK0qcQn+9qJ5Zk9zA+Yr03TNNmYKenX+OVMA6xHKilAq9+bV/deI2pILyTX5b340GF
	 2GU8Mq6lZDmRRG3+Roaam4mTC4PXjouQQFDQC4NOPa4yxx6X+RIh50zw9BSScy1TED
	 aI2x/noyxexCA==
Date: Mon, 28 Sep 2026 10:40:20 -1000
Message-ID: <bda525506b3fb3e61da28a112f28abba@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	JP Kobryn <jp.kobryn@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Michal Koutny <mkoutny@suse.com>, Amery Hung <ameryhung@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>, Jiri Olsa <jolsa@kernel.org>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>, hui.zhu@linux.dev,
	Donet Tom <donettom@linux.ibm.com>, Greg Thelen <gthelen@google.com>,
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
	bpf@vger.kernel.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] memcg_ext: memcg policy through cgroup-attached
 struct_ops
In-Reply-To: <20260921192559.2619635-1-shakeel.butt@linux.dev>
References: <20260921192559.2619635-1-shakeel.butt@linux.dev>
X-Stat-Signature: ea1ds7kdnp4yymec8p8z9dfcuu7tq7zm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: ACDAD160006
X-HE-Tag: 1790628022-38274
X-HE-Meta: U2FsdGVkX18nty622axnc4m/IM0zwLSiIzWspQwKtIGVZcf/ifleEd8CvaOjqrHGgzT1PfJZPKierQPyBio+XCRMpESML8ILF8/LumXOlTTXO5TZ3A1JNKYWUjjGl1r8RyG1x/4c99tRqgUffAhlyypwZAQpGT5s9/J4Dmu2dhFU0b5gbKreZgS+4t/zetT8kt5seD6ZE4fgpwUoTPWu2a/0e2h4mNQnMr4a31acSlJgOScPrbDe4Q2AS3lmLW3gA6DjT548Qn/fYFDY5q7cFk0/xD5sHyfXNxDCKS/ShAdYn6LjG6mEsY49vUx07B+OIwUgDRNmONsY0/RKsoY/4dSHSeK+EsUgji8z7adW3KofdZkhPwXCdf97GupLmEgPQLfm6ZEp7hMsGh96Xpi6uUQMCwlm8mI3QEs7pVuYXQLWwLXEwQnYr+a6hmZL9EIK1Dx0+naFZ/lOBfOLsSjJsHoY7LjVVbqMHQTI2AbbZccUW10txwEIo3EAC/5HjOlcS6F4JmdR7ALSWaFNajOJxMQvJ5qTBf2UlqisV8zdyNlWblK41EmoYu3VDZwklbZg479wDcOyGbn/vkgmrXV56CELGLabA87ETRtuU4VraP8I6Yp+We/VtnaHDepMHqCv5wIX6ruFigNANXesaZBIARvuLXpP+ZDQQeNj05NeX29qVI5vB/57oOFobnYm/vvGdywoile7VrsNjJzgYFAwXOcInEvg0Y8ejHeCkyMlfggmtTo8zWeNUo7SwgIWctTVOZAbAqmUsV6/GszYX81MW1c1jH01DBRbD9W/TTJqGrH/C+AV1wqf1X9vNBaHdcaYZFBzYbmE+aWoNL72KKbJ2UUB3cWhsEAy6LzXcso5+8YTejS+5ol1PyOWm2luUFENlnlefFzJpWj+6bZUCf6il4/j2CxiYTP/8AOGaFu87VGFPRIZGDlCLMEV+WYd2YXFNEjEIkW4inFbUzqIdU2
 ZpW1Ju/f
 CPf5yZHgdNa4t20F0QtDsiHRuBWmfTi4cxXFK7Qs41241MqCpkgQpi2iNSuoBqdYV2rY+dZ7rbJR9W7ElPM8LZbq6YugHC8SeMKzduyCSrHPMoLfvupk4Gg0/LLSPf8HAoJKiZU3Fc0O2LMhNg3ou3rlhjzgstqGmZwv79kl1L4iVPhZx4F+5TqfnLuhffpLdsBfp1F52mzde4qTuc6GsQJ4CkIuH+Jkw2X9UHEjsbh1t5pYmwFyz5540mUoD8CQP5jnEoYJrNW5uy7B5a2MU23F3XUovcOOUGZlSt6+PMzO1foLyuYT9141wjO9PJm8dmVFvcBtnsYRru+5Tyz8Ge3nl/55r680TBEKtBKYTQ68uIV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shakeel.

On Mon, Sep 21, 2026 at 12:25:55PM -0700, Shakeel Butt wrote:
> try_charge_memcg() calls __mem_cgroup_handle_over_high() before it returns,
> which reclaims and can throttle the task.  That happens wherever the charge
> happens, so a task holding a kernel lock can be stuck there, and everything
> waiting on that lock is stuck behind it.

Why not just raise the lazy bound high enough that most charges never
enforce inline, and maybe annotate the specific paths that can allocate a
lot so that they do? Inline enforcement should be the exception, not the
rule. Flipping that and then trying to reverse it with custom BPF policies
doesn't make a lot of sense.

> One concrete scenario which can be resolved by this new feature is the
> kernfs notify worker. It delivers notifications with the cgroup2
> kernfs_rwsem held for read, and the charge for the delivery allocation goes
> to the cgroup that set the watch, usually one already under pressure. So
> the worker reclaims while holding the lock, a waiting writer blocks every
> later reader, and anything touching cgroupfs stalls for seconds.

Slowing down the kworker inline doesn't make sense. It's charging on behalf
of the watcher through set_active_memcg(), which already tells us whose debt
it is. Wouldn't it make more sense to defer the debt to that cgroup instead
of slowing down the kernel thread?

Thanks.

--
tejun

