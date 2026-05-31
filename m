Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA719CD6E52
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 17:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B7AA6B015D; Sun, 31 May 2026 13:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28EF76B015F; Sun, 31 May 2026 13:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4F16B0160; Sun, 31 May 2026 13:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0686B6B015D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:10:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C441316211E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:10:21 +0000 (UTC)
X-FDA: 84828353442.07.7095030
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C2391C0003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:10:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eYFLCAod;
	spf=pass (imf20.hostedemail.com: domain of cyyzero16@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=cyyzero16@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780247420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CqJpbwtossSFW5neyJ87RipB4IcgiOFbuX2fMHVoKDA=;
	b=d6zjcocXPrYu3/Bq8qN6pFksntQZ9vasQOjdhhirDazZMpNZiY/Pv6OrFcATq8FjD7TiBK
	GyWIpptNoV41gdnwrd74n7v3kot/kR2gkYwIlKvCGXT4eopJIqryVRAGGUmLUm80D9d9kO
	4V8H4dQOxvSPqzP652UFbfJO3ivZvTA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eYFLCAod;
	spf=pass (imf20.hostedemail.com: domain of cyyzero16@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=cyyzero16@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780247420; a=rsa-sha256;
	cv=none;
	b=cqIjOwY4tyEGaPgTxXZbZrQj7Ru39qalqtMpi5bMY8VlDe2UcxBqqQ31Dymr5FW1+N1h1s
	gd/6Na+rUa9THPLS5pWkobx+DE5V7zd1QhVw5pDf2a+mA9ktkItQfcHASDKUw+IfEhWPIE
	TQlaNRumsfj/qL3D/NWIUxr72C55zSU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c0c2a68d01so3692645ad.1
        for <linux-mm@kvack.org>; Sun, 31 May 2026 10:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780247419; x=1780852219; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=CqJpbwtossSFW5neyJ87RipB4IcgiOFbuX2fMHVoKDA=;
        b=eYFLCAodqTA7UWLm91mJVWKi9F2wfAQ3F8tQOsHpDxrlbWgv0jLDQt41dQP/uoc401
         mnmG/mdg8hj/3aYeiU36OLby9PmTI7ZUOyL8DnX3jN1lVSisCyp2VSaMuFNL2hfI7tzo
         TbSUkvoQNVJs0iuTeMq5vHvjDgx6WvPsanNUtJ74sZIa99QPrykd7qfBhdIk76h3JIPq
         4rAZIcM7AvA/SQvMrZgN/QH8yuCzfOee3OCIFyoy+KVpjdNz84zV0CbMi7s9AfLVSoeu
         /DH6HTX4AmZHoM8i32AJpA2emy09gbiNp94nkQ7R6sNYJnNtPeTjYEtlYp2TwgAPhS6M
         6HYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780247419; x=1780852219;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CqJpbwtossSFW5neyJ87RipB4IcgiOFbuX2fMHVoKDA=;
        b=IrvpttvIPEIe/fEj7CSO1/UvYic+P4Cf9z5GeqUS7fB6GjqMpwf7Wziuk4ogHC0wDT
         xWmvRtc8Xj0LbFZj9CCWFjSxRIEYfs36xEw1rd7e0tyW0w+Z7eoJ3ULHZwCOL15mqQgX
         wkzzKRIV0smygUWaJodhSidp55dSCbMHuSpS3iujHcmfSdpgT+WAO2Vj7FrYRVmEHPg7
         5U0OFiKQON9CdBlfMpSKwOi8Hv6DTC+r+37G7qd8m4WGKkqHb6JpGoDw543xwTaq6F2e
         jFcKQQEM2hFQbYwNubdZ9UocL9fbvCynAcJwqomXM2vByCByUjqR3mYtEtaR1qZ29Ky5
         B86g==
X-Forwarded-Encrypted: i=1; AFNElJ8sA8psjOx5H06b0jbJwdpMtHt4gLzpBKRWeAiBNpkBvFnMsj4GxtjeIhU5aTJotmkDvhs9KQ8oEw==@kvack.org
X-Gm-Message-State: AOJu0Yx4Oh5/YbMYCD3cQwewPo0rSEwHiWW/yq9td5doEd13aKCRX+pC
	mRa6vWUrD8CN69kbNsJcctmFC28tXw94hMQPcUUgNxlfbyE1jE5g2O4y
X-Gm-Gg: Acq92OE6kQO7+J5ap8V6ewiQmriwZI5zMwPswBhjBAV1/mUGqhCI8kQGuxKWYK3cwFg
	u+FJ9o5o++pE9gLy38EUprfwcJwwFTYJms7jLfGZgiQnYmg3lc9uFEcmaYo6yBFoirBDEnZEFV+
	WSxZ5Jbj7sJuqPfL1CH1wrvhE92zbdYNL99jiJCm4wO+y/iSsjxUn3ET4EoJacbtmTVl27W6EIR
	ZezsuPBcG+kI4GldEflaxlDLRIAklwu/t6C48wHiEvZFUqpr3M/BhoQk76kfgl99S/2U2UTbCZr
	yUrAnqZWxNv29V8OZqZcF8Eo8DNCJihgS3jkVsLuh6aqrkw+goW7gYDLFcqp1pFUFyaEZQqnG+R
	idOy2H+J7+zEyquUkJJt8NU5Sm8ibyP/Ag55yWNPyMmYFvvjKQKuzLOglQHwbcBqwCvgZxs+pVj
	eLQHYf7rJEd9L2A2Ob13VSrBoVhmONZ7VNOC0q9WUBN2o=
X-Received: by 2002:a17:903:986:b0:2b4:59bf:5728 with SMTP id d9443c01a7336-2bf3682a21bmr82919535ad.25.1780247418899;
        Sun, 31 May 2026 10:10:18 -0700 (PDT)
Received: from ubuntu24.lan ([14.219.52.32])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bf239e71cbsm78487495ad.15.2026.05.31.10.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 10:10:18 -0700 (PDT)
From: Yiyang Chen <cyyzero16@gmail.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-devel@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: tracepoints expose s_dev of kernel-internal superblocks -- no generic resolution interface
Date: Mon,  1 Jun 2026 01:10:13 +0800
Message-ID: <20260531171013.289131-1-cyyzero16@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hnequ4b79udrtqfrqn8sppziwcox1a5w
X-Rspamd-Queue-Id: 1C2391C0003
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780247419-389527
X-HE-Meta: U2FsdGVkX19DplypQ0V1LKet0bVaX2JjoKh2Sl2W6ER2XCm/dWvlMzXx3YT1YO+RUcvNlLk7wsPw3vmQg2nkbK2kikBerVa5NDqKndoeusxZFkA6i1x/l2MH9NLuqGIX8u2p9mLOhvz3e03VJTsiYd+uLZR1FZ0+7cey6b9WMoWKdgdS+HimCq26N9xf4pLJVVWJ8YlOSPORslsURBI0gIQVk32hoWgce19ucbHZXFZRlmZGz03u6uYEherqVQgnVODpdSaw/t/IskoA+SAv87vFdQZtbnhuy01RDed1IKbkJRWF9uavh7miiEH/S3Emulx3a1sgADyU/J6trUx6/UypOi40WyvNpQ6YQkYX9IxnyfrnwNzh9KUweXFnAuxDZPvnSyQeimAHnDzAeKzIvTbDrLv7PTFRw0jshafPH1EAWxjpjrDJxBvMPLkvGy5wPvVOfbx3VH63PyX8lPSPj/kb3RGPWQezLQdpUVzAihImxWLAcp9SsTjvJN7XZ8KRe/ILZ+sGV+7gynVx0m1JFIPWCvSevrB21PBWStMAMtqmPe3pdeT8Q5R4FVgoNfAnBTVHwtpGO0R2fNIdrn0I+gPURv5KRw6dhnnHrJWtLgGjWF9J4OoV80ccpXcU+rjkubyqFgrXP9QnzCvEuGAlmYpKhlWmKF9FNxSpcmf8b189mo5hSgPABq7j7iasR07iiaImOnlSB6snH11/4otJbd5qZpwNphSiaQmHIWGB+l2z3V38tPYGUYJNF6Oep1MfJKhOO81qQ1axLSDsM1Fww7XypTeZN6RD9VgLfPjm2go3dvq0UpJhdHOI/dwsv+237EGlS8vcTo1+FFZxhn5rNtnXpyN+m9OLKBipJ5wXJag5kFrPN7Z0ZuP7YRly66xoQR5Hxt9v3m/8Nc4s0KIi78hrQJl7N4v9PFFNnBBwCh864J04tNBDOCLevUX4u/y9O8YAlYctK8xQBSKlWg0
 LtQyuOlF
 6lRpvww3cg95lkN5nR5vtgpKj4qVBAw9zFkQ5YjD6797DnKnjoGmWqjZ1r7SAW9yD/VySMNCd0CkqcpRGS1RfMiPoH0g4OqC4yj8hXVdNniKif3yQKVdmwCzEf0c5S18LaxlELyOK6o05vjII5Oabyd6aUFuGYS+Z8qHDuFlc5NGMmXFoRpH6MjhJtnS1HeG2Z+bqcAW9WBsp88M267HpUzSqKGUpCEhTfW+wKLRZMQb16FB3s2gO/af0Ym+IsbtJnRnVD3kGBLJ1pesiaek+u7kSmtZL+GzMtj3BYHI9A59rjANok81Mk5oHNVuAF6owVFGxhDtZl4+MZ4fWVy4F81+tJyhBM6MBngiKQMq6fbFiNzSQ5rYLZ0yjnyY71EOOw/Z115PhKk04uag8d1wsTwvwSYJgJehSALRJrf3bYAsKU3BAAtcFhFJpOIhQ97IM8Dzzdt3eARifIoY59ggUJ7iq9bS/Z8DBiqf/8jWcbBRHDCg1iKsiRnJCxzDz9HUCzvb2SKh8x09VJbg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

While tracing page cache activity via mm_filemap_add_to_page_cache, I
noticed s_dev values that do not appear in /proc/*/mountinfo:

  mm_filemap_add_to_page_cache: dev 0:18 ino dea89 pfn=0x13ba00 ofs=0 order=9

Using a kernel module to enumerate all active superblocks, I confirmed
this is the hugetlbfs internal mount created by hugetlbfs_init() ->
kern_mount().  The actual s_dev value is dynamically allocated via
get_anon_bdev() and varies across systems (0:18 on my test machine).
Because kern_mount() attaches the mount to MNT_NS_INTERNAL, it is
invisible to all mount namespaces.

Each internal filesystem requires its own trick to discover the
s_dev -> fs_type mapping:

  - shmem:      create a memfd, call fstatfs() -> TMPFS_MAGIC
  - bdev:       open a block device, call fstatfs()
  - hugetlbfs: memfd_create(MFD_HUGETLB) creates a file
    on the internal mount itself, so fstat() gives s_dev and
    fstatfs() returns HUGETLBFS_MAGIC

None of these are a general, authoritative interface -- each requires
filesystem-specific knowledge of which object to create and which
syscall to call.

The question is: should there be a single stable interface that exposes
the s_dev -> fs_type mapping for all active superblocks, including
internal ones? Here are some options:

  - Add fs_type to the affected tracepoints.
  - Provide a generic interface (BPF iterator, /proc, /sys) that
    exposes s_dev + fs_type for all active superblocks including
    internal ones.


Reproduce steps:

s_dev is dynamically allocated via get_anon_bdev(), values vary.

--- test_hugetlb_sdev.c ---
#include <sys/mman.h>
#include <string.h>
int main(void) {
    void *p = mmap(NULL, 2<<20, PROT_READ|PROT_WRITE,
                   MAP_SHARED|MAP_ANONYMOUS|MAP_HUGETLB, -1, 0);
    if (p == MAP_FAILED) return 1;
    memset(p, 0, 2<<20);
    munmap(p, 2<<20);
    return 0;
}

  gcc -o test_hugetlb_sdev test_hugetlb_sdev.c
  # precondition:
  cat /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages   # must be > 0

--- trace script (run with sudo) ---
  TP=/sys/kernel/tracing
  DEVS=$(awk '{print $3}' /proc/self/mountinfo | sort -u)

  echo 1 > $TP/events/filemap/mm_filemap_add_to_page_cache/enable
  echo 1 > $TP/events/hugetlbfs/hugetlbfs_alloc_inode/enable
  echo > $TP/trace

  ./test_hugetlb_sdev
  sleep 1

  echo "=== s_dev from tracepoint, NOT in mountinfo ==="
  # filemap uses "dev X:Y", hugetlbfs uses "dev X,Y"
  grep -v '^#' $TP/trace | grep -oP 'dev[= ]\K\d+[:,]\d+' | tr ',' ':' | sort -u \
      | while read d; do echo "$DEVS" | grep -qx "$d" || echo "  $d"; done

  echo 0 > $TP/events/filemap/enable
  echo 0 > $TP/events/hugetlbfs/enable
  echo > $TP/trace


You will see hugetlbfs s_dev which is not present in any mountinfo.


Thanks.

