Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E47F3D5FB
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 14:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF13E6B0092; Sun, 29 Mar 2026 10:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7AAC6B0095; Sun, 29 Mar 2026 10:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A3D6B0096; Sun, 29 Mar 2026 10:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1E1A6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 10:53:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 726031B7D08
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:53:23 +0000 (UTC)
X-FDA: 84599393886.12.B837318
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA5E3C0004
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 14:53:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jui8O7Fg;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774796001; a=rsa-sha256;
	cv=none;
	b=1LVNaDttFnQzUsuL6g3+TCTF5L3AGh+3xOtrekx5+iXsy1Ro2xxXZVPomjB7qMPNV9Ww2T
	taKZd/qMeTHrXNBbTnm5ysgOCQDRtZtfTFEBR4tVMpvV7fko1x2mobCTfU39eG8gJDTdDI
	kkm+YbBNnm4sPrUDAGdFc7em4/UOyDw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774796001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyBMEBVF4VO18eKUw3tH04vxhl2TguWEgEoBE6E7omk=;
	b=ltDuvo0MxHzmmh/ZIr3+XR05USDGCZwfRtGs+dK6CMWLVEDF03HYNyggGwUzVx9DxsVA1A
	ItdvtJ8995TGSVkkjTBGlISBYkXjEhR664cOwZHidAVXYHG7/8Of80H0U526MiqdXZZWRl
	D0WmoRMHo9WrzVee+K39ycRls91VxQY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jui8O7Fg;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BE9B600AC;
	Sun, 29 Mar 2026 14:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6BEC116C6;
	Sun, 29 Mar 2026 14:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774796001;
	bh=XKaT9syjyaCnbMPh9xU8yW2PFKGdVEwY+cGqHnzDB+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jui8O7FgvptlbXRZq73j9aMgokf476nbtGQfAayqrFGPM5M1rqd3PpYfp9BAMi6/C
	 fL1eqbXYDifbXJ8uOXBFoP/6CRY0JlTE7WsCOXYv8Ql9LuLfyErLa7+KlLM2FglaGU
	 qbE5Etji81WZiWyePGrLmECgunM4syabk01Xu1dgjjtuUczAsxEZBM5tqWAQc7x9Ag
	 IaKBp8zyGiEw04kTG2hbFf5L5x/F5oyVogAqGad+/+NX1nwsqKQDDM5nPSRUd2vcIj
	 4zjY/4Nq2TyBDizlHXcJYuS38zhF0RVFNBAb/WiGcUeD58vRzBqwh8uFdWKGlhl8Y5
	 e/uWoPCGQRWBg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH v2] mm/damon: add synchronous commit for commit_inputs
Date: Sun, 29 Mar 2026 07:53:18 -0700
Message-ID: <20260329145319.47226-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260329095602.3471-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DA5E3C0004
X-Stat-Signature: 9j3o1dkd51tt4wshs69hxozpsj4kzyoa
X-HE-Tag: 1774796001-5107
X-HE-Meta: U2FsdGVkX1/CqxNsfb8QrYsttIsKLXTLvkPRXlaT+p7e9h1/QQ8r5w+HIWMru2kWEBMdxakEBTln5tL0MEPHfqWPJqcYfC/OeJBe9Yw3R44S6ys0en+iEjYX7hZL89FRBdGYbrdcvG9Bts4dMopM0gi4LcG1gIpJH/O1lq5e7FtmdPgZURRYeGpMTQUMA03QGEkFlJdCyseDay7yyeUv986Pma9bFAKzZqwitBpw79iawElsLUcDxvf9CArc5HGBV1l4Ej+NTf9qWR5ZP4FUN/KNov7t9fMgRtg5pwZo3qi0StvVsk3ChAPPILXcOQq/9TSD79nw3ARntSzqqDpUTeBYkDcx8IoDdruNPgyt6mkZrif4Fgin64zEnk73j0j0PKHW1EzzK3zgHFH0N2XLAviLUJJ5FzYsetwdd6hmhrO03EKdyCm6z6pGbE0NmIvxhGSbPVI2E96jOWdPXyuMhZRXBC1zlR0TqZAlRNgmtsD3kJxNCkmJ+wqKqwK3KevMcyqJjy92DsiMNqWO0dO9vFuKokhLoS8uJrTB7sBA1lwJvWcP8d7vXSSNVsqEYgy6t0Q4Nhfr5CFkog036c3UIGQOT2j2+ipfpwk815EavB4P+KQF8WS2DAWLCIRTukFpq5y7d+8vH+mPbLQchtozBpNhmCbrvVD5znhlzZ8fA1JTngkx+uPQHB/3tShMn3Bc0s6JmMSaFV1NKlqT/f4K8hRQCDR8SbLG/bka6Vz+WFgQd3PhvuycTahBOQu3WwAyRkrtpY+p/yruBcP10NwWB7FM1CaN1ZdCs3w56rFC3uvcPrNPG06W3jXHCOBuXdyoDKGjg5//wIScAES15+F4vS9KubihFAtSpYqC9RoB2uCMPpgXIdHdI4M5nb34egCpNkEXuie082wEMCsJDOt4oartoTWqANTxI3WMAyckQnH5hxSMY9QXkd2ymHOVqUj83z4GemmtmfZljz74bn8
 oAt+5d8d
 lbJm0JkctMy52G0BBlVKprVvuzrFaHW5D9Hgwek1tnE9m5jTh00y5ucmSDMQqZMJUVD90ZYXwaPkBMDqR0qc0GiOqx6Hnt26qwzR4AaG8K63Nl0H3KVKUE9oyuvdgIQ8+vbjTzlAmXEjr8/Zjs19hpuPszXRlieiQk87qmOWhnMCfGkAcMiH/zIFaRPfdKfAowbWDIwbrPX95zynZzcwOQkNLY/ShW4qvgHqGukc9kDBR4cE4hktEWLiVDkfGBw91xsnr9MccCiq4l+ED2+PBwpM2bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 29 Mar 2026 17:56:02 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Forwarding Sashiko review for doing discussions via mails.

To my understanding, all the comments are same to those for v1, which we
concluded to be no real issues.  Please let me know if I'm missing something.


Thanks,
SJ

[...]

