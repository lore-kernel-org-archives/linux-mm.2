Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D504F106B504
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 21:09:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10BDD6B0088; Wed, 25 Mar 2026 17:09:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BD1F6B0089; Wed, 25 Mar 2026 17:09:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEDF86B008A; Wed, 25 Mar 2026 17:09:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB0B06B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 17:09:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA138E06A7
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:09:37 +0000 (UTC)
X-FDA: 84585826794.15.653C5EC
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8D0E5A0013
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:09:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WZz2Afzr;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774472975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VhIqM8zGhc+m76yKiaO60y31unY6JeTZ44Jk2qvOic=;
	b=1DiJXcCAC7HAGNOHqOFMr+v0QuLm5wrhxPK4R9t5FjPcAwOALeTJhCi2lzy+R1W505SPfh
	wIglHTQz0gfdS87Tf8XpgFGLylslqZOYXjpQc9vv3USpPTUuO6yJLwt3UnK0hdtueXo1sX
	Qg/qU2tYjifoxrHVe48LQFME5jVrN1c=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WZz2Afzr;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774472975; a=rsa-sha256;
	cv=pass;
	b=PkRMRZy5LdrlofOt7BNQ2DWGnwazwPw4mLXREmsHAOL8hwzEfiOVV6t1MP108j+rErZ5k/
	AaHAtL9dRyHdHRwFssDYN2Zhoy0CZGijy+IOlC5YjAC22jTAqKFwNYesKx4aAxWeUNMMw2
	ilW6tsWw44gLuQkZDa9GDF17YuUPg0g=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b97ed4ad579so43446066b.3
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:09:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774472974; cv=none;
        d=google.com; s=arc-20240605;
        b=CUyxzkpC2cyzu61uetII7DAda6jhITRVJg4oIJ+TLwMWxSY1fKEFUPoSOJ+IC+/U8v
         J4qZER+iBnJv8MB5QemM+OGrI2O/uaJPttoOns5jnmw7TF9omIxL0veYwosDw2DJaAH6
         sbGI2LzbkybLh1MBJ/HcR+iCejJ8YM0DRwab/I/Io1obQR9q5BM7Z3tiz5b9n6ZfqZfP
         MDDvNjCPwwPTId6ZtbGI88hyoSzdih8VXZMZrkxGEMchdNnr3ofS2SdABuQy1vb4QiiD
         5RiFSllz7qmKmZ+o3MpSrYqTbxfw/QFvJE2DpVb3g1/cTiq+orVCRHO49QkR+MQre33W
         iVFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+VhIqM8zGhc+m76yKiaO60y31unY6JeTZ44Jk2qvOic=;
        fh=IOVLKlg7QFPNn+ykdKKXk5D7/Ff1pUXxxxup2pfBLGw=;
        b=RMoZ9sU8NsafvLNAZDqI5DwAAYhbT49tB9QPu2EIZEAcgVhRLSmp31Oy8dmTDxQiSP
         febSdAdSJSPNHbNKSZ6joA2vvQID3Ay8aT/4Jtdc/Zbz6OvKZBueHJG7J7Qc+9QDAS+3
         i8UJopdH/cv14J08tB4qNdECnKYg/D1UCOAcSwNkTol8B+HG6JLsirRsN79nlGluWy9M
         k9lYzV2U55NaSykYCIVKqqO6k9xktVUMuGzWk8qhFkwJBZzqz5tNp24oZDGjkzMaLq/y
         kda2v8C6+OA3u5ULK8ppOVYL6bA7XUJ0Xg1DERUl503wfptRQRFfO8e5t3QWnXV2GpCr
         hWlA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774472974; x=1775077774; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+VhIqM8zGhc+m76yKiaO60y31unY6JeTZ44Jk2qvOic=;
        b=WZz2AfzrM8aDuLTxUMmaPPw+QP0fUw8beIeOYWE5IOHWaAzXwgknQXIsxP5hyvdyMQ
         sBUOutZwy2s9Ek32kNnraP56tspLHd758WaR/DrOr4Z68HHa8zftflp/uyz1DRC7iYSc
         +Mi/YTBLxglJITG/APLxCOOC4fCzdCzBDBSNmozc2tW9XwFD8sF8oapkvblnrIcaceVl
         vw1psG+kA1gT1fI3pQrsKohg7h6t4+OnE+krtwhLF/GP3ewmreRI7xybY7ge426hoAcw
         z63xhMAMsf5WQzO6uVDK+JMpfJX8Rk44lUVKqZtjQ3lVmJn0cwPMeqYSR06TsHcnWn7x
         l5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774472974; x=1775077774;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+VhIqM8zGhc+m76yKiaO60y31unY6JeTZ44Jk2qvOic=;
        b=dtIB/L4gD+9aPFXB8oH/L7x4xNqu/7lPYgjhpvHRCFy2QYeTCosOYE8zhkwrXedO8n
         P01KOEKRAP4J2YCeqUscGSk3uY/rO9trLy326B1kx6PCh90Pf1XOuhmkgikayV27356t
         K3kla1HMouzGqFtvIxDgZD4WNEmIF7vRsc5/MIyigNiIKUlj5H5T+l0pofz2tGv7cp7r
         zSGL5u3cHM24vqt24iKkydsTB4VFgu3+/W6Hpm5jBDKNmuPURJLEJHnCbRIgntFhQSNp
         jbqUR58NengsWCAgpayOWgdAvgxW5ZYfE6mKTuT/nbjs2D5/cajsRLi50I6iUkMRP1a9
         F4kA==
X-Forwarded-Encrypted: i=1; AJvYcCUiseDTDvzdtzi36gJVS3Ra5MIkRXPNV+0VpohhJFXqUmXFK0u1DTMJXorERFogiyGNP5dSe+ugsQ==@kvack.org
X-Gm-Message-State: AOJu0YxLxYxyv/9/F8Cx4IZZyCzkNV/CrnGpAolNYELgtx8aNSM9AB4L
	QZsJKHFGEaoxKmClbm40exYuCPZRpyV0KJn5vP/a/sx/5MvYrxhmxHVQxkFUQwL0OXBln7UaTuf
	qDsUbmQ5lSO3QheLWz5/CVbhZTdxEX6vk6ILVJyRdYA==
X-Gm-Gg: ATEYQzwksB3X/9x1BSoVDvMwrEORUeXys/omLh8xSoYmkFlEMKIvDnhPvX24sSMd9m8
	aJrdoc+GRo0rNoo759w85Hx/w9Ln1eKfbCnC5Su2t8xn2F9CtJgyB/I+0uNZjRjR2SqJH4AWDIi
	rogDCp2eZ4AaoxupC6yJy6WC2OIVcQNe7W/xa8PrZSYd8psnc8k/3kUoNhTdVyTKBGJJk/tH3jr
	ujaFsG8YAPX9FRklw1tfTS4k6lLOvAsw8qEwJ3i58/GrpPlJajYtM1JQx0WzgWwH0UzA2CnefJf
	6i9rue4EE+8622NDWqA71amfkzrsPc9CD+3r+w==
X-Received: by 2002:a17:907:806:b0:b96:dec7:5209 with SMTP id
 a640c23a62f3a-b9a3f1a00b7mr371393666b.17.1774472973704; Wed, 25 Mar 2026
 14:09:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260325182026.467307-1-pasha.tatashin@soleen.com>
 <20260325182026.467307-2-pasha.tatashin@soleen.com> <2vxzikajacgc.fsf@kernel.org>
 <CALzav=eybgJwMQEtvSi2bUv8u7cic6d45r4wFZdZiKFFrrLJfQ@mail.gmail.com>
In-Reply-To: <CALzav=eybgJwMQEtvSi2bUv8u7cic6d45r4wFZdZiKFFrrLJfQ@mail.gmail.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 25 Mar 2026 17:08:57 -0400
X-Gm-Features: AQROBzAuEXVQtKItis6pRa3obLju-DQMgEMDY80SPeEiiuzBk0dpu4-udbGQyUk
Message-ID: <CA+CK2bBpa8ZnxPdsPCRCAiPeHUbqQ3TNjHTGU2eN_BGqqX2Y1Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] liveupdate: prevent double management of files
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, linux-kselftest@vger.kernel.org, rppt@kernel.org, 
	shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8D0E5A0013
X-Stat-Signature: kwnghqaa4k51iccsw3tane8ryo98txhn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774472975-20571
X-HE-Meta: U2FsdGVkX18ZYBSHfUfBWoZeIPQmxV2MMc60+EfNe8RcK7QHCFy0oOxpslr5s9B9uicqQajvy7oQ8VTAB8+uhRHUt70WXOHDpm6AWJXKjgd/30xo8xco1BJ4Y2LsAL5mC59C4pjvrW/vL0IQhyQG3HmYuxYy7vpgx6drcUyfDxV+n9D3X1RnWJ3E/145Gdi3jS/f5pc+QFBdn8VZQYyKmcfDEnC3sQl178w6L5BTixX1v28QEo0Le8sGXyd6S2j9CpJwltWIREoIRfdS2gyji6qJmUavfU4L0jC3l6s4yjyzdciC1zjhUwdr8IbbXziQnc7yR+aMM7TW7RFlm/bfeCpjNrqumtw+WFI+abi+mlVYcC6hpf2uyEp10eKFcFpTCYdVMbJUzwvmZMOGXh0Z9CXcww3b0/VDHDzgqvoFl+UMzC6RxLpZqE/azrSv1C1QCvh+ZXQctb5TTM4l16JBAIIvqzIIENt45YwmnkAZN9WP0wE1eVLQo7GNcuLh+iPJ0mZvTlzePPWbSr00wGQakRPWqjouhPo5ogJmuUqOJtSxf3KEyqs5e6fyi4o3wFFelQKjgfu+verGBgeeVE3uCXTlB6xQn/Qcg6voGfHoREGv04y7Cyq5D/+WNSXIc9gkGnvd9WO+KD/o2+AYm0B+StoSt7ArvWvrvsuqyPVRk18HsyUP3JVAoCKoIQuzumRZZks65HQzmIwacmCODTCQK5sW6iDSPrlMpw7D+P+uC+ZrxP174h2bUIsKcJ72lu7KlMAmECl4fIHWqiH8svrCu6jCxnuHkwg2oQEWRgbdYzIVuH4kjhz0AGnRoVoQvhGDHw1zQzMh0KctzB4k/ZH6QFOEBTRPxQqpZ+J1IthjueoKA7mj8zJh+eQ4FZLx3Y9nQ6nXq0DfSvZRZEL/7x1KaFXILidYISb0lz94J+WyH4BQnMOqfUtQlV1GD2Wi/cba2Z1hhKWTAHhieqiGFQI
 q09fdMze
 yMH0dVV2YE6lS1XfFkmOUclU5U1KwOCLWNMwBl9jGDg8CDLqLo5a2cRTWW1MuczeQwHpbVjr1QshA92NCS2Tq7da7ob8B6ig1PlL2I0AposXplmnKNaPl2FHYRyo53lDamsyj5qdQAGuE/jlrCCfMLkAnoo8sKkan27whENCocxe88FVpT/WYzCI8KZAcHQFuRYwnsWdaL+o9bCjNIplWHYlwES8byeS4aEyS38wADTVWJ3t/CvxPupyvxmJ7oFsS1+tAAUCgMGVkysqG13736OsJcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 4:34=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Wed, Mar 25, 2026 at 1:20=E2=80=AFPM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>
> > For memfd and hugetlb at least, we serialize the _inode_ not the file.
> > The inode has the contents that we care to preserve.
> >
> > So if two FDs point to the same inode, this will break. You can do this
> > by first creating a memfd and then by opening "/proc/self/fd/<fd>". The=
n
> > you would be able to trigger the preservation twice, causing all sorts
> > of problems. Same on the retrieve side.

Hm.

>
> > So unless I am missing something, I don't think this approach will work=
.
> > As much as I hate to suggest it, I think we need to move this check to
> > each caller so they can find out the object they need to serialize and
> > check if it already is.
>
> I think LUO can still enforce that the file is not preserved twice.
> HugeTLB and memfd's preserve() functions just need to also check that
> the associated inode has not already been preserved?

For memfd/hugetlbs the true state is in inode
For vfio/kvm the shared anonymous inode is just a dummy wrapper, and
the true state is in file->private_data.

I wonder if we could use the XArray to track inodes for standard
files, but track the struct file itself for anonymous files (we would
need a new function from FS that allows us to determine if "struct
file" has anonymous inode or not).

Pasha

