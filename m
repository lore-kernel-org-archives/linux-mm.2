Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A55CCCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:41:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA838E00AE; Wed, 29 Oct 2025 12:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AB5D8E0042; Wed, 29 Oct 2025 12:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C17C8E00AE; Wed, 29 Oct 2025 12:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7C28E0042
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:41:52 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C166C08D1
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:41:52 +0000 (UTC)
X-FDA: 84051718464.10.9858D8C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8EA141A0018
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:41:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dKse65N4;
	spf=pass (imf19.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761756109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0GllQ+s4BepM53erysRngLqxSW7H1UQovnCn/jD3ms=;
	b=IHJiveKAZaJsuqvsmNU7hFUbNqdmv5vNFcpNhc1dBTUYNu47VQv1vejn2hc7I+iEL0TsZ4
	FUi/S94hSwDRBqZLzCytI2NvdKmdxqkRKbbv3hjBcKoRoRqHGkDaAlWPNfqCm3lngh+RYq
	ugxXa+/9XzpDqlTmldTXTl8OaW151YI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=dKse65N4;
	spf=pass (imf19.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761756109; a=rsa-sha256;
	cv=none;
	b=A7woATGrl0XENO2GtIpQkjte3nWtt41/5eJEtWfV4YtLZ/x8s3/df9qJsPVXQzz06tO19O
	WZK3L7tBSCBAP1139VLBEyVEVEmt0YXQo3ZOTy7tqlEW2OUwSJRMB8tnCJhYZcYm12Zw0e
	qBsbzTjr4QqzXkSSbk7A8IrdUMlsEV8=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TBiUmF019857;
	Wed, 29 Oct 2025 16:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=O0GllQ+s4BepM53erysRngLqxSW7H1
	UQovnCn/jD3ms=; b=dKse65N4TsbKhRm14Ls1x0hI3RnfKhBH1czot/BQLnftQ3
	VSB7DZeS4jZB8eDykb6LAFo6VP4DPicUoS7xTm2aDbxvYElOMnLDwgTMbL6hRGL3
	TYS5saRlJhejUglioVhTYllR68SkjXm950RJTiB1qR4EMnRLFxf1sZqcvRQZvodO
	Yek9y3+dRvDajApzMXQySHxq9Yen+4lyhPV6/jqwLG52OoPGZzC1m3FxT2WVuVTr
	VFxcExJgzOYhyJmGvwy6S/9Zn5AT7Ur2Bs5o9mFVN5/OIf5QxF96TusPuvcJ/N5y
	26/Ut3TVD0wO2slyQX1cTgeUu10rBK1KrNFyU3Ng==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34agmapu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 16:41:20 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59TGfJkJ017114;
	Wed, 29 Oct 2025 16:41:19 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a34agmapp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 16:41:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59TDufOl027440;
	Wed, 29 Oct 2025 16:41:18 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a33w2mcn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 Oct 2025 16:41:18 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59TGfGon50594056
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 16:41:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7782620049;
	Wed, 29 Oct 2025 16:41:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5CF4F20040;
	Wed, 29 Oct 2025 16:41:14 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.14.225])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 Oct 2025 16:41:14 +0000 (GMT)
Date: Wed, 29 Oct 2025 17:41:12 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Woodhouse <dwmw2@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
Message-ID: <ef0cd4bc-1a37-4755-8957-d8a7e5c4564e-agordeev@linux.ibm.com>
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029100909.3381140-8-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=K+gv3iWI c=1 sm=1 tr=0 ts=690243b0 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=A7EgIBmc_bNo8zDYgroA:9 a=CjuIK1q_8ugA:10 a=zZCYzV9kfG8A:10
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-ORIG-GUID: 4s5OgOW5GqS8eVWCgDfypaa1QGghCrCr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI4MDE2NiBTYWx0ZWRfXxhPJM2SCp9M3
 JIxHzUs/CGPXr2j/HKIQSyzP/NPWYyBAsUaz21z4d+ni6Yh52/bKe6ciGNuCC/yvPIu873sf8eD
 gUHIw+TkZjXiw5u5gLht6WE4fmO7hFP9NwF2MCouQJJ1JbmQRPIZ83a9wuBP/AITVNjmJ0xGGmG
 qezpKkQxzyKV9sl1nHhwJfM6t+wdGPLGm2dgusnKzSs3rGhIdUuwvWs6rihxfKcmPaUdbPSNC2O
 eRn1rutFYoUesHzwc84/+sqyzl9CY76RRz3bxV43lF1ZZZBVTvKGz/ggCG3uOGlSWeIVhUkfR5+
 V0NM8GYqpxuXlg/ptkK3CqTUml5yz9fsasWNSY3QfT7gjFUhGJ7eXLt9sN5PD8nzr1T3dYuMu78
 3y4Xh9Rxn4COiXYCY3Cfr/IFgKK3Dg==
X-Proofpoint-GUID: mFGA4Vr_KjknbicSy-pCCIOL2RNOgklo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 adultscore=0 clxscore=1011 malwarescore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2510280166
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8EA141A0018
X-Stat-Signature: cyu1fqkeyoze9xatkdghifgsgs1oiioe
X-Rspam-User: 
X-HE-Tag: 1761756109-25808
X-HE-Meta: U2FsdGVkX19sYzwDCxkR0Zec0TUt64SRbdOi33s+n+t/OcjD1INABNGKgsBsiupIxStIsKpE9vckw6OmnGI7mNBA2hx43wScZE2CUk48F3Lea41HksSrqk+81HSDIh4q2d4R2wvWIWI/Gd9hqwlL0kSDb3VrY8sXy6wPGJmck/AZJsSdYYvFjP8+ZyDoFVPadK2/B9Q1YUd91PR3OTPTaGg/XZF5WP9YpAE4MFjB5ZTColm9P1aqZhaXG5D1Fh+20FXJX3xLR3mn4yamMYVPMkrumpMbXq5jFl8sK+q+VrmYoZ/OAESvmfkA/b9gXKA1CObqYB479l5vIIAn3EWqvlaL4J7EQWE5YR/CNqH7Ne7GO79fBNnV8cqz4MKJr+pakLnYIIbTRfqPSGPxTMgR0u+nHojhi3o2Ah874Ig8wsPvJNt28ziw0hmsOn4+CZ05p1rabPuLPrPKCPEqkDegcVPcRFFW4ynCvUHz/avvMGz7o5WzqyzA4sYoCyNic+6GCm+2nsUo8/SWLCakb3NuWxwUanechB1cGlAqfwtLuGyDVWDCJwxcfrC9CJ7n9/HF4DoRunNz6fLxz7DQ1O4RtspdmOHb5UIURvmsiZXegR6SgqLvinh/QlHx15YQ4YFgv/hAxUOFlLgi8HMFh+11JeN4DO24XGQMaaK8BMHe+wSrjb8Tm10OConAysakWcu/hgMsLPTaBvHr+P313uA30D94sA2o0ilph3+wntEZPw0Etlu5g+1YLePYiFjPRX3qsCu4Zy/zy/kGijJu4WywKaY7/0azCeqihd2l0L1V6ylo2N6L14RcNWParKY6ygp3WPwmF4VC/W4VaJ6S8u9JRZ8VKD9jrQ1qi+JO53kiBh2rKxn1KQaCbC/0s3iSmSvZBMwObJ74mdwAn4RUr3ocQ+Mdq9vdskANi4fYR/zQbRTat6yQcJh207DmXmgEtLb76rpDXIs2aYzEcVbXKo9
 7HUDX2CZ
 BcaO2Hxv53lP7HynZtkCQ5Dxa6XlRq6OCFSM3gg6ps30A6dQricOkVh7TJqBo8k+mrz7g3e8y00+zMi70Mz7bwnz8ig+s33X0DxXTtHEVB3c0BktaNyj3q+76kfroNBsASryxJf3Iaxkn3I1OUSq2/3hs5+fvQasK4CdCZ47sBVrcLmyrFZyemeM5W80l8LzfMo1Hk9e5fCLTlYyITmNAiXTuR4YmWt6UYJKWBw+TwpBVyOHDjeBzyZ1spT/JEs9SYsJLkINTnJW3N1EtG40BfdXRjMZmtEgqabq8kMA7z94qinpFs+TDJ6Cu4DYLKyCy5IoKA7E0QJnhT9VTfwzUPvesuHAbqa+gouL6S05yYhiP0KBkSY3RY0LHAW2YcCJE4KGqjnxR7cadyhWhfFMuu2iyaaDOP5n6T7lqgJQjLSzsBEE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 10:09:04AM +0000, Kevin Brodsky wrote:

Hi Kevin,

> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
> +static inline bool in_lazy_mmu_mode(void)
> +{
> +	return current->lazy_mmu_state.active;

Whether (nesting_level > 0) is more correct check?
Otherwise, it returns false while in paused mode.

May be check both nesting_level and active and also introduce
in_lazy_mmu_paused_mode() right away to avoid any confusion?

> +}
> +#else
> +static inline bool in_lazy_mmu_mode(void)
> +{
> +	return false;
> +}
> +#endif
> +
>  extern struct pid *cad_pid;
>  
>  /*

Thanks!

