Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C5C606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 14:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VKutAHz3
Received: by kanga.kvack.org (Postfix)
	id F36186B05B6; Mon, 26 Oct 2026 10:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6F66B05B7; Mon, 26 Oct 2026 10:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE296B05B8; Mon, 26 Oct 2026 10:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B8D6D6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:45:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 44B2C1C2413
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:45:06 +0000 (UTC)
X-FDA: 85365049812.17.2438D22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 79650A0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:45:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKutAHz3;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793025904;
	b=UsOGNsvmNt/tllhdhLwsVD804J93IFwHpMBUpLX93G8bdRtyOBcNkbmnVsuCj018wvYIip
	oLJbBah2xaJzO+FPo9uSydD7zhyo068tdqre6PPrKqTb1kQWjsCjAwL6yczQHtOANM1HnN
	xzaWM7fWbpdOBbp6XWVIvuI8+LqJ37k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VKutAHz3;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793025904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FT1RdVZKFn+emuIq4wyVAsdeeZxKAtKJ3BuQVSeNiXM=;
	b=krns4QEl6OtlFjtWaJS6Dj1aa7hfZZca04qQ6lmZd0fzJaSuXGTYhlODsXNgVyzJAoZftb
	zr9OLRC9E2lDashpLlm4gA/9MdM/QQcCF1VjvKFENgIFEmFFDbOZtPhOKGP9YooE2ViYxo
	orHEvaQPboTOslo1j3pihkP6stzgd5s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5B5343914;
	Mon, 26 Oct 2026 14:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344B31F01829;
	Mon, 26 Oct 2026 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793025903;
	bh=FT1RdVZKFn+emuIq4wyVAsdeeZxKAtKJ3BuQVSeNiXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKutAHz3mI7cYrCfwND0ANbGs1pVOCiHmR1hqXLQ8nqksJZqgRcOL5Iesy9WQ5C+q
	 ri1OfR+RVSMTC8uY4CxZmbCaWqINlZJZ7LTg5r94rRde0PBEStAxV96r2oVCvzDhcC
	 +5pW9w02Uh9QI4HgkPy9ufqM6+jC1JcsjswnufEtI3HmhT6hkGvxQBj6tXGB81GA4T
	 vEPVVuHMS+5kDWYWsKhjhgw+2hILYm43edDkdTCvNid1Fyp+p7U5bOjSUtaMOaahy2
	 6fv6utu6SXRQpiFABFMsYycZ/hFSwmXTPgySiwEDS86x5od+1cK7TOwHq/ctKPAGHt
	 nkPdwHkZfhQoA==
From: SJ Park <sj@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: SJ Park <sj@kernel.org>,
	Aveline Noir <jm5905938@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] Docs/admin-guide/mm/damon/lru_sort: fix remaining grammar
Date: Mon, 26 Oct 2026 07:44:50 -0700
Message-ID: <20261026144451.150560-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <d054b7a2653a2ff3d419b689a50a53290c2cafbb.camel@mailbox.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 79650A0003
X-Stat-Signature: 1b47tygoe1qr5gt1x3h11itfm3xqh7j7
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793025904-666904
X-HE-Meta: U2FsdGVkX196C/kik+MPsRXJetMiLZ8TrngGUP+LlKkXLHA6GLlsQt6oq9Q65QVQVlqoK0pNW/+kdlEISd49jXhYMg03xtqo9M3y1nZmY2+0zvlDkodHSDTVprz4KIOKSrWB8f5ari5GsDnEGCSaUsR+B0l4ZwonpJvdxgL7QwOL890GkQqNAxp7gEY1UK8wexSnrYUXXKJBXSyKj2raJFWJY48MapflmpxFKZGsqbqr3LOGNNJ63vhm/0gaGDTjoqp44trcVDeiiBOopke5l/Zo7Ox6d7tAvHV/oMBCAhBQvubriSDmMB6SbjXQCb12Btq2ztMGgYjEMwPyZXTXoGpSFOd8NNANeRfWftAw697akAXVpCMckW2avhJwSk5WKRB7oSe67A8ZCNkR4xEJsZxdGS5yURxDYWkUFnCGBWQ0YQn78ZRFVYV+URH+jqP0A+ioVkKb3xd+55cu6fLXkF16skikwaI+oX7QdTyMLbMuHD2PkUJbCPm1ncATAiZ4LF/FqOFoqlYcVZ6iWjPOVXmj29sOHegUvmzgbhiC9KtUl0vqKlQLd7HDekYaHDDWRE7ZaxFHUittUIUBCqx+Mhq+aznOd/lU5rV8YeOVmdoXmrY+djeXLuK8mchcoEkiEZP81yAyZwUtb+pkx1QLOMlwxKenwhlnrqlxYA3AoM0H4v8EFVJTqVpFsPktfl2uLNSRen+4lYVbPGD9/D4CX3nrc4xjvsa/Rd708Bf7TaYDbB56LWVORM+MWo3VoAgFjT6uyeRRYIH+DOvZM70Mlw26dFNr4WJ8eWSqURnOXhX2lLIfKTr2vnc9ydtd5S1BuyjHIDeKoLBSHJJKm6q5WB7tgzo0DJLHpGPbqs5xsjLGmAvs8Ps3PY5FaFlh9P6BqET5VM2QKpcNQ0Qe/Y7BzCPxkExP0CUTdgeJqTtFjk7b5Ma/Y9qzFI75TJUaVWNqTLMDizPHSpnI//Bx59b
 fb+KbZo9
 iOJ9/9u/GmkUEZeWbhFDkpGLwEsM7RE6BWaUqhS+sMpvPrtqEd/FG4Y0RoW+13YS/gO5e7RAjTjLbqT3cHpr3ZVo/QXJLIxCwlgd9A4j7TjAvq9SSMBAD1DUvcpc9dgIa9qUsbguKYShrQ3JjZUCZwGWPQ1aREaIBuH1PyDmqkzdNT9unW2OHzAtW0dWz3Dikb/CrVfY74I4S7Wl3IXF2LZh4KfmabzdXcya9D0lstzRF+PFQHChz4zueJAg4xJVDPq8+tudi6dXrzBNAvlwbV++p8Q1UczAdSneK34gPgh8rnPvCVbANTm97hJA0qUtpDFpAdPAOHSfcan8FBjyOwDkBOLDWDodbPYhhMjzPMD/aUwLOBPQsuX2FOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 26 Oct 2026 13:57:49 +0100 Manuel Ebner <manuelebnerli@mailbox.org> wrote:

> Hi again,
> 
> On Mon, 2026-10-26 at 22:14 +1100, Aveline Noir wrote:
> > Manuel's recent grammar fix for this file, now in damon/next, covered a
> > good part of it.  This should take care of the few mistakes that are
> > left, like "should automatically activated" and "Make DAMON_LRU_SORT
> > reads".  Rewrap where the lines got too long.
> > 
> > Signed-off-by: Aveline Noir <jm5905938@gmail.com>
> > ---
> >  .../admin-guide/mm/damon/lru_sort.rst         | 45 ++++++++++---------
> >  1 file changed, 23 insertions(+), 22 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
> > index aa4cc90ca57c..c628e3f6e587 100644
> > --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
> > +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
> > @@ -35,7 +35,7 @@ deprioritizing cold pages on their LRU-lists.  To avoid it consuming too much
> >  CPU for the prioritizations, a CPU time usage limit can be configured.  Under
> >  the limit, it prioritizes and deprioritizes more hot and cold pages first,
> >  respectively.  System administrators can also configure under what situation
> > -this scheme should automatically activated and deactivated with three memory
> > +this scheme should be automatically activated and deactivated with three memory
> 
> Yours isn't wrong but I would make it:
> +this scheme should automatically be activated and deactivated with three memory
> 
> Choose as you like.
> 
> >  pressure watermarks.
> >  
> >  Its default parameters for hotness/coldness thresholds and CPU quota limit are
> > @@ -55,7 +55,7 @@ DAMON_LRU_SORT utilizes module parameters.  That is, you can put
> >  ``damon_lru_sort.<parameter>=<value>`` on the kernel boot command line or write
> >  proper values to ``/sys/module/damon_lru_sort/parameters/<parameter>`` files.
> >  
> > -Below are the description of each parameter.
> > +Below is the description of each parameter.
> 
> My choice : 
> +Below are the descriptions of each parameter.
> 
> 
> >  ...
> Looks good to me.
> 
> > 
> >  --------------------
> > @@ -310,7 +311,7 @@ Total bytes of hot memory regions that were successfully LRU-sorted.
> >  nr_hot_quota_exceeds
> >  --------------------
> >  
> > -Number of times that the time quota limit for hot regions have exceeded.
> > +Number of times that the time quota limit for hot regions has been exceeded.
> 
> I would go for this, but I'm not sure:
> +Number of times that the time quota limit for hot regions have been exceeded.
> 
> Number of times that ... have been exceeded.

I have no strong opinion.  Aveline, let me know if you have some.

> 
> Thanks,
> Reviewed-by: Manuel Ebner <manuelebnerli@mailbox.org>

Thank you for review, Manuel.


Thanks,
SJ

[...]

