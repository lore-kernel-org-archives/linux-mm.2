Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206F8C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135436B009D; Tue,  7 Jul 2026 03:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D836B00AB; Tue,  7 Jul 2026 03:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04AFF6B00B2; Tue,  7 Jul 2026 03:24:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D63F16B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:24:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 630771C355D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:24:11 +0000 (UTC)
X-FDA: 84961141902.02.F12A12F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id CD5CE20008
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:24:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPerxWTj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIB+BapHUzxV/CmBubl0Ce2T16FkAn0tCi+DQMi1NGA=;
	b=u+U+y9cw4kTvbG9kfX5Mqg4lWVt3IUwH0eGIqVlvqHLW/CV8IQLLjrmbTETjgNcXdvCHIK
	2O12VOKTUKMRX+l53604r6hLI8U9YhxjUnnlBpnxQENPnfHazWJFF9XEN1MAtezq0JKWHS
	ABeuvZYVbDmxRlqbcutjPRHUkwk4ae4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPerxWTj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409049;
	b=rDJ8PGSmcg/9aKEjYlZF3k6qyLLPfgPChpqffUMnemyLcQKa5BOs6KgJfgE6qhR2uJ3bww
	+B++0myGVi4KJW18Y/e+T9/anwIHaTnpWuRtSkhVdgAqq5eh5HVG2cj7QtRaFX9W3q7gns
	s3ep6QsxJoyf7xvkmLKq8cVGwap9SwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34D78601DE;
	Tue,  7 Jul 2026 07:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F8E1F000E9;
	Tue,  7 Jul 2026 07:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783409048;
	bh=AIB+BapHUzxV/CmBubl0Ce2T16FkAn0tCi+DQMi1NGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HPerxWTj/wR/yz9KqR7BZ/IE74mbMjRVdfVb/Na/vo3crjk7v7RkPkkYTA7oAGN7l
	 5EKfl+gdyapyQpbNfITb611pxx3ENjIBTmAcaN26elsvf00r97h8TwXf3qZhw7+B0A
	 4T8+W93k0iBaAhuqFPoslEDKCs3dt36Wsm1rQwFLRKBQ+y3XZ1qGbmUBuEqlhKSZFu
	 U29dKQZ44cXhfda1viJ6wn/gnz9Gf59/RcUsVHEUCZFx0k/DwxPr3gqs4xVezR3mR8
	 o1NMhxcG45RFk+L8j94ly1pa9t9+uDj823pW4sqQjCJF8iFir+E5lvhr0zbwbWAFtC
	 Ca/kv4P02wFtw==
Date: Tue, 7 Jul 2026 08:23:57 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Linus Torvalds <torvalds@linuxfoundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Oleg Nesterov <oleg@redhat.com>, Peter Xu <peterx@redhat.com>, 
	vova tokarev <vladimirelitokarev@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: prevent registration of special VMAs
Message-ID: <akypf9pq8NCeZlMi@lucifer>
References: <ajOvwGs5xhnfBu-k@kernel.org>
 <41ef0dce-e973-4947-b5e3-150fdb07f1a6@kernel.org>
 <ajO4sLq2UBciSgOn@kernel.org>
 <dd2ae577-9b7d-4e40-81d0-fa9fcd7e0767@kernel.org>
 <ajO7yI541hphWRb8@kernel.org>
 <11bae87d-73e6-4946-a41f-c5542fb40b75@kernel.org>
 <akeJdxdZXAFb8XCr@lucifer>
 <ake3JZJPYHP-0N7n@kernel.org>
 <ake7PLwdHUHu4idi@lucifer>
 <20260705005124.307e2379ab03109e5f77bd1c@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260705005124.307e2379ab03109e5f77bd1c@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CD5CE20008
X-Stat-Signature: b9tawksmzdygghfr9b5f85w6pq1d3yed
X-HE-Tag: 1783409049-454573
X-HE-Meta: U2FsdGVkX1/R+I6QywhI5QWsKusd/Zdo23XCexeYMcSoffzgADuscObY3J8puTEh5hW639lEHe22gDDZj+e5DF8zAlGDmBWS9S4moOzXw6DOHeF8Tfazk+6Uc6sHxC5Z6eCcu5ndB3IRkacuQCsYvb/Xpxg12tHrM9LiyGGMKht+IBv0bPG/ww8JhfbQexs9bdUUqCcFSxthwiVB8d1Ag1pMVqHcFTBzv/pIlDEmmINHaWe3RMElrjlu7lGmcVkNjFejyvEUWRNIJaJXqlWIVKbVSxFN4U/gM4xoetIGO7VjO/V0giO3A2qzurwM7JaZJwgwJstSQEQNFV1kCv6lweKAs5UbKWsXqKB/0VRPV2TgxZYLQ5jYH4e6kh7d3GEMTCP6sEIEL3chwHcOWE/676HEnQDJrAjDbKIHAh6IDapG3f45qic1680bSkWuvFNcC/YhZplinZ3sDariUL4/1xIL2DEnWdNmaKFtSJJCHz2j2o1CcybqExn9JofOky+zn0uA6Mlw8q15lKVk2QrKxWsOF1Pw2dRFaj47nboMkwLrJORpdJ19JJl8W4i0SdBGMOtMWk4l94TFMpEMwRpaRk26s+Yn1+i38QyDAb0Z7tyaE7/LidkRs/KmKk9bmgGvdeG8q5JK+DJBN6iOfyisYvF4AiHoVYXfPgKy7Q+m7Q8tzve4uOQGxvoGnZqd5dvrPwgLLmDg8vGLRZJP6ISHhVnjF5LIwrxTYHyUKK20XwXk54dAKdDVMr49n1hiP7j9DpHeB4wnEP2UcU9ELXTZMqye/QEFiHf2eV4kCn6uWRgTsZ9UY9nqiHstVk8/guS/Ecjtkb2K3NCjz/UpBnUzxF57MRxjnzUR/mjMmQI2O6INY0HJsyYH1FYraLQl94x8JS+jnThmmQvX+NbqYk97/lucnFyjcQwdXmuWIQMZlETS7+exrK0Xdr7SfQVuCfQHnGRUmpyoT6/sOM98r4y
 iioCSOX6
 Q+A+kwuawvjiK/U+0jB7JWde+Xgq1BEjjGDiacE1iQZigtqItJFrJtBjLdlKP8Zki4DGdwg2v51A8iWhpU99G2HAC2ITioWBym0p/9sC7GNyNWnsUEuNEqt0/uVfOrXdEXjpJbqafU5dXCEi+E0k5jKRdMUAYpgjeONsy0rK6lk8pTHztdLApjL06WuSQJqUoH9C8ZanbOW1F1TY5Dm1xaOjdbx2C4NAuQtm7DxGDOpx2ZxRSBrYX4wz1HJjBnEsgshvwPawe0NFwxbFUqjQX1TJGJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 05, 2026 at 12:51:24AM -0700, Andrew Morton wrote:
> On Fri, 3 Jul 2026 14:38:56 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> > On Fri, Jul 03, 2026 at 04:20:37PM +0300, Mike Rapoport wrote:
> > > On Fri, Jul 03, 2026 at 11:11:14AM +0100, Lorenzo Stoakes wrote:
> > > > On Thu, Jun 18, 2026 at 11:37:10AM +0200, David Hildenbrand (Arm) wrote:
> > > > > > In a way that's an extra check for hugetlb, but it will work.
> > > > >
> > > > > My point would be that we exclude all special VMAs, except hugetlb (which is
> > > > > special but supported ... in its special way).
> > > >
> > > > Mike - you said you were respinning, it'd help my series if you respan the above
> > > > quickly so I could base my change on that :).
> > >
> > > I sent it already:
> > >
> > > https://lore.kernel.org/all/20260618095017.2553004-1-rppt@kernel.org
> > >
> > > and Andrew apparently ook it:
> > >
> > > https://lore.kernel.org/all/20260618183442.BBCD71F000E9@smtp.kernel.org
> >
> > It's not anywhere :)
> >
> > Andrew - did you take that thread as signal this should not go in?
> >
> > It should definitely go in. I will clean up the mess discussed there separately.
>
> Thanks, yes, I added it then hid it when Linus objected.  I'll unhide
> it now.

Thanks!

