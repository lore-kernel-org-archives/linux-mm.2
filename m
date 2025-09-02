Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93FF2CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB1E8E000C; Tue,  2 Sep 2025 16:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B238E0001; Tue,  2 Sep 2025 16:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43028E000C; Tue,  2 Sep 2025 16:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE8998E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:54:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62D09B8F13
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:54:51 +0000 (UTC)
X-FDA: 83845514382.01.A7027AF
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 785CBC0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:54:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QgDYRYHT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756846489; a=rsa-sha256;
	cv=none;
	b=jPPVbKmAF7Ee+2t1xjlXINsV/bDzxAF4KfI0dynJfLLCJmjjXEfD7hoG4+kumtzrCoEqqt
	ItbjnjJF/22ld1q061kfVhV+BmxazqhZGx4CY9WXHzPw9lvzSHzIeVPuO4H/4puS+zKsYW
	tVmdlAtv1wqDtfiY6ZbND0ClbDJ4OFo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QgDYRYHT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756846489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kutjVkpcvEETb1qEj2HY122cngSwuEsceeDMIRlTOiM=;
	b=c7fuRJ91l2dITK6U/lL+RNqyEa2h3Lf5G/MCbqVIpevoTTpJ9w9hwsL+RYEnNAMe2FLAth
	sglk+Q9qMRH0Ss1cJE0d9LpueR18QRyVbqQjJ/ZFtBfEM9HVrMQU1M0V4TUendMUr9tlQA
	oDVBO3sgEBlE0vjqJAiCCpIdZ75HgEE=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7ace3baso442144166b.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756846488; x=1757451288; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kutjVkpcvEETb1qEj2HY122cngSwuEsceeDMIRlTOiM=;
        b=QgDYRYHTiBBSid3HYxUCgQolRzwMgTU5XB2I6n88iPjanQHbP/oCi9pEzG2HUFMZxy
         WUTe9Xv03vgOG7B6VRTKtZurbo9L8d/09p6V0LDLyv5TkYEOKZ3NFfBXrac/kuJz81o/
         SQxBmc7RMk87ti1w+j/2Sii1lrfHCrMlB6Rt6mG/7QEBWwp5Hp+I2CoS9wn9G58wanAl
         LuMFYKsQyMsRyzL2Vw/mREfVoDtoa8NO7RFWsoof34X6rw3XKEca8QLpP//5iUAIDzm6
         fuozGNmmT+3NQx+OL3k/j9un89cY+zC7oT9OQGTGkD4461ERl8Jyhn+JadDTo+x3+aUx
         SDSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756846488; x=1757451288;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kutjVkpcvEETb1qEj2HY122cngSwuEsceeDMIRlTOiM=;
        b=wXhrniD8Mxggjj46tlfZ5By2cJBTP5UTBKppvxU0ROXqR18t5iniuGvm0ZQ9EznqpA
         umz5bSynj4ZHvrdDdA+N2MZk4BOhvV0CzO0tkQXE5Ae/gdE8h2UWTiuF504tEaCwt65/
         tTFzRW4gvJzBN20Pye8xnDwRhcLtnE2x1UdCMcry8Lzl6K/jmCAECGxE5lFs7KzQMZiU
         9/qcGOqYOGw/Hmj4oAb2l+3fSboesUR/ikAxUa4EXYFGSBXhA7TKbOR5mcDaI06ohy85
         76A6aH/Qe9PfgcxEeyun2ebPviA/s2Wtns99wgSBAozv0YZlmENhgBOXw2XZGAQRRUH4
         lWIA==
X-Forwarded-Encrypted: i=1; AJvYcCVpoezZ0lkmOOJGq5EvUqj8P2tQsEorMBzHRjlZFtqP8YdHcYgsdW3Lb2R2VvYJQA3x9h8htLL6UA==@kvack.org
X-Gm-Message-State: AOJu0YzQzpNwyxvIX2zM1+ICcc0zWuvIZAx42+d4BGWHx9XDOZHfOs1a
	rJ9OgtqnIYCxTQEI+tLLERLRia1+STfLcbDoNWxhM9zcHTUgtEdin4I35glskxf3Mx7q9aH6Xu9
	pPaBwZw7TTZLwyAY/9f7cBfNVVI/PqsUF4QvXSYg=
X-Gm-Gg: ASbGnctylN/9LgvPXHfIGI3YX3k80QnnUEcCXjqVqkXp0+EwQzl56BYFDZ6idrBHiE9
	CwzAR8Fe4N+YTbjWmB/4ZASRPG288ECc+yhDHgb7JJNs3SkBzQY2PDeeHb+Dbw1csGtSFlcm3Xm
	PHfFpw2rbK55XQOGL3KoFRdL0NmoKO0C4yEMaZN5/Piuvz6f3AmXdf7CBApoRqfqw8PMZ1nAlt3
	31wOCHLQNaQFwM31w==
X-Google-Smtp-Source: AGHT+IG4zlhdZMe5YSuufGeqwlIQK8acaeuuvg5xL+VVOl3StpGEjjD0yfcY2w04cC3rT7k1Cl4bbDXfAthjT80xlmI=
X-Received: by 2002:a17:906:4fca:b0:b04:6546:347e with SMTP id
 a640c23a62f3a-b0465463a5bmr50237566b.51.1756846015338; Tue, 02 Sep 2025
 13:46:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250902-pinctrl-gpio-pinfuncs-v7-0-bb091daedc52@linaro.org>
 <20250902-pinctrl-gpio-pinfuncs-v7-16-bb091daedc52@linaro.org>
 <aLcBcjvMbrxoDYoC@smile.fi.intel.com> <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
In-Reply-To: <CAMRc=MfcFMgkNqWNZV5o0NxkAvxBTjC3vv56Cr98n0R2CkxuPw@mail.gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 2 Sep 2025 23:46:18 +0300
X-Gm-Features: Ac12FXzQiEATdvX4DXbIt31zcGrGliq36XoLvlgsSrCLd-DIw99Mu03fZo98CMc
Message-ID: <CAHp75VcgaqnDrPH27wxfgyK6zz4RAKJQB0r7G2vbTONTxkEzTw@mail.gmail.com>
Subject: Re: [PATCH v7 16/16] pinctrl: qcom: make the pinmuxing strict
To: Bartosz Golaszewski <brgl@bgdev.pl>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Alexey Klimov <alexey.klimov@linaro.org>, Lorenzo Bianconi <lorenzo@kernel.org>, 
	Sean Wang <sean.wang@kernel.org>, Matthias Brugger <matthias.bgg@gmail.com>, 
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
	Danilo Krummrich <dakr@kernel.org>, Neil Armstrong <neil.armstrong@linaro.org>, 
	Mark Brown <broonie@kernel.org>, linux-gpio@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-hardening@vger.kernel.org, 
	linux-mm@kvack.org, imx@lists.linux.dev, linux-omap@vger.kernel.org, 
	linux-renesas-soc@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 785CBC0002
X-Stat-Signature: d3kb5gnezpaxsh3198b6ytkgu6ee3w5u
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756846489-648913
X-HE-Meta: U2FsdGVkX19+JZkzqb/hHLC0Yq5edXQ04ytj6RdtAQxPdtFIJMsjaHyUw3mj9bE2uca0+5W916jzhKrXk0yDafm4wTmjRORI05RsF0Z1CeMS0j9O/LoHf8N0TRhsHwYrajMOm2zdm8Op7HeheZPpqAApqLTRg6bmBgXx2/Yz+aHZvRWe2zSr15aG+0aelSfjALi9prNhN3n6u+JgtJjbXJrmy79ZILNMhlPvhi+6p4/PN7QMx1//I5pn+Co8nSd8fMefwiizPP3jDfDQ9YVWGebV3mWE34z8OYZmJR0iGB+sKgGGBbmRqKZK/EAM4J6+i4M3XqWxeXfptv4S3jzMeRjHBETSaLPo74WLcJjhU8yPJUzh5OXktm6ujYCS2lQ1N327V/UgaT4KSWYfnhQOL7DFkMyprnno8svxCyv+7MfwFq/SqPbeM8t+/asGnDcgpxrMpO89OvB+bBWkcfVlBtlRz2UYvLb5F6GmpmBAoNDVV9lcXA8jw1TZx7KvCpb9coB016qltJBjBI5mgFeDPKLunqeWTw7az/PKLUK2mknh8h/w0MmpYnFikrYVeUYUCObzF/b1wWBZjunr8EXmqgH4zCLEAQQ6VVpKbvV3Ho6aQHoA0yVZN0AwNwja2J6kJdVO2rQDJw7Ym6n24MTHl1ZnBV9H2p5+WVkMmRf7exu0mqe0f4ugX3kRH4aE7G9XfMuH2BceR3jhYEoetQ0/pFDubH952eHn9OYPRDq5ety5X6adsHComKlU4BNSNZ+39SFL5YvhHrTV0NTSURk0jAmmrwInOLg1BgOVCXjv0EvmUizfhQG8cJm36/IihBCrP3/KLxSiTbmqakx49tnknfCF6CuYltkl/q0LDKo9PmvIqvByvae+FYjuwd3cJLhWGUw/bmWil1DJE5hMR8aInQ8x5pcg6VA5GHQG/idrq9OYwBnG6yf8rG4tWFC4RTXQZuSRSLqUp+UHohggX9o
 PcDsp/3C
 81zO5VBWO/hP/RDXu+eiUhdFQnf3KPSXj5FKxA8TpR4FiMpWsyq2FKmbhG/qTiBn4J7zItCA683bJ1A0isMcMshd+8lOboo1yUWsE+KpB+pl3z0dh9DoQq1/rKywnswzg7BD0U6ptg4q2h4LLm9ExHUyhB/S/h/96vIVtwRA1NMOy7K+cr6cVvQrs6C6CBiz4g/9lVKaNLnz8goQRJC1FBIId+3332q7221f1Minokudpr1zX37xkYih7cZz5vn42X0fWV7AO50KLUdWljygCRqSBYEnhhpU11JlINB9+gVQAZBCCZaZtwrGvABQdMFZtueFaobhl56mCmhIAxVuDdh0rf9fwYSqbuv+UWdqVj7vZgtn87lmpQNF2x7JzTVqx8uwjzWzvrkiSzTM+y2jozgzSYvpOHyqa4fL4aoMd+82I/61p4h5XgJLR8ickiVMTkj+9TqlT5oK7VRktITVUXhbtD4Hq6QisGY9RO3hGvrVsubD4ct3GOVIlPPQmLAh/SiSF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 8:42=E2=80=AFPM Bartosz Golaszewski <brgl@bgdev.pl> =
wrote:
>
> On Tue, Sep 2, 2025 at 4:38=E2=80=AFPM Andy Shevchenko
> <andriy.shevchenko@intel.com> wrote:
> >
> > On Tue, Sep 02, 2025 at 01:59:25PM +0200, Bartosz Golaszewski wrote:
> > > From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> > >
> > > The strict flag in struct pinmux_ops disallows the usage of the same =
pin
> > > as a GPIO and for another function. Without it, a rouge user-space
> > > process with enough privileges (or even a buggy driver) can request a
> > > used pin as GPIO and drive it, potentially confusing devices or even
> > > crashing the system. Set it globally for all pinctrl-msm users.
> >
> > How does this keep (or allow) I=E6=B6=8E generic recovery mechanism to =
work?
>
> What even is the "generic recovery mechanism"? That's the first time
> I'm hearing this name.

"I=C2=B2C generic recovery mechanism" (I dunno why you put away the I=C2=B2=
C keyword).

--=20
With Best Regards,
Andy Shevchenko

