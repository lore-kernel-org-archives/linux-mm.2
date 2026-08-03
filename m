Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A35C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411FB6B00A0; Mon,  3 Aug 2026 03:15:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9886B00A1; Mon,  3 Aug 2026 03:15:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326BF6B00A2; Mon,  3 Aug 2026 03:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 174FA6B00A0
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:15:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 99D4C160629
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:15:19 +0000 (UTC)
X-FDA: 85059097158.22.D8AF96F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id DD7B91C0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:15:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DpFxADqY;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741318;
	b=ev1bgeIx7PaZx2tJost/p5QYHsCBm0HJkN2zbTk86sIUhM8Ia9iL4yjarELfwtuGLH2poW
	tkSblP8oXcQjxpQlG3Z36meh3IBSSbuSSZA+3RZ5keEVU1Y3kE+AljZGcH98jMn+DAMvnX
	0VynTi/T+hyDhE+0OuX+NHlEk9bJvL4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DpFxADqY;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lOw5vekGbjNw6ykDt0fzbiYJA2c7NYGfZyY2lgJKOak=;
	b=UhA/SlwtVvhokYVSq9BL/cnCP2RM8bfV1xY0T5VpdwOjxuk5q9ylsiCzMxH4gs4Bw7z3d9
	0J2Ar2a35mH5LcmFSU3QrbWuX0j77uuDLACKWrt9JvkuCxlziX8LSkXxOCBccBO/Fr5QDq
	kWw/DxqvRRATE39CX0L0I/cE6OiXhGg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C365041867;
	Mon,  3 Aug 2026 07:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09371F000E9;
	Mon,  3 Aug 2026 07:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785741316;
	bh=lOw5vekGbjNw6ykDt0fzbiYJA2c7NYGfZyY2lgJKOak=;
	h=From:Subject:Date:To:Cc;
	b=DpFxADqYOi+VHQ+Hrpil882FXtGQulPwbpCRjtbBGElPW+ao4/mQfksudQQLthqF5
	 pkVTVUYOo5vZhYepoOIxvvFHOtkoPHMo/dz57XR7S4sxJlyoo9A+w2q3TJou3wKf9U
	 /AQhkfpmmahTv41Cm0E5We5ZQiFqkL1bhX55rKzwMVJrb+NUrLf59e51n0xMXGD/Hz
	 xDMCGpqeCUp0V6KrAcV6FiqZLg5sC6G1QlFj//4EYFd3DMno52+L34cmZHx+tz/qWw
	 WM7JxxUZlbEz2fzVoZZgGa5+tV3uZ7QPEakf10G1xJ7OLUMr8rSAv+EgrxhPs+8xDU
	 RgY5si8IGAFpA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH 6.18.y 0/2] mm/slab: fix unbounded recursion in free path
 with memalloc profiling
Date: Mon, 03 Aug 2026 07:15:09 +0000
Message-Id: <20260803-kmalloc-no-objext-for-6-18-y-v1-0-8b01d1021f0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQ6CMBAAwK+QPbukrbEWv0I4lLLAKnZJawyE8
 Hcbj3OZAzIlpgyP6oBEX84ssUBfKgizjxMhD8VglLHKqSu+3n5ZJGAUlP5J2wdHSWhRO9zxRqa
 5e9cPTdBQijXRyNu/b8HW2tU7dOf5A0OcH2x2AAAA
X-Change-ID: 20260803-kmalloc-no-objext-for-6-18-y-5e297a8bd9c1
To: Suren Baghdasaryan <surenb@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Kees Cook <kees@kernel.org>, Danielle Costantino <dcostantino@meta.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
 Hao Li <hao.li@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 "Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DD7B91C0006
X-Stat-Signature: 4ma4y155h9notrnwxyqw97uskcp4d8u6
X-Rspam-User: 
X-HE-Tag: 1785741317-4389
X-HE-Meta: U2FsdGVkX18w1NmTv/nYDOYI1J3N/lHvTZMykg+f9lSNJtd/drdgpfw1P7Jz49c+r8HRgds8Gva/kmL1EYaUB2x4FQxn24JjNmf9M0Q8FltIF29APJAadYETMnHP1pUAm6nIrjsuVaXF3kewEJ5i1bGuNxco8Y9X+80Ky+Oe7PmGsEXF62B0cDAo8w9yaar4epp+5FCo4djnzPkDkSvXGfXk5BtRbnArYB2+4gaLHbRD0PmFBj/jbOAWG5xPIZfI9gnkPqMDOHH6hafUiLndeD8i32FxEyc9HQAU1To+80VPUPmf9GYISfxGBltJz3VLu8oY4zvqLOtE1aTlK3sq0aSwfSY1sC8gObjuC8OnYPpXQkqQ5c8Sp8p7fcMDjB+r40BYw52QOlU627OvdAKIe4KnQuE2IQcOPGNXpHjWKPmZMrR3O9cOfwCzDL5LVLQN16iexNp5oxF6l3ZIUmbE7H0FIrtZZg9Qq+jcdm1OsD4xWjeFBDWlzUjrBl203epLCZFTSNQpRNQZ3LhpLC/tjIP0OhagOozERYjxwgVqZd4FWBiETx6tVou1j2xxHvpCcsO++gP53MlVH0heUyZ5w0Ro+l3lsLKWr7HIofkQSA8+GP/tpG3yG3vb8BGY+WsSLaynCmorjMe1mjzwlEiGS78m6MQJTgl9i3sJQLwxSPyZhvKYxW1DWhYZWIEf/eoDWEoimIBSpEKcBtmO7Y/Wc+fgdEex4u6cgf4s0nQ5914fG6tIIPSxzoBGrZGXI7yKln2Uk3SfpXvSoL+/OSFRAr8rf/gvOExgsbf83GlgydyEV4lkd0LlsXENwtGrgYg+X7Li9moQ44lVMRmUdZMT4+mxOqZ4YkfdCAbsgeOGPyF4KyZPOiwNTEi0NLQbe/j3pQnHyMJNDoRKOCQAw1hNXxC8ka1eNfbNib1NjKf7b9QBAqPkgelGEZi6kvyUJBFCUOAr0tMAv4dsc0MoQs+
 EaOwzZWK
 7WOe4lGE09PnYNjh8bV3mTSaJIgYlKCPEqe/+oaSMWJu4jep7+o7hHpxd03wKmV/u+KTd1RT7Z+wW7nvOJS9ReO7HrnM6LU2Gtuss068UYL53BOoLdZYBtSXF6/jv3/jp0LZ4oscEcIvr/YSQA8rcPkeMuJyLMY7hu6lPmnDFyNgsePySrtAz46E5HYQ/L/w6uCCnO4JJy+EiZ6PNaJyayFEEUAjZTdp3ppG8ytfu2fhphJCFMOUQJm2u0vHu3IdSoNZlP8cjavgExUqqYfTS+AiZ7wQGbvVaueH79kRJwcIiTwpdIjD42tL6WOTrEoCfWd6TpqqijDCT4OIdHRmA3s1XzVoAC8yGU1ZzjKthvjhpf0xmmvChpbGaU/Nj6jluZ/pR6qjawO5LKCGfbl6G+gmsFFmHQHau6Z6M8SmkKY02cmH8exjCu6Yuf5O9igruul+5ynPZvSLrUBzsi6L9rX2xqd1YnKUS0xwyz2dHQ5xhfPlIJFZyW7Sop/uz+WYorjbqbeKUhvysme/CiQSuX1KGuOYow84PnIvYgAZjOAPokTPHYz7FS0oeZ7XoXa7OH1FP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is backport of "mm/slab: fix unbounded recursion in free path with
memalloc profiling" series [1] for 6.18.y.

The last patch has a slight functional difference compared to mainline
due to lack of SLAB_ALLOC_* flags. I described those subtlties in the
backporting notes in detail.

The first two patches from the patchset are not backported to 6.18.y
as they are no-op in 6.18.y.

 - mm/slab: fix a memory leak due to bootstrapping sheaves twice
 - mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT

[1] https://lore.kernel.org/all/20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org

To: Suren Baghdasaryan <surenb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
To: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
To: Hao Ge <hao.ge@linux.dev>
To: Hao Li <hao.li@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>,
To: "Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

Signed-off-by: Harry Yoo <harry@kernel.org>
---
Harry Yoo (Oracle) (2):
      lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
      mm/slab: prevent unbounded recursion in free path with new kmalloc type

 include/linux/alloc_tag.h |  3 ++
 include/linux/slab.h      |  8 ++++-
 lib/alloc_tag.c           |  9 ++++++
 mm/slab.h                 | 28 +++++++++++++++--
 mm/slab_common.c          | 13 ++++++++
 mm/slub.c                 | 76 +++++++++++++++--------------------------------
 6 files changed, 82 insertions(+), 55 deletions(-)
---
base-commit: 2fe596715f840d053aed5cee5455f701bdcd2b50
change-id: 20260803-kmalloc-no-objext-for-6-18-y-5e297a8bd9c1

Best regards,
-- 
Cheers,
Harry / Hyeonggon


