Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A36A4CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 05:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042198E0023; Fri, 17 Oct 2025 01:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019C38E0002; Fri, 17 Oct 2025 01:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71978E0023; Fri, 17 Oct 2025 01:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2B0B8E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:12:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6224A1404FD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:12:26 +0000 (UTC)
X-FDA: 84006435492.19.AB8511C
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 70DC8140007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:12:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=d6FXsWDN;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760677944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zx7gecJVM0B3tgHO4gvhQyUHfVpL0ObYiuUhv4Yc1KY=;
	b=WmSL7RDzbpOlueNelCj1MdHKQqIhPZLl0blKIz45Dl8UTGhCRXY/7Oz43yC+mwqgpqDo8d
	A97QtNbhwynJztg/gNyUed/luj1I6loYKH8ej3cWyEVPUFsrYeFMDHNQ3ETtXojQ0k4nxb
	o/ZyFWNKQXQvwjGLsf+axl9iZgRg/fE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=d6FXsWDN;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.54 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760677944; a=rsa-sha256;
	cv=none;
	b=OB+UzKYneNuPW8/daAo/GNnxTHPZj+xGpi47bUyeJVu9NgKEKkl6Zi+lz1ahMoQqcXxYK+
	juOeOy45ZBB5aAIH/HO11qcgxxcmBYGyKilxRPj2tpnIA4IFTSvlBiUzvu8KFsH86CmqSH
	Z8DSsFoffOwuNksGPYeunbZYdoek0uE=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-33b8a8aa73bso1409884a91.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 22:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1760677943; x=1761282743; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zx7gecJVM0B3tgHO4gvhQyUHfVpL0ObYiuUhv4Yc1KY=;
        b=d6FXsWDNkDGUe7YDzQqaRDlO3ZjCMrP4KEnyI0Gviu0eqs6N3QZQrk7RWIjxOp/MSB
         AyP+4ykOOEhkX5FcBmQHRUevI7H4/qxZh6YXc/ZMT5zgzP0teahgxRzxyFUR6eaqqtpo
         tjisLKAmk00/cePO3RUp1LKROfavuLX0Rjf3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760677943; x=1761282743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zx7gecJVM0B3tgHO4gvhQyUHfVpL0ObYiuUhv4Yc1KY=;
        b=dk6cNZy61LZyAHp2cQ9gQpdCY/iNl1t1BV7piT1eKen6RZFACLw1dkQ1AvFP6zQfiO
         YM5oPApFIjvam0u3AbAY6bpITFUgHfaCJmBECRZBh7MdAHk9FgirXLwjJ5TZDHhlXLwP
         AqJNNM0pNHJzos4NYOnhnFl1+pdYumT9+fJFTl004Hh55F97ObllCf1/im8YmlJUThmZ
         l+Qp+fwUEp7pdsGROJfcLYjl0rDZMRFqADAUIkTYSbnTZmh2cs8+l3HPdpsAHwD6Y61v
         5oqcT+7lyDhue+vNLEJpgnzqiHfEOqEANkTCQMLzC9OuHmXHNHLnTYZH64iaINuNj/Am
         AfQA==
X-Forwarded-Encrypted: i=1; AJvYcCWClEjA7FQf0AlivDKF6XYa8acLAFEIrRxsabLoFEJrelM/O9/AbD8cUH3LTozCPwgA8krw1b6/MA==@kvack.org
X-Gm-Message-State: AOJu0YzubVcAOey8LnI+V9Q/8ufTnBSWb+cSZ/6L8yikk4iXFZN425Ux
	XYQtLNTYO8nqaB0b1WBstdI3WT7uHpLhagE3sXja6jVD64HwtAlBQBFrFngzitGUpA==
X-Gm-Gg: ASbGnctIma6FV3zcZ1VHb8YDPBHjXnNrKqkqnK+2A7Zl/Sb1lRZ75E/BktOJuTstAu+
	jjy1+VBPZGbxP1arFmwPHka1nW81lfR0bhjmAs2lEwmtuj7np9P035/dVvjsdWJYW4GgdxvMPhA
	a7I6hjC692JjrDphmkRy89tHpPSLik8dQ67IBloH+QfA9wzBcRSfaYrKzzsja3qy3zvVMXTSESe
	GR8bovbjuUnXofM4FI/LqYHd2v8GQlU8gQ1BlC6vYLZEDV0Q5+KwNJq88eCbjsqRFgM4TGhFoWG
	kMjqRQ79AHZ5GmMgWpzg6LhPt79IY+Djr5spFziryCa8fobPIzlPVXBOTJGJS2Hol28lZxpDEc+
	BCiJVhbSYzdAwGChk4W12IOUM2YF+AJmh/J8FCkzHr3LDwWa3AsYQ4wfxymFvOyMCsj/fecQaBG
	TpXUNYCTdwXqUzd59SyuJ2aq4H
X-Google-Smtp-Source: AGHT+IHMSNNWjuMVf6ka4ZRAthIkCQkaS+3tfv60BOFg4hlZ3TU5YeQGrih/jnEx7KdcsWc9ynXdTw==
X-Received: by 2002:a17:90b:2d8f:b0:335:2eee:19dc with SMTP id 98e67ed59e1d1-33bcf8f94b6mr2535744a91.28.1760677943281;
        Thu, 16 Oct 2025 22:12:23 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:98b0:109e:180c:f908])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bd78dff7esm1409370a91.0.2025.10.16.22.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 22:12:22 -0700 (PDT)
Date: Fri, 17 Oct 2025 14:12:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <rbl5iuovk5xd2ed5ip4n6mkh5ad6d52ygkqlwbehu3rm6awkn6@tswgallufq4u>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
 <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
 <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
X-Rspamd-Queue-Id: 70DC8140007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: b1p1hwz7p9nzthxzw7qhhe6d4b61r1h6
X-HE-Tag: 1760677944-945448
X-HE-Meta: U2FsdGVkX1/McHOHB0GEfFKc40Czf7BYmUjDF6vPXBfo8uau9vGpXKbPC2hrmpDrZ/nKLAWPpXWiI4XDYw8ZibvV8CaAnyZZtJbXJSUgwz7FDvbsZRjpy5obzaSBJpC+LIxEfAmUDwcywjWQwp17jHCgwqdbafrxtLdNLQBf+dw9K6qe5gsn6oCvmLNkVa6bywisslnHIyee8NkYAqEz0DZhiaHtLiyeMdQ4K1w6FhnMeHutFln4fJbeRITwimQ+xIO3BFWeJEBGUIBnWizAaPdsNiTXchxKhQjgPIdscwOyuXJpOdR521TIvTvFeecz2qdWAeE17roMDBIvnfAdRu8R9rdmDR4BcOBZcODfqDursIGX0YdpQ5RPfvISfAZQOCH/l7G1xk21cy8zbAudRhHD4IEz81hHmgHbZqxPbpwRuEih7pQU8le6gME4xyG+p+KOuzBVjkmX9D6NDPslsxrjiDF5jaGQddSwPov6ZFuoPwDjhc6NdOE54GpJkLY1fJ+weUl9dUU4DvwbrJWJL36YXxJd9ydKj8JCHodNaCKngLEJhueG0WoWwumNu/DrileVsxvOB0us1tzqcnIK6MO4gHCVZNCtPaBjSy87DTJG166oO0XMObvWQpLa0QVAdGsZNXyvg30ZMAtv2Yw8yxLVIFQUTKXQHdumb2L7B1/6ZHNGQsbCsD1NVPkqnALDQxvg23d0kg54NRFnyw/LNGj1JS8f/aFyqQz+WWsrORO7inVD46VZTyRDB76MF2hryRP2xyVQcJIldgXr2mIK4mbQbtAJzJwjyI0qqr/TA3xVVhexDpwU3zIprFDdWLa5I6i8lr2cADkHtundEkxiDoSyxhO307nfsnBr2+NDKspf2Jdmje5UiyJiQetl1GsnE3BBaOCFhL/3bf07kM/c/0HyafTibbdfQBM2GqhTEd2vehC86Byv+oG483ZFNOjiQOt5ytbxfGGBeiiI9dG
 BBXXFNDj
 Wiyy1oWLufm/uisVFycKzSx/WnxXCsyKyk3QcaFsbKhDu3zI8CAKJo24j9lTzY9HZlmXNJ9IJH8u3njnjoqVaG4fJnxEiRUcttA4+DXeDAEr9wVncihvgmj9qB9CPkmZUyqYTEDeZ8lBo/+BmnTynkf1Ai107KmdIHUFohNXAVtug1IJLXNZf7dIAAi0rySQKxYhMQWo+4pE/D1WdXwurPXE1c2MoivrORJnnoC4cuyOdW8Zv74DjoMtbyxhyOYcd0zthu8dAE4lhb5hQr1MueVBWN+O6H2Z5Djg2ZTZ5SfUSC/OBgTol9uY8q/oGHX/M6Qt7CYyen7Tip+F3J+njxejNIF1kJnihkS1ziNHq7e5kNCDTsOW/fxQDZIjyZ2wirbO5DGewbIrW7tf23XwULx3/3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/10/17 04:04), Sridhar, Kanchana P wrote:
> > What are these for?
> 
> Hi Herbert,
> 
> These are for non-crypto users such as zram.

I agree with Herbert, I'd keep zram out of this discussion for now.

