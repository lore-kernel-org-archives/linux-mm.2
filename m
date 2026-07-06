Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3647C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 04:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BFC36B009F; Mon,  6 Jul 2026 00:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741F76B00A0; Mon,  6 Jul 2026 00:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6314F6B00A1; Mon,  6 Jul 2026 00:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FBCB6B009F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:40:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CD788CFCC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:40:49 +0000 (UTC)
X-FDA: 84957101418.18.4916CB2
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf28.hostedemail.com (Postfix) with ESMTP id 32AAEC0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:40:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783312847;
	b=3n1mkDF9wvoiHuC+vnGkBuNiE7D3ni0y+nHpF9VPP6pWFe443wag/58bV56OkZE4EUKwTN
	h1QO76rOcrZIknTZc9yxOXbreIfRekFPhJqtNx80j9DTZ7cAnw1UGTv2bIeaIWJj97KMt7
	ZGZ/EdiUOrAiSosrBJL0ePWhLrVHiDo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783312847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8zUpMqyBJ0Y1apS4i4s1jiKdAyn59KuwpVauBtL7IPo=;
	b=EFFvjGSHGATjMIl21aPJz1RJuCZrNLH/pPUHyZXWKn02Gy93YUafLN+PMROKH0SkA4vvrG
	OICspbtgBM8CgAoJGh+TKRSBFb2gwscR8lB6DSYJdT8+mjVAR7fhGDji3fl1Y1I2mjbjyE
	OYzOiKB0NB6lLAXLMh/ueU7YLDtKR3I=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gts9m0JQvz8Xrrg;
	Mon, 06 Jul 2026 12:40:44 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 6664edUH088961;
	Mon, 6 Jul 2026 12:40:39 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 6 Jul 2026 12:40:39 +0800 (CST)
X-Zmail-TransId: 2afc6a4b31c758c-43279
X-Mailer: Zmail v1.0
Message-ID: <20260706124039747M7gtCsrOvuzDyfLMXIJ2B@zte.com.cn>
In-Reply-To: <20260705010000.1f9b63735aa19fbfb5d9c24f@linux-foundation.org>
References: 20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn,20260705010000.1f9b63735aa19fbfb5d9c24f@linux-foundation.org
Date: Mon, 6 Jul 2026 12:40:39 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCB2MTEgMC8zXcKgS1NNOiBwZXJmb3JtYW5jZSBvcHRpbWl6YXRpb25zIGZvciBybWFwX3dhbGtfa3Nt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6664edUH088961
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 06 Jul 2026 12:40:44 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4B31CC.000/4gts9m0JQvz8Xrrg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 32AAEC0009
X-Stat-Signature: 4cei31ccc36j76srq9ibko5fp5xww5db
X-HE-Tag: 1783312846-975676
X-HE-Meta: U2FsdGVkX1+aKJlzgU4Oq6q+uMLfBcAtcfbiUPk2dQVjBIC4evbGLtMfhM+Gk4zBi6tHw/zfqqZqgqqAlRqKABnHh4knVyfOKUu4PqheT8ChBbWWBF/lIJMxih51GvIPRPuItka94JqIkmTNHTMfajDwGFLq32BHf5TzTsVv2E71aVLJUeKGPHX97aSf3CfjkjBpgcAitIk368yzBtZ4RImGrGD7rSOy7XJ7gPQbhbiswwP64vPIi4iDxzgvyn5hX6H2CDDL0WiuWJRZsJiMtSl+CziKhFZfr79cehPlrV4XvO1cGXztZ8eUYqWbQu8aMg/ZySkKyQ2MgK1sP8d/dAI/1BDyhs7khDWpVUcC4+d4fzu2s8Hby4GqoARxSkXTWwMGxwF97HW7m6tA4/1zNZTEdqEC1LBY+/we4n3xP2jyZM6FSSKsO6gGUZoA5TchM5pqUtbFTvp1AlUQx09rBRNLusQ3LCTrg5FlG8hUwmptfgAdlE/WyjE/TD60XIWhfZ+0Au7Vpsiadz4+jv/MzeptGQSZ7XkNPdvUHpDakcjC0zo1gMz3vVhsrH7NocDScO0oovD8O6rvtS4dnTM/+oerVjA8InM3F17+3uA3AF19sz3DCf5RgsUon3jr2C1BcICaMxbIhHv86om28MrkkEYM9Oso5jgFV1mVRRnnUUc0ZTINZbxb3IZbJgY1zIamZxkuzHscSarE5n5H15NfXap5Vb6j9IyGnoU9A05tKxyNsJIKtKAO0yQtrw3HgcI1/CO+jzhGvO/lQBdxrLeyAQfng1QtIdA/E3xKPufks+S/PuT1KrV8mqHZKehLuKzzSjMvfwIzOWfEYXcxPEhkUrG2aR57ZRTvsycDSFayom89T8ZsF0MhiRwhcenn2A3Z0UuUkutEgPr90Z8+O1QKSxUDlZauRfevqpmMTg91OvJM/hZkReg3ElfQBcxOBsz+8GNz1pa+M5Bz1Y2/d6v
 fDvaMNKN
 XmB+2L1lur3vLxPzW1XoITrMTHUMVC155Xf7mdQ75hj3lxUJKnG44a73jJiE2honFRXjm3Xararao3jU6dlpDlLK3TEChMqH/TkLj86VgXY5As4z2zLzFw/HC1NqRovib596pbkLkQ6aXffJqsE0Ijgs3O4O4kl9ED9v/6GhquXxglmlCPZyabJJQvQU1giwDryHjjK5KVbvlVvOvEJkR2YAtR8Zw8duXJwwixpGENoMu4o9i1iPCqjdvdT4WjchofWT3vQ6LvfD69lVMXxMgXo7PvcIrSNr7YO+d5Byt56+7YOQshj6rnlTv9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Again, thanks for persisting with this.  Great improvement and I'd love
> to see us get this finished off.
> 
> Please have a look through the AI review:
> 
> 	https://sashiko.dev/#/patchset/20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn
> 
> That 32-bit thing looks legit, kinda fatal but easy to address.
> 

Hi, Andrew, This is not a major issue. I think it's acceptable and detailed
analysis is as follows:

The sashiko said:
"
> Looking at struct ksm_rmap_item in mm/ksm.c, the linear_page_index (unsigned
> long) is placed in a union with an anonymous struct containing oldchecksum
> (unsigned int), age (rmap_age_t, 1 byte), and remaining_skips (rmap_age_t,
> 1 byte).
> On 32-bit platforms, an unsigned long is only 4 bytes, while the anonymous
> struct is at least 6 bytes. When break_cow(), remove_node_from_stable_tree(),
> and remove_rmap_item_from_tree() assign rmap_item->linear_page_index = 0 to
> reset the age-related information, it appears this will only zero the first 4
> bytes (clearing oldchecksum). The age and remaining_skips fields would retain
> their stale historical values from before the page was originally merged.

Indeed, on 32-bit CPU, that patch doesn't clear age-related information, but it
doesn't introduce any issue because at this point the linear_page_index and
age-related information do not overlap, and there is no conflict between them.
This is clearly consistent with the logic before applying the patch, so there
won't be any problem.

The only change we introduced on 32-bit CPU is the overlap between linear_page_index
and oldchecksum, but the zeroing issue here would only cause the rmap_item to
be scanned one more time, as previously discussed.

	https://lore.kernel.org/all/84886648-8cbb-49db-a816-de3e0d359ed0@kernel.org/

> If these fields remain uncleared, could this cause the smart scanning logic in
> should_skip_rmap_item() to read stale, potentially high age values, resulting
> in newly unshared KSM pages being erroneously skipped for multiple scans and
> silently degrading KSM deduplication efficiency?
"

