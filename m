Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CF78C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEBFA6B0099; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3926B00A2; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2146B00A3; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA4EC6B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:02:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 466E4A01A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:39 +0000 (UTC)
X-FDA: 85161881238.14.3C3C3C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9BB8C4000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:02:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K67QxRPW;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXn4FOiKb4JIWcSHZNBTe6EO/erUpMh++SEHXjVqCNw=;
	b=NkBNxAUnZewArWvcvseOC4VLDuFF60oXrIbD16yrt2ZUJ+W9pDJSSPdcA3SXETqESiDAgs
	JN+FDzbDmSQkYMW36MBy42+by8O07T7HkcVGmave43KTCu55S/yQihaNq+7jmTTbL8LrRl
	F8HPKBCdbfQvApRuRSgjMlb/GXvUSxQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K67QxRPW;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788188557;
	b=wQjQuWOikNfAmKfEZFF8xq+2yLD2rZqfGrmdXTaFQ+Or49iu5ZXMkiTW6m0EVlGRNJ3CIH
	XXWAROK4CMLY2zWxH0q05PP3ifzZJoW0Fdye2RZ5aCMiqthOYdg8tJ03WsMEsCO++3WzIY
	jbkwGqw+DXqxLAOSG52swcpsiDX9NL8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E23CA407CF;
	Mon, 31 Aug 2026 15:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9A51F00A3F;
	Mon, 31 Aug 2026 15:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788188556;
	bh=yXn4FOiKb4JIWcSHZNBTe6EO/erUpMh++SEHXjVqCNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K67QxRPWwOvBzIuBi7VnzhsuXPxPepi/qpbAN0usUjIR9TeEMc+UwvMUAnDamy07U
	 lw0WLuJjhWOPchA+iSwH/5ofeDhdsqFVq0kawpyRUGNjla7c9JvDfoW28/7ALet/5v
	 rgMu+miDMDpojnONyalNpbR4UHz76N2Cc4g///DEOm4v2UaYykh35UvVy64oh1AQfZ
	 ihlTSC/9Gk+dVFsQvfnZh/4/qA1JySu1qXkqdalz2fttrXGC/CkGce9LtR9zNkYvTb
	 hsebKie7WeST3NOGnUbdrA6T/Fc/jUSjnTkgHq0RSJoojP19XsPto1R+oyx7ry7TiF
	 6a5Ko+15QDoyQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] docs/mm/damon/design: difference between watermarks and nr_snapshots
Date: Mon, 31 Aug 2026 08:02:25 -0700
Message-ID: <20260831150227.83416-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831150227.83416-1-sj@kernel.org>
References: <20260831150227.83416-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: no6j7r8fby47rby7bjxw4xp41xaon5qo
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9BB8C4000F
X-Rspam-User: 
X-HE-Tag: 1788188557-809457
X-HE-Meta: U2FsdGVkX19oGXkvbu7/sDlnNe4ceqJq9+qdwssXDksli5mdv1T+Z/XArimZi1sBbZaeCbqmiUKpLXz4mMxPgEN5Spd9Htz9eWA3pvrsgaAgC3LIM+ygEL9wfZCwEvibTS2bpYMTR+mg4jID1zEVi6w+rSuWrCObqucPtqJojdMxjSxCbZn2OPq8pT8cvtpZmeP4aNZGT8x6N38vCHup9FaPyVHphtxa6WJ7fxrC8S2/GjRrRESHF9g9y9qZI4c4i221A5EQ20U8mMkt70ISay2EKKAv7cpOEDBi3yCv+gtxgDtFEKO5AIJyc4f9ymlLkIIJdPrkxIMht78l4WXqwc1n5tADdL0NaOm4+xPuQTcB56j4Z4GK3p7s4VayFZCW3ObiiZgyW4JUEr1GpS5ndIcK+fLAcuWzNVss0ctmG7b3HFhg2mVRJV5PKj8rxO0hz0FuDZ6Uup5/4kCvEtyLB+JkI0KQCTCdEC9t2HmZinToTA+PwqkNGMLy/RReQpf2ZP/PuPukOBYzv3SccckvHsZ/vLp5AUKRyNB0WGwpc+X9lJqTS6PUMtxdK9X3ol1BVZSp0qiubvu6LKqGyjgkWqXBSgdpmEp6WuWv7y6cxxiGcatmU/P8MIUxxsTbjxGM3sMgJXE8MjCsI8amgBRyNGEV3DLY5R5nRo7hd4l1+QYuLhZbvsIJPOWFMfYu4eh3IDfoRBxUj7kQWacVqc+3fj1Zaid35dRwiU8oJd4WKEQpSL8K7VAFKFv5gMEbnSMEfsi/YoDVMJz7LJcuC9QFHJ3RiaQzyAeYDdzqrBNjPZnLd5pS7bkNFJgCbrH6jpG1FdujqfMeUlsP0Tmn9CMFOxG/lERQSGuZSymi/9EOZ4sAebeNxtukqNNxq9nLqtZZt0OLqp9shs2invqNpKZSxWNJOUKllmecZJO4Gk+88T/ZgS52vSDpGyUgFrQsebuJ7pJ+MRppD/qOZzR7DU9
 R7tRbMN6
 7yZooYhEMK/HircLSC5vPApwBPZHj6xy92bkjIoRboic7+x3BNlJ9rJDtkdtWla/ItiX6UGFFi2BPKvgLe534PX0cv7/s4X+uP11Ada3yXWS+YI3TkrkxIflx4lnmlCU1MziQiAOkYgUmJKzran2/LjMIpr3mMVMdqREorL0NsNIjz1DUrIZJtT4jBxD0Duf4nmAW7WfEf214BvAZTlw55kbvQPAgN8emTtyrwGm56fRYsRed1Zm0uQmD5H9HKZy6dzB7b7Y6Ffkru82lXnPjLCtKMy6l7CrKdY7hxTgkMG+S1mFFqez5uyYHfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Explain the difference between nr_snapshots reaches max_nr_snapshots and
watermarks.

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index af94fc27890b8..74170a2285501 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -874,7 +874,8 @@ the action to the region will fail.
 
 Unlike normal stats, ``max_nr_snapshots`` is set by users.  If it is set as
 non-zero and ``nr_snapshots`` be same to or greater than ``nr_snapshots``, the
-scheme is deactivated.
+scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
+``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
-- 
2.47.3

