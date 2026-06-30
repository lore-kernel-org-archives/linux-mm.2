Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB697C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6B26B00D4; Tue, 30 Jun 2026 10:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9506E6B00D6; Tue, 30 Jun 2026 10:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE1A6B00D7; Tue, 30 Jun 2026 10:17:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5092C6B00D4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 531014051F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:41 +0000 (UTC)
X-FDA: 84936782322.22.9F205E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD6284000F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gd98KBHk;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829059;
	b=QNxDpQpN/Kd53nAv5zwwYyThaspTht7YU5TAYWS5L8Ss1/sAvyvvUe4Kr40qI1ZX8S6tEC
	bzyp9qLiYImoiPk2TzRtLZT0zd9JC587C18IpEi1cwf0gK1dvO7TN+f2hDiYa+lw9WDSGV
	XE84AtCW7YBDe5Iqv/+0ZxzFWdn7UMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHx9E3z9Lw6thGzocnkJE4de1IIySrzMkwZxkqXO/y0=;
	b=A2ABYEfBdkFtDVP1niFbHkmYNR0QKDJhJWdH8lKi0eywPSZ05k6AN+aUw/O7WwesPN2eLj
	Y+J8Mx7stIesTvJRSqNAz+1AMJaX+9lwHKCZhsRIHWpHJb+uGuIwKCcVWLDWxJ+rG94C62
	WSbSdv6fQXdDryVoX8LAdbdubeRF4qQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gd98KBHk;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EC8C601FC;
	Tue, 30 Jun 2026 14:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CE61F000E9;
	Tue, 30 Jun 2026 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829059;
	bh=tHx9E3z9Lw6thGzocnkJE4de1IIySrzMkwZxkqXO/y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gd98KBHk48qxp7JudoP0SPFiYSlTvZDxu5F+wxNZkGL4OBaSEVwaT1xZhVptYG+79
	 Z9UiylLjRMsI3xmO3IuQvRiqIH1gALaeqNFzaeDhlMOnEmdJ6YYdmw0ATVZcGWD2VG
	 xaW54zvBaSJGYxCy5o6Rw2Atq1v6yJlyU5JdiO74wEWUQjTkYvJ2TMj4jLFKf2eMdK
	 623qM0WyaR1V5nydwVn+G++Z/IPVkaOqFAKl692wr9aamLPkXRD/Gz6efouDNmyqzp
	 D50lmzA7K8NiXYW0tvn5NIQ9dUKJKQkXMP0/ARXNBShRKOvH0biONkaM+ufgeSfL1i
	 kvocPmKfaTQgw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/11] Docs/ABI/damon: document probe files
Date: Tue, 30 Jun 2026 07:17:16 -0700
Message-ID: <20260630141726.92246-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: eqnqin8mso18yps673hcppefxsu1za66
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD6284000F
X-HE-Tag: 1782829059-687414
X-HE-Meta: U2FsdGVkX19MXvMVb9coVRknphbv0bR9NJcs812yRjKTwfGr4ms6GZdpIMv2P+pyqOSujJ5PsxddXOSdyKDxckPSDE04nzsDpR3wGPCFyI5E+yLeLBI5XKgAsAZ8WVlhpXY4X3Teqxxf/c2EZ4g/n2tmn05FiBMRFI7WYKWrbLRlnLq3gr4zkaoKYxH8GinWGjIKYBBffhMjZDneYftiLlHwcmsqeV3Euyda8GjU0DmWBnyQWNUy1x0UfLRrV9VxMrY+9Svw0+0T61eLphy50dxAOclzi2gwpdadWNArcT6yMRaIbwv/EbNAiwUrQ/6DcyD9VVCOfK/A3deZb3GTfh3wG8e093e1IT2xocwtj7oYmmJGVEGQhsVKuTxcloj8VKqtfVmmD6YipF1noPtGwOK7U0zBUcIHHYoufZTIbe+XkCZDqBw17oz4Phx8FNvGsaHtbjzSemXYDF7W7IRlzGyizdsD/wEt6/Gck8VKP/NBat7sGOYH7uQEyHfnffqkCAVOtaOvzTKoCwiwG+b7Z0JMYv0PVSmfcHv8WHIaWkD4EnERGuhQwWVX9T8VT8Hj7ycSVADPFz1nygAGKfBMC9pc5uRkx24e4OHdBJlqmiUPrlzUNNk2i6hGyweaxJ3uOpf8I1zGB/C3/FkzOMHC0LDnA4m2nkCNGtmg3HH5BImV2crSLvX/0p9giFvEWRkAvPNmcmCOJDtCSUyHZ3jfA0TGTmnGGhBfeDk2BXoRiEp5vVDWgHT8YocKh1dWlAqj27pK3rwUepI8a5zv2FlNtT13Hvo/KlxKdyXjl8+btnS/v9n26BX6Z2nKTQ8ESHkDzhK66c/yVl/jrSRAGCjgCvrdyqL2hRLVCQmbXKwhymOMAfk8HX8UlNJ4Jq2wm1PkUznxr3fmf9ARkOwrGdrzhyc7uLdqBAMnWen1AfzEchp3hGh4HRV9UqRb6zhemVkV3xDl+ktWWjKTrMbayF1
 qvEIg1qK
 a3z5kHM83AqyjS3knhvvBpNQoEXGp2O5lWu7HYBwn26BIcVZM/e8hOq/yIy1zvKPrQvS/w24GCX9hnlbgpmGzaiA3xcvqcXAlUY/cndoigoa7w4xMkpuhEf3UI66DtpD1z9pOb10TqVOiTVAdWRp2YD/iw6WVzIGMs80N1hoYcCLb6mdRBxZWyp6F2evf8FeX3LIzQGXg3/hWbz89clXRVWeZ/S0Th22nyzNG3BZLADG3JdAsqnbgdItXsah+YCKT/f7Y79qpSAEiNM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON ABI document is not updated for the DAMON probe sysfs files.
Update.

Signed-off-by: SJ Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4fdec63a47d4a..dd6b5bd76e119 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -157,6 +157,46 @@ Description:	Writing a value to this file sets the maximum number of
 		monitoring regions of the DAMON context as the value.  Reading
 		this file returns the value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/nr_probes
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe named '0' to 'N-1' under the
+		probes/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/nr_filters
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for each DAMON probe filter named '0' to 'N-1'
+		under the filters/ directory.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/type
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the memory of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/path
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	If 'memcg' is written to the 'type' file, writing to and
+		reading from this file sets and gets the path to the memory
+		cgroup of the interest.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/matching
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether the filter is for
+		the memory of the 'type', or all except the 'type'.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/probes/<P>/filters/<F>/allow
+Date:		May 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing 'Y' or 'N' to this file sets whether to allow or reject
+		hitting the probe for the memory that satisfies the 'type' and
+		the 'matching' of the directory.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/targets/nr_targets
 Date:		Mar 2022
 Contact:	SJ Park <sj@kernel.org>
-- 
2.47.3

