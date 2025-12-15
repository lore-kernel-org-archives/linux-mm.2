Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63458D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 040BB6B0096; Mon, 15 Dec 2025 16:17:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15D66B0098; Mon, 15 Dec 2025 16:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42D86B0099; Mon, 15 Dec 2025 16:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC9F26B0096
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:19 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9F96713397E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:19 +0000 (UTC)
X-FDA: 84222966198.21.4B36797
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id EB64E40006
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FsIc3IR5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833438; a=rsa-sha256;
	cv=none;
	b=Ew0FBaj6v/T3ECGILVXByJDPaRVu4MvbXR30wvClzrHr02vcy3g9SGWD5YW3ffCMcyGJQK
	hJdJuuyPT7rw9He37P1Qcg+5XWveL+ocBhtqkHQZij2V5WlVpnw9LdB7COxWbO1xBJoh3O
	scCiIZAsm7xXueDignY1ORYDg8PvAcA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FsIc3IR5;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/P6T6Sq8RPkTGNp6xWLfjTt61PWY4uHSCHmLz/Yexss=;
	b=6HqgEFpvQJUbSfuUXzQ688BPirTsW0LezOy1lrs7Gn5YcYjBiwZFCy+lerw87YQfvLnQzh
	TKayMr+Bjj39+jWI7aD/kQRSg3DkAMNBPnaUpuhZ1yyyCubDfwvYaQmzxu4BziChBWWtQB
	A5WUOuGHf04sibG8IEhdf3FKOpne9do=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/P6T6Sq8RPkTGNp6xWLfjTt61PWY4uHSCHmLz/Yexss=;
	b=FsIc3IR52LkRtC/hnTYzobsyGKinUjr+vq678vwhniUTIO7jGd0k6VsN4PkxIrFjwvuP2O
	zN6nxyMSSPgdGlfJb63jlWlbbWZj7G7rFgpG1nQtrt57xyrG/uVkfBJNZtAaH8wYqBr4A6
	O98dm11xT54oxu89OlTAZD+BepntAb0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-7CB2-qNcP6KvMrnotPf8uw-1; Mon,
 15 Dec 2025 16:17:14 -0500
X-MC-Unique: 7CB2-qNcP6KvMrnotPf8uw-1
X-Mimecast-MFC-AGG-ID: 7CB2-qNcP6KvMrnotPf8uw_1765833433
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C4EE11800621;
	Mon, 15 Dec 2025 21:17:12 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B12F51956056;
	Mon, 15 Dec 2025 21:17:11 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 05/11] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:47 -0500
Message-ID: <25350b6525e887f1938f54cad30df96be7364a2c.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: EB64E40006
X-Rspamd-Server: rspam03
X-Stat-Signature: fmwuhci46esxy8oa4unr5a1jtwqp6puw
X-Rspam-User: 
X-HE-Tag: 1765833437-379945
X-HE-Meta: U2FsdGVkX18a9kuCRJEmgIURlDkMsR2V6LronACfnyn3jhwZ1aSWwY08DZGZCa7Lo6BpNlZFNMF2nl5Vv+BjkcKxLywig/Q4R6ZnDuEd9Ex6NhVKPt5fv3UyLGOf776wEcOI9HB92p1vcP5kFHCH+L+FUpyakKNLnazAYNLFKkodO0UcMflO0g0ZRQU1Nz8bIYJZINf6nn+JbgYJynnGby9+Kmctcg/kziS6meIvREKVpd/e+GuIf3S3LsFcjgesno2YoD4FYauQBsKwL399eqWUk9iMXjSBZah/gKXGDI2Zsl+4rMEvj1O6jk4yMX9YUWdpgukE5n3akP3lRDawv7Vm4cQhYNq7e0HBcOzX01sNkyh7UfvhiZUmSlCRSRy06V7FSu3eBQDjQ9vpcDe06C+ASiTxoV3OX/UhojW+pDRN4YIMo6PqsZGDDXohx1PXRPviUrMs2fqHVlewYsLKR09fpXS6BXkVWsMJWhfeEGdmkzec6pr7yjrFwHymMMMZXWG3sk3vVf+T/6807DsA+bOKMy5i/n/fDnKEcbJ37i9/CYV8Yl3VyRCWV05oU2gubS7s/7rF20dFFvKXe/P+20uzUnqtCKxPvWSG5Z3Md9QjXyIoLk5+nRfsIY/wIME7v8vUe/k7BpLQEDJVrpl05dH+5KGvDgV558DcZiRFLQjSEk4zg0mrswcH+B2j6/uNwqbVRaAZqAknY8m+sITYLt0FNzjXBSqTM7kaw20tWPuJlnVx1ETWdIqLL4mIjh3+yjqtEC+RDhy9DBOONIpNQ97UKT8ypJLvrrqOpj4/y9XSD5xUa6SSCmFWqGlcSMMe5nteLyg4mfpeQKEZUZkjPXskan835le7sFr5pqrGkdVV1TX/9mYmtdMar2kD7eXaKwsw+OWapqYNM3NsS8NMAN2BjWtoZ3fkAFhbPX2OQTSr3ti0uqpolboFfxsJIuuAoAh2h9WmgBPSnw3QQnb
 x6GkmxGq
 1DD+vFEhVJmWjsgLcxBjOztR/CZ6Bq0Ym5kNIJhG2KlkPXPI+HoBOZSOaR55k8TOWtWDlZwq7iEMpCsKQZmBMFy8l4MdZfzrBrJzE9qnMYNOSQ8NACG6LN6KBwkpUUvbCrdrFJsx0O4KGLZ8R7Nv/wuXLw7voNRtfLR57HthZA/l3wAzl0aaCV6M2VpMFyGFjc4fTwlLZDI/olEvmjh6NLr+nXe9fKbLgwdIarMfj8g6HPWvc+9/Eucf0B2YVJFg+iuc85GbmyMCAT7PzynRph7chYS9c5rNeNmnLjm/pZA6EPaLNVDjpRkn2P7jrXuj5MOMVxdxqR+RHKavC6B8ncF16ydvF5UPy2Bck5DUvnKkaS+eCKgjKgZPh7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nd_pfn_supported_alignments() and nd_pfn_default_alignment() use
has_transparent_hugepage() to check if PMD-sized pages are supported,
use pgtable_has_pmd_leaves() instead.

Since both functions want to use PMD-sized pages with THP, also check if
THP is built-in with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 drivers/nvdimm/pfn_devs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 42b172fc5576..7ee8ec50e72d 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -94,7 +94,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 
 	alignments[0] = PAGE_SIZE;
 
-	if (has_transparent_hugepage()) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    pgtable_has_pmd_leaves()) {
 		alignments[1] = HPAGE_PMD_SIZE;
 		if (has_transparent_pud_hugepage())
 			alignments[2] = HPAGE_PUD_SIZE;
@@ -109,7 +110,8 @@ static unsigned long *nd_pfn_supported_alignments(unsigned long *alignments)
 static unsigned long nd_pfn_default_alignment(void)
 {
 
-	if (has_transparent_hugepage())
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    pgtable_has_pmd_leaves())
 		return HPAGE_PMD_SIZE;
 	return PAGE_SIZE;
 }
-- 
2.52.0


