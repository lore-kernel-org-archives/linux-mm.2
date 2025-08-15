Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3156ECA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A25C8E01E1; Fri, 15 Aug 2025 04:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1535A8E0002; Fri, 15 Aug 2025 04:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BE18E01E1; Fri, 15 Aug 2025 04:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D51138E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:50:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A652160875
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:50:01 +0000 (UTC)
X-FDA: 83778369402.25.126B69D
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id D4F39140007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:49:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZsMB9Qvp;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755247799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=0UAYlgaj0WFRwfyJcLterfTnNMoo1buggHkCH2QGz00=;
	b=5W2YVeqtAqW4LtmfgmSs2fABDHhVW9gylmptXxVCNefIVE2YGvzAs2Kte1QHTzixdj0dEQ
	W1HxAnTbyVcIobPVbf2WbafqNZoMtijnnfszDs6es1ARTvPDQFCHnCrcsrUXZvilsKxxS7
	JQsNquXKtNKXPwYkNPv3Ajp4kPzjihc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755247800; a=rsa-sha256;
	cv=none;
	b=UCtuV9l4SsEnG7xiu7cVUdb8Hzoc7+MbctSKZjixYPC9kgx2auJpKm1w4Cv8NGkpjqg8vX
	496ftB/8na8u2Krk2ObCTvqU2ToZZ3UoxIWCqcPirk9ABpmPF9Q+MQ2AAL+JoI1Bo3DP7E
	BOr0erxYybNTNH4neE+MNpb3ttJcy0g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZsMB9Qvp;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so225745266b.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755247798; x=1755852598; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0UAYlgaj0WFRwfyJcLterfTnNMoo1buggHkCH2QGz00=;
        b=ZsMB9Qvp8xlS7tzvtzcKrRW4JUqYynguBSKMbMaOuGPpBk5kCiCK2P7wvDptKrWF6f
         xuOmQfLqRmd510dI/yv6stuj4hdDMOF2gQowQoDxCpsxsEtVsJtp4g3jTTbSYdADcTtf
         oeJU24eyQfMpGt3x3bOQ3kzI1i38ooNXmhrcsfE0Cg5Boelk9K2XclBy1vZLZiBxeB3u
         dyXLsCWRuJg5wdn96fa+aR6uyt4DbGe+tZP2R1hF1a9nRaR5BO3Bc3HlR6KWEYOEJ7zi
         dnYH1wdswA10bow8LBZKKTxAUUy14Nm1HVz9n9ovWr15gwvGnhAOx2nmqD2LNvXbgCLF
         s/SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755247798; x=1755852598;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0UAYlgaj0WFRwfyJcLterfTnNMoo1buggHkCH2QGz00=;
        b=pRKzRHAQ8gShXy3x2X+SDI97E8He47JfgGQf5I/w67VVvimanzxYFHA78aZEylpnKW
         Zh0IYU6Phc19YrM8GFaqT/I57yY6xtXaQ2ZRSNb3wEMOW0H4wHi6GDdLASsb8JaN+3qy
         HENKVcOlN/wEuPbK3iuqsNeAXBn6UWTT18cIqTUT1+UGgZ3caF6q3f5RywPkAGJxZFCS
         ANrv1g8c2zJubdV4m8MzJ2ISVMzylKNkLv0w5kkRxc+VcnKW1jTF/DDmiX7MAiIZsyVg
         dvX0Gc7/bipkl2gw67iG7clRsRx176fadkHJKn0QmY3DDmp27TKKu5H8B6jtG0wykvc0
         t/pA==
X-Gm-Message-State: AOJu0YzjbOq3I25fQ9FWQ3f/O/xsD6lCkpJuMbopoStSfgEfK79N6UMX
	j0GCDfyhQGc4T13rTsS+bkkSL6RBV0/lakMADRGJ01Z9Q3TPpl25kEPp
X-Gm-Gg: ASbGncsB8gEpEZnL+hAJTjJm17ihVIWwk+HUIa3jSoT1uih3MkFDKZeWjyC/gBPDo5f
	ncBuX2jLAdwwM4Js8bP5s9YhwOKeRdtjWNySLEkreucIyqJFO4JoQmXqkAnDqPA/dsMUi0LLRSn
	UzYrtg+uUp1MYeC6y4d4i/jUb/RSyRxFfDE3G5by3OvT1hOiZ2mUram1phfq+35NEMy3xpS9GO7
	pAXKTbo8t43B+X5A1/mPBXjlyttDu4fip8VjWOqmMYYzus6SO5IpqVO5swuEwpy9gKMaucFsOS+
	R+cXOQaU1hsyJIIizgEP4z/5gHNtl8p4fCX56I5id1hy2gPTYqlwVKBJ6jTqNpM78Z9j+q2iGhi
	M+suS4tG223+sKGMjSHYsXw==
X-Google-Smtp-Source: AGHT+IGc1McCDrpmoAO09U0eI9XuT12LebO5LaSdIXrZ9Qi+mTKe9/T6fNr2h3R+bwF07TJAfyuqPQ==
X-Received: by 2002:a17:907:6a13:b0:af9:ff87:4d02 with SMTP id a640c23a62f3a-afcdc288d90mr102639366b.31.1755247798256;
        Fri, 15 Aug 2025 01:49:58 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce73e2esm94972366b.39.2025.08.15.01.49.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 15 Aug 2025 01:49:57 -0700 (PDT)
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
Subject: [PATCH 3/3] mm/rmap: use folio_large_nr_pages() when we are sure it is a large folio
Date: Fri, 15 Aug 2025 08:49:43 +0000
Message-Id: <20250815084943.23063-4-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250815084943.23063-1-richard.weiyang@gmail.com>
References: <20250815084943.23063-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4F39140007
X-Stat-Signature: xizysteof6qw9axdzi7p4zc5gzhifg9b
X-HE-Tag: 1755247799-752422
X-HE-Meta: U2FsdGVkX19TlSKfDkzC0HcFmETf/Mm1zzn5VpSwglNqMenxiqP6ed5cvKzn1plnYuI8unv9iGhWsSC65YyhgE/TWf6LAFO3e2VHt4YATHmrt8bYzVEXB8Lm4qN9437tz2XfXWzOr+sg+jIRsHe7mvVeFaVu+I/pWNJ3REaU0KXDHXmxC5hdDRohicRBywbWzsdfq1FlLyaG6XLO3Jw32pcBPu3Zkvor85pjt78gmznkwmRIgi0+2yjHep81iiC8q+CGZfryqBkwRxSIHHju3TEPRjI6wAskeirRqG3tHOIluRvbr7VaBjq2ONU5oUNdAGjursMZ77oMNu1AUFpe5rcuJxct88SAo6dGQZjbK4gpEiCp6S2M2kmzA/seyuoLLXB8k6iCPj5dme9QR3sF62QXxhGKJFvmZZne0C4aN9JQfTaqCHnPEKAJGotPwIrRFEBfAIM3jjgCR5gnT+ODBZe4rXKFu041vuugW5pljR077h7lQCgAKwr9uk5Oh+R2IjAJoBFZDw/maJDAqLWkcIcoa2LD543BWz4BLVaqm+5AO45ssEm6haX4AgTsVqALQ0fF6oRHCnZaTuzB/V2hfqf3hpO81f0sQ/eVb7S+mK9x/P9PGhl4cEe+uzqtcysjbZYvi7AW5OlX3z5Ep+c9EQpEQW+QBfs1Y+YdfeNuD9lmV49B6UEPQ6qTaO8Sr2fVcNWmglFUj/X2XJ2oubH101Md08D+iPdSDF9C0fn3F8l4kkun6MnbMheN8nyv4hvLHQI3zGfoYG42Hw7RmCS/w1UsctjLqBMlyoHGg8Y4hIhlektlz8cIGepBg6j98h5U4ar70J9aGOh4clnL89ANxvN+VZwfzeJDMoQVC9X84nWJdRZK5W5sypHfaY+0OTADaE4aIkcfc2bP3uY8sBYbtaEPGwhY0/EI2yZtuP61S3jNQ2ScNZnAXUcbAtmw1RBV9gqVB0Om6X2mhO3oMCd
 TQqWi4Ir
 LUUlUsGkOjvAv4mkgr+jZ/zKmAEtBmCbn1/Q9AACX7Z7RpoIIjrZMq+eLaymvC3+Y3tdE/A+T7MrflSfEvL9dxwuQ0kBnqBSBZbdQgwOzfLZ3urKNQN8Vu+Y/2ZFZWHXH+0/ihc68jLyCq7YtvWZqr6ZGlrp6SdFbdYqO4rDnYCKzFW9g0vVPdTVmL1CXfxLnQUje7H0nyzGrz6YpQbeB9RgRSSvpAFEmVLgv4XaDJuRTuvn0ce/CHTUa6x9gl/H70zsX7s+rqo03oUaSN1w+xCZLBzmtK6/WaKkkbSgMeu4wUKknbkw85m9A8UwFAg06/Kw2NPKrCYNoXlvT7bSszQLjYzGAEjGTGrFi3HI27cuM5DEJPkfW38uvF7umImUkKhf9o6smAGTmnX+kYspdS5KgapWKC6oqmqy9wWvFzE+G5D+rn1dszIwn0QiSDTOMpWsOOCS5dBOSlloMRCR+Q3xaN1u1tD/U/253v7bNcclmRb/wNpsuFBiSVdEqse2a1VtGZkWn4aO6N0iEQm8idbUxLESK1tUlvA5SyuBmSLt5gz9/QUec8k9J35aw98xE2jDS/AXEfVw6gEwqrdmMStWp1oWuwLK/ymLowmih9bcJZgCqAscopKU5HGoNWTfk98ogNbIZFavonr6WSZY6JGAje34T6sqqThT9Er6c445ccxEDLTSQ7tFjfjTGDyq8yObBnR2PovLfcbdZvYoSjpIe0ozhI3zpkUGmnekv8rEZH2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Non-large folio is handled at the beginning, so it is a large folio for
sure.

Use folio_large_nr_pages() here like elsewhere.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>
---
 mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 645d924bfc7d..1b7011afc663 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1703,7 +1703,7 @@ static __always_inline void __folio_remove_rmap(struct folio *folio,
 			nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
 			if (!nr) {
 				/* Now completely unmapped. */
-				nr = folio_nr_pages(folio);
+				nr = folio_large_nr_pages(folio);
 			} else {
 				partially_mapped = nr < folio_large_nr_pages(folio) &&
 						   !folio_entire_mapcount(folio);
-- 
2.34.1


