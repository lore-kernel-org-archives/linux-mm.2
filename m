Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259F0CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 11:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2AA6B0088; Wed, 20 May 2026 07:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9D76B008A; Wed, 20 May 2026 07:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6966B008C; Wed, 20 May 2026 07:53:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62D986B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:53:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2E04C13F5
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:53:38 +0000 (UTC)
X-FDA: 84787638516.07.D35C0B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3A2CE160009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:53:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="idZM0bE/";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779278017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmdRx/OdrSP1/4dyRKCY69ICjkv+Bj8XRKzIDVfemGg=;
	b=wgwtX/zGRaf9W1q18SzRJMDGcjASiqeI/yzR5UELUNWZoPzuQflH5xsYjHaKKu+CLswERz
	xgTGcwcyxjWM0CGgDWCPPahkiLw+hEJSPvF9Ob1zTe9mOQLzL0HO2BpwzWgr+T6RQRGK69
	ji599YHiqLXPmZ+31Y6YBhvKrJTofu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779278017; a=rsa-sha256;
	cv=none;
	b=Hqv5lY0h9ItQIUMJ4vvIreW0Jvv61boS7lf5/U/u8b8SuhyxGx4u0mI1z9qIJOx+KLN8hy
	9jvfjtLVkdXZDlPHqg4xfKpdK6sx/8J/nGKwpEEJNyDN2Wx4RiAltEEs8GVz6c88jH/HG9
	XZ1euIWiYYOhA/+Gm6G0CQGkMlKzaJQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="idZM0bE/";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9983660121;
	Wed, 20 May 2026 11:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41A41F00893;
	Wed, 20 May 2026 11:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779278016;
	bh=UmdRx/OdrSP1/4dyRKCY69ICjkv+Bj8XRKzIDVfemGg=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=idZM0bE/7jeP+u7JHgjwOgmxfkB4wUoX7W//ziKz42bvT7Nrpd57hJfG7jV2AkVtc
	 ntHxYjunwe6sK9F/VXw+e2DcE0aK29qNs6dxuJdNUC0SQMee25BoGkTD++kwd/pjlT
	 D0e+bHGokGLTw/+u7pQ4agLn/0rPFlq+sdaeqqm4UW4y2r1FUEh5XcLDYqFK37mTj4
	 g2fm1MjLKDSs1jJ5HtAsXeYZ0MT0zEoZ9q/g+J0H3h3H5OFMN9GkNzpI3xlQ/gkhez
	 yiZigo0A6qrN/vDGddrYPt3bUYn7bxx5yQcG51HcI0iFLOieT5RXU5fAh7IeGYAe3/
	 aBoKdRfY56Iww==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 5/7] mm/vmalloc: map contiguous pages in batches for
 vmap() if possible
From: Mike Rapoport <rppt@kernel.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org, 
 urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com, 
 dev.jain@arm.com, rppt@kernel.org, david@kernel.org, ryan.roberts@arm.com, 
 anshuman.khandual@arm.com, ajd@linux.ibm.com, linux-kernel@vger.kernel.org, 
 Wen Jiang <jiangwen6@xiaomi.com>
In-Reply-To: <20260514094108.2016201-6-jiangwen6@xiaomi.com>
References: <20260514094108.2016201-1-jiangwen6@xiaomi.com>
 <20260514094108.2016201-6-jiangwen6@xiaomi.com>
Date: Wed, 20 May 2026 14:53:16 +0300
Message-Id: <177927799626.3551615.13339231881249812474.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=540; i=rppt@kernel.org;
 h=from:subject:message-id; bh=bLYkbD2AcHPKVqpNELHBVm4UX2ClXw9oXOGt8n5E6Yw=;
 b=kA0DAAoBOQOGJssO/ZEByyZiAGoNoLSjfl2bUlyBf32591rxxL4PnRAQCLMN4ZCiDoV+N6WkI
 okBMwQAAQoAHRYhBHjlWFWlmS+fdNGv6TkDhibLDv2RBQJqDaC0AAoJEDkDhibLDv2RZF4H/1AS
 Irra0SwiZ690MYluiEqMdTFz8pq4s4d4caaWf5YL0fuyEUZJrmKaWVz24kXscZL7yRNYrks+9fL
 Gc2UOa/HWUj4DoVbTae7PdfggIki328ofVlz9KiJyyPt/3JlrQzc/6jOTkXHMAC/IXilk+KeZw2
 9z0vDoywOS/Jo31fqDj4jOSl3iH753qG2CSkNmMWYlxAvwuJsOOrRbIPGbsoKn5/IFHPMkegaAJ
 gF+AbdJgTi3vvNc7Id7LNHcoTXkDHOR2lcFgxTGEgPrJQo5HYX4y7bjMeovGyJ8Gjbsf8bOKL3C
 fgYuyU0EuoDkkz6uhIswXbAMuJDzIFbSiWZZFGc=
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A2CE160009
X-Stat-Signature: xmd95hasfpbwj479u849dks3ea899gja
X-Rspam-User: 
X-HE-Tag: 1779278017-540930
X-HE-Meta: U2FsdGVkX1+74Pkq/6pRb8f7WEJcZ5iDnxthkXIc0JhYLn3csQF175C3cRnV6N6a6dLgt0F8niusBvvKynRKUytSc6YYVYWOndjuKNmqII3tyLNm8k8Gs1eAAQGasdYVZ4qAk8u+0P15FidDzXgxZEkj6onljZ3B5ALeMQsgkQ3c/+39JEcNJdwpexgFIPzyM388wX/Afrv1E0wpaQUSKEI5O6JZQqwMmT4CL7DRjl7clUNmNN4yf7EAmIijzvZ31OYjEvqfbqdZ9NFTFk+qrGZodk7xC8MJaHgNtLuAoja3jKw3Mo/9zD26A/oeCC+noNoG431fWW6X124YCwmJG4XrbZdIm7P0UswEH8hL1z2nEaHQcEGGdGTX7l77NvJLoTdxMJwb/hUWa0PRe8BkK097cl1ra6i/lxRw7M9za1XGnIOXBWdyW1XI0zoEEKzGXV56hdgrP2+HqJ1QuylAN5gY5mmE0q6CaDE2efzoZsPjRyw/yfSevOeZMQJZy4jKs8xd4Z4HKLmHfXZmmHwB5ldpBhvasS822idQj9HkzCzgAXuBFNmo2EHAh5Fok4yqcbpF6PDXwqp84Fin3TZgslR4fnjlKZrSs6fIr7xpKejLYW4H7wZC9viwXmKbIdjeuEFggQbxvwI6lgAqzFRYypHmYGM+mf7iFRf0+Zu5w2Epc9KPf60/82F08lSa7Mwt/Bf1uzYhPOnyBHi0E0ZWmG4N1DPPtpgKZebIWJgLbEGoopM4qrNxIQZ17yoJdFafC2OKdlUwnDcztvfscFbfPMgQYEPmpb9P3nyUJLS1f5omqJOe7HPA+NGPqMay/PfV9sqWFl3vWFcCI+pxzKwKDc2vhBCQLqoNWOEJbCTdKQovQw+CpPzkaO+xj9t6Pc5hJlJh7N7KW8mIjn5RNioKDi5iN/IBv7ka8klwFnUdjng5DE5wCJKdncUHB+eGykwE8I9kyO0IYk+oB3SSKTA
 Nn4U/T0O
 mMVz8ugCLp5XmD8OJfq98S8MGe5isDCaziKLtSODroV1L4uuzJJt4/14IC+LGBagVLF6I17SDCJ6krG1C0Aa7epF7mwJhFNmrvpppg1P9EU9D6hNGV1zudjmmnUnHcpyuz2xOaQVe89PVr08KOfL/f/Y/sQHQqOz3Exi6bppgDSRyPq3xy8hSk5cj0+MLrxNJKc1l2uKUVIKYgRqWYX16DQopPVaf/shezG6yP49VJZR/Tm70MeOdLbGdvxhBpdm6A8xQHYdM+Dott7R0rEkANBeqkO4on0Jb32muM/CLDK0H/xQTtZ8EyNVLSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 17:41:06 +0800, Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 516d406507e9..c30a7673e0ac 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3520,6 +3520,77 @@ void vunmap(const void *addr)
> [ ... skip 25 lines ... ]
> +
> +	return order;
> +}
> +
> +static int __vmap_huge(unsigned long addr, unsigned long end,
> +		pgprot_t prot, struct page **pages)

This won't necessaryly create huge mappings, maybe vmap_batched?

-- 
Sincerely yours,
Mike.


