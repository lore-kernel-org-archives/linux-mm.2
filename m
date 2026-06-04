Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF029CD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF826B0092; Thu,  4 Jun 2026 07:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6B46B0093; Thu,  4 Jun 2026 07:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ECE06B0095; Thu,  4 Jun 2026 07:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EC426B0092
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:04:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFEE11C1422
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:04:40 +0000 (UTC)
X-FDA: 84841947120.05.4BA572B
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf21.hostedemail.com (Postfix) with ESMTP id 03B9C1C0018
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:04:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="U N8fj7r";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kHkU6uCX;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780571079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9Guk1v6UCqcbYZsqfj0527/CdsZdpy+8usy0jwjfTw=;
	b=YzK782ZdjwPBK7e89clkH7vBRDzdzCSjaVcRVPOzdcGHUZOu4r4xyTN4DMFf3rhNR+WvUf
	uFOS8sIHhrNzOx17aJCxj8Jds/TL+uxeiYG84HePW+fGCsrvvJGiUik7cGWmhrt+82EV+i
	dyI8klJfwLYe/NK1Q5PmEHdMLLPp/i0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="U N8fj7r";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=kHkU6uCX;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780571079;
	b=HszMJQf/yDdgc6na6Petr6jv1JKvndHLpXhTmz5IK0gGrEtNvAVaeFW1cTmW47RwnG5CDl
	LXqCrtNagrlfRVBohvXkmF0bQlXd70hzxii4ScD6+LqzRxa+Ck+tTMDh2o5DgBibC5rC+k
	6PCl7MM25qIeqaJtAS9D48jnbHljN6M=
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.phl.internal (Postfix) with ESMTP id 4A08B1380154;
	Thu,  4 Jun 2026 07:04:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Thu, 04 Jun 2026 07:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1780571078; x=
	1780578278; bh=+9Guk1v6UCqcbYZsqfj0527/CdsZdpy+8usy0jwjfTw=; b=U
	N8fj7r9HNdENn3fljE7rLtleY7XVbGsqBvc3itSmLb6ul3E2mJOFvb+SsQJrMYaD
	vuhy/2bqu4MUD7RPwOafy2goW9KrD/9dV9HbVbIw82hH91amdxFv0D5DCwZJBnQp
	8FyxDfAJIWdCXzJMWkq41jM9y0e68ibr0yUu6AwvXeUQjeJl7IjXNBylH9lhVHx3
	ke3WrlUYmI/GFXxNHXt0to50J+cWI3LCl3ixsPTzUjGWN37hYzoXH5BI4y6UECR7
	eMPHzJHK5r5/whA1ySLkSZ2vCnGV4BLW+y3oXQEQsumfbSk0IgWtPktW+vmQXH/Q
	Pbz/KiDxYd123LhscxcVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1780571078; x=1780578278; bh=+9Guk1v6UCqcbYZsqfj0527/CdsZdpy+8us
	y0jwjfTw=; b=kHkU6uCXyVwnOSfyicVgiL98Zy1Mzr7HcLims8y3A3ymhcjPGpt
	pU6W2Rl/cuaZ74Gg9AjSbUHdytPNb7gugHHoBqVds/5fd9XsReu5TF9eSWcQeto/
	Q9ezekyQd45w/jtXHNLF4iYb6m+CeX3cgNPRDUrAuVg0kIjsnwS03LDLlsTn0lX/
	zQxSRw1RzCSaoQJf9ikzRJp3nkWDRmOnRgh1KTM5fOw69jbFkn0AJZI511GDyM3o
	vAkWe87UyMUC6KFdq2Q4tyVtHFL5taP/bcR3gG3DHn58vhl8UWPdIkLV/m0d74ft
	g5yoQjeRtqTDbXqJE57/sKJaZDfuzoEe9kA==
X-ME-Sender: <xms:xFshaoOPXNWTozIsfycI2bzP_z-RwNoc8JSx0DKdNLCNxh_WSObnxg>
    <xme:xFshaoDijg3dqf8LsVhlQJ_e4MoqWAzKS1WSLbrQjSW3lCfpuqHqBOQwqNZkwePC1
    eGOG7aTUvQGHqk8ecz1sHMdzcDqF2KfjWYjO426jh4P9hLlHnbfG4Qv>
X-ME-Received: <xmr:xFshaiOH9uWkm-uMGwidrC1L871JS1bPQI8ssKkhjWXGfgrfv4rFQkt-EHO79g>
X-ME-Proxy-Cause: dmFkZTFr7QY4Bhqerzvha2I0LMExUdgcQI1Pil8VbJFkYBwNmGuMv7KaM8ber1k+HdlcAG
    1s5+QrPd4KwJEjqFsISpo4w+LkK5jrKBiwoDgOJtaDO3dj81Zq2H3GQGLNawialwaf7srz
    3zVJoZYR1HEyHypVh27Ahm7mTIJRTosEyIpn7neBAKhOkauj1wMopJz34cjlvypisv7e0k
    7Jfoh878GmndHrULSK3KHkC3q/9kEkSCZ4CZyerIPyuiDxEvEdWJHVzMyQEpThTfPvbomQ
    TybmSQsniqdHboagZX5srV5ADMe5dQs/fA8IYav29U2QBvCT8kcZKy/pXHbJ3kzUYYTnba
    oBgpyxK82g3Hn/mMVcx1+RRNjatLwQnPZ4jTKnkC2q2yCB9xDV+nWXGMnv0RpRaDUnMDNz
    v1uhbJpYq8FBu2H4dMsekHF1CjTJ/m6x9Q46iP6hgokaoFC044lPuz+qg9lFC/+RE4ysBj
    KreHfPHLR3uMZvPye70tETzN7i7YKOO4KFFHnnQMvp5L0XEHnSAQkLf1cJ/Ma4UaSAIcmA
    X6UmeIixFCc9YKL9Lwg+jJezQFL8HAYsHvEoPKC87VHtpvz4nDOezrWLibwhV624pMvvko
    qcT7FHMjjiCFyA+7CWABWmdadTTcNjFEdtnZbX9yWsY+BGXy1jGFw92jRMow
X-ME-Proxy: <xmx:xFshatwLU7jBZRPW2SrYzxg-C-HZ6Iuhyqr75j4jBYJ3EIU1DDjc1g>
    <xmx:xFshatc5fZeoNi8tJsRuHxeaFfTgO6txytoFoOPKyBZ2cgdKxYFpHg>
    <xmx:xFshag00HPPdbK3j2zyTDffKlafc9mWz9RtDelizIfSaHqWCK8VTqQ>
    <xmx:xFshaumMmVFAbBMSGmBpNl6GLC-0W02GI1oBjsHVdTI0HJCqLuFw0A>
    <xmx:xlshasNx9iMhkb7lAzQlUmrPcn-_ykuAdM-kySpr5Tlv196TFi9h7TCX>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 4 Jun 2026 07:04:35 -0400 (EDT)
Date: Thu, 4 Jun 2026 12:04:34 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: ilya.gladyshev@linux.dev
Cc: ivgorbunov@me.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, 
	david@kernel.org, foxido@foxido.dev, harry.yoo@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, rppt@kernel.org, surenb@google.com, torvalds@linuxfoundation.org, 
	vbabka@suse.cz, willy@infradead.org, yuzhao@google.com, ziy@nvidia.com, 
	pfalcato@suse.de
Subject: Re: [PATCH v3 1/2] mm: drop page refcount zero state semantics
Message-ID: <aiFZ57eRrCcWmS6E@thinkstation>
References: <5dabf3a748fee0c7b142c74367e7586f5db1ed1e@linux.dev>
 <7c28d766b007345f5f31ba9a086a3bffe95a013d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c28d766b007345f5f31ba9a086a3bffe95a013d@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 03B9C1C0018
X-Stat-Signature: xry68xan3xn846w39e9ycm9bcg7phto1
X-HE-Tag: 1780571078-538170
X-HE-Meta: U2FsdGVkX19XJ70wcmnDnF0mIWd+fe1GdQUApGlW2AOctyhOhutqeFrLfxb2gFVoZttMQreyPW1sBpUi5VlglEmFVnCEr9Rvl8QAwBo8cxU3bDi4QLymONuoLrbOmSiw+Suy2xxhS5FxDR8WlEpbyARiy2vMkszm+FACmZ46LvcjV56+wAEl27fT4o+BDCHo79qCROZb9SiXCAu7Jhddz4BEF8h+2JMfz+//HsLB4hhFV1nCUaHo7wKVZVfxmJj82PjfRTOPmu1kr2f9JSdH1TEWJMJzxaulvaWz1XrNHnFWvbvo08mK2U5cKqK2AmRmoVrPtn2QNVkAt41xFc0+mBNJ61LuVvxVkFfiJ3NEqvPWBOmGzjtkLaPrTDa6Qep5F+GriESgYoyFNM9bx+rEDE+OKQHWzbSORrXrdre1enDY3fSLW+vO01bVmVlsYoPAZI8o7d0b6K9RVtXEGmcba92QToYS+cLWMCDHdlLGV0yolsOU38TdR97ZfPZvNMnDPgjc2ZXuUmdXnJxPL68q5Y8wMcVw6ZjhaHB2/GqdJlYICsLbWsETQ96LE+aO2phi0fAmueWMu2JNNtF3Z7xNYmRsQ0VYkT9iqFQa9dlj841AL0iflGlICE2mVe6P1w8v4r3aIV6NhpvWCYlCUtdwsqvtA/9lZTPcOKiGhiczVdehseZ84hDzjYczYTResFhlhjfRVBIWk8KtcrWNLZwNZPMYfxmldDkUID22czFBQUXsflZjf4exArpxOFP+tMIp67+imQuqRV8L5qgiMGawbXQQGENwOh8uSBfj0sQ/ucdhGgA9h7DqeYF3FjCFNng2jvBWKV9jFLbO0TihDUkfhg1gU4w974nbqOz77Gsom5ZcWPTlNHdqa2pw64jmuI5oHuQ2T/vul3p1SWVE0gJGgW+lOtDl2mjcCIMGo/vcJM6T/ZspwjyFpI4y0PlJ0u3W8WCSewHf+ycipyIRMjU
 VvX0NPB2
 HWGZ97JL64h8q5BxIGJqTR64G6wSBd2X5Q8n66ffDWAXtJeo/nu2qhUSuCDMcFEUiQmtfnrJuU81dx0NaXPoo0bbgXUs3riJzuZ+p85dzAT58sxcMVQIm8HSi9cRzeaB0oMxXymlY6mKRpoKEVk6OHX+8LBSOiIbWZh3T0F+G8+2Nz+dxxTXu+PfX+ALguQ6wpJYTATcVBh3oL8NvJEf29LamkPnbpM3XYSaU8bsRECBVTJqNibAQQJg1WbSOqE67Nb2yw+4+3pF7VvshyvourWfCiHVkXIG1Ux0RYWnG19RItQUebOvSdB75aeKJAi2iXsLwvYIXoJvfQBwBTp4HztEFBNREssvy9rfwPTX/wO7KNkGNmxrZs4nW0+S0dAOmz4f/d8iHC3UnSku86aBOZ7dTubQ08ARCBjDKYEjzDjt8X5X9azKANGG2ST13eZslkia7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 10:15:12AM +0000, ilya.gladyshev@linux.dev wrote:
> @@ -115,8 +120,14 @@ static inline void init_page_count(struct page *page)
>  	set_page_count(page, 1);
>  }
>  
> +static inline void set_page_count_as_frozen(struct page *page)
> +{
> +	set_page_count(page, 0);
> +}
> +

This name is strange. Maybe something like init_page_count_frozen()?

And don't you want to update it in patch 2 to set the bit?

>  static inline void page_ref_add(struct page *page, int nr)
>  {
> +	VM_BUG_ON(__page_count_is_frozen(page_count(page)));

Hm. These VM_BUG_ONs are useless after patch 2.

In patch 2, you make __page_count_is_frozen() check the frozen bit and
page_count() masks out frozen bit.

I guess you want to read raw ref number here, no?

And why not VM_BUG_ON_PAGE/FOLIO()?


>  	atomic_add(nr, &page->_refcount);
>  	if (page_ref_tracepoint_active(page_ref_mod))
>  		__page_ref_mod(page, nr);

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

