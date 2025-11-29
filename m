Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60135CFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 20:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D4BE6B000A; Sat, 29 Nov 2025 15:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585126B000C; Sat, 29 Nov 2025 15:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 473A36B000E; Sat, 29 Nov 2025 15:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3196B6B000A
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 15:21:33 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A366B8AC65
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:21:32 +0000 (UTC)
X-FDA: 84164764824.13.EC34139
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id B4C8C40013
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 20:21:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=J7xFgPeQ;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764447690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XHR7HkGUh307NcvDolSi1iT1WNmg9xX4qNTaJW490g=;
	b=l2NPTrUk/XteQWvP97O0tEiVe9q54NgGIJmSBaVWmxOwHA5mURveOc+QEpxsA/xgK2ST8x
	PTTpccrAvQjGIyLulhTLZ8po9mTVSvlPZo9DTrmMh6o2PUIgyAbEr9NnvjTWbBby7YcWEW
	95CkAmNVHGiNTkKb6dIKihMJK24xtns=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=J7xFgPeQ;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764447690; a=rsa-sha256;
	cv=none;
	b=UmH/QwDaTTBkQ8Ymi0h7GV+0ozpJNKTAfYaatbO/eDqkAD8KjtT1j9jcCSNagFjwZ2c7WP
	Eg7pJBsQgC+lVpbA+YsvrmoHx2wUQkUxx4enIqGGGZhw1qmb9x4N2a81iwMUM0UFkQB7Su
	gAyx7k8u80vlAXSMj4TTWx0e0EdVma8=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso5681141a12.0
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 12:21:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764447689; x=1765052489; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/XHR7HkGUh307NcvDolSi1iT1WNmg9xX4qNTaJW490g=;
        b=J7xFgPeQRf0JQysA/rgZjoVC0T2NzORvwBDhJMfM4XF1uv7EGB7f7V1Nz3p0tUnweb
         4x8dzm/gg0weqLbA95xw3+eF8+sS+L0j2hVk6LxezgzJCoOfpxK3/UfVtGu6C5Q4pbzR
         FPbHhsbNAy6OlIKPTRUvXa15wGD71lNvKzrgUoAmfUVnTLkJRwcVGZntABoOenzd65iC
         3RQJ6SmJNGytZVA2EtW8FXpNV48Z6yyNpRXekFnIiEzDNB2AlJSeoKIueNKJLBPMDVlg
         lAPmbxCbg3lwyBOY7u9CvFcG6JQInBBbWGUQisd1NCcZNyG2uAxbuNiUmehTl/G817iX
         UqUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764447689; x=1765052489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/XHR7HkGUh307NcvDolSi1iT1WNmg9xX4qNTaJW490g=;
        b=mGEe3zLu98mI9CIsOFPmUBrZVm5aLp6p1GDErZducSyOrxndmxRTCGaPBP+HoB886v
         CgXXwsJRmv4GMyVe5OwMpfbpbqGddQpOdrBJqUp+PZ9tRDKm7ygWAcZlTDhfTGm98Gds
         5FKLwHeSm7P46yoQwE6naYQzfMobpnF0Xq66yVAwJZG8QEgPaOBLwDhgAyCHGPTtPLB5
         LPEhIQgAVw+eO5wkiALklyHiQpJx4ZMJXslOCY4ml7rjrxXHpfcoK2Wc9zGsf+HThPHW
         bNasKwpOh+v8Zt883okdXe6z/qK1KpFf3COvCOzYPoIG2dwIWz6iebRHD3o1ORrYESYe
         tCXA==
X-Forwarded-Encrypted: i=1; AJvYcCWLvnu4TL+LLeOEA0ZqtLQhC0Mf8OQP7nFcGCNUVLvzFBXCvx1JwdkJaqnMQFCO94aUNDEActJnqA==@kvack.org
X-Gm-Message-State: AOJu0Yz5T8jL1q0Is4suEmg2vk2SC1NN2OisLGG/VrAbyGcCagKPn07m
	r1QLxYjRBtOVp6Ip76JQzi3SVm9p2L3qI/gMq1lVSC65SRl09U41OST0WVsw+mNaSLfVdfmwEYe
	wHJ99qgR1zwUTT2qE0aoTqc2bMNrLhW0FotneqlMn3mkbAoue2+t1dtQ=
X-Gm-Gg: ASbGnctAl8LimgeThJOmxeqXwERkXSu7g1QjLo19cL0GJ7uByyaLegD/7MGQH6bn+TM
	jO2IHPeS2Gay5+Nvu5ABcRDhG1iXe+CS7Z50J3yP8qGdc79PDqOnDWz4SHP6Gr7W7zcPLFEerhv
	Bvb49X6+cko/szzPGvPVBf9Ijs2hEa86lzmAf1Vkp73a0g1wI+4jY0nwlFy1oDrNVZxKIJHbM50
	sHAkQz1OT5r/UZqvJyFaPz+fj+aNk9VhiOVc6RU0iMZf2z3GYjtbPf/bqwkDSvWxER1
X-Google-Smtp-Source: AGHT+IEL4C5AnQpblZ1dvvo+ajN+xWYGrZZ8Ar7Vxav7Gzlsu3+rsZciLM6uVqUSKHBwC7MdMFToICZgC1zz+1jAtMk=
X-Received: by 2002:a05:6402:1462:b0:640:b625:b920 with SMTP id
 4fb4d7f45d1cf-6455508090amr32009897a12.6.1764447689219; Sat, 29 Nov 2025
 12:21:29 -0800 (PST)
MIME-Version: 1.0
References: <202511280300.6pvBmXUS-lkp@intel.com> <CA+CK2bCmp4gjpyND2=Chdz-EfRAF20unYzO2dwQb+ZTEihgk3w@mail.gmail.com>
 <20251129120040.fb60e8a35d54d66c0bdbdf33@linux-foundation.org>
In-Reply-To: <20251129120040.fb60e8a35d54d66c0bdbdf33@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 29 Nov 2025 15:20:51 -0500
X-Gm-Features: AWmQ_bmWLua5FxNRY82NS-hj8ivGSs3L0IY3KtCuQNzfBMcPL-qi-s2DnemZlOY
Message-ID: <CA+CK2bBJmj3nK4QhAC5pr+5nS0vRv_5cOxAr_mohC+YreiZPcg@mail.gmail.com>
Subject: Re: [linux-next:master 12118/12398] kernel/liveupdate/luo_core.c:402
 luo_ioctl() warn: unsigned 'nr' is never less than zero.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B4C8C40013
X-Rspamd-Server: rspam02
X-Stat-Signature: fuk34c398gh3hcmf7ea8otq8zy7kw86k
X-Rspam-User: 
X-HE-Tag: 1764447690-879773
X-HE-Meta: U2FsdGVkX1+yME8RBMXTx52jp3YgfZlqAMMDQ6AUzxvqxP+oiviSc61/uUWfbEwhfynVp81hQPxGSZtdTiz4T4Qdc1mHWFaztHHeND0vo7CxjayvOptTvAHWg4rkNpf9CjT7UPRNhzW71XxWSgTpLcvgANClvkE6eorjfFF76Ccy+i1AxA6N1JTXm9t8cdW+0tQ5zcNtEPWXpJbWkC8i+TU5VxD9bBIp7v2VNC1Fd663iWTaXu6xdjsA2t55DaLYe6iO4Z8kBpYPc27vkNWJtMIOojGJZunsvDMJXEgeOZ2SGNbTDRU2BfO86rkcNVK3yjvoeQm5nJ0fWMV2m1hzYUU0eJvqSyp7F90Dd2AvJtwuyEZCpzUoKepIVnOkpizyx/cq5UzKAYS3vkFvpbIrqr/+G0LVCWN14yxixr/+Lhc+DUF6Er/UUolnTo7q3IUaazN2Ws1i7hFy0eMRRp6+1DNz3VTEJ6fsV7/TsE88IRgyKaF409ZGzi71Ydr4+BOpqqxXpEu88+JGGzrhHQLA9f7UDyhCyw3ACX6dVaOlZo8KEjc1oTHqv7CUgVUrCWwsZQ8+Iuw0ii5gKJwNlFkA5M5tGw2qIJ/Zd2vYwWeTuJpMY7u+PL9AIXa9ImDU0yGY2OcpW7FY/FIAhcD4MZiTlkNN/wnyGbhp0Hc4iqT8LoiVLnPaU8eJmxwqt74ihNCDzHXwtAf7P3cGAiYc9ga44mPHCc3wSMfhJQXh+ioH3NxO/O8gcH20rqOkYXXY0BxVjKBfmsD6s41RU6R0LVuvU+2Xp0D74zge5Xqtge4KfCqPSEoN/EidIOPKln9tPZf2PZ9h3SAu7zTeu8HmhV9NkUL6FsSKxGhpalx+3aOi29gTIhEKmD1RjqOxt/WnG0TNo++PwmQTib9bGuo//2XZxit8caCMUzdaGc7t+9LmFiYK/f4r0Yc6/zr3GJRPwSrOOY3y/89FW1GGmUCRFb9
 kHoyd1SW
 u4+UqWpejsuiHP4YnvlRza2iam6ZTECIB6KIP/oEgDYhN1rb9gYpcZFquUYacN1HLog2BN+e723EUWO/AOlHEcRZwKC/LrHHU9c0H6vKNLDe1D80vhPY9SQs9xpZa1UcNMinBBnXGY9E7FRlYnLj6E6G2PRZfI61V1B7PzBdaDdbSfzf19dmAzB9282MagFoWl3YvJw0k8CI1IogcWpELBmaN4vt00xpFkzc4Juo7vbK52zLY9RS0/xg4lvz1zqIk03Vk70JXAv9aNh+g/eSOgh/6/pyBBM4cRzXe9oqAMCDDpeDhyaOuTy/j9K5FjcQC1+3Ld7ObBEK/G8fRubMjYI9yeleu2VDfbAZl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 3:00=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 29 Nov 2025 14:51:28 -0500 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > > smatch warnings:
> > > kernel/liveupdate/luo_core.c:402 luo_ioctl() warn: unsigned 'nr' is n=
ever less than zero.
> > >
> > > vim +/nr +402 kernel/liveupdate/luo_core.c
> > >
> > >    392
> > >    393  static long luo_ioctl(struct file *filep, unsigned int cmd, u=
nsigned long arg)
> > >    394  {
> > >    395          const struct luo_ioctl_op *op;
> > >    396          struct luo_ucmd ucmd =3D {};
> > >    397          union ucmd_buffer buf;
> > >    398          unsigned int nr;
> > >    399          int err;
> > >    400
> > >    401          nr =3D _IOC_NR(cmd);
> > >  > 402          if (nr < LIVEUPDATE_CMD_BASE ||
> > >    403              (nr - LIVEUPDATE_CMD_BASE) >=3D ARRAY_SIZE(luo_io=
ctl_ops)) {
> >
> > This is a false positive. The logic is designed to work generically
> > for any base, similar to how it is handled in session ioctl and
> > iommufd ictl. The warning only triggers because LIVEUPDATE_CMD_BASE
> > happens to be 0 in this specific case.
>
> This is a difficult situation.
>
> In some cases smatch has found a bug, in other cases it's just being
> irritating.
>
> I think there is value in smatch occasionally finding bugs, and to
> support that we should try to rearrange false positives so that smatch
> doesn't report on those.
>
> Perhaps there's some way we can do that here, without uglifying things?

Yes, we can make "unsigned int nr;" signed: "int nr;", should be OK.
Would you like me to send a fix patch with this change?

Thank you,
Pasha

