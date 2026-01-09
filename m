Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477DCD232C1
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 00:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E206B0005; Thu,  8 Jan 2026 19:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A22936B008A; Thu,  8 Jan 2026 19:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920856B0092; Thu,  8 Jan 2026 19:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7B76B0005
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 19:11:34 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 306ECC18BB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:11:34 +0000 (UTC)
X-FDA: 84310496508.02.7DDFFD4
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id A8B2940013
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:11:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NftmsH+m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3s0dgaQgKCBY5wEA984G2AA270.yA8749GJ-886Hwy6.AD2@flex--jasonmiu.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3s0dgaQgKCBY5wEA984G2AA270.yA8749GJ-886Hwy6.AD2@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767917492; a=rsa-sha256;
	cv=none;
	b=VSiEkHocBghmcS61RC9Byp5sGjHyorfE86YELRM+X78c9bbqMIa3jtEFck4yqKdsnVex5q
	T1ReCucHznS9yyViHCwypO9c8HGK9I5Vqhhx2LW0/f49VlNhTGLLnLenIh34GL5iN+YfZV
	07WSuCkkjuVhQT3G31WOWg/nin4rGoI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NftmsH+m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3s0dgaQgKCBY5wEA984G2AA270.yA8749GJ-886Hwy6.AD2@flex--jasonmiu.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3s0dgaQgKCBY5wEA984G2AA270.yA8749GJ-886Hwy6.AD2@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767917492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VNtmiXXVMpIpjKeokSIj374jlcsqfD2I2+s5Exq8j0M=;
	b=V5S0KiEU1Wl6SwK3rWvAPh1mWzb9ohKMV0TdTrhKWGT/rJDpyjh4djcCHW+aZmI8J3sFpy
	MDAgC+BzgrePAxbfVF4IttRyJGHdCc+d2d9hTl7x2o8m8F3ZAD6rKdof56BtipByc+N9+F
	cEWYkCFgkamvgY3Y5ZofEFsx+OaxtC0=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ae56205588so4145678eec.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 16:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767917491; x=1768522291; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VNtmiXXVMpIpjKeokSIj374jlcsqfD2I2+s5Exq8j0M=;
        b=NftmsH+mDSiIEG2wt5P0h8vFyz/imsH4AmxTbECQjaAEd2kj7PMnkn/TxxqYzSspCX
         dFgqRTQJKAr8UtGH2Tu/WnpZF4HEBWARWLijxW9ktij44uRVqPo36tlEJFVv740RtQEy
         RuzxLE9qsjxB7g/4Rv4Xs/3DWPn/ZsvyFap2MkYwt0hzFzRqBRFMwWDQYlBcYN5dX46L
         iCN2zkIbJdVs7MJWK1kMgR5zDWYFe3uBIL6wngQp8JcLnFRkpInpnVh/X7xrFO9TlnI8
         E4u7HmkwqwqdZ1PVf8AElVj8zC02uTrReZwoDHc9VZiM9yf7xH/yGyWaxC+Be3xUosyS
         ROlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767917491; x=1768522291;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VNtmiXXVMpIpjKeokSIj374jlcsqfD2I2+s5Exq8j0M=;
        b=Aa7RsCNarLNPeg44+d/OIBjyoXNtLvNyWMLpq7WsyNaau4fvfYL/CEsrVTk8ydK0Je
         L1ZXmHpVE7gBaKKGE/oMA7wZ7IVcZrtvQCJPnDgVCunjYpKTZjz7dYVqxvafPYqPwD+I
         O27SIuKg7w8dH8ZvWVk5YSmTEGo/Y22dA0dQFhVRSeBuYpRou3KhEUd8k1U2m89v3ljj
         E1gixUxsxUdVXixhFqmG8wd9Bce8YxUH1/33SQZydBZjtdN7hXyQOtn3hOt5SaV0V6CJ
         bZMZZsPACbbHM037HybuoBhODMrSISD5NWbdNDyQnXURbrMfeA9HDyOAz/jjwIOOIE/2
         eQgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOaR4EpXzDFl9dtVJVgFkrwkPVmc1Voklo4mMl+cM+acBlfbgKrFusf5j5n2i5Z6Dki9Qlt98oyg==@kvack.org
X-Gm-Message-State: AOJu0YwYUQmUs8JfFkLQimSIf40/9MnNeZzo9Go/tpH77yPk5VmNLY19
	3izWqHAsFb3rmr9lNHeBdyHzd1WtklzPZvRUiG0VVeV2+YHRlF1wx95gtH0CkF0e9+Imxzo/a5U
	q31UJrFRUXy1tDA==
X-Google-Smtp-Source: AGHT+IEg07jJ9OPJkKkmCWjDY4B+wb9xBXz7fBkAifPrpk4fCrC1NnhSeBjwSL6KURgNGGSLzkcOpp7iZv8H2A==
X-Received: from dybnx41.prod.google.com ([2002:a05:7300:e7a9:b0:2ac:1eee:fdb4])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:fe88:b0:2ae:5bd8:1dc9 with SMTP id 5a478bee46e88-2b17d2519cdmr4148660eec.14.1767917491269;
 Thu, 08 Jan 2026 16:11:31 -0800 (PST)
Date: Thu,  8 Jan 2026 16:11:25 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109001127.2596222-1-jasonmiu@google.com>
Subject: [PATCH v4 0/2] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: d4o7sqjxng41j5rj1b7xmibtb6obxtwf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A8B2940013
X-HE-Tag: 1767917492-925141
X-HE-Meta: U2FsdGVkX1+z014/oekcFvWV9/o7bO4NRbCy8d8VS9juLS0XfPlUj9sjMivMMfRknb4zhRnnw/QCoMl+KvQgnS0I6pf5K9ePk2WvjyEXc4yjhqoADeAbsfMU13mFtwp7qU9mxvFR4cMnMNUVakY6+FxpGjiS2IotjnyjGRXwGVMWnSYJYIyI0Uiw/8sbxHh1p0uKDTFI2vCPz9l4Cw2bnI0ChKVa7DauUgPkzjKLzuvjmJxHXJrOEA7qmGLB453R4zNsWmwbQ/hAW5qDiLcQ7cLdmM4pvHC89+FvEVW+38b5jGBpOfRvTVthaBHTytaFy/iXMuh06dOwLlppAevh6zyN5zlGFQ6JQKjITiSlZtcnAag7S5C8dg6op0MkZXQECM2+im72Ff5b8v5rWO+EPqPogZo6oJByH5+UTnlHLEQ1B3x0pJZGE6zJ55c1A+tBPjLv70zSXbxNLg6F67OkM44a65kKh3Gv7W4qOmVhMHlMGsatvCdbFHK5kKEAa11/1UKguxirEZt1FkOzAObb/66VG79HMTuv1WEJYrULJgDD4+jNA8UQsGE2EezqEFubtGJD6/pEuOzUvjZ02I3LSZccRmq5ytgewBORh9TQpILxLO0fvZmBnCZH25nO7N47V+Igo0Q2ORPlH0vtRD7+9gk2M89yq+lrScGSUcbhYVB0Cj2jiyKusS7KCjCp3FCpAN/uTZ91RtB/NGBedkBui4yOKnGrGzEGr2NobFcdz0aRnF5ejf4xhrQAD4S8MS1ecx32ristTgXbSSmgF5i7WFjznhu7SAgPOxFtQnnwTcA4Y6hGl1Zl1hjEhJQUUlqboVTWy5z1UU5iqAaRgFv0lvThRcOqy1s+vYs3nV5Vlm4emhVhGINNynNg+hcndO9ftsx/kdxG4xzUGjxJsJtTvEKwGGpb16/xdNyjQtEbVYggWrdo8ZEj6MAbUkPwBZ+HodZJbWp4vzq4DaUYFlj
 8GxQrgwE
 23cjU2xeY5Kd1FWlePGrsEBO/O2mLkNZzZIanBuUCtBaXrVVtHytUZw/h1Rl2XJElqOwkdQrLxhW4c2hWFslMCar3i/l9R/fb2JxGxs2YKq4JMXiLAAPG+dh86zW3QlQFF9SXUBOtUv1XJMG+aJDDRRvCOgOFmPYyWTNvpNbA5wcGm6ZHXXDgKKau+J/Va29igkwZ+gF+enTzZJwDrIJ7KxTNEllNYLwMt1JAXkYV+a67zzgxQ2N2Eol3MquedTUbShT60hU7QKs0tUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to a radix tree data structure that can be passed
directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmaps where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

This series is broken down into the following patches:

1.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

2.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changelog since v3 [1]:
- The patches introducing the KHO FDT ABI header [2] and relocating the
  vmalloc preservation structure to the KHO ABI header [3] were merged
  into another series [4].
- Use `struct kho_radix_tree` to encapsulate the tree structure and
  expose it to the public radix tree APIs as an argument.
- Public radix tree APIs now manage the tree structure's lock internally.
- Protect the radix tree with a mutex lock instead of a read-write
  semaphore.
- Radix tree root pointer validation and warnings are now centralized in
  kho_radix_add_page() and kho_radix_del_page().
- Updates to the KHO finalization logic are grouped into the second patch.
- kho_radix_encode_key() and kho_radix_decode_key() were removed from
  the public APIs.
- KHO radix tree callback function takes physical address and order of a page as
  inputs instead of a radix key.
- Refactored kho_radix_get_index() to use kho_radix_get_bitmap_index().
- Updated the documentation.

[1] https://lore.kernel.org/lkml/20251209025317.3846938-1-jasonmiu@google.com/
[2] https://lore.kernel.org/lkml/20251209025317.3846938-2-jasonmiu@google.com/
[3] https://lore.kernel.org/lkml/20251209025317.3846938-3-jasonmiu@google.com/
[4] https://lore.kernel.org/lkml/20260105165839.285270-1-rppt@kernel.org/

---

Jason Miu (2):
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst        |  52 +-
 Documentation/core-api/kho/abi.rst          |   6 +
 Documentation/core-api/kho/index.rst        |  23 +-
 include/linux/kho/abi/kexec_handover.h      | 141 +++-
 include/linux/kho_radix_tree.h              |  72 ++
 kernel/liveupdate/kexec_handover.c          | 703 ++++++++++----------
 kernel/liveupdate/kexec_handover_debugfs.c  |  23 -
 kernel/liveupdate/kexec_handover_internal.h |   3 -
 kernel/liveupdate/luo_core.c                |  12 +-
 kernel/liveupdate/luo_flb.c                 |   2 +-
 tools/testing/selftests/kho/init.c          |  20 -
 11 files changed, 573 insertions(+), 484 deletions(-)
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: f96074c6d01d8a5e9e2fccd0bba5f2ed654c1f2d
-- 
2.52.0.457.g6b5491de43-goog

