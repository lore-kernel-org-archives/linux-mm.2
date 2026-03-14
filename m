Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CF4410706E9
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 16:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E9906B0088; Sat, 14 Mar 2026 12:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2757D6B0089; Sat, 14 Mar 2026 12:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A22C6B008A; Sat, 14 Mar 2026 12:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 07B8A6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 12:25:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89C7C13B670
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 16:25:50 +0000 (UTC)
X-FDA: 84545194860.30.605CEE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF8AB40008
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 16:25:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tu18mppS;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773505548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQb7vkXBp27URJSDzhnU5LSoqjB2+SHKXYLTo/CLjEM=;
	b=W2T2/WS8WZ1xYqIHZgi8n9bRK14DUYdOL+7KliXMW0WuohXKHSzj/cXBo1cLSiiwCG9AqY
	GKnuK0Ao1ji/SSpLQN4gQcFuPG03z2Az8/2uMdkJlR2CK3p4HnFitsHhtqMl7sNDxNrrxd
	GC1OgetQsD0KHHCJI9vE/BzV+XZ2Bv4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tu18mppS;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773505548; a=rsa-sha256;
	cv=none;
	b=KTvpO9xKQp9djIXg3dofEZJuvRfHCVvGjU9KNiWcXKorWAizUt6ivXPQrOVTt7X0khxjsz
	wDQJdGXV8QnQVkXeMAlk99PX6DYoSaGzjxLS7HrN7rFI3UJY0ajHYLvc+urLq+NigeIjLc
	qXU/UB1qP8tSci4qsU9iHoRMvq/aXP8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3927C60008;
	Sat, 14 Mar 2026 16:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B431AC116C6;
	Sat, 14 Mar 2026 16:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773505547;
	bh=WQHjrscJNWdfNTnaiIwZRdE72Obs+ZCkgeJJYYAS6KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tu18mppSLudEvM5OC7BNvQCYIEE2FB4FQPoRK3PXyJjh/ziHxprozbZ7kkI0WafyG
	 k3yewUuiW1Go3jboIU6p+FCJkmXKUgtWD69vcP6JSNlWaI06JrYGb77qng8PgRdUUz
	 dZRY7BcNI3lSxsj6h33MSlVMlkjl7so1GwPpxtCZt8WeXQ+ptHn42PzCTahICEDm7S
	 90txMgKW7wFGVoZyCr+3IRqDb134wqplPTD+DchY1YNC1HDCzPwwf/wgts68kqyXIk
	 PCMw5g1XPDVnJldy2c1Bp3IYg0ILzUWuCMbcd1ihl/wYiPBL8kcmteIeyl9xkA3p1p
	 DXqu8t7NDwUkA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm/damon: document exclusivity of special-purpose modules
Date: Sat, 14 Mar 2026 09:25:45 -0700
Message-ID: <20260314162546.86404-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260314092145.7496-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF8AB40008
X-Stat-Signature: r7uze8jhd98s6at3du8f46wwucdhmhwy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773505548-301434
X-HE-Meta: U2FsdGVkX1+9dYGM6J36ZXT4SGbkEgsJt0uWC3+DlRRvahdn4Kq8+Zq0XoOzC2NKqA4CX2S/Pq+6vcqysQ+3xulhBGjSkcM3ssOD/x12ygKxoWd/J8zH5pGqPQE3Ed8hhEsC12Vdmiu+FspXzsy2mnb6HgsjzA6/A0PPwUDhnHL9tOw19+EKfd6/Z+lrg3XwTFML4Iu8BqnfZ6Tx/vUOb/hZXRwaJtcVRzw4PvcRLSTx9XUy5/2/mX96slWg4qAf6XJEP4rbgXRwdlMRrvXIn+djdfdrgB92oU2xxjrWVNYbiiYs/fuMMrznjhDmStOS7DigVNcXGo5Bz/l10H0lsuoNMKDEyyRR13/E2zsy4zUMex5u9ttyEXzm2bIdoR/OhWuqfS7RplXbb5Q3DA1B+4WjXiogFOLA3CB6gzeFM2Z24/vg8K/sPnpA/cXQcIbD9glilcRhOjb91vDohqpz+TTGz6+Fde3Lne5ng4y2Sj0zNgyq1riZsIzFZN28LUVYL692mMlkpZqq5fNATLmIqqVqnocvmGu0hKtDhz9yeG/JmtUO7Lj/ldXgJVx4RlOlJAAteWXkwRvb9VQE2O6f6gFUJtc8SRML2RyyitfRfQDVBFZ4A8Dy0/BxP9zj//WlIRAwwlhjr+ZWrgFn5BseL5AQdLZ8IxmYxzfs8wzmtJo7HRn06nMhMIlAVFA7nmLCkyQkEBg7341z1ZYLv0TsHn5GwpqoOuDRUzL7vW7y2K/3Z3Qg+y4LCn+l4X+qH93qWQDfEmjKyQ+eHPYkYOjW2LPowq+DSVmMqsuSnUO+/z34xtC8rDK4dXLB7Ukouod3EwAiSPPy7viVwFKxfHyXroiDWj5a+irHA5BBq9mVJPCw8Man4XiLkjMx3DINI0TESfTpsaHA31sVBPsC08//8Z9jZ4876UW4UKBd3EJkLD7NAF+wXpxQBkksdPi5F2Cnkc1yJVs4l8rAzovVv0v
 d89hWF3i
 yIa1Pbp5p0d6ejDy42mVW+GkCJGNDXOQgOmalrstM70GibEyi0JlULVo2UClxIPNfVa8Ns0Nf2l/rFc/qIld7Z8VT27O+RMqFerQ80Lj2iL9G5EGK1cWiKXwNplMvIXHtsmxTWUX3kb7E5goC/hPbYrT0jRWsIkt3Kad4a/3mktxS+R59/HR6/CjZtZlPUCw5iU0sJ/H/rmsp7OXYfmXf/DtHcHx0duelY4VseXal2ySJ/7bT0/+ToJYlKcuPD1c49W1uC+7As5pNTNjHPXg3Ort7NJMA0x2A3w6CWaBGErZpIgv70TGwxZkkQitXb9lA24EVjODVRbUfEj/VbtccJHeK03QpA6muKBvyLOzl1/oO1PCSbxasbV8boC9PH0Fd8wjs4+6v2OxcK4lx6hJG9u1wqpl7wV8NCDAr/vR6CJV80dI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,

On Sat, 14 Mar 2026 17:20:22 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Add a section in design.rst to explain that DAMON special-purpose kernel
> modules (LRU_SORT, RECLAIM, STAT) run in an exclusive manner and return
> -EBUSY if another is already running.
> 
> Update lru_sort.rst, reclaim.rst and stat.rst by adding cross-references
> to this exclusivity rule at the end of their respective Example
> sections.

Thank you for doing this!

> 
> While at it, fix a Sphinx syntax error in the "contents" directive in
> design.rst (missing space after :depth:) that prevents the table of
> contents from being rendered on docs.kernel.org.

And thank you for fixing this!  But, the broken "contents" directive is added
by a commit on damon/next tree [1] that not yet planned to be upstreamed.  That
is, seems this patch is based on damon/next tree.  As a result, this patch
cannot be cleanly applied on mm-new.  We prefer making patches based on mm-new
unless there is a reason.

> 
> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t

I think it would be nice to give a context about the link.

Other than that,

Reviewed-by: SeongJae Park <sj@kernel.org>

Assuming you agree to my above suggestions, I added this patch to the top area
of damon/next after dropping the "contents" directive fix and adding a simple
sentence describing the context of the link.  The change made to this patch for
that is as below.  If you don't mind, I will post it as v2 of this patch by
tomorrow morning in Pacific Time.  Please let me know if you have any comments
about the plan.

'''
diff --git a/Docs-mm-damon-document-exclusivity-of-special-purpos.patch b/Docs-mm-damon-document-exclusivity-of-special-purpos.patch
index 9e74de3b..db466405 100644
--- a/Docs-mm-damon-document-exclusivity-of-special-purpos.patch
+++ b/Docs-mm-damon-document-exclusivity-of-special-purpos.patch
@@ -11,26 +11,31 @@ Update lru_sort.rst, reclaim.rst and stat.rst by adding cross-references
 to this exclusivity rule at the end of their respective Example
 sections.
 
-While at it, fix a Sphinx syntax error in the "contents" directive in
-design.rst (missing space after :depth:) that prevents the table of
-contents from being rendered on docs.kernel.org.
+This change is motivated from another discussion [1].
+
+[1] https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t
+
+TODO: move below changelog to the comment section when posting
+Change from v1
+(https://lore.kernel.org/20260314092145.7496-1-aethernet65535@gmail.com)
+- Drop contents directive fix
+- Reword description
 
-Link: https://patch.msgid.link/20260314092145.7496-1-aethernet65535@gmail.com
 Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
-Link: https://lore.kernel.org/damon/20260314002119.79742-1-sj@kernel.org/T/#t
+Reviewed-by: SeongJae Park <sj@kernel.org>
 Signed-off-by: SeongJae Park <sj@kernel.org>
 ---
  Documentation/admin-guide/mm/damon/lru_sort.rst | 5 +++++
  Documentation/admin-guide/mm/damon/reclaim.rst  | 5 +++++
  Documentation/admin-guide/mm/damon/stat.rst     | 5 +++++
- Documentation/mm/damon/design.rst               | 6 +++++-
- 4 files changed, 20 insertions(+), 1 deletion(-)
+ Documentation/mm/damon/design.rst               | 4 ++++
+ 4 files changed, 19 insertions(+)
 
 diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
-index 06a46812a728c..0198dfe87f4d5 100644
+index 73980bacc3a02..56690646cf398 100644
 --- a/Documentation/admin-guide/mm/damon/lru_sort.rst
 +++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
-@@ -353,3 +353,8 @@ the LRU-list based page granularity reclamation. ::
+@@ -351,3 +351,8 @@ the LRU-list based page granularity reclamation. ::
      # echo 400 > wmarks_mid
      # echo 200 > wmarks_low
      # echo Y > enabled
@@ -40,10 +45,10 @@ index 06a46812a728c..0198dfe87f4d5 100644
 +purpose modules exclusivity <damon_design_special_purpose_modules_exclusivity>`
 +for more details.
 diff --git a/Documentation/admin-guide/mm/damon/reclaim.rst b/Documentation/admin-guide/mm/damon/reclaim.rst
-index c5b4d8a1b0014..a37ce6fdff050 100644
+index 552a7786b0829..6f580f637134a 100644
 --- a/Documentation/admin-guide/mm/damon/reclaim.rst
 +++ b/Documentation/admin-guide/mm/damon/reclaim.rst
-@@ -331,6 +331,11 @@ granularity reclamation. ::
+@@ -318,6 +318,11 @@ granularity reclamation. ::
      # echo 200 > wmarks_low
      # echo Y > enabled
  
@@ -56,7 +61,7 @@ index c5b4d8a1b0014..a37ce6fdff050 100644
  .. [2] https://lwn.net/Articles/787611/
  .. [3] Documentation/mm/free_page_reporting.rst
 diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
-index 468c122c42594..46c5dd96aa2ed 100644
+index e5a5a2c4f803a..c4b14daeb2dd6 100644
 --- a/Documentation/admin-guide/mm/damon/stat.rst
 +++ b/Documentation/admin-guide/mm/damon/stat.rst
 @@ -45,6 +45,11 @@ You can enable DAMON_STAT by setting the value of this parameter as ``Y``.
@@ -72,19 +77,10 @@ index 468c122c42594..46c5dd96aa2ed 100644
  
  aggr_interval_us
 diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
-index 0a3b77ec458fe..3694c541e65aa 100644
+index 29fff20b3c2a9..dc37402c0fee9 100644
 --- a/Documentation/mm/damon/design.rst
 +++ b/Documentation/mm/damon/design.rst
-@@ -5,7 +5,7 @@ Design
- ======
- 
- .. contents:: :local:
--   :depth:2
-+   :depth: 2
- 
- .. _damon_design_execution_model_and_data_structures:
- 
-@@ -960,6 +960,10 @@ more detail, please read the usage documents for those
+@@ -853,6 +853,10 @@ more detail, please read the usage documents for those
  (:doc:`/admin-guide/mm/damon/stat`, :doc:`/admin-guide/mm/damon/reclaim` and
  :doc:`/admin-guide/mm/damon/lru_sort`).
'''  

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

