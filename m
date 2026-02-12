Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BDE3EB491C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46416B008A; Thu, 12 Feb 2026 07:49:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD07D6B008C; Thu, 12 Feb 2026 07:49:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBC66B0092; Thu, 12 Feb 2026 07:49:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC9196B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:49:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6507F160142
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:49:49 +0000 (UTC)
X-FDA: 84435786498.02.FB1E4BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7B3FB80005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:49:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i+ghlEhU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YM719y7E+mTkz8X3h+0EF62k2rhu1PY3VU/uXfzYDg=;
	b=QGonzpHoFJ3TzLyWtr+A7vDKA+N4WMQ58E7//4il/7GH/hTs+lEWpJkK2jksircCq1EuvW
	FV0hofYdAlU71pPK79iwb/jFFQ6PxzaZJ77qYBbN4n9JNOTh8/5PWulv57lF/MYF18kMEU
	YQOirTyHKcinz0zg2bjBYvjCOjJ0Vho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900587; a=rsa-sha256;
	cv=none;
	b=RWyzfznPkwH6wnvl1lZ6Nd9h825mrIMqp8iRide8q+H+AQKWSXAPYRi03j9ZCYRMDOP3jx
	qXOICEaJWDkqZM4QXDUR/Oc8BVJrqh65vQDAy1ddo3irywv0sL09YarxEyi6KrYKhYKSta
	hJpIOJXVfyFbr8iVL9Y6Jv+JGXrEQeU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=i+ghlEhU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of gpaoloni@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gpaoloni@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770900586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7YM719y7E+mTkz8X3h+0EF62k2rhu1PY3VU/uXfzYDg=;
	b=i+ghlEhUBAokYF6pWq4F4U1TvQZATos5uqJqduNi7L9OvvBthfuJGE8a2DK+XoRyJNKeI+
	KrZoR/BIkThME8qfQsof+yyHWgm61UfRXa3YIk7Tbstmo+HrDdLBps6JGNcZOS7fusPF07
	f2AAYfC2FR+UDlZyCcfTr5Gv7PbNcgk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-602-pIi6mzgSOEWpbxei4jKU1g-1; Thu,
 12 Feb 2026 07:49:45 -0500
X-MC-Unique: pIi6mzgSOEWpbxei4jKU1g-1
X-Mimecast-MFC-AGG-ID: pIi6mzgSOEWpbxei4jKU1g_1770900583
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 443481955E88;
	Thu, 12 Feb 2026 12:49:43 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.44.22.11])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F8F430001BB;
	Thu, 12 Feb 2026 12:49:37 +0000 (UTC)
From: Gabriele Paoloni <gpaoloni@redhat.com>
To: corbet@lwn.net,
	skhan@linuxfoundation.org,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	brendan.higgins@linux.dev,
	raemoar63@gmail.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com
Cc: acarminati@nvidia.com,
	linux-mm@kvack.org,
	safety-architecture@lists.elisa.tech,
	kstewart@linuxfoundation.org,
	chuckwolber@gmail.com,
	gpaoloni@redhat.com
Subject: [RFC PATCH v3 1/6] Documentation: extend the 'Function documentation' with expected behavior and constraints of use
Date: Thu, 12 Feb 2026 13:49:18 +0100
Message-ID: <20260212124923.222484-2-gpaoloni@redhat.com>
In-Reply-To: <20260212124923.222484-1-gpaoloni@redhat.com>
References: <20260212124923.222484-1-gpaoloni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: NcYdkw6CDbwYNk57wslik7qgtuiR_x0z3hZitng_9Sc_1770900583
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 7B3FB80005
X-Stat-Signature: 9rrbz46arq4na76zefzyis3iwu47ykay
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770900587-16664
X-HE-Meta: U2FsdGVkX199hme66ZMxIZjXkZkdX9L6KjGX6Z+EqItFhXXPQ5/mh+39ViDKjXHJy49lyN/p+mInNNvshzK5E0pFHdyNMojld1xHt4zTFA6bG5mDEYKr0rZw09wveDHrMpAG0vdchXfULnmVYbh2FHM8BL3XVzpHRV0l8cxBgyZgHk9wYFx2EvxAawYsTiFPBllVdPZsFJLK1vQgfk1e/9gzR4PDtZUtaQVml8p+lRV0MOQRY9ZR8mAIbJFOaNfpfpaktOKzlOtX3S3TMBrSH2VyNymS4BGqZbRt+xxJr1Z0Va18BMR5RaPLcWaerUyokiDKb/U8PQsB/vybgu/0FRY9dgexGEK/QnC73GLPPWjskAPBBzMklbAEQEdd0tlHE8B4RMjhoD91l6UptUQLbRngQQkxYGgrRjR7xrjGegZu8fwSjaGsjTB6NutB3AKFimBguB43IDGVKVjUhUcCRLA5ogzkI9x0pXoJ4wtaMyQzEvtiiay5svPD7b4Zga90MmPOwVcQ7yjLp4CnGzqRDxYmcsB3D/sOgcM0hhpmokc3EqFjendBcc96HuvQWIG0akZ4fR+XYWfEyJs8fhYFEUciBpxxZf3UA9HRCPmHMgqZUigiisaduVjEeGfdqU7qWMH1eb1eSUIbx/DG7/C5ZA2lKPyGakfpNQrPfpEsmTSGRWusJ2NAiMSPUjA0EUfbqlFe+Qrwoe7n8aaCyfi8zoy7yBe3hIX3jCnIJX/wsNneJLNFY1+9CNirLF+7lI44KYgWc6P3igZXQF1+7XjDcjhfU8EhV1bSHZCgQPrmWWEigZcmNLvYv6pKNXyvYfy5EGSTptSFFSoXe+K132Rq9BlBvPgmsBkanggagsiGD9ImneSyIlTkOaZzXs+nLU2vNVhPYyGU52rEKO2D69sCdFtoIYIIdynNL78IDOs6ETOrKdnnacy2hkUAWLYPq97zLlvrcF6cf4Z9No9uNnE
 y17izCy6
 AzuSRzzPiZEGKvZlmcQRfiYaXG6tXl9wDSqP5gH4+iCdd9uRWd+v+0LkmuJjj7KNxJO3twmLVhhF05mqU2knJ0JbdeYWFFDnrURiOhWVkpz4NCwIZHsEgwDVmW7TW34sC7Vl5qkVWhYBJbXpTwCnLlv3LgLup6vEtzLTzy3BvtXH4LSKXutWN6Bt09yuiUrrqmiSkHHISLwRTK5mvFO1dHz9CZeZ5efStNtOoppRN9c+tNTiFNu1LdIt8kpChy24FhXq9E3YhTjbhAAO3edQDMfjNOG9oNUt5mH69vUr0DeeGhcS8uiVIAUaOGy+aA+vhSwvFBAe76IkcMpgEVZd2TMQQMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the longer description section of a function kernel-doc
header with an itemised list of function's behaviors and
constraints of use.
These are useful to link and trace test cases (e.g. KUnit) to
the different behavior IDs and define the constraints to be
met by the function's caller.

Signed-off-by: Gabriele Paoloni <gpaoloni@redhat.com>
---
 Documentation/doc-guide/kernel-doc.rst | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/doc-guide/kernel-doc.rst b/Documentation/doc-guide/kernel-doc.rst
index 8d2c09fb36e4..23e6c4b45b14 100644
--- a/Documentation/doc-guide/kernel-doc.rst
+++ b/Documentation/doc-guide/kernel-doc.rst
@@ -83,6 +83,25 @@ The general format of a function and function-like macro kernel-doc comment is::
    *
    * The longer description may have multiple paragraphs.
    *
+   * When specifying testable code behaviour the longer description must contain
+   * a paragraph formatted as follows:
+   *
+   * function_name behavior:
+   * [ID1] - [expected behavior]
+   *
+   * [ID2] - [expected behavior]
+   *
+   * [...]
+   *
+   * [IDn] - [expected behavior]
+   *
+   * function_name constraints of use:
+   * [ID1] - [constraint to be met by the caller]
+   *
+   * [ID2] - [constraint to be met by the caller]
+   *
+   * [IDn] - [constraint to be met by the caller]
+   *
    * Context: Describes whether the function can sleep, what locks it takes,
    *          releases, or expects to be held. It can extend over multiple
    *          lines.
-- 
2.48.1


