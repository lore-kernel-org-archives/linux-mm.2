Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06855C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4BA6B0088; Mon, 27 Jul 2026 13:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E876B008A; Mon, 27 Jul 2026 13:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CAF6B008C; Mon, 27 Jul 2026 13:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BCF56B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:04:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C22B11C00A3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:04:11 +0000 (UTC)
X-FDA: 85035179502.17.B756164
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0DD2E18000B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:04:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=H1z9+Tqo;
	spf=pass (imf16.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785171850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KuVSC8RadY+LK86Bwdw/4JgOl2/sK70FYFnSHTYlTgk=;
	b=TKFuU4OLPcWnbj858Hvxw/E3aD8PabMfM0JkIHazhwcelCQmLBNxTAGug4P5E+0ieLTj1r
	92OQo+tSfunCNB2Xyk0AF58nkKwNd/vYeNEkF0svhjB6agx9+ya5LQQA1IvEFlgTj9McU0
	OSsjg2GnGuU+aGbG9SnZG7k6iwDMJT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785171850;
	b=eijCScnzBio35rfaaFL4m0TkbtcEgbEI1OcK8ZMlZ1mTWyiN78NtedaaSvg+p6TZoeM/Ni
	74da4PiD7fOPkS9ZFyVvzYQAf4MFFIq4gqd+OJAzCbG6dcDFQ4lo9wyqycYArkQ9+im9oS
	9PwPrS7ceKmr7Y4dfcKNuPtLopRr1aU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=H1z9+Tqo;
	spf=pass (imf16.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3E96F408B2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1785171848; bh=KuVSC8RadY+LK86Bwdw/4JgOl2/sK70FYFnSHTYlTgk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=H1z9+TqoYuss7JjoQTGjCaRVPO0aDz8CHY6bp06sEg39a1jzsgRFiNb8/04tduQeN
	 fDW67ArT0WivAkcnHiJX1/ovInBmNT2LoDOOkJiXQ4jY+pME+GW0NSWsQ/P8We5n6e
	 R5y7dkVo9WbPsDICbaJFDVbQsEaRSKdFrnOyI+7OMVVx4/YHFmyvfjfHUaIFjt1hR+
	 vxCM134thZGB9jEEemPVsUyb+cxfjU8Y/Enl4PGDAUxRHmGcRNqeM6LOzUhZQLgwC3
	 SV+eusI42GzLDGkSMWbODTZxs80qM+c0SX2yowTKb6os53cl9ldWm32kh4OyQhWsIK
	 mWgShsoT4kYVQ==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 3E96F408B2;
	Mon, 27 Jul 2026 17:04:08 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Xavier Claude <contact@xavierclaude.be>, linux-doc@vger.kernel.org
Cc: Xavier Claude <contact@xavierclaude.be>, linux-mm@kvack.org
Subject: Re: [PATCH] docs: add example for psi info
In-Reply-To: <20260726134037.24412-1-contact@xavierclaude.be>
References: <20260726134037.24412-1-contact@xavierclaude.be>
Date: Mon, 27 Jul 2026 11:04:07 -0600
Message-ID: <87tspkicu0.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 0DD2E18000B
X-Stat-Signature: 7w4hwy3ohuts9wwc65kukyq5owqdp9s7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785171849-624017
X-HE-Meta: U2FsdGVkX18qm5qtKDX3RBSSd6uiKfn9HrfZcF+HBa9UtCeXDB1oPsXDgFnmNRSGEL9M3y2SSWjkYlZw9NutlFnq4FOqtc+YVMz9GAw11DrJrAH7KiIElON4HoOkmhfG5pHgmD+dzZb9fTpO7FsZWEqLmm1TxOmGuPxeYA7acDs4a6Ex6MalXnVACpcU58azmv/icPRhRjPXgm7txHJYcr5vFL+J/CUiIbgQ61Z5gg3zPU9aErMgdPraNTYkQdHediSZup1xywuHK6jgkWpfkDo1jofgNiY6z/QRZ92kfHNWGAskzNzEIH18tC8ehIhOP75DqO4SAgfEN1qBXSV6hmC1i/9sD8YVRMW9PRxEtwHgRYN+TCchHKWpY2QOhD4cy1IpK1I03nLyn72sA6b39Z0q+4eYAM1P8phFp6Hmc1DjVigoEH2UDMzjVZq/0PyK5eKbjevQM3ON1yuYBmu/D7OwT68dAP/cB9Dq/ZNBzTsyjGkJPeuj5Wdb3jPXUAAD6FaOMWYcrPu1v8ZdzFSr1adCfDh1hAkOcKwCZzNR9Zm4unLikVGJwOtQODdNWsTloWvgIbjY3ZnW0e7MkPIxD0x4Vwppw9HgY3Z37l2dCPy41Vgnos7WqdjBE6jimKfTjKMXaa3mT8+t8al5oVUeyN9VouE+heKDb7oklZepBZKuEsskcvLD5OQ1QfKf7g/2HkDK0pd7+gw/ZF0pajhvOm4t795m10ob4o/yNHog93EXVF+b0WPZWDyyO3FnpJ8Ih86F7fooSegWdCdzMqS3ziT0dhY+LxWwhKJukeRs9XRgNZfD7DXMb0xQVwgYKlClLGgBLlQSAdmyLH3ynybgI84tcnojlCaJrrmE0iip13SIRR8HbEh3G7/Q1MBAkVHIej/Z7J01yAJmANKjiigOUknxMBb2+5yv39kH1/OqqYFKZP6hKF87EJmT5rKQwiurygzn2dh2ju06J029EWL
 IEUN3tls
 0af0DyRYBBnLMnx3AxOhWk7VDFWV04C1xV+g/OMtEkKmlm6NVIUMmm7KXVv+48zeWbV1r/2UpVnOAYqdb9xY/+JndH8F9kW/5NIH8Wg9G2D4aZfhliiUfD3cBNtyZvUK3y7yIiC8pkmCYiD7+F1XyNUjOmP+/gehOqrHtHjR5vKlmCicwQ5s1/HbRosG8IoVGcqCMFTHR4IUIa5xgUz7WMIKL+ZMLwIaleXFANDR+AtAxuCVNQXXHryTqzkOBlR0lrfyS/UlrPEZISo9uRuRnoY58fJhUDixj3zx21qFOZhmCIa9mUexhdhUavVWvA3JauH1Ul+vbHqYNGlI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Xavier Claude <contact@xavierclaude.be> writes:

> Provide an non zero example with explanation of the values.
>
> Signed-off-by: Xavier Claude <contact@xavierclaude.be>
> ---
>  Documentation/accounting/psi.rst | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)

This may be a good change, but you really want the memory-management
developers to look at it...adding linux-mm in the hopes that might make
it happen.

Thanks,

jon

> diff --git a/Documentation/accounting/psi.rst b/Documentation/accounting/psi.rst
> index d455db3e5808..dadab65f872d 100644
> --- a/Documentation/accounting/psi.rst
> +++ b/Documentation/accounting/psi.rst
> @@ -64,6 +64,20 @@ as well as medium and long term trends. The total absolute stall time
>  spikes which wouldn't necessarily make a dent in the time averages,
>  or to average trends over custom time frames.
>  
> +For example, the following output::
> +
> +	some avg10=7.52 avg60=12.59 avg300=24.82 total=2128219913967
> +	full avg10=5.70 avg60=10.56 avg300=22.40 total=2014527537356
> +
> +This means that for the last 10 seconds, 5.7% of the time (so 0.5
> +seconds) was lost on cpu cycles because all the running processes where
> +waiting on the resource. On the same period, some tasks where not
> +schedulable during 7.5% of the time (so 750ms) because they were waiting
> +on the resource. But for a longer period of 300 seconds, we see that
> +more than 20% of the time (so 60 seconds) is wasted due to resource
> +contention. Moreover, since the total time wasted because tasks were
> +waiting on the resource is 2014527.5 seconds.
> +
>  Monitoring for pressure thresholds
>  ==================================
>  
> -- 
> 2.55.0

