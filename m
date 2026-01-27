Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57573D25921
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 02:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6DB66B0089; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AFA6B008A; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44E36B008C; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 969AD6B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 21:44:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33E961606F0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:38 +0000 (UTC)
X-FDA: 84376200636.19.13BA4F1
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 60BCF8000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:44:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aQbGYH0b;
	spf=pass (imf30.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769481876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTcM7omY+rlT+2vT5sMl68zqB+/AVOaJpGtLWNEHl/4=;
	b=30lco0mOgilYWDO3kTEV6a28YUGTLZIKC/9Id0TrLohd5tOE0bXZ0biz0VdlCji6qIUbIO
	Tyy6wy8E5LWWTLPNjNp1YrngW6AlLRiwrjH71RYRN+M3vkgyoElTz9jm/eZ+w4q+CNMBDo
	/SMvJ82WbEC6FNnSWnkSbfgbVDOJPlg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aQbGYH0b;
	spf=pass (imf30.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769481876; a=rsa-sha256;
	cv=none;
	b=ztGQjR4PVFkHDxABjUOn0QWv1LkYXHj+c33DoSWWP5vKtUX+YWcS8wxn9IxbjqVGFpzfeM
	FC+h7yNlgHH3gyDH+IjR0Aid04Gp6JpQN6+Ut66An1eBQHM3oYWlug0dMDNuD1Hmwotv+4
	UdhLtZF5LwiBah2XHQ2fyYmY+1ebjtg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769481871;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fTcM7omY+rlT+2vT5sMl68zqB+/AVOaJpGtLWNEHl/4=;
	b=aQbGYH0b9IqOiAI1EnpGFE22GMgsHH6he8NABKg7mw32FIczwOxBGo0aG0q9T0VlgZjhdR
	QmPG9Kg+eEsT2qBRJgdrNs9tc8TykNsvZXhOUUY/Dq4XH1wdMYzhk9sm3X3fwqZzA0IN9P
	sQA6S7lSzG57VB4GqJunTJ4Q6Diac7E=
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
Subject: [PATCH bpf-next v3 01/17] bpf: move bpf_struct_ops_link into bpf.h
Date: Mon, 26 Jan 2026 18:44:04 -0800
Message-ID: <20260127024421.494929-2-roman.gushchin@linux.dev>
In-Reply-To: <20260127024421.494929-1-roman.gushchin@linux.dev>
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: wm3peg3m7yb5unuiez5mpih45i89wpxf
X-Rspam-User: 
X-Rspamd-Queue-Id: 60BCF8000D
X-HE-Tag: 1769481876-148307
X-HE-Meta: U2FsdGVkX19znLJ0oFvecuDe5zUhtOIXbAcFmBss2ePEKWnDkKrfR0qkBJg3HhX/w+sm5QDfPIGr4VRGp5nZLihnLlkJD+YZnuw6zPvOi9j21zOorHhpnYtA7jItxGXbXu52Xk+cv4HpySPfJk+In8+w/k8q8H7YmzG2ttugwiwAxdKF0+He7BmAkMdJuq7HUYBOREd+2bN8AwEs+y0OCW7vm18S84OJ9HH01JzSx+ppbeWbm1xverDYHeCxeNZ65DogfozDgjR63MASFC2BnvKcsvrGSaaLkNt4MErtAlZZR0JMgS/8OXGr/0afIhO9q7zhMEwhqNpdjF4rVTRCLPq6cNLP4G28joEzwoCDK5zrUfKzSUX5FBUPgCBKuOH0Vi3G4ElJCDclOxDLxV2XaudoYBpTqaI5cxZZxAFL77iJogQTj8DlWYjnmyyqG+AS1yBgS+Gy1IICjmmWAHVKNTEkLkbNwThO8JjqUm5bvknYuR5x7dCIF09Ol5l7bwpt7MCD0iaijA5q4dZuv9idV7GcXe1EOX2Mzkq1F2oXS0qnrcvZ6poJsvzRprXF6U7SsYuxMOwJmFYNSMRozzngpeN7AV6GNgdiiYh0OcfwXowjpcgkgVZNOV3fwsD0+2v9k/WEad7HGIg71N423r8RRihElHhnIz2/EXdstYLO9rh6t6499iSmx9USAuzeBkdxFSipGu+wxPpyaXeUOU54zCU0Rf5AcwxAWNsV+IcFf4qhZV/0+WokccEGmvrd4i2M4jORc/bJJwGFT6AzDYGHoYqATa4PQ7tLE3/TOgXu96yYVLV1NgMH/MOeT6r/FQEJF8AjeAc1Iyl6PQ0bIUp0X24W7J63agPo44YYL3dxLzBLypqCjA9/Ai44dkqUNzOfhyComuVYrwsqrfDjQcKpRgsfjwge7E+MDTMAdHo06qvSPuDeIE2EG6poEIVnI5nfBNlSzjgVceh32psDIZc
 ejmhgx0c
 ouTFopCLL09nQGpcYF94Plh5uVHBfK90IawY1oP/l+KlfBgu49iOUTRTqoQ5KBIG4xpfFF2NBy0wBHq8LfemE+Ivrf/9/SowHDA9gCVKUbzcQbyx+2L5fAR7j9wtwk9rS5QFozH5+krd4OLl7e2hk2HRSt/NwQDhwlxqVoF4sWwO5mR55VgRuAwzWLs1pZSWIuI/YxwNx0u4WL38fJrtvwZYrwasW6eYbDCk+KWeXu4cuiCUXP3IkDsMVRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move struct bpf_struct_ops_link's definition into bpf.h,
where other custom bpf links definitions are.

It's necessary to access its members from outside of generic
bpf_struct_ops implementation, which will be done by following
patches in the series.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 include/linux/bpf.h         | 6 ++++++
 kernel/bpf/bpf_struct_ops.c | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4427c6e98331..899dd911dc82 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1891,6 +1891,12 @@ struct bpf_raw_tp_link {
 	u64 cookie;
 };
 
+struct bpf_struct_ops_link {
+	struct bpf_link link;
+	struct bpf_map __rcu *map;
+	wait_queue_head_t wait_hup;
+};
+
 struct bpf_link_primer {
 	struct bpf_link *link;
 	struct file *file;
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index c43346cb3d76..de01cf3025b3 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -55,12 +55,6 @@ struct bpf_struct_ops_map {
 	struct bpf_struct_ops_value kvalue;
 };
 
-struct bpf_struct_ops_link {
-	struct bpf_link link;
-	struct bpf_map __rcu *map;
-	wait_queue_head_t wait_hup;
-};
-
 static DEFINE_MUTEX(update_mutex);
 
 #define VALUE_PREFIX "bpf_struct_ops_"
-- 
2.52.0


