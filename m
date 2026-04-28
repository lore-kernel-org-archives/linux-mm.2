Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA2AFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 15:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9AD6B0088; Tue, 28 Apr 2026 11:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053506B009E; Tue, 28 Apr 2026 11:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84EA6B009F; Tue, 28 Apr 2026 11:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA59A6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 11:57:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8CC8A140390
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:57:33 +0000 (UTC)
X-FDA: 84708419586.30.BA9A4D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id CABFF18000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:57:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pBR3W7i7;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777391852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8KUhZHlHGTPgOntbXKrrg5wa3VYZK6/h7G8Qr5HN2qw=;
	b=FiR7HfeW6bDhqN87ED6ch1pFXDTkd/lJjZgDMDiz0PVjYP2+pswKaR/5mdvttkEh172mHN
	kfxqhPapCeDrGPGxfZOeP+kNHqf7/vi5tTUicECu8SO5ZnTbvWchNnRK59GtAgA6rtPz06
	OEThDlwwaWcIAFKrCQU6OltU665uc+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777391852; a=rsa-sha256;
	cv=none;
	b=Wl8TrfdtIffRd7LK8UGC/W7/aersGejiZmGWAa3/GgiUvhWzdkzLiiQiEKQBSFrL+BsOcK
	BtgLh/VToxRqqL4aGAeHBKu8sdttpwtz2vYt48JG2Tk8IC6jwXHgaVw/V4n9bckgTcdiiD
	DBq7SFim75ZWpx04WzLI6kKRekEm2yM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pBR3W7i7;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B315B4410C;
	Tue, 28 Apr 2026 15:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB04C32786;
	Tue, 28 Apr 2026 15:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777391850;
	bh=bSHGxzZyV+iGAQI2g9t72aBNM75F0ZQHFSm7A80ludY=;
	h=Date:From:To:Subject:From;
	b=pBR3W7i7+ibkWqtMyAjhcM1Q4l/sooeLhIYKt2pmlUE/GgobCIdy/VPqcibdRHy58
	 ZFr3yLgr6Knw8E62gQS8wedE1GvaHcTVP8eCHvRWtM0DFih2XYu0BuRv01xS0B4Cez
	 CYWAa8CJ0TJ86Ch8NGqq4Y1jQ0y/9cRK85AIAOCY=
Date: Tue, 28 Apr 2026 08:57:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status at 7.1-rc1
Message-Id: <20260428085729.e7546ddc6bffb3e3e07f2480@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CABFF18000C
X-Rspamd-Server: rspam04
X-Stat-Signature: 9oogrtskjqg9eej14o8okqdq1gwhp7t6
X-HE-Tag: 1777391851-258956
X-HE-Meta: U2FsdGVkX18E2hVxSzxbv30yqBVVUEzbjZub4ondGlmwkGj7lVP1ivVprLfFRQqdzDUeycX/sp592iWEJG3eIQnaO4xBk+lOJSHJHpS3IvhAkb/YCAViJOQkhFArLH/D9zQrCIhLKiTdv146xBAWEnf9OyhDIvgV1JZYkU0MhWKFlv79beOAg+t0L8Tl9FAOxczPhFjsZTKmSVygR1D99tSeNo35xyTBopxBmNP7AwqxhKTVPlG2McLGg5CQK1BrFqlxWyt+tbAApeeoGTKyCDw+HewXwK0PcMuA+wOMUW1KNnV7vjmHKoLmWhHC/nSmr8vVBpEDVlY9VjjEa8Fy3/zUnL+Ah7UJhgqe5TqR72myZyu+KBV0ecOjKT2xlcSwbsMwCsxcUDNk0VPFyIS+1dEmFI84UhuVQU/0WxkeYgFTYWsLQbPyExRteHXbp/g86I6xRs68vIbKZk4oMa5NlJz83yw0zRJ/w4IqwgG3WVv9fB892ViJ5WO3U4qdrapwpvGGummSMgKhzwsBOGgtOrBwBSbbfwBxUKSB1s0H6ECZZld3MlCp9w4wN+WQaxq3QnQdRyAxkkt0al1rl/5pcONbqRXynWrKtd+ITpYCeF6x7U3x00SJeWElhXLQ5JjMFZWn+4Xl/b64bwEDc/sOdHYUvi4UCCDpY4567+d6cprWmECng4ngUtydjMI9svFWMRQOuXJmwusxdykMN7zAFS2H5eDiniTk0iu668voXG2kBMqKF3SxDi1bErOmVZT9OZiWdupIMWKq/6a69YEmU0csZGtoaNHvqm24pWItdZvpiAOtUFzUudEpZi+i92+sIhDRJ4QKCOOcFJK60X2EmRQbnCzW5R+yxAVvLJTvMbfbxCumQKhvSEnzv03l1or/5mbVCZT6diHJdRgAFaOl6ER5J10bh2rGTsHc/+RnfxkyinHLX/ivMbfMV4UZDqoT8jciSTb0Kdu5b1y8dtH
 Zxo81qNv
 5hbVnfuEgZThsNVHYG6f4kL2slrUHoAP4c/Hr0KIJjrU5hHZ52P+mgVfUjnJFGHBSzH3ZUC2QpJs6Agq9rWTPzU3LmLTNxxol2FLi7vBT2DUaAuc9HXEMaqrks/jehzPNyhcqZV1W3DuEywB0g9YYosPjnerwkI9c6AWC028S/9m5d9hOEEbCu3T7ILgDZZlBHtbTUfDwVvoy0/niqLdGrx2BSYa9VdUOb3KX93RqI84Ns//Y4ajl0U6JtjPl3FmrL3crjAEukPNeiqxagtrdJp8uzzxq3L1/DX3iVosR8EPZTervdp8GM/SuBLGua+bMX5me5JalkcTuefyNWnsmO4MkOV9kLWR0Iv7V/6Ka8Mo84QZTnquuiVqSfAtwH8naLd64kHy0U12w84FQVfRuLwhON6OvIqT1vx7569qIFU5tFV0bybu+NaQefNHUVXYJNEgMDqt5yMhlPqsc8o5y093MhNsEu5J+wLNP7BwKcvrFYO7uq7FA683vHyiDcsJHLjhwPWRDIgo/oPzmpdApfg9IWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


I found 130 MM patches from backlog to add after we'd finished the 7.1-rc1
upstream merge.  

Most of these are still in mm-new.  I'll be moving these into
mm-unstable (and hence linux-next) in batches over the next week or so.



mm.git review status for mm-hotfixes-unstable..mm-new

Everything:

Total patches:       131
Reviews/patch:       1.70
Reviewed rate:       70%

Excluding DAMON:

Total patches:       104
Reviews/patch:       2.10
Reviewed rate:       83%


Unreviewed patches by author:


Aditya Sharma <adi.sharma@zohomail.in> (1 total)
    "mm/memory: update stale locking comments for fault handlers"
        Link: https://lore.kernel.org/20260424092217.263648-1-adi.sharma@zohomail.in

Alexander Gordeev <agordeev@linux.ibm.com> (1 total)
    "mm/gup: cleanup pgtable entry accessors"
        Link: https://lore.kernel.org/20260421051754.1691221-1-agordeev@linux.ibm.com

Andrew Morton <akpm@linux-foundation.org> (3 total)
    "include/asm-generic/fixmap.h: reimplement nasty macros in C"
    "include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix"
    "include-asm-generic-fixmaph-reimplement-nasty-macros-in-c-fix-fix"

Barry Song (Xiaomi) <baohua@kernel.org> (1 total)
    "mm/mglru: use folio_mark_accessed to replace folio_set_active in PF"
        Link: https://lore.kernel.org/20260418120233.7162-1-baohua@kernel.org
        Link: https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.com/ [1]
        Link: https://lore.kernel.org/lkml/20160606022724.GA26227@yexl-desktop/ [2]
        Link: https://lore.kernel.org/lkml/20210120173612.20913-1-will@kernel.org/ [3]

Brendan Jackman <jackmanb@google.com> (2 total)
    "drm/managed: use special gfp_t format specifier"
        Link: https://lore.kernel.org/20260326-gfp64-v2-0-d916021cecdf@google.com
        Link: https://lore.kernel.org/20260326-gfp64-v2-1-d916021cecdf@google.com
    "mm/kfence: use special gfp_t format specifier"
        Link: https://lore.kernel.org/20260326-gfp64-v2-3-d916021cecdf@google.com

Lance Yang <lance.yang@linux.dev> (1 total)
    "x86/tlb: skip redundant sync IPIs for native TLB flush"
        Link: https://lore.kernel.org/20260424062528.71951-3-lance.yang@linux.dev
        Link: https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/ [1]
        Link: https://lore.kernel.org/linux-mm/f856051b-10c7-4d65-9dbe-6b1677af74bd@intel.com/ [2]
        Link: https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/ [3]

Nico Pache <npache@redhat.com> (4 total)
    "mm/khugepaged: generalize __collapse_huge_page_* for mTHP support"
        Link: https://lore.kernel.org/20260419185750.260784-5-npache@redhat.com
    "mm/khugepaged: generalize collapse_huge_page for mTHP collapse"
        Link: https://lore.kernel.org/20260419185750.260784-6-npache@redhat.com
    "mm/khugepaged: add per-order mTHP collapse failure statistics"
        Link: https://lore.kernel.org/20260419185750.260784-8-npache@redhat.com
    "mm/khugepaged: introduce mTHP collapse support"
        Link: https://lore.kernel.org/20260419185750.260784-11-npache@redhat.com

SeongJae Park <sj@kernel.org> (22 total)
    "Docs/mm/damon/maintainer-profile: add AI review usage guideline"
        Link: https://lore.kernel.org/20260412211932.89038-1-sj@kernel.org
        Link: https://github.com/sashiko-dev/sashiko/commit/ad9f4a98f958 [1]
        Link: https://github.com/sashiko-dev/sashiko/commit/b554c7b6e733 [2]
    "mm/damon/core: introduce damon_ctx->paused"
        Link: https://lore.kernel.org/20260427151231.113429-1-sj@kernel.org
        Link: https://lore.kernel.org/20260427151231.113429-2-sj@kernel.org
    "mm/damon/sysfs: add pause file under context dir"
        Link: https://lore.kernel.org/20260427151231.113429-3-sj@kernel.org
    "Docs/mm/damon/design: update for context pause/resume feature"
        Link: https://lore.kernel.org/20260427151231.113429-4-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: update for pause file"
        Link: https://lore.kernel.org/20260427151231.113429-5-sj@kernel.org
    "Docs/ABI/damon: update for pause sysfs file"
        Link: https://lore.kernel.org/20260427151231.113429-6-sj@kernel.org
    "mm/damon/tests/core-kunit: test pause commitment"
        Link: https://lore.kernel.org/20260427151231.113429-7-sj@kernel.org
    "selftests/damon/_damon_sysfs: support pause file staging"
        Link: https://lore.kernel.org/20260427151231.113429-8-sj@kernel.org
    "selftests/damon/drgn_dump_damon_status: dump pause"
        Link: https://lore.kernel.org/20260427151231.113429-9-sj@kernel.org
    "selftests/damon/sysfs.py: check pause on assert_ctx_committed()"
        Link: https://lore.kernel.org/20260427151231.113429-10-sj@kernel.org
    "selftests/damon/sysfs.py: pause DAMON before dumping status"
        Link: https://lore.kernel.org/20260427151231.113429-11-sj@kernel.org
    "mm/damon/core: handle <min_region_sz remaining quota as empty"
        Link: https://lore.kernel.org/20260428013402.115171-1-sj@kernel.org
        Link: https://lore.kernel.org/20260428013402.115171-2-sj@kernel.org
    "mm/damon/core: merge regions after applying DAMOS schemes"
        Link: https://lore.kernel.org/20260428013402.115171-3-sj@kernel.org
    "mm/damon/core: introduce failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-4-sj@kernel.org
    "mm/damon/sysfs-schemes: implement fail_charge_{num,denom} files"
        Link: https://lore.kernel.org/20260428013402.115171-5-sj@kernel.org
    "Docs/mm/damon/design: document fail_charge_{num,denom}"
        Link: https://lore.kernel.org/20260428013402.115171-6-sj@kernel.org
    "Docs/admin-guide/mm/damon/usage: document fail_charge_{num,denom} files"
        Link: https://lore.kernel.org/20260428013402.115171-7-sj@kernel.org
    "Docs/ABI/damon: document fail_charge_{num,denom}"
        Link: https://lore.kernel.org/20260428013402.115171-8-sj@kernel.org
    "mm/damon/tests/core-kunit: test fail_charge_{num,denom} committing"
        Link: https://lore.kernel.org/20260428013402.115171-9-sj@kernel.org
    "selftests/damon/_damon_sysfs: support failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-10-sj@kernel.org
    "selftests/damon/drgn_dump_damon_status: support failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-11-sj@kernel.org
    "selftests/damon/sysfs.py: test failed region quota charge ratio"
        Link: https://lore.kernel.org/20260428013402.115171-12-sj@kernel.org

Zhen Ni <zhen.ni@easystack.cn> (4 total)
    "mm/page_owner: add filter infrastructure"
        Link: https://lore.kernel.org/20260428071112.1420380-1-zhen.ni@easystack.cn
        Link: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
        Link: https://lore.kernel.org/20260428071112.1420380-2-zhen.ni@easystack.cn
    "mm/page_owner: add print_mode filter"
        Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
        Link: https://lore.kernel.org/20260428071112.1420380-3-zhen.ni@easystack.cn
    "mm/page_owner: add NUMA node filter with nodelist support"
        Link: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
        Link: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
        Link: https://lore.kernel.org/20260428071112.1420380-4-zhen.ni@easystack.cn
    "mm/page_owner: document page_owner filter features"
        Link: https://lore.kernel.org/20260428071112.1420380-5-zhen.ni@easystack.cn



