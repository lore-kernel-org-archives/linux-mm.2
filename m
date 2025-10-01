Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5547CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 19:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF878E0012; Wed,  1 Oct 2025 15:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA7038E0003; Wed,  1 Oct 2025 15:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC748E0012; Wed,  1 Oct 2025 15:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 886C48E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:27:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 57FEC1DE1C9
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:27:00 +0000 (UTC)
X-FDA: 83950528200.20.F12BD36
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7039AC0005
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:26:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BL+NAKMo;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759346818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbYRlCl/Dzj0Jt1PXEP3jL/F9CvbCkzzyw4wzC1Iq2o=;
	b=mNoChmjZb1iy9y1MUgqlpI6ypDfEqEBFb6YiPNOviG1fwWyQtMH2HfNT8phe+O4A7zVl0Z
	PbHaEMAE/KfJYewRcMMICa58wWTWXhcZLlmFYYR/ccFhGbV+/6zyaxa10oitwTqyshQWmC
	vzbSTJ9LYBCUUnuwfK+1Gv8HTRRSW3s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BL+NAKMo;
	spf=pass (imf22.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759346818; a=rsa-sha256;
	cv=none;
	b=8ZFVCtk663LbEKQOOYeLJzSKh6Wiz8DtG1GdfmAXlr0RFVJEw3ZumPFOI87Ca5yVQYdPWM
	lf/HX3cPEDUzB0gHPPYqdZtc1fm9VhPqwYeHd0aTXNzmJ3Y44QNfy9/Las0GSa5rbkaXMD
	v1J+ZPl6eFGvgSFTuMaPO27AxEx70j0=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-57db15eeb11so225763e87.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 12:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759346817; x=1759951617; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbYRlCl/Dzj0Jt1PXEP3jL/F9CvbCkzzyw4wzC1Iq2o=;
        b=BL+NAKMojGGZ4H2YLOicy3Y/zc8xdIgWvSLa35btzA7aNWNHJSaVkrPw+W+F2qCGKq
         TZnAa2jGSkoH1JmJ3aKWNYqYf57cfC8izb+JEW9K1y3ivXKfqUoS2/hvDdEjFHOUm977
         X/iSq1nOrzAvl3SeZpP8s+iBAPHw8q3ajx8e8HEFp2ab6u1/PL76BD1xZEmCOgHFPxDD
         adfSYy8uFKxPIojUAzoGAYdZWYJkSZvCmA+Fhjj4x5bip1tUcLct7qarA8Qq6SBDA/H6
         omvFs3lp42dwwKKOvSBRpmSx7w14Y1HSumm3F3TgDrY9PBmkfIRKy8uD1rrOdVnfhuZL
         Trpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759346817; x=1759951617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IbYRlCl/Dzj0Jt1PXEP3jL/F9CvbCkzzyw4wzC1Iq2o=;
        b=lmTdDOMyJPvaeFri1DSUBDU4AQenCfmF9yqgCbKVggHwu6B3bUgIM3peloBCE8UZE0
         2uaxVjwsFfUVuTMlGpFDJuv9e3BwaM1TltezcjU5Q1H0P/9RsgHnjuLYEyULDaxrfFNz
         cY8IIWrLt/LtxAboCAKfpAG6PfdH8hCUE8QS282QG8QwVic35dR3zgwk0WpggmATgl+U
         FulwMtjtIrYYtnjrcne65YVf2IG4IpgtcIS8EKHt65MF+wmGIzqYrFx1tn0g/brwykvM
         cOVhxPQdRFCEcoIAUqNBovAP81IBtaYFpwoep6WeDHfaTMPFnJWHSP+pe76Z9DgIlih3
         /1sw==
X-Gm-Message-State: AOJu0Yzy63xyrWGIx3zSFhjA5FCw8BfkjBesCAh2bejn0Bq/5LAKwIsw
	XUvKBU94wPdEWlvCLyA5v+fWm76o0uNlQ9mE6GUiYE6fPh4dpF09Zaa7y9HJS6sNql0=
X-Gm-Gg: ASbGncssvgCr/yH5HM5fW5N2wwV3AAJzdBRnW3D1nfxUBQxfaT5dx0OWG3Ev9MF94H+
	VW6iHQ/3Q19bRV+keI0qlwdc87DEhQfqekEQ36CKMixO2ztvYVllKZJWeoDEt7fQKsuDFjMk583
	13nBS98dLxiDil6ANbTWW8srsfFQLqSsuZU37huUFEg9CraAQY5qMoKjDdD3Ft1LZ3NUgcT0ZYZ
	OFi9QsFWAHChSCHVbOU+pXKXc/ojj/9hw7td5phwjn26227Bcs7HlMmrM1DravVifqf7+5odFty
	XXbLnBNGUX9tVfZ0hmE7I/9V4nZWkif+VmNkj2jMLaSfpsccfFS0IiPg8EUsrvVfR7PTHos0879
	e9TjD9sEssmKqO73xUuZEy0gDooUEdHZwWX5Ttuj2
X-Google-Smtp-Source: AGHT+IF9llFN2LXsjgVGkXyRw7BDqyfzeD80j0uo5mXamBd03EZQeOTEdSwaixEgJc8AVhTRjW6k2Q==
X-Received: by 2002:a05:6512:3d01:b0:579:e5da:e530 with SMTP id 2adb3069b0e04-58af9efd33amr1535887e87.10.1759346816620;
        Wed, 01 Oct 2025 12:26:56 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-58b0112414fsm136627e87.28.2025.10.01.12.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 12:26:56 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v3 09/10] mm/vmalloc: Update __vmalloc_node_range() documentation
Date: Wed,  1 Oct 2025 21:26:45 +0200
Message-ID: <20251001192647.195204-10-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251001192647.195204-1-urezki@gmail.com>
References: <20251001192647.195204-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7039AC0005
X-Stat-Signature: yexspamnmpax98pdeakhzuw51nmo66bw
X-HE-Tag: 1759346818-589898
X-HE-Meta: U2FsdGVkX1/cxkiaz20XimaCMOgNa33l4WiEkDPTzwgHxG8U79we1/0OMZd1WaP6nVAxjqrHQmEFGiwMh1RzakcPUlA3CW9bdCmbtKfIVNSAwP5yhiJdTBSz3wV4N3tRsUbdHRGKAWLf+Yob+LEdgTm7Ue6A6zcIxpL8hbvVY9BWjoCmH/RZiW0IzuTGOXlfE/solyNAcIKHUE0d+8n/IzDZBFOdo6t+PRXn5Ze+zk9M7nBN5638KGWg+9gYE2MUUHiY/zcwJST8apS7L8SJtDILy234o3tQ/394wmrHL/we6j9JJFFjgHXpkrh4EJ99KHAQ3Mcbn4ThWzc5R72EbbqYYXJl9bb18Pa6TBmrVqfRrZAaD1m6R1vca1MVj7UjicQ6N0nGWRuBXRf/wpj6FOiWjIW3tbt1QifAAP9MiHJ85PDW3o6CvRS+JSMOktzzvCmGpF7VlNcw8DoktU3TsUznOY9sSZUMQZxQSPD3a7x0BnkG9uZRep0gYdl4I2k9846xRIxNgVXNfOCnYsJpiJtUgmNq5pz82835aCsp/kaslpwHTvMyGn0wkVVlMQqQi/mKyyCO1Usw/+JHddEpBIqBcEFLryzfIbNsq2I7nk94PXrAVSExWreP20AdJao1R3+oqyjNXxfbdbwSDAZa1Bd8HkkJpTM8lG1hx4IDdEHCUAgPmCmv40xa+kzZAifknP4KIUc9GCBUdKNvH+Zf9eELIH+yAJMIgsOPtbajTEXAATsfRHXzg05U4a+zUhezPLAeaJMNaL/cnGrWCyjpUmi4Vgq66YHZWtRjG3LOBFlnysKRwsHdtBFc3SAzMXxTMjKtopXuBldFbEzqhsc7QKn1rzVcSEsdvuVgyLWorlCMex1idZGeIqifdvGK9KADEpvDX8d7Hz2W6ZP3Endhb5kyeVCw9touhA1iYEXsZWEJN3QZ0ltI/3RbISt5rOq/gStfNh70ZtDBpWIL5CO
 nFNLb43N
 28h1S4GHpvrv2v/OMwDaymM10Q1d+ScrgkYDtHQgnZYrlxSvlNjF+D0+42Ckhb1hoWPGc6wsDytiLJjD21/dYNnzbm3ZMEL2Io7lJ+138x0qQ+MTkbSWpYmlf5377A7t/P7xSxbXh08b+SrLHCHIFRi6o77DgRxwDo1Q9HNAnphxdd5APKLBcUnFiRfJCGMb3XCIb1goj4XBoBF2CF356T+R9w5n4236LJTXWfcG8/6OZ6YpyzvlTzn8eoYET4K1sVq2zmQL6XDAabPFIvnh6xRUC87DzSNCxiRi4vYqwdsouNQmU+DdiA8Vzh7m8Wc4ejW/xTVCI9N4rT8acaEdshITeMMMyW2DaG3y7duVub+1ujo297bdW6+l13b7oiiW1X1z5HOSzloNVO7VhLFtGV2W78IGOeR7ehN9Qx+DXkgCGIgKfJ6R4HxG+7fJhkO7UCQR2Ak4DLkJygZP3s3KkOJI6zPkHUG05joIatV08uFcTd/hg8dBbW9Meym+AqjfJ1H8ZYYABM1D8eDQUnbUTm57de8HL/wJywV21hQAv2XBAA+N3/ZAJXZE3Wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__vmalloc() function now supports non-blocking flags such as
GFP_ATOMIC and GFP_NOWAIT. Update the documentation accordingly.

Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d7e7049e01f8..2b45cd4ce119 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3881,19 +3881,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
  * @caller:		  caller's return address
  *
  * Allocate enough pages to cover @size from the page level
- * allocator with @gfp_mask flags. Please note that the full set of gfp
- * flags are not supported. GFP_KERNEL, GFP_NOFS and GFP_NOIO are all
- * supported.
- * Zone modifiers are not supported. From the reclaim modifiers
- * __GFP_DIRECT_RECLAIM is required (aka GFP_NOWAIT is not supported)
- * and only __GFP_NOFAIL is supported (i.e. __GFP_NORETRY and
- * __GFP_RETRY_MAYFAIL are not supported).
+ * allocator with @gfp_mask flags and map them into contiguous
+ * virtual range with protection @prot.
  *
- * __GFP_NOWARN can be used to suppress failures messages.
+ * Supported GFP classes: %GFP_KERNEL, %GFP_ATOMIC, %GFP_NOWAIT,
+ * %GFP_NOFS and %GFP_NOIO. Zone modifiers are not supported.
+ * Please note %GFP_ATOMIC and %GFP_NOWAIT are supported only
+ * by __vmalloc().
+
+ * Retry modifiers: only %__GFP_NOFAIL is supported; %__GFP_NORETRY
+ * and %__GFP_RETRY_MAYFAIL are not supported.
  *
- * Map them into contiguous kernel virtual space, using a pagetable
- * protection of @prot.
+ * %__GFP_NOWARN can be used to suppress failure messages.
  *
+ * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
 void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
-- 
2.47.3


