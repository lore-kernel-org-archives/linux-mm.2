Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C943606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=EPf4bMTu
Received: by kanga.kvack.org (Postfix)
	id 00D906B05B6; Mon,  9 Nov 2026 20:54:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F019D6B05B7; Mon,  9 Nov 2026 20:54:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC9856B05B8; Mon,  9 Nov 2026 20:54:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A381F6B05B6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:54:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1CC421C32EA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:54:02 +0000 (UTC)
X-FDA: 85417538724.19.DEA413F
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4D822160002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:54:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EPf4bMTu;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794275640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHlakyrx19DFI00OyTV3/5itJ6vPo7FNJRTP0VUFhsQ=;
	b=KMYj8isFHzBdUB0BDIMJZU5nxJOWmN7ZXNjjx1uQdJm3d/a9bJUp/3YoDXJHZO2gj/gmDh
	T6NSxEB7cRWLG1Xmrii5DfEjs/wt9qgc3sAohNXF7U69o2O/qWogNaOlyGgTOYZjTfBweb
	aBipGPiehH3HhWJGDPVKHfTA0nMelgA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794275640;
	b=AP8/GR78eSzCAiZcPB7G3NhGTsdc5YxUkE5lnVN+xSK18XLtXSFhVFgV9TGUvhrSscYLSW
	VqRmevjoHvxTJRQZnychQ0Wq7kCv1lqdNeMyHxgSjZnVVgoxNBFOeydyfVORIydNfkj/3m
	wFgj5ARQUsqtwfH25e2Tfv0arkbj3dg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=EPf4bMTu;
	spf=pass (imf08.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so633002b3a.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 17:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275639; x=1794880439; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BHlakyrx19DFI00OyTV3/5itJ6vPo7FNJRTP0VUFhsQ=;
        b=EPf4bMTuOM7CJ59rxfeWZGSR3kW23iu4wzyqXcmkUrbb7GdsCTPGUNzrhrsXRpT7kI
         +Z9Jy+i6tsrlp8jvS1h5z4cbtohlrlryVNSuPVYozVdSg70vdzkq1+9fyT/bfkNVWti/
         +eZwiX0SzFzfW27MztcMPxK8Y7mb01mOCS0EfblwL8MccFeku/as4q57WGDVdzbIKVD0
         zYf6d7OZ4/khvHb56o4wKPWRrV6ljKkDz/nTapwNhV/W7DaLwA4rUmoVLmD6GPwhvLnc
         wwgXhQuNpiHJnYaVWaFRv4Zh11D5ZI/VTpeIppg4+V7cvxZXYbLiEpeGOO3K8+0dFege
         9wgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275639; x=1794880439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BHlakyrx19DFI00OyTV3/5itJ6vPo7FNJRTP0VUFhsQ=;
        b=roEf5r5MAGHXAzDf3Al5LnIo/C+0i8iCnVSjs0h1L9Gme4Rwzk7XiiEly1QkQe7BeH
         yCSGYbICEfMX2sivjVFfy4bd84f8Dw1ct2f7eJ2kDty8YS/T9sMPRX99nIUux9VAXTWR
         nwPsEuxJFH3dvrlfUth6VvdbZVnpPYOiGL64eRWE1QN45AV8Y21gvRacvgMvhhKTO0Ss
         s3ITlAxYx6gOXPG0uQwGsvM+bs0+ULy17xABl4y2vYV2piPnt5IS0aRDngcsWAlgJxb7
         FNdlWJzAX85DHyjJksSD4aeFyRP02yRK+BDoQedW6I1GB3Jgw3Fjxootj0pTELM6k32s
         NGJQ==
X-Forwarded-Encrypted: i=1; AL+hErFi/ZO7q1Ki6SJaVzN+TfMyVrDeIgWopeZtlmiKPGBV9t0/+jsUixRnTaMqVgTeMKg5/j0v+F0VSw==@kvack.org
X-Gm-Message-State: APuU4Z/Ic64mXc/AH9YdwH5h7fBxJq0bB/1+4q4gao/6aR1nK1pVGutf
	SkaTI/HTkTcQ6oGnwYwzQMGzANi3JUrQ7vANPVmwBopD3Wsp5pUBTISA
X-Gm-Gg: AYBFou3idwQyjBVR5qotCGMqyQDeA9oCt1XSXAb//dyMn3/mjAUyebNG7vYl8NiMdag
	2hD+c8lDGTLtx2AbtHV2RurYNEbvMYL0UGgGdOVXmXEZ1XtX+/RX8eEOMnQerpitbPjeWPRl5Nx
	jPHi8bBafSUJ/0jPc9ianzHYM2mXgEas4WJdVEQaHtgjoXu6UUUBkg6NNFlN8B4jplMXBbGyCJq
	OiClmvaS8Yfv2NdwARJa9YKAMs6Qt5cEulx/NW7k4fExM5KFTh9NZ8ZkyZ8I+G01yT5eBwi70l3
	0DltOidDMY97CIrc7822U+EjOmTnuxa+h7VUnjjVR6OUBj0xMYQ6HaSAqX04BNmEODVh7b4FC85
	Kfnrf0/sq7baAf4q2jhWoERHj92RxOxtdMpMFv+Ebzfc+Njkltg4nhyiI5g93/MW/2fIBxxh/8E
	7avm/u5ya6FGv8aZDZpCfpSigjm9OjA0xV4u5qjikmwU3R63CPXzMcQueON7pPNcXXlUq6eePTU
	nfJR6Rxz9XlDId8VpXRMH7Kpix/4CxqHRND8JQ4ueRq7GPO6MFuYSdJgECKwEFSxjjrc/uGHHEY
	L5J1QEgQ0O3ipx3ZXiYmGHv8G20mVa+mv7Avp8GRR45NPA0GlhvzghVwWmushvBne6KBLQbMwX3
	dGPg63dLQqittr7nZCrLl6QQfbGE=
X-Received: by 2002:a17:90b:2d8a:b0:3ac:ea3b:f28b with SMTP id 98e67ed59e1d1-3b166ceb599mr1275045a91.24.1794275639153;
        Mon, 09 Nov 2026 17:53:59 -0800 (PST)
Received: from localhost ([2a03:2880:ff:45::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1690f4733sm552422a91.3.2026.11.09.17.53.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:58 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 4/4] mm/damon/core: use node counters instead of flushing the root memcg
Date: Mon,  9 Nov 2026 17:53:21 -0800
Message-ID: <20261110015321.611093-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261110015321.611093-1-joannelkoong@gmail.com>
References: <20261110015321.611093-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wkob1mawg7t4f1wax8kpk1usbbnuoim4
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4D822160002
X-Rspam-User: 
X-HE-Tag: 1794275640-616007
X-HE-Meta: U2FsdGVkX1+YjRs2cl64PMaHrlhJcrET0KN/NMaDliGUP//omsBpZ7uVvaMFgWrl7iCT0CczoM4IH08mT3IaYbB4LUF/ZbWnpcUOzGp0WYLMYsRF6zfs1ajZ1D9dk0tgNQ973H9+hRs9KM9VWKYFK2SsOvTE4tOLuRd0jjQ0RwIZ+TeexZ8GyLoGXEhuJ48ibiIs4+emYFfpVk0NdxkWYtLp9BqGqEo8M9B/kIIup5u/ciN3QrsAsF92+sIvHuEXeHINJ8cIpuf4aPO5k9Evt0IefJJIP4QoPjcqtQAs0cTA9YbL7XOqBoxMb/fYVuHM0it5hHYLjSpF4COSTKPIF1ccuj1YiyCZhDy9RRpN2e8UPtd0TfZlaUFPWE4U70zJOQITloj25kLigpT8yXdjokSZSdNJZdInKeD4FICEeREULKXtECHbybz04QfmEwfgDnndfBmeQ9xyKBlxwDLCKN9c0Kkq4cRgjTfSl11eV4gMxwUTEj4M+DwQC9O7uP5lXUwzmtgqRuane92At1BBwK7+1+L6tTC8FCDJ91c74YwA6PXJXrewAlMI8DR/uzJ0MWbpecuNLsYjm4EEdd6FHVoFQkZwO6qyx+19ZtS+2sMyjUGmg9H7Oe4RpOFWAmuyELGSNq/Dr1Z916rfB8zwiZ9hAfwZKxE3WM8BNy9QQIp+tRNLx/SMf9rE6GIXTmLrh3b9jxrs7nRZNGf4hhxUJHjskXmM0M4m6rIocNr7IXkNrpNFkmq51LW6d4Vjl3noxJj1bNPFA4VSCbOyZJNOWMbNokQZRsNSiBxRHKagQB8nmwkEEFXMiMYEWO407Fj/pgwRzxXRxz+OcI0gQ6Y8ZsPuYSxd7I85ixBzBBh1LSH2fnyHMs+tSGS42G2qsJ1gTHPSPJebf+cwUTRaAbks4LtmlvXjCkdzBzouxXibQENcIWODcsC983HtLCKrYxM8OvQnLR1RCXr14N7TnTS
 BJl78DIG
 53BlpCCN1zYsZLKtQ28ve5fSeB9vOFEADzynogdz+Ct4KGTVn77Fv85sojd2I89iHAYmJKeZcr6fyB2QtVQIpdm+6pUhWCjmjCGiI/phAnsrTJQx9ddgtMp75Rf88e6BV5FaODFc3J9kmcWUfBVqxRSVFWsuGfOjjuls9yi2eEg2Q3v8r+mX5VWmQApfyT1ICEaHn4NdkEba3n+X6P+faeyj8Qk0lCspKBFoD+RF5Xvpz6P+5zgbUrz1Er6hvpx4pxkXeAeafHirTnGENyb5GuSyWJpMkM7MYz95G6/oBI/qzYYELXdqLlP8Q8hA4d+fbPCxOEA/ofW4MBLHGNJX0lgreNz9MwwzIiulZ3Foh4vL8d+wctzPeTyS6tiw6bj+1GlzHnwIUaRVKT10JpB6JvuwvAWBGQOXiDlOPmdlrEgqyI2S2mfzISHXwme3tfBQke9Tw//p5mnPxfr1oz879GeWjaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_get_node_memcg_used_bp() flushes the memcg stats before reading
the LRU sizes of the goal's memcg on the goal's node. For the root
memcg, that flushes every cgroup in the system. The flush is not
ratelimited, which means it happens every time the goal is evaluated.

lruvec_page_state() now reads the LRU sizes of the root memcg from the
node counters, which are always up to date, so skip the flush for the
root memcg.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/damon/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0a056949604f..14f2a36c1025 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3057,7 +3057,12 @@ static unsigned long damos_get_node_memcg_used_bp(
 			return 10000;
 	}
 
-	mem_cgroup_flush_stats(memcg);
+	/*
+	 * The root memcg's LRU sizes are read directly from the node counters
+	 * (see lruvec_page_state()).
+	 */
+	if (!mem_cgroup_is_root(memcg))
+		mem_cgroup_flush_stats(memcg);
 	lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(goal->nid));
 	used_pages = lruvec_page_state(lruvec, NR_ACTIVE_ANON);
 	used_pages += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
-- 
2.52.0


