Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8548D4662F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 22:07:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AFB6B0005; Thu, 15 Jan 2026 17:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDEC96B008C; Thu, 15 Jan 2026 17:07:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE0C56B0095; Thu, 15 Jan 2026 17:07:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B99C86B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:07:47 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4165458B11
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:07:47 +0000 (UTC)
X-FDA: 84335586174.05.96C9318
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7DD17C000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:07:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c09TgZ58;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768514865; a=rsa-sha256;
	cv=none;
	b=WZDRDYcLnyzw15zXmjOBdhYvcWnG1PHTxB+7vvgozb6AqL7vGsdRRmYOHc/uA7Y/xf7poe
	BbGqsO2zgGji6xt33qpAWBwxeYyWZxSc1EYG7+6kk8jmd1/NMd0H3eefeWEl1YhNDLFzfi
	lvYxqGleo+f01Lm6LOjUbhyI/eWHm3o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=c09TgZ58;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768514865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RweGDy9hi+XhSYL959XswHHDwGBOE9WGO3p6TIk9HQ=;
	b=CQIoiRrfrPvgxfsw/AUbfbQ6/Ylgg3K7mXyq4dObLJL2/3R95ONFUVWTNgaS1GzyKYZzue
	wSb+ODAxFMkx1LAfF9F684grhFUHBx2BzXqeaCenff49ubhmajOEZdwZ4A3oFY3RtIlEVQ
	/5juNJ+AIskgbI7HdHB7E+zrnkQYNFw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BC83409D0;
	Thu, 15 Jan 2026 22:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46889C116D0;
	Thu, 15 Jan 2026 22:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768514864;
	bh=W3Cr+RejR+eSzFWDIZeH7kRpZoscMgmTdLsXquo7HdU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c09TgZ58wztqMmQaJ3qAKXi2wc+IryyFkL4oL81hS6kx168XYxN4THaoameBiTtnW
	 OLcRPlXnqzBQz41pRk/sSplUaHVdYQ/bpky+B5rXvFugZuF9EWfYPCiZIT7ZvapCPl
	 7JmaGvH53+iIMwIPvsaF7WbJJPhAoLrCNMgN2+qM=
Date: Thu, 15 Jan 2026 14:07:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Mason
 <clm@meta.com>
Subject: Re: [PATCH 2/2] zram: fixup read_block_state()
Message-Id: <20260115140743.f7ada77bc912595a580eaf7c@linux-foundation.org>
In-Reply-To: <20260115033031.3818977-1-senozhatsky@chromium.org>
References: <20251216022727.578BFC4CEF5@smtp.kernel.org>
	<20260115033031.3818977-1-senozhatsky@chromium.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1z3bfchwfrd41ekowna5mcmyr83mi75f
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7DD17C000B
X-HE-Tag: 1768514865-454067
X-HE-Meta: U2FsdGVkX1/BSdZwF1S6Yz2xJjrDLxVukayw4rewxGKmZq+0IVXXYLovBE9laR7r0jNMNqKh/udHMgS88z/iBq/F07JRI/ZdxqAkoHSfEs4R4RC06fVlMmWrQMGn83azRnpcQEouq43oZft+c1LVO8DhCgVNvzQiM0RCTXdBSsd2KEP6RJTcJL5VCxNV1hWlGol58i+kuJwzkcP69HBBpPs84OotkiaxsyAIgxexfJ4XZMdAA0XyAd5x3jJVvTAyYkqP/53lDhq8Z3tQHZ5b/c2cypDurISeRLrX6sAhC/kiS/QIViAoyLS+/nDRUe+qvERL7kE6V/m6y6XT4JcLbc4KeVES3n7jv6L8RMpRatH98/W1uEksPh71qLLZop8fH9RRhsg5hcf2RLimzG3FI+sz/X4De/bIKdGZf4w4QE82uPxvXGcDyvqkyP0SmT48nAPuuiYqO3zqqVTF9HuC0hLUEt/+O7ecsy+U32vBDt9ymaedpFhB5ATG9SG/QUnVIOsUJPBQk7NAHzQyHjjDpUJHIYibb3mgL+mJ6J1PtgM2P0TdqiiYJ0NXU4VoH5Uur/CN4B7UQO4+V+fTvUeyWVNpDVi0YbYu+TvSU1s6+TRYP3eGYAhDSh6W1W8fg9JggCPEQ4dyzduwLmAZo0f14w9T3szXfecadUjbarQApyqhHCFRikqX2JFX+aFVm/7x/hFVV8wZnoACGNzYuwAJHhoA4WodYZPjYG8AuPLPxV6jODUcsPFRjNBfVcV38wGhUzlj+aBIBXoiFGNfmiOQQ7Tk3KpieUx5Ggwxlf3QwTcNBFOR30rl60oL7BQ0gLEchqEhV46Zh+baHBI3OI0ijV+KrTvI6CIUk2sPvFvLuZkut+yErGzE5CPhXI7oMDm2VzPxNb8GRDQWb0HWgg5WRiZ5GOltFB2yRTb2qbko1I7ikbtApdKDwGBG1DI3eG18V4X0AImh5e4BDjs/S+v
 ds1+TFS0
 9WThmVsRsrPdJFHmQHP2yr1aaoyCaw0dU6wRLd6KS1UE1GXqRaP2kDcmi5/4Lakx3wPyhFPvyRBq5JZx364uis/93zQ/s3igBpObVdwr+s5c/36oUenWF7WmfbcCAAPQGdsXPajCFrnd3RLp/BPKbJGABrXT/Fwdk2Bpb0kHeqjy4wLDhcojbktVg/S2DTIvrOioanC8XPgBSrtzfm64XMOrcJuxe+v72rFIBx1vh7vtJX3FBIsMfOcJx/1YNfx++p+i0wyi49k9yEYL2cOrm2X2I9BtVSFMld65mhIv4SdgDFAqeDIft2Udx8uGfTBG14371Zk+jL3x3tFb2dcJMjfSBoOaTLaOePW+o9ffb/O+U2Ottf+3cv89CGscJgElhxPH5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 12:30:06 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> ac_time is now in seconds, do not use ktime_to_timespec64()

Please help me out here - which patch introduced the issue which Chris
found?

> Reported-by: Chris Mason <clm@meta.com>

The Closes: link would be helpful.

> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
>  drivers/block/zram/zram_drv.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index cc51aa8b6181..912711faa4e4 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1579,11 +1579,9 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
>  		if (!slot_allocated(zram, index))
>  			goto next;
>  
> -		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
>  		copied = snprintf(kbuf + written, count,
> -			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
> -			index, (s64)ts.tv_sec,
> -			ts.tv_nsec / NSEC_PER_USEC,
> +			"%12zd %12u.%06lu %c%c%c%c%c%c\n",
> +			index, zram->table[index].attr.ac_time, 0,

local `ts' is now unused?

>  			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
>  			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
>  			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',


