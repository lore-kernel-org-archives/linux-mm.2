Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2448BCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727586B0088; Wed, 20 May 2026 16:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8676B008A; Wed, 20 May 2026 16:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B5726B008C; Wed, 20 May 2026 16:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2BA6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:37 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F054F160E2B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:36 +0000 (UTC)
X-FDA: 84788991672.14.317018F
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 688B840003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e3ggfQ5i;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310234; a=rsa-sha256;
	cv=none;
	b=uHROdCvIIHqeuLlI1kLrJQCr1ogioVk/15luzWy8yGvbBkjSHvQF+z+7gb5YpggyxpRAVh
	7rWUyHhe/wV95vBj5HqLj18bMo23UyDvqXVKikOhNKWJHnNvsMxO+FW53P0RnJTmfdPcyx
	WS8VOJexMzHilhnSvJV+GCfJGkqsIkw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=e3ggfQ5i;
	spf=pass (imf17.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vd43LnA947EFq0/DCZQf4Ap5tt7EnbD+Y9KrusTIT/M=;
	b=FGkFHJTBkyItjV4NNAMGHuPsSi5bOibG5v8vTZ10LdI59uRIOxk76oYh72gzSY6I3E5Y5K
	ZU5Y9CKjd1FRaCqPEYui+8BDF1Hrlt/Mf6cDclfF/NhDtWaqG0NqXMtDyLqhuDDHzqXIBc
	arU8H/TRbpipg6QQ6elzk2G+fRkUHZ4=
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKOBgu361410
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=Vd43
	LnA947EFq0/DCZQf4Ap5tt7EnbD+Y9KrusTIT/M=; b=e3ggfQ5iJZvEHRmVWX+j
	LpFK6H+LsUTgm8fyI6wL9f0vMt7W2oIbT9qn60r4FWKZqhpLkP3JPi064tiKO5DZ
	fkdq8VvYDIilfbURYABMrhkiDk6vnaAbF4FQsQ5CbvQQ693ktoG3RgD1IfVwDM02
	GtQWDjriMuc858rYZhQ8SwA8zKivQg4b1oB+Qr69f6/kyIX0+1MuF1XwUUTlZGbR
	oBKUlf2O2jQAMQgaGGwYC/2k2+I1UR2RtYy86RcLqQb0I0x0/HoYiUO8PCbpOwzd
	LlLoeCgkDOCpeW+7VspTHmsDFE7B4hWWUbpO2aYngH6S4S0QVjQu8/n3rWcHI4dr
	9g==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9dh43qyb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:32 -0400 (EDT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-90fc64a47edso1149763385a.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310232; x=1779915032;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Vd43LnA947EFq0/DCZQf4Ap5tt7EnbD+Y9KrusTIT/M=;
        b=ew69URn1LatgnUY/sfTGHIkOyQT0Yx6278ux2caqRHlc5syQfNoXbo57i+/OZhxX39
         zxVRAH4x9dLMarjNm2JCr9xiO6nMuktP9agEdnww9zVNwnUMC51hSAiPyhaDDNYLm4S1
         7pHsysHXoFjBiV5DEZ3gq70KO2chLEfil3VhF8YZiqP4EFrDy+M0AqQMKCUnPX1oOfey
         y9V8txSYfaMFrHVFno/GVCrz9poqMzrrtkMJe4F5Ej5SMj92nHi4eYyDQO76I2ul3CXQ
         gSES3PPnBFUhGgCkzy1Ky1OiCa2haTfFt9uJSKnjKjALRLXsxVH4HBmG/ZWrMG8OhwL7
         MZhQ==
X-Forwarded-Encrypted: i=1; AFNElJ8SPkAl/Fq0Fl6+ac4uL5nq7LQYO7e9kdJWVfB80m9GtK+tCuQqkZmr3b8J7Uf+77eOjiXzlwSpCg==@kvack.org
X-Gm-Message-State: AOJu0YwVaufT03Tw084FZxKHwJCff0Z+DSh3yCxtitQKP413nIIZx1WC
	ymwUHDtFGmHChs0pRZgECVmobkWMJx384Hts09V4ZTAo75gpO5fEFUrqaMu0pAtMeAtH+zTE5Go
	ogZVL0trQxiU26HUbBTF3xwRgD5SWO/1NkfFZC+5HPFFnWR5R
X-Gm-Gg: Acq92OFf8cuv78IpDHKlhoP3IvySSlNamGjEaFS3BNwF3oJDpLN4bJ+CIKGdesYEUUN
	6ViMNC7a2Cqt2+DH5KQkZeucIkU5N1Y+YBEqOP/yDkVvTz2sv4epvO3Kkwj99M7VrWjpwyrAu1Z
	7ZCjaJgiZN9ZcmZ2nh+aIxZth+TCulmxrJOQn8XBUPeDdC3SfDjYsJ4RcdKMuirvK9Zz76RCAFJ
	+J3qY/NbZV/H8KKLtcYYCgxrmkKjdqdZqvw2YCDWynFFwyhHXwFwQkTilW75wBe8FwK13qLhBWw
	YNsePI/i+lIfWK3zgF+5IxXqIZrdQexS7cdAXxpOg13ddEreiwOYn5KSlKNL4ev2c58NexM23Ki
	QPRxaeZXg1eDGzB6BwnrCXXTchzc0lLt7lf0d0haZPaghZgEdcAmct7PtAZZAqe99/ks=
X-Received: by 2002:a05:620a:45a1:b0:90d:3af3:2a62 with SMTP id af79cd13be357-911d01b8480mr3765383185a.46.1779310231903;
        Wed, 20 May 2026 13:50:31 -0700 (PDT)
X-Received: by 2002:a05:620a:45a1:b0:90d:3af3:2a62 with SMTP id af79cd13be357-911d01b8480mr3765379085a.46.1779310231448;
        Wed, 20 May 2026 13:50:31 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:30 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:52 -0400
Subject: [PATCH RFC 01/11] mm: add folio_wake_writeback() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-1-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=1111;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=VtCji9Vx3n0Qm0HWIP6UWTPSjZWdzR1UjYoNBHm1Y+c=;
 b=azfgHe+wJUmJYcnwmRy9nfEahOjxOjPQSFoLVtJuTFiY0m9rg0Q8a5Ipg+OYQuIMW9Uilws3E
 gf20tFxHI6SAIQaIiaLwaqYFsnM1ib8jXHnImDriiGvJgm0NNJdZl85
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfXzEiit/CcGOo4
 rguTP3IUgkEMDbjHl3B7ZBagZUFniMtU0stlTwTAuDOCzLE+OUak4CPGS+XO3QsJeXIby3NlYq/
 8azZknbbp/Lr9U+cYvYBWLzA+6MBPhbbsO9i/BwYwvVt3GKqMcChcFprZjK/c75BAZQlq+nyEea
 zld/tSzSQ0CImhnKpWFcEMCTDpFwpVyReGgeTwXGp3lJT68mXhjUGH2rx/U6POLCF49baEEJ3DK
 FClkrYL1lbal8yvxfk/Qxf4E/43ukCMHW6+SznHa8SDvdyb0325Sla0C2jvY9Oq8TLuYUUQMdcN
 fbGAOQTz50yYhEYmngDLjXFvVLLWxxKGZaj5JCiRt/OgrxjHq+Lt19EL5uUkngFtbQj/tVrFfFu
 FfdaUuiJlypoOdBZv8/ndLO8NQWZO/DfVwolX4V/QNZMC/U5X0FoQZ/o62tkXBnEIJfgJcCE6u/
 DmySX+MAzjZ8f2ULgAQ==
X-Proofpoint-GUID: gSc1MciUd8wfg3jSYvEBmZcejUdRs3ry
X-Authority-Analysis: v=2.4 cv=OYWoyBTY c=1 sm=1 tr=0 ts=6a0e1e99 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=s_jWojCdVP8jdXr2cG4A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: gSc1MciUd8wfg3jSYvEBmZcejUdRs3ry
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=10 bulkscore=10 priorityscore=1501 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Rspam-User: 
X-Rspamd-Queue-Id: 688B840003
X-Rspamd-Server: rspam03
X-Stat-Signature: sz7khneebznb5164hratd46m15zqezzh
X-HE-Tag: 1779310234-218752
X-HE-Meta: U2FsdGVkX180IHEDCvL6FvFcjzU1G/ehtQ4u6LnMxE4h9m9vzGup8B4dVKNqYyb9zzTxsZk8cpcbUN9f4JsfRC1wkAQs/l6U9ZxK5M/oHS33abqK4RjG/w/DlkdjGMwqSEDdImu1xaczdWffUWRrqx/0P15FYB57aqlERPSglGsXsh6o2k8UFi3yK1eEPE+8/k9TktKvP+vNTh8kOyDb0+erWkuKCjt3L+RXaecjscFRyJL6UoleZYcKFPWyw3eCYwfozLGFcKuunzpQX3DZNh4prxn+V2ll9M8wpESMKxq/6VYP9ZF17e1lu1ZciWbh10qdJJjWNCWPEnK19G+FkoyLkHX9rFgihnzp+RxgmDBxZ6XvB4l3F1fq03AGQ1cdHNlCCbgQONOJqOnlWA9/iMJdogQotP/vSsAAva7mJAsDC9ISxlznrgaAnHtudRqKWUUYIaa0M9ECbE3GfACThNXViJHqV62hz+85coHVRtSpysrClpo1DQP3czqyUakNeRbVVR16YZQwLbCqqMMEUge2pFRfn3Q8yzBuGCkcfIT9Zn8cCnZmcPS8uFACGu8jsPk2VOmNfOKOy6cpNGoktKYbbEmnonHRlcHatspaufRuomP+a64L29QzSygZ1pZTbxaJNMvByJXd/gSnPGYNqFE8z/9OgWE8b6q+bMUUvnlp3uqd9OVg+rTbi7mBoC+PZk9wncEoTf8jwi1YRP+uLS202XqVD00bwerWVDGKizkXEwEWPZwCVh7rQ1mFrZgLyCMON8A5tKp8wnz/mO17qu9p3M3/DcUu7xw4Vg6SjRL8rYqHkAb7PZGsHW1kbbq0jznAipQfGtlJMgZxy+ZuJ7vB3QFlBMoPVDFR9uvG4WL9ofKxBi2lXzoEgMZLmx9DA1X4G9ktq69lm5tTIlMwE6HFOrXnA9JkJtT9y7/7v/1BC+BViu0wcyONi2HuWRzICi5WrRyzfXFD0spGraP
 43uqDdtT
 nFy1h6Ns2g6eyknaZZQ6luZMoe3UG7j+0GqTLFqo0Sb7zqfB1PfBRiuId7lL6EFTypqDaE+zouqtJ+SjjlbTC+8JFm7avkJCHKX0JLcdHq2RQRF960TMlcI79RS+OU3Ya8JGNftm7Zxcm+NANAyzQ+x7Z+ONjl7Q/VAP4bnhIvoUq49pSuYSfPoUrxJJtYeoAlQNKApI6S4Krd9P7cANHRwieq49QvwC8ZPu4HfgxQ16xcaiNn82Mzz5Rw3W80IYsMntLpEU9kXVxudbQa30/jfkzzewhdIVK1OX/F6cV8TENTpUzx5Lllzsrs0W6gdO5n3hlEgqrHtqimTkLBRCdjsI71ZKxdFuHE0GQ44ZL9UYP2D6NPFtSLfc6TW6x3AzQ4PAK903ymqf2BPfSyKU4Gg/h9N47qFa0HgklTsvzgPxkgZDmSAPE/3oIvn8gCPF2B0ZwMFJdz1iv9xd1yRj3hldqR66AZ6+ACUlaawqiJGPbsxY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a folio_wake_writeback() wrapper for folio_wake_bit() for use in
folio_end_writeback_no_dropbehind(), in preparation for moving the folio
bit lock and wait queue code to a separate file.

No functional change.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/filemap.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5aaba0d3e81d..567742fbaff0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1209,6 +1209,14 @@ static void folio_wake_bit(struct folio *folio, int bit_nr)
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
+/*
+ * Wake waiters on PG_writeback for @folio.
+ */
+static void folio_wake_writeback(struct folio *folio)
+{
+	folio_wake_bit(folio, PG_writeback);
+}
+
 /*
  * A choice of three behaviors for folio_wait_bit_common():
  */
@@ -1664,7 +1672,7 @@ void folio_end_writeback_no_dropbehind(struct folio *folio)
 	}
 
 	if (__folio_end_writeback(folio))
-		folio_wake_bit(folio, PG_writeback);
+		folio_wake_writeback(folio);
 
 	acct_reclaim_writeback(folio);
 }

-- 
2.39.5


