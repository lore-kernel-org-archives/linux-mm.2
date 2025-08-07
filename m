Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A234C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 03:00:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160A88E0002; Wed,  6 Aug 2025 23:00:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1380F8E0001; Wed,  6 Aug 2025 23:00:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04DB58E0002; Wed,  6 Aug 2025 23:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5CAE8E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:00:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98D5B5A89A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:00:20 +0000 (UTC)
X-FDA: 83748457800.17.D85D74B
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8C7114000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:00:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LtG9z2Ig;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754535619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3ob6AtmQmism0IsXi5kyAQfn9jSVsfY+ZMouUkLtfQ=;
	b=YAcu/8XW4w902c/QSJey4UFPxZydEGW81kH6yW0uOIpU8UJ9O3O2AaxE1XN/k0LVfsxH3G
	zB4nwVJ1MCPWn0kfula7mjbVHyM62Gx/Mpf2Oov4FdoULnMbR96+reiY1wHuFbJDQDOsog
	IGL5dr77HXCmQ1TYJK26gGTCSy1DGhY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LtG9z2Ig;
	spf=pass (imf23.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754535619; a=rsa-sha256;
	cv=none;
	b=TXnWGQBVJ0/o6Lep3eQcwgcQ1ocs4aQLPmY+04S+DBrE+3IQlj5AzzagDLBzc5+8UIiQlT
	wm/+32nFDTNGnk1GTNp1UxotYASyljkXfFyXCtEccT50XNChmcTN1FquPfXHkCj5QO6bA7
	Ww/KGGVIBc2v2+4lcTYNQyuVAFJU94k=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-31ec95ad016so509580a91.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 20:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754535618; x=1755140418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k3ob6AtmQmism0IsXi5kyAQfn9jSVsfY+ZMouUkLtfQ=;
        b=LtG9z2Igh6C8HI0UaXlTm7zwIdmGsBVCZPYrXsMdV0q1YGCwQ2SKw05xRBWGf92m8D
         Cyv0Xn6TG4ORN6m0N+8rsfduUWA6qR4X7LsTQX1yY/EKwaC50eP4vFmbdFJqKdW6Futo
         /ZY3saEzKR4UDqJcuUa+tmgVmQ06rzQvwX6TiiMlQRBipsXVE8uhidOrteujTcd56uZz
         kMB6R0J05a8HdRRfVnltzCFEWZXAZURPvMJIdYu74VmrvJPblqRHAAsky9kGOM+nj2r5
         nJfPhl8/QDYKRFCM8pC7FYxEqJdyuF27K7rbTd4q+98auamZWHSylOOmYq7NwFrY07vH
         SXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754535618; x=1755140418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k3ob6AtmQmism0IsXi5kyAQfn9jSVsfY+ZMouUkLtfQ=;
        b=I3FGY2L1b/2/MVN3Z8Tn08qDT2RanqQh/aJgnI2BJHTcSeUhHQ48kcJhtThLKbLNZA
         m0309CS3RispjS1cORvyJ4UXpWjNDMqQ0QnnNiSD/plxd7b6TooAyFzPYSbpa1AHvKIv
         Z9EEol+Lio29pCyH8pBJlHTAOvAcOLj5YQ60BInXAt4gEu1+pt+HECucoe0JJYZZu0et
         WOZOcJwGoBX9klkADiQaXL4+6g1wcqiSYstwG52yyMpyTwiXKe9ZnotZkRW1D/U+HXq4
         DfirUcbXHw9haf8lyQzyKEcFwdvuBLGYYQujR32SnkCIz43cdcVGKkvjBdFsga0ZXJjO
         LSnw==
X-Forwarded-Encrypted: i=1; AJvYcCWkGHyrnv0BEFYfm5fxIEtVwqdmRKChNLpMg+Xadg3LSAwqeJON0jIHWGA+M9oef/ooNcWfiX3veA==@kvack.org
X-Gm-Message-State: AOJu0YzZe7SphmbQR/sxpr1NqRYg+sZkiRViMRyhhghUuXm7Vrdi33sz
	AbkgBTIftYvVXUHwNUxACAOgYi7EyNVcN+/nHh8lmeusFGI5L+SVPGCm
X-Gm-Gg: ASbGncsZGZr8vYdQqF+72+XW+G9srrKTnLYHQDT45PKOZ2ZQzBV+nf2iKkiHmSeNdMR
	/v9cVLBJIbgFgTFbUBZtnLfXBwAc4ky9+vbjktyEYQqM5VUZU7xtMAVQrBLhryKmhwVUJPLwfLG
	dLEMUWm/JlspklWN3eep6ANyGYAW0AdZBMYXSeIQ+1qjyM0UVybAXMj+ZJZEeeu0Pby8tN9xOJ3
	83Wv8jlQIkExxl7k9hP05I8NfoVXD0aBGb5WTBya6yVygBgWnLcIzOS9mqx6FGKG9+zYhBL/aE+
	jnivMNRCX91D+xYn68SJg+KMaEdpmf3N2dEwFu3jOWbBLhUalvvemAuHqO4HokqeUFtP5oR5Uq/
	kH+TxgWLHP7NeBoDxUpZV+4khUrxWGp7NOeOfM9hLVXnv7YcH8UZYGxOv
X-Google-Smtp-Source: AGHT+IGMTLZn86RSz9+7SPg6P2DUvVV5GzT2KGNr+O4lPPUaJRWr72Uejisfcsm6HAFjyl0/A7ORGA==
X-Received: by 2002:a17:90b:4ac1:b0:31e:cb27:9de4 with SMTP id 98e67ed59e1d1-32166cb2fb2mr6982196a91.24.1754535617508;
        Wed, 06 Aug 2025 20:00:17 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:21f8:86c:614d:c5fd:9908:c9d9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b424ca987desm9771651a12.40.2025.08.06.20.00.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 06 Aug 2025 20:00:16 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	npache@redhat.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	wang lian <lianux.mm@gmail.com>
Subject: RE:[PATCH 3/4] selftests/mm: add check_folio_orders() helper.
Date: Thu,  7 Aug 2025 11:00:00 +0800
Message-Id: <20250807030000.33303-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250806022045.342824-4-ziy@nvidia.com>
References: <20250806022045.342824-4-ziy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9rhbcgrq7qwaogr5zhutbky51utta8io
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8C7114000D
X-Rspam-User: 
X-HE-Tag: 1754535618-387177
X-HE-Meta: U2FsdGVkX1+OR8Q1mA0GyR7I3KqKo+jZrcoWT3vLFnwtB3+ljDIVEJ3ZV191XFdQnO5XytQmV/fn1Fzq9sxJkOG4ZVWGjL6IMR7KHeFO9xIdzUdlfHK7gxPMItYDu+LLpgglpLymAGt1r5VG/pB6hTtksTwSH/HWvpLphDo4jDt5VIN0bNA2SixXn0XH+7wUzRJdXkCAwb48VBG+uRzW6W8lJ8JMY93SDTll9uIlWrkks3i2fNU7HZu5ypgHCQHtW+lh3WaRcfWis7tdTsEZNU7c5OV9VR2xoZ1nUCMhzL5Knr5v6e6ukw1xVmG/1CkI0GHq4LYU/YnWA+TGcMGQirYwhDI4HS6W+cK3X75CcFzoF+RMX/HFfvtgyhz4CB4GdmXRP87v0/T1YZqnhmlZ1xLjgrfKJy/ekBZ8ej0rKsnroYdOg+JR5b4DKvKQMIKtKicKLeLHPIyDnyLPqrzQ90RZOaTX38gBTRXxm+RiH6vnKKZFIfIj9nrtz6f8Q1hbciE9hzKG68/Jh9UCqjk4evau751fKB2tP5cY2jB/OUuTnnPYDPx473CWf1SIPDfdLJ4qLF3OHCgu9JTp3DIhl3N77a1Ubt3eIprkr6zVvkonT61YTKqBRx8QcqQJFTu/sogFfjihGyOYzIstpasweXpFPjJy5GR21PwvJcEGApgr5xXjToojL3F0OcQt7Om4MMsky3ajJOK2wECsq890EMG0aApybA9F/ABC9fslXd2Q9ekkRHmuWF43c3K9+tx90wfmd4jbaJy+PRFXYgf7Fa2lWItBndUeEl/xH16hd6VQN4+3w1D2CfcOs2nzL8x6twvwtXXztGbID5dngS/4cv6/otidnlQxTIQ+xzXboMorn+NLHTeA6GqqTxn4h/1ZQ2pMe37SCrzEW+Ccgwf97Yisz9Qq0yf+AMLNe+DEclcrmzSXejMAVSkHelzEfE3TeyoZ2exGAjH/bzxzurS
 xFGLm8vA
 umhfTrqvCAU8eLhfe/p8h9m9MCBnB0BS83yksJ3ORBadWS2s8cHmFR1+9Y1+UyV9PgQV40zyeBObCoQaP9iljnE751GAdJIcPbTFAd2oE3s1dLu1o85mzX137RmSfKLbC0Af4HsRb7JKaldgK0B72F6ujyzqX12kkf++rNguIAuRkK4hFjXaWTyDGjXhABZ+k5TR3oR+6oIrEY44pR9KwSPGL7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

Thanks for the patch.

I have a nit suggestion to centralize some of the macro definitions
for better consistency and reusability.

On [Date of patch], Zi Yan wrote:
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> ...
> +#define PGMAP_PRESENT		(1UL << 63)
> +#define KPF_COMPOUND_HEAD	(1UL << 15)
> +#define KPF_COMPOUND_TAIL	(1UL << 16)
> +#define KPF_THP			(1UL << 22)
> +#define PFN_MASK		((1UL<<55)-1)

Currently, these macros and `PGMAP_PRESENT` are defined locally in
`vm_util.c`. It would be cleaner to move them to the shared header
`vm_util.h`.

This would also allow us to consistently use `PM_PRESENT` (from the
header) instead of the local `PGMAP_PRESENT` duplicate. I noticed the
patch is already moving in this direction, and we can complete this
cleanup.

How about a change like this?

--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -17,17 +17,6 @@
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
 
-#define PGMAP_PRESENT          (1UL << 63)
-#define KPF_COMPOUND_HEAD      (1UL << 15)
-#define KPF_COMPOUND_TAIL      (1UL << 16)
-#define KPF_THP                        (1UL << 22)
-#define PFN_MASK     ((1UL<<55)-1)
-
 unsigned int __page_size;
 unsigned int __page_shift;
 
@@ -360,7 +349,7 @@ static int get_page_flags(uint64_t vpn, int pagemap_file, int kpageflags_file,
 	 * Treat non-present page as a page without any flag, so that
 	 * gather_folio_orders() just record the current folio order.
 	 */
-	if (!(pfn & PGMAP_PRESENT)) {
+	if (!(pfn & PM_PRESENT)) {
 		*flags = 0;
 		return 0;
 	}
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -17,6 +17,11 @@
 #define PM_FILE                        BIT_ULL(61)
 #define PM_SWAP                        BIT_ULL(62)
 #define PM_PRESENT             BIT_ULL(63)
+#define KPF_COMPOUND_HEAD      (1UL << 15)
+#define KPF_COMPOUND_TAIL      (1UL << 16)
+#define KPF_THP                        (1UL << 22)
+#define PFN_MASK     ((1UL<<55)-1)
 
 extern unsigned int __page_size;
 extern unsigned int __page_shift;


Best regards,
wang lian

