Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10653CD8C8E
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 15:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380446B008C; Sun,  7 Jun 2026 11:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331866B0092; Sun,  7 Jun 2026 11:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220576B0093; Sun,  7 Jun 2026 11:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 110F96B008C
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 11:28:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0A671C2048
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 15:28:49 +0000 (UTC)
X-FDA: 84853499178.11.4E9561F
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE1FE140004
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 15:28:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=COBv1Quv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780846127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Nmhbip3VP8uizzhEAR9YT+vvnoLjIUddI9JAhC6TpU=;
	b=o7h/Ppfml6s2mxizOdzA1K4rOYF8tHoqvRk86znQaQ4qRxUlJATLnQi6VBSiUCYWLgsn1w
	k+QZ3u5KSmCUxcbVuCAWBwn3nIv1vOAO0LU6pTvEQzEdOZqqJIsYtEYRFNt7MKqIA4Iof1
	dWmZJ1+xNXs2Zp/Z6+LqRE371t51ip8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=COBv1Quv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780846127;
	b=P5KVJNX1DuzIVcTQJe8S8ptb5tEzWNnDp7bSpfLbfKKHGqJSeubnPkayI5tWK/twjtcTiE
	GN30QIcDih1Xera0EbrGa0RxZN9IyPEIR4tsqh0knywqkB61VSV5VsH9aERdHN/o5Yne3w
	NtDN22v5m048sh+ZfIpkHih37GBSSU0=
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36d5fd50d20so2221120a91.1
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 08:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780846127; x=1781450927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Nmhbip3VP8uizzhEAR9YT+vvnoLjIUddI9JAhC6TpU=;
        b=COBv1Quv3SqXDLtnvy04dNP4SG5cqtF0kBMG9b/KthV2SftmjBlXF4Z3IjjtKQpyEc
         w37Wuy4lL4KbWzIl7dRU/Y1C7j3Ob7fymvJInusbxdULL6ZfdE7hL48bm+OM1ege/+df
         i/iTQdk87qCAunloNh00/oj+LdRKvQpbVbN0USBPUuLXLz+POCwWN680SP5YbxRrsIoI
         reIDrGi0P6BCldoDqeIRhOsAd41Z7aKrtbxFd1EvBbAzhrqSRPcQlkW2tJcBNS87phpy
         xE3updoaUxiUKda8K/QJ6r5MzoIRHDSRtd8p7J/W/bz/qRMvNn/4CEXP9+3VBzJaX8o6
         2e7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780846127; x=1781450927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Nmhbip3VP8uizzhEAR9YT+vvnoLjIUddI9JAhC6TpU=;
        b=pBtvwbmaCuheLTCY396yqkDussRHsbv2O8H3xWcGLWfkcOXlFnE/mcXGfzeKVfbehj
         7NVfyVIFh5HM44XLh7Sc+lu/YX8BrflpsegDU+/fbQtsDvqNCYz2ILNAzpWN2/R+BpZd
         alAr9qAHQIEZ7Vc+bJwXAw04223/TfxMn21PTe2UbGbeT7turytaLLr2RraRBAXHaQsd
         Zmas4WNZBxYlg2TQ39NaTOUmPaQJXSDmo5aPY7pSSslVMjTiItaG/UPayon5reYvR+Xs
         Mmj/XisivX2oksjDDaS0MgLuM2HXfgLxpAK4fD9c6xMtuvzf9ZN8kVD047bDC9hFWHIV
         Mwew==
X-Forwarded-Encrypted: i=1; AFNElJ/yBnImxlx6ZA9OnKQ7ydZLZzyXBztSU1kZNJMO2iPDc8zeZByVwd5zySLKvDuzlgFTJrKcvDLEjQ==@kvack.org
X-Gm-Message-State: AOJu0Yywmg6w4QgOxSyXMZLOF/Yb00J1EGeUEpuinAj+04oCy6qdrmrz
	KIDDwVDt6TnFTy2JiMr2i1dBJ8HTZu3+OuwdmnAFGe6FCFT91JzGW8cH
X-Gm-Gg: Acq92OHcLSrwWyKLF0FE0XqDxzzneOSfFxbFViJ5rdotf9XuT/9sVy+tr8csKJBfAa4
	TrMajXocU7GOPcL8PjbPabFxX3PJj/N1RzffEjlVsz54c4uZXEV2vQ0qA1xLBHZYOx/IPv+dRJO
	Ms4G+aB3gun2ZpnbFqR8pC/Jmwdf3AxNKdIpFVixKpfFlCpb9VRDrg3XV0zQ/ee5AIsxvLfHJw3
	gXcWQKq82r+VCy990D81Y+I3XDPtq0zZPaZTTSeGTMA2RR9VyzXRNKGPE6LdG28ccCtDXjjuDFD
	nkeOlBD5pH9CWnQbwU/1JFfQ4FqarMXAcT5dN2K32CScCLTVn0SbZgPJonCAvwu1WN04dRIRxgC
	qNpJoRf7qORTlA27ogp5/ARe8wJ1o9ATOgWajm4a5r7dcnIKjBhmg3Mm5xpWZx0Y8ejJEOSn+w0
	pHu5s6TOLECpsrJMjyVtYb0aSiXVqvVyUeRqe4i6BPkrdOyJ4WnsFaRs1rr4GmOOmo/g==
X-Received: by 2002:a17:90b:380e:b0:36d:ae6a:22f0 with SMTP id 98e67ed59e1d1-370f0a5fde1mr12621612a91.14.1780846126591;
        Sun, 07 Jun 2026 08:28:46 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([116.72.144.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6bf82841sm15604680a91.2.2026.06.07.08.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 08:28:46 -0700 (PDT)
From: "shaikh.kamal" <shaikhkamal2012@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	"shaikh.kamal" <shaikhkamal2012@gmail.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] mm/mmu_notifier: Fix build on !CONFIG_MMU_NOTIFIER
Date: Sun,  7 Jun 2026 20:58:30 +0530
Message-ID: <20260607152830.8775-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <202605031109.uxckW5L3-lkp@intel.com>
References: <202605031109.uxckW5L3-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE1FE140004
X-Stat-Signature: x17yixnn1i84eotsuyr4wodngwafn1rf
X-HE-Tag: 1780846127-958788
X-HE-Meta: U2FsdGVkX19w8r3BMBJMMwZ0v6N0j6ppTQ56EyOtoO7PzBVu5HQWqI+hSiXccFSSEr4vua+KpWuzMuXGmiusGRhLNXzmbNZpHpA6XfBaYQ+V183cdZDlpSP/FqlkCxtFxPyk6Qpq+FpKNbsYctJWESkTxRMxTXNLWxPyzL8KGmX1F1ClqBmmEue1S5lx2BolBx7usURtHkYNqcydw3PGTtt5idyUatHZt8vvrpFFEEq7MYfRyTbrgLK+xFwG8hYanTSrX9bzuV7uToccyccA8hYYsczFXDyonaMJdIferhp8mRdiJiKYFfp2lYSrrmNq7hbWslTc2xj97QTZ8lBYQ92fx83NNgcB/424NfYnPjB7HmnnbKMaWpeqxVhohQE91NGiSbPlR+z8K8i7k6wNn/3S5tK6WglfPfjE9Gx6vuTWBNOHY0zxu48cA+Jln2QhHtN9hBe++wssA3QVViNRDqL2pGQm5srCj1viIi3o5MjneZ6Nz6QPCh7RdiLSe9BBkZSFcIgXL1YABF22SW1KVRKuRZt7qTcsaQ0K3n+F+/Xk4uy0Vb8/+tBHqT110o62jYfch/2/I58rmTuwt0Rkzab377cISHWzTv6rcFDaD0aXJQRfMHn1LsLPAEqVxMrakx1oHtSdUfIQODP4Dyg5jcaQvoZFYhV3aAKl9vAT/xetI3JFLN+yxARJezs+omUlfPftrC3erEGk5t7MSfivjPD1ItoBpA45aq1JKwQEeUjXIpeda9sFhk1iYBa3ux+256oG+p72hiWh2VJUNoHVb/qNbs9DBezOzHi/DR34qxCatqxoIJOI3lEGCnq5FnED6YsjV7OS7ZqliS2qAb6HzsXmiUL5J5GI3ZPx8eBsbq03Pr6lm+49GkZNeFntm8L5DkKYY24cK1wbQO8khuoeX3xt8FmccPxmEw0ZrR7NNto7aHCIvJtATpE9c8fdD+1f1xHfywzvNLbnMQpvk0x
 JvoimkJZ
 jWD5I61Uq2R6KMM57UFxJyDltjRHNuRGG/57Q+FZdC9sgpOKGeDh+AxNPloehKLQrr3JfR79s3wOnuNEWK2kY7oBrZM1+HHp3GppvMj0BUmr5BTrSPJqkj1B5gX4h1n6RlUeQeCitc6C2mbb15+yByrnL51Ph4jqZmBRjSwFypF1+dGK1BqIqDt8IqKHPlXcG+XWfqo8Byh4OaP00hBLFW9/SesO12njV0jXBmOG5QfyKx8otB3FOpiSt5eqcM51jRIe/tEOCfdzzvg2MgsHxS4c2HdfrTlob0OqfqbZ4fxlXw642hsfm09prVbQSeUEGoQE1vjoZ5du7SVowfHZnVnFDARGojz6tHkPUZZDUvakFc2N650k0cQeGLXAZVgz+dgzeFgY4DSpKBLvkbr033ipb2vKD+eINByZHlvmyC2GjbCl4B3xktv16ICbtYCUyAqKLWwakUeqsKObMmdqvQzxeQKqT3YlZ5TnoR0sUwvfr2qCeKqUytuX2VXz6kzO4dLGVcO9kjt8wcIiO5xfD5TWmSj+C3lfmRvNvKHFm8rHFXedua6qRrMWNl8GpmoA3g81GzHhaBQhfZYWfDks7+za9RKHXmJzuCjQddCIVh9gS9CE53sYUSaeuojrXPv9W14bN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add missing static inline stub for mmu_notifier_oom_enter() in
the !CONFIG_MMU_NOTIFIER section of include/linux/mmu_notifier.h.

Without this stub, allnoconfig builds fail with:
  mm/oom_kill.c:523: error: implicit declaration of function
  'mmu_notifier_oom_enter'

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605031109.uxckW5L3-lkp@intel.com/

Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>
---
 include/linux/mmu_notifier.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 0ccd590f55d3..ad1a5e311ab7 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -670,6 +670,10 @@ static inline void mmu_notifier_synchronize(void)
 {
 }
 
+static inline void mmu_notifier_oom_enter(struct mm_struct *mm)
+{
+}
+
 #endif /* CONFIG_MMU_NOTIFIER */
 
 #endif /* _LINUX_MMU_NOTIFIER_H */
-- 
2.43.0


