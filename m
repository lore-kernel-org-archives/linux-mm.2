Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4954ACAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 20:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9572C8E000C; Fri, 26 Sep 2025 16:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA6E8E0001; Fri, 26 Sep 2025 16:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8D28E000C; Fri, 26 Sep 2025 16:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 65F3E8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:08:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2355411AC49
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:08:09 +0000 (UTC)
X-FDA: 83932487898.07.98271A7
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3C39280017
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 20:08:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RP4JGIEy;
	spf=pass (imf30.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758917287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K9CI2XREIIFjhmSjVkb/YP87oVQqlW9glL6hrNBmQgU=;
	b=An7/q8kT2x43YCHnWUZS7nMBPDxpezUu6ntPnstD8Ie41U9XegHIOYSp5hPUXo01SDohLd
	KbPBc4wp+MrMcyCilKZea9zePxI6svNy6r2GiUys8N+Edw/o+1uSpSjF1N3mkCnCY0iEfM
	Xs4HxwZS9Fnl7HqATL2SyfFPot8MCbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758917287; a=rsa-sha256;
	cv=none;
	b=XRRXrEXFAdKGW5PRDWrBWTr/EUSG04GSUYUVMhH9myAnc5MeHmX+g6JVfTxcjXC/v3m3vM
	i4Kc3NH2MDDdZ/OCmT+FhUrldrRyZLRLVkLyRRGKRJWGXaL8WF1K8ScOQfx382Fiu/gVE7
	lQ82uLg07jlD105TMsKLtdgz8fXH2UQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RP4JGIEy;
	spf=pass (imf30.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-57bf9bb803dso272e87.1
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758917285; x=1759522085; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K9CI2XREIIFjhmSjVkb/YP87oVQqlW9glL6hrNBmQgU=;
        b=RP4JGIEyHntuXAWDhvCUSCzMnGWv04mv6QfbIXzzm8YA58szoYoH5prNS9vSTx/rpN
         1DuLsP3tYpGX3LjA3Ai6dCdGuGomZW7RPsvMU4WMKdtkoSbsVvytaNP68XC0YxpIMggc
         zJeRHeRsMGE9XSs3ZiAAm+qDm8c4W+/LcjGG59r7AjWYVkIJu3j40l6ZCk/PpGpV+Ppw
         lPeolLoJD8zhSftv28JamPJJaz3PrpIHRh2SmaPylz04eajwqjUVi1cSufxHjWQ1NGdp
         8OmQSZ01ROiPfWen+joy6smZ2kqumCH7BLUnlL3WQLyuM3HvtiW8IbCzM1/V9KQzqjh3
         sSAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758917285; x=1759522085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K9CI2XREIIFjhmSjVkb/YP87oVQqlW9glL6hrNBmQgU=;
        b=Gt6dBqpttZbkFMVfdSgHcrhs/NIEIeq4Oh8q+HyO+h2bB301XpVcpva4OQJKncEjF/
         M5BTMoL7pPhhFPOPkBhR3d2VApJga3my+UqcFf8b5G2eaXd0JdLWVKQ03cLeUuEsSfGV
         LvY4mpceD9c9p8ON+nWICuahoMV4rhclifMpuhcyEqyHRXE4sAUMZ8hiXjcfGKtx4/kh
         qL/zp1nrjIL+MawZbPVOwMlWV1ckPOv37reE1ZMJqcYXi5by1KgYpXwZuRwV0rvdo/5K
         aNtvOvOtx4JDDTaR1Orz2wXbxLo4vPEz4TEDLTHWff/KS20DqJX45tEgTsbSyPweFa0g
         uq+g==
X-Forwarded-Encrypted: i=1; AJvYcCU4b7lqqhOw9idOKRAP1Tda8RSAv9m/4yKTewlhB3igypk7Dm/2nsZ+h+OJmMp23ZOijobeXvIbuA==@kvack.org
X-Gm-Message-State: AOJu0Yw5/6QEfKRnZM+zY9OBkkQztnwYV9skrA6jAH/U60FgZ0CRCx7u
	qW/rSfWybL33AoV/wa3lGvvSx5Lew2rPye///TaI1HsPQqfzcYMp0iB1275rfHkbfVOzdwaSX+P
	OWXkkMdS1dTFDe6SSufyXw5uryIjEgJQuTrgEYVm+
X-Gm-Gg: ASbGncs9LPXGgVXC0ViISxUn4uTG5JXkk4zuwFK3LV4MmkCD/oa/qpgd0EXBQF6CI77
	ixrT1ZkloFIrnj9xwS2hBecJc8Gs6sISB08lO1Jq8cyZoF77qbgdvZkZcKt5659cZkTgURcUmbf
	HP8pR1gEFxUK4oXtyItUAP0nuJnVg1cBBMTYtci4kpBFaCHYj/jCk7j0F6AlXa6vAtCOKzXSagL
	jPIwJCmGDLcFsZiVSMIlJCFCQ7xra0fAX0=
X-Google-Smtp-Source: AGHT+IHh/8s5lDW6PrIkGVFJaJJdDZIo4CtrqP31BIJcj1gV4FXK0xxTL1eISgB5E3n7tXhFhgbr2pjeJVV/JUTIXYs=
X-Received: by 2002:ac2:48b0:0:b0:579:bc95:cd25 with SMTP id
 2adb3069b0e04-5856d00983cmr99849e87.5.1758917285153; Fri, 26 Sep 2025
 13:08:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdxtTYQye1Rtp-sG48Re+_ihD637NDXTG_V_uLkerg=m1Nbtw@mail.gmail.com>
 <CAOdxtTYKrMhjW9JiOCDBia+s=2tob1HF6yfAytYnajYsSoX5Kg@mail.gmail.com> <aNbwuc_Efg-Bj2Yu@slm.duckdns.org>
In-Reply-To: <aNbwuc_Efg-Bj2Yu@slm.duckdns.org>
From: Chenglong Tang <chenglongtang@google.com>
Date: Fri, 26 Sep 2025 13:07:53 -0700
X-Gm-Features: AS18NWCZIXmLqkVpjrQEp5xtsSwnAPUB3hSpbrnmkPOnsnT8YMG5tAtXTkLnx1M
Message-ID: <CAOdxtTYadTmVt7N6SLkQG63Nxxc-a5M=df=4f0qEXwm1LcrNAg@mail.gmail.com>
Subject: Re: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
To: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, lakitu-dev@google.com, 
	Jan Kara <jack@suse.cz>, Shedrack Okpara <sokpara@google.com>, "Calvin D'Mello" <cdmello@google.com>, 
	Jeff Schnurr <jeffschnurr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8tgtpyf6re5oknm1n4tp51fyaaa9jg6j
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C39280017
X-Rspamd-Server: rspam10
X-HE-Tag: 1758917286-592376
X-HE-Meta: U2FsdGVkX1/x5QslVG+ggZj/zXLy+Z7wRoStcd6gtoDjRyrU60e8ROinBUhwZYZ0sqs+mMyMzrpEZuKKmjRa2k7KZpxnf/LBQIXvD51MuiRfp55JRCgnFLFxm6x/qzMWEJ5vzPW9tNRee94Zk0Fhk9i3jUfgEETPsTd9IYQU7iWV7UOe0CF3I0IA3XXlERDkqSG/L86gIlL+8Uh3imZ4Y30E4OppG3swvehM9fK21cn2qGf169VJBIB9eolKNSZlP+97KUD6i7NWIdqtsj32B+r4dfu4DNjCo81Gf2d5ARyng/niEvOSM4+6n1t+T1cn18qUwq7kQZpD2mcfO8dCNaWalxtyGK8VTYcuv+h8sJfyuaBj2Zr6ffY0eC0DU0WWj5xUO0neIF0oLRoAr4d3y4BGZGBSTChqSTBewX+M79wJ1fVjvHIdRLffbkc6j9INSzwU/3f9yAhMcZ02IpaD08VEhYR8pr5PcM6aM+jIJmyCtTuBWFiVw87sPiPeOj4hIZIqzej12V4UJyNAojihVRrIyluyzzYCxDyWXNq6Pjw+hok5BJ5k7qiShlzF+s8z2Vz+g1cOb8Tunb09cMuFYn+wkAIG6RL4eQe4alPTgPinH3e5IJzqtcUVYJY0auXok9grClnMNEBy+VTn6A1Pdf8ma9VY5WU4Huxl6x4r2SYzQkEKm4znYm3XQgPgFDTRmncBmC1+VeJTJNJXvctnpV1fZckN341RklnF4S3e/XK9vaR3rqyMqHFM20aX8AemKXaYC13usuSlWAK0otngIBqpOInKtJsTueN7RxSYfvhmYnuErudCIUay3vT45UoWsQQhFNjOcmKmrUOPzARmHardpl9c60uCk5M2izx9/0ITfV40PwXQJBjxCm5mwVKZvM5STPK0jobQ8oK/IJHVzxmt/Fg5QMI7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cc'ing GKE folks

On Fri, Sep 26, 2025 at 12:59=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> cc'ing Jan.
>
> On Fri, Sep 26, 2025 at 12:54:29PM -0700, Chenglong Tang wrote:
> > Just did more testing here. Confirmed that the system hang's still
> > there but less frequently(6/40) with the patches
> > http://lkml.kernel.org/r/20250912103522.2935-1-jack@suse.cz appied to
> > v6.17-rc7. In the bad instances, the kworker count climbed to over
> > 600+ and caused the hang over 80+ seconds.
> >
> > So I think the patches didn't fully solve the issue.
>
> I wonder how the number of workers still exploded to 600+. Are there that
> many cgroups being shut down? Does clamping down @max_active resolve the
> problem? There's no reason to have really high concurrency for this.
>
> Thanks.
>
> --
> tejun

