Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AFDC531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 21:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921D86B0096; Sun, 26 Jul 2026 17:32:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9366B0098; Sun, 26 Jul 2026 17:32:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836E16B0099; Sun, 26 Jul 2026 17:32:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B3166B0096
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 17:32:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D30D8A05B1
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 21:32:04 +0000 (UTC)
X-FDA: 85032225768.20.AE208A9
Received: from ewsoutbound.kpnmail.nl (ewsoutbound.kpnmail.nl [195.121.94.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id A95B51C0003
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 21:32:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=IZ+YSbkD;
	spf=pass (imf21.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785101523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PkNII37eO6z0YhZ/U5eAl8Xy/QnR5k8d8xDGrIaXLVc=;
	b=sRBumpy9FyBfT8g6taPKZ8HKEz+jIQINRCegLqYUx44hj+v4C3K0Qmmbli9txqAURIwlv3
	Xo2I1KxHvYlbukvwBBk6OEQQ90UP8hkZ8LRvfc9EIVgojYxUO+95wb3mN6DDntuYy1l6h/
	kbaKx1xcb/VqkZ9dsCuuslj2HKIl8/8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=xs4all.nl header.s=xs4all01 header.b=IZ+YSbkD;
	spf=pass (imf21.hostedemail.com: domain of jkoolstra@xs4all.nl designates 195.121.94.184 as permitted sender) smtp.mailfrom=jkoolstra@xs4all.nl;
	dmarc=pass (policy=reject) header.from=xs4all.nl
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785101523;
	b=w3NBv8Udl8IJACtSn2XKdLms9/mQo/bUHnsH1/DCbM9VqEADSUHok+gR9M9EkZLNaLZpRd
	XAIP5RxDvOICq5MWKT9noqNmSE+xu02GdZSgYdHc9KZ0aQ/fjFxBvXlAdqrR1EYPCut6HU
	znsT8mS68Q+aR+n7R9+xSPyy2g70ssk=
X-KPN-MessageId: 6f7230c8-8939-11f1-a5a1-005056994fde
Received: from smtp.kpnmail.nl (unknown [10.31.155.8])
	by ewsoutbound.so.kpn.org (Halon) with ESMTPS
	id 6f7230c8-8939-11f1-a5a1-005056994fde;
	Sun, 26 Jul 2026 23:32:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xs4all.nl; s=xs4all01;
	h=content-type:mime-version:message-id:subject:to:from:date;
	bh=PkNII37eO6z0YhZ/U5eAl8Xy/QnR5k8d8xDGrIaXLVc=;
	b=IZ+YSbkDfUVGBYjZ5ffc99Rspi3hp9ZHSotxJqJvkLew3Qxd7tqw7GOynLdETTM5eyoIOqOvzSE6t
	 iV+ISRrMmPAhwx2hm05PCt+4KFp2dWqLoYmmDAXo6ja51rjsQg5hwRtsbBeCT+qlXd0PJ5S45hky+9
	 CRmQubnfsMP8R1XxQFMGBznJmcBwilBiGv+e81vj+5XC2vqmbyEkGTUJMMeHkeRPF4RKS81dzRmKDS
	 t19JQ+ixDDehP0EzvY/I7jL+hNMoyPmQdeXQU1RRMbP2Zf/i27PNJHDfHmgwVcHB4eFZesPrX1LzTV
	 8N5FTYd3pz2cldhi/fPbr411i/fHGkg==
X-KPN-MID: 33|ePywlr9eTYlMvTqTjSYxNkKt3vApC3vdIBki4AA3+u+ExLsBWIXRMRTdpybsUwv
 Er4RFTteCCX6Ix8ZETA1GgMsNFZsmUrKyn8urNLQhtzI=
X-KPN-VerifiedSender: Yes
X-CMASSUN: 33|REqvLpPbt3J1YoMQY/wV9jGu/6UaarOQDY78tgetYwDvcQ72xIyjW+u3bL59oK7
 zUBV2SbWd9YTASBjDo56e/w==
X-Originating-IP: 178.226.150.234
Received: from localhost (unknown [178.226.150.234])
	by smtp.xs4all.nl (Halon) with ESMTPSA
	id 6f2bd4b2-8939-11f1-8dd2-00505699d6e5;
	Sun, 26 Jul 2026 23:32:00 +0200 (CEST)
Date: Sun, 26 Jul 2026 23:31:54 +0200
From: Jori Koolstra <jkoolstra@xs4all.nl>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	Farid Zakaria <farid.m.zakaria@gmail.com>, jannh@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 01/24] binfmt_misc: restore write access when removing
 an entry
Message-ID: <amZ8tfX77B2ey4Hn@lt-jori.localdomain>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
 <20260710-work-binfmt_misc-locking-v3-1-a162f7cb58d6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-1-a162f7cb58d6@kernel.org>
X-Rspamd-Queue-Id: A95B51C0003
X-Rspam-User: 
X-Stat-Signature: qsndquwfsco5jz5oaeefi47mquma4t67
X-Rspamd-Server: rspam04
X-HE-Tag: 1785101522-763492
X-HE-Meta: U2FsdGVkX183Fnvbc4F3DwXrNduo2T5X+wYmomvp1HeDR5MUOYU1p6oHeNvn6a4y4LKC4zOTzPjBBt8vmLX+dL+I8f8S7YV61j4vUw/tZwZLJhXk1B/Vegpv9Mzal7NYiqWzYTCn4uwnX8hPZXXvq8uhpA/CPZfJi2eUGoFzjD5hHOn3nFssrl9Yx5i8grzgwHNQlxGLV6qI8ZBWX0hEHBrFwZfZSy0dm0k/QfI9e/ckL1jMGZx4lO6eYlNy4bDhpQFx43k5u3B3aTk8Gry1XSRl4zkO8Lwi0KgLi7LWkL60C/BQ+zYF1+Ozlr9Ust9TrAwBAIS4IRC6TpUjXKXWi+AYvKDUHftb6CX7RXVilnPMY+qr4li7uuijBHCQqBE9n2dfg83wB284a4aNFZvIG+kpTeRKADimIcULjpXIP4dQw22Y4L0sATVjG1GdVtTysYLyaMNI6jJ5Mt1GNmdCrH7hemsMUj1JBKT15h80nAsBwZRMBWeI69ikiySasncMtrzYW3BsCdntCU6ycjgMNfDFkxTwqq57Uee3UCmtQ+G7U51k2nZIq/FGYvNJTqNtY/Ty0bz/K+xMPiMdczWdqb5fEYr7kOkycBYz+LIOraFc9izEdgQAFx1C1u1zgSO0dmzhHoBOZj7lKBmYMMKcf77Tt/6EBHlIQ7nd/516hiyTxHlM++oAmD22MQoA7nJcoosK3PK4j74p4EZb6dGtPAcWO0KCQlShAT8WFqpVbJBcNLepc8vNvvX2UKotp6z236UlPsCD5S1qH6z41Lfbl0m4d3CaMBFYgEvRu0t8d4tuogBaw4N2jOKXDmXx12S98Dpn8riudyaztG6HCimtH3Voh9TNk1Le4KtzEJgNC6fwvlMafQr8mwihSgNhU7M8yPR9MNzWb8tzbhMBbiCtU7KyTps5KXudgg++Yau1K2KNDuSwW25Fb1RwtUt8nLrJcIiQTy8yL4HLMajNP04
 z8PTP2EU
 YEnNMa7/bw+lonxgdx1kzajguR7ueDAcBMtOdvt1Q7a7l5g72KLSURqOSFPzF2Tm3oeIrlSl7Ct0t1C15GUsGWhv/IYozBf0odFBBcfSMvot9oC1sF7Cj0Bsf7fMFW+spZrKP3D/ARYS15TyuQICaTH1uqAmTxbF19gW7pxxeawNkQk9y9yxAfNKaGtXQ5V32cGG7aFw/jrf/HHiZgsxkGLhjng9kNwhbrdnfoV+WvCFdsFEznZ366FAcXFobtTdZ/e86ka3+WJmDLGFYRrvXGi5O79ol2YWtm/xtRe//UtU8x7MTLI/bnSFOmH1+jNvdJz6SfXzW5FlhRUksvKkoeUtkt/hOZzdrgmovnd17mvahjW8E0DbAosyIzzwLM0J5b/yZ5+qLn/lXUKBBKJir+w1vmuxxDXw/VDiZ3erptJEhII73VeZ2vBD8N/JyoEeMp5jv4DYywAzU1+OYWVI6W65Kk2FoW3n38QBIaJ68eKkWs6kX4Lb4se0zZFns5wcx6lOy2PF2FcxQMop75d78YeTkmcmR3zSOJiIw3oKdwZzPIklgxtfJ4/bdTOYDDY6LRi17mkiGS0h7t7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:33:02AM +0200, Christian Brauner wrote:
> Registering an entry with the MISC_FMT_OPEN_FILE flag opens the
> interpreter via open_exec() which denies write access to it for as
> long as the entry exists. Removing the entry closes the interpreter
> file via filp_close() but never restores write access, leaving the
> inode's i_writecount permanently negative. Opening the interpreter
> for writing keeps failing with ETXTBSY long after the entry is gone
> until the inode is evicted from the inode cache.
> 
> Commit 90f601b497d7 ("binfmt_misc: restore write access before
> closing files opened by open_exec()") fixed the same imbalance in the
> error path of bm_register_write() but the actual removal path has
> been leaking the write denial since the introduction of the flag.
> 
> Restore write access in put_binfmt_handler() before closing the
> interpreter file.
> 
> Fixes: 948b701a607f ("binfmt_misc: add persistent opened binary handler for containers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  fs/binfmt_misc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index 84349fcb93f1..de50a7468b07 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -162,8 +162,10 @@ static Node *get_binfmt_handler(struct binfmt_misc *misc,
>  static void put_binfmt_handler(Node *e)
>  {
>  	if (refcount_dec_and_test(&e->users)) {
> -		if (e->flags & MISC_FMT_OPEN_FILE)
> +		if (e->flags & MISC_FMT_OPEN_FILE) {
> +			exe_file_allow_write_access(e->interp_file);
>  			filp_close(e->interp_file, NULL);
> +		}
>  		kfree(e);
>  	}
>  }
> 
> -- 
> 2.53.0
> 

Reviewed-by: Jori Koolstra <jkoolstra@xs4all.nl>

