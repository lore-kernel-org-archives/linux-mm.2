Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC1D4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:21:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8EB6B00ED; Tue, 30 Jun 2026 10:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F0B6B00EE; Tue, 30 Jun 2026 10:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB5E66B00EF; Tue, 30 Jun 2026 10:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A10D16B00ED
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:21:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2547FC28B0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:21:45 +0000 (UTC)
X-FDA: 84936792570.20.080EF2F
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id B317340002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:21:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X2t4P2pl;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829303;
	b=PY2hHv8zoL/+nWxdYPCbN7yLajiYmE5hBzEMqdn/CSJ4bC2f2yRjOkxNf84cF8+5RrndSB
	/EsVx+gjnbheQb8xPsH5xHsDAXGw54wblAQF4gRMC+kNs9obQS+ghlyYJ+6bsm6LpxwnOY
	ujmOAYl6IwLSY1E+9eEt0pt/y9Cn86k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7ma1fkLP7myuZ97dWxsnvojHSaSFp6xHyBh8qniR+0=;
	b=St5ALgeIk5QihTwAyF8fmGmZXhoTf5Au+jJpGbQ0MTja/zOMnaM97++VOGbV8jHhG77Wxd
	jtWN069CXmCX/R8WL9uOEEjRmOI6h1QtrMbsw0TDley51yyKMU5cLPJfXUrPaCB69qMVlj
	XWmJGUiGNPEZjCxUSd2+eJFVtPlG1XU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X2t4P2pl;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 30 Jun 2026 07:21:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782829298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W7ma1fkLP7myuZ97dWxsnvojHSaSFp6xHyBh8qniR+0=;
	b=X2t4P2plIlVRpq2hmcYnF0HiysTJE1BMvMoRfPBp/NqQJx7P8EJDQRdcUQSGexyGxfpU1d
	54f6MC4rBY3LY6E3hHlCNHOKgkPkh7U4RsCl8bOtTsoOFu/JZaA2bHLl+HZdD22n6Q08eM
	FYgExvdmeyZvlHZUadnJ4bcDdSD8rek=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 2/2] mm/vmpressure: move v1 userspace eventfd code
 into memcontrol-v1.c
Message-ID: <akPQrBZBQZGLO_DU@linux.dev>
References: <20260630112617.1198623-1-usama.arif@linux.dev>
 <20260630112617.1198623-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630112617.1198623-3-usama.arif@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 7gek3z9wmbwhrorifno9ypowpf8enx4c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B317340002
X-HE-Tag: 1782829301-594900
X-HE-Meta: U2FsdGVkX190PfYJAK/4DmFRtPPnchKCQPZwbXEL7Eq7u5+LC4p2nkKklxUUGIw8yeZr+6+zrZJu/+7Wp+0u3ea7VAB2UhW92Mb2nIyD9VmsdTnfnv/fwKlqWAWFG69qfQcBzvmy7iFkELnlV/PIqmMquxGgLS20z7IbfewA6Ow44pzxySbPUlGTXV5w28OAjDvBNRnKTu6oQhssQTHgdUkJcIOSXu9x7N65GOb9DLNCT/WcYo1g6I0YFqvluaIvxH3s3N2cRQt0aNXujIvcRuzOxKS/AidG0ZDSbiuOcKElr+qKuXR7pw2r/Lt46o/8rM7mZycNTgBfsNN5N5+RbtJLDlmhrOfPzXaP62hDThgr0b6R8U21OjkvD5YMAYlfBATI5AHx9uz4A75T5CLXgSls0Q+jM2f7odcOGPwAujSddFyAn+0z1Uwld9s/hEQ0mWBNOql0jYicwJV9uxyUzhWh5veP2K8XsSxzaBUjO4ofU6P/3Y3YiR2VTR6hk3VJfpcKEt6IiElxIQEs+wpi3L5z+T3ARyv846S+3gmSdnsBArMn8otI+rZJERUGmhCatB7V8ORJOvPaNW39lc2D4+xCpbyvB4PgRRN0xUQV36wXN4Q5zBdCPc8OpcLS/h2xk/OWSSyD+7yUHY/ZirQ1JwfQfqTfizL7af7jQKwzH2f6DGJWWHrn84tDcDCTfiQLh1E/bb/jpfLV/E341S4c+wEeKSp4rI+KesvIG8DOiDWapEw4J2iKcYBIN3mbP2qPk4VhoZ2QGfcKx3yP6R5fjg7qjpsGfxh/cDa5tksf0LYsbkcXaIgeNJaeipNY7C5YW/1sWOq+hO1BvJYMR4lolCBs4DlO7TCZBiuoBmrNJeplNRJI2Mn0S44I55jqv6tkZ4RfCj3hw4u5rBSV+A/SqV4WW+I6WF3+dvkhfdzTujORyCmYkjxsKU8fHlE86PwxDvuN3+89GAF2AaMXwsF
 ic/pomME
 ATl5++A7Z7gm0dKe3g6fZhCREB/Hx9dZGwuZVtZum6nZzpfok03waAJrsvh47qriKkW17rwEZ4tVlHeNa2SL+nj5r6+Sm93RXB7RpLyfafDhg+JVfIRFJo/EYIGmF1I/nGkJeaMRI8fXfUfP431oFLVp9pb8grnbnc6PjkAqgJEz4A/pMCNR8/ylLViAQTIPV4IRWDZ+r3PThQVnx3oROpWsU5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 04:23:33AM -0700, Usama Arif wrote:
> Clean up mm/vmpressure.c by separating the cgroup v1 userspace eventfd
> interface from the shared and v2 in-kernel code.
> 
> Currently, almost half of mm/vmpressure.c exists to serve tree=true:
> struct vmpressure_event, the events list and its mutex, the work_struct
> and vmpressure_work_fn that drains tree_scanned/tree_reclaimed, the
> parent walk, vmpressure_event(), vmpressure_register_event(),
> vmpressure_unregister_event(), and vmpressure_prio() (which always
> calls vmpressure() with tree=true).
> 
> Move it all into mm/memcontrol-v1.c (built only when CONFIG_MEMCG_V1=y)
> as a single contiguous block, following the per-component layout already
> used by that file. Keeping the v1 vmpressure code with the rest of the
> deprecated cgroup v1 memory controller makes the full footprint of the
> CONFIG_MEMCG_V1 option easy to see in one place, which matters more
> than component-level file separation for code that has no active
> development.
> 
> vmpressure.c keeps the shared bits (constants, vmpressure_calc_level,
> the runtime hierarchy check, the tree=false body, init/cleanup
> plumbing) and calls into three small v1 hooks for the tree=true
> accumulator and the v1 portions of init/cleanup. The hooks have
> static-inline no-op stubs in include/linux/vmpressure.h for the
> !MEMCG_V1 case, so callers don't need ifdefs. vmpressure_prio() gets
> the same treatment, which means vmscan.c's call site disappears at
> compile time on v2-only kernels.
> 
> The only #ifdef CONFIG_MEMCG_V1 in source remains around the v1-only
> fields inside struct vmpressure itself.
> 
> Memory savings on CONFIG_MEMCG_V1=n (measured with pahole):
> 
>   struct vmpressure :  112B ->   24B
>   struct mem_cgroup : 1664B -> 1536B
> 
> This split is the first step toward eventually making vmpressure
> CONFIG_MEMCG_V1 only. The v2 in-kernel socket pressure path
> (tree=false) cannot be removed today immediately: PSI is not an
> exact replacement for vmpressure, and switching networking socket-buffer
> back-off to PSI may regress networking performance or increase memory
> pressure in workloads that today rely on vmpressure's hysteresis. The
> medium-term plan is to introduce a PSI-based socket-pressure path, keep
> vmpressure available for v2 behind a defconfig as an opt-out for several
> releases, and only then drop the tree=false path entirely, at which point
> everything that remains of the vmpressure block in mm/memcontrol-v1.c is
> the whole subsystem.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


