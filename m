Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327D560A3804
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=NlCU9cWV
Received: by kanga.kvack.org (Postfix)
	id 3F81A6B05BB; Tue, 10 Nov 2026 23:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A9406B05BC; Tue, 10 Nov 2026 23:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5986B05BD; Tue, 10 Nov 2026 23:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03C8B6B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:27:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 874CC801E2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:27:02 +0000 (UTC)
X-FDA: 85421553084.18.6D4C087
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id AC411100002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:27:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NlCU9cWV;
	spf=pass (imf14.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794371220;
	b=67yhYCeolr/rq8Aocx57qt42SJd6NY9Vd7V5tvbFcDQW9fDWBRpjs4fpZK4yNrysEfnk4u
	TQll7ftFJws5QNtOrA+zc60fGyw5DsvJeageiP6ZmCYbXmarGUAuAjusk+RzGxfX2hdsfS
	y5lxYy6l4As6B/t5RTqr1vwAJtqMHNU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=NlCU9cWV;
	spf=pass (imf14.hostedemail.com: domain of gopalmalaviya53@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=gopalmalaviya53@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794371220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1pY2f18oXgCvPBL0khHJZDCXmLtKWWVDmpFe3/LPR8=;
	b=J2QNvoApT4HniAAsKP8e5Qlp8xMfl37L5eiuz96FAvEQ3h3WSglHkLm29iGINvpYE9bSc6
	+/U5afal7dBm2Mss57mu8cUXjXXF4RYbxhe3n22MwcPmLInXLs8Jvs3qoTO4cWkfTB8rj4
	MSw3P5qPDGZoMYoddaVYgF/O5USIUKI=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1b3acec6677so4341231c88.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794371219; x=1794976019; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y1pY2f18oXgCvPBL0khHJZDCXmLtKWWVDmpFe3/LPR8=;
        b=NlCU9cWV9SaHQWyNFO9gOi2ROoS1WauKqBOo9zynaOQdWwHpnhh9McPVtx8Ptjoyr+
         Y9CNojvTsdUvX9wwpsOOi0DEJrkFVu8Yuxct+hjgaqYwM3Z/eETssg1d3y+U7R8Ns2K7
         /vdQD48BxwkZMHjWhBS7/ne+wisBbN4KtMCyd0KypG8anOYRyFH6K5BF21zxWo+caGOG
         BbQsDGFtH6Jlw1pfKmqHkvYGh0q7GsDGjD8UDv77shkUSNR+O7NQmh11cMHax1E/+HRU
         BvkUejiIyAnx9SauatYi8CLPb7vFb/WhWdiBM4V6iAT84HimzwsqPqJFWL5aPd0uD70z
         51pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794371219; x=1794976019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y1pY2f18oXgCvPBL0khHJZDCXmLtKWWVDmpFe3/LPR8=;
        b=Kni9XT6sfTL1roiU+0EED5qVYL4x7Qg4AbinQdTi6vCfGqjVUFA7E1rdm+KRnrAaER
         i+qMaMBB7n9umtHD1pqBgdDPSKvURib/syeFtA33KIuURdf+bbbDPSET8sa6czrgBYnm
         eB6LBd5xAds9Wp+gA1U8t2JMW7yJOLo0lXvR36fjIr26IUvutSeNQIKSFTIDYRImBgm1
         yWXZ/WOvb/Y4tuKNkWvlC/HoU4Jx/JUaGI7DqjZJFkPY/b9EUFEjQQEm1UEa9bPMCfbD
         JQJMb6FziQMPWb2VyqR95LzdECm/BEpQUSKaL49CmQc+xjTg2M7onZU9gFbCVntTVmm8
         0Z4g==
X-Forwarded-Encrypted: i=1; AL+hErGcsYJecwhtEkIKlS2nVhLR+kZPynwebJ2xlNCYKp/yMcBqHN3G1zCMRJ+sFHTquQWWxNakh56t6g==@kvack.org
X-Gm-Message-State: APuU4Z8+MQmlDOCwLSkgYxwtVpBAjiaO5JdF2nt2uFBejVMk1Y7AaL+6
	h9ZlAuTPvw6BZu+opKCnBff0EsCa7YwUzM2FD+jxdueyDr7WxKZ30v2z
X-Gm-Gg: AYBFou0E6bcbaeDL8SRPYZu7HaO8jWFhGwhNjF4RJTYp+MYUBXZGvbo+cKEDfIk3iXT
	n7EUFyFj7dBbEzL25rsfapMQ3yd1TlANSwVOPs5tsRQ+i8tmPTgGvjsPJFPKLx+Dc0nRsu0mAQI
	COlfyKdnlLII1GtX3mHovJR4GPKuclWD+EdmKdECFgdXuuJANuHNo57Obtrw8OTYPX4ylmihqTp
	dq6VgXG3vVDDTC8kyhdNuFu1p2fxAhBBX9TE26ovO4HEbHnZAi3t0mLPfFiVGoldtsCsy+Ov1q3
	SzPnQfoEtaq+zu/eutzPGMdhx4bpbpRHaNGeAgt2/EwEMlzd3lUl07rO1CLpEtKqXnwKQWBB50J
	kcChwvyFjO7agwQXO1jmxy3HKVb5v1TqyEvqyE9Q4RKkKLgpdgnqHut3MUU0Hli1anYXp0HA1ay
	odoBlzSB/SqNj1WFNKzGzLMl2NvjGu2Aw1JBBw1sC9JoHi6HWAgxCjxun4S2xCARf5JVeCJDV+b
	dmZL+NkU/FEkfJwQg5mXWE77VEdmrpKUTHx9uKv851tlLp/w1CcIJlK0noHrPocuaEnTMaYftAS
	jR4PRP1DRQA3g36fHIl/HgcB/DTDGaf5XEg/6pBxpnEGf5X2CX+D87h2L/aknYKfOQ==
X-Received: by 2002:a05:701b:2302:b0:1b3:a26b:8b97 with SMTP id a92af1059eb24-1b3c0353171mr1289026c88.41.1794371219170;
        Tue, 10 Nov 2026 20:26:59 -0800 (PST)
Received: from LAPTOP-KD1TH5BD.tail375eb4.ts.net ([47.11.96.168])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3b5890e04sm11563252c88.2.2026.11.10.20.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:26:58 -0800 (PST)
From: Gopal Malaviya <gopalmalaviya53@gmail.com>
To: jack@suse.cz
Cc: akpm@linux-foundation.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev,
	fujunjie1@qq.com,
	vishal.moola@gmail.com,
	roman.gushchin@linux.dev,
	tracekotae@gmail.com
Subject: Re: [PATCH] mm/filemap: restart mmap readahead on sequential faults after many misses
Date: Wed, 11 Nov 2026 04:26:39 +0000
Message-ID: <20261111042639.191997-1-gopalmalaviya53@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <jwg2p4bjzkacnx6fkifkb5jbe7ah6btuecpcpulbkym6e23v6x@mh35p6yafmqi>
References: <20261105192517.228523-1-tracekotae@gmail.com> <20261109091444.128521-1-gopalmalaviya53@gmail.com> <jwg2p4bjzkacnx6fkifkb5jbe7ah6btuecpcpulbkym6e23v6x@mh35p6yafmqi>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC411100002
X-Stat-Signature: w8rxehgkirhq919ri5gaxjjyaxpgwg93
X-Rspam-User: 
X-HE-Tag: 1794371220-498961
X-HE-Meta: U2FsdGVkX19AFbwE4MX90NlwkeblHZc3VNL9eZ1FE4IkUqofgsw4+VGTDCvJ5zLI5lWlg2VqWlmP/x2uCxX7XHbkJmTUMvF0WzQVioByZlbj8x+7ieZwbDrXESjGrzfir2sW0jgs5mMV28Un/MfWu8dzKYS6AV9PpR+56/UYDT7m3B9mbHNt7zmRL+7I3cxjtHGUsWKlTUqf8Tgyakb+x+NUYf+saW1NCvTr+qcDrmreUTxLCZLa3xV+dsXgw9zZQL0xpGNzgU6mhnczfV8LL8sG3rGMGHn9FETBULpBPfDxFyglK69kIuQg3WpDgQ2LjBPjCObn4IbSPQwOu9ikA7WBbpewwX0FjngeZ/xltgGSBME+5iIGMUwpyHkcL6JrDmcbVpDrtTfr2cVLg9Aon4g44whJHBraOEz5VU+VFelb/dns5ZzadzUQhQUQaBiTfK0cjyZI1PsQJMdTvk4/QHVMe7FyXhiR3IJPetsEpukL8WcUzsxoqCyqmJOM48QWMy1uTyvDkqecK7+btEJk1CF/nXZMH7sKVDUjPf+TU+5Yh7Bx9BhTXwX5+43hp+w+P71b6KzSm4zlSeLmL3hKT3BK9tp7Aa5IL9mh0+bvsPM4ygf93weHx7K7LK9JRqM5ARaX3+463x7kz2tBqmFgBTFyzEuKMLXfmp82je3ijmwgfOYkkKZRrFHnOib3Xs51p2cXvyrFnGDya4Sq54mbNT3ZXt30Gpq1n08jL5DG3NhP4cYeE73a8SvgPmo1a2vi9tyrn1BHfzvlYuF6ZmhxGBLWFn16uwU5Wx8IOVVuOz1yRxereoG6mi8o5HHvKmWN+DGia4JMVNXP9UaP5/+qgbQX2V1pXj+tf/CnOMB+A/bAteopdLhFbCH7FVbUUgb/7cDyjK8Y8/XGTWldFLzw+Gw18uAgYxZZmOu9oOrEXSnSiYt0bSOp1xlfBzTdUYZQDHVT9YLycEKfBPYS1J+
 1pQ9cIuX
 armE2U17rCCfdurgXMRI8VmQuEsNhXE+R+7CAM0WKrMCseuooKfIAAq+97SEY292mtxGw84h1HueIoTgEUWfceZ/A/Y6Ah00dfnEJaa6deTGEx82pKyiqlK9lJAC70sPvY47ppeMPMzUAOU60vga3LO0s0yp/X87gFF2BGGQ8uJcAbiiCXAZGTP8GLLh9ZwVdcIUXny0ABCw6uxhdqqNlLVhsn4T7NqXtkZI2fky7BCovQKIZQ89eIBMQ+JN85yaG6tiMWyb3tOq9JJVrfT1SlHJZgeMc9/EII1Hq1P+M89fAElF4zCcEqHS34zdhax/CzfQlJdaol7nWPJu3TZ2jG5kIE8/gxA0GuupnYMOXbbiQxE24lNCjEOrXnFnAyrCDbj4ghz+yVWK7IM5chrHmxoWNfef2PkyaFnm73kQDblqk0GNKtY6wiBXiFAVkWkQv5azJfUI4IkQVm9pjnCgef7igQOliTo9v6Ecnwe6H1oqypQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 14:53:14, Jan Kara wrote:
> I think this [1] looks like a nicer solution to your problem.
>
> [1] https://lore.kernel.org/all/20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se/

Agreed, it is simpler. I am dropping this patch, so the v2 I mentioned
will not come. I have tested Alireza's patch with the reproducer from
Trace's report and replied in his thread.

