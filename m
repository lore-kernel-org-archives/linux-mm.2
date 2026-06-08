Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1A87CD8CA8
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271756B0088; Mon,  8 Jun 2026 17:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112306B0092; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA22B6B0093; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF5426B0092
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:06:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9172E1C1DB7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:24 +0000 (UTC)
X-FDA: 84857978688.29.10AE182
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F6EE1C0006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:06:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KROTr9S0;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uC57su7lQhQO1NelrjFHBLfbzQzxYj6jVoSFj1yoiXE=;
	b=ePcOL/DiYdo4O+fgvfcZN5YQ30mG7TQYAq8siou2OJFhjkeNmui/cWSKP5bel4oJwBlSKv
	eHWk16GjBHu3VfSYkMSWS3+hogD5PEuypRZj4iG6E6UiCKUsaOXLMRhcY0f1v73g0Le+ZJ
	PA0ViIuaEXcpJBM1RrAhVFeOxuXwrNk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KROTr9S0;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952783;
	b=h3mXPEGihK3Q+LmKf9kDqbqoepBZdm1ENTWJNw41eGr+SVw4AeN13XjnuODYBzHqqMW+MA
	fM/X289W3b5aA12XsIo6x2f+Z4+9ZIrdVt+MMfhf+jDAp6GyCC3X1seCK9De9UJErZ2TY/
	k11uj0J1eLiw4Fgi0HcSHuhPf6gsqTU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=uC57su7lQhQO1NelrjFHBLfbzQzxYj6jVoSFj1yoiXE=; b=KROTr9S0xX7mmTN3ichkij6BhP
	5TUMSFKNc7JNU8ZXJSU77mMLY2dt+E83FTj+WG4WPma1nJt+VEQUGfe+SA89ZwPFloHDbLXq+XRO3
	9Z1E1Qv3wV/peDxQVjJzcZQw4wM4pTesRuRVjEWdPaENeB73bqntyuYwb64yCbpaC1MJ+XXbjDgnE
	xvlilLt7d10XjGfdvsaXp4yPe63J/4JILdFWMHRCfnEedojZZQAeNDzYYGNiVCN+twA/llkW/giiF
	BijelPH+kcQUZa1C24P78cP3MMCXH+c0FmZF4j5CYOd5n0Jcr4BHaOT3jcs8gHSXrBJsnrV512xbs
	9SuXJ3xQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWhAr-0000000EQBl-0e9m;
	Mon, 08 Jun 2026 21:06:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 6/6] mm: Remove __folio_index
Date: Mon,  8 Jun 2026 22:06:16 +0100
Message-ID: <20260608210618.3437216-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7F6EE1C0006
X-Stat-Signature: uraio6ku6f8mg3ny8w8fwjmfoeinbyug
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780952782-363882
X-HE-Meta: U2FsdGVkX19PHzuO9+b2hhUB+r8kOHxDLPZ5hNJOy5tofIvOBJgPPwDphOWdLnTo04ams5OjgjqQZPgx4CKW23Ly3ZbU+461MwdK+BbOJk7G8cG8+uRYhsYWB5w04IJIBYqxqURbEPSQDhr1YPxVNPoYtI78ZatGLUbB4OtwOMLCEyUotjYuh8WhjKOYoeE4hyw35BMDRoIVup0+0s8g5TCr/nmzLhNbZMbGOJDulDwp2FvFduMH6MIIFbqucmOaIPL6uTuxzRNtE1NCGqM57piP74z/utPglOSyuAjFqg9XxwfMz+vKYMnIP2QxQAqf6IY8WHWmoP9xu4fNZRSOY2+AVAXX12fhl/M8PjD2xRZtzBNmSjYukTH/VLsTO14J9DdscOYWk5ZN2OCaoIMahpOWBYejr1b3/nuIQQAM7z5vyXzxOEoNxEATk5HPdGmn+Sjp41S3mKspbp/EdFRfayVhzDkYN9aTxMrm+jxwbMFSO3j4Erm3BKPV4ZJASTc9TtFE6KVN87n5jCNdYDe+N700+aLSl6BJDnB9ciybRWWDvAR9uLFML2Vk3nqo+z8rfn7ymeaiZ+7ICL8k/PuTJJyb+ixR5c/mjBAVNE781eIYyEM/gNe6TpY5tXldrqU2ewfMEzOkr/wF7ACzz+JTadiMwkoIIOHZXHI7eY09Z4hR+Aajpj3anLK/H3/ryro/pat59JfLUnCf0/RqApFv/gPCUjkmm5sB85chlHQ3ZS7pnqvj1yQR9X9kug8IZ36H8wfdS1syUTBEN7wvJ3z42XhwJDrYBGRgc1D/V6aN+jf8ygnWmYVhyOqUneO1MpU0DHY/ar6bY27S8O3pnXpBWNQx3G7P+rdkFgn/tVwyCGeM1Wx0f+YaAy84hVBoOncLpMTpxthpyMirnqb24jWvOWvxAcnC6Oo7E5y5BWETamRfETOq1an9eTQRTovh8Px+1hD7m1qMTyOk+E+MW4A
 rthPX3aM
 6MCFOXUXzOIcGCOhgtmohao0rfGPFeQRDR7y2E1Vr7yyvUsQdGS81kpTm6+te0VIb6LX6eABS6RkzDaqC52O/iJdRy0vZdPtghz6Gwbt/7pP8AIdcsp6BhahLYR8V1zBPAuLjkdvF1XTj8M6CbLY1zF+a61JwnaX4t0Hkl9rJgqyyUgd/Ix4EySIiZuAvFOhUMmBPwZ6HEeuj0NyfiYNtGlW7M3hRjXyq0xXAEuOqjxdZVsRBA7fWFCQJJ2U2lYzbP7UxdkN7+WFbwNkSGdlIsQ4eg0VrGlem9mqP2XG9d+ZnLy9z1ACyi1SVZilbhFV6Ulra1i9Tai+WXIQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

People have been abusing the existence of __folio_index.  Since that
was too subtle for them, unname it entirely.  Now we can't use it in the
FOLIO_MATCH, TABLE_MATCH and ZPDESC_MATCH macros, but that's OK, since
we don't care whether these fields alias index or some other field.
Also remove page->share since all users have been converted to use
folio->share and I'm absolutely certain somebody will start to access
folio->index through page->share if it's not removed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/mm_types.h | 7 +------
 mm/zpdesc.h              | 2 --
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..2f2ba262b963 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -101,10 +101,7 @@ struct page {
 				struct llist_node pcp_llist;
 			};
 			struct address_space *mapping;
-			union {
-				pgoff_t __folio_index;		/* Our offset within mapping. */
-				unsigned long share;	/* share count for fsdax */
-			};
+			unsigned long :1;	/* formerly index */
 			/**
 			 * @private: Mapping-private opaque data.
 			 * Usually used for buffer_heads if PagePrivate.
@@ -511,7 +508,6 @@ FOLIO_MATCH(flags, flags);
 FOLIO_MATCH(lru, lru);
 FOLIO_MATCH(mapping, mapping);
 FOLIO_MATCH(compound_info, lru);
-FOLIO_MATCH(__folio_index, index);
 FOLIO_MATCH(private, private);
 FOLIO_MATCH(_mapcount, _mapcount);
 FOLIO_MATCH(_refcount, _refcount);
@@ -612,7 +608,6 @@ TABLE_MATCH(flags, pt_flags);
 TABLE_MATCH(compound_info, pt_list);
 TABLE_MATCH(compound_info, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
-TABLE_MATCH(__folio_index, pt_index);
 TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
 TABLE_MATCH(_refcount, __page_refcount);
diff --git a/mm/zpdesc.h b/mm/zpdesc.h
index b8258dc78548..194392afd3a7 100644
--- a/mm/zpdesc.h
+++ b/mm/zpdesc.h
@@ -54,8 +54,6 @@ struct zpdesc {
 ZPDESC_MATCH(flags, flags);
 ZPDESC_MATCH(lru, lru);
 ZPDESC_MATCH(mapping, movable_ops);
-ZPDESC_MATCH(__folio_index, next);
-ZPDESC_MATCH(__folio_index, handle);
 ZPDESC_MATCH(private, zspage);
 ZPDESC_MATCH(page_type, first_obj_offset);
 ZPDESC_MATCH(_refcount, _refcount);
-- 
2.47.3


