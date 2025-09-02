Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73858CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 05:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7D5C6B000D; Tue,  2 Sep 2025 01:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53046B000E; Tue,  2 Sep 2025 01:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 941EA6B0010; Tue,  2 Sep 2025 01:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E48D6B000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 01:54:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D3D711A7DB
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:54:13 +0000 (UTC)
X-FDA: 83843244786.27.36FF69E
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5DBD040002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 05:54:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=goSKQWcS;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756792451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=isJs+BSpnFMCJQiep66pO9WoCa8BcyekP1bcFIWYWk4=;
	b=ihX0KV/53qzJWn5SDA8W0qRAfEa8iXQpADqN+lPIIYYMPtuqfQVAzUwcXE+KA/H33lvw+/
	XeEe0WVilYDS963X/sthI5guaxDOYL+hdd8kq5Pg4mJboI6UsJx23aZDpPoT1BZfMKE8xU
	AZUfhCqY2v0KY/X3MWhvG/f54NjX8g4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756792451; a=rsa-sha256;
	cv=none;
	b=pfuYcs2AzUcfrZxJeHgWUR8/brOuJSmgMCvFaKAXL1cX0/5fpkJVOzI3vfGSJmTypW3BUY
	MlayA7p8OBtyAXJ/O/gXhKvuD4aCH4rFD6P3Xip4H2DcZJvu7xq2+9nj5Ck8iUSnPRluBI
	exhL3+HkjdKnx7uznrJC7OhwLBpvKYo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=goSKQWcS;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-7e872c3a0d5so490045285a.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 22:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756792450; x=1757397250; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isJs+BSpnFMCJQiep66pO9WoCa8BcyekP1bcFIWYWk4=;
        b=goSKQWcSAntR2v+RE4+pjHCTn2iHnxl26Y9EezZxQVrg5c2U/NBvCInTARwfPq5xdq
         ObUui37WHLV3cN+ILvaDBlXzHbAV+XBG6EbSqn5CfsJW/iL33Oy8hZCHNNV+EVvFVWOR
         a7hPLcoyHie16Cv80wIxW/s0A+a7VMYWjwIzd6aQrR6ZmzYjQYIQ2UICWjD3KPZiRVXg
         sEJ5PYwD/6ySW+Osf87H+eRtUJ/FP0LPJtRA7cTA9CT3URtHpdv1ip1kLcQ1uVZyq+B4
         BxW8ZZU57ik9uwuNhTzZ5t3tK70+CZPezOjy6n8K/NjFvRLvLE/spUjQONvRDyHoj4+n
         0P2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756792450; x=1757397250;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=isJs+BSpnFMCJQiep66pO9WoCa8BcyekP1bcFIWYWk4=;
        b=w4z6Sh0uScItB3uTMGAvzXsQaVSOWdkKquutPuzb+zzHdmUeFN1yhnXeaB/1GxJF9R
         +GByhPBqoXDOU67Niu1arc11rH1U+bChLu48ePAMvQ52h3US6ooN7xGfFd4b75Cuiq2Z
         lWjNzfSeJk9H4IYiJo9HSiwDHOzYyQO4csy6iB5U39suTTAXP37iTIeyatXiODGQq2cF
         i0gZWjCvMzYii7Z7Zlo3TpDPA2BLCYXxlLxRoHhHZuVO4x4Gm07L2LaTY+esp9W5wkT6
         Fllgjdg2shvjaGTF1P/IiVDWpKLzzK2PQuON4p96+GBErRadWrC4V+2HORwLeeDfdXrX
         ZFMA==
X-Gm-Message-State: AOJu0YxeewdscR/H2u1B4+CwmnMVbOFSsKomb5Bx8nKiFPGHr8cGpXs+
	I/tmWZy86sW6C/55y7bTizgsbGN29fp06t3t9bV7ECB7tIwfw6e1SGSbc1SIWxqcMdEt6udy9QW
	K1T4j6YAfsLWWf8g4t7SXyfKEfJ1zk6Q=
X-Gm-Gg: ASbGncsvPwQ1cevmbKGxs1dyYW5uv/wt0JYMMIN2ePP1ZHqskIXomch+pQ3dWrpBrmc
	Y/IjlMpFSCAKkpZ8ZnLMBp4cInbTfLiGVkvXQ0NsTJfSS8EdTJXgjhPGsqd3EQh4LIey5RxvjqS
	KNAXsIFRVhrJEnAoUdm06skRrrGv2snm79fiU39nPWbGUqIGfNf2CBrk3A7sfuMVDHckEx50S10
	OZ/aTvZbOzOzqTv3w==
X-Google-Smtp-Source: AGHT+IElPYmrO2JTFGTxjWDUyyjx/DqHnegvZw0zz/eomd0JGXG5A2ieS/dE+0dPFtRgsGk2qNXut+znFJlw1YNJHwo=
X-Received: by 2002:a05:620a:19a7:b0:7f9:ec3f:b047 with SMTP id
 af79cd13be357-7ff26eab6cfmr1062526285a.2.1756792450289; Mon, 01 Sep 2025
 22:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-4-ryncsn@gmail.com>
In-Reply-To: <20250822192023.13477-4-ryncsn@gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Sep 2025 13:53:58 +0800
X-Gm-Features: Ac12FXyFe9ctWfEergz03QTYO3jAelSmUJtD1XyEOo3ep0a_AGCh0AaSBPxGPJQ
Message-ID: <CAGsJ_4wAPV=K+suQC+jXwa-vY-TXLECTfR+zeq031o+G1EA5nw@mail.gmail.com>
Subject: Re: [PATCH 3/9] mm, swap: rename and move some swap cluster
 definition and helpers
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DBD040002
X-Stat-Signature: 5dhdt7eb9pws5m4uz7byb97ch9zesp17
X-HE-Tag: 1756792451-875115
X-HE-Meta: U2FsdGVkX18b845dW1GCUlq6Y4AMREC4ku1Ie1k0iORDErGFyTGjdy/lFGksdcLddHjo/nT/CYsMo+Dv0QWydT5iVvoHH1O93qYq7tEoAWIXDBRog6+d7dJy9AniUS3Xh9AJbZGkOhSP3Qr+TKVouvpEPmDyE88wxwHX1Av/gYORsmnOmr3Fp8m8vl2dyCkgaDihd8H0pxTlu/bLNgSkF9Iy1dGabtZyCaXGCO+NeViS8x7+z9sEWS6Jg7nZBcPmLsjHnn6QP0C1QPQrolvApwgZ/nao3bGBvoF7GvDbhWmOsQTFRuLCRbfLeR18U+gV6BznC57bsFcKzmPcr5JI/risSEALlukcVf5c9AHFXp2BKdet4YtoJep8m6JHTG1eYnxNrm7DeO29Sbwt6bwl9LM1mdgoAJ4jbcWSpnjAE80vLLbhT3skfHkTYSz1vXKHAg7baG10YKJj6LdTcPmjSYE2PSQtB9HqySgh41y9WczfR9HSNmbux2VwbYTdsrkk+DbrS7D/YGNPpfDeDTodyI1xwgsSNDZl2agIs90fHDidOf4BkDGlZ91jqQOhlgeH8OZq37QppLG8NixrICnjugaz9LpvUItllF8OGbDDkOk6vxFgfoab0LYF39+u7dvkj9Q85tp0mbqX7/jbzogRn8m00HEdELeTmhsER4c0ZNHqyirnsFC8P+GbAN+Wm2s3OUQ+xwhbKMORxUh5/Wf/xBFUg6pgWymuMrPapB+M3y40+KGZXCk+1IIgKR3G5y6atUBV3nhVRuAAtkkoo4lTChTrtHUWlvYB9kEDRfgimy0R+cCvzDtf5G4Xf9uYZoHYI+uVrYb5Pu13fk0SEHv0l6eyS4MGvfTHQyb30Ldz+yOWHmuOwBNYGaUl//kJtvDb4UDn9lOTcZhBp436rOUUoxOu/sgdZ4/pZrkAeXYM4zZj3dPnyfoQmAaGjjCl2LAvfMm+PanvWD/vlxFJ+Qn
 0OZ/x/96
 +2xFiOm1CWOJE6fNyKN6QSRxZgACYcgOOQjW3cTXBflcxCr8fXOi36Wdc1//onYyZ3IORokuVLG+sTBBT0ivsUALW5e5WXADXC7lnjmVxQieP+0ywbWPGyI/4h8PjagnxkUSUAN3nPrRvDB0m/A81pGlf+Uf4Z2qhLAdz5YnWa0HRquhRb+QuZBh+DSw093D/B3niVbGMVRlVS1MMVtxS4ELXDlBSjmFQ2pfkUxdGkG7k4C1A8Bcy6IsAeXQ/KS0WkqsSMSZa1qsCho0y9rzWFrobZkhkrKcSM3JpfCJ9nNo/aH+7TdrHYR/l/9c656gz2b4xahHbv8boJ+bK+EOgZpIyUIf2Dw0KDFutREFLTgaK66I0JdsUwwThh4TnCrXGEQThUfYtp1TSA6bFeHqaohSQi2YQcM9Z76ehdiRPh3sq+Pw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 3:21=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> No feature change, move cluster related definitions and helpers to
> mm/swap.h, also tidy up and add a "swap_" prefix for cluster lock/unlock
> helpers, so they can be used outside of swap files.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

