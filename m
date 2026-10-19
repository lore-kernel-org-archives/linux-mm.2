Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9438A606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JYMDLAPI
Received: by kanga.kvack.org (Postfix)
	id A652A6B00F3; Mon, 19 Oct 2026 13:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16D66B00F5; Mon, 19 Oct 2026 13:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C6A6B00F6; Mon, 19 Oct 2026 13:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67F6C6B00F3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:58:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F0B51A05A6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:58:20 +0000 (UTC)
X-FDA: 85340135160.30.44C196E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B290B40009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:58:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYMDLAPI;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792432698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AO7xqUXlLM1TA2n8fcNeWS06aNBQVTSeH4oKun/bjtc=;
	b=SdXYFlPONrAKJ2C27DdNorz/samBHLWGLgLrrbxVySyqmIjK1vCT4sdeV6+a34gFv49D2C
	WwqJYAIPE/w+46pEtVB3ZA4wztYPFg6EVJkeNFMMJH2n3QfHlmRVkixTfUfMbv/diYOGz7
	xJo0WTlAtAYaEKjq/RS2VDJOL6nMpMc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792432698;
	b=syfDz4ACwHXfeUA2P2IaJwI4Ai/5qslClsXDJxQXU8lJdlu6CCuBLlrT4j6RRVy1E+l06g
	+jLM1y5/Hcyy4znyHGoEMEZJwFwaNjK1Pc0wYUidzzUEzVDKT2jFHIxYZ8LVRv3Dz7LLQl
	uks+alxGCTrMUCWZ7C2ymmviIAdRffQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JYMDLAPI;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09BD0600AA;
	Mon, 19 Oct 2026 17:58:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A551F000C4;
	Mon, 19 Oct 2026 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792432697;
	bh=AO7xqUXlLM1TA2n8fcNeWS06aNBQVTSeH4oKun/bjtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JYMDLAPIlnGDCSLBNWLAx73Dyjpl3FQ1FyElE4UAZCi0GlccwDiBVINdBVS3Bs5OY
	 F/6z6VGnNuxR94PeS40d0KDlddWiw/hiCFcxGuON3usR/zxnwpoQ8TdmjJJN4Q2QXu
	 HMoBSAbw+qFYO+eQhoRGGbPgDToer86yFVpeWaBJHBvA6CIFRa1+WSgPA4iTN6mayx
	 AsylWJ6DNUJcKiztzWcNL7Nbcp6g4QLG7yj5aUCqxovYzyvxfhjcHPq+Nmr+2Yvc93
	 af91GIxf+ZohcO+uyeLIaa7NHL9V7Txzzd34rWzNxEbGCwCyvgYrnzGZOeKS/GjXJ+
	 UeiVKqOzarHfA==
Date: Mon, 19 Oct 2026 18:58:15 +0100
From: Harry Yoo <harry@kernel.org>
To: Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3] mm/shrinker: allocate shrinker_info_unit from a
 dedicated kmem_cache
Message-ID: <atZZkIFH1wrX4w4w@thinkstation>
References: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-vstor-144715-shrinker_info_unit-kmem_cache-v3-1-0fb061e09bf4@virtuozzo.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B290B40009
X-Stat-Signature: d8bezkpxcpixn8go47gpcdgfw8q6ibgu
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792432698-596305
X-HE-Meta: U2FsdGVkX1+zaGYIt+Vj8ejm/5buycDH6r/CIXifdyn2cfB1y2sZnEb6AK9FRY6BSeh30F60OBsnOXXEokYfSpNA7NJ9PXyn82xeY9sipOSaZah7wrL1acdPWqKNK015tkKHS9Rik1+A37PYJrxDtMRKrEstyn9L9p7mF6og5U62Jk+GTzUAH4gJH85AQsPu1kaAgF1lMbLsgPGxGFl6nDfDvFysDxPjF1aY3apAVMbdodvIGDn+xse2jqfN6QmjIOn1N2Qf+Y2CS1kHjyjvmTtQu+OEsaisMkAQDWOe26FzVXG/VUHWJt/oTxlzvn99TjzPGV6n+qRw9ryZ4zq7hsnLSQ7dxhJEdeV2nKzIvz6bY8BTCfK52cNc09DCaN/ls98yeZjdcPk1cvLRK5VNokdpKzfgTgomlrCfTVF8rA5SWNwAA+czW2LLfM+4bJCAY0nxmb5TJHV/Pbc7U0v/s6qrMtZEMarSfJp0d9Glx1bdN+nXxxu7aVKjfITPnI2CqYoj+4ypW+t0uswbBMOxhpX99nzrZb/Gw9oj7KAQfk7kNwUgDQdDNnwxAyBTzQXrJKaOyI0X8NLSUUALwHJL66yrd/xc9NHVBsCSqYxF5xGfJLn4HLfgaFs3L1egxk8Jc4P5MBNu3UoqeR3+KFGrf1/lyRcjqs5m0Y5+kzjNn3Dr1Yuvcveii5pGBOL/FZ0WCsN1SSH7ZDve4fZT/yK57nwZmiX0xhSjvHPb+goKFBbxctw5ZZEvPLxv+M/2yBNPLffkdk5fvj5DUFRsJQaeQI+WicdqyBDJS2NUkdDzdrBx3dL6LtTFfuehX6K13q1vU79cgzWHxurtV+PF8XdKy/OiqNpvamNdcwjmrrAdkldl0VR9XZN0yBeGcUDFLMg17acntcVRDgcIO8zwIYHvTEPzmI0Tf29YEELCQYdx2IXxP9mTcoyvTR2JouUbSpTmlGJBIxqFfPt4sx2v8HK
 lhKpsOEV
 5JZvN7qewk2+ugcFlBBH5+L1lL6jZ+5giPllwzntQKYgWTFGC4deAh72siMPhXdqi+QoVRJ/YuZedsbB5YuKzZ/EQ/XbRA19sH5p7pXeb328assskjaJgoGiYrQLRT15M3M+WdNwMuK+j7z4RmN+CN95+dWwWTTJUZd0SPBEVp+T0vVz8b1eQpgdBsROxIKXito4TkBKeKy89ROkUhkCaD+/ERJTCbdy6JgdyeHUpgNuJ43uisuLgLhv0eIrTWdhkwizS8Jf+/xXFRJEvndfCPwuALbZeorDEloGGmdz5jah6gK+DFbhdz4lNJJh7jczYpHwuQOdw5fYE76VDBq8gUCKMiTJG7lfWs9iN+3J9GtmFz/SicstcGqGOls+yzT02xIdJYfN+4alyY/GiknLfaAtSEqLmJC6ugrilizwFxHlB6o2LzX1wUsY7xA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 06:11:44PM +0200, Konstantin Khorenko wrote:
> shrinker_info_unit holds BITS_PER_LONG atomic_long_t of deferred work
> plus a one-word bitmap, 520 bytes on 64-bit. kzalloc_node() takes it
> from kmalloc-1k, so almost half of every unit is padding.
> 
> Allocate the units from a cache of their own, sized to the unit. The
> cache is not cache-line aligned: the counters of a unit already share
> cache lines between shrinkers, and aligning the unit would only keep
> neighbouring units off each other's boundary line, at the cost of part
> of the saving.
> 
> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
> Assisted-by: LLM
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

