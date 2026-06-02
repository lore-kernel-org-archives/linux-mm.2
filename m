Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC0AC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 07:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D54A26B0400; Tue,  2 Jun 2026 03:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06506B0401; Tue,  2 Jun 2026 03:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1BDC6B0405; Tue,  2 Jun 2026 03:41:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC4D36B0400
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:41:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7119A162BD8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:41:31 +0000 (UTC)
X-FDA: 84834177582.09.1BE08DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7AEE014000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:41:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FhM0a85p;
	spf=pass (imf26.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780386089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hA0FiCS9ooS+oM4XlD7bN1EhAH0gqUkn755Mz94STBs=;
	b=65apLaFPcs8276bkFqLKgtEQCrzW6W8r11GyC+jmN7thKSQR1zjNgd2iFxbTdsN8cFRJma
	7bPQjSK/LcNuGOYGOe0FXnebctwz6b8Hge0MV70CBiJeJoZbdwfMPtLCCv1uxdkKl+pu55
	pgVEkUaMokhNPDb6wNcyFusBJQ0yXiw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FhM0a85p;
	spf=pass (imf26.hostedemail.com: domain of linkinjeon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=linkinjeon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780386089;
	b=um9i/AZZJMm+KyyY/c0O5prLwaX0mDs8Yhsh0rFxTsUVs/h7VUPmrwD6HSAivg1g5Hq6vK
	DdQSYcqfKYjtKOZYMGX5b6wSuvOBKMjXK85JVVaoliBwfcPsuGiTAkABJaY15aF/GU+EtF
	rnJaVqE2r4Rm0ZcPHP4gLnXlNKJrzMo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98AAC4350C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEF31F0089A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780386088;
	bh=hA0FiCS9ooS+oM4XlD7bN1EhAH0gqUkn755Mz94STBs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FhM0a85p+gIXj9KgvgpHkigcX58gKxbBzJMNnNCfCHyVa8r4n8IbngY9gj2EcaJWB
	 EwervNfguOaq2ZXJ6BXlkuG53PVexOPEZKw8cE3s2Vn1WDPPfr22bIJi6Bf6jVi7H6
	 9+i4DIrgwhexV60cWsUuwwQmTwnIO1d284klt0LQOLw4tn2JdtBJDoCiF7Z4iUyjj6
	 cVbXtklweXQ4CGKgDgIKJzTuJ82jJk6T/86qh+a+x1WLGR0nJyJdPcUZxZ43VTUDPu
	 6t9vShdEkGcnQGnvGvLn+5SdwE+jeAh7cDRrq/706N74uDex3yNz8oyfLH7WOOWb5M
	 o416Kd3C1WwHw==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-68d2342c5e6so3220266a12.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 00:41:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+E9v2qt+C9CteZAa7/h786s5e0vjo/DTyAY8tNoyysEKcwN0AhRuNLT3gN7ZNAvbhJNt+bCJEo0g==@kvack.org
X-Gm-Message-State: AOJu0Yyyh5fLCLBQm9IDRZsuNd7iAxK8Gd6UKfWSIN/BJP3sZtcWaOXl
	tC2jeSlSsVhVwY/zAeSwCl5kvWen9Sk2+g2TQU55w87sJEX0tXc/zd0BYAJFbKVSU5CVc6rrH6A
	BZc4QCMpAUWeO77U20u0wO8f78MxuHDY=
X-Received: by 2002:a05:6402:a50e:b0:66f:9f63:e537 with SMTP id
 4fb4d7f45d1cf-68c8cd220e3mr4074950a12.19.1780386087215; Tue, 02 Jun 2026
 00:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260601192626.150804-1-willy@infradead.org> <20260601192626.150804-3-willy@infradead.org>
In-Reply-To: <20260601192626.150804-3-willy@infradead.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 2 Jun 2026 16:41:15 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_8sUxdRT82pGmu2xo9=wt2ub_Jd_9ecFgOmQhj2Od1KQ@mail.gmail.com>
X-Gm-Features: AVHnY4Lgnr6ZT-SFXiJYLCzGrX6QCpf3_RA7vIZl8mbRng2W9bM_b_JQnJeb2YY
Message-ID: <CAKYAXd_8sUxdRT82pGmu2xo9=wt2ub_Jd_9ecFgOmQhj2Od1KQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ntfs: Remove references to page->__folio_index
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Christoph Hellwig <hch@lst.de>, Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7AEE014000E
X-Stat-Signature: bmkq9mwqurrtfwg85d1sfi548ozk3yey
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780386089-746647
X-HE-Meta: U2FsdGVkX1/kjUMcQ3PfiJci8LmBU+xD0BrbfZ8ilkLz346QVV7tDgXTDKMoAK38suDW3ygext9ATJn7ORg3sFIg3p2LIMiGkCjWWkaP35lw2jWh+FuOYrDaE/TaeExj7b7X5mUp4ltNRbn+m3HO3tkFmmnzB9nEqd4B07+EpD7OeETIZRlmWG43mtZHh9dP2q6obOcVpCLdDRUo5Ez2hmdZsoE/1i14ON/OCSH7I41+w46Q7rUqw2qv3yYKOgkNNxW7PLEAo8hm4AjuPJaQX2sbXyDP4MFeMnyvzNeycrvvBHiVFEcnVsfzl4JeS0Nwtmfq1A6IYjtn3pc8Uy/iFYPMYqdorMHLjP9nR3JzjmvOVnpM7mEPiZ+lMWhtTe5yLAt6Zq1QNvf4eHHna2ow/H9O4ong9kROuo658JZxSI9MBoVpjOuIqgbcfGFu5PTs+t0Ji6mbVcGIB2UCvEP0UJ/18j1Se0675laGrvLV8o/M5xvVDJ5GG69hHs00JXFB+QQlVAOli/7wo3slssL43xWcAx9BgME7gzVp7Oix+psRIg4ODFYb9p1v62sDiXvrwCEdaRyjg9mEKrK4nam3NuTuzHU4NF6etk8vJaJh8YKye02o3TnKgl6nyX3RYxsxMXg0JdlmYU5S46FUnjXEt3VtAbyaM6gM3BI+a3SGtkmzcqaHdvufYdXeB2+4x5FJSodW364WCoMW4dYd9/9yyh90i5pJ3GGS+21wZA0VKaSZTQWAnJAAko1XI93Njs2dIpuhF5+3tDmVlkc2ro0A343KCSg/UW/s1zZpIkIV5uto09uU4hSMl3mpH7EtlvIkelsDz6BkYWr0j86OwPIeKQ3fD7iahg8OZ9OjSxYv9mZKP6dB2cSOitvUaXQvAMzAHGy7DuLRAh7YYiC8rOMzm6YpSUnc4pJOzCrVD732t3QARMIxNt88SxE2dCgsjvJKANnxM+oQGiXvP3TqnQm
 h6AzSFnD
 4dpqRcjnx5Kbe7I+EcR/g+vMOFMMEM2gonUNrZ66GCrpqx+dj2SRCg3P9yWRwSKa8K5ED0WNWX7X3UHoPVwHbNlCulCkxJM4tVWSBi93SilDcNqi2V9YGSADwJ2tkNR+qPGeUJBM5paZ856CVGPGyhT2CbsUj3XCw1ofnzfh1tjn0Je8DM9V5ynxU8sW6K4dGeDze2pSNaflJ57Ev+1+fW+5jPFpXvKpgSndF6S6GhGsxoJxRlsrHfRdotBPO6VJHJSdwyrfHZdkMgFhmPyCg9KAQp4Knzd062n9FlB9SJSJ/LLzQuL9hONL6jlgAy0qcfdLzDydTcAXg+T9pCDfPCoyI5ZKjgz7KYjqrq40Y4nFSpiX/MrrJ8vPnLbFijgef6wc43B1Q3csm30sXo4hucYoaPrce/VoizaVqUxz+F1UNdFlJ/zg6wmLztwVpEcQdODEJKOG6dlCCaW3rO1nU8W7WhmHwByMqoRL66mMpiF8vS4RMaFHysrLRorweTfVXW6OO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 4:26=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Pages don't have indexes, folios have indexes.  Correct this in
> ntfs_read_compressed_block() and also remove a use of page->mapping
> while I'm in here.  Also convert the calls to unlock_page() and
> flush_dcache_page().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Fixes: 495e90fa3348 (ntfs: update attrib operations)
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

