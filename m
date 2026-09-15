Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C53C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 09:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACC876B0092; Tue, 15 Sep 2026 05:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59576B0093; Tue, 15 Sep 2026 05:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925826B0095; Tue, 15 Sep 2026 05:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 612156B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:21:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3145C0267
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:21:52 +0000 (UTC)
X-FDA: 85215454464.27.30B0DC2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id A5635140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:21:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uJAj+7Fx;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789464111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9bu0smDoTnQRvulAvtrN74ZoF7ASKGzXCEXeJEYo3dw=;
	b=no1ehej2O2wVfStPWpGPQEu9usT0QC+qnmqWJaQK7JbEa6UczWA1XPODmSazHx0JDfkZRq
	muNAgou9g20YBZmrpdaQuz7TopwsTmtuqepR59AOCeqGDvCJ3NhDXONTV1snIyAr4vEE/f
	7rM85hIsg3pVNvBv258bl8sXHOQqyk8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uJAj+7Fx;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789464111;
	b=8qMYwlGmBSUAtsgO0XpAnan+6dupR8gul8jKWNwUMHErzdrQV69VrGUu8IBm0Fpt0uFs8W
	P1lWJAG2o5yQiw5N2LrsDE2NSkKUCO9uAm9eifUV/nJwAHpd36N/VoUyJBBTPuSp3H6Dqy
	m8SwNPY389qIxk+P8lSbI3Vs4k0EsUQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2122E169C;
	Tue, 15 Sep 2026 02:21:46 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE9F33F86F;
	Tue, 15 Sep 2026 02:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789464109; bh=AFgqujhkJrGASZuwK6HMERYmbZ5P2W2+hv4OhaNPtQ4=;
	h=From:Subject:Date:To:Cc:From;
	b=uJAj+7FxYyzFDCCin5QvAMgMxPqvJQYfLVI2/HM4PNsF5rh2/8JMKPohoHSA675sB
	 /zIu1nMYAXMldL4IMU/sq1jciDGHZZxs/vLJia2obRP/Xw/wNT18Vt7R1d16piAWPJ
	 6Oa8fY5OWlEyWPhEPw6dTHJkCh4Gud8xXkJbMN9Q=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
Date: Tue, 15 Sep 2026 10:21:35 +0100
Message-Id: <20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAB8OqWoC/x2MQQqAIBAAvxJ7TlAj0b4SIZKbLkWFUgTS35OOA
 zNTIGMizDA0BRLelOnYK4i2gTm6PSAjXxkkl4ob0bOFHrvGK+DpgreLo40Zr00nlTaSc6jhmbB
 a/3Sc3vcD6VER72QAAAA=
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2907; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=AFgqujhkJrGASZuwK6HMERYmbZ5P2W2+hv4OhaNPtQ4=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqqQ4pqW6CqNXPPPXfOrgAwKvwi1qdYYBTYZw8A
 wg9WRl42COJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaqkOKQAKCRBt1cPRWsUx
 M+kMDAC+icNdo9ex8a/XcN4CcH19iOYi5hhEqweD7ih7Mxr27WHC7//A5zWJh+JHmFtogpa656r
 A+t4r94LEmHzKngogkWejKyL0zYh8qgWeSg92dkn2zl0LDabvqduoG1tiGEQVuxsVUN6FEQIEB1
 csmMDOU4SJEJ0P/lWZ53+wjTrbakbVfGdhsM1Yr8B56pBMZXGBm9nYA3bSyPNSWIHKvPRm5os/X
 CqtM278tZymubu/tsOzNHqlXWCICpqQPyDjtbB2yI2glavvAKPjnDjUpmgZvfWnpFsrm/s8Hzex
 ht1miaQ0sXrxIjYOjDY9xIml3vMGEdOFixFXsMf81kr48k1eA+HaosqW6C1rEmbr/+ZPaSktVQ3
 bvAHVHo1SMeQtdLJdeJsgcrYrqwqj+oaGJS2hTApcgvI77BWpr7WVGd7inBbZRz6BxM7Jlt7OZa
 rtI1EWUJ/GOA4WcAFlX7c3hDWxuP+4IuHKXPGL7qc50OhJ0C3hz+36AZuwbpoZxNxUwd8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5635140007
X-Stat-Signature: 1xtfqid8caitbowagbreqoz949esy9tk
X-Rspam-User: 
X-HE-Tag: 1789464110-500911
X-HE-Meta: U2FsdGVkX19+yMzJ6wZ9/dxC7c5hCfs4Z1yQv0NSGsMwjDKp8VPNMnw4cCIp3bIlIodi5ABvi+o9KbQIcA0wXuaNqsNxrb6noJPH+CVyF5lEh3AwwuKnI5cCVfYK2eTcwvYJueZVVy9qdnrgfhOC7n+2dRF/KatYYsnqepfGr2W06xKxTpOkjKf1n9U97K7VfWrLJciMpyvaWSz7k8EsC6fWRpbfPcPkcljI4Xv+9JlP81QVgCre/zoLJY+cL7VQf3H4LpmkCGWBsujjkcMINUK1rcnNCpEyd/1n3STJNqzh9Z+4IQKiQlefEXig4A2qM66mf4QJa4CLByiX/s1YqZ0GXAkfwuLQVRAGNKBjGPkyF2K9aRL0oZl8g8h2pytF30VJUQmYjUCHv8famsbokZQqPpaVFmFlmnIjkwhAvLrnpoqUg4JtmnAuWvz6uJ6tV5o4QMG86ycqZaJ0JIPHbBebqsbx+2D7AT9Q094all2TiNbO3pjx7lrpH5w2bM4CcU1NxC5CuwXVoWubd61Qk0mrSpAd0lNpus8u8vAF07s6viCQYOwDDcQQGMEDPkjHWbpX6n/8bdoOlZuxcP/9OajPrYxWDbkF0XbyNKrDuPhJieOUQNHO3cd70jvsTbyJoHg1z7ft52yF/k+LC5U1tLuRuW0i3s/zOIdl83Rx5L8Mjd+nlmMRWacZDy9RYFnOxi4Rla0jI2oVHIFaMV9oHA1gUl+4/ZyYSGXKS1GfyvJfAy+lJIchp9/TET4yJAiWvMYyLbMbZbDfHzAiOHTDGalSJ2FOH2r442Xe3uv2jWHmLGXT+XXLPFDNGV35WgPdAZspmkZVFZTRASsCZzHx8xEAR61lIKtbuZimW3mBmB9AyE2d8cmceRkSO+KpCl96PWBnnUksQVMMJw/oliI+foutZVf3nt71qyEF7Vv5AITvoudmglNE5WKFEhNwxokcNl6A2JQ7llKicJBwn1k
 c2ZBxM1v
 dkw3JZ9sMoMYX4zuRxkMpwPW3HyhmCbn0XfWfWjZerq6Iufd3Zf/9gcVGHvr2GNnqSKLSApNOgVgWMD/dqT5p6aLkmV0KnhM3Y8qOVTqLPSNALlTwivArXEHeTXlDE+Be9+Mj33OdCQT9kHIgZpiP83AHfezrCxV/fj2zF7XNw6pGPbEGxuVLNDslpra7nDzXX7IkONUrcT44KjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before wait_for_scan()
is called, causing a sanity check that expects uncollapsed pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them again
before c->collapse() is called.

To prevent this, change the khugepaged setting from ALWAYS to MADVICE for
the affected tests, and mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan(). This prevents khugepaged from collapsing it
again before c->collapse() is called.

Also, fix false-positive results when a child process fails in tests
such as collapse_fork*() or collapse_max_ptes_shared():

  # -------------------------
  # running ./khugepaged -s 2
  # -------------------------
  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

This failure was observed on NVIDIA Spark with 16KB page and this patch
is based on mm/mm-unstable

---
Yeoreum Yun (2):
      kselftest: mm: return fail when child test result is fail in khugepaged
      kselftest: mm: fix intermittent failure khugepaged test

 tools/testing/selftests/mm/khugepaged.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)
---
base-commit: 6b41451631cabf9ea3b384c2a099088e1598f963
change-id: 20260915-fix_khugepagd_fail-9d8932689200

Best regards,
-- 
Sincerely,
Yeoreum Yun


