Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 156CEC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046256B0088; Wed, 23 Sep 2026 02:58:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01E0A6B008A; Wed, 23 Sep 2026 02:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F926B0098; Wed, 23 Sep 2026 02:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B72B26B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:58:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92BFBA6AA8
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:58:41 +0000 (UTC)
X-FDA: 85244124042.11.E90DDFC
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf20.hostedemail.com (Postfix) with ESMTP id D0FBB1C0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:58:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NmqNmuUt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790146719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iZrjQ33poEdSxILO2JDtHpIllTCJBtOtLGzw0UbF9Hs=;
	b=wgWf8gehYLB6iVkTM985ckwM1onFhkMyP7xs6FmDcE5bLrs3EZmCmvEf3ECBJWc2E9JvS9
	enMsKMSpDi5XDCi0k2GzjyPzdvZ4HN+F2Jz0PFpaViZ6nuI0f0c+sXiH7sUSJ4n3i+oKxP
	7c7nNSzxZQPdHtXarghsnJAT8GcMJL4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NmqNmuUt;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790146719;
	b=f4yiyD1FwyND2fiEOR+5VGVc7tn5RQlI9HLU4wx6JWbVymlcNak++Tn5LZ7zF2AIOD9CGS
	JPgBDtWbBVHnDLpW+tR459WVj2iejXM+ITJQZT6D0RvD6Xh9JmTZNo3tXHjnbke7rdAi5Z
	ZhnltjuG+OGaxS5xyTize+IB4eIovm4=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso3520765e9.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790146718; x=1790751518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iZrjQ33poEdSxILO2JDtHpIllTCJBtOtLGzw0UbF9Hs=;
        b=NmqNmuUtXDPLq80Nppopm5GJ/eN68/AKu5TpxbLtT0uQ/kFB0z8oCjwjZhjdAhstnf
         GXekxxNl0HTgas1pFagSe4qMd6+b5GrCiulYaFaJGtYYL5ISNoL2vzmrsYR8s+j+0qJD
         uk1HNu8TkHo9rr6hfR/ifjyz9XtfzcY/+w1/SfwfHojQFo4bTGXG+UPQSvRvNGAUyVdV
         5DU37jZ7DThJ2kR/oNFlkVy8wSqhQr70eQ1/NB1iTPO7FYb8Q/msNiM8fNHrKbMOVtNa
         hhXbkGSWXx5s71JKW3gAhhxXhVlkIm/i65i8dUrEYYXITBuYkhJ36Re6V+iWLfvlFTX0
         SyUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790146718; x=1790751518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iZrjQ33poEdSxILO2JDtHpIllTCJBtOtLGzw0UbF9Hs=;
        b=pWj7+fk3MRAzSuQwv56gA3CTsqCVpgyPXT0q2FfqTvIblLCjNVAxwmbCNNGOornO6D
         nQUEXvO/xYqc6v2KaVK8imq8c8aD5c2/5g1a/aQtoZT2tLLFml6qoSWCqzLoAwwauzsA
         eiQCIagYYMfxR3sy6uBWu1fWwarWPEg5mheYIXrmppxGK9Es9E87Xxm9T308/+mrfzDQ
         wLaS+9oE/rzPi+6Xv6fEzMtNEtgntnx73m+qqryF9Uq7Lj+d/33gz2X/YII0RRiWxZM0
         kfi2WxNFtUPxsdTsNMmk/Ez1CELA5TXKsJuzdwQDrF4wR4jFuCt+iJJQqH6iSoIQw7xj
         hfQw==
X-Forwarded-Encrypted: i=1; AKwUvBzDNTyaHr28buuLc/PKfZrKpudmSo8R95S7Nw8relKl9Z3FCEDVEs5/dm9CnJUE1JVPRvitjFX8OQ==@kvack.org
X-Gm-Message-State: AFuF++n543PxvTAvGm45ss8nLfEF7vTCQoDKOq9UM5FE0ebxEbHGVjQ5
	CHpEboJjohmr4oWK5Xt2NCzXgLNKB91mRbCAgwKY5ew9a09oPN/x2pHR
X-Gm-Gg: AYBFou0owR4olmemIfGCXdf50Ja1mbCk3jvRYPtu+8tBMoC0NbPMMHldz1N+FHc/Ezz
	eI3CqKhuaQ9b4168F1yBMMRmX/YD3frKe6bVC9JDFjHNsd93BRvxfQ+cB+NPY5HDhT81pehhZ4C
	xxMdq2uvZSWXx0/w5nM5zsNzQA1utDKDn/qoAGvejpuRDGfrbDlA9z2Uuo/fhg0Vh0qaAhzeZ66
	dqyQOpZDDHgrwmCt/Eh02kugDciw3QWqnfM6AdHLxmK20+6X+Y6Nf8T+P0lvIRaM1sWdT0Ra9Zj
	Q7Xd5/5eOxqXYgusj4mJk+0/A1zHrSYnvIyoxojYL3pzeQFHVxtJROcqBXnIBw1CsJUbkA9bnu5
	RrOSZen0TmLq4rqdsTyT6+UbWuXHnmGkgXh910Y0BvNaH9GWBKeNrRgb4ohy9WJo5Zua72APvHG
	jEiSaChzPq2gLzjdXYPj93DROOxp3LeJnqre8aqBw9ia1xFuH/rCvGRauqBRa3nq3s/496KMd4R
	b/Uzo9s1y3+h71Heaik6NTtW3UdVCtsUPmfQ8rKB0mxo+CvwWET8LdCG8tAjDSEKn9S+7Q3yo/f
	iTJZE56BmOx1s+fqwEFJcz+zHTrzFOcZh1hwDA==
X-Received: by 2002:a05:600c:c176:b0:49f:c451:b4ab with SMTP id 5b1f17b1804b1-49fdf152561mr17989925e9.29.1790146718132;
        Tue, 22 Sep 2026 23:58:38 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-114-182-160.95.114.pool.telefonica.de. [95.114.182.160])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe23d4288sm22524325e9.12.2026.09.22.23.58.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 22 Sep 2026 23:58:37 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Zhao Li <enderaoelyther@gmail.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Ma Wupeng <mawupeng1@huawei.com>,
	Jinmeng Zhou <zhoujinmeng@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/hugetlb: fix max-only subpool accounting on alloc_hugetlb_folio failure
Date: Wed, 23 Sep 2026 08:57:14 +0200
Message-Id: <20260923065714.20781-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260428113037.88766-2-enderaoelyther@gmail.com>
References: <20260427145247.84157-2-enderaoelyther@gmail.com> <20260428030712.66256-2-enderaoelyther@gmail.com> <20260428113037.88766-2-enderaoelyther@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7wx4bm87qfrkrfex7c3fwnm4mmeprk5w
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0FBB1C0003
X-HE-Tag: 1790146719-509938
X-HE-Meta: U2FsdGVkX19mlgCyTmscr91AyZJrbTMScYReq99tSlYuY9Y+YJkqBAPKkRs1RGG7rbLvXLAWFLCSfCqsrd4vzXJzgSYHnnPfTyKFGhQspRPia3CWE0tN03U2NbHKEtkm/XqGUcep8mZhj2bVPpCI8EAwgPzyz95neYKmZAIvE6mUi0xzp0uJHOduZ1DLCp9D/pxVgvYBnRgb5If9UHU+7P5VBvNqRVESvwRi/qjvfpAx92g2V+YeLdrWHMMUvLwSRxM3knJWbJyGrhIJ3aIASubltu6hnVj3zpEBXPnUjELukmj0FWyz/FQqtK7mC1uWgZPddiAklGWkuOJzVoYmNOlQZCHzHdRixmO2TsCrZ0obIlZ5194ZRv2fbCq3s9cPHp7FD0g48jM4/jH54+xdkSyoZ2MXvNIhIpQAaAdd6LsVxKf9jzpU25YP5QzYnskk22Sd4oRT6vJ8fYU2AlidR2qSCaw8Jwm9Zz/Mf08fAaCAMzr8vxROFSF5qBI/2GnA22NEY2F81/tB7CCfyiFVOjmmSXsYJd7rWIT+6IZ0pjTdeZQvP5aIZ7KCGR5g4GeQp2IPwvfcZ4CLPN59gx2586KwnHXI0C2pM7O29SCyqOf3BP50gBmHOlU62L709eAPIy2GE9wmGnBxHKnrHgfyf6vf0haZMkJY9gMkrWgCBSq/H1EtyoQZBGLhtiRv3Xjnn/hB3RiqoAIgKPcoYTKgbjw6o8TZq7F+sye/Envgn8VHxBA6YE/Z50ohxKAcogOnhNC/xiYpd7M/hNTYuxC2lnMwzv/gO69iJA0BJjxhQjKPOhrHGdXjYcwKexz4wnQ7iF65kzdmaLml59jmM5XredmEin3lP9hT+Dh8G3DBjscGp9S39YeR+6R6kI906xgs2G6KazE3M0+sLZwAKLshMz/lqV4OruDZZDuqn0+MgWy/+2yfc+eK8KJL16wycM2VWtUPPxz73OhpqNvwlzF
 994z6TMA
 dYdYbgSidfY/XcZvN2Bs4okIS1F6ezDr5vTZ12NCht0IKwX5nF3qeZr8/OMXfQNwuPUx8tT47QzfEMZntY4URKdTF0whHVFdTcvK+BfWiJ73VWseXyglyogZBo+Acw6kd+i3gn5/TjhGqE5h0hkO5OvpjmxzxBmHItgTK3Zf1mCfihwn3gn+sGL3u58Bml7cLtqFfoj3rIiHzpKwWuOoHofNwicwAclB7qsbX1J4FfRyWFx6nO+ws6viCiZw7Eo/JmZg0n42srTh2fG64vMz9eDBm9e0sGrJryM1VDIqrt4dy4kIPr6iKMlHOfyY32oQUkI/YyEnycsm3y1KwbyCoYFyG2V6NvlBAihsF49UdZn0KI7lDCaD8659XfClO9RlauoqUvbmkou93kOY+jX98Vx9UtOXu2sXtabYYGur13/WNhIqe8vz7x8Xjpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026, Zhao Li wrote:
> Mounts with min_hpages != -1 are left unchanged for now.

In case it helps with that follow-up, here is a small reproducer for the
min_size case. It needs no hugetlb cgroup.

The pool has two huge pages and no overcommit, and the mount is
size=8M,min_size=4M. A test maps a 4-page file MAP_SHARED | MAP_NORESERVE,
touches the first N pages, then unmaps and removes the file. Five rounds
on one mount:

  N   faults ok / SIGBUS   statfs free / blocks   HugePages_Rsvd
  -                                               2 (after mount)
  2   2 / 0                4 / 4                  2
  2   2 / 0                4 / 4                  2
  4   2 / 2                2 / 4                  0
  2   2 / 0                2 / 4                  0
  2   2 / 0                2 / 4                  0

The two SIGBUS faults keep their used_hpages charge. Half of the quota
stays gone with no file on the mount. used_hpages then no longer drops
below min_hpages, so hugepage_subpool_put_pages() never restores
rsv_hpages, and the mount has lost its minimum reservation for good.

The out_subpool_put: path skips this case on purpose, as the commit
message says.

Same result on v7.3-rc4 (f0100363d8c3), on v7.3-rc4 with this patch, and
on next-20260922. That tree also has 6f8b22e85eac ("mm/hugetlb: fix subpool
minimum reservation rollback"), which fixes the hugetlb_reserve_pages()
error path. This is the fault path. Tested under QEMU x86_64, one CPU.

Thanks,
Karl

#include <fcntl.h>
#include <setjmp.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/statfs.h>
#include <unistd.h>

#define HPAGE (2UL << 20)

static sigjmp_buf env;

static void on_sigbus(int sig)
{
	siglongjmp(env, 1);
}

/* usage: t <hugetlbfs dir> <pages to touch, at most 4> */
int main(int argc, char **argv)
{
	int n = atoi(argv[2]), fd, i;
	volatile int ok = 0, bus = 0;
	struct statfs st;
	char path[256];
	char *p;

	signal(SIGBUS, on_sigbus);
	snprintf(path, sizeof(path), "%s/f", argv[1]);
	fd = open(path, O_CREAT | O_RDWR, 0600);
	if (fd < 0 || ftruncate(fd, 4 * HPAGE))
		return 1;
	p = mmap(NULL, 4 * HPAGE, PROT_READ | PROT_WRITE,
		 MAP_SHARED | MAP_NORESERVE, fd, 0);
	if (p == MAP_FAILED)
		return 1;
	for (i = 0; i < n; i++) {
		if (!sigsetjmp(env, 1)) {
			p[i * HPAGE] = 1;
			ok++;
		} else {
			bus++;
		}
	}
	munmap(p, 4 * HPAGE);
	close(fd);
	unlink(path);
	statfs(argv[1], &st);
	printf("ok=%d sigbus=%d free=%ld/%ld\n", ok, bus,
	       (long)st.f_bfree, (long)st.f_blocks);
	return 0;
}

  echo 0 > /proc/sys/vm/nr_overcommit_hugepages
  echo 2 > /proc/sys/vm/nr_hugepages
  mount -t hugetlbfs -o size=8M,min_size=4M none /mnt/h
  for n in 2 2 4 2 2; do ./t /mnt/h $n; grep HugePages_Rsvd /proc/meminfo; done

