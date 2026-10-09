Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C79CA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:39:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50DAC6B0088; Fri,  9 Oct 2026 12:39:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497C56B008C; Fri,  9 Oct 2026 12:39:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35FFD6B0092; Fri,  9 Oct 2026 12:39:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1238B6B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:39:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A15540465
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:39:04 +0000 (UTC)
X-FDA: 85303647408.22.48EA8C3
Received: from mta0.migadu.com (out-95.mta0.migadu.com [91.218.175.95])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6C6F81C000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:39:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J+8gLjcW;
	spf=pass (imf18.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791563942;
	b=ed2aHNVXtM5897Raw/11gbg/84g2h/+dWUrdq/thzu5f3J1ZX6gjjhaf5iUoeiH0/Sci30
	OCRC05W3ekFYMRhAgrjT6FVcDo4EuhVFLT7aWGk+aMInItdW5jDko7mZKhcKzPEUq9b3nt
	7VCbT2zDCLlrLJPQGirXDI9pxaNGONY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J+8gLjcW;
	spf=pass (imf18.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.95 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791563942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hz67S+x8+369uZQNmLOoW2cIOvuZqP/BmHvrslsBMOo=;
	b=TA5dOtC4wimPiDJDQYoJO6F6WCjVgoGHKP/nW5O0IjMojEi11Gy46Toq+qUQzmdgf9eYi8
	SN+d0h7VEYoCI7mHeLogYlJpsBq/WNuFe4GoTADZpK/BXMlbCy54HJkhiR4eOmmlhYONlq
	oQWFiRx18CdwsqjkRETAmNyvOkOqXUw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2kGLUYEClmKPKTPxWBwetLsiowXRUtWKT3Hr9vxYvAA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791563941; v=1; x=1792168741;
 b=J+8gLjcWIxCDxxC/2IfV/ZWtfXuEBkGDloxeJFkNV+EHvLOqM4Kyiuuu9Gyx9vyUY83MjdNs
 YlWEIasWZzKsygr/mIeLxT2DY48TDLKpEzGmDSBbxEcmqp/2akMECj4E5igb2PfFTzAztJD7PMi
 v68/J1/7HCam6KlQhVx3AwoU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8714190fded7bacd;
	Fri, 09 Oct 2026 16:39:00 +0000
X-Mizu-Trace-ID: 8714190fded7bacd
X-Migadu-Flow: FLOW_OUT
Message-ID: <271f7ba8-df38-4c8f-b59d-68b52ee998e9@linux.dev>
Date: Fri, 9 Oct 2026 09:38:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vma: keep the unlinked VMA off the file across
 unmap on mmap hook failure
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf <bpf@vger.kernel.org>
References: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
 <20261007194708.2009-1-okerixx@gmail.com>
 <e139339c-1e55-438b-86bf-0960ad4029f1@linux.dev> <asjQQF_Ok1TZPm1M@gremlin>
Content-Language: en-US
From: Ihor Solodrai <ihor.solodrai@linux.dev>
In-Reply-To: <asjQQF_Ok1TZPm1M@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C6F81C000E
X-Rspam-User: 
X-Stat-Signature: 7uh65uhsbgnxhtpf6azunxrct7wo6tbp
X-HE-Tag: 1791563942-991143
X-HE-Meta: U2FsdGVkX19EvbDFHrIkL123lyucRF6w/SSTlqFhkmAgqykOXw/564gNpvnXC7O9xHJEf1H87CZe6VBq+TGgpJGC0THNHP1nN/z7LRQU0onOSQCcE8zGZIMLRL7cE8KoMRe7/y+JLovRF8Lf7PCm0T1+pBi0sa//usvgkL0aTd4BjR+J81MSQfpddtAMja6ODY2W9hu+15G9bR2lLq8sTpIRj83X1q0hmzx8WowpyRZpmErFe7DJZG31nVnlUhoRurEflc5l58/OJqrZesGrBwEXM6XwPW2o+cCpZyIlIqnIeWZ2/Qch4HEHHSN8Sw6fcjcolI12tkMFoKvHpkc8OcLJkZcM/yFCs/JbO6wAhUfVCyiK6+2dRYDH9gU6GtPsQnnaC8F943MxvXIDym5F8cwJxRJ0Lor40zU9bWvxwSLdRAEsmDMNrt7d5ExHhKzHRx8ydrUs9uPz38PkYqrUlkYAN+v/fS45Tj8PqrMaLaj2x76y1Lz9X/4LxcH/bsZBcOXX1zoko3c3o1Mqch8ijsqJmoTXxCE01wAkDF2jEMf79A57oOoX7dMmCp7xecH9O5knkLqg0NlpWQJz2Mb6S8+PP8vxw7hWB27kMg+pAe4+JefW4MRjVcjuiW7HAWv82Tcsapr4vy1du5fJg78qxxnZbkEkk/NeiWW5uicj0pm9j/PD7guZzyqGfGlxMel65Gv2HohFXpI578gPaJ2HUn1gq629oMEcMlql3awW8/lH7SWXLvNSMhg1P52JmInaeRDOnHwWxdwG64vQ1O7LMdQCL8Wrfz1eYI1v/f8x7AGpiiUMZfW2xXgokLB27NLrWI6CSCYcaIdWVGz7u8gjfbc4+qIrum8o2CWHoiCZJfxz3444zw4VQC+uplROflHLxov/wbU1q7HiynLKosD4Ovbq++Q7ZI8BDFOqFkSK8C96e1G7XolaGjv2pPGPKI3z5Cd1J1ks1v4Kcujt51E
 rQG329OA
 KElW+0jh2F78mB5gfWZTS3DOllqk3jv06h2iaTnudX7tJbm3w6DOyf4400FhaOlXqdw6c2Q720IjuG4eliY2LzQFnjv+qnCVm4QlOZ1am/JugKPCgnYp4kt8/bFVQvkVIM5KWXGsasBmjsNyOtYjKbW/HI/sGntY1LIV80AQNYDtuKlQ1pT8/DOi1MVMTkQI5osFuSenWmGG66V+jlHPkjsDekoSIouD6Px90zgV8I+ihaieoTtGKF0PTVF7God0QW/ye89wsWc8cYTxjUJEq4Hu4E56uBVIzfj3DDJxPwfEqMNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-10-09 4:31 a.m., Lorenzo Stoakes (ARM) wrote:
> -cc slopper
> 
> On Thu, Oct 08, 2026 at 02:48:07PM -0700, Ihor Solodrai wrote:
>> BPF CI caught this bug on linux-next as well:
>> https://github.com/kernel-patches/bpf/actions/runs/37736351874
> 
> Nice that it caught it!
> 
> Is there a way to automatically notify patch author that when it happens? Does
> it bisect, etc. or just green/red?

For linux-next it's just green/red now.

We've added it to have an "upstream merge will break bpf" signal,
because it happened regularly.

For bpf list we run on every incoming patch, so regressions are detected
quickly. Not feasible to do that for *every* upstream patch, we'd need
much more compute.

An auto-bisection is something I thought about, but never got to it.
These days with LLMs this may be easier to set up though.

> 
> --
> Cheers, Lorenzo


