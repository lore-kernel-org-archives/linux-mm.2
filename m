Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8640D73E8A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17A56B0095; Thu, 29 Jan 2026 16:05:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4916B0096; Thu, 29 Jan 2026 16:05:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9D36B0099; Thu, 29 Jan 2026 16:05:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7850E6B0095
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:05:06 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5592C1B0B6F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:06 +0000 (UTC)
X-FDA: 84386231412.14.D19F3B9
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9EAC41C0011
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fuhmodv9;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpgSTfoH6x9FkcQxT+wr5JUESeygPnLUnHeiLg7bHkA=;
	b=FR9fk34tkUvKH2Hzk+p8OzIlqBq8WwVSp9Sm0sTVC3MFZbcOY/D/MyE5RG/W+634IGd2qf
	EcuPD73uYKh324snlZlO7CyQmWKZkvygvsrfXkHy30HzY+aSmLsL9FJj2gFUq4tsJAPfgy
	D3B6+doq8zzHLP6a1lNu50vRWRUFL8k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Fuhmodv9;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720704; a=rsa-sha256;
	cv=none;
	b=yXwcyRmdrb4c8LbUDaoINUFvVFS6eOS++ShnDKxFJu3ghBHtSKP/L5Op8Ib4j2jAwlgkIk
	qOjkafQVESbWsESST1akDW+Jgquq704NHJd0A/ZCK7n1nk0WyecA36praeRl5YiJXPIVMU
	ylGgz9mNT8f2JOkEiZEskvxRni7g2RQ=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-88a3d2f3299so16064156d6.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720703; x=1770325503; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpgSTfoH6x9FkcQxT+wr5JUESeygPnLUnHeiLg7bHkA=;
        b=Fuhmodv9afoDqC3uG6qJfzmqL2aKORd0xHFm3XHfCnbqGFJyvDJR0lHXU/CgsikRpp
         bkNuUN8J5s21Sf+qTTRAjXv14+DUR8KEoTCQxZWIggzdnTJvhdjSH7yN8Nz1govi5b49
         KYsc/W/xfPeZh/zmObLtwbvbyCT5k4tMetJP+zSLx8jSKLYVO7ajW3DAva2Yp+jKOR3B
         90/YPJo/cqJFlWAwW+SjMWb4zJ+APaCm8F3EDMMSpN/EgjYENlUyoERVEMncPr8cSg6d
         WR4xeBCF/AtssqEodLH+EoHQNtSEE4iIbSwo+y+9v9Ak4C1/OpeBfII6zvvSlL3b8Hig
         yqLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720703; x=1770325503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mpgSTfoH6x9FkcQxT+wr5JUESeygPnLUnHeiLg7bHkA=;
        b=RnAbq7kOXRr1DMt7WP7bbmFcfr76cyyDJjtyYZ81fFdmHB6gepmuxl7i2UomGmnHtX
         N2VaBOba0jyesAnz7aMJHCB2yrripiBqO4yTyTlBwTN2Pv9Ma74oKg8BxH4tGqeG8ZM+
         aY2Utk1f8vBo66n2EYLdIWBR2j8T64CsAy6fFkCMYyM4EghK9woCyU673qPmssRCH3xL
         TYI1wL7aJ87lFwpSpep8Ch9mCAkGaZV1jy6ceX9yfO1XZuHUODf4j3u2Yn3/TwkPLlgb
         bFXkBPuh6w7xVLHr7P16AIA7akPI8IjFvPm5sb/2HFBijp8Q+LlC1NEGbzx3UxWrk/GS
         gueQ==
X-Gm-Message-State: AOJu0YzeOrDcX+HeW1FSXz/qz5vEZA8Ldgnl9vtwPEs5dBgsOHh5B9Qo
	3YEYqgrSeLnKmmleB8gPmsYcVuIdahUCg+xeUfULDHQqrashBvIQGyvDJeurDMBYfOsx7n2vY1P
	zuN2yYms=
X-Gm-Gg: AZuq6aJ3XVd0cD2PkTvtBbeaRcuNR7PgKW4hNHXd7aDVGfHSsJ433CBwl6J2+lwn0u+
	X/s/SGNrIUgAm+T9qcQZ7zvs0NFEKaNwZXKd4Km5j3YJ0sRZl9RZFLqMB4UDusDJYyEjXaIA83x
	yihigT+DcHf8iOxZx0M9zLoBqUCUzuzTKr0r6aETtW8P1HiLm/84vg0OeIS/YM20tX63yf3ycy4
	m4l6pzXpz3BDMuUwb+EbyxTkpu4zd1rSSlz/9hA8A1tvB8+YhGDnXlqkCejeACBt43dR6p3uxhs
	yQ+UhqycPF5R57pcFhHOYRG4707r5a+ISyfgOqscm5F9TcD8AhOXWQSbWly6wAbRPexfHPjIYdJ
	waHwTHDOUeGuVgs3wJB4W12Pklpc3hF3d2cCH8Za88WO442SgnH6l2GmAC/hzTANhNrsXfNDSip
	kReDbTrcPtrKzQmi/E2cXDCAVQkzBhHOcHWhoiDkJXEXufQ12703XZXWTtcKuK7ex6dLlerZcSb
	v8=
X-Received: by 2002:ad4:5aa2:0:b0:894:78e4:27cc with SMTP id 6a1803df08f44-894ea026eeemr11955076d6.38.1769720703415;
        Thu, 29 Jan 2026 13:05:03 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:05:03 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 7/9] cxl/core: add cxl_devdax_region driver for explicit userland region binding
Date: Thu, 29 Jan 2026 16:04:40 -0500
Message-ID: <20260129210442.3951412-8-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9EAC41C0011
X-Stat-Signature: ofdw6gfh9gfio1xmifiyj8gqjz8e53n1
X-Rspam-User: 
X-HE-Tag: 1769720704-595994
X-HE-Meta: U2FsdGVkX19uFSgGp0scdV1axXlSyUZztjgs7XQ7Vg7TPl37Q4zhXC1WlzQCE4tSJryUTS7UXERVbd4c3eue+Abxgg7PDj/osfVEHQMre79AmwUbTKfKNzvt+FWNH5TlJHDDs1jE9clqyytpYv8Gp1wg7HgjTYiWhwaLN+IqFwNTSTkxWN7L+Dcn41hTTbxxCadfqkgCMInOfslv2BbFDa49vQxRdA3bdmkOz5hSg3wcZVukKm8BXLLQ/IsqDzeTKNN5hQh3ggjPXIJup0V9ejTj4wo2FK86Agk4AxKkMeDZt48IWHVwD0wIkwn1cUhWHnQG2PKZISZQGjf64c/FDEfn72f9lyRbtyp0cswRV8bntU4LXOJGxLbsiABLRm8Ztyq5qO7eee/tbsu8EsvZiMjjYiLTXVkwsekF6Gi4AQsk/B/7zUg5pGq+VpiLYazxYzeLidDEa0alSKShRvKYrpuPQ06pu2tTZgKQWtm/3s9bzCjsU7Z75NJVlSEr6hTc8bWvduRaxvoD098DRomyNBWHQKgFWuYam6cl98rlkyAh0VMH3G4MQV0Sq4HqVmI1vLsRDKGyb1l4Q/oN1uBQwtFBTwN56V9BxK6hBjeUCWfcpjtbbUK7ef/QzredwLxhY71ZmaGmfR9iSIlZN4MggD7rZ8xoXDtR2d8EeqtCWerjsEMOI9QQaiHCBfS1z2mv0ozPUiRhgWhuRRO0qyBxwoznoElqLVpHQOd7WantDArqXl4Unj3HxjMqrhaBqTO+pKQFlBGNwB4wx6R8TyZUqTCow+I3PRx7SO/R5lhnXVwZ2U/xTGczuHDhghHuvC5lLppwbJkmEM1wkXv7LxYYSD06Jleooofzr5m6+U5lVhTe9eIc4Bejpb+MfwVPqwchGSW2giZ6rTAx6BKA2ezqKPxEuabL0HHKrHSnPt/wid8+raIca1sT4mA/fYPeMwRQaoUeFBMkz5tgdtZkMzs
 zkVhL/iI
 vj3Of+hkJXt6ro5c6ul76Zyt0YbCe3U1omrozcL2ol1ctdRRQ5GaQsLAmtkCj1Jzbm9iAvkYSl2JTwzfL1gX93JryTPC5DtW6uZjm+6Df0WC0PUYUtZEEiiakYO5VTs0Ui6KwDJiop/7loGUZGuxdx+Z8AzBihjslJzptdni0hmqJocGyC3kgqDy505GuHfegkwn/RFIEGz5h850DJ1AyBWfAXd0h2pfv1rt4+4OCUBQBN2D82mu8aq0Gsagz9PMt6z5mfxKY1guDliUs+RdEqVFEWmXfqcd6cl/k+a8wr1nU4L4361nMYnCNv4naVrCePpRNuP3zjAXO3P5zF99AHnDDFihRCa4nIaSS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new cxl_devdax_region driver that probes CXL regions in device
dax mode and creates dax_region devices. This allows explicit binding to
the device_dax dax driver instead of the kmem driver.

Exports to_cxl_region() to core.h so it can be used by the driver.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/core.h       |  2 ++
 drivers/cxl/core/dax_region.c | 16 ++++++++++++++++
 drivers/cxl/core/region.c     | 21 +++++++++++++++++----
 drivers/cxl/cxl.h             |  1 +
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 217dd708a2a6..ea4df8abc2ad 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -46,6 +46,8 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 int devm_cxl_add_dax_region(struct cxl_region *cxlr, enum dax_driver_type);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
+extern struct cxl_driver cxl_devdax_region_driver;
+
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
diff --git a/drivers/cxl/core/dax_region.c b/drivers/cxl/core/dax_region.c
index 0602db5f7248..391d51e5ec37 100644
--- a/drivers/cxl/core/dax_region.c
+++ b/drivers/cxl/core/dax_region.c
@@ -111,3 +111,19 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr,
 	put_device(dev);
 	return rc;
 }
+
+static int cxl_devdax_region_driver_probe(struct device *dev)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	if (cxlr->mode != CXL_PARTMODE_RAM)
+		return -ENODEV;
+
+	return devm_cxl_add_dax_region(cxlr, DAXDRV_DEVICE_TYPE);
+}
+
+struct cxl_driver cxl_devdax_region_driver = {
+	.name = "cxl_devdax_region",
+	.probe = cxl_devdax_region_driver_probe,
+	.id = CXL_DEVICE_REGION,
+};
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 61ec939c1462..6200ca1cc2dd 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -39,8 +39,6 @@
  */
 static nodemask_t nodemask_region_seen = NODE_MASK_NONE;
 
-static struct cxl_region *to_cxl_region(struct device *dev);
-
 #define __ACCESS_ATTR_RO(_level, _name) {				\
 	.attr	= { .name = __stringify(_name), .mode = 0444 },		\
 	.show	= _name##_access##_level##_show,			\
@@ -2430,7 +2428,7 @@ bool is_cxl_region(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -3726,11 +3724,26 @@ static struct cxl_driver cxl_region_driver = {
 
 int cxl_region_init(void)
 {
-	return cxl_driver_register(&cxl_region_driver);
+	int rc;
+
+	rc = cxl_driver_register(&cxl_region_driver);
+	if (rc)
+		return rc;
+
+	rc = cxl_driver_register(&cxl_devdax_region_driver);
+	if (rc)
+		goto err_dax;
+
+	return 0;
+
+err_dax:
+	cxl_driver_unregister(&cxl_region_driver);
+	return rc;
 }
 
 void cxl_region_exit(void)
 {
+	cxl_driver_unregister(&cxl_devdax_region_driver);
 	cxl_driver_unregister(&cxl_region_driver);
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index c06a239c0008..674d5f870c70 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -859,6 +859,7 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
 			struct cxl_endpoint_dvsec_info *info);
 
 bool is_cxl_region(struct device *dev);
+struct cxl_region *to_cxl_region(struct device *dev);
 
 extern const struct bus_type cxl_bus_type;
 
-- 
2.52.0


