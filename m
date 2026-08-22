Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462EFC5DF8C
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 19:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD97E6B00A0; Sat, 22 Aug 2026 15:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89CD6B00A1; Sat, 22 Aug 2026 15:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B78E96B00A2; Sat, 22 Aug 2026 15:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CF6F6B00A0
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 15:14:45 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80FE140144
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:14:44 +0000 (UTC)
X-FDA: 85129857288.13.1A2679D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id BFB67160002
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 19:14:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHhD3My+;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787426082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ea6Z/PmroI0x87AWLnDQmNurQhRxmSEuWDOruKz5qfc=;
	b=Q79obJ8oNNb4ltWjadg0btz7zDkvy1GMOXAHYWM7srMimTQk7wB2gSN5KuEVVMLmm+rRcc
	ky1HLvPf7h8R5L+uA+RGKzbps1FBpIbJ7XHld9lwKd/mtGwC5Bu2yQGPq6VGCcutaUT07r
	XCUZkTPCMEvR04uP880SsX+1nBR8GBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787426082;
	b=GDe8kFHaoH2tIX9VNZNpaaDZtaWalSS7IYBpOzTqR+2Uu72zISw/Z/BX++K1XfLvjottXD
	LVolJpHD65y9cNEUuUDM0kE6tm98uFc9Gz9iqVHiixmPDD/3AjqGat2ay6zXrav8rkYR3R
	+jLkvQ3RsLlUUl8xfROpIPjxshP+174=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHhD3My+;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07B3D60008;
	Sat, 22 Aug 2026 19:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7251F000E9;
	Sat, 22 Aug 2026 19:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787426081;
	bh=Ea6Z/PmroI0x87AWLnDQmNurQhRxmSEuWDOruKz5qfc=;
	h=From:Date:Subject:To:Cc;
	b=SHhD3My+ZVsezLwvxqor0U5e91ykfaJWAQh9AeQ94LS8NdjMzixJIfrPBqvoIVK6o
	 P3ugDRGnjz/w7tp8P6lsKlGLS7OMXStIW8mLqtB3rPF5DunKkalB6qNDY/dhXsxhgg
	 VJ8uhFE9Zs6tp4VM1etrm6fVqFu0Uun9uQQHSBwtodS0QmbawPLV5ZRH3l113/90zJ
	 YkzDvSY8RHeNcEqVGXTx8A0iKQ1JNWGLEXG4c+TBI786/utdsW0mdz8Dhxy8ChgNOQ
	 YdvEkPjXDIdWEo3qcgNfeNmMiBu0eqKluzJOXKX+txPjDml8/ddGulU5IHdqQsJ8wo
	 K0zNej4LM+1bQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 22 Aug 2026 20:14:02 +0100
Subject: [PATCH v2] mm/secretmem: properly account locked pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260822-secretmem-accounting-v2-1-fe445a7c6eb1@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPn0iWoC/4WNQQ6CMBBFr0JmbQ1tmgKuvIdhUcoAo9KaaSEaw
 t0FPIDLl7z//gIRmTDCJVuAcaZIwW+gThm4wfoeBbUbg8qVyUupRUTHmEYchXUuTD6R74VtjdX
 aqKqRFWzTF2NH7yN7q38cp+aOLu2t3RgopsCf43eWu/fnYpZCilZ1pTNFUZV5c30ge3yeA/dQr
 +v6BaXuPfjLAAAA
X-Change-ID: 20260814-secretmem-accounting-ad6a44629b19
To: ljs@kernel.org
Cc: Daehyeon Ko <4ncienth@gmail.com>, stable@vger.kernel.org, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Jesper Dangaard Brouer <hawk@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 Stanislav Fomichev <sdf@fomichev.me>, 
 James Bottomley <James.Bottomley@HansenPartnership.com>, 
 Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, netdev@vger.kernel.org, 
 bpf@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=15483; i=ljs@kernel.org;
 h=from:subject:message-id; bh=p97ofeXu3cJL9HMeC0WK95ngz7z/l0sxVqXEkU2VVag=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI6v/LoNZ4oeit6yFWzOUYp1GHdaX2VXNU+a2c209Cgy
 wvOTP/aUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgInYzmT476i+eYrQzbapzOmv
 v2j3rvtcJKxe//n1dW47xa7HmVsyVjH8lStP2xO642xq3sX3kXEG05q8FitzaB8se1T9Ivfampf
 5fAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Stat-Signature: mun34mao96humukigycg6iidrxei9yif
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFB67160002
X-HE-Tag: 1787426082-265079
X-HE-Meta: U2FsdGVkX1/ouKsrq/sLYhvxg/BEMjKEaTH0+ufjN4QP95BQ6vLDyfq9G8EyHPJR0ZTQnuLDabwUf0GFeB9+omFa5ldqbdBuUiAeihXK6Wq2pwLAIVcYtUeGbohj43DBmdTmLI3nFmn5o4C5xkvR2rmYermXy/yibzf945i3NJdzacx+yTgydF0jDnzBxd3SpThH0CwhfXyXb/FjhBGZss7DhNCBtXrQOYa4EbqpMbquwecdDVxon93eWI9oijBLeCkjlgv+4+3JkWrNEBTTR4iyB+aVEmn+QL6cb6T6F/VOk6qD5yEwVrx83rALdBGXphTYu+5PhLuigPfede1IBnHW8Kv0JAHrdPSubzSW2NmO/45NQziU5hCVpqy1Kiodiw1w2l4bxjiJAtOxiIUQgY/ZXFeB2rfmgo0tC+G2DaA0x/ItHkhGuNQzXtIhoB8m914YgCffpb3x/++NW8sPJ4V9rbqSZkumXHogATHuV326neL9lzWSpPHA0Ysr3o6RlsBSv/q8WQYOJKHjUFlcnoM2e7DeRj01RqtWtQmLcFvq72grk+pXcKxz+ZL87vpwWBKrO6QVs/xP+Nw+4jaGpJdfcfA04XITXnFPkzFYRYQasrpFGmQP1phIq7iykdyump95WDS0lfM27g2ie8lQepAkm1gO09ZU2k+cmQOCrrr5wYgcHFrQw07fK3EGk2NPh0eque3UfFdHLaP6ZmVI/e6PDSGC4kxSl5PUcO/+Iu87lT2xhpJS2/ErJTNujxjx8PxqtlBX47dFu+EAN9TwoCoX/d56+ubftNnVv+7T4DjTCKMpP1pLiwI3ciYI81InW5imYTVQmCM7rhbZhOwW5qGLsOnhtRmHI9KSXy5FM06tzaGqBogX7C7CSnCfKA2uKR71yiGMpkx1MIwE564vmsqncfAg7JpgFh5OGNJPEX1YrsnDdR0+xVaxcfA9uAYb/QGi8ix995U9GGclpeb
 GadMJ2Uf
 RjpHVeY/7zHFbDep0AwUTGW3HcoDuUnC218aU6Vw9I0Gfysdv9YWvPlx1QMib+ho8pUy/9Wl59/sZH6KzHQJpssgVU5XTEx/hdZSZAE1UD5tpodqnb2SBzO6o9ZOqk9xBLGXlOiYcZN8EU7hGrK5YNBAttgefsYxhfgAcMGAwvIRs4huYgY/v6NtbohXHzx4Jz8MRWHSqZLLjkQVxJrsiSkgZJ/OOSShJefDOOMgJ4skmwRK9lBMTW7UAD+7ABFzmVcLzz54u/pgG19N0FMwtMS+FHSiyOOa7PtKfVydet9Vp2hhYacHYkmmd0UWBpMLm2afsh6PxDR+4jTi2ypr482oFDrSE2zFYL40Qx6L2s5ZrRikKqGt+iTwimJlWoO1eTg/DyK1qIiXxPv9T1HHF1D8zMfGTEUZOa3X7GgOPC3kP/mIqFjBJXn/P5cAYmGhw/K5vBWw1VW9BJ9mckp3w9qqBzmMMJEzwixolLHzgV4bn0N7CK55nKTb83wqdVo2ImKL9lDlGWrS5AxB71S/e9OsiUSY8y92z/Lyx0/SE1vHkxpyT13p7/A2gegY8t0wM2pAlxsxNQsrdvNitCdVp+v81Mf63kU1zeooQq63lGqK88XSGWN231uyqBLFOdoM+S++2YFDSW1VVz3BWIOXjkFWd/1+V/B6k4FsVbIX4/Z31BXv27wxenma1ouvTwVRyjtJt9SceiZFYwUyCsrqwRobLtgNkFwVlTrBmk/3XC4gNiRuq/Brt+o1uzgPamRduJtPGv7daU4gsMlj7cvusnQlbmamlWe+F88o5GnF4xixmyFjLfo5S1/nEXe7O+i4rcbhTZhLCKcamvrDi8uLeiA3uBmB6fiQSApADCyQl04FMXdBTDJ5pnCgXJwpgiOXzXHIxqRhz6vljD1HjczVcKIe7E1u0pv7D9I8r6gAuygRTKdplb5zz5bpAE5NS6/SxMT77
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

secretmem has a relatively laissez-faire attitude to accounting the folios
it allocates.

The intention is that the memory is treated as if it were mlock()'d and
thus is limited by the RLIMIT_MEMLOCK limit if the CAP_IPC_LOCK capability
is not in place (which broadly allows unlimited ranges of mlock()'d
memory).

The lifecycle for memfd accounting against this limit is - account on map,
unaccount on unmap but the lifecycle of memfd folios is allocate on fault,
deallocate on inode eviction.

This mismatch is problematic because the folios are unevictable and remain
so until the inode is evicted (set using mapping_set_unevictable()).

This is problematic as it eliminates usual mlock() semantics - mapping
folios then unmapping them does not clear their unevictable state, since it
depends on AS_UNEVICTABLE, not PG_mlocked.

A user can therefore easily work around the RLIMIT_MEMLOCK limit - simply
map then unmap and VmLck no longer counts the secretmem range (or more
involved - fork which also achieves the same thing).

Worse - they are not accounted in the process's RSS even if mapped again,
meaning the OOM killer won't know to kill the process.

A user without the CAP_IPC_LOCK capability can therefore repeatedly
map/unmap (or map/fork) and consume all available system memory with
unevictable folios and cause system instability.

A secretmem fd can be passed between processes and over fork so a
per-process limit simply does not make sense.

So follow the precedent set by io_uring, perf, skbuff, iommufd and xdp -
track the number of locked pages in user_struct->locked_vm.

Since the scope tracked is actually inode lifetime, the RLIMIT_MEMLOCK
applies per-user not per-process. Also given the change in scope it doesn't
make sense to bypass for users with CAP_IPC_LOCK, so remove it.

There is simply no reason to carry on marking the mapping as mlock()'d
since it's misleading and the lifecycle is now correctly handled, so remove
this too.

Additionally, fix the selftest which checks the limit as this now must
assert SIGBUS on limit violation on fault-in.

__secretmem_account_pages() is more or less a duplicate of the code that
io_uring etc. use, but since this is a bug fix that needs backporting,
defer any de-duplication efforts to a follow-up.

Reported-by: Daehyeon Ko <4ncienth@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20260813225328.2010303-1-4ncienth@gmail.com/
Fixes: 1507f51255c9 ("mm: introduce memfd_secret system call to create "secret" memory areas")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
v2:
- Tried to put the commit message on a diet, as per Mike.
- Moved secretmem_init_inode_[priv, destroy]() nearer their callers as per
  Mike.
- Removed CAP_IPC_LOCK check as per discussion with Mike.
- Removed redundant GFP_KERNEL in kzalloc_obj() call as per Mike.
- Updated to consistently use goto err style in secretmem_file_create() as
  per Mike.
- Updated test_mlock_limit() to consistently use goto cleanup style as per
  Mike.
- Added a comment describing why we are capping the mlock limit in the
  secretmem tests, as per Mike.
- Set inode->i_priv to NULL after destroy.

v1:
https://patch.msgid.link/20260814-secretmem-accounting-v1-1-d2f8c677980b@kernel.org

To: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Vlastimil Babka <vbabka@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
To: Michal Hocko <mhocko@suse.com>
To: Shuah Khan <shuah@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
To: "David S. Miller" <davem@davemloft.net>
To: Jakub Kicinski <kuba@kernel.org>
To: Jesper Dangaard Brouer <hawk@kernel.org>
To: John Fastabend <john.fastabend@gmail.com>
To: Stanislav Fomichev <sdf@fomichev.me>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: ljs@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
---
 include/linux/sched/user.h                |   3 +-
 mm/secretmem.c                            | 117 +++++++++++++++++++++++++++---
 tools/testing/selftests/mm/memfd_secret.c |  96 ++++++++++++++++++++++--
 3 files changed, 198 insertions(+), 18 deletions(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 4cc52698e214..8d7e5521f7cd 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -25,7 +25,8 @@ struct user_struct {
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
 	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
-	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD)
+	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD) || \
+	defined(CONFIG_SECRETMEM)
 	atomic_long_t locked_vm;
 #endif
 #ifdef CONFIG_WATCH_QUEUE
diff --git a/mm/secretmem.c b/mm/secretmem.c
index d29865075b6e..b7c8b2057e81 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -18,6 +18,8 @@
 #include <linux/secretmem.h>
 #include <linux/set_memory.h>
 #include <linux/sched/signal.h>
+#include <linux/sched/user.h>
+#include <linux/cred.h>
 
 #include <uapi/linux/magic.h>
 
@@ -47,10 +49,70 @@ bool secretmem_active(void)
 	return !!atomic_read(&secretmem_users);
 }
 
+struct secretmem_inode_state {
+	struct user_struct	*user;
+	atomic_long_t		nr_pages_accounted;
+};
+
+static bool __secretmem_account_pages(struct user_struct *user,
+		unsigned long nr_pages)
+{
+	unsigned long page_limit, cur_pages, new_pages;
+
+	if (!nr_pages)
+		return true;
+
+	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	cur_pages = atomic_long_read(&user->locked_vm);
+	do {
+		new_pages = cur_pages + nr_pages;
+		if (new_pages > page_limit)
+			return false;
+	} while (!atomic_long_try_cmpxchg(&user->locked_vm,
+					  &cur_pages, new_pages));
+	return true;
+}
+
+static bool secretmem_account_folio(struct secretmem_inode_state *state,
+		const struct folio *folio)
+{
+	unsigned long nr_pages;
+
+	nr_pages = folio_nr_pages(folio);
+	if (!__secretmem_account_pages(state->user, nr_pages))
+		return false;
+
+	atomic_long_add(nr_pages, &state->nr_pages_accounted);
+	return true;
+}
+
+static void __secretmem_unaccount_pages(struct secretmem_inode_state *state,
+		unsigned long nr_pages)
+{
+	atomic_long_sub(nr_pages, &state->user->locked_vm);
+	atomic_long_sub(nr_pages, &state->nr_pages_accounted);
+}
+
+static void secretmem_unaccount_folio(struct secretmem_inode_state *state,
+		struct folio *folio)
+{
+	__secretmem_unaccount_pages(state, folio_nr_pages(folio));
+}
+
+static void secretmem_unaccount_all_folios(struct secretmem_inode_state *state)
+{
+	unsigned long nr_pages_accounted;
+
+	nr_pages_accounted = atomic_long_read(&state->nr_pages_accounted);
+	__secretmem_unaccount_pages(state, nr_pages_accounted);
+}
+
 static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct secretmem_inode_state *state = inode->i_private;
 	pgoff_t offset = vmf->pgoff;
 	gfp_t gfp = vmf->gfp_mask;
 	unsigned long addr;
@@ -72,8 +134,15 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 			goto out;
 		}
 
+		if (!secretmem_account_folio(state, folio)) {
+			folio_put(folio);
+			ret = VM_FAULT_SIGBUS;
+			goto out;
+		}
+
 		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
 		if (err) {
+			secretmem_unaccount_folio(state, folio);
 			folio_put(folio);
 			ret = vmf_error(err);
 			goto out;
@@ -82,6 +151,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
 		__folio_mark_uptodate(folio);
 		err = filemap_add_folio(mapping, folio, offset, gfp);
 		if (unlikely(err)) {
+			secretmem_unaccount_folio(state, folio);
 			/*
 			 * If a split of large page was required, it
 			 * already happened when we marked the page invalid
@@ -112,22 +182,30 @@ static const struct vm_operations_struct secretmem_vm_ops = {
 	.fault = secretmem_fault,
 };
 
+static void secretmem_destroy_inode_priv(struct inode *inode)
+{
+	struct secretmem_inode_state *state = inode->i_private;
+
+	secretmem_unaccount_all_folios(state);
+	free_uid(state->user);
+	kfree(state);
+	inode->i_private = NULL;
+}
+
 static int secretmem_release(struct inode *inode, struct file *file)
 {
 	atomic_dec(&secretmem_users);
+	secretmem_destroy_inode_priv(inode);
+
 	return 0;
 }
 
 static int secretmem_mmap_prepare(struct vm_area_desc *desc)
 {
-	const unsigned long len = vma_desc_size(desc);
-
 	if (!vma_desc_test_any(desc, VMA_SHARED_BIT, VMA_MAYSHARE_BIT))
 		return -EINVAL;
 
-	vma_desc_set_flags(desc, VMA_LOCKED_BIT, VMA_DONTDUMP_BIT);
-	if (!mlock_future_ok(desc->mm, /*is_vma_locked=*/ true, len))
-		return -EAGAIN;
+	vma_desc_set_flags(desc, VMA_DONTDUMP_BIT);
 	desc->vm_ops = &secretmem_vm_ops;
 
 	return 0;
@@ -187,20 +265,40 @@ static const struct inode_operations secretmem_iops = {
 
 static struct vfsmount *secretmem_mnt;
 
+static int secretmem_init_inode_priv(struct inode *inode)
+{
+	struct secretmem_inode_state *state;
+
+	state = kzalloc_obj(*state);
+	if (!state)
+		return -ENOMEM;
+
+	state->user = get_uid(current_user());
+	inode->i_private = state;
+	return 0;
+}
+
 static struct file *secretmem_file_create(unsigned long flags)
 {
 	struct file *file;
 	struct inode *inode;
 	const char *anon_name = "[secretmem]";
+	int err;
 
 	inode = anon_inode_make_secure_inode(secretmem_mnt->mnt_sb, anon_name, NULL);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
+	err = secretmem_init_inode_priv(inode);
+	if (err)
+		goto err_free_inode;
+
 	file = alloc_file_pseudo(inode, secretmem_mnt, "secretmem",
 				 O_RDWR | O_LARGEFILE, &secretmem_fops);
-	if (IS_ERR(file))
-		goto err_free_inode;
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err_free_priv;
+	}
 
 	mapping_set_gfp_mask(inode->i_mapping, GFP_USER);
 	mapping_set_unevictable(inode->i_mapping);
@@ -215,10 +313,11 @@ static struct file *secretmem_file_create(unsigned long flags)
 	atomic_inc(&secretmem_users);
 
 	return file;
-
+err_free_priv:
+	secretmem_destroy_inode_priv(inode);
 err_free_inode:
 	iput(inode);
-	return file;
+	return ERR_PTR(err);
 }
 
 SYSCALL_DEFINE1(memfd_secret, unsigned int, flags)
diff --git a/tools/testing/selftests/mm/memfd_secret.c b/tools/testing/selftests/mm/memfd_secret.c
index aac4f795c327..26d2a4a527da 100644
--- a/tools/testing/selftests/mm/memfd_secret.c
+++ b/tools/testing/selftests/mm/memfd_secret.c
@@ -15,6 +15,8 @@
 #include <sys/resource.h>
 #include <sys/capability.h>
 
+#include <setjmp.h>
+#include <signal.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
@@ -22,6 +24,8 @@
 #include <stdio.h>
 #include <fcntl.h>
 
+#include <sys/mman.h>
+
 #include "kselftest.h"
 
 #define fail(fmt, ...) ksft_test_result_fail(fmt, ##__VA_ARGS__)
@@ -31,6 +35,11 @@
 #ifdef __NR_memfd_secret
 
 #define PATTERN	0x55
+/*
+ * Set 8 MiB as a reasonable mlock limit so users with unlimited or absurdly
+ * high RLIMIT_MEMLOCK don't cause us to overflow in the tests.
+ */
+#define MLOCK_LIMIT_CAP	(8UL << 20)
 
 static const int prot = PROT_READ | PROT_WRITE;
 static const int mode = MAP_SHARED;
@@ -39,6 +48,13 @@ static unsigned long page_size;
 static unsigned long mlock_limit_cur;
 static unsigned long mlock_limit_max;
 
+static sigjmp_buf fault_env;
+
+static void sigbus_handler(int sig)
+{
+	siglongjmp(fault_env, 1);
+}
+
 static int memfd_secret(unsigned int flags)
 {
 	return syscall(__NR_memfd_secret, flags);
@@ -57,10 +73,31 @@ static void test_file_apis(int fd)
 		pass("file IO is blocked as expected\n");
 }
 
-static void test_mlock_limit(int fd)
+/* GUP disallows automatic fault-in of secretmem, so do it manually. */
+static bool fault_in_secretmem(char *mem, size_t len)
+{
+	if (sigsetjmp(fault_env, 1))
+		return false;
+	memset(mem, PATTERN, len);
+	return true;
+}
+
+static void test_mlock_limit(void)
 {
 	size_t len;
 	char *mem;
+	int fd;
+
+	/* Locked pages have an inode lifetime, so need a new fd. */
+	fd = memfd_secret(0);
+	if (fd < 0) {
+		fail("memfd_secret failed: %s\n", strerror(errno));
+		return;
+	}
+	if (ftruncate(fd, mlock_limit_max * 2)) {
+		fail("ftruncate failed: %s\n", strerror(errno));
+		goto out_close;
+	}
 
 	len = mlock_limit_cur;
 	if (len % page_size != 0)
@@ -69,19 +106,50 @@ static void test_mlock_limit(int fd)
 	mem = mmap(NULL, len, prot, mode, fd, 0);
 	if (mem == MAP_FAILED) {
 		fail("unable to mmap secret memory\n");
-		return;
+		goto out_close;
+	}
+
+	if (!fault_in_secretmem(mem, len)) {
+		fail("unable to fault in secret memory\n");
+		goto out;
 	}
-	munmap(mem, len);
 
+	munmap(mem, len);
 	len = mlock_limit_max * 2;
 	mem = mmap(NULL, len, prot, mode, fd, 0);
-	if (mem != MAP_FAILED) {
-		fail("unexpected mlock limit violation\n");
-		munmap(mem, len);
-		return;
+
+	if (mem == MAP_FAILED) {
+		fail("unable to mmap secret memory\n");
+		goto out_close;
+	}
+
+	if (fault_in_secretmem(mem, len)) {
+		fail("mlock limit is not respected\n");
+		goto out;
+	}
+
+	munmap(mem, len);
+	len = page_size;
+
+	/* map a page past the limit to assert inode scope. */
+
+	mem = mmap(NULL, page_size, prot, mode, fd,
+		   mlock_limit_max & ~(page_size - 1));
+	if (mem == MAP_FAILED) {
+		fail("unable to mmap secret memory\n");
+		goto out_close;
+	}
+
+	if (fault_in_secretmem(mem, page_size)) {
+		fail("mlock limit is not respected\n");
+		goto out;
 	}
 
 	pass("mlock limit is respected\n");
+out:
+	munmap(mem, len);
+out_close:
+	close(fd);
 }
 
 static void test_vmsplice(int fd, const char *desc)
@@ -292,6 +360,12 @@ static void prepare(void)
 	if (page_size > mlock_limit_max)
 		mlock_limit_max = page_size;
 
+	/* Clamp huge or unlimited. */
+	if (mlock_limit_max > MLOCK_LIMIT_CAP)
+		mlock_limit_max = MLOCK_LIMIT_CAP;
+	if (mlock_limit_cur > mlock_limit_max)
+		mlock_limit_cur = mlock_limit_max;
+
 	if (set_cap_limits(mlock_limit_max))
 		ksft_exit_fail_msg("Unable to set mlock limit: %s\n",
 				   strerror(errno));
@@ -301,6 +375,7 @@ static void prepare(void)
 
 int main(int argc, char *argv[])
 {
+	struct sigaction sa = { .sa_handler = sigbus_handler };
 	int fd;
 
 	prepare();
@@ -316,10 +391,15 @@ int main(int argc, char *argv[])
 			ksft_exit_fail_msg("memfd_secret failed: %s\n",
 					   strerror(errno));
 	}
+
+	sigemptyset(&sa.sa_mask);
+	if (sigaction(SIGBUS, &sa, NULL))
+		ksft_exit_fail_msg("Cannot set up SIGBUS handler");
+
 	if (ftruncate(fd, page_size))
 		ksft_exit_fail_msg("ftruncate failed: %s\n", strerror(errno));
 
-	test_mlock_limit(fd);
+	test_mlock_limit();
 	test_file_apis(fd);
 	/*
 	 * We have to run the first vmsplice test before any secretmem page was

---
base-commit: e737cebb8de0d38e8f64584a8bbfbcf9176c7537
change-id: 20260814-secretmem-accounting-ad6a44629b19

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


