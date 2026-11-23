Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524EE606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nWYlAJhS
Received: by kanga.kvack.org (Postfix)
	id 66EA66B05B0; Mon, 23 Nov 2026 13:05:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6464C6B05B1; Mon, 23 Nov 2026 13:05:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BF96B05B2; Mon, 23 Nov 2026 13:05:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E55C6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:05:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 998F01C43FA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:05:16 +0000 (UTC)
X-FDA: 85467160632.06.953157C
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3D5A18000F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:05:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nWYlAJhS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795457114;
	b=Sd+kJRxqBfQj+FIhrzHnXNvzmlj6yCE6QKWsn8LxM6tpZNEZhdMtaKIpPT7Xe1UgL/Dx4L
	s9NMgZjVg19/gLhpqIbYL6xh89uBJ3IUpUKduVQbKeYXKYthCOraCjTKgBXa0/aWgamUnx
	CoOrABrxwS6v8zTJGMLTeaWxmbbzbVc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795457114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jw8SilefRf5vO5k7eeVpHgnCi78conTEfmhaXVb/RAo=;
	b=0IkOBV6HGAyvamjxNil1pvkwQLQ9j5Z+LTEV37No14yJt/QcqT4c4x3DO+BLjGIe3pmHhg
	oNcQ59ueL7GfanR3YAVL7CBM3SMcjKEQJFCNMhxVFBgxxB+tg1AjMNz8RcsFToH8ZxZxT3
	CyFWib7+kguy8L49003nJApBEq8vWMI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nWYlAJhS;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=dmatlack@google.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3adac5c10e3so1881869a91.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:05:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795457113; x=1796061913; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Jw8SilefRf5vO5k7eeVpHgnCi78conTEfmhaXVb/RAo=;
        b=nWYlAJhSZcDGhbKGAJK0UZCMhBBVtaKxvLXA66al4wXcmQnA/QQgbVs9bjGCKIsWbY
         saRTg5goU+b2afAJkNvgz7KSie1hS5kxGNvBJT5hptwNF0iSB3PNL5GTvp3EguDaGZLr
         Vje/kReMqzHua+Fr6oc7xjfLAgQmaiitm3myiJjSmA1yi6dJhf3b2vrW7YzPlhDCpeDT
         47y+rKop0AVNIZZOxT8CG/gIJ70wgWvPPHf0cNaxlY+SuIhjaHVUQEG4IV94q2oQtxCr
         4/scyUS+uQIhA8+4lG/kiYVpkBj3ppPh3ZBuVcOFFyjGgAMOrYeRC9OBQ8qLF/4vo2sg
         mRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795457113; x=1796061913;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jw8SilefRf5vO5k7eeVpHgnCi78conTEfmhaXVb/RAo=;
        b=ElcBTunZcL6QKiXc4h8epPcnBW6LQQLbjKY87VGPY8kMRXqDaqa9NPE4G1yHv32YfY
         qZHhEyOcS8g1l3bTzEFVJvAOaAVjALKV+ud7V00+dT0HpzY5mW+82ORfOjIqCu35hmTh
         I5vmf8oVjK7aoCillVuCrb478LXfBPYFY4SbAKCMdZrzy1ESDN2zvlil1HAHk04qCrh9
         EhCUyAeG73zvuRzqUWisb+YY5XBhiF0GVfHJZHmQiHkEAColUWmFatIIQWsAEher3RBG
         K+70GWYIvD++HI/Q43qds+HZ4FRwrD8yEkCmMOSU+eziOrt01LN1dvCIRAID5cpfFF8a
         bXKg==
X-Forwarded-Encrypted: i=1; AL+hErHn30dYUniNSZx+gxzd7U1QNBeRZ1rOv1WisM6vlARk1d0PrSYdJINh+SB/poQYdSik8bY/qnuKkQ==@kvack.org
X-Gm-Message-State: APuU4Z/Md1fWHiYxMupMfL8KR8Xxd/NEgjT1ikxPYxDvMaSJWU26Dncf
	y99KDUNYyP9Zch8lKRcizlJl3yUhwDONc2Y7DUF+5iOkGRF13YPkojj1b9VAO7da3g==
X-Gm-Gg: AZFdTZdHfJRCXCl+beeJQVuUlXadmYLX8R0AFSJKN1QldbN2i+mWdggOpj03t0U0Erv
	+pQN0QfPLqAoypkVE3HxeaVof5ncqHNB09rFGdSraE3MUwQ9OFF7BvBZWdhmFAYVDRDhWDK3fIE
	a7Wd6wqIcq9N6WZ5Jdg8Aqoi246JvreX6n/BOFR+AXUdezznQgXP4m+a02nee0ESGE53CFKmXW3
	ty10+4PAHQzMOlnM81rcPoiaQgPGIDIzVGwlxOThxMrBKATFGt3jq2VMfDP2fuxTzkXAVdgV4kQ
	dctcsCX9e724WmSZyq2OAT8R4to46pTvWLNOjxKzklAXChC6goQ1H0WOwv4Tgm3zNPV8jU6wgpL
	UktKu6EieHSNjNlckBWiUa/JCy4TAYMsikmUNtBD2i0naQWOx34m/T4Ax9N3lovwHLUT/U3DIDb
	xExhsrd+3l2VestMbDIYf3C6FY9trMTTkA62yRO8MRXAWZod5WztdNM2dOZAXOnh6are/8xpwji
	Q/7jWStMaZVC8EhfrByNaVNB1eTFsdHmZn5GHKygcC2nrJfyjKbVCLiCpxvFr5CaIQeBkW9L/3D
	FSqqwCT1bSL4YSD1M3M0UsTqawE+7+rNeu4iP0sUL0/sbTjDsbcZTlusWOr+2KkA
X-Received: by 2002:a17:90b:1d4d:b0:3b4:ca86:8bc4 with SMTP id 98e67ed59e1d1-3b4ca868c1emr225054a91.46.1795457112373;
        Mon, 23 Nov 2026 10:05:12 -0800 (PST)
Received: from localhost (33.79.127.34.bc.googleusercontent.com. [34.127.79.33])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad46ef5sm18802720a91.8.2026.11.23.10.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2026 10:05:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Nov 2026 10:05:11 -0800
Message-Id: <DN2SFE0VTWYZ.30XIXLSZ0OQAQ@google.com>
From: "David Matlack" <dmatlack@google.com>
To: "Pratyush Yadav" <pratyush@kernel.org>, "Christian Brauner"
 <brauner@kernel.org>
Cc: "David Matlack" <dmatlack@google.com>, <kexec@lists.infradead.org>,
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
Subject: Re: [PATCH v4 08/19] liveupdate: Let file handlers retrieve into an
 existing file
X-Mailer: aerc 0.21.0
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-9-dmatlack@google.com>
 <20261120-gedulden-rausgeflogen-spruch-cea76174d5e2@brauner>
 <2vxz7bi73fby.fsf@kernel.org>
In-Reply-To: <2vxz7bi73fby.fsf@kernel.org>
X-Stat-Signature: bokkt7gk8osq6xcfuhcjwik7dbhceioy
X-Rspam-User:
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A3D5A18000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1795457114-428634
X-HE-Meta: U2FsdGVkX1+YYx99d25qsepv51LMKlA4h+up+kuV7qn7m4B/Jw68Y9qGi77Gei2F+bhZ0vfpLdwEmii/uE58lI81oGtc9diwOysnD9vu7FSy7r1KDhwoLFgDXgoRLbACAsKw06OsKU4xEDJxR2XK0FZ2shr4QrAt6HfI7nH/jftP1tATba01+WDj880uRxZMiIxegybFYI87E1q2L+yEsUZxZB49w24/mUpUptVI3lKoJKwpd00pR8IUe2hLojThjc82zOhNnorUgZEOh4vYM1GPHtlJSuB7WelKbIXaabCXgfCXwZwYJSkaaCCOJKi5RNqxGzWLUauvqnl5oIPA/1cTEErZMaRyWJqrwru0GPqtALW/wpr9zUS65f8y1m8iyq9K7dEk1oRnRJFnqSXXM3Rnl+d5SwVHBj1HP9K5pB6aLnPV7QapYNOEFTzAtnW0nKMb7RwQW8SfquVd/xbH6r0HZN21qDEGmZkiSuaB6pQWByY6rj4Xn8TOuMRUD3+c0EtW1aUbIPuJp0ur3h1QJ52pdYFS3sAhtKFbn9gPjK4xL9O02SVGjFSopkzdAeUnoANH+pzmQp48itWwqj/EqvavVDA/+n06Hl8bfKK9r6PDicNKdmxKrxcFQlrvXwzE9iHlNP/+6bOtiAz7yki8P29wuLqBJ9dSWhQNoJj6/cDBBcKTITQCYgRfLX8vfeK2Y9m0UVD5HoavoM3LlBzf601/p768/KHLNu3ooaOSmlvJAUMVnk9Ry+Njy6Z7FTkBSFenodQ7PBSUQD6ulbyljTNY06+IowwDEAZiGC2ga5odf4kU2THehbsqwkVB7hFFH5BNQAIwJ4eyFNYcJ7EXoYR37XgfgZf669lHLgDJ5LPQlZX7JxBFMo3gfiy/Pt+lxPxrRQ5th8Jd4G+CUQ5LtxJLX8XXyzBGqbeI91SgIequwfxX0mezvwmFfoaw0FZsE7UovraYO6UtiZ2qLES
 RwfgcN1y
 B/rlfcV4MiVgzXfAU33cVUULjL9cFEJtCqRxy3VZ6ZWRgbt/VtQxXRSPCLMvp7bbtP+ApvzoCnNY0bHCmrre/zm3e3xumBfkLPKnYkLAuTXUICpHeuwnEr+fTnj8Eo15hKnG98ZWrD1h+VU66f4v51EaCnauIOe7uDBdmIUB76p9nqf6WyI1+TK4Z9t5BK2vBwW1hUvsJ6HETooVCKIMoT/Cv6JjX9Z2laLSNr2z/7S01IF/d5YVY9IKz4y4pJwpZFGmz318IoBKReCfz1BHsxpiInPlOUVKhKoeDhwDyY7HRGwfFsatdPu2lm2/LQAr2oerLe4VVgy8MDFXo+3bSVdn2hwZJunHe0ZaMMyZE1YO9+byTJChFT7KWm7VYczaufkHXV8AndBc8X2ymelyLBFggeROneBkR70i5GnPQKT1B+70G37ABQlKmUiuuFrgTgSZaPKpIlBL65o+3ar6mzVbBz4Z6drVe1A8e3qHXGC6pOwvNneRc/KsFZAPDkIhgQFejZKQ/Wdbo9dJDmZU1NkkQFgiq/g3HOpbDG6tzkmrDEZ6NssBHxjocJdNoSYVS4GujQyvvWYo8W25ZIseNoKgzoscc6pDvZNp3cxaQkSxj8lSecfi09WB0PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri Nov 20, 2026 at 3:36 AM PST, Pratyush Yadav wrote:
> On Fri, Nov 20 2026, Christian Brauner wrote:
>
>> One thing: Please just install a new fd like for every other retrieve.
>> I think it's pretty meaningless to return the fd number the userspace
>> just passed to the ioctl.
>>
>> The fd number is also not useful as it's not tied to anything. The shmem
>> handler looks the fd up once and LUO keeps a reference to the struct
>> file:
>>
>> 	CLASS(fd, target)(arg->fd);
>> 	[...]
>> 	args->file =3D get_file(file);
>> 	args->fd =3D arg->fd;
>>
>> Which means, another thread can close() that fd or dup2() something else
>> over it before the ioctl returns and the fd you hand back refers to a
>> different file fucking over the caller (shared fdtable etc pp).
>>
>> That also gets rid of @fd in struct liveupdate_file_op_args and the
>> special case in luo_session_retrieve_fd(). And a retrieve into an
>> existing file then behaves exactly like retrieving the token again.
>
> I suggested this approach because I found it odd to return a FD that
> userspace already asked us to retrieve into. Any sane userspace would
> just end up closing one of the two. I didn't think of this race though.
> I reckon we could return -1 in the FD that LUO returns, and let
> userspace use the FD it already has to work around this. If userspace
> wants to close the FD in the meantime, that's their problem. They don't
> get the file they asked for.
>
> While I like this more, it's not a super strong preference. So if you
> still insist on having a new FD, that's fine too I suppose.

Thanks both. I'll go back to installing a new fd in v5, like for any
other retrieve.

