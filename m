Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D978C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17586B0098; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA1016B009D; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9977B6B0098; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 771E06B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E77D6A04E5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:55:59 +0000 (UTC)
X-FDA: 85190138838.24.4D60F4F
Received: from out-utut-a194.jellyfish.systems (out-utut-a194.jellyfish.systems [198.177.127.194])
	by imf21.hostedemail.com (Postfix) with ESMTP id 286B21C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:55:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=ArswRCrQ;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.194 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861358;
	b=6uP+MXfc6ApVnofYNRttwyEz/ExngWftGt10yO+B5ydfg3SMYLIvVCCWSxzjPioMEO2hzB
	ygtF5c5r5qdBbZkRQoykZyQC2TgHlruAhgi9FuNEE7yEnrKyKMsjdE495xyRgR5VK0GzGc
	6SZBJazrdaWF76ODDgBHUyKJBuMjtcs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=ArswRCrQ;
	spf=pass (imf21.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.194 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QWwCCBEOgN/d9xYRLy5K04OOq5DsrGxdd2URY0hSlZU=;
	b=cm5/ICtuwqBIXC10byHC9sxqNtdPnChb7WQ8SU8A6V+flDUdZX+iGfv5U1b+6tpYLyUvxy
	JiIOGvOjtwOxNc6DWKJLfBbP1Vy7vV4LJ20do/HixXiZe6lRQDmfuig+36ZjqmV9DPS7Li
	VrKcepOu8wUGTjOHiKWf7fCkfltzaLo=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfK7k1b4bz2xN0;
	Tue, 08 Sep 2026 09:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788861349;
	bh=QWwCCBEOgN/d9xYRLy5K04OOq5DsrGxdd2URY0hSlZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArswRCrQYCbrhKI78k1+v4toddTLSUWrd+VepF7xzjNk7Y/rnuIoHpVBKZ5cvf8U7
	 XVuLOAGvqGr4pKfb4BJGDKOjM6NPeQ2EjZnx/WTgosqS6Czhk9W0EMAXRNbPodj20E
	 11CEoNAxo5gihgoGdAtydq7fdY6VKnWtj4bQdc99rIvi2JsbPIh99Kq5S8BLFioIGB
	 tC0pfG52+ZYZNqyWzhjbZ+HlhqLh9r+d62u/jW0SP6XWDzkPHLyG3gZsThV7tMcc0Q
	 pV+5c8HgmL+uK79/mNw8m4X30UTGtqqGyomU5IDiFDedZcqd9cXQ4fxa9CTNydZ9gI
	 wp9P6pdAWUSUg==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: [PATCH v2 0/2] selftests/mm: Validate selections and scope memfd_secret setup
Date: Tue,  8 Sep 2026 17:55:31 +0800
Message-ID: <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906135444.749144-1-hi@tychen.cc>
References: <20260906135444.749144-1-hi@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 286B21C0002
X-Stat-Signature: 69pfw54sxkopzkikx59rbnfditfwc85j
X-Rspam-User: 
X-HE-Tag: 1788861357-752996
X-HE-Meta: U2FsdGVkX18Ll7Ja+m30Q5ZPyR0q0Uz4WPfJpgHcdIolqoXiKdcqy83O8is/no7btOkftTvMacgUokr1w1LqmCvJrrZDOYQIqXZq2Kug43ZVivb2sxliRYPA0t+4PA0VW45QVh1/4q1J6T3yVIPjSrevCm3jT6ZUM3onooFZmfsNV8kkNhhKdOyrWCIDqvF0nY+j3rQ7Ql8P0iFugkXBlJDr9c7nuRR/3DjjWV6ZcNwwi2txF7dxl233EHHwmlxTIn1+YZYMfQiUejJoJyw+z9i2DcQRWKLYJfDxNZ3kIJxEpMydLOwal3xd7wJq3/bnjoB7CK1lqcSs+5zyO74+kYfVbsb4XaAxF8nct8xvD/p55Xa3hZSbn8C4lIPTYHVxL4I0HfXnNXCLUV+ed8xWs9yC4GLOKjSQd1hsNAMWLa65Wk8Bhq1A0fylsxhiIvvqX2ET3/QSk8C0Pny2Imfkgbd1SVy2xUMKjjVQTBQ5gKLg67wciQWYJw/cD9PEZI7nSB4/GRN1yAZyt+3i4TDcTqkzsQPHjFw5f8cKjvc66bnoXADOuGZSldcL1e/UYgN113qda1L9x23hWC+XZwYkoMnQC16SJlDM8j9HXWj0a45ZeGuMPkNCiy3cLCK5z+NSlqW3CUpM9PA6jVrafeROd2yvo8z6bjb4b+S1BFR0jkO2cGXNtedvCLpx4W+mPMcr9PwB0REBaAWKGsDnvWhn51gyJgvCHLFFIrtVICyqnyW9qsTKOLeluWFQjxcrLKUPg7r4fIwgvgwZv/6H/uAo/X+N+j7s++huVqvm+WUo3qLjR5GdtRskpNIdQf8lv8ke8CgZkf/V3bZ5P8uCJIHqLrwW9EkwjWG4jhirdY3XoAqrUkGF1JrtjHdl2CLcEWtU5ttKtaV6LndkdfeLPXn4LHc6WDMtvJKarKlnEQDOkiXYsiQbyzJ+CBSioFndKNSKlnBZYcoB2ruApj/CxMn
 zmvnmKSB
 NM6HvGSyVAbhSBMYjpPkMglZO+zrrmnHE0DtU8SKBKpWoXcdP4mbLTr5DFCCAMYegC2P0ndG+R+SZ5O1tKaqHl+IjgwOxKLg1ia9Y74kyOWC6CospE167narnHRRwQXSfYr+6X3TwCb9obyMk478cmiydNaD5tQ90Iq8aljxEYo4X36w10C793C9S0RlRzs9qAM8XycyEpYUPu8qQ6mqNSutR/e1S7LbJbmLy7X0UPGixDVmS2EuF/PAzoMlVNGQUJWOhLz1j6quCF8WNFz9pe7Y/ktc8njtpCOKfRUK0S6ZB1/+D82BsuNmnI7/QOxw1+GDs/6Qb3zBnEsAo3162OacjF//e4PBwg8xvV0orXFIQLX6Z4joVLRldIBr7y2d3aOB0LFiv5D9yhczBc2FpY+w4hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh can reach test setup after an invalid category selection,
and its memfd_secret preparation can change ptrace_scope even when that
category was not selected. These two patches address David's follow-up
questions on the earlier getopts fix.

Patch 1 extends the getopts error handling to reject empty, whitespace-only
and unknown category selections before setup. It uses the existing category
list in usage() and normalizes separators, while preserving the default
when -t is omitted and the existing environment-selection behavior.

Patch 2 gates memfd_secret preparation on category selection and executable
presence. It retains the existing behavior when memfd_secret is selected;
it does not add configuration restoration or otherwise change that test.

Changes in v2:
- Rebase onto current mm-unstable.
- Extend the original option-error patch with category validation.
- Add a separate patch for the memfd_secret setup side effect.

Focused validation:
- Bash syntax and strict checkpatch passed. All 30 documented categories
  match the categories used by the script.
- Parser checks cover omitted/default selections, empty environment values,
  explicit empty -t, invalid options/categories, whitespace-separated lists
  and command-line overrides of environment selections.
- Twelve invalid-input cases and help were run through the full script in
  a KVM guest. Invalid inputs exited with status 1 before test setup.
- The real mmap category's three programs and memfd_secret passed in an
  x86-64 KVM guest running Linux 7.3.0-rc1, including multi-category and
  environment-selected runs.
- The guest kernel lacks Yama. A disposable file bind-mounted at the actual
  ptrace_scope path verified the shell's write condition: the old script
  writes for an unrelated selection, the new script does not, and selected
  executable memfd_secret retains the write. This checks script gating,
  not Yama policy enforcement. Missing-executable behavior was also checked.

This was focused validation, not a run of the complete MM selftest suite.

Previous submission:
https://lore.kernel.org/r/20260906135444.749144-1-hi@tychen.cc
Review:
https://lore.kernel.org/r/519ef70a-679c-455f-ba5f-3841730873a4@kernel.org


Tianyi Chen (2):
  selftests/mm: Reject invalid test selections before running tests
  selftests/mm: Only prepare ptrace_scope when memfd_secret is selected

 tools/testing/selftests/mm/run_vmtests.sh | 29 +++++++++++++++++++----
 1 file changed, 24 insertions(+), 5 deletions(-)

-- 
2.55.0


