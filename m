Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61592C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCE06B00CF; Tue,  1 Sep 2026 04:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E566B00D0; Tue,  1 Sep 2026 04:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C386B00D1; Tue,  1 Sep 2026 04:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 179916B00CF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:37:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69A07A3E9E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:37:40 +0000 (UTC)
X-FDA: 85164539880.12.9486D85
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8C453A0004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:37:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pIGYpw9x;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788251858;
	b=gwVgF+BtABOgvzAHPlKYkwqYHcZqnc1wY9hxJuPFytd2MLjxZbH5U9azQx9Q/f4pttu4Hz
	6rBnclPaPiY6MPkDmru7fIW7ifQ0J59NvclBs5pIDwsQ5VNhPuprxkze6AY4MHPbGcEisa
	2G5VEYLgPVfcpc65LWxD7LQG30M60hI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pIGYpw9x;
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788251858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLMiVP+WYQH9c6fmi64EU174ERw2OHDZTVkQEU4Pesg=;
	b=Bv/spIvdXkEjJHIpKZvS+l8Cyvcz30VAXEBRx4k+9M7TJ0Qo6tHxvtQhi0MlLRYjS9/25l
	x1OmXffPKenBA2DbPx+BSa+WQvUiu0U+mtev4/hYc8MuIccWNnj1Ckbfz4Y+HgWSUDfQ8c
	37WKQsj3ct7ttqCdy4oYV2ugN9f+E7w=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49b8687630fso32393775e9.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:37:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788251857; x=1788856657; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tLMiVP+WYQH9c6fmi64EU174ERw2OHDZTVkQEU4Pesg=;
        b=pIGYpw9xQA46ogq9FQ30Gziv6sOjJGMpRQKXvBlZdaPmvwn322tQcMLY5dlfo22ZR1
         EP8JqHt8nl8y1E/S9+XTUh1NpAlMquZ37iAS8NNcuAygYPRiQUbhiSQrjUtN1MxKsD7Q
         FpXrmnW8wMDiMcqM/mcC56oCzbORELx0+mG9LP8tRHutjjF3Ikxu/rkiuCAhlFsJrp3Q
         kUMct02ijOnzkvp80pZEYBhAhnwYFDHIq6hvDTmxles+rLerA4kJdlMmaLz9r8X3VJQo
         PLag6vjcNB+I6mRXckOFBJhEhD6UuiUlftqMGdVrla/5QtyfvhGRdiFdyekGKtoh1NNJ
         z/qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788251857; x=1788856657;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tLMiVP+WYQH9c6fmi64EU174ERw2OHDZTVkQEU4Pesg=;
        b=svteTVWLXlin/Sb5mX92Uq2WO4hsSGD6td3YgupbSRQeB10UWdOyOJKu0zc2Xmm/Xs
         j72cl2ZPHc893bUPLmVObL6ueBJxP3YkrnPtNphBuFSTsOciYq2gf4TG2fVbYXyxif3M
         JRMSDXu/MnYfoJMnydSVrjxjmZw9pALhYHdk4r7dho7DHXGrrT3a5vGU+ubbj4bFdJJm
         Ipq01QX0P7IQTWajso4gkW16uDqnoSixW5+OLE05IwO2Aq3JpLl0a+UyfYjMF13ErJK+
         cW6xijfhkhq983P/t2C+Oyb7yqUhpvWPG20+gt8P9Hu/Vqc4o1LfZXTWu//4zQ77JyYk
         mi2g==
X-Forwarded-Encrypted: i=1; AHgh+Row40T6UyaetRpE4Yy7GDp9PmH1dY1vvTbDjeGs2rDY1Cv17sCN5sCX1iAnCWYlrZido1aSIau8PQ==@kvack.org
X-Gm-Message-State: AFuF++myQrGJjBgIegF0uBLLlCZ9I0UurYFw+gi9UEASW+p/Q71G1QvK
	BNP3kNSOspMmolFJDWuYIJDAr8uJlWlBskgawOaFU70KvPLcojUdy7gC
X-Gm-Gg: AR+sD10SFN5ScsQ0uN5VECHex9wYyjTTL52at/zBfHWCXmWFsJmzkEwllQ2OSUdTkVw
	eVzvI12t/Ug51FqhEYY/VLQJeD0qrZ61oJ5JJNRtxFJf1k5XovLEwhOjGqVjai86cqr7AZEN8HT
	h5xGt/rq9+OlvMgEsTRhRZOM2c+SLVWL/OdrYNiscXeupRmf2HcLCId0+GnpuhTIDooY4imDx73
	79NpQjN3n1Gx7ca5Fy9+hwzCFPxKCurRkkWFaTwwk0xDNfBMfJsIvUsyAAsh0AN2eOBQeBMaTci
	J8Fiai+iO8d4OGh/8KT84GdAtGovEA0zZ+xRLTPt9OQZVZQDa98qmlafxQoFto5TEmAQVc2lQTA
	KWdxKyklJ6To3d3E3qdlWsFjC6jAV7YKTpLwoqN1qbsRwKhDxDjuC9ZXkRxskGJEAUxSht4klit
	AbXpOc0NBIj+mVZVEYKExuexDmRmdMZRWoTqHLR8AoILDruX1cTQYE1/yyLRi2qhWncY1wt+F+6
	987PM1gBWHKLkyuVDbbY218tQ==
X-Received: by 2002:a05:600c:4f88:b0:49c:c0d4:53d9 with SMTP id 5b1f17b1804b1-49cdc4546c9mr105399215e9.14.1788251857090;
        Tue, 01 Sep 2026 01:37:37 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce10153sm56391225e9.4.2026.09.01.01.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:37:36 -0700 (PDT)
Date: Tue, 1 Sep 2026 09:37:35 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Eli Billauer <eli.billauer@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Brad Warrum <bwarrum@linux.ibm.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Michal Simek <michal.simek@amd.com>, Ritu
 Agarwal <rituagar@linux.ibm.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Matthew
 Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <20260901093735.3f5b2df2@pumpkin>
In-Reply-To: <apaF1HUtJnstuUN4@kernel.org>
References: <20260830-char-misc-v1-0-05e2ce44f291@kernel.org>
	<20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
	<f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
	<20260831123937.32255a49@pumpkin>
	<apaF1HUtJnstuUN4@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C453A0004
X-Stat-Signature: kdz8rzo3nhbp9671d7yfhurgwi5jt5qm
X-HE-Tag: 1788251858-865106
X-HE-Meta: U2FsdGVkX1+9Mmn8z03L8Sn+ha6eqbuG84rOWfQUlSEzhnHBag2LNiJEsQlV02d2paUTeaNQDvirdJAoQ3fwJEyez9v3BG0I2xkJfxp74am+FHPg2eZnMoI3tOglB1lXoATa9FLmACMilB/Nvj2Wx2u7Fns/8BJpTFcDQ8U8+Vz6P8kYUgGMv6g/TXxFidA9XAs57t+zmYbw1j5qfGatmpvdnOApbV7h9ri6+ORH0fZ445C3fpMuDDTrWsg3XCQPGBJXa0Gy7d54+nI5eNJnGaneS2102V39yxqjRse6xt6yGMZEYAHZq4fb/5dw3ZZWQIGcu6LQ6diy5wntuCciNHXVuA5oHwnm5NRIZH+YjGup7yCSgf6gZpMiHVQ12QCigkuyT8d5xMrYflJkvbWXtIbs5vf0+hpyO6wuImqmu+0up/kIqPZPgjGkf38wc1VWAgyZE0FktzD79KQ7f4UqvnkjHGq/Tyx1sjDzKAh9NpIDwHA2h0fZ8ttAjVfkEZUj5HVm83bu9tNoi3MgnAkQEiPHBwfpTeGYZ/oKWffBNEcAlRXVD5zLBj/TmBOT18If8xkGKjSFd/Qn1TwwW1HW6zlZnaC/8M45KRkWSpYVtdSjq6FKdklx+Yknl/ESUeySdkxlj+Z/L7WrZECzV7GK/Qgx7MR/EjE7/CisiViWes2/0VPfAY7LLw7V41J//e36liBwZ8W4jPhc2YZoCYYSloIZ0aS1tCa7c0iLBnB5ehG+dBQrfggWcEFiXD7gTLqBW3LwWGFIBY7gd3ujeANxMHlNwCWeB8HDjnMujpU/Kl99UMxrTTBmfHxNH03NCe6zRpltifUcq3AUUOFqYTqvmNnNvbwzWbyTKPX/ZWu6zy1kM16eaC6gW5jh5nfMQF3i1wSyFOgZOZNVM0xfehyhDHHZqeUFT5eRhTos2z/dnplkPRRLxxUtWTZZPxsnvE0InGb1PpeIjs8sDp1uH9h
 7K73I6xN
 GIxXANFyO/SCwwsxsIgohEqwZAu6HodRB3+X5lh71OxMYJGlxdcR/KJ0PxY1KSJJn4jupOkASUmgEgG9w/Lxz6zebtWjV8Bicj2qIlc7FaT/bV/L/iFKuROaO91t/WCU4Wj/WIEpE61T8Cp8GkJLkhXQiX9uX+nKZEf0V/HsSFHu0BnYcI1ks8Bcg/k0+4gYh6P1izKc5CragrpNPSsZiNT/ycJZccQMsj8ZBHGbfWHeUcD/dx71kYAUoxf5/8V/GKgnrCAcyFe+yU5hHT6rSLZMxbLK+UZ13QkYH87PXKGzVBPL9nNeSrthCCMHCOqVVv+H/cT9ADptErd/6jsLluKNZhF+Ayj5nbIz2Pf4r+RH0xSGWIIlb7gyejuyyHqNZ5wWs8waAqRe2MBFHYYsxx8V9kFklgTrSQYGsnx9PpR1XNeqcr/eXhJEZTU4bQ1c0QQIFmq+qfNi2XNX7SpaWnG8kVSJLF8Yy/dE9HTtKKYGrg86Wy6suhsZLowNvB3zoXDgbmphNstg8wC0w7y/kKs+K3APg9H8Mmt4AfxAcajgT3UzL9jPTnE6+CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 10:59:16 +0300
Mike Rapoport <rppt@kernel.org> wrote:

> On Mon, Aug 31, 2026 at 12:39:37PM +0100, David Laight wrote:
> > On Mon, 31 Aug 2026 12:13:08 +0200
> > Eli Billauer <eli.billauer@gmail.com> wrote:
> >   
> > > On 30/08/2026 9:47, Mike Rapoport (Microsoft) wrote:  
> > > > fifo_init() allocates the buffers backing the software FIFO and
> > > > endpoint_alloc() allocates the transfer buffers of a USB endpoint.
> > > > 
> > > > These buffers can be allocated with kmalloc() as there's nothing special
> > > > about them to go directly to the page allocator.    
> > > 
> > > Except that they are a bit large.
> > > 
> > > fifo_init() may be requested to allocate up to 256 MB of buffer memory. 
> > > This memory resource is split into an array of buffers (fifo->mem[i]), 
> > > each 64 kiB (or less, if there's trouble obtaining segments of this size).  
> >
> > Would it really make sense to allocate the four buffers separately?
> > And/or use vmalloc().  
> 
> My understanding is that the buffers don't need to be physically
> contiguous and vmalloc()ing the entire fifo->mem in one go should work.

What is the minimum size?
Remember PAGE_SIZE can be 64k.

David

> 
> Eli, what do you think?
>  
> > David  
> 


