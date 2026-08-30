Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63081C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 03:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACB96B0088; Sat, 29 Aug 2026 23:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55DF46B008A; Sat, 29 Aug 2026 23:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F216B008C; Sat, 29 Aug 2026 23:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AB826B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:13:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E7B94023E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:13:14 +0000 (UTC)
X-FDA: 85156464708.30.AF961CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C92EC0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:13:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oLJ8t3tU;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788059592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hJJJOup+wIKIbKGSzexaljQV4pEOoVPh3Fa3fwUWmw=;
	b=ODK9c58SkzJVNUpXOb+KS1CTNJQGm9yQxWRb9KU2A3xD7Lk4fI40jZlg3wlU5YP2ghQXpg
	YXAydPI5g8RaA1MCpAwgZdhTeW7WL3kyYUqv6ESWR+GvYQv7Mh45fLCip+nSipaUeyZqho
	uZc++HM8ZSYnUmoictG1+QkhpiYLrEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788059592;
	b=TVXvnY3U0ZotWjlx5dmCdHa9D3MOXZjLPr6Z8UtMlMGIUwYV847B4GwafFoTkdql7h3k4o
	jOWoguN6kzB9QNL0pmUqNNRiRQ/GudiY+e7D2PVOA2Wo67Fv8nXlPWzB0wUF4SWahzROCR
	Jla2mJn2z4ECPpOh6j0R7PmgNMaWRyA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oLJ8t3tU;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9C06435F5;
	Sun, 30 Aug 2026 03:13:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5A51F000E9;
	Sun, 30 Aug 2026 03:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788059590;
	bh=4hJJJOup+wIKIbKGSzexaljQV4pEOoVPh3Fa3fwUWmw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=oLJ8t3tUEgYSbjbEH9J/2AuVNTaOnRHH7ymkB5tvYAspfhvx/Qzhbaryl4IEYOSg7
	 QvxmIT26hMnQD67CKvm9JDtBvRY1bkt3Lhr9Ky9SgIO3DA9uxx4FUnYkUYXgyPX05K
	 y0T+/a0ipoOAQnU5MyQwYFwjx+k/hFSdb+6dtIzE=
Date: Sat, 29 Aug 2026 20:13:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Ye Liu <liuye@kylinos.cn>, David
 Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH] mm/oom_kill, proc: replace magic number 1000 with
 OOM_SCORE_ADJ_MAX
Message-Id: <20260829201310.648ed330984b91b1c135d8a3@linux-foundation.org>
In-Reply-To: <20260811033609.3992348-1-ye.liu@linux.dev>
References: <20260811033609.3992348-1-ye.liu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hx6cqzuhisdubg58jb3e3au6zhjnr5th
X-Rspamd-Queue-Id: 9C92EC0004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788059592-6575
X-HE-Meta: U2FsdGVkX1+JWdw5LT98OCnXxTzG9XytqbmIuAE7UwsAv887+7UpBI589sBaBDWuQNfWLpb4d7ohdRpJ8vE13M3EUHIjDx4G7HlaZGJuiodpDPO2LnfDynsUnEr3y6r9jkohtugLL9txVMcNwWDxvnEHk3IeFZ82l9ZJQXsuA8AJqoy7f6ZxE9ma5YihX5z8ykvcUDSBJ6XKQXg5i8l+MYKD7bGzPHax/z+nnsGeL4tpcWgMud+/jZYnQ8TrdsmJFynI2OUHtVVhP5F4h/bsf5MRHsnuBNQtf5R61ELruA2kZohij1sz5zeaZ2kmSlRwd5gn49S4b7iK42iJLzPhVMUCvCFfUgF8A7wFGo6cRvxJ9ONHSsu1eJVKIGwF4TFTH4U7DFTZzlw07YOwOIHRwzbdIeE+LlyVpBkFRvw/96IK5Nywxy8PMJB8PTPvmbN8rk+OvNJWpZWykUtTb8lA7nAOUMwBgEF+39OGTtZaquGZ2Xw5ZyYKlxqAvYXZm+qWRubIEvizJNWGhqi4MyitW90gJdSwJLOSlN9hd/Qc1LcV4/FXnKoO/wQj2R69KzaRGm3nDZIIjM8AppXqt1GBrYsf5YhNeSyEVYGchkfCt156EVljyB9hivLbzWZCbAdQ4kxLIJ4oRwskZNTdqz+gylpIxsHSMBWjY0yr7J5l3eueuhaX98eIlVPTeDrhtaeKeqT0x0NpgQCeOkxKG4kAiu6C8aGoPg7a6W8FWKiqKsYv7CgE4v0kypCflY05P0p0Yyj4vPZ46v1G+g2f3reqKAV1DTBpKY6jHJMoFBqKoHqcdTI8Cm3EdpnReMljjOja/wpW5igFx/+ZmUhEK+NXtR1AqaF7/TLjYIZv9Q9e2fJ8LykYelfJ1e4iAs5cvo/VrsmU/IXJqn3D/9TBGyX9vJR0b3uthTWdeRx2p9Xack6sc2WTA+sy04zFd6ibZYpb4M0LWFtmGqzPIil96vN
 gu5ng1Sw
 SEJhNFgB12z+25TmbJ+5jYlkN8bfVhgjRAZomIllkqaOa1y0j95etJEjXsF79bzA/En3IM4kUZK968wvBam26XtTdK5cxToEysypqa37SMNZeA44cbwXHnChgxWT7iAe0Fji56ly28v8U2BkIaZB4MBe9Z6AI/HwE6BxOSc8llSmyS2LZGVsTSoDEiSgpSWdTLi+y4qnrI12yakm0uvWhZYt9L3s+B8qIdLE2J0HoE8Dh/k59DvpDlYfHGyrn4/OPk9IZnZNeoB/klxWu39Bl4OVDs59kdNMPXyEsRIpDUthYQ1BFylTeejsga+KB7AekO3S/YTyARvO8xG7Yk5msVmo0z6rdoidwoJgj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 11 Aug 2026 11:36:08 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> In oom_badness() and proc_oom_score(), the oom_score_adj normalization
> uses a hardcoded 1000, which is the value of OOM_SCORE_ADJ_MAX defined
> in include/uapi/linux/oom.h.  Other code in the kernel (e.g.
> fs/proc/base.c oom_adj handling) already uses OOM_SCORE_ADJ_MAX for
> the same purpose.
> 
> Replace the magic number with the macro for consistency and
> readability.  No functional change.
> 
> ...
>
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -594,7 +594,8 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
>  	 * exporting for a long time so userspace might depend on it.
>  	 */
>  	if (badness != LONG_MIN)
> -		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
> +		points = (OOM_SCORE_ADJ_MAX +
> +			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
>  
>  	seq_printf(m, "%lu\n", points);
>  
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..08bff7a55db8 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -230,7 +230,7 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
>  	task_unlock(p);
>  
>  	/* Normalize to oom_score_adj units */
> -	adj *= totalpages / 1000;
> +	adj *= totalpages / OOM_SCORE_ADJ_MAX;
>  	points += adj;
>  
>  	return points;

AI review suggests that this is a misinterpretation of "1000"?

	https://sashiko.dev/#/patchset/20260811033609.3992348-1-ye.liu@linux.dev

