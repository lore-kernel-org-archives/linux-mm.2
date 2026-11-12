Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D70A8606A337
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W/9XjxEZ
Received: by kanga.kvack.org (Postfix)
	id EEC896B05C3; Thu, 12 Nov 2026 07:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC43D6B05C4; Thu, 12 Nov 2026 07:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03836B05C5; Thu, 12 Nov 2026 07:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF95C6B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:58:19 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4D39F14059C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:58:19 +0000 (UTC)
X-FDA: 85426470318.12.568E790
Received: from mta0.migadu.com (out-240.mta0.migadu.com [91.218.175.240])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10504A0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:58:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W/9XjxEZ";
	spf=pass (imf25.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DGPXITXdeh70KPetjF6F96KspBG9wr+UCHeX9/qigkk=;
	b=pc7voa5jb/MsJwBtIFiNSmeZYkaE1XznlpC2kElnwmeUz++Pqnkp1M+j+pPpxYfoIytpQQ
	8yfLYvcy0RALeDm3r+b3C8Q/+i2+r+u7Yz8bf1/IZsFzD9/OSqbLT5mIMWSEhNbCwEinA8
	eLZynJ1W6rvxNTIoMDAUyxBZptIhrqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488297;
	b=Lk3vRMhagA38Oh8l+6VLKSvZgU6c+ZGOjRwwFtIC8YakCuHz9tgFtFhXQxgb6Cfr64eBsW
	ibs3HFUR4Bjg8AayWaVuKUoe8pWmXxhjrzE+13Dv/IEupy+c3VmzFQnq/SKuZM1u9tpl07
	rlGajpPwCNCbYIMZG2A7xz+UhkEu6tM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="W/9XjxEZ";
	spf=pass (imf25.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.240 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MRWB/iNhy2/F1l9+rCKRhIaHK6gdy+Rx8uuqx60BjtM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794488295; v=1; x=1795093095;
 b=W/9XjxEZXlEz6vu7Qr2m59K+huemuJJih1F0Fnz2mj3PldFiX8SO4Bl8XlT1wESZwGxVZP1Y
 HhCSDx9nJu5eHQX4pwlyb462ekV2q7LaZGgaCbWlw1rVpmb64/FYi0wJvn/VO/lxAzo1bldle6S
 LP7DdQZRII3Bmf8aklrinx6s=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 5344362e3ada360d;
	Thu, 12 Nov 2026 12:58:14 +0000
X-Mizu-Trace-ID: 5344362e3ada360d
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: David Hildenbrand <david@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	ljs@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/ksm: clean up scan_get_next_rmap_item() initialization
Date: Thu, 12 Nov 2026 20:57:54 +0800
Message-Id: <20261112125754.176930-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10504A0005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b5nwnf8wsa58trh5ctj41cwhgpf9xsmd
X-Rspam-User: 
X-HE-Tag: 1794488296-395160
X-HE-Meta: U2FsdGVkX19LJhZ1Fvi68XqPB2W5SYfFdoY4BMJ6J6xbaHUatL5EMjJG3HL5iEsK+3jcZZN6yIupwSnbNQjuEBFgK2ejlclt70Hrg/u7AROVceMPNE/nG86CCZcxLaOefWR0nno/nJTuAX5Ydx/xKm6Wzd0aSHMKK1ItabnmG7pi73g82LCZjVfNPFmBUO8eag6qrDizPwzuSiaU46lj/DmH43ZSCn0dLzRUndeb6SIv9Vy2AOtVMbMCclY53cRGab2JRswYG8qaGXlFi5A7FMyhqG6gKX6w4XIcHnjljuqdbcgLZLls6SRmyxHUQobPmrMJauaMlrqLqEjifxKpVrxK45K3UkusBzOBWj5HEtOVS9jfAxQBiwpZB5AbsG25tEYgx1xHrFsxb79DB0pkZPclOE33HhPaPXwoCmpRg8ZyJCkbuEDwg3N02JInbwXORqfDzbzxbbl+cIbSeph3QHbce2vyuaamCZPW2vo6ik4QXGxXGJuJPGg+qBh4Z96oOpm1ymaGRqxySlxXSffQw+NEZAnlOvuUPqS50yeooWxmlu9n7GjBmWer0BSWeUmKheBoenxtTTN4WVuBfLPTa6os8JGxcxtfV2gLxHVVNDVBKMqiEPXGMV7Zqt1FETahGSQgzBLEzNzp9HAqPLmunHq135ek88oLsso66/igbP6TLxLTF5ZEW2GlVJJHUCcssdazJCKkElPhSZm5Ih4rB1A7kapn/w4GEU1Zu2aODaTBnmFM/EOsqoszAPQKfGmK2aLTumihwPe5BdlEtSIBICxGgTUuwhRGJ0FarT+SsYh6lLtinh6YDIKf+RPUdBgkBC9gZqP361RBYMYxUyJfoYxkJCyi8G2goMsBib8wHB5c2yZwVCVMZMu98cPLYaIyNIN6+1dauHmGKfSO8jJYk/mg1n1V1kSzYFsNz5wzz01Jy2Foq/mdrwPujgAYStYGwLibDQV1jBK3rzKUJaX
 Kk1AnFq4
 ISafdBPIwBRBATeZvCTFyJeiTfpTn7bCQYmjBon/TIGQtwbn8fe73T6mf79nRK6vBZE40r5Ls2QOiDPe26rADyrPn+9o2WNVZcR0UjGJGDgUFQ+BFUFEQoYiTd9qFe98F+mtM1XGNTgTzjzNoKfQBsp8sJ+z/Hwnd1ElePKLenFN7A4B4JfhiTRmM4Mi3zZKcE6KCESbksF9JOslOjk5Z21fk79l5dZM7Khzvk9uLykNOGoqcXpqepA1fvRw2WXLcMv3xNx9lBWCJCygfAiRevTTnCsW4BgN0nJHR6DXahDNMi7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, scan_get_next_rmap_item() has grown quite large and complex.
When introducing new features, such as the only-merge-zero-page mode we
are currently working on, we don't want to add more complexity to it
and don't want to touch rmap_item structures to avoid unnecessary overhead,
so we need to extract some common logic.

With these changes, the entry of scan_get_next_rmap_item() becomes much
cleaner and easier to follow, instead of being cluttered with unrelated
boilerplate such as stale stable_node pruning and cycle initialization.

Let's start by cleaning up these two parts at the beginning (where I think
abstraction is necessary), and we can continue cleaning up further if
needed later.


Xu Xin (vivo) (2):
  mm/ksm: extract helper functions for scan cycle cleanup
  mm/ksm: add initialization helpers for scan_get_next_rmap_item()

 mm/ksm.c | 126 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 79 insertions(+), 47 deletions(-)

-- 
2.34.1


