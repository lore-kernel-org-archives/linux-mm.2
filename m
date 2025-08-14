Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6963DCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16C09001B0; Thu, 14 Aug 2025 13:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6D2900172; Thu, 14 Aug 2025 13:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967859001B0; Thu, 14 Aug 2025 13:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 775AE900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:12:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43682B9FE7
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:12:04 +0000 (UTC)
X-FDA: 83776005768.04.8F644CB
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5C6B88000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:12:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcbH1kfs;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755191522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEOmhYbmmbZuNpyy36AGBb9lWDhr9LiPjyclBKHeUw4=;
	b=k8XHFssei4/dA1UvNBVUFb9wd9aA0KF+Ggp1UMhT92gwvNSeO7Vemrwc4+Qk4O+Ei/87RN
	kEwBO/byxgGeRqNTz0zah1dhO/h6p6jJG7gvq27rfAfSrUVrF2lb4OJenJqD5OYho6amb1
	D3ueC4Ns/1QfGb+m8tfotZfLkeeEmXk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VcbH1kfs;
	spf=pass (imf30.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755191522; a=rsa-sha256;
	cv=none;
	b=3ht6o54vavf2XgsZ2r159p9MNsGe+orvgkC+P7j3Ci/acJkVnVCpFkaILb0m8t4CdwSnT2
	3jfWlC7GT0mRQ1o8MM+5oAk+Vqla4OlhgL76KQs/RwM30nFoOaohktJASJ9yD37L0QJN26
	xSbXwlpq2/cW+Doh/JymjSyYjaLQj1U=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1b004a31so8230335e9.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755191521; x=1755796321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XEOmhYbmmbZuNpyy36AGBb9lWDhr9LiPjyclBKHeUw4=;
        b=VcbH1kfs5Q83JPjf+tOMvsZdwnPXHuRWWvpAhY+qIzWVnm4ZA6mn9EzIuCCwNcIHoU
         jsbJM9FuNEW1UQqmtlJil+EXCKpU322ziUwTnHHlLVJ5LyHwhuwxVnwr7LlIhVW41bFq
         /Fw5ShpdOPDhfbOc61i2bEU0uMwz7GB7K0nIVwuH/QlifRGy3mcTbTEsqJ5SflKBBz8C
         m8Ebl73hgZauy9JDSES9Pjvu3e/DbvDwBJVsKeI/Sa+iY6qsgXxavVxQoKjK2SPfZIY9
         5FyVZNrZ9Ndgf9tSpilvYegLjM0j2+TV/7V1qnskHrtqeuN86zfGhCPFM3oyENX1GYCe
         sTsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755191521; x=1755796321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XEOmhYbmmbZuNpyy36AGBb9lWDhr9LiPjyclBKHeUw4=;
        b=trM2YTXznL0GMCWQvNc+qoI9sHYOncpdFkVU16uO9dsTA90AgK8eQAm5yZzYoWOJJM
         7xtGybaagjR5c7etqw+lfvWjpW1FTIOGDIlTebnPqD6uTIHIAtlULLh4kBThPcEgz50r
         zhwX/jjeDqKlMq6Qv/Vm3JjWzg28VLozhYnk/kaH93GlwZ9rZNqJjXZXy8bqXF5hXyBd
         wy5uNkFAhIUtw+2540kPTjnlc04WdEdPzOcHBq745jSWViTF2ygSPUdmcKXPRLh2qupF
         eDBnXukEQ8wrqxSOeZasVEPSJ0MuVzAf4sU1TKXQ+6QhJ2OUBsfQMXbB/gqviqjHazeF
         owfQ==
X-Gm-Message-State: AOJu0YzWgIMFutzpKVuhzcF+w4Opal6rYjK+EFxp3eRb3fQsrisu6nvU
	YKyoIu4w5bglIDdGzsqHUNQ0grTd/f5WWW7VIrOW4UaQ5TMEsKiMGR4B
X-Gm-Gg: ASbGncsS9BQMQ5VBC1jQFTWoa5ZbdtbwZc8UmCuzHQTF/Le9OkCDjriZQg2hABjY74j
	742oLcEwaNakuSTn50xYmlhKMHfG3wYK/ECdjohCqKaRIUs/7k9bmF/wCM3eEPIykGqZcvJ/RoD
	hVpyZ0lfOwbThqFDXdeaypWzxUKcZ/HT3VioPB6Odvja4zev783MJIpYfklk+M8SobLGiMB6PHJ
	XHLQyLWvLjoWgzF54pi5EzbC0zYMTMlwx3faNUP2LAQywkIxPhbtEvhl6gCUleKR/eSS3C862TX
	XG3oTPVtmIoXHZ6GEd/u/2yp/Vv42jSu8APVuH6dL/6SKZrmlJJSE0H0Njwr7lLUVFQ80WIlDVL
	dVuLgElHL0UrouoA=
X-Google-Smtp-Source: AGHT+IE9XhyoiJxNDkeztV+vPBU9i2mKI8X8ueavbAWcAwwxIPz9l9YmLwBZfHxoWjPUVpVAhCuRFw==
X-Received: by 2002:a05:600c:4e93:b0:43c:fe5e:f03b with SMTP id 5b1f17b1804b1-45a1b668299mr37616765e9.30.1755191520651;
        Thu, 14 Aug 2025 10:12:00 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:43::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b91330bf7dsm9158590f8f.28.2025.08.14.10.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 10:12:00 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC 1/1] Add memory allocation info for cgroup oom
Date: Thu, 14 Aug 2025 10:11:57 -0700
Message-ID: <790da5ffebf18a5a1211ad8dbe4e5b4a19871408.1755190013.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1755190013.git.pyyjason@gmail.com>
References: <cover.1755190013.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C6B88000A
X-Stat-Signature: mn6zqroxgioys3torox517jn654e7hzo
X-Rspam-User: 
X-HE-Tag: 1755191522-642156
X-HE-Meta: U2FsdGVkX193D+vF1W6RlgMQ96mPet32jqy/iO1CPAgNkaqSTFv2EjAF3lMCHH2parkYABj77xs/zHuw2ZYGes+VmrLM50Lx/5432OTLCwX4iPrIt6EFoyat76sYAXK4XH3psHs5MhIPyRWxC/0VHHnNOwxP6FYLFLfoHimMOxQFwW5ZNM1AIvxwCqBJsevBMWnRWFEQ4hC2Qy4Z8ObmjSiGLbunua2NyHNqW0+PpTfD1vnG7bQpAUVg/l3Bcgp0z9JBV4bAkMlMi3401OVyfUnNOJfTXXjeVZ1e/lSu7sy+LJKMN2a/0vjd/7djyJ9KyKyoCOjiNYX+w8IBNxr2SOdEy8cXsayZpi3VQQbuxUzJ+pH4ze6v5zegz0g0NLtdX7qCw2mPwOJyiH7H+hEN0ACglacDehQP12+atH8pUP2zyToYi+FEvJqwuT9dn0A4JeyUu0JH8kfWQqJXL4xxfq/vdeKxPY/GMAovtybNimhuL04gQ3sxuDgDOQEpFkPCyF/0/WwpIMpfkgNzN6P/4fjNttyWCZTrEMXiMv/Djp9SqSM+bI/3b07YDdWGyOMn6KrjtqqvqPZ1qLsnx5Za6xqgnj9sWq+UnvReqIt+fdRMHKgytWu5/jXWlRI/Q1slw90ucMaJi4oGjhUo6Ockssljb65fi/ijfrG3X0u6HfCTDCEqv4Qg4JqmKGeDnLbqYyy6uInqf5MLbPWhrPOsfhqCrZOkBMV7/iWLllXC0gAPhhRti3KaKzJttCl5e/oIv6xOBWkX8sABy4jkTxj2w1jRsZ4spVFB5SKxOfN8hZ73Jv1XwhYQ6ddhYZVovBKs5IA1ZENNmC3Vd4IrihiO05NiScawfegu9Uc98Xe6E/oKwYpI2sqy1q9+f4K3FK5wPzody5jP3L8BThZrtYnSeZXAVHDRtFGxhj65BmQT6vkTr/yfi+Le+6PUWyKWqVbP3n8lAvCJf9boiJned5a
 BHbsJ5/i
 ddIcAWhg6OA1MCUh5tpQpca8wxMnN3DgAf/wmtdxn1AWAIrJ4QFJ/LnGHg3oZl2AdxSobevykM5PCoe7mZCU0Q2xkCkOeEhIHfh6ogt+nG6xjN0zvQuMPrO2CFMViIwkp1jF96A3nu0xDQUlhSN9qrow3DpLlI52Jte8sHRMBL24ZPW/NobrJ4x5UqG79PKPi/sahZOwQPEM5wzeJ5RXg00v3jZ7EUj6TOGVGv73KC7YZAKOoiv8jSGpEP1Lu8Q73EGBt20CA6jty0Su8jFURCI3AehKjjm/FFGJ3vc6B5V/PmrxLZbXRR3fqHxa+kfrxoBr6502g3scrQQJG4Pyrdn0Qfo2JmXfQYLA3bnMmGie9I0snXCvba/WN+5TjCqFTYZHIt+/jLPTihLwICSwhxDJ/VJCeHJznjVR2OabW3rPxMTNAohGWWWxVz27/PClwP1PLKLYaaQGFJ5kawQOizpn7Sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable show_mem for the cgroup oom case. We will have memory allocation 
information in such case for the machine.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/oom_kill.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 17650f0b516e..3ca224028396 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -465,8 +465,10 @@ static void dump_header(struct oom_control *oc)
 		pr_warn("COMPACTION is disabled!!!\n");
 
 	dump_stack();
-	if (is_memcg_oom(oc))
+	if (is_memcg_oom(oc)) {
 		mem_cgroup_print_oom_meminfo(oc->memcg);
+		show_mem();
+	}
 	else {
 		__show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask, gfp_zone(oc->gfp_mask));
 		if (should_dump_unreclaim_slab())
-- 
2.47.3


