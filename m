Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B626606A33F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=pP49Uczo
Received: by kanga.kvack.org (Postfix)
	id C0DE56B00EF; Tue, 17 Nov 2026 19:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5196B05B0; Tue, 17 Nov 2026 19:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4146B05B2; Tue, 17 Nov 2026 19:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8C8DE6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:06:51 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18AA71A0614
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:06:51 +0000 (UTC)
X-FDA: 85446299022.21.FAB0C5A
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2C9B8140003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:06:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=pP49Uczo;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.170 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794960409;
	b=A7v9LR8jJTCf/A0dNFbtI+hJpwQEBTAVvLG/WRnCKIE3ACX8bXmEUqefgJkF+aafla+7IM
	3t+3m1h+iaru3LOyeNCj34GFFnw7UIG5EVGJkhFtypLQYw5g296qV1ZQf/rERIgU0FuMsW
	DKSfxog57pFIkRYlgNlk8MdYV0J9pFc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=pP49Uczo;
	spf=pass (imf23.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.170 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794960409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFsKUadGG4JNXWjlD0c48hYv79rszfYTM4l79IQ0eAg=;
	b=1PWl7//gwYEFtD223jBV6F38nCp4IgDRykHL6ra9QuH13AgKuSHz1ehbvsl9Rjq4HB3jny
	fFa+/6e7+2Xay+X1kTtizcM0IUD6kNJwexIqMENsx2WTPHPno3X0ts2TIEMs/ds6D7zR22
	tF6tq859vDmQIsXr35a2EV366XhQo+o=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-380b40319bdso773167eec.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794960408; x=1795565208; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EFsKUadGG4JNXWjlD0c48hYv79rszfYTM4l79IQ0eAg=;
        b=pP49Uczo6+r0iZ7vUVRxbRYgpOWw2EYTiUoVANRRbRjhYe8l5wqD0F9G+lyrV1on2Q
         Lco1dTq+9oi+ZLWUqpJIhl9DeQzRkkm2QRSvC5267kfCMGwN0ahGN6hTLkrJRDji66w3
         t4uEKo2KZeJGwmWmvXlOfYa6uiW+ZuazgBvV4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794960408; x=1795565208;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EFsKUadGG4JNXWjlD0c48hYv79rszfYTM4l79IQ0eAg=;
        b=ZE7GtKLmXxoG8PQF3XfaoZ/sYtp+jyhhiTNvtFOCxiK4IZKgQUzuWw7oRWQfiKkFyT
         yPo1Ne6kV0J418Yaa5HFne96SjM5ZITyRZ0PYPP/oUA4ypbQPZN15yYe6iLVplnRYPGp
         XXvv8ct/r5lccNV1xErGtwxR/woBEaP1Fz12agctxcmiQojsKo/BiJJHxx0Gg9pVIqI9
         yV/jEbRnU+u3XT5WQvNDPLWhTkO3vxV0ghsQy2Hbh93S5gZ14VTMn/8yCZknnmzg+COg
         Gt064JEjNiJMeK+rsxflMNLMqMF6NB4DI/XZaC2OmWhyV1aofptmFs/cY1X0oAFhnYey
         MIOg==
X-Forwarded-Encrypted: i=1; AL+hErEbHCZ3HuDyn5fYXpZ+VjpC3WVee7Tqc1Yc6d0wb2c8z1kHIMToXOuSx0uueLm34/fBfz4WQS+41g==@kvack.org
X-Gm-Message-State: APuU4Z+FcQutw0pcqmh3eAch9JRlZLVNp25RtfBieO49QaBMo4hcR5wn
	iKGED9GdEmAqrBM/1q05jBsJKI1We3Ghy2djuLInjwwUNwNV+jOBQ5RGVOseMLmhTAs=
X-Gm-Gg: AZFdTZdF0+7eFMWEkcBMQMrbRc2RrdBJcO5QibKTWsDPJIKZ+5buslAVQbhplS3LQ08
	3kjlziVdZ08w5vTPHyan5yo24/ucQPNGnmK/2YQUkYsgMyMuf3rvO0pduWLZxIwcEAK+Aa33M4D
	3rKmRnSwypqs3amZEbREgJGrsSkIbQr4LnRQP1WudAbAveu4V64lfuWvNm3wpaXI8HaVwAtsm23
	UG91X4EjZFGWgJ04Yicxejtx6O1vqMQncjbiKnBaenFci19bK9n18t5tlMajkwcWEOjBAsQ70ed
	iIxwbdN7buBX+szWhhEG9RHU/tLtz7ngwt3u8wLZsgmHsyT1vM2pSljRjt/CIsiPKynu+hzZSh0
	r9uWESs1POE33nLJiKput92BmYPjdTQSFu0DJEAA2UI+/HwpKwKwhgFNohjG6xOYwYzh7zpjRqq
	yF6Y/aa4yJ1+95HY9kuSC/khXZKo7KzPfpikKlUo1Ra8BNVuoQHT39iSxqF/eCO8c5dh5bNDOdY
	55ZY2EVUOsj6xFSWbyVteJVXMTtXPPiVuGQQbchOnVVLorkp/Ielww0zihnETT3C5LEN46ukzKb
	Ca1/sYal9NIxmOZx18YRgDB9ekZx9hFVcRlpT4KSb3oQ+XAjJKdnW2yd3ehvjPI0RMg9XsYtrro
	n8bHRwR29r8uI1Hl04HnlJlmSbjteYtJGt8V6+UdMXpLdh5bOfXKQ/+tOX8HoH8AAPtyL1fNL76
	BNM7XlK7zOnRoLkOau4HmefN+MRQwtLM3mVQqL9PydrCRUX0E2jp8X1zVICCFlZnUZ
X-Received: by 2002:a05:7301:618b:20b0:380:f32e:d257 with SMTP id 5a478bee46e88-3827f98bff7mr824254eec.13.1794960407817;
        Tue, 17 Nov 2026 16:06:47 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a6800338sm1714896eec.11.2026.11.17.16.06.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:06:47 -0800 (PST)
Date: Tue, 17 Nov 2026 16:06:43 -0800
From: Chris Down <chris@chrisdown.name>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>, Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>, Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/7] KMSAN: Move per-page metadata out of struct page
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avzsE5wGnXji5u6-@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: fn3k5ga4eedjgjir6qy1iwm7srxw1b6t
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2C9B8140003
X-HE-Tag: 1794960409-861130
X-HE-Meta: U2FsdGVkX186wIOVWQTVmkn/7ofQk3VtTISA+YApK07Wzuql/JgytQCKyv5nkCTD6+0Tn8e9OByRSp+6X17CuE1hpVntIxbutT17Fo97rUWlRl+mIK6WqFy0/MCTLE8gF1CXxQoFW4FpnUN2IkSWwlkUfOmNWIENF9X21FzI3qmJ8226zUOi2EM7lhGFY7Oj9m4p4u97u13shmSlqcDxi4ffnKVw0gz1dfmNGnoyPf3U1Uh/NR1Ig3YNMuTHPFx2RKmlPiWfFPldNzCXxKmhPVYdab+kDyhNqGypFWElgfYSIK98TWXOQuGnvpWJHeRrn7P4av72tUbXyiRFvLNcWn7pPEqrm3hgylMxW+2dPFSXZYcDUlYuUil17G5UrLXlNA40YUTftb4OAxhNIggLJe7Kv3SlH5JGC10LLdxrf2F11vfiF0HkMdF8vdqpvf0neEuoqMXp7YiNdau1ker14Uta8grANw8A2KAZG6H1ol3uEUEBcZqJvYqjCg6N4lcyYIOyounmYdevpXawg8plnOGd9KQ9UNrKeXABzqfgYD6L8egzoGRYDtUX4kU7mf60H11I44XW/WhB5xsTlb8StydWiQnMNTIPzD64JeYdiLHVH8eijvzjCK4Dq/qJxN7QshZzGW4MMTxbdn7rTNpNyA6TPUtsjmoEIRASp74bOZcKXwmz9eST/yNUqJry4rQIJT4tXatq8ocERh590UgE9K8PAuHiHVz/Y06bRKJmBwzOt5xg2Q6zRs7XIemAsSaUB2Dzu+pDU9QEi7eH/gcwqERP8D+xFSywbfORFG80RPv+enZ/ohPL9OQhsq9fDoXFi7Mw+ZYhwIWbJJC0PQiaQBxtPuwKim1FZQYPwCgvu7Lsbki7DfoULU37TrhUSI8eGCc3Orfb7GygGz1hTGDuYR/i2h4jBbCpjMOpMMV5DWJsgHQRAkYL8RnJKdnScb/qKGiFsS5+7LnLaZO+Fzn
 q9tacTKP
 4LFtBkyxvfD5cTOdx2KpX6eRw7Fwgi9/MFT25BSxt5n3z0OCVXadJCabOCBrOg9oRZHbxBazqQ9Y+n3+5+lxvR+IqZK4Pn+rUjsl/WapN+sYjhj9CE8mzGKsZU0IuvLYAs/Ja3MWsbdbibZ5R+/BRQrNykaMv2arpAmTeeK0GbvTpAqo5cgC2xg9GVzmE/BCqFGaxRWXJ8qwM8edxRad20AbYNRLsacWG/F1kcye5/t/BJzg09FjEYpABqhmW3IkjhDwffXlkQqhQx0FsaBAZ1XajJyNrzS1UJRP8NxfLnxd1jivlFSquES/cbuPr5hNMZqbq17Denwz3g2DyWahYt2ZTyswEnxzgb+OHS5+tQf1QcsADfLOkFQjfbsQTEkTGOdmYcNCNJZYY2AeHjb3G1PGbRVpUYjQ2OYYOYLTjfW/R/LnQ+oFWSrUR06xn5AxtDSTTTJT11qXSesc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

Thanks! The changes look great, thanks for working on this.

I think patch 5 still has some issues and have replied there, but for patches
1-4, 6, and 7, feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

