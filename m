Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D92FAE9A049
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 03:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C98A86B0088; Tue, 17 Feb 2026 22:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45FF6B0089; Tue, 17 Feb 2026 22:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52326B008A; Tue, 17 Feb 2026 22:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF836B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:44:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 353208B8AA
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:44:22 +0000 (UTC)
X-FDA: 84456184764.04.F339C42
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67A29140005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:44:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=C2dwOToV;
	spf=pass (imf26.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771386260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OizJYsHUor2RnnhJFFaJDcXjClQ0nP/mCZL/njlniiQ=;
	b=SwleB8x/SU6WP11weKIcF77a57LZBVTrVLk/4MH9eou5ZautAlaKaVmBU1T6UWTFjIxv5o
	1xeWDQGw4aRUPmLcH/qmB6auspn2HuoR1WNe0WqovleawPSgY3wahKdwsJAGvyR1rkhQYO
	8kLkF7uoKHKJQIyUGfQVUjPCtgSEL4U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=C2dwOToV;
	spf=pass (imf26.hostedemail.com: domain of chris@chrisdown.name designates 209.85.216.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771386260; a=rsa-sha256;
	cv=none;
	b=BCv+x/jHAB+G7OswEvvieihRii/PI31Be/2Gg35kXct7GPKbtrIsaYPX7Pe1RzbAvsRhak
	NyAuGHj25LOU4Hu84XjCGqDVXyHWbRumtvOf5dxqwX/Wvu3tXHLnYxRrEltzxju8qQwxi7
	oDBcIe65paeXgzNBEqWcwGCJIik2mEM=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3545d66bb3aso2523383a91.0
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1771386259; x=1771991059; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OizJYsHUor2RnnhJFFaJDcXjClQ0nP/mCZL/njlniiQ=;
        b=C2dwOToVVOSmFXWq154JtOTBEtKxgehnOcKQRC4nNSJEWahl5Z8Uu0j+e4fuHwE0pU
         Csn6Ti5SiQHHNx4euZbyGZ73ZHGNKfcrrKVHxHMubV2JU1hevM7/B88Ees7uS6DSYwGO
         qymR3TdPA5MEhVkAIadgaHwBDn/OpnxRZEPVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771386259; x=1771991059;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OizJYsHUor2RnnhJFFaJDcXjClQ0nP/mCZL/njlniiQ=;
        b=jhEnh6Jt5QgYyr3rpXfhuluwc/NxhCs5Q7hOgzrPFDhbFiCSWHYHGZhRCmEc6g93O7
         ySXLXpdAQc5mzj81SCj4986Rm16ysT7MRf8B2lEzaVlN14hprph03lHiwhc1adGbmqLO
         dFemoelLX70KYfE8KzpcNQ/vh+xIQSYWFZ6mlDzrqgkq2MknZPq9kwcmyZ+WF80k96p6
         yQ/PDvJrBafGXDGO5g847LI8F7heodeANSzw5jI+X/VM42Pncjd2OjzJdIZiKVk4d6PI
         hxSJfn65DlPE51c9+NtWdlzMjsZj4T3CBnxMt0/VxcmPMtw+xcW8ZY9aQo6eTiNwsTAv
         8arA==
X-Forwarded-Encrypted: i=1; AJvYcCXVDdhYJf6xMM5BMMChh6AwN+g5bzv15o4gjRVAHB6BdheB5nQgoZi91oIEWfUhUX1zY9pTgOOjzA==@kvack.org
X-Gm-Message-State: AOJu0Yy7zUwuCj57VHwT/7Ol+lscq/zVfhQRVgVipOhDVkMQvctdG6kx
	DBw4DgW6XwEO2d/4wglnh8aysQ66NS+dtEJpRswCEIVjiKL+eiTnBDqmNlqJCWTX1dg=
X-Gm-Gg: AZuq6aL7itPncv/tmlL1hHkiBX4fKw++egFBRHV+HYb/6GNttHuz59f0ZjDiDXso5TR
	ItRXu+x2yQX5VKYUhdOgxK8xLb+gGs9UsY59ZUMtcQ05vfXG45ctp6FDmN9+umcbQ4yggtSac8J
	mww923iXelVyoD5YV15XAo6J0zZiMdh3rxCqPBwSdo3RiQ6QVK/UTi4dU4ZDM5LWIJSiInqmI/0
	hoV2lwrNk0QLt/tDsv9N0bOCSnK+B5R/QeGnxuAkbONNQZq+l9NctB2GKouebLMV2lFH2nwjvTj
	VNqkSBYxpseXoh7RPAbUpOk12ieLCnjxyMFkqu6FdBUBJ8/O9+oWhlsEmcVhExQbE4pgvmXHsGK
	5nbfd42qDzqEV3NXgcFCyAMoS6xwiT4KYEayLP8Pkf5+uizjdMmxME8svGil2wGh6jes7TTGVM5
	Jlc3a+jpXbaRMnEv/dzXeh
X-Received: by 2002:a17:90b:3d50:b0:354:ad98:7d1c with SMTP id 98e67ed59e1d1-35844a354c4mr11528304a91.11.1771386259008;
        Tue, 17 Feb 2026 19:44:19 -0800 (PST)
Received: from localhost ([175.139.248.66])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35887899158sm388475a91.5.2026.02.17.19.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 19:44:17 -0800 (PST)
Date: Wed, 18 Feb 2026 11:44:17 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 0/2] mm/huge_memory: fix move_pages_huge_pmd() for huge zero
 pages
Message-ID: <aZU1kTOLcrr-Z371@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspam-User: 
X-Rspamd-Queue-Id: 67A29140005
X-Rspamd-Server: rspam02
X-Stat-Signature: 1xjn3baa4pzt9166p8njent4p1ac7c7t
X-HE-Tag: 1771386260-767956
X-HE-Meta: U2FsdGVkX19SG2YhxX9PzYI/0v5ssyT+LfdfwGjidOCiI9jvuKA4GGUtswJqyTKUnN+mk00AJ/JoG0DEToZv1d81b7YhMi7s43eIotcwyP9X59/pyIeNJJZidUIQ00WrqCvRfIVb9gGv+P8FIwJ/8ATbJMxlhZ4J2Cm/MjY+QhShjCXGgULIh5AKIL1Cq0EDH1LlGhzp7K40OAnJnDfQxFAFBm1op/eIO+iMe359RJSDxObeTb4CpcPmYdvDBom/DXt8Ve/k2v9pHYkp1nqjHKvfG2LSmY6uLUARaSZ6uYUbbsAzM+YzPWhf13ov/nNxkX4/BNONfpwV5nPexY+WHJ9ey9v79lRsOFdTOretyZprz0GxdKzycTaPug0EXEF/ohuzH1ppkxTMKlI2GXNeBBtP+hyiTUPssNf9z/D+rrv3N+8dPJCeQBtTKF431Fmr3ZKQuC275GRe6jPMp4HLQF1msv1wtrg7QEphmm07/6ltpQ4/RPU477AAOGG03ZJlgvWhJDGbaOAWY0N3eiQJJGmCR8b2Xf2iZ7mQQmtzpVVJtHx1YVcKvk6cbafyUTgsoUmRsPzSJGiRP3ul7nTf/GkSr5u0j+IBxSi/QeR+NMwMCRJ5yas6irsFJy1AtFTjg+1tlWW6gKmr37yYzDzVYrC9bcKpqhcQSSBfu2Ho7O8DidMOkryO5J1ASiOx3H01Eb9mqFkTyVxMHByVWN++HDnED8z3YP+JxT+LdUGtuMOwzx8Hn8AsvlQvey/P3iHd3d9iAwWtUhAiV4IqRNuql9VC/Nd+EPKeM5ZkFFvy0lYpD9UvUiUyZTzhhZQD5L89ju+WEDW5TNWLTTsN0y99JKjQoTf9qCgJmEu1JErKw2taIkUJ4vjiFAsKdqC4iHppR+0lQHvvoYPV4k6HLivhLjxGO1mTPjkVppaFor7KhBQG7NYE0wYfCnj38/5lEm267RP3Fw8b1bNI8I8gDqa
 Un3pMMdo
 zrrFFkfOag1bCj4pAB9SS9uL4c5jg511mQV1pM77EwWTKrcW4+UYomaxTW6utcS9U6fxLseUSyYhpmIeVTqyfvpXueLtB9vsZ0yceNLHSoWovYGV6CwaBk/pq1fJMgYVgPPdMOaVP/m8O+/vnhCYt7B9uBB3O3VzSXHl31FgfTXMD4Zu+dzVelU9Pc9uVg3aYCTSjhOiRD0Gk0F2gUm+hl55UV3/2g5VVP17W4lqHeROGGLyyV3dRttgOuHT+y6DmzN4SbEJygm53FEJ5yyGPyNy+araAO671KQABZuzPkaPcAw2PLSbsnOOLpa7TbjcqmwLHNDA+98bFMaXzEKIOpdzQh3DhF4s9VTNF28lzWK2pfJOBbt9jJ6FR2dpIQdFkEZPo1cAPxfpXdNRYCjV65a/CLOF3OP9P8wvKZnExYK5sl1vltcrpv3hm67c971KUDdPRXKGj12mZTly6Us/fmzHibI5ri/rlOv7vvAmhv9DluvtTAqnlvj4iY7+mE4hPMsLBcYcCH/z8Ens=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two fixes for the huge zero page path in move_pages_huge_pmd()
(UFFDIO_MOVE).

Patch 1 fixes a use of NULL folio introduced by the folio_mk_pmd()
conversion in commit e3981db444a0 ("mm: add folio_mk_pmd()").
mk_huge_pmd(src_page, ...) with folio_mk_pmd(src_folio, ...) in the huge
zero page branch where src_folio is explicitly NULL. With
SPARSEMEM_VMEMMAP this silently produces a PMD with a bogus PFN, on
other memory models it is a NULL deref.

Patch 2 adds the missing pmd_mkspecial() call that was omitted when
commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero
folio special") marked huge zero folio PMD mappings as special. Without
it, vm_normal_page_pmd() on CONFIG_ARCH_HAS_PTE_SPECIAL architectures
does not recognise the moved huge zero page as special, incorrectly
treating it as a normal page and corrupting its refcount.

Chris Down (2):
  mm/huge_memory: Fix use of NULL folio in move_pages_huge_pmd()
  mm/huge_memory: Mark moved huge zero page PMD as special

 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.51.2


