Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E46C5C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC556B00B2; Tue, 25 Aug 2026 10:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6DCF6B00B4; Tue, 25 Aug 2026 10:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83AE6B00B5; Tue, 25 Aug 2026 10:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACBBF6B00B2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:58:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C1651C1A59
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:58:43 +0000 (UTC)
X-FDA: 85140098526.05.93B183D
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf17.hostedemail.com (Postfix) with ESMTP id 219E340008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:58:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F4kThCqO;
	spf=pass (imf17.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787669921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f/bO7oRLixHf3hrejlfMlGfhBMkAcUtSYSC0qo8lb9E=;
	b=jTv5dt0CyIo5GW8WHNIVrG8ivQMzCQI7j6z6djPFgiRs8WaBITTQHJtej4ByPEfXtcCO+4
	nzPj0hrHqgZnUQIWFgXt83ktVb9MZdUze4WdLax/v/aEQGgt1iLHhYW+2Yrb8tX8fOHHHc
	ZDaM8SYTMdkr7QmlzGEK/yH1k394UVA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787669921;
	b=bCMumR7HfS4hQ0Fx8sH1fnZwo2+skOSQbf8w6Dw8P5zvnti3Kb9sLIsD+agUD3B2jXjCGz
	/wTp4Z4Q9sDDq2pda2FMdxNv5QeCfD38I9mxkmoOqcPhsdhFUCnIcWoGdR3evs3cByl0iX
	WIqp5/wnuNJCV57Bi54GnOhBJKvYlcs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=F4kThCqO;
	spf=pass (imf17.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KnZDcMWRn7Zu+bLe9Q7f+sdXJDlECr099EG30SIifxc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787669919; v=1; x=1788274719;
 b=F4kThCqOBaNlN/UYZuYK0Se+MWi+0EkemxC+9Yomr66iwmnsmUzAClw2RzORsPWPqAlaXbWU
 AT5qe6O34aMkIDXsezO//O0cSnODIxYPLi2d0JQpO6pMcWhC/TAgXoiisyFTf7Ditz/o55JgQ9U
 3B/Il/ZBfs/eO5cV/2BMcKz4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by smtp.migadu.com with ESMTPS id e23b80d205abac2c;
	Tue, 25 Aug 2026 14:58:39 +0000
X-Mizu-Trace-ID: e23b80d205abac2c
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
Date: Tue, 25 Aug 2026 22:58:33 +0800
Message-ID: <20260825145834.14244-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
References: <CAAhV-H7XKFj93fSPcKAR9AR6Z4O28pC9va243hVccvPNOxH3qg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pgfeeoi9gsp6uyeacaugwmebgr1h6917
X-Rspamd-Queue-Id: 219E340008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787669920-817016
X-HE-Meta: U2FsdGVkX198XagtZHRKbCrIsWJJIMg1+jK5+1f+rtpqiSuBs7iXOswprKuCnOPbwc+Juo7b5uGeq5/xH7NTogwNr/dbgm27uixeu6vBCUx/YI1cKCzyN6L2m3CjVV4KmiTUtQBuFHRLL/W9G77ZRU4vG9Ha01H8DpTTjHgo5G5U7eca+Se79xUE7wkcYjFwKJqz95n60SES1bgd+UoV3xkWeLUnClWbXiUIezib3/2p2btNbGaO7HrviVto9HyzrQPEz9zRe/2V5lRfsEcUqTmjMX/vRtqxscdvLPEesF3JrFQxvQb04hNWX7BL5+tyb3HWGBQZEJBfcvPBptwgOIuwksbb6r2p2DWxhjvQ9p8vlzj0Q7azsOiBFmt2WK60CQ/YBg1njdKqg1A2J4kQ5SjV0kI5FV/Ha81i+z3gUycX01N2qrxKkrvxBcsM4kl63lejeUPQWQnlTbA4Gl3nkVdNO9VGZQesoazyXEpUWt7agp39EtDYi+XjNL8OrfIrDCQXXYL9aKpIUnlkv53dBcSisKdppDgulNe5LdYO9CRsWbROpcK+cKPAGco68ZCbnpMpwznmYHmY+ZRSPJ+Y5mz3IA4QUYso/I8tkbGaL3KUEXluv6lAffEGXVCF9lPh2hHn8QWzaXkHq4a0Uq9g2Y0DzmaDseZa5BVn25FN6N4nmIwTfp2HYFQE5kZW9W7l3vkLTYDU1AxZRg2qOHGpwQgh8BtWc1oKaKTVBF3YXeemPbx5EiwsPpYCtApEEa7zRy0ndYZ8csL5Y/ce9Y1ve3uhLbsta9o+xuPNP2kQy4yZP5WBJBG8LyAnQTz6QA/ZEjDTgBDLXmq6HtevGXfbOcx5mM3JDpRZuszE02baUGEY5n+0NF3mp3XuPZVnpoU5LKIkhKQjOBLtdhRTJgAYZGgkpW6CitChYJdp5C4mpaMXSgD3Zy4M0v61zfg/8EbWqoPmUwllHQ8gJl5vsLd
 o1aVmV9/
 xqLar/bNYiyu1fYmGoVS8AX8t11lPa4GJ/cvf6NkmZh9W/e3BGkF0F9I7xX3mU5xaHFnQQebOCUJa8vBtluo1S9hjcJyuQ8xAYm0Tst8LxOni4AuVWj9WRPMdHXVGENh1rZwZANfK5d8G56ii7HYOFJ2k46JUb96nbimxwR5+vW16XyIbgjgKUsaI9KTLUhMkGIMc3kikEp8LG4j6WjPdAbUU9xURMEqEzArVRlb7a8fQt+iC5t18vIGNCSSdVM1WOSurNLz4LvQ/d6UN/OTbLZ++vA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai,

> You nearly answered nothing.
>
> Does your employer use different kernels for host and guest in KylinOS?

No. Host and guests run the same distro kernel in KylinOS, and guests
boot with edk2 firmware, so ACPI is delivered and i8042 bails out
through the PNP path. That is the normal case and it never panics.

I have since finished the investigation, also for the firmware-less
case. The same QEMU command with two kernels gives two different
results, and the difference is the kernel configuration:

- A distro kernel (CONFIG_PCI_HOST_GENERIC=y) maps the PCI_IOBASE I/O
  window through DT PCIe host enumeration, so even without firmware the
  i8042 probe reads garbage and fails cleanly ("No controller found").
- The selftest's minimal kernel maps nothing there, so the same read
  takes a page fault in i8042_flush() and panics before userspace.

So the panic needs three conditions together: a firmware-less boot,
SERIO_I8042=y (the Kconfig default), and no registered PIO range --
which is only the selftest-style kernel. I agree the mainline fix is
not necessary. For the selftest I will enable
CONFIG_PCI_HOST_GENERIC=y in loongarch.conf instead of disabling i8042,
so the selftest kernel stays closer to a normal one; the standalone
patch will not be sent.

Thanks,
George

