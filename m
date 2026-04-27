Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B907FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:13:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB20F6B0092; Mon, 27 Apr 2026 11:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63AA6B0095; Mon, 27 Apr 2026 11:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F926B0096; Mon, 27 Apr 2026 11:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A6F446B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:13:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD2CD40864
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:45 +0000 (UTC)
X-FDA: 84704677932.03.FF7F24B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id C3A854001B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:12:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5bNnQW9;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777302763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbxQY3lvzqhT/iqaqHhhtJ4GZyPdebweaPj+BWQtC58=;
	b=q/xUUZ8GWUZg7BubL1mKgkRhISAVvMBOEECLbpohCMpqrZWhl8g0RaepNzjelVBs7u1WTb
	fA1cNjzaye9IC5wL6RzG1EHncIihFz4kplTiqggpkZuhEdiNr+GMyXlSr6WFWaFkjgs2OD
	WApn4XEumYn9mSH2ng9yQkhXLVCdUts=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5bNnQW9;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777302764; a=rsa-sha256;
	cv=none;
	b=z+CAnP5FFp2L38m58fwBjIfNgtH+ajtAGGpQslt1KUOfjeqZWuSQGY/8oa7FTU6JIA27AT
	Lylobjqre/4TUKD9XU6wqXxn9yvLUZYQ38tfMPVgf7PgOnIAv6TI3USfKDBRcPOVtYRsp/
	EVJ9hpxrpgiEx2O+4JXDIFf2yZKsWFw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 98BFD445ED;
	Mon, 27 Apr 2026 15:12:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFB2C19425;
	Mon, 27 Apr 2026 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777302762;
	bh=acrZio7SwTIWWe0wc5YY1SpE9hMTqgCgT01pPcG9A6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5bNnQW9w6UfmygfZeMPknLdHTYsBUe+1OlK5Dgp2HD+DcUzmdn9PKZJEGpQ1Spe6
	 Akt3bXbTxUhgwbcstxO07AF9aIriIy65eDAMGuhsn8p25p1Wm/bE/xoL8n3MeRAFgr
	 g3Zzcq4zNRsB0a/pJ+uVN5G3mpjU7DcmTjrXdY+xxqvkx2E34OhRn54wnvTx8rLogz
	 n0w+a+ZYAumiZNlUcrSmbgmEipQDztN36RF1erxzL0uIz6abHHGcotBS65ehtYSMQI
	 FYEVRVedJlDEFiLRVYxB1owgQzHCbHvzLdZaktoDdYD/r6CuY+VWllhtDYBwgoJWC5
	 ZQd3jG+u5ASug==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 05/10] Docs/ABI/damon: update for pause sysfs file
Date: Mon, 27 Apr 2026 08:12:24 -0700
Message-ID: <20260427151231.113429-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260427151231.113429-1-sj@kernel.org>
References: <20260427151231.113429-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 879p4qbbsb5auk1forcbqbcmj7hemzwp
X-Rspamd-Queue-Id: C3A854001B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777302763-104817
X-HE-Meta: U2FsdGVkX1/cRpfaOTbZKWZwOXZJm1nwmdRMW52gOVJDy0mSI0kI4eMjG+gTiVrwD6KRnWxanID1m9qPXgRaBocFnIS4ZRV8UyYc/1yIZJhNSF4QyGtdfyOpA3o4U2m73vTPqfS3DkaPCAq2YhwSS3ei1M7yQsJQW0oR6shK8/yz1KqlzQ5rFlCM+xkS1oOpM9xdynNPY9No9iwpOT87PvyuqA7HZepFzNPOdW4yPHHi4KJqqwhjKIw6K6H6lLfXiGlvc9N7YaR159xzJ3sMaNiIvqtTHAr4n150haZ982x871fdynTZHzyjgTjchow5THaa636+W5lwXpSYLwctuFropYARcZUoyzWaPuo6+aUCERgUOrA5SkuDs+vjqcq5H/uWzuR35p6P0cfyaOgnSaJP3Z0WfhIo8GDkFv7o689V+RxA0cDkTHHIFPoT1Npffj8vaOhMpW19W/WMzJqi+bWZXJV/mCOPid62tyTvJ0rJE6tDKSHOLPgStPFweA0CPG+e1Sqt0HcXpIOS/jnSBOsIJneyAkn6dgiQOHlonT+zUNdsk9CsyOMGSs4Qs/arT92xnbLgGmY8EDRSIMgGGYdWUV2spfmizRNEAi7QP3akKqPDGjS3DD6Hz8vW5SL/i86hNXYgNDhaNFUzJW8bEBhmlEaIebs9Pw+UX5/fz3N7CFf23r6gNPlFJOM2dthxnUthvDdHyih5HRwquucLEAWUWwz9jiq+DJrSGd5JUpWes+MvEvamTaRhkMDLSlaDSrMvEEK+0Wzvjo4wz+zxESvFRbVwf2+s3diq6j2aF8PdC7Wl6aMvwuZmWSbr65YqkrhDaQ/lmGfemgKwQc+XF7hfWHA7Q2YIAJKpeSwgIidwuz1EE69+gVea0iGR4aFT/dPdGh3M0nxTuiDCCbjBPL39FrmHJWM73SIBlCSyiTn0SbRLVhhgY7L9pk4oS+G7JhrHtG21FAY1VU0mojv
 5kwJddTc
 SBG+m3/anOmUXjqokiaEnK1xU0tOHecBrmBNLK3lkU71UL+NG0mR3Aty+XJ59HlUC1Oc1zNUCsz90WmjyAwe/4PhB5nauUsk6ZitJb6X1P7cZA6AGOAL0mrc5wRRraMB4wjPS5iSUDtUoFD/FhyFdGbVeBBzJgSWo3bvPI0Ed0FW3Zvf4Jvxdrw5jzFPY34dmeOKRyXdIvo6kRFM3Q85IxngUzrIxEY/4fZG1O5b4x+D3P18=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMON context execution pause/resume
feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 2424237ebb105..7059f540940f0 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -84,6 +84,13 @@ Description:	Writing an integer to this file sets the 'address unit'
 		parameter of the given operations set of the context.  Reading
 		the file returns the last-written 'address unit' value.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/pause
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing a boolean keyword to this file sets the 'pause' request
+		parameter for the context.  Reading the file returns the
+		last-written 'pause' value.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/monitoring_attrs/intervals/sample_us
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

