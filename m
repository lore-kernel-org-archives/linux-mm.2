Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362F5606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PuArea7m
Received: by kanga.kvack.org (Postfix)
	id 4EA336B0943; Thu, 22 Oct 2026 10:00:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49A826B0944; Thu, 22 Oct 2026 10:00:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1866B0945; Thu, 22 Oct 2026 10:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12E2F6B0943
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:00:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FAF112012F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:00:46 +0000 (UTC)
X-FDA: 85350422892.25.33CE2FD
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A0C934001D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:00:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PuArea7m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792677644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EKNYHk3eWPsXkBiRzkLXkiQdodIeDBzq5DpPM2/u1GQ=;
	b=I/Ovbua+jtNiMCOQdA3EX70eMQTLHiRsom/ArXFJXaxP4taeqCJI/UZauyQxaDNyPxmPED
	u1wsLdCxZbWpnbRDgIwoA82UfNDTtgGwhOpkbJ5wX9nQXR1QXxMyN/EG/dUMksq8frRNNS
	TTJnbtjstP8A0X0/GhPGEdxtcoPmJWw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PuArea7m;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792677644;
	b=QNyJf4jQudNcRMDgjApB9lOyq+/CQiB6xVwRy3CcjJRYoEVwHTdWq5jSidM9shxWuWwDfz
	x+D/Nj7H5rV4qRjTxlSwUqH54OdNUI8s221DF5Hy3lRM0CNpSY3g1/8SLHomoC10pvvMHa
	Xa/WlAkbdXPvg83zFvQkdohSmkEwt24=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-35cd4e8bdbdso3211952eec.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792677643; x=1793282443; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=EKNYHk3eWPsXkBiRzkLXkiQdodIeDBzq5DpPM2/u1GQ=;
        b=PuArea7mdUliNlW2yqiF4QNJhxr9EU+rVMCdhuWDxtEl4pObZyYDWIwtEqDiOWuYDS
         fFcp6Y1y4mgTOG2ZICbfSq/StM/JLsxyIbFyHWD89UzuWgKMPncjHlUI8Va8qwL/PIJw
         gsmKwIJJYBBw0K7VjGnYTUmkK42UPE+BpMWqixeYAK/mU4y1bDvf/yKDX61GVGT3tPsR
         QbOgm+unKA1E3NAICU0qoYWp/x/fNsaHNb169RprO183AjKeBxwFFEYVXsJ9oLqmcvNr
         OLtSwsvp6UG3caGTsXpMb7hsqYwy+ao2WvOIMDs7qUh1sjuAOCQJYmviNFVPSIgDKsey
         bNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792677643; x=1793282443;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EKNYHk3eWPsXkBiRzkLXkiQdodIeDBzq5DpPM2/u1GQ=;
        b=iHMpC0r11lF7ukNMHIto6/ieB6X+CJK5Rk3V6NU4rG10+eJTGoNlBKcVO6I+DaLO0P
         xJ1MQtMPcG20larj0YCaWYZN8x0doR36cWwVaiRYSo4UMQS6QqoRkXltWb6I8+Hdi0/z
         qIttgjoLkw/EIdL0HWEFBPtIz61g6NXIet8C41dBkh/IGt9HoufdaTdWCVP3ODQrJcen
         zKCLyxdZC+Rgdjv0s0zqOsGHgwxIIdKiISqA5M8D0O69/pnyFvpPpyUJ2d8QuGYWwCVi
         iJG9F4ehhJtuvREcQF22FgmRbHwm3pqwGCOF7oWp4S3u0E9dbd1XtSBe7242ebIX7/j4
         Mn6A==
X-Forwarded-Encrypted: i=1; AKwUvBw/zz/9XlGVffisWD402I0hgpKVCB20Tx5A7uNqpARiz9n87kaqgoMVo+n5uK5A4u6GN6DkfqyRRA==@kvack.org
X-Gm-Message-State: AFq9FYLvGlvRsJvVpt9Flqcdv6qU8hKvPrxovZyutkhpUNxei3puPeB0
	ghhSlDigi+haBO9lOtpXCsVblxVWfT4lCs8Wt23dHmSXHk7lO1+yia0W
X-Gm-Gg: AYBFou3gwoqlKTE57UQqfw1qcYpIcV5fzC2HjTkvyi8UES/G4sGbY2gkHZMJiCCQOWf
	SYAkj32xNsnowrGXK6EoQ7+fhPj0uIAoRjxzUmId5EGYos/nawXoFezX98FEMi5YB52yHYHj6YF
	9vvezOKKmCBAuT8T7RPTmAUgEI/LFQ4D3R1orJh0bwrXF0IF6DzwFMQKnCNvtkdEGvTHUoP/xXe
	sfwv5i6SqX1vlUlwSuSr5+L9HFYhyxXR4rV2qu/YVCgQP00ZlD60X4P0XeTm6NijoTr+5cTMRaG
	GghQqZiP3eiUsRgZfvDlL2jxgtTHkEeIMByekNzGp5OYB1b38t1nQ6XQdYpNUWSISXv5jdylhqO
	BKRqU1jB851z9sKOhGC1/LH7ErnzC5/4qjURBCAE945rEo8QKo6wfLaHXjzuPy/MX8mZSjKu3sT
	N8S8/rLWowxWmuIMuX4ovCznFcBfJIziazQ2C4ewCmmzpyTEbvyT8SjnwhAVbtlK3uscYESG7rf
	l4lzcjn2S/3NNq+0zTHj+Sz9IpSZV66JGh8WAxn2WaKeQg8gDI=
X-Received: by 2002:a05:7300:e9cf:10b0:365:b147:b458 with SMTP id 5a478bee46e88-3674b52acb8mr7969106eec.3.1792677642657;
        Thu, 22 Oct 2026 07:00:42 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3673e15353csm29420342eec.2.2026.10.22.07.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:00:42 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH 0/2] mm/filemap: read ahead for mmap readers that move
 backwards
Date: Thu, 22 Oct 2026 22:00:35 +0800
Message-Id: <20261022-bug-mm-mmap-readahead-descending-v1-0-6d08b34862f2@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAMX2moC/x2NQQqDMBBFryKzdiBGsNqrFBczyTTOwlQSKoLk7
 h0Kjw9v898NVYpKhWd3Q5FTq36yydB3EDbKSVCjOXjnp8F5j/xNuO8GHViEIm02GKUGyVFzwiU
 Qz9PDjcwMdnMUeev1T7zW1n5JGIsAcgAAAA==
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>, stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: A0C934001D
X-Rspam-User: 
X-Stat-Signature: ab8an6b1q1fpwm7643i4schrwxkkkup5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792677644-351390
X-HE-Meta: U2FsdGVkX18xNgeW2zz79SUO5fPtTjNCor+4/RLfjDLcIzZ0wCBSLncLTg0YEgg2kFNHNhPu4lVJj3IRRYMx53q1vY8xja+VcG0OUUlaNbhLHdQoK8/3HXlUuKsqxqViZPrfH4QxVwQl/P61RDfsG42EfCIZ8XsgmPUUlNPFtlGaHvlH9wgHAfkkfUwJBs44PXVIkjT/s2OrOlUVOMpenf+0FWkl36WYImZdpyiR9QQKlFRhjH7KwrzbLqdr70OjgY0NctpYlGH5Kvw/ia6cTiYWYdFTQ473QnJEY4ti3rLLAkD8iar4W7buWaWF4oWhODnGITPVdxb0NixKSv1fsfUE2OnYiSjeDuHWtIlywgiulbeSMOO4FFUWHomyv5iAoLmSEp45/tosAp5KoXbPDT7splhxSIc1558cLfhiUfrYmMAQnIJSOidEaQeReXeM/EPoGvRQNMNKy5YCReLgra9GdtVo1mOgpyObOeB2fMesKQC+vPULgKVsdzcqhS4JHgseHbFQbXNPdiPWXes5Kb0CtEYEzO328pxjNuNZt9MOI7cKDDtw3B4OnM5P65zhM6yLHHlp7wd3eSp8BoKOHFw4yZdIh4G1FMPmcYh3XVFyJIcQEfOsEXMWh5jsrDU66aj+v3MfFFWE4H7RsctwiIcdAN4nqouCuwMqp72zmISBRI+MqQMS5AkM9Psl3vg5qWJR+JPTrbXD9Ji0ArtvRBB8zJ6SAaVXsJ05yzIro4DtsAsHmuZh2786nXepm7WFgHg6goUbzhHm5Z7hNzaowgUMM/bvCXk77+V0jAao9sCo4Js4pYzaFw9XGhROWbvqiGbxftoiifCWxFiaP3+6nEUZPnWp0GrBrYReY1irYLsus/DZOCDA93Bcb8v5p/+updGNZQ+iWeIJm9RX40RKvlA2R+0/9/pGkwnVAmUsCZg3o5yUlF92TgGkh9xSa4iEKsij1v1UredusGeJb+n
 2KHHPltg
 6trpX9oP5Rws7FwOuNMZbivPIwxClANW/BLzYJJsZbcX+r491MVqCWJHfoh6yu50gBfFlPLaMClFr7oQr1r6W49gG/jCo9qPw/CWpcSZ/AzqGkRLGkLvsEKy74NCdGWNRmc0+PtgXbYCPzi6Qnzo4O0ECiAniUH3nLXy8AwRVEiBKpfVK88nSUzCyPZ4nllTGU5bN15rDOEhFniNrIgDbPob0HceBeXvOx3UQqIWhIduIF+Fxppe1vpsdMSPYnCVxG8M9/HFdNkuFNQ9W9sSxoJgV0i1rM3zW0qlxk19YBWNY/mBr1Gdp0nHbE5JNqUZNdTxA/gQmwVx7f2C6iIra9eKTmWTfkizOrAV85TDTalOHnIflvcFuaAn22flRlDhH+LLpvAT4AT1Anc+3xI9cPuGPp/+iHjaRnUZ7dhzKyQkh74mmfsIptSb8v4bQ/VGBgHA9L/qYTF/rPnhBIVzeQqhBmnQC4IVV7sJGHw+a3CX0GtJ+9sSFMVLA9dTbbD2HiaWE9rI6Bs1Ba/GzDKSqC9nKEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A reader that walks a file mapping towards lower offsets gets almost no
readahead from mmap faults when the mapping asks for it. glibc's
memmove() and memcpy() copy backwards when the destination lies above
the source, so this happens to loaders that copy large files out of a
mapping, such as LLM inference engines copying model weights out of a
safetensors mapping. Both MADV_HUGEPAGE and MADV_SEQUENTIAL read ahead
only towards higher offsets, so each fault of such a reader reads just
the part it is missing.

MADV_SEQUENTIAL was slow for this before 7.2 as well. MADV_HUGEPAGE
became much slower in 7.2: since commit 0b9c0aeba938 ("mm/filemap:
count only the faulting address as a mmap hit"), the PTEs mapped around
a fault no longer count as hits and PMD mappings never did, so a
backward reader's mmap_miss passes MMAP_LOTSAMISS after about a hundred
folios and readahead stops. Each page after that is read on its own.

Patch 1 fixes that regression: on a descending VM_HUGEPAGE fault it
also reads the folio below, and it counts a PMD mapping of the faulting
address as a hit, as a PTE mapping is. Patch 2 reads the window that
ends at the fault on a descending VM_SEQ_READ fault.

Reading one byte from each page of a 2 GiB file, last page first, with
a cold page cache, read_ahead_kb 8192, in a 32 vCPU VM:

                      7be4bc52fd9e    patched
  MADV_HUGEPAGE          36.76 s      0.41 s
  MADV_SEQUENTIAL        50.28 s      0.76 s

The same walk takes 0.53 s with MADV_HUGEPAGE just before
0b9c0aeba938.

Forward walks take the same time. Megabytes read and major faults for
other access patterns over a 16 GiB file:

                                  7be4bc52fd9e         patched
  1% random, MADV_NORMAL         1002 MB, 39619      1004 MB, 39619
  1% random, MADV_HUGEPAGE       1583 MB, 38762      1603 MB, 38758
  1% stride 64 pages            10496 MB, 4          10496 MB, 4
  5% random in 2 GiB memcg,
    MADV_HUGEPAGE                2203 MB, 187413     2221 MB, 187399

The walk above, run as "revwalk FILE" for MADV_HUGEPAGE and "revwalk FILE
seq" for MADV_SEQUENTIAL, is below. I can turn it into a selftest if that
is wanted.

  /* revwalk FILE [seq]: read each page of FILE, last page first */
  #include <fcntl.h>
  #include <stdio.h>
  #include <string.h>
  #include <sys/mman.h>
  #include <sys/resource.h>
  #include <sys/stat.h>
  #include <unistd.h>

  int main(int argc, char **argv)
  {
  	long ps = sysconf(_SC_PAGESIZE);
  	int fd = open(argv[1], O_RDONLY);
  	struct rusage ru;
  	struct stat st;
  	size_t i;
  	char *p;

  	fstat(fd, &st);
  	posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
  	p = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
  	madvise(p, st.st_size, argc > 2 && !strcmp(argv[2], "seq") ?
  		MADV_SEQUENTIAL : MADV_HUGEPAGE);
  	for (i = st.st_size / ps; i > 0; i--)
  		(void)*(volatile char *)(p + (i - 1) * ps);
  	getrusage(RUSAGE_SELF, &ru);
  	printf("major faults: %ld\n", ru.ru_majflt);
  	return 0;
  }

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
Qiliang Yuan (2):
      mm/filemap: read ahead downwards on descending VM_HUGEPAGE faults
      mm/filemap: extend VM_SEQ_READ readahead below descending faults

 mm/filemap.c | 115 +++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 85 insertions(+), 30 deletions(-)
---
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
change-id: 20261022-bug-mm-mmap-readahead-descending-9cab86703bbb

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


