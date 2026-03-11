Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27ABAFD88D3
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 00:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38AED6B0089; Tue, 10 Mar 2026 20:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336116B008A; Tue, 10 Mar 2026 20:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2256B6B008C; Tue, 10 Mar 2026 20:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F2A1B6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 20:03:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 90EEB1B7B0F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:03:01 +0000 (UTC)
X-FDA: 84531831762.03.3126D95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 03A88C0009
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 00:02:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0aDpCOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773187380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yxj7r9wH3pzid38977WanAD9mEZHOMtbGNJB/MLLSuo=;
	b=Rb9ccsxl6occb2tcJG+OtVPvyPEwa0RaEOZN+PJ7zQP55qFEw+3mHLcayea3U6/y80ByJk
	V0rNjcucmqq8F2K2y50GRlh27Epx0TXpvGahLc4izPmD6gGoCHiIPZvT3hZLh4tYyhsXjc
	j2VFeE0VgyhLGM1bZY9WceeUJfxjw6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773187380; a=rsa-sha256;
	cv=none;
	b=BuhLal4OR2ryy0WPHK/ZLioLjqZlXxw5Gh/86ik4mhX/AohfyuBHqyUxcy4/74vzH/Rpl5
	17FX7YgGraI4kSCUobcvrmKOGiKcanE7YgUmU91F8KtLyFtvhzSmDSg291T5Z0diHfdNF8
	0iRjOMbucH4LFvaax0um+tkLTKcyBrk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X0aDpCOm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49431600B0;
	Wed, 11 Mar 2026 00:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF54C19423;
	Wed, 11 Mar 2026 00:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773187379;
	bh=gAo8pIpamNKNwt/umJfrAxt22Tj7aXcndH4imspEA14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0aDpCOm8sxO8E04vKcPXSSuW9A/LnB6sSr8h33EbNA1n2ceJET0kYl+RnAVm/OKt
	 M/ivmJ52Jj50SKUfeORGMT2cmDLTr9gLITDK/H8h4RZuqFFostn/7us5r/cUhi2mi1
	 ganYQToKkx50yRtVRfFxM4dtMzMQXkkLYMQR/3TmzLYMWPnT8gkuqhEFsIfRbGg9bY
	 BapKRT/mT3Sb9eTC+1iFsGRf4Q85l1wo91fQACABBMqXq/uVZlmUqnJ6NyW9a3F6BN
	 pSE7FqG1ztRQg3FOchbpKugNWh8T8UZMfSDYybyv4Zua6XhqT0C7xB7UzCY1sLegko
	 NExKtC3XqcEBw==
From: SeongJae Park <sj@kernel.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] docs: mm: fix typo in numa_memory_policy.rst
Date: Tue, 10 Mar 2026 17:02:50 -0700
Message-ID: <20260311000251.89967-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310151837.5888-1-akinobu.mita@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03A88C0009
X-Stat-Signature: ffo6454zspzcdsixegyj348gkp9irefe
X-Rspam-User: 
X-HE-Tag: 1773187379-406561
X-HE-Meta: U2FsdGVkX18Pv8Cf1Ioz/IbQoiIE2nMYh0pjgFBOCpiuXgsudaCn6ox3X3jeYcA51oGJTlSm+Nc6QwcnzVnodApu2uEwqlIQt0JcOe0RR81jBP0XaZuKIP3lX+DTQ5gbNtS5l65cLB2oyDiXBNtDQF4QZVfqgSTNkGWFj44FxKq/saOeopzCH0akieOYs+H7OKiqw6viqVTWgyj6jdBRojoVzmMTYR2iRd+PUV17+FeRIYuUXX/9VwKHcmxF2IsUp/PrHXPEr2l7+VTqZPTUomVV8g+GP1U0ZV7WzV9sAYfQTxUs7qGRSE+XDPBlMDXl5HQvTV7deCB42DDg22NTXKkuCXFIR41jiK+Z7R1Kiq4hg7vHhbLeQLZxbPQt4fS2XUiZht+UykTxVFd9SVlcr/UN+T2pBavJdcRndxnQL08uLxvvPl/5vhnPCeAkv/pXB9dVfMHyu9kFNKTBFrJaXGxyCORd0eyLab5kGXJSwdX07yoIMfaSO+QgZ+Vq+jhVBVNK2NvZDDpbHTWKaM8NvGL0XjG2Vb6AxRP/KQy+dsXREkVAXZhgSLZRO6IKHozBtrl0h9KY6fXJ5PDJEAYbUkcVtNBw5t/FLnY9qGVF+/DLsqchtuNAOz8FeKTHr7faerDwwA5qjRwEfCM2ugfOYhqqYwEUC6iWT5TXTygkNHZ9ZCYCpSa5xmf9wZIjkYxK+KnleMChbfCUf6Y6siab1JSCjM+DwwRaqUbycrQZUEZG2wb1r9jz72iaH0c641ojZzVLDTo04ACG/q9MOaVINTA/TMxMEMzRnsLQ8glG8UphdWXR0fzDx/83u2rcKH/SAnYc1i4R3JHHVHU8QoyFtuMwDzVwtuBIz6IGer8AZifiU6OPVOK8OjAetyMIbZm+U4aR5IfLpWie4weSaUr/uqgoD8ZcokWCgr2TlCBYvUhK2Y3C/Y0SOtY6y4DFKmNKi823HC6wEAZKQHi6alU
 BiJhnj/K
 ks1TTgT0eekO3LK1Z54mAog4JN0w1gMNU99r1QMqOkLcnLymRQKBBy1niM8iKSF0mueoUNKUgboGgLm7bJYsBBv8u2lePIggLV5qOysgF/6/7Vg7KYtNEUFWLKQYOvcLcTqeKgWpiwWZ7NyfKWfrDitnHnZyDCnCSzts2KkQyfgum4upUOmoK1qgqjxZ6JN1UOQ61yThqnDOqgCZ/GOQAsceOoOw5uT58sCzyojXX/vKF3oDoHBg3J7iT021wSvSxcnVloH4kCP/3J1VEFt7D8KcNOv4M1aGf7eEK3Us8I4UUMDa524OmFyp4YAta23Hnb8/LLzio9VfSEncrAs6xB+vSBmVaBF177dhkzFWZjWP32cT+kHpOBTjZLxZflmH95m5WZdhJr2X0Iak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 00:18:37 +0900 Akinobu Mita <akinobu.mita@gmail.com> wrote:

> Fix a typo: MPOL_INTERLEAVED -> MPOL_INTERLEAVE.

Nice catch.

> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

