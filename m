Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80554606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cQg6Fz14
Received: by kanga.kvack.org (Postfix)
	id 997B96B05BC; Wed,  4 Nov 2026 08:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9482F6B05BD; Wed,  4 Nov 2026 08:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E826B05BE; Wed,  4 Nov 2026 08:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 654F06B05BC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:46:03 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0487416074D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:46:02 +0000 (UTC)
X-FDA: 85397560206.23.6CE3C26
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 526202000F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:45:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cQg6Fz14;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGFVMoJRZR79GkB1zDENh+lvuQ8N4gNHeoEkuezJ4HQ=;
	b=6YfN9CGxRUP1FEg4oUeQ+pNjYEYNsog7xPyvxvkqUhf9qrRuXYn6TulDdHxR0NpSL0YzLV
	HHDokhHoL/gwrnVDI5mHJ9A/EiX5gEiRSYYL6yuD7R1STOYJQCl+VTrAlQP0y1zjPqk1aj
	e6z47qjB9DRpUGT/knOCigmizo/rYPk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799961;
	b=URTz3YfZ57bI473szowvGfJAkLgTVMKbsNrxBaG4RyyVWLcB0/DZjKZYGIukWc/jFrDWjx
	LlPOFX51BkI9rt8D+/bjVWtcAG2SaBm7Mj10v9IWLewDiYe7I6+mNkJGxq5g0zfyqHKabf
	zx0rU6O2vMpLWvhnzvDUQ4cU56DZFDI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cQg6Fz14;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793799955; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=QGFVMoJRZR79GkB1zDENh+lvuQ8N4gNHeoEkuezJ4HQ=;
	b=cQg6Fz141ge859rVLWY64KUCghhlsaItbkiCFQe6EVIflNVQlxpPjgQMulwHxXxIXqftbxwIOLwAU1osu38QwTZ1OVStPuUGAovtEsadxQm01p3GSgKBymPQtuN1TW+voyCN+Gr1lEcocPn8GUXgA4uoWCSUxL8Z6twnuz2211k=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R971e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XE5sgSS_1793799951;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE5sgSS_1793799951 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 21:45:55 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: sashiko-bot@kernel.org
Cc: alex@ghiti.fr,
	graf@amazon.com,
	guoren@kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	palmer@dabbelt.com,
	pasha.tatashin@soleen.com,
	pjw@kernel.org,
	pratyush@kernel.org,
	rppt@kernel.org,
	shuah@kernel.org
Subject: Re: [PATCH v2 3/5] riscv: Add support for kexec handover (KHO)
Date: Wed,  4 Nov 2026 21:45:47 +0800
Message-ID: <20261104134550.1779-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-196857@kernel.org>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com> <20261103080926.2079-4-cp0613@linux.alibaba.com> <sashiko-outbox-196857@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o3fsowzhttfbe64thchph5zns3m5uy6h
X-Rspam-User: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 526202000F
X-HE-Tag: 1793799959-819205
X-HE-Meta: U2FsdGVkX1+X/caOt3FwCg5122NR5YvPmat81ztX4lbYteH4UC3A4v+gFp4SLikEcNZSjjqiDSS2aREV70JgXVJd+bM6V/22L6C9y0YUPgU0MumEmvJwqELE9ZA2h5Lw1RIXYUw2SUlE7E79LreGec7R/tIQd/zIe0YqMozAXnJWhR0OAZAeWjFbFYpozdeZtbjnP+CczToQenCRzSrPvr+WhGipwJabH2oaJOxzMXg4wePF/p+zSLhH7nlWhYRRHISrXuXpBcTXoTtn+xQ00uikCXPY2Zqru6N5aQCokoLyzsyzh7mAL+/Qtv99vBfXWGgGcBE66xD+wiFJ5cJoiYoRyqIDaAQAP5ZMryz6Yd1Ij6Ij2pSvtc+hwcAng+JF5lRahxAdKcP5JKGhoL5hH4iE1/NXZIw6akbykIXj21frb8VDA5PlAvUNqMtRzH/FilO/qRh0MMCirc5imyq37Wlfa6ONxJNy6zinKQ/RksnRM5snedtCVFmRK4eXWB9+0uhliEEyArRkELRmvUlLbmyogwujEj9NfqYgqpJRnp3F0If7HeCSa81ewUb3u9E0+gIrVvowPM2DA2ApPIvLrhOO9Te0TH3cW9VcL1uRTfQAf2LrKidBguE0cziBrql5A5SemMYLuzV9fHUQ2U1eHLTIXLBQ5CMw28UIhxNums1Dk6z4Bs+WP7h3WswqgUFDj6+CFJ0ujGJIqXMxlgIfO+UM9ZIiT7Sn0FMlG4bwYHhnHGDNib7F891S4NbM/Iw7pGhXY+GiI/OP2ZpTxU+bM0yvmloXconv594XPkKftcGHN1aOyN3qVcoMh6Eu1CPi9OT3UdibKiWHZrHLzvkBNjiVq6H6+ZzWq+QE6jXktWNSZnz/8DflVWaeq8LdhcnU0z1MGLEAEHn3zK16fZs7SZuWiVOHeu9wBb2yI//2YJ9fblqAj+rq4r4P7MALrNOnzRcd+G2T/gDtvbjZwbO
 pL5FhIIC
 Uc+lG+vLU63mee+r21WkIQy7G3MU6KNo/GxUZO7UGLpeUghadsIWZlxRVPLCNaLH0rCiLqwPLiJiu/pJf27dQ4rlD6ZAnDNjOlLEuv7LJDlzn3gX7b9O2ktYNqpH8Us+YaDvQq77bM/n+/ctj4kOroB+aPgRX5QdhdFyu/uMR9W8aMJ2xND3Zjvhp1igNmmc9yYKLMdXvNV9FFXW3q0kuHKz3NtuK1rE53KZGhvy6ci4ko+mGDUmVsy5KOzda7cxaeczKRgVVMt/peeep9QC4iP1DwS8O94gOQD+x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> As reported by Sashiko on v1 [1], will kho_reserve_bootmem() fail on 64-bit
> RISC-V platforms where DRAM starts at or above 4 GiB, or record a 0-byte
> region when all DRAM lies below 4 GiB?

Both, confirmed by measurement, and neither is riscv code. Mike Rapoport
has a patch that resolves it, so this series carries nothing for it:

https://lore.kernel.org/kexec/20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org/

Best regards,
Chen

