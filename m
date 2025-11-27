Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6FACFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7496B0026; Thu, 27 Nov 2025 00:11:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E5F6B0027; Thu, 27 Nov 2025 00:11:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BB456B0028; Thu, 27 Nov 2025 00:11:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A57C6B0026
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:11:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DC2885BCDE
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:11:43 +0000 (UTC)
X-FDA: 84155214486.07.7F59EB0
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 066B5140006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:11:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lbcCzwzy;
	spf=pass (imf09.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764220302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VNELv++YwbC54kESNxXGCOluUxP7zAxLktNtjGFxJOg=;
	b=ENSHMLFfLaOJ0pus6xiigM7mdY9lXUbwolT0mBU6uPXlPnkk8Fhl41jaZF3nhHEHOyPf9K
	/InjdS8n7fbcZc+12om7tDssj4kaIeg80zcK6IsOFTwSv8O6m6AgbzinJV4OX1TN2SM+BZ
	6dP2N0r6qj0ytEcBXQ4b1W/b5NqaYf4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lbcCzwzy;
	spf=pass (imf09.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764220302; a=rsa-sha256;
	cv=none;
	b=nUwCl6hTW6n9wk9fNP1rTCvh+xwFpT35T3Pba42JBAu4pfT38qmb8fjFascrtuSN0Bt8zD
	XDqJWES5UmsQL0mbo6jPqckKqEYLJWD1p65DHG4P204Bc96SteTZU0nINy/ySKjnWKNTQw
	0wLp1vJqWvxt+CnI9Pyi1EDMDSIN290=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-295548467c7so5808485ad.2
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:11:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764220301; x=1764825101; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VNELv++YwbC54kESNxXGCOluUxP7zAxLktNtjGFxJOg=;
        b=lbcCzwzyvTD7/Hgagio2TuO2iX/wF4cCi9cL+pf48lxbUtYbl7r7dLec2mu+x9psok
         beSoAtMr/vbJaJkK6MknlSCwZRQnvoKefJczgk+MqSsPRq8SCARy2wOEY+x73nkVauVv
         GZsUk9F3XQly6Beoiow1j/hi7U41xj9pmh1DQCqfX4lEJTd+xCkCBB9XpsfdGZR2t6aQ
         rsiH8qK3qI2MgHxeX+lOLXOGcSZVhT/7qltBdik5O5mmjpMVZj11d/Ydd4hQNlyXMhl/
         SeEJuMSheh4GkfEJGjtO50G0FQgHoEfSaTCUscEGGZkNXRUjs5ZZtvE8CgeYaHq4FM5d
         H4cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764220301; x=1764825101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VNELv++YwbC54kESNxXGCOluUxP7zAxLktNtjGFxJOg=;
        b=aAhVOnUAeyAWCFllkR253nkVTwmi4QTgwByXFYkTjFyUBhofVICJYT7I4uQoSsQzc6
         mj0urLTixl9sB39oqMPhVwWgPs8yAVeEVMWbse0tDp9ZXWClhg/G5G2awrI6darWZ8My
         zEaGNZEok7ZpS3G9NAZpZ0Gcy5zR4s2CgoafYlfrdMTW3zhuYA7nXdOyUtwS4cOE0/PT
         Tr1+kGogX+j/7hDuYb8ZQjL4v6L3d6eiF8r51BgHJ0wy55EGXh+bEvz+CpjNj4tcuA3S
         I1QvSHscQD5kIkb4q9nv9x67JCF9Tx2G8lxfWMoVbzQF3WIiQDOCEDu2CfgXbmmoM1ip
         Do6A==
X-Forwarded-Encrypted: i=1; AJvYcCVXG08uBYLl4WVih+ugYDWrHz37BpCVtW2p8E8M4TiXcagzAEnqJswkDY+2VlUEa39wipZMur0DUA==@kvack.org
X-Gm-Message-State: AOJu0Yxbx8eErrWzpLAF/S1tO2hGoGwcqwYWqS8ogyfTUfRUxpVKJYds
	qh6NSeLigN92p4djbatTatnVGIzZQTWiVPPst4WWBcUgQukrvnrVl6wV
X-Gm-Gg: ASbGncuBu1U0NanGQqPk8vALooECAyTbM49c0+UQ9mUMUlhKWmE+rTJ3u0GzUMKFoTy
	leEVpebfi97DWqFeKN2LnQEgSEj+bmHXZWWn6pL7ycTO7RYnn2QASy3fdIPFVIKXejBbmUwg/UC
	pc8hAkZeqPmvWlS02ise0qGEJjUPpcVbJfh9PBfMvcsEUlN8eFfzNE+QG8C6vhJEqnReGiNV/tO
	Hjov53Ug8/eoDkTmRpRdc3DIqMfVwB716V3cdgFtBkjtyWDENIPB+p8NFj53BZA63fJply3VJda
	n33AvFMDT7kb+jTeaFn+4Mo4f+iGPB4kSkWU/lIEX4qinTFIeEMjgbqR5inGf7LVdaJfVQeuDlG
	D2Vg8Wq1xaDhbEzUfzTfFRmgPy1YiKNJOeiycyFey9G9hLHPFTzv2JCf7pahgj4YY4/cfBHPNEO
	gGSMQNef67+bN/Dx3QTkL3ZRJ84w==
X-Google-Smtp-Source: AGHT+IFqg7v7iOdZ3USt4elMWC8fWYPUKOM6NI8I27OQ35/QuSWuYD8EuYM1x5wPN098iRtcfx347A==
X-Received: by 2002:a17:903:32d0:b0:297:c272:80ec with SMTP id d9443c01a7336-29b6bf5f043mr283637785ad.42.1764220300768;
        Wed, 26 Nov 2025 21:11:40 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce442744sm3590715ad.23.2025.11.26.21.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 21:11:40 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH v3 0/3] mm: Coccinelle-driven cleanups across memory management code 
Date: Thu, 27 Nov 2025 10:41:27 +0530
Message-ID: <cover.1764177933.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xtr1wrhbwbf4b6je4mtjwk73es3ndfk4
X-Rspam-User: 
X-Rspamd-Queue-Id: 066B5140006
X-Rspamd-Server: rspam09
X-HE-Tag: 1764220301-966095
X-HE-Meta: U2FsdGVkX1+95PKbUi7WzEiq90bfbxMW02mYHKysSDYfdEmUTej4nsIMlZ38ZbBbmCU6+FspMeoH6EOXFqR+bELFcfXx+djoz1W2MqQGxdokP+y3rOEQIIuP3i9btTZwF/AWtoLnYIxhsBA+4wJ26+tgI39PnzL8JN2Qm8gHaD5KqZyPprq03FNuiy9Lqiqp/dLj2LJysCh9p5cav6UYqK7ga9QGakrSWPp+vPG7XsAApO7lGzLqFyXNeTS97HMx5DGKAfM5YOMBZd814tFd3tOk2cVQ6e1LuBPksD4y7sPVAmdaeJvOpTr5xovOpZh4Qi8iJBUzFqa8coLfPYuNYKR6RYaimmm58P/28QDDsiZboT4C9hB5YsjZWHVe0DoQkDpTaDJXEQGCXsKMYabTODffeUBJXHbhRyoeutLpl14yxGP6s8UyB6eWYb/Rojj60HPIB6JhWuYKxtwpXPNId7aUN7mMkCbuAK1/I4cdnwmZLGS9GGWOEDuZWJq752F2YvQMiBZAqMgqEszOnxsr1Hzd+QkByzBLi4w8VvFDyklhWAIgrcclelUQU/fV4YgY76RbG6J7dE0IbbQVmR21XeqZXBqHbMUTbzEHDcYikNYIGO51s9fyvLJZ9DX67Rq/+zLf6PaSrlxNoETcUmmXKmhoqK6JawjukxgCbry4YARN2+ojdTxEOqylFq8XFw/iM8O6WZOJsmNDE7yGfzO4A3Fi4zJJluB8PumLaKZySxEUZK4mAVzeQcuzHU3q3PAXNNSu0bK+gquwGnnVonztPMYbrpkDAzUEwtWS/IxdXuc98flqUwyWijQSSr65SfKBEVXWG5Mea0F0PquDN4WW4QgI1fMT3BMKFJCzoa/SRYAna84ACz57mK501glgIkwoBk3WHUDqUHam6Rl1e1ONCFVHwF+BD8AH31RXFxUZ6jTvMeiXYkySnfe77RYlMb7jZt9oBE6nismtvfEF7n3
 yUR0MFfR
 JzCG0iYWY1GCvlhFakyo1/31xVadRWLhDo0SUMIQIl+OZt+vTrm8S7DMGUMpddz7X0l8X/viz+uY1LFd4uK5pNXLuHYrsFEoUmwm5Oo060N6e/684cucAubhJLrXJmd+H3ry+iShmrAQq9G2z7rDPbMbyADLcNW9s9D6V5ob9bii3xBgQGtxJ+OXwLcyZSGMAf90FY+wICDObqgX9Czt3uFfUzPSw+Gf2uDUIKFtd6++elwq3OLNa/r0oPoG8pPeYCWGCyuvsXXDdglkcg6RJljvIYquS+CmXI59pd3WUgYCknrHuxBYJYnjzHI7FRZG+kgef8txgo8NvmPFU+RKpi6za1nGu+JrvwXbF3LybMK7FnUqOooi+JtESLH7RkTJdyCIk3kVRABA4b7BjimEYx9nm5Fw6/KfQDPx5tTsWzAQrEWS+5UbwvnhJp3T+c4Tya06lmc2BMLIpJqSyXlGFBG256Q7UTgkSQPYaSxJIQfv3fuPT0TUcc4WJ++8qJTyshHBk1sKAV7wlUvDNCnBZEyzT++Soo+pc5Z5akjhLmD+gBVVpNsZCHOpOBXXUOpuhe0i/OVCt7QbKGiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series contains three minor cleanups identified by
Coccinelle scripts under scripts/coccinelle/misc/:

  * Replace manual ternary expression with the min() macro in pagewalk.c
    and change return expression for clarity.
  * Use the %pe printk format specifier for PTR_ERR() reporting
    in vmscan.c and zswap.c
Found using:
  make coccicheck MODE=report M=mm/

changes since v1 and v2:
- Patch 1/3: update return value as per review comments.
- patch 2/3 and 3/3: Add Acked-by and Reviewed-by tags.

link to v1: https://lore.kernel.org/all/cover.1763227530.git.chandna.sahil@gmail.com/
link to v2: https://lore.kernel.org/all/cover.1763796152.git.chandna.sahil@gmail.com/

Sahil Chandna (3):
  mm: pagewalk: simplify hugepage boundary calculation using min()
  mm/vmscan: use %pe to print error pointers
  mm/zswap: use %pe to print error pointers

 mm/pagewalk.c | 3 +--
 mm/vmscan.c   | 4 ++--
 mm/zswap.c    | 4 ++--
 3 files changed, 5 insertions(+), 6 deletions(-)

-- 
2.50.1


