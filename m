Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7462CCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33466B009B; Fri, 15 May 2026 05:22:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B826B009E; Fri, 15 May 2026 05:22:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21436B009F; Fri, 15 May 2026 05:22:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A34946B009B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:22:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40DE81C1B17
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:22:18 +0000 (UTC)
X-FDA: 84769113156.08.000AE7F
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40ACB80008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:22:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mq6m5Gj5;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778836936;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SZB7dXJdMz2m27jS4oJrp4Xa0e7eQPlOm8RhL6/Zm48=;
	b=WmAW4r5dA0IhHUZN0Nf+HXwmaDBiNKDMXfxl7lh1IMMIvKWSyjkCbQyxvx31iSbxIOGysb
	3Y71IgxiFw//joDMk8F3OUJS3QdIP9RUroBuJB72uSTABtQ1kUmFXo2biV98Dfv+mJKjtw
	UNnbew7ceRU0RucqxsvcF3X4ZivYhiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778836936; a=rsa-sha256;
	cv=none;
	b=3ohJZQTT89z6Zar8XR4hTrI/yDV/t5K3I0nD07aotKnQ2nDhoNEq4jTqUn255e8V3uCG1c
	vqg2E9p4WSyWSXhRVzew9jNuZm+7LXMlxaASLowcWahVtNP6UVrbSdRCgGZizl6m04lwdY
	5eH9piZc9F550mSt8wbjx3jSlzO6K1I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Mq6m5Gj5;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bcda7765d64so120918766b.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 02:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778836935; x=1779441735; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SZB7dXJdMz2m27jS4oJrp4Xa0e7eQPlOm8RhL6/Zm48=;
        b=Mq6m5Gj5jPY+3inWGhi9A0hA+XkdB2bI5FPR0eMsTBXhkj/OiwzXMYD8n53QhIZAV8
         dSQHxyX70ZThw0n5QvVNwwLEI8YyVg5UfNywY2ZpduoodFuV/ykg2+LeK4iFMHybwJQ4
         f+pwEOxyQClOwmX8eZ6rz37coXb5C5TohNbJk2BrUatNKSIrNjWkQfBQEjiz7cEJfp4D
         xd7Uq0N+maI+IoZ/bvjSqLnQEB0OUNNd6hSqwCuIufNLJjJhOl+kVNhHTp0hfo9npS1t
         96rlMwOtey8E6mEYlwkI5aRKp3SFXCCh+6N+F/1Xb0ZB2nDVbTnWJjv2IxtF2E9I8ppn
         0hhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778836935; x=1779441735;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SZB7dXJdMz2m27jS4oJrp4Xa0e7eQPlOm8RhL6/Zm48=;
        b=Ef2Ook8nI28J2JpEzMdLwttr51E89CbwH/Dr2Ybv3Ci+PjCfBu7AQew+QNNcB49T2A
         6sLNDr+uRcGeSG5VsaL8spOLjlo5BmdHsATfR4IoqtMIQWF7FCbhJj4mxkA/c75pVXlM
         jUfgPO+I9xkzlCKq87c3EspeUpzJm8eFac1qpK7K1ecjSH9g3CiTci/vvJg1CGRnHrT/
         netaArA6jyCHwlscLLF+SZ6UAI0j8+RTFR9cz/Unau2Agu2D8GvX95IUt15vkxwJr++u
         Jh0qVCiwdkqCsg28+BP7BrlgGsIpOveRXTFV4s2ONP8x5ii5cn0LyOMH/6e4rk8P4k0D
         Gcng==
X-Forwarded-Encrypted: i=1; AFNElJ872GIanRsvWP4rluz9gW9LubNNOWbZsyQ2ysakHiuI5ZEP9QaWTCBL74ByObWoUsVeBxSHtm6Tzw==@kvack.org
X-Gm-Message-State: AOJu0YzwojUKwcuQBXkEOvGmwbaYHjMwzgvSarLpVIbMoIdevRFfuZr5
	Clt/hBg9NHXn0HNR7dBnIJTzaPIKkXQQfR70BVn93B7ASQ9DXo+ddD+t
X-Gm-Gg: Acq92OEWVishw4A07N7ZPypT2ilpNpDL47IUVI3Xn2CDHtnOmS1swT3qRR5PdJhiCWw
	AmFS4lK1Q368ln1hI+NvcVtdjC4nrMZcOrl0N8yXWC6t0fsF3pOfrN4Ym8N3Nc0I4136BLxcXUR
	fXxaDcImraHZqTB0oZVVsDgFuyNnQzWDGSspwNNzHzeCqUvGkAYbjQDML8+m2uuLTqA7U2OlQj1
	6/ibq0HPUhDuCCW4+LtFQT6M0R4hKPrTISFzKCKAXcFxuFHaT/QIoJSEfMAl82kgKthHNqO37wW
	ne9SYmeabDYxuK+WaQOGhny/JqTz0Yqk0/Cszpk5bVwpWqh8cfzCcBP72QhGgffxn5l2epz7AtU
	OghVw8ONYCLTWzHMm7iWJpE2cpfksAUEP9OUavIcRl3DwWpI/Ep70TlxYy/sN7h5F1ShDwXs+Iy
	iE2Xm1txeBiu4kZHjqbBnQDA==
X-Received: by 2002:a17:907:9614:b0:bd3:99fc:5610 with SMTP id a640c23a62f3a-bd4f3503c54mr412050166b.30.1778836934495;
        Fri, 15 May 2026 02:22:14 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-68311769040sm1743357a12.24.2026.05.15.02.22.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 May 2026 02:22:13 -0700 (PDT)
Date: Fri, 15 May 2026 09:22:11 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: check file initialization writes in
 split_huge_page_test
Message-ID: <20260515092211.qkmaxcofxwfdexld@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512074924.27721-1-agarwal.vineet2006@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 40ACB80008
X-Stat-Signature: 8yhj1jt39r98rb4i66pgofm9a834a63k
X-Rspam-User: 
X-HE-Tag: 1778836935-645753
X-HE-Meta: U2FsdGVkX199P40nMTK9qq0hif5dT9GWvtCIJ2QbMhmHAfylIYB6mi38gzSerRHCqnfyaqTzB8qql//FJ1Ze5O9z+xGpR526KNR8VhHk+Q6+/bsRSfcoDGJ0m0mEtQU+QbrkIaGe9cd29g82uwnRnHU+fuV9Fy3wqgfx4aCFnH3VPBKcKbeB3KiP/jGjMfMTbFkEgHYDigiqfl3+oLPPRzEcgloeUP+u85mlhrAPYJBPpoLkl/oyP/NFeLTqpbbE/XsBSIA4tFMxU5lqiyZrWvaKvj6cQ7Lc4wRdT2JxI6SyP42RyyOg/DluCReH6fTwTtKZTYo7uylGACwRGQQ+U3cqkfY91P4jroU+1RA002jZ12vQZ3xzVqVg5hlMvzWVVAog4BIwZ3q//77KX1eaG2b5y+WmSATF7qzx3DyGtOVfZrv+xnPniF7XiKKZpwfR7tCJhpj64XVzyAit02fwNeIN39FiuRRAsgOjqrVxHGJPPe36oz72tk49E5+/3//ucYMUELNW+0Ix7BmxMx4atHCVbGZdh3nvJD8gXMQsp2x4ueDyN7VSTZ9yEVthJOH3hR4nRZaYuUJBvPyQ/Ft55QO0fbIbImRRpvZxHmhGq0Bh4WhlabBD+vMdjI20yYksEdtel/3GEpQF1LA6c4KtNc7bqCGX9zlq8J7AX53FaV5hBJWcHPp9gmtkD5q3fp3k68ekc9l2vrTHVdUJos6lnGpGiiS4iUpoVpgN6YKJY+GaZh/81XPaNl7IGEhDLwJWttVLUX3+4HxR6YjyMeAl7tftajhV8qR3yK5mQPVpDDT6IWaC/5BWlTB9nYp73Hbix46+N0ZC66B6NHEcRwZOTEtXIGEbDoA3zyxxi2gsSqu+QuqUNDbBHEnEqwQjaLeA5ybIa5LmMjfmF3rOBXcH4qp3+wfYFKKoe7rs4VNGZ4eTgu/mFsnIa5iCGsoF1fO9L6ly8hFF8j1ath58aEv
 sYprPuqm
 fNtt3gOyb1Eg7cRk8j3wNQW5dAM9/fd6ms1E8YaCRs4imFjbgo5CX5/As5V3LvE2E4ti7YLSY6SafjFrXEUx7XE0wIeEw1ns6gT1cHYVfBSqwuzXljli24u//UP3JTN6xgQV1oWA9l9unn1rLAviC1DaLNpCCmKVSGOI6Y5iQi4sc8X0U1AsGmzKbUJcXJJU0kS8ZAseJTvmGdlE+QW03XCkRUQHljalZoueSibHDg44+C1iSWUhj0/2+upvWDNbc5YV2ZQ5CgpfmzDHOYE/6JrFunpKx6o0wKklakGWU7xhBak9a7rMNER2VxWRj5uvD22jo6FugGU/VTFpvB8ET/3Zj/6Zt1CbecqczHHy7gC/Z/+9GT7v0g/GArT35eRxYUf0cCYjhBiZG48DAP0HJ4jdvoFawnsWu5x3B9I+XNkLlNQu7elkRc42P/F9lt8pkpX6vaqxQ6kMg5jQnIEJgWtx+kM4+wPDj6ZmnEc8ufOlh+GP7d6AwZqbaNVsxNCUNrGZdOMF3UCzWbQTSnF1+GYIbQXcD8ws1DiJ2NEhcatvfQJ8rmJbdEZlhsXxCmMW10i613oRXL2gobChcPu8RIRDoW1n68Ys9NK01Zprwn8dfAmrJN1OMB8AElZntuz/75i3H2oFtvg8rhEcHwJfEAC/K3y5xxdbeJcTGt5RLey33Erh/3NuXEqvOQREGdhwGfbDVqv5Z1SaPur/dBumy53QKk6Sz1uziDG6vD3uGAJee35BgI2db4xcYsc8H9gBV+o/qjckn+Y7JsOOUVgjVwz6bGoKlGztgs9uYFBZFbdJYsLpNwAazqnbnNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 01:19:24PM +0530, Vineet Agarwal wrote:
>create_pagecache_thp_and_fd() fills the backing file for the
>pagecache THP tests using repeated write() calls, but the return
>value is never checked.
>
>If a write fails or completes only partially, the test may continue
>with an incompletely initialized file and produce misleading results.
>
>Check the result of write() and fail the test if the expected number
>of bytes was not written.
>
>Signed-off-by: Vineet Agarwal <agarwal.vineet2006@gmail.com>
>---
> tools/testing/selftests/mm/split_huge_page_test.c | 13 ++++++++++---
> 1 file changed, 10 insertions(+), 3 deletions(-)
>
>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>index 500d07c4938b..eab69b0f59a0 100644
>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>@@ -609,9 +609,16 @@ static int create_pagecache_thp_and_fd(const char *testfile, size_t fd_size,
> 	assert(fd_size % sizeof(buf) == 0);
> 	for (i = 0; i < sizeof(buf); i++)
> 		buf[i] = (unsigned char)i;
>-	for (i = 0; i < fd_size; i += sizeof(buf))
>-		write(*fd, buf, sizeof(buf));
>-
>+	for (i = 0; i < fd_size; i += sizeof(buf)) {
>+		ssize_t written;
>+
>+		written = write(*fd, buf, sizeof(buf));
>+		if (written != sizeof(buf)) {
>+			ksft_perror("write testfile");
>+			close(*fd);
>+			goto err_out_unlink;

Maybe we can "goto err_out_close" and remove the close() here?

Apart from this, I found on error writing to /proc/sys/vm/drop_caches in below,
it just goto err_out_unlink, which left fd open.

How about fix that at the same time.

Generally, the change look good.

>+		}
>+	}
> 	close(*fd);
> 	sync();
> 	*fd = open("/proc/sys/vm/drop_caches", O_WRONLY);
>-- 
>2.54.0
>

-- 
Wei Yang
Help you, Help me

