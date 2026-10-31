Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84113606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a2zKxdT8
Received: by kanga.kvack.org (Postfix)
	id 911C26B05B1; Sat, 31 Oct 2026 16:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1CD6B05B2; Sat, 31 Oct 2026 16:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7796B05B3; Sat, 31 Oct 2026 16:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBA06B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:58:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D01D51201D6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:58:00 +0000 (UTC)
X-FDA: 85384133520.15.38CF702
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 38BF0180005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:57:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2zKxdT8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793480279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ME/DwqzmVxiuu2qCC6yi8ywsrQDgzY0nAzN4XnJ72s=;
	b=OVFC5Zum8vqmmBJGcaJPHLiQ/rGPa24oB+od6jo7RFVY6WdJF6yyJ4uTB1mccMCerVJXV2
	d+Yxi+k2PIGtBx7x38AmQ8qX5AK+y6mi7DY0fLpSPJnvVDPpxkGKp2UVS5gSi2rpeykvDx
	h9KMeB7nzkcu+JtDv4IsJE3lkXrsqGE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a2zKxdT8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793480279;
	b=ac6h8m+X6PrMpLlow/UJ+qKSmuqtiZTM9DFbfRkNQ5EbCqaKYqTr7GI5KIBxA8AX0AtXNO
	wyq2Lp3DmCm+XOF6cHQxFdJ2S5dbOpvvUuwN4kCdE2ORLgEc0I87U36r/AAuXPBeEWJS1O
	wABA+m5LsaYYQvaql0xJCu/5IiS82b0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD128600C8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1231F000C1;
	Sat, 31 Oct 2026 20:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793480278;
	bh=9ME/DwqzmVxiuu2qCC6yi8ywsrQDgzY0nAzN4XnJ72s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a2zKxdT88rxs4YIcSMs5D84GMbDVm/XhD4gZ07oiTDLAA8DEkyNOah0XcscTm7V9T
	 +tg978hxHZK64QEYIAcecR8fmrQ3InNoL01bVp5ggvWjEnLhEcwNEfXovgP4QoPXCU
	 FqZ40Ef8/6JGAkCgR1p31s3UKv69HpwHA49ONdsKA9xb3D5qeEm8GAxooClXkaue3K
	 YrVjqRrD0exk3GMWJDolJp7bXkIyh+HzswzwP784X5NIowMtaWlg97SZ7LDzv2h5Kx
	 bV7Ld4p58+p5RjUTcaiM1KQKdhHbCmyrKiaLWXdpm1ssqmxg3mtxtH+pntaMpamt0y
	 zuRSkpiVhGH8g==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Shuah Khan" <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 6/6] selftests/damon: remove unused imports of os and sys modules
Date: Sat, 31 Oct 2026 13:57:50 -0700
Message-ID: <20261031205751.97240-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-192115@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 38BF0180005
X-Stat-Signature: 5u1r98ct19eihef1jc65wqtr78ia7ukf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793480279-152863
X-HE-Meta: U2FsdGVkX18VQ1BVxZBy8J2PODraFQNEtB+y+PeMXGxAfk+nPr/mVNLQfTGACtqfVIh47SeWXJsENRsQNa/bBQj18apEW/uuNNfGfcy4XOsxkfXyz4PzuMCSvc0UyCK/Vl5qm33PjOfPf0a3i6l0M7C59w13i71Iwkcw5UO1b0UpnL5SBb0r0yxBCQNkKtMSI05B5qpD5L4bO/Ez71sRDou/215hhGpx1PRJQ4rD3GReJvK+hwJn+/iYuJFEeaS3YQCBzJv17lokOB25au9pa15QIFgfVA7XaQb18586su+aFeBz43io94eTZCYUNr7T85CDs1rai/GX/zQTjvhCM0VNy8IHhMJk1FPXrMa0pb/UxrrtAvt5GTTPatco96TumC+o50MxUjr0EBwK5kn2hqFxrV0HhU0ijrlXRSD8RonPnXWEqpiP+Fm3KB2Jw/pAsE1G610dR70KMpeeTEynmkNJCZmAKf+RH1sOeYiJGT0uH8O4zxRvVNYI1wBsBFtJXT1zL3+U7Iq01Qu0IoZp7D469Zr/v04QaY5sU9w4qLbZzrYAQoa2mzB2whXRQ4Bdr8Vj834n3j4FFd9l60ebWUVTAQYfet+ZW7xvpovYrMG4NBKBQDZ/QoHOCVAXn/ZIXra3FeZ40PQPmKtLGE9hvyLrx/nHBKEofthShrc6x+8c5qq2WzXj8NJEbl1paExoJHsndpMzAi0lPI0fCNLjCAfPT4FT+58DFbClTzQ4PC4pPRk8FJfA7MhiU3L0E8cbcSIIsGbPv4fVLYUe/C0rEBla0CICcXHwAQa6ydmLeqP9CXPf2VfHzfnSZfV9uDPGlF7W1Y5d60KDQDzeMBkLWdeIl8s+rF1Y6uoY1Nii+uzxycqXJN4piWTzcLFCXhdHHuz2XHjsDS5d11Pg6K7kyp4ASt5yFUK7h8ZlbIzL7Ql1lGUZNLMOUZUdp8tZJ4HkV+o1KwqZXH5S5emhTtp
 75LD1dIk
 O3XIBPxN3UYHTSUc2/fPhPkv6ERGcEpLuVilYJIJL75WhdJiO3aTasQlep656dFq+KKusV7hHy65Yiyj9YQPzqNzJ9g81SI4NQodxTQBVdtI+gQ/+K6qAWmYGnedfdpON/MnUjm0veorHY0ENUBB2KC3MRxfuapRhkkHxf71sA1Ipwe5pb/VBIuRlYqaDuiLMj/+sHEqIK63JJY6Y7zXY8JkqhzuN3zqgdKGZ+DE3UWDZmpiKZExNk4k+KJGxyju+BTgDKj2aSifVaL4Shr4+03sa8YKjtt5U1cT0+CW7N4Ck586FCLTxqWtj7PTEuML9yDcqIqlj70AEjAT8XxgpvIbqEyfqLFskaMg/NujCEaqs3JFfuRSKvFgAJL7lmAqLuQ7+d8SH++VCjfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 20:29:00 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Low] selftests/damon: commit message names wrong removed modules
> --
> 
> commit 55304159b940aad6f9b71d318671a40d9d63ca46
> Author: SJ Park <sj@kernel.org>
> 
> selftests/damon: remove unused imports of os and sys modules
> 
> This commit removes unused Python module imports from two DAMON selftest
> scripts.
> 
> >     selftests/damon: remove unused imports of os and sys modules
> >     
> >     sysfs_no_op_commit_break.py imports os module but never uses it.
> >     sysfs_update_schemes_tried_regions_hang imports the sys module but never
> >     uses it.  Remove the unnecessary imports.
> >     
> >     The issue is found using flake8.
> >     
> >     Signed-off-by: SJ Park <sj@kernel.org>
> 
> [Severity: Low]
> Does the commit message name the wrong removed modules?
> 
> In tools/testing/selftests/damon/sysfs_no_op_commit_break.py, the patch
> removes import sys rather than import os, and os is still used in
> dump_damon_status_dict():
> 
>     file_dir = os.path.dirname(os.path.abspath(__file__))
>     dump_script = os.path.join(file_dir, 'drgn_dump_damon_status.py')
> 
> In tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_hang.py,
> the patch removes import time rather than import sys, and both sys and os
> are still used at module load time:
> 
>     sys.path.append(os.path.dirname(os.path.abspath(__file__)))
> 
> Should the commit subject and message be updated to refer to the sys and
> time modules instead of os and sys?

Good catches.  I will fix these in the next revision.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261031202614.96036-1-sj@kernel.org?part=6
> 


Thanks,
SJ

