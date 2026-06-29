Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D47C44500
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485B46B00D5; Mon, 29 Jun 2026 08:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 433B06B00D3; Mon, 29 Jun 2026 08:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237DF6B00D3; Mon, 29 Jun 2026 08:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E74F16B00D3
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:25:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75A94903CB
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:12 +0000 (UTC)
X-FDA: 84932870064.03.7482264
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE1B48000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:25:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjKzPFOR;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735910;
	b=PCjPn80KJA7VMRsMGgQOFD5Wpt7U6FzQV2N1qywZybuQ5megKCr+mSOOQ+/zBaK9q5OV7h
	nzSSiwpQm//Nf9O0WCK7t8casti2kfvPLKuE3/9DmcvIZZmebiHzd/e2Cmq49w2ihhAaDx
	CLTu5jYUA1TA8J7uu7wSvB3AO72Ywls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mS4FmeICQJ9Ywkxd+EfahpDdy7CpZ1ZHvCipweuqRKE=;
	b=FmnniVRcHzncJXDovnEPRx4zvQH2NKaSuL0tWs1M1m9WAJFGKWd0dB7fG8Q/5dtI1PNecQ
	nz3wN4TMu8FinxBk/QAae4so99it3GJuxmZve9gorkX9l+jLixudgnAJr5/aL2pXQk7DLj
	zaelSiQcoa75Tsn3SRTDvy5Iqkz7WpA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjKzPFOR;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 67AC0600AB;
	Mon, 29 Jun 2026 12:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EF81F00A3A;
	Mon, 29 Jun 2026 12:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735910;
	bh=mS4FmeICQJ9Ywkxd+EfahpDdy7CpZ1ZHvCipweuqRKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SjKzPFORFyyoIvxCVewGH6aMd/sKD/EoO7d5JdR5wogbwAZoUOXibHP65k2LlCA/8
	 BiDr50glG3uwY1H1vA+mRYMF2MDP+QL5rXkWVgySzfCrIQhyGB+8gR4/GVBcPxj4qt
	 DOvEa+0b0ihViJqYaZgKrywdAJzpEMJNG8Eb9Wa7BKWu8xy7A1vgegH8mqEYdTsSyy
	 bT5ire25TKtLfGZBmMyi2ykzbXuONvUTuRmDOh+vr1tbwvuWufGO7Tn9tHB231p/iB
	 1ssVMlvXkA/VVtOMvemMEKzl/DQy4jsIfz1JJ1pJKCxelkDTcCYThwtdLAEzJUM4u8
	 0vd3tGQPSCpEw==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 25/30] mm/vma: update vmg_adjust_set_range() to offset pgoff instead
Date: Mon, 29 Jun 2026 13:23:36 +0100
Message-ID: <910f7b5be78232304dc7ca01cd57c6f5ca8f3d13.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: r74apemrah37btpb7e6x1ram11f1oq18
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CE1B48000D
X-HE-Tag: 1782735910-904898
X-HE-Meta: U2FsdGVkX1/lNAZM0u9TjSWS8z+qcpFxysj0K5P2Po+b2wJEIDIPwfEuPB1kVzDQA1orf0zuz+RGOnv+poPOvRgRWA6bN/US3vqVL2lvMsZhhpZQ63q5B5EROBbhIBiAzjjNM6YLKsafQB7AekwVTfGpOzNHrZIZ4FZh117oBN0UiFUIT8Jc9MVVRhnOtKakhwm+wG5ARURo0H3DxSWCW6Fao07wGzd5hyHR5tmaDUU4VBkfZhyhTdKDB35obWF0651/weJSC9czdgYdXvjzVhrGAiPrwQPByplFf3KejFjNceiQj+CX4TujNDPVPcO6Kki7jqU4z+apbY79+DAdPQzToNMDpct4/fqKVfrgqPnNaCIb56GLgycgpISC2HYUkjbYjq8B6GgETEDncgmRTpnBkGu7P56FipsRtzKfuY2DU6G8O7DUtyZSjPclZNMzfxzsWxkBKp2XHl1fBooE/XV7rU/fskZBaOZ2gXLs3/GiC8kqdQAf+MB4nS/B6rRBuxJr6gU9yU1v1yYM8jXHK7nV2Fja1nEXENTcRX9gspQiOSk6xu2pbPxHcPcpodspQUYL1dUelXQgFXKD7G7jacRRJR68gPc9TJSjs2431v8FRXpH+up4FZmOgpqV8wXPzY3iwkrE+vflQyPBWDLCdhqIoXFmgjpXHK8nw4o7HI+90Ia9V8V5EN7K7SyFjojE2MHj0lL58LuTgPSRdAv65a2VWfhMobblc33mXhdTmp2PGItpc61xfUPhh4R9OjOjroDdwbPxk6XsP+fwrRVnZNoGY7ZrQXd48C+gkyKFWyD6EWT5sG3gXhAx9sW4l/4X72buGy8l65kGPe8XpZYJ61WkKxMXJpYrUCHXNSEK9WAk5g76OlNRUfZjcf6y///E/Ap311V5SMYFBLPPN1gag999NfKzny0Vc1o/9jQSYReeANzmuTmIbK9IWRKIQr7v2WmRMzrwn2BncBi4Qhb
 56PhLg4m
 vYTvJHGr2wHk8Tr0PbeTJO4Y1hDprqrwIYc4pur0P+zNvl7WhUIhlc8tiFiaJAbiVmeYULsuK5wjfzvubAe0f6IG6E3ihoOJvIgkJspcEuRmM5PlDw6o/kce/RHHWpqw15lJFuOarDhSz8N0ZO7Fj4NW5l/th8+UJvUWnYAA1w+85BanoQT07ZAo5q4PuihCv1sRKTJq5UebdVDRbtvcZXPCoAc8BANWMDEGII9sZP2ObfyL4Hja2/dgg/Rhz//W5PdFQzil/4ZDvzs5YL94uEw9RGyuVvpkbLk9kUMhvTVUp08B/pb8GSNLQMnAQqFEzzYkGiFvRt5S6ElWKN/77AZlmYeKdW3dDDv5jQWgmQxUavcY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are calculating the pgoff as an offset, since we have vma_add_pgoff()
and vma_sub_pgoff() available, just offset this value directly and use
__vma_set_range() for vma->vm_[start, end] values.

We take care to update the range before offsetting the page offset, so the
adjusted VMA's vm_start and vm_pgoff are mutually consistent at the point
the page offset helpers operate - this matters once vma_set_pgoff() comes
to assert invariants which relate the two.

Doing so lays the foundation for future work which allows for use of
virtual page offsets for MAP_PRIVATE-file backed mappings.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index e3355eab11f2..0579fc8c9bd5 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -714,9 +714,6 @@ void validate_mm(struct mm_struct *mm)
  */
 static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 {
-	struct vm_area_struct *adjust;
-	pgoff_t pgoff;
-
 	if (vmg->__adjust_middle_start) {
 		/*
 		 * vmg->start    vmg->end
@@ -735,8 +732,8 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 		struct vm_area_struct *middle = vmg->middle;
 		const unsigned long delta = vmg->end - middle->vm_start;
 
-		pgoff = vma_start_pgoff(middle) + (delta >> PAGE_SHIFT);
-		adjust = middle;
+		__vma_set_range(middle, vmg->end, middle->vm_end);
+		vma_add_pgoff(middle, delta >> PAGE_SHIFT);
 	} else if (vmg->__adjust_next_start) {
 		/*
 		 *                Originally:
@@ -764,13 +761,9 @@ static void vmg_adjust_set_range(struct vma_merge_struct *vmg)
 		struct vm_area_struct *next = vmg->next;
 		const unsigned long delta = next->vm_start - vmg->end;
 
-		pgoff = vma_start_pgoff(next) - (delta >> PAGE_SHIFT);
-		adjust = next;
-	} else {
-		return;
+		__vma_set_range(next, vmg->end, next->vm_end);
+		vma_sub_pgoff(next, delta >> PAGE_SHIFT);
 	}
-
-	vma_set_range(adjust, vmg->end, adjust->vm_end, pgoff);
 }
 
 /*
-- 
2.54.0


