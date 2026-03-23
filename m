Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D120FC72C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A996B0093; Mon, 23 Mar 2026 19:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66166B0096; Mon, 23 Mar 2026 19:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB84A6B0098; Mon, 23 Mar 2026 19:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A56636B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54BCA140DA9
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:42 +0000 (UTC)
X-FDA: 84578995284.27.9F6622E
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90AF6A0002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vCZqKFcQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3r9PBaQgKCLIVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3r9PBaQgKCLIVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Zq8TWEDbszxKidgDH4WcoGu6pRsZKEzAg4VfsbVeec=;
	b=ICg1bZw+M+EFCGhmeFlP4kcoCS9oMuqTTX+rFNquxPaRhkVK43URlpSJp2mtyi96fCmrEF
	F3JvUJ6M+D1FHlAM8UEXsPq5nci3UC745tJE/bFjCprZLx7JXUKqyyHcJ5uyQaUM/SPzwA
	iT2saPgvl8sCphyiXJydE+y6DCUk9O8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310320; a=rsa-sha256;
	cv=none;
	b=R7DEr60Ghzv/tXNTE4ZpEsE7c+M7+Mby8GlnVOjeXyIvl+In1Pl09S0vAWY4omV6U5rcbj
	5GKzFyzZY7nq+6boqrYPdURcGGCGswnY0x4oXBKO6uEMNzkPNtX8ajeeMkgnQJiuW2Tcwx
	1HR+sukdh+f16XeIpm/dPaGIqUl9PPs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vCZqKFcQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3r9PBaQgKCLIVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3r9PBaQgKCLIVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b05370ec01so316794075ad.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310319; x=1774915119; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Zq8TWEDbszxKidgDH4WcoGu6pRsZKEzAg4VfsbVeec=;
        b=vCZqKFcQY4eVXCUX2zghwSf3Cu/g1sG8ZcDM+CqlD7N2xsa3JhknZGaWH7Tjt3gBeE
         7wKGpzNsNPVyHmK35VyCpS5jvvIco0vI+cjnj1Wu/MxakjLM39jfPOvrf7W3TdiEGU8V
         ykbsZZ3lxMh9nj8weXAb1aNBDS76/P+lXqYT+8xYLFS3hWO/CiSo6qwNRn9k/r75ms5H
         /UF5e1Xx50oVd9cOeldeXUNiOde1kG93jM7B/gp9ITLOemxoRjvB+gt02+dvl+koN7Sp
         p2DdtSIMaZoCOVP2gPWCWLOeBG0uEiJXgIIAL/HPWSFSDhH9FofXjakWgZsruXxkDqOJ
         87EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310319; x=1774915119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Zq8TWEDbszxKidgDH4WcoGu6pRsZKEzAg4VfsbVeec=;
        b=rVm+JtNkHPYD7HAfZ0hsEXS1ZY0SoXnr6gBbDZVMgRErMownMlyJU4SxLhUK202jyf
         /H3Kvhx+hSeaChawxj38K31NBtSIAK54NjV7yKXHyGpE68GlGjeZkhiFYyc50+2WGfza
         LALIuliv0xgjliiiVGgq5vAC94PKdOb3aC/muRim2+cHsLc2ZrxC2H8+atBxjNQDMK0m
         NnQGzdgz77tK/G3osmiSPCVQ3JNWUMPVVz0GIeP2axbrTBVSpew2tFkux2t7D6JNtsdD
         4uaj3jIyichUjelT1vhL8AoUZwzsEzA1hviwOAMEVOFX/iXLXyX2/QgBnk1XhbE7zWjS
         sFHA==
X-Forwarded-Encrypted: i=1; AJvYcCUWOHaQ5ZUMQisPlUrpTUGQf9RSQIq0szpQbMCxboVTTgnMnDtWvqUmCeRxpGJbL5HeQvr2jmmIMg==@kvack.org
X-Gm-Message-State: AOJu0YyF+MXHsubDWtIsOCdkS0spdS07spu1OR9Un09pL55EywXsz2eZ
	0FWFeLZ69snoO7aBnvVCmwDFxCLQg1jT5HlKxgIdI+il+8SE4EmdvGyHJMvAzor+BnUhtgXP07O
	/+klY/xHPxnrVfA==
X-Received: from plbjz7.prod.google.com ([2002:a17:903:4307:b0:2b0:5cee:2504])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:dace:b0:2b0:62dd:3a80 with SMTP id d9443c01a7336-2b08271a32emr137995625ad.17.1774310319196;
 Mon, 23 Mar 2026 16:58:39 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:53 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-2-dmatlack@google.com>
Subject: [PATCH v3 01/24] liveupdate: Export symbols needed by modules
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 90AF6A0002
X-Stat-Signature: w3ykijehkwdosx6bge7jficqbpf9gtpp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774310320-585152
X-HE-Meta: U2FsdGVkX1/Bx1BHOgcKFWOBzXB9idinDKDhYq9wrOYpBwW0/1SS9hqkAbwQcq85dnDEkgZzFATl33/6FL5yZNcyigRdfOMAhduy4Ns0BxxdjYZ8u2bUL7Us48u29TS/kJ3NaWelwlw7bNNk+airVFLc2tbPM8BItgv0w9u9jmWgn9FPyXXGrufbKnZ9Dw9kv/y69BM50HPTzhQXbzVmy49BjV8+stuY85+eRDUnTkqi5Nvw9IxkaOsfIZqE89lxcFLQiuER0HK2ndD8MjCfNU42mwcFtganY2Ap6pUPhNSQ3mpMaBeKqQry7/1h/MmgOQ/jpBGbaaeZCgLCEPYWvadUGAVRhr8Pyp0UPN7NC0oO451pKyGD2xPaSBAJ7VP4w/usvI1Ii9j5NzG2tHaEGmbp5QW8Cg5YUfUy9r4rLFmQ00G5tpxa3WZAunKjv82SsNYz7IGNHWCsTSBhJU7MYLhHvtFyG/qv9sF6/O50yMOzZOoHCnPSeGcALvSP3I6WcA/ldYHm8B/mA+Jc3PnQVJOhiBxHvvuZgIfNtw5JO2UW/1EXlbCLeGnFKPbiCRASwdEebh7fPRXj1nI+L0Cz5vNooSjN5y6Ne6m985KWu51QfgbTpVmm0o6XaCA7WBPWp4lK3vJD7fHVD0+HexHGkYiPGhgpyLkVVXNGfU7GcYAjd2UbU+brdr2BMiN6y5Yf6kXRoypZSXylVB4mDof+6HqvFxPg6RrKJPT+b2Xuc5ihkifUK2Rld5YDljy9qbSBnzCB32prjcvyzeK4N8UAg9eGk2yiHTpM7/HmelqCI/GoiNbRgxRWFvpzTlJeBqfOKbJuqtu0xVLR4FRyB2UxOmY+KOepLzKoiQF4BM579337COZ6Pu8RUkmcjrFl2Xzd1JLR76z5YfacO6Eh9EubzOxa+wPjc9AYHWd5wfmds7g8aMPvTs0r8FNgAfWeXdd7ESnKsoDdASve75PUwE1
 oHZ0zfyn
 hibD8Y9Ak2YSgXgovqSnC7R5u6ND01RfAq5mkvm806PA7VJ9L75fSQpOxs3QbPEo703ifrrhxc84Q5M5fN0oIvvKvhRvJ3sNcEjgfuDDb2cjGlJtufcmQFqOw+JyQtJbI/RfRL2egVROby4v6Pp1eT6QQJhzpLtuqKoo/2UD1kDQuM0AXTu8Gk0/sYBQKQOR0Vy7EUDdZUS9RT0fGBr41VWeKn9i0fuYGJeTVkTNvJfSwtHoqXA4wm79sONN5PbMAmrfMHytDX79dIbeop81j9WuZsKTBTWpyUaOV0pcPFivIDYkDex8FpYR14s7LUC//4ScnWSlNAbsE3BOKLzDs2Q2cUSEgrVgA3TfLjn2mtzJS0oNTYtQpQbjlrHk2ufKF/hoP8xMrhOqWLlB/5wOIrWW/Z9s1nZiTPxRwoolSug6Gb3d38crdQUqu4ZfafUz4EkiUl6IgDObsHuUfbPrfFbKC81BNPiV2Es7pwUovBmXR1Q7Ezmj/B94yv313zMKHyfWN4Tn+ot9CQLJslnnFvQLupW1CSIydCEaSvti2EocYTD+eyKuGJwVVJOyQwRuhpxQYAy5SGBICPfwYY7lhuRSaoSyQXdls89c0SvBNQELYhB+6WngqcoC5C8cx+Kvo9ZpCcpY6B3y+Fb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export liveupdate_enabled(), liveupdate_register_file_handler(), and
liveupdate_unregister_file_handler(). All of these will be used by
vfio-pci in a subsequent commit, which can be built as a module.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 kernel/liveupdate/luo_core.c | 1 +
 kernel/liveupdate/luo_file.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index dda7bb57d421..59d7793d9444 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -255,6 +255,7 @@ bool liveupdate_enabled(void)
 {
 	return luo_global.enabled;
 }
+EXPORT_SYMBOL_GPL(liveupdate_enabled);
 
 /**
  * DOC: LUO ioctl Interface
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a38ea4975824..cdc48d49e5e5 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -866,6 +866,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
 
 /**
  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
@@ -884,3 +885,4 @@ void liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 		list_del(&ACCESS_PRIVATE(fh, list));
 	}
 }
+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
-- 
2.53.0.983.g0bb29b3bc5-goog


