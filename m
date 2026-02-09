Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D9AE94614
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2F66B0099; Mon,  9 Feb 2026 17:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAAB96B009B; Mon,  9 Feb 2026 17:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D752A6B009D; Mon,  9 Feb 2026 17:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5C146B0099
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:14:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99F09160257
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:59 +0000 (UTC)
X-FDA: 84426324318.06.314E652
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id BD43014000F
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:14:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A6dNxiru;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfMwxb5ebBgIfUxMHIxl0ciZs5Chtdyy20TmiqAu9rY=;
	b=KBAW0HFlxRxkS6oMYglfyHJqh8Lxl54sUT/ACj/ggiHdszHMhsVnAp4bXe4zNpQEFVErKz
	vMfa+SSQfgJgDFxLIgAXh1+RaAfSZZpbRC6AjkMHfrvBzQEFZa+IG7aMQ6iAGR+S6XPoh2
	RiYGvz4/NK7y09ymcx8T0d21edLLfF0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A6dNxiru;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675297; a=rsa-sha256;
	cv=none;
	b=hPTIvNMz9uXPxvV0TF2+Ttbmb7N89IWxlmu6qQ89VzjZZQh/jitGeKttM0B3yT/C6vYYvZ
	pMQ/+CEcRN4eG+FdBU8SI70VaL1dQhRzDe3F9S/ZAeZIYZQ1qAMBbsT+HSpxwOQuh6IPTX
	hFzor+7ZhRQSGF1lQQJsXtI8yZWkWcc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cfMwxb5ebBgIfUxMHIxl0ciZs5Chtdyy20TmiqAu9rY=;
	b=A6dNxiru2R6X6kJDE5R7urOIxxk8kT+5iEYnAPcvh6VNIn+jNruqNK3+ze+qBv+9wCQtQj
	R2twNMPxTo3z7chulM9TjrppZizIgczqZfG8X3zAI9TyWzqKmP6/Wr+WtaDeIpNsA1koCT
	yUDkfk0ZJXjcd9beIp6qqlD1o3qe85U=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-mn0I_KVsOKyBbU8sB_W-ZQ-1; Mon,
 09 Feb 2026 17:14:54 -0500
X-MC-Unique: mn0I_KVsOKyBbU8sB_W-ZQ-1
X-Mimecast-MFC-AGG-ID: mn0I_KVsOKyBbU8sB_W-ZQ_1770675292
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFC8918004BB;
	Mon,  9 Feb 2026 22:14:52 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 807B018003F6;
	Mon,  9 Feb 2026 22:14:51 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 05/11] drivers: nvdimm: use pgtable_has_pmd_leaves()
Date: Mon,  9 Feb 2026 17:14:27 -0500
Message-ID: <3142e595b73685be8bf4a4657fdf10b28377acb8.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 7yDy3l2_27DXl-FjcrX1eraa2oUjT-LEf7HUlzKXQas_1770675292
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: BD43014000F
X-Rspamd-Server: rspam07
X-Stat-Signature: tnrm8rotf8ahmti67xao8dksx8psgnxw
X-HE-Tag: 1770675297-7060
X-HE-Meta: U2FsdGVkX18pnabUunPnliUJbiZubIPqz6MLig+Lz9wxMuF3RP5vgGep7A4RzLEuTCX+LRfzs62Z9/hUlAI2oqm1nI5AZzU61AxM2gGkGXA4ENxZSU22ISywsjNs76Z6LO7tqiQTTMwZJgIQ2soulqhXucDm9Wo3cpKnuoMUAoF6lxlY2lsYPTFNLv4eN/icpM1FFatFUlf1N1ij48+1s/W8j0B+t6GtqXKcRFXbw0KlB9yCP1OXeTHLv2Yfx2287bodFD4gY+rAcGTxTiXP5yCfCbRYhaeZOWQOarfqpDyM3TgQzCgIaUxmQjKE/cIMuMOb9Ugj94Zm6ylIsgLYUv7PDfwaEN03drkH0V46/1D2kbYjmJNSybW0zzpVCx2sTbP8Pjc6TqP1N7yZaPCb81U/ix3ReonmWVMwMXXc/KQgF9UHRCZX1oYUZpMJ4cUvXSwtlnL4MSkIG2vwtylvp/hByJAGt3bJNWtiGs1h+a8bhktcKvwIBuqPfNN5q7T/hplUH5jul3TlF+GxInEIlAGa3wVy2ceLzL3J26Vr86gB6p/vfeu9DRfs73YWWgTPU8Bjldo+T3FPLFfDRW/+MpDc/cUjS/a+CXg8CRKSRNGh5a+nXCyqrBMo0pTYeFQWUPslRbXwdqipchTQ13moqS+kVdLAgQ/OlO4BMSoWXEUTQT7kPwnQXomuUiGdQo9cmyPVyyTm9tCCgLnGpZHlhpmJOwLaVwxtSDuE9ze7Cf2ueWzC09gJEtRJgKBQJJq/y4lQvQ8zOYtRrc5cbc8vUaEoXlkxtpAiWwvXfgnAxPN71MtQzXwcf8inYYesC5IxP7o66ilhjue1zN4MjPUhWLzWLxTXBxTtKAYQtxhlzWJqwmNepYJNoLERE6Yq8kqayJuGZSLGp6bkxq84mFkDpWBnoIjbM2vP6d5y2sMEtTqEwIPGDLtnAIYPapDJfb5Pbe+DizzpYNp3Q1IECO9
 9EBnKqU6
 uQTHdWI7I6Q1WG9NsoI3uU2KNEq3faMfUjQJNfh5mxCjFPQoyPNrQ0HnccFdNKnvkhO2+vK+sr4XEvc/A1uMpwJJ1RN+We81sYMNPnmkjjNbfOm1IN+08lD5GaF2SB+yyMd16uHt4MN6RHCxhamGwZ8hsiWAmQ1wsLrTRmLBTqW1OxKM82Pu7JPPHdstotlG1Zyb59pnmeecy2FITq8BGbkxNl8wCz19kzEhoq/q976sjNPY+mrFaVaEB3jtuD6Mh6o2VoNjSDdFytTopgE20Po9aOEnF4NNC0WTamENTcaEBH2ofzXpgkzmOV/UMOerxHGCltNZ1TXQ8OjxhSvzikdD9uiF/05IqwguHKmyiTHvoVg5DtWmLClTgrBvB2+GXxss1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nd_pfn_supported_alignments() and nd_pfn_default_alignment() use
has_transparent_hugepage() to check if THP is supported with PMD-sized
pages. However, has_transparent_hugepage() is being replaced by an API
that has clearer semantics. Thus, replace has_transparent_hugepage()
usage in both functions with pgtable_has_pmd_leaves() and a check for
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE), this makes the intent of the
check very clear.

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
2.53.0


