Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686C4606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BFAwBKbw
Received: by kanga.kvack.org (Postfix)
	id 8938C6B00EF; Mon,  2 Nov 2026 06:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8436B6B05B3; Mon,  2 Nov 2026 06:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758786B05B4; Mon,  2 Nov 2026 06:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1816B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:11:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA936C0CAA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:11:54 +0000 (UTC)
X-FDA: 85389914148.23.D093817
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id B4559A0005
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:11:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BFAwBKbw;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793617912;
	b=I9GktilIVQROzuZqZH+GcH5P9GFsYPukUHnFdgeB7toKeQ5vHl1sk0YQwQ/8VD177IhgsH
	S3D5fnxlq5vYXAkvna2YDnHPDwMhYraSBns7JXPUSH2RTenE0MMMXufyTu8uI30eNSa4eY
	CvKYGot7oU2We2mNvHb6MmBcsyS149Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BFAwBKbw;
	spf=pass (imf15.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793617912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQierFXrtdBxsv90Wvr5GLl7ZIg6QP9xO7JbeTEr+Xw=;
	b=2FXoNBuJ1pbedJyMq9sLsF+nl0CxE2b93SjmkkdijxMYgfpcyZZYvxGFumYNHTSkRVRUej
	2/tRQLMNfpiDbmkRsqXjeA/p4YDcgWtkoCC/ot53IYi77eAdOcJgpmHxa9lA+dGuOka3M3
	K98x01hx0Avg/WTm5oizC4MufzXdx/Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13AA443A55;
	Mon,  2 Nov 2026 11:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFD31F00A1D;
	Mon,  2 Nov 2026 11:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793617911;
	bh=tQierFXrtdBxsv90Wvr5GLl7ZIg6QP9xO7JbeTEr+Xw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BFAwBKbwGTlz0Mn4enaQSgX8dTUg8pp7VJO7rtcJP9h8ODPemnCLR2eNJMPd38/pI
	 o3ypw45HPEIawjkPWwjC7vpedMr/rhrB556WMYHevVOUGn2DSZqM3XyTdvy9xaafGs
	 d+/SQtsBFnDZzf2np20BbCeTeaBHQValygZuXcE0jqxRoGvyrwoaqpftP2ml8O9MU/
	 0HATVm85QPYzXDyRzMncrpNRNw91wJIj2+fA+lGi97MgKvO2KPKjh0YegXTGOM4QlH
	 zeFv0Pn0ofxsDPqODF/sKmuouK59j9ZhHiStG+T3gwfGMbUvELpg99pmqo5mqiQtDr
	 OUMAd/jT7HUPw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 7A9A5198003A;
	Mon,  2 Nov 2026 06:11:47 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 02 Nov 2026 06:11:48 -0500
X-ME-Sender: <xms:8m_oap1pn22irz7gCc14BXj8OEqUpwx3JaQztnNOC7KHO2BMy333Eg>
    <xme:8m_oao2hpwX1d8FZPJSOjgh5MInTWJxHlbjIquzEsa5ouO7aByPoj37Jp-SCbE9ou
    Nx7vfKB-Oa4pHtVAHO_eH4WUmfTl6goBh_HywHjHO3FzyOQfPRy7n98>
X-ME-Received: <xmr:8m_oaomWH4ItRcaBeR3WStFTWfJK0mu8lLjdJPwJHfA2OBb4biLzLTw2OPw>
X-ME-Proxy-Cause: dmFkZTEK1+02a4zp88u4Tj7j1xR++eJHRcOeZsjArkkCuSqZTrG8QN3et3PJ5Yhpp8JgOy
    tSOq45tZMVN3zAAAPAjPYdiYp4+PM3U5Ilw/Pvtw7Ftx3GpE/TzxD++/NwBVjZwRlAofk7
    pgG6siSuYHP+MNHzb/HomkI1yVPL+oawmIR9pZi9gWP0otMusCPkQ232d0l/98yOZyjaO8
    HCSiHgy4dMxZTYLPkGusk7UMm8k5Wt2nCqc9q31PZ/V6ihq/eUyqlvPexGPv0hMZ1E+YGx
    sYu7Zoyhe+tajg6s4E3RIIUMBh/H9WcY7aPjBvRgJ+f/iJ4hRlMvNuh74OMKCJAds2lDaw
    LuHKwEP2phflf9q4kE1iwNJtNjh7Mpe/RdmadkWMkn6nU+Wb0hAdhkVdLAVbDQIOIPTSkB
    lKxK3Thu7rQlxOUPlh1jbY0wFMZNQpWVLZO8yoh/UobjpsE+YBH8Gm+QCT+dRaiS+FcvdP
    zkcv0QSHR1X6YeFjlgRImzCdCwdeFLmZAWzMlz59bkHguqNYREG58mLEZ2yCI5P0Fx7ld7
    0oN+qmyXHVQTlWvextupVYS/txj5aUgCi95wcxQcH7qyY2K7M8bHoBgwfMTdb5Rjozx/jc
    qNE9yUW3AJqwqBNA5BKKdk/cxyRYVf8/3eXZjLEoHkP9zWRSitoidzhZiOeA
X-ME-Proxy: <xmx:8m_oapPFGL__hvcoMqMzBnRZ-INyOEygljbY6EiycThk6Y0F6l6DsQ>
    <xmx:8m_oav7wSNhrP83Arz50u-l3HyYq7VbGbdKXaWdvfmj4GLR7kpXEOg>
    <xmx:8m_oas2GsREdtezfri6lt-3yakSD4672zKA1Jdet-JKU7ZBgwJBZWQ>
    <xmx:8m_oatqcVCgLulftk8UoOuP943tkcFU81X7byj4o9pPXmFkdhPVZtQ>
    <xmx:82_oamkCzupz1ocn0mSfB1WUaZPNn8heBXCkh_JvDXLF73A7bEu48WfY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Nov 2026 06:11:46 -0500 (EST)
Date: Mon, 2 Nov 2026 11:11:45 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yeoreum.yun@arm.com, ziy@nvidia.com
Subject: Re: [PATCH] selftests/mm: handle child status safely in khugepaged
Message-ID: <auhvkuDO8cP9Pip4@thinkstation>
References: <20261030215841.229969-1-ampr.mhd@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030215841.229969-1-ampr.mhd@gmail.com>
X-Stat-Signature: nfq3uumuz5ahb9q8b6m9xrwsp7y7u949
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B4559A0005
X-Rspam-User: 
X-HE-Tag: 1793617912-265953
X-HE-Meta: U2FsdGVkX18P0H1EB2hOQYBi6DHaGRzJQxV0al6nvexgCY/Ql6nWwmj79jjIwwyRGrAkap59/OU82ktP79pr80bNO9/roCfsYXRciQFJDKYe1lNokcWek5Lhmo26QYZ5xyetxgciqyYiSFKjWMXITYGtJatgyxcc+LQ+p4sQQcULxUWQJIHNaZg1ZFM82tM1qM5kTbzNbVR/IN/VKmXfu0mEbaRPrc/51pDSk7p+YkdQx9TCz/Jd5Z7ApZ/ZS6X/YDT1keMMgNhgrwCraWUnO0ZNqjch3Sv0Z8esW5k80CEX6jSNMYMcHh4u8GabT+TL/RMHZ9qP9XU34g9VfL8Lr3AjGAzkvjjblEF+czJ3qqmtFAL8yXfHU/06XrIXFMHfjwn5fE6Ye9VQn0sxOkdYG6kIMI+PEQaFm4bXHOiaaDF7tG13wIV+9hTJpLnjrUzpzztfBwykzv6CPp05NDzKk0+kp2NwcyoSV764xy7quRaASuKI0gOx84/gc0hmtrGQrbXkAlrdAtDw+CCW8qPSgbFuc47RJPN+2k9MNHruql3SkVrlC08HRX3Ni7XsPcz1/veYNrk9Nd9t2GqwU7b/vTQh5IUFQ9njRGc7Fgc+yiNbKfT3QlQ7nWR2hgFvruvNo0UaFEUSK3iD3VQbasALXfbzO9LzFvMLqFQ3R+rVbWXPm4FykM93UhuqKXShOLK8lBm4d/clWy2ekdaswjoA3V3ZHNUBLIZiYLL/f7P1Jg8yLJAbwzBfQQMX1Uez/7uku50KofaqEDEzU2TnQ9O3RV5aVWXBE4GudIs1wHdLxA5LG3KdgIxGQ/pDepMLwFjik1+LY0ayaqZcti6opYKegit0hBvlNhjN+xrKUsDZVBi+aPeN35CdJv/4pk0xrNSiYjn7h3A4rF1lmV8MEB147+K+CrE5hibJssB8fqJ8cucRbzzqPZ/ju9s+qD2vVtcPd9DRn3JIZXShXthJm6C
 6oNwu5oL
 0BSHHeByjOe/SAZZ5OYuknwT+5s63uHNhSEzCZecBHF11xzsKS+GT5CiguOTsqpDY0s2euEPw/e7IeHLws4CXvJu8ksTVALx9Ygf6j92+AH6ZucZ0mpbRDwLwUGovJznD3ZEMmBJLpOBqQchzMuNknXyT5PmNrlB1tIcy+hnXvzakZA/UmrC8BoRM+rEUU+qteQMtq2zSp4vEKwdaE+u/5HD4397uUid81Y70l1oqVdkhTl9emK5XjmQRnMtDU/1ev6WMY869rcsISWwX1OGGSSKFZ/TcCxrGsBFYdzMOytIW2eL6CUR9QMsxMy3PjqlF5GvrKh5MNn+evjawSW0ahfPW4N0GwE/FIRlm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 31, 2026 at 01:28:41AM +0330, Muhammad Mahdi Amirpour wrote:
> The khugepaged selftest reports child exit status through a shared
> variable without checking that the child actually ran to completion.
> When fork() fails or the child is killed by a signal, the status is
> undefined and the test can report a false pass.
> 
> Capture the waitpid() result and distinguish normal exit, signal
> death, and fork failure before interpreting the status. Report the
> child's actual termination cause in the TAP output so failures are
> visible rather than silently masked.

The bug is real: for a child killed by a signal WEXITSTATUS() is 0,
which is KSFT_PASS. The parent goes on with its own checks and reports
ok, so a child that crashes in the middle of the collapse goes unnoticed.

The description doesn't match it, though. The status comes from wait(),
not from a shared variable. For a killed child it is not undefined, it
is a pass. And the patch doesn't report the termination cause anywhere.
Maybe something like:

  collapse_fork(), collapse_fork_compound() and
  collapse_max_ptes_shared() take the child's result from WEXITSTATUS()
  without checking WIFEXITED(). For a child killed by a signal
  WEXITSTATUS() is 0, which is KSFT_PASS: the parent runs its own checks
  and the test reports ok even though the child crashed.

  Fail the test when the child did not exit normally, and print the
  signal that killed it. Also fail it when fork() fails, instead of
  reading an uninitialised status.

It came with bd212a7dbdb1 ("kselftest: mm: return fail when child test
result is fail in khugepaged"), so a Fixes: tag would be good.

> +     exit_status = WIFEXITED(wstatus) ? WEXITSTATUS(wstatus) : KSFT_FAIL;

A child that dies in the middle of a step leaves the progress line open,
and the "not ok" line ends up on the "# ..." comment. Could you call
fail() with the signal number here?

> +     while (waitpid(pid, &wstatus, 0) == -1) {
> +             if (errno == EINTR)
> +                     continue;
> +
> +             fail("waitpid() failed");
> +             goto out;
> +     }

The test installs no signal handlers, so waitpid() cannot return EINTR,
and it has no other way to fail for our own child. A plain waitpid() is
enough.

The same check is now open-coded three times, four with
collapse_fork_cow_race(). A helper that takes wstatus, prints the signal
and returns the KSFT status would cover all of them.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

