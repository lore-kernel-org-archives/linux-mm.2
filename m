Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13EA6606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 21:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Dar2SFo3
Received: by kanga.kvack.org (Postfix)
	id 294426B05B2; Sun,  1 Nov 2026 16:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C056B05B3; Sun,  1 Nov 2026 16:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182FF6B05B4; Sun,  1 Nov 2026 16:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB1746B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:03:45 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 754DF140A61
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:03:44 +0000 (UTC)
X-FDA: 85387776768.04.9C2DEE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 983EF180008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:03:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dar2SFo3;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793567022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L1KaEDjFsWvGvMrTGkRaCJc21/TfVIdv9OIWGbl/AE8=;
	b=R47XfANJVJlzVO67Bo8SFfUiM8v0Cy7iuc2LgSN2FDsQAQtGG5uxpVU6VLg0R2Fv/snf2y
	ep0AA9HAPH4dONAHfOJYFUgBXX1qkATRW71dot3k4bHiNe4R9sAcl3HW6mXRe2SJ21dmuM
	UJz9ib2fq1u+LKNounjPTjE8ztsgngs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dar2SFo3;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793567022;
	b=KTQ3yn+wqu/ECcgxtjRm8vPrDjEYtiDAW4PNbNi2l4rOEMc8tw+oqtrAMRYVn5v5kxRrfN
	z3Sy7Rmkk4tOcnF56QjuesGWALfBHcKC54LgVQ9MJsL0lLHdEj8sfNZXacg1HgLaSSB1TH
	2JrBjgkvm5paaTSIgDAp8dQjuonPCUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 24C8660054
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA50D1F000C1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793567021;
	bh=L1KaEDjFsWvGvMrTGkRaCJc21/TfVIdv9OIWGbl/AE8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Dar2SFo3WrBnMjg/Wi9AxrLDYq9DWwa7uJBUlcAQLwyr70WFSaNbTQl75OPMmNglW
	 MeKaqhOFSQ2JzeiCtwoEDa+GDXV/xWfqogeX7NISoEzCF68cp+2j6T6L7eJjejoq/c
	 emu5q3LK9Jy8kBAdtrHSrXAq6E+fjWFMHnoY/Ov2DIkW2a95Y9Bwl3YoxX1V6XP5AE
	 iIdgIQgoirvdxK9JDo9d1YeAVkhS8BAkI1bG0USpIIcudnqjt1yqvVgI1ElrliLWbB
	 /GeWDTbuJGOGuPKIEe/8q2NKEbUaLYR5p/x6Gnt9wDvuqu21p61WPh53jrrSiZoJJw
	 134escY1GMp9Q==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93e6eb77f0bso235420385a.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 13:03:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwvK2fWbklggnrdUXEQCvVP6TjHMWoFYLfaNFtHye9iBmbtkqPI5U0xWgCdfmwtQSZ51iRxzN5Rlw==@kvack.org
X-Gm-Message-State: AFq9FYL6Pa1SlLy3rsuZUnCDb5IwSts2Z8OmbkQiZwnS+oCFyKOnh+Da
	SnoxoZ9rYKXEt+x68YBMK3KqGyqkoBOxR2cIDXU+YKIOFKZtMuFWlniH5oQaFgvGb5fOdT4s56S
	2iBzINLZFSt1WaWd5OKDpjMSH5Ick34s=
X-Received: by 2002:a05:620a:2806:b0:93f:5892:e5fd with SMTP id
 af79cd13be357-94421585e50mr1455648685a.1.1793567021240; Sun, 01 Nov 2026
 13:03:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261012205447.2717801-1-max.kellermann@ionos.com> <20261012205447.2717801-3-max.kellermann@ionos.com>
In-Reply-To: <20261012205447.2717801-3-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 2 Nov 2026 05:03:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zQh9HrvgaqD32_A=bSdqmPqP4oV_SxMXMEDBrHe4jjhg@mail.gmail.com>
X-Gm-Features: AclHuK8OqXgKSVdL2WuIVJgz5P-HEa2lSTPqglBGQNxXGO5x-V4zhAlTU4Zabl8
Message-ID: <CAGsJ_4zQh9HrvgaqD32_A=bSdqmPqP4oV_SxMXMEDBrHe4jjhg@mail.gmail.com>
Subject: Re: [PATCH 2/5] mm/vmscan: move code to lru_gen_{add,del}_memcg()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 983EF180008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: cuoyp5h7c9r5yf8ipfhdesin5zj8k67u
X-HE-Tag: 1793567022-742759
X-HE-Meta: U2FsdGVkX193UUxZPXXERpDzYgsUiOOW+Hmjmr5B+yo2gZQENi8ao/gYRrUcZ7gFuh5LovC/sQRDVDj3DnBZyB6aLiy3lHiUs7AvytW3OWwfi56aDXg6FONV3YksICNDN5/N0He0m4qrujiv9coWNR6hOUT5VrKXr8JIqLXA5j0s6ssMDH5I5Fw0gy/4cFSSf3a5OaxJ4RQ/LyfHQ8mDi+VXWthTH3dQfnCJbHuUdXYBjzPL/q+J9eWJoGIJ4e11z0aOis5cFVEqRW05HbyLDf2hi5PNvqZZhBHOs6R9b1hApBBc9EIapWhQKGb65icD1Uhf+JWT5nyLdjnf08R94pd6t0ArxftjECCOIaQ6CE+t/KtBfKgJeeo+ZbbvQbYbRVRKilD/wJ1/1fEGVyyE0z7UaKN3ueXLxKB0P8Q8JZdCE9VizPK9SJnCazmnNV5cdP9f3o/cOs2p/QM5ksLzAq0DVypPfp+w3lLMVzpaYl84MCdESm4HP8UXJ16cXWgZFO+XXDjEafY0rql4WR1GYyIbfXa0/1/R3iGY6lkiM1Ht5YMk6rgkgS21LjHY4KCg+9po8LKDf37mAFL6ydjOfIA/MW6P3c3rDB5z+lLfa5xm24Sj7Nl321aQ+tvAAxX6n4YEgTQpNSTqmvk2M421IRf1HUyPmX6E+Qh22PWW81O45aHj8BDfits8+wZ42xcZl6aCXLqxjsBRFRsIbuB4sUdORdMnmrGIh6Kapmuoi0ZYYY/hQlhHggOJ1BQIGIDdGkIDabSeEOCO1yVUoYa9Ylm4cvUtS8o6Ei59onLzv0oacgwobsZkYgHqTxcwbAF9SmRjqpJYDG0ILKbH9F79U30FzYGZcwc/irTdaEwGG/z54XG8QooDHUBQT6Q2a1AziAj6cdEeG2anz5PhMY0oX7W/OutdDwWu1XiNy88KfP5MCM8A1EkrnndCBHW6b7y4DX3BMnYf/PeyyQ7RaOB
 DKPgmB+k
 BrrWUNdUWWfZ5X2e0EFFUE6qfFEjSpF2BNY+CZJnrrI3HsDkYKZjawBUYMg5SghAA2cT/FZoWGzsJf4vE89iCssr/IjbOJ5WlAlb36FjQVvgylQoeNYxnWX1TPzTEjOd1yOw2jiYHLmLqTbzsEkrm+FKLVBL4xPA45t/3eJbsIo5Qgw0Op74iEgcBs415c3XBNxhZ6QZvyWtuXLwYnhBmSw3BibfZ1gE+boQVVw6k/cri5oJ5JbxEkuq7mU7jul96B6yO5aCWiU1+k45WV+6AVxMRWNue4h87BmjFRylT6a0f7UoqZ9l7/uBRgPPcDgGdQGwBDN8nqZQwevYilGhxQOK8bcpsGHz0mMuNUbyz7bPVQ/i5v4baDy1PJAm737szUhgV+GjTSqUOYyv8/pVW2ck9f0lT67J2lk1bKcrUIRSYyLHXQ+qHpKVoXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 13, 2026 at 4:55=E2=80=AFAM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> Preparation for the following patch that adds tail caching.
>
> For simplicity, hlist_nulls_del_init_rcu() is now always used, which
> is also valid during rotation, because the entry is immediately
> reinserted under `memcg_lru.lock`.
>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
>  mm/vmscan.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)

[...]
> +       lru_gen_del_memcg(&pgdat->memcg_lru, &lruvec->lrugen, old);
> +       lru_gen_add_memcg(&pgdat->memcg_lru, &lruvec->lrugen, new, bin,
> +                         op =3D=3D MEMCG_LRU_HEAD || op =3D=3D MEMCG_LRU=
_OLD);

T.J. series[1] removed MEMCG_LRU_OLD, i guess you will need some rebase.

[1] https://lore.kernel.org/linux-mm/20261028010611.3929937-1-tjmercier@goo=
gle.com/

Best,
Barry

