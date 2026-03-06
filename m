Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DF0FFCC062
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 20:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1FA6B0005; Fri,  6 Mar 2026 15:25:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899F86B0089; Fri,  6 Mar 2026 15:25:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6606B008A; Fri,  6 Mar 2026 15:25:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A6A56B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:25:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19A7BC264B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:25:46 +0000 (UTC)
X-FDA: 84516769092.01.30E9C63
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 28DE240004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:25:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="elwGjK/R";
	spf=pass (imf17.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772828744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fL2JgYqvFgG2jo1CEhVYJcdYaruh0cGQxMcZdwd8dvc=;
	b=SoXA91ohgolX6tYDh4chU2z69ELOvmaW0hqNJTmnVt04LnSWPwkSyG9xV2ZB46ZalKcdk5
	hEHcLXVeXzVCHsmaEJpK9Yo9vm6E+NhmONoSA/5yMrXKlWshGHbTaWRevVa/V0uKQfQI3M
	+m2mzek+XMeibyysE/qOaU9bfGSkSgM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="elwGjK/R";
	spf=pass (imf17.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772828744; a=rsa-sha256;
	cv=none;
	b=xKvRMO9hKOhUg00LFEwP0+k3vFY77ojKk3GUdam7LoQNCA28qzvHCPERA/H2wJYyD4Vo6b
	2RBUGskSLzimtOIi8maKgqSjGgRnIeJCpMD673pd1EgKnJmwjjwZ0ZICkbMH6FHDKK8Gjs
	q09+8pc4DAhWQEYGiHirtFNjSFoSaec=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4836f363ad2so112478185e9.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 12:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772828742; x=1773433542; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fL2JgYqvFgG2jo1CEhVYJcdYaruh0cGQxMcZdwd8dvc=;
        b=elwGjK/RggDzktnl6Y4NIyWq81OuyE9TxERAychWH5I6sQX6Bk2gcIUMtxdZrswPgn
         8wxBs47pskbS1DhP0qVK8QbOd/bs3pfVS54C3AEfNvvErwPTJ4Not82EeWqB9lqW3Oys
         C6jjXzOOEhHIRUDXBMalFkqq46/NX7h637w0uysPc3y3mR/vrqGG/NaNoJz6okhLtGoE
         sKbAHWy42k28FMevfi+jUW35MUHqFhqrOercwka2CMH4piCoQUmBozgPon5b6UHwXlYW
         QgYxatiZOlhYegMwst5jmSFDGuYw1Xf+rfR5j1U3BTCM3QCpNahc8JeC/Z3dTS6H4kMd
         oVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772828742; x=1773433542;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fL2JgYqvFgG2jo1CEhVYJcdYaruh0cGQxMcZdwd8dvc=;
        b=XGx2G+ZWEpC+mHTY128fMe3ZdsFF0UvE7ab0RPXPxee3qpFGic1l3FhAEBmUNkHP/u
         ismRlTmGnDSopvrQ8OiDnOmTE9aS2XSujQoYfZSz1BPXTFRptdD/fpWnwZyRZTe8yJ26
         XRQq3qT0dV5s2b+2FdEnkGcr3cB9kpE7EJymC5ICtAsGzLQBJ/Ov8F1j7EE/VKyF+1fv
         TMkaGkK5Ye2UyplS606c8BiKBSAkcTNNwZkDt3m7PYW1YAz/5rUGWOZptZKXS/3WpZvR
         zZcC99ckd0MdxJPDo03X8fBIfmee+/UnHB3k/Au5ETj5vvkbm91JPw2e92csS15k8l+T
         m9Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVnjpVnP9JHJUHSkHUiIYj4tJpIubbcxN53ly7LXVo7coA3o9jBBM+wXO1Ojl665cRO0iDRg532hg==@kvack.org
X-Gm-Message-State: AOJu0YzzenvGTVUarqVlo77xyvP0XB/r6D4/eBumhBpneOoV/tsVPZyO
	63O30m+cso13YERtPMX09t1UhAAmh0bpVy5RD0vq3tEYKFrUzMVtvFUA
X-Gm-Gg: ATEYQzxGs3Tx+gTBy2r/R+i/BAHrm8eci64F9qH+uqrKJ4jirwuQw9He0kiWAG19Uws
	aaZVMugBqdZwgwe6U+Y6xfxe1qgHAtiqwDWJHtVUPK7atZm/Cluyb026iT1cAKHbVU4O3rwlufs
	ED4fT7wr5PMtJVrfkmraDut1s0Zj4ZKsBI2U+4cCwcqv+hZ5JS9/QJxrsNhuyxy/m9dZ4iLr1Dz
	F0XN+K0CF5iekG3Rv99d4bXYoKSQ/8w4eg01IcRgXiPOKUy+2iqimuJaFUu4r2CTWSrBhhv9wel
	o0cLqrKr+G3oReUpGboC1Zq3cMhXd6y0/LpFA3K70+f219TkaXCjhovzVsj675OW0t1rgxHFXod
	NdGbqp+wPosRhyzBvoGr9lEswcQ6rWqg+TTlUdli58PvlGUNrh/F7QCHJS3pSuHgF81lI46tnFg
	xPQp4AS5bQMhUQZdsB
X-Received: by 2002:a05:600c:3d90:b0:480:1d0b:2d32 with SMTP id 5b1f17b1804b1-48526930a4fmr58858405e9.12.1772828742211;
        Fri, 06 Mar 2026 12:25:42 -0800 (PST)
Received: from [127.0.0.1] ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dae2bdf8sm6376995f8f.25.2026.03.06.12.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 12:25:41 -0800 (PST)
Date: Fri, 6 Mar 2026 20:25:42 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Josh Law <objecting@objecting.org>, Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Message-ID: <64ea7b4d-1d55-4d9e-8fef-396613e8bc10@gmail.com>
In-Reply-To: <aas14HsY7dj6jTDZ@casper.infradead.org>
References: <20260306200319.2819286-1-objecting@objecting.org> <aas14HsY7dj6jTDZ@casper.infradead.org>
Subject: Re: [PATCH] lib/idr: fix ida_find_first_range() missing IDs across
 chunk boundaries
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <64ea7b4d-1d55-4d9e-8fef-396613e8bc10@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 28DE240004
X-Stat-Signature: tx6puwnrnxw38wrnmneybysgy6cej3wc
X-Rspam-User: 
X-HE-Tag: 1772828743-721141
X-HE-Meta: U2FsdGVkX19bTHO3IhKRw3JEH8cRWj1+r4ODHxZa0SGKsgar68P8HEoiwUEK1jyBu3DqA9IlNadDRyZDGCLlt1ZZzEEIlD6iU7ne/8rh5SiUGKrWaJUNLvvq1hzPYjgVygry4XXxs7LpnPir4zr7gUM46xJpxYZoFqjRqNcGv4ePq4d/8QwSMnce/o8Q4IegoyNd8P4Dyag1k817EW1mH4MeBCkHMuojoFWm3gbRIjuDhBgyGwf14zTfFbeqAp4W6jcX5iTApoQiLsEeEy01Chv/lIjhrYm68JgKGMYY/Ws1p6lpkTvcgqk14tgNzYD2uo+jRRZN+Tw8oudHVu2hYVMeFwVrrG6+cq98GWpgIwV685ECt7kOqlLBL9dvO7ASdb0PhVXbId2eJ0ZReOzbrgoYVR8IDTrgspgQMVR+KH8qYDixH9j9Ht3+k1XoFFy7yczJekPLjvGZJDeE4vwdh6mod5IPtlG2v2aLLOljn85dFnjUGClpVV1qHZg6s6EdtBLpRxAboi7Fpk9a9FbCr2E1biYqVsj+rsab9TCFLsVrRyjXsDeP17UIjU2NlCcAuWyHxhEgvBBVj8JOdiNtPyRgb6gH06o0pEJfYL3fwkYQ95th8yeGc7zFxldBcBN3KIL6vxBTJsSd7do2X0nJvuD2EMPGNFuPtCmH6nG+6CoVcCzgwzPBu4eSwYiasBK4SuYYSMfLXmLo+qkOp9jNGLJQhJvlxQGqVxfCk5b53QoIT+YDkFltx8QSTUQdD4W+hNFgCjYMmIIyTORSR2I9fb9QxeDgDbyn0+EYuKVOdmB4WZJs11RJ53FuacjUORybcaETPJ6CKzfbhFwly9iMjS/rjxQUsiMaq5vFqpOgA+nAetgC/7tE2k9QUm48gQ+uYuZW9qDDuPWwXlQpJ9pGtUJpuamp7nx4befnGc6PUPGAWFmoazDZzhJ9AulyGdvTVAcebQLWskSqMSjWcvG
 jHOCJzfu
 llHh2Y/89j3XSLJ/qcExHxFIjoZCYTi06Yxk2waGCICMJpYOoxOQ4m9AcvpoY/hgVdB3o8AvbdqMpWBrg/i8VR2eFRk2Ya+SXYjKhRo+gSCpX5BAhdsQBHZ2CL6lpfLSo9Qg8DrhPrtgnIUzrs4sBRmnU9/ZmyXHjRLp8V6bvxn71eZoCIM1qaEOs9hgPlzIP80i1VwBrKYHilbq+LMZ7A68j6WAG2djo8WuhJ0IGEuqvgIWBkK87wJwDr3trj42QkRWxZCW7bJcR28bo3G8GmAdCYlrf+7hBIOQv9ihUS5BBPWXQc3e7MPf4DCDD4YH+TzLMeS5trAeOMgZDE+wrfSphZurzw0gMV3HbLJTQrKWTjSkLV1nMxWQyBAxpBsCPtFL8jWYOwJ0/Ulob4NLJV1ZcBLo+eYKjjyZILHHOImQpOIxTxsHdqMHJKVah05ZYF/i5yoGInTgj36E8hrExQgCjUb9pQpguvi5WIwz2KsV4G9FucHTmL4e2rEWEm3cmzC70EJSFO10Ytcb2GL5EMPzijeTT1RJ1aIU/wUExXjXZBs144a8eabeXC3SolQyszFRqAL/WKcyr9f4PuX9wguffKwebUuryeI+vI+eOLXndox5hyThJuJtCb60Tw3HXXc7Zl6TdEa9gIaVLCkbKw3xPOBf6piWaXf9f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

6 Mar 2026 20:15:29 Matthew Wilcox <willy@infradead.org>:

> On Fri, Mar 06, 2026 at 08:03:19PM +0000, Josh Law wrote:
>> ida_find_first_range() only examines the first XArray entry returned by
>> xa_find(). If that entry does not contain a set bit at or above the
>> requested offset, the function returns -ENOENT without searching
>> subsequent entries, even though later chunks may contain allocated IDs
>> within the requested range.
>
> Can I trouble you to add a test to lib/test_ida.c to demonstrate the
> problem (and that it's fixed, and that it doesn't come back)?
>
> Also this needs a Fixes: line.=C2=A0 I suggest 7fe6b987166b is the commit
> it's fixing.=C2=A0 Add Jason and Yi Liu as well as the author and committ=
er
> of that patch.

Okay, you mind if I put the modifications to test_ida.c on the same commit?=
 Or would you like it on another commit

V/R


Josh law

