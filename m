Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA638606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lESe/0x4
Received: by kanga.kvack.org (Postfix)
	id AE8956B05CC; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24F16B05D2; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912D96B05D3; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 693AD6B05CF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:41 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEF9CA7FF7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:40 +0000 (UTC)
X-FDA: 85446641280.10.6E66F1B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 62203140005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lESe/0x4";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4c30zMvWlF/HAu21CDBSrVZTsdtRg90kDV5GhwCdMQ=;
	b=l74rEque2Gg+RNx7WKeoHIAkO/qbURGKe8XymwzLiZ1k0DaTpEUMv9I5XiAXfzhrhx2VIC
	mU7kapjdn/iiDcADwlHHIUtMLpcgA7W+FUDXhtsJ1qTH9ufl5KFzGnows5vPi341q92lMv
	gj9BBr0ZizqmuYacdXYbk3ccdIGq0uU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968559;
	b=qbPIL6YdCjUa0+X85rPAp0oyaGm0uawVNOp+1qMOzsFpzcwNT8brG3ShUfnzfkQ5lfxeHV
	yXQsSw0Lx384XDQNq5bgAfpcCFQDIZxynjHX0trVj8RXHP3hTa8ao5sTt4z61sNxFvV2e9
	GDV/8XFepOQYzJljf+sa1iu+2Qv8+oM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lESe/0x4";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34C3D61F43
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAABD1F01831;
	Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968559;
	bh=R4c30zMvWlF/HAu21CDBSrVZTsdtRg90kDV5GhwCdMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lESe/0x40pspxTfLO3daU8b2jvOU/u1QdsY6TF86waH4uF/VSqrAFIW/X1B97Eqgi
	 xf793yELsFJOqsV/+cjDnE/jBmO6iSjSogb6pAXwbdjq+vS0Lsp5u0BI9vZKu4gWn5
	 TgyGXgqGWCyBp8TQ2VCZYCS2tchcEucPOxK1s+/NFLwCicYbfZUYhEeJ9JziroQjwr
	 xW9ZPoT8WJOrNEjYAY0nnuUG/9neCLQTS1lS2GVV4ilMovT2klLSUxKqTUlwAae8mR
	 XyDDRLTUa09Hz3ae2cjftOCYaqys8wOAecLxjMKzqRdT8oeAvWAjQelSbA7zGIt6e8
	 kmT6raxgdZWvA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 19/27] Docs/ABI/damon: update for REPORT_MADE probe filter
Date: Tue, 17 Nov 2026 18:22:14 -0800
Message-ID: <20261118022225.100659-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62203140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1xe6pt4o9a8ifguodt1dntco7479extf
X-HE-Tag: 1794968559-164590
X-HE-Meta: U2FsdGVkX19mNd+B5YaEV/W18M7DKT9w0IGp4Jb9Jfq2dQCzmXinxAAfOA2cH1p/EdKMi2GW3zgf7mtzv0VcV6ZtEblTbX2d07etczpECNBhs2eOIGi/kn0n4qNshl/m8K3P4giL0/EXR8sSpLlXtTBhr10O/53aD6vt2LRNahCq8frBiWZw/Um8NR8OqVjxqXzflDYNIibCv21iA5SpQTDYVnmGmk9pzfM1ZeZ3L9oxUqEzpAazrBa4xTvSXJJ/h8p51733uhnM40Xhfvo1SbKBKOr+wuu5mb9u73hf/mlHtqKGXNTAYDNrUtGgY7SugpeqFTttKZr3SvhF/uWkuFJrz4zxCGQm32931MkcQda26jl9Z3qsvIU78ffx5vzde/ALDhVjgYMQAAd3yMOQW0Ayk4EFkmdpRgeeb6fWXvT774164KBC5hqRjqXwzQb6s/KPBIGL3eqm645PCItPZ3qgMYzL7hN4RUn/FN4L5GgLJ1xhy1V+yk3MlJxawGlsvn3u+5j60BPaektZpIdQ6mJOghdmSK+BBM809F5Jhw7wnbWz6RmnweAcEiCWf3qkqNjSjqP8Bdc2qWbhvlIl+BnITZnLHXMdDLtCVbyyAV9TFo6WcVy0oXMPYKt5iCy+7wHwYnDHTk2Hq+Ytuov56yxsQFXsp40eTOXxxjVAcMNsAzsNLt6bAGMj00aLm/Vcu0ne3ZBG5uNfWB+0K6XOMsjxGtZTFB7RHkkuozABrUMOb3yjCx5ANg3xpBrXOlOJQW6uNM6WT6MdXt9Ri+IcHc+f+uXWgASSUCZjOjk5TMMFl6ZOuECryn1S+40Mhp0W9OhTneTNYHrhNNsKA8L6uS72aKfJXaBHPhxyTwqm+3MFFn0u1WR9LKcY7jJZNnIbes+wBgOuLhDPm4deJ3FYraImyyzOtkUjRuO8/WIygVShIIEwhMqwFeug3HNvMmfwAHTBPSJpwnKsfpn05kt
 7wgM3NRm
 839BUSiC53Rlk4vPrabi51I2chHlxIo98ZILeQGe6AWfiDcQ2M6q5QYNjcmr4ZyA3Op734iSxp32k4AvjL8Hq5ISX6MXt6SiRRXL7+Foatnebx68rPArlVtkK0mLBQB3D7lGUNWSRu74ZmBN+qjqrZ0IZBKRTBpMi+Xpv9zDhf0+Rw/3SGzSjUKWq7JE+HEm84SV6emTiWnp6/JzEqoRLaNce0Nfgt4NSyDgT2uCOlh7eh/Tc5AcpT4xX1fvwlQSAnvQctuZTGfdkZW1A7tZcrq+UQ6oYWLoGIYdI84Y487fBRLjiMChixKSn/qEb6rQKuS6PBCoF5TdPThRJkh55ItRFNLc3jkpKuKDu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added REPORT_MADE type probe
filter support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index c9f718f126c70..e558dd4212f2c 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -233,6 +233,13 @@ Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
 		hitting the probe for the memory that satisfies the 'type' and
 		the 'matching' of the directory.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/filter_report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'report_made' is written to the 'type' file, writing to and
+		reading from this file sets and gets the 'report_type' of the
+		reports that this filter is working for.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

