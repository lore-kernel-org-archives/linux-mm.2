Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83498CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 10:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937386B0088; Tue, 29 Sep 2026 06:33:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7C46B008A; Tue, 29 Sep 2026 06:33:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8986B008C; Tue, 29 Sep 2026 06:33:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 511466B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:33:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5893140487
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:51 +0000 (UTC)
X-FDA: 85266439062.30.1F8DA0F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id A3F961C0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:33:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lYe1EwY8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790678030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YRtSwT7DxMXKYJO0wSAUy4nj5QmZCbCVMb/MIlcAvf8=;
	b=g06UU0k9DmHEFMuUhc9CPgk/A98Y3+6zaQ1SWsDecKnIhHVFuQAgvk1KRnyWJNV8IGmA9K
	D4bUvSquXTCtaoaPJSqdG39P+XquUMw87jCk+ULFhCSyZQDJfS41S7f2w/m5HVpSNVdOhh
	KEWLzZUKbPqKdhzLIkZ28jJ3F0k98wY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=lYe1EwY8;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790678030;
	b=VKuFMMimMlXR5gb7yb+Qt7ID52OvNwt67CdclHREUIUYNS7nikAYvcamZmM2yDkZvUGM2k
	Xne5yPQzFTCoPba3hXQ1yP11N/n2JIdFdciMgpqBSycEpyX1y/IEIVurCvEPb8d89UxGnD
	86tFwwlH/TeaC03NKCublRyPDDftL/o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13284497;
	Tue, 29 Sep 2026 03:33:44 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 546643F86F;
	Tue, 29 Sep 2026 03:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790678027; bh=eV5lqS2npUIZnoSAYX7UiQBLBDCa+eZARi2ceYOyVCw=;
	h=From:Subject:Date:To:Cc:From;
	b=lYe1EwY8DwO7+J7j52MD7A/TQLzikpNOO11GzjKqoGFprZGEn00qaYDu/Z9fTlGw5
	 SoOml5LaeyA0YGyacrf9uinXHhW3RmZS/im82Mw+MuR3QkApsQWAEnFA6IZtj6bXlJ
	 Sjl4jLVxIji4Vq5ZxGwdm2PuOqGgjq9Zk5euWGOk=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v4 0/2] kselftest: mm: fix intermittent failure khugepaged
 test
Date: Tue, 29 Sep 2026 11:33:17 +0100
Message-Id: <20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAO6Tu2oC/32NWw7CIBREt9LcbzEtaCn9ch+mabBc4Eb7CCjRN
 N272AX4eSYzZ1aIGAgjtMUKARNFmqcMp0MBg9eTQ0YmM/CS16Xigll693f/crhoZ3qr6cEqyUX
 N7bkxlYQ8XALm1i69dpk9xeccPvtHEr/0ry4JVrKbaCQqbrHS6qLDeBzmEbpt276fF3sfsgAAA
 A==
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
 "Gregory Price (Meta)" <gourry@gourry.net>, 
 Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3274; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=eV5lqS2npUIZnoSAYX7UiQBLBDCa+eZARi2ceYOyVCw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqu5QGVeBBp6tar+v8bI+fW5DKxbPrbgKzSblUm
 I/EQ3fxmZqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCaruUBgAKCRBt1cPRWsUx
 M3MNDADG5woL0VLW+Y+vfB0vU+OeGg+Curv1eH15X0CF0c38pqdDED7OE0AX4zbl7xsJASMnX4n
 IlaS3Cj8OL1jhOXwcWwELevqc3cQ7FBDgFpHGSTk+ClyxBWpZ04lBm6OpEyufOo281yW5U5b92z
 zCvv9y0NdCU+IDf5rVSu8ikwGj50sjN/vkOAkssuj7KOmFp6G6tzXl9xwht8eAPdGx3rSFni82E
 hfrBORSxbHJBFCIcRQdqYqMEJ/rWX2iT7kTJtNkefOuNyKILoPZ8u5zvZiTNYlKO7J+YkYYCUMP
 qJBG9eSYXu46yJ9hwozKBG+PndvcsDeHUwE+dEyOvQ31qMD6yNzCKe9e2OiDdFCOh/qDHOBXcmg
 ICDN0PTtK5AF86RQKI/jVWauWbIGAia40zYcHbOe5J6ectuM8elwS3u3qhFG00eFfb/1pfbKE5S
 Si3s++y9Y4EvVCQKi7c7y59mhVPNMXWb9zaJcM7chgBJ2EHEpv+AZTD67BBanes32esUU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: 5zdsfp1fpg38zw5xmpddjgai6hmuasou
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3F961C0004
X-HE-Tag: 1790678029-98895
X-HE-Meta: U2FsdGVkX1++T0Jk8iOdvFkjnUkSghqQfV3lO7LzzLwYCsflumFoTDEeOc010bUBxZ2kSyUgPs+FKx+n7x2JEByuwOZvLieP/Lm9nQhxuqqH3wGpu0vcs/YRJQIlzFZjK57xloQ4BIWohwmhPqeuzK+yxsfc0pAaOCq31MtN0luFhBdtbkOfAf48MC9LRFszcyJ2wpAuf2WIjRRF0f5B1rr0rMaKfhTSspFVG/fQ4AKTki7Pjjf/l1Yofj+wwVBq2djNXYKJIShJ0wV8R4JWBsBYFMxE8kRX1SVIKRHi1KVL8FATU5ENVTCEW3v5mq3QMcO/HzUw8HWOXtyUblaDsCugQDM5yVSyTa9FsfQNalzXTB6usX8MtqgVk4AO2yvHkAIWanw9gs57o0VPEMYSMWAPPvoP8n2yRHSxJ8cLvSiWVr16zcT8McOkQifHnU0MVQXfZK9LzsYxZQiqm33VRPke6nmRk3YXwqkWRQNsRlhM7IayoDBSr7gGKMIzXWzBenJ36UsiJpQXreCg/1vsSagHHez4KZhRzgIbdJZFlV7VrkhH9tBDG0WY7kX8g6VP2ZVhf5USKlFxyvP2i5jMmgrRL9n+bDK+tBIsELMIcWSkWAq4ArwrIN5LymCssu3T3R+DKzB9OJ+deGrEgHsvvfl2x9gDLqE4f2yZu6hG6BBXXGMOXn4zKL+y+Fb/e3+fp4KcqL+8woIuw/Bf4WZlf1a+ZLv1E6wxC+j2RnodPiIxoEjien0uOmuvA9ypmnMGwReGQHR9rD6+DF3+EmgwW0dTpL8eZ9PTP+p6H2RQ8NYw0wetpoCnceQl9TLZJwEeizbQTeVQbdr3nTJWMGWotreYP/gX0wCs+6wgVxgIy4dSnDXZ9kjJmPd1I/n3yciEN7zHZg+GErBxjV7LfuaPs2bQHYQXcfBdcpCxRnpGDlGBA4qq/a2f0NEjaBJV+TLTwXijwwzjmU0GZ4yXtZ1
 wat+mF3n
 UbwLJwvCK3rBEo8j6WK200yWg9xkxoD5/Vd3ucRmcHEwHcCAUR7I0ypx3itFbAEArAG9KxPAa+01Mf/6zARGzdl6WZp2wF1GEOkwBdiToJq0wtP0dh/odhoyDNNGMxXz8YZcJQMXIz+igFTvZBkcmpRY50uYs3HZGYQQWKNZAVfPYI19Z7WvneFoO2czMakLjTPvhAhHJzSElfMlYIU7BQ7zeOBpMZDMHalZrSgxjUyz0HAvS3pmJWgCayzcbWAeGWuNAhpldkgQ30W78lZL7uRM2Lg==
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

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon. This prevents khugepaged from
collapsing it again before c->collapse() is called.

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

This failure was observed on NVIDIA Spark with 16KB page.

---
Changes in v4:
- add comments.
- add r-b tag.
- Link to v3: https://lore.kernel.org/r/20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com

Changes in v3:
- using is_anon() instead of comparing name of mem_ops
- add r-b tag.
- Link to v2: https://lore.kernel.org/all/20260921-fix_khugepagd_fail-v2-0-3c2877beef61@arm.com/

Changes in v2:
- remove temporary enabled setup.
- Link to v1: https://lore.kernel.org/r/20260915-fix_khugepagd_fail-v1-0-bb6f04c8759f@arm.com

---
Yeoreum Yun (2):
      kselftest: mm: return fail when child test result is fail in khugepaged
      kselftest: mm: fix intermittent failure khugepaged test

 tools/testing/selftests/mm/khugepaged.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
---
base-commit: 685086170033a6ab334f0068cd25dae90fd1bb4e
change-id: 20260923-fix_khugepagd_fail-172362f58d17

Best regards,
-- 
Sincerely,
Yeoreum Yun


