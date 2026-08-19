Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2669CC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 06:53:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFE36B009E; Wed, 19 Aug 2026 02:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5870E6B009F; Wed, 19 Aug 2026 02:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C5246B00A0; Wed, 19 Aug 2026 02:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 294A46B009E
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:53:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B049040468
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:53:27 +0000 (UTC)
X-FDA: 85117102854.19.0932529
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA6FB140004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:53:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=p64A1sy9;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787122406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lzAsoZzCTTLLF8TDuvOBmBJ3kbpB3AYIk2ZZ0mfupw=;
	b=DJXjcdQn5pGNTN94K0fogr+ZT8rU5gQATkUIlsbjLMlud2exbk30UB2WNig5G92kJaanP5
	PiVVmlb1Cv34203YQNMo5NqDtm31lBM9RwlgoDQBjGA0UIMVP41KB5GHmqzfE2njxLAAqL
	Xqf0VDGtLE9o+7PQLr1x0sDPHIniJr8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=p64A1sy9;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787122406;
	b=uwzoxs5L6uIC4Nz20jIUV8AIYPUsViU11nN8lu8rbYBRTLFgsKmXUKlPCN+tzAcx9YscLX
	fYlc4xp3lmbXyEYrl31GLjvItlwaBDutiZS0Bcx+e/Ka0LaWnbtj10zJgVLTPgA23kj1Mp
	TzxIJxpIM4E57AC33N2WF9GVIhUEnPo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 05AE5601FB;
	Wed, 19 Aug 2026 06:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3516D1F000E9;
	Wed, 19 Aug 2026 06:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787122404;
	bh=4lzAsoZzCTTLLF8TDuvOBmBJ3kbpB3AYIk2ZZ0mfupw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=p64A1sy9bVqbVm8ugggzyrfMvDB55yIDJyurb1IiOEMSAB6pNPUJCmQ/ABIIS+oPr
	 JOjMwcVPl8pcMacNvNuUjiia7sRat9IEZVlAZ7cWOxX4lYvDj16xeAgEGxiVFtyTbc
	 S3CViW2+OwViKzQO73RrqYk0rxRkab1/7e2SpTnM=
Date: Wed, 19 Aug 2026 08:51:47 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ye Weihua <yeweihua4@huawei.com>
Cc: brauner@kernel.org, kees@kernel.org, cve@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] CVE-2026-74484: Fix introducing commit via .vulnerable
Message-ID: <2026081933-slum-washtub-fb91@gregkh>
References: <20260819030103.422702-1-yeweihua4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819030103.422702-1-yeweihua4@huawei.com>
X-Stat-Signature: 4eibdqi4hgejypnbnox7qtb35y9pjfkt
X-Rspamd-Queue-Id: DA6FB140004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787122405-705585
X-HE-Meta: U2FsdGVkX1/vhbtmHAudhV080s+TqD3K4edrpwB7tkbe3NXA1oB9yuR48mak4AD09ExdH0CWWP5olNghZzr1jXunf8+LXjNsOyeaGDaQbKpapjj8wa+IOBA/zd6VNoYus4UlJz8jrWRS/cBMcMJoh2GwuHGxoCCaJNDDjuOAWjC+SmWjokdx9npAwETROvSpw/pHMFOHm7fzSvebc4kqBGvu4zN/p7XLblSUnwWbiBiIxL+quGjKQFzxYe0K7TklIcxMFpEzUtVddgaqF/7b8z/tGBLFFhY3cmH8h0q70tpbZBiu/k/0vAD086syqiddtVXSRuO5JaRHWuVDtPw0tk/qCjAWPB4R3RaIykYfnbYISGsF3m2AY5oZGMcqQ/MBLuM4uNRw66ANr5CZveX8RXsg6MD2WvdiFq/Vn5bwBQE4ga6YjFh1pYNwpVz8r4bihli1Ph9OSrqWCbbvtSX08JX9antDktnq15SUkb5XNbFQw2m0bpdoXv9m5NMK3o0yZVfwuRlSNS0V+lqILB05iYxnN4Jh8fz7cG/Q1TXT5jWEEz0SZ9ZNuPA1sjkWbpdmPV0/+zUUGU8KszQuErdUF8BjoErJ0Dm3SankOWC/ah1TYl2Kl1kVGnMkErjm77TZeV0puzcafsSJnOjZpJQAZrxPIp3iIQnYaw7t9dFzdiUBQoTDmtWU7oWWZXpCKWmt/ekb0cC+U//r6DoUdKMu/QhSwxzhUC2MHdKRs/8cblA/aedBEJMKdxGYjRu+4u+jV4MdaR/HauajuqKp12EXMumCKsoHnx/mqcCxyoLfPaFaicoqr3eH1hvHZnWj/3Qchqg0ivnVUp9wP5ieaKMgT3SFcufDqkzG/xuT+LWkQ5ksycoVsicsj+OAfpApq134SJ3Sr70rpNhTsLgQvqX6XhlFeNSXFDvawhhnB0Zqw7kAVHnvWFJCjtGahdmE2qcJSDhe5A+xCwsr3a9VuLJ
 4BBVX0lc
 OnFhi+6Wbr+pE3jDJoEbAoRXdvK80xEnQXYBsg1ReG3L6j8Vv5P7YF/G/pnsVIVXG+pqUhQ5qLwEwVsdnAek2YoOT90NdRj9+Ztwfi41UFoP4uBDhmFcOOBQzf7jwLZpwiv7aXm/UTBXXQaSSr/XJ7XWI+bUQRkf5YdNlDkDXnvvQM+xscKGtd/yIrhgCbboyU+jhfuWDCojP3YSbLQOKZqATzvVyNEnlYwyURuSCRu6QPI7R9TY9YYpOc0h3W+ApVVxbmrH0PeBWDd3MouEF4irPNkLj0m/aqPTUm5ibHaumE+ocD9kNWu/n1kGQYmkO6HpWNRCJO2rUIe9IkDUSr+PY7q6ylQH2f5lsi/cdBaiuOYQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 03:01:03AM +0000, Ye Weihua wrote:
> The introduced tag of CVE-2026-74484 is 21ca59b365c0
> ("binfmt_misc: enable sandboxed mounts", v6.7), not 948b701a607f,
> because before sandboxed mounts an unprivileged user or container cannot
> trigger the self-referential DoS in a restricted namespace.
> 
> Signed-off-by: Ye Weihua <yeweihua4@huawei.com>
> ---
>  cve/published/2026/CVE-2026-74484.vulnerable | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 100644 cve/published/2026/CVE-2026-74484.vulnerable
> 
> diff --git a/cve/published/2026/CVE-2026-74484.vulnerable b/cve/published/2026/CVE-2026-74484.vulnerable
> new file mode 100644
> index 000000000..39fb39f38
> --- /dev/null
> +++ b/cve/published/2026/CVE-2026-74484.vulnerable
> @@ -0,0 +1 @@
> +21ca59b365c091d583f36ac753eaa8baf947be6f
> -- 
> 2.34.1
> 
> 

Thanks for this, now applied and pushed out the updated records as well.

greg k-h

