Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33010CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 21:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2153F6B0096; Thu, 21 May 2026 17:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ECF56B0098; Thu, 21 May 2026 17:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AAD6B0099; Thu, 21 May 2026 17:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1F666B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:54:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D1D64080A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:54:53 +0000 (UTC)
X-FDA: 84792782466.07.80C1FAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C946240009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:54:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lqbCa13u;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779400491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nq2To0QuY4e7vdPARpZ8ihBrwwym+9Z/ywa3n/yj5WU=;
	b=u3JIq7anMAgzoxRfKPRCWusUFWUogBG1iSLF2NOULfZ0JuCI3fvh4zaIn/X+lzafh2/Y0D
	Tj6CmA6Zufbz1ndMb2wQ9muYISRpNXZpngXYuI1XsoaiZ4w+UzVZn8hiS85lXYBpFTBbV5
	J+8eHCb/N0/YOOpizqJJo16aSsITaNw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lqbCa13u;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779400491; a=rsa-sha256;
	cv=none;
	b=Z4i654FhYgOXps9vNQv0+3wgrV4nW8EAG6yuh9BpE30/tHOUTuZ5o5vhXKA3jVO8e+4HaN
	58bGS/3nYmyyfmNIIu0Q/YbMAg3JuUfvp3O0foAu5TEA38L0HvveszV0ThEVaMyEBj7s5P
	gZ/ISoP7XEyfNBIu+7SL/mBI8gLrLPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8F8144271;
	Thu, 21 May 2026 21:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189A61F000E9;
	Thu, 21 May 2026 21:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779400490;
	bh=Nq2To0QuY4e7vdPARpZ8ihBrwwym+9Z/ywa3n/yj5WU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=lqbCa13udxE5HS+7g3+IdEidtP790M7oIPY27BNI0jhTG4rd9X0On4XXir20YE9K2
	 2SwG4ZPh3ENt4oNC3COhZrRGEpo84MdcGCwaSzLYHO0tuVvULVd0kpDGSHhG3o7CKj
	 RNDilYoy/hqzHsaArsqrJy+2+E03yKpf6ea86IKg=
Date: Thu, 21 May 2026 14:54:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Ritesh
 Harjani <ritesh.list@gmail.com>, David Hildenbrand <david@kernel.org>, Zi
 Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>, Oscar Salvador
 <osalvador@suse.de>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain
 <dev.jain@arm.com>, Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Miaohe Lin <linmiaohe@huawei.com>, Venkat Rao Bagalkote
 <venkat88@linux.ibm.com>
Subject: Re: [PATCH v7 00/13] selftests/mm: fix failures and robustness
 improvements
Message-Id: <20260521145449.ff6b050527ca494a7ba66e9c@linux-foundation.org>
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uswbrz9zde3be67uj7oetwnemnkthj74
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C946240009
X-Rspam-User: 
X-HE-Tag: 1779400491-135005
X-HE-Meta: U2FsdGVkX1/p+9viRR8l5Hj8ScscXPEUiucmlPO/DuNubXvhRfmST+lEmijWZfnbzFskPv0h1Id6parq4czsRNz7C2/KvXY5iCi8PsGPlCJwDuNpfe0KXT6YZDmWXITczfLiVE6j18qAbcXRlyGWB+SdVIRlYnx5XK4+MKVH0cqkdYbjzhDoDOZQ5l0vtNENM0ReMuklB1APBfzWygMB14VK1YPRM2Pwp7bw7shBJi5OC8OTRcX0xiayQm60a+OTnJGXNT25HZ5jjCniAIUZtBQqjwAmHN5DvI1JtH6hftFwlnLIOgdcDR0Fi5lviK9kn2L1YHDTg0SAQLldilTvBiFfIrlQJ4mIW0UhjtDrUxWC+myVlNH3GVBuSNKOu7cKxhOkyWsq2GtJSTeOlyEa4st9Vfw19qCUrHbRJPcA8sOBU8Icb3HerpmVfw2OGahPxy5FHYU+plv3FZhx64LdkyydvsRUQpxY09enUQcphEmuAg4bBo+cnORwSwk88HsamS8h7xWEuqiZUESjGdjfllFmJpAIgz08t+GpBCA8KGovHNlZ0M/YHuzKqbJJ2J3/bkFkR7UUCL32yHtDYCGq2Qg60LmH5uKdIQv2JJ4sY1xa2tAoM91FV/uifo4XF2d4nKYtNgkIhax6cgiJmlsRLz3lq9dbo1pPxCw3Ho/G9M0FEhS9Qan/zQwRcHaQPsybBc8RrL41GhhpUY936/cPdQTEaU6YH09+TjV95vCv0fcbL4soL3rY2ZdhdiqweISM6Do4m/tlAout2in5aelDJKi6YvCraKcQtlMU1XnyjbhQC2/6/Ud7heTGzU+AR1KUcHhH5AnyJu/4J0HMIYxjmmyP3GYHWb6+4rZNVFebgh51xd7dCG+o4paDZH2Mu2l+MiwSMeTeSSqN5hD8ts7WkGfqFnlm7oo1FGCuqIyullBNz9HLd52HZvkaoHcIkJEWPUHAHTDmIIhsizPphs2
 kVNnMIZy
 gF1Aj4sAK8XlBncoG6QMZ5hJA7cWvYgFvXkUlk2tn6JJC6fo8/ncOzCrtesYW/8EvNVQYTH5cuJ+5xPZsoxtlG0EEqO3zPASIJJ/jzbRbEGei++NyuXmX7dIJXF9mkokcKApXNe4Vl/v2h3W9LTAojanbQoMHgVMsrMbzieT3Q0lFSybPSDutW1frglOPq8y51U1Bzu5AGE5RN9YQ+dvDPa8dO/4oikWJwyIWZ8H37gnqBP/wfqchQaQCJ5LOHp3Xo+Mvq1l0/38KpXpmhFBJN7CVecflPLNuziTYf1cmJKgovH2Rs2ZSRNKDlB6lSsp1T5SwDF/CAKBQsKdV4j/en4y6/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 12:03:26 +0530 Sayali Patil <sayalip@linux.ibm.com> wrote:

> Powerpc systems with a 64K base page size exposed several issues while
> running mm selftests. Some tests assume specific hugetlb configurations,
> use incorrect interfaces, or fail instead of skipping when the required
> kernel features are not available.
> 
> This series fixes these issues and improves test robustness.

Thanks, I've re-added this series to mm.git's mm-new branch.

> I checked the AI review comments. Most of them appear to be relatively 
> minor.
> 
> I have sent one fixup patch ("selftests/mm: use ksft_exit_skip() instead 
> of KSFT_SKIP in uffd-stress") for the comment in "selftests/mm: skip 
> uffd-stress test when nr_pages_per_cpu is zero". The remaining comments 
> were either already discussed earlier or can be addressed later if needed.

Cool, thanks for letting us know where we stand with the AI review. 
It helps!

