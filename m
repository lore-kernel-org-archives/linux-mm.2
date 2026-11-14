Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889BF606A33B
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 17:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=UkBrZ2pj
Received: by kanga.kvack.org (Postfix)
	id 795E76B00EF; Sat, 14 Nov 2026 12:22:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7471F6B05B0; Sat, 14 Nov 2026 12:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636EF6B05B1; Sat, 14 Nov 2026 12:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A1C86B00EF
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:22:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 344C31A046D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:22:13 +0000 (UTC)
X-FDA: 85434392946.02.F311904
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4A2A0100008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 17:22:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UkBrZ2pj;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794676931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rHSD3+ZQwKzYQnxgJEPwedfPYdnuIPpqgShWvy752w=;
	b=0W38a4yXmyn9TKLz9x6ie9YIYTa4CiOhVdi3tN2JlQpB6P+TXUYoG3RZclA6RzlvRHNRWQ
	Gyne9nexW7B8f0nSWm2R9bFRv+DTOKNPGO64W3GbFXmC/DvcKBxfc9ujs+jl21BfOTigMg
	cAwgH4VLGylXteau9w58SbtPEuudV4M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UkBrZ2pj;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794676931;
	b=KoPcmF6yYDaujIPV6RAmjFfK3L4T0L0C9c+n5t6flzuESptzV9/lAoKuRclczGChQX/i/y
	3UdXURqIBZ3axxRB6Xm4ttiL8A+Aiclj7svZjxaeb21VMC3F8tiQT7oP29yHa34qzRqywz
	1agIMyw+tHNjqFqcXZKa6J/90l0IK/k=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-91f332a4b2eso9323406d6.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794676930; x=1795281730; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5rHSD3+ZQwKzYQnxgJEPwedfPYdnuIPpqgShWvy752w=;
        b=UkBrZ2pjzEUuUwjaT84R3emSqeDezcIZJDDiJo19n9wkjln2i23sVR9+Qs4EHLRsak
         8LTZTMLppO7e7BrddampEdV7dCUdaEUCeH5A/4K6mH9CZT9gSEOYoJuUmBNEMScT3Cen
         yUonmKgOjxWfuufORlrctlnwICF2KHehVIjARuyHM91EyPpJ4wbZQsuEVgbKMB5GObf4
         dF2/zOVy37lKeAhq8Qlscgblq/pD8YtLhDpgLQuGkxjoXhmkuA2yqhIi7Woe6/saFTXq
         lzGptzQUGy0ehZaQYL9iv9YEnyF4VR4S+x31LIccb2g42XoF4iVYqthrT4IsRe8cd4xI
         fwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794676930; x=1795281730;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5rHSD3+ZQwKzYQnxgJEPwedfPYdnuIPpqgShWvy752w=;
        b=AVgOAzKzrh9kD/9MdXuSEVbXvxEwkuNX6F0SR/927zfgp+z5RlM04EmddHH3AEzMtJ
         beRV6BvB2M2csEZ7K4t5M7PzbSUTucO4iBSUn3ag0DLZWYZY5tVcDWtf3O+zx3KWBbhu
         n8wF6efkODotDDouuEjAGtO6PyqTT9kWWk8xNeayOaAYqy+lR5qqKIU7FB/bUIpWc/nn
         Ti56TKp1kd75qkr60anWaj9mCuOE9GFq5fbLzzy/XqWPgCPX1zE+VLMOrlIxx8n6SD+G
         zRZPrHN8vmjyV/Wu3k5R4uBD5NopGc5V1H2dJA1j+rukWc1q1t+O5n0hhJTNFAOEDNfn
         0H4A==
X-Forwarded-Encrypted: i=1; AL+hErGVBL5T0Qd0PJqx4Lr+fDC6fpS5kY6uyc1zRaqkgf1o7NHlepIONPMGlRUlHDGr2TwyfGCy9SgJ0w==@kvack.org
X-Gm-Message-State: APuU4Z9TuB/YUq101p0YzRRYZhFZmy0WVh2mergtpGrRjUwy26o+ZJXo
	BJ3UdZwJcuY1XOWX9tq7tIgQyE27vwjVYubPk+3jpbCNwJQ18J95aS7J21r2akT9fHE=
X-Gm-Gg: AYBFou0YyR/+eGJKQ/YLLVzSc0cXTbclmn6kPKko4DSvEAOa3ZDZt5rhsGkGgz5mfCU
	UV1PbtZ36jVvtFwZXcqfzjWkVMnr7/nl8z1RdvSdReXfch7NfSfSZL5wBtWQnFPSJR3t2HGdpmw
	6f5xh0Snc+I7Y+H9t7pHQHsOVopJabgFSpd+NuTgxwsls6jTukjQ2Aj1ompDGamaltC++qTZobh
	XC37anHyLxa8Fsp7IuR7KLPH2PXj/2dkOz3gyzlMt26ZliQiVe4mrRAJDnF2AXacDMZ05srtURa
	7WYw+DmJmgNoofT9/L+R9i+Erzv0One7cZN7oP/uNGQ9VuZh9g/TGXAU/tqbng/TIDPml11q0nm
	qilC/RGO7KhFP7UAGJijT8GXMMEWvRvyW7mpbVHOEATGuunI5bPZj55QYAWo0JX3BlEi9vVMToD
	8tdGH0lAq0fQHzqRJpsbOiBsaP0k5QmHjcG9VAEH5vYbh3g5ZSNMZZz9vMt1+Z3HLoTlmHSb43+
	3SxYiNbmDQdZFJEb9a62OJQu/mS9RkNYJiCKLDN55JK2VO16bykhwsulXzPfP7r/cFZeeNKGvMN
	G/V4DBiolIclTCoNESwL5l4h0uwtggm7VJO5PgfqpElC03iYD0Q7ejM2bNLkVyQGNBNpWSFYWJr
	+uOcP7xI=
X-Received: by 2002:ad4:5ce8:0:b0:91f:2e4a:7993 with SMTP id 6a1803df08f44-91f2e4a79e8mr70102936d6.14.1794676930211;
        Sat, 14 Nov 2026 09:22:10 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23d6193esm47177926d6.19.2026.11.14.09.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 09:22:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] mm/mempolicy: merge adjacent shared policy ranges
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
In-Reply-To: <20261113-mempolicy_limit-v1-1-16688b2644dc@kernel.org>
References: <20261113-mempolicy_limit-v1-0-16688b2644dc@kernel.org>
 <20261113-mempolicy_limit-v1-1-16688b2644dc@kernel.org>
Date: Sat, 14 Nov 2026 12:22:08 -0500
Message-Id: <179467692882.482102.17918264505505182751.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 36eg9w8q8gma8bg3w8g9eddkbk5aft14
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4A2A0100008
X-HE-Tag: 1794676931-973253
X-HE-Meta: U2FsdGVkX18CEh9weHmYhuAmnZ1M19PWEFI4EvMkWAR7fdqnFKgJW5yY3kvJ8Fo4AHUS2utOLbbTYc5iV6K7OsvidMbz7UrY6iBpukZnxp2qvBYC4HcexXduYGUbGAallWWVJ6Pq1ela/s8cmvbwg2FDGqFI4yeu5sEf+qR4IzqTaRRhRBqQSPF5389r2KIJIoKFx1qJSYT+mcM7/I3JSsn6RAJhxT9WDkXohunOADHacKsnFREcNTqCP9ORhuMjhWV9MkaSNCpjzeyigrSORwZXzS5uXg9OVWeFSqhjISYfUASnk4NaMGlgtS3sU5l3Wv1ug8KUN8s38mWfeDcmdiaBNI2NUXsCmv9YhGtpFljytALGZpxWPnwDILb0sDgndLtavkqjYtnDhG27zr4D3z7VnK9Ch7Ui2FqgZQcKa9D1OCTgWcQP4umHZq5BKBwKZxAbezSSUxVL6XROiUN2cqO1WO/nWsjYdRKwK8jvkVN38TEk84jDYS5d+lsonG2hnwb62M6x7qDvXcWMgCQlsvmj25YQoqy5H9aqmciHPxZ/wzSprw4D6eCYbDH69tUKyhejaSP+S9ddXQM8snFamlHOt1eBNbczlYGCivPHCnG64wACXu9zQMGIyBGPWFzCHwqIrKdk8Mn8q3oBFyvXLnHiJyv1c391D6pPrlO6pFhrJ+nn+d4ktEkILepNI0wxtl1E7j44YgUz/jVhwOj0Dzx4es03YXN3c4f4UTvhzyONrSf/VWxmZ349Cvaas+yJm5kPjkcZOpZUqNW029WaDG3GAa6O++iYkpAlJJpXRAY9RX1EieKFBNG15snnWe/UjHswEbWopDniBth0Fn2eZgMV6nLUVyReVBz0pQi52eMMTtlub5FOQeDR7C9rHx8uMRfDXz4zqAMi2lfu7Sl4TUmZFTk7knL/9fiKySHDOJAveb3a09HkUXniKJtWLbsMd/NspJXfe8cYKkRYsK7
 05FVGjB5
 gSZBauZKERhHzne4hPaEOK9Cpb/A5u7gHYswZKGa0L4g+lUPQ3uLEDcwtzDYwo/g6wQpuetb3Bd4SqdSTvSEw9EQdp2QgfpXwRhZAPx6dI54y8lKnO3g4t5ucoxPv7uniC0o0Z59J5K21wNByQYd+0x/3ktm5VlziqiZX7OxlR4huDAMpIzDWMi8IXBy0EzZrddc2w7PAT4PazCfycnNzdni+cRbqLTbpzDrD06UEKqYE8PmFfPCvDQ3zej7MBpDEDaqg8PlVZo5o6lq7ipno0Be5G6GRcQYABnZqjw3oVqGMV3Hs5jej6af4zcCnqE9CvNsVf0E7SzauiLwiLQh5Z2fs6y74ben4vZMTLH8NJsYU2v7qYxP56YIaqoguLobQjCNt8g+sK1czTQA6J0fXroVbTkd2SKFjWKP1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-13 22:36 +0100, David Hildenbrand (Arm) wrote:
> Shared policies can retain separate tree nodes for adjacent ranges with
> identical policies. This can create unnecessary policy ranges especially
> when individual VMAs cover individual file ranges, and user space sets
> the policy on these VMAs independently.
> 
> Extend the existing replacement handling to merge ranges with equal policy
> at either boundary. The existing replacement loop will then remove the old
> nodes and installs a single node for the combined range. This also avoids
> splitting an existing node when setting the same policy on a subrange.
> 
> Extending either boundary rules out splitting an existing node, so the
> allocation retry can only occur with the originally requested range.
> 
> This change will make it easier to cap the number of shared policy
> ranges per inode.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reproduced some bad effects by setting a policy on every other page
shm policy across millions of pages - then setting a bunch of pages
individually to the same policy.

Base: merge never occurs, 1 range per page.
Patch: They all collapse back to a single range.

I was also able to reproduce a "BUG: soft lockup" when a file is freed
after creating millions of shm policies (absolutely not realistic).

I think this commit is probably fine to backport, but I agree it
doesn't seem worth it.

Have some thoughts about the limit in patch 2, but otherwise

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


