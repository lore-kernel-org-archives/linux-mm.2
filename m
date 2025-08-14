Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87279CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290CE900105; Thu, 14 Aug 2025 03:37:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24126900088; Thu, 14 Aug 2025 03:37:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1302D900105; Thu, 14 Aug 2025 03:37:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2164900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:37:44 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 791A783099
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:37:44 +0000 (UTC)
X-FDA: 83774558448.16.23AFA24
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 48E0818000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:37:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=lQL7PQG+
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755157062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E6lyA0E3BsgF3c0Firp9DhkX0QGDczU/GAUF9m624y8=;
	b=kF+UVG0g3goKnghzy6vjveKxw2niRlFljAPs3EKWcfj5aHtmyayZQmHRTJXcR9UZoOLE91
	WjTwxO+Y02YaLwPzBwJAeSanIOVHT4TPB3vwgeRO2AbrnEpn+rcFrHwa+azPmu3lnLUbrG
	rfiJOkpMtVTVYY5MmI85C6FeqiqxnoU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bgdev-pl.20230601.gappssmtp.com header.s=20230601 header.b=lQL7PQG+;
	spf=none (imf06.hostedemail.com: domain of brgl@bgdev.pl has no SPF policy when checking 209.85.167.42) smtp.mailfrom=brgl@bgdev.pl;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755157062; a=rsa-sha256;
	cv=none;
	b=E2QIUj6v2GDvQIzYV3RFi2pvggjBd3aP/bDUs/Dwjxcm0awm2h436Qkgr2d1rCF3MhMGCv
	cZtqRNtc1RD91K9rn1IYHluN4Uq+fOBe6JCAn3ikD/63giT/jIyNiZClRwI2PtmUrrkf56
	ioDC+yPvDmgDtTlYvXmcDBnI2MdRBNo=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55ce527ffbfso530368e87.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1755157060; x=1755761860; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:references
         :mime-version:in-reply-to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E6lyA0E3BsgF3c0Firp9DhkX0QGDczU/GAUF9m624y8=;
        b=lQL7PQG+sEgD8SfsUX7T2+wlW4CePklRqZ6Q7gZdfmcQ1P4NQ06309cNd+q/KYzgti
         FfHwVqD1ukAK/u7357OBn9nFAo0F3kMLLZTIojcB1aBUnfrUvMYaCWPcduDFfn4i+nMk
         iJ7aGiuehn7uZnpZWk2+ZrtjiJKtWoMFj59Y9OnXqLvDkVMTFUvUWbL2xrn2C0A/cS7d
         Rb1IRz/5ZZkSMtDzxAq1PZSZHzrDfpOrlZymlB27JeBwIxfJmMg1aVUenqgM05hnEaBH
         wRoXAveRseLyZRnQ0YmaC3M2RAzDHt3cetMpDzTZkkMW0vP6xe1YaH7DAxEO2IUBsSz5
         HYnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755157060; x=1755761860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:references
         :mime-version:in-reply-to:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=E6lyA0E3BsgF3c0Firp9DhkX0QGDczU/GAUF9m624y8=;
        b=Zvlv77G5gxsF4aYtNdKrCAALtCNi6RVjmWokkleV8Wbsx2wlI6cTg/3k4Vfq3zmRGR
         9II6WiwYtvwQBmReDwTomCY2w2p/H5KtC/ZV5DHi9h6A/c0Umj6/LpTUjdIhjtczD4+l
         EOhiS1dT3WgLB6TC35Qs6bpv+kcHXXGuvqLxxIMbWd/+EwNqShUB0rRpK0r5DPWFpvPY
         UmPwNcbsn5i6IBco10EJzpmsGPwvvlVYi+Otebm3nOoHFA23qIhU5oNUarm4fUjenuJh
         TSjuWLSgBBmRX8YD/A0+AIodRMsH+/iDwjK6EaBhoxrnAcLONcj3Du43pNwJT8hMMKxH
         Vt+w==
X-Forwarded-Encrypted: i=1; AJvYcCV2ouwJxjfs/4XlkXaK4sfCbk9HnXXR+iTi8eR5QGpe16wFttjaROo1XS6QFXh9GUbEmhQ6kJrIAw==@kvack.org
X-Gm-Message-State: AOJu0Yz6GDfCb0bg5lZsE1z+/cZ42G4t2PN90aCdEd/8raNpKh4Aacyw
	/8H4h4mbMSCHW9wKGWMJ1RAo2inrxOnyf5NBIDkmM1nrFL/M8RHNyDRCm6JnZn5cVTdd3hhKD3p
	2+wGgBFHF0PMenVCZ8zRfg4zDfVmYaD+6uBVf6RAKWQ==
X-Gm-Gg: ASbGncu0q83Q55h0HobReVanJ8QKHD86fgaZSp7VXZHFOOUJYNY0RyCrT5ETT0vSBgY
	P7ji0G2i56RvPTuAFhN/+z4hupaUyMVR8/iigxwUwAO5p2n974c5epMi3MEsR8jGPQPgGar9h1B
	3NjDxfyEN1PEkTyZPoq2Jr3JG08eOqeE2AsRHrCmQwDrWNRHeASdq5nCqc4h0QDMEXN7aKraoxk
	quKjb29jwTfiPUYkXGYQ+UQvq0gOG9wlJJhFQg=
X-Google-Smtp-Source: AGHT+IH95og7bwOhUuHKkvwv0kTue2EveWatnb0pXZcfIY30oh+DnenMVeGiemPUTLNRulqOQX9vjsDh8YkJvs9r6SA=
X-Received: by 2002:a05:6512:3d29:b0:55b:8f02:c9d0 with SMTP id
 2adb3069b0e04-55ce4fe3984mr762477e87.0.1755157060157; Thu, 14 Aug 2025
 00:37:40 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 Aug 2025 03:37:39 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 14 Aug 2025 03:37:39 -0400
From: Bartosz Golaszewski <brgl@bgdev.pl>
In-Reply-To: <CAHp75VeSA=AYDKOV5XQ5nnz7EZRmnhbbVyJrcBUcMO2LrRMTmQ@mail.gmail.com>
MIME-Version: 1.0
References: <20250812-pinctrl-gpio-pinfuncs-v4-0-bb3906c55e64@linaro.org>
 <20250812-pinctrl-gpio-pinfuncs-v4-3-bb3906c55e64@linaro.org> <CAHp75VeSA=AYDKOV5XQ5nnz7EZRmnhbbVyJrcBUcMO2LrRMTmQ@mail.gmail.com>
Date: Thu, 14 Aug 2025 03:37:39 -0400
X-Gm-Features: Ac12FXy2K4h4wcbTuyQHNLoBpmiM4n8vonnKvWP5_H1uDnS85jqeBZjb-G5DXZs
Message-ID: <CAMRc=MfzSq+7EY8cV+J_AePve6r+yV5QEHqG=Z2N8Afmy+Bc2Q@mail.gmail.com>
Subject: Re: [PATCH v4 03/15] pinctrl: airoha: replace struct function_desc
 with struct pinfunction
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Alexey Klimov <alexey.klimov@linaro.org>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Sean Wang <sean.wang@kernel.org>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>, 
	Andy Shevchenko <andy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Dong Aisheng <aisheng.dong@nxp.com>, Fabio Estevam <festevam@gmail.com>, 
	Shawn Guo <shawnguo@kernel.org>, Jacky Bai <ping.bai@nxp.com>, 
	Pengutronix Kernel Team <kernel@pengutronix.de>, NXP S32 Linux Team <s32@nxp.com>, 
	Sascha Hauer <s.hauer@pengutronix.de>, Tony Lindgren <tony@atomide.com>, 
	Haojian Zhuang <haojian.zhuang@linaro.org>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev, 
	linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Bartosz Golaszewski <brgl@bgdev.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 48E0818000A
X-Rspam-User: 
X-Stat-Signature: q5w9a3qmk3t9txn6riehthdzt6yggywx
X-Rspamd-Server: rspam09
X-HE-Tag: 1755157062-241529
X-HE-Meta: U2FsdGVkX1/LIsVuKKjnIjEFop44rHFMTsdejW+/kRaIVH/FQRVTP08NX/pXuORH7fTPOTXo3Wjm6cMkKl3rwwq5vwedCGqTYt514qf2de2xmmlMzb9dUTK6JnjWQHrrO5wix0kOXuzfNvP+ZrPse3L1fZTDTV0UdsS7qTCx/ji5TxmYWqPVt9YvMk/M2L28DDIWQ64qGOxxSlp22LKQdOaa8ELDHJ1PjqsofDebOvfAfgdVfKV2yj9TVWt/aq9TQPwmTedKg39Pc3XnqbjQJh+0Mh9JSwx9YZ+YSrHqUXNraxzS3IuCQupmAIQOd2WjCsVb91ByPKLoaldy/GYOdyVDK4sZBhUriTrWl7b/pVPBKtlHzOYq4yuS1pqFPVYngytjqL1SirJrKmAzHzyH2FUPRJds7fSk6VcQWfMzqkIgAZ0iFaUQDmKLg2mDJVuzNY1NaHYCukIJTtbitHqzSWJZvB9gtWXLree+AB8x/7t+l0WZ7ckdm2Rkmrm48b2Gu50/5s1lflwQ84ev9gifViN1cFhnNXm9iWkjQ1iIoMkniHVPE5cpXqxTM8DOQaFSc4gPUhbaW07OBae9cXOHacOKwQ5w+COiDx+P35XlfX9rhM9LLrlGKI+XFnKmYGJEPtgR5VVkvmxUKkqum2/UYpkmhzKIoIZhGrR3u75Cry5gKViWPNMt7rmDd97+CH6ZQXCJvzDXq2H3WotYBYGSPP0B31Kz0h7Gq+uqB61HB3d4/vQGBH0QCe46anCOosHUx3kPSTGUYuk4Af7YwLZrlG+OUOA/KR2qiyOuGgj4sXHhciMLqk2vTCvDgQr9w/rMOlW43YtvNN1qvUQzNFBBVz4XQHsh7BvehJXt71t5f2oZC5RUUQ0+0u5+7q68DioeIOdWzkfFhjRia2Pi3g3UhBWqMUvcfL59h0lWn5FnJhq3jjcrWE4B8yfJcShC5ABQSbrlmN27zxUXNdNayZc
 skeoTOBF
 2PA822ylHmxFcEaP3aSHTaHn/tnTxRKmfYBRnphCl9XwtGwPbiKZ/B1fVijY3vTxtSWsRkUiYhmLacWP602IUX+nSzApabZ3p28HOObJFduQ6ioqQESL0Ea+2fRKGUDZOB+LhRsg9vZLbF0QFQglIz7Tc95rRN0pbAvzFnBOWz8WewTPVRK/OYd+4Q9YqjYdG0NB6+4/vi6cstLlpmRuFwAyxN1Fqeuglh8Q0affWNge2dtMbvnuqal6poOFUqdnI7eq5utMZp80Nd+qnriuhAkQbUt8THrAtOHKqBsRRCU8gh6LrJIt0ZrFacHwTmd9ItM5LKClc6MIhI+nnPFqLT7JFvj52Yjk5ZkD6lOb1rIYhwDhKTlg6xfyhzzcDPT98aFV09CWGP8WC1SFBZrtfl2qutOYYbSnMyOi/PsgWBW1o+3hyJN16W10AhM786+s4vHhzLuVYsWwLt1Sh0LepKZznqyiHLaTuWQRhY5Ez3s6HXYY5uPkA/3I1bn69WuDNibCH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 18:57:00 +0200, Andy Shevchenko
<andy.shevchenko@gmail.com> said:
> On Tue, Aug 12, 2025 at 10:27=E2=80=AFAM Bartosz Golaszewski <brgl@bgdev.=
pl> wrote:
>>
>> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>>
>> struct function_desc is a wrapper around struct pinfunction with an
>> additional void *data pointer. This driver doesn't use the data pointer.
>> We're also working towards reducing the usage of struct function_desc in
>> pinctrl drivers - they should only be created by pinmux core and
>> accessed by drivers using pinmux_generic_get_function(). Replace the
>> struct function_desc objects in this driver with smaller struct
>> pinfunction instances.
>
> ...
>
>>  #define PINCTRL_FUNC_DESC(id)                                          =
\
>>         {                                                               =
\
>>                 .desc =3D {                                             =
  \
>> -                       .func =3D {                                     =
  \
>> -                               .name =3D #id,                          =
  \
>> -                               .groups =3D id##_groups,                =
  \
>> -                               .ngroups =3D ARRAY_SIZE(id##_groups),   =
  \
>> -                       }                                               =
\
>> +                       .name =3D #id,                                  =
  \
>> +                       .groups =3D id##_groups,                        =
  \
>> +                       .ngroups =3D ARRAY_SIZE(id##_groups),           =
  \
>
> Can this use PINCTRL_PINFUNCITON() ?
>

Yes, it can. I'll update v5.

Bart

>>                 },                                                      =
\
>>                 .groups =3D id##_func_group,                            =
  \
>>                 .group_size =3D ARRAY_SIZE(id##_func_group),            =
  \
>
>>  };
>
> --
> With Best Regards,
> Andy Shevchenko
>

