Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77CB606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=eL7T0eP7
Received: by kanga.kvack.org (Postfix)
	id B9B356B05BB; Wed, 18 Nov 2026 12:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B252B6B05BC; Wed, 18 Nov 2026 12:01:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED596B05BD; Wed, 18 Nov 2026 12:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 658D96B05BB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:01:01 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2427512080C
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:01:00 +0000 (UTC)
X-FDA: 85448854680.23.2F24CE5
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id E49E980003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=eL7T0eP7;
	spf=pass (imf02.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DIZNwWT/uvt+A6koRQpqLPE5GQ5zGLmOz3JOqcv4seY=;
	b=ciHICUo8QjlEtk4h/PlL/vmMgp/j6Fbw4zjDLIt0mpZyZzbGqaC8VpBPSn4w5oAxnjl+G8
	ASFbCobV44x+oS3YS7/sgr6BchPmVKAXSzUR9Jw6QNoXXTUIh0Lj1wOcEQqX2m/wp7otM+
	tq2x6nydBTWXqyfHjGUPW5KGIiDlFzA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021258;
	b=NV1MbpyV6/1xf830xSlxJi4mxBBL1GIg5TGSoY+s5O5HDGYcNg9P6tFKgtxPUibJqwkbb/
	lCJN237vUBwImy7t2jNJwl8RIx9WZTtnhnbSfbantyovySn9ui0+P9NXFpfl2oH/37xB3e
	GpA9G27pEZCJ4WXmEocpvYToX90j2Jk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=eL7T0eP7;
	spf=pass (imf02.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-930c0f9c1b1so136968985a.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:00:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021256; x=1795626056; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DIZNwWT/uvt+A6koRQpqLPE5GQ5zGLmOz3JOqcv4seY=;
        b=eL7T0eP7GCkJLWW8bZ5egVXrcGTUl07TgLxTQNjT4De6xNOSPCnCBtApqzyrJVgp8K
         0TViovRLB8QCW8N99HK1TMKsiN2pb8Y/RroikPWg55LXGlL/4rPFuMe2zEkkSQgk5m24
         7IUdGOA7/kYy25bBOin9TM2JfeeSdMARLuzrS4DUdIr2EqY7ysQomAZJY8mQ2SG9FY1u
         mNQpXivzF1Okw3Du62s2AAwFaHKWH9S1tD1cGhSMWN5xDywXLTbibMDXCoNritWxM8cU
         74dkk9T/N/BfbvVys19cPhNnGyjYJyP/ktgStkXbCEcPUWd8zufki64sSRWuGtNXmEsP
         BwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021256; x=1795626056;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DIZNwWT/uvt+A6koRQpqLPE5GQ5zGLmOz3JOqcv4seY=;
        b=v5mX2LeXpnSvACQsySQhIJBLjCuNkDqp1ajE2biXRBcl4un/cBP8eBVirOzvOe5hd0
         6/uly5087e69BS3W8znLJ4EA/eAHIAr8zY1Gc4kJ360tVU6TfgrKMZ9FLW0e2jY9/1xz
         6SmoXv4f7m2IIKUW97gmUS1I/uIcWit1LqVGttZ4WfKfMdngNaGJw+QlkeQTl2bN+fn2
         js7oYEX1NLjAtJaMAD99G7ayz8cM+eeSrFxMfAgjIAguWUbHApV1XiJbTF3W30QuN/yP
         hYv9G+bLl9ydG1itfcu6CPocdnqMvXqo2QofOX0+5I4zOtTzog9H6JT6tM1zyhaTo+KC
         TTPQ==
X-Forwarded-Encrypted: i=1; AL+hErFAcbZBbaxoRv2Q7VLmNF2pyGMDFVuuBPJM7C+brj8FQTBMw7F97brATWCwS1nqCp7bXFCEw4gE9g==@kvack.org
X-Gm-Message-State: APuU4Z/XYRm2l4jvE68mjAIH9k65Oozhlye7w3uaUkRDolKn4V38ZXBN
	6ChU/JxfQdvwoQwPMJj8jKfYNQCx0G7mtclFFslhRfcYO1ogRgU4SzSJ78PP/vx/VPw=
X-Gm-Gg: AYBFou2KTB68rFIvaqbOeDKZb20uPWxbASgFLG7e7kGfERFHpTmBhoqKUPZhYZ5Xyid
	ZZUn0MSXks4544LWQUTpPkEQ5AObq4xlazgIXUTgRoCO3F3e9BLhCdJOlLGdpuaUmiVCq+C/MHI
	JMtajtARBrB46BhdjT5xtOtribAGWbGVMm2mOdAfw+86o4w7zubDD2T/2b8sGLl1tvv3g4wxcop
	bg+X1d7eUxLefYNT/qFilBBy0+ST8ZZp1DQgBqoux1SRQYW6RwTdv5s8oXN1vL75KWleZLz5H5a
	25m4oDuUhvzrOrUrczTKfBFxT7z2Oj2NBqLiJ8Zv26WeC6taL0ge8D5HZPg69rKe/3SjVKnOows
	zEJxc+8xe1bUP9VrmhUWdJnHSQoUVP/l+vNIU2NiW3ytgtpZrJkuKvwzju44hMh95/EbUTHpw+w
	r4etwuJ3QbFWj4aUXq3pn35MvT5WzQmHeRhmYcHaKLg8PKajezG8bHT7ccgfTHCZ1TIaGFVYvZ4
	/yf36Bpmo6gzHCEl0lUc8o6ea13SFa2ZpKGkRlAiW11dzYaxR0Y6JmzPoJBb87x9+9B7U+UxEM0
	HAbDNhWJpbIOAbCOvQee5EBrUzdaHE3SHjEw3zpkjvtsDg==
X-Received: by 2002:a05:620a:4556:b0:93c:2c0e:7ac with SMTP id af79cd13be357-949995dced4mr594443385a.53.1795021253478;
        Wed, 18 Nov 2026 09:00:53 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b7b8444sm224085785a.31.2026.11.18.09.00.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:00:52 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:00:36 +0000
Subject: [PATCH RFC 4/7] mm/nommu: fail the split if vm_ops->open() fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-vma-open-fail-v1-4-c8b0209f2700@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=806;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=l3sGtJSsIXUNH1LtH48a2coOOhxjekJKvrVexVKAMZI=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHcZaIXSGRJhSxFOxiyyffHTmCXKS66517lCKxCfp4sxEUj3tzVms0eVrNMzOCq8ZpgxaXAzSxn
 HzhmmrBDt7AE=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: ryma3hgdbni3offjrnp56ezo6qgntmk5
X-Rspam-User: 
X-Rspamd-Queue-Id: E49E980003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795021257-883673
X-HE-Meta: U2FsdGVkX1/y/5nH5/NMBxayN+vzvoJMxXCOcbBoAQhq9Jo7EimXLDRJLcDrsqOsszftS4TOdpzx7KWTOoHX4MllL3HJ5O4KPCDM0P7Be3ldfiGPQ/+j1CZjyaSNY4Kgm+BQA0Vn4bNNtynmtc7TaNjwnT8k4EcbZty0olgHSeD0lCf98FZswIlO6/1bdwKxwNZI1h9Vz7Y+RQxNEkMXIjvmhxlSY4Kb5r68bjytwtqVjLL365cpB3pVKjTunWU1MzRCbDOldMKUqSjb5X4Hg5St5uNzZGTdTirt2RrfnFXqyDx1coY8vwumurXxZHeCLHy57vZzvFTqhfa9O5v+7fGQ4Vj2oEp2b7vHIGC1ALPn0vheYw8dMdnHL1dCjOSHzxJch763EhFwtfj01tJ00hjnt337ObpmjhRLXdWLnligP1xY2yQd5QiK6rJHT5x9XV6gd72WH1eSn8siVUCAjuhsRiDPY1CjNj44dxoXJG4AVtaouPgsncygStotzl64eNtl6EjziFcOuLbEBV9d8OJ2rdB8TtHyjioYbpO6mr0NZK1ZmPcY5XAKi8pRBMTeVg8ONEy4zHl8xv8g+vYh1s6v134bn0fX7mq3q4/yUmcnOyhx5jEJVqSfusZvYGaL3VrAGbClLsFpwU0fCmR2xk+WnPGhrmM7n993fR2TwqrPuXOiDFK9axsg/fU9JnJW/3j3b1LhHz4VIUHwoWyUOJ0Zqyuw1sgNqOxPF9Ep7W5CaGZc6XlUIuEgMSTJNEOQebDx3iqMRSs+EaHjSn+80jt+WKJU4kc+lIcm9RZXNYNY2X8nyDszfdK7VyGXP2sCLKLUu0AdaBEXYsIOiuZnX7e4dCBQQgPJUpSvYB9l6r/cSMrlNfDghrvevY0l7HG5MDwha3LIMaHmFjae6a0uQdqrLmkuEaOoijLxsHSmioFF3CIMF4c8r6aetBETVMRW7SP2xAMQOT3ZB9K8SRk
 o2JGyaoO
 0bW4lahjrfSyMMgWcYBjqx2kNEIlhn7vKMhsPgutt0sKAPfqjmMz7j/L+9R5+mF/V+oYjBMfQty3PEddjS32IdfssguuC1Ajhe3o3ZeoXkrU1sLX0K2/3JNf1/n+ab1nDVnfX0LKiqbo9U9Re7TKjGdf9zDXIInZWX3ikSQSC92f7rQ1rOpq8zf2FeunRxGkQotpasK7RRL8TVcPdKWXlUbIWNRw46ylENa9/oeudjQP/AKmWyo5ssTRnKBDJxQdDQQQKIQ+7nZdNezg7Qj471cBmSvR1OBxAbIqPv5Wfn7ZtlatEBMtoP+7aBLn9Pl0gbjuvXuZSW6VIO574jFg1s8Ss9wwp7Ms0QyBEkZ80B178yqryRQQoXLyCBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The nommu split_vma() ignores the result of vm_ops->open().  Fail with
-ENOMEM like its other failure paths, nothing has been changed in the
original VMA or its region yet.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/nommu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index df99495c8902..cd4ebac74dd2 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1373,8 +1373,10 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		goto err_vmi_preallocate;
 	}
 
-	if (new->vm_ops && new->vm_ops->open)
-		new->vm_ops->open(new);
+	if (vma_open(new)) {
+		vma_iter_free(vmi);
+		goto err_vmi_preallocate;
+	}
 
 	down_write(&nommu_region_sem);
 	delete_nommu_region(vma->vm_region);

-- 
2.55.0


