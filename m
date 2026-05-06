Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15113CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 419416B0088; Wed,  6 May 2026 10:52:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA016B0092; Wed,  6 May 2026 10:52:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3073E6B0093; Wed,  6 May 2026 10:52:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22ACA6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:52:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0CD7A01FA
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:52:26 +0000 (UTC)
X-FDA: 84737285892.18.A54F083
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf07.hostedemail.com (Postfix) with ESMTP id F096840006
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:52:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778079145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=gm3r6XvAzplY+rEalmoj8Yu71pABThvhETrnbJpSVE0=;
	b=eHUAz1ZQzj4R95D1oTJAxA46N3IPzVfUReCAzP/CgwBVW65NDZjvKL3aeIwcU1hJ/LkVMd
	VbcDyityuUFLnohb0XRwfRTEUO8AJAHrJ+qwfiQ4suLklzfssRdYmuHCQ0/m9GhqbEiDbp
	Ej4U11D8hbtHXld/OpFYApKIhr0jk3U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778079145; a=rsa-sha256;
	cv=none;
	b=xz/OPsqvOkCrqO+wshdzdwKhnVCRMwaMksu6jaXYCFIH852nhg/MDrRdNeEFfeCziKDYoa
	zCbg0JZ6buNcHfA2pGK4t/F0FCztlc4Hr5mx/1Z9i5bGw+FDOQ3H3w/VMSgRJR7qIcmXF9
	518Gf7//BYEvLgQPjYaqILY9u19hRe4=
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB98C1201A0;
	Wed,  6 May 2026 14:52:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 1006632;
	Wed,  6 May 2026 14:52:20 +0000 (UTC)
Date: Wed, 6 May 2026 10:52:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Liam R. Howlett" <liam@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, Alice Ryhl
 <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>,
 maple-tree@lists.infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] maple_tree: document that "last" in mtree_insert_range() is
 inclusive
Message-ID: <20260506105218.2d027cc0@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+kj9YBeXscDLq874zLU7zgLj+l26bmBXA=
X-HE-Meta: U2FsdGVkX1/cgatkWo0EqaahDtKU5HPgw4gZTQ81Jbc7hM1/Geamd84zEdzF4AarhJyAm3mXQ3yqp5ltGn3PXHhfD8NieJ5oteyfMkoXHDjiAd1NvGu7Moz8SjjRfuaT91qXlvUjjXFiMHzELM/XZJ+rWSmwGgF+4ZBzKGN0Ta5n+KYhfQwGB8tKNR1OD0djayL0umKSJ9K4P1B7pfZfG6PGJRYe8AEuHFzQe9ULCyyKlcbeKgmMeFPD0Ta7IOMdc4mz6XiM0greIEBTpnIDX0+CdmWese6GKnGqkevdD1saAkTwHPy056V4+CTA097VPMu+aW6F7iGXhsF7zRNsHZKqd71c3Ym1OeYfd9D4OF+ADLj3YgDE84T7i6qzCS+h
X-Stat-Signature: y4yubf5yuioqdrb6guydznm8pwoa8p4m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F096840006
X-Rspam-User: 
X-HE-Tag-Orig: 1778079140-721101
X-HE-Tag: 1778079144-962627
X-HE-Meta: U2FsdGVkX19p41UIvEsTFjHw8lEQGTOBpfyqaMCwcRvxBOoJqcunCutznUc6W9B742JsjIcHt5MNmWWp+6Hwbmmd6b93+KqJdQBy7BA3siH/W09Zlp50nTBMp7/N+zfZ6/16919rZ6pnmHX1koMZg1ESDtQBBtg85wDhTTQARcjjnL78EjJ1DmzXj18hg6CrR7FpcdVu6lJZR3b9WnLuPM8bQDFGkGEUMw1kGJWbbpN+iZ27pRCLM8QJTt3uAMu9fW++uw8p3aVtrK8IB5WSEd8X/AZ+HYMXjjWI/CcNFCmFajOY4XLnfOMcfVBo50fSOLk+eWnyoL1owauIwRkCy+uMQ8m6xq2JauDGVPtd0XO4n6H/dZXpyaVLehxMcTWcDPkya8kWmZ/3UYlvemQTtAE/LvcD3UczRyRuRrkUJkFXXCxnvhh20CUreXm4UGsNbvrwe6MUY2Ozo8SHg0NiQvJ1IlWn3Q7LxPs0ODS77a1Xd09PiI0Yp1teUe5ComKyr7wSEMbnNt2sBC+as+NN6eOAHcGa53hcTiuEuBBDfLu+0wbIBwPaY9JOhOcNvgETE8cbtUcHYn7cns7Kp/Q5lh2g8/JoaoP2Cve8iRm5oHncoPjC4WJmurS/5ogtYmoPXdvtyW+wugnP8Q/7PVRuh/Lleyxg5RBEb1ClpD9glsNC/UmaBbFBw57YSfLpiE958s8hdJ8reRP8nUgnykwMnNtf7SPKhYvBzoDv53irYsq0hkZUV7YGAUuUulvEtdecFMWBYJ4Blv9b7Izyv3kpAIwEpNBQH0+NFpFis7I8PMAJYozALEkQClP49xVu7wqAf9jgFdZFoBcJ/iYVFIsF+cdr/Kvcfq/GFYP9FVDzwYifmMEibrwHuxSPionHz8kQoa7zPv7I9Z2OtWTNys3RWAC8CxF1H7+2HMclkxbs+6T4zFZYVZfnD1hkFMp5VR3G8xG1R9buSqSZQAL1crz
 66xklhsf
 71FfEf9iM44RCrz8SKMoqp5Y0S+H71kjwV6WV0u91/JyF0jP4Z3U8NrCMGFqUk6SFckkBH04KKfXme6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Steven Rostedt <rostedt@goodmis.org>

The kernel doc of mtree_insert_range() does not state if the address
represented by the "last" parameter is inclusive or exclusive. This can
lead to bugs by code that assumes it is exclusive. Explicitly state that
the parameter is inclusive, and add '[' and ']' around the word "end" to
also stress this point.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 lib/maple_tree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 60ae5e6fc1ee..dc9591218446 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5730,10 +5730,12 @@ EXPORT_SYMBOL(mtree_store);
  * mtree_insert_range() - Insert an entry at a given range if there is no value.
  * @mt: The maple tree
  * @first: The start of the range
- * @last: The end of the range
+ * @last: The [end] of the range
  * @entry: The entry to store
  * @gfp: The GFP_FLAGS to use for allocations.
  *
+ * Note that @last is inclusive. That is, @last = @first + length - 1;
+ *
  * Return: 0 on success, -EEXISTS if the range is occupied, -EINVAL on invalid
  * request, -ENOMEM if memory could not be allocated.
  */
-- 
2.53.0


