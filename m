Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC6FC531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 10:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A946B00AE; Thu, 23 Jul 2026 06:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB2C6B00AF; Thu, 23 Jul 2026 06:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5A06B00B0; Thu, 23 Jul 2026 06:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFDB56B00AE
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 06:26:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6099A1A0457
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:26:54 +0000 (UTC)
X-FDA: 85019663148.29.AE1FA20
Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53C0A100005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:26:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ayIkWdbc;
	spf=pass (imf14.hostedemail.com: domain of gouhao@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784802412;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVb+x1eJeMDbnGatYezDXk3mRUPsqyFLA5zoJctRxBo=;
	b=ua+cTgUH161TUMucxEw5LR1q6dIsbFNjjz9tcGQmvdHDBeml19f5HisrykQBrteJJAepqp
	hd/abUfBebdiWq8joOMabaHY9Gl2foLVQiH1tzLypHi7uXI93tKK5UCuipFmtiFlFObXgK
	7eEhQHEFrnfDQmjgFsdHta0cCKzapY4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=ayIkWdbc;
	spf=pass (imf14.hostedemail.com: domain of gouhao@uniontech.com designates 54.207.19.206 as permitted sender) smtp.mailfrom=gouhao@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784802412;
	b=M/BSwAN1ZnSxRueMo0mDCFByKVrHvEuS5x5WHFPSHDTsqxoawXAV7XQU+R8e9ihmEhjiVW
	JBEM3dY9MfxQyM2vz2Xaz7LcLU2JpiJ/bar5t+V4DqA2Q4LPtPAN+6KC2A984OlZ6+mYW/
	Lbk61CYV4VwsFH0VLTfoFdz6D7ECy98=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784802402;
	bh=lVb+x1eJeMDbnGatYezDXk3mRUPsqyFLA5zoJctRxBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=ayIkWdbcS8JO9TRkwXNVvV2cMsNZ0/V1CHIycRnvvpQJ2sIEva0zrkTBdinJ062Hc
	 JY0IFEVk8Q0Lqf/FIT6Dxt+8OiAskya3/+9VYV+Mt7kWJlDMn1pkJv1K5kLrsNd27s
	 P9av69av7dEem/7DdCYc1Tna20zTcmNKmPBB83rg=
X-QQ-mid: zesmtpip4t1784802386t9c54a72f
X-QQ-Originating-IP: memIhR9gvQ4ZmW+tM9XGn6iEAQmEwf7u2uI7gKQx180=
Received: from [IPV6:240e:659:1b0:640::113:101 ( [localhost])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 18:26:22 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5317163867551177588
EX-QQ-RecipientCnt: 26
Content-Type: multipart/alternative;
 boundary="------------4HCosMQF2fkroIavSbgGnprv"
Message-ID: <2B4E356BD3ECC2A3+5e1ad5e2-b34a-4ccd-a11f-60957a20e7b5@uniontech.com>
Date: Thu, 23 Jul 2026 18:26:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] powerpc/xive: remove dead NULL check after GFP_NOFAIL
 allocation
To: Mukesh Kumar Chaurasiya <mkchauras@gmail.com>
Cc: maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
 chleroy@kernel.org, maarten.lankhorst@linux.intel.com, mripard@kernel.org,
 tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, bharat@chelsio.com,
 jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org, ynorov@nvidia.com,
 namcao@linutronix.de, sshegde@linux.ibm.com, nilay@linux.ibm.com,
 kees@kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, linux-mm@kvack.org, gouhaojake@163.com,
 kernel@uniontech.com
References: <20260723081813.176792-1-gouhao@uniontech.com>
 <20260723081813.176792-2-gouhao@uniontech.com>
 <amHgkkMT4nrWLSka@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
Reply-To: 20260723081813.176792-2-gouhao@uniontech.com
From: Gou Hao <gouhao@uniontech.com>
In-Reply-To: <amHgkkMT4nrWLSka@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com>
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpip:uniontech.com:qybglogicsvrgz:qybglogicsvrgz5b-2
X-QQ-XMAILINFO: MiiIZxVYHKtyBDx+D5bHAmbtn8grGwzQ35gLx0CbWpEw3ujXVkRUmP0k
	M1yxTahfQ70c0Y21c3k8c84EX63ZO1CrPvaKwU3KQgLQpqB+q0FfXYd7SSbqSuLncBx5M1p
	O8s5Gw44qym4i5gaI7NIi6fV+bWDK3Y6ndGT6GYS0qRSHi4VdEjA656RRMfckpYNGqaJ6Ct
	3Cd8aPzmSm/bv2pYcHijAtT5TMl12sDSAEdjdg6L/+Y05Ap76SAWMXUMRyr8j6+hSfqiLqK
	vXstOKEDfR24TgvCi1lezRQeRO5G/4Vox4re+htW2HdWCvyeeqnFsUzZYnwQQh/4YPXyh8y
	Fk3KMxx/VfBYczrbNO2suR5/R5SHalxOuxuleZfSuU748xnvDxrdbjgB3dA3tpA2fVuLLCw
	bMb4eKnudk5zfKzoWRJDrrs93TXYMwluzIWZSDMKzh1FzWwheHx8U+3f+0gKGqHI4liqIZO
	gJL42QL0iywC/uPKSK3nXuqxB+Mq0cayDUTmZ/ODanX+GBd99V9j5o7ZU851d0luZTLMl5e
	z4+UMTUXD7NfG8JZrUCCgsS9i2ujQtEPiOLPJCxrSV6DpcL+RPo4+O2uYtiVhZQH+w+5/pL
	odbsAVq71fX7dfmScfMPIHQ0HJv7TI6NifVipOFsteFwFjNDZXBYbXGeBGuUgzPGh0iuqLW
	8tyoyPR9nACwgeZsIETc9kUPBjY0n78hxUNB+erNlXQ3DatvVipDS8oEMYtn1j1Bc2eF5w/
	iCK2z95/fvKy4qSlUftzPASKL0RTPoEoi4LFTBZKs68Tf2p4MlV6A1CsQLZvExjXr70Z59i
	sYxz7x3LEK9NkKPOeKTRjTGu9XiCBhEAHSnI+b2UX6+jMKiBm0uEnvQFzYgE7I4heV7V7Gg
	NOSBVPzeBTZrIftWUSn7oL3OqcMm1YGvmZsgOPMicWUg8fys+0HGc5dicPReXBZCCquL6KB
	o6U3zXocSLAARRxY1xYhZ3QLwRhMa1vtDKWQGp7oNLttI73bKqXqs0C6b9nhqabt88VhPbY
	FEDa5PLEPj83qFgQMGGNBEYprayD1SqgQ66WaBIkto9FHlLOU6Tx4L9kXeLLU5UHQAm9Tz5
	rfE4qFTmp+2bKfneUmV8PBum/qECbbH2nGwDvWZj8uk+Z8SxuNgDAxJtb/VbC+Eag==
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53C0A100005
X-Stat-Signature: hs3c46we5ufzr485r1rqe7ewubhwtchr
X-HE-Tag: 1784802407-628773
X-HE-Meta: U2FsdGVkX1+xbkQ4idpp05sFOm49h1g4raT15X/mcuDeEPLGX5MyQHXzzhALs74ZQnPoJGxvtw16y39xE43NtUDtxidumuF9UavUPre2Cp6mEBv42JcwYBWSyT8UhcSAeAxvxArfVap4jXuA1h5prLv0HhYYjugEeSY0TNgk6jSgXG8pHwE/SZH0xgJdBY8L4Fmk7APDiFMxioCvpoRTx8xF10h6mxsYolyzvyR0WFBBtAqtOjL4Rb94NAgVOCdtk7+DZQgdXTJIwKkuT3FHlTiBGD0oA9LVshRQudBlHlFeg7uP5Ek5h+FUPKmjX/2ar3MNEn+K9sy8iWponMAH8bq4Rmv6A9SlpW63gZ5VKAOfuQrx5DU4apz/00f/HCLDL//ICkunXw3BrAOSlgs2AYqHmA4gn1cwi7hi9RNLj30l8ChP/8zsURlHIugz6fBIH38VUR0fCSSBj8SV5O9thBR3r/4FGn7mAPAPN35+1HigJBReFqwTC6NPS1PYhg12gwIVrZDV/qCa5StJBNi7X4PRMJO7aeu6VqGCMq5ZhQGM2eQws+ZElO39pv85UnYyo/Db7lX//GS0I2sFlWjFdQ/bcc2r9SrsTsDyfGTeHZYECC7f2+7KtarUCLtaIV9KwD+fakhJS0r+F3KXTtDNHzkYyvIoKc++CsChyP13gNWFEPLgeoewQjRcgiQ/4vzUt1hzwNI/z8e5GcTLaS2bsKKZ/Q93ZUp+Qb/IWb+L4wT2i2M42HujTMuSQYK9Glte5jR5xeSJv18eKb/J6AY4DIiFqn5zkZmvNKSgIM2tkSoHxldNjdwAGsEmIIr6h1aO5RrEJOIDJ56enX5KUoiMolJV5VaDLZ3RId4Sx5C/ZxxTjOXn+BYsAkXuZqaHo6y4bWYk5qyAxyyUYXdLKrF9KjYDIWjfx8SWP4oSYvgEGjMvmrDTi2mze5QwUlgjZCL79CyCMKHiMvd50b2dprP
 esTQVGKS
 UjCv7vB/N8yrJ6ZNF1smlQbu1Dxq5yY9T3T17+zhBqm2hFP97QYvSaLG7MXn7tZacNwBKdZdwwaEsMpAPspfO3byFK9N+UXzLniSHNkkJpASfbpZbpo1Eoyket8n4SULTSpRBH/9LUFcTgcQofZRZknpRVjp/6H358OjF5+WtMSYwn8SL7MAxkcsn/k1oEP6rD/MEiCVfvCmXhGc+47C5VLr/8KunhoBVNaUB0Oslmed0X2nn7gq/n7tQVrDZxXeMoGO3ffYJ//gXawGtKh/fMdjRA/ciLE4JaSEV3Kk54yxhwjvWCK5+m0JauKwJ2uJf/3LC7rTYU1rApdSFGd+lItLGVIhmE28C487Ppqu1UfuHCPJjK93QmEe3z0lNpF6I8RUf7LMtyFOh300bpLpEN0YNJ0H1bdBk3DnChcGbG7wS1qIOSNOTesEy4hMwQNaw0/1vFxvqdLQrWbWclY9xfecTK2t6ZVwiDodZAzvdJJX+XlF5fhzKs4ChBFGSXkfGXEAUnx1WvgbvmB5qXkZxW1qkNAyC0I3en1Q9ryKI+X/y7/hXj32m9XY7ScRfdkngJx9QKFnZH9m1xR/lRm5zCLJyFhZGx9brHOE2p2Ewgo+I/eWOzXaMY5ayzMEkZH8NxNc2A3QKd2/hOdv5+1jbmTA6kqRmqK66NGwBLYeZ3lTKNVYpDGiUZxLmIumyJsjnSA5u7fvB1C8vcU4L8Uu/fqieco3HDdqOEFYLrl0jZh5o3wsiukZNAqzRt+BHwwn8bRRrdA3vOwnHxDyfu/ToOLC8f2Gv7kTV0k/g+QXODYZ2zlBLq5skSriavKBtXiKIpKcb9z1TXqjioK6PwXvXiLCrY71dxrR2YjAb959dmp53uT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a multi-part message in MIME format.
--------------4HCosMQF2fkroIavSbgGnprv
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/26 17:37, Mukesh Kumar Chaurasiya wrote:
> On Thu, Jul 23, 2026 at 04:18:10PM +0800, Gou Hao wrote:
>> kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
>> subsequent NULL check is unreachable dead code. Remove it.
>>
>> Signed-off-by: Gou Hao<gouhao@uniontech.com>
>> ---
>>   arch/powerpc/sysdev/xive/common.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
>> index dadd1f46ec93..79d7854259cb 100644
>> --- a/arch/powerpc/sysdev/xive/common.c
>> +++ b/arch/powerpc/sysdev/xive/common.c
>> @@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
>>   
>>   	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
>>   				 GFP_KERNEL | __GFP_NOFAIL);
>> -	if (!xive_ipis)
>> -		goto out_free_domain;
> This will be an unused label after this.
>
> Regards,
> Mukesh

Thank you for the review. I will fix it in the next version.


thanks,

Gou Hao

>> -
>>   	for_each_node(node) {
>>   		struct xive_ipi_desc *xid = &xive_ipis[node];
>>   		struct xive_ipi_alloc_info info = { node };
>> -- 
>> 2.20.1
>>
--------------4HCosMQF2fkroIavSbgGnprv
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 7bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>
</p>
    <div class="moz-cite-prefix">On 7/23/26 17:37, Mukesh Kumar
      Chaurasiya wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:amHgkkMT4nrWLSka@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com">
      <pre wrap="" class="moz-quote-pre">On Thu, Jul 23, 2026 at 04:18:10PM +0800, Gou Hao wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">kzalloc_objs with the __GFP_NOFAIL flag will never return NULL, so the
subsequent NULL check is unreachable dead code. Remove it.

Signed-off-by: Gou Hao <a class="moz-txt-link-rfc2396E" href="mailto:gouhao@uniontech.com">&lt;gouhao@uniontech.com&gt;</a>
---
 arch/powerpc/sysdev/xive/common.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index dadd1f46ec93..79d7854259cb 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1134,9 +1134,6 @@ static int __init xive_init_ipis(void)
 
 	xive_ipis = kzalloc_objs(*xive_ipis, nr_node_ids,
 				 GFP_KERNEL | __GFP_NOFAIL);
-	if (!xive_ipis)
-		goto out_free_domain;
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">This will be an unused label after this.

Regards,
Mukesh</pre>
    </blockquote>
    <p
style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">
</p>
    <p
style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;">Thank you for the review. I will fix it in the next version.</p>
    <style type="text/css">p, li { white-space: pre-wrap; }</style><br>
    <p>thanks,</p>
    <p>Gou Hao</p>
    <blockquote type="cite"
cite="mid:amHgkkMT4nrWLSka@li-1a3e774c-28e4-11b2-a85c-acc9f2883e29.ibm.com">
      <pre wrap="" class="moz-quote-pre">
</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">-
 	for_each_node(node) {
 		struct xive_ipi_desc *xid = &amp;xive_ipis[node];
 		struct xive_ipi_alloc_info info = { node };
-- 
2.20.1

</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
</pre>
    </blockquote>
  </body>
</html>

--------------4HCosMQF2fkroIavSbgGnprv--

