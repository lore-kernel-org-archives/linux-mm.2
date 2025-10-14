Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8195FCCD185
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E86E8E005B; Mon, 13 Oct 2025 23:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0FC8E0007; Mon, 13 Oct 2025 23:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6238E005B; Mon, 13 Oct 2025 23:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3908E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:12:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FEEA13B9F1
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:12:44 +0000 (UTC)
X-FDA: 83995247448.03.50064D6
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id 809104000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:12:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J7ChGC6V;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760411562; a=rsa-sha256;
	cv=none;
	b=CGGnVSONNJrLAFjgNFupXGLC7LmZvdNjejvY5uaZAmyLf7sfyULO7CRpPr9vp8CZ4qnvls
	dNdjLS18TdTI+/5nIOeloHDxbFFkDCyH+Ii+BNCTxg9FHuvGrdzkpx4Zpft45fQuzx5jBF
	9DbHSoP4A7Iq1i53Dii4AadCMFA1bnM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J7ChGC6V;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760411562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CBWGup56mF4O5M0pZnQX21SFhdfJU3QS5w5Qz5xEMdQ=;
	b=XcDWWVM06SNhty6REiIUay6vGjRFpFoSLBKFVfoILb0ceVgex+/TAvAIFQiBW9P4jFZ0Fk
	SiyE8dd59yljyOyzKhbYtoRslOggRc87iewgRs86Eju67uMFOJ5DrLMDFY2Gcc5Ep2de+5
	Cs6CG6H6WQkzbhSdFO4kMAhkOuarobg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760411557; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=CBWGup56mF4O5M0pZnQX21SFhdfJU3QS5w5Qz5xEMdQ=;
	b=J7ChGC6VWw5JS2Ra9dBmzEm+rvX+J7r5SUSVGxhlp7YqDB/9UJeHzShGEpp6pUM4twkCjrNqInPC6lvuaMN1iumVcip23tlafS1fydHJ9wDz5EFobnQ0nO4d+1B1snDlKcXIy6mx6RkCu5BKX8qyRIN5EcDYBf0iSA1tFhWja/0=
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqA2qf7_1760411555 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 14 Oct 2025 11:12:35 +0800
Message-ID: <e8002ad7-e24a-4d85-bce0-1eb5d265a8a8@linux.alibaba.com>
Date: Tue, 14 Oct 2025 11:12:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm, swap: cleanup swap entry allocation parameter
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 David Hildenbrand <david@redhat.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Ying Huang <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: osjcb4ryxjkqsgnq7jbwykynbft5gds3
X-Rspamd-Queue-Id: 809104000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760411561-745728
X-HE-Meta: U2FsdGVkX1+cewQPqv/hty/e3XJ3ReiHlxiZ5Ya0BAHE1oXh9zNxzODL4vitHR2dFI3utBh7F1Q6JYAjGDX3GjsKfc3VHbcKATPwP3Ur1IG7lZWsYSSEJoc03CSsJfz423jJDSi7ZDSp5JANaNNA2ZLZOSeMoiHdJvEx7r5sHRr78j2bMLP7ubbuOSD1YL4IdZOO+t1C95jT/S2T3i2mtVgBVCxMkEhOkdU2vtL8wcyeZwBk5PdO8Wm51ltn18FDeyiPNQmrDurqRh8LoXweenIa/yNazjidBA/Xde+u1JhufmY6Rt0qTu2DoG3ZyM5ptusXMy77/3SCi/W6pFH4gouRHsOwhBk2GK7l7Z48geHMMvtcdb4Q0JAleYbmfZY2bydKtuChx63y/cq8WsT1ecIhLnIOovu3huOLIQnFzVj4MH+Lgd21G7gFEGl1ACna7cKydHNbLf+qXxFJn6DxOLBOSrgp9eau9s1q/0bXAJkZycQzfG2lEOukNX0sHH4f3wst8VP62wEepp20GoQVrvhp3pgVtn7ejkmjdul+Qrw7IaYr1ptRNnv9np/118sxsh81J6/80+3ewNkr2EhHMVmXXRrIytA/cgDczKNycw3Q6XVTuvS4Jps4yjHNkgEN882tVJs7YqU0ZsQH+aUIFuPSPVCRRbXo3muFHu+J0r6PD/H5G0ZAxshuiwrwCYF/ktcPd5Il0vqdaiJm2Gdt+zaBa7FMUZ4pgiySbIhuFhFLlVtNknlPgKDS9vspx3G2puaXr1BQvvl+1gJvm7RtUaIKtjRwO8b3Ae/TJrBvjX9XZJ6x74EY9JdzHNnVjG0LtEIJ47rC9833T+sNp+nxj9qm94XLDXKhUOkO9pCorZ3RLtt1gN53n8JkP5unUiYWnvwNaOn1Zl8cqbvyZmvBeDzzMIop2hRHbmDKnkuRHPFfDQYlZq1p4cWBHkkTDO3Qq6jeGm4AIypo+YvZqgw
 HbDolYt3
 AccwvbBEsrn6Znx9vTIfgifiLd3R2pZCWWh68g2GmfM7Ve2sVQp+CWQled/a7+VG0msrDwWUfUxmHL9KO1tAC2T6p5+zOaRFhcNYVrVhcE9hiPBkkMCGN8t67lC+nxs2OukMYy2ncNOlphBn8ASbXvsYZqXltPHn1kvyCakoKCPxrqWBeAT+IM9V8d/BMVWVnZOfiYp1+2ZATWNY8MrK89TXFAKGLvDMgsca4OpVEA28foe5+usn/WpNcysUtaFRj7w/XA4407XeJaqO2K3wxpEA5B0VkM9clHAQlzMFl9hQDe2rlHIM70JRG8lQfCitM9W0LcYRDEUK6uOc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/7 04:02, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, swap:
> use the swap table for the swap cache and switch API"). Before that
> commit the GFP parameter is already almost identical for all callers, so
> nothing changed by that commit. Swap table just moved the GFP to lower
> layer and make it more defined and changes depend on atomic or sleep
> allocation.
> 
> Now this parameter is no longer used, just remove it. No behavior
> change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

