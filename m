Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE87C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43FD6B0005; Mon, 13 Jul 2026 01:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AE16B0088; Mon, 13 Jul 2026 01:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A584A6B008A; Mon, 13 Jul 2026 01:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CFD46B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:45:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C06F1A0A81
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:45:13 +0000 (UTC)
X-FDA: 84982665306.06.81C7D8B
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf11.hostedemail.com (Postfix) with ESMTP id 64B8440006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:45:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783921511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oX7T7eBEB370JIUwuOyDtaIF+R8oXgOTPPlXzlzGkI4=;
	b=BNSAPJOv8I95o5GDROfSsA8tSJRVFfRMLdRI1Ig/ZwOuDH25oD/CdF5itBokyOFJlxc8KO
	Q3v6FJ5zbChvZsl738aV3Vpxyax2kDtoLHdX8mNbWc5infvifFi/PnUQhGk2P0nQ82xwmC
	CKShoRQ1yudDl68y6KS3+S8ORoPQ7Eg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783921511;
	b=LObNc50q1tVBq2qsH/oAVa779OJUlMKRDOccbnUtKS8sg994m+pg3LZ82FkgR4tfdEMFjT
	ywBEXPv9sDRHKgaIwIPNmgr9EObPoR653/U6tFXH+qOTUwZfN34kIeclQjydOeFqPZIPsc
	rKzkxbW5Weob04kU2gqdt8e5QBpwIX4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gzBGk2mFSz57HS2;
	Mon, 13 Jul 2026 13:45:02 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 66D5iqWe066853;
	Mon, 13 Jul 2026 13:44:52 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Jul 2026 13:44:54 +0800 (CST)
X-Zmail-TransId: 2afc6a547b56907-fc964
X-Mailer: Zmail v1.0
Message-ID: <202607131344540423N-vjn1y68X614fkeZemP@zte.com.cn>
In-Reply-To: <178368585772.363984.12871786869575753171.b4-review@b4>
References: 20260710131536564mY9CDv7aP2dKPiLFXbrBv@zte.com.cn,178368585772.363984.12871786869575753171.b4-review@b4
Date: Mon, 13 Jul 2026 13:44:54 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <ljs@kernel.org>, <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <ljs@kernel.org>, <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
        <baohua@kernel.org>, <lance.yang@linux.dev>, <usama.arif@linux.dev>,
        <chengming.zhou@linux.dev>, <qi.zheng@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <npache@redhat.com>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vbW1fc2xvdC5oOiBhZGQgYSBoZWxwZXIgZnVuY3Rpb24gbW1fc2xvdF9yZW1vdmU=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 66D5iqWe066853
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Mon, 13 Jul 2026 13:45:02 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A547B5E.000/4gzBGk2mFSz57HS2
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 64B8440006
X-Stat-Signature: koxogo11onfhji5pshcgrimzoues18pp
X-HE-Tag: 1783921510-850336
X-HE-Meta: U2FsdGVkX1+UiZtkwndDwjFUsgpXy1wsA33qdlE3nAFveRSznTaC3qvMqKST5XYcWdbK9FDV8mZSqtTzrqsJml5lNvd/QwYhQZXXCzbr7ECgE79T67E32CFpZ22fHwSIHpRXsG7pbPg5qcUu56iKmdPuY8GLYSqENaK0KIuuxQwmiy1A0oIheHmjAy90MpMhWAQpEqy2bxM3lvZCUDiIGPtx/Qafjxam1qwNVcgDHHvZRYfLlo4M/yReha0a/n/xdGNzqyKC/6hOiciHNV2hijWhbaWujYKmUT8rapUZ2DQfKv4mdu9T7J6k2UYy4m7kv6TJ8bJH4s+g76SqqUhDwZQ1ZfhwEzqWg65u4zlorZAYyP79U1j9HD6An/3W9JKGx1zQiMPYXs+wbccMgIKc+wVyDLtUNLfJ6Q5vq9PxjDPsvvXONre9/MUpWY1awUQ1ndofQormIczsUqJ76Do220Amoz6nYq487PpSj3fHCRBx9956pu4NwS8XxPKyKIvIL7dyrpobRjSwAzTDNQDJPLx7cfcQfBJuFrMO3T/W+2skCasmjQmXr4CIiQJJTIDuCi9NRi04f5NTIySxUOSBW24TWc02Yq2eMQvJQ4kC8IU1qiiPuQxcVZonHYQGyFSM+H8oeFZaScBfCWl8M+4JmTmJzkPtIgoxxbToMfGVpB7vCoJy+V9IKgiW9jXbRRXTtocbXl0aJGTZPvzRygg6WjguTE5OW+Mjp+rBUsQDGfTt0huydtrcbHOBW4EFG/pQy6VvFK6vOez0U0RaA73JEE+Qrm4MqEB9AbZrJRjyyeAY2rZRh7mwB1EaOSPgTBbfmvHz923QTaYHiT7FPHU3MfM35C2ezNRULL9jTEJ8Vm13mRpe77i12bnpEHk5RkVo0G8yKvu4Z2+ZJO5O+yFHI64MbJykb8W3+bZGO4UvluqCKi2nqEZM+UeUA5VD/8tb4bPbTb7tZdUXVT+K1AS
 U7PkNWO2
 zUrnlG4OPDJiW2j71iMiKX88vuVBGGWbon3rxfwW4/filWebFkHdEDXpp3t2gm4rJyHOaCn9fqtHgY01mF5xGvXlD2oo5tVQCNjHaTkHLDUzzpJ6zhGaMMm1QlwnYy5lcBjWrEu5J3quAfX1wznrKBpjBz1VijpoI67EPiMQfibEbIKolRgqxB7SKw8CYI3p+n+PPdtpx1kJrXQusUaB4VR9KDFMnzZpHo02lAre1L1pZvJpTVHcEUY0C3QA7XXCmPUzz4QDEFlX0zrLEK69K2AyeUha6iDk6iXjnbIe7DH7+2pV9nceR/NYNv4otvdLoX9mQe/1YzBG38q+uy0aiOW6bhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > No functional change is intended.
> > 
> > Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> 
> In general it's fine but I want more :) see below.
> 
> >
> >
> > diff --git a/mm/mm_slot.h b/mm/mm_slot.h
> > index 83f18ed1c4bd..bc3b9ae8fdbc 100644
> > --- a/mm/mm_slot.h
> > +++ b/mm/mm_slot.h
> > @@ -52,4 +52,11 @@ static inline void mm_slot_free(struct kmem_cache *cache, void *objp)
> >  	hash_add(_hashtable, &_mm_slot->hash, (unsigned long)_mm);	       \
> >  })
> >  
> 
> mm_slot.h also inexplicably implements mm_slot_lookup() and mm_slot_insert() as
> macros. Can you change these to static inline functions in the respin?

Sorry, I looked into turning mm_slot_lookup() and mm_slot_insert() into
static inline functions, but unfortunately it’s not possible because
they rely on hash_for_each_possible() and hash_add(), which expect an
actual array instead of pointer so that sizeof() can determine the
hash table size. Passing a struct hlist_head * would make sizeof() return
the pointer size instead of the array size, leading to incorrect bucket
indexing and memory corruption.

> 
> Also rename the horrible names from _foo -> foo too please.
> 
> And we don't really need 'mm_slot' in the var name for a slot just 'slot' works
> fine.

Ok, I can clean up these stuff.

> 
> > +static inline void mm_slot_remove(struct mm_slot *_mm_slot)
> 
> Yeah this name is gross just 'slot' please.
> 
> > +{
> > +	hash_del(&_mm_slot->hash);
> > +	list_del(&_mm_slot->mm_node);
> > +}
> > +
> > +
> >  #endif /* _LINUX_MM_SLOT_H */
> 
> Thanks, Lorenzo
>

