Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31EE0606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SwiATUi5
Received: by kanga.kvack.org (Postfix)
	id 3BC496B05B0; Wed, 18 Nov 2026 05:34:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36C986B05B2; Wed, 18 Nov 2026 05:34:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 283B56B05B3; Wed, 18 Nov 2026 05:34:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 008DB6B05B0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:34:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8ACA0A80AB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:34:45 +0000 (UTC)
X-FDA: 85447881330.17.83B763D
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf08.hostedemail.com (Postfix) with ESMTP id AEE82160004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:34:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SwiATUi5;
	spf=pass (imf08.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794998083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbnsRzldWLp5RM4Wbi+k8602uEkMWd5FOiwEB3P+mX0=;
	b=WHCbEoLkoffwKAhRCUpSDsffTxIRmiQW05qxAENvLCTuCYsKsGlfbRzd1g8Ph79qtL2E8Y
	q0KxD5l8NJ6woWqsla5iZ1VOggoEXiEkiNJRud0W3kCFLwpSaLHG6qQ+aQEZV83yGriTr0
	v77seyLkP/5VycIjhloIck5QG9lTSEQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794998083;
	b=ZuVZ4lpyXbrunrEpNU2EivAgFb4iNq+YcRdZly+qvFMyDy66gaV+03ild0tX342zx3F40U
	BIot0HjxsU/QlTXD3DPhEsUj7AQ2FWMAAQiUBZimw7/ovSfnQJJ4xHk658+x4OOUHXjvZ0
	avpwcc+wVq2VujJl/WIZ11U/BgCNuLA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SwiATUi5;
	spf=pass (imf08.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f1.google.com with SMTP id d9443c01a7336-2ed408b0d0bso3794975ad.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794998082; x=1795602882; darn=kvack.org;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=VbnsRzldWLp5RM4Wbi+k8602uEkMWd5FOiwEB3P+mX0=;
        b=SwiATUi5SQ7r3vyZ3+qm/ZtYxqlDAObysCSNgGf00zpio2kNolKZez4/Go09217s3n
         LXUiQyUSppe40sUyOWevjRhEck8rnEM3RliKsAHL3QcBJ7BvJPDb6/1XQ0FcZ4rA/T8m
         Oki9lhH+3hyEo4KpUdKa9IsSHqq2gsCSyUGxD8LPSKjkMckQxYRcisGtbEffyshotwD5
         pqoqlkYsp1UnRKYYEl/dzoaWnl5PSftbyH3udbVYi0kgCxQ0oEtuBxUG1UqLTKJOivYI
         Jjh0qfiRngOXJmC+Xw033MGUCrRyDxh3UOyObE7PsJRjPG2UU3aAO4M9xx985/Iv1rA7
         ksNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794998082; x=1795602882;
        h=references:in-reply-to:cc:to:message-id:date:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VbnsRzldWLp5RM4Wbi+k8602uEkMWd5FOiwEB3P+mX0=;
        b=MJUHz3DMFB8Rp0yoCiL41ZI9kBdTS0ZzPoVKZRURCTt9e2GcAWNZe3hvMSbzr4dExp
         nIxPokWHwCKV3ZeO+N+In9beQwLC8mRoRCnFDnj7yHQpHKiuU7rE3NgDJ6lWDIaCwhZj
         +m+IslCsU48DFrm2+QreznrHVfKfOUOSgR+8YR5hPmVxVOAsAsbgG/t6gr7lZrSeHS5A
         C5G1ITKqHrVPowWeMcQIw0jqLMudOgvhqUporR2VEWm61f7xncj2ZMh1PSOfz0Z8Cczu
         c87ujfv7uMBACo4d1JnOPSrnjDU+WqLW8FmEVkFB8fr8rvjEFNjTEfmGR0gilJdBDEHd
         aurg==
X-Forwarded-Encrypted: i=1; AL+hErHvpX1ua1hs3jVIuaobnmzL22/kxE/9Wma0T12xkzZir12/gB9BW0Udr7hxFWmHtMI/k3B+ZSfbpw==@kvack.org
X-Gm-Message-State: APuU4Z+TWrsLYe21Y/paVmPjASa2UpIcI0E6lduL+EaonbV9LmkRaZy6
	Sxnpt6Q7ngrClTzYPhx6TMYxt+TmqDGis9NGafy4lyrORy/10MvzbhaS
X-Gm-Gg: AZFdTZfTBYTFGHaKrL/dk38HPnZxxhIARdbLSgBWtshlUS6o0XZ2vZX3Sa4xN87zso5
	xi7ZCkO3EuMo7VfTX6FrUNXzGrN+d8a+kRA6M5uIyUoXAu4RraX+vMKQrNcZnJ52KwP4jxFriA2
	raIPgu1S+aA3mgeT1ah22MwhV+lr2nu76i/6+twbxJNCdQxcaCmlmH0WMfpxDrkrBxuiYSjD5BW
	1nc2Ph48IjTLIWUSWsE12xQAM3+kiFcrqIQbBosPiwoUln6SxzDUfSv4ocWfJbyl0AvQw/na8yC
	RcsnI5N79gSsjUqDhu6IIvMqSwJkK/3QOsgiCffntpE1sQRyEKfZA0yOvawDXfiDfH6Yz0FJjnd
	JlCRYtaSoxEI4VK/gnxPNBXYVuyE7rcF92Y1ELx4DfSEcAxkVfUb8jikKwxOMr5Q+PMOYkTFwjT
	8/JS/hNhCGYScjFsFipkaVrUVJ1QKmyvMDcJijNSDH2ZXVVQBk9Tiq2beZ0aqnzCUi6ydVU9e9v
	rKbUj8O4HBHKQrODg6Z1cWsq3cQ6Us/IgL52lAvF7G+u4YTKT6FvLOWKKH+79FnZtd35yPbnoKH
	UTiDULBQbIesxE3f6oHaV5HG+qMmcVIvHVCsQtWsiFJJ+JMAu4rbCuOnc+Q/DH1GCOr9Y1pVOXa
	NukcP979vDtS76ezespx+ZUDX58r9Kk6piQbGmlh/JBX81w6VwGz1yk1PcFoF99quJuZEFz9js8
	Rku4Zd+xBg
X-Received: by 2002:a17:903:1ae4:b0:2e9:6333:fbb7 with SMTP id d9443c01a7336-2eff756dd79mr21077005ad.51.1794998082258;
        Wed, 18 Nov 2026 02:34:42 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6184152sm10914405ad.35.2026.11.18.02.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 02:34:41 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] mm/damon/tests/core-kunit: add test for
 damon_call()
From: Aveline Noir <jm5905938@gmail.com>
Date: Wed, 18 Nov 2026 21:30:04 +1100
Message-Id: <179499780488.5.13594313574604410531.b4-reply@b4>
To: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 sashiko-bot@kernel.org, sashiko-reviews@lists.linux.dev, sj@kernel.org
In-Reply-To: <20261118063755.37749-1-saileshnandanavanam@gmail.com>
References: <20261118063755.37749-1-saileshnandanavanam@gmail.com>
X-Mailer: b4 0.16.0
X-Stat-Signature: 3ndisk5okgjjrr9ybuq5bxkzy4uzryat
X-Rspam-User: 
X-Rspamd-Queue-Id: AEE82160004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794998083-638199
X-HE-Meta: U2FsdGVkX18KvwShZYgwyIOzxpf6qWIJPXBuHumHseUnkwM583bTZhDSRrZkrfZXdU+aoU6yRojz9bV/pR7R7NF/RkLmgFK3CqqG0aJDX6X2prtM00sa54tkJ5Gylb3gvy6nyHSxvpu5pQ/hUCPEE1yMtTkwmXBS439hGPpb8571bDkp8VZgL4KqBEHzSItrwxvSR8EXI9c1JZeTFSLu0F6VBU3Qf7NY293DcwAxvJBzZMU7hcjw07WYujij4V/S36yzIIemzVi51UPcO57crYEUoT50zcpfPUA2TvFhOoZCEvoHgta6PykwEb2MOwzQBpNslfGqfIs/c4cIeeBoUiGweYSG3vfAX8P2J6j5Y+kGnexzAp9hr8b+N4L5033TCDIVIRTJRGnUZI4WkOOI1SZjIKWkBBnJ+3UB8ttW3dh4l7DJOB8izhgNCbfJylIdCObz9CLpjisKhjNwNLwa6jLz0zKdFsaPHZMXfZcBhq31o+tDz8Lz/P9ahuLSUyuNvUqw1gAG+H/YJi7i+DZuq5gXX9hMVEUelnRTh8xu2aijNHu2YiwGiHz3yea3YLWlXPuubCAycVIy2jG5adlU4bc1iH6juU/GQnV6H8yO3jVcB5zNXLX1kXmyZwbJuziVxNG6kgl41Zn95LxndsuyuPh4EodCeMrPAKE3LjCr8knjigNy8qR+1qTOV6KhHqSZZgxhki/mvgss2Kkba997O8EkasNUNqGGX2kW4kaewAqWnssOqcAVdyIDD6hw+6UQ9nfSfr16pt/kHm/I2eWgN4hwYjSyHVovs8AzzqAEuoNipxJ6QF+r+QMwAnw8a2GMC9zJTDEzO5a/dX7VnZc+MEFgXS0iBi9WocrEEx1z+k2hJHnj0E00wnFe7/2zq3xM8m2KmrDF887niOaEuR4T1+Xce0SYj5nv3RtvZsVee/gjnX47YTfBI86OCPJOwr8fbfpQ0fCiu0CqIH2ryqJ
 5aUiJx6o
 Fj39Lecdj+morNky1YOKZayILT2VzgWUPwp1gGvjCQOM/d9VaTqIdDjNZ+e1LsH+ouO11w4Gs4LbTMOsRlQxAMErv5ZQ/Mc5rky/dGmdFrQQyBxrQkWqP5MIVVZZqJBqp72c7DpgQ27tn5mp8AnPK+EcoHlQTJ3ySlhvWP2aSnh5UfmpU/x7XMcZ3XQVOE5hzPeVd7f07x/Kf0l0xiwTEjTjMtPQr0nI09L9w3RD1cLLTwO4pe4P4vwEvgk/gwH0ZFUINniiPu7qI8kItd+uQPRDiulY7ETB2pBSbyw0/azoiBNtDWv/zk9fkWKpB6fcS4+aaNqMnj1bv3qGhCjBYVIoAPIyl18qn2MCc1Uike9RgwQqztVLMidSSy7XNmHnry6a1fcMdh4fjfEXzGPcjlcF4T5gEa4CnrEGkbr9C0hFTDF6/nUtFzzrVr8khwlaLYTZC3u/f+I1V4f/Fkibavyrz7MCeTvk0VTVpHIw2qmsjZEPfUR2jO9C8cuCmULrMzSiE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Sailesh,

On Wed, 18 Nov 2026 12:07:55 +0530 Sailesh Nandanavanam wrote:

> Add a kunit test for the two cases.

Make sense. Thanks :)

Tested v2 on x86-64 QEMU with v7.4-rc3 as the base. All DAMON KUnit
tests passed.

Tested-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>

Thanks,
Aveline Noir

