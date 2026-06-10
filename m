Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 546DACD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC0726B00C5; Tue,  9 Jun 2026 21:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A606B00C7; Tue,  9 Jun 2026 21:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5FFE6B00C8; Tue,  9 Jun 2026 21:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98D796B00C5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:45:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4399314070A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:33 +0000 (UTC)
X-FDA: 84862310946.02.8E03285
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7032316000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:45:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fplddgwa;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781055931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pKutm9+cyTIXeV2mo8MjsDLORYjIUZMG6rmHK81GwDk=;
	b=6/hrMWt7zyTD4N1Xnia8kBtelIJn3hTSGyGqKuU9JkMn51TmFCF2+7yVClr1eE/tnhMQAa
	aOZhv4BC6eJMfEdSzUSRTl8MyGX7q6CKa36S5rSzmpD/yHrHi4DI7Ip8cdLLI0NqWcSldD
	WYPbzE8EPZUSoT8ds8DpcV059KuTfio=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781055931;
	b=hpa8BDtBC5X/yH5qXhQcCTmjIx8Wg4KKOF3W4a5L4+YbAyii53iyxKXrgoSuOOqacAzD18
	HN0AqFKyE2P65dN/d70+G2ylZ+dM/OO9jdUv5UlKjdrpVPR8b83HK0eIFJMUWrMUfMkz0R
	7RHiWj/oevvClhQrUDpcONlgyEP+CTg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fplddgwa;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51758478240so30919001cf.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 18:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781055930; x=1781660730; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pKutm9+cyTIXeV2mo8MjsDLORYjIUZMG6rmHK81GwDk=;
        b=Fplddgwad0vbMglkfGgYpi+6dwbhaQ+4Qu9jES2BVc/fYSpsh7w5iHkcEir0Z3vTsP
         vLDt+ticqMi4hvyJKOczSw9FIQPKhRHuYCC5VekpzvyVCOV1FqxTrVOyA3T6qDDA8i/O
         8vCf/RgaF7QOXzBZ3ZdP3n5H3/xWovUjS4gozbVeNuh69XkubxHDEze5xxTHfh5To86h
         jqlaZzKSFJIJ7vJkabvO2BpELxw/A0SmBh5WsmhToIv39wYb949ix4cXyLVPUk/IMrWG
         8uUCecrFR3jtDPSDy1svI5y9btGqwDVptvaZULNhOnRSVGUSW0SAhbBqr/anUEGG0Q/J
         jyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781055930; x=1781660730;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pKutm9+cyTIXeV2mo8MjsDLORYjIUZMG6rmHK81GwDk=;
        b=d9PU918MOwlXXOyb3+CuKnetnWuBijiL8iZJgYxcYCUsxPPFnbgT6R9T0IIh9yZLUE
         z8gl6Yu3PDOAslbX/pkRYCvgDXoEXhFvjDLAnb7QDl0mcX+PT/klBBxcUqHx++ags0JK
         j3N+OyFxInXnp9NQbK9lDwB5LbiEOGe1thjCLRsN9cA2Zw+gJtq7V2I9DFqZTWZudZUu
         cWdOg7f4/cKc0JhdU4qHtdySz8tEm/2amx89PVr+ETxTljiyKl5UbR29/EmGX6HIGvlp
         JZapaRmKtRWBm1Qp+Qf7X6acF8AGWjYILi+3fGlnWhhaCkVhHac4j7uvf8p5v9MbEDVb
         iCzQ==
X-Gm-Message-State: AOJu0Yzchsvl30LZ+R0FmBB4JdPNlxZlTaLCKfQk8HzRaB9PW0ehZa5n
	uBOWS5517qLuHgf20wpKOzXeSIM5gJt65Mwa58D2aVGWP/0IdKmDqa5UgNBv2lja+PJNZlZi6CW
	LNGoY
X-Gm-Gg: Acq92OEzEmCPslPEOxZ2PQJE5U35aQfJ1xZiemH1yK6tvQi8BNB5Zqq+q+SKMdzGirR
	Lkraztt87xajNqbt3rK76SabWRQob8ABOfjyWPxkv8TYk4kNzwwJPPWNo5URCXgC58oYkUehjZs
	U7a8QXPPDK0uZgSnpov3o4v+gjNJR+JtfkcjaPHnraUrqPZdW/cWCdcnjwN83MBN4MWKPGcB6vx
	9Htd9LoG/WUjvotPhyIUoQ9Sh2vszk9pcbm9RHqxlcyy3VynX2bqWTLVGwYxbBnOfD8OhjR3P/g
	SF1Hl7zUGzsGhfIYGhHeEw0ICTy6DYtcFaFcN5xDYHD2z1w+RfoW03Ia9J25Pla6rIsa21H5en5
	2abJPdzUJqGRUwQ9GI2ork4MwuiD49cOmfeba3usKAqcemOH3EzuVxVuBcjE980cF7l6MVU5wkl
	4dBNuLR5xfNkuc5N3u/xbwWtAPqSls4W2vDAt1XmCTJMmNg1Ex6s9UO+KanRYPSXgT0zzatM1ms
	SE5Z0P4Vhi9WmU7WM+OMtg=
X-Received: by 2002:a05:622a:155:b0:516:cee1:4727 with SMTP id d75a77b69052e-51795aeb96bmr323037361cf.14.1781055930465;
        Tue, 09 Jun 2026 18:45:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51775c07e91sm205923261cf.4.2026.06.09.18.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 18:45:30 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: x86@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	driver-core@lists.linux.dev,
	kernel-team@meta.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	rafael@kernel.org,
	lenb@kernel.org,
	gregkh@linuxfoundation.org,
	dakr@kernel.org,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	rdunlap@infradead.org,
	feng.tang@linux.alibaba.com,
	dapeng1.mi@linux.intel.com,
	elver@google.com,
	kuba@kernel.org,
	ebiggers@kernel.org,
	lirongqing@baidu.com,
	paulmck@kernel.org,
	gourry@gourry.net,
	dave.jiang@intel.com,
	jic23@kernel.org,
	xueshuai@linux.alibaba.com,
	kai.huang@intel.com
Subject: [RFC PATCH 2/3] acpi/numa: add CONFIG_ACPI_NUMA_STANDBY_NODES
Date: Tue,  9 Jun 2026 21:45:16 -0400
Message-ID: <20260610014517.253609-3-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260610014517.253609-1-gourry@gourry.net>
References: <20260610014517.253609-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7032316000B
X-Stat-Signature: 3jhyqtwrymaaspf877ff7dwg7qp9ahkc
X-HE-Tag: 1781055931-973661
X-HE-Meta: U2FsdGVkX1/xn6M2gekU7PiLXUyTrb27HEx4RaxRlGbZPa7Jm0QdcP4oC5c3Iq7ik+bKlk/BHSb9gvgphnrKBriS+F+ESxr5U0XrUi/hzsEf6kueNqToEuUg/05mQNwMwPump7ve5ciKZsssDz4KuXoIol7d59rXRfH6jhi3c3YOVtXnoobxe317OwNioEykbac/v4DMVi7J+Rlnud+ensrJvuteqp9YrbG02dxkj3p+Oqg+Rv0Xgxdx43g5PnGkcb3ynNwmxiyzWom21XdvxRrlJ9WJbH8HBPlC4WbS6dlauwrloZEadq6Y0jzhIQpPS01ycIvToRcmVz0WMEHALDGEQ1Q/Qa/9X2eW1D2z23wWO53Hld32aNRAbEC3zz4bXvWD+/6sy2YhpR/ua+QtfmoIFzhSAWRRWz7s1CuLHBjG03P5wwWUTQdphlsaZ5LGwc08Ybn7GTkRuMyOzLfgjgf7vrsW7nl88d3LqUEasNMw+3WZPnPHHZhygMDt+vBqv4Wb9eFXIXx4GthkaQDgcvqRxl4/xDJIQroNpiSzsNq58ZgQ2SSyKMitVWV0JZ8IIw4vOs1FHM5kAvKc2tcxBX77txsbl03N4xjLwf4fUU/tIQ2TVwVKem6u5+/SV3ci73Gpx8yHCHIAKsFXjJJ6r+NwACQB2Jw5lVSomN4M/Q0K7hZT2syiVT/U1ZuvNcXkYPF3DdzDrlDFwPO81nMEJ6ZRIYjVS3yeh06OhwjbB3x7h+PQhu/ER18aRx7CEJxxy6QwnBWKEN39khbjF77bK2O+4p0cD+NfgWvnkA9zDT0m9CZXmrQcZdBP0v7zZvhKPscdubPvfd+wXejnW5/ZPm9N0MGIrzV4zwcs7TuttGbH2g3RsvbnTbN0E+VWf8bbPZkx8NAdCSbiTfJZe1dtEFN3pvTYKvrjHh8ufjDYO8YZqUipMaKsQNTTq3LAA25DVjnmsqaFXKJ948kuTK/
 QdrUUFuf
 Uv7tBuGnK9wmndpR+lAX48cQafKG38OUNOZ0C5RLcaLjHpQbWpWRX5+95CkPsdEITcNrpZnEU1phRr1eHaR1asuJnDAXFiWo5Vq41D2fAkDYWcJ5pFS2IAVfWuH3UWMTi1l5aZ4Wkn8rCN6H9wWp/tkGQHgSeyGUO7bmA1/GDzLEmvxC6MKELEteKuBCDNiNyXHt9ntQFL0ye5MuQ/7TSWqDW9hmUEw9U4GHpuVL2IWjz8T4DMSZa7CvGNs6fVvvASV0f6ulhd/v2WH4ymmSlgGEmP+W3e5RhWah0rpXIyfssECWClr2ap3wp30fFw7aGhJzMG6w09HMs+hjnHueZzOPi3epVRxO1lBND
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms want to reserve empty NUMA nodes at boot so that drivers
can later place hotplugged memory on distinct nodes for memory tiering
or isolation, without those nodes being described by BIOS.

Add CONFIG_ACPI_NUMA_STANDBY_NODES, a platform-independent count of empty
nodes to reserve.

Deferring standby node creation until after NUMA emulation runs keeps
old numbering behaviors consistent for NUMA emulation users.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/acpi/numa/Kconfig | 15 +++++++++++++++
 drivers/acpi/numa/srat.c  |  3 +++
 2 files changed, 18 insertions(+)

diff --git a/drivers/acpi/numa/Kconfig b/drivers/acpi/numa/Kconfig
index f33194d1e43f..ecf27bf45e5b 100644
--- a/drivers/acpi/numa/Kconfig
+++ b/drivers/acpi/numa/Kconfig
@@ -13,3 +13,18 @@ config ACPI_HMAT
 	 register memory initiators with their targets, and export
 	 performance attributes through the node's sysfs device if
 	 provided.
+
+config ACPI_NUMA_STANDBY_NODES
+	int "Additional standby NUMA nodes for runtime claiming"
+	depends on ACPI_NUMA
+	range 0 16
+	default 0
+	help
+	  Number of additional empty NUMA nodes to reserve at boot for
+	  runtime claiming via numa_request_exclusive_node().
+
+	  These nodes have no memory and no SRAT PXM association.
+	  Drivers can claim them to place hotplugged memory on distinct
+	  NUMA nodes for memory tiering or isolation purposes.
+
+	  Set to 0 (default) to disable.
diff --git a/drivers/acpi/numa/srat.c b/drivers/acpi/numa/srat.c
index 62d4a8df0b8c..d7b0e4ece610 100644
--- a/drivers/acpi/numa/srat.c
+++ b/drivers/acpi/numa/srat.c
@@ -664,6 +664,9 @@ int __init acpi_numa_init(void)
 		return cnt;
 	else if (!parsed_numa_memblks)
 		return -ENOENT;
+
+	/* Request any standby nodes (created after numa emulation) */
+	numa_request_standby_count(CONFIG_ACPI_NUMA_STANDBY_NODES);
 	return 0;
 }
 
-- 
2.54.0


