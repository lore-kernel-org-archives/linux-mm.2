Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD245606A883
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 02:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thundercompute.com header.i=@thundercompute.com header.a=rsa-sha256 header.s=google header.b=SF0Ihrie
Received: by kanga.kvack.org (Postfix)
	id 033CA6B05B1; Mon, 16 Nov 2026 21:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26E46B05B4; Mon, 16 Nov 2026 21:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15816B05B5; Mon, 16 Nov 2026 21:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC0FB6B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:39:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45EFA120306
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:39:23 +0000 (UTC)
X-FDA: 85443054606.09.874AAE4
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 62A211C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:39:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=thundercompute.com header.s=google header.b=SF0Ihrie;
	dmarc=pass (policy=quarantine) header.from=thundercompute.com;
	spf=pass (imf21.hostedemail.com: domain of mark@thundercompute.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=mark@thundercompute.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794883161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=W3iQeyj5kHA8i7LNdw/GpSJO4XwaLwyqthlK+YVxrcY=;
	b=SaFOvOrGKKlhQ86suQdpKepq7k73JIKjhKFoIawfAS6qY8PkCpz+1Oqrp5p9uNVYiIW9Xe
	UlNlkThcFmNpzPUzzWaWjbrLbdQ4FdQK1NC4ZBmNrgbrEaKMepMWb43K1QdLggZPyK38p2
	zULHJe/iWzd1Lw1qtzCwGMf4AnH6508=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=thundercompute.com header.s=google header.b=SF0Ihrie;
	dmarc=pass (policy=quarantine) header.from=thundercompute.com;
	spf=pass (imf21.hostedemail.com: domain of mark@thundercompute.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=mark@thundercompute.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794883161;
	b=NZTFrQXYn5FH4DIAzOxgHRlzdj/+bw7q7gRBlcuPNk+hmWXlTrwT6dHHoawOy3WJXzJK4w
	jb2IUTDTRul/A5vFNhPsaAIycfVIwzEkKcQCc6QdUF4ZQh6FL4ej5gZ+8YZMawj0Rs6xKh
	0mB7V0MWE1KLGKDdz3rWtpMb5ctO5iw=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5c1479a959aso3368753e87.2
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:39:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794883159; cv=none;
        d=google.com; s=arc-20260327;
        b=jY0RmGaf0qsrsSFI32OD6DHxuzKp1orDeznYbATyj2eljYnzYM+Otbv1yaAAt6HbM5
         77YLa4L16I/JPJN1D4BCBJdFCCi4yF+cUFj73WTD9wdcGlavF/tfCi0+BtUwDVdT1qsi
         w6H21qizkv+Sfj9KpRoXmVPh4XJmLqMH+WV1kTs3FdfmyK21o20ofI0bxByyfm7l3hB7
         NhA3Jq6TU3D8CI8vCQonWcis5QEWSxqUBwf2fDSJK+8pgn/W0td5buytL8vYsg6YVecR
         Gh3YCQ7YntDuqszwaYoNTiBg1g4zngvU6x2pFy5GY01X6oXtn6E2DZ9kF9HmulFx433g
         9WRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=W3iQeyj5kHA8i7LNdw/GpSJO4XwaLwyqthlK+YVxrcY=;
        fh=wQ3I8WtmI/jkIqnhFcd6UZvgTvh/hfNg8KgYxzpheVA=;
        b=D1AF03iFJdEM4Yk9kShllIRQHCEPeoUi09YHzJL73tlTB2CVXZg/8WNTxRsDNCIugP
         g628SZrJmM5fF50A/O636bzlrbN7pfa9Jk/9uAqZfAukn+UskKz/TaWvTXHUHFJhSrC5
         VV1zz/P8XuP81ijxhaRnl3boyFtAGCO7fqBvPqFUeQaWTFGv3iP2EdJiH5rnk+Ej8gxg
         CbQs4hYQsqBOXs0TvENw5TUybHUzk/OXqEcFceHM0AHtiQC9OZXDglQw+WUKbMM9Yefk
         tQh1r0h9yg5QOKSDyx7yyPMNgEpkSrXwQUp18LvhwauaiUwtbda6ZVKPNVZDiMP7+nzN
         RFaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thundercompute.com; s=google; t=1794883159; x=1795487959; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=W3iQeyj5kHA8i7LNdw/GpSJO4XwaLwyqthlK+YVxrcY=;
        b=SF0IhrieDtsxnzaT0RsBFFjLVv0387iOhCKs57YqMxrHMkU5tBKJfq3loE2X49Fsr3
         rEjSZJ2DGCS/PyBk6+HZ5xzqtuVsXMCEUDargdCppTrLFvD/vHDmOn+rMFSuG1/1InYl
         vA9xSP0amGsu3QaG0Z6xgzxlItvrNCCUabFqLtsbTFpOOPGwNhCX2vpY+Pui3e9H8+WV
         vTUhZ+bTkc6HoSsrdWYN+ZlgEQLgpEKEurz5EnTJPzm6LpTQDBrBLPyix2mTFL9GyTKB
         0EJLYrEy2Hh67iqj3WlOiEF9LUmkcgXC1ZJg5kFKCteuplQiIa0OTG/IC+YXGn3tHAeO
         uPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794883159; x=1795487959;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=W3iQeyj5kHA8i7LNdw/GpSJO4XwaLwyqthlK+YVxrcY=;
        b=gd13oC8OvqbSrF8HgVrzO9xlsBk1cmSUyioZwaFtT5qnk/ffHHWubR844nygUl0RTY
         q2QqkGBpJmq4av1Yt4/XgX5jighGYCdco//MXyi6u240ASI103L2U57WXmkgbIuutoiC
         gZc7X5SrXKvQf3y+5yanAad2b7gt7OAW3LyqCyaGMgaeKAKS+1rTEuX5zpuVYmwrHuES
         QDT8kXGMS5RaqtSGW3Rqk6KIk5bG/5jn2UBxeeUZFA+eEmcvENv1WJ0eEqseBhoelEpm
         7somD0zlzboFItbafyI/lP6RZp2jLpVzux+c1kA0QHNW9SFiOr02FU+U7c53KZ5ZKm2J
         pJRw==
X-Forwarded-Encrypted: i=1; AL+hErGvRL65zkTYlydzQszjgZPP74l8s4sPgVDOvvJ9S4ehFN/HEsYkw1lQqqoJfLbp2ab8hiIMVl8c6g==@kvack.org
X-Gm-Message-State: APuU4Z/+tOY0CQwdEB8phYX67Xrzy6VL8Nmt+8S3sHSNgqUi/GdJMh9/
	GVFz2ikNZFRn4MFojWx3lSw/XmE2zUB+KVOYx+qPeEHqJWcDA/WmfeHFEyBeEtM6Hh1z+uLDqY2
	9FDRWytO0AivoJnZ67TeZgDNVYIlZDBpObld7lhSFkA==
X-Gm-Gg: AYBFou0yOypTUxyq6h8nCYbIm1TXDtklV3xpCPlcHkY5T3vfW/R7k+9sLHW4R8+Lrt9
	XZ+5pXk1sKG+BnvVcI0VAI04aWHogsVgEGC5GmuUNWrflTP0xwRKlGydoTR7kPbRYQPWP2hS89m
	d1XlDe20adbTjg8Sg0maYyh09T/taa7CHnNXlKzKBn1VI0C5dUKihL76ffUTXPRWnQ9PU8MrTx4
	sjLRJ/LS2oGEyhWN24rolV9O3tCyvOl6EbGanMGABMY6sVDRMEFQkCJrfalVl4Q3jYn6E+Voc5b
	OxfoMPPYTXfZggBHcCGus918Rx+NMYXUxTVwu2pQPrY7PkkdPp45rqUP1DgsCZmvBBIcYaLPeDi
	SfRNpFEsTTGyO29bymbATTcntd1IACuGR4WltjNKVQHDGVUWDNXWKXtDM3vhBjnzA2rr+Wv+mCd
	ce3A0zKApGq09841O7VulPCepvOkl1MKG0LvCCV2Uauf7xkkbjbBN6fx/onCiSnwRZoKASlvAAi
	5usErt+L+N7IBjszck=
X-Received: by 2002:a05:6512:618a:b0:5bf:c4d2:b074 with SMTP id
 2adb3069b0e04-5c170a159camr4783685e87.55.1794883159435; Mon, 16 Nov 2026
 18:39:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
From: Mark Polyakov <mark@thundercompute.com>
Date: Mon, 16 Nov 2026 18:39:08 -0800
X-Gm-Features: Aa3M54o62zRPxq-_tXfhcY6Zgma9ObTMS_OIn5JcKten7oxKU7zRiaBe3aoCxhY
Message-ID: <CAA5JH2yO-gw1gn_172hv0YWFfQpkXz915a=uoVH+e49P_D8-+Q@mail.gmail.com>
Subject: Backport request for 6.12.y: mm/damon/reclaim: use parameter context correctly
To: stable@vger.kernel.org
Cc: sj@kernel.org, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 62A211C0008
X-Stat-Signature: p4krqr7bacy1rcmbwfef1j7utujgw93t
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794883161-518011
X-HE-Meta: U2FsdGVkX18flqY1m2uFPtNFnXFyDeFFsNk+F7qxJdP8CurG7BdWvRLfJGH1MRBE+xxDfnKajK3Lkg1+KsKMaJHMI6oPJtnMBlL+TWOmvMLUrjperiD2gNCEAnPd2d/K6I0Tv4OhUXkvat2J/CZ/fJEw2mmUeNQkZT+VFNL8aHIEP+Jf45yprVrmZSoPn5kjrorJGtl5t837YzEvC9xO9UMsn1XMsYpxAu76Y0+RQq19jgyWEd5oODJweys82y7JcksuiftbuiO7TDxF42dxhkSFELjmM7iI6tV7cYFuZRsg27oRvcvF8WjnERTIWKOTBP3oK9U0eYkirC6/eJrvACDbXW2rZSfAefMyIYugBrEmjMtuR0h8KAMpjkk/DPCP6lycp3zWFZbxiispWwbRNMuEXBHtDqxg0asScnAx3aPtLQjAzq8QbMsyXTuQHussXs/TdJFeeVRy+pVbqHfgxzSCl4r3YjgDWbBckQlGrx6qrZ001ox0ttqQC8l57cFaZ+ISHo2x1eO4bt/Y1aClUCz7p/abpfTOGSQ1i34+aqmKab8zfNjcbm6qFevyrE3p2xtm2E4+66TeSHRlEGlnh3xalMh/MGzpxgqEXtGf4KILFs+9P2fL1SHXJQ4RlMVYt+STBMJ3h0FCNRLIlE+w/3eyutrLr2tYvmxaIP1NwgFWRxUgQwXq2uv9MYYFOuKSZAQAKukf1/JYMVWO+Fwg/d2FQmhk47VQo613kzvvoXl1hq2GqWAUnFFHdhqK7QhemvQkKlBj+nvNEu9VosvXM7120h0IMVbWj5Moe+mBvCQVBt/j9km36WwEVTkFeZHhZWmSzy7Oiw34k04QLffUjiLT7etagd89/lTUzlhQmd9dp5RQ4Taz+hLoz1Xd/qzVfbc752U9iQiJ7lW9iAAoaptV3JBzWcSBoCQl8YsYojmaMhq7rzw2n+wjIlTuvKeQDqB7g0fb1iltJ/CcRQU
 VqMx6UDl
 yU3jwmK4tibGerX6U+hwMw8z79ZvA083dIgghN8JMghOuFYptu6a6IXS7v1p5MGEr1/Pkiu2z4Ht2Rt8kj6nWia4LVTVfgPhigo7gUR5Oymd5YPKVl9CjxHM9c5/0/UQ3sH+5z5hIw/p8Oqn0bMC5UqVZOsqTU3LC0UvH3Jjs0XxAEZfU2wsbm4CJPMtSXVPr6prwno1OA+kitbHz3OALwU4fwRY5omQdebDacxZNMAVK3GQA+78Q6o1SFz2Dmp4OLwAR4dm4Xq5iQ6W5lia32boozh6Rzy2QYbP0asu7sOoHFdc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, would appreciate a backport to 6.12.y of the commit
fed48693bdfeca666f7536ba88a05e9a4e5523b6 (mm/damon/reclaim: use
parameter context correctly,
https://git.kernel.org/torvalds/c/fed48693bdfeca666f7536ba88a05e9a4e5523b6).
It seems 6.12 gets backports of most DAMON fixes but this one must
have slipped through.

We've run into the issue fixed by the commit on 6.12.115: A guest VM
with DAMON_RECLAIM enabled but no reclamation occurred. After
backporting this fix ourselves, it started reclaiming.

I can provide reproducer etc if needed.

Love,
  -- Mark Polyakov
     Thunder Compute

