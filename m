Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B953ECD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 21:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E83D6B0005; Fri, 15 May 2026 17:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BF1D6B008A; Fri, 15 May 2026 17:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FCD76B008C; Fri, 15 May 2026 17:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14E986B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:59:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE37E1C0694
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:59:11 +0000 (UTC)
X-FDA: 84771020502.30.005A462
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B4356180005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:59:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mlxAZ0IA;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778882349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tefq8HvM4P5E2wSS3fwKg/uRUohzy18j3qB5eF3vc+I=;
	b=i3jI09TyAeEpp///Y1Xc/fhLS4RZ2BGcg9v3AmRyTyiLOha//TahEhMxUWxsYwB76aZLcF
	baJa3gWbM6/gbCXqQsyiGv/Pt7an6cJ/LJUmGbrIitZ7oPFhoZQU2jkofDfNb/WXTWitPS
	mol7wmEhLSbJdafAa92VGI/EyuhyOCk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mlxAZ0IA;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778882349; a=rsa-sha256;
	cv=none;
	b=Ii1uFmkYzX+fvevS8ddAABauQOfcUqNRR9XNvekVZUUBCQxPYaaw0WLD2yUgzXf2nWf92N
	L8cbfa7c7xr3LjV51cuBBbDFjFkXCa2gtRG0mb1TKdVmOHuUF6stzs+jnHp3cBBnI+sFDl
	T7BKDXaP/IElw442lmuhIVqSv60397s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91C5B43F23
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70370C2BCB8
	for <linux-mm@kvack.org>; Fri, 15 May 2026 21:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778882348;
	bh=Tefq8HvM4P5E2wSS3fwKg/uRUohzy18j3qB5eF3vc+I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mlxAZ0IAIzSCHzLngeDmNQ4J6co9JfMfAyyTD56EEM12uxEwPF+d70rIFEgbXNu+t
	 nmFWRYoP8nH71/SzDNTwckMpq9wyB25aRToRPAIigrb7jE/X+huxz3wV5weJQEh3lf
	 ZsxLaxQxb/gZTw7PSxPLrOv75lNNcS2p2VvYZC9t6B4LYinmg6kLafUf0DfUj6eBpq
	 kZXCFWY/C9/weqMV5t5f0tzNqll4Mc26mgKMjPP/M9Z9q4x7BWVbGRpdIXWiR96TOE
	 0nKaYS+uAe3dGdJ5WvMJ67+DHS+m1Sv1+QgNDDJhKoqmJOrx70mm+Pc9QAldu7MgQe
	 B0cPfkZiG0HUw==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65c305f381eso847943d50.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 14:59:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+aVOKDV08y41iEn9XU5GXgcrFewr6snUM8/+llpW0Q+FM/c390kBc/fE3RKsxOzMGweNHOAbMYrQ==@kvack.org
X-Gm-Message-State: AOJu0YwFaC1g+dqm9sPhWoAxkwng2JHbJ0/pe7D/YHRKd/1al9WzUwwc
	QmeeWc64fDhnuVrCsfppJYUpLUwF3GC4QnG0FetOUzXPOMsISDOM7E3gWNXWVxkv+OykgimISat
	r4VTXqLMDOX+9+VhOj0ht2cKYXqAXdFObjMULiZkucQ==
X-Received: by 2002:a05:690e:4188:b0:65c:477a:2ad7 with SMTP id
 956f58d0204a3-65e22733998mr4980962d50.25.1778882347862; Fri, 15 May 2026
 14:59:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260512053625.2950900-1-hch@lst.de> <20260512053625.2950900-12-hch@lst.de>
In-Reply-To: <20260512053625.2950900-12-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 May 2026 14:58:56 -0700
X-Gmail-Original-Message-ID: <CACePvbWMpfBo0zSFmMGLh7uxrpL2ugHCmD9xp=FC4aXiv9GYmQ@mail.gmail.com>
X-Gm-Features: AVHnY4JjyLNu3psg3JDksoA1h3sEopdVsiktUSZMp2g3bBnm0ZZ5mBGkhXfViRA
Message-ID: <CACePvbWMpfBo0zSFmMGLh7uxrpL2ugHCmD9xp=FC4aXiv9GYmQ@mail.gmail.com>
Subject: Re: [PATCH 11/12] swap: move struct swap_extent to swapfile.c
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4356180005
X-Rspam-User: 
X-Stat-Signature: 7eqeykum14bkekfqep8fe35yw51h1nbt
X-HE-Tag: 1778882349-523206
X-HE-Meta: U2FsdGVkX1+XqtG1o/SXrxepQvV3GWljshPkKCwnaggdA14IkC6GKT2uun4atRrZqK0dQG7D+doS9dgCYv2tvRz0zCxBpcjlXEp5oBpVQXIB+B8JBDKH1pDztlk8Am/tii9CdeiPb8sdCd3Bc7CEI+SH7xTyc+tNqWQI8J/OebA9PnaAAq2DZVwlKQvtl/nBZykyWVudxGbfFXUV/EtyrZRt/U3/a27in16IVMX5dPg6HtNhB140uuIGHVRJxO4tKBlICQeoSnRF/vrSE3JJDmQoN16mivvX1KOn2vWBVi2YAI0FOm1L0ctJKnnXy79wNmMQrwcYiX9/btu8XyF6D5H4Nwc/FOJcZYq3ZRPOb2IOag2NVoipuVXGsR4jdkDSV2xtE5NiZvxiytrz+ZdGjXq7AfxyhF1UnM8HHrZLvPIKsrupodsNg3pLdDNCsUUel620qHbrqwyuj+AulLyluLrMYeeelgb/8hJQAsuCI8S8UKGCzjjudRD2C7U6Loqu7MnSjS+8UDdjH5Y/a57skw9WqEt/nZkZGRyrkGZ5UZLTJMAefBhsQ7hjrB2eVR4+UXaVVlezHgqDGmliLtI5sN/yJFiVdb5ZdDtp1t3I853+vDx2q/5mYRvqUrgmXzKAwIhBiJNJR51uwC896FpJ7+EAUdr4vXtVRTBeKa8xwOhjsr6R1kDxCoXocPjczu/T1LhjS5CkeY4FAOw4OlT30TGTio1MqGq4HAKG9+yt2SCdrfIDysjtCOkGUk5/csEBsIJIAT0xjIuJJAzZktUSI6/J+yk+2UkoUiuYYBAlwLWYR3O3inv1sD3bUq+cAbestaWFjvVhTeKqWm4phsvzZozeKscs8qbjW1KWtw45h9uyFpDmH8n5Z34K++Pvy3aP56L33YqUIPmp0RdsLjyUZcNv0UDs1cSX/fuCCUyN9IhCO2Bc6v6rLq81vEI6EWlmKYVfm7Eb2ezRBAh6pQw
 qafesmLe
 GQKTQFF/v42Ij6oLeculz1SdGlUWc2J+SXrsJFm/ivDT/ppviZYgmrOSFEYeKni33RgeXkc46DigMzFmhVr7ARcC+rWy0bvoXR6IXx7uo2mlLRN19h4xcREsJ3TYKWwIhRhOftb3UBXvRDUu8X2PXBQdpjTx1EOHsmuCSenhwW3m7QkDmVnLJANqYMfqteK2gN/hvNgblTJLh9Rv8LMDvcoRCCA2H55wIIpZ6LvXZZL+EMHMMwU5XCtx09iGZ5pfr1NF8kMIWhhz7pxLZHBqdtgFnSUXcw5G6zOl4pCd3VrE5urhwD8NYUsqauenYq6GUkFJxbF5SIk9GSRYOIhDSUHNSyQQsuRcs+DnbI/0MGak8IMM6t7/3QHKhL1JzJ0oADfvLFrSfPvVAY6pXXtXZWXqaubEiqTiH9iLO/dSRBxUp+x/JRu7lcPzveXAAQZRaq+TBYdOGtSmnGAg2gEWAw1i4gHVxLCAFb4Kt4siP9/6R2mc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:38=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> struct swap_extent is only used inside of mm/swapfile.c, so move it
> there.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

