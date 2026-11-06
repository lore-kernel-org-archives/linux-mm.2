Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48F52606D80F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TK3UTnlS
Received: by kanga.kvack.org (Postfix)
	id 6BBC16B05B7; Fri,  6 Nov 2026 09:43:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693856B05B9; Fri,  6 Nov 2026 09:43:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A93B6B05BB; Fri,  6 Nov 2026 09:43:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4F66B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:43:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC6BBA8CB9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:43:29 +0000 (UTC)
X-FDA: 85404962538.15.9B790FD
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0102F40003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:43:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TK3UTnlS;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793976208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1coO61O9o20KGfWhe+U/6TV0ZY/FeV096v+PDZIBmoM=;
	b=agSvAihF5QBL6IRTDskVyrNUlWa4DKO41+6KjlBeip3rS9S3XOG0Ien5TG+nV1dafUpGTw
	2MMDO+X0ofuWUWCS4hb5iB4cztpjO6M2gMIfiadwuGVw2Lu37oVlX5lUoI5mI+SheuXu+h
	L4GcI6d7hZBp8Dxn3VY0+DSgI/JnlgU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793976208;
	b=dx/3MJtjRdJGgMpDzi7AuAFCdIQ/S/0IbCJgQTGlnEiKsfsmu5TAcOUcjpysM4IalQQ18O
	e0OOqjiR+0oLxFsdeVdb6ahC+aa8b1VcX4tCVWw27BQHsdfFnyMEc0gH0xK/oM4sHsPSs/
	e7+0oGjXTG7VpDIoi+gvJtcMgYbsVxk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TK3UTnlS;
	spf=pass (imf07.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b561b60b78so2686944a12.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 06:43:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793976206; x=1794581006; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1coO61O9o20KGfWhe+U/6TV0ZY/FeV096v+PDZIBmoM=;
        b=TK3UTnlSLELfMO0y9OZsBwc+RlI7PlBN5Pz8QwUR1m6ipxaelnej34dOJwu8N3rNTN
         Fvu0DZV43uZnfXrKlS/lyQRGoHRPzGrJYgLxYPHMG929lO4SE/BIInwJNiy0gQLyfOsY
         pLczWtVFymoKomOCNOKC+OjHEMsTcNEbu4nSFWHJ59Z/0jvQ3Lz8s/yNTo5otHwkdvV0
         NphC1GpnjzKZMgrMLGyn9q09Z5Y2LoMx0KtFbWKuk4esnxPArF2XUhnmMz2e70UZ1U8e
         3MjWD3GcfowQEytkcdgQMRP8d9dI0HTTP5BV5m7/f3+gBnmaVXO6Ft4Vi9S+/L50YLIv
         HBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793976206; x=1794581006;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1coO61O9o20KGfWhe+U/6TV0ZY/FeV096v+PDZIBmoM=;
        b=HJ/LwJl+lPPDgj1yAwnQo4Vpk7h+J4tRoJToSOgjibUcrrRoGQz3TmxknpWaG5gs+s
         y7/rFADWi4ZmycFymsK/byF89b9VePTVJpY7L+OHnQr7G0IXn9mFz3ClDgz1Z9AfLNCo
         WA/sZv4Nen4yWqzcpSEsOnbi1onm5TRiy8PSpA1wq/gBKglcGo2dU23AxkqN++AscUkQ
         9Lm30rhQFXLfoy+HUcVhOWPC9XfI2RydBXXMjvGaAa8qAu8xgFIXXJr3VzaTzHOs4Rxg
         k3xrdz8BT5Ti5yQzlIUKaWxBmzCTfR2vBBSLpzpoKvyKdczAIvp2OxYuJ+GJ2hR4JZWZ
         JvDw==
X-Forwarded-Encrypted: i=1; AKwUvBySFHekR9ha/+xR0VXAvJerVgLhMjRv3L5e9VN/o0XpvkKivmqAecvHI/U4m/GesikBJCUabsdiAA==@kvack.org
X-Gm-Message-State: APuU4Z8YV8zv2xzwY3G13D8OTtICypr6OQ0SEADLHy5NwQS7sspjrAwE
	xUCZYgvHkD7NqWHgX+yZijbC+fNu2K9ZuNqsJlxAXWxRP/nQfRDOx19Q
X-Gm-Gg: AYBFou3e8c9xMVNLmhBRWQOHQpWAg1W+u885WONz5cKLtJuR2G2qf/yN+MbIPGHk/yH
	zGTy9QpiJFnBgWUq1gWntbZlLhg4kkFSHkNgpo6jEaxUn7ipcr0fuT1DBbEN9CV8rf1R2fskT7a
	D3n1s0X3POOh6VqlYfftBDC0kgxzFhxyGQXVuVy4lOwYRk6pCpcAWD2751qlur3XE2bGfanhf5M
	+55Fg3mk6KyG7KHhBJg37Nt0GYkWauz+fFpOzONJY2+pMTKVpKJeTX0Up40p08twk/MYUUr/deX
	ZJ3aCGiEvKxrsuDt9Gh+g4a54565qljdId0iWJaj8XZDnc17+xrA0yK1niIuvyrGEYUzMBF5e0u
	f7wa8OsvJDh6w3XTYiMdTAQ9cVHAQWxM5USMm6blWeDhJcjtjOTUfR3s8YH5nlGyaBHK2AOuVyP
	NYHk3rnRdOer1r5pCLq2DRlK2mqnEOrrRx4IW5e8NwP8+5Z0Tt5SdzeKTOymmGICr2VaYdxp1b0
	kcR/HuFUH4Ah5GQYEwoF6PVaJUEMTOle71M/duxRMSzVpdy3Ne+u/Jj3LiwLDgrbYAc
X-Received: by 2002:a17:907:fdcb:b0:c2e:616b:6763 with SMTP id a640c23a62f3a-c4d3525a3f4mr249438666b.3.1793976205728;
        Fri, 06 Nov 2026 06:43:25 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d35631eb2sm86304166b.27.2026.11.06.06.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 06:43:24 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 6 Nov 2026 15:43:21 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <au3nidyyEWsNkL9D@milan>
References: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au>
 <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au>
 <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au>
 <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au>
 <auzOjphJ8DWpXwUy@milan>
 <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjcKOC7O30L8_8PMniT71aqy_3ZEYK2xyoR8zW9ZCvO7g@mail.gmail.com>
X-Stat-Signature: 1jcxh3z845xfmnuni94f5gindw11d8yp
X-Rspamd-Queue-Id: 0102F40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793976207-134148
X-HE-Meta: U2FsdGVkX19nzJE2JN4ELCMvvk/aarKWRlOzUUfvLkMrDo5DbiJHw9UD+tjU6jESBNNWLjPrFR856459yffXigmFCoQhrTuRh6nj51sTTGNPAPEXbHx65Q0Yg7XzQCNE/CHNVKnQRkCNHV4+uplfa0b1InyFfGAhkiQJ/yGzmHVGfCty1a1s35C1AiIPs47Dph1b7/5BQgNEgOQ5eQ8l5oZIDTaLIcNAA5EslU+2xoykLCoD41i5+M6YF+pp6nNaoieuBSzZ4+8iqxg+bH0BfXO0tr4BD1MbIdtzzg/hXiT01R39EuDiANXBXOD3XeByAIqVJtBfonH3QqafYTrsjv4YOXWY/ONOXnON5bpEtulclbA7y5jg71jzMax22kshz12f4d3RqdCnRekAJMg9W/TV62tbZWsomOmTNmb1mLiMzinPqghumnb+lX+h6duPw7LeAyrK5jy8YoOVLurXCL3/qxewsLoDP9/apEwgF1p2JytOVXPirEO6Jnz4U+ITVywrtVj6XPW2nkCPuoBMT/DIGUFRNLE0aEfYV0S+S3DLr3GT2t742hyYkouMGDFRB5Bh7UUQxlLPTpo7dlZ0Ov8WZukIv11jCYwzuGTIpe+AP8PO/jkiOeQS4qrEBovLvIG9ELPG22WvcCDJg55yWGCW4XlDAk0VmNQ89740oSZIPLQSrD3cZtm4usmRmpM0WX+1+tLUXbSW9cFewF0aYPc9nlB0StiRMq4ev80bzJJMSxMp1+vj8V+5CcS/7BOaqSPXYQZSx2MYfabLnPc1bPIpzYGVX0nIgtoNyhQGOSzdY00i9bIqnC6YlVq64qwQj31lUB3C6/7qJOxKBbxw5CqzhzPimraCbABs2H7oVb+Z9yiYw7CMxYgqHDQUi49CXqlcM6RxbgFMKS05R2at60+wc0wGmUAgSeC5kbvFa29AaYWS/bdphbBb18Ei+Xxb8NY8aVwZO6FGtCqkXBG
 iBxi7pMY
 BcVOGrNxPHcbmsJLc5Xs4q+DzK3Kj5/7qFJxsAD46FWqz5BDjdxiTtM/vhDWKvZdePWJz+O3DXyDVD2/+QrUnRrVmx1r2Ha9n6aniWsCNmggZC+Q4pUZ9nR/B1XCuz4J60Ezlu2kEt2oCCU/VA23tWmTlVzzBEEbVuL3ZmIr+70nPo4cx440EyvwkrFTfINf68NMwVo4c75O/QttJ9Z5JbWpMWfoDBZrxRLPek79eozjRDbwWZfilqi9Ey5qS3kKaDHUnZf67fhl57HlGb8WnN5X9/rm3ZOBztgLCCAuO98naThtaXyCSFSKCAT2XDBdACGSLB7LdIJqDCPIkDiEkya3saG42sMASI7nt9pf+VhgmjbQOYzL5T5mzGUQhHhlIVBtwNbY9kxWpAcNfo0nSBPcXsatA2teK7ymkIyQl1xRmZy8g+BVt/l+eaRBuiuG1QU+RA+L2i142Mu2pwNF8gEWMsiUuYtoJ4vUYrAW7jRsTvwRPxUJQ3VXd3okKS1KPz7+ZY+6iy6va8iw+yqoR9cUyGcaujdEfRXz4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 01:02:35PM -0800, Linus Torvalds wrote:
> On Thu, 5 Nov 2026 at 10:44, Uladzislau Rezki <urezki@gmail.com> wrote:
> >
> > @@ -1025,7 +1025,13 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
> >                         }
> >                 }
> >         } else {
> > -               spin_lock(&br->hash_lock);
> > +               if (in_serving_softirq()) {
> > +                       if (!spin_trylock(&br->hash_lock))
> 
> I don't think that in_serving_softirq() makes any sense.
> 
> If I read this code correctly - and it's possible I didn't - this is
> always called under local_bh_disable().
> 
> And local_bh_disable() will have increased the preempt-count exactly
> so that it looks like it's in_serving_softirq().
>
Sorry, probably i am missing something here. My understanding
is that local_bh_disable() adds SOFTIRQ_DISABLE_OFFSET and
in_serving_softirq() checks another SOFTIRQ_OFFSET bit.

--
Uladzislau Rezki

