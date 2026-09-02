Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5523C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C31CC6B0088; Wed,  2 Sep 2026 13:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2506B008A; Wed,  2 Sep 2026 13:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8216B008C; Wed,  2 Sep 2026 13:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF276B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:21:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C95C16030F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:21:43 +0000 (UTC)
X-FDA: 85169489286.14.5AC1E4B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2D67914000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:21:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cbA0DCxQ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788369701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mbr8vDhDQK57otnRsW80mi/+agFd8G6T3W4N93pfIMo=;
	b=dX0w19Z8OurwqzJlVc8hi1+kT6eRvjQLZ1mkexsyn/tEQ8ImqbjLcUD69F4/Uh11N6lfsH
	rWfk/kd1X21YkEVqG+GNl4NzW+vhv/hOWbeacRWyXkOU7z0nUKVU0xv/hPQe/ZcLo8AHgT
	NcNr7Vrq5ZT45P213k4wsZitY6tqlYE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=cbA0DCxQ;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf26.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788369701;
	b=uulTl+okYYlgMNwKKssuYo2o2WT5bYHDWpEeWWGjhCHH9a5DoW8slWLYEhLv4zhTKYiDIU
	SAIvtKuRENxzsDYusRMiBajjDTFzWW7ZhjXyrD1CXyMllDih+r2ouu3LRl24mUvk4mLtt5
	oQvywpvO+J9YEtRnRPlbZo8t9r9k48I=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso19952025e9.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 10:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788369700; x=1788974500; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mbr8vDhDQK57otnRsW80mi/+agFd8G6T3W4N93pfIMo=;
        b=cbA0DCxQOg+j5rSH5XgVT45U/Wmg7r8mXzHIXsMEhsCmZG6aQ//AHREGRZeuHOZtwl
         4dsVZwH4vZqGu/A9RhVbr1RKF44hqSR7WR3cqhUppJY5NtVULwTeTJ1xx0qWHJOd6IDL
         bTam8koS+mk4XmspL6/g1i6Xn6VT18IwUXLKQwvLe+IjJ0QugOp+M5zPJ6zqUdHXIGNh
         XHER10crObmFWOGGmhTMIICexWQcuLdz8rZY2fWgfuJ4U1iKzo9Osl3hG6XVSM8DvFT+
         ZKozJNvS8eNIBMAqDVtz2EwaCCc9BTB+mU2vUEOulAn3YvZzXZ0l71a1o769fakca3wS
         3K4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788369700; x=1788974500;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mbr8vDhDQK57otnRsW80mi/+agFd8G6T3W4N93pfIMo=;
        b=QET6R6CQu8vT1S45cnY5dDPPiSdDl4z8x9/SVLSQxJYUoyv2ea6Q2T6eZRl+skF9AT
         eM4N+QwqIFNrDbLLJlwU5L5THiHFSS3csnR7Bmom7ab5pWxm80ofZEKiC8J2/372eWZv
         1Kv/pY3a9Rxqhy5FV58WTvOZNpcX6Ft2vtlCkTtYDjCXKHDzgNn95VEci500v1GRxWY5
         gsR2UhfOW1tpD/DEP/N6Hkap2pOh7B3qvOF+cphx43/5QE2yqojYvS/F/4xeM4sgkOcB
         cTQ0g0Up8ljHbS9YntGmo7yl3dYLgK8lHoXJXJl2BhKupFCap/8s+BmRHgtFI6LCRh1H
         2i0Q==
X-Forwarded-Encrypted: i=1; AHgh+RohLb4C/ZLQO5CKc7tVKJT7vQGCDUGNHDO37KYrH4bcnwxqJGiYcK1Bp7PMxqeaN9dz648rPElWYA==@kvack.org
X-Gm-Message-State: AFuF++mb3S4GNCWqK9tuaQgjWhRwOijPVXJoTtd6mBCCr97GTWFsORVJ
	4wGWDC61XYD1b9EsO+l8QshFbTGuwBZBSavmJGUaf1mAbjiLSiAmdWqusAQDBUrzDDc=
X-Gm-Gg: AR+sD11GPC/YShqURICI6AgwL9WZX0JoYQ6BOqpoCTy9s5CmHCXM+SaCUDlkjjgTa9z
	F00QJrh0TJbesM71uih1B8VFjHeIVpSrsh2SitIYCajc28H/trA2xYNnynRgkRWDiwlTFN2zAos
	VWrbIL0OVn7TZG2uyGMZvVb5ZhM68Y4yPf5/eT7g/V7cxnqK60Dl9+pm3zfX43XzRTxfAeNa33w
	8Y+X/TNvO0g0wsETmP2g9aCP8E31Mn//cXAMxDA16uIsj7H0H8fidQzV2hUIc6LCoEWOjNkZDka
	XAonyOFLhGvNmguzNDsqTlekuqrhwHNP7EMWCczFivFg/aaM+SfBIUNy4oAVzIHK+HknGVGXmYe
	prMtoAXD14mU8gVTbKjIXQ+im1OnoayKf5NhrqaGUwG+5dVKYrr6kkepJgYmofboCxjZuMHPp01
	KU3BWoYHjpmUjz3Sy2gfu75n5GjPZv3e7ITcI97+iTesRnD201xpHTTZDCEcEQOOc=
X-Received: by 2002:a05:600c:4592:b0:496:c1f3:e8f8 with SMTP id 5b1f17b1804b1-49ce5828104mr100735675e9.7.1788369699585;
        Wed, 02 Sep 2026 10:21:39 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce554d52esm46037545e9.3.2026.09.02.10.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 10:21:39 -0700 (PDT)
Date: Wed, 2 Sep 2026 19:21:37 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
Message-ID: <apha6cxiTEi9_FS7@localhost.localdomain>
References: <20260901052250.154532-1-wfelipe@google.com>
 <20260901052250.154532-3-wfelipe@google.com>
 <apaO1OHVQWJCuJDE@localhost.localdomain>
 <p9738q5kh9uc.fsf@wfelipe-west1.c.googlers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="brfghnffrv7lgskx"
Content-Disposition: inline
In-Reply-To: <p9738q5kh9uc.fsf@wfelipe-west1.c.googlers.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 19gj5ekz6s73rh5tp61k55w7jxynhppo
X-Rspamd-Queue-Id: 2D67914000F
X-HE-Tag: 1788369701-307472
X-HE-Meta: U2FsdGVkX18ZJE2INoy3uK1nAst9u7GerajlPtZvnOWzh7t5Tt4zF+nt5fTKq9BaQHyevcctSQBVyDqEAfn/4wuvzKtuOsa1JVU+Z5x6BPGfiJMDEod4l5Dw3wXmFgc3BdZz7yapCTVbfbREts1bwd1/BqbNO0bQ/soi6L0HWLJtTU9qt5zW5swJPeVV3PP1hatIjRDy5INZBd+1AW6SJnEYxqZOiSKHXUWRm491nURrw0/M3opbk7w9MaEsd0pnHi8czhThXcovPMOQHQVYOuFaIVIMY4Mu5fmiPAyaxJjRfbqchlTgRJkqFDc2WxXPtdBDlcxQMi70CBfOiyXZYaLNyu4ht2Z48p/TXLxk5zeER16s9GLfsabgXI8mPrhPDIMZZYY4PSmQvwqsrPcvJS2G4LCR49/ihmymI9WfEd2ZI+/2xxKYF/2ocRUs2/SRGekKufOhq04acsIzTPejoGbvdO56KQ6a2RwGJGBsuQiljN9qE+/sT5GGOmwtjyNanKsH7l9l6NacpIK37NRejvcFx3yMW5OmrNVfdT6uU0IuzeIEH9PnzXzktOsO99KWw9Xv+1+RePu15xJWuQHTNgIIfjVqAM1gll2habb0P3VgdjPjOpIzcAPUN7X3tba5F24XU5lFw5og/RLPmbHOKPuoeB5kg6iNpPsnxQzga+usL607sbNxYfhxETg+qbw1QMG9KV0QfmUtZeQcIrsAtwu5c+EIzLLqhyV+L53+FeCDZu94U5uXoMnwWntVzi1er7odC22IOBggQv+pk9p3lPxsh1JvEF5KGzksbwwNIwtoQ759T4He+AMofoGKeHZO5IRKqK/M6rB1I6eyE0CnrjFOYOBX9AMdHGSDQ9lU4IZMV1bToIJoj236IPH2s8ZI30qPIZM4gs5/fDoXQuNNAWIqKYItOdRodBK9oa1U27dFOmPuJqIzPjOhP2sh/fR9ZLx4RCVyHWX1+6Ojn2l
 9YlC2Edu
 kKIzSnTHcChUWBfMdM5QNq3/3jDiLR+rw2GOglLIcipb0QENQj/9BntsxiQjrR/HPn7x0sI5REZzhMOdfhYvnLLnObuJjnEyX6lzeGihVPQ+YTYSZNAqM8pt10kxm4hCEN9LtS3PdKgjECQJKTFwpS4+ENBt0K//ey2rl0lf3Dio8S0ZQjm3tA4uIl6LM0J/1f9v4/DVgeoMLM0YHEjXft+c83+knoq/4KWl5CFPgoPWj22HS3neWcBvWXij/bIA8sPp9QubhHl2wrzTt7xjInOMkf8er71dei+OVZrZn6fk94c8y3dFCzZz8DhMC+e10F7ijQYwnW/MYMXx+ctL5ORaYWRrit/qfXljxnyvv60vKowlrM1hDo2AJL0MlHCMrq5aE+dEq9XN3EdPWFzV6Vnds01TVr5Og/KSbxuBK4MmwLDtAPmWhR444NJX0UtRByswKF7+7WJKx8DjAxflaBnlJYFLC6VfKu0pKOD4aHXE6rJU/fxqMCPOwRPKbUIOAdvtZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--brfghnffrv7lgskx
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
MIME-Version: 1.0

On Tue, Sep 01, 2026 at 10:42:51PM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> I like this option a), any thoughts on the sequence here?
>=20
> I thought the following steps:
> 1) Add cg_read_key_s64() here and make use of it;
> 2) In another patch (probably 3/3), replace all uses of cg_read_key_long
>    by cg_read_key_s64. There are 41 uses currently.

Sounds good to me.

Michal

--brfghnffrv7lgskx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaphbHRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgYRgEAp30olA9rJ2qhGFysO4s+
aIyThbEl72AZDl4Xoxzmfa0BAPTcX/yNIMQiLrmSpdmTPSJc835GqqqammL+Cq4q
NggI
=9Inn
-----END PGP SIGNATURE-----

--brfghnffrv7lgskx--

