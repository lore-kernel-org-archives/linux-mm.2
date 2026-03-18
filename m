Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A6E2103E18D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F13C6B024E; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9575E6B0255; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731016B024E; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC896B024E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:17:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BC5A140799
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:08 +0000 (UTC)
X-FDA: 84559385736.04.8E7015E
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf14.hostedemail.com (Postfix) with ESMTP id 29379100010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:17:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RwkoAJud;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773843426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJIAgTqcwEqKxZF+DzcRiR6G39ka6soPVjhZwY8SjyM=;
	b=XErbX+xzi92CnHhzq5Bmo5AN/UuznonRoP5/v/zzp5i/Eonfpr6wjAyBW2J12KHWYO+jmL
	0a8bB1PC9246IZ9MQMpATlaHYmiQjJFncv0a3xdeBTQzvUsMIox6grBBKsERc3EmG0Q7Df
	bPilCc9BxT11+WEGUIUhu7N76vPixoo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RwkoAJud;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773843426; a=rsa-sha256;
	cv=none;
	b=4hIf1l6Bn+Ba3LKM/utA47s2dQ34S+6BvIaMzcO34jLN9Km6uMhGMMF+Cciez4L4/JhY9e
	Lk5Bdtkj/wx8d+GR/Yu9tdmczNFQhZ6YXc2cFBt/5TMHdiav7KgavvZcqwTUSoM3FKhM50
	szGL23dnD/TjAZlT6Ko6Ml4KNP+YQXk=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64aedd812baso7040909d50.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773843425; x=1774448225; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zJIAgTqcwEqKxZF+DzcRiR6G39ka6soPVjhZwY8SjyM=;
        b=RwkoAJudz4kmFZE1YrOI2H95rSphhaOv2KE08KQnxkcBDXzYVEI27hqWDsOCqksOSS
         QuhAgOxNE4Z0rBUDs3M1pI92y8h8yfP9D1Bfu9VYn5r8N2Pd/Ws3ku9TtqRiI7E3oOiI
         aly4XVekfQAcSA+v0TmTOwEyiDmWoBGvtBEFkp62DHLucWkJQfr5oX7slH5NNk7VvJnL
         768A57wwj4t5EsRE2t4PUSEK1BFPYHsXcrsLCsxHTRCKHXL7oFz1FgrDcAkwgGL+DejD
         4mkAGuYsFhWGa9p4+2AM+ror/MFBi/skIN53CjTDQ3Y1wv6yFZkFSOzii0q37x07AjY4
         B3Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773843425; x=1774448225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=zJIAgTqcwEqKxZF+DzcRiR6G39ka6soPVjhZwY8SjyM=;
        b=MKw8xNBUF4DTrPjkyvUqjaTB3Tnw8xqv42vjoTkaklMSLiweNEUu2oz7ND3/Rdm1qq
         XgOtBIk8toootVPXD+oBOigmVgbO1lRe8RzbiNaub57j3slQc9kwW4kl7aRQmkAAiIQF
         E0Qnn6uuLL1ZbYa2wCgoa+sY6UCcl1MxI3XsUVa9c1ETSld59MH32VxAlWYNgoMLIF7N
         7NSZ1SID3SSfajl4BYPcXgVu8iuBQNmagm7RXDxai+4Tdzv30RjUZhDhyCCaTX7h0q69
         DwAwXlm8Zl8NU21W0pqvJLmdd28/xjw38JL3FrEwF1TAx+6S8xokE38FSvKYT3HMUslI
         Ci6w==
X-Forwarded-Encrypted: i=1; AJvYcCVk6Khhp3D3BYBXzq+NxYTP3BD6CKEHJQcdxspR/5G0CuzgDDlTS1bjcafe1NVIKB6JQgsCMPbXOA==@kvack.org
X-Gm-Message-State: AOJu0YxPFxcx1eNAS60P0E0HdwNnWumvD905uAwv35u8G3MEZSva7UYm
	5ZkMm+0G/OCbAPEKVAZi2Uva/jb2q6t3Y7ph3B1qqrb1C8fPMWgT2eTPCgtcBY8HME0=
X-Gm-Gg: ATEYQzwv9PaZPjtmKhQABkzs5E4v087sgb/b/PXv8X8nRI1KB9UBvrKOpZBoJz7WBOo
	pQqy1M0lcV2FLx0i2YdbazsnS8JUif1DV8RaBdJ/NYdxRaQ4p5hfaPIA+kHhNuXZKbSn+E+DQQX
	2fqPY0Os44ttkPtQv5UpjyqqpIViElec3OVlhFDF1zw8Cb+mgK+9uOiaQvC/Mb645IjiDytxd0W
	0QHafP+/c0QZUpOHXDqNqP8f5XQGzqbyQuP+G77TPu21x6vhJ+2V1h1KshW2htfSa0kAO/r7XBK
	7YqwCANtrb7lkiuW56DwWx8tb6IZ7qqtN6cniAV2P+APfY0unr+yPATl8puNhW0D6Pi7iDF4sZ6
	i6wuqW9VovBdFKMzKnHM5te5GNF+NIQ4y6yI9zQa6PJSywD+oz5WAMuEkyFryFMr+5e6lZ8Je1x
	B/ZI7DKyi5YmV/CfdwnNARAvjfh0AQ6QCJX/fjTK6Mxd6FtS2i3YO29aGkptgCd6RQ/DvpwFu7r
	FTyQuT8VW2uU1mDeHwkJDe3MbIKLJSSWv3n1bygaMqQFDyk3A==
X-Received: by 2002:a53:b451:0:b0:64e:7d41:29a6 with SMTP id 956f58d0204a3-64e9172c834mr2927143d50.78.1773843425032;
        Wed, 18 Mar 2026 07:17:05 -0700 (PDT)
Received: from soleen.c.googlers.com.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64e91be0e91sm1672028d50.15.2026.03.18.07.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 07:17:04 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org
Subject: [PATCH v2 8/8] liveupdate: Make unregister functions return void
Date: Wed, 18 Mar 2026 10:16:46 -0400
Message-ID: <20260318141637.1870220-18-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
References: <20260318141637.1870220-10-pasha.tatashin@soleen.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4047; i=pasha.tatashin@soleen.com;
 h=from:subject; bh=iQJqefJr/CoUSt54uwlSGDn/SfrrD/dJQLTwLis101Q=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBpurPQ01nnBZVHBvgS5KZW9wUgfyP0EgxeiXQoQ
 Aio6skXjrSJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCabqz0AAKCRC7dyhM23N6
 3qYdEADIX8djMB8QpL7SqEjHbjgNU4y6AHtYiJSRuvwaqKvRH9B/uTysQ9JuByNUn+QCH+u9yOI
 uAgpflNxMb3xxezKl/4CjMyqMwjxcIhdw3kAY4O5GoJsMHpCDtqVfHLPJ+CH31h1hH50Il0NKGV
 AcT3X53LUz0Zlv7nXC0/5pB+mkR0KSLbtrCLMs1NNl3RqJ43a+2jtRq2+uYnqakButu+3GcdBx7
 MjogkEWuhtHzgYCI0sa8gq8AdUFMxf8Ng62w6E6DGlaSOm8h+V0xKlV9ZczAeQ3oK7eis2RdYuA
 Y/zb58JqMTHw7jILMxq8Q8kUiv/5AI3SS/jLuyE7eDwUz3s627zXDITXdBOkkW6QcyxFNlFMu56
 jQVigdcJm/8S8w9d/3ghjQ8Jr7QuhlG3SptT8J9QG4Wld5Zi13Gcd1keHjw9Tp5QDzVk2yfHMOc
 a//f0+R9F4VJshhpzAlFiJzVpb7GE/gCxB37WyLq+/av7UqWlRICO4o9J9TTcUujty4N4LekaS9
 VtluW/IkW4XIviSrynpY4KxRWo4kiBocTX+d+SlK/sj6nKUhG4KW7IrTg7V3uK9XO5x3lD4AR6Y
 EJfxB9ZuNiX7eruEQWckstsGNqwrh+d11lM+YPWBix0OTifxDCn3iO/m4PENWX3FBhfYWa+qOAy IrUAF+aiUQjauCQ==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp; fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29379100010
X-Stat-Signature: dienyf8ss5rdxtzmdn5msmw141h4d3k6
X-Rspam-User: 
X-HE-Tag: 1773843426-818121
X-HE-Meta: U2FsdGVkX19KQFMWRHK39g0/VCeuO7GakvlaVhw+E5uFr5pY9K2XmMzD4vy1/qSznfYvAsvfpgG2XqhcreFie8lU9dGvp88bBSgB+9E4F+LmhjIXIrxMKGvUxIzJhrPyFR3vLkVcuF0EvnDp9O5Kax28B6Q1Zq6jQWeRbENH0kq00juTAGmqexJDTZh8VQQUMhxJKvHNJVpGqacA+IhhrofU2uszg/a3e4P8k0O44ERGUva3CEL2esPIfGxF2zwmaldgUvl7+vwUd29qqy47BzK45JXfa8FEyl9Q5UzX5/BZPyBY8siEEyya5RmHPa49XtVgcuxNkpE1gT+bxsm73FlP1GNAdrTBjibmkULZLZiyJnG3HuhFVsuGB0xdGyyaGp0dINgapnNMnoaHrFEomiwiu1ULjkdCvKC16UphXuqc3lWfScCA4Q4eZi+nYHpIOtrkFbXxrNJNxxNO6XCMS2sha4Lxi/AT3j2TD4JuQR97/VDDxH2eqOZmU7Jvi418Y+vtP2acQEkPWJDrq5JA+4LxVEDv4kPNT48G5JrNNGTfw2bFxbQTDNi95OCSxh3rMF/zbaqRrwCJbsH6s7n6275Sr+ae+T7DHKh+bOjTjprwNG/XleVO0+BLsb//B4KuBpbojO9fIG71FIZwsvx/NEMNqT+ppVAn+sQ6ryHgrTzcvPPh130miUpe9p25yQN+w/WEfIhIJZg+6xhL4hfAYgx3osWn29c+L4CYZoh9qQsA/aGc3fAKTZQnIAWVD2TWKRWE+dseeRZQxOEotvKcv8lJPoM53y3GIjOLF4J/T439npmj0tfGO20UWfcblkat6nKL2brLXWLZsXdOxCKBR2mCVegaGvolt4W0jKLb0cyAxMyTyGBeR2fMsgAh6i9uxU1oqriwEIiOH/FS1FVbJvGBp9aDl845mxtkyOrEBn1OfOaGFBnAny3TRavLi7P7oRrby0g2hcWnsjkz75+
 4dKLgnRX
 9KW+dHIoRcOrrWsI/Xi2EdROl18oVGj7Zvp3D6+tHWMN9EQCHT7xS24WmRkInAdq+NPxpBRBQWHL1gZv0vrYA2nrZ8OVi4Niyx2ONJ6iRFNcVojy6rqOedCZ+V//bxarDR3X5OZ+TQxQJ8rQq3etcE1/aRDYFlL2JEow/V7nuoiy9KXCHcn8Tbbm9jDdHHKWWI/0VRhrzDlhR+WEF5k8T2E0lZtU/ocya3OE0KrkrAWb0n9yCg3v0Ncb8oMqVoLaJBpu5Nznbx05h9fP7jFI3NLt29qxtDlH/NN1I6tFwSFUwuFZKL8f4xWI8JYlUu2T2Yky159a3AMAZTRsRs8+sRfS1XDhe0FhVQxjH83vwmBL+tiI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change liveupdate_unregister_file_handler and liveupdate_unregister_flb
to return void instead of an error code. This follows the design
principle that unregistration during module unload should not fail,
as the unload cannot be stopped at that point.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h   | 14 ++++++--------
 kernel/liveupdate/luo_file.c |  6 ++----
 kernel/liveupdate/luo_flb.c  |  8 +++-----
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 8394fb2d8774..636175432d62 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -231,12 +231,12 @@ bool liveupdate_enabled(void);
 int liveupdate_reboot(void);
 
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
 
 int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 			    struct liveupdate_flb *flb);
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb);
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb);
 
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp);
 int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp);
@@ -258,9 +258,8 @@ static inline int liveupdate_register_file_handler(struct liveupdate_file_handle
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+static inline void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
@@ -269,10 +268,9 @@ static inline int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 	return -EOPNOTSUPP;
 }
 
-static inline int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-					    struct liveupdate_flb *flb)
+static inline void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+					     struct liveupdate_flb *flb)
 {
-	return -EOPNOTSUPP;
 }
 
 static inline int liveupdate_flb_get_incoming(struct liveupdate_flb *flb,
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index c9c26015020b..a38ea4975824 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -874,15 +874,13 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
  * Unregisters the file handler from the liveupdate core. This function
  * reverses the operations of liveupdate_register_file_handler().
  */
-int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
+void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	scoped_guard(rwsem_write, &luo_file_handler_lock) {
 		luo_flb_unregister_all(fh);
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
-
-	return 0;
 }
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 5b61c0844a49..874830f8e44d 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -476,18 +476,16 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
  * owner module (acquired during registration) is released.
  *
  */
-int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
-			      struct liveupdate_flb *flb)
+void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
+			       struct liveupdate_flb *flb)
 {
 	if (!liveupdate_enabled())
-		return -EOPNOTSUPP;
+		return;
 
 	guard(rwsem_write)(&luo_flb_lock);
 	guard(rwsem_write)(&ACCESS_PRIVATE(fh, flb_lock));
 
 	luo_flb_unregister_one(fh, flb);
-
-	return 0;
 }
 
 /**
-- 
2.53.0.851.ga537e3e6e9-goog


