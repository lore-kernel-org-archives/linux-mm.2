Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC40C606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=rdciyy0H
Received: by kanga.kvack.org (Postfix)
	id EDF376B05B3; Mon,  2 Nov 2026 18:46:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6696B05B4; Mon,  2 Nov 2026 18:46:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD596B05B5; Mon,  2 Nov 2026 18:46:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ADB146B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:46:28 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A80A802F7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:28 +0000 (UTC)
X-FDA: 85391815656.26.B7092E5
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41C26140007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:46:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=rdciyy0H;
	spf=pass (imf09.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793663186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hriumy7DI4YANVX5f2MdDA/+HkJn0Fptt5/VQcqGvTE=;
	b=8nxqPouoTQvwsqJGNHAyasg7gVjwU3Jd77Qz2rBCdM0IqPX9REWOEgWPzAvVS+qTQF9pl0
	r5F4ajLnYSxLOrUgHDGFTg/xoijm8bbCbOTI+ONCKY+07Z0l8yXjU2eHjZ3hrSx5cXyIsT
	z/ERrq7n7jiuUuIevYL7bJOc8rkCMb0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793663186;
	b=flJQu6GbGJqbQVLXP6MmmiSQBYrn1p1iQMYC0Sy+USeL9ml5jktBEeFA9b0eBpD08qSsrW
	big3FgObGNTuJjVLJEqoomU1FlYmcvaV54QFj+DqiZWsoxHakvoBseoKfx4+yrFXikmwd3
	ALgw4K7FZY8kYH0zjFcecszJwgfi2mc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=rdciyy0H;
	spf=pass (imf09.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-533778ab0bdso51741141cf.3
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793663185; x=1794267985; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hriumy7DI4YANVX5f2MdDA/+HkJn0Fptt5/VQcqGvTE=;
        b=rdciyy0H0nvVYXUmckZFSUCULodhnh8LFNVI2ayo1evNn5rAwY8L4xcVgd7pwZ+VfG
         Fn+nWDZWtzyYi8QQ6sPqqlBQZVncGaBPEctALDZLmzxyMQ5/Hk3hvIODWSA7THXPzJxr
         V76czfP5GA6fkcs/tdbYBjMigiu6/C9VLMsBIXnXVJUJg6w2/3HKwqzbBrsMEW+xy9QM
         0C2N6uOuzvAFDLgo2e6r8q3y2mur4WxuErvghceMkCbtRShjP1Uxm+vk2Sf9g2h7rFVo
         EIhKpF606OJ7eJXGcsx4LfK6RGOhHntljyWX5D1e7juNoENvEb7oCpIwwjVXCmrinxFJ
         kb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793663185; x=1794267985;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hriumy7DI4YANVX5f2MdDA/+HkJn0Fptt5/VQcqGvTE=;
        b=lb9h9TshemW590nBRC+NA7dYkJVJXEP9D3OeYpw60leoDqUCUFMMWKOOR5/BSh8WvK
         zO1A3dRX0juKB3ODbHQ8PLZD+JbG5j3PsoN8tChCnTwUZb6yHgDmZNS1Vc4nRf9oCTPl
         nlT1DAYszpJYj7lGsEeb88BHkFopFxVm0T5mZwIwwCxIJGLkJ7Cf4i69EL69X+gi7i6f
         k1ma8qCVGFku2pCeBx7TsPJjBp3DjRhIyBPiC3nI9mhdees0yYqE/qvthk93pc0o69lb
         8cyadzCXRWYeZizMpeqNF35yaxChUE1T09RVAh+vT9URC83aD9XPECVrpHU1egZOgaic
         Lhyw==
X-Forwarded-Encrypted: i=1; AKwUvBxEXZD1xtdf9d44xZgo+pIyPllnTjIQf3V7y1kgTDoiQYpmONc9s7aMRXhOouAuBc/nUxOhHPgw9Q==@kvack.org
X-Gm-Message-State: AFq9FYKhdgTM57TO2aBX6UGyu8FwjWcZEN3VdhvQtZ2YRG55FRUTJoJP
	VhQutlf3JdbOUCL2S0ujVPWFf8oYFbxUBnOtlmynlgLJ5qiur8n4Gfi1JKGINNKsthU=
X-Gm-Gg: AYBFou2xm1dCIIxtXR030Kb10K1IcVPc0iRWKOW39+YJorDvT0OzULOyVt7PnyzS7eG
	REzjcXfwxtlvzLSEgALskZSW/n5eZ2Mb//cYd666FWOdW97Avn3An947l1Up0rN8sxY6WcOwWZx
	pyWQbCwikVWyd7Sq2TfmTYeK053zBhicqBFc9SJgD7B9XpvLXnnpZ8MLqmiqw5hl9/FezYWBkyA
	GGLBD9sRYMJd+PJg84nZb6cXM4PzyshmJIolfohj3ZEBvU47lTufIXalZtjdTeh+LE6dlRgq3kU
	UFYEgSf1k3GLQkDzUekQujfBXk4II+o3+b5Rb6MpQ++KTz0tmZiv6qUYl2yLt8JaP8WAuijjGM4
	49x68c3NTRUS6WFTCWLzSwxO3VP9ZOizlTQQ0V06ALugfa8dCWdcKSEQxaYFZD+kq+bbJb4VhdR
	EPfpZrcLYHznGOHuK9cVMiyLrKQ55Sqx0kviv8Ndz97bzhez36DCfpUs0/fXxDfdyA3cv9rBHvD
	yIV4nQLLZVw3cZay+0gV7BIvXUygLtHZAPzGLvWmDrnRHuL7YMFWtDcyQ4x9Vis0dymmNdP5Hvv
	zBKghjLoGWEHOPpdHPawSpvQbHefr3KCaTIpyzafPqi62A==
X-Received: by 2002:a05:622a:17ce:b0:535:a5f8:a5bf with SMTP id d75a77b69052e-542b7c0ae69mr212737751cf.63.1793663183377;
        Mon, 02 Nov 2026 15:46:23 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5498c37a7eesm10714791cf.20.2026.11.02.15.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 15:46:21 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Mon, 02 Nov 2026 23:45:59 +0000
Subject: [PATCH v2 3/5] mm/mremap: reaccount on unmap failure only if
 accounted
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-b4-mremap-pre-split-v2-3-d281dd11ad7d@toxicpanda.com>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793663165; l=1268;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=mIckdpbckk76R6ZJ+l1B7uF23/C/RMo6KhccLOZarUQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QDdilLug2fc6t39F6F1geyoXH9rzFBQmMKdmXqBH+bbTXBQLoZeTCYMQVEMwGRu8+hhIli9FPGQ
 v9HdpndA0hQM=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: j1gzbsq8bgs3kp6fiepipfc5wf85z7n3
X-Rspamd-Queue-Id: 41C26140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793663186-956700
X-HE-Meta: U2FsdGVkX1+sbuwo10Sqlg663vmPnKWXxeziSBKFk+clRteSH8Mr49xjsKUVcsTIptrMcRhyIPpkOs4LdtU+QddOOCu2L06CDwnuTx1l5xBS7Mdo8dS9K5Mz/NwwE+ctg0jN8Ii4wPsBHmHc1HeSstjRpRpGr5yqMAFNoenukhDDP1NNFhorjHDqW8vf9qSJqQMIKyzXYfRy6M7xlEJuLqqzq2kR3W+7Q3e0ERDY/hVhfyXvZiWNK+hWgy+INmC6Rq72f2sMSb1F6S7ixUHotLQtFtmHYJRHCtxfSv/NxY6RBuOIC2Afvw7Ky1nk4qCIIuZGSERXZM5Tvc7PFqBDS/+x+eJ7+1gYd53OoUimOL+ckgLKN3xTvw0fAnhkep8ebjkc8Rmg5f9ZR4SqcFGiAlBxUJwNGUFKh1DaaDja2JJwfnx6hdwC3jQfgPi3oxtea1gNaihMYyrG4qfHu8aeiN74x6rtE/7twyOCknntb9eCoqWzlUbF8RXYCJPY/yM6nHhCd2omjUDvOSkWwAnrlRRxCWKh8ulOaCtO5/tuxJLPAo5MpzA8vMtoPaC+zBYAWqCqBmaAdqIADxNnDV+DyMaELpXH/zKgFaPRMfEP8iDknqy6tFmsDtjq+t52bH6BkebcLUIcYKyKjDEMOyuNmsZ5oPQcquNzHtFyr66PrztDQeKTzHQdnocyVk7/laNoffBRtN0wEkzAJ4cgQ+u2CoJ+bnoOpVXCMO3r1U/Qem3ZmDFqd+AIZSQeR1+W87Hd2oncuvAjDZNsrl60LGGgFwlElr389qUu0vUcH6WFWGBVizxSoVRingD/bvcGb52JtrTcWuJjXiEWT3ORuBztkgq4c3jrnE3s4AzPt9EoTtQCfDFEUNiTRVcNI7SzejpLLI88v3SuJNfMe90eHAlKmDr38HMf8xG5BXYdNP7YNOhFRHckYtRhQjN60k4XaFd/tSWZDViAzrhyxKXPMod
 ALZPmROh
 K25mL+KIEsFI6m2Asd/BGmWaHkN7pizzm5n8L/Vj8k9BeCIWigXXULD9gUhW9lV2ixRcfQUaje1R+9OU/gzfltcks1UFtVX/cO9Mg6P8vQAF82iPPU9jlX+XrVTJwRXDrqYJHNBd/KiaEfIgTdb7yp/kvfvdA/1Iu3cXAKRDV9a0NlajdDkAGI7Cc5qcClSpmVzLw/vxgSDLgj1Hkigg6bnySRP7xd6+hpoK1ZNCBf8Frz7WL7eOIuIVyOEcd0i+dx5MqVLSWclZ77ejUwGt8RZtht36VYuQ/Pky7x/7y99beUZTqOz3cpmXcqFkbxnaMuRGXIxW/hvLW7xryDiEku7qSXnrIiIfKmwUmq0T20l438dk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the unmap of the source range fails at the end of an mremap() move,
the length of the range is charged to vm_committed_as even if the VMA was
never accounted, for example a MAP_SHARED or MAP_NORESERVE mapping. Nothing
ever uncharges these pages, so each such failure permanently inflates the
committed memory count.

This was reproduced with fault injection: each failure on a shmem mapping
left Committed_AS higher by the size of the moved range after everything
was unmapped.

Fix by charging the range again only when accountable_move is set.

Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mremap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 5926ecdb31e9..71c9f335bea8 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1246,7 +1246,8 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/* OOM: unable to split vma, just get accounts right */
-		vm_acct_memory(len >> PAGE_SHIFT);
+		if (accountable_move)
+			vm_acct_memory(len >> PAGE_SHIFT);
 		return;
 	}
 

-- 
2.55.0


