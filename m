Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53FF6C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 23:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16596B00A6; Tue, 30 Jun 2026 19:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDAC6B00A8; Tue, 30 Jun 2026 19:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E061F6B00A9; Tue, 30 Jun 2026 19:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA0746B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:48:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31C19A012D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:48:41 +0000 (UTC)
X-FDA: 84938221242.02.832DDB4
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 39C1E180006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 23:48:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=lMmboJ+s;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.41 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782863319;
	b=vgVVF9QGXJnWq7xgnzfKCSYLtks4LucQAYANbOby6O3z061Eihr7W9tU5076A8JGsML2th
	30n/bizZUJB+Q9KE+8aoaHKBRDlf4DWQckQmKRQuyEKnEeWkJaQXRANypk64iIQGTbWf+8
	MP1Xn4+Refo7mv45diAPaozWnQPeATc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782863319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kt2DBulMpkq3yuN2l3tu6FacmANttLzW0MCd7Z/rlSg=;
	b=UUe1TcJr2rUINJaybo5U+r7txRXDucRhOdUMHPZCKpIjXZy/EZsdB2fWThsi2+R3Cg+XFB
	UgmPB0+F1TcRSZEiNSYg+M7xnyDQ/DXW3kjsoIcsVUD+NZc/8TEBW2UUsmmU70suLiWKqa
	J6yRfAUUoBfRU/m4ZHXqw88APUwLx7Q=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=lMmboJ+s;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.41 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-37e11438c66so26657a91.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:48:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782863318; cv=none;
        d=google.com; s=arc-20260327;
        b=ZCnAT7e41sYuYoz9L+TwFnG9LUOqg+QBkT58+cD36eeo75YS7nKTgCshsC7Iniwz4M
         u0cQe+dtVdEqMtAUfhmKo3xuMrVGlXuvLBjGsy8hASgc53kMnPjX/w4ZBHXuX53ployL
         Ds42guhxLHBCkcGM20pGW82sK3yPKFMd1IeFkkZYEihoV5YgeT9ItbOEJOdlaMGb97GI
         dCi8irOWp/UkoBmvJE6cSvCxY06JiDPfyMLcp9sQHi9a/l1AnW4AGYh2YTQT4owmqi53
         zKgQIaMvx3ZsZs5uw32RQVIiCxOTShZSPIwL7NaKbqVh/fhmad2unLReSwcMFfTHhEJa
         XntA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Kt2DBulMpkq3yuN2l3tu6FacmANttLzW0MCd7Z/rlSg=;
        fh=5yVWx+6hYWsuxPCGN1I0FtO5foNbcZ5SPow7V/VnQok=;
        b=B9Zi+EGvER9/cumfZEU43qjLRJKRW2TcmdxoO1c3MSh8DgNt9eSTrHnnR3QYIn3ck3
         5vp6lZBkGKJINC8ggSMdnzCCbo5utO5RRSjmnl8Fp37bXZvBzRk2Bd+xdr1J7U9igR46
         2MJo1ExfYT4bqWTuKov6fcCKOaSUpzPHI3J5TzwOMGriXPdmdvk/czY0ggieJSwwiNzV
         D8v1kF79ClXIQekAQxRE7c/CGH6eUBEXKSgkvpTEhhR7CLUHygPTXYwEHaNXsvQeFQUF
         0Y42AoO2kiIBknJHdaj6C0g3MN4fEdxBVTXwiMMSPFzsX6Ka77GL4P7LYxYl6Zkovp0S
         G0mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782863318; x=1783468118; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kt2DBulMpkq3yuN2l3tu6FacmANttLzW0MCd7Z/rlSg=;
        b=lMmboJ+sP5uqTYUVXokVc5tOwZjr5yZ/kqPI0T3/2AXi7qSi5Cwtof11Xhk+hsHZLH
         ahaZNPebre6dWOqp5IOly0qJQSzjLZMKvn2ej2IllYxj1Jvg3sEx271nYucqxg8EzV8V
         k1YyCVtzmSDin06SxhWKkXXHYcLobDxciPnidJCkha5crbxVxeu9wWsjTB9Ep+hrV5H9
         AdYvTycNLwxR7F60vmZxs6TE4+K3qpbrTa9TPn112rWo/R+yCeb8tGJb42Y9GhvZdvhu
         s/ziiRB8cSD+VqYe8br0tDyOZRCjonTzzedRuqLK5YLqUSoVacuvYV2Ae/2F8oq9gKKT
         JOKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782863318; x=1783468118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kt2DBulMpkq3yuN2l3tu6FacmANttLzW0MCd7Z/rlSg=;
        b=eJuian3yR5a3cm0tc2CN1xHJGGRL2+fadSkC4+UTzju5ZRDktDpqB9W3T187o7YUTd
         D/ALGYGj7+QMxEQxoqFsyDimTsda4jOfX2CVGtxUlv/FeR8Nhs0S6oWE1qxymuuGdf4I
         Ef6oi2fRgX1l/LocfNdh4TOYlcK/CPXz57WedFrdPuEROWRznWW7mI1AqWB+NkVcbIUq
         b7jgx2lCcupq6LdFpxZakHfivCcBllP7LtJaBfNUYhS6HRDNEE3eGjo2YPS3G3qPwl5m
         JEEaeQ23zO2+deDJEFUj6iwsmlPEd+JgbnsH30KS8bQ0i90GGjuczEsm66eGIqyl+KGu
         BkqQ==
X-Forwarded-Encrypted: i=1; AHgh+RrMC2f6JCn66Cpy3GuiAvM3OaqDDuHxebqNHGpynT3soUhh5tPPquZ1m3NnOptuy/C1f9Jja9c2qQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3RuUCVwFDCnki4jtLDOOodYCsT8jCVyT7LGs2uLYRQcCYyqSY
	4b+h3rK6KmKFnZpTwogNWWxtfPrMzRJO0PywO/OQdSOHOUS/3VAE1HwQsBcY116TnIaY1rcZslN
	310YgTZSdSU3juH8TEShjaEvgB8o50FouVlcfHUkO
X-Gm-Gg: AfdE7cmqpL/Qg0/GKoFiOUP2rum7el3sQnJORb1/Ap4ga9xmLBgmT2NeOck7YfWzoI9
	iuyObovr6xgOqr3ry3HDsrmbxOCVXbvR8l9a6lemFSYsB3kjyozQ+XsA/4nmCXJQYnoayNJhYA5
	laxtduDR/YstsQZj0t+ewOGdysZo2vVE2A0ESEmt1bQE60ihybHKVl+LPpOwW03VcF7BBzzuKqE
	NBEZo4ztsv+qjNNa2KmZnL7jiIBx4ci89abhYuMEcAj7l0TROr8suCQVfjzPLGr7uJpF2f/OQO9
	Pfn2Mtv57Hdboxf4gX9qCRzK1sTQ
X-Received: by 2002:a17:90b:3909:b0:377:424b:59e3 with SMTP id
 98e67ed59e1d1-3808c0e139dmr2071252a91.24.1782863318168; Tue, 30 Jun 2026
 16:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260629214712.1198680-1-xmei5@asu.edu> <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com>
 <4e96acf4-25e7-4f30-8455-f9b3f49062be@intel.com> <CAPpSM+RhcW=xciX50W3G+2mUVNkmLfL1-BScPN_2TekMbzYVcg@mail.gmail.com>
 <c7c5d2c7-db83-404f-b40f-ee01ae8b9299@intel.com> <CAPpSM+QVOwhmwspjaUg+FqKsHjiEn7C+gYPEcpJ_UZA=JMj7zw@mail.gmail.com>
 <cb547653-0ed0-4fc5-b022-6f0b9691a4c7@intel.com> <86e805c9-ede0-473c-b8a4-8b20439eaa6b@zytor.com>
 <CAPpSM+TM6VL36XAoDMsoCr6u+c0feab8DzXuahjpNfVJQ7g2JA@mail.gmail.com> <9ac1d214-aa8a-42e5-8903-15f8eac5cddd@intel.com>
In-Reply-To: <9ac1d214-aa8a-42e5-8903-15f8eac5cddd@intel.com>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 30 Jun 2026 16:48:26 -0700
X-Gm-Features: AVVi8Cf_WIqqKI8vqJ-7-zhFrDMx9ui8BwZRhh2LAk5C3DC2KmNyzSVaHSx24Vg
Message-ID: <CAPpSM+Qf-=cG1yw7vpTexh5F6+J+c18m-xGjR7H+GJV6fdx_kg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Dave Hansen <dave.hansen@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: orsxicf13w4zw59i67644sks94pwgyye
X-Rspamd-Queue-Id: 39C1E180006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782863319-300101
X-HE-Meta: U2FsdGVkX1/Bz9vNQGi+s5sPmMCC3RftCZo7D/apMDTiwiBh4qgzofed/hF03rW6PyyH5yWnKQER1BuYwp1KsPHzOnkw0y+et8pahdzJDD4gH0AFDuT1IpaBttBwXMalsEG5hk6uQ5wrLGHiIQJvJ0SkHxYZ+7croWX9Ke50GLYfJMRBipz3bGeL2Bl762UuVrvaWqkqg7W/uuY+wX+8+r6CPpc7lJMY/IhXdXPtWeOyfQ6aArbgv7Nict9haMi/1jNU/05tkeEZz6t7VpuHz/yYUeegiAmsSYMdtCWaFguCTqbsfnijN+Jaeuj5I5xX9OTNmnq/74YoWUcqoi91zgr5pXCIgxANdGN8os3xBdMERkOKROoBii6etybUwTvgLEEdd5yf3dQRlgUSzJNRQssUeVgHqSpdmzr7uLxkUjnSUxinjqh16eBLAbjoEs5VYrYlJylCijYsiLNrphcmmM8ArFympP/s71XdMUA65LzVRWW4TjgMPN6QobRfYna4xdz0Qb8Cwv1+qbVVBpIv2fMUxA4oXIdV1K4IYIiRloIKSmSvt7oD3JDekluLpsLQA6hC6fOA1keXn5bKaAc6litjb5boIwulonONdXVhNYSDqvHMVBZmRcCxmncgBm0ULZ48Vjhi0WPYIxFGZaIVyviqPTGqn+LogEMSU7xUzscD6PKGYbGndzSly1cRgzYA3Yqm1dqyc8QEFRks0aP5ku+bENiOlP+bMfnxgZqUgMsjpmmGv1uv80H2L9tbyZ7K+KxWbnZt0sdb9ACU0V1NKLPnPrDxqw2l87LsJUb+MW4yACL+1BZ6whX2Fq9l2aUGpCGLxDBsjUMKPk2mFnDLAFQpnqTo5YKHhybobqiAK81phjg7M8P4AdWYVmbtHppXkHtBQpUZw18IXvTR4s/mTO5medFK40SUhDabwcx8W8NabbkHcSnvWiAkiZTTNjiOvnZSdPNhQ83aQpkujxO
 thyRZCdi
 CNlZ5hnHcL0I4ZBOXk6lXCXl2n069tJfAUqaNXfXV7hiXOqG9qCyoDRuJ9VRPBw0NeRao74IBNgOigYtTYMUUBO0jtKulS66OdM/l4/FB5FdHY+IkCcFjxCb25B0kws26FXvXMcIecSpyu9T0CLiVW2ijTa/mb2j6oKAn8cVvomTO77C79BNjQc3M5pLfLK65SOhrqBgZ9A/XmlxqXNckWt3bEtiSOKZ8Vk9XSobBi7ywgn63PhQ/xFMBUlH0iSPk7cbzx32H0E+lNptv7kANDgOQ9qvmPi+H5Z/Ot/bu5GvIxrDrQ4Pfp9UWaKtyRgGIcVN/p+UxBQqzdoI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 4:40=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 6/30/26 15:47, Xiang Mei wrote:
> > On Tue, Jun 30, 2026 at 3:14=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> =
wrote:
> >> On 2026-06-30 15:05, Dave Hansen wrote:
> >>> On 6/30/26 15:02, Xiang Mei wrote:
> >>>> Please feel free to ask any questions; I am glad to help.
> >>> How do the CET features: kernel IBT and the (theoretical for Linux)
> >>> kernel shadow stacks impact the situation?
> >> CET should prevent this from being the target of a JOP attack.
> >>
> > You are right; CET breaks the assumption that this technique needs a
> > CFH primitive.
>
> I'm not sure what you're saying.
>
> Are you saying that this ENTER-based technique is worthless if IBT is in
> play, so the new stack gap is a worthless mitigation too?

IBT makes it hard to use a CFH primitive(including ENTER gadgets,
which are a subset of CFH gadgets).
Currently, it's worthless to enlarge the guard area for Fine-IBT/kCFI
protected targets.

Xiang

