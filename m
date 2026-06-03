Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A735BCD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CD1A6B008C; Wed,  3 Jun 2026 08:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A4206B0096; Wed,  3 Jun 2026 08:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1A16B0098; Wed,  3 Jun 2026 08:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22286B0096
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:05:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96AEE1A0370
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:05:48 +0000 (UTC)
X-FDA: 84838472376.17.284F6AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 05EDD140015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:05:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M8hQG6qN;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MM7RRVhqPTlxtMXqTYBOK1SOCNMNrDXSVM/K+K1p8a8=;
	b=36rz9MvFXtF6hXZfdyNqm/cZC2BMKR5CeF4Q6wvJ9WAGjBqsXDSJbUPLsTrCQrKZeo3dc1
	G/4iVibSOam9m1uw5DvTbvGWjPL1PjjsCQQeUNItbm+j/dwjoHZUoROPPZpAJuOwkXzjeG
	k5hEWgGsxfERduQ1E1lBspmUjegXguM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488347;
	b=7gCpGhYif2TCjFklAOp/cJbT1t5gQ1kmf+n7GrgROZ+6FgJ/CFZpZ7PWRyJ9vwtkn3Ayxl
	q0nbZrYlRyBbm6DbM/x2jEZdTpABAYY48JU85s8xyFlAJkgbC90RYjgEKy1u3gGW4Stiu1
	Umy2fUUwQ8IFl/VES8jkLuPKtYIoBvE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M8hQG6qN;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 58E316021C;
	Wed,  3 Jun 2026 12:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C11261F00893;
	Wed,  3 Jun 2026 12:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780488346;
	bh=MM7RRVhqPTlxtMXqTYBOK1SOCNMNrDXSVM/K+K1p8a8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M8hQG6qNHb2FtS6Sae/SBDvlIBvgHlYZqYB6AKsm1UIxVpiBTbQkJdVTOeuvJnKmZ
	 dOvXnU1M18/DYRL0FaS1GnNvxWMQVzb0t1poISDugfZHMhgW4IffllKTafTlgiOFch
	 5vxs7ML2Y4VSJGAzmSwbSCHO/OWFlQnqSD/4kEicJ/fwmIB4IO3C1AAVc57qWBimtz
	 gcoM3YG5nTPE/JyiDfy/jtwWoWdeM1iHboRxGnli7YzZPYWIXoVsFvtsPYKA+uVbWv
	 Xe9yryB0Q5c8pwecX/95qGTQUQZhRc+MceUAi2kp6LFLYzpUR+pqW4mNkOHoEKuXvh
	 zpy96EZI61jvA==
Date: Wed, 3 Jun 2026 13:05:39 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Chris Gellermann <christian.gellermann@codasip.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, david@kernel.org, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@suse.com, rppt@kernel.org, shuah@kernel.org, 
	surenb@google.com, vbabka@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] selftests/clone3: Fix wild pointer access of
 getline due to missing init
Message-ID: <aiAYQVaVGRLfmpAK@lucifer>
References: <20260526113409.ea65314eb1da831de7c90ca6@linux-foundation.org>
 <20260603104310.936706-1-christian.gellermann@codasip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260603104310.936706-1-christian.gellermann@codasip.com>
X-Rspamd-Queue-Id: 05EDD140015
X-Rspam-User: 
X-Stat-Signature: 1ygwfa6qrqy81py9kf86ok1jh5nc5iyk
X-Rspamd-Server: rspam08
X-HE-Tag: 1780488346-442806
X-HE-Meta: U2FsdGVkX1837qgD33jEP1Z4oco4svjTP0RsTBNFhuO28vk221Kzdqx795XVgKIkJn7fPgsSjbMmIlK4+XaR1Csk6WLuomMHQV6fVRRXQMUPL8UZ3lsDZmL0lSXCFrua4uvwFGtkhTC94CoItz0RnFUK4QmmvaG2GrC0f4bEIBUPEmJrb2PEhg+V9eWYJc7JpUEyA7ZMVvWAFydZniU7RzrP3OtstvbAedf4M3YMUk8PVLA+M9Oxrgn2UppwIpbHcPA0g4JnLqh6Wsnum+OdD2YFzgM+cOYum1q5uKW/+S484oJfmwegWUCyDPC39JQRZb5qSrxFQmzj+t7qsIpH4dF9OTNoE7EnNMvEvsjxJflZpwxn39BLz7/rhy/N/3aGrfzc1PhXlquSj5NIk/cEO/0Xmkf2exleLD0IA5cBZO+3XbfLOp3zT5sQiCjRTD8QofipnD7N4iy2X2iaa21dvZa9di+JZyW4A/O/NqHlxjyXemkDhqUDpIa3pkzSt3nDSRxXFiuzqfrTCP9ub44X7zG9ZVZlefxjtAaOfYh1Tpe6pq9YWe57lFk7sbQBp7GDUzZwKXviGFjU8VQo1tTeKAqE1tjYWQh3BIu2Xuw8djtbBStHoBoIg/iEx5SGM5bHBhrIQIQoaS/NfYc6NB2AGbqmE4AtYv4nFT6mAV0OPfpExiKxZoPOW4Mc8510SkyNI/LJ4VuM/CVNPNSF6wVDCqhwXSyqCwLlJUHDg3np+fV6WAa1S6DiQpXdNv48wcYa60fDuQEjGaYejjP727WrNLriq6vnhnyg3Hd9JkiDEjjFx1DbFyNni98QJb+JiUaUZzu8CQ2CPNvkggssM2AmG6/VGWgw3LKA+pASEWwcDRFdRJ4KcMd/cbWIlTrpRt3a727l2aYN3MybnkXQSNpnpxe6u98oYQIt3ZH1/D7bahKbD61f0UQbrQ0gBLM7y/+eLFNyt88Sga4r+8TXyJJ
 exzliUC6
 +yM7EWoiyKxFwNXim8vD3egNj+akBRM/jWnRRjq/j7emJy8nu7N7uFsI92hg4lok3D/RxCxCKX0EUPdjvtncyvmBYTrSZ5+f2w2VS6Xp6OYRXUSNl6eRxKeWLbpuhvIUzEagn81ymAg/N015RAlZ4FDRpATv0yQBbV+FS4U02Utejpo/u12SZI6F90Ojzti0JZU3nEpPV1jBlRhVquXNkDFE4EKFeSV1JtDvXieQfUONqrwkQjv4xQiBEpwyGvsqF3DttDHhf+K6LBdxgHX5yiafu7bjal3v+51U8LXx7GKOACqcJoVp3rYNrBdjdV/ezGr/LZWyQQ6UhOlMU+/2O70P/MhCgo6ogiUZ0xlPYVeadP37YbOylOaXtAN0CG2UpXnGFKIAT35rcdpDogTNOkCk7y4Z3QTnJbE4D6LI4IQRELuFb+bfRCnsvCycstYyhkqRSpDlNtslX/PIWT11e5d+LSDY1eDuFSlVs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hm you're combining 2 of my least favourite things in one :)

- Doing a >1 patch series with patch N+1 in-reply-to patch N
- Doing a vN+1 in reply to a vN series.

Just for future, please send series independent of each other not in reply to
other series, and if there's more than 1 patch, send a cover letter and have all
the patches reply to that!

Thanks, Lorenzo

On Wed, Jun 03, 2026 at 12:43:09PM +0200, Chris Gellermann wrote:
> Clone3_set_tid uses getline(&line, ...) in a loop to read the child's
> process status. The code expects that getline allocates the buffer for
> the line on the first loop iteration. According to the Open Group
> Spec[1], char *line has to be null pointer for this:
>
> > ssize_t getline(char **restrict lineptr, ...);
> > If *lineptr is a null pointer or if the object pointed to by *lineptr
> > is of insufficient size, an object shall be allocated as if by
> malloc()
> > or the object shall be reallocated as if by realloc()[...].
>
> However, char *line is only declared, leading to an undefined value
> that is potentially non-null. In an example run with Musl v1.2.6, the
> realloc call[2] of getdelim, which implements getline, triggers a
> segfault:
>
> ./run_kselftest.sh --test clone3:clone3_set_tid
> [ 1366.165898] kselftest: Running tests in clone3
> ...
> [ 1367.799244] clone3_set_tid[811]: unhandled signal 11 code 0x1 at
> 0x0000000000000000 in libc.so[68184,3fbf69f000+4c000]
> [ 1367.802808] CPU: 0 UID: 0 PID: 811 Comm: clone3_set_tid Not tainted
> ..
> [ 1367.804188]  epc: 0x0000003fbf6b0184
> [ 1367.804188]  ra : 0x0000003fbf6d4664
> [ 1367.804188]  sp : 0x0000003fce5f2e40
> [ 1367.805314]  gp : 0x0000002aaab0dfb8
> [ 1367.805314]  tp : 0x0000003fbf6f14a8
> [ 1367.805314]  t0 : 0x0000003fbf63d000
> ...
>
> Looking at the realloc implementation, Musl mallocs for a null pointer
> memory. But for a non-null pointer, it assumes it's passed a valid
> pointer to the heap and tries to access its meta-data. This leads to the
> segfault we see:
>
> void *realloc(void *p, size_t n)
> {
>         if (!p) return malloc(n);
>         if (size_overflows(n)) return 0;
>
>         struct meta *g = get_meta(p);
>         ...
> }
>
> Fix this by properly initializing the line pointer to NULL.
>
> [1] https://pubs.opengroup.org/onlinepubs/9799919799/functions/getline.html
> [2] https://git.musl-libc.org/cgit/musl/tree/src/stdio/getdelim.c#n38
>
> Fixes: 41585bbeeef9 ("selftests: add tests for clone3() with *set_tid")
> Cc: stable@vger.kernel.org
> Acked-by: David Hildenbrand (arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
> Signed-off-by: Chris Gellermann <christian.gellermann@codasip.com>
> ---
>  tools/testing/selftests/clone3/clone3_set_tid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/clone3/clone3_set_tid.c b/tools/testing/selftests/clone3/clone3_set_tid.c
> index 5c944aee6b41..485efa7c9eed 100644
> --- a/tools/testing/selftests/clone3/clone3_set_tid.c
> +++ b/tools/testing/selftests/clone3/clone3_set_tid.c
> @@ -141,7 +141,7 @@ int main(int argc, char *argv[])
>  {
>  	FILE *f;
>  	char buf;
> -	char *line;
> +	char *line = NULL;
>  	int status;
>  	int ret = -1;
>  	size_t len = 0;
> --
> 2.47.3
>

