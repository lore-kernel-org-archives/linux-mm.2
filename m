Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 756BCD5B866
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF096B008A; Mon, 15 Dec 2025 16:17:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF366B008C; Mon, 15 Dec 2025 16:17:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70FD6B0092; Mon, 15 Dec 2025 16:17:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5F416B008A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4214D588C3
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:14 +0000 (UTC)
X-FDA: 84222965988.25.A52C78E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 77898140003
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BXWgvWF2;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2bDuFnJn8jNM+Moo2Konu58lzgFdzk1j+TCq2m/eW8=;
	b=qMxDN3vwFOjFq7se9Tq/jwyrYA6/OxBLEaMCXBlw43pGr9O958lJ0B75PJpSwi4QS09ddX
	p9GXISsNy/L7AFKfrxDd5hVcLwMk0Ff//I7ADSRFEBNpSB5hTiQ+ikPiU+H9rGo9coQ2ly
	5V/uYcL8RGF388CA9/YKaq6GEhtVrbo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BXWgvWF2;
	spf=pass (imf09.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833432; a=rsa-sha256;
	cv=none;
	b=vxT0nKWtAjw1ZMl4Nh41JFA/02Qlc08yoyRWY11qXR3JVNzRFO/iGj73H+kh9zpjVof4lV
	Tc5pClPrZCTVqDovc66wZf3abwqLI8k3ZA1L/ql6af9WPyPVAZSrojQC1l7Lmy4iC4zTjs
	AsqX3h2248nsp9osOFBwZvvwb9Dowd8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P2bDuFnJn8jNM+Moo2Konu58lzgFdzk1j+TCq2m/eW8=;
	b=BXWgvWF2PGD6wIbGcizFT7hkb9bRsfendukq8SFS6YE8wu7KlUY6kqW9eMiNjHd3IjCGPN
	FoZFLj8hgfqM4RO3Hm1IwPNkw79giGutfDtQUVief1eAVbitWP7l9HEIOGOvD9knUCIuLD
	DlD4BPL0alwSIiJuQWGAOJjtBL0kmRs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-44-g9_BhdjgNoe9I3vEd6GeNg-1; Mon,
 15 Dec 2025 16:17:08 -0500
X-MC-Unique: g9_BhdjgNoe9I3vEd6GeNg-1
X-Mimecast-MFC-AGG-ID: g9_BhdjgNoe9I3vEd6GeNg_1765833427
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 22A281956054;
	Mon, 15 Dec 2025 21:17:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C424B1956056;
	Mon, 15 Dec 2025 21:17:05 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 01/11] docs: tmpfs: remove implementation detail reference
Date: Mon, 15 Dec 2025 16:16:43 -0500
Message-ID: <6c611c5a46548039e714cda6014d47c9d93fcbb2.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Stat-Signature: au57a6nmr5k1smfihy14d9e5qi68k4dg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 77898140003
X-HE-Tag: 1765833432-129241
X-HE-Meta: U2FsdGVkX1+XpBDu0gZrxgWAQKDRbhjK9LKeL0Jw/KYeqfwxczvPDN3WhrHab9RSj+Q8QhJ7M2O2cpAtto8w0pVGOJTK+U5MqrrLlOMv5GI+8O60ta1iEeftEJbsO7DnyuSuHvAdBj/mOcnrEFU5IfFrimMAN3nBp1wJ+22uyit9ZRbxDaIe5sLt1SGMpHvz/MVX11bQxxwQC5NAInsbXX/sXfsYIbrxrZgWo6btafeG6+kkVVE2qR+SxQYHRCELZLiUULyKg8E5ZGWug7U9vVmyxcBl1Vq/8p4LqvjlyQCvOkVLZpOYjq8pHeDVi3Z4KBTuTOHMQG1a6NzbeDelVuT6knFURWIVOODKuouL8hzpHxzWF/uvZWNYIrqFfyzCN9yXBZ1/vVpsV7wb78s1HOHfrvKmbupdJqtKL5R5L3X7NBra53JRXKiA9CP/e/nwfyTdxW4u5TJmhrji7RoohdslnmrcFTyvs7WBM3BJNb7Ptb05MR+kFdJJr+dqBMkdfPaP7EZ/OqGQr6Dtwd3WkpvuNpnoDCNkVSB0eIpQ5KQSzd//vVGKhe2LwA/zovOwqZChLA3leexWAJ9n/e/hOSOQkGuSbE1aeEMCeArGIwS4BVCxRGrBTNlbjNjeJhaKwNUa2BdPjSeHkUl90dPwD4T2+VhwcBdJpVKmT+3NAacZrJGP5kxJPa/RV3YsCZXdy7gxFDJX2WdPu8wvKB9OPIzBu1iPhjTKnYwZaKOCEK0Lr24GKgMUyhjdY10Pn8/ll55hwlgDMxe2W6Rr+nj3yqYDZhepWhXfTUPR34ecRLv3wSr0aNOwmLG5jyXfOGCrMOIu5YuZ/Do5ucHd2jlBNy3GZtRiLV7mHkI8NtAfvaPO6W4kBqJh9oGfHw5ihaCcFI6Bw7NjU6B2zJBG2h3NOBFC8Ol7RldhPnfMTSEfuzFP4XRu8g5l/FczN+twVWMQaGxjMrV6JmaOl1d+uZu
 IMSnEN69
 v8l6WyBA0PGZvU55JxoPLf8pdF1kbapmHzelafov2x0mQu0yy4smAw2LYZkmIsM5cRCyjkwxSDX2GK5TwLhnRW9CgXYHvoMx73qOPsmNy7vu0Z21i7Bxv7vilGJQu9ThhjRuTrO6qGflA2lnsItG6H0ApnIbID/jAstAMa5BBui7IvdtZ0zVmN4vkuszILMoqwuxvTps82YS4/F3nz9ELcissyjytnpsQ+z90rTrk5+5lY1tzDiAFUrpN02dXyDW5bveKZgYAJmvezyo2WMAIiSw3pi9O0f7+viyaOhyzSzRiHWxYuVvFAQFDwI63ofM4qobfDwC2hEXL5Q0PPCbGdBIr8PMfjXif+ti0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tmpfs.rst doc references the has_transparent_hugepage() helper, which
is an implementation detail in the kernel and not relevant for users
wishing to properly configure THP support for tmpfs. Remove it.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 Documentation/filesystems/tmpfs.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/tmpfs.rst b/Documentation/filesystems/tmpfs.rst
index d677e0428c3f..46fc986c3388 100644
--- a/Documentation/filesystems/tmpfs.rst
+++ b/Documentation/filesystems/tmpfs.rst
@@ -109,9 +109,8 @@ noswap  Disables swap. Remounts must respect the original settings.
 ======  ===========================================================
 
 tmpfs also supports Transparent Huge Pages which requires a kernel
-configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge supported for
-your system (has_transparent_hugepage(), which is architecture specific).
-The mount options for this are:
+configured with CONFIG_TRANSPARENT_HUGEPAGE and with huge pages
+supported for your system. The mount options for this are:
 
 ================ ==============================================================
 huge=never       Do not allocate huge pages.  This is the default.
-- 
2.52.0


