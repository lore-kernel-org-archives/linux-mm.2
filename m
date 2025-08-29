Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D195CCA0FFE
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C10B8E000F; Fri, 29 Aug 2025 19:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649F08E0001; Fri, 29 Aug 2025 19:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EEEB8E000F; Fri, 29 Aug 2025 19:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 381818E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:40:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F245B1A09C0
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:40:01 +0000 (UTC)
X-FDA: 83831415402.01.47ED4B1
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3091280005
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YqmVmMUB;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ujf8I+1Zg/6WW7rH/KitWZGTR+3mmN+VDaryGANFrlk=;
	b=QOjMHh0cJJaviBlhFvEv48FpQkHkaINSK7utTkuV87BdG3Y8E77FvPt7igyTk4/CsxajRw
	uS3I0PYEzB0U02DBKb2C5X5Uqc3W/iB7yN5r6lSTgsXnUOYzmGVb4M80dENnKkML/qJlM8
	gz0R5Njkkw7SUwQQqYRWo+Oz7dFqImo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YqmVmMUB;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510800; a=rsa-sha256;
	cv=none;
	b=8lOACCJKPQ47lAG11xhT795265A+MBFDqbQiRtC4U/49L2kU4Lr24ydcDpAxVLDxFIMeCN
	99U76uusX2jMe/9/ZPullaAmltlPpL/tt2sqGI1pwoDHnWslUqFaHrmzCXz7Kg+o0LS+Ca
	0atL7EPhO7BqeecfC0lV9PFlGsffEvU=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-249036375a1so12986545ad.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510799; x=1757115599; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ujf8I+1Zg/6WW7rH/KitWZGTR+3mmN+VDaryGANFrlk=;
        b=YqmVmMUBXqzX5A0CMHREgO+fh5MUoDdSG0BGiME0B/iQd1oPLSqx0+chm4qNwXw3Zg
         WCxiXwrFoKTnXk77kIM+QPa9ZkyPTQnjlCHfMjgaU+Lwxpxmp+o+d2V4xLprJ91JuFkm
         m9acUl8IHOtU2mmMMZwYfrhkfLcuwjxEq/QcmUFvEIRzyiDv4bmcCNcdipxHWPUaJCGd
         N79J9DD7E0awZTZkN6v3MqtjoinNU+UM+cN2A4L0QhFbtyGz0PGrCjOfj0K25t+459mN
         2t58GCYlovXsf7DNewhm5oSYsfG8zWsxpX3bjqWySncuduOqvpCwHPgtoFOddWZ6ODnJ
         N6cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510799; x=1757115599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ujf8I+1Zg/6WW7rH/KitWZGTR+3mmN+VDaryGANFrlk=;
        b=Wye7jAMMQLxsM7l/j5oCwT6b81TLz54B8evcXCGaNADuSgp0ZMBLz/5pTaHPBe2JgH
         aFTKE4CdW8mcxG/tUum3YZWJzv2kbHPdNS/eiEyYqiElv160P+m36dJQnzaifqaTkFA7
         l8aEYl1RcLoyFwTWbBLGvaJloLCmhqIFlGzc/33IWav1CrcAwATGTh/sBKgwSKKil8dp
         Uu1wxzKqbdiDKbXXf9Hdmu+TkpE80F/mzP1he3fqNrnGHUkipVpjI7s+Oa7NfGJLl8WZ
         g9cluijmh7et++T2l/8YTC8wJwmZ58mGC3BpCqleS7EnbJQz6Kb8xwUZ2r+VY2+lVVC5
         1vAw==
X-Gm-Message-State: AOJu0YxSlCTs9m44yV6i0wYtKKRCiHqqQi0lT1ci3sm1d8fcp+o16Yvp
	v2S3E3ZJAqtPJLMNuXKNtLU3SEfdk4C4025b7QQMzXRTyW6zA1AR31MJQjpKQQ==
X-Gm-Gg: ASbGnctk1NGVKuJvlsMXfbdCFJye6YBRdavycs/3OG657rPVU3xTpghzRjNY00JO7Tm
	AKKdMAa7gVNtm9ny5Fgt9+Mu1szOYeZiA9VD4+ewwemzSBM+xP67gCamPZrjhn6oTATZk9pUJi5
	GNNlWlpnY76jO4B6j0y4Tii4LDC1/kGsPEte5SUSvQsrjFitPqK5nR8rzy9fiCuQUIhtQgISjaM
	KUFgr2Vxk7mlAxXz3OLCnMHoUXSYLKlWw6obfTtT/VY5R6EYYWNal5E789Iz0fqkNZNh+ygeVZk
	WSG6UzgKQ5Ah6zMcq+B5nikaW4Se0A0hb+UmX5tzpYMX6NxvYiUH+E9p25XwZ4W/gaBrhO96jmK
	I96oPxPTEn8252bA6XxPwC3JK5Bj2
X-Google-Smtp-Source: AGHT+IHLyQUjattwHzqsh8kLDnVYrldB1MVPcLD9W60hYF1Xca21tPEVk8iJYUsBmSi3Y19+Todp9g==
X-Received: by 2002:a17:902:d4c9:b0:248:9964:3796 with SMTP id d9443c01a7336-24944b3c411mr4052135ad.43.1756510798887;
        Fri, 29 Aug 2025 16:39:58 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24906596416sm35109285ad.118.2025.08.29.16.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:39:58 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 06/12] mm: add __folio_clear_dirty_for_io() helper
Date: Fri, 29 Aug 2025 16:39:36 -0700
Message-ID: <20250829233942.3607248-7-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4adr471mfyrfmsoofhn3ft76ad7o7y6f
X-Rspam-User: 
X-Rspamd-Queue-Id: 3091280005
X-Rspamd-Server: rspam01
X-HE-Tag: 1756510799-60797
X-HE-Meta: U2FsdGVkX1+9JZp8fYgILx0F/5tNfPzyNVXZCY/2JDJDxMzG3DX+8Jj1GhsdMTLbs0f4SI97PXhKy9clv0ifpxLeJGBqf7I0GZip0mogIpflKzjM670u0G3VAH3L7Ud7ttTzlb0Q+A68I6CaU3ojcltv35mHPzuJb9oFuvnGQ5fSrsrp1JGriky8p/ErPwx8v7zhHcu05Beybv9D+YXU7CuHQ0YSGaGtrJYK3voUzlQ+FxV15MSBeNrLed9NOWWvXwthBdlhEUBS3JWrGvF0KGhKrk+nr8sPLdY4Jqnf9kS1K3ejr76NxzKioTP9mpccOEahpO4W1LzWiEvqE6hnDz8mW8UNff1wBvW0mW+7PKkYGx4UZcqtU86sMQcGECZogd4WLv4Y1lv+C/GxrpZPM/dv8lkvAR6aj58Ct0DVUQ37PMaX6swt9nK2/FoiMNVbmu0Tugv9Z0o1jfn7UYo9OwEl2cbt4n6pzmJcBJ2HJpWNd8kZw5vk8G7VFkuctNGDVOD/8vj96T8G2ho4YImql6Q2kqZjaIBycNg46QRApDudw3AfKA0GLANuUFz0g/N48UUqtWVz/EwOSbFR/zCpIVOa42fwKuZtfyXhGQ35t5X/h3wQKPPuv/GhdwkuHQXGBN1TS827a4PesVr/LF6HYLEH3VmpD7062VoqCpU44cMiadYLwCAjhsQq9F0AvGdGgt0hyd/fxego5TkzjFpjTfZX5X50koytnHcGfl0stChI1wLmKdPWjYKqxappEqWPKW4H+FgKKKC4zmSigQXIFU+dr7Nsrpvupxm+df66jAgy2Ea2AlIDRYFb13VnA8ieVbl88Eom+T75BfzQNetZeRsDy1MWrZmtm4kuJLngS9yBLhDn8ifr5S8RhW+sof0AEoDgSEeZGm+GIQTyzL2YOz86//ubM1jx/XjZ5RP6B85i1vpbigs3hDdmzcSH/l9W7iVyFIHLjXBPEhZ/mLk
 gJgWK28z
 lQ8/IDRCZFsdWQjMQbx9CxWDX0HZjIwBGuUdEmBun53sv7+hOrUOmqfEShMnUrNWS/H746ELvogSIZG5S/mdwZVg09cKOj+N+r79sTK4bO76rLeoJHys9QPJ6IdF1YYdJjRCjcs15yvXOPlzmQD+/qDzwAJOog+rRwtZK4LQ0nZznoN4uIceRuJMHqlZXGVSV8oANJyUdDKkOcg3/HQ0qAtcqyIaWO1gSXrtc2epDsupfKTJm9WccN4LrJRF5O8nBOMp8PWQOT9rZxl8iipp0MNUvz7cHr+R7keRTmbC5oJqh6zM8KhXrkS0aLE0XjUeRQxPa9IEUiplFJgfKDRvl48IPhdQ2cQCeraEMVSyIuzzj9J82PQyngDuBJ0wHGl1wOZ1p72QO2AQoXARYTFn7q98sAtleA2M5JP1qBreX+pJ3EpJfMgI0MssgQT+621G54kK1M9GGk4a2K0KjPOfMojDKTqRnEXG+tVtEdaEqfd2MfhNxyYJS8mC768HCMEiKKmYa0cz/ZczvSKYCvNqNs6y3Keel7Aa1v403/UveoU7b9sc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add __folio_clear_dirty_for_io() which takes in an arg for whether the
folio and wb stats should be updated as part of the call or not.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/page-writeback.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 1f862ab3c68d..fe39137f01d6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2955,7 +2955,7 @@ EXPORT_SYMBOL(__folio_cancel_dirty);
  * This incoherency between the folio's dirty flag and xarray tag is
  * unfortunate, but it only exists while the folio is locked.
  */
-bool folio_clear_dirty_for_io(struct folio *folio)
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool update_stats)
 {
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret = false;
@@ -3004,10 +3004,14 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 */
 		wb = unlocked_inode_to_wb_begin(inode, &cookie);
 		if (folio_test_clear_dirty(folio)) {
-			long nr = folio_nr_pages(folio);
-			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
-			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			if (update_stats) {
+				long nr = folio_nr_pages(folio);
+				lruvec_stat_mod_folio(folio, NR_FILE_DIRTY,
+						      -nr);
+				zone_stat_mod_folio(folio,
+						    NR_ZONE_WRITE_PENDING, -nr);
+				wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
+			}
 			ret = true;
 		}
 		unlocked_inode_to_wb_end(inode, &cookie);
@@ -3015,6 +3019,11 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 	}
 	return folio_test_clear_dirty(folio);
 }
+
+bool folio_clear_dirty_for_io(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, true);
+}
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
-- 
2.47.3


