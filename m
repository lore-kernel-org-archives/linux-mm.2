Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3558C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745B96B00C6; Wed, 29 Jul 2026 10:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8A26B00C7; Wed, 29 Jul 2026 10:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51B356B00C8; Wed, 29 Jul 2026 10:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 238816B00C6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABBC51206B7
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:10 +0000 (UTC)
X-FDA: 85041980940.23.4E5D4A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id ED90B140023
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCY6Kfg6;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333788;
	b=u8zrpO6V/fmCy0GthklN5MsZV11H5RI7Acj8wkT8s14lKgljJyA/A6YQVKZRS2A6gOcbvV
	v/RElKsh8NBzLbiZLGRD7XJmFXu20Dwt74Hmlf0fLGWDE7zhKz4f5phYQyupzzMyVU5KWV
	GqXViMpl4evULliYk0fGup6Cb5Oz3hg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCY6Kfg6;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	b=A5NPQNkvxUqD+ID8/Ad3pWqEB64fPrzxWuqelh2AEEiEDswAQwHCco+AO/a0VldLfrxuRd
	EUImq+ioJtp5z/IPtxVeHuClchBUOJZKOWzTfZOPzfQpddK5grwe7muxDtk0dlNezVTa7r
	5HTnr7P4ROHfDlCHuIamkVqeWCeJReg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C1CF600AF;
	Wed, 29 Jul 2026 14:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F1A1F00A3A;
	Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333788;
	bh=FTkFqCNT/LseVbtXKhwVw4AevH2QQucXk6b0DrI2IK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCY6Kfg642m2C60vKXHAEOQbfP3Q7OEL3PytJIvUfzVav4TeZK0BLDzrUxKpCqG1F
	 rgoOFzBmm7fC05ocsXZIn1dxxC2FXThNytvprMuHEl342oOWdTlaJF4BGEdqapiX5o
	 SOHmztScUESE4PgfrqDQt5qNpv74YiA1Sk+PUn/0CFEmsIOl79YLA8iVsMNQJTtWYp
	 XQrbmdKG5xKGCIfQQ3pU47vs5o1BIs2cDg7Jl6QJLhl9tKc8FhuOMcYnFnAihNzg3u
	 f/6cby8AyfLNZ0tkj0txM/SACn9t5cvTMsIL4q8ZNpgXCSvpYXR6RuPAMQG4mxKRGO
	 5rROm/vfqtG4Q==
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
Subject: [RFC PATCH v1.2 12/12] Docs/ABI/damon: recommend subsystem doc instead of admin-guide
Date: Wed, 29 Jul 2026 07:02:52 -0700
Message-ID: <20260729140253.87753-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ED90B140023
X-Stat-Signature: ckg34qsmnm63n1ruq7qcoswakdipjfi7
X-Rspam-User: 
X-HE-Tag: 1785333788-661328
X-HE-Meta: U2FsdGVkX18kb7+ud4LeD/kHRlHEQXfrIkiTxHN3q5RwIrIVyQ8aWeF9v6c01dDRl+Ahzfz/PhY6Xz7PAzVAY7FamEce/GQXMFNzvuTFPqt+/oBBGBvzW0JnLHsWpHy4EAIaz0hfXUcjtZTfedwzf6Piml8wVKpGYqBytu1et2b9HZHaqDdv7fyYq3+FuQD2BXTe5ZV1ISUVBB+L/AHnhSgwzmdJDw90qNH2waPDmoypawhggNn6560Bm3mGg4OKiUUQyNNPnzRNQ3CtaD9aQNhxnAqOKnaqJSMlp3QAwvtx6R0cKYD7PpuL7yxHLvD1DEhpLZlwj004JP5HxLtFO+3vUqXTQRYToVuTjzh5p7hkB+pt9nIh0LQ7MtLwe+b/tkA5aClPk2nybi/wqWKrbs1TTda7wV5jk6qt+EhJXvwh0RO9oEYrBLkIR0S8vQKPLBzo7NGR0e7a77diWPjip1CHwaluQ29XEXAb79Pdzd4T0+mRr9zC9FkF58HldidfHAnnhKOaV38cEaRGha7b33qvghmUaVLyn293f+mc/FC4p3BnDzZibQQpOEWrbJZiPrFpRE2kThSKiqlqPzm2i0fkk24kA4vVhlzk6uZQWMtGzQouikWC8Se4ne8wgi2DvnnTEZPutPWHIrco4Co2pbLDcuQdEKcAmouqBCWbtv314/Zkgx5DoCXY/EV/EzEGeoVSK8Bectc3vKz6VKMuTbX22ZxJVhE9+mxFjVrHWi4593qCeoaMQlafZ8upF39myIPFB9mnCS+e7+g9UyLmVmW6JrUoN0zxnJ/x+ycKrE+PPEPzkU0Yrc2BUf/90cOdfSbai0dUsNWrRcyVA1/0Kq4ryFckr43TMDPVMtUi6e+6dSISCm524n0S6Hd5LReudakW/vpKsa7SAstNnCOWQ7zW1jzDsBfDj5aGYzyy0X35ccNTeqXovuIXuYzV8OJfdX3AABcPPnpdk87LIfk
 0i4Zy1dA
 wFnIfP6hPC2IGLFoAStO7+twf0SZyBR9l7pNI7qMa1nDH1IZUx+SjlbPgzPadZLHv8YpKXgprhFPU6oxLa7bbDI1uoBFsw9yq+Z2x7XKNQK9f67RJz53q/GvSEEahkpfwChJosufkcT9OY5oVsD2r1LvOSDdhAR9c3iQkxVDx9/ApLXNVwUGtYhSYR7wOM6WoWcDXtr7xGHu4Spmif/hbBj5/q/qGvvu2iXpcMA8RRjIIkAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI doc is recommending DAMON admin-guide for people who are
willing to know further about DAMON.  Nowadays the subsystem doc
(Documentation/mm/damon) is a more recommended place for even beginners.
Recommend the subsystem doc over admin-guide.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index f8d2601e82904..ad21f58f3c912 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -3,7 +3,7 @@ Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
 Description:	Interface for Data Access MONitoring (DAMON).  Contains files
 		for controlling DAMON.  For more details on DAMON itself,
-		please refer to Documentation/admin-guide/mm/damon/index.rst.
+		please refer to Documentation/mm/damon/index.rst.
 
 What:		/sys/kernel/mm/damon/admin/
 Date:		Mar 2022
-- 
2.47.3

