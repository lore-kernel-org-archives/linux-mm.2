Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFE93606A332
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mk1ZYGFW
Received: by kanga.kvack.org (Postfix)
	id 2FFD86B05B1; Tue, 17 Nov 2026 19:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288B36B05B2; Tue, 17 Nov 2026 19:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6046B05B3; Tue, 17 Nov 2026 19:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E238E6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:20:11 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DBC280654
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:20:11 +0000 (UTC)
X-FDA: 85446332622.10.0812891
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA3B540008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:20:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mk1ZYGFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794961209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6so24GezOUeLshnz+r9/uQrQbBVW4KNO24KQxAvhjmo=;
	b=c+WdJrvJ8Ufs2Y81FrEf51d0CkiGLKJlHRPkPLDmaoRZhs8ozKM2wfrbIGmSHF3y04A48b
	LcGhJVmOUMbrA6y3wLw8yHIWYYnvsQrmLvhep7GM9Ije00ol9t6Z1/7gCqijfDlilOsaEO
	OEiXKmQD4l6lmCd1+Krmz4Cmutxd1pQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mk1ZYGFW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794961209;
	b=NjPsf7KuC9PyhL6WcP1YFMuZND84Wg1sROZUmT3A+ZAfPyIN1sVHtqVpDOgaw2NvTOwH1L
	LqEq2TZM6tYl4pPRX++NfUnqN3QSWsfEIf8Fe/+AgYKKjaII8Qdf8d/aWmABG1KnD0GKTd
	8WYNBt3YAf8Bhn7P09TTWIrS523yrvg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7F5F6116B;
	Wed, 18 Nov 2026 00:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822391F000C9;
	Wed, 18 Nov 2026 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794961208;
	bh=6so24GezOUeLshnz+r9/uQrQbBVW4KNO24KQxAvhjmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mk1ZYGFWyc+Mg2qwBo1YPEdoME2QsUO23tOY4Sd1WHLz7FiFJwSoETTqb5YJe9RW9
	 dPOclLekAsH55cDRB3qoSJGeVtun/8ZpUsIBzxPldTNcDevM2dF/RmizvQcfhTUNwC
	 cOCBRY0/v1Dp/q++QzuaXVs70w7kq+bMT3qzJ5rTiqM8nzaQn0KxdKsp5GLRSmB4t0
	 bL6rBbrCEOYibTL3ryvZHT2CyZkyISySrVc98+I5clhoW8WY2magEPyJC0p/JBA5kP
	 BFqEeK8Sp85poQLLF6AuHjX/l/DVvT580UYwJILgulmFFKm4Wij2+2FrlHSbft6NG2
	 snD9dn+wpDXww==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	akpm@linux-foundation.org,
	mathieu.desnoyers@efficios.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	Dmitrii Chervov <fary.ru@gmail.com>
Subject: Re: [PATCH 6.12.y] mm: fix OOM killer inaccuracy on large many-core systems
Date: Tue, 17 Nov 2026 19:19:55 -0500
Message-ID: <2026-11-17-1-daily-reply-0004@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261117124938.72111-1-fary.ru@gmail.com>
References: <20261117124938.72111-1-fary.ru@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA3B540008
X-Stat-Signature: gzmrsnjmpsxozkmyt4f7piuy9re31m9b
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794961209-162731
X-HE-Meta: U2FsdGVkX18TNPLGeYfoCNZPUx9XxlD+qKjwmZyY9myQjs9fZZE8+3/L0YONKX0BtYZHRA+ZM01ZZunEAm/FOyZzNtj0a/PbZkzM99G+Uz28lVgxRfZT3Zz+GcX5dKR5PETMQ56Ol/JQ7qsdBXFPEvxLlho/F3ofpu7GHhpizDjTot5+ynLc4adVZfb7P11CdturP0kVdXt3dqQXCI/3kmPeiZ/CB8Ay8y4MwNDPiQSeo2jF/KEvpnBB3MqSlyj+zT9tiBMKIYi4iqXUfqC9qh8aDeilu+cv0yMifmPK3fFQ/ed1XcOZrQfTVIjGwgI/EbFpsIrqFxhLVce/Y51pwEM6Q7uxGhT6HKvRWwB/UwcLolZZ+LFxQkvADeUD00eL3Wj8c087YeDHg29u0Xbb1tg79jIn3Fi/oBXLM8QeN+lq/AXCLUNXgt4hndwI9Y5olvwgM7Vvpa7KsL0aiybrexsmihO/JrjzwNosQQ2ZTroPL7FuigNRT9186dA6aDaQQUdUQFEaxUyYh12t9PCLP421r1uEwLMf0lb5FFjGXTeJLYFrqDYa83A2GU6IwRqTh+vtrgNK531TkRtLfpZjsfmGjgfy07dOxiL8ykrrvsuQitQLm5bqbitUXK5D6zuJ8aJ1rOQddA8O6zdKSQD7FDmGLXhevflNpkuWyH0NSmIs83ht+vQ/qBI8Kux8d36n/rxE3dB8tLhT+2n9YUZeZ2hewlLM0EL6rgg54yuX6VhG+luQrpJETA3UHsDJd+p/VEcIyw0WJMfK27/knlMsORS1gf2r0Mj62IOpj2VkJeS4y3uxXyrJ82bkk4qFmXh2XgR67/LBeb9t58oQI/K8eLrLpZZVPdVNJ3xukKs18EBIo3pDXkXl/HVMp+V5FT3+44lXVtA3Qo/h8wJDXeqbb7sUK0c3YrapnNni4mU1vwW0xrXBh2hB11k7vlwRlBNRVRXQ4Mkd5V2llcc1ITM
 P1ETofX6
 Z6cO33EEkqCV+CJEGvn7DHrZRFZR9KPNuyxHBsb8wb6K6keAGvALHGjLxatCtfrZM6j96AOS3gF9+mSGFPgtWLCHTkmYrAsA8ydBhvQhrYF+xHIMIYCAhoWLqAsuWnP7yZy72FFE5h+KtkamzcmLp7nuCJBJ7BYDyrY7c7DgqOJ38aaba3zcnns5IOFVyD087QzMGOtjTWapYMZM2DOH8onHwTCnPZIgeGKYF44lRb5bSxR7OhGKhSlp5x6bkJIug9hy1HLSfwGA004uQmfzQZvwz5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [ Upstream commit 5898aa8f9a0b42fe1f65c7364010ab15ec5c38bf ]
>
> Use the precise, albeit slower, precise RSS counter sums for the OOM
> killer task selection and console dumps.

Queued for 6.18 and 6.12, thanks.

-- 
Thanks,
Sasha

