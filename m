Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1014DD3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 19:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 753916B0007; Mon,  8 Dec 2025 14:08:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7053E6B0008; Mon,  8 Dec 2025 14:08:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3046B000A; Mon,  8 Dec 2025 14:08:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 493826B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:08:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE82912CFE
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 19:08:05 +0000 (UTC)
X-FDA: 84197238930.11.55CC08A
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 113AF40003
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 19:08:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=fasheh.com header.s=google header.b=a5A21kIA
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765220884; a=rsa-sha256;
	cv=none;
	b=ZZoenh3xzCSq6+VCa2zFWmbeHkeoYjV2Ycdm8m15NcSslgYKebk7n+5Hh/W1cgWxsj1SNP
	1TFYXtZf+XQih+oUpZT+nzKEUlN1xt97oOM5vz2O4c7lzXvUcgPat3X34U1hlpuf9sfd53
	J11PMP7aYabIP+qJwtyevVm1xKwxGaY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=fasheh.com header.s=google header.b=a5A21kIA;
	dmarc=none;
	spf=none (imf12.hostedemail.com: domain of mark@fasheh.com has no SPF policy when checking 209.85.160.175) smtp.mailfrom=mark@fasheh.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765220884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yPID28DpX/lRAgXOsnJ1NIPQsZ48K9MGkXMnfljxvE=;
	b=NLwU0MakfXF47+ddPPEcQXy81No0VWvSp2qMYl6As2lNjynhSfSlXJAYMAxv5sJ5/7dydy
	05Rk6GsIF0/N9v8JWSqUOBP+WBPQjQo13VZaHJb0eAN4OVrX06QWO1q1b/hNVILITX8r1Q
	E3euF0sdlESDm+BwQUYjuDYKJj31tkk=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ed75832448so66920171cf.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 11:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fasheh.com; s=google; t=1765220883; x=1765825683; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4yPID28DpX/lRAgXOsnJ1NIPQsZ48K9MGkXMnfljxvE=;
        b=a5A21kIA0Un22fegv+OcVzqd8PhGu7UmuFRJ4FuPGYRzs6hhgVwkuvPX3LNZSKbDzF
         S4xOXKJXjsv9M5pUdwf9gNNudWVRxTCfHSKX97Yn1W7yndNUdBoUGPih7Wq1A5iAA9+u
         BiqhTO2+bXhH7VK2Px7h5Pd92dpeIGGwKaEymgR+yvqR5MHuriyDLN9genFlZA7wZjU2
         vO1alT3X9to0RhTikPMr9jLcB955rEmnVUEDOoN4WIuZ2Y8pmu/tVka9YFozr8mCSpYV
         +TnEvM/mBBII0DmRt6KmsAqwR5DQzOkw3lcSufBv6MQPOs77LVKDK7gbGQ4rJ2bVp6pT
         rRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765220883; x=1765825683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4yPID28DpX/lRAgXOsnJ1NIPQsZ48K9MGkXMnfljxvE=;
        b=MMq8onj2fyCgsQgq7N41WXY6w9pUJZM2Eb8nK+9JZU/erkUPpnxwMd4AAPvAymYaFQ
         U5e1+Zbahp+f3vc85I8E4Jv2xvivI+ENiZZE57OTjY7L6E7cl2wOrlygdKtdMn8PQNdd
         xpDd4ZiiQAkkJD11HUHhoJzZfQi8MeDE3XTjLpVmWjLqFz6Fc8dHd/ruUGg1R37RjoAJ
         3AWtY/MZKfqVWBWXeSVgBmOApwOkEfdn3vl7y6/pUxiQyRFBRluWOpNhmn01z5oJro9y
         IDzmDhM3R+p6OKYYoLjVQfj6NBUNd9m4f3oj4wKgOLYUCpQ86WTnV4uzPNNHVP52Fp5H
         E+tg==
X-Forwarded-Encrypted: i=1; AJvYcCU/e+EGMlHL1Mq2FxmBsc4up/0FJGuefyc2zPRl2vUHvunZGMkqYfGWYjtGDTWKTJgu5wT7qidSXg==@kvack.org
X-Gm-Message-State: AOJu0Yzdmvz1c5ei5aN5je9IBSgKnWyDG4LIjJLiEcljFGP4Kp6mh5pJ
	51vWow5DSykTk7LKWRQPOEdS4MpjHXtKAxnH/EGcunqIZ0LzvSAzg1wO3VNtKsg5kgix81WYcv4
	ZNOpAEpu3eQFWPfRjzElb3r1cSAM66G2rkx90toC/ieVLCG71nsxZ
X-Gm-Gg: ASbGnctGyLJHAPzlyntHbYM1lJgqo7WRiqSrUmm488ZSWTNRLg/aP1Y9WnCJdtAJD1E
	4/R9mhTZEaMF/k//YeJ9O/0bLoEhXGPLU2gHvT7uwdpwb1INuZeS+KUBHt9OuNfQeJ7/WGh2qAy
	jA2UrfnahjCiH//Z6gCCov5PshBl+AnDls1YMbRn/INaF3azFt/WS3HBvzeRiM3bW/IeG14mARf
	mjl9X539pbraULozYjBqDKl9EhwMN9YT3XUIBkomUJVDCj92y7C7l0WTts9PCCdaSQ4DCfRTPmy
	jaW/X14u0KPnjExmwhwCFLnOINg=
X-Google-Smtp-Source: AGHT+IF1FXVD37QbUsQ0Ik7oXHDWD0jOrlfrEIfFomFdjurHr8pgoEPacv+H7BJz2eBcQ5cFiqmqRanY3KfCqKHA/R8=
X-Received: by 2002:a05:622a:4d91:b0:4ee:56c0:712f with SMTP id
 d75a77b69052e-4f03ff60e91mr134665501cf.76.1765220882981; Mon, 08 Dec 2025
 11:08:02 -0800 (PST)
MIME-Version: 1.0
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
 <CAHk-=wgG3xqJn1=SVw-npsdwCRtyY=sYbLa7HFkmj_Q0U=vdHQ@mail.gmail.com>
 <5e5e24eb-6af9-464c-ab1e-f9ee55a05a24@linux.alibaba.com> <CAHk-=wgvMBRrcR=DzsRKcLdZpmg-kJz49D1CzafjrWj+BzAGiQ@mail.gmail.com>
 <f72b8316-ddae-466e-a72d-0df9960d6c82@linux.alibaba.com> <nrgonfemkkz2bnwfkpzycfbz3luspjm65dakyjt4e4nuawklbw@cw3jqnedbyjf>
In-Reply-To: <nrgonfemkkz2bnwfkpzycfbz3luspjm65dakyjt4e4nuawklbw@cw3jqnedbyjf>
From: Mark Fasheh <mark@fasheh.com>
Date: Mon, 8 Dec 2025 11:07:52 -0800
X-Gm-Features: AQt7F2q3dlmMzj7bH-szN3EmMIipF57sJYb2u4-9z5qtFRDR9mlHljT3ULZgYkg
Message-ID: <CAGe7X7kDBqTn_G458pAvDMJPw6GUjrZAow1DEkzZJiry+kNH1A@mail.gmail.com>
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
To: Heming Zhao <heming.zhao@suse.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Linus Torvalds <torvalds@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Dmitry Antipov <dmantipov@yandex.ru>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 113AF40003
X-Stat-Signature: mbfjo78twnrikgp8nxqe7mnqhogckft6
X-Rspam-User: 
X-HE-Tag: 1765220883-709309
X-HE-Meta: U2FsdGVkX1/SUrKtg+k6RT9+qbcA07LfYOLXzPOGAjF39rLbRwaSJalG8eNIfFnwgXlPy5hgdLR/nWVNfgFrabMkBYni08+gKfS0ILldzsON3yS6pI2aV9v0u+iKpekIQQObGxDtIHHmS91c5+EyOv0zo3W76YQ+vNa4HLxQZXwoyruBEa8WvgLRiNYP4MbhwzMjjNVdAcARudoaISEumIFx2rMFuaKEnvdOBCsYH2HGYmCrYiihWuV2nlfEuNCX0PGtC5crxwyYRZiNNXfYfsMmWdyyvMcpZxZ59cDr7UlNzu40te/x/wJ+nHWFItw5aP+7T2MxfkdkhenNFc/pv9YMpaLdujPtxnOq+nvR0mU2hgaOOMoKzy1Z4CSn7+Kq2pU2a0dqbzGCMH2zZHSkEWji1WrFgF6QAZZC/tLIbBbebUTZMbXu+T2cU6kbvjkZCAltBSoWS0T3rVccEqbVyxkupOPhfH/TWoZMUWgNQb0j/yYsAykbZthPlu6kwojvMhbKRtkjbWrNRBPVdHxjVqV+Sv7ofBM8IobEVlcJncy8zn4stlzmHvLgN+AT4gRODZLH+sMg+LpA83ovwCreXxbhTm41Fza6ayozAfAL1R8uFnY5CYMPTSQ4qsGuUqiyLrjSF8A97aY34RLYyHpK/SXToD51JnsZ24C9aIRPu/NjrV/FTbLaDJCAM5/4UU5KE8DUH/nkoxs4DOZ7XLztcogG5w6N1W2RdbwraV++0JtWFLNcbMte/UngFPlBs0qz2nRqrXZEUwVKDlmsKHxWgZAF60aECOhKNcl2oMuOYijjlNhBjQIBVxc3/YyS5xWc9K1dRrw3c1eN6YoPrQ0lxyd3/CpUJejvqBPDOctG2mc6YeW9CWnMvYT3mp4OB1BuOsxbHtAAufbAh7R6sMDnzfiFTIfrXGprXvt7IQ6vQji36P3cBzmRVTxqdgop7B0jQ2o1fkXkKp23doLrYvX
 cwAahCsr
 7uPNVPn8z6foxBMq8JULA0N17LL+Sn1iQ6EDtjD0lS7MOyZ1jpsZzgDTkkn7eBmIMmmv6W002fMhI0TMps6LVCuOB74hIPQ6Xbyvueu/C80Jc1pxKArDS4kxsWUAAqikQXmRhqQztVONRlZlRk/t9YrLlaIpqaVr3MBS8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 7, 2025 at 11:58=E2=80=AFPM Heming Zhao <heming.zhao@suse.com> =
wrote:
>
> On Mon, Dec 08, 2025 at 12:01:09PM +0800, Joseph Qi wrote:
> > It seems now new_xh->xh_count is 0. That's means, it is trying to add a
> > new entry and here 'last' is pointing the next free entry.
> > If so, the original code seems right.
> >
> > Heming, could you please verify this? I'm not familiar with this logic.=
..
> >
> > Thanks,
> > Joseph

Thanks Joseph and Heming for looking into this.


> In ocfs2_reflink_xattrs(), when preserve_security is false, the function =
sets
> 'args.xattr_reflinked'. IMUC, it means that if users want to preserve sec=
urity
> xattr items, the args.xattr_reflinked is NULL, this then results in
> ocfs2_reflink_xattr_header() not executing the cleanup jobs, (in the code=
 area
> defined by "if (args->xattr_reflinked && !args->xattr_reflinked(xe))").
>
> Regarding the clean jobs:
> - by default, it only handles three types:
>   OCFS2_XATTR_INDEX_[SECURITY|POSIX_ACL_ACCESS|POSIX_ACL_DEFAULT]
> - it cleans the first item and shifts forward the remaining items.
>
> It seems Linus' patch does not handle all cases. If new_xh->xh_count is 1=
,
> le16_add_cpu(&new_xh->xh_count, -1) makes it to 0, and it will miss the c=
leanup
> job.

It's been a while since I've look at Ocfs2 xattr so take what I say
with a grain of salt :)

That said, I agree that the cleanup code looks suspect. I think the
answer is to always memset the entry that we just removed even when
xh_count becomes zero.

Thanks,
  --Mark

