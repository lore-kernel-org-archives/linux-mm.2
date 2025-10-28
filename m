Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69629CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4BA8011A; Tue, 28 Oct 2025 01:32:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C9D800E4; Tue, 28 Oct 2025 01:32:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9898011A; Tue, 28 Oct 2025 01:32:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9B904800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:32:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46E69B8F9F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:32:50 +0000 (UTC)
X-FDA: 84046403700.24.9192135
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E5FD20005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:32:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Lhj32Nlb;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761629568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Wy1ynDaI6taIoYDlBwI1sYFOXKyWHxR4eO6K9jXR3Y=;
	b=1VF9ohzocg++85VxnGHKoSw47rU+arShn2w1aUNMZo4yTZBYZsJfFj624lBbmEbI3hq0nR
	X7NTlAGlLx5rscs6SxJ4IdJvAlmf7uqsH5Mp/OZ2MTVkarMYOBgt3UWoiXDfC9sYfeCi0U
	czE6nxGb6ull9zdvyHb3SlCBSbMnGzk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761629568; a=rsa-sha256;
	cv=none;
	b=GuX1AtwHfkiLaK9yOhPc3GeGLuCxyO/Cc+f1m3p5MGzUtuljUKvGgYHiXSyPrSeyH0BDdB
	MK5RJ89pUVSo7/NhO079VNjNP6lcRG5zS+CzW7aDXwhtsTyy4e6PdhfETNMroxbtWQaaq5
	JlQ91jXJzZf1sxicO0D+Sl+nfTeTh+E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Lhj32Nlb;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b6dbb4a209aso132419666b.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761629566; x=1762234366; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Wy1ynDaI6taIoYDlBwI1sYFOXKyWHxR4eO6K9jXR3Y=;
        b=Lhj32Nlb0QC68JT+mOy99EvWeoSSIjk0AY2dYiGBXFZGsLWvAUg5xUnDeZir44Vshs
         5UgRkrKyfVPddP2CMC5BBf+yKU5ok0Si5v7N3q+4+MB4goOpaPSc7ylByihg73SqsJTg
         DfyT9pPJsl2oU8YAIMgUNqBUNh3bJz13eoz1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761629566; x=1762234366;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Wy1ynDaI6taIoYDlBwI1sYFOXKyWHxR4eO6K9jXR3Y=;
        b=ltWg97RFmVhC7ADe56t04dN/zvqc1kmiv0yGThdKteGFKzThwbtsIFOSwe4Gjo7w0w
         UmgFC1RCuKzpgpUF8rTnefwxgTnbTJSWrfTpeLdPyurGj9RqLTuxOYxchvdcClePDNVc
         IxYhr9YegkQYi70R/7lQ6OibzFgRWc5LpSvaFFd1ktExYdelqyaeQFczUq/ILE7qox52
         ZaGfWJQlOXL8K7J8QPxYPB4t7jv2agAXJGKFKa3VTkg1+jSbdjVPntXOsGrksAyGGOYt
         85+oAgwceZ+y3IV1akT95dGdne0velyJJPMOFgqHOmYOU3suwC1HykcQDSJ1t/EDQjXF
         bPAA==
X-Forwarded-Encrypted: i=1; AJvYcCX3ybmpF12pWKvs/WbNM6+jSW7sP9k6afnL1IEr1pLmuO6KnHCgwpxLyIvw/rN2TBI9tCacY30rlw==@kvack.org
X-Gm-Message-State: AOJu0YyuacE4APMFjtPbFswDSbHEIVILFrai6mxH7sUClBFcORvlaMA1
	DismKktyIRAM4CvBaJPwQ1wdtJp3BZLKOiC1aVx+S65bKV0NlEhINYg3yhDXzlFdjjyvr+FIAq+
	XguAbtcy8sQ==
X-Gm-Gg: ASbGncuA3wFZanIim9WmSU90K+4ACVZjyCr6LGD64hpCKWtGojmhdfaljYw2xtVnymo
	ASPRpiEZ4V7yAxie3aFpXrh8sXfwXcRo2SMvEx37s1mwZgJpXtdbvbcjUfgXN0Uq04AysM3XmNm
	IaJB0WK+oAKP0bjsAehE9BwSMKyj+AsYMJTFLKee3OpBQhbnoyeSwXJZqbNXQ8+W163dPAwyHBS
	YTnH1nNehz5a5sWVhFl9wlPSad5lihzfa3d6E1KI5k7jVSj5j2es0fW8l5EAgz+Qlw7TRApKieD
	/NRVR5Rtoj7ma/X4R79JHyUL3fSFMzeH0usy0YdsuwmUEsOzCU3VhNX7tqwLGTURlFev2RBb8rE
	A4WVfJIMCbxeUskwHnTyesnbnmwquoxVG08fA+fi8dVJeTUbXrtfYuKsio0g53EkU8HIF50dfnE
	6L96vv8KTzy16imjmwlvqhLhISdnS9HBf9FXNicpH4Ph9PiKemKQ==
X-Google-Smtp-Source: AGHT+IF2c1k5OwpDiYsmuUxKHTmDZTsnNtDVlp2OhZ/T9Y2XelCpLdx73ZjhKvnwvdI+crCABBwJCw==
X-Received: by 2002:a17:907:9408:b0:b3e:151b:849e with SMTP id a640c23a62f3a-b6dba4440acmr241151566b.10.1761629566106;
        Mon, 27 Oct 2025 22:32:46 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d853f97f7sm967179566b.51.2025.10.27.22.32.45
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 22:32:45 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-63c09ff13aeso9547204a12.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:32:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVkfuSQAPC+fab4M0uggv+t8h8Khtvkhb+9anaSt4QaHfShrXWeTes6FCGrQrJp7Dqits670G3kpQ==@kvack.org
X-Received: by 2002:a05:6402:5346:20b0:63c:1e15:b9fb with SMTP id
 4fb4d7f45d1cf-63ed84d11b8mr1725392a12.22.1761629565035; Mon, 27 Oct 2025
 22:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-32-viro@zeniv.linux.org.uk> <20251028015553.GM2441659@ZenIV>
In-Reply-To: <20251028015553.GM2441659@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 27 Oct 2025 22:32:28 -0700
X-Gmail-Original-Message-ID: <CAHk-=whCnWNXcmZAgxfV9p8rKJfjxcceNzaxia41f675+yEdfA@mail.gmail.com>
X-Gm-Features: AWmQ_bkREqIMu_f1B9dwguEOjRWmmtrQM-BuU5ACiXPx-fVfEkz6aAECfx6yPOQ
Message-ID: <CAHk-=whCnWNXcmZAgxfV9p8rKJfjxcceNzaxia41f675+yEdfA@mail.gmail.com>
Subject: Re: [PATCH v2 31/50] convert autofs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, 
	selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: xhnrdzu6dywxjnoqg3jic443rtafjrzh
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E5FD20005
X-HE-Tag: 1761629567-952905
X-HE-Meta: U2FsdGVkX1+8qCa/bdrOXKrCFKfXiJhZSZY7RX2XfaNIjkxxqlwcmfxGNC4jCST9PUQA2k4nPhlgrRarNTsYqMtA2fW7sQPlQLNnkSvpa+f3VMtIdJocO1tdLTRRrY/Yl6WWZtJHO6AUtIG4/3qlG2j5f+hxjrmsAiYiOQeOwMZXCpQNM2u96YgYUp00B7CfmLVxFSJIK+2PnBAlTz2DfVC51t0fdXkeJ68T6lHzq8Cdq/lflPfvLYsCGjyMmtXVqi8Br8kMYHenQw+jEA0etnnCAh/5hhnyXxgQR4xJnX56hglZxx1nyBsT98rqnP4DZekYUJ6ZmDsEAr4AiwBiOwNhKIVdrplfq+AUhDfJQyo0zFyT13jh5nebCanBbqU5MwPf1H0Wo7XVgHSne02Btaskcwf+Z4IyQsAsPl6bKk0NQMwdnveUosFdES4BIK0upHKUezu7Z+VcbW9SCdAPc5uL0TSNZ2L8CLOwc8SSWaQivYJUjB2swhOGeFMcIF4WzKj+BROTunP2VaTYAI7DAua6kcSe8ZMqIwDv4JzyU2ZlGTAqNpl3zPoh5YPcJl0oLPkjc7pvXsLIMmntj99kGW0U4F+L023XOdzLanyl8FpcaY8GlhlkjihIEnfhOURt0GO/xR/cORU8ClaW1QZ4fh6AlyXFsj+0JrziEib/1h6o/48parmtRamiwNn4f/vi7vVZAhyB5DdtClZ/+4w25AAUOS7S5iyES+t81EBSLsMJ9ZO284I0x/2QPKA7owu+iaN0X5gzQRc6vh1Q523FoqWIN9THNE628Vc5MuETSU6O2YhpW3zZ/NxcBpRCsuGOBYyMsEUkMInEfVTIR6HPknDGy8vOPWeftxl4DCTGwsnd3XH+V/QSHpNav9DKwsqOgYvSHwA/B7Pxz/uvMC/PH679YG5fKsPxqbxnYOempLdBa1qZFE4P4DdlDzwbhLSahr9Jk/YtISexLWAxHiZ
 ls0X2TM6
 jE9rrYu2AV/2osVtsHw8evzy91xfwUZ+RLBX2djwaOQ39xekIH81FTfXApAFk1ctfTrGhpflZ0X5Oz5UuvHlhhFprgtNhPNKYKV0+xyN+A4eGT45LgXBS9dOUwTUewYb9N072SBaonZTQioccU3XmiYgYI3CoEBEF3vkwelxaIzq/JGuDxkiWTulm9gztv6tNRSEjeUy/lVuxKLKQwuEmDF0Tzgt5m43DKW88iqgjZbKk7sNjNOX+YV9gg41gp097yY7YKDyE4aQUybHsDDlgtkqqNWYNZA8iOBtoTB8ZIll3WOruZykG2/WO6LVz/NRCTzKzn1H6juyoZWYImHiFJyLfWFtPbAlGjUMwIynQxM82AXN9NqXTKuF0pJR/vOvIos6oZnpCLXsM3jY3KDQbX9D6mvS37G9AMt5fCGQzBI/ZyHaK6N0/W9AzOnppxKWLq4c57ESxHBk+su4X687ad3nRmr68hbpetarn8KafzIipB+57rniF+rdS2GpSQZl4O0Y1+cHuUBsQaUO7TJ5SRir9/EB/IH/ksPS+KKZ7vTIAX1zjhMrWp5Vho7h1Iq8pPtpe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Oct 2025 at 18:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> BTW, is there any reason why autofs_dir_unlink() does not update
> ctime of the parent directory?

An autofs 'rmdir' is really just an expire, isn't it? It doesn't
really change anything in the parent, and a lookup will just reinstate
the directory.

So I'd go the other way, and say that the strange thing is that it
changes mtime...

That said, exactly *because* it changes mtime, I think the real answer
is that none of this matters, and it's probably just an oversight, and
it could easily go either way.

               Linus

