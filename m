Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBC4606A884
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=d8jdFWfS
Received: by kanga.kvack.org (Postfix)
	id 3ACAD6B00EF; Sun, 15 Nov 2026 01:23:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D486B05B0; Sun, 15 Nov 2026 01:23:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2739F6B05B1; Sun, 15 Nov 2026 01:23:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F22BC6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:23:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7CF5E1A0589
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:23:49 +0000 (UTC)
X-FDA: 85436362578.02.20C569B
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9824F180003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:23:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=d8jdFWfS;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794723826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
	b=GkU0Xq5j0uyqCNT45+/2MpmYomNGQbPUnnUwl0RERtktPFmliGusMn4TiSF1EekMJlt5Rf
	N52OCsE+5P9TmP0afqLfiCdGcNkSw5svjIhj7RP3CUgefNLBo8Tn+5cDeNpJW7kI231Yj0
	+2/RNEbZ1s4xFf9y6z2y1BcAEydBJw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794723826;
	b=kMNZpaQ8XEg5WE7osLp/tkPtIudP7rDvBCnTFw6BAHH6k6LYE9IoCaubxKyx6KpeAbkECY
	uaXfbXPLKD5kJ/VRJIoVx+2J9170TyN2AsTSmK0nl/W/ZrowlNsBJh5IvU5BxwJ/9AaBBh
	ZKRP6JsDelodJ2f6ORGFtlTrIOuI3yU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=d8jdFWfS;
	spf=pass (imf06.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.175 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3282db206d3so7121967eec.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794723825; x=1795328625; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=d8jdFWfSptl3aY1XDv/8BtGbJFNItgSB93Go4wY1dXu9PGyFZhZca7baqhYWkFKEfK
         Hrwh3+vcb4ivftdeIy3jWxoqiNCoZb1NZj3j/Ag4Ps0SrKKNux4wBO/EUZ/Gw8AnFO8x
         a9t6kGvipKp0Jw56wESXHcokU9zLky7jSlxeM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794723825; x=1795328625;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f+UcsNuMg4Yueaqy8xslzDAXYJR5HIy/+gngqmLcoZw=;
        b=ZaoKTevEN8PcnGDY5ucSPma0z1+j/AHbXqD3NetqJvNRqR1MhGxEPX/0HtfmB2Ai6N
         Qt8WEXg2A8IO3nSN2r1nOFKn+xYkmksgLNBjQ49gPd8+LXms9j9vWqWtHoGCIA54QNMi
         clgKBFf9CjRu6DYyNtOekhxYRetD/EkSVedXTD7/XbFddZv48EaQZslnUlKlLbyHO6VA
         KyMpRQEI3xAW8Zxpox2AZ+Vea9017YzbiKhbcCEdZ+uC6t8tvOiiJHSVBnNX0YSLKw25
         VYXb0EqAR9v/3SYgD0vcFdw2w1MGlF6eyr6dezWA5yA0nmb9arJdoCeJ7f6xxx0zDT+8
         1LFw==
X-Forwarded-Encrypted: i=1; AL+hErF79a4w6jfHoxU4hKmy/XmJIAP0OZ4vAggUpyL+u+KHnSc4pj1OfWkwbVo7ZvkekVP+nI59P1ZEMg==@kvack.org
X-Gm-Message-State: APuU4Z+8X4gPvkSRHBkZH2Nsh8ZLQb3cyt/+HkgbJsbbA+q4bTS6aZw8
	bAzjsT4gKvkGYjBJCIVg72xlU6PYtIhAitctR88VfvkRkNltxvf2HC2rKgRSJ45gXBc=
X-Gm-Gg: AYBFou0qUmAC2DFjfCTQ6MHvuf8fWs1tEz9vJQaRz3TvWca4g9Yc2h5t2O65OFodEOX
	2B9TY0OW84gn/Tvs4slwYBDCjWBPpesC7wPLvnCbuAd8wU5N4z9mBcfi0jLMjwD06XVC5f37WXx
	QVOEeGaqPT/hc+WRNpTP0i81o1WE/M/dZDZY9NqXtihYQ+0w9KoMhd+OCf+MwGV0v0rlsvyr09n
	zZbVmn6CDzaU1EPgSM/ektSjSzAHzLZHnp2PM8BWugEGzviOXse4Vj9jVbASofGao75Xv9UjC1S
	x8bmVJfugIc24YGt7K4M0sBCQmDYzncNDrFhCTM27yCbKiIT9i80agM72Sxv2H03ykYY5rVZ0Tj
	6o0NzpQ6uyQWkjEEtTpx3AknGMSoP9L1tmw3G6rD0uz2u2oM1+A8heeUGKTjJ+S1+rUg0s2ield
	Oq6DnJx5fgt2qUEios7H6cHt9Oh8S/Hbyoo29RdZ52DWQ6dRAuJs2xsqnkeX33GiCbo5JkPXfX6
	qsDTVDR9W7RuUw4sr2kVRN4ehn1dq5+nQUrJvRRSOXrJD6k0TcU/8NaSkZST+q2fGo91fJkzvxh
	uiLwO1zkWldOiBk8MbvpbObP3jjxF0SQOv0a1n7MWx8WWs/xTsNqt/A6kPT7bP29hRdMV7TZ5b0
	CtZ4HEv4f/oipjaCGqe/bx+2gVydZN4m+rAC4mhKry0Wtp3HJbrZic8vWOowOX9Pbt9LDYb4I/Q
	C+qgTxmQhkTr1CgcoapMUs+jS6vubKLHNGhmF9Io0gzaSwJDGTvY1rIlQZ1DfO1JaG
X-Received: by 2002:a05:7300:269b:b0:37a:cafa:6d78 with SMTP id 5a478bee46e88-37acafac54amr4684055eec.33.1794723825291;
        Sat, 14 Nov 2026 22:23:45 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379558231eesm21719807eec.12.2026.11.14.22.23.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 22:23:44 -0800 (PST)
Date: Sat, 14 Nov 2026 22:23:40 -0800
From: Chris Down <chris@chrisdown.name>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>, Sang-Heon Jeon <ekffu200098@gmail.com>,
	Mostafa Saleh <smostafa@google.com>, Ketan <ketan.kishore@oss.qualcomm.com>,
	Usama Arif <usama.arif@bytedance.com>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/3] kmsan: encapsulate per-page metadata access
In-Reply-To: <20261114104150.58424-2-songmuchun@bytedance.com>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
	<20261114104150.58424-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114222340.8fe68e5bf755c1f7@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9824F180003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 41pu6b519zftohchiwanctjy8bok9k7d
X-Rspam-User: 
X-HE-Tag: 1794723826-454584
X-HE-Meta: U2FsdGVkX18Bov8tQpVLSbQYT6kq2VKAzYgaaNEtJdv2UkoA7K5o83sWT8y4kw9uwcarHpugRyQkL3fjVTGBByYZwXy+L7vVG+ArlFix0Pdg26oVjlMW69elxb+4P0sqs+xRHXJ5+sFrCiLw7JZybnEC/rO/q3V1Jtl8AvhXh/xv5H5Dsch9zdP0cDZX8re1ixiiIwJmZ78+Cv8GBxVyZFgeBxHpKT/NrfGWIbMeM3vSahEQU+KOZQFUoLpUVBU9Z5o4KGTBE38Hwc/eam7rfWh6MsLQtG4DW7nDYJDuFu57lMZF61n3isPhhRBUnX/nvLfzWu+iE8rJZxylIMUuQlH55jEDJELkwUgTNh5AdENYTiW+XjxBqQj7xdNaiXrW+GEQytpVRvwY4QbHa+393zWfLMi2m63MoGtvGBJXbKeIl6gOQTf1M4KwUjJ9djtAvFGko258CIylWdTiYpxfdoROTAvmhuYBDhJISY9jvLJNyOMFKzgjBxCwjJ2DVHnXBOu2pIpCWU4uAsf3Dp6Se0IgxlwKO766etr7pVq0WdNTBr8Jf6rFNoYZGdfpD/LXuwuRPr1GIZhgUOyWaMAcjIdiBXdIZjJz8GyonpTaIicCHtQcbZAxvyijeb844upOLKsrst7yGBOcboVt3WkemYRD/S2L8lBrykj62/dcfKNtEfTNLC0E8GHTWb/aFoHNbdvCsrREMvG94FMnTy7iBRy8O6+hzK4X6zDtK0Tt94ltL+R5hiIyQ23G1rjpoIJM3tgfPbliyptQmao0IAugZN4oC2IeVWVDP7Iv4Nbo59atQ3TLIqdmWuRDnVlj1NX0ON1fy7QSWdbCurKxiPwAyqnwzHRLAQVEomgMtjOV1vEumZ/WQYjQ9jn+xQmdaywMHZASsqfZq4IJGHvkLmiibQ65wUsN0DYwOxEcGrZi50iesWZFh7GxQe5+KYGV5jgWsjAnhAOBiczYSjYgCBr
 i0j68FLi
 y2gbVnM6KXPWFHCkogmFnXVGev7t4voo0lxl/LcgEp9/3bUUonLRgmV90woSwqdd8Gd77sq78TtYemSU8Clt/bLY12KYIHVWRmn2nAXIjnYf3P8gXh9WZqF1uZkHcAa1YY152RuuoI3izzAPcNPywmnTCp5sCQGpBWIk3BxcstHpip60RrVUedNUwb3GpmsGBg8AK9dzCE6b6Hs+SmAxYj3I/5RFnQBruSS3miQCulaJ1UlNSn1heeIvcRdCNdEAJrI7jEcdjQIWJOiFlBNs9EKm6zGkgHjbfZCriGgBlELo7FdIgHL0gsqUz+iCFhOfikGYD/5jP9LhosDdYHQasRzdzjJItwYentNZIqk38wPj8tEvqINnL8afbgJzMxWH7DGpLpVAKXdc2P5szz6zxTINMbjuAsKHhikfh4dfi0r/tyXJKy3DhLg4RtXtdAE/vDjBmtCKh1AIteFS8faX379s04wKiCQMtaxub3Dsxmzfqqze/K/9YOFIHwTuF9kmgThriJwY01ZZQ32iCpiiLLksAYzmfol0dLO+ROPhQ5VS8JXoD6kPkXIMW6Un6OTuakoAlR2ycjxdvAfk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Chris Down <chris@chrisdown.name>

