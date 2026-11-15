Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B372606A33F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 06:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=v/QWdpMe
Received: by kanga.kvack.org (Postfix)
	id 226236B05B0; Sun, 15 Nov 2026 01:23:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7046B05B1; Sun, 15 Nov 2026 01:23:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D306B05B2; Sun, 15 Nov 2026 01:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C18F36B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 01:23:52 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 410EDA813D
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:23:52 +0000 (UTC)
X-FDA: 85436362704.12.75D296F
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4E69C180003
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 06:23:49 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="v/QWdpMe";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794723829;
	b=w8TmnnvlSVKOHby93FJHoWY2NTsvA3gsNQnj+azvc/v+n4Qtr7zQ0IS/D1g7bq1O7eR3Be
	wYUTpLIs9E6XS613MeA1iJi90W9qAXmB5hmfrq+LSW94nkonI1sXpKJAKOJBMns2Mal33S
	53PDlCNZThPkZ8+2IFo1Ggo9NLz5WGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794723829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJBuCzf0jzkgkRBG/+Qk3pvdihNoLY2pngEX/HqTYv8=;
	b=TpC4CPgB79XgPWvlW8XB3Bw278J4KYBK+C5YJGsrGongmAtPxNlzasHn8TlFZUB3xjK9Cw
	vYzUWpCccLRZmQZ4NRBm5i7rPAbmJChdhRYsdNoyz1tnkm+wOmFS6gEj6HNBdbXuvnYsQx
	4yffdL9OWtKTMqDkd5FVX1A6ciLDzVU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="v/QWdpMe";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 74.125.82.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-3791619605cso4815526eec.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794723828; x=1795328628; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OJBuCzf0jzkgkRBG/+Qk3pvdihNoLY2pngEX/HqTYv8=;
        b=v/QWdpMewyjrF7MCHhJdHRwj+oZR3mreJyUiD63M36MsOcdbd+oLMJLRAVF68kPh2V
         LIzxs/WJ6S3ykj75bzAsUN0WlEgz9t2jYS3uMqHBrFnFSyTnWZDus1XBv3SxWx3JlmM0
         Uqvl7qR6CKrSKYK9O+A63ybMMLMFz/KCWwbvc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794723828; x=1795328628;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OJBuCzf0jzkgkRBG/+Qk3pvdihNoLY2pngEX/HqTYv8=;
        b=i6SETU2xYW+EUtUjyIopUX50Pk196U2OZm8PqunuWwlvErHZCyKUyFHHYLRQA5ZJcm
         2Nth5FcrrSJc+c+izPY4rMxYli1UiHWboVZydVutE2/sMP2kG19ebaZUcO5mjhU09V2D
         H1PWPV+R6c5w5ZYf5ha1CVLWvM0PeAQo0ZX99QCee50aDyM4MyYoZYYbfCGx6byMOfyV
         SxAAv2Hc5dRSul8oal9h8CJJshmEGkC32XXV/1VRiqg6SrUq4OsO1oXUqfEO6Z4PZX7t
         Exl7CsHuuEc0CTCNBQaNexPLZwtqCiO8vLDQQKJAmkXh/VK9jvAUQsbsoysHJv/HsCKZ
         8YJg==
X-Forwarded-Encrypted: i=1; AL+hErF/sf4DuewDZctcHX+HuiAIBHU40BVnyBkX4pCzV6+jvSCWHIGODJZQgPCd+vXy/8xpbflrWFK4Lw==@kvack.org
X-Gm-Message-State: APuU4Z+8MLPXNUygV4sBSaMxHtbiap20xOcBc1We6X9RXWrCGrszNcQ4
	Us3m6cSUirfRY2hF3cBfGuuin6s4c09snpiSDFXGnXUI5zC8JwNjVJPPUPlXdLGwy3A=
X-Gm-Gg: AYBFou18fsaR6ccvH5cfJ2FF2KEc0mAstZwVdPGqs592zkz+cWtWLzjDc8YMoljJ571
	t6fSnIrq3/ih5n8R9m3oLCo9ManT8Qp6gl9IbH2zdFcE/H25AKyT63af6z/uwN03RRNmSKZ0ZvX
	8GlZfLWcv3se1YVh1m6+Hi9Z7hG5vxjhifiNpxpqKFhJ9FEaz4Py+ZB1UnkuPUnapMqilH2fTQ2
	B99RW9pbby3+7mC0SvAKkl7JbFXaXwp9eM7kc3HPZe5GIfehqlAhdtsisdwlvHaW+s2PUF6zVgN
	dzdOCPihxExsFJ2FCew6kW/FHh08qSGOWj4MMIUWkzfBJISUgkGvwB0mpgroBvnVVV0Gd53Rdl1
	7L9N0DCN6dNekmZ0RwV7a64jTx5Oxd/s3WBB3nUJZdaG4OVu47PWOqVA9RsWnBAUT4DPP6P8xpD
	xuGLs6OhkMqYehyZFyVMy4R1qa6Oi+uXwKIK/ELO6xAe19l0fKQ6mSOd8iHpS+yWsHF2LH7TtHM
	Ys21bB2AKlE7u4CKPwYKfCIgNyNk3FpqcFCn7IINRoLg7/QqrP92BxhoXwt6UvfEf3gN+fSROCb
	LdJ5+IzG1D15aWuLZ14Fw3q2zuxOwR5zDBh4inO/6Z0Qu75khFTfsqf4wu8oP+fnwwN8IGoWi3V
	yTD5nl3kUpzzhYTzaj7GUfScxa1uxNglfT39RUgqA2/z9GuqlKhN1akkE7CZfj1SnMPkvKKgjce
	VJM5+XsjWVLo7+n2tX8/xQcwC6hM7TNPbB/wraCeNivM/WQ/MRiKn8Sx6HRoNqgG5wMw==
X-Received: by 2002:a05:7301:f08:b0:376:aa76:6a15 with SMTP id 5a478bee46e88-37967027f1dmr6460112eec.28.1794723828153;
        Sat, 14 Nov 2026 22:23:48 -0800 (PST)
Received: from [172.18.0.2] ([172.56.232.151])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955332a77sm19889556eec.4.2026.11.14.22.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 22:23:47 -0800 (PST)
Date: Sat, 14 Nov 2026 22:23:44 -0800
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
Subject: Re: [PATCH 2/3] mm/page_ext: support early allocation for SPARSEMEM
In-Reply-To: <20261114104150.58424-3-songmuchun@bytedance.com>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
	<20261114104150.58424-3-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261114222344.e65dbc73bf2c9276@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Queue-Id: 4E69C180003
X-Rspamd-Server: rspam12
X-Stat-Signature: sny99tor64p8nrodrid3izucqbooidcd
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794723829-400639
X-HE-Meta: U2FsdGVkX1/zypwzU6O/S7KgGWKUXwv9Kv7w2OGEEX0WWIvY6BXja17MDn9Xvc8N/5M9+Hndgr/dNjsWoOBfh7KZzBQfttHQZJa89dnsTkHAYB1OyjgQqIS+BlX64M1kFqvIpydel6XTL7N3yN19LSKd2rMHhderZk+O7duiU8sY9vS/VZkm9yzMYrPrarLemob5mEy2qXYBPfUkbhLsauJq4Aouvlrgcs+fZ37oSo8lJtLf89vIIedPTspjA2/HmnmIY9/kyJXbxa/zx3OZ7cARffR3Ds0oEg7csWIRVWXbg1sydloQj6rmLOsaqecgFekIQYxoa8RK6Z3njq1+hc9g+jh4GYsenF9i6q/XcorovH229ob6AztQ0J8uo7DXa8JfrrIEuQcFtesaQL6hx4EKIrT4uPSYE68NjEOHWHLzXFNd+tYV6qqTvVzfvuieKX3dF7gAqt3pO/8f3rf44cBwlPegU8LIoeOz+/Bn3d5/Kvz3clH829x1BaFF16a/kI/KaYoiqIR12opdPVJdQCSIzh37XcwtICyeB73ufUQqGTel4pkaWqUk2Lz8pg9KZ5DeQDHz08pAkeiJFKoNdKK9F6TsJD2t6MsfNnd2H5hqOU30YGLrWV1LYL10rQXMbiQoGEf3ruJqldY0JAQlXlZdofmX0cHIaP7WI24lxtOMtiLr7PL1cI8JuJArNsKO4leJ6muAD0Ri+1WJszlA2jmSWffU3zDN9PyEatO+vv4aTgPNdulV+3uO9OayYbU2D0VgMIq8wvXf+9eRcrqlZQzyyrPc/8IdbR0a9shSSJAuFeWBHuxlEnU9AEvVfTGxHyANiCDV438A17devUruhJwJrTI37/Ac1Rg2xA0LkFsuy1qIrNUlf7oKls/uQ3+ZK8VUb/GrJi2wKZa6VZynUaoK6maEO+GKE7jnTv/VGZuZOP0dm/2jMEhXq7IrbiuZgXUnj6C2HzfYV8YjzOg
 zOzibs7m
 HotzMnXlLw06wYedPqEygRJ3jtYMvoifzdv1xxLDIMRXy2a824PZAuKn+bXS+HGm8jmevrd6xWJLce71HToeCQGIfpI8TLM4qq/x4NeHVpkRLMENb5PDafwBHxCeyCaoaOH0tLWBkHcGvdqEYVn2DX/C0WOCNZ11XpSq56QEwcyJFcjHDXp9dcuYPka2Zds2DGCxFVfb05C4J9/Tkoi0yMmyMf/UW7Jm6Yjyc61g4dFtBwIk22Y9lQTnIF9z5xh9XhglaIg+JTyYLyzmVmGiscgXf8fnIFHfVYcn2SC/MEeHeb4FInx/uryBblSjPiHoDSX+iOk1jmZsS8PMCreb00CH7iCBGw+12B3Pip78Og9QnNMbx9PGPLPlQ4Fj1JBRJRnlsRUt328V5x+GXBqh1RbYQ1tp723NI/ZMJodwDAWgCkfXhpMVR7f8LyqhyMNvaroM59MQxZa8ofoFoHUbREedYlgmJQ/1gYKUe2/9jH294ELYIRDqYZEgze8NNqO5y0almMZJjNsA5ynaV7NNO1HIfxZ0vCBSSFf5SkmUkCHcF/1ZaaRLyE3v7Zkbrz+8qfE08mmydmFohGLArKL/tBaTz9XzlXzQYF2twVjA8+NwelQSqVg4qPNA2/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Muchun,

This looks good to me in general, I only have a few small things.

Muchun Song writes:
>-	/*
>-	 * page_owner must be initialized after buddy is ready, and also after
>-	 * slab is ready so that stack_depot_init() works properly
>-	 */
>-	page_ext_init_flatmem_late();

Not a big deal, but this means that on FLATMEM the init callbacks now run
after vmalloc_init() rather than straight after kmem_cache_init(). I can't
see anything that depends on the old place, but FLATMEM isn't what the
patch is about, so it'd be good to say in the changelog that this moves.

>+	if (!slab_is_available()) {
>+		addr = memblock_alloc_try_nid(size, PAGE_SIZE, 0,
>+					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);

Maybe this should pass __pa(MAX_DMA_ADDRESS) as min_addr, like
alloc_node_page_ext() does, so that the tables stay out of ZONE_DMA when
there's room elsewhere?

>+	page = virt_to_page(addr);
>+	if (PageReserved(page)) {
>+		memmap_boot_pages_add(-nr_pages);
>+		kmemleak_free_part_phys(__pa(addr), table_size);
>+		free_reserved_area(addr, addr + table_size, -1, "page_ext");
>+		return;

free_reserved_area() prints "Freeing page_ext memory" when it's given a
name, and this runs once for every section, so offlining a few gigabytes
would put dozens of those in the log. I think it should pass NULL instead.

Did you manage to get this branch to run, by the way? KMSAN is the only
user of need_early, and from a quick check offlining a memory block on a
KMSAN kernel fails with EBUSY, presumably because the metadata pages can't
be migrated, so I couldn't exercise it myself.

Once the changelog and the log message are fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris

