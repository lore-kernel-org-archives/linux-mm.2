Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 908A9606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 13:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=LTM9AkCn
Received: by kanga.kvack.org (Postfix)
	id 8B6E46B06BB; Fri, 13 Nov 2026 08:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88E916B06BC; Fri, 13 Nov 2026 08:03:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A46C6B06BE; Fri, 13 Nov 2026 08:03:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 531576B06BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:03:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 202E040336
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:03:16 +0000 (UTC)
X-FDA: 85430111592.05.301C80F
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf31.hostedemail.com (Postfix) with ESMTP id 68C512000C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:03:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=LTM9AkCn;
	spf=pass (imf31.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794574994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atdp2aydRKXMXDIBngPs3VoW6SW6B3JnVooZbiegGyo=;
	b=Aqy6uyHjkXTuC9Syy/R04bPXjcVZOokXzdVldCMbuOczx7mcDx6ur1fUoWW+FOsis96+c+
	1ynXSt7YClhumSNHbjP+abSTM/KDOqbW2bCaB56Ec8MYeqcHOwJD3R1KO7Cm14E/6S9W/S
	ZJWAX3QrIpqEOeXJe/XrcQZ0zywD2PI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794574994;
	b=eQ9RZDvuY5GPgYD2jqpPAkLj4MoUE1WGunf9YYeQpUUd8SKRvwfQsI4IdArslsgeD8yyD8
	3HireI0KpVzuUA7g71tRaHj9DvWcxtb4kQeZVy0wpsQACqf8kS3nqAU3QE0pn0uX6RhCIn
	0qmLtzj8xwUrhUy+SS2uFABMIylecjE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=LTM9AkCn;
	spf=pass (imf31.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=atdp2aydRKXMXDIBngPs3VoW6SW6B3JnVooZbiegGyo=; 
	b=LTM9AkCnC6t33+hNMotrxV1KakbzcP9xVuiib1rfU38aLSyOpkPkovxRZnCfqm0C9y8wd++cDSA
	r8x+EnfFoHib35KD7OiQp1BrxbkivMQ2nlJwwL1n/LdWXNr+S2dAh89CYxJ8HJx8UH2b8GFkwvUqg
	NeYZI2agHB926oPEhvyV2GvCAeP5Bzp4Ujfa8WvuSAuOszTI0LdHGf2OlFBlf+Y2l92wK5wV+qfpW
	OSwjjtJ/QpRqmXkob/PvIDtaoT8YqZsqurk5O1O0Gy1AvhxF6kxNs8KxHoyfCcv3zuMc80wpO+3DC
	RBufQeGqrwkPvaWEY4SVtpHLT699JvIPIhyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xRqvc-0000000EfC0-3U4A;
	Fri, 13 Nov 2026 21:02:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2026 21:02:52 +0800
Date: Fri, 13 Nov 2026 21:02:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH] mm: kvmalloc: Bail if called with soft or hard IRQs disabled
Message-ID: <avcKfEvln8_2a7fJ@gondor.apana.org.au>
References: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
 <auy-7TvVzJ-VCrG4@milan>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auy-7TvVzJ-VCrG4@milan>
X-Stat-Signature: gpdsz8df1bho5icr7eg8mxbj6mjiozzp
X-Rspamd-Queue-Id: 68C512000C
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794574993-166325
X-HE-Meta: U2FsdGVkX1/ye2djLKT7EH+N7rfivwHqu7I7sbP9Gkv7IrAq5mfWvuPeAJBTMuCjpLbRmi98tbR8pwCZFW9942Z+IdtPdEKHAM1oMTtkztn9gwHYYNixW3IcP+3TvoREwt8piwRl/5Pu2URvEqONCGOk/Jlz5AxYM2Aik8IeeM8Dlk/Dzb+kVKHLjzrEkKjCbS0ghsk3yhYujziAGx/uJkTjped1O1VcJDoKRlhzGijkx1WeRFiTouKDe0sYiGamokbOb7qO6Nr3eoxSDyQMf00ErjPeTt4tixSdCoHb9Wl00hAS4ZjDJEfsIfiEO31wWasnKxZ1E+a4zLEERnmuljzMSwxsfksUxmxbEvd/5K+jA4YHvYiOTpZtLFMs1/SxioFPExzRsa02R3LzJAZvshhIzfb+BKvH3EgZ0cndE6MKyDRKl+7aAr8FcShZ7viruLkQkjVsabciHuQRgifdgHgBdppS4g7hlnj6I8RiCiiVYXyD/qohl1CEqJ/3SZsGWiQUPPW+hUboRB/lKUVE7MPmvKD3wpi1JgeX+to/j2ttCr/zGfdTOdSe3ufvXxxF9tTP42gBYA+2BZ28nQHWv80h9xWTvyUsXGuqnHCqBIekYSmlualq5Iu3tHCrCZ9/fFUj4n0Lg2bDeOaNtfah/p3gKtoCGdvCLKBRJ0fNqmnWxPhNGph8rRRZzggFJWCgGKQqEqZs8BHiWYaEjiRoMybb3XSG35livGE5PGm4HcfUmVBd6ATRKWO5NJ/OXlkGiGnQoHXI8SAZxzMfJ+nk6zZf59qd4m/t51555kU9kmUgxXD7/Et/pD58DpCLMkPfFYWJKt/bkIp8ADlppaPeiFZWm8n2i2k5D6tj4gnvubDEhGrodwQPFJ475XbfqwKZgdb30Ve13PcviDv0ItW6jVICh99YYvFVZPKTN4r8o3jnIoTyPiM5/YvSTNMeYTaWBS5y7JBsoH+0/42GfYk
 6yknj9M9
 Y1yTMRK2aYvtM2JVe1eOrNaJ7s6qMmzPkatBu+qIuYDcqALkAIJOgH80qJmDwaiQWAMXKoz/zWkk5p7so574BwnLvsEOCz8H6IjYeCH97fvTBYjHkRJzNmJyugYCec8B6ow0wvmYhWNtbt2ULY5qCqjFHVEeoyXuMmAqzm1OdHDvTaaJgMVf2YKUe/MWHNv+qUfC5iexUCYrRWHFU2FngcT6Ye0vE3xLBPNsmDG1v48ZD6XxmX0KgPp0hgR8lUHgE5nCF5LpnBBwbOninGd6EIOozizgdbDNFlq/lv+eeZi9B2W3/DOTXuA4As+2iXYFfLO01B7nbUhzOXuAFyh6tMWuugYkeiaaxRyw95pfTaE0B2X0wbwZ/9+bYrvOWI5s4EibPym18Wb2PGXlAkxQxeV06njhV0TnxtdPYvMq3gwFIRPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 06:37:49PM +0100, Uladzislau Rezki wrote:
>
> Probably the simplest option is to return NULL for non-blocking vmalloc()
> allocations when BH are disabled. That would address the reported
> rhashtable deadlock.

OK let's try this patch:

---8<---
The function kvmalloc may call vmalloc under the hood even when
used with GFP_ATOMIC.  However, vmalloc uses naked spin locks so
it must not be called if the caller already holds spin locks that
can be used in hard or soft IRQ context.

Use the heuristic irqs_disabled() || in_softirq() to detect such
callers and prevent them from using vmalloc.

Reported-by: Liam R. Howlett (Google) <liam@infradead.org>
Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..18bc70f44e22 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7139,6 +7139,14 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
+	/*
+	 * vmalloc uses naked spin locks, so it must not be used if
+	 * the caller already holds a spin lock that can be used in
+	 * a soft or hard IRQ.  Use heuristics to detect this.
+	 */
+	if (irqs_disabled() || in_interrupt())
+		return NULL;
+
 	/* Don't even allow crazy sizes */
 	if (unlikely(size > INT_MAX)) {
 		WARN_ON_ONCE(!(flags & __GFP_NOWARN));
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

