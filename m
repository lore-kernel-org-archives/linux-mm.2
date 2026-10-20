Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DAB0606A328
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 18:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WUBG2mD4
Received: by kanga.kvack.org (Postfix)
	id 4DD746B017B; Tue, 20 Oct 2026 14:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460F76B017F; Tue, 20 Oct 2026 14:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301186B0181; Tue, 20 Oct 2026 14:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7E686B017B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:07:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02BB1160348
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:07:43 +0000 (UTC)
X-FDA: 85343787648.01.860C22F
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B91F20006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 18:07:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WUBG2mD4;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792519662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Tzrx3HtUL23rsTyUgIMMsHFbitPGwqDqJbiS38hOu0=;
	b=4MefzWJaBMPWlFV5/izAki2gtbJyWtkttwMsQwgYzemDrlkP5POt17cIiMJGf8F/Vrzisc
	6A1dJVDkPkMWsNHNGB6n5eGbSga81igdLkDnycD3B3GqL/qJBEGwL/jZbXvsXmfk9nYGug
	oB5TZAc8JnZsIdXV06p92G/lBB9Y+vk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WUBG2mD4;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792519662;
	b=GjOXJiLJ8LnbNVvd4UR4HQi44GM8JNJn4qMNT4QJB1WivMUbZSNpY9IQp5LU4s605PgclF
	m6jMI/Mx2kFGXbeLhLOvIfFKH+ASz18mNhZCVfRDCr1bPRbYCBCLis7D10n8L8NrWl0s4r
	Tu9lCDpsuQEn3m9dE8K7V3bf+fQkiEg=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2acc1e170cso524993066b.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:07:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792519660; cv=none;
        d=google.com; s=arc-20260327;
        b=jo8++IDezAGfcxAUEGIl/B+5uUwe1xlbsppnLF0e40Fgw6WyvcV/7HYSxyVDeCq9T6
         jf6XKPZAl0IJjgbZr2MbVy3XYBQ4zAwamXsDVyO9lpZzbd34n5R1eu5Yw5HEM91XrF7q
         HdLkp5cB/TMw1zIXhZVhrwzeGjpj8Lr5zfWAICTn2oc17RJyKM48IMlnjOaX7R8/pcCj
         3PyGcsipTCtRmOOCkVemhIk/oR+pBa1+XR1k28Aa+XaGB/7gHrNXpoLWe9EvI8Bzo4r/
         TIQ/PbAvZeqWtlDafX4uKyDKjVpp5/5euFjSFjOXOFSEzJMiTe2/DnR8YzyT0tJY9/vy
         j9jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0Tzrx3HtUL23rsTyUgIMMsHFbitPGwqDqJbiS38hOu0=;
        fh=eYeMy6kmtuDiNmX3E8oJD5iqmdMMDtgHXH2/pUefhxQ=;
        b=fDsiRjXSfPQ5G1cfYYMBVdqY2YsfjxZqpCU3iGuLFcwvLkgkz9ljtg7l4vfwcv+RY1
         e0Fd12US8sxo1xgHAD7GCrKOBx0YGaKycSU+IMKJi6shyGFFg5G86huQZm0/jFzAPmSj
         +VZY4lt0JvjjdUkjoZvn97TiLxuCugQmtHXPIIC+AAFulsMBzaGGwLpK9zCvfXQttWD9
         iE+xKXjZkVq4UtSm/4B4tvKisEFwWJoN7a09dvHNpRJ9fwnfrqo+s08uraeQf6OeNPYF
         zbrKjvK6m8SHem559iTOZbTt50oxtJzw3ij/uKmxMaBhyCY/mxqZ/F7yQFK6AAZV3u2u
         2WaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792519660; x=1793124460; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Tzrx3HtUL23rsTyUgIMMsHFbitPGwqDqJbiS38hOu0=;
        b=WUBG2mD4asLOP1rhyHKvnw+yD7UzjweeV0z3D8jjSOyYJf5uEKzCB+DsX8Q0xPfkXH
         uiHRgKB88N4bL4yur7KEnKg8oH+NPfuFb5/zrcXi2HgiyO+TSVHFYUBBtvFskNwZd5Lg
         yrXFMIKf6nnzaTH8xIEkScpuGJFEtDJEHu7nvrT7xM+UtkMAbcdftfoUB0TsbHbEiSLC
         DEo9emnsBTNviLJ40hukjt2OVf4TDzLFjcDfpztWVlIJckElIONSpe7PKZtQiR8NAn5/
         RCaXWbpcRKbCOJ1mDDWZrb2DsLkAzQ78NZ/0znnw+6KFT5K3TPPuBQK5YbLj1d4I6ATb
         6xVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519660; x=1793124460;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Tzrx3HtUL23rsTyUgIMMsHFbitPGwqDqJbiS38hOu0=;
        b=UIKVgoHrxD78t7POSLzSyg0ne+TuguUCdrj6L4lM0zjbuHWHVG/fcuH4iMBibyZV6p
         sVdhAG2BB022l+ttZWERGIPnUpW+kPPHXf3qUfTTcjfhUBdlzBO26iiopd3LrGMERmXV
         venfQDbtkTpNFE4++Op4vGImF7Ua2dRPv9xHyD/VCNXFXwTj9tjYxccwgJ30nI5un/VU
         PQl3UHAs/j6HsZl6NxnZHOemtf9WiMQyAOPhDDsZKGEXzZkRFgij2Cm6tn2gwB7QEaRb
         nnK9G5MVmXTSJm8bz+s3fXlDIzZt2qadw01AXGjvhovCD7qT4MNmrV/fu3H3h3YiQjSf
         GQ4g==
X-Forwarded-Encrypted: i=1; AKwUvBypQtYmSwk+y5PRzKcEUdkQ2t8loTyDByFiKA/dbe5TeP8svU7f1AEgd84d+oeP72qud+91FmP3lA==@kvack.org
X-Gm-Message-State: AFq9FYLFTfxTS3iYg3xu4ofF/HFYva+kTs8HIq5/+yEFABEgFXPyDCCt
	HJ7Y4mmSB5QKZ5TwrC8rhRxoNTh3BBUmJhwZfFQK2l5tXNIBW73gt5UW25Gc/kx5Y+wWqdc79K2
	7AChyFDOsp5aX3qR/hT2AmHFHmQLjkD0=
X-Gm-Gg: AYBFou2xQtT9Few+DXkcApPsIzTKZXTWaFclfu+vDzeO+JWF6rjTcTU7C0HdcQpj4ml
	6UrvZwzpYkoSThCFffhCYfa1ivXIr0U1nGCatEP6G+YbtTT5pezxlsALh1r8jbeQpwtgzWqbCvp
	EUXYBwWaPWJ821tpJoTvLPD7M7TXgiwJkaZU4meelzBf49skc9DGZLeu2sGh/RX5/mtNCWShziZ
	cVMJ8JXLhe2EjlGD3xhfKkZAcek+HhCOcgnsDZ0FCffs9w7kpzgQsRp8wcn6GYNPd+vQMNdQW/i
	KK85AlWoIL1HWCs0kqEz4/YF47xfDSraZCvwMhNKkLBP4tyP9jooTlivAKeIWAzytAFbxV6PXea
	B4l0r2HqVoO8Y
X-Received: by 2002:a17:907:6e8e:b0:c2d:c800:d797 with SMTP id
 a640c23a62f3a-c46791a8928mr2454966b.6.1792519660356; Tue, 20 Oct 2026
 11:07:40 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261015060528.302634-1-jiayuan.chen@linux.dev>
 <20261015184014.715dcdd3a25e18fd4df49e95@linux-foundation.org>
 <b2f925b6-93e6-4b44-bc18-c94a34b381eb@linux.dev> <CAMgjq7AGRP3B0UZ9-wJKtz8D-ayivhV0gn2WxsrJ1Q=Qm4TVWQ@mail.gmail.com>
 <20261015200023.49685b4cba9d514d1f3ac374@linux-foundation.org>
In-Reply-To: <20261015200023.49685b4cba9d514d1f3ac374@linux-foundation.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 21 Oct 2026 02:07:03 +0800
X-Gm-Features: AclHuK_l73Ef6oIxyE87Kio-1EMNhd6Jp_RBoiRkCRSdqCOvvr4CSbl5CnLxa98
Message-ID: <CAMgjq7D8Ek1yE+LUZKvvnOpiJ4WtY071Sysh685JTSeGAwK9KA@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix swap_cache_get_folio() returning a folio
 that left the swap cache
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0B91F20006
X-Rspam-User: 
X-Stat-Signature: kbwnckiun4t5315spzuzpdr7bsc6zq3s
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792519661-504141
X-HE-Meta: U2FsdGVkX1+LMjIpNyaVeEJfMz3g0THNPrmq6nCwQeZ0Cxn/qdW35sM4EkTGSHVBtPT3jMq+G+7XtDPdjMleIz4kQLAIZLgS4kB/Rh2NIVkaExWgcLa44Zq7dqeKbxS4rGFEjegpmzRLXKSdLcSXqrF/doNE262o+MKklXMmf3RoXTEXqU3Qv3C0bcx36cuJZANr9T2YL9qvfhxtZBo1Oc9AimP8owPvkOMetDEZqSwWYAU9mUfhJKHgRY7po+706ckDlMhWBzZo1FKjMf3yobmxOdRcEj5A7OZytMtJn6+UC0OVKQx85bB/JDhEjc9rGD6T0bRNa6pw7b2bo1ZEaEBsCb1cv4D5A0sBQGoIbctX4STRPjrxlrtQgpiCH9DI/lzg0GkIE3gCgutIUirMufwCi2Xa/jGc6VTymRDJwNVUtGxEE6dO3r9n6N19Q0mW7WNCQ96rnD8g41Y6mHWRGtsW73jphGeswoB0Nc5Zz11+Xe9QY7xyNrqC8BnoS1mdhdV1TWDzYSfd9/KSnlGsZhmsnq0lg8pRNYEfw5MSYCfzG9VbeMT3S4z6fAMbtDer61IMJpdjxbaNQxc1pD0zFseCtOAyTjdIjflfO7hk49vFdfVrbRjPWlaTY2GI19mCINqK6Ruh2Lo33tHfzKrziaO1v3qi85IPrp6qnkUrUK+NF0Wd0uqZBH86Vop+3beuSGUvY9TGPwFMlrjZcNyHlc6FFWpleazravG5TsoFpoBQetYMW0IHKasB4YooM0WHUNRa9fbgk+tHaZ+uPa7rpTRf2/Pa4T0Ie0SrcEr533bFOtGmO6e850yKyJMBk1fgHipX8oSm/1aPONmfJeRBzzBS0Pn4+qZIH2kFQeeVqDN1LKWQsS4AMRCg5PdWNjwNnjees54ZpjCYMUSneRhIYgPJimDmc94GrmH1xYszIqc+vr9UHONaMlK1XJvuovDWveYe6eQ7r7tBs4yPRTP
 Oey7U3Gl
 6YPMfc+UCU+MrDzZ/VWRXcoF+9h5rYyTm3y40rc9CGuxTwnGqqyJbAh8QAjFFK4vRZJN137fy27YcQR+KYlgGCScW/gUJylrbsjFEkLv9kRobUXCt8LT31K4tXyP2+y74w/OU18XsosGHOf2FHr5bnxDfWsTkp3BJ+HtqDavlDGFO4+X0qduSVbVDNT37lxvKQw6Zkgss2SwMrtHTLOvXTYqEP3gv6Fn7tHkB2OoSkVNtS8jcmdrvNYSj1g5JN6Jn0HVXvGyD+wwkYfFdwqFEMEShTIrtZgvbncxHKG3rSdJQEJlhZFruUOBdEdiBEpTAnF9yICThhzFVnSbfpe+iIkkcEreGx072AfFQgOoYDT7wG40U4qxj0PlJivZtxl6Jgz/fqRn62tepaqP6I6wWUiqwulpJ+8COzF+qiePMEXUupdHFKe86biRBwC6bwNw1uDiLKDv8QWBFO7DX73jyqEzeW8o7SY3yZd03AqvsNmLmF9CpN2fkApaj05B2/2l/Yp1gfHs4kjJyqFX7+xeqq9u+X8ktzyQhyjdADXVMaCEpXn0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 11:00=E2=80=AFAM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 16 Oct 2026 10:22:20 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > On Fri, Oct 16, 2026 at 10:16=E2=80=AFAM Jiayuan Chen <jiayuan.chen@lin=
ux.dev> wrote:
> > >
> > > Hi Andrew,
> > >
> > > On 10/16/26 9:40 AM, Andrew Morton wrote:
> > > > On Thu, 15 Oct 2026 14:05:27 +0800 Jiayuan Chen <jiayuan.chen@linux=
.dev> wrote:
> > > >
> > > [...]
> >
> > Hi all,
> >
> > > >
> > > > So CPU 0 writes to a folio it doesn't own: it may clear PG_readahea=
d and
> > > > takes the folio lock of someone else's page, before
> > > > folio_matches_swap_entry() finds out the folio is not ours.
> > > >
> > > > Recheck the slot after folio_try_get() and retry if it no longer ho=
lds
> > > > this folio.
> > > > Thanks.
> > > >
> > > > As always, when fixing a bug please fully describe the worst-case
> > > > userspace-visible runtime effects of that bug.
> > > >
> > > > I asked $LLM for this and was told
> > > >
> > > > : When the race occurs, a swap fault can acquire a reference to a
> > > > : physical page that has been freed and reused for an unrelated pur=
pose,
> > > > : potentially by another process.  The fault handler may then clear=
 that
> > > > : page's PG_readahead/PG_reclaim flag, wait on or acquire its folio=
 lock,
> > > > : and potentially attempt to remove it from an unrelated swap cache=
.
> > > > :
> > > > : These operations can interfere with unrelated workloads and may c=
ause
> > > > : unexpected stalls, impaired reclaim or writeback, and potentially
> > > > : system hangs.  The subsequent swap-entry validation normally prev=
ents
> > >
> > >
> > > I don't see a way to a system hang: the folio lock waiter is woken wh=
en
> > > the real owner unlocks, so the worst case is a stall. I suggest
> > > dropping "and potentially system hangs".
>
> Yes, I think it's assuming the other-owned folio never gets unlocked.
>
> > >
> > > Writeback itself is not affected, only the PG_reclaim hint on where t=
o
> > > put the folio after writeback. So "impaired reclaim or writeback" ->
> > > "impaired reclaim".
> > >
> > > So I'd suggest:
> > >
> > >    : When the race occurs, a swap fault can acquire a reference to a
> > >    : physical page that has been freed and reused for an unrelated pu=
rpose,
> > >    : potentially by another process.  The fault handler may then clea=
r that
> > >    : page's PG_readahead/PG_reclaim flag, wait on or acquire its foli=
o lock,
> > >    : and potentially attempt to remove it from an unrelated swap cach=
e.
> > >    :
> > >    : These operations can interfere with unrelated workloads and may =
cause
> > >    : unexpected stalls and impaired reclaim.  The subsequent swap-ent=
ry
> > >    : validation normally prevents the wrong folio from being mapped i=
nto
> >
> > It's documented that caller always double checks the folio so this
> > part is harmless from the aspect of data corruption or crash.
>
> OK, thanks, adjustment made.
>
> > > >> Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap ca=
che and switch API")
> > > > Given the above, I suggest adding cc:stable.
> > > >
> > > > Do you and maintainers agree?
> > >
> > > Agreed for me.
> > >
> >
> > This is more like a optimization than a bug fix, but it's clean and
> > easy to follow, Cc'ing stable is fine to me.
>
> Was that an ack ;)
>

Right it looks good to me :D

Reviewed-by: Kairui Song <kasong@tencent.com>

