Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873DF606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JKLqGCrK
Received: by kanga.kvack.org (Postfix)
	id 51CFD6B05C5; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3D96B05C6; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4307A6B05C7; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20F0A6B05C6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1C801405AD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
X-FDA: 85446641196.04.79EFD60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 19AEF40006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKLqGCrK;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968557;
	b=5CWuiUmiyDEpOX6nWb7wplUV8T0vHL/Tt2Jy/sfR/endwsklciWwBK2I5DrLOzULYdSOHJ
	67uFMHGOEe8ozdgrias2spDXQ9PKH5uLobq6EZJsA8lrTi+euEAtZY8oXE6Z+MfOaoXkH4
	VM6vN2LiL19McnJDrPGXdABA9FGBOpU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpJsxUs5k/v5Q/BJmFbBidw7iSSRFrTJt5QonQhU+Vk=;
	b=mcQY/wl25CUKU7dzBlkQWm2DKeHlxY0L8Nj67OduhLCJZ79bNiu1IJGahLc61YNpR+bLvo
	z3PpjQbl26UQV+y1bfQNRSu2GElXEg1fYCQFDR1mB9qocD++YQV6Cd3lhim3+u8zw3TuCz
	25znzHzX28sYK19rwM14NHbgUVlBhxs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JKLqGCrK;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A8F845CA7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3502A1F000D1;
	Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968556;
	bh=wpJsxUs5k/v5Q/BJmFbBidw7iSSRFrTJt5QonQhU+Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKLqGCrKEe9L/MUJ+Q4hSknRmF/yEYHn8OnP6j2BExNnfo1iAddeOzs1OPfL4bs/H
	 M4oIHnNoVd0MstriSeN8+eZx5MayPGcaI3/h6y4lIdEiPP2VwtfbyGAgb7DhchzZqc
	 LZBOr6tn7ONXza7pHmX199WBjBb6X1VMsw46GlyQijq97revk03FoSXBsu4IjSaCUF
	 Hv8mnMVY1+ujqwb+jSNy7kdB+6eEjgWSF7yO4uK0vW3hld8by7gVbN69OhlQBF9b4S
	 0Ve0baJZkbEvmkRh73dLBJga1CD0dnwL3FYeyW40LL0MeAzk0lrB/XYWFWq2ohXWH3
	 1kb5M3atNgGDA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 11/27] Docs/ABI/damon: update for report producer sysfs files
Date: Tue, 17 Nov 2026 18:22:06 -0800
Message-ID: <20261118022225.100659-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 19AEF40006
X-Rspam-User:
X-Stat-Signature: c6hyu5oz8we8re6kpkoqzusaaddeabrd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794968556-698017
X-HE-Meta: U2FsdGVkX1/F/yGpz6W6rAKUA839aRoIr6gQiv0nQM0vtnZgHPqLS6AUVpUcVdjcdSaENZl6AV3OWzGIRCgIKrwizeovVMZLRYpVzHk6bYERgtiRMLapTwFSS9LYFIwNeVOSbUDPgNaAUtKjOA//wPvaYpXO7sbBOafZDYEnTNJODzje7BNtuEzy/bcFtexCPHa6/lBfU9etsTmVpUpIc/P3+gVQ2qEHjD7qFJ46kp9v9A/N1SnMy/3qtHBLDA/b0CpbFE5Bd/Bhg8EiDM3+EV57Q2o7BVCT/tie3Dp58cTUdexZT3kW6DeQduhQSYEseNh5Q3SgEpnkVn0NLEROTegtE6JslsD5on3cAYNMs1wEZThp4br2jthEndfw8VAsBkWSnfNvhSzBVlKZ6e7FT1YtH+gi0V9oeyI96ZD73obOjnXjArYW/ewbwcFVXY3rzzrCeaciOPE/4dO0miiQQ3jv/32wSjHdYiYagMMMy/ChvxMG7oj7JP8Oc/s/TpR/sAEHO1TJViMarauKzFc/gAjohrShF1BdDHZyFX5cU2GXVuLxjra+bXe5vVWiBqjsMCstmJlK49ez9RWbKYBl4G5ZHoQh1oAzm8yaIBUs8irvP0HQQL9u73kbMB3RXNNW72vsFaiH8AaF4ZmksxJRj94xOkvpVQlkVO5hh3KDIJvDcHZUURI7Z6Pfii8Iubx6z/xkZ2GiO2tLeCJMqRGMTSJ8qphSMF4kqADFXOgiTxeB24D5M5p+aixCbXPkkrn6UdNA3cLDzGZ4FXWHCS67RppwVR1IRhwbAxMXIFJd83CWDqz1d9J6eekGP+WQlUx7TM1EWiyWLTQ6ywKhClqfe5yNuFFXluFwHub5142C8uNsC3ZDvdzV6axCgZ07iK89OmSF9+QOck3c1QRzrLYK38B9EmFybXNLWdn8otBeWKsBURMcrEur7BL8KaMr00eDaS5qD6n0Vzu1da5N/jT
 H8yoMG8z
 A0BmkUUrPO2UX8jpA7IPy6toJXfkioCowcmgaLblIglyR6W7MHOkwqGCzm1EBiHbH7JJ4GOCyH+eoLPdoThy5TLic2QJ5hqd0zqbi3PdtzaV0TzSQZIi1yKLl39kYStKKY6cxA0NrwMjcClmpVlKxCR95I4z4iOfn46X0B7DVV8l+I4jIYLl0SJXSL/+ctkQcD/qslRj4GBVXicGNJisbxHjTV/lBAxJU4+MnIv2XmlaL74hz5Ceo8CN8tojsARzsOz8WjB5gT9MAhEOPJkIpdyftsHchJH+p4F1v+BzVBGt74I4D5dj0MTESl4/JQCIAj/N7o1qusur4gHTVwFwCfGYzFN2RWpM14FGHEQHsoB7QFiaa2FOAK6zOxpt40TEeplgbMVvDfToH8rXmPUlRUMeceUdVqi7KO9rSCxNt0Yei/oHfOwVfNipzhyGAVRVvnV1T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON ABI document for the newly added data attribute report
producer control sysfs files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 .../ABI/testing/sysfs-kernel-mm-damon         | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 4acb2015c2f4f..c9f718f126c70 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -695,3 +695,23 @@ Date:		May 2026
 Contact:	SJ Park <sj@kernel.org>
 Description:	Reading this file returns the number of data-attribute
 		monitoring probe-hit positive samples of the region.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/nr_producers
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing a number 'N' to this file creates the number of
+		directories for controlling each DAMON report producers
+		named '0' to 'N-1' under the 'producers/' directory.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/report_type
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the type of
+		the reports the producer will generate and submit.
+
+What:		/sys/kernel/mm/damon/admin/reports/producers/<P>/producer_state
+Date:		Nov 2026
+Contact:	SJ Park <sj@kernel.org>
+Description:	A file for requesting actions including enablement and
+		disablement of the producer.  Refer to
+		Documentation/admin-guide/mm/damon/usage.rst for more details.
-- 
2.47.3

