Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753D2CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1476B0088; Tue, 29 Sep 2026 03:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497226B008A; Tue, 29 Sep 2026 03:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381956B0095; Tue, 29 Sep 2026 03:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13A3D6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:33:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A5F440445
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:33:02 +0000 (UTC)
X-FDA: 85265983404.09.9AA4DD4
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 953904000A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:33:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h2xEdU3h;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R7xCnuy/7g5iJFczMExEfQo/POzPplLTdlE3AdQob64=;
	b=VBFkbfnqk8iv36h+hsapy6CYSvT2kfIYl+P2xQcGcyXiJq7iv+qtV/4LWDfZaWp0lcEnY3
	Ov9POUkmE97rqg1npvITW1qSmtz+82l0FFQqwWq+ZUCx5KyqyEXbuUr3ugXAvQvECruFn0
	7X7L6l75eg3YKh3qVetj1ONhMrVy94o=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h2xEdU3h;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790667180;
	b=ZQZyM46Bcw73Cf+Nq1nOW70IAGpdIBviDWW112RAFrZt33+znj3ARGU8NHlYKoGdizN6E3
	jt4dJj9xkZTDAtaOhY3omMOFuPINR3kljbnk+8PY/6iTBHetUwZ91kXhb1gmBEjDHO93Ms
	MMymnhi3l1d72EeYrMNxtBO0ZiSXzBU=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2db33db4de9so35645ad.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:33:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790667179; cv=none;
        d=google.com; s=arc-20260327;
        b=hgU6sOG34xvZg8QONTf4dhZOskOwy6l+dJz3nEkYT292XG+3HTNKXFURzUqYQITc+G
         St5jGJZ3Rk0aMETyevltzrQNzkf0rFgXztlYk2xCQ8IDgGaroRhJnNaPCfoHTDxz5uD+
         Co+1EPDXrqXrgKR6Pl8cOqRpS4SscRJ5IvWCL6bXBCcb+iOIhXqT+0wCPtnrRZ1WBH5O
         bCUGQA+pJcyZXaDXMJ3xsnDne+iO7kE8T1tz/tkhaopV/ODDZoNBg2aB4YUvcPiXhRc+
         r79pPdfYGLfUXwTpumijmq79H15jJu03yjfBet385oEqm6J0N1S4pRCLQvSDXjMLld1D
         O8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R7xCnuy/7g5iJFczMExEfQo/POzPplLTdlE3AdQob64=;
        fh=5zEWbfHk+2BUVFshmaGYVdSGe8fEvzfK6s8C1Z9QaWc=;
        b=T1DpbNedWY3Hbi1CCfg9kXvpFOXNmpLXLWIy9uWsHiR9DGVxqFoz9e1iHAV6zHYLn+
         6O/lKfHT31JQabEkgxAdTtsxQblLn/IjpvpAvxrUrg7ydgVy+3Ghn+yK2ehURYOk1Qxk
         Kw0oKyPhyfCtfnQtuEZV9wVWpWQCAeEDvQXf7AapJa9P27AJf2fLlCMLvKTZBdP7/CDS
         s1EqDgZofn3BjzmVbmj7qSMf4vX7HuRabuVAQIe6Uul+0P50l3gABm5HPgGSAIT4Hb7V
         9ByjHQmCgerSqmu1zcKmh3hVocnyObjMzJmgXat8qw0JWpEv4rIweTr5T5d6/igZpDeB
         0Fvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790667179; x=1791271979; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R7xCnuy/7g5iJFczMExEfQo/POzPplLTdlE3AdQob64=;
        b=h2xEdU3hICVJ22RgF+qO0uCfuyPBGs+mR/bHE3/+W8yDeJnQA2Jk8Z9GjHuJ3RZlS3
         k1KyqNAR3KqNT8htDnYQsajw+B3uQczlhSvlq5TaqRrjSq5Y/49oY2iusXUJ/3DZQ4T1
         pYmP6AukM1IRA6MLOSG8Bmu4P6xNck/W/ghCN8A2i5mBml47d70u4LvrIMLUQkWtbm6d
         7EqRYhseR7cDEITLgOy/Go0FQZ7qybtyEcYzIbq/rlH9L2kAH63SKw978lStXw4goNnD
         dFpSpK9gdeerf0JzEpOisqSw3A5HlB+m1CPpD5T7eu1H9WhcXLerEGVKQ+AKXFARmkss
         2LOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790667179; x=1791271979;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R7xCnuy/7g5iJFczMExEfQo/POzPplLTdlE3AdQob64=;
        b=s3tNc5JGYPppcJRqAgg/66MfDcY9wrZvN3zTNVwvlB1fjv98x6C72iLj9jWRbeTui7
         u9CoVI/EbLk9JlAZhYjfwWb5aM3ucf+ypd6VCw0t4iBX1uNg/5xNxAEqT7eFDeyrJiN1
         Bn8eoH+scc5Ox63c/ewxr5uMmmCtpTyjzLREepqdw0/EE8bI5BEBVH3Wwk1vZc/Ja04y
         L79tA88/9QFKZu8O+V1aWG18BKl+4mess1X0U6iOcLU3sT4Gu71pFTdBnwQgVQ6GEmU6
         zIAe9MMIenpPl41nSJuOyQNTKVTbeJ1TUyg0VN+MRPFYm7lN5Mb7DcrmiZKTO/Df+hv3
         dsMQ==
X-Forwarded-Encrypted: i=1; AKwUvBwEOD0SFxosLvbkDkoTrKKDEMKvnfIxo7G+O4QbQ2tAMqFSl4zC6sWO0cPpEMc3Q8VY20c/TzfdZg==@kvack.org
X-Gm-Message-State: AFq9FYKsDTo7X7hB7b9vNCm3shO3FCH7chLxy2v+EVoxQaxNNosRY/Oa
	z3gV0SffX/mKel6TdnewMG8W11LT6jDHaqPvsMQQDtBCvy8thLUW1OcSpwl7DSJJgBkFr/+GKL4
	0H6aJhJxWERAU5TkshdbhlkNWb/8em0FQ5gK/IYco
X-Gm-Gg: AYBFou0IcqeT3z4A7PAuXEHdq91XvlNjSjlIIorKT5ndIfKXsJ68IixJL3I81JDH0TR
	DOc+AopvdMvlw9AJMcjl4qg9p1P2pTNsavugJc0cnqttoyFFtaeseRWq/0j88jJDObk9RgqF8tt
	EoxAwFzAp8tESqtif4qS1dtQw7yfqNr9Gd9pJaIc1uzGVw/2Qw3AqR3gV8JdA02athgPpUtzSGP
	2DEtoZaWfbeG2sGk/HcazinPufSVS3Rtfrq//mY5HMlp8b1mfh5y4taiTGJ2p9eK/9jKqBlkjB9
	csWGidmf+/VYkQ9UaqOsISfADkLcg1KklSpWH2KXzYjzWjtY+ksc/o1TICjRGSwGejHV8A+E3a+
	7LyDgMngiBj5f
X-Received: by 2002:a17:902:ccce:b0:2d5:db3d:1a44 with SMTP id
 d9443c01a7336-2e2c7a23584mr2335885ad.17.1790667178733; Tue, 29 Sep 2026
 00:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260924050009.19974-1-sarthak.sharma@arm.com> <b8da4a73-296b-47f9-95dd-b8a74f3a0984@arm.com>
In-Reply-To: <b8da4a73-296b-47f9-95dd-b8a74f3a0984@arm.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Tue, 29 Sep 2026 00:32:46 -0700
X-Gm-Features: AclHuK8NL08FRy_baDRvYY73Pdr5_fLWqFBgJkAq-JJf_OGtsBih00TomEM-M5M
Message-ID: <CAC_TJvexEaehZno0P=xsoCbLw7wgfz+22iV4fwzcuGCiu3vAAw@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/9] selftests/mm: improve mremap_test
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <shuah@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun <ts930@dgu.ac.kr>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3jrjsnarfauexrjp4a96kz9zccma3x5r
X-Rspamd-Queue-Id: 953904000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790667180-438261
X-HE-Meta: U2FsdGVkX1+KfH+g93LUccDhzNW8mYy9mmKu3hQksq9FaKdC0eSciW4dFrneXB2by9+10ZpxFXoi6WO58qvb5gCabFYk5QYSlQ5J7XYKUC3w4devAaGDu4UHZrcbo7T72NOER2JPTZVEOSLoLwfTr7Sv8chD3IIPYEqaWaLZbFSU+f5aGgtgTeV0YQTmzehyB+SpXFHCmv5pQdooW06vI5OKk/c1Jo1o+N9gJZDFKvEDZl3Ltum18DxjNfAXJh66SHN4sx+H7uwFSKaMKEZCZo7l/+j8oowXHMmcb6YZZG1zpXV6byS4noke9gq3OALzxS0TFuip79kzepDOognBR7DcoxC+Dbintoz2Vij/2YmZ3TUVnLsICyUcF87XSd4pGmYXUamUucvqsYD6Q6L3Lyj4M6ZdMNUaK4+86Pz3ZqG5tMO+5wHmeSO0yc3TvtHWZ6nlD3VtyymfpYhSodJ60shiKq0xuxOZ2Ki5IjURnG4C5lE+hMbVdnBavObph4dISMAXY6p8TXC25nzCGtorWtNVdQ0q1Ovhrrk07H1W0RMbyMMy41L5E2ufj9eF0ZqpLKre9h8baRV/xJk+RSzXzV/X+NPMjLrvDsGuQUHM4/NZsB1cbmwQUIax8Os0eB8aDpkv6Y79+KvItDds06pjNTASglUtzWsH+RQHn1SpqMwLShyxGqS1ec7jmnLaenuZZOPUHujjYujCBRazA8elOEWqfUko5nRPmbQMlAIP48HKi0Fb3IKfqLXhSxY519elpdsW44jF/Z7IOUCh8/kNmOloDbs0JfXaCd8pDmx1/JayvCmhxWk0QIPM5U87qUKXcIz3Ujcudq6zKVef2IgD9x8r48dVISrGFxDQg9VDchDWOmXwDfMCMTEbonFSBQeuDgsDYDKSlACI6Y1qI+PJcLd9oWD1slHOncQ+KfJTaULFIddMvwtlpps9peI7WJNmKk04z7nvB29owx52vNW
 Um9r6L3D
 ERVDYEDqaMGA1DPCc8JPlHmXuMQJmRkYagtb4VVOyWgpp2u7E3xj9HXBPQtyBF0YTW7x/tVw5IQFeCXE4eq7BoJxgc3+ZNxbYJ7H2RRkqryysKVgfUR6JB0ZMq51Vz4HXxIJnrEg/n6Gt3UWKVUpJfSFC42G121yWCDtEDDRaQl+6pAA1n2y0e9AtMChJaSeQ9C1e54fN6kVYNpqOKD07rk4ZZstBTPIaT3Y4vTTQyL2VkFlG+jlRqTHkSGkeCUlTx/j+y96TWZIeGniSkwhqQyRloh90ndRWaIYqOo/aFKo3Q8qtBwG7AkfUa2iIpCfEdT8tB+irgDa46CNzKCn8zmReWjVQJijHqJBWBSU5hTunTY9TLTyKGMxQw//Rvj+hvBhm4VkTMtyf5O1nbbTNTUXCykzQh+5eZxR4KzLvZmrex7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 10:54=E2=80=AFPM Sarthak Sharma <sarthak.sharma@arm=
.com> wrote:
>
>
>
> On 9/24/26 10:30 AM, Sarthak Sharma wrote:
> > This series fixes several correctness issues in mremap_test and
> > simplifies and strengthens its data validation.
> >
> > Patch 1 converts the mremap_test to use kselftest helpers, removes
> > manual tracking of failed tests and corrects some spelling errors.
> >
> > Patches 2 to 5 fix userfaultfd skipping, unexpected mremap success
> > handling, multi-VMA data validation and failure reporting when data
> > corruption is detected.
> >
> > Patch 6 removes the randomization and uses a simple pattern based appro=
ach.
> >
> > Patch 7 removes perf tests and timing infrastructure.
> >
> > Patch 8 removes validation threshold and always validates complete mapp=
ings.
> >
> > Patch 9 strengthens the multi VMA validation by also checking the
> > mapping state of holes after remapping.
>
> Hello everyone! Just wanted to check if someone has had a chance to look
> at the series.
>
> Also, Sashiko has a concern [1], and I had the same while posting the
> series. I hope I can get some opinion from the community.
>
> Currently, for PUD remap tests, we allocate a source mapping of 2GB. We
> only fault in the first threshold_mb amount of memory, remap the whole
> region, and validate the already faulted threshold_mb amount of memory,
> which is, by default, equal to 4MB and can be changed by the user by
> supplying a command line option.
>
> Since we plan to remove all command line options from teh selftests, I
> removed threshold_mb altogether, following some discussion on the list
> [2]. This would now cause a 2GB source mapping, and its contents copied
> from another 2GB buffer. This causes the process to have a 4GB RSS.
> Sashiko says that this can cause OOM killing in small CI machines.
>
> Would it be okay to keep a 4GB RSS in this case, or should we find some
> other way of validating a part of the whole range instead?

Hi Sarthak,

IIRC when I initially introduced the test, John was concerned that
validating the whole range would significantly increase the duration
of the mm selftests; this is why the threshold was introduced. Please
check how much it increases if we validate the full range (with
David's suggestions) and if it's no longer a concern from other folks.
I am fine with removing the threshold.

Thanks,
Kalesh

>
> [1]
> https://sashiko.dev/#/patchset/20260924050009.19974-1-sarthak.sharma%40ar=
m.com
>
> [2]
> https://lore.kernel.org/all/2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.o=
rg/

