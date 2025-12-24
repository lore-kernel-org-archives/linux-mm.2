Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2346E74916
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 12:10:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC346B008A; Wed, 24 Dec 2025 07:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159A46B008C; Wed, 24 Dec 2025 07:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03ABC6B0092; Wed, 24 Dec 2025 07:10:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E715D6B008A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:10:58 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7FBBD87FBA
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:10:58 +0000 (UTC)
X-FDA: 84254248596.25.F1FAE7C
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id AFBC2140007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:10:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eUskSE6Q;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766578256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amDWvZilcUNQCRnb9FMww/04o+Z50BC4wdV0XDGsTVQ=;
	b=4sCH2lqigphGSwZuvUzXQ2Fz7Iz2V4RKvNpZA5PdmLxQvlAGztl1hSHUfwg/C3eRZuxwHx
	Mx4FNpRFnsMylEuLiDyFH7kPJwwvAlp+I61bdbgTC7mwrPxiqU1H1cmH2eWfguWLTfWFt9
	i40q+azKWRnpLdDFjckRcKpF9ZnPHBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766578256; a=rsa-sha256;
	cv=none;
	b=VPo3trdTej3q5uezqgLnyFpTDdfYQ7GbV9resnyCu/qlHuZmu6lwYptByqfD9zHi2uIlfh
	6dSsUrVQfnpGbZ0cMgqjfUBhw4IcYstdc1CORPO6whgjXOfOV8oycIF/3xhf75fySDbVWq
	oNj+nk/QWUL8LPpMvyp9IxhgNhCOpPM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eUskSE6Q;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7b89c1ce9easo6722409b3a.2
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766578255; x=1767183055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=amDWvZilcUNQCRnb9FMww/04o+Z50BC4wdV0XDGsTVQ=;
        b=eUskSE6QqLhWKEgybU4/9kGVzlOR9AXo01aX3rmZPkoP9YABej1sBT7Gj/z8g7uXj2
         ZKk4ehD4Mht8CjIKSBXSDUo4J6igRplMvcs4dkm0dngA5X08vcxO91FpC6lq88XlhulY
         xpOpxc7gSXMXvCHB9enHGOBMOqEApQJpO28S/ftFIjb+QUd3MkH1bpArq4BJ6OA7XKho
         89zrrWEmwdCZQ/0D5y99io3MjP9fHKzZVAT4UVlCuL+0HU9dJEQw/SYfOhrL+0gzqAIm
         HvLi12RmbA0ZhHq2Aw1MjIfpz0Gp0DRQ2jEGDSAygSrxWBkOkAogu2UmuzGhoVWoAjhr
         TA8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766578255; x=1767183055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=amDWvZilcUNQCRnb9FMww/04o+Z50BC4wdV0XDGsTVQ=;
        b=r5FBUeRvZyFqNBWTzv7LJSiQqTCGkRnJomuMVp0qIJadIk5TO7x0QIBlRZltki7WKU
         +cfHI1+2Bo/FK4UzIFX52T2Pr6TzV3JWOBxqLDpM8ZJkW+ZvS+EKEtMCPMuUsP47xlHS
         Wjk4MYhZViJqqyQKxR0CLWPypf4LdGwRR+k9ro07beDlx9slcFAUdApX3msFRWtNrfhv
         VmP4N1RNmDe4QfZD+QWcf5wvo8Oq09XaszX/7N8CUIjhqf5/UNz7w8QxmaW8L9qFJK2f
         kliyXGdHBQaKv3eJFofRt1cYQciKKe8fVv/dDdiSrj+W6uRU2Wmg6sam8B3FHMh6ddf0
         aSAA==
X-Forwarded-Encrypted: i=1; AJvYcCWfUZmdaAkpq2g8/m3KK/v/ROt8HI1PTZ+Zpf79+AV+LASoQ7WckAk6VFMBnwYejfogpQFSRsdmww==@kvack.org
X-Gm-Message-State: AOJu0YyseGtrXWGEnJKQLOQj5GxCe0nzFAE4HxUz8/GmXSxM9kl7HjeI
	t8OGa7Nh7+gmpTZaXwaXtzK3JLOOjIFnMzwhTzUu0ab3dyShp6h8q/ol
X-Gm-Gg: AY/fxX7LL8TGlK7uhM4xNhRQSw0tn0/aSqh5Ho0KAD5zn5NLJR6bHMCWbFL65js4a6z
	GEFAtUn9b0KBJxCq+jKBjMdjliAD7RrwXZdPXtpbtoMynzn6L50MBAMto/rweONVq9lpWFI5mGa
	Rno5DKjbUXcAAUbx5GGdZENm1OsOdAhaVUC5vVJQgH402r9U/o7rjsx6t7/20kUffMCgHBgwreD
	y/RufV9pfpVfxM8nwdYz7sr5BKCdHhm3i5hGQ1y1TUcdQPSOlhXibII64d3PUEPijM4nJeacIe2
	GxEPHY9eXRNmW1s9Rzaqo3qtrqbdEjSjGYbJc/YJdDcOVZjMKy7n4gR4rr0BAu+DL1veggHZ2uz
	p8DMqis2AkWuDiFACy8T02cMRvjpwBRrxs7sGPD5WyA1eyPZUo0wRuJ0H8zqN887ScJMPqCkxez
	xq5+Q=
X-Google-Smtp-Source: AGHT+IGMW8f9KARCRCORQsU4PNhY2Xois2Gs10c6eZiOv5H3XYoy7LVCzNTRaQVZrN60Cq6oSWPrPw==
X-Received: by 2002:a05:6a00:a90e:b0:7e8:4471:ae79 with SMTP id d2e1a72fcca58-7ff68245f80mr14622236b3a.69.1766578255361;
        Wed, 24 Dec 2025 04:10:55 -0800 (PST)
Received: from localhost ([2a12:a304:100::105b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a1a2asm16666372b3a.41.2025.12.24.04.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 04:10:54 -0800 (PST)
Date: Wed, 24 Dec 2025 20:10:49 +0800
From: Jinchao Wang <wangjinchao600@gmail.com>
To: mathieu.desnoyers@efficios.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exec: do not call sched_mm_cid_after_execve() on exec
 fail
Message-ID: <aUvYMRmkWXUuuWXW@ndev>
References: <20251218032327.199721-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218032327.199721-1-wangjinchao600@gmail.com>
X-Stat-Signature: jm6nene8cn5ckua7rs91zz4x3nf8z38s
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFBC2140007
X-Rspam-User: 
X-HE-Tag: 1766578256-587186
X-HE-Meta: U2FsdGVkX18zneegVvF0AIWNG70SHR0EYkagzHi7GFlEcdAA8EsMmqaUsqhwrQu3MrIqbaNzUuZ4aApL2Wji+RRcj2AuwMsajUJgRe1wZdWZP/oAHzHeGNLPbSqpPCL48Jz/u/JWlAHQRON2ZRn317I1UPcK8UVdduWosh4nZwlyU9gIEJ+VoJALzJOh97RCgxKOvnKaxitBeUoJD26CPdKRFpJc7gX9PSJPj689co50lJN1hQ7y/H36bnP62zZzQx3Zzg0SaEz5jKQi0TkYYvN5bR3Is2cMWephl/AHZfxmHJLbrhBfCYQhM6UizzNMfutzNubqq7I3E1jfFv3BzSvgouk6waKSE9qUsbpgSfd5U8sTlwIn+fWnxQQuw63pPMsrO51vFDnMvvQoBQlf18JNNSp0hTvBdmotR7pwPNyBR9AC+NGPzi9CTHqwasFC9TVdsoNVTWLA7vXy4tq5GcBZW/E0kjh5QP8eLHQucj2CwDYBRb+zrt1JRHciS90hiHN3nWVyqZfK9SRhdEBIZXX7uIxZKmBfj9HFVy6GG9eiy1apIav0qX21Fp3Lb/Ac7y40ukr2gP1qbRzQYJxCks/0U8H3DEqICNrHsQCwfNPF2P6xqgbAqvU7vuxsA/PAW6sifXQsJezLJ26LIhVtwsYE5vpM9/K58SQ9aGBL8F6imukxHp6JIf3ydKVNVRhx1ECT7IwKmxexXBoGHwEnqtneRfLPT/pZXjxi1j4xIwOKBErhY+W3yyIGjtKpsaEoFFJIPZVPgWBNvZF099NSlMMvgcPlQ/esHzMGp9yEOUv76oFcabfr85a2inV3EW5qpq2/5xzlZeIGdOxcNIASTgr40SsqflLKqz2/pLKnzgXG3NMF+pCPEaZvJ1b74/ctPvelHX8ZTU8hHXOnsU1EGwRvBihdOQdGE6Pz/Ly99FB4hfRrdZLZcRpa+IGQM8vvyRKZ2cgopFcOCJlzsUn
 dhSq0D/2
 OmNDsucXyVxg6bOK7rbaaA8kK0PphoTh/HaG33jvBh+a5p8Ew8ZAeT72taCRh6+Fa+oDItF/vbc4yVEMXOLHQibA4SuM9Kk7912BRc0u5AXUgfAfAni8MIJa5/BEbjg/pdM/mjsDIeFPaAv7xZvVXuPGTcgCKQEj4jDFd77xVlUjrj0hh2CprHR5VhwIHYTtMUUh7zKpOR65rfZgTrdAlemx8vJOo0tTs7vteehTDCmJhBGe3Ht0egOLNFMcIITtmZ47FrJtgqkVLIZpv+8vdMPexbSsberN2YrulEpuVFnJcPVAgGMue97WfcRE3y7U9YP1hh7y5wmVGI81dN8ZfjAZqCSENUfryNT38SJW3SJqXjpbX/Ba4QLB1ob+dXcOBe07Qx2DpJsc6f3nw+nYb1Dut4LNGgr6DtjW+OswrTl5KVfV4tEDQPb9yg/w0Bq6P4+eR0iauxNzNB8175xQhbFGuXw9qg5kPH3uTzdPixW7wZx+hX93aGLZJzy+Fi31nq+cAxjW90EgSKfyLpbv5fCC5O5n6tfg5mSYjmClXEnAefT7dojO2GJbUBOR2ZHDPHcgN+vLkZ0Cuhhjoxd56ri3pnGgHtWPFxsMS2UEW5SLibiSfxVKWdsYE3H1xrStWc7eGShyih5z2mQ0tmk7F7qbMBHIC5HkuGJcbwmDHy8Bfz9PVYICy9LAYX4BrzeklZoj3SBAlVdUhGdWbA8ou8L+cabXT5Ecgau2z3FLuqFiVvddWEOFaIZs682wfP96+tCzX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 11:23:23AM +0800, Jinchao Wang wrote:

Hi, mathieu

Please review this patch for mm_cid.

The syzbot test failure occurs because the syz-repro breaks the system
state, causing all user commands to fail. Actually the syz-rero can only
trigger a panic or error.

The broken system can be recovered by resetting binfmt_misc with:

echo 0 > /proc/sys/fs/binfmt_misc/status


Thanks.

Cc: mathieu.desnoyers@efficios.com
> sched_mm_cid_after_execve() is called from the failure path
> of bprm_execve(). At that point exec has not completed successfully,
> so updating the mm CID state is incorrect and can trigger a panic,
> as reported by syzbot.
> 
> Remove the call from the exec failure path.
> 
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+9ca2c6e6b098bf5ae60a@syzkaller.appspotmail.com
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  fs/exec.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 9d5ebc9d15b0..9044a75d26ab 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1773,7 +1773,6 @@ static int bprm_execve(struct linux_binprm *bprm)
>  	if (bprm->point_of_no_return && !fatal_signal_pending(current))
>  		force_fatal_sig(SIGSEGV);
>  
> -	sched_mm_cid_after_execve(current);
>  	rseq_force_update();
>  	current->in_execve = 0;
>  
> -- 
> 2.43.0
> 

