Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEADECD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:28:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC646B0088; Tue,  5 May 2026 11:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3606B0092; Tue,  5 May 2026 11:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2016A6B0093; Tue,  5 May 2026 11:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 140C06B0088
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:28:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE632140478
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:27:59 +0000 (UTC)
X-FDA: 84733746678.28.A50A8E4
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id E832B100005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:27:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jjYin6vL;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777994878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yub3mOGvWG3A9IM/tU0pZLVh4/23joC0/WvFOxpXwvg=;
	b=v1sVlV4YbkXwjb6looo1Yl4d+QCOIVW8uRnMA4KUgoXAJxiJnFjaXjiVszd+dn65clTKv2
	eOQtcxyKkskB7Z3k2rCC6ZK78WMpb+piFOSsSXfs5zGo8kZo6qj6lYzQzutStRto6PGNa9
	kv+4+Ja7yhMHf5713OXUB3CJMm8v0os=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777994878; a=rsa-sha256;
	cv=none;
	b=i1CehND3pnqtTt4/8fsosqD5/X2+000opTY3cIB28Fw7Gf12mnMxqiaAj7/f5hLZ6imKLw
	EoLs2d37hs/vVDdax7aWbQabrtee82a5PPzDetjwR1a5iFobGj+SgjkjhN06f+nJ63FBZP
	NmnT1YPl96yatpHt7oYLA2rVeKGh5pU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jjYin6vL;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8ef0ba61d46so610029785a.2
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777994877; x=1778599677; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yub3mOGvWG3A9IM/tU0pZLVh4/23joC0/WvFOxpXwvg=;
        b=jjYin6vLu4yyA/2PId5JZrST2wWFXnwD1Q57xyEvUW6y+7m1fefNxalXojgEEHzCOy
         p9ytjxPqD3q+TCq3/vGKwptrdDyhyAe2TME+vsgP9J32T0fw0bXsf1dxR1L8Tkxddo9y
         R+gvNG/YdzYFRsic8pmZ+P70fMItulDIKkSD1iYHf138LGU8JHwQH2tJqr4XThH+xEGM
         fBd4VfCm6trG6PdZUerP65PujeVqdQRm3q2SvbN6tHmYWj32yG9wQwbG8gUi5BM6Kf/I
         sCgzexHCCtwLQH+mRH821/XvtLXJ5nQ+h7r3vxDB/GXBceo60/7VZkp4RhacRJucx7YW
         gRVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777994877; x=1778599677;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yub3mOGvWG3A9IM/tU0pZLVh4/23joC0/WvFOxpXwvg=;
        b=qTFqDUrVKkb2X3E7qku6KnVt19I6pg9M2gf+rNjS1UOu9oDnWCJDWmpiTaSk6cvt6d
         hDNPtM3RRDFicmJ5bopcG30tpaK8jnrYs4lD3IxC5RO5ISq0WVeX4++y6MmIVKBAsQ4R
         CRuFad1h9KQKj/PiuSk+Oe5VbpMApmgvd9nsfKwWIFLB8KdTMXjXU5ROLA3UYM//lHMp
         AXer7wKkso7T0ELLmJKl6/KAV7x2t/ABMQ5S0QAFob8DBuOg0V1EwlUBYxHEOrSrKO87
         jb7j0YBbvNw8940eE3R7Ez6E6EyVeHRsrhx6n0CePmqrLgrmdJ3GSDjqJnuTZK3TAnuu
         aHYA==
X-Forwarded-Encrypted: i=1; AFNElJ+z90eAxWQ5j/wMyHhyHw0VMAyPuxloTywZjrTwqJOwM5vXYIQ83Uf3JqgEa77RMrQEOKeIkJ9wAQ==@kvack.org
X-Gm-Message-State: AOJu0YzlX5JbNcYyYaTVR3Llv27dYPgbs58KHc3z3XAhhcy7YQIFl2cL
	0ixaayRAbi/STumAs/W+UL/zSSxQSvTvSAJdTMJYBdgg0SnO5HlASfkVo6gY7lsFLDs=
X-Gm-Gg: AeBDiesul8Yh4naVKQq7WcJCS92WOpsUKo1KvFIOLXe1hor/hjAMx1IcWN+POc6ybN7
	fGDVWJ7Owe+01TVxPsJOcqwBZpkJtXo9OkDc+Wvf3FlqSp44L8ZJFu67DB0C3hadLMrt2xrcvLn
	hQhQ1DuCTrIB0q69vqeV32NED8kLHhGqvS+nIxXBfnp0choLO6q/27AM8JzvmCAyxId1i1Rnb7Z
	VKvi3VzRWjrdDVT+5faxF2d6g/c6FXn0bO5GAj3Q0mFqm/62fkjOs8ZciT71yHBvjzvCflEe0yn
	vBnAyo7g5r8VVv+E5k/vSljpVtZUl7tNpv8R816xNFcRITuAdyLj3DyCCPAt4ICVLyLQi0VuZ6b
	szk0NKANVN7xSArP63CqYcrwSKYlaEnDYOWfzzocUoy9Nm+SyFnm74uCdLr3haHPdRNTVDffsfw
	JpTXXExxFkJxzIE2rLZVTvB0GVU+saCMv1Pt/agTzB0CbnvlFI3+0VZfINb6810w==
X-Received: by 2002:a05:620a:4488:b0:8eb:d38d:2013 with SMTP id af79cd13be357-8fd164be8a1mr2145708085a.17.1777994876982;
        Tue, 05 May 2026 08:27:56 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2938e0b9sm1357740985a.9.2026.05.05.08.27.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 08:27:56 -0700 (PDT)
Date: Tue, 5 May 2026 15:27:55 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jeff Xu <jeffxu@google.com>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Brendan Jackman <jackmanb@google.com>, Greg Thelen <gthelen@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] memfd: deny writeable mappings when implying SEAL_WRITE
Message-ID: <afoMad-xL2bh0SZV@plex>
References: <20260505133922.797635-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505133922.797635-1-pratyush@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E832B100005
X-Rspam-User: 
X-Stat-Signature: ok58ybbmyyjsmt5gkpt91cmskm7mi9yw
X-HE-Tag: 1777994877-19458
X-HE-Meta: U2FsdGVkX1+A+fhdMxJ/u02gz+iBq5CY9j2o0Kmugx6hu3bQ3VjZMAN7ch6xNsPQKbHcuafvU59ehqFlDoMfeIcazdgi4kOS6Gg4EcB91PHrDQ0TkFNjQ0o1crtl4FU7bzLfzU/Vb9LbXTz4F2ms9zFuKee81P028alja3010gKPHimNXriXY1SrBOCH8Kaq+QnBxl7bdJGDqzPyTHv0/H+TH4dC7GI6+gWsR2GkdjIzFxgI+c5XlhlFdBy1411eP/PEMNDfGKxb/F91nymc3nUQDjFXL9EOecm2HLa2NBt7BEnlmxplOqF5AIK21HxlGcakJsL5dZdvh1ARiiz+LIG7pqVm1r0dDR2TnLs/KgDj5h/8Os2IPKmOrvP9NmNyYz8u7CcImafkM/pn+DQ4orgpl3IhVsN068oOiU1/3cUqJLa034VSYSmGftyuOrC05VmhsMOfJBgDo7emktP98SQijNFuPWNjjBBtOuoliqgfYdJFlhK8urYN4A4g/ppt7mL5MgGXP7KWlXrCChJ+1tl9W2KLoCLe5bKqOd5z1N0u6KznFAkcNcPKkcXpQ4mSlYDWusB7rVot8lcjZgqetY5GZnQrfoT0YaqVf1/jhta4+Lzo4A69KriTk4CEzpAjNCPKd7heOxsL4bOFEN/ZrFhw6DQ5CDtFRw5yuipRXYYcf+bEMb8iay7b80NFB61hQah+Pr+sivSpj7Jw+gMAHU8aNsengBFHKYxmN6g98xig3bOaqd/VPDEDHVP+56IMwqYDlbWANZg6zs62dg+BPAKj6ZWYaPPq7ckvdfjhGtfmEo9671LhQ4sU3gS7rI2UeaEBmiWgVEH0UZpPbnzhgExlLP/2oTUppzbEZmA+CppLMus7SoCcGJrvLG8hLyBD2sPx86fBahRftETgzNCiE4D6iCIVdE8yHvM6sc1KgSczMpi4d+M9Ecsx4eGkgaNDQ0RVuqbIU7trt6GtEhc
 RLb/GUdg
 ExvR0K9Z5R+OCdsU8N33363YoowmxsxQd2e1weRiEb1dxZmLaCYs8uRG7ECX2x3kkRd4qqdHGrfkLwboyOSRMdh/aUH1yX5b+GP5Y0HhpvIso4Q4uc15aIgGMZ7IzXsdf34cHeTJFcxE1B/cMzMbVddyZUlRwM4Q8KarxTIdtkPPlB89V3XXmBoz7MyLbsM2s+48saiJ8kPqNTAijPAjh0O7mR1E3FnhI5GyQbSE2airuynKBnSETEFRon/U7/UE3pcGuT/87KlC+J0+v3yBRHjBsmMqcpleI26n0PkQ4F5r+NCKseUCyXZNhgSnlRmydKYPW4DnlwPglLXgRnrbR/aHSAEY3JK0u0ty6gb81Q4sHz6WE58vY7XWotz/by3eOCjbi9drSRvqc8Ymz3Yz/gfR+AIzldio7Kd58gSEosZUn2v08RTOBWaGGcU6rJyTgx0sw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-05 15:39, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> When SEAL_EXEC is added, SEAL_WRITE is implied to make W^X. But the
> implied seal is set after the check that makes sure the memfd can not
> have any writable mappings. This means one can use SEAL_EXEC to apply
> SEAL_WRITE while having writeable mappings.
> 
> This breaks the contract that SEAL_WRITE provides and can be used by an
> attacker to pass a memfd that appears to be write sealed but can still
> be modified arbitrarily.
> 
> Fix this by adding the implied seals before the call for
> mapping_deny_writable() is done.
> 
> Fixes: c4f75bc8bd6b ("mm/memfd: add write seals when apply SEAL_EXEC to executable memfd")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

> ---
>  mm/memfd.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index fb425f4e315f..abe13b291ddc 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -283,6 +283,12 @@ int memfd_add_seals(struct file *file, unsigned int seals)
>  		goto unlock;
>  	}
>  
> +	/*
> +	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
> +	 */
> +	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
> +		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
> +
>  	if ((seals & F_SEAL_WRITE) && !(*file_seals & F_SEAL_WRITE)) {
>  		error = mapping_deny_writable(file->f_mapping);
>  		if (error)
> @@ -295,12 +301,6 @@ int memfd_add_seals(struct file *file, unsigned int seals)
>  		}
>  	}
>  
> -	/*
> -	 * SEAL_EXEC implies SEAL_WRITE, making W^X from the start.
> -	 */
> -	if (seals & F_SEAL_EXEC && inode->i_mode & 0111)
> -		seals |= F_SEAL_SHRINK|F_SEAL_GROW|F_SEAL_WRITE|F_SEAL_FUTURE_WRITE;
> -
>  	*file_seals |= seals;
>  	error = 0;
>  
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

