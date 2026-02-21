Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D470BC5CFED
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 04:37:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55EE6B0005; Fri, 20 Feb 2026 23:37:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A005F6B0089; Fri, 20 Feb 2026 23:37:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E56A6B008A; Fri, 20 Feb 2026 23:37:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 786DB6B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 23:37:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE29E14029B
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:37:49 +0000 (UTC)
X-FDA: 84467205858.13.FE62381
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id E77134000A
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:37:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lfCmJ1HD;
	spf=pass (imf07.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771648668; a=rsa-sha256;
	cv=pass;
	b=hzo74gjNH10+FnCvqU5hizj53L4QgGDrj3VPx3Rs4Ers3ea0hTu/LKHm9lZcLTMByQPSSy
	TuxLAOA9Mrtp2vfyZTWNBWMBfz7M1+WKm1DFieGnpj0d0PrwSYG5u6Ht6XAnXPHHPmJTiB
	5yYj0uNTZBwUQLzGCrUSFcYS3s9JVc8=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lfCmJ1HD;
	spf=pass (imf07.hostedemail.com: domain of kartikey406@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771648667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BVqLtu8eOSB6Ez9slneFXi1iVxb6lz795QLLkkZvzKM=;
	b=pyQvYd1qV8vfnsA4ShF4OeJm6OTIxq6fPQFea+xvx1Qxv97fXHzQgh4uEtJzr5YpJudScl
	RCzar6XdhoUIZ/aHW6bkfBAbPRVrofCf9iAqNDZ9u+5/P+hXJlvbQkbFJ53S6yX/PtHRtO
	Vle0ZJnrnvBe2C/F9iw/PWt7xAesbqo=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-649df3c22d4so2532951d50.3
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 20:37:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771648667; cv=none;
        d=google.com; s=arc-20240605;
        b=Ce8JTfoIiRuQoFe3sZl8dEmlNVlQ94f8GTETnKZl31N+viw6Tpkhr4MIVuvfzeYZnq
         sisldDZRx8cbWuicPLvRg9uDfCQ+kWGVllYRYRWAo4DNHWibssZpnd9h3sTSM+1YTVno
         HCH0fwscmv5xH2r6pRlu1Ub9Rii/hWZ9U7xQyB7Qk0WUvQHbdhmvUrGzOVlTPmvrbAea
         9aJmFqUrKCbRnt1rkKoWqQ/SEiFsRJTzpH+ilRJM+cPQS/RWfdPzAZAZcIsQyg6yjr+g
         UaefcDNqbSZ8yCpN6R7TrI1q6ILer+3jGsB0KQB16mUk7lqCWE6hm8iedCgps/4nqPm5
         v/fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BVqLtu8eOSB6Ez9slneFXi1iVxb6lz795QLLkkZvzKM=;
        fh=Fe4bdzNkDOuc0nOEl/D68JRGkQkdINj1Q/EurYI6Jf4=;
        b=FPqv5o2yFapYF/7+WZsQ/LbjStbm1NalhHZxW3Z6lpbzrpMEWHzp1zjweFTGrStYeo
         0oAUUIFtkCTYCyyV4m9G3e+tvUMr+gX+xKWJkaGCiRAf0Hae9DM0phcYU1ZCOGA9lmaZ
         p/rHGUeuGlEiM0rJhG1L4g+Y7lkJPcFrz6FMwwMddpRYl3RTDXQrSkjkVd+waxpARbab
         uQ+h63UOMbtDMYJHCS7vQ8QQHeO0htIkfWPf7YYLriuBSg6iixwP2tI6zTPPLw499+l/
         +I784nz962O2iRMnRMM3Lps7vQ9zBLk+S+Q1Yv3mzvR2EL3VB1lB9RklN2tqcQgGWc5h
         8XwA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771648667; x=1772253467; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVqLtu8eOSB6Ez9slneFXi1iVxb6lz795QLLkkZvzKM=;
        b=lfCmJ1HDBFBvCtl1Al5yaWyj/pLU/7RKPVxIvBmRvftuxPy9vAGzvs1PmCyYZtPQH9
         hXI+mRA3M0Oo9a9XV25vDd9NXIuHh9SutWbWZcza4ZM/9YbZfGlMm0MTDjicJ7HvtAdv
         FCYaYpN3yLtDH62MyOn0RFUtElnVX/Icbm+5jj2Sx7yEpfqdeZqo97RnzV8R33wExmRW
         vYAZU3KxJqq8bkVLZJ9YCx5NuKA2/pIsESkum0ToG5KeT2aP6DbWI4uVZL+zY/3OsBV8
         lbimn0Elk3X1/1jUPoYNcVXei4D7DInLujBtHbiI9V/Dhxr5Ytedou4ZQA+ONzF2y3MW
         Hg6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771648667; x=1772253467;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BVqLtu8eOSB6Ez9slneFXi1iVxb6lz795QLLkkZvzKM=;
        b=tDGeSOr8/RqlJrKHGZJImtJOJwbjIH8kWwIg+BO4c1I3ZTYl3tKH5aDI1jNun8Km1e
         T19dsKpEZNgTRkXaASJp8vdN/Ua4U73NQ2s/FSSSUxUL8MCGb4sJuTzzOsKbZSSY2lty
         U4g2HqbnXX9SnwcPz1NJslFQCG50MMTEHml8x2/qiLwrvo3YB3OEa1gCUkmt3F5DOoKL
         u1JQZWj76tNDIKoC+OhGfPUKGjr+tYt2hZ64+7atM0AZi9FUmTz3tgNr8osPi9+lr1LX
         /ov/1/mEp1Mw26y83umcIT1EJhpaWaEhaHO+Hv7dTsN4h3G35DyzCPDrKajBp4sXYaCg
         RC4g==
X-Forwarded-Encrypted: i=1; AJvYcCWBXYtkKj056fR5K+U2NiJCQ79IMg+LNBridc7LusbFp9h89nCM3xDnIzSpBFqKlpvIJljh9//now==@kvack.org
X-Gm-Message-State: AOJu0YzjhFheMTVurNgb2WnOulasA/N0VFl5eUPARNahw5p8V5Bo++1v
	ZWBgVOzD/gKC50ZShyi7DaM7J3+NfuNtS2QPFtnRNjIDeNjp7dxHRYrbwbdaTeW3btHv6/Db8kv
	hprA5M/ld70OxUMQ4Br6+bCgprqjTmjM=
X-Gm-Gg: AZuq6aKQrgXDCOAZGqPFLcMpreA3VvLSK7UHfFJV0Ks0VZcj0XqKwhwNfXrZdt/5rdN
	HtLlAhJPTT6Ntfku4sQRNKiX0SjSHrw26xUUr35rHAxh84zB+u+sKFfmee3j3k0N9LhnZg46vZd
	E3YzteFYWddXZz9NYjflFOZqWMYpJBU9V27utvxNqtopQkr+qvkan55V0vgEpIWWP4Eu+kqL1At
	iSVvCxpo9qTOfRlFM86VSqbHy+jeA+d/wF7d1xTGRbM6uLEt3bEEE3Vf9OyCm89nDudwXtht09+
	uWZafs0Gbv7MfG2rK/CrgL0J+O77PfD5CrIMkUpKdOuNQGcuwsmV2VmdQPgvIt/iLAsCHCYe
X-Received: by 2002:a05:690e:5cc:b0:64a:e142:a099 with SMTP id
 956f58d0204a3-64c78e373e3mr1335884d50.41.1771648666835; Fri, 20 Feb 2026
 20:37:46 -0800 (PST)
MIME-Version: 1.0
References: <20260209033558.22943-1-kartikey406@gmail.com> <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org> <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org> <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
 <CAEvNRgFw_P-GZ=Z4irGheM4O-RnXkd_bdAd0AT7fUuwXEnSqHQ@mail.gmail.com>
 <c4c06a75-e50e-4530-80e3-13724c08a949@kernel.org> <CAEvNRgGg245-TQn2HFSadZ7gmz-FxsAQ6=N14BUgiYGHhZeLeQ@mail.gmail.com>
 <bac19363-0705-4bb2-b022-66054e1f28cd@kernel.org> <CAEvNRgH6yfFtOK3E3__hCjkNTQr55y-_N=SpBBr0i9_q6E2_8g@mail.gmail.com>
 <5eb7aae7-f642-43d2-810b-d7afd867d665@kernel.org> <CAEvNRgHegcz3ro35ixkDw39ES8=U6rs6S7iP0gkR9enr7HoGtA@mail.gmail.com>
 <CADhLXY6zzWJnu9ZLH8jThMx=z6JpYmnB_jdxRJe=QVjEMu6WFg@mail.gmail.com> <f3252a77-f41a-430a-bbb5-2f6d3c8a7c2c@kernel.org>
In-Reply-To: <f3252a77-f41a-430a-bbb5-2f6d3c8a7c2c@kernel.org>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Sat, 21 Feb 2026 10:07:35 +0530
X-Gm-Features: AaiRm52METFgUoMNRW-ylcUv9TZMGPAbl_rmK9yVj_hA2pPt2vz-eO7viEqmND0
Message-ID: <CADhLXY5GpPAD-nKZq-eP284cgP9KSh0RJs+0HRfEXZgka7DErg@mail.gmail.com>
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in file_thp_enabled()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ackerley Tng <ackerleytng@google.com>, akpm@linux-foundation.org, 
	lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, seanjc@google.com, pbonzini@redhat.com, 
	michael.roth@amd.com, vannapurve@google.com, ziy@nvidia.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com, 
	Fangrui Song <i@maskray.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E77134000A
X-Stat-Signature: nq1r1htjw6sjfs1r79f5e4x8oahh1nhx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771648667-156031
X-HE-Meta: U2FsdGVkX19WhEGvKw6JT2bco7y1lrsy9VHpTtgPB4oM7jSsOSt35agkGiOAs2H4fuj3RCyG4Fow6UHTJoRJ9t1rdCPr2erTLI8TSAsip1YLS0zvMoN1rFAm46cNzcAV/Epa0rzD/q7sRZudlcSP9KO+2tgwHPDBfPlMtIbKJ+2wGkEZL0RTQF+iZXJiLNdpxGsglYj7u1PvF+tsui7eF1zPt2G7wZW9UUAlRd84em6K0mEuHr1U9csInobscoKgwEFsedWupzN5mSFy+U0C8gshIhnm52pMMDAg0gx85mN7T2vmx3YP8fs6m1EKQtVGe82E5Xw/8Ku4FKDpc0/kHLL01ZnjHgXwSn8pcSsOSrlmrwjttFQ0wDd9mtz9O7vuVA3pwGxOh5WH0ZXDEvUAPmi7cYCwKtobOQjlyP6eSgq45vJI+p7I2dlq+vierV31tDz2/SfN+0ciVoTVEjWGuM4MG2k/vNf8iAwrRBYpGsZMpGbhH/c5c7vY+BKUySb3am5jPEfOt1T+902GmfPgB4Um2q3edieUmqQ/2clgdVrBHCEfEcryH6PhQLnfBtc1w5Uv9fin1vdcNUCDnz06Q91Nu6JR3beTXC0B2B1RTX1KGp36hfZ3X/P2IowwIGeOv6JwtUbKLQ4KspTdZYaj3r6qv22UMrZ40ecVeN4poBTU4lsiuEbP1cZFN7fxMolFK7HAcK8n8KTA9xdnkrB1G9RPondl6C+9UXplyQBk4yhUNd056ys5NDnfLRsuo4GMbvxND8JcMlQQoE9sWFOK9gpi9INY66rkKii9TYG4usenPV1/iMEtTR8m1QAcWymPVMj0tKEsI1IIYIKLdHuumNzDt9a94M2lJziQYrdJWO5xA/n9FtnNytq2qQjgC+57ES2RL4T35lOieN4ZgMi+mf5QgdmE88TrsTsEDIX0avt9VVTlyl9YZ9/VHfC8/JZTxWjW9mWka7O0WDWdBkJ
 f5qQA7oO
 7aUYOh4rHWoRKLJeYgQgMMRRg1qVkhq1Knw3rRDHbTzco2oGZPWFyXw4xtJnWQkvlSelkdRydvFtjbMGOa0HPXMfruU+5DRMfhLxKDpnx+NUTSVXFEDHl1rk9PYYbaQRx93AXVcRmuh+9Ci4gOeZ2ng50d9RlAWhsGaIpPrFQKhV2e9s/Gbsl4Fr6Jd88lwlbHcvyhwyjbtzf9npeLnjcBfZf3RXwDxRoWdkpoQVFf4qUukqNf7JQKH0TuXjkUzkcR0wKnFjnwka2r0BcA1CR/y/j7czPgu6mlL2Cflfd0eo7KeJkGfo44ZOLPuXZ22R3ygsk3hReOPTPz7DSLRPA1wBb8dO+NCxLpHQBQqaycYEIh1u8ubSMFfHond0f4N3yrF46flTFUN9F7CONi1F6aPopl22jh/mm28vRaMmAz28NY095dzDtaFkUMoNHTGy5IzHuHKtfJLYqtbj95bxFaZYOpJ/lN4nsvC+xIfMCXxtdK9Wpao0pWQSTzQu35aM9HpeFZroSU4fRin6Nl4MZPczk4Dqb9pbf+JhRL9/XZxqs31RGo2+RNuStu3fm6/yBkYHotivsPO/gYSNkrqcAXCCrxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 2:36=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>

> > For 6.12 stable backport:
> >    - IS_ANON_FILE / S_ANON_INODE does not exist in 6.12, so use
> >      mapping_inaccessible() || secretmem_mapping() in file_thp_enabled(=
)
> >      instead
>
> I think secretmem_mapping() is sufficient there given that guest_memfd
> does not apply yet.
>
> But we can discuss the details about the backport once the upstream fix
> is in.
>

Subject: Re: [PATCH v2] mm: thp: deny THP for files on anonymous inodes

Hi David,

The upstream fix is now in mm-unstable and linux-next. Should I send a
backport for 6.12 stable?

Since IS_ANON_FILE / S_ANON_INODE does not exist in 6.12, I was
planning to use secretmem_mapping() in file_thp_enabled() as you
suggested. guest_memfd mmap is not present in 6.12 so only secretmem
needs fixing there.

Thanks,
Deepanshu

