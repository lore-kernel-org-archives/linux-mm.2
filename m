Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD01C606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 01:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RFF5/+1/
Received: by kanga.kvack.org (Postfix)
	id CA6366B05B1; Sun, 15 Nov 2026 20:44:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C565D6B05B2; Sun, 15 Nov 2026 20:44:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6D2E6B05B3; Sun, 15 Nov 2026 20:44:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FACF6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:44:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC1131C3F27
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:44:50 +0000 (UTC)
X-FDA: 85439288340.07.F655D2E
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id B15CC40004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:44:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RFF5/+1/";
	spf=pass (imf01.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794793489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0H3osWMLtIW/sGVyOWkSlMGoRnGeburV1Z1d6wUanME=;
	b=pbeo7jsVNXFUHtJMN2RYhk+1p8K92DBw+AOdI527Q9UoMiYLGcZhS+455LbiCN9o4/Ddi+
	mfTqg1gj3NDtJxWbs4/KRMzZbzWHi3F/q0/jI9nU1Cu8zuxE/rfV52MawuEoXF1PMhDR0O
	MThXUK++otIc0aA6OsC5VwaaySnnOmc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794793489;
	b=lOWtgJ3uzH3e0qzj8GUabI+dixBCUqvpghj7pmVdB4YyfFPD6+liZv/TyPegVi0OC9vDUB
	tpWWvD2v+qEoFk/hvdpIM9CQlBII/rFzQxy7cugXfC0XGgZYeoJE/vtdfNNIbnS8j7BYMV
	WxVUxcNTT5KKgQDOi1YOZelceNHU9+c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="RFF5/+1/";
	spf=pass (imf01.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n9g002gGdUvJhs5RK9AVAw1HkjwpmBlxvswaJ6Ry8a0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794793485; v=1; x=1795398285;
 b=RFF5/+1/Hrv2+IqeBltZeAERVGUb0LeWWYrRhnIXOSZSEkZnE6oEQznRlzDvycUFdIJoVZMk
 TeNe6RCDPEWRvx7jKjrfhfHg9OMb/GOJf3zM0WT2FyWACMbqzeUKtitqK61ohrkLZsWGOqPAQZg
 cAlIkj/nkoNbSuMHhdTOQOWI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3d83a667f39792f3;
	Mon, 16 Nov 2026 01:44:45 +0000
X-Mizu-Trace-ID: 3d83a667f39792f3
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: David Hildenbrand <david@kernel.org>
Cc: chengming.zhou@linux.dev,
	ljs@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	xu.xin@linux.dev
Subject: [PATCH v3 0/2] mm/ksm: clean up scan_get_next_rmap_item() initialization
Date: Mon, 16 Nov 2026 09:44:34 +0800
Message-Id: <20261116014434.310003-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pry198y8jtwafof39q6diwgb71nabze5
X-Rspamd-Queue-Id: B15CC40004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794793488-851632
X-HE-Meta: U2FsdGVkX1+mXl7OZYmZlObsro5UjOigewqf2GfbQppOkbEkgux9+TH5QML7xQheUTOeYhPJYI+MZvNNu7qrOngIDkutfocpYw1o4AtDCbswTU8wlrGkgL3fA/YedMlPvi5myU1kr3EL43GxM3ItHb9Bp8ENn58rkM9q1zh5I48Duro5HpN6of6kPYWYxNx77ckuE6V1F+RVysx6XVkI3MJ6GM+OF7pKavV3fN+uZckprBCVK83enhPLsr5cownfHa5xOlJ0rX/DJIWyS5weMHBGic2kqEVcV078CB0nhtwap1VAxl4bQ/hOpDb5aNXOUKwNPPMaLKQX2UW3qBG3OJ3FtzmvwSRsyElhQz6JM5YsBNin8MTOV3YUcBBdxnMh6kg9Bz0NVfblfKVXRsMRBjcP9keHMYUtNWGHy0uPgnNpgLgjhrqyJZyhtpJ0eTnNeOs3HDfigKv4wZU8M0CBRhkZiAFTj+UpTbYNxswBmHJZ1lcVTyt0Sx+XZ7pgCmbWzVw9h/twh9sL9PAue2vP7C1R/lny/ooUagNB23i7X4KjRdH2hzb+qgNwOqBXn2EWogyZRFqFviY1wst5TOg65jxiDsfSvfC3xzbqiLEFrsuAaMM5P26bRHGji2uws3eAuBLqDpklK+bT+AByn71Ig6WwecMDvPmzkCt0RluszAy1mcDH1xYW8WbrpwFnC1k0SkkCyjS0b+qvuE0VYTFLlstduU5J6YZeVISjWaRXD1bEMWD/N0rbXlCd4px0zo5DdUOsTjCmM9EFcLALdq8+oWjbzkeeaAE4LsnPIssfrH/IIWBdyqP2DOv6Guhuu3WeGfXbmumzNur+OqwSqFYnWhKwlpLSfnL8U1gX5l4XQPFsn3RLhxcfbjuvOHDx9eedz+C/lSkqkAznQFRMKY2PU0lYS0QtSdMCLRP+3cHLWkufdK6OP7dJvcgarYzNrK3rI5SIDqg8De64XxXhat+
 BrhzW31y
 O5Gx6CdxZU9fUAN1OP5sOELZzBzxRfZ3Oamibv1ob3c1Dv79wRTfG47e2xnrbzea/fOjVICxKvMDAwai+2jDkKrAj2fCLShw4NUNpIlxI5vuqBCOFB58OfgsGdREJQq85JjPByCMo7hfF6iWCtkL9pDFOn8c3zRvamy8VaMIGM/PEopQ67LcCCRPmqIuvPZ7QQqqk2bRmReGbEYNkLXF6hU+3WDEzVysnG/HkQRWeLBE+TR0JhQ01hoc6UhO0kEfdul63las1ZYiz+E4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, scan_get_next_rmap_item() has grown quite large and complex.
When introducing new features, such as the only-merge-zero-page mode we
are currently working on, we don't want to add more complexity to it
and don't want to touch rmap_item structures to avoid unnecessary overhead,
so we need to extract some common logic.

With these changes, the entry of scan_get_next_rmap_item() becomes much
cleaner and easier to follow, instead of being cluttered with unrelated
boilerplate such as stale stable_node pruning and cycle initialization.

Let's start by cleaning up these two parts at the beginning (where I think
abstraction is necessary), and we can continue cleaning up further if
needed later.

Changes in v3:
- [PATCH 2/2] Initialize mm_slot = ksm_scan.mm_slot in the else branch when
              continuing the current scan cycle, fixing an uninitialized
              variable warning/bug (kernel test robot).
- [PATCH 2/2] Drop Lorenzo's Reviewed-by tag due to the v2 bug fix.

Changes in v2:
- [PATCH 2/2] Rename scan_begin_new_cycle() to scan_should_start_new_cycle
              and keep it simple (David).
- [PATCH 2/2] Keep lru_add_drain_all() in scan_get_next_rmap_item (David).
- [PATCH 2/2] Use scoped_guard(spinlock, &ksm_mmlist_lock) in
              scan_get_first_mm() (Lorenzo).

Xu Xin (vivo) (2):
  mm/ksm: extract helper functions for scan cycle cleanup
  mm/ksm: add initialization helpers for scan_get_next_rmap_item()

 mm/ksm.c | 101 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 36 deletions(-)

-- 
2.34.1


