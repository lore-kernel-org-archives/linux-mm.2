Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8B9C87FCF
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 01:32:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241386B00D3; Sun, 10 Aug 2025 21:32:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2346B00D4; Sun, 10 Aug 2025 21:32:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1686B00D5; Sun, 10 Aug 2025 21:32:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB5D26B00D3
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 21:32:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BDEA14068E
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:32:28 +0000 (UTC)
X-FDA: 83762751576.21.C610182
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6BA901C0003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:32:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y8EOBVDq;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754875946; a=rsa-sha256;
	cv=none;
	b=1eXeHLs5WvJOGbCWM+Oo5f91J+EpJlEdLhlUkV9Zydm15ryaZQCoe7VWPUrQneNihI6Ele
	3UjfZRWFeZNn9mPNFbJyKLTmDNxpA11zhSYMWApdrsMtggZLxvZ0am1vomp1cJ75ZIHflV
	Y4p0q+CuK6balGF78oqyyN+1h4NzoUg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y8EOBVDq;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754875946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ea3MqeO9Ps0j8dDC7AbHgbi3QziiGd9Hvht8UcE3yOo=;
	b=zGPeZ80fFvKFfgrZg+gyJA7A2EaTatIP0/fXcsqKffMcOVJ+2qsf5ZKGyUgZb990z+QLBe
	k0MTJjlCiuUP+4hssb4e9snJPN/8ObYeYgzIiEjEgK4NGQYXwgcCJ/OyMyN4lbMnR7fxWt
	GvUERLkQtoCVUJ9mOyrZByF3xDYR5dY=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7698e914cd2so4877920b3a.3
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 18:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754875945; x=1755480745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ea3MqeO9Ps0j8dDC7AbHgbi3QziiGd9Hvht8UcE3yOo=;
        b=Y8EOBVDqWYzv9KqHTBc6eTdCgsCQQVu0c7FEx+/ECFycyP9AFqcXvI9KecHw0Sih34
         7GX/menMj+IXguXEY8avARsYUsTkmWGCzyXgWF0Wd1asJ1EhoGaGFWsnK+/16qvPembn
         T5qEJNE99mqN6GawdZn+iiMFd7wOhoIz4YspUK8ZYqLLptjVoe2vi8Y0MsILzvV1lXZQ
         bYzTTCiv7APoLuLX1pRZjxamFK+rYGUAMHw+n8FOgIbTY+aLYhuVL9U1d+O9VVpXeXiq
         DJWjZg2ZwAunQ/ZBRZfOpJ8kBD1SOjSHiOMfMbpkfv1GL8n2O4xEkwAwzoLoIvP9TlFr
         RXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754875945; x=1755480745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ea3MqeO9Ps0j8dDC7AbHgbi3QziiGd9Hvht8UcE3yOo=;
        b=vhgiW/pLRQ6M1j2Yy0lIrvnCrrTipUKQVL3VqsSREb3lNMXQtdG3Sb4kFx9NsHeHMg
         K76Azafcsd6NwXl++vQwK1LE4R2X0rJJswMwGz0THigvAIDjiyKFSy7G98PcmekZVbD2
         ey9dvrGy0a03QQieoBny2JiJ18heHAgk7DcKJTJNwLp2u8qDZrAl4b5yfkoyVrkdpPky
         Jno9zqsP9MTCS0hs2JuAWu4PC71eVN8Q+b0jzNnD5rYKzzJGuPt0ZEVuCz/QrJ+c2Qcy
         v3P5egimmIDbhMwSdh1pHfyTl5FPIq0w2f7PFbLOfQo7sLsUpinHgid4rZnwBp9b5qZN
         3YQw==
X-Forwarded-Encrypted: i=1; AJvYcCV4BSl7HonN/C4fC77HfixUrUMj/3414m0X+ZJA2rUziWEI/wpZ/G+NO3kXjrJ6xrTwcJ7viOc2SA==@kvack.org
X-Gm-Message-State: AOJu0Yw420VYQvjFsCPxp2uYOpTvMq/T84N4PvqQFS0vD11LG7lmPPAL
	rungyVa7NCDjJAXJY2B5mYtOAPbMFABfLwiOlvI+JTkoHarjuD7DTheD
X-Gm-Gg: ASbGncsQbLGLDI6mkYZEIh+JZ1JFpAWEA5AZasVMxkSPsi/qAGL0CGPeUvc4UMnrlA6
	OA8ATxSa+nxLFNDNyi8tYTaq/CYQ/tZz1YRF/vGhHV3TAjnLXgWRe+FLSAtQbCgsMg5SSNtPKT8
	i1O5UxTHWEz+YfTviROmItkVeJ5JSF8Qgyn89ajf/xVHejcHjkTXraV9wNzddZ/74q0869VzEsy
	W1WJTh1FOugQ6ka4Uaic6v5iyi10NGIWzIqQI95OqhpNDbwAUZM5aMLV1JUIU+Iotg81VTuOsuu
	426reVLV03Uoldenqn+o4kB+sIwtTDXodOTbzoQZbMJDY2z3sb/KkJZWkiUB+aOLFsePNMHC5JD
	TvrrxBqh5XynBpMEO2iWeZiXfsCTv//mZNVsSV4sNiR1X
X-Google-Smtp-Source: AGHT+IGpzJFikA/vM1MNktbjWzEslLwV0wXBaZB9sZ67jwW3oBT3kMRiGhbYbC2PB6j2JdOKoYlF9w==
X-Received: by 2002:a05:6a00:1a91:b0:736:2a73:6756 with SMTP id d2e1a72fcca58-76c461b8d4emr14929265b3a.21.1754875945173;
        Sun, 10 Aug 2025 18:32:25 -0700 (PDT)
Received: from localhost.localdomain ([2409:8900:21f8:86c:416a:76e3:d99:97b1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76c34d23f01sm10126909b3a.23.2025.08.10.18.32.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 10 Aug 2025 18:32:24 -0700 (PDT)
From: wang lian <lianux.mm@gmail.com>
To: ziy@nvidia.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	npache@redhat.com,
	richard.weiyang@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: Re: [PATCH v2 1/3] mm/huge_memory: add new_order and offset to split_huge_pages*() pr_debug.
Date: Mon, 11 Aug 2025 09:32:13 +0800
Message-Id: <20250811013213.54499-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250808190144.797076-2-ziy@nvidia.com>
References: <20250808190144.797076-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BA901C0003
X-Stat-Signature: kqbamj7a1mwm3sh5i1xms67i6ctw35ik
X-HE-Tag: 1754875946-507564
X-HE-Meta: U2FsdGVkX1+AeJhW+pKc66vQCWDroKln/c94xuy1oZzUTxc6FAJAwgCeM8L9i9d6EKPSwpkMQ/q2AasmWNYV0sKvw48yZGPa+nW1m4I5bzWgHk8KtOMXtDBGCqHh3q2VsBvt2vE+KtfwNpHm5oh1ezoL93YiWgc753BKYWDq5KY0iUZw3U2cHa5KYVm2Li8MsgRWGLTiOI1NiklRK5fJr5BEzXv/wIXvuXCSwDAbrG923UIU01JmySz2Fd6x2E7PIOisfOMgZn2TxF8J+/tWV5wwRon02mIvYYy5a6oLIVGhS3hm3K2RWxj2o/CpxomkuDoItW/Z68G8vql/k2Dvq3SCxSJgREdlx7ASN3NNKXDASq6LcFFAz4W1fUDZGP/e7ZoWvkvdgT4X2kZNEeKbzuXL0/1Zk1hEuUejXdJc0I2ajpMPMRM6IxSSRiTB4bgynjaSYMIj//jALsYobG4P7zczbw5dOO+qEeaHWHT16ZPJ4Wl5NC5oEYmuGBE4MkFihStVCiefaG5IV4jM29bZS8MMomd8uiF4LsJ4ZJEqhDeMoN1Kz1N1iysO7Nssy8UivkFpZNsG1CPJhjmYfWEtycArRZ573hozeSyhuWPXtk1hO/TEcI5Lkn6JvI5nSk7CVJidghsiVD3Tf4Kh+j6W94Fc8oJGV7CRflZ6MUY22sXeJd+k2c171cSLKVzRiWubBDem+EGUgkp6RybMx3ZQ2rA9N91IT5sK2X5o6dChU3iI3brOjSfZb9yD9h6bubjZSbLiUx+r0DuXR318jswB5wvOG0wTKcKAjl6VjVov8ghLac+ZMxveISzbKokBwr1BvBPqkUnSmu2QVm7Wazce+ILSJfPxQrG46eG4+q8IzQMGoaf2kPwmnMpt4zzsUVSLca3cUuQOykbHxT0ZHtOe+RtLKrO6ljDslau3sfKxXH4kuOtBif1iT23R78lGIE6++iKIawc00a34Gxf2+kL
 p8N6TO3I
 orOuCRinryZCj4aU4Do31wWzJosMxnA/ymNaToB5jo6AA4jW3fs+cyiVGfdjGJL+Y+L72mlfoFAEv53CPz6HeagHQbMa9+LbpS++klzxYF24B2Rp5AOoV4/XUgady8MS8Go2WgZz8E81G6IDZ0oKasvEY9Y1uxhUYSIsh67MNLgp08sHLaaWx4kqLjp7mtJbM4Xk3bB5+j7ErSqrZ2VkPvcLWdS3y2s6sukLYovmpJasHaGAtvo4nnOgHX533NmFf6eLFObwFIRAKDBKLmevhuhcr0gfsqCeequy/3d61e44MfdgGHy5CAvpCvCpkX4cggtoFnh7Im8t00F8SdjKvS6hR3OG0ant/Bo+f/yrarlym25SwFFQSgX8Yzh/0w5gJVu/J2VqmzqDMAba0wkRXepj3h5hHvgg7hps1yD7aqqinKNMnLB4mEqjahbM0JotfrRg8gPLD9iZLy5JQ9rHmwzOTQPmVqUjq7YCsLVNwelz6CqWsysnz+MsISyjDoBlf8brDQgqC402KAI9/Aquv7K2EXuB30/Jl0rLwGN6uy6xqAGrJpXvfbhXblYP6wDpIgVA/oqyfpW5CXYiXRCEokn4bjRpXPH/0Iqk22qE3bX3Fk7GBOj0u646jEJV/p1jTqubN9PnBOXcSIi8+B0V6P4cYDg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> They are useful information for debugging split huge page tests.

> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Yes. LGTM.
Reviewed-by: wang lian <lianux.mm@gmail.com>

Best regards,
wang lian

