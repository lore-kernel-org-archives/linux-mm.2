Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3D3CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FCB6B0005; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377D66B0088; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E186B008A; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 19C6E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:29:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A88A8C192D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:29:27 +0000 (UTC)
X-FDA: 84858490374.04.68E7275
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADC2440006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:29:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WQiEhU/d";
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780964965;
	b=E4uAc1f3qkF381E6UZZ5CMw2/5ojjiYfEVZ/e6j4m2K3GwWfc9iR5dVtEWfPyrN5sg1sKO
	KYj639QszVmdK6OWZWSoTGpBVoN3ZZCYNfYGS648sQdK1k39aN15xljXifTRex0myhwven
	+J8EvXgtU9Kk7gMAPmMlf1z3aB/qoKo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WQiEhU/d";
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780964965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krb9Nv6r6GcZphF82K+J/njVb/sPkhDh1+NI3KGdLxg=;
	b=bHvNIwzBkT/iInp4lud1QV0xw8gS3lDSq4TwsAZGIdyKnZIU9tF7SmwauGtCj/ZQ0e/1Sx
	tL09bnEh+ZI04H5QsznLHgywwMvi7g2vVdg23RCJDvjY5dSOfEWZqIe9unBfuQ9LJif+E4
	omkEF/yUfXYZgcQHyEZyvB1IMUna8Cw=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51765331535so2061441cf.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:29:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780964965; cv=none;
        d=google.com; s=arc-20240605;
        b=GtO5h2v+gJaGCDq3CTgMZ1AKUkEbBGElMXU2tuoMY6TwWQ2RandyzfTHfQkhO+Tf7y
         eldfrJXsqhr7GuAW5X5HpRvhVD3aK4cOap3jbamtiQzj48xbnEkWTlCEJeqzg4Zy5sqN
         4ubprkInFsaXiU18siItsB9wVM/1cVHswAOHyhlxvafFp8pg8GnsSoCVRBOr7i9oB2lm
         LNzahramaxawS1nWo2oFuQZBOiByrA9o0rxlajJTm4uOO6blVqoAzZuI0aDPIkscRyeB
         +V33BvGyPlYDnkc914qZrNqPwZK8yXesgf/40agWOVSl5PGj20I6rW6oRikjPgJXPihs
         5V2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=krb9Nv6r6GcZphF82K+J/njVb/sPkhDh1+NI3KGdLxg=;
        fh=SUFSbo08gE7pUS2HIVBrGZEKQAV21knGYMAmMKZUzvE=;
        b=P99HVP/dAkpsPOXFC+bX4QjtxkEG62WTagnZLmFa7j2f0AOLQo1OmS7hFqs0S2khaB
         GB9AXzw0XBOW94NZyYx8pCJXC4jqmLGktsj/Rez0m5V7esbOD2HS7hwTzUDUnnG+/qdL
         N+hBHaAY6E0Qy2drwc28sUJX9UjgabJiBIk+rvnHPk4DamvileefNXatZc22s6VYPEO/
         UmcH/Ro91t8z0eZkE/k1VzGxLn4CDqD7kkdTJ2p3bcKoP+lVonJowGGYykUClVwQGbds
         OwdI26p7K2lTi1tW/aM2+B95N+fRP93ICUd1jqVm+O+WV9BnUS+6J+UPEdsCaoHdcDub
         8UKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780964965; x=1781569765; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krb9Nv6r6GcZphF82K+J/njVb/sPkhDh1+NI3KGdLxg=;
        b=WQiEhU/d4LKjr7AT9lTv3ncPSEqvIHAZlCZg73OTuMn8TnGB6jZ0LzthVuaQMWm7fW
         Q0mL6tVZtCWdU2MvsNVT2mmi/Xqe8AgrKnxpPAMCIuteq9PovVhE2u4U/z3RwdEuTLSj
         5v14Z2u0fRhLJGawy63FKUmx+Sghpv8W8PKysM9tx1LyALo9RGOQ/a1dbSSfwKz4a4I4
         FmkdLoFoXHs6j2T34wbwFPAtenSGzHjOnjflZTOtnHqB4vcznhwFl4Od8gWClMP8wnXU
         F8Ui4Iak+1nIBo5INRQkov/UiiGFwEYdXha0xDU4A1WYLYTBrFU7sM7PbNtKkPAqpFoq
         Mhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964965; x=1781569765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=krb9Nv6r6GcZphF82K+J/njVb/sPkhDh1+NI3KGdLxg=;
        b=Hnn4Q+UkRiqEOKj9hnY0D0+gtiaJ2mBT7r5TEtpLSv668VohXwlQEHUJJar3Ufr8DP
         ILkLPAa5hmCYLYoYSIW9Lje482WgEG4jOJGVL6iDIIZq/FJ1rM9Xilcrk2qktYBiakm5
         7/HzxYSx3ymaFVApr15UeUMod+izYjoFRKXSL583CkwDffWAbYqH1LpKTWC7MZYC2Ghg
         P9Rkb7imxb0IcWVZ6L3+2EDwBosQZL+NSFun6iecH5gsjnITbfQ1aMWjHGre/BVFMcyj
         qC6Km1IlBQYxOMWAXEm3J/EpxiUnY1E4oWFfXFA7pwCi1gM6bfj2S7pZ41YeCZrGZxIl
         zFKA==
X-Forwarded-Encrypted: i=1; AFNElJ8dPilxT5C0KosfKimyJxOkfGNSmWThra40ziLFuSNH7231oBeenWs3ca3i32z2yd4cNAvi7hHCDA==@kvack.org
X-Gm-Message-State: AOJu0YwJZXZ/4qgICttqOBzY+7rcHx8wqB2ge5dH2HyYqfUwKBqJy6k9
	cmUPTKyDX4ZzUvBlqiEgSshMbIWQM4vqop6AKxhdWZLGeaUEOyaKW3S4Rs/iXCS1n17FQ5bypKw
	IL0YWyGcoHSgcaM6vzXF8ofeEZvd2l8lRZXZRo0q8
X-Gm-Gg: Acq92OGJr0Of/dcobhC6UhnF6SQGOYXcXoxfIs3APWONZshJwcoVkJ1LhhI5jugNeIx
	a5yIYRTYJm+tNTzN0SDsuA6oo6vr+YCDRNYygJYk67q2/js1nn/qicORYjxdVppEx9iYHBdTIZv
	56o4F45Br6oElweNXlVPgye6iP0Pfsd0IOONUdUz49pNNkgbUavQwS7+9MX1Knh+vvkn8yBEl0x
	ikjy1XNLzHfQnz1Xc7cekyAqoSz1GZ0NhVr6O71Qak1STPxutZ0MXeqlToUBK7kkUDvtDKQwmne
	S92P6l/r7pz/4G2A
X-Received: by 2002:a05:622a:2307:b0:516:4f62:85f1 with SMTP id
 d75a77b69052e-517982b5301mr36127221cf.22.1780964964188; Mon, 08 Jun 2026
 17:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
 <20260605170858.9ee9ca2181a041bb9a4c3098@linux-foundation.org> <CAL41Mv6pZOVacLdUGta7UnxmFryumBbN6=Po50KfzgLzMs2PQg@mail.gmail.com>
In-Reply-To: <CAL41Mv6pZOVacLdUGta7UnxmFryumBbN6=Po50KfzgLzMs2PQg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 8 Jun 2026 17:29:11 -0700
X-Gm-Features: AVVi8CdW_XYnqC040qYuOHa0VARrYIaDN1WkkLFosCihB2CV0Lg9ChpwDfTu2zE
Message-ID: <CAJuCfpGr+K+fWK0zxVdMqGwKnr9Y26=Hn0HYFpnp-sUBcL8aKw@mail.gmail.com>
Subject: Re: [PATCH v3 0/6] alloc_tag: introduce IOCTL-based filtering for MAP
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADC2440006
X-Rspam-User: 
X-Stat-Signature: yj3xf4uh7tq4dywrf4wzy1956afwrjoy
X-HE-Tag: 1780964965-890069
X-HE-Meta: U2FsdGVkX1/AMkrwKQc6Zr/gNi7RzZpwAegn3ioBgkaQYHmgWdZeoR3AqFB9DDCNe3yRZ8gnXBFg4WOtsUQD25kmiOKKN4/ANoqcevHH/WBn0WwCHPcH+K0Uqb3UGDHsD5WgOILipEi9vkcPa1iH1mifSq126DL0axBPprTzCMae3reBKELu3ArxGP89nU7AgAA4O/YRPAPjBDmNv0METzUBGSBVQ1iYpczE/tiTv7o2GwPeuxdmOAva+7U5V3gvNwQiTr+yJHuzsVE1jnNo650Cayw3AOOHqH1HTpp8fLzHx7sCeFcgsp0TEFJw0hxBXux/sDFtSjIg7uTndoTTtJ92KIS37p7d7dzhw7oTsRU8iqyxYsJ2TDbb6D/ctLfSDpnvUWwRm2dpR7jo3NIXxtHTWrYeRxf96J+sm8qTv/rDKi8+VYTDYmyJ04RoivitVU/k8t3RbPPOOH3vQ+XOuJXLKgVwCoZNaqWtPwsByJUbAkrjn33XyzrOUba2l6LIHZxYVdHfN+uA10Nzx91IC3aeu3RCEuNX/xtDC91mhoEpO/RpXwem1Rw+Ki43PPk4kOR1YQ3gapEjmZJtxdTl7+j7z0/2Jb8j4xHaDLSQucdeX1THI/77ocOwFXIxwpjn3LnqSW1vEBCb9jwYlUO1Xr6eROG8AC2IRzMFRFKixEL6w75nGcRhB7fz3RO7j9+lEXYhLrQxYTGIBx7b330MMwAo5GigWLoUz6cuAuIeB85W9SmCuhw6diXgPZSV1jcIeqZOr7apgTdsR7kD87ONOyuF0TRIWPatG4oKZTalMoydHNtbJVUwBWaAU+DlZy9Mo9W/7cyL6+OsxuLnlsSYS7+Z4OS0qJq8S2BCiGcitSQbDrLVPKMZdx55EJ4Srrjmn7sKk56eA18bmwdWrayPihMXkSrUjZTzFqXWkPyE+8mLd+HWlGSSHdqVrVTw/ivZNMMGRR8CYJIu/F1ZsUJ
 Vmd4Hn0a
 p1kAAAWcvbI6s598caisrC9YEhBHXyDQsxeCTaxn7/vswtdk3iiO2/oVYg37CO89AF32ch0GLVc3qUgRBxrm/yDs7N84mP1KV/7xgbJojA1ZbJMzRtKgAvaOBjiiQKEUetz25uyE9UGgE6oS/CCXyBjbx+muUssaXZ5FPRhOUVWwUe0ZOF3veG4ACrb3I91lr7ynKZJ8JK/CnhVAng8+QFlfvzT9XfwtH/CEHvNds4ZbF9S2xCmXTVdGIekD+/3XujxxgqQqCgxxIbo2wNLTQ3EuMS8P5GErwsUy06dxgDq6KUDu33vhcwCw1NGsA0JbuVRnnoadlQ7pcLIIcX9vWpLXstj013V/EBxj2+zrTods9CLiISfl0vQHzteJrXpskjFeRaqV6REyBpa4RUfjReWXlNiE8pCr9Wx2T+ZYq0iGpM6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 5:02=E2=80=AFPM Abhishek Bapat <abhishekbapat@google=
.com> wrote:
>
> On Fri, Jun 5, 2026 at 5:09=E2=80=AFPM Andrew Morton <akpm@linux-foundati=
on.org> wrote:
> >
> > On Fri,  5 Jun 2026 23:36:45 +0000 Abhishek Bapat <abhishekbapat@google=
.com> wrote:
> >
> > > Currently, memory allocation profiling data is primarily exposed thro=
ugh
> > > /proc/allocinfo. While useful for manual inspection, this text-based
> > > interface poses challenges for production monitoring and large-scale
> > > analysis:
> > >
> > > 1. Userspace must parse large amounts of text to extract specific
> > > fields.
> > > 2. To find specific tags, userspace must read the entire dataset,
> > > requiring many context switches and high data copying.
> > > 3. The kernel currently aggregates per-CPU counters for every allocat=
ion
> > > size, even those the user intends to filter out immediately.
> > >
> > > This series introduces a new IOCTL-based binary interface for allocin=
fo
> > > that supports kernel-side filtering. By allowing the user to specify =
a
> > > filter mask, we significantly reduce the work performed in-kernel and
> > > the amount of data transferred to userspace.
> >
> > Thanks.  AI review found several things - you'll want to address at
> > least the first few.
> >
> >         https://sashiko.dev/#/patchset/cover.1780701922.git.abhishekbap=
at@google.com
>
> All, please note I missed attaching the reason for choosing the IOCTL
> mechanism to this cover letter, but I will attach it to the v4
> patchset cover letter along with other changes. Thanks!

Can you please add it here now so that we can review that?

