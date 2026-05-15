Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12A56CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 22:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1756B0005; Fri, 15 May 2026 18:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 771DE6B008A; Fri, 15 May 2026 18:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 660F66B008C; Fri, 15 May 2026 18:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 559F76B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 18:19:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0851C12022A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:19:46 +0000 (UTC)
X-FDA: 84771072372.16.1426532
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 31E8B18000C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:19:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qPLUzIqe;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778883584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvCWNGBV0/IbyJ8baDSLSIZ4bAFvtnRm9ehorzRiQS8=;
	b=MMLSOig9inj92t8ZW0vDMe3XCgaHlDZZTpatGi+KJ5MdngxrWIFoO2SxB+BeFm5af4PyBS
	ZascbXCwoPujr45fmFdjFMGnZgBvKG19JKYWbuupNI1Uh26aAXH+b+NUqsqF5Zcaq0Uas/
	tIMDK+Z7Qu9Ikp1QEsbiDWl3Nh5zLg0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778883584; a=rsa-sha256;
	cv=none;
	b=T00CEEKpoUiBbSBmovHT29dpJA+nTspv+/njlyVL8h5V4+eVrRhzixqf3sIducSep1ey5w
	e2MQunN1Rif37ybLyziMBszl3pCZtDZSbApS0qVvCbAXse7yLQMAIzmdkj277/AqPJedPl
	ERVt04aDEZRYuhRHG3DDf5ZOCjw5yMA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qPLUzIqe;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8907B601DF
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AB8C2BCB7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 22:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778883583;
	bh=W0dCpwZODJFKPu2SY6eKQzfEttHd/2HhQ48IKdHDqaI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qPLUzIqe+TD/Ajtl2DCP1cDvkOJuqKO9ysrycysQpsE+m+xWszTfV+rlfwO2rVKqE
	 9F9C5+WMgR58Dq4JWhybLmVz6E2Gq1ppksYTWnpZZFoGIO2vmeRi1n5dNTZU0lZZUM
	 LHgpphCcyo4hniv1oCFJL/7skvnp5MyvMD82drSl7iHg2CdK9SgPMcT1eji4QEntu+
	 bKqWwOLzI8aqSyUq6S+qUu1FZ0TsUcs+G7zeRfwLEDUj7EhUwoZcp6lrZ+yJD0TAga
	 Y0BGiekqxRPhNJJkDIYjraBHPn27CGWMSn4nt6BcPAwp/tcUOYNTNfVjYZTGnNn7yX
	 yQrUAd2V5+gzA==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-651c366f7efso666241d50.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 15:19:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9MmGdvYcrj2DfXGyO3hCTJ5ioeE+ZasG3RKt0BDNP2x9oI2sd5YzQfoMguOGEEPnDHYEYwd6PaUA==@kvack.org
X-Gm-Message-State: AOJu0Yya/FVFzDOwnTimY4lk7XfXM7zq+DXTRm/CG163Zfmq15YV5zpw
	kmLpKN263YlMgqvAIbaF+bbx8rtBU6J6sPcagtzCaXH8qVmNMznz4EcVRhRJYp/mcDPPzSvtR4u
	bviW+1Dof1t7kYmnONE4qV7Sn4qZbvq3e+mVegb7U8g==
X-Received: by 2002:a05:690e:4381:b0:651:c264:dd61 with SMTP id
 956f58d0204a3-65e226f5107mr4855343d50.7.1778883582591; Fri, 15 May 2026
 15:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-5-hch@lst.de>
In-Reply-To: <20260512053625.2950900-5-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 15:19:31 -0700
X-Gmail-Original-Message-ID: <CACePvbUgHmSuo_r9WDSD+oMnQeW0537OziTPMt-sRHx96ihg3Q@mail.gmail.com>
X-Gm-Features: AVHnY4JAgCglMa8_5PLakfMWnAw05abJthdzcE1NPle548GazZ3X3WKDUpcNb-c
Message-ID: <CACePvbUgHmSuo_r9WDSD+oMnQeW0537OziTPMt-sRHx96ihg3Q@mail.gmail.com>
Subject: Re: [PATCH 04/12] swap: restrict to regular files or block devices
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	David Sterba <dsterba@suse.com>, "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Carlos Maiolino <cem@kernel.org>, 
	Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 31E8B18000C
X-Rspam-User: 
X-Stat-Signature: wy4x1uagcj4kcztm96xwheigkzppyrwp
X-HE-Tag: 1778883584-65074
X-HE-Meta: U2FsdGVkX1/cjHFbJexskM5nFZioEndBXPpclC0jihReZZsMNnSZta5mJzTjJajAhHbFa/NVanYW+BTPzbvpErtt6unVyUax1ljJa2+28GpjDiakQisxx7rrexS/nSlND//pyhun/6DwgiOUDe9ux23Ca1BeMGNE9Nhzjv0sybOrwKoC0yeuONUjI3lftPpNoeskfDY649/LYCoOTxK8ODcfq2znfFFDWWwok8YDV53Alxpj0kha8pDa/Zw55Q5lFmqUcZ7JyuJuddDDWN3Fe854idXmtSrGBdqHdes38WxRrXPb46T2Dpp6UjjwOfERsOGXeXrgJeLDY93fSVREDoBZTCdKrv+IrTfoTTNaztnL0wMWgvgr79IEH4FRRBZDl75rvgyox0Jo6nHIYrY44+zhUDTuIFpnqtrRnF5n3WV+fC2BgGtwses+waF4mnnGqTH/9C8GH5bWKhU+wm0Un8PvsLhFRicjDEHI8hwOrqsVIrC6rZEhjCJkZpuKKO8pJPEyT0oi9J12LDZ86CEBkMQvJu1VV2Sbs1u+qxvtflKv5TO7YEW2/hiBaBpTdzar38ejLjN3n9mS6B0nc7fxbHpJcT+UHU/2pUT9jz82c3vUn21i/3+l5+9J68aHSkUqiltpE5KUYN9XvDbpELYhQdMeI5HfVNFHMq+r7ATe98M7jxSGKWzFUYlwWf6kJpCXcDIcitL/o/+5GbsMRmDFUpqGtrbW4GVBqtWU2fhP7iZIp80vxwa88EIpM9ePtwMcg8sfc6SHYjqRD5gFTvDmzS4XnYAE77Stcfhcg6FQkhaFdskj/vYW0k7hW7teYpEAq3I2aJftU0UrcTV6KuMmsogBwhDGc/X4BzgY+ZSISiIHQgGQ+s0n9O6m+lGRYYzzn2z0k9A1lePXuksztGbeJ5MUoHKNxdJeaMAzFvKPC+7C13lN0suCv6QL9y4mbd4xUOCqzDhqUO2FwVgIDVf
 BA6fo9VT
 6iS0ZNb5+UyY4JPNWYa5Rsb4kBRRV9SRaDGeKCvLErJItIWeMFeujI8JY70kyIQUG70GrfJ/QulId+fEdpEMVYUjwLzDb5TBKc6KEishzo1SHlRCbCdQnchniaq4+l+AdK/mNaxPqCjiknQh+/AdytZWHtHCxw0MICwYILc6BbaeQ4R28e3c2Jo9LQ6qUr38siCipOvHhngT3W7GmxKGQn5hBnZIbYLHkrlO4NrpKABCwWFhnBcmc+ppFGS89CKZJG8e0HVMagZpD7EFHiZiRLGnK4lv9kHe8EHv+10Jf3t8ruH2wzjvpuZWsMvg5WmSl9jAMXqhj2OgkCld5NS294yqGBtyGvKWzlixO12Sqx/IuhGRSQiVCk23Dh9fn7c/KeeJ+HySTm5LuE5cxSYeGDQUxlepuFktjgARb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:37=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Various swap code assumes it runs either on a block device or on a
> regular file.  Make this restriction explicit using checks right
> after opening the file.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

