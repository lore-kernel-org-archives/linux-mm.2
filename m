Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A05EB3625
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12076B0005; Mon,  2 Mar 2026 12:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBC966B0088; Mon,  2 Mar 2026 12:34:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC9D6B0089; Mon,  2 Mar 2026 12:34:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CC4466B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:34:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 998A3C0C3D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:34:07 +0000 (UTC)
X-FDA: 84501821334.04.0636A69
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 844B61A0019
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:34:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aKeWZJYZ;
	spf=pass (imf19.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772472845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aR7wBC+ansRdnpr2xRHWq+wiTXZewXFu6CEriISZqzI=;
	b=YBeP/XjIRn7TtdwBcr9OLahFHtMGm6XtAn4+ObkhuuBUyYemZqEqQEs6wdZEmHj/J9ttI2
	L2+qOPb9O4Apoh+Mzbe8nuLt66mtwYQ1v2nfVKIm7E6+0fcAlu9SmzSsZL13dIaJp+qqKf
	nWddQmPdgQBYhtixHErQkhQDwAsApVg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aKeWZJYZ;
	spf=pass (imf19.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772472845; a=rsa-sha256;
	cv=none;
	b=uHwhTjnqdWXf2FWvCMQyS3X17uQUOSSO6Zb9HCFpkZ6RGyTor9PxjjtImJBGY/dSZp1wLW
	xGhBqF4oj8tIFzm3BDSovDmNuzW8KWmcXgmU7EOhF844UVlZmD8V4hQu1C1DeCO/Hsgt7J
	oh0cgbdAjwIkJNVqkblTHv1NgC73QEI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772472844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aR7wBC+ansRdnpr2xRHWq+wiTXZewXFu6CEriISZqzI=;
	b=aKeWZJYZJPQw7agFCUuXWPmnnw5r2S6y8/rSC0ekZkb50IfIRlZZv1IYkJL/134Wl6Cr9t
	vLtOwSyLRJH+pqcTdTwDZjzaL10ZnNx3tDlBeX9u/MxDH32OlmcVyRuOoPt2lQTQ34QHot
	OPwpehRQBmlNuiAcRSlY4JtbvPoN2qI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-paCPR8LDPzGitr8yBq-Dwg-1; Mon,
 02 Mar 2026 12:34:01 -0500
X-MC-Unique: paCPR8LDPzGitr8yBq-Dwg-1
X-Mimecast-MFC-AGG-ID: paCPR8LDPzGitr8yBq-Dwg_1772472840
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E942019560A7;
	Mon,  2 Mar 2026 17:33:59 +0000 (UTC)
Received: from [10.45.224.173] (unknown [10.45.224.173])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8672D1800666;
	Mon,  2 Mar 2026 17:33:56 +0000 (UTC)
Date: Mon, 2 Mar 2026 18:33:53 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
cc: Christoph Hellwig <hch@infradead.org>, Michal Hocko <mhocko@suse.com>, 
    Uladzislau Rezki <urezki@gmail.com>, 
    "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, 
    SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
    zkabelac@redhat.com, Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org, 
    dm-devel@lists.linux.dev
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
In-Reply-To: <aZ2zPzyoFUUNWdJ7@linux.dev>
Message-ID: <5382696e-25e0-cd41-0a63-a79f019cb6ae@redhat.com>
References: <ff48283b-be21-7f9a-d616-e303a4a1ebe6@redhat.com> <aZykWyxLy34o7PKr@fedora> <32bd9bed-a939-69c4-696d-f7f9a5fe31d8@redhat.com> <aZzPwsBp-Z4XM58U@tiehlicka> <aZ2N9a4XgxnurOhz@pc636> <aZ2YDD_l5JN78DJC@tiehlicka> <aZ2voRA5VJytcfLp@infradead.org>
 <aZ2zPzyoFUUNWdJ7@linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: i00XQZu9gMJlagKTDbIiG30fz9bRjYKTVBSiGhHJBRQ_1772472840
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 844B61A0019
X-Stat-Signature: 1f3ynqp8ecnix4tgkf741e99ohrzq3mg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772472845-743058
X-HE-Meta: U2FsdGVkX19BMFgmNjb906jA6k8S1dfyrLZlYTTklTkhu5Zhhikb3EyJwax4AlNfN6/d1Grgl5F2+W39SSKSL9j9NEzg3VQNcbA/ok/bw6CGu+xQRkRe2JLF1H4CUTp1wHh4fn+OLWUfnH9G085x5rxAPBv49nWyhPLt7LZy0wkchBBuNonYsh5Hq61carPKNig3jFao+R9Qdx5PwFGW/D2Ky0ICkqbBM09rKX/1mGz/Z6SFlLT8XSDz7AC/N++xTVlec39O1uX5QmPEShLiwD//Fl1vkWcj/JcToTzsSLHCLnQ9UGgsUZ3g5TmANZ+mnFTJ4lsptCwLjniKYIJPHz5Wx6S3N4RjBSsr6miDZprYI1GQZfkqLbfpE0XBQiB76gHynDcMg0jo9J093PDbGM4/i8t/XKFfQN6EMi0flr6D425TEg/BJYrOcFBm1NkTfhuERfTnEEJjGsRW1/vNUv3t1kPO2WQfvVKwmClLTO+YjjrrpI0Ik8Pz2RnPk4PqxM2a7Uu21LNRHX9nGMIG+2uyV3x2DHj/RJyfsyzWJS20/lzN6BUbbsaIC1z/fv2N3bX07TuhqKT4EgvBJGWRDH1FTtZT+5NUWmU1vXsnELpdtd2BgaVeg9pKIAHUGl5hu3NCinpacxx7D/5mOj/BnprVefo9ZF5oN4NB33W6cGGSOrIg1FXaw1N1DJqUZF6FVyagaEqzVv5NFLMkNFhjh0zyafdlmzRUmq0UPA5tdXv+WzIybtevvsDv315jXa6M4HIVnOJklk9RIBcIwiy4HicE2bvFEHP5EttwE5Om318E1pV1+URKMD3UPGeS8g95zw/jDkDTqma2pTW0GX60C/09HXjFiBNVlys27h+Q0uRSLskOOriznICCiPIFO0nsOYPIlRKJDMJdW52BuExP/sbCRYclIU0nxC6mfdv+eIWH9UI9UYd5TVdT33Khj4epbeEMBfX2s6hMLDveaLw
 30H8dPB8
 h/p/171spujE8I6skjkGlE2Z6gAwaTPMD6R6uW+qMK2gCmsOS8oBZxGolw31PQNLldDaq8EOdV1YofAZfJgr6/7Hr5VLKIDweBzP6x8G80vOnVEsP445P/Ap9WWdXIboKPeHyvQ7+4Bi0WLlwXakxwYsMTRhV05yY+64kL0WY/nFJmjTOgMgJX2NZ4halDR3bLDIiZy75hYO852okOdNLeXYjG5J5g5mkkHozExt8Z5KnitCmjT0GdFNQqH93W2xX8gc2BasPy5f3jQlGmKHm33zOx8EB+lW4pwk5NwPBLbt9tw3H/rjagFb5YztPfq6Lie0EyIWMeRqLjOXa/LoTROKGCIzYcbsTKeNoNou7srl08fRnD1IfRrMiN+fQP7f2T4s9O+4A48ddt90PRmgJGBoSksW755lsvVoWWnZux6p3ck+Yxo0xZJkPIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, 24 Feb 2026, Shakeel Butt wrote:

> On Tue, Feb 24, 2026 at 06:03:13AM -0800, Christoph Hellwig wrote:
> > On Tue, Feb 24, 2026 at 01:22:36PM +0100, Michal Hocko wrote:
> > > One thing that we could do to improve __GFP_RETRY_MAYFAIL resp.
> > > __GFP_NORETRY is to use NOWAIT allocation semantic for page table
> > > allocations as those could be achieved by scoped allocation context.
> > > This could cause pre-mature failure after the whole bunch of memory has
> > > already been allocated for the backing pages but considering that page
> > > table allocations should be more and more rare over system runtime it
> > > might be just a reasonable workaround. WDYT?
> > 
> > Why bother?  __GFP_RETRY_MAYFAIL has pretty lose semantics.  Trying
> > too hard to allocate PTEs is not breaking the overall concept.
> > 
> 
> One thing __GFP_RETRY_MAYFAIL is very clear about is to not trigger the
> oom-killer which is not the case for GFP_KERNEL. There are users who explicitly
> use __GFP_RETRY_MAYFAIL to avoid oom-killer.
> 
> Mikulas, is that the reason you are using __GFP_RETRY_MAYFAIL in your use-case?

The VDO is deduplication storage driver - it needs to allocate large 
amounts of memory - for each disk block, it needs to store hash of the 
data in memory to be able to detect blocks with duplicate data.

If the VDO driver attempts to allocate more memory than what is available, 
we want the allocation to fail; we don't want to kill user processes.

Mikulas


