Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16C8606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 00:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=Jj6xFzeY
Received: by kanga.kvack.org (Postfix)
	id 7C8396B05B3; Tue, 17 Nov 2026 19:06:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779426B05B4; Tue, 17 Nov 2026 19:06:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667626B05B5; Tue, 17 Nov 2026 19:06:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E31C6B05B3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:06:55 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7B011C3F49
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:06:54 +0000 (UTC)
X-FDA: 85446299148.06.8BE9301
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id CE756C0004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 00:06:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Jj6xFzeY;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794960413;
	b=JEFVuH2E8WhGQZmxS0Ei8hmq6rVeeCuyPGEMX7dUej9guuVyucIDGhJMKrGQR0zeFu8bdz
	P5ifmee3QbiM3VKEETjTudzCz+NO+MQBL3GXVIGLSTmra/MJqZ7vplgZo+PNz1VLu9xOZa
	77le0Zc3BuYJFKIL0/FO+4X+nWhR6xM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=Jj6xFzeY;
	spf=pass (imf10.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.176 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794960413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whdIwtpmJAdRFtIWUAbtiFqajWsbSsIAg/rpjYImvLo=;
	b=B/FgZIdXk+Eru/ToxVXfnCrf7mi9l+aiNTb1yYbFweBaRbnJQDztxO9z+yyOn/sFzZozGj
	3EUm5d2xuL7zwSh9e2Yvs6icDylw0ix0FK0Kp3/iJahuzUYojCz4p6PSlYRwwLda1712H5
	mZ4VEc+XwGn57tgfbCiu8Vv9HQRccVU=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-381f65e4e4bso767258eec.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794960412; x=1795565212; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=whdIwtpmJAdRFtIWUAbtiFqajWsbSsIAg/rpjYImvLo=;
        b=Jj6xFzeY18HtRxiq+AlTYBqOspwx+8sOncRugQCsQxn91zmlBaZcVJjFZevJZHu7zm
         XGHQP9z2qo4W2HrFKSdRoeAQouVxYWS6t3KOLE+GgbLS1f8zskkLXpoPrFSbLv95nR7p
         UkRQNUhxdYQcNjSRlmvNwmQcKMxwxGMby14rI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794960412; x=1795565212;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=whdIwtpmJAdRFtIWUAbtiFqajWsbSsIAg/rpjYImvLo=;
        b=M+tDgZzhADPRtaT+dvHb/USroAPh8DypmQJIAGVJ2IfUQD6KxOYPBBJJ5RI0xoQYpi
         8r6GVCUlpaYJ2fVgBg+us3J+n5zktxnhGMJgdvtbqvi+IgDxwSWz03bVewYUMeL1bGEV
         mUYpA62HOjusIkU+iZekimGcAp2PJXcE9Ful5fjWKQvwwxft5AQhG7rX/Xi0YDRdiJ9Z
         4b03EETKA9WvJU+YnCbKrgp5umozBI0BycdHd4t0Ug29IxMwrctW/tV5+VJkPw/G9/f1
         NOtQVi5619zwLy9jgvYe/8D0+SBomGuSOkiulhZ6NBxDzZwX+sQQc2ITZtfnBHOQ1/IP
         IU/Q==
X-Forwarded-Encrypted: i=1; AL+hErE/KmvVgiY7TgktG19BaeNRiH+GzTllm5VXcSQHXWgjFQ12RDBAgXnhua3PHYfStYVdL3kjM9xfIQ==@kvack.org
X-Gm-Message-State: APuU4Z+yHn4kO5fOcOLo2u7DgcqyCxBOOmoI65Hi8gHr2JaDloPwSV+M
	4aolZxzIgCq/7vb6jxCxzMx8Pyf9CADs72IbpvEtTIkSQsjJipr6vBKE14cO30Hexdk=
X-Gm-Gg: AZFdTZe4lTLRsbNe0WK2p9BCK+uHeJz7bQFpNK+OAZzRGh9zeR75VPPxMpHGoW+hbP/
	fPaGbltDdZ76F/M7niKaCeZu6599K1x5Sh11KHRDO1vzKxZTkKdgawKtU5iRQLjVivZN5/UYh1M
	8j9z8HHHXYnQBNKLLdpLieW28FBiw9cmH+hQJgSoOFeWQlD70SA1oi8x37OS4biCNzklsTRIcAK
	dm7Aod+YiivHdTjUjupQFi2Z+GdCZlCUaqT1o/LannTQ+1oAOB+cSrpC4nn+dJPzPjvF2Zrow5I
	oD4+iC2sPMPyqcgzTcbz2EidtMDYvZOfduqOtdYWY6AMhIS41eEN75U1+7xAa1ezGq3wJBVatE+
	ccp7QVm5LwTPMZp4RS6JKaCudsEpoVqMK1AqoGazYKaN2o466/6sOkQekfXKvm6TTKNT5k6+8Nq
	ggkpPOSuQ2sgTPjnQtTx7AX/fwCULKZe6ACo0PKSE7PMuQULtvSgi0Dd/3SboDEsCXUCP4HvXUM
	wwLTKATxV1lywETa8vNcKqE6b2xyRFqXPE70z28EGiNdhVun8Rq7srn+8Byn6BVuGk+8aNJSpB5
	YQfCLQsQ3kVHk449Pa5NWfoJSc1BHzgKTnvLDHYiSyLaJRJw5HunnPzI8DfqQF1YT4URumFHbV3
	VXa4YjHo87JqE+VYxiwBEBjh6x373H9dqryM+v3LLJlQ8jiUooG/dswNiZtsi7/PQH2fUZw1luR
	CLVvY7qedKWwX5eZfAPClrLXwjWGceD0SjSFJqvuKiv/NterJJL9Qf6Qbti566Ah7Mxy48EjR5U
	TZuaIAgpRogbQ==
X-Received: by 2002:a05:7300:d210:b0:36d:4135:cd7 with SMTP id 5a478bee46e88-3828083e094mr888033eec.18.1794960411569;
        Tue, 17 Nov 2026 16:06:51 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a63054ddsm1519563eec.4.2026.11.17.16.06.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 16:06:50 -0800 (PST)
Date: Tue, 17 Nov 2026 16:06:47 -0800
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
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
	SPARSEMEM
In-Reply-To: <20261117120627.50601-6-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
	<20261117120627.50601-6-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avzsFxVqO27Vf4Db@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: heaqdejua7qstnse9ijr6g6syqeyxhqq
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE756C0004
X-HE-Tag: 1794960412-546279
X-HE-Meta: U2FsdGVkX19w+Pa+S3OHpR5oMro4ClgixchVTL1S6dqWl6CFvt8JGPHS1PFZPAZmqx6TDhIcRbxSOfVxkq/KE277UhHV/fywA8qDgewWnOBZ1eg+8662f+Lg7hE9lFhcXGVnxKbUr0Zx9AIJiuEb+REC8UzjefLdtnWGKw/DMJN7Hf6Fn8hNMkAPZW12wKpG7NDanI1du+xLUzhb0EuJ/Cwkcw6dS7d4e3F/BxUwH6g4UbU7l71z09Y+kv63K2GgqvJsm2JJOfS3B1ly0CUbGRKWK7csVyW2hncPdOPF66LXxD0j5W46oRtYe/5l0w4A6SwsYtf+ehkF7t0NivvsgWhO1nCm1vl+UPBwxzQ4oXcl7a1fGAkR25nGMv04oIxUaibdqnOxBujR57KhzGrqV1PejiORTxkRFzvAhE5GubOJGcUbOcF4Yw3zO/QqkbHlJRi+AMU6DZC942ijRQlCZWK+/CSVzbT57th33W03n/Zi6vtbU3eOSeFYe+Jmgvtr14NowjAMJGSTOQDYxoSTMgoFC+2g1g9y6opCGNtqdr2ne1JrSUqK7B7GE4IWfo/X0pxQTeO6dmXcqncNjrmWHAHZBY8GYL42xuEiA+Ab/P8Q+MZA9yiz+hADNjuNbXbWP3GQfq9RORlqlBv8A5VJFcD87AhjJq3DeJTGe+BSfi/CcpViykxOh3qwpZW7dODJDbY2CdFpHt3yP3H65b6oie56XWScaEt/jKW6Ui4e6VH4fXpGiWvB81/1NQrim/8zEekHGG2wb+z7St7fewur2wYkyVayjlnMrKCy5I+ApfmS+BvujQd40kwCw2cd1S5xIPoawjHftVwsVY2cz8TkkOkpzeOFz4zPrOBV2a6rozAZ31LW48mzBT4Ej+NabGwV8lwq45Uwl+mJ5SnjPiDhwpkjSbEpoTsQVDeKejDWcXQzxnMZy5NKq8VY5FoP5BmwY2X0GVHTpRARc/mQb6D
 Lqr1sL1T
 7Jsg9LR+OXdDKtFAaD0Ml2R7w7XGjWWxamZIQ/AatgI2UIIlUCSqJQt9lztnCqGCot4jwVEpAcgjFppUHemyTj30yLF11El9bmaNgecpBlxHee3mw3b4zxtEZGFmOv7203lwSuBcebztiYPbU3h89s7WQtdjhwDE1K7fiJSDXtUgvvujVi76wcOUQLM/kVs82JP/wkkbJGGrbnuZEGqZPu201mrOe+zirvT7ta5sB0nXogictYqSvi7x8/1se/Zb1iPq7+pAjsnAvnSeaMmzFy5A8IEEyEIX5lXZwKjs53tgRhfTZmtgsEk0nuPcvCbxVaUp8CkCNDVhngFH5J3mWwwVWE8Dz2ZHqhAZnblv65T0VmJBTNkaQ0+6JrITxA1vs1sWwtSWM2oJg/+M5xM+VxtPCQ8awTpdGy2hUlh5Hepab9YqSRs4tK7ahv8lOxqTR2PJtjxFDEDcNyDxP302eG2ZzAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

Muchun Song writes:
>+	if (!slab_is_available()) {
>+		addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
>+					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);

Hmm, unless I'm mistaken, memblock allocates top-down, and with
movablecore= or kernelcore= the top of each node is ZONE_MOVABLE, so this
puts the page_ext tables there. It looks like that then offlining those
memory blocks would fail with EBUSY because of the reserved pages.

I can see why Mike suggested always using memblock here, but only KMSAN
needs the tables before the buddy allocator is up. So I think this needs
to either go back to using memblock only for clients that need it, as v1
did, or keep these allocations below ZONE_MOVABLE.

Thanks!

Chris

