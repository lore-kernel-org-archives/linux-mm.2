Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C039ACD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 12:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73286B0139; Sun, 31 May 2026 08:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E239D6B013A; Sun, 31 May 2026 08:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D129A6B013B; Sun, 31 May 2026 08:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB4636B0139
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:52:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 536AF8D136
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:52:44 +0000 (UTC)
X-FDA: 84827704248.09.0A034FC
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 812F014000A
	for <linux-mm@kvack.org>; Sun, 31 May 2026 12:52:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YzOtSeGo;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780231962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnMQ970O/37FDrK1Y36am7zIeSijQMUukVCUSJ3uyGk=;
	b=l/g1nEtzYmeoi1BlMZx5NNQvnGjiCZnDIc9GRsw0Crh2VoBKfGykLR3avg/0LJ5GO5yOvd
	wKn9Fjdf1blZbZOobAyS1BJT+LjD496hgV4fVGB2zGoJj3do6ji3UD7JIR2Z2Ah30vLlkk
	Ee/6peaIwb5xuUInO24HSs2P0gr7S1Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=YzOtSeGo;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780231962; a=rsa-sha256;
	cv=none;
	b=HOOQtUIxsQhbPd5QVGp2WVj+TInZBiz+1AIOMrHpujGTKTPxgiG//B2bJsHYNTpKFS88GW
	BSLz9ZqFzfdWAveKUQW926BTUw0PVMr74egw2T0J1/C9crFWWN8LXtxwv6xAaLbj7nt/BB
	PVVubGvg4DAUzsaIpJ40+BQRyQioIos=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-915336b83adso227572985a.2
        for <linux-mm@kvack.org>; Sun, 31 May 2026 05:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780231961; x=1780836761; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OnMQ970O/37FDrK1Y36am7zIeSijQMUukVCUSJ3uyGk=;
        b=YzOtSeGojoYwP7OCgAx1y6dfyMOqgWSED6zlbQRlPaMbv1vNZGcu0Dok5nnCTj2Wzd
         3lJ6SIDmNW60D0f4VIxpuiuWVOSQQp8Z5QZcULH8BWW9xBslgAItH4oJz/Ywxe7yunds
         4GWtfGmHnSDsoQQZrVa0WU9WD7BWRNpFX3oQi0IzoJYG8lT3oMcFIwL1SrJAg3XzmB2E
         11rssgtpoTEYQLwhjIw5sS8sW/iwPoL1GD1m3rOtyWj7HWmKKeAIQ5rmwnyBJUzIMurR
         QUz0PC1k4JV4cESB8+fmtkzPoYvsk9cAhLkWLSyamFrlPrWN6om9B/9lLt3Xi+o7hpA3
         WxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780231961; x=1780836761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OnMQ970O/37FDrK1Y36am7zIeSijQMUukVCUSJ3uyGk=;
        b=X0dm1mmB5Ylu9bMDiUDUvkZ/ud2YZ5PSYsDMnXGsvK/ZIOiFSaJgR0xU2UkWNq5edf
         JK4jN//Sh146wtLt7sNxAwzQ7MjJsZQkEfjMT/Vu9OowEtgwkLWknzp0LaXUCbrBva0u
         ELZkZSZiZDY7p/1R5hIcNZ0XllWX4NnmUwHnaXFbkSYSWnxtiSVTEmWtJ8YY4aXkdc+g
         H2Xjjmw4qKWjMLWv6382pab6VQORBoLRBaXVqzFHNAiv00GZxVzYUKhtw1A6+gYwhGHO
         p3olVkGzSywB8tnZUW/frcQUOHR/KQeIrQEHxYKTEx4MoBRLYnUs58mB8VrFdqdh0oso
         OV9g==
X-Forwarded-Encrypted: i=1; AFNElJ8QSgsRI1hdROGUHMFrLj76S+eej5qCJbVRf72hoFCzOp7c1W9JKaVd35qDmxpyfhnqJQImZnUTyw==@kvack.org
X-Gm-Message-State: AOJu0Ywut70B867yCVMkLFo9y1fawtWC/MPma9SHv/Lu5TurGMgOE5Bo
	+68HLAvq1roiYpVXyQzUrCqm/Rq2JMTQHsouX2CM9EXk4NSRf8caSLq891lYOA736aYjNLZWnKa
	9jiqX
X-Gm-Gg: Acq92OEuVoJ01ESCFHvP8SMeQ9eDU+yaKnS9/SeqBKbPMKoZURpcJbeZAnIgAL4oG5C
	zjwd0V1bSdQjEfFoVe4hxY8Lskhw6iG9VaqC+4cstiISgURB1JBUnq7uQVbggdVD2LoeteZXgc4
	4FnW/zc956rGi4gL+T8D1tXNz3cBiBpE53isAVTGnYrDmG4URjwiS9fNa4VIXW8UhV9EucrziBH
	U8cbzJOf38dBHCAr9BnhMe+y6AnS3yw9fcXuCd/mRN2YkgGfEM5/IhMmG+yfHVKKqY5jYWMnHyg
	VfP2wtSwN9tRsYDgl5eNKeLSEm6T25Fyh9p/Y0cc2V+XiMh5HJ1SM7NywwvyAI3dN/+jDzjU9+W
	AuGRIgNtN02p15Sh2vpQt1C7zMkQESdv4HPn0QZkQLumtX77S+lnYFuoobeQBOhWUB0B5ul6JwS
	Lg/WEiW21JJWzvDJ2/2Qy+BPL8pXC/IKsfWrcABIP9AggsHbtpSSwbE3k5suCKaw==
X-Received: by 2002:a05:620a:1792:b0:914:ca5f:bc59 with SMTP id af79cd13be357-9153db8be70mr1156444585a.62.1780231961592;
        Sun, 31 May 2026 05:52:41 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9153247515esm743332185a.13.2026.05.31.05.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2026 05:52:40 -0700 (PDT)
Date: Sun, 31 May 2026 12:52:39 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, skhan@linuxfoundation.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, corbet@lwn.net, 
	pasha.tatashin@soleen.com, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, skhawaja@google.com, graf@amazon.com
Subject: Re: [PATCH v4 02/13] liveupdate: avoid mixing cleanup guards with
 goto in luo_session_retrieve_fd
Message-ID: <ahwuA1tYmM0LZt0d@plex>
References: <20260530221938.115978-1-pasha.tatashin@soleen.com>
 <20260530221938.115978-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260530221938.115978-3-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: nzjecep63qu354dw5roaiccmu76ob7mk
X-Rspam-User: 
X-Rspamd-Queue-Id: 812F014000A
X-HE-Tag: 1780231962-229435
X-HE-Meta: U2FsdGVkX19ofDo/b6/egXm2L4H0uP4DSUaXHnGzaASxOWosdBcSmWcQz4Q1Lp+7AmISndUJM73gMZXndCcRRGLWqLKEd/DfTGJEbvV4JGDi8Lk+q/gKPb9kSI6QxBjpLgxSbtmbyYOweDAbzOD0rgd0We2RhwIYb6zTyXQYGD9LvGyPNvkAlBZspJK82GDUdFaJ4QkrvV7qzFH+o/8Z/uYjO2J/dQyYWHM0xNA/962wa9hkmS+3rsW0RqmfMOupjztq5WhuxtLlVP18dz2Bj1djEweJD+BZ5UEAgB+BUtqnsReh5z1wn/xnpejmrsEUrfs9wUcdhFDSBBNm8F+nK9bMYRvzcCkPLXK6qrrzsQV/Gc3Gkkfv/NzD2QJbIAp7Q65uVX4bDA4mEQnXLvCxuyrv7LYGSStJOTzan8SRUeZW+cPJL0KK2FtLQhkMiGo3B6cJMt892upNUJfiDdHaoLsOt8E9hDoq9HN6fd+n0yDzCK9Pa8rTN+hfPkTUCqCrwj3Xqs00lrnVO5soe+MU3nkVSx2tU/pdIxXL7SgM27x4UibGJ7BdN5oTz6448hO1oC95EFNjH/dFyxvn5HswZNSmIXWRplp2S88Ie9M1uNSSqvIcOInZC1CWyW6OVrVgTJSgmAnixcQQ9BNPPYIibtP92GutG18i45dAsTtZInV3zjIvBWUVW6JOqA9hFmJQ5bFBN7ri7XHoqcxeclcblB+io7CDX2LnwOwgT493YC+UexzSIBHNcLgOyPPrvq476fVv0C4Grg0JiUCdFakDkmHtqEN/9Zpij5OqFgWfsSWLSYU2SeSJYMzSE9ISdZx4LBqcSu9Pjkb6Rt00lDjkcn5n9dTOXiW/57Fr44flVqPkIcrkdj+x2IiJ5AzNkKyKc9lmXO7qicmAYVtg2xmFHRsC4Kkr0KSia7eb82/sG1z5fAYEzfkgsoAZtuWSn8GtxDesUl+/Y3X0TvWQXfa
 gBcQiXyh
 wNSqLu+wEuzjxf4muZfNEjf2A9Ak+/++eJ/GhEIIW6UeH/hj4AS8CBNF+fWWQ7l7mRExLgakHcuU/5rKyWam6vctIs+2iNLa8TBWDPncXn5GcmsRwVZlQDzg77Jh8FimhzRgyC8C6h8Jr+QMtImzRn+mUejB7YQn9UWIRV8XptqJaiP0UhxR6k1ZPm2B27H1uAGrNiZvyb47Gx7n0ItpdlmI2tZXbiNdq1848WDvjpLlsCEll0QJ0dvjq09dCJE7DQk5hVG/kmg1B9yBf0DFE/VmOgDUn3NqC3ZBEf4T8ZAbZkwXkr2IvjFJsXYhO3An8IKrO53HuNoRUJl6kBlwp8bl88evifHqZ+Zb8TOxD6v8I8lhiSF1ruYuE/JQC5uMLQPLlIohuU+7P8Bxhx0EFHmUjUsFTy7H0rKNH9G8HLzIDCreZIGHFCLemVFgvLLeoAT04MG4iDs4e10jvaa69gRgoRDwzssCM0qOvN60JoxBwsvTTTUK0mb7sOZYYmMHVL0llW0oc86+VYlL2KKv60NneNVW+9HK9wDO8DBs1OH+P69oPG7H1S7iE7fjUodMKVxxXy6glPQyE14g3gkNFdcoWPNHRxgBdZs2RHbh5I/+WSp0tOnZZdP2ukA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-30 22:19, Pasha Tatashin wrote:
> Refactoring luo_session_retrieve_fd() to avoid mixing automated
> cleanup-style guards with goto-based resource release, which is not
> recommended under the Linux kernel coding style.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/luo_session.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
> index 146414933977..8d9201c25412 100644
> --- a/kernel/liveupdate/luo_session.c
> +++ b/kernel/liveupdate/luo_session.c
> @@ -291,25 +291,24 @@ static int luo_session_retrieve_fd(struct luo_session *session,
>  	if (argp->fd < 0)
>  		return argp->fd;
>  
> -	guard(mutex)(&session->mutex);
> -	err = luo_retrieve_file(&session->file_set, argp->token, &file);
> -	if (err < 0)
> -		goto  err_put_fd;
> +	scoped_guard(mutex, &session->mutex) {
> +		err = luo_retrieve_file(&session->file_set, argp->token, &file);
> +		if (err < 0) {
> +			put_unused_fd(argp->fd);
> +			return err;
> +		}
> +	}
>  
>  	err = luo_ucmd_respond(ucmd, sizeof(*argp));
> -	if (err)
> -		goto err_put_file;
> +	if (err) {
> +		fput(file);
> +		put_unused_fd(argp->fd);
> +		return err;
> +	}
>  
>  	fd_install(argp->fd, file);

From Sashiko:
This is a pre-existing issue, but could this error path allow userspace
to hijack a recycled file descriptor?
...

Answer: No.

get_unused_fd_flags allocates an unused file descriptor (FD) that 
initially points to NULL. It is not associated with any "struct file"; 
this association occurs only during fd_install(), which is the final 
function called before returning to userspace.

>  
>  	return 0;
> -
> -err_put_file:
> -	fput(file);
> -err_put_fd:
> -	put_unused_fd(argp->fd);
> -
> -	return err;
>  }
>  
>  static int luo_session_finish(struct luo_session *session,
> -- 
> 2.53.0
> 

