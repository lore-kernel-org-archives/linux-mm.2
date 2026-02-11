Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7F3EB5948
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 01:09:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398356B0005; Tue, 10 Feb 2026 20:09:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345DB6B0089; Tue, 10 Feb 2026 20:09:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227956B008A; Tue, 10 Feb 2026 20:09:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10BB76B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 20:09:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B01E41C0A4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:09:00 +0000 (UTC)
X-FDA: 84430391640.09.2FBF859
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id BC643160002
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 01:08:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BNgbnRIE;
	spf=pass (imf08.hostedemail.com: domain of avagin@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770772138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5wIzv3gxAepMuK2aN8/ovNvhOsuPkbIqgztuEoLqQM=;
	b=4iGLoSfhqfC4i5KDuMmyfj+VdrIm65iU7ys8DJvtcMpnRtnscbFGmUf29mQf3l3G9ETw7Q
	/uhwkh6p1gphPzHOtvJPRttv3jv2QuaYVLrTKjUA2g6HGYQ/RWPwg/eh1bcaNsmgQJ54sW
	OBpsX/IWmHxPijf18IoqhbETMUmDBW0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BNgbnRIE;
	spf=pass (imf08.hostedemail.com: domain of avagin@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770772138; a=rsa-sha256;
	cv=pass;
	b=yLlPLq6iZfV+kZ6JNJkwDbmM6LA1oMaZ+s6ji7OI//FNhDtatNkhfgB+h/RKt6/htRk/4t
	0kJvMQXDoVbxmUXKbMTUSZE6/nTmNWlw5Li/jG3Q2OyTZLboWZqJZiIad9DQ17AZo4pg9m
	4DKtX1Gxme9s/VcGG+bCwBlXYSnK3Ww=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5014b5d8551so135331cf.0
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 17:08:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770772138; cv=none;
        d=google.com; s=arc-20240605;
        b=UQ+W7/TxXqEJ24RLUPIycq5G7/dc4kcrIDqcj0Y4cau+N1IPvQdr20EXQYPiMAf0DA
         +JAsfKqIDOGqUyP/0vs91JxbYpvtfdJl7ckFbQ8Mct4oejHzZl6jJQx/UXLqw3C1eZq8
         nrSd5/0i85kOG+IEuHi25pSkxwebkktpaCVX/VSVnCIhFPfSdXJTYWsF7qlPX862iZgS
         B+aPQ8qAhPAW6OrxVXm7RYKFbzSgqkaOPMAQDK5FfGH8aMmmgHS1qTG/gsn/ITV44hpa
         mi+sKLjs2w/juKOIjHMjHXd6wALCK9VdHILHdLWmEBBvAohICS+OfX9/p4miSYTOCyj4
         vkEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t5wIzv3gxAepMuK2aN8/ovNvhOsuPkbIqgztuEoLqQM=;
        fh=xB0KpGnFfM982Xj/nIjQRCzeWbzTTwRjxg6fAC87+aU=;
        b=cy12g7BRpiYKhJee1UFL/ThiUmHg2KJcsOycT+mP+wST05+p+71OfHt2rABRg/T1fi
         6PDh2FLObioChY1MO4SwLKuEk7tLsnmYKDE9XWGJDSeTqxuHjhKQ4xdrU5Mjx6ZG/ZPR
         426LXRTWebA8whE+rS0F8d/NO9QYt1EBKHsySrBllPzMEkKD4AQTuIJIM+zOaGIqv15C
         zKhqDqSl/HEd3u5vW5wcbZJlKY90MlsvDoW6SREPAnJPrOiThOQTVnbP/3xtVEo5sLtz
         vBZ7mCSycaaP/eVijghJo4WgzXRsIwiPl05IVR7QryPMwX95LkFSfiMBThwt2CgAywjV
         qkPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770772138; x=1771376938; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5wIzv3gxAepMuK2aN8/ovNvhOsuPkbIqgztuEoLqQM=;
        b=BNgbnRIEqdvG3xWEPqV/99aqOqAD0ZxfcBg+So7FOkeqgV5IEB2nREV+On15qarcCZ
         F42nRS8gdSjlBcED7WjSJ0He9//NSJnfLkForQ3yK/CeOj2nu0JqdJ1nMXEUM864B8gU
         xHiTb8BHjpeymQf8a7c3gU72YezRhpEnOAVsD9mG6FTZPFw1MfwMqNCC9ROZteaLTcRM
         j7myzlmLq7ml80745/VePDROnPjxIYuLCIhheDSe/3ANHpcZM/bqM8c4X6NLgQtrTjEA
         wT87Qi3YQAHlka6T6FdHvqG+poWY3EHO0g/8CBObBQrqH80pS0E2JprdKFj3HEfGGgJ+
         N5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770772138; x=1771376938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t5wIzv3gxAepMuK2aN8/ovNvhOsuPkbIqgztuEoLqQM=;
        b=HwNoMWMk6CpmRJI+xB9sCzsIoCYvyxgCR//ibDTa+xXjTZyF2hOTR6QIvdarKwAOBh
         M1jBKjK3rGbSBLK++oSJdzR/5Gbf1mB72dFu9Lkq/TxNZntZI3gkF+Jegkfqq1zb1ICl
         5cc2CVkDfCqbkwHBpO5YeucMx2+Xgcsc3UbDaNiMlJXPJTf8O5lFf6ZA2Bg6DktN3Tbl
         W6JMkbivnPKuASAtuJ4kzab0rU/H5xB9lmHsZU6aHQFe+Rpdgc5Ygn49JtF1D2P2sTNV
         LUQf17y65EhXOpKcWmJx7hS2VENYlCqYTO/TRXkQXSQ6wzmRoyCtrjkTm2u2wGDSg+Sy
         Eaeg==
X-Forwarded-Encrypted: i=1; AJvYcCXySfd/9BgF5bMMjfzXPGz7qHMoxsNQLT3YWFP8kU0VLb3e0VgG2V/3J2VNsWAN0pnQs9ryuSJYng==@kvack.org
X-Gm-Message-State: AOJu0YzVwHXyYatkY3PRk8XVf5ZD6tvWcKkZd2rQ6G+QE3IYasnsNhPE
	+/vshNxL/q5FXoZNg4IUiau7BdlhsPVGw6T7praLWIYpByV5ciWPiFwVk+HVzG27DfhhqBw5Kxa
	rdqFYxE8+GSCmrxIwYQNPbp8J2FS7LSPzs/TsyR78
X-Gm-Gg: AZuq6aJUXxeeWCNnfibH0SeKmju848xyzGms1mr+fugJbOtx5+Hsraptq3ZxsCtEn7k
	57lojOfAXLFZXGqkwWSXlHnl9ISUGbmfSSzZ5OHjuqjRBHTlb0mWdE/9lzyWvvd2AayEn+ctIlm
	reuvEuHXYETGOsAG/0gliVTMOeG2gnY3qnHVlZCyNzHzheo8a8i7mpjyPFbgRQmg+odB/jy1D0/
	DjrLRuEl8OCO1kWJO7ExwzoxiAONZ9TRdT4D4mt5N0SMUHfggT7hPaDA6lr5s6Zot+HKRxu8dbD
	iG5DxTU=
X-Received: by 2002:a05:622a:118d:b0:4ff:bffa:d9e4 with SMTP id
 d75a77b69052e-506827666e1mr3331941cf.13.1770772137161; Tue, 10 Feb 2026
 17:08:57 -0800 (PST)
MIME-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com> <20260209190605.1564597-4-avagin@google.com>
 <CAJqdLrqFJm5s4qgczWUi50muoMbUm7tbDZ4vTp=3ktEDYoi7wA@mail.gmail.com>
In-Reply-To: <CAJqdLrqFJm5s4qgczWUi50muoMbUm7tbDZ4vTp=3ktEDYoi7wA@mail.gmail.com>
From: Andrei Vagin <avagin@google.com>
Date: Tue, 10 Feb 2026 17:08:46 -0800
X-Gm-Features: AZwV_QjzYmM-WZIpZJo7jxpdR0avYlD7_PH6H5p6BAaV9nV0wPBlcHA2v8Of8Jw
Message-ID: <CAEWA0a6x+RfcBpOrcJuWaFcZCPAbBV2uDWHfQbaCMv8vBHeZEg@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
To: Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BC643160002
X-Rspamd-Server: rspam07
X-Stat-Signature: gj86mf6sncf967mpdx8ocwwuk4xrggp5
X-HE-Tag: 1770772138-128064
X-HE-Meta: U2FsdGVkX1+k+wRhADf/VR5B7YC+h02KNvlK5DMtdMfC5DVgu1dQ7OYyaDWyvgxx+1joQJRaTfGIc8okEX4ODbExABhToLeTqHg3HRxBjLj/uabgXycxKC12/Ffy6pzyJJ5aHaF9YuLwj5S+x8wU7Fwem8Qwk4S80X6ulvhfwVc8OifV2IS+mRl48fJ+2W54Vc5/zXvz9BeIjvOxvtO+5rg4MzPDJWerq/X4kgVhbl44ZMdk06pz/iMCIN8RMRH1Oh/StBOpKUdP3uJohnDzmvUD6p8zQ5BNfm/HI/crNUX/qxB2+w2xyEmSJes+vCYJqee54XWIGpdG4eHFodXeqIFxvu3ygAk1Pz2yE/rgfnMo47wfHAKLypoH9RQ3ShjEzE7arYn2Uj3ABi+D/jKWtjGmiHC3EDVzIF/4dLum/hZLnqUMQcGHbYjQQP68p4iAPx86FzOZx8wLhHOqA0mJ4Ig3eUZD4EzqxefcCEUdSPiSGCmTgU8t18tltTa/Z3yoH8Mr6ernhemcz0ekpbuZi0RzGrWKmbPDW8FKQ0GAB7ZKzlK5sgkVeSwpjBjAXB7Pu8xA4Saef4FpBDq/7cp5vu0G/ZFFyc1DIsQtyG3mD+kp+Ss2kjROz3CnQJCf73fxatOyVqU9DVT2kqfMpLw5uelBnX5ep8xZtQmT3E5aV6JD7Q67cZ1xtbwjCo20B7H6Nv2zynMI1d9IaMGrlHRsuBWnUwQTgePwgEyvCYy7XYc6wsWQqeIcCOUQTHeyGnHDDeSM4N9UcrYmd/EnO94aLXkunWKofQpfM9hMfFeqPQhSyGLJ5lTsvkp9oKX0N2vJyK0NkQ1chXrRfhzxMWLhraiUu0AwgCLOh+jxPYdngndtyWVMue9Rh/AVA0qXcjYNfURuX/6cM2YbtnyJEfu65dMPHME7bFWiMG0nLkf46obTVQbRUqsPWRvKeQHm4e+iJJ1D1a2F+sy2mXSm8eH
 ansKCwLE
 kgto/Eubl+T81q/YYta5DZuFqs9a0IjyrSpvmNtv1KGzj7Aws4amLpycnPCuQhSY0whddLfOxTWNQl0YuDBWSIGw9ZW11e3VEvRQEr6PI7PUKiOjOCzZnfakwTEnVPHiDwJdlEuITZC+rtyCPsrEj7Ma6+HT6fMg24I663t7PCNo+YDdbDPNPOjgSk73Dklbl4t1rotDJXG1HNySZu8ixx/Md+HaXDpO+r6ZSwIu/UqycgZQYUDM+QAl160Ti06Q4VpPtFv2Rl/ze84Bz6zt/fVrwHQ6uUwp/7OwcOG7JhyjHxCv6GbUlmblhpPwfN7EX8l2tqb9nKzzMdW1zY4qFDuv5hsUmytTr6NcEi7ykPBXyGQje4C6LEm+IAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 12:36=E2=80=AFPM Alexander Mikhalitsyn
<alexander@mihalicyn.com> wrote:
>

....

> >  static const struct file_operations proc_auxv_operations =3D {
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 0091315643de..c0a3dd94df22 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1104,8 +1104,13 @@ static struct mm_struct *mm_init(struct mm_struc=
t *mm, struct task_struct *p,
> >                 __mm_flags_overwrite_word(mm, mmf_init_legacy_flags(fla=
gs));
> >                 mm->def_flags =3D current->mm->def_flags & VM_INIT_DEF_=
MASK;
> >
> > -               if (mm_flags_test(MMF_USER_HWCAP, current->mm))
> > +               if (mm_flags_test(MMF_USER_HWCAP, current->mm)) {
> > +                       spin_lock(&current->mm->arg_lock);
> >                         mm_flags_set(MMF_USER_HWCAP, mm);
> > +                       memcpy(mm->saved_auxv, current->mm->saved_auxv,
> > +                              sizeof(mm->saved_auxv));
>
> nit: I was looking for this memcpy(mm->saved_auxv,
> current->mm->saved_auxv, sizeof(mm->saved_auxv)) while reviewing
> a previous patch. Shouldn't it be there?
>

No, it should not. dup_mm copies the contents of the old mm to the new one
immediately after allocation, but it does so without holding any locks.

Thanks,
Andrei

