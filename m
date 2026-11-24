Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B589606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=koT4gIdx
Received: by kanga.kvack.org (Postfix)
	id EF9276B0767; Tue, 24 Nov 2026 10:36:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0F06B0769; Tue, 24 Nov 2026 10:36:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBEFD6B076A; Tue, 24 Nov 2026 10:36:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B25FA6B0767
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:36:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 352631C44BD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:54 +0000 (UTC)
X-FDA: 85470415548.09.EA24020
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8BB9A8000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:36:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koT4gIdx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534612;
	b=m4nZSbECKPT62Fj7SqYlCbf2S8wYzVKkZHwsi+K9STRbPBjP/SwoWvxeGDXodWXcElWLpx
	+2SvWuC41RFlDU8A9gTxDpsOCWOo3nRGaWfgTYRkx2H5s9m6CLjKYv2kGNh5kcBgCnv1bd
	flSo8cDNEy1/G550OC1kxWqVih6WGMY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+3Kv3h58VrY/LyVwtKRPMKl+l1ZZJYm9dKAaxGeEwI=;
	b=8UOFqC0oYYFgrhvCwahcQWbIeUpFzb5VXq++T6g4AVQ9r5HhrVCZE1gWPLW7y5vh5eJ6x8
	sH5P3FXnK/7bAdxRiCuH5FJnxzU5cNy7LmDxnzU9mshgB2cWwj6vQ80UanRXjMNgL7eHaV
	XVqC0AOQWb579hQQsdfvFXjl8Oid3QQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koT4gIdx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B7CF6243F;
	Tue, 24 Nov 2026 15:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6091F0093C;
	Tue, 24 Nov 2026 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534611;
	bh=N+3Kv3h58VrY/LyVwtKRPMKl+l1ZZJYm9dKAaxGeEwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=koT4gIdxpF4Gd7m8AN/75DamYXS8Pc2Hxr05MnBc95/67YqzKYJlIkmXNC+CW/Qhb
	 KjBC5U1OLx8wOlh0BCwApBYiPOXOxu875taprrq3CssrNy4yrW0pJD4vbDk3eUU73J
	 kl3E4Ezk7FE5Hsd993P9m3/m5kkDS5b4eNu1YErktuKIAyW4EVUTq90BYjFo6GWtgC
	 7a8UKJ9796a/V6TH20cTgAVCZacwpP4zskFsLIuQ+ZkW9J+dGdYEKTOvWbf+AOjHHt
	 yWYpk60Uge0mkE1XGTmuT9M2UQQOJb/JX24i5E4NUFUl+QyfnzGwDw5AAQb0rXSxPM
	 i9B+eqsFZMOZA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 10/27] Docs/admin-guide/mm/damon/usage: update for report producer sysfs
Date: Tue, 24 Nov 2026 07:36:16 -0800
Message-ID: <20261124153636.91854-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: unpksop7de3dcqmrsratcq13d6pakucb
X-Rspam-User:
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8BB9A8000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1795534612-929806
X-HE-Meta: U2FsdGVkX18HwFJlXzqe1j5AfpzRsgnDFIM54nszO7XxZdbUaJNsDnyoIkAZT2Y369/JiC+G/vGcpy+ixpM4RwGojpzICXlxEkCLAJjI8IAdugTnDgBNKAbVnFDgyvDUkABSfoiNnxiRh4+1+z5BY4mffEnUyDiM5X4SWBWlm97Kkc9qSMPFT8szdeXnaGTeTR60hn/A2/ZM81A2ucNVou/465z6/AfiLNHb+QG7dYLlbyyJGKhODr9DEDR6JctPvJvQgrQ83sNAr3jDn4lz4SCtBSoN5z/EqKwsa2LnOOlm7ltXhGrG9QGmYYgAz67JpehuL/aJYQU8S3jcRQLnI+pFK2ohnT7OGYm6UelUUw9vH7CVw/8u5aiIWA9/DeYjXVjlhgB3ROeq7C04UEgF9gxwJnM0wYP0YxuOyBAWOta8WD4YywRk0/s4OVa3QnPtWsUxxWFpmRMOfMqaCbhBcsjogqw15jl/9s/+B6cf2avOe6WtO2EANQBE5Ow9kASqqMch2idjTNB0Zw0MgwnbF9wSNwTjEkFvF9E2TL0F2iB/QvolWtvLg+F+PJO/qjSbUqBFcfUfHqqLiyqgdxI7SYREEQTFKX1crg7o58CB4QeudrT7N9vZitBpNE+W/aMa0fEwCHzcdxxvjzccwRqvKy/h2GseLWOmWWQNI+UTzmrZQMF5zAHumEQVd0d9mUKfNP583/3Afcgi0pcxX1Qj+UDbUE85ABGeivYzs8T26oQoaeYX4MYpHC37Lpf/jxmjnqdLxQZgP9AaCjHRSoXANdSl86rFlmfj1tzfM8PP5POH0vGHQX8j1dz7XhDcPCPRE+hqZpO/q+VtpIv+9VL9PnQBecYQ0cBSmN+sz0u/u+gC79dGeASzyp52ZLIrRYk74B1518atguVORp6Elb7sAdb7Q9JN/shhmqxeDdhL1/X9cqrtMBUio6Rlf5rHFdokyEBBtxPRty6FPgxmeD8
 045lHISQ
 cqclvvvf7ecaWGja0V+dbLdOdIik1Jfjxv0rh4o+79lg/1jxXxqggEoZNBFiCMwyIf0BVEbaQejJj136emL528GtsymsSVBVRQC8sATDwpR7pcQDeco5xr8jYcroIwM20V+Ukkm2WU7ff9vvtoV+qRGZzCM7lMZ8OxnJcaPdBdtIPMKnVN5+ZChXx0ay8dqTNLtziRoVTb9a0TcqUkWub5roQzl1Hg0hwC4S+zc4XHFzN/1K+z9kRgh0DJvjhwdo/UmL7JXO4utIWZoseQA6JoI1lJfhQ3zXRWGD+wbFOjZIUugWiwyKA0FioPUXZ4Oj8gNpNF3XR0W+IM97iNt7eUBl1jZP/TMQ2gswESZdSEH+a6mICtFWNKi8wVQR7Ov5tlemv2EGAVld2wdBNiJVuIvsTkbrZNMpHaZz8fQcEV+yPtE/cXbToyxYsdPW3rRBl29AEVggtG/IQzTATsAHsgZKAcEWuQN1Grdv5rK7/50vJiPbt91Kd3qoW/bE3ecAAVyPY30xGc6TZHxF4ktkc65wHB8x1cRPTuIhm9FD7TGV7EtRvAyBpK1/3O26MIsrrCRFhMAZc95CAMNqiehNXYs0HjjHxRGcd6us3ZPB1gdi6d80=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update DAMON usage document for the newly added report producer control
sysfs files.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/admin-guide/mm/damon/usage.rst | 35 ++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
index 51c4909f1a8b2..5e0633b5879de 100644
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -118,6 +118,10 @@ comma (",").
     │ │ │ │ │ │ ...
     │ │ │ │ ...
     │ │ ...
+    │ reports/
+    │ │ producers/nr_producers
+    │ │ │ 0/report_type,producer_state
+    │ │ │ ...
 
 .. _sysfs_root:
 
@@ -732,6 +736,37 @@ Please note that it's highly recommended to use user space tools like `damo
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

