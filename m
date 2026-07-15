Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 097E9C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:09:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0797E6B009E; Wed, 15 Jul 2026 10:09:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0519E6B00A0; Wed, 15 Jul 2026 10:09:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84F66B00A2; Wed, 15 Jul 2026 10:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2E276B009E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:09:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C57C1C009E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:09:35 +0000 (UTC)
X-FDA: 84991193910.20.2573CFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7965F10000D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:09:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsMhAAJu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784124573;
	b=IprPw5FprpK/D4C51vuSFd/C7S/lgj5Kyy9MC5NTp8GXOPyoZmJpjp4LngdepMB+QF1qBj
	DQiUK22Wh7crZ5T+50aardb7YqFsJ4XXqXjr61C65jf6F5frmLCASlY0cG8y6RrWFcQs+8
	29oc+WiLu5a39AVe2AAeVjf//kz5ktY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JsMhAAJu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784124573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmLajELBwebxH7WxDXtone4cRwMQnjq82TSthiZG3yo=;
	b=WhqxsvR237OFaLXCE6rBPwui6awuov8qhxjTZ30SJN7S1919NXME2VnIU28JT8RQA58I8T
	6ZzISJzyUefDtP/2JsHJrV6L4gfNh7EwD3FkHH+btWZiJXP7wQdHNRecAG6w2OMxXLlIJe
	abqVa2jenANO4J7VG04d2obKybZVTBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 609ED41E48;
	Wed, 15 Jul 2026 14:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E091F00A3A;
	Wed, 15 Jul 2026 14:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784124572;
	bh=fmLajELBwebxH7WxDXtone4cRwMQnjq82TSthiZG3yo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JsMhAAJuy0UKuZYDWb8ZyxBhcEuXGK7+4HoxA4WQGGFilUXJaziL3rUg7N0l8O0oY
	 yaHX8HnIfERUujyI5L5IhE9tZnSNQCC9KcTHx5qoAAjZ52vBqwR8KuPqodpd61mKEm
	 D+s4P+6SRTeGylndvOLiBBr09KD1cbI666l3fAuMwv6q6DmrbSdwMCCqScrRl4y/yp
	 50wFx4hlc0cVgyHkMrDAgkeTNMowmF4oFjCFbi4LK+SXX4YwLZ2Jisj6DWDGZ28TKn
	 C9r9i4lyMv+fR7kGR501lTKkzRkVtYaLFNeuaUFm8JbK0ISqN8kBErZFDitcqKdX2f
	 jSIxL3z9xKN1g==
Message-ID: <4b6904b5-81f9-4e27-8ac5-5bd7e7174c5d@kernel.org>
Date: Wed, 15 Jul 2026 16:09:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: khugepaged: skip swap tests when swap is
 unavailable
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260715133418.170386-1-jaeyeon.lee.dev@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715133418.170386-1-jaeyeon.lee.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7965F10000D
X-Rspam-User: 
X-Stat-Signature: ppmr61jsmjkjodxkwabeit3ch8wy9edd
X-Rspamd-Server: rspam03
X-HE-Tag: 1784124573-874084
X-HE-Meta: U2FsdGVkX18QOWB/ZLNRhxwIaLrxW/ssRlMktZoJO3rZk1L+hXlA5Kb37nqMJB6k6RjJ/Cz5itXIZTdoT1x8n0Oet6k8bIO3UUuThtBjlwx5FjUiyXT/UFutx5HW2W9YV+cBzeIIVkTV4BaaWnp7msrNfo7GQrq6jIFpDcQzNrlJ4DIBC/Nkp/Tfy5CBWE7bGUkzr85zapTN50NO4p63g1aPgv0PheXQBSZtjTONKrGYyvxG3ZADpmG3y1g5zPo8iLBSWhOwy+ARmL507xuw8Lfnm6qRnsohUPg8O2nMLNfEC1hEpfk15y9qeiwc60BzevAwCD+JvH/Jvcf+qeLu9EDPBdLESl93/sgbZh3zQ0dTUDXlU8Yca8M+TSqoJvfXVQ6wYMVeNJLJuJu4GD4dSbeQZw0ZKV/Gr+ZeVP9SE5eINwXYxjNr2EVe7XsKpk6ptsdHNIe8/W+y0O4KIpHUNGiutVEQRDnO6WdxVTjt6WUo3wVywti7EMV5VAK8B7yr0DOdm1xCfmuk1ITvourm7IwGhvjypCTClAWX/QkgQueAoKsw4mAD7Rq8nnl/RwP475IZj/AH3uxdiWo29eiRKGIoTHjCFN4+fIGhiY1kTzWmwx1USmHz3Tozh7f63I8ykcjkz+bc9SEmK/cX6QFlS/zuIR0TOZS3QDetZO6GZPtlCi2MDVGczwmGMSdUwXTK+MdVvl5ZIXXKNot2lp8tuIoR+dhiuXUuiyCJm6o2fxkXdkjuj3J4QqxLheKj/BNRPZ2VLPUj4WRhtK8yl5LQy8GEQwcBOo9hvvorNzy7Xq5oMsPgt+HLC70xLojKgAyFdouZOAWxk8/ee2J8+W66ZrdKqk6NgPPGmuEWx0+mMJe051uhs2uhtLWxI0oxcqNawtTmDj1yAgUBgCVUWal2yUlGc21RpwtuIzRSVMG94cfl7Ery9hvWZEUAfhaCoJJzX5/OQ9hLFMdAG0tOXb/
 6RolUA/X
 LgGBHW9yz8V4tf4E9tBeTtoshOxTlXUeol/k0w6m+LC81mFN31YVYy8ar4kUTY6kSsxDGeLk06V7gza8F97TnIESAGMZeEPS8LKQ1SrngVRtAbjGE948eFR74OD9kDLY3fFa0ghjXO4nYVuIfSWhEhrhzw86yoY+GO3qyteC09P8wVO75MeRAW9tfMRElqp3lJo2T6Pi4XDtUK+ZL/RAzFte8ZTkgNfMc8TOr9H+Ts52oV1/WQwRBRcH5twrEhTgsdikCR+GfYdUhA7B+hIqxzbQhsGBYrCWp9fHwOQDB2OPqHDlN99GxSvCNbKQm6ZM/cBrSa9eYQ/x3MozKmlPdJg1eJLZP98I9rIhl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 15:34, Jaeyeon Lee wrote:
> The collapse_swapin_single_pte and collapse_max_ptes_swap tests use
> MADV_PAGEOUT to swap out pages before verifying khugepaged collapse
> behavior. On systems without swap configured, MADV_PAGEOUT succeeds
> but the pages are not actually swapped out, so check_swap() returns
> false and the tests report a failure.
> 
> These tests cannot run meaningfully without swap, so a missing swap
> area is an environment limitation rather than a test failure. Detect
> the absence of swap via /proc/swaps and skip the affected tests
> instead of failing them.
> 
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 10e8dedcb087..f9b4ebe733ce 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -100,6 +100,22 @@ static void skip(const char *msg)
>  	exit_status = KSFT_SKIP;
>  }
>  
> +static bool swap_available(void)
> +{
> +	char buf[256];
> +	bool ret;
> +	FILE *fp = fopen("/proc/swaps", "r");
> +
> +	if (!fp)
> +		return false;
> +
> +	fgets(buf, sizeof(buf), fp);
> +	ret = !!fgets(buf, sizeof(buf), fp);
> +
> +	fclose(fp);
> +	return ret;
> +}
> +

That doesn't mean that swapout will succeed.

Take a look at cow.c where we use pagemap_is_swapped() after MADV_PAGEOUT.

-- 
Cheers,

David

