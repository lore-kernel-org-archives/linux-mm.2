Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4D0C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 04:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26F36B008C; Fri, 25 Sep 2026 00:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7EE6B0092; Fri, 25 Sep 2026 00:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8B66B0093; Fri, 25 Sep 2026 00:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80C836B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 00:29:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA466A6965
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:29:17 +0000 (UTC)
X-FDA: 85251005154.25.32D9EBF
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3408D40009
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:29:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SmkNtJRE;
	spf=pass (imf01.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790310556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yf3h+E5l7lZ9xnH7vca0oSG6Rr+EZJjVtHwLxzVwIUM=;
	b=etv2l00ZesH9q0WT3SjT437z19Hret2WZlbSjpBQXUDcP0NHBIAKcuIAEGK3+GW4MX4pLE
	yJaNyLM0+iKfbkruJZK6G6d5YzpnvVdMCsJHbQB9r1w9Dkpzj1ufoL/r+iHtxD7Y7NvEAz
	1n5A/bZ7gyvRyR5b5tSsgFhe01i2o0c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SmkNtJRE;
	spf=pass (imf01.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790310556;
	b=MjteaHCoYj/U+WRbIfl5+qlYyv4jMKeMcmXGft0dTrnTHOCQ9rS1tf5xz0I7cExhJEpnnq
	xBoWqz6TRvPosCB5bih7SQF/qgBlBfnU5MP2CXDSmUNdHIA2uZALduTH2Pa4DoePA1tWJW
	C6VinAH608rO/9ZoSPO8TcodnVNamao=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b43b20bso1626365ad.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790310555; x=1790915355; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yf3h+E5l7lZ9xnH7vca0oSG6Rr+EZJjVtHwLxzVwIUM=;
        b=SmkNtJREEt0DMuY3Oqpigk9BeZt6pEkcJ4VHW9+giU4/kr7ln/1/NoDM1uhv+P8zyi
         De+FRKFtU29B35MC6sWBFndbo3DCqay6FOFQII6kwHt2ZODdGzaA1OzxB4jrL7XVE2vm
         rqa7JlnjTSSVNBKwhVEVnhy2LzB+GH9/AZQSKIvl8yBnaejplzRHWylkixMUjQT+5Qt0
         Ftf+Vc1CwOBKb73yWjOmjvKbuvngtxsp8nV3utybA03pg7WpuBtOXxsFkJh6jeSrwWLH
         +R57JDaPY34Owq9ErIi4W85sLYAQsBKw3YRDREm53wrV3xlhEW0mqGQylOd5CDAnuIKJ
         KTiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790310555; x=1790915355;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yf3h+E5l7lZ9xnH7vca0oSG6Rr+EZJjVtHwLxzVwIUM=;
        b=RGbEeCf83EgtcEHkLQn6329Jzy8BqQlBrLpSsgHBSJfSXlXaCk481WlL+qcADABi5/
         pYXMNY+pk2bDGw4G04TtLGAgTKz8Nb56bpadjQSlw4MpdTRPs35D0VTnNDJg533OIRtN
         gKdcTcUXsO2yMSck9xlQNMW8iMvkSOIW12FFuOhoEDCsqQxUF4rjpTtHyYtGQ4lLy16e
         xILTUTet+NGmc/5eYdePaqHigthhM9bfnXHamWG5fTWHIqClHyvXVgdTiMDDvaWfaVGB
         JwlU74GIvF4C6Dh+7Lm4i2R5ayYbrGRGtGI8fklMIZXS66jR2S8R0cdodtHXvYPSjUiu
         H+vw==
X-Forwarded-Encrypted: i=1; AKwUvBzAujwkxVBj4yrUZbGM7zIwp44gMd7jD9K88iv2sxoxhWaAhXWRFAi5Wx5c2ZlErdKLoMIeY8TJMg==@kvack.org
X-Gm-Message-State: AFuF++niNjduqzigCAi9a2ADslu3M+wkUhDTHlWd7nOMtWajF1GEV/6g
	px84EETKRjPpHGQmhI0ocuYWIxEuY1sG6pzRiqbj0n92+kEsSx0Q8Yw=
X-Gm-Gg: AYBFou1kjbGl/iyMZotDRLDRR5zQaXHawnvrUyrRXCKEb7/N/iLzN/WlR64ISsRkoxW
	83KeG1jdJeIOPdho+GbLa6C8hegjOhvkblMx4c3dWoamldd0TNZ+Sy9hmQfvyVPIfdo1XJGXlpa
	vBvUYF7cApunOMBK3q+YljScqUT8UyFbRMuPomFriMA6t5jGbMi8khBHpntu45wNEtLDRyAROIU
	3h7uSEof8xkNmCHo3c8Xj6TiGmxg0Jwd9UdBeXUhtj9YfiUQpfZGlNAlFX5Z7NAo+2rUU4noLIc
	rG8bQUFtAmEJo257M3eePWlTM5+6kaWCTh+tQk68c54oCQi9HmY2sGqxdW4LA5lfhDUogEgQhwf
	YIrXHVP3bAdsxkHM+X0Xgpnp5CaOUZb31GYHeAZIa7/4zBmJ6bwyA07qNHjbuoTMQfw1XrEDo0i
	ga4eK7FLSQpwl30pAtPVUW+PxLEaQsb5zfNl0IhVHjlPxsw27I4UXt0qXPYyWpQEXn5d7ChvGS0
	boAXJCGlQNI4Zgb1WHiU/H2mxutSMyLgus=
X-Received: by 2002:a17:902:f549:b0:2dd:c100:424c with SMTP id d9443c01a7336-2df7e247b6fmr40036125ad.48.1790310553531;
        Thu, 24 Sep 2026 21:29:13 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9525cd53sm2499125ad.38.2026.09.24.21.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 21:29:12 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kirill@shutemov.name,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com
Subject: [PATCH v2 0/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Fri, 25 Sep 2026 13:29:05 +0900
Message-ID: <20260925042907.2330519-1-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3408D40009
X-Stat-Signature: eg5u5j5p6d15qissu3sjz53ywmcjazan
X-HE-Tag: 1790310556-868375
X-HE-Meta: U2FsdGVkX1+bhvJBPLwyVUMqyptEAiXhywv3uQIZcWkQPob3Js6kDy7bvWkl3sQOLFDd8G+aEp4qZStFfo5gwim2epHUWF6mDfR5qkWPL09RyVDKqXBKse7O1V/G9lLVj5vnJgu+Z/HUHWAXT2b5XfECzJ8w/VlGK74KB5B3mmi3GiABplpdxQPYTjh9WXZ4GZHNelFeK3HxCHy5X19sxqPcx92PoyUP5ytCBdNZsBfFjSvaLRJZftFdYxKLaTYZ0Fu+jgMpTNc+TfYP29KFFce1zO9NG5BIwROb/izwH8APrNfasZCL6/OUe0dUUyIB9A3+Ygaf1IUGhfagHA8hJmOAqO1Z3O803UiOoOh/grzyv5KwJEpDNG5VrrKa+XSl/ec+/ZBKT8xRNmvaScQX7cRx1ejNWs61vGAn7Aqu4Ipqy0F7q7cdSx8W4rSERwWZY64FWR48KekSqacFY/6KM9b7MJWiSp0Gx6Js09C4yxDVg3hki8r8StvyWDDczkTNxDF1yp79nwXqD/EqThAHhDRj044ZZTsETKgcgqTy3UQz0gkgC6meZ0BLOcldbQadiqlnNN6sdp5y8p0lMTZNqyOa/L264sZB7ez1Q8cSIF6fckUMgWz5nOwSf0anXGnPFTNp8U8In88ACZLow10QwBnXTJPjpsrU1ZedQwSyyb7pthMfp+G+CW2YszHO0Q0+jE/JJgc8Aqf4loPiz+/LfGB5NGfX1/q83sbk00BWaX8U+Ogwm0Hf4cKleKa/ESnYwMO5xnIu92/1ezG+4QigLWiFERVGBOmJ9YIRivd3BTaZk53trS29VrcpAlYDCWSkq9qIpMzaHhmpdSpy6wkHYQLHsGlPKtiMzmVzOoJnIAeG12I07NxNqacQgiwTjfYu8Jh0AztWXXayEcTDZrex2ixebmDjcaUIqyfY196GMQCqVhqRi3MoAXw4kjVPsfckzNdOpMJQ3RppaGFpos5
 61vSDRQ3
 PVnLCHTwq66oreT7xvAyM5qnznn0GWnq3MzdyRCqDwllZJYo9b3FBHqmgrsOJPSA12LudY/jjRCCMihLLiKvGEcbO6YX7FdVMR8fm6Z4QaRlHLfoX+VQ1LffGBrRYcN4DKEdv4IM+YorPOxpN/A0dEIYQAo2pwNGxDnSOGDtxNVxvQbR+pftea4MfusorrqGYKsPDFYTHr+V8fFewuw9iRaciONijdR4zcvXY5y6oom/q0fKViDf4OZbj7xUU3wrGjhVYFYS18q1RId8ADlrp9e8QdYbm+PtfKJSe2H1Ged8sxGmsv1Wep1LkOYCe5NfDyvGiKZ/sYuA3JysqfM+ZbVnNQEiRav3R4XW1P0OE79w88onSTH5OSKjN6E2gtHxms5I/qGTQjBxFDwAiPX+Z6O1sRxwDD0PTp6Wq1F2JZ8jZcIJ9RBbkY5dlPx+Xadg6pxgKXrhzj6KKeqnIQZgVwwKb4UTr2evw1Rb7Niw+irUDFp7kM0/dGEGIfXIZfWobrvo5hvQkOS8kOp9yUzwa+HGf9rIGGaSoMVKVzPGj2ALH4V45RyedqOWbLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on the source lands in a
destination VMA that was never registered for write protection, and
nothing clears it afterwards.  Patch 1 clears the bit unless the
destination is RWP-registered, which is what the present-page and
zeropage move paths already do.  Patch 2 adds the test that catches it.

v1: https://lore.kernel.org/all/20260919004630.1159895-1-donggeunyoo.kernel@gmail.com/

Changes in v2:
 - patch 1: clear the bit unconditionally (Kiryl Shutsemau)
 - patch 1: rewrite the changelog for readability (Mike Rapoport)
 - add Assisted-by: LLM (Mike Rapoport)

x86_64 defconfig plus USERFAULTFD, TRANSPARENT_HUGEPAGE, GUP_TEST and a
swap device, under QEMU, base 17e7b8eacf4c:

  uffd-unit-tests                    before   after
  move-swap-wp on anon               not ok   ok
  the other 114 unit tests           ok       ok
  uffd-wp-mremap, 38 tests           ok       ok

  pagemap bit 57 at the destination  before   after
  swapped page, dst not armed        set      clear
  swapped page, dst WP-armed         set      clear
  swapped page, dst RWP-armed        set      set
  resident page, dst WP-armed        clear    clear

  MADV_COLLAPSE over 2 MB at dst     EINVAL   0

Donggeun Yoo (2):
  userfaultfd: clear the inherited uffd bit in move_swap_pte()
  selftests/mm: add a test for UFFDIO_MOVE of a write-protected swap
    entry

 mm/userfaultfd.c                             |  1 +
 tools/testing/selftests/mm/uffd-unit-tests.c | 61 ++++++++++++++++++++
 2 files changed, 62 insertions(+)

-- 
2.53.0


