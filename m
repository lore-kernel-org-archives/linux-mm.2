Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC51CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 00:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 393318E004F; Wed, 15 Oct 2025 20:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B758E0008; Wed, 15 Oct 2025 20:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A8168E004F; Wed, 15 Oct 2025 20:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 175C98E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:46:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9134516013E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:46:24 +0000 (UTC)
X-FDA: 84002136288.30.60CA6C7
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id D7123160010
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:46:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LO2EVWI+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760575582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=DybicCIAAnWMrVWVtE/wSbSxIbiEfhd9wpDlnlEPQY8=;
	b=vSuKD+RrDdAAFOaYb2ci54383mKzsyzfv7cMxEskfraYjNdgMuQpoQ08F8WdhwUy+LQQ3r
	qAmCJzY9QYLMndp/ZOrmPaiFCLayhpK/hXo1baH1tI+0y1B14aU5T/XBi5io1extrbIto4
	kCLG4TdwYhqmKfeXDocmSqqH3a2KYPc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LO2EVWI+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760575582; a=rsa-sha256;
	cv=none;
	b=fZ/dIDTIxJAk+wMmb38ED3rjJVkoCvyeOrdrEMyZ3PonPsDfKE/E072IjwAXCMKsNZpUtA
	EBzWJ3Hjb/d73fwXgcI5kvgEuMn3akhHh03AVRZVpUjHKVv7XQ5+tSamVvoJMgcUiICL/w
	m9tSdgoxQmuK+BDo+dBNUCy+aKDfT5A=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ece0e4c5faso170664f8f.1
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760575581; x=1761180381; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DybicCIAAnWMrVWVtE/wSbSxIbiEfhd9wpDlnlEPQY8=;
        b=LO2EVWI+nXSCDlfpdMwyztNgvRWbSGDdqpG32IL+w7wo4RVnM2umnwnkM6hsiEksb5
         GN1wpv6IAK6VbPqlt9jXYM0gM3wBWDp1gWC09kewnzZmOtrAfWgOu88h31JTU+y4F84N
         y2wYjq6WTD7sXhxwe0Spq2J8rnJHmdJ3rfwygdTybK5C0bTqbdxxBk+naWd/ptlD09Vz
         pgCU6TzsVhi432TGXTYUOcvn2G/b/vHThow17Akp1/Yjb75jOylmel6WBxJRXop4SbjC
         yrzwYkfPNX3B3DieHxZIZVNmn0wllW3DF2zcfmS3SRFDNHlEfdLIXJPGpZmzbnTz5uJD
         6CUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760575581; x=1761180381;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DybicCIAAnWMrVWVtE/wSbSxIbiEfhd9wpDlnlEPQY8=;
        b=jkVRRbF63JSDOOTAei1Q+Ey1Zqsob2KaOf/DYeMwHKNQ9fXrOjcNtMleGGPlZtr6rK
         LvwFB4UjYU3DETR0jUNAJiTnnNZxm0B9ZVbXIfMbl6B2UFGOaVMxEy2t+jhfwrd27xs6
         SQs8wW7XyQXwRRjpxfnyyF8FwImq9IcrWupC86zscSdoa+0Kbf/B8kVI72FQcSuyxvp2
         IDsx4Bl+oMOMJuP1zqNe0TXNJZc4KSBrXluxzCGD5NHnAfRQVTSg6lmNdZq2IUWW/YVg
         FqgJcpgdetcclTDh2b3YfjxN8innPmPi990kjZ7yI7qjaRcKhR9iVjyHoQrYUwV5Vs8X
         FHcA==
X-Gm-Message-State: AOJu0YyCT3Rm4mi7PeB5MPti8e+eBsUKIbMxjAhEvhBYQB/ubVD8UwVe
	M9pLfa0Tq02vYDxpwXsVsSRvenHHaxpjM7gUHkxyNNXNIbZGJUHflfc3
X-Gm-Gg: ASbGncvJEui8Y1rOlWBGb4l+Q9poWJzC/Gu05y/UyQk2hGH/JZVYmga5cANMnKqhz9z
	1sobjTbaNElWPg4wcxyuYOzvQ9F7ZwyWwDzhj5BKM/jH4gtw4MRZjr+X4mZWIHpjZTVYC0sEVwu
	BPM+/p2ypaNWxy4jJjWnbDy+n1LmmoexW2caupy/PqntG/5ZgC6zF2hPloQTOh1drB+hxAltacA
	ghlNFBDwUJEN5CazW7K+/aCsK/urmBh7rRD7IbykjB6k6fQuWKAUp40mGqKF03OM06Q6BU1x91a
	T7y65ESIbcolS6TIpW4MqGF5P3zx3r0r1z72a2ok2Tj1glmbnBLCapzZWjPNmtEKD5Pz1QVBWNO
	e/S97X6p2+w7QhF9kUvnBMo4jPFGLoUs6PL2bzV9VvPUffy5HJ8Q2N/78gidBVZOC7k7u1NETJv
	eGoNokEJgSEw==
X-Google-Smtp-Source: AGHT+IGRGjaNq3j+nRp27GkpGfVXhEViDLCxJes4PGiQKePV40SDpgr88n7QzOSiAxTMt/zTAKc5vg==
X-Received: by 2002:a05:6000:2c01:b0:426:ef1c:91d1 with SMTP id ffacd0b85a97d-426ef1c91e3mr5195896f8f.41.1760575581065;
        Wed, 15 Oct 2025 17:46:21 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce5cfe74sm31167443f8f.35.2025.10.15.17.46.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Oct 2025 17:46:20 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/2] mm/huge_memory: cleanup __split_unmapped_folio()
Date: Thu, 16 Oct 2025 00:46:11 +0000
Message-Id: <20251016004613.514-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspam-User: 
X-Rspamd-Queue-Id: D7123160010
X-Rspamd-Server: rspam03
X-Stat-Signature: og1jp4exjmoc5mpxhc3swpyqy4dpw5uo
X-HE-Tag: 1760575582-300829
X-HE-Meta: U2FsdGVkX19pcf2V/q/wbmKahIEO4BmfOJN6hbH33Sz3DtBJNS4ASuIU9JiGcNU1WggDX8I4NIrF5wjQVXdWsatdWVv8tDixrh8P+7e4DhF34BMBppXeYVbLcf/pF4cA9BJTp4PDfU9XKU3YdTbuvMcNmz0M570NxYKkjdR9QI7NEOgv75SjjKdQGHZpfEwhj0PIr4pzwuxy7w3yJ33OHJPh+oz37T/d22kFHJPB9Ds9VQ6tzhpMcB5WdtNPbCTjV+SZujhGeVyh1vCgM8diuut8ITM2TVkEzfYaBlNajW8yQrjFcCgOqDZN/3/4YPVaqiLtcvosEOKO4VSY7G6JAmTKTblOsY/ur6kt52MguCC4U7BC8Cmcst9PgdfikVd/D3Qlzvs+Vy9bBNi83KyA8PF4lQEibt1D13O+cOc8PJTR5jCHZjdiEc9I3VrLNJ/aqmLVx+zq1VPi/rS7hBFbTy7LA5Cw7wBjLiqY+qRuJd4dJruVjLFYC9unir/l55Y13+52HlsgbUFOm43XJ4aerB710C11mqCR3xa0iwf2nAlx3LhreIQrcQqu1C/gFKFzuq9ONfZgaKvvNRrDWYKRbicBzaT1nYYVDu+/tNh7EhjjDqxybzPFDiKh20XFrjLedRnmevmP5qQ8UDhqxw7OSjzGK+sCaVpPQ3HVnxsRHMHqXsH1VyMCAAnGrMnW4kCIgJPVQdP6pzAtanSHJ0mNQ7IFbdVdCTe4CCxLaBTVF9QNsYNUPTqj4lFnykTpyLL+hP0Vyb1Et1DQgMdDyvjx48ZPUDho/sLb/uIWDSbq4r9NvAZTZI0SsR7KiluqohtXIKYGtC7Un0CpIf238LTnSXc/CgWGOnCm4guNRyiGkty8q2NDDoYpRKWHN4SFHejc9V/zxeiHgYWBl9lI4rzfl6kJVtB1n6soWJZfg4hM+HR2blsKYT2VFhh3qNnCV7Vo8+Ndfb3oOVk1jyvFmwg
 CLG+x44k
 KxdOXyxXVmwjo1DWRWw6vb8Nc0s0XoRSs49QV5GYDtDy+fdGhplgAwxWznVcVBWhkFbDcDTPDdWtwvuPaJ/ooFpdcXA7EiQ45IiVUVbVatyvyLJphPtZ31mGtUUo7/z1vfjoBu6Un/lgreApBrTkwtDgWSXTGOBq2MFgNYOx74/2gFjshJIrzrfzciKHubXxhTN8bOYnjtLCUqSDsxz55vB9titQQqbBQ88rXZh4QwbRCpA5LhIUh8yTwvZxBlf44SSBwRy3NoCyFX5oN39fSJKAoD8sV41F6ql2mh/MECj5Q5D8NRm935iwYk4DQdRNgOaJlaROR0Pr/xGnfPyNF5eHZFUnT5DHm+iGPYypf1zp+Bk7v/NIIHaW0JRmkdH3nCuvvGa5wXpgniozCMgKiwbJNYwzqFDRfd1UalccQ4y0tcg2Qor9ehmYpjaTWAi/5eBO/ysEJyAhU1/FajkL7UJOoEsrExsp+BS0XtFOAmTPQTr8LaqEdpZuUCrWm9gU4iwMR1nl0AKBTY16mlSmJUSV7WImZXh8AiKiLF4FPh2AQ4m/LIQyflrpAMSVYSj7EQUs3Y6RC4yfCZKr0uXRFGYtZ/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This short patch series cleans up and optimizes the internal logic of 
the __split_unmapped_folio() function.

The goal is to improve clarity and efficiency by eliminating redundant
checks, caching stable attribute values, and simplifying the iteration
logic used for updating folio statistics.

These changes make the code easier to follow and maintain.

The split_huge_page_test selftest pass.

v2:
  * merge patch 2-5

v1: 
  http://lkml.kernel.org/r/20251014134606.22543-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/huge_memory: cache folio attribute in __split_unmapped_folio()
  mm/huge_memory: Optimize and simplify __split_unmapped_folio() logic

 mm/huge_memory.c | 69 +++++++++++++++---------------------------------
 1 file changed, 21 insertions(+), 48 deletions(-)

-- 
2.34.1


