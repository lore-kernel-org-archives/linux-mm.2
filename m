Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4355DCD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 01:33:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72BA46B0005; Sun, 14 Jun 2026 21:33:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC876B008A; Sun, 14 Jun 2026 21:33:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CB2B6B008C; Sun, 14 Jun 2026 21:33:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4036B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:33:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B3EA9169A
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:33:18 +0000 (UTC)
X-FDA: 84880424076.15.2E9E836
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1002FA0002
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:33:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K4ZeFBcD;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781487196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7YfAIRPnSgVTVTSZup2KxqvQOtyczG2cRa3xPgGvnEo=;
	b=YbAkvXsTAPTxpjxrtFl+0L66CPM73QvoLQ/Qkv2PWqac3X0zg2J6ODEEKDO7xl+af685oB
	W0OHLJ7xBT3Gavaf6I89CRJvFV/eXVYr8k72xE6LuUfs5830V4ioa0g/ssfCq3JVWiFX9E
	sAT4BHnjki6AGfGdGBg1UcOp6EeKDMw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K4ZeFBcD;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781487196;
	b=Lp+I13DXr+yPBEIzuNjuPf069nQ8Ag2h/gAyESC/Lrbcop3P/Ydd5eF5v2w79jmX/aHWdz
	ArpNhS8Qa2Lh6aBK4Pw0FW+b1/ueMhMas8I07e9J10czxOR0sIJ8usOS5KocuMIr5RZPim
	5AB+6cvzHEE9rnqN7PZl5MTfkTVuOW8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51765531803so800831cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 18:33:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781487195; cv=none;
        d=google.com; s=arc-20240605;
        b=bDgetVqiIFcXX4EBkZaSeooO7N3OtpcGZKE6h9ByXLccpLVW/v3uqZcSjsCiZ9lcBf
         lEkCxpx3R+BOXDC6bBfnZdXsE6FmBExY6lqXrjZxFbb9ouFwDd4XE1Ur7fAy2ZnlbuvA
         D+LD0b/QOOggm4+pK4pbheS1vj9dSLuSWj9g8FxgI2YuDwcQ0OwIjmEou+ltUPkgV5ya
         ZurMp5Xv9uBvc3EhjXxInik8oYZ6LEZuBhx4Z7/y4S9E/HidBSWFyXowc8gPR/3XE7H1
         zbBv4xGSrvQqXiTvl4c3qgvmj90lg4DP8lLAPtctj6QHTmVz/HP9YUxCcMFm1rwB7B0q
         bMPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7YfAIRPnSgVTVTSZup2KxqvQOtyczG2cRa3xPgGvnEo=;
        fh=q+NJuPb2ShB+GNoHK7zvT3ez700a3seQf7EDZkNIjTs=;
        b=Je9FI6PnslCtKUA1KjxTh9amDGkJMa09leNtJ4nta0wiJkmmE3quiIBTxfqwboP7Ve
         Eto9TfVpKFfhumhQp5Apv9xV8YazLHVVGVilhlerqLPh3Lxh5GFdcihGU3H/zekCLYG0
         /8Qw32KMzmdZO7Ekt20dOSORahGXS9sVXRSdEzYYcVScSLwVW0heEOc6Ipa3auwM3/pG
         EyiT2Zgji7W3jOanE1k8BmbaKGdeLezyOOKTBOLfvTYa8d1Jafn+Ptvf3V984+QCJUIA
         fAdJyYEGyDKg8UrmfdJG2B+8ERVl2ItMntM1W7QJPMHCBzVfm1PJKpTOTS5uz/LFdUHT
         Voiw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781487195; x=1782091995; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YfAIRPnSgVTVTSZup2KxqvQOtyczG2cRa3xPgGvnEo=;
        b=K4ZeFBcDHgkXYERbMxI9uA0tyBq5ni9kBqLrClsMu31AJaeaZmzSybjxVf6H3bzjrC
         lll13QAV7o//nSTnjFANNGUbvwTO0Xxm8QglYdJ+fjmn9bSFdyyDXVDPlVKcK3eik9yV
         O7Fa4zvR0G8kw8Fq0sQB1p78Pza+k1h5V/0NRRC6WrsRVfXUtB9Shy/F6FuCG5VUb3Bv
         +IItecY7+2vvVc/3dqlFe6866+JxdFRKhMnVrok8lxb6JBH7/EpOd/o8ljR/x5Vxsiqx
         Ppe3cqmhURqEccyYZdvXQG5kb/GyPP6SAlcoKShw/dc/5pETwB03HzX0aggIRhljqb0V
         MI3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781487195; x=1782091995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7YfAIRPnSgVTVTSZup2KxqvQOtyczG2cRa3xPgGvnEo=;
        b=gAHjtni6MqxHUDnuuQ7URloLBzvPjnsuppcdKiu806R+HkttgjGeoGribarqeYp8M1
         0mFVxuKljC0ZMAKftYnh8wG3LjQeVUPLSnTzf/ybA/DUL7aPMNzncgDTD8WNtdF+cJug
         HFIrCvHJ4CyU4/i7iSzyBYm5FZoEXGGHGkOdeuQlpHQG+ZNIp7PMespq2+EIphPEki40
         iFrIe50L3Hrx/Wgo7lM+MLM4AsZYROJh26FfySyFLEjypL/ohXJ+p6JO+9CWiWDhQWuQ
         COzp4sunA9pRlFtbjuotn8Cu96joPuVeDfGcjbcLzl+A8QaDWi6F4SqDkKiXS6+amIYT
         +Dcw==
X-Forwarded-Encrypted: i=1; AFNElJ/evqh5e9wkkyt4a6bCGvf4f/Nt2ZHONj9sV5KID4env8YlAKhbUS+pVAV9Y4azsvP2E1jG3XNP1Q==@kvack.org
X-Gm-Message-State: AOJu0Yyuqbnpt/K76gSa6Xwb/VAOApbZHwpAFTFxYOznJc5So9AZwhF2
	o4v3aL0YdwA56V3KgZGADeRlF6hBqxlKc0b0LpTorSLq2zqQiqS+I7auB0XGQKAxpi4WDmXW+8l
	VvTaqK/6h3QijRay/TQ1HaD4tJKWTphNPwjfCMbdk
X-Gm-Gg: Acq92OGDm72jjfYckCf4oSw09gSZmAxr6dLPnwWKQediF/TKgqH47kbOXJnLFXfqH0q
	QZZiOxpLPoDh5Kawv5yilmulbbfmYpWNhi+5JCaxW/saNscpgIOnTzr43qPqFgKFi/n4+GLdqW0
	TDPu1n6qlHmQYHZRJ4BnqFxJU75VihTzUOVkLnGtDmbqc9HvQR3FS00k9z4KrxzA0DCp20gIzQS
	84oiB0q3DI3UEeMTwvl8Wv035IyHyGNLmnozsoadls3LJvzoSiK9KDE4g2YZpTiyDoWD5XLPfa7
	LhUzOhlRR6WN/24n
X-Received: by 2002:a05:622a:4c05:b0:517:99ea:ab77 with SMTP id
 d75a77b69052e-51955ed47abmr10839081cf.23.1781487194598; Sun, 14 Jun 2026
 18:33:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org> <aiuBW_xY6x5IBQfE@fedora>
In-Reply-To: <aiuBW_xY6x5IBQfE@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 18:33:03 -0700
X-Gm-Features: AVVi8CdgiUpri-ysDlsl1zKbLaoB6SytnWZ1DdXfEBNz5uTw-d7A6qLAoBejAcU
Message-ID: <CAJuCfpHh+DW_G8VrD7yX9mU-onGBtkNecCmGJOgMoBqTm1GQPg@mail.gmail.com>
Subject: Re: [PATCH v2 03/16] mm/slab: stop inlining __slab_alloc_node()
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1002FA0002
X-Stat-Signature: gpg8c65fkqktsffggbkuxynt5zqngyrq
X-Rspam-User: 
X-HE-Tag: 1781487195-850781
X-HE-Meta: U2FsdGVkX18we0etyJeGbm3Bux5rgBJemf1QodgXb1j34B13Xq7VSFEhBELZRZ6XPYy9Jd/IBWM6JULGZ4XsaXvdolEc91AAg7K1vFOpew4dck/20B1YycT7zwWsWllQ+/EmjgtAOmOQMGm3U1224zMaj7Ae8ebrRsUThhFvwsMEg7swxgYth4eHrRH5ReYLrgs1XXW0Lg8YEr9ygKJmRtNffg9LwKI9beJ8/gs9PKesxCEg0/xBEpAuIrNrr3Qn+d+8BDy97wdbABBE17SnpHwvWg9PQxJtzl5lr/mswOxfPRS/ytGYzi2FJqAbLOwTkTI7eItgwL4e6qgWL+35rTPTaaMzSGUmAlKkmRcHStiw+lKibv6V3++5TGLiQXp5uUOl4t3ZnhtBg/O2HCVlPEW4Z+W61r43bC6TwbrbVmx1j/p4cUm5HeIXx5milbvMUJ4kK1gF0BPLOuIhO8UAXHPyKl33Ayhz/Np4mdokVSdR3xzKIk9mkb+llRGC4Y5mt7g2cz20Qt6bIAuio4n3h8N9zdhLxdWd0Gu1MtOT3yUoV0dw5nVR4FhR0JXlulZvvdWyJ0mhl4sBDLyy4CCM2OxP20SOmEZM85lZlTfwEOJ+hlcTB4iPSaTJXkbM3L6ND2RNBOS9CLBA5Lb6tvuDvK+qRtGuQWIJyQMVfFwBRVKxxOivZ9r3/jvTqdg8boBnPPLdH8jUWA7iTp+opbpxRkmLbz52MiiUoZoP9Q7KyzYpNQS2RMMALa1GZRdCzXDSDYFQlzUhBZfP3nuOPyLH+7yxci09cvbsQS6tzzy3KiomoatzHDymmD1MEZ7BHsBbo77KSos5W9Z2qTD+o3Rm08pcAKNGoGKlyDR9Ue3yh63A1Yln7pFxk620k8Dl4HugSV8W4Oz/7MMmS+UsisEKR4dQmVwB0Wz9fAzrQSlVijy8HIv8CllrD3BFk7gdRpIgqw9ETXgzfljFD8rVH2p
 pWYIEgy6
 eTG6JtXA0ZGt1jSiryAs8lF4wg6Nvanhu2cFqO2CBRF2yD/DJdj4oHMom0LxYcNVSB+ETVC9aT7QwFj/yH8kIIRgx2TzlQ1HLDXwqvIf9JqRvFTX4oatQWSngQws2lWFNnMk0CljckLk8YPkeghmFCMQ4FrqEmQ6SlKXzqfWr/2a0LehjWaAOHAFbreGWrzZ2T9XkEU2f8nURkPg2AqIefal/ako0WK8vDsINI/yt1gsHVoQoFmZHc3P995soCgQlxkAKFmUlVMbNb94+CgfetKqGD+hBbad3fpul+QzDu+f/YW2FrnnZDnMEnNz3NG4NwPH+ADzTelHVeqax+yhlixHzdtdbjTQnNBmtzlWKBOcsbgnoDawvsyUQ8FY6g5O4lCVzlNYgdeWkvB8m3zDGWmAMCbdzie3QCmXB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 8:48=E2=80=AFPM Hao Li <hao.li@linux.dev> wrote:
>
> On Wed, Jun 10, 2026 at 05:40:05PM +0200, Vlastimil Babka (SUSE) wrote:
> > With sheaves, this is no longer part of the allocation fastpath.  For
> > the same reason, also mark the call to it from slab_alloc_node() as
> > unlikely().
> >
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


>
> --
> Thanks,
> Hao

