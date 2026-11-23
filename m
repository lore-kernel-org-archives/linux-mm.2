Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F10606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a/NsoHrF
Received: by kanga.kvack.org (Postfix)
	id 160E46B05C1; Mon, 23 Nov 2026 07:02:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138E56B05C2; Mon, 23 Nov 2026 07:02:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028926B05C3; Mon, 23 Nov 2026 07:02:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB3E16B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:02:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1D54C031C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:02:52 +0000 (UTC)
X-FDA: 85466247384.30.F61DF21
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 09DE880010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:02:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="a/NsoHrF";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795435371;
	b=1G6fLpFIWhCHBJuUAABARiR3I+iEELn/Qs8jQbxxZfnFKixVqZR5IwJzjAWbeqHVL6WPdr
	WWPZSjeXBKLdeTMNBJKtaSK+Sz2R7UAc8w+3fmRlTlaJSkFjMQV0FDpyfVmNdZfrRyx20U
	NWPT2JXjo5Vd5FLK4I+1nIKynCfdhwE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795435371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEYCsDgrLbetznMLuynoSw9eu0G6R9GrkBLNrIpjTxs=;
	b=QL/3u05wax/9LoHC+q4hcEd5SN2TDVKn1NkR0dcoOaPlGy9Bg0xuMhCZ1chUwogLYjbQuO
	4sRiEY/lnZZPGzy5R2EFEtwU/vEMEXxWJot9pugXd1uuW7zKUTvCpw0ATG+K1Wk9nMwH79
	eydNG1JVx057/PTCKqujwJAhIzJUz9E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="a/NsoHrF";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1a2761c69fbso1853766c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795435370; x=1796040170; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aEYCsDgrLbetznMLuynoSw9eu0G6R9GrkBLNrIpjTxs=;
        b=a/NsoHrFugud7TJi5sLYnDYWkn5EREEypaYvmoYnLtShjc5o2F732pqa02chgOp95s
         HS7LADkWhQYolec1wsGgJWUgYNON78D9iHzIT8DDcuYhqqijZdJBGNMxLtzMVv0P3Bt4
         bQfU/OQw850aTSyemffWF9Ig2ZjnSpsy9/720HbjC8HqT5H5448yXcqddj3ADbPbXY77
         U17ipbjxubSDfPILPOYDB+FzqvC03Q2e3er4Cpx9MDSNqhuvtUOfthdT8sqnlCMPq95k
         6nlkgDjRjTsw5jnkPmwFu4rcDlvNM57E/SvvaDrP4WW87IhoAl4SNvSu1XzeTtgXTCe9
         apNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795435370; x=1796040170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aEYCsDgrLbetznMLuynoSw9eu0G6R9GrkBLNrIpjTxs=;
        b=k3Xp7jusCYLKk/vFhX+Y/TGSdIWuORY+wcJRNw0P2kYLwgx9IPIOqxQ1uKqxm4LQZr
         0BxaBhNmyTzcN28ZwgI8MQpEBIHDQs5aI/t5DQRnY9bKjKgErHB6QG7o6CTka5X9CPB3
         ZXvcXCVyD3VwC+9EAoNOOTxPXZMjxORfs4+hK0CIqEiY6aCBuwJQJIjeI7HM4Z48x39A
         vNIgoxa/q5RHlTGNQQGbGfsXf7Z9MLPNDHLSLQB1NjnjgEjzNKYXJRv+VE9bRMrl4cSW
         rrsOMkUtq4fghEkD8OSN/jeFChW/kSItnwy5QVg7EZKOJNGDOBDQxb7ClzvdeO26RshE
         21dA==
X-Forwarded-Encrypted: i=1; AL+hErF4RWz2JnSl13xSXv3JPkheGrzgaX/7iIP9GNChfL6OKgRFTQYjAoQ7CDr5vfdoe91Tj0h80V5vpg==@kvack.org
X-Gm-Message-State: APuU4Z81JB3UyJsi3VZcLnkw2Z60WE9bZIFH4lcyNuiMA24DcTgytmTk
	d3Nq7KqdYcF0c9xMmK4W96qObrBzUhe7ba3Y+ti49hWvXdMPD838yWfg
X-Gm-Gg: AZFdTZdDG8HdvJk0mABlhe+IVgr7KZJx1RLEJLjHL/3DaUfwwCKqBbzKfTWY0CVw3UI
	j+63HfedOs9jNgw63zIUpb0+QrSG9SdPIeXwmCxzyun/r+Eo27k8m1QDJvv8VNt6X8ueCgK3JUp
	bYsUzkAqznz6VYKhluoeEkOopTs3eL2o4qxCXPBWNdkJz5dxTzcntqRyLcgK5acx19xOU7ivFNG
	lfiqti4Ul2+cGf7tGroarznT3yMiz4J4tGw/QT5hrPvqqs2Sf1WcW5ZVmMPH1otO0EHW202dBxS
	ZkdEGQFdaZqEVd0SynrVCH47EjM9J8dNfjlK5P8vKdyC5BBTeNNf2CAD4ej7T2usD4/cRjqOSTl
	s0SMFgCwEGHmHdjrNdWG/QT2NhcxLH+MWD2GzMnkLUYrV1YC5vkDu3UH4S/Qg6LAbbQGaqB17g9
	Ej1bGMHZ21MaupGbkFKdcl1+YbvG8wotDiP2bCiSDm9nRUOHVKdjLVPocuFcxN1g9UTDnqfLfv5
	jV4tziqUeuhoCrzsmUU1b2CmFjteFJaemH7KiFG3c01Jax3DUu1rKtnm7E1PsdqvtkShbXJC1U8
	wgTC5CeTgIwqdEHRYt18eVCa23UWrzSLDU3N4SppbvcZgOthErii/aeYxdRhKA1axqN6hcdXrmp
	inF1JwcryPvLnxA==
X-Received: by 2002:a05:7022:1587:b0:1b2:6d5b:36bc with SMTP id a92af1059eb24-1b5568efd35mr13570989c88.23.1795435369489;
        Mon, 23 Nov 2026 04:02:49 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5568592adsm27453682c88.15.2026.11.23.04.02.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 04:02:49 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 20/27] mm/damon/api: introduce user_report report type
Date: Mon, 23 Nov 2026 20:02:34 +0800
Message-ID: <20261123120240.9394-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261121210013.130397-21-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org> <20261121210013.130397-21-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 09DE880010
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: wcbnp6n1g6p9usu9qunazncbbcgwoo89
X-HE-Tag: 1795435370-177200
X-HE-Meta: U2FsdGVkX1+w2lw2WI4d9djUL8MU8WD5FzG+0dA9NcSpKqGaEgtisVR+n49aAdLJF8QghsuZ7jyLN1K8qxX5JoJm4zEuEcEINYKJyI0HB4XXaXvp0vR4g+o5713lh40N7wszsZCO/XJToqLLv8VvnIlRmNjjVvxCeyFLddjWllr9YrDFizpYUcEO4Xu6dYcMZkxT9G9HWokUYMRrJ5VWy0a87+ikG3Cx0OoFrpBZu63ORsj5Q/7uOBuklAORb57+fLbfTJufqM7PEmMWBuibeXSASHc+cVi26pzsfZYIFyejceQ88dgiHc6lcG8w2cKHqqtCvxaqUe/W78TI3ojpMbRQih29R0CxK8nhqxRNpNfmF02dMsyKQerr2LRY1LPVxxziiHeeHK5bDJ26OtRj5CmyN4o3oYNBcm2jc0fSy1sOvmdLUyrLF+g2WgZq3KSJmMUg8jgxYv8tUHOroJttmTRXZ+isFlAFksVpJi4vrILlzq8BuUcBHJ12dxKODMY7Ofi4AytAfRffMdQMMNJil0/inn47f7GhT6A8ydyermr41wH7fvDbEYCRWAWy55OseOuuVS3G84LYPwiGMky2eydVUf4gLW/B8WSx3mLmC+A0teMjxiUh8gp1Wx7zRVRJkUf+kzS8gdu9if/Hl62dqh4jWpjlscxQ/Iyix9IQkHzvbeXFRJMN1NiJfEWNfbMZzV643/FtExi6QqYSYU7bWEYUC8V1NDHapCI1MjRLtjzoZBioTNHQRUvC+QdqY9Isf3ysPLT4MF95M7NbMIi5WEkK6oo+28yeOQfByDr3xmTyIncqqH0bXxtIMuOuXPcmrFCaC9V5iHPvUBlGUxrh2QiZRpHhK/WZRyHDxQhuF51wcJl7oulAuvBZ2EefvC5cQ1PjFfoIQMTsIeppnB9pMQQWozuu8pg2w+pPIFHMfNSEI30fNGavz9HLldmdD/1COG7QVLUNL5J1hm4U6v9
 VzaEFBOP
 4mwTZqnhz3ITIQMFCGjlkP09HbQtCyos1t7FCh3J6D+QbHyW8HJwFHNMzOgeF7St6Zikp6Hgz9rEZgY2ie3lk6o5aUs4f9/6mQWe+CQc9qCDhsPiB9Lkwcna6KX4mEmkyiUo994eZfonHDpaHW4Pu1ynVK2a9c5MlyIRx0/ceWqILsGhdBF7XccaWXeK2miuPfT3B3PQwujpd70N3zmY1uGx9/FhlI2flCk7oBLg9NDvPf2gj+lPUhblGSU+BKy+o38A0wlavAgf6wnSlpxcl4HMTHI6bwzp2Ynr+m3C499mDecwyVaj5a/qWEh9464/feYdb1oqNlYxruwmXVd3Jrhxe6tYvQxbMfoAsn58MnwqS0AP+hlYCdnJhrk7WHAa+5Y4qpEJQcToOo/XtiIl5OESM+Ttpb2RPoPFRGkugMMTgA3iBIfY1MGlFYgND+yO7QBktOSKw/8OwIwLlhA1b4jqNO5Z2moBUAeaKA1LR5vS22aFCFn6N92nmKHNGMzRTntrAA4dzuqRVbG57M1FUGWUUtkb6ZJCTM/ek3H36okDhvHylNCPhw7QxFEwpaPVLHWl9asXfSk5Yy/+tgjFINQreUBFs4X/xADIZV02zRGim/mjZTH8QYELQdJOsMCykSIVAA5nSi8IokkNZtmkwtmko+nc1fXgDpwmsS3nd5Ay35IP/00/b8nvobKrQj4bPq85PnvZUhcn+xDgc+jqvDoOynidpI53HAZzoLfUmXm/cCgkuqquMyiIJKHRsJLL/Myjbjy72D1RiEmk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:00:04 -0800 SJ Park <sj@kernel.org> wrote:

> Users could know some data attribute information and willing to provide
> that to DAMON.  Introduce a new damon_report_type,
> DAMON_REPORT_TYPE_USER_REPORT, for such user-provided reports.

Makes sense, so LGTM.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

