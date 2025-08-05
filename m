Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 644ADC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03BE96B00A8; Wed,  6 Aug 2025 08:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06976B00A9; Wed,  6 Aug 2025 08:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6476B00AA; Wed,  6 Aug 2025 08:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CE2816B00A8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:53:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 762881DCC7B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:53:44 +0000 (UTC)
X-FDA: 83746324368.17.E2BD3CB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 96DBB40010
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:53:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eNHJeRbs
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484822; a=rsa-sha256;
	cv=none;
	b=7TsyMr4/NlHXPCi0oMVYCITnQi/0RDMNUBS2UeOJy5OmdldG5jmE76qJCPJL5jzLyDSn01
	cIER6JlrTkoc4GTvBPQMfXOmm4Z2vOQHEMlB56BE4KCLY95o9fCE/XqhqvUda/SjONU/HD
	uXn8ptQ3lLoRCkLT3Um8DYrqn4NJxbU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=eNHJeRbs;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=F/TwXhbCIN2nm2NyxRgM+sTxCqGXU/tBK3NK8lKHuFE=;
	b=Zyc8a4vY6VEOHS1kz5XHVq70qjFlWUSJZYDhErPs6IhnkHbf+sXfmcJ5E8yCpl5v7jpYgz
	qszlE7MNJ2Hjw7aVNz5q9ACHWLX+fygHTspgxvh74nHVEqYvtYSgOJkkUDDPL7ekDmi/4R
	Z1x3yYzt2uduT6gWKsytPx5xLbW/XS4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Resent-To:
	Resent-Message-ID:Resent-Date:Resent-From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description;
	bh=F/TwXhbCIN2nm2NyxRgM+sTxCqGXU/tBK3NK8lKHuFE=; b=eNHJeRbshisqAajiywkShXXnsl
	ezGEGJCnK29dbXlcL3CQH3q3l4n22stjmj0rZIF/BYFR/pvTdh98+OCCgUXvtm7+zVcJqC+bRXmd8
	k+EPTftGPWLOxeF86Kb4bHSBt80kF8EriuVIUhQbMwII5HxbTl2xYG8zpQg2wFFRrEFm2Jpedo99A
	lUQr37KneVzb//AL/XpFudKRuVmpqh/cN3gVFKOoqe7YsZfLvkiGbn44hl5spVR5LMn5RUbTTR0+l
	xVsFQlF1zqZe4yGz/9GU8pHPcmkJb+RGImb+G3d1/XtDLxvVxWz2g178mwRNJK9I00iNfUpC9IV8D
	y1y5df9g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujdeH-00000004Imw-0NFY
	for linux-mm@kvack.org;
	Wed, 06 Aug 2025 12:53:41 +0000
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujLNW-00000005T5N-0iAW;
	Tue, 05 Aug 2025 17:23:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org
Subject: [PATCH 06/11] slab: Use memdesc_nid()
Date: Tue,  5 Aug 2025 18:22:56 +0100
Message-ID: <20250805172307.1302730-7-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250805172307.1302730-1-willy@infradead.org>
References: <20250805172307.1302730-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 96DBB40010
X-Stat-Signature: uhwcmqcg9p7jctoxa85cx3znx4h3gena
X-HE-Tag: 1754484822-476320
X-HE-Meta: U2FsdGVkX1/R8v57Texk03lXLu80wwaelOCEjFDR9vUJy6g+sNkkAHEUcGhc3y3+yj4a/xOqH0TbJHCmb5DNTvGmFJgAnpwqXmryz4L6J8HlejIoZV3zrATDhxOtfKenm9KzZZuoKktXRskqpyp7jFL7Vw09sBNs7PS9l394dJDiOhXiSbQna5ckq+58Ql+3mg2xs44veUKELi5rk7E0HHtn0AxLwbkHB5SD5ihOvw0i3BCk+D1esTJ7izsWtFfXkBlDzQfouYlzapLuGufHkHTKoJ7R0YVa8QJDShRryOznzg5NwxYhog24OXfwoWseuISR/WfpFsncCpx0BpTWzPs/K1xE03pgLIxPBIcSxHIELVtos5BQmfV9gZNMtZiBovlqTrVd6dS+vq/7jqutGqHEIa11LHbcr/YphlwQK+z579LqVgB49eU/w2/Bn0g15JuMuN1a22ewi3gkQ02nnidjk5v+xIIYwOjV1FgiZOL/ACnEq5UGdwZvOq93YmqbetliwpyiVC8QFzyMILIBMZdses2MvueJDZmrvmdYTQpMstx9dcX93beEEprQH9tPUF5hpUfgqnsoLDToRn94TvqOC5GSGcv02sM3Wj0cGAvkSZOqNGq/krLShaX94vNgkHkt6aXbZSyIomarryX5iy+FmBGZXK5A3SbNalBiM2HowiGreD1moimJ86VYFojTGXkS619lnq35OoMJTXEF98PaNIj2SDmAiIPsPqP2KxUpjdMAN/mbgIOTuecO1xEop3cnBLrg0mXfW0qCuUpVRDW0eXn3v5JOde+2NO657WkcjJq++cXcpHZYyl0D8wjetw+Ztj26RjyH/zwGFn2yb++H13NDzBPuOKHhmQKEG0Ca9FBwlo0GJRZ18gyTC3oBfFQpI8+SzaeTgTBT/ox4trJ9P1GTUtB0KvpoLVa8e7c5TPmKshiBMUlXCbP40jrM8/P/puYF5S2RC17KPnp
 Ksn4BinI
 AJwfv1ZU4zEHnUBnXm5NC0e6T63BJqC5e5qMeStfJeZP73i9JKll0z8C5Cwifw5WJXJlAkVl9RlKEOWRHaPLWo0McZrC3pFl9fuJyRS6r/IFyZbyrPK4qPCK51VxADGrqXDjK1NUDVKp80gSAfeLDvwU4tRKbybfdoiux/xNFM53Uxnw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We no longer need to convert from slab to folio to get the nid, we can
ask memdesc_nid() for the nid directly.
---
 mm/slab.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 7757331e7c80..c41a512dd07c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -174,12 +174,12 @@ static inline void *slab_address(const struct slab *slab)
 
 static inline int slab_nid(const struct slab *slab)
 {
-	return folio_nid(slab_folio(slab));
+	return memdesc_nid(slab->flags);
 }
 
 static inline pg_data_t *slab_pgdat(const struct slab *slab)
 {
-	return folio_pgdat(slab_folio(slab));
+	return NODE_DATA(slab_nid(slab));
 }
 
 static inline struct slab *virt_to_slab(const void *addr)
-- 
2.47.2


