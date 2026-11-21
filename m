Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5040606A325
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 07:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RmtGv7CJ
Received: by kanga.kvack.org (Postfix)
	id D895A6B00EF; Sat, 21 Nov 2026 02:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39B86B05B0; Sat, 21 Nov 2026 02:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50086B05B1; Sat, 21 Nov 2026 02:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F6806B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:45:36 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2BA24C039A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:45:36 +0000 (UTC)
X-FDA: 85458341472.06.314C46C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 87CC1180006
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 07:45:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmtGv7CJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795247134;
	b=Ez6pakC3kq2RsDP2fJTZKrfOSq+PF+pTRPc7rIC02IEyEj1GVwneycctUhxB5/7uLiGyZG
	5pJDqkz0JSeex400GtFI+Rqc/5ZQ5Xq2ez+V+ZZmjeTZLiFuW1AQWpzy8UL7qEOKGr+fe/
	cmLNw04/kvQiGSOq48+a4CGNxwt/qj8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795247134;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WzJaMs2T6e7SVplt6j1n4FowiofI86G0Ejnb7luKxuU=;
	b=2RdYUtBZNS08chhHvoUwCILOzq1myNI0FUANP9BtLeQV+0wR/BUGD/XB940Xv9OzCgPZJz
	PmWusrF06hitqw+L6L5NNccKKMSZDtbhBaWa78qO5UbR/8q3NjnqM3+OB2422f2LGVNkqw
	YtIhe7t1pQcysU535JCc4UyT0e9+s/w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RmtGv7CJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4418360BFB;
	Sat, 21 Nov 2026 07:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27961F000C4;
	Sat, 21 Nov 2026 07:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795247133;
	bh=WzJaMs2T6e7SVplt6j1n4FowiofI86G0Ejnb7luKxuU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RmtGv7CJ9anPybwJ4a6mmf/6LE/eUc9wg0gsGyfAIibyWRqqaqEzLUAZUlMJzsQkO
	 VQxLxyp7dD0fTVwT2ohaGcAqDlhAUHWTd9zqaMSCa8bkMH5YrvWDIpYHvR+9art0fl
	 ZX5BEzbqFcFzUBiJwtC4Oc4Mji3fbntdNc2u8zF07SjdHukdMMOqH8jre/z4ZUtUi6
	 irIc1s502lIe1AFk+zKtRrIIM3EobPExY+yf30WFMVdTk6RxlDjy9rvvWIVtBqF8rN
	 Eqvtv31wb3aQVPeDgHFG7N8A0AVh3SApzi3XODtTK8veDoBJXgC7ZZ3X1jXn/qSxjx
	 8XBOYHuVM2VaQ==
Message-ID: <sashiko-outbox-226795@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] selftests/mm: fix false-positive KSM fork test
 by dropping init_global_file_handles()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?WHUgWGluICh2aXZvKQ==?= <xu.xin@linux.dev>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, david@kernel.org, donettom@linux.ibm.com, linux-mm@kvack.org
In-Reply-To: <20261120074445.41446-1-xu.xin@linux.dev>
References: <20261120074230.40269-1-xu.xin@linux.dev>
 <20261120074445.41446-1-xu.xin@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 07:45:32 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87CC1180006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: fetk34o3ekqg4g9cwhqfshspbbn3bo8o
X-HE-Tag: 1795247134-16853
X-HE-Meta: U2FsdGVkX1+yPZfXewTb0x5GIk6lvJ9fCVlSS8MBdSAmVYtRtPDnbBaxDo7e3Pw/W+t9Whixb0zPkBEx+JNR0oS9sc90CPcxpR/WVbD8M41xBZcExD2r4Pi8Unf1QY7Y6cG7DNan8MdggztFIWVyyWdSfHSskMMAYVfjxxZQvs/nla+768ybCNXlr7mf7SiTkCKv4iHe2elFkRtqDn+4swmvdwj5QxfbmsOOtmJIjSBo6QpmWKmrYYT/wWTWMjmr0wcvtYkkDT1ibYJMLFpHum1DqW4I5/QPOumNpmhYGjWyhGfbRz+gX2BA98x36+hM9akN8eYq4WXCVd/8S5fwuKr1vU+ddxgBGh5kB6nIlxOCWCQymvB+KkghYMILb80vAfewWRKhsO9GC2rxwS/E8x+VELmcbllPxSYiuKdyvf8BtpH2YgpJL66eNw0rIBeQHwOrvNI+gaBRoGxI26TQd55CGbC8S5WFTrzqiThEke2gSGOssB1n+cHqLmVGCmohGmQontOC1ChLYGEV6BNJx9Edne27xmdLvte22B4AGNQDVFGR4ObNJY8lIfPPz6+RUceJBhxmILLjXkSxX/vp4oPOkmlwzaenB5Ct+AFgfa0R7m5r+4JUj58GugiW9braH0BsKiPndhryBN/JzG5QwXt/MmE0RaBCDt0z3M4JwRJddkC5cnZ0hAI9Y1EBypLk4Vk/ENPucs3hc87Wmdhv+CKaOJxwGNlxpwi13KUCjLdacFsIlm28GQifthvavpmk/thuqjMyZPhGT8Q1AFvnpVy068eQNuffgqqRMz5M2V+QMHD5orwbrcEinjCx0tWQX7mOwFwftCyCFGP0FOzcLmI/peRDKsstNgy2L95RWHNPmYLiEKUZLPzsdgprDqylHlXIxNGLE4cgxlbSC+dmprD+BLdb6B1E6aYfd5DuBDcvx2N1LWzJpPbOrW5aRXKl3YQo9jSyxqoib15CUt1
 +gEtVVEH
 xy3+xctBvGq/Fg9pruircKalPiuGlD8zzder9sHVhkOqPWc0T1OEMyDxeJgPl1BooOXMy4jScgWqnGf5uNpdVz24fsLw2s7iJyM6CpFEuz/l2nOO9nmlk+HmW7eiIYkbBihR12YsKEU9kKe2TyXixQEdny8DYClPFc3wCbpUMPZDOS/pCJmm7jXbX0x4FtMbAM/IDrorvMeS3ymTT5zNRakZHhxbHcXjrgqHjXBCcEWwH240Kf/60u2meRlKzSav8Q+UmRuu9TADVV3OdqduAqvUlIxzssBA6ZhS6hJoZ4Lo8Thq+Krrewm6NFNldHgA/EQ2XGhW6g98lnyG95PV2zBBvLbVLRP8Kwvp1HiKvYiMzrtI5waS270ESOSmblnq8tuLRE6yLUwifylq0SvbOi8mdKKzAACwZHGk/hoMdeSGuxQD4tZi+X2rNbg42On1WdUhfx+SL/lfpYtlNZoheyqaSUNldi0JAQBOvjK9KiSuetZU8kDjfONsnwOJaSKKmGafeElatYjHG64S1v1+8Q890IoOu3RfryxvnqdXw1qFUv6vHS8rvkX0TyKE4Elt9FbKwaHizo2zCHvxEUaQ/xffduQT3nEX4yIaC2Xv0MbSTPNPqwU78UlnWJs5f81r+CAgCglevfLMBZKJwW5eyMwHI1PDyyojkztgclksn1GL2a+4nXtcwOg03VjNMlga0yRAD/l/zpEWm4AgpehpCelT3PHFlMQSdhCKgzcxr0QjNEiGgQUVNQrSI3XASwJpSTeK1s/RfcIIe/g91GY44UahCSP4Rc1RS7OQooJx4jPRojlgUOtO+1MslPmM4ftBwBp1qYVUlCQLp0wi28s0B1roz8XeILazd8YcRJUPx+2bYsItkcm4HFeXqTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] selftests/mm: exit() truncates page count in
  test_fork_ksm_merging_page_count()
- [Medium] selftests/mm: ksmd race across fork() in
  test_fork_ksm_merging_page_count()
--

commit 320ca42efa1f04c6ac42a52e155a4cd5bc860e0e
Author: Xu Xin (vivo) <xu.xin@linux.dev>

selftests/mm: fix false-positive KSM fork test by dropping init_global_file=
_handles()

This commit removes the init_global_file_handles() call from the child
process in test_fork_ksm_merging_page_count() so it does not invoke
ksm_stop() before reading ksm_get_self_merging_pages().

> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/te=
sting/selftests/mm/ksm_functional_tests.c
> index 135191f99962d..c20982b0aff0e 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -670,7 +670,6 @@ static void test_fork_ksm_merging_page_count(void)
> =20
>  	child_pid =3D fork();
>  	if (!child_pid) {
> -		init_global_file_handles();
>  		exit(ksm_get_self_merging_pages());

[Severity: Medium]
Does exit(ksm_get_self_merging_pages()) truncate the page count to 0 on
4 KiB page systems?

test_fork_ksm_merging_page_count() merges a 2 MiB region, which is 512
(0x200) pages on 4 KiB page systems (or 256 pages on 8 KiB page
systems).  Because exit() and WEXITSTATUS() only preserve the low 8 bits
of the exit code, an inherited count of 512 is truncated to 0 and the
test still falsely passes when fork() fails to reset
mm->ksm_merging_pages.

Also, does ksm_stop() actually reset an inherited ksm_merging_pages
counter in the child as described in the commit message?
unmerge_and_remove_all_rmap_items() only decrements
rmap_item->mm->ksm_merging_pages when removing rmap_items from
mm_slot->rmap_list, which is empty in a newly forked child.

A later commit in this series, commit "selftests/mm: verify
ksm_zero_pages is not inherited on fork", converts the exit argument to
a boolean via !!, but doing exit(!!ksm_get_self_merging_pages()) here is
needed so this stable-tagged fix works on its own.

[Severity: Medium]
Can ksmd race with the child process across fork() and cause a false
test failure?

mmap_and_merge_range() leaves ksmd running in KSM_RUN_MERGE mode, and
ksm_fork() adds the child mm to ksmd's scan list:

Parent                            ksmd
test_fork_ksm_merging_page_count()
  mmap_and_merge_range()
    ksm_start()
  fork()
    dup_mmap()
      ksm_fork()
        child_mm->ksm_merging_pages =3D 0
        __ksm_enter(child_mm)
                                  ksm_do_scan()
                                    cmp_and_merge_page()
                                      try_to_merge_with_ksm_page()
                                      stable_tree_append()
                                        child_mm->ksm_merging_pages++
  Child:
  ksm_get_self_merging_pages()  <-- reads non-zero count

Because the child's forked PTEs already map the merged KSM folio,
try_to_merge_one_page() succeeds on the first scan pass ("ksm page
forked") and stable_tree_append() increments
child_mm->ksm_merging_pages before the child reads
/proc/self/ksm_merging_pages.  Pausing ksmd by writing 0 (KSM_RUN_STOP)
to /sys/kernel/mm/ksm/run after mmap_and_merge_range() and before fork()
would avoid this race without unmerging pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120074230.4026=
9-1-xu.xin@linux.dev?part=3D2

