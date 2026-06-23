Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 900C4CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 00:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28A6C6B0093; Mon, 22 Jun 2026 20:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 262056B0095; Mon, 22 Jun 2026 20:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A1076B0096; Mon, 22 Jun 2026 20:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E5E956B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 20:18:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56DA3A0316
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:18:49 +0000 (UTC)
X-FDA: 84909266778.01.6241E75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1564A0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 00:18:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzkxjb8g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782173927;
	b=nycEAsxFFNmPFZGBrJcL1vU26GYTBKm8iIx1Pfzlrao05nq+yrX0euOpg5cCuy36BwJxe4
	ANptWtTcmYewQ7PavQ9Ip7ogJK55Q4c3JdlX2G2CZXT+P3PEIevUJtvpQb9P9n7E0XRZUg
	tuJeEC5aLLSyHLS6WWmbxbTjmEs7Y4U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782173927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bqkm7vO1HQAEaTJZatZzByS6cW5Og9eP4FfT+b0aJMo=;
	b=XOo2K82hrkPbjdmRiFC2OzXOfEaHoabw2OLpeMpFztsSj2o40xRJuoMpYZR3d6Rb9LNjTl
	hNgMyiQSyfdNMpYbPyN18s7ZFrqdcH5RJMmJ9e1x0x7EDInGQkFhjq2GwZvo3Ztn9togOm
	BSXnQHAz6T7dBfz2NK1TsAUVftPFfw8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzkxjb8g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1637C6001D;
	Tue, 23 Jun 2026 00:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C191F000E9;
	Tue, 23 Jun 2026 00:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782173926;
	bh=Bqkm7vO1HQAEaTJZatZzByS6cW5Og9eP4FfT+b0aJMo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lzkxjb8gTAUFi+dkHf+UzFnYTQdioFDW6caG+yF1SKfcdd3MPgXa6Afpy2xI/Faxp
	 +rmXkMJ4DOQJ8Kzqo4xU1Z9VxEmT8RVu568mcMtKDB5zFDwThCtAUZusKtLucv2Kzc
	 3LT7ANwqB/vTXnm6ONxdchyCFfi5pDnP4jYyyomO6c2mT8uBulnFCvKm0t5ENXD+K4
	 +LAw9TFTfJzopdu9aVb8Fw918A9g6Qqfde3u2yU//HrtbR6yBjDMGZJgRBcgn3NOWJ
	 I4rdU+QPO5xGbKcuA41ClXt2Q+HlD4Mq78jXjqkYbfwgS52kzCbRL4hG2anltdRrAW
	 fzweHkBaG+yfw==
Date: Tue, 23 Jun 2026 00:18:44 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/7] mm, swap: support zswap and zeroswap as vswap
 backends
Message-ID: <ajnQxMY0W3VGyAUE@google.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
 <20260612193738.2183968-3-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260612193738.2183968-3-nphamcs@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1564A0005
X-Rspam-User: 
X-Stat-Signature: 7twnj9dynp89xfxhsw3ep35tgdtqn3pz
X-HE-Tag: 1782173927-691265
X-HE-Meta: U2FsdGVkX1+4mLW3iRGFwEVSBjLp/eL8u9ETsUqEK+OTN99kQZHu07pkrTxgAKIZb/gCiVL6j0Ty2H6BggCgOvYMosLRPgEWK4/eEGvNsUu0AXZvcpomXkKAW7X9iwKod/DU8YO5k8boc3V8VPNhr+XNOVl5nbivU/EpQ+byGK6zfymOWCB/ZMhKHO27B1euwKq4vbdRv41aET6a4joH1qVkwrRIzb8iInhb4AZetVfn3jUnFAGeFQia3qoQh88unJSMaKkMhflMUYItrEDGRDckxM7ezYF1vxyK4PvqHdi8XSzuzMLacu3rIq9hGFbcAehEOIWXG702hpkcHqPfFM76jGJqVEhUvzeYoUAV/glAywpHSMCQ0koP0oZILWHKYtYcvR7oecb5/pbIm6FOD4cJ+DUslfzfKdOmPGy8ucbLUlnfvcX4x6MMUANiXWpaL+WjeKIPjJ+HJRaWoLdI15YY6yzDBFmvLUJYd3w3PK+r6AeOnDl+N7BH22uVLCnVeiVkDc2AwJafnuJFIc9inL6UObB54K1vUYGV5G23dgQO1czG9w005RYd34bQ7rjHFlW0FCtpQS+ZdvQjK0hYM8nyMWgeig99+7sNvHhI2kWFhvsvX0Dou/dMqKWr3fEDUzLo/cDWPkoOpXxFJIgpg5kL2zCqdasxlb4Ew4npkBBH8fvhZ3jg5VkAnhgINTzMfgDN4lb6Nar7FYNoZfXcinTCy7sTBc3M1Jgnobr8G5fKBJlK8KAL2//sX0h92Nr5WGcU982PHE7Ydym5o0e4rxSq6leA3HSXAmqQg53msjug1d8O+OavjWVye1PiTSylab6bXKMO1OXxWAxTEZtV3T7NsFidsMUypKaMqyyFgrQSPDh0oSpVx+2vnuM85HC9pD/TXw+VqP556rA1Ud6fVGHzkFhJlpNOk5Vr2GuBvAWDc9Evcfru4B0kIgzopgwiIlmGsCmtRy1mjfiNG87
 acMhgTUu
 oxLz29Jxh9XppVxtlk+nTSfzbEChHweJXdpky2Z1gmzaSFZ72DnWjcnXdF90hzKkJBSK8f811+uz2b/IcmbWncKbNT67+gDXAVarQeNjNq2cfsoex+65ZEa6z2/ci1UQU3zky4RQfLNZBMdYpsCfz8eG/YFJ7WLs2GHdNMSdMTaNUJT952jp4myH3MMTrSEwsqDDJ2z7WUAvsmmhl5Arw4tIB43bOa92xdPg3yMPLvV3yEF0dMZT27ZN6rEoZwVh/HTe2lpkTYLJMbDmKyt7vkeuWGSRFNByJTXi7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[..]  
> @@ -1623,16 +1642,14 @@ int zswap_load(struct folio *folio)
>  	if (entry->objcg)
>  		count_objcg_events(entry->objcg, ZSWPIN, 1);
>  
> -	/*
> -	 * We are reading into the swapcache, invalidate zswap entry.
> -	 * The swapcache is the authoritative owner of the page and
> -	 * its mappings, and the pressure that results from having two
> -	 * in-memory copies outweighs any benefits of caching the
> -	 * compression work.
> -	 */

Forgot to ask, is dropping this comment intentional?

>  	folio_mark_dirty(folio);
> -	xa_erase(tree, offset);
> -	zswap_entry_free(entry);
> +
> +	if (swap_is_vswap(si)) {
> +		folio_release_vswap_backing(folio);
> +	} else {
> +		xa_erase(swap_zswap_tree(swp), swp_offset(swp));
> +		zswap_entry_free(entry);
> +	}
>  
>  	folio_unlock(folio);
>  	return 0;
> -- 
> 2.53.0-Meta
> 

