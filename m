Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF9FC106ACED
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB376B0005; Thu, 12 Mar 2026 16:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E9F6B00A6; Thu, 12 Mar 2026 16:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB266B00B9; Thu, 12 Mar 2026 16:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CDD86B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:56:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D575B58BA4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:56:19 +0000 (UTC)
X-FDA: 84538618878.08.E4FE6D7
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id F34E81C0004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:56:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Phw/80eL";
	spf=pass (imf18.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773348978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I81kaNjLYEhYWPtg1AvVrZiAGxn58AVvypr+CpHj37s=;
	b=lpBk2Yg/7CcPL+/waFx4+pX4B5Bke3Luh+lm75cESY0MfatB+80MS+Zcg8f3Pv6Ge2EfOj
	E09LFm0h6vawLxH02yURKB4CeLg+OQ4G75ednpjNa3Y1X2NkOKtW0vdj0S6VGPysa4MZlc
	s2E3s7UmTRGAEHYgQxdlFNWyJl0wj4U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Phw/80eL";
	spf=pass (imf18.hostedemail.com: domain of hlcj1234567@gmail.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=hlcj1234567@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773348978; a=rsa-sha256;
	cv=none;
	b=jAqANWF9Y68gmgti96yIgVOGoNQ5bZJ/g5MU9Eq8qUF6HVOl8VC5Loq6mfLa9WvtaClaUd
	YSHJ72SWzZPANoEtcSzCMv2jTBU7tUYG59/wK1IVR649Y+6W612pAcKitiU4K34sT9LPWU
	2u5Wc+JUDOR54ZgAyGkusDWl/SxtWTM=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-506a747448dso12780811cf.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773348977; x=1773953777; darn=kvack.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I81kaNjLYEhYWPtg1AvVrZiAGxn58AVvypr+CpHj37s=;
        b=Phw/80eLQihlJRbqieQRD3Z32zK7yJ6mGiKzn8iSpu2nCY2L6KCXr+7VvLS3yLeCQa
         yA3uO1gfpcKJyPZLjhinkC+DhcNshK+3CcSfzWccql0qBGxyoDElP2iCdVMH1+F7A9AZ
         YQfI92jz6q9TdUGlIBngall8AvacOcvHgyuWgvQqIKZ++DCYHLj8m/HPDNhivHyi9dxU
         /NboXNad5LwpxpDn10f708XTAfkINdeHu4GJwhcF0M3wv5Jcb4D4GAATTflUHlCiQkMk
         ewiowAe1LV2T3+I9oNs12nDrYVAPYZZ5/a00U8gGVPHPfCCo0AVl/8m4aS4bBxWYK2p/
         iseQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773348977; x=1773953777;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I81kaNjLYEhYWPtg1AvVrZiAGxn58AVvypr+CpHj37s=;
        b=WQSumFXMcMOKUlpw1d8UplUVZw9LQFrDN0KM5XutVUeC8h9A7Hv02Ti6yr29j0b+UN
         dcgzclUuatw3xa5Aa8JY/6NXc8O8jkGjfFely4d9Dmft/LEdNBJQa+3HUXeY4TStO4/M
         lVI2H7LrWdxsTtQqogcd1q62u6mrPtB21/r5l3RXZMzEHCIssXiWFUC287osAhYiElrD
         QJ5tJp27AVQ4wCNS5/P0ryCqW33H4bsRCbhcQ4s/DoFhQ414fATUxBwgAAhnlXulbN+l
         4hGbF58n5CfOnNkQKbD0eaFho7iCmmyzd6xn9/JJh6BKpPtCocZX/TFWaSJtEH2q7vWy
         yjrg==
X-Forwarded-Encrypted: i=1; AJvYcCXClsn9cJNpS+YAH410/cXpDk6/UKKrShAuHBpeZHrNeBkbYFiSctLzoUVediIdz1JZ8yaT5tutdw==@kvack.org
X-Gm-Message-State: AOJu0YxUrZcmCk2vHRbRmShswuU4fAS18hc7DHX+DbwFPb0xDPNQavw+
	fUm+0buB7KgHJbm+RWrNcnvLHnPrpgNEPDRIlzbPWiP4NyAmTpoeNQc4
X-Gm-Gg: ATEYQzyJHK7JbkUTvGbNnLONUJrG1dTMqzn3suoRulnUsNiqql30RR+OSgRAKLx4vJe
	HypLrWVXyNgc3ZoQT9gqNdxmaZ6DZb7+1pGaMm9qYXZpBVHOXi3M+KNZBqJ/XTafG53FT0H5Q2l
	vNhAHiqWd/uKlX+RTgcD1Lu6Td1wFWNXvS4ntP0tlcbFRf8ORU8fN+D7RGyXwpsM/v8qADTiTGR
	lQSE8SBOq+I1y/vUao8IcLfhAP712uD8E4PVzc6VI8TvAxl93jTzGfxlKpEY29CbPpncWO1tLza
	F6nVP6vlMnsj4tJ28CkZIOt07GZaMA0FMH0rJGaerAvr6Pet3s4QB6DxRHj0/DRAhMoX0NYzExd
	oGcr4KQofFvDpk7Js/wGiGr7pq+Oe6pNX8eab1EqwvyS9hXZ71G23F8lvQyUAFSITMX4kFljCW0
	gWm+TSgRCozfgFlv8Geq75hRmqduvOKHGIXEic
X-Received: by 2002:a05:622a:244:b0:509:38d2:858c with SMTP id d75a77b69052e-50957e10b71mr12563371cf.61.1773348977030;
        Thu, 12 Mar 2026 13:56:17 -0700 (PDT)
Received: from ?IPv6:::1? ([2a00:23ee:2968:90cb:1c6d:1979:bcad:501a])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65d1a3e5sm40190786d6.50.2026.03.12.13.56.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 13:56:16 -0700 (PDT)
Date: Thu, 12 Mar 2026 20:56:13 +0000
From: Josh Law <hlcj1234567@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Josh Law <objecting@objecting.org>, maple-tree@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <14071af4-6886-43ac-8502-5f5c9763cc5b@gmail.com>
In-Reply-To: <b6327414-237a-4262-bf07-c506908fa263@gmail.com>
References: <20260312184054.23481-1-objecting@objecting.org> <20260312134531.49c1f9171b4b0bc8352e678d@linux-foundation.org> <b6327414-237a-4262-bf07-c506908fa263@gmail.com>
Subject: Re: [PATCH 1/3] lib/maple_tree: fix potential NULL dereference in
 mas_pop_node()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <14071af4-6886-43ac-8502-5f5c9763cc5b@gmail.com>
X-Rspamd-Queue-Id: F34E81C0004
X-Stat-Signature: 9pw3gwbsbqkj1cxxjiqay1bkdg9yeh5d
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773348977-76164
X-HE-Meta: U2FsdGVkX1+I3OIbzE21+tr4i+zELQi0W6kNE6vtyYzrTTHygW4AuTozdT4y5nPok1X7F6rER+aQtUgRXATxgCM/VidPBGBATcrkVlK9UG4MYr7uF8Dvys/Xx/qRBXCvqT5Fhpyi8UzSSf6KsJ19vaPEHTsV50AWNddLuTcr4sTsFZgYY9jgszToAqYea62QwuK5azlkl+i2RD18m7jWInhIE3ouQUkAALE4NMaZcJ1EDu/0lweJnYaD/AK5BEngp1JcBM3R1APnEdBeDohyXcWMiogPhWKSoHxeUyJOKEbC2o7iUHmrAekBPTrv3/KON0dj3E0eBGWA8Rg+xRD/y9MMJTtv62lXXTwkjc4MWjTJfVdbFGgUz13AIGT6wgaFh6AOOcLxJN9deVEG2EJjlne93ZjyxWF7wfSt/xnaw4FhD3ootUJPH9f+iMYtPE0CatvsAYHUUvFQEaG7wzgH5GYbUi0PGEQ7iKNAhc89Xj93bQpA85wcbKuFgVIqHT4DhyeADYfTPRcTjflo1HteCqX6gvatHthR9HQ6pXudT5ldBbhXElcD7mKTQ0YPosyBdG0Hhl5yCaUAHS6hQQAI2FY3vlvkbCWrX54KOn0C+htlX5rYRSXiKQyWZk7a6VKSaNSti+QVlyqnmLRxJtCpCPDTZ7g/CADwyTXarbkc06D9oZSi8yBWD0NuDR2YmPJlShS+eA3+hP9GbgpFb0iXVo4HY6iLHyW7buhy2VD3TwDnn7SHejtvQKyh+mytNWrN4pbdfl3jUrbAnHn5daPoTxM6hZJVKwjcpV2mXYH9l6AVan3onF+tLKfD6cDrkYhT37wUgRIg/tmKFoqdnawXIfop3YlTebQPZNCNOBTrFdslcNgnB/JdWMT1566RsdNU9jR35B3kSLps8wAMHGx3YsYnofQl3zudtULHaCLMAMzSklIYDfYsIU+X1o6MmwN7Iwk2Fd2gV0upSAcsNFi
 TVJuqUEm
 dw5MXyc70KmufMlsOAHh/4d54omMfITnGsb3Zgj//hXif7Erf6IWpYfoyioNVCv8Et3pKpvwj9SDzzP8pR98oxyhpeQcCAwlsuOENDXj0o30Uxr5x6L4KGtAVjWj3HHkYF5Qdquf+l7THul+1xhWbxWsE2un6SYj1QI5fbq6sK2j2rlv5en3BuNL3iDy3PbD1uAq97bWIpiUhk4MKr4mlO4Qh2L+sCQ2lIT9/eAjaNKLFm3mKwGagyoF7xhCoLdM2cXJgfcBFG4qkMp7bz74blj5rpqsDMy5KysgaBx7zBZ4buVp4SBSuzws3ZEjG7w7+UiuzRjs3QyIsYazKHu1leaYHal4lOSSXRKDe4heCpiQcnzxSYkiQ+E2UIaHTnjailmUlhI0eloGvjai1BYM6w1zgncOXQoRn+VZmR8upj6sBihby/JKN1kMY/krckbOjXWq15dZ1v18Vc0+cMbgOz67npwir9IOj5Hgf/h8pS/0VqSZ+EBij1khhETGUBQGCo07lTGpS9210a8IpUjJHY2DbO8ApSuvcY5aed1sstIYR0JiM2/gmSaultGYjYR/cPWK1tHVdEiaLuewhlMpOQu9OB3xBGcK6soJwbnCrtLNSk41mHOGIVLUyVxPyfU+KW3Tu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

12 Mar 2026 20:49:21 Josh Law <hlcj1234567@gmail.com>:

> 12 Mar 2026 20:45:32 Andrew Morton <akpm@linux-foundation.org>:
>
>> On Thu, 12 Mar 2026 18:40:53 +0000 Josh Law <hlcj1234567@gmail.com> wrot=
e:
>>
>>> If kmem_cache_alloc_from_sheaf() returns NULL (possible under
>>> GFP_NOWAIT pressure), mas_pop_node() falls through to the out label
>>> and dereferences the NULL pointer in memset(ret, 0, sizeof(*ret)).
>>
>> This is such a glaring bug that I wonder if we're missing something.
>>
>>> Add a WARN_ON_ONCE NULL check after the sheaf allocation to bail out
>>> early, matching the existing pattern for the !mas->sheaf case above.
>>>
>>> Signed-off-by: Josh Law <objecting@objecting.org>
>>> ---
>>> lib/maple_tree.c | 2 ++
>>> 1 file changed, 2 insertions(+)
>>>
>>> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
>>> index 739918e859e5..87a2ba6468ca 100644
>>> --- a/lib/maple_tree.c
>>> +++ b/lib/maple_tree.c
>>> @@ -1063,6 +1063,8 @@ static __always_inline struct maple_node *mas_pop=
_node(struct ma_state *mas)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>>
>>> =C2=A0=C2=A0=C2=A0 ret =3D kmem_cache_alloc_from_sheaf(maple_node_cache=
, GFP_NOWAIT, mas->sheaf);
>>> +=C2=A0=C2=A0 if (WARN_ON_ONCE(!ret))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return NULL;
>>
>> If we're going to do this then we may as well restore !__GFP_NOWARN,
>> get more relevant information.
>>
>> But a GFP_NOWAIT allocation attempt can fail relatively easily so
>> callers must be equipped to handle it - perhaps no need for any
>> warning.
>
> Well, fair enough, but WARN_ON is equivalent to a "oops! Something went w=
rong! We will continue anyway", NOWARN is quite bad for logging that that w=
ent wrong, usually it's BUG_ON that causes said kernel panics and that, whi=
ch is a bit overkill, that's why I didn't add it, and it warns once, then b=
ails, that's why I'm a bit on the iffy side about adding NOWARN, what's you=
r opinion on this, do you think a NOWARN is better then warn on once?
>
>
> V/R
>
>
>
> Josh law

I checked the callers as you suggested. In lib/maple_tree.c at lines 2352 a=
nd 6039, mas_pop_node() is called inside loops where the return value is us=
ed immediately (passed to ma_mnode_ptr or bitwise-ORed) without any NULL va=
lidation.
If kmem_cache_alloc_from_sheaf() fails under GFP_NOWAIT pressure, these cal=
lers will trigger a kernel panic.

