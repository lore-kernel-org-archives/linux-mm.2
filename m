Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2659609D137
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COsIYpm0
Received: by kanga.kvack.org (Postfix)
	id A50566B060E; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27596B0615; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943316B0624; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74F776B0615
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:29:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF0CB140193
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:01 +0000 (UTC)
X-FDA: 85390562082.08.348F12C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 60D53C0008
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:29:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COsIYpm0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LlMzZy2++vEEV80Q06m4mj9WBM9QJsJxRJcm7Er2ORo=;
	b=khKUjh1NLS50SETXQBW2wiGJoZ5iMerfPBoVpoi4h4TQpI9cc7U75+WoSQkAfY+mXZa6DX
	FyCzhuAh7eaUMX4bzuUSgwkvO58EQ2+9Y24IfV0h8ILTYVrHQaW4+54aEgWZtFF0rddYdz
	Xef6tYofIjrjVUpmEbWre9zUEkbMaM8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COsIYpm0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633340;
	b=Hcj/S4LDZHuxJFVMWOa45DwRwZQGdAh5zyfiRZl6mYUC7HbJStKA/uWj+VFzYynurRwght
	35l/VCWP+IyLhA50Czo3ug7WJSBJ0LrnGlX9cU0x8h7pinnxAYW1bty1jrTP70ZUOze7TI
	ts9fa/2CHPMHL5DDEoYjqqyB/sSkikc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B46B60621;
	Mon,  2 Nov 2026 15:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684F51F00A17;
	Mon,  2 Nov 2026 15:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633339;
	bh=LlMzZy2++vEEV80Q06m4mj9WBM9QJsJxRJcm7Er2ORo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COsIYpm08ZRi75aGJuQG+bMkt7CvV5oiS5/4li7guJF2PuUIbGAP8AQ+Y0l/onn5W
	 PAxYTF6weuSJ36KW9l+1T5vec5TURMd9NL7HyafPCPnWQSPNPLutBz6AWnQqny7FrA
	 9l4cY5bHJGcj2qAOGP2CjYjlbeBIZ55a5Y2QmBCMWS2swkNqHYmxxI70/3ZjO5ecqp
	 9GSEAjL3QAb52D56c8II8fTHvDga8icXAf30FHfSUgu+uj+XmDeSdr43SWTscPFq8n
	 34SV4xiilngQmmtGi9mvgtBl2jYibmTRCgiTxtZxCEA/IDS3KioSgCgWCPa8l0LnS4
	 E9ek02KyzdzQw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/3] Docs/admin-guide/mm/damon/usage: fix incorrect option syntax in perf example
Date: Mon,  2 Nov 2026 07:28:47 -0800
Message-ID: <20261102152849.96057-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102152849.96057-1-sj@kernel.org>
References: <20261102152849.96057-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 60D53C0008
X-Stat-Signature: s4ryho6ka1sx1dgjqbusbq746365bzs9
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633340-708035
X-HE-Meta: U2FsdGVkX1/Yqi1SdtulpVnm++W1TZSajmF0HFA3rpULppqmMl1/8JfY5FDSU6FaBjDlJ8tnZj7XPe1nxOmm4JAW+I0GVZ9/LfU/Fl/qOSwNGJ1TJ44VXB/quKLavQvQFYjsETk61gLmQxpT2HEAB0X1unzCI16JqJhq/3tiEsrxrZgKZyRraZnVOmuRqgEmDg34+8vK2yt2qahPqHX87D3m6etap6GGnJYpJZ6x/QHoue2XQV9spcQVMlM0zvs31ZvymBW6hQ6T56sZNFK9ZpR36f+HPkWMj8h+FxtAPL0TxGMdqcupQ7OoIpc6V8AdBdKfm6BjT7JWbBigtyak7Qm4B44HP/oFW8VRwABCfvX2N0NdDYtdbfiCgX7mMTo6ZqKL9kwvaMtrlr5fXKnzUCneHNYRchv2u69FmrV+jIbHa1ogShQmmBDGv3V6EJ8S6qGF+6bgbk/1SeQe9SXp3Ck4F9SNSQ4btoUOXML7a/3CA9AC3YpRbB5nEmk0jw3a3nM+ux2lNpVEN8U+5HXOVAnW28v4i9pNTK/9lvlIc6XYloUaCSMFKl+CE+ZhClGWvt//cqtBaVNW8rpE7UYGXMKkZoL1ULCTWHpCPJ1/Iki5pG8T3b8VpeRfPsx8hmaiLNJr/5irp38y94L3ah9f3mE+3/h8cbfs88bFdIBhYqcQwQ47NtW7YNEQNFUHcLguCdztLrhdeT7llc+hxGjQLgRwDjAhdlIOeNWqKipQZJxiW7f3fnaCBFpxfhDxFUikCoVjko5zyfQnLlqDNLQP59zgsjDTklf6Vhyc6OtRrhLBP/cB15TheNRVo5GOJDX/hHOU27LE/bnZar6jgv5XiT7aAVTSAXfgi6oBnHdJQc6oNRwqexKcgN5anZ1cCcjASHCoxTi0rVb+UfPj2pj/i5l0n/u4v864BEvFbcFdlOpgUPVm+g0JohQri/Dqk8TIbTftVq3LnKeETX+YysM
 OEQCPT2W
 4EmS0aHE/RS0Q1J/wlMZiy5uL0Mf0ejlBRCR9/obedN2ZmwgER3c0gF1TLVwAWJwo9lz6frpX4vbrdRg1+jPlIz77v3haFDErDPYj9iy/hB0G3/vnoWocT9iHld9ajhsAYhFV3W82juiTbrzWfYXsAibT2hgGeLEBqDs/e+tvmTZpgCoINcMgOQf1xSbiwK/Pd7cMWoRzXK4h8MMgtL0Jy8jBtI66RYVkqh27uVb7yarv+yDDCAXIf6cP+FFTR09pP5BWJ9ZTvonuWtncQF1vEwgHjl3jjNyaWrCbU6WDsmuPTG5tZOUOkaCbEHWSd3WxDdUmWVOmSQtLS9YC+PZi/2RDH+hzeBzisOGbNlPvlKcyQIKs96czmvPxG/vRoUVPXus373hZCCxChoCzuG2ijWgYjxkbEgWWiiLxvv03fU2jRys7Rwpt/y46jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>

The kill command in the DAMON documentation uses an incorrect
option syntax in the perf example.

Use kill -9 instead of kill 9 to correctly send SIGKILL to
the perf process.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 3d43954c7046c..bd687d89ea4c0 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -749,7 +749,7 @@ show results using tracepoint supporting tools like ``perf``.  For example::
     # echo on > kdamonds/0/state
     # perf record -e damon:damon_aggregated &
     # sleep 5
-    # kill 9 $(pidof perf)
+    # kill -9 $(pidof perf)
     # echo off > kdamonds/0/state
     # perf script
     kdamond.0 46568 [027] 79357.842179: damon:damon_aggregated: target_id=0 nr_regions=11 122509119488-135708762112: 0 864
-- 
2.47.3

