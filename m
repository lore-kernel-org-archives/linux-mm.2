Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E269E606A323
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b8RNwxrC
Received: by kanga.kvack.org (Postfix)
	id E82616B05BA; Tue, 10 Nov 2026 10:39:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32F26B05C3; Tue, 10 Nov 2026 10:39:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49CC6B05C4; Tue, 10 Nov 2026 10:39:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AECA76B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:39:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B8701205EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:39:22 +0000 (UTC)
X-FDA: 85419618564.18.352AD52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A0B0312000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:39:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8RNwxrC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794325160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxFIcL8AVsaeZE4IFp9DhoZHiAUFlATqoX61kjAFAEY=;
	b=N5rOjiAUy8Odm1cEKj8GfxMU4jmTwOOqbeg1GiLEzHwMwpBMMl3lR5bp/To+hUSkcC4vRU
	CI65E9yrzD9KIMnAuxl4bolxfic8NvSlT1BQu62T9TK3m1gWSvFbMTNq2akYHlKQ8Pnw66
	mwmLOv3PQdKvxT1uSe6aMPk78Jbr2IY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b8RNwxrC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794325160;
	b=sB5uTi48EXv6bccTKI53IXcXzawbEOKp1dWtHKhLRjfruHhHebrPpNcPP/jmPI4vk3LhHF
	7RdX2kj8zYyFx8+2DzcRelVEf0smoqgDHWs/6XybAiTpih4iyZFGpBgSmT5Q4FCwHYbY7t
	XhNEl/QKMPpZtTOlSKxbgvwrNWtZPBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83F5D41412;
	Tue, 10 Nov 2026 15:39:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AC11F0089F;
	Tue, 10 Nov 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794325159;
	bh=fxFIcL8AVsaeZE4IFp9DhoZHiAUFlATqoX61kjAFAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b8RNwxrCoval3cj7VaO5A2ekKiYwrG6m4fB1V1beYqHCJFlZdt063QAGd6toVBr83
	 etntU9CFZEUgPMcYVHZYJ3UhlXaIH0XTgMdZnJP+k/BDfMMK/VhvuOaAwCV+zDwBLQ
	 ml2wpf8Zr6aaSjwttXo5aCMFtc6+9ht+prziUkDAvgsllki2tEiwMc0LOrxnsO/Yrx
	 /HczPATqi9To/i5RdnbPeA9DVAEBjTllfSyTjBI01XNDiQrtCIs1Im5iCgvxW/YBVZ
	 dfAhqJfxR9HrEqTQPEq28TlwGujAWv+9D0qI/gethfpu71Tb08V2WRj6J2l/Xg+wa5
	 qJQPkO9w8jPMA==
From: SJ Park <sj@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ahuang12@lenovo.com
Subject: Re: [PATCH 1/1] mm/damon/core: simplify minimum watermark wait time calculation
Date: Tue, 10 Nov 2026 07:39:06 -0800
Message-ID: <20261110153907.158338-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110085132.1023-1-adrianhuang0701@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A0B0312000F
X-Stat-Signature: 6565owyyb8ecaztqtoq1bb4bfobwyngb
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794325160-595236
X-HE-Meta: U2FsdGVkX1+rDbSyDU3iAxQaeB3X2lNIMqQPb8mOIKXLWUwcjdgle8cSC3Prrf1lBEWxWjKIcXF988tX1AD/3+nOtHjzrH6CAUno0CZKZED0Pt6jzaE0RHEFmPt6ZEbmp+GbkXVwsmfePyc00NL3j6TImPP2nugPvz0JlDiHJRGrXUIDPhe+9KvSI4OwSJf2uitI4InlnWuoBSZkZbszgDP4xmhgVUDrx2oiirlMdftqv/nyNeyCac45JpXP85V7AhbZpN/U/Gxey/iq0UIOwwEV5wMkf4RAbzgU7vvYYUwKWuYEpi/3mXIAF/DHNY1otrMPFa6/kdOfpDeZr4W+383RjanLdF5VMXeopn4we63rpVjSgeeD3c/9WvTagE0CAfoknpK1MlQ+CYLyaRkKcMrOZpmcHBy5bipkyAGkPw/RuGO2MXRRieuXz0NiM/VdstCTA7BoZ6iVojdFBG2mPhuuzAftdpkUOThpj5JVmuexkCKFAltt39HvIE7oPJzl6fIDCn4og1GYQFAlXsAgNxZKeEJ6S+kIdb7tgRvir+a99XM6tA+iJmM1P8CmTOWeY9m8f6daHeCZ+eJEOVR7yDTGhcjNZHwgKUPelYnsY2Y7VR+DOXcUV+ptAhMuZbHP4KB2HA+FFa6LMNH+TwEALYlnlGNE0Rt0MxBcp2dZnGdWaBk8ExI7BrREcO8msdwZYF/FALITb46n6f6khqF1pgHZDjQ7Z6uLN/a6XB4pjaBJaAdHZb5Nkp8KcmYewN1HE6kg8W8r5eaLa5Oq0SnoWZA1Z2lIY+7FvEu3Q1FeRxcH5of1VKy4tWGvj3PyBR0LOPL6LRdaaRN72ayN1JtkW5dud6QMRRuRvILc06zQAPl9bj9R1avYFxE/Wc5mbyVNNbVm4n2MnGMarDdw+A9m6UgcT1CHZiCA5ebQE8PM4AfXqPEotqNvkCmB2sbunQdXNHVaS8c+LFbNnKCb7P3
 YxSNx3Qf
 eO5Wxh36qD4gUIkDmw8lHhFZvNaeUuLCw4VBPqR2NFLPJjGg80LGO+QdKGb/ZKpoaMG10d+9cVaONyi3XJ1sr3MSknXaw+mwD9rqSSv/1bs5JZ3ja+idvuaVsuyqELi5VDTGfxHTVkfR/iSiavxOwx7FaGPBypqq7W1cS6u3KL2w7LGrd9d4cPnxGWOVENEnL1v0j13uBhCY/ccBmwoQ7DA0sfE+psNvVRLTidCBUQzutdTddDQUjaFQnts1bZApHV1l2zbaDpgL2Wc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Adrian,

On Tue, 10 Nov 2026 16:51:32 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> The minimum watermark wait time calculation uses an additional boolean
> variable, init_wait_time, to determine whether min_wait_time has been
> initialized.
> 
> Simplify the logic by using list_is_first() to identify the first
> scheme and initialize min_wait_time accordingly. Subsequent schemes
> update min_wait_time only when their waiting intervals are shorter.
> 
> This removes the unnecessary boolean variable while preserving the
> existing behavior, including the case where no schemes are configured.
> 
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>
> ---
>  mm/damon/core.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index d36823f4d092..93ec684a113c 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3985,14 +3985,12 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
>  
>  	while (!kdamond_need_stop(ctx)) {
>  		unsigned long min_wait_time = 0;
> -		bool init_wait_time = false;
>  
>  		damon_for_each_scheme(s, ctx) {
>  			wait_time = damos_wmark_wait_us(s);
> -			if (!init_wait_time || wait_time < min_wait_time) {
> -				init_wait_time = true;
> +			if (list_is_first(&s->list, &ctx->schemes) ||
> +			    wait_time < min_wait_time)
>  				min_wait_time = wait_time;
> -			}

I implemented and used list handling wrappers like damon_for_each_scheme(), to
hide implementation details of data structures.  This change exposes some of
such details.  If we agree we have to remove init_wait_time, I'd prefer adding
a sort of damon_first_scheme() like wrapper.

But, init_wait_time really need to be removed?  I cannot show clear benefit of
removing it that justifies adding a new wrapper.  To someone or on some
evironments, init_wait_time might making the code too difficult to read or
inefficient (system having so small amount of memory?), though.  If not, I'd
suggest dropping this.

What do you think, Adrian?


Thanks,
SJ

[...]

