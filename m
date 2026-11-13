Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 134F6606A880
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=JNT8zodY
Received: by kanga.kvack.org (Postfix)
	id 144D76B05FD; Fri, 13 Nov 2026 00:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6696B0613; Fri, 13 Nov 2026 00:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFFD66B062E; Fri, 13 Nov 2026 00:08:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF79A6B05FD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:08:31 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42F921C3F53
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:08:31 +0000 (UTC)
X-FDA: 85428915222.21.256A8DF
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5A73640002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:08:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JNT8zodY;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794546509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmFjzwEPLh1WnvAWN35VH6q9XGy6Q88rO7whGWc3zyY=;
	b=BX6MloixSywBv+Am/A1ihfbgLetIWigX05E2ybeA0Wahoi6Z9cKbJHOl+e/WbE7QfnARKY
	/bGHdpISAVDUg3xRdrFzgvvrDMWXBaAoqdKExmr0NJpysd9w2XjcmL5XmHeD4o3tiQdcPO
	Hp/rvRZtPrKcY+dIRZbjO5mr9317x1w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794546509;
	b=vRWBDHrWLlz74dRIci2UaWaBwjzs74Gk9Nl96RTN8whUCVI09lqvFoBLUBtEq1DrKVkdcr
	evgri22e19NvpsYjV8+fDe8Cxh+lKHeprsrbgyXACsrAU6whvASsPx0tG8D5S6OCip5I8k
	a5QoeWgxF3gVnlrnpx3dAf8YMNmRuR0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JNT8zodY;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f3c616c84so79298885a.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794546508; x=1795151308; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LmFjzwEPLh1WnvAWN35VH6q9XGy6Q88rO7whGWc3zyY=;
        b=JNT8zodYKpGUKTtx2fvoKVloi5BS1ZcTcMbKAEREGsx4wUrSagwrfGblrmb3KyvWN6
         EnGQnQRrVU+S8GyQ/Zf9SmnJnwxf7gYWLJ5DHLTlyATRoJjIiMQI03yEZoWqCaL+q2bv
         Xsa8dk/v02i3nCesl/I3HAkc8oo8zEqbcHU62sWvut8lKAgkCfp4uFoEd+EcUqupBNkP
         scAJGstCMWL9G8RHP7FU9j8SUP+6CT+I1w+81wVRH586hNgaW/kl/1kBxMvWvRp9Z7dW
         mbS6sPUG6eSWW/P9Ee/b9exGTicu2ds8sPD4rtTs/3tJr+9XS9xqDFkJTo6iPe4T6ot5
         gM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794546508; x=1795151308;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LmFjzwEPLh1WnvAWN35VH6q9XGy6Q88rO7whGWc3zyY=;
        b=03moAN/Y/Rmn5ZhnGoOnLPsGx3OdCaPne+ruYyERbyxyDELDLrNRuNA8/uoWPKegTO
         1sdD5+0kDguX5zBoYa8uk1UKgSqiORk1EeAi4QiIjz5WSX5/ADa1Nbs7D/YuIaQ/Z6YA
         2KZFPQm2ZWhdEaG7RDv4IEvoP2chQha8z6mpDlZPg0d50fyfhYe3UMazgtRBTBnmcFLl
         nTvEiTPF8YfUZ8MATwuCjTKUtzeBX9pel+gM4848GYf6sNYmfEnwmgg6a4th6nzHAxL5
         WKkNxCoqYnOaKE+qeI7BZKY/oz+BEUlQhMCErBxlS+5i1NQ4/txQBBdkU6jdYz9/jIHq
         0uWA==
X-Forwarded-Encrypted: i=1; AL+hErGSnSMoM4xLMwPNR2cZ6XdkT7b3NO3iT9cqeJMxDMQqw67ZTN1IvFzKMhPLvY2rnygn7moPJvFscg==@kvack.org
X-Gm-Message-State: APuU4Z/23+mi0OemmbVyq3S/q5JAxxPppfJJxJjnN7agiTLtt7Snc1qz
	YB8/Y2fdNB+sTmjR+U4yl93941AXUv3y3kynEcVZE3pmAh4vfqJ8ZYJTx0a76lxT4m0=
X-Gm-Gg: AYBFou2IVWVy843AoNozpO7ZCkplktamK5nlHCyzbP0zxoixWJaXCJTRUymj4e+zqRb
	ujb5XhXXG3HBVMKds0JYZdZRrrf9jUZ2SSx+9eTT6Yntq7C0Wjo9P53obRQ7Uogy1uMX2GWw9m4
	GPdN1zpZD0khjxHMORO1jAQlA8O4xIsSU5PQOhyJsitPN2e2Zo1GQZBk77FvenrB2UwdEs0hGtY
	J7Pro6dUGnVqvorGFbtqH83QkjMC22lbHnFOufzrWnlchxEqJ/OTSwYj6S/0LJVkd/cWjMo4MyL
	7kirKPGgMpN7NMIys0wfh4G5uxQdYgyX2WoKwyxeoaOy76UmeqCuEf/P/6YTPSJAMzgn+LS2vdL
	ZZVQ4H2yOq+fWq6fKOWe8y9xem7s6M3uHn6VTCOQPMhCsqEFk6FU20EFEe6+HKjHW0kFD7L6Ln2
	8v+REtMaiGhhwkR28uTSDvEgkFGHWdxs7ayEfDlSVL9d2KmQywuuaoQQyDaBF8WYjdJVx1M6xl9
	d8oIQXZTTTH/ahfpBIwgrXSvuxHoFs4Vrgoxi+A77KhM4wegFzqnK5atU/ZqFwZHxo0D/1HXl4z
	tfM3qosiXvbFd4jGI+7FWW0nuYAYSIYCjit/hoMQwaz5ihmWxjApf4sHvk0X7ezOzG4Yoxte5ZC
	1jtUDIt4eodgWBFEGDVRmQF3WZiZ87Q==
X-Received: by 2002:a05:620a:2987:b0:93f:2a56:2772 with SMTP id af79cd13be357-9494bcbc465mr254819685a.78.1794546508039;
        Thu, 12 Nov 2026 21:08:28 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d452b0sm12300596d6.11.2026.11.12.21.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 21:08:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 05/12] fs/proc/task_mmu: write-protect device-private
 THPs in PAGEMAP_SCAN
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Peter Xu <peterx@redhat.com>, James Houghton <jthoughton@google.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Andrei Vagin <avagin@gmail.com>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Arnd Bergmann <arnd@arndb.de>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 =?utf-8?q?Miko=C5=82aj_Lenczewski?= <miko.lenczewski@arm.com>, 
 Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <avYQteUm963AKJQ7@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-5-00713d368976@columbia.edu>
 <avYQteUm963AKJQ7@gremlin>
Date: Fri, 13 Nov 2026 00:08:26 -0500
Message-Id: <179454650651.482102.17667443707760097412.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ee5twnqmzftd96dfabpttc3h9mt8mum9
X-Rspamd-Queue-Id: 5A73640002
X-Rspam-User: 
X-HE-Tag: 1794546509-604374
X-HE-Meta: U2FsdGVkX1+WPFy3WO9JdYEGl4AzuGpV15h24suH42KoFj3yjd+gN+Fi1PwaZTtoqH2ciAvHmoADUd9SZXElp3klnl8u5lp2jIp9CJs5IMWlZt4RoOIvbqhCAcQy2UDyeI9dfQDlVt96knCxCvPitI3tohIdv6lKQJIiBdbqwbx5jfFLT4kNNk6obAssJZ7WEVSSV5HjYrNSFEUscTGU+4TvT/ESjPM3QEAop3ZBMEUSFzl+ploryUfTyxe8QbxflLhEZAbz3G6DuipoQKr4urGh6vFsA/rhQC3kX5RmkgWoSUkfk7jw9VNp7QGY1QEmOHPwkRnadQZQ/loodGKydMd3Wn603NpTMuUfbCHK+ed+GJa4woCub1gb9u381xvHLxBADJG8IdU4Fhx+nAclQi/DsGQMXnRaG1/10pMhiJNexsR+O4ui4o/pdOSOUgSnKpbb7Ybm9dxyB2m089AjlZNPnDUv4Mv8yIjBB3OEeoVwQszANBEVH75Z0sDKEwB4nvk6NK1i4m3y+JeNY0hfbX/Iet0ERDy/4eK/yRY7ehJSYqzjnleQqT8TjMPMUjf/jmFTedgCs9lEfBrAibDqfmH2Ylf1jwbX7vlh2uk3NJ/hTnVt+4CWakltxLqa1ZOWwlK7Fet/QYIYDTk4Yy+zjD2/YJC2ToN0Uexb/CCjjYD3znWrskIy34OF8u/je2Hi+7l8lc3nID3DLe666bsV8nCUFrAXGJVcCX68h23fD37cuBs2uPr/IP4/bj6ZYaWVFy979gC3iND4O0M5KHROG4ZTuVj43abDEwktAX+z2IFRYa42st/QXb/4OyxatjWkFMu384vR/Ak5g51kVvqWFPNXrKXLJpE5JJp4z2Z9UC6fXfdah45N+RMGJfLG7KG7YBIvdbIOc2OlBcnxA4rQ9Op6OW6ex7t9KFyxrc/Z10TMl3v8uTtDsKy0Sj7t1NfkWANEYP0sXynsMcNMbIN
 L4j/xkPy
 I/kx1JUQqwjxYSgDdOpQ9q58l0TF/wMhvk8KcbILQACv2r09LPx9UhlRE/e6XPtyoDB4E0L3AETF+rIg9gW9pu4u+j9S7W77h+ER4ywwKg5byFv9ojmYvg1vUbwwkMarzmiAAMA6RmLHMf5r/O8wrCqOGULk1R8pVG5KyNhp03NAquRTPQ0Y9k2fJblCq0ye4/W8jpAXk3JgAzMNdczxCCtGkK4XzziPjZek6eXoShyqT6s9rDw0XIcqGx5fJn9bLSX8VbLmIz+RHlCW6ID4iHl4lsjJ8AodeeFgkoePmLr5yb1FCCMfVRDIRkSs3FyCxpzwqikVxrLCuN9oGtq37mClEbT2oKI+CWQqpGlCjcREqxrMTtbzGcPgIeenGmpFP+Hwy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12 19:34 +0000, Lorenzo Stoakes (ARM) wrote:
> On Wed, Nov 11, 2026 at 12:55:13PM -0500, Tal Zussman wrote:
> > but does nothing for a device-private THP. The PMD never gets the uffd
> > bit.
> 
> Sigh yeah. Device-private feels like another 'just have to happen to know to
> update X million open-coded parts of the code'.
> 
> We really need to find a way to abstract this stuff.
>

I've poked at it a bit, but zone device creates this issue in many
places. The core issue is really that softleaf can mean 20 things,
and the number of things has been piled on heavily.

I don't know how we solve this, it's just a rats nest of complexity
at this point.

-- 
~Gregory


