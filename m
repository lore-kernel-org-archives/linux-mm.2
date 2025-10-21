Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EC00CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22458E001F; Tue, 21 Oct 2025 11:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984D08E0002; Tue, 21 Oct 2025 11:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FD528E001F; Tue, 21 Oct 2025 11:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6D7368E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:01:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E00B61405D5
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:01:01 +0000 (UTC)
X-FDA: 84022433922.20.77CE864
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7AD6210001F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gJtlmdlG;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDLrgg+nqjJKw4aq9VppMtv44pG2L3C4aYFxjxK1b9A=;
	b=7RlHuJJyZK39Yt6MX+8kR2Eg9Zel6q1tRIJ1eU5b4gVubr0wmg7AZ6AFbKNbpjL+0xLCXY
	ZbJjC4vp/FxttUAZ+wjoBmCkDSJFdbFisgWA5dxzmHU6frmFU0HxzocyWbcGC9nOGTbQfv
	FpjKaGdkJNFTbb8DsASkLgw6qw1/9bc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gJtlmdlG;
	spf=pass (imf14.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058859; a=rsa-sha256;
	cv=none;
	b=UA71ZWMUvL0Ip3gSAAmkpFX0Ceem+QmbEglxkTzASDddt6+/N/zbSiIQYRjbZleCUExn3Y
	IX0YFlDUtNZ5F3ldG4WVYPYfm+ib+uWrGB8budiqwEqbb6rLSRKLSu9oiSLJswa+a3BtuG
	egNlr5wOMgIb0wuT0h/9zdQ4RVjj3aM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XDLrgg+nqjJKw4aq9VppMtv44pG2L3C4aYFxjxK1b9A=;
	b=gJtlmdlGtmHRjFUXczTpUtiCvUB9qgrx9GCFx3iLh4WDm4CJauGT7FXeqfoVSilLghFWli
	Y5IrJvMelSdrrZ1ppKHXvB77iZ/qke3VXRE8AimAOj03Oag6jEdz9MaEc9xRwAz99TSDB1
	0hLT+RJmhMq4g1iz2Sa7swUdWq4Nyoo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-alXXF3CPNEWjFRoeJZ6hUA-1; Tue, 21 Oct 2025 11:00:52 -0400
X-MC-Unique: alXXF3CPNEWjFRoeJZ6hUA-1
X-Mimecast-MFC-AGG-ID: alXXF3CPNEWjFRoeJZ6hUA_1761058850
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-471005f28d2so22199285e9.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:00:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058850; x=1761663650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XDLrgg+nqjJKw4aq9VppMtv44pG2L3C4aYFxjxK1b9A=;
        b=KQHSXe692dWnlEpKc9TnwzFNqPqPBRIJaJ/Vnn1/bR+fGCPSWZlVQKMXK7U+YWCalq
         YS1nLnOjvqDOXNinJfIHnOBmy5YJNkJ4I2tUD3zlF+rePgGCyAoi0kcheR9VNHxQ4GMy
         OzQ4Dwq7TI1s0lSUtVMjv92nvinfnkNmbUnRD5cCnq+ZWggMKl7NaPJURN/q8+yl4s+8
         fISPjQAplWVu5WnEPZHTiFeZLBPokZtoluPKiEww+ZKhZQgIqKn+kaImseNNV1NGEEh1
         WTmagRA0l9+n8YaOqkH1K+lpWji1NeNgLL0HykroU68SL/Hkqp/QJuBoxepwcPjM9C55
         qZLg==
X-Gm-Message-State: AOJu0YwwM330FtUTJiJT3f3t1JyAKYafQpCkgJ26tgD4pjv/n3kcGmQu
	GuI39ZYXqFY+xinOnW2lPj1IrXxQ2S5uKCDi3VegOxfD4D/e48bEv2OXzcHsgh0urt5o0VDeEY5
	92hFdikE7yCPsfUGHaSSIHJMQNTg/AgCvbZTnhAIxIh0Ih/HBVexI
X-Gm-Gg: ASbGncuqYuz5cDU7ZPhghLUcRdADwn0zVKXdvBreHOi90MtJJdXbtFg96zOKKZkqsRf
	3Wt19nz6NtYMpjjWthg9a+7Y4pumrP8FH2pGJDQml24fK754U8y57Z3nSnvBWwYlwri1h4o8ntd
	OgrCq5nQJhpBsESv/9fC3DMg35w+shVerePy0j0iT1IEE7HxiW4OA5uIXixVWfVeVEm2QyTlFG0
	zlADGul9d+9yfr0Fc6HKhhfi4jH0qQytgNTEBoz3R/dPFxsJfB6PJAiCVwU3XJGSJK8uOC1MilF
	6u2bDfEAclAjv/nsq+XOEXaqITCe/Jpj/s6gXA7DAXXHzXg9o/yym7V4/WzdhBOHG1fZrxaG7X2
	+2nKAg8s1TEiE/yX/xzpSNoS6EX6/o2eEDm/NWca25O4mTCU2e5NXg3FDX66o
X-Received: by 2002:a05:600c:3f10:b0:46e:59f8:8546 with SMTP id 5b1f17b1804b1-471178afb7amr120260185e9.17.1761058850159;
        Tue, 21 Oct 2025 08:00:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDk/chsWh4lmzSq81oi5QgoA5chh2GWI8u8p0fIiNZPQgGrNl16RwScdXvWvZ/Onc3FnooFg==
X-Received: by 2002:a05:600c:3f10:b0:46e:59f8:8546 with SMTP id 5b1f17b1804b1-471178afb7amr120259635e9.17.1761058849707;
        Tue, 21 Oct 2025 08:00:49 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471553f8a3asm233676345e9.16.2025.10.21.08.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:00:49 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 20/23] mm/kconfig: make BALLOON_COMPACTION depend on MIGRATION
Date: Tue, 21 Oct 2025 17:00:37 +0200
Message-ID: <20251021150040.498160-4-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021150040.498160-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021150040.498160-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2BO3CSvHrT36AybuRVTi86loN2ZajYygQCZDXLzQnUg_1761058850
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AD6210001F
X-Stat-Signature: dqhskw3zhnfwe9hy1jgom316irpkgowj
X-Rspam-User: 
X-HE-Tag: 1761058854-507058
X-HE-Meta: U2FsdGVkX188CSLQziasxDEzJOrRXBNqRC+B/zYtBbHrGurOCXndbhY4vCPuunlpatBnrspzxLEfDjCPKdUkeGG5L2s9Eg4BfzscHEJnXH9+5Ioq2oxJ8Mzs4GCrN30zJDQ+ysGNTjwx8tKe4XqJKXFmnMoNyjlRM3fGQT5coZgk8BnIdQ0QEkofsppkTmn7Z2TDP7irtgtrGvxoZCUa9052we0q5k+KNCUoKe+BV/ZUO8bc2YulvSPXC7IyPj8qopGAQKLC2m7qgSJIrHpX8dos1t4bkgX54CrvR/5wlFy26iY14BfEIE/SKXxqFKGh4yO9jb0jk06+mfb0jG8zGQU0h3/2vJQOBSddonJuCuPWqSsf9U8prXEFnsvAysk9GJwD5wBQiWI93s5Uad4FBSolSIq10FpFLDR8hqLK1q1BXw0dJtHoRP4mzyyEbMfZGATbVIq8kCzVa1EfYhQtEaBxKMd6kuxOFukkS8P1LzxwEW4ikzkDuhEn7iuq7Rx6eY1d0vs7aZUQ9LNt1CPlwVSxZ7KtHTtWsXNZnjv982HNNBUdkCDsYHb/B+WgxOOxIqrffpu6KRzQ7wDqPkI79B9KIHtP/cxLuvrG36/anUbIPHme7k+WrNgFrMfmXrzN2pv1TrMgnonL1Yk40tT7gxEPQLt1RrrEn5iXQr3DxNmgwCIInexeIU9C2Z523eqrSLKCjvkk/5QfzZoVXzQNC0j21zrsY8My9cybqdAD5+tUeruuWgr77Wr1gJNKjho2TGhqEmYLqDMe0OWyYXl+bbW2j4MAqdhxGGy0IJl00eahVsNW+PX/f5N3HedE1EgdfZgRS+lfBXo1wxJFLRX+9VIPG5+Dw/cNm4CHX00bco8TTffQMzQtz+mltU8VBBgp8TTDpeOvBRhb2h+sB2TXJrDIhbIro6bbtfyZZT5lNvpNgp2CkHhFonQZWU2az6ySsQCwtlY3XumHafR18FG
 UGlhjdia
 xTMaaqWb7Sbxiy8PMrVv5MlrIdOve6deycgeLtA4WZ4lVPzdfCYTzGqrGO4DyQPHJgIOttFYUq1Twe0coEZfp3aIQJbKuXzigfCQwYnehySuK6jq2lwb9BMPFf78H/I2noiO8weL39+OVSazMaydc2K0Juc0rwtvEvgSoQYcw3gMFxOHs/AaASdaWziHa2pud4/KPjMie5LnYCBUmkR436Ju/MznH/DwUeKgVJ2+7SC6PY5K6TelliTRuRbboNTzSGPudNkZjbP2XLv4Ei6Opx2EZsX/OdqCPWmtsOU85btGYEoEEzuqp4p/7NJ1sXZZT0ZmLnNgh6o48h4TGYkx3VD6K7qWqNk2ntMhCO01amG7zBqN/zlT5WTKKcw4Pb5qRa4D0zHHc755G1IviAz3nT1rJ7kCO/eMfN5yZBH7aPR86N0L5aWPxeANawghe/VMOwBG5lbuMKx85FFXnRiP6rCkiB/4ykhPfgLmeSqXeldTkjtaSUsEFxjsfwyDXWFVAHzA4ynFUcMwCLd3hEiI0ZRmbN6CNhH+DZP9YTg1Cp409Ke+192y9YiYhfwg8sUg1l+2m3NAM3hzXvWTCraEWCnLXTL1Z2cldlRXv78f0wG4Gw3+KsqX2XFPJ4yAxu8kwECtmtz36e6lre3CR+Za6vguQ32hoIsgwVN7cE5ZWoSE07gohr/S5XEaX1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Migration support for balloon memory depends on MIGRATION not
COMPACTION. Compaction is simply another user of page migration.

The last dependency on compaction.c was effectively removed with
commit 3d388584d599 ("mm: convert "movable" flag in page->mapping to a
page flag"). Ever since, everything for handling movable_ops page
migration resides in core migration code.

So let's change the dependency and adjust the description +
help text.

We'll rename BALLOON_COMPACTION separately next.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/Kconfig | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index e47321051d765..3aff4d05a2d8c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -599,17 +599,14 @@ config MEMORY_BALLOON
 #
 # support for memory balloon compaction
 config BALLOON_COMPACTION
-	bool "Allow for balloon memory compaction/migration"
+	bool "Allow for balloon memory migration"
 	default y
-	depends on COMPACTION && MEMORY_BALLOON
-	help
-	  Memory fragmentation introduced by ballooning might reduce
-	  significantly the number of 2MB contiguous memory blocks that can be
-	  used within a guest, thus imposing performance penalties associated
-	  with the reduced number of transparent huge pages that could be used
-	  by the guest workload. Allowing the compaction & migration for memory
-	  pages enlisted as being part of memory balloon devices avoids the
-	  scenario aforementioned and helps improving memory defragmentation.
+	depends on MIGRATION && MEMORY_BALLOON
+	help
+	  Allow for migration of pages inflated in a memory balloon such that
+	  they can be allocated from memory areas only available for movable
+	  allocations (e.g., ZONE_MOVABLE, CMA) and such that they can get
+	  migrated for memory defragmentation purposes by memory compaction.
 
 #
 # support for memory compaction
-- 
2.51.0


