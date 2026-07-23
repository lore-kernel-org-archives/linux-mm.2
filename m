Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C779DC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720416B007B; Thu, 23 Jul 2026 07:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8B56B0096; Thu, 23 Jul 2026 07:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611A76B0098; Thu, 23 Jul 2026 07:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E0F56B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:32:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB0AB160468
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:32:13 +0000 (UTC)
X-FDA: 85019827746.07.796633E
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96FDB140005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:32:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sdt/50cy";
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806331;
	b=dhJk8+oaiBJ/QaAN5YKtgKd60y62y7jx8wrk0nXVYPaHUL53l2arZGexn5a04t2aZ/yIla
	kVx9a83ySTrYEt/M11nLbxYMLNSOwAoi3AnEHPGuktdaoc/zFzAiLbTrhvhWsiTvEmRcYT
	sRplSj2AqPLLgjqh8i8iGP5oEwhZbso=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sdt/50cy";
	spf=pass (imf26.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WnP3NqUZtZbK6qpmXn4nR86n/4NymHwsXkDtmWeZw10=;
	b=hSMrEb4HRxe4RqJziuPna/cUnzpeZOLvqjQy5lWTDJli106tJmgk7mUXPwsyUCZ5CF2RBc
	Ci6Aa/WlBopIuENSoEbqfXXNMraTX5AkrbSAFATjLHpleet0ylDWwlNUUce4sNWCNN08jV
	rt8FSUs5oiRL+aCWkKYsD/1S6yjIOxo=
Date: Thu, 23 Jul 2026 19:32:00 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WnP3NqUZtZbK6qpmXn4nR86n/4NymHwsXkDtmWeZw10=;
	b=sdt/50cydds8v3DMxd2uH7ZtdEkILdbmxDkxAbvhnei5MJH/K0PpMQaT3L1tp1hphszyXP
	skoflTDLjhC78zAMiVSByQf44kTodEcyOnlmshvAfId5F0DvbHFomEI63gCi556y1uY5ob
	H/IBUM71PHZ8bhOvSKItfENMQMcklig=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 06/13] mm/slab: abstract slabobj_ext.objcg access
Message-ID: <amH7ndu2TAd4ixKU@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-6-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-6-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ihaz9xfftxz3psmpj7maqt8o4pou6b8g
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 96FDB140005
X-Rspam-User: 
X-HE-Tag: 1784806331-521032
X-HE-Meta: U2FsdGVkX1/2klsp031lyH5Xu9nC91yTwKAqPIVfu7Y0MhL+RNbD86/43M8GmNLQ+/giVww7FqxffCcdjATwjpr+E0OpK2U6OshX0VUMpOwZleZKFcyjp/MR7CTJkiGBwMKdEY3ANVKNwstT7DfgQfdNd8jQru5oFVY5ypg4ubDv3QB8oXA4H3eZTNGbBxWyWNBCa7ZfLmriIEysV2kd2WcNtT/EXxTm40fHQKs5twXrJ+G0oqJlqZHfKsPUrx2nbfVGpUzfupLOkoKM8kaqQQwpjV/TXgNKMWp9eUcwocl7XY3B+oVNDbP+pmsXnwSDswuJEj+zSmOjvGlsRYHtT7xY9ybbnjETm7OaE15bmfvxVenUZkZV4Upn27jGj59T2uuCcfXBGYALTIZMVj3kjYEqyq4BlSr1ZjoaWC+3W7wDSKJTSBvNnWbQvBCu6fy6LFJWW9hUhFUVX3u8qVLBMtVV4SIVSJCEmAlSf74QOoF4qrW/2dioR1OG8azW6KKhxRYq4SzNmMJTm946czUpXTtX/AcF7nGVJfqP+HM/TWlhY18KbDBTTvyWgEjkgycxxJ7/YZxisRqjMJ/Z52CdZX/oVJryn5wATv1yLZluoANr4la/joIUv728vW06beFzChTyWKPxctblqYA74PsufNfDBZFV5Lr/eQcy4QP1rBteLnPBofb9xY09UBM7Km+jFVo5qnYLMzOtCZz/mNfLP8o/gbTuIfVzO7ZaeyznL4KBodZW+XsZTTrVv8SiIRWa0CnUYs0y0Kmot/AGLu/Gk2h+f1ev47JGk4wyZXOaMTw6G637gR5xVdVmthXnhfVa3fWkjxJjx1GEpF67ivrZVP8FjsjiANDg82DlnLOPJLEp6AvIpS3pctPZv6I+pkzD+1sqVJTbbMJ7xrEry1MyggYd43QoDKsnTkHaDvE0cHsyujDcI+V8r2ZhVhFIB5532cpf97yIaLB3pTSmJCJ
 U2vuqS1r
 hNWjdoZvSz275lg/+MfD/tC+VVhbayzhQSd61O+fMxiPosm8ChPGu7+S4WuOnGAUEMg0s4oyrF1vO74ykLyDQwncQIMacLs8x9h8Vycqe6nT5BE8vrBrUmxOoUWpoxui8mj08AEFMh16WodhFcVwULbRMFjrty/x5e6FlvoJA4nlC7++46DiqMtSn/aNk0AvwdF8qgPyVxA5g6xT4Dd3haAzHZoKCzG3emu1z8D47AOxAQLVhOPLsjyeojtxWh+wLtioHjW9DwBFNxJhhEbS+Wkxw9NrqhYlHChNmcsCczUJm75z5Wvg9U+sYng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:20PM +0200, Vlastimil Babka (SUSE) wrote:
> In preparation for changes to the structure, abstract getting and
> setting the objcg field with slab_obj_ext_objcg() and
> slab_obj_ext_set_objcg().
> Rename the field to _objcg to make an unexpected direct access a compile
> error.
> 
> No functional change intended.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

