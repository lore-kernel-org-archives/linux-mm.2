Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65F310AB82F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121206B00B9; Thu, 26 Mar 2026 19:47:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D22B6B00BB; Thu, 26 Mar 2026 19:47:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02C96B00BC; Thu, 26 Mar 2026 19:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAD8E6B00B9
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:47:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94FDD8D5E2
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:47:29 +0000 (UTC)
X-FDA: 84589853418.17.7B7DE20
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id CFD3740009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:47:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b5ji5W6l;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BWqN0MwA2pohoP5pjCmhKdhw8V4J/TSimsFTnm7a7Ng=;
	b=hDzVC/gTf85QHW4lNT871p9zVGKQXwvE5k1B72bZCcVow1tyy29i1tCExBnEhVauGRRWAV
	7LShRESZhs5CzEOIhzqCEVupUW3zRP7z8zmUV//Hw6C5K+c1e0qQUc7zUN2znPwDroU8MS
	ZUQRZRJ07i9jrLAcG7jsMdawCpC7rQY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b5ji5W6l;
	spf=pass (imf11.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568847; a=rsa-sha256;
	cv=none;
	b=ppweWaO1IGrquxKk5DicxVP0zcxVOFrQfT1tXNbs4Wwsnf+ZY+rNBYCvrOMGBHjLQ/cVvs
	NOsPtkhNQMLv56BngFaOzO5Cd50T8cYF8LZASsH8wySKZROhcoto06dxfhZisFPU1v1O4m
	P5CIO7yOI0wW9Kpra+TLg0f7Hs+4ccw=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2b0afa0210bso7749175ad.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774568847; x=1775173647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BWqN0MwA2pohoP5pjCmhKdhw8V4J/TSimsFTnm7a7Ng=;
        b=b5ji5W6l0Y9ftgcJxqJJgYDlfYG71pzVdT6GO/Hex9I1oYkPPDpu0XLmyPy6/UHLhv
         XLqR3G31bWaweVan87iR0aa+3Yh41qwjsfq8fZOy1soSt0CIOhxozGmzLiaKgNECu5Xi
         FotXTFJ5dKVxb1ueE2R3GDlQsgndl535igAweBsJgu/g839H1u/D/La8W88OwTllUJ3G
         0qPSN5K9muDsN943tSHPXJjVn9SgJuKFFpiOyUkQ2DI1SlKrjyZZ/oHJxeKt4MvANGph
         mUkHIenpv5ps/RiP/ygvK3ReREEgaao1nMSyJa52GIwxHXRbUJD6xlsWz8iSIJl9K2n5
         tMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568847; x=1775173647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWqN0MwA2pohoP5pjCmhKdhw8V4J/TSimsFTnm7a7Ng=;
        b=rLTT3ndHnaHDnu+aovD9TxsLd8Y/hcyodRsDuE6K6TSGDs5xG7zLlMFu2FNuaWQ6Zu
         ATYB7noxPFM6XCCB7A4s1GYb3HCkDXnaym4UYm46yC9lWqmqpFnysenJFZkb7tNTXEE8
         GSicynRCZcmaWDRrpqBRqSwB0QbLU/Ke61nGmrL2aOVt0zDD34kvoHxeBRzPeeYEzaqr
         zvv5JOSV0Dxv0eog5qnWPXn3Sz0NfBgENRkcI+GBqu91WFOJ01g05ijYNKdGtIzH7YSl
         +9+vIeUKMsYrboSGTGS2VKOqw5XRR6nnB4f0fNNTA8HozfyuNdDlEJvc5eeotIxVWN7/
         2ugg==
X-Forwarded-Encrypted: i=1; AJvYcCXMoXzm0UF6AAle4qFwEBbjgs+2Cy1xD/LfG1JZhZmY2QtfsObNoRL12c+6Cv96lKXDJbgq9vkQUg==@kvack.org
X-Gm-Message-State: AOJu0YzjB6TDaWIcSIxeZBEmK0g0+/1GdsbTXZJYsePrqGLNWxo+d+zB
	ueS2F/SV/t1c6XFtK0H/MnHo1HIm3Bs+XAXDoJnpeeiuHafgcXf2xAzo
X-Gm-Gg: ATEYQzzFgcromdjm7bF/04w8vcc/RGGZuFHGE7HKrqVyURp/tbwqi8KjUv364I7/GCM
	0qRdf+bXeG/YD8dbDuZ8cwc/RsRJNugw1FJoyL9pYr27/6k1JP+Uq3nzyBY5gf31amvn008zp00
	P7K5hL/B9YhsMXbCEyH4KQ1QJibG9jmvsR9YBoiPkOFNFtwANmrcB2atfBxQKF5UyksU6mTuz5E
	UnFE8xQJIsIG8OQkTbOpSOPvfxAnrVBt89x5xBXGz+xInUIUz4xB8JmhxGMvRFx5jxsiOndqkyw
	ZZzcnI8cgPhqDCPi97E9tLKYiD/pF28p1Me236eF645d2WQEshm+IXdXMJySZzfmWzUJYSbrx/1
	YquPWEKjrPIutAvpSFeZshSls0CEGvHSJ4d34QwdofSv4cgH9nmzU2Xk0uqJW44D+XVDytc9/Q2
	fEOiqTJx7wdRycr1AObAUlLFj9JZej
X-Received: by 2002:a17:902:e885:b0:2b0:663f:6b53 with SMTP id d9443c01a7336-2b0cdc9b555mr4221655ad.13.1774568846583;
        Thu, 26 Mar 2026 16:47:26 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:41::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b0bc76f1d7sm43830385ad.1.2026.03.26.16.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 16:47:26 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: jack@suse.cz,
	willy@infradead.org,
	miklos@szeredi.hu,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 0/1] mm: start background writeback based on per-wb threshold for strictlimit BDIs
Date: Thu, 26 Mar 2026 16:46:28 -0700
Message-ID: <20260326234629.840938-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFD3740009
X-Stat-Signature: g4xi8a7ui75efkfnn877x7wqdia5rmd9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774568847-799302
X-HE-Meta: U2FsdGVkX1+/FJVN3yyFJoeYyFFAv7RnN2JQdieg6hDxTXvYNj1PJpqWGrPyj1rA/wAXbjJdYoJOD2RsDbrbGVOC6lSaiZtEF9J8YiObMUV4Um7j7IcVRgL8KHYn6WsB0af5fDss3TaEVjiAloh41vE/RNjT8dxwkCzuKRl5ZHQGjUObuN1k1OUVm0Oiuk0FTrJVXhBspXpa5SIgCDQM6tLcv7djU+FiOyMVSJ1pyFt4xREERSo8JREXb8C+vvvKUWnTwgGkPnMZUwyArDMljgjRPKZfmI1SUiDHtG9qHDhdsdTY+RJUdtKdtK6scMgHXiBvjzLQS+hoBEdkeqOdHXpO4Rw+MLC54G+4dJCreBEBgkJlyG3M+/LqFyrS37m8w3PYBZ1kjTJ8Z6ahToAuTJ+VG1FlL/WmBcik3JNVn5+wkSMSr28n1fSIAleHS4kkDnUyT6aLcg8655GU+8KlBsGLTXI0MtqxBrcjQB1eFVYT6CBGQ5hfwa+9gZ2JKn7iNbrsfW6O3mZGYCz8DDvZwzGjkn+UJjowutbxaG13/8ILvrF7CXzkKyCn9CzsqbA5TYAX2FcUMUpYDTvlt2CQleWjKjaQhD0ni6rMmzpJgXvJf2rspomibe/HDrQszYzHGtiE5sqyMaOtZjlqCEpjtEHwVfAxBU3dFaWPrR6n9z9TujplGRRXXQcMOSG7oKQz+/FokA3XTq//H/KiGWTimY/rgQW1eIfA3DjZGRpplhj9GW33J6rvEwi8d5gij21vPVBOEZ85d1r5znPE8bUWAKqcw/+htnBFiX3dpaPA/OokKCajvmSBgv6y8mKvtBsJcNjvgtGGUtWbFSFM/al52i0qvsFHVUq8jLbaNxGZBFKkxNBG97Nr5BHEZGDEADOoceMeps7fU20A5DXNRmALk27IOy9jLo07o7U3+cbB4EFgc36ZQZMKZJLR99jO+aGS6Fvwx7biyc8cbmUNTIU
 BQw3UzMI
 dAlMq9C7BdpT1sjG94A5ulHa26TjvtRtkVDebjWYyk67Z4Ks3UAN1GVbGCKKEfg/vAsUH1LKl8FwZEJCs7GayuKMH6Hgbrrv9z6yxeDuNURNRui1qJVO8ZS9vh38LJtf70vH9rp6pubZqnO9bUHHaIMBNXgyeZ77/01Dj0gwXxR2XDTTBjn83CdbdHupwA6qTx7v/YvKhpK5u8iRPBv4CtMkt3XzoS0UbzGvhKPf7gfKws4/c2dfZR1nbhC4aX/+M23bw7Wc/8B/dUTys6uSeLTjTNwgVXGPHCpHZdl2sTt/KtQTZPXRN4YtyBInH3gdTSh+aLPQkmCsHWi1VO7+WqVLAevOwSsxlIUvVFLYlDDXqaNXI7KFGSc+1SvCfgpyoAdvQmrKDgpY2LE71JRU8NioLnmrhfZsiW9xSR2XWwjfO2fwq6IY3euzC59bnYfwqNLs6B9iyWhOXQ+ZZRqHaxxBU1BQkqYl3VpipwVmigoZz+kU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch has a dependency on the writeback regression fix in [1]. This is
submitted as a separate patchset from [1] because [1] is a fix targeting the
7.0 rc cycle while this patch is an optimization that targets the next merge
window.

Thanks,
Joanne

[1] https://lore.kernel.org/linux-fsdevel/20260326215127.3857682-1-joannelkoong@gmail.com/

Joanne Koong (1):
  mm: start background writeback based on per-wb threshold for
    strictlimit BDIs

 mm/page-writeback.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

-- 
2.52.0


