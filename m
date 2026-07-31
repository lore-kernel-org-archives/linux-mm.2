Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07535C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 03:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E74F56B0088; Thu, 30 Jul 2026 23:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25F56B008A; Thu, 30 Jul 2026 23:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3AF06B008C; Thu, 30 Jul 2026 23:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B74D56B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:36:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E45D40334
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:36:37 +0000 (UTC)
X-FDA: 85047659634.15.5206042
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 66AC8100007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:36:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=citI954n;
	spf=pass (imf05.hostedemail.com: domain of shijianlin11@foxmail.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785468995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/L0XMQGa1DDfjS3hU02vlKX4lo3wqFMc+fEjdCdUZpQ=;
	b=ETcC8Fh7kYPuRPw7VceAKCgrTEMRnfbTteWxVP/MIK3vawUZcD1+BtFq9mk45i8wKLi7h3
	zITXC5suC9bs903JLULQrzui8aMvNXDTpr9pmnubQMbQiz35ReeyUy35djqCyc/NOu5xEC
	s+bwjLtkdQq7FszYYJUk9WFWY4zBmlk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785468995;
	b=3fMZto9WeHNHWiOJU9Ur1VvuDNi5JBW/aINVIeCIdFfsltHXZNMp8czh+otNufb7ur6iXi
	H+KTg6q7fK2uAplJwYaMpAfF/dxlVGqikpYGJnjEEbit28ju2SdgQ1lzaQcj+JxVM6Gjsi
	By2PnLQp20JI4EaqviptZpNrVH3z32A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=foxmail.com header.s=s201512 header.b=citI954n;
	spf=pass (imf05.hostedemail.com: domain of shijianlin11@foxmail.com designates 43.163.128.53 as permitted sender) smtp.mailfrom=shijianlin11@foxmail.com;
	dmarc=pass (policy=none) header.from=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1785468988;
	bh=/L0XMQGa1DDfjS3hU02vlKX4lo3wqFMc+fEjdCdUZpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=citI954nxod/O0rmJUw3Shl+9qPDE6iaxK7+mBbrHpGI9ksB2QYx3tyBIZr7cuxEO
	 bngxAQ4MJDRRkqvIlqdsF6DoM0JmLcSeB6K9CbAdcQzyeP+NdkASovEavYwQiXP+pI
	 rfz69y1zaNuh+UqlMDkHjDf+UEHSkXAQXCsrId+8=
Received: from localhost.localdomain ([180.153.160.8])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 91A37E00; Fri, 31 Jul 2026 11:36:26 +0800
X-QQ-mid: xmsmtpt1785468986tz3yfkr22
Message-ID: <tencent_A9F9A0525FAA458D725A6A3443B44A970005@qq.com>
X-QQ-XMAILINFO: OVFdYp27KdlJCDLgjtG4ERF+7iHtRV+2q6pYEmuQdf88Thpn32iXB5cuttvw60
	 c6bJHCNExpGdDJXw1FI8DoGKOPu1vEbybRZGxE3NaosQesUUqVAY4D381P3+1q+T/0aG7tnIWXF8
	 rdJaDWRd6rJIsBffgz6cOw5AbvCBRoA8pEAb6hXRVmqZCsTrSWtVgSAyax1cN/vKR0sFDGntljbY
	 SQDknESC3hEvY1zpIbbjUhEaaoZ8K2pM7TgBn8rpA9nm0dGZgdE7yTMuP8O9RftePps0uga+5Dj1
	 ugrouqWhZ2d7eW+P0G19FRl1o7oilwHqCcLmwJTBA77LCgztwtvdObfAlqgB6icgZfGhB+9YlLlZ
	 WgwRiypZ8jSndyS+gQ6pOJWlAX2e2Spj8uKyjSaGdG3dN8HqbF2/iVmf3kVlOw6L/x6ttUQSszKl
	 aLkT3HXwzpC5QJLg1vCEChZTAxW7Vd4hqIloEFJCamWHEuFAbI8jtug3zYNNPOJl8GN3/uBLtPx3
	 RLPvkKy1hn0ub4wdB9te1DaO+Rii9kHZ664Dx195tIxQmMxQVDNqlToOlXfMoU4sa/OHnzwi9E7d
	 6Hg4udaZgr2TG8laBnnFhTDOJbtUe76IZEtdeEM56l44Fa5REI/G+gNVJHdFgVKdaJEnaQ/rrD8j
	 K1Jsern71YBe6YCF15HRuJOvihDF0lUOh2FfuDNYSd2cbOI13o99ftIvXDRSn44rHdz/1k4YKRkI
	 /NTsycVnWm+VQ/2RexD3VrOaEAokF+4TtUIeLAiFQiA1BZGS8pg/fGGu94Hd3E6nna2iunM3K061
	 KTm4rEY42ago6s2PkUdHuOZ22/phrDwmg0r8Hlnk6tZk4GjGpOxguZ1jtPk0Lv+v/2b+nab0GjXv
	 TtV0XYGDTv6MYi1YGjfLcGNvQxdei6PW0NGj8+wKtyVNam+YJIgu4n1nA2qPYnnD2HjFDV1kwhed
	 2SwM5CzX2Z6YhqAp2DWbSrByRO4vkL5gY+lhemUaOpDOkfggrZmE5ThWj827FVxHj7NUWJHzmMOK
	 jWl5tt7w==
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
From: Jianlin Shi <shijianlin11@foxmail.com>
To: vbabka@kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: only update lowmem_reserve_ratio on sysctl write
Date: Fri, 31 Jul 2026 11:36:23 +0800
X-OQ-MSGID: <20260731033623.3020474-1-shijianlin11@foxmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3105745c-f547-481c-a329-9b78ff4de0f8@kernel.org>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com> <3105745c-f547-481c-a329-9b78ff4de0f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66AC8100007
X-Stat-Signature: za5hmxnbrkg1qrzqh7g5qb1555xz86yh
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785468994-743683
X-HE-Meta: U2FsdGVkX198aMK5Vv68zgMwlSAZfZiTIiNQcQUwyJgZT6L4cqvaBU/6/QglwvOgXcgL9qsJ0JxzdIP8i0us4xxlfGsBeUv5yHsgOecvU5HDUag3ZOps83kkFF6wuk4Rm6I2FsVCfQDxiF8fExCBxhXlPIeIjPVvf6rMeKOwklTPKewLVjS637DgMlDnt9gxZpRjdN3aFB/F/z5RgrIBaDoLOFxMBq7WT4e1r4KuFGFmoPksdayUPi3cC4pr0WOJdEIcUaicwkgpsO8I5Q2Y9v4VGcG1yeOhPiFIigqkjDv27waP13tx1FxMuFqLRDNmy91KR8DZ55arOqypZ1xjtx7vDJgvatl+76fJCfly8E+8cBCszmXzVR1qAuCB3C8Zkya4NJJJyT+BibeqId4JLAUD/tUrQFgp/32K2q9/KzQ0bYFqfWczbVEEoDz+HjVqgqa/sFU9BvWwC7hQtYMTm41ubAbRlrOya8bxta+yKxsZ2jX9E1Rj77MRhHaJqFNCUG3PkZAWsCaOCgmeuDl5rVVrZXeJUrfwNdycBxU8H14ekrM8UUZfLskkfZ9Y62/Pb4J0mZmM9EybIIx0byOs2t82b4jL9h5yMwZblzYS21Ii9ucqWPKWZxLrHfcn7KD9TELQFhvoPc5THNrRJ5kXXhdS2tv3tjZjCR1iHl7vaYlYIZn2ZQ6ipzSLhiATt2rIzdBalCOkOucFVyUPfJeutxbPYS5b/rw9Da9M4M04NeagKwiEBsTxqOss+lWc6zbcF3cAkYlX3mn5h+Nl9OkykB/nMnuuPaIaxV7uxLcEu64hy4+4mBbNWxQuKzBgYugxJEjiOEZwsw1AFqvSZKNR6o0xywslGC9xBVwd8yq16Dti8yJFBisbShDOb2w3hXs4HDfZjP++f0dcNmtf4+s/nG5/8k3TS6lXS3OnQb8RKTYAianVzrbin1WHsBPZaEvuBSQqPvboczjIvoIxAlA
 /nGJB+mq
 yxv5DSNDXCVTVlwolsDyxF82qndlrjYmeLkuFdinf0dW6+pEPoxU2vviM84tmehM5Qa84w5F5FKmxGYQYTaqRAzyzJnoR+cuMvF7VMEd1utE7tkxoNgGr6GYWjtgFZpH39byay0DteM6bCq544DcKRpAkWOWgnS6YBUKgRjichDZofci7dhESK4n91okJqr3+5Ucwu8sIPsPF0RNIIRQEc+e4c+NPRCutgyBxRxscWZ/Xg9T2LwAvLuNc/8Q6FXgSj/gRGlWwxb6bxiU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Jul 2026 15:28:00 +0000 Vlastimil Babka wrote:
> Could we also get rid of this adjustment with proc_dointvec_minmax's
> handling of tbl->extra1 set to SYSCTL_ZERO?

Hi Vlastimil,

Good point, thanks.  v2 drops the manual "< 1 -> 0" loop and adds
.extra1 = SYSCTL_ZERO to the lowmem_reserve_ratio ctl_table entry, so
proc_dointvec_minmax() enforces the minimum on write.

For integer values this is equivalent for 0 and positive writes; negative
values now return -EINVAL instead of being silently coerced to 0, which
seems more consistent with other vm sysctls.

I'll send [PATCH v2] in a separate mail shortly.

Thanks,
Jianlin


