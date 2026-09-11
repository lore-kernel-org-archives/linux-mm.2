Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D06C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D626B009F; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C912A6B00A0; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57E76B00A1; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75C146B009F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5893A028A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:23 +0000 (UTC)
X-FDA: 85201628526.23.6E22C12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 53E0C1C0007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SS7+jmwv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	b=ma37MrdJrCVVY7f20xa/ilNV4BsjYVl/uwg6cBUxNXMUVv25RpmWaoyPIFQEFHJ7VO4TLn
	0tu4yjwPU699xH4nm6wgn4l0E+IfEHuYBuZncsYuRPTyQ5HkuxYMQ5LdplDoXbkMUa/4ax
	CP2bHmd/twq2m7a/FeEHBeJopzRk8rg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134922;
	b=bIpUAq8yV6r/gtkRODDYLYLnssxxb5paDP1+ASGXzGdTlvNDzWlxzMqHOSfjwOkzn8oQKz
	vgq8Y6dTmtxmqlysrTFobH44fDGJY0+AmKe5MzbE4XqFrr24JzCxNvXRWBOAIFQ89IhIYl
	5N49ckhs7o5nOZbEqf54InNmX2rS1gE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SS7+jmwv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE52960A5E;
	Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CC71F00893;
	Fri, 11 Sep 2026 13:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134921;
	bh=0/q3LnB7iB4S2lxLwjnJON3GEVnAZWX6/MrZWM0ze7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SS7+jmwv/8ImSjFx2zCBblLPosOpBtZLgZ94qNWZ/sDQaImjAr+ZfYxxCGAzAC7ih
	 WbY7PqMNtdBViMPLLba0pBXCqQCKFPHNlIookFzl6o24QFVQdqx7Ayr+lzF5M+JekH
	 e+ZRWxTGFWtLvkiRnPJwlXOIxfbbAP4y7IczFqq4tH0fEnFDpvCZ50IZXGlXM+bQHr
	 vTNoZ1MPYyqCcFHbGAt/E+k6K5k0uEYQr+X6UICm7sE8goSkfgQCbkVKtzg07cuOEq
	 0yYP6ASIs8mmqXh4yD1sejBBcKUy38DCjRm5saXE7ceHvcQzJfdHAOXeJ0HbVKbP2y
	 vWmFjM3nnbY9Q==
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
Subject: [PATCH v2 7/7] Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS filter
Date: Fri, 11 Sep 2026 06:55:09 -0700
Message-ID: <20260911135510.96914-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53E0C1C0007
X-Stat-Signature: uikt6f7dc8j1q5q98d3km9ne6fnydfi8
X-Rspam-User: 
X-HE-Tag: 1789134922-492770
X-HE-Meta: U2FsdGVkX1+57ML9qGfVonqWb8EyZn0fy/cL7kKSz0ZmJ4c8cS1sLkuiOWNr8q5qXWWjz5WBN82r53mDbfffNHzxy8t71D1tDtKz+572SGRqUREl53JQAJQ+H9Jw3nIDpOqZnmK9M6cI4mulEiadHrhB1JXAR9iQa6LsdvOHLdbeM3YeY0yc4Zi7QO3MQD+WdLXhw7pI+ye3a8F2MlzDqtE1MuCDczfaNFwwbH0g2Wowi94LOdMMnt6oCgjOmrm6cc745nF/niAHQn96GrFkqrRGnnyd7lCX9n20kAx78ZZwJvNGq/630QUDWOVcQa86uHR64dykc4EJAdZj8n1rUaJcaSUs48Z7n5nUiUo6ilJ+Be8usqI41xmDFYOIA7W4g5votwLgZT5m1LsvB7pMsmln8DwQVQwvXrXwNZ2QMJBFhNnbR3kzxXeRCO7ffDzcykB0RlJxbPv51Mrdrsz0as/N+ViYVbsdAgfohiu9pI1ALvbxiFT8SfCI/ipDXhLbj8JJyqJofJGQvIUeWGqMQYc2f2Thr4ICv7xJFqbh+xGQylEPEPzIPCmIFAGsho249hMUW1tupJvpMd2OfxL5qeyBQ+A/++VsL7BmtmmI0CYqeyf3Af0sLACHI5iGFXk4+ZOZYXN0f/0iGBvuFVAlZqFrn+JU1ZJ6el37iu2u+/K9V6oBMmAWfEyPgAjap1xdWJwX9YVDY6UrfT4L6G0dNSYRCQt0wjuv6N32pXmKgF+MxtdM0iDvrw7McekDg6+nvUQareb0bOecocKpCKZFgIQqdJVNouIT1LiK1gRcZne34bVWAdZKOo/+d5k6v7hB6Raid8WKlyicD9014Z4XPaTWT00TpuDMMnz9FZxXApJ7milyPaU3ugYzWH1FfKGMkMzBaya7y8sx6tvlfXKIRax4FTFIdkfTrRIMGGmvn4fUcFn7eYYAhHdKkIkji6joTufsP9XraUs4he3oBXM
 hx+4qI+r
 VU6HnqLy+0R5PydFKXfNRAetjOYxFe4rWAhcWbiAx82IRoLiiMzagwBymAcJOyqLL5Og2tCPE+bSWrHJM42CmGGCdr6RmWKoOQIjE4KKIrWuZ0XNxIW5ZNO+9qwXef1P4xIw8jofCX1pC/GU/pYMH+ujducxVGb3h4S/VAaG+VMPE3igrv1JV/Rkq3KQUa7jq9fy+YbwyuIdxS7L4Lmzolomse93diFsrfdSse6LzFs4TG9fbfNKWl3wD3RQ7NacV44T8oukBsAx2uADCV5m2H6SNJAx5Xx7ixOGQszA3/rlNq/uBrBCWDRYqaOrKeM7Gy1KXoMOIACWDGbJLKyw/YHWAW401dKMr5VKEWBHIBdMKbjD9rBcACPhMUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON usage document for the newly added probe hits weighted sum
based DAMOS core filter type.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 023c6334024f8..d3e37400367bd 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -551,6 +551,10 @@ and ``damon_target_idx``.  To ``type`` file, you can write the type of the
 filter.  Refer to :ref:`the design doc <damon_design_damos_filters>` for
 available type names, their meaning and on what layer those are handled.
 
+For ``probe_hits_wsum`` type, you can specify the minimum and maximum probe
+hits weighted sum value for the filter to ``min`` and ``max`` files,
+respectively.
+
 For ``memcg`` type, you can specify the memory cgroup of the interest by
 writing the path of the memory cgroup from the cgroups mount point to
 ``memcg_path`` file.  For ``addr`` type, you can specify the start and end
-- 
2.47.3

