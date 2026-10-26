Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEA8606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wxpYa9L1
Received: by kanga.kvack.org (Postfix)
	id 3D5016B05B0; Mon, 26 Oct 2026 05:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385196B05B1; Mon, 26 Oct 2026 05:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 274336B05B2; Mon, 26 Oct 2026 05:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 014616B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:16:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E59BB14067D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:16:00 +0000 (UTC)
X-FDA: 85364220480.01.F489F2E
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5F3EE160008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:15:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wxpYa9L1;
	spf=pass (imf08.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793006159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=US0uto/7eSBm2nirGVeihVV9dWVz4q+SUEGpM6IyKCM=;
	b=Ab7r0rGcNS63qF9sayA+0QuXLdmFgDGkMgIhT5pc7nrVmvPJp9kAY+rrzGHhBRWHejmscZ
	jwPR54Y4xaTOrvTIRqmD6rRIyInW3DnM/XGOSS84LfvJH0408J4vb89sXYAphSdmHm0KfP
	iKRSlaC1IYIsNRgVQlUoCCOUN6GLwSc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793006159;
	b=bfg6mFhcLtUIwcBTMjNWd1PlpTjrLadY2r+kNyE0OZCMyQGF8UoUW8wf3XJDyaRsyMjAeY
	JV1FFggBNu1B468/2FgneHS+1/2OMk7EOGPIhPC6ELFv+5cxV5iyp4lWyBCEN6FJZTdGKn
	JwihkvtdBihDBYqU+db59TwvijiA1mA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wxpYa9L1;
	spf=pass (imf08.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793006154; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=US0uto/7eSBm2nirGVeihVV9dWVz4q+SUEGpM6IyKCM=;
	b=wxpYa9L16PYztk7C+KBdLnVZPmQuCi/EzAnvPiytD1A2ShanQa+NuY3ptSFenWijIBTNDHI+crRruEWrJD1tLohTNxPat+BSGaHKx0GMpOneYPxFjs35OE9I2jnPmq7z1hU9RbJOxTJnEmq3fDoCviy5b+4qO6MLu4pou/Ic7to=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XDWAIMZ_1793006149;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDWAIMZ_1793006149 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 17:15:53 +0800
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
	sashiko-reviews@lists.linux.dev,
	shuah@kernel.org
Subject: Re: [PATCH 2/4] riscv: Add support for kexec handover (KHO)
Date: Mon, 26 Oct 2026 17:15:47 +0800
Message-ID: <20261026091550.9348-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-183678@kernel.org>
References: <20261023111612.2134-1-cp0613@linux.alibaba.com> <20261023111612.2134-3-cp0613@linux.alibaba.com> <sashiko-outbox-183678@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F3EE160008
X-Stat-Signature: uhba6hc7jwzbqodwcn91urux9j1wn94p
X-Rspam-User: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793006156-137600
X-HE-Meta: U2FsdGVkX1/bR430TopZbtJUqQj5Gb2arEzwgUZf90eD1zCh68y+etKD1EUOqstBk7vLxqWSeUSG6tY7zo+sFqmrKMsowayJUISH8zO9j/Nt3+7nCANTblpJmmR9qInXR1MWxaMJ1sqoHjZp+JRXEY5m4txrWbnk6SCZb2EXqTE7uJAEw31KUuCsU6n9eCPJ1KjIEC64zoy8UcbB/PBHdGENcQAUCP71gbDL/0k0nHs/o9maq8YnBWGPdRwYEoAAOJip6zy84/kB0lqhy+4K9KvVYSGMcKARUdCzFyuEu5wRhxDfOPOUguTtCKpAOubol2+nD7LJxKkN3P1/ZGNPWZt6PdO3gSi2FHkRR9+iWiEBRq2Aa2NacDrkAN4hDTSIr5g/IJ3sGEZxDE2pYXg//tRk2CF3U1TH2i79lUJ4cwJEyrep8t5kQtr/W/A3LmaQeN6vinieUvdZQjLM5+FMA78m5AXXbd/9tCF696h60AO9ErURiNIykLHbb73gtwECdNmxOuTZdqyl/Wovw5Opb+Ru0zNH3JKFs61ZE1QI11MWJipKIsMqp1xfLEYtuUbR7nLtTTJ87Uuz6tfJqCjjltuesx564GP2/jcYRrrxyI5/d/y77Rr08O3jWzjkRKhq3b6Pe/fc7ywkJUkgbRhA7ike3ZnY5KtfTI1Y+V/0zr4YcqTLlzIF2epK98y3iFCZPlfdsYxUHd4NZ9qwc7zBIJicRroPdhMogGAiME/5boJNvTiaqf/BKeFnvRDfWo4MhHEGpw1O+74iuSDMNJ8K8UT6L7Z02GF/8MUSxIj9i6XV29p/u34IBmDUWX5pgPihsay8ECVrMDEtlSY52l/FqlMW0mx8Ue4tvOzLl9HTgcCTYdOidSFEq6agghBdGsDCM8tIPrQhSYFfTcMd+F4aUNJAZeiFHiK/OhAcpgMk7CJjy/x5HmK5vnXmNnNDPGullcyK0mM0d5Ie0BNiL7V
 5nvT4Blx
 p2b+xOucOOFEYaumKoC1Iqc1y8hHv80INxpeNl0N8ZlGad5HrI2zMQeZ192bIJuyVpys1dcVqyuUn7ylytkq3Qp+S+G2E9e8zuXHC0mqXVD5QwHHHxOVnd0wd2gPLvGVtYQTJMwZg3rDYW/uqdMaUy20rjF0EA+9Mk+IjU7AhPaOOFkBPwVXylj27E3ZEXBsZBVTLcoeb09VFduUwi2xA5MkmM8uF273NITM4buyWTn3W5eb6rXJiXZ+FQ/I1p54rIGQTRnQ28YAmHBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: High]
> Can enabling ARCH_SUPPORTS_KEXEC_HANDOVER trigger a BUG_ON() in
> linear_mapping_pa_to_va() during efi_init() when booting a KHO kexec
> kernel on a 64-bit RISC-V UEFI system?

Confirmed. Reproduced on qemu virt booting through edk2 with
DEBUG_VIRTUAL enabled and "kho=on" on the outgoing kernel: the first
handover dies in the incoming one during EFI setup, before the console
registers, so it stays silent without an earlycon.

This will be fixed in v2.

> [Severity: Medium]
> Also, will kho_reserve_bootmem() fail on 64-bit RISC-V platforms
> where DRAM starts at or above 4 GiB, or record a 0-byte region when
> all DRAM lies below 4 GiB?

Confirmed, both halves. That is generic KHO code, not the riscv
enablement, so I will send a separate patch for it.

Best regards,
Chen

