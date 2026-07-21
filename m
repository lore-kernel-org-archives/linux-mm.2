Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B51FBC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74CF6B007B; Tue, 21 Jul 2026 05:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C259C6B0096; Tue, 21 Jul 2026 05:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14876B0099; Tue, 21 Jul 2026 05:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 860946B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:30:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DEB75C03FD
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:30:48 +0000 (UTC)
X-FDA: 85012264176.22.1B408EE
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf24.hostedemail.com (Postfix) with ESMTP id 062A8180007
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:30:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="d/waB1qO";
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784626247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJbsqN6wqYrtfAxvXkhAoP2bYCz03A4sparHJIC38dE=;
	b=b0JhkfvwhnmNp0oUb71uC0m9EmujINd8NNrA8PzXmsE6FZkBqm4q1fQGxpsAO1lpk5NQBu
	PzPg+gQ9lBs7rX4xUmf17PRbdGs2x5yBnRj0kZTnXdX18PVEhqAkHSWDDD/Tkx1cnBX1ne
	OEPx2zxum4Sd3CRupwD/o9JMxFDDMs4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="d/waB1qO";
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784626247;
	b=5NbhYX16M5ExNIzbnwbswUxCzSoKzpH6JOb34qQErb642M0eF2yxI26GnzVaigSHZmo3O2
	dp5i9tpzHcWTM0la+w0XYvJ0VHkW3v56DUYBSwwfCOHUSOhN9UUnIRJdlU3bS3AdpaVbVi
	5oGhmYlZ60gACByO4QpUzYnyo4WFeSU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cJbsqN6wqYrtfAxvXkhAoP2bYCz03A4sparHJIC38dE=;
	b=d/waB1qOowvCbjjPKalGiMhNHDsFZrHvKEHZlV/nJrLXOgmgPkC7nDlJRnAO16DkaldMP9gWd
	aletERf6DHgMUR4iKCXmqmCq/Cr6ZvibLW7dIaJRLDqN5VbVvp+15UOKCURwB7wjglTTNp+8f+o
	lWBEFP3d2ypJVutMKNnzRNM=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4h4Bhc42Lcz1K9cD;
	Tue, 21 Jul 2026 17:21:20 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 63DA840578;
	Tue, 21 Jul 2026 17:30:41 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 21 Jul 2026 17:30:39 +0800
Message-ID: <e674b355-b4a9-4205-9a60-a1c49aca6758@huawei.com>
Date: Tue, 21 Jul 2026 17:30:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 11/15] arm64: syscall: Simplify el0_svc_common()
 syscall exit path
To: Linus Walleij <linusw@kernel.org>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <kees@kernel.org>,
	<oleg@redhat.com>, <luto@amacapital.net>, <wad@chromium.org>,
	<thuth@redhat.com>, <peterz@infradead.org>, <mark.rutland@arm.com>,
	<ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>, <yeoreum.yun@arm.com>,
	<anshuman.khandual@arm.com>, <james.morse@arm.com>, <tglx@kernel.org>,
	<broonie@kernel.org>, <pengcan@kylinos.cn>, <ryan.roberts@arm.com>,
	<liqiang01@kylinos.cn>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260721081858.1169276-1-ruanjinjie@huawei.com>
 <20260721081858.1169276-12-ruanjinjie@huawei.com>
 <CAD++jL=D1S7HE9dVwHeOyAmu-6g+BGq+f2=2=BUX-4tzp88NOQ@mail.gmail.com>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <CAD++jL=D1S7HE9dVwHeOyAmu-6g+BGq+f2=2=BUX-4tzp88NOQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 062A8180007
X-Stat-Signature: xex4m5su5kqqhfjnhngq7fack85r64mu
X-HE-Tag: 1784626245-427805
X-HE-Meta: U2FsdGVkX19mE71X6Omd0Y3Z4lndLMsavnBNYSdeToq+LOLrADw1Wx+U5QfPr31QZY5FSq5vJyi40h4qqYr1HV3Fmx/JN7ZzBdzmPUyluxvjwL4BvbQoWO1njCVqTDErFKSp4/bdTuMxRckQ1AGk/C0IRiWwFHmc+TR7r51tIggWbhsiW3bDU7Z8kqeucTdI1gDQ3yH6tyohqsPSTA6Y0s8chY9yk0I32qGwLuK0DnA71ytZR565EWxJ7nhhBamXZbe36iU0r7kqNUy8/TkKppCku1k1U5Uhuw5hrHAWlnRDxV7yjrjTMxdJpoYq0FlwAv187DBPOGiUm5i5y8lOhDHD1Z2by2EbIU/PnIdKFpZLNndpIJ635fdKna+CyUW/FuC6rN8AbED6Ol9iQvELJ3o675FWKVsCiQZGpZ8Q3MyR65JdZhF14y2iamJ1StxV9sH8kKiV961YMRIEznmcexCDPuOdLM/SRJes1RgN0iSWexsEzMzU92S6pajiXgG3uCdQyDkfWBnMuLUXxQNmmqqcgjdHiJ0aRkfDAyDQww5X9ak+2D/aTWp1RGIdYUdCSuOUnXfqPlgOxWxFPoD9t2X00+6xrm9t8eHKp0vprcMJxRG3ai27UafO+fpXA582ZPTs/sh2A7PWsG/qHmM/hA+Ln6sk6oVW3d1+NiE/YzaOdGUIVU70k9XVRs2tHxLc9ErXmhU9NWW2MSTHGjN0DU392XWlcmHRjE4CmJ0+ukWUHPY21mLxLelEbWk5GXOkNKbMRPZjJUsRkrQ+Bce8iLW31RTJfLhLyctDvrlv6oDDxfpj4T/vPq8Bh8ixahKVlDycY4M6XlaxVIbztIQbFyKKB1YIVe48Nc+kQiO5VvVDVzQteMHjj3By9XJ8awSGweVQ+qKKLpth+w7OyBzL88Y037dF6Q59d/o6+Ig9UCfidz2WSzQKjvK5Tpgxcu/Jeb1AMuH1EGBxr2BDVNS
 smd9j9cV
 5Do73rOSGEetuaBmB1yvMJtRURo/6klob08sUuVY76DCa1xr5hw7DXtLtqlMEmjUyDSOb+i68rOKinw9YbgH8enC9jxWKu4aes0Q0WYMoQ84VntLJHcgYaOcnjKUEh7Gl4uC21+ERQVXrI+8kErXt6Pc21HpRcH1SW1lF3tal4gMmM6nmNIiwQt11D9a55hnksa/mEPsesS96/TLZrLMpg4T0VlpfMS2MtLsY5XB3eIXkjJGgST1K0Thbo2EZbyx1WFNF2gLUy5XOacsKDcSXgGtXlLLe9ZtIOp6gt0eGMw5sbKy9s0Msna5xpG10nXzu+3BOrgMeFNB1amuJb1rXJURwvt6MBPIMZ4ap4wntrSN3W6e7du6OeQ0ieT7qa9EZ7WS5u0uf0mOXoRLdS+a3XsyZNtWl1NLR0P0aU44TyJwUEKB4T+ElT1uDh0+FwmDCNeZDmcx6olheqgkzkDVx7PolrWJ46bISA+f0RiXT4JBQF7+mcTzimJ/t/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/21/2026 4:51 PM, Linus Walleij wrote:
> On Tue, Jul 21, 2026 at 10:19 AM Jinjie Ruan <ruanjinjie@huawei.com> wrote:
> 
>> Remove the redundant nested conditional check within the system call
>> exit path of el0_svc_common() to streamline the exit sequence.
>>
>> When entering this fast-path block, CONFIG_DEBUG_RSEQ is guaranteed to be
>> disabled so the call of rseq_syscall() is a no-op.
> 
> Please explain why this is guaranteed.

Yes, there is a little unclear.

The expression "!IS_ENABLED(CONFIG_DEBUG_RSEQ)" evaluates to true only
when CONFIG_DEBUG_RSEQ is not set; with the guarantee that it is
disabled, the condition is always satisfied.

> 
>> Under this constraint,
>> the code logic inside the block becomes completely identical to what
>> the arm64_syscall_exit_to_user_mode_work() helper already does. Replace
>> that nested logic with a direct invocation of the helper, eliminating
>> redundant code.
>>
>> Before:
>>
>> | if (... && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
>> |       flags = read_thread_flags();
>> |       if (unlikely(flags & _TIF_SYSCALL_EXIT_WORK) || flags & _TIF_SINGLESTEP)
>> |               arm64_syscall_exit_to_user_mode_work(regs);
>> |       return;
>> | }
>> | trace_exit:
>> |       arm64_syscall_exit_to_user_mode_work(regs);
>>
>> After simplify:
>>
>> | if (... && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
>> |       arm64_syscall_exit_to_user_mode_work(regs);
>> |       return;
>> | }
>> | trace_exit:
>> |       arm64_syscall_exit_to_user_mode_work(regs);
>>
>> Furthermore, Since both the conditional fast-path and the fallback
>> slow-path now uniformly invoke arm64_syscall_exit_to_user_mode_work(),
>> this explicit conditional branch is entirely redundant regardless of
>> whether the evaluation is true or false. Removing it collapses
>> the duplicated logic into a single, unconditional path.
>>
>> No functional changes.
>>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Ada Couprie Diaz <ada.coupriediaz@arm.com>
>> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> 
> After looking at it for a while I conclude you are right, provided
> the reasoning about !CONFIG_DEBUG_RSEQ holds. So with
> that explained:
> Reviewed-by: Linus Walleij <linusw@kernel.org>
> 
> Yours,
> Linus Walleij


