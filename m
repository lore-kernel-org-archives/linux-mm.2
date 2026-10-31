Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE4CA606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AdwdlbtO
Received: by kanga.kvack.org (Postfix)
	id E132F6B00EF; Sat, 31 Oct 2026 16:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC43F6B05B1; Sat, 31 Oct 2026 16:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA5D6B05B2; Sat, 31 Oct 2026 16:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4F786B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:13:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29DA7A0A34
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:13:31 +0000 (UTC)
X-FDA: 85384021422.27.344E99F
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42E46140007
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:13:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AdwdlbtO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793477609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ECtJrZ810nCPL/tA58/OGxY/aV7ZpN5NiiX8ilCDeYc=;
	b=mndmtg9fVjErry9w1lrPYiDMFutK2D0lo9JUg9Myq0Sni+ewQvFTmsO8x6kRnIKbsVUN75
	YXpERDWqWWCkFgdR07QcB71xdiLM3sRYQDhE6w34lhZMzN+/bqkvk0wwVfo2qnqZHVuhRc
	VkNGtPwH+fWefRIcC89muYgXoVMjMIg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AdwdlbtO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793477609;
	b=U/UScY2VXvkecYXY+lK/DE8M7ADw5OhPlR6HEE57QZh/9g+eA6/5kf38KxgGJVCAE4kyYe
	Rdz2HHoudp/TAlFZGYyOaAyZC4cGnIEA/qrm8eL9OKFUKKNnZ7BK0t8dI2agj0JYLP3tBz
	VQSduPdGGBBOOTSHjwWwoyfcZ2B7TKs=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2084d62cdso15853805e9.1
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 13:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793477608; x=1794082408; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ECtJrZ810nCPL/tA58/OGxY/aV7ZpN5NiiX8ilCDeYc=;
        b=AdwdlbtOrdIk4FO3lAVHzVwkWRrUcMwdp6LK8vTEtLwx7wr83qNOPDbd/bXnuR8Tjs
         dAUp7sef0LNyjBRrmmcnlxKBZR79wJ16gv+0zcD66g7SyNvEISdHTK/ny/P2jMNSnKFH
         /lcVjii7TaHqKNQ1IpQADiZAXC3UBzTr6B1m0ynHHJBa21WTdX/o3OfL65yR1kRI1IUA
         42oQjOZFKTijMxyKn/XVM4tsGZ5DucqmdHB2ZLUtn2uSCDV0QU6udJU0X7he/tiq0w9c
         VacYiFZiIx1wb4MI37YPDjyzqKW8mZA9yKA0YLAJqOXke7AZsG6F0D0UyMpdCFFtnp+3
         gD8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793477608; x=1794082408;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ECtJrZ810nCPL/tA58/OGxY/aV7ZpN5NiiX8ilCDeYc=;
        b=2tp1ybyI7k1+KwYYtUrNtUoHPSk/qk1gG7He3ziCiTmMSIhYYfsqx15WXo+R5v3ujk
         NY/xGnvAu3/R3VfZsVHtOg9iZboFxGRtwGLvYq5Khg1mAjKjNWgykD24K49G6G5gslw2
         l+9IVd4WB71DgZCu4eHgFDRo7cJzO0JIsMvQOoFyo0GKbr+Ed/zuuxci4PGEUMcyRJE7
         HeHs00LMt4iThfYq6kii8C3/Cu4OVXqQPv060S4Md+tNDAKum0ZfrlfSssPBuolT5fY6
         kO5BUIWdH45AIxpgaY4Wx1mXPFR+rdf/GB1ZPRLtT8dpgzRYgCyQR37gz7qzo5kGQuzS
         PnwA==
X-Gm-Message-State: AFq9FYJAm466CFE+xG2pXDnCu0aT9qQb/rWVW/IDQ5Hb+GGmcUfpohHh
	ikXQmiZOR5jYa5U7WdIAZSA8tdtSPYg0TvZ6wk228Jk4gpvig61PxHqX
X-Gm-Gg: AYBFou1gGpbgCE0TLz3txO/5NZCSdQBJGvUqFN4ZEIgDMVh/FCQHTxFc7AaeDZmfI8y
	k4M7o7BcjePIs1OUrlYjngxtsmyRHJq1ZEnic1NWTfyuutl5L3MKCf+XXdIbD2YYmmfsrBD384D
	Pa5fk/836iz4sNdK5v8m6QiPV+aRxFgbNegFxhHzwflb0swsuCfDXmnbjX1k+bPmVx/xu/6UVbP
	3deBsxBflCHWybHtH6cYRhhXMBJbrfs9b+E9ZKNYFDL7gYlxlw1lxhr/2EpMJKYtaCn4HzUGD1l
	xUjhXS25uQMXMqwWEYDJIbc1nUl0yGrmKB0XPp89p0sSBB5ay7xeo8k3fBf3bZp1DUdxMcgptdE
	jEWYtJG9Gf487u6CCCEDsd+iqTCTxdo6YVrcmEXAK/pDHes34KQnII0THbQOKGeJniBQQFxWPYR
	suIlN2es8U9+R06azHCNEgjE9uZI3j1VEEtHGUBbUAOvBj0k8aZVBUF7NXrQrjDTw9DGbVc4iD+
	+cqfhK6kOkI2osHf/L7O4EkXPSsPmyPhGcYCzk8f4/GXjtr+Ou/DRrbxpwwooc/Z7htZ2B2QWs8
	UXVJ6YXwO/tp4GJnbC5Um8L1
X-Received: by 2002:a05:600c:198c:b0:4a2:5ca:767f with SMTP id 5b1f17b1804b1-4ac151a9a36mr144521815e9.4.1793477607538;
        Sat, 31 Oct 2026 13:13:27 -0700 (PDT)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b8011csm11733605f8f.31.2026.10.31.13.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2026 13:13:26 -0700 (PDT)
Message-ID: <751f878c-1a2f-4fbe-a255-3520ffaa2f28@gmail.com>
Date: Sat, 31 Oct 2026 21:13:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: store the child's new uffd context in the
 wait queue entry
To: Tal Zussman <tz2294@columbia.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261031-uffd-fork-ctx-v1-1-a837fd576ffc@columbia.edu>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261031-uffd-fork-ctx-v1-1-a837fd576ffc@columbia.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 42E46140007
X-Rspam-User: 
X-Stat-Signature: cn9gj5f5qrsxfsmdiaboxwato9jtrjtt
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793477609-529795
X-HE-Meta: U2FsdGVkX1++WTQ57VsQ34O8TcRqgkMf6sPoNzYAObB+XFqS/BJK198ys9GYU9w+WcGCyQKXsn+gH6Gz0UOeVz1GpXHWe+Qc++nBEIz1AUDIhn96NNDKS7n5ui+gXpFHCBunG6beCtC69NsRYvrXzSvG1VE24a845nrUJ18TcL16Ti5VMc10CmwNzU4bH4cdEXV18w7HOqidPyERVpHkKBioeGX6OmnFqhtRC/OIB1ox7tc4cjKRbsUx5+e6Ihd+2UZufh1eOAOUVTisNSbNMRkKfXURxU06sr+X2kf18WgmpgL+m8udLyLYHH0Ox+C4nJt7Qpd+LY5/3b3TlixjAfbRHayYq5TW4fbGP4jOXqo3Zhtj6xN+mHn8TeLIfYHxYSchpbabS0WE82VK+JHi/3OT+TISPjUGv+EsPzZA2OSl1XNwZuH6+txkjmxEU2uic6hNz8eZIV5V1P3MoyTov3bdue7W2lq7aP8P8XZWhaWHbZIZGFstcg5dYHPnMEvpLK6FhBvN5MSpShtecknDMWJ2IYqJUD/N2XU3vy+ZxAqcoX52oE7t8dTR13N2C8d5sPppCSzM1/y9TkHpm/iqIR3VrQlwY+9hlYhYV08yH8gEh0yjBCplZiYdUMbUCG+mlt1I1DqhELunPR+1iE+EdpWAH6da/gqePuvHz63Jw8G+9zE+hlndnpAGYFF39odm/JkfpwkQQzKxRp0dh0qr1wdigihZUJUGxPb9XDQD6MUqvhO7LQtJE4kgafhsfUxQT3he7XyyN70G4W9iOqQKxkkm8IsAqBAToTpw861iBciLgSJiomfXKyQmJ+n5A5NNl5b3sKMd0CeuQg86i3teHdFK3jX5BA+B9Z27DIDnB9FJiSK+jFVgoBng4UP/fKFlvgtCFOylenlvHO38yWR9qN0F7bICMIrNXDvHV68n56mSmmpyeScQEEiBRBk+Iep5Rjb2G/JNeyiPYlAOJ1C
 Z4S8tgHb
 pj4srtEWXUpqc6ybA+CEvKjOPMzIx599XMB5QflfDfV50rfkAX+S99fHhiEP8UY+heMtQ1KMfedikJKjGoCaFrawTid2/wD3tPuymbtxSHat9PHCMQ9FFEVnGAxN6GX6Yg5k7CwjSrPbnMkFDVsrNy7QEBIXVdBDMnBUX2xaBzMY0bWmIK0PsmYcvtPxWWZmuS8lV83ea6dfhs66wVEwglc7LnlD3d4iCLj80ia6xeiU/Y2Gf2H/zeASwZ+MRfRBPKUhtsCRju8tGkswFsveYKgSy/YbYSmjeChpFhaRsyeQlWaq6oRRCg9wqTmBnSb9zWoXT2FznWVm/5bYjEv/ho2cDU2aFFKbWqEyM7trCcIIRNCSggfKC04Nrj1i2K0N2eO2QlFQZ4CSQOWmeeYTdYkq36Y8d9gDBngtzTSetxZHDjL3eWOC94GquLV/swgR8Z3W3d9poNpIWi78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/31/26 4:47 PM, Tal Zussman wrote:
> A UFFD_EVENT_FORK message cannot carry the child's fd when it is queued,
> because the fd has to be installed in the fd table of whichever task
> reads the event. The forking task has to hand the reader the new context
> itself. It does that by casting the child's userfaultfd_ctx pointer into
> the arg.reserved.reserved1 field of the UAPI struct uffd_msg, which the
> readers cast back.
> 
> That temporarily puts a kernel pointer in a struct that is copied to
> userspace, and results in ugly casts when passing the uffd context
> around. While resolve_userfault_fork() currently zeroes reserved1 before
> it is exposed to userspace, this unnecessarily risks leaking a kernel
> pointer to userspace if future modifications are buggy.
> 
> Store the fork_ctx pointer in struct userfaultfd_wait_queue instead,
> which is kernel-internal and passed around anyway. The casts and the
> zeroing go away, at the (negligible) cost of 8 more bytes on the
> stack.
> 
> No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/userfaultfd.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 3b71712edab4..cae70df89c00 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2430,6 +2430,8 @@ struct userfaultfd_wait_queue {
>  	struct uffd_msg msg;
>  	wait_queue_entry_t wq;
>  	struct userfaultfd_ctx *ctx;
> +	/* UFFD_EVENT_FORK: the context created for the child */
> +	struct userfaultfd_ctx *fork_ctx;
>  	bool waken;
>  };
>  
> @@ -3006,14 +3008,8 @@ static void userfaultfd_event_wait_completion(struct userfaultfd_ctx *ctx,
>  			 * didn't.
>  			 */
>  			__remove_wait_queue(&ctx->event_wqh, &ewq->wq);
> -			if (ewq->msg.event == UFFD_EVENT_FORK) {
> -				struct userfaultfd_ctx *new;
> -
> -				new = (struct userfaultfd_ctx *)
> -					(unsigned long)
> -					ewq->msg.arg.reserved.reserved1;
> -				release_new_ctx = new;
> -			}
> +			if (ewq->msg.event == UFFD_EVENT_FORK)
> +				release_new_ctx = ewq->fork_ctx;
>  			break;
>  		}
>  
> @@ -3111,7 +3107,7 @@ static void dup_fctx(struct userfaultfd_fork_ctx *fctx)
>  	msg_init(&ewq.msg);
>  
>  	ewq.msg.event = UFFD_EVENT_FORK;
> -	ewq.msg.arg.reserved.reserved1 = (unsigned long)fctx->new;
> +	ewq.fork_ctx = fctx->new;
>  
>  	userfaultfd_event_wait_completion(ctx, &ewq);
>  }
> @@ -3404,7 +3400,6 @@ static int resolve_userfault_fork(struct userfaultfd_ctx *new,
>  	if (fd < 0)
>  		return fd;
>  
> -	msg->arg.reserved.reserved1 = 0;
>  	msg->arg.fork.ufd = fd;
>  	return 0;
>  }
> @@ -3482,9 +3477,7 @@ static ssize_t userfaultfd_ctx_read(struct userfaultfd_ctx *ctx, int no_wait,
>  			*msg = uwq->msg;
>  
>  			if (uwq->msg.event == UFFD_EVENT_FORK) {
> -				fork_nctx = (struct userfaultfd_ctx *)
> -					(unsigned long)
> -					uwq->msg.arg.reserved.reserved1;
> +				fork_nctx = uwq->fork_ctx;
>  				list_move(&uwq->wq.entry, &fork_event);
>  				/*
>  				 * fork_nctx can be freed as soon as
> 
this LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

