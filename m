Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A784D148A8
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 06:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E186B0088; Thu,  8 Jan 2026 01:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9164E6B0092; Thu,  8 Jan 2026 01:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814BB6B0093; Thu,  8 Jan 2026 01:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B55B6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 01:26:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D23D1605E9
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:26:43 +0000 (UTC)
X-FDA: 84307813086.17.0FBA4BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8C8B4160002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 06:26:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9abBvZ7;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767853601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBVVtfx0YDlMsLQFIJ58x6MiIAvHJS1+LsyVh2EEvJM=;
	b=Zf+c/q2Q0eqWF+xLJEnvCqeKmyfiEEncfbhOOMAgDWe2FMQkIWxlRIOZUhs6EBZ0k/znHD
	Z1pOBmyEiXaYlj84/1S8wYI54xc/DAraJjtggi7TOI3y+rSeEOogFJhySzCoEDoK0Z9xUE
	GL3pIUXcozIqLffXsOjscEGhYIQnBBI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k9abBvZ7;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767853601; a=rsa-sha256;
	cv=none;
	b=31dhXTf0B+6u2qVZSl8CEjI4SjaSxFYVYAbhP2xlyuYdOMBLIjlFNkwTZH/gK69stY3YTH
	UXORHZ5KSyxQVtBruSHCX3uityHS6Pys0D2JetXbpZoOutaRyUPec4iNhivyI/wobI1o6B
	yxldDEtG+WH1cgwRC22hhbmntkPQ1V4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 911FB60052;
	Thu,  8 Jan 2026 06:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C943C116C6;
	Thu,  8 Jan 2026 06:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767853600;
	bh=FXGutq6VERqgV/hjO1g+5GcrQN0Ow9xSIPz4swkwE0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9abBvZ7OkmhQeXd4ATUETLzXjy9eZBg42jUPZb41bpUBq04gitab1wpF6LYacQhu
	 Em5IyyUBPU9j6oso5x89RDv0xqjuTWAVn3pbBwAdz9wA1D4IgNdLMcgWF6oTn5hMJV
	 Utz/BdYWQeeFHONi7JR9DtIFU09kt2kYw7U1uEdShAnES/um0uIw3wgfzbmClVGPb3
	 B+ApGx4GeF0MbzkUtHsJbFHCocSfLwfxvAB+fWNPDkn/ogtqBNbb3VVB3Oohn5V4AP
	 0qqscOlYhxk6iDxuON5M7Cq1mYURkKOBtmZGo+l3JbJpe7Q9K8Y3Zdo7uAjlrLn4UK
	 dgPTDf0YAqIbA==
From: SeongJae Park <sj@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	David Hildenbrand <david@redhat.com>,
	amd-gfx@lists.freedesktop.org,
	linux-mm@kvack.org
Subject: Finding mm patches to review before those are pulled into the mainline (was "Re: [PATCH v2] fix AMDGPU failure with periodic signal")
Date: Wed,  7 Jan 2026 22:26:35 -0800
Message-ID: <20260108062637.82125-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <f6pged4wdv2qrpwn6uiqeampyi4m64xoey26eudw56k3txu6oi@3uwgwbyfrlwm>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C8B4160002
X-Stat-Signature: b5cb1pkextwx5qrht419eminm3e9f1wk
X-Rspam-User: 
X-HE-Tag: 1767853601-125093
X-HE-Meta: U2FsdGVkX1/d55ku5VdQiwl9SQH7VctYJONVXy4Aa+ZxCzP4X+M1Q1WQ+IgebBnJa1XqXocqiGpuWG84ki/W3IMsHSBQ5lMRY3PATT/4t5mEM4dqpF05khTSIEEDFZ5A76HZJAGqd2q0gS4iqQNfgs6fUjDx0ooJTYMLtLz/Jc7EWtrNFErAoLTewDrSHYd9QFcS37pdcyyFV379te2mL4BtCrYftoLcDUSZrl/4KcTbIb/XA4AzUWyI/8SCk6Lgv6+tedC94Wt5wf+ZKB1tEYy2QfdW5v3jv3FkZIjpR1XKcKNYGqOOCZOGA5I3KxsuuwSxJKkCaS8Dl0UfVp2Ij7D37zO3Bh9PM7elNgEiKyWodIIMU5rtdPAmj9YjBHZk1rAN4MRdgQ19+kvncca/hGt2D+CdgLpyfFa4lY3If28cbFd8ox5engzudL4vAC8Q2Rm13F94UJeLJSbzLdpYRGx6DnCZb1b+OS8QEsQYOndcBzYNzAhddKu7lWp6j4zjsVnApJKrL1V296Z//tbWrMH3S+/v1Hsp359R/WVWhUiR0ftX9riL4MjVbmcfJLRj0PDnCfz4Gp5jF1GFOWUMwEG7pnKhqcB4mTGFZFc+wsRGlCilN2aD/L/lPkdhMArjyscgeJvBlCfip00Xm9KI4Ku+pfcUhTqHklvoo8ZdXpAWXztYU6H5lSeiTTBHdotgiPDp5yY6QLWQ4iuSUTPIAfYhVNyfs5GNxT3q6nNId9ehMIOaT3VZsXU8AQ9jYVdCDfx++9g/a6DXzwlSnAXuMAf7luWkxwbFrI6Uwy12rBp8ceXU0chxY5koI1r5lDVcNIhFhH1sd/32HsuYV+dOB9hzVyjAUMUUHi0oFsYTz6wwZU73YEWb6A6J4GOTVmwvrueRR+qmGu1NC0T6Cuh7bNUMO7f0OsTovBOpQLcJtAUhvw2mHvRxEV4nWJgWUrkKzJzAREOexyu7V9RLVOK
 0kYJW0lT
 4IMo2/TZVkoXPQXzQipVIBaMOGdO0Kf6mHOuJ/Nl/mT1w4u2XySXGKLnJ7OQ1pWW7ApjtVfD+t2AHYpzl/YpybXKjDbXf926YeVKWqkvB+mV9wGn2MceBBlEQELaJqG3zh5RVcV8rXp9FHaqEEn2fQGG65m3+V0kstEgab+pTqn0L453isZ9CIHEMkHf8r1b/PxH2N5UPFd+pHiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 21:52:25 +0000 Pedro Falcato <pfalcato@suse.de> wrote:

[...]
> I understand your point. I don't think anyone wants to see patches falling
> through the cracks. But we also don't want patches to get applied without
> any review.

I can also clearly see both Andrew and Lorenzo are trying their best to make
Linux kernel better with only good faiths.  I always appreciate their such
efforts.  And both their opinions make sense to me in their ways.

> 
> Perhaps it's time to deploy something like Patchwork to help track
> outstanding patches?

Nooo...  I'm too dumb and lazy to learn how to use Patchwork...

I believe we always have rooms to improve, though.  One way to resolve concerns
raised here would be asking Andrew, someone, or some tools pinging relevant
reviewers of patches that Andrew wants to add to mm tree.  But I think that
might be too much request for a signle human, especially for mm, which is a
huge subsystem that many reviewers exist.  And because the reviewers have their
own tastes, the solution may not fit very well to all the reviewers.  For
example, someone might dislike directly getting such notification mails in
their inbox.

In the past, I actually considered making and running a tool that scans patch
mails that not Cc-ing relevant reviewers based on get_maintainers.pl and
forward those to the missing reviewers.  But I didn't make it because I worried
polluting someone's inbox.  I should also confess I worried my electricity bill
:)

As an alternative way, I was wondering what if reviewers consider mm tree as a
kind of compacted and curated version of the mailing list.  That is, using the
mm tree as the useful place that we can more easily find patches that we need
to review asap.  If it turns out there is no time to review immediately, the
reviewer can always ask Andrew to wait.

Finding such patches from mm tree may be much easier than doing that from the
mailing list, since the number of patches to look for is much smaller, and
writing scripts for that would be much easier, since we can use our favorite
tool, git.  For example, I just wrote below simple script to find such patches
for DAMON from mm tree:


'''
#!/bin/bash

if [ $# -ne 1 ]
then
        echo "Usage: $0 <commits>"
        exit 1
fi

commits=$1

review_missed=""

for commit in $(git log --reverse "$commits" --pretty=%H)
do
        commit_content=$(git show "$commit")
        if ! echo "$commit_content" | grep damon --quiet
        then
                continue
        fi
        if echo "$commit_content" | grep "Signed-off-by: SeongJae Park" --quiet
        then
                continue
        fi
        if ! git show "$commit" | grep "Reviewed-by: SeongJae Park" --quiet
        then
                review_missed+="$commit "
        fi
done

for commit in $review_missed
do
        desc=$(git log -1 "$commit" --pretty="%h (\"%s\")")
        echo "review missed for $desc"
done
'''

And it indeed found some interesting patches for me:

'''
$ bash commits_to_review.sh mm-stable..mm-new
review missed for cb844296e68a ("mm: introduce CONFIG_ARCH_HAS_LAZY_MMU_MODE")
review missed for 7bc3a776d611 ("mm: add basic tests for lazy_mmu")
review missed for e8dd7a6b54a8 ("mm/damon: fix typos in comments")
review missed for 999d5100ccf7 ("memcg: rename mem_cgroup_ino() to mem_cgroup_id()")
'''

The first two patches are false positives of the script, but the last two
patches were somewhat I actually needed to take more care.  Thanks to Andrew
adding Link: tag to each patch on mm tree, taking the followup action was also
super easy and smooth for me.  I like the results more than I expected, and
decided to keep using the script.

And I now realize this approach would also work for people who didn't list
their name on MAINTAINERS but still looking for patches to review.

Even though the idea and the script may not work for others, I just wanted to
share this, only hoping it helps finding another idea, whatever other than the
Patchwork [1].

[1] No offence but a joke, Pedro ;)  Sorry if it was not funny.


Thanks,
SJ

[...]

