Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D4CD73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF5526B0089; Thu, 29 Jan 2026 16:25:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61016B008A; Thu, 29 Jan 2026 16:25:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D235B6B008C; Thu, 29 Jan 2026 16:25:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C04C26B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:42 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7FE64B6FFE
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:42 +0000 (UTC)
X-FDA: 84386283324.22.432C897
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9D0F516000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ac2ih3ou;
	spf=pass (imf08.hostedemail.com: domain of 3U9B7aQgKCDYVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3U9B7aQgKCDYVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXsfpp7fYjSPi1nIw2ScrDnrjqTlWGi7ZArDWIRjDgk=;
	b=sqb48qBpqhTOK7cy6+xr3alFzxcwXAJFF5MN+w/F12l2aMDOAus1hEKxBYzM5iSfB0cc/U
	0KQGEja+wcDnLfK/55JmkfUcc15YlRUEQpuWYrea47AmFxygFobIEWfe06baiQrtxvA8/e
	iHJHtUZFJVtojZtVZEv3ZPuaH69TC24=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ac2ih3ou;
	spf=pass (imf08.hostedemail.com: domain of 3U9B7aQgKCDYVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3U9B7aQgKCDYVeSldSUcYggYdW.Ugedafmp-eecnSUc.gjY@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721940; a=rsa-sha256;
	cv=none;
	b=jLKuKStd7z+xpZ6OO11hxKfB7XypFkoo92FWPq3D3ha21kd2rVXiyIgc0dDVBlCyb7VGFX
	IaqiPfpdW3fGT718RqiboU5HG2iTNcrM1tF0anhoQRt7U0xXp2uE+EKKBQxmhymOfhMU0v
	H2M66t/n7jYdBBqpT4dGRGAqr8YWHe4=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352ec74a925so2554704a91.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721939; x=1770326739; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iXsfpp7fYjSPi1nIw2ScrDnrjqTlWGi7ZArDWIRjDgk=;
        b=ac2ih3ouTt3BUGa9qBxwZKPNdOPgbycuceN6egSHCS5FiQOFheRjyMyZS55DEKcySj
         U5tFMeZe+NJNaMV8g4iN+Uol9qe5Ztg6rAGIgwofDkpzcFinE63W7FYkMv1Yb0MFt07m
         nyHYW12VEYZGckAwnK/g3M/ioA15FiqGRs3k1LZxpKK4A1ccYgBOwoEkvBei03Yntd+m
         XrvlxsTq1UfLjFdZSkonHGFUMUz2TjC3m6ebLlLt4aM9piMIOtFBRxvdcM7PCa5bYAF1
         rlaHL7XejnjWK1wM/aS7GIKWcmBiKXnUztdGOHTQgPcEtvMDJXAJlFQBem+JxTzfabpA
         Wl5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721939; x=1770326739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXsfpp7fYjSPi1nIw2ScrDnrjqTlWGi7ZArDWIRjDgk=;
        b=jBG8dNN3SiaAa9IG9eqzvihn3kLeYB2NA2coy5XO9MkIwzjsJBVwC9R9FDEEkn0QSV
         aPZUhVWCV3KB1Pn8qrQA5iOkIcoig754ANXU3dGf+JQg/eXbYkR++tTL+W60/J/5h4/5
         3x8UP8vnyorybaZRNCpPzmgygj0msLXJwCxnE3ilfpTqMbHeBEZtIKrnOkBpfeTyrBBy
         y4fDvSFVnbGqofbGgIpk8EVLcuyhPA0X/DH5Nw45hR2zImXNJfhVYVhpfcLOOrW5QM+a
         2Xc5ox5Z82+aMW3KefVBLu3KTK2L/jAUH5RsQMrjv6Gn2+e2oZw5skhMXDOQb/cNSaDm
         Yfxw==
X-Forwarded-Encrypted: i=1; AJvYcCX/Dvh2621u82n6q/Sd8YBRdC2Ls0F7DfDsgxhd0dYPmv2eMweBeEKuVJ9YPjuh9zMIMW7KIrmH0Q==@kvack.org
X-Gm-Message-State: AOJu0YwQkFCwrzOD5d0f6y2WNGmMQ2yQTxpcfzIJSKvHriMcYwqUrsJR
	96iyxmnUQwifzdAnF1mMyzIwsAAlyju+T3S7rEaTZ2xDsGtj5BNgbpuGmLrRvUvR6XYhYDHE5A1
	USVVcgaQBQfFobA==
X-Received: from pjyu17.prod.google.com ([2002:a17:90a:e011:b0:353:454:939c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:17c9:b0:353:356c:6840 with SMTP id 98e67ed59e1d1-3543b31688fmr768863a91.14.1769721939368;
 Thu, 29 Jan 2026 13:25:39 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:48 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-2-dmatlack@google.com>
Subject: [PATCH v2 01/22] liveupdate: Export symbols needed by modules
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9D0F516000D
X-Stat-Signature: mrbxinn7o9xe4hzpz8dshga1xznz81bi
X-Rspam-User: 
X-HE-Tag: 1769721940-373318
X-HE-Meta: U2FsdGVkX19woVlsGbdNjoGz3GrRuzned8H/RqxFpbKpka4fuPxrJ+zGn0ZnTOhJsKsEZQrQcNgrZsk8TFFY7J95nrFu4RyXLG1w4Ro0/4U12WBSyOQ9WhnzUFanj0E6LGxu5/GK1t6TKw8webypPiSBJ0YqIFrtjoCtkI8/oTHASVHXzEAttBpWLS3fJwZGo1LDFFSEPCUMNYxuBQSlAes9invrpHjmk7zrrNrDRlqEvUlbnCvUlG74w1tTsWrL+RLmZL2eKYXGgQHlGs5kg7uZ3bNCQ3n5vb7ZqSFzwqXOSWH5rP5Kd4A0bwvppfnffZ1jGCz85x78RGAoimEwiZSiHwqHAQlNs6Yb5fBgYdpt5g9STF6JeB6Kic9V2BrZICqXMrUMLyg5AkpNkbli9W6A8wu+8KoBNo2ES3cFmdQcceHgFeGwp9tbO/PudvWnP3gafy58xUUMqjKKaaxyxMlaHoHppTzt+YvT/8OIi/9cZzvlM3SsjFqn1qDaXNKWKlFJSnpxXCmsqI8ChjxE0NMqI+Vj0ZF3TeDY5F+SO5UTbBU+Wsnh9MF3qnCiIGZWWbgZlWqWtY9ksk6ner1M4fvE71Hc4KonFtirpuGHo+MCBhGoEQki/t6UKpp6Ers5uABZRC0cXzns1s2I5b2Fc1NfoDh1Veq1PhXUmtqaZwBNGI6DyT8VVBQcirmGV6XQbIyq5oK4Yix9ElN/FuGHNULiDbakNQM14nSTL0qKMKUpd4J632K9P9+hBZOGJimZluBFXT6oCCMVOZSIfFWEJJS2qS6UVaBJwYhoPd+m+ZrJbYGLntBgz66OPXsmfv889z3OuCYfqyvmwXNaut9StNXj0ivgDzqKerPQFroF2tTFJd/14Kq223m/pQe6teWBvLdbFw2kgxRYeWNT7YKUeVCHEOP1xAU/FI+rw4m6zK+BzKklBEj39+Z96V09v5gh5C+Hs+XlaHueQpMB6PI
 Wp+6zKLi
 yPVwfwuFPgmLWbjZL3Ca1rJoSQqDQ9SRtLtICQjsU8edQNigLnKiuSCsXM4Nk9YsCX+sJtHMpf+DHwkk9CdBhY073ZNcja4cowXw0qgCZ6Xts4VaJkbrZH6D6YVLOvapkhwa49KiXUri0IXy5B+r+YHxSpj3ct1Y4dYKLjA28vfvQ8ZOhjAbxrm/fZLOvMypVOZP2f2oa+29TgE2lgLSmjBruHFumS+isMR5fj9FO8QMe0OleIPjzHrtq7uqEdmsHm0zIxDTL5xbb68USHFPHmZ2LFy6kOi9RBuQ8KOLUxCEgkaIOF6BZsBLZkk5NVVj63IslITIcNQMEXE3fiLHo6t4pcK+XzKSSa2MhlGRoKpASFgGBi8vTdBRDCd6kUWwM9gSzkoAs3dlYYxoTD8AhSebOxuQO7BVZendqWE5HfPXtZNu1DdqNKOgB9zLkEZEk5ZyAsItsaZ5YYZzTzbT336YpiKdmBDMASp7ydt0hIhUsJ2FOJ7cJAu9BGxl5cQWXA8Y4VPdsmxGBKcM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Export liveupdate_enabled(), liveupdate_register_file_handler(), and
liveupdate_unregister_file_handler(). All of these will be used by
vfio-pci in a subsequent commit, which can be built as a module.

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
index 35d2a8b1a0df..32759e846bc9 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -872,6 +872,7 @@ int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 	luo_session_resume();
 	return err;
 }
+EXPORT_SYMBOL_GPL(liveupdate_register_file_handler);
 
 /**
  * liveupdate_unregister_file_handler - Unregister a liveupdate file handler
@@ -917,3 +918,4 @@ int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh)
 	liveupdate_test_register(fh);
 	return err;
 }
+EXPORT_SYMBOL_GPL(liveupdate_unregister_file_handler);
-- 
2.53.0.rc1.225.gd81095ad13-goog


