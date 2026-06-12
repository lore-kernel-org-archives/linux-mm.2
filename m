Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98B8ECD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 05:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 032866B00A2; Fri, 12 Jun 2026 01:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F25E66B00A4; Fri, 12 Jun 2026 01:29:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B956B00A5; Fri, 12 Jun 2026 01:29:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D23806B00A2
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:29:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7760116579B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:29:01 +0000 (UTC)
X-FDA: 84870131682.01.5383D13
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id A224D1C0002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:28:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AaeLdqPA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781242139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=co9Iw/3AbNoVqm+ieCaPAwVCcZFfa5kR/NB5heC5dsQ=;
	b=sQrMTtxnkF1MI5Z0V84tUCtAcWi4An98UO77ykghdbqQBfQsGHcB7kfdCzypG8bk3Rjk4X
	EM2MQG9c2vg4936mwOIV+ghGubwz5Mi3qsmZ9RAbn+6s+e4Yu9fbf4i9OZ4avoYwq+kYOA
	Em05FHePeyd52I/FBC+VP/Vcv/c/M6U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AaeLdqPA;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781242139;
	b=2P8IslWmBPhyb2u2y6dRRoq+Tfw/1svk1PVBj27GCact+uGRYD2gVSbPSwzOHarrhN+6r6
	osVAx/OHS3s2g3l/pmSme/Cb44eSE6aOkdinkj0CH1pVPA+5N42/hktWm7vneDkvoLUQKt
	FvNwcKJMn0JT1radKeHunX1jyzOggm4=
Date: Fri, 12 Jun 2026 13:28:25 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781242138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=co9Iw/3AbNoVqm+ieCaPAwVCcZFfa5kR/NB5heC5dsQ=;
	b=AaeLdqPA+cTJiMoWuujUNtd2oszWJnPer5VhmZi2FK+MwabP4xVhKs74kxVVTTz+uB2Lvl
	1+PYBj3PTDOSg9m/SR5tqt0RpmCOmEfsycBu3xPGBk+hAF0Oe/kOq2p18z7vVamONGyyrx
	vMUeI80xwDMdvhNEfDP7OnznDQw0oUE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 10/16] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
Message-ID: <aiuY1mDjpfCT94VY@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-10-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-10-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: eho53511z5bi5h56pdrm5zmg1eyu5kxh
X-Rspamd-Queue-Id: A224D1C0002
X-HE-Tag: 1781242139-278262
X-HE-Meta: U2FsdGVkX191Q+/jDshKT1KVdC3+YBHdr//RggBvHLhvE+qs/gPQiOhXh+Se9goLoP0/vFY1EVi0LEwXzDhcuRYTF8PiCcqvttd+RSF742cSwVMd47Cbc2yY83TgRm3Jv5+IadSPWNN6dJ0/hQT1daOx8iWnO7mkv5+snP6ErH2OBxDZ3CG+0xqV4kcmjHKx80/R/EPTmjh2a+8c13rCLFUnjLmyg4ycfwggDBBcaew/g+8a3cRF3bJxlRQrsS2mQ/HiNBV/b3+q03D2imGev/Gu+L054WNrCx9yndHnjIc9VvghH6Wv24qM0t6xNGEsgRjopOBsUd8lYQ/3usx09ioyQdK6DAoLdKIP3tSCfTRit0COYLgI7gtqJu8gTiOfWz/vsn2tnrkqvh0aCTRrxB47dxITusk3tgfBeNBZXdfVGQly/J1OLU+Yg6JKxBJAPKDZUoCjsQvwCXr+Blxv29S5G7qV3JCoGCVLwJzJb1sEy+xwPwzIRNzj7uL4L/JZ7fUXRPR4lLnkOO5hRxWYYwum2BdxGOJVioWshI79t1yKjAEqcS6HzmqCKHfMgdt0PKIZzz8ts5tsq260mN4gMGAaIgP1GGpua9edr/Z6uj5HPesNS24+CKBoEr5kPujrI8P0ButSEuPuaLSeAwvmci5VpYyVHCLlWAaiWhEuJFbtV4bN3krpyzEdmWx2SPutykfGTQ6hhT+3jzKMlyJAef5CW8khyrqz75QcR9McQ+m+zQAYoCe4sBn8cNeGvU5U5Ad/HXAXSegCNZLt/Vr8klcjUvttcHmItGDDrfqCTQcmdyxa7Ddty3qz7JPZSyqkEZxfepGo6koo2nlvLjRAUiZZT5SigG/FQDiJxhwDYR5mTPCIjKHYItAu7KbUjFlGMOXF0/zX5BDXVhSsovlRCXjaNehile8BEwDvIdM4StpQ9+bIVzfqn9XKVkF4nXfkOkHwlGepMClh0+7At6B
 rxDFCnTj
 FaidzN4+HrU1dFETyYUd1EO6mo0kNOXIowOcQI2rc7KzdPhia2mG0kdTh61ve+IMelOT5Hwnqivy171QJNf/Z13dcyXTusGGHSBgJ3w+V8vVb8YwxsVAclSOmwpl01YmgQc3qhpfQQW0jZ50DsY6wpCAoH5TaQK41xcSD5s/k+wgQu+DZBgv7BZIu+R3IZLRBMX4lA2GqGjgb2y486tFO38xs9R9uPxd3wJxop4xQVmzuN0YECU3zBN32sIgVqsa9d4Wkz0a86fjYGqwGa1ysq6tk5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:12PM +0200, Vlastimil Babka (SUSE) wrote:
> The function takes all the parameters that exist as fields in
> slab_alloc_context, except alloc_flags. Replace them with a single
> pointer.
> 
> This moves slab_alloc_context initialization to a number of callers,
> which is more verbose, but arguably also more clear than a long list of
> parameters, and most do not use the 'lru' field.
> 
> This will also allow kmalloc_nolock() to call slab_alloc_node() and
> reduce the special open-coding it currently has.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

