Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C77010F2871
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 21:01:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4386B0005; Fri, 27 Mar 2026 17:00:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB786B009D; Fri, 27 Mar 2026 17:00:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E17A6B009E; Fri, 27 Mar 2026 17:00:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A00E6B009D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 17:00:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27D6F8E111
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:00:59 +0000 (UTC)
X-FDA: 84593062638.01.9E0293D
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2704EC0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 21:00:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bv8IpJWb;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774645257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHvMP9KDYXp5B8fQ+exmdFOH4CKDCprqxecGbubjPqI=;
	b=OUYNUDj+NC6GzipFiWiUZmHHRKbB67sZvninXLvhdso330V9acicwk+lTiD22ivUW5e3yJ
	l4rg8SCJofu+hLaFZWW2wotpIQkX9KyLv6FQr931T2qA58rHVVRwdtUrOm0wGVKdEjchx5
	BhuNv6OHPwSom9PcY601PUeTDeq+gjU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bv8IpJWb;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774645257; a=rsa-sha256;
	cv=pass;
	b=Wsa4yEMuYCLJ1KGezNXVqcv0nPkbL5lOHIpnkIsxyau/CL6VJQm/zJd9GgSmywLXiQM58w
	j9vVFueLeUrAbnl18N14Pq0b3nKoJXEqIZu3XVTMcuGULuSKnCFqa+MSvQGqqWFM4K0rjo
	dneeD3u4QBy8x2LoKSIbkb7Q1jrA59Q=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5091ed02c54so50531cf.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:00:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774645256; cv=none;
        d=google.com; s=arc-20240605;
        b=Ulg4/fvpvNDMXtKwZ3qGp3Cw3JeTL7MDro7+moFnPuL+DMHXwxGoDQZewe1PjNWiDa
         Olsxbc9XByqDPnvBXdUw+L0g5sz0upiICCB4cbaH0fTcqS3cMZwPFbxebgUr3mxPp0A2
         i3IMYa9ISwc6UbEzI54R+Fct1TTsN5XJq6uo1Cu3H8gwlg8jlItiUnSx6gV+eqv+XDCA
         zPCHmVqRoB7TXRjdJj8R4F2OWmYDykmVpiiBBXMTQ0zSgKdtnWQZN7EZL3BH8lChEO/h
         uJ90IVGMtNBDIlIGujZId9RqPX1mSG7hxlp5amlH4vhhCsBM/ZZfxjmJHVd28dFrOrKI
         8Uuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uHvMP9KDYXp5B8fQ+exmdFOH4CKDCprqxecGbubjPqI=;
        fh=sVn7IqoMsaxw6/tG5BCka/l625y8JsTb+ZVTwiqZvSM=;
        b=OX9P4q12lymSrGC7f6FA7oPuNsWDbPDUiAPvi28WlcBUYXUaZMYzOoQ0idp0/Wvuum
         E9U55kJuv1dEN54AgRMuJHAV6ZCLa6l/KYfCulR9xUY7jwtwTZXKqEjNWmFxI791zw7N
         qndE/M5RZwXpwT1Mn+FNN5vftWUX5BMTY/sGtHKJJ3Tm6rO+55d252DF8OP78P5fsoXD
         LVVQfX1Y0xHpo8ZYcdV8+k0L1tVevcmcsWpWH84zgEpaG05x6Os9iBd8jOx2MP88FpQC
         pVOcAUB5AUGuFduTWazfN/sX4S7vS+jeFnRMaOYTyQBOBhA/qah7fJxqahxlMXsriMF+
         6IIg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774645256; x=1775250056; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHvMP9KDYXp5B8fQ+exmdFOH4CKDCprqxecGbubjPqI=;
        b=bv8IpJWb6mtiPiauJ0SztzFNBtfl6BVM0byPzVM6E+oihHMU2mf71Mw6vF/UnHARYe
         uz70AzOQBFJJlFzFosHHxQWF3hllE3RdW2dfs+qzUWMc91uwL2s54bBOg5O1T8PZFKjy
         3qXkpsT68+LRWBZayzoO/gQDh9O90gj2ZYVtBDdBQwxEczsBMznLLLSFJtAKIU6YlA2V
         zH+bRimt1k378DGt3TN8B9sK8U4cwBCTfuO20LMMA1kuma7mVB9eRLwY71ALWUKjiBOJ
         Pijvo6Qxsyxrrtz1RbHxs2pxyQ3o8s2Jo2SZqgerRlqSt3ukDZWuR+TQa+MTtKzPFYvE
         glZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774645256; x=1775250056;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uHvMP9KDYXp5B8fQ+exmdFOH4CKDCprqxecGbubjPqI=;
        b=MDCWm0cGAR3hnNYHUif6EES+N8Y7O/2njVF2Mi5+Kdwn47t6yhICpkQjmv02WrWDmv
         Vk/iNeoW1Dkb98jYw2ahHiuWDgsz7xvD8GhBESOfUVbU50yEHEI0ypdAN/L7/S8O/NpY
         qqJTMZHcC6erpr+0qZKe7WHl67UscRxwWo3TrcM+kjr1Ov2XKJAHWBp2feuekJNX5kXl
         ZLW9LI9ZrUmdLhmyyOkXEZXIDy5lmHFdpAb3SYnEU7vUXwoc4bl+V4P4Kf9bp5fy2/bX
         qMcol1QyBFX73ogLNX8ENE8KbiasowPK7c9HgNaTNP+Vp/mnLUBST5hInN1dMLNtPZab
         t8wg==
X-Forwarded-Encrypted: i=1; AJvYcCXrqqyRQSZjU1G5eqRlhKmtIXg/WJ6YbyK8gFg0EKkqJPWa5sRNuSRMtwU7Jtd6x2ugi3EmN1v5CA==@kvack.org
X-Gm-Message-State: AOJu0Yyw6o4Gnqd5/hYjVx+OZx59r8jQhwgzgmcSrK1qqEmljURNMAAs
	Y2/zNx6IDMTR04sjIL9VRArle4/4L19Us+/QkwdyQUpGAMVXGCQ75OmRahOhFpPT48UxnB6MXaL
	StMaRy3y4J8co5AGbnac6p/TW9UY0Laa+/mQ2rDcG
X-Gm-Gg: ATEYQzzBDa44T+nXlXSuKPq28FLgfXl5qD9HMr8F/AsMPTvR5jkv1fOeeNpSMlpZBQF
	B3/IZB/M7XikeG9HWcOFhrwGj0zmYs4uTomq//q+K8pFlTHwkTXGNmTy0meDwdhdf0XDopmf+81
	tvrzcHGiJkMy06NIystRdxDQwPUQds6bYF+8pqx17bMpJecxHtgSMwXpvDNtyysYpff5ej9clD/
	C/pzxMLeeWv6cBby4nWEAiAAP9ermSWLdpFn4zgMQMiB46ftLmxNy/R2u3IBPIXSEfxJKIOSptI
	GFtR98i2BoOlvD7MnGYtVr3A9YtGBcY1W2kj
X-Received: by 2002:a05:622a:aa50:10b0:509:371:f2ab with SMTP id
 d75a77b69052e-50bb288a2e6mr3465221cf.16.1774645255554; Fri, 27 Mar 2026
 14:00:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com> <20260327094738.7150efc3b0619e6ccf095c23@linux-foundation.org>
 <20260327100322.b539f1a9f3662a0a4c080cce@linux-foundation.org>
 <CAJuCfpFxZsnZqqfoKXX=JEBrBaqZHNAgBE0VHbTc=GhQzP7X=g@mail.gmail.com>
 <df0c2fc2-467a-4ffb-a697-7c89d64bad6b@lucifer.local> <CAJuCfpHthntC=BNpWWYHePTfJJ5WQr_UkByc_-LViuy5V_xQ=A@mail.gmail.com>
In-Reply-To: <CAJuCfpHthntC=BNpWWYHePTfJJ5WQr_UkByc_-LViuy5V_xQ=A@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 27 Mar 2026 14:00:43 -0700
X-Gm-Features: AQROBzCX6JW1WY1HEKM5C3tQVZuMaYiRbHqFEwYBGPSueKMxsSn6D7aAg6e_Ipc
Message-ID: <CAJuCfpG78eMr8JjXLUi3toipy1chx76Bq5qRnt9dBqVLrxfLBw@mail.gmail.com>
Subject: Re: [PATCH v5 0/6] Use killable vma write locking in most places
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: wgopo1g4jcmz1bn97xnenkrjosqgzexh
X-Rspamd-Queue-Id: 2704EC0002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774645256-396694
X-HE-Meta: U2FsdGVkX1+AvpiNNH3rCURxmCvxGTz231+gM1i2N3XhgJqrso/ipqn89pM0wfm2JhG69H+IDrF4vlN218kM0ss19F5m3v31oL10y38/JL+1VMCE4KdU5gUAdtsQQB7MaryghWRtFMq/sn5UmXK4V7ny2buv5AKg/KxMxDYv2Nx0g5HF2G5cSflD54wEswdr9i6tYIfqx6xVK5xv3ekBSjb2NDazKf1UMgjNW+6MmGH/IC8rkng0qXXZ5+7CHyMFvyRxJcNAWTmffKCbCUbA5MRMzNZFOXomAhFSv79opOiwWst+FGi/LBgZBFytGv/7De0xWrMWAPs9fjSnG84EIkU7n04l5JIc2eXn8kCu7VLvde5Fm6k51spgDUoiOzhnyoO0xVcRlof0x7XJYAEQhHSyZCEKq7urQZ7DMsLps79lzqf0TSrLiS4nOl8F2iKKEUyQTRX3KFI5/LxqgnmFpFjOZBTbRX9JW4F28uIqaYWdG4MupgSaskh9dlEQ4bJML/qy4Wekbv66TiMN/nlNClUeTRaMcL7GSuZOsYZqH9aVgDMtBfNd9Of+RIUEQ7Knj3CtLPouNTC2KhGRBRdQPvV1Wsqz+me7PN+tqPwHfyMMDN4sOcIUe/tvbragLtWHuu5m/YNNYlpZOZgqJj1qU+maZIOLzDJzRPR2G5GMa/uVhY02d8J/PZCpZIeSqngNb7KbveTs8RhZmxbXs86IeyVjt00nEYYye5Ypv0v0t4U+pWpYBWOrScoNFEmTZgtDnLEZAS7RFcIwI35s19L/42uASw9uu4r9Sqh91ePd3sAHUKC3FoTkyqe1Kdo78E+9rpTUm2cFs5Oqd2AN2Gkusw4lmBhnzmRCTTTh3AkkSy7S+8akSC/cE/oSIGFmnRJ4tdduWnVwHEiPoh/PHAM1IN98hQPCbmweh8GaP887GzHoX0LS9O9biyBXfMxNIU0fhsS2GAKr1naQ/0vuxBG
 sNet7cUN
 ULtlNpwPSncxgMVstndFa9x+TL9Y/gpcqE1X+2dUc+e5eNusS+/AKR3PYTRUqcCtMm9lJvyc4QgusF/Cpb8dODkv2wOdFXicrWe6P2AZ5pJnXwAqNRaqiUwUkNo7Ue7Vm0BSt2K5d8iVUXGQI8eGBeYNSHiDB8H5rZdVIvJxD6w+QWRR8N4T3ZpkAJzbgh7ykGXe9JGBc28o1bQ4KL5cWFRTP9DVf/iukrMfemIVcE8VYpipWDgWCz3ynQvx5an1ZXIcwiJX8+HSfhP5H2AB7wLRmD4QahQQPryk6xR8kzMZxOisOFpwkxypP4UcZ/j2dqeCZ/AkbUmlXbvtNT/ENXpgjNqwWjmL3LLcWoiJ1V3CP+7ckqO/HOiIdvq/BjMDCMb7KUvFv5NlDviDIV/V2TkXqhYGnIM4fNpniNm9ubHyLr0g7dwfEErVznQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 10:38=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Fri, Mar 27, 2026 at 10:37=E2=80=AFAM Lorenzo Stoakes (Oracle)
> <ljs@kernel.org> wrote:
> >
> > On Fri, Mar 27, 2026 at 10:32:27AM -0700, Suren Baghdasaryan wrote:
> > > On Fri, Mar 27, 2026 at 10:03=E2=80=AFAM Andrew Morton
> > > <akpm@linux-foundation.org> wrote:
> > > >
> > > > On Fri, 27 Mar 2026 09:47:38 -0700 Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> > > >
> > > > > Three of your patches lack review tags so now it's 65!
> > > >
> > > > Three is now zero, thanks Lorenzo.
> > >
> > > I just finished fixups for issues Sashiko flagged. They are pretty
> > > small but important. Testing them right now and running Sashiko
> > > locally. Once done I'll post v6 and will ask Lorenzo to re-review
> > > those specific changes. Sorry Lorenzo, I'll point out the specific
> > > changes I had to make and will try to make it easy for you.
> >
> > No worries :)
> >
> > Could you send to ljs@kernel.org on the respin? Sorry to nag about it b=
ut my
> > email more and more set up for that and makes my life a wee bit easier =
:>)
>
> Absolutely. Thanks for the reminder.

Doh! Just noticed git send-email doing this:

(body) Adding cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com> from
line 'Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>'

But it should also land in your kernel.org mailbox.
Just posted v6 at:
https://lore.kernel.org/all/20260327205457.604224-1-surenb@google.com/

Lorenzo, please see the cover letter where I list per-patch changes. 3
patches not listed there were unchanged. That should help a bit with
re-reviewing them. Thank you!

>
> >
> > > Thanks,
> > > Suren.
> >
> > Cheers, Lorenzo

