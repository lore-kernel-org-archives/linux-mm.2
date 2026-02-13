Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28DF3EDF170
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90DCA6B0005; Fri, 13 Feb 2026 10:19:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BAA76B0088; Fri, 13 Feb 2026 10:19:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7416B008A; Fri, 13 Feb 2026 10:19:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBE16B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:19:17 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC3811C524
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:19:16 +0000 (UTC)
X-FDA: 84439791912.17.55F0EB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5545140006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:19:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uvs9VpQk;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770995955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SclNrYr7nJm5S3eJn/cpV4ydXXhe+tnS32nXzr1I8g0=;
	b=8G2jsWjgMmzxY4o6OCUzZZadsYYXej1FU+Ac4Y5ZzqrelDsPm3SuqJyogl3IQnioXlA2fI
	Dn2TsaHb3hKglXh9cLLAQbo/FL69GS3gfXmqKyI2/TIJuAn08Nqmh8j8iXPtVsIFJwYxVY
	gkkbyXsDGOezKPfi6jF3dGowCS3q9xE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uvs9VpQk;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770995955; a=rsa-sha256;
	cv=none;
	b=xgih2QIqQerx9H1ar2/s/t8KdQWgLX8SlHlvqkQK3etsUUz6H+lz/U8gnwyotbU5Hzycti
	D6JGsIW5IL/Q8GhGj4T5Qc+xUproNhLYjOOUaoQ+UWmsP6MAkQ8pQsxv3mZX8altjuCbNi
	2WjfznrgaAcUz+n/38SiXURpofRwRoo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8594E6001A;
	Fri, 13 Feb 2026 15:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B07C116C6;
	Fri, 13 Feb 2026 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770995954;
	bh=tSn2VGHTk2dz7GxXDBVDU6D60bA8+I6ljFRm/Ed3mHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvs9VpQk9HQQsZXXmwGM+CC8dkC4X+xDs8Pz9vfvJdx5044sHazl+H0wrYSbzQLs9
	 HxKsUKqCFESbgbX8GegXJnZ9DebdRKaisrrrdluvqAlM9Jb3hkNH1o1yNNPHLA1in/
	 RIRRDvyma/UGkjgWuC549amzjxFpC6S5qCCDZDCf2vMSduegS5DwRxEJ/M98d68kF+
	 Bh0g7QO8tGqXxju/l08Zxtdb9Y5iqqw/+bGEMVPQRCRckhfby7u8a8AXMMJ9IA+9cJ
	 UBmCF53qwAk1IQfLzYRhOik1WmEAa0DNt4nYRUBxpumykLiTNv/bjhtylNfyzanwRO
	 nVEOIRMhGRqZQ==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/damon: remove unused target param of get_scheme_score()
Date: Fri, 13 Feb 2026 07:19:05 -0800
Message-ID: <20260213151906.74717-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260213145032.1740407-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5545140006
X-Stat-Signature: otchw6njzu3n3j1wkgkknwj3c9p4jzk8
X-Rspam-User: 
X-HE-Tag: 1770995955-75005
X-HE-Meta: U2FsdGVkX19s0F/yVy5EkFIqVIdZebvyA6tZ+Cl8Tb0EQRHd4LOxFGzSWNg/yd4n/J8Gk4GItvvjVYPIu6aVwqJL2XzG15SFBRMX2dTl2dQH8DYHCrF3rIm4Rr0sK9jcY/ojvt83AnPvUi+NQYLagtNFSXOaAmJwJYzQ51PnmOlgSW5pTKzUW5XPrdWtsxJzLxJ47s84qYaNwhhpVsZ+Wi8BshZ65RFQrFRMOObJErLCaBYQn6BAQ1mg4VpLQOI1t1Ifv49W2MvTxrNw0rL9J3d2SfQHF1UB40+hqf5/Cbnb2Z4e2GLoTaSzTZI/0jJP5J+D7z3zfzbff97t1HQz1r557lDWo6tA9+xV+f6TwKqgfrqctNMgd3a06KiHcEVoDjdyGTP7cJ59Y5hN3/zCjkQOelTYvPzIPjTVVs02zhZDuu2bdrU7E36sPCCZUud6TDmZhVVTEwWlc5ICZAKGHca3UcjSon6HYxmatACfcaq0bIrksf7lDQ9hoM8i2LifoC9IPXjjE/0wn+J+PFjSk7jhbzOkBsZ8f0jNGAYxsG04CLdWJ6a+fnYWaCLdJrC7Dslu0xDm8OokekGvQ+suBa6eNqwCANEvb0EO3hHEvwuAF4ObA/MIRvTnv9y2Sp35m7TmaqqxgcZ2Hlj32ZxfWkL9P0YIAjkKv0AWnbzmqeBrsLCndsna+Hbp3/Bj+e/JbpghYXAXiZKQDO4lw6ekaOFs3IroJz2BlbjrGfHW9R9MAYRFEZ1wlpKsN/h665cnQtrCUfGpSvaIvWLRXd7AXyGfs1M1wbqbrpZ4RaqARdwGPsDOUq3pQW84utdycBfREsObnWbfg1iD3RQMQKtxEiX3/156IqxsyY4UgGYvt0co61jCJujVkxAyBC2zNnDiv+YyMGdzqhQmvdRuKTxBaYTFjmHOaQ1eu9WtaKKVkWPqLEf2uHN2g4jS+WoikpHc5dMEg2i0DL0HGrw66oq
 mdLFlWkd
 EpmpGYxZQuXkvkzda0kwxzZbo0rKqHUtBX8+nq2wHnoaiMNrgDmp6Q7W7Wz0GumhUBcrgZtF7SYZgD1sWsu0i9J/AghwtmRb72vX1x8S/NZZ7sm1kNHxVbsOh01yiXfGgyzqqZLmAkegmXH+LHwqzQyJyW6D/U19iYvZg7ImfkchqnJT4K4RZOJJ3ppMXGG7tbLhmzQlq8rTFtB1IiLSPoHVb6ilQIQ2W8QzNvqCD6EazopNfJWSTGqYU+8AcRpck7twAu95dSixPmjZD08mukq5tcPtrH4m2QRZ870qewvKoro+7dDJWYpoKGt1SK5zJTukh/5wZWOxWn8h+Xab7Kmc06TfMEXLmbGhgwTcrKwTvGckeJZxGzyB/BxYDtGz2AAHb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Feb 2026 14:50:32 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> damon_target is not used by get_scheme_score operations,
> nor with virtual neither with physical addresses.
> 
> Changes in v2:
>  - Patch against mm-next

You mean mm-new ?

You should put changelogs under below '---' line [1].  Also, pleae consider
adding [2] link to the previous version if it is no big deal.  I understand the
previous version of this patch is at lore.kernel.org [3].

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

I believe Andrew would move the above changelog under the below commentary
section when he adds this to mm-new.  So you don't need to do one more
revision.

Reviewed-by: SeongJae Park <sj@kernel.org>

Thank you for this patch :)

[1] https://docs.kernel.org/process/submitting-patches.html#commentary
[2] https://origin.kernel.org/doc/html/next/process/submitting-patches.html#commentary
[3] https://lore.kernel.org/20260212094326.906497-1-gutierrez.asier@huawei-partners.com


Thanks,
SJ

[...]

