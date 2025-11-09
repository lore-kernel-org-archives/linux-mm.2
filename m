Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37166CCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3C18E0003; Sun,  9 Nov 2025 14:05:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E642C8E0002; Sun,  9 Nov 2025 14:05:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79ED8E0003; Sun,  9 Nov 2025 14:05:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C99A28E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:05:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 377C71405E1
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:05:45 +0000 (UTC)
X-FDA: 84091997850.15.ACA4719
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 02A1116000C
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:05:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762715143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=twiix3CRu8dZe4Aq8InZW9fpI0QES7xrbjrO9gD+m+c=;
	b=FP+AuF0nUYwozlSpxmnExdhhtxtyMj1rGWcCkCags5Lqr3kJckEApOp1IZxHO4LqoXdS3j
	RKmtOlrQKOeH0IdZ44G8TCvt6u9fp94x/NZkqPIZdVFaxfEWXH9b00b5SPKCl/W6Zk2wxF
	++kBeYHZl8xoCWqAj0pTBqbtvl/hXCQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762715143; a=rsa-sha256;
	cv=none;
	b=JqrfnIwHiMOWl9WXroikupxq3PdmIc4tEsiH96RBfTLVsqFJ/4c1VVbWJaZiWjdGh+R+h+
	tZ9W9heE14fqmRiY1/GTDjXhsdsoTT7QMLqtqKjLvWQOhCYllnFioLmN96Uf1NNPY2hM6w
	eemD6Qm98UP1JLIibZZ+zh+fLmKVGJI=
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 4E0CC92009C; Sun,  9 Nov 2025 20:05:40 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 481C992009B;
	Sun,  9 Nov 2025 19:05:40 +0000 (GMT)
Date: Sun, 9 Nov 2025 19:05:40 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Alejandro Colomar <alx@kernel.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    Kees Cook <kees@kernel.org>, 
    Christopher Bazley <chris.bazley.wg14@gmail.com>, 
    Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
    Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Al Viro <viro@zeniv.linux.org.uk>, Alexander Potapenko <glider@google.com>, 
    Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 1/4] array_size.h: Add ARRAY_END()
In-Reply-To: <2cb4ddff93b3d3037ef8d094de94227982117f87.1762711279.git.alx@kernel.org>
Message-ID: <alpine.DEB.2.21.2511091903580.25436@angie.orcam.me.uk>
References: <cover.1758806023.git.alx@kernel.org> <cover.1762711279.git.alx@kernel.org> <2cb4ddff93b3d3037ef8d094de94227982117f87.1762711279.git.alx@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 02A1116000C
X-Stat-Signature: kwrjfumgiibq8t1d11ps6dsw7nt95ucg
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762715142-609405
X-HE-Meta: U2FsdGVkX18zcVqufox0ASCO+DR2lGTMaTvJRDBp10qXUXsCmo7iFQPOdAmdgFiCeHCNl0/ttaII5HOkUuCpx0QZmGHMqWGULZicKPXm0OLzekDYsxMrOotdEVK7YOQNu1OJDmQbR/gJbgp7D7fMYrI3oCc3iHg6ijDnnCJVYw/o9sCkRk7kzoJw8TeDQVZjGvAnQXfdxoSgQLyx4J6nG9VqpwwIuK9XuIzItA2YnvxMO/XAUXVdFLO6rySpmHOOyYvd5QgPHNPk1J7BMCiT7kly8zqDR1jZwmB58hYitv2JmQj/GsAc257zoDTYSlHJedSGstoRKbWfpSz+j0/F7r8lrw8K0QL28SBnCWCnKhoF74NM7yC741E1l7AHYVM9+E7J7IWONM3LARYIwUpDl5GHURltaIzxNNL8NL/gzYtVgxqvNUbyA2TY+WYecqOn9iawdX/qEQ3gUKE0UgkZ3KQr1sQZg/a/4UBDcIdLh+iodeIGAv8EUKgo1FjAfLodBFj5QOa215G0JdT2rWNPgotqebi3cjQb01hwErkm+pzwe020KpnDN/uzSK0lsqVAMMu5ao3JtzkgIhdFkrC3LBDvuDxVOZ8aWy4YWqpRv5LgKGshRlXGqfGF9BFO62PMML2IX4JP79BnJXHkxVkfjXxHEhIonRnSrzqckcaZa6ri2tyjfXA4wgVDT0TXrmUocPGqVdcZK9i5IO2S9VvEVVJtkv7qyT4FOv5eUKqHVRqCp2Yz3avmC8Sl2TvyPk4IBbitWGqQ0eTHt4GKDbHoPqZiNw0WwKHGwY1U0RDMyK94qI4XO5McTfbNVhAitW+Fke/YHaEwndirqCLKyz5cL9vDD5BROuBAMNyYtx+67wQT6rUIhBablNtfQR0jVtQL51j8rbNluxpQ+wzbhSqAZ8nJKcEJPGdBN9yfp/OTdCYia+EHez2DMtt4Gb6mKiE0DzTeKpOZ3b1qFSDRTTE
 g6hsQwr1
 E7e4JsxiAMjV89qtwtqIKq3frUy5duCT/m3fn6FYl9zhbe7keEebUOxnF9wBFpV9FSl6/OcBp+l8MTWcIJ3nbfOT3Bp5NvT+Z7X87WNy7/6B6Ml7sbrRwO8IxguQczVWRJWB4d+jP8t/m6hzQORLQLzo4xBAomdIGTl++RWqKH01ckk0aHZHFVQipwo+oYvCAYPuCKmojHYxeiGQ8PDVcuYr1eoIsyGwx55v6K9lbxteKtEeCopMO/7gR+bt4cl/ltuFg47F9I7vabHIxjvKhUCuVwg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 9 Nov 2025, Alejandro Colomar wrote:

> diff --git a/include/linux/array_size.h b/include/linux/array_size.h
> index 06d7d83196ca..b5775b8f13de 100644
> --- a/include/linux/array_size.h
> +++ b/include/linux/array_size.h
> @@ -10,4 +10,10 @@
>   */
>  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
>  
> +/**
> + * ARRAY_END - get a pointer to one past the last element in array @a
> + * @a: array
> + */
> +#define ARRAY_END(a)  (&(a)[ARRAY_SIZE(a)])

 Why `a' rather than `arr' as with the other macro?

  Maciej

