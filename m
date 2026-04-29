Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFBFFF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257906B0005; Wed, 29 Apr 2026 02:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 208606B008A; Wed, 29 Apr 2026 02:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FB706B008C; Wed, 29 Apr 2026 02:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1ED56B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:24:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6810E8C12D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:24:13 +0000 (UTC)
X-FDA: 84710603586.26.15B27A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A37F2180003
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:24:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l1AF5oK/";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777443851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZI5B0Kq064gr2UpHVa/cd6iiCvYDn4emyX/k3XaXGBc=;
	b=5UXeej4LfxyTz+WZJ/a1BnKr9cX6/QxICCanU7uNkdAiYtV6llUMMMTWDhQi6dXu7mcbYx
	mr+nMSalxHb05XdeC4fYkAT5bX/9t7rzpW/rOrJELZOwFIQh2HqRmfvbHTI4TC5VSl2/YE
	lsxyGLM1X4kOqWzshIKMAZE1K46sv5k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="l1AF5oK/";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777443851; a=rsa-sha256;
	cv=none;
	b=2YzAGlTrCBbZIbIQtf9PTZMOMnA8KiddrFfbq70vITjWAZnaLQ1xmbnUHnAwtgz5kbHmir
	QFBZo+BTjAwms3JRHOKfdqOljspjzHdRWWYuJP+QXxXJp4ZJb6+l0i2eLRcnbMQMDPRSeL
	/BiqtiWAN8lZg+mo/J365LuygselKwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F348160018;
	Wed, 29 Apr 2026 06:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFC8C19425;
	Wed, 29 Apr 2026 06:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777443850;
	bh=s+ymMav/zVV2SJ+TT8pbk15gl8mNj7o6Akyk3HmVUfs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l1AF5oK/Ad1oKm+XDPVJGXhbnsF6R/VJ6vaENlzRCqrRU1VLmBozvcWGa4mmif8T1
	 mNtmvsN+ZRHdbXq6CwaEcpT9hdZ8RSL7Iht1u+iLrZYUszoZHZ980Qdmx098gdV4xe
	 nEsRGS7lGiZ3ICaIvBFe+UOJYsF2BWe2S4wPiE8NzUmxm9m9/D7VQsApcMsyDqKPWm
	 fdWQeclN/77TgkMlp/zJDa+fyETJGhDeXI+7cU2Gp+9260l0CcK1v9INgvtrmObUW5
	 r0rv3KpqTvm9KY4afKXCsWnGSVW7Et3KioIZbvBewJt6f66oFu6BH/JGzLPZcN5Ia1
	 CUWSjw2HqiHTA==
Message-ID: <1c8a5cf4-e6e0-40da-b1e9-83f41a8b3f7a@kernel.org>
Date: Wed, 29 Apr 2026 08:24:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] selftests/mm: khugepaged: initialize file contents via
 mmap
To: Zi Yan <ziy@nvidia.com>
Cc: Vineet Agarwal <agarwal.vineet2006@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, shuah@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260428133138.88802-1-agarwal.vineet2006@gmail.com>
 <583F8EE1-5C49-4250-A24B-0D73372E3864@nvidia.com>
 <95714cec-205e-4b56-b8ff-9afaf9408020@kernel.org>
 <0FA813EA-5EFA-482F-B8BF-FE65D4169C44@nvidia.com>
 <b4fad2c6-f2c1-484e-b6a1-97e763a39ba8@kernel.org>
 <83EFF919-7A84-4773-8C16-C51C15C3D987@nvidia.com>
 <8D71AC0C-A10D-4B1E-B5B9-606422E0B99B@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <8D71AC0C-A10D-4B1E-B5B9-606422E0B99B@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1wj6qkt7hqmpei7md8bmjdrogrhqsfyg
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A37F2180003
X-Rspam-User: 
X-HE-Tag: 1777443851-960850
X-HE-Meta: U2FsdGVkX1/CgPUwB45UjKAgQX0VBS5AilFlLDwXHv9TGm8t0Uky51zfUzLK+Ca2ZBzqKfA+hlSToI8OZZ40nVZk+Ik2FStZSJwbpLCOuDy8tN/6ije25BWitxxckkOmOH4v+dW3O2/j07+Oe8rIz+dnMKLQxDgNS/+TUOo6lFjCVrqeYo9Y/CJhUXsidEyOhB72NLTD4LZV2Q9SV1lYAgmjO7XNXp9bpXYwRA1ZWTG6jx8FaduordXCO542VEOrqgOoEAl2NdZO0Pb6VqmXqCV5YYIZM3rE1JWaBie6RKIga7K7vT/gNnwWSgg43z63QXoBhdtQeSRmrgPJNJMpz1fAsm5es5VNUyshAD0XtQLdAXiGsDHUt6fNNP8aQW2uQLCnoVgvPdgu++TxHV4w+7i+6IPptW9Pr/1qg50O3Z7je7I39chaLqZL5ad631NKh+LaznQ5t93SkVxrEIXNESZxRJQ/fH79dTFG/OTvwgLK4N+w4oIAcNYzXmdZL9t4YMXREF7gAm1FVZM/SxbEpJdkHt6ZQxlFepz+jBemxzaVv+OFUxOANFCp7Z5+Ah+nud1vNyJB+3deIdj2yyKXPGH327CM+ofeqLW64kMeZPOPbuI9CBllcg5RODY1Nsw7r44ly0flz/D1ona+O1DJPJLC8wx0gwTegfrnzZmxQXuuaM1En4xoLsMn9uFd+SccbVIJ91skoY9WxMFoGe2d4DTq3uxROO/7whD32Bu5KQhwWx/smz0B2KTaqBzu9TOjdBx9IjNZhJRBl6wmFIyF816LsTTkgdMFhXWqmf3G7U3f3d22Glt1+YUoQKfXLRSTsTULvGENOgL22lsJdS6fnL1lJf5L5YWc6AN+DqJ9ITkXwZVZnF6CxVEgSaZgK8TFDMxJ86hUZVEbl8BrXPHQRGwcTQjuHde4EmQZnXt339KGmT4SR11xoj0tW7oYquntCA45fSOQTZCjlNfTyws
 SvxfMBPG
 iOvofPPBD0O2BUNC3iUYiKyGaRTIb4+ZQpMircO4aEJfD6b1Wr5C2yzQCd79RmoA1OZUkpCzuh3ylxw4ogEdwQ2XFRPpNDlLinzVvvAjYHihx1w1FlBG+3vtSKAY2ya9P5Qw94p9Y15/oSo6UKAdmt+Y0jB2OE4bt6IOpoqrxuK9EPl3IY/f4w8xOxhPbxC3n2IUGJXfquLMrXp+gzWpW4aqaRtV/thpkqq/skIcoHeLKoVk9LLNvDKX2HWpYytJWkVEppaDlE4OjW/7umwqOmMcYWkmPqf1PNGr81ASbCVxu2pVoJMkRJHo0xHiqszqJfBN0havzAAPZf/g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/28/26 22:23, Zi Yan wrote:
> On 28 Apr 2026, at 16:22, Zi Yan wrote:
> 
>> On 28 Apr 2026, at 16:19, David Hildenbrand (Arm) wrote:
>>
>>>
>>> But why doesn't the write() make the folios dirty? Or are we running into some
>>> race condition where the old code just worked by chance?
>>>
>>
>> The fd is opened with O_DSYNC, so the data from write() is transferred to
>> disk when write() returns.
> 
> And the folio is clean.

Ah, I missed the O_DSYNC. That makes sense, thanks.

v2 actually contained the msync. So I assume we could then drop the O_DSYNC.

Note: there is no need to close the file or munmap before the exit on the error
path.

The following works for me


diff --git a/tools/testing/selftests/mm/khugepaged.c
b/tools/testing/selftests/mm/khugepaged.c
index 3fe7ef04ac62..5862a3213840 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -373,7 +373,7 @@ static void *file_setup_area(int nr_hpages)
        unlink(finfo.path);  /* Cleanup from previous failed tests */
        printf("Creating %s for collapse%s...", finfo.path,
               finfo.type == VMA_SHMEM ? " (tmpfs)" : "");
-       fd = open(finfo.path, O_DSYNC | O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
+       fd = open(finfo.path, O_CREAT | O_RDWR | O_TRUNC | O_EXCL,
                  777);
        if (fd < 0) {
                perror("open()");
@@ -381,9 +381,21 @@ static void *file_setup_area(int nr_hpages)
        }

        size = nr_hpages * hpage_pmd_size;
-       p = alloc_mapping(nr_hpages);
+       if (ftruncate(fd, size)) {
+               perror("ftruncate()");
+               exit(EXIT_FAILURE);
+       }
+       p = mmap(BASE_ADDR, size, PROT_READ | PROT_WRITE,
+               MAP_SHARED, fd, 0);
+       if (p != BASE_ADDR) {
+               perror("mmap()");
+               exit(EXIT_FAILURE);
+       }
        fill_memory(p, 0, size);
-       write(fd, p, size);
+       if (msync(p, size, MS_SYNC)) {
+               perror("msync()");
+               exit(EXIT_FAILURE);
+       }
        close(fd);
        munmap(p, size);
        success("OK");


-- 
Cheers,

David

