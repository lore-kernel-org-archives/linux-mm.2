Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39109CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFD76B0096; Mon, 28 Sep 2026 21:46:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5FD6B0098; Mon, 28 Sep 2026 21:46:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731406B0099; Mon, 28 Sep 2026 21:46:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED4F6B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:46:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C127CA689E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:46:49 +0000 (UTC)
X-FDA: 85265110938.22.6ED7C4B
Received: from o1.ptr9745.em.honeycomb.io (o1.ptr9745.em.honeycomb.io [149.72.141.136])
	by imf19.hostedemail.com (Postfix) with ESMTP id BAF741A0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:46:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=p2CzMLOt;
	spf=pass (imf19.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790646408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjr4nqeM7n36WuKKf5YXVh4Uzg4b73TbpTuDVtR5MvA=;
	b=CEj0hZl+YEyYzvR+MRToGxhO+heeAukV8yaL9tmMzjOdzLW5YbypC34kYOypXJPQ41S7vT
	7rjeb4DI482rKmKMrECCNWNH0Dg8khRTPf2HlP8BH+mTyYu6eP1vUumI0ENt/5HjXttbln
	S3JhTZZkkenyEBmGV5fKtVKX4vp5Ouc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=honeycomb.io header.s=s1 header.b=p2CzMLOt;
	spf=pass (imf19.hostedemail.com: domain of "bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io" designates 149.72.141.136 as permitted sender) smtp.mailfrom="bounces+3311449-c6d3-linux-mm=kvack.org@em.honeycomb.io";
	dmarc=pass (policy=quarantine) header.from=honeycomb.io
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790646408;
	b=sAwNl6+wMNwdLyxVXGNqIp4nryLeLrDBPAKRrM4/N2UgU1zoRZ3wpPZvbSnO+d5xRn0OqG
	v6mnUNM0sZ4aTeEtY1vTfTqiuzJ4KaRRscD5k2HRoPuftQRe5sAFBHPN+qzlV3STVLpL8j
	oq8cMK/yo8m5GOhQTHRFUG8rm947Bz4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=honeycomb.io;
	h=from:subject:date:in-reply-to:references:mime-version:to:cc:
	content-type:content-transfer-encoding:cc:content-type:date:from:subject:to;
	s=s1; t=1790646406;
	bh=mjr4nqeM7n36WuKKf5YXVh4Uzg4b73TbpTuDVtR5MvA=;
	b=p2CzMLOtjdg/qpxtKmM7R78US9WK0lqk4B6w77BnfxnpvQPI6PHJFP/yFMH3fzOtmjz3
	r+v2AYeujSWtCGbv4+QZiZgCTxrJSZvFw8B4Fl+NmTpzCcNgIY8hZ2uxFU6wReRb7Xn5Tn
	s/u0jL2i3JSfUyts2CQsrLqpiqVOjCLkkrMh1r/9c5ifQhXmhhHhkJtZiC8cwW7wVNB0On
	Oav7vbeo+jhq9FDTOzqCLiIwKNLprPjMuzVN/9D5XAXE/S/FT7l2yabA8TAmrLGulVLCi1
	96UV7Umv67n2ZCdbOFw4Z6IiWKQjmy3KY/jCjzUZLV0ajjl/k54t7C3Q5tnCIu2g==
Received: by recvd-7fcdd7bc5-f26mq with SMTP id recvd-7fcdd7bc5-f26mq-1-6ABB1886-1B
	2026-09-29 01:46:46.322011859 +0000 UTC m=+367138.101351504
Received: from daisy.dens.ffj.family (unknown)
	by geopod-ismtpd-9 (SG)
	with ESMTP
	id MYZBB6JWSTelCpJw5DSpOg
	Tue, 29 Sep 2026 01:46:46.242 +0000 (UTC)
From: Liz Fong-Jones <lizf@honeycomb.io>
Subject: Re: [PATCH v2] writeback: let foreign flushes reach dying cgwbs
Date: Tue, 29 Sep 2026 01:46:46 +0000 (UTC)
Message-ID: <20260929014645.1573059-1-lizf@honeycomb.io>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260928165612.dca65d7bacfc726508ad7d97@linux-foundation.org>
References: <20260928-wb-dying-cgwb-flush-v2-1-56b54cda74f2@honeycomb.io> <20260928165612.dca65d7bacfc726508ad7d97@linux-foundation.org>
MIME-Version: 1.0
X-SG-EID: 
 =?us-ascii?Q?u001=2ECuH7N2XAoeMR1zrzr=2F6NZrhli2vbKPOHff5fJuZuba6ZIE8QPyIf9mn4Y?=
 =?us-ascii?Q?ezqeFFjUkh=2FeROy4LtnO7KN9jZmeQJbctk8Zigb?=
 =?us-ascii?Q?dMZnAM7BOjV=2F4TujBzr6OZLUqLZ7PQGBGOW6AOa?=
 =?us-ascii?Q?h9EU14a5K=2FrXXhmznM5HiQkS06ohe9BHJzVlKsh?=
 =?us-ascii?Q?4N=2F6tD82QvwW35ETu85c1dWyo4RkTwO46s7gxVi?=
 =?us-ascii?Q?uW9CBN0FYyPzuTRQsBNeHg=3D?=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe
	<axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin
	<roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin
	<yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ian@honeycomb.io
X-Entity-ID: u001.GRlkmHQ+Ka/CKxmoC/CxTw==
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BAF741A0004
X-Rspam-User: 
X-Stat-Signature: rbucxhukz59s9rpu1g9i4yy5g63et6p5
X-HE-Tag: 1790646407-461969
X-HE-Meta: U2FsdGVkX19kw1Eyb97ptfD8p6yYeXCAiQVgQb8234s3Ul4/8d+EkjUmKIdgCuUeG5HiL4LFl33mvaxG9NzDEqQ5M1zs1ug7G2owDufwJK+OU7NZWkYM9lI284JbXw7hoZHFnJyVHx//lMdjRRX96SO+NGNlE737I4YA9aExfu9MtqPDd5/Y6HmVpJirskLVAXa2fyGd3gVBo5xgVXzL8BlIFhV454vqlYrJIWyMbgoLkhIVprpHFG4yLs8xi9twa1yNEFpxpQbFtTbR0BiJBKrq3afDsoKuCZZXrBGNO3Z3Hr/LcsWLPr40SiTuGnHOQlfBOF23Cdq+V0h5RjCjIATxBaF0cqlD2vX92RXwG53rCWMPtLk5AUnfSOUjQKOoNetDXoBmgxWv6eeOL9d9A2s7vjOupLx/VFrgSmOrdo3YSZXpn4HbvhD5PsWipszF/snMjlJBRFik/dznj7H/n28TW+rYGZNM8Hv65oCP5KRy5+Qp9m+lZMh20WbwFCscDBBXQ4YpzgQLGiJ+7bFgSIdBfYvbbqSWEFelvCuOSriBNxJLnP2Ecu8beyhj4lfaJ4cQKx5XzvF2paADXQ0qd3uyFm46M/7YurMBtPuwW58xVQTezWRcbyXazrCohdsLNHJX3zXCLdOTkCOfzu4he/lv/gFatC01CtnaKqFAD5dHMd4kYSr8/ZpY/SIWlniB27OATJziV4V3p7pGENYb5nMD9bUOsrlOCcHhU4kQ+nFmBQAP8fZTndHAD2182SjAFSZHCLMXsC4xkTqwCEFPXFV2HgNqMYd21PEBK6qwIqL72FCKozpvURAZctqDq3IYls/DfhjXJTGDwN2I8iD2UgGuw4ALMXcL3rwTs2VmnkCkNELjcy4owUK/RzHWHhCM9bFfR/oTvF66Qv0FJR+R1DR6HUg6dPJs+nNsXzIbYKMw9GW3qfgxUyHc8mmTSkWzz7Z7l9qzd/MKe0nUTCb
 XS2MN+50
 1iYBj5kRHk3w/U6GrOysgkeqc8X4dDvxewBkC+/K0YAFJ/HITLX4NdCqso6kWi0hla9GENllaLwNg2cnNfzSmxaRtFv+5YX/Dw1jNMOMMvMwzxZDGm0okv3fIpudg3H1zYChOsU8TA844PAwGphiQnRZDXbLP+WytlZhw3I69QH2RDFxSuBuLyKUrF8wLsJ0KMou6uhV57dJQYSH/buPgnL7LvxhjGVVz7mbnVXxNM3iWv8c2BXo8bPOFr9w7ZNXBzf/pkwUELx/yGvWEZXmgJrX8O0fvxXZzdboiGO5++fztCCMOJ4RA3uhMQUNVHcV7CiItgVPzGfuigUy/6AOlGgkGUp1sduN5vhFfQcxuLXeS4wM9KyGiFQJwqexwNGSWHEL5V7mslghfRmVcCL0Idm+mpn+4Y9CWF4zq3VY1WrB2npyIPKrKbuSjWfXrr/EpW1kCc4BTcrtjm8epJutWNhBPjn3BrC6UiQcELM4FTJgMyCStVyBxd83DFXnv3jVV1tCo4T+o25bgSivRPgrotFWozk3YgdW0UXllk/i+s2FWQ+NF7jnAWbNRCwJ/a5eYkAKduIE9gxxlCLtLK6453VqI4fQfX9xPYcWt6/sauo8WEwT29+tt6YVnla5MWOqNKeIk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Mon, 28 Sep 2026 16:56:12 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> IMO the above two paragraphs are the most important part of the patch
> description yet they're in the throw-away section.  They should be right at
> the start of everything.  Thanks for at least including them - many do not.

Thank you, I'm honoured you took a look. You're right, and that's my
mistake: I was used to commit messages leading with what the patch does,
to help maintainers judge the risk, rather than why, to show the
benefit. v3 moves the problem and its trigger to the start of the
changelog:
https://lore.kernel.org/all/20260928-wb-dying-cgwb-flush-v3-0-e35374884667@honeycomb.io/

It might also help to say this in Documentation/process/coding-assistants.rst.
Its step 6 asks for "a detailed message describing the problem, the
solution and a Fixes tag". If it pointed to "Describe your problem" and
"Describe user-visible impact" in submitting-patches.rst, assistants
like the one I used would likely lead with the benefit on their own.

Thanks,
Liz

