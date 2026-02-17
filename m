Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3DD2E6816E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C61FF6B0005; Tue, 17 Feb 2026 05:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5DA6B0089; Tue, 17 Feb 2026 05:37:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC6DC6B008A; Tue, 17 Feb 2026 05:37:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 968756B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:37:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3682EBE85E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:37:36 +0000 (UTC)
X-FDA: 84453597312.19.E65EC41
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id CCDC4140007
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:37:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Yf2v6w7g;
	spf=pass (imf09.hostedemail.com: domain of haris.iqbal@ionos.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=haris.iqbal@ionos.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771324654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZMo/PtOIzSJeD+bvKh62aH9xtqgsP4XaPk4C2v4d9E=;
	b=4iv8FfYy2ANJa2tsnKalKkcG+L8oAe8MxI9kTU1Vh0MrESY4Gg2OMSscCK8xuXIgtSzi0m
	c76nFQrWmOuF12I0fIl5ZL/mSsJDQVv7l2amB4QLkluVChB+cmBy9LF0wzBRMgwvyMDrCB
	4X48PHhjze6DTKyuXXR+xD274HMmQs4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=Yf2v6w7g;
	spf=pass (imf09.hostedemail.com: domain of haris.iqbal@ionos.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=haris.iqbal@ionos.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771324654; a=rsa-sha256;
	cv=pass;
	b=1GadLJ8gEDAj4BtzUzxZ2kypscpQ5iYISP7i7bsEiB3z1VGR5pzbQBK3DFlEr74CP0s3+0
	VwzsdnmKn7QBFYtBefGSjT9ay9L58YXJwzGgLly09FDIgtMSfmjL3p6lu+qraXfwqJrEbu
	sHJFGcMNFIHFkwlZr0Fq0ZoCvsxfdjQ=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3870c7479c6so25852951fa.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 02:37:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771324652; cv=none;
        d=google.com; s=arc-20240605;
        b=BYO7D/62quLGgVSNZ73syuBPWjAK3OSI/r2wiXYhFbfzgFshkcX1xPKef5yazD1HpX
         V0vKmcedUEC6GxCXqk565J8owazdGVeDNG3ZrfqTbKQiddTLRkJTrLzf8h0ZE1Rb3rDZ
         njvpkM0obEKszgNuWxWuCtVVRsA5khtS+N5ONLRLJkEwD1zMEEK3UIUbPRJe3ge9JlIM
         cwp+DxcmgKHtzk3H22CtsmPK/vxzKLrWFaLpHaXMTggaohOdlXMUvt6T0mW19f4wvu5S
         S/jPk0uSDlRpeC8DR2U22KmuINr05xeZhuHCMXnPLs37d6OVh5M5vCIdYiQ5szfIs+ox
         ATLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NZMo/PtOIzSJeD+bvKh62aH9xtqgsP4XaPk4C2v4d9E=;
        fh=M6k8ZyxUGYQegvBzdkdwt6QWsUsZ3sxgpwlAXrOvG+c=;
        b=eVxtjznML8+7KZ53/wza23aMn+UZBPou3pWeMm4tJusOh2MJX/jMw8VBdi0ye0mYCa
         OR0BtQoTkLov4wKOvlMzQJ4zGmF7mna2mikN9ylMkMmBYhnWpFuMYV+UYU8i+qo9jmy+
         m/yk9g7y+U0lL9iPYYRYG4sjpKvbusIXMJ58olTzd7A4xQBxkx5OMBLjq8xUupO2D18z
         K/Qwlt8jo1ZC49boaZTGAcrFcHI4Ae2j+emKJZcUoz8qo4lreZ36lNq2P3/2yt+5zLLV
         Pz1tYj2kn5dQk2YaeACRLSI5IQ81CiwwePe49+RB22FJg2n9TKlQPXY83PLqid5Hrv1P
         CGHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1771324652; x=1771929452; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NZMo/PtOIzSJeD+bvKh62aH9xtqgsP4XaPk4C2v4d9E=;
        b=Yf2v6w7g02JNGDlF/WmbSHfuPXF/rdxoBTkxW1D2Msb6RnlXA4JcUua7rrKPxqUydW
         bOG+R6q7U6h+KcqQAai8zml2jq3fpa7HTz6dbTzsAevlpwm82s9uYT6HN2evGLwJi0Qo
         1jgQaMhVffJC7DccLPUn6GO35iRtRDYkFYtiXSzjeZqCX1V7v+Vt6G+n6lMUqzvV/r1o
         TYN0hSa+dOSmsPi6ClGjTtt2TB+ahAdEUIbbGWF4+WZISnLL9WxgxBaVWENKlpGjP+/h
         K7PdxTuDAfHIncNzr15ZFDCs8A8Fe7y2ccluMj6ZldW8fJR98CXVUs7PZbbUx1DpKJTy
         OckA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771324652; x=1771929452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NZMo/PtOIzSJeD+bvKh62aH9xtqgsP4XaPk4C2v4d9E=;
        b=FB1xBo4QCPltKwYL+94zTcjbfArBdsgxZQxcwEKZNM4o3afeMRVfuiM+38J/gyDsUV
         KFlv6TOEdwnlestIayfehlMk6wY/23SYSUicmdBh6Ns7HyD+zcaiokf0zNyqxlEk07p3
         ZFwXHyPaIaCp2REQmxHOubm0fWA9G7wPDXb2wddE6BNUav6x80p98PpoyQqbgD3gJbJb
         FpftcKZloMu3dA4hH2O4lQXCEjtaiWiVQtcM4A5seHunaqxrijMNGIgeT60XC3dUZHXi
         MuxC1TsG+6aL4shQBa1XZPHPlNa2dpuV85Uq1D1L4R0oyQW849u5iGSdPcOnmLOlfCdT
         9EFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU7clNNntgOmUMCC53oWyInoaWsaQ0d6VP+597m5sccbWodIO2K62V0gYX3N+WGbH+lzBswmjAqA==@kvack.org
X-Gm-Message-State: AOJu0YzkdT4HEF9F3RmcD2PwsveyMze/9YzfgF1FK1bwxg8yWCYgVTBB
	W/rGpGEPcUvWDQAt5aiZSt1yx6/AxwEQC/6IRJTylFwJYfM3pIRPUd0238sQsgSx2UIfjCk3rOC
	A4vpuUbrWo5vLsMzUo/KlBXx9BsBSJCK2uHZEoufO3Q==
X-Gm-Gg: AZuq6aK25jvOxb5NFwIAQwSF/XYQqCKuCGt0WrZ3w73CLYht5+/4uSGAgUmwVk2MdBn
	6LDAQO5xay5V1D/ZGLFZBonkHeaykgZCHrZwliU1j2SDDmmkZHcm2zi6lOg6uGH/Ja+ShuTKMNf
	xCHeTadkM32nO08ff8eSNSkoFrwca1EYqmtECR+Yf6IjcHIhLWmXHitKbFjxfSRJXTyAcIeb6OK
	mTXDq8F4apWJysQc57zGQINecG4OV/TReEABQ31Q/7GcxcAYhea99wTE+6mhitHVr6r2v4/0QJv
	ubwdryV8vX5SXnooaoQP/gH1mxt9h/LK+fpZxUIhhtuYV/WJzmY3V2S+V0SyNUPu7fZP
X-Received: by 2002:a05:651c:1ca:b0:386:ec21:c87f with SMTP id
 38308e7fff4ca-3881b99cc9cmr30135731fa.42.1771324651832; Tue, 17 Feb 2026
 02:37:31 -0800 (PST)
MIME-Version: 1.0
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner> <20260119-bagger-desaster-e11c27458c49@brauner>
 <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner> <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
In-Reply-To: <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
From: Haris Iqbal <haris.iqbal@ionos.com>
Date: Tue, 17 Feb 2026 11:37:19 +0100
X-Gm-Features: AaiRm52ye33PKO28CcExseV6coNOG-rZ2nBeMP78z80h8Dwp-N455yQLK7UlhmY
Message-ID: <CAJpMwyg-3-Z=ZDC60Vn0s-8Z78VOPKYmvX9s=Nnvcoao4T5zbg@mail.gmail.com>
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, 
	bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, lwn@lwn.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CCDC4140007
X-Stat-Signature: s451xwb6rzmbo3b1ibr379cuez6iah4s
X-Rspam-User: 
X-HE-Tag: 1771324653-5471
X-HE-Meta: U2FsdGVkX1+BeIrH2hrsoEtKtZmzcpv+ADPjns+GFVGUhj5THmN5uFAn3BgvLZdfOCZ5ok4+isysp1UrEy5jMWthTv1fAlVksxLKPevIYBpzBtQ4boRkOhK+cO9dPRsoO7jPsRLhFBsQTpP5eImHE9ayThfYJSRx9OPjrB20pnSF4QukMnUQQQn2q3sr00RstQCrO50EAaK/Qjo5Da1afvYDEr6JWctmZcR8KHlvz9p21JByPxOUltBoRhd/5G8QW9AIRnyLZOWNOgenyWxPF1cFoCZCEYMixJ5Le5Ej9cuCCOJ1NAcPRXwzLxOSry0LAvlpGZMakRJXBZz/ko1Kc8a4WPo9rX44H+ht/gpj21NHB4EOrsOjA9jppOXkCtquJzCr6zzyzi5exNB+JIty6atGKjF6mVhJa7MsUEoEpaNkCxycjx/Dd33faREJF9ckdWW6DuEaL5dPYx3aXcjMieQyueDqn1w9k6aDMuXlCEisgr2QqhD5eukZpTqAEeD89kZ9uMgGzazB3OJtT4xWW20P5l8n8z0BJxlN9fiw4nb0gd5kTLT7RjwROYrbXGAun4OfzUlFNpZHm5k5lW+6kAkhWp9o8TLmU/EMT9rcfRaRXJYuMlpHJMdJQ81PVIRZxo2AtZFdcqSijss0PAc27et2BwTkPKeaPmNQEGvhsGgcRmusXHKiATl4hzXvm1d0yNqZU3Ln8FxK49u3+64MmsIoPIM/NICvKyopBVG0vVtsszYEklDLLcbrYMfFb/mHTrQXgQqmxCkpvofO1QnnSSFyVM8hyDDsrueMIs/5Zdb3AWX2ctzr5T6dcJ0MuK6PO1rcoJFHJOXV1kL5sbklOmfNTYhfYTtSi5pGaoWQKN7ijGpc1RjsHzghtEaPYbVwo7G4aSKWlze0y9uT4WhrBegoITLnfRZQQVLtHO4RprILm6qo0bMEKgnmYtIrudnA1cG0e+p6T33Y8ElNoaX
 N8uniJtK
 CgWdujKyag8HhEo1zP1qX0oqsfe8MdiyegtRIO8b3rEYHP+xwblmgRXB+hR4QE2t44DAghEeujN9It+6Pe47pGUVPQ2ziRgq5cV4HZhngC+7NjFomzHJltAAvXyK9fFhHD5VRP61/+Gpskw7aMnfFGHTKy74v9vKD7kCdiBHMbQGsyZvtgD6OKFyKUw1ZaftB/h9vTtHz4iFG+aBWrJegISQ1EWGj21RH5k11Cx5rxoKnivumhElBVP4fkjRzlfSEJnCyuc3ndim4KhTzFkmg7uM6Ag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 3:28=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, Jan 29, 2026 at 05:13:52PM +0100, Christian Brauner wrote:
> > On Mon, Jan 19, 2026 at 03:26:39PM +0100, Christian Brauner wrote:
> > > > (1) Fill out the following Google form to request attendance and
> > > >     suggest any topics for discussion:
> > > >
> > > >           https://forms.gle/hUgiEksr8CA1migCA
> > > >
> > > >     If advance notice is required for visa applications, please poi=
nt
> > > >     that out in your proposal or request to attend, and submit the =
topic
> > > >     as soon as possible.
>
> This is (likely) the final reminder to put in your invitation request!
> The invitation request form closes this Friday, 20th February.

Hello,

What is the announcement date for accepted topics and invitations?

>
> Fever has struck me down so all you get is a bad limerick:
>
> There's a conference called LSFMM,
> Where maintainers debate and condemn,
> They argue till dawn
> What's merged or withdrawn,
> Then next year do it over again!
>
> Don't forget to pester^wask^wremind your respective organizations to
> sponsor LSF/MM/BPF 2026! If it helps, you can tell them that we're
> considering renaming it LSF/MM/BPF/AI.
>
> Thanks!
> Christian
>

