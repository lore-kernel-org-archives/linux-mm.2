Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DB1CAC5B8
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 06:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759178E0003; Sun,  5 Oct 2025 02:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3128E0002; Sun,  5 Oct 2025 02:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AA268E0003; Sun,  5 Oct 2025 02:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 434D88E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:03:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 941C41194D2
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 06:03:41 +0000 (UTC)
X-FDA: 83963019042.12.E6D9935
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id DE3524000A
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 06:03:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cP85FJ0C;
	spf=pass (imf11.hostedemail.com: domain of whittenstephen08@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=whittenstephen08@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759644219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/EpeQY53/4UkcXmpr31rsWooJ3ZbSiXdT/QbRb9y4Tg=;
	b=Gked8NxCO2EqY0u5a3/Wm0o+aQ0keoljhxXOyt+3Bnu0do+r6OwOsJveTRDDfYKWVSOxAR
	5x6XWSiqLQfPIonwFlxnxo6RY4ZRLxM69oU8FV+/g1AfnDykt2LQ8BTEEcSoFCo0RLItMX
	oyC+6BeSnNwm2v2J75YmzcP14UkX+Sg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759644219; a=rsa-sha256;
	cv=none;
	b=DroXywnGXB680yc9eTHDvQWqPDxljUReDI+XCdILaf1Ag6gmJlq5+r0ObWix/ck+NyPAp+
	Dq3L0eu/gMYYvcYVL0WHWuUFng5sQFKBdXrPgNrLFTLjF3g6P/lme1rUfGz/qsgWv8UKNZ
	PhkojYM5qFnJAadRx2t0cX/+Dkt8J+0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cP85FJ0C;
	spf=pass (imf11.hostedemail.com: domain of whittenstephen08@gmail.com designates 74.125.224.46 as permitted sender) smtp.mailfrom=whittenstephen08@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-633bca5451cso3851358d50.1
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 23:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759644219; x=1760249019; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/EpeQY53/4UkcXmpr31rsWooJ3ZbSiXdT/QbRb9y4Tg=;
        b=cP85FJ0CdsOTSNw/HobQFyfTomVpRf+n/AL89xO3jcOd+qf4kz3ZYBwHNbew2RTnju
         XbxPCPT70nlA8zvmR/g2oGZ4KcZWhoJR6oqt6liULYUkecQ8LBgMr2laxglTT0PVz0hL
         EfV7QLIYDuxiqsuBDoTCC5WjK2ub1Y9PYy5f20pEx9CZDSzyPAWjsOFtqB5Y5EKKA90C
         B9BNEL7lQxFkc6VUbkZfFe8f2ByxcwTkRGVxOGMAAQrgAoGcWBfvoICCq4f+SAAiTHAE
         gqj3tga3VYrSeiOeK+BO4fMGccClqifrcbcM66ptksKFDQXbG5aTjin+z/rlLB/eVsMC
         ZiNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759644219; x=1760249019;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/EpeQY53/4UkcXmpr31rsWooJ3ZbSiXdT/QbRb9y4Tg=;
        b=xFSAWeDFzGJsb15q2nIotqfaz/5yaodryOmBThCQzqg8s5HcqyhXNAVwX1eYTtXBlh
         XMnmijfMMfF6uUS8p+jC10AgmWDHuJPcWeHIJ6lbNB91u1o4D7TVt8TYOfUmkJ/0GzY2
         iBA12GocUyMPvOTREx4gROlxE1XxVBENexSkpN+c8FUVAhcfsPFZF7xd7fYtV3FJP4Wi
         zyM56g70vErYE9sbE/9GIss7W/MzPQpYlmxlk6V6ptdYP4C61QZOlakPXC/8+w0T5yrZ
         ruKqZfiLK6PrVus8H/h9Nmh3CegQZrFFGFH4WvTbxIxC/QeRP0yxb9vLSdZ3FLuIVvx4
         RZRw==
X-Forwarded-Encrypted: i=1; AJvYcCXWDAmkN0zfsenwl2M3X2pfUHX6lJ3JODbYYurKPuapXigCz7e0YAtyugWgnvX0qboNiq3GCC0jBQ==@kvack.org
X-Gm-Message-State: AOJu0YzdboiiUwBY0BEwZYIL7Dpq64PRevLs+ZAkfi4u731JiO7+VeeG
	OhpqlKyIfE+oQnuUSPDcAAYdeIGjxIDfaWEgHWxcUZ/GdqXTpDbDNCmdH2xI4j8kMu4GCF5cPwg
	utRl/q9nL0N7C8AWSNtlCuWOFR++Mh2U=
X-Gm-Gg: ASbGncs98naqXAW8mLUMSL6lTWgzPB0vnbNP8Ik+dInvLcJN9wIKWgLHzFofFweB+UL
	UoXkxg1urJyW1ZlFbp8arZjAMkxMsyW14JYl9gPK1PVjEETpQpSMpl8wg0skOSqW9nC44E5tf3q
	CDzvr8yeAIQ5Nx0fFDt5AeRixvQ//lwxBlswk92tq4oPqTcLFLi0/ArtZXNE6YPTc4olNUji87l
	ygjfyRvBQGF18KERtQs7zH4Jxo7PFQ=
X-Google-Smtp-Source: AGHT+IGPaMPCVPIYGmwVr0TM9+ZceO+Dm2crUygS8Pb8WLfneKoh5hZDerFLHfk2mBWduSkWaC3PXNES55Z6FgWStR8=
X-Received: by 2002:a05:690e:147:b0:636:3cc:28b2 with SMTP id
 956f58d0204a3-63b9a0f1756mr6361320d50.36.1759644218926; Sat, 04 Oct 2025
 23:03:38 -0700 (PDT)
MIME-Version: 1.0
From: Stephen Whitten <whittenstephen08@gmail.com>
Date: Wed, 1 Oct 2025 07:29:01 -0400
X-Gm-Features: AS18NWBpVO49f8YrST5cDAyYfhn7szBYaw3JumJAaau0aA8sKcIL_fRym4HV3mQ
Message-ID: <CANrTvFdxE7HKwc+t6cOhUsbY8TZCkH9b8ekYJEtbtS0+aSbzhQ@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] bcachefs: do not use PF_MEMALLOC_NORECLAIM
To: dan.j.williams@intel.com
Cc: akpm@linux-foundation.org, brauner@kernel.org, david@fromorbit.com, 
	hch@lst.de, jack@suse.cz, jmorris@namei.org, kent.overstreet@linux.dev, 
	laoar.shao@gmail.com, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	maintainers@linux.kernel.org, mhocko@suse.com, paul@paul-moore.com, 
	serge@hallyn.com, viro@zeniv.linux.org.uk
Content-Type: multipart/alternative; boundary="00000000000099aad006406318de"
X-Stat-Signature: r7mcjcb7r73isdpuejpdnxg5ejjouei9
X-Rspamd-Queue-Id: DE3524000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759644219-977751
X-HE-Meta: U2FsdGVkX18LYTqF5/S0Vg5Ib/vXNzyU69OcdsnmqAvnozjS7tVm3mToKzIG3rWTX6u7SjUTHFnHJM3nL/nrKWxGNIyaG1k6OMDTie/IDRtElah2iEY6s2KBldySeJf4uo9WyK4UwkQNoAAkP5vLJqCQGRt+KjPcT1Jp0r1Hs/nbVt6lcVfJLZigLhSh77cngiED3u87YUAI+Ji2QnK+bICtYjimCD4GjkB+f2ef9mWH7LJCIcMzWes2XWxirkzmIypwbEPCWSGeN+HiFFuuKB4apxlqpfnius0AcChY0xRb6QCxiRdtiM4dNQJsGniJH/nkbNwbIeh8xrBIiz8MM2eUCJiCKyLWGftKNG1w/IfoON3DYCmM7i6vCkmpe42POw4JEuMJMfJeGr0cNTSE/cbcJuHVmCSLzeyeCIjXam+muH4kS/B3hwytEnvVr4Xx4VRVCyb0eetKWWhZPXHicRB9I4GFcQLkgk+P2Iv3OT7Nz5gpzrlK1nxP7+4Ng1EdG2ErImp0eM0wABkzWdNxv4qODIaMO/4/MXAh1nhJPKlmxnjKPMHx6qFRzzS4q5+YvbvdiRipuhtK2cSRyXMvU5s/jrrmrt9lOnT85Wa6aXVEgMI8g3MPzKhB2bxDOIwIclQ9EAsj3CF/bk0qFWhShSrtSpCY4Wh0JMgcYSJ+Q+mbH+mp+VB2ymkWxJCvftaPqw6yvQ5TdZZYADq3gBPMq+Tw4L30C6eG5r2OJhIYL+HltqIaHpHfiXb+ycr/EJ51yDh3hgoU/azKb9pdLrSGeBLRoO81DYC1gMI0R6R61WQ6KAj7XwJo7OTQrScMJ0DMDM6IMdatNsljZo2qbkMbnqapNQm/KCBrJfmyaB1R55JbJM+DRUhsGl/7zDUOqiKuA5IbjIio2APnud4WYP3XIw4znBF55bPi9CbVqsGzrbbECBYQ/9FvGTYBzqgE4Ceu1QZsWt6zNxDIJLh3VFq
 OQhbodun
 PhOKQC8yzPma5NUG7xPMDqwLQxxvEWe7re04aubx0tiTKWDU/cNkjOD88xcurQwLuOevTMF2ulfRRtOhJ1T6fDpo+Cwq/UZ6t+5H+P59JMI/Ys+ydMNs7aWR0Z6K6dJBxt9c9DkfoQLrabd9ixRpGt3kyBbV9GS4a1VtOy3e+qCDaPNpHOKYRWYifhGT9vryLouh61B2+QjyutgznZrvVRUgZUPMnTzIkS1SIqFsBzESScWHKP2mQ7M7uqgM3h2V3M/MXKsus4SC8vneS3owE5iNI2hqMzpmIZ663ketc40Hn3uqmVtq19YxP7g/ermcAU5d2weWPJGoSee5fTlvlhdax7/qm0N/C4zt0RpSk23NkachzkKMOqthsqFhHIhgN3kw7J+lhQ1pyf4Kem6q1t6IjyWiKBWuZSP4Pfp/I6jjXcneLjYVYOfr+mQl65UfMvpCFWiyq+Drh42M9dkVdcI06ogf8W5p/Fp0hQJCM0fwhQPLK7KiFjP/qLNJVoPIAt+bUyc4f7MoHmrgoTiogSGDnElveFotME/RoCSGpmnKb+Bs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000026, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000099aad006406318de
Content-Type: text/plain; charset="UTF-8"



--00000000000099aad006406318de
Content-Type: text/html; charset="UTF-8"

<div dir="auto"></div>

--00000000000099aad006406318de--

