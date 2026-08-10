Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EAB7C5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF566B009B; Mon, 10 Aug 2026 10:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AF206B009D; Mon, 10 Aug 2026 10:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DD96B009F; Mon, 10 Aug 2026 10:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 000A26B009D
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7244D1201BF
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:17 +0000 (UTC)
X-FDA: 85085572194.22.D00B33D
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0644A80013
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=seVJQEGw;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jW8uIo9mq1l2z2LJqV2kSeHNoorVMZ6STN4QBox7XYc=;
	b=N52D6qY6nQrROZawnrXUZ7Q7xEWIC5nJatcBhopZX87a5edzRaY/Gce6eWnK806Swec5d/
	NBTq6JbNV4fAekd4akSer0sov7h8Eqp+1LCiovlBeeaz4m0zhp71OezBleEwxqkbktYzTT
	rZ7y072Le4cPiQnnIC/eyLEe0Ip2Vag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371675;
	b=dhWPEFON88lF8N4UPyqxGkyobc3BtM73UVV38jrl5PYDaBtPbQF2+Nx4tYQBxo4CuFdqLJ
	47Y+LT8/3/vPTMYEP0Tk+l08ZGTrxtVR0lHXa20q35WdpAVUUtq4TkDHMy7btiTvO4AC5/
	CwtSwibMcarbfhu9oy+zIYhjy/ddGDk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=seVJQEGw;
	spf=pass (imf30.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACaFfH2721607
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=jW8u
	Io9mq1l2z2LJqV2kSeHNoorVMZ6STN4QBox7XYc=; b=seVJQEGw48BgY3Nu9Psy
	tQQuCjl+9yc5O8F27BW5VVwDRtmwyNqign08Gujtt587mOgRMxa+TxRCOuvFzAnX
	fACFqvlqUg77CEbTfrcUVjEnc8Y6hvJN7VIXP8gLteGpb9S/s/KI6CFbScKO5rjC
	G/x5IJZj9UQ5RaWoqT5+Lj4qgWKKgWh7//KaugA9v8ccpAW0gYdtFe43jwh35TJE
	jALRLyOj+M3yxht9j6PmS2DQzBA+7MAFLMhpgJ3ygC+kWWkUbT1UQsbLUfrnXY41
	7rvVKVvDB2euC0f1HgOUVS4OClT7f7vdAbYXTfWHd2TpVuOZokMPmw9pNqHblRnh
	1g==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fxyvd3gw0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:13 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-51c01ff996dso26636921cf.2
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371673; x=1786976473;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jW8uIo9mq1l2z2LJqV2kSeHNoorVMZ6STN4QBox7XYc=;
        b=J02ZWzSNqPf4Mgz7HAav1uJRlJD1g3YueyjC/wUWL4joIiIYUtMx9OwqZpHEaBShL4
         +1s9PvFm5elKgBLFKXkShH5B2ueYby6Tor+UlrVeUIConkwImsmz8crG9NLT5PTskKiq
         UpEOfZkF+49TKBZf6wVRkBZwOldYGM1eXfbqR/NWuQkZlSWw8VikAgH/pPDuKvcgGuBx
         pgT66DGm1+cofK3KCJbfvlHJuAAMh/dnfNHQWpjYHVOUJNWxS/FwiimbK4HUX7GLLYso
         yqs4SA5tv/lFH6F/ETaGIMn2ztmY0mGvkFr6q59nkxJrcx7nFPLqkA4zNsbtafco3nNp
         N/Xg==
X-Forwarded-Encrypted: i=1; AHgh+Rpf7Cu0H/lfVxlMtnVWGEFdjjO92TSxcMCwaNFM1Z9zaO9RGBif1OhhxjbWgpX+PZLYCqzw8qSmCg==@kvack.org
X-Gm-Message-State: AOJu0YyzUwo7oB+OtiXdKWKmA6lJih4Spb67sgImHQcOQXEyP3mz14BP
	uK0ziJkJoCc6/H7zZUMpb10uMNS4mEKXxWE6IWsMi7V4WcpHrIVkPAOwqwoleed9GxXlIsNrurV
	+cw7HNFkvzWXzd/7YOxscp2Pc716sesCtvFaecG0kl7HNdmIe/6NiLz2Nq64=
X-Gm-Gg: AR+sD10ayvsaAGAWrJ+lTpw0HuN59m66eDPV4prixFHttra8RNJiZr4TPHDXvxM25oO
	/Zb5QaaRlDccMgT91ytDMZNkAk7+ZP+t2oE4M0su3ilSFzIZd38E3109RTyxWznYsGgA/e3IUsc
	Ua4DqP2f/fU1JMTs1wuHafPWO6bHttGmcWnjj5f1SXUP1M5blB1cwpOHEHdanNo41yjyBQ7JzjM
	DPo/LM+Y2ROAc27v5ene7LjdW65VXoFYzKr44Si3wG6rm41vh4Azp4QaR5EtSuazP8n0G6wZ7B4
	u9IvKr6oF8wd6WIwjRCedAHkcTVP8vPr+PArsPrvM6FhXs81LyNkrueP7JqasebzSmPMtm94cUj
	WHftNXt9O
X-Received: by 2002:a05:622a:581a:b0:51b:fe7a:4eb8 with SMTP id d75a77b69052e-52d1918e143mr244245111cf.35.1786371672749;
        Mon, 10 Aug 2026 07:21:12 -0700 (PDT)
X-Received: by 2002:a05:622a:581a:b0:51b:fe7a:4eb8 with SMTP id d75a77b69052e-52d1918e143mr244243051cf.35.1786371672052;
        Mon, 10 Aug 2026 07:21:12 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:11 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:15 -0400
Subject: [PATCH v3 04/12] ceph: convert
 ceph_wait_until_current_writes_complete() to folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-4-dd7531704f26@columbia.edu>
References: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
In-Reply-To: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=1518;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=l3uEHuwNVk6EU1qiSYF/Q0V/FDAY448POx4+1dXVCT4=;
 b=MN0UzA0s4wH6d3PLNpiFNlpzeBQU1Ayj1yl+dxXmrHHGmwf6FOlt2/PLR9CC+k7hpkkVwBz/A
 zWPq6NK5C5PDacjs4Oon93gHT3vjCh1ok9uHfjQLVsS+prVu7VChuak
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX/pb2P5WgGahr
 ol8FmCMENjg7sawqOaRH6ZH3mxOC6Yfru0ygc1R1YVJ91gZZbVgM6784Alp0pH6wLDOBqdNhUn3
 59/UpGwuZf7pe/on/HCMEPDZC/DmexRSIDnUN59d/5gd53hOihUk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX0CeXpnSvaAcv
 S5Dr5CmFFOdZ08121RsNRrDQPfyCXHASp2kiRFq3g2NJqwjo2xbwqSDKBTobOQspNFc8BKjTdsm
 y1xbJZa645iw2lrdxCK+vZGcGNqRcxSCFTUU4FhhDNcuQQ2BGXtxF0hgRXQUU1x2Z5SQxJhV5J8
 sUXGYGF7fwZHyq7cZOsM9tXTbFp8dEo6ElKRb1QA0BDxFk1bse3gIgQPC6k2sy+4LjuHnrg5QGz
 SjRPDjVMT3NdeAeiWynhWzbq2shlvyFwGwxGHdFdMDqs8OgFpH5mH5oSTpLUmjPkrZOnGWC/+xX
 eivmOvCFwNP+8aU7ICSgpwSbYknkUZBfh9BGbGsdzABrHBw0M83lIs9o5m8IQjcz0oafdbRveUg
 JrOSUuIxJ63qAoWkuucp+FRxC57tye6AFEJgNb8qzdVHx0k3jevDJZOEkvPXk9C3Wze2hXcKrRi
 Yv0D91WoQRCaG4AQxCQ==
X-Proofpoint-ORIG-GUID: Ya3CzBa2mRX-WU5C2uXvhaT6NFKrnNEN
X-Authority-Analysis: v=2.4 cv=Gb0nWwXL c=1 sm=1 tr=0 ts=6a79de59 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=JfrnYn6hAAAA:8 a=oBeIbaJldBQvbLH65vwA:9 a=QEXdDO2ut3YA:10
 a=a_PwQJl-kcHnX1M80qC6:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: Ya3CzBa2mRX-WU5C2uXvhaT6NFKrnNEN
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=10 impostorscore=10 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 lowpriorityscore=10 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0644A80013
X-Stat-Signature: gbt5uuqxqa8iy4dygen3rswqkttbqeun
X-Rspam-User: 
X-HE-Tag: 1786371674-990261
X-HE-Meta: U2FsdGVkX19qXDg9adjX3/R4tYMhRtNQv2aOCOlgddmjmPjVym/RmYkB7lRvJULDDsy4K3oV6wmxTiZEPfe1wB+RLFZwVjgCWMlmK9ar6vI7rIPkWhRlc2rvuMvavlVl0uQfOxeUNvlSz1BU5Sazda5VMSTqkogXGLO86nlRJWVVNhSfLtnlZEKvtveDEly+79PYVzSc1fN8ROQjyMZ4DKH9eavaUUZsw4AP6CBlQVgwQBVxxMv3dEkj4sUg2q60ZXxOy3JXA21vyO5liGX9dDCFHCXKIAFKy8iuwRLavt3k9Gwq3f3S50VnXl0hZ8kKaz/UBmTfAWWJkZe3UafW+sPcpgfPEZtrQC31KELL+J2mYhOkM/BZHgLsadx+FDz6GWPijT5FlYrR7aiQes9ETeEOIunvHvs+51NsyMQjjMtBE9F+IxcGM7uwCc9STJ3f3a+VGGgAj7ILBS11OWtohIgoxLBO3L1KLDaa0EEnl+6OxJi/czqW4SSilPoF+HQ+UHIn4tg2nAyUxSJ7eZ9dcxvhY9Ak16E34mzUXHxaleVEx7vSoKAagjFpieLNy/qW4E/RVoFM8yhcDhQNMM22diqj0gXu5KyZFVf1DYJVQIXBJAI9PvAFaeCDdBn6WhE8TPesGj8GRJiyII9BrlfdgNZ8RVQdJmXSHfiw/33QmRnwoz4fTEp0mGolmGxHDfJVzl6Ul75KvM77kmSrHr+pCkv0aP0VaqSvuF0bHEMbjSMkEUdpRRh9ew/1/JLLQj6IeVo4IwUO0aMNvurZkRXEH9POIldCyBY72wVplJO3yGDG90tLU31kEajF/5/Lc1WiIDVCv03NGuKHBC7bKyhhcwKLmStGZ7UYqpfNpt2+G1IO+xXHhy7R90EzFm2m4NYcItaE8di5Dz6uAJdRXBxjsh4m68QLNeIqOMXXvnEYcMW9MEHtUlA4JLesWZnEQMpLGlKJ6RqWSkK7fHOahjH
 s1scrZ3o
 q2wr6SqVu7ggVkIn5WSsWQ28Z0VOZ8wKAMCVTcbOSvzJfRYOHMs7m48+4wDbOiiXs0gbXKalW7sOZTuOJEGe5sO4ulOcIuI/M0c+XuEc6156+f21bmTHSwcBMkichwC2e2CUo0Y5Lyp1F4Bk6obMh9rPRy/bICL92OUhKD08oli8+BmbB342YuAJD8Kqi8d1sUubYCrZJz9uRaCMmSWiXTbbCRuWHvIHVmVIKwbWkRGpSXrX62wYYgIcwQeMefH/MokvQ7bNAFEjzPVPv21CNCvjq9RE1auae0R+PbSWwTKNM+JUy5oAqRz1wNLu03wFrQHZO+Osrt6w6VVNeMLECQbUVJJm9c7YQsl1Ha97k9Nl9sqTZbEHf9P4X+dnuGnC4OTFD6OsQ34I1hj+mx2wGS8jzYPUzV/w9h2RjFS178ovQufPpmNPiAwmJcK/+RheapVQ5+YXinSb3TPrfNJDfJyfIHVRYnDl/9nfLO2uZwdtNf8Ek0tVcAnBpXNJGgbyc0PFCYLibflGvtuvWrtfkp60zKoRZdwfJB9GfCCdc3mqBEKh64BF0IGY9MP6HIwVfj5QS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Iterate the writeback batch as folios rather than using
&folios[i]->page. Use ceph_folio_snap_context() for the snap context
check and folio_wait_writeback() instead of wait_on_page_writeback().

This removes one call to compound_head() and the last caller of
wait_on_page_writeback(). No functional change.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3d86e4c85b06..c08fc70321e6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1637,7 +1637,7 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 					     struct writeback_control *wbc,
 					     struct ceph_writeback_ctl *ceph_wbc)
 {
-	struct page *page;
+	struct folio *folio;
 	unsigned i, nr;
 
 	if (wbc->sync_mode != WB_SYNC_NONE &&
@@ -1652,10 +1652,10 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 						     PAGECACHE_TAG_WRITEBACK,
 						     &ceph_wbc->fbatch))) {
 			for (i = 0; i < nr; i++) {
-				page = &ceph_wbc->fbatch.folios[i]->page;
-				if (page_snap_context(page) != ceph_wbc->snapc)
+				folio = ceph_wbc->fbatch.folios[i];
+				if (ceph_folio_snap_context(folio) != ceph_wbc->snapc)
 					continue;
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			}
 
 			folio_batch_release(&ceph_wbc->fbatch);

-- 
2.39.5


