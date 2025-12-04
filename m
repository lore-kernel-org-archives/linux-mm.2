Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FF6D1CDB8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 01:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC28D6B000E; Wed,  3 Dec 2025 20:55:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E731B6B0010; Wed,  3 Dec 2025 20:55:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88CB6B0011; Wed,  3 Dec 2025 20:55:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C694F6B000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 20:55:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7F965B7F4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:55:09 +0000 (UTC)
X-FDA: 84180120738.02.8621919
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id E2475160015
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:55:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PRMoANHF;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764813307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b9ZKBsX1w6UPefrLQ6j6TJQtLjEj4G2aPJhHSG5VU5E=;
	b=rjYMb3UaNvOFnabPg0PHI/Qx1+TH/8hoJUdRmsOp/9YkNV5jwWhqJmLEZ5qVZkJXEF+76r
	entVJVFD5GYE/1cOA6A4zxVf37scMzL/9aXAstH81uGOvWn4wdwTgQDUfr5yi9rWrbcJJS
	MiRX/wP6Y/DGDRSW02xK0vf+nJ11EQI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PRMoANHF;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764813308; a=rsa-sha256;
	cv=none;
	b=fRnG6V2aKXoILAUYohT/YzPzfFnqIOHjufG5I6IuBQxVEWP2aAO6VkFkGLBBOMM7OvfQAk
	fCpPy0SFHvC7aUsiIdROZEC7hwcExq/f/ttvvHNC7pvpCjY9rktub0TgZSvVUsgRbBelQR
	bt+OZMb5bc/n3w/R8ymnqHQMRmT0QTI=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2984dfae043so4301305ad.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 17:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764813307; x=1765418107; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9ZKBsX1w6UPefrLQ6j6TJQtLjEj4G2aPJhHSG5VU5E=;
        b=PRMoANHFPuN006gtl8Td89AvPBjUbnJq8AK3DJt6xeTLX+uN1gx+LXerc9hUV/hJtI
         FbmSkQALsmnrNFkyH9/XPEZAxzqd74JHcj/LZ6REBhNCCPzg7BkTMKIspJjr3Fd1xX+Q
         F0zFRpvOHklc9McVMOoAEMjzGtsIu/g8vAZFnQVBROgmblMqYpPkWHqiZWPBV4s30q/6
         9bXCi57IpkvmnfzGEGLoUkZBYqo4vqr1KDSZTzw21WoLux3YAnyR1py8oWWddXpVfB1L
         aTbGqIa8n/q73SxFRBEb5spo8yWFwsWQkB1vAzBvYt7wg6hZi5BkIeLRvFLB9TjfuHrL
         uexQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764813307; x=1765418107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b9ZKBsX1w6UPefrLQ6j6TJQtLjEj4G2aPJhHSG5VU5E=;
        b=GqNiyT635XgzD6+Ax/Jhg4W9nldH89hsv9Hmhr/nY0O9A9nkLKGFrGJmyjKnCnWwY+
         noKEw2izyCsrPnBf4w8lFWsXtHbws3BC9QvWBgYtj8ZxQpldQG7U3CkuCELl2ASTenQ3
         FFzOYJkLrCnL4/j+nso6mhJai1qkndRyjbpg1q3nmN4cvLr8dGsizAC8ROsLE9elpMga
         l7ingjxKCRj2/tkxU46lN37pFYwBYIXvOcoBeZPByyizWz9sZ68mJgA1FWm7HX292VQ3
         ot80jxo6EtBZ/Pf3JEh28cvfwJkLloHTpJLxj0GBrbFcIXUTIdqpXNzIUzgwRu1pyh8I
         v+/w==
X-Forwarded-Encrypted: i=1; AJvYcCXHwpoWgDdotQKdG1RXixcGndEb0vq43wVT6LfPwTncS0G5cxU0/jTrazMC57uw30Ib02r0RXpmSw==@kvack.org
X-Gm-Message-State: AOJu0YwETtELHwW8ta6RkzFYlGcsPxD3yCu4DWW0j0e8bTGd0EHOsMDf
	GcLaov63YtQmVGtlE0XY4trh/65wQY4hUzJs2YCdyUW5R459Os4LGS7n
X-Gm-Gg: ASbGnctBo5FX6xukMu4B1vqE2BX2dZqa3sKnCLASYgiAW1y5KWxfhE+1YWoS3as08HL
	m+yKaAv+YJfF+/jr/UkEla29UGbET4UuKfXvomD1BeLaZMoLCCJcgJVWLpcO9BwZU1GFvYTOleF
	fuA+dDkhOqtvy8T5L2RzTma89PLIPu40Bea2HEAQvFUny68pma1znlx7xyfuw8zZB7temiIhS42
	z45ZItHYHtPvBT8HkiwHzgGzOTxQjm0C/wUcnVGjMLj9aL+OMyqsYfv0aLV/cvQpPuoA0lzqjrP
	Rf0MRDjeHF5nM6hLo82rYH8SDrU2q20EGd7XEmoGI+a+XBD+71manjUOlN+2etkfjxDPXNV9C5O
	ipLWfy/E1lZL5bjaUoLCr8xbXkJJBrdpBBSpCYyjpJB/j7VfikFSULOkle4p39EUKYoSIwi0D9r
	9Neo9FvoTRoxjdI/k9QXkO9DjemD/2P9Hcw7cpJJEAYyMtFF5Fvg==
X-Google-Smtp-Source: AGHT+IGq8c9oD3u5GYh05SjANvXBHmmeyohU8q+LRCLY9miurA1rAfYoEUrgRkiIG9sgighxtVHcGQ==
X-Received: by 2002:a17:903:b07:b0:295:9b39:4533 with SMTP id d9443c01a7336-29d6839870dmr54019345ad.30.1764813306619;
        Wed, 03 Dec 2025 17:55:06 -0800 (PST)
Received: from localhost.localdomain ([2409:8900:1be3:8f38:b904:5201:d897:3883])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34930b5a195sm915502a91.3.2025.12.03.17.54.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 03 Dec 2025 17:55:06 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: shivankg@amd.com
Cc: Branden.Moore@amd.com,
	Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	mhiramat@kernel.org,
	npache@redhat.com,
	rostedt@goodmis.org,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH V3 1/2] mm/khugepaged: map dirty/writeback pages failures to EAGAIN
Date: Thu,  4 Dec 2025 09:54:25 +0800
Message-ID: <20251204015425.66988-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251201185604.210634-8-shivankg@amd.com>
References: <20251201185604.210634-8-shivankg@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2475160015
X-Stat-Signature: d8uugwythawdinj3x54x5tena8jxq1ci
X-Rspam-User: 
X-HE-Tag: 1764813307-25532
X-HE-Meta: U2FsdGVkX1+PqTXecxatN5TpLAen49mUIbR9pkqG2WuJuERRrlj/4V11RRDEN8xqo27PAPCaIIAz96LA1h6KCoFz7G2z9BCuBubNHbPDHADy3jd0a6mEuB9yFto6aAZINvgMpEQlcqgAqMoAJagaPlA4ilJY56PeZB0HprOQG5P325AChG8nayuytcrzULmQ8b7obp3+AufjlTkY+SVvfTB0TKMB89yssWXS2SyUBEvywct3kcmIJ7ptLtU7B+HPl7hW/dWUO3UBuChnCDOChgVQm0RxJhh+hXESF3YZLOIQ7W++eYV854jXiPbuiA68D4bYJ1KOGRlGv2kWFXlo7B2kcRI99m4sRBOcHFLxYVGV3cCqo3Y7/tOHnoPpwdiMMGasl9YTjPSKqinRh1rfl6U/YjCTivR1tQuBoQjZ+5KT60Q50hLp2x719aB71OVcScRPE1rJ6dRsYIUuwwmTWx/bGBzERl3ON3E+yJgFpH4BrhVOEnj7s4atYy5kHxIcG6EbUoLsKjwwb1SM1RBfpYJbffpFZJN001wNnJD9bmx0A8593ahfAHn7LF5Yt2ZqXcMjz6qIwSIcUwG1HkfPs+0724XnJoj62+dA+TErs97+wnim3V6HVZAS6B/4XYROfC+z/Lf5vFcspt6UBjLPNQHD+ariWYr/MDOBzb/nw9jMQKyAmIDX15JHiqCDcEstsyjgiOiomlO6wYO7Co+Ep1+UYb+h7dTNDK+gf8+7h0B5vWi2p24SB92GEiMD2n6fgh2Uc6OjLAtenNY8QE46Kap6SFbMYqBkawwUsQBpqAiMZandPJqRpld+Nsaw+Eu2aKpTiUUQM+A/j52oy2VzrbwabQnNQ93J0UudPWhNR1PG6IbF7UdXSrH9TtU+cH+UX2E8/3Dv6+hRGPi5p6cYoiHPPAFUItPhzpcuZua5ibf7bWIOKtvO/1DYKQEYhcMIPkqv/mpqCiSoFLWCJQI
 sWK3N/vs
 3/+5m6OkOdhDjDETjJseMm8qkKwckSkg/yla0d2Z52oT/asu+gCSIhCqJH8oBy/sKBrydCZXnrei35ErZybBNNJ/LZ1GvEXRM/Qi/umD8M8xdiZo4odMQehP35m4nMxcLiRdwpjqOomc3Tsj6vN9pGhnCaAD8V6pJdpcYI9way6T3QtvZJMXYlqN6eeNR2m1A/0PqzUD+BoQNzNoxGnvIUsexErV32qMnVrA3yRwUnjBvca4DrMis2ah4pmfmPnSxKI+fBfK952yCIVh/zbiDccxrs6ypz6K41XyJoij4aeW9qS+HyW9l9yUdv3eMzNbwOYnsYlGEC/eFp7O13pQtn6im4Y7r5WQuRtvywTsO1g3tJB+miTsBvQ+T7uGRveTpxLW2DsoxmsVDGYxEF0/Ur/58p65OT5sbK0t/pNB+pt8Ke/odacatE8FItEkQlsBh2YWUQJi+R5NrCcIDLZlx4CGvuzqM9nAuRc4iLwPeDQJUA9J0ohBSKDakcaB+dt9k83Tb4Ha6bwT8dbV5R/kZRW4TvF1XD24NwJwd0Js24TdNlo0w5dZGHf6i7MO6myLmzLKOZUZpd542hhPBmfgzsB1S1UE9uVfwouRRS3jm9zIO17BG8VBBYJpNUUWjxFx+ddea
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> When collapse_file encounters dirty or writeback pages in file-backed
> mappings, it currently returns SCAN_FAIL which maps to -EINVAL. This is
> misleading as EINVAL suggests invalid arguments, whereas dirty/writeback
> pages represent transient conditions that may resolve on retry.
> 
> Introduce SCAN_PAGE_DIRTY_OR_WRITEBACK to cover both dirty and writeback
> states, mapping it to -EAGAIN. For MADV_COLLAPSE, this provides userspace
> with a clear signal that retry may succeed after writeback completes.
> For khugepaged, this is harmless as it will naturally revisit the range
> during periodic scans after async writeback completes.
> 
> Reported-by: Branden Moore <Branden.Moore@amd.com>
> Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
> Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

LGTM.
Reviewed-by: wang lian <lianux.mm@gmail.com>
--
Best Regards,
wang lian

