Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E6B606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=AIYW2sJX
Received: by kanga.kvack.org (Postfix)
	id 5CC126B05B7; Fri,  6 Nov 2026 12:50:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A30A6B05BD; Fri,  6 Nov 2026 12:50:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B9056B05BE; Fri,  6 Nov 2026 12:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 242816B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:50:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1514840187
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:50:56 +0000 (UTC)
X-FDA: 85405434912.28.9ED4087
Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 17DD1C000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:50:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AIYW2sJX;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793987454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUrssP6MshoZktd0NrO0Gm8SiEs8U5r/BOD5vR9U3Qc=;
	b=Vytluws/EQQgx9fLNAZqtdpj5jbVET1Gb0bAYNPfhIX3IF7FTHLfZKbEi3HXJBjocZHAB+
	LjddJQ1yKNM0VkyPRGllh3Q9B2SV++niCLNR8qZCht38JcwV5UB/ckMleoJ+LEAPzKv3hu
	ymRtJMJo61QhJBGIgcvtG+o4Ou+mTLU=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=AIYW2sJX;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.222.54 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793987454;
	b=gInPEMF/65HViR2MIOEICqgbnrRLcjWMTOUzlWOby1x4S5GNuGae6jaCau4LG5frpaQ3rA
	kD7w12yoPf720dZDs6e3/fp8RMUhE+u596D2k98DNo7fuPMAIgYu5xZGIuVqGS9LhY4Ivp
	1tSGW9u9AVdD54qpjkpEYBfEeP86Ryc=
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-9950a7530d9so405166241.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:50:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793987453; cv=none;
        d=google.com; s=arc-20260327;
        b=bS/XP0nE7DVRvcfsYkK08P5pkOoZEIELbSFneNt6p8lYCyuERCpbQpMMn9/mHkXKtH
         gOEIvB4iNhzvcQ31pfe1Gwfd8Hg8dCTg02+7qMMY9FYqqrNViDjaUgYK65P/e8y7QVkj
         xfQrcPw69FZyvfAFYrp6Z5CQWLBZWjmX+ZP1mQZLdwu48+C+kLH7S13e0/B7pMjjc+SA
         GE+HS9vvA/s5F29fDIx4ydL+5XwnlXbNq7M83mHrJEd6WWRgFQRy3mLP6LaahFG4/7uI
         dVJsY2yzstKommxW0ivendX49uESTUju0NLKRBg7wXvfisUePLGOz2U9TGMkc/FCY9wJ
         3KSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tUrssP6MshoZktd0NrO0Gm8SiEs8U5r/BOD5vR9U3Qc=;
        fh=/YAUCKv2nNUF/SiRfXnmYkE4JeRcf3Nh5pNnxdn4umQ=;
        b=jGdT6Rv31zlMhjDNREMbnAI5qy1RJPrpoy//iqGfk0kavLAsAHocWLkNSAeuMFGgNf
         /e4tRgzGn/EKgPS5riqytTvgleaGbvQRcEQK4nPM8luHeeJIqbiGivO0Nn9I+8g+71pb
         P2TEl03cF2voDcZ9WKL8eBQUOEV8+k+gTMYT6NjXrq+felw3buOfIEDoEiFnTYODNn1x
         /NoK71EU0c8T8HqoXUOSUVshISEw6BD22XFnKOpvJwf3h8RNOARQH53oB/iqf0UgH5Nl
         Ru/KrYM6ZuWqqsUt4ZOXDKDk6qxA2GP8e0r5XzJmJzB8/43x8iWX8doAIX2ZiaPm5thk
         QorQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793987453; x=1794592253; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tUrssP6MshoZktd0NrO0Gm8SiEs8U5r/BOD5vR9U3Qc=;
        b=AIYW2sJXCwO5qOduxRwfx+fh9lzOwbdI+56FzEIALrVKk0r1juO2vL3zCseojl3PNk
         Qce6eE1LoXWwi+loBBiNtL8R+UPdLNh/W/T2b0WvoR2tKERLlFDbAzwd3Stzra5YWRzh
         om+YwOpXV05xxaJjfMQfc9tjuWDsC18QxoEwvnqjAIq/zVz644qjrSWkN8r8bp+YQkFU
         gyp/Ko4med3hiBYhYF7wJ5Ba3x2TqmLY6xjGazpkCL86dgsE2I0Nct3vJsucOWVtUixh
         pIl0rCvkf9ML7G0mFK4GMrWkfDHuBWPwWlX0rwUBlXFqA+X75o47MWXnL5f4t5lEyuIR
         Ip4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793987453; x=1794592253;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tUrssP6MshoZktd0NrO0Gm8SiEs8U5r/BOD5vR9U3Qc=;
        b=cv+3PVqzxemUJ8jC+tBL0AiENsfeuY23cLdbyPtSKgrER4VTw8d3/p7S5fIcvKrEC9
         zY7l6TTxCpI6sYq2sAqQRIknDgsf0TUhccIoY6h683hOe1EdyJOiADgXW7s/SGeZ4DQz
         6SfohstM+BvnRqWMoGb1mDGDrWf+B9Of4Bpc8ee7LxbMOuFYAfZwiT2yGRW/q8yRtTko
         0fKuW6aeisqaeZVSGeYHt8kLLz/tYwAO94L7cd9wF2lpqARzE+rbPnlFQf/6G/FbHivI
         mL5VSMMbqquRip/CP/iY2yRXtp4Fr2hAhTqqecAjwWzXKW6fWNTUVkjWToXn2o523J6x
         gsUw==
X-Forwarded-Encrypted: i=1; AKwUvBy3oPBFSAHc7MCV+AMa6g5i1oyBt7CsKrIZMvXYm9UOfJ2zvRRrt8EYChwRRPCVkhU0Z0Bt6/tDYA==@kvack.org
X-Gm-Message-State: APuU4Z+r+wocdA9qUER6kT4sbNchdaT8d50PW35ZtZchKrj6BWV8CrFa
	aggPuxkMbfPpqvj5vrDbpjvnWogteo8RFXzxBlr1f+O3/Uh7oDMt2E/xfC86kxTmliUiRTQ/vas
	fWW6CuLYWCoB0ZUd54WKIq+Gl2XAsonM=
X-Gm-Gg: AYBFou1yhKKw08TrJ6/V5gO1dsyLKKGzEBqQt8wnQMninZ8dSh3duSdpTjHEiCliiYS
	26ewSRDrjclLwsGnO+KB3+7Tju3ctZ8znh/nN2C2RVe0Y9AGDjdUfn06gm6PDU9sSfZFm+CSHUl
	CRPfW6I93wWUfnVNVzqhreUddSBRNPi5ePqlvHpqaanN+NVyDE/4CDpReq5SWcIPRb5978GqTwr
	oqM1+YZ8GGAPIB1ZtPxwyd3L2hIkSIcq98oNMW1x7T2H0g9g7IFErTY2LKpVipVgPVbRZ8ONsJ7
	VBGxeMDp6BsXtSENpxlpTxbgko2/IsJXgpKdq+AV4mAFe1vAJNBwk4mHrLYdLK6hNV9ZcPPq93A
	I+3ddJNX0LMcUs60BobJp6d21uojanxvEkTDfq07jjz8xsj7V9QUwaF8fijD8ChN3ejIqUx1plL
	RgwDuv7wEd
X-Received: by 2002:a05:6102:3250:10b0:7d2:b199:670f with SMTP id
 ada2fe7eead31-7d2b1997cbdmr654347137.17.1793987452979; Fri, 06 Nov 2026
 09:50:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106172620.318113-1-joshua.hahnjy@gmail.com> <au4REhIF64b6TUms@gremlin>
In-Reply-To: <au4REhIF64b6TUms@gremlin>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Fri, 6 Nov 2026 12:50:41 -0500
X-Gm-Features: AclHuK8iqUYH9uwHjDssr02UoFzrjsc7Hb2Jh_xgaQ_bcnovytG22SUXrSO7fWI
Message-ID: <CAN+CAwNk2SN0t5LpuQUM4t5itG_rj=u0Kvs=zpKXhO0n5vhpWA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/vmscan: consolidate promo vs. high watermark checks
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Gregory Price <gourry@gourry.net>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: he61ddspa1m943ywiai3iee5h1sqfom9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 17DD1C000C
X-HE-Tag: 1793987453-736259
X-HE-Meta: U2FsdGVkX18m91iDCXpf5F1mhsEuqhpR2n+ucAAaBT/rSJ3KLkr1tO9JJko7i31c1FMCzMsIKzjxQ+1NstQZM1gZ5UC0J+Vdvj+kp4ETv/b4qlKM30u6xRCCDOXuGVX4aSe2cGvKbtgKhedKYHvSo1scjMyH+3+hGX0XQGGto8Me5V+WR0YuadVkN1+o2nN19zyZrhbBdWZqrjdgHcWz/nUfoUNwyn8JUj5PSjrzAy3vLTYCPT2KztT+vQt8aU+hS8JcqZnIXy6JoRfAAFmMqAyEgG9/YBHq5G4rajLbFRtaLpP92CDucizMKFVdmzC8lRyDC2XqjIV0SknlPkakK2PQy1tS4jr6N93odB8WSK2qyr995/ODHpDTiZ8Os7zSXzz5PYZ6BZnrzqR55EUdmQxiksEKDefpyLZiemXunXXGOrsPLbd/kqtB48Qv0VywliZn+fa3/E95Qygeo/wy0Y0wCFzH2XEq+SVIX4V7ClNxAZDAMk2m89RtxYTyijMpyGxRxtPUC7JWS5vZfzP/rtq6SmlLg8WzSr88k/6nEZw87oKIB0yxquWzT9qhYOUKIT3t0h9FpJMf0bKUnZDgLMrOI+CAlaKyBLUNlVE6dTmEuKjHHYUXz/N6lRfXdRja2MIMdZ3NeX3E6tmqh2bunCFjss7wjyy52U9tz8UlRlQBDDc5ec+j8o4JOZiq3hN8+7T4hMdC54A1BPs3uubPVXtAyWE+3PobKeqZkSOFpx6gJ2yVQ6JkUSe5T7TLSCTcPN0i5Su7lFqkhRY0+AVlg/ItzgMf9XjqR02/pN3hyUdBWuYv5eEjXOG1iAzOqVPHAQy61rGYSimvXQBzYHS8Nr22BWTUU7Xg/5YqLLGB4OWT9MqOKIJNFt40Kdhgyyk2Q807quiMF5GSbk22vEhAvviIZ/XteCSXtZS99tfNBQ0KM+c+mivS7vdujtgP1xmYzB9BZAFugMGqdO49avD
 ceYfNdi4
 2jyK4XbN/pwOhqKj8x09+fqS7L7hQkym5aKUrhYJvFJBiBbZgPmY9OBR3rBF4VaOHRY8c57FPC1BHK4Ar1atmUrUCeIQ9QqbUP5YQZzbTzXt/LQHYVEpbnjFWk4Uh62xsmg0Qx+w/o/0KKyH6PzBTrCElxRqRQppcOWwCbCnksnC3ZBF5c0ujV6ng82JYhIPIGBQ9k5wMpUz8BqQX1FyVzfS3r+HpZM7nFsYTM88A2Bkzwd2LAD9QmLdEkqmwrxyQmc8vlVnr78eSQbmB+WQ0JDKVxMXKYNDZ8GniKczE5P0qBi4dPINPlTe6hbUJw3dEXtGdj76Vx675sbgXaT7lrW6jtyN5o9yvkn2MmgNAn3N7cM6HtxOEq8R7x+lSIDV+CATUVvg/1OXC2D9rJMpb+7EUqNHxpVJuuzcTdobBlTS+/NyXyx/BlPLi8zckP2hiW5xJOcoekXhEKFUByukg+bJpEPkA5UHOUGsMJE6/uFE4oko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 12:42=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Hi Joshua.
>
> Please send patch series of two patches or greater with a cover letter,
> with each email sent in-reply-to the cover letter.
>
> The easiest way of accomplishing this (+ our preference) is to use
> b4 [0], otherwise format patches like this:
>
> $ git format-patch --cover-letter --thread ...
>
> (You've got 22 patches landed in mm, I shouldn't need to say this :)

Hi Lorenzo,

You're right ; -) If this series gets a v2, I'll be sure to add a
cover letter. I just wasn't sure what I would include in it that
wasn't covered in the commit messages themselves, but I think I could
offer some more explanation of how this was discovered and why there's
no CC: stable in the patches.

Thanks! Have a great day Lorenzo,
Joshua

> [0]: https://b4.docs.kernel.org/en/latest/contributor/send.html
>
> --
> Cheers, Lorenzo

