Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FBBBCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63B58E0036; Mon, 18 Aug 2025 08:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A13CE8E0003; Mon, 18 Aug 2025 08:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902FD8E0036; Mon, 18 Aug 2025 08:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2238E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:27:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80BEA5BB70
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:27:51 +0000 (UTC)
X-FDA: 83789804742.02.A1F7375
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 08E6910000D
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:27:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OU64BbyI;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755520068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwneGKQ4sfoe7BKC8gdXxzrgKAJX+5iJGTZjGrJF3aY=;
	b=lrIGcqu5wZUVFvqSDNnO50nZs+/6dtvpyAZ0xYI449oIT+VKP8R+qHueGu+bJBWX2cuHZp
	nEGyKfWZ0wayj2OQIB9Dfnm1pRoBMel4v6ZBxM+De2eEW/j/Ovh2rCFop8Frti3t+z1k+F
	2DF9ROVR+SbxwtrAXxy4ldsqHFNF/Zs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755520068; a=rsa-sha256;
	cv=none;
	b=EMI9r/gfaPuXvhA+Ok1buGZMTrOrUHjUL30+4ICv/C2Q7pednHH0hRRhYzKySCWDi2OOP3
	Pxh2C4QfNkcpf3mz152POBEuDaURWJKDO6pi4frgdrHLRAgXzArFyufGtKL6FOkDe9Qd2d
	NCmvO617fFmURqfunTGD0pt519Q9w0o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OU64BbyI;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2449788923eso2167375ad.2
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 05:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755520067; x=1756124867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwneGKQ4sfoe7BKC8gdXxzrgKAJX+5iJGTZjGrJF3aY=;
        b=OU64BbyIQuR7WSju4eIu2v9bxGqHkZGPc7QaXTfNLyUnpUrewdpCiC16mCpiH55l2/
         ct+15bwA9MzlwoY1b8jShMwr/OH+woaJjNUYjmhB8lnCJyQkZ64ScqRbsfy0OEnVwpBK
         +kYezcqxX/9d6PtzRNpWn7tV0HswaaOlfqrO4wsUDPiDkkiYhUANIbNcb1eBPunAA5dp
         rE0i+nEWpk0O4hIkflx3zzY1oUL9Z6Dp4tHvCw6M3sIyjB65AvEI8ZkL0uAsJko4n0Az
         p6Ffka/1eynIjfCooyqbin+xmOlY4eMbHHb0cR3mEP1OknEo6/opo7sFnV0MUcPZ7hcz
         1p1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755520067; x=1756124867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cwneGKQ4sfoe7BKC8gdXxzrgKAJX+5iJGTZjGrJF3aY=;
        b=LIddzkLbBnLtqHBrcCh6U0EXtlgB4E6mRhuPVV5T/2GdYYLJ06oAIzstVIZIYDZ1l4
         1VOvSJA9Ara39iPHKTIOTB89+5JnBZKCfLTC64nZ+YuBhqND05n2u4+BjKFNi9p4NNrT
         QiRmarbouf5E73jNl+km8pnkglcw56sJLEkSjSu+kUkohailsk+oYUaRuxG/uqVd1+cI
         L7TP9QVC5UBq+bUsCQuNjycXxuf/W/DAd/tDPHCPyRXByDmDkdyZelpEnxxoiNJer8/l
         +NkCLuaAT+IPpBSuYFxVxYXLXj8zxhwNFvHyXQuUj13Rrj6V+My4cNPif3hwqzWexozO
         93ug==
X-Forwarded-Encrypted: i=1; AJvYcCX1spVLyu5WkjmwB5nV8gyEzzOIrpfQwe0KT3k2fE/KxKa0tTiP3sMbiKgkYhe11yfkU5zevfEd0w==@kvack.org
X-Gm-Message-State: AOJu0YyldD4hCIp8GGOFf/IDHbGb+pIid7thnnpUR0IMMMP8RWCNHv0v
	DEI111/Vth5UGKAJwhgoqZYxU+ScZHvL4h5gTMeMv2dxLPZ7lKh8eu5g
X-Gm-Gg: ASbGnct7TUcVuy0BzTrRTQ82ldDwx0nQKzZpUKEPn3k5W7VyW78fhQL1uEWptoSadsf
	65zs177UQeDB/yZe9NIpXC9H8RX8JbeonYQDMVMTEuxuS8Q+JvUB3U4UvRlLZGCOUyfmEcncSyW
	9dWbFZlqasG6fPIwLCCB4kZQmAGUfgjrrblI5IuL3nhif7tpsQiBH6nIKCnIgLL6gqqjDQ7P3Fn
	D13RPKzhGQee+jugxVTO7rH5GPIK5UVQ9EeyKzJazhps0Qcqosx1CWDOg8XjdVShw1HOiwpUqk9
	wbACOmsRh8JilZHX5wGD3wd0SFuke0rSCgYpO7/oiBJ0EhvJbjTk6rh1q3rCwN73Uvf1xaQmtW/
	4c/RmCwEevmv6ZL2nODObii2mHZl0rcBOvoVV7gXJk4S/
X-Google-Smtp-Source: AGHT+IGTAUGEwOZ5QaDSUG+R4n2NIvHL+mwgpzRGpuDYJ00xK6zUpiTVfF5BJr74uTjMSx7tqRF/ug==
X-Received: by 2002:a17:903:2f82:b0:244:6c39:3383 with SMTP id d9443c01a7336-2446d709449mr143591315ad.21.1755520066653;
        Mon, 18 Aug 2025 05:27:46 -0700 (PDT)
Received: from localhost.localdomain ([2604:a840:3::3008])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d57f12esm79236705ad.157.2025.08.18.05.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 05:27:46 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: akpm@linux-foundation.org
Cc: mhiramat@kernel.org,
	naveen@kernel.org,
	davem@davemloft.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 01/13] mm: Add kstackwatch build infrastructure
Date: Mon, 18 Aug 2025 20:26:06 +0800
Message-ID: <20250818122720.434981-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818122720.434981-1-wangjinchao600@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 08E6910000D
X-Stat-Signature: hzcrkqnkprzmbyidg58uwp4f85ejuyng
X-HE-Tag: 1755520067-504586
X-HE-Meta: U2FsdGVkX18khIo5RJ+CUKPxw3Xd1PWb2NU5NpEPqPYoWyATRRkcPUsu0dkGR7jE1ZAGefKEjicH2OMTSE0sXefPEJgCAGVJJJF5WtgOnGLZaheTzbWe7WGJcIVj3QN5QYTH1sXc6hrqrUsGMczg243dGgFDm3p/V95q8WIG/a+XjsRTiOuAXFgJvbEc8G9fr9AjDZfzT8zXKY5rT/JTu1qJOcFW4gAVQmvTd8Nk85Gdxc7JT+f8H6us3wlJTAUOVdGUxaCiNzEpokxVZbFdtdyEiVuggAfCWXjWGupksL/gNZQqgohopZmWG4PPuQuOwDx9D8TJslyslqy+N3z2K293RFgrlDAVC9CdJAaz1bYDX8ic2hJQqlUvJGxqN60SccRyMK+8ARwBFQu/T0CnyhDAPAaFSKtIIFT+hCdt+ny3YdSURYF4hOzHtfopiEjlFaw1BKX/J2ef0gbN1fDIKaakLHbVINKWxt1FsEqH4DQv8TF+fxbwau/uCEYJf3JfdTtZmTQ4W3PpAPmQ+ZK3bbthwMUQxt++Szh/FF6vm8BVXfFV5DwtnKLCYDJx+7SOh9FzCCRiq4qZXbRZTq4NkVJHWwvaYUAD2kbOaOYG7+dC5/GHImCwdr/yxYWX6WV68hRu3fVIP1ZWP5F58ePcivZAS4wX4l0dJhDK2cnpgCmvdqFeAJ53fUcf+vqcrizmoymN0RjYEMR+dytiSRFRiaGjC/sM7OhCzGTyx5D1/0hjC9LNXStl2ZMSKobSjRIePL/lD6SpXUa4vIrYpznjCqWlozdAMsl2f13I8DonYQhaWNnQwK34g1d4c4gJDx7bzQl4/x5CYJe1Nf3NssYJHfXqgVpFMLVmeu+cbq10CPcUoIy6xYPJLOr87OK2t3NbQaIpyPCaGzILxEy69ja0zqgwhvlh0vYhge52K/oQ8Xro5n3IQ77RczzDNijYFNZE1cU5a4E5xLxX4yIfwQC
 a25O+Bw/
 pfRXpsKnHhNjPe6f5HpaU8VBmD5E38pkgvb29YoiSbT1FTninlP2NPic4x35T/g9Y/Mn9663Cpc/ucMHFDprO+F1t9zmKtJy2FOtp7Ul96tr1u2gmeK9K3GPyjKxDNPMMtSy3tnBCrGkJOBoPwbHxSBMLXXgUfN8wSzToNTPtQUpERTHiSf8/F/zcAEwVUQOzZ5CA7OWjap7Xmk0GypVUIfrPkP+rwUuMeyLuWaB1kfJk3XQylTIKAj56VFRADoY7C7dZ9BZ0XL8i27Ami5zF9yK4+w+ttVH/U4hvh/w4V+gi8PCJOT7kzXhZwvr/XqWHUHuvDrHW0xA3QAxir3mCoWwmG5iU5LdNQ93DxEIoBfkEYlEtoIzUqXxnF+F0dGgoskhQ/HEV0fMlOzWv0Orlsa3aMRtplG8MXBqMAbhv0gxu3uPDpxNeN/u9PklgZO2Bwnen01fdzmRV6V6OmLbRA8NHo+cG9YW5mo59
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the build system for kstackwatch, a new kernel stack
corruption debugging tool. This patch adds the necessary Kconfig
and Makefile infrastructure to support the kstackwatch subsystem.

kstackwatch uses hardware write breakpoints to detect stack
corruption in real-time, providing precise identification of
the instruction that overwrites stack canaries or local variables.
This is a significant improvement over traditional stack protection
mechanisms that only detect corruption at function exit.

The implementation is placed in mm/kstackwatch/ alongside other
memory debugging tools like KASAN, KFENCE, and KMSAN. The tool
requires STACKPROTECTOR, hardware breakpoint support, and kprobes
functionality to operate.

The modular design splits functionality across:
- kernel.c: Main logic and module lifecycle
- stack.c: Stack canary detection and probing
- watch.c: Hardware breakpoint management

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/Kconfig.debug             | 12 ++++++++++++
 mm/Makefile                  |  1 +
 mm/kstackwatch/Makefile      |  3 +++
 mm/kstackwatch/kernel.c      |  0
 mm/kstackwatch/kstackwatch.h |  0
 mm/kstackwatch/stack.c       |  0
 mm/kstackwatch/watch.c       |  0
 7 files changed, 16 insertions(+)
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 32b65073d0cc..dd9c1bb7f549 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -309,3 +309,15 @@ config PER_VMA_LOCK_STATS
 	  overhead in the page fault path.
 
 	  If in doubt, say N.
+
+
+config KSTACK_WATCH
+	tristate "Kernel Stack Watch"
+	depends on STACKPROTECTOR && HAVE_HW_BREAKPOINT && KPROBES && HAVE_KRETPROBES
+	help
+	  This debugging tool monitors kernel stack usage. When enabled,
+	  it can detect potential stack corruption by watching the remaining
+	  stack space. This provides real-time warnings before a crash occurs,
+	  which is useful for debugging stability issues.
+
+	  If unsure, say N.
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..665c9f2bf987 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_PAGE_POISONING) += page_poison.o
 obj-$(CONFIG_KASAN)	+= kasan/
 obj-$(CONFIG_KFENCE) += kfence/
 obj-$(CONFIG_KMSAN)	+= kmsan/
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch/
 obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_FAIL_PAGE_ALLOC) += fail_page_alloc.o
 obj-$(CONFIG_MEMTEST)		+= memtest.o
diff --git a/mm/kstackwatch/Makefile b/mm/kstackwatch/Makefile
new file mode 100644
index 000000000000..076822eb7661
--- /dev/null
+++ b/mm/kstackwatch/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_KSTACK_WATCH)	+= kstackwatch.o
+
+kstackwatch-y := kernel.o stack.o watch.o
diff --git a/mm/kstackwatch/kernel.c b/mm/kstackwatch/kernel.c
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
new file mode 100644
index 000000000000..e69de29bb2d1
-- 
2.43.0


