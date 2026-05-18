Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9062ACD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48C606B00D6; Mon, 18 May 2026 19:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D3D6B00D7; Mon, 18 May 2026 19:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B73B6B00D9; Mon, 18 May 2026 19:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 10B8D6B00D7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3F9C1A0A94
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:36 +0000 (UTC)
X-FDA: 84782164992.30.4BFE47F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 483FE40002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jPC2DPoC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/bZmf3kdcTDBu5C40qPbPv0dm6k5Sl+YpU4P6slMUg=;
	b=nwuUbMc9cIIyjXipJxJRIuSJwq+9Y/hJUqnJlzoXlGtRwyDwobe8cp+dWnW2MP7ElweBda
	em5N1oEbgj7e0HnSWh3pq9ROKUABpkvfoC3YG8f80jOg9GFU29yWOKPcUDyK7QqpfVFJcU
	UnQ9jOYtUc2QBjxwQM0OgC642EV2SZs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147695; a=rsa-sha256;
	cv=none;
	b=vIULShIQUoXgG2+4N53VEaq8pgSD6m1rNQZ+xmYH03AVclLll+zh0QnUddO2re5ANPPHlP
	Td00M4Xsxx3lzc4OFfR/Trceg027Do+IJ/NoKQjAVvVPCmADQFUfFbirR4RQPOiz6hmtjo
	3CHOTyL2weo1x2AlKiDnq4/JryZ7mx4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jPC2DPoC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E89560120;
	Mon, 18 May 2026 23:41:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481A2C2BCF7;
	Mon, 18 May 2026 23:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147694;
	bh=pPitw4Kbtb0sQtr+JQ+YU1RPjhVWQVsWpAxRL8y/Q/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPC2DPoCuKdsge2wTxodAU12wBvMRo1AgrdbhCSONiJMpayPYlEm5Xn4XTMdbVFlb
	 vBK+Qp3OluA8LCpioHbE8gV7xiZn6f8Jne4k79sDdK84wz4VrBMexS0cXEMRe05FU5
	 3s7kqk+v1pzMy77OvWQ0PnmPitreSd1TLFW7RH5zDoPXJs3l++q9f8omk/2HW1o7Zm
	 OkiQwxqBrU09EwG9LaxyeGmufRIXw+xJ5+lfht68rMSLz/jUmNO1napv9I4uhawXEq
	 xWsurm5mbO81RbgqFULgX+iHy8ZruUoCNxNR+pPbUdcBtlGJKOsq4LjFwAk/dl3j+w
	 KLaI3RwRN8aVw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 28/28] Docs/admin-guide/mm/damon/usage: update for memcg damon filter
Date: Mon, 18 May 2026 16:41:16 -0700
Message-ID: <20260518234119.97569-29-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 483FE40002
X-Stat-Signature: 4ty13gxad3wepgif31sobo7m5xn5zxfm
X-Rspam-User: 
X-HE-Tag: 1779147695-8019
X-HE-Meta: U2FsdGVkX1+MWpAHEsqLi6Y+cG0n5+Pz/fjRFFRVbU+Ym1dhidlQx8yQQtU7tpJjbHWDLjTrC19oxFSjUCx5BNWy57GJQRvQqM3DC2sZ82VkNQCkR6IsVAB8sKne95B7PuK/7AIToxZnjdpOIw6KH7VtzlgIB6Iz5I9G8+6C1wPSNaDLIMS7WhszJNHjjcTDWsxgdNDg8SYEnEEUH2vxBoPJnv3mv/JYE/8kPdM/PPPP131nEkMzCkYa7tThyTjSHJRvajknj4e5LeatdXcdVFnA4rGBe0uegiz0yxHzJ+XkiU1BRzc6tDL2dcEOfNmns2pfFramu30kgwY74QA4qU6vXJqRoB1BDyOdhGS/hDUsRtWTF0PK+b9sjryGjeE2G5aXMTDn1a/LduaRhlSL2n0UOGnVX24nkB4ZreXOOSrGU6yZGzOsRoE5KWhxu3TNBZ5yMXolr+fQx33N8odEGzrcDy7GYnOGQtrdX6Y+kIvK41yQP/puH5Asih5YKxChCfnF/KrtzNVOD8FpJQ93pw7rwt3xK+Qs6paMzsmduFxD/Zerj/o1Az9o7v2AFeXIbyDlKhENw4ipk7Z6+2UB+iuxaN492Qm1HjUQaG9v6Bb3YubNay7cQPLNmOrZ4kM9ttI++9z2LjZTjScDiZBk0CFrMMBFe82QixWiKgOs+32KrsWs7njGNhE3cKVlQkVUT8sShJQXV8LQmbSUErQqFAKjUkPDzAXh2cAePx4GrG/OIl2+a+/dVwrC5FiJfRKvFNaZMGeIYZ+q8XVLI/f/Nvcqte2xiH4tkUPt5UIO41ZQi1phQoupEy2cMjobZK8k82HcqXtHyb9X89HkQBMhnhSTUsFzSQ/Vjg348pTFrpjKNPMVd+zD0M+uQZc56QTpUX8TUOHU+W99goudtcs6rOYG22xwCyKBUVpowWsbrb0+cBeCOib1gGU7Fmkee4bUjRX1GyVe+Zr4MmxtEDv
 rFUFhe2c
 5TVO+QAOKiE20rgwduiLn0nQKrPqmpqkMjHK0wuw0I2HXLXUq6wGjl87voJQXySf1gwcRzlQuwldjrJwn8T5g3zwSK/t3Ao94QcEI35oTe35VVk5xsdfuZTT/vEP2IjNVN4lCgUFeE1s4c4k0F3m4VIwsT/+ZZZnNhE+jCuDtuZXtZbqER/N5Brg5fy5BlZcn74eZqJzrl+eVoVTjlXqEjPGZpPFnJFeUXsqNEIY/Re6TsuSDrCJMpVXOE3gmdI1hv5Zsyty5UhYxhMwB3KOFoAzKxiJWBOVGmK5+RdyjXqJZQLGm3VaPj1K6fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added belonging memory cgroup
attribute monitoring feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index abd38385b3c23..d46875e603d86 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -74,7 +74,7 @@ comma (",").
     │ │ │ │ │ │ nr_regions/min,max
     │ │ │ │ │ │ :ref:`probes <damon_usage_sysfs_probes>`/nr_probes
     │ │ │ │ │ │ │ 0/filters/nr_filters
-    │ │ │ │ │ │ │ │ 0/type,matching,allow
+    │ │ │ │ │ │ │ │ 0/type,matching,allow,path
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -289,7 +289,9 @@ the data attribute for the probe.
 In the beginning, ``filters`` directory has only one file, ``nr_filters``.
 Writing a number (``N``) to the file creates the number of child directories
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
-way similar to that for :ref:`DAMOS filter <sysfs_filters>`.
+way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
+``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
+filter <sysfs_filters>`.
 
 .. _sysfs_targets:
 
-- 
2.47.3

