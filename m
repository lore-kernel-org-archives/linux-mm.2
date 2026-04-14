Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32ED3ED7BBC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9C06B008A; Tue, 14 Apr 2026 06:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A446B0092; Tue, 14 Apr 2026 06:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FDE6B0093; Tue, 14 Apr 2026 06:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4C96B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:42:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA2D4E3990
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:42:48 +0000 (UTC)
X-FDA: 84656823216.27.4248C75
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E19740004
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:42:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bPE0beNw;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776163367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frM77usxFPT3vq9Copj1FbXjZMzdBEqufSu5zj/MX+g=;
	b=Gyr55R+w/gurqZUbk5L2MqmOjL5pJBWbszH0ObCkUaHh8huvbTImCyidHK8uwjp971lLrp
	xmIqSP42N9TFA89kLf1RqVC7ctE8B6eSItr2QvtSwi1sRplcbjUt2atzkupdoWMok0sVns
	0e3itqnwThIxTUhOZ0wV8Sjn40h4oz4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bPE0beNw;
	spf=pass (imf12.hostedemail.com: domain of charsyam@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=charsyam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776163367; a=rsa-sha256;
	cv=none;
	b=dr2WYKowprYi6kUL6AswCGnarrJBMtb3eAUKBMkOVF7M8Be83Rh0rNeFsSHnRz0+lH/oGA
	AJSAv/ny+ekQJ9F7XNoBy/bJRE0/DqVtWjR++zqk6iLGm+yR8AciYWQRy1ws9RvZUQI8M1
	77xPwS5KrUmbbHIgIZ7/DHKNPBsffa4=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-35fb262f92cso311619a91.2
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776163366; x=1776768166; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frM77usxFPT3vq9Copj1FbXjZMzdBEqufSu5zj/MX+g=;
        b=bPE0beNwJQGEsD5iB3upxso3GJodKwfjLVOOGRDmV88WSirxgIIRTWZnv5ZdPhx8NS
         m4QlJJ9QxLbMYrO8NKKXQ8IUjOdY//VgsNTtFVGoDz5L4frCTaSkyED/29y+ZpbYWNGH
         L6jOXy0FFEhq351THKSm3Hp8+BlbcaKARQGJ3S6bweFCV+zP8f8WmlY6qNxmzUtTXzkc
         noAiIRv/14XUxFsYx6+YIpNY5KzFsCusfaSdcgIQCIRy+U8ndinJL1zOcMe1LSVElyy7
         N4NuAxw4dEOPIm+b6lRC+R2lPIdQbOPcwG6aFmCsorAZflqL1UlMWhoUd+g13Of2TBt6
         EYAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776163366; x=1776768166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=frM77usxFPT3vq9Copj1FbXjZMzdBEqufSu5zj/MX+g=;
        b=hYi1mCXyAyezazrlyoDcBVk4GrgMXBZvvWeQAEzE1PktcuZcbMIMrRjCwc7vy6xaw+
         Uo9is/sBHg7aiLmhGQY3QFtDHpQS+Anv1maq6rdhwRe+n3JLIDchW3jf+EiWiwvygZjB
         IugPxhCgSFo4YwvODyJzSGOdC4exvz6PDJDPAebOl0Lm/6kGQkZxCPBAWDhzqKozb4cd
         z4lM4kOZfpwdUE0h0T6EA7bTptrhSdzATatRhx3FN8nqlH6p9nVxiM4XYFsApqgSzno3
         MPgame/EiiDwMQYANCXqmDOQkfA52xoER9ocQCwAZAKKF7T/0KlvtRJYrpdnVh/X2DJX
         Xx1Q==
X-Forwarded-Encrypted: i=1; AFNElJ89xTBZP8DPjafceXvjaXMZ8lVMEgWrqRQdi1AktNph2FS6aIdP4279vmaLq2cDARkquGdQSV+Aaw==@kvack.org
X-Gm-Message-State: AOJu0YyYnBr93VHB3bY0kXN/BEhtWl2LDdou8yZa1NdKSjFi8Y3/7oBE
	3akjUejRvRkMeSRArbEwNxjPDkw9k7o+ODk0bHfGZJZpAFmPk7tqjgKC
X-Gm-Gg: AeBDievgkv0qLcU/peqlOtQ7d7vv4NaAHVHy0d8JOslE2BoQd4+6Jjx+C4HgdpTX2T4
	a9JQ01Jes3LRYB4Q2YwjpJIU+LH3KIrHLbOMkne/Hxrlp6ZfE0W/cqd79+b++PQrIO9G38fPvRZ
	Tf6q1/9QLuMAfJK4VZ+rbKwFqAF9dXE+mnL5MSHWROQ+GJSb96MzDyJthTu0xUYjBNj2qo6Q6bt
	4xi6GdIoLmBhVOhIEzO7o0m/9uX5hSiSUj9gjb+wL7q8GXkHFoOH03OrRYz/5i80uIkOS9S03rF
	ZyMgAvqkrjpgNEgWsAvYO7Vr0cjyYbhlwVC92/5DYlSS2KcMyV7ERmk4/FBqQdi1c5S9L3QmMxk
	eXITAfp2HqMenik7PVOtJe77IVXXy0TileH+YnIUuaSPwsKb1kC9Alp7600UdukGcWlCFGGVbeL
	xBTnPJWFrw8RkPqo3G
X-Received: by 2002:a17:90b:3f45:b0:359:fe72:3555 with SMTP id 98e67ed59e1d1-35e427a9adcmr9590032a91.2.1776163365783;
        Tue, 14 Apr 2026 03:42:45 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7921a12adasm12179185a12.26.2026.04.14.03.42.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 03:42:45 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Donet Tom <donettom@linux.ibm.com>,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v2] mm/memblock: fix off-by-one page leak in reserve_mem_release_by_name()
Date: Tue, 14 Apr 2026 19:42:36 +0900
Message-ID: <20260414104236.988942-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <V1-MESSAGE-ID>
References: <V1-MESSAGE-ID>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0E19740004
X-Stat-Signature: in81nyrfocxokwrxnudfdom57nycpx6d
X-Rspam-User: 
X-HE-Tag: 1776163366-591963
X-HE-Meta: U2FsdGVkX1/S5wh1QCneLgWa5empEFnCP9oZbJXLivYn8Ipb5Dtx7MNXJkInrWEBCHF3ofuz1n0UaaEckHL92AXhCR9AtZmBxP2s5vEDM9Z060PBWpvF4tfpONTVJnhD0tMPezc8vB8gbKKCzhR2+87wOT7RqaV4QjaIIMzXsmZ83ZRtG0+lYtylb5j1tMvUkwQb0CqHNtWkLA5dYYxMWwOBNViI4Yy2Cj6PCJlwuyGsGVkXQermqvm1Mwnr+o9AC4/x13YAyYKtx96krsuaPdGwoQki1cS4nhrfeNvftD7Av04WaeCBLvO+mfgIz7D97sH0CErCZpWtjVL4UgtwDLezIn96/31a26+P6fNwZOEYJLVHvDDnXI1HTpUoAe4TNQiiNM4aGYrT30qdGLWWNLfQ8CmqG1ktOxbIxqKTa5TpiP7q9FGOzt1YIVtH1u4hTmYPyUWil8//pmmuRMtkjnVoL9IAYYC843IrL9P6FO8QqWakYtqj5WI+GfoCTHoSvSulRf+PhQ574XuNMtVaseC3Q+PeHXWUp8j3gwQBYxI8/LNuyGifbH6fn51bFOBSeRA8H5P7QO9L9UH6eAZntU9JdjFlQzGSU8uc4Zl5FhpkAFaauhjkJlnIv0jul3QowUjo0dWXBiFZyxxTjGPNvxyjSfNdZZ+6xXy6VH2TIvOkV/0HGWYRyjXtyMLkMhjI9UhKeE1voTFfi//uiBoO6A3qtijxWV+fh7eR++vY1ToRXbo70zKj81zBrIykml5nF0SP76IZTqYbQTYEiPLsWXQuscKgYYWc3cpUAKQbrqLtDmVqenHyu8n4TKgLq2Wgtv6fvHNO59m9ihXyRZ2RQUT8zOhJV6WRdHToip8xYDt/TiGhMShcCRb5HsmP7tXBooavEENhDx2uWGMfEkKn7zmtRcanCjlhEVHO6r3/48ZpM49gFZWrMSiZdEB9a03GRn3Z9errg/jl4cA0Br+
 fGbC64kF
 WXDMLJvueYpl7gRRP3byVbW/kZl+QAXqaOpJzqqRtutd9DJXRlBmOHLzqQJOqeg83KZK8pSeyN7scmPolOubaRQpBiYbV2ioZZAXZlRALzSO4ihrjCJWcYrx6vwq0MQlIQBVDfa5FS0rnhbSWPEy4fubCss2LShfhQWKjNRkU4TdI53UEiqOLqd2EChmZIMdV8151NoXDfRW8hw5TQ0Dcz6jkQcBgpP4rRnDIgxbb1Rce2O2ZW4pMbk2Rg50Uk60zBTHG4736iIGfEig33Y8DM5MeQgELMehsj0pnk1jA0ggPnHq72a/ui5ORJWGOI6UpuB9dCUiTk2c3+MEmR03GIePHnRmHE6UrLkIDUHVwp2bnGWN6xdBKNpZI6Aad8smXXiR1ZfY3QPxOTAZOCP4Vw8amgyGtahHDKR/MlbB4eM64GvChDDRNv2FF1u7PlMXN1P/0Tpj/l/OKZqLoWQlJcAj0+bVw70kTlLwhZqsc1lCBohk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_reserved_area() treats its 'end' argument as exclusive: it aligns
end down via 'end & PAGE_MASK' and iterates with 'pos < end'.

reserve_mem_release_by_name() instead passes 'start + map->size - 1',
which causes the last page of a page-aligned reservation to never be
freed. For a reservation spanning N pages, only N - 1 pages are
released back to the allocator.

Fix it by passing the exclusive end address, 'start + map->size'.

Fixes: 74e2498ccf7b ("mm/memblock: Add reserved memory release function")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
Changes in v2:
 - Add Fixes: tag and Cc: stable (per Donet Tom's review).
 - v1: https://lore.kernel.org/lkml/

 mm/memblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..d4a02f1750e9 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2434,7 +2434,7 @@ int reserve_mem_release_by_name(const char *name)
 		return 0;
 
 	start = phys_to_virt(map->start);
-	end = start + map->size - 1;
+	end = start + map->size;
 	snprintf(buf, sizeof(buf), "reserve_mem:%s", name);
 	free_reserved_area(start, end, 0, buf);
 	map->size = 0;
-- 
2.43.0


