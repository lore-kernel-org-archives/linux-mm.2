Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98A3BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 11:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7156A6B008A; Sat,  3 Oct 2026 07:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C67C6B008C; Sat,  3 Oct 2026 07:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B64D6B0092; Sat,  3 Oct 2026 07:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCA46B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 07:01:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA148C0967
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 11:01:51 +0000 (UTC)
X-FDA: 85281024822.19.62477E4
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id EECE18000B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 11:01:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WtlUyfId;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791025310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=U88Dx/fLCGECyYQCess+Hy3G4KhGKCmrl9990XZefic=;
	b=Sq6KPgtRIEXFsVNuixsw6letXy7gTJO9FMLC6kQs+JdF7DoXkcLkChAL072B1rgrc24afA
	3Cx+lTXgK++EPl0uhgC9maopg7FnRtcu9YY3tt0H3yZbi46cB/slbaF8bsVb3uQQ67uSJ8
	3UHo/i0xNAbmCxGOo4fehqBXg7bZBnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791025310;
	b=cW5R8KIS5JyDzL6YuRZ0xmlc1xzKK/40frPuQOQJUwTObaJQlcnQ9rJ5hQv5psRQfwPeV2
	MY9Fw9rO84C7Gnw28h06phnb3sHlZiL5Lspp/Ik1Zsc6URaCFGcNEXiS1OW7J7nPtNvUfX
	Cdu2GnkRBU79uCx2hz2L4TNt686s79U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WtlUyfId;
	spf=pass (imf02.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48b0d19cf7eso184945f8f.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 04:01:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791025308; x=1791630108; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=U88Dx/fLCGECyYQCess+Hy3G4KhGKCmrl9990XZefic=;
        b=WtlUyfIdG7sXAVE7wJ/soTKCIgwiBXgzQ30Wd/+AN7tRXWEPnfG/URReDV/SM9KHLW
         K+Qcnn9ntA8BMLeys0mMu3s6hduuDDLOanx0RcEHhnS1hcy5t/8H7wjrjFhoXAOTmQtK
         PmcPb0zTYgL3rXQfBgFkjTsWZWYwfYvlQVfLrc8VQgyQMHJyE1YlKvKCVQy0rql4Vwoj
         n7ZQfzK5+RXMq3eVs3C7FWNUm3dH0aL8HoBkcP4pY8Ih8u0h/2sp21AvbWGROUMr5P3Q
         73azsH0GHf+1x6v/rwjSeUqv5sKXgPXkj9tzOzCYyCGzMHVlmq0+3QHb4KXiZUCsnUN+
         wfUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791025308; x=1791630108;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U88Dx/fLCGECyYQCess+Hy3G4KhGKCmrl9990XZefic=;
        b=e8nIOL3klVdZdtV6V9FWX3mz46e/1DlDAqusnjZmnu+BRUCT9Z0ixN6S/JW2HF5T73
         fPzRjQJdVs2DTTGE+6wWg4r1c4O5DxYhxgd4yNGes2ZBiZPbVwSHNP08321iovycv2fs
         94WjM9+gyeHZZkKchG/OYAYUHBmdGMWGkFz9Ho4aRD+YGM23YiVnzp7Zi3WgGLSVqsfA
         kTrw6zthk+aeMgQAzzEZmScij7e8wlVc+2s64FPMXXFHvk5mBm2T8jOIhKOlrGkaZOoT
         EOkxETfOQgohpb4CZFJidCsRKsp4A95dw5pXd+v2XK6tZ3AANHomVDM6f5BBXoLSKzg6
         aDKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzNpKerscoYqkJnBs/GRtoXJ/LyR0/vlSvgE4XavvAw5XOqGcYI5d/SktE3ZCJfq6ArFNkJmI08Lg==@kvack.org
X-Gm-Message-State: AFq9FYJafr36v4EIuCcQe6igJHextrn/YHz2HLQwGIlPXPUQr6thmaTU
	h3dLCLSoxxkWE39+U8O/zM4zINUNUTsvnQg52j5d55YImeKJqCvwuXNE
X-Gm-Gg: AYBFou3I1ZEWdUnDkY8fbxAfoNPNoUSNmRTMfweAyRV+oIdVBPEN278dbkEeBOFY+FY
	7Pqmsh9KRXXOvP7xPfbKAk6bE12Ly8kIwuCSjMka5GneqK9hP/M5kjD4y6gjSAiGo/vftwf6cUM
	YKtvh5Tqrk/jtyvhsavnIyFc2o/Y2LCQRWmSnUXwpEGE5dxgbk1ihkQ7Fd28rP8E5Jc69qJvHDc
	2JILpx3vxMH7CeCivzUTJzbDNQ6gmHbafsAySCU1OwInq6ERM55ZEr3NZPdr349Pvl2OUIgWl/f
	UCgImtRHeSg9Wfi3Ku7QuL4/+0P7MW1ci/g5N/uW+z6/mZYwFJ6gilshFiifbNJ4o1xL5bn0i/Y
	ustse13Cyrg5JaB/3t3mE0EGcUhUo4fXcleQ2bXhKSMbDH2tjuauGgRjkB8JEfZqjDYonsdjnXv
	tkJ8VD3ZsaG0YmYGHU1Wkyh0vBHo0JdIARUyvzYCKXspllU4wyRcAN9uZHHHTV3tht8WwUzDViz
	WUNP5H7itKhvZnCezJ3OvjfZrFXc/O8q+BQsSpzJSF/n6oAl+h6tJnW/EYbFFKuzh3DyUMxOYqh
	1Ygb10kcSmi8ZI47RfbT50P5LxrqJclz0tDK4pCIzcuhqpQAApY55NcFuI8Y2f4uA/hD9/Qd+od
	0IVrR3WaarpTfN2bSDQ==
X-Received: by 2002:adf:e80e:0:b0:48b:437:8fbb with SMTP id ffacd0b85a97d-48b067c013bmr13201711f8f.19.1791025308156;
        Sat, 03 Oct 2026 04:01:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b2e2-2001-c47f-5a89-3d9a-cd2d.310.pool.telefonica.de. [2a02:3100:b2e2:2001:c47f:5a89:3d9a:cd2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b38103856sm12316254f8f.25.2026.10.03.04.01.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 03 Oct 2026 04:01:47 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] userfaultfd: docs: Fix an error code, two names and the POLLERR cause
Date: Sat,  3 Oct 2026 13:01:37 +0200
Message-Id: <20261003110137.88619-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g9ptwredtcjci57zescodkfh3cgqozzb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EECE18000B
X-HE-Tag: 1791025309-245409
X-HE-Meta: U2FsdGVkX1+fBpyN5REHmHgiLVC3ffAdUVNr3giZhnu+9Hc8VjafWOwue8gXrAOD2s9OLpqOgYwvw7ytWAyE25M7xEFR5TECExoqrUTOikO7/W7gGYg2jiZFZwOHMaNpkadlHVU5e+24Sj2ZNzTnFbDgNL32o95lAUmTYd3S4cKXJNAHfPHwZb3tVdK0gHAoENTQpWVoiNAwjldplG9TKoK2yLf/4jhJoiG52bCOITUaw2PytFkV21tQozsyL2hfZ73P1fHHFkgXEvaJFY0rBANJS6A4F+GywAJtcsa+31V+4MNM1Mh6FW9g96lNy+tXB5KxSgVaQbHDQG9svDHRGM6HZ/tUeownvmquOhgyUirnVOfl+EDC7KI1wvDcszBUv9TwWchf/xBo2NZvQ1K4w63Bo/6bp0+C4YyoYhPW2WSHSw+2O3ADGNBr0VJp7Mn0+uDbbwlqFArnhC315rdSRp93tKpFk3nGmFvS4hXrAh1f5tOfjbaMPi9rOeZo/L/MOEoDpSZKfFypP8plTeG75S8AupX0hquHWJACHIxuvB61UFqHCjrHqwfSuZ+MGLc74X8wOb3IdJ1YfT4OurkydtWHTwkmr/OBKuRL2KNlbiYVyzyC+kB4H9SEUqtM9W2VVNm+T2dxfQc0ytWamUjOpM4tSf0DJchK9m43H0aXYAslV001B8ZyvBbAkgeWzkWVVNuzewxEV95PiBuLjaHcDNukCbeff7sNxC/ce5P0o6wEE0p/AOP53ksICW4zALkkkj0lSxZr/aVwieRcK2CZG/3SkKj1F4QEInzLaW9Iv4/tfsFn6jxPT6TRpIDF7QUO261W+sYnA5dzsyATKUmirkDrRw2kvY2kkMuBWXMlnHcTQom/YYXjpBov25peiI1wR+bx960ZsC1JzgCRkgzbefyMcl6daEaBw/YNTaLR+knuzh/fFCVBpZQgSeDdgCuXwDnIUCqw7uSXyvv2aFi
 Q1KqqKhw
 QPr1v58v5DnSGHsrC4XeFdCvPfppPhYDdbzRfWJ0Fy6FRsuE9r/4R2eG0hP1bIKS/iXlJJlAaI5gBEEKfQLHVh8UnlttrxyZdRzxB3AqeDHq6fr3S6T4s24fEBWmU2lXkLyGST7ofPGUG1QPX7kBUJSMMzwYBfwyBvZtA0y3Pmg7k6stv7TYvCkLx75GsxEPHx60G2jq17n1IRAp+klhOk/f2R9wiiqlc8w1zAIwKrXr+IOCyip6elmNoDVDnbYMBzxPTRSjK0bh7L+M30OCGZCH1mNPc24x5JNbanPDzVm1A/1BktUFmiNyi/cz5s52P3Y0Y13Sn+0iiyLTwzqOCbU9WcWWV0JNdr/CTHYiAB4rky9XFU8Q4FgVtJPGJ7WrsDoc1Ac+Yr31FQXIOGsbt/A7LYMu1WGrCdk1M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Four statements in userfaultfd.rst do not match the code:

- UFFDIO_COPY is said to return -ENOSPC when the monitored process
  exits at the time of the copy. That error is -ESRCH since
  commit e86b298bebf7 ("userfaultfd: replace ENOSPC with ESRCH in case
  mm has gone during copy/zeropage"), and userfaultfd_copy() still
  returns -ESRCH when mmget_not_zero() fails.
- the postcopy example says that UFFDIO_ZEROCOPY is used for zero pages.
  The ioctl is UFFDIO_ZEROPAGE, as the same sentence says a line
  earlier.
- the write protect section says to clear UFFDIO_WRITEPROTECT_MODE_WP in
  pagefault.mode. struct uffd_msg's pagefault has no mode field. The
  flag goes in the mode field of struct uffdio_writeprotect, as the
  paragraph says when it sets the flag.
- poll() is said to report POLLERR "when ranges supplied were
  incorrect". userfaultfd_poll() never looks at ranges, and an ioctl
  with a bad range fails on its own. It returns EPOLLERR when the
  UFFDIO_API handshake has not been done yet and when the file does not
  have O_NONBLOCK set, and it did so when the sentence was written.

Say -ESRCH, UFFDIO_ZEROPAGE and mode, and name the two POLLERR cases.

Fixes: e86b298bebf7 ("userfaultfd: replace ENOSPC with ESRCH in case mm has gone during copy/zeropage")
Fixes: 25edd8bffd0f ("userfaultfd: linux/Documentation/vm/userfaultfd.txt")
Fixes: 57e5d4f278b9 ("userfaultfd: wp: UFFDIO_REGISTER_MODE_WP documentation update")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 Documentation/admin-guide/mm/userfaultfd.rst | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 783d969f0e28..97daea83b7f1 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -199,8 +199,9 @@ Notes:
   those IOCTLs wakes up the faulting thread.
 
 - Be sure to test for all errors including
-  (``pollfd[0].revents & POLLERR``).  This can happen, e.g. when ranges
-  supplied were incorrect.
+  (``pollfd[0].revents & POLLERR``).  This happens if the userfaultfd
+  does not have ``O_NONBLOCK`` set, or if it is polled before the
+  ``UFFDIO_API`` handshake.
 
 Write Protect Notifications
 ---------------------------
@@ -218,7 +219,7 @@ protect as many ranges as you like (inside the registered range).
 Then, in the thread reading from uffd the struct will have
 ``msg.arg.pagefault.flags & UFFD_PAGEFAULT_FLAG_WP`` set. Now you send
 ``ioctl(uffd, UFFDIO_WRITEPROTECT, struct *uffdio_writeprotect)``
-again while ``pagefault.mode`` does not have ``UFFDIO_WRITEPROTECT_MODE_WP``
+again while ``mode`` does not have ``UFFDIO_WRITEPROTECT_MODE_WP``
 set. This wakes up the thread which will continue to run with writes. This
 allows you to do the bookkeeping about the write in the uffd reading
 thread before the ioctl.
@@ -584,7 +585,7 @@ The QEMU in the source node writes all pages that it knows are missing
 in the destination node, into the socket, and the migration thread of
 the QEMU running in the destination node runs ``UFFDIO_COPY|ZEROPAGE``
 ioctls on the ``userfaultfd`` in order to map the received pages into the
-guest (``UFFDIO_ZEROCOPY`` is used if the source page was a zero page).
+guest (``UFFDIO_ZEROPAGE`` is used if the source page was a zero page).
 
 A different postcopy thread in the destination node listens with
 poll() to the ``userfaultfd`` in parallel. When a ``POLLIN`` event is
@@ -672,7 +673,7 @@ asynchronously and the non-cooperative process resumes execution as
 soon as manager executes read(). The ``userfaultfd`` manager should
 carefully synchronize calls to ``UFFDIO_COPY`` with the events
 processing. To aid the synchronization, the ``UFFDIO_COPY`` ioctl will
-return ``-ENOSPC`` when the monitored process exits at the time of
+return ``-ESRCH`` when the monitored process exits at the time of
 ``UFFDIO_COPY``, and ``-ENOENT``, when the non-cooperative process has changed
 its virtual memory layout simultaneously with outstanding ``UFFDIO_COPY``
 operation.

base-commit: ff47652a4b66c067c765a7ad464d930b5a9367cc

