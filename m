Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54750C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F3C6B00A5; Wed,  2 Sep 2026 11:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618146B00A6; Wed,  2 Sep 2026 11:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554226B00A9; Wed,  2 Sep 2026 11:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 354ED6B00A5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:36:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B55431401D7
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:36:38 +0000 (UTC)
X-FDA: 85169224476.16.1833F3B
Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	by imf21.hostedemail.com (Postfix) with ESMTP id ADA851C0010
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:36:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oc+mui4m;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363397;
	b=JygErscg8jZTbs8C/46wEVxoczwn54V0yncjabEGpdHUlFYAwXVbEfJWkQK9UcT8FXT6gG
	8hP1+jXnvqL6kekWiXvvD8O4rWRv4kdV6s24LbOeH8sjZpejpS8Zvk4DA7CIlk7NRf++od
	67c0vCn/AL8vr2tvbQXcQvSfy2NjI5g=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oc+mui4m;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nItDDQQb1pJXA5S0qu0tT/5aO61SUP4/19EPQJ9/hvg=;
	b=KX6D4Sb4mpYNzduGOAlPPvOLgrEbdxRT/p6LSaPrVeVRw7f/cXr5FI+d91qy31PZZlrzvZ
	HkeninG4qmZpwGkYSYzE53+o+6RZgrOHAq4wK7wlYt+pMrl2zm82da+Yy7JlaItXd1ZhNX
	kyqhaEoNMOypSyXfBby+G+J63Wph+DY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nQsYSlZTDghUio3blhbx1zI+jv+vMKfhKPaFPZydeaw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363395; v=1; x=1788968195;
 b=oc+mui4mfm5rkivU1QIe2HncQpjw+MEoitTI9PcMQigNEVtPvlvaXTCZbyyw54KEovPfWuYr
 FMDVbSteUoEMvG6UyNNT9oZ0023l36gQ0Epc/YKy4GNGpHBUuwoIHtX5Cou73RvtqEADC0Z3sC+
 bmevzRE8s1I8UoJK1O4hDGvo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0dc618aa284fdb5a;
	Wed, 02 Sep 2026 15:36:35 +0000
X-Mizu-Trace-ID: 0dc618aa284fdb5a
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:36:30 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: replace PF_KSWAPD flag with kthread_func() check
Message-ID: <aphCZEkORT4GFkle@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-4-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADA851C0010
X-Stat-Signature: otu5empb4irxnn5nbw3wf3o3q4rjc1om
X-Rspam-User: 
X-HE-Tag: 1788363396-66200
X-HE-Meta: U2FsdGVkX1/4/cbIUP7vjH3p9PGa2DC9UxEN8Xa9UHDk/1HEo+0/KOmF9jipEf4a//Tr3G2Zt4/P2zYdaLYYfOk4I2tdVv4Mo17YscwfIODBdBEnHz+VN5OQIp1JSH2aa0JYHt6l1MhvVcTDfrXMnCuOKP+IdC0LvtJ+16+3ikVKKZxSzJQrg57hnHH9LAHo86fBeqYjSrRIKAdWGcKglajobYNtPTR8KdQWspIFLKCMJNOM8Sj3V7RaVizl0m66+qxVy5K7rFglkEN7i0a6yYV6uGz9govP5W1AZXxepELsEk+iMKwIP8g/3lM6XtYGQF85FLlvNkW1MXMlBevK5lTOGYuj0ovABlhH0NfcbyMsdEgqpKDQM1jbP1iJ9oPUgJp4penRxj3a4E1iE1yEeBIKSA2LHIIf9tCYKwqunobip2pnl85VcqwuzgcCiJLWsi2PqOG/koE6gDlHfGUqLU0EeI868f+O4oLw7+azt1/mOxLjJhSiijPPxeUYx+8r41czVrhctkl8OSbN0yTDgtJ5/VwcODj5W359bsF2ppRgCDDWrUE/v7QVRvRC5CvX2uSzy6jT2uPS7hfpFAlecgcf/Fp+Ga41yyERw+k0+LS87Ti9k5QdKd6q1lEe43/xSjO5zmYrYSDdZj1GaHDjdMl2OeiDJZAqap2JrmmGNrqnng8Xplb2ZMNlAkV120dIJhhk9XOCuAfxNSY3BBPrJchL9wxnL9xqTc6R1tATu536Aslj+OfkFmGtq8R8y3zWLzbffaDMu86ye2kJWX0E4qlShXDAgBzQtmVEoyp8cJjUZ0pEbqgCuRVXXc3oWR9mvsuZmKNBWxEZh5H6Pj3iScJAuZN4dvci+9NqMzCs8kKkou+zR7ewLHj5iwR/EWL0zoxRYJMR+uJCMzA48/bkEgG64YuQqUqUR444UuzwI1THGOI08d73q9L3+34J4DJlcLC5HqrXdqUWA34pYpq
 WVz2Zgn3
 yVoUCldGf0fjmg/2ShP/EwNxMY0Yfv7yFmUjxKTsW93E4io9K8bJ/X1dLTpTafdxvTjp0paD2kCh+FZ3lxsOd2odKO/2HuYl3MzNTlBnvsRxX4vlTPkEz0QhSNzdPLO43SnVoERFrYxF+Y/o9gJwXNjnkY/yPtBwHq9OkaPfuM+b7G4IuEtJ9PVoB7IliK5W5XrvC/ZWBN6rsfwQ56U6O1DOc0muWaPaEb09gzTBqdlAndzwyPV7wYJli7CXmif8SI9huqprVmxGDhp9RqNCF4SuL9WN+QwUIu0288emYFzkD6BKoH2ue87PKea24D/iTfANv6rlTJekP2/paBwzK+bCiIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:16:52PM +0800, Kefeng Wang wrote:
> The preceding commits removed the last consumer that propagated
> PF_KSWAPD beyond kswapd itself (XFS btree split worker inheritance).
> The only remaining setter of PF_KSWAPD is kswapd(), and every
> current_is_kswapd() caller only needs to check whether the current
> task *is* the kswapd thread, not whether it inherited the flag.
> 
> Replace the flag-based test with kthread_func(current) == kswapd,
> freeing the 0x00020000 PF flag bit.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

