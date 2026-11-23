Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FE2606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 04:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ADLjvpxs
Received: by kanga.kvack.org (Postfix)
	id E93816B05BD; Sun, 22 Nov 2026 23:12:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1D986B05BE; Sun, 22 Nov 2026 23:12:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8926B05BF; Sun, 22 Nov 2026 23:12:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA766B05BD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 23:12:20 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E126F407E1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:12:19 +0000 (UTC)
X-FDA: 85465061598.19.86955DD
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by imf07.hostedemail.com (Postfix) with ESMTP id 42D1C40007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:12:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ADLjvpxs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3IL0DawoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3IL0DawoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795407138;
	b=tP2LzXVAJqKR724WpJrNMq73SvpdgHIvVemwB0q6qRz5wbH2IBIbLoDnLxnX+jbL3j3s6k
	r+kRqubBzS9cZ2JQdiYoqY+VqHEm5P87X7Ft+Vf2CVyNFlpiJnvE56EldPOX6QX9qcfYhq
	K8kqV9NhXzQpYZitNBcD+tNLUhq6MA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795407138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LOCdAV3cJyqL6wWWxU6d+kY0++FuazKUY9a33GDOhyg=;
	b=xe+P4AJQ47horDSfYkr4kObZrKWQ1vrXR8md9O/MacrwaQ4dmZme2PxCW8SeDJNPtcB8zm
	77pi19NOLPVzyEfsG+wfA4CsvQWWu2Du+curJvdmpjlhL+t/aqDOQ17RkOSwdGxLkhqfch
	DKwKrPg2CyC7TVyFiI+dtIHPMV28Lj4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ADLjvpxs;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3IL0DawoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com designates 209.85.210.200 as permitted sender) smtp.mailfrom=3IL0DawoKCAkwruj74jr1qpxxpun.lxvurw36-vvt4jlt.x0p@flex--nilayvaish.bounces.google.com
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a01e2962a1so2315077b3a.2
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795407137; x=1796011937; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LOCdAV3cJyqL6wWWxU6d+kY0++FuazKUY9a33GDOhyg=;
        b=ADLjvpxs8XcgpV/jRnkQEgC/OPFKx2bVKxF2wnT3hQbs8Y1fIOrhH4L8+0+XfiD6yc
         LmqtxiWrrVJ9cTqmzWvmk4/KVarAT4l46x833DF3jxwG5wYZIQVpsoUEnCgp8c7aRKyN
         IK6L1jd5obWzIyp0iJLEu+H4RXpFTtVMOllH647W/ZNxNjdHrS9z5EfOykeZqg17c4ld
         oEc1db8+rTb/DO+LplTGyXHvrtgwlxG/BKcqCQ0XM99UtDUKeOrzSKsL7qsnft0sbvV1
         Evkw1NcPtfgyqdaMFO58NJFKkmcshDVvLSuzQMmu64g57FjRtO6CPA3fiRConsVxMBW5
         CWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795407137; x=1796011937;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LOCdAV3cJyqL6wWWxU6d+kY0++FuazKUY9a33GDOhyg=;
        b=yPRNliQtOAMMlf+uIap1s/MUwATI+PlpsY3Yqdz4yPb3MaWnC2A7iEtOPdW1V/8De4
         iIQPPnNMmJ9E1212GPRm7SrOw/BFd+w4zaxRK2jFYDup1ac7XqfH5khwGq50uZKCPmb+
         wakex0nBBvrqrATQFE5A1qjvFN8oN3Fw8Br+n2FQl3rMsfdpuT5NitUnvO4MCcvR1ubT
         NB/mPsNPR5E5hjwaRpdPXOv+tkiIPZmeawOn156+irPTthhsGWGUyIISIQLAeYz8AAoI
         94F5Kz2LeB4awL+0IKVIjWQhVJR8PS3isIFa9JoTsWVgD8I/i8irOAEcSiuHKet/Xmxn
         jBPw==
X-Forwarded-Encrypted: i=1; AL+hErE5VDp5QvSH4OHYJhkONSY0Yon4Pt2jkM3mK7emAtOmU1PDy0dbjRXmOzy90asuQVyTEu5uRH7bjw==@kvack.org
X-Gm-Message-State: APuU4Z9Vp0ODRh9bCcLkesGCfNXg1JG7KbB6TYahSOeT47zYy1nNdl1F
	BgS2d3JcTaxXHjsUdFXAKWzh/NcVCx4cj9+33MdIuet16hv4Eb+Ul9F8pReQ4UfmFBlYBbouCi8
	hitJAPXPXAtv45c3LwT2Zow==
X-Received: from pgbj25-n1.prod.google.com ([2002:a05:6a02:61d9:10b0:cc7:8e37:71bc])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a08:b0:3f9:3f64:9b9f with SMTP id adf61e73a8af0-4014d2549c0mr11025809637.25.1795407136652;
 Sun, 22 Nov 2026 20:12:16 -0800 (PST)
Date: Sun, 22 Nov 2026 20:12:00 -0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
Message-ID: <20261123041200.3239570-1-nilayvaish@google.com>
Subject: [PATCH] mm/util: fix off-by-one in snapshot_page() retry check
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shivank Garg <shivankg@amd.com>, Luiz Capitulino <luizcap@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 42D1C40007
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: edkcr7ge8mm3bawj3151phsce55xw7bh
X-HE-Tag: 1795407138-410605
X-HE-Meta: U2FsdGVkX1+IJblHIDqGBWa+rLfDiLv9bDdduaimImyCenK9JH8tjZzWfeaPHYGLHkVZq1UtRSEPUmikgk5kQ3dXBfz3pSKZZD168ZHryZj2exSaqU9OQXyf78dKgrQoot3frb5JNkGO+P94yT1+q9NKLDpTppggZb8xXO2AeO4f64iOvqy9B3gu64ReTtbg0LN0mPfak8mPH935WIjW4BgbfoxlH2f9HV8gXOt85B6eFatjk0KcMx1CIieEqnqDsF9cW7I1EKdDRgJCiKktwB7hPbFp8ZZc/Z7bGyuOVuSz1iWus1+BY+Os0dfKpfdW9ra16gTkripYlrmLedR8G4u7bvSlAB4zO+oe4+XdyYAcIgZRdO8EblmaYgKi+wAZXAE8EakESlD5gfzkCAg68Tw5uY6K5W7wD8JBq/y3dsXjfCTulBmxOVhvA4h/uKs6XzPQpuCLyefbbetuF+9tjbwdnZVdmb6Rqw5LH6uFQus8KCtd4xPfgFz3UyvCkZK0pyBNAaoDPP3xPY05jzJ227VkOL1nHPOlVnndW6BzZmT2U9n05gh4cErPvtV7A1hQZLKn94kxPmXcW4kM3SicvW7KbgcS9fhZ2+HZDzXk5XUpG9BHdffPboX7ad6pyEG5O087AVRDC9z2d0exR/eedixVAybL4SfEAW3dzCAoy6VmodfGbzVJ22VPjUubc3bbrnQBvOrNIoeninTBx55JmLipGRJ8Q9tCgbcLZB8Ejt0eE+wrzycJJFM36VR88g/ZZjCWDWRcIn57eDPvyzLZey07rUBQNKgkh6ZUiB+38k88x9rNIJo8UryB/LbWhYIfVC8Oz/CU7A91jYq2c4+pOamNjXglnbP0pwJDvO/q3k8qKtKSWpP6UshQ12SHthhJh0Kabgq8KcYXVNDXslc6PytEyVUw80K8mQxnlHp7kd4usRdmfxNhVi68zsR+BFosXL+Kls+f9wQUY7VEgyq
 yttpxBYo
 oG/iKbySFfa6N+ngy4/hseU6uDU9Wftv9GhUI3SLbcJ91D0eNukUrRI3U46H3Znotw+IAGMcT43zqvAGOQkfuc4ZmQ2boKi5CKgl3QlHszthxQee1mDehoQnm9I4w4lBIAD2f+Q7SbD8QSuP/f/SBfFqPx3IAvAFKH7H0lw/yIRu4mUS3lRdTjuwg94s6+i99u182t0nE38i3h0+CdrWGguGlu4MU9Zhq6y4hyMZ/mkd7jjBsIXS1eTuR35H+yxbx+W8bB+d4Xl9gPNRXLVldysJgd1NUSf64GCbT/6L9dcCiaIlKmq2vegrlWMXquzyxwvLgWbNmtW7Vg8XerNd8nyXKqf+7kek8LGqn1DUTZrta3tqfrtJGVOwc2Ijyql5AyZC5ZEcxAnVCig47GpZwHKBnnBrEi19JNa6nsYEo9kD6BVzrLlD7MN6Fhf24VuR5NvIU4xn+FXcDMXiH0liCurCLjE4MLAt/nVQBuqURGUbsJdts+ZArF+bXJR/Bsnal24VMWyMLWDcupT9EpmNhlDFnP8Q3aJQqcPFBOq0B3FI+C00WHdfH3VTzaBUWQmmfUD9xsAGXZ+X/hRlGzF0Pjw5N+ABDy2ztb/OOsy3jyyr01g226aYEVTI8nTopyS7jFtswnd4vlo26E61DUkfBZCxt24xl1FZTPrcueUoUfLOquTR0NSnaDRe/fvwcgU6zwND7rCSKMR5C/YHGeyxIaGXrm1+0f3vKO/EY7SdmJNNpaeCYDUGtUiPtLh7UjgGdx8ZDAaif7H4GaF8+beP62NsuSCAdA1kzDQLesnR+AcMEqtz9hd3eJtCyadK8fSis381NjUQy1CvUDRv7M2At+Mw8o7RoLRbAj3LD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

snapshot_page() computes ps->idx, the index of @page within the folio
it appeared to belong to, and nr_pages, the size of that folio as read
from a copy of its head page. Because the folio can be split
concurrently, the two can disagree, in which case the snapshot is
retried and finally marked as unfaithful.

Valid indices are 0 to nr_pages - 1, but the check only catches
ps->idx > nr_pages. If the folio is split such that ps->idx equals
nr_pages, @page is no longer part of the folio that was copied, yet the
snapshot is returned as faithful with an out-of-range index.

Use >= so that this case is retried as well.

The race can be hit from userspace. On a kernel with a debug-only check
for this condition, one thread repeatedly faulted in a PMD-sized THP and
split it to order 0 through the split_huge_pages debugfs file, while
three threads read the /proc/kpageflags entry of the THP's second page.
In 90 seconds (about 181,000 splits), 14 snapshots of that page were
returned as faithful with idx 1 and nr_pages 1. With this change, a
second 90-second run (about 138,000 splits) hit the idx == nr_pages case
41 times; each one was retried, and no snapshot was returned with an
out-of-range index.

This issue was found by an AI coding assistant (Gemini) while reviewing
snapshot_page(). The fix and the reproducer were written with its help.

Fixes: d863a12108f2 ("mm/util: introduce snapshot_page()")
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 80f6c714844f..f2c23e4551a8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1444,7 +1444,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
 		set_ps_flags(ps, foliop, page);
 	}
 
-	if (ps->idx > nr_pages) {
+	if (ps->idx >= nr_pages) {
 		if (loops-- > 0)
 			goto again;
 		clear_compound_head(&ps->page_snapshot);
-- 
2.56.1.750.gf70dc682cf-goog


