Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77BED2505E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552146B0088; Mon, 12 Jan 2026 04:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FFB06B0089; Mon, 12 Jan 2026 04:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FE396B008A; Mon, 12 Jan 2026 04:45:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4A66B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:45:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EDA0BC2741
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:45:46 +0000 (UTC)
X-FDA: 84322829892.20.5506167
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 43DD51C0007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:45:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768211145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fdMLvjeapQ/bfLWsnXGxaJQDtJcQspJseu6jDbRyKHU=;
	b=LsyHxOWMm5e/wOpsURGDv9Iqq4NoNUTxxDIc3MvdgssrOgbh761UdqQ73EqHk7J+RFdMc0
	stkqu8viszvl6NQMZI78fCIRnrA62E4HSUk9wP3bbDe+Pz+b4eD+g3QoXz+SNh+l+6K8dX
	Fb60Wnd671DkCx2v/xdZ69tPkrfWWZw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768211145; a=rsa-sha256;
	cv=none;
	b=T2fvL57jjtLjoxgqUAJaKBBZhUg8s03HoYb6joliradJH+p4l6DTLJI56EbZahL63Admzq
	XGc6E24MbV6vtwDbaUalVTcSmrfFToXvWGuAVN6Ku5m/XAaqA4iDSiMxhrkU+COWeXhlP0
	LoTjnLhnC5MnE6/Ri3tbHJJbwrhynJw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5A486339;
	Mon, 12 Jan 2026 01:45:37 -0800 (PST)
Received: from [10.57.48.185] (unknown [10.57.48.185])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D5C6F3F694;
	Mon, 12 Jan 2026 01:45:36 -0800 (PST)
Message-ID: <f287a467-e707-459e-96b2-ae0bb0fdce37@arm.com>
Date: Mon, 12 Jan 2026 10:45:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-15-kevin.brodsky@arm.com>
 <1e123306-0efe-457f-953b-d4a27ce6bc60@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <1e123306-0efe-457f-953b-d4a27ce6bc60@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c3cm7tqnrat48jj631ehmo6gx4ssope7
X-Rspam-User: 
X-Rspamd-Queue-Id: 43DD51C0007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768211145-492935
X-HE-Meta: U2FsdGVkX1/htoK61hB5R60M61dC4G0h/EXTd51iudMnFZiM4Ba4fIUiK224l3yE87KwdS7qcAx6ZwadCCVDAU5AWV2gQfcB5Iq3x6cLD65PE1x9GCGff8gujrJSq6rEnYfzmIYh9bnLsNBhSz9FnBMblPNHvvxyZTTZGJUYPo2JXawksTLkvzX1KhG+0gE2GHSY83G1EKGtwrYLfY77EymXdbCdvidbWHYqBiL0uOqxE5UjFbVmT1z9vR7fJ5DmSjk/MdiRhua025BCfo2gRARvgOc27F9pH7VApIe2Pwe/YNUkQ73a9EHaK5lSmxLOhcc4hSrPzv5iDYSVNDW9aSr6GT729TKX12Q6OjIoZzxs7dsfLgYyfkEzpHyGjSoE7nL8dN3/QdUDMHs3myiDqCdaAM2jxRtHqGaCG4ucoaJm5n5tOF829XcFzFjeZLBg7oZG0S4zYlDvhLk5Ig5etCxGK71uHM6Dey9ckNFM1YTheseHlhTX8Yj9ppBz1oC15bul+0OLLSE4nrR/iuS4hwtfBEhJwz4HIjCS6sr9DqeNR81tzUd8JemblzDqR0pUVxjHr/I1q+1/Ox65JxelIIvRqxNLe8YpfTP7y8NnypFaRoNd0iENzq9B0fn66K7yNBW4ylReoE7TkOH9Gqgi6bz7zg8CF4fn3BWBCTpXRvEnUrcyPrH8l+KTFjIH4r9A85gL1NiDMuAawhax412x8fgOb0iccrHrK9+e4kCuWrU30fV2VOGj8+ql9N2+C4keOn785FSEMDOFdwN1OGmkppwFCrAPoevv6EpgS6YRKvvSmT2SZKXl3QM3pzT1jPAx8ErGIk+yoNziAfBIOV1sy8/4f6koSEymy3obbx+U5AwuPpSCEm6Y5TDFrZOirZLo4fZz3s0F+uZDfLEjHYThQ474ZaAwzxkhIAeO6N5jni+lymSXTn5CBOcpTmd9TMC6Nn1VujU0FNIm/lDw+XC
 VYRnZQNk
 alw9guP5rHMJXT5fFL/9GGnetoyTlRmlcgi+4Kqtb87ZMHuXd0bvQlyEVHnxr2tMEviurYhEdEYShobCdKFZbGQnta/OzYjtL0S68KnG7EjSHCRa3Z/i/BQ5cMy2zSMOkCACd0+V5yJYi3wH5nANurHeWAlSooEdbCd9AUKbnJcReqgwS4fMfuPPm064iJiVUI4ILCYou16jpesUXUdGNvJtzswt2++qWA9ZpTou4/iBd030ecxPCx9k9u77wJwbkpgLZGoYCGyP4+Ohm7C9XDKGfqi5p9WM3JV57
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/01/2026 16:07, David Hildenbrand (Red Hat) wrote:
>
> Very nice test 🙂

Thanks!

>
> I think I prefer the EXPORT_SYMBOL_IF_KUNIT over disabling the test
> for PPC and over making lazy_mmu_mode_enable() non-inlined functions
> with an exported symbol

The EXPORT_SYMBOL_IF_KUNIT approach is what's currently in mm-unstable
(with the fixes from Ritesh and me).

- Kevin

