Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6F1CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9A2B8E007B; Wed, 29 Oct 2025 10:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D72438E0045; Wed, 29 Oct 2025 10:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C881D8E007B; Wed, 29 Oct 2025 10:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B78648E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:49:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79393BB241
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:49:49 +0000 (UTC)
X-FDA: 84051436098.26.910082B
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7F40F8000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:49:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=dPvgXxuj;
	spf=pass (imf02.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761749387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vsfcHn1joSx3FYcBHFCIU4wVQAcpbVHvkEyCsZn4M7g=;
	b=SdjueETxq58ohTUSZlnUTRYbKd4iKGWUWd0tAVfE2UvvYTpugdZ4WWCrbOHFFRxDEcy4oP
	EsvhgvP+UXMV7qzYWpqWglYtZMwlYcWboYlskRIAov7Zl+6tu57temAXcUOZjTsnrxGFit
	ICO0orwH2SQmLCDdRc+o/V5vXyWsLM0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761749387; a=rsa-sha256;
	cv=none;
	b=TS+47B92dqEhafEqgPxQff946zbcp+3hJjGBUTM4nkyElcFptSjOAS1iANQei/bazwzHs0
	mUhpvIOgPbx19t9RcsPTmKCE+2sAhumJGlIM7FHJy90DtmBHX7gmL84DEKv6p2Vf0ei79f
	hI8cn7y5M6GJao/oHTaCk4Co1xqZSRo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=dPvgXxuj;
	spf=pass (imf02.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33be037cf73so7725971a91.2
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761749386; x=1762354186; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vsfcHn1joSx3FYcBHFCIU4wVQAcpbVHvkEyCsZn4M7g=;
        b=dPvgXxujqJfm9MCdGceBFMevdWSm2UwU0CnY2y3rJOK2GaBigEgXSB+hNxbbWvENL+
         SmKOZqRgYqJ+YaME0wCUfDX5guRwFJ9bWaGcxIE7V6dPMjKtyCIXmo2TXdxPnGe9Pb6I
         hosLm/s5dSqM0nf8Bd+kQON7/c3CI4nSpj9NwFGf6JJ5+bYFQlSBuZNE2Z3cGIFyycRV
         bR1eZrhwvNI+ekLmxs/m9k047+HnpjfWdc5VFCHCJ2R97VXo3f9HKsOZYiSBrtcVN27Q
         v3RyEgjiQR5rd7g2XEI0LJOSKVM1aQAzQTpb9fk60nPSq3yO6V8UrwwARDW/ZrKD+J/A
         dC0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761749386; x=1762354186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vsfcHn1joSx3FYcBHFCIU4wVQAcpbVHvkEyCsZn4M7g=;
        b=UxsyR+nXkfz8ilHH75ulWyAjTxv9DhH5gIZ5y3Y0UbpCnk/YB5IoNkO0k8IiMRJJ66
         YQUc6W6In6CXPXi+50z34FDzZ/FukWtu/q8SiguS7Zg0oqZRzHEaPtGMVltfSDun5xXi
         Mk33P4SJR4JDB/ewIufmwWSFDXGrnWdD2Mlj6BHQ2/HRXKJf4zjXS2xK6Qe8LEqmiKFG
         G9XcVbZ+31wXaLCdMavJ69T7MF8de8iUi5WaNFIxffuI+c+kso7nGb2pG8dXWd1YC9j6
         O7W/QKhtOacMZlHQIgOhrQEzUIFe5zmAFHnxkPHVHsdpbWhU71vOjEIMuQ560Cgk/d+l
         5sSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzrD3PhHZX6nkZcZDOFMnqBhGVAx1QiIXF5vt3m5YYBQKO+30a9F4gmC9Nr1HgF2U7PueTJP77CQ==@kvack.org
X-Gm-Message-State: AOJu0YzA2XOxaxXfH7EqsZwRG0IAxTStjHSZFjtaszOXd/s2fozpkq4W
	H76akcrN4wtYye4YoO9Sk0FbnlJGvyxFljEn3Tvf8cOT6v+l0sPKeEWOaqYNbeQ5vHFetYnrcL/
	GOrhMduc+F/Gdaf2W6i6VqCOXVmDLa4o7uZFecFEf
X-Gm-Gg: ASbGnctObImF1LnMtZ7csfmkT+vIs/HdmNywEYfyvdDvLGyziZ3+qWV3uIc75rN33FW
	VKepdiRfugnirn+VtxNOOtkihEHLFA7PwVAgTPbWKxsFGzaPABhhvZnIJfubBeqswKFmioTIUF/
	oFwUtkKKRHCEJL/5VdMz+uRw2EbCAzFWWXQ8WgKDJaMY64XjanOm5MLjxAp39BFCHmRbIg5ssid
	xedtvtTq4ur8c4I0kaTQiicBZf6LnAG9Te0gGPCKnveOJk3I4TY6WbIayi+
X-Google-Smtp-Source: AGHT+IHiN2wVay8qKwNUCQNQedszNEqWD+gbH8QhJy+T+EtTl6Gz4GwA6YgaiehmmoZJBoAentF29nQI5J4sc3vsbuw=
X-Received: by 2002:a17:90a:d64d:b0:32e:5d87:8abc with SMTP id
 98e67ed59e1d1-3403a302f52mr3761415a91.36.1761749386246; Wed, 29 Oct 2025
 07:49:46 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-36-viro@zeniv.linux.org.uk> <CAHC9VhRQNmPZ3Sz496WPgQp-OkijiF7GgmHuR+=Kn3qBE6nj6Q@mail.gmail.com>
 <20251029032404.GQ2441659@ZenIV>
In-Reply-To: <20251029032404.GQ2441659@ZenIV>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 29 Oct 2025 10:49:34 -0400
X-Gm-Features: AWmQ_bkw5gzRbiAC20oxF8nOixccAI_lXABYmuYCSfnezye7FZYc2Gs15NqnG0I
Message-ID: <CAHC9VhRefx4MBDU78Qob7Pe2pDLK=1HK4b2EuTtENVssntHecQ@mail.gmail.com>
Subject: Re: [PATCH v2 35/50] convert selinuxfs
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: k4y161b7uxs8dnb6ftqnesmq7r7eeukd
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F40F8000C
X-HE-Tag: 1761749387-732186
X-HE-Meta: U2FsdGVkX1/V/JpV14CqBfVl0FLwvPgEMGMbX2Z1miE5kh3NYPwLwcjq7HkNLZopXqhLyMcWI2YnYY5j7ur8LqTTT4XR5AjJn+XQCPQ/pbj7jYnQF8N1SLOG62CHmyO6nxGgQxPDvcHDxlxn424NqSIqFpChh9iHq7QUj9yrbtSKQlDf8l3/bVFX1imLOQI0SXGnTka0yK7B//g+b1JfOLJiLF4QS0Dyn5syxhcvBGxBNmvbmYJGsp/b7wxBeR+XIHupSKGJyILEfu5O/XylIm1RwJkCasJ8PwWxkWAojaWGJcOHrqmG6bxQiqz3rJVq6/EHLXHqSBOBz8wZO25MX4C0ouhdGMZuMd/zurnotL+X5yPhCooJ6d13eKrigKvgcT0fYINMjD04jS4IP5KeXas5SsAAgy8CBeM/Kv5bCALJ8cFXjhYIWrQWQZNuueFU4RA7cN+abKdHoECmzKk79r6DTJU86kLy0kBOwjGaJ9jvqJwALsr/qaVUSJDdce22tHhyyow1CVV8NFF73MWUjOaYjaAobrqeGvNjrlMPRDNcuXJLijTqNUG8wslF73KtI7juyQ7CetaJq5/P2v+0LXk01VvVfEkoSUCChiryzWLNobg5n15I1XmmI/lNFDWzDK4bQXP6CWuCGUzMEhdTXpHzpfSDPh7crZ6rGawOFJMN9ra6oY8NYOccKJGdYpZZ6dluiTzmPCQVbWovBhMhDB9lFmrCX/hI3d9dL0fj68RqltaO8LCUA3I3D5x5wyHV0a8vM58wOISRB27NBOmLRo8gVA994XNOQFTAxL/GxQyUR9C7B1Pp4kEBlB1xWiQMwRJSJXsU2IsbkdHwlOKj8envaD3LAPt+LtRw0Arftqyln3MlLbB4G9/PFrmKABPKzV67H8CnrBjYKLioHtKm8Yi4++Mx454M+B0vbBNLYzLJtoVEhJEHx8p6zfmuGl1pwN/wawnNaASqxuKhtsb
 i6fsxS0E
 oqaHRcDB8hs0n+jbZvF83ns/j2AuQwjUE94LAatT8cSNDQr2GV0Qxgx+nM8iTGGMEWUAUZakyJviODRE8Hlb2U8z/xqDETMYx7D+uXSSYhuR+aeJEwybFG31QeyA34HX0MdH10tgf6g/uU/gj6FaRRJkYE2vqOmIz1GSjVjogK8d3ZU7RCQ+TpL9Ea9HXU6WVoYqMbZw7O6MFDostbeJ4D8Sbs4CSj7xo8gBq/F5ax6jCTGEO4JrWGc5PKR27lQBAVKvMc7r3yLqZUejgYwUdDdNtgOuo5/d+m/fZfp9Frqh/vNdt47Ohke/Pn2jG1lyBiTkNWSZFlVI9i6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 11:24=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> On Tue, Oct 28, 2025 at 08:02:39PM -0400, Paul Moore wrote:
>
> > I suppose the kill_litter_super()->kill_anon_super() should probably
> > be pulled out into another patch as it's not really related to the
> > d_make_persistent() change,
>
> It very much is related - anything persistent left at ->kill_sb() time
> will be taken out by generic_shutdown_super().  If all pinned objects
> in there are marked persistent, kill_litter_super() becomes equivalent
> to kill_anon_super() for that fs.

Gotcha, thanks.

--=20
paul-moore.com

