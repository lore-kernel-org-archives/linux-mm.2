Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F05CCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 00:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6C7C8E001B; Tue, 28 Oct 2025 20:04:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1CC88E0015; Tue, 28 Oct 2025 20:04:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B4A8E001B; Tue, 28 Oct 2025 20:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA898E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:04:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5937088BD8
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:04:59 +0000 (UTC)
X-FDA: 84049206318.18.98DC2FD
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7967E40002
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 00:04:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="O/d0+xDG";
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761696297; a=rsa-sha256;
	cv=none;
	b=pEzmGw5yTfD3F06e4v7hyLWuW6TiqevulCNcLpzyuSMHz6rv2cUK2R699cl8WZnXb22Ve9
	DUPk/ipUcTQ2aJge6cKwSG0o6a1hH2CiBUSC/GLuGx/hs5mRAgkXDDvMWrhT63qPZE1xcI
	v0ZjRAo6mvX+94E/5noBuIZ4qrGIzdY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="O/d0+xDG";
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761696297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BerLOcBoWrV1cLwn2WvSsreg5PxA+PLtgWK6veAyVuE=;
	b=BVYieuNB+NVmLRa6wwQ3FdKTscdT2EbpN8ujIsf6Q8ydqUmormsm7o9L35uesyhCXIdvQU
	SEpZih5Vqlgot6U0W1jTXt9P23xJtXSfCLg6axs9oePKwNYUTiKrKqcBinA6vzCxaWZ1c0
	LF8c5sO0pdlU9kipMZhu3JJwxYiBDO4=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-34029a194bcso1688967a91.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761696296; x=1762301096; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BerLOcBoWrV1cLwn2WvSsreg5PxA+PLtgWK6veAyVuE=;
        b=O/d0+xDG6TU9m82DtsjWb+zgqAmrdzjqrljDs3G2+XAXo5zdLDbRtSfolnJlqtqN+r
         nzH2DLSePbnDtpcn3x/1TUOJVERKpNrZZCq83lfLJqSJOQ18Llcu3Ri3ShMioH93mpxh
         hm9EWiKyzgiETouMqC46Hz/LTyiJWXfiC7ktol60aB+psd20jJktt3QU/Dn87wmH+SIx
         BFEQp9/0Gm9MXx/D4XXpfKhuvrXXp+UieCBRNzlvC/M72emGazDX9mqEP0zOceFh9/dJ
         x2Kwp7VxMqt+yqr6d3x4bvufedte0D0A0KKMYUd2MQdBibiIH31hbrL7KqojA2iWjR5M
         /Kzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761696296; x=1762301096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BerLOcBoWrV1cLwn2WvSsreg5PxA+PLtgWK6veAyVuE=;
        b=ZHN/noKxJbt2Pb2XIIuYaNFjlc8KFAQoc+0rdsIdCzCieH7+KpLN/56KLdYhEh93t9
         o2jV2nqGLSO/myCGZU8GKioiVbU7KkpHtm6dJ9r4VXQX0DSdS3C6Lm8ppQa2NIZOyfQX
         +GkFboRIKsy5S2N5FjXpH8l1JjojEM9brtCN3hmlfmfBvrHIfuH6+mss0UBHxVgPnGL+
         PDp07Q7sl2UcGJ211D8mZN5XuvbU+XQCqoeyiuWsUHnY17zmIUsB229Mx1EGiEn58fiF
         UkPRLSnK4XkswVAXCqIw+9FPlEorVE4LLq/puh6FLHN388trvefErfz1bCiAOH4XXsF3
         PJyg==
X-Forwarded-Encrypted: i=1; AJvYcCUOea+6ALqOk5rUT9T+Ae/tpKbhCtoGq0iAhIWehVgk6wVLPjNwyhzWx0kodk7wHLumpXI+8tkBfQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+Y7VMxD1Hkmep7dPoLRRE+UYmGANG/CpfUJlNvURCCzfrVP45
	x/8tnPljlemHrvdsAcRPGmM7KO0zU1Ctpx1Izw0KSE/wK+fZor+dovbcTycXEw7vYGP7B/4PYBr
	w6OcVz+VtmNgKauLJkpyD+mzRJ5SSDA0fI82Cr+vl
X-Gm-Gg: ASbGncvyYPss9aVSdrcvDKwU8VJ36kh6Ar1tDuynNuL8FL/4rTLrSKVGh6wkfckLs2r
	UkUQpU667pUMcJHyKGP9J85MXNSlUtGaRuXtqLzg7+F8SAIucvKaIpSXEZUaX32QXaMc7zsuZwg
	Od0fB8pm0zjKhTdKjOLB9Wi2dhG69+xtwZjRSTBf61DPjIGo2/2D38FZWPwwIH/PR+gLzFahT15
	mki4PONndc4yTZKXkYZc3Oh/mk/x8KLOS0Yxh+CNKpPHQ+TZQbujz837xyGFRIxYT63304=
X-Google-Smtp-Source: AGHT+IF9Sg8XTJhY1XF+gNJzXx33YCPJNPvD397jHY3K37ysFCuyvsRKOtkLfk2UKLtdow89RUSTsoGqlzXNXJIH+YE=
X-Received: by 2002:a17:90b:3147:b0:33e:1ae2:a4a7 with SMTP id
 98e67ed59e1d1-3403a2604b4mr1039988a91.12.1761696296385; Tue, 28 Oct 2025
 17:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-50-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-50-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 20:04:44 -0400
X-Gm-Features: AWmQ_blrbvCvNMESns84vcg9Bs91_mExO5kolf7cbCdCoz5ngCaqmvIG7Oeo_oM
Message-ID: <CAHC9VhQH--uP=fWo0MsH5=BojV2qG=qy7A9tHTVOnLYOxKbV5Q@mail.gmail.com>
Subject: Re: [PATCH v2 49/50] kill securityfs_recursive_remove()
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
X-Rspam-User: 
X-Stat-Signature: 7pygf3sq4phud3niwzd7np5ssjstzai4
X-Rspamd-Queue-Id: 7967E40002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761696297-749247
X-HE-Meta: U2FsdGVkX1+BHI/brWuk7lGni/rYjPtZntjFlDxr3PqNIQvdrRqWPsnXx+kohReK45A3xYcYdQaiHVbszmzV1AXXk0YZDFD84Dn/1R/pHNSvMtWNu+eyXWGboZjil8+vbP7vObtUVlVuCeQY3f40FxqLxiz89wrcVGTUqsrhzNfdx9J30KG7Llk+kDiyJ/5UIbUcg5L42srhfL/3mXEDGaPlbgYfhpqWcQFkFM00GZ6s9TlEpkIwwRm1lxmJBrPl1bI+7MxmmHcOZcfyJph+7gjdc4YgPqrI/ChAKLpTzCC+xxwf+h5oGvq0H8/YbUleG+nXULKTnseGGwGyQK9qaxr72PiOfbvHn4VK+H8odY3GzyqejoUOcqk+O1o7TQmJ+FqgFHKBqzS41tedGABiLl1qftTwN1jIA7vc+5N3SjZTWVL+Er9t4eheYOfxZpaDZ7uup70Qwu8XTgIDhorDxzkNZuWT/TfpFdP+M7dtBULJDo+jb0iwEx3RhDpKeCO4HNr+kXqZCkeuFmenJIIYoiZ4RAo5RWvvLZM5dzFmDrdhWavtRuv6FmgynlqWvCVreVhjc/9ilhYJQnGCKHbXXjxrsICDblWr3O99ipbmdEfOXVbCAbnQ9KdVNaeS8G3L2On/G2N6Eh+m3bYPAIF08K59Q7cqueaqcDkGW4bdjYYmRLlS1anDuqLG/DxNN1qM8kkN/ODFM5Z8bzHjS6EFJpdactREqXjbDgEaVW/NFTCf/xwU74PPRUX3Cohq0+YaLmPp8o+1hwN1pgRGSKOT8KSdQBiLZ6dphV0klbnmkwgGHpBsEV7F+/Q7SjRH4vo4vb4TnaHx9QRY96wAJ4APXcoz5jEgYFz7CB/pTeBdqISCVLgxV36HSJ60xet6TmGOlW0wc/0MCPf176UdxSPetrBbzlSF3XS5FV5V8lC1Z/x9DJFn57UARkMVrCThZMNuOIY40MxGoPWI+MDGr8I
 kPiihGaM
 1uG1qNEZ7h1LyzoAqxx7okrOYM2xEqUkOMOJcKOPjnD9+iAwIh0pj5O4UeBvxkfwJ1g6J45QCdTmqEuBh9PjkMDxElPcpBUwAvoMY5RGqEW2G1g6kVHmokawURuFGP8byJWQwx1PfC3YjPCvPWEPzyBa+nHt61SelfMmrS/0MUzz38Yjv88Rj11TP8p2KlBnt4EhoZyWzEkYepA3xt/EXanqzywrcDbm8x6z5gZDuwNKe/0FHShYfO/urdZq1uPcpKI1e/52AvBF/ABFkIeM0Cqyum4K89fbDbdYRKXLxEwT2jhmMjrtiQUn5JIq+pyOtnOuzKA3owlJDTAeVHR9GKLbV+0rc7a6P/NUNa7z9G9J/vDT3zQ0BJAH+L4LqWVFYoylzFTxpKa5L3k8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000010, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> it's an unused alias for securityfs_remove()
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  include/linux/security.h | 2 --
>  1 file changed, 2 deletions(-)

That's annoying.  Another case of
let-me-know-if-this-patchset-dies-so-I-can-take-this-patch-regardless.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com

