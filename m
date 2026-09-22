Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13442C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 07:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4BCC6B00A1; Tue, 22 Sep 2026 03:09:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFCDF6B00A2; Tue, 22 Sep 2026 03:09:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A136A6B00A4; Tue, 22 Sep 2026 03:09:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FEF26B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:09:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0504840378
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:09:31 +0000 (UTC)
X-FDA: 85240522584.08.B229EB3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1C65E1A0006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:09:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FtxLmGoW;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790060970;
	b=4hRwIZ3duSN3vOmfuPmyW0dLtX6+n8SHCzuvHXB7+SXhRgGTAffgPDOPOELldKfIsQ+R8h
	pUs8HQufmzP/t0KLRxQe2afPZANVsNk+5TanClhGrroAkKhqh48FlZZd3lkcxapjxjm2XC
	JkmeaG5n2lRzvlkdNBNv0QXPHu9//fQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FtxLmGoW;
	spf=pass (imf19.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790060970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tC1XgIpJmQiBnXNVMCeuGF4c0nUXlDuZW2T+EXLiaa4=;
	b=cta5ml0fPJCPbfGSE8R1yNJ4lXaDapSeUBcTGdWTwf7qFWfBCWmyBom8a7aiPkH6c68lk0
	UKTUzhwkMS6UEepV8b5sPqSdfULtJpZJ+HJ2BDzaCet89fCGatc5LAtN0EQelx8d6T2pH2
	Mrzl27zPHSgrQ6AdTnOcH6lDQ/eb2Vs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4FE1D1476;
	Tue, 22 Sep 2026 00:09:25 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E57CE3F528;
	Tue, 22 Sep 2026 00:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790060968; bh=X2elJjOWX+I6p0hkyb//O2VmgJU8aZwYp3GER8YVCRQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FtxLmGoWO8aL//MyFM2NR6VNOmEyr2TmdtJY8DnZSFG0+8YvHYjUp35bg/UOxlhK9
	 JFpg4usURYN6gUMNLnUjxV32IdrKQLjslmdts2//QkfNANa4WIlue6KyW4G14mkAC3
	 vMlXXzh4ouDVIMQNNNipuDWCpX4HibahJYp8rWpY=
Message-ID: <2e0a8157-a529-4355-bd7e-11ef0234b825@arm.com>
Date: Tue, 22 Sep 2026 12:39:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: mremap_test: handle ENOSYS for userfaultfd
 and add missing newlines
To: Park Tae-sun <ts930@dgu.ac.kr>, Andrew Morton
 <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260922065143.118702-1-ts930@dgu.ac.kr>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260922065143.118702-1-ts930@dgu.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C65E1A0006
X-Stat-Signature: iwmmxqborc1f9gwzsdz7ryzcaihpitit
X-HE-Tag: 1790060969-6213
X-HE-Meta: U2FsdGVkX18T8zB0Yq43l3aXr3GkhwDWjTJ7TWigMv+H1tXAUzrSByRgRHqbbRm9fHN2fztMSo+DaWjHvWS6iF/jA9VGn+WIKg3vp8b0fzwy4UQM3Z1zzPcPSg9vtHPXi3rKEOCES4DAZk/ZdLqu7gotqL5OfZISPXYgwdf03GeDng82oKxC3rY03PmKQR1c/DwDYwng1/EkmxWrZMpgOjos0v6I6qEABSQtTdQjn/Bm0U16KmaKXtJ2YqCgcJSZdReY/SHLIhf9Chixd8MQEyxDdPujC4MFDpqKVvlsSviRWMIjej66HEUqdvzk+WBld2PqN0v8eaiufRYtUXgBXO2wYgSbD0GLpguxWM5g0PRQMv9ZVzHXwEvOzC74KlD9voywjRFORFKH46LG8UVCJtg1H1XIYWnFfGasl38TySqO2vpvIPlaxz9a4n1+GURZ9kSt4Xz2ejLtLVY54TuX3a2fx4AwW71/7xHLJdbT5lI/KkqWofFtrH9KIdIECn8fYVcZxHewfL0OYGkS3XTjBeUxwwUuu5OJN3fdjOBawwn/6m539eT4ryefLgP4BFCcy2AlQITxUFsL3bJzcCPh0p4VAp9lKvdu8I++hwxiNlN2gG4dvH5nHfUM85xJHrtPzLqE1rHkjy7O4KkykygZJ1NQJ3pwOGUUUKkNL6yQj4/Rf0HJm8+xyLUBh1+7FiCLbD9aw4MKITrxceRrMWUNZaEZ8xTTXRCYrwIYt9UxEkIV70bgiKFFqVrpVQLDpn53VAq+vfhy+kNKTuDYaa0NfYviQ7bgf/EuYQnCEhcXK/WwKKC/ichNXtPkZ/Qy1xHPierkwoAzG1VIXzLj/e31F8k2s6imPZj+t3gKbYG9t7aO4DDlVKF22KFv7U0SjHP0oRDWfQrBFRf9X2k5CjCmdk8Ve8mc5yzt+NJZwJ+QkM+MrnEbEdk53mpTkk/OKF3QUmWJdc/NlbNbu5YtWyG
 a3eDhUNA
 KgYE91VJBf/0taf/itWasJ1HWIAShhNHdwLEAyCq8e7ITfdDQ8pienGbrKJJu+Dfgy9z0bBSymvWTnbZyzjDT5Sj6tv7O4bHa8X1A+vOZ1rHictq7twPPkHL+05gWbQO6NF62I/hsBY5GKzs7pEMzBuy7r2z2y9uRZGL/P6YwRImamQZbsGFw5Gn+e7+iuPM1Qd2312FM/tmwQ2leIhGX/KJMGWTtp6Gnm1nK7kczzgHyaslnfTmBWvSP8cP+E348OSFV+/td4lqQPgjd31hkln5J6sT5lSVQe4EUyLq2h4mfUt9pTIaE4nMNFbw3YMDFJSGneT027AUyyo+2KrjAfWPF1QI0wtS7vhBbP0sPsaXKfqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Park Tae-sun!

On 9/22/26 12:21 PM, Park Tae-sun wrote:
> When running mremap_test on a kernel built without CONFIG_USERFAULTFD,
> test 26 fails:
> 
>     userfaultfd: Function not implemented
>     not ok 26 mremap move multiple invalid vmas
> 
> This happens because mremap_move_multi_invalid_vmas() only checks for
> EPERM, so ENOSYS is treated as an unexpected failure instead of being
> skipped.
> 
> In addition, ksft_test_result_skip() in both
> mremap_move_multi_invalid_vmas() and its fallback stub is missing a
> trailing newline, which causes the subsequent TAP summary count to get
> stuck on the same line:
> 
>     ok 26 # SKIP ... - missing uffd# 1 skipped test(s) detected...
> 
> Fix this following the switch pattern in guard-regions.c (lines 1498-1506):
> check for EPERM (advising running as root) and ENOSYS (missing uffd), move
> perror() to default so expected skips don't print noise to stderr, and add
> the missing '\n' to both skip strings.

Thanks for the fix, but I have posted a series of patches already [1]
which include skipping incase of ENOSYS and fixing the newline issue in
ksft_test_result_skip(). If it is okay with you, can we go ahead with my
patches since it solves some other issues as well?

[1]
https://lore.kernel.org/all/20260917111951.188266-1-sarthak.sharma@arm.com/

