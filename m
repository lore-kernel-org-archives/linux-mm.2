Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01EAACD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F2EE6B008C; Wed, 27 May 2026 07:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3AF6B0092; Wed, 27 May 2026 07:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BA016B0093; Wed, 27 May 2026 07:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0516B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:45:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA760161A2F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:45:01 +0000 (UTC)
X-FDA: 84813018402.22.3D17F36
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9A07C140008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:44:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KWwKGZre;
	spf=pass (imf09.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779882300; a=rsa-sha256;
	cv=none;
	b=LKR6t/PYeN+rjfSqSGxgQsnd8Unbjl4vTTw+aLzySsoT4JwB4wC8d9WUqt6N0LsReMdcC7
	PP5ODlFEYXeFKeP5QQnRvDjn0P7FeuNBtjUqC89a6KDaWL+Ry4tLDef8rThtXj3ffH/vxL
	f3sx+KbubCkXOceDnJeGQOdkCGe9JEs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KWwKGZre;
	spf=pass (imf09.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779882300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUB0kHUhBy3ng5DetQ30N4vUPE1VonqsLOG2jbmUYA0=;
	b=WEYt7zymol/YZQcvhLdLUq3N423upODZshYs2DVTI/nLXP1yBgPdN48Cl3OCPWydfTrMTg
	aMjckUPF9k3DOxexLeapKGjXrGQpButithLfowJa4cQC6zjFOul6lNn/mJDMEZ4eeGDjQY
	Y8t75Dk2e9alvZRB5Y/5UnipbBw9ElQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779882295; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=oUB0kHUhBy3ng5DetQ30N4vUPE1VonqsLOG2jbmUYA0=;
	b=KWwKGZreojKOhur/byN710zgQUAeEcVHDS8delAwewiY17gUqIbgVdKuZ98YzDUtOdwp3dV8xQxOf1ITwYMy7Y19hdO8/NlTtECJ/uaHDRRyOGBycEe6lKsLFTbkCIw6vUxFd96TnHj2bw8aLpL1f3upJ7+qUtsssjISHYRYua0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=xueshuai@linux.alibaba.com;NM=1;PH=DS;RN=29;SR=0;TI=SMTPD_---0X3jezDI_1779882292;
Received: from 30.246.179.14(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0X3jezDI_1779882292 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 27 May 2026 19:44:53 +0800
Message-ID: <8ebf43de-16c1-4798-8d48-c93390ab6df0@linux.alibaba.com>
Date: Wed, 27 May 2026 19:44:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 4/8] mm/hwpoison: return -EFAULT when copy fail in
 copy_mc_[user]_highpage()
To: Ruidong Tian <tianruidong@linux.alibaba.com>, catalin.marinas@arm.com,
 will@kernel.org, rafael@kernel.org, tony.luck@intel.com,
 guohanjun@huawei.com, mchehab@kernel.org, tongtiangen@huawei.com,
 james.morse@arm.com, robin.murphy@arm.com, andreyknvl@gmail.com,
 dvyukov@google.com, vincenzo.frascino@arm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, ryabinin.a.a@gmail.com, glider@google.com,
 christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
 naveen.n.rao@linux.ibm.com, tglx@linutronix.de, mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
References: <20260518084956.2538442-1-tianruidong@linux.alibaba.com>
 <20260518084956.2538442-5-tianruidong@linux.alibaba.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <20260518084956.2538442-5-tianruidong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A07C140008
X-Rspamd-Server: rspam03
X-Stat-Signature: 54h8n65rfbiifrazmedm33kyatddqew6
X-HE-Tag: 1779882298-37448
X-HE-Meta: U2FsdGVkX1/V4Cw2P3RGqRodll0T8oyGY7TAJ4GxE5u0t4VlXdmfyRcbjFeVTDmu/zilvfbsxer6R3fSFMRlBi2KMbdF2wOCCwY70RWMlFyTd1SWygDDOjUTvmdGR+uGxDJJWhJyd/9+f2NCJa852i6taEZ7wrvnP8AC/GsXILnnepXj6GIXlE/jhuFD0UvTWoWZXDDbNNBViwibHZ0XtLxRaZ7Qagm2LWFog9x69snFB1bysJ4sSTjHqszzJPP9bbWU5i19/xVubg4T3UP4Gy5XwapBI0FUyVKW3lGhVXQAOY5+nFE8TzXypLQq++h4JJIezOSSRkSKEdZ7COk/Z+DSXU4Cjz7dfUd1ByLyyds0sipWJ+NVXu8Y5QAeAePitBl7AGaKmwa/hTbcVukvS0neyvLin6wpzfWKjZVvorxGKgvXFQ86zBWcgXb7gu1nmUta59lRaPk3mcHsSNzfcHBDsXdm4DqOpMnFDFUjX+qX/VhC50LbWZYfGPEMjLfisroC6JVMkdgF+1+qj0BAPrhh34sonY8qrz/9S0i2ykjLu6T7RlIlaT8HUNxZCAteX/rKcTA+mECTbwg7urPG7bgagWFnaD/hyZATMb6UnYRu1U/qYqFe4KIh6chRTE+BfR7PFKFiUYQ+BqdoEb/4gMw4x9auiF2r8+QaBWd+BbEDqvAR4f82/zQ1jglTr/6lIknDlqaVk6Y26KZU1pJx8DFjALqTDSvH743fu00dRAdF2gJo+hjCevkNP5/+2xDSDSTt0YTXsyG+l7XStg/X19j+c7iXZ+ozv78EPbeQ2yBoimQUaMfIECckkRR0gE1w8hkVbFL83vjEAmEtWF1zrMMoGW5y1u+sDCvYci9MqNwx+YKx16/16cPBAC2MWU75Yw0UAdET6E+JMNfBF1YxG6XLhExP2xSJMzdQUQgN4qpl2VqN+Fn2TG26yVR1j+1NrjVQdwEOUI5D21eFxGW
 BvCYogtS
 p3aZFMmn4MbJ16SL5Sc7slzMwyB1fDScPhVEikIg+WINFMW+0v9xo40xvIAOsJqhP36v+G2ocvIgqxJXcbgk6aILhJnuCXt8RHQq+p/N/0qLdmmHDYA5z1fmzpy5Q9uvYslsEq907CuvWfYe89dYNTNw07SzKScMd3PuqiHT6t8d6qycOpgS6M78NW4MK5vFqMbo8+DOpjxiNcE40CZWX349cqCoBMPiydc5KK4Uaam8JNO6h/1oGPIKoTd2yQ5nxXVRM6DqnWWgzARePDtwl9WO9TGRfcM8fL7yOAGriDQ1OmuMpZjF/yqKa5+5fJT4q+YatipjK3/ZNbe+nD8K7fZdMs1BoyyA9gq1fyt3uknZWGfCUMMKPQyPY+zg5MR+ix2mUhH7n3xW/EJ17SaqN79f45OnkgmvPxJzvFIIeOU89qxPCyrWM/JECNFbC3Uzy75jmPuJnwK8OAa+1xHeYTxz7KZPT4rBslrkG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/18/26 4:49 PM, Ruidong Tian wrote:
> From: Tong Tiangen <tongtiangen@huawei.com>
> 
> Currently, copy_mc_[user]_highpage() returns zero on success, or in case
> of failures, the number of bytes that weren't copied.
> 
> While tracking the number of not copied works fine for x86 and PPC, There
> are some difficulties in doing the same thing on ARM64 because there is no
> available caller-saved register in copy_page()(lib/copy_page.S) to save
> "bytes not copied", and the following copy_mc_page() will also encounter
> the same problem.
> 
> Consider the caller of copy_mc_[user]_highpage() cannot do any processing
> on the remaining data(The page has hardware errors), they only check if
> copy was succeeded or not, make the interface more generic by using an
> error code when copy fails (-EFAULT) or return zero on success.
> 
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>
Thanks.
Shuai

