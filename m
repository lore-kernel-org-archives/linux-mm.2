Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5397C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 20:45:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49436B0092; Thu, 17 Sep 2026 16:45:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5FF6B0093; Thu, 17 Sep 2026 16:45:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6EBB6B0095; Thu, 17 Sep 2026 16:45:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9365D6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:45:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2E311604BD
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:12 +0000 (UTC)
X-FDA: 85224434064.19.EF26BC7
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf23.hostedemail.com (Postfix) with ESMTP id DFD1B140007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:45:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kPnl2odP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3VVGsagYKCAY24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3VVGsagYKCAY24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789677910;
	b=TlDUY5cIzpLceeMALMoDgmkcMvf0xBFRXXU80W+0fWqSnedMs929+AXEsg2L34Gh/YmZ30
	4ilAOopdDP4zD+flBEqayoUNcFRg6bQSNKLgMfKRT4ofqF5KgoAxyCMZohjhuD5vZ7Wom3
	XUPEdTPzs7EQbsSq3Iw4Kd3mXpGQonQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kPnl2odP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3VVGsagYKCAY24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3VVGsagYKCAY24ongtmuumrk.iusrot03-ssq1giq.uxm@flex--wyihan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789677910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hoad39omJnatpjgiztoN01A08gT8UYIlksvJjwoC6QM=;
	b=FBRNzKv8R5PkDdpljYPQec5T/4HiVznGqFh/RVMKergTS75erGxkUFRIo+/Dv3S+PEZBwz
	qWOvrolEG7Cncv8FjyoleH3Af3+LgW03/SUFxDRgdZ6E0QDAxl+oLb7sPMURc4tMxMXl4C
	iRluUr/nHoxu+2jCGIt0HijYB7n2dwQ=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3965ba1ba3eso86257a91.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789677910; x=1790282710; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hoad39omJnatpjgiztoN01A08gT8UYIlksvJjwoC6QM=;
        b=kPnl2odP5dTzQAqJfn+Tr2IIddelVgftf2zf1HcHczSQ4O0cyWbVJZ8FVA7fmsXwdO
         oLjSNEV0R9aM+4YnQs9f1J0zyfAc1UqCW36pxkPTdFRbSX2fDMabCdhOY+awerOkRZHC
         UsZpg6cuCIbcNh2ruPtoslylDekA6kXwIwD9NjaxQF3U4MXwwa1rqxwINfkLEfxcdb4S
         F6Wg6+6hs8o1nYzyXvIZwAY8vmCz3dz7Us4mb5FkxzVpHi49IMOmiO/SuWs0O5rfdyrU
         tu5Jch4mjCCGkQg2kA/22F7tBYghscQflJS/KalWXvtLiNLJRTe8X+hY1crdFJZwNcvH
         9gog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789677910; x=1790282710;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hoad39omJnatpjgiztoN01A08gT8UYIlksvJjwoC6QM=;
        b=YxnDul5IGAeJYLLt6BEFrxnUg5/XTL5sjqO3wTEjDYc30qYFbFSdSiBnoMX1FOKShI
         yycawvq160Zl1FtTyTtu0UTI1AkyDjrXXSmO0c1153gjM4iUOXQwhozwWOPxHhyXXEQm
         M5bII0IKcM00C/UffJRcJ1pWmD2in0oVpRBkZEUDYGxo8K0QZwdGr3dJ4yRyBpzr4XB2
         by+FVV1xEA2x6ZPGZScuUt7SxurA8aqq598GnOX/hNmI7yrOzloaeBDBMZkmE112jJR7
         vpC7RGpVD7dXaj/QXEHiye0LFr1h/EdQXs+YMaZAtoBWXu108mYipg1/OJxt0WXS4zSR
         TXjg==
X-Forwarded-Encrypted: i=1; AKwUvBxgD8x/zA9P+gBr9qfvD7l9Y9vhtP83cxO0Ay/gm5JaqRhJ9b2BFvIlai6jZTMbP1Rwt10Ga3z3wA==@kvack.org
X-Gm-Message-State: AFuF++kOFia3UQIWyeY/KyiaigLH6AQHaIYt35HexPisd2+rHrT5qPAn
	3EHK1iA+FmuvO4rJaQ7z8uowwiCuGwa3CN+YOY5eRBeImpfK1lu1KSSi0WJ0a1zo23yxE2lH55D
	WB9keYQ==
X-Received: from pjbei24.prod.google.com ([2002:a17:90a:e558:b0:39e:ac:d0a2])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:224c:b0:39d:f317:44cd
 with SMTP id 98e67ed59e1d1-39e54eab3dbmr1101051a91.14.1789677909569; Thu, 17
 Sep 2026 13:45:09 -0700 (PDT)
Date: Thu, 17 Sep 2026 20:43:48 +0000
In-Reply-To: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
Mime-Version: 1.0
References: <20260917-memory-failure-mf-delayed-fix-v6-0-4b00856b5364@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789677906; l=2010;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=AkbxLkF/+nAmGEf9KgEr5gQ3H9mZvwt0D27L0+zaegU=; b=l43vikXXPWbiYd0vKIvQqVDarn1Ty3l6Vrm71axmlmmBFUC/OJBsLcDslWeQrnqbkktxP00pO
 rxclAE9wwFRBWLRaf58fDlGZj9/LGabzo7cne5Pv9ImCfAttWfE42ZJ
X-Mailer: b4 0.14.3
Message-ID: <20260917-memory-failure-mf-delayed-fix-v6-2-4b00856b5364@google.com>
Subject: [PATCH v6 2/5] mm: memory_failure: Allow truncate_error_folio to
 return MF_DELAYED
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, 
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, Rik van Riel <riel@redhat.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DFD1B140007
X-Stat-Signature: 5nnc99q9ppawt9w7hbi5u35eta3ccpy5
X-HE-Tag: 1789677910-20787
X-HE-Meta: U2FsdGVkX19XZA/f9UENDFujyau4pUzafk2x4xDiWk617ZpNbrABgyo8luz5UJJ9VQ81UgJMbQVCobOuaQTGJjsuh7lTkis8hq+roT+tPd4VDofFbt0pl3aukcqK3Vq8gw6omS+aQpboLNo3/2OnQRoI5WEmTpz08IkwmiRYB3VyLY9QsIpcgTqMq4CKmo9tcg/c3yqHIcSjuOwLgYau9z1yRdjYKAcoY/hcyvKjlvCFZDCPUe8hHIPhawvAKnNrsaWwsTH/RbzqBIbkukXpTR87Eh5/v1ThHTw5nAB+8QwQyBkMuxxeyRnVrCP3kilq5FZbgXFP9xuASoWgRjZeuWEmPzvRrV1HYGnRw6gjb+VumvkT9m09C/kgbsBWYBKcj3y0F22So/jUjtBTRcWKtVL65WqsYDrbvr4VqKgTr893PEVbKyBi5Wb4gz+5sETPKOYI0dSYND8u3UlDVjk8UdtopEwcylGDa3Z1pjEB89ebsbB1Wc+u1+y+PuroVCMV6z31bYto6O8Y3PnCvgN5WeBg9kCDG01luWdtJ+J/N3ffDvrHGgRGhhm4+pQ6zZMJipgVMz4QOHzcvYrYdUF9TQejC+dj3shjRkjysBP9RYXIBjDvwFDFlTDm09MgDtXCpn83OZ6Eqgfh27SZnTstCHfUAAVYLihPCZAzF3zrFjRAKFkq3oXENoUhsTtg/ImaRMpFBsnlUtXoQQmQiZ3L1Vx7z1/yWPYVTsocRpvzezBlzKRgd7ysu0Bn3ZngvzBJiRItO4DOC+rWbr7/bsfOjW6GT3tJRyaxVXcAPcDkajDFUk0YyShD3elZQmFBBrL3Tc910X/uIpKI3fjAPSljbqBK9tTkQJZDvxP+KFl5fMvOpPxlSihR1ivG87352oZyEvKdwn4+I28bqdqxg8GaXcNiIF3oRuaQMQJMLcwglHm5u6cSiDnv0pUs7zvU4kSXCNSO9x4Q8lvwMOpW4b1
 jHR5isV/
 oBPumcZ3qOV+yKA2Hjkd1Z6oK6hzYGc6QnUnUpYYJuwqWQQ6ienY4uv/iKNXEeJxJJOiIfvVUWlLvS7r5nHUcAPCgvvhnJj8emghGGQMy72ydWBD4x5ubpM5U1p+Ic2NtM5OXtAxicYIGW1E009sYupxNqolld0+l3Jjx1j+tdncD3QjmVnoQZfVz3yqAcBmzaRbkaEWXlb5LaZEr+5PmzvIi3esyY8NzCXZ6D44NR1S4tUHiwrbXU0OaL4CVYdIwuH1f02KzsUC2LvP7eNDpwtQW89z+JlltTgX8Mbctv4uMfNJjEuaxGGcOKSQU6I+R4B0t4zLSnlKCJoeUijEtoTSZLelm/nPVgqKZWc8JCKnckTLAtnxVSICbPoQkh0yFXQXmF5mZ/oX16j08xKr+2ziK6hF8OC1hHmEzz5smqzfVF31+LyFaTw3zF18AD/E0h7aMwgliH9tzJ7Ay/k5weltejKGMwM7H2f55DHYPOak/LdIjFpJFFlMoe1XkEyeb2C48X4EMXiJp06D+hqd46Tkf0Mv9k8NzpF8GkQmiykkfzXPIsTPuq9c9uZ4De1C7oYDvjJb9cG+XIto/I6iaGCLlAvYCdXGgAZE36WQeWTJgY5/AgimpxeVdI4/r4AEoFZV+cn3kp1h9Md3U9rMFIlNSB1bEOAUz9yVM99z3HHqmK1KVQWQ+RfWsCop+j5qTsLcknvAwPBd5NelRwmcKsGtgiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The .error_remove_folio a_ops is used by different filesystems to handle
folio truncation upon discovery of a memory failure in the memory
associated with the given folio.

Currently, MF_DELAYED is treated as an error, causing "Failed to punch
page" to be written to the console. MF_DELAYED is then relayed to the
caller of truncate_error_folio() as MF_FAILED. This further causes
memory_failure() to return -EBUSY, which then always causes a SIGBUS.

This is also implies that regardless of whether the thread's memory
corruption kill policy is PR_MCE_KILL_EARLY or PR_MCE_KILL_LATE, a
memory failure with MF_DELAYED will always cause a SIGBUS.

Update truncate_error_folio() to return MF_DELAYED to the caller if the
.error_remove_folio() callback reports MF_DELAYED.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Fixes: a7800aa80ea4 ("KVM: Add KVM_CREATE_GUEST_MEMFD ioctl() for guest-specific backing memory")
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 mm/memory-failure.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e698d0e9711d..37ea23489b75 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -939,10 +939,12 @@ static int truncate_error_folio(struct folio *folio, unsigned long pfn,
 	if (mapping->a_ops->error_remove_folio) {
 		int err = mapping->a_ops->error_remove_folio(mapping, folio);
 
-		if (err != 0)
+		if (err == MF_DELAYED)
+			ret = err;
+		else if (err != 0)
 			pr_info("%#lx: Failed to punch page: %d\n", pfn, err);
 		else if (!filemap_release_folio(folio, GFP_NOIO))
-			pr_info("%#lx: failed to release buffers\n", pfn);
+			pr_info("%#lx: Failed to release buffers\n", pfn);
 		else
 			ret = MF_RECOVERED;
 	} else {

-- 
2.55.0.1082.g2b9226bbc0-goog


