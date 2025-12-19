Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F528D767EE
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 12:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2D06B0088; Fri, 19 Dec 2025 07:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470ED6B0089; Fri, 19 Dec 2025 07:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372B86B008A; Fri, 19 Dec 2025 07:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 24E046B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:37:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCECB140160
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:37:25 +0000 (UTC)
X-FDA: 84236171250.25.491DAA1
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id A4A09C0012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 12:37:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eZjaJg7v;
	spf=pass (imf10.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766147843; a=rsa-sha256;
	cv=none;
	b=JQoB8E6aJSQU5iOEvFmLVJ5cOh6lcfGIj88DWm9HnWE3xi9RcZVQ72ixYIIKXcQSfGjfnR
	r3X/8i3tZMbZAddFo0HePJ7yReaJ5Aox5N1Ml8yYeF2wYmfdu2gKs0E3qiORb9APOq69uv
	ILQKOEgkbOFP09YtENFh4RjW8K5yuNQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eZjaJg7v;
	spf=pass (imf10.hostedemail.com: domain of grovesaustin@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=grovesaustin@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766147843;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IcHUaTFrmXuihljZ9NPOpOfzWyP2bzk3HiTs5aJT8Q8=;
	b=6exMYahO77pmg4sdnZN1U4UDWBI2OTTGm5ATyZAbnGX1pmiauX8PXCZ4njnqD1RqFvGCGK
	9IJJ7cLBK5TF6bSUSny4J5rt36lzv+8gd8jIJ+o+CUGQ+dg6xflaUS4pu0eMHHV5tbDqPM
	BQCxU8c7l1Xy83aSDgxntuJK3q+w1DM=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c78d30649aso1039376a34.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766147842; x=1766752642; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=IcHUaTFrmXuihljZ9NPOpOfzWyP2bzk3HiTs5aJT8Q8=;
        b=eZjaJg7vRKP2s7RfQ07/gC7EgY1DtxAXtuZ1Kf3iWRp0UNYkfo3jzqwnQRjyRD22ZS
         9cNHv5MtSMdX1ScD10OkRagxkNdP/sUZwC9LjYxZ7c4FGAaB9puLmnIRLov4XWdfrd+h
         KAr8/FaVTZBlb7v8v/ljGSxvFthb92ZNFG5C4ug321aYOJCJLITOwHdaSi5RwId79ePF
         vQf6PJREyIPA6KTXIQfi7QspR5I2Fj1FksBwkRMgB+66zdLmk4qif1mcjvtnLmFneCuo
         9UGVJSBvilbslluffdoxy27tuQv8aMAstrsPn5sNhzlTkvygutgTABfq0eNG72llmze1
         m48g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766147842; x=1766752642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcHUaTFrmXuihljZ9NPOpOfzWyP2bzk3HiTs5aJT8Q8=;
        b=a04gp6b0PnqJo9spHQ9icK3GhmgNElIkGxhZOwYYkIy3aWF+UxD56sEiPNsTwDcGae
         /hDfr03pyFsCgyacC+fWRMI3im0TNRLTqKf3v26sZ1l3rEQxRif83Pm1eqrPmG2hm/v2
         RSxqwif5D59XorPpWHOVj2wLSgqTXO0JCUi9v9rTpw5UPg5xrDFtfXtj9gmL+8CR8Zq8
         p9xRCECHbaZu3cdKpponJcD/qacntVXDDMnqPhWR7tWQ8XLLwhqkQOiRnnX3lT/XXyaH
         GkYdCi+kGtEryE+ON5w8UpyGfeZZ7wM0ZyYTKUhuh1U5CfkRkrqKIiCOKfhKk5RB4BI9
         AowQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcLmpfRC4aiGgV8V7yzU7Vi6QsGCmz6mi7HFQj9iGjyVglJIH9uv3h+R5c4Df4T47S4+iUkDfBpg==@kvack.org
X-Gm-Message-State: AOJu0YxE76JbADdsxSrVjQNfHcm1elM0dNC7MSQrwKNsX5w/GQFnf+PL
	MFkRFUH3zj+F+TdJiEsonxZ+T94TJhUOHic0LdkICKAc2tjYs9+EW5q4
X-Gm-Gg: AY/fxX7EE9cVRnoM9cbPuM6aAC4NDc+d7FqmS8NyWuW5dY8JvhV5wUZY7TlW8z8ogaB
	fzFXamJqLvvvYq4XRUhzms6eV0JfLOUGgVX0rq0tliet/60/kRs2wcwIDM8gUgBO2xXkm1CoxmD
	C8+sE1rt709DN3B5d3IGcWpjSiuvSYtbuPYKZ0QKfcN04wbIMZ93P/ms6y29nTOmd1h3ef8CcMw
	2mX80hFBhS0rbS/IlW08c7uHdDo6QuAcJ3VArlDpgTpJln/Exj6VFI+IkmOV7mPGrmef3gu6Ot8
	tq+IyLvQzHTtAKC4iwJmVQhWM+w1X22L78Sc1AwwFEdHbWOcH2IH48hpVwoBVpLhlzFM/L76EEh
	WyCc0bKbacFlBVTnHmZhOyV/vHA4/zvpP5luOO5fc70ctyEX+6gwK0H4QjW6jHpak9DTUB67W+J
	axCzwnN5lRVmA76lnqtdvmLjzhahK+HCUWStvz1vMugH8N
X-Google-Smtp-Source: AGHT+IEgOA0/a6B77dCuTQnCdZXbZikCeOm1NYByQGossxUkCBmPTXJQBtJah4Ps9oYiD64ephxmcQ==
X-Received: by 2002:a05:6830:25d4:b0:7c7:591a:7e91 with SMTP id 46e09a7af769-7cc668a4bd5mr1727231a34.7.1766147842443;
        Fri, 19 Dec 2025 04:37:22 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:7cbc:db2c:ec63:19af])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc667ebe98sm1571289a34.21.2025.12.19.04.37.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Dec 2025 04:37:21 -0800 (PST)
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: John Groves <John@Groves.net>,
	John Groves <jgroves@micron.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Balbir Singh <bsingharora@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	John Groves <john@groves.net>
Subject: [PATCH V2] mm/memremap: fix spurious large folio warning for FS-DAX
Date: Fri, 19 Dec 2025 06:37:17 -0600
Message-ID: <20251219123717.39330-1-john@groves.net>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A4A09C0012
X-Rspamd-Server: rspam04
X-Stat-Signature: sw9cfmn13khgwn568iqian7ndxr7pxd5
X-HE-Tag: 1766147843-20025
X-HE-Meta: U2FsdGVkX18HM65V9AaTvI8+ZzoTQryjzB3ZyCJpnozCujaeQSShRSWcPJ26q6XUTuga2qYP7qnTPC+sS+cQvlgDBT+pTWYsY2CpXyU+DVg94iFcyuv1yjyGWE88kIEXD3VP+HPY59TAbCDhhtCAKWk8YP0G+IhaxyAyMd1ebFc3aVoecwITuaHknj6EPLu+eFIlTnBauUpvaw28hKFSXTc+mNj+eN8H54sWqPGTziO0ccWbdbk2/prTWDHHXe5zF1cmvQU2EnxXzPrzDs0nsNouibq34TXtb2qN38Ben8rvg+8ucg2KS4A4jMmIknyh6LW3KDm4URmvTwKgCWBVrxEqoFjqVmqhdy1LAA0oeuiRW9Bt3z6lJbcYZ5yjNbzkmZp7jcI88GSr4UGUt7UHDwQ3t34hZm7hIgu+mE1debpbvMs4EV/ULzNOVIz291hWTutpZl4MkK3knqKRV+PJISeLvjqcJ+9MUulx+QPWe+ntvDU4br98jIqvXGS1zO4HedA++A9QybRrj7ZnjARhB1+SH/cPYHPou/zDVNF9hZRuXqTzi2QKwK/zibo/haJ/0CAzWGDVeujJJdOaRzBpx0DCThaMULC83EAXvyLyDPnp+eYG0AMBZanUDFdOwRf1CM8LZux4dfsq9ZDMWmI7KUVOhusYgCP6tD3ayKa9VlqS/c6uy8IFQV5U7uYCQsrv2gZfEkQzXs075lBNtAedLj9lJKd/mPfaUcmxEkY44jHgkgWhe7vUcXegjt4XEK6Ejc0Jyf4WBhcWZTGgzLucDYNVyjyjfIyWVGg69hYeQqTunMyiSJkFDLzJIFd35lMNZrwGxcvre0iy0SukhchluQVIwRPOqYt+X1NM1MMIlamXyrQ/vVB0IZ6LHB7ePU7JgJikF9q2Ogp1u/Ai0AZ65eNy8jcNKEqMBQc9+NywfsofGGlrdruwdm2l+UJoRF8C3K9hgMY/qIQqUVkxwjo
 N2iyBvRy
 eNDBDKRb3lDL49mLaUca7ulMxpmGNGr5dS2MP9kcxHKod+807vz12xFx6+fGxaODDB5fC21G1XVgVefMqDa6ShUN9ByWV1yJEQec6XEqi7XpGZvIVIbgXiTa/3pfMqtUhjjq3+dNG4WVHeTtuk2iSglgqHR+c2zjAnAsGSSo/3MCFcQEfYfQrMf++akCfkjt/OKsu8Q+BRHpmQ7adQN29Ra3knE7XBNQUKgd2XeWzNrxWNaOLMD5oMj/FQPW7QQeh97UkvuPANFPWVKFgy/tByQEmzQgk1rt2G+ndH/oONS6uEG7knzeEYEl9IrOOqOb+HZhHYtX4VIWO8rvF1nMjexSuU9UPHIcWtqOpCNqVRkL0wItcPNscAKTtO5bfto04NFmI0IMtM44o4xZzZgQmTZ1FA5uJBJshTUThvmXuUlGXLhP32r9T3yl9k6iaMQP2GaoE9R5HDlzSnDPnbu+luC5Qm9aHHxD7cnB1g7ms/gqquiT3/sY5UlcyxHJIYdM19LUMp4Yh/5aijYFq4PMhusE/63PF94+/7L8c8VL7jgw3PKQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: John Groves <John@Groves.net>

This patch addresses a warning that I discovered while working on famfs,
which is an fs-dax file system that virtually always does PMD faults
(next famfs patch series coming after the holidays).

However, XFS also does PMD faults in fs-dax mode, and it also triggers
the warning. It takes some effort to get XFS to do a PMD fault, but
instructions to reproduce it are below.

The VM_WARN_ON_ONCE(folio_test_large(folio)) check in
free_zone_device_folio() incorrectly triggers for MEMORY_DEVICE_FS_DAX
when PMD (2MB) mappings are used.

FS-DAX legitimately creates large file-backed folios when handling PMD
faults. This is a core feature of FS-DAX that provides significant
performance benefits by mapping 2MB regions directly to persistent
memory. When these mappings are unmapped, the large folios are freed
through free_zone_device_folio(), which triggers the spurious warning.

The warning was introduced by commit that added support for large zone
device private folios. However, that commit did not account for FS-DAX
file-backed folios, which have always supported large (PMD-sized)
mappings.

The check distinguishes between anonymous folios (which clear
AnonExclusive flags for each sub-page) and file-backed folios. For
file-backed folios, it assumes large folios are unexpected - but this
assumption is incorrect for FS-DAX.

The fix is to exempt MEMORY_DEVICE_FS_DAX from the large folio warning,
allowing FS-DAX to continue using PMD mappings without triggering false
warnings.

Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: John Groves <john@groves.net>
---

Change since V1: Deleted the warning altogether, rather than exempting
fs-dax.

=== How to reproduce ===

A reproducer is available at:

    git clone https://github.com/jagalactic/dax-pmd-test.git
    cd xfs-dax-test
    make
    sudo make test

This will set up XFS on pmem with 2MB stripe alignment and run a test
that triggers the warning.

Alternatively, follow the manual steps below.

Prerequisites:
  - Linux kernel with FS-DAX support and CONFIG_DEBUG_VM=y
  - A pmem device (real or emulated)
  - An fsdax namespace configured via ndctl as /dev/pmem0

Manual steps:

1. Create an fsdax namespace (if not already present):
   # ndctl create-namespace -m fsdax -e namespace0.0

2. Create XFS with 2MB stripe alignment:
   # mkfs.xfs -f -d su=2m,sw=1 /dev/pmem0
   # mount -o dax /dev/pmem0 /mnt/pmem

3. Compile and run the reproducer:
   # gcc -Wall -O2 -o dax_pmd_test dax_pmd_test.c
   # ./dax_pmd_test /mnt/pmem/testfile

4. Check dmesg for the warning:
   WARNING: mm/memremap.c:431 at free_zone_device_folio+0x.../0x...

Note: The 2MB stripe alignment (-d su=2m,sw=1) is critical. XFS normally
allocates blocks at arbitrary offsets, causing PMD faults to fall back
to PTE faults. The stripe alignment forces 2MB-aligned allocations,
allowing PMD faults to succeed and exposing this bug.


 mm/memremap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memremap.c b/mm/memremap.c
index 4c2e0d68eb27..63c6ab4fdf08 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -427,8 +427,6 @@ void free_zone_device_folio(struct folio *folio)
 	if (folio_test_anon(folio)) {
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
-	} else {
-		VM_WARN_ON_ONCE(folio_test_large(folio));
 	}
 
 	/*

base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
-- 
2.49.0


