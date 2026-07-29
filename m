Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2763EC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 06:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318D36B008C; Wed, 29 Jul 2026 02:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9D66B0092; Wed, 29 Jul 2026 02:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0A06B0093; Wed, 29 Jul 2026 02:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8C046B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 02:44:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D74A340556
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:43:58 +0000 (UTC)
X-FDA: 85040874156.29.0A1D34A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40CC0120005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 06:43:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvlQRu25;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785307437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caqnS6e4kiY3oUkt/HJWfEnD/2y5AMUZ+1hzT/P5Cy4=;
	b=C+JJ23KXZgo5flQfqeXZohQwHdB+xuW31vYdmDXPAEbog0Gnv/xVE9vBEfndn7WdLUfjol
	ihQRCBwKwoz5DAJGRttx3NZl440rsF4Tf8DRmTCBWw+ae5dsh+zIs7xr62h04ne1B1KseI
	BWQkncLyrC0JsktWtK26LvsIi4hy4MY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvlQRu25;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785307437;
	b=IBjU7AKVoWoK1Qcq93FgX5rn9ZhZx9fUYWopB6cowZ7S6aY5VV3J74XOk7RuyLlNSUoT7o
	aeettyz78Y3gJ8Hc/wAsz5Rtf3L788NyvzuqemeqKw/QzlIOSTyOQcNa7UEXTbBv5F3xfn
	4wxxxBX+OKFMHqO8X1NkpwG50UcTyvs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AAAF43EA4;
	Wed, 29 Jul 2026 06:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF831F000E9;
	Wed, 29 Jul 2026 06:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785307436;
	bh=caqnS6e4kiY3oUkt/HJWfEnD/2y5AMUZ+1hzT/P5Cy4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=dvlQRu25NfTiF+5Ce8PRfJhxILSry53XqUXJ6ZP8ClrUQfOGtUFRdtGBLfkVubWfk
	 J/M+UDqVFOPPyrh1Pz2wZTwRpK/UxiKeNMAjkLOE6v3Gxtc7hd4Xc0aHq+qrdJpJZx
	 bAUirRJO5TTbeiE1C4429EyLrJ+QDiVHtfmMV7d4LELX72McLgOFbgV8KIeoYTtDkf
	 me/XZz4oyu4OO4/07X6qzonX+rBQg8H38JOatio7+Id9QfeercNt/kYelqV+0YtAgO
	 rcEjucc6Kq7sdJ7FW1aTUx5ZS77Yyd7yZPlRzhZ8q3dit23oB0Pp3mu6JII93WZRNa
	 xw90Lr0iSJLEw==
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260727150240.889555-1-pratyush@kernel.org>
References: <20260727150240.889555-1-pratyush@kernel.org>
Subject: Re: [PATCH] kho: fix size calculation in
 kho_preserved_memory_reserve()
Message-Id: <178530738771.1195472.13332239668735060040.b4-ty@b4>
Date: Wed, 29 Jul 2026 09:43:07 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 40CC0120005
X-Stat-Signature: 9y6rbyqyt6qiucspiibi6pjmypf5xgaj
X-HE-Tag: 1785307437-769923
X-HE-Meta: U2FsdGVkX18mLVvE4mSZJUm2dxV0tvwBahj7B9R0g9e9g4iO/3HM9cvmLZOlQwriY5FKeUjOMhSjh6c/GHfYB5VqdXZh3s+2TLGeqp6P/L1UE02YZES4tQrpOw7ruhZBquyIA2EOXNtG3/4W5IvZr7xnDxZn+kvL4greTIakhSx6Ctd55gjmMFO56DE4jZdIr6EEbGWWejVbjhEmuqAsL7ipFFZUxltMWi46WdcgLhgOkl9oP/VbLWvl2ZRHezVAzYVzuNiC9zyNSRSObQtrWd1yklbQHbzR5Jz5F2ykQ3R0WxKSZMK5e0ljXAAYjXH+x0VBpH1GvrMW/3j+X2ebenNa5GlW3cS5uTLEl36/SNNM9hj0bymIzZOjHFZ0NWqOsk0aqhhpUytysDeyANzxb6KncPEjHg2vsyPEbPlapsjWZUStAgNau8pv0lwmKvNDMD3Y8ET38ILmSM24DJvfJrQ+vQ5tAbEdbW8l1w5ZhgR7RtQcIDOphic5nTvahX0I3owfwj1UH74jPYhAXKzY6zu10FkY6JML+h3n/ITSUwV5x3YqlD/PpWf4jNi6UHfu6ej0j3qR7hZvXpORa9HZi5yoZMEE+vjg2Ky7B3N2nhyloLO0YeHQMnpVoUBMaooxKCikBtL/zW9rXHy0ga/CzlV9RM16tyesj5mMUF7IhuflaDY+PvynpHtSaVQ6o7nZ7/kY1IwZ1E1PNARqZJ4ddy3Mnt7Pv40HH5jCXckz8nqCggFxe0bMqEIOZX//K/dBjNviKgtSyALdhe6r356wpov2FkG4jtXd3Q7bX+a6xBdt/yf2D+OrJSWqheoYEAQx09pNoXDPcEoipB4bQeyXUgSBFhDGPs+oBNf45jpWRIx2KVVJir2bE6hH0FM1DO1ujm6XFsinlO8LUlh5vFS1xXGqSb4Z7T8iSsTh6rOauSoqvrHWNhz3r0SP1STDzo1WGobCb4mLPb7e52VRQ6f
 6bppXtoR
 o+PSSUeKXj9JL9BJ0Vr8+q4SEcx09gq7iPdtAloKoI34A1pht5ugt3Azy3IjI1AOwc0t8YbaiQG7Yq9ZPlwPyx+SdyR4RkMp/uFx253kh/eRg2oR6uzd7pXT4XpqgzZlO52jzaHJ4qdNpUIB7+a618GpGmbe2m6xybLZeWUycYPXMI0t6ppJSengYr6e+SWlKub2NDXoI/HeuiEIDyZAII2V+ZFLqeX8m6VQyaklrnBO84gtrkvcMr8izOdSbsKtmzBB+WSe+9oigZOLfCsmy/OeiSWs2sf5V6Atf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 17:02:39 +0200, Pratyush Yadav wrote:
> kho: fix size calculation in kho_preserved_memory_reserve()

Applied to fixes branch of liveupdate/linux.git tree, thanks!

[1/1] kho: fix size calculation in kho_preserved_memory_reserve()
      commit: 3a0b8fa2eb36afc88b62a95f33f0c77c71fa5ded

tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
branch: fixes

--
Sincerely yours,
Mike.



