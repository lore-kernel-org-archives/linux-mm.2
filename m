Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B16F5510A
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666B66B0089; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0806B0088; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4197E6B008C; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 260F96B0088
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:42:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA367B66DB
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:42:29 +0000 (UTC)
X-FDA: 84520288818.13.B854B45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EC2180007
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:42:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cxcdUQH0;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772912548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0oQDX9WQ1HvpGKzBbz5tod03Y13bj6rtS6Wm6811T0=;
	b=sw1Mxuu8nwkxR/ZOr9HqdD4zVQBM/+gEnuPzfxamOGjzfsLlvC28cnL7YP3dWV00foEYoH
	cM/17H4HIrJeWuOBXJ+JPHaZ64CeIrYFhDJAFvQ4NxOySy5Ha5OQlrh8fovUe/OzAUV5vH
	oDUgpRWYPHw/5CIUKXmH9ecJoDT318Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772912548; a=rsa-sha256;
	cv=none;
	b=QVs1EkgOha5di6mlzmyCsjtXmKO3DHwSc91HSewDXwlgiYkKAoVFdl12O5skmSeOenXciq
	yBXrrFbiHnIUIs3INpazor6ju5SBp0HvZxzy9FZuXb13XLmtRU1O83G18eHdyJeMzEm6hE
	3lJHKzq4d/Za14nOhgHlabjATQmPkAk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cxcdUQH0;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A275B600AE;
	Sat,  7 Mar 2026 19:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115ABC19423;
	Sat,  7 Mar 2026 19:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772912547;
	bh=hW/2ycay+HzENCaHwC79wBirLF865EtYyfXIYZ2Fx5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxcdUQH0a72LRUKSuKr2PQIYUV7QCuuqMbyh0lvh+rbp4NC15TkcqN7yqbsEiNNdW
	 UyC3v6strUjJ6vR7fJFz+JmYgiXuyJ859bS4erZvLJ1Bc9SHn9Az3SutHOxiyAUiO/
	 53e5x7bHFeoPboFbdotMv3aKrkbVBl5Igi6hJSb5nLKbc24BohDnqK28AO3dm2ZLSI
	 nzLAtE7QgfWRFdIlqYQneMIB7cUyB93R/V1oWqKdIg6D07IoHfqGpzCoYSRKnMGsKp
	 cFWDG5glsciRKnAnPBe7ZZM5dnVlT9Fzk7Zq+5UVpUQ9+lEh5zcfeWL3M2eY2QYL3k
	 SbZHA3hgnOFKA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH 2/2] Docs/mm/damon/design: document the power-of-two limitation for addr_unit
Date: Sat,  7 Mar 2026 11:42:21 -0800
Message-ID: <20260307194222.202075-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260307194222.202075-1-sj@kernel.org>
References: <20260307194222.202075-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: j7kcjjxkx1fi8sg68aujz3hxr65kmtis
X-Rspamd-Queue-Id: 3EC2180007
X-Rspamd-Server: rspam03
X-HE-Tag: 1772912548-360427
X-HE-Meta: U2FsdGVkX18BEWpmATRPNuKJjRrh3icQiUMtx6hyDNKPaM7St3cdZXT7OFXoSRpY3qBWko20R1a9Eqp0cqUril4a9xe0dxKV9ofhD/F+fpxmoVFkOmaypZAmPYK461ARGI5ib2KypaJJmtYeE8OhqoDbsooEoUzlR853F6H9G1EBoLZyrFjDVRDsjiDt0tOHJakVIBHBmMXplGui9qhbyyYVUsOqZp8BnLONqxPS3K0qa5pObfipwraLbFElo+iBeA36c1WLayOx5VWdjd18psJBnfvfdlcvs8oXBnelOw/fcjzlJL/RElnfWxVvCYzMCR4MqCv8CloO/aPvghY7JGopWNPFJHZSeT0UpVS1FdnRgloSPS1G5kKkDBcQcEwDa95woE8AROxtp3AzRFxrimCxr6kJRrJFCEw4Kr7Bo0oMN53wpjuBBH5dU8uXOWHH8vV9KWBl6kfeMKCkx4e1cQHh3priWOVAllV5FyyAn10G7u8b4KeSZ3gFQhqePNL9O40ceq3pxnFBibezZLPSsFq2iXUZC3P8j6sw8QOUFq+lE8I1FAsYEWOu7/hg77Frwm23/ipxDn3wMFkm4bYJ4CtFFKKFUhqon8zRCl2YzdRlwXVUujUAjlDn6RsN2+/7BHFKbBcUvNKTHhS9JGPyRw7/ASa3kSj6UcZJ/n4RIkfPBtfzhxifM3uUiLcHz74MRD0zXj+crdzW5S/YtePESTmiC/z8aJUE3fh4LtZPWcLKG89zJHevQ7h3Ly0e/pMNUr9TYL3FdhzTnXAlhEMtzVtN3fGTLtD7Ne9DX0eXUbedzDZkKIlckXj7UhpR2ZUwAl40pxsAGf6NKWUVvgWPFs5Pk6/ziozaUsIdsGytZlEqC58re1Va3rUg2bGihSG27D1BlAQYs8p2Gcpn5iLhmqSgvKK4cNKIMYMI3X1VcfmEwacngcsr2uIxm419JPmeLwrxi6R7w2zvqyKuCsg
 8BjMYW7M
 Ut5ZUp0j2UMdbn9XmOADYDO2twIWX00OIjKughY+fQ/z7NSs7Twt6+bn1rQM6arP9chVk+NFL98bw1QMNjRmFGZ5cUgRyv9d4Ywv1DeWuvdIDl8E9tT8OMX8vtQnJ3rrJepExyM5GT8ng5h/KzfRP/y6gioAkpkENVVGVEker+xeO7lz9a+4ACCMvZEMJizIu+VWyQTnGjweEj4nSVJMuOCBaUVDMt1csP7E6lUwyELa6md/5ATKMOSSU5UVYHupiQUEOgdOY4HchNtsjeqPW1E1www==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The min_region_sz is set as max(DAMON_MIN_REGION_SZ / addr_unit, 1).
DAMON_MIN_REGION_SZ is the same to PAGE_SIZE, and addr_unit is what the
user can arbitrarily set.  Commit c80f46ac228b ("mm/damon/core: disallow
non-power of two min_region_sz") made min_region_sz to always be a power
of two.  Hence, addr_unit should be a power of two when it is smaller
than PAGE_SIZE.  While 'addr_unit' is a user-exposed parameter, the rule
is not documented.  This can confuse users.  Specifically, if the user
sets addr_unit as a value that is smaller than PAGE_SIZE and not a power
of two, the setup will explicitly fail.

Document the rule on the design document.  Usage documents reference the
design document for detail, so updating only the design document should
suffice.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 28d932ceaf7ed..29fff20b3c2a9 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -150,6 +150,8 @@ address on the given address space.  Support of ``address unit`` parameter is
 up to each operations set implementation.  ``paddr`` is the only operations set
 implementation that supports the parameter.
 
+If the value is smaller than ``PAGE_SIZE``, only a power of two should be used.
+
 .. _damon_core_logic:
 
 Core Logics
-- 
2.47.3

