Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB9C8D25923
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ED3D6B008C; Mon, 26 Jan 2026 21:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3180E6B0093; Mon, 26 Jan 2026 21:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2243F6B008C; Mon, 26 Jan 2026 21:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F14CF6B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:41 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C258D3C84
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:41 +0000 (UTC)
X-FDA: 84376200762.02.AA2D06F
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf16.hostedemail.com (Postfix) with ESMTP id 062DF180005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VqQ1tgRF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481880; a=rsa-sha256;
	cv=none;
	b=QDDRmv/9wcjaBMTlO+4/gQD9pEHTS8YBICpB1jpA2TnAsELSbbURhSpodrwEwrZpzDqCBJ
	PeWJmQ/H0HEE7ga3Z2hjgIhAQrQbUumO9jfIkuemIeOLTsN5IudMv7AnLXjvM3C8arDHZL
	30UigG/CrLQyd/bUXbRW0qy+V1upz+E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VqQ1tgRF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prFf4bLkFxmL672PFq9iQpUXEdYH2JnxC6I8++AT3IY=;
	b=Ttwel90rT0J8xl150/uwlK/5NjgRf01oRIa2H+r9rLusTygfjLUxtGC6XA7JcTIW4w/CZz
	0uxF7yVcfFvKL4CqCWKvfXlqrmutGbcs3MO4Wi8Pzihgt8bUkIyDI1bal8NIpYXRIU5ooZ
	dRGrTWuyCREkoaxs0oEv3rINvmIpwL4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=prFf4bLkFxmL672PFq9iQpUXEdYH2JnxC6I8++AT3IY=;
	b=VqQ1tgRFsg9DAgp80I7caK5fAICVmELmNdTF3Zfbr0DSK81FtixqJsAebJ1U9YfHuIkQ4t
	60z0NHIBhH9awJ7ue48VxidiZgdzn3sQ96nCcnN2Pj6SPvLGFTwlndFkXlGYwe1r48iJZH
	HOoR42cTjeMrewVKEgocLz1xOVH+Tek=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bpf@vger.kernel.org
Cc: Michal Hocko <mhocko@suse.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	JP Kobryn <inwardvessel@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next v3 03/17] libbpf: fix return value on memory allocation failure
Date: Mon, 26 Jan 2026 18:44:06 -0800
Message-ID: <20260127024421.494929-4-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 062DF180005
X-Stat-Signature: ie5dy3nzoy8aq97eiso554z4ebcfiqrk
X-HE-Tag: 1769481879-153162
X-HE-Meta: U2FsdGVkX18zf0FhwWVrzQhi9ECpXsR33TBdzBLrvU97lCcWluOlDaRqgWELuhiHwpL1mHvrzu12W6/NKs0T9ZZmaww48KoE68pXCVI/LX2Hu9x71EbctWynMcWRy6I/bg7iQhpyc32tbe4GP5Ae4xpmL7jzKLbjbtiy6Wa4QIGMDKTUZ3Kf7Etq4G55ZGY1BeyOMxaeiygXPT0JWyV/MzlnvCIq33KU5t30BUqlWvF2IH9yERVDOFRlwHZQRT0HyE8D6FA/m3Mt0qImPmySXRD3trk4kpeyOFJp2xgKvNbjZivzyjMQREOho9Cr0PP6lcKKK5cSjTV3Rgfd+ZQIqT4+w5AjEmWCL+o9163h0QZaO5xhTBRC2wTi0ZqN5khdFQ5jkmvOx01UJ4arcp81nn+aef7AX0GpoLQj8hTdp5WhUvKBhcowWDNRgOaqsJGtIwlOcQLumHKKtZ4wNOaVXlfH4hQjebdoOpzwUNynLTOJulwldG/koRhbtmhJv5gGRsfEhqissCprgMq0zL7kmxQ7xEllWyQxEnA53pfRKBCAaYhKA3hbm2E/LZCXVZeJVpoRN9eeczZQHb2Bp25inmaUA/5Gus8AZCYE5KOcWEZ4JRzypqHFGKCqkur6Q5SJrll0z7wNSI56riikZBmv6zkSCV5KkyUStLBUNS6FgSMGBsz7MaL1slXlW58dKnbRVKjpkPFMr7fFf0QBEgPq4Hn2XaNsN7P+tSabk3sbVfNm/J0rVaPl6LqPFVAL5PD55vuoSt26eBak68QNvI3/K7qW6CqInYwcwciQBQkVgr3x9W2hog8QPkwbHNpZ/RusUQFiHouyBRKfqG7JBAyTS3qZQ6FuQ/N1bZDUTlUivnTj3pv/a+BTijZgCT2P8WCKow3hXQXtBeiatsZ2KnlD2Dp7DAzdkTFNLx8npLzu8F5qB1X3itzQBKZmQfAqqGPCBwJOVgfiilF4fRy2yCr
 VJWvs+7g
 5qvk1QJx9geOq+QOCDJk+M8Hfz9ku57z2u9KiyhcF5gyoYihGnf8DOwNFsNzku5FgIdD5UJnPGwFax96+Pd5u+zObEOBsTfgU1Z/xRDYK7xk6U4ZcN/gkpp7UzLcP43j0J/HpqwFzg5VtlXOLepqlgU6hcRvOPwV9lMuorRV5jWTTE9xBdoUtjyAUs7xMYZE0+OgP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bpf_map__attach_struct_ops() returns -EINVAL instead of -ENOMEM
on the memory allocation failure. Fix it.

Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0c8bf0b5cce4..46d2762f5993 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -13480,7 +13480,7 @@ struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_map *map)
 
 	link = calloc(1, sizeof(*link));
 	if (!link)
-		return libbpf_err_ptr(-EINVAL);
+		return libbpf_err_ptr(-ENOMEM);
 
 	/* kern_vdata should be prepared during the loading phase. */
 	err = bpf_map_update_elem(map->fd, &zero, map->st_ops->kern_vdata, 0);
-- 
2.52.0


