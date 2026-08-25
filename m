Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F5BEC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C23A6B00A3; Tue, 25 Aug 2026 10:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64B0F6B00A4; Tue, 25 Aug 2026 10:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539EF6B00A6; Tue, 25 Aug 2026 10:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0166B00A3
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:21:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BA578040D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:21:41 +0000 (UTC)
X-FDA: 85140005202.23.CC29E32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6AFAE20004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:21:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVZKTFvI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787667699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8b/TJsXHB/XozJI5wXe/xzYJFnEOoZHE7j2Gbt/52uk=;
	b=L9DMC2kWuryDXB5R9cevS/KmCL/a15HJusJpe3wJWglSDXQa4eZJnmy5V6XWwCAtLUBKEA
	28YUiKd7TDq31azUJ4ctrzPGqTSuS3lyFeB+ekPSbDASjKwsxsR7r+uVssMpX3rkA28wkd
	xSLRMDXcfzETpaiLA/k7n6HLEwFzRTY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DVZKTFvI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787667699;
	b=kV81V9cFxyRSo2RoF4Wxw1lEcH+6sO/OB97/c+22C2M73mgST/qAbsYDgEO2HElRu3iBFZ
	X1S6pHrciCL2FoutZ8m3YPdfO8zOiINuLptTvJOXqWZ4AQWVgeV7HWv/faajao+mLnV5j8
	yDQ6LGl9lfRnaX3FICXeUMTIorWa3OY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DC7A43A30;
	Tue, 25 Aug 2026 14:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BE01F000E9;
	Tue, 25 Aug 2026 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787667698;
	bh=8b/TJsXHB/XozJI5wXe/xzYJFnEOoZHE7j2Gbt/52uk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DVZKTFvITbFdxEW/KNwbUMuga8mUJt48vBMCM2ld8TU2FCHZcsOG0Dq7gmfHjM0Bx
	 xQ2f9VsJtomANbCQJLYAF/rbw1h39e0ALymilmEd8ywPGKN3Mzh1t6tJ2ostDQ05gG
	 stMZSlByJqP/VncOkl8qLoMpNtrjdAIfXVHtruT1D+hLVbS01WIm55x/dSZZpLdGdz
	 Jz3oo0eQg37ZWFiROX5gi7WJgBewZera2BcghNt5Ji8OihjrGcmOkF5zS3w2hMdYy2
	 9P8CeJ7IU39ogelRkwpqzSFi/bpncBN/QFGtsJs3wDBkWdX6MCj99UCd9G6T11EGAo
	 jLBVXqx2N4LhA==
Message-ID: <bb515cb2-6695-4fa0-aa80-b04d4bc4304f@kernel.org>
Date: Tue, 25 Aug 2026 16:21:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: fix incorrect skip output in
 pkey_sighandler_tests
To: Zenghui Yu <zenghui.yu@linux.dev>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org
References: <20260825123023.64418-1-zenghui.yu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825123023.64418-1-zenghui.yu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6AFAE20004
X-Stat-Signature: 4n71gz7wkgimm6chg9e3p55bhotom1bn
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787667699-44742
X-HE-Meta: U2FsdGVkX1/wUSy0xrpfbUHw/aeFn9PR4oJfhvu5WCvYg9FIrI/Tx4q7BeUc4cxrxHVJoof7jtLr4tapFBRBHMS1NPH3soW3XZtUJg2bnve7sfitL6Qt7aXI+DvEKyjr+VFwLKB0P3fAKRXFOK3aX/kbfMba5enIFYallKWeTgE1/5NkTu6nJtiI4ZzAPO6zkttmovgeuCoIJT7ovckcC/kJGqs0nj7gCOGvT1m7mz1U7fCLiKdIiz+qEAeWU7sErd74MlKOudN6VugSLTB+jRU4+g8x598jeoWDWy53i67igbmRZ+EdnaVstEHY2iniT06bvj7zIcQElwkiFDw8KyaCHumnwtbgF9BlKlHEOD2a1yqOA2TNAV7r8n7VpRJtlH+B1O3hPV+OZs+NObk6cxX6XyMUg5xtI4FUeyEI4xLBY0E0XuzTi/IarxB30B3qXFOgnxtCLnSLwQN0INILyti1MQyuEn5lrsz1lM67aCwudJd+px22CRTYYf9kPQwHh1GbFOFNxPGQLVyho0zim6vQpXiqpNbQsC4TjFX+HBVeH2WGLCu7s+2VBxvuYgztn/f+1kzaRM2057snTkl8TDtZZjB54ZImTb1zWuHiik+9Bred51MT960NKwuESMA8WBP3I3zyzuA7ohKYTHIm7e78iyR4wzBo9knep+jCCbMlriC0Oi3KPK/A1YvsCwilodVvEfrpouM3PX2Xfgth0ulK/N+dDd+PEQD+fNCgj7AbpvLUZf35RIZnK0/Im2cRbMAs/vH1FDzCiU6Zbh9K0fUGVHx0fk5mggZrBoS/RnMHbLcmnM8YuGN8kvy6SEMqSB08w3JUTOSH9+5fUpUEKoQI9xSKNDXSksar5QTeFvMGiNGvkLJEWhS30mwzP9wxtX2ipP8Hh8FYXsAU4MoZpMY2qM6U6gF0PbMBegaqHl31bzXUiGlTADFsCNtrtGfbBFjJMbiPhL4Ds9mbmio
 CWHmg1bL
 DpOzljrO2gAwKIpk+dUTYG1Km6wU8P9vdvaM3R4mi0nZyjJLwiLwQ+uzt6yPXiBtvY1Tbp5VaRk9pLOwYwgYMkC75RN5Hjc6ibRtQc6d2JXAFx1d7OEGo1Q4n/0EJQrsxwQPN29W1NB79DxXKUsNVp9TbeAn6OgCUOTdfnn8+hF5tEpWbCcm40iTnIg8XMKveYQCrB0Yb4nIE0MmuU0+NgY83valjJK5qrkJ+WMon6te92GSamIk3zrToqmdu2+GHni32ehBoyQmavTlF0NLEmXR2Er6avU2fp+SMZFhrD801y/fHSNOJDKOuMEcNozON5k0RO6kuI10hXXjeF1wXflavi0DXHQ0aMpSXp7kP9VMnBTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 14:30, Zenghui Yu wrote:
> From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> 
> When pkeys is not supported, ksft_exit_skip() runs with ksft_plan already
> set, which takes the "ok N # SKIP" branch intended for skipping a single
> test case.  The result is a TAP plan of 5 but only one result line.
> 
>  $ ./pkey_sighandler_tests
>  TAP version 13
>  1..5
>  ok 1 # SKIP pkeys not supported
>  # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
>  # Planned tests != run tests (5 != 1)
>  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
> 
> Move ksft_set_plan() after the skip check so ksft_exit_skip() takes
> the "1..0 # SKIP" branch, the correct TAP representation for
> skipping an entire test file.
> 
>  $ ./pkey_sighandler_tests
>  TAP version 13
>  1..0 # SKIP pkeys not supported
> 
> Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> ---
>  tools/testing/selftests/mm/pkey_sighandler_tests.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> index c218d0510a2a..74bf79a5399d 100644
> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
> @@ -543,11 +543,12 @@ static void (*pkey_tests[])(void) = {
>  int main(int argc, char *argv[])
>  {
>  	ksft_print_header();
> -	ksft_set_plan(ARRAY_SIZE(pkey_tests));
>  
>  	if (!is_pkeys_supported())
>  		ksft_exit_skip("pkeys not supported\n");
>  
> +	ksft_set_plan(ARRAY_SIZE(pkey_tests));
> +
>  	for (test_nr = 0; test_nr < ARRAY_SIZE(pkey_tests); test_nr++) {
>  		tracing_on();
>  		(*pkey_tests[test_nr])();

We also handle it like that in soft-dirty.c, so why not

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

