Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44C410987B0
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479CD6B00A9; Fri, 20 Mar 2026 12:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 451CF6B00AC; Fri, 20 Mar 2026 12:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F3E6B00AD; Fri, 20 Mar 2026 12:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27AD56B00A9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:44:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92E8C13A3EB
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:44:37 +0000 (UTC)
X-FDA: 84567014994.17.58DC1E5
Received: from toronto-edge.smtp.mymangomail.com (toronto-edge.smtp.mymangomail.com [209.38.81.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCD16180002
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:44:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=OLWx2AuE;
	spf=pass (imf24.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774025075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlkUSalMj9D4ZyF5iVWhe4Zr05w/l/vA3PbfqbtaeJE=;
	b=sP9mndkjlvLVBPO42lgWkRZgfHbearGn5ezDFVocj2oW+X8qMw1GSTiq7/CqdY6BNEe81C
	BLeIE6pMMF4MzQIp2QxO7nX1zmgocqovEmLGZKEgNUj6JbmUe9hp0vs1gRN/UyXoUnYoR0
	kWxbYJGdXiTnP+7KpPVAuN1m3Oq+ip0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=OLWx2AuE;
	spf=pass (imf24.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774025075; a=rsa-sha256;
	cv=none;
	b=dDJ/xzIzjpcBw6w51QT0Wu9e6mbDHPv5Wmi8/r8hejhwpLuBymv7LCtYMefMN3dIgxapRG
	Epad3RPS0ownI9FvvIn62vjrA9MQcjKHVbcMQR09cYimCA6mGcsj206H0vqLSKQkI090rd
	kEyLOdJIRBtNCXTGwhOh+TLWd2rMaIE=
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTP id 037615F43E;
	Fri, 20 Mar 2026 12:44:18 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774025057;
	bh=LCP21uO2OPKzphq8H7bcRGLaZ+F4b8Pc7Apy117wI5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLWx2AuEk0kG9zBBROAAKPICPPUq6/y4iYKgplAdXo2kKU5ghP/1Vq8FbbPIj5Lhl
	 ebBvCd0GELyrvFcdtjUGEPnro+SFSGOepH/O/gahw3Gs6ss7SlG8rO89oSNO0pxFSU
	 v4crwG1qDceb9CbH9uwzVkPEg7D6ruXeFi9D4kqk=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
 server-digest SHA256)
	(No client certificate requested)
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTPSA id D56385D9B1;
	Fri, 20 Mar 2026 12:43:16 -0400 (EDT)
From: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: [PATCH 5/5] liveupdate: guard FLB counters against underflow
Date: Fri, 20 Mar 2026 17:37:20 +0100
Message-ID: <20260320163720.100456-5-oskar@gerlicz.space>
In-Reply-To: <20260320163720.100456-1-oskar@gerlicz.space>
References: <20260320163720.100456-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hsc5esxrwf4sj6k8mhgb7a9gyrbkagxk
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CCD16180002
X-HE-Tag: 1774025074-302232
X-HE-Meta: U2FsdGVkX1+nWwVAp9D2NrOuXDwopgZUdT60SdNVHvtL/SFlsAK3bX19IQFIW/1uKC60MoigDNFIgMoWHND9oeUTibWlhh7FQfk4+A7PW39BhzU1tD84+FYmkUSysIKaCyDPn00WSRoxy2+zz0tD+UI5XMNIubK948EcuGboHv3k5uzq6U4Tlr0rJ7NunO2TyinrbZLPr6yeewqf4pckWvEtcwjsauQNUCGoUqt16ky4qbyQGmoHb60X+bGrILCIxvgCozTpME3J5fK+6dTBek2kkJEVyz4huR9X41QxN8Bk+YC4hpR5huBFwL0tdkWeRtfBJGcPB40y479kh5j/EbFotUSjc290VLzPFlCX5qdL+YCscAuZnbf98MgSqZknY/YL+/DaU1UvFzzCDMpBjvQx4VtCPU9jwD7Mn/gt9JNwXIOP2yytS2oC9yUNo/6HBL9nfy3RQZMTO4BFjIx0UZX7LHF9rrCEMjcJ07uOboe2bn78gpcqnRucVhehLnEM3y4QekgI/DyGB9d4WxDxXqmIWP3XOe03KayS7to2aA2jHD+6ourXgg+JbZYRf6lULrmMP8p6jvuob004H/+UtYH9wXYFpF4IWYjwMvhlPJOz0IS+MZ/3Uf+OKmZW+UqwrtIpUbbNJxYSyt+f6NaNzPRnJ3ESUDudqoN30Z8F4dk64bVyw7qldokeXd3i1ocexLEDKZFuJZF3BrDp4sToK84JFv6l0pBdzNrLFiqE8R5J77G+c43kNKdOpnkcE/7SEI4BeFLawQDvpUWxUoHX+0Hp2zvPM1MIF/DG5lrVMvbj/rSFSMvwybMmyjgn5evp05o8NfL1xl/QAXfEMT+TJ/+kRr+/+9Q10uTIo16tcSS/jpBDzJ33WYeLDf+tZcGkDYxA0CG59uWjVLDTsyBhKdIQjCJKEuCvkMe+MQUq0zSUfBDUrCvBFc3S06geuppvv9eqO35qBqP/yd2DFWB
 RyyVd28G
 aKho+Dgqd7RKw7qI8C7x/BN7wL4+lcuekVeQHsEs2KRNdpksPswDqyCyNGUwTRXWEHmwsTVFS93TYsD2Rlcpzwo09hBVFhNqfSNNLfVEKaTFNEM/AcGk/HNoIbt8mu/2XLfFq4vQq0aRVQ1TTIk+Qu/1zHx7vkhYa4VZulXGJIgfwy6gzGBIC40JLGAs8UyVGoxMz1DfMr4cIpL16Cf7lwCc5VMJ5x03UGO452wAGBSsVJuFEAr1rbGJS/uZWVDIy9Sx/x1iMSaXfA/CH2wuPDQVbcybUkFMz/MEi/PTFJW/hsW288JBjrDwHNne9IT9razQ6Cf+zXxyl5ZtkvjyaHQunzzWiggkzUlwS60XEqgsPg9hB0EIH5nBI9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The FLB lifetime counters are decremented unconditionally on
unpreserve and finish. If either path runs with a zero counter, the
value wraps and the FLB state appears to stay live forever.

Once the counter underflows, later handover operations can act on
stale FLB state or skip the real final teardown, which makes restore
and finish lifetime tracking unreliable.

Guard both counters against zero and warn once instead of
decrementing. This keeps the existing lifetime rules intact while
preventing wraparound.

Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 kernel/liveupdate/luo_flb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 3672cbf8e075..06501360fa3f 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -128,6 +128,9 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 
 	scoped_guard(mutex, &private->outgoing.lock) {
+		if (WARN_ON_ONCE(!private->outgoing.count))
+			return;
+
 		private->outgoing.count--;
 		if (!private->outgoing.count) {
 			struct liveupdate_flb_op_args args = {0};
@@ -201,8 +204,12 @@ static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 	struct luo_flb_private *private = luo_flb_get_private(flb);
 	u64 count;
 
-	scoped_guard(mutex, &private->incoming.lock)
+	scoped_guard(mutex, &private->incoming.lock) {
+		if (WARN_ON_ONCE(!private->incoming.count))
+			return;
+
 		count = --private->incoming.count;
+	}
 
 	if (!count) {
 		struct liveupdate_flb_op_args args = {0};
-- 
2.53.0


