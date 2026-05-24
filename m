Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78B8CCD5BB8
	for <linux-mm@archiver.kernel.org>; Sun, 24 May 2026 01:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14766B0092; Sat, 23 May 2026 21:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EBC06B0095; Sat, 23 May 2026 21:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 901506B0096; Sat, 23 May 2026 21:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4E26B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 21:48:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AFF9A0B51
	for <linux-mm@kvack.org>; Sun, 24 May 2026 01:48:23 +0000 (UTC)
X-FDA: 84800628486.14.EDD6615
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1948180008
	for <linux-mm@kvack.org>; Sun, 24 May 2026 01:48:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FMgBYlCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779587301;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WO7a9U4fsCTq1SpeHYwHmvNatujDJSQpb2AN7xfznlI=;
	b=B9tJk39kIHqlpXsptTKpSEIDJAR6SyjEcpXrS+nZH+2Yc7s5ZVzLX7SG+YxpxGl9ssvezt
	1ckumUbbK6dvQUPMIuwZ0w+ukgLJNtOQuk8ix4cxJ1pZ4sjaam2tfZpszzvgl8KaNplTTE
	FRJ7Ejp5D/7jUQHZCd6Wj+4EWZvf54I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FMgBYlCv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779587301; a=rsa-sha256;
	cv=none;
	b=5mE/6Szlmwn6NmnPYFtB0mEHDCAFOQ/QBAK25xaXzqbU8GSgtpwMmaKe5sFfVX+cT2HHkw
	9/mH0uC+L6a1Crf8UprSCNS8dJCDhC+RyHucDVQcOOBPDoTdDN6t1ipPTpzo2sXuX2MDpL
	QRdup0WcgQeqBvOgx7wxM7mY5IrQYGM=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bd01481e592so1188186466b.2
        for <linux-mm@kvack.org>; Sat, 23 May 2026 18:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779587299; x=1780192099; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WO7a9U4fsCTq1SpeHYwHmvNatujDJSQpb2AN7xfznlI=;
        b=FMgBYlCv1slo5HuCA6zVqW0eSxqJrXwXNd/wlcqONdwtOyPpszNOkY6w3x8b0WBTM2
         Gr2Oc/JpA0NWxXNH+RWqUpbK/SJERx8EaUbuJk7sPcZhoidoe1JOyzDvIRH6rmga7Htg
         OeD2BdSmz1ZN9U4SZbt0Qm+hghfL5tEKmOjqLKnyPlLxcCuKfKKA00AK/RfmfWARfnlS
         y1OV/idxG0BSMqIGO+J/wBKEXi8IUOLF31SCQutz2CFeI2PGadyfMU5SHncpTJ01Ob8F
         Nwn5OxiEVaDBHFfluF8VSu1rlXN2E7NQ1WOFP9y1C6kk7ogAprvKmxO0SUoXFITGeq35
         CGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779587299; x=1780192099;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WO7a9U4fsCTq1SpeHYwHmvNatujDJSQpb2AN7xfznlI=;
        b=nnmUnLzS7qFQ2VtlIpim7YACRvtlzrj94tJjFMk+r+ukqehnTRtvuwkRiaCihjAgHz
         jprcK+OuCyQArv4Ndyjspgn/AG3dJ93oj0UJxlDJlBiurFrlmWPIDEiJShWspyU5Guen
         pqTGelCbp07Ag5kzyK3DzzYhWLqsCrDVFp2tNAww6hErBz6TCVBXRO3WjDJ7YsbpKF2J
         bL4KEG0IisIixXTcMcJU/GoWUP6Dlm6lSeVMBemXCgrkYcnmIk6GRgd/q5XO3mbLVs5v
         kWwo64Z/h55Wbl8SeT0DUEVBkYU0zsl1Hd3V/m17wBHp+ASdJL251hGYKKXcKLVW545k
         jbCw==
X-Forwarded-Encrypted: i=1; AFNElJ9SBS7E1I1bzFdJ3SmyYJ332qI+lcJlW9O+44UjIJlczkyDyVJR/F9XJC4zQVQxTvJiwLKYNUSC7w==@kvack.org
X-Gm-Message-State: AOJu0YzKVI/cPVWVmnNHZ1h1owKSkyyiHR+QJN+oPmTdp4u+OYj+QpMy
	XUPPj3+qLsuOg14dvNIAqru+UM6aCe111vX7PdcMZlRxkG4NDEbln8aB
X-Gm-Gg: Acq92OF8T/zZUetySB4NAyi5lKWCSbRrcZTTRE7rw+dri96XgL6EP+QsG+bQjZuFTko
	QGZ54r1KPnw0ckL0TcB9kdeVWTzey6qcwpGrc+FsP0czjGhZ0YEpWkz3CvjUMoQ+RH6aJtjMUO6
	wbkULO2Zc2COn1AG07PWQq6P5FkTbb+WqStMt9FcZW4mVW1Qy9evA6AN5dwmbQ0idseoI9j7Kdv
	THqRr8k14UzEPhiQgRbhb+KOeoUzZn2B2il+9iS5HjuF6GTBjWQDBC0OJaViUcheUkTr0xZ6O7P
	mFO4BqpQ5K+dJukuG3SFmJGvNuEv2h1hMSbBNmU4u+IxHxdQpGG8AFg8MdWqJ1UGSUDEyG/f+Ay
	1EzULQW+oV1dY1uuocuc3kFHzw/Tnn3rfWPdGrVNE0KCm2wtLpgTx4BivNayXub+PAf/1fMZvon
	SF8NOV1/f/NybiH1jERpflGg==
X-Received: by 2002:a17:907:928a:b0:bd8:f4cf:388 with SMTP id a640c23a62f3a-bdd263c976cmr509526466b.33.1779587299162;
        Sat, 23 May 2026 18:48:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bddc62d9520sm241095766b.50.2026.05.23.18.48.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 May 2026 18:48:17 -0700 (PDT)
Date: Sun, 24 May 2026 01:48:16 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>,
	david@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests/mm: close fd on write error
Message-ID: <20260524014816.4aivvwqa75fad2sr@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260520020336.28914-1-richard.weiyang@gmail.com>
 <20518530-12e3-4731-9b4a-54cc950239e2@arm.com>
 <20260520093824.eannlavh64fpxyrz@master>
 <20260521174951.d16f76cc39cca19bb5d6ee70@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521174951.d16f76cc39cca19bb5d6ee70@linux-foundation.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: udmq9arw3gxandr1cwnycifsd3sa53me
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1948180008
X-Rspam-User: 
X-HE-Tag: 1779587300-927278
X-HE-Meta: U2FsdGVkX1+gCHqn3ISKixbvIr04XZsnlw/mvFqoC9sF0oLrwGNfeDylzhKxVamlr2xHVS7EPpWPzJH5PbOGGHA0aOrlk/hwbJ3+lOHJ9J9e1ZiUJMH+c84snp/atqEbqbx7QcoDmPL8keJb3a0JaGBP28u8lBPppXOFOGqP9gvbdEAPXiCKlFL73mB8D32bOdnKPQRTp98EyohT8/1+ply+InGCP+NOlfjmSvkD9COeSM6usABnQamJZ0sar/SURhfT2fTHb1//1j15/iUkvyzEUQ3zhETS7Ezbw6K6b6llW2z6hAiUIKQiqs+VLSzKxd0Coy0/qTtoTwzzdo32r1YnqVs2vVWI+ORDEpFI02UZLgRZSLgoyW9YCYzW/jFGA//Imw4RIMD9fnV1j62/jT7RNqeFVGcfgbwisPm8u7VMasKsslelKNw3R1QU82vibNOVkGh6UiNIJcJSXpFyxdcPxNKtTU3yEvldoDAUo6igdWnCuljf+V2wPbx3hpAR+A6naKtOame2QlhOnSBohmXfg/xnyerOyNNAi0VRuq8faR5QTTMQ7ITH1DFfGKf1lqvtvwGPK9MK98gJJ0KCjb3e5P7f51YJHIUDvvxd2rjl4oXr8h6tSgwnLbXKrRFZENpZ8AePbBSzJrsg9wMAqjtxqdxzyrLf7T32PofEzD50wWeswRcRTJh6tYB+diSG0iyqzj9wDgDiktPVCWGIWaNKlLUvgFvzZQ05aGRZxd63rO/Jvz0H3maKx+ZhC2uDP69Z6mzpog12gYifDQsmZc+TafRX0yYRHa/NyL/XDHnf7VBXriEHdb+a2XxnsGeErFCpncSdGVk28hpvSebigW4yLbF7QJRlUqJrTgt0L350jrSnIrPdVu297qifNQxWPuR7QLHteD8THVgfBCkhRctET9V5SoWx4gzkUzM9k+udipzgS5M3x5mNkMSa5EMq9kZmH8qkP1k/jP/i9ew
 VeTs2wOM
 PrH9If8Pbq29QcpFsABSUPH6pXlj/A0cI04nWoKd0NmHV8PKMecyOPb1jBwUaBmTApxHw/GhxCjIaFSqeWYDN6WujkeGYb/rcD+uU2lmWNjRa21Xe5EweDa/fqICwFO6TRNqmJm8iFsxI4/gBJ3Lozm6M1mD1NmihqC5GSqH6KFCYQzOHitzYu4KRcGmbqy7EHHYrNuwt5Ur3GqMuat08KN/XL7HEsxMzl7yGrjc6h5we+uIPfY28TaLSGKNWbLagxagy0kfQQN4/H3nHV76p9+QJY9OtRDG5yJCl924jqU+AEX7QMPNO+VM12wwyTy8kxKbMbOwsX42yjilW2NgXivQmqSFXOQZRCgo83Ng9gxW7LPMiEGKn23TG9PT3AthpuKr6uuGGe3CPSTnfNCYtd5K/YE6KmZ5rVR5JmwHhzZu4TTcPPs37MVUOxhHlxdPzhZxdVx39+vKcQjweLktVyvSGMa26HofcJrp7izx7UgjOoODY4nKNgJMAuRwQBlJJNNoA+YEf11V2vnOkR49/yhI4Kj9LNiiQWI81f3eRoekJUTtQdsHjxxkNhqL5xLJSA3+pAhvdZYVuVmwZnAaUhLRORYry+hlcRAVwaFgv4oWCPr3Xk6jQZne5AZNTqt9XF1VXGYZtjOCgGnEExqWk4hyGascnSwo5IoyBiE8a+7CToWBhybsJ/Vf2imoV9Bj0CuJv+p/Xk1O9P8fB6b+H83MA4wR6vhaD6O5GGqvaBFmfH2NxE+DmLwxB67gXaG1i7t59YLCXYHeB1uQUwCzo/7i0Ukbeca/oW5kQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 05:49:51PM -0700, Andrew Morton wrote:
>On Wed, 20 May 2026 09:38:24 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> Subject: [PATCH] selftests/mm: close fd on write error
>>
>
>selftest/mm is a big place nowadays.  I'll rewrite this to
>"selftests/mm/split_huge_page_test.c: ...".
>

Thanks, will do similar in future work.

>> >I asked AI and it points to another problem:
>> >
>> >for (i = 0; i < nr_thps; i++) {
>> >	if (is_backed_by_folio(page_area + i * pagesize, 0,
>> >			       pagemap_fd, kpageflags_fd))
>> >		continue;
>> >	ksft_test_result_fail("THP %zu not split\n", i);
>> >}
>> >
>> >ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
>> >
>> >"If one THP is not split, it prints FAIL, but then falls through and also prints PASS.
>> >
>> >It should probably jump to out after the failure".
>> >
>
>https://sashiko.dev/#/patchset/20260520020336.28914-1-richard.weiyang@gmail.com
>doesn't say this?
>

I took a look into the above link, but not see any comment.

Not sure I got it clearly?

>
>> Thanks for AI.
>> 
>> It looks we should "goto out" after ksft_test_result_fail().
>
>I'll assume that's a separate patch.

Agree.

The credit belongs to @Dev. Not sure I should send the fix.

-- 
Wei Yang
Help you, Help me

