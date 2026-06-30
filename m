Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384EEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:02:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FD56B00A6; Tue, 30 Jun 2026 19:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1056B00A8; Tue, 30 Jun 2026 19:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DFF6B00A9; Tue, 30 Jun 2026 19:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D75B46B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:02:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76B781A017B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:02:11 +0000 (UTC)
X-FDA: 84938104062.19.2B577B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A4BC28000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:02:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YX6u1Gd1;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782860529;
	b=CuHvqn1uWnxFIgQJ7gVnNqw6kVPMu+9Ar9Hskf4shq5O1hDWYFgIK/Y5UxTsN1VLZqIRoT
	ZkRcC192f1o+GmUUDMZVf8+oOZSj4GP2luPyasMaMSl6xo8NxNpXdizc1OjwTDcZ6bLQWr
	xZrT5mluMlCY0MAY9wqgweSosP8u0v4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782860529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzgBLJFQlQhHqV4QWecB48NgOHTUMuZPtVSuPWBMy+w=;
	b=PjrI/gWMKL6yuN70lGh1jCn0AxcQYK+Up2pP9RON3aoQ+Y5+qVuVlwBmsNnvfYHNbAuTjF
	CuuiYi0poDdDSISptNrvRQF1chge4xm4J3LQbKOxxkWUzKtQ8KJlHlhZ5h+qhxeNd6xYcs
	6UTFEUVOz+XliCTDBOnNgsII+ahIybA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YX6u1Gd1;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 082466001D;
	Tue, 30 Jun 2026 23:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF201F000E9;
	Tue, 30 Jun 2026 23:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782860528;
	bh=nzgBLJFQlQhHqV4QWecB48NgOHTUMuZPtVSuPWBMy+w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YX6u1Gd136+Ad4gA51fknftI2nAcS+KZGnpftdh0kBYHWxtljz5LONfJyynuJH1Er
	 r/01i2oz8KjJpIJQ3XCUiA+9Yo/R3BjLrdjm6F8iPW8fBAjGxi45e9NSn+j4no/dbd
	 eJStX7RHbkNwOEES82mHjPJq0t+wWyHbpGYBvyVk=
Date: Tue, 30 Jun 2026 16:02:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org, Rik van Riel <riel@surriel.com>, Jason
 Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 14/19] maple_tree: WARN_ON_ONCE when allocations fail
Message-Id: <20260630160208.b6d1e09d60c50c8fbb80e830@linux-foundation.org>
In-Reply-To: <20260630190843.3563858-15-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
	<20260630190843.3563858-15-liam@infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4BC28000E
X-Rspam-User: 
X-Stat-Signature: 57bzig3m91p9eef5hi4azchoibj73hm4
X-HE-Tag: 1782860529-54142
X-HE-Meta: U2FsdGVkX1+C/7cRWVmsyihZr3c3OrlFXclDVvtRi4Fac4pHb+kobe+bwWqWQqM6fUd7fUgWVSV9a1dknmNijOfrqPqpVT1frNew+ccqLd+7/vGSCM98ArBC2/ZKbE1gRFMyVqZOwaFAQNcvdydQAsJLbx0aA5pmLRnHp+7ttir646Loy4y7zrSrTsWhe/6Ve9URRwF7S0scm594iRYZ0k+KpSNtUed04KDHvfJ/MASE/1GIbbqOIOLNzce7cnUHgUdILiroDspCnUFoMduvGz3qPN4OCbLcI7JTdIOxrNCUk9rYHUE57iX9TfhZKMXz5b43uU0zQd3u/Nzyv+nHGw2T6TFwJm5QyiDcQXzeaquIgrysLSO7O6wvEP++jITsgaDdWqbwu1aZbYfTer6zDLy2yQlJwBjg2qzxSzueWO1koD7oMXXs4EVEfkabex7gJR+fmBdu9GdCVKQ8IkXJwZ+ofKhkuEnHzIX4cvn+J9Z5NstxAZzRj47KqgNcCeadZwMTSgCUdBx7B0X9/K3OUpc8yNmxwI4mo8MB5wqftNVOKk5XR6sSpvu08sU6kYpia6QfYb8NFLZi7qQ7gHfR+m2arL2PcByogQbWJK1N7c7LAfvEwcRLH5YZ4UnASXzUHfv316UQCYrBs6EmduYDenhnkyvTFqOauj9cknAIUKzbFwrQWNBMrOe8Q8VeGhde+AvJbhPMZLx8nkBp6P6AVxafxjR6yElg6QBDt4TL7iRj++CCTO1MPoU/fY7zmCDbvvqg190L3XlIU0Lk8HJkw6fXorEdYQtaHeVHi0JmQXulhYA6cTo/fR3/0YustW8KRoaqxIoyO/rb7FcNS0ejb1erUR6dwmZ5rihPt36TJDFXxOXqh9fDRyQRHrmGgDfoPiw0RruOihJXN22+d5BaZhBqkXb08PM3aafYiYQBD5PInOUja4w6oYBbrbBEp++ZDn2MpzpMwzViyO1I+e9
 SbwYXJwG
 jc+S8ktTc4EuHAdarNdkCFBXUwdvAYzAfWnugYpJ8ye3KIWt5rCmFqvkn0jBIP5cLuV6LUjizll6FedfvNavcibfs/RPYvaezElZKAnBxPAodtyP1ud6HKm4YGAMQ9XCEJE7jQCPyTvJ29XWJLm3j3rjaoQmm2nkk65EtnvhOft9gnaEWDs1C1j9+qtfUiZhMFrzZmWOE9kHI+F1zht74ZtTKhLi4MDyDtAT4H26pO3G3R1nZPe0sLK2AU7gx0fALXARa2Nn7T1j04/6kPw2R02UiCDrT5DZiXY+i9E8wsfUE7/9vSl7KOF+OwhHpqGUwEFxg1ZyLep23P8JNA9euc/Qjst8u5/S9DEjB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 30 Jun 2026 15:08:38 -0400 "Liam R. Howlett (Oracle)" <liam@infradead.org> wrote:

> Allocations should never fail in the circumstances that are expected to
> occur.  Add checks in the code to ensure the circumstances are correctly
> set up by the user and warn if they are not.
> 
> Also add a warning on failure to allocate, which should never happen.
> 
> ...
>
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5720,6 +5720,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>  	if (likely(mas->node != MA_ERROR(-ENOMEM)))
>  		return false;
>  
> +	/* Allocations can fail, don't do this. */
> +	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
> +		     mt_external_lock(mas->tree));
> +
>  	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
>  		mtree_unlock(mas->tree);
>  		mas_alloc_nodes(mas, gfp);
> @@ -5730,9 +5734,12 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
>  
>  	/*
>  	 * Return false on zero forward progress.  Partial allocations are kept
> -	 * so the retry path will attempt to get the rest.
> +	 * so the retry path will attempt to get the rest.  The failure should
> +	 * not happen as we try our best to reclaim.  The user would need an
> +	 * external lock with a non-blocking gfp in a low memory situation -
> +	 * which would have triggered the first warning in this function.
>  	 */
> -	if (!mas->sheaf && !mas->alloc)
> +	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
>  		return false;
>  

Can either of these warnings duplicate the effect of !__GFP_NOWARN?

