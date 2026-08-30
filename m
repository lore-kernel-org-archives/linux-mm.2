Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ADF7C61DE1
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 16:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636006B0088; Sun, 30 Aug 2026 12:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DA16B0092; Sun, 30 Aug 2026 12:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC606B0095; Sun, 30 Aug 2026 12:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CDE36B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 12:58:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 811B4C0297
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:58:08 +0000 (UTC)
X-FDA: 85158543456.15.4453F8D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8646E140007
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 16:58:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M6aidOie;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788109086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eY6S1CuOxppKERshHyMUDaMx3fFTWDyqBYaQ5/cHRXU=;
	b=gDSE0TWTk34K9g16CaTirU3m/MGk/xuZMoiaXglxT67TwWFpzXt1EHmVdSNkiBNn+qlGvH
	5d/hBlSiV0HNgU8YoRoaNovT/a/cMUCBnXCscvNZw6Pktc02FOd0U44SBaorPNWo9S8Yl9
	9ohQO7GFdp0M/rdWLbgI5GMHhUwAABI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M6aidOie;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788109086;
	b=MHR4lHciJTU6+LXp25PjdUn4rrkIQdCPraUG0CoJkohrKkUMW9UelTGuG3EZlC0sMOeQD4
	3u30mbko8mCvuG4fjVbGv9KlYBb0IkhQQchgfg5ge2ZLrsPmR77O0bvlVY9B1wVFx1MB7p
	DV6gfN9S6RHEOF8KpELOyxCZERqoFHA=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c10e86e52so209691cf.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:58:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788109086; cv=none;
        d=google.com; s=arc-20260327;
        b=jPhH9qG6ZdhO5LUtCCeK/ukBo71wrLhXJe9qDz/RfH1/0z3uQbR90Sk1oe8fRajJwH
         8YWBo4kNDumqcP7Fhh1e9R3L6L4KNzj7hU0ss2OhzhBieZkTIlSa7nMEDlg+/9O+86an
         PLYHzTLDItAFohjCFtAmwZmR9OvGoENlueDLcqe+5TdTdj4Azb3zpErGL3l5P23B1P88
         sDH4nqGwIkAP70vUGJqOc08OjeqEW1aT6ycRAf2FrVQVNIfLCHrvK4hm3XiYkOAhb0ap
         gyRDmRDz9MzYUMcYSKpgNKdLWV6ypwfofx4GAeFmw+KYWhrUtqGiWM04BFZv/eNBMGRp
         MrPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eY6S1CuOxppKERshHyMUDaMx3fFTWDyqBYaQ5/cHRXU=;
        fh=2HsGHdFmC/iL52DnLCuSbRG3wjVCHNQL3tXUaLMmSKE=;
        b=TraKXwR0uJAO2eq2tSf954Z34CDWKufyhGcdvrkRBwOm0tshZ72t/nFmVmxN9b1ZK3
         sYlOd0SpqlcXk1gfup6wJ86PClYT4GGdOd/+f0NDO6h02GZUGqaDGXOpS1kqoC9RTcDQ
         16O32yZ4mYvWvR7ADvPN7z3PWncQrWxDb5PCGmSvZXZrCM+Bzp6i7aJ0jdYjNf8g/Wyy
         DFyg2vjP18iMJ783LlDFJDcVzCdquGxVhEySxZPxz2sHlp46dWWC5Njl+sNM8wr7+SEL
         GFPmvVi25807TzDXnQoSKrsSPo1JzHv51eovIyU+0stSBNMfzoFXcNll5NG56HIz8BeM
         aP6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788109086; x=1788713886; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eY6S1CuOxppKERshHyMUDaMx3fFTWDyqBYaQ5/cHRXU=;
        b=M6aidOie78WpThMwz5I2RG5U+8qoS37boeXNOYbtblZTGo52VIbDhMlz6iU5Phf6Ju
         pEcnVlUwgMaUiYERwFUymeSpDgHR5RbZq7wOAvpE6uNY1jp/NHRlV9EH81rc3V76CXqH
         ciX7xyH2xiU989DrURwxmv3btBP+1771qDvejddMK9xubj+2yjUqJl8ckxl+AT2sdRFZ
         LVh0auCFNFVQU6vRdUwQPqBhdp+IwFaBCyw1sQbfmJAiUxDcihOqzBwjwYiRou9Ufbcf
         nhjs8DdwRn8d1YrxWOjvIVQxuylh8DGyKc9q7A4bVzYhXfDDu/eH4+4SwRxp3lCqt8X+
         DUZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788109086; x=1788713886;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eY6S1CuOxppKERshHyMUDaMx3fFTWDyqBYaQ5/cHRXU=;
        b=FVhvNRbUX/n9kDTsoy+X0QXp6k+KkoDmsMOInYgA6kPeQwrfMrPEdTR4J9ZjNV+Zp5
         N3TDRb4jIt339zzXOqvxI9UZl6vg+xhHMFHtM2VRIbsM5gVO5rbI9ItYSpmmtK9BdS+8
         g5cHV0CX+T7+x/afPegziXMkM/WeKIrTF3+ZUjmd11snRjopfh8Jqqf/keG66g5aCIgu
         AQd3FbFevx+wYdgzR1JtZURDTG2TT8qiIY4paf88+S2B8cpyuDURG09AeP4u/FE4fbhh
         G4OqEPeF4qHeBEeJkHkh2+198Qzv0ve7tg7N8tBEKKzWgGIE29/35JMgOLE2MfHxNCF/
         cDiQ==
X-Forwarded-Encrypted: i=1; AHgh+RpVz7iBqvFIe27X0EzpzAr7tOOorAW7os89Hg/tZhHFSVDxjrpCpPGPZCQUt2Sg3HbIilBP9F+LYg==@kvack.org
X-Gm-Message-State: AFuF++nauIRZKocaCwiNU8WG/Vur39UAkaOEPdCyQyyi0Q5SPcr3xKGR
	FrAUW0u6t01Lxm+iNUs1+Pp0OsvVmW2YYc1sohC637TyRZydurPlRdvj8EQOtv+5DmLGgbLrUy+
	W8S0L6woKXSWJt9XrUiSnnyusJnf3kqWRTYwd78cX
X-Gm-Gg: AR+sD13JH85T3J7BHGpVRlMisz3pwGYQjDfmrHnB9lM1aNEqUmGgqxLLpk/DaXPhIVq
	hQELSkSMvHtRJDnKZOzqyxWUYvLp/Qr4/ND/PMNTTvtmJlSgT7olvN3eMnk9mH6hibr6gJORgPm
	XvaYjxKjD7rnRZdCk3lR4jXjBrJgIKfS+wEzA1aJbNeN7J9KW6vJiRvT9eeOuqccHb0vi82MI1R
	LNb3leKz4kDwWrVVODFzqKlz0t33eX8ZDjh+5uIrzWJd4mnLk5Xf2OrqtYJLHWG08zl1y3SP7Fo
	R6Sw7JN8lNP9eOPlPDa5JXTE+K70ZPTYyj1hpa6yIpM=
X-Received: by 2002:ac8:5a4d:0:b0:52f:6e06:89ac with SMTP id
 d75a77b69052e-52ff7392cdbmr18296591cf.13.1788109084962; Sun, 30 Aug 2026
 09:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com> <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
In-Reply-To: <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 30 Aug 2026 09:57:53 -0700
X-Gm-Features: AcwNN1Uwp2PnQgLvcaKuLpOXbpaoKSzdckjfmxjUMDcpe7gynTwxBKZlGUetcPI
Message-ID: <CAJuCfpFtq4Y-dDXNHJWDEXayhyCqqjTdJUCM3QTdbeBB1rXUNA@mail.gmail.com>
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: khjujdyzqjwurxciamafkn857fmiqf11
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8646E140007
X-Rspam-User: 
X-HE-Tag: 1788109086-220601
X-HE-Meta: U2FsdGVkX1+d17Ph4/H4J+7icOAYH2NyexQXE79LoAcvZHJGSzTZ8ynASBo0TDsXiYKIszFUh9EI5m5kx6BAQ/ISMnRTo7HcYAwRKK+dvjej7cZtr33Xd0XWkR6VuZfo5K3myU6cfGS/aE76cIuU0w1J4shN3S4Mg8z5SK/5mxN6HRAI8+aPYMOATsaWtqEtXAAiq9l70ZqYf7P7/S5wXG7OoDDKMLVvq2CotcBfJgthdCLk4kD/GR1WnhjBVGd2pSYkq4du8Q/mLO0cxrcDLEJLC31n9ctzNHrHfeB/Nm2knK+1XDH60Bz3UTLuafmkW0PuMnfQDQ5Dkp5rja0Gullhw4Fh0Q3jmQUARtH4OEMc5qufD1AvyNk/2tLwGz4AMbOyIjCyFbefcmqW8uLddd4o68pkxJxMk7gSk70El27KYdlamzlbXc05PvXvjNm1E8uoOssIyrX59jzxp9W1inMtybn9D1az9xuqtiocWlxvR83RX0jOpqWf4wUvjPDPye/dYDHFlo/UPe3yyBHLdrIMu6PK8w6rIauEVWjG1cfjCMoQkGZVPmSbj7gYRBm2SajMOFj9qoNydo6liBqKILb051qHh6KcNvTVl6mbt8G0QfLD11oUZZNsHSqB/VUkpPDJ7POITfsr/6+W6fwy6Ktx1scxRgKMi/pBYCeaOE/pymeXEyugvfwuFj4X/wOSuHhmrlPpQxTRwkL1NW/PEHkmSysvG61E+OG17WdiV4E8/9RsH+9j7E2Htx67FY6EuuJOVO9zKJy+tdnTZmAa7aXEi0hViRulnGvDpjRGsdY8ChGjWgQUHt+eGP1Nghn6wdJ2oyw4kz9rpw/KhXDEteo3s6NNvli37K7IfbKRao8zMIsry41cRskXLnWMZh97HPmtKc9yYTdDNGpGbiXSYrEaDFpyuTJSsUrZC1LiYiRhlz+Q6b5rlzO19ZHmmxHthmbHLrm5hKtirV1J2kQ
 DDiSFzR3
 YZVv7KYSRMB24DqCp5iUz8EC5DpEdAIM3qyeEkRrI2Mw/bVIlJ30MpxxCBXfuftt2GMdUWDJg247WMxg4WpAeNJ+ngSzAZeVU21RK6Zd1NboAMgIEhcWTujlIJ89UXUZ6RNpizdOwwWAlCKatLOvgAVcEJS57a5Hg0JhnIopjeOiHh0g4YM1fWs+kZ8/59ZiBLCa0J4JjeXhZigEnTzWnAdKm8FUgm4n7Cznm+9SCB0FPZZxiU4P7i+2Zrc0l4XFrc9wcy+9ikNuHqbkefKfozX99/boaJ6U+DzzaC7ShzFtO25aXqNRrb76n2PDU0YvpxW9iG7e/21nFRFcwY40rS26aKjt8HCFXkOUWc73QXhYABTlbPO7LTr65pTsoyfmH9iqTQafINWZT3un6EPk4nfstQckvyO/vWOuE1dm2Q4L7kUQpbyrD1/LNT6ZIzwtjDOdpKkNtidXNCM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 6:56=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > v2 version of this patchset [1] was written by Dave Hansen and per his
> > request, I'm taking over this series.
> >
> > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > of the per-VMA lock users now that they can rely on them being
> > always available.
>
> It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
>
> But it applies well enough and is adequately reviewed so I put it in
> there for testing, thanks.
>
> AI review might have found a couple of pre-existing binder bugs:
>
>         https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@go=
ogle.com
>
> and a small rusty thing which you might wish to attend to.

Ack.

>
> > Binder and networking folks: Your code is the target of the cleanups.
> > I'm cc'ing you now on v2 because there's emerging consensus on the mm
> > side that the approach here is sane. I'm not quite sure how this pile
> > would get merged, but ack/review tags would be appreciated if this
> > looks good to you.
>
> As said, a resend might help with this.

Will send an update on Monday.

>
> More binder/net acks would be helpful, please.

