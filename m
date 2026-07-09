Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A501BC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EB9A6B0088; Thu,  9 Jul 2026 02:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B8E6B008A; Thu,  9 Jul 2026 02:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A1E6B008C; Thu,  9 Jul 2026 02:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4716B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:30:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7B72A03E6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:30:24 +0000 (UTC)
X-FDA: 84968263968.21.1E7222A
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf05.hostedemail.com (Postfix) with ESMTP id D3C2A100013
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:30:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ezKkmXBT;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783578622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPEUhf19vuUBFdiEFO1XIuZL6JrCsEiMauadhYQeXkI=;
	b=0aAAEw5K3wadqp6lv16WPTOgtccvFDJCCZuXyF/byUwcz+k11QOFW7uZKvLL3Av6T1wEPg
	rsb2VMjgm1RwkACEAGqX660NYGhiODgiNqr09xpBaadYnGzZya2DlZBxAGsbD+54z60b3N
	JqIF3hImAa5C2FLwFnMXdqSe/9sw80w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ezKkmXBT;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783578622;
	b=Un3w77DyfmfIk2P07MlqtciRg15JBaKo0mETdRM1MfMhGYGqxoBeD33T93ZQPYzLCUvm3L
	feo05GjwmPJsd6Npryp8IqVGtJWZUgn52jwFyfZMhARsM1zMuMYjk3S1nQ+mWnMnALrlEd
	LwJxHjSNHHqL8XHM9l4UznHtFusC46Y=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XPEUhf19vuUBFdiEFO1XIuZL6JrCsEiMauadhYQeXkI=;
	b=ezKkmXBTzR/qNWnLeDbF+5BJNIo8pxBj9ojrafj3ZsTNYsFYXSZEejUWq4j67MLSYDOtlML8b
	4d5j0Apq64AYWvH9mkFxelT89X6YltSvbtnX3ieBwv4tiM+7+5GgVA1Sav5ubsVZtqfEBcyCMa8
	2mgoep7V9O3WqitLx2zHOl8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gwlGl0dzBzpStn;
	Thu,  9 Jul 2026 14:21:35 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id CAD922012A;
	Thu,  9 Jul 2026 14:30:16 +0800 (CST)
Received: from [10.67.109.254] (10.67.109.254) by
 dggpemf500011.china.huawei.com (7.185.36.131) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Jul 2026 14:30:12 +0800
Message-ID: <3ac6d4be-7c57-44c2-80a0-408e2c6f8136@huawei.com>
Date: Thu, 9 Jul 2026 14:30:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 02/18] syscall_user_dispatch: Introduce a weak
 fallback for arch_syscall_is_vdso_sigreturn()
To: Mark Rutland <mark.rutland@arm.com>
CC: <oleg@redhat.com>, <richard.henderson@linaro.org>, <mattst88@gmail.com>,
	<linmag7@gmail.com>, <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <kees@kernel.org>, <guoren@kernel.org>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <geert@linux-m68k.org>,
	<tsbogend@alpha.franken.de>, <James.Bottomley@hansenpartnership.com>,
	<deller@gmx.de>, <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
	<npiggin@gmail.com>, <chleroy@kernel.org>, <pjw@kernel.org>,
	<palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <alex@ghiti.fr>,
	<hca@linux.ibm.com>, <gor@linux.ibm.com>, <agordeev@linux.ibm.com>,
	<borntraeger@linux.ibm.com>, <svens@linux.ibm.com>,
	<ysato@users.sourceforge.jp>, <dalias@libc.org>,
	<glaubitz@physik.fu-berlin.de>, <richard@nod.at>,
	<anton.ivanov@cambridgegreys.com>, <johannes@sipsolutions.net>,
	<luto@kernel.org>, <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <chris@zankel.net>,
	<jcmvbkbc@gmail.com>, <peterz@infradead.org>, <wad@chromium.org>,
	<thuth@redhat.com>, <ada.coupriediaz@arm.com>, <kevin.brodsky@arm.com>,
	<linusw@kernel.org>, <yeoreum.yun@arm.com>, <song@kernel.org>,
	<james.morse@arm.com>, <anshuman.khandual@arm.com>, <broonie@kernel.org>,
	<liqiang01@kylinos.cn>, <pengcan@kylinos.cn>, <ryan.roberts@arm.com>,
	<yangtiezhu@loongson.cn>, <sshegde@linux.ibm.com>, <mchauras@linux.ibm.com>,
	<austin.kim@lge.com>, <jchrist@linux.ibm.com>, <arnd@arndb.de>,
	<thomas.weissschuh@linutronix.de>, <sohil.mehta@intel.com>,
	<andrew.cooper3@citrix.com>, <jgross@suse.com>, <kas@kernel.org>,
	<x86@kernel.org>, <linux-alpha@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mm@kvack.org>, <linux-csky@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linux-m68k@lists.linux-m68k.org>,
	<linux-mips@vger.kernel.org>, <linux-parisc@vger.kernel.org>,
	<linuxppc-dev@lists.ozlabs.org>, <linux-riscv@lists.infradead.org>,
	<linux-s390@vger.kernel.org>, <linux-sh@vger.kernel.org>,
	<linux-um@lists.infradead.org>
References: <20260629130616.642022-1-ruanjinjie@huawei.com>
 <20260629130616.642022-3-ruanjinjie@huawei.com> <akegeU59jSK9t7FX@J2N7QTR9R3>
From: Jinjie Ruan <ruanjinjie@huawei.com>
In-Reply-To: <akegeU59jSK9t7FX@J2N7QTR9R3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.254]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Stat-Signature: kpipb38onjg74zgjndde14t87u9qtdyq
X-Rspamd-Queue-Id: D3C2A100013
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783578621-729605
X-HE-Meta: U2FsdGVkX18SPOiSp85/Hs9CDXjs0G9KfISRAOGXoRI8xZqW8tFeLvAwTCpVlcJ8S+pge0OD0zpkq9QFDO/aWP54Yt55xX+3ndHzG6hIWyX1q+bkuMnnJaCHwBsNLZIeypUi5qV1LjgL1mGEDFHXB9b/f+wk4B1HDXO5st08Ct5tYlF9cwMxeDs45Z2Cnoi6X5YowIOkSYHRzEEwn1PxhsS/kL0cLqPLhwszrvwXr9ApG+iBdouo1RZ8BBrCznNfiTEaaucWn4JNI3zbi0k+Py/SNObj83LtNYIivqLC8aikoIPDlAYs3uDq3SOPnSMc4CuXomZxED8evhqp1rRt0Z/aNpQe58IR+gjExxeY9ZJT0DFv25DFwYbpDC2FNnXj8GZg1ndmH5VoAwavIx3UzQQfH7ZNIvFYNZElxcp4EFrDQVmQVuSfwgQmEHDaPl02hFNSeN/SxK3h57XLUTNdxEtr+s3cHrIGV9TfAy8yLfQbpBmwsO6Q/uVoi+wsXS4adB3ox0khRxIEtvJmppnuQ+tnY7EQ0G5bGXU/tGejsPwWx9tW3fJW3v3zUt36sXVYYrls0sInUjdftRQhx/3NlySeA8lZkX5TKy+rRIdlU6B7zNuawt23bnZDafhdNAofooPrwv+gaQ0lAq7ywxUhSvM99Ls/sVsgyRydH3Y3Hp7dv4SZL2794IV2VJrr0YNRxAbSbZ7HDFohtdkXnyioovU7o8EAYgaZYIbTaoDrpI4l7sp1APajsHMAdMagPD2hbqiLB6yOGlbSxypiwqppcCPqe076mkm7DPBcHxp86Dvi0pPEohKrVhPnyDLqFmyUghRTA5R6ojXuSB7vnwRVdKwpgsEx0EcqRUsfCLUFdz72uMeT8qAtpG6QNws2CVb0AW9azgchRoRwtFTs4gRfax71qCOmLjAI/9Xm3jD5CbKHg6RSAyuwzEalvmf43yAXNDOiv9sicf8KB3STCxk
 fEKKCO1W
 qyIABOH5I/5SzEryiCr0MPqIya5D0vSlAcXUdIEnxu6UMsPf1l8YcmGONH3819KcqW3Rud9UfRuJ2Oni+OLuuygOnENQqdbf5Ps4qretEwXwpJ8kBlPPRe3i8/jIDYJTm+GPUQatQWVL9KeE9tDc2hfzkpSD7clg/t1u5YdIrbq/KuR4Nj+bC21jubrKO+JDeUrsRWs0AQyYqlV/G4uzDov5oKYbd+HxV5+TcHzK/ScBW44xsezPWO0KgvgeyVxhNN0zWKD3+QwLbaEgkjtB5Dv8Ppg925jDUZnNfNuAxjiUKxTLFHaQtUqE9gphHob62MxjlqmTVyjjZzbLzRAPz/vPi0IQzB0yhqa9nbdPynaY9izp+cnv5tWpfNUZo9iQUbDcrSsUf9mIsLCX3nSNzxuozg4JkOnQNopCy4fPVFc9iirbY3F96TzwE2Vg64VQoQsS2aSkmGr2UnK863/bOEByhd1RoOjQwJomQx1cS2XVSYTqB09ZM2OrdLsi3+EI+hCA6Zics9fSIG5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/3/2026 7:43 PM, Mark Rutland wrote:
> On Mon, Jun 29, 2026 at 09:06:00PM +0800, Jinjie Ruan wrote:
>> Currently, multiple architectures (LoongArch, RISC-V, S390, Powerpc)
>> provide identical stubs for arch_syscall_is_vdso_sigreturn() that simply
>> return false. This results in redundant boilerplate code across the tree.
>>
>> Introduce a default __weak implementation of
>> arch_syscall_is_vdso_sigreturn() directly in syscall_user_dispatch.c that
>> returns false. This allows architectures that do not utilize a vDSO
>> sigreturn to entirely drop their redundant inline definitions.
>>
>> Architectures requiring a specialized check (such as x86) will continue to
>> override this fallback with their strong symbol definitions.
>>
>> Clean up the redundant implementations in loongarch, riscv, s390
>> and powerpc.
> 
>> +bool __weak arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
>> +{
>> +	return false;
>> +}
> 
> If we need this, please make it:
> 
> #ifndef arch_syscall_is_vdso_sigreturn
> static inline bool arch_syscall_is_vdso_sigreturn(struct pt_regs *regs)
> {
> 	return false;
> }
> #endif
> 
> ... and require that architectures which need this provide a CPP
> definition.
> 
> The use of __weak is generally problematic, as it prevents the compiler
> form being able to elide code, and gets in the way of symbol resolution.
> It's perfectly fine to require that architectures need to provide a CPP
> definition alongside their own implementation of this function.
> 
> That said, as per my comment on v15, I'd prefer that for now we DO NOT
> enable syscall user dispatch on arm64, and we first make it possible for
> architecture to express whether or not they support that, even if they
> use GENERIC_ENTRY. That might mean this patch isn't necessary right now.

That sounds good. First, focus on switching to generic entry, without
having to implement syscall user dispatch immediately.

> 
> [1] https://lore.kernel.org/linux-arm-kernel/akZgV0Y4YAmB43_g@J2N7QTR9R3.cambridge.arm.com/
> 
> Mark.
> 


