Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CCEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62AE66B00AE; Fri, 10 Jul 2026 10:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DBA26B00AF; Fri, 10 Jul 2026 10:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518416B00B0; Fri, 10 Jul 2026 10:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2864E6B00AE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:02:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 998141204A1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:02:48 +0000 (UTC)
X-FDA: 84973032816.17.11C5CB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9BA4180002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:02:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVqzTa4s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783692166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXRFFkLYVns1/+XFmHFxA02oUx/vG7e6oaudilozWhU=;
	b=bvadgh/M3H+pc03ak4bCdbAZNVyVVpvjanf7X2I8LaEayxzUoo/uhSWzt+DSFhy4YTgAbw
	CfxuResf4PDLMHEqa5uKg1pTu/KRufLL8tj6YC2W45HPKYvGrFJqlqzn0lUsBfGYtOZG/z
	6Ikjh/lWMzTbNVH27G1JAKZyS33yeHY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NVqzTa4s;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783692167;
	b=pDVt0yyufd7MVGOnwpLthgXOONZKbjQAlMVLZ5UeQ07ajzGUd5ugHHZyTwJg3Ei9qAx97I
	SATjWXWpVQwBKKCZBKTppX9JLMRUh4czqgkng6SdR09ortyuOj9Ui3lajz81uvtF0RHlz4
	6kl6WhajsLc5hamyiyBweHnr9v9wetk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45582600C3;
	Fri, 10 Jul 2026 14:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1481F000E9;
	Fri, 10 Jul 2026 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783692166;
	bh=YXRFFkLYVns1/+XFmHFxA02oUx/vG7e6oaudilozWhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NVqzTa4sCRa2i+lQ20ttLl8+DYSA5pV41sI1EMXc8DLGzL0+p9SAXYy7+73NBq/gY
	 s79VGcmES1x4l0YI4xlc9XoQwwVpnHGEvCXnUW/qNozPSdTft1SVFzrQhLe7Rx4ZLj
	 R/majU9cH8n9+ILjd04KtELbscU5sfIaSR8A7aL9gOWkk7G6WyydJOSk6tqRC5N5hM
	 jfL8I0lfhjBhLG2evyMEoyptCl1EONDwAL2BekQDGtZiRxFZnWMd89N/Nz9+uYd4mU
	 R3Hkgx4EXmbPdFj1e92mE5D7jPM81FV8vTEpo+WE977Iy4N5e+S+ky/zWJ8GsJAoWi
	 tKEtWZ2ufe6FA==
From: SJ Park <sj@kernel.org>
To: Song Hu <husong@kylinos.cn>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: test damon_nr_accesses_mvsum()
Date: Fri, 10 Jul 2026 07:02:37 -0700
Message-ID: <20260710140238.24103-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710041530.557455-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E9BA4180002
X-Stat-Signature: hod1spomw4g9pcw8afszu5yfjx1zbxft
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783692166-16183
X-HE-Meta: U2FsdGVkX1+ZZUu9hOTRg/2/y5Qju8v4cI7nqNxYWO80ipjltp007ZuSE6SoeMzfC/myQB15pLy8LVCDZMlXUoGvS3jzBnsBoOa5+eVvNfZOVSVdKq1netfp9/TOKkqh+egb/I1is7J+czQWCRScpOcCTy1WVZSK2zF7lS/jJDZ/U/+os9ZJKvSrUCVlMnlv4idZrGoPI87k8Q87gM2+URNmOJXPmzFNMpA5/s4GY467/ts7N0Ypw9XJZrYATWC9YXBdBhFWBf6mZP05OfS1r1dir3vnyQI6M2iR2CYAcl2PKh3BcDBAXXiC7/O3hsFx9RskDx2kOTvQPj27gfaE1TVURPR5ZJI7CNXAGBLbZTaFdKPddiYT1raBD38y3Vkzdr8mkedzIIR5zEnQqwrr+EbURo+a4F4IZxF0xUQa3Yab/uwQJYShxNohxx/L85BQMTQLw8N3ybsGwYWwyvAhHmZLclnDtAlx5/Ut2L1IelJ3qXA+n6ytMGa/+kkEgSRUNBYtdyAyWY17RXZ1nT1SJnvLN/kYL3SRVMTbd4X/NfGHu81ctKgDiB6MsjIOx6RVUQu8dVGn0d9LTDLs/jKenQqKxk6/nuS/ww0uFq7NH/gE8D8FpuYX9IyeFJFJRJEJfRizDM8nwTob42mOOqkhB+sB6BDB0bI/Jz5VuI4K3h07JH7JMSVdlNM/ll2Ko01FldW3GcrMHbt8tf3qKac+3K4s5+bsTnCSZ4JaILEFj6b+IxYq1OI0wowDonZ4CLc4CxsfSOzmMpUfh41oQHSy6EzLR1Jy3PoQdiVbv+flEcw7ZBqMnxslrFbylXgCk8iQGB8Kqq6PPxmUl6JGyvreWjCsu/Yhn4Ly/LU1l1iu4F3FiMERvPIEmIyZYhmjqTQ1oufwW9CIuQFeulrVqIlaEDs451RvdMCW35/ZcvJn42pKOoMRNRpPqo815YmLZ1WobDrqQCSQyUz+pllih6E
 AysMJTv3
 xndeMzlcDAQ9JRFk/YbGEINHTkiqXHtmK0RO3ZSX/erdB88OrEGW4LiZvFWINEp6zstQg7Az0nDTs/X1EjIrIJ83UdLmLpgcfugeyPxyq6/iDenuEHhkq74MGGYU98RzNFADcWOoUHFy9+z1eXeMtXfaegllze0nj3mhF8bFn1fxvgZi5qUq7UtGlpCNtVEbFl8Enz8tQRb+to9YuvB1iXSqAZKN4A9fzgfz611jBfJribvrp9V6IiNPi2Y6TMaApbg95IahD+d0j/TKWndabG/tXVU12+JXyTpPye4YZIxv9WGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 12:15:30 +0800 Song Hu <husong@kylinos.cn> wrote:

> damon_nr_accesses_mvsum() wraps damon_mvsum() with the monitoring
> intervals of the context to compute the pseudo moving sum of a region's
> access frequency, with a special case for when the whole aggregation
> window remains. damon_mvsum() itself is already covered by
> damon_test_mvsum(), but the wrapper is not.
> 
> Add a table-driven KUnit test that exercises the full-window-remaining
> boundary (with both reset and not-yet-reset nr_accesses), partially
> elapsed windows, and the no-window-remaining case.

Nice!  Thank you!

> 
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/damon/tests/core-kunit.h | 49 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 0124f83b39b8..8c030282a638 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -683,6 +683,54 @@ static void damon_test_mvsum(struct kunit *test)
>  	}
>  }
>  
> +/*
> + * Test damon_nr_accesses_mvsum(), which wraps damon_mvsum() with the monitoring

Please wrap lines [1] for 80 columns limit.

> + * intervals of the context.  With a sample interval of 1 and an aggregation
> + * interval of 10, an aggregation window is 10 sample intervals long.  Each row
> + * below specifies the passed sample intervals, the next aggregation time in
> + * sample intervals, the current and last nr_accesses of a region, and the
> + * expected return value.
> + */
> +static void damon_test_nr_accesses_mvsum(struct kunit *test)
> +{
> +	unsigned long input_expects[] = {
> +		/* passed, next_aggr, nr_accesses, last_nr_accesses, expect */
> +		0, 10, 5, 3, 3,		/* bp=10000: unreset nr_accesses ignored */

I was bit confused what 'bp' means.  Can we just drop 'bp=...:' part from the
comment?

Also, let's keep the 80 columns limit.

[...]

Other than those, looks good to me!

[1] https://docs.kernel.org/process/coding-style.html#breaking-long-lines-and-strings


Thanks,
SJ

