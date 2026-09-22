Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9FBC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 08:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F376B00AC; Tue, 22 Sep 2026 04:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8F16B00AD; Tue, 22 Sep 2026 04:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 090A96B00AE; Tue, 22 Sep 2026 04:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCA946B00AC
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 04:44:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DCE5B1A0402
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:24 +0000 (UTC)
X-FDA: 85240761648.18.5F3522D
Received: from mail-pj2-f2.google.com (mail-pj2-f2.google.com [74.125.227.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 248251C0004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:44:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7XOgnTc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790066663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7DrDy5k1cF63oZDGZmuZpMhR9CRSHaszqjBOE8wOFU=;
	b=MF4QmdYWqyl0tyVrUVlV3+pmxvzMOvWfEGdCdU6jCm6Mfh5jM8xx/waI9wtw9OIaZd9TEe
	3T/Mybennf5jogpPqBUwgKE2CwVZkuwDIoHzu3Mi8lk8p06GR7iYCZ4jbUPR3KrVSl9YcY
	0ENKvVkUIVN73yL8Z0i8yhngAscAE6A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790066663;
	b=KoB6mnPQm0uls2VPykopsQVabP0iaUGZday6iZZYEU2SMksNyP1ImEGkdT44/yc7isahNK
	r5AZRjBhcw6QJAwDbzub0b0/AwHsCS+YKjZxV0LYTTaf0M1btzHutqnfcdnp3VYXd1XN5D
	FgrdCAGXuZ41qg1Lt1s5l3Dmf2CzraU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7XOgnTc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.130 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f2.google.com with SMTP id 98e67ed59e1d1-39b2ad83680so1597888a91.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790066662; x=1790671462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S7DrDy5k1cF63oZDGZmuZpMhR9CRSHaszqjBOE8wOFU=;
        b=H7XOgnTc3SBvKmP1Rj1qzmpbZx+/xlt2tq7vSGYFLYMLUWt+Fk2R6qwp9RiYb1qHqj
         CphvC0d9cGeu3OuYv7pfO+86pcz3/UFb3j8e1oonqUKMTcE3lRrNgjbzNVJ1N8dEm3BT
         +dP4f4zcQ0fWx9aaohab9ZwUF5HpsgS22TQZUBVehBkSZwGRXyP/bJd7AiOABkXEOWMe
         1TxQOO5GWjzs7UmqDlBOnJII3lstdmjIl1YqHc9mqsG8Oj69WSwoHFk8e+2y9XdtYf7w
         u61YMQkw0icSdMWQemS7cuxfII8HS1PEg1SxGYmUYMFbUSBxofoFmIA5mfW/tuYsrJFc
         /eMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066662; x=1790671462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S7DrDy5k1cF63oZDGZmuZpMhR9CRSHaszqjBOE8wOFU=;
        b=lML2eVpbc24kzObBGWRb/0SWcd0OySHW2UX9SZ76356DQ/xLfICjMzGaAl/tjddHCw
         ngsZSRPK8YqhO+DOvz7ASrk1qfB/uAV9i03CEzEfgAz2GqwQjTyeRRkMOCyZP3o9CSB9
         LdJDbf4iVU3205wh74d3QXsWAh7GE2Iwg0QRi3vrkDfevJGFXjR0XZDvYd4PMyHrjaIt
         kGEDlh/AwvXhSbFxOPnCw9BKef1v0zY5fGnd3c0Uhxq3tMlRnSnjwMBD6DHpF04sQpoK
         u/xcue7/dosA44+sbe3QSNOGPwshaXDJ4095gXtkuHbUOEJkkHpL80lqlhGi51zKcFB3
         tZkA==
X-Forwarded-Encrypted: i=1; AKwUvBxcLgbv8HDCMP7lxxGOuMklVmUXcvTjejBpn6Ptwh/52zbMcy0rbN63R0OmPhQ8XORxn/hfzLzAjQ==@kvack.org
X-Gm-Message-State: AFuF++lbJdOIm+chnaiCe6xieKihzdEYXWLFcvl+zdygXrgjCxtRa7FI
	2hdE4ZpUOm7KeBBKVzrf3qzcJBxixZ/6s0SG7Fd5w1UPJL4vACn5ZPtk
X-Gm-Gg: AYBFou1vSzKzlB5F71yeBxnzFNxc8I+UIN0YbcH+1BFUWxfGuGXq7+Ikn5/icVM4SF+
	xkeGYQa/ipXUHdg9zWK/w/BhII67EE8zXas26ndmc84oD5Ceadn2qj8zZj6yqtMBq1pUZQ3M7fs
	Br1YGjv5zUMAKAGyunAeGnFBsOREr0cl6C46gfsjqtBBO8XDQxvti814L97rwr1HwKqi49cV86v
	/zd5Nx5aEg7i0bXTncivbfV6clBDi3IaIRkhiMH6wfil8qtKLoMuzqSSHRK6qXcbfWXzciwWUtN
	wHfSBma4mYWRjJ7Jl2WUmwXqzmm3lIszKt1yvXgWlJv/GWdpLHxbKN4V0rTZ7SWWZ43nGrp1sc0
	w+IAvHS+xxrzQ0VlArscs42+rr4zQyJKmeU18hKQhUL48gTyCL9S6Y/eICUQtz75PAma1SKOjNU
	2PVIcAUoGgcs0MxNEQzle2hSth1hLi41w6wALZdKmoqaEzB/44TAAhfwh8/Dk/9gkjlCxytNRb1
	1yR/2GQRBg=
X-Received: by 2002:a17:90b:2ccb:b0:39e:6a81:c921 with SMTP id 98e67ed59e1d1-3a0731e1df7mr452432a91.20.1790066661956;
        Tue, 22 Sep 2026 01:44:21 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0674a5ae4sm3670016a91.12.2026.09.22.01.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:44:21 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v7 6/9] of: reserved_mem: add dumpable flag to opt-in vmcore
Date: Tue, 22 Sep 2026 16:42:53 +0800
Message-ID: <20260922084256.1515554-7-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260922084256.1515554-1-chenwandun1@gmail.com>
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 248251C0004
X-Stat-Signature: iactwjni1zzw31qir1md6ztcnz3ics3c
X-HE-Tag: 1790066662-28985
X-HE-Meta: U2FsdGVkX18Seq2lii5VHQ35gZAbiKGaYs5szUFaLyVSX6pQ5vb/7M0Tt0t5p33vhexYKIscdvVBX8/aMdi/UYnagNMM4V9rFCnI4uZ+11wQqtX4sk2Tq3WJF/Rw1FM8LPuHnlxoNG4XMtFNGL1RkxWVINAQ+r+dI//5nYLDDx+3dFAWqRAh4j+BJHBxKiKpFJvTVjH+0KQMxWXBb9s0zludb5hhtuDqqAYGraFrDT8n6KRQ0q29/ftpsGVN5wz8imLv4A7FsL5DUmXjHn7w53C2VU12dqMrItvrG78M9FCOF5jen69bRBQj+3E7UWdNIf3IaRFctidQYPXwaO2y0hP33j2M3bjwpw15weQLu5hvxCB6PApiYc886+j3NfmBalMh5I69mZGWXOZpvSwBIx0yComlaD2lKp8eyJ5fVzpXESzaTsxn/UQw+A4F811iRH/KlJnIE++FDBrQuB7uknmeofmA1/uophUSN4ZUiubw+U2PiZSblmSihNyWjtIzeqh1I+mHzcdtoJ8whDQZ0NzKJLFOqMccY0KRoZeYWm062/rujT60yG8HXUo8/X3jyATNs6TugPwU9VAdzArPgjzY9nQctx8rBqMvdwAJTsJ4/FQOpRCHcsASqJNwndMU+GwmSwSbGYyHMmmkRlSgwEarisqjCAuMxphIoKduNkoYfACH7/VYIuTpy956fc5JfZObUuVwphoVLBALYZby0wj5N2QiWD86kwhisNLR86bZUrls0e/PPp9vb9T9WdZfXgkuG3IYp27YpHTedPIYKEL52NpQjeazmwRELf6hweOYxmTWD+LDuEK70/KiumWdqZ1jRoQJwbXTFbL0rfSkIhnHc+E7dQMI1lE/m6iwrd004G6bu8/nMuT/IJEfrHGmNVhgj/3+v9JDLS5f3UbtJOJewSb/rQhOWXH1Hnbp0TfdgHEjV9aLl5hZCF4vMwe3HJd3/S0gmbKNImK7dVE
 cEVkHWk2
 5tQzPcaAja48KUkcelF/rg+YOa+EVx7r4HoR9Yh6gXgwD9FMPNhk4lRM7ti5neTrRwBMy/+EVR3iXQk1vfEbzRI9ns6RrrPSjJ8jc8AKIrg/7/9OcAn+lofSReqoKK//APnpoCAHei0KYHb5ERwOW4xWW6fJxE6e5jzK0TKJg7ID4ezM6oh4o0F0DdVq7U9slb1btKaEnEdVN4v6a8IaZCFWstxd015GQtcAB5hQcbrEC9RQ0CjMRgvIMTgjhZ26SfF4V4jok0vYX2tlrFkYluORGgQIOPz3MNtcxgt5eQIB4EVzO6lRpDuOgGRRv0ZhekTPWozub6AS4s9hEDolyagFSRHugthgRYqRYRSc71VH86/PSZ6hx2E4Co8+fgRhdDjCx+Iz+tIryQTA6KMuVklRdeh3+sb3fEmBgRXy0LPe6CMorAjnyc79HRDU0/wQtZUUyl/L/0sE6ITqBSwREkTIPGtrxenSKcmdDXND9Q6L3S/XPNbdH4KyXH1amomh0ZkZvhCDdAhIzgOjRLUcZ/KtuQNh5D8qOfHrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Add a 'dumpable' flag to struct reserved_mem to decide whether a
reserved area should be included in the kdump vmcore. Non-dumpable
regions are later marked MEMBLOCK_NODUMP;the filtering itself happens
in memblock, keeping the arch kdump code independent of the DT API.

Most reserved regions are owned by devices and do not contain data
useful for kernel crash analysis, so dumpable default to false.
Reusable CMA regions are different: their pages are handed back to the
buddy allocator and may contain key data for crash analysis, so set
dumpable to true in rmem_cma_setup().

The dumpable flag is also used to check /memreserve/ entries for overlap
with other dumpable regions.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 include/linux/of_reserved_mem.h | 1 +
 kernel/dma/contiguous.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 49da515859f2..99c0f3ccc297 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -15,6 +15,7 @@ struct reserved_mem {
 	phys_addr_t			base;
 	phys_addr_t			size;
 	void				*priv;
+	bool				dumpable;
 };
 
 struct reserved_mem_ops {
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 90937dc7c627..d7bfc38ac762 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -567,6 +567,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 		dma_contiguous_default_area = cma;
 
 	rmem->priv = cma;
+	rmem->dumpable = true;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
-- 
2.43.0


