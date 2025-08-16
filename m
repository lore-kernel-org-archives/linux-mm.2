Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A007CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 02:23:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B247E8E0231; Fri, 15 Aug 2025 22:23:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD808E0008; Fri, 15 Aug 2025 22:23:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D33F8E0231; Fri, 15 Aug 2025 22:23:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDB48E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:23:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02902138152
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:23:25 +0000 (UTC)
X-FDA: 83781024012.06.6F6AC17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E17840008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:23:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NmfAc0Y+;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755311004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVyf4yIJq1CvgaZJAZ2g+IzjlCuLpWMkbOR1PlE3goI=;
	b=6AW5OhluqG88Cp4o06PhN2dCe2TGj+t2OLG9laZog8Fgfw94EERVR7tgIurcYHIM5tcpgM
	gYD4WaY64r+HuG7TbAiUuoVm0e6AQnEYfk/nko9soPQvsW1r1VR9jO79FsdnKyTcEQHl7o
	S4Lutc/tP/r5YRRmaXcImUEKLc0/fbg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NmfAc0Y+;
	spf=pass (imf01.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755311004; a=rsa-sha256;
	cv=none;
	b=3GkGNz4+ZRdeMDXfXCh1UQVuL1IZSIKeBuadWHztQyLLFZqaOJ8PB3f7/Ok/6cBdRjvdyQ
	M1pK7Vp4uRJKipSKFXXLtxPh1o2lvqqtk8bGU5TATnYXvFqKPUS2Xx07P9kUIFYvFYybmk
	dXn7hYYmejFY/sSq+FnSjgkI3P6EE9M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27B876141C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62A6C4CEF6
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755311002;
	bh=9nWnSWlyfK1lIcikiEsFL567zZN2chbwv83qacW7LeY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NmfAc0Y+QMCUz7KdFmIkdgVYxvRFdVm/v0BkztwcY3POTRrQBq5rRfSjKlWMLKIZ7
	 zm8pD0PJ3RF4jYupDMac+j191cthPJJPDFtdKeZgu0C3lrN+E5F8afKF/Fs4JKckRm
	 2QC2rRG5NuqoTQ5ScF09e0KL6ECWcUDnGr93SprjxTx15M+6FLa/aKR0Zz2uqK/8m7
	 iBEwoFSsfWTTyQDZ497n390C0sjH1DVG4O/GnrjOGtw070os6VK+72HrDJw8Gin66i
	 /00jDQRclwlYI/yCt7W0bBFtEFh+y8Cn9z6blUb+XkpG+ViwuGfZvf+GWqWHMafmKq
	 p/SWaoGhzDC7A==
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so35055e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:23:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWiZ32TvDPCFt9Nf3GGga8KzgQeZQYqv5Pg0UoOYumc8JmYizq3vP2pGNSN44pFBykTI8NwlTqERw==@kvack.org
X-Gm-Message-State: AOJu0Yze36QtjeZMEe85x4GSOghDISF8vFOQZENkZ4ZbFKlNlVkTCVEZ
	UqJUAOqQzkRrH2Qp8wEsHLXjkJmPPS2ub3tpxnC4nlj5LiXKVP9KcBkno44dga11zz0XOgwGYLB
	CBxghs3itMhSxbBv8zQ45LvzM1qBh/ARIEW524bcW
X-Google-Smtp-Source: AGHT+IFGXZTSemj6VU7E9uD/RJcpIkoECmdORfOfRQ3qmLGzAjhfCzIa80d2PEufH8KVTBp0MHuf8ftyJRTdOsasfJM=
X-Received: by 2002:a05:600c:5d6:b0:450:cb25:ead with SMTP id
 5b1f17b1804b1-45a26f11466mr280225e9.7.1755311001612; Fri, 15 Aug 2025
 19:23:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=Mtu3KyNUv_oWFo9vNiWKkmbzMXmG3t=XgpVtG9C_v2mA@mail.gmail.com>
 <20250816001415.90915-1-sj@kernel.org>
In-Reply-To: <20250816001415.90915-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 19:23:10 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPwfRVHpvNRr=1NT4z_3Pmr-1u4vfRYmkvh_Kh4uNGy9w@mail.gmail.com>
X-Gm-Features: Ac12FXwmB2QVQRyKxq_VZMT607goJfdRhWQV8cWYchU8wxGYBzofcFt8jwVfdNY
Message-ID: <CAF8kJuPwfRVHpvNRr=1NT4z_3Pmr-1u4vfRYmkvh_Kh4uNGy9w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E17840008
X-Stat-Signature: 9d74d9m9wsbcngpebdwquho7s6wiwhf3
X-Rspam-User: 
X-HE-Tag: 1755311003-61227
X-HE-Meta: U2FsdGVkX19n58JJxxNMGMqFGDseNzOrycnxljmIsmWBihrL9jdf5ttyNZoRUKdA6H+u8qwn1QHmD5xTiHVdZ3v6lxCUz02ojlASXaKjt/P43sMNHhsEoHRUn3byqWRQ+L3aG4p8m1pUFceHKCX2wVBINQ1Xeuz8La6eQMErgqCGXsaGj+QsN9EzaofJta17xwjhh275V2oA4g4HSDBIImWt8G482HihhCdqmezKWnZKD3NM5N33V0RbuG9kEiAjNnfTdiY+SUeCq9RVQcB6ek8QTbimrb5qyKn0KTchvKwVOyV/L1ahSIzv+mxMvM0yHOnKlX4SxPzspJlsofoWzjawoN76GrlJSuGgb9rDYAE9mVMV4okbjH5CMNPLs02K7Y9eJfV/o3qmWWU2Luwo3HTgF38PogVbd7JgQ6/ni0e5rtoN+hbJF3CJOBVULzPzCWshkN97mha3+GJrmoKs8DbRxMStgizBKjoksF3sIQkJSeL8GQr/UGaKy4H/eyFIVqcmiceoDIPUwJv7+BicatvAG8hpsWofBvX1PQPf4hqv5NFc8dsusQoyNFGcmhnEyKtesBctIOGVGP0efajskpJF7OK1pCsRCFlRPA0mrnjOTPsL4PLrtOEbUPhN6RA+NZApWe/J+Y59ViNMajQJ8R7cA05EPltFbycm9uAXHSeIVh6l1mSHed7c5R0NQANSCVPlwoIJsOOTMapybhzYN1kPJyXoo/jLkfi8y+MmmYEplSrGiudNpnJchtwgotlaBPr3LGdGqDPVOIdntRYqObF+HlpsIGnwxYULW/wukUjK6fDOf5E6+REIbbRl3+1kmqDbubZfKR8eq0mSz7JoXpsKTTL/wMF7TbCsZD6hSZG6JhtcnW05oiEyp63gxMLh5Un3pFl84LwVUH+KSvDRD4iw1Yzzp8T4O2J5i5VnoNjW4n2XceT5gWamKTbiZayQjxgWuUeGkhAOQnPbVnF
 Qo3Yyd3h
 SaZYBwVOfn62lWEr2ZbFOcAP9r5M4psFJugwqFAH+ScGc/8AtYuEWCoeFY4aOjJ+08NzlcIgVleemGTPrvGPbkY9vEPnARTNhf7rt/Bt0k/CJIJNxJwT1re6JlQcuizXQ+BZLBJWvpxgm1/XlwxNAxw01icrHbsN7JbMPU0G9Vv3m8nYaLdkCHzIogK8ky0sKyKWb0mQtIY9Q+RW1wYvkmMTwKHQQ8oY282Zz5RC/Gae4DofNDsV5rggpCMvgrWhqHLmWH/tVh8nixDAHc1y+Ey3E5mc7XM93W8QIa3zhJ88mqt9LpxL/2L2rXWZl9AwC57I+SoiTrq1/yLr1z09JqP2qXkBnjdNRdBAV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 5:14=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> Sounds good.  So in the next version (v4), I will drop compress_fail.  In=
stead,
> I will add two new counters, namely compress_engine_fail and the new atom=
ic
> counter, say, stored_uncompressed_pages.  Please suggest better names or
> correct me if I'm missing some of your points.

Sounds great. As I suggest in my other email, if up to me,

"crypto_compress_fail" and "stored_incompressible_pages"

Thanks!

Chris

