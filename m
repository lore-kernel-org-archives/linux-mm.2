Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CC11CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 14:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6686B009E; Thu, 27 Nov 2025 09:55:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E666B009F; Thu, 27 Nov 2025 09:55:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96B716B00A2; Thu, 27 Nov 2025 09:55:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B57B6B009E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:55:29 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4665B850F4
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:55:29 +0000 (UTC)
X-FDA: 84156685578.27.88207C8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id EF1B9100002
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 14:55:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=J7WljQI6;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764255327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=58WYeoWp+L034I9TYiz+ieCppakm+AyyWrLBMP+OM0A=;
	b=pVmyrjLTEuEptTAaTy0VFPDONx9ugJcAYAYCQVaaTNIkyByNlh2kFBEQZpwIZGnB9kCCeN
	G3aqY5nAvnAqlXhJaw5mBDAZJbtU+nGcqb7LUznnesF4pU/Y/tMgXs/NHgvO5B4+iEPwO0
	ktXtJwV7LZC11Mza9UhETvvX0t/tIBI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=J7WljQI6;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764255327; a=rsa-sha256;
	cv=none;
	b=VpXekmBdGuERObbuPtLguFBw/+SDXOT/fycGJV02wceeoBnPM/0pPkfB/vDUph8KhiDrsD
	AOp21z0eh82x/E+9qTmRVD2DqK4OynYMmi5YkIxe1n7+e7M7RYdrA+TWkB7yzK8rpoW+sl
	AuNnxDDJJHKcDzXTVDRRU7WlH5P5/Js=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=58WYeoWp+L034I9TYiz+ieCppakm+AyyWrLBMP+OM0A=; b=J7WljQI6KUNn+EFR6+1UQpkkcf
	g945pGaj0nuiFCTt/jREJ1RI0jT3fLpA5GPL9DsFKpQQskDHtAyC5cK+3xWxu60A1i1WTafjj6pUw
	EuQjqtvIxuPDusDWAaSgq0T3mpqMmCOYM0UuKFcmyykVb+b7J9c5j3ZuEE9e4yF1guMiJQYFq9uQi
	dR+CsEru2Pt/hvvx9bZxrRzY0ZA3ETAoJ1SFrqjtgv8WWShGIq0WqsCymYRkOjJ9Rx2zE+gNmGCsK
	wJ/OIBP+CKWBJ3SUk/Px0lrTg/W3lSuWqRKYtVw23FelO65F9b61rO3bFUl+SifJHiF+6SiEUNQMq
	Cwbdn31Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOdP1-0000000Bsna-0xik;
	Thu, 27 Nov 2025 14:55:23 +0000
Date: Thu, 27 Nov 2025 14:55:23 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: Jan Sokolowski <jan.sokolowski@intel.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/1] idr: do not create idr if new id would be
 outside given range
Message-ID: <aShmW2gMTyRwyC6m@casper.infradead.org>
References: <20251127092732.684959-1-jan.sokolowski@intel.com>
 <20251127092732.684959-2-jan.sokolowski@intel.com>
 <aShYJta2EHh1d8az@casper.infradead.org>
 <06dbd4f8-ef5f-458c-a8b4-8a8fb2a7877c@amd.com>
 <aShb9lLyR537WDNq@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aShb9lLyR537WDNq@casper.infradead.org>
X-Rspamd-Queue-Id: EF1B9100002
X-Rspamd-Server: rspam02
X-Stat-Signature: pteyb1ssjmoawgstwbrh6bjchxt5jhen
X-Rspam-User: 
X-HE-Tag: 1764255326-135322
X-HE-Meta: U2FsdGVkX198F3zhEml7Onq6nevTDlKsYAA66CNgr+krQC9lt+zXRjhL4LbG2l2Iwu/sLzN5P7+NghyGmy33PphRQyY4aEQzqJuAWGwHhhvlWp2LKxcVaCKuNRMtRAPKQ3tFiVmOnUxIcEpWWI3OjyrVjdhjmc6K/5bZARgk5M2OyDoOPkmegk0XbFQefyGH4+viWMqgv67V9HXBRrhYyEKgparGzB1X3kzAY9gIjuKEmqc1PlrMvd+fPE6Q0vYjdnzViW7ze3JwnTtFdPPWyblOhsrFr53pICNW25pLcVjl3EjaLJKIyuGUFVaZ5KbyQEx9bFIr03Fth7I00cU/1csQsb4wN/JKaAQN0i104o+eZh5QlPL3x5CHXb9d2mljz0wqnylgC9j4J04ONw5h9WHNNyF/s+J9MTzRBUurS6cesqwYLIz6sJDBajdVp4Vk2s2QyUvfH/6Q5Bo3Za2/avgofxMyRc9dhy+4/mTFhmSh9JDDin+CQY31TVWGr0YuQLylbCmzUgLc64Hj4c1ov6EPPtwGv6AoAzuRQRMLyXjnpf2IboGEo6GBUQk9crPkIT51hScxNwzNpBe9hczqFbhD6TzjzXKWD3kNAStH9xV0QlB1Q/YS+4CBD008MQioNw+MT4kmNiCkbINO/Hexr/cxdDLFwQJSQSqEr9B6T07kKe2Fm9fi9b5Zpg/XNzZr7rVzalsqhdkra3n3oKzbfyLTqR5+PV1p3vsYAM01nB7tawSQXDLu2OU3Qwel6LzhB/c9QLDVZ0CKnsA2xRxWg2EDTfX1ZzMoOjXRxx4U8Y087SsbUkFs/w6t1b4OHU4DhGX59w+8nuAa8SMsUPdSu9T1ZW86n9HvXin2UbtW2IVCYGanlZQm3NTg8ynJPVyBQ+w1q7oBm43k5Zrwa9Q287LlbenGw50KROzMhmeUtZl7UeTLW3Kup4KW2zdUZ9rNiRGspUMyBw25Q85Lzd8
 XXVL+MLO
 BYGtewRWkNHfggCs2bjl7KQTcirkl8/jLNJu1Fwz9f4orJfz29V95cvq580hwB0nCupOjVN4XF4/o9ZAJPsV9Yvf3u/xUg/PBJFIjLtJoWvNSsTRmnGjwGKM+Rq5K3u0bR/R9rByCFBYuSmXEGNukhu1vsp5Ibge/zyw7Vlmd3C9zbmwjg/NNXrWKZr0kzCxVxd11Vo7fYvpPLYZ4GZlVxHnsmIzRF8jdrDfzz43hbhfd/o8d15T7JIrHvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 02:11:02PM +0000, Matthew Wilcox wrote:
> Hm.  That's not what it does for me.  It gives me id == 1, which isn't
> correct!  I'll look into that, but it'd be helpful to know what
> combination of inputs gives us 2.

Oh, never mind, I see what's happening.

int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp)

        ret = idr_alloc_u32(idr, ptr, &id, end > 0 ? end - 1 : INT_MAX, gfp);
so it's passing 0 as 'max' to idr_alloc_u32() which does:

        slot = idr_get_free(&idr->idr_rt, &iter, gfp, max - base);

and max - base becomes -1 or rather ULONG_MAX, and so we'll literally
allocate any number.  If the first slot is full, we'll get back 1
and then add 'base' to it, giving 2.

Here's the new test-case:

+void idr_alloc2_test(void)
+{
+       int id;
+       struct idr idr = IDR_INIT_BASE(idr, 1);
+
+       id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+       assert(id == -ENOSPC);
+
+       id = idr_alloc(&idr, idr_alloc2_test, 1, 2, GFP_KERNEL);
+       assert(id == 1);
+
+       id = idr_alloc(&idr, idr_alloc2_test, 0, 1, GFP_KERNEL);
+       assert(id == -ENOSPC);
+
+       id = idr_alloc(&idr, idr_alloc2_test, 0, 2, GFP_KERNEL);
+       assert(id == -ENOSPC);
+
+       idr_destroy(&idr);
+}

and with this patch, it passes:

+++ b/lib/idr.c
@@ -40,6 +40,8 @@ int idr_alloc_u32(struct idr *idr, void *ptr, u32 *nextid,

        if (WARN_ON_ONCE(!(idr->idr_rt.xa_flags & ROOT_IS_IDR)))
                idr->idr_rt.xa_flags |= IDR_RT_MARKER;
+       if (max < base)
+               return -ENOSPC;

        id = (id < base) ? 0 : id - base;
        radix_tree_iter_init(&iter, id);


