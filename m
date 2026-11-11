Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD100606A89A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LX1SPgcP
Received: by kanga.kvack.org (Postfix)
	id E409A6B05B4; Wed, 11 Nov 2026 12:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF16C6B05B5; Wed, 11 Nov 2026 12:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF416B05B6; Wed, 11 Nov 2026 12:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A80B96B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:23:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CBB9A0347
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:23:52 +0000 (UTC)
X-FDA: 85423510704.26.96BF3FE
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4541840007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:23:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LX1SPgcP;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794417830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcheYV28FEeG84nrqn2wc0u+T+lt+CzxE83toBxPN9U=;
	b=3zSaWtLpMLe6KCC32lXEUauM9Cvu9KwQQICK+SU2KRFdXQkpaHbU307raQH+TejLPlMfB2
	RkXonzgXXDCwpn+QH7TB+gR5eJrn6sC/BJ/0yYSSUBFmn/cDPqPxsGkGcfSnqQS9CWQRnx
	JeDNAVnl94ux1t9RBDPJbNZPiush+Ac=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794417830;
	b=CfBjPYiQ87GPe3X9MaFoo7jGDNpZVUMM2Uv8UMZzsBNtJvRNGtLorm9F6ZeWNUrWrA0tqJ
	kvu/Cv0vMLmyCi+wqL0+2EglzUgOwEsO2r60woLOzjvyZC7ncma2UIBNUA32VdHIPEtcw7
	PYzRApKlajoOjShQO00ZUF3YJBS23Gw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=LX1SPgcP;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso34157055e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:23:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794417829; cv=none;
        d=google.com; s=arc-20260327;
        b=QR97e6MPUDze/KoQMwWEJGXjY8/1sH9zBCGNjOVrvEXzvj7DY7c3OLW327JPFmVPvf
         bZ/Zm54zCsB82PSG84+YtLeZST+WuPtmFvxWArCY/wkS8ji85m+ECyo0VittD6gziRwp
         i/worUSxIREcGQz4OUUx/YGU+T6bgotyiM4eBntwGcaIMD8vLhjc6tJFhZLR+LdlyyBe
         f677xh6IIrC8TazRFrsr0snx/6frvvX9zd9j8E4lY0CQ16TUrTRPnsPeOz98YPAILCk8
         MqKdc8lLvT+zIp/NjM1nCexchlr3NxNeC5reLGVfv0Iutw7GLAN0K0xqGw3YfigmPk5P
         7ZSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mcheYV28FEeG84nrqn2wc0u+T+lt+CzxE83toBxPN9U=;
        fh=SuqQmkGtYwX817swHI0125H7MBz7UaF51NMJbf0Dex8=;
        b=O/jTVU7IAvGW2qSHg1r8Td+qXYo2tNFsLVTejsC0EvaWewctHeJWgBAlggL3ShuUQL
         TlxVfOSVdAv/8j7jhCcHInLRf4/cUDjNA9/rKZGGA5O9Re+S0MsX/VcLyvSoVnA7cCwc
         77aWZ+ymU5s61+psrLQK2SIBetBM0pn45PTiXPfzkMhtLo8hE6rN3ePmbcm5vvkiRJXu
         kE+UnRNyrnEvGenQtLel2A55k318cdtYQr3T+568MeYeydHmOrsk0hB17IoT76pPVW/Z
         zQMgwzuCOwxcfKJ0Ld6pl0AntcAtvSanly7lyQn5US0wgDWZNboyEu571v4oiZ02OfVF
         yqgg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794417829; x=1795022629; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mcheYV28FEeG84nrqn2wc0u+T+lt+CzxE83toBxPN9U=;
        b=LX1SPgcPQ8yZYWrOH71EH7Gu6xvZB+SFtDm9LI/xbX/tk+dAuF/4QtmoSSNM50udk4
         XoBLpB/WywrD9GloIbKF34cBHbP/GFbmeMdoSS6dKSqDD/Elsw6TgIB28WZQ1Ot0f2ig
         rMnoIkPPZndXFnNgt5uIygPWVDXmrtFknf09JADQWOoORXNRp1UBylgEHOS7opOK91x5
         a1uUzARip1LAG1wAgXyrTr9tIsmLsfNQkR4MqgYoIvDQsEzSFyolDKv66qM71154O2Lq
         0qYT538sNnpcaKXmjllJpPdh1Z0hlm8whYwcUj49xWIgndQJU7/hafzF//L4QaTQdUUS
         fcug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794417829; x=1795022629;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mcheYV28FEeG84nrqn2wc0u+T+lt+CzxE83toBxPN9U=;
        b=oVSZC6togloiRJUYwoNPBFx6VKkLDLnUzvxMO1zORF3EdN6xGmL9NglOpOXatL9TZ5
         aRRnMLVXsvxdCc5p1MKQUIOdQov4/3ZD0XDjESAcuhikNNnaCcIIgdIsq8vMo/9vuvFk
         cpthRuCTsGJRKZQE41ajW7581cQaFZUIHAYhSFFOqizG6gkLgC0tDhe4kLoOukW19Mh+
         n9onUtjYCicCMjtjIji1BLPWFuYS4oHJgccPe/TU7ePhIVOxU+9BGHfZeS6K/1J9ElJk
         sk49KyEzI//P5fvtdMZBehk1ygUDtE/0msdk44ZeiML7eA+zFbdUUelPgW7dfmHQ4xTB
         p/MQ==
X-Forwarded-Encrypted: i=1; AL+hErFlzB8JDHRFSxgHNKuiSenr8tfl89s0daDLeAgO36s5gwTDwuM4rivePUT+12H+ZrXHM/kKJ4cFbg==@kvack.org
X-Gm-Message-State: APuU4Z9rtSJOKXTp+VTmdGO66A0RDfWDJHz5iR6o4TtGEs7yN9VX3hi5
	gMAdoG0n1X7ZLURLyxDho9nMi6Ngd1SVtNqp9x43yNapN4wqTe4qjNpCgCA6hBRy6oSKRHo5Smo
	kcpvM5Rmu0O5w5INTmerixmTG6dN3krY=
X-Gm-Gg: AYBFou3A2ueZh4Ake2U0+Wa/jjE3AMo+0leVZH6cV2DNZGqk0ttuZTQenJLh8hK5XiZ
	V8SnEVB8ps9bMzUCsFIRM1eenrvYavGTF8L113qHzX698ZhFucC17+/XbPLErz0MYwxT1+J7RBu
	EQBxEDIinSLyHiZTlRDAMVUvAGVmbqyigN41VwU0FUqtj4CilFCkqR7wHVyk8y8gqurwffcQuns
	zfcKQ+zc2yJ/DS5+t5IFDMOMgKfPfr2PY2BJZ7C/XX7vv12H4vj/fdRAqBYh9ccAVeAHwgMr54q
	i73XtnleH2ifSauU92wfH6XEFe0thFHiivKQvEIuy7vfDfnCo2SX4wRw7WX0cScDtfoUSd2Z7CC
	0hrQfvOYDXg10gXtukZScIKA9zTdNDxeVtoCwyExT8xOq
X-Received: by 2002:a05:600c:c11c:b0:4ba:4395:56d3 with SMTP id
 5b1f17b1804b1-4ba43956399mr35681085e9.7.1794417828858; Wed, 11 Nov 2026
 09:23:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026080329.140244-1-hao.ge@linux.dev> <20261026080329.140244-5-hao.ge@linux.dev>
 <e1cfd568-8fdf-4aa1-a8c5-961bb8d7efba@arm.com> <5b0f90a4-c7d2-4f12-9d95-95c7149c49c7@linux.dev>
 <CAJuCfpHOZPKKd-bGWavBmBf5cmR-PEZO7a_jxXMZVS8tsgG5PA@mail.gmail.com>
In-Reply-To: <CAJuCfpHOZPKKd-bGWavBmBf5cmR-PEZO7a_jxXMZVS8tsgG5PA@mail.gmail.com>
From: Uladzislau Rezki <urezki@gmail.com>
Date: Wed, 11 Nov 2026 18:23:37 +0100
X-Gm-Features: AclHuK9kTkE7tX3_RqNj8eIIBWW_zm-niQDFwkMhLI9nwK05oSQZyNed3nD4i4g
Message-ID: <CA+KHdyWZ6F1=xY1zrJ65TBwJad5k8gkuKmws_hOHVuGtj9q-JQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/10] mm/vmalloc: propagate errors in vmap_pages_p*d_range()
To: Hao Ge <hao.ge@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4541840007
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: o563y38um9b1qiit79q7j3jb9f5ejef1
X-Rspam-User: 
X-HE-Tag: 1794417830-242223
X-HE-Meta: U2FsdGVkX1/w6UWZMa5GxjrP4GJUmijUMYtX4g0omly4YW59vw0ol4vonVs4jSG91bVH4F58azwqofLvp8yTuklSW8mwFOvw5T7OIUjC7Gpo8hLdE00QuZGQ9grXVEaTnlwsQ5mFBIQVF84NLGxqdd2qWhfYe0pK6HH9LK63LDkKyLFpJkefC6nR2hU+TyCff3TJ5N2UIIdTb+c97xvoiN0bgSPSTrBeiOEP+NoeiqvFCLIQ7XTdeNrAv3xqyu9Uw4lLj8FnZdsVnmUJrSsSnM+kJZ+0QdPoTagn7FDcVf4JF9/f4Jr7qrIhS8zUC55NyA01yA/Y8mAwoAE5kUFu0k7DMK6WTLDdZ18LK6Xzrdv9HSTRGNxy0QRfKfj5IXdI8fC7a08MbuONPydme7DpFp4Jlx+FsAfB70GDFDz3c8Jf4fYft0tN9nMCTjnJedWE5Fj41Rmnl+azOEjuC487FPgVuXts2Ijcd92PDBEtGLhARGUw8kDs1A1jmzOfTXvHK+GvfyFjGDaGSFgwgeWszP0i0fcAGI+9ITFv1TtQUvc/fbqt45x36Q5gU0Il/q8VjqIfC78lqeTNpxmGNgc1xu20cxXwZeCDX6xzTVnDoB9lx6oX2LWemHLovFwkOxM46XJ4M7qsC/i0dDvI1yQkPjROLMQAF4p6d2rCYuf5xjFhcRi262dlnVXPaxK69VkxoDlsLd3M7t2o8IbFt2ozu7JhNJhbxTzJDivivRZzFCD4/9aXbRpLwC9OwZmHNmz5r3RnHoc7t2ILwK5QXiUGK92DmlRVyIjH2haUftZIxLy2dXTJAbEig9FhcGAj4zKHMmQbbhH5l1Q0lkTYKWuIvQXJgYJe8NBpJkO9ez0MedLYS9xCUFLMfF5IVShze5/kzVj6x7Eddq36LmVmBoAb0GTKgY+/aNE3yIkkcM4Zr43dt4dqHtS8lM2bQNTCU5fjxd10HXF9vPydNt6ayvH
 VLbruA/d
 hwO/zwcufHtDM6mrN6RZfFYnvDs/kLqC7etmsovFTp4/aMLRzH88OEDZvq0W6bS1V3sk8gLe0NdPGaLbXbC70YCJA8ZmaFv6mGHUusFc7G37I/xCcO5fn4E2kSmgBsH1DBOXCh1H9A+QB8JjNGpzov9GFqZZNDU3NMUooa+3dno/rOOFeBI/Qs0J1CYznnUtNuS/B+ZHdZ02jVV5+OddP+yCBPuO/yEe82JPGjPm1IjBLPxQMCdZTlWnT08CP3TO7L35CUUEqSRVBadipcOWk/P50xtVP5tNa4eKMhGQrj4WWL3/LjeJEeSg/rfiduXhiSj3knsDQTPQ4H6RKJbIX3KfvrZbLLtp3mN1IH7cfXbtb73PvOixS8N2K0juJNhghsBFaXx+Yc74X0zAtFwWnlLm8bBDazODjaRbmG+OsOiSdxRkRfxx1SkaM765q97+dCppYGuBTuWMPn6ZuCyQruEkLpRf7sZMGHEmajarLRLMf6g9crPc7dasxNyxIN4lpW1hFgSAi/T7czyTn35vUHDUeCN6oNjMAXbNbNhpu0hsMJZYc7Wdr4khvQWCZkgLKvyRUd6zW617/SP9r4ZOiiJRo04DkElNtTQv2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 1, 2026 at 5:00=E2=80=AFPM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Fri, Oct 30, 2026 at 2:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Dev
> >
> > Thanks for your review.
> >
> > On 2026/10/30 15:29, Dev Jain wrote:
> > >
> > >
> > > On 26/10/26 1:33 pm, Hao Ge wrote:
> > >> vmap_pages_pmd_range(), vmap_pages_pud_range() and
> > >> vmap_pages_p4d_range() return -ENOMEM whenever the level below them
> > >> fails.  But vmap_pages_pte_range() can also return -EINVAL for a
> > >> page without a valid pfn and -EBUSY for a pte that is already
> > >> mapped.  Pass the error up as-is instead, like the vmap_p*d_range()
> > >> helpers for vmap_page_range() do.
> > >>
> > >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > >> ---
> > >
> > > Fixes?
> > >
> >
> > Sorry, I missed that.
> >
> > > Reviewed-by: Dev Jain <dev.jain@arm.com>
> >
> > Thanks! If you have some time, I'd also appreciate a review of the
> > remaining patches in the series -- or Suren and Uladzislau, if they
> > get a chance. No rush, I know everyone is busy.
>
> Yep, it's in my review queue.
>
I see v4, so i will have a look!

--=20
Uladzislau Rezki

