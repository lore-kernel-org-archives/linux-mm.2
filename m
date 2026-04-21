Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE8BAF8924D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 10:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F217A6B0092; Tue, 21 Apr 2026 06:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF94A6B0093; Tue, 21 Apr 2026 06:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36996B0095; Tue, 21 Apr 2026 06:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D44DB6B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:25:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 77747E5BAB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:25:59 +0000 (UTC)
X-FDA: 84682182438.04.75A37AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CABE516000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:25:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3h4oYPq;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776767157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JEnbnARUnGYOzvOOAfD7bDEij7ZoYspS5aLmbpnF/ZE=;
	b=ctxvx7LxrN3nqIy3ql3i52YOQtzw1lTVMDU5FdjHPObBzbjqsOeHWAp9UcHw9QEb29TQXV
	6Wwz/yT0ILpiAZJ276zNlAzWBB4LxL/2JILCrphfTST0E5sXJovtWYqTb0lTgdw/mNF7hp
	Cy55sttyXFW/z3oaMRHstiDGslDSZns=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d3h4oYPq;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776767157; a=rsa-sha256;
	cv=none;
	b=SQk5YtwZGuhyswsBUZCW0FEqwgfqcEGBlCEHZjgT1TvYSJbTkMPOwvRGGzZcHgK9X3ef5v
	Pby1d9XlQr9Z9/V2CBKr92g6hZ9pY/3gMEFYq7uxGyeCb+4t5JXL5exsSxZfG19HesVWVW
	cjH07Y9TAmUjTOio3sDXWdT/C5rAUNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E7701403D3;
	Tue, 21 Apr 2026 10:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D91BC2BCB0;
	Tue, 21 Apr 2026 10:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776767156;
	bh=4loqqwmVByZydFOLKx4Df/CNcWTPfKogyfRe2H/uC1g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d3h4oYPqihpDwu5jSY38mVpZvUnUftD4h+6bma3bEJMXePM1uyAyqvqpKcJrwoX44
	 KFvKUNwjb6SdyFGKEnZVVEQeGNKrAicp+kuBGrEk50YddCWx0cx1Ikf0+EldqBmVq2
	 y4DfQf3+KDm0FgFPMk9pXTsiublJYe4zkXGKBuybI9Z1zprMIyWL2DRXsSJXjztf65
	 +JJTUzxIrKJ9ZtkqOkBAP8rQEU5aNZijRMUEg4CkYuyDYdXTXnNySYoOTjPIiFnxAq
	 hmLPaS3U/0RNf+6kxU+Dr1CBJi2hjiHDfRjEKSFa03BAxuMGnWNGMxbq1UlamIGsgc
	 36Wgw6s5N+4tw==
Date: Tue, 21 Apr 2026 13:25:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: luca.boccassi@gmail.com
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
	pasha.tatashin@soleen.com, pratyush@kernel.org, brauner@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/6] selftests/liveupdate: add test cases for
 LIVEUPDATE_IOCTL_CREATE_SESSION calls with invalid length
Message-ID: <aedQrhEYmgsSvNuB@kernel.org>
References: <20260420141741.2688371-1-luca.boccassi@gmail.com>
 <20260420141741.2688371-3-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260420141741.2688371-3-luca.boccassi@gmail.com>
X-Stat-Signature: y99kks3gitoxbrnwu7z8kpwdnnci7o8k
X-Rspamd-Queue-Id: CABE516000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776767157-396129
X-HE-Meta: U2FsdGVkX1/YFDSwQEtslKBLUu4LwpNsRsEn/Vg8ggM1JtMrhlFCLBGZwaroWzZIASpuourDgSg31VgwXypM3UgMdAXk8j9fzI6NSWDuTuOWDeftu0xZ4Jdgvbr8+iNf/IA2pUHAOr5dWg4B0CZoEYzvVyElJkE1Vil0KX1Ve27l/0KNWLi63wM3BTZGL1Nr2HfG2b4KXGDAo8q9zBW2Tr/OnxCJYDfLjKUAuGO3W5behdZCOIk+BQIpC/2DH13iHhpdjftV+WJlV4ST8KNNfnpu+V4utFeIFFKl8LHVvowPubLebUVrw9krtt607+E3OZFuMng0kl3mHjxD8CusDkRp59o34o1bEU9kD0wTnfI67UFWeUO/JuiiYLEYOdVgQa1aEMD20JFpzpT6PbooJJLinhjxm8aOJvnBzgDTw4JAiYhv/iOrZfy5p0tQweDW76cL+wZlyXTPletRgfwsiipfCTX5IWnjaeGi9iOpNHDVmkcqN7lXJsShmMgw4bDMYnAlAOKmVDRQoXHZ/qIzX478NvkjycRFFKQy2FECwaf5MLcvfhktApa0nQLGM8Wjb1wMxqfXU14tVqDEJ8En32Fo6XXliqyuQLrckc8Jmn0l5b3MVsRsrbQbl4/Q/o4mltpds5+f7VnjS77woOsI/4WUcPO3mrqlBQyoS2EH0v9VjdlB+0jSwTHJuI3hQthfifEDRCBiCGST9OM9F8+H5qF0phYqaHW9EkqtZdG97pYXYDmnhyPmwalKt285MC7B5MiEMdp7ZX9y5+t46uA1/adc99Gsy/kfAmkDD12FYhlpClv0hN+ETqjHXjC7dUpgB4XsiCPik4O4TWXuTqCKBnUyvtsDcgKK90QUs7/wqUpci/OcQc4p7m04TsDtntgYzF1VOKrbeadQJKD1nqGZZ8iAmzFoaxCYaxgYT2BEw80RDyLqpWr4Iq1Q5TJFvJVxiPumJSbtgveR7NsUUyC
 QyXJWZK4
 cF5wqP7mn1dgg9RKCwVc6Q13BuK/XOYZD5J1LcwfXWz/1qSWgSaVtOWEY+pQBx+qeHDY0zBVvccpQ6Z7c384AkiOHPgBFO/8oqd4E/ln5uCBJ3a58fQcUYoVNEQV3iR5nFyUH4X1faBAS/F/YV29GIR286MgJ/4yJFUeKwjkX7YjqQS10cFIPw9Lt7UWYR777wiSsgb7v7nVU1l57+conL13pt2Hb/Bm3x6sEN+EOMy9ReRaDP/DwoyrkN9D/TSCiYGdP8HiTga1G8N574mTzESbUoXNZgHjHd6EW4R1rurCxz6/RwLqdAjUtSYsAxORAujfXwkVcvRrqggsml94jgNqdVBpPtiDXnfvk4psL9qxGCkWPInorpwk1vvKHgNKcmZRa75nHqNQyzD+P+Bbn6QsKPYoYgbTDv9TllgGWWyVfOt2gSMOazui2epBormGi+PIG45R2RSfuljNf5ySI/ITagadhA/SC98ai
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 03:15:10PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@gmail.com>
> 
> Verify that LIVEUPDATE_IOCTL_CREATE_SESSION ioctl which provide a name
> that is an empty string or too long are not allowed.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@gmail.com>
> Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  .../testing/selftests/liveupdate/liveupdate.c | 42 +++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
> index c2878e3d5ef9..f0a8e600c154 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
> @@ -345,4 +345,46 @@ TEST_F(liveupdate_device, preserve_unsupported_fd)
>  	ASSERT_EQ(close(session_fd), 0);
>  }
>  
> +/*
> + * Test Case: Create Session with No Null Termination
> + *
> + * Verifies that filling the entire 64-byte name field with non-null characters
> + * (no '\0' terminator) is rejected by the kernel with EINVAL.
> + */
> +TEST_F(liveupdate_device, create_session_no_null_termination)
> +{
> +	struct liveupdate_ioctl_create_session args = {};
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	/* Fill entire name field with 'X', no null terminator */
> +	args.size = sizeof(args);
> +	memset(args.name, 'X', sizeof(args.name));
> +
> +	EXPECT_LT(ioctl(self->fd1, LIVEUPDATE_IOCTL_CREATE_SESSION, &args), 0);
> +	EXPECT_EQ(errno, EINVAL);
> +}
> +
> +/*
> + * Test Case: Create Session with Empty Name
> + *
> + * Verifies that creating a session with an empty string name fails
> + * with EINVAL.
> + */
> +TEST_F(liveupdate_device, create_session_empty_name)
> +{
> +	int session_fd;
> +
> +	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno == ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd = create_session(self->fd1, "");
> +	EXPECT_EQ(session_fd, -EINVAL);
> +}
> +
>  TEST_HARNESS_MAIN
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

