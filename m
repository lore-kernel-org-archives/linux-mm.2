Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3EF1606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 00:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bxchyc4J
Received: by kanga.kvack.org (Postfix)
	id B41C76B0B3B; Wed, 25 Nov 2026 19:11:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACC256B0B3D; Wed, 25 Nov 2026 19:11:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B9286B0B3E; Wed, 25 Nov 2026 19:11:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 719CF6B0B3B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 19:11:14 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CDD0DC01B8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:11:13 +0000 (UTC)
X-FDA: 85475340426.04.FEC71D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E61104000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:11:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxchyc4J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795651872;
	b=jJfAuizCGnyWYkDXh661lwUrT1WMElX82hpopmrfhnH4cNjZMCles1NnIDhAR1S6qnnn2A
	gmB/Uz92IlwaVcASAjNuLPMm+VN622yOL56SVACoxv/7C/vX1yZ0K6dqNv0dhxNs8iCJsC
	XD3SuIbQ6yznA/w3Qt03YYKirkSU9nQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795651872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RDINDvHKD6MZseAlC2/IPYtXWUlAArkqAjR7GnUg3Lk=;
	b=M0lPBvhfZAyVjNO7IGD4sxW6rQiF4eMjOt6idpcBIsdOqIIiQ1xo0YH4GFSt6FPLRuT/Vf
	zJoSe/Yv1njSkCNuS1gdeqw3eKVWUQVBEmPu5cuzfBS6hjzNXNqlqqULcAJ0jAHXwHYvy2
	K272kx4WT2j7PUshm0cw9hVMYLWLDfY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxchyc4J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A9AA410C3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D281F000D2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795651871;
	bh=RDINDvHKD6MZseAlC2/IPYtXWUlAArkqAjR7GnUg3Lk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bxchyc4JfjA37MYjy8kPfsVM9Ol2cupkuK0ohVXmFUTPfH6j3gHcSouV7rL/Gl5Bg
	 vE6fKxChav6JXnCWMZENtTaYOaEMteR6ijkUrVK5ed7GMnRtFXlJVjVnU8LmCLxEn1
	 6QXl6H69cWtNLEq3YGCm3XYWJCmqwJkVwVVPgVtySQeIrtyJVaFOmgqim+/r2CstDF
	 1V7UyX0tIhzFziHodoinKQ9JrFI2noNHZQs7gbIAeqaFA2PX2ZqVBR1mDI49AI4uAZ
	 6dpUWhqsfJjQ4PkBBAP/ItbaYuH6DxmchleB2vCB1B2PbvrUn7qprtIAU8cbGMYX0h
	 g3rzZYUMstphA==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9496577d4c4so707664685a.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:11:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFxLZP1+huVCtHH81UxnNHjL/jcjqDVWoBk9r6KpqyQnVqADDN0nlVZnuVAsjmoBbGb3xFbTK59iQ==@kvack.org
X-Gm-Message-State: APuU4Z9AevtkdyUbfr/iKh8PWhS7Wkzcye4jGeUYNcAe9ctQhS/ROufQ
	4xsHTM/zuasXjlqakzvOICZt2sBDdV9szzBC5/Z/m9ddNqoo9mV3q91l4udK58XyevrfK0WqCmM
	33Jrrl2KM6wbhVAOhV9e3qHtA9VJLEZc=
X-Received: by 2002:a05:620a:2585:b0:949:7058:dbcb with SMTP id
 af79cd13be357-949b35723b2mr3687848785a.14.1795651870358; Wed, 25 Nov 2026
 16:11:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261114200803.23129-1-baohua@kernel.org> <20261114200803.23129-10-baohua@kernel.org>
 <e2595c80-c223-472a-a756-d352161a3330@linux.dev>
In-Reply-To: <e2595c80-c223-472a-a756-d352161a3330@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 26 Nov 2026 08:10:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wTMF3qj5tzT1FtFDgJJAL7hw=Gb2w3uq99ZNrCK0vcYA@mail.gmail.com>
X-Gm-Features: Aa3M54qEbqb2UlKYb-QEOhd5-I-lklbxngV8mRirioZSLDDnWN8UWOGBIbJttK0
Message-ID: <CAGsJ_4wTMF3qj5tzT1FtFDgJJAL7hw=Gb2w3uq99ZNrCK0vcYA@mail.gmail.com>
Subject: Re: [PATCH v9 09/16] mm/mglru: Avoid placing rejected folios below
 populated gen
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org, 
	liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, 
	mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E61104000F
X-Stat-Signature: 5jwuuaonbyc77wp368z1q71mhz3di5xb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795651871-121016
X-HE-Meta: U2FsdGVkX18VW3F4IkczEHXRtwJk1DtYdT6gdHD/xfq6NrQCL70UDd/7ve3Eh7IHBGWu+fuAQZXwcXjXWRGTaWLCb4XoGOUBPHuFe/efidyfTiwNcBOWLSxwhGMYAK5Ghj1VB5RoCuwgO7XugG18dhStRwxAYJldu20W+nBZl/NHJX3bZKCsp3aPaH0NH20rJJLNZ1dhtGqU4sBSCSppTfAl7kTWmFMjAgsHoO/vYc4XOAGun/pgoXXfmv/8GTvzl6uWyEpbmQMvdAseIymqk3QulGYIlEoFtvsbOQtGHDJJtL2t72UBWOQpHkvj5dBuHdUEHKwH2hk015j+sd9qv8JA12lSyeNtsq6qHkadxXL6od9Q4JvmeLJkOqK3SAk2047iG8c7Qe3VULfCHrCgI5DqXHbAfuc/v9IOZbXCs7C3tp1fXpFWJSswTwTBDcXi4+bE9cIirwzCJzecruyrOw/mR/VCi4BdOOCu0liW2+eelcK3satnIvL8ugfY5x9bH2J31w0yOC5HWE3w3Zxpbu+/JvanvGytB1v9+VDejcYkd1ANZCYW+3fBMmE/F4FiwC/ql/q4aQFHr4KZ55Z1agIPhIwsIoCyEIIidZMPlWBP3cvMLo0SeAMXwIGn2A2VdUi3+G5eG67TcPg5LOdBGOhw43u2rIW20Pitry82DfVzGuAXA97bnizj6OCslGqX2eskjYK88Ui3vP4hKTaGy5kaQoypn7XPVDrS9+43aBbTs0cxpcgM3dlespNjk71G3ngtnEmqUeuPbe5Qi3e2NDVWe9YnIpK47Szj8G7TltIGo/cEnTElYAWto0QfJa4qjNfzlszXwFiAo1hWMG3SdJoFvisJ7mB5/95pgEGxQa25rPAnQi1IoXFUwCUkq02JFlT9ZSaMPNzMW/EKOeXFPHQ9aaAmSeY3dCdXavGAqagiHvICoIVYMtfCPinBM31oDiq2YLmoWf0Uo+SiyhM
 0zf/00II
 fE+5z7WesTi/6VwWC4blASSwbe+DK4B47b/WkxGOA0fFtdO8MBZGcdi8+A0rO9XBG44x3z/QTAGeuDuZWLADmWEI/94GTaBW8QsmJEzZdIItiWy10tC7b6W6RI4wB5aHu7drXiOh9XyLcLCrm1I5ZxfkKXFRd+kZAoy2ut8OHZOFKMTbl2ZvaWZDRtVRDbsHHWMcMoVwZfRIiXibOjOPwYC6h/ClecrwlCZJCHugqklqHDMP+NkJ4PVj3lBJgWvZAuY87xtmsGp0eDvq3ii17Y4auh49s6mBKZ4x8CK8a0KkSa2Qf2jz4Cry+VCQ1snbG5dKaiVTo2S15FO6UgWIzk7Vgq8B+l84DW6fUk2qEcvpZs7APwAw31MqOzrm/VLSxkzx7MHQpSj++eAcF6H85CnGNfZEcDefKs+k/JAzEpZczuXyGjEagADBq1FyaCg4CsdzuRCI4WmuPhEGsFqdKRUPPsov9tToX9ruxpBXxHPT22rYJn5EtyaXwiG1MBo1FUY3a1vF2dUgrKTouo7Wv81sOYsIsybfbtAlCwUcBvs68DBGVcGG1kF7RrEyzdUqNZ6L6TQReMEb1MHve5h/bqmH6Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 7:47=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> > We used to scan only the oldest generation in scan_folios(). In
> > evict_folios(), we checked whether
> > lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_seq[type]. If so, th=
e
> > folio was marked active and moved to younger generations.
> >
> > This was itself buggy, as folios in generation min_seq[type] - 1
>
> Should this be min_seq[type] + 1?

Oops, a fat-finger typo. Andrew, could you please help fix this
in the changelog?

[...]

> Reviewed-by: Ridong Chen <ridong.chen@linux.dev>

Thanks!
Barry

