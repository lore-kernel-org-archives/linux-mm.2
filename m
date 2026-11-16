Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6DCB606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 22:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=dwRehALk
Received: by kanga.kvack.org (Postfix)
	id D9DD96B00EF; Mon, 16 Nov 2026 17:45:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E6E6B05B0; Mon, 16 Nov 2026 17:45:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF136B05B2; Mon, 16 Nov 2026 17:45:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77C906B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:45:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF5FAA782D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:45:47 +0000 (UTC)
X-FDA: 85442465934.17.98CB11C
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id C4E7720009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:45:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dwRehALk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794869146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7+WvZ0aOuqDrQLrk4s8LJ2lZixNWnQh+kPTnMGEgEw=;
	b=myc8gPRVYUdUYUYOsl7CvAEzjl+MXWI6ub1HBdXQt5hW+7hsQKzta6TjCFEacSxU4k2EEy
	F8vHRrKZp0mkMo+8VYcgIOfkpjcCjSys4B53B0+1yuRhUF7ty3KupFgTlKPQd5I4/ugHFG
	7SRPq3aQiJUJF40taqcE/3KbiZrbd10=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=dwRehALk;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794869146;
	b=qKCklas0nruf05TaGGkflSYoUgr19wODIHBjHgMgVCOJwlufKzDjPZjvs55PVXlzn8dNLl
	S/+bUX7m0bzjVfmeJpVkHZpF91AqEzYLnqGHxoeiBSq2uh7fqSSKZl7W0FHzIJZJTgwjBV
	t48X99ID48PuK3qsQsPQYCon+PtRg6k=
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5ee1e4e3abcso1145395e0c.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1794869145; x=1795473945; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=k7+WvZ0aOuqDrQLrk4s8LJ2lZixNWnQh+kPTnMGEgEw=;
        b=dwRehALka8cenp3X+SRi+4Mhl0MoW6BGJBV1eR6mWQUYtd7fntnh0An6vWdP7G3rjr
         pB1SZGGMaUHphAAEyR0n/RjL79D/+o8oWYQ7t/PLGJwzXYDr4VMnjYkAxycuLl7q1x4H
         Jca3wk9jOc7iMRBVKovGEv7FhgGx0mcgOo91jUZQH5QJzQctN/BaoclJAuAN7GVhRR8C
         h7G3AmbAfflwD3mmTdheA89EHqU/3+axwRIFkfOC3a/WeAAsCKWmXtSZRmppVBQxt5S8
         +AvV9vkkzxXCYvKgZIEYLkHSsA4vGgO4FSqM/45FPSXMN0HPRCMN3FqDEG2qRcxpcr9v
         Q3Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794869145; x=1795473945;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k7+WvZ0aOuqDrQLrk4s8LJ2lZixNWnQh+kPTnMGEgEw=;
        b=zJgpQzkOMLjXHGP/AcGFVLqCjClCS1SZEm7WaMTCMZTtt6+q5Mlelu00NwRd3WjNRz
         sWCOvv2gYZzmKqOd5Xpa43pSmnmz8C1PggxbzYkCEO8+pX3HRyBW3AqvF0qw6hMVrthq
         80904L1Nr4/txWm1ZrpeNYY4AJP4H2CUu8xbs2z0CGUeV0L4KmtQHGye+e9RHzV9CKIT
         2BZZ3p+anDYd0WHRSbFg3S6DiV5iyqIXQAMv/iTnNv8dozDkww7y7CwkSqKjsay/i0lE
         7wVCLvkMmEaoEbINmJskqam4Crnj8wOA6HpqILJ3UAaX4KGlSWgohcqy+IawODd1FoT5
         p5wA==
X-Forwarded-Encrypted: i=1; AL+hErF3W6xMbGv3gx7gZZKo76Po0aZSetwfI6bzo01h/Y5PUbD93aNdfN+w/UljvwcYdzPld+eaimJcjA==@kvack.org
X-Gm-Message-State: APuU4Z//8bsGYzOHLvclZBu+iF7mBa4vyojss+QoGQqyvD5VuIbaDPK1
	p9QhP/m+siKIJJkHuyXjwiks36hD8IZes3GJiv11KIRLjVKZEspp42Lu5SkN/IKbdqvg5k+TTo4
	BNC88
X-Gm-Gg: AYBFou0px4jtVptJM/bhollznrOolwYQhMQJCRqnIWk/ok1VETJIZkHV5tX/jdcuuHd
	rU9MpP/qlDMjWEeyNZqB68gz7Mjtys4bcgBZeFHVaZN3u5OMOfjI95TG01SBblEFZRy4jkayQqq
	I/q4OfwElqo7PZENCX4SYC/5wwQrRfgkk47pOHpO6yyNNXjKHS3aMt6utLL0hW7SGL+2WtAuY3Y
	ZETNhhr0zunU6Z10NW99fab4NY6pgyeVeOf08l6kM66LbYEzpXeSkIwhuj2hYlvEOuK7xrhqXY5
	RxtzxuRG9uudRiuKnqXstwqrCzRYAnXXYmAcGbL8E0P4T8eLAvXX7OdIyw6OSuqgxuDJOwV40RD
	Qom3CQx+Y0m59BgeV8I0XekKEdPM9STLrIdM8j6iglW+QkQaKPHxcrQMlxC4tp/VX2i4X0hQDNY
	n5GCOjOu4+KiEUT2lBN92AGk++iKXXH07bTzVDuAtHYP+Kib2CuKFJ3TA1gQNFddzkrnSXZcyxR
	9rUQHTAHN/wIkhHdSki1bEOjZb2U52UhKM3t/lFGeADFUYmntxTj5UqydRDIeg6jQFWn8Kz1lyV
	qoXIdBffy6w3nwSWJ3sgqQMdoZpz6uFAO8VQLtzdjxhaW5PJRH+jBSib0wa6VTXrSrX1IBtDzxJ
	I/AKJBTrnXg4jJhuI2DM/l+HDbcve/QN9DG9DCOCPfWCGDMo=
X-Received: by 2002:a05:6122:1d45:b0:5ec:e128:2c19 with SMTP id 71dfb90a1353d-5ee34afd185mr4178359e0c.23.1794869144703;
        Mon, 16 Nov 2026 14:45:44 -0800 (PST)
Received: from soleen.c.googlers.com (57.233.150.34.bc.googleusercontent.com. [34.150.233.57])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ee34e3137csm7011494e0c.3.2026.11.16.14.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 14:45:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH 0/5] KHO map
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Tarun Sahu <tarunsahu@google.com>, David Matlack <dmatlack@google.com>, 
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
In-Reply-To: <20261116134013.1636689-1-pratyush@kernel.org>
References: <20261116134013.1636689-1-pratyush@kernel.org>
Date: Mon, 16 Nov 2026 17:45:38 -0500
Message-Id: <179486913878.127049.11178890384802388709.b4-review@b4>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2994;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=B4tBNQ1Z7VdtzwiInC3mDSvjqCs8TTj8AJu8ec5+Ftw=;
 b=kA0DAAoBu3coTNtzet4ByyZiAGr7h5ajw+EgnwLf4K1QE3Ey3wBrMuunsyLKn4FwzG4JaTR09
 IkCMwQAAQoAHRYhBEExqpPstG8a8H82Yrt3KEzbc3reBQJq+4eWAAoJELt3KEzbc3reexgP/iNJ
 9wngObtxeMjseUrGIZO+homrx001i5s30BEDOoxaOnc0JLX0k6wLSKqgU7aGykiWFCsycGxxB9b
 c29M5wS9gxdM/pcu2Xw5N70dBLhpdn9+haQci07V/zrd5lMrfphNFYZwqjlWwbiALzVcssvLiOD
 6UbaXW4F2dIngPseFhAnnXLKgfrn9J2HpO11t86+d5RTjj+UTj4pu7l8ZmzffBTZJS6uGXWkLGQ
 E7FhU0knsnp/EwrkIFEdlfVxywUvoFyZT2KmtpAFNboSsJrJmJR1W/gr2ReuSMOPwZb+36pn307
 qlchMHGrpkxxKYg8XoyuNXO4eOYHIPQiVkDGDYNoKrUYJPsuuuyn5RpSDBSpBDFbr8ZK+sPZWPu
 TZnI5Aexi2UPJFvXfvNhWNCaeUOUQMSWrbfoTaYNF534mDaCAKajs3cssYoD04PdOruWTDEOt+8
 oL3aJMyFRagxw4GQT9JZB3SLi4tQ/i1ym1rDfzxbdrAVVIbB7noxj+h+2U6Rj7W6bJUS2gnIc8k
 H3OrBYHeSS6ccJcuolC8taHqSp6qIY057JLomhydU/L2vC98fy5zipt4VeLuYl1Ty5BUAbmly34
 UZJSzl95wNhO1dpC/V5Uazz1WvnPgP/MCzzQDw/eXmunJU6ptZeKCrcSEjxNavBkmfIr08kd8Bm
 P9lPZ
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: C4E7720009
X-Rspam-User: 
X-Stat-Signature: dqiwjusi61px4kyb6zbjcpcm13ypoizp
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794869145-944019
X-HE-Meta: U2FsdGVkX1/mBISli1pZs/pJop1HFQy7OABd/T1dmKHUsiN9NFnOp5VzEgk0kLamY0nRBF22zSCZ6Ym//6y4VDH7s/uW7T5eG/x9Tc9bJFjxQ2BiylvvuPNQgz4lJ9pAcLKBbBpoYhxq6M9dH7NPEAaTO/KPIZtmnOFKedQm5Bml3YJkfNRfigqQzlWyDyqyCxhPOw1qcwxyUN4dnF5t26+nOgCftS69MjOdjVFHmtD0O80YoVgePg64Q9zvQ3inCDYH1T8Vr8/md2Fw9HpcNbHG+dFWZ5v4iUGx2Z6dqIug3Rzjqx7BS98gAtbBTADcQgym+wKnQRglp6O+HMmHA/D2jDOE5NcASsiuIALyf7RpHVc2GQra1rcDElnCVxgPZqPbba140tLrvXn350Q8ovBVOw6iTbVfw/D/zCVAHjEB8DaDfJPeok2JGgDaJwnF0GRQPmM4f3Q9qb+7nMUtX1ViOxl8e3HvomWrASyKbQVYG2T0O+ibfPSuU+4FpTV7S/csFgqkkIe46l3Z0qxaUHSx0Os0yl6oe99md6d+e7SI9xQh6yPYYUBzuzWsLZhNCnf06XNwmhdSR0QxEwu15rbLZ/BYXJ17Evs0ZuHN1oO3flCQVYJoTvJ7lXC3ho9Dr5IRSNmBOlNw56+Gi4RON1/bflnt1Uty6H6DgtAbw+oXxBwWXqW3/AgY0DhukTggLKL8Go+4q2erJ+9hqqfCheEIPNzEt/9r7xEvNllHquTmO73fd96z3azGLIhXj8svzAIj4HFwwUWxd0Qgi/znX0XyXULXcx95PZ49HRcwhjkQJWHwAd6sNA1UlLAYDtB1He8Au361aqdqH29Aqzljo7aOKFYdP4JB1UCxvGguK7QtUj2TJkW8CFn9nxVkzZBgctUmPjlhledTDRPWev5N35Y3Nf1Fv7/cnW8cU1xrTJg+iMCOYNN4Krb/n/74sYD+TuotrKSQ1jF2qx7GAb+
 fu2e+B3C
 Bl9ADIFx0FFvnravQei3rRmuTZhofYPoDSY+Pi2Z0s8fBgyR5iIGfQftoe8xSYz1rQ2S17gL8bUxtnCaxOghVrBlkrDSuuGUxvnukU/u4IilXc0i1MaTv1whGPzFIe3hwVHIXStcvfuoYB1WRn1hs/cAYtQw1lkTgAQI7tTgyl05S5ONePEgOLyWS2OqoAXz2fCm1ps6YiE7zu3vGo0mOFwKZOhcAbR2hsyv6dTbaZXTJmvG5gdWDFcMVBG8FAfZAIUboBtfBPYmAErwrWwK+XDcsfs1GUJzss8SJu/reUkP+XAeUCWDTZmJxRL66cQNEghe4Wnj2sDWSIcdOqqWFIn3rRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,
> 
> This series introduces the KHO map. It is a sparse map from integer keys
> to u64 values. It is implemented as a radix tree of fixed depth.
> Currently the tree depth is 6, so it can support keys up to 54 bits
> wide.
> 
> The main user of the map is memfd. Currently memfd uses a vmalloc buffer
> that has a pair of {index,pfn} to track the folios in the file. That
> uses 16 bytes per page. The KHO map uses only 8 bytes per page with some
> overhead. So for a 1 GiB memfd, it uses roughly half the memory.
> 
> In addition, it is a more versatile data structure. For example, it
> allows for adding or removing pages from a memfd after preserve more
> efficiently than the vmalloc array.
> 
> Post-LPC 2026, the plan is for KHO to maintain backwards compatibility
> as much as possible. So this data structure allows the serialization
> format to be more flexible to future changes. It can also be used by the
> upcoming HugeTLB and guest_memfd preservation.
> 
> I have talked about this as "KHO xarray" before, but I think using
> "xarray" is just going to confuse everyone since it isn't really a
> xarray, and the API works a fair bit differently. So I renamed it to
> "KHO map".
> 
> This series isn't complete yet, but it is in fairly good shape so I want
> to share it to get some early feedback.
> 
> Things that are missing and planned in the future:
> 
> - Multi-index entry support: currently, while the map is very efficient
>   with 4k folios, it is horribly inefficient with 2M folios. Each folio
>   in the memfd takes up a full page to track. Multi-index entry support
>   can fix this by tracking entries that cover a whole page in the
>   previous level, similar to page tables.

Let's fix it, see below.

> 
> - LUO versioning support: LUO versioning headers are still in
>   discussion. This data structure should use them for future
>   extensibility. I am mainly waiting for things to settle down there.

I would not worry about this. If versioning lands first, this series can 
be updated then; if this series lands first, Tarun will update his 
series.

> 
> - Dynamic depth support: Currently the depth is static, so it can only
>   support keys up to 54 bits wide. Adding support for multiple depth

Let's allow keys to cover the full 64-bit space from day 1, and make 
values 63-bit (like XArray), using bit 0 to distinguish a child node 
pointer from a leaf value.

By making it generic from the beginning, we won't need to worry about 
ABI churn for these features later. Instead of caller-chosen depth, the 
tree should grow (and shrink?) dynamically bottom-up based on the widest 
key.

Plus, with bit 0 tagging leaf values, 2M entries can be stored directly 
at L1 and 1G at L2 (on 4K pages). Even for huge memfds, the pgoff space 
is much smaller than 64 bits, so in practice the tree stays tiny in 
depth.

-- 
Pasha


