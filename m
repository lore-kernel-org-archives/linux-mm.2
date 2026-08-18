Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57C3BC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 03:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5622D6B0139; Mon, 17 Aug 2026 23:46:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53ACA6B013E; Mon, 17 Aug 2026 23:46:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4288E6B0140; Mon, 17 Aug 2026 23:46:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 162876B0139
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 23:46:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8B7AC120A62
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:46:17 +0000 (UTC)
X-FDA: 85113002394.27.8EC27BD
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A537120005
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 03:46:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20251104.gappssmtp.com header.s=20251104 header.b=ECHFpQm+;
	spf=pass (imf29.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 209.85.210.179 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787024775;
	b=LxLeKcFx/EN/HbaDLkubPS2oPg3xp0T/H6O5zEeGbBKs/f1he7Y5/1H0GYzIHIzU1ZgPBI
	vTZsHLQvvlqeQryGG3ebxLopA0CGV8jHzfzrdlnVtJyACVqNx5kgF6y5L7XBguSVgm1obI
	8eFupmBKei5c+bgVxGdamFew5JZrDds=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=g-ucla-edu.20251104.gappssmtp.com header.s=20251104 header.b=ECHFpQm+;
	spf=pass (imf29.hostedemail.com: domain of jasonangelov@g.ucla.edu designates 209.85.210.179 as permitted sender) smtp.mailfrom=jasonangelov@g.ucla.edu;
	dmarc=pass (policy=none) header.from=ucla.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787024775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gvzXK3W/uIG2TnGSiCAj0G4qvHFz9goxNEqSwA5mwyo=;
	b=poyqdodslhzIV83NJ4MWxpNEQBuTTSKmnvvx48F172sejL4W0zMxCHawkwRVCYHmBbyClu
	P462vTguFHdxeBiLa0Q5hLSBkGID+wdh1yNoXxAY1XEFJPhhojIsMdFifdnj3vwdcSq9sf
	U+YnaEdb7L+z2/ynORFxB/FlEEZJZko=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8485ef63b68so3147071b3a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=g-ucla-edu.20251104.gappssmtp.com; s=20251104; t=1787024774; x=1787629574; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=gvzXK3W/uIG2TnGSiCAj0G4qvHFz9goxNEqSwA5mwyo=;
        b=ECHFpQm+b4Pp09mt07UTfkohuUmFWa7nsmE33s54CKrD0t2oPmzlSLH6dGrQPBHTE6
         q7DpJCZO+o8rPJh8whkrDPnZBg1Gk99oDKOoMJWBhBuYrH8xetqCiAe1xT+egSV71c2b
         9H2Y0o1SAy3so6y5VjLIlEQxDfo/ul58xFZDYutidi1a68zSs49XCtZt8CZ78QHJ4gF3
         vzLt//Rva2NkcumqrmySarQ4fj6djVH8C0JLDzlXugyU+3GMYhLxsWcarSmEAi/IDdYf
         os9iIZYJ4LvoTT2fZWXYY6Cw2Bb4H1m0pKehODBROavlfS/pz23X7LWnpxYpki6dXkqk
         tloA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787024774; x=1787629574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gvzXK3W/uIG2TnGSiCAj0G4qvHFz9goxNEqSwA5mwyo=;
        b=SRn0KNoMP9R6qDI9dEyMJq9iNqjkn8UpeWSyf5Xe4fsXY9KxZ/8JLA4fNLRIWbP0in
         Ab441f9p4QSG981/e/pNRwCgZhHjjBhVPFldxIV0qR3DK48kHL4RcJu+VpLsWgOlfI3+
         U1fE6tiu1P1WWTtr5+a90RE1e3dYwQCMo08sEKsVyUikTG8y5lhRQO2iVvf2ydjGZFUW
         5DFPUteIEgbQk/egB2tyW1Zl4VbMBvoGP+6mUSdnDEPiTkQRq1K8UGsWxHdnVZk9IcNb
         S+b+pD+4CABMtlj1sL2gYO71ZtruKzYL3hWuzDv5SO4IhFjxsbTLUKZXqQAJ+z9E/bfm
         ABLw==
X-Forwarded-Encrypted: i=1; AHgh+Rr833Gu6/0X48rPlBRRA0YRlwp123LU0jMPNgV5IBdQHK69HkDklDrwu6ZjDssl3AvpGt1dcWUVSA==@kvack.org
X-Gm-Message-State: AOJu0Yznswyoa4tg8juhvnV99DG/MV6h7Z5V1ExTg7R0zydxXonemueT
	hDKT0W9G3kmjPFAVf6gcHLdpKsYFd1An3XoU9Wj2c4uEABCMuNMGMsyH0HdDx/AdFik=
X-Gm-Gg: AR+sD10Z6iEY2cetv/dyofFfOwBEWPrnyUyVdptoQoCMLtfwOS+lNKV30QOkNZNojQ2
	MG1HlOFH6BwAKpfmrz5vV+JYAtCb4BAbV48qlSV/2er65F45hsyYwrZUpj4vUh37TghlFg3b4EF
	Y7xo1ewbk+z+I1VH+ZRJ6HNs2W92KC9eQsou0wL4Mn9uTnOs0S0CQm89c2oNWi4e4KiLjpTw4kr
	ikxkCbkVKBNOsMqaY5hMRhQzjjaxV4jALoBy1yueZj3T/3CFSkii2xjp0+HaX9OqUkgqeJy04JU
	9mxK4BvSkK9UXMcIlmB9yKgBWJGT8Dc3kW9RDiq7h1ls3tdGLDX3CVjzhuokHhOvxb2mz0u2oca
	SyazSEAva/COtgXJDpQc7mgVQO6vBTBAWe3LVcGoY4ZvEa/BqNaWZ0SX9xeatOdiCVXw19tRONj
	CmorjyJWulZavJPll+oKA2ZiRPT7GA3QFRht3Zjg46+1l6nmeCiFk5Zh6+/F8TCTwIG5q+w7dgk
	/twhi8j4Ig4DjkG
X-Received: by 2002:a05:6a20:6a1f:b0:3c0:b943:f984 with SMTP id adf61e73a8af0-3ccda405866mr5334939637.3.1787024774083;
        Mon, 17 Aug 2026 20:46:14 -0700 (PDT)
Received: from damon-kunit-dev.tailb106f5.ts.net ([73.93.135.51])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267be8e35bsm11453293eec.14.2026.08.17.20.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:46:13 -0700 (PDT)
From: Jason Angelov <jasonangelov@ucla.edu>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: shu17az@gmail.com,
	jiayuan.chen@shopee.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jason Angelov <jasonangelov@ucla.edu>
Subject: [PATCH 0/2] mm/damon: add kunit tests for probe_hits handling and probe params validation
Date: Tue, 18 Aug 2026 03:45:50 +0000
Message-ID: <20260818034552.11975-1-jasonangelov@ucla.edu>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8A537120005
X-Stat-Signature: pwmtzw3qjidpr41opim61wbdr5eh9zwu
X-HE-Tag: 1787024775-950568
X-HE-Meta: U2FsdGVkX19UFavLnEoBHDqII29YfKEywYCSW4ecGrEYdgGTxxL9YjiAoX/67vw2MWW8OF7OQE78UmN/X4mtnYej3uq8/nEzH3GDcNqr/cqej5WChN6ZZaESVKAlQlQiWzmhu924qCgP//YumfaHl52vqvlWByHNG2KBVq5UoPnxLTyiL5dhZ3iaCK1HaynOPoda7txp+i7nuhr+7aldMhUnkxC7SOPUpZE4zsoqthlxsnVXLxOO8FPdFnTrvEPiSRRWE4nzdPEh0vkoCtJ6thDM9m/XRDoVfiQv2hk/Tt+D/Q7gbuGVzRqLSCLvTGqxALyxcWrL1/KPJIDy0ujDZPlFUrzeyBiS/2tO1YGQn9me4xQneITzPRpG9nZElTgiMrZq2w/dRrALS+IMu9goD1HXSwaWWPtrdav7T3cWiPhj4yHZoWO4Dm5iRpUC90A3o+xH7m6Y6q4syufWrd46PvIOrR4BgDUWzfbcl7/t/UWdveDFUDoj6YCRPrBmygLr2ad8mKjQpBT3xWGYoE1H0yOLrY9VYoh+JVOlT3urTVbNBEp9fxHfggSBGLFjQgvtEJ5frrr2GCx8QM6Z114LtfylxSMWgnZKv8tYcb6UcbOR0w5QsbT6jvULV2Ry0kKrn9SZBWCrffunCZ1ktgJc21B1DzaSWEd/hDzTv2Yrj4H9+xvPio4TJ2TXFxN3NnkWjg1VbWRnwYFjwewVynJFkX8B088Y0sRWGZG2DKH6JY1KPbpKxy50pNq3mCTZkJcLCqFQRYSfSv3z7W7bwoF4cWhMgzvSjYeb3ugujTwcW7JCJ/I8i+PZDHcz0GUzPURvWGwvQkSbyT1ariKrIr4SCh+gkT7sLjq4MnWT2BJCPx1wtE2dkPeVsY5cbSHFKMn5i9kDOH+U2nrYJA4Vv3Nul41kTndm/x8oxttLS8AuhLr7OnP1+6UDnh0aD/OmttH8XyvEWQd2jKpGCcJNS8e
 W1QStNT8
 Mn2T7ZOtm99hene+MDxG92HVWOeqG/4mX91hoNJ+VZrzfLrViuxlwisLiIE0e+i0OzSRE4BapIwNkO/xn5kga+F/4MLVadL8K1/AqHmW4R3KUolGlbRIVYYR06HgfTFDJiqEGALflCJidf4ttJH4lXkJcU7swKxmXbeNAaL+m+qwobXay3ttJRWHHXK41Q+7l07hCDR+z+OdsnzNdP8GVeMTh077Ahn9lYX4Q6t5eEvFBSJfEIX1wpSkRdsgGVwTVKAa52gW3twk6zwYu3t8XCTKr4mbgAW/3Heh8M3Tsv5sTWFAHuRyklDvm+CatlEhG3417PXyo5lcqCq1rMUzrZ61+txDmcJ6yis0eiCoQ3ANRweXR3mj7zOWZQ+v43LCinXYWbJWvxnObAE6vB9BNIZZzRwU7NF+GtLlUAZtc9/HlGUnNuRLL4G8SsgUk98+dvgcIjkQ98NRbaW8ddL+ofjapOUW9poCFIzJvGhQ/n3Q6OuSiMHPFJxUuMXP4mXcUA/LeIjSD+zdC33VreUweFftbORY9GbwTQs91QlD0pTFNtMfNjEwM3Z52Vvd7cvkENPihqxp6zLp+AzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON recently introduced probes and probe weights. Add kunit tests
for the propagation of probe_hits at region split and merge, and the
rejection of invalid probe parameters by damon_valid_probe_params().

Jason Angelov (2):
  mm/damon/core-kunit: test probe_hits handling at region split and
    merge
  mm/damon/core-kunit: test damon_valid_probe_params()

 mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)


base-commit: 4b65683fd25fe596b5b5947d934bb176413d077b
-- 
2.43.0


