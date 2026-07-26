Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02569C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 17:40:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6206B00A4; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9CF36B00A5; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2186B00A6; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E0106B00A5
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 13:39:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7D22C0511
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:52 +0000 (UTC)
X-FDA: 85031640624.25.B3AFB43
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4DC3D20006
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:39:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfxKAN+U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785087591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zLddCQIKLIqqHQQB1XegUK1ksWkMV2zqLgwJFjP3qcQ=;
	b=qMcs4mt3eG59PVwEZRXRLEKNoygb2osh+KyFa+nf4Ugj1EghIhAZ9AVMuzvA/OVrQWzuaE
	wFTwVYe3caP+qiigBYXHo+zyVYbti04TTWooSKWvnHF3FaBIOLZ2xQYKX9Sh9EWhTDQS3z
	/Hp1w5lYT8kj+LP97pUAH9FtheJjLJQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VfxKAN+U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785087591;
	b=0JaJjW+3tPBeD7yWpXsN2uwoyWSpPhhB9X8aNZLCVcsnrYKiPGD/tR8tpf1vGzueVi6aN5
	pimyKT6f3sb5vI5U22EVK4lfwpzrclDSBVk4k5+V/e6AOFis0iRtDn+x1i6HmfWjbFV1L/
	ny8NmtiNcN+RjN+7uUVlL8CWNVn7aBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AB7143558;
	Sun, 26 Jul 2026 17:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930A01F000E9;
	Sun, 26 Jul 2026 17:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785087591;
	bh=zLddCQIKLIqqHQQB1XegUK1ksWkMV2zqLgwJFjP3qcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfxKAN+UXDa+v0mAcGrhe7wCB5ya7W/uQKmpvzAz4W1il9FKDeMlDVPicXUcJqUsb
	 6uj9RloR/Kohn5dO5zBzQhEtdLH9u6u60Ha8+UlTwcYGnZkKwd+FINKOv4OvkbPr/P
	 mFJiSE5vaz6O5vKiBniwVFCtn3Z26+zuLOHLZyJAJHR4ku99qc03qbN4T+6CW6OTy9
	 4TuFkLmCk+eGVW7r7l+3x5gpXCMSsw2vSkl18Dn3NDqKlM8cMj/xAx2Wj2tQvgp0Xh
	 EeEv3mh7uuAfojsxXq4F7pYuRhDl+zQhrKsjQ9jDKrbPeD7gh2UzMmXigU0vKRVkLy
	 5hgrYa7QJn8Jg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 17/17] Docs/ABI/damon: document probe prep sysfs files
Date: Sun, 26 Jul 2026 10:39:33 -0700
Message-ID: <20260726173935.94046-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260726173935.94046-1-sj@kernel.org>
References: <20260726173935.94046-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DC3D20006
X-Rspam-User: 
X-Stat-Signature: hoxoy4qq1qgjygp33dmc4q1jnfumoj9b
X-HE-Tag: 1785087591-803885
X-HE-Meta: U2FsdGVkX1/UD3i8HmD0NRnvfJ6vDe2K2ZX3uIS5wCB7I2Bu/mm5Q1rLa9uku1uz881Gl49T1l+wPNDDxqWj/QXvxX2ez+InDB4AIohEPDOhS7tHlXFGIOtJPU5Bd+xjYjUss7g89sWUhC7ycG4u541iG0s4IZR8tRfGaR9Ftfg1Dy1QlEzhDHmUfdyWHCdO9p9roPEjVWvpGd1fnyAQPoHm/7NgCCN3o6OTDyz4xM8EoJnyJ8ffLTBt7QDCemHxcUbvxh5pNynlD12i7yy9sEL/KSrbuaJ+5WNSX6Mvk+iXNZmqX2jaPhDfSkVRD4FgIpbtQLNgkrOBi6mtxeyoIiy8XlD1fi2L7OdP+lfErXYgpVvSyKXuDWTXG8CBfoXRrkh47on5c6ntaiyYCIgnlEBNq2iHHZOE75ZxM/QP8U9pu17FIwoHm50ON/pxrqf+U3QbKyawmuXTEnnz+b55p39edKbcITLoococmn0IdSGXM2gFKzXMqwYLCtne0r858jXX2MwyAAMl5PBNa1uYgOZ2waAqo5pz3v+3ez+U5L7roVCIIJ68TwFcwjb2QY7BOnTeYcNcS/BCItSPhK+j7WUBrcti94uKDwXQ8nXEG+n+hFwdeLIaeIKeHGw+RVLvTgkwjdEGEwDmOu05hLNRbE1TDITHKnlL6rRBh8esZswq2trYFZuC3Ww3KSVOgTIWePWrnRrXQa4EBTPH1kPBnpeDItnSsOTCBTvLBNdlHW3lVf52nmw5XZxiPzM7QJNWcNgU0YaWV73K5pdZF6hzOv9aSkwU7mM10a565MlZmugpNCW4w08M7+ZpyxH/UM0oCcb1Ynyo9yGU+OuiNqwv0sXJ4Csa8+X4YQxZED16LzZaGtXlUBRlMwGrVh5einFQqIIUKmAiz/hxHOX5/R6h4HhShO3ENk5W2uvz1rWNIbl/rZJHp8Oo1kVjHuewhJnoIPIOhFRsJuqxz1eyTeN
 h5yNr77z
 gP+qelFEbDyNAAgt9LPGKk5aYbWQVAkl7p3dRCN5fxYnximLy6nsnOH7hiQc5gmS5WIKwiaPmmsFmemFzjw80qyeDvvKYwTeK6mxTgT5jjRuZvJlI7phkmqiOxycinhSk5RAqZY+U0mPsR3ipaBz0xAe6rw2J8frqoIIav2i4mkXEYgA2yOlzSpJ8xLbvPJ5TklgXb1TIFNaTX//U9OlxN8Bk3+7RLoIfPnoYhzZJ/rKMMRFqFRMUWYXX78YFJgrG+BdY6A3QkknEKgXMKkGQorJ5qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the newly added DAMON probe prep sysfs
files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index e9488bb48d23c..339b7c4177ab7 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -173,6 +173,19 @@ Contact:	SJ Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		per-probe attribute weight.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/preps/nr_preps
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probing preparation action named '0'
+		to 'N-1' under the preps/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/prep/<R>/prep_action
+Date:		Jun 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the probing
+		preparation action.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
 Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

