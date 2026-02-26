Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 399F1FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 431506B0088; Wed, 25 Feb 2026 22:00:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA506B0089; Wed, 25 Feb 2026 22:00:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296386B008A; Wed, 25 Feb 2026 22:00:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 118DF6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:00:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B6905AD36
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:00:00 +0000 (UTC)
X-FDA: 84485103360.04.91E2172
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf20.hostedemail.com (Postfix) with ESMTP id DDE8E1C0006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:59:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IT6c015o;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772074798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8F8DPv1+8kXX8FrzoNjsuCyL9jUTbkIPz4J+MH2Hlts=;
	b=y0ZhcJLpxhAZlTC9qeta35IDpKWuXyscWUPz3ZGfHby1sRc+3BIL28ylIM2VkL3XrjTFMb
	Q6U2ZovUttyE0JO4ubXJ8cmGVeoo2Elaa5NdFEP3hqXIcr0SztbN47eWeiTFLZjxOwyAip
	rJWcK0iMjTlxikat5U5qG7IfFRc93/s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772074798; a=rsa-sha256;
	cv=pass;
	b=JAfXEIWKpu4JFGd3NiUHA1ACz6g0YIn8Jskcct+A3PFEZ6WiEz9J/QfUeMx1LjO4aNJUBn
	XH65G8/odRsPcro0gv0mIl7mgbrExveVKBPqUcCombxh56/KFMGCYD/f495YQq/1jQzs0B
	vVE7SPkUOeoBBT/Q+A6w4rPBI5UEANw=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IT6c015o;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of ackerleytng@google.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5fdf3735e14so191645137.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:59:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772074798; cv=none;
        d=google.com; s=arc-20240605;
        b=T2tZSYHp44QkH6k9ptl/Jxl1Gh+i+RsNjyEcTY+3xvCDMh+PoSCAxslybenpAifF/W
         9/dcQ+u41eeqbS2/J/7XP/kxqGKOA1pU5I5ujt2XFItUefU1BeufOWpPsraj6AFDJjFn
         kxs4y+oj7f1/bq0rLxiARLnNrwTHXHiE+kcBjR2ocM19uwYF7aEQKIQY9dx/7UNu75mr
         H5+woR2mi5Z82DTwjdsnKh7Wfc7wcmTDdvq99rvQNCQsf+uuqEgfuXk+Xyyyn2FspiuO
         FbVYF/dWZPQAAQJjN+EKnLUbJsEzCU36HApRenFypqIu/dPzaHPzgWcWZt7C/Oq2DNmg
         2QkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=8F8DPv1+8kXX8FrzoNjsuCyL9jUTbkIPz4J+MH2Hlts=;
        fh=9eFgDjXNZZJCdSvaijTCD67lxeDTua2kWIw+zcw9vkI=;
        b=iQnPvMI5uCYepw56Kh5iPORkMz1zehLVo/MVrZIvmLEuU9aKoRSviMaEWmZQ2QDlE/
         Ly1vqTCck+RtARYpS31yH0Ry/DGD/9DPYE3ymdhQCz48W93xR/7KWbNtTjeL5cFW/8Hv
         UAONa+rFnbTDUtlUoJLBWailJCPCQIpdB9sae90mVjqdflL+11giT9JMVac6Y/QFSc5a
         9bCON0ztFYLXKS6F8AMOlIKlOjtY1W9F2EUU7hDjuuCnuLGEFWXXjP8k1Bvr3FzOsyFh
         NV1Dgni+6vso5nIUWjCM+OykcPPrz1HKR+VK6FSBUZnIcjFwJhpSmnynShJ4m6ZrPnLd
         I/Tg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772074798; x=1772679598; darn=kvack.org;
        h=to:subject:message-id:date:mime-version:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8F8DPv1+8kXX8FrzoNjsuCyL9jUTbkIPz4J+MH2Hlts=;
        b=IT6c015oqiVIx9ZD6mTx4LnSLJxu91mJYAkwedAGdfnZQi1A3FeiJJFTXcINz0GEEh
         iez3nH6rKAylo3YvaYGZEUxeLb3GagnTxndOUhMiPi/oQdE1+NgqYxeFQMmVwPbWTzGB
         lVGwxu0cfYDi8hKKcBU9k629jEecAQGNkTsYVWkvLSCFG+eEqYNnrFBdKbme9RybxY0v
         FM3sQlsxrqSz0ArygAHH8yo0LjEhv4IyJAB+O7Io39/+2qIN4Ap1xRmzTUShc+RWbIi7
         BlfyWzpLqAWNdt1Dz6Glv1/wwI1sRvmwumNcekaeUDDSpSCFwOCkcQoMTiw5iBPcdhNL
         kByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772074798; x=1772679598;
        h=to:subject:message-id:date:mime-version:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8F8DPv1+8kXX8FrzoNjsuCyL9jUTbkIPz4J+MH2Hlts=;
        b=GkKmtlYGWGxexha3yps0u0a8sU1u0SwuG96mTG9CMfXWeQBhSfdHZo3D1HdBJ/DY22
         E60QE4IcABEpctH962DpNxzrRTGndXZjOxQfnLgpWhEKxeUOH288DEvYDGVSGpWEUkG0
         PVD8P1Cayl8sKGkOvij/jNRZEEqFjqM3wEhz5Iwi6f8vEcZG4j8a6rBn4P2uU9VbvWlt
         ExemqC+1iLNQtXRU82aw2+1LqWmow2+L4cNJzK8OR06S8J2fKwmTRYkzrVWWIyYy4h3F
         McnBtsMi6dJqwtXKq2KVyfgcF12fj6uSbPAnJaFcw6hBT0yTRcG77obvbsmxvTT4QozJ
         F+AA==
X-Forwarded-Encrypted: i=1; AJvYcCVFhUUZSSQbndAiy9I2FalXGocceHkJlY1trf94mbDQttnep2n9dI92pDNr/dKBDCn4RNkQN72S+Q==@kvack.org
X-Gm-Message-State: AOJu0YxMvXgMvJ0eicPHt8Uroiz8A+0kCVehrPt/z+GBgiOImEo95Wj/
	D2uFx8FDdUGvsmvPNAwnCXjx6G8NbOK/RmNbg4q+YSLbHHXoDtBc+dlX4/gyT0l70px4aN1eTOY
	qkDsmTbDG6Q4ThmNEeNBI8uzFuKy+QWwJSnbjLLk+
X-Gm-Gg: ATEYQzwSa66Xd4/ayIorTFPx3O19/VfciVtc3ggdElTp6he+/Vz0OS5bpPVOPrW4TLM
	uF2/CodS25QG2MYtHvAih1zUP6aQR7JL6bmr166inl+vYaBPnwn8KmDtd9C9T1irSKKkea7Rv3b
	oG1Vt6Z6RyWv4RPGHGcjroEKUjUQQf6SYF38qRSGfgHyaazntQrgVJBOWbvQX/4UWeO8V3qZ9RR
	hie6RAO5xvbqDOmUcJSYDu1tgxjhLnquh8P0MihEYq+lg+vJJYR7jkH3/27F7dq4U5cwNrwFt96
	sYSls62UQw6HhEMEN5P863Jmkt3i0kt3XH7cehSmIFysCF7gwavTxOg7UdqxaWRxZbGucA==
X-Received: by 2002:a05:6102:418d:b0:5f1:bcb3:5577 with SMTP id
 ada2fe7eead31-5ff20c30c12mr353313137.32.1772074797488; Wed, 25 Feb 2026
 18:59:57 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 18:59:56 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 18:59:56 -0800
From: Ackerley Tng <ackerleytng@google.com>
MIME-Version: 1.0
Date: Wed, 25 Feb 2026 18:59:56 -0800
X-Gm-Features: AaiRm50M8XWgDMJ9cOTMEwCcIKXEzhH3SzAKiIj_3KCzzjf8AvWJgkzJ68SfaSI
Message-ID: <CAEvNRgFvHNH6GwuY5yLYD+0OK19mC3pRJKDBR=HsKgym=rghWA@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Opening HugeTLB up for more generic use
To: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: fowii6aywgpxj9ne9snowqzpk8pw7qbs
X-Rspamd-Queue-Id: DDE8E1C0006
X-Rspam-User: 
X-HE-Tag: 1772074798-387029
X-HE-Meta: U2FsdGVkX19rnZLLfMuCMPI3ubmdzRpmSJzSgSHQH3A2JXk/ku0OpT8ys7aO/8HD1nKEaRzRFf7T7Fvwbt4LYflChlLrD9mVhNz+VGogkx3iXe3aeLPHZoAqJEZzP2ceiUpy/Lz2VVOTLv5vR9mEt5c5la/wvAoqSVFJaD3EDR3eJf1yiqSPGceusq24yR70UXReegN8na7v3Bre+x8Aa5Hd4npYR8S9oWPdvub4NGLg+edtf/og1SVfwVNInPeXO/Wq40QZoFbOlJ3cisZ7PTtfIl5ZmtYXc1JfF7cL0tI+gR02RvX/alk/jmuz8y3u6mt/mu/lKX4it6oqu0VbVduZb1bSqW5Ottx6CaEFb/2VdNFmAyRkRwKEsuoAbc4egdfQ45g/mpaw/BXH/tL+mzQKfeg8DzORA8Q7vVlqTXNJW8pSc2m+zjJTpD/0cf9QXG98QdNtCipsw7BNprJypqxHusyBQ7r/TndMUVZyJPsGMmLGolmJZq+35J+nVoi7J0n63CzENBUaIPaxOEP/F988QuxBHzTRtWMhX05phfjDVxtRDnYLojhE1agt2tScqB3CWcBLiZI17esVUAZtBHum74TauMxjY1jFn0wEJ28Ajgt75pRyYX7PUptdqCS8pHHE023PwfjuqJl5Abu5ZwuUzTAaIbh+Sdr1z1w06SNwyM4xszc6X9VhSmKL4J2Mkq5lyMf1W3GptLKPzxKBzoMAzVckfRJqkP20z32lPy4E89woDF09+wfwTamd6jd0UM0DvToIyjtmtJcsR2StnyH7VK4YRzrr0eG80Dj5Vx1MeQk+dLXoXTx5UXorCOdcM4Nkd/yxgcYtDCPcCegb/WQVo8WEwqPN6R7TB6q4rC3jm23265L3Pse4CWl2N0woFQVbtbH8wbGzc7+PuoF5jaJ9+Xpn8aldVXJRepqkbZGEaftJDxCmX+1P7X1f3Yr0evz8vXTjUUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

I would like to propose to open HugeTLB up for more generic use.

Motivation
==========

This proposal was motivated by guest_memfd needing to provide huge
pages. guest_memfd wraps existing allocators to provide memory for
backing KVM virtual machines, and wants to use HugeTLB as a source of
huge pages.

Proposal details
================

The proposal is to (re)think the in-memory filesystems as memory
providers around memory sources:

| Memory Provider                | Memory Source            |
|--------------------------------|--------------------------|
| Anonymous (mmap(MAP_ANONYMOUS) | Buddy allocator          |
| Tmpfs/shmem                    | Buddy allocator          |
| HugeTLBfs                      | HugeTLB                  |
| guest_memfd                    | Buddy allocator, HugeTLB |

While working on HugeTLB and exploring HugeTLBfs vs HugeTLB, my
impression is that these two are overly coupled together and could
benefit from better conceptual separation, as well as code separation
between mm/hugetlb.c and fs/hugetlbfs/inode.c.

Status
======

I've been working on guest_memfd HugeTLB support for a while now, and
Google is in the process of qualifying guest_memfd HugeTLB
support. Here [1] is an earlier version of what's being qualified.

Here [2] is an RFC patch series, split out from [1] and updated, that
refactors the HugeTLB allocation routine for more generic use. I hope
this will serve as a starting point for this discussion.

Goals of the discussion
=======================

+ Find out what the community thinks of opening up HugeTLB as a more
  generic source of huge pages, not coupled to HugeTLBfs
    + Get feedback on guest_memfd using HugeTLB
+ Find out what the plan is for HugeTLB(fs) testing
    + Is the plan to continue maintaining tests in libhugetlbfs?
    + Should the tests be migrated as kernel selftests?
+ Gather key components that would need refactoring

Requested attendees
===================

+ David Hildenbrand
+ Muchun Song
+ Oscar Salvador
+ Peter Xu

References
==========

[1] https://lore.kernel.org/all/cover.1726009989.git.ackerleytng@google.com/T/
[2] https://lore.kernel.org/all/cover.1770854662.git.ackerleytng@google.com/T/
[3] https://github.com/libhugetlbfs/libhugetlbfs/


Thanks,

Ackerley

