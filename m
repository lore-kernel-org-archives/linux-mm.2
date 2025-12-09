Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B00D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 02:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6C16B0005; Mon,  8 Dec 2025 21:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87E26B0007; Mon,  8 Dec 2025 21:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D8A6B0008; Mon,  8 Dec 2025 21:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B702D6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 21:53:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F5C589EDA
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:25 +0000 (UTC)
X-FDA: 84198411570.02.B2BF321
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id B462910000D
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:53:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aRetVIf5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3Io83aQgKCG8WNfbaZVhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Io83aQgKCG8WNfbaZVhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765248803; a=rsa-sha256;
	cv=none;
	b=EQ2iW8JBAzXPBc6JqtC61FyavMcW+V7CyqjNZoS3u7wrszXxpAUs4cMCOi50waAxvVuLMg
	E5OYHKQpL/LU3H2923BuEzHTxzXIF4N9wlaR8APrieghQ6MjYRxdEV19Xgx+gbf29y3xJE
	cqNvlkrMWW3nLLn6BSaD4Rrr365Q7n4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aRetVIf5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3Io83aQgKCG8WNfbaZVhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jasonmiu.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3Io83aQgKCG8WNfbaZVhTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765248803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=f9gZ+HAcVYxjhk69z2YeZ7p4VDGLij0no/oxgM8IiD0=;
	b=GwxGzqCaICAYWS1hCLazZSrNh/O+0WM4FGs/4+wcrlnIAo1MFngW/XdsK2sYtWibiyLuhu
	4oYxdSlHk4rQW/ZdJk7pRdSxGv42isa8Woqj6FMwEbLm2xpQQRTircHek5CZMpuJmx4bBz
	P1s17+62NlI1D9ehpqy+IqzUJg8fzNE=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-bde2e654286so4499736a12.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 18:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765248802; x=1765853602; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f9gZ+HAcVYxjhk69z2YeZ7p4VDGLij0no/oxgM8IiD0=;
        b=aRetVIf5mUIfOqJ32TfknSb2DzLrMn2SaIRt98X1NrxY7HEseVQEHbJtpJdWke77Je
         NtcgwoT7e8ZrkGcVecQp3HXBCWx6cec7oJLQSmxEDXpPGcoCNGJ3zoaVgLjUkFRWU6Hr
         xPVPfikKM79ch6p9Hcx+qHA+Hwttfbxy2I4fKJ0I0pB6aTKimWCozQH4F0AQmTgLgkpI
         3s8ikCB1RNU9uBAi69nmHyynYIINcOl3i6qjV2Wy+5WdOxF9c+35hN7rjDP6YTcfMwYX
         ZHqdE7PHQSyvUv73dY+CiyR9SO8do81mWcUG9TWSCnBk/dx5S8YAwRE01V+jtL61BwSs
         GZPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765248802; x=1765853602;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f9gZ+HAcVYxjhk69z2YeZ7p4VDGLij0no/oxgM8IiD0=;
        b=jyD5Xyil9N9qYttYlQ274hAq133qwaUG9HbcODowoVR4UnxwuoG1hofP3gkyY/LyYW
         Vwf7HOBYKl51a+5teeecNVbdpYchPYAo9bqdKgJq00zTGxifVpmVMWeU0uzhHZ1PdcgB
         xAM78k94KMN1i3GoFE9BMNGh1e5UxwCbwSaYx4DEkWS9Sd4TttTVumoCqKTWH1dGEGAd
         F/33fE5ZQzX9sF3wo9i4LHLuPlWm/hXlavB0/+W2EaN4KUPdOAJ1ugpoM+ChjdIfSSQd
         m+DDhCWA2Nn3xz/U41hMR6GdF4N5qGJHmZlCoYEtq6HRjWvqWJQV5Cvli0zJ+jjBhTMx
         roZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMnaGx+xh1JsYj6cUbu2Kwub1dwXWp6a6vhNLDW8xBgs1e0BKHKR1bBpdRUNUxJ7y46wJpgqwIXg==@kvack.org
X-Gm-Message-State: AOJu0Yy7RVuuaXO8anqH2M6bmgxF5g81zCo1xotyJ6R5ESX63vvtAd7T
	rjfsq0INk4v6az/4QuTKqJkKXFKipWd/CFUhW0c9vCoh9tnZ8e0rYZmyLCgtI7BzyDNXT3XV2GO
	p1+lvU3IJilBhvA==
X-Google-Smtp-Source: AGHT+IG4gpI9zqTEOKN9vzBYmrGxjK0E+Np3UyMM98Hh4RHj2KGXooaQHcs0e+c2q3YeS6uW268akwQ8U9IxFQ==
X-Received: from dybtr7.prod.google.com ([2002:a05:7300:f547:b0:2a4:50ea:8fa8])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:8807:b0:2a7:343:399c with SMTP id 5a478bee46e88-2abc712a148mr3561851eec.16.1765248802275;
 Mon, 08 Dec 2025 18:53:22 -0800 (PST)
Date: Mon,  8 Dec 2025 18:53:12 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251209025317.3846938-1-jasonmiu@google.com>
Subject: [PATCH v3 0/4] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B462910000D
X-Stat-Signature: iy51tn7ixinshf8z3ytfzeawizp9np8j
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765248803-474851
X-HE-Meta: U2FsdGVkX18EXJ6CYqCM4UwdrjIkySgfYYQyFsJmtlC6O1/hqzjhV05lrkE/cTU3PaiUzHMEi/93wCfkx3idxkJbLFcTAwjetZycVclNzOT0WYPy3LJLSX5Z5LWJgNDj6Sl6qON5OAFipFUkFi8JlkgT0ahqYCTb0A62PyWZqR7FZe5iMQPdHdxyfATd3rKwo91sizNquYGnsondmw+cF2KhWP2vaDeUmpLMsx3ikoz5VUWmcTaVwl5/pWPlenq1jODM3bWg6QTYvaZPoA0kB7iB77RMgXU70Q7fERNUaIwOxc5lkM/6HvXXiqu6USLGUN7BWXlrUrvaxDgVO7zcUfWrUbz8cbU7bZbbU+Tuh5abajmgSGcSMEI6DPuHX3GCC+PtixYTa5CiCLtmONsAeL64gaEQ6CWG+a96lA5Z+GkcUqCqCrL9K6N3QFGtlEQdOOdkTZd8U+k+hLndc4sya9/rcdsRfhPjoazPpdhJ3ItoQsqAAK4N1gyEkZvqTsgfF+9/C/TfkKhN4pinsxwIg/2A7O0m7djGqpp4Dffd8FmjkbBkB2HDq0LmdgqkwJqUlnmBHnSGAcW8r6ogSlq5IhwjhVtyYkieZitTBK/C7N+m0CE4sOjOyfQWeTWviln1dKrZfD0wR/J3UXkI0xjPTMsvYxN9Sie+rgE8sVVNzt47ZMu16kq4SI/G1pUxO2SXMKRTLVVxLgiPG5gLewZLuJSP+hwXwUC6kD15zgyVAksBSu6YARvrnJN0pulTzi9vys0V+i7ttoVNjkuYTnjhRUjuLajW+UUJS+kbCjpsFh6MDts7FPUfyEs8NPxSNtiXUPYhMqULdpomrEHhzfTuUtQ/tl45xa5seJ/nHSUha4zTbvfpG73lODrPiQRsF/W0PlVw2jtsPodiiibe80lc2Zob3VOrzAanXWzrLO2EWm/8Y1+0UJ/4VKGuOdJ1LpwBFAZsEftiDwyQk8qdo8g
 kQ+h5QRR
 /Lj9l3AiM76v4oW1omjB8eyE2ceN7TJ6nFnaI7XCwsTfR7AH/UQREioszrPQq1lczUeUqYJtDjANg/7F1ZNh43Sy83jFzmwvs5hj5dShGIKwYsFJyvEl9YWC4jp3Qvt5n/G6G7Oi6F8hHscnCnizOn94iTBVGvIUB14mqTxrs+ZnqxgvPZNwju0TN2Jjlj65uzn/1UFXatrlJ7cab2DYxbVnRIxh68WN51Z+fS6qAihEWgzjGhCeaQIdDef9NKNbLLx0IdKD6eHrn//5etsdSlGsa79CURRLGd7WIkSEa6qBHOrHx3XgE2seSLImKp2L1AzTkT85tUThi6Q7R8A8ISm4vkacNwCwUOJ5J/L5a5+xrBJuqeTUHRFvT2cinoaAalPeEQrbfTedp8CBvWS2VjknbtxwrPfAI/CFbegKS287Eyfmz3es9wldkQMWwygqxysgEJM59/+JeH4x6IvDcwBFzpfPK5slMEFV9YJ8z12/2Nf4FkiPTC0t+eAll5dDhyl+rvlyVC89nB0NWdqWfpa0VhI2YTboMxOvzjZwGw7KQW8szU47HdogTi/TozrtaJZKNgT7XaimFbdU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to using a radix tree data structure that can be
passed directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A
page's physical address and its order are encoded into a single
value. The tree is composed of multiple levels of page-sized tables,
with leaf nodes being bitmap tables where each set bit represents a
preserved page. The physical address of the radix trees root is passed
in the FDT, allowing the next kernel to reconstruct the preserved
memory map.

This series is broken down into the following patches:

1.  kho: Introduce KHO FDT ABI header:
    Adds a dedicated ABI header to define the FDT interface.

2.  kho: Relocate vmalloc preservation structure to KHO ABI header
    Adds `struct kho_vmalloc` and related structs to the ABI header.

3.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

4.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changelog since v2 [1]:
- The preserved memory tracking data structures is defined in the ABI header.
- Relocate the `kho_vmalloc` struct and its helper macro to the KHO ABI
  header to formalize its status as a stable ABI.
- Export the core radix tree manipulation functions as a public API to
  support broader use by other kernel subsystems.
- Update the documents.
- Inline comments have been cleaned up.

[1] https://lore.kernel.org/lkml/20251020100306.2709352-1-jasonmiu@google.com/

---

Jason Miu (4):
  kho: Introduce KHO FDT ABI header
  kho: Relocate vmalloc preservation structure to KHO ABI header
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst          |  46 +-
 Documentation/core-api/kho/bindings/kho.yaml  |  43 --
 .../core-api/kho/bindings/sub-fdt.yaml        |  27 -
 Documentation/core-api/kho/concepts.rst       |  28 +-
 Documentation/core-api/kho/fdt.rst            |  84 +--
 Documentation/core-api/kho/index.rst          |   1 +
 Documentation/core-api/kho/radix_tree.rst     |  17 +
 include/linux/kexec_handover.h                |  27 +-
 include/linux/kho/abi/kexec_handover.h        | 268 +++++++
 include/linux/kho/abi/memfd.h                 |   2 +-
 include/linux/kho_radix_tree.h                |  81 ++
 kernel/liveupdate/kexec_handover.c            | 694 +++++++++---------
 kernel/liveupdate/kexec_handover_debugfs.c    |  20 -
 kernel/liveupdate/kexec_handover_internal.h   |   3 -
 kernel/liveupdate/luo_core.c                  |  12 +-
 kernel/liveupdate/luo_flb.c                   |   2 +-
 lib/test_kho.c                                |   1 +
 tools/testing/selftests/kho/init.c            |  20 -
 18 files changed, 765 insertions(+), 611 deletions(-)
 delete mode 100644 Documentation/core-api/kho/bindings/kho.yaml
 delete mode 100644 Documentation/core-api/kho/bindings/sub-fdt.yaml
 create mode 100644 Documentation/core-api/kho/radix_tree.rst
 create mode 100644 include/linux/kho/abi/kexec_handover.h
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: 7d31f578f3230f3b7b33b0930b08f9afd8429817
-- 
2.52.0.223.gf5cc29aaa4-goog


