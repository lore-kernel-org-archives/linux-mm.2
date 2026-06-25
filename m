Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78515CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86D06B009B; Thu, 25 Jun 2026 01:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F746B009E; Thu, 25 Jun 2026 01:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74E06B009F; Thu, 25 Jun 2026 01:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 985526B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B788405B4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:22 +0000 (UTC)
X-FDA: 84917254044.27.AD8851A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8DA5B40003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaJRpyT4;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364100;
	b=vuWBQbpkTT5Ja3pSUBVQV3f3c8FyxX+5mk9QG69FhitI7pAIh/cyO379K7jjShNVk4cOiz
	trROe9veziQmS56J+3XSrAPKZCkQpvIV2Fk5ylk883fLxyCRNBbVr/dQxw1ug+2/LOYdMI
	d3dNYGGAYORVlxIS8mLa7fgRbV72Xbo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4nqp2h8NJB/cbBvBAnNHXHs1MQz+3ybtLtYTB71w34=;
	b=C1MiCzE/UpD4IN+g/PuPO6uYTHrIu58z3XgKUgguIfsJDokFCwXY+r7bzM168ZIsPxHLcf
	gqeebt86MLtXKeJKLEsBuUP86nzNJOMFSMr+VgNqITa26rXDGbk1CNdaod2OeyAHt6fBt3
	JZr1tJwOsC+/CQCZFNjuiSKsvYkfEeo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VaJRpyT4;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2D00C60123
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD611F00A3D;
	Thu, 25 Jun 2026 05:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364099;
	bh=L4nqp2h8NJB/cbBvBAnNHXHs1MQz+3ybtLtYTB71w34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VaJRpyT44V81xCKSMTidxJDBudtkzs0adTpZz0z6TI6CjpWXHsz4nupNV2nb01PiX
	 Av2+3po2X7I+mjhqUpmmH4y+mag3GZt0pjo0bPuCxl24jLqnorytIlqbRubMrd/49E
	 NvosAJTM6cIwR/mkvVhwuDIsCLSWf87ADzaePkwHKbb3sXFXgrRc3rFZ3z4sU2OrRY
	 23AodH2CxfINTr9tANFA9zzmg6PAdOBc0ctcLVFCrgTYqHwfPgz70RRacHqz2Z7o4r
	 JXoqvJFqVB0pC7KpbxwQG371NDseDp+ra6eqLNOIdMHGKmkeid0jR6w42PhXgsW6Q9
	 XXLx3I/bne+Kw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 06/11] selftests/damon/sysfs.sh: test dests dir
Date: Wed, 24 Jun 2026 22:07:49 -0700
Message-ID: <20260625050756.91115-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wbbiqe5unq759qeikiyiabkotb5rtsta
X-Rspamd-Queue-Id: 8DA5B40003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782364100-857836
X-HE-Meta: U2FsdGVkX1/RadtmNchndAHfRLCeHOspGfBzCkF+h8xv8OJHEESwg4cauNgOUoj3g2pMs6HX6wl6lrhXNOwcsRcMlJ5AxbQpoHQG8W5fSJh2xsYsF5vyF52h1tbFFhdiP1oF9gv8GRS7BgvQScYJ9Nss4jCV+BmNAP0TU4hO9L5ZKYnLh9axfZRAQqiikEF69fKgH1fZM2Uq2KUZumfxELUmFQuuB9Zler6rkjNTCWQuG7awcq1oQfmpQCxQyovXb0jZa6jnvvO19Y3EME0aTx9Dql7rVUqNJBKIrw44V8GXtvoWo4teZoZFTXhwfwpSNOUAyMK3/W+udA6U1/9tPUCbqSxD03Xq4s0kYqyeotSNh3413HAfx9oVRvyfhEdWve6IYCKM34zgBVuFKDudpUE/EdHvfzkPbgM2OZI9YBSHgrYLC8P8qApniD6cEag/iabtpMbMOTAGD3LIJSA9B93cZtT3UwxQ0rT9qOEDKAL0L6IsAT9hnC0Q6h0K3ouHtDL+vdH3CnuRD/rxtbJagGRZd4bl5ObfNBV7ywPnTg0Bwb4b3tYY6s0mp7U5BNN3i8KkjX55XyT2ehyYP3e09fk2wGyVlNYmCkCj+B4Lea44ZVI5GVNbQ0wXcZzKZuIdgSf4zqtKzCO4t/KKEj/Zm6JYRV3js9t2rAplNgYwsjU92SMcyMJ2ALRDWnIYnlAum/AgM4yiHq3pkkvYnKl/IcQm9TEchPVW66WiERfBgNVsItk4I1+coh9sdnQ+H4XGAOJS1oFq1ZaIy/4KmWShZ11DV8wszJ6x62Vmwr62GnmHL0p5cFyhY1YePeLPHceyZYS0VjP3maCv4Ot7+41CCkcDRPLgEjwZrjprLSwdfzuynKAbDaR0wEmwE1SWw/hJaR+bFJbbJNJD0qafWtETNELBc8lVDRuakIwlsQTplrguyshE5SEbup60D4X3vt2VIqBxoP8utwoBDADbDL4
 WaL2EG6Q
 IC59EHuK/fjh7FBeaW2cwHdrPP1vpCPQdS7Y2FoJ0bPwledy86nj/GL51ZPazJlL0WR2m44Wj4g8v0LMN3pT6VhWqa1Bv7GkMVNJMqkEmKV61v7CEC/gjeSJERMcfeMqi+oMBXtxe3XNB4+LiEj7Y1+7vSiIuJDLpyTQ1Su2qzlzdawvpcsnS7FdikLWpvkItaeIJKAUGy9YO9iaRurINlRXsvxK5SWO5H8dk4Bl1+Mk4nqXDa1aTRVl2VLRN78RB6CV4zjx0X4FzoYiOZqPnUmPiYczINvaN7ojpWmANhVFkMvY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON selftest interface essential file operations test (sysfs.sh) is
not testing DAMOS dests/ directory.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 07a33995be852..ffa8413b5ab3d 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -99,6 +99,29 @@ test_stats()
 	done
 }
 
+test_dest()
+{
+	dest_dir=$1
+	ensure_file "$dest_dir/id" "exist"
+	ensure_file "$dest_dir/weight" "exist"
+}
+
+test_dests()
+{
+	dests_dir=$1
+	ensure_file "$dests_dir/nr_dests" "exist" "600"
+	ensure_write_succ "$dests_dir/nr_dests" "1" "valid input"
+	test_dest "$dests_dir/0"
+
+	ensure_write_succ "$dests_dir/nr_dests" "2" "valid input"
+	test_dest "$dests_dir/0"
+	test_dest "$dests_dir/1"
+
+	ensure_write_succ "$dests_dir/nr_dests" "0" "valid input"
+	ensure_dir "$dests_dir/0" "not_exist"
+	ensure_dir "$dests_dir/1" "not_exist"
+}
+
 test_filter()
 {
 	filter_dir=$1
-- 
2.47.3

