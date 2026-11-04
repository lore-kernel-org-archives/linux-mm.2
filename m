Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1EB5606A32E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QsBa1Crj
Received: by kanga.kvack.org (Postfix)
	id D1F7B6B05BC; Wed,  4 Nov 2026 14:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6C86B05BD; Wed,  4 Nov 2026 14:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34146B05BE; Wed,  4 Nov 2026 14:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3F66B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:03:46 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 447641C3A5A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:46 +0000 (UTC)
X-FDA: 85398360852.11.4E5AF98
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by imf23.hostedemail.com (Postfix) with ESMTP id 97026140010
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:03:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QsBa1Crj;
	spf=pass (imf23.hostedemail.com: domain of 3joHrag0KCJ078EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3joHrag0KCJ078EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793819024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XMmoP1+qWKtXNy9UbFcoNobznW37r4Fg/NhEAO7nu0w=;
	b=Bzi4zWl7Uvpg0waeRdC6fQ6c6mCCHPn54ETZc81yb58eTQX4/D8UpL2JvCA/Ot3BXLusNA
	6Ii3GFNa21757BfyEawPkej3uR6b00i1cKVQnOD7m4DH2t873po63Q5LCdSAEHNcJ/Y4sl
	bnhS0y6IJ/UbGkYNUre2OuwQH01mcOI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793819024;
	b=gUF3Q4nNjr18V24saajKJqsn2Wl5jKRRwQPD0BskE67+rQOJzSF8uegM8bc+B4h6mD1qw0
	DeitBoXgNXbb0RByILRGOyGyf9eVmPod8htfu0BfhKpLqv+EZ2gDJQVDwE+RW6Ze2COtyg
	IU7gtS5f30H7yuvZuGe8TKfnWnXRCxc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QsBa1Crj;
	spf=pass (imf23.hostedemail.com: domain of 3joHrag0KCJ078EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3joHrag0KCJ078EFPEBH87M7QDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1663fb7e005so1262459c88.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 11:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793819023; x=1794423823; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XMmoP1+qWKtXNy9UbFcoNobznW37r4Fg/NhEAO7nu0w=;
        b=QsBa1CrjSLfG2N7dPTM7FagXTT2Q17MBDzXw6zn4Gm240Ogjueml/eHZmTrYQWIdjN
         odmsnt4vSsOeC7rGzEQEBgVvDO9hd64zIudeP3EUdGEM3lLvcCdlHOFdt+MUgIt/UBPW
         2WM+V5Y/6FpLH7ocyD8Lem5k65ANUmNbfrJOIfGC/KiMwq3CiFlEFKlyzFj9eZGpGgoF
         isRzy8pToYm5gpCn/i0IC9CNe8bQulvGqiVwuUhItSFbDyFbSwl5CKceJXJjIg3Km3dR
         oRUIPazmGwEwIO7K97tQeRivbnwxc9+jbuNBD74hkOHlHsPe4tAxR3va3mUMyCAj9USX
         q6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793819023; x=1794423823;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XMmoP1+qWKtXNy9UbFcoNobznW37r4Fg/NhEAO7nu0w=;
        b=gMJNE6ukCkMxHz/r94G38+IOj13cb1mNt7+P+nkPuBcB1gyorXBgRPsX0NuMEVKBMm
         9p+ZEuicMeVUYYX5MrBqN8kwiDm5VIA4qCB5hNTK+M+mcbQmTRvG5oTS0LAHZf+qnzyh
         bljrIqwslGlGc74IyEZx0XpdDXDxe3CCI8zC22AnCEXDtkjbf383qNqev9G+dVfsc6qO
         6S0CFm/En8X6pTx3PmcoiYK1ULHocKQ7tgI0jlSjBWphZrl8FAzrRuNC5/BPhbkJZX9H
         h3aiD9kuwYnMwDonz6FhmsfTi1d2AfFDHCfxGMWMni1zs5GQiQsEw6pLEr1bO8OlJMFR
         uSSw==
X-Forwarded-Encrypted: i=1; AKwUvBzE0Vveeo0jS1x50hjnn2mlYKZ8cZ7LQHT7ZutGCUT2lrlWIH7bDs8jVZ7Fd9VM0Ergj1KGHdFNcw==@kvack.org
X-Gm-Message-State: APuU4Z/vD1SSt0zA6JoCOLd97pifK5ZgDkg1jOmh6edtFG/+zS13M5DC
	K0C0T+UWDHiF+X4HdDUJ1XFpbpbxP2u95eA1MIP3DVp+sNlHWv7rgyzeFP/iX0NDKlu8kXrV5R9
	yBIvDUUtEiSlW43u043Fujp7HcRjOgsSnkw==
X-Received: from dlbsv9.prod.google.com ([2002:a05:7022:3a09:b0:1ab:fb55:f657])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:2097:b0:14b:cf58:ce15 with SMTP id a92af1059eb24-1ac600d9f9bmr25256760c88.43.1793819022924;
 Wed, 04 Nov 2026 11:03:42 -0800 (PST)
Date: Wed,  4 Nov 2026 19:03:35 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <cover.1793818636.git.abhishekbapat@google.com>
Subject: [PATCH v5 0/5] alloc_tag: Introduce selective tracing for MAP
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1r7bwhtffs4w7ddq5h4pwh5cuk46e5dy
X-Rspamd-Queue-Id: 97026140010
X-Rspam-User: 
X-HE-Tag: 1793819024-737157
X-HE-Meta: U2FsdGVkX19TjcbF4tEBhokl2I/xIbLtM+nW3iSK1KFtuZ7JECL2fQ+Spyppp4O9nZQ+/YxTjHc78D0Yem7Qdhs0wR/cmf0fzYflpgbdKppg65Pxw9YbXHhR5vWzyuCb9UBVysIdhGcg9MU1/LoHEN1N2OHr2eYsnd/q+aOT7tHcACq7PoD501ep4z+1kLPzkCCgTEsVRICsjtZ28DM8+Ww2apHE5l8apKWpyvxA8UKkkImd+M7MGUWTBs/M4jRX1dNVzg4RT90kvjZzD55lvkV0HFzt46YVPRh1uiFEOsrrFSltJjToP75NLV92uJi3barpW5vsy2ioO1O1pM1ZoEvv6xyY1Bnak0Mo883NkLRsQg7Yw1bS3RbpUwdJICP220KpVt94hGt+CICNV8HgNBSiuyBeDlcf6ZADwjhoFuRQ6VDM+/pjOoPeUgFWyZ1LdgJSD0YWm/Xgs6XYzZyasz353YxIflg9ppp5PKau6u3+HxMv1pEentMKUzKTmnY5rVuBB6GAVypuMo0fooKaXnQ2hPWMpkyVDBq2gH3HiZTzjeSvWmhrjsuigskKGpq1QMt4L4a/aisv00A1n7m5uxklMz3jFCuXGh4aknkVj+ay4VdL7YDNvKEciptQC9xVEnqQzg2AGNZ8OtdM1KHdaVEtmi2S76jjrlJashSkHuwZlGZl3GLilFGqueldSVlSMw+9L+bcVNNfQbdFqSHLz7c2vdBoU0bMMFw+VvKR6hi9FrhmSZsQHPl3cmQEmupOv1DPZoFEzwcpehDJsDNt8mJBvvRe+2AdGmhL4ovYkwxtBUUbo+9RBITvcHynis+rMNv33E9tTovWmCJsOF+dz6i1uw46dBs4PXG5iuHEKKGprm2Uf+ChO7Dpx2fO3WTtmTbFzH+WfXn8kt8tpty8IQFvkuKgz6yKMHidKri5kM15Zdniy3jgkAi5CBebRo/VPjFpxt13vYBJCZUTDlw
 hVT3h9HI
 /BiYZgbPZTXniViJN5hfEJn7D6qKHuNj2IRo+w4qAlwO7MzKiCAydTOmOGSrx2Rr9XPEphjwNb7gLazcdAEVvlkvshNQWiVuzE4ZyQQr8POsQfIk6/G3uFSqxXzsSun4qNvaEHRICj+svQibYfpYNZQmRusBxFszIpH6KEfYI9okiqRt84qJzcqJWnlSUnsCc/CvkNKa3tvS4qk4k5akR1lDgZ8aFWMhA6Ubr2ryeM1i4KX6wdHHumocbrAkQuk/G0+Mt+3AiVo2LIi1X94M76Q9OHQfE6RToAtQIntiU/PEBnz24hRITpwxkpRoCaSw3DX9+sAAp9vPQiCqCdxUy/tUpS51Sue9TMzbMp3gQCQ7osBFse6srsSk2kX/u7dGOgERRKBNVjdK+LI3fH17+rQLrEBvJKGJhmVjsNh55B1tZVTzujrHXOWWKK4ZY/LHN89zftfLejYHpCBeyeYN4JV70cYLyvws0kd2qD0XAfrVGDiZYxfoswnm20j2cQgR2MQUlC2NKXGN+UEy1bmzSc7gVydr3IIyrqvkiBmWBpp9wlY0HNswgwTmM/7MWjbUukltZnjuzuCfRgJhBB99oetzyy35h3UEZgli0JxATG2FRzNrE2KN1ytH2NJ0rpm6BMbec7ASuNfuIU2rt1mrh+sFVGg+/ba79XXoDe4YJ/oTOuqwV11ymbWSbww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The existing memory allocation profiling (MAP) tool accurately maintains
aggregate counters for overall memory accounting. However, relying
purely on aggregated counters restrics the visibility needed for
targeted debugging.

This patch series integrates three new tracepoints (alloc_tag_hit,
alloc_tag_mem_alloced and alloc_tag_mem_freed) directly into the
alloc_hooks_tag fast path.

Enabling trace events globally for all allocations introduces a severe
baseline overhead. To limit the performance overhead, we let the admin
select specific allocations to be traced.

A new IOCTL is introduced to allow privileged users to determine which
allocation tags need tracing enabled. The IOCTL utilizes the
pre-existing filtering mechanism to specify the allocation tags to
enable tracing on.

v5 changes:
- Patch 3/5: Introduced a new patch to introduce a flags field wrapped
  in an anonymous union with the old inaccurate field. This allows us to
  extend the UAPI with more filters without breaking backwards
  compatibility.
- Patch 4/5: Minor update to filter out trace_on tags using flags.
- Patch 5/5: Updated the test to use the new flags UAPI.

v4 changes:
- Patch 1/4: Minor refactor, changed macro definition of
  `alloc_tag_trace_hit()` for the NOOP case.

v3 changes:
- Patch 2/4: Minor refactor, documented the `CAP_SYS_ADMIN` requirement.
  Moved the mutex lock / unlock outside the for loop.

v2 changes:
- Patch 1/4: Changed the trace events for the page allocator to track
  pointer to the head page instead of codetag_ref.
  alloc_tag_trace_enabled() no longer takes a tag arg, that arg gets
  added in patch 2 instead where the function makes use of it.
  Introduced new sections in the Documentation expanding on the newly
  introduced trace events. Minor typo fixes.
- Patch 2/4: Toggle traces IOCTL now uses the same filter as other
  related ioctls. IOCTL returns -ENOENT if no tags match and an empty
  filter matches all tags. Added a subsection in the Documentation
  expanding on the new IOCTL.
- Patch 4/4: Updated the test to work with the new UAPI from patch 2.
  Updated commit message to accurately mention that the test flips the
  state of trace_on, verifies it and restores to the original state.

Abhishek Bapat (5):
  alloc_tag: Add trace events for tracing allocations
  alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
  alloc_tag: Add a flags field to allocinfo_filter
  alloc_tag: Extend allocinfo_filter to support tracing queries
  alloc_tag: Add a test for trace state toggle and filtering

 Documentation/mm/allocation-profiling.rst     |  73 ++++++++
 MAINTAINERS                                   |   1 +
 include/linux/alloc_tag.h                     | 106 +++++++++---
 include/linux/codetag.h                       |   5 +-
 include/trace/events/alloc_tag.h              | 122 +++++++++++++
 include/uapi/linux/alloc_tag.h                |  37 +++-
 mm/alloc_tag.c                                | 161 +++++++++++++++++-
 mm/page_alloc.c                               |   4 +-
 mm/percpu.c                                   |  13 +-
 mm/slub.c                                     |   6 +-
 .../alloc_tag/allocinfo_ioctl_test.c          | 114 ++++++++++++-
 11 files changed, 589 insertions(+), 53 deletions(-)
 create mode 100644 include/trace/events/alloc_tag.h


base-commit: bcc036cfa1670a64500f6d857eaa71908b79e3fb
-- 
2.56.0.506.g506a7eabc5-goog


