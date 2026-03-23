Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05AB3F532C2
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6A26B00B4; Mon, 23 Mar 2026 19:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0AEF6B00B5; Mon, 23 Mar 2026 19:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB6F6B00B6; Mon, 23 Mar 2026 19:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB716B00B4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D18AC039A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:09 +0000 (UTC)
X-FDA: 84578996418.05.24664F9
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6878B1C000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GUWgYCsH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3ydPBaQgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ydPBaQgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310347; a=rsa-sha256;
	cv=none;
	b=vqqZeEz+iTCcmfKq66FcTIWqwPgtVjQdZbxYPBVNj+MbZSB1xFXXnLYOOqnQDI3tvhMipo
	pT2omBsll15oEgUlt00b58SgWXdO1hA4uuj94VFhJlEGjZwbvcZkLKhmkTc1OOqTLFwCzW
	/JMwiGrp1VVYpIJcG9f6k9Bb/5H3H6k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GUWgYCsH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3ydPBaQgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3ydPBaQgKCMwv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bCulrz/+ZC3yY//mGMCNHFkV5P7dfGgY4CJSUX7daUA=;
	b=beCj76aEpx0X8PDd7d779C4BRQ7RapHYw86WmJ6DabtGggMgadm+dMhUPxlm2ubIJv1h/e
	mV5mWkgBW696eDqaZQPDzd5o/g08ZsNdkA1kCp+rGDVG1WxhV/6D1KnO9i6kGfojCx8DgU
	kSWDD5Bs4yJ27I5/b6MODYZqPYgHcd4=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3594620fe97so34421222a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310346; x=1774915146; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bCulrz/+ZC3yY//mGMCNHFkV5P7dfGgY4CJSUX7daUA=;
        b=GUWgYCsHQIyCajRBRyQ+zEXNfWshCienhK8wHzdU1LpOxrzLsZ/GkD6LNBiEdtWMuY
         TPSNFQa06E1o55SPDKAIXDcHlnfe7BstotTWr9dEubORzRMBkvjqrFDSu9HaRLGIRv2N
         n5FK6BP5YHXFcBFlrCGMrs7v8IEqP/nxT3RNDp3xxfRnRiYiCoZi70OhgKGZliA288du
         vaaFHlSAzlAnnzkLFnj5fec5/Tc46TKkO/Qcc5+Pt/XczjYYeIMbPWxGAECsxtFx/2FK
         VHVNDkwas98c36+n3A+1LhaQpu3JsCEwf+JQLs9FqBrCwJBuNq9XAw2n7NRZHQq4Yr7M
         CcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310346; x=1774915146;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bCulrz/+ZC3yY//mGMCNHFkV5P7dfGgY4CJSUX7daUA=;
        b=lg9MLsiew8TNYC5L8BMkh9d5jwm+aGB2SNazwFw4Fu428R3tzgjZeJQbU09i9OXj9K
         mJxu6gvVQZRrCB4zz17VvDz8QY03osIEiCogHI/rQ/mV48zKv5onhJq2rhqA36Yn6Ll9
         maqNSAg46m6HDtN4Gk6BPRSkFZk4N7WWt/UQ0Fy4wnW56EEeE5lEbj8xhNTcchjsFOyb
         yzn0kx1ZgQNrBrd0fYGwOOTmY9I2u6LNbHt+i5KXl1ROnLphYT5ZjIUUJAzdulR/7uyF
         XTU+mIkXmK/LSAK+U+SADJ6BLJZ20+ySj4kWmohRvqpcNGIVYbcBORbj0UMCmBDGARkd
         PD1w==
X-Forwarded-Encrypted: i=1; AJvYcCUPPjbBPpNA1+rqp2WgTtivAPe5oiYHBmLYCTuzI/DtUKiS4YoXcLtCM9XGUcyPsluoNBeOjKno2Q==@kvack.org
X-Gm-Message-State: AOJu0YwUvjULd8drFUTJXzsITnR0sSGikQCxWkfkINkKJlcnFk1uyBtU
	j82XlyqflVItWIpRwdiwlARIUabf6saNgl3UvkxxkU4gDx7nrilR9TTXKV+NpQBNBsqRfxGSUPS
	tBeGhQ3+z0hpFRQ==
X-Received: from pjvd16.prod.google.com ([2002:a17:90a:d990:b0:35b:a305:76f5])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:15c2:b0:35b:e4f8:78e1 with SMTP id 98e67ed59e1d1-35be4f87c2bmr4832204a91.11.1774310345696;
 Mon, 23 Mar 2026 16:59:05 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:08 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-17-dmatlack@google.com>
Subject: [PATCH v3 16/24] vfio: selftests: Build liveupdate library in VFIO selftests
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
X-Stat-Signature: 735q887iqrasfsczi9c69yt6fgsbrsg8
X-Rspamd-Queue-Id: 6878B1C000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774310347-57256
X-HE-Meta: U2FsdGVkX1+dNQRgVsHbqkoq/Dzqj795N3ZECO0kxGNkMGbO45CQplD+qzi6j3wdRnlhXsWa70E+haUxzARf5qdfEm41J818ELaXEu9AeS/ffVrHntFf6dqmJua3RFPiS+18nieaORO5KGe6m95R0EGB+5ScWSt/zgT+uS3JO1O/HMU+VGK/h8Co6wEnTd1zVVypCd5vaOkChIVz77Ai0vMxQeZAwLV0bOnEg/AF3WNLN9s0dcJgJOIHPpnHAwtPe23Zed9cBMYuKLsAQlbQcpDyyVWQihkzIkfLndtqTUwBRo6h7YipKzZiMoIJZbY3I8yJYIgDvQ03kpEkaTBF6FAN7Ri1RSTFOLb03jJE3fPcCUGCUtZCxdeehYKhlIKkFXO2d0Z1QZ1mpAZ/q7rS6A1+VgLNa3QZXTrl6+iO03yZFwedlF1i0bnVMkka+zSZ5BOp9IF36G/0NCmmcDZU2kR8G6g6KQSeBXiCzzeEpTt7vCyocARqN6dWdK9jmzY388xfmrODsX2Y+sUqqsjWRYHZRO7h6lQ2Iyu7JXF2ZdZgojjPWQ+vMAR4bYCe5zBP+G+27q+h0//uEExO033JzK6j9dqwS8UiYrdsvBSyeOBCq2vJms/blxULYM0bjZxWXSO2Iv7Xr67AAKenVyoVQNZ2dfNuott6H1dJum/rxbooi8JKGXuSpGiIyZsfA2IbhvNECx8vJbJ4KD7WEZ7t6WV2GGccO+2zgwywSVslu1NS7KkNHgrHiIJFMed2SWnhil1BG75ncMl33Zpep3KTLe1vJlB+FcReCnUyWTfQgWswtyHXgx0D0w2bdVLR68mQV9dX3fduEJDJID2x+nQiAfP00mFGNuch0Qeba8u02k6QRzYPrC/CRhJvrdDpRoO/UZFEEQKGyRvxTrqMBN24084XXZWthOmwIY/IE8Yok+hud1BcSRGW5K8gdOC0PmC7kt5RTt1gjr61sZiN9En
 PDrxeeOt
 VS3EruW3zuBGIjvwL9dAtacJgTA1QLu6JydA4eaH1YMlLDoMZ55sYeU13J7qUv4XDFxxGHQ1Nn0ahJuFihCTq1Yu5glCgJzbzaVW8YEWN+cNmxicQhPlo6i08NRU2LprVckVNoBCH4FsByrnTvGFi/VhKcIudE8DaIfuRuVzTXY4Uquw1tKThvzt0ntvSm+Ck9OlEorEovE5ZeW/JmmKfCET0Qi6CFs1ziPv5Y9ZO6CCl/EXfipFs2uYlgbeNWV7lpa7YbOeC4pfQ4oi4Hpn+lzXwtzEwXR3hOj5cPyDUaxF1A0FRVFXtQmA5mIDWMKweLWQqJD1GruOwD6KA/4KDJseKGVxxJc36vRLqcpRxdsI/vj4j/ByQeL1tfcRHdxEeLVDlTQDK3886F+vmHaow4EOpv1ad9j3cqjCnN64aIQ7k4sIcaQYKtd8ZRziRHhupkpEApqCZev0lBxmz5DvFArAcSFYXXtzni9nvlQquZRdFlf/2BmM8/aWICpSe1aS8k0nkW2gVXtvYrUsZLG+F7wIue7On9hXF8BOizryC/pnrogQyYNeTIAEQpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Import and build liveupdate selftest library in VFIO selftests.

It allows to use liveupdate ioctls in VFIO selftests

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 8e90e409e91d..7f3c94da289d 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -20,6 +20,7 @@ TEST_FILES += scripts/setup.sh
 
 include ../lib.mk
 include lib/libvfio.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
@@ -27,11 +28,15 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
-$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
+LIBS_O := $(LIBVFIO_O)
+LIBS_O += $(LIBLIVEUPDATE_O)
+
+$(TEST_GEN_PROGS): %: %.o $(LIBS_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBS_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
+TEST_DEP_FILES := $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O))
+TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
 EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
-- 
2.53.0.983.g0bb29b3bc5-goog


