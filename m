Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC682D46606
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0303C6B00B7; Thu, 15 Jan 2026 13:14:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D246B00B9; Thu, 15 Jan 2026 13:14:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28906B00BA; Thu, 15 Jan 2026 13:14:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D10C66B00B7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:14:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84C161AE475
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:43 +0000 (UTC)
X-FDA: 84334998846.05.597BF74
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA2AE20011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:14:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M6S0jg/o";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768500881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uzE76a+k0/N5f+yjx3U0UCT4vdKzz5GXnAP053TdQe0=;
	b=O2t4WPL8gsqtyJtaXeO42uIIAgrN2VPSVqOpxrzpZh9XcwuW/LNsMtKZWdV6mddX8F7l8f
	b7pdqgxcllFUO+INSaxJWbXVhXOlWmzNqU0DqcsrWzfK6MCAwTJzlsu4i9jxIski2Ec9vi
	MQjtpS5aAg8KWtWdyj44ZOX+gbhYIj8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M6S0jg/o";
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768500881; a=rsa-sha256;
	cv=none;
	b=Jv3JzImDET5n5/HdIkln+wQ/wWFSw/CQMIK6f3i4NIO/5ZloxrpLFev9qExuvJiRJ8xeCO
	I7vsQCRs/vAT2x5zdwnHEQ/+zwrcBpKBcggnCfcxasjm3xnh0O2YMeICaps1TptCoRWzJs
	RWPvRXlYgm8qzpFi719GegLQ6YUSUxs=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-644798bb299so1108029d50.3
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768500881; x=1769105681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uzE76a+k0/N5f+yjx3U0UCT4vdKzz5GXnAP053TdQe0=;
        b=M6S0jg/omWCAOe4PWHLLQopx27qMza48CBgj+TYgn7X3b32UYaBzTQv9JodOGBjwkq
         bR58gKazD1zcaKpbTeHEVjuCU8T4x/VuhmKzZYgQPPwvjznOd6tu8cfLmwiKCF/+7Fde
         X7y/kBYqFEihPhvLyBxATGQmfdyUMfL/wxCbS8re2Bl8b+EW3DM4vZoBCbrm0PRHJX+l
         Sy66ZpwQBEwqClBNxxItSFeUXInQctIvegAVFf3QZq9oYAu3mVHuqZ4e+oUGqVQ+5PRm
         PA7vu0Dhy8aRCKNVydVKyzpBlqWvBiNH84h6kHcRVMAe1P6I+VfLK6prnItQdB2Qq9oo
         Uz8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768500881; x=1769105681;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uzE76a+k0/N5f+yjx3U0UCT4vdKzz5GXnAP053TdQe0=;
        b=YPVFyL60+Cu9oBjml5cMMHDILYWOOgOZTJBiHutEe8BVrm+E1B5Ms+PcjzA7/9+2jy
         8pPNd0//mwG6Luejgp+0K4VIbQS3D13Fit+hbYkZDusEDAZ8Bwfair1VVQblGXFwGZP5
         q9sIU0o6DUNP43YgqIQTtu+e8oiiUiBCAYl5hUDblA70z4hDrGMMPiUFJvlGHee/YbNK
         gKnhB1wcny2YbofgY8vSZjwCz1NqOtXucohIFiZrgeNDluch4flEfMFHYN6Ozyp2brf1
         9zgiLm4TRVIcg8iZt3X4x0CMqEpq5fsKkVRx0So13KJ8sKyHWBOG6DJqgT5UBbf24TQY
         VJXg==
X-Forwarded-Encrypted: i=1; AJvYcCU379mwycCSRLsfIiu73+eflYgO/knP77ac/FB3KzTFAPP6B8EG9w34YEc75DIy0J6x5PahXWzDsA==@kvack.org
X-Gm-Message-State: AOJu0YxyywycIDU9E5OVGy6ZcWqEyh4bFhW/MMYKuGpNnxvxGxqZ9apH
	+SFNkKAKdj6OtVLoxwCT1CmcDkUVkCwu3eLbSwBVl1dVoYN4vAjMsB1F
X-Gm-Gg: AY/fxX6N0xBmAwp4EhMZWRKncfL/I02CZ/0lq3B+LVgYdSKjkk+o8pgZOI2xhE901ZC
	ppF09SLjAH00DRgUNkhJj43XPezsywVygO1qNPBXbxCrtL6B7zVCB4qx3ThqJFH2egqKcGHZO57
	1uviDBDo3CcRc37v3KaqYY1lagyHuxfHwZtGuNAc8Lboy+aq2mp3d0OB2o4Pe8veY6is92UDb7a
	xbk7TuDPHbModBkCUA8UpwBzAEu/qGH/EMbBZC2JKgP1pEapKCroBzasI7TkxgopvFmypETVXRE
	4k18jJrzzalHXRDSLhpSSZYXttKsgrJJNsp6NvUDj0uJrAJSafRiZybs52cFbztIYfpg49IFu8T
	0t3JDEhxaAgbLJRGVk9F7ReB+XmWO5zyIYu1YUGkT7JptjPEr8+7a6YP+0sYI80fhz6e9SekiFl
	Jtws5N9NPK
X-Received: by 2002:a53:b3ce:0:b0:640:d255:2d75 with SMTP id 956f58d0204a3-649177114d1mr8404d50.48.1768500880744;
        Thu, 15 Jan 2026 10:14:40 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:6::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64916f47c8fsm119480d50.0.2026.01.15.10.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 10:14:40 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 0/3] mm/hugetlb: A fix and some cleanups
Date: Thu, 15 Jan 2026 13:14:34 -0500
Message-ID: <20260115181438.223620-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ojzy56ea9u3b6w5oknwbmajkh7x4mjyr
X-Rspamd-Queue-Id: BA2AE20011
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768500881-133324
X-HE-Meta: U2FsdGVkX19y2H3M4KOq0sK2/jwcEAyJraNtXQkzPJ2XOGuXx/jiVJpr69xXIWofO7oHqt8IrJA+bl38Lr9vgE1tzFoHV6R7zWoGfLBxaQCR20Y9en0j30SzN/wlRyNN266d68Wworby/YkutjT33//KDhobsam5EkTRp5hp0le7VmHugyAb+aclp5H9MAlvZY2umveONDo4rUDIb0MmmRmeq7UVc5XQl348wEChFFHlfsFbf30y9spZB1K6t4B9gs4HiIE2NsTUKTAB4s2TISWz/crVHaKylhhb5K2saCND8e2bQHAvZyuVDUcK8vnG8e+w69TJqw9cwkdfpqTMSF9vCcDVU3g+jAGbqR6kKnZkPfo55L3f5qHB23S7vQMlk/0SZLYaijX4r5jZTKl37oaPunVwT2AsgKLDQBSYThXjo/8IvuInAuY3K36sPWK1wCVlLM3iQTbQ2ouelvGUMDlXPKUVuHSHp/hp+YD80hr7fTOqiOcSFmgS9TMH+C8qFEhdBr61Bmm/Z30pHdY63DflsayWexzoP4ESZmuk49JpstWkSnM8ZydmUI5gyxUwvl2/n9MYmPCIDUwTADo9YuVjCqoNFVNvnsqaH9vpNqqmFejHhMX65SmAm267HTJt9XI95qV+fAlX1TOoD3RdRRuAlnIZLTxkyaFL+T+YvzKku9MQRCnJ2i/Ogs0ZXlXcY8e3Wqo4nOHBmZb1QkNqcx4naHuS889AYwgma7cPzGDl/aCRrHvd7LKUhhmUD7piuNLfr9LSgOAFT7bbQ+mjaKwCzqSUpTrBZmCHViot6rgEjPtw94v9Cj33J7m8rrh0Tnv3FVoNMQ4peXyJKlZc18NSB8vkx6zr2iOC5B9nZD29LVYhZhGShcnkW/j8TuT2EM3zE8EC5LB32r8H3TBbBLfhEp8qxNB/PXmk3nWvxq/pm18H8a6cabqbsCDVcFFbPRsVlfQaIqT29E8PgCw
 nsP4nOBU
 F7I4Jwzs9uSD1+2wPUb0Lvviqk70H4TzZl5qQB7oy5t8difKKT/tqbIpbTqHeNhQuuU3OkzoVLsitCgNF/du/uDFykYi0EK1ovpkb6EChYv/67ItYzm4yarvOn7csnB/y4s+aVfXzEJYvjK8eMsEPZs134q1MUOLE4VA3RGrgu11r/3BTQ1LRo/4v8N27NPCwbyeOgexHljUC2FYTzEtw4p+87mac5693t1+iXG/Neaqxv/iJ2v2N0sMAUlSKqeMExBe4NdjNOjBNKaMBUcXAaZMGKuYHrtf31t+gwMwxHUArcQWFII+FByT6kqQnuTKbrkIXl1Fa1CNMDl+2u5BxFWPOMmmMq1yKMCsCK8G+jStaCSsaXcqWmsU2pGOwLqkU+cNkoiebDnDvyp3gg76jTwZ2waKvShXV8Qo1ANPpAr/QXozb6/MkIsiFgaTtuUkVjUwVjHuSkJbBIV2MhJggaXptoQ6VNzzSmM0qcNDNxoeRiqrPmrTF420a8wXpxpzbX+4HqdMy/XPZmrnacD/rJa+brQv/6Hh+r+tWLejwEOU/8GLGIDMIdbrumIEcVlFORNJM0uWGlAlBFGERi8BwO/IfSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As the subject suggests, a fix and some cleanup patches.

The first patch fixes a hugetlb accounting error that would leave
hugetlb subpools with an elevated used_hpages count, if a reservation
attempt passes the subpool limit check but fails to acquire pages from
the global pool. It was introduced in a833a693a490: ("mm: hugetlb: fix
incorrect fallback for subpool"), which itself was a fix for a hugetlb
reservation accounting error.

The last two patches are some cleanup patches that I've been holding
onto for a while that I didn't feel was big enough to send on their own.
No functional changes intended for the last two.

Joshua Hahn (3):
  mm/hugetlb: Restore failed global reservations to subpool
  mm/hugetlb: Remove unnecessary if condition
  mm/hugetlb: Enforce brace style

 mm/hugetlb.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)


base-commit: d70f9612414bd3ed6bb709ccbeb4206d1a1927a5
-- 
2.47.3

