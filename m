Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06E0CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 23:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3675D8E0003; Tue,  9 Sep 2025 19:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 317998E0001; Tue,  9 Sep 2025 19:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2072F8E0003; Tue,  9 Sep 2025 19:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF288E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:34:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC2B1BB2A5
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:18 +0000 (UTC)
X-FDA: 83871317796.03.A00E429
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1259240005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b5bHZ30D;
	spf=pass (imf07.hostedemail.com: domain of 3d7nAaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3d7nAaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757460857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p94KfP38ehFFAQzIc4UYzAxhmkH/aHIfMEPOUg/9po0=;
	b=Sp5/68C1OY3On3tPki/mg8Rb5lBcxtvGp/TraK2K/3JydIVRXWOzb0Qiy71uhnlsTYjKOZ
	fZqhS7aZkMzwhmLhzxT2lj66/TkqsSp0FKukTW7kSucf92RiUwCNqp/QvQe88gZIv7iIhZ
	y/aWagilTI6W4BzZvNpY7HoKWQxalG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757460857; a=rsa-sha256;
	cv=none;
	b=sqzMe4TgAra6IjVnZyZ8gr5FtN6xlRdBTTbVj4bwtXpL1TMYwUyp42OscrIRO5A9qOHo1U
	lCxk3/CS+SwLXFXFil7w2wlAslgXE+wiWCzbpekvnADFTAktRCkrVxm4RihjYLH8OQjD19
	p5Gfhg8DwqJEJf+HNwPiMWKt23P+JIo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b5bHZ30D;
	spf=pass (imf07.hostedemail.com: domain of 3d7nAaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3d7nAaAYKCDooqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77288e1ce43so6314371b3a.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 16:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757460856; x=1758065656; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p94KfP38ehFFAQzIc4UYzAxhmkH/aHIfMEPOUg/9po0=;
        b=b5bHZ30DivcGbema5ZjiBAkj6NTgWsaCjIyr1DOQ1K8ZcMf/qWcuM3SfxLJE0mTRbt
         ZsZDsRnumYAVLiJ1IjQT9r7eof+yQ4HmmsHfr8r63m/+83oV60mMfJFWEPuU9QKYZ7GO
         Yo7aQjIhokNQb5Ly5pINC+zWkxGp5gC0LrVlnI079U924RIdEM2nTNF6ZWc1TkX5Jpm/
         NWfplnZz4M1eLedz9FU5MNIGMAJnRP6xnuQ28ppZJt9btKvt0McLbEdz2SXwC5+RQyGt
         YNpzljbACEoO1yZG4eGBZOM7ia7wz4ANbSWYe7ejKj4DM7pECiRbZ/8fdGAdSvwvCddD
         vSNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757460856; x=1758065656;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p94KfP38ehFFAQzIc4UYzAxhmkH/aHIfMEPOUg/9po0=;
        b=V3Sa8EvB7iDaoxxYQKl+XI4b9CNIX2DYX+1XxyLB2ogWI1ja739ZCb62NQ5sZGuqUa
         3qLShBpF/rhe3DfP94HWQRnJIDj++MB/zPIdk326tpPsYxF+Tk22Ep9Leb8s2aHzkINt
         Y7vY0pSWXx+Zt4mk9MBiBQ7EBiI5l+CUJefEW3QWUM/8YRXWQFEm9c6f2ycllggoAua8
         NUUUGRBP/LjT9YWqOkOrOowMv2/dsy81whbMNvED7cApb61sr/ONxPPb531WY8EE9EWV
         KPXZ6c9W/jP/g+DC4YXccaGuzz891bCij8ie68+TbHH30Eg73s/KB31+lIWcRbfqZOm4
         RtMA==
X-Forwarded-Encrypted: i=1; AJvYcCX+q28CSaEUCfEr5LF+qE5xwlA+7BrzzswGCKAaiw1xLKnFjDCZh8LEiUBxSPKLOuUGgCK6ZGTRZA==@kvack.org
X-Gm-Message-State: AOJu0YwFW4JJl4dgIc3t/yJC9dl13BrZ0Cz3sHCQ1WhLO/0xRitBXLqY
	0AUcP5AXAmq4MtoHp52D0KfkDTW3OQ4WGHeZLCG3EdAKqpAwf/9vV3qsInYxHowpRj/Hcmb20hJ
	VTSRJTA==
X-Google-Smtp-Source: AGHT+IHe9jU/ZXDF3VrMHA2zefxE/BkTlf3fesT6KUXKBfH1fEUS5JMtiAufZ6h2wVl/I0nMlsowMm3ygQk=
X-Received: from pfbbm11.prod.google.com ([2002:a05:6a00:320b:b0:76e:8d8d:6652])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3c8f:b0:76b:ec81:bcc9
 with SMTP id d2e1a72fcca58-7742ddf0f22mr17694356b3a.21.1757460855691; Tue, 09
 Sep 2025 16:34:15 -0700 (PDT)
Date: Tue,  9 Sep 2025 16:34:07 -0700
In-Reply-To: <20250909233409.1013367-1-surenb@google.com>
Mime-Version: 1.0
References: <20250909233409.1013367-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909233409.1013367-2-surenb@google.com>
Subject: [PATCH 1/3] alloc_tag: use release_pages() in the cleanup path
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jranzwzpn7ea1jsym81czgc4ek9yft58
X-Rspam-User: 
X-Rspamd-Queue-Id: 1259240005
X-Rspamd-Server: rspam10
X-HE-Tag: 1757460856-995366
X-HE-Meta: U2FsdGVkX18cPQ7hlw2jItLFIhF2C3cJeJD+xHpY/i3r/1uLfg8s9D4EqeP2P+raBgWvpRPehqoiN0louF/hVt1G84xTjqdQMWjmOLiI368URljt5jIa3xGXHl7SsHvbp1qOZVPabfx/wHeDDXXTDs3qnSX8eSrfRy87lBDVEadsFuZvYdSwnf+OtobGeH+UOLf/Invtiv8pvR4wvfycCgT4ZRqv9UBHLtCNHi+Ay+/G4sFlK/K+Z+QvPhkCaYl2xXEidR7Lm27meodw1MoGUR3U6Jv0wDPqPx6QyTkcTYYFyPPZjkQtbV2eFnb1Dxdq4J9Zp7OdwPVwmdYXR0DrK51KecedYPOdkbWIdez1LLki70UYPWrJKO4ZlZWdh1uZTe3ARVoqRO59Nl5RifqDTEDWHF765N16vgrNiwiOMSlLPYwjHWlAjnS/UgfTjq7evrqrJX+eUjnL+sELV7eY2D/iw9g9fMW5M/8dejS8YGu2TnstcFDlFEDsKG25WQH2yqkzi9pKhaqyalV+VVXQIapPalkS6gH+vErtYk8bmb3Z7pwAZDtmgYwOFt0FA8YMWWJmVPr8bYznqP70+BHqvI9D19wig6EyqarNAqMW/CFZ2XbJeZy/tdCK4wuwxP2zH90H9XX+Bt/wznDeEmwOjhd87Ax6L5ltszreYEY5pcWXhHuzg5DG9Xo7nfn33yX1ZgvD2FTLERVZVRMBMQhnbCXysKYCiGFpgTQ1VIiZyBN8+WL+qQGsjmrXn2Q7a53dT1s3yTNicLytdhws+q8lcivM++qZb/r1oXvRL8AvbiaTcEYNBqr7f523RwDDuRMbCc/tPLFx4BEStLtuO4vFd7njgEyoJDqGN9irhT9mYhM9lz7BMYDtMGwNOZiZXLdr7VXhOvXbSZ+ch1R2jkYyXOcECRlAuLBbnIwa+JPUXLWCayt39NSMKAdg9i/JJs5VD0QhVFQ680QWi5R4Y5v
 5tdIRXuV
 xK11pTUebv2xDF2ypQ7khSAsL1ROwZAeNZCeviabbF4tznofXduXsVAYcmZxmPFNbXST6qxZt5fIgt9/bh3xAx/y+2x7UWj1+M/vZBzc7MJipYKDb0unT2k4at68bnqrJ4R8IjDCk3jLmquXGg7EdfAhoJXiMcokyhfvejY7sGiVNrGZN/bo1GJ7sxvxYySJfvuiQ5R1UvvvFHa9RSAEOb+Os2c5vAJk6fkQuQpGuFkMFE5ylAeWtzE6Nso5bx2w4sShP4HaHfU16J4T7WX2RrCa3mjigSkoA5GJftdO+P0cYfENfE3Lw0jkXKyyEAd/AJHs2hSbysaEZioa64fKwO7rh66jWSBbflZrzhkmTGEhp8dOy/dCaIhjCSixzPgL/GfPrn4YKKaqRxTVRoZMoQNMrQdTuqITai7ocWjMzf9IUIXguPRjf7LfmZ1X82o6gssUskFELYawVVaycT4HmJSJ7mgpUOTVkMz2keB8ikS/KgUTB5iqbGX+dnHhc+IYRHhvj+xFmAIXV/iYYTWDJ3ULswDogSX7TZox3DArC523d0N9awTArvop/vQ73eFeqWpbMBeKdbeJ9Htl2VRjciN5bOOT+q8+dGXYh+Xs2TKjTgJ0R9oODq9dRUjOIQs7mdu5iRC+FtOGVTZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When bulk-freeing an array of pages use release_pages() instead of freeing
them page-by-page:

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 lib/alloc_tag.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index e9b33848700a..95688c4cba7a 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -438,9 +438,10 @@ static int vm_module_tags_populate(void)
 		if (nr < more_pages ||
 		    vmap_pages_range(phys_end, phys_end + (nr << PAGE_SHIFT), PAGE_KERNEL,
 				     next_page, PAGE_SHIFT) < 0) {
+			release_pages_arg arg = { .pages = next_page };
+
 			/* Clean up and error out */
-			for (int i = 0; i < nr; i++)
-				__free_page(next_page[i]);
+			release_pages(arg, nr);
 			return -ENOMEM;
 		}
 
-- 
2.51.0.384.g4c02a37b29-goog


