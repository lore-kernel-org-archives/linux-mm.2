Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F37F436A4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 13:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A1B6B0108; Fri, 17 Apr 2026 09:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D41FC6B010B; Fri, 17 Apr 2026 09:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E246B010C; Fri, 17 Apr 2026 09:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E30E6B0108
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:48:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20E321AF5C7
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:48:28 +0000 (UTC)
X-FDA: 84668177496.02.D703AC4
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id DA3A3180002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:48:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=R+ga74QU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.219.49 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776433706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RaBVFY7AnNSnD9b2BentSR20VU988SdCAvqd5GAeFSk=;
	b=LE3Wty5Mmi2JhK3DIU074foXAeN5KmggORnrXzjv4qT4LKGqliOrZ9/gx4le9DIFMDlhuz
	56ntz6tmUC0+U7NdwbEiYrDAT4rmNciwsjeYZCogX31k3FEABxkKwe6Z2Bd0NRnEefcFq7
	EKDuwainHo3BP3kuscC/yWxXSrAD6gA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776433706; a=rsa-sha256;
	cv=pass;
	b=fywHbEFLIFJTfR3/TlersQYnSuOE4bPbJluhcUq25BplTdsJAQWCzqomOvKRyqvY10yTGY
	LxRuRKmp+TIh4qvx9slD2CxoKySfRQvxz9xkXQyzBZIsRnDf9HgWV927+FMaezpf3vjVyE
	QL8clWfkU9cuN5f8Jwu9//LTo4sw+P8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=R+ga74QU;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.219.49 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a3b0242631so7004436d6.3
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:48:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776433705; cv=none;
        d=google.com; s=arc-20240605;
        b=H5Dc5Pt8mHaO9zcCfjndHea7ADDcrRbpwxMDor6kMTe1loHLfkToqWhbrLIq1w8iNw
         m9OwCUpAH+XdgbNBRNXTrkrSOSVw8P3DN0GvXGPibuw5NOauQ8UeZBOmMe5py8XVzpk2
         H41OIT17DOd+AljwcX4CTKAYSJn5oD19O6f7BcMOm3je77f5mM1reHWZIa/QEMdcp2bC
         WGvY+hNc5M0d7PN92nymb2QoRnh3MNqaRI+xT6ho8y8l8iqg8detfb51x6xK9X41F2CF
         A47QdHn3xx97qroRZgVPNbFlim7RCf4GLzr20AxLUEZiRO2bmsefAnWIldfCIxKnyd9Z
         jZcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=RaBVFY7AnNSnD9b2BentSR20VU988SdCAvqd5GAeFSk=;
        fh=nttmVvdNUfkvudkUQ82hIkcV322VxIXsPu6LwqnJRdQ=;
        b=AwMIlN3tmg434Srd7GjvrdR534PSax66VHnJe9iWb/EDbPa3H1e/ewO8Wi7dVZGK08
         GKN4MGoUpV00Xa1jEipgOcSoywBFeSDBDP95At8m2/rpIx7mDrJIad7fWjCDKGpsYjPq
         kGM1bcyHHXrBLvGJMIb4fmaDn4xSxTI1SEa6XRus+MVVnIxtvy7RMfpx7z7G5+9jxzMW
         u3mZvAPSPSd3MovF5qnnzdH0vbKjH+Hd9CT8WtOewgTvVu0UQ1PYzwQiR0/1q7eSeHK/
         YIxHXtk1sLFtwyquKnchkRt457O+2D6uzGuIc3iSi8EE7/ZGfVYrJoCt/cotujujfm6V
         2VtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1776433705; x=1777038505; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RaBVFY7AnNSnD9b2BentSR20VU988SdCAvqd5GAeFSk=;
        b=R+ga74QUZCpmrrSgYosIE2i7a3PSn6/NTbfH9IsQLcW+nwGWLrtVdVL+HwMbcv0yE+
         xkihJtAev+58oLkK5kaGV67mdy82dbrj17osTVz4PNnxxO2amIDHmi43RroD/Ch2wWNf
         w7Yr67YlJPjYOru877/049321acUvB4wthgpM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776433705; x=1777038505;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RaBVFY7AnNSnD9b2BentSR20VU988SdCAvqd5GAeFSk=;
        b=jQt2jHPxoWLr08hgQ7jErrym/8pmmCSSB0XVMq4JGugh/w4qeg9S5oGRdbbBijQrdc
         m6a2uWOoIYb76a6eQPVPPf2vh9V5dnT8DaCjT5UYhigDLy7+Sw/VpN3IrhIthEvB7Xkz
         MVtfRzCVp5O6OChoXn2rOiONJNYusCRfKxS+k3KsD6TpIV8VpBc6NrYoVOLPMNDTRKHe
         3mVV9kbeyvTkxM2dGhiLOL7adGiHWgd/7mOt2ZSGFmKbRBnoYEBiZYBdRhocTreswJnh
         Ak/pXjbGWIrDvq12aSpxsM7QS8x9BC4RLA20fBZPgl/7SDHCYWs8K5gAseIjPbWSVBvb
         DBxg==
X-Forwarded-Encrypted: i=1; AFNElJ8TGFItAuOf62s94/pGgcwiXWHcYEmiakudKDnXGePNWrt0Ed2wjHLF0VixQXcM+/cFjTXnFSiHSA==@kvack.org
X-Gm-Message-State: AOJu0YzyIF6KwCf2OmpSxqY2u1+Xjt2QkkSLsDswrc27W+XPi/DdqtB9
	2LypKGXkbu1Sj0lzA3KzHTSB81/dQrhBMW6bVLCuV6gk46mxK5yEvapp7RMZpu1NgQh6ZXhJxvr
	MyU50+hyML8HO8nJQupWTae51ptyRvFDAHOrTDPzceg==
X-Gm-Gg: AeBDieu2qDINEyhEgLNLf5j8YmHSF3SCbmMfxN1xTvsB9kgQYDLoCrY88e5CsRIihfa
	5mhuLQf29bHXQ/lo+YUxl5nDAHVnxKph/xdG/hTQNHcfghGaZB6C1s8vYs++03Kny+fbCIp2PvQ
	zpEYwY0cpw28jUDfrpZ4unI0NV2WlkKohch3n1dcrwY+mZgjRC56fGS7eh6Ko8aJfl/o3cGuy+N
	URA5fnoCL8+jrsQJybvmuT7uV48C9VNGUYcxg1SFF8MceVL52cqj0IUDO+a7BBP6vZaf8qyKRaS
	yRq5Np5FW+rac5ahU1P4bZobqcw4TaHU9/98thZ3nKhyLxI=
X-Received: by 2002:a05:6214:470c:b0:8a5:104b:e361 with SMTP id
 6a1803df08f44-8b0281693c3mr37122346d6.50.1776433704794; Fri, 17 Apr 2026
 06:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me> <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me> <aeFuarTL7xBbut0F@casper.infradead.org>
In-Reply-To: <aeFuarTL7xBbut0F@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 17 Apr 2026 15:48:13 +0200
X-Gm-Features: AQROBzAW7iBVOcbWzWDl5jliPnjlXzb1RPsfJkPFfxAumnXuWNvcGTGMUJbuMrQ
Message-ID: <CAJfpegtAeyMRENdneJkJrMKu8Uwnyk9LYBThjvTrFjHmPr6O_g@mail.gmail.com>
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
To: Matthew Wilcox <willy@infradead.org>
Cc: Nikolay Amiantov <ab@fmap.me>, fuse-devel@lists.sourceforge.net, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	fuse-devel@lists.linux.dev, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 98cfkz6aone9r93sp4akry5h4qgunnuc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA3A3180002
X-Rspam-User: 
X-HE-Tag: 1776433705-686113
X-HE-Meta: U2FsdGVkX1+LkTUgx+RcrsCjOm9NB9PIxy5xJRN5qgADcw5KA4GU0axMNfgZ7pdZoscgOjRHC4VshupJeUXdaW4kWV7RHmcIXOTX4oKo9JEGd3hRr29MZO79qrFvpv785NTHEKd3megU4LmuBgjK5zOZygyK0gpXnKHlaRhCqE2pLF3kJD/mhNJ9ejzTA2Bb6eSIavPPSq1EQwyPONKxoEpbp8OmfSV/c6ye3HNC8lKIw3UlOEUjDHpQGC9s+QY3YVgUY970Rv08d5yxmWySkebyKnIG/E5bSxroOjUtqaoJE6LhguXBP6amCtzv7lbONIRGQ4MqGrim7fsF0Roug1nK7Yzx5H1sTkBjoSCFBbUBqch3uX83n0j1mBV+bBrvOYm5iwdYxvhagF27dz7sRdtP0lz9Ob4VfJKV8bpURRS8p4g7CSEXBZGcjK/TpUkGuM81pns9SKWE0IMMcKArXNJSD3mHNaapj2jRh0OzgO4ESCp+r5G6zF3ZIEAsjneUtQDk3aKcA+96mCdk7RbLMca3jrkS1xIh4FdRAtCDbDLlRGiIN/fGSK8dQBSBOkfd854iwYCUdH/K5r3mzLb18G0Is63bvVEGmkUZ1NuV//kJuM1LbQDCSCAfk5sFdE+z088w3Jmu6u9dokc/eRoB4FLtkhxNcAb7g97/mkglbKTTUA9Hacs6Ar/CLTPwbi15jsoQFKEotICwNByJzYZse/rGedsQOnhjPKTU39Uf40z/9EuL17Gw7CC4dZF8sgRcJFHQMnxJbNk4ca/BBxaLC+v+gwAxc8YAE/hwwevkrqpYw2UOnjFPnO4Z6HnplLSWy+CGXy8tQUFfEJ0UMxGJ4of0LnJXvZ0kWKi/K9+4NQCrQI/29nlxOL0XzIgASGfsTYuGIWnZxAJPolc8HG3Zu6tjvqpAQP5pqP7dohhpZ5gAJ7Ho7R8IZtggHmBcNMCDkA8t2/IYDTBhx3246w7
 LDFMmUYO
 IaG0ARt+jkwCiMtqF+pt3MpNvSMSeq1Oj2MhvK6YZxQZPIvs3RMc1EpYL0FusQMyLDvx97YV6vqou+4hC0+6CrLsBRUB+XWADNEovxXnst2lm2MOWL8JJEsxNSkRpuF87vZOuFECfetoZRAybxIAUMeMm34Z2s4jmHkSzEbPdcAv86d00iPtXfiIPu+aQqQ/8W1GXRW6hDvhB2a8hbzdL3GCF2wpQaDkepx25mJ0ShN1vQmPp3IAxuUkPM2gi90q/H2OWr1rYg84VzU0+3s0JPZNinWcai2Ia7lsgBLbvmbzxM/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Apr 2026 at 01:19, Matthew Wilcox <willy@infradead.org> wrote:
> What you could do, rather than unlock the folio here is to initiate a
> read of the folio and allow the read to unlock the folio.  But I don't
> think this is a good idea, I like the idea of invalidating the folio
> much better.

There's still a race window if the page is invalidated after being
ref-ed by filemap_read() and before i_size is read.

Should that code check for a truncated page and retry?

Thanks,
Miklos

