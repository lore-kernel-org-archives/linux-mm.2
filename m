Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C90CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 08:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 429FC8E0009; Sat,  8 Nov 2025 03:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 401978E0003; Sat,  8 Nov 2025 03:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E0B8E0009; Sat,  8 Nov 2025 03:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DF2B8E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:34:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75E3B5905E
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 08:34:26 +0000 (UTC)
X-FDA: 84086778132.18.643D57A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 844231C0002
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 08:34:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tGf86zAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762590864; a=rsa-sha256;
	cv=none;
	b=RCXTcBjYTIDfs1lLZoMPSKyTCin9sexcjA5HiW1rQqIzyKUTCPtwwBRULkgsDPM0vJChn/
	+Hl/Ggf5IFQm+5/UyrimMdg2Y5uvCRUOjruf87QrokSNdO0lo1yUfaNzxTJTQ485CV5Dv8
	+e5fGkLEnWa9Ya11WwziTH0+SuObAU8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tGf86zAJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of chenhuacai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762590864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YY4ynXlywRAxLSCE0o9XbTuT7/c0CWG6jGHKSnp6GmM=;
	b=Wt47PIxaw0RIdPqEIzfdBjak/RPWTTEyWw4ASeANlybiUa8XaiC25UP7whY/OOVi1Ndh1B
	IIhE7GfCjxSam/YaptEafFmhUEG2ghyKiBBjJrvWHR1F8mmhgOSYVdqyc9PIYPnWZLGArR
	wYeSZM12rgOvvmQSuqwK06jOE/gyc50=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 398D34432B
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 08:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154DAC19423
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 08:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762590863;
	bh=tlZEONXv4tiRT3AMc0su51y1oD5Ls6tTrIpaqE0ngs0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tGf86zAJ94DACKdaNqRgK8YNQB+EsYJB5rMwJWLYHhHSch6AzOd2IGU6E0Sc0K8oj
	 ok1/8TVSSAio+awRWFtGI7CRLOrSiIvlKjCAPJecee+p3SACLV89TYr6W2syiRBjc6
	 nYx8RSNYK5pYUDRNdX10ZILswkx/MuMDVrUChmxwCCQrEMryaa41oYtzS6hnXglBZ/
	 kGE0vMaTop1wWoElr/GDKMOd8r0Pdwe4koNP111CuyN1VaH0vP+VqM1yESVMLgxVSi
	 aUhElU7GMlnwUNstJaauNka7d2Csdclt2aPojzjzVShrxvzRwJ+cTiwmQqRO+H6kej
	 8iunQfiZTtluw==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6406f3dcc66so2568927a12.3
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 00:34:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVLXB2Q0Jy/oPieRLo9CSJMa0yACUAOGbN5TIIDdU6GD1ajPZdCGi7MDByk3NT7gz1YUGWJ16o+Ow==@kvack.org
X-Gm-Message-State: AOJu0Yz5bwsD4q0d2RFGaZwuJ0F2T2HceSfqFKGq3pJaRKHkBzJ3eKQD
	Lb4dW115UGe0dPLxoblKyhigBRVGG0Lw6t2Bg47000Gjni1yvTePQVSZ2pWM+XMoyxCUp7XT9YL
	m/wTKO3a/UcQbUvBSuBAwlTFLLp0DUfc=
X-Google-Smtp-Source: AGHT+IGlb245/wlR/RrXg6CuqlcByT1uGzI60JlcScJKo+CxETFOnGjHVUbz2TrCf3DggZ37u6QhKQeLBIoK3JY1V2c=
X-Received: by 2002:a17:907:3d92:b0:b70:b3e8:a353 with SMTP id
 a640c23a62f3a-b72e05e5a26mr184062066b.50.1762590861638; Sat, 08 Nov 2025
 00:34:21 -0800 (PST)
MIME-Version: 1.0
References: <20251107095922.3106390-1-chenhuacai@loongson.cn> <aQ4lU02gPNCO9eXB@fedora>
In-Reply-To: <aQ4lU02gPNCO9eXB@fedora>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 8 Nov 2025 16:34:20 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5C_Af72a5QcJs25qUMsJqO26=8oNvvLrJ7z+xHZh8oKQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkuuT3NN8uTRvAGhFr6le3bzLzpE1q1tOb9RXNULYvf4D4AG-sFaEbbJVM
Message-ID: <CAAhV-H5C_Af72a5QcJs25qUMsJqO26=8oNvvLrJ7z+xHZh8oKQ@mail.gmail.com>
Subject: Re: [PATCH Resend] mm: Refine __{pgd,p4d,pud,pmd,pte}_alloc_one_*()
 about HIGHMEM
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>, 
	Arnd Bergmann <arnd@arndb.de>, Kevin Brodsky <kevin.brodsky@arm.com>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 844231C0002
X-Stat-Signature: mwkws5o8eteuwjpjaezmibaaijaxx3wq
X-HE-Tag: 1762590864-355891
X-HE-Meta: U2FsdGVkX1+lNHMSbPSxnFDr7kfaPuj6YXb0O8CUGEKQ3j9IvSus95YQmsXYid2jC9qgYNiEKGWoIOs/+S7IZP9ulbdQGpI6y9bgKpeMsShaF2s9qR+Dutezs9N8UV5KUR76U+ljm7FhYZd94l0XVFKliKds5HjF0CKkc2w2KgJpVVKy07JNdscnDIUluDRKc70mv+WFXmjHCxvMvSVSReijpflXZzJ21+7VOzH84bsbZR4ZSWLip3cjgx5sRgv5lS+bJTJ08rCGMwqcvULY+2QAFTlMxlUqjKv1CexY/Pt9zwvKphb5q2//5Vvk5SHcz8gDPu2VXxEzYC900VjVDHvHCmOJXooYyA6Eo7w0/m9KdbqRv8Og2zBcBUEhznYl+qHSs5aCcD1NnguIj4sjbM1HjU8Ut2KDPPSJXNk2SpeIk4nxo2F+UXADBrCzlAC9ETZ/bJWNLSrh08+Q25jY3J/2pr4wEeP/ECgEDqFmmfcC1RGGvOLcRR2mQkk4ny8e1ciEOEXJ3ubrWIxeLmtaa/1T1mz96NJEwg9FFxOAaQ7xPFlSsMgxkxi6L7iF9hEycr4uKprBYfQwVy4XKxuyj9C6lZ5/h1YD8pefrFUS6zayNJyrWdFq3Z7KzxJB/A17y1Gc0/6ATboCTpYsDEmhmAVsLV83dcUwIqfdTX64joiTEHAIp1gizckJVb34kYOw8xSLMlBVta32bis7oxMGFvfDyQ5sddGRZ0w0/MPLwifI9zB8ZBwRtWEDdTAtxhaHgdrRQiQVladXAAb5vHm1g+x6Zeqj+72JGVdgJ5ic/XoUlIJ7grLT4aWS4ta7ZnmXw5vsFqz/I+GHXEr/p/vZlEw3SqhGvKGoPqb2DJAT1B4A5kdOjPglHoFHkib4Je7TelQPYUmGySQKK4spU3jjclgSl0NFid5PuRYahxAi++1ewhpULXZjiEnm8yQ1iz6eJ6WXdSXv8Ood7qke0YH
 vQlcFZXq
 b/Dfb+qdtZ/KP+42rdqPvymXqrA4OTVe2Paoe5Ftc1h3DuFhcLUv2giPq44P6DBf8ZjBo00um+00IxUklmYUeB6cPpRe/4Icuzu2CNRRzv+0U7lyf+op3s2tBZzrs6ZvYj6QDzL1VCWsl45L7jZcY7zB/ecerdxAnm/02D0qjPckhNU8hY6yLXCtkwyh5lqW6YJF0RqvatWGTMsSzPUxMgpXMXUao8Sha36Al+zUE3XY56Rf0bf4gy0hts0URcuipG8f2v35bBweqRqkd/3WomurutIEQxrj3+I7FsIs3hKar1l8a366TRGmlCEBEABQ8Ft6/sbOi80pV0uYLHznguDu6y5ZUCfkylwmjSwuTCppQXnliMnnFpBXRUVxZFo0t5+dSKLI5ONiZ1GNEFtyVYzqAKEJoH0cXYU5ZbYHVfjxZ4ZQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Vishal,

On Sat, Nov 8, 2025 at 12:59=E2=80=AFAM Vishal Moola (Oracle)
<vishal.moola@gmail.com> wrote:
>
> On Fri, Nov 07, 2025 at 05:59:22PM +0800, Huacai Chen wrote:
> > __{pgd,p4d,pud,pmd,pte}_alloc_one_*() always allocate pages with GFP
> > flag GFP_PGTABLE_KERNEL/GFP_PGTABLE_USER. These two macros are defined
> > as follows:
> >
> >  #define GFP_PGTABLE_KERNEL   (GFP_KERNEL | __GFP_ZERO)
> >  #define GFP_PGTABLE_USER     (GFP_PGTABLE_KERNEL | __GFP_ACCOUNT)
> >
> > There is no __GFP_HIGHMEM in them, so we needn't to clear __GFP_HIGHMEM
> > explicitly.
> >
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
>
> I'm not really sure what "Refine ... about HIGHMEM" is supposed to mean.
> Might it be clearer to title this something like "Remove unnecessary
> highmem in ..."?
Yes, that is better, but Andrew has picked this patch, should I resend
a new version?

Huacai

