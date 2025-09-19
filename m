Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726AACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 07:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC03A940009; Fri, 19 Sep 2025 03:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97DB8E0022; Fri, 19 Sep 2025 03:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4DE940009; Fri, 19 Sep 2025 03:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C20D8E0022
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 03:12:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4632D1A055D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:12:59 +0000 (UTC)
X-FDA: 83905132878.21.08A3C65
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE57280004
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:12:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QV+O/HFQ";
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758265977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=NLGozOOt1IVRUMb3crUj9Bxlg+CaYn2TCRgX+oQe2Wg=;
	b=JElldpvcalmGsb0W8dyX0dGaZYhIaqLtGLjHkfAA/NM1hgQVa/q4vtsnfCp864cv6vBZzp
	RvAhk2sWihx6k2yuXb0K9gtAZsusdIP5mzs5+dybYpCOXvC0EbdalGjdDn+2PHu32dTNXI
	QWYgans0N4qt7zzMQiFbpCVJ6494NnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758265977; a=rsa-sha256;
	cv=none;
	b=AceIX12cbXui9/URrkNTrnZrpHA4DxRaNY+bQtBe4S+xfmunGeef+Flhsi7T1ErnwzlBFQ
	VIwlw1/0h85UsJYutRJJ4b3aVOt+QL7GM+6xp85Pyju6w2HtIYyGQByBidmoOMGyytiKOp
	KCNi6TAKKYJO7nSmus3p62enMz96kyc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QV+O/HFQ";
	spf=pass (imf30.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b07883a5feeso332214466b.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758265976; x=1758870776; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLGozOOt1IVRUMb3crUj9Bxlg+CaYn2TCRgX+oQe2Wg=;
        b=QV+O/HFQ5dq0G9+fgwiS/+S2eFXOzVh7hneKDCGSqFeCqmpTQK45j1yadC+Ujgsspw
         mJdvmvC4VnWekYetPxTyDelrTvNcXqCnwz8YTiTkpLlLF1RMMenj7XA8cQleBrkZ6fie
         EN4etg5LTWOt5IyXx+M6nsrkjA2C0jXQ7axPWjS7Jq9QD3gS+BhAGqs0aIVygVThmLwa
         u7IPtM3yHFuxcRBSu/m8QvYdHBqhlXlrtCC8QCD4uit9ymBORDtQPmIRktdmwxQpvpP1
         PZ9uhv96YREp1+vgwOpEkem1DqKT2h8ERinrVTreBo7ZFlFxfkU9K2xrjLWE6MCJGD2q
         SoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758265976; x=1758870776;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NLGozOOt1IVRUMb3crUj9Bxlg+CaYn2TCRgX+oQe2Wg=;
        b=HrV2iX+27R3jr9y6sjxs7By91f7rafcAnJwhxUWhrmrGdgd86OAo0cbbondAW5WJaW
         ffalJgXSl2rs+eFOF2nV6Eeaq8kEBF83/HJ36YgZcWNUVIDgYlCVP6lGQXquTp8DKznA
         nA7YWVKHky6bowYWJuhuAGvCBEieguyuFurypz6S+YvOYWSq1/n+VRPYscL8mZKkboA0
         qzwSjrz7QYkh3+bZm4qZPq4qk+R1JA2ZaRtZtJ66LIVxgb13Cf03vd8zMP+Rtwnvgh2o
         hbzDf0Vp1kjjMgX+/+nth7c9Cufijiel/4yK+kxSRVZpL2j8+uHlDKhPiCmLSD9M/Kmp
         mrmw==
X-Gm-Message-State: AOJu0YyGLkk2A0PxfUS7eC6EcKLGE7PNKjUdZF/ywQceN6lUYeWB7XLk
	G7RXyejLTPn2sT6cY6rQJh8yslKl+U2rgOHkWGGrAxHQ2DgH4AEjHOCY
X-Gm-Gg: ASbGnctDBLHdv0zc8SkvNFlZssgd7taVvOdMlxH7gmg2smeI0sXPLWPIe/Srg1dhbq+
	wIpyvyOZ0Qx2asFiN2TwO6sBGZNWZyv6B2AiggXeb695+4D58zmrSvj1IqdfQ+yIhUeQ7rZ7Yzt
	YQYCchtufsc9ZZfR4GWbc/CwJM9hd/JjAlL+JVLBW1qoYTDrFjzIcHZdEqxWUAhy+HKmez8A2U1
	Uf7YFURK+gRrfFqsq+BQfhWjzvhCqal+erUxnSUE9FULtqJtA9LXQjhrFYstCSlIfPpZtjSHuTt
	B01kqHtTfbNyJbPGHv8q6KgxvWulfraGE/neKXgps97l4xn2KA1HnoxnHZ2vucpBIk41xWw9NUO
	pZ2SsO5uD6DnbTQrjJNM/7g==
X-Google-Smtp-Source: AGHT+IGSaqod/w84tcNyXd0/cFXPoS8J3j/FLhYBBBphmU3OiIItx2EtIGdESvpO9zGxKEr/TRF5ww==
X-Received: by 2002:a17:907:9811:b0:b24:6e6:7117 with SMTP id a640c23a62f3a-b24f3e5e097mr223295166b.32.1758265975714;
        Fri, 19 Sep 2025 00:12:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd2816769sm366753566b.106.2025.09.19.00.12.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Sep 2025 00:12:55 -0700 (PDT)
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
	lance.yang@linux.dev,
	xu.xin16@zte.com.cn
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 0/2] mm_slot: fix the usage of mm_slot_entry
Date: Fri, 19 Sep 2025 07:12:42 +0000
Message-Id: <20250919071244.17020-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: c3yps336tkh4s6ibiko8bm3jj8mzb6w1
X-Rspam-User: 
X-Rspamd-Queue-Id: AE57280004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758265977-178531
X-HE-Meta: U2FsdGVkX19e7XwKdWqNF7v3j2AjnghYcYgFPnvCkWcJjlVYSJigGHKnUCsolgJltGGMXNqrHErKVNnkLzIqi9OQRlAmbeMGP9juxag05dIskvx/qEaKC4A/6CR5URrP6t6nRzds8otSRkd/m9089PFStLLSjq62bKe90d8eLzQQnDsJz8Zlc7up3cUrLapkmdouWzcwbIvPwTN34Sg2s5+AzTuyrroIIWjFvJaMhm0AmOlXs9M8QKcEh7xOThu6PIi9QDHlbtXxwWk/V3ZgLp7vTQZxWRvUr9XwmpdxGN58al9N+CJLETCG8u4fq6bh7rhW10LVmTgcB/a0ioFHGM9QhWu+A46cD4IWl06cgq6q6Ydljwi8iv9Zbyp5W8GCEczhAsD87BwGXgmQzcRlXR5+K05sF8uqP2h8bAj1Uy7MznWs2EdMwP60ILT6U+Z/H8s7h7X7O7rdom7Ht0SFBWXrzqHywxauI7KOYSRFQ0ixiNve1wHQXG/si+laTMUonTVODIuWhxG9/f9GdEh2K3Wk2bCGBI62/deSckr7UJaxb64YxhEtCeot2rO659EjsYcdgfnSnar+HnvumYUC2FzuJ2sX6OpXXfnbkgDQy39ERGNiOayJEM+37/5C1VHd3aC2UBNKPlv+59C2NpGUMP0qbYzbptl4N2T7PEj3v4A97Plf/fvOETNaPF3XQgT8YNWRNJEmjg/eQh5CnJl9okUTF6O44W8xUWMy8i+P3nRHNbZSe4PFfO2rPnEjlRpbIAfVTYiL5daiGr3OzBfsJ1pi0V0h4gw8Gun0psU3Jl0qwOTQNAO1EpawfRW7u3QKk/NnPzdAuRBs33ouitvrwhRKRw0hEQnAMQ9KgiDuw39dkQ9WGAHxtxdLL4s+Bf9wuPfhVk9TZfpzj/Zwq1kZ4kSpvAcyj2rkfYYIPk0ijfs3ln2humYyRYjwC+FR/p1xiK4I6tD3X1SC8gyWvN4
 u52adp9j
 ZCKz4qZI/NyPzrQHgDj6DEXPa3QjKpgbKvlUaQZ5LYJoxL2SBvVEu0mbDRCiVmoDeEQwYOOiD6em9TxEFeLToPF/+czlJ2Y5U0i7Y1BhIdCE1lHaz3zSYrCemGMELjKezezF+KyiWCF/Xwhr/2xbkyY6hAN84C1mgqF3T2zMcS46clV8Q3o8Aqzrq4lQl9SyNYpYfJL8cAL37tJG4Ne5wJVRZTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The usage of mm_slot_entry() in ksm/khugepaged is not correct. In case
mm_slot_lookup() return a NULL slot, mm_slot_entry() should not be called.

To fix this:

Patch 1: check slot before continue in ksm.c
Patch 2: remove the definition of khugepaged_mm_slot

v2: 
  fix the error in code instead guard by compiler

V1:
  add a BUILD_BUG_ON_MSG() to make sure slot is the first element

[1]: https://lkml.kernel.org/r/20250914000026.17986-1-richard.weiyang@gmail.com

Wei Yang (2):
  mm/ksm: get mm_slot by mm_slot_entry() when slot is !NULL
  mm/khugepaged: remove definition of struct khugepaged_mm_slot

 mm/khugepaged.c | 57 ++++++++++++++++++-------------------------------
 mm/ksm.c        | 20 +++++++++--------
 2 files changed, 32 insertions(+), 45 deletions(-)

-- 
2.34.1


