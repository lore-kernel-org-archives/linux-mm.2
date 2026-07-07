Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C77AC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250E46B00A1; Tue,  7 Jul 2026 02:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201E46B00A2; Tue,  7 Jul 2026 02:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118D76B00A3; Tue,  7 Jul 2026 02:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E244D6B00A1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:25:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 73DAA8D260
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:25:22 +0000 (UTC)
X-FDA: 84960993684.27.BDE7E16
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1F9ED40003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:25:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HmhIES5t;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783405520;
	b=ZqKwDHezkvWO+CE4UkAgrNrLosjSvKfgEZ8/V5LY0mnIEAKAkaqViXn0JHV2QraPtExroO
	s9Z935gyEj3WBr2z4yaMD1Ef3a3HYFP0iFsV/BuzFcJEzR8HDjkcAHga4/Byoq3cQcQKq5
	V5/P9WoP9tcuvit7P24wTwuf8H17tRw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HmhIES5t;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783405520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghULqfOG2OiM+NWRpdwQoOqUFkQmBDMnnbFJj6vRT50=;
	b=Tr+QUiEt6J1rpTZuiknCs5asjXC3NQlJvm+C9ABeZNqQtP8U6tguvv0wf4zZ5Yuc2UcxQa
	X+mILJ6WqcHk8vG3Q2Bt6EvSsK1RuIyZRbgNZbBq9uBTpw5+x65Zrfk7yX5YlYPAmQ6o5P
	Pp8r2FklXQhTGxzC48dG8iUw6zwn52c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783405513; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=ghULqfOG2OiM+NWRpdwQoOqUFkQmBDMnnbFJj6vRT50=;
 b=HmhIES5t8SgNfdNdmy6iddgU7/27ddha/kj6/k18ah4DbAOTIkGokekLLfF6beOLxVSexR
 j2GcutlV8HfvKJvZ+K7N/DPoQ2wf2KX76f/hRPooWdDkWl1zXHOtd5ZfDa3FH8jcwzE+FQ
 3dtvY1QUpFV+SrCHQPa2259tv8Jf8j4Mm2EU/IBgt44XRZ9edtRBzSMeykPmaK1TfqhSEZ
 2XcQrDvanrYdBnJalp+K7Yl/s+DshsE8NqEPi6Vbm3EG5/XsDjEmxsHP5uJwTBp8mGtEzr
 LwLPDG7AJjfRN+mUwij0vCJntmphpYQX7c4eNLexNflsH5pxE6C/LdLLLkl1UQ==
References: <20260704203616.1ce10365e07c746f1e805cab@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>, 
	<linux-mm@kvack.org>, <muchun.song@linux.dev>, <shuah@kernel.org>, 
	<wangyijia.yeah@bytedance.com>
Message-Id: <20260707062505.3171552-1-wangyijia.yeah@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a4c9bc7+c7053c+kvack.org+wangyijia.yeah@bytedance.com>
X-Original-From: wangyijia.yeah@bytedance.com
X-Mailer: git-send-email 2.43.0
From: =?utf-8?q?=E7=8E=8B=E7=BF=8A=E5=98=89?= <wangyijia.yeah@bytedance.com>
Mime-Version: 1.0
To: <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND v3] selftests: mincore: fix the readahead check on large base page sizes
Date: Tue,  7 Jul 2026 14:25:05 +0800
In-Reply-To: <20260704203616.1ce10365e07c746f1e805cab@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Queue-Id: 1F9ED40003
X-Rspam-User: 
X-Stat-Signature: 5y9qtmz1jg99jxorh5gsoc5x4rif3114
X-Rspamd-Server: rspam03
X-HE-Tag: 1783405518-466937
X-HE-Meta: U2FsdGVkX1+DIIveKOloN9Ww6G6uozjExvKF0CRFiB9fKnGSuovEYLCPhZGXy864b9iUMHaLwkjjfJA8a5hyBCXqGZ9L9B3hfYKbvFGz2UP7AwalCLtAuVqVxa6ep/GYBqJ7bVg4l0rAj1mEOMlkTUA/b137ofUW72butOXgn8WyFQdSmWAIp5r+15aYqw597E2frgYFT24i32R2rx6IS/JBG/q7qJWg08bJTrXp04/DqGF8y9lc8i13OjoUh0vg3Ek7zpXXNUwud5tP9wHWGdaNT3BLSi1IL2Yelx2ZW6V8UN+Va2jgAFU80bnHYqgf63/7QARI+MD+HS6PXIHxGNsasYnOKB7/VAvsWgMUF8/GD44C7qTkeKSS+29tq8KcSVqSWhcTsBlRlZJym1PJTv+27e1nNoGtgpPtnFzokVgw4um7ma3Zp/w/+5wSdc5w6OD9RWHRNBBqRonRoTRel2t6XBXagtoP8hGyNu60FBTu83X8KcB+NqTajXAsWM1QT6IjfdTqDzfgiN0jfQk7gPzFlHHD08mNwzF21PY0kYfbRSMke62ZSZsvy3td/Ls6EZwiI8XxUxu8dCbRXYoO2LxmRYvKhP6PaLuhSitX2z/Gwo2Pawoe7q/r6S9tQsFBZR2ruRKVEyeH6AhU04mNtb0O01PuG9B7o/7iFuJMOLq9pNYayzCaKexi5iY83hYzK3uO6EUXn8IxJ+raKH0v2ORYzucAw7U0mbYBr0ongb1SnmKdCc5WoiSKDu1Spbvr89iBTc40Ilvm2EhE/ns0cMRd4JRbGaLD4V6OkFOvPpjMrJnHgOOXVXiSILFa2x7pmCqWbLgZq17QEx3qrtKhdert1zJlo5Kf4XXc3+jiWfRvZSEAuByhwYlb3PH3RQrif/U9h4skZ/Yy+hK9Cxf53OQPRnobmcuTQDmcPvLZ4m2gH3FMe9kGsvvYeqtxrHVCeoTcyfmP2mUeNlJaHAL
 nv8DvJMv
 GFVVIDhu45MSrOsSRXfJH6t3vlGGq2qJKQoNzJb4I+oxiiNgin9J/cV39O85hilkK0P7d46CgpxfyJqDtzFOXRNRifKI5SYcPkqw6keyQQFvO/OwjbqhzT/LePpSDdBvXmE8smjO6kpQrtuWHxLjvq+/ZH5xbeIVNbqxTwDVca0DcrETfOI3JwEGQOxuMSq4IFhaQQnP8Bb3Qagk3nQB2t0D55yRb+T3ipKN9tKYOx52JLVOWTtXNosV+eHRw9ajAAaYbqMP+qPsbC/7vZo+EheRadOduodQW2+oc2KT230RyPRwCABys8tYKVZD0CrK8LANyCnyN/DotvFBfaFg1cutOBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 04, 2026 at 08:36:16PM -0700, Andrew Morton wrote:
> I'm not sure this is a good thing for us to be self-testing for.  It's
> poking pretty deeply inside the internal implementations of
> kernel-of-the-moment.
>
> Oh well, I guss if the test suddenly starts reporting errors, it might
> be something we want to look into.
>
> Thanks.  AI review might have found a couple of things of interest:
>       https://sashiko.dev/#/patchset/20260703125253.3016281-1-wangyijia.yeah@bytedance.com

Thanks for taking a look.

After thinking more about your concern, I agree that teaching this
selftest how to compute the expected readahead window from sysfs
read_ahead_kb is probably not the right direction. The failure is related
to mmap read-around behaviour, but adding that policy knowledge to the
test makes it depend even more on implementation details.

The actual failure I was trying to fix is narrower. The existing test
already expects a neighbouring page to become resident after faulting the
middle of the mapping, but it only scans after the faulted page. On the
64K-page arm64 system where I reproduced this, with the default 128K
read_ahead_kb setting, the file-backed mmap fault on page 32 makes pages
31 and 32 resident. The original test scans from page 33 onwards, misses
the resident neighbour at page 31, and reports ra_pages == 0.

I tested a smaller version which drops the readahead_window_pages()
helper and the new skip logic, and only changes the existing check to
scan both sides of the faulted page. On the same 64K-page system, the
original test fails reliably, while that smaller change passes. So the
sysfs/read_ahead_kb logic does not appear to be needed to fix the 64K
failure.

I am thinking of sending a v4 in that direction: keep the existing
EXPECT_GT(ra_pages, 0) check, but make it count resident neighbouring
pages on both sides of the faulted page, without trying to compute the
expected readahead window in the test.

The other possible direction is to remove the readahead assertion from
check_file_mmap entirely, similar to the tmpfs case, and only verify that
the faulted page itself becomes resident. That would avoid testing this
implementation detail, but it would also drop the existing coverage.

Would you prefer one of these approaches?

Thanks,
Yijia

