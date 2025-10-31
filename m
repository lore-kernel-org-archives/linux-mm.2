Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D875FCCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:48:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7718E0126; Fri, 31 Oct 2025 13:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 141008E0121; Fri, 31 Oct 2025 13:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E1D8E0126; Fri, 31 Oct 2025 13:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EAA5D8E0121
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:48:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B6894A4BD
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:35 +0000 (UTC)
X-FDA: 84059144190.04.D3DC980
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id B2A1F1C0008
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LXeiT/2b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761932913; a=rsa-sha256;
	cv=none;
	b=AvOERga02tmx+DsenMrflUIV5e+jUR8iOnRhpIaRe/+ZzCFnQ85zUFG/M7is95hrQ/3hp6
	LHpLudkREYWLEA8MaSDq7GXnGWLCCMW5Wv/JEkAtl8Me3eHJCRUWw7lwqBT7hgdJAMgOne
	qBNq3ssLysbUlE1LvgCAMv29h0piqk0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="LXeiT/2b";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761932913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=098F261HYE62bz4EbLCakXKNMD6yEDzP+rbKPhuk2BI=;
	b=NjOFpynfUNb99hctv2KKUQ6kbvbnrVs6tOQsBJqjIMimOjthj1Prm2Kj+R1CDexacRF4WV
	7PLJiQNeq4S8H7yVgRevnNBNT+sV/qWcawCIyEklUsy8sCOTQaa3I5Ur1t7zB0KFJ1wez0
	sexfW2BPYEkjigrGS7XyzhuYaOsYp94=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29509084e3bso16961935ad.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761932912; x=1762537712; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=098F261HYE62bz4EbLCakXKNMD6yEDzP+rbKPhuk2BI=;
        b=LXeiT/2bGVf4/g6SZeGacPp+PdtSFXodOTGS5EHBr1ZZ1z8VrTnjQg5IktANaltB+a
         XAYOKwXVUOfodzsyZm17R55DS2sq7VL7IX6LqKy+gbpmctbraJu8jHM/jpFqm16NCPwz
         6Y9g/+r/LynuWfBaxAldDv7AA3tadS4L9ThzhhcSADaISWR9saXG+VgZBJMzeIz5la+T
         1kwvxA6aQQe8M2poapmWeR50oo4SMEYteCWJl2VI6ynv+4/GLcwaWSnf00qQW3tvLVRh
         vIHHyhsP+4/bEA+L/E7B95OJciBUWSg95J2iIukeQTmoWKbWqp8UkqWIlH5IRHs81LSI
         9kag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761932912; x=1762537712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=098F261HYE62bz4EbLCakXKNMD6yEDzP+rbKPhuk2BI=;
        b=eCtJzZaa9FSPKcmGRqiCK41KEzHznmVSvq3Qt6BNNT5WBAXRcZQZipNiBDqL4U0NhL
         XLjvb3IttDSryyd5pPyNuuSfS0yq0NgYWKXJ9MCwG/8gBhvvPKTCgzTfQUTZ7WrlqYlV
         BrwXZUNgKhP44YIkWdG22viDcjSWtYJyr5CLIJwftHchN85D6IopWw2K0IZObME8WROa
         c6zy0uuPdzIYqCIHNIznwXpfD3FquafL5xZ6DfqrWr4zayG+xW8qhyp5QZGT95T5niK3
         etELySQd2rc0iHaiC5QF04OhDBlVRpjp5QGtKZV8BP9UwapB+h4aG0OkpcXJJ8j+Ogca
         6bBA==
X-Forwarded-Encrypted: i=1; AJvYcCXkZpEHXF7ASKG5llfsCZndE5bZyEzBubsyodjbcwdCqOn/lt2I9cXpMmUeodclZLg2BavKkzlLsg==@kvack.org
X-Gm-Message-State: AOJu0YwN49rQ4PFnqV3pvKfa7RnC+fDNVebHKaJ3/Ab94kvGJv8rviFI
	5JU+QeUsxQ5b4jd67tLBjMiMFZSmxDtRVgLev2i/o5RyR+6Wh4S85D4s
X-Gm-Gg: ASbGncvxrQLKaqA7TJwJoqv7saOgyC2gacU/A96Dc1DVQgjdkOe+sJHkCwmtxS8P8MU
	gz8OZ1Or4m571bJNbKlGtlXzZiRrKq4PO6jgomvuilO9XPgMJFh6FD/71li8rqrNZCESU/IwIoB
	9VHZdQIZUovR4TmEsB70t5jrHJNQ3BtDcrj6/3GBizzpSwfYg05lR4mUusuXY3RYhpM69xtr8Zf
	iOAxB9E7EVm8o7OJLLYUfZfL4DhH5n4A126RtEwk2UHM0gxu05vPGubtJSHUdtA8cRGJaLPhVl+
	BWFAmlqPOxHu0EVhNhKC2J8O++rjiwvXIX0LKdTmDhFmKs3x88H2wKCWmKV+x5t3+b/raLEno2/
	0o6lQd2JNAlwaUoVjwQ1nOHksQO6onKH6UQAqYJsLmIt9oYtp3tfXPPXs1tdT+Lam2PteYcwQnT
	6RWWWY54Y/HkMCto2k6onrNd4GtzFZxRYmm4o=
X-Google-Smtp-Source: AGHT+IE5ZC1i8KnkDoMeuHdmVM+WBof0Tvfw9Q+Bnfn74KlqAm8f7TNwkIf30NrJPjEKzPvI2EG3Fg==
X-Received: by 2002:a17:902:f60d:b0:295:28a4:f0ba with SMTP id d9443c01a7336-29528a4f69cmr30095965ad.14.1761932912206;
        Fri, 31 Oct 2025 10:48:32 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29526871693sm30113185ad.20.2025.10.31.10.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 10:48:31 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v2 0/3] ksm: perform a range-walk to jump over holes in break_ksm
Date: Fri, 31 Oct 2025 14:46:22 -0300
Message-ID: <20251031174625.127417-1-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f6d3gyfm9brcwmn6zu4bzw1jg4qoziqe
X-Rspamd-Queue-Id: B2A1F1C0008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761932913-996153
X-HE-Meta: U2FsdGVkX1/WBhlrvUcluDTkcPURG5R1w67o0WQ6Hr99Tdb43Ud0Bx2rYNJQD4dNI6N47/LH/dr9vN3w3AeBa9VyPwM4n7HRNkl/c7IPyYCNX7RxLLZmgE1Ex3tJQkjTisTARhU+EIM3zKpfn+Qadw4SP9r3FsbuFpbNUI18zNReWiq5T+Zf2n2LXZVZShBmWUq+BO3d8x5IUkXomHqRH0qnu2O2e8i8rwm+Kcck28DUdx4XBjDYcDg0zuGzVGqwusKTigY7vH9cTZKicMDUtDZu/o9ObFE9oB70Ue+w3LhFemCw8zgvQ3nQdkJkS/2WO4uh4/ALsEHwLL04SslNxpdrcJRiuJDaRWt3QXlWtMk5sTDpS3TIl4E52VGQeE5GgLrlwe8gbqcAgkSn6reRL58XQUyhMzpiKxEEpVBS57LVStdDV0/llpDHIw1nbsGqbwMlquTERnjSFMVbMbnqOd3pKsKTcimg3WVf5KnArtchMbRAuAHC7b4SlGiUX0FTyoKyKuJJp/xXWYrI8FdsIWoIarwEF7efNQ+Z3gLEiNzXmrRsZIQZGdedmot6M0rZujBo5Dahi6jIDMxx77NSzLON9ynHTrWwnu+NlWYbERVYQELNtv2wx9MvT+l69DwPXaSxhkNwPg1zZsJJ41UEkH5qHRdalNrY8uOmPl14nSVnGzrSdHMpH065PZWnaXvIWdCkoW0AujbUunZ7cLfZhKf8izq1p4bP72pqW+C8G2Dzy92V5PEd2f7Ak7kIagNm15EXydFrKzF1aIXzZHJTzZT+4H7BWw1gBIpVg5MIPDnuUe9Hk9O3Y58aunf/9E68Bi7gP6pXuOr2gXKx4smU4QWNY7aKN1hbKex0abis2aiiZFnHviH58KlXpG1dzQgnxV/2viHzR68O7EuPIuIuVkkomjjGGG4HJVRIGQBCR1IsbtAhoOa8Cn5qk9d9TrQvfOSTWgxH5D8dCjfmD09
 1n8+tCKO
 mVQ2+9qMBT2LBVgxmc6KrMfscV829HXz/VYIfeggO95INRGdT+2KGYhK/Di2MdMz34g37zqB9uF4dF7uU49WplFvyuo7k09WyU3945bFtfUNbtkKH6bFuJc9vwfUSzzN+x+e8F1HtjKjVDNGfeM3gVz9PTeTD1jPP/b5LbWH6elQ+ktzAdiMVU+mIeRzC07A5DncUiHy5P6KrwlFqPKEP7v9gO/gP+8N2ahTChcFIg/mkAFbZZLuf2SHQmP3xNKSlAeYrw3oT0JI64CNJRnV02agW/157FjVIXjyZOIsEWjmTwhGmfdpgQ6ipEnLQ5ztaKw3dnM9HtqF/zMwPk9h3Yz+LaUtWldvX/WzWt+OKrJ04E5L/ZpWtOSFGwkWOJSXFQYKxl0GhFwH9/MERHG5GZW/3678dd3shNAbRVabRL6VW3+HiZsRRegsmZQpkKzB3VQK8Q/J6Kylb31qnMOEHH3KTrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When unmerging an address range, unmerge_ksm_pages function walks every
page address in the specified range to locate ksm pages. This becomes
highly inefficient when scanning large virtual memory areas that contain
mostly unmapped regions, causing the process to get blocked for several
minutes.

This patch makes break_ksm, function called by unmerge_ksm_pages for
every page in an address range, perform a range walk, allowing it to skip
over entire unmapped holes in a VMA, avoiding unnecessary lookups.

As pointed by David Hildenbrand in [1], unmerge_ksm_pages() is called
from:

* ksm_madvise() through madvise(MADV_UNMERGEABLE). There are not a lot
of users of that function.

* __ksm_del_vma() through ksm_del_vmas(). Effectively called when
disabling KSM for a process either through the sysctl or from s390x gmap
code when enabling storage keys for a VM.

Consider the following test program which creates a 32 TiB mapping in
the virtual address space but only populates a single page:

#include <unistd.h>
#include <stdio.h>
#include <sys/mman.h>

/* 32 TiB */
const size_t size = 32ul * 1024 * 1024 * 1024 * 1024;

int main() {
        char *area = mmap(NULL, size, PROT_READ | PROT_WRITE,
                          MAP_NORESERVE | MAP_PRIVATE | MAP_ANON, -1, 0);

        if (area == MAP_FAILED) {
                perror("mmap() failed\n");
                return -1;
        }

        /* Populate a single page such that we get an anon_vma. */
        *area = 0;

        /* Enable KSM. */
        madvise(area, size, MADV_MERGEABLE);
        madvise(area, size, MADV_UNMERGEABLE);
        return 0;
}


Without this patch, this program takes 9 minutes to finish, while with
this patch it finishes in less then 5 seconds.

[1] https://lore.kernel.org/linux-mm/e0886fdf-d198-4130-bd9a-be276c59da37@redhat.com/

Changelog:

v2:
  - Use folios in break_ksm_pmd_entry
  - Pass address pointer to walk_page_range_vma private parameter
    instead of struct break_ksm_arg
  - Do not unnecessarily initialize start_ptep
  - Order local variable declarations from longest to shortest line
  - Improve patch 2 description (do not reference the cover letter)
  - Quite a few styling fixes and improvements as suggested by reviewer

v1: https://lore.kernel.org/all/20251028131945.26445-1-pedrodemargomes@gmail.com/

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>

Pedro Demarchi Gomes (3):
  Revert "mm/ksm: convert break_ksm() from walk_page_range_vma() to
    folio_walk"
  ksm: perform a range-walk in break_ksm
  ksm: replace function unmerge_ksm_pages with break_ksm

 mm/ksm.c | 141 +++++++++++++++++++++++++++++++++----------------------
 1 file changed, 86 insertions(+), 55 deletions(-)

-- 
2.43.0


