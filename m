Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69B31C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 05:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DE76B0092; Wed, 16 Sep 2026 01:57:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E6566B0093; Wed, 16 Sep 2026 01:57:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223D16B0095; Wed, 16 Sep 2026 01:57:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F39BE6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:57:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 742521205F3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:57:21 +0000 (UTC)
X-FDA: 85218567882.23.DCF7FF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0CEC18000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:57:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hfjbn/14";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789538239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6SKrH4CseAWkOxTNnD7adA5OG5gHGdFDKDZV8MwdQo=;
	b=SPOTwaFW0AFOu+Ja9VloY1JbtZxn0vTQ0yam9TEjR523OId7b1wzC/aEJmkwa7g0CcLbwr
	s+pIbahG5VZ4j6vQ/Gs3Tx1OlHAYlBicNCKxjkNWDzrvYZNmYpq+LMCeAn5uAefImmUlOG
	4VfnIEZZPEgNxBuZtGYNpDoA5+Nttpo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hfjbn/14";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789538239;
	b=vMK+92RaBXH11kUJGtQNznza2V0qZ017Pf7vzjpKNJ02Q4wxnGn1R9pv3NWB/Cax6bbLsQ
	GJFXssqC4iGlYYm9Hrtw9aD9V/T5RXYd24vN9YNv7M1oa2xckO+39rncMaZ13PvjzQ0Gp0
	mEHQl4PFu9o0OOICeucQXbegdMsk5/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CDAF2419F9;
	Wed, 16 Sep 2026 05:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AAF1F00893;
	Wed, 16 Sep 2026 05:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789538238;
	bh=m6SKrH4CseAWkOxTNnD7adA5OG5gHGdFDKDZV8MwdQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hfjbn/14ap3NphlFUGF122siXy5FCwFpEPoVLD/bkd+cBzcIjiKB6/MC5XRcHHUDE
	 BUE4Y8+QMyH1XCUvSJSf8eRGEfjMlCj9wnfBzVCwFXv3IwxFVMtGNTuAHgTBJe5pID
	 OEQI12RtTWQ0jmOWZeDg5lNVuxrA9jf6Ykbl8Z5puaZI/XWFlizjnsciuMt2Zezswm
	 EweQSqqGtp5HWk8w+BJ3a7A4GO0DotOvPw6wNEwfag0dnM/3DhqO5Dk/0n8lR3qJAi
	 sG+5atyvp3JADGHGrMHBXPGJvYivWpXwzTF9csYn4q23Zn7dnYeNgsS0Z5qUcu+u50
	 jXFEPammnloAg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/8] mm/damon: introduce hugepage_size probe filter
Date: Tue, 15 Sep 2026 22:57:10 -0700
Message-ID: <20260916055711.24926-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915163928.9d6260f445d895429d115fd8@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C0CEC18000B
X-Stat-Signature: qsfzmxrzqyjip73bk3pq6bai58ea89go
X-Rspam-User: 
X-HE-Tag: 1789538239-469884
X-HE-Meta: U2FsdGVkX18pE0TQ2bjnxvxj8Ps2VE0xgNwu+opZo45Qk4mNjITSqjCNwnCkFjvqSxXstIe9WM6kGyTCo+WPysFMN6flQYXuX7p5vC6cKnHruVbWzIQzGTjNX6tj88TkZSxvv6dmcgeihIVmAG1ocrN+xVkd/8uG95WGoVcbogud3ZeHiC9u9VB1xneLUrCYw0PRuBHWa2MmizfAyAuDxCGhaAdcKO7GOfTdyACDzuqLn+gfWCDsjcfr3GcYOQW+31MJMjxlcZ/Ci5Uh5SkQAw5RwTUAkpHAuTSAdpshaHI+QcpZLE2Er1aAnxNpN/MJSNDa2SWZ+pPdxyVe0fwPgWBI//7BCKn4EiYH9QdkU+whP0UNJQceHhLqTBRtcGhuFjfHnpqGS5UjgitrUoL+ngv5wkqw+f+k8G3R8IrNKX0ny540Ql5j7G5HX4hQHkfJVoa5t7QlJmKi0589OGWtfBbeVrrTlIuCViQ0cRvta/4d+s4KKHWJNI02/NIRWoyWtOMTGfiyLIeC53ABJO0pKceZFxbdU52ez/aNZB8ia/I8apBxnxd3iCX01QirztjN+PSr/6nRsq9aRH0Mv5gu8hz3NgId1lxWcHtH/sn78m1fyRFBV1jJCq3kVHYEw9zAG4jJjjGq5Nwb2MbxD5ORBdY3d2BBXUgyzluE6wWJlM7CmIjMPMlnei0RgjBYlXOp4wVZmKHroaDfCoG2Y7ItIURMJ38eRrHm/j9jUZ+eNGkgUlQQrtXS1cCou8gcJLSik5aT4RMdisYXKCs8wRv8Qf8F/3Yc4fcND6I99B+juATyQVSFhYJlqODY5caGRlND5lfQgOHswz6YaEl1kweGKaIbnV1aBne4eKkSgK3Wt0z+Z+qi3NE/NrXZ40i+fTVWiwgBVpOEZ7fsOSt8F4ml9V0ae+uSfkKpAEHpEoeRnRqweKEV7we8RQGuoyy7olytAjE3/NquwFXUEHLPJeF
 VBVRDx+t
 lc6oK69YWYmijbgocnnxXHiyiCj7qP/G4RMvj+jMJncJ8E2BgZy1pLcutGwUaprkNKOHzhVhr1va/gGRk6foCP8KaN11To1fWbDav0L4KoZBNkZrogNiHgFkC0usw+RTODM/TfSwDAmC3nvgTDT9oNgmRebxhYS2DsVZp6u4027T4auvsw1I3cfr74WQiVBHCkKRgTa5MRfu+iLnLUzzujzka0dAamQtnvjuXRp5jce1px4Cq/82oGyXuUiTwMbZGuuoXwFRNRHE6fBNsXa7n71DMj3uPaGtyYK4R92Q4sP+FhlQPpd/ax/Xu+/PYwEb7sRNHnPSZJCNRcXWwTWdCy6BuqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Tue, 15 Sep 2026 16:39:28 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 15 Sep 2026 07:33:49 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Knowing whether a given memory is backed by a hugepage of specific size
> > is useful for efficient utilization of hugepages.  For easy monitoring
> > of the information, introduce a new data attribute probe filter type,
> > hugepage_size.  It works similar to the DAMOS filter of the same name.
> > It works for memory that is backed by a hugepage of a given size range.
> > 
> > Patch 1 introduces the new probe filter type to DAMON API and extends
> > related data structures.  Patch 2 updates probe filter commit logic to
> > handle the size range.  Patch 3 Updates the filtering logic to support
> > the new type.  Patch 4 adds new DAMON sysfs files for the size range.
> > Patch 5 updates DAMON sysfs interface to fully support the new filter
> > type.  Patches 6-8 updates design, usage and ABI documents for the new
> > feature.
> 
> All queued up, thanks.  With a -fix for [7/8].

Thank you!  I found the -fix is in the mm.git as below:

'''
$ git show 81c69fbb4128
[...]
--- a/Documentation/admin-guide/mm/damon/usage.rst
+++ b/Documentation/admin-guide/mm/damon/usage.rst
@@ -309,7 +309,7 @@ named ``0`` to ``N-1``.  Each directory represents each filter and works in a
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
 filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
-``min`` and ``max`` files acts as files of the same names for :ref:`DAMOS
+``min`` and ``max`` file acts as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.

 .. _sysfs_targets:
'''

But, I think it is slightly wrong.  The fix I requested is
's/files acts/files act/', but the committed fix is doing
's/files acts/file acts/'.  Could you please fix it when you get a chance?  Let
me know if there is anything that I can help, too.


Thanks,
SJ

[...]

