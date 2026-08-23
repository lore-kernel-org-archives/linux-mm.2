Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48722C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 16:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C71B6B0095; Sun, 23 Aug 2026 12:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29F3E6B009B; Sun, 23 Aug 2026 12:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3E36B009D; Sun, 23 Aug 2026 12:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E92D56B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:47:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 683C01C145E
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:47:04 +0000 (UTC)
X-FDA: 85133113968.20.9B03907
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id A135D4000A
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:47:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DVtGmBoy;
	spf=pass (imf12.hostedemail.com: domain of abarnas@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787503622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZF6HUGQYWvBUACVOKONbBRQQpsYWeEt/fKmrPzcNd4=;
	b=c7Y6lsPr+/JiIYlJUIkFg3/op/0hwtv319znu8XvQB7Zvy+bpHhtxh4NYCQbbqIPkEOB0V
	9e2dNXYeTsI/h5/YHQ7L/nJw4TXOmLHrrO6Ll80+HEtR/vk5JALoCSLP4AzkU1oAx4SPu8
	shB9o+aaCvvIZWMyVNupKMZDJhBQuac=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DVtGmBoy;
	spf=pass (imf12.hostedemail.com: domain of abarnas@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=abarnas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787503622;
	b=1cUPEJJm+Ly1o09rtKW5Q0/Fb+hDGW/lFVS1Z2BeEUTKBOrV9D2dcw2Sdv/vBGD2xhsLTh
	RYLgGdcQX47DIjMAzg3q6icybUVTu71Ld51TYxgAHrWqDkgwgcLLLh6F1vrx8G+6dXEKlj
	zdudaZ5AzZStJ4mgMsvDLsDBjTPebP0=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47de008b020so1406144f8f.1
        for <linux-mm@kvack.org>; Sun, 23 Aug 2026 09:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787503621; x=1788108421; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/ZF6HUGQYWvBUACVOKONbBRQQpsYWeEt/fKmrPzcNd4=;
        b=DVtGmBoyI4aZ91c4C29aicZQI4s1SquDNHVV7a13Ct/KzNQKFJdMjeTQlC49FYsjBS
         BgsAq4vYr9qIOqWsndlIxLQSrmLX6cwKM7X9Hmup2t33MVjTguBd8Hzu6nzCkLemMHCb
         BYLGPo6g+Hz4VK6LPch2AqJRMajN5HMkKSnD4v8zeAhoOAe1LSGwCcWWz0nWFHZK6s2S
         HoWS/i0mHoqOizrNTd5VOn7OObLeAIQpu/jx/gB70jJne2fCWP0hMlyEEWCl8Xm4c9/G
         830RnBLckwIuUWeVlx7X9r2Tu2d2+oNH0J6a2zDtSqjAsNMcdN7ushLUt8z7QPmXZwNY
         mTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787503621; x=1788108421;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ZF6HUGQYWvBUACVOKONbBRQQpsYWeEt/fKmrPzcNd4=;
        b=PkZGpYB823mCNuGYin7TpJXFPRoct+Lkv04Xk9QGJCksMjeXBngtVy/IW5K7A4M8Vp
         SQpmYxvbo+15LmCwqMABp+jWt1c+iwiz5yIOYFdSSd16KWhfSmKqVW4zFKxcaFt3h5Nf
         69x0Idn/R9+1vivC/Zvd0Pwj0rhmCbKqFM46ngtJrAO/kfAuyMPZ3EryvyTg+2rYCCiw
         s3wvPHnHyyxRRrBxtWXNlDAK4TiqfSBcMloUn4bFEqlLKCFJYcV9i+BVYAKVIim0Obw2
         pgMaGKKjEPPGFTuIY9gtuv3Q2rAPtc8N1+ceQt2rX8qwQ3CWPTxaR6rTf8fPlDq8+l1L
         qBag==
X-Forwarded-Encrypted: i=1; AHgh+RpLRHX4lhKUsSpTBSI1dqeRhEWzAQBnxwDHdrVXxE8CCv0dkPV2HzZyLhSiXEOwh1spxqIzDtJJsA==@kvack.org
X-Gm-Message-State: AFuF++lpK8X6RvtNatEfx6C8mVMtU3HPsjDX2OqiwfWx85S8rQMUZoRN
	sCUHnnHwfNt58no9WIFoKmVB0EVpPZbVm5pWMGP9zcFaFaVcDYUum7G2EuFYCCojbQ==
X-Gm-Gg: AR+sD13AC7PQ1eJ996cYtW5WBILcpskcv44QjtcA+pxtOpDeM8zkYu2w+iPUHKAqMyP
	ITMpcm0VphX/hAWX4xTKsJLgyna7DI7fjaUpdYlt1o1rlSjMIhf7d6kYsg6dmncM8S0WByxYHpk
	uwwPcGZDUeZp8xvDwulIRqMxR8ARL4X97B0D+Lf/kXe2MrZPxVHnRXlbh9wJ2RTT1iE429ocLnZ
	rCZXSWKYvcODLJGztymzFzBbEt9n4lOBy8tEZOo7+pfukmW+zXV8Xwv45L/khMmND+ZB8qzcuow
	+mRgWFcqX07nzvsA31+i6QRclKbDebTnRZEpHgtgnTg6QJdlkjehhmup3aay0zkrMZ+aRK53hnv
	aRk47mahZZa5iSHjwHxPNKvQnJGi5+tdXocA8WuORceyEdLz+G98llluyxRkmK1nXuFVYFsvIxo
	XXDhTSgcnsO5/ersLevEOFq3yui0eDQ+OSYXPivlmLSM/gOGSfEilHxKze716pjU063MOrn+Ce1
	cZlaI3wnRN8umfR5e/tpL2twQ==
X-Received: by 2002:a05:6000:3104:b0:47f:8554:a341 with SMTP id ffacd0b85a97d-482b784c4bbmr35989706f8f.13.1787503620630;
        Sun, 23 Aug 2026 09:47:00 -0700 (PDT)
Received: from google.com (78.207.190.35.bc.googleusercontent.com. [35.190.207.78])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482c9bfd2bbsm5538099f8f.18.2026.08.23.09.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 09:46:58 -0700 (PDT)
Date: Sun, 23 Aug 2026 16:46:55 +0000
From: Adrian =?utf-8?Q?Barna=C5=9B?= <abarnas@google.com>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org
Subject: Re: [RFC PATCH 6/9] arm64: Enable the execmem ROX cache for module
 text
Message-ID: <aosj_1LChfLM8xaz@google.com>
References: <20260822135323.795946-11-ardb+git@google.com>
 <20260822135323.795946-17-ardb+git@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260822135323.795946-17-ardb+git@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A135D4000A
X-Stat-Signature: xf8nbgysduwsyb76a9zfjei3tx545dk7
X-Rspam-User: 
X-HE-Tag: 1787503622-256350
X-HE-Meta: U2FsdGVkX1/QWTJl+b9PsuAEHN59vl7OrQlPtX03oTv5FvQ9V+EYBvTBkcpPV2ZPIqoUg3rjEe/CahBCtLDthuagrL3YFbX3znGPvH6d78t769KWJHxq+abVyZeNJm/RDX42kbuut+s/Td7DRfR65L7HeyoVEkoeEMSqt47LGLxXvvIteStYLkLpfD1k+7ZfECsc0dlSps5KUZrzHp9rvWroFGjr2LXldrg2dmhAZwsGXyI9HpBD01v84MoMHpNNfrd5V7MuxW7DEkEQRGcJ/L7WcTfscB4huyYRUlNCAvZBtCwHg+v+8fJJZ8vKRfC1+eNMO0SPeDIs4o1JW5MH456lrlKcLkRUxVcJsTe0K9Bnxpg2+Xmw5Sfwm2j7D8tpbGlWkL2uzQ9q64F/RLQPy6beiKIX4OjXtQetOnu9p1DjvecFFTI+oqKdrKqVj/zIBM0LArRKGH3L3hVYdIWGVexzw8HxypvGQ89Ev4Q9Ylgi5cvJM6LB7R5TTzlHofJbKduqHgLH6a6XBzey5JYFwtdX3bXuyFIpKbTPP1lvK65NvdsEADGAMLRomCRv3ukS5MqoyOjmMlN4Tr4BMoqinjjkX8Rh61Z0CkwyCy2QWrWSB3fusqhQMrmeFaiRbDnQnN7N/zPSSWRwQW985sSOAhMifLfBGgovaSWU4ZmvnbhRymO4s3qjkkwKaVJgY0LhrrTmVMb0RWePjN/WOPPoIeFkBnc4t1y2Cbd2xZOdXhad3aW91omEJUgxFX0ZhhkHFMU9jqH9rES9pn0octznCDmXJZgbUYTWbOdG7NBPBDtHf6ULinF9c7xQ9/Nqf/+KcrAwSr1Hk/3Z0KOQDdIMkhcyn8uYNyftFBozTSxm0l0W1hhfOxYi+UAGk5ekSQuLX+sNR9eXp+gmzzdLEPTR4Jr4t+pdJH26r5bFt2GusCWUEjYglkhXZG3h6qhdkWKKbPZ0V3/e688xEhEI3z1
 JUCbYH8P
 dsbO10X4Q2C5emfIc4TgY19ttVLLiG32IiWoq7kjHayCjHoiXOhjggaznL8iu1OPTrtcdC6usr3ki7qjXSKm3RjcEyP48gNqWIt3J9r4EHmPrVY36vArgOZuwmrIuL2IrY07uyzS5hGSjmlRfasJh2gUCyt8IYuPJqv6ZeSwNxCfsYUYxjbT/IgVB5Q4ZbYOjlF19/+FZ7AaRQhwe9SsLTE8Jx9AFzekBWlpPOWQjqQE+CCxx6TkeQeg17jPHTo22MFTiyw2AnqXKb37iQuhOyumARJ0yTk+Wcy1MKGT4tCkKm//rSG9pz3jupRs8EJo/H6Eb9msq0hySbm/aUFa5ybr2Orofx8KDX5LeqVlP90D+QdSVTmB5bPR9NnNGXeEU5I7jIY2A0V8SUsLq1+LTR+J6KkoXfKxkkEm2A5V9XpZobWPolWzwrx9RAJ1VcvyfCppPj6+tScnCPIrJydPgaloS3wrxiXNOJBJdLA8QbUgNJswKtS7FQ2aR/dh2xAD/x3TmhFO6GkEWsSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 03:53:28PM +0200, Ard Biesheuvel wrote:
>From: Ard Biesheuvel <ardb@kernel.org>
>
>Wire up the existing support for the execmem ROX cache on arm64, so that
>it will be used for module .text and .init.text regions. This will be
>relied upon by a subsequent patch in order to allocate those regions
>from a single chunk of memory.
>

Until Mike lands his changes [1] on set_direct_map, enabling ROX_CACHE on  
ARM64 would cause a permission fault when the same part of the direct map is
used again (the RO flag is not properly stripped off after an execmem cache
clean).                                                                    
                                                                            
[1]: https://lore.kernel.org/all/20260823-execmem-set-vm-perms-v0-2-v2-0-b013a37d84b3@kernel.org/
                                                                            
Best regards,                                                              
Adrian  

