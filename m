Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38597CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 19:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EF1F6B0088; Thu,  4 Jun 2026 15:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F946B008A; Thu,  4 Jun 2026 15:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567706B008C; Thu,  4 Jun 2026 15:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 45DE26B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 15:12:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 109B9A0278
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:12:40 +0000 (UTC)
X-FDA: 84843176880.16.2C76F2F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0DBF9180004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:12:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l0J0D4oR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+oyJtAd3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l0J0D4oR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+oyJtAd3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780600358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVccA4ceReq1NsSUiW4BvISRJkHdxqfqmTVLliJp0pA=;
	b=4arTL9MzpTnLUG0lp13Iz4t2jgS70PJdXd9A9vS2AOHbYImzlRJg/xlihrW42vVYxjFTWF
	udVk2rIeX41kr/DPWoByz5JbBfXmlzF1JFZk1D9sbTjxM6k2FwsPpqhacArcA31ITJFw1H
	iIC0w+tauRPOqWRLiZVnmTxU94FQoI4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l0J0D4oR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+oyJtAd3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=l0J0D4oR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+oyJtAd3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780600358;
	b=5iOr0owJ1mPYrbgH4DiA3BjK6VttpebZMjRFSIzGiwHvKxhZwp+nLv+xbV8t0MRC4f11Ru
	Do/z+oOu8xst1xOUhP6Br1FkrhUWT6yOQFkZLjuCsddh35smreS2jQQDE3UDHncUE7iAV/
	msM+wJeAvK8k/usMIbHWyluOtk7NEWI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C1270683AB;
	Thu,  4 Jun 2026 19:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780600356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CVccA4ceReq1NsSUiW4BvISRJkHdxqfqmTVLliJp0pA=;
	b=l0J0D4oRlwzvwXiFyeQgd7lUB2NIqPON3UN9nyqyuKJRVUwcQ5y8Ex74IWYO8Oa9B5/ZoH
	FFwZpCO72xfZqgFKZurNNMPR1/rzPM9Q5EzVfxWXt3bXp3aKTfdn4k0Yoz222HhjD5ASIC
	liazCw6uqwUjJ5BSFXxkxAZNHpoz+zU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780600356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CVccA4ceReq1NsSUiW4BvISRJkHdxqfqmTVLliJp0pA=;
	b=+oyJtAd3Qb2ZMrrAhMaZyEyPWADlPH8EdOy8o/3C7B+euZY4GgIje0HDPQwu3yk10s5yml
	j1lRlfg68lTEhNAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780600356; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CVccA4ceReq1NsSUiW4BvISRJkHdxqfqmTVLliJp0pA=;
	b=l0J0D4oRlwzvwXiFyeQgd7lUB2NIqPON3UN9nyqyuKJRVUwcQ5y8Ex74IWYO8Oa9B5/ZoH
	FFwZpCO72xfZqgFKZurNNMPR1/rzPM9Q5EzVfxWXt3bXp3aKTfdn4k0Yoz222HhjD5ASIC
	liazCw6uqwUjJ5BSFXxkxAZNHpoz+zU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780600356;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CVccA4ceReq1NsSUiW4BvISRJkHdxqfqmTVLliJp0pA=;
	b=+oyJtAd3Qb2ZMrrAhMaZyEyPWADlPH8EdOy8o/3C7B+euZY4GgIje0HDPQwu3yk10s5yml
	j1lRlfg68lTEhNAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 18C8F779A8;
	Thu,  4 Jun 2026 19:12:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id drW3ASPOIWpQfgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 04 Jun 2026 19:12:35 +0000
Date: Thu, 4 Jun 2026 20:12:25 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Harry Yoo <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, linux-hardening@vger.kernel.org, linux-mm@kvack.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH 1/2] mm/slab: add a node-track-caller variant for kmem
 buckets allocation
Message-ID: <aiHODMbciRELKGbR@pedro-suse>
References: <20260602183122.747759-1-pfalcato@suse.de>
 <20260602183122.747759-2-pfalcato@suse.de>
 <ed9e834d-e3a0-40c2-9407-252f7ac7f00b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed9e834d-e3a0-40c2-9407-252f7ac7f00b@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 4ahb3r9upg6ddh8hytjz4td94oqdc41s
X-Rspamd-Queue-Id: 0DBF9180004
X-HE-Tag: 1780600357-831952
X-HE-Meta: U2FsdGVkX1/9qNj/O3lzvO6m43pTiKBNC6eu+zhjXqigNDp3LT4wDoUFvXwNnvsZnPfr0a6jLu4f8J0hX7j5CoTmn6OsQKTz32aK537BrP06F5bSh4UPbpPAqsN9570gxgcZwl3BNGc/CdzAzns69fA+ldB5uYkj82Jed05N473Q7wWTLXm85zu3/uf043ig6A4OP9q6oN0PUhH4gw4KnIb2WHB0yXCwza3jkCWKZSMuZZS8gpiiQlQEcnQQ7/eFLpc+HhMXme5wqcOduL47ZK+U4DHx8s5+XEaRpEgOsLeSoAF2+AArG4+Map8d0QtAzNfVgqAGSW5l4emzk7vT2qNsCIu0FoimGsi3wLe59HrqbDxRercNRTkr5YLmw/4CU4KSlpdWhXyhxttBdBhx1QfHXcOGAdotMSKO2Qr+n1wfBzwJ3FduXM0qr2Pv3ZgN7fuAYIY5OMbaZZBJs5Fmwvpeb6Ra/2tJ92AR5sN5QL/HQ8TD3lnakCzUCitc+N4IY/jtf+JxADc9OWNzulCrVpENGZUA+W5VhYKOitvMQ3Q1E1ELdJN4NWvXOkgZWn9An3GC/+Ot+E4NPuA42iY/avirE1C5onMOx4Y1A0M9XUYoCyhPxsjxOnfs0E2F1Esc1eYZ8luBCz5BawcsLDdNlELHcgHzblzURVgpasTq0MwZLmWV2aN3SgO8JVPe1JaYrGfEF+YJBl7N+zCdt2R+c5rgHjLZ05TtIIo7bc44yS65mhpuku7/+D2LMT+wzEtISSblV7VCuITaW98jJABI/DTpHAcVJdyob9l/fLwM58hrtquRCk0kV+rfpMUCVGgZHU6iK/XTy+hQXA+kaAGn9TyH4xZ/3ivg4RAllJqMaDi6vo01vqSc4ZHkFFoSW1h/F/sX4OQpVr+DxtETNdUO5kiCSdD3yZkMD8ztdyWqnAb35hr2NoSG46MdNEyJ+iDtsT00PpVr5chXYndZESe
 0Q9B6Csx
 GUMS3tMU3tCdBrRlnzY1p2DdgX7gFXtCNjFq9RNDUsE5tTUjY/w7eb0XhQsF5ROXy2is6fQZ39A/PPocKYFfi85Vq33jDpYZagPAArwRKu36+Cg4NbF/8wCbNfpoI28ovisWei9qA6rzZbujqK09WEZUidbvtSzxQm4BnMnEp7ytTv/N1gwE7Ym7sUoeZbwM9/KHBZ9eB9uorcTQeddoEd5mLcHlbAY8ufJRFhX0mmrnexFX3bxAQWrsdvTsiWSqg5RyrqDLxiew3lf9wNVZDVKRCJrBbRXRcFatvIBSexevnEheGGdRCKg02N934lwSDGYQ8j0iVCGGUwpE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 02:19:30PM +0900, Harry Yoo wrote:
> 
> 
> On 6/3/26 3:31 AM, Pedro Falcato wrote:
> > This is required by users that want to use kmem buckets, but still
> > desire specifying the NUMA node.
> > 
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > ---
> 
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks for the review!

-- 
Pedro

