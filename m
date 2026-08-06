Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE8A1C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3AE6B0098; Thu,  6 Aug 2026 10:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54496B0099; Thu,  6 Aug 2026 10:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6A216B009B; Thu,  6 Aug 2026 10:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7649B6B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:29:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4D681C1414
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:29:37 +0000 (UTC)
X-FDA: 85071077994.19.923744D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 68AB4180002
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:29:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ktBvd0BS;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786026576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5BWkZq/C4vFDQQrLrb4nj3IuIxBx9GSl58cfmq6opA=;
	b=LamdJlODWdrKJ8Q3jxI0KjCTllwPm9+W3SHkMN3dhYcqb/bVzWW7ZAUE21GMhp+uId6RsI
	PoXdFES9BaqM+e3CIyoF4MvX1Gj6jrAdDQQIPD45YRa2JEHztO4h7snOo2xskZYnZpKxgU
	3t+N855O2y7lCIT+EZW8OWdqItpmJI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786026576;
	b=OmNXJaiIDYHkDBIfM8JnSqynv8+QrwC7mjboYcIiWlKzyKFE/eAf27EOLmrdZ3Oed7cr41
	GpvzfEMX+ztVi3iMzb9Q+Qwsik6r3yh1eRCK9ciEVIwqJgPWJzpPu6AvansWC2cOy0bV6c
	7e+OwivgnqlFUrM2km6EvQZ6UjYr+dw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ktBvd0BS;
	spf=pass (imf24.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A5BWkZq/C4vFDQQrLrb4nj3IuIxBx9GSl58cfmq6opA=; b=ktBvd0BSfciz8PMJcsrchdochm
	BjAkTmf3HcoHixYrjB6pBA9/D5Dwyu2r8rPABTSJn6GugDmVzg8RU0f0JIg+qIU4UD3ekBR6yjCEX
	Rui8+6ufoS51lahST0f0QmwN5EHmP5Em39/M5tI6JaBT6jO/SGnQSN7ZmBzNDLDRIIdS8MTpDTeOn
	9xhswGI3nC+PsfRQH3F+286V1Xr72lDuKFIMcbfgBNd9ltQNyRJoPVYrxIR1yBJJXyvw2y8ddMZpS
	J92TYMU0nJoi/ZKaQxKIWyHY/mWgDz19KD5/zFerZ5EHyiRWBjyVxaCtZhXuPhTmr3VQTh7y/Yx/u
	lkuAP8Mw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrz69-00000005yvP-22r7;
	Thu, 06 Aug 2026 14:29:29 +0000
Date: Thu, 6 Aug 2026 10:29:27 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, 
	syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <hg73nwj6fdkqect6xzf34i7e4ki5izjyzb3lz6ery62sq3566k@i7tsboqhsdxd>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
 <20260805004619.GA28508@ziepe.ca>
 <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wzxrnoi4rqhkjf2l"
Content-Disposition: inline
In-Reply-To: <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 68AB4180002
X-Stat-Signature: uz1wk9n59c8icsepwmat7uk4c3zazx5a
X-HE-Tag: 1786026574-481037
X-HE-Meta: U2FsdGVkX1+8tJLrMwEfDdnNkx9wMf2ZYJ0rJk+AgwuqaYwisSlcPwmFm5UYgVE9TZgFvGJQRvIthU3ouy+wybRtLlE7EC4rbcws+yBKO9N8DQriNxXhn4AzwBiBKEChJmKAvN2XHP4Iew8Enr3Ir+L8otoh0tDH4KHhkV0L1z8/Zh/T1md6hb6LGIImc9YUhbJUX4rB0KqrUK8qPlfkvPaibSXZ/5Y8MyGth5Eqm1FCgz910GCfk6NlfjmtAXA4ayft4/k2zp+VRZrJwKaeH167elzX8W7MHQ4nba/fUMUsErweFdw5h/be+EGrTuRxf78+aHurTwuQ8I+0XF0FiNbDXjdn9bra2ddQPQ+BHBL3JH25SN+fgMGqi/7OjbG1YUdMjFnSiVe4RUr8DTJV7AP3SR3L4Yb0j+4XBv0HzFpK3NZ7jIFqKSc3hWdA9Bw+K1RqZfBlLEyI0PL6GLsj7BSook5sWxbpFD8tgufYw/5wUMZx06uYqD1RQNCIGDL3c2jS2z0fkDaI18KdECkcyN3Lt6eoKnrssg16crmU0D/jC5RJ82bI1hEYsezwEs8ic4kpiYp35O978ASZSyRi6kw5vZq5a3Dm20J5TFF7g1cD1cVQPqEblWOZtDxdxK2ZSG5b40k1yadIEFuxaTuQDrLSlOu+C+Mg9BR63aq+rNGvbbpxr1Geqp91C8qpi3AGpDGfyEQGlQtfN7KSufLd/ZWzU8nG5ka7f20giOQ+XBY0HVvNQuWrjOk89BJvlkuQGOq9z8XvsqZTgAsfMkaVX/OiXuuP3VojPblGI/fHh6aAcL/P8x7+sfTrnkZNGctaIg6L0FXT+OyihVxGHzjf26xmSEHgVMWI9jfuF60rZuEzNvUnSL0VSbwIMTVvrvxEEy8gp2CilptzjZAYEFBBejKlYrSN/DxucrQz99VEICA2G4sFgFps6VWHsk+YNkb+FC682avdNIWvVJqEqnV
 U8S1NEer
 P7Dy52IQl2ZRcyEyXymxt4ldVA+r5UsgZbFVd/RC5L6nsLx1a03N43J6ZAEg0O3ieB8j7gKuq94JokgKWv+N1iPkfm/pn+KtxuQ+LF9vxVRh5Y8QAckhkn1ECmGN9xOWTlchnfmcaY9vLOFh1oX2Lk3Ccex7hmLzn7ywwk56mpzZ6F5GJGkqBKNPSQTH+s1TpgaG7NR9dLVRY3F+OZjUug86AiSjaicpfYQxcwVug8LGXtsWaDmaYkGXmeXnwyStjMLAeUQAvVSYNBmuGpO6lUf17Ug3Ve+l1GeLDkDxwLGJVunDVvbLNoAz6I14kXe642KYswjN5MxzLiPwJoZyRVszVNeu6YOOTbvLva6YOBt1e3jba2Q4YLnkqHH2ZrXXPttRApUKIIzpyKC2getdai1wVC8BtLhuFE7dVDbrj3WENbdvPfuq0rFlyMWqx8Q/ABjmLkzGtj8XT1kwyj6ffy+9jy5TkcRqwuTejDYcO/hUi9Haodc+0P3id8Yjpqfm6Ly8W/dSknkB+D5eqLtSIW0fwiUWK65q4XX7r2jRp/eBsEPjkOH+NtoIR3F6WSpW6Qv/9ziRf1a5/vWkWhCVJZN627NujDPMsIFyaXOn4AtKQCn2qquEBfgyO6xYWTCwQrYzjr9dYd8wFcUTJBQl4pi5JxjBQ1T3BoVYDGS52XbK1OvT2R7sxMG81XPsBShAbOFvH27xFmjVLw/S6BZeuUZnfT23IkAJhVOsa1PtoqNzd0PE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wzxrnoi4rqhkjf2l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 26/08/05 10:01AM, Vlastimil Babka (SUSE) wrote:
> On 8/5/26 02:46, Jason Gunthorpe wrote:
> > On Fri, Jul 31, 2026 at 06:07:24PM +0200, Vlastimil Babka (SUSE) wrote:
> > 
> >> > Thanks to Vlastimil and Pedro for the help on the plan.
> >> > 
> >> > Summary of previous conversation is here:
> >> > https://lore.kernel.org/all/20260618152451.GE231643@ziepe.ca/
> >> 
> >> Yeah, unfortunately, "too small to fail" is a lie, because in some cases it
> >> can fail (such as the task itself becoming oom killer victim) or any of the
> >> other conditions that can cause __alloc_pages_may_oom() return with
> >> *did_some_progress == 0.
> > 
> > But then we are back to the original problem, an erase API that can
> > fail is fundamentally broken.
> 
> That's why the plan is to add __GFP_NOFAIL, which overrides the
> possibilities to fail listed above.
> 

Something like the attached.

--wzxrnoi4rqhkjf2l
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-maple_tree-Remove-warning-from-mas_nomem.patch"

From 7943966dfd4eb8470d79da1fef2d81cf4cf59983 Mon Sep 17 00:00:00 2001
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Date: Thu, 6 Aug 2026 10:23:00 -0400
Subject: [PATCH] maple_tree: Remove warning from mas_nomem()

It is possible to trigger the warning in mas_nomem in certain call paths
using valid gfp flags.  Drop the warning and handle the failures
differently.

Instead, have mtree_erase() and mas_erase() use __GFP_NOFAIL.

During the discussion, mas_store() was also flagged as a potential path
that may fail due to implied gfp flags.  Changing those flags to retry
with __GFP_NOFAIL is a viable solution there.  At the same time, adding
a might_sleep() check to catch incorrect uses is prudent.

Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
---
 lib/maple_tree.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 0954d431bf981..4fb7a209dcb2d 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5577,6 +5577,9 @@ void *mas_store(struct ma_state *mas, void *entry)
 	MA_WR_STATE(wr_mas, mas, entry);
 
 	mas_may_init_lock_check(mas);
+	if (mt_external_lock(mas->tree))
+		might_alloc(GFP_KERNEL);
+
 	trace_ma_write(TP_FCT, mas, 0, entry);
 #ifdef CONFIG_DEBUG_MAPLE_TREE
 	if (MAS_WARN_ON(mas, mas->index > mas->last))
@@ -5609,8 +5612,7 @@ void *mas_store(struct ma_state *mas, void *entry)
 		goto store;
 
 	mas_alloc_nodes(mas, GFP_NOWAIT);
-	if (mas_is_err(mas))
-		return NULL;
+	mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL);
 
 store:
 	mas_wr_store_entry(&wr_mas);
@@ -6351,7 +6353,7 @@ void *mas_erase(struct ma_state *mas)
 	/* Must reset to ensure spanning writes of last slot are detected */
 	mas_reset(mas);
 	mas_wr_preallocate(&wr_mas, NULL);
-	if (mas_nomem(mas, GFP_KERNEL)) {
+	if (mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL)) {
 		/* in case the range of entry changed when unlocked */
 		mas->index = mas->last = index;
 		goto write_retry;
@@ -6402,7 +6404,7 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
 	 * external lock with a non-blocking gfp in a low memory situation -
 	 * which would have triggered the first warning in this function.
 	 */
-	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
+	if (!mas->sheaf && !mas->alloc)
 		return false;
 
 	mas_reset(mas);
-- 
2.47.3


--wzxrnoi4rqhkjf2l--

