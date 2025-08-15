Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D02CCA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74DDF8E01DE; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8598E0002; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BF8F8E01DE; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 498D38E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:50:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 975AD13841C
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:49:59 +0000 (UTC)
X-FDA: 83778369318.20.30A603A
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id E5F5FC0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:49:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VUcX3tfk;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755247798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=LU7iL3yi9H4lRvXov9x2IQVSoDXY3x5tVgS4fxraNaw=;
	b=G4re71BKn0iKAOywZvxGt97IrvqfrvjTATHbZl6fOh8/FwFl85QEoPQvOHRUea5LGSkgwq
	FDHAQX3oXuJL6wNzJ5GxgsEAcUG+L8lXXbxcHnx8hli2gAPvu0tHDfr4ft37vO3fBXnKLl
	tiEEInsnFcqS6jKadAaBUi5vJtUuTbI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VUcX3tfk;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755247798; a=rsa-sha256;
	cv=none;
	b=ZqhPWKn9FhCoO6CNmERAH+1OIC+yNgwlY7Gld2EA5UyhtVKuXUqOr/IejpuW1FV8utieoE
	ly9GeeDY3TT/0UrQMD8AUgo48Pj3SIJW7UsijNP58jqMfSvLy8dyAiyIfeD7GvNPztWs+3
	EpavuLZfT519WzYf47WYuewNb5dHV1E=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb78c66dcso267519066b.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755247796; x=1755852596; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LU7iL3yi9H4lRvXov9x2IQVSoDXY3x5tVgS4fxraNaw=;
        b=VUcX3tfkBNc+Ik/ehqOzpNSYfT6h+YZ3wMXhKm9cI4KQ2o5SKmX1l6Yx8expXHBJV0
         f5HiLjPyNhfYm/Qar0NcCznATqPp1LGIZDf/dFWhS/kXZ/m85HHKMzE3ayrq/ZP3f8jM
         HyCT5cfLcn85u62sTHIV76Ep8jYYePhKNWURricpRxkBOX+F7tdLOkVyoXELUL6Dd6PW
         wGk6ga89EphXqGS3/DMp7Ij2AWsD+T7AUW952iXtuwYMNaGkFNr5Xz5lNMhSGX2d2MTy
         XUzbfybxO/YbKWm5oHlERSA70Xe2wRpyp6Z+Z71BhEEB5L6QswfZ2czYu4jLAQbu56yA
         d6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755247796; x=1755852596;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LU7iL3yi9H4lRvXov9x2IQVSoDXY3x5tVgS4fxraNaw=;
        b=NgiGX2oz6Vu+nqFEFkfzluWiULsrP0mgnAn0a6CFXZxNcQ88SFZDhF2f+HBwPu6hhh
         JLOlQH0ugXo6Ufy5GOC7UNzpp+LrOERTAkmGUtFmk0BQVlV1rgmMGo5qOJ1UJfQBiqPs
         wMxkVwdphnYXfhlpufEv3eylGWOfehFs7/d3P4tJ5n1AC4bKCfxxQfdMc3llZVwhfARt
         6u4ag170sbccHl/B8uw0/vNl+BlDPf7E12ZsFcvPurziuvhApbfchEGbgIzDRGOOxCN4
         BUcqyvMdnaV0A4POtVv+tLKylQQH1nh7uZCWSgCZwiISSKo0UC1aXZogtHBqnuxIzb+k
         mpgA==
X-Gm-Message-State: AOJu0YzTTKqwzaNYlDa+K2X0UWDeiIbTTVJCLwu1E3opStjzr8ljHHPI
	R/C7v6IobVBE00S5hNZ5ofIhliF0WGVgvgYr3PFD8OAo3rhtKjUUYUin
X-Gm-Gg: ASbGncu7jRA9sVf+TZsaYybS6vxD/9tuDSfM/3JLTjRb2AJUzS3BmkagvQz3fq4Y9/s
	UZZDq6iPb7t3WM5KbkGZDNpoWkcfQyaZNeQ5gMi+joRdbZky+ciXZLbp0mOkwrdXDCBmUGKnJQo
	gLK7KSNnp98e+f42LdD9qut/ySOrgN5g/CWCDFcEgxssVd+P2gwExXFY2KfLsZcve0tpnr8mXef
	lqUaRAPo0iFYa7dD61qkkntXILyxsFFQBuigRRe1VGOVa/74osKlGfAtpPU0c2Gt+ERpiMNKdlf
	Gv2nVLrrzASHWC1kWQ7EBPQQKC5VtcP0KoGxC4MlNLZPGxMdo+gwYQw5ztARgK9CcLGJKPmUhBs
	v5uGHZUNQah6rm60y5FzR9w==
X-Google-Smtp-Source: AGHT+IH5swTGh3n3GdIXj9+WwmkJMHapHemJHQHDgDPEXmtgFxeVOuEfuWeyIdyUqqMsIAHr1eJDaA==
X-Received: by 2002:a17:907:7f23:b0:afa:12cd:9daa with SMTP id a640c23a62f3a-afcdc289f90mr105880266b.48.1755247796011;
        Fri, 15 Aug 2025 01:49:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdd01168csm91912366b.91.2025.08.15.01.49.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Aug 2025 01:49:55 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH 0/3] mm/rmap: small cleanup for __folio_remove_rmap()
Date: Fri, 15 Aug 2025 08:49:40 +0000
Message-Id: <20250815084943.23063-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: ng7rxzth4ko5r3zmayik4ys7en4xrgne
X-Rspam-User: 
X-Rspamd-Queue-Id: E5F5FC0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1755247797-191403
X-HE-Meta: U2FsdGVkX19s9nEedE8WbmvAL6nrTX1hKnMEJjdLbzGprFHliDuj9KU1J6X/qyStoHwPH9i3WyDxP2eqIttlHzje0vD1MGEZGjeguEM19m6dOxL9RyVrh98fP4K/zY2KjezEVK7gtoHYLGgkY5UxqTK+PfKnduE8xeIta/mPY5mykZkRwgZhHemPND+zPN3Wmk8GXrnHgsESmKNP9NtQ3AgWJSGf9ahTNa8ZW5vKJejI6u1WpzHy+BEnuARptSEX4/+KUoLlTnY5jRbaAwyRm49jTHjhHnYBeQvn0lEj6Yxhn7FchGMFpmodfhc1BPq6bBOOFrDbem83FMzE2Yu/+Di9krvlCXBcSM5CRrPrDFIotarvt/9rf8+sOpLJWVWSHEJV2+khxlL10xPRWW+ikoAD9+Zj1PLY192If5pHIt/NSV2J9oK3SrRxeySml8ia/PA0zEyKRURCJofY4ZCbrvfJuA1df3pQK2tHh310YAirA6yyQQSS0W1vSx2WMuvFN8hhyya8kxq7A0KDhEmaqtq+09qq4ceHQBhzCPd3oITnZHFTbW8ULpvBGVEm6hZSHYNQ9lqhLZq+mTMHPc0OBkTtvLMD3ytMHl8v0g14xI0Xr5OrELhdMw+Z7PrjgA96D4pjFsBn8114MNba2uuqI3kRGRLzc5DqYC5E7Ex1nro3udcKQ2A3xCZ2nt7iLmJldGLIkGfUjmhW1TPyy8Y/n+jMc7mEvgYdtTcfUlpC8hB7U4ee9ZUORjRPCNCec1hxHfMxALNY2VKUOR1TAgpovOgOhBodLFcqy0lfM4qRjeWGOTqQVoOzXQowpFP7e7YpyOfCRYBG+US9AYBCVHfLqvv5WA45B7y2wE5FrXS/WDcz33Xw+deOt1Rzor7EuvgSBESDiBXvH6bSz51pmFW/UAOaQMmQ1NeCCTJ6rpUb4QHkmg32fmX8N+zZXZqYQWgHtHmaue6luLo5GqcX21O
 V+vKi+b2
 eux1Tz4bg/ZzvCeN/AfxhtwOQzOn8pXx+MJA1XDXaKjmY5e8cOOGcSHwXm05KQOeLLIbjQ0IWkEQfJG9gK3/5cWsWEf2oLPsMspOE+mo2mqsqrqwd96TG+X7ljYt4z/TU8J+ZXcaL0KpyGaE+wpJkYh6qQQ9rA28VlZe/d8NZAfI0Odhsc1rlZsMEIgB1Qg97kjKdJRldIDdvap8jcnpCddyoyoEYs+EAbogPkRQZNggY9Rxz9WEL9D8wJjgtqetPBhmxy2SKKWyuQkLTyV8fgXbcPJ/gkduA8Tpl6qtOoe73CtSc90PoDdUGpPwSTD0GP+mLIFcpvQC2RoSRlxG0EwTELsC4zUwHujleD8uOCffMd1zxrB2adtI1Iya/G+CYa5UhNl3mvXOCuDaoXG8Nee0HSybdZKXt1hbpPov08kkmLQ5fPE8V1NNh/dT9TqzbZPJVKaz9WxiGV4C0COy4Vn7KVzbuNPQha2AktrYxAkVhzgHBfVoS84pkQgBgMp1KN0tD59VsR8HTbRN33IrId/u64f67sZ7yVvZZJ7STKS8nVg8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During code reading, I found some small places where we can improve based on
the knowledge we already have.

For example, since base folio is handled in another branch, we case use
folio_large_nr_pages() to get the number directly.

Hope I don't mess it up.

Wei Yang (3):
  mm/rmap: not necessary to mask off FOLIO_PAGES_MAPPED
  mm/rmap: could be partially_mapped only after no entire map
  mm/rmap: use folio_large_nr_pages() when we are sure it is a large
    folio

 mm/rmap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.34.1


