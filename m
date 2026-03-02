Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F08BE9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167CD6B0092; Mon,  2 Mar 2026 07:17:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145656B0093; Mon,  2 Mar 2026 07:17:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 051616B0095; Mon,  2 Mar 2026 07:17:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E57466B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:17:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E9E613C139
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:17:57 +0000 (UTC)
X-FDA: 84501024594.10.4B430A0
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8BA9C180008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:17:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hnrSL1lU;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772453875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rfvGQOFclF/AK5TYJX+Lve8Q4AghDs9tcQCHmYbQIc=;
	b=Dqg91v6B3urIfcGJYKmIlMdjL4BMBRotdBNi2pIABJeb5FiyY8UeT+2FOsLVItFvZIZJxt
	KBh8/4yalKb0YvpQwrbE2Uody1ZE+eWJDHL3nqRAgi3K6lODx9fs6JknR4ZjSZQihxoAi3
	ZS8CVT2wIV9Qp46NrEjkwb0rnOnCeB8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hnrSL1lU;
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772453875; a=rsa-sha256;
	cv=pass;
	b=EdKw40EkGI2wVRJC0DgOmB4aONdYEvenNHwq55GqH/z/Wxe0sHTGkzV/iEsrVBEYli+ngz
	vBX2TxMH/RSMBNQk3JFeoUJPxj0ncPXrk5Pv20nb0MTvcGFoW70l2qDIV9QYMt9qZwR4fp
	Lzo9eMwBZ/zSMK0rBp5BYWNxBxxVpHA=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65c0d2f5fe1so8746522a12.3
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 04:17:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772453874; cv=none;
        d=google.com; s=arc-20240605;
        b=KeS5397BX9x4pqN+3vXUzVQgnw9k8SY/JQ0NRAW7q3q+OEeSqKp2jc5hMO5tHA3Zlm
         KP4ISNeQu0pbJbarntgva2iDStBuilDAmIjC35ZaoGvUUlZZOKkx2j5RG/gAupd1lbKk
         J24dTljdTe5niN8da5rDAeqTkrR3AfmehPaLsH0+hH+dv0KfYLP2k7Y3qFdwK5oMfuHu
         B5/nCj2mpUiE2v+q8Gb5iCIi1rF8x4hajle0Xfz7p2zKklcsRuPBpiWhbj6HBNlTbjMq
         ap/q6WLzE0v/S3xtlsma1ivldYtaUz9JpYKwfsXBH1CzH7saxefC31I3ynpmFp2RFlET
         Jb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9rfvGQOFclF/AK5TYJX+Lve8Q4AghDs9tcQCHmYbQIc=;
        fh=+qM+d/8yxKEJFfZ6cCX6VARPbwqQPf9PuPUXPQqKXVM=;
        b=Xz2p+QhjmiKeN55wIrlke7AuTcyehbr3q1ZxF/1BcVpopbkIwarGbuZfnISS8Oc8wO
         rx4VOOX91OkNRdM3lAvdPpd50AwO7FVJUtv9wdxygsehk8gU/5F8p0eETGSli7c57mQn
         dNEonV8SQ1OyjiO4y6PZpQPi7jloqdD12x2Kc9c88da0QSWzU4edG4rWuQl+sXHNZj0P
         4i7XU0shZVeUrTnwvhivufdthkcSqUi3SKLiDXbzFRozAeL49+Yo6K8R0PzdBE0oYMsI
         phCBsKRwBXdPbMiD0XdwMAIqnSBKsUF2/8v6Az8XA86TP55iUM+2Yjq0xAz20sK9vTD8
         wzHg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772453874; x=1773058674; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rfvGQOFclF/AK5TYJX+Lve8Q4AghDs9tcQCHmYbQIc=;
        b=hnrSL1lUYn76CP+tZTLMoOZVxWd/seoPxjyYXO0Hu6XgFNNHM3wQcNuxmfVhAS3PAC
         biukmZjHDeqVT1sh1MPF1Dk6cszDZvdo9tDQI2PB2lzZmUtbJl+b9LVoMF1LagWBPthp
         UejXgu2Sb1388bzYz8b9r/mLEEuUecEWACwipnCHUsF9HK/1WSmnfnjvnfW2Vz3AFYQ0
         WBF6OJmT+ND2aGM4GmI12Ua6nW2q2c+W1ZeF+DlA840ullC9Zxx3IuxXpeffWsdYnPq4
         2FJ5I6DTkWLmkQGgM3BVLc9MAxl4+/FwRITut7OK7DOxi6BvjwmMjbNOMfUJ6RZszg7O
         Kvbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772453874; x=1773058674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9rfvGQOFclF/AK5TYJX+Lve8Q4AghDs9tcQCHmYbQIc=;
        b=Dc7/ntUy5nJM70O9HaAvgVic4H3NuIZtE7unNPwMvRGbTFEfLeiXq5h3ShSMX97rV5
         IIPxg7dBrobH776hDvTdB95oahTzhoWmp4dC+6amq6MyjPQvMjr2aZFs6s3TjHCW6kP4
         KGJ1zOCm14Ea268DrmBUDk360g6/NWJrIC8F/gI2J9OYz0ifSj68vALOK6YxDpZ60ATN
         oUjouKDkkSyT46F6fbvlbzu6jARRdqcoih9Gc5uN2lF/2owWcuRhWLB2vnhe0Jz7X02Q
         psXFx7591jxVUTTW5g4/bxW7stjCR33AY68XUlSAqoZ1jxgJezbOirEtzqcA0/ocezEb
         YeKg==
X-Forwarded-Encrypted: i=1; AJvYcCUF1nPa/UqLx26ODmc4E7ZSpZCBoSxKvVsGheCh3t78EJoN0EWbNGKrTjop52h0YYgTUORKeFW/cA==@kvack.org
X-Gm-Message-State: AOJu0YxWSOiXue5jvITtNBvw6U5w53D9IiZVeHgvpE3ASKR4KVUixawS
	vLscTWm3vFkVCISf+VDMzFDCl/7KRLwRjlfFt6yd7OLfKk3tL1WbNIhe7kAT8TyhtM662jrlmVM
	BLAfDdWqzi/3vXkA9nU3wmXwPnft2ihk=
X-Gm-Gg: ATEYQzxKTdr9OU8Ce9pDp3NPXL+UznJDp2spPtJG9NkVr3zmFPrmHXeXvzLyTIp2Ih8
	TPrn9nrEGqKDplAF2bPmIulKynl4TUW4SIeC2O3B7eRx1THu8qre+oaBbdhyzgHmgcET91loZaj
	ETVaA768vvnRZDS7P/3n+Y+q0Dcu4kLp5uuh3+YIH3qEUXYfK5cD0PW7BIr8c4bY5ylr1Y3AGR7
	+YiUGwpXCyBPn/WyXWhcIDE3GsRiRkrhPKftMR29CxP/aCeT4eiaau4OolyOF8/WZp6rrCwOERs
	gxFIQhY5OPQdI30b3BV8L+co87owPvKeIv+hjk/h
X-Received: by 2002:a17:906:f91a:b0:b93:4555:1396 with SMTP id
 a640c23a62f3a-b93765111a9mr557923866b.37.1772453873836; Mon, 02 Mar 2026
 04:17:53 -0800 (PST)
MIME-Version: 1.0
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <f4c9b715-be7a-4587-90fa-97f6b72938eb@gmail.com>
In-Reply-To: <f4c9b715-be7a-4587-90fa-97f6b72938eb@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Mar 2026 20:17:16 +0800
X-Gm-Features: AaiRm52V-K_-OhbXL6gPkeiO4wU-MsNrk6wkWX_1kJutl7MlCfJIZxtp24kkkLs
Message-ID: <CAMgjq7Aofz8qf4x4Pd7rQgSmL1exT86-wxb3L9zZWdbQgvhW1A@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eeyumokqp8hxqyoi4exctzxddeiwpbfe
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BA9C180008
X-HE-Tag: 1772453875-993124
X-HE-Meta: U2FsdGVkX1/DXM7qaJtBXIINsTgQzFNeeXmNjcjx3Df/6hZnq66WTsDh66+RED5p3aWmQ7vPQKhTT5S1lCqSSn2oWPjHHY9nK4lGtO5fmGi+MfF95cu3bd/13rnpxw3FnMiMJPgndT2gJ4lo5L15VX9zm6BYNvS9Kd5kYRxkzbMtJFJiIlxhuxu6cPR39r2jsrBkNW47gCNzYVy/Tln93Hhp7QYPd4OyuAWZ95it0cS52zUNeT2d9EKbh5IgMOSnHZoo9xI1+wSIGwTd1g2jdbrM9wJrJoOxQFWAg8yWfeHZYjzCMy9inHRruDIPPmR8B6aP9UgWl+KJZQ/X8uA0M8tv0wCMAGNbTQrClT+6NzsGvNwgn94z/iv0dSqxnTUHF9FjWnQM7tEaGY5wSwGO+PcxERG40fuRyW2ISt9mYowbSVid2/WPbJHAw3rc75/qHqhiJmPSaO9SzBu+gjMxyi7ry1zPJBCxYEUotZ/LR8DGFN0FO5uYea0AkV9h7We3iVaYZ7Oc4r3IuwpBATg1njx5Hys9SbDppp/Eg3kXbSIyjJdKb3V7FWxFe4Sh7z/NJKEvE3+MmmpG3VRq4TwYP0Vi/SVI/MMOG+JP+/YNP397vXusgMZ9uamaWg4Z6QguVGYfxRbHBkg4nob9jaFESDV7F1yBuJMQqYnrs4jHxvuf5glkOYC9UMEqge92HK0ItbU9kX+99XcAVXeFE+46L+YZG74m46Rh8wI973V/zx4ZWQIF4rSvQkW7UGQe9UtZHuTdzyrj9WDsJ9gR5JpbdpBGqa7UjES0Zhmj9Z8RvqL1fTTd+zVCM2YvT8wcasPHkrrpa7lRP9jbJYExyyTit1thIP5Qqsc88D0NoMOOAKWLhB/J9Zex52PyHtgO/tsmdDewq1FLos0S5vA1BZomwm59XSLOVJqPk7lzIvNU7EJHFJdhp7URmxpeFvRBL3NER4Jx4Hu9IVhA7wW8ruZ
 QgK/czZz
 kDxMb7u9FSudP4iViSlsTMvqO9CFQyVi4qPuCbLizhEefXtXC/KBnPKovyR3WQe1D8Y4oW0BXD9LupcYaX+wrq6fES0ht75kgd6NOhEUQ8rlMek9c7KeK/jObF+Kt0MyaBitKibqiUoLteGVfa9vOrR9nlxbUsXhTlWkt8Mvz36GfH7xj+XsQ/j77eul1gQ9DfNPsw5ekY6Ng3wyoFV0/eK23V/Lbz+oWEs7klhdfEb0NKm/keYFrie47xXQfu+cu72uFyawUzdI97izMBKIZJrEztriujgsQwX5ICko5Asi8i4q/D7sVOmZN3t3dA6dhQbubppVVfl/53dU7bMDtPdw7BD+99gWdyNceq2N0Ef2D2yMVxlp7SHoAs85FutJHgZ+zbdvG/lZC6WTsHhU9Gwryf4BNwHCAeD3QqSe9XpIoFGU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 6:29=E2=80=AFPM Vernon Yang <vernon2gm@gmail.com> w=
rote:
> Hi Kairui,
>
> I would be very interested in discussing this topic as well.
>
> In Linux desktop distributions, when the system rapidly enters low
> memory state, it is almost impossible to enter S4, the success rate
> only is 10%. When analyzing this issue, it was identified as the
> inability to reclaim memory. Further investigation revealed that:

Hi Vernon,

Thanks for the comment!

> If we could directly remove the force protection of the youngest two
> generations, this issue would also be resolved, and the solution would
> be more universally applicable.

Yeah, that's also what I have in mind. Such issues should be fixable
if we find a way to remove or optimize gen protection.

