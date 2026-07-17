Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51BFFC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 15:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 556156B0093; Fri, 17 Jul 2026 11:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D076B0095; Fri, 17 Jul 2026 11:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41CE66B0099; Fri, 17 Jul 2026 11:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E804D6B0095
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 11:57:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E20D1C0025
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:17:45 +0000 (UTC)
X-FDA: 84998623290.19.D65513A
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4404040005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:17:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=R3LVmMLk;
	spf=pass (imf12.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784301463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8HLQHxPCpbLm2MKNPLqrY3+EQ9+E1jrzcFBgC6A4ls=;
	b=8Rcqg+QkQbDH1pzXmEWOHaPdkxnLFKn36fZFNLcP+myN2BGAu3zaRMYqruJ0i2BQKhKivz
	pqtaSZe2Ij41eNV9SqZPJdfcGqKY6ZA+78+n0AcFz+0blegeGfb0mUxJPUzmYRQtoxDtNC
	ys0Mp1GTCXzWqWu8AQA5vpqwVcB8sj8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=R3LVmMLk;
	spf=pass (imf12.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.170 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784301463;
	b=cjfifa3UF8kdzqCzEjJQlBD1ofPg7lR9XPNBPLXjeJVu7rPEVTTRzVmrFSQCTGunhQKYo/
	CLV9v/SFdXYD6clPGsvmU/FGBNJ2oZHqKUgmmNgA/mRdu6vkMu9hYlVJJ12ZIaYqInKctk
	tJuXTSm6JkNbck1RMjAzQsu2QIbCw6c=
X-KPN-MessageId: a6dd896f-81f2-11f1-83b3-005056ab378f
Received: from smtp.kpnmail.nl (unknown [10.31.155.37])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id a6dd896f-81f2-11f1-83b3-005056ab378f;
	Fri, 17 Jul 2026 17:17:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=a8HLQHxPCpbLm2MKNPLqrY3+EQ9+E1jrzcFBgC6A4ls=;
	b=R3LVmMLk+I61ZwygW8mhNvtj02kJzxjqrIrjtmsWnsIa3wuFhDGculuYRMMOHGVaRP/SmeYswD/YO
	 tJ4I5tp5Lb4F6RKXaZe8m4gwNILOodXDayAfLipFqMon+EG5/58PFAoLoK6ATnC4bEtvP0aF2HWQvI
	 dNixdoWnJTa6AJVgnetikhFMBdSajnkCgrZFM/Iafv+BoddAWDvgJZAL3e6wdn342hAIwJOZTB7+l8
	 4/i1rCUWEYuum6WHHlewgF1mVbIe3nYazora5M6A8uvmhLOOGojjZjRgmzDlbso/YQnMMxa6+Tm51h
	 U5uaAw2x8QsZ+mObfAdeQaug5ZYqyZA==
X-KPN-MID: 33|BJ5gks8oQ8GvvVXN+LDYfxHKPIO3j4bE2nWZPbpnvpGV2TQGKcwYFW8ru918+L3
 uIkRLJux9vj2y6nnf2+B4mI6WSKXjvxNzRwrKVitsZeA=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|xO4ZtJFzH3SbHMvW4gTF0FS+AJ9qi4XIFY7Lk3s4cEGi3T/UQ3LpSvulZ7PLoZJ
 o2gJcdVaW2goBAMHeD3slNg==
X-Originating-IP: 85.144.169.142
Received: from localhost (142-169-144-85.ftth.glasoperator.nl [85.144.169.142])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id a6be1a71-81f2-11f1-920a-005056ab1411;
	Fri, 17 Jul 2026 17:17:40 +0200 (CEST)
Date: Fri, 17 Jul 2026 17:17:34 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
Subject: Re: [PATCH v3 18/24] binfmt_misc: simplify check_special_flags()
Message-ID: <alpCdI9_5j83xly6@lt-jori.localdomain>
Mail-Followup-To: Jori Koolstra <jkoolstra@xs4all.nl>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-18-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-18-a162f7cb58d6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4404040005
X-Stat-Signature: mzgbhxi3uq47te7zuyz9hog1oyza9t71
X-HE-Tag: 1784301463-137268
X-HE-Meta: U2FsdGVkX18TCRdIBxxAKRQ8BfP+NaVPiJJDrAoaDruqO3Ywk1dczS5QfHDXLovuavAg7tvPPYbpfsjYHKCAQmIIrGHJK/kIJsTGzQ5/z01ArEF+ja/2uEIAzMUmqRdX01NZ6HnvMtA3pLjbzste6a/eKEi1ZMNUDXbeQQccu4yfMlaqFrPMk18QJIzMRh4wzEP6Y4ZMC1DVgricbrXkgBTzAXodN4p07HYJhvLGTSDXTkxofBJI3vaNgB5F9OqvQJzBeKhanrW/WbOc9HKUdFD9JoQYQoob3cxa9zZqJpSBfKF1VfFy2oxDsDnME9A7/sCU/8awcXFHZWxPWriwtLD9NR7Bj9LDS7Vpbfzal3Zo1q1+mpSIIiAp2zhNYbH1U43APxHoa73X6SLLcsglO55YDUAeZTS6DHtCDjQO6/xQbFT0F6nlbbRqYLMDfLvPEQGd4qzH+nJFXXG6vs6wCQee853Lhb8Ua5aAHsjNfpj7w3P4cRqn9W/7ge2mzuBjOyK0esMzECVP2pblgV3pfHurE3lyyDdPj73jBSJkv2sRu/WUSSW5Mk4DpaVJY1HlX6OR6RprY8IDCTtS8TK28pqd6WOMVbA/+4sJQ2JCDkoRn5hwgwlgVjw1a+U1jXm+qv+F7i3TS2EK894u2JMTRLusflf4fxJhb71+UfwqzN82G8NYiB7YgmHwykGBSGMvZmbvsmMQssk24lg8Oh5gx9uMxsZwZgJHVHX1Tbpm3yYuKYf0iidM/Ytp0qECJVGLqbxYHmdpuHlUOf2ea6vwpaTozNf9k9E9QmkP5mC/Scf0x+IcybQlQcceKpAus6QpwcnxlsCZI5dPE7f+s3IJ6ddUx9qMJtSJoIVuusM8sIPXKy1bZxTDpmh14EPkzvmwvekwM88viIEtIw0qVM/tR6NuaEOVgE9rFzB5Rqw2BjF0zmOi0nUlk6VLOeZo1YejA/RyZoUD0qamz+Y1FvQ
 IrrHQayb
 4JC4ly8cU2l4WINgys27f43uCLBTtlP3AZWUGE2sAiQNzUiqmX2R1uw92orLemAOisJGlH5uTBmqMF/wc/QnUwWITyyvrzu5EiW6yrROg4WHAfbjzPDIrjIJbCNRkUHec/xPWuKG+0JB/nI7RDhNpZestn3HRqKXZPpKN4U4deH/YYIPv7IpiZCaR+oGUUgxq4CPyyIJagZwBnx4N2V8dzgVLwhBSMmjkxHtDQe5y93GRK9DQWelNDx2WWPkxbzqwwAnyMC0c5+4RYAV+f58W3lRwFG0WLcvTjo0qkZ0+wRjATn53hzvU1eARhuqXRXxa2JlxNzbH9DDEEXmIK/hwNEgPNU5amXigNBwCdtWW2rXFr8a7oxswRJCjBa2agrRuL1Oo1r2dX19PVIRHFWrECOrWK724wlxGgI7pouAtVXOo015/GIlQaIdamiPtVOZHytjw+FL2+omJCV6Kh93oZL+Tvmvh3ozyMvvlgq0KLjOWepB+1PIqarkqk8GtuLOAoCelKz1fOU1lisuzxgZFoxo1tLr1HuOKsQJuUghdVre1hrRMJD/ZT2O6Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:19AM +0200, Christian Brauner wrote:
> Replace the cont flag and the pointer increment repeated in every
> case with a for loop that returns from the default case, and shrink
> the multi-line 'C implies O' remark to one line.
> 
> No functional change.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 22 +++++-----------------
>  1 file changed, 5 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d6bc2abc4a7f..d9dc9546d199 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -309,43 +309,31 @@ static char *scanarg(char *s, char del)
>  	return s;
>  }
>  
> -static char *check_special_flags(char *sfs, struct binfmt_misc_entry *e)
> +static char *check_special_flags(char *p, struct binfmt_misc_entry *e)
>  {
> -	char *p = sfs;
> -	int cont = 1;
> -
> -	/* special flags */
> -	while (cont) {
> +	for (;; p++) {
>  		switch (*p) {
>  		case 'P':
>  			pr_debug("register: flag: P (preserve argv0)\n");
> -			p++;
>  			e->flags |= MISC_FMT_PRESERVE_ARGV0;
>  			break;
>  		case 'O':
>  			pr_debug("register: flag: O (open binary)\n");
> -			p++;
>  			e->flags |= MISC_FMT_OPEN_BINARY;
>  			break;
>  		case 'C':
>  			pr_debug("register: flag: C (preserve creds)\n");
> -			p++;
> -			/* this flags also implies the
> -			   open-binary flag */
> -			e->flags |= (MISC_FMT_CREDENTIALS |
> -					MISC_FMT_OPEN_BINARY);
> +			/* C implies O */
> +			e->flags |= MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY;
>  			break;
>  		case 'F':
>  			pr_debug("register: flag: F: open interpreter file now\n");
> -			p++;
>  			e->flags |= MISC_FMT_OPEN_FILE;
>  			break;
>  		default:
> -			cont = 0;
> +			return p;
>  		}
>  	}
> -
> -	return p;
>  }
>  
>  /*
> 
> -- 
> 2.53.0
> 

I really wish there would be a construction like

  static const unsigned int bm_special_flags[256] = {
        ['P'] = MISC_FMT_PRESERVE_ARGV0,
        ['O'] = MISC_FMT_OPEN_BINARY,
        ['C'] = MISC_FMT_CREDENTIALS | MISC_FMT_OPEN_BINARY, /* C implies O */
        ['F'] = MISC_FMT_OPEN_FILE,
  };

  static char *check_special_flags(char *p, Node *e)
  {
        for (; bm_special_flags[(unsigned char)*p]; p++) {
                pr_debug("register: flag: %c\n", *p);
                e->flags |= bm_special_flags[(unsigned char)*p];
        }
        return p;
  }

that would not waste as much .rodata. Actually, you could offset the
table and the memory argument would go away, but that is a bit
ridiculous for non-hot-path code...

Anyway:

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

