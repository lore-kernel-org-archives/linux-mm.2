Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D833C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 08:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4071B6B008A; Tue,  5 Aug 2025 04:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7CF6B0096; Tue,  5 Aug 2025 04:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6456B009F; Tue,  5 Aug 2025 04:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1817E6B008A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 04:51:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D111B5BA3
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:51:31 +0000 (UTC)
X-FDA: 83742085182.29.E264CD1
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7719140009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:51:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HVJuKScu;
	spf=pass (imf26.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754383889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nTyUNY7DkPk6giF7bQ8oyIphr5083kUpV0hMxYtsqp0=;
	b=T1L66DIl9FyAe1Nto0JjthvqEam58C+OdTVH2egGT8tfrT+ovgcwvO0I/BM2LLZUsRLtJ9
	zW7qs89qoR9z9bxbSML9q2Ebo0foNRD/dmroV46Vmvq/UblM4OaXJKC0xTsGtuYIvwcHhL
	NrbQJW5UXn7SzoqD8GbKl9Oi+SkhU5A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HVJuKScu;
	spf=pass (imf26.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754383889; a=rsa-sha256;
	cv=none;
	b=OEvUvLdD048gVqbX2BvZueflZbzqwL8I/F5RzNgx5w/IHiZvX2Cd50lJmbrXihsuq69/zZ
	G9rVZFIved1ZWpcEYdjq/kvpIAcpA+FavjyvotGNlZHWxFEYBVjQo6gmxIf0dNvt/PuAWU
	6RY3f5ylJqN0NGdgMDnIcq9lo6Q1RlU=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-76bc5e68d96so4320445b3a.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 01:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754383888; x=1754988688; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nTyUNY7DkPk6giF7bQ8oyIphr5083kUpV0hMxYtsqp0=;
        b=HVJuKScuyWe/MGkaf3xIacdA1vrV/YviKgX9E35E2sO+/ouarVoNoZBgvDSb5zLvx/
         2zi4xDUw6BUVsDp2ipo7Jv2ZRZ/Qfx5SNQPlWWiasPQC16OyJVwwYzf4DsB4mLnWIr3m
         QeeMXORbb4KvzXVBxiSSklyg5A1T3SdA4Dga87sgbT6O+wIW1lB0qSjrdx0t+3qqK8cH
         D+sA/5ffnFY5WrZHCv0YlbmJIe/PgojPH8NDSMnAgqr6VlBIKo41TEYjGyK22l6Op+3Z
         ZedT6OgOsOomjYm2pPwNxxo0CDQLbtv8XOfZ5GreKj3QuVWmVlJZ9vAczipd6pauS1DS
         ICxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754383888; x=1754988688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nTyUNY7DkPk6giF7bQ8oyIphr5083kUpV0hMxYtsqp0=;
        b=oo5Vp30q6kA4HpxxznAwORt3BJ+mh5eoAZGDrCehqJSlwyDtDSAWa9k7IL2X98B3Gb
         qGIkviF9thws+zPkReeO4cKN710o5vCImT++fl4KkGXvY35D1JUK4oUlhl48Y4E+e/BR
         Fd/j2oSi4VvYHwDQh83pDGRq6Lmsw7ir3ag3uHGdPDamp/MLzGIdRF4bwUHpfOibSQje
         SFTDHtiBVzGzBX9XIVSDqL5tdrlpqRl2YEXZoMLf7X4Behjy5iykTb0LDrDJAwbyY5td
         l+abh3Cuuiu6EFF8G/iWlphbVc2DFZO7vWL9Mbs1KEEIXEP+nbwtdXMN11jdhA5D/cZ1
         X5dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJL26SX7feNiqDB4mTcpjgcblB7jL+e7w+NHrAi7DKk2HODUQrbUwvGkvfmpVwWPnwO4/oPQLlOQ==@kvack.org
X-Gm-Message-State: AOJu0Yw7othqjuwSdzrvxzNAjdlBz7/JFE0CUDJIspXZKT9uwExsudbB
	UEJzyLmWrGhReuqwn+OIlCNfRXYxPM72xV3NB1frqb60qjfFsAu3SN1j
X-Gm-Gg: ASbGnct7uloPzIZJVC+SaHrc0sB00dGmjc9cA8AXzuBYZLod0670jTja4wna09n66AV
	ajB5A/ShRZe1v/fONOtAgm7u/j7ha45axR1MwSbn1aQVWKO9Hc3UAHuObl5Kg+UOkNT5rO30cW3
	a/eNlZW89A5ZbK+3d9x1THHzxXpgEC+0E0VBR19RQUPqjcLXLAXbQewks9w/XNUuA/A8RI8pMih
	EimUasDMH01mJ1UOFWGQ7rZCr1fzYLc5w3Diy5O7W9gnLj25IYeOCn5ZXsWQvcEkXBYdiVmir3v
	VMMg6fEncM77AyBptVmHc2Xy8ClGVkSzAMJ2gyO4kYQOTtKypD57WmNof8MBKN+5sW+FkOAx6Ci
	LMehRNuS5Fw39X6aaWZMHNehVmhmruCiYZvg4LrojQ8VhdHkUHv38D0YXGGEl8+wzBOy0yoI8D3
	xwENrtXkQ=
X-Google-Smtp-Source: AGHT+IFX0CBsQxCnjnp9iFnMUtyP6VCztAqH/RJ/WSaTnNKx6VuGiUz2vo/HXm+TGSqcjJwYZHScUQ==
X-Received: by 2002:a05:6a20:938c:b0:240:1a3a:d7bc with SMTP id adf61e73a8af0-2401a3ada52mr6210239637.3.1754383888430;
        Tue, 05 Aug 2025 01:51:28 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (220-143-195-113.dynamic-ip.hinet.net. [220.143.195.113])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef5970sm126691715ad.20.2025.08.05.01.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 01:51:28 -0700 (PDT)
From: Adrian Huang <adrianhuang0701@gmail.com>
X-Google-Original-From: Adrian Huang <ahuang12@lenovo.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Liam.Howlett@oracle.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Feng Tang <feng.79.tang@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Adrian Huang <ahuang12@lenovo.com>
Subject: [PATCH 1/1] mm: Correct misleading comment on mmap_lock field in mm_struct
Date: Tue,  5 Aug 2025 16:47:26 +0800
Message-Id: <20250805084726.2054-1-ahuang12@lenovo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jmmancbgf9s4hbmwpp3jcwe5m718mkyg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B7719140009
X-Rspam-User: 
X-HE-Tag: 1754383889-398294
X-HE-Meta: U2FsdGVkX19LxLxycQpP1WNGwgwx6m+nSza9jIMljWQqkYrGsAQTtto3CUsj/qddt7tnXqSUYFjnO/sv45Ev6q4NxGpzUmSluRh18JeN3QEBYhfHX1ZPDD8kWsv7bZq31Zau64EDxl0UIC5m0P6yrmY5li5V9M8A/YrYwwljhucr63Xtt096o2x+vyCkwE850CLrFjqipNVaClQ5+fOW4cU3/uESJQ94saj5uXPWvpJA3EVhtEoqEtwGcvHn5thShoySjrBQz0eV6tZw7jAcVsj2B55D7+5TNsHRkTErqHfDq8Tjtp3QJaOwA/03vEOb+VYmpq5ieqsd6aCQBXYMcf/TMmzi3J1TjwR29l7vxYASvP8M6AsW7JxZsGgjUAllCPzL+YIKPXjpgUDg9sOXT6rtE6bk5klxxi4fOOERNCkn+qc+ibVicweEEyvV6h4y27r+O9WyhLb5iSdqubHZ9VzydmYncIvqULmEh5iAM0I06gHBuxOjiH1lbb63lZsofkrLYMBgk876J8tGGvnjPhwqCBn/VBfzUOr+FT8QjQjQwBzi/jLqZGngWDqfmlJD4Yckmk5NP8WWt0W2+cbJdv12kiIRMAP27V6Wn2X/vyFaWkkoBDpwoAzOkqaCEMWPG0CLOhEVlGeoKaWVzm35SY9vnqh6pSLGj1EjEDP/aUHE8VJU6rq9QZh7CGBzpWjW7q+AwPLZzFbvgRiq+AJW3icmqlh88WcIGTeOxovinmGJGqhls9V6z1G5B9VkkDKEgQTAutIPLp04HfN5XnjqGS8+Hj3p2z8M2I9B7+GdWPGezvuOeucw7HYl2PH8jhOquWLdyURu9GvTWKw25uvAcxZAMLxe6pUETW7txZkworLq2bKwVyN3eERuDWAivzulGSHbIj21bTqzdaSOAabB92CfuTTbYmV5jGBAyIXZdKUU5+xaWOQnKPtlSatlXPEAqcuvrb2x49ZNLuqvKq7
 gZTYGs8b
 4pAUH1ujNyZHgHCbeHd+IGxwltKO0bhm0J8FrVrNXWynIZZmxTQU1nMlh7QB7O/O0EYyE2AtsRE/KoteO8h/R6Eh8EV5WhByAdUwiorY20tBweOZuuYQGqtWq6RmcplGuTn5OFFw4N8eSBv/be1jv7ZLUpZoTSczyzs2f+XaKkWYwrBfskksn8I2XIyYcnKxOpFn/nbu27fA8CJHpZffttjTwtJFgFhW2XpN4MOA1xR1t1ofl3j6+DMSgF/UvXUJAK+ByDFNFh8l5meLaMDJm9uDa/V0WxpPr0H+QfTOY88H9ofed9UJBwjsEA+D8fyBti5Faae26ih36lk61j2qtkUV0QlyALRNUFxIi7v+MzRyTnEOeRAZ+jwQBGuoLLTPA4baDjO6fy5PGDJdR8AbficswhFcytF9n+cqGnGvnAIpLcEtF9718Wxn1YwC/40+iaMUUYo0urL96Dm/OB5RWHsfpVQWjPTlQ138mX/oUZeRofQVxitrHEyUAMnDVZpAT/X/812aKBRQinCcrFtknrJ4F5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Adrian Huang <ahuang12@lenovo.com>

The comment previously described the offset of mmap_lock as 0x120 (hex),
which is misleading. The correct value is 120 (decimal), and using '0x120'
could confuse readers trying to understand why the count and owner fields
reside in separate cachelines.

This change also removes an unnecessary space for improved formatting.

Fixes: 2e3025434a6b ("mm: relocate 'write_protect_seq' in struct mm_struct")
Signed-off-by: Adrian Huang <ahuang12@lenovo.com>
---
 include/linux/mm_types.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ec273b06691..ec90bbf22e2b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1027,9 +1027,9 @@ struct mm_struct {
 					     */
 		/*
 		 * With some kernel config, the current mmap_lock's offset
-		 * inside 'mm_struct' is at 0x120, which is very optimal, as
+		 * inside 'mm_struct' is at 120, which is very optimal, as
 		 * its two hot fields 'count' and 'owner' sit in 2 different
-		 * cachelines,  and when mmap_lock is highly contended, both
+		 * cachelines, and when mmap_lock is highly contended, both
 		 * of the 2 fields will be accessed frequently, current layout
 		 * will help to reduce cache bouncing.
 		 *
-- 
2.34.1


