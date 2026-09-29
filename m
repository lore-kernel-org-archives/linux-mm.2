Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E8EC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C196E6B00B7; Tue, 29 Sep 2026 04:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1C06B00B8; Tue, 29 Sep 2026 04:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B080C6B00B9; Tue, 29 Sep 2026 04:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8756F6B00B7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ED68680434
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:36 +0000 (UTC)
X-FDA: 85266055392.02.0337573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 366C740010
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEQpeDY7;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	b=7n9a1p47uLZEOKCQNRYz2IdjjZRRpo5ROkjZ0HvRlwfqv78NUajfkWOW+rGqvAY26+2LQd
	9X9EjvC3i2+mkkGS+QgoXpdU3nQ5bnq6TOQHi2ux7dRT9L6VrL8kineiS101iFuAD2d6gr
	vrrc7awGWa29fJlubjcBR2Q2QFbz+NI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEQpeDY7;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668895;
	b=Jj7TZ2h/HWH5QXFqhYLpoWWN+7fNx+SeqGT3aJ14/K1QI3QPLW/meTTvmbcArkXGiV8kQa
	OFOuZbTeQcNLE136aKM6EkUjzdCE0bEJO3qMIcfkbtSH5teC4X6ms5cv2X4Pr/pqgnFnHc
	r3LFeHQ81PTAKkFc8vZuV570K4Wbda4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 998B94142D;
	Tue, 29 Sep 2026 08:01:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17F141F00898;
	Tue, 29 Sep 2026 08:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668894;
	bh=s7JRcQFcD/nLSCcRzyB24nV92nZBWi01kt7jJ+1f3Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEQpeDY7pkyQiP/6fqcHuonHtC5l+T825vbXq+6peAhJ1F8PsNKBBLsfRCYUJKbq9
	 4Q+n30FxmVECVj78BGGaXBSLoPXIDIZfTNpewh6WzYxkgHFDJmmO1NOJ+lBzBOwWDc
	 P3D50PEuLe4ARXi+/7JEguq/QKEa6RCEdw2BemFyX8wNNyQJ9dluNndnGsmwoTaDnQ
	 5U1PlM7s4Zv4XMnTlCe35g+9pk0JGQtfaL20Z1IA5vwzocESHgvGDlRLSCpLdk/7cQ
	 G1HKP2YpX0536rujpVZKpvvnneYDydJougi9nGrWUZdXlsCu/Fus/qPHg2Wymj+JRZ
	 lRW51B86EcLdQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] Docs/mm/damon/design: document damos quota goal complement flag
Date: Tue, 29 Sep 2026 01:01:09 -0700
Message-ID: <20260929080113.41708-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 366C740010
X-Stat-Signature: ezgiy17bqz9g894de3e3ok1okrc56ip8
X-Rspam-User: 
X-HE-Tag: 1790668895-102207
X-HE-Meta: U2FsdGVkX1+kzB2aJbCwj7l4TX/fNvEkTtIqAdxKcZ/jKkOiVVNKpPGZWTUMBYw2Lt7/DMI26IlMO4OR1EE9gtHL9H5EXgtscQjeAkHFFqVCBm50s0ppbXyeEOe6YQN2WQxwA/lec/QlUVl8QYgw93o0mbRfFZR46TRO/nAlF7zc+GMOaXjAx1e6SqwNWMsiRxvGaVaTiAbWv71liSqKWYHDIHOCazUmVahUmawU3nRrX7Z62o23feyLvUt11n9v0AMdIAwjNfLsG0rgiV7HSd9dgB77dcvIBLf6fijgws0EzaSob1uD75V5xV9pip1cBI2MJiEh5m8XDLLPQ2qyozxyY5SKrTxsrIUYsDqX296FDVPqiZE8NeyVAa4KbMwfgIAY8qFJXBy3c86uGy2RSSr/jjK24XL7p5QoS/bhRp/GwgKNSjPcGmokihcXgekdwIjpVKZgL/zr50UzpB9oVk8ClOs+DvW/7t71sdQ25Zim2F3bB4hYPWSRfBSbOaEfAg5E7SZmisqNLtF9RGf3qTg29jDX30gRIKIbIxev0AZhKtJksEk3FB3leyHHkawy+yep020h4igLOCsl4GCvVekp+P2cdZHXDw18UvVGdiYUJ8L0I9CAfSOi0Ub+eASafAzu1pxosnatar5W2TZvxujlMiCjs+X8dFdwwR8EohGMjAtMhObKsYUcSvWJ6GSNxNKyZ66TpHDFIqbFhg1W2X1afKoFcWasdqN8D8adjAuEhSFddlUyCKDQ1NpXtap/8RKcnP+G8XyJ+kd+fH0fvEXY4z9QV0PIK/vg+Wfi9ItDV4Q5mTYJV12esbvYfx7T10SkIz5jF113x2YtM5Xxs8J7hgEIPQMK9gti7K8Pw/O07cPqZI64HE4jN3F17LDFEXhU/0fZtyYbEByzvQ6fW1xai8+OeFjvfxPiBwJQN44oNX+2sKjuJoZjV54AhJfQmCMSLgDVL7uDaSzy7JE
 lNVtOcx0
 hrxdB7KoWhbX00BB27YgHTH5wAjZBBkgGNzPjf+pWy7jhRY6OWAXMNmGDnOdag+3xRQsPbpVybsEZq72HPnxcLncGih0GcRjH1+3MP2CxlaVYfgz8D7RbCvv1c0QX7rnh5ybyu5dbavdPmy+YBZj/sWL4g1ALgnOlkc7K50FVMYrRlM3x3niusliWOVgd9ObiJKPnPF2OAXQvvjSbWbhDztYcEEUUBndV5D4pQM1/sYqtLcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the newly added damos quota goal metric
value complement flag.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index e82390e77a70..5cd651b1b7aa 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -702,10 +702,10 @@ There are two such tuning algorithms that users can select as they need.
   that the zero quota is a valid quota, and therefore ``qt_exceeds`` :ref:`stat
   <damon_design_damos_stat>` will keep increasing in this case.
 
-The goal can be specified with five parameters, namely ``target_metric``,
-``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
-mechanism tries to make ``current_value`` of ``target_metric`` be same to
-``target_value``.
+The goal can be specified with six parameters, namely ``target_metric``,
+``complement``, ``target_value``, ``current_value``, ``nid`` and ``path``.  The
+auto-tuning mechanism tries to make ``current_value`` of ``complement``-ed
+``target_metric`` be same to ``target_value``.
 
 - ``user_input``: User-provided value.  Users could use any metric that they
   has interest in for the value.  Use space main workload's latency or
@@ -733,6 +733,13 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
 - ``hugepage_mem_bp``: Total huge page to total used memory ratio in bp
   (1/10,000).
 
+``complement`` is a boolean parameter that determines whether to use
+complemented value of the target metric.  For example, if ``complement`` is set
+and target metric is ``active_mem_bp``, it is effectively same to
+``inactive_mem_bp``.  ``complement`` is no-op when the target metric type is
+``user_input``.  For the metric type, the user should be able to emit
+complemented metric values on their own.
+
 ``nid`` is optionally required for ``node_mem_used_bp``, ``node_mem_free_bp``,
 ``node_memcg_used_bp``, ``node_memcg_free_bp`` and ``node_eligible_mem_bp`` to
 point the specific NUMA node.
-- 
2.47.3

