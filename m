Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3881606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=CcbxdYFA
Received: by kanga.kvack.org (Postfix)
	id 7BD886B05B5; Tue, 10 Nov 2026 13:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794E76B05B6; Tue, 10 Nov 2026 13:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AB876B05B7; Tue, 10 Nov 2026 13:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 403176B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:56:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27D31C09FF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:56:33 +0000 (UTC)
X-FDA: 85420115466.09.CAF6D06
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34E6510000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:56:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CcbxdYFA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794336991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8kKfDytD/v7OOrYEkkTE88iqH3WPJ5eP+WcohkLFA8=;
	b=3DB02c/ejqhsZT8ma1zlZ0R+FfZuaM0JIosgOm0Jsu8DMUokuiZnO4w92mzV0Y7zJRP3Ln
	wzUEZDHQWKpqpkGwq2e51NO9rh6saGUhaNB9t9V5ZxDU6AzfVDiGFEMYDsHoaji59/4qd7
	L4Y0LPv/p0+AdOJhB2eAFaLH0TH5sJ4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=CcbxdYFA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794336991;
	b=HUiuWon8YguoBdXc4WrTfm5nqVCw0mWaUQxmzovTGDPbo2R2FU6+jF//As0tay8TuFgE4J
	lJFoSAmDUkABSv0oWawpLNYH/iB9LJPEXN+rcYnqoIEDXmTMdf/UVKxtj3T2atsQCzO0q2
	n3Pt5KDHaZ96WeN7KoFRl8DRKt+V7GY=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8b67f25e6e1so1186130b3a.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:56:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794336990; x=1794941790; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=g8kKfDytD/v7OOrYEkkTE88iqH3WPJ5eP+WcohkLFA8=;
        b=CcbxdYFAJQQuoUBFJ4YUCIxheM6a8oOogd5JA5JwCf5fAA47FXjOCTVfc+zRtUoXje
         ilZTIjnBRGIYC0CHekWti056m6Rp5/cE5PmPwfycqSfjeFykJzAsoAaZ0MZgkMbAWE9A
         Vsm69vVcb9rQbnvGakvRcaCp4PstTAYFRRBCBPT8wJBGFyeJuFq3qF04trIQ3C5U1j/Q
         jKCChQgFoFi5RJ1V2QfW/6WllU6hT1XhDabksnicRq9wGZmC+qA/YXwTF0EIJ7gFNJ2H
         W9biEb8r0EAXK8NjTn8kgVt4e3zPbDPOYgNuAlKBRFpRYvTVJgNgAmn5xwmcb4QxP3G5
         6nDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794336990; x=1794941790;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g8kKfDytD/v7OOrYEkkTE88iqH3WPJ5eP+WcohkLFA8=;
        b=lCoo2h4VIsJFwwaO489pOl28GrTFMOyaNIUikfmY1m2YRfE6apfrZPkq3FuHdarWBB
         kq76yj6t3HURv9SAHFTwqdtCx8JW+ISJxNeqGSPlOiefeeqzNfOy+06t2fW9OsAc1Det
         SNjrZ0eeHT4PnwF6phmajb/Sb9NaD+1eS6wpNE7dgGMBNykwlh00iVN3o7F48BH9fZiC
         Kzxk4qDDDDl42cNA5WxBjjd/AziKqgKnNk0xWK/FMW06f3lEnWEQetIZ5Lv3hsiEQ70u
         iMemLptLGJPIMXLUG/ZCkwE73922zDlADOw0h99Iq0NEXDWHwRtKzi0lDdECe3F06FI2
         KhwA==
X-Forwarded-Encrypted: i=1; AL+hErE1LEetWoWvA6vkjeTJ/fQsE/PYlQpg5Uvg01smRUNNOGHcHs7BmSAJCyqMAQovHOcuc0nlu4y3sw==@kvack.org
X-Gm-Message-State: APuU4Z9l3jatWKe7K1phSUdBNnEDnPQNQML0/yTnLlOSP539RTr/OWNL
	gqqI7wdbvkY/ih1HXTf8wezSulA+KZzyX0c7IW9+A93sJBSs1FTIdg2oeKkvDpb2XA==
X-Gm-Gg: AYBFou264hE8afLagYPYuBoA8XXpMc64mGfzWVkjOhQOldD+GOrm12sq8mXjEviq7ae
	jZhxqAp3Z5HTqQdHyNpgssz/aO3q6hAzBrRBSGkTpjzwpdV+Xh0hk8UOp80VTCX+BsSa7qg97tG
	4AarOBaVumDJfmQr8xkUUoMmLZi3pajuvKbjyFS1/degrlA/ko6vcGru8q8OeOalCewuX2iRyBE
	CDBLQQyl7xM2Wowf+/zAaaxWGTneTLAmqTS+KR+ocdCKN93mymoJJv7ZBuMoawAouH49W7CxnKR
	hyITkSE0f/v+/eUNaZZ6FwwoKkNl26fI1Zfk/pwQ1nJ7DRoUKzgrwAx5hE8vFWBs5B8iwwg4F2v
	s2MAgF6uRJ26ps+DEzlNcvaI6q4SbGCeTcazNMYTt3bFqkwkvf0gFUh5sSSkxXC2eKksg1ftECH
	HTm1C3tKgImM/FPqmwIMv/RV+Pvi0NcbD6qf5YsUSRUD8brvlGpKp9j7QT4MUEu74IP4S23VYiS
	p2tZVJ44aQn0dqFgJ4ZnxZT6J4UqzSKO1r+w2gPBjjhaB2a/OfZSgUO0Hb72AZgnfjgNz30bI36
	PwpUOFSD9gioW0h/dDFOVRvwVfB677s9YNPe4WagnQg767De5oegGfcPkOK47fWm
X-Received: by 2002:a05:6a00:2349:b0:89f:7a1b:2bf4 with SMTP id d2e1a72fcca58-8bc1b6feb8bmr5444b3a.16.1794336989281;
        Tue, 10 Nov 2026 10:56:29 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm1302972b3a.42.2026.11.10.10.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 10:56:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 10 Nov 2026 10:56:26 -0800
Message-Id: <DMRRDJZ8UQ2D.30SLE82GDTH48@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "David Matlack"
 <dmatlack@google.com>
Cc: "Christian Brauner" <brauner@kernel.org>, <kexec@lists.infradead.org>,
 <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>, "Alexander Graf"
 <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "David Hildenbrand"
 <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes"
 <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport"
 <rppt@kernel.org>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>,
 "Shuah Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>
Subject: Re: [PATCH v3 00/10] liveupdate: Preserve tmpfs files across Live
 Update
X-Mailer: aerc 0.21.0
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261105-sitzordnung-nahkampf-ausbleiben-6db911d0333e@brauner>
 <auy0ThryqW5nVx20@google.com> <2vxzbj7witb7.fsf@kernel.org>
In-Reply-To: <2vxzbj7witb7.fsf@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34E6510000D
X-Stat-Signature: az8mr9w9dp76tt8fby4b63dfba1fcnk8
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794336991-935449
X-HE-Meta: U2FsdGVkX19WHkifz4pHZesUAwQVRNFlQpTjeucOrtt8rkRmqp9Z2xpiWkC3v0NhT2wi5TUwqImVdVAnOekWZ4mkq4WTOnprEb5EgbjFCkf9MkFuIwhlbu1sYYaVcG19q49TIBtLRsI3L6uJ4flbAF1X3zkKuVRFHKPVPJvgnaxhj31X+q966rUZO1f6NmJPLfbMMs3VFMvH2HQj8c/HDmyUVyZ+zxktULEltwbFBYrOq+j5a4SIHXGTJFMvKpRNt2I3CaLMF/ejppdclpCC538YC5W5vY1FWelI8c87+HJfkGEw0UG3eiBhKtRa9ZKqfRKANYsM8mtCdWfAOiCE6i6z/EgyInMXBGwSeuwYy+t9UoY3N4R85c/r/nDB9Lsg4FuRo0fYnh5uy2KLyYnb6m8MPT/VAAkrjqD5r+1+rl1x3izprO3u6k1UDsy9bYfqCpKAJ/4kh1wcTZ2PaWiyRf/tVqLZOWFvZFnGpPSAu6NdExowEjyEZRNWpplouz7X214c4AQO0MNl+pXJdcyvdMHHoTbpwLVPBk9XMizMW6gYy+RCvTYhehX5LXetw3qqyf/Dd68yrh+f+4YJjRGnuqP56SwbwPlKT+ZOCEzQOOavzwEPwG9uUDa07WH2PWTtpqet4IfbK5jmUi3wEb3kskEA+7JVRcTogv5sYAZiVj3H48B1nqF6xtAfzn3lfnQYcxqW0IEQEJEtvklNez/0lYwzLx8/hJnAOdd8gLbiV1G0iJ7yHVcznv6Na1Mng8dZi7OQ5BYayeuyvyefnniTYiYNSbbYXEGOyEdZHIzVexxcMMiuRs/AD9fVQUM8jitxGBkPa11wJiF4UK/Xc/+EF4mkveqKTnTPLBX4zx3oXr9bw7lM8ABwFr3xDkxjmYNi91FZoH353aH8MHapqeOYcDtBMSsxzEXDRDQt/KJ7ghuDqCotXnqmGwFcR8oQRu49M+fyUMM22GGFAhQ0aBg
 0zOZXObP
 fMzMRU4STfx3ct8+xUE8M5zFnF6HUvGHt+JUn28Fj0F5eEGCUQhijANVlATrO0bHyt8CmnEwbRC7hnXwuSkVplv539yI5HKFU479OeFjkUgWl3kY+c01LiPzSVhdq3KT4TgNde1Cusbg1iPYbsf348tKPusZybWzKqATFBKDCAGq5EeROYOruwUjy9UQmyuUNFvzx8F3Eibxq7rzbpCz7XsWMyDA8yeltu/xL+I8FTff901zMpz6dY5qJmwiw4zXGAz9XRCP3DdtCYe57yPQxg8Xa4qTGgukcY7aPPgDEvWAmk7tP0tz5l5qyTa/m44O//mEIKKzcONZCwJpFTo3b21I8hLxOfaKenxJgxAvKfjKrxkbAg2WOOogZNqNlyfgbdWbGLu68/hmZ+lpiViT6SHf3RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue Nov 10, 2026 at 7:45 AM PST, Pratyush Yadav wrote:
> On Thu, Nov 05 2026, David Matlack wrote:
>> On 2026-11-05 04:42 PM, Christian Brauner wrote:
>>> The checks on the target are trivial: a writable fd to an empty shmem
>>> file with the inode lock held while you fill it. A tmpfs file can't be
>>> sealed, it only ever has F_SEAL_SEAL, so there's nothing to restore but
>>> contents and size anyway.
>>
>> Sounds good. The one other check I plan to add is rejecting a target
>> that LUO is already managing, e.g. a file that is preserved in an
>> outgoing session and whose size is frozen.
>
> I have been playing with this idea too, and I also stumbled onto this
> problem.
>
> You also need to make sure a preserve doesn't race with a retrieve.
> Since userspace has access to the file, it can do both at the same time.
> I think LUO should expose a "register file" function that registers the
> file in luo_preserved_files. This should be the very first thing
> retrieve does.

Agreed, that's what I have queued up for v4, which I'm hoping to send by
tomorrow.

LUO gets two new functions for .retrieve() callbacks:

 - liveupdate_claim_file() inserts the target into luo_preserved_files,
   and fails with -EBUSY if it's already there, e.g. because it's
   preserved in an outgoing session or was retrieved before.

 - liveupdate_unclaim_file() undoes it. If .retrieve() claimed the file
   it returns, LUO doesn't insert it again after the callback, and a
   callback that fails after claiming must unclaim.

On the preserve side, LUO inserts the file into luo_preserved_files
before calling the file handler .preserve(), so whichever of the two
inserts first wins and the other fails with -EBUSY.

> Also, today LUO core expects a fresh file from file handlers, so it
> always installs a FD to that file in the task. When doing the "retrieve
> into FD" thing, that will result in two FDs to the same file. While it
> isn't a strict problem, it seems kinda ugly from a uAPI prespective.
>
> Perhaps we should let retrieve signal to LUO core that "I already
> installed the file", or a "I have no file to install", or something
> similar?

Makes sense, I'll do that in v4. The file handler will tell LUO that it
restored into an existing fd, and LIVEUPDATE_SESSION_RETRIEVE_FD will
return that fd instead of installing a new one. Retrieving the token
again later still returns a new fd for the same file, like it does today
for any file that was already retrieved.

