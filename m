Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6AF7D2505E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:37:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6566B0088; Mon, 12 Jan 2026 04:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 276E66B0089; Mon, 12 Jan 2026 04:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AD356B008A; Mon, 12 Jan 2026 04:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACB76B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:37:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9E985160761
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:37:33 +0000 (UTC)
X-FDA: 84322809186.23.DADC936
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id E39B6120006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:37:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768210652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LLHaptyO8Et6BX64ae2o2/w3br5H+WwMc8+MrROXYEY=;
	b=B0jAFJ8P3XVVw4XmjbzGRn+NTJ6LCJz4dxgkguNyDV4vUrkm1dnNvl8yqKHR8lNjDv1qW/
	7YeKBS++0lPD9qWqiyhPV5wDyhch0x8bThKvLlEiRIgpX6gRUrUW7nOkAb00BZFpQXhpYT
	NbA7kPsGOkrjyHxoGa2zMDp4yDz75+0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768210652; a=rsa-sha256;
	cv=none;
	b=UeCLRGyT7W8ENg1QV8Zv3fNKziUb2OLO7QQ7uvYq5J+Z3rHKi7J3eudabWHbQhD2yxbTxt
	Op9nxqH0veeU8ZL/Wg+5QiKXc2n+h/kUk2j5xWeefNr2wkED7Ag+HPh3KBF81JC/rxxAFT
	dZC+xIHqUbrx77xty7COT0/IVzIh6Gk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2002E339;
	Mon, 12 Jan 2026 01:37:24 -0800 (PST)
Received: from [10.57.48.185] (unknown [10.57.48.185])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 663AA3F694;
	Mon, 12 Jan 2026 01:37:28 -0800 (PST)
Message-ID: <b785754d-ba6f-42db-9e44-66fd377aad03@arm.com>
Date: Mon, 12 Jan 2026 10:37:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] selftests/mm: introduce helper to read every page
 in range
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260109013009.68474-1-sj@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <20260109013009.68474-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E39B6120006
X-Rspam-User: 
X-Stat-Signature: wnxoi6phiqpx9gup7ankdwefzrnqpk7r
X-HE-Tag: 1768210651-694689
X-HE-Meta: U2FsdGVkX1+NFvkyRZYScZaqvtG1D9BJ4kPhEyWCtbWCQnnmnMUsia1aY7lLB7+8y+X5G4/EXKJ9lPs7ymaeAi2YNvSCB+s+XTn3zpB2f6F1DBgvq23hzB84sSN55+TP6Fryx84h0JCnSW2tusd6cgiHLrb5ZlfY4MMhu40xSXjMCTDNlvWO8l7UnalM5TD0OXbyEAzVfDFs3M2+9rIAQXswr2RsDciiQ2ndQdzw8uCCyRoxCwsRvThBRrSPslfuGS/u68yA6Ixr/JSmO461vTFuXv1HW55s1hC4e0hNUi2qpkvedT0/FmqMX4UgUEmDkDIlscszy7MPcZybmQW+qaggcBy+RAVUC2czaGK/o4KgZj96LUTv8OBDVTJcjDJiHJ2hmwbPQylVR7a7Gpb+TeItKNujdkTWPtPigD8AudQ/ya2sTuaDdWgFwO3I6G/OUtpk9X1c6RfpyifaL/dZz/WVuOcVFg4e2lktzj+F/XoN1Sy7CblbzWlMRCbK1yiZ2fJh4aUqyRYFvW42/KsH4OMjuN2a1NrEgxJsLnYE9babNORxjT9QLHTfuLPZTXiuOAsaCvRE/RlydRjlz+PyMBGCcjFeTVOO0aPwRX6ajMzdGT5cAYA9U081K/ZkJVfETHLIJgcjnX0FBdOjGx4eujIBekKxguqRNEcqwaLylec+kj6ldQUF17it1qljbeOQlP9NjwGyiUJF+rkNmoUyMdKR3PH9eNUISKq5Ne5hlNzZeFi34Fq39EKsmOx6hzUBdidr+ENpbyCZKEpXNxb0ciG9NbhvmbE5hVjg83qfiVPEakhD9WuOIlWULjuQb/r+6SKwpv56Wwj6aaqR2jdY9pXj9DdUlHDvErkR0vP2+zVAo2rBADNDvAdhwrJKulIVzwW6ymV7V/d1v0sGmfXJnjkWepF7fxpQq/ju9stt0h3QKmzSuSQXcfAuW/znD2J2DwJrhH2hnYyb8e/5Xxe
 P65qd/CE
 3DTRVEDFoeAjcYx1fPH2BSgoFWtzmEFq5yFsKlIiNbtalLpmQP1nrdRnCuTN9ArIBgjUgKsmlz2wuGtf4Er5V7/rUMMhD8v2b3yHQQgsU+lw6qmT1YMSzJnUxDu/gTOr9GyiA9YvAFG54npbgDAY0O5jBSdcNESg+FdCzMiVZTUMROYCYeEx3BkhDp10oRb9kWbdyY+6Ioz5hKKJWI+6Bj5oQI1HeDf+UJuRm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/01/2026 02:30, SeongJae Park wrote:
> On Wed,  7 Jan 2026 16:48:39 +0000 Kevin Brodsky <kevin.brodsky@arm.com> wrote:
>
>> FORCE_READ(*addr) ensures that the compiler will emit a load from
>> addr. Several tests need to trigger such a load for every page in
>> the range [addr, addr + len), ensuring that every page is faulted
>> in, if it wasn't already.
>>
>> Introduce a new helper force_read_pages_in_range() that does exactly
>> that and replace existing loops with a call to it.
> Seems like a good cleanup to me.

Thanks for having a look at this series!

>> Some of those
>> loops have a different step size, but reading from every page is
>> appropriate in all cases.
> So the test program's behavior is slightly be changed.  I believe that
> shouldn't be problem, but I'm not that familiar with the test code, so not very
> sure.  I'd like to listen voices from people more familiar with those.
>
> Meanwhile, I'm curious what do you think about making the helper function
> receives the step size together, and let the callers just pass their current
> step size.

That's what I initially considered, but considering this discussion on
v1 [1] this doesn't seem to be justified. In hugetlb-madvise, reading
every page instead of every hugepage is unnecessary but still correct
and the overhead should be negligible. In split_huge_page_test, I don't
think there's any justification for reading every byte - the intention
is to fault in pages, like all the other cases this patch touches.

- Kevin

[1]
https://lore.kernel.org/all/a3ca6293-8f85-4489-a48e-eb8d0d3792c5@kernel.org/


