Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2776A606A336
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E5OIPJD4
Received: by kanga.kvack.org (Postfix)
	id 25CE46B05C4; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF9D6B05C5; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D51A6B05C6; Tue, 17 Nov 2026 21:22:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA7136B05C4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E4EE12063F
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:38 +0000 (UTC)
X-FDA: 85446641196.12.A6E84B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C3A2320008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5OIPJD4;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794968556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3VuRAkKYe8EHkp2JgLASOtjfe+EnSMbvCKOCwj6jzs=;
	b=CMOi3hGEUtqRV2/wbSHyxW/S1Q6U+IEXgUu5L02yNvo8cJHkyUQdlI3+Rc6chgN16oCeqR
	j5XwurCy9q9iuMh3JfbDu7q601jRUO1jUScyt4s7dzo0MWuF1PqUZrFETPtbxTMEZJg8AJ
	aKTmMZlxZ6nWXqVdqGrdbZRqsAsa/rQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794968556;
	b=6wLfAoG4h7vCszRqg0DWyXeZzcPz6kZOhDnQ2yBTe/uvR43BhnHj4YGalQLpoqFs44xSMU
	eGXPIr38XgkLbhL8jzzKct+9Gu033/A4QYD66jLbEibwLgU/sB+XJmikyyZD3+AwJqIS5N
	ocldI24nIwCn0XgHTvDQCVvutXtYCyY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E5OIPJD4;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29C3945BAB;
	Wed, 18 Nov 2026 02:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89DE1F000D2;
	Wed, 18 Nov 2026 02:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794968556;
	bh=+3VuRAkKYe8EHkp2JgLASOtjfe+EnSMbvCKOCwj6jzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5OIPJD4OmpaRADMH53N0EpGSCnMzOef1jIUENVaS/YVrGBfeNJJb7qMVVUDBEgQc
	 RY4rODElY7V7kq05Q4LJiTfSNkSmOqW/M6OWaTHcjLjz49fqhQFO0lN/8Te5QiL+8O
	 4jnN1vaEQugd4Vz+ePmYCsHkSUqeA6wpenbY5veMX+6Y7dflibA4eX5udJPxrlK2A7
	 0F8wE4A8T9/0erD8TsBrAFf1hz93h8Nuw6QHGiS+Cn8qb92PM+lq52jvrbjEoiX6Ms
	 xEWYiXJMcK8LS4amnLuGy4Fg8mCX237dpgG0ZeHIhzSlWzYCpKWYQpjDz93LIW2/5h
	 1awEoAVTIDJXA==
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
Subject: [RFC PATCH v2 10/27] Docs/admin-guide/mm/damon/usage: update for report producer sysfs
Date: Tue, 17 Nov 2026 18:22:05 -0800
Message-ID: <20261118022225.100659-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118022225.100659-1-sj@kernel.org>
References: <20261118022225.100659-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3A2320008
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: mjoxg13yij4pegs4wpezt19wzarjrjk9
X-HE-Tag: 1794968556-309196
X-HE-Meta: U2FsdGVkX1/lwIKwLb9pndYzts3/DXRyUXcqSdj4RnrkG41JnXhRIaBRHTfi0VKeT9ohObRxLuzdLe0tBnc50jFVuGg+S94JPiCtIDGVBX5AYxrci/mTujDUDIGyOfs9Ku+UAV4AR/qpVoWF9AwbSJtcltWCmvn/lqYG/nyXy6+/DuFIxIG/4IF1VA8kT2/pwc4ked8jjusk/wqcFjDs3y3utsUZFMb9HZaLDqcnPZhEAb/re8h9xv+Ycoq4l03q3tLuKn3bTEEhM5xjnChFEgoHhdPKZUqsNV5oFzvkTF9Q8gqjK8m7qfnY5WKxwfdkd29DVH+H7DakMdbjeFHmJ8iUdHGMTLv7ien7+lSc51P4q24mekIbEDRsmvhqI+5DKA7n8GDU/OrPDYBRslgEr9hzSUWncKHaknx0bB3+obMoO0YyzhBBL7l9j0+vJGXgYkYD2csXvXIuRXwWiwM8uDoFMDwaWXxqNaNBZs5CNUf3tJMBM1WPnWhlvAmFGok/ym2Jrvgqpa9AKHUCRq+vnbDB7s2Lp28MUT6pSLLLDCpIxh0tT8JiEskltO//qzCz5wnve4QKIj7R+vKiyfxYXY1ARqRCqXbN2WulR1RO36Ju0GXVJAXV0WKX99ZQ38FLpd1pHEz1TdPHYLxvy8iqi/hzRP3yNYoRRyGCefNK5/RBPTHqou6O320kPEYkkXTkFV8WmtuoL8Tl2yQFPRSR2TLsuLfhzHBOTAkjZzymKBGywCQguZwmPkWA5J2k47NwDaa+/ne9Q2oeDKoOi2Fq7ogj6rhojvkXuPryUJC+ZHC0uhPm0ZIf6cWWtT2WIRVmqUhXKjrOJrECsO0VYTwz63sNY0/s75ETbl8PPfpXcfK7oGxum4uy9TOO666eFW8UKzixWg/M4VMDcpeIezMP2E9d4SNdIEhKIhJi2YdWXNiUUb3KJ2wfAQi/eWNvK5yhvNQVVcsfJlamQEI9PYr
 TbHX8fJI
 hEPYIvrEtK9nT5cmPwlgXklZ5a9Tk8bnLbK1I/nDadWvTxFPtQbwLzgoP8tIelNAI0Gusollz7qdvPWhYDWw/+HRoEJs0bm/tYTCugU7/hXzu5LIqbq9rNBwZXnK7tEM0i+jvQk4DWUNvoqC7E+drgY73FBWPdu6YO5WkYLqqfaZbmuPUMWDJiCHVALuOen/pnnrgNt4u2/lZoiukB0ReEBoSivcFpKWzKmW6M/jbEMAvJkxVzdYR2u61WlX/r7P66pIIKwWmiRqabk9ITWzwYwxRE75EGO3AfjFm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added report producer control
sysfs files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 35 ++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 6093b1c8fbfd9..644250c7bd681 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -115,6 +115,10 @@ comma (",").
     │ │ │ │ │ │ ...
     │ │ │ │ ...
     │ │ ...
+    │ reports/
+    │ │ producers/nr_producers
+    │ │ │ 0/report_type,producer_state
+    │ │ │ ...
 
 .. _sysfs_root:
 
@@ -729,6 +733,37 @@ Please note that it's highly recommended to use user space tools like `damo
 <https://github.com/damonitor/damo>`_ rather than manually reading and writing
 the files as above.  Above is only for an example.
 
+.. _damon_usage_sysfs_reports_producers:
+
+reports/producers/
+------------------
+
+Under the `admin/` directory, ``reports/producers/`` directory exists.  This
+directory is for configuring :ref:`DAMON report producers
+<damon_design_attr_reporting>`.  The file below exists in the directory.
+
+``nr_producers`` file is for generating report producers setup files.  Writing
+an integer ``N`` to the file creates the number of directories named ``0`` to
+``N-1``.  Each number-named directory is for configuring each report producer
+and called "producer directory".
+
+reports/producers/<N>/
+----------------------
+
+Files below exist in each producer directory.
+
+``report_type`` file is for setting the type of the report to produce.  Users
+can set the type by writing the type name to the file.  Reading the file shows
+the last successfully written input.  Refer to the :ref:`design document
+<damon_design_attr_reporting>` for the list of supported report types.
+
+``producer_state`` file is for reading and updating the state.  Reading it
+shows ``on`` or ``off`` if the producer is enabled or disabled, respectively.
+Users can write below keywords for the producer to the file.
+
+- ``on``: Enable the producer.
+- ``off``: Disable the producer.
+
 .. _tracepoint:
 
 Tracepoints for Monitoring Results
-- 
2.47.3

