Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523B0606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ltpGO29A
Received: by kanga.kvack.org (Postfix)
	id 996716B05B2; Sat, 21 Nov 2026 14:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1AE6B05B4; Sat, 21 Nov 2026 14:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80DCA6B05B2; Sat, 21 Nov 2026 14:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44C196B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:33:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8CEAB1C3E36
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:45 +0000 (UTC)
X-FDA: 85460126010.19.3AD1975
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 00C3D20003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:33:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltpGO29A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795289624;
	b=ylHrUxce6UeJU7BF//y44Q8JFZzKeV8BWkQubNuKtSNcTYNf+vqi8pAUUPavy5NUwdwI1/
	HFIsnfPqjDs3cY+5pd469+bp7PXtgudGmLj3z17WcokCJkVjwlfZdZRNlomOw/UKmz6xIk
	8IX30IC29SFqjYqt8+l469ZHjysXvmg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795289624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Du4+njXljVHpzEo98PHsfc+3ZjNfYApucHyMGQt5m7Y=;
	b=FPmaP1wH9lHfI0PiwSxN/mfJgYJOCUE/QVvBiqOR3KWeyDAZozVw9ZijBOuqZazFxGit8v
	qagJr7Hs1RZIkvjIJSO2gc8ZqnnlQhaASOmtrGFdXocKTupfRRiBW+2ej2LwB7GvVQEH0X
	UYaVVF+Z7ag4Sw1+DcgchIURNADhLvg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltpGO29A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 543264591B;
	Sat, 21 Nov 2026 19:33:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B5D1F000D1;
	Sat, 21 Nov 2026 19:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795289623;
	bh=Du4+njXljVHpzEo98PHsfc+3ZjNfYApucHyMGQt5m7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltpGO29A1F5nrbBhSOQmDLG44uZcAg43fqIGY90Nro8h3p36bLZBNqvFQpoRc+GN9
	 /n/vA331PDUbfKYLMQ3gW9cfQyn0ZuLbqeFSwcFekQdjaCP4bP/DL6+w/86qNkRzVH
	 xQYdM55y/ZbZCMrtw0De8koDiXfX3FsfjriV8yAGgcnf5zfIH1crRkgAq23cHaihKg
	 jSBGoRGQZdujzElnNIWV2Ou5HNpi0Ek02mjGjO73Kf/yb2JIgcapOf2uI70P7BRj/v
	 EzwtmLHDhFPbN2e0FH9khET99CFx7O7w6Nci12NvBjZVGO0z/LpoHG/HK+l2Un6V5x
	 aqrv/rtXhW7yQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/4] Docs/mm/damon/maintainer-profile: update key cycle dates for damon.git
Date: Sat, 21 Nov 2026 11:33:29 -0800
Message-ID: <20261121193331.108587-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121193331.108587-1-sj@kernel.org>
References: <20261121193331.108587-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j6bripkyhgo3acteb4w4h8rey343hb7z
X-Rspam-User:
X-Rspamd-Queue-Id: 00C3D20003
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795289623-772418
X-HE-Meta: U2FsdGVkX197IKcOIjKkhy7MK/Z0fUPxFzgDw/glB2fJwT/y1zEfuq0xF2uPZsJFQa9YAe03sYgiCWmmZit9Izy/X3YzdO92dMBmsCeMafla+kP932/bT7PJWedvt26qBF/0ikuMljLO4WOqz3I9R71QpiHF0OyPOkqAGZiWSt3Rk/qkqJgF6jON1oR2pB7DAPxj+mh6CTTeAfyMtQMC1BBH3CzV1ifcPyl3ocS8jmGuNBe8mtkWeSyojMmt5K4pyCst7vGPCfPPwVZdTe87WsyRU7e0N5Gkz0svLYcXq7bTbRac5zNMPUz249E+OJEdpxLDBzLV62pIfZDl5MqKfcohFdn8osaywVvJxTgnKrwR+bfqSyVpVsDB5mw31JQjcDWLtCkR8HweGr15Pswpd2h9uScu37Q4uolZKGOsdmmCT/gncb4jE0e9KKsQzUaVgCUWGp8nPTzxU3z5KcU0nKTPMh3wDvdkW82LvlQM2O8Vf+0UWU8LyT+reBjnd0AeU9SMD+vxc+dnDvokHQkGDjHT1pPK8BQpcSTbLHjKc/2UB4HSNWWYR+BjQFDMnMhhUBi+n+PrMDkNVN9QCP4AEbUfiI3IEufKPqQJYzE/CAST5aBOYWL2RsLaqZcsJ3e97HlG+6WnhqZruyOeZlvvs6n0VJ6JduFM4FHMU22WtikOtQhWr6STuZQHH84RIVE3judsD2bMiltS6C8S3VXgTfi+0OECj47uawy/DcUfDArrLyHKHpveybrHU8MhM8JufAfyW3882CPuMzGsspRVf0hfjDxGGdU4qnkxhVd0bXTQzP1kEr6WQFPXFfrI+UStDEo/06QmCYNTepRZbDyZWd5zUUy21MvpX+eLDrzwwE9x1LA1Di6UTJiCT+E29JYungsnSNbo+1RhCDlNARBMN7a6/tho4OIa2yeiLG7pe66He+vSl1afns2y1LJsYG0AHarSB6y8gmuSLboldwn
 jTKUiEyw
 EpMA0zSMJ614oOI8b3NqlXZfqrT6Dv0SJDF6lVcvoOzn52p4M8lbjvFWyIq8O832RlPSdd3zsNk5MYK1TQwDYDrioNZik8nV84JdzSqMJsRvhXsDn6zFpAPRXtMHtC0aY1qP/h+dV5zvBxz/x/QerkH00cZLvD8gTSn6UuOB9Mqfd07Eyn/bmG35aOZ1aqcYCD4XggiBSprIL0Ej8Q/1U1MMokywy2TSVN5XpqIm99UG0pMcXtGxjW0ONsUQl4eZRrlpyCh88HknLma+851ecvdBp/uYmDKkM1eokyT/e+OhXKYj8GS01TggDTObATbnCZEfymjGq13gX9j17hH1YEp6qOH1QJSstbTV7OqaQEKxVAXWLJeWrKDyEJ4WqGj6AiynsUvoh0rDLVGBFIc2fnbBjrY9j2vdQwJOJCQS3Br6NKSrJYcg5fOVrkq9NlXHHyRdYX66o4X9wJOiXQnOeWSKbdwyL+utfYNz5eebLR2chnjVODxYVIjra1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Right after 7.5-rc1, DAMON will onboard the mm-next transition [1].  It
will make a few changes to the expected timeline for patches.  Update
'key cycle dates' to align with the changes.

[1] https://lore.kernel.org/bed81e01-7303-4957-bd7d-38e3a094e96f@kernel.org/

Signed-off-by: SJ Park <sj@kernel.org>
---
 Documentation/mm/damon/maintainer-profile.rst | 24 +++++++++++++++----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentation/mm/damon/maintainer-profile.rst
index f9a8df2b11e73..75ad74b5b6e93 100644
--- a/Documentation/mm/damon/maintainer-profile.rst
+++ b/Documentation/mm/damon/maintainer-profile.rst
@@ -41,11 +41,25 @@ Further doing below and putting the results will be helpful.
 Key cycle dates
 ---------------
 
-Patches can be sent anytime.  Key cycle dates of the `mm-new
-<https://git.kernel.org/akpm/mm/h/mm-new>`_, `mm-unstable
-<https://git.kernel.org/akpm/mm/h/mm-unstable>`_ and `mm-stable
-<https://git.kernel.org/akpm/mm/h/mm-stable>`_ trees depend on the memory
-management subsystem maintainer.
+Patches can be sent to and reviewed on the mailing lists anytime.
+
+Patches that are sufficiently reviewed will be merged into damon.git
+``for-next`` or ``for-next-fixes`` trees.  The destination tree is decided
+based on the urgency of the patches.  Non-urgent patches are merged into
+``for-next``.  Urgent patches are merged into ``for-next-fixes``.  Being merged
+into damon.git is only for additional review and testing.  All patches in
+damon.git can be reviewed, modified and dropped at any time.
+
+Patches in ``for-next-fixes`` tree stay there for at least one week, for
+additional review and testing.  After that, those would be pull-requested to
+the mainline.
+
+Patches in ``for-next`` tree stay there at least two weeks, for additional
+review and testing.  After that, those would be pull-requested to the mainline,
+in the next merge window.
+
+``for-next`` tree is closed for new patches from -rc6 release to next -rc1
+release.
 
 Review cadence
 --------------
-- 
2.47.3

