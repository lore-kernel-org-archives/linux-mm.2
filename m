Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925FACA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 01:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214436B02F5; Fri, 15 Aug 2025 21:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C50E6B02F6; Fri, 15 Aug 2025 21:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB7D6B02F7; Fri, 15 Aug 2025 21:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB7A16B02F5
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:52:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59F701DA766
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:52:55 +0000 (UTC)
X-FDA: 83780947110.08.20FC5E5
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F77340008
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:52:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gIloYCSR;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755309173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NLKG6jNvVUsekFiiFHIYl022cHqokzDGITdYQJ2LTYk=;
	b=k9EMmgzK0t+0j5QOCEwz555RibowWT61SGG/7Q9s1BNWqBPeBbUGyRc0fu5uaIooZAHcur
	E47v7prPpyfylYdCClkG0fl5Yk+tf2qpAYAkxMIQT72P/+Xd0ID4Ose2UNEdDPECk3YAPb
	iLaM10cz7lLZZGU6D2rUlEZRKwB4/D4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gIloYCSR;
	spf=pass (imf07.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755309173; a=rsa-sha256;
	cv=none;
	b=ExHGm/UKxqFN7fO6xnKWm46cXco4aRRsP/O0UF6kZVY5yGfQ+0Eon5piR8imWFlLgT8KLB
	oEBxisHcKgGkkCI7CBLxAqEu/w8G/mWuQWcmJgtbT5IynbTImtiF8H42XsUc6w3s0ViGvG
	Qr7O7H3DaqbF9+zCrDTinPyFuYNzwas=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e39ec6e05so1380259b3a.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755309172; x=1755913972; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NLKG6jNvVUsekFiiFHIYl022cHqokzDGITdYQJ2LTYk=;
        b=gIloYCSRzhelHvPf3BWPAl2sux8xBfs5CLjILzT1LcZcHKt8+HjNBdisEpqSVClFqe
         xhCAJqupq1tvDmNVFLn4hlgG53+WhuGwVl1DGvI2NlXJ4T6LJ6MQwDWcHJG3Szzahpbl
         2HzYv1byjVmwKGSC13uV8xaQ4Vbniq8YHQ/c8qKgHyk4MSVUaC0T0rfb4agCxes2yTUo
         ME441h+3lwIkjh5oAIK7ilFIh+h+uIRw2P7UC9JYhoQb+/pv1DikSWnU9m00h8KzKZrB
         OC2EauXQ1WXpnfRBz5gFTRjD7m9VZgEg0wXkESAq+hfNQBA6xBYJASIEyYp6B6msA5RD
         WLww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755309172; x=1755913972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NLKG6jNvVUsekFiiFHIYl022cHqokzDGITdYQJ2LTYk=;
        b=MKWt/CV2DHifex7o6UWJSvkWWUDXDz71Gd0shydbo6vsZxDMNlYNRiBdRlzKtfGPmO
         4NC92yO9ZiMNPei2Y26cNfvGLexBO+VrPxX4eowoGMwB1M2n04l/S5cwz/SUGdkGy6P9
         Dsq3jB3a1At6VnYHf4u2C7nYwuzzdmqMJgDnIs/iSWpmmgHJzbft3T2KMGrjpjtO5K0m
         48fCy4eChT1VlDUGZcYDrnE67bn8bikB+b3v1bBSfGL/Nab3R+lMLszTi960H0D6QtgR
         OwKC1XOfO42K7CRpp2rTysgugsNrL2/0qVgq6DJtG92Wf51Xk1TTMfE9wIBP0hCH4Png
         LzlQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoJeVrdg7lhHyxRiTY/9iiwX2UE0Aouvumz93nXrnREtvku6fzhf8aOQwoGd3m51VtBvvIXFUy9A==@kvack.org
X-Gm-Message-State: AOJu0YyBt735GVPHr+OfbJ5I94lQCx9vjc6paR0nu95TX6xf2i0+qPvP
	ButxnKN3AeZPYBuxpBT81OA1LXN32XBsQiJOqGZJfE7lKEf0Go9sk8jN
X-Gm-Gg: ASbGncvx2+1dvdDX1FV1N1xi98A3l3t1UUYyvE9FYXfaTZDsRZaykixpefr3BfWrQbE
	UUJf3DUmqVXCjlnDgWAblG/VX/L72XFysMyCsU1qx1nekiHwNGlOjqa9LIwRNERaFQe9IsMXlCA
	jW0SCVSQ6HgxLFv9HfUERUafSe+wGNZe4cG2jZo7gAwFiRr4mnkfKza96MZ8yy0vJGJHFnaE6jt
	Jle/J8ZvNIDtQG7UQNjKVmUtNbJp/zMUhvpBy1ArEEA2Mr71OHnICep/SsKYl30QiGss0RVeXtc
	luIi0eyE82NeEKSmrcBQEE6m+jGJlOx0grBSZ1bJl8pLENufqf/2W6Q8BZZjDKVDC1zsYWHAm9+
	w/ANgPRq1uC61bGA2
X-Google-Smtp-Source: AGHT+IF9A2Kqr68he/7eryBtdSIV/oxea5NzcQp/EEPSEaGXhlmWWl1RqA4Rfv6eTN56d7YYgkaoMQ==
X-Received: by 2002:a05:6a00:238c:b0:73d:fa54:afb9 with SMTP id d2e1a72fcca58-76e446fcdcbmr6372130b3a.7.1755309172232;
        Fri, 15 Aug 2025 18:52:52 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76e45293ddbsm2076609b3a.49.2025.08.15.18.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 18:52:51 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/core: fix damos_commit_filter not changing allow
Date: Sat, 16 Aug 2025 10:51:16 +0900
Message-ID: <20250816015116.194589-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o5ixqd65opa3ab7reeowfodgijw5wfuu
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F77340008
X-Rspamd-Server: rspam01
X-HE-Tag: 1755309173-548654
X-HE-Meta: U2FsdGVkX18sYXquLnV+YtPu/6d6Yeav23Q8OoV9gSMNiWhZXvoiLkNspmPSh+oL6K4NB3tM7qSnSU0vvrOZbvEhYscOZjd+4UUOx4J1bxixlIJVr6GZ9Wd9GscMzXtuPFjg4pE3xSJsttb0aeH/raj6ZpQbpquWR8I3mTjl+2SUSBe69JQgVYeAqyEKYF9of7pXk29fn2eLYayDNx5HRZvAlJk2Lt0ymduMAF/O87bdTL/XBaJLMygJayG/oi22SlZ/rq6Ge2hpfedXkvbElHqVRc2WtyA6JRy6gaKQMRnwm5IZ24m8Fl0CXh3B02jtDQxkaN9kFD/SdTVQat6fpClVmRgwkGa+OQOjkv7w1bJg305SPQ5zW5G0C/DXkni4BMxCNpMJfWsOF8psIn7hOeK8f8mTZBdBKPsGS6B/LTHaBGWgIdSkx2AbEB7wRId75hTT+iGu3B3UdDjdHkINLBgAFrvPARSuyDMO4iwmZFrjD+1oxXakV7VEvs919kXVIRbjF7/VbRAssE0eUpmaJGFCST65ZOTqs9XIQGSZUblyQCYmpDdlmdGvGC94Vs0+gZn205F5qyxMNSttm4zOZcd09lRWSyZURAae9CRUEWPzmEqa4jWFQThzUgjAmCGxPr0Ay5+ctE8mmM0UM/CSvSvpzVaYwAjsOLzPh15rkzRRUSA1+irJSNiviDseVNOw9x3MyYLNGkdlkfh9DN17tZFp5voyc/kE+7GSuJDMK11u4lhJtqT0EoAZPN1bX2SlLriXR8jOsRxSFwWtzNPQNUS7dxmLYP8hRwow0c3rZppmBlJIrnThYQi/OmZPx0uYYnr/OLJt0VyTUjIgZUdtazqSyN9ZqbYU6Gny1zUAI6mQD5ofdKO+Go8wNIcEYP3GV0TWB8V6xQVWZQ85v5nKROKhLMH4tcNcDRW+VIaZwygTckYkXnUeMAwnzV3/9CCU88iQUMpb1freHe1thNu
 OMVlpYYz
 iomX5Oa5h1qJ1nSjakn6rOtNXJavEyE9Nad6qQt2Wtp7DBWmTLS/VicRx+JDlbrU0MI4kifPyIcQRVaGMhGs7+HIG17gJeimjimFeXziYVp0pfpozBMlvnWdFAWAqDv5P+JZ6DR/4Ho0IIMmJ6G9NNS+STR7LfqNY8N1CeN7G3Zo7FTPsS7HkqLLhiufJdXqCgpPuLxiQs1RGrOpNPL6ZqStpVzoqW8SSIQI6uu392Q0zAN3VaR3nx3VOxY1W50Bbebo1GAOxk9FIwQh368aJhWTg93l3owI3YqxoM5E9MkqeGl3DPHJeMdUuMZSn9CXj9dXXD3bDeSi0tUOizdBDlDgA98XvTkayVvKprA7D1VvSfDe1t+KXyMfBVVgbMSg8HmG4PtWXuZRA/v7CE0lYNC3srQe+9bhrnmJnjLF6uLSyAJrkusKMPB8baEzO/LMWSNAlCThoXOFMiLM7psHAuOSArXL0Ku/+z//+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current damos_commit_filter() not persist allow value of filter. As a
result, changing allow value of filter and commit doesn't change
allow value.

Add the missing allow value update, so commit filter now persist changing
allow value well.

Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")
Cc: stable@vger.kernel.org # 6.14.x
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]:
- Fix wrong fixes section commit
- Add cc section for backporting

[1] https://lore.kernel.org/damon/20250815094059.133769-1-ekffu200098@gmail.com/

---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 19c8f01fc81a..cb41fddca78c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -900,6 +900,7 @@ static void damos_commit_filter(
 {
 	dst->type = src->type;
 	dst->matching = src->matching;
+	dst->allow = src->allow;
 	damos_commit_filter_arg(dst, src);
 }
 
-- 
2.43.0


