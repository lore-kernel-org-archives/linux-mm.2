Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F08BFC79F8B
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 23:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4FB86B0088; Fri,  4 Sep 2026 19:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF836B008A; Fri,  4 Sep 2026 19:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9166E6B008C; Fri,  4 Sep 2026 19:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1F36B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 19:06:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E12D3160251
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:06:56 +0000 (UTC)
X-FDA: 85177616832.17.F8C94F2
Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1228C0003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 23:06:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aQtFCJWv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788563215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NdS+z8hce6z1IyKuB4KQFIGdBs2uRzyNfx6yORfQB5c=;
	b=K4bnfO4Y+tgpGfw4BdmVFUIwdPAeGPpEtOw1bxGzwjkvSpylgdKO5jI4nKnrC1xvj9eDXI
	sNooVjluY2pbpaa8xie9fvV1NqbMcMLo46yW7MkH+PO6zXkEyJNWzW9Ia0Mr5KlTtiZQ++
	3Jl11U1p7qseLiuKPF1LBC9m76zwh3w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aQtFCJWv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788563215;
	b=xAGxwLKnfP1jhjoJPhCcArwj9AfW+iKMKoGBkSHFXGSBMJ1Rnd75TqoGY17xYCkLy59HN5
	jVpqE3kI2wktFsDbG/qEwVMqFumEKzlbjjguX8LJ5yGqJ+05BK8OO6ZliFyU10Q8XQNwSZ
	fpZo1PPwdO2hpjE35u4WBxtBEwSWNrM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZUM2AKTRyDOrNDBMw/PpojLw84g0UsyJaEenIna+gsA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788563213; v=1; x=1789168013;
 b=aQtFCJWvXr+WjgsZqHRE9+lFClfwQDNjBmh8txhqKugdL7x3P7/+DWpnER31CD5nmGIps5aA
 9CYS1sicQQoX4XxMSAQMSw81lmfkfjwcplJYh8qgt8FSTeuh8YnXK24aQ0EkGLofCD6ndVeqIaH
 yHIpsggT7GJVHFG4DGEBun5s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 553d8ee376d76e0c;
	Fri, 04 Sep 2026 23:06:53 +0000
X-Mizu-Trace-ID: 553d8ee376d76e0c
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 16:06:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	dev@lankhorst.se, mripard@kernel.org, nat@pixelcluster.dev, tj@kernel.org, 
	mkoutny@suse.com, osalvador@suse.de, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kernel-team@meta.com
Subject: Re: [PATCH v5 1/7] mm/memcontrol: flatten try_charge_memcg control
 flow
Message-ID: <aptO87TL7KDvcX3D@linux.dev>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-2-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-2-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 9cc4z4m9h4yj6npii3sn961ghq85jr95
X-Rspamd-Queue-Id: D1228C0003
X-HE-Tag: 1788563214-790085
X-HE-Meta: U2FsdGVkX19wCBjeXN+U8lx4YQPhLAmJVl8u5ARcO01yc8RZKOVchz95x1FxhNaMs9flRe4jXJyxfnsDpaQdZtr+RGqnjT0OPFpvhzLVJPNeZLweuWEba+Dmu1Z8PFW8kHTdLkd368XDFYRMnXQsr1La1C+7N+RIHgiRNPOSET6dthA4cRMI/If80Vs2l5Y5S2H7xulVQoktk1WVUgIxKZi1/CXr4SDdX+apIbUylrFg7iJp6+QrOKnmpOdod+RPiafwAaMXZPu4tmoIW05DnGLGqHamdjDvN8UvQjOosycSWsS/LvpK22FLMPszg3J0lasjnsJXEVthDB3tUpDot5WYq9d/yKvqk/8Qx7MrYnxAcs5sNLDaNVlET0QXXAcdAvpDpRGSuQ8nx1qhkJAZ6UliZDHlQD+w93lXyQynKy+ONuc7fmphrHvLaA530eO96OlY0CsfHC5poZ91uubsyp6f4GIjvb31m12nft4RVqLjmk47rB7TVLCWlOMFiuPKabHKOM8l/i5vmzdSEpzFVz8FHAJkDABmGjT/5M87DmEa68zsKwd5QIrSPrK/bCMgtxiAM3KtSfdR5BTTBzex6MBhaG0r+euinlO7OuAiFmDbV4W/c3DFPf8urORZbHGGDxYmKQWcHQgTeR7qXQIZnVGK6ljqdZSUs//Uyh+JTsX0PI0WJlyBWS/W2kKSY9bCNd08vFeW0YmR6OTdtIqfrr4yDUM58oBaKKDFNhKfZQ+oypAcIiFvvTCZTsr+WTQK8G0Y4mn/YNQFMuHD/JcStITaXsnKvZFzwNxvNVBaxg0GxW3d++xzt7liakbQCmKXuQlrjaoJHqypISv49vqWL4FpHm5FKxJK84D7QyIHpMF/jVHwxY/++LTXwY0ClE5uYJL6jZ1dHjUdcRPzqsBk2QCX7gBNgC+//TKQ1lS9HV21GVOZvOsqrTRcnlmaSg6ePVEGr9EZVbN3iZQ/m7l
 xZCQZ/6U
 wCAu535abuL7/HCtJ7n2UW0UDbjmOcvzf0CftgR2svgPVDoHEzWhM4MZKClS6wCRnPq9UEsk88q7uSEYGwBRqZxXLh9EH7nJHkBJ0zOgiGJyedRsS1EP8KdAhvE0bArLMJEBDvBl9ekkiNmc7FZuMKsOufcUbh4VH/FvcofWMo6tNHQOzPt5C8Vl4jItIA6SkjlQRZmuYokqYoKBqNz+tQuWCJr9Urm0WUS5OL8EQDuCkO/CzXDnvZKHCGZL8VsSQLLzHQifiI0xmB2j4xpu2d8eEYB9oT5WGon1uNIEP0JusAjtqSNNWcDxFbiFnDroHpG2cmYe+FNGQjKOn4RQVx36zURx7Cqtj5wi5SQYYGI8ZM1c7FsVHR4Y2GPZGXISkI4aRm/Io6KBUkQYPJJrGJGyVsRkPV6P1yqcA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 09:37:45AM -0700, Joshua Hahn wrote:
> Refactor try_charge_memcg by flattening the nested memsw/memory
> page_counter operations to separate the logic between the two.
> 
> When page_counter_try_charge is made stock-aware, this flattening makes
> the control flow easier to follow since each page counter now has its
> own success/failure paths.
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

