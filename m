Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B03606A339
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 22:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=R+FAgqMB
Received: by kanga.kvack.org (Postfix)
	id 01D0C6B05B4; Tue, 17 Nov 2026 17:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F876B05B7; Tue, 17 Nov 2026 17:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD78A6B05B8; Tue, 17 Nov 2026 17:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE6D36B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 17:18:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51511A05F1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:18:00 +0000 (UTC)
X-FDA: 85446024720.15.6B9A313
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 615EBC0007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 22:17:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=R+FAgqMB;
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794953878;
	b=MjMSQsSUrLeN8C8I3mer+zYy8rILIZFqfvKIVu/+x9HE00W1+dZD5f94BYfQRCDQgmvL1Y
	d4tGC+d9xvN66J2NMwYAS1bOgm4wun0bTYmRUpgOk6hHszrpHkWZDE18GRwEIPq1+IrVxG
	1cn7CyKprDPWmnn14MEmzgIkW7T9Mbs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=R+FAgqMB;
	spf=pass (imf28.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.173 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794953878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IjjsahCYIJUHZbHsxd03sCHundy4Xa36e/V5rB3U47I=;
	b=TItg2nk24Dkus1We9hBDawrbrCgXqa08G6qCUm+S0Br2PoHN80hifRpFGBoqCa4gXo14qF
	dyHrdbURcze8uskA5JjTdQ2sazqjZ0XqZRIG7Hi7pniq41JGU5TWRmjqjLXCtTgdXmlAFD
	ubRm8FtQO4osAg+3xTnr/zAeEA1BU4k=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-380b40319bdso672769eec.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794953877; x=1795558677; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IjjsahCYIJUHZbHsxd03sCHundy4Xa36e/V5rB3U47I=;
        b=R+FAgqMByBJiWpdSRc82+l+6TPLhdVvYDJ3qG3mycgzyjCNbiolgyD7kcf8XaYG/GZ
         lY82IUZECn2tfhx6RCitbjadT1fKMpl8xURDEbtaU9UhGCiXSng5/8YzcslPAKU6z2ev
         I7Pd0NqFS3L/KX87Pu+CXf5Da0IxZ5oQqLc64=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794953877; x=1795558677;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IjjsahCYIJUHZbHsxd03sCHundy4Xa36e/V5rB3U47I=;
        b=KgjpeMHh6unM+9Fs1nLrkPlvhvr6AvDPmnQdyBxx4/S4IjHaLMGMpav7RB1bJjlRK+
         3Vmi4Uu5z6C1xDgCM6N8mIaO7Ipy0XuyILGOvZOJR8yAVr5c4zztqGd3vxUk573p11Bz
         1GvucwyeHC1hS/ZtejlSCvd0FbHI/kvcMPBdASp2skKQdpkgLvIfIIdNmxPUGK2r7k0I
         A3AbfLF8iKiE87KtFdKopxBQ4MHiFYbedA+EYkkkdvTHDj2yignG/spCcCITNwUFxYN9
         yAVFueavf/KlLjbJJqLhVNIO8vQ+VIlPmVhF2PvQ4zPO5eHNLeU8dceceScBDHfFdakO
         fvjQ==
X-Forwarded-Encrypted: i=1; AL+hErE9mdOG/VziohqkpBbK3lR/cBO+AqpGx06FkPLWkjoTbXCxh3BWcI6pHFu0ulBnKUXOmvGgOSfGbw==@kvack.org
X-Gm-Message-State: APuU4Z+bm11W54FIFph15KznHJGBwtJ2dopzJR+i0+cmUddXGP4O9aB5
	eHuiITGHvq91PGZd4p70Mdm+UoJY3BXl333a1vFmYSFc1XQx7wKA4Jlh8ftrKzI9t3k=
X-Gm-Gg: AZFdTZfJl/VY8dduYiQdb6ZRkuCfK2SmZj6dCRX2CVa0TiQ3PcwFxzz6way0zKN1qmH
	baiXOWd+ONBAUEMFiCbJqxrXvrIg5kx6H7jRLviL8BoOj5trkW/3AwPVLVCGaF1XT43KDHnbwFS
	UJCJ/CSIbpamjLB9g8oH/XfvEAwnij6I5Vk716QIX9oVmK4yXhqqr67Sf5QEeBC7/pOtCJZJgnx
	KCiPy7vYdwv5wePEMrKC14ksuzK/yWFPf1rSFKPoeTuiJthWwdhTqsUnYTxrmiFQhxE+ecn1dq5
	Cs4AY1qyLer4SIXXkIiomqZ4TtxX5L8ATcvyyyq4pd49iywassqAImxQU8Q1wfyclgIPNsyJftF
	fm/s4J+P9ifMxNi0ghkvgYS7fIchGM+rumuaP0D6bvYZ69RL36zYFCw9Z8qrWBnGoHGwDbVoHk4
	x14qGcW4Y2JON9tzGxhg3tIleC1vWmKYEPkTuuwWeAeDM3m9oxx0jSJ0DE3AzzjmijgjmaVwDQH
	zVd/1kWmn6MF9iWM565SGAF/SToj5AWYbmnaMkS5TFmj+mdtCNjT+AEuwvcXrVOm9AWkz/5xWwZ
	r5aQHP1vzXcPpUh8KgjaUFm2RGsv1+N0bLCx/xNfZpI7NcsSIsTE+d0RlEJYcJh+Nn2A7+OOdVX
	I/Jd3RjG6wmAEGZxdAzVkI0hzmZmaH43ZonJR6aCghZZZ4wb0bkLQcSP5mAuvNq0DnvBs+ZYBhL
	N2AuCL5gMfKHqLwWxDxT5hP5mQoWIHvgSQG7kJ4zfusgWwzepBM5CHp/Z6KVPDiNKJ
X-Received: by 2002:a05:7300:8a9f:b0:36c:9fa4:dc5b with SMTP id 5a478bee46e88-38280b39afdmr671672eec.23.1794953876891;
        Tue, 17 Nov 2026 14:17:56 -0800 (PST)
Received: from [172.20.0.2] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a72e52easm810151eec.17.2026.11.17.14.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 14:17:56 -0800 (PST)
Date: Tue, 17 Nov 2026 14:17:53 -0800
From: Chris Down <chris@chrisdown.name>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH 0/2] mm: memcg: fix memory.high allocator throttling
In-Reply-To: <cover.1794902513.git.zhuhui@kylinos.cn>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avzSkT9-jsCrMoeX@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 615EBC0007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: qokk1ztxrzewfrqz1s8ukjmfb4ezzhqa
X-Rspam-User: 
X-HE-Tag: 1794953878-817232
X-HE-Meta: U2FsdGVkX18OqywrLoIf9Gu+6ZDjBOc2ipRPxhb0jBaIziOFUBpHg9+Q4M6MhrGfyFgSlY1LHWnQAvVp8AGDcTxoIUM0WWCvNPZfsXY4JqGXLlcj7Lp+q2unnpLYdC4oxBxIbwxMzaGQPsKqtFLAMHn3qFQPcnOJ67d8JePei6lOqwytbuL23q0JqSqK5Jc3ENaFuKYn+kV0g3blZkXBeK9CPloqnZlkcgRbcnEqWGSQdH5GLvoc3V1zLq3nT5j5EZMLvlRn1W9+9yNWL4jw6XZjn7sqyWYPYrn4rGJKx+ok98RYfGdygEjUL8X6ID3siCcxFQ51t1o1m6ruF7lG2FlLYsz4lQX28+TiKz/Ci+cQBtADdrapCkRdM0rSaHkWoFjjn+NPSk43dJzH/H9SG0IyzFo/Bb44pSm3Dldw5srr1LRE0Pkh/NYgZFhlbVh+oiQhOfxDzkojEPEJmzBav7rGO8866xBDKb8c439es2Wf9vvFZtRI9Ypd1GHV8F3hhtNANY/BgklAGiiL6HwfnDNOR5TvWpDdpx79mIp6Le5bfW5AEYc9j1hcgAOaDqVkxuELApfDRReyPJ55fUyNVyj2sG+7QYdcjEPxYhvSom4Xy/Y7uRRXKS4C6ADKxe1azq5o7T57RDDzms2hd4BMxKcnNPpfRtz7oFX74qe7xe2SvZgeKD1hThxKpr5YTla68g50PEUQ9sxqoBqOlsIJlJmQXgMNo56XFM5yqdhy8mg3J6niAH20VF/VOHntQSVnmQ4L/ZnsQC4+I+pRuFLcdxwy1eo+RGrO9tGahIsBkcNmXe9A3Khes69vAy77GdW/ktDKVtOjLbd1reUjoreK4gAAfaqBNUzLr2ObqKOBARqUJCXmkx1tUkA6O8lE6iaQTDbVYrJQUWHU2EI99rm4jfWFcPXiqt3exajsyBsurqmnboOcyBxWyFOY1GOs3lKXM8XG9l7Hs9e3xLAeMDT
 wgjr67Jz
 6rulMvloJPCYrVsKrX1ca4om7ezY1S80Id6djvukmXi0dQHYYaFl4cAvKG4eM49F0fh9kI+oZPNkxO1+mvpQsqFuKN4Iqhrl9NcGk9WuV6dCowW0eOqCNAAVB8DcUV8OkOfB00acqqn/iO/cEqhKyymwsr+nsO5czHKVfv/K9q0EmHco9jmSmZssHLwWmhxXS03M6BHKGOK4jo/o3/7nJ1VZZbNtjDfhIuw9AWHCTCbxNYqkac04YcakACVqHlGbDpNp8i56RWyCk/E93GSijeSMm51KP4ZPeu8seDvQfuSVVHGz0BJl0c14En6gi7SGeGAJ9Mkr31EUM1Me9I+Lozwm4UV21O7Ieyf9sSlzEu8TY23U8CETmWQBkKlVvUTnSCtqGjUOcZEYCruZVoWHbqL4BnEXcpXkdWvNmtBXBOk0llySbISUgbaVuj+A1nE9sjnsTK84KPK87T5efDUIMJpzur14+6aDgH3kf/yJuRrfvm0qXhS8mIWadjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Hui,

Thanks for fixing these, I've verified that these fix the issues
reported.

That said, Zhang Jiao sent a fix for the same two problems a few weeks
ago, and Johannes thought the overage cap there was a bit of a magic
value, which we have plenty of in mm already, and I agree we shouldn't
add more [1].

Could you please coordinate so we don't have two patchsets doing the
same thing?

Chris

[1] https://lore.kernel.org/all/auNrakxaET8qkuAn@cmpxchg.org/

