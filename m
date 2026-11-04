Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77628606EE86
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=l+8b+qDC
Received: by kanga.kvack.org (Postfix)
	id C83016B05B5; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D436B05B8; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A9E6B05B5; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 66FDF6B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:38:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E2394120772
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:04 +0000 (UTC)
X-FDA: 85398296088.15.631FB83
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id 42EF120005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:38:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l+8b+qDC;
	spf=pass (imf31.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793817483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=G7AXQfq4m6o2RX2w0JId8q5zNKOwsNSA7U5XE8gBSZw=;
	b=v1maZLX1h1ZiRHFHf4weTuXqYtv+txL/E9/V5g+vN5TCdefS3CP6SfkT0OtdpJKYPHQkTH
	NjCwFBWx7Se6ffOgoC/K/7RucZWhHJpJ4C3d1einAFN+rlbg6exiO5i46rrSuVZW0gI3BK
	lv8JnCzFqCFcvzY2fO8F63nnUJS1rPQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793817483;
	b=53em88PQu+Te87zLb0mind+cPKkfciiRTOT7xJZ0qrWO+oCeEMXgWjy2LdxGrqQed33d/5
	nPT0/OGQPEr5KTozAIO0/Uw79JmglmW2Oud19NfoUyHPkZh/BHmlSvxHwLQ4ytJTf3hKPi
	rwiRrnYJwY34V5Jo5lKlK8IvI8GSufg=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=l+8b+qDC;
	spf=pass (imf31.hostedemail.com: domain of 2dgodoy01227@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=2dgodoy01227@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e60f9af6e6so10159055ad.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:38:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793817482; cv=none;
        d=google.com; s=arc-20260327;
        b=lyf/ayC3Wh9ii01mXNlAtT9GQlj6FPF89WPb0T7nvzNl73JYrOr+7h7Pin4pj4ISNz
         k108L63o/ErtXupxiInA64UFag9rjOnvU3v95FwQNl/fUCQGBceArjFcxMWX9S2KebII
         2LYZ2hCr3HhAyzy9z/Yn/HnhoRnwoF76X3Xk21R/+4P4DVGrdKdge+N7eaXGjm3E4Ua1
         Lq7PbdmEsTzotN+3e+RNzW4h2L6NszuKV3Gfv71jNs8YvtkiM86BxS1N2MY8OwcXW3XY
         W5/AUoi/TZdnPD7CR5T0QpW6/zVNxpuLQOEA4PWYnszSj29XbNx9Y0Uo16JfalVL89dv
         I8mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=G7AXQfq4m6o2RX2w0JId8q5zNKOwsNSA7U5XE8gBSZw=;
        fh=YxaQX7GTjfBsN7A2Jl+A9yP6mmGOQanoqU6QROKhVaA=;
        b=XCvdA4UlcrS8Z5jGckYexHnIzwL0IeQdBkk2SzOuZWr2A9QSvTBrrE2xDI6CxK2li/
         Qjk/NbFwqfwyJ4CzQT/SWYxuIYkgQ1S9wB9BO0Mc88GkjsX4JmEK5l+dt/XBrWndXqoy
         R2985VLAS3jnZXsSqLL7nSv64P3jFmjGs0t2gLHgzzhx9Lq7LXaX6LRNoKiFIQw7CzPK
         Xkwv32Gh7Cpkn34tcJcRstoeOkpK+fR+1B4SrGwfQFWrH1Thlb6K/cvJCqsYW91va7X/
         wE0a5nvj8h1PenWvZ7xnVNd2490bM1cam4x0QMEMXZTQEKwUui91glX7pdFG1ik0RkYj
         USGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817482; x=1794422282; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=G7AXQfq4m6o2RX2w0JId8q5zNKOwsNSA7U5XE8gBSZw=;
        b=l+8b+qDCIFqvVjrjgMscNRamrvNkvmHFx8EaReXriRciv/ndHgoaOdWveURXqiZl5E
         Og3IFRZ21D27Mu8L8JQISbpiHaCfQKEVcvqjnxam5QtbdKtef7Sgn4PkZkAC1eI9oBIK
         1eXj7j/hj1WH5gDMMYDbfYOgYd1MuBrTwPGLMRVFzqSus71EOV5O1QQR+qaCZQGflZ/M
         lWc3V+08Lepk3JkWEp8LLkGWYXspW8eMh/K84GGpawvqj9OtYeioVjM1HteiV3HzYXmK
         rWxvcADr2LWJ1oax1xx8+MO0xTh/PXVQ+DS96+6IaDMwYfJH2R287uNY/Ej76gW6ej/1
         c9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817482; x=1794422282;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G7AXQfq4m6o2RX2w0JId8q5zNKOwsNSA7U5XE8gBSZw=;
        b=VfOE6cTOIBvH+HU3YE8D6Z8K1qrmsFisRTuP9ecnbRsp3MDHN4GVhaidlWmqNJN/uT
         ngQsQvJWpdgmamd3tcOihtEkfW3+en5implbOLSLAaY5pQ8SmrO6iwcZdpB+FggqW8Jr
         4iC/xYb9WKs5b3OVsXoPxkoCalJ4b7HaE1lzz+tbSWUo5dI/hSsZIV9DVgMGWkgzeEeW
         RPTIw6lm9DkFt/747BF81Jl0PgUII3051s3K4VC48Sk/zP41eWebX7w4a/XIc67F9OGd
         ryaW1htWyHq/xW9G6um7xnbpHu3DSnoZl/He1fB8bAZPTE68CSTRQ75mUNM6805ITfGI
         ieWg==
X-Gm-Message-State: APuU4Z8K3/uZMnf6u/zQ3hUWvqQ28M1eNMwieDPJXxxDXEw3yV70w8rG
	MTQtzx4rCcLuo/zNpShUtkMKUEB2OHn/ndCvPtePb+ozzdKLS8avS3/MHIRwYxfGoil1ICsdzr+
	pk2o9tV5RvnXxat1VYKGg3fiDzve5UE0zOrli
X-Gm-Gg: AYBFou2FHQV5Iz+chMJCjzLX+353dIXYmzgIE0je0xw56Lgsi63fy0ehVHxmigRWBSm
	aO6lKwtbIMRyPK7/vY+m+/CCJ3gqJPZOAMx3PS+CFvD5eo3mvV2lJdCnw/d76LfQbuy0HhCQl6Q
	qljhXztid7KG4m20HUuDRcnYkl9sJ3y9uHoekx9w/H4H62at439iBWUnAciGOoJmvQxI4JlPHLn
	vaaPT9ouy0Ttkdnyf0jyjoCUHQG5b+Wi5dSuklWK5eN40OhclwAEde64pexUuLE21zhSWMvMJzX
	BRS/W1j9hXVN6cpzhaq8yr96rIxgFV5WfxirpmCDIyY3FDpGlteubEB4KDLrCnR6xnNN3WsmbUR
	ED8waSTtZZ4EU+Bv4IInc050r2Ye+jt6jYBkL1cPddjwipWSXHSveaPrx3L492d87UaqM
X-Received: by 2002:a17:903:1b0e:b0:2e9:3dd0:c8d with SMTP id
 d9443c01a7336-2eb36493f7dmr174390165ad.14.1793817481800; Wed, 04 Nov 2026
 10:38:01 -0800 (PST)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:37:59 +0000
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 4 Nov 2026 18:37:59 +0000
From: 2-D Godoy <2dgodoy01227@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Wed, 4 Nov 2026 18:37:59 +0000
X-Gm-Features: AclHuK-1NEd_EjkQGbZlEjcVOS2Qz56KPrchd5JTUmxZzHfe3po4ocdXh7U1CDw
Message-ID: <CAL1HEBAeDp94ZNTzbviUSZna0jv4YDkYfxyAhw8TdYQx=tztcQ@mail.gmail.com>
Subject: [PATCH 2/3] tools/mm: use memmove() to drop the timestamp from a record
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 42EF120005
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: szpobatu65y1zke5g164pxuzpghsowxo
X-Rspam-User: 
X-HE-Tag: 1793817484-797671
X-HE-Meta: U2FsdGVkX1+pAxiOOgnvwc6XFBO+sKPVAdehoRb3UXaOmcnAIaOf8f7oNpygnF3kcwtPoXonjfLxtjT9/c9jy0MUs4ijlEjbEP2HmQZV5qqIrFtNS+CzByOW442/Wl4AVUuyuOC9Bxy7VGHv1VZp4zvt9wh4GUV2JGh93GSevwFJHwL4cIo0RV09O5X0aws0J2vWjVqD3Jl3HOMqNwcQGbBUkdhXCN45bgjOFcnb4bG2tm2FO0lZ5UEok77plBl6UMBjTSbp/k6GRy/7OggSi9QjJ0W+5XzcTPi6r399khOafBYEf4P5kaICAJpFXw0qwIt0B/scq6FxHQuTofGzTF05pfDv4+RoO/6ky442+a93cz7Dob8iE3cz/12axaQ+gdfYQ1RLPf/j816AUOB1Cc9UtV+pd5hXLFC1dZz0JtOq/TVfIfb+nQAEXyTOPCAhYC87omj5fEroYIOjMuakpyd9nO54DrxOilzyewvRjFBTUHXmJnS7kGPyz6ZYdAGOPXtAOu1T8SWVXJkMhOSPqLl81tU+m1CG7cPNEqHKhZup83rqWYSr7UoVu5BOY2TRTCwZ+qwTrv/QD90Lt+yJhwiUmtISqy4lRWke4IDhTNlINbSBKMzh77TGEl23mRAIMPqCqDTQ34NqWyn7UVcnOaqyNwHE78T1iHtOkItVM7RDtfE6sCuEVUUCL83o1W5Sj15oPQc2jHAFQBwrGt5e3/wDGSsTAI3sQrkLV8hzKueOKMWGjgJ7+YHCC4z86GSHFFVcCePJay/TK/eBPHgavNIOm7dajRUQQ+prDMI8j2vGha7GEkpbVvULPPARWPgFdZwBkGvDu3YGWS0TteP2nH2E6lJmUs3rJcRysyqSjJQDABD+wE6nR0hvxXIJuy9o6YBMfr7eXWYWyYL/0zxTxBcI33zXpRt7VjPaIK95YgbhchnDcLTc3Y/ffWmnXxr4WARUZfJPyD7EpGEg5Qt
 f+OzXj4O
 gfAYWM75auZLLefptWEDHY8O+se9h+QjHt6ZjGxNymHS4K83TwFFpAjOLazltC0sPOQ8puCv44i8aBaS/y5T2AluDkoEIUfXfgncKDODWEvQL6MYvglCuUgEJhlaW5+VfKwVo4sOSe/XKQgW8ksxXCOpHFy7lsOv1KCsMLyiMRfS+tH5ceNw7/8tLaGpGnDVscykWNRWzSy88x3g6cBA+mkHbu0Knx6iZ6iyTRuDMwBS2qFZBjKbWifYX3k1LyStwmq4mO9463luyGfn52PcSuNL4jqJYt5X8DGkfcm1Rr6mKNxnTF6eLXHz0sOg5YLNbm/1OohXBmT1B2U4lfNn4I3sp7cGYxPeXxjci6F7Otqad9hYN6E1SkcWTCLR6Wja87WhnAkj4AYUaPsHY/HV5/T4/rdVZ3ECUMJfuceWHBu60Zdx2G1sT2uW6hofEp6xrkyyk91wIvmOMm4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

remove_pattern() moves what follows the match over the match itself.  The
source and the destination are inside the same buffer and overlap, which
is undefined behaviour for memcpy().  AddressSanitizer flags it on every
record that carries a timestamp:

  ERROR: AddressSanitizer: memcpy-param-overlap: memory ranges
  [0x60f000000262,0x60f0000002be) and [0x60f000000265,0x60f0000002c1)
  overlap
      #0 __interceptor_memcpy
      #1 remove_pattern tools/mm/page_owner_sort.c:252

Use memmove(), which is defined for overlapping ranges.

Signed-off-by: Henrique Godoy <henrique.godoy@cloudwalk.io>
---
 tools/mm/page_owner_sort.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 58d4a54..e56375f 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -249,7 +249,8 @@ static int remove_pattern(regex_t *pattern, char
*buf, int len)
 	if (err != 0 || pmatch[1].rm_so == -1)
 		return len;

-	memcpy(buf + pmatch[1].rm_so,
+	/* source and destination overlap, so memmove() is required */
+	memmove(buf + pmatch[1].rm_so,
 		buf + pmatch[1].rm_eo, len - pmatch[1].rm_eo);

 	return len - (pmatch[1].rm_eo - pmatch[1].rm_so);
-- 
2.39.5

