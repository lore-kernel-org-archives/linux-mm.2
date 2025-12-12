Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AA6BD43363
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 07:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6CF16B0005; Fri, 12 Dec 2025 02:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E076B0006; Fri, 12 Dec 2025 02:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933D26B0007; Fri, 12 Dec 2025 02:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82EC66B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 02:30:40 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F679B9807
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:30:40 +0000 (UTC)
X-FDA: 84209996640.17.518372C
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 49494C0004
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 07:30:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D5h6pXqu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765524638; a=rsa-sha256;
	cv=none;
	b=bot/mXJTdxo/BTmmvEPs8KD32XuVXS8DgCQBTxvQsa3D+eC8aQh8yKCYVJKumLqHhEK1+q
	RB5IgnB+IoN2gKxBVJGM1kJhvmbhJoH9P3LvqOVEQHPZTlJHbiMk4m9lSZa6q1dYOzUtR8
	yhSWomL38aGulAVViF+EXVqm2LrATeA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D5h6pXqu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765524638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbY/nvu9k0jdFLf6PceIz4U/m+vG+cifGKFXmRqaXwk=;
	b=62BjxvBwOw+Hv2GvKepowdrnA48/vTr69cCnX5o2EJvUuxWxuY+HpgJhGg8d6opi/0o/Hj
	cWR+G6ASpJ35sKEf7SqzxEVG4TRIU3UdxeDAZCol/CwfNYb4Mk/V48MaXko0l4B6Kq3qmC
	lg81hizei3SHqNf0XeOi/CXtiyPr5q8=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-64472c71fc0so828683d50.0
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 23:30:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765524637; x=1766129437; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gbY/nvu9k0jdFLf6PceIz4U/m+vG+cifGKFXmRqaXwk=;
        b=D5h6pXquqah6+n23X6i1YPjMCGywGSfDo8as96uEo8zbkBYUlX3POZpdb/WX9XQp2D
         mD4FEOaVoiUI/UBAArZAdjF3Nvw4Uhk+vX9+SH4s/wDUfXlZJnociCwEQlmnf/rfdSfO
         vND3XFlnczegFnLd1qpNYwSTHOj8RSl7o/IX9FCTGxvjnxMgQdYVvcbKMPyUvYfWw1bp
         95GSJTVFuj5vjpGz+XWAkpL1vV+vhBzWQWT6yZTinqQGEkx+KWG8clXhl5Q61W2yVFOd
         N9Z2U1F2TEtLPB9K3IExtAa3MJP8MQKegreLPeYtyFBBAkr014HQBGDsEvqOhWyuHioU
         7paA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765524637; x=1766129437;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbY/nvu9k0jdFLf6PceIz4U/m+vG+cifGKFXmRqaXwk=;
        b=d2V2QdGERkmGPB9FE5+o4zwsMwY9FXdbX9QoJh0mir0ATUpmTJF4S1BEVwBoo0OAQz
         XEodCn00kH6NLrU5AO/DnyEOXbQylCsKyjC34v4kc16l0Op/mv9vcpUSSnrFsGaSVLJK
         sBlsbO0/tS8KwDjKxklNguDsrRJlGF0PiVsiUgB4iUkrtVe2SSOCcz7Bf3JJeCBudPAF
         jMAsdGRzsJs5/Yww9WJVEB/PpoJaD5iR1H56jdRyCme0jnEL09muWUvLdZSGvyKnqyE+
         SHSTRFSfiHhZB3DBjJqA4l2MSu8oT+gAEEtKlUEBPWbEnERr1+pvl7L1WD9LTsn0fzU+
         znjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR1ow5pBrdTyhqHU+5rztcf8AiCuz3oBgCiZnhqvrPcm2mrXl/E+9Xf3P8/WOxN254CFXaXObO+w==@kvack.org
X-Gm-Message-State: AOJu0Yy/XvJwNgnQS1YvIUQ1tUbfE7ZaENk+J4Y+pNXQ6GLyrq5INT+9
	bDxf6wD0sSa3RHMAVXsggWca4csbOojkrwxQhViSxrfRAlF3lALDSXiWednGjp+4msyZOtEVBgf
	JWGPtgKFTHvtf7NA0HVkv27xfFTjE8lU=
X-Gm-Gg: AY/fxX5Z8J+5HLWCIszLiy6rz0rnqZB7kx8yGH+nrWV1aPDWTunfHbCwvUzjwCHPVvy
	NoYzz7vyfTu10CTJF/gwkE9zC1csI4+e1NRRZY3yetby9YnBHXnnQyxrAGjzbO8sS9Eop0DSX/t
	0/5ThpbaBmIOz21QIddV+JQ02mPYB7C9zNWUL9o4fTQdUDJfwsTcqfUeOOkXswix3NyOkFQZlFW
	rKgxRiGxUC39kujVJ17eeJ4L5wxkOY+tc+um7E6TTOGUEmBAmjWVexSqPQcWeNTSJl8ce5G
X-Google-Smtp-Source: AGHT+IEzDVXB1bjCbfAIBeJJ9LVwd+PZ1SexNTZG4im+40TkPh9ylFdtSqrLakFNNss0Y8TrUpzAomad+Rqj/W8ypP4=
X-Received: by 2002:a05:690e:14c6:b0:645:591a:cb60 with SMTP id
 956f58d0204a3-645591accffmr68426d50.81.1765524637312; Thu, 11 Dec 2025
 23:30:37 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6ixeLQeTJANkAvQhRviLyr7=xNBs-_jeKEo+qF6E3qAg@mail.gmail.com>
 <20251212034613.41033-1-sj@kernel.org>
In-Reply-To: <20251212034613.41033-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Fri, 12 Dec 2025 16:30:25 +0900
X-Gm-Features: AQt7F2qCMypcBYiHBd8_DY3c8sXx5SQAojnD2TiuRCXQxR3VNlNM3OEJCHwUvv8
Message-ID: <CAHOvCC4h_pv59Eb8euiv_=oQ600qJOjs8P8Onc39NrJnEaEV8w@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 49494C0004
X-Stat-Signature: esgsnaq19crspdcunwuz5bxo17g6qzpx
X-HE-Tag: 1765524638-982395
X-HE-Meta: U2FsdGVkX1/093STttCpAjrEqlanGgXSPre1G18LrEwHa4SFKr8xGIgXr5nFEsSlph1P9IBoKMmme9/ddgEdTtukl3M3vHrQKoTlxUsXd9Vp7YL+YoxOnI+vffyapsXAdX9uybHVvjGuSFZzsxAbX3tmlzyTndoEHuzoOsO0erDbt2mxApUUAk0qUiGK9jlbvGNBuzoEzecbKaCKjDu0N4eR+65WLG+V/8OB71AgY8+MkZBR5jowO+B6AydmlbdXwckbc1eJmlZWxoE42vLwCu/IxzHqjz5HDgpsYP455sodqC9r8R6uxdtVZc+WQFC2niId7GQ5+83DoXv9FoBNQAp/ZpPIBLHWoIJm5Hy6A/YUHntTSRPGvToWjpd7PpW61Krw6OGJ1dmy3SEI7gUDcrtYNEvXZ5s0Mldsw5cLzpzFK2rbiAA7mWgvczJ6xh/Um6k/BDtmIiAA4rULKfORNGugdQL81H/yyHjqTQF/mIQHkAX3lmei8xQShYtxXcdzZhNWWDMRDG7TlqMZmX0GFovY/E7lFv1H97xcwr4MWvnjC4WL5jkkaiOGDzSyYGqwmVf3ZD+1xw6zvHvKvhFRelfnRt30LvK1PLbW6P2GqKgmdRoidqSTbyQ7NDs05OMEHFFVapkJtHIQGx5SyiMmvsSANS3jA9NqxNYu6gfE4zdtgxO6g/jBZHh5ssC6qhyW6Rzshhb8iKu5Ib2evpT2WQRPBB55Ned7t2kwYtVEwNPVMvXhBbZD9Cf9GUKppPK0C6M/aBcg4NLNPPTN/4Mssu8ChDXFsdVIeVpbdjIyCWYD436sKRGrPfBqQS8xCfErcCz1nGTrCW/FhsUBra5jNgASI0HKCiz4rVNh0BlqhHkZ2La6+brvUjdLUZwTavzEIDm6JinVhjxBuAEO6/5wwp8lhv3YHPZWXt8PMzc8OWVQ/nhssSiUbu5K+30FcuX8FeVQo5/wtjUMDya1iaW
 ABbXDq83
 PQGi1ESt0DwlUhXePx9Q4dFVtmxImyKD0fUcIENmdETQZYTqFDFtWLFIeFet2GgZzxXj0M1dXCgoESNCce3LsyQillxt30U/WMzjbZrf0n2S/RzBof6Y97zfo/NRqByFUICrCSfzeh0Yp+ToZYDOvw1KbdWqXvIS9H+nznJrHOIRQGOM3MmLO20ZKhpih/cfjMvj24rXrlBSuWwax3Hn8iVHxMYCQ39RLX+PKKw0vzksaQ8ON7i6Uk8RtCCV3N1FOLqIpE8wFPlAScwRDZ/Al78XZ0Kym+hkdPTHpga9B84WfCGjndfYdKmNBwDyFJVx653ka2krrPkQHlT+8PkCV1VUCx2lKdi7d4ZGLXjpvxd9dK1rgbdobMs83/58fSDH6zQwDIb531GVP1W0t7uV/jY5qOwTnPnL06UI9QQsyCnSj7L3Y8FTT1Wt+7QQtSbnkR769
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000967, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Dec 2025 at 12:46, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 11 Dec 2025 17:13:09 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Thu, 11 Dec 2025 at 16:54, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Thu, 11 Dec 2025 16:38:46 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> > >
> > > > On Thu, 11 Dec 2025 at 15:04, SeongJae Park <sj@kernel.org> wrote:
> > > [...]
> > > > > Sounds good.  Would you mind sending a patch for that?
> > > >
> > > > Would you like me to send you the patch with only the comments corrected?
> > >
> > > I was just asking your preferrence, and seems you have no strong one.  I will
> > > do that on my own unless you mind.
> >
> > I have been argued the following so far:
> > "I proposed unifying them into kmalloc()/kfree() methods and
> > removing the dealloc_on_cancel."
>
> Based on your previous email [1], I understand you argue this patch is better
> to be merged as-is, though you agree it has the pros and the cons.  And
> therefore you are letting me to make the final decision.

There are pros and cons to both, so I agree with your opinion.

>
> I was implicitly saying I show the cons more than the pros, so don't want to
> merge this as is.  Sorry if it was too implicit.  Hope now my opinion is
> clearly reached out to you.
>
> I also suggested making the comment better, and you agreed it but I understand
> you are not interested in making that change.  I will do it.

I can also send you a patch for the comment.
But, I've been looking at the documents you've been working on lately.
It would be nice if the documentation could continue to be improved on your end,
so that there is no confusion.

>
> So, all is well and no more action from your side is required.
>
> > I apologize for not being able to respond promptly and smoothly
> > this week due to a busy my external lecture schedule.
>
> No worry, take your time.

Thanks,
JaeJoon

>
> [1] https://lore.kernel.org/CAHOvCC6bJLf=LuBpm90n5poz8Sqhz9wjXtk5ypbPwkvhb1ptag@mail.gmail.com
>
>
> Thanks,
> SJ
>
> [...]

