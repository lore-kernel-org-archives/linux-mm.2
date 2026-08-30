Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A27C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3E96B008C; Sun, 30 Aug 2026 03:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573E96B0092; Sun, 30 Aug 2026 03:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 489AC6B0095; Sun, 30 Aug 2026 03:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 280106B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:03:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FE8E80260
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:03:29 +0000 (UTC)
X-FDA: 85157044938.16.6F4E9DC
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id B2E40A0009
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:03:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jDuGBySP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788073407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jT2rrXLHMnHsZ11anjGvX6a28pL9SpHa48zbteBY+kg=;
	b=00a4RwdCFgqOC4091/A7lWgU03pjXzaeAfQBZiiuZBLYzkPrzSSDu73FalGpB6xCTyAABU
	vtFnZvfob0LT3PENpts6hUCVNyM5S3cTobp3V+ECf3SaWZ967mXu1Uc1qZNAp79eVKH9Ti
	S50JKybd1gL+jCy4w/0F6/0cwP23EC4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jDuGBySP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788073407;
	b=rEbb3BDKLsjqXOM2cVn7IL0T+cC1WqZGf+km7GJu7LGjTcz33n4y5o0OjqlEHRtK2vt7D+
	Ecn8SvSdKxfiyIhBQ/DFNkldceb0n3pC9p7UcuxMVot5EiWtC1ejn+2Yy0ehS6g5qfed2y
	NkkVPlKYGIFI/Dy2bV8SVw8qPcN67vM=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-39682983a0fso2974212a91.3
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788073406; x=1788678206; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jT2rrXLHMnHsZ11anjGvX6a28pL9SpHa48zbteBY+kg=;
        b=jDuGBySPEJxJ0PzKAaDsTcBoEPGnoo9hOOrBdpSiO0gn4/Ye8b2Y1MYk6aJd83GCd8
         NbevKA4kQiqKaXIAXGnimVwFBSMGJYYU2hTyyv3B1qiNJwxj8oEwMQ8sb34CvU+hNWWF
         wJjMQvarbtixvVDwzfqAZN/j+VW4jPaSwjT8x2LrHWyp09WJ0XVBX4V6RLJFyj9Cmxsg
         adc1FTGP4SqMpE0Mi8BldoQr/S0kE2SNigmxKFMC7mzeVEORS/t0Rg8ic1/wQbe458U1
         NbAuwkP3LRxNfcUAwnRB2KJau0ZtF4TKAjNwsnMP0R7TUN1NwPCa6JfpcvzY5v9sa8hs
         XOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788073406; x=1788678206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jT2rrXLHMnHsZ11anjGvX6a28pL9SpHa48zbteBY+kg=;
        b=jxV/0RT/RLniFDkRwmfnOmb/6toNBVqklAdX+AXJrP+UbTp+Jy0A7JyTqG+8swR61n
         JDdkOsVEI5QHFd/dcDPIqFhQOZGDfBXTTwqkVbq8HkBpzjuKYtPW+XCGAYZn+rDjwT9Y
         2pGTtl7CcvYuMTrcrI/Ffv7LVxpqsbGmY6GzilPrZnjzQ85odMlfUiUTZy2pUxO474uY
         e1jUtdhKo7QfpZVi/jBuXG7dXA9+m1N4c5GrmKeuQ+MIl/jtNUcw1JGW1gTzRxCMZD7D
         /PdW9FV/XID2+Kz6AGVanC0C5XrNTRTByemSISXqOzU5u/+zRunpPuyXfW/rDAvZY+zU
         +Wzg==
X-Forwarded-Encrypted: i=1; AKwUvByG2iwfndCxM6xW9lDCgtIIwsfTk+m/TZo/73voD8vLyKd+OBHBOGEKnYk/d229HZMP+5pZI0V7yw==@kvack.org
X-Gm-Message-State: AFuF++lLUFC0M5jlkWvDhs6DcXXM8w5NtOmRbX4cUYeIJU2G+eC1zhrE
	JrIrhstdo5340GH+GPML5vvnNSoq1Q7jTDIAeabg1Tjwum/CQjQ0eAwy
X-Gm-Gg: AYBFou3l8O9RMnmI3YlxtHv045aw2j0pwXDgjti+yXIVBfrr/Vh56YjVx1esokoqsVi
	mmyYhQIfxH+1j+Kf2VIAOe/mLwf2Jt+tJko/DQ8Sgr83M3jWIw5hZATJtqpxnVZrKAhb5Lqcogb
	9Ca6sQjlCSSJzVan56seLH9Cfuql1FpOxVXvT1Odw/OheIPjs1EFkPhVpzrj2QCTn++FgASdzC2
	yB83WgxnwILYdGc02LxMw5cm8mOc1T/mVesbueUQGAFHwYmOQfOAA2YfRerBc7x7ogmcYvYCfm9
	d4jKztgS6TtfO7FRame5t+LqoAaVGX4DnD5eNUUT3UjZ82g9OHEbDsUa+pGSjGhkpIQJqKiJX1/
	1Xa68P9qO4k3+kouiJRIc1Fk2UKm790cua7RcypOxrDdJL2SK+ObfItDza3UwrhC7Tz4fdDmKde
	Zrb5Ml0Ba+FpRK4bHiiG3WQhR6SmXkDDKW9CiJG+yUFGvbqEvf07i2rnLYMPx4fV1+WdPWbtVEH
	0VjhPdmC1Clc2xlAfYqmuKY3P6M
X-Received: by 2002:a17:90b:4a52:b0:393:288:29e3 with SMTP id 98e67ed59e1d1-396d0eda189mr27367690a91.10.1788073406451;
        Sun, 30 Aug 2026 00:03:26 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398a14d3e83sm7469034a91.10.2026.08.30.00.03.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 30 Aug 2026 00:03:26 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 3/7] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
Date: Sun, 30 Aug 2026 15:02:49 +0800
Message-ID: <20260830070305.77990-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260827234704.63163-4-baohua@kernel.org>
References: <20260827234704.63163-1-baohua@kernel.org> <20260827234704.63163-4-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B2E40A0009
X-Stat-Signature: qmyji31r6zocjc7o484nfkzb37cm4f4k
X-Rspam-User: 
X-HE-Tag: 1788073407-128549
X-HE-Meta: U2FsdGVkX1/nDnzUszzsjWsySAfRe8bEOAurbvkGxZP5q7W+US7Jj9hvtXyihASrLb96+namJZzUvlCoM+nYguYSKQ+r67sqbujWaNeeZmHF5nmBakJL6Ag2EntwX66PitxRsWvlZQzIbDGlLQx4fTdbcR8bxVC2brVo+/nL1Ms1qf1Wl4grcbEgCGthaxTZ8X0N++8Up4nRce4mnAovwk2twACMRA71wPA8ppifWLL02fJPq3wpg44NZa/131bCitTTpBYAlqEIB4XMs4zD9TzErDEuSliSA67sVLh5vk1sYW5+JjKj3CnmML7OHMkbVgp0+jxtCZBIGNeP6cdkRwOvIouPB1C9Th1tsjm+uguogxggkkjf+Mi/catYywg49OnFI/lluhrrSbXttjFXdJIuL7bnCjuvT5PtLVM6BDY3CKZoPauAjONfA+/8EtOqu99Aax+/wwYFzbkbF7ixaKKVd3ffdkgIK53etj9jaiA3fOQ/7mm75JH4iu/sTuGXP67dxxcGuwb1fkEnlqyopCX4AJ+IoBEc8M7SiamxEmNVLElkRmlB5CxW5I+JmlScqmIT7LGLvIltFsn8fPD3SAOAU7gN8Jexxqzd0gm5gAX5nHTD/6s/7ihhAZkoIiIFUAx948nDc1gkQt+hbt+eDQafK3/rTS7g/YqTgnU65nq8rU5un10wSfckA6MfYK4cWIpfIIFwzwUYxrj1BETGZbQ5xXP8xr7e8eyqmJi0MHcJf19vLVpY6MLREwPFXwe1c9zlpwBjcGZJJkuwi4OaUKHDJM9lKh2t7Is4/dC82QRpspCjwupQDbk0Iw25Vy1o2Tm7V/Qj9QS+lShV3iHCzhu/vpyj8h7rCbh/rCF5b608qllgkoyxNhQHB0kMa3DHWty1ykms/PXB0YqHKgapgS9mv30c8DvMgiYU3AyDuUCCcavZ1c82PT+L+OHzKvIH/bsyv6DTeuRxvZcKp74
 2D3+b/Jg
 SnuOEyfW2wwtyEPPHbcWhmiU6on74U+sRqWQkOiVMWfbjqu6StJqRNH2gxHOkxQo4ukwu8YRw8IMNfwDQ1JmXcpRbF+WKH+fHOhuVJEuEO0cVElTRqA0LW68uBScefwJb8r83Z3M7jMBvB8W0lg8BInL0YV6mQe/L9flHfZNPQDH708VhjLnHdCd7jT+NqzXjlrb9tzKkg8mKrah9yBE/NvUBz8+dsOXXIYGtGQ0TEPl8ECqvYBfLiqTezHvwkVGKtAXhYkhaatJMWCJik7yWJqkY7u32+YAro55U9K/G9UjOx0cgkm9/Q00S/F7bEq9DRr6Cw25AJ+oCzeiKpz8bkAnjqnSD6dZBPYaIgwNxeRkDRJD2yowbynOi36eLR+sTSY12S9FrqypPp91BJcWO3S3BXFHTJiqUzOFx94UTB+LaVxj/7mESA8CAQxnGWZ0ZjPpcqjwHkl/Ozecu0VJ4QGbf05CiINok4C8VceMBqukyl/CT1rnCY1yK+UTOk5gE+TDyCN5Zig8mQVW1X4ZMXXmuWtQU1tcs98vHEEt5dVsaFjBfVoYozXP2PS8j7gMHuc/MTHKJYlsoDv9ddUy9BwsBBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Otherwise, promoted folios could end up behind folios that were never
> promoted, effectively inverting their hot/cold ordering.

This makes sense to me.

Reviewed-by: Lian Wang <lianux.mm@gmail.com>

