Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E67606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.a=rsa-sha256 header.s=google header.b=gRi7j+6y
Received: by kanga.kvack.org (Postfix)
	id 8B84B6B00EF; Mon, 16 Nov 2026 03:07:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 869876B05B0; Mon, 16 Nov 2026 03:07:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 757B56B05B1; Mon, 16 Nov 2026 03:07:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3D86B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:07:48 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1256160790
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:07:47 +0000 (UTC)
X-FDA: 85440253374.26.9A19ED2
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 82060C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:07:45 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gRi7j+6y;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794816466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Pb6xr6a8f5h8gb6JGzQgb39t7gGon62SuzmS0+FGP8=;
	b=lc7XVSdWKKyJL78nbmS1fOjwh832jtVuj4g7veNIipWAtv2swAo3tsBsnDBuoTnL6Y66uH
	gNvZByPxIaVmgvQZR4BxdEnIX+TfyhBkip1W1vcOBvxtWTF2OBzk5irSaMLov/9/P+kKHX
	ADRzzlaQO57QPtFlLRR1RkyNbcBTOvM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794816466;
	b=nk1GhS1VeCdAD/ooNxem5bGDGGfDfPu0J7cvsE3g+7zThK4CHEgXfzN72RzolZutuGeaxE
	RalSEQIvf7i646km89VMwwgDB4SZQOEz+YGi1iCPCCR36P/THikPrarwsrADUdCmgvqKlb
	HH+aO3jPbu02I5PtfThoYh/d4EcPxzk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=gRi7j+6y;
	spf=pass (imf10.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4682977f9aso457177666b.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:07:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794816464; cv=none;
        d=google.com; s=arc-20260327;
        b=TtY/1qBQ8Rj9rkRN5E42VS1GpahR7D+jXhBHcFogz3C69e1Mk9pmBnPB6vRK1Lb9rZ
         wSG3qbgILrcdWIehTTmNfty2u6UWngP6bb3uFJNufEbD+OJv5wCfQwuaK484YUdBh0yF
         2VtVG2chBzKNAKTKQpv2Mv67VzYePA0uEUoz/XjJHg1kvsxoYYJvu05WbAvaSP5RHOCS
         syTYHgaiCzgrgb4zRmPat+TpXfoJKlet/FL+w4PZvHv2i9JjGMeREmH9n/9vv/Fk5TwO
         uJpXLp2ZLXd5fSZMiVTOl6PTd5ho5iDVySjC410UphoS1rEz1FQ/3aJaK5zfGjiwblEt
         xw0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0Pb6xr6a8f5h8gb6JGzQgb39t7gGon62SuzmS0+FGP8=;
        fh=8azbulizXVq74qzqwBjK0OeDuS2hLbvI4bta8a3RBi4=;
        b=dBD7KH8Vs6Z8VQuxX5ASgw7WXGL4VCua3sVpzImX+hK8uphkDUBAWVyI5nlnYu7LfN
         b7842O6qqeN9Th+uov2s/O7v8Anj85S+EBXZb5yEdN8/zIGRe2wMM/PIVEhZxIzgDlnb
         OBKE2QLdlRiIrt6oERBo2m4Fq+0cJHK3udhTtecHE1UdxvIj7jkqXIvcE1heyjkEFkPf
         J/X1Ijdeh1M/yRwngGSl8HC6AWChnHFzfRw7fWwwv3dn/NeoN8JqmZgcwz4rHkuwZL+X
         mLhVPxgJ17FuJhyJl8kJ2rkWUiofJbPTWAm7VmTxv1E1CzZSDdjIlJy61QbRrUegYrvb
         6GlQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1794816464; x=1795421264; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Pb6xr6a8f5h8gb6JGzQgb39t7gGon62SuzmS0+FGP8=;
        b=gRi7j+6yzBoD3cHSc9ii8OoAzqGK2naECdsay7hWDDjOpnoWzLxKKR5y0Qa4z6p9M7
         BGfwTYHCI45pBiLnUB3OBmJbOxgC+g9l3n1JU/ukxj0J7tlB0GRhezsCYhqtJ9I1ITe2
         fUU6CBxbwUMSO5j0sx67prBPd0DcViW8ImZpeXAn4aVDrWAj/kgKvMD6Fdq/7k0ToJwn
         0rLJZR8DlQerZ1FkEbSfGFneIkZ9c/50WlUt5lNAoyOdNRAOoQlRfsmzPBysYzfGKY2O
         a8F3qbMCN2Ta2Jk6yUOCRWQv7cG7X3FMK+CXDg/jpOfgvR2JnK0WPQyeSnkR5WODzgoY
         UhBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794816464; x=1795421264;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Pb6xr6a8f5h8gb6JGzQgb39t7gGon62SuzmS0+FGP8=;
        b=uAJo9/8R3a5OMzgZAn+qAgeyo8hMb78PhzNQ0M+rKQKyAtlTu4ABQMQ3aAnz/5NG6K
         0jb6ZhwQjWMEzNguihH07QeqGhxxSgJ6FZryWBaGas547kSCDiUCYOZueJw7VmqOT2nq
         ZVUwHT7YksiJz8tuJ/geFKhuQq3SGHr1pNPr/o7njW2e0VyF4PCRm3YR/SG1Rwr0xLrz
         8uubbc4RZqq1/fPufKbTIGlDMJQFHMTicVWcC86kd4ze15kjmebAtbRGNODxlknZa9V7
         VYXf9u3+DojhXc2PLgFu/P8qeTw5C5jnlnUSLdrj1FAxG8Hj2/uWhPY2zHd3T79QEBDq
         6iIA==
X-Forwarded-Encrypted: i=1; AL+hErHIkWNGTBiOvAryOqrOOg7zjmOnmlXwh9wBYM5+oiqfEvmKkKBFbNOJbe0Y/p0ucs05NvW0mGS/3g==@kvack.org
X-Gm-Message-State: APuU4Z+tFVDBe9SZcJf7Dga9g1uwRXZk0kvuFeGJ3d54Ab77RBkcYUDQ
	LqtkjSwbVQYyWZ9gJIXo07LKmQH69woLfm1z5qWaTOhmbZAgOLxa7OLrHIRncioHb8OnjPPf9rJ
	MKAJ2S85qBBjLAUVN6s8CMIh/91rk2Y6YlB3r6w5gbQ==
X-Gm-Gg: AYBFou0wbs2T0PBs61KgOFy0qCi5ISXD7brUFy1YbFFJ0OCMT2tg4Eptmz8rrkL3XnS
	uJo/jKbORF4DyB1swlSB4fxWh8+M+yB7P9sloFAbg9od6FgO95zfbu3K8Ln38O/a8EioUJ7ucf0
	CKtfd6fhYXOjqFdurpxsl6hpYVcanQpXg5V7bOFVBxWxspWev5logRrj/Id8G6rPv1+tVOfxurt
	m2a+kT5nrn6vLoSHnQ+0sVq3IoMjxgFuVKUhFMyoygHcydXvv3CkgewoalY1UYQa3DcZo1QiiyD
	gNtFscyIz2gS5GPVEIwfhq2EaNMyoGM2mV4vPEIOhhgpQs/StpSA63aQTRzHMhx5VDeXYze+QoC
	RwbFefWR5Olm0pNTxs2Bjr4qKAk3Lbf00t9U6TRMw9orirl2fYo15tIgaJyZMVuhm3A==
X-Received: by 2002:a17:907:c06:b0:c50:8d2b:4392 with SMTP id
 a640c23a62f3a-c509674081amr685735166b.49.1794816463797; Mon, 16 Nov 2026
 00:07:43 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com>
 <20261103113711.1832834-4-max.kellermann@ionos.com> <CAGsJ_4y+LX-CSnDJ59VT2nc-i=rB=4iMuBQYawMCktk-_SPykg@mail.gmail.com>
 <CAKPOu+9XP8CP-EiLqd_Q-F6EWUQPgi4Ysz7wu8LZijR+j0_uyQ@mail.gmail.com> <CAGsJ_4zp8WJosxkVwRtfEvySBwp38bLd-0g6cV0G1BPb2V=hPg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zp8WJosxkVwRtfEvySBwp38bLd-0g6cV0G1BPb2V=hPg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Mon, 16 Nov 2026 09:07:32 +0100
X-Gm-Features: AclHuK8pcuLrqZJfU1rZDi9Fc8JwweuaSuc_E2UFqy4M0KZNmfZJEbG9gBYu1Ng
Message-ID: <CAKPOu+9+NuwfDr4ii2nD2Uk2DWFLqJsDro_O=FW073oEF-eBew@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: nwahqxqe47f5n8nh1eiyu6pqyr4qanu6
X-Rspamd-Queue-Id: 82060C0006
X-Rspam-User: 
X-HE-Tag: 1794816465-809588
X-HE-Meta: U2FsdGVkX18XKwq7wpigqENZYs5cy72wr9Ob4/bROhZicFrwBgEBXPdC+MVmP/eQPQBo/j58KzdmLjN5O/PO3L7lAL1bymMtmtOb15Jmr8nd4JGoxd7nm5MgXHE7C1YX1o/T/3LGzH/Q4LJu8zdCXQBX2FZDCo4RpT2f8ij9HAJCw5woQ+JyEjNzaicTh0BDu/heQxdFVMksbVgu7qgZmARbWEO4qFKIJgoDupO4dBnQQ3ONJ2T1EMZFaEcNySiaRqKAtH7l3gLL9hfdViGlXX/4FhzIFsQXUeNZ7h7Ea41gLd6DM6WjdnBHUxhIuc08IBM9Ml1Vqr1+VcC1zDVYTQf6RwhF4xdZfFjlSQQRUC9vkF8cxXTTMpoo06c4GAZgFexYsGnaYgDVqTEXsj4Vzu8Y/QfYrC+7tU6Aasv4dv3F2r5rhrw2KxHxCDDONcfagHQDS9Ryhylh0BrX+rJtMszUyQ6zzJkBQWi4AJBKLDlvRqfJfcayrhLHlq4z4gE72NlLI7RVaBXwqrI+cp6mZhRNN/w+q4+bvFM1dRAKZwVsyTmg3jTKYM9QfH5wTSmVD4xPJExE+4st9e9YRGZXjRV4+OXOh3ejHyDwjPwqNM64OVqH6G7cof7Ivue99Rx28TLz7rvSAobh/Z5H6mgmjHI3cthLGr1dLkWqmppBdlOe2c21itC3+7QoZFxcLk0Y96NQXmr+ErIvkq918Yn8GZKn7yonLqoaed3WiMB7VJFPKM2kdiBeGD6Y3mlxtLGaLCs2HeImvPjdrkOr0AotXu660YlL4kET4kXxSxXvjNo+6ss7C1LegbB5sCQSRP7rv54pu7mVZcJTzIZZvO9daM18PwTrq84A+kFLsEIYweLRQjp8h1T3d5t1YbkoPk2e2mKJKxwiGconzIB7Ax87/kH0cUXf+KTwch2osqSL7HZPDNUI2CUokLWVgKoRO+t+0BjiY7EhEggFx79Yaoq
 y3YXPZCN
 tv3s2AibPyvh3BoNmQGkypjizUbSLNHptD8sgRBJpLCFiZCWUCYsZG+DVekLLvUAM5idNdzbk/s0avREFZUgoBL8jbURQTrgj7GtAUNsq/ojFcH7/1byoz7HUjQB3qLIEf8dwCnc9Y0qJVJ/S9X6OMBYx0m6RIboJDehWVwK1H4QtUplPFJ6U/GERLaLMhsxlv82eTccbJbUdSLrWW1z8OltlmXpyiPUjSGVh0Ri8JMI25018HuOOo+NnDAqAIQLKa4JHT8oGkdykjaHxYClBvifnulgLUT8/RWSGh5LZZFsWKq8u8xeaMPfb1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 9:32=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
> > For me, it is not entirely clear if a stable backport is really
> > necessary (thus I did not Cc stable).  It's not a bug; just awful
> > performance when you have thousands of memcgs, but few people have
> > that.  But that's up for you to decide.
>
> Okay, thanks!
>
> I guess we can only reproduce the soft lockup with thousands of
> memcgs being rapidly rotated by artificial test scripts? In real-world
> scenarios, would this be more likely to manifest as a performance issue
> rather than a soft lockup?
>
> If so, let's focus on upstream mainline development first.

I did have soft lockups / RCU stalls on a production server; real
workload, no artificial test script.  The workload is ten thousands of
containers - it's web hosting, and each Apache/PHP/... process lives
in a separate container (cgroup).

> > > > +       if (at_head || !last)
> > > >                 hlist_nulls_add_head_rcu(&lrugen->list, head);
> > >
> > > Do we still need at_head now that MEMCG_LRU_OLD has been removed?
> >
> > Yes, for the "!last" case.  This is, unfortunately, a special case.
> > If you prefer, we could move this special-casing to the hlist_nulls
> > API so callers need not be aware of it.
>
> I mean, you might not need `at_head` at all if you rebase your code
> onto either mm-new or mm-unstable.

True.  I did already rebase, but did not post v3 yet - `at_head` is
indeed gone, but as I said, the "!last" check remains and means the
code doesn't get any simpler by the `at_head` removal.

I'll post the rebased v3 today.

--=20
Max Kellermann
Principal Architect
Hosting Technology

cm4all | Im Mediapark 6a | 50670 K=C3=B6ln | Germany
General information about the company can be found here:
https://www.cm4all.com/impressum
A member of the IONOS Group

