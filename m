Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA6CBD637A4
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 20:09:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5A56B0088; Tue, 16 Dec 2025 15:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DA06B0089; Tue, 16 Dec 2025 15:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8CC6B008A; Tue, 16 Dec 2025 15:09:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC0086B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:09:44 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7B2951607CB
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:09:44 +0000 (UTC)
X-FDA: 84226424688.02.26F3C90
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id B0A4F100006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 20:09:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S6w/oXXL";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=bijan311@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765915782; a=rsa-sha256;
	cv=none;
	b=DjNBTrvnudLnR/eDXyj4H2Xt042ozlinrNTVCPlNgy10Oa7ioAcFndgoK3iRhdSHyAtbPz
	1KRepdFxhTAeZUCK/Q0+yGC0Kuf6pqoxBLjTzXggNkZ88FZ2ZpFpRG+PuyMCx7cUGKvmPd
	qwXsnwR9DT7lgMG0fqWwSvcXewPSUCs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="S6w/oXXL";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of bijan311@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=bijan311@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765915782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nMS6a3jAyVimHierhPrk+dmchPtXev21lxjws8o9I7U=;
	b=gDr89fx+HFih2ZGz2OxFnwlS5eIqDxDVkOGCkdZoITT+rJrB/eKphqsIF9h3wa2hAFW+z7
	W1efQ4qRK6dF0Gqsp6sZg/6RQxl08wgOypevakVa8DnjoBOUX9JQdqE3EJZT7ybz42fSH/
	TR1B3OG7gicSzF/Zo+KIJEGq7ZlVyGk=
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-787df0d729dso42220307b3.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 12:09:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765915781; x=1766520581; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nMS6a3jAyVimHierhPrk+dmchPtXev21lxjws8o9I7U=;
        b=S6w/oXXLu4rc5KrGJmfgPMU+Ga6M0IDuKZIG7fFILNzxtAQlD+UkvFj/w9MTiNfjZF
         PeKsVHCvT5D3ZKrgK913gCGPCWwu2jigTWfGuBaAdEAI2s3nFIrrjcSvG2uOzvmpd2dN
         PXdcLSWH5fG4oy4quXbMApEKCJrHSycuFo10bUINHJRHNNmSLSRdPzptUr0gDL4eitYy
         X8/2wYQl8I3G8xvuXjipIn9EmuXphVo7ED5rUYAsf84M/NEgIjnfhxvTH1vQ8lMOghAs
         Tmx41A65W6BLVay6lj54Ci97/fR3dp76qfwH0bhJVtSPVkdchmB6oPAF8g7u2YZrr/Fg
         9XDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765915781; x=1766520581;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMS6a3jAyVimHierhPrk+dmchPtXev21lxjws8o9I7U=;
        b=MDzhfiYz1PnFWMOESIFuMEA/br6TJI5q+0AMCgNdv56MK4Gy4Dn8nd5EDbOMtkS0Xm
         lm+h95c1dSuP41jDq5GCnaEHg83s2+g0/Z3WqfeuYGSwDbdXp7rWQRxLUuu+2kYQHPp/
         EakpdHnXGaSnUpjIWlnAlgNzclEPdPH5k6ZG/M7nIcSuPoAua4hT7F5vaMuvXaPWsqhU
         MXlNzLscN3GV98bTtrD75WbSNLSeQeoZLfWbvtTy3YyADSh7ZAt6Af75OYUGT/XyR0Na
         36DDAUPE6Viucan4pbLI6l++OkwE9bNG1N2R4pBMD6hTRnqCSYDUcsvosMUs0502CpJR
         B8Dw==
X-Gm-Message-State: AOJu0Yx/JY0gCJsP4OkFPMxgl8kFFWXF+Wbjh4VeGb8G2VwYX3xkIlKy
	U3ctq6Bd+Rfshp0rGHcYT988nqRKhfxMmxLKnx+T+4SGenXefh6QnwQeBX5GUQ==
X-Gm-Gg: AY/fxX7CfJeGvQTVTcg2gAyGSjQfUDuoat+p+9GO2PNQO1FUMfzA+midRD++O2Fu9i9
	azDXIQ4IjeHoTwEa7AK1DpcA0wyuHhwxS+TVhbeP8zQSO3eRffc/pPQY36fBWrNqYwc4GK3oolD
	kRj9rHzzQXkVS8Tn5t99wg3WdB3t226kbd99j5J4MOhhTkqmyOnBKbSTcvPsxtZ3KIrwFoyJlmS
	EpW7m1j1eNRbz1us5MSzamJgMFLijadqVXnqjoXS92QFR4k17gzrp3XgREA3VFVnW9JeC+0woV7
	0U+VS4bQxUKLVgufkCAuvAqBnc1Lwg0O9E86rylH693F8b/aDva90rAZqeu2RS5X3WwrTCHO7d4
	v6f6H6Qj3hpeDB/1CjFF6aOJqyt7DwBE7AjwLlpYB4hAooAFjuZfjyVSLaahkCq5DSDZLtVLF5e
	knQclk8kG+u2EkFW3yLNjr3opbTgCUG5wvsVSRCRji23bj
X-Google-Smtp-Source: AGHT+IE1rNltaFw15QKa77QeIDdymJ4q3ZBePGvgojJXsNzIzp4mSRCbWloz3h5stjEdm8mcjMlo5g==
X-Received: by 2002:a05:690c:885:b0:786:8ce9:3b55 with SMTP id 00721157ae682-78e66ce7049mr114466567b3.5.1765915781146;
        Tue, 16 Dec 2025 12:09:41 -0800 (PST)
Received: from manaslu.cs.wisc.edu (manaslu.cs.wisc.edu. [128.105.15.4])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e748ef9e3sm42652317b3.17.2025.12.16.12.09.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 12:09:40 -0800 (PST)
From: Bijan Tabatabai <bijan311@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shivankg@amd.com,
	Bijan Tabatabai <bijan311@gmail.com>
Subject: [PATCH] mm: Consider non-anon swap cache folios in folio_expected_ref_count()
Date: Tue, 16 Dec 2025 14:07:27 -0600
Message-Id: <20251216200727.2360228-1-bijan311@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0A4F100006
X-Stat-Signature: hq6mkwnezy551x5t6rdxkuocgwfzdmfm
X-Rspam-User: 
X-HE-Tag: 1765915782-788979
X-HE-Meta: U2FsdGVkX19411QieauaDEYWDDZMjF+IQ3/IreOJlBv2PGe2DtFz6rdX+laPmJF2O4VZatuvu3sbc7b9p/LXLjLWvUiFDxOd1+eGJRzTvpkGuNPMTpOQMk0TEylun6vHP+/AKFhB2yBvHPs6igCUmEYD4s9Gk/jAyQbdSL87YQMtdgnc3J3pEnsPEzq9lCW//nUHw+0rngc3ahndIWWvUbMwVVQxW/RTKrMEAGQYHCXl7CQw6FtA2dkZjuOKA8LAIXQorITZgS1pF2E5VmYqmHVIRsicEC+NJiFxzQGw178qzfibxLLNajm/GQjpW7oIzMDGLGKoDmDYqHw+5095rJ5JEjfiLD9UVw10wfaDwWP+qVBarhN3zFNB3PTavvwmTvUugdFKtPoxvZm33tCiY7Ojfx/zXrgDvSTioFCVH61Za4l/LMhgYx8F0PGlg8pbS/cxDshNsmaQj1Cdw0x8mW6q/9HkRB3FGuqkqV7Ho8kNDzIB5bU+AnqZ5GcWBOaytnrAvV3HkiNUrhDU5rU0mtMu9BwnhMMcnou36DyJURSlBIRc/jS+L8Grn63DcC20LEmD6OfCFlttElRPiam+rWfoOLN+vzcruaxbdriRn+2iIiEDNvzYhmQUdpTS3+h9m2GZ+X5lrF9lvCNRVTSaeOONmVpmtZzpuhVSJ0qK4YSvZr8J4CgJKz9HtA2BkU0Rf2m1vu4cFwrD9fboLszMDkJLIG4UWdG0Ae4IwiTTJlVjmuOwLgbOfldg6ckyQ5Q0aaYG89iHi9EwcuEEGyyd/vrt4iHxLNW+xIa13hWgoswNimnlzD+h/TWpAfJUcqrRJFVNEYPh3xNxRaYpbzdEJz+kEnD5tCZyuEOyvfk/sjigwRzw15DzwQh2kx/dJX5hfg/nqaIkkC/1h6nOOM4VNaAjJQfJGEKP8DVLd26wrx7KV45aXGOsJOJ9WUwH7PTx9MKhQrDi4vLn4ta90HW
 OjyUmxPA
 CguAbwcGEFzn0VHupL4Q0QBStbqnV85+d+5AxwFZsHHHAAEINqflIZR08950hdE4cr2mL/PDrg+vIaHBdg+tx6IWRHYeaDv1uPva6HyL0kZtgTsF7S2gq/Sip9kyHh41e1DKhnLTxTNvAAwdo6MGypYmdXUmKOSmyzRbJ4fzZOYjfJ5q4qbPRNxzF0bx3SjrnVY+hIxB5FY6t9xZh+4y8cAbQ7tpbLbrpEjJ5XW52gNrdPLmyDFvDTQzB7TvLruyLjzj7/qaqrrDK0O2OX0DWvxaIoOei8n5niv+gTtDpzMLLyO0dbrpR527AH+MyLSL52Ghp3uuCQoWS4CFH7sR9IcoMN4WX2bGa8ANQaIaP/KB+rj6St6RbeYAfP8Pb7VxZJ14oH+a/H4r8KvP/DyKNk4sILHtzYgOMXgOQ6gicma9Stg1IA5/T7KFUHAiLv20grYJb7S520i3PmpdFj+RY9rkU+ywTYBwe1oqZTogi7eVmPoDk8N0gRaIeib5YI2GAKZHt4nTDgHtIc90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, folio_expected_ref_count() only adds references for the swap
cache if the folio is anonymous. However, according to the comment above
the definition of PG_swapcache in enum pageflags, shmem folios can also
have PG_swapcache set. This patch makes sure references for the swap
cache are added if folio_test_swapcache(folio) is true.

This issue was found when trying to hot-unplug memory in a QEMU/KVM
virtual machine. When initiating hot-unplug when most of the guest
memory is allocated, hot-unplug hangs partway through removal due to
migration failures. The following message would be printed several
times, and would be printed again about every five seconds:

[   49.641309] migrating pfn b12f25 failed ret:7
[   49.641310] page: refcount:2 mapcount:0 mapping:0000000033bd8fe2 index:0x7f404d925 pfn:0xb12f25
[   49.641311] aops:swap_aops
[   49.641313] flags: 0x300000000030508(uptodate|active|owner_priv_1|reclaim|swapbacked|node=0|zone=3)
[   49.641314] raw: 0300000000030508 ffffed312c4bc908 ffffed312c4bc9c8 0000000000000000
[   49.641315] raw: 00000007f404d925 00000000000c823b 00000002ffffffff 0000000000000000
[   49.641315] page dumped because: migration failure

When debugging this, I found that these migration failures were due to
__migrate_folio() returning -EAGAIN for a small set of folios because
the expected reference count it calculates via folio_expected_ref_count()
is one less than the actual reference count of the folios. Furthermore,
all of the affected folios were not anonymous, but had the PG_swapcache
flag set, inspiring this patch. After applying this patch, the memory
hot-unplug behaves as expected.

I tested this on a machine running Ubuntu 24.04 with kernel version
6.8.0-90-generic and 64GB of memory. The guest VM is managed by libvirt
and runs Ubuntu 24.04 with kernel version 6.18 (though the head of the
mm-unstable branch as a Dec 16, 2025 was also tested and behaves the
same) and 48GB of memory. The libvirt XML definition for the VM can be
found at [1]. CONFIG_MHP_DEFAULT_ONLINE_TYPE_ONLINE_MOVABLE is set in
the guest kernel so the hot-pluggable memory is automatically onlined.

Below are the steps to reproduce this behavior:

1) Define and start and virtual machine
  host$ virsh -c qemu:///system define ./test_vm.xml # test_vm.xml from [1]
  host$ virsh -c qemu:///system start test_vm

2) Setup swap in the guest
  guest$ sudo fallocate -l 32G /swapfile
  guest$ sudo chmod 0600 /swapfile
  guest$ sudo mkswap /swapfile
  guest$ sudo swapon /swapfile

3) Use alloc_data [2] to allocate most of the remaining guest memory
  guest$ ./alloc_data 45

4) In a separate guest terminal, monitor the amount of used memory
  guest$ watch -n1 free -h

5) When alloc_data has finished allocating, initiate the memory
hot-unplug using the provided xml file [3]
  host$ virsh -c qemu:///system detach-device test_vm ./remove.xml --live

After initiating the memory hot-unplug, you should see the amount of
available memory in the guest decrease, and the amount of used swap data
increase. If everything works as expected, when all of the memory is
unplugged, there should be around 8.5-9GB of data in swap. If the
unplugging is unsuccessful, the amount of used swap data will settle
below that. If that happens, you should be able to see log messages in
dmesg similar to the one posted above.

[1] https://github.com/BijanT/linux_patch_files/blob/main/test_vm.xml
[2] https://github.com/BijanT/linux_patch_files/blob/main/alloc_data.c
[3] https://github.com/BijanT/linux_patch_files/blob/main/remove.xml

Fixes: 86ebd50224c0 ("mm: add folio_expected_ref_count() for reference count calculation")
Signed-off-by: Bijan Tabatabai <bijan311@gmail.com>
---

I am not very familiar with the memory hot-(un)plug or swapping code, so
I am not 100% certain if this patch actually solves the root of the
problem. I believe the issue is from shmem folios, in which case I believe
this patch is correct. However, I couldn't think of an easy way to confirm
that the affected folios were from shmem. I guess it could be possible that
the root cause could be from some bug where some anonymous pages do not
return true to folio_test_anon(). I don't think that's the case, but
figured the MM maintainers would have a better idea of what's going on.

---
 include/linux/mm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 15076261d0c2..6f959d8ca4b4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2459,10 +2459,10 @@ static inline int folio_expected_ref_count(const struct folio *folio)
 	if (WARN_ON_ONCE(page_has_type(&folio->page) && !folio_test_hugetlb(folio)))
 		return 0;
 
-	if (folio_test_anon(folio)) {
-		/* One reference per page from the swapcache. */
-		ref_count += folio_test_swapcache(folio) << order;
-	} else {
+	/* One reference per page from the swapcache. */
+	ref_count += folio_test_swapcache(folio) << order;
+
+	if (!folio_test_anon(folio)) {
 		/* One reference per page from the pagecache. */
 		ref_count += !!folio->mapping << order;
 		/* One reference from PG_private. */
-- 
2.43.0


