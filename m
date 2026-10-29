Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F746606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p7KrGyiy
Received: by kanga.kvack.org (Postfix)
	id 6F0D76B00EF; Thu, 29 Oct 2026 02:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1956B05B1; Thu, 29 Oct 2026 02:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8FA6B05B2; Thu, 29 Oct 2026 02:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 339706B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:54:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC7D81A0314
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:54:08 +0000 (UTC)
X-FDA: 85374749376.25.D28C4D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id F1793A0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:54:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7KrGyiy;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793256847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nrt2MHmmyL0EGLrj5sKuJiNd3KbCufFNQHr5Yh2LzD0=;
	b=BSA56TFAsXuwWEwQdCA2b2j3CCvwpZlsqSkQO+7/nTpGbsAjivkK9zGBSwfm/Lcb0y2AQE
	zIDuIW3q3V0iWKgjhHYlo7+k2WtP9xKBWA2K9yL440ks0PgOBPWpVDWsYdL/exUPaT+LGJ
	a1h6bG8j+6NASxNy08+C934cz41psns=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p7KrGyiy;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793256847;
	b=4BJvIsaDUsBWz1wvnlmIvv484zk0mJj5IxaM5CDa6x9BwoDW6UpLffApPJ/reVJsQUi5jt
	CgOKLr1c6ZKakFWZHDuKcj80p+k+yqbXHWAqxSWPqNB+GQTiulwQJQg67qTFAGdu/ubvMt
	O9Ma7g+Ihv7s6WEqAhyQoxazr+tsvPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5218C43B5F;
	Thu, 29 Oct 2026 06:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28891F01825;
	Thu, 29 Oct 2026 06:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793256845;
	bh=Nrt2MHmmyL0EGLrj5sKuJiNd3KbCufFNQHr5Yh2LzD0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p7KrGyiyFbD9sM4Rlwusp5lHcU8a08mSX+AQ093gw0/dLPiWE0vPL4ZX2HX3RRCvv
	 6beyLoiZw1o2Uelx6CBDIt5rgfXwnQkEh0/V/ZjsSdFVSNDOTuQ4Hs4/44vpCy4smO
	 F3vs9lsyRx0CeZR/3tObC2FxvHNaZhdG82aANyJY=
Date: Wed, 28 Oct 2026 23:54:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mt4022@columbia.edu
Cc: Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org>, Oleg
 Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, tz2294@columbia.edu
Subject: Re: [PATCH] exit: use READ_ONCE() to read mm->owner
Message-Id: <20261028235404.2a24aa50c06556eaf77a033b@linux-foundation.org>
In-Reply-To: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
References: <20261027-kcsan-exit-v1-1-7c0429a29bc0@columbia.edu>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F1793A0002
X-Stat-Signature: ysc77kdk3ku35gqf3xbrgwea5pjsoywj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793256846-711359
X-HE-Meta: U2FsdGVkX19XntiyAjqb2whd2uAgjjKjpsRsArivP/dbCE8q+KP4m9DcnVpL64yEghJ0N+vz+Ly6WNmgnysUIXXNx3fBpTUHBRSOT8r2cAEHQsFvTLMisWU7QndxDfSXYhu+DQx9MQLvExAt0L+FELs7H3rAXAq681Iv03KGUhjIeuUZ6tIQnmHgA/8wwkyzEPgW+CG2SjsLzsvO1BapdMnyPaeqj8rdNj3A+xDduRCPwI2r+i7vLcCkbA5nyeQFWPqNjudF+G4Q83jYG/Kuzg5a2Iw/O/iYt4xsVCnGVmCENmnZ8K48q27NDhW5FU1w871kfZpFpeOMT+PlAF1Z7uFzNad3NQGFN5Lm0MjK1HvAhKRS6K3aH8QVMrflVGIuZAC3IfjHAWYguXv2tCZ+plBv6OnLkrhFmWlOPuSIQ6OokVrfwP4UB5dnSdmLom878M2UI/KMOQvOeRsv3gvfvtDkAQIWp/hG+bH8V7BMa74iHG+lsMWFjNcwJMep0cOh4sveKNVMfRmyUvenF2SJhBVPwpKBs56/J4Up9e368v1FZMt00O1neZ6wRGwYH8Siu8z/ei9cdKl8yV9PRYUcoQmMnM/wvD29hdOsKQf5g00t8JcUZAgqYu4Y7jMKGUz8Mw7clVsrVilolKUJqwB4h6YebS4pxaJ9et88l6eN5Ezv3AmEJ0k5rVJ1WaXL6rJ0OcfAiDdVsS2Y5Qv9dDy8v5Trd5Kq2q6LDyqgwVmUqe/kzvbMfoANV/dWIk7OYz3AGhDj06vCx1ppWAnF9CxE/+jY7KbeOiv4xvWIKSwUR/t9EOgnd1y0pwkzxg0LNWG7DKxPuqL3Sm4qLiEtkItm21CtUTPtgRd918Vbj5BptPzFseL+hwMhstRoWr3k9Yld+XR4bZzeeOhUqcmppEbzHchlZ6HoHj2VxxpmUiAD1iHpLi0p69s1LwpZ8x1H4hcwJ5jTjCl9CLDvdJhiYYN
 p2M4bVAK
 gNssPWXAWmxiqwYyHtIYRJDZac+av8DYF8ZQiDYR81PqJviQSvd83qqbA7jCEotVNNz4AKqRm64EnfHwz6tCnVc/Pf6JfV+ZzzE/MIOQb9cv1ZYsW/G10xaet+h5YnHYgttE1VtfbQK89+YOq01bLO9f7Gez+XHyB9TSGQ/QlG+HgrP6NYr6mczyc6xw4uZUpU/utdOE/Wg3dokILWaAMmlZKZWoMVKC0+w978DQlgUgzPU9cLC0el6AarWyfxPehK6JhMouuHuxgrQPBewRfBz4xIrHhs26tjY2Ufuytfm653z2AEUsM7V1LN7tzJo5ykNkRhcmxe/gTDywsQUPFlVunGoixkxu2nNbwMQtPSwKsuQNbbDXrH4CoKfEFgomeqDeXJPA9YVnOZx1WGBSL8PPFyN1Rdge+oEnf93UzSZdTSIbdIQ5VYpxWgUd0A8sfhcsn8dAJP2zUokU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 27 Oct 2026 16:09:23 -0400 Mani Tofigh via B4 Relay <devnull+mt4022.columbia.edu@kernel.org> wrote:

> mm->owner is written with WRITE_ONCE() when ownership moves to another
> task, but mm_update_next_owner() reads it with a plain load.  The race
> is expected, so read it with READ_ONCE() to match the writer.
> 
>   [   14.915975] BUG: KCSAN: data-race in mm_update_next_owner / try_to_set_owner
> 
>   [   14.916154] write (marked) to 0xff11000004471b80 of 8 bytes by task 71 on cpu 0:
>   [   14.916204]  try_to_set_owner+0x100/0x140
>   [   14.916302]  mm_update_next_owner+0x177/0x300
>   ...
> 
>   [   14.917246] read to 0xff11000004471b80 of 8 bytes by task 75 on cpu 1:
>   [   14.917293]  mm_update_next_owner+0x2a/0x300
>   [   14.917396]  do_exit+0x575/0x18b0
>   ...
> 
>   [   14.923906] value changed: 0xff1100002ec04180 -> 0xff1100002ed3a0c0
> 
> Found with KCSAN while fuzzing under a deterministic hypervisor that's
> currently under development.

We don't want older kernels doing this either, so I suggest

Fixes: cf475ad28ac3 ("cgroups: add an owner to the mm_struct")
Cc: <stable$vger.kernel.org>

