Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CFDC54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA1E6B00A2; Thu, 30 Jul 2026 05:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 691CC6B00A6; Thu, 30 Jul 2026 05:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8766B00A7; Thu, 30 Jul 2026 05:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3696B00A2
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:41:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4170A08EA
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:41:53 +0000 (UTC)
X-FDA: 85044951306.04.365B491
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E7C8C40002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:41:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGAFEkP2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XGN7LY7NQLvXC+r+ZudwXwnlP8u8gr79l7lLScD7Ek=;
	b=NgPvGrhL3plfXTFbdWPoMsTqAcB7oIFmjwuPkXBhuwEsmNEfSJpMrLUOhga5yePgPMVGGn
	4gVCyrwr+QyL4TVty4Nlh0EdrUdGYH3VKE4r1fAawxPIOK3/D92uiAaKOeGXqzPdIITQIz
	pidQsMXcEZJ5gZ2zV6XeDX/P0LP7wF0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AGAFEkP2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404511;
	b=VFVo05q7fZRtto7sT0HGUnLUMLbxcjRKyEJ77lvBN+s1D/Bym1YdGKc3IMlhESyRIue6Fd
	573iKKGaqqwgzVtkCp4GnOsHkqIq4OMaOuDeq0kglQE9hMhyCAsrMaBq/dCKHkYXYHBWNQ
	ROswfVB5OUn6xx1giLvB5Tp+KoyROpM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 77320600B1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311D01F00ACF
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785404511;
	bh=8XGN7LY7NQLvXC+r+ZudwXwnlP8u8gr79l7lLScD7Ek=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AGAFEkP2LX/I8y25ujAs3D3HAPT83onc1iifd1xk4ev2vLc3wWkO3teRE9bECFOdE
	 xl8Zs3OEJVmNsQHNqYWErZLXylWIHSzg9vLTaQ6FC/O5KVqSRIbYJ9Qv2MUbCAdJSA
	 y0jfOfAm4GMIk9BqYP71LAcwAFMgA6uc6gN01THMRr/xmMZY0Rgh41mOSqU49D6jr8
	 YKFjN53lbPbdMpN4tGgj02g/jOfWouWPJ6LbWBXcuasSBif1AQ4HEpqk9G9ZSWbBDF
	 F+MKvG+VyCVJEOyiKvS+2Zanrcn0Tf5glieauV1W+pwU2sAfr/gC9kCgB0cvEXYUuH
	 rcr0L1va81IUg==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-902e4af2d9dso4567366d6.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:41:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoKHYQ7f4ldl+cAUfoO0FFWNyTq30S+ZC/Dbb9iV6cpjY+qM8yxLdSljCNABOYX0x1YfPWWR/RR+A==@kvack.org
X-Gm-Message-State: AOJu0YwkIyA+nCK3gscYtAT+8WE6aWzi+IfOET8mnWVPVyuVXGJ9Q2Lj
	KguDfKMZqSz2D0O63uWWmechRJfw44Q8iDV26HL8hO0GQ34yuphwP47LHnabKGKPr9044NuGYLf
	OYZ1f3oDTlT7s9EGFEDx84oDOy3/dvGw=
X-Received: by 2002:a05:6214:4992:b0:8f1:fba2:d4aa with SMTP id
 6a1803df08f44-908350270f0mr15477476d6.16.1785404510543; Thu, 30 Jul 2026
 02:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
 <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
 <CAGsJ_4xnc6HzvoNeMmcN1yOEnXC+adVO+AT+pOsxyWhhUcbXbw@mail.gmail.com> <CAGWkznFCzz=ow2eDyzQR6UsAkLvuamEYpyc4PXJXXd6rF4HHcg@mail.gmail.com>
In-Reply-To: <CAGWkznFCzz=ow2eDyzQR6UsAkLvuamEYpyc4PXJXXd6rF4HHcg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 30 Jul 2026 17:41:39 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4znO0fPzNBH-CMakf5hcTFyh6exBTEhMZ1TRmn6283rOA@mail.gmail.com>
X-Gm-Features: AUfX_myKFAGiv1-gK5tY4_jSO7CZ9okPlYrgDUvzIIETvUqfukLbTQ6RDtqniws
Message-ID: <CAGsJ_4znO0fPzNBH-CMakf5hcTFyh6exBTEhMZ1TRmn6283rOA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E7C8C40002
X-Rspam-User: 
X-Stat-Signature: ms4cj9n5ndogaed55hspjaza43bitemw
X-HE-Tag: 1785404511-43606
X-HE-Meta: U2FsdGVkX1/pyWRCmBMhSE7y4FmkL6OlKl1Hig421cp8ruWkUHiu2LNOxriDJzNVzL+r9jEgY2s0wIJqJkmDFKAKzy1adHhgekiAjGTXf7LFpnhpeuePF2qHHpXa8/r+XrhEzK920vLta8+LSXAjJ1boWydCWOqMnbKkoyYsNYCj7dtnlGGJtaJ24JyRp5ugP6Cf3JQgEgnpuXMbgO3ZI+v11zVjPJTbj4S3Vs5xK1OPDNbdSyD2wpNLBdQutAyGQVmkJ61NOuXMrYlTkeCmcvY2DVHq2ynmpHdOhV1D8B0tp0zPWxBZVd1OQI/hXtHX7+mRcPgsjLjGi9nO4UhRSjB8//g+v4pRh15VdtRQJ7HIWVDIPOxoCNSxpyPvDliURmBVlG35i9Qgr5Jf3ISp2srKOreyXHj9dSjouOu2zu9ejCc+qaN3EAljMyqDCr9iw6sXeUuALY2837oNfysoZRhOVeoyfe3Sm8UrjNvjEhJhAWxw+VnKKHlWVQ219PafBNfBkjpB1gcnOU+pqAcyMXbvoh9Djh7wgCooP9JOfYzeGPXrdkAtCt7cS1RRvNMDTuwjcbh0K+VknGD+rMdRDkCTSCQayhcsQbdCnI4be39o8mpyFVhjwgCBudbC0lUaRi10IRxOusf9dPeO/DqTuDYj6Owfmaely3WWHXr0BkgihSKZFSc47pha1HVlsRHKTW2af04Kdf04uTqNG5uQFqZf+5btSfhYwp8wvtX5D7pOvq7b59kCRyJzmJGV++2H9jBdFCRS0mT+WNMgqg+MzN6ulhe3LqlFOyySnsIm7ucC5av2P/seF+QxOTuPQ/5PpXzUQOikJvYVcLWFeG/N8/OwGV54oCGvteopmcoJiScvqBcvkXtMjJuQQ/kWtJ/9fAdFOFCi4SznLvZ7Ueb99DeY6Pi2w0cxJC/5hfkf7wip3c/czISVEX5V5+eQaF/if7+Kpqa3Sfj3giaRFr3
 t9aMlAPt
 CnMB940lUruBLy8MbNmjXxMXtKw6MiPpuPWsYL826lZf5h6EkXaT/n8c3BsysyqecWM5HkL5FSlhDzw1kVbnyiUhbZgSkX8ulVKorPf6Ia3QlmpB3q5wAy3wIIzC4Mj5ep4frS2F8ASooIZdKIe1EcjMdEt+BrN0NgLn4tH/aNV5tQydSiTuJ6Vi+2Zn69IEmmiSGODW4+umDuWZPXAfiamR2YTrkGC6KkX+cvMUdCy7sFkqVfvupB5FNl+vJnFgGL8PIA3kt7GmAbNsQVR5mByyB6zu+HAyrPo8UpH9hTJVW0P2I9+My9ZB2UfqI7jFuq36jGY/d2FbJ8yFuPmQBct9h5w0MEQ26oESZ8vx5BHsykGjJIl5a3F3Z6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 5:35=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail=
.com> wrote:
>
> On Thu, Jul 30, 2026 at 5:31=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Thu, Jul 30, 2026 at 5:20=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@g=
mail.com> wrote:
> > [...]
> > > >
> > > > This is very weird. This seems like using a sledgehammer to kill a =
fly :-)
> > > >
> > > > Do you mean that isolate_folio() fails, the folio is put back
> > > > into the oldest generation, and the next time it is scanned, it
> > > > still fails to be isolated? As a result, scan_folios() makes
> > > > no progress at all?
> > > > And is it because the oldest generation contains only this
> > > > folio, leaving no other folios for scan_folios() to scan?
> > > >
> > > > Why can't you simply promote the folio?
> > > > Do you know why isolate_folio() keeps failing? I suspect it's
> > > > because folio_try_get(folio) fails repeatedly?
> > > Yes. As described in commit message, the orphan folio is an abnormal
> > > one as it is on page cache but has folio->refcount=3D0 which makes it
> > > isolated and putback to lru forever and finally be the only one in
> > > min_seq. IMO, MGLRU should keep make progress with bringing this
> > > orphan folio together with.
> > > >
> >
> > Why is a folio with folio->refcount =3D=3D 0 still in the page
> > cache? Can this be fixed at the source instead?
> Yes, it is a bug and should be fixed. But I think it should not affect
> LRU in this way while the legacy LRU could move forward in the same
> scenario.

Yes. But, if there is a real problem, a folio could always fail in
isolate_folio(), or keep failing for a long time before it can
finally be isolated successfully.

I agree that we could apply a similar approach, for example,
promoting the folio to the second-oldest generation instead.

However, if this problem doesn't actually exist, it seems we're
trying to fix something that isn't a real issue.

