Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A1DFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C3E6B00A6; Wed,  1 Jul 2026 00:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4CA56B00A8; Wed,  1 Jul 2026 00:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B16136B00A9; Wed,  1 Jul 2026 00:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 827646B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:01:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EEB811401F5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:01:21 +0000 (UTC)
X-FDA: 84938857962.17.4D43FA9
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 01A8680003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:01:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=py9670J3;
	spf=pass (imf30.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782878480;
	b=awHzcaYKSIDME/sh5RmSQoIHyBoJbZJfaObZ23m/QybdAHqq6GNzDrCtbags36WPyqDDL3
	H4T8mTyeZ92zkTf/b0BIeWVI/vTFcuoGH7hvPQeigyMueUCS+5xA+jj1lRCToBoMKiiz1n
	IbplQ6xlLluAs8xIBu/p1P3kRwpkruA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782878480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
	b=FjnjkpXQu+B4K9KgplFNNJ2JzCvUFp3oZfGaJNH/XL+PTIdzDs7zjzYb62D/3nr2MITeZJ
	SGCqqEG/pG2UJX1L3tnpyS9ssvzl3DbOVzFtBK4RG2C5uu5R9elwCoMWfYlx3YmBBtJWMq
	/FH9AJJzWDNoBnHNxgidXuhZ7JfxEh4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=py9670J3;
	spf=pass (imf30.hostedemail.com: domain of safinaskar@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c128cc012b4so25937766b.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:01:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782878478; cv=none;
        d=google.com; s=arc-20260327;
        b=WaDhCrbB/iMDWDocuyuqL6Vhsu/4zMbgIizRmMcWTquhTgUsHON0/6V0t6kvVdBUJl
         y/KThMQbJqAkmBymkiV8Jgg4J9P0BS88KXKDTk5sdpgYPmx6wAYe2vJBW3b4qHX4OZQP
         CZRRo+8CDvUBfv9l253fiEuYm6P6+rkuUM7DK+d2UJDqT0zqJUL7cpLLXPoR6mPiseFd
         6BVA9Jb8DNSIok89gxQ3+4AZErOi3WxEI4RZpb2pqZSy2C3PuMAfJk1FSqNO4ZjNlR97
         +EDkZ6Ycq/L4kJl5a1KR4dmH+3rr9218aft4RQYND2oKW1UwA/c/WFKKOg5I7kdOjSIj
         5s9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
        fh=bnUpiBkV9VCGpw7ZbkXxEgIWu/vKVip8QcWOi9wMlt0=;
        b=LLs9NaUnSbMQyTIL8/NNI0aK6Nq63t5vKJC1AsLU9xuuotBW8wfgXfv6OM+x3UZoto
         HT+a1hgr356pkNSQLWeZ/6mUhfZMZy3hJnvmjsHe79qCy2SBvmYOox2sMkN6u7ULWh3y
         uqiHl3lTvf8fjzU5Db4Nt6FI/MzquYJCsS/SH+OAVxS/HL1woatP1vranNhpyPwz0EtQ
         hlOgKdcoY95SgqGSP9Lcapq8iBTQE9ceAlYmI+8uXwEuOjsj9swifSDdAWp7bJghn9Av
         8p6/w7Ejqw+HzaX1too+Q68F60lcW5VZ5Ju4LVySmFuSOMrgVNPAa7Y81wd52uubIOKg
         ZuYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782878478; x=1783483278; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
        b=py9670J3Kef3b/0Na/NmMEDSh7cQGIjVaZy1MSG5tzzEnqNAfrc+BjFDDioJL2rYYG
         hgpoEK/9wjJ9tqkUBZP6bRwNtujS0OVVJTqRy0DAGcdQZS6QoxgSFe8+CdhGcMiC1K96
         LIbexRzcjULoHwFt5mwvgUAVjZbK+uavM7yVnjVn25qR5yYJpWY4S0WqrNxY1MwWRdln
         Tu/OGpAZ0LJu2UjzszZmBDuify92ZjEI41RmCBAjh7WKljqplp8mjV1yfu03XiZdye8O
         IcSTkBNodQqn55XStEM+WaUHFfjtozPMzdaZS5xLRwBNpOrDCJDYPzZLozhFMzhfA+sl
         0SCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782878478; x=1783483278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nbcaEzsRX9Wd5cutUSGHKNyzPWPZ9Pa/dME/ipm/wTw=;
        b=gP1TQdYockk6A/WzOOC/OvjlWLhjaiRUDLUFtjNI7MLkWemLaWDlBHSj2AgHzpQNL+
         dxaqoIQh2j4amUhMxnCwDs7PXlw+yN1BjszIN8JkssOhMQZNl/dupRG/1bfibxgi50js
         qUZSwEY2uUo8+ZrzQFu1zTrO6GhrsiKI/C7p5w344folE3a7m8ZyYDsy6EaKBC3e8fUN
         kbPk4NNp+kNUVGdGHbEnYjUdSN4sckZnxmeCYjF0Dg3IBxQ4muJG/5lXTFYQLjaOg4kw
         CXcQsSwINaIPCgwe0q1nZStpra+X2QXOWE5Cdwbl8jtfN2tT5KY0SjeJVoAEmyngCl06
         ZinA==
X-Forwarded-Encrypted: i=1; AHgh+RqY8moTN7mn5nDnG9kEkc2pZK1WoA3G3yeotkF6h+x3qiJBzc9v6WqhMB2j7vSv4IKumUo3VpOtzQ==@kvack.org
X-Gm-Message-State: AOJu0YxppvTsK/S5z0j6d3ZmWM+E6/aWFS4YaygMmo01vSngb0jw7su6
	Eh1lmWjYwFWTVAZ7JNRYSutVrxMem5Cjd44n7RQ4eZ55ZMPnkl+CpYMOXQdaeTHvv20DCMtax4t
	1foVS38PNEqo8fbdYGxj/WfQvEeAPX34=
X-Gm-Gg: AfdE7ckRykuB/DaPilG72S89S+DtuJVYpjuggAK5texuDJCSBYtlmj2xeJ7ik6/O9Hu
	KtgunH1KqX6/4lfKbLm62f3OJaJ3JXuRFazjfNCQxGgULAwnIj5VV4u4ZCIqlHSt/+qLTGBKpyV
	APi4CZ37Giu9BvPUpfJXA81RSNT1A5glcb6GQCC58PsPor/mddxO0mw4XxtSD+L3D49dBZRtB+R
	Rc1cYkXaVVrT5VQ6iuZonOLA5GpZNR220xWcktzEimGo/CbqaZyTsqU1vXO1CVVRCYSHXcy1lFK
	DGgVFVI=
X-Received: by 2002:a17:907:9694:b0:c0d:7c31:26a9 with SMTP id
 a640c23a62f3a-c12a79b53f2mr2792166b.2.1782878477949; Tue, 30 Jun 2026
 21:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <89ea76b3-e956-4232-8180-ee3929adf905@kernel.org>
 <20260625101132.3859505-1-safinaskar@gmail.com> <63f7860c-4f5c-4682-8914-27978b9fbfe1@kernel.org>
 <20260629-bauland-knabbern-abgeladen-c0acbfa62cc2@brauner>
In-Reply-To: <20260629-bauland-knabbern-abgeladen-c0acbfa62cc2@brauner>
From: Askar Safin <safinaskar@gmail.com>
Date: Wed, 1 Jul 2026 07:00:41 +0300
X-Gm-Features: AVVi8CdRVGURQNkveI8Kk-KHYrlO3h9NseHLMt2SfGvb89Oznrvksp3ZeC4J-SY
Message-ID: <CAPnZJGAJROqfCWSeeBu31HsE6nmgxVqHTNeC554S5y1Y-VN19w@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] vmsplice: fix some problems in my previous
 vmsplice patchset
To: Christian Brauner <brauner@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, avagin@gmail.com, 
	axboe@kernel.dk, collin.funk1@gmail.com, david.laight.linux@gmail.com, 
	dhowells@redhat.com, fuse-devel@lists.linux.dev, hch@infradead.org, 
	jack@suse.cz, joannelkoong@gmail.com, kernel@infinite-source.de, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, luto@amacapital.net, 
	metze@samba.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org, 
	val@packett.cool, viro@zeniv.linux.org.uk, w@1wt.eu, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01A8680003
X-Rspam-User: 
X-Stat-Signature: tgagr6rm1japiaorqpxz4pp4dm8ueafe
X-HE-Tag: 1782878479-34672
X-HE-Meta: U2FsdGVkX18aJoit8Cbsu9nj34IShAbhLcRw/K7SxweYmCt7KMG103/H0M71zY/SMbAkVHIjprtSDRPU3IxBqO/Uqu+OEyEnBvu7EqQLCqFoGRHJEqy1AYMBeDsVaTHReXankpscRqA/SzWHlyqiWyrRp9aDfWv0UXD5GocBDAloIxxM+1lCBjgnxe9ImsSOalZvz75lacY8M4XjsIYZyxrG3ifz8BSwIDyf1TLQhT23hL6jR6cPM0ettTZgiN4+49TMuE+FRE8TIZAwUBDjHxLyN/1YBMVbDwvC/VcJbnhhKi0uDiax6cKHPOrV+IaqTXKRDil0cEDqERkL2FJZ80lWVBhnHyassNNDlGiwQI8MRV5Jp7akWs5HaKin1m+ADoU/2OhHDzOS1cP2LnFNPIHKL9Igl4s6tyrD9lcOPbxEy+TDmdNegIQGI4meNow4D1KUi7uz1kq7Qyzh9rGlukDsrw1nN/xtCPkOS7V7Y3xH3wrRX3rTZz5K85D+OT+Xh3SvXUoxgFKbkiByjkDy9LmAOeKVs5B2BW5FQFoZoIQjvpc4YyrG1wDtzXJp8HS5CJ37FeFBcV4dRdXgGbIDb6YRCuGrITmrIuiX/uTbqEuBMnTX+sT4JLPrAqWnQhSxsQ8smDcy9YGt3wK5BJru9h/eLDWLBykYOOdvGVWX8RQdE5hIHy5ZP0JVd4iQnL65uvlKlFRSw58seea/NRciickDGtNwg6guDwKY5yssaHz9RB+F6iZMRkT7aEcKzRIvi9qOjXV8GGRjUf1fRQjS6QNJpFjcOot9swz+VOv14SLz6m4ZHdO5UfWv+ugbO3MnInHw/rIyhQtV3vZ87s+r3dDhPrdxCbrH/Yg4ffPeyPINIF2n1yNOF2ViDJA9/N19IL1F47dkfudKY1jYi4ooOddYih0a2TM7aWdJ7N7IT0vmO1WajiWwE6+p7h707du4tr0kT2wW/bOSbhz+1ff
 Qi8disW+
 uD1Q3G2MXkecFMVqWcAgikcKs+S8eODe1yJ5rJXEmoT1plCnoyM0Qq8jZSN5fW1ScREJFbp/uwfPFjfdJ4lD3p3j7JW6cqFBf1YrSHB2ySQUOUHYOXmBHOxDoypcFaVICajGe9++NMFo7SHBCyz9EAeVaXl0EuQrlbqutyGFROV2TzD/WI8VOHreXY5dhvtHT4dcX9lbbl60v0ysRjGJWSjOZdNn57gf6Y4lke8BIBKE55aEC5uuswlJHVRVPuTgYAiUfovuN8EsJaI6p4s24sK69IoymvaOhZzj94rW9viZIILMQRgC5v4yyTzikK4DEx0zJ4p69UIULwxzrNraOxFW4TwmswZgZoV16m+v2vAKv83uE8knJTnqP1ZMrnb0Kgn7AabcaW1R7dyX6J9XZqqLrHLHDTBQmpmCGg6fSz76BGO61Mi3qFx5nLrrttL+rlYH2C+7ZDZ3oSReS6uI9NsnScQQj3ZRXjQcG66EhMsCMW/n/7yPp1E8KUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:56=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
> The amount of regression reports that we got in short succession doesn't
> make it likely that we can merge a plain degradation.

Let me repeat: this v2 patchset fixes all regressions found so far,
except for major CRIU performance regression

--=20
Askar Safin

