Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E81BD116E3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 01:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9F9A6B0007; Wed, 26 Nov 2025 20:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76D86B0008; Wed, 26 Nov 2025 20:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964D66B000C; Wed, 26 Nov 2025 20:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8175A6B0007
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 20:15:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15E13160573
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:15:09 +0000 (UTC)
X-FDA: 84154618338.18.0E1D6C9
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2CEDC180006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:15:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nRsCXAcL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764206107; a=rsa-sha256;
	cv=none;
	b=vSfsNKktCO2uz4/mrN1NcsZEQyoEB6XKkyzVqvZntu1a+g84yIrPfTsaRdmjjtUqeiYLqN
	+jOpkNWU/Ih8bu4VmAoCPgaGtgm4+X9gzaiGIo9g9+SDH4sujRSlWX2LVQDJm3XNPfhqnN
	y87Fu+ypzdZRTeB0tlWLrUky9DfajqE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nRsCXAcL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764206107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YN0BTLFbTgqhPvFlS+d/VYwmsgL4p5TAnUdzEI0ntIc=;
	b=L8pzBkL+kdwDW0OwtBwh4HhLDtv6ebjubm9EUAGlp0An08yG0fnE7AeFoVkaxf6w0lF0GE
	bGVl0IYFXlwnZw4PVcPiqH8bvZGak/rXcWCDuQLClw4e1P4lPXr6vGvx/isi7ySgkTFF8d
	pKB4l0UDe5a3o95g+WjnQFL+v1fL+3s=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7b9a98b751eso242801b3a.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764206106; x=1764810906; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YN0BTLFbTgqhPvFlS+d/VYwmsgL4p5TAnUdzEI0ntIc=;
        b=nRsCXAcL/OMiwFiDuMZbtcXkELTIkeaqRXHUc+BAvafnNS+IH4phfGIko1eoH5x1lV
         TcrGycpr+AHMbK3aoTL5JaV708fgbmQeSuBCB7Vz7QTPeZSmuVPyqzh4gf6z4bwtizGM
         JaMWN/6ypxsrRSOF98ZBcjT5JHWtikBbMhzRKa4HtJAQvDnb7cNHuVFk0TKcjmfOiNvL
         BxR9QMrYgQ3qLi3zSimS4OFrYX1btcCCZAwm8iCgBQ1YLhDa/77M4/Jz7awhzsG+ZSGF
         EOZDPZT0mZ78X7uAJQGx/0oRkp8vkHFCCnjqx0nYL9F4GHCfIMHC5h3maZX8B4N0LSW+
         FBJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764206106; x=1764810906;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YN0BTLFbTgqhPvFlS+d/VYwmsgL4p5TAnUdzEI0ntIc=;
        b=suvja1NXGKaM85YbzNWNLb1nmySJBGc1hNYlKtUocE8DIz+ED+T2VfEwCgSWuYSL1f
         e8ibOoBTJSZ9FAtO8JFv7V0kgc3RjQsGR+4p7FLKbULt9U7HWfJS7YhL6iRvr+q+5QND
         rpwT6YBufJYlLhiBea19rZcDKJONSBmRBNG7cBOvDx9u3r6BfYozHxLCAcbUqadsVqHw
         CZ3SfWjxZXAP4AAM8U5K+7yt0XFFhqR5Dx+wi20LSKSQrCjCoSBfgcs4uffZ074yV69h
         GzG6O9zrD/7FrvVVvWJNaC50shztnBab91N3Wk9Ujp7Vk5zn7XyHKaQk9taRunnm/wn8
         TUZw==
X-Forwarded-Encrypted: i=1; AJvYcCUYLOPsNfil+iPCf7T67B0WddNM/u4vFCRif9gGAL/3rYm2b5N+8hH/YAB1Gz3jwZZtEzhutctBOA==@kvack.org
X-Gm-Message-State: AOJu0Ywd5oXXfabtt7ZfOX7YyfyT7erTwPKxA6o7wD6/LwzRO2AEHFYY
	K2JVFyK3Ax0rVgfqzoHGf7RX3VxX0qResmLukmbmMhhaMxPz0QlEcoJQ
X-Gm-Gg: ASbGncseRNxdei7HsFvZDZWOD9D5Q84FPmesUJupB59JWN7S2uXr2rGWHIM0WhB0gsV
	VHwX3w3l7Kksq4SA40Qhovo5rcMZk0U0aTwtG9wKIBVdUf0TfiJ7GU+6e0XkrjZW4hb1aMB2EFS
	s2LnwVuzjzA1ostTeqlOUcUsK4zz85nCnlMyCiqq5/CjISEkTID6Cl8k9IPOsudCvU8ak7+QPTu
	68AFQDORLM7aGy+nDtaUeSwpvW3jDXERY2nAFChTFd5Oo5TI2baVjSKFQCTSELEZzfnEa9ZtSMm
	yfXenKRTi/lu0LGSSgkr89nbswO8A80X/Qv8d4QCfkGJXXYIyhfGF5f807zmj6q34bfDxLk52T1
	PSbQYsgOXsHAJdaFTRwF8+Bf3oO/MAophBhcI8UcgOssq1Q0jN6xPIf2QCGQd0QhLVADEL4uPp5
	Ssg/fR87nDTJHVCnp64L0/2GoC
X-Google-Smtp-Source: AGHT+IFOjeQ0nHa/gitKNf1wf8IwI8ZEjtO1qVKyyQQ31rBE2Lfq+ONwSrRkJugnArpqn7KBTPKjcA==
X-Received: by 2002:a05:6a00:114f:b0:7a4:f552:b524 with SMTP id d2e1a72fcca58-7ca8b2b16e0mr9121834b3a.28.1764206105589;
        Wed, 26 Nov 2025 17:15:05 -0800 (PST)
Received: from Barrys-MBP.hub ([47.72.129.29])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c414c226f9sm22447356b3a.53.2025.11.26.17.14.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 26 Nov 2025 17:15:04 -0800 (PST)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: Barry Song <v-songbaohua@oppo.com>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Oven Liyang <liyangouwen1@oppo.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	=?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Nam Cao <namcao@linutronix.de>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying page faults after I/O
Date: Thu, 27 Nov 2025 09:14:36 +0800
Message-Id: <20251127011438.6918-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2CEDC180006
X-Stat-Signature: pyymh594ypdgi4jz17cgapc4gsnfniyn
X-Rspam-User: 
X-HE-Tag: 1764206106-278196
X-HE-Meta: U2FsdGVkX1/EQQyDP9228oQ890Tvqk5N8P6UYHdmsLoZkYJOOwmBKUxYBHP9FB5qgwW3w8mdfkjNsx22yYk/VJmosuQ7mg1hOcz0lyrwg2IBatWQaqZWEwHTVk/oCyRVoYZwTx9lL3E30TfRodx49jm+zbUSBea6Zmp/urCRsuWaMn+P1GOtlDRYi/PlpS2Mn82nILKalSI1vTPN5VXQgFe2A1GlJS2/FzkCDFyn474CE6pSORXSBErXznMIEQiH03UPHfycKX/K6EphP7tfHgD1yrEp2oGgL1mAJU9w/63zYlHdDMdLqS8OEd3rSznYMKuLm0XfemWhvy+6Hl9xz5W5N0yGs68sV7PtH5jzy0p5/fFW19ApZjY5INQrkyimX3G+VhvA+dQNKoyrOJV+5BrAg1bM6GhQ3Cxw16FCTVL/3h2hphm3WMT9BVcFxCuRhwnUGAIsbbdPpqETkzGkA9yX4hWetCQ9V9yzkxeUGF/M//m65yVHh+HVuP9e1e4RnHP4E1q1WB4PCdxk890kO8jKuiHrhbXKj/ynPGqBEfEq3ASCl6FgXm46ZPA5SCdvSKbwQuW3nWjNfaHOypTlPs7j+41wNV5sQJ/sVBNtmlQSBoB+Zvv0BLkhnwalLUzbGXe/acOZ4OBi7tkW38mxWUBmbuiG3mldaoTtx4ovxIthhLglRpzLakUJyK2ysMq78AxBtWBwd/wLY/2rE8F2wwbemXKaalegbCpGNWxJeumQNpm1RzTAadx1lflwcjuPa0VHjZZD7LbOvIF87QNAneMb29Ex5Nc/+494x4UDgIoxfz4Lxs3cGHwWKfmByOd6PNQ6cN0unRI/X6yEEwXwBaNBE9R618+uhoDRhdseOTdSMZHpy6zE4cmZSGS44+vJbbo9PaXc4OMfYUK021oJPdZP737KQkBHOEceP/q260GOZLZNbvmxFh4VluPLy+F9ZNpVFHpRJe/bzyr9xTR
 6BzuoXv/
 S46t5sApDk0Jhel2yr0q2Qm9e+zNSF4ct7HLP06vxfdDFJPvxXMvhsTGFGgvmalocowMgzsOj2eGhY0dv4UfaihynX24011zFZBqdxR84VWA9rm9Y9S8vKMYRRHgtvKIRMXl7HFJlTfXA/LwFqhnldg9mLGnrBMMXrQv9mmRK+MQK7xINZ7Kt24SHqEAAYiz7sQms0v7mZCye77fp3WqKQHIasdgHS60DnzpCzeWit2O6V0YKCsmkFhndmgf2tzqEhZX3y4ckimIv8a8yYp3CaXbiZ9Nr7JvZcmlP7lC0IT4egwGe9QUdilQqNCk0MxF21YSDcrZ0DllA8DgDX0ukpzFmx70iQemPMRjjnM3MTvs7pDHbLCX5lIhKZqR1+qp+rHjwnSRY3rZlAE52z7DTmOokOruyVuiWr8o3Lds/guCAI9k3hzX/p9oR+iTM+1nJextpBV9rVVSla7ACNomkMmIULIhqHxSRoz4bHCIHImZ+UA4GEtsLlD18LtRELYNQ+D6LBup+eu3W6Wqd2hAXYFS66MdQtPGRF87TtUuDHL0MZZphqxxknIAm2GsEgq80WXVYLqlIuwiMajl3j3Z1z3RF8F3faxO6M4+QOqv8Rv4lx55UpwVBViNtpMUMwiHkD2k3KdMPmows5EjsSvrUreTvBaFqba/Ghn1HuNKp3OxEP6SfXEc/6zd+1NsqEsCiPj7QV9l3hOFgompoMqvzG1+m5yeAdC8Etx4zJ5mU5NtpFOlDkYyKaq/NqKquNBJZsYxMXB5FuhA92D+/CdkPiFWQAGiwN+YmkB4BXxIATFi1ixwIvYV/b2pjq45AgD4WQ/VdHixLbDB3kZsxT2BW2G0PnYRXJJh2bHYBtfCfexXAuBRrOoqNBUfwTGGWhrJx7smb3c9dKKpnZ1346+UrSGsfXQkgO20jT8E7ec98FFvlGxbFgQXP2lKYZU0XHt+Y+C46APK0OieJtMdTN9gR8ougKkgV
 5i+cRNx6
 ip0YiXMid1JzuoBqnDHsP4at2zegStciV8vIEW8s+Ausq0tRIUqhwnjIwULGbU7iyfSAJq6P4YB2Kz9VpECqC+Gbn9DlzJnjCNtrX1z4YxeGtCtUIHhCM+HJx+wBOM6+hYe2l7dLB3EOY0HJug+3c3Dj8i0UT2DpoROOSg8CyJURGVL2MZWzQcjYjVKC6qeiKYkqA/TSgMOdbIB/C65V+lsca+BxF4f4IWKlKXAJUNbZmqSS1l9ZT7dtnsbWxdfyZsgFrEAey3GXiuhjSd1OfJB6m23ygcirIWVXidAZoOxbykV2xAoLJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <v-songbaohua@oppo.com>

Oven observed most mmap_lock contention and priority inversion
come from page fault retries after waiting for I/O completion.
Oven subsequently raised the following idea:

There is no need to always fall back to mmap_lock if the per-VMA
lock was released only to wait for pagecache or swapcache to
become ready.

In this case, the retry path can continue using the per-VMA lock.
This is a big win: it greatly reduces mmap_lock acquisitions.

Oven Liyang (1):
  mm/filemap: Retry fault by VMA lock if the lock was released for I/O

Barry Song (1):
  mm/swapin: Retry swapin by VMA lock if the lock was released for I/O

 arch/arm/mm/fault.c       |  5 +++++
 arch/arm64/mm/fault.c     |  5 +++++
 arch/loongarch/mm/fault.c |  4 ++++
 arch/powerpc/mm/fault.c   |  5 ++++-
 arch/riscv/mm/fault.c     |  4 ++++
 arch/s390/mm/fault.c      |  4 ++++
 arch/x86/mm/fault.c       |  4 ++++
 include/linux/mm_types.h  |  9 +++++----
 mm/filemap.c              |  5 ++++-
 mm/memory.c               | 10 ++++++++--
 10 files changed, 47 insertions(+), 8 deletions(-)

Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Oven Liyang <liyangouwen1@oppo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Kristina Martšenko <kristina.martsenko@arm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Wentao Guan <guanwentao@uniontech.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: Nam Cao <namcao@linutronix.de>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: loongarch@lists.linux.dev
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-riscv@lists.infradead.org
Cc: linux-s390@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org

-- 
2.39.3 (Apple Git-146)


