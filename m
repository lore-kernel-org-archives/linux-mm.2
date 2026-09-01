Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB771C624CE
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 01:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A30306B009B; Mon, 31 Aug 2026 21:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A077D6B009D; Mon, 31 Aug 2026 21:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6906B009E; Mon, 31 Aug 2026 21:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBA86B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:42:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC764A0338
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:42:55 +0000 (UTC)
X-FDA: 85163494710.20.D15741B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2BEC8180004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:42:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=madk7Afs;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788226974;
	b=QQPLcQvrVWQqJuSLfUQZj7CUsvrnhVfpZ//gwBu1esBON0XXftwsg1Pas80Q/0D456OKGb
	rsHeisnHlm5LGfJisGOOzxkuivc8caACpnFY+lnGLp8nrAU7DmaEuPd8d9DZVGEuAX152u
	a5RWXtUQGhhChvrrtMQaPKUBhOTt+i4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=madk7Afs;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788226974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUBTD6UGQgvrXlngZStTE/AMCacoF/WiZwM2SuL8ngU=;
	b=cfaHMtLPoMYRZ6qfDNAeOWmQgsU0gbYG2BUDO4OKAdFlMAxTxa4AdZ+z2BLA0m+OJgUpcu
	bHRsQ91KnsWp25CdsirqV6lwpVZ08F2J0X/RbjnRRRM+Z3bZzH62DZvfdEOgsRP9uR8Hr6
	qlSLXGAcPxZsTryhvSvhu+reUR62xjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B3F5601DE;
	Tue,  1 Sep 2026 01:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14391F000E9;
	Tue,  1 Sep 2026 01:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788226973;
	bh=qUBTD6UGQgvrXlngZStTE/AMCacoF/WiZwM2SuL8ngU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=madk7AfsI+5lWe4vCrsnibHe02et+DfFeK5OUWKvt5tq9pZVqO+QCF7YfkvnMzV0t
	 5CKPSb94mnMVCRsR2Ur1fFB+sPqZDX7jOsAiJJpmTnPEYoyFmBEg5r9sWSI0hES32A
	 zOdpK+xbnu7htr1F222URnJRt7AIpvlX9jYjalCU=
Date: Mon, 31 Aug 2026 18:42:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Ye Liu <ye.liu@linux.dev>, Ye Liu
 <liuye@kylinos.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under
 memory pressure
Message-Id: <20260831184252.15b978678820a94b106640ac@linux-foundation.org>
In-Reply-To: <apVPTt9Xw8kSgmTU@milan>
References: <20260828091753.299295-1-ye.liu@linux.dev>
	<20260828110503.e1eff32a9b7df9a8b2ddd4d6@linux-foundation.org>
	<bec5eaef-d084-467f-9bfd-43f7dedc1aa7@arm.com>
	<apVPTt9Xw8kSgmTU@milan>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BEC8180004
X-Stat-Signature: tmapni98ky4ciohe3ejkdb95zsgbutkz
X-Rspam-User: 
X-HE-Tag: 1788226974-721115
X-HE-Meta: U2FsdGVkX1+F97RP0Dvxk5mFyY1MbczZqTht92IGmLu6VVneEdF8K3fccq3YknSIEFWWWHGp7wEWG4PUodBDLlraMRih/+Di8fng43zKiM1B/dIOzUB62r1EXkXinhaYc1p8rMtbUvIAX67zNxTVpCJC0WIktMRB6cn3rAh11olOUr5qTrcWrg2TzM+AoXeiZa+0tnVbRnbvkb19fjXp4rHJwdom8ASqFLa9NHdgl+4wuKdpe6oq/OHlZfEJj5MzXtbeANdADBM7LESaAmE9xTFmoNmGGdOcbNwjTlFEtPN8C4PKNqSLG2MgdoBq0Z+/wEdsI4GpzxnJQoJPvAjJ0BCPnB3tjMswW9/YvXy4kNZJQBBhDWotDkY+tRACbNIc16HUAiB54zcdW18Ui0FYqN2+ZS31zOd2lpkfS5j+1A8iJyNLTfOXQ3+q7Tc+kd+a2xIC22V2D93sXg08KnGP49p1mDWqdJP3eZOX+1WGJhQZbIYA+aGshqH+X+mHf5gtGi9vK+oj831W/Ci2ztcvmq3NZbqSHpZnslsjEdUhhUqZa7GpdD4uRWcgScnp6NajVrjnROPhVKzCi+uK3Ooivinswl8DAxGhWPzr7YMzr7Aily8SAbDav/Jzgh07nNS2mVIwBbzZhJyFkxTGvJyvZ0U8Mn97y4FDZCGpORScIx78GXHav/ZkH9KiHTDAKYmEe3lVPdwR0cQsvH78G6eBLLcEas0hHUq84Kp+RQ1YNsPfwPedEaLqWIcHSY6289QRg+4QxihJLbUiDqRQw5YdpSuRIsDx1hNj+5OGVUCMdNUxsLuv49T0YlLhMUV0UBcqjaGtbos7/qMM2VY1TrpkyiVhFAs20I88PwPy1+BXyFH+jzLTFf90qeG5q5YUB8+KESTx/YC04Fvem/7X90yAek7/ucXbbT4J/hWGAvi4DtuEnnSGPXF6WFSVEgcCcSuBbNb3Ny0fPo/cfPAbx4D
 m4IlIqlP
 fJavS9h2wy8ht4PnQq+6pLNiqRCXR6YDvpa8pfsShrBwMdCbUjshSwOgcIE/jNtgEMVfPWW46b+tI7KuC/1c5YeBZOiOzFLaNTXotq9vgzrzLjkq076UqgYcKMn8/vVgNa3FR6e8iuaGh9xBhgbDfstwsVOYYS975w5lv8S5pgj62ZMto4PJiRiqc5I4QJ/I32r97Bsi4oYxUaF3ZiMrTMU1VukB1LEF8kVlEjOiAGNHZPKko9ZcmjloYxDUSWrglWg+EJRJ7vglv1aNpjisejCtJlhGMGdZiSnNLJuEyXLtRNMU3SW+Bkhc/c2nir04bvIHz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 11:54:22 +0200 Uladzislau Rezki <urezki@gmail.com> wrote:

> But, i think we can overt mutex_lock() into mutex_trylock() just only
> in the:
> 
> static unsigned long
> vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
> {
> 	struct vmap_node *vn;
> 
> 	guard(mutex)(&vmap_purge_lock);
> 	for_each_vmap_node(vn)
> 		decay_va_pool_node(vn, true);
> 
> 	return SHRINK_STOP;
> }

I *think* that means we can expect a v3.

Ho hum.  I guess I'll queue v2, under the assumption that my
assumptions are usually wrong.

