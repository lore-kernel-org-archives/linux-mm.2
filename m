Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1F6C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 04:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33306B0095; Fri, 24 Jul 2026 00:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE53C6B0096; Fri, 24 Jul 2026 00:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD3686B0098; Fri, 24 Jul 2026 00:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9DAE26B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:59:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C558C0133
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:59:06 +0000 (UTC)
X-FDA: 85022465892.20.6584094
Received: from smtpout1.mo528.mail-out.ovh.net (smtpout1.mo528.mail-out.ovh.net [46.105.34.251])
	by imf15.hostedemail.com (Postfix) with ESMTP id CDA5DA0009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:59:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kaod.org header.s=ovhmo393970-selector1 header.b=Oi9DC1Sq;
	dmarc=pass (policy=none) header.from=kaod.org;
	spf=pass (imf15.hostedemail.com: domain of clg@kaod.org designates 46.105.34.251 as permitted sender) smtp.mailfrom=clg@kaod.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784869144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CufKqRzRWGP5C9wDDHrJPSM5oQL0vrGLL/dJi11OdLg=;
	b=XM5KYqkb0xBbmtp+J7rfVGrSG8yW1aYgGr3jHOiht/Kx77KdGHc6EN2xgerKffVbRS9FbO
	DmAPbX28UEF90AmhGM84i74jFHZFZnbetF6LOrIb9fKekdUooPtzDnZfuoPONOQUJxeFeC
	lcGqyJpbbsVcD9MF+dc/XAwpl1IRhcE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kaod.org header.s=ovhmo393970-selector1 header.b=Oi9DC1Sq;
	dmarc=pass (policy=none) header.from=kaod.org;
	spf=pass (imf15.hostedemail.com: domain of clg@kaod.org designates 46.105.34.251 as permitted sender) smtp.mailfrom=clg@kaod.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784869144;
	b=6uv1UssBscCdoFO8vKTg7+nKJwnXOUITxM2/RAi89hUqTslugoaCpmYbY4ikzVUE4dc9xq
	zfx7DRSajKxD1ca2G1GdDRa58ZNoKZtxH653iahCn3dzRIkAe88SaPqvLakGIjZcB2Zm5D
	S0TDfsDGycgT9GAQWQjqErq3sALj45Y=
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net [57.128.106.70])
	by mo528.mail-out.ovh.net (Postfix) with ESMTPS id 4h5wkW3LJQz65Y5;
	Fri, 24 Jul 2026 04:58:59 +0000 (UTC)
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net. [127.0.0.1])
        by director5.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <gouhaojake@163.com>; Fri, 24 Jul 2026 04:58:59 +0000 (UTC)
Received: from mta7.priv.ovhmail-u2.ea.mail.ovh.net (unknown [10.109.254.225])
	by director5.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4h5wkV75Bsz7t8k;
	Fri, 24 Jul 2026 04:58:58 +0000 (UTC)
Received: from kaod.org (unknown [10.1.6.2])
	(Authenticated sender: clg@kaod.org)
	by mta7.priv.ovhmail-u2.ea.mail.ovh.net (Postfix) with ESMTPSA id A7BCB203E0D;
	Fri, 24 Jul 2026 04:58:55 +0000 (UTC)
X-OVh-ClientIp:82.64.250.170
Message-ID: <988bb08e-3c6b-49ff-9e33-0263b9216a65@kaod.org>
Date: Fri, 24 Jul 2026 06:58:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] powerpc/xive: fix use-after-free of xive_ipis
To: Gou Hao <gouhao@uniontech.com>, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, chleroy@kernel.org, maarten.lankhorst@linux.intel.com,
 mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch,
 bharat@chelsio.com, jgg@ziepe.ca, leon@kernel.org,
 akpm@linux-foundation.org, namcao@linutronix.de, ynorov@nvidia.com,
 sshegde@linux.ibm.com, nilay@linux.ibm.com
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, gouhaojake@163.com, kernel@uniontech.com
References: <20260724022851.466017-1-gouhao@uniontech.com>
 <20260724022851.466017-4-gouhao@uniontech.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
Autocrypt: addr=clg@kaod.org; keydata=
 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
In-Reply-To: <20260724022851.466017-4-gouhao@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 17371228191519649000
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTGaLDmC1sGz9F5x4qvEOawfsm4Qoc4PI5XkON1B5NhPBXhuasc2fQjXH+VDsmM8u20AJO5uw9QqMPdxtLUwzW4JHiund27yNotetwU2aoTKlSByjpVbPXNhOAm6Sbrj0YxwiaiRSE6c9ur3YhDfD71mXV5UmnBjw55DxC2402dux2yrfi55r5CK/DrF2UJJtPJ286dwRRmaSI8PMt00k91NBWQVZLH0x/WvzQLiEKxFqHDIN+rylQfVV+7TlQk8VLKe6IPkp1wpOzMV2quZF6Z2kCTGNe4BGIGTxDslcGATaCAjurvDo0ZhXXEBlCGlV6DzbWEZMkizxW3KZwTMjfSZFbyKXqSekAL1vm6pEBopH+PbZpV31cz44toPdcY+W23WTq2U2Z2wWgGPyHgTbrR/SjTpmdKXRd3WA/OL1C3MxvCbRXaEc2zN/xMgjFDHTdX/FZLFtDVoXf5m7gzWokQlFyav3Gx8WNXx8JUPWH5a4rm2+dD4+YexO+u0xNT9DMrGjkVABvkpWiVQ0EREuN2imnjX8yREyvRhjttusUNeEFdCWn82sNpOatRzHBukjfhAoZ0DzsOseDDPycnEnVJUpfFexpqRW0I+K2A0QazKCQPVe0HDupddfFM8R0YlH/d6o6GujYiFMJZBncFaPO7+LdSOLohtnsFrXxlz0sL4TA
DKIM-Signature: a=rsa-sha256; bh=CufKqRzRWGP5C9wDDHrJPSM5oQL0vrGLL/dJi11OdLg=;
 c=relaxed/relaxed; d=kaod.org; h=From; s=ovhmo393970-selector1;
 t=1784869142; v=1;
 b=Oi9DC1SqdS+C169kqp7ZTc1rba+g6496Rbb8hgeNT6xdrYDQgtoU2Epb3yN+SadIbIyWphHo
 4/zyeJEaLnxlIVrcy2hJRVSHdtMSEjuRS/jee9HRb0LH90GlXQBVvwmpZfsm4YXeTaxLCMppjQt
 RDtSBO48JUD2v8/Af6T1Wz50Rw3/mE5JnwKDAg8rgubPuruBP+F+TvXbhPq0lAva4mbyAOPWPX4
 OIhzq2b8OkwIUynO8AThJKeWDgflQt4VvdHRCP/fsUDlKIXh7zrmvG8fULQEK1tc8XqIb3Kckzm
 KaItUQ9ikaeZFd0wYoD2ZSOd3I5OaCZGTj8lCb+U/jf+Q==
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CDA5DA0009
X-Rspam-User: 
X-Stat-Signature: qohitibr1hh1ib56y6sb18dc35tjes81
X-HE-Tag: 1784869143-330857
X-HE-Meta: U2FsdGVkX19A97KLtPxo1JttzL4yUKjPj58L4JvOvs45IJ8lrORECfD5HrY7stekVQ3BSto7CNAhjfB14vCOsyGeEGKD3aZX7VLoaKm6P5iqG363h8vLRrn+q9tXttFfPAPeuj5hLT45QK0oj7E23dF95baJ4aVsYAOBdesspYFfAYYgza9P70nTpf6O3ThTQputHe2/BTuROQ+dV8cm1wepRaz8DSLfIf574VwMvyc3Umew4v5gAAv1D+eF08BUgUgzcqadkpQaCzjC9KoBD98AHZVhljyKrtxSWDl5IEE4Vt6a74F/Y6JF1i5vKA2qMp0sNjfH1WjjY9+6Hmp+MjlzDfXSR2YpqARYInVbe6j1ELEebGApgorOho/1nCy7EOUwXKeOzJS2ow0k8fD72LJRdSGKYiEDwgOF7VW4jOb3MRUMR35mit1CuYdP71VtyzYRlvCl90YkS23RQaaCWbdkqBz5AhSBRqsWs1GVhnwjqwN4QOjV+sPJ5W+ZqRF7sWkdvkrjqmypTHUQBa6MQ6hb6iUEngNrSEUBMISI/KG25atk6EKwK7ToG9oKwog1LPwaqTwgEZeLWtOfdVOTi++J2o3pG59QNCx1ZEkWK7lJg1r/yztPmHjBXrBRqnfvCDVn1wy35zaVX9m4Y5xPWxwflCnwMkN4X9stf7ZWZc9xcd3bb5ZdIlcQ1Na1cGKnY3fVCdQ5eVqdVXfemya4E56Q9f7HltToLhE7+zp2fMiBTdBoUvksMtQA8A0YKshMw0InbhvwmZ/lJdL0zrvMXyRfrpBk1U5NofJrru4q/0Tm9P61xGP41VeFHdjyT7QMI7dOQUCEl4aELLfhyUOFxPs1mjTWWfz5XLGvbQgCdiXKA/ESpnqRnjICnyQx7VRm9MHoELG8UK+z90EoasRkb16eKnGaSYfJhETmCNVCjKRRZpT73z+1nPYnUMthZfNwTcGTcba+VQEeMUwTWgY
 Jo8KLOsY
 t4ud0Y5W84AkluCQ83kJQgdx6A+X7PiVjEKhIh+MhZ9Sdt7bWwfWwlRKld/xQDTzLr6v7+brK6ZcbLV3O1IryHzlZQyGa/0qUXxImLzXiWvXGfK2e0ixhziban4+6bLgyB1vvUYjr2FRMtYjAX39b9YBvcdMotqLwMtzIGPlsbFGs5yh6v1kqTbszWRERHCilG5S9t35Ekf6kgCgS8eCoNz7bVLfYaP/hDUuFQR9OrjKK5hQc1iWaT+eJufgNU2DAC9RjYzO7HNHAZhF+qcdoP85quQCTbhjJ6D79jQwOBXmdK8c6WwyHLFFsXlVvNE1w222LoeMp5OkFlNms2jBzstxKBuOKNacn8u2zSx2vESKCt9/fyRxrMZ09WiSqTtmyFj4Xc8K+to6HHbtwDTf85xb1wUl918ns6JC3nGLOufgAYJCMi+Kn8WCboXFoCnK6+P8X67Pj5dDm71DEffCnH5rqCjVRRJXHsusOm0U/wVH/TrGXjjC9P1gnWEAM2cmY1+EsO2ctN28wJzgNlQ2jLZPKARdCCfMZhorNWhQN+HbsFsHbgEBuh4IBGPYYJrKlUWkWp8gED+rL+VFivwAvwGCQ6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 04:28, Gou Hao wrote:
> When irq_domain_alloc_irqs() fails in xive_init_ipis(), the error
> path frees the global xive_ipis array via kfree().  However,
> xive_smp_probe() ignores the error return and proceeds to call
> xive_setup_cpu_ipi(), which dereferences the already-freed xive_ipis
> pointer, resulting in a use-after-free.
> 
> Propagate the error from xive_init_ipis() through xive_smp_probe()
> and check it in both pnv_smp_probe() and pSeries_smp_probe() so that
> IPI setup is aborted cleanly on failure.
> 
> Fixes: 7dcc37b3eff9 ("powerpc/xive: Map one IPI interrupt per node")
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
> ---
>   arch/powerpc/platforms/powernv/smp.c | 8 +++++---
>   arch/powerpc/platforms/pseries/smp.c | 8 +++++---
>   arch/powerpc/sysdev/xive/common.c    | 6 +++++-
>   3 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
> index 8f41ef364fc6f..b1201dbafcaf6 100644
> --- a/arch/powerpc/platforms/powernv/smp.c
> +++ b/arch/powerpc/platforms/powernv/smp.c
> @@ -332,10 +332,12 @@ static void pnv_cause_ipi(int cpu)
>   
>   static void __init pnv_smp_probe(void)
>   {
> -	if (xive_enabled())
> -		xive_smp_probe();
> -	else
> +	if (xive_enabled()) {
> +		if (xive_smp_probe() < 0)
> +			return;
> +	} else {
>   		xics_smp_probe();
> +	}
>   
>   	if (cpu_has_feature(CPU_FTR_DBELL)) {
>   		ic_cause_ipi = smp_ops->cause_ipi;
> diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
> index db99725e752bd..14cd0634eeca8 100644
> --- a/arch/powerpc/platforms/pseries/smp.c
> +++ b/arch/powerpc/platforms/pseries/smp.c
> @@ -194,10 +194,12 @@ static int pseries_cause_nmi_ipi(int cpu)
>   
>   static __init void pSeries_smp_probe(void)
>   {
> -	if (xive_enabled())
> -		xive_smp_probe();
> -	else
> +	if (xive_enabled()) {
> +		if (xive_smp_probe() < 0)
> +			return;
> +	} else {
>   		xics_smp_probe();
> +	}
>   
>   	/* No doorbell facility, must use the interrupt controller for IPIs */
>   	if (!cpu_has_feature(CPU_FTR_DBELL))
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index f9a1229cede73..bb6ce07c1699e 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1256,10 +1256,14 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
>   
>   int __init xive_smp_probe(void)
>   {
> +	int ret;
> +
>   	smp_ops->cause_ipi = xive_cause_ipi;
>   
>   	/* Register the IPI */
> -	xive_init_ipis();
> +	ret = xive_init_ipis();
> +	if (ret < 0)
> +		return ret;
>   
>   	/* Allocate and setup IPI for the boot CPU */
>   	xive_setup_cpu_ipi(smp_processor_id());

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.


