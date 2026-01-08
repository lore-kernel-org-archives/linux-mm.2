Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44511D185EF
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 12:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9484F6B0088; Thu,  8 Jan 2026 07:48:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9200C6B0092; Thu,  8 Jan 2026 07:48:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E566B0093; Thu,  8 Jan 2026 07:48:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C09E6B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:48:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D02EC2601
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:48:21 +0000 (UTC)
X-FDA: 84308774802.11.F5ECBD5
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id 54A2820003
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:48:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f+rdJSCi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767876499; a=rsa-sha256;
	cv=none;
	b=UkoYzQ3x0ftcbB9kH66O5ywXkBvJmVEgDsl0lpZ+BYLTt8r8/1+UGaX7Dfcr4QDkHyp+62
	T76BwzTOzUjblZBCHXruIkUq0PucE4ZeIn8JeWyTqxo4TouR4fA6WdlWgH8p7CdPycPIOo
	TcenWhFevVSQ7U8yhbT1jJr2k2okt3U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f+rdJSCi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767876499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4dlOWSwPt/7OLfxqZ2lQ40XDlyJQbigyk2o9VvelnSw=;
	b=GMI6UxcP95NjGzxFDkc1PBSoGM/BjXjrwr2vanvwifK2P4r6YCR3wABrP387aD7IBJFUEt
	3jbH9ge82BINNrO9peWAap1eAXrSGT3X+mDjebQyXwmf/a6nyLVhj0WpPJdrGHhsE+Oy9D
	LU9WVRGRzlCHT4Lyu8OTa1oz69ykCNk=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88ffcb14e11so33753656d6.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 04:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767876498; x=1768481298; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4dlOWSwPt/7OLfxqZ2lQ40XDlyJQbigyk2o9VvelnSw=;
        b=f+rdJSCiJNEFU59Xt3jkN1FZWSnDM9qFI5S4xWKsVL9ujB+pXX0xpwxwitSCyaiApE
         udXxuCCrRUl7L+woVPHo1g0nxiMofpw13xCKALQ4uXbXw5EJqCwQN5+OyI9rxGwELwFE
         siWWXzJclb4H7tOL4JY3W09cXuWnM1Hc82kxhT7HALCsgh5vJndaBf6KdLWmPG/N/HTi
         iQl07ZootvMkO4v6g+wKSB6/R4DYRxOjdwu4Krp31wIOhJSQf6TzM+cZ8jlyU+f5GIYe
         Cy7xJ0y/EHnrw/3ImIoZ/X+0aYJ2Qp4YxgQWbzeDQ6ACEN2zQmwV6UVoUYtpL1E/SW6W
         cYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767876498; x=1768481298;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4dlOWSwPt/7OLfxqZ2lQ40XDlyJQbigyk2o9VvelnSw=;
        b=YkKwuaYV3hz5pFzv8xJZT8ot3pziMS9JfXTNa8PCiHDMtVjkBnsIy08VkjvQ6n0jWg
         veAY2pLoOWbqoLnLae+cSAUCWyUp28+Pg02aa2B0c/EU5Pie9fGOAZY7fNn7RpB90niK
         y4ej3WIvxPdfkcOU1vXNiu+UQACXW4UyZxEURA8X41Wf5E2S3WRsyuksiWNcsLFxztg5
         j4SgyFsJ5ZdAD/L2JoGrUx5THbXoJMvwWuDStTr3P3VHxW51FUR4Yo+AY6E7vgoFcwa2
         xB+v/afwrU88zU1Di3llrMm/jOVcCxvwggLAO3G9/2JH4kEInXm91iEj9pB7rvqt4NtE
         QSgA==
X-Forwarded-Encrypted: i=1; AJvYcCVB5N1erzKJkh0quemOsAETxm9xrJb+e59yBkfbANRLsBA6T2P/oU+3sCzp//tgPA4kLdJy4/9Ljg==@kvack.org
X-Gm-Message-State: AOJu0YxqHs0pBBLttQuPpNUFX9OXahIfB18+FNgeWFlQn7tgU8K87MR1
	KOVcEiQan5/7Q+KJBsPmHqBbfFCdiUu6pgx8dglMkpuASZDGFRS5gWWsMvBaAQ==
X-Gm-Gg: AY/fxX6889RnRRPCPrJhsKb0WSfspuoMcwCWAWtGZveBXjXRBZNpwKgOzie8kPbyNdQ
	PPyg+K5c6DAuJocAL4MV089y3Cw00/SZMffPkNwJO24qJ9jxioBOIrW+R7OG0/xg8XfxC6MbBsX
	9eofmYyXXCe7/i2UmdsVsFUHCqhmsJBDM5wnhm/QmkeSL+x+4tebubo9nWwc7txufe1NeIp2Smv
	CW/fzJhENyhFdY8NJjoWd0LL++Rk39DD0iglezy4rlGiTMsybMv8UuMAXOX5Gp+a1tF03VUrlkN
	9GgW6vHsChzXATD7xMDPXKeyZWY1JTOHnBUCaHAkNAo2jzYN/AIUlCkfA6Kg5HoDvjLxbPviozg
	KunxYR6+uFAY4hsUphG+j9AHzxW9cSml1nWYZNJgPAI4wj4M0k0bar/Wc3Rwdkt8e0DdfLBlssX
	Pzpl0=
X-Google-Smtp-Source: AGHT+IEEoj1JTojQ2DgoCrIyIqOducGqfdzKTZ9olImjfgPWxDAdOY4kkh13Lgqcr9kesWvBx3UAxw==
X-Received: by 2002:a17:903:1745:b0:2a1:4c31:333 with SMTP id d9443c01a7336-2a3ee445ae3mr56242315ad.19.1767876025072;
        Thu, 08 Jan 2026 04:40:25 -0800 (PST)
Received: from localhost ([2a12:a304:100::205b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cb2fe3sm79705945ad.59.2026.01.08.04.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 04:40:24 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 1/2] mm: add filemap_lock_folio_nowait helper
Date: Thu,  8 Jan 2026 20:39:24 +0800
Message-ID: <20260108123957.1123502-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 54A2820003
X-Stat-Signature: htd1381zizztd4attga53xjcd7sfbru9
X-Rspam-User: 
X-HE-Tag: 1767876499-854393
X-HE-Meta: U2FsdGVkX184QLhayxJ5h1fKjFWml3D0GzVOyu87dOSjzFa4kY52VW52UPPPtI/92oDBTuyVanqzrQMVFyykmojiAAQhSM3gCgueNwrZaFo3/a2xf1HshZlkJxp4E9knyQODbloLx4lSDl7fJ24yvcZqKklAq5tCV8NbyqSO6dHNp/UrnFMFGKn3UNmYDGmgT5zS0CWyJ0GJjAg0h70AxIl/J7V2lwZapzEfgIKrAvScmjaNyfYsZEostN7mlivJJBsi3rIPOa453nAj5LB+oNtyE7HwUANlSHdFb7Kurx4lewuO2rGPmBF/HtPh1NuWLiXslW6nSJHzlLP4dOvCYoPIwZ/pWJMQQVVw7Rr48STvt50etECzy7Fldq3znHScNVSBqMIOhCOk5l+fNpvGeQ3y6vHkFdEpisejqT290vBwM8d/OaCm+KkgcYokluiVV32XbE3rTAtvbz5VSO/MVrF/LRN/xzfaJrFjIBqptXmEoC78ZkRnOXtoz/2cnGkjjD8vSv2stENXzoszPOgdec/ccSdbiABMUc83bpgCMmF644lZ5Fh5eW8+qrUljal/txRtgKdwhXQb+5XwXkf7QAXO1Tdz6QLgE9e9jgMkWUIkU8trUDQU3f08fXcPmbQnKYJkkcHWeuq37hPW6sodufwbYErudIv28S59tTlzIq53CJsTqPAUgOgCnmmqAy0tF+ykRKcFmO9yc1Bjklq7UYoH7hSqY7a+qDBIBvLyzSHzenegTr0I8Ij5+LWFxwYH2J6uv8X8YI3rPXSUVtmLzbig5HxFH7o404kOr/4TA6+D3uel4qysVbuFy0b27G7IkXqDIMUbbQRQLfs2ky84gO96QvSU/l9rkrDjiDpat5lJTZalyIEU+BNHpnK6zd/mrF1LwUJN0fU0BGQPrJzPbJ1pz6s8xFGxtJnBoUDV7TLMd2VflARcVwelETDYXV1xEpdpnRVG9Xm49Aj/o8I
 8YyNrW2F
 dH3+BwMwEiS1BtZZgeEk9Cu8Lq7FhrM038755M23NZ80fCxta5iFtPqAcbHdAOojMErja8p26xWceUiSVmRHa+x2fWIwSjHmgku6rL4CkpF1JMTVUWBxZuRvJy4KNWU1uhW9cTGunYI19OIOHqRpMXpcgZwuxViIy1Q/CsjqGZ9dbfnRpdGD+2rF2qF1ZGHdvMRu70rm4CFNk6JWpCzArMyhtbFNShtpGJaLIApu9NXXcJcFeuw4udkL3dTUG8U5GDqWyk54pPDjmNj/f1tIbJGnjx0wssXIQS7og3XKn9Y1gwU+N5n1bmbGqkpPfnJN1tblXJvlXj+L91FsNAyeqsmKqcyHIFianR5DYFLSYaxhAW8l+It0+dPkgiD7KFHRaEqtuqlhZo8LoMSMJQQ3tnokk/4woB4zzuG3mbveRruqYN6qwHU7IhkwLcfIAfHr3bGhK4/+MJDkyeCvQHVPGQOvDBFdEBcv8SHxKcWH0QsZcOufWtNgzOGcInwicTIx81ACg/ltGsamBEaQoLiV/yzKLNzpibPM7zO0ZVFpsN23OvPOMvkDBQ4rseQbNvcu5tdvtfTFYE7cfGaesAvCmyBOOBcNVJWRzEYcFeYYLs0B+KKBYmKLBUfltnw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce filemap_lock_folio_nowait() to allow non-blocking folio lock
attempts using FGP_NOWAIT. This allows callers to avoid AB-BA deadlocks
by dropping higher-level locks when a folio is already locked.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/pagemap.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 31a848485ad9..b9d818a9409b 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -825,6 +825,12 @@ static inline struct folio *filemap_lock_folio(struct address_space *mapping,
 	return __filemap_get_folio(mapping, index, FGP_LOCK, 0);
 }
 
+static inline struct folio *filemap_lock_folio_nowait(struct address_space *mapping,
+						      pgoff_t index)
+{
+	return __filemap_get_folio(mapping, index, FGP_LOCK | FGP_NOWAIT, 0);
+}
+
 /**
  * filemap_grab_folio - grab a folio from the page cache
  * @mapping: The address space to search
-- 
2.43.0


