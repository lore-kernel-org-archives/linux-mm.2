Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D765606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T0SNnpqB
Received: by kanga.kvack.org (Postfix)
	id 211536B05D7; Tue, 17 Nov 2026 21:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 124296B05DA; Tue, 17 Nov 2026 21:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42AE6B05D9; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD7306B05D7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53C57C061C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:43 +0000 (UTC)
X-FDA: 85446641406.13.3C12138
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id B3872100002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0SNnpqB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968561;
	b=wWuGfI8H2oTP0SOyV3B44nZJQAGbEH1GllgYbZTrXip0zzRUblI76hcMIrdX6EraPcBXtM
	gCNMF8p6VfkNQD6N4ay5b7BA7MCcef58VHOphK0zT2r5xTuPZGzpAOt5iTEKaDOS4JSoN6
	1p3x49bLhpzQnjK3QaI48zIjV3h1IRI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R78z6DX4Eb7n5m3aMS1vuBN9kYcpNJhnmoRj2a8fkoA=;
	b=rVDsnxuNhlZw+4HgxATMHC6ugGib6F9nAp428xewGNxEFMdKT4fxfmZ62pctiTMTqLdbAt
	eBkyQfY7lSW+MLTU4G2cFyglkgIdSI/9BlW3lBdYU+pVwxRrtkwFWzFCiWJLqT3HywnJ1W
	J5zY9KAek9eIw57fD1Ud9refOVNL304=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T0SNnpqB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8049B45C8F;
	Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8311F00937;
	Wed, 18 Nov 2026 02:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968561;
	bh=R78z6DX4Eb7n5m3aMS1vuBN9kYcpNJhnmoRj2a8fkoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0SNnpqB8t6E+4PGKkicOyA2bgdDL/KGqJbfnKjnPtWYCdSM4Ao8uhj+FPBpzYf+N
	 HeQhFnTFHqH//dgs+C5CGx35yY8jEGRhyHyWyrn7k/inqiN29OZLUpGHS4eIjEnSYr
	 +q2Y7PzeRRw3oqfTh2j9sOhWGOgzQQJxSbHUtMEgmJtuiZRUBkhwsVdt3Vo2jbgWFb
	 H58AbiFDMLJVt+Sz8wGVIyPEZz1Ij4Gs58dknyEFqfaeS+RGaBrPgJEpy1z56/Crie
	 Tpo+X3CmsYsTB/WXtE6Cxhy/iB7U3ZKxYYapOcSRBzE1sQkM0oj5BnhNY8EWgc++GZ
	 kpbZ3KziTHuGA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 26/27] Docs/admin-guide/mm/damon/usage: update for user_report report support
Date: Tue, 17 Nov 2026 18:22:21 -0800
Message-ID: <20261118022225.100659-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B3872100002
X-Rspam-User:
X-Stat-Signature: emexy4ngdgmitw8ezsg4jrcbice8uqqi
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794968561-737280
X-HE-Meta: U2FsdGVkX1+fbVCJaPpLPyWpxKp5KIB83+Z4Y+ublRAcAHqNfFjAPgN6jdw4mmAIJZJTt/N74qzwDmN2X43i28f99dfv9znWJm4El33Aq8ICatF7kxHpi72/vNfso82+0C9dCQVtnBfuurtQaO3+2jcDhR06yl/6sDJ17IB1qamGoIBo2yer9xsLObX7urKFXTMhc9S2SzfibRPXbyzBbZsWTWaVILsN5cvio4W/qkRwPAcssBy+CEB1fUa85roEk5S1Wb3swQbgLGkkyP1FGC4DFy2pxLTkj0mcsuabpQEDDTDQTvEcf5juPFl+isHGdGKzasgd+tG9UGMNkYFeBgPRFF3UPxngmtMdL4LAZULpd/f/fpTWNofVPP4ld4Vwu6CVsFvZNTQDFIz0h1LTDtoGIMqAL8XpLoQ0dqUfhLfyB8Op0ysmyeRKouUGkUOzRfIYfQkoU1zGxI4nWGR0uRJbm0UGLsTEeZJCTZH53pjjLuM4rrQH5wgmCcf+s+wXkCXO8jhMkA6clXZhXh68Ova73Y6Hp4HCPudu730ndonus1lsstyrNG/bMnc8lqV3ApmlHUiRj+Rg/aNJRa14qb4sO6drxWYL8Ay/ezReK2bohHEQeLtCqdv1fvy+YmH06MU5qJSRZ5Jwdu4HPuHuKbLYygeg4qP6yOsjzdJo4MqaY8TYQU0akQVEsVM7KTIlJcUTKbdcwv2uGtMtGR89nJa78ENnkqS0B0EuPKN3fSwbRh0f6XmWDekO+BwvoKaZJ8nAZnExdXVZSQW7pRtkW6nidVe1WSZMRpJv5WLdYSk4aX3XdhKGo8LO+FnUPKeC/4HbltcBARzNRrMaBNwyu7BAWf90qmqlMMHWDrIYl4IAl9SKuGiDojuXekkRTakxxqCUszRmNy7jOa321UCGZjrkr9btxFBaLpZcIQVKLJKBUp64Fq1ky2nsVDxtOtlDClTQEonYcPFm5UK3b34
 PAK0mGbF
 MCImPVJlOYwBVFEjcC/CsViT/sqz49LCtPBgGIAKWDTZ3wAye5WDqlQZv4tgZfpTfsSjp8eLoszr1ZSlWIZ69YBMIvfz2TYQiKfH+8TMW1drJVA8ujnVnRhwuuV8RTbcTGPyu6gvqKsR8rgyfHZraxHqP+SA6szuqjB27N7SOeXRlk4sYhEHU/WI2Ym0vvaEYmZywWUDJ6nlKrbuELkCcyGJuxfzibgpkK9xwezkRa/K98qWySamlomF09YEVvBth5kLBhZEGxRsaGvv0XPulZOZcN2NIPJPG115CTSMmlUMY75DnIC61ffycs2nTqtxOjm0M5nqsLDTee7UcuF997HnxAeFEULjPpZ3CifxuqMTjVgjEXb1flwpJrf9kCOzJOknxOsfF0J6Y7D8B22gpcSmETvdrc37PYBZ6C1VlLqG6HG4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added user_report type data
attribute report support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index ce4e9e4c13276..4024dd4e92979 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -117,7 +117,7 @@ comma (",").
     │ │ ...
     │ reports/
     │ │ producers/nr_producers
-    │ │ │ 0/report_type,producer_state
+    │ │ │ 0/report_type,producer_state,addr_start,addr_end
     │ │ │ ...
 
 .. _sysfs_root:
@@ -767,6 +767,15 @@ Users can write below keywords for the producer to the file.
 
 - ``on``: Enable the producer.
 - ``off``: Disable the producer.
+- ``submit``: Generate and submit a new ``user_report`` type report, if
+  ``report_type`` is ``user_report``, and the producer is enabled.
+
+``addr_start`` and ``addr_end`` files are used only for ``user_report`` report
+type.  Those set the address range of memory to manually report .  Users can
+set the start and end address of the address range by writing the addresses to
+the files.  Note that it is open-end range (``[addr_start,addr_end)``) and
+therefore the end address is exclusive.  Reading the files shows the last
+successfully written input.
 
 .. _tracepoint:
 
-- 
2.47.3

