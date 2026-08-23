Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AE4C5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 14:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2446B009D; Sun, 23 Aug 2026 10:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482FE6B009F; Sun, 23 Aug 2026 10:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C01D6B00A0; Sun, 23 Aug 2026 10:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 193B26B009D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 10:48:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFB9980319
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:48:44 +0000 (UTC)
X-FDA: 85132815768.13.9B76944
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5312340008
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:48:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mLgYygp7;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787496523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSqJDYl7YC6zwUC4YsPvrfUU87RaP8s2DJiRMnTnJ+8=;
	b=il9PXwW2+xm7fDMbU4OQbgFE6jU4zwz0fFgWIJeMdVaBXS0FsIHV/kIJtL9jtVbaiAvnh+
	f3Pioys9bfly1rwREtvYaHdnC1KVhnK39mPIjuSouPrNyAyHv4Nu3ELyWUEXE7AtCE3raE
	a3Ov4LCXhct4TiUOG0NeXsa9Lj7CpUE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mLgYygp7;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787496523;
	b=3rKGtk2+7mZsDB1mUkdcujE0RRMx3W0jpvqJhEmosX5P+TDrRiRXH8liKudVcL/UgOLXBj
	5WIM28l919V8KweBRLlhOCP/5lIsI3D/BhYmb68P2sJdIIaGcaUx8rQgRax3uF5/XbmsRf
	McSn3WyesoQ2nBCr4EcIHj4noeVLAaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EDAB415FF;
	Sun, 23 Aug 2026 14:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE4C1F000E9;
	Sun, 23 Aug 2026 14:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787496522;
	bh=BSqJDYl7YC6zwUC4YsPvrfUU87RaP8s2DJiRMnTnJ+8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mLgYygp7AvPEokLUF73ZmybohJWR8L6I0o18rVF/DU6vIq8kwxQ8o65YUFSxoFF+b
	 +uvE73Kdhw9RBfzgcPh4WsqIOSFIRuckU1aDnFkHKBV7W7ao9CD3wK8x6j+f5ayTUT
	 GCgxI2xCB1Vl84hAhHIQHtz5tFRL/oWR2vPRnuvDnjwVFTBsC1Us+ctEFYlO65kqp6
	 1m/k/gW6sC5kcq3Hu8n5RC+22SnRRlHKdfJfDB6J9kYnNl+h/TJSRQddMemdgJyVWG
	 0DyI+Zj2x6eDwkroiR1REnvCQs0kGqy2meOp2cfdYUqZpu9EE+aZEknlfKg4USbzrH
	 c9lvFXoY8TvBw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20260819154436.3225746-1-ekffu200098@gmail.com>
References: <20260819154436.3225746-1-ekffu200098@gmail.com>
Subject: Re: [PATCH] memblock: simplify reset_all_zones_managed_pages()
Message-Id: <178749651733.3573931.17983838083973436940.b4-ty@b4>
Date: Sun, 23 Aug 2026 17:48:37 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5312340008
X-Stat-Signature: biyk879mqjgdqwgo1a6fffsbac6itykc
X-Rspam-User: 
X-HE-Tag: 1787496523-497050
X-HE-Meta: U2FsdGVkX1/hQ1Jmfv4vlGACi72OT1q2LO8N44t0h2hVC5hKdc58MQi2HZtfoU/fj3C69TbVo2G4j85Qbu7hyKa1MA6BOXtJdPqCaLtelnH8EPepcfXHk0LNRMlfAdNKBTr+kUMf/i4RBIcMke99Ywr87ZRdrkcwK2P1OfOlu6FTl0I47ndE91bhsKnbvl04Yaaoc5EyCTGyVGPbcY+Gh2q9i5n9WA2LCLdq922wllXgx6ZfOp06XYnkYLEV3w0BhKcjpt8+K4c/uwA4b/ZG0zhgX7/j2OMD4j6CSaTbAcozUgzjBpAWee/q4qqqionbS7QIZkV+fEpqRLVek1TxvmdDfkywI3eusQE5BcLBZs1VatDWkHsX8r3gp7nLmjl/OoXphRolqxbPRgxuFj7+z7R+WV0GNjS3JW6NVe6DqVm+EeAgMd+QkW9BZuwuNUGJjbDRkl3eT1UbjpFwhYZaurHiB17MhcIO9dYOUpKyLjTV68tWn8IGeKPnNq2y3lxeXVJjXzCtmOaR9HMRPALtzAup+T78PGEw5c7eH/T3LglA2M5hyCmK6ARk/68viya1zapzd45XEFfc3s0pDbd296TgKXf2o58VWSJzJ66MLUdDsArHLKlq6vuDGEOqEtf1+kSI/C5iuQLzHPO+BzZ++VwFwOhmkOzz5xgTd2LlbZ9c8xQoA9AzvqrZwOcPLW29f88gXg83oFBmtbxRM8oiH1EbhyDhW0CVhEy5Oth/3cQUjXtmhylJCn7JTVAwaZVK4bwbwRv2vEmXk5Xtzl/5LNYU3DsPJ1B0+mYY4qRKCF7B2+BTpRut3FkHzlg+ZfuH7kGraWjyAHqJv1W2YGF0J7hng8tCvV6SzaO04gRSzntWyryPAWoDhp+XjyVBSW7gDAg5arDimKezZ9DYYnI3RH8E3G+wduwW4YrDEZ+DjpvoO5HLqVyeuBo2Yo8TEjb4aoGH/R9lFNSwiz0yOXa
 czQfoeGm
 jUE68P8QC4aibW0S/5Dbahg0xSNxnRfPZeK6STVNVgHNOK9ip/Qoexs3SqvwDjYoLUC3+E7jblCFK7wTVY02labUjaY2nwtrRR6H0E9rXZ9H3bddIN3xJ6YICg5AvWYGrVh1kFjJ4vyFJ3knu+W0H0NCgNoIKBET40M+O1UQLX9X1tWs7UctEHQJXhryKZYeiEOSnoxb6jdoj2MU8W3q6FZFLF2TZ0z75cRTr6zSp6ANIao4pVLOUUFubJfd0AiaCIXUustXj6y4cFn6ASGmlnm16z4MyWFKYVhmn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Aug 2026 00:44:34 +0900, Sang-Heon Jeon wrote:
> memblock: simplify reset_all_zones_managed_pages()

Applied to queue branch of memblock.git tree, thanks!

[1/1] memblock: simplify reset_all_zones_managed_pages()
      commit: ec03938cbaf99c44f97ffc106dd8ac3ccacfeece

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: queue

--
Sincerely yours,
Mike.



