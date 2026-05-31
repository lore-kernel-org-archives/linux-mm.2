Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5928CD6E5D
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 13:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E177A6B0141; Sun, 31 May 2026 09:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF01F6B0142; Sun, 31 May 2026 09:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D052D6B0143; Sun, 31 May 2026 09:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BEC346B0141
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:35:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71775A04CB
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:35:52 +0000 (UTC)
X-FDA: 84827812944.18.FCE0BCF
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9C40F10000A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:35:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Q26I/UlF";
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780234550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ecmbfN6Hxv0wzfAQ6MM3bdc8Nu3WaBbGIPmE7GrM3yA=;
	b=V51jrGwbDIFBa2A3FVgdtnc7i1L76kSdWYuDf3+A2SfstB94VfKyNyUmx8LoyHGjQSN+4l
	+1n/RLEbFr5XFRQo8UInqdpiir8CKhu5pjwQnFfBtiY0Klp20zAkn6QvMKzsjM84cD4y/r
	WvPPb82b89yBSPLz6m4Tj4+HNrKYIwg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Q26I/UlF";
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780234550; a=rsa-sha256;
	cv=none;
	b=s+NGgJzvGvCdxeOUYF0DMr8+sdKMm68XxGPEKzrtgSnq1i0zmTcPDrWX3OxCsDHnlGNQ/C
	t77sumTTkfv54lhIBcslAftpMsVxeghWdgPlr+6xFZfwTCR+Czj53Yv0GNd3z+nHcQNbmf
	TWW1NKsB3VZiPeFND6nmp0TCBOTL4aE=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ccd1f57b32so44184276d6.2
        for <linux-mm@kvack.org>; Sun, 31 May 2026 06:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780234550; x=1780839350; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ecmbfN6Hxv0wzfAQ6MM3bdc8Nu3WaBbGIPmE7GrM3yA=;
        b=Q26I/UlF9wABbMBWQarXD++pcACsh3oEBIW0uwNRxl2BYRkyUTlr8s5PL2K3NEbSyH
         49DceVplMCDWM4cUdnT3JYJ4QfTN9etPKgn2hYInKUJOlNr1u7kIXrrKcBZPq04Jv2ZU
         PtJ1LpdKRsp+3LOZX6MG9CsG0ajYvO/CwvyeqF/tVFlgBzHmHWyCWbJbeG+6LOGYjdoK
         9zpuq8YEjl/l5Y66Pg+pI4mIScoHrvFVXDmzqbFm70tPsFBpglpPHGY7WsDPPBLp0Tm+
         wfGqEinMM+pO4lGm9kqVEnTdUjIOsLhglEWXba1C4w1nbqqFaJJmJ1o1bnQbZW+ilKzK
         PlsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780234550; x=1780839350;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ecmbfN6Hxv0wzfAQ6MM3bdc8Nu3WaBbGIPmE7GrM3yA=;
        b=l4foPoPCNCvtWEcQC6YuIzLR0bZUdOpgs3DlLOX4nd/XzxMMmAW8/6mrUVIQpis6Tt
         3Wq75+aUZHOLU87gJWnhjtvDeLJ7K6GzUuWr/8j+Kz/hTuq4ocuujJXxqASS/F6uo5zc
         ZhrizSmhj1yB5+bm60bxNKccduVSDUugG+t2Fn8jq8PkZA62xoSIbky7OX+vsJu1e7c9
         SBCY9hJt2MxPpfHpG4Xt1hs0Sz8dMKH/wrVNIw1FsW/U5+zQzu8hZ5VcHEniGabpK5GL
         DHEULKOU7Y+2r6riviTRKO5cIfS9eaURkEq4wkm8KsNVngPwMfsX1dvbyh+D+rm5+k4K
         nhjg==
X-Forwarded-Encrypted: i=1; AFNElJ+o5iP0n11Rxbc58GDOF3l7tREcebSV378tJvWpg6eux7Vhs6CXf/tGCRCjuaTBQ0GQLmF5eDs7qg==@kvack.org
X-Gm-Message-State: AOJu0YzhUTdiknEUeXsGifSCfUPnLoIxHowqA/VtIlBm4/71keg/VwtJ
	MQJ80t78C0eE8b0m5StXEaKmQZ/nBET2YOd2a5GYtPYTReejx+TIOSOVFMnAvdzm9J4=
X-Gm-Gg: Acq92OGE6hOVMEDSa+zqcv/xeurun4BNq8WWwblNHq3+Kd4cQJEo6MFWo6TjLicGkwP
	keWQ/TthFuBQWRf1s50BZ4rNgA9ehIvh7pCW1biKpQejRLJTtAJsWRI62CSzS7O1atb/ZrNp9I8
	yXWLDWEjlzjKs0ZsX+AolMEWYKm1y4D4h1yj7DfAz1x8VNmF5FOb7XVTJarlVN2SbVieyRLCwSN
	NTziOle9dSg+qLU/AmXK5MJx91htwFHwrcYVXbG2XTv4xjYpynflr1onEVOcnYNbRCu69tqfRKN
	ov8peD4L96FHOAiWmdqNwWBBPv61qR3qgG8uXTlbLSw0AGNC201IJj8JmY68mqTQ/wGRQUs4DeB
	bUeuTJl04kKZTzyQCT6ItV36UV4NWOCVV/c3mYmTFyrpe8RUUgNGHqojw4rAk7LHyS/aj5iI8HI
	qhQ++NvS1T17dWTl6HUFzoKsVQ+pyzw2wusToq0a5fWnQDUwgZoQpG+RhKdZt6Ew==
X-Received: by 2002:ad4:5f8e:0:b0:8cc:ee2e:8d9b with SMTP id 6a1803df08f44-8ccefd58403mr113278696d6.18.1780234549737;
        Sun, 31 May 2026 06:35:49 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea0425dfsm69984996d6.3.2026.05.31.06.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 06:35:49 -0700 (PDT)
Date: Sun, 31 May 2026 13:35:48 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
	pasha.tatashin@soleen.com, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 01/13] liveupdate: change file_set->count type to u64
 for type safety
Message-ID: <ahwv0ZiyQ6TzoCah@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-2-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530221938.115978-2-pasha.tatashin@soleen.com>
X-Stat-Signature: ae5z8rexpmbp7beghya95s61ehn88bia
X-Rspamd-Queue-Id: 9C40F10000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780234550-989770
X-HE-Meta: U2FsdGVkX18KLuDnORh5PTJCNZWqXPgFEWXY4scA75uRoalYD8CyAu6c4y78Fv2OqEsJxjClxvFS/rMOETei0SXLb98SpcB5w+oYuQ8zP30dR5ABNDi6RqIi8NfjtTowr7lQB/g3XeuJb/+4e0U1ZpqXSv+XGW5491Lk7bJ9sBHIoH11LhKT5QpwdIYG0SuhyAMdRy3ma7Hd6JjiOoUPBd8FEvce8hdP7UarBiciB8T2Kj0ijda6mKOHi/f8pwvCUbCM1F3pXL0L+S7Vd6IC5KUTPelxL8wE4Z5Aa+pPAhiaaz1kxrrggV+W80ZqI2qxqOdCTAhYnMPyxYerosvmEmGq7TPfJPVixQ/6pYgIzAbLikqlGMQ0+PCp2LLq2nYjrIDZJVdqxnbLVxYtBCeuTXnnikHrw7HBpEJy25mRVDmu7JeR0NE4veGfKEsTtsHfN+ZEasd3IQSnOm6jI9lfFzbVU3UuYg8lVkG/DabsPGubNvExl2lv0in5vgBD7JgL/4GPaSuykx38B5bhUT0cWnpmJRQE6rpL44/8+zVUTuKtvfA9hoAkS0nviVksYqYn5BVmZ4HG2HRF02szqArrFhlxlJyyXvaoNO0RvWoEkEBcKl8F2nDjd31KPCs6Guh3vc2VWsyPjxADlcvF4WSakOCxmg9NN4WvAsEyhym+8vmd3TVOiCIe/BM8q3cVP15BN2ELtbX4BfRodptK4M5weps5EzphOmcIU3YVld6GKX8UisWjUUsMpTaT92zY5qgpV++qrGbs/Hk4uamsiCcBYSbEggqa1gOup0zjmnWvYNp8/AxfS7qjxkfCYsyABVv3ZZhXPh4TcqEOiRStrkLCQPyexFJE/o0Jg3g8+qHtT3dqjQ4fLwglyLXGqdKs9ed/h7giytzsyjGp5eBXxqz3RgpdF4mfeLFuR4as7Ln95BNj9hJ2KyYUppjJg3uztf2FTBWrOQGC0lBe7IeBrDH
 fYWFUKod
 MHIBKcsHWYVyKKTAlr8s7pGBQqGq9iSR257j35Drr0UzoW21soNHVc92g+yaXJzK1j1AbMo+LaVgugwPP2//zUXQfl95KJGGVaHEXL1k4sSIiXwDw5zdW56fuV8nGg8h6HqpGTCvouBV24PaXm2R0bi/Thpsx5vnCnIssWWJOKjGkPmeMVgYUBqlXM/VYUGCMl/JxKzvRxegjdn1LoDTrQkft6kUuGcsyb9qaNTrfXy8SCpr9azeCF+hQPu9gtz/3TEYoEX8oUCDNMyehabPV5fjCfOTHoR1mN9oS+p4YFKm5bclRFCeZQSkOrcXCgBi1qiOQhJKiQuVmTfGPXZRL/XWqvSBIT0U32uT3ZaNax2LjdyXmpAHlbAEwMfCCyOYoZ86hCakM0JNh3MohF6VR4nAYjReHWetZjs1H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-30 22:19, Pasha Tatashin wrote:
> This improves type safety and aligns the in-memory file_set->count with
> the serialized count type. It avoids potential truncation or sign
> conversion mismatch issues.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_internal.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
> index dd53d4a7277e..ae58206f14ac 100644
> --- a/kernel/liveupdate/luo_internal.h
> +++ b/kernel/liveupdate/luo_internal.h
> @@ -52,7 +52,7 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
>  struct luo_file_set {
>  	struct list_head files_list;
>  	struct luo_file_ser *files;
> -	long count;
> +	u64 count;

From Sashiko 1:
...
Since FLBs use a single contiguous block for serialization, an untrusted
KHO payload could provide an abnormally large count.
...

Answer: NO, there is a chain of trust during live update. The previous 
kernel acts as a boot loader for the next kernel, and performs all the 
necessary verifications. We trust the previous kernel to pass the right 
things if compatability strings and format matches. KHO payload has the 
same trust as the previous kernel.

Therefore, we assume the serialized metadata is well-formed and valid. 
Defending against a malicious or hostile KHO payload is outside the 
threat model of this system.

From Sashiko 2:
...
If luo_session_finish_one() fails (for example, if a file handler returns
-EBUSY), the early return skips luo_session_remove() and
luo_session_free(). Since this is called during the VFS release operation
via fput(), VFS will unconditionally destroy the file descriptor regardless
of the return value.
...

Answer: NO. A finish failure means that we cannot safely release 
resources, as they might be associated with devices and DMA activity. We 
deliberately leak these resources to avoid memory corruption and data 
leaks. When userspace fails to finish properly and closes the session, 
the only way to recover these resources is to perform a cold reboot or 
another live update.

>  };
>  
>  /**
> -- 
> 2.53.0
> 

