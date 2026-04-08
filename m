Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3867C10F995A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 16:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90DE36B0088; Wed,  8 Apr 2026 12:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5966B0089; Wed,  8 Apr 2026 12:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FB6D6B008A; Wed,  8 Apr 2026 12:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1016B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:27:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 215911A01F2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:27:45 +0000 (UTC)
X-FDA: 84635919690.20.31909BE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1F8F440003
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:27:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cznLZ2Ek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775665663; a=rsa-sha256;
	cv=none;
	b=oFUiEdpqomvqaFYG9940MpzVTvg/3RoEoGti6ESmY2Fr9u36RFzBoc5/214Pld5KUWmRKQ
	nZZQGrFdWWzjy7dwetDYdL691poiSjME65Ly5pXuLQzEa0YPj09EnxoTIxSq7QXpCUutxe
	f7JpD/E2AesFzGSih43KF20DtQgkKEc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cznLZ2Ek;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775665663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ufZDlKZ485/m20U7MIsmROqZ0tfCkev/WJXljvTA8O8=;
	b=wV1ItKVtLjfF48M3WAXmjgC5aAyxU1OkI2oFXYghVyxcZDTM1tlB6YlUgogdIe5eQSo8dQ
	3DM4j2waNfVswX930i1do8As+DY299na5Z4+tqUNB8T1NjkYm7P4EsYXQxqeWZ9IDjuW3y
	iTZch6NsM8Iu99TEP3dy778PGzYXXVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 65B7C60128
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8E9C4AF09
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775665662;
	bh=ufZDlKZ485/m20U7MIsmROqZ0tfCkev/WJXljvTA8O8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cznLZ2EkltNsVpFgDwbi4L7F3vTnqYBKFL6PnWs7y3A3P3fdc2FQYAtLWD3fkcsd6
	 dgeTkWNVIf1DDg6ZbgDpu+HFj4D0JWU6D9eApMUVjv2v4ySoBmwCYPlRMwim7duXmx
	 PZt8DTkem9/WIVDLCteeLMHoTfmF+yCgyTANtNV4AjJVPQm88iNs/iSecotuIbH9Ge
	 u1a00xGdCAfSSq6yvFzYiD+jcWeKLbN6/acu/IHZNcgSmFNtDL/GJgVDhnUpFh3Elp
	 LgrJu4Y9K5MfoPcKy2dXw4gw7oHIfzLqcbEsjUgk9tJx1Ny2ulKcgTK2UbBGqh5jIa
	 iIKjAlVOL/+PQ==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64ef161129bso5364964d50.1
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 09:27:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWA8HlokwOxzgoF6n9bvTbJpzVPT9uEaInZdbKlHL6bBHf0kwg8fbUiHnRg1CR+Noes14qwn2N+jw==@kvack.org
X-Gm-Message-State: AOJu0Ywo/Luw9YhINKg34zN4e0pYAoqPxlkPvo01SauKXD4FtbOQKe0I
	eYiBL6hCZzBAO0kjnEcxvM1vhda+39PybaQxMPyVrJPY3azM7VXNcpNyi8Pjmt9DabybM1c6MJ7
	WnorHtBkV3i7VSo5SrJWHgf4SmhLf9wchue780tdPIg==
X-Received: by 2002:a05:690e:4399:b0:650:849:db44 with SMTP id
 956f58d0204a3-6504880099amr14212604d50.38.1775665660473; Wed, 08 Apr 2026
 09:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260328075812.11060-1-21cnbao@gmail.com> <20260328075812.11060-3-21cnbao@gmail.com>
 <CACePvbXVaK0McYSr8O7h2XMpEh1f1JGzLVJQd69V0QnFXr8Evw@mail.gmail.com>
 <adXxdLSHp2E2k6_5@MiWiFi-R3L-srv> <CACePvbVwoqdOmMWkJUm=mqYQi=MgK+Q3NJu1Pxmmy9v61f4qEA@mail.gmail.com>
 <adZ4LehwC9KisuXf@MiWiFi-R3L-srv>
In-Reply-To: <adZ4LehwC9KisuXf@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 8 Apr 2026 09:27:27 -0700
X-Gmail-Original-Message-ID: <CACePvbV66RRGg-q8mBE6sPa08drVc_NV_HW5QjrUw+hL+=JDaw@mail.gmail.com>
X-Gm-Features: AQROBzA_fBJ_v1JAHE3_gK85XTS-joyU9CVb59g4PKnHlHNEu7EFFx4hnZT3QTY
Message-ID: <CACePvbV66RRGg-q8mBE6sPa08drVc_NV_HW5QjrUw+hL+=JDaw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <bhe@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rsxajzbc737nmwhfohdmy5hbc9wpm3cu
X-Rspamd-Queue-Id: 1F8F440003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775665662-252138
X-HE-Meta: U2FsdGVkX1/EnYWaxL6ShZB0t7FRrtmZr6koKD0e07tL378ZE0WV0898uArpp4Xkt7iGZ8fK1btn9kBqZyuVvbSeXYfv07hDM34Uhk1rVYyVaHLXWNI81Esm/yMd/4I0sZiPDFQuZFouogycGJdN0x3Ar+quIiwG2XMSautpM1+OKz+hy4xgMhayVsYykPcCJCsJdQu3PAxxSnoUe5XX1joclLtzEs/oJkPOWQfnxrAeo+IJJRYvb/C6mp/wECRdvK0TMhsxGP+dtw2DYzCDcd4+/xCorEWWysfZu9H50jBvQDLyFariYNXbR4UZMF5HTLJe6XBTSTaHf58FZq+bXjpg0A6vWTVj9YgaCXfmacOtreqSuCQL9WJwV/uS4vLi1NCYnHMbRnO2PMkt5xmwz5GvMk+LqWcp8AndQSgeAFNUMQpKcOR2fA1O/bFZ7JMq8O3P8/0+q+SC1+x/Ic1LioxQtnICBojtlneL2HgMUxyYEp6NWVhpiiJu9G1DfbdF0g3A8hwn2eRht0PikFznbAvA/0LHQ8B2SDKaSYYCGcBQJM/ZLpa0Id3fipOI2RXV7N9KqgnTFoLKoQjHYVpTfM770A9tCIJJDyPu7YmheByudGabA1enirVgRwMH0F2ODLKqA4pWBYb+FJmPeh15cBqro2F+HWWY00cS1S4g3G7/SoM+mAOLnwwP1FKkM8nbIyMvMzQS8UeIy7yes75hh09PUlOUqsGjFFIuVhj2ngEMKvl2OsqYsRRZPb3x0iDh9rxPRxxXzbaH5b479lk6qcbyznIPAqaOKVw2ZWa6eBPYne68eI8l+8NVkAUCVr8mF2pcEIp6a/XOEByTC2XmKDBqer3Lp2nYlgaaxZnDfFaE1xTNhzE0HJgTZPSD/oSlAMddj/zmxf4WaZ/aKsdn/Gab5eoTCDbOZorVU6Z0gHgFvLJa4uRfSIsv2mzdTzlrzU+A14xi4AoQepKSZDV
 fhDA9jHO
 L9pnooR456OOGD3UUplzyXPsBFvZez86I/B3Eyb9vs8GyJHg+Ef4M5O2aLgqdByqATm0CD19XA/AALBobhDTbF9nmrcItZ3BQWZ3DMH04nANa7k5sEWK+rHcl5yGKC4C1QgdOvgimwk0eaqRn1WdHVvM1+D7paJ2aI+6uMrAJn7wmcGxbXLrIXd9h8Lk3+yJSdPXW5eRKIXfEaVD45Hagmg8SYijlw9kAWu9aDH6HpiDKcrNswXa2ZwoSZelTisicsej4+sAREDeQmcymkui1tBw3cDcvUPRAVzQDVY2e88P4grSNUHX+MdP4EGFZ4w0QMAhfk+PqJBIx50Hszq9I56mMzE6HCnjGz+bRlY40Ep03UCbD6kAB45S81g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 8, 2026 at 8:46=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
> Both is fine to me. I will change to do the checking in
> setup_swap_ops(). By the way, I tend to rename setup_swap_ops() as
> init_swap_ops(), is it OK to you?

Sure. Eventually we will need a function to detect the swap device and
decide which type of swap ops to use. This is just like in the file
system after reading the super block. The kernel need to probe which
file system driver to load.

Chris

