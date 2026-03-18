Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5BBBFD8779
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 00:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F4C6B00C0; Tue, 17 Mar 2026 20:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFBF6B00C1; Tue, 17 Mar 2026 20:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CEF06B00C2; Tue, 17 Mar 2026 20:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 856906B00C0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:52:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AFFF1B7E87
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:52:31 +0000 (UTC)
X-FDA: 84557358102.01.C8874E6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 871381A0012
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:52:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAKqgwQC;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773795149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCrkdn1nxMUoURpcc2zIt70Zl3bs9ko6FRA3k/NS98I=;
	b=8jLLMTNbUA4Fcy5Ut5SCzjx7y8rbRT1+BeUHuwRFkh/1/L9aeVii19nYOGCAYI2bOS9VHF
	OW8Hyusk/uQSfzz8UoLn3/fkLsrD3IWcNRZK9zlaMdtsSYhjbjFxJ3bdmouRJuBnoxYZkf
	NoPcB0+IypI7xyOb5FnRPCxaZEUFG1o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAKqgwQC;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773795149; a=rsa-sha256;
	cv=none;
	b=oRK71QpShKRuFRejR+bSst+vg/s+wMViCI9T/8VQxvKwmPRakc3Y91WRs9ssEY8a/WIxZU
	syYBMDMG6KGhJmHZxFbR3RDjg2yQ6SfXb62z5aJs94X/Zqo9Trj0H8GIyvNHpqNADDmmkU
	cylMYdm4R8CvYqVPn+Zx1t2S/VUgHSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7848643A66;
	Wed, 18 Mar 2026 00:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF577C4CEF7;
	Wed, 18 Mar 2026 00:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773795148;
	bh=EwAMtwt5gp44/cRaugvoB1jqQt36RleL4zmzMKF101c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAKqgwQCiql7vHn4tad5fLGdaN1AsZupyTJyl98S3O7o54/BKNCj+bQeYwiKWfcc/
	 gW32378aRxo0QxLNONKEbBLyceRXu9nyZqULTpo0AMeHkjwXVSZTD4+iZqU1o7Kx4N
	 NIONmUVo492qxWnaSwZOtGN2K7m4xFbmXjwPsJB5ltxvPkh6/UtLQfM7ruZoLOPgXJ
	 q10+Qd0pgPSMhJGsCk7UZAKlUJlz/hw89MTYH0whJ6hhZJz1p+lXSn1juA3/B78kBh
	 QS8q9QZLp6DPgweubphSZQEXgIt5yCi2pKmyltQDaVn1hunFlbeDGNjxeOoEd1kQlm
	 JG7g7O4q9Ovzg==
From: SeongJae Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
Date: Tue, 17 Mar 2026 17:52:25 -0700
Message-ID: <20260318005226.132181-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <247cd41f-e703-4480-9de3-a8708bb3d9ee@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6fx4af7dajtceaeqmub1e15fj4moo5og
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 871381A0012
X-HE-Tag: 1773795149-779331
X-HE-Meta: U2FsdGVkX1+zodRL96EuwINB6ncq4zmhsXMKOe6WQm0lA70v3zL/R4eXiOBinWcU0KuVWFWAimOL3s1JxZTqNruIlHCM3rOKKHBjDOzfhnARybRSV6AthNzQQd9v45BT1qu0kxT+Z6x2FnhIx59dar+6XtMNIYJ8gUPHgke7DEGlJN8BlnZwCdG+tWmRpp95AV+kX2mNmeEFcOlytLhwZnlMUNZrQ82OrgIgDPlpjQM3JB/+TZxSYo8NsVE5WH1WJ2DN+Cg0HXVvgcsRQLvc3IcYsor89e8IAFk1OZB46+amgSlkawR2pIWzCVsFm8hKMesUFgg/f+womH1pBjOK8eDdkh2VWB0mDwCEUS30C86O2ac0JPmgxF/XmKrdwqzuLy/5ZNJ2TVV2u/zGm398JlbOVDzBGUYPMYD1HktJd869pZI0SquT0ECV7XPWrbemTjdzie570o/6PDpWme9u6fGEIgt7Ov9oaWv2ssId2m360gI+Z1eT4YlY0sdHLuThGJwrZowm0gWuQ8QIaR201DZLe85E8xw8/pzGZhMpMcyiXkF+g+9SryUgHfX3yrU9uM9w+Xw5ud/hEC9STm3+m3yJXNwof87P+3El2gzr5l/3MVrRckbjNCyr3u7nCKnzrOCUNDy0F/yC5/jSd1SPbGcW9n39VuN6fGpLpwufapLEbNpZHO98IPkBkfJCliWavDZKBZsvv56PGDhsUH0kl/dzNCat6MmT/wfRyM4rZIqpYOE9Fz54LjCUKJVC8JEatfU4acjINgn7s537RRJEE8O3fwWlvrDcFIjzlT1pKLEsK5BtCmn9KxCsZmXPXOvt7U8KpgXd3BOWOy4m/lY6mX/EqcShBXo5uIrPnxP3FcTyk0HAr5C+9pXXKG6819WA4DTWxXCYHGNMwemCPSwz7enK8efRs4IBP4u/jQ53wtRved4jXVtlkV/XYjzriL+XlfMCxFr2bJjSVfJEXmJ
 +5gpVYI5
 9Gyk2vuv6i4vzJvArkynzSioC+4plkVrbzyQxmdtIHJ9BPgOhzKgr6Xrpul7AK2VdUrbspifD6EGV1wZnbku/oV7SpLc6J2sk4Nb86/SFPY7vlRiQp/f/8ya6/jHSCS7IGylASAZSDhEtfirvgQMyeuFNApfFCR27BQyX02EFwecln3jhrgMaKVbJSh7gIJVBeV/8HpcT1dPyfqSwegF5wptWAMYQOhPy77X2JC32OH3Sehr5Tb//FYRVtwVYJVDtZNY9dqBeskWxtB2j91U4GL/Yj/+pOMfdgI05GYTDKQ+HJAgo5gwlniTwWBA32K/ZKsohgowoDeez/8snhM33VnyzaXAgRm7hmwiLEjkZTS+EAKu4zvyx9+is7BTLFF8G6p1dz0buQ0YqzZofruwe+VkREg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 09:52:09 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> First of all, I just noticed that this was sent as v2 RFC, while
> it should be v1. Bear in mind that the next series will also be
> v2.

No worry :)

> 
> On 3/17/2026 3:32 AM, SeongJae Park wrote:
> > Hello Asier,
> > 
> > On Mon, 16 Mar 2026 18:38:05 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> > 
> >> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >>
> >> This patch set introces a new action: DAMOS_COLLAPSE.
> >>
> >> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
> >> working, since it relies on hugepage_madvise to add a new slot. This
> >> slot should be picked up by khugepaged and eventually collapse (or
> >> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
> >> enabled, khugepaged will not be working, and therefore no collapse
> >> will happen.
> >>
> >> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
> >> the address range synchronously.
> >>
> >> This new action may be required to support autotuning with hugepage as
> >> a goal.
> > 
> > Above all makes sense.  Thank you for posting this patch.
> > 
> > Do you have some test results that you can also share together?  It would be
> > nice if it can demonstrate the benefit of DAMOS_COLLAPSE over DAMOS_HUGEPAGE.
> I will run some tests and benchmarks.

Looking forward to.

> > 
> >>
> >> [1] https://lore.kernel.org/lkml/20260314165156.86647-1-sj@kernel.org/
> > 
> > Seems the above link is just added by a mistake?  If not, please clarify.
> Yes, it looks like I copied the wrong link.
> >>
> >> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> >> Reviewed-by: SeongJae Park <sj@kernel.org>
> >> ---
> >>  Documentation/mm/damon/design.rst | 4 ++++
> >>  include/linux/damon.h             | 1 +
> >>  mm/damon/sysfs-schemes.c          | 4 ++++
> >>  mm/damon/vaddr.c                  | 3 +++
> >>  4 files changed, 12 insertions(+)
> > [...]
> >> diff --git a/include/linux/damon.h b/include/linux/damon.h
> >> index 3a441fbca170..6720dc70c487 100644
> >> --- a/include/linux/damon.h
> >> +++ b/include/linux/damon.h
> >> @@ -140,6 +140,7 @@ enum damos_action {
> >>  	DAMOS_PAGEOUT,
> >>  	DAMOS_HUGEPAGE,
> >>  	DAMOS_NOHUGEPAGE,
> >> +	DAMOS_COLLAPSE,
> >>  	DAMOS_LRU_PRIO,
> >>  	DAMOS_LRU_DEPRIO,
> >>  	DAMOS_MIGRATE_HOT,
> > 
> > sashiko.dev adds [1] below comments.  Let me also add my comments in line.
> > 
> > : This isn't a bug, but should a kernel-doc entry for @DAMOS_COLLAPSE be added
> > : to the comment block above this enum?
> > 
> > Makes sense.  'make htmldocs' may complain otherwise.  Asier, could you please
> > add the kernel-doc comment for DAMOS_COLLAPSE in the next spin?
> OK, I will split this patch into 2: one with the code and the other one with
> the documentation.

Does the 'documentation' mean the change for 'design.rst'?  Or, the kernel-doc
comment?  If that's the former case (separating 'design.rst' side change as
another patch), that's completely good for me.

If that's the latter case (separating kernel-doc comment addition as another
patch), that will make the commit trigger document build error, and the error
will be fixed only after the followup commit is applied.  Please ensure keeping
'damon.h' side changes as a single patch, and therefore no warning or breaks in
the middle of the patch series is introduced (and later fixed).

> > : 
> > : Also, does inserting DAMOS_COLLAPSE here shift the integer values of the
> > : subsequent enum entries like DAMOS_STAT?
> > : 
> > : The DAMON sysfs selftest script (tools/testing/selftests/damon/sysfs.py) uses
> > : a hardcoded dictionary action_val to map string names to their integer enum
> > : values.
> > : 
> > : If the enum values shift, the test's assertion:
> > : 
> > : assert_true(dump['action'] == action_val[scheme.action])
> > : 
> > : might fail when checking the struct memory via drgn. Could the python test
> > : dictionary be updated to reflect the new values, or could the new action be
> > : added at the end of the enum list?
> > 
> > There is no test that uses DAMOS actions that defined after DAMOS_NOHUGEPAGE,
> > so no real test will break.  But this is a good point.  It would be better to
> > update the hard-coded value together.  Asier, could you also update the
> > 'action_val' dict of assert_scheme_committed() function in
> > tools/testing/selftets/damon/sysfs.py for the updated enum value in the next
> > version?
> OK, I will do it.

Thank you :)

> > 
> > [1] https://sashiko.dev/#/patchset/20260316183805.2090297-1-gutierrez.asier@huawei-partners.com
> > 
> > 
> > Thanks,
> > SJ
> > 
> > [...]
> > 
> Thanks for the feedback.

My pleasure.


Thanks,
SJ

[...]

