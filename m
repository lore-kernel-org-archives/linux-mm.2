Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE4E606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 06:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=H7CCoruC
Received: by kanga.kvack.org (Postfix)
	id 142E76B05B5; Thu, 29 Oct 2026 02:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3C36B05B6; Thu, 29 Oct 2026 02:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F25656B05B7; Thu, 29 Oct 2026 02:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDEF66B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:07:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 470F2C02D6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:07:32 +0000 (UTC)
X-FDA: 85374631944.11.A1BDE84
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77ED6120005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:07:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=H7CCoruC;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793254050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEvr/hVOQ19MxZAsJUGrC+tPSerEFjUvPXYsJLofEYw=;
	b=H5PALbgcjpeku4swqdXh4wLaStppyD7ogTS45yS0YWpGmorfQ9OQfbZ5iKqdohZMJWKzhu
	u/IOIGttyIRevybUJoXo7Jg5VJE6BxAqg/FKEQHDr0QpWuulPWBdnwz7yfp2HoWaa5EXT0
	BSvyy0k9+UYWxT8h+ef+ngr2MLFOJuM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=H7CCoruC;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf29.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793254050;
	b=c1P7zmm9WL1jeKTkkMR2GEHOvw6i4LPbOBuvmTpMRt0M+WOQClcjV0s5TbSbL4w6jpQAxd
	lhFQIxc51+dU5Q7uARikcof6WtDrfMemyyhBJtxNXUaZyW4GVf/oE7fi64F5dJfynuOg78
	qXAErPekDRJhrhHJX1SeSMKwRjIw/4A=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2e8f2c3ad6bso10657595ad.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793254049; x=1793858849; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=hEvr/hVOQ19MxZAsJUGrC+tPSerEFjUvPXYsJLofEYw=;
        b=H7CCoruCO/JTguy0CFLMEq1y/SPYaTdsYp62zUn8Zlj7uHQWp/JpH6PqmiNcxW1Y6n
         KWN8lG9rGK0h5/ltyHCBJCMh1k7Wlzy1ibVAXRi4v1BCkDe4qF0jiWfv6dQgP7oSrPHz
         SRr10k2vQDcc+BX9KKZw50hNhCVGmZNAKZWf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793254049; x=1793858849;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hEvr/hVOQ19MxZAsJUGrC+tPSerEFjUvPXYsJLofEYw=;
        b=CUEZVbm3kamceOOkNLLZ6paKHHgu7WtJ99IXEX968/j4+vxLYgTNyYRKhEJUT0YHpw
         J9msLtHFB0y1Mwk2GE1h03/DokJOiO5qM7/++4/OH+L00kQvmJCAXQ3CyEstYZqwkUuy
         DIwqd+uR3NkzAyk+pUMm9AkuiBlWMGwWgFYJmPIOz2E/6UhTJzxPYaKxIKLvWzuCAI1U
         w4nn/TdSeTIjNI7f2HdKIph0y5x/cl6gkFW64oBkUeWhIN7HtYEuoV8gFrhmXKloZBZI
         qdL9R1kZ+zDvi4MtDDJt9xWCFVe8e9AEHwpq45hC3x3J5KCppEvKOE0sd1ZrT+rv3LxG
         vPNg==
X-Forwarded-Encrypted: i=1; AKwUvByJtV9pK4q3MISNcdLEx6yuujwsBF4jeBIYWij4efZcs1NhX4sp6nLTZkcBFXGwSpNcGsnsCy7EPg==@kvack.org
X-Gm-Message-State: AFq9FYJgDZ+9KHWsAg63/me79EXqkqyMrN0MfW3HDrgKlHgXUo3ePv0e
	VV8fj50UsJZLlPIYq5K0kbEN6IeA983wE6r3kkU8ZaQ2Du04ZvOu+gCXYRY2pse21Dg=
X-Gm-Gg: AYBFou1LbLQCdIKI/D9LCu/RC1Ny9gWRcMsOuKqRqZuRER7dC4YDpGto7dsKqvcHEoq
	RcQjngKNmroiRW+CF2uLQTvjiDVeFxnFyoJw457ALIRR14zYqiNkxVMKY6W4sKVTXmGRs2n2Nlg
	Y5ePBMx5NeBXZcFEB6hymE83oHR6dTOtTYpObP5Aa9cvwnCnjAB1ncLzOTc+GyuI3B/YhkM2e3K
	OwulA0w3xeG1qMBH216Ex4Tzj4pnLcTrFxmGEsL4qMQJy609TXd49UdxxcVbK0akWx3maoPRAll
	pztBKVkyVo4ZBihQ9ytmB3LdaZ3ontAtQ4TDKMxMxkiObVIb+mgnuf90/rvhgSpSfZ3+Rao24bO
	7reAaKc1rHJ4V+VvdXNldEps8SR1s+ddSbBCJr7HlAwQSTKgn9WFFIHD7wXDEgV9NFlnnXG24WQ
	hkfKHZQ0lrfn4sr6V3WodU2CS13HIk/hR45ECANslyf00IzKQ/Hltdkh35HngLzxRBHQX1Np2RW
	LT4CmuwR6A0LEoYHQBZPhTVUNbRgJiJ9MLfYdxg0HX3KisN1WyU1H/+nQBVqO2XExIkVSrQlGp1
	/P8rSeMnRZhbBn8A/0b4Z5OoDUfD+CBNy4pF0RnPopV3FSImZFOd9mV4aPASUMi/zGyGgdFjIVl
	lKHMR2gXERJcz/Tv9BZrEm0WY0bojVyoh2Hlm91ASHRqYxj1hXJVXBdO3vWvSKVbhDMMJkWRr
X-Received: by 2002:a17:902:e545:b0:2e8:2d05:9780 with SMTP id d9443c01a7336-2eb0005dca5mr43806985ad.8.1793254049153;
        Wed, 28 Oct 2026 23:07:29 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6b79ce2sm28521545ad.21.2026.10.28.23.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 23:07:28 -0700 (PDT)
Date: Thu, 29 Oct 2026 14:07:22 +0800
From: Chris Down <chris@chrisdown.name>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 1/6] mm/slab: Enable SLAB_FREELIST_HARDENED by default
Message-ID: <2ba9dc862607d70050bbc86fce0091de2e23c023.1793253633.git.chris@chrisdown.name>
References: <cover.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793253633.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77ED6120005
X-Stat-Signature: 5d784ehhcwyqaeb71jsfz34uwrkmgiib
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793254050-300630
X-HE-Meta: U2FsdGVkX19HbDv4vY7njwv3kRug4f/WvwyEfYKOzu5mvnI1nVHvgA4T/C7Kzuu3nB2FIjWD9DQXGucmRQFHV/4aij/XO/PwSnVHxZ88rpkdW9Fd6NQF6cl9yGnLBkZVBzFNahDnioeZkz5qs0YitD0zG1p4u2qkAVKs1sTECoR3V21AJNuvx4dMOLxrZ4C0mLOOjNYAGXDLQLUtRqRvah8F95XaA1NOXvLGKeAIdnNAkPKgr4li8eknJraq8/rKS/iy38KjSuLzHzIayh/qLqi4HsCxDt+/9D08+8yw79uQXs+yCm5PHiCZoy3WTX1ps+SUJy/5vwb16r2Mm0cFI/T7UR0UUi2Z3fVxHe/dDTEtzHHzDQGLQRv1oqU5EMFa0exNw8qhtsmXWx7cM+6WRlB0VrkJNBTSaoFVXOtk53v9MIVdKmhoVCPNDwwh0deH2y/GgV7RPRjO3vg6ntpfj03N9mvzUJ9l8Kf/Kw6T0J9EIK5hkKV42sb6svGvVI1ovqFKj8u6k7iGZdXN0wnR6oXqu7TF+QrROdFrfsrGVZaUZRgzh30amv4Jzp0RoTxvFJR4pfUXgi4ErXbPO2TnQQbFKTQkHj1xxYbs6DblLG+rpfO8+/a1/tiLVa5vNtDN+9WF196kH8U6nQsvOa8nYXRpdERZMiXWCgsZcHzw0Y7I80JVdr7LughAHDlb5Rv8fh2I0Skphebq660ZTwq8sk9BKJys0kxezLi+k1LzxlPNXGdIaWiNsXHZwc4NfaUtAd8Jq2QUD6FxNJRyxnBHcNYEsh05MRQBcL8TS814MCGjzzb2+XbIb7CJmDK1av2PlFUOv11lFBhKJrw5WlKS15g0tN8/Grpw5ag1ZcFdWepMki3U1kRlx3ilfAqrFg6mSOtbNF+SHzszC3LpB29cewPDIlmlK5cMgKXry4XnYNA5Qip9f3logFhXCDYwp8r9e2nakP0B9rV8xoPUt69
 R8ZgDxIy
 p+4TinFbUxHA7FYh2JXT1ynD4kkVHB8WlD6n5EsRvxRGZmzD6eprBPBqoUOT3LlYX/NpgaegPoRBjf11BiQAitu/q/qIKx3wjCExVrxEaX9eziJvwlixxxYnrE3P0hwVwpNXAcNJ8ZDyID+aYrFmH5Q2dhwR7uqFfvSRXnbEC9BDlZLUH6APT2TqI5EysLapqeudYt9hJDCTJQIzwYnksft4pkedblkPT5ClKj8TzT1vvypSwqLBqAQzBNsKOofTv251Wxl48Z3nJrhzSiNRZIe2sjYFalMVyxqkyhjT1/eXgf7KMNuz2YQLdJA/zQiRJB7XU2lK6qz9hqkkgiJT359IxSvITHWEJewKlEhaQNs770uwS18dpEIfQBWrB5JA+Ip5TYyc3XU3GQ1FM5dcTTNrvX/KDD+l7wP/2+C+yna0jxQBgr99pmVrnEOV3AyjryMCwqW4if9hhpqvtPjKoKz7fdxqwUfePNSeEkQRhHdKl5xPugMRqo0MehdvpgqARH+S1inVuJvlaQtyKBmRUcN3cXfJpeHdz+o+c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

SLAB_FREELIST_HARDENED obfuscates the free pointers stored in free
objects, and catches naive double frees and frees to the wrong cache.
Most distros already enable it, and with sheaves its cost is small,
since the per-cpu fast paths don't touch freelists. Measurements also
show this quite clearly [1][2].

So let's just enable it by default. SLAB_BUCKETS defaults to
SLAB_FREELIST_HARDENED, so it's now enabled by default too.

Link: https://lore.kernel.org/all/auITixAJMfLtfa7i@chrisdown.name/ [1]
Link: https://lore.kernel.org/all/179312451613.474906.1475329637924619088@kernel.org/ [2]
Suggested-by: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 mm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 604c58199acb..17d017e8fbef 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -208,6 +208,7 @@ config SLAB_FREELIST_RANDOM
 config SLAB_FREELIST_HARDENED
 	bool "Harden slab freelist metadata"
 	depends on !SLUB_TINY
+	default y
 	help
 	  Many kernel heap attacks try to target slab cache metadata and
 	  other infrastructure. This options makes minor performance
-- 
2.54.0


