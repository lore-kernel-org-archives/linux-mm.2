Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFA06606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5g/dHzW
Received: by kanga.kvack.org (Postfix)
	id D20496B05B9; Mon, 23 Nov 2026 10:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8B26B05BF; Mon, 23 Nov 2026 10:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE31A6B05B9; Mon, 23 Nov 2026 10:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 995566B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:13:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C2621A08FF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:23 +0000 (UTC)
X-FDA: 85466727486.11.4C1A417
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8230E40007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:13:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S5g/dHzW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446801;
	b=s2ZxYuxedFpWRBMu+UhSP5nmO9Cru671N4xEESh9rwR71MHXr5OTwa8G/lB5p96yqr0dx6
	/E/GH2O7gEAbEZpkwHe2PKALMDhgOfPpb5hnkO6ic8DvB0UdhTQEvz65GRLk2CwYDlsbEY
	jNlv9ksHh8PsJCsowmvlM8K3arSBUi0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BmSLZeMOrXtjJT391VTzHm5vcDp/H+TXxFKlLbmJKIo=;
	b=dw3mHCs3C32x9fqiTR3sUjrJQWubwuoK3ebgXMki8Zl92tM9Yrs+/vpHK5+J8QH5OCYnb5
	Xcdinm5G88khZj+P7mnKxngmWG8I5B37zuGQBLE9oIhJWFlhbwUfrOB3TzM3bGfykban1k
	uo/1BaCnRWhsPbmi+cn9m8o2n3Lo6Wk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="S5g/dHzW";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E47461413;
	Mon, 23 Nov 2026 15:13:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6291F000D2;
	Mon, 23 Nov 2026 15:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446800;
	bh=BmSLZeMOrXtjJT391VTzHm5vcDp/H+TXxFKlLbmJKIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5g/dHzWyh1+k+1NQKyrS8oVqmpxiqv4nPd3rsQNb3VKSffJ+Aslm0nl/W7EIx+Bs
	 Vt4l2xJV/+o+vgo9mY8hkqZfGWUltMtk6Hs7fFJ3NM0jXOJTx/7YBrRXtCIYsoh/dG
	 Vdg/l5L9hYUUO7iOYyQAYrUK4CBzTj6keOl5QxaVwp9DmSCATH4UTRidSR44JhABWK
	 jBfUIUZMaa1Qo31zNU5x72tBq99S7nFSoy04vr8rF4AJqeP7CPf0EW2+ItidKJm5mS
	 80PsmD8MBQNp6EwtTwBu4jDwyOavuK0hPXX1L8hu620r3jM29NfXrJ2MEl1jlXUCZO
	 CR29qYfON7HJw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mattathias Pinchover <mattathias.pinchover@uber.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 4/6] Docs/mm/damon/design: update for sz_ops_filter_passed_last
Date: Mon, 23 Nov 2026 07:13:05 -0800
Message-ID: <20261123151309.82675-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261123151309.82675-1-sj@kernel.org>
References: <20261123151309.82675-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6kniymehbcxom7dp4h6889khpo7xdkx5
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8230E40007
X-Rspam-User:
X-HE-Tag: 1795446801-968723
X-HE-Meta: U2FsdGVkX18Z0wjSDDdSvZH0vU/+U/q3CQ8AOG59st7SttY3y2erYHxxJ2dsRDSruCTAx9Oz4sS26f2+m94MRox6YrhlRwR57Jwng6zhKB4PTVlcAcCN7926keApyYupJ9myx3VTWPb1qHwAFzIHQcBo9GegfHVJ3MEA6cW+G80CLy9o6h1X0Ye8WCTwMjd2vRQ/ax2zT78jtY8i769J9vTqxkwyU7h1IML8Nkvrx2kxLTeTw/Xtw8F+sEiVUuPpIwFqa93sBcuxkkj85/5WW20iOwGQjuUF2MiFLpVz4bpmiaZE3mcC18g9qRedCeXn6nqOoc3s2rjHbteu8SLwUxaqg7nrnmnZ2YQb5BHfHHNNI2VLCfEN9T4EVu0Z5u0mqtYBm1LAPvIHQiLymeyRqnC7nNmzm3/WhtvijjYHvXQEJt6FFrDoJ0sbVb3B7VcqZOULyGGHYJa58koX2JaBaMDh+wdfTU8n2+QpiIHGc4WjsJBInLw5lccro6px85H07AfQVIYPT8Rexj2HDOnVhF6+dYJi/cc4v1CgE+T/rJQgcUKWvEOvLjQTNc2MimO2jLdsE165rAkVQK1KFQXmuU4+WsG4jz8fTFZnpzki56hVr9zPP3JvoHCVE3pQf0seoOWHlKRp37GUzQ4I1MOQ+rz9d7bpniYCBVTm2e76hijdKV1H7lUHUwAtvRvkXGTPQtw6ZWYfV4s8GehasxoPE1lb6bip8Dlj0Ee7udx5BvZ1bcfxg4QDSyDZY0ADy5NLFllwTXy+jJNC7D08QB2pgtH55KtLi+CiZN7erZvScIjzmx/j6ASyG8i5ilTHbm2t98VGc6YqwhJwbwDbOiqCENckSKiSxsCqfpVrPRWXgbN7qygQD5xqSH2ronSo04YGx3cZxBDDPHIU3W9J5jR2Ou/ySSFdDhdsgAUnj+rCWIrI74/Ady3y7NOspqVBFEI5L5Rll2DxItibAp2PFTj
 HbqG1pwA
 RPqkCtWUK9laWRXDPWc091kPWpeUY+RtioVpQWZNKC17K2pIrpQYOUzgTMv8xuOM7Xy8jVG4Ya3COmNIpinKEIu0Wc9tsOAXKFAWAW8ZGi1zvf98GTAUvjY3rRkOsdp4P9GzHsgTw6Jj1Hg6Q42Dx98MpBmrScySTs6fxIY4eg3/nBX77i7fj71BgRrcMTviXOfz0ojQC+V1usocLOWYBfv3q3efyyJPdk23FvEsO3EPJrv4/kDwAIgBnjH52TjKp+bc1ejQzZQWfSBC6NgvYTnDAcO3kNDi0qIZ+yigu7pm2lp8mv+H2vQApAeKBRQAsSMAK09I06pmUeAxZDkB01I7kDbsGIyZ2/s96fFFEiUVpkCsA+wELRhhTjBK7gs/L46SgRzTt0AsWz4Gm9rhWBTO3aQyRTLIZg1AteyF13FbqFh4oWPld/T8T0xcZ7Ev1GTZn+d7LQ/CB4+1dTqe9+ph37r+M/hul07dX5Hb4tEonM2iPNhUkQUF3pNaKLBKd2h7vi8Qfw8bjQG1+roQrNAsNSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mattathias Pinchover <mattathias.pinchover@uber.com>

Update DAMON design document for the newly added DAMOS stat,
sz_ops_filter_passed_last.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Mattathias Pinchover <mattathias.pinchover@uber.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 6284b90054430..ca8fbf93d556f 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -876,6 +876,8 @@ scheme's execution.
 - ``sz_tried``: Total size of regions that the scheme is tried to be applied.
 - ``sz_ops_filter_passed``: Total bytes that passed operations set
   layer-handled DAMOS filters.
+- ``sz_ops_filter_passed_last``: Bytes that passed operations set
+  layer-handled DAMOS filters in the last ``apply_interval``.
 - ``nr_applied``: Total number of regions that the scheme is applied.
 - ``sz_applied``: Total size of regions that the scheme is applied.
 - ``qt_exceeds``: Total number of times the quota of the scheme has exceeded.
-- 
2.47.3

