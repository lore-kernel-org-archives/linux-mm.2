Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01F52CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 19:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404A86B0096; Fri,  1 May 2026 15:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B61F6B0099; Fri,  1 May 2026 15:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CBB46B009D; Fri,  1 May 2026 15:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE5B6B0096
	for <linux-mm@kvack.org>; Fri,  1 May 2026 15:38:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC4DD1C00B7
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:38:38 +0000 (UTC)
X-FDA: 84719863116.21.1F59F6B
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id D857E20003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 19:38:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kNFm7MRM;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777664316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/J79f1asvrACGXLLFTel4S33q5C0pBsIvuXPpJLuoI=;
	b=Oke/Ve2S/kphAhFYPynRSwJYrGY9HyF1Mp5JNGk6IiE9RVyaneyGbKsMuC7gMdaHkgloZR
	LYzG8sWNm8NIBLHL2jYg++h19Q9z7m6+9wxgLSkrbJxqp/RPN31AA2s063rGzCkAbxh6sn
	tmasPxj9zmVwHIiovLvdB6x7kjaQKsg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kNFm7MRM;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777664316; a=rsa-sha256;
	cv=none;
	b=jzw0pe/xWFzsf0EkUxdyUJ/aVBXWdIqGkuHyjg/ZOuv+iT2gHetGxzr1JODq1Y8gBgQAUj
	xDDCPrHlHG+SOmi1lfoc6EeXpuP5rx0ObPcJlf/LBgzNFptpVFncTNDnH2q+cs3HlSdxc4
	mBQ9mqDIo2dUNLnzOV0g2V5Lx/z8OtA=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8d67a483d3eso257520085a.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 12:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777664316; x=1778269116; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6/J79f1asvrACGXLLFTel4S33q5C0pBsIvuXPpJLuoI=;
        b=kNFm7MRM/06PB4igoB3IAmxU63XPtjEQwxzRBnae04rmk8KUcURKSKVz5mvf8rUqiW
         ZT/dxfXjFe2vNKRdQAqsvYKJfGx5JRvyqGYaokAPbaIHva2bc/+gTQcdDdsXQ/2SVRth
         cFhg4q0f/aQ2WD3jymRa6WnkxMQvSa+2ssT6wMH0FTfPxZRal9EsmKH3V9Hwto5a8yOW
         XKS2UMkSeuDlu6yCBbkf8DyQwvdvQn8xerdBpcmAGTRcb/8WG2YbikZTrFli0Di/oNQ9
         D6kox0ce1fK26JvG+p+K+WBmZWkviXtpPH3l8AdmeEHMfqpl1Iv6pWm/yp28+qX58tdp
         5/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777664316; x=1778269116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/J79f1asvrACGXLLFTel4S33q5C0pBsIvuXPpJLuoI=;
        b=Q95ibaXP/f8/cfeug1hKZkOq5jt1db86LRxcET5ktZ/t7Ipxnvqe8cF5uxEfGeeidh
         s2/Nm9m14dKY4HDIudJkT849Sq83BwzFgpEtD8tbqjfgNMrAMgJP7bKv0bHMgJf22lb2
         hUXWvE+Ll/m2D6GTm7AO37/EdFvpeizfC+5mxWtrXn6Lv0Fyn+Z0vZGHDZjx4j5HJjR7
         f1s3m5nds5TZYlYU9skFVcpB+rVLoICYAQIvY/F0P+ONRRgIoYMUSERc3X1xGvdC77AZ
         2f6Qn7MWJlUW0ngmhUB6k/2XWrA0gZ1pgw/+ZQVmOsCMf7l7rZq/s8d7zY5ovF3Sx5bE
         KWuw==
X-Forwarded-Encrypted: i=1; AFNElJ9l5C+ZogJy7lBxz4wgWGBJ4N2njfRhED+wq80zFKtF2Agrybjm0Os9iRN842dkE+22SlhrYmOMUw==@kvack.org
X-Gm-Message-State: AOJu0YwVDT7ELD8+NrDjwX7tG4GswA2X8FACtazeadcLX6b/aG05DHZg
	ys1Vuw0VHc2x0pkTSeNBZR4OtkZfe7Wjb3jhToVQ7m0ylTBSTI6LinP7oJMSoyWqFJY=
X-Gm-Gg: AeBDieuJTxKaqSG/Bbb4KgW8lkatPzy8QJQiBFD1DHElVLIX1uyBXW5ozeqgm0rTyB3
	vVxVCPgl/VScxq9ztH5+HMbKveq2rVBBur0pDL1hx64OFcjdv6fsGMUOECMp6EkfzsH2h5H26bz
	ALHB9Fb/C997T44mqlD0kG2CQEdfE8t69BNJWo0qXVd5KQVQ+z6MlqbZCVbGKu8Y8KzlADZqyZa
	Cfo9N6A6WO52phD4wXj+GoGTVoRQeEuZf9Kbo/7mLeq+F45TFBbGrDId2i5dN+eayDvb6+cMd7+
	UyGeImEU5SEwdwnv8Iw3eL16wSGnGriVTajeM5eSXN87X+0Jw4FZbbTR1GyIDfUyIM3VQVD1gLA
	OIlLSYYSW1rOIKTfWSlSflhxFsSKK5NbKl8nP5d0pSoqcv12Tib9omI9EG94QDp/cgLGbYITUKr
	wn4Rc5F2y1DyPmXS75+cCMSfugLPXwcAF/AzBrKlRQvvykyoTzXUMTfuJ/imVdNQ==
X-Received: by 2002:a05:620a:448b:b0:8f7:879d:ccdf with SMTP id af79cd13be357-8fd18529267mr105294785a.50.1777664315885;
        Fri, 01 May 2026 12:38:35 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91cd89sm246288685a.35.2026.05.01.12.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 12:38:35 -0700 (PDT)
Date: Fri, 1 May 2026 19:38:34 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David CARLIER <devnexen@gmail.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org, 
	pratyush@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/memfd_luo: reject memfds whose page count exceeds
 UINT_MAX
Message-ID: <afUApNZQumxPQ3wu@plex>
References: <20260423125648.152113-1-devnexen@gmail.com>
 <afT3no4OkYxnQ6zJ@plex>
 <CA+XhMqws+mudAQo4ibaLb9MJv7pKDfLUAH8CcHSAkLNdPtijeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+XhMqws+mudAQo4ibaLb9MJv7pKDfLUAH8CcHSAkLNdPtijeA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D857E20003
X-Rspamd-Server: rspam06
X-Stat-Signature: iix46nupeaeacirgxdrpqub7kjbcxs1j
X-HE-Tag: 1777664316-64231
X-HE-Meta: U2FsdGVkX1/ljZ+ozmqMg63Ea1sIicODAR0zohlX8dQ7B5j+nlIW3+VJCE//UquusgTpTCLhI/WcmF76uwprVoDx2vwQtyXLRYqhp6AOufou7pR+1cA/eRCYsTjV1DxXzxhYjT0ZLTHvrhVCyTkcuVbsKRRaYlXmTLVRw2PXPQZulbxfEaiPdgcXfbUJ8c6duph41mEWZfeBNBfknOrkhequ5nYKh+r8OPSeoPeQqb0fxbrFqx9PN56+TheE9c+SF0DtPkLdaowAQNeoGrFR3ANNwCwIfR+AdviydOrevcbnl9vq3a1yBIa9REQTD6fyH+TJRq01wZqnGOsvNwY+iZoIUo9XwSDU4BpGIxgjUOmpagL4uWrxWMkOMQT/bPnlZd/OmpBCAWk42ZrgaHcosuiZiTVylgHRXZInWM6X3zHBpEfMDRspWxQzMSIXGLoamrkKfo8JVtKMFYL/TB9p78dXgvSq6nTnKutpJPZdxbsHEz7dnXMEsLayRMWQ7l/AtEClSjAHKu821w/5ltM0qoZ5MOeV8JLiAIKacBOudIHRiaUZBJadF12st1B6ghYhv7KlSdIjtrC5u34BgaNarSUVzHlKB+G9bYAgDMMfVYej6ptWOc6FWEkln5Yfw4Y5kiHSpq5/Rj0+AuM04tyHpjyjg7R2wg482yf+CBDUmE/k6TAVMGyj3ATcwNPmlnnd6YUaBG+p74B7ekBbOV+UPrvdOEOlhBUCsj6i/V/IXoN4q2eQPlMEip8buUDG7+PpwVJE/0qPERvH1aVpsoZqWcGolmougAKThOUJOAmJEge82WRmS5Y9WP7lLOeCuIAAv3qCFLzpgqrSQtZhse1jjKaPPUgRh1MUStw/hIHkpje16Xoq7FBumG1XxsnmbeenqJFRIyvAfekUYkELLXmBxYZ8hunWPNwHGFK0Qm16tqaJ47sCf9NqRARqY6kNXus6B04XjV6Jt0ydELQO8cz
 ldfFCn6w
 7/9wBUpHLw49kavTPAX9lKu70de2x1mW5AopkuWOzRFGHVKXIN2n2xg+04EYwrKRPb0QldETtsAbatmSEb540jDr1SdUhM2OOT1QHpKDNkW9GJ17b5CAfuILztCWFcDgQcdAUbyF+JgzsKLARu6fSF4c/rK93Ekq6vmzfybmgTnGIphum8BPhLhVTuu4N3mJaX1KEemoxJmZ82EYuIIdJmUUu2l+JhbtJYIzj1V2um9FNnniSY2xc7GcNhr7a60WTBoZjQcUSfi6uATkndNYK7ZCX0GXelqhUAhGk/SsU1+QfjDvK3pHfnUD3ubYo6sLoPP+9WsUwh/wtCNhe2UDgsyMFjFP4ZTqmppE1zEuK89/17oZ9uGb+jGjlOBH6whoAP/NILfCjvn8C474mPiiGncuQiEVFmfyfUTMP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-01 20:26, David CARLIER wrote:
> On 2026-05-01 18:59, Pasha Tatashin wrote:
>   > I think, the fix should be first done at memfd_pin_folios() to
> change
>   > max_folios to 'long' or 'unsigned long', and then just updated
>   > memfd_luo.c to match.
> 
>   Even with memfd_pin_folios() widened, memfd_luo_preserve_folios()
> still
>   kvmalloc_objs()s the folios array up front -- at UINT_MAX entries
> that's
>   already ~32 GiB of pointer array, which won't realistically succeed.
> So
>   the guard here still makes sense, just on allocation grounds rather than
>   interface truncation.
> 
>   Happy to widen memfd_pin_folios() as a separate patch, but I'd keep
> the
>   -EFBIG check regardless. Or did you have a different shape in mind?

Ah, Good point about kvmalloc_objs(), I am not against this, even though 
it is a very theoretical issue.

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

