Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A472D73EA8
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 23:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33F256B0088; Thu, 29 Jan 2026 18:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2A66B0089; Thu, 29 Jan 2026 18:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A4336B008A; Thu, 29 Jan 2026 18:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 06B8E6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 18:06:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7B03213AA37
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 23:06:50 +0000 (UTC)
X-FDA: 84386538180.06.BECBAF3
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B19740006
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 23:06:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="OYu/0SC9";
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769728008; a=rsa-sha256;
	cv=pass;
	b=Et1enMBe4csgohDHDnMW8ZwGUfjTIu1RpnGDrYRi2MA0/aw9vUcPRsbx0iPwKg4z62Bxal
	DwMCY7lfKmkCHi3zHnmtZVkDlUMzltRsRTKtrEagrk6kCRiBEZIeaJWDQAfHaZJjUoHfGX
	ry34VUogaEq9K0Ws+Dgwe98Ia2aK7hU=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="OYu/0SC9";
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf07.hostedemail.com: domain of paul@paul-moore.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769728008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2FgRhUI4ULyQ5DXrJKYAevPbTbBkxgDEbQDJd5wdBQ4=;
	b=GZMDhT+OiMoh/6BWXRR5xzj2ISbRJpZLuV/8KFdoBh+cy212Rg+/GTyL5gBzFfUOXeYhvU
	HKtwkiDIImxIfXluEQpkzHOfC/Ua2QTkDnUgTVtXZ7UqAGsiXRT6DuTyIARrj6vpUbGvBG
	cPjIHn/M9dsgl6f1rOzU+v1LrGjc+bE=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-bc29d64b39dso529958a12.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 15:06:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769728007; cv=none;
        d=google.com; s=arc-20240605;
        b=jsxEq/Odax4/JXF0tvuESOW4QRgCFdbnZyferqUc+AtzNUE3a2A/dR30dm6ddUbQPU
         kEmZb54/ihrGoi981U2obgog6SHwwiibD/2mpINsEc9q1j6FfS2c3MKlOpakpKkrVeN+
         C+rphgoEu2DkA4Zod0QT3PUTsJeSlJV/aCOjbIyYzAY7GZOwQoSCDMpB8smODAKDhiZA
         gzFsmp267Z6XCagoObuhcQCTnOaEA6DjxGQl6uinoV90cYZlvK/qPlA42zbD22gSq3yz
         sDYXKq6G8ijY5bSrudMLanr+GaAdODIMTd2XgasFx5uaxgQ1oLVICOilNWoZ1GC4CI5R
         ujwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2FgRhUI4ULyQ5DXrJKYAevPbTbBkxgDEbQDJd5wdBQ4=;
        fh=H7RvlIvj8YZQ4cs7bLoYcWcxTj0aZwnfN62n26pD+IQ=;
        b=esyqL4JCpGsWvXBuLFl2OmFZ1hvQKeIeyIRce+4pyVDZID1udgH0GTN61UCn5+9a23
         WTycsxZrYx1oY+6JGVeiDsXsYHn40fZKt09pGNHZJTLUKcx+O1OShYnTdF61cOyOiRaz
         PKPkJhU30L048C7dGTLDn8pDvDNl7lT+G994t3VXcSrdlI+T1sOBQPWhwYeqbdWdH4Gs
         Hw+Vmy9RUvIG1bgWXeCzO9NJFd0rzDD+o3d3LoFSRTPU0ygSzdlTYRRS3Uql2ZM6kmsu
         X4U+yV0LgYc85jemsTfHJwxh90+t8MglJzFcsLWA/IXocLqv01yoG/dMf0f0URF1V0M4
         iumQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1769728007; x=1770332807; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2FgRhUI4ULyQ5DXrJKYAevPbTbBkxgDEbQDJd5wdBQ4=;
        b=OYu/0SC9Y57V7auqudVmsbJ9cE0Y700PLclaMWZI+MKylCExtnaTI3ZoDd1IhroaIc
         N5VqathfbiABk/LbDgIvM9WhKwmQsoCpoHHpatFFh2izlikpcyrtYqkv/6bo2VVbVZTN
         Ii1GogbCLNcTWx/8ahkVi4YP4LXIRkE/GyI9TxawvzPCDYAybQlEjiJ+WCcKGqa1Im6u
         d3kQtpfyyYxO1HWtvdeCBIX1pT4tZWa3C+OCyx0hqjjpFgUZl4ihtiOPCIImuhXSbeLw
         6OM1N4zwxxmBxXBELKl1BTD8OCsiHax619JLW5uXI33HBthb+8VJb1F/tSCMADGvnn5p
         ilww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769728007; x=1770332807;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2FgRhUI4ULyQ5DXrJKYAevPbTbBkxgDEbQDJd5wdBQ4=;
        b=eA6o6BqXbgbXQFDVfuj8mQ9PXGOYcbyH+Cfwo20GFn/EqyX893r7k8We1e/posdRLW
         TflrJyOfRcDPBq5bMOUUltYaZAu1sMHetzyf7VPL7ZwqnrhsaQoVZlnjuvyPmkPPgqOn
         lAcH/gIz0rwxBvZKPssA0/LUaM79RpTnp7veb2LSkCw79HoiIRGsk+w0SC4Jn0vSfutv
         Hem5c4NHdklJOwMiS7hVNUBvwUpbm6aSzvk3ZP/1sfdE9AKNnYdDMLCOrILhFcIUXwk8
         VsGbFgMEHDVYl53om4V/PC/bChs13rHGrMSmqnAn4MzzkkQyaqCnZEU1dx9F4rEiWpzx
         NOTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDS8mfVSHstZtkuuElg4CmHcZkaD/iiEgPX0x+8Ct1jvOHloibICXGFd9w8iTHGCkZUOSibv1HMw==@kvack.org
X-Gm-Message-State: AOJu0YyuQoE6gXGKJnncor9A1L2Up8yvYliA4PjWL08Vi2Lrdfevliu8
	E1VgxkEUWrwO9UbxMODy7Omdf7P4tIa6fiEsH4Wh25S9es0r5hEpZQ03wFOkxz662KgQhHl+aLB
	RyRrVOp5Z3KXRLjZO51Lqqbi3YOsYpEWIxerZwnhh
X-Gm-Gg: AZuq6aIcae39DKxZ0fvx8J/dDOZUtefWG5jKWF0sLQTM4QGqdqp01q7lqPAaqyluuOD
	mv3uvXoZxTSWfWwaSb4NsD2wBcw52rapn7jHh9sHwg0olwgr04bduHsiYisMjYC3Z38h8wZowXZ
	A69HAE8wU1zjSuEDUXY4wpPPQ4SC3GjtVmhbOy1Sejjd7OvvqrLtOEKFwoFw1SnQi6nv4hEK5Z1
	TNcX/ny2Ecd31KXZI7KncuN+sQECUeqibkpBrPJZ2iJNUnZUYFXofWknPbsrtvQcfxEvYQ=
X-Received: by 2002:a17:90b:4a8b:b0:340:d578:f2a2 with SMTP id
 98e67ed59e1d1-3543b2ebe3fmr942700a91.6.1769728007348; Thu, 29 Jan 2026
 15:06:47 -0800 (PST)
MIME-Version: 1.0
References: <20251017202456.484010-36-paul@paul-moore.com> <20251017204815.505363-12-paul@paul-moore.com>
 <20251017204815.505363-21-paul@paul-moore.com> <0146e385-935b-4f66-9e6d-51bb47ae4bdc@lucifer.local>
 <14638978-b133-457a-ae9c-31ba54e3964c@lucifer.local> <74286aca-a565-489f-ad2c-886c650ea2bc@suse.cz>
 <01cb28cb-56b7-4862-bf27-07e4bf17115e@lucifer.local> <CAHC9VhS_y2gy2nAK7C-OpchME0pzS34-QN2bY9t5SRBXArz8Xw@mail.gmail.com>
 <5392220f-c29e-4cbd-8dae-59fbea4c6491@lucifer.local>
In-Reply-To: <5392220f-c29e-4cbd-8dae-59fbea4c6491@lucifer.local>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 29 Jan 2026 18:06:35 -0500
X-Gm-Features: AZwV_QhVDVaLZs8JJVAmxYQR-vhXYvsk_Nd5ubbkE2VXzkBWSDq2lgRuz96U7i4
Message-ID: <CAHC9VhSqpqVT4oFzvFpReJbh247mJnAz6U9ax-DS3oapHRnf=g@mail.gmail.com>
Subject: Re: [PATCH v5 10/11] lsm: consolidate all of the LSM framework initcalls
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, linux-security-module@vger.kernel.org, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	john.johansen@canonical.com, zohar@linux.ibm.com, roberto.sassu@huawei.com, 
	wufan@kernel.org, mic@digikod.net, gnoack@google.com, kees@kernel.org, 
	mortonm@chromium.org, casey@schaufler-ca.com, 
	penguin-kernel@i-love.sakura.ne.jp, nicolas.bouchinet@oss.cyber.gouv.fr, 
	xiujianfeng@huawei.com, linux-mm <linux-mm@kvack.org>, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7B19740006
X-Stat-Signature: gbcwy6muwe3b8sebgxfiiaxxbx4ip6kw
X-HE-Tag: 1769728008-349668
X-HE-Meta: U2FsdGVkX1/3D026lNOqBksLLX7BTO+p5BM4qEUiyFIB8J06IoVJd1kzedqxqQtimaJr64lXWDpL5rlHW6qwHVBgtD6OW+wvfYcjpCm77A5BRimaxFsuDCyahMSBl+lcdgJL53/5CWLmsSRa961BdTWf3JgTfjUQG93nI5D8PfY3h02gSd/eRW9BlvkuFyMQ7S5KxA3GOLY6G5kf6PmNOHMIESa0wqxrv018C5xb7pNSfSu0LWMsFLIlzyToU7xOPaUBmodMdNl4i7XU5UhA8C7Qps88ZXAfgbIy0EW0SC6oKUN15opxvchlA85vig/LH0gV2ECqyclgJrIijhs3d7eqqMYUaTY+eVFsb4KcdpGveoHsGS8LISCxCAvGJoxT/gzhnsQGonfcM7smfm7XeMHGzrsPHC2r7PACQGPmpusq/ww/z9CZjezDEpWkcJ8OP/c3Qa+GT34KdrAkhNpFU2/6fSjWjo9brHVooj6Q4VrVJ7Be2/aovfOWVMXCR7E5sO/fVDgQU/kBh7lR8m4mcrnOk4Z7og530gc4YUBRTzEAFr6n3z90rLx3iIGQI4Dk8n84oPKa+5OQVnbktwNdV2EMhtPsQDzPf8J0CgpTbIS3PnxzePdcKAP/nS/NYPdot36O+N7UrAONq2br+eqweIW3KysMc4i6GzCwqsKnzyfMVm2mKym/BarDm2t9F4CYczhCd/nVMom+v02mKMmHfiNhBiTAN7vnYF04WWRoJyEw/j94L5BmA2U+KiPzNZEpWW0tuWeWBS+/pLeo9pv1OkP9K/YyEZAYF18EQg7bYnIYkz0FcMognCFbbMbTeit7vQW4W+DJwGuVUKP/vUvR7CxiQ5pEuMV4H/2A9mIEpZNVwhoTts7ON3xw4ddFxzKskoDRwBVWksCiibflN5ebBPf61E3DiMQ6Da539KrbG1Xus34rnZ0d/KGGIhpeWihFT5t41xNGzYhUgdV3SPW
 QMUOpepq
 jGcoIio2NZ2SY78z1MBFSOPjUR9+0fWwvv7Dr96Wu9jpSyLV5gomKuuHs+vXc27sMgOTG3bswS2Wpk4gtEXSU4/410pwusSy0GmGM8ESBI0my0fGAnAXYzkH57ws9MbLOS+JS4u7rC+q4uOR86VQWXN2yTnCRZLpwd6vvA0CpkoqPeNXbxvN/4WdNIzpOTNvBPpmWtjqFt+AFslVKshbff/uwl2pUpYPNgp2rJNCU9QxNsHLqxG9rVU0kptSLwgKIX+zn7c+FO2ezF4Nd/R4jEtDp11x8ngYUkV8Fzti0NBHXjXx9B0MZBUedUBKcG+LhNpvPmPZGTA8JsgJTSDbaDke4H8Kdt4ROkRoUFETo/5rOFsGHhP+w5FQWlJLFXlYzd6nI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 1:59=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Jan 29, 2026 at 01:31:05PM -0500, Paul Moore wrote:
> > On Thu, Jan 29, 2026 at 12:11=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > > On Thu, Jan 29, 2026 at 06:02:00PM +0100, Vlastimil Babka wrote:

...

> > > But that's future work, for an -rc8 hotfix ...
> >
> > Expect a patch later today.
>
> Perfect thank you very much!

A link to the patch is below.  Assuming I don't hear any negative
comments, I'll plan to merge this into lsm/stable-6.19 tomorrow and
send it up to Linus early next week; this should give us a day or two
in linux-next and then most of the week in Linus' tree before the
v6.19 release.

https://lore.kernel.org/linux-security-module/20260129225132.420484-2-paul@=
paul-moore.com

--=20
paul-moore.com

