Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA14C531FF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 04:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665C66B0092; Fri, 24 Jul 2026 00:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DED6B0095; Fri, 24 Jul 2026 00:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 507946B0096; Fri, 24 Jul 2026 00:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1ABFF6B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:55:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90301A0297
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:55:55 +0000 (UTC)
X-FDA: 85022457870.19.6A9009F
Received: from smtpout1.mo537.mail-out.ovh.net (smtpout1.mo537.mail-out.ovh.net [51.210.91.20])
	by imf14.hostedemail.com (Postfix) with ESMTP id 02252100005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:55:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kaod.org header.s=ovhmo393970-selector1 header.b=fptsVdey;
	spf=pass (imf14.hostedemail.com: domain of clg@kaod.org designates 51.210.91.20 as permitted sender) smtp.mailfrom=clg@kaod.org;
	dmarc=pass (policy=none) header.from=kaod.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784868953;
	b=Cv9Bd90gpIpwwSp/eq7uaqm2k7K50HNpx1a+siyoM41m+b6Udu5OBQSFvFa4uW8NriLiQQ
	7mfmsdxHng8rapX09gxgFHjHHvSiFnvyzQoQwfpGByPhv/mmy8qCp8Vua30LfP9LHoEwkz
	9HY/pd3FO1fnnAT5nrgNWfKWDtux5z0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kaod.org header.s=ovhmo393970-selector1 header.b=fptsVdey;
	spf=pass (imf14.hostedemail.com: domain of clg@kaod.org designates 51.210.91.20 as permitted sender) smtp.mailfrom=clg@kaod.org;
	dmarc=pass (policy=none) header.from=kaod.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784868953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lpsNKuaDzpZhNqp4w16ugJf4ExexmLy2gskQEsg/tcU=;
	b=G+xESzap0k/+/8R2bOmGAADxmeYg+GrqSbTYCK08fpmyKHP/PnXSA3Mu9Gnf892qKsbAHn
	UaxI2LYTFiG+WChr/Fs/I3z0GSTn5Uv2aKVHrm0QBZS2kvNqqOBlu7+5eb/Neh7iQm3M3V
	yP564NTyCEyMz4jw6IrIBSqdUGJJeqY=
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net [57.128.106.70])
	by mo537.mail-out.ovh.net (Postfix) with ESMTPS id 4h5wfr2v2qz3yvC;
	Fri, 24 Jul 2026 04:55:48 +0000 (UTC)
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net. [127.0.0.1])
        by director5.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <gouhaojake@163.com>; Fri, 24 Jul 2026 04:55:48 +0000 (UTC)
Received: from mta11.priv.ovhmail-u2.ea.mail.ovh.net (unknown [10.110.0.198])
	by director5.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4h5wfq6fzlz7t8k;
	Fri, 24 Jul 2026 04:55:47 +0000 (UTC)
Received: from kaod.org (unknown [10.1.6.4])
	(Authenticated sender: clg@kaod.org)
	by mta11.priv.ovhmail-u2.ea.mail.ovh.net (Postfix) with ESMTPSA id 809112403E2D;
	Fri, 24 Jul 2026 04:55:44 +0000 (UTC)
X-OVh-ClientIp:82.64.250.170
Message-ID: <82bebd8a-0376-4fd6-8e8b-125bd895208e@kaod.org>
Date: Fri, 24 Jul 2026 06:55:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] powerpc/xive: add error return value to
 xive_smp_probe()
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
 <20260724022851.466017-3-gouhao@uniontech.com>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>
Autocrypt: addr=clg@kaod.org; keydata=
 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
In-Reply-To: <20260724022851.466017-3-gouhao@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 17317466469420608744
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTFag79TUuknUcEyJ+fUBsqHM0xcaveY2xgVNjxV+qnKwhwsNTHa/2zdKcagVjzZotwGF8tiTuYDFnLfCREPZ40TItmps8VQlgCYXtQ5s/8YhU27P1l3fNA5vFk0wHWnMhXlAGEERA1YXEkq6NvX3J7mbulyb4PCNyOiCS02W8K6KQos/fdl/UFRJLB+bcrtLX5zpkrqLCS8UVIBGkLg2pXo1dt253286tHqmpjN4aJU4Momxnq4NCIh4qjGOU8oLxiXXbSRp93kS9K9HRz8GsPUGJVR2g6ypPWuPrcsxVVwSadqKe62E2LhGeYWeQK5G59ftKSi6eFNdIHZZqSwCU/JaoOMXGmkxCnRclM/OCuhglaDeN3BHUfDx3r50MC2T73P2UNZ4JGhwl2sLnvSRV5LGbJuTiqZGgGzrzVM58GD4zLNB/RZeH1wc/0zRk//2Xue9NMmuW3qm/WtzV0vO0tyeZ6VmTIaU8OL/f9xBiPfV0fE/kMqrHEve6qNThviQfG/EHH3yRZxfJigHWxirAmm9MAf+s4tK0hD0PvourVEzAQseAzpPKZt+8rZhPPA6izowE5nGl+xljFZggcijL58lcU0Yms0/rAA2LHfWPtHKlO6eeyK0wVywjt04umh2B8l/lldWqZzfzJYrhkT2FaXaL+nW6q+n2cziaIMo66PEg
DKIM-Signature: a=rsa-sha256; bh=lpsNKuaDzpZhNqp4w16ugJf4ExexmLy2gskQEsg/tcU=;
 c=relaxed/relaxed; d=kaod.org; h=From; s=ovhmo393970-selector1;
 t=1784868951; v=1;
 b=fptsVdeywA8AchGltVZrfsyqfHnxUSVi6auYkCr/g+DeI4HXpU8HYp+DbN7oTXhYVS2ihiKM
 4b69/7eP+iHECpIXC2LTivylvJ98jAv0CMv3u85/H74PB67ZB4u19dNmFN3fhoLr2igRhuRorVL
 5Eh+uV+CGcQJ2/NOqO2nTQb9bZPtg8O0vEXVncHpTp+XokQWucfrtmkurvAXbAv8RHiaMCg1jFc
 6G3Tomtqc5CGsr8TvF/Fq5RYYeCLQAyy7kMYRDt1Z32/CHdfoZuS8+YrrvNvhICbwMvmJ3tzjU8
 avuwNOU2N25aPFejN/Y4ZZC0k/R8/U/JNu484CDDGZbmQ==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 02252100005
X-Stat-Signature: 36i43n1m9ue5j3ox8yr5nh6mju3u9zuq
X-Rspam-User: 
X-HE-Tag: 1784868952-601156
X-HE-Meta: U2FsdGVkX1+xg1mqrs1gN0JUW9sVN/Oreuz1RwnJHY3e6PYZjwi8VQAiHxZpaN/1n9OUZfSkv/ZJGqBWItKqxUB+tAW3T6GU4NWN6g7zFJGcRGz7oQW9vij2vBJ12V7qOP7wZzY3i2LT2rWBg7cnecfyfdUhrT4B2uQzsMyCD3i3SVaZTm3v9GmH+R7sbkJcEadT/ijeU6avkJ1R2HgFkYW7y1TwbJZ6wjzbWhMv1eRIji1kHNGYxsosFiSrR/sIcJFv50hXHbHAW4VrM6avAEewd5oFj+rnu8O7dpk9pEePltZLJDMIAGF+vGkFXzlu6DkfS17ZkXYVhZHLfK0hdAaB079gOBqRggnJQjY1z2b4YbusmqIIOeYNRVTyXbB+fw26yGs4A+jgoKgUtXXp5p60n6mkZ+4sMLSO8zxCehO+tSyvdNRRbKU2kPhgdifVRJmplfTJmRTZGb3OG5gsRdoxMdLairxOOVOG/ZCPiJGzeU6sdPp8Y20BszuOkNPThWu1clWRUeuqMOGNE4EVxWBUPkdOnRKfeCC4mjSZfcWsLc2rM9fsgcwb8We9KNKefWFNi8zhwr9SF3xFBx7o6bzq14VbZ0dj9pfeG/AHVmcbkI14XUkWpvY3NdNeQEyvhoS4alPD/IjG7TNm6PCd8NN8HZXEdhdxh/hAt1kImk1HCf2RF38ztL+xPzTpGtreyxq14GVLPG5q2qnP3BY4R5p8QXXPep9MCXJUxZ9vCsMG6PjnUkDh0dipaL0E9keBRR+8NAtyK6SgpTt3McP0M53IbmNWNUInK9o6gN+wHXYu2S/CRyWrFegy25gRWkZ6EjAnX6Sb97zRzQUC45H0cepgEr5FayKQ8nZqSzZmczhBju5LtOVAyBFCg3dul4KBck03QqxyQHwoerdom3ZNZ0hh2UarpJ8WhNfon69T2G4f2ho5c0yiJLVpUhzPUq6hQwISo4IJ1iRV0tAuosb
 GJHH9lzg
 vSBrLf/jD44rsP6F9lihqwEczL4qMGTwGK3z6nDZKc+48qPfLZFUF1HcaD5cIx0gGc85Mw+ekl2A0jNUOxT4KklqYo7E/iy6+w0SfpkftCMndOPnkfejjUO2lJSMnwEg18AdZRn5WxVcWCHFyp1DVEADclpt3tXqIZlToPuiyqj28n5GrldTNBD9gOi/YmZRuYiqEpJfOYWPiYruBXvY5jB+VqhynPjs4F0tkC4aPQryqgItv+r3zg6F5HvDqsKvEQk9V1KtQDbOEUN/m8AmI31T2YibtfgfoyFiiYPB+3AOKK48Ln9G1dVFQYGRhSnDXRzhH5xhamQpRAp4hcfTUSQOExbB95lur7WonWUcpsSWv17yPHAP9HCgfStb0lLbQTGihifF5zbL2kCq9YAX4tnYxag+55wWU0cliP1IIZ7UJKZ1VYzvuzHSzGnPMAwmmPeqP882NLdLHD1sOr8RMpTGizyFuN80lGCCKkQ6242/6g3cn7cujM7iU+apKZX2pMz89syKkTOhjsZbsFIJswtKB5ZLzGWDB9xvrN7SReGDFiGeJQW3eL8iZuLYmsvsZDj4l1w453y6JUGWrOsIDNl0toQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/24/26 04:28, Gou Hao wrote:
> xive_smp_probe() calls xive_init_ipis() which can fail, but its
> return value is currently ignored.  Change xive_smp_probe() to
> return int so that errors can be propagated to callers.
> 
> This is a preparatory patch for the next one.
> 
> No functional change yet; the return value is always 0 at this point.
> 
> Signed-off-by: Gou Hao <gouhao@uniontech.com>
> Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
> Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
> ---
>   arch/powerpc/include/asm/xive.h   | 4 ++--
>   arch/powerpc/sysdev/xive/common.c | 4 +++-
>   2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/xive.h b/arch/powerpc/include/asm/xive.h
> index efb0f5effcc69..4e3e3358993c0 100644
> --- a/arch/powerpc/include/asm/xive.h
> +++ b/arch/powerpc/include/asm/xive.h
> @@ -91,7 +91,7 @@ static inline bool xive_enabled(void) { return __xive_enabled; }
>   
>   bool xive_spapr_init(void);
>   bool xive_native_init(void);
> -void xive_smp_probe(void);
> +int xive_smp_probe(void);
>   int  xive_smp_prepare_cpu(unsigned int cpu);
>   void xive_smp_setup_cpu(void);
>   void xive_smp_disable_cpu(void);
> @@ -153,7 +153,7 @@ static inline bool xive_enabled(void) { return false; }
>   
>   static inline bool xive_spapr_init(void) { return false; }
>   static inline bool xive_native_init(void) { return false; }
> -static inline void xive_smp_probe(void) { }
> +static inline int xive_smp_probe(void) { return -EINVAL; }
>   static inline int  xive_smp_prepare_cpu(unsigned int cpu) { return -EINVAL; }
>   static inline void xive_smp_setup_cpu(void) { }
>   static inline void xive_smp_disable_cpu(void) { }
> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
> index f2904a5c2b7bf..f9a1229cede73 100644
> --- a/arch/powerpc/sysdev/xive/common.c
> +++ b/arch/powerpc/sysdev/xive/common.c
> @@ -1254,7 +1254,7 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
>   	xive_ops->put_ipi(cpu, xc);
>   }
>   
> -void __init xive_smp_probe(void)
> +int __init xive_smp_probe(void)
>   {
>   	smp_ops->cause_ipi = xive_cause_ipi;
>   
> @@ -1263,6 +1263,8 @@ void __init xive_smp_probe(void)
>   
>   	/* Allocate and setup IPI for the boot CPU */
>   	xive_setup_cpu_ipi(smp_processor_id());
> +
> +	return 0;
>   }
>   
>   #endif /* CONFIG_SMP */

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.


