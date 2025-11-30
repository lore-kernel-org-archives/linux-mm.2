Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE83CFD2F6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 00:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C36B6B000D; Sat, 29 Nov 2025 19:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575176B0010; Sat, 29 Nov 2025 19:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463CF6B0012; Sat, 29 Nov 2025 19:55:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 338C86B000D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 19:55:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C43535B6F5
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 00:55:42 +0000 (UTC)
X-FDA: 84165455724.05.A429ACE
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf30.hostedemail.com (Postfix) with ESMTP id DCA7A80003
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 00:55:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BPlo9+Sr;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764464141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODvKrhGkwSlhPa8Jb1bNoOTwQQH/HZ4Eumvhds6swjA=;
	b=IKpYfSvEaFAL4TD/gleeTAJH8B3uTeqaxE2RmIsP9HyzDAtmXmwgeQJbt5i8xabxMBW2JS
	8H8rOkPKaDbv3gsPdAMRSoAjqxlsqRNwONqJolVEzivYL1EBH4Sntmt/6P0gGQUtFsIwfU
	nYarcNkmwfcmdDC/7P/YB6eAB20cGLc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=BPlo9+Sr;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764464141; a=rsa-sha256;
	cv=none;
	b=6etSgJzM6AgNSrvn57SyYEkbGHcTIMiOtfQ+rRMBmJa0hmf7J33t8hrkLqEyQKQ7JIOA7t
	Q8WpRo8jXQvkQ9uTA2v9WT35I3rIWBnX9HSRYQLWw0ILuCKFAzCvJvzk3RWW0fg2fSJQX0
	Y59niLFkYSHhIVGF508R28SAaBM9O/g=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b735b7326e5so680370766b.0
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 16:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764464139; x=1765068939; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODvKrhGkwSlhPa8Jb1bNoOTwQQH/HZ4Eumvhds6swjA=;
        b=BPlo9+Srk6mv0a547LtQbuzqzfZPFzpjUQ0xFxXzjC4II2Ye8jYYVpu/sUtHxIqH6a
         Ff304BaDXQJ56LiqE9DXsYcm9nzd0p53LlIumx1Ne0E1c75yh/Odu5ckL9s0hwE2InPe
         EIwcmKbcArzG0wSp4FTKQKhD0jWBTGEeQCqmqIms9cq3h326iyGpeEqJsnsGFs521glo
         xfM1FkrjZFLDtYOZLzWe0cXS5Mm/A6acNpfEn0DgZFSF0zBqNNVu8T44awpHLRLG4gSx
         q/04jAtE+k9+jeKwxEyR71gYBKDgLB1zAPel4HmcVlrEyXB9mI7AGdV+wwL+8C5FUv2V
         bi6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764464139; x=1765068939;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ODvKrhGkwSlhPa8Jb1bNoOTwQQH/HZ4Eumvhds6swjA=;
        b=B2p6VNSGRQWpQX7C87/S8SwVftliOIDQP8yQbOkfZhFcjMuiuxb7SWaggvwXpiLBuS
         8REvOvK3hdKBA+n2JXuxxRtV7tNeBkp8fxchO6v36ixuHs73JYSimwTTCfNhZgyiP4qr
         +IcZuNKI/ssPa3tPB+PLi4ZTElyBVfBdWTeWBRkmxaR8noObZ4lnwWO5eFpHmLKDh00q
         dfDfT04A/4aDl5vmdL1s8B6+qNLNMLy+HODfhc6CPTYpbw/BqVQ4bajduBu1aHOsUSQM
         YImMMvn98W2iBttRM/W5h8EXUpU/aDjqM9DkAlo1L8x4dp4nxjgFpqiqrw6Qr4Wq5nEo
         qvNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyPZ/t0xJ8iCWXVVJXSqA1rlfXKFc4eWxZIgmc74SlkRBKwjCsyehY+HLVidYF+h4sbuGcSjzsog==@kvack.org
X-Gm-Message-State: AOJu0YyhSTOlmjEfsFSoSQGOv6H2dFLWxWJDgjV7Kx4Pd8NmKe93t79x
	IxTkvz+f0G1mb9e2tT9yAmJ9Gjeixzt+96fbsOKs2nY5+21soPqxxThOLw0wqEBn55iLXdmwyQd
	fe+ix6pWToXz1g5EMUnLVvB2P435QQY0H9+1TFKPDjQ==
X-Gm-Gg: ASbGnctaZeA8K4PtjEwlSpgG8TEYSXfehDC4bll9eua0TBGDKo7F12uPPUyxDYAuwHP
	szdmgbFCdQjn+PMlfElCX2hdYfwQs3b+eggjMThnh+j/m72Ld89Kq5rBgEKso8DCsxutstM5quJ
	wqRlYKes94MXaTS0IBt+qTPePxYGRqLY4h4pA0ASLq+b9wevO5uMC94mfQ2awhclMD7bc/GJkvR
	YGS0VDUT5OmwMpTOyFDOFfvmkzEhJP5XQKgmIZQFYoIq4MOo23tae31ag8x45orV82Y
X-Google-Smtp-Source: AGHT+IH6LUCi5rjA0Lr0nzqfx5DbAhNHqzUxGTdNtAaquPcmdopH9wDpInveo3rVf28FnQZ02b/ePqsUDSgGQlxuq+I=
X-Received: by 2002:a17:907:7e94:b0:b77:1b05:a082 with SMTP id
 a640c23a62f3a-b771b05a47bmr571754566b.2.1764464139115; Sat, 29 Nov 2025
 16:55:39 -0800 (PST)
MIME-Version: 1.0
References: <202511280300.6pvBmXUS-lkp@intel.com> <CA+CK2bCmp4gjpyND2=Chdz-EfRAF20unYzO2dwQb+ZTEihgk3w@mail.gmail.com>
 <20251129120040.fb60e8a35d54d66c0bdbdf33@linux-foundation.org>
 <CA+CK2bBJmj3nK4QhAC5pr+5nS0vRv_5cOxAr_mohC+YreiZPcg@mail.gmail.com> <20251129155221.d5f3c519747d8d492aa17462@linux-foundation.org>
In-Reply-To: <20251129155221.d5f3c519747d8d492aa17462@linux-foundation.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sat, 29 Nov 2025 19:55:02 -0500
X-Gm-Features: AWmQ_bnGr4rnCvxKPzqTx69_qNLEustqMkD3XbJsdWt8w5JVvGcgYvW5EMJahow
Message-ID: <CA+CK2bCS3DtWR5u-z1jwyQLxLjgEJuvd916Mn5wviBLD_M6Fww@mail.gmail.com>
Subject: Re: [linux-next:master 12118/12398] kernel/liveupdate/luo_core.c:402
 luo_ioctl() warn: unsigned 'nr' is never less than zero.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mdppgfm7qx5kx8ubume3gs8q6f47fatz
X-Rspam-User: 
X-Rspamd-Queue-Id: DCA7A80003
X-Rspamd-Server: rspam09
X-HE-Tag: 1764464140-425338
X-HE-Meta: U2FsdGVkX192VLy7OUHIjcE4rAbBGPpSxGCc0SAtiyBsNM8bhrHWQMFw0coKnkddEwuSQN06LVAoXGkyVGR8EXbY6cjXQapTDPKHvhMlGEq6IsRyXT2Ph+6NKK1jRvC1JEmLbUFZwDxn/d1ak2Y+aT7BDpnds0zruzmRDGWyxVCl0sjDP1JSD0lnj1Q/hLylF1OVWxIld7a7n6E0vXb1KIgmK396fLnGJOuvKN7xhxDdJX1qLLWzLDWNYSfhD47LvQVwoXlTTIRHsYjei3syVDsGk8cv/lKMo8RkH+U+vaPMdiDeZDd6GI2qvO+VUCHV/sq94KZLw2aJ75zwZOvdJIK58TBtnpxMDxQjnPc1rOPJJj4twMOejOvP0/FlEsULbrUtVcleA2LxX7y5aeuEo4m59wsMQtPALdzl+68yR/PnClwSR8OCFTPs2CY+I0oYcfyQ6Ue1pE2u6xRUp+80qhbePGJo4vfkcaybTNUFjqFHs635NT7juRtm4i0DfuonnLqwWdm811bUrSkdChua6evHLOSd9vX0KabBzsmkpD71Rg63X+dyH7Tr5uPJec6R5zfu9HJpAk52t7qXCnuTAZqA+imG9oaXDH0+G1s2SQbmtYIvDqrbFrL0ci/PELgoqhbxzzM/heNvTNE9cY9WT+g13lSNG9s17mv+B7QZKqlfwLWGVp+EdYdSL6zQx0IF80H061t7vNAlfXP1orMdEhrfQTXwWeUS7EV05VLX4FXbHKBGuPDNtQCg76yB1ENCZaO0qnWMAq03xti9aJ5TcNTn/NdZ5lSYASFMwj7KsxuNxX55YDhsV2TZBkIhQm5LymYgG7QQKzBKqy1zLH1OF5rPEfyDhe82a+xLWuz1iWR6vh+iemjvQBkeim3oEzjbhwt0QHCU4EbYHdxm55gP4p+CxLC9sIsWEIz0UW43Jz4Jcdak74PnI85D8WM+LratunNdCPwHxg7yTeHA0dR
 SKGfwHNX
 xaWf+UtC8q2yGKISCWX/h5yhOMq1YJWhaQ+Mkn+cm0J4/OdZRweoLmtKJbDcYY+V/X/2kOlofUYvUJLrxrjJAW6iVmhwtI6AMgsaedZ+fHW7zsD4kM4ZfWLS78/YHltsc/DrlVPDWspOhFKcTzh9LlU6UMmOxr8La2X6BFkH6cSLhCemIoYzy+W7dWda3qawmX4Eo8kNt/3AEr7otvz19gvX2Gg7ZczhnjFt3pZQxKhSqIOHEeb5GG8ZnTVY03QOMMBkM7QZ1ZMGT/tVLGtpK7KHSjksZv7dngDyesnXy/2+HpyBZnEyZ7M+Ak1YK7h8j+y/N++IMa7+Rm6jLcRbcsjG8nij396ojB1dn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 29, 2025 at 6:52=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Sat, 29 Nov 2025 15:20:51 -0500 Pasha Tatashin <pasha.tatashin@soleen.=
com> wrote:
>
> > > > >    393  static long luo_ioctl(struct file *filep, unsigned int cm=
d, unsigned long arg)
> > > > >    394  {
> > > > >    395          const struct luo_ioctl_op *op;
> > > > >    396          struct luo_ucmd ucmd =3D {};
> > > > >    397          union ucmd_buffer buf;
> > > > >    398          unsigned int nr;
> > > > >    399          int err;
> > > > >    400
> > > > >    401          nr =3D _IOC_NR(cmd);
> > > > >  > 402          if (nr < LIVEUPDATE_CMD_BASE ||
> > > > >    403              (nr - LIVEUPDATE_CMD_BASE) >=3D ARRAY_SIZE(lu=
o_ioctl_ops)) {
> > > >
> > > > This is a false positive. The logic is designed to work generically
> > > > for any base, similar to how it is handled in session ioctl and
> > > > iommufd ictl. The warning only triggers because LIVEUPDATE_CMD_BASE
> > > > happens to be 0 in this specific case.
> > >
> > > This is a difficult situation.
> > >
> > > In some cases smatch has found a bug, in other cases it's just being
> > > irritating.
> > >
> > > I think there is value in smatch occasionally finding bugs, and to
> > > support that we should try to rearrange false positives so that smatc=
h
> > > doesn't report on those.
> > >
> > > Perhaps there's some way we can do that here, without uglifying thing=
s?
> >
> > Yes, we can make "unsigned int nr;" signed: "int nr;", should be OK.
> > Would you like me to send a fix patch with this change?
>
> Sure, thanks.  It's a bit lame using an inappropriate type but the
> world won't end if we do.

I will send a patch.

Actually, I realized we can simply drop the nr < LIVEUPDATE_CMD_BASE
check entirely.

Since nr is unsigned, if it is less than LIVEUPDATE_CMD_BASE, the
subtraction (nr - LIVEUPDATE_CMD_BASE) will wrap around to a large
positive value. This will trigger the >=3D ARRAY_SIZE check
automatically. This solves the warning without needing to change nr to
a signed type.

Pasha

