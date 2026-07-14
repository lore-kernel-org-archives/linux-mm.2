Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5647FC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80DE6B0098; Tue, 14 Jul 2026 10:01:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56C26B009B; Tue, 14 Jul 2026 10:01:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6C4A6B009E; Tue, 14 Jul 2026 10:01:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B95D6B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:01:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA915C03C4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:30 +0000 (UTC)
X-FDA: 84987544740.25.6B98918
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A45E20009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:01:28 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AThCemuk;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxrO/4xtAHaLxdanZUyXTCrmeo6syyrgYQaS5wtPeRs=;
	b=1UGP6Zek3o+s+yEiAmH6tHEA3Y7yPb/5cyEeDiPwPXgDH1UdbpzaDbcLLCvXp4+cv8oGVH
	57baZR0hAzvwHxNijd6nFD3Y/L59rzCpQu6xk5TtP8Vb5exiEjOK/6GGx53gzU9di+SY8m
	M4iu5lOf3zQ9wQzZU+T47O+fRv6N00c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AThCemuk;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037689;
	b=K3NBRKIEFjShe9tqcDWTAthS8JC8MW2PxInNI2Oba9J7Zc1CVF1w4aOnOp95sxcr52IMGz
	a/A/kgKBemyT7Fu4MRT3nznH9DrnsuUIv6I9z3bpE9Js9PeAfJt9DaX4DKZ4z+yPqeKE2g
	C9kK9+Q29HLKh6bhXOSFH/ur/GVr2jo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD1BD6136D;
	Tue, 14 Jul 2026 14:01:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02AA1F00AC4;
	Tue, 14 Jul 2026 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037688;
	bh=nxrO/4xtAHaLxdanZUyXTCrmeo6syyrgYQaS5wtPeRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AThCemukE+FX5nDLPu9Yg5ZvIPjYN2ueV8uF/mwdcsfpaEQOY3KvRS69A9xofDNsz
	 yEHrAU7aPgQZxVpUXDv8jsTorgbx8vHDble4znYPcy07+GXAI8OBxkGOKEEkYtqNzM
	 +NAo78s9TP86S7XqXWnvbcY5t6IKRJ/LZZ98FTf+LCbZV0cd75pV3HDdDQ0tlOQL73
	 2HLPA+gwjr2gELizwJUVAV8chByBNEIP33Ps/10vffop2wamFSnlPqZWPNqLBLB4da
	 V/BRmP6NdLwC4/A3mB5LJqq4pK4QxLMtzlqOacLNit1Mq+K4RzEc3K8BHtiO0jYrQG
	 RVKf8IqSDeoTg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Song Hu <husong@kylinos.cn>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	SJ Park <sj@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/4] Docs/ABI/damon: document update_tuned_intervals state command
Date: Tue, 14 Jul 2026 07:01:15 -0700
Message-ID: <20260714140117.94147-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714140117.94147-1-sj@kernel.org>
References: <20260714140117.94147-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A45E20009
X-Stat-Signature: nuc1itaqytpjufef587yqpte777ygayr
X-HE-Tag: 1784037688-129288
X-HE-Meta: U2FsdGVkX18yK7FvQghHnVxq+p2N4xCSlaejh6dzE+cAMe+lIjHfeRDTNwTmN7l+M6I2IYGJtx0f7jeOd+r2QRA+lOo1DwCXWKPlVpuWtxYIrWH34kNGpZoYWrPPX0SxnIOlDlZtjXC+TFqIKe2jcvswKe2nwEGC/eMnIaZ3fqXhce/J26an4c+Sz1yZk50YUHgnht6OAcqUBEZSD4hAimrrHP+CtfUQIzKFxZoIij2g1iQpX/0S86EB/tBUOuf9PeOtekdshD1XG0ZS22ypIhKoGD6VyEj9N5oR2FFfYFM0DZexiTVarjYa4d5A/JdJjuVf+h2S3QWMk/oS/GWpei6Wnq4Kw6lz/BAS2yYM5j+eTbrTeFUekYWPmTxxfqxcGA1QG/wSbbSvboD0Ai+L5RfiTIAEWXH4eftiEginIIbSmF+tCyx5JSae/YTofW8yTJDjaq5GhX5Cx49lgQwEBJjyKSjDvGG/5QzGF6OdTPUnRVCub3a1T3N2Tf3Y5C10ujMg5TqMmiyECKzRssIbV0b5V/e52ObRfD1jv8tepkuh/tl8a2Lf4Cs1AKego9PF8o014iPNbpfZcstz1h3zwUPYHnfeWbO1kYcAfdI7DvrOgrdGHotmcfmegoSvJjWgtKm9n5ajv020zEkFi4pPuAoXMqBFzR0ckbnbUL9vLxQ9Jyl57CMSOR/ocMJ7wJt1XPhPnnfbbGlYOZkMyC7lckWM0m2Z6FVTdh2JPDb9f9OmOfBxDGLSANzZM+NrFZBtXcoYguynaISH+PM9FFytp5okX1KiplW2T4jyvb0tBDuYrzwff2K2xmVkB1c5JFJDRkYKv1ExI3QlwJQ0XgN/12HPbrQVYyV153orWKY1up5Z2OKuVhAoYBqIp1Hi5pTH37WkO9LAZ1I43oNkDoUgukvk9Tv/QphLFlTUxpzXOhgp8/VA8/QG7WhA6kKMGMDVXzaFQsby2KeAGOYjIxs
 ACTjcZt0
 FgqUkOpV8EodSaeP+h6HAcjiRMeSSHZNCQPxAoy+gyTEm/0Zzb69oA/sAUtmqBbYpPHLYhM06bpD5lrfjLKZbH7rUpRaZNTn7d9V/38LBUYV8QWrG0sT7QfNFkmAorHwKGtu6IoOhdr5aowNmWqB4y28jX29a6XUIdMdehoSN2v7fA1HSGLfGIkSmgebIKi/dpI+Pi35NbIoS/h1kU/PjvAMycIcnssRx/9BNZHrNFEJ/+MIK2CzohVT1XrAq+z+jbOVEgOEU9vIsqkKBart01UdALw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Song Hu <husong@kylinos.cn>

The 'update_tuned_intervals' command of the 'state' file, added in
commit 1077605396b4 ("mm/damon/sysfs: implement a command to update
auto-tuned monitoring intervals"), is described in usage.rst but
missing from the canonical ABI document.  Add it.

Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index f3c99c79b0f57..1507e63ab1711 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -36,7 +36,10 @@ Description:	Writing 'on' or 'off' to this file makes the kdamond starts or
 		kdamond.  Writing 'clear_schemes_tried_regions' to the file
 		removes contents of the 'tried_regions' directory.  Writing
 		'update_schemes_effective_quotas' to the file updates
-		'.../quotas/effective_bytes' files of this kdamond.
+		'.../quotas/effective_bytes' files of this kdamond.  Writing
+		'update_tuned_intervals' to the file updates 'sample_us' and
+		'aggr_us' files under 'monitoring_attrs/intervals' with the
+		auto-tuned sampling and aggregation intervals.
 
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/pid
 Date:		Mar 2022
-- 
2.47.3

