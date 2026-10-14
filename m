Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC3CC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEF116B0088; Wed, 14 Oct 2026 16:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6EB6B008C; Wed, 14 Oct 2026 16:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCBB6B0092; Wed, 14 Oct 2026 16:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C123A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:30:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 614931607DD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:30:32 +0000 (UTC)
X-FDA: 85322374704.03.186D16F
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 186F014000B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:30:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=CkicvWHE;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792009830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yaoYiNsU7mJl5B1XUBRs0KY4FNWwAjLp6a5fD5J3icY=;
	b=RfGYfIUuXw/g7DZF0c/5Hs2kp//IUqvAvl4pWDL6k9FdlbGdKOO+wtieDS/eUmoApZVdD1
	2B+CoWcG5wIy3sRs9x25dt1UPIajKvwqdYbakLSweT8FkNkm83gS0f27XC1HXjPB79tVoZ
	Kzp7iIrPemQs6F50/w9qKzjlSMyNrHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792009830;
	b=fTXfnMFQbohKIT3bZvhGVOdCpyXfb7tU67zik3NBlnMgWvUIcfP6ufFqVQ0pf4F1fZHXNS
	chgfesQnSOk+m659bcvjJ7nAdNGlcuWAcslTLGNF494HgGuCYDxWukw9W7SNE1a/5YN/7I
	4XkaLmrf1Vvwt0Q8xbBwxJo+X++XAKU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=CkicvWHE;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e503815adso319644985a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792009829; x=1792614629; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yaoYiNsU7mJl5B1XUBRs0KY4FNWwAjLp6a5fD5J3icY=;
        b=CkicvWHEGk69pGSybBNRyLoESHnzNWw/Ruuf2wvFkr0mjHsPi8Uv2PqigAvwfE6BFa
         kKVISL9PP6sI8nnMDmqNZxPnosCab4H7izEQew9yD7+sOCDFjt/z7I/vTU2ytlTTXPm+
         clEH+mMThJnxgFl8GClZU6N4g8iVWN/tLlFQ25GRbnXFEVnrmy6ZXbheTsq1feybxTQO
         jtL40nuz1Ui8TkatysjH02Gvh6kqJZIV+AGxDOfp4JTo8TY4LLYXDOgO9+ua6sUp72rg
         NTwHu9Yc7s7r9VcRbmxjleRwnyyxhnMntixI/jYbbnTqm/r2m9KYqWDhprWTTwa6ispM
         pzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009829; x=1792614629;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yaoYiNsU7mJl5B1XUBRs0KY4FNWwAjLp6a5fD5J3icY=;
        b=ERbiLybp/hxCFNNeANZqArytgzvczVnq6yr/cr5uXQwsoqtbz02nfP/vORPmD0x/lH
         qgipWAmNg76k3RQyIIU6lhem6tVACmRLikJviZBNDumgCd1LZ72AdwwtOMLRzCFMNSZ4
         Rcg+2BptjrolTlK7Z/kfNbS2KHNNnl8R1iDzATuqHntgFmBkcLrAKpA1U7uV4Rg57bQQ
         pTDVZ3bzmUCHq1asyrfzFAE0hExwCQKvv1etANaDsFC57t2nq7I26Tu6odKkF77JXPKT
         iElbbwiTHphf4xrXoWLbNh/LwN5cOChBcEC0XqpS5o7rPSeHZftMfX5uyVUCTXIDkHP2
         nPtQ==
X-Forwarded-Encrypted: i=1; AKwUvBwDWUrjPnPoUE50pNAv6M0tLiTe75u/y3+iOcuP9zG17olYnwPi9oKMsvxMybKBAQoNlDllGyngRg==@kvack.org
X-Gm-Message-State: AFq9FYLCVa04mbkuvFv0g6kyv4VeNa2cApnFp6PFPTHXmSM/c8FP+0ZT
	rHSrFmVhRclSMxqAYKel8VhL8HbYYUVb4A8ipe2r8lKvFnh0QOpci/TryrypGHwc1Gs=
X-Gm-Gg: AYBFou01xrxQx+LhOTgrVexgHhmatK/q8gvjk0s8IRu3SLKV5+WQdhIKBg0WA21eg51
	d3FKpiafiqWJh4F7EcdguSlBluCaCuzKt5N7xGn4pwzZpW8S+qpiRNtCPOx0opjZ5akfF1KF9bf
	x+lsFJFVQihNB48uw67/PNP0CDdNZaMkR/2sF7SHbQD3gjwb2xEItGCbGbpRFw3S2v3jjyFBuWU
	xMu2gIoP3cpMnJReMSICCB1wv1pl4GKfn/5epA6yC8VyCveKxw9RV12I5zRXEEEkBlU3ysMUVnT
	kQiDsPc9HxQej2cGH5lmMd+YRGpj9QA2JEU39n6/35plL6WlNdEYpKGuI+qL9o40f7BuIzUYJO/
	vcG/agQbYjTwpSJdyTscNkKltD6rQqWOjwfPvWy/r7HvwnZjSqK1wFhBKRIdal9PZzcLNXm5ITe
	kUzGLzfi3TCQBJSKOgL+raOcpnI54Twlif/XnI1475Ax9S1FGZz0BxBbqpTmKU4Qif2RKb
X-Received: by 2002:a05:620a:26a6:b0:93a:c102:1123 with SMTP id af79cd13be357-93ebd1bb363mr2748648785a.15.1792009828985;
        Wed, 14 Oct 2026 13:30:28 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f0cfac145sm64291685a.31.2026.10.14.13.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:30:28 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:30:27 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: memcontrol: remove mod_memcg_page_state()
Message-ID: <20261014203027.GD371161@cmpxchg.org>
References: <20261014-memcg-unused-page-helpers-v1-0-240b37c53831@columbia.edu>
 <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-memcg-unused-page-helpers-v1-1-240b37c53831@columbia.edu>
X-Rspamd-Queue-Id: 186F014000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: mr5u1rsi3fx9fqedyujnantwmn4bg3fq
X-HE-Tag: 1792009829-390162
X-HE-Meta: U2FsdGVkX19hNi+cUm31je1miHu/GB3Xt05Q2mnyJgSXHmUYkRF+FpsbQS3d1JBSUST79KwLmsdmrg7Z4qS/ItApGp24QOeN93fWcwvX1TQQDzvFbIIg5sIeWX9suZu9Jc2sMq+VBNG/sTGNtn9B+rd/rGwFukVZv3ZWJUqCTDennH4gky4UfLYKgd3PpEoPNuwzCT6kmy8Pccpvp2RIAilq2OlUasCeBeb+vuO632UepX4WalbRbVJrtZOLxA31aP/PJ32eGFfaa53n13yzJyn/2HzK0CVvqKbXb0r3i2MZt16Ko+NiVXbRDf7ygoIMfCQWGC+tojjAYpKbU9MFx4A87aSvTaKC/cHkAFL433jGysiuEamv4KRetBdvxT0yU2sxCnHGWKTr4oEhXK6Y6CZQnHiw1aO/xZWadjcS19QjHcjNx2YkG/i2DhRD/iuYWCFj8w5mfBRyP5g9cUNqXPj81SbS5gUhWbHJG5jJkvKMs+hDduNuh3+4ajt3pWWVhnrhEGAHPo+acO7V7czFvRCBS3VNVlylYmtA3PuDMb5zFq0XTyx5ceZ8wEFGHHDyTbiTPyacl7RVD78g+ynRhiv6S++Nypi4QNPlsNQF1/ObOr7MLeeJtJMpY9RKbKvyUhJp9lMzPXnyLQhwVgpj1t7uyh9O+i8Q2oY4/9SCN6gtbqNaCYNcK7dbgmOADZAdrH7Oc3SzrqI8wIWrb625HjPECrkho/VXhRp9xKPkwQIckUMv9SXP1lMs0A6oQARQX5ROEMnAGwxd5q02hJXLm/1YOn7+20ZoGFFYg6iwNR6UdxLHTBDldEIUrSC620DaPuLEWSoRSIcv2Whgkf8KzxJw514r5ucqYWYMPR1Ffaed8fMlhav+VON8vUh7FYmDDmQNkY8Ei76Qw9jwoya5f8UC779vCwESttI7Tt7vt4mUPe+7kSmpaJJNqBcFl/SisDaM17pjxI+X1CxX5jO
 KKZuxEIA
 hOK5JxaH3gRSMFsTNeLrC1gsXeG3JhQb7PZAmqy7OroaiSrpM4cz8nN+mRztSKgOSUwk20nqTjtqR313TQc8eGMdWaeTmHbnBUPuO0gmGlzLWuINm8g3NqIRt9+W/YSdtVfZAX1ors15FbUduuuwyDR+xo3HFk1olNj5nbcGoPpFbeAhloGENdCUzWnadyr2mr64XhJnTjZ+VIkerWeY7scO6mIwX5DOI1ihXlUUCs8WI+f2yDqL9umU1/RwnDxlXr2dY0IU9cnh/3XW1xESuErPFX/E8bx3am+onuEfFJUIpJlRVs0X5vx6OIZZLJa/FiCKeMeddXjZsg4aazYnY0rtcyRaTa3cHUIt9kDzLyxMQIlINbQDIj4VeXrLKXJIgVBLTHnt5ok7/1apGsN5epqCWfuodsz6aQZNMImTQgR/vArw/9UPB4lFXNJLA16zqFbQsDIvgrytzyxNdOo20P1pUB0Ex2i9JNS6e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:08:20PM -0400, Tal Zussman wrote:
> The last caller was removed in commit c466412c73c3 ("mm: memcontrol:
> switch to native NR_VMALLOC vmstat counter"). Remove it.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Tal

