Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42961CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 18:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E9C6B0088; Tue,  2 Jun 2026 14:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3668F6B008A; Tue,  2 Jun 2026 14:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27C136B008C; Tue,  2 Jun 2026 14:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 187296B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:31:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 761A11C113E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:31:44 +0000 (UTC)
X-FDA: 84835816128.20.3038BB6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8F307A0016
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:31:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1FU9Fyow;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eskRAaZ2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1FU9Fyow;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eskRAaZ2;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780425102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dVvmWIQsbYCW4qeWXvktTCWvRA7yElcuono/iggMNmw=;
	b=OYKp0dERmp06i4uePGQrWTM1OQcEa7q3Vts0uyBfNbQibMhcSMdB6SFNjSRIEXnbTFEwrH
	4iSOlt8duowpXCc8zss5ZftIEOqL4jr1A4F3XCN7qrPMGWiQEgMs0PKxSzsGI7JpdG9+6q
	5SP53r8bu2QmMp9Mub3KhggNW+nh8KY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1FU9Fyow;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eskRAaZ2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1FU9Fyow;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=eskRAaZ2;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780425102;
	b=SgThUZZ+4YUGTttdMeBxjenR8k1UN7fT0WO1Bzox2XvKJWQ9csrdnV04okXDJPlqwL3yyR
	TN4J25rY+TvP2lKvHI392azZo1CtzAUhj0/yA5bstVPiAUBTunsSw+paGT7TEi3ANow+G6
	3yDfuyuSGsszd93mWCu/ZPvPIsp6cf8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 58A1D6AF08;
	Tue,  2 Jun 2026 18:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780425101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=dVvmWIQsbYCW4qeWXvktTCWvRA7yElcuono/iggMNmw=;
	b=1FU9FyowV+cggrwzjroEuXqlmkeP4q4qYMFJEDhQEOwuxe8r/DLeWnkpnt1msN5EArfHHI
	c/cxAMoMF7s38+3qe7eJfwbips7Z8REt313jMuGHQoKMuqMfMEwZ9Wch9tKEPseTaf7/LA
	EysgQ23J9T3HL2i22cSSCUNnFMssEJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780425101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=dVvmWIQsbYCW4qeWXvktTCWvRA7yElcuono/iggMNmw=;
	b=eskRAaZ2tu02jflI/8FBuZuunrCjZGM0TAO8XhauiG5Rr5z0v2Y8tWgCNXTGpNep0Yg+Lv
	T9ZVglW2dfgUCJCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780425101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=dVvmWIQsbYCW4qeWXvktTCWvRA7yElcuono/iggMNmw=;
	b=1FU9FyowV+cggrwzjroEuXqlmkeP4q4qYMFJEDhQEOwuxe8r/DLeWnkpnt1msN5EArfHHI
	c/cxAMoMF7s38+3qe7eJfwbips7Z8REt313jMuGHQoKMuqMfMEwZ9Wch9tKEPseTaf7/LA
	EysgQ23J9T3HL2i22cSSCUNnFMssEJQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780425101;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=dVvmWIQsbYCW4qeWXvktTCWvRA7yElcuono/iggMNmw=;
	b=eskRAaZ2tu02jflI/8FBuZuunrCjZGM0TAO8XhauiG5Rr5z0v2Y8tWgCNXTGpNep0Yg+Lv
	T9ZVglW2dfgUCJCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1985779A7;
	Tue,  2 Jun 2026 18:31:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1X5bN4shH2owXQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 18:31:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH 0/2] net: isolate SKB data area allocations
Date: Tue,  2 Jun 2026 19:31:20 +0100
Message-ID: <20260602183122.747759-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F307A0016
X-Stat-Signature: 9txti3gm87zps894cid5pa14s1etx9a9
X-Rspam-User: 
X-HE-Tag: 1780425102-577004
X-HE-Meta: U2FsdGVkX193kWZXkNN+7C03NOThJBta92lZAUPZmFvTomfhkbaNc3XkytTdltyVcdjrdNYLtGFQL0ZN5xn4xwvslxCEJHuG356MFUjUt65CjolhkJI/9fj844zol6TKBdW/J7I+k5RoD88dSa5Yco36q4ijHmwKcQZQM5YyZG7Os9ZCqX9vBT4fivm6+4HfwXtygVfTrhq4D0hlRI6M65mXIyFpjc4H1V4slbr12tS6a/g+DeDS9aYOGWzYI5slL90VBnYfeDVV1WE96VA2rzTNXxrRU42IG+Xu/opz6wndBDu84/fp9i5i2MIH7QZq/a8OTpufjl144WRz14lIVV6it6XSzh5HUb+ln216WRIUhUhrNJX46m9SOAHD2e0CRrF6QQr/mbVWAYJEgNVH+Dxoxve9XWkzAnu+pKrtynw555nwik3h5XZ3TZ8eWblRxfJTuoB9+AgCaOIn3ZF5cencj7S7auSMVLd3oPvvl+7MDFTWRl1JGEeliEy5T6SwRQghaFEBM4rJfFJ9OMELRv4J8+XrqEMvSg9xJc20ZQm/66PvPtyKka+E/La8jWhxGMoeyv3bTHkzb7UJcosyQsE3ppBfDX3A6pCnlja43qqV8RswAyfBkV7WFjyED+Tq+AtU+fRg9hMEsLDCGmdp2yvTXzK09xBPaE2gaU2xOtJZSnZGCG7GIXzzd1ACLLrhhRkI1N1e9CdfEbIdn/c9gurWCIGVZhALPoldQ2TRql3/kbaBo/7ry3cJ1+mAuiCuzBfR/KyqTnQgPcTf/PQsHJwq3n7ugWxvSzaL29oZn0rJJYRWHwC3+rF8IzTf1tuBahMSaq65VwF/VQX/IAIubBCSMEx2di4agbU88Dj2PnZeYcfcGgquLXGh+EcZNrx5AtsBxPGXdJTD7kZmlJxaAAyFXYJItRHJMUybanuMVP2/fJbkoO1DPGWYvgdpx7uXYJHSJTq4NZYfs/l4hgb
 GOyhp0GQ
 4tOAK1g3qy+51UUxFUf1yxC/Np+8y4gVZCRv8Gk0l1qHuf4cKRUp8lZnrFXZkmVGfUJEcLUA5sa+ZLaJxrNc7qp6nFOaQxNNSmTCRry7szNFt9ZGi608mRmab6T6I6C/s1wAJlqbTTl3pZgnoN825nHoD7eTan3Z8HBqL2F6gpvI1Cv2lK/jArHCe4+GV/4tzN4S0HKnk/L20/XPQtFjsnYi5bohJcAjOR4l7HZpRD1eY0G9lbwyHnTPqUP9BkF9n4tlBWXTe9v9wDNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a rather simple series that attempts to address a possible
exploitation avenue - the allocation of skbs around the network stack, which
frequently get user-controlled contents. Found while doing some amateur
exploitation analysis for some other issue, elsewhere.

Patch 0 is a precursor patch that adds a slab allocation helper, patch 1
does the actual bucketing.
I don't know what tree should pick this up, so I just based this on linux-next.

Pedro Falcato (2):
  mm/slab: add a node-track-caller variant for kmem buckets allocation
  net: skb: isolate skb data area allocations into a separate bucket

 include/linux/slab.h | 7 +++++--
 net/core/skbuff.c    | 5 ++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.54.0


