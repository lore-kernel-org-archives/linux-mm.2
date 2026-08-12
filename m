Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65E8C5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E5C6B0088; Wed, 12 Aug 2026 01:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFED96B0093; Wed, 12 Aug 2026 01:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14A26B0095; Wed, 12 Aug 2026 01:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 824F36B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:41:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECF911602FE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:41:01 +0000 (UTC)
X-FDA: 85091518722.11.3C1D607
Received: from out-182.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf21.hostedemail.com (Postfix) with ESMTP id B528C1C0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:40:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5pWdTs6;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786513260;
	b=DXmYAeCAVWtEg72et+JhEsPLl7ZlcJxk7VpLcgUJbNvq8hvjbYJr8JCww+K/C6uqLieMnb
	C8DsrZmYaO5H/H48EVmi+Cv8Z3zoUrBIsNYe6bBSy3XXooAUjbrZiVbLjnLkSoy8tggRw8
	hv68YEGbZxGPzceJnsazBIDwtzrVAx4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5pWdTs6;
	spf=pass (imf21.hostedemail.com: domain of hao.ge@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786513260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tgUVbxAMqq9eyDnj3cSJELw1GrjSzVkJC09UC840utI=;
	b=rqkwqjw8/zzc/2fO0nyfikPlX1xy/GGTKneikXGHsP2ZXNWcuSB4hg/qhuzPSMJ2bJ9nlL
	1LvraHxML/e+WmJGCpDbEfqQyM/6wbxO0IXPM2oqO4sgFQK6qyZF3vTiNx0JIDp7GGPCKI
	rwB5dp90v2iCFd+RSMhO1Gbjrm7L5EA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786513256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tgUVbxAMqq9eyDnj3cSJELw1GrjSzVkJC09UC840utI=;
	b=I5pWdTs6iR44KCPchZFhbtaRPzzGzUHmQ//szAGW4Se8CL4a2SKesOe+A7bcEfGxIPpkB1
	0r1Clyvu8DuLDvuA0qO63HmxVfA5FtapuDd8Uod6UMd0p8Hmw+Lp8thxh4EpZpEllPNgZp
	h+4EntL4Ely3UAj0m0O0CEb0RIcYBCY=
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>
Cc: linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 0/2] alloc_tag: fix undetected compressed tag overflow when profiling is disabled
Date: Wed, 12 Aug 2026 13:41:03 +0800
Message-Id: <20260812054105.102637-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B528C1C0007
X-Rspam-User: 
X-Stat-Signature: fujmd66uoz871buwfyj9e6rp6oqkht34
X-Rspamd-Server: rspam06
X-HE-Tag: 1786513259-392385
X-HE-Meta: U2FsdGVkX1+g/YFyALfhjlhY6CCapUv4mT/mEd5BgOf4tk4mZf6LBXx47agsxFxiYZU4L7iPLDrKQZGkzmHeoTnZH5mNCa3DQiiM0YLZJvfi6jCGG+atse3a9JtvDOF9RrDdolwkuS4OCs+2cwns9tZwCIYAw+GbTfrLjkNanUYWXecA4+Iz/KmTNl5g8mg8/WpVRhGVaf2OZx5Om5aQkydUxnr+gNuVguTRPZfebjHzf8DdPuaukc2c5bjTQ8d4e99BjJXmGGPA55Wydv1N+TfJThc6ksz5K7Sir3HI0KRRxX5u+s8YcRy8BCZW7EilyvAFBJ5vd4fvSR541qiH9Ag0lv1Qt/SwS9f75jCrYM4S6Tn2CaMgVJerSKDyWTqYWbNBQEvlfmGcpS1G2PASE6IkjFFIeRi4H60irYNNC7JxWKd29lvNmiuRGaLUOrIYkpVSjLl1mug6VkkoMbCchevQrZJynu1NXuA7tABSIdkVrr730gh5UFl55lpexUVq18c/Rkqggosl/Bmzw5uTpGANnUnJpJMr3cqViJ9B5Hb1e12dw4yWJPMM0eGAq689ORzgbiT7RaIPpmteUQP8N8SqucdO0c2pKDXvQ2xIgY1XB0XgMhR1032nhvJvZ1Lxn+8AQmyNhfmrfKJ6hWfn4n+e7uErfYYpXOnUOk+R0SYyciB2P8L5sF+Vw4BKEMyST5pCkPUGzMzvQwyLM8PnK+6GCaGvDnAeyGe8MaeYX+YrkvzBmC8PUdBpJBS/mYM5Mg+ADg3aSryOWYLKYO+7y6q0K6Kx9knL3J1gPuRYgsZwnXGVfZJ+01UtR63AN8Oaa1hXdrBxQJQiQcBlFv9L6efOGyWZpGb/rpZRqZ0UnJlG4J4THt10DwxCtvYHjJ0YZBQAHlP5cofsOPtdr9iCJc6xOeseqjxmWhovPQM5XitatkKDsDNcDTj4hMs9sEavj2cwOQseV7F07bPSZlb
 wHCyPzPu
 2n0ZaGmm0tHPqkxgwU0opBZ1mVPi2SOqYS6mwsVkHjPzSd7uBD9K8m7JDDIDJdyVx96+1eQ9ORDfxbpjXANFrQMDMj2Zu7qn+LShkeHMKwN7F0d08LosXDXYDM3h8DIC/6hRZpXguBQSFojUUobztM6uSS4NJALFJB3RWxVHDkwIXCdwDnSPYA5p+bs71QrjryL3M3+Rh5pSc1zTA9KWPsPJ1zXvDECKxjdrH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v3 was a single patch. After discussion with Suren and Andrew we went
for a more graceful approach: rather than failing the module load on
overflow, let it load without profiling. Once profiling is disabled,
codetag_needs_module_section() returns false, so on retry the codetag
section is placed as regular module data.

A new patch (1/2) is added to move release_module_tags() above
reserve_module_tags(), since the overflow path now has to call it and
the helper sits below it.

release_module_tags() is what module unload calls to drop a module's
reservation from the maple tree. By the time reserve_module_tags()
detects the overflow it has already stored that reservation, and the
-EAGAIN return skips vm_module_tags_populate(), so the backing pages
never get mapped. If reserve_module_tags() returns without calling
release_module_tags(), the stale entry keeps pointing at that unmapped
range; when the module is later unloaded, release_module_tags() walks
it and panics.

Tested on an x86_64 virtual machine:

# insmod overflow_tag.ko
# dmesg
  With module overflow_tag there are too many tags to fit in 13 page
  flag bits. Memory allocation profiling is disabled!
# rmmod overflow_tag
The module loads without profiling.

Changes in v5:
- add Fixes: and Cc: stable to patch 1/2 as well, since 2/2 does not
  compile without it (Andrew Morton)
- restore frob-adjusted mem[type].size on retry instead of zeroing,
  as s390 and parisc add GOT/PLT space there in
  module_frob_arch_sections() (Reported by Sashiko)
- drop the load_module() mem_profiling_support check; the percpu
  counter leak is pre-existing and orthogonal to this fix

Changes in v4:
- add a new patch (1/2) to move release_module_tags() above
  reserve_module_tags(); the overflow fix is 2/2
- release the reservation on the -EAGAIN path
- return -EAGAIN instead of -ENOMEM so the module can still load
  without profiling (Suren)
- reset sh_addr, mem[type].size and sym/str SHF_ALLOC before retry
- skip percpu counters in load_module() when profiling is off

Changes in v3:
- use pr_warn_once() instead of pr_warn()
- return -ENOMEM instead of -ENOSPC (Suren)
- expand the commit message to describe the /proc/allocinfo impact
  (Andrew)

Changes in v2:
- return an error after shutdown_mem_profiling() to skip
  vm_module_tags_populate()

v1: https://lore.kernel.org/all/20260804064408.105033-1-hao.ge@linux.dev/
v2: https://lore.kernel.org/all/20260804122038.190270-1-hao.ge@linux.dev/
v3: https://lore.kernel.org/all/20260805090633.141001-1-hao.ge@linux.dev/
v4: https://lore.kernel.org/all/20260810093955.153015-1-hao.ge@linux.dev/

Hao Ge (2):
  alloc_tag: move release_module_tags() above reserve_module_tags()
  alloc_tag: fix undetected compressed tag overflow when profiling is
    disabled

 kernel/module/main.c |  25 ++++++++++-
 mm/alloc_tag.c       | 100 ++++++++++++++++++++++---------------------
 2 files changed, 74 insertions(+), 51 deletions(-)

--
2.25.1

