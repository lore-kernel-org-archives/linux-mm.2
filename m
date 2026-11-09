Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6180606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=fdX7QWEg
Received: by kanga.kvack.org (Postfix)
	id AA9F76B05B5; Mon,  9 Nov 2026 11:40:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5A756B05BE; Mon,  9 Nov 2026 11:40:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922B16B05BF; Mon,  9 Nov 2026 11:40:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ED126B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:40:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8EB41160735
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:40:42 +0000 (UTC)
X-FDA: 85416144324.03.434A9CE
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5B1804000A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:40:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=fdX7QWEg;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.179 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794242440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hck20NyvBqj3Ac8MLVTjPeq6/3Z/Gw267omoUWkMKcU=;
	b=0Bw1Zze4xouDXItvA72cixfjzH51ZvZaLp3bnWSCjW8NFMcZ+WUcxV5czIwAdeNBgqTxD2
	qq2YFKBThXxTWHA/ox/P+EyBdvayqnNmP0dIHARTgvvjgYjKcDjkv6HJGPlaZU75DrNkKV
	KaEGU15NZwKG9EQHm4VVImoMB8QhiUQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794242440;
	b=4tYO5CB12b3b6p+YSXojCKUXS/K0DSfY8wslrAz+ql7vuJ0woTExoy1U4keV9odq1H/3Ru
	HMQ8JgDRO+xtx4Lz6RiLv7fTi6DcNePjHqpdTrF8I1r0cGg21SDJPnJggvvro3HzKmz+0s
	GYbNYF0htMFPhZC0IDkDCMhunP65YeU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=fdX7QWEg;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.179 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3acff56a300so9636211fa.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794242438; x=1794847238; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hck20NyvBqj3Ac8MLVTjPeq6/3Z/Gw267omoUWkMKcU=;
        b=fdX7QWEg5cYf4Wiep2PK3kmSZziig3lHo+nCUfVXLvPkKDOkHBgYVu1UvSejrJ+JU5
         QswE/LgQnElt+Cvr02XhkGswf3d89yPDMbAbBwuRL90NggU5ZBG0el5bbFlbJnhUI9OR
         TZmaEaZXxHqBiMg126WFyBLmgqS25JIULHOPA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794242438; x=1794847238;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=hck20NyvBqj3Ac8MLVTjPeq6/3Z/Gw267omoUWkMKcU=;
        b=uQ3vd3oSixmlhzq37LD4ow2udcfZa4k+oA3QimE2nfekq6u8YOA+ErbXfudrFD/nhC
         9S95AvpRvy9sf5bxOFOZW92fstCYs/KP0HKnvMegsAFZX57VI8Grfzy5ZC2VcY0EtagB
         veN0KoFW9PkJggAmBz6WaIDasPM9ChyU2FgYkC3OMOFC4MqWAgDblQpnt5YBfduTar3w
         ibr5ccSOFpMJH3XW23Xah46g5p8yRYL8l2Caq/wtR1bDkTxjgCynRhLnaXs3hHCDa9VD
         /tzeP604mVJJ2h7scdz5IoTILyfegt6KoCuc/zwkSmZlPIFLgdFoRUL2YZ7WG7igk9FP
         YSUg==
X-Forwarded-Encrypted: i=1; AL+hErGLWYAmqLDIgPavd26Is6G3n/xYcLCC+2M3y1e1jQaEOs3MXCSHf3JWmTWNMezTmOC6bTIeTN/uWQ==@kvack.org
X-Gm-Message-State: APuU4Z8DUdjo2u3lhk7E3QMN7f27BsH0olfSvaeiHu5WqWsDTTNP/CGW
	7BEVp+7cJPaRqgTpXS9SZ/0oibM40XHGBAHAz5UTuRfBJlFBYHrioxtDz7XWiEvfdhbnRfHIL0Z
	qOXwy3Qg=
X-Gm-Gg: AYBFou2ngIVTcx++9jnRaztToUSgwAx270uWl5aFeAKGOc5wm2dZpb4yRYIwjLVHWLQ
	68wTNtTnxFAdeZcBwacm5C7GdqVQT1rcaf/SPsGkgin7UMTiuNNgqJgKUHdRgtUaCGeWaRGIJkD
	70x2X3VDKKXif7uSsOVlEg8I4pIUaiaruYTWyobrLttfmDZrm5Kht64lBAgPgSkEXWOmCXbJx33
	J2mb5Q0JjFOFqPcEOK6zVRoohEv3EfIsMOnPQlgXM7R3qd6HI+Bb2GPmXazudAD+jjBkBFxDx5a
	wQTkwL/5NlJwB01uYr6jUn2KUN4CC96fAGlN9gutpl3Y3jSngBdvaqdPWqh8AMs6ouICBgVDySl
	UcrbXAekpMT9JGPdtQyj3EakZr/qoeNYCAGOjmXTKRmd0MNY+bQyYSUSXxvI6fpw8ktH9qzfuty
	FkiYeu6ChXRnhtOsB4Xk7gWh0aCIwSFeIJ4C2as/chTjK4eJ29dOeON8GP3TaRz1TofvizPjS3y
	Uonlh/pT3cNnz5k3sApchZ4CxLzDnreNrk/dOHvaStENJd28YJWFte8w3cKsA7RveW/R5HqlJ3u
	h3Td4nNvUwPvoxejUHMIHY5iu+1NfC/Ym3hS4wY8MKawVwn7UGY/lg9i09NNcOsMfmxRxk7DJP4
	M9A==
X-Received: by 2002:a05:651c:1508:b0:3ab:2a19:8625 with SMTP id 38308e7fff4ca-3adfa3eb67amr10780581fa.4.1794242438342;
        Mon, 09 Nov 2026 08:40:38 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3adf9d76f0bsm10683011fa.2.2026.11.09.08.40.38
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 08:40:38 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5be53e5fce1so923590e87.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:40:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFgKof7lfBZ8LdhuVwPiO9vtSXctiY2dARVAFKR3nvYKj+BJbqXoTBXcZveOkRchKsrllFzkDQvxA==@kvack.org
X-Received: by 2002:a17:907:9303:b0:c41:a5da:1511 with SMTP id
 a640c23a62f3a-c4d6d58b94dmr324648266b.25.1794242121304; Mon, 09 Nov 2026
 08:35:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104130118.2507513-1-kas@kernel.org> <20261104130118.2507513-4-kas@kernel.org>
 <f21433af-afc6-4a8f-8d2d-3a377cd3bd6e@kernel.org> <CAHk-=whn=xc9J3qApHWRGTaBpwVRtGbvJ0LURGF=dqC9B3swUw@mail.gmail.com>
In-Reply-To: <CAHk-=whn=xc9J3qApHWRGTaBpwVRtGbvJ0LURGF=dqC9B3swUw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 08:35:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=whhp=Q8qR+wPoM9+mxYPQ_OXMOEoKmT7J0JZikFZusuqw@mail.gmail.com>
X-Gm-Features: AclHuK9Zg1YgOX8tZrGKznWYWBoZxGMj9dsb1Z1k4ney-3EhDZHB_lO5ezPS7Ak
Message-ID: <CAHk-=whhp=Q8qR+wPoM9+mxYPQ_OXMOEoKmT7J0JZikFZusuqw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 03/18] fuse: don't move a folio with PG_rcu_free
 into a fuse file
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Harry Yoo <harry@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Luis Chamberlain <mcgrof@kernel.org>, 
	Ilya Gladyshev <ilya.gladyshev@linux.dev>, Jaegeuk Kim <jaegeuk@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	fuse-devel@lists.linux.dev, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: iwgoqc3dzjes1uhug9h5m8ss6cas8754
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5B1804000A
X-Rspam-User: 
X-HE-Tag: 1794242440-369745
X-HE-Meta: U2FsdGVkX19DlEyDJbwj1a9YU9bXPS5uiPikCrGHM+1VjI0IFAH5VOuoJ1ucKJsrIMROE8W7mTkKY4i3wNSz7r2vpadMXvMHFlp4tDAs58E+sSZu+sFcAuM5v/v2pRfWYY3B3AvkyIlK+L1DYoDEmk/6/Ho4mDzwdJ2gpoNmNe5ncVMHsupU191ZsFmZONXYeO3Q26RA1PRogNRlUGsSNcHQijbVggrNI88yAKsLD7TJxQ0JEUVCglEXMqcBshOKsXw5dogm4zzSx4gsbsrWFVPoPP0RD1Qpmj44W/XRbpRRq9Dfvrt2OjforbKgOJ4Jmmr0/Xrzm3HFgfZZrsNLCXygHK/ov4vgLUx3niNGt61KNdN743n3qKNa0HjQIY2nPY44DrgU9l2uMH9H2uuMLT1quinv0FBudBr8JqtHqKIcnM/oWr6sv6tuIygm8SmpJDjMz8O2GhhN9mQPa9T4KljWkM4deuGDKTQ2JEd8NZSANUOGxoQi2Gk9cXfPIcHChpdXyLPtVsRUQQlIl7vnbEW000PMKarToWy2x1ycBRFidfH2TdujOgeWcwvqMYoFqINFBJCDhqP5OBcNX0K4EW3jEr92DgljK/Jc2CUokwXVxgUNvsHkFXGKZDyo7oJAPaH1dkemA+88ZaTjglBQOr7B1/Cjyc3VY0I7vxGnWpywWCBaov6431ozV1h2aDVmIKvbksCfHDy+IPHsyBGcJ2FYKp1Ac7yw/Pv6XA0qqTtHxsw8iX4scF+ktDwLxLrf42jQoF8H7v3Srk+6/gh+RJQd2RdPEzF39bljGZ9LiTcZ34kK3ii2ow/Xqc9IBYD/dNYmP27J/IfWyxnns9t1n7FfCC1IO4XBoBB9arSeKeVyfo55YLjN9Xw4ok9fNH/bBsUczOaCUQ6vBdr1C03px7QXma5LlutAXHsHdNjdpe0lkafbJcmCnmSxnqXus7QtDzxpaHu+4CqqI2x3Vc5
 1LCWvtIk
 f06e5kXLXkM0RSm7nsiBez9YuwZURklkEpjIhnSU5kAOGtpgUbdcH+NCpPStKc8NAyRRke6M796o0+falOjWoXs/wkl05u106rP9F7EJnrnLcKTEOYTGmgFd4jrWym4dqWDE26pxmzWWsnXr9Wniw4oJhQ7eMGQHhhyuc5quVBoejsgp8qnSD4N1fQZZkKfZa+cDFv/ZAksPs+tPHNM2wvJ4kBH5f+pk5mEQpHK70j1PStxm1DMHzfRiUwTyiY2BcJkBzGuUXBzBlMBbL0Ed/tL2RlSDRMwhQcn51lUP0hm0sAvncRX24o5bMhhjMpSRE6LCuDhVf08xT95jA3R/rigLzDpEN6TGmHvKn6vCWJD7Ad/WAUQBylAqVNdHaumhbQuIjuBZDg5hTlVMNt4KVcAGE0my3quqcdFc8z9wGFVJfFvyeRmmQ3HU/xNow4ERriEw9EEVPI5lqHoDkSQpLqOZyABXcA5uZulEdZQ9Yq0Dj4D4u5qfihZkuhXPH4Vc2pbo2Sp9iKTB+l+9A1HkjzWK2vxaUU8lRiE7xOVMCYEfnnmAKAPRim3E0BQ4xff7O0KKDuNSxu0NEnoy0jkaTXgygOpOKhlSRuZtgrQo4Ox3U8mfN2Zv71RpScjydYQ0zTQTj4cm3qfgkpbD2ZUEA7LKKmKhKaZxexWo4upBZUInnpHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 at 08:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, 9 Nov 2026 at 06:46, David Hildenbrand (Arm) <david@kernel.org> wrote:
> >
> > Could we get rid of fuse_try_move_folio() entirely?
>
> Please. That would be great.

.. and in a similar vein, we should get rid of splice doing the same entirely.

Kirly's patch to just remove page_cache_pipe_buf_try_steal() entirely
(ok, it was originally mine, but Kiryl took ownership of that series:
"Tag, you're it") is worth doing, but I think worth doubling down on.
I think we sh ould just get rid of 'try_steal' entirely. I don't think
anybody really uses it. I think it exists in fuse and in the virtio
console, and neither is worth it.

Removing pipe_buf_try_steal() would basically remove all of
fuse_try_move_folio().

Conversely, removing fuse_try_move_folio() would make
pipe_buf_try_steal() even less useful than it is now.

Just remove them both. Good riddance.

                 Linus

