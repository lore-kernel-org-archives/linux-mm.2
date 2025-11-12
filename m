Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07BEBCD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D288E0002; Wed, 12 Nov 2025 10:42:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0CE18E001E; Wed, 12 Nov 2025 10:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9050A8E0002; Wed, 12 Nov 2025 10:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 760C48E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46DCEBA0B5
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:50 +0000 (UTC)
X-FDA: 84102372900.26.3D2FB3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9532B1C0015
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uB+6vhcX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7/V9HUa+DpFiidCNDTPVTzme87zZeF9okNpyKW71vw=;
	b=cyw8t3R0ibWnFevuFJfEJcbzgDzZAALyKp5Yp2WF0sZj8HzH6oQtO7xzT2PiJyz/yWtduw
	oc0sCN2VToPd6SM8q/iIresaHXABcqDHFzRjb3cSEqL5eBPbPobN2jmY2wbUoJX+3Li+EV
	H9oz5QeiA+VahlbQ/u2wV41uXy2isB0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962168; a=rsa-sha256;
	cv=none;
	b=FIhKtqb8c7SPp9bRkBtUJT+4mm0vBtA1YMWnLE1f0cBTYq7j75TcC94orxts21LdwPA+zB
	Bj9kTiZhc4cJRWNUGTQTYSAcrT1ERj4Prj+FR9MSKoqBiYT2Hsfsb0jr4ncaknQzKez0R7
	UlFZiWCqKOUmjXDxNCigbqB4QEvOiXo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uB+6vhcX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEE77415F4;
	Wed, 12 Nov 2025 15:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9C4C4AF09;
	Wed, 12 Nov 2025 15:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962167;
	bh=FBvB31rC2k0tLRJF6QYnzPfHs35FSu/tgti7HSN3rF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uB+6vhcXgD2N/irb6B7wVJSD0ZCkAohTi91IssEJMN5ne6QnsOoRIjSATHwXszAJP
	 KtwCRdxqtDCAbw63HqvPiHcVK1/ollFG5R5GF1vTt0cQkZUoiIBqEKDyZIVarM2GE7
	 byMmioNTmy+MlAzqC5Ia3j5zEGYbKg4lS5S+CoAgb2jLfGCpRIA3cU620h3SF7I/Nz
	 8hCl91wRfHQSzkBePKgMxNaSU8UQBiG2RasFpYimQp7eFui0xGIVKg5OP2UcAWld4V
	 vw+4DdO6eicqU0FkjKljiRcCsYseK7y1tWx0cwGjdlNPFhU4NeET2lzLv17Q6hvz5V
	 Io/xl7FbXk5ag==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 9/9] Docs/mm/damon/maintainer-profile: fix grammartical errors
Date: Wed, 12 Nov 2025 07:41:12 -0800
Message-ID: <20251112154114.66053-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5451cngo61uoiuyrz3qewfocmj1etqua
X-Rspam-User: 
X-Rspamd-Queue-Id: 9532B1C0015
X-Rspamd-Server: rspam10
X-HE-Tag: 1762962168-502487
X-HE-Meta: U2FsdGVkX18qyg+pbSn1/vcjrRpvbIpMSyE6zIjWe2J5xVBWpgtk6vBD+pN5vIn4N1X4OB8+vu2AwIxYnc+ORshpxyiGS+kU7L4LRcyK3vPS9tXCW1ZPh2acY5MRnXFjMFsnzBLjShzfh+8jJr300pZ1TFtUNefvbb040TVdIb71RtRpNDCuVRJGpkTbWGaB5fiYMsINLgEZs0BPsNU91afWlVfHQemMBTyTWo5ZLSIHSAqWJ8BWV6fCwMJlwv0LgVW/eKhWQQi3Kq+9yU3hjVFqyCOyqYKKN8AUiJge1cZrf9JgZdnhDSQ+N/mDBRqVd+D2vtJeVp4IOESnNe/r+WLdnof7XGY5++PxhN+IQPo7faBNatRlAoqJjILhDEH2GZV2Zq7NBHWShrbz2DHWMqEhP8C58dKBBax7js7QrfMq02brSQT4zfHOEmVCHVciIUyVSmybGrgpEBwcQigKTGF9V5W6cPVA9PUi5gEX7CGndqsxUG0IgPKEOMgAkB0JpzBhoRhtyjhbMR876hvk8QyOmkFgwrM+6zHtM8ybk1a0BkxMroAnowkz1WrMYSV6xyL40wRhvBmpkkvP0nvLTdQBQ+RgJYqDifxZaQ9QpvI8ujN+QUeJfDcCBCzxJDnF0s664Q9v3X69pPKv4qK/Om4B7fAZcCqMI/+3nZasUmzFKJ1HQj8UAd5WFIDFeEA4mVTXan2SOgrWdcAdb/J6+nGKCdyoDK6r3Q3n2qeCNw+PuXV/Ob0HFR6epQZEqJ9+pEXg/4mNCcoWZBAAgs2X9VQDlToKpNmxl+rG+maYjdFPQwVXnYkeFCgoJPuxorjxmvx1z9uCMxhwN7TFf+z+mEAOvvDp0u4qxhGqS6FnCnRZeQ3RrnBFGDfv1ra957xmjRNwWxRontxr8jASQonvjaERo5/WMmVZBrpD6Gs/7NLFZFn7jy4VCrnjWngOeaZuRljmHkvEHxMfwlIByUE
 DhQYCg0P
 /EHePQLJtSgXCD+sllDgafTF01VVddEv4cl2tFvZxFaqGyFlF2gmRmo1lWsYev+2vapYWywPZy7WgNAZZQzLJgb4cpZYGCjRDcupI8AdcAlRQMJ2OC8ph59d1+FelJ0v0+8c0dmfV7QHtPUFhgrtHYCvyuSw+DRyxMDtQ4s7S5R9dV65m819pMMPZd3/bDIIbSKz+FK1+tfhX+Sip+zVQ87OGHAGVBdmYzC82cx/T9ojGIdfsv3+HN7GythTf+ZDwJxHux3s1qDiHhFBN2qj7uKHPYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a few grammartical errors on DAMON maintainer-profile.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index f1aed6e55d31..e761edada1e9 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -27,8 +27,8 @@ maintainer.
 
 Note again the patches for `mm-new tree
 <https://git.kernel.org/akpm/mm/h/mm-new>`_ are queued by the memory management
-subsystem maintainer.  If the patches requires some patches in `damon/next tree
-<https://git.kernel.org/sj/h/damon/next>`_ which not yet merged in mm-new,
+subsystem maintainer.  If the patches require some patches in `damon/next tree
+<https://git.kernel.org/sj/h/damon/next>`_ which have not yet merged in mm-new,
 please make sure the requirement is clearly specified.
 
 Submit checklist addendum
@@ -99,5 +99,5 @@ Schedules and reservation status are available at the Google `doc
 <https://docs.google.com/document/d/1v43Kcj3ly4CYqmAkMaZzLiM2GEnWfgdGbZAH3mi2vpM/edit?usp=sharing>`_.
 There is also a public Google `calendar
 <https://calendar.google.com/calendar/u/0?cid=ZDIwOTA4YTMxNjc2MDQ3NTIyMmUzYTM5ZmQyM2U4NDA0ZGIwZjBiYmJlZGQxNDM0MmY4ZTRjOTE0NjdhZDRiY0Bncm91cC5jYWxlbmRhci5nb29nbGUuY29t>`_
-that has the events.  Anyone can subscribe it.  DAMON maintainer will also
-provide periodic reminder to the mailing list (damon@lists.linux.dev).
+that has the events.  Anyone can subscribe to it.  DAMON maintainer will also
+provide periodic reminders to the mailing list (damon@lists.linux.dev).
-- 
2.47.3

