Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18EC6606A51E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b8oA2H1w
Received: by kanga.kvack.org (Postfix)
	id E63D86B05B7; Fri, 20 Nov 2026 01:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC746B05B5; Fri, 20 Nov 2026 01:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02606B05B6; Fri, 20 Nov 2026 01:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4AAA6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:07:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1D3A7C0D24
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:52 +0000 (UTC)
X-FDA: 85454466384.03.5EFF20C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 931F1140005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:07:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8oA2H1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795154870;
	b=2mvgqceFjLyXIAd6cmqYGDGqfqeLxnf2tvGYI/YQ/cFpPkuc/+0MXho9sUneOGcCYFUxZE
	09LNmqrz40kwS5SywK2ioNFLc4LzRHROBgkTrZ5xN/NRNzCgSKd2a/SyFzNPFZ2QhHynVw
	Z74iIjyZtwbZ0YtMd0uPEFf59kKAZZs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795154870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+Q/Sp05AiIZSb9V9uY0yDUF0lL9up7p30RJjOrcfbo4=;
	b=LF4YCH5z2wtHHTre0wmmKG2LwCkellZEJY1RwXWZO+9BwwSZiaHX0/1MM3lkf1sJ2cj5jv
	8O6XIPC4EmXY8cq7xTS3wwZVbkaqtjfKExZ/ZjD9XrXP2Fq3gq5Mabp1idAyC3xEYBqSiW
	2njx0MxG3Se5IBlep3qOc/dxzgFRF9c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8oA2H1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 608BF43CF4;
	Fri, 20 Nov 2026 06:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0695B1F000CA;
	Fri, 20 Nov 2026 06:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795154869;
	bh=+Q/Sp05AiIZSb9V9uY0yDUF0lL9up7p30RJjOrcfbo4=;
	h=From:To:Cc:Subject:Date;
	b=b8oA2H1wrVN/rA89/9EkhaZutna86qhgM8ktwmiydVOErWOPhIzvUq0FOeqU8NyGN
	 7S+SO2AgIcpZViYJt2TqP7PFgcrIJkJ3RwTblyuAMo5DIcY8oFc/VzmIQZPh5dbubg
	 o9eogkNzHTAw3mvZXnJ051K38Udfq3sIUAucbpP17Rz6ULuOj45DbWnK1tqh8QZ5rd
	 rYmooDiXghFeZQW/vls97sdGymLHw9J9OLMoDLokgoLAfjlehkdHcw+JK9n9qyc9zF
	 RFmt6A/soWKxM6h36q7plHKfI/TVK3XuHmI8zn0mDcPLvaSUwMQxAF9ic8cn4uEY6p
	 32q0NV5gCBHsA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] mm/damon/reclaim: enable auto-tuning features by default
Date: Thu, 19 Nov 2026 22:07:34 -0800
Message-ID: <20261120060741.92121-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: obr8ct13xwq8c7dc7s1qcbaj1p8d718f
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 931F1140005
X-HE-Tag: 1795154870-285019
X-HE-Meta: U2FsdGVkX186OPN3Z788KpMqEp8KADNhmNI1WEC8Qaer9qwP/DVjLbWC7bXwC0hGmzLUNaTpGMQXHBq4dS6fVSYOBNnG/Tia4LVDQowbMrmcJb4nW9Lbc8dBDKaJc7H52YoWTozP5yMz8V2UOvCcj+fUbBE38SDENTojUme9VY3bpSqrsh8bmfAJZUhpsr4c40vZkFMC3fYKbKuamgErcGy25wCAdG9hBPMwBwHem39PE3XYdpk/96VMG/sKvccCL11cGeAC+rP8yMBWuNOfg6/vXGbtd+5eyhKYrgFn/k7JXv0g5Rt8ACB0SlBVhyX/Tn028FSKhfxyhTdUAwYAwEi3j3MU8Sdcvm9TZ8GATHipUc871IDDQhtSZMil3zilfu//CKx60Jb2yNo8lyGdlmZSKBd2Ds4/v0vZz4XgQ/ummdsnsaOww0OKpshb7bVMMszjpDL8eDai2eZQgYcAbxQdu8VTm063OAo12q45MULl8ynkha3dAeMNNsIn7stltlVosv12cIsGA3uxQ+SMOVR6g+NvuazmKByl007bxmOp4wtymDMoLWHR3ILMcDb823t4fZ7umvIZmQQcN7ReGAD32V02mUYGew5ue3yI8mfzbWfyZ0fYjycTeiDAvGUQlr8C9Tp7Sd1+pMh6uzmZ3Jvz6CzooBs14SlA/9Iy+3Edt0DHs33o+7q7XeKN5pFLWF/EPG7dhyA0jC1u0D1+awnAm/ZJmz3p342d8jzeoj6l+hQ5yyXz2uJ4cZaFmJhuW9mm2Gs2fEmaN5EmBS/sYggrYWXkYwoMZXEVQ24QoLQrDDvOMLtgIPY6lij4/a0FFWGc/p0K0+QH4RE9e2Kl7nkC4f4Ec7LnJU4U9cmBZ81dtpIFJaxXhWuksWrpEzdGpalSX3RzJbg7E6u1HMfslh5f3440c3+PWPe3k34ZP7I7SGdnrFRiFg2xfFXsjTCJP6UidkglIB3sHkBH96U
 YIxJkWAY
 bCFI0A82FB/K6AOKSs2hYe7+D6tx+e+i6Iav7dMNyDBIee0R1uOx8gmcCiq/5laWCIqvx/JJBw7Y9uNo3KwrMrtG7HizufC2R8SCAGe60BaGw7W9qcY9AoyHe8dlbAY4XNovgILKXFnA0c5cEevyKhpkMldOwMIKcVwrd6TYxCmFnITsSpJ+9qc2ZN5ThUnI0oHv+Svh7jSZHX3AupssZgNj8tQPEIEDjGKIrjQ5jdh9H9YtQVs7zNkI3x3vkge5o/SCZiLKuv87m2RXIlkASO+hZUPZmMEuRJlR1eg+QL5933rMIj73xAbvmhKBc/5MAukzFjo43wU5H7xED4DlfMftBt9mfKwbZvqR6O1eqJ/dILp+oyVkEyCMcImIdna6KKRcNQvcZnRY/+MCrenOCjBzBJzJ3wXFmzvUK6dPGX0PhHpi5oJc8DSOOxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The initial version of DAMON_RECLAIM was supposed to be used after
manual tuning of its parameters.  Among the parameters, the monitoring
intervals (sample_interval and aggr_interval) and the coldness threshold
(min_age) are particularly important to be optimally tuned.  The optimum
values for the parameters tend to be highly dependent on the workload
and the system.  Hence no small amount of tuning efforts are required to
each DAMON_RECLAIM use case.

To reduce the tuning efforts, we recently introduced two auto-tuning
features.  Intervals auto-tuning (autotune_monitoring_intervals)
automatically tunes monitoring intervals to provide practical and
efficient monitoring results.  PSI-driven quota auto-tuning
(quota_autotune_feedback) automatically tunes the coldness threshold.

Because the auto-tuning features were introduced after the initial
version, the features are disabled by default.  That is to keep the
default behaviors unchanged.  However, enabling the auto-tuning features
is only expected to provide more benefit to the users.  Disabling those
by default only makes the adoption of the features slow.  Also, it is
difficult to imagine real users who use DAMON_RECLAIM with its default
parameter values.

Enable the auto-tuning features by default.  For PSI-driven coldness
threshold auto-tuning, set 0.05% memory pressure ratio as the target.
Free memory ratio based reclaim watermarks were introduced as a safe
guard for unoptimized coldness threshold.  Because it is now reasonably
auto-tuned, disable the watermark feature by default.

Enable the monitoring intervals auto-tuning and PSI-driven coldness
threshold auto-tuning via patches 1 and 2, respectively.  Disable the
free memory ratio based watermarks via patch 3.  Finally update the user
document to reflect the changed default values, via patch 4.

SJ Park (4):
  mm/damon/reclaim: enable monitoring intervals auto-tune by default
  mm/damon/reclaim: set memory PSI 0.05% as default quota goal
  mm/damon/reclaim: disable watermarks by default
  Docs/admin-guide/mm/damon/reclaim: update for changed default
    parameters

 Documentation/admin-guide/mm/damon/reclaim.rst |  7 ++++---
 mm/damon/reclaim.c                             | 15 ++++++++-------
 2 files changed, 12 insertions(+), 10 deletions(-)


base-commit: 0ec5c1c237bdf91ae93b3efe32767aad9a670f8a
-- 
2.47.3

