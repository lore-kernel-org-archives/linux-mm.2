Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1D9CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848CA6B00BC; Tue, 29 Sep 2026 04:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2476B00BD; Tue, 29 Sep 2026 04:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1256B00BE; Tue, 29 Sep 2026 04:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4828F6B00BC
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:01:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3A231C2FC7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:43 +0000 (UTC)
X-FDA: 85266055686.04.9969C9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 35D9C180013
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:01:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2TQsi4P;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790668902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	b=WZpcFNn14JLCUkJ6s5qSUcUyRgdnzti7EqnOD1ig4j5YtbdLIvXZPmd8/jMkDEo5gCUATK
	oeZaU1sx7lO5ucv+285fDFBc5lDMgkqg5K9SRH/Q2Et7xGGYRUS1zZxnagP83+nUSFmSaE
	4EDZ2LIk7w8+QHWUiZltIci0ZL/2Jok=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i2TQsi4P;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790668902;
	b=wqtqKkOywXig5b2sCPVUCw8zoCJVymgAkcPeZpnIk1KJPYwFmPRXH507TlN2FquH2mQ+8n
	9YyVUaUGeFglR/FSaYDksG5xYaZVwceR/CYXHmQJ3hyon+U8ea33Vfi3EG7Ss7wKxdpQ8W
	aMVcUqYlxki1MsTPTiioWJm25lJYO64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C78DD60A68;
	Tue, 29 Sep 2026 08:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33AB1F000FF;
	Tue, 29 Sep 2026 08:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668901;
	bh=mS1OGjGueuh9xRDDJo/iscVAdMoJD4YdolHQuoVSGCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2TQsi4PwELyq4EBO5xilP4w+zwzZP82U+I3u5/cEjBQHlm5b+5kTzjA513cq5oD4
	 GdbVfkV3oBrg3j3yh/H71AywqJ+vQFSzif1CBa3F+9/7Pd/vxMXzV7hAKjNaGXzmfb
	 yugohwAPN+WOuQE2iFSFUxSxm0eLFyw920d7vGqfLMQozsJwufs5WC9QvQZBT2QEyL
	 bQTXY6qjET6RfEfsW1HbIOTKYnc5A1kWr5E3FutgbgxX5maqIKLHkklfiU6MPWryX1
	 yZPSFXVvTRhsijLXVoPWNUX+dwuISIJ/oMDFBUAUM9xPqH/KBPsm9GPaKQaEHdguWY
	 IfxbgTvtKy2nA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/8] Docs/ABI/damon: update for quota goal metric complement sysfs file
Date: Tue, 29 Sep 2026 01:01:11 -0700
Message-ID: <20260929080113.41708-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260929080113.41708-1-sj@kernel.org>
References: <20260929080113.41708-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35D9C180013
X-Stat-Signature: hbs6gssarb8idqbw6nhjyc7srefoztto
X-Rspam-User: 
X-HE-Tag: 1790668902-11032
X-HE-Meta: U2FsdGVkX19USvii34B0ZN/Di8aWOpDIYGA4ocwLV4Ll1cbDw1/N/x31zMfgocNUBKW/Wo3BruX0d7eSYIrwm9v4aMEcy8tHhmYE30a1KZPk6iWR5WIbpIlVI7mfQosXiF1d5kqDhiiYz0sztAa3JAyzHDOXhWWrgUAoPn3YM00HaeVR7fEFNiA6d8aDxrSChex60Szz7dY/WRQYbH3JaWRYM/EcMTxfJgLasvUX1cVmi1LUe9ENhUsqMf0Zk6FfByAGsQIM640w5z3uU1uuP/BsOCvHPyzBwrb+5X39mAJvF+2XSuWDfZyat+mu8JRmocE1kjcehAwTEO2ghB3rp+biEL2rbYAR53DqPV4hwzHY/iFhS5SIt1bXJ8vTtT5EgF3pgsYo+uF2bVVjGycCdooKiUZQ178b/iVY8xiUlpwpHkTaMddbjQ1SnukqLXAdUTB2tLBCurALiyMjSAmyHIyuZ4aYWhXCmKDojvTsHmm2kyKylhXHQnPmaiiYzYNI31kZITsE3NxnTpwM2v8ZtPu5USeVhY7bEzC/qLeqdk4oK8Zcsw/EDlxUWOdXbEcEsvH6r4Bybq0kiD6a9kpdxT+XBDhaI9yzLOXanCN0bLqb52EwkeN5s6hEz42+G/qv1cS/llOzqeIk3g9LUF3aGJ1ZIdkmn4XGaDJlQEmDHCqqrIlRS081DMwH3LvpHo89d0TxK46lTg45TyKXzO4RToKBv8EWKc7ZUBvKwuqioCsizP9rPYsvc/MU5LmkZkURbjQqLLH3R6eBc+yJqCOTPhDGUhdFv22dciBi8g1iNffKmyxBAjNUEQLrE7qrrY0VuIHpMve/eTEmBJQaOS5b+KxmRVuV2LrmX7tlAG1d058xKn/ftlmHkPvNxrVVgk8NQCxg7voLoFXjfv07IKOQ6hZLVecOLlLer0Jwsdacp1E/V1dizztjAF0QCW+eEOBSdqU59xJXhwqaku+QqHJ
 aWKsR5jO
 oex3iTv1WLdnpsDFPJojvrAYbNoN93oVh3wxFkA8RZZqGJHjEKMBKt9tk7mNmV2gxRUCb4Ce9ygwF9yR+a0Bzp+lDI3YOo3MvydOXzAtESpAm2QjVwSuLxgE/dB1lkm8KbPTjuAdzDSR97/38RKCf5b2Eth4t8Cj4H0WD8asQmO4g2of8mZncZvgNHBkHpTcY1gjT1Bdfi1n/jw3hc+lPTV7TmCvM6UmxbSBr+4ElpqZonA9xTpyyFLbA7Cpn6vdEyq9prwcSXH+kY1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added damos quota goal metric
complement sysfs file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 55df688ea596..4acb2015c2f4 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -375,6 +375,12 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the quota
 		auto-tuning goal metric.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/complement
+Date:		Sep 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets whether to
+		use the complement value of the quota auto-tuning goal metric.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/goals/<G>/target_value
 Date:		Nov 2023
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

