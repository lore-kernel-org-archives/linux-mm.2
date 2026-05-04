Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 008E4CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C2E6B0088; Mon,  4 May 2026 03:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCCD76B008A; Mon,  4 May 2026 03:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE32E6B008C; Mon,  4 May 2026 03:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2EF76B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:35:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61A1BC1868
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:35:57 +0000 (UTC)
X-FDA: 84728928354.27.968CBC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id B7E97A0002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:35:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwZxMQof;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777880155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqFpUme6PI0IGpRbtCiQg09CSdqJV/ogi+wzFrrhm7g=;
	b=xqA1UpmROaGHXUUdp6tg6tzFMpqWOJ5NY2MbVECiJ8l4UMOhK1N8os/b8oj5rZNYGUbAIz
	Mp+PT/IRlDyOgVZHhjgF/e6V83+stfq0aYwSudKj/LWY9ZjCdeArZ4YUsdmiR66RQk32KT
	MMcRpviXeeRTOasltdz07Umvf3EgnqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777880155; a=rsa-sha256;
	cv=none;
	b=jplQFyLTyEreF/xoume/WNJ+5au2ZrbaOhpU65NyPo0ga3y9hbhCCs9OcLNbqykvryZc+0
	EDlQ16HQ/z84lWTFkvfuAa9SE05ceOGoHd+NXRH11bRCZW+mOpplLnXCMZtRAYWOdQoQH+
	tMi1bX1KR7hsqsbkrMNS5zLTRUNvRR8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwZxMQof;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CB3E60008;
	Mon,  4 May 2026 07:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A297C2BCB8;
	Mon,  4 May 2026 07:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777880154;
	bh=nP0S2q1CAzOGhGSdSCjymgPf8nuBERecQ5nTjVW12qQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dwZxMQofx6uIXs7HGoHMgLNnUGRsmZWDDIiSADIemxTxLuZR8dhs4m4Bm9V0M2ioC
	 z9kh24iWzmu55tMpnz7mCGxGsauMwJA1S+Ng/0/wRxsyZGVh6PJKThcrdJGRAkj9SV
	 rL3AEJobAm+7b1ZdQRrXC+dhzIyqhYS+3dnPcmt5zlcfylov7Ke5LhFg40bbEK5qO/
	 zWF7IzrUBYNzg/seZaKvUhvg79C1U7uucNC8j+BrdpDntWlcohZNncxAeK49w4kV1u
	 P+nW4+1+ARQpeoKBJTlnt8b0tIZVM41k2c94GuXsqiT4GB4xrNQIoURJbez270BpXA
	 eU5lJh9mEJuMw==
Date: Mon, 4 May 2026 09:35:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: shuah@kernel.org, akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com
Subject: Re: [PATCH v3] selftests/mm: ksm-functional-tests: fix partial write
 handling
Message-ID: <afhMU8qbUbS-uVa7@kernel.org>
References: <20260503101229.654763-1-agarwal.vineet2006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260503101229.654763-1-agarwal.vineet2006@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B7E97A0002
X-Rspamd-Server: rspam04
X-Stat-Signature: 3drcsgutc5ugm7e8hb5n7fczmyatudgh
X-HE-Tag: 1777880155-136092
X-HE-Meta: U2FsdGVkX19nLL4EHyEwcle8oGYbnRv82StWIkEIYU89W20v57b9zoc74eOMNNqki8MLO/cmfgG7Vc9/6YeIOgKqp49wi5b05a5WVOsoVvrHi6g++0gfuKTjbnCnpg1vuNz22jr1UWyTyGCFPTIyyAS12hXt2Nh4VLJucAwr8UprAuAvF1oQQR5LTa4LTVd/uF0cBilyOwhkENuomHzrTxlyKRtMgpEEV43ghFBNI4zksBtzx+mdGbwSfAmJ0Ab0vXSQ0f1+coJVliSYMIvYGrwEDL+5goSzpAGG84c/R6rBpjWwSly5rb4iJpc2oxey5tvAS/IKSa6FOJAvhbxg1V4NOQm9pm++nopPgNYoU9CHAv/6o8M81CE7fU7bIp+MDOYkW1+WbngkbGCxlDg/yAQVuugTv60uPd3OB6qfTEhko1gPJClMf6VuoJQkw4yIuTZ+0OItFT3HtvWW4BlL92ITg58Tw9fDxWE6/HGtL6gbbW7y45ZFJcV0o49nYi8ec6Gb46wdjxDu0eNoj0gep9XWj5cJ3lXCrX+vznAR7n4h639Gn+haJl9HbqjL3C6PoVsuSoeOh1ye4sVRQFN1xLhqtwaBe4YoaWWeIEFMIypT+VmmBquYwU5LP+XZQgKl0t99Uy00wlDb4Kce4qlUHEG7XQmI8/hP5cId06phG+t+Em8Er2d8zMuaiFlu0y1n4GHrTVI/VU2UBQFnKerfnSTqWmKz43Kw7kksYoXpVQfxX+htZyIi4K7trMDjDERBP4Fd6yggHSe7JG/RQqtjtEMKFWlJn2uiO5jt1X27RLozbRmpNxCXVHYz/Gg4Ku2j1w+7xRTyprxNNIGxEYf0S88kXdOiBSP6eeSjlJWaOspbfzarZrg/YeX+GCoEA9nYru5ziYSYYurNXYWSnOZkqk81thaKKgJMlY+4RC1JCdaROYZW/IrXOwaRDAKYUVqY6UJD1ILxhj0e52/lJ8h
 OBp7y9JI
 X1BmX4kzlG/TnZ3UOWV19bUBY0ENpOoMs+JBu05WqYchoxQi267J+YZzHdeKsI3qlria0FhF4XnxyJYohjZOxpOENBOkqlHHiQkQ75/G2D7B2lynJusemnmgDTX/9jqRy6i6E8Eh5dZmHkOGNf5bfhdYFYIup3dmI1yWwdF3GUVytlmhQ5nhppVORjA+htB5iRQ9JlthmBIjSe1YcX2I3gmRQ8wO05vKRHsRkslQbzQwVGSnOB96w41IHCF4U8FZ2NIar1I3SrehAlX0k7TYpqPDNyHS0vI/VFGWEAh8p876t0noXuDrW4siIAT/IcchE+ByUVLgeKDvv0P5YmPxNYq1yCV48G4MQAHJ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, May 03, 2026 at 03:38:40PM +0530, Vineet Agarwal wrote:
> Update write() checks to properly detect and handle partial writes.
> 
> Previously, partial writes (ret > 0 && ret != len) could be treated
> as success because write() does not set errno in this case and the
> code returned -errno. This could result in returning 0 and
> incorrectly signaling success.
> 
> Fix this by verifying that write() returns the full expected length
> and treating any mismatch as failure.
> 
> Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
> 
> Changes in v3:
> - Simplify error handling as suggested by reviewer
> - Return -1 when write() does not complete fully
> - Rebase patch against base tree
> ---
>  .../selftests/mm/ksm_functional_tests.c       | 27 +++++++++++++------
>  1 file changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
> index 8d874c4754f3..4abd98be3f59 100644
> --- a/tools/testing/selftests/mm/ksm_functional_tests.c
> +++ b/tools/testing/selftests/mm/ksm_functional_tests.c
> @@ -498,6 +498,8 @@ static void test_prctl_fork(void)
>  static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
>  {
>  	int ksm_fd;
> +	ssize_t ret;
> +	size_t len, sleep_len;

ret and len should be of the same type and one len variable is enough.
  
>  	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
>  	if (ksm_fd < 0)
> @@ -506,11 +508,17 @@ static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
>  	if (write(ksm_fd, "1", 1) != 1)
>  		return -errno;
>  
> -	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
> -		return -errno;
> +	len = strlen(pages_to_scan);
>  
> -	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
> -		return -errno;
> +	ret = write(pages_to_scan_fd, pages_to_scan, len);

	if (write(pages_to_scan_fd, pages_to_scan, len) != len)
		return -1;

would be enough here and below.

> +	if (ret != len)
> +		return -1;
> +

-- 
Sincerely yours,
Mike.

