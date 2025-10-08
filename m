Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D4FCCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 12:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F26E8E0023; Wed,  8 Oct 2025 08:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B2E8E0002; Wed,  8 Oct 2025 08:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A708E0023; Wed,  8 Oct 2025 08:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02FD28E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:47:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A858EBA18B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:37 +0000 (UTC)
X-FDA: 83974923354.11.2A9578A
Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id B78D580010
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 12:47:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=jZIETUWJ;
	spf=pass (imf30.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.147 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759927656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2uY5NoijnwdLmleoPPRrn2yh0v/tr1KGjdpZ1mjviHk=;
	b=F2tMBf5U89FI/qOhYGfOGOIOjli/qnZhtsUyFcHnEh1qFbHEpkQdARJjRQwDZ/1S+prvEp
	rOB+k8JjE7OL/RN3MO4aTE9ADoqO2KELnSYiNx6p65x6JmEaOSQ1HSNF2L1wf92df3N4rv
	Pad2IX7Y+DflAk7S9kXG50trVXeDWQs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=mail header.b=jZIETUWJ;
	spf=pass (imf30.hostedemail.com: domain of work@onurozkan.dev designates 178.154.239.147 as permitted sender) smtp.mailfrom=work@onurozkan.dev;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759927656; a=rsa-sha256;
	cv=none;
	b=zSFwsTFTWUul8Cd762lK6vXMT+J+uPjENwHqfueNkiig6OTBt6CRKhOSh5K3pnzUncRYrS
	KyUqWS5WSY0Rxz2yt3J2YDxmJ8CgyB7nnHwSuICsh3eihyOFpTxaosYmGUKp40XvTmZzFl
	GAf5URm/BwIul9QT9MzUru7MVhklYKQ=
Received: from mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1b:3715:0:640:1185:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 35F5880732;
	Wed, 08 Oct 2025 15:47:34 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-74.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LklD46OLveA0-D59SuP6u;
	Wed, 08 Oct 2025 15:47:32 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=mail; t=1759927653;
	bh=2uY5NoijnwdLmleoPPRrn2yh0v/tr1KGjdpZ1mjviHk=;
	h=Cc:Message-ID:References:Date:In-Reply-To:Subject:To:From;
	b=jZIETUWJfKDZBha4rR9GU61rEsPoWRPnta/4npIBviypEjNMjfHwAtG2UCmdOVi91
	 Nh0XBjQafoKH2JbdN8iFqoHwDoAr2Zd4V3BH7YEEL5cSxf6d12TSqfXdUxlo9sjnJK
	 eM9hO3IRO2qqHBHcAQdLQsw38NhuKv1MwLbKWFYw=
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: rust-for-linux@vger.kernel.org
Cc: ojeda@kernel.org,
	alex.gaynor@gmail.com,
	boqun.feng@gmail.com,
	gary@garyguo.net,
	bjorn3_gh@protonmail.com,
	lossin@kernel.org,
	aliceryhl@google.com,
	tmgross@umich.edu,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	acourbot@nvidia.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	corbet@lwn.net,
	lyude@redhat.com,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
Subject: [PATCH v2 4/4] remove completed task from nova-core task list
Date: Wed,  8 Oct 2025 15:46:19 +0300
Message-ID: <20251008124619.3160-5-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008124619.3160-1-work@onurozkan.dev>
References: <20251008124619.3160-1-work@onurozkan.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1bypc1965uu546gxie81asuaxya4kx97
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B78D580010
X-HE-Tag: 1759927655-565750
X-HE-Meta: U2FsdGVkX1/1dj2BrAcPGKClNGNjDBaycMCZJ3QK7mxyMcWx3rhYOFq9OlHFZxTMZlWVS9JHX1gHX2IFZjhWE1JVUyRaMcSOme9QwwHurvBQQurcsNK2bunJimLDXsGQljcjGHRra6goei0mec548l5Jq44CKkPgY+xzzuL4QRVrtg7K6PBknibqd3UxzQf9hJj3LjcP8vOMEW4N2Mm3r6XdqogF/huKfA9f9TqopbTnaS9sdbwNNsCLE4H76MlxPrkUSEVxi0Apa8V+H15erp5FWT8D04OP3SBve8KDCLLKEHXKxXpQHfwPdW5sgHkSodUDKITfVJH8anJZ/6VqVabE9cuTyplDephjwI03QMuEcrWLKB2wu+x2ZxqWjcPYyDlffkkZjH3DrssTMJ0slttPtLC+pukfAQoLgUjnutPVT5DteIJB6vxLPW+3fj7NNKbbKyspI9GQYWBhBSBDfpGn5IEr2XUuV/S0Ab/cvDGDcLhyrD6jp+VPuAIgDwJ/TqBtuAVHOiOw5zD5UbwfMcdVjXa5Sl+pC0MbI7JcREUgb5b7uxnA1hu2Wez+HpAvDWhM9qYuk/8VRwKsXGrFUSuugLOkobl8Hkp056jxX/6By1l/PtZ/5FXXsCunhbIqi/+DU5iGwBuWMslGwkUFD9TOcpmAcZB+fp7Mo+XDrTGgBLO4muEHYxbWYfByhAG8zC+tFwMOV+KXw14VpzzvrWe8Pga6y8Lr/r2ADOEhE41zTvi8OQKk8Qm2w+wfUjt7Fvuw2VGGXAzjbP/2EsP59ahcNqAkkkQxMZTGsPMrZ+gedm/Yz+KmMCyp8MGDjuCnzEJ3A/+9YB5ryaHjUImw3w414MB5+FdFP24hC0ovLsmX8u5Obg7YhBVzTIkSoWuhM99ZXqWdxXz1iNDfxyOdkv3RGEbZIgIe2hinQAIwKa+eo3TejRF+Wn8kzYUdgYPMmMKa4tAmHAWO60YbbRL
 0LT0Zgq2
 1zf1Q5Oy+HWGx/QerpSiXa4GkAKZsqnWgvwG4NC8X16Jvk3t4N4S0jYKnDXjclikTQmy+ShXfB1GoKtSTTrOEXAXLYeIZ8oa6GlxAKeivHiSHYxMf2+Y4Ve/BIytonh89u+UbxUjtkm/B5UdcOJQMJ2aR4kWOuUD8oPH8MiUD++HHCMUgn46zulVey9721pLUmY5kARchUUM5sUQ3l9JkyMGTMluHGaw9FNHYjC7GxMqfkhAH+PUp7iYqjOdvTCULe2IDHVyysldnddpL0FP0o9E6q2vEdxmK+ZlBiwk1EN+HQHKa/w5RIcc2uqqOCrx2hAtpB5W91Al1zEymBR1baUyMlcZYAaanpwSCkNd8s34KmL2ftVmVplegsAtI3PDQirJswuoI9CnK1Ag=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The task is completed in this series.

Signed-off-by: Onur Özkan <work@onurozkan.dev>
---
 Documentation/gpu/nova/core/todo.rst | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/Documentation/gpu/nova/core/todo.rst b/Documentation/gpu/nova/core/todo.rst
index 0972cb905f7a..de70a857fcfd 100644
--- a/Documentation/gpu/nova/core/todo.rst
+++ b/Documentation/gpu/nova/core/todo.rst
@@ -210,14 +210,6 @@ capability, MSI API abstractions.

 | Complexity: Beginner

-XArray bindings [XARR]
-----------------------
-
-We need bindings for `xa_alloc`/`xa_alloc_cyclic` in order to generate the
-auxiliary device IDs.
-
-| Complexity: Intermediate
-
 Debugfs abstractions
 --------------------

--
2.51.0


