Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C5F4606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Zyd4QvL5
Received: by kanga.kvack.org (Postfix)
	id 33E696B05B1; Mon, 23 Nov 2026 12:04:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEDD6B05B2; Mon, 23 Nov 2026 12:04:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCA26B05B4; Mon, 23 Nov 2026 12:04:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E193D6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:04:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77CAE120906
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:04:52 +0000 (UTC)
X-FDA: 85467008424.07.B8BCBD9
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9B7112000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 17:04:50 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Zyd4QvL5;
	spf=pass (imf31.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795453490;
	b=LWdkrOfOVxHhesJU1llXkKeJZ3phWFS6NuRVynUPiJgLM+fWBonUG6krdrV12wVsOP85UC
	lpc65+PVdGAMdiY4w4IQZrGq8fu5KcRqJMt6d/LmGyAxcBlb2qaA/aTs4KdKBnBqfxwZmp
	Wdqj7hOhwZNJEjIqGqt6b8zHKeGyo0Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795453490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6z6ak377Awv+mxJYPSVQS/ONw5MrRNWXM3G9SGJDdio=;
	b=vbourDpc8BDIN/ISovZBZRL1OpmTIvTqtjTM2/eUM0M8y9VwZbLoBjf0yqPCmCLCM569Z+
	63CA0JHcXXTFyYftMOb8Pkio4iuaT1rcasHaslsrRO94YPsWAV7JNvFpBmaC+dDGNWg0NF
	zlDuajsSQwXpdtCdJ0tN95priRXwQs0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Zyd4QvL5;
	spf=pass (imf31.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2f048bc09d7so120295ad.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795453489; x=1796058289; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6z6ak377Awv+mxJYPSVQS/ONw5MrRNWXM3G9SGJDdio=;
        b=Zyd4QvL5I5Q+PI0bAbgJL+go/WpK4yOGOEP9vubOmG1zmR9BfIDZaWlTNdCRJuDARY
         nj57eDrYgUSzsagvzToRakDTBhyLpP4f1OPQoXaomMqJV0sh9+NrczNjxQ6mNaH1dAQM
         aww1mzbJNQZgGbcg9VfBRAKGbV12nkjY9qtiYBQ7DWpkaPEaj2QWB01nj8qCH0SFrd5+
         4MxSJcatAYgzYY/1RlYG5lFdPa+Otq/+vBHEsE3DLzPHMukXuHIkyh3LDSNt1TA7l+0Z
         vJJYLDgetoU4QBJNd59n5EfTImUQQ+GMRhXCPMSYNTxmwYGjiXBnbaLdVh/YbLWKBdTj
         g+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795453489; x=1796058289;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6z6ak377Awv+mxJYPSVQS/ONw5MrRNWXM3G9SGJDdio=;
        b=HpPbqiaM5OW906fRixyTOrT15AaKExbjEwf5MkDAzWm+5O0mjHbPOZRxnzPyRsTbsD
         SNbLEAbL305wMX/YCZXe0fqiIBR0VYApWPeKKgybo72cxKzjGMZbpxd3ZBziLYP1tDNP
         LAUBBrH+frKSTYy7QnDFbiOFYtAmrVq646yXxaKjX4FAhsFushxDhSgilfJtuqIX/2Vr
         7mO26QMv1Ih7nnqzhXrhBY0/vabvMS+brrk4BN5mxmocn+46PHTKv5MMag1oJkzmUIwP
         6Iz2dafqi9himcQmNxV8UzEGt4YLfNEHfZMDOm9h2/2gLu2btVf7fzvDNZsS9KfMRF9n
         gDgA==
X-Forwarded-Encrypted: i=1; AL+hErHy+q0S8cIaaXqhHwL2VAGFnO7Bvq6OMfb1e4xy2w4r2Uh+54DP/QM4WV6YhRlLCwYMyUyt9jyMSQ==@kvack.org
X-Gm-Message-State: APuU4Z/JZKlkKl0f2eU24xlVs6VEUP3MG5kcg48TU5jQDXe13Lfscb5n
	BwB9+AcE1B3+ZwvTZm/bpIp8idd3XPX1oSnFUki0Ym+VMhwuZCqaTu+RSGcieNL+3A==
X-Gm-Gg: AZFdTZevBJuaSu0C8EoZp+nPbyHT04eEnPoD+/XK39IaubmE1JwJVL6dW73p4OjvLuR
	8m9xPg0sCxmr2dpo7btzUZSRSm+9Q87SFnfyvfSXnmBQhikupDRyvVz6O3L/RAe7NFPflrkDEuo
	BexWnWR2bM01rQdJDVnRVmmeBeuyGTJOwA3NwheaXNbN58jMzyLTX9joq+2U/PgCASqtKcMjOmo
	tjcL09Mc1REU/5nqTVnJAq7xmhiv52LUiSHqak7L3x4s8uU9L4zvgcHffRkSCs9Qru08AnKF+M/
	Rym03sIhXOkNxKJ9uh7g9wNwtCIRnZz8b5pfBzmLQw9Bd2YRlQ1Mgi8rf37/i6usQHuYqirOnqZ
	nC0JAi6pOwia29vJl7W9WkZosZkz3SgMTUKl6kUfNrwYfsNyDp3O97x9AnihDyxmqsRTDnRYu4/
	36efqmQ3Mxdfdb5XwVoV9H3+eDbzBgbumTFRb3quFIbbaNvtQemG3NF2asD3tLai1zKo7EuAbkH
	LRMrDHz6b46ud/fNLNrS8nVn/Pp3qZLkA5XxzOYLuL5efMxdiajuM8p87I7Belt43qVfWIQP9ZD
	j3KjXpeuaPipYbnoJXudv0f8Iw/E2xxWjI+E6xB/y6RNO7OxwSPzZMeaRHZ5D+58jhbcXIyf8F9
	WCxhTFRxqfLq0fbbggCfwPY3uOcVU4fZiGX8lRHfmT3x0VWTT5myWRshX2DNeqH8+NCy++6aJxM
	lwetKL7mEZFYeGsaHCD9rLkfVoHXhCzdg1fny3qu6DERoGRg==
X-Received: by 2002:a17:902:f790:b0:2e5:9bdf:6b65 with SMTP id d9443c01a7336-2f0615ca0f5mr7681115ad.0.1795453488528;
        Mon, 23 Nov 2026 09:04:48 -0800 (PST)
Received: from [2a00:79e0:2eb4:9:2973:837c:48c1:1e91] ([2a00:79e0:2eb4:9:2973:837c:48c1:1e91])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87285b60csm5993799b3a.9.2026.11.23.09.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 09:04:47 -0800 (PST)
Date: Mon, 23 Nov 2026 09:04:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: kernel test robot <lkp@intel.com>, 
    Christoph Lameter <cl@linux-foundation.org>, oe-kbuild-all@lists.linux.dev, 
    David Hildenbrand <david@kernel.org>, 
    Linux Memory Management List <linux-mm@kvack.org>, 
    mm-commits@vger.kernel.org
Subject: Re: [akpm-mm:mm-unstable 327/327] arch/arm64/include/asm/percpu.h:261:1:
 sparse: sparse: cast truncates bits from constant value (ffffffffffffd8f0
 becomes f0)
In-Reply-To: <20261122194825.2541c7389c2f958ef3d07fbc@linux-foundation.org>
Message-ID: <7d1f916f-2a4b-c31e-617c-e1da7623fca3@google.com>
References: <20261121133112.48w1QOqw-lkp@intel.com> <20261122194825.2541c7389c2f958ef3d07fbc@linux-foundation.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: 1zaciqk3dt5snkydj8brtseybzi5k8mo
X-Rspam-User:
X-Spam-Status: No, score=-28.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9B7112000D
X-HE-Tag: 1795453490-170604
X-HE-Meta: U2FsdGVkX1/SopHyR8jaMybPxxJiU8YjJvQ+baQCatPffjecQcZGsEwlAVkgPxVUnhSWUuMchCok5EnVYdsg7VwGRZnNUODaFMqAiTtKpvxhBoWt+6GhJmj++QILXttZ+pL8TJNohQn7/7LUQLbf1DXT7UPPG642OLISHroeCsNLnnR0O4chZffUeV1jPudJfxIg/foNyJc6YklsD2UvPqA2v01oF33sHc2ovsYc4dWdg0uADGQ2n7ofYOkMLVGpY2rEXa1pSx6sewzEWPhHQZy6OD4l9jaNOy4MSx06xRN+9OPFF5Tp+LrGh6LEnl3aSsyf8JwZUHBhK4llGGGn9Sec15kTkC1OJP3nbdes+GWeamReP88Mq17d9sXE9bY2zu7mQI7NvU8Nm1pNY0YsUayRwEuS4gdeQLz5TNRshpz8wH5jrOo5vyyAMsORJZurVPFnpzLmxBcfEkAmNStbg070JAoi2q3UuiMbMCBx71swPKDgZ5lX4/n8zZ4LMzt8hsmZDZNwYRX0YPvz9UG0QYJLbRpn1mS6beFqd9DWLNekHSmiy7k7azThp6uwpQM7II2ydtRElLfTAt+k5wlaR9TDes5wHtRUVBtkXKYZmFLRhFMKVjYYD5wddWAz1QYV3n//6nmcvf5DHcXUjQy4JVDhY98x5xQVajWvIN6eaRdFXWOIyM2OeUTxRu3zIXxeK4UcRq8Ij7BXQ3mVwLZldL8aoe3mnIwbzaNV34h3TmvQaM/iAmf8Tqr1tqdt8fenzvbZE1KgqM1r9fVDdrO1Q/pY5ais/wMSBJWSG8V+dytv7UtsP7e7zRV6NKtmr3kNN8lFb9gqlyiCp0ksnlnXr4j6LyR8axZMqtVgC+Mv1J4F9zO1zsYfVdE89Sjsu6mnt6SvKdPo6CsS62goH1gGaDGq63fO5IvjzkYqFM2DL5jPOCdGDuAftpHRM0bV9HCUvvaOwHF7GEK86ejgSTO
 lgb2BDJF
 OniOGGL6mCDSQ9HWwBal85Sc/cNwY0o6Rc2FrzoP+X0K8l1AQwi7PUNiGAMTyPHjBHSmlRhI6h2vkTJQoHlYHhOXmBATgh/eIJo2mkNB+v9HzhO5KxF1iiueKSXH2ffPF7LkCEABgNFUh7re9R+QkpmOGMK/GcWrYc+vqfM/GG2UCF57T45kJuloLglqqIniXF07uWBYUdApmkhhB4iQqXH8HE9Ocx/86SP3sg9xdIgsZAk4hy5lDeXI8zHfC0KE4E08M/we0ePrxoq2UDn6urXdHDJom51qgdcbqWtcBwc3r3T6rMJuCrJ9jcfzCSztReY2VL7t+DliM8LdsRla8oUePR5QhFzPa4k7kyT79w9VoPsgMwt7BbtHZXbUlrpM2xLQXyNAxJ2xmRcMKOKE0VbC61wMvrZlfgKqmru9ODRaJLHNs5AQLApQ+sEfk9iBdXdE5mzZvHbSzRneMcuC6Z92M8Pmtze3Z0z3zyC4DM39uvY/ScMYoK5gUhkbuF5IuUehKTtE+9tdHKa/ydhsxRKrlVBBqzzKgH3Jz3Sg2zQIKki02+B4s6V0vU8c/WrdcyiDOW+CF0vpXH++E+OBOQKQHPCx+pCYJaUhEXH9b4JAmLqRLeYWa+vXbdFx3nU2ViqAVXJPzRto1h+5OX/K+n3VGOaiU25D5NqOArQbxTpSjYQe246bt3J2l/Pax2RsTdKHE++SpP5McdHOc6uQ7rgo9TdBdcDhKn/hy15LgV34kSZF/jpEAPRm0RvMEgXjRsq9T+AfVfKpfSiXfVgYZTKTY//UrGK50s2Cd8YgFWOar6xBzc6B5CZGQtALJFrvstQZ0XoFrsN/aVJMACgLJ/LjQjU9/5ja0zchn4HlG0jOMbPC0C7S2jtw14mZzHye5TAvYz+zvAC1VdW+w7dloDOshE3dYsHSS71Bs5DjrVqmWdYOYfJKPU4ong6iqRNnfgfS0kF+3ClMfH3soksh6T8bJqHe7
 F0LiiZS5
 okQV21ypIDZ+LNg2fUKChoHkR7Jz7qzxHZBU/5p5StDmzUDWYE1Dvjz/149CUVHi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 22 Nov 2026, Andrew Morton wrote:

> On Sat, 21 Nov 2026 13:34:45 +0100 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> > head:   7d1a16abe4cc5dccd21e3d6262e44433a5885d27
> > commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27 [327/327] mm: vmstat_kunit: add synthetic benchmark for mm stats
> > config: arm64-randconfig-r2305-20261121 (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/config)
> > compiler: aarch64-linux-gcc (GCC) 15.3.0
> > sparse: v0.6.5-rc1-21-g84ec0658
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
> > 
> > sparse warnings: (new ones prefixed by >>)
> >    mm/tests/vmstat_kunit.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/kref.h, include/kunit/test.h):
> > >> arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits from constant value (ffffffffffffd8f0 becomes f0)
> 
> Thanks.  sparse is being a bit silly here.  Using a variable instead of
> a constant silences it.
> 

Thanks very much for taking care of this, Andrew!

> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm/vmstat_kunit: avoid sparse warning in vm event cleanup
> Date: Sun, 22 Nov 2026 18:51:40 -0800
> 
> Sparse warns about -TEST_COUNT in an unreachable 1-byte arm64 per-CPU
> case; the actual counter is 8 bytes.  Pass the completed loop count
> instead to silence the warning, with no behavior change.
> 
> Link: https://lore.kernel.org/r/21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com
> Fixes: 7d1a16abe4cc ("mm: vmstat_kunit: add synthetic benchmark for mm stats")
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
> Cc: Christoph Lameter <cl@gentwo.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Sarthak Sharma <sarthak.sharma@arm.com>
> 
>  mm/tests/vmstat_kunit.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/mm/tests/vmstat_kunit.c~mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix
> +++ a/mm/tests/vmstat_kunit.c
> @@ -107,7 +107,7 @@ static void vmstat_test_interleaved_zone
>  
>  /*
>   * Test 3: count_vm_event() benchmark.
> - * Restores counter balance with count_vm_events(item, -TEST_COUNT).
> + * Restores counter balance after measurement.
>   */
>  static void vmstat_test_count_vm_event(struct kunit *test)
>  {
> @@ -124,7 +124,7 @@ static void vmstat_test_count_vm_event(s
>  	time2 = get_cycles();
>  
>  	/* Restore balance */
> -	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
> +	count_vm_events(SLABS_SCANNED, -(long)i);
>  
>  	time = time2 - time1;
>  	avg_cycles = div_u64(time, TEST_COUNT);
> _
> 
> 

