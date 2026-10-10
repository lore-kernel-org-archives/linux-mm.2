Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7601DCA9EC1
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 16:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7454E6B0092; Sat, 10 Oct 2026 12:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BF66B0096; Sat, 10 Oct 2026 12:21:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 611F56B0092; Sat, 10 Oct 2026 12:21:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7A66B0092
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 12:21:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 557A0A820A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:26 +0000 (UTC)
X-FDA: 85307231772.24.F5EB05E
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 94165160006
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 16:21:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MmR/HjuV";
	spf=pass (imf08.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791649284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JK7tMUimMJdBOEqaL9WlBjYAfUfZHviVsycPcwxmo+U=;
	b=kFbsMvPE+HX/2P2/WDJYxRhlFk0pQcyVN/YlY579uanc3fm0hlmJseowobV+wxzwtQ7X/e
	gnU7pM8LOKKOdMWnpvHN6BByDdXHn7mQuQVPDVBXoyIOEMZBe6Ag385Vb+NiqkMfOL+smm
	pEUbWlRseH4Y8YYv8wz8xxK6r2COvJE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791649284;
	b=GpSix0WxiejCe0n/HUTvw3SgheTCPidtofeUttVwTHpqom1NDpO5NxuyLM6l3JM+fy5cJc
	mGjQ7fdE1UQr6AEXuVbsrA9+62Btai907BcGF4JI9sgUh+RWf+2yTS747Kyf2Rx7UaZwYB
	rfgcpADY1V/fOfJgFwprZ3oe0w+Bprk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="MmR/HjuV";
	spf=pass (imf08.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1419d3416ceso1159788c88.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791649283; x=1792254083; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JK7tMUimMJdBOEqaL9WlBjYAfUfZHviVsycPcwxmo+U=;
        b=MmR/HjuV2RAa1kiLiWcv0jzAG97qs5wWXbKyskGSwH8CnhGt83pT89uQrCZAgRgJXQ
         mHevMYrRGOKDIXE9Dz5DSF/HeNyAueirMebpqi6LVhWConNLGlccN749ra7JZHBwRoIZ
         7z17qm42X1jZY6g+ATR8KAtmLI1LwZAMNNc9wnOLdV2A74KkVCGzZ3S8PfTtBCmTKne7
         y7wrhb02lIgxtEctBCNREGv0m5sBdzx6Rgx75Z5gJeHnNfeOtvkLWFmDLoun+LVSyJO8
         zlDZGEdRQyZfcMPqzWrBOtYwMQFSnStCTJQyePZVhNBeEGAjldNDfrK74U5AYATYWKqJ
         Nz1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791649283; x=1792254083;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JK7tMUimMJdBOEqaL9WlBjYAfUfZHviVsycPcwxmo+U=;
        b=C17iNOZeaN/UcnA2tUwITvDFWrGKyFpOV6+JNs/DFrc96kuABenyqeBE41MDdHxnoQ
         hblhgyBwWbK6VVa21ha7/cZ9K8ENDCfPkjxCni/0nzsrPxlVm3+f+aDcy7fWIEspwwtR
         BXJHRNClh34J1kKozrCA9RujBNUd0HylYQcmYzyQVeWp589pC2Dchnv2S9XRjik/5GLd
         Irml9L+SfFIhZL4vG6vr5xaITrIdHz4aVMRgaeX48xdvsYC+TXxuD2fwNHXutzwQJJsu
         k0nXujQHbjF/0aevmkoDIIN0gVETQz5UIl7wEFMqveM3RTFDbYw0J4xjxPwU3TFaZipv
         R/mA==
X-Forwarded-Encrypted: i=1; AKwUvByzfWSwn4hG8j6A72jIrHtB1HnmoKPnzff5s/zhTo7WwoTqz1BuZsmNRUo9OVYz3tRinQHwbl1XwA==@kvack.org
X-Gm-Message-State: AFq9FYIU1S3HlZuCsKo0FjTcU4P/04YYY9Gua6KGoziaOpYHKbTX1Vmk
	GvMxnATIE9S+7yHncS8UQSX/vrNIVDgWub/9f8IxHEDUqf1+5s7Vjj8Z
X-Gm-Gg: AYBFou2P+cB0hz7XYELQrPbYm6cea40j8Uj7WFDZxP5kNTZ72CXqDj1mwQsTTp67Etf
	wHRdxC+fr47q2HBTShV9Qz0eJgJyJmRzhnKc6dPA7EbyH5ZUGiYAdDw+Ud7cWfYAusptyGjLGaQ
	ElV7sNTanOe/Zk0uUtDc2DABwMZPamIuNG/D3bc/ECQqkCkD3ciY94jiA7QTDyVUF3bywjGxNoT
	89tKF66L/cL7d7NYHpHmF6H2NUL32fMgs3AU0EiCvGc+9stJLdZ4mqDlbdmX+99z5J+q8Z3QWF8
	Vtg8HWoKzSlP7w+viPtWuwjjMMW+HRkfpoIrcfdMc00SjNIHpM4Kv2Aiud0i6FTXNbte9uOXgM0
	vr7gYjRLo022YwnrL0SDdVcFOk/DXnQE7eUNsDXNwKktteiGcclQl/nTOBjx//UDYioLQxm03aA
	KP3F3dNK0YumfhYnrlQPKt+PQvUtWyVgk43udjjTN+RzO3wea4zkQYbK15wHfoFMAOFyDpZ/zsQ
	+oQckeunEtPU1zMHg==
X-Received: by 2002:a05:701b:4502:10b0:143:50a0:56d6 with SMTP id a92af1059eb24-16a5faa6991mr6411962c88.7.1791649283242;
        Sat, 10 Oct 2026 09:21:23 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([115.96.176.39])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a3f6186fsm15778622c88.14.2026.10.10.09.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 09:21:22 -0700 (PDT)
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <djbw@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Breno Leitao <leitao@debian.org>
Cc: Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Richard Cheng <icheng@nvidia.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Subject: [RFC PATCH 2/5] cxl/region: Factor decoder poison-list retrieval
Date: Sat, 10 Oct 2026 21:50:10 +0530
Message-ID: <20261010162017.62506-3-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
References: <20261010162017.62506-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94165160006
X-Rspam-User: 
X-Stat-Signature: 819fxmz31x83hg9mtt19k15gtuftkh95
X-HE-Tag: 1791649284-792193
X-HE-Meta: U2FsdGVkX180wuE51Eqc5DgfLUTZuiOCTN2Kd4ZWS3FhDbfIVnqALxz3VM4T7pHgu6EjKmN9LrcSQhb3I1iQj9PlZMi2QH9uqnGhfJNB36nEGodwHIuMEy5aHP1Ef06t9XLWnlx0jOb0egKpQkcPWaAVQTeME8ySivZGrp2Id/6OCf7lGty5hJuXNCURdADzqqRC1KzYMRyTXUr+fushZsQLGzz1xS/bX67KqRZvRBjggs3dfRk/6whjKnXZ9z0dC8nt3JkVcRnIA7EeF3uY/KkZS0FhLXV5bZ+GrwD6D53YaLUqLrYsrzIFpFMH0pyYnEzkT4hWEyyBjRYhbApY65MNo9vxAJWY21401IXdnHsvncFCID6rziIHgfgtynMcMWoMNX1cB8whOava83VLFIscWK0+AYBFESi/cemv+LHbTANPlD9995UxpC1W8LJOdAXxYDZLfzyoyoiCF5ZxTRLKWGt0min/CqSdtUcWQO7K10Jlc6bL9BX5RjO/fQiJvdx/MYTXr4vN7HWwqGlxoYNS+uV/i3DhihNnO5ozALHCWNmPPd/57p1E6NTlnQMJu0evcw8GI6M5R1BjnSNpn2JQPLQWhvCO1OQB4NjLNqhwpKgeLxWvJHqTjHGfzEfoeI+hEmv62syv3j03k+7qU8XB06JEuYitbEPpQF3utlSsZfaMTcGO8Qm1N41LnU1TUbJ1HeHFhRjhn5QKSBw70nSUo0izCjYODFcqFSV0Ymoz6klvoq8kBSqclgEXkVboEuuLBcSUGgLuObu+AETnhwLx8t5AblbkqHuaQ4BUYFLdAb4qiTZ5S3qICC5bqgMjLlnIq3J+6eSO8k06R6/kVufSm9R9x7LO3suZ032byPpa/Mw8AXozTmwLkRrQS+ToJ9fgEWlmNGIqDO9Q68rMfFXw+CPKTCd7oglhcMoC4+z2PW2FAsVmMqwBbMrYMp005VozwHXTwQFDvBJUErn
 caBb0P3M
 49pee4dK0XKgesmrJBF4rIPMiypb0tcJeZ0pQxo7TdbrbQ1v8eB5OOt1IHc+F4fk5QRDjEAegsgdtZZgMUrKg76OxjnrMDDYU4YdwoCFxDFpXw+A67eWun/7s5sUJlUtg97VvyY4BKRA69jRYjDIhE06JSZxujMo+1WUyeLB3ZduI1pz+A3vJO+rnq6L3AHS+o/1S23TSUXsIk/f5kruBp6EcjFeFqT82+Gk6V0egVvX7ue9cVZ6zgCx4nVt94z++xqi6si6HdfyoVKfAGwjkp8YpAHHmSNA4nZq53vLMXP2gz6/SP0+vhNuKF5hD2el9mR7/7Y1dIZhvpaJglY443TLxDuLU9GDlCG4rz4qKINWn+9BM7x196A5nrByMfUAPBo9VFG78e7I9X2nhVdjVnWb6nG5KTKHeJfSN2ut84ewdcL+avRRDmM3kD4YdKt9D+X/yDM7pKRIzr2dVVcqEO2K0zHdy6Le/07tgjBOsNtBYR2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

poison_by_decoder() performs two different operations: it queries an
unmapped DPA gap preceding an endpoint decoder, then queries the DPA
resource assigned to that decoder and its region.

Factor the second operation into cxl_get_poison_by_decoder(). Give the
helper an optional snapshot so a later region-probe caller can retain
records from exactly one mapped decoder. Keep the existing endpoint
walk, skipped-DPA queries, partition-tail queries, -EFAULT handling, and
trace behavior unchanged.

Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
---
 drivers/cxl/core/region.c | 41 ++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 75b8092e6dc2..c72524923b38 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2940,6 +2940,40 @@ static int cxl_get_poison_unmapped(struct cxl_memdev *cxlmd,
 	return rc;
 }
 
+enum cxl_poison_query_policy {
+	CXL_POISON_QUERY_DIAGNOSTIC,
+	CXL_POISON_QUERY_PREONLINE,
+};
+
+static int cxl_get_poison_by_decoder(struct cxl_endpoint_decoder *cxled,
+				     struct cxl_poison_snapshot *snapshot,
+				     enum cxl_poison_query_policy policy)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+	struct cxl_dev_state *cxlds = cxlmd->cxlds;
+	enum cxl_partition_mode mode;
+	u64 offset, length;
+	int rc;
+
+	if (!cxled->dpa_res)
+		return 0;
+
+	mode = cxlds->part[cxled->part].mode;
+	offset = cxled->dpa_res->start;
+	length = resource_size(cxled->dpa_res);
+	if (snapshot)
+		rc = cxl_mem_get_poison_snapshot(cxlmd, offset, length,
+						 cxled->cxld.region, snapshot);
+	else
+		rc = cxl_mem_get_poison(cxlmd, offset, length,
+					cxled->cxld.region);
+
+	if (rc == -EFAULT && mode == CXL_PARTMODE_RAM &&
+	    policy == CXL_POISON_QUERY_DIAGNOSTIC)
+		rc = 0;
+	return rc;
+}
+
 static int poison_by_decoder(struct device *dev, void *arg)
 {
 	struct cxl_poison_context *ctx = arg;
@@ -2971,11 +3005,8 @@ static int poison_by_decoder(struct device *dev, void *arg)
 			return rc;
 	}
 
-	offset = cxled->dpa_res->start;
-	length = cxled->dpa_res->end - offset + 1;
-	rc = cxl_mem_get_poison(cxlmd, offset, length, cxled->cxld.region);
-	if (rc == -EFAULT && mode == CXL_PARTMODE_RAM)
-		rc = 0;
+	rc = cxl_get_poison_by_decoder(cxled, NULL,
+				       CXL_POISON_QUERY_DIAGNOSTIC);
 	if (rc)
 		return rc;
 
-- 
2.43.0


