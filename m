Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFEFC4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D556B00C8; Wed, 15 Jul 2026 09:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CDB36B00D0; Wed, 15 Jul 2026 09:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599166B00D9; Wed, 15 Jul 2026 09:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF2D6B00C8
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:44:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84417C019C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:44:26 +0000 (UTC)
X-FDA: 84991130532.15.B82A64F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 623E91C0004
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:44:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XUDBCE9u;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784123064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/u2mCZiPMLYnW7+q5NfIuTrIQP8TylZu2qZxNmRo7c=;
	b=fO/Ffk5M5L3Ab0QVgnJsnIoPIZ8FEbWsGSbfh5yZCzpX/JV8szix87wkqOK7AphBSQxTiG
	cyR39tuUZCJuC7ZCw1H4bPIdDpViQX1/zrOV+/dkE1ioHilCJOUmYrWSbfxTxL38BNHfrd
	k5aJvlyZOGBcT3aHxnc/Hq5vzUJJ6nw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784123064;
	b=XO6XF5FhcKlau0Q5F3hXeL1t6LHBJpXhQUg//bHuA1RTpuqogxjzClmOcxgybayIGLvid+
	EW2ug/L31E5a9pgpBGsEX4qF+0ldk7wddl7ykisiSyOMorAHlZkJpj7ribvvmmIKdU2see
	dLaPJjuKGgRbEivOZhcutghB0SAvM7c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=XUDBCE9u;
	spf=pass (imf21.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BC4D31477;
	Wed, 15 Jul 2026 06:44:18 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A51C63F915;
	Wed, 15 Jul 2026 06:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784123063; bh=eIgpCTRPgqPTqdx54P+55ycRFoiVAMVPyrH/hSOkxIw=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=XUDBCE9uKhapcjpn3hEyydo6n8Z10XJL4DGb4h958hMrkQQ51e4U0TkwAjNzJDzOk
	 eD/LOzYvppL+1IQtFhflB4XCT6Ncvq4/Hh0/F3eNv5PwdHMKH6kHWKs0fpugu38REX
	 eGLtl9O5j7jNXOw9fMgYIdBX0uaZplN8x21Nq5zc=
Message-ID: <1dcd93fa-4922-433b-9f1d-c096c0de3665@arm.com>
Date: Wed, 15 Jul 2026 14:44:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, david@kernel.org, linux@armlinux.org.uk,
 akpm@linux-foundation.org, ankur.a.arora@oracle.com, rppt@kernel.org,
 linmag7@gmail.com, chleroy@kernel.org, klarasmodin@gmail.com,
 chenhuacai@kernel.org, kernel@xen0n.name, kas@kernel.org,
 zhangtianyang@loongson.cn, wangyuli@aosc.io, tsbogend@alpha.franken.de,
 ljs@kernel.org, jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
 arnd@arndb.de, ryan.roberts@arm.com, pasha.tatashin@soleen.com,
 rmclure@linux.ibm.com, baolin.wang@linux.alibaba.com, tj@kernel.org,
 kevin.brodsky@arm.com, anup@brainfault.org, atish.patra@linux.dev,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
 dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
 hannes@cmpxchg.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, kasong@tencent.com, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, anshuman.khandual@arm.com,
 yang@os.amperecomputing.com, chaitanyas.prakash@arm.com, ardb@kernel.org,
 guoren@kernel.org, yang.li85200@gmail.com, viro@zeniv.linux.org.uk,
 dinguyen@kernel.org, schuster.simon@siemens-energy.com,
 wangruikang@iscas.ac.cn, junhui.liu@pigmoral.tech, muchun.song@linux.dev,
 vishal.moola@gmail.com, namcao@linutronix.de, pavel@kernel.org,
 djbw@kernel.org, yu-cheng.yu@intel.com, baolu.lu@linux.intel.com,
 Jonathan.Cameron@huawei.com, coxu@redhat.com, andreas@gaisler.com,
 liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 geert@linux-m68k.org, shorne@gmail.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi
Subject: Re: [RFC PATCH 11/34] mm: vmscan: remove stack copy address of pud
 pass in wallk_pud_range()
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-arch@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 x86@kernel.org, linux-mm@kvack.org, kasan-dev@googlegroups.com,
 linux-csky@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
 linux-openrisc@vger.kernel.org
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
 <20260713135614.1618183-12-yeoreum.yun@arm.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260713135614.1618183-12-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 623E91C0004
X-Stat-Signature: yzygpcyksrz87dabe616aofggxgoprpp
X-HE-Tag: 1784123064-629892
X-HE-Meta: U2FsdGVkX197OzUGkLCuQl45LC8/pq5pI1tQmLchCYi/9x2F+hYOhNibM2UzfD63WXoekbKkLKG72un2rx5zYVmIiPp19Ua8qy2tTFQRi4hkqXibLu3baaYr+rfibEg8vALex4zmJX64djt5nIVUYEikbhbFdFZXdqhH590FjfdeRUIRHXSG4vbxGfm8RrfVmCw3mZ1sA1DNVIpTxpuNjNlcEz9B05LRsPxKCCqdq8y1xv6nrInI53H1ixogvpU4kaXqUdsJ6DPul8cRUTRxYwKlq4SEuBWMFGql34QLIrHKqX6XkpTEJXztevXsuv9Dz6d9JNh9yDpx0jVi559OWMEi590GCDTVWLyPWpb6B0lScCGuBICF4vryaSyxI38dF+lJd+YfmGxcYCrT2u+uXNrsm70rxagJUWIEs++peWRFIdS5VYMsK2MUpzgIkS5kTdfpq2BxqeFVmDtwuNVBtVi8jd2bhgkRADXFRtWz8Qyf3zZWgJO12KHDSfVSqz1WdDwCVRJAmM+7idz2MhjAknFhinRm9D27sVaCFAo9uMUVnWiE7f8Y5WuHghJhHa50aVIOdxQdSrFQn5ZBCEv87cGOpHAGT6k1LvxmbeQjgwTrdX85ooQY32pjJMSdqMrtSBVatWrHl1PJW6xRmH8fAQP2iMXlaKDqc26RBwFuUmVa6xmkZxwVeFRtkoFbpJCfWQI19m+XyQgcYwFNWePVK72pq0zITnAHOARTza4yt4stBauaOK9EumnnGOV9512crweCze2Jlr4fNfSTTJ3iCGsAIFCdYPn06o4lxSKak/1OYo6fLtEWvPqQbmxLlAVsU/a8G95Rexu1c34D3uAlsFoAB0rX+HZapICXu1Ug2RIA76R3ZagJrzK2HUKZIOnvREPFWEnCG9+4vXt/D+3MYOMCGaHgneYr4NLgD0WsksRXbcf68mdkbTKHLCYQIlnukGk+dt0WwWsag0TTrdd
 9PTqbiJO
 /UYx/2gIjD6EUqtP/hYhxDEdP9e1tJRr16dYDu1q0Ne4+BcjLPWRuDwPJffzwfGTD48UBp41lcXHnAhHdRT5MLXs35wBX/j7VzdBPP95lmyobDLQYkXTQoRD+i/BFRDKuPSrIGN0hG40YWKLmY8Yha9+U2VAvBjWEPccAyHmUB5ix8pr/L/7ub4LorDCBQGK0kgM8FSzH+nOuha0vKTNuin9n7PpLyXgl+rZ1hnrxQ8jyALkOhUW4NBIEK6mYVqG3p4Z+3I46LYKWSSzTcSNGEqINQZRVUs9elb2PudAtE8O0spmpBKFKQxs6oUEVDN4C/dSH3BCxZChnfXcJeX/Gtz27L0IrZ+BE0KSPIqCvx0ff11OdBcd07to5FYVzxPPz4+3ZilgHrgTSD5nv2GM9hkQMsgYy6rPrX+OU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/07/2026 2:55 pm, Yeoreum Yun wrote:
> We want to change how pXdp_get() works with generic compile-time folded
> page tables. To prepare for that, replace passing the address of a stack
> copy of a pXd to walk_pmd_range() with pud pointer directly so that
> the ignoring the value of folded entries.
> 
> There should be no functional change.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 986dde8e7429f..61470223d8213 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3725,7 +3725,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
>  		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
>  			continue;
>  
> -		walk_pmd_range(&val, addr, next, args);
> +		walk_pmd_range(pud + i, addr, next, args);
While I was working on converting these page table types to hardware types, I
had this exact patch for this problem.

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

>  
>  		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
>  			end = (addr | ~PUD_MASK) + 1;


