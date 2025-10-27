Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE500CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 08:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4385A80024; Mon, 27 Oct 2025 04:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40FF08000A; Mon, 27 Oct 2025 04:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3274080024; Mon, 27 Oct 2025 04:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21A458000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 04:53:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3F2FC0544
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:53:14 +0000 (UTC)
X-FDA: 84043279908.10.1265BCC
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf18.hostedemail.com (Postfix) with ESMTP id C54E91C000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 08:53:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GJotxEZo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761555193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1SFbXbwu/ePc1DQgC7lnHgCpffeuAr2Hs5LpPIUuFM4=;
	b=RGrSgW/MFepE8q+enqdc8Zv4kthgdEwGHCRQULFeX+G/YeFKYEzMBpU5v1rNcr3X2lxGLC
	0hj4cAkbr2f8/OCffchoEclxakWlHXT0R85emqp7MauNxoa5gEhTfOyYZRrFlbV+fWJVfF
	WXUBfGq5eGwfm4f/cdWO0QoWLuYiDYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761555193; a=rsa-sha256;
	cv=none;
	b=aw9g3dwjKPv7Ok5+uScXmyrdaE6mbZgDWa5Jg3z+31tgC7w0wFEkKbMZniEBMaimE2mCAT
	Q+wJxDBD9dMM46aMOySaVayCmcyYeCLrOKrlwFdLNhq2Hd2kF2WQiWd1X0FGJ3noz0RKi9
	cfIviUc0xW2rtEEThdW0YOcgqwXqDq4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GJotxEZo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761555190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1SFbXbwu/ePc1DQgC7lnHgCpffeuAr2Hs5LpPIUuFM4=;
	b=GJotxEZoFx8sIisRu4wQASX1sFEXgoyMGt0ian2JabetFdavHE3TA9GGZCAlNvEAwkxHIC
	LMKTU3goX7KSeJEFby+UIDWs+6EcdjwYhXSgFGG9i+tQLReZUSZRy02bwIiDWw2aQWJiJp
	uoztZZcEnbreSeWtRVW8HfZ/5bB5htc=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH] codetag: debug: Handle existing CODETAG_EMPTY in mark_objexts_empty for slabobj_ext
Date: Mon, 27 Oct 2025 16:52:14 +0800
Message-Id: <20251027085214.184672-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: 3g6mte9fdtyppe5nekcjzt5sisjnnmm7
X-Rspam-User: 
X-Rspamd-Queue-Id: C54E91C000D
X-HE-Tag: 1761555192-961862
X-HE-Meta: U2FsdGVkX1+NhTgfNIbTjxlQjgGbLv9JxltNIPCW7sefLhAkiViE3Yaj1J4iIIGujdNjIiXRBCCYEQDV9I4W/uecD+gQjpyxN0k//yf3g5Kw/NE+Y9DHUNu/7Wu9N9ov6XEU+ksnvy27fjHXYyknPgwKcuJ/4NOoCcIG/fPGtPnlmBR0jRAW3mIXOORfB5pyF06b73tv94dKOjZQoawYhkQ9tVFyS4Cm93xXNOi3o8ujcRkZKV3AI9YnpfK2fHRywjoOrkvtmLY8dl9jCrCiOUrOJcyOtnbHkk6LfYcMOawP1rgTP0ZsjeKksMDUoXlIu8lx4VDEcf5RhtO+zvRzf8XJBvrXYDBwZuH3XzrxW9nosX3ApuaZg/KVI3ZsHna908ZzRUJ7IMdf6LtSUi8TDqjoxg5vml+P+wz8z+EECRqKxBgLFSyqIBTe96AqKNRp+MYoLKpGJ1sCioHKlRPLuB14JejWhdcbsO4DyDzHjiIbCk59HBfT0WZFey9uW5PmMUnchqKMbXVT3QHeB7vguidQj/e+ngcAbIy9uyuGuW1cYN9X7EnxLKh6slY0mn3p6XgxJfZENu1Zy47obP3+oUOWlrT6ziZgiLW3dJOd0PGzrYwh8iGJkuzjujT7afSj1sn7U0FAVBxVgryPxB024sh7rianNbpw8X2jat4kkHVVt/NLHrGtXBYyrhfgVQTH9++akHog1h70u3152hcNmpQaJXRDPCvaF8AXVn0Ytt2gevwP6q7BrqyRO+5cqNysVroyBDGiIRVYvSR1ZrVfWPAxrU1q0gIqSHMipfQelHfzTfRgbZ8YI/GLmCqiC4pKa1tFkfq2yHE9YeznsXLHluXmGFzWzHYmyWSY6SrxVwx5ORkjl2xF/m70mwfuUmqJv1Hz51RbZ8+OvdMjgU4iRG7txWuJGFMvgkk2bx7XmpYguMUizRo+xdqKeU+nf1t674PlVcVTolTrG8bKnAZ
 Dwehh6KB
 tZbQBGcuFoutE4eMNUiA63rWFvK204PxoYjwvQBYO3qHGG9YZSpE9U+bX1KDaJdZvYMJwtbobneMdyaLRrrQdFJJZ0uQl143udmMRGHZsxTfx/h8+jobti1GORQjE+2vFSlZ+fflay1vShyEhjlHyayEGnvQ4PcIxktKO0ujasV9FN4Wt8pzMvkqh6WxkG4u7QxYJlqM3IZYA6f228yue6xOhHwMCkJ+AxsbVmf7ycaI+8gYvSu0F6GVLNlOESQa3KMUPDw9ZI3F+yuHndjoKBTXtyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

Even though obj_exts was created with the __GFP_NO_OBJ_EXT flag,
objects in the same slab may have their extensions allocated via
alloc_slab_obj_exts, and handle_failed_objexts_alloc may be called
within alloc_slab_obj_exts to set their codetag to CODETAG_EMPTY.

Therefore, both NULL and CODETAG_EMPTY are valid for the codetag of
slabobj_ext, as we do not need to re-set it to CODETAG_EMPTY if it
is already CODETAG_EMPTY. It also resolves the warning triggered when
the codetag is CODETAG_EMPTY during slab freeing.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
 mm/slub.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index d4367f25b20d..cda8f75b72e7 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2046,7 +2046,17 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 	if (slab_exts) {
 		unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
 						 obj_exts_slab, obj_exts);
-		/* codetag should be NULL */
+
+		/*
+		 * codetag should be either NULL or CODETAG_EMPTY.
+		 * When the same slab calls handle_failed_objexts_alloc,
+		 * it will set us to CODETAG_EMPTY.
+		 *
+		 * If codetag is already CODETAG_EMPTY, no action is needed here.
+		 */
+		if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
+			return;
+
 		WARN_ON(slab_exts[offs].ref.ct);
 		set_codetag_empty(&slab_exts[offs].ref);
 	}
-- 
2.25.1


