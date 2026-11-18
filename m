Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F029D606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=mqiVwVA0
Received: by kanga.kvack.org (Postfix)
	id CAC846B05B9; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37186B05BA; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24AB6B05BB; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B4296B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:00:55 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 014751407C7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:54 +0000 (UTC)
X-FDA: 85448854470.03.0F4F382
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id D562EC000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=mqiVwVA0;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MMjogFi81D6qY4eWtfwaW+AtVc+xlsGL1XsGC1bzDhs=;
	b=43COGWDpeuo9d1DfiLqjjQ0W4fduiG95+XXanzPcygkJ5REpnNpIG0I+mAp3WMjo7RwPp0
	eJoSNLUUQICb3keTXUVvrxr1VV+CgVQaGZhNZFd4oEmMy9S8+R61x4jwpebJ21Gi5d4fK5
	PXFU2EEGUlY/eYwVmowSTLeQlstZYGg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021253;
	b=xabi8POAIoxC1xBGh6/MFoCgmWDa43hEPY2M5o4dAQYPI5BEm4pZGmBV0+BxWwdS/QNCsw
	vqU8dsKh1zAoO0yv0w85XQTjwD9oVQff3+KfIRVCougThZO3jcqPFPHtNZCq6zcCcpayrJ
	e7cMUcCG5hMDYAL9J4W9FjH1OcopAbU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=mqiVwVA0;
	spf=pass (imf10.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f2b8cf037so104933885a.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021252; x=1795626052; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MMjogFi81D6qY4eWtfwaW+AtVc+xlsGL1XsGC1bzDhs=;
        b=mqiVwVA05ANiui87oSZgX4mZYB5RjAZ0EcZfzpgvgA20+ZZVPUWVvsPn8+h6vXN9J4
         mS7F1FqrfLm+EMGEJYETMhB3hW0utdXjMO0+Db/by6XopDrs2b1rQIxdo3s+w8zEiOUz
         6Bl2RkgQbx+Obq4wIuF96KNsp1Ldj+L0BwQe6h+01/O+OQ+U4ypvctD34DyDestJaZB2
         c/bhti7nupGdnY0Q3Oe3uxUB0AMxahp4RtPKKfVxa0T1FomxV1lJ2HQOIr8fqQ8KoTaP
         eKVfEWgNb63AKceVwH/JaG9ZcSDKI+YVLgJqLGdcZq7djMNJEsjTefyG7GYXyaWU3peH
         mH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021252; x=1795626052;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MMjogFi81D6qY4eWtfwaW+AtVc+xlsGL1XsGC1bzDhs=;
        b=z6KkIx4H0mexY5y5jPsZKH82HaPeW2L9GuBB80e3K+oQ1+koXktw7ND20sM63uBVOn
         XH6/UJf5dNUfPCHsvbfX1vgV37AH87TNPKnuBhznUQ5V/apR4GJxhhB2XJUkK2PgZSJo
         nJ+9UOD87/8WQGaXkSwmziL3h/kfeMORK421GPBMY2XXEhVwegxeashrXv3xpuDUn2Uv
         ZzSeMu57fls4qplPxz6g1h0JTHDgI3NRSO/5EoCeC4YaHbxUOYy85V/J+uoLrZTP6gob
         Bli9s558xuUYzwrq6jIp6blhabXUPnBIXRb4Wr4D6aGQNaQDoRJ5+MwWGKPxfkZ40R5G
         MVPg==
X-Forwarded-Encrypted: i=1; AL+hErGETEEhS/z2oUVINgLQu9MvAJgTKqG5QiMn7ZbQtSg1LsY5dfmOqHrDZBDk/v91h9QkVTTVVa6IAQ==@kvack.org
X-Gm-Message-State: APuU4Z/WGw75M+XUgRqmXCO6rAg6ZJ2xoigPca9mdSDwloeJRLJfRBjT
	AgEAR3/PbzmjZQB7pcuNO/Hp0t1MFyt4Wkw+yzUUrRihq5injCQNuciJ1Roj7O3mDwg=
X-Gm-Gg: AYBFou17bsmxvI9hRVgXAcnsTQmrsxCNq49rflLxCffbsOIuAO33Yy3TXs1d/gqcOEH
	yI0c//lKzgtE7Mgvzb7bI3TkouxV/abjCIQof6sAa1DfchOXDlP8nk+C3BK+6hw6RRRxGjdlKAM
	A00xq+PzZ1vhDLqjaREsiLr+dZT2/BnluDZyiahDKAwhG4KQ45EjtBInJHhhfeqay6GPrGIN81Q
	BAjvlfW0busZGNHFlf8Jg4L3QnfLatrgg0dOYpHBbGL3KCJLn6tFJ/JqUvrZ8r36Pe+NWz1oQML
	ay71Oj6YhXUNa38krNK7zDBqOIUtbLDLb+BRpmQSv5qFTc92Y/Je6+GGOGMLmA0fTSEscJhVm1w
	MeyZ25DK0/QiAmuWAus2kR4lTcE5CzOoEfeWjjgv38lFTdhmtUPKWIW9nFjylLwsaNU2HMcsk6Z
	O2Tm6Ztp24BLD8af5s6BNX7CdYW16jMD698FnNvNBtb/oQd02ZNvZEjjbceJcpPL4oexXXQCabd
	RZXubskOqoBBTR4uESVGMftUDhETtoq2KzZ2yYOuIH2dr8EDYMzHUA6XMTsOusHJzM0jtlak2Gl
	v7JF1sVEch8LRq2ZY8TOfVUn7VOUJJLGwh4kAEprcRLt97Y=
X-Received: by 2002:a05:620a:261f:b0:912:1206:ddd1 with SMTP id af79cd13be357-949995db0f9mr581151885a.1.1795021251794;
        Wed, 18 Nov 2026 09:00:51 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b454fa1sm226497885a.3.2026.11.18.09.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:00:51 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:00:35 +0000
Subject: [PATCH RFC 3/7] mm/vma: fail copy_vma() if vm_ops->open() fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-vma-open-fail-v1-3-c8b0209f2700@toxicpanda.com>
References: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
In-Reply-To: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=1199;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=rgo4IdR8BQo2/dvRJ0FsuRLcIIaMK24twJ7uaCyU8AQ=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QMVDhgOTt5XiWRIkOMcc8tLTJAAQ/VOzANP/Flq1CsARNP9IyP5xsAu5ZqAMhoq6PV22hd96eMT
 /wse/qii+xgY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D562EC000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 5mfjm5drdsgju3xdo5h7i7rc14y1rgp6
X-HE-Tag: 1795021252-614079
X-HE-Meta: U2FsdGVkX1/efeKWYHB8F742iNYsU1AW0tek3vnmqFJGfkHEyg84CkSlnAHtIswsXbSMGoTYEwdbt7fogLuYlAvtjTpS1HbA51swRLM6wGUW7RSTVruskTYZ+9rVVGETSRnQIqMiNMihZ+I0EvHMVoRFHHWz7XajIvOJC7mM1YAGU0g+n3SNowQvmj5BXORG4vZ5Lw9l6FwPw6yuBlmVg5RD01/9IiCqVx9IH+nyTo/GqR95RaY2gj3+UeH6rg8xcaqovnmWesdsbwHJll7or1iOYsmW4Zljvyxgd9XDrrRW94hE4pqXOp23dVLKZKrl6xrrpYbuA+7YUHdFmdjVpHN5eL26apdU83pjgR1nvo6LUGJqFpNkxPJrAoejSjSljf/7a/f4KsR0NlCqNO4mEoDO7gXS1z0pSe715f3cuyGTlcHE+as0mjKWu0t+ERHy7PFD8EzhLVs/zccW2ptqmpRsOW1fCaFkBOil7nAN/97XFpYkiUJ1WEvbyPxdW3cfWkyDAJsOT1519QTrYL56n+89Cyy4Fn9G5SzxWj15tQpcFSFfRfP8FYmB3u9wFJaiqxdoA7l+2qFBj2TeBVRURcxrOPHnOxR1Tryy71J63KScOxQGrWRCPoQxw2oyXLnz5dz2KABj4IyRfyAv5i5Omo7AYBMwyZSpH9mnf7DBZ8YH8Pu2472fxh+eGoRcfeqrKSaCsTNC+YNVT1ynR5AFKzWNRxVSN/SzxJyui2WEoMiV9MQ5XpelTvZaVaQGo42skk3n9f6kAhfjxo6wDC0nza6Exvh9AePW0eFl9gTMid8tFLSYIEtjdInBCqeaeEiuABWgBs1p2kCn9bQEK+YxsHdhLQeglg36cTrZxykNKk3OcbB5GRIDgBKCtFiReHCjZ6XDKKa5Ctj6uDzUjYmwtymAWzK52SXbo/OKwiOttejCZPLECwecJ+2Kp1Nd0ie+tfVyffK30dehzEaghVw
 0BDN2YKW
 enrBsJ3ZS6AdL8KwhuYYVFucT+dmU8s//htSbDSdY0XgWj0N8fgl2N8rYO8IBlZSMob3hQIJnlPXAPUomDSKYEBNntf9kaTI9dGmDGeINO9/Fbh1rtmVgSdhPMDrRVtCP/J/wuQ9SEP+La8SjDigIK5YYPduIb0rP6CY+jw6Qn+0/NKszgce/W8Sb8XcY/b1KC/WuZwKeKtzNI7uxEeIy/7GBC33VkrpvFHYRj6+VWrjwv+4VYf+g8IsKcQk3wnv3sOObtE6BgIV3kgr8cfVEzrLYGDdEp3vnLN2pHS3A/r0KQk+X3ENJKG3xjYY4R0Mx2DLk38a6iSmBjyDPhClOtwgVe6OPwdN4ei/0wkd0goaNByQu6OTbsRSIOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_vma() ignores the result of vm_ops->open().  Discard the new VMA if it
fails, without calling vm_ops->close() for it.  The caller reports -ENOMEM
for a NULL return, and the page tables of this VMA haven't moved yet.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/vma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 212c2497bad4..b2e897a301b6 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2082,10 +2082,10 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 			goto out_free_vma;
 		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
 			goto out_free_mempol;
+		if (vma_open(new_vma))
+			goto out_unlink_anon;
 		if (new_vma->vm_file)
 			get_file(new_vma->vm_file);
-		if (new_vma->vm_ops && new_vma->vm_ops->open)
-			new_vma->vm_ops->open(new_vma);
 		if (vma_link(mm, new_vma))
 			goto out_vma_link;
 		*need_rmap_locks = false;
@@ -2098,7 +2098,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 
 	if (new_vma->vm_file)
 		fput(new_vma->vm_file);
-
+out_unlink_anon:
 	unlink_anon_vmas(new_vma);
 out_free_mempol:
 	mpol_put(vma_policy(new_vma));

-- 
2.55.0


