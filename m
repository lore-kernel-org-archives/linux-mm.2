Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F74CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1098E002D; Wed, 12 Nov 2025 20:47:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62B578E002E; Wed, 12 Nov 2025 20:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BBD8E002D; Wed, 12 Nov 2025 20:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2B47B8E002D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E941E160771
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:21 +0000 (UTC)
X-FDA: 84103896282.28.0D27099
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0AE69160002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=UFSnFpEb;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf08.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998440; a=rsa-sha256;
	cv=none;
	b=ycKlBaWpxIuTnpoHeFT+AJvtDmUR4eSomXuu4xdkdthlLBaq8oDkikaGcOa8RYA8JbqQD1
	RMsVExdspY7bsvA+TsGKX0nODXcDW+qWyXF+sKUsaQG7cMPPZun26pog7CcTFW0fVS9MFy
	89UJLRQrLe1AUUGufWJLpSRrDM2MUAw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=UFSnFpEb;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf08.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61IAp/RLZglhPiTIaYZ0zqBWXh5TU3+Z1ZyRv4wlW+o=;
	b=HXhgn5KfzF2BNP2Ypvv6oUtq8/jJFn6+3aPNyDErZotVlQ/oITwP5tJJ0lt7z2PhrKHFrn
	ghhkbThovnD+cnPskNtXbH0M9cIh6mhA2wqQ3qCKYcEHTtWp+V0fkOxmawVKxfTZc1ZOBU
	0IBweh2+Bsr+p1dtBqM7/Xm5h7XOM2c=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-bc1f6dfeb3dso176370a12.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998439; x=1763603239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=61IAp/RLZglhPiTIaYZ0zqBWXh5TU3+Z1ZyRv4wlW+o=;
        b=UFSnFpEbqBfnCSrV0cXFsOSIbYpEPx8CtYk+AxZDvNtBHkoG54WdM3oQbfw5Q1k05y
         sShQaEfqGlPFGajBKwfPioU4KeKVH5JigOymNWi0R4GtLgWgBDzZgDgnNrJRWFBjCGlI
         FCl7t8bbMUmodXI4dm58Ondwy0vRFSVTI6oiqMzW1LQwswcosEW7V02Oyjkn9C6susre
         t4DtMr1IFv7COD/SSdmCrN2ocP4C6eYIzgDtMKZLkQ8APHholBURWKETT+PRsKm4b6pG
         NXgno3jlcTAxtCjvor4pJOFCnezw86SKBZgxme45cXpQZCAWjWYQ2LKX26AY3xh5viIR
         kvRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998439; x=1763603239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=61IAp/RLZglhPiTIaYZ0zqBWXh5TU3+Z1ZyRv4wlW+o=;
        b=rB1bQLYeB/sCZQHHjOrHTTljgSp/oqqVKsyBWjLKBrLfAlmSC1w1aFYXh52s9WBnT/
         +LyxvrD35zybJsv9ciO97cs149EWC6bZqFGtGA/+u+uxYmNy8CIe74DcpKMhXPVULuGq
         pU26MIQWvneAPzyVKgy921DdMSaNM3mjgYrQyNbVQRPtAo9ILKBVU7nehUhyARwmWWyE
         7OTxXKW/nu1/xWouDD8qbfEDf4udpqZJL0IDEZpHewr0Be5/HGxx1nZeeLlrkPZD+WGV
         sGdfQ0zINks+0JXFL5X/W9a4G5MW2aZyxHTo290e1tDPCH7s5g8QyoCV+ylODoqug709
         A3uA==
X-Forwarded-Encrypted: i=1; AJvYcCWfe53Vmeh+xXmZQ71SfhDekpQwQ1GbseIJ7B6k7SY2qC6u6rKUq/zTKRWbPnZF8pT8sj2UjTs1XQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1skXhITYFU8Qmv2Z5NSgnd8cxbFTbYEWJgvEJRcRd7lzgTz3a
	KEK+awVaI6RftqGgbzjSrZD66QMul9gKa5qZYI1a8qsYNOWrd1NoUhupEzzBUrKzJ8I=
X-Gm-Gg: ASbGncs6o7nQO61GF9pRax/tl+xrdtEuUkFhnbl+F0SDJol8ApsCyeK4EPNsZiqidRa
	HWGgF2s0hfwkj28Qm1ZLKcjHAVHwEgfyMokSK9dyN2tfeO4Qe/0UvparI3rGdei3TB/BtklC/93
	XgRowu7JkVO1MTidrD2dFgnWZa45pPK37r5Ea6XjbPa8G8gL8w9Fc/aDEJYB6CIqD4JeijFUPBi
	BPpyhbDtaYqD1hnE6h6doZd6kBIV7b7MDDYBJxDCafYpPhcQMu9Kty3ja8f9TzFuza9YStahM7K
	ED1llxzOfvHNH2TaqBzvUgN4fJPo2bY6xZxikt9HzD6q5KdgdYoTfOIpzm6KdWSht7oWpuCKlXZ
	Cf2aScJZb6CrSJOLUL7WK+WGg10zzC+jzTLSum32q2efCOdQIiwCZaAoai+zKMzNwsDbjjM72y4
	j6hcsFrE9NWzjjdod50RF0Eg==
X-Google-Smtp-Source: AGHT+IFQeTKY4sW5xPwKJekSx5UPto2J8a08JXV7cfYp4pOZ2iobnw+lqJ4IrO6RHskdtg/6++UDAg==
X-Received: by 2002:a17:902:e5c3:b0:295:ed6:4625 with SMTP id d9443c01a7336-2984ee0459dmr58942605ad.47.1762998438873;
        Wed, 12 Nov 2025 17:47:18 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:18 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v3 13/22] riscv: ptdump: Only show N and MT bits when enabled in the kernel
Date: Wed, 12 Nov 2025 17:45:26 -0800
Message-ID: <20251113014656.2605447-14-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0AE69160002
X-Rspamd-Server: rspam07
X-Stat-Signature: az9pk94a46qnz9fq89rw7n3kwqejps8d
X-Rspam-User: 
X-HE-Tag: 1762998439-466536
X-HE-Meta: U2FsdGVkX1+JW1dHttfKjCpC2zTTRgAVs12nIO6XuULm9BXKn4Nk4pDWkMmVeul4ZxEUG2mF9OJNlmun6wqNJApLF3+re9VIQXyIXmVX+zSGQ5eShPESBpqQ9//n73TCYaTaPlGIiQBDLOfkdjXE/WZQmC3lEIttZwmRkkIHafur/XZBXq6NNncr2Zu1EJCY9Nen44IQzGjZx8EFQEL3TY0WSQ9C8qDybKiW+ykJtoWMElGkvr/JQKo/x2YVZKebPsKeDWJhNBUtVxiO7HPJTODzoyEwL0ucYtxpR7JdS474Bp4Dvv1OnFexM6oXjLOV2t3mP1Ufuoam5Gb/B+C0c3LHFZf+W5zfqWqXBzq4mQIj7KO1hf1S4RdZoEXRaUvhNf0pPiJF0bRQG/ktKGf8z/uEStmkGCxPMk9f3uN2O4oHweWKaDJetCqERGzABMzopB1FXg1Uh1r+9j/NYKh1EeZsnc7G5gKcV53O759fPMsh1S1irwaI4iBMuKYTEJJbG7cPZ7Cu5v+rGBIhN1O0P85aD68ftEoDR2jGR359IXY9Uj/vy9m3aHO1DJno4KYw7bCh7PIDNR/QyFqhtjFFxWqfvzdsVxeNMk0d98ZJLl1zY6I1EaETRdsXkaanNvKBeZKDz4pPcQ8SqCUa0AYCT1DOSKjNPVQVPV1pEstBM5UzgBZGRXuO7DM5QnhAPk0bQ+tcILMf2VdDZAR4KZYPC9Pghy6QmMc6Yz5BxF5gzvX2lVFEWe8sY/25XgNgOVOhiPJ+WE51QLv/Xig2Alcx3emVkVGIsLtRdgKqsHzyK7ePVFD+xsmoG5sI1RZYIr2keEr3PxbtqXTDbAGZwBFTXgZCjzGdQxZkL/OgSJYzvLzbC0Jjsox3LJVLCo2U57HvrkJxsUi3Cl0JNYCYvT7vfhSXP9EsFjRCXhWMUQUya0/9EN6o4FdjK4rgnge9rdk/4wsLWa/bMoTkR8lv8g6
 sqp44HyD
 MaNRUKQmzyvG4Tk/TOSSMvlTo6Wbar95dWWusDOAGXCfu9Ie3JTXbSoq203rirR6REu4R5mJn1OmPVyCpIXLRw/3EW+9T/rYBcvg5p5yGLNL730jb8PgdrC2rNx4KkCBZ7t7JEmIJraaZ3RlD9UqGPh8wBTX21y2nSxrDS26lunDsCzjmIQaBKnGODh38QQIcAPbZc7Hdd7QYuQqGpz3kTvsgBMNMJVBx56lzu/mfirSpPLK7TXxHioN9ZraI/GRK2UxmjS7gkkvMX3f9d+SsrTCYIux/8blGhbvHejNeZiTfktKFQvVr4REIvOjXb3/yiwf0OFk8XAlyYHf85uSv8RfJj8pWy5cfSvahN0M1E9Kmtzj1ev2OhkjgU/74lIWjtdGpZ1w+LhNPd0je39KcJvQEC3v+xKxebzVPOPNSNmParyAf7ywyAq88AqZcUFyv4DOtBKSxmvhWr7qT+WGKaFMIow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the Svnapot or Svpbmt extension is not implemented, the
corresponding page table bits are reserved, and must be zero. There is
no need to show them in the ptdump output.

When the Kconfig option for an extension is disabled, we assume it is
not implemented. In that case, the kernel may provide a fallback
definition for the fields, like how _PAGE_MTMASK is defined on riscv32.
Using those fallback definitions in ptdump would produce incorrect
results. To avoid this, hide the fields from the ptdump output.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/mm/ptdump.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
index 34299c2b231f..0dd6ee282953 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -134,11 +134,13 @@ struct prot_bits {
 
 static const struct prot_bits pte_bits[] = {
 	{
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
 		.mask = _PAGE_NAPOT,
 		.set = "N",
 		.clear = ".",
 	}, {
+#endif
+#ifdef CONFIG_RISCV_ISA_SVPBMT
 		.mask = _PAGE_MTMASK_SVPBMT,
 		.set = "MT(%s)",
 		.clear = "  ..  ",
@@ -214,7 +216,7 @@ static void dump_prot(struct pg_state *st)
 		if (val) {
 			if (pte_bits[i].mask == _PAGE_SOFT)
 				sprintf(s, pte_bits[i].set, val >> 8);
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_RISCV_ISA_SVPBMT
 			else if (pte_bits[i].mask == _PAGE_MTMASK_SVPBMT) {
 				if (val == _PAGE_NOCACHE_SVPBMT)
 					sprintf(s, pte_bits[i].set, "NC");
-- 
2.47.2


