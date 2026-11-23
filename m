Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AC7D606A68B
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=I9gqIGc9
Received: by kanga.kvack.org (Postfix)
	id 44B3B6B05B2; Mon, 23 Nov 2026 00:47:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423C96B05C4; Mon, 23 Nov 2026 00:47:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C2F6B05C6; Mon, 23 Nov 2026 00:47:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA4D26B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:47:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69A901407CE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:47:56 +0000 (UTC)
X-FDA: 85465302552.04.EE88B28
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 98218140004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:47:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=I9gqIGc9;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412874;
	b=Xph3aY+BSLb2Kl4cASmrM7VhqNvAAfeKiqKoWu9sIApbe7SFaya6WrAseEXimWOKaCsktV
	3IZKqxvYdbw/hoFpWjPEqVlLQXYcBfx97RsLt4fFPWpE1k0+QXP7qqXVIBE6dUoncWcZXQ
	fxRBjV222IjRb29NLmbyr+nEjIvBpJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KVYLN2+U6McWuEiDknSvpcPzmASCRN8tM6SVo97GcMM=;
	b=ae5ADTKGaE5bt6x17+6cHrtfDDm6pNXns9sYraYhs1JSUPl8qpkmzb8yZ5ptT8G2x+PvDc
	BsuyXosFbVTgrPWlS3N/q291m33UAXUBTladww9OLlxGs7Uto1fsA4Qqq1Xr6hd0nfHj3r
	Lj9rA2hy96RX/x5CC0oyt3z4p4RWQw8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=I9gqIGc9;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2efddf749e5so15730805ad.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795412873; x=1796017673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KVYLN2+U6McWuEiDknSvpcPzmASCRN8tM6SVo97GcMM=;
        b=I9gqIGc9Ho5OCdMsBBb60fnmrcqcEk85VF2mIUZPk7jBApC4DOhjOzW7o6Pcc0cbwN
         Y7b33jcn1t1Y7yd19X+kjn9AvajNym5SYHgsXPPI7Gk+dPn+E76rpO3XPT3IW39gvhFV
         Lh0hONiwN6y5iFTQEDpmhOngADRiaNNOm2eo4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412873; x=1796017673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KVYLN2+U6McWuEiDknSvpcPzmASCRN8tM6SVo97GcMM=;
        b=fd4SJIjjkVVk6VUB7fbPOlYAkKjNMPARmQ1dFiO5I6DPKusmi2jKSrBIvJeDo69gyX
         +HzaUMI2+illg8IcX0ayEltnAOXSss4vMVJn9sspqlW6cw5TimSvnRhAMoNvq7zhuw15
         10k1yRNGrP1ID0FM0a7dOh4uvSbZqYG9puw+wYsID4jNQIU4iuRYevDkenj5k3rHD6xA
         ujlbtEOObkCQ3eUe+7jgig216nOMlfSqeYIld6BGD6ry5Zff4Kd4/B7lCLzqcbEvSA5i
         2417iifbR7ChDWXkCS56QgXAeGH35NYazK/+0PCbyXMm98T7X8JMzIK56hzhchNhnEMf
         piMg==
X-Forwarded-Encrypted: i=1; AL+hErF3iNWn3v1lTFFZWWkWr61SmnbNi/9FoqqfX6ji5iVSwul3D1zFORQtIflRT3ueQemI6w8XLSbzbA==@kvack.org
X-Gm-Message-State: APuU4Z8rPZXe0Qg9I10jFul5VKzcf/O0EanWUnyWRb3aF1I/6oYzNdil
	nrsza28zADs7gLVseoOnJCQUUyJ0A/IQ4gNrb+9Zs1SwovnXoy70pXxhACDJXT4DHw==
X-Gm-Gg: AZFdTZdptM/2YAvhIcByLPSGO/0IP+2aXBXZMlU5E4ry9VT4uigG6Gl++zQwwfpCf9g
	lN+9E8Utn8gOdvi0JOoPvmn/WxMlJZgBKpd3aaADhZ41mweZprEToFqU89RdPJhBi8quZLTbYLx
	Byx4IXYanrxY9gPbkLvc/h9pMVtX8TtUiBGHcwAeH0+XsfuwF6JwpN/hLrSdqN7veNAGWQVyPXK
	RwMB+5SF2aG17wqksfn+b5QmBpkc/nbXeX4EQGOmC1curE0AyhrUP6p8C3ZFLQGcJI9OtC5BIio
	IHLDK82RAfYXu0vjD4c4zZsR5z9Hgr7R7DEVWIGpqOSiwyizz9kpo6uESO8ghkwm6x3iBKNLfwI
	tTyNkD5kLqF5LpEsOI0fSoI3Zym7ShpzPP+clBcxfiAHumQVfasUVTd/jtRFU439aPoEvHVVx+W
	FJOm5fe+XuuvgOp/G+mdh/3GcFu/31GcCendkp8h0/jrlZHvkPa3kf7v59tqtZ4In1zo6m1v+Q1
	R8AB9CU8f+jACPMYvTjreV8UV4SY+1Bib9lDrDUkw9Hkx/x/exKLGdhQGfkbYbpLdVNCY3+HLwa
	9fiKXgH+8KCv0s0ET13BsNrf8IQM3I/KjCSHY5UFpP1NwXcQxjq/jkagMAnZFJ+iKzTfzo3mdJ7
	vvJKZAiwrGiQhnOOk9yc=
X-Received: by 2002:a17:90b:442c:b0:3ab:8288:b8ce with SMTP id 98e67ed59e1d1-3b41c92c161mr6622325a91.24.1795412873376;
        Sun, 22 Nov 2026 21:47:53 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c07sm16240267a91.13.2026.11.22.21.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:47:52 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Hongfeng Chen <hongfengchen@xiaomi.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v3 0/2] zram: zsmalloc: speed up zspage free path
Date: Mon, 23 Nov 2026 14:47:35 +0900
Message-ID: <20261123054746.2579253-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 98218140004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6wmwj8b58af9t9pjwyd7cwiyczug6aqq
X-HE-Tag: 1795412874-988045
X-HE-Meta: U2FsdGVkX19oZ0s04+cuRcqB0E6u5RUmi4IEq3SkMEFDYwfbUMHCVdIUylo0kLwuoAB2LEU0C9cDb3lqoKZO/vdhDLjYNhTLZ+E568A8Wr2M5sNziNumgnPG7puQufqEly4feg/S81cct8BEgg6O/QKjdjtFSDrNLILsOEGqDAuV2KW1iP1WIRmxSelLzT2aieNMOtEj2LTlL69ArS87JSWzjP/O9o5LIbbzyu94J5m6d3LQ4p7DExV60/4luAy4NYLNa2auxY8OhT45fahzOFJHO7WXglANjmgyY6Ci6AFM9vCr51HUdoW09WjaJ0LGRTE/03W2YcEGbJwcod2KfQZ/6UkugiIyF6jMCLXG0VyeXIejuvQkb7Yrg3pEEZDSisd+fa2yyvFwKR4ahjKYzMnxXaFxRSDRGbNscstYYav3h1dCxCRDc8E8bFlj2pfKiyUzG6MMRZMQDqZEfXG5dZUAQcL1WGkpuhbbDXjRyvr8mHK7YuF5okz1lyuJIGMdT5pvieMyi7TK55fGbtJnejZ7EmWpW7hSDHacbkMXbPnhHjJIr1dvMrnWKbHSMuNYdsMQO3RKW8PPWUE3/ioHA9wb4YsOlo1K6gSl4HfF8hVIZFBW/znZcxGbNluaz/t2LRG147Ia6a3qr7oeQXBiTMNXfo9jrcEw0LCYMFSj/eo/4VhZNO+/xUZu43GjEkoErrBQYgGj1oI8oqKFVT4iWymQZ780mMYHpayh96YDjiC/7LhcbkJMGzWGa2MjHUgofUTfgEYNZfLcGpu3MvQmVBnZZcpP4psRVmHOjnl8/BETie3m911KNBJD36M7Hv03jcYtnLusvdiYqXwS1C8yzChMiPj6ZQtXaFSQLOeWZr/9Q8UPUJTLVtLyCFXAnxoCeMIhWUoiAUT2360eQKuyaZuyCCoqjC3u3UUs0pu1ZhsPkwD+rC4NvUY4aoa5YcE8CVA9GBjTTM4B4ShpxVf
 p2OMp5IU
 B2jLBWYDUonPBtZwfaSnSetw1kSSH3WbJtllng9frs+ZzZzuMhPfdnOb8HfS4CFLo6UYmbGhD4RWAxqZvK5CuIHO+tH40dnw07lbkBSsOyI44IWVZcNauG5WrkJ3k4ggb2QcJDknKpT1hKz2tu6sT/6ScJEpMijepsCfEP/n6wCfUaZ5Z9PvIulO+ugpAzgA5dsa79zlyuQWK+0/CsNEZ93rjvH0/lpPBsbnXoas22NbujCaDRax/Ap0Ska7uXIZ/y458mpqE/g68rQNiRR+NGTQSZ2z5Bm29Y17nmVdMrkE7DqCoZ6tEyWbh6Y+0iuK5A3fbqRBiakOP+FgVJQDiHCcAlnADs1IVHZ1R2fI8eXy97Io2mmenfbFL+Y3ovwPaQuDHmof5DOb0Yc/UTF49r78tsDKbr3/Ioxe4JwRWhNOEDvzdEX6ZjchshVQfsk0QaLIdM2gHzN6H68qr1ZwBGD8iSluxj63W2pb+KCf1ujBvfKFKH5Z1n7o3dcz/Goj3nSND99QKZF0aqm6GfpwipGYCxePihWzQ+2whge0swvBUw2lN2Jqdn1r2oJWivAH9nBc+85YV9u4Ftny4Sn98aI0Sig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This is a followup on deferred zs_free() discussion [1].  We cannot
do deferred zs_free(), at least not on the zsmalloc side, due to the
fact that object handle is now stored in-place on the client side
(zswap/zram entry).  There is still a possibility for a speed up
tho.  One is batching of zspage's pages free.  The other one is
moving zram stats into per-CPU area (as was suggested by Hongfeng
Chen), which reduces cache lines bouncing in zram slot-free
notification path.

[1] https://lore.kernel.org/all/20261016120927.3191690-1-hongfengchen@xiaomi.com/

v2 -> v3:
- clamp negative stats to 0 (Sashiko).

Sergey Senozhatsky (2):
  zsmalloc: free a zspage's pages in one batch
  zram: keep the hot statistics per CPU

 drivers/block/zram/zram_drv.c | 99 ++++++++++++++++++++++++++---------
 drivers/block/zram/zram_drv.h | 26 ++++++---
 mm/zsmalloc.c                 | 52 +++++++++++++++---
 3 files changed, 139 insertions(+), 38 deletions(-)

-- 
2.56.1.750.gf70dc682cf-goog


