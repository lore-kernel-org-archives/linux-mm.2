Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0F1C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 106C46B0099; Wed, 16 Sep 2026 08:58:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7FE6B009B; Wed, 16 Sep 2026 08:58:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E3D6B009D; Wed, 16 Sep 2026 08:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D05DB6B0099
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:58:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3DDC616064C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:58:13 +0000 (UTC)
X-FDA: 85219628466.09.BEE7A12
Received: from mta0.migadu.com (out-41.mta0.migadu.com [91.218.175.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 61EB5120009
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:58:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pq2dSTG7;
	spf=pass (imf29.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789563491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eWz/wncSmlnOy7MkwT5uFXj+uJiylDV0XMDBpfJ97xo=;
	b=d/IbZiDk0QYTP8L+NY2bDk8MGdRBRR9waoGpGjy4h3zzboYC1yfVxadwfDTcAmYWjS5T78
	JYd3dUNlLy3xIKBUGU2JqV2sf4guLIbOBZYv85m18KsOuAdL/aPK0GZpTjMQjM9xq1tet6
	x/OwIHcAfN/FJNNHMKGLFmDhzQ2sN1c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pq2dSTG7;
	spf=pass (imf29.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.41 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789563491;
	b=FTPuL0sXpJkEjBtXBzxPka3L6ubgoBvfX7xogEAopwxliXSkulV6piFB3lGFHSeGYTV5Nk
	QYHOLagZi8iBJJksNkx/YzhQ9uxZedNqazasjZ7EZw8LedO5uj04sH0MceNC8tPmKdfqDY
	+i4D91TiKwSdSl9dyG/80vg9i+Car0o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=bdXVZ1Kbw6bqlFSxE/MaNfB3RIbM8xtQX+eZUVejI94=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789563490; v=1; x=1790168290;
 b=pq2dSTG7Q95TTIaQMizi0n5RB6McC4WDKKzoXmE6vWjaxc4iTbdPjsYAgbCeHS8ppbsrWyw0
 tJQD6nm9hEqxjd0k9itvXFOfG4DJY6pCv488cr2OfNVNLxap8Qa2jm0fb9BMhtZTjwrhp3hJOpr
 +lbceArzVhgaKTqo2denBr9w=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9a5d3f7511db98d0;
	Wed, 16 Sep 2026 12:58:10 +0000
X-Mizu-Trace-ID: 9a5d3f7511db98d0
X-Migadu-Flow: FLOW_OUT
From: Tao Cui <cui.tao@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org
Cc: roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cui.tao@linux.dev,
	Tao Cui <cuitao@kylinos.cn>
Subject: [PATCH 3/3] docs: cgroup-v1: note the v1 memory controller implementation boundary
Date: Wed, 16 Sep 2026 20:57:37 +0800
Message-ID: <20260916125737.1095414-4-cui.tao@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260916125737.1095414-1-cui.tao@linux.dev>
References: <20260916125737.1095414-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d6wad8po7wyc3sxyhgabmhd8ue1ymjd4
X-Rspamd-Queue-Id: 61EB5120009
X-Rspamd-Server: rspam07
X-HE-Tag: 1789563491-719165
X-HE-Meta: U2FsdGVkX1//QKxHYRwHK2ktg8qHj+95MCTtc8vDX/mTr/uNlJmsyXbtK+vxLki2jcovdEKdzSEeycT7vWAjm5U7p9l7EpXaLTbVeHGYWfaZSatsTnz9R5dFDx6X4WeBJGWLSz3uVToF7Edwmd+UgnshIHsNsqQMaCcnhF6hPANeD3ZnD6kTTF/WtwWwgrkasksI3O7Iz/5PDAGeCnayeZyKIZqMjyZ48aJHS2pQCuvKGFuZt+fMn/fXvmavG8NUfZxghtU2aQJ9sVpfFnE9KWsCeMroM4/sWR42Puxj4Vxrd8h7A7VkUsVP5mvESoZ7F7XVwMebH5JTZXsQsL8zW81OgU/V5x2HFKYdFvlhb0Cc5V83wgrpZ4TOx2FsO5kkbl9+/vlT5BqF3u6GkVMVa7CuB6pbglhqsrFGcXzy00T/gg2PbarNvMTNUEtss+97m7q1XlURmUMbg8CwGlwFc6ifRAX1KtkQN3oCImjrqk+4n4yfadXBDe3DScRvsNoewF3S87F8DiebuLvcdRPLX0sZ8ta1HMqqQAH3bpj7ov3IktuPp8At7h/kCVzsEXfyvLVKZumIiB8QK3vGiJCqvtXxPMiCyYjVcJrEK6ssZsWWjy0Li3OAbLKJ2Ovova27FLI9KJfYYSciLIdwn5dEespeNCLq1QloD/sdXQewVdCmmqtt/ktWqkRRYRwc0qzJHZQJ1BQIXOZdu11iVHPAwsbH1nkezuQ8ZGxIfYCgry/wRSawo56n8mdFTwqMTfWPxHs8ZynZGQkTcUT1gsNn0GmMB/KwRXpf73xu3Htjvr0EYhoT40IPg8eEkwMB/uMDgoS4VsmtIf0lEFzTvg9ZtbpBkKU9RgVgUCb5HOxJSGfTF3Tt0BC66drU2J4+2gJcPdGAqyBiDfut0we27nB5yHnBLmmJrmbdG8cuLqB7zLQp6CjGr2lXuvggwr1LfCLHkWszPhhHpe6vqKvPtwb
 5yVBOoxV
 VFP5oeC02b2W4eDPntNJd5XHaZmD7xeG5ZZ+f6ZU/8yYkzvoTtgLuOayLtidZ8OaI4jkkb15G7NKXO/YJWVnsilje6nBWAPWdpkJXqD4bRIP7KOpnBOpPk3lYiW0c/kp3QfqX/riQkQ3a2OSEJtcCvqHCl0P0vWOkLQzRUSRGw4FHEanp7XTRBrfySQNzEFFLUTb7wrAgcArJoy59SOJGcicWz09aPsBNmwDw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tao Cui <cuitao@kylinos.cn>

Document that the legacy memory controller is now isolated behind
CONFIG_MEMCG_V1, with its state in struct mem_cgroup_v1, and that new
functionality belongs to the v2 memory controller.

Signed-off-by: Tao Cui <cuitao@kylinos.cn>
---
 Documentation/admin-guide/cgroup-v1/memory.rst | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 7d2a44af52c9..2eff1dc6e13b 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -8,6 +8,13 @@ Memory Resource Controller
       here but make sure to check the current code if you need a deeper
       understanding.
 
+.. note::
+      The legacy (v1) memory controller implementation is isolated behind
+      ``CONFIG_MEMCG_V1``: its interface lives in ``mm/memcontrol-v1.c`` and
+      its per-cgroup state in ``struct mem_cgroup_v1`` (see
+      ``include/linux/memcontrol.h``).  New functionality belongs to the
+      cgroup v2 memory controller.
+
 .. note::
       The Memory Resource Controller has generically been referred to as the
       memory controller in this document. Do not confuse memory controller
-- 
2.43.0


