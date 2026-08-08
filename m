Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1B9FC5AD05
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 00:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7311F6B00A4; Fri,  7 Aug 2026 20:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1E36B00A7; Fri,  7 Aug 2026 20:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0FF6B00A9; Fri,  7 Aug 2026 20:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21DFE6B00A4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:15:29 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B4091201FB
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:15:28 +0000 (UTC)
X-FDA: 85076183136.18.2D0E02A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D490E40008
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 00:15:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dOoFAEzh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786148126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYOtN5es1U3sL5PR1h8VK1Qw6VZNk1IXyhW2dQx1Zs8=;
	b=JrrUBkhB5F921NM7gM7wnMgzF5MBpnc/bnVsr2jdlrWmDvksC+phCHrqn/3nXsqFuOfGZU
	21odDi3qi92b4isQ3Lt8s0UUVWQEYqb5jM7zhnA2rhSk7kOYGfUQ2oO0cSAQPoAEbHyF6y
	OwVcmQzCjPGzo3dY83L6J+sA5D5yAik=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786148126;
	b=Po/ZqGRrxfzfwSc+wHzsnzAMDQHHl+oHWkXiDNhd8oxT7UorwtICS9w8y/+mFcjxICKH3V
	3j7lSQ0Gc2RhQyYfsctMkmeXzcKF2jTXUFVgwKYe21YxXEUYbP0BCG2FwAAlgT5bA88buH
	rUpUhAnP3MfgovlTzTuvW1HJH2YPsDk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dOoFAEzh;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D5340408D7;
	Sat,  8 Aug 2026 00:15:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C7A1F000E9;
	Sat,  8 Aug 2026 00:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786148125;
	bh=HYOtN5es1U3sL5PR1h8VK1Qw6VZNk1IXyhW2dQx1Zs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dOoFAEzh8QmWlhl/Qey0OxS02wr9iK4w12SUs9xV+kECYHt0HTDukkQBZTGp81fMK
	 aeOyjdWhiUx5K6GDLRAc/cB+qpwOny3BP21x+MbrKMCV+ZwpOxn31KQE68S0+D9Qk8
	 vTJ0ADvU1qkuuuyQSJXOYovSYfUBNX59EEeBqlKdqC8s+zSC2omC63cyGydoeIFwRQ
	 doN/uqitbni8Bc02I/L3L4cxwM3RBjWjj2VLUFD/zmgip+A4s56BjTQzaIfYJB/7qu
	 VytlEzgmjSEofYTW+NgJVSqqPJ+wCIkhIgAF3gzw61zlwWEPjK62Ai9wAAu8zNP/ry
	 osOEKEqqV/M2w==
From: SJ Park <sj@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2] selftests/mm: Drop duplicate test_seal_mprotect_two_vma_with_gap() call
Date: Fri,  7 Aug 2026 17:15:20 -0700
Message-ID: <20260808001521.1467-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260807071533.48130-1-hongfu.li@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D490E40008
X-Rspam-User: 
X-Stat-Signature: p17tpba7667wqi7xqt7qfj7gzhhp3e41
X-HE-Tag: 1786148126-673515
X-HE-Meta: U2FsdGVkX19UeyQhExRUglS518EYW6SB75TYU60YBh00wiJhZqOjTTjG/cAKLjov7e0ZSRMRcj7re2nGMD7J0P/t7PrTHy6TODqONCKGaSH//qENqd2CZw4z8TlU46bkk+GopQSrxLcXEYF3AH3ioCZFfG6swxoDyha10314RV18e9HdJRFPCfYmvDsE4ItSBf3OaVv0HAUSTXFdspRsWxwDikyK2zE92gb2nnBWaJCI/ZkI6LjS55H3V8+a2EunlAW4iDBwrna/E4EEHPndZInCFY2AZEdYfTnCDLhcUC1H1uel/P3XJAWqIh7ErkE7oqJnC3LRUYk2OjT1I4mxKdlJf68yfufDsr60cIjk5nXg0Yiy0nYSlv7qykxJ0Bk1IImSwVR3h6Dz0N2ICf5Af2yfs/TleywgP+5Y8MPqdSeZ5qtaXsKySGsjRfizB1Ew9xr4RQPWtOKPw9A8+Co506EeOIxf5ShbsZr8jT6HHnF6C4FENjJOLpgnq1ZFn8RhOZxV9J86dfyMiUcQtg7lNkCG4iFKYISYtN6IxXcuryyC0lqpu4AicQn1NKzQtD7PSQokEyp04sjtjO+InJGOr9yXJRtm5Ie5B81LLqREAEteikd4VRTYoeTsZDcG1gmnD7tkbWWz4MBgmrL+rJvquZCQgOR+/F5v09YaAzjFPTZPgGdoRmCk2aa6xD1IEIrbSZtx6JstpREaA6ML7xuDhnymsovm7eOQ5v/BmJ4lDje/+58lILdkuNbzH8vEdCX41V6E3AGxH1UQC5u5XkvLqHWL+m5067PVLizItGVPQenXxWJlGeOh1aI81dae782PV1MYnx7tPsnfUwOtuphcl4rUTBBwLXGUeBc0AtRJA/AiztmbY6HvLR11DIjKAFVJA7ZsiZsXmL5ENCftXSddqdS8TTNuc2bwDvnE8csPJfAFU9nAknQVDbxWdNNhooaU2mJ0mCMWNcDuNcw6QWW
 nlEv2GOP
 heADlC90ij9aAsecSLRvLAebEIemKWFQXhaO5ZdcYyWip+UxMpjQkSTZjiLXL2MBes90s85vhHVNPqARuKPoB9YdUtrj/B+OkkJl9lJiNyHXAQUlyyxb2S/KaMBjqbtTN0FRU6+BuYGKbDUXz3C0p/ApRXa8Zsc6gTIbjLdsZ1ybG9sF+qGppeERf/j4UXdLF2FoU2IwttAVdWppwwlcCQlfNr7DPSSM26bJ9wvGXvq8aPcZHstNHdnsulDbupJvr9cTn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Aug 2026 15:15:33 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> > > ---
> > > v2:
> > > - update ksft_set_plan(88) to 87 to match the actual number of tests
> > >   after removing the duplicate call.
> > 
> > I wonder if there could be an automated way for this.  Obviously not a question
> > to the author but just my loud thought.
> 
> Glad you brought this up, I totally agree with your thought.
> 
> Something like the below refactor could achieve that automation:
> 
> +typedef void (*test_fn)(void);
> +typedef void (*test_fn_seal)(bool seal);
> +
> +static const struct {
> +    test_fn_seal fn;
> +    bool seal;
> +} tests_seal[] = {
> +    { test_seal_mprotect, false },
> +    { test_seal_mprotect, true },
> ...
> +};
> +
> +static const test_fn tests[] = {
> +    test_seal_addseal,
> +    test_seal_unmapped_start,
> ...
> +};
> +
> +
>  int main(void)
>  {
> ...
> -       ksft_set_plan(87);
> +       ksft_set_plan(ARRAY_SIZE(tests) + ARRAY_SIZE(tests_seal));
> +       for (size_t i = 0; i < ARRAY_SIZE(tests); i++)
> +               tests[i]();
> +       for (size_t i = 0; i < ARRAY_SIZE(tests_seal); i++)
> +        tests_seal[i].fn(tests_seal[i].seal);

Thank you for sharing your great idea.

> 
> Though I'm still unsure whether this extra complexity is really worthwhile.

Agreed.  I believe it is good to have this as is for now.

If we have to add such automation, I think kselftest framework is a better
place to change, than each test.


Thanks,
SJ

