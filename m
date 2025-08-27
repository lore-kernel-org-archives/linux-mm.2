Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479D5CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 872836B01AE; Wed, 27 Aug 2025 09:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8236A6B01B1; Wed, 27 Aug 2025 09:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739466B01B3; Wed, 27 Aug 2025 09:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61D966B01AE
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:16:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9524849B6
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:07:00 +0000 (UTC)
X-FDA: 83822562600.16.6EFDE04
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5914714001F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:06:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=LwpRKMID;
	spf=pass (imf09.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756300018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvREMMUGX4DDLPmaa03a7mYhWcIU01kBarCsM6l7Nu4=;
	b=Qyl+uQURAOFj7EX0wrcGRaXLbCuJ25aIAh92etUkyiSBnPf/dDBP3d2PlCvfiOlOaDEegf
	M2tRvdSu13uxjYiT/FyBfzsiHFMCi1pJESbmM8zE+FX8mQcDRXnYWXrREzy4NK4QB24/IT
	QfztlomoyGOCp3VEB+qy7Sf4TCveZfM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=LwpRKMID;
	spf=pass (imf09.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756300018; a=rsa-sha256;
	cv=none;
	b=y6j+s9zjetuvvCNpobC+ZC2nXgJlrcxAhOHnhJXg7PsAhPYeNX4Mcjkr9rQw1FEUNgyhmV
	6B9t/1bYK7uT2BVcFxKhtE4LmCvSXBmehFI+zBDM/gmkOU9ngBqPX8fiBJN43ZdTIcP6Gq
	GPPkdQq2AYG1tCE+J8lJNkZXxA3/HOc=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb7347e09so1174376566b.0
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756300016; x=1756904816; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gvREMMUGX4DDLPmaa03a7mYhWcIU01kBarCsM6l7Nu4=;
        b=LwpRKMIDJkJDcd9K9k56t+xWda523BuNTYJd3m64Y+hjRehnGHAkpC4pHnQU/GgLrr
         7T7HORwWc/EML2N5d6qW0D+x43sYnpDt2ojriX4x572F0SHSfKED6Dn9dd1/yUbtdKrG
         MQPgEVhUcMBM8gWtlg8f/LcX1TejkcGLrepzjaAbXxhAh9H5Pti1+ppKQnRoFwOHBXWm
         i2NF3dbSx+oEj2XaL5uwhD2QQE5a1GLSUQMrUqCEQSsg45Ltyb2cWSs+AFV6gUX1Gc5Q
         hD9lUyxodtBbkQi6I2rIVuzwPljs+RKX8D6c15DNJ0jIQkOUKwYq8bVYW/tuf3tMoEvk
         xLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756300016; x=1756904816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gvREMMUGX4DDLPmaa03a7mYhWcIU01kBarCsM6l7Nu4=;
        b=V5SLQ6qyESxw6wFUIntjseacRWCo71xcUeFlQ59qwgp0hpB2gJfwzRQvFRwuZORRQh
         69aLkcnzhB2nbjBAOMETRT9mUt+N6Tc0K1DbOuGUrwAjQ5vW2hRz+Pf7dddyy7zrJcft
         FEwjbsKrbCAkVpKmxCfOFApFDlDAeoMf1g42AMnsnmjUZipIyHb0HPDOhezEKRAsSFJ2
         Ss4K7h1yvTLnLhWkPLRsLgD9KkjvhDCJwiCorTGnm8AMBeDFECU55nT/Ek3IoHVAHdOA
         N40AQ3Q/43BrH5BP86+/bpmu/f6BqzHti9idvmTHctOeeAYW+cSV2lFzf+bIJhAXf4hb
         3iAg==
X-Forwarded-Encrypted: i=1; AJvYcCW0MknN/Tu/4wMOSfSGv7lNUlGUWz+2S/FsmmcC+0DYIKyPzup3qDmv2cXQTwbInTStDy+SGTRrMQ==@kvack.org
X-Gm-Message-State: AOJu0YwFwVcvp0/VnfQ5LPQp0xpfSxGLG/bnZdWi4aMM4sQxYm2CunGL
	Vo74lHIdd4y2oAZVygn7wd3wXAsNVC12TwOOMeyFgwc2JKSnXcUjSJHLlaFvdQTxEh+eKpyeSx/
	HYShbDk+UoDZAg/5Z8AUTsx4DPMJTz9SGlg5vopVgaQ==
X-Gm-Gg: ASbGnct/9xUkj9/j4htUTgIhHCMxE2ialnNmU6mH3ST9F+/nOnCsctEeQUI4cJ+XNg8
	UCACsIfJPSDYdcTe+TudFMjtTZ82SoQAs0hqSN+FcNKCBHI2+lVWVaf6cVmW8Vl3wVwmo8pRJmx
	EDnRl7M33sLyDmfZwXFQTMPVuaeCWSVRjqye6aDWm2PXvIbRjpXFEO6QhZDHcdttxQoKyLOQ8ah
	XpOtP6CbGYZUMtkAVMSkcRLxQzAue4DqjM=
X-Google-Smtp-Source: AGHT+IGcS2N5xEv+uacw/lgkOH8CRCWcPBIObSa2NzqVcxO43YGBpA+T+PSuO6/+E8wHrtpzJhJ0Nnk1Cw52ryvCxD4=
X-Received: by 2002:a17:906:ca48:b0:afe:8d39:41f8 with SMTP id
 a640c23a62f3a-afe8d3944d2mr748684266b.40.1756300016515; Wed, 27 Aug 2025
 06:06:56 -0700 (PDT)
MIME-Version: 1.0
References: <20250826231626.218675-1-max.kellermann@ionos.com>
 <20250826185515.7fbe1821713195b170ac1b31@linux-foundation.org>
 <CAKPOu+9wz9g0VuYDPiNDYdaGG-gdK86h1gGSCmVPsC2a5f-GPA@mail.gmail.com>
 <e5783c3d-7eeb-41d9-9fe7-730155f9bf17@redhat.com> <CAKPOu+_8_gfko=Sh-YKpbgcMy0aJB=m9yrC5JJKEZm=yeYPOgA@mail.gmail.com>
 <11a5d391-3a13-4376-98f1-34b529d3c583@redhat.com>
In-Reply-To: <11a5d391-3a13-4376-98f1-34b529d3c583@redhat.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 27 Aug 2025 15:06:43 +0200
X-Gm-Features: Ac12FXwwckjBhLQ7o_PMRpGnjCBD6ur9uuZ01YuxV6JXk5dizy4yroOgpwkCCEU
Message-ID: <CAKPOu+9j5+w6ydvygdWnryZM24AFPSVJB_21VH8Odi_xdrNksg@mail.gmail.com>
Subject: Re: [PATCH 1/2] huge_mm.h: is_huge_zero_folio(NULL) should return false
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, chrisl@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5914714001F
X-Rspam-User: 
X-Stat-Signature: p8ypy6857y7hhjc4iq4ic6wttxq9d5sg
X-Rspamd-Server: rspam09
X-HE-Tag: 1756300018-878330
X-HE-Meta: U2FsdGVkX18JHiTv0m+a1VKRmJNXkRDIeCaBmL5WSSVux3bzsFyddj/agkOklJxArparJs4HfPnjDcSZyBQRPEAWRlmrm3vXE5RRzXy6g1ACB0reFhKKT4lzHW0izwQ8K7ui687f7xNTwe7k4nlxH8Yyv3GQhAIM8ycIlDGD/6M6LzzMavwCvuEnSVUxxn+PodRVIFtwJb5rW8iuADyqTvSF4VPJL0G25B/dHN7gbyYtQXzrI/GD0LeCZFZQbMkdKvbF9Kee/zhkYXCAxj+FiOgMu2HD5YfxDGUIz3QEqjLNpYw5L2Vl2YibNUXtRDOIuPFCgddOJBfDGe2eedGbVEZi1ilsmXATfOin8QkpsRAtSORdcwpgv8ELKHLXJDzNvazWfIgA+IpzoO899IWBR6JRvPzN7wOj1pcHash4oYM2aM+Osx4SoqmlbpZpMsgwtfORiRcjfeEErCwgcMuiUkZp4RgqISP2WAdKd+JxXtjtmxLkTg8wzyoPPjhwdIc6hIhvVgmkYu2mKCjWFgfCIFzDlIUOWxHdUAVbBC4HCiGxN9kuI0MZAWaChMYriq8Vr/iZtY1B1NPALI4QwT9+X8elSdOHyAVLhMUVxfa6AFiL93TntQLuMuOAYhjx7+c0TYd5YftKvIDBVGyVxCqpI2BzJ8QUoTT8BAmuuOo0M2BEcGGASgFNNsQh8lhw0FBUHyXn3Nmxf9ESdXUa5iLZDPy0Xkl5gLb/GZTRvlD3Attav1hWQJpYI+VCxoIPuHKMEI05oemH3Tvinu1Fx/gpl8bRnR9hwWMSkdibBSL6QuWhfc1rkwTC/txud54Nyenl9XnQOZMpXBMIw2elNHDBjB0pTri/znaa2S0P7s9DaFWAN/Z+CXzjXAap2AQj5wdYTQH/lP+b2AvdqhX98mnCaESkLLDbTsKZequ/0bQX8ZwmgtW6clRrrLoDpzXIRnV48GQQJL5KkfLWGCgKwtD
 t7J8r1Fn
 B2GIWpxlNJv6bITmap6sIxX6TkpYIja9dkvH8S7NaMh4EjUf+dDYIXZz+4O/AKU9HrcwNibpLTlDH6i8FrsdOxWVXIvSR/kg31S41wDxvd15ki6w42LKv2Yei8DJs/MmCaMg+JWdOgxeKtbIUaJ4hnR+cEdQNFd/PGTbc8xtxrZ+HGh1zInZfsFUmdV9ozEYDBhVEg4Ommvj1TdFhU/FqIkuqngjGt8u0eWGnWLTvjAvl8v7y7lBqU7nvGVFrtsr6HeAK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 1:56=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
> > This patch isn't about the function parameter but about the global
> > variable being NULL.
> > (Don't mix up with my other patch.)
>
> Huh?

Oh, I see the misunderstanding. You are right here, yes my patch is
indeed about passing NULL to is_huge_zero_folio(). My previous reply
was confusing.

But you were replying to a sub-thread by Andrew who questioned whether
a call is_huge_zero_folio() is legal at all before the huge zero folio
has been created.
The question I asked Andrew, which you replied to, was not about
passing NULL to is_huge_zero_folio(), but about whether the call to
is_huge_zero_folio() is legal at all, no matter which parameter value.

I agree with you that is_huge_zero_folio(NULL) should not be legal and
makes no sense. It's a bug somewhere in the caller.
But I saw that the current implementation effectively (randomly) hides
a bug in another part of the kernel (=3D Ceph), one that I'd rather like
to be visible (and get fixed). And that is the point of my patch, and
is the reason why I chose to have the additional debug-only code
inside an #ifdef - I don't want normal users to pay the price for a
debugging feature, no matter how small the price.

David, what is your opinion here?

- leave it as it is; is_huge_zero_folio(NULL) may randomly return true
or false (=3D reject this patch)
- add the huge_zero_folio=3D=3DNULL check, but guarded with #ifdef DEBUG
(=3D this patch)
- add the huge_zero_folio=3D=3DNULL check unconditionally (suggested by Zi =
Yan)

And do you agree with Andrew that calling is_huge_zero_folio() should
only be legal if huge_zero_folio!=3DNULL?

Max

