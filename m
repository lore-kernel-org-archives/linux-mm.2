Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7EF2F3D60A
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 15:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429EB6B0095; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9E46B0096; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8DC6B0098; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 165756B0096
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:30:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CD69FB99D1
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:30:58 +0000 (UTC)
X-FDA: 84599488596.19.06A93B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32D68A0005
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 15:30:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJwtZg9K;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WJwtZg9K;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774798257; a=rsa-sha256;
	cv=none;
	b=H97lc3n+lHRECz9iWTYB6dvo/wPaFiUOhoT36pHDO7fh3/W4GF7ByIm1+AD637+BGoEJHI
	TxYVa6vF8q06VxN4mAirdnLUUEfP1LqHkvrfrdp+dK6xha1HTfx7nw37/1Y0GyUFre/VNE
	xHXCVvaM2JaC2xYCfr7gHQYLXVSotjo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774798257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFFnukuwe5Knh/bFFWGbSx8n+/Penm2UtDJqtuQpx28=;
	b=A3jeUXXXUo/eBONB/ujqsUqzq0wVMipL/6Fmp7mIHRCezEu/AEkMgqot1GWbZu5MmuZo0s
	c1Xpcot5U3WXzEMkPOW35EMk704LuS1So0kZPGrnkytt5Oc8+zp4V+zK2XVTOhjhYfTq5J
	5CN6+2QvNc1Vzbpdy7brU96mbV/MrzI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F95844569;
	Sun, 29 Mar 2026 15:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96FFC2BCB3;
	Sun, 29 Mar 2026 15:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774798256;
	bh=+Vuu7wt+nGQlkJXcCrqmt/j27FT/vMyHTCViEQGR7sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJwtZg9K6U4VRZ0r2hlAY4XFRHBLim8dZ/Xvik762PO5eROJ4vVAY9eAhyBbz/arI
	 fMNisW/OZZtsGuS9o4D0frWt10QP53N1BN5Q4SEBaNDZGkGG1Qhh9ld9HMIgwTfEVm
	 gXwMWoTAWLeNfUOrOGwiKQxfGe1V2XhIPTGtie1eqtZled6tHQ5dtNw8O5PkZERXRM
	 +LoRLFaXC2WmsT9uL+1kq/xXSiNhPl4XrXTRnS/F74XtW7U/6Jrdalc3kFyu3MVr22
	 FfoS9cngIU+CD0ELQ6BPlPa1Vqm6fPZUJEZkcj5WBOypnC5edUUALCtzWVnvhGrvHu
	 9YVJiIH8X0eTA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
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
Subject: [PATCH 1/2] Docs/admin-guide/mm/damon/reclaim: warn commit_inputs vs param updates race
Date: Sun, 29 Mar 2026 08:30:49 -0700
Message-ID: <20260329153052.46657-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329153052.46657-1-sj@kernel.org>
References: <20260329153052.46657-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 32D68A0005
X-Stat-Signature: bzgbag87cyzjm9fkw8jah9ipyayyd8ji
X-Rspam-User: 
X-HE-Tag: 1774798257-348076
X-HE-Meta: U2FsdGVkX1+KdGAVXrAjPe1MAmNXmM0lS9MdSjPFcLmHFLBRX9/kfQc/qG6Hx9Yr1A3Wo+aEjq0sxqBpR6ibj8nWVpyxzkOGbAmmd4gmw76d8oNDzBSTAb4Eg1Q8xHf9XoYcK4gPPfi2kp5adr6ytooxFLlVkXpfylknahonyDOyus6WE6yOh4O7AigDZ1mkcEI4xvj/EESjaUKwhcimb5k08HUqR8QFkCEQlL/zxj9xGHXzqLV5CG7QFTj3N1fUR3yZcjLz0c7MZOtZRhFclgctSjuk5VgCGzPKbR6F9x7xStx9lBO4cNsGM8nOQgWZIRBzqr9dWwtmmQINCPLAzHT0psEcSjOQDGHevIBm7ICacKxZUBpA+Ac9KDKsAlfeJxOuD7dV4rJNaDGf+W2EfUwT8MInaQRrWcDArJErTuk45elhkV34RV+77VCyPZi+HK+t5snQ6Pss1asYtlZOSAiiotS0TzDWsbe5orZx1Vo7CQDF1YxmFWR+E+9zoH/3EsMXzHnBGl5E/mBgUivuuIedC7OktnkESaRZuFZxvRtw1jL3FwvYKGVO6xErHL2/W9PdoHI2lVjnUB8SQyyYi4vrPrjNVxJO+nYBqu0+XYGmh9ig5OJhzaTWqN9BbCzVd3a8E9lVQ+0NEwfgBVzDX02NTIXch56ipf+aC8c4iM+5iQPwZ+u9DYHsdXcGnRNB/XF8UvSaP0S7H1NUQnz/22FYTXjHTJwlG/++Kd596rd5uA2unaV6EuAHVVkAbyVVIDPXCVznhg+RPPpEQ0QDo/m7t/C0d6SCVHeoBtAwx40NRImjFw9hKILpDy9X5aJ3FCRPVX80Mj1Fk+78SrohYOIWbkjk3CwRgQs/kvRnftyJUx1sWKatMzEQRRNPmnKTjreHYd7Zd1QaXpkcY04jpY5zaREE7tmzhjZlwHFoL+fJQOE9P2pgJjfVWuwrJRTrV00SSXy+Wy1olBZeUvG
 s9lXdjA4
 lfy7MsCgyjWL/I2kWncxIenDtexyD9LM4juhF4h5kP2ZAp9w6xdQdqzFCVJU7RM+4GPfAouq0APftawKZ17Uq0w41UbdEACSznKsapEM2eC3n6wtiu6a2tqoI4hdPaUG0UbGZ8mDNUeT0ktSz4thq7rU3x5xyUwVyxyRn/yQOI7hStZdrUfabPRPt1Ae6Y2YAuQXTNIPM79PqSBSaMG5PIZlfh+ay0+WgxvZl4XXb297RuG04NBpoLjczZMDNVD0rdWPjvW2vox7FmYl+0gBouG74lPcXXk73So2yGKrjYiJuvBFikZjhlFn9XRsg3+j1DXYqzT3NFO9hrc2I8zTRRFACsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM handles commit_inputs request inside kdamond thread,
reading the module parameters.  If the user updates the module
parameters while the kdamond thread is reading those, races can happen.
To avoid this, the commit_inputs parameter shows whether it is still in
the progress, assuming users wouldn't update parameters in the middle of
the work.  Some users might ignore that.  Add a warning about the
behavior.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260319161620.189392-3-objecting@objecting.org

Fixes: 81a84182c343 ("Docs/admin-guide/mm/damon/reclaim: document 'commit_inputs' parameter")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/reclaim.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
index a100216f3a72..17e938c319e3 100644
--- a/Documentation/admin-guide/mm/damon/reclaim.rst
+++ b/Documentation/admin-guide/mm/damon/reclaim.rst
@@ -71,6 +71,10 @@ of parameters except ``enabled`` again.  Once the re-reading is done, this
 parameter is set as ``N``.  If invalid parameters are found while the
 re-reading, DAMON_RECLAIM will be disabled.
 
+Once ``Y`` is written to this parameter, the user must not write to any
+parameters until reading ``commit_inputs`` again returns ``N``.  If users
+violate this rule, the kernel may exhibit undefined behavior.
+
 min_age
 -------
 
-- 
2.47.3

