Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37321606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DzZfMQnc
Received: by kanga.kvack.org (Postfix)
	id 0D60E6B05C6; Sun,  8 Nov 2026 14:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0885A6B05C7; Sun,  8 Nov 2026 14:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4746B05C8; Sun,  8 Nov 2026 14:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC37A6B05C6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:30:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DBAEA8100
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:30:40 +0000 (UTC)
X-FDA: 85412943840.18.7DFF14A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94FE41C0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:30:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DzZfMQnc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794166238;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGWcdi0dUz45RUK9WtiCKIc1bZXWd56im4xspZm7By8=;
	b=xQtw/0GDlJkeJ1/gg90fWoY6T5EOQwP3EFRnC6kRa1txURxuHr4wm0/hiYn0yrDsfOJtXS
	KwNf9WmOu5WqnmsGI6vNcEDC/PzK93TFudAbhbe1RfPVTuJ3mihxNfMHeKh2uN+Wa95Bnj
	g8lhWKBfBJMmnhyiUU/irmR+FRLtdL4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DzZfMQnc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794166238;
	b=KD8GC8whIaU9GWNjjKdZZ249jZH/9Y8S2YvYqlxYmL3lDfcRrLzW0kI7runuypGfk1vUs5
	ja1vrbX3VCwI6HQ/wReOPLviOdv1Aoa+Io//2vXZyEMHcdB4UBoiVJjmZDbP6LClnbcIZK
	9R/5rCh0MeMpf1Cp79XmStNfP5WpN3A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C43BF41A01;
	Sun,  8 Nov 2026 19:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52DDF1F0089F;
	Sun,  8 Nov 2026 19:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794166237;
	bh=FGWcdi0dUz45RUK9WtiCKIc1bZXWd56im4xspZm7By8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DzZfMQncqTIaP5p3UzNb7vrOecGw38WnRL2X5aQSu2cAD7rBl8MYqx+f+9yD504IE
	 lCEWYu8sVr+IcnAZj+LMKRBiDa+BtqQYoOuh9C+4gO5J/I46AkegV2di1xdmguyOIa
	 yPtF4lZeoWsWYFWOKwcslKnthVnVc7DqujgNV+lnJy2Lne727M5VddP61DfsXLfYnI
	 tbKlXHxV/OW34zYzWGR1XpnoQghexizUv+OxenfaHlYLx+x+QF7pUmdtYW0a4S6Gsf
	 nQ4MRas8P7JHnF9GT+JAIFUCOdbNSqDyoPXH6F1x6zvVbpDXQCzoC7HWGAd6YCtNqV
	 dVJfoqjmnhXyw==
Message-ID: <sashiko-outbox-203953@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read
 sysfs_filter->sz_range only once
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Brendan Higgins" <brendan.higgins@linux.dev>, "David
 Gow" <davidgow@davidgow.net>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261108192221.114362-4-sj@kernel.org>
References: <20261108192221.114362-1-sj@kernel.org>
 <20261108192221.114362-4-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 19:30:36 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 94FE41C0004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wwhoq9dfar9rxci98hqp6dd5d94jk9do
X-HE-Tag: 1794166238-782251
X-HE-Meta: U2FsdGVkX1+whj1f7LjUt4Cdznmg72ArGVv5TPlIKCHQKgEVHcVmFWMztb+cJCJHTjy2ze0SZq9iSkOGLPIOVyIsHl4mbxz3jHKuhaR/Oi4CRXS4K4dIWPlYZBiJsBLYvIT5y/FcSsy7lW52LcaCXq118TlFLXuRPloPsvsxrv4kKR9Wuduth8g6BDmukNoPnZ103y7KcVnHF78tcM1LOWT4T0Zt9+641okyFVgfieeDIHkGsPPUpxWFkCR4MDBBhwnsl3BJ3UdVFp23wSGveV+GldedoFjDwnuuYROJVrAKboorlz+bE173RXN6IqbS681lhmDSLRX0/zK29y/GyrqgfCV2DcbpfDTRb6Is1rr14bp1/5W23Ai9t1qb5//V1rnXb8Ib+0j51uXoJxE9vmjVMTQWjM+msF9iWFEkP7YTFal2oEo8/AXVtkjl11WqJgSInfeChHiGUwlyTeSz434nIELn3h1MB8ghmwjBc9l0ifwGraHx3ao/mtTnz7KeCo2v/f4wKw5hIafmn2mvAhZAlnOoEtsfcP/1fUpdnQMzYxDo2RJMJ7rnZ04zEDgzRcm5ZCCxf/i+uhmEOp7mLOrmc28yncE5LAZUN7WFBiX6qj5/KbNUvcaJgxMbVsZ71w0nWTFg60r4Pq28wcHvNkNb1YT8G5IZfMWww4l2ayHNxfYNjvQufLXK6eFqTJRxcA1ahfnbwBltsvpafhyUZF1e1bbdHy9CoA1UJwZkq25qy3rzWvAV1QuQI06eURBokT4FkfYIV1Pf1p0p/XTE8Kt0RfEs018DW1kV5HB5kBh0ExbRQIp0hS2YOmn6zrc6BVLd6QjxZvk9m6f5NZOSzigPcFTFXJnu/XJ0X/E3YJBzxrXkLyzYgE5F76B35bq+6rrDKo7Y3ESyFSbNLT9mpMpfDswmaFf2j/guY1uDlYojb5gvgIQOl5avrpqjHGYf7XyZ0fGSp2MN6BhihxN
 nR9MBkgH
 ivxfLF9vvq+Bpc6lP77XHRM6Igm5kK83NUt01QzQ58FyZ4fzNYOHSqBmmEeaWiZ5JpkC1uwsh+B81+oeBILg1A5rmuMXPbEn79SE0gfMl5w59iFHaZAKjeTuhhjyeWs389sHxHEcxzogUSTexL+5amHP5nWdOF0yIPdKwaW9OppYswFgjLBYLNuXn1WhkUgugO1wm1nZYjhBUY7ewWs6UNBf9PXX+d0vUVXtkkc9JmS/TuFeOakXCi5K9hvjRItixtUAtyXkdTr1rbYwRvBl1WQlkWE/ScMOxgUFX6z+HiOhn1547Aq3w7kz1TncxmKPR/xf7R1QWa+46kJcCSA0yOPypa+lEHN0Py5itBtdeRe+0aFB/XDqvX+8e45lZ5MZYXC4V/o8KZgFOVclM4la3thfovM9xA4NZ/X7ANH9EXebThi/fXMBZ2maus2QNb1dGlgBw/GMyffCd3UdpwA053oP8/hpGQiT9uQyVNy4TEYKWDdLL0JPFefFrJvR2pZnGNrwRcygTI8200CgWcmRiyxjFOCmaV3Zz3Bn55uqoWJijbnO39cG+FQJZ5J1/gTlG6NWVoMTWDNobweqMTYRFJu3nE5Ny7HkMmRqMRsh6JtijxO32i4VaHvRK1d6dCLQzAC43
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] mm/damon/sysfs: TOCTOU race in damos_sysfs_add_quota_score()
  [1]
--

commit 244e62bfada7cc56b0025da40ea03dad6d9c6420
Author: SJ Park <sj@kernel.org>

mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once

This commit copies sysfs_filter->sz_range into filter->sz_range before
validating it in damon_sysfs_add_scheme_filters() so that a concurrent
sysfs update cannot pass an unvalidated size range to the core layer.

Link: https://lore.kernel.org/20260914142327.92510-3-sj@kernel.org

> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 37e0a8bef4b1f..0f945ef043709 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -2493,12 +2493,11 @@ static int damon_sysfs_add_scheme_filters(struct =
damos *scheme,
>  		} else if (filter->type =3D=3D DAMOS_FILTER_TYPE_TARGET) {
>  			filter->target_idx =3D sysfs_filter->target_idx;
>  		} else if (filter->type =3D=3D DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
> -			if (sysfs_filter->sz_range.min >
> -					sysfs_filter->sz_range.max) {
> +			filter->sz_range =3D sysfs_filter->sz_range;
> +			if (filter->sz_range.min > filter->sz_range.max) {
>  				damos_destroy_filter(filter);
>  				return -EINVAL;
>  			}
> -			filter->sz_range =3D sysfs_filter->sz_range;
>  		}
> =20
>  		damos_add_filter(scheme, filter);

[Severity: High]
This problem wasn't introduced by this patch, but can
damos_sysfs_add_quota_score() just below hit a similar double-read race on
sysfs_goal->target_value [1]?

mm/damon/sysfs-schemes.c:damos_sysfs_add_quota_score() {
	...
		if (!sysfs_goal->target_value)
			continue;

		goal =3D damos_new_quota_goal(sysfs_goal->metric,
				sysfs_goal->target_value);
	...
}

target_value_store() updates sysfs_goal->target_value without holding
damon_sysfs_lock:

CPU0                              CPU1
damos_sysfs_add_quota_score()
  if (!sysfs_goal->target_value)
                                  target_value_store()
                                    kstrtoul(..., &goal->target_value)
  damos_new_quota_goal(...,
      sysfs_goal->target_value)
  ...
damos_quota_score()
  mult_frac(...,
      goal->target_value)  <-- divide-by-zero

If a concurrent write sets sysfs_goal->target_value to 0 between the check
and the second read, damos_new_quota_goal() creates a goal with a zero
target_value, which later causes a divide-by-zero in damos_quota_score().
sysfs_goal->metric is also read twice in damos_sysfs_add_quota_score(), so
a concurrent metric_store() between damos_new_quota_goal() and the switch
can leave goal->nid or goal->current_value uninitialized.

[1] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108192221.1143=
62-1-sj@kernel.org?part=3D3

