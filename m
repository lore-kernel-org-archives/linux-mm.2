Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83654CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEE18E002E; Mon, 25 Aug 2025 10:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A86648E0001; Mon, 25 Aug 2025 10:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BD08E002E; Mon, 25 Aug 2025 10:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8226B8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:48:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07F9911585F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:48:43 +0000 (UTC)
X-FDA: 83815561326.13.6B05588
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4B7368000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:48:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VFGz6IN3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133321; a=rsa-sha256;
	cv=none;
	b=YZEzCIdjsey7OSnKosobMhEGHLgC47bI03+V+Y2PnpakygQ9tMqfvGm1TUfhsCiSKFOG6H
	tn7sHjAj5Eu8NP1Kcd7O1NPwig41U14PKOclll3H3vfKe/h4uXJpNWK8AoG9IpPgjZgVUq
	10/mYvhUOOznd/a6xINdmck7N2TSkR0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VFGz6IN3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LaBi4h9qQ27W+z3VVAxCvJfwUOkIuGF9RWMFwT6gLh0=;
	b=1b0yWZYq1Dq65klgIZZaru7zYYyVu5KWBXRIMNbSLrLWEj4SJQtcpGY5OhpMWtZaAry3wn
	4zdHc0JCamFUaAoA5rL2f0W/ZR4M0HgEwoS8ukpwQmnWtEBAepk2VgEd6ptFYa1FajRyPQ
	r9AFLr3WvxGEIGRvw0+63wfN4ul6Gss=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d60157747so35427847b3.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756133320; x=1756738120; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LaBi4h9qQ27W+z3VVAxCvJfwUOkIuGF9RWMFwT6gLh0=;
        b=VFGz6IN3KD6O15WAxT53yFHgT5FxtTB3oAjh/yHK11QDBF5fwY0msketOgCDUMa0Am
         KMcWdTTZ6cYI1LXhw13CPCS3vl3Y2aTa8gQ/XoGzgnZP7lAjRp4DwlrPn6VBPWlA8VRN
         XbTMki3p2Qne6e1CmEaOBlMn+tZkb5OikalWdpYI5io0mVGefMD8XV/Ds2yqIqjgHhni
         PPyskzOBm9ss6piYL3mz5XU99OADQEaXmiwJ7ucBChWozqwFYUJ6ajsNGzoJWV25uudk
         MxRlhMmi5STKG0QvbtJHx/NgjndyW5yUcTKKF/zkBiQjVQq8EvbIhtv7QV+rSw3Cx7z1
         LtBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133320; x=1756738120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LaBi4h9qQ27W+z3VVAxCvJfwUOkIuGF9RWMFwT6gLh0=;
        b=oZlY1vuxRoH90kEQde7xPYVyzmSqJDTG1MMar2rWgOaE9L4uqeU0NVNv1ypkDUEQkH
         eaAAzdq7/MWapiTBc1Jz0b+EpX7pTrgEFw7n5Nv6OdNAK5hNoc5XVSStQJj2v3t9/n7c
         oiis3588Cc4H0r/IjeKfwaTS9n6dv6b4yuH6xhbsOUxe+f5/el+p4zyeB3iC6xyLZ8no
         hU4k+SnOGKq6/HCY5BGEXfmmNk5wNy4ekNdOqksLU+ZOHp8A1rlvlVtwpwUE3cVJ9ga1
         Z+g/fZ1ckejxf5d9TLcvbelVzP+V/0dokdBpkdqOTSe+AtNpABsmzW90ftCGEnQKvM+I
         /yxw==
X-Forwarded-Encrypted: i=1; AJvYcCWz+QlETufzIszXN/RR7eXrQLbWcAcrQBs1JyBJy6UewG7og5yyTaiQGTNkbmtm1U8MKHK4HYdvhA==@kvack.org
X-Gm-Message-State: AOJu0YxITCHZboyR7/mSsamMUbYy7M7+Qt3uDZEsftK8Y3N6wU3JrHLd
	STJRog3QfqLcuB6B859wV6Vs4h6bLt+T1ZP5vebxAnHN3HANZwgoiuJ4
X-Gm-Gg: ASbGnctjL19p7lCJqcn5U3lJU1S3POUYZNoPHK5Q1vwjWTDBBG2tDas3DIWmzZgqSIC
	JSkYwiwCkh1WOUkS27i2nRtq/x0XQa/aVe8r3qdP7ZbU+MveHvV3SyGxa5d//SQw+a/4sChTLo5
	th0S4iLqjTp7RqiEw0WsGWj3cBT261YJr+GEkx0ep7SII85uZ+wAf68PH7R8q6Tw6N3F+keIx84
	ZUfRCBKXxEQyYNRGCnJliJeclz9dCSpHX/qAQh09VQNMkg6cvtEGm8is1Go0U8k13O9du1GFs8p
	8a9ljW0yBbRs1tUZJMXRjOIqsNIN/zbxegOsfulCzey/pmLXZ+qSC21bygD0c5s9WBhqoyZBTZo
	ELAJ4OhF/MrT0pcW+Cah+kbJHSIPL8pVOzJsq2A7PFls/AowZedj/Zg==
X-Google-Smtp-Source: AGHT+IFX6t2g2RWBiaV9FhXCN/YWOlqlLXpi8FKYaFoeKCWyWmCmS3h7Sg/R2hd57jDnYX+t3o6YZQ==
X-Received: by 2002:a05:690c:a87:b0:720:378:bed6 with SMTP id 00721157ae682-7200378d942mr77175157b3.41.1756133320165;
        Mon, 25 Aug 2025 07:48:40 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:43::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff173633esm17768947b3.27.2025.08.25.07.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 07:48:39 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	glittao@gmail.com,
	jserv@ccns.ncku.edu.tw,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
Date: Mon, 25 Aug 2025 07:48:36 -0700
Message-ID: <20250825144838.4081382-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250825013419.240278-2-visitorckw@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4B7368000C
X-Stat-Signature: eu6xdb3ir7azm3xk3skpxf1mm3ygzp9a
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756133321-870505
X-HE-Meta: U2FsdGVkX1+Iv7RNZvISs05PqOMdUvjHa8lx1po80Drju1luzDjyEuIKUtJf5tsb9ZBVf88gt3ayJIdbRkl7X0pBwRaMv2tgrUn+Dh1Oj3/pocGrBCKM4HiakacjCEgllAKwL0aoQteycbK73eIcQYlDHwY3YEMgiTu7fnIQ4S8AVckusHl8z4kmgbLm8j9qy7tmrlSWGKEHk0HQOIh6XPWSK0Q7Rx7E52L7jF+cCfxZ3v/93Wk3lEKKKN/ls3Y9J0gLZqGh3S21pHmPyg+WO5pg6dLQZ7ur8g7ZkTXNt5aVrjD7uq6BN+gWnzDVfeCa4BjxZW0gxobQ3z1JcIpSvcepd8eBoFKEWD7oZ0gBUC3nmDXlRRtK1ZmyKr11wnOW+VwA8eo8vNOjKfQm+MqK070a+1XL/d9nj5YC9E9gcQqxgCIYRhwk0DZuWRIwepyU4h1FrJSlCfau7Gf2JqUvLVok9bl5mDm8joN5YpcFsLi41Kk/81iDcZ18pC0YnE2gw3bSgzG06CepgonWJ5mY70e2gf6w9m4q0rmgXBjTHclCoXYp8s6i0r8TJVcdfLvlaXxRmlqH1BGZ10WleYDcPOrwiBFG65R7uBPndUND4pJs7mR1StIbcBwFX3NaIobdGF/iGfgoRGlPR5m+ZmhJo5XR9KZITkTTm2l+Foy9pRU3k4gJPINwBIPz3db3GHxcuJ+KeIMhpHK3NkxgyBf06T2Xen4q77gJwJN5mkKBtYja9cxzlWruSRrSLXPd+r6g/6FZjqn0PIvANUYU9bXb6vtTOoFo/iXuNp8ebzt4RJmKlqCm50WuIRHdcG0RgkLUSmO0/MvZwi+IuweoCpnIxHIVp5wPWINDdMVxfCr4GDTiuFH9M7XcAAHxvpsNv7lEoDCmgj6qoQKnXP7S7v9/AHVsMdpLl2m4l1xd1uL0ZhEEWGKLrd5dVRC0zGABJV3k0AIyewjwUkJ+xwesOLd
 EMp/7hGZ
 FbC2EAsyyLd3fPEYE0XLM7+M0tu3G1fC787mkMjOGdSgaamZV7eBcclSWwnYwumHu3GwR08gTuVzMP4uLUB4GGJEy3kT+hqK+OIh/B1N9xBE5hRpKEA689589vz7SNbwfEPDDBndHsdjwdYsuwX+FGtM7cDvB9j3ekyOREsoLEVO1I3F2pHSRs+ajBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 25 Aug 2025 09:34:18 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> The comparison function cmp_loc_by_count() used for sorting stack trace
> locations in debugfs currently returns -1 if a->count > b->count and 1
> otherwise. This breaks the antisymmetry property required by sort(),
> because when two counts are equal, both cmp(a, b) and cmp(b, a) return
> 1.
> 
> This can lead to undefined or incorrect ordering results. Fix it by
> explicitly returning 0 when the counts are equal, ensuring that the
> comparison function follows the expected mathematical properties.
> 
> Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
> ---
>  mm/slub.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 30003763d224..c91b3744adbc 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7718,8 +7718,9 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
>  
>  	if (loc1->count > loc2->count)
>  		return -1;
> -	else
> +	if (loc1->count < loc2->count)
>  		return 1;
> +	return 0;
>  }

Hello Kuan-Wei,

This is a great catch! I was thinking that in addition to separating out the
== case, we can also simplify the behavior by just opting to use the
cmp_int macro, which is defined in the <linux/sort.h> header, which is
already included in mm/slub.c. For the description, we have:

 * Return: 1 if the left argument is greater than the right one; 0 if the
 * arguments are equal; -1 if the left argument is less than the right one.

So in this case, we can replace the entire code block above with:

return cmp_int(loc2->count, loc1->count);

or

return -1 * cmp_int(loc1->count, loc2->count);

if you prefer to keep the position of loc1 and loc2. I guess we do lose
some interpretability of what -1 and 1 would refer to here, but I think
a comment should be able to take care of that.

Please let me know what you think. I hope you have a great day!
Joshua

