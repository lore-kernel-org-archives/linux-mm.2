Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39BCCCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 01:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5388E0010; Mon, 20 Oct 2025 21:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456178E0002; Mon, 20 Oct 2025 21:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31DF68E0010; Mon, 20 Oct 2025 21:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FAD48E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 21:29:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B155347E11
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:29:21 +0000 (UTC)
X-FDA: 84020388522.30.5946CFA
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1C6840003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 01:29:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FpBblKX7;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761010159;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XbAeAhvigMJAS3c2tXoCnvk4KAjUZ+kOzf4CO+MJDfc=;
	b=2E5Hq+vVfTH3qkkV726GNs3TwNgJ7M9kzdalZE5GrkXq1mc8Shn62MOPWaqVr0ouYPFtap
	ofhIdpVWV4Q7l5dr+xZCvve4EfQLZi61O1wg4jYtxtMYq+oG2JcZaAg5QS6DtH2vfjMmrj
	38AnoUTSlUiKI1ptINLZw+Z0hPov004=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FpBblKX7;
	spf=pass (imf12.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761010159; a=rsa-sha256;
	cv=none;
	b=VxvLWUSe7MpuSakcHkeKckzxoMu7Q2eCjflgG7BP6IVIYGcfh+ovoZFmU9RfZAPhIWdaMi
	RvKSmk3XQtxpVpbj4YK8BOYpyts9qfCQAMn5wxitZ5WDwLIJ1W45V0Yy1W8RrodRXO6RYY
	ehVfGKogwcfRaLPtwY/CUtdCywGMQxE=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b5c18993b73so816399966b.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761010158; x=1761614958; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XbAeAhvigMJAS3c2tXoCnvk4KAjUZ+kOzf4CO+MJDfc=;
        b=FpBblKX7imwETQoCGk81H6hYuUUDQbChTQuBvi+tYA7Yi+gZoTagyeINO065UZt0nB
         ERa4zm8mGI1DSbB23GCqgI7/CjtIqnJSzPKnIZCCTOjGlevt1YeSPduf3sMDv71pXrph
         woXsS+N6GpWL745B8zywfPihJKVBxfOBYnp28k2kHpSKJYu6i1nGc3wolBa3S1yi94OC
         juiIAGQl+eJjJi+FNiuZsIt19GqYen1eDEsG2lrzV1d8MMmxKL9uEDJ+yUPWsAkS9las
         UpYGyrtuOX7IFN+FgX+DQUaFfJVvfBmZuBcTZpheDwmUIZes7Qdl84PndqQzd/xim0Ng
         BcZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761010158; x=1761614958;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XbAeAhvigMJAS3c2tXoCnvk4KAjUZ+kOzf4CO+MJDfc=;
        b=YPA59JSTf0IdgOXtYqizsZ8cv/mUyz2idxdg5KiOhZxDXqWOyMcGz5gIhb9w+jJS6l
         cFnQCnSGamptCcVTIKo+/cIRaa4X5ivG1SMZ2viOWgyGqWxZhtJhUA3i/d2b4HiVp+kx
         j34wJJchAMYrSCvQ+0235z+ijQmE9OvQD9CG/xZCKH1KqtSnoFGhOO0jvjlL/LS29SR7
         kItt0LIkGQJu2A8BQRiQS8k9aTXZ7pYgFQ7lYA0mUg6BwH8j/00q3QOZC9W4kC/4DY7C
         8D8CCOh6knywAzidjIuS/UVaq0h0SQrBcOVdA5QnnlKvKSt3W3BQXwNf9hMXpCDiZzNf
         oHZg==
X-Forwarded-Encrypted: i=1; AJvYcCWM8Ibys52CPYD6C9QEaGPFMaDswe5J6hX16AtOXv9S86iyfsc7B/ZcSZo2jDzqhGx7aisaxsaoFw==@kvack.org
X-Gm-Message-State: AOJu0YxY2yEGCmdj6ZLa3CYmbBu96TGIMQI3E6dFiRkSFiMBnMB80mPk
	NnQqqT43CUmmRJiAWESVDOvCKyqjB/OoH84OaNYvhfMefDm8JGLptgeK
X-Gm-Gg: ASbGncvoI7J6UMfGXItZVLOww/l+M+dXehHiFJd8dGQ2jEY18hkM8HwB65Junpdhd3p
	Jc2YGbanz6ZpaEVfszZRNiuy4EoGxVOIuTiwewZw6nywJbVsE6+iK0QMGRg0Nxqz1PLYvw999aX
	8Xcalro0fDSTy0IC2th2In63yZg8zphaD6Yg1mh2hmk5KguPvg9lZ/CpbGxUeFqbaGIDWhBJYZ/
	eEHcxfFwFZpwjJpQVh8U5ApG/eOpHqtoJvwr8nf614dJAyTLQ5TUpRi/dRB/sZguX5PCUY5lfaf
	JdhDOxN4yuk7xd09q/t9YXUTOdLD+pQcwnpM4dZ/0K5hS/balv/WVUqKMsXHh9TrGZnWLaH3D0L
	bUqZsK3tS6xwj41kWWAjPz8vwy0yJndEqQLt5UtToaVIeHRhTctkFZ8tC6IA5CmRiA68XuI5cSd
	c=
X-Google-Smtp-Source: AGHT+IEaH2H2LgvLbz87krnRsRO92Pl4X1QpotTP6cukUX3DXB/2xHYU+4teR4vU4XoGFAF40rZTFw==
X-Received: by 2002:a17:907:7203:b0:b1d:285d:185d with SMTP id a640c23a62f3a-b646ff7d658mr1804922266b.0.1761010158071;
        Mon, 20 Oct 2025 18:29:18 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c48ab45b8sm7990881a12.9.2025.10.20.18.29.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Oct 2025 18:29:17 -0700 (PDT)
Date: Tue, 21 Oct 2025 01:29:16 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc.
Message-ID: <20251021012916.gkxh6cenjivwj455@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251020210816.1089910-1-gourry@gourry.net>
 <20251021012533.56rdl6v76plkw4nl@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021012533.56rdl6v76plkw4nl@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A1C6840003
X-Stat-Signature: 6d6bkecwzi3cza66h1ffzrfes4rk7pk7
X-Rspam-User: 
X-HE-Tag: 1761010159-128967
X-HE-Meta: U2FsdGVkX19ypqWgbJpYBNbDK27TtElDKi5kA7vcpV6qjChmr9YL0Uk8l5mmMQyB2+2ptBZTL2J9yjhDTO5t+JwA4voGdh6y3yf1HZIlyjuffx9qCTH8UDaQTWgXZxLN7O9CkmeyP8SGBz6N1tqknV/5Aou5sjpcr4zdcSDVXOFEhQQBtVtGhwyr3NGBHxtiIku6bNU3IXhNV5RiUmDkQ/nwsLyrQIquuOrHjvaoqubYZPQNACHdIzX1Y2rr9b8oBZPOhcqP96TZpqtUnHB8etRBcTRON13Mz361mXxwA2STtykDALE6UJGDaYtrmdgcp6p8kZpDdlvJ/VQrgNMRVbMj9e20JnwU5p2WJFZjEkhoggTviSVIwVbXP6O+f4Wlh3JDfWvotyIaup/BAcaaFZwC2erfDrUo4QJa0s5C8fRbL7t3s3BP6Bb/4Krj8wYjKb496KH82Y5uZJZ7BxRXqz5FQAyUSXZ47je9E1naKuecPx629NyCfX2OIXUGy7NfUUq3Gtg142M9zdAtAGeDS+4mYQcmK/cfyJcmtDnQevEvjFpo+pz/1S2iGAfnOQmWTaJCfa7n/TMzc/V4LVlsFg3NyXpJmSAzsARMMK5mxvoWgyaPaSqcwgTfisNVTUNPsTODDtAY7F2yjiRb6PDnU+Ehnz3kqI3+eBsuajM42nNXn+nv+hC4LzpUKqMQw5ZnxVKhC8hI1QJ8uMfwlJmPKzt9AgEf4OLXMnWiwk9OG88gvyEyyt4uzGq3iUMeXQimn72d1okSAs85BsxzYli4c4mSqaFoS2VgwKm/tmQXXM8OK/GRNm43oqz2bKskIIZiKNIw1bQNtYArrPXb/VWZy0nPWrTbUAJDPt5p6bRXx6vhy3KEI9opq+3ypczbCiFKH3/n1a8tXlB+HwTJYAYv/ovOLjNfpzGF5L/BdAWXrcykg5HXPm5q9kmxKzWgqMrUuZxeXkRNG06RvcGo6A9
 NDJ5aMj4
 78R6eWwkVYMA9LwVtPw7MXgfzq0CVwqLXxAkjY/OupSUyvwZoDnDoAjzYCAMgKdhj8I500FO8J8BQ9jkdybu0OKPFAI3FvOTSdSADDwq7IicPIlw8T+XLjaTqMYkj8aD7Lj5K105KFrehLNXjWsnY4dQ7tBlBaW7rEbmr4rHZVTHQLyKiyIjyLJ+l0zRhb82N22Z9iCZUXFvV0n6COdSEOIM9obKcP4tdG01DENWPa+wAP/Oymk3E2qEjch5uUwRdiuvaSpZbNnMDhuXNuwXYFGTEhA5Qj738Yab0CtbJA0R/HIaNbZ9Kxv0GmmgrVJpKoq1N7IGOelcu6TcqL+VFDybU5IgERyfnHQX1/cYgn2ayoPohWeT4ZD4RTyx5FkzvrYGkWGhACDkDoSpaBueqpxUK6mBvVZwgS0dPcQqgPoXvQnqfxplQJ08SWsegoFNmtYc/Ok5mN2AqdUDEzT9cfciRO1ShXqJHSyYJvWnV7h8H9nVXyxq8XHplkaikaHGDdNsrC8j0Tr6ahyaD3LO4DPQKUfErpMnYndN/4nFom7y7Q6hor0Vkc/yQGrQNBPmoQrwZg8nlZGjpF0+lYwZSLS/vucDw9INiUjb79a8ommqnMiz1xge2Qm65IAyEf0FTqvzI7MSYUAZYwnwuMJ+zy3ZjRH70EqfmMnuOcYD35LLR+p/LEpXWlU8swTz4Ejv6yOcXjL86Abn/xzaJKB1zBE6elSQWWPiL9iYo/AOu4cG92SiKHfph8cBGPySDG1jK0GiQjlfKKr/U970we1HEQBMRUcSphzrcH01Y3SZdM3Q6ZLQ6AGMEjmGpSszRCHMymhurjKPFJTgE6Jv1whSP2pry7RUdRDg6NHJ03m8QMs7fnrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 01:25:33AM +0000, Wei Yang wrote:
>On Mon, Oct 20, 2025 at 05:08:16PM -0400, Gregory Price wrote:
>>We presently skip regions with hugepages entirely when trying to do
>>contiguous page allocation.  Instead, if hugepage migration is enabled,
>>consider regions with hugepages smaller than the requested allocation.
>>
>>Compaction `isolate_migrate_pages_block()` already expects requests
>
>isolate_migratepages_block() ?
>
>>with hugepages to originate from alloc_contig, and hugetlb code also
>>does a migratable check when isolating in `folio_isolate_hugetlb()`.
>>
>>Suggested-by: David Hildenbrand <david@redhat.com>
>>Signed-off-by: Gregory Price <gourry@gourry.net>
>>---
>> mm/page_alloc.c | 15 +++++++++++++--
>> 1 file changed, 13 insertions(+), 2 deletions(-)
>>
>>diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>index 600d9e981c23..da2e65bf63e3 100644
>>--- a/mm/page_alloc.c
>>+++ b/mm/page_alloc.c
>>@@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>> 		if (PageReserved(page))
>> 			return false;
>> 
>>-		if (PageHuge(page))
>>-			return false;
>>+		if (PageHuge(page)) {
>>+			unsigned int order;
>>+
>>+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>>+				return false;
>>+
>>+			/* Don't consider moving same size/larger pages */
>>+			page = compound_head(page);
>>+			order = compound_order(page);
>
>How about using folio_large_order(page_folio(page)) ?
>

Hmm... I see the discussion. Forget about it.

>>+			if ((order >= MAX_PAGE_ORDER) ||
>>+			    (nr_pages < (1 << order)))
>>+				return false;
>>+		}
>> 	}
>> 	return true;
>> }
>>-- 
>>2.51.0
>>
>
>Generally LGTM
>
>Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>
>-- 
>Wei Yang
>Help you, Help me

-- 
Wei Yang
Help you, Help me

