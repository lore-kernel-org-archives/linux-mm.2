Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76FEDCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 13:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FA36B0032; Fri, 28 Nov 2025 08:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C009A6B0062; Fri, 28 Nov 2025 08:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC8536B007B; Fri, 28 Nov 2025 08:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95A6D6B0032
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 08:56:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B12AB9CF0
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:56:34 +0000 (UTC)
X-FDA: 84160165908.24.58D5C08
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id DC26D80005
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:56:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nfuSb531;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764338192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuc3Pms4+K3aWFusIGvCSQgbvYf1noIU83gft25Y0Jk=;
	b=lhPXtXNR55l6x7shYS+w4LtcG/z3zK5TWP2lzwkVPjnpasaW/x/UEtJ9GX+N1sdT857cQ0
	kX5DjRCdd+k3KiQ/dDXm97WCp5xPB303oiE2UoEb6LuG0lO2XdqSJor8zrFGfqURfBEFMW
	NpSOVUnlwlahPw3r6O+EvN0CLtjlOSY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764338192; a=rsa-sha256;
	cv=none;
	b=LxQz7JZSis4veiDordD1RAGGXWTXUUKslcgsbWlKkISOJUic0lIhbHelDcln+Jd9rvbWH6
	+kC4Xe8UPZYm8XYArCUqq6+dxpGQmvt5ORAW4mM8BbSxSGJz7Uf+ncSXXeCALSNDWLH2QA
	6pJnOvWPPQYk8yr/Yio/nedCFXlgiNo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nfuSb531;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ARNulWW017020;
	Fri, 28 Nov 2025 13:56:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=wuc3Pms4+K3aWFusIGvCSQgbvYf1no
	IU83gft25Y0Jk=; b=nfuSb531tk/ek8JrdBpnHmvTEUDTGbCOp0mphA7ZrbDjev
	BoWgzhxao1BJFJ59KJWq6mU5zymb5DM0QmNtdKaLoycmcEjymQLzMJV/TgfJJzco
	x72Yvin16SARaWpet5dCakug5hQt6Tv3ziLwE724GmNpAat1fUldsTgBmAGjUWvw
	qa8kw+7V9U9fBKvVz1m5BZgU8xpkzn4262BQtEgONlaRwL64IR0LfDkCSyvx8nkI
	sDg9UvJ4tHfUID1Q+oblXNoCYf6305+ge0nzqdrEOkRZ4n4+jKR7y6mgw/6K6xW8
	6lOcMGox4kBO0S6c5bfbGrgZ8yMnmXl9ytTmhifw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uvpnu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Nov 2025 13:56:04 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5ASDu3As032077;
	Fri, 28 Nov 2025 13:56:03 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uvpntw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Nov 2025 13:56:03 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5ASBu8XO000831;
	Fri, 28 Nov 2025 13:56:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvydb5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Nov 2025 13:56:01 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ASDtvda33423852
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 13:55:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2F99720043;
	Fri, 28 Nov 2025 13:55:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E38D220040;
	Fri, 28 Nov 2025 13:55:55 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 28 Nov 2025 13:55:55 +0000 (GMT)
Date: Fri, 28 Nov 2025 14:55:54 +0100
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
Message-ID: <23dcf752-0b75-45a7-84f8-25bddf97af08-agordeev@linux.ibm.com>
References: <20251124132228.622678-1-kevin.brodsky@arm.com>
 <20251124132228.622678-9-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124132228.622678-9-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX384OntFmUues
 dIOJyCctOD7nT813bCm/GhJf1ZL6CQOs24jDcqmIzdmwQ5T0RXoegg27XMRfiI/9rumngr6NMHx
 tl4nQN+mvmC+VcOHvBu4um686d8ss4oR9DYJ5Ixwx22asl3RT+5FAdIGmztRh+XF2zs4cr6A6QQ
 2iJfQR9W19UY77K6hY2ve4BgoptnP483ec00f8cJVrDJ8H4kjr1jbZu+2pYFaT3+wJs+yp2bpxN
 Z2mA9gIRx8y/C6JYy4/N+CX6k84tbzt6buSUWK1JGk7/Kg3P14z/anrGpqdlT7BTI/og3OVkJqE
 hlGzPPlMS7WwIcss+Fa5oKUZR6EVsKg4LDkTSZbq+j+4sF4jCL4HPpqSwmzRhTJdfHsyh20fqJg
 JHubqHqdjGvQbJ9GegZsZoMEJOKyzg==
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=6929a9f4 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=h1tPiQvNrzWZOeg10D8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: 9jG27-IvFUYEwqeWcDa4RUx8C7I3n3xe
X-Proofpoint-GUID: 3YWVV-kCMzKLLzypHTUX-OcmdogqNxWJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_03,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021
X-Rspamd-Queue-Id: DC26D80005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ucnzg7twwqdrmmc1nz9pgxt8igigsrxw
X-HE-Tag: 1764338191-833803
X-HE-Meta: U2FsdGVkX18RuaWzpOi5I0WUs4G5H/cNSu49T/wE0o0cnVdGFYIahrwbEKFvqN+G8Jw+vMkhw0mfodZEJoofchxfu/FvWvoPvB2kOOCt7MFvnp9egR6LfxG+Ixhjb0XojP1svoCEpCZJ4o9vvzE1sTe7ls0w6llteKf6iNbs/8dNd8hfdzUW+bxHxFssie6Zh1fWvn+VdKmmr2ZxMn6wtHrkg6eO2HsDt8bO3XTaUxlt4/cypc0eOR8cwgpMVaxv1aN3GJW4k2o7sVkTio8nJzHyGe32iZ5sY9UNOOKRw5roCPempMFTZKd8zolFelaEttQ7LufQMmLUghY6Odb7vkWjeXPDKFeEPVPbUkwizeseXY/A4OYvDFqjPLKKsw8NTWcNer5Y3nWpEPFTCK8Bx7n35An+RYe5wHIq4VfVPDXiepHd014RkbX0prN6Fk1g2Q5SEyr3Ue2Ug5sE8LJoWuKfAHxMxhKnk7/GtmJ6IVWwMYk0ohwyD/bZwA3RvTC4B+hSSmONV7a62bnzozt9gUe2wsqYzNNRL/rnIHf5/9S22rbLVOFZ77cUUrCtbzxWNGDDsjxEky76vV2sCrPZwRX6qYEy2/07oLx5ngQcEGCWDEdf3QK0iKtF3aQMM9umt0vi9sY8fgvxVwj/j9vSeHSpjKcHf343l2xANvuylGewVbrK4/SuaeaMvgRbglfD/FVGNlD09WvuqLuhQzpqUQlewlwW6mlWUGgMp5G6iFCDSTxSjri74oGm0YOny2LwxXoBvyxKvfa/X1ZRQly4ervY+0I7qFIJzZONz4QVR04HuYCV+7FPxyVkH7NCEx4yo6YDHSvTXMBontxiltJbNTF8vAPqyrybmng/jHrIjkwFapanbat0BwxAdFTJBGmbA1roga4Li/KDAYqVU6f9mi56+hW/fOwTgbjA9F1C5CjG4npbXvTOH78G2jaxLhQWUVl7k0jlqnUhyo+w51k
 a4Po+4Wn
 8b/p7ceAA87LEeV37Iifp9JuZOKOY1T0c1PRvIARrbCro9Aa1pvVG2FIWyOxyUAj2IgppltcIyUMz1K0mS3mxZHmY67ulaIjuLhr+cty7O1adNRjMCvPTC8JsKKlDEi/6y15DVTBvV6DHJcJvk0VX6sZm5Q3XjfOQMAG68PMuwqExpIZQyuj+sGWR1wkvSvJYuUbg2333zxMMFr2h3wY1q7RQWkGhiL5icLJuSSfrbAqK5cgiPhaN9ayh7kMwTfiFWiuOzRItEL6u+fXqyQW9B4AyIsrXzsnq76eHTOyHZRpH0rykFwDbZZaQSvsrcQy5gX9IlTZBsbZs7HRYOV0xgYrKubBEK2cz10Qew39DR5lYKvJuLtBI4JyL1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 01:22:24PM +0000, Kevin Brodsky wrote:
...
> + * Nesting is permitted: <code> may itself use an enable()/disable() pair.
> + * A nested call to enable() has no functional effect; however disable() causes
> + * any batched architectural state to be flushed regardless of nesting. After a
> + * call to disable(), the caller can therefore rely on all previous page table
> + * modifications to have taken effect, but the lazy MMU mode may still be
> + * enabled.
> + *
> + * In certain cases, it may be desirable to temporarily pause the lazy MMU mode.
> + * This can be done using:
> + *
> + *   lazy_mmu_mode_pause();
> + *   <code>
> + *   lazy_mmu_mode_resume();
> + *
> + * pause() ensures that the mode is exited regardless of the nesting level;
> + * resume() re-enters the mode at the same nesting level. Any call to the
> + * lazy_mmu_mode_* API between those two calls has no effect. In particular,
> + * this means that pause()/resume() pairs may nest.
> + *
> + * in_lazy_mmu_mode() can be used to check whether the lazy MMU mode is
> + * currently enabled.

The in_lazy_mmu_mode() name looks ambiguous to me. When the lazy MMU mode
is paused are we still in lazy MMU mode? The __task_lazy_mmu_mode_active()
implementation suggests we are not, while one could still assume we are,
just paused.

Should in_lazy_mmu_mode() be named e.g. as in_active_lazy_mmu_mode() such
a confusion would not occur in the first place.

>   */
...
> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
> +/**
> + * __task_lazy_mmu_mode_active() - Test the lazy MMU mode state for a task.
> + * @tsk: The task to check.
> + *
> + * Test whether @tsk has its lazy MMU mode state set to active (i.e. enabled
> + * and not paused).
> + *
> + * This function only considers the state saved in task_struct; to test whether
> + * current actually is in lazy MMU mode, in_lazy_mmu_mode() should be used
> + * instead.
> + *
> + * This function is intended for architectures that implement the lazy MMU
> + * mode; it must not be called from generic code.
> + */
> +static inline bool __task_lazy_mmu_mode_active(struct task_struct *tsk)
> +{
> +	struct lazy_mmu_state *state = &tsk->lazy_mmu_state;
> +
> +	return state->enable_count > 0 && state->pause_count == 0;
> +}
> +
> +/**
> + * in_lazy_mmu_mode() - Test whether we are currently in lazy MMU mode.
> + *
> + * Test whether the current context is in lazy MMU mode. This is true if both:
> + * 1. We are not in interrupt context
> + * 2. Lazy MMU mode is active for the current task
> + *
> + * This function is intended for architectures that implement the lazy MMU
> + * mode; it must not be called from generic code.
> + */
> +static inline bool in_lazy_mmu_mode(void)
> +{
> +	if (in_interrupt())
> +		return false;
> +
> +	return __task_lazy_mmu_mode_active(current);
> +}
> +#endif
...

