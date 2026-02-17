Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56754E909D3
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DDD6B0088; Tue, 17 Feb 2026 11:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71BFC6B0089; Tue, 17 Feb 2026 11:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A486B008A; Tue, 17 Feb 2026 11:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9F56B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:32:57 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1B595754A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:32:56 +0000 (UTC)
X-FDA: 84454492752.29.24232FC
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2B941100003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:32:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XEGTHLy1;
	spf=pass (imf14.hostedemail.com: domain of 3NZiUaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3NZiUaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771345975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bJd/jsI1Ahr6ZvCTFiQFd3QULQDNn4kGH1XUoRnqvFw=;
	b=q1GIWsgP9btUFtRT578qKtpnts4myCyTW05dnbp9oR5TndrxuMjqm57oB0/GnGCmCBEF4Y
	Yuox1Ek/AC2wkkn5n5X+IuXtpF7qZ0zReoyUPItIAo6dnFMjr4mmm3QuuxEXQEfYIXosQE
	MTmHX7wjO8xSvBQ0KHm8G+E/ZwYuWgM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XEGTHLy1;
	spf=pass (imf14.hostedemail.com: domain of 3NZiUaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3NZiUaQYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771345975; a=rsa-sha256;
	cv=none;
	b=s/E6S1MVZahHTA8gKGH9pFNWMu9gg+UA4abmSczRpoKHPY3jh3T6KkFJwfclGOd67qjD5u
	hB0YqmRpfhJnjvtTWkqQ8esmdQoux84JF5vyjGUcdTe5stTBNhFJnR67ZJuQ1vGiAZw0CU
	YWIsUExBD6qrlV+hy3TuZV9hHcyfMz0=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-126e8ee6227so7849389c88.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345974; x=1771950774; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bJd/jsI1Ahr6ZvCTFiQFd3QULQDNn4kGH1XUoRnqvFw=;
        b=XEGTHLy1WtVh33MPw07XYqLL0M/pnzSlqCA6udmZ2WOePdwf95tcCP3jQGJFhm7VKP
         uxyOZ+ZOrWW5nreS+rUQsfsHf9IUSNKFM2LM8qsj3vva/OjI/gv7QrHCLHGlSTLDrUQ2
         gHeLemFtHs0Y6Hv0Zuo/C2uE81qPK8QLrEMmiXOD2D53ppfOfYDeZoZ+jrIiru6ILrv6
         hlagm7Lib69rVW+Sown1dQhZ95gr9YVYCXyfA2XNAZTQGXOt0Fx7DmGaxr6X/F0wYqE+
         zP1WFxTCQMUNN5Y3oxMlpp4FbgzP6tC7f9nQ/bq7m5JEyRTn1DM3gZSoHu0e8C4sNLPh
         qqFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345974; x=1771950774;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bJd/jsI1Ahr6ZvCTFiQFd3QULQDNn4kGH1XUoRnqvFw=;
        b=N1DB7WL5VitAWObP964BM5bB5vb2iMaotTasBVkROCjUOUq0kApwVuei4xTH9Ij+EW
         HQ2YQEsYhv0KkYs3DsJhXGlrPWZuX17l95OpmB47vRpdWqhXJReXlBSnXGpPNle0FL3O
         ku6Rm8xjwA3Zg3mQ5gNiD09K6GFqp7Gvk8mdAl5XyCId1MxWJkcfnToBRHplv2wcNmEh
         bYjKcoUZ2NDOqGsNgHJPB0I8IOB39WUo2D56YAaV5HX+1msT5XH5qO2NKz/fhB96UiaZ
         jyz/CMxollzOj9g19xNe5Z2KEIztXZFEm+mn3ZW+DMY77Y6kvLAKcID4buNnjlmZ/+RR
         4VuA==
X-Forwarded-Encrypted: i=1; AJvYcCWUYTPhDiqlAOd1KDGSoQK+NELbnBNAYSnYaw6mcFJ9dWCmTVj59FtVYnuyxTTpQRNa+6AMEEsdRQ==@kvack.org
X-Gm-Message-State: AOJu0YxdtBbT5TnfThLMrcmnsJ6AnpSpj4sr982AoI6yuqHzwDhWMhaw
	LG+LxjGfOT/TZ+ME0a371c8kWn+vPKY+TFaw7NlDHRU4tElVPy5Dw33rF5f9CSawoyMjvp8uZzP
	RgO/zyA==
X-Received: from dlbur9.prod.google.com ([2002:a05:7022:ea49:b0:127:e77:9377])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6b9f:b0:123:3488:899c
 with SMTP id a92af1059eb24-1273ae56e4dmr5617423c88.40.1771345973444; Tue, 17
 Feb 2026 08:32:53 -0800 (PST)
Date: Tue, 17 Feb 2026 08:32:47 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217163250.2326001-1-surenb@google.com>
Subject: [PATCH v2 0/3] Use killable vma write locking in most places
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B941100003
X-Stat-Signature: ddwsu3qdo1cgroreeqow18k9ankuaamm
X-Rspam-User: 
X-HE-Tag: 1771345974-266477
X-HE-Meta: U2FsdGVkX1/kcIARx7IzBSxdN5kHVkD2CGgMKcdzKZT420RKEKG4oLBMll4ya2c7V0fHieGvbTA6h6Bou0tNFk6StdM40SOloj9Sl9tyRpaj7txKyMeUt2/EhchqdC5/ebRFBLXySqWtIwK+23u2B1f1X2c92FfSgtJPt05OMc3exGCcKipQ3qqCTkKEui5JtJjeP9JgZu/WNBviYGzwF9H5tn1kRw52KtuuND7IOfz1SPKXakTDFI0nHrM+4HOxUdqiT8CTSv8YBTRY4XVkYHemhFgz3/+l4tT0lyqC+y5ZL7cq8vzD0L44tDbdxBZQtloaZ7AEDgEu3rUTaxVmMRmDvIY+3p9Eoz8Oaj/+M0U3RDHCLmc5tFk65t7EX9cp8Glynx2o8IKGhUN51AtIy4Nnz0t/D7x3a4sAJlUidUzeKGJk0y1laV9rJ+57EM0A8fyvKmouLS35pcGVv3SvgvS+2E7aAiIzExokqfXaQv33NSTT+yGG6K12SGl+8loT0BPGTifqJtrxj/iP9GaWEjq62mHaV/JueWGJg9SiQk7zUxKZHUy1PwLddFtPbjknQWurCDkaOay+sjOQBWgIYCjE1DVH7ihx2Jp23y2UMbN63m1WdwjrUvRjJvQmLGK9mEK914++fj3PibjAnmqn2B/3WXRT0APluyt60h3Xpem6MRKXk7LdkHqxv+YkBn7AxedqDF3zqjvu8FuyzPyjZq0vdF2/pxjZYWg5aDjFKZS0xn5tx/hx5OgzNmKrEsltvWazJxNZNLUUdDGT6DTEffaqp78zqijIVZRO1BKGKG8KbbUYp9rLhe03CeOHcw79w/Qf5vMARuWmaQEahQUECBX1bRENEPhPuHA0V0TQXbIfai/5R3lm0PXLdPUOMzfMUxRMpRiiy9VevxNPM8aji3JLV/Oc4VRnbZU1krxnqGXzYVSv3a10WbCwZFuDzpTbtvfcMEQNGd80a75umF8
 SNa/syMw
 Mo27+LDFWRPH65S8QxOPfiZgl0U/MHjA0IPayc3WDguXWGx2VZpGsaOX9XOtPp/CIRP0EtfAKHd/e3HABOzAnaUE8UtG2Q32fr/xpRvbVhyP7a23+kYOYNJtLH+CQ11OePOrKcbXa+/QFQbSLriT/1VGbJbypdMo9qC4arG6ytWW1qr70dxBsybDdELJYvCLX1dhEQRpJbNPwcqIUr+n7ZlrVA6+gHaH2H0vrdPkfcCbpvvCVHTLzSgEA7fDGWFTszvrXmyhFPUkqXNkkzyHu3zFjxCbdP4H4KHY5WHDQyRtiG2TKC4Si0LDuB6BBSslo/4nGV01LJhrI7nTuPcM105rqag298XP+tUQWZmyMezjflplR82GGW1azJD++PXSrCSfNT4em9C+EX37C+c1lgurjaMFArdFaDJm8XMOzcxuWre1yLddSpMaQTDXLdwPRaKohSxicpvZrLjAmv2/HXfWxyn4W/Pp0UUQL+78RT5qVFhF4hsKZxAFahZxX+ig+d5+IYo5cm/njowSJuNOQdsA9W5KKgmh7mBYcO5Kp+7aUJ7A0z6mjIjIzaIz6aatDtARvGvP+Igs77LUFgNjPFkie8YPRIHxG4tvtavRkT7VsOJKx/iYvY5r7m7xD3cK0WVerSd9PM5KiojFrTdPiHPXiZ1KhFmt/O2T3ENL7cs8Wkoa2OeIqM8mU8l/T/HxN31SwimOQAW9p2U7lqr202O2U6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patchset:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

3. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

A cleanup patch is added in the beginning to make later changes more
readable. The second patch contains most of the changes and the last
patch contains the changes associated with process_vma_walk_lock()
error handling.

Changes since v1 [1]:
- Moved vma_start_write_killable() inside set_mempolicy_home_node()
to be done before mpol_dup(new), per Jann Horn
- Added error propagation for the missing PGWALK_WRLOCK users and
split it into a separate patch, per Jann Horn
- Moved vma_start_write_killable() inside __split_vma() to be done
before new->vm_ops->open(), per Jann Horn
- Added a separate patch to change flow control in vma_expand(),
per Jann Horn
- Brought back signal_pending() in mm_take_all_locks, per Jann Horn
- Moved vma_start_write_killable() inside __mmap_new_vma() to be done
before __mmap_new_file_vma(), per Jann Horn
- Added Reviewed-by for powerpc, per Ritesh Harjani
- Added s390 reviewers and the list due to changes in the last patch

[1] https://lore.kernel.org/all/20260209220849.2126486-1-surenb@google.com/

Suren Baghdasaryan (3):
  mm/vma: cleanup error handling path in vma_expand()
  mm: replace vma_start_write() with vma_start_write_killable()
  mm: use vma_start_write_killable() in process_vma_walk_lock()

 arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
 arch/s390/kvm/kvm-s390.c           |   5 +-
 arch/s390/mm/gmap.c                |  13 +++-
 fs/proc/task_mmu.c                 |   7 +-
 include/linux/mempolicy.h          |   5 +-
 mm/khugepaged.c                    |   5 +-
 mm/madvise.c                       |   4 +-
 mm/memory.c                        |   2 +
 mm/mempolicy.c                     |  23 +++++--
 mm/mlock.c                         |  20 ++++--
 mm/mprotect.c                      |   4 +-
 mm/mremap.c                        |   4 +-
 mm/pagewalk.c                      |  20 ++++--
 mm/vma.c                           | 105 ++++++++++++++++++++---------
 mm/vma_exec.c                      |   6 +-
 15 files changed, 164 insertions(+), 64 deletions(-)


base-commit: b08472d036a36893ecf68296d87beb58d21f4357
-- 
2.53.0.273.g2a3d683680-goog


