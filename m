Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F7DC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2B36B008C; Thu, 23 Jul 2026 07:30:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99F66B0092; Thu, 23 Jul 2026 07:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFFC6B0093; Thu, 23 Jul 2026 07:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95A0A6B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:30:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DD68140463
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:30:13 +0000 (UTC)
X-FDA: 85019822706.05.E2C08BD
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3560E100002
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:30:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S+CxPn4V;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlMXS0ReEa1Jcg5Kw/12F9RUMNxQ8FVd9z21BkuydjE=;
	b=GclYCLgXILnfgsM0e1rYgYBmrZVLUYy4TZHWOuFlRe4Wu974QnXMQ473pYoNxIkHU13OMc
	zGRdKi0k2OmSBODn0lVxv0sCZZ6wp/BFwjivI3MhSeJZGGyZ8ebZOVVrZM/cyaFMLf6R4M
	Dz1HwDtISNpUZdLFSZvBplpHzRLGiAs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S+CxPn4V;
	spf=pass (imf14.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806211;
	b=HwreJ9kygebselSHKL1We+lJQ5/h3GGWLtDLpI4AZ1sVSPoBuetTfxdRwiDgycyPbyY/Pb
	xNfPZ8OUH/EmZR77Q/DfNlXOCfp7L5Z5zJQAgKcu8CvJ+RGzFBCIaUx54J1X+qTSgGTuJk
	Nu1lYiR/7YFXClUnGjY8DKzQ69ryUJ8=
Date: Thu, 23 Jul 2026 19:29:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TlMXS0ReEa1Jcg5Kw/12F9RUMNxQ8FVd9z21BkuydjE=;
	b=S+CxPn4VeSNyIfb3s0ABJkkUNzNutt68r9nqps6I/lyAtvkSCQnLvPld/W+kKaNpsYjWg4
	d8mxCwLHUTJWLe1QHnM59lyqfVjxrsqlcQrxlTSBqNxCROwWnKVAEA4422DjU/UVCaLskT
	OZFnUjxbOo+xE63T508iZlC0nKXtdPU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
Message-ID: <amH7GSSZNliu1vWt@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3560E100002
X-Stat-Signature: wbx3eu34gha73jg7ig5k4wsfi913o4uq
X-HE-Tag: 1784806211-216697
X-HE-Meta: U2FsdGVkX18hw+dImeqCinhKBYfq2kino5x2PwkHoTRMYdaiCuBo+EPpS4yJf+tH0lZCitw+jS5kwXT/LIwYUij8Q6huQuPwTsIe1Hk3N9BkeUW0bJ3Iyc3tXPIRU8yrR+xhjNsxshwZsyxIbIAOOv5FaZ+M0J3u0ieYNhVNk2R60SC9RuJZIOQwc+87Mezc9IMtpA9sMqrJu6ZwKottLPCERwmo6VxUYni0UeJRSxHpZJ4z7a2gmWXPzILJw1x7P13MnYyBkjvglcTbeUu1jY5rr3vmnAjWn+KiUhmF0R0YcAWAf48qLtlIYmbg3PNzo0c47kEpjn5RyvIKQJA2pBiQ0NEA29W6ZalXQc7JmyRzY3rXiqeKkMjih0RNsx79IkxyTe0eGaHb0BYCknNRQopyNLVT4Ymzr3rdc+iptTH2t+TtLtntFTnGF9rUcJCbcRevRZwwa0VYZdEAvd2eBtyF0Mp3NVZJl7/+Bbv3TBp3cmNR+89UJtPOm78LSBypom5IMxNpaPhQpnN6mWcOmpAeBuD93JJW67nJGE+O8nABeKfX+EvPSwHDHGQOLyd3SKNOUBPTrGXOXXcRvy1Q2EFnH6KOrKKO2BxdsimDBx0N6ZjZm131YFXVohescxaiBNlUafdi3gP5i8wMNLJAICWCXhQ53qZDYiSEfQrqjQAfjLkdI1/y0tYqtmCuplv1m74/bHSctWaniia1gZddUDGVriqW214SXnyHN53i7AZsXTdSUL1lBVtCffzT0GFzaPAmM21uzZ/cHRwRTbTIvA1s3itBf71OuyMZvg+vyrih9EGegdmcv802uWhb4rA9/uvF7A281L7xTm0MZ7sMjAxJlYwLyBCthz51AwkAv7jeaV7iFE55MG3tv+L2Jw/y6jX5GQRpv8XHfOGXP6ywF0yMJKOJfEUm6k/JBgvTQwaMZjzPOPGXSU6ty0xH9Zer88N1BgSqUochAwK4y85
 7bSPRJuj
 hHc1miGOxmsUhOY9ZUE/8YfX2/mxArRKUZ3p+dtjbNCAw4VFTJVvk2l7zdzRjAPZJA9t2d7obuz4kL+y7YzUqWXKAMQemxe6wrJ0QV2on3px3JXo5QZ23LZo26l3UPBkdhEFOVRxodjNamEu4cyt2lglK76NqmgcOzxUeuje7DoBQoQxXwJmDTg9QmYuczucXwtdcpkXJtBxEol8cnyJNj5njOlgHSMz66MQH8Yo+gOlJAl/GorRRhfmwPV3mFnmRRujBM27zuE7ySnZ13DJgH20lfiAVS8rAdcwIDvhkIu20jmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:18PM +0200, Vlastimil Babka (SUSE) wrote:
> Users of include/linux/memcontrol.h don't need to see this internal
> structure. Further changes to the struct will reduce recompiling.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

