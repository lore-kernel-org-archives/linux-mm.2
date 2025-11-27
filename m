Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3161ED11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 12:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5606B0011; Thu, 27 Nov 2025 07:34:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D066B0023; Thu, 27 Nov 2025 07:34:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7932C6B002A; Thu, 27 Nov 2025 07:34:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68D5E6B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 07:34:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 052C8856A0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:34:27 +0000 (UTC)
X-FDA: 84156330216.22.929CC82
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id A2E724000A
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 12:34:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=J4oL5vFe;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764246865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U/SiOGxBruZSPDZESgyMeWRoh9i3M0q8OwIPHZ+5svo=;
	b=Svw1/imHU5XXT2y96k1MZRTi6AKd0QrectbFuMzQrondMaHFaPtrWSohRzx9Zr46gNQ7ij
	x+Lxtr/NW8wy2mzth/3pkX5tWVvpRsI1Vs5Er+yLT2SVWToU+FUWCvFsriQuWM6ZrRvMDK
	hK6jJ09vgMumLFFREoG4GpTOg/KoPAc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=J4oL5vFe;
	spf=pass (imf11.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764246865; a=rsa-sha256;
	cv=none;
	b=nw1qFoahI9kwomfrxDi1qxiWt3XePELjRrhmJLx8nNUwhMXp6q7fHNbSriLNkJtHoi8PWQ
	wMhS1yotXRosn4yo9HghnlItn4QZjtHXEIiNz1IkpIqA75VjPtYlcazSP4aRdUoWqDNBHX
	2mswmzqyOXNzVlIpihZ9dYyMd5XQ7Ls=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AR28C0C010976;
	Thu, 27 Nov 2025 12:33:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=U/SiOGxBruZSPDZESgyMeWRoh9i3M0
	q8OwIPHZ+5svo=; b=J4oL5vFegHjiNGUagzBApHvzd8MR3jsToqRXuYwO6O9Ano
	CfVy3024jZCEuLyMaeUHzi2cgBCQ5T6x4HVWA8NCfO7ZlKXGxRcy5YmZX37Zh2xF
	MzA5rDBMW3cmhVdAQSTeXH+hFh2FRdgAuqx1Jzqmk4tt/2ktJ1SEh2NYPAZO1/7q
	jBIoJv5xvHry1ZrUt9bk/no4UIxF0+pD3jnN2daFgo+pwGrp+lKi0J01wvI25Zwo
	Y+JFSohSzDUkcOH+osfpgqNaWu3TBtAGEL12D2LyBmVKPVw6tBHfq6+fKyW1yPof
	wj8Xue+B/9P6KlMUmOSnnh8qz3jHMVFftGHP1S7Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4w9smjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Nov 2025 12:33:12 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5ARCRff3010922;
	Thu, 27 Nov 2025 12:33:12 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4w9smjg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Nov 2025 12:33:12 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AR9paJp030755;
	Thu, 27 Nov 2025 12:33:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgsr7cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Nov 2025 12:33:10 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ARCX7Gu41746800
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 12:33:07 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00AAE20040;
	Thu, 27 Nov 2025 12:33:07 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BACC920049;
	Thu, 27 Nov 2025 12:33:05 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 27 Nov 2025 12:33:05 +0000 (GMT)
Date: Thu, 27 Nov 2025 13:33:04 +0100
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
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
        Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
Subject: Re: [PATCH v5 08/12] mm: enable lazy_mmu sections to nest
Message-ID: <4d0eab1a-e1dc-49cf-8640-727c9734233d-agordeev@linux.ibm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-9-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124132228.622678-9-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX9NOF0yN0lw1S
 0SZ2o+OA5NhSGQn0BtdyjjidP8fZgVZF6bKGYqOeYaerArXU5/eYaH6mjoMO836BpL61X8D4vHm
 UI4sk8Hx5RARonWYhreWmyHWARU9ObUiHo1rZ1488kywlyb4p1nLQviUeZWU5jHTK6ubjCRzp3f
 +lzNrZUD6k4MitmXkxXE1FBSz+t2k8OrxvuQ9N1qtEU671rSSdQQZW3OzxL73gwtwodSoKuCAd5
 zVlpdX6K+l3L9DoCrkZWL523cXAZ3K0nqrWUQOBp/3nUGHINn5pOunRbOHLW3tYBKmoRFSshw2u
 kphg/WcqiohDerAKQWOcIW/5lvy2GLS3clWCMDLpqje+49pqSaVI+EbpcYECNk2qFOMpAmxlrdh
 QN7hJqHTshMIrpIpwd78rJv0I72AAQ==
X-Proofpoint-ORIG-GUID: jxCWpMIwO3U273NtNuZU0G48jrPAegj4
X-Proofpoint-GUID: 4fLOgGROG6bc0vkQxWmm4vD-nC0jkq3o
X-Authority-Analysis: v=2.4 cv=TMJIilla c=1 sm=1 tr=0 ts=69284509 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=l97El5uum0sds0BcBlYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021
X-Rspamd-Queue-Id: A2E724000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5heifenfn9c8d61uydnrrgapdfo175wu
X-HE-Tag: 1764246865-570814
X-HE-Meta: U2FsdGVkX18FMZf2m5YjVBk2FgkIXDkPBfX96aSG5l4o/E4ztO3EHwuo6QkE8RV8Ovddt87/oVzgO7V7DCl7mROcm2FA6VWdMe/1hA84wZCIEe0SGTfQ6ypli2Re4/53rdCPmMIAJTaOXysZmZHuKtedX6rUh6oR69hZVqzTyiLY8qXdttZ2VzHmdk/KhzRL80+ZHmKintGekhSvolSF59Jhbe69M9W9c1ZKF+ezvtWs93JR7QVxW7+I/7vdyMdMXg8yqgbyor3khJb5BEah7tGyvjO2ZLFUrX7BKaJceTfu7KDN88UV6B+fxNQ3BsDg2g3GhN7pHs09K2k9t5n6jHitQyODkwwJ1yifdfhPAYPkZNMZqQBTHd0P3FN6H7cbbhO8APyUDg1hVpONWqtder71GiqnkxQYsXNF6JE4GraNFKneOVPBcIxRhVFst4YhCCjbQKRpLDoeg5AlO10gG2p6PFk4Jt+P7dRrqfdovYZvzBHTfgvnQK1tFGbCf84AIncluUzpYQekrUBKcB5qnr8T4SHcn3AZdbnfJdry1d9Wyj4Mzuz4iGxNeGbUZ2UcX/rj5oqyZixhoaRytY3eyBEyREwnv2ls3Xg4gPiFCIyCmmuopCGOH1TghLCzV1zT1+ccuMX5c860ErA5MNb+ClkZ9tRUBL+Kh3PzXOhzkfZGPxCWgXAIwe3qLBsgaruCwugf/aHkyxuJ+3pJdyKOfB3s/W7f1qErQ8PkEBzOa/ZoFHW97LukY7QrvL332iFOIfuSq+yKIyzPsdBnaUuKQqIeYm5c4F2dONLIaNHuvD+6JOA9FUCFNRJvgQbmtjCyKl65CJ3q+eKKtFv2xsDU6NGFk+A17urQciYsHUKLAZqnS8IIqetzLpToANDZBEt3hv9QZG7tmtj4khWID2GBgWiJe5dTtYIX/hhUG0tW5ip+OoAVmnltxdV7RPlyrY5AAZ0HNMsyWZKRAAhRMmh
 LL+ZKTuh
 uL99QU8/uaMSJAvaO3qt5oOvB4tMFLx9bSZ4V2zhN9dxQxOJNH2AC5/T7iEWiVcB2NvmdHLz6KepwO0/t/Bcdwq9AgTjYaNJ3MS0MLEpjZmI/lpffryHHIsfjYt7dB6kVR5PfafeKgm9mBwkSeKSeRhZGAMLDbxsoMJm1kCaMOR7PmN8QLrNEdH1ONNTWPtSRj31f0kvvpRAmLhkcRTF9uQomoMdkpSAY1JA9RwFcU7URdrJmq4OfO6VsCHks3P4ViLXrhoFz18whKHIBDnV0oQRAALPeJC9xwL2S1Myyx0mZ79Q9TD1P97ieIIPljWyRinbxUmCz5PF9IFQskCtxMyOs7afr94qdyeC5yIr8OaLJP2GqvTrDA03fWcLzfjnzAM5Tj195iNgt/f38iIKBhZePLdKkTVMdtoEHoNB3aM0ISz4SyKsdfwN7NqCC1/b4dKJ+ck16PtaW0P0tBC7X3jk9DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:22:24PM +0000, Kevin Brodsky wrote:

Hi Kevin,

...
> +/**
> + * lazy_mmu_mode_pause() - Pause the lazy MMU mode.
> + *
> + * Pauses the lazy MMU mode; if it is currently active, disables it and calls
> + * arch_leave_lazy_mmu_mode().
> + *
> + * Must be paired with a call to lazy_mmu_mode_resume(). Calls to the
> + * lazy_mmu_mode_* API have no effect until the matching resume() call.

Sorry if it was discussed already - if yes, I somehow missed it. If I read
the whole thing correctly enter()/pause() interleaving is not forbidden?

lazy_mmu_mode_enable()
	lazy_mmu_mode_pause()
		lazy_mmu_mode_enable()
		...
		lazy_mmu_mode_disable()
	lazy_mmu_mode_resume()
lazy_mmu_mode_disable()

> + *
> + * Has no effect if called:
> + * - While paused (inside another pause()/resume() pair)
> + * - In interrupt context
> + */
>  static inline void lazy_mmu_mode_pause(void)
>  {
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
>  	if (in_interrupt())
>  		return;
>  
> -	arch_leave_lazy_mmu_mode();
> +	VM_WARN_ON_ONCE(state->pause_count == U8_MAX);
> +
> +	if (state->pause_count++ == 0 && state->enable_count > 0)
> +		arch_leave_lazy_mmu_mode();
>  }
>  
> +/**
> + * lazy_mmu_mode_pause() - Resume the lazy MMU mode.
                    resume() ?
> + *
> + * Resumes the lazy MMU mode; if it was active at the point where the matching
> + * call to lazy_mmu_mode_pause() was made, re-enables it and calls
> + * arch_enter_lazy_mmu_mode().
> + *
> + * Must match a call to lazy_mmu_mode_pause().
> + *
> + * Has no effect if called:
> + * - While paused (inside another pause()/resume() pair)
> + * - In interrupt context
> + */
>  static inline void lazy_mmu_mode_resume(void)
>  {
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
>  	if (in_interrupt())
>  		return;
>  
> -	arch_enter_lazy_mmu_mode();
> +	VM_WARN_ON_ONCE(state->pause_count == 0);
> +
> +	if (--state->pause_count == 0 && state->enable_count > 0)
> +		arch_enter_lazy_mmu_mode();
>  }
...
Thanks!

