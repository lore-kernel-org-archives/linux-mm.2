Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989C1CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 12:46:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045CF6B0092; Thu, 11 Jun 2026 08:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D5D6B0096; Thu, 11 Jun 2026 08:46:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F256B0098; Thu, 11 Jun 2026 08:46:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1C5E6B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:46:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A1D6D8F747
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:46:49 +0000 (UTC)
X-FDA: 84867606138.22.DB6C76D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id B7E9716000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 12:46:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Szc1lnZ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X2XdxoRs;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Szc1lnZ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X2XdxoRs;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BzpYKtYTsb/gy7p/heSdZJScKkGH73POZ6a+foWyPDg=;
	b=4rkAkuXxDxzVzg2gvjGOLlkyh6DTJQavgcbwporj9raJUCJMMoiKka7yH0uTArfMgQtOK4
	w1LCXuu8jskCfs7dbwEAp12xp2weFPWbRLlSPH+H19cSANTDSbmZaZHnB/HZh9a/CZFlYV
	jH6qXNn6wnV1q2YteVm9HEaNDAaFh7U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182007;
	b=LhhHSdFiiFZqFq31LOBdhYIorNPO/VIjfpxK+SouhYicCN+Y4PF9sniwO1Xz0RZWSphEr8
	PhHKFFUd0SdVVZicsxK+HbL129KZ9unR1ZhW/usB3MVM568umXXRD4z9lK55HlRh2IWmcl
	H0sDqk+QS6Vzhsh6sSG1TOD7mzFRGRs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Szc1lnZ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X2XdxoRs;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Szc1lnZ4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=X2XdxoRs;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 532386AEFC;
	Thu, 11 Jun 2026 12:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781182006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BzpYKtYTsb/gy7p/heSdZJScKkGH73POZ6a+foWyPDg=;
	b=Szc1lnZ4SQUwGPUKFxZyZJTGKDopj3R9crYXAQ6sKzeeT8VLXz8e2JUzAhEiCU26xCjbw+
	qzJ25jY+tTl+/mvE32QF48RNv1Gfkq1vLSB52BMp2RBsX9gjXT0lAhahGs1uD9Wcr3rQkE
	Wz+RUAwDHrxOuF4BxY2nqC+YvbEkK6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781182006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BzpYKtYTsb/gy7p/heSdZJScKkGH73POZ6a+foWyPDg=;
	b=X2XdxoRs/JYyDeXVoPNav8S8Oh92s0IHIC2KyyK1wQS6a1EBUJi06fZkywP2dXQ2PNkDIc
	ErxyAys9qbFLw+DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781182006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BzpYKtYTsb/gy7p/heSdZJScKkGH73POZ6a+foWyPDg=;
	b=Szc1lnZ4SQUwGPUKFxZyZJTGKDopj3R9crYXAQ6sKzeeT8VLXz8e2JUzAhEiCU26xCjbw+
	qzJ25jY+tTl+/mvE32QF48RNv1Gfkq1vLSB52BMp2RBsX9gjXT0lAhahGs1uD9Wcr3rQkE
	Wz+RUAwDHrxOuF4BxY2nqC+YvbEkK6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781182006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=BzpYKtYTsb/gy7p/heSdZJScKkGH73POZ6a+foWyPDg=;
	b=X2XdxoRs/JYyDeXVoPNav8S8Oh92s0IHIC2KyyK1wQS6a1EBUJi06fZkywP2dXQ2PNkDIc
	ErxyAys9qbFLw+DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 032A0779A7;
	Thu, 11 Jun 2026 12:46:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7Db6ODSuKmpaagAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 11 Jun 2026 12:46:44 +0000
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
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH net-next v2 0/2] net: isolate SKB data area allocations
Date: Thu, 11 Jun 2026 13:46:40 +0100
Message-ID: <20260611124642.345400-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B7E9716000B
X-Rspam-User: 
X-Stat-Signature: kj3ixp5tt1dr9wh55jt89dnfe3eyemid
X-Rspamd-Server: rspam08
X-HE-Tag: 1781182007-667373
X-HE-Meta: U2FsdGVkX1++Qa1hHpRwoQCF1loWGwQSotoUUiQ5UcaZPlJjfnxU9MLBMp0HLhSXWrDTWY4tSrJkgUbgvGomokym5pCSgwxjPrx8th7W5J0PY8pY8BZ2jQyKi6yrsktsmWYNj8rqRgCxHapZyhU1N2YzjZ18ROLjEgDPGphsLy9p4Npy4mSc2sEuO0i+O+XKP8RxRK4ZKfqRzmKKiJegJGGoKPz6d8h0MsfFLGYypzN+fiWBKZJEqztjpCIUi4i/G5NmMCpby8JafkG0d5+Lb60wOZNuwCR2sreZ5C+0R5qiWiGiD+2c9/W6alwzu2zIIFpfdZWGIPDF4kaqTgKMDjVRnCEK9TUbPUMCCfEadxffWB3ye/le6ujI7fiK2RMu1vFckbgCDV25mBGBug+7kUy7tgt4nkix2rdpIQnPUvTEo9yE3Ymd2W7BUSqMQ2YiJPXe1opKXt8TuoJ28LtNwXxzxY4r3iCgIRSdF8Ef5Djgn99PxdRToqyoRnsQVGTcqpRacmx3V24svSY81QZYJS4E37RO/gnzKszJhvG5ZwnQO6zlc0SSrX5ERTcaFWVLuCuG+wMMxoRK+jt5Msm3jn0eL1hU0+Oj7nOG2XnrEZ/UEih0KZ+pCsbb+tokNA3USi1b4fF5rayZVcdCvwPoHgRHcI1dFWf1a0kteriGjzH7+5k8t8LGqm15H2vJHciXY8Xiz8QgAbyPvPSde4jgKmmIVIzlHdKqfAQLVDIalyh3aFlUzmutYc9DgSjYeLk48pbqV1//WgD2Q9iGXH++A4i/7mH3PTV/hcKFtPn+TL7fG/zkiu4QRBHJzNKQ09fI9bWXUMnNW1bIUA6tzMJ4sLMTai0LBqk/jAG/lCv+sYRxUXIGHMmxHuUKGSr1Cz3nMrcRpiKyYs5xlTyD5zNEKT8o58kmv88qz+G/3xY8/m9Pbk4PVLo3DbY9RnXIaUBMQr7t0EGnxC1bSWJ2H+B
 QgosM15z
 53ZyAmCMy505q3HJV61snJpxTbg1KQ9aC5mP9BF5qI+nvGgnru/iodGvxk/2U7cTMeKVaYF1cP1pGYO+jf17VyiJs8hoLwHtpY8Jdj6WAltVG5q19jz3GAsjPZcXmV2dHIanm7KdrQ2qqd6NOSv0yuSAK93SVYKu78ks3Jb16eyZgKmU0Hpv1yNgxRl20qOd8RCAYXctb81RG1xKiIq1Pu5HOzyGXABvEcU+eDYmYJ1NvHIOoAGv2I0FFZC+dzH0bLGoY9U11/2eNwug=
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

v2:
 - Pick up A-b, R-b tags (thanks everyone!)
 - Cover kmalloc_pfmemalloc as well (Harry)

Pedro Falcato (2):
  mm/slab: add a node-track-caller variant for kmem buckets allocation
  net: skb: isolate skb data area allocations into a separate bucket

 include/linux/slab.h | 7 +++++--
 net/core/skbuff.c    | 8 ++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

-- 
2.54.0


