Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D8C7CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9863F6B0095; Thu, 15 Oct 2026 10:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936ED6B0096; Thu, 15 Oct 2026 10:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84CB76B0099; Thu, 15 Oct 2026 10:05:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD4C6B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:05:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2ECF1409F6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:05:11 +0000 (UTC)
X-FDA: 85325032422.22.9868812
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 30D8620010
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:05:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tnslj58V;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792073110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ocp4Et+sK/z58kpgz7L+Txb0eSLyo+tHlzKReRnPCk=;
	b=JNWBtIy3hVU6/BNkkhaOdvO5KgRu6qkev5iKo5C+TXSGKYUPXKSBYlAEDNpRRT0LhkqvX7
	v3x9JDmpCzy/Wu7nbj6lwtY7KJb7ClInQEOD+oHVTFGgTcLLl/83SoDhABAn3zu5SZniX+
	B+H1FfO2S+xlsQnyrSGy9xauB1GIcoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792073110;
	b=TurRz8OStfCq17/K3nbs5IzyafMWRJjCu/Oflp7dnbkKymw7BxNFfouij2Q69G0JbNu8uZ
	csCOm7ervE7KUmoIvEUMMPBX3vPBWWIlkj+0i7eN7njNDCU9/zYsYNtKBWE0+TBamgCJmN
	c1vlmGXQDPdm4LE4Nntx0RXGiZP+lq4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tnslj58V;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33829416EA;
	Thu, 15 Oct 2026 14:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE891F000C6;
	Thu, 15 Oct 2026 14:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792073109;
	bh=5ocp4Et+sK/z58kpgz7L+Txb0eSLyo+tHlzKReRnPCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tnslj58VcWVpVH2J5Em3kGZqb2Lv4pzwZPtldGD6fzcLiFwsjPKtWdAsQZkqfue0H
	 q00IUB0TkvRYKIgWrzOBh40ZHTyE+yumCC83Kh3a4i23PUYwQmkyu8sKarYwII/AUk
	 Wj0yW11JgnqZUMdpMcycBUwI5wglVWWoPVhckHTzt2zx5zNbFmw0QzlNehMyhnKHk3
	 vOiFHoRdFXUX4NJ2FmDrVjLlWrEoiAYXF+sk2KbRbW2sqHj0q0jFtz2K/lN9Lh6tCw
	 5atdSz442mcHmcBok5QP2DHIuOkz8reEfp/1+cIArP7LybmAgo0VsSmSZRAblYCi7g
	 zCWLXW/5CPIUQ==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] DAMON sysfs: failed update clears tried_regions snapshot
Date: Thu, 15 Oct 2026 07:05:01 -0700
Message-ID: <20261015140502.87975-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmHo94dwHVMWeUfQsks0b30uZT0wuV8mDQ9MjB-HL0yVnA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 30D8620010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: aa9y189xmcx8zx1fri74k6b35i4t46rg
X-HE-Tag: 1792073110-347774
X-HE-Meta: U2FsdGVkX1/vcjJikM1mq4yGTftn2APFdoHszvYZYz5KonQ9Cq345dRiRu3Up0uH5+uXFGRFxAu2tgbAtplWmskskBpL25o32jmfUR9QJjT7z5ZXaYnlDfzUqifiVeVMejGCJIuGogQV5N9GHm0qqoAvTVq31NZf0oO1lZDSPBsMwWGceQ+/M/vRnN/7hdLltwggv7Cao3j1rkBVl7bswGjwU4OdNEjHHPGiSfnT4bN0OChFovhHkZBhd1sCQlX7E2aZ2QOr+zbr3ssiAZxyBCTj7EzDG8CMO5S4eLHNb7YHGPjAANrYZuvAGIAWsAJajekztkT854wHYQTPhD8g4qztspeg09DninuUkDNHA8r4EKJT7Mmb6QbWOfW6x9e3JO7u4slDhRI7RKsDM5Bgpnd9tdbT1IkNPmgoSY6eGybxPvQ9KjFEwjwI3mvHoIVvL+JuJRRci49ppvReMcF8Up+MM1+YTMPi1IYHUHGzDrbUpm0j17FcESv9Rnz2ebPwzF4SgQXpBsezGKicZ/OQ+A3KUEptgJWtF3oDDZDv8RCTh7Trx84bn6+xCTsmBmRc23WNZYPIngIQmMV62jkryfDuMSJpnWtrKXcp9/r1RS848ozPMHn5QgsPyNckpJ9AjVQvRbMcyYHFGHsu/5b4s+Rr4wsytvJsS2Mmdpl+1tdLGuSZGcdwTSnGINh3ucT4420TR++pWmlSZEtHRGORImE92E5v/5E2bA17/EI16Wj7+cG2M+vExG1rp+xswOtEPi19Q88D5QIDIKSTO3igITxPUIRUV260Sg0nq5D74eYkduhkH83AGb2VsCunL7zSF5sO2rTggAMP2lvtxbUwqa1brRy3xRvA9klfdbgMw1C20j8gTFlEzzU/TLV94wZYIbgXtnEriUTUl/rF4axxlFVrTRIhowLFpB2nVA1Acm7517OtU775/HspKM4Vi5zkxNQ8qcapNwC+4CIVznD
 BtG8KXUk
 3G6FHxagA/pDvbuPVMAc0FjXcVSUSJokSE7x58W53e7h9hevdNq5UCJ9cRsx33OWerblnIQ3u6kMGPVc0dH/sLBbJZJpfIVoYGYkf9EbFetKkUbCZWCOZ0AK5nmeMhl2ym+kkPaVwSlpzCRD7TGpPamc1N4sZrsd8e/8yInIHW30DE5xy/kMI4GtU1o0Nu5OMtTsGeXX4d2IOIgK5IgltbWby/JeO2qGtXk39Sr52hxQJwRVcS+DUjvApRzPd1YrR7ZtGQX88H5oHi167yX318hp6ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Avelin,

On Thu, 15 Oct 2026 07:22:38 -0400 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi,
> 
> On mm-new commit ad9f2d463666, requesting
> update_schemes_tried_regions after stopping a kdamond returns
> -ECANCELED and clears the previous tried_regions snapshot.  The final
> result collected before "off" is then lost.

Could you further share your use case that this behavior becomes a real
problem?  Also, have you tried bisecting this to find from when this behavior
was introduced?  If so, could you share the commit that introduced this
behavior?


THanks,
SJ

[...]

