Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F472FCC9AF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47B76B0088; Mon,  9 Mar 2026 23:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF5B86B0089; Mon,  9 Mar 2026 23:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D7166B008A; Mon,  9 Mar 2026 23:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E02E6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:12:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25EB51403EC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:36 +0000 (UTC)
X-FDA: 84528680712.02.618E362
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4B3E214000E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=JoB77cFZ;
	spf=pass (imf23.hostedemail.com: domain of r@hev.cc designates 209.85.210.171 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qdvvi5cPomjzjf9BfHEmNolRXDMIdQNGPSx8FVbAXpE=;
	b=GgH50nzDzovJ/5q3wN+Z41EoUd/fF5fda7DSgZU06C8HTqu12IKS1ht2YvTZVca9+kNGxH
	yaaTakmWwYCtprffd6R75hjB8apkhzP0CeDhi4Zqq1HxVryEX+lLQzcR/d3DiD0FDmbibO
	vcFvXWyfV/qf6EkfJBZDx5BWRaX6e04=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=JoB77cFZ;
	spf=pass (imf23.hostedemail.com: domain of r@hev.cc designates 209.85.210.171 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112354; a=rsa-sha256;
	cv=none;
	b=5VmsG4m3j80nIZ6DrZBLolFM0VyUPPQSSecvVZevgIlnCFdhQnIIhMpi9b8kaVjiZ0L6p1
	4OvjKcjJ8Xg/5UkSU5k7a9MTKg6HhZ1E8iuNTB+9lSq06hl7HitcNIWE613qeyQ5UkPu/Q
	YpB1NS6O9PVG7ZfPQWAxIYD2bfbYXbo=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82735a41920so4574958b3a.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773112353; x=1773717153; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qdvvi5cPomjzjf9BfHEmNolRXDMIdQNGPSx8FVbAXpE=;
        b=JoB77cFZJC2mTM4uwR47j73oAslPjgRQU0LrpAI1CxCMGWfzIlLOiEnHfC7ROdVEzO
         zP78P9G/8RRyERE8qfRVxZpmAVfoYGbX97dja8iEQLXq2XChwFH3s/cBuTcVkRs1FWG2
         Fr3h8AH3HOMD7rw8v7fPjMoKj61FxeyYj88dzPfhxWrxUWBUjHfmiN8j89l9tSAzVfAU
         J7SD8MuvVt5kfYopqWesbcoBG+Bsj/f//DYtHpnsByr4TdeskiyMmWd30yZXUOinVP77
         0ujuIVrBGa+w+GIb+f+YENDK8kiQvDxvNWiadsCqPPytI1zaidF7QQZm/wDSXYZFydEu
         J6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112353; x=1773717153;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdvvi5cPomjzjf9BfHEmNolRXDMIdQNGPSx8FVbAXpE=;
        b=jl3C9LRhaeKw8TJ/Y0v5GImESEJSfKQ341e6gSJKOBNO3XXgPB833WkOV3St3WTAJP
         SdsIqTAhBz/D+x1s6bYLgnC5foVhW7zk6iBxDHzHT7+axGrL/ZS1BUzFoTHdwKXbxi3e
         +MQUzkLwRRNf6/PYzOlta4Tgv4rneGaunSH5YhZMeSE9vaVtiJw07juhVIAPtFBkDMzp
         KWNul/SiOBJi/DJll6HE0RtNs1a6nerb9vD9sJZZK8307Cmis5weY9EyJrFrkxhZIe9r
         klJ5y7FUNJZNVuk8pwsdq2wUWCXKQQqJd5MPHy5KLw1QJcMiOH+MbJnBjcCxL47coylW
         4uCw==
X-Forwarded-Encrypted: i=1; AJvYcCURPAonzzcPiO7y8jXw/+2moEu69IXUO6X0PxWkLLDCMFyY3DQO5hwVxx2tCbOKjQI/WR9wTRqxLw==@kvack.org
X-Gm-Message-State: AOJu0Yy1KaNGbVMxZjAsvKQcr2tMDP+cwfU6Gc5cMU3LYZoZRna+WugX
	esDIT2VVLs7mJcr5XZJxftn+m7wKkT3oV31Wk+NXJ79WJZ9VasQX3k1N5jt9Mp0GFlg=
X-Gm-Gg: ATEYQzyN7y9ctwTjP0x30zi4QmJV7b4Y8Kn+Ehu0y5jEx0kWzEjBvlMqhAj0WEDqDSz
	JHvSyKK20+j7DsFERXpcqvnBjr6kYxB5WaTPtX9PCxRP3JxmD2Witl11GP9uZ2c4ggwbwHLjulo
	ivQxhmfdx/NHXkUAsBxJkevKoo4UJwUWFJ/uQ9n7pa5j+rmupqDX4nHShQFcv40ga4IvHpXyPJQ
	d+bNY+pRABiPSPcDgZ8guzM/1Mt/fKvQdxc1+Cr+DCbMFAgCiNKIanEyAJ0Uh7PDCwiDWKZ1lic
	kro6ETw0bjNAUEoqJs+UHNx1sl2uGX9mSeHGl340XksWZg1rNzv+7FI0MGBqVOiiLuM5CTKBUkI
	d6OuDzm6dlCq1QRFMUW3mwdPu4D6LOgcEkuU9udX/0j9JxDFhgfMow71eR1zJ8xZ2Nq1rNCGJ5o
	3At/kdsG+f
X-Received: by 2002:a05:6a00:66ca:b0:827:2c79:fa84 with SMTP id d2e1a72fcca58-829a2d88cbcmr10308211b3a.12.1773112352943;
        Mon, 09 Mar 2026 20:12:32 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a465c872sm14213691b3a.19.2026.03.09.20.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:12:32 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v4 0/2] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Tue, 10 Mar 2026 11:11:36 +0800
Message-ID: <20260310031138.509730-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B3E214000E
X-Rspamd-Server: rspam07
X-Stat-Signature: 57u8ozbcbngetikjo9z7ffu3mcxbhhtp
X-Rspam-User: 
X-HE-Tag: 1773112354-223974
X-HE-Meta: U2FsdGVkX18pwc9wz8l449WGJAbBTB0KqScf4x3ZJpDWB0QJapizD8b0HVb8+MXLvUivG/cV136iVTxJVkto5p2GvDTfkWhexwajYlkWzNwV9cWt7HZqoSDBxYNC5cDmU+n7RGxC0vOEv8uoqhg1nrBKfgKmJWFfxRTy0bfHrKjmnXLdW6ZU9mE0xth7InwPEquVloJVASrAyDg2YaZW14cKCwI9+EMEM4IruS1GvPnySpoQxUUKFOwuTIVuRJfAlKDvz6SKQptjA+BepHlbnYmLVefB5J5MtnjMaPbyw5dp5/MZp0Yx5Ovyk1K5gYB30DX7sy77TNu35GGsFxAzvo3Q/eZn17nqjts8HixStj5dVADt2cqLqM34gW9slsQgzLBwr0lEmdvQ/h7MU3m71FbqrISHlEJ9cQIRpZ90Z68u98auQU+G6wRj13hW9tlwSOHvC8uzfFgN/cLrNCz6wXOnL72ynf9UDgGKMyWIH5aQ101Gjwbg/29JKDa3M8CTTAStL4DWasqRNcd2o2SA7I49XSBVg34z6mQBfj41NtJZqb6/Slo8lGEJ+9EoPE5FUG77hky9886J1kAO7C0s6quxX+DpbdriJRuM3vDFlablCbQKU3V3o+bXXb+lmfrdB6Mdp+tEWxL1AVxBA5XVqww8JTZlEwwbdUNU1hNl0/ZE78CE5/eWWiPBVX51ZSN/QiyRszsDSvtiSERlSX2i32Zcl4Eo58vGv383dfsAJ4K8lgTYFekdbZMfjdj8wFjvtCZbvBIyRIuA3N/p+jt1LWATqGgAsVGeVjbySlvXuB7tMlB0KP/HI42ME6GQ05ABy0CPF+BMDilgk0Nn+9CmAnJU67hKJrLTGJQqgvAzK3aX0k6OgLpD7bFWcMWZmjDznBbGvUtuOsX3+e3DDHZMQI1orh7qhP9rU3FbJJyqgrN+QO0i93FpPSBE9G8RQkEB7kdYeVnPqjXuVKqD73N
 hmv3Xsl+
 SCkN2oiGLlbMG3OCC2p1X6k3nRVlhosnYR8VPnbIIzcchS3SeI+MOZd6pca8JBU7l+hUWfjtlMMm4KHT+QvtVfTh8uz6TNuixY2LSYyR4/mw481jBAi3sI/vxyV7D7qJMYfaQ7dfu259121OoqVWEK3/7xC4KFvmqPrQ6lLvWZ92rfpuuhL6QU/PRyKHGVD5+GWmlCrKhzJy9i4K12k4F/rHbIDn7LFZqiR2YG7iGvU31gAUh/WlOwjv8hCob+S8g3mEevyKHoX/jeeLMWo+kuBo5OZJcwAXcmnNntSCc+lVtaXal4CSha/g/XOAGgfZmuKHaO8vRUXPJDX2pFCcyTDTgNx8CWW3pm87KyeKcWkOw6OrzkT+QvMD9UTXb6SrHEPEZQpIjmdrBb0UdYFuO4YdRDLpOGjJwlm90jqaH+iBfhpCDmCgW26G3CTsphRSUx8kzi5LmLxU2Nz4E6dd7/cZ75BpEONF7obiul6mJNDPYEZrpNEtWMLZwWWcd1DIDEMIPVDW28bhW8qbH3UQu+O8YjxfE7g+yakIQV5ZfsSkE8Z30Y2m9creYOFuYLffEAizrAcR2bOCZ4bNZvswHQ0zVVk06l2/Qy7PAhYgNbDJZdHkZKRkSPk3EKYMi4To4Zx6pVX5OlaP9qnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since [v3]:
* Fixed compilation failure under !CONFIG_TRANSPARENT_HUGEPAGE.
* No functional changes otherwise.

Changes since [v2]:
* Renamed align_to_pmd() to should_align_to_pmd().
* Added benchmark results to the commit message.

Changes since [v1]:
* Dropped the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
* Moved the alignment logic into a helper align_to_pmd() for clarity.
* Improved the comment explaining why we skip the optimization
  when PMD_SIZE > 32MB.

When Transparent Huge Pages (THP) are enabled in "always" mode,
file-backed read-only mappings can be backed by PMD-sized huge pages
if they meet the alignment and size requirements.

For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
segments are normally aligned according to p_align, which is often
only page-sized. As a result, large read-only segments that are
otherwise eligible may fail to be mapped using PMD-sized THP.

A segment is considered eligible if:

* THP is in "always" mode,
* it is not writable,
* both p_vaddr and p_offset are PMD-aligned,
* its file size is at least PMD_SIZE, and
* its existing p_align is smaller than PMD_SIZE.

To avoid excessive address space padding on systems with very large
PMD_SIZE values, this optimization is applied only when PMD_SIZE <= 32MB,
since requiring larger alignments would be unreasonable, especially on
32-bit systems with a much more limited virtual address space.

This increases the likelihood that large text segments of ELF
executables are backed by PMD-sized THP, reducing TLB pressure and
improving performance for large binaries.

This only affects ELF executables loaded directly by the kernel
binary loader. Shared libraries loaded by user space (e.g. via the
dynamic linker) are not affected.

Benchmark

Machine: AMD Ryzen 9 7950X (x86_64)
Binutils: 2.46
GCC: 15.2.1 (built with -z,noseparate-code + --enable-host-pie)

Workload: building Linux v7.0-rc1 vmlinux with x86_64_defconfig.

                Without patch        With patch
instructions    8,246,133,611,932    8,246,025,137,750
cpu-cycles      8,001,028,142,928    7,565,925,107,502
itlb-misses     3,672,158,331        26,821,242
time elapsed    64.66 s              61.97 s

Instructions are basically unchanged. iTLB misses drop from ~3.67B to
~26M (~99.27% reduction), which results in about a ~5.44% reduction in
cycles and ~4.18% shorter wall time for this workload.

[v3]: https://lore.kernel.org/linux-fsdevel/20260310013958.103636-1-r@hev.cc
[v2]: https://lore.kernel.org/linux-fsdevel/20260304114727.384416-1-r@hev.cc
[v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc

WANG Rui (2):
  huge_mm: add stubs for THP-disabled configs
  binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for
    THP

 fs/binfmt_elf.c         | 29 +++++++++++++++++++++++++++++
 include/linux/huge_mm.h | 10 ++++++++++
 2 files changed, 39 insertions(+)

-- 
2.53.0


