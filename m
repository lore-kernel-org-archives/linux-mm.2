Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E14CCCDB47F
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 05:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 992256B0088; Wed, 24 Jun 2026 01:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9442F6B008C; Wed, 24 Jun 2026 01:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B156B0092; Wed, 24 Jun 2026 01:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63F716B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 01:56:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1FB81669A2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:56:41 +0000 (UTC)
X-FDA: 84913747002.10.6E53393
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id DA03B20009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:56:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FoChaAaS;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782280600;
	b=yxpvnP5ncYe6hlmq4Q+7ugTrj/XQ2dJieBLkHOoLr1xVgHCGehLkNf+QVYkmLux+xoz7w4
	Nw3WF0OHT2S+9Ykna2Wgn2yWYKZIYCRZtlGQ9ADuGlaQUb++PPoboylhVwy5aAQJxA8dGs
	LLjrCeozmqg2Y8C5gA5u8KrPtto/b60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782280600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ijWaurZ18Sx6SXLxiKD8dCVm6hSjutFy/lKdsp1CTY=;
	b=qMHSWa7oFUSL/HQrFaTofuFlOe6nvcVfv+3YjQszzHyg1tFOqPHHMXNQYsqrXtvMlXrJlz
	UGcWsXDMwWxVNu/7/k8iQXa/x+FfoYi/W6kD/fhOF73t7s5iNPD9B25IwND994YOiDroyi
	TuuM2vuw7c4Mv49U/0zInjYKPIAgmoo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FoChaAaS;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782280596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/ijWaurZ18Sx6SXLxiKD8dCVm6hSjutFy/lKdsp1CTY=;
	b=FoChaAaSGpbsLWThiO/Cqw0MNafyNBYo8O3Pag1Dm59Won177Qxbmhge/H0D5Kv9FGJfMY
	4eL3p0v/vgoX3cqO9ocdc31Ah4g43sGkC+fSy7WZVvBvyOTW2dyX4TWvpZdkKk119T/XgY
	vyDoSl7sXw7EVj0Dur2kVNtScmc1Pts=
From: Lance Yang <lance.yang@linux.dev>
To: igorpetindev@gmail.com
Cc: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	akpm@linux-foundation.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 2/2] mm/memory-failure: remove redundant initialization for hw_memory_failure
Date: Wed, 24 Jun 2026 13:56:24 +0800
Message-Id: <20260624055624.7339-1-lance.yang@linux.dev>
In-Reply-To: <20260623114743.4565-3-igorpetindev@gmail.com>
References: <20260623114743.4565-3-igorpetindev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pafnz4ij3buw87b9u8r68qnixpu3irgt
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA03B20009
X-HE-Tag: 1782280599-959997
X-HE-Meta: U2FsdGVkX1+NWHxjIFDWsaJPa+tsiUqhvbOx9ioKtzlvXUsBqN2w2hQHPdAh7dKXryXyS2GDNKZ5vkWD3VqClw3E+XHDVf5TVeCy1hj0NL9q35zqo5jqyAIaXW9fBILMWnwBIufCLQLYUk63GBegqlPfeo9673MxXAN8US82I8W8uecgm9nbtqxR2UNG408Csyx2vKYOygQ/LhvJ0Qjs2Nvkt1zRErY3qjg4zKBoovz2av9fX9fE6ANryI00tqyyCuCZMG3pbdNROXiIWQNzyCWSiyqaWAfegmsE7M2JVztayDep7xyUUpYmzXYpr9rKB2Ve94gfljharFfKQm/2xMgDDhvS5+7PNFvFp32sCtX5Tc0giOt5vADYlYJjy1AQ4xuxuW+IfRM+5CSeWnkHt6EInMNSvKUNSfdKGMORxlsXOjCumkZqhgFrLzAaMrtVJMwIN1Bmdj1Soxy50f5yoMX4RueenxlcW8KQ+PI/XtOlD34DP7S1nKiRSIrSFNNGLp1qM6eWQ+Br6ETGWIs8K8sttzuXIOh3a/nailoYK5mLKdKmz3ueFhBDXV73TBjMfE2hwHuTSCQmaH3Tbhl+YztVmq5ZTfzdqXCeN/l/LDe69pH8EaAqy2unJ8RG7IAWKmT5DZ5i2kdjJrgrCa3W6H1DNbmHiXPyOttZnf7jX9DorKbC/6A0Y/ewoKoB7Y2LbU+9Zxkwu2R0RiYM6gYYwdcvZSH3SaDmHomvb4fo3K/c4wuYFyuEOVQsaKtAICzzdEhOYFHHqsK/cYxd5ODOz8XVrO6HsNY/+U28IDBkooJ8namrgK/TlD/UE5vsC481TZez+EJdWrc908+G3dF1VkfhE4qeKFNubVggGd/x0M9e0kzPOh+Lx1AqzOAGLIMDjmqIjRcfGO8bD0WfsgHVqjRJafLTPGUSOorAROBfIVtmj6l+wdINUavAb9XJod0HYRH5Q70XqcDjfekkSjQ
 KB7K/+xF
 kri/hKOmf4e9OR1mhUKTPxx+ZYbhE2VRYrEx2M4pdegjIzyPpuSezWxeHFyvgWja+y+cCs5byovNk/hT56914SjQa+V8aBke+0zXAGp84cNCgJJwcxbYRR1jsznsEYE97I8JRjGEeANAbflF3NAi30hSxbg+pj08X0yOnotfyuE1XL6H5wfcbB6nnzrre3w2d4SCwkOpji1j2b+KSMhJQQVn93B0E9pDxjPrIWYU04E7t28SyPM4Ajt1/Ik7NoXHaf9aRmKobHn4QCMJIkYqeQjRitmZ6W22L3L7m/QVu/8cqMj5MRWnPbxizG0nV847VSR77Nkkq9WpgAp9Ef3qtr1QaNNEJ+8g+HEnx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 23, 2026 at 02:47:43PM +0300, Igor Putko wrote:
>The static variable 'hw_memory_failure' is implicitly initialized
>to false. Remove the explicit initialization to follow the Linux
>kernel coding style.
>
>Signed-off-by: Igor Putko <igorpetindev@gmail.com>
>---

Thanks.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

