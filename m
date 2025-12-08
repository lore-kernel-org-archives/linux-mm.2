Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FCD7D3B7F3
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 14:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F9C26B0011; Mon,  8 Dec 2025 09:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3916B0012; Mon,  8 Dec 2025 09:36:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C0376B0022; Mon,  8 Dec 2025 09:36:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3637D6B0011
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:36:42 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E74B41DF1AA
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:41 +0000 (UTC)
X-FDA: 84196555002.18.57E9673
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 580C810000B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 14:36:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W7+IRXEQ;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765204600; a=rsa-sha256;
	cv=none;
	b=2iVZLvdE8hfjr0LIiJqN8hpsWSamj071Wn6EJmx+MnxpW/eU2u4g0vOx6hR9MIfS3nRYLW
	atPOjJE0vuBVhegNxAQbbVFYcE+OSJs343yFFnfPy8DcIPXVFmvx34UPfPfNMcZou7e/ho
	/GRjQ6h1hbqUG1vQK9SaYUVv/7V4HT8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765204600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=6hHgxc8YFTgHzctSEodlEW5cy/urU+ffIcddBsW8qo8=;
	b=PdwKj68vfXS4iu6HWFeXG6lfuLbwchgLCVL+2F6Xh/2Wk0wPrpDG/m/ug+zKShc9AUXCmG
	h+ba+a2HtCdHf8oYnQ3yFMeVp8QaOucpUd8KgEAVvv7zFdBUg6FmpTV/VJ7AM0Ktj3aSAj
	JI84XGVLpwrPbC/cuqKBpZuIUJleAyw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W7+IRXEQ;
	spf=pass (imf05.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b770f4accc0so600898066b.1
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 06:36:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765204599; x=1765809399; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6hHgxc8YFTgHzctSEodlEW5cy/urU+ffIcddBsW8qo8=;
        b=W7+IRXEQ27RWQpW0SuLa3WK1M7UTvExs3Sh1a8pcsxXCn3krSJqFR8XQA4BzzNX3xo
         yeKEbuarXsFRPiseXxD0qqjZKBnHefHJXk+i8wd+K6QzNfq0Q0TzxVb4Qxw+PWh+a/8q
         qYsFrZhDoxygGTanopyNwE2sZrUqeit8WmAsoiTEE9sUpvrF3i2ORnS3MsLUkWMDMsfS
         qcafdJKgmb+QGctvAzKT4JvnIeF5IY2Tds6WOvi/fh0bWdm4AjRUAHpE2CoD9A5crDZY
         2B2vhsGJEIsT7ri2YM+pXOmZjifxBwQSQZ4FtK282crALIAa/QQADbrsBEtYUwZ8WBmx
         wVgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765204599; x=1765809399;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6hHgxc8YFTgHzctSEodlEW5cy/urU+ffIcddBsW8qo8=;
        b=oEdlQdo0e/Kl7HtgQeamVQu9S7bVkO1GUqHT+waLT5l3BdDtIgJNmVuCeubvdlUQYl
         79MysvHrI6maC4eVY8pbyKluHcEATfCj8fykUZOSnT7BYME8ReRKG816owkk0PKKL+8m
         YKgtNEjgDbmvjlU7M3L+GIG+nYqY3Mcr9BTtXhGYfXG4Tb/Rku6zHZpR+CYrxY4KvVx9
         aYQVyBBDLHblT1jI6V01VqeHLpdoFCvyydHai8KpEzBQtKMy+j+nWrZ6aXUqhOBC2UrF
         jOPVjWx2FoacDJAM6f0zaKl3sENSGRmtKT4lyryQbBQ9A6xJopBys/hWLGYxieai+Biq
         2Uyg==
X-Gm-Message-State: AOJu0YzftEJoGtU9sagt2R4u/p23kC6O8hikY7vuZ0833L+i6JlmPZwP
	wZbJcXz9ntryrdecweC2Mj8/71lVoNlWL1cXV4FpJHxwkoi+hH9W/y6p
X-Gm-Gg: ASbGncvU8dSjeR7jZnWhRAS5wYaK/IExBtWnBxc7gqPwM373iQoRmDYjaLXcNjyoN+5
	Brlfupipt+kskLanx9dvXvKlEJkKXMJ1PMr4A92ovH7/1Gitl8SZ2sDAlLy1jlWQVW4glEznM6u
	CDeySbN7A4fvT3W97l8TYq9bNBRvMsMts0JOXdnq8Gm2rM0LG6OzCKz58Y0FHBPTPKGlB49N3AR
	AYaXD089kAApVQ/ZYDcXeTsC84ymIcrs892jmerWXCtUwVVq9vJ4+o88ES+Bk36nDwMg121zwXr
	mPrtV5VQVcXctg8bM797G3aeuBpbVyZqa1ynciJ6l0njI7LcFU9m7ID2erOG2/q+EGCoWmGcEtg
	82IXHLhOvMHIaNP6T5F4TVquoNqTuWxB1MFsgmN0wmaMsynH+ZbGCvHeXMmx2tCmRoxsH6jGBAY
	3T3QhmxdYYtEGzAjK0gMJg
X-Google-Smtp-Source: AGHT+IGFDwZaV0TzW1bNl1/sT2YYPePTsTuL5+4ayiBCe36foiKVYYZL3yTE1HcZKaXr5KQBkLtxoA==
X-Received: by 2002:a17:907:7f22:b0:b73:99f7:8134 with SMTP id a640c23a62f3a-b7a247d147dmr739572666b.45.1765204598834;
        Mon, 08 Dec 2025 06:36:38 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b79f4498ed9sm1105382866b.16.2025.12.08.06.36.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Dec 2025 06:36:38 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [RFC Patch  08/11] mm/huge_memory: restrict @split_at check to non-uniform splits
Date: Mon,  8 Dec 2025 14:36:13 +0000
Message-Id: <20251208143616.20797-9-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251208143616.20797-1-richard.weiyang@gmail.com>
References: <20251208143616.20797-1-richard.weiyang@gmail.com>
X-Rspamd-Queue-Id: 580C810000B
X-Stat-Signature: ishxupihphuqjm1mwjoe664bypqpqugz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765204600-502469
X-HE-Meta: U2FsdGVkX1+terKnbYzxRtNLbK5eglWlJ1J0e6wPqW9cSI0p4b8MsSkI5S5al4mmOsskRIgvDLE4vX5IFhruBxOhA7/C4fANbHzPyKVS0ZX3/f01t4HoNKmUcXf947NUR2x2IkceGRxs0TuNekbj+79mvHfGNwBjVIY9u+NSv+feNTSIW6buR0wceP9JD0JduQO9Ce1BddzT4MZrOjateK+RC1vqlpKO/oC+pnXic56mevP1cmObe9SZgdgjuS90ZvtG1+dcPwL183GMrjmAz0UH/bqT7Hb3XAsIJYFMhfoMIxihTiqMrkPjxl8NmQ+uk7BtiB6LiBvDlyTSFy3DIupRaK/kSEedSlKTMeG25jMbuQW24bW0aiO2o8cPnA3/MnCEPcKXUFunu3DaVI+Qoaj/xejRZW43HNvkpLKqrvGF3rp+XtNYpL1WTItUOiXq76y8BYn66t6ibCCyIVk1E1Sa9+TGnMErWKGae4YSSEAJdvcvHL1qhSdAPNSBkOIKfn7KMZXcOM4hStDjp8BF8vOxSOv6EawCnbuGzZpZ5Ua/p8jdOqG6cOXf+xAzlFMrUaSBi8V/9SGok+JALbi4iuB8lisc9rstejqtQtkc1CGs/DnOj+O9zlXkFxOvsr4lGfR9ndrdru1s+XUGCPyi3MrPOdpTC7dVjIbtMnYnWGbKJuyB4FXXdgjQzWWKwo8hpWdjJRGF/wHz5hipRC/m3FO3Eb7DFuUwGRx7jIPCU6s32/ruiEVOQcp2bQ8N3sAPRjmEYMvn+gwur01T/gXYGHiYrH0QLH1y43Yw/bUH93jgUb3O39ymxT3/FQTYv6KDZeglWaTlfkT1W8DeA9CoLuwHeljkjO+7a9ytD0rdNQXu06y1865baJARidqH6Y624Z6npsNr+2NrHW6fj0AsbwkZZXgb1vCpSdmguTHjG1cZQ5JN1ZKyl8qOSIi3zaIeBNr5nDobGLTQnRtaKmp
 QDWB8mxJ
 vy/eBVegXdUaL0fmUx/4HIwhtCffbxfAo74QGZgUrBTSlTEu2547JCFPeHKeEXPxRugmuWbrtDflOi5UOmfUE8X9r8AbX/ZJbtkzeB8jOq86ZqKBCkzl8i2CaKTKNVMCEW84Pi1Q/2E3rI2eYlZeM1zvdWopxgFG9crnIHV9LZAsbOABs0p0ibNhLTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The concept of a uniform split implies that the entire folio is treated
equally, making the specific starting index parameter, @split_at,
irrelevant and unnecessary.

Following previous code cleanups, it is confirmed that @split_at is
indeed unused in the uniform split path.

This commit refactors the validation logic to check the @split_at
parameter only when a non-uniform split is being performed. This
simplifies the uniform split code path and removes a redundant check.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index dbb4b86e7d6d..a8ca7c5902f4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3995,7 +3995,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
+	if ((split_type == SPLIT_TYPE_NON_UNIFORM && folio != page_folio(split_at))
+	    || folio != page_folio(lock_at)) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
2.34.1


