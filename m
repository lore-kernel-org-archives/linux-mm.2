Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1946606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c2NHoMRW
Received: by kanga.kvack.org (Postfix)
	id D505E6B05B6; Tue, 17 Nov 2026 04:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27F36B05B7; Tue, 17 Nov 2026 04:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C170E6B05B8; Tue, 17 Nov 2026 04:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A05EE6B05B6
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:10:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D0331A0399
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:10:44 +0000 (UTC)
X-FDA: 85444040808.28.34FDB22
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6107140004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:10:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c2NHoMRW;
	spf=pass (imf07.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794906642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qU+9OGvRfJV1audZnO5SC1P0nvA1K8+fKrFIUfplFUM=;
	b=ct6vEev6vWVkTIOZBV+HqDjVyeGl9qz2JfjxD5Bxbqpwdame9XQy3J/ti3PJaPia7cd6UT
	LjYepb/36fVqoIQtqykqmgFOTJ9Vm2SUxnC0tgY5QHdS+YMqbbk45NSSyYDQeQB4S9YG66
	tVsNM+WS06hYYqzQ0gn291yS5HNkBxo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794906642;
	b=OzMt2n9kobF6M/RdRAUih8omC4yr2b+d05RTzE3KzReFj4mtWUDk7kP2/zIVkn/7oGiA8u
	DRRwXowWe/zRjIHsLP2wW2BOKuMNx7OudNYmy7w05mnRfGe7tO/6AayKEHSL92v4eqRm+M
	4G/aY3p/Ol3qeM7ioebv/0GL5HLsVQ8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=c2NHoMRW;
	spf=pass (imf07.hostedemail.com: domain of danjwade95@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=danjwade95@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e96502e447so44375915ad.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794906641; x=1795511441; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qU+9OGvRfJV1audZnO5SC1P0nvA1K8+fKrFIUfplFUM=;
        b=c2NHoMRWS6gxIar0lbD5/E3AUewUOAIV2E7UJi7QAbrrNANoAIDG2F8nGz9WohVmEz
         LHB1GZRuUV1CBmiddT8+U0Nf9uXLdxvx4rxSQ+7kcgw8pAAXi1FktQWXX046nXZi89tW
         z5jxMoJrZfjiBNApVQyXgOWJX05l+H3A6MJtWJkTXcb75igpnYJMw80SEYE0s7aMn5n1
         EWmTUORzy6mfb6L4fH+vqLBjtW+DgQdyFCKBVS3G+FlychXMHTBeImDyERQbUpj48KA2
         hJSoLI90BwYIXMstzOrl7vmUlAumatRW4DFpajRJbmH146sXBcT0mwkqjZ9QC6LRBtSK
         rQ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794906641; x=1795511441;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qU+9OGvRfJV1audZnO5SC1P0nvA1K8+fKrFIUfplFUM=;
        b=0qFxLVu5qlspA0vYVdjp7OUaQO1ryrULTbjbVajsPMJwCitJUIQhHB3XBZHQNXD5g/
         V9AipE9iGuH8Q7Efy0kMmzncYJFO5D9XvsiS+iSVXihN0+t+3UFl63APz1Y2oownEgyC
         P75G7FF5sLYTfkBm2Z6FeRs0tkqgLLogmrtL5LYLEqy2KhkK/9vKH997AoUzDMdB+zsa
         QMAv6EubOA4iYKOTcv4LDJq5PMUflPwhI6g7EeD1GS/FFwMD1Fo5+lOHJRmRGDrjGHyJ
         Vm+JDdveLJSnWAPTPu6CSn5s3kpyNj2nNglfFb4yBlkz+vjW+gld17hJhQWt8RfRP446
         b8mQ==
X-Forwarded-Encrypted: i=1; AL+hErGoQQHdtH8XJDfSYpai6HADfqexdcDMy0vFw8M9vz4Cp0EsRoitmT1KNNzwvV960T5iboETrYHA/g==@kvack.org
X-Gm-Message-State: APuU4Z9FqziOIMK4TKyvD/pRqCTaYp2ZtWywl6xk2pIX4WoqgPpOpaYu
	f0lsdxdzFMTGpLKsLYaYwXc62XnhmMLCBjEOlgbKQqStUNeE2glcAdhB
X-Gm-Gg: AZFdTZf/a1xhAw3Y6BadGaAzTOCPAVyTV0XFv/BJKN/zLrxxtuKppwsIUhTYX9xWbwe
	r5eGg1R2fhlRTaojJlc0E+AOtvnMdovs4q+hVNWXNTqEF6Bh0OwsLp5nqJcqZXLLRRSImcPm0iu
	zHU3icZjaUUG7ek7IIgy0zaCgqz1NB6cjcsyiT9+vb/ij5ewxjyeV/dyVhpJ++sHMnrW3C74uwg
	0YZWt19ELft0pOTmz+sihiisBB3nQCynwTDQZ6NC4xix540az1QpjGzhw6i/mYSk0Syt1ow7hUd
	sp1w6QaYs+cZ+l8wSuwFxIBFDnp7qhWRYpCL9I4lmlc5lTMIqlmmpT/m1hNzn06NaxEYb5Xh2z3
	fNgFNX8RQZ87VodIPsBPKPx/hjIOnJJOO5R22EYgP6xB8N6g+W4+a88/3MYUOVHVPQ/kRs5U0au
	5TuioFrN5X57jzBF+ZXNxJdT2CrCuXpAnhvVZMUkne/d9wKMv+94ly1J2iMgtOglyMps1aUCd0C
	hSa+AIExEYdrOJxIO2sP2RAG9rh2mwD4djjZuKXIA5wodm1lgFhCYqARf/ql8wpEwrgHsUfUBtD
	PR5jWUy4p4G/NMruQJanMzxNZkUlR/AFsl2QiNTR7UogbbEnyhXREjYQAJTR77rQZfhV5cn+wyF
	7gX6yUbKV/bk8RVQrhnZMt904ne2OqKejpIBtiCm9SLmi6eU4H6wG6QWcMn/mPWtvauMZh6ZnOE
	Y15s4y9eBVtY4MzT8D7+glPEK0oiNxNNitmo+b3d6lx+K9SDh/FG/tdJEqgePiSH6GVbBu02TL4
	2k2AMandtSERqCvwI16FHF+StywoE0oymgEU/1wnSlnBrdVfPYGimsZfgoU/wMj
X-Received: by 2002:a17:903:390d:b0:2e9:5507:b532 with SMTP id d9443c01a7336-2ee0dc5d126mr124593155ad.43.1794906640821;
        Tue, 17 Nov 2026 01:10:40 -0800 (PST)
Received: from localhost.localdomain (123-243-92-89.static.tpgi.com.au. [123.243.92.89])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2efd7aa8049sm11241175ad.68.2026.11.17.01.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 01:10:40 -0800 (PST)
From: Daniel Wade <danjwade95@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: mark a collapsed mTHP dirty
Date: Tue, 17 Nov 2026 19:40:18 +1030
Message-Id: <20261117091018.63639-1-danjwade95@gmail.com>
X-Mailer: git-send-email 2.39.0.windows.2
In-Reply-To: <dfbf361e-8125-4f8e-9567-65e80996e2d4@kernel.org>
References: <dfbf361e-8125-4f8e-9567-65e80996e2d4@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6107140004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 3mwpja3ikoxo5snqgj5izyyqoj36tahz
X-HE-Tag: 1794906642-814640
X-HE-Meta: U2FsdGVkX1/RKJT9Y5K8EEs9E41KTy+6vxNfow/rOenWf33piNpjUuKEEk1zkauuuXk1FnaW2oPdGsOfVobOJBO6633VYrpQmkqA+zIP3SUpyFneaKWiSgC/34BBFHT0002dgIS5PKTL5bLXDlZuykrNG7jwVnG+0FhaMqUVxd2ZKzz2VgTaU7S3yVt/eEo2J5tTjaeQXkhnGiB7jnnkojXeCCaxxlh0JWUHvKwkjutfbjEycM922eexi3u9y3XfRNUrfzC1or4cOTBTGOlzWanZKHIbP2fc7xnHJtgX/hln5WQWUYFBz6VOMHq8wqb/aLzuwkvc0f2rVyKHFA8j9fx7T8Ee6ceVXZdn+nX+YOdMla1Trpzw5MQ7qS8ZpDP6DGEZdW7gAJMQJxR6x/OdnkUdWp7AhwixboUrp93gDn8jsb5ECdyKqVf6my15+KNvcNOdZf7diD1/lWX0dlqOyLB1jD1d7Ua5FZZzSILJxPa4nEHFW3GXcDfVeUaNqfdSGKhqKFHgFlEoIHkQbneh08LqMdabXeNSEtE+LIezc6eSX0RwmsHnHteYqcFH8K1uC5XHWtq5ntfR0mgWFDLTVw1FRmjg81zi/3LDAc5x+XugjLBl1kJzFt73MjY7a6p3OpCsyUaurhE0ALVmg8or0+u6elaK16hNQjluqSHw1mcBcdbXyg6aPHEmA+e3yVPCv3oHaAHjxrx51vw+rLDyBJRRnKQ+41I640q67XqjvjjnDEd2nXILEreLDB9e6QRiJpdVzeGjfd+1vCjWqhGEIghX9fNCGAQUTRja1c4doxE+9qEvR/ps45h8Q17zFkxlhrTsDnGBQ9urXYupcdFzZsl7oDrEEHXab7mkGLyPzoLS4df0ugEPKJ+9rSmbGGliNAEYr87JC3qr66wqYbB3FJS3IW4skpbNs0eNFmBgBSFsU0z6AyZao6wutm4pYGOFQ+lG5MI45BE7J7yTn9p
 gthf+tG5
 KW2GWkBGWFbAzgbwfVEwYso0FXNiutd7YhSkLYZIduBl/njnzA7uYxW21RK9PmvU/9RLT5MQMafqmx3RQEVpulLnsyLxK8k8KDyDKHsXU6vCZ0eimyKWMUbYCc8/8eKMllx/mSpnSI9/4FoGLZwfdVlDLR70rBTEfj47z19OS7Or9/K+yno+6EW9tI3+lTOofn5HONJtMIPAzzoaFN8lr+FRtmM9UchftYdsSpNLFtzpQCxsVI69xvZuzP2Z4ufzor2vnCbfpuv9tH5p0M9F10/bGW/1xRTDtzyMy0SM3ShRZDX+8Sg0utyeDbjBQYoEAW32bSqsCmNYuTb67/DdyT5tkda1l/MhYiUSW6wbwjLcucrIM/AmawpPPLBqib5mJA+Dn6FfEP6fLYBMRucwnACI2lQz73HFRa2c30LCgpg2gHTl14q5FlnJisg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 17 Nov 2026 09:13:09 +0100
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> I have a different patch on my queue here that fixes this as well I think. Please review.

Yep had a look and yours does fix it.

It's more than soft-dirty though. If the folio gets dropped while
another process still maps it that process reads zeroes, I had 64K of a
child's memory come back wrong. So might need a stable backport.

Dropping mine, yours obsoletes it.

Reviewed-by: Daniel Wade <danjwade95@gmail.com>

