Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06F3FA1FE4
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1601B6B0092; Wed, 22 Apr 2026 14:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1108F6B0093; Wed, 22 Apr 2026 14:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0267E6B0095; Wed, 22 Apr 2026 14:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E57126B0092
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:48:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91EA01402D0
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:48:55 +0000 (UTC)
X-FDA: 84687078630.18.CA38B9B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id BE54C4000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:48:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TBPqydOu;
	spf=pass (imf11.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776883733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1v5iZXZ+Zp369IPCromLtLEQoKWJfedhJQIDvQsoHA=;
	b=fJ0GZ3geGL6xbFH+DSU9Md38jLQUMP4OMYU8Ep0eGwgMdziJfo1Go+I42608HgICV2VqF0
	0U1tdwrmqXzRpPtdia9XtvB3hVMVveIYgJJrktqXEUZoEgfLlKllRT51NXQIkbZBkNEWYh
	Qd8AtYcukz89FZhpxB5JGRY8o/apPN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776883733; a=rsa-sha256;
	cv=none;
	b=XTZgR0gw6yakL0z8MQkFCZyqwFzYJ8MWRGtfExurGOa3tiuWywkTf89BRbez/lV/s/97kh
	VIS+ZwMJgHU3BZwn+N2ABk1d9HTlhXzyH6QsSKgOamHpCRtBNBDgtVPrhIwhW6CHbR9ZA7
	STF+JjqIy301iBfqB4uZw/kWj7wAW1E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TBPqydOu;
	spf=pass (imf11.hostedemail.com: domain of joshlaw48@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=joshlaw48@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso60807165e9.1
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 11:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776883732; x=1777488532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a1v5iZXZ+Zp369IPCromLtLEQoKWJfedhJQIDvQsoHA=;
        b=TBPqydOuUxl+qvp+0tAxC9Z3APxpX9ZShanaDnTU0vnU/h1orcugHs7CEj2u6bGwOG
         JMWjj1JGc+jpLdulO7Thn4QWazlS8YvK0/WF/qY21ED8pe3BQ0ec8w51q0e4fqqDwQ90
         XpB48l0mAH96toMejSLvkRTpqOn0sMvXGCNq/fIR/fcC2WHj3Lfkp2lU9OVxO5Jss4S8
         OB9kmmn1wIGorJfoK7Pc4bw6b5AbUiRZ2I5csslc23aNIIvj/25Jbvuau+CKvK0jzvUe
         x7LZPn5nqfnbxDGTNzyK6v/GAz1HxUP8uAkIqK8ehIaiePTvBs9V5RNeizQSmmdPnDc7
         5TGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776883732; x=1777488532;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a1v5iZXZ+Zp369IPCromLtLEQoKWJfedhJQIDvQsoHA=;
        b=i4xs2PoUIbsb5eCYHqtybIETXe/adVHpLz0HOlAUAb75gUk4wda+NMPsBcyQLVrL5Y
         29ARl9qyEk9mCoglM+4g+WyGbRJxPjgoNy65yTX9U7myZEVVssaBPEIifwtZxL8xCKyh
         +xm1Kv276g7QnuA00CrASzTA6v94KDadUp6Zg2pQBAWnU4oWXROMUWa/dTM3d2JzD6i6
         y+ZJ/u0l1NO/eGx9iAwEdbvouLeOsomnDN5b2fCXH1AorImYPta9QAp4quVPIh0kLdRo
         w/weujeWlGFrPPuO1Vw8gmBSX3GjLlqBG6wlS0Oqc4WTjB1lxdSu1uTQhndThfJwKrRp
         0L9Q==
X-Gm-Message-State: AOJu0YxBxdMjdSVAqNkftjT9iqJjiaXs9f+lUdTnPgiu0rHlEdR6lEJO
	gsPK1PPKB3/BC0Ad97xyGf0D7vqiHOV4BbQwfss3TAhNAK7Pkr0kvgK+
X-Gm-Gg: AeBDiesZ+ZWCLkEt3tq4w1bm68xDQq+W1Nc3Z7dkrfbQS/7KG22DU7kHlWcOHI/K2kB
	U8dMoLILSjpampZGVnTadW2kuC24bk2UHoae4rKp/UFspgqkVPKm/Kltc8AzoYwPS5Y2bxOLEN5
	ZO+J5aXsHQAxHZicg3aUH2igiGu2e2e09gfOowzjs967NiJJompKyem3+63Sow/xWReNH0O8xXW
	12nCzgGz/CEFTgLiBPEkEfYMn83OeIwpnwlXiqawaRUTpJgYlMJNlXHExzI6w1CLdk1+RswT3ry
	oGA0e63UlCibgPjzSMbGG2ny+XFz5bQ6YHHN/NbHxIR9SloFZepwJrKHtIU5Jw1B8x3LUOogWP1
	a0ELUjhK7qxDvWZSUQDH/LYhq2fZL/VSpBJXvw1b3kwQOhQyjFhjlAW5dVN0OqR38Wi1m3KKbm4
	Fx/obrXj65QON5DW7dsTajBZrn11M1nhhGbhbjOOZzOAxw4qI=
X-Received: by 2002:a05:600c:34ca:b0:48a:761:5816 with SMTP id 5b1f17b1804b1-48a07615b87mr152572315e9.8.1776883732086;
        Wed, 22 Apr 2026 11:48:52 -0700 (PDT)
Received: from ehlo.thunderbird.net ([2a00:23ee:1cd8:21c1:5419:8abf:1a05:5c5b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488ffc5e3f4sm247124255e9.2.2026.04.22.11.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:48:51 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:48:50 +0100
From: Josh Law <joshlaw48@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
CC: linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] MM transition
In-Reply-To: <dd27fb14-38f4-439a-b5f8-59149e6fc6e4@kernel.org>
References: <16B7B5A8-EEA7-4580-A565-3A0B4DBB08AB@gmail.com> <92c3d650-be80-4a64-a962-3586ba753316@kernel.org> <B2261993-3CF8-47EF-9F76-FABA6BB4A50C@gmail.com> <dd27fb14-38f4-439a-b5f8-59149e6fc6e4@kernel.org>
Message-ID: <4B3D556A-AEA8-4143-85EA-CEB76801B879@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4xfb1rwpasj3hhnhzkh66net84fnqoek
X-Rspam-User: 
X-Rspamd-Queue-Id: BE54C4000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1776883733-616699
X-HE-Meta: U2FsdGVkX1/L+smT1OwkzvXsDyYWC+meJ2rHU7gPu1zI9fhmcVycl5xtxz07b/ypk9v2G2vjzs9m/XsxJf8uv0Sjzvt1UNBSCCJwjshqFA54vUvLjEDsSIDFm0HryqO7LNh1CKdB6M6ZIgXbo5GaUwKKL+iHt0SpgNzF3nXGRm+fdud9tyN0qLGCUf7zTkVapETLrTx8h7aKmrJ9jShSQUPRJmrPj2DjATCKDWyQrZHoCl6/IYOMDXov2IL95oj5V7fxR2S4WTFP58WaKKThNhmgpzUFFJDcCLv/2qjgv1gX+yN7HpJQkL7lXuUl3odNjAConfjf/RdBW6F6jaapOAFqVOb8lxX/xFcDwXGJVGWOFW9MZEpnkBJVaosNBhseBpU/cR1tMiTTPwIEenLFAvsVaYSK6DSlcWxoc3Q/wfLrnjMUw4DOMJFkdaiJsTMEllLGpDGP39WKGwf99mDJg6vbpS/2AKDmeDHR3wjCrWSS4WtO/Iz+oZtun1TM6lxZ+0ArLqvcHBs+R7PzCBYrknVNeDijGunp4dTedFFyqlnrUnIm8sBTNJIUKMFaABDUnaEzGSzjru7HRdM3AXaR5t/ywwL66AAkNcarcDAcTEgRwKnRE+JZSS4n89rOcdfkZe4rwzL1pW1rvmW419805DWfsxq4yTU6phbP8HV1uuZEzYXeni/OvLQwmgVbnYbiqDo0uMTqcAmR4SVgjJv34Y6yH25+DJrjVI1Fc8hnGh03fgHuEMCKPwTFSUfyjJJjjiFFElFz3VpLr9X5sLtOhhCP4D3uGasKuItVRlouId3W+5vD3BVBy+HxL1l8wxOK3kfho972w4LvOoWZwde4qhfqtu6+LBIlSYhqrhGS/HmsUnVuXIox96itXrx9ZnWEEkFjy/3divS0f68c3fOAU+xOVT6um6dDibdJIFM2z+4YiPynxdg/RIenqi+tJQbZXyDC1rFXecT3uy6+flY
 h45j47+V
 WLau+4+VG6el1FyrqqbdDDeMx9vpQXQbRjMhJq+ucJ8jYk3SKjWAdPSrzGEJS4EEFD1819QY2ovWyGOb0JohZbWJmM7N6RTmBO6MSaBT6Wv2hkG0ihYupET5ZZhUnhcpv6R5ziUPzWWzNzIxTZVWgP2ZiTlulGkn2dNi4MRBWZRYV7O69fiYBYzt1PFKrT7fBtkdnJ23Q/ZlNMSVOlLuFF37ijlUqxErx0AvronJ1hzwfgLR9c+2Cwb6TN3VGemkBUjV4ARTJcjvRm+fMo9t5Fb/P+QN9bfcz9r8crUIJd/kOU64dol9dDmUESVAMROcKxzFhqiRch3Le8CfQ3oO/yGdmpIT8LW5g79AlJV9UXTDjJN54q42+dvk6benkwq3VrQ6UI5cPp7skSCqrpY83DCs1p2S+EueRv5kmJne4aryCRufaWBJbsXUWK1LpRmEBNbqEyh6CTZlIam40+OAIAcKHoutEfXX20/Fo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[Snip! :)]

>
>Yes, but he also writes (nonmm) "it's pretty quiet" ;)
>
>So, MM is the real struggle.
>
>> so the (basically) orphaned files like glob, or smth like that,
>> could go to someone who understands the code better and more likely than
>> not, has time to review.
>> 
>> We may have to have a think about this.
>
>I'm sure
>
>(a) Andrew will enjoy being around and we will enjoy having Andrew around.
>(b) If Andrews workload is still too high, even after MM is handled
>differently,
>    or when he wants to completely retire, I'm sure he will speak up.
>
>One step at a time.
>
>

Agreed. If he needs help reviewing patches in lib, he can feel free to
CC: me, best I can do showing he helped me when I first started :)

I'll enjoy having Andrew review my patches, he's one of the most polite
maintainers apparently.

that's why lib/ is my favourite directory!



