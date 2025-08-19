Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BDA7CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F7C8E0057; Tue, 19 Aug 2025 14:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0588E000F; Tue, 19 Aug 2025 14:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0068E0057; Tue, 19 Aug 2025 14:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94F628E000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:03:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4468C56C56
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:03:45 +0000 (UTC)
X-FDA: 83794280010.30.E13A47E
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3CC0440007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:03:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MPDU9NFv;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755626623; a=rsa-sha256;
	cv=none;
	b=WLMKIYj0JvODqJP2GbN5Bbi7pHVHlPmZLC4P51t7AuRr3QQJ/vBIa3FQEwJVBTVynERJne
	MXLTnvoiKl4a3zT3FEGIzSJzr7gKMOTVhj5MNMgo77cl6AjzFHnRiWYrLy3jwJepnJbxw/
	m9fRV74oIh5atbxmxzMeoAjMtZT0NFw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MPDU9NFv;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755626623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GhwQzM4cXgt++GF3ZN5iSCu2rPgPoTUttLSOF1VLntM=;
	b=H8kWt6/IQMaUAVSA8IW6I8v+n3PtvbtL23l5gocx+g5uIyQFl+bhogalI2oJJYpDRiBF5O
	NFrom/D3aNSSWzCEIwXimNmYUOmq1uEl7PAGSj+Swgw966fb+2Gci89MtjvaaLMkCQ3zfM
	vylgCllm9LUDqXSmNis6ykGkKu6BI6Y=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55ce526627dso5705962e87.3
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755626621; x=1756231421; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhwQzM4cXgt++GF3ZN5iSCu2rPgPoTUttLSOF1VLntM=;
        b=MPDU9NFve5N2UTszrxRF6UkYKWRqQQhbiVBD0SnbP4I4G5FEZRm3VNngih6OISmQdR
         ySB6G6pV/LDAmjp0aLdvfZ4pvcU0Mf4hxfBAVPZS2vDSA7GTYgkvpzKAU3wduBBAt7cG
         0pyA24jFGzOcTGSye8EfYMNmcverg5kr+orIGwRNrpqZPCrPlvKay7lo9V2dqDyYYstV
         LR30Eb/btQkcxvSRqwuPOamQ78SSKG7kJ6uwKDHDp6vMIIF4NXtzroQabZ6H2Babvlm3
         wFvNo5esSkRqrPBfs7wm6MKWNBIZ3/88pHtKxORp8hdrK5Eb8twn4ZbBnOTyOVUSEzcm
         Yw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755626621; x=1756231421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhwQzM4cXgt++GF3ZN5iSCu2rPgPoTUttLSOF1VLntM=;
        b=rmFL3c2t0aHWqS0gO2Mr1j66I9V/OnJ2rcBe43MSxPe6LHmQ/lI46ffJyMzv2E/tzK
         8Iq8FPOYBWRLLywMKjBy6LuM4TiLXUkgKxCgraWqCRBOgXgjGq/z5cu/bc/+QoUQAUKv
         ItJs+M0AH/0bxBnz7lCdcguVJ3SszMuoZbIRdsNZ8Dta258EWLbKy6iDiDCYOCNs2wqq
         sDZ/Q2Y7CJXbkmYTPgy6s31Eipiu5eTVetf2zSB+KXnsThgzmeVz4W19eFtS+CGl1ZtW
         9XmT+bXfRiP+QrYWRuG4jbnEg+WbjKE/9JHR3l5NUth7R/e8J6kwWg5VA2ln32jIk/pw
         lrkA==
X-Forwarded-Encrypted: i=1; AJvYcCW+BfAbE9325OsyHRKknLUr+BctmXjGxwUtkyFKkMMIJJwBIz+rTB2F7cxNSCx6x2hQ+lvQTj3/fA==@kvack.org
X-Gm-Message-State: AOJu0YyqEkPE+wVIBDxMJIVNxE1bW/zbB+wPLDg+QNVZzSztqI1i2gpM
	A+l2mFUMy3XPJ8mfODuX1b0MpV5xAuNzKNz1sNA36WD/6QXspp1socXKV6psvHYjqAMElLVMh6B
	oSBU1H+n1RJ4RW9QUoNy08du/ftQHnCY=
X-Gm-Gg: ASbGncs7+/yJabEK0oJg086nYC0XtwcoRJiF29t/tojgm3pnN/tke9qKhtUqdeA+gsS
	QPvfYFIksaH0ptb/FpvKirlmFNIlCUvs7l2LN/P/vfULN9JU+VQo8VWjpYUkIVXx/fHEICTyyOq
	p5Eioe7CjkrcowpxIPlRQQ6Obv44ttYcU3HS55W7OrgWl8/knOms40qdiSmsPS/6xUdOp9ISPj9
	vI08Qw=
X-Google-Smtp-Source: AGHT+IFxdUlbLO4HNpt5l+2YcbYsbBU0mbvzO4XJ72fAO9uBg5cvJYcUkDL5cRzlXoduYtPRjqqasZFC6D43xjbaogs=
X-Received: by 2002:a2e:8a93:0:b0:332:5ce1:1fbd with SMTP id
 38308e7fff4ca-3353be4c4a6mr23211fa.31.1755626620874; Tue, 19 Aug 2025
 11:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250805172307.1302730-1-willy@infradead.org> <20250805172307.1302730-2-willy@infradead.org>
 <CAMgjq7DA6Y3vY=dfKCk4WvNA_AtH1uHmXo15UYipPgOXYw80VA@mail.gmail.com> <aKS7PRUfJRKWKnt4@casper.infradead.org>
In-Reply-To: <aKS7PRUfJRKWKnt4@casper.infradead.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 20 Aug 2025 02:03:04 +0800
X-Gm-Features: Ac12FXynGEtdrcGMntWqBpvWmKwNEWyKZy8PFzA2IOONF6OWNFigg0xIjYMX4cE
Message-ID: <CAMgjq7BZG4G3carSB6oEDk7griL_3yBqGGrPQ4ZcwBPYSVoYxg@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm: Introduce memdesc_flags_t
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3CC0440007
X-Stat-Signature: 118x8z83p146ez4p3ix7tbxbycpft5g4
X-Rspam-User: 
X-HE-Tag: 1755626622-926374
X-HE-Meta: U2FsdGVkX1/JS8QymDrR2JXQTFqf7NMH4jFcZM/PUJT/opOKbMlAvsqksvPA1BrKHhlYb5qU09fkG+YkYOWjf7x1xjtsdyRuIwLVX76ZeJKflkzlwUHJHbcI0XRLh3cv11Vs9C4zcvp+uJ5XULdA6q6xmlTmHU9UI5deHoButluheV6BGbcTXBSD242UF9QPtL5BExYsqidJotM3C0GoJmFkf57VtBjaN6DVxdRywEEFKFqRaLV8NhDg5CCEYdnWZfIXSjKtoavJXVKpNqTWeC2/AfUh8PmVaL2Cfp33GviQvVIzgtw5qHU0lbnjitky2WymYbIUC9GSxZ4TBjH9j8IMqw7MLvDzgf4lOm6bF+K0dQh2V0ZPsKRx5WLZpkfk25w9Lm3QhVeMkh9qkHf7RVtcn6lE6pYBnCFY0YXgRoXPmqQgwAkDX4vrZmoy9fUgTu+jhi2hdzz8dCgP/dW3fqWayVaxx3B+cqXNliFaPqtrFvxvOHDM36s2GszSdT61r4ZUKE/dFZmKeJCQSepbL39XJdEhheQFy5upPV8JxSobF2mPe4UYpDrPuRLB/CCFbxwiLyPLq6+e+5TFrZWjzzIp7JKR7OCs5EigcX2tjhgnEcYXsl6lq40YNyRyuJ3PTZwgOcWLFaOMxrNIgp74uE3P2zjhBhQu6GiE6SHA3+f7b2vtCniVFWmeMpAzdk9prgkhaeZN2SdZbT5JzNXj0MGNEfFMxvuK2RVfFzcUgUar70G66v2eJbUJjGk3VS1EthMBmQJ5fH53J6QvEDWngNjjLaUkVaS/eWSdJzxrTdUjvuiUUB/FCR94PW0rPa40FnGgO6j8YGA6Oz9kwZI2Zf/VaDSq4TM9kz6ttnSKn6VXAG0iIpmCFvwTkYfnL/87jEuWEBepVgGELckjhEljPhH7zZ20XYtTQBrvf0rL8r3vKWfiO4O5+ALPzd4Sx1rokaIIzDbKgRdEHQcFDaz
 cclmANNS
 AAIv2hg9xfUq+6WOCGebWFIsx1WfxDwAEX4+J/kixRIgo0q8uIEYANPAMRkZFiNY0mcINDD6MIQYafn75tLki6y1uFEWCR0gpVs/LpwDdw1HLcmqxx+Am/k21RJ+J16ey+Nr5V9IYw2U6p1EvL9PcpvXe33OB2jZ5kS3HVlFXbbgD58LQrUNSnO3ttLbviSTQV/TxHn+aESi/apYk/YQfyfAHXVwrPfWuF4Svv0vyrY7RRMkA7ndewIlkPd3dksy7x63+FSbQ7yno/1wzV+hOTc1EYXhp+lfXAmp6RIshrjbtPuVqhFec+pnXmtMXNS5X642lgjIhkhSbz1Z7IQhWM5kFzrEq3WocGtgY8ZYukmxV74llBZxOt8fI7vhnpg+ruN6fFoMCdr4fhsRAcakEC/sg76/UJptiXW87eSeSGXzttDDdqMJG/dCs+22C+9jHUV+LN1Ni9RjEyGSDkbSIBa6NGhQpgxapRVM24azlC1k7yMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Aug 20, 2025 at 01:49:54AM +0800, Kairui Song wrote:
> > On Wed, Aug 6, 2025 at 2:20=E2=80=AFAM Matthew Wilcox (Oracle)
> > <willy@infradead.org> wrote:
>
> [you really didn't need to quote the entire 900 lines of patch]

Sorry, forgot to truncate that.

>
> > I'm rebasing on mm-new, and seeing below build error after this patch:
>
> See https://lore.kernel.org/linux-mm/aKMgPRLD-WnkPxYm@casper.infradead.or=
g/

Thanks, this worked for me.

