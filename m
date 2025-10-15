Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3658CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 16:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 264838E003F; Wed, 15 Oct 2025 12:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C8E8E0005; Wed, 15 Oct 2025 12:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12B4F8E003F; Wed, 15 Oct 2025 12:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 027718E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:44:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4392B75F7
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:44:43 +0000 (UTC)
X-FDA: 84000922446.08.B7CC0AC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1A7B6120004
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:44:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9Yii5zg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ITbL+y1k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9Yii5zg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ITbL+y1k;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760546681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98x3oan5ZQ/cd3QQoCx46VxTuy0CMcvOqM9UTT3BM+k=;
	b=URD9EBZyalJUSuBLXQHQsV5zY6BI/YiD3VjA7F/R6BCFNCPTmfoMA1ZnF2yNKSeWEKi6j0
	ytDyUDoTToeFJ/xYKWvHNk4DSzz0Ki3ac6yU5bYlcihTXg48Qd5Gy5y0JsQfrAzrJpyxV+
	lQ4z2xSo8ypu5awkTMcRea81ICJL+hM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9Yii5zg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ITbL+y1k;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c9Yii5zg;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ITbL+y1k;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760546681; a=rsa-sha256;
	cv=none;
	b=ug0P8Gc3zi0/8z2ODIe9D0Ay9Ka3W3yLlD3fPwPr2vDT/zH8bIYqwcUtr2I4iFaueWNqql
	vcNPfJUjt9slDeZpK8zfcFk+iYvjwdskOuqtZY+ZDrEwxGGXwKHsZKGnSReScDZwvp6oTY
	Z65jpo+V7C/RQQoY0cgh8jk+S4ydMJM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3E4645BD2F;
	Wed, 15 Oct 2025 16:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760546679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=98x3oan5ZQ/cd3QQoCx46VxTuy0CMcvOqM9UTT3BM+k=;
	b=c9Yii5zgppVLzAeN0+mOjMYMbMhOChMBY7KB478cHe6JCqABtbiQcezXpG7KPqjDw2WLN6
	Xa6p5G1nOOrKBHxoGu4MuQK+rsipVitaHWYZYZjxPwqVbOzXFzyNQu+LNbAHbEgxlwJahO
	vyxa75Ij3tIaqJguuVC3LOC/cXyZVqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760546679;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=98x3oan5ZQ/cd3QQoCx46VxTuy0CMcvOqM9UTT3BM+k=;
	b=ITbL+y1k4oIggDVJc3M2+pnIWOtEqRKjexzkmQ4tG1c8SQDFHUOsZuacpFdKBqEJoMaZSK
	xhsE31S/qQQpmtBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760546679; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=98x3oan5ZQ/cd3QQoCx46VxTuy0CMcvOqM9UTT3BM+k=;
	b=c9Yii5zgppVLzAeN0+mOjMYMbMhOChMBY7KB478cHe6JCqABtbiQcezXpG7KPqjDw2WLN6
	Xa6p5G1nOOrKBHxoGu4MuQK+rsipVitaHWYZYZjxPwqVbOzXFzyNQu+LNbAHbEgxlwJahO
	vyxa75Ij3tIaqJguuVC3LOC/cXyZVqU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760546679;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=98x3oan5ZQ/cd3QQoCx46VxTuy0CMcvOqM9UTT3BM+k=;
	b=ITbL+y1k4oIggDVJc3M2+pnIWOtEqRKjexzkmQ4tG1c8SQDFHUOsZuacpFdKBqEJoMaZSK
	xhsE31S/qQQpmtBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1F6F513A29;
	Wed, 15 Oct 2025 16:44:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EG9dB3fP72gyDwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 16:44:39 +0000
Message-ID: <0928dcc7-a4e0-4641-9381-6adf2ad30493@suse.cz>
Date: Wed, 15 Oct 2025 18:44:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] slab: reset obj_ext when it is not actually valid
 during freeing
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
References: <20251015141642.700170-1-hao.ge@linux.dev>
 <CAJuCfpEpO_HaJuV3ukDtTdw_5zCq9R0MnMexC5PoEwOcKWjuYg@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAJuCfpEpO_HaJuV3ukDtTdw_5zCq9R0MnMexC5PoEwOcKWjuYg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A7B6120004
X-Stat-Signature: kn1hbypgj5zs9zquph3qduh4sdbpzchu
X-Rspam-User: 
X-HE-Tag: 1760546680-768785
X-HE-Meta: U2FsdGVkX18Ev5uKHKGtvFToHuniTD4guA5wVnNrv30hiO1pGLLeWqFgkVXPRN1vIlpiWE7DmCMANGqkGsaAvHetyAOCa0b8gGWGAqy2ag09DXr5cFDyVfrPXrDUgN7cnlT7+3DA1BG7UGaBdgGvWfmECCFjP4My6/W5+gAQYZRzyIX0XLAKBTEN8prJqjyVORlTYJEpVGDyiS9Tl2EILIrA8f7AWSDyENRo4y7oBsl+XyrPCNMPmbXGGiMJqPphT6IlVwOamKs5nr4thqMMg2QskdNtSqFUELJlK2+Nfk90sK3wDOMvU3ofSzPGw5ko3yygBR+3bb4RpZUhX10PjaFUl0vlaFbC/zm1kXNe9tySdhqN4BUilO2NQKkvZ9otYkhJC3MySWtgpqFigMp1jsYGdhqyE08cDU/q25zkmD0EJNTv70PdKay0ppfCtZO7yOqYOyvC8tcFUxFc5FyTnJ8oZv9q8T7ruJ1V6FHDnhTqTHtOdpA83bH8hm8VtuYMDFSoFCocoVgKB392qqjpq3+RBH2Fpu9OL49OuMtHkaZlgkNFN+CZZnb8HjR8Cj8U3dtmAbZgI+t0+zxvS0VRVZ3tuF8HJv32s94iROPuHiReMJVtYh/G+Agf+0tgo2f4pzoc2u3RRVNK/jc7cHVl68mgl7pPvJcLIV3WE9imM2GRzX+ohiV/hxNLghrv2M4dfnYfNjmV36O7iAxPwvwA+7LYAfcoS3kE1+wH0XFGzIfSz81cGl00NW2qJyDJ0SGkwfxHCy1VFx/crHbT0oX8etqaHeDf+tvrVewmSqfSBNj+r/ywEr2WIxLDpo5T8/ehR+NgQzDFBC7IXAvcC9dqjsNdtfvx97Ov4OwSQPgCWY6+W+mqq0DN59DAAD0iLg+GvxfhL4hO3zFuJOyjn2OaQIVX51EXKMqjHmioaD7Q2vkkKrOFasSOfyGb1h8wo3qRScNv3mFHDWailJoBM1a
 PbqFhFJc
 wjITSmgF9cOUULZdkaqF4Sp5mJFtp3l5Aa9ap/ThDSitzCUYD6lwQ8pUH3wLSyc56Y+1SsOzsuSCSp2RTYt2+WKuSMaS8+DhDF8tFIowC1HCpg/Ey4JI6oFNKX6GKb5y48rzvoYIAfn2H/zndRvLFroAx/Y4PfHlRuLVO3bjcnfwPoKUukXpYsvwNSwYXJPBy9HTNFjFUUr5qShwYP4eL7kH39bacdoJuLHqYoAIgq1rZFJA983HXV5o/5hF02MKN01OdbMXBMVqflagtFL+8UZcY2x1zRxKSprbUrTE9N+xW+8IubSGMWszXDHEUm7/k5SW3NlcZ+g/Hw+Vg4p780lH1GEWZUFLl3vHp8tn/6zgiU2sH7+zOccAuvkflvqYITj6G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 18:29, Suren Baghdasaryan wrote:
> On Wed, Oct 15, 2025 at 7:17 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> From: Hao Ge <gehao@kylinos.cn>
>>
>> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
>> But we did not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
>> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
>> release of the associated folio, a VM_BUG_ON_FOLIO() check in
>> folio_memcg_kmem() is triggered because it was mistakenly assumed that
>> a valid folio->memcg_data was not cleared before freeing the folio.
>>
>> When freeing a slab, we clear slab->obj_exts and reset it to 0
>> if the obj_ext array has been successfully allocated.
>> So let's reset slab->obj_exts to 0 when freeing a slab if
>> the obj_ext array allocated fail to allow them to be returned
>> to the buddy system more smoothly.
>>
>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> ---
>> v5: Adopt the simpler solution proposed by Vlastimil;
>>     Many thanks to him

I've massaged the commit log and comments a bit and also realized that
AFAICS we're actually fixing an issue that predates 7612833192d5 ("slab:
Reuse first bit for OBJEXTS_ALLOC_FAIL"). Am I wrong?

----8<----
From 8151384e5baf34db5812ed51e2e463796ab6e973 Mon Sep 17 00:00:00 2001
From: Hao Ge <gehao@kylinos.cn>
Date: Wed, 15 Oct 2025 22:16:42 +0800
Subject: [PATCH] slab: reset slab->obj_ext when freeing and it is
 OBJEXTS_ALLOC_FAIL

If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
But we do not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
MEMCG_DATA_OBJEXTS currently share the same bit position, during the
release of the associated folio, a VM_BUG_ON_FOLIO() check in
folio_memcg_kmem() is triggered because it was mistakenly assumed that
a valid folio->memcg_data was not cleared before freeing the folio.

Another problem that predates sharing the OBJEXTS_ALLOC_FAIL and
MEMCG_DATA_OBJEXTS bits is that on configurations with
is_check_pages_enabled(), the non-cleared bit in page->memcg_data will
trigger a free_page_is_bad() failure "page still charged to cgroup"

When freeing a slab, we clear slab->obj_exts if the obj_ext array has
been successfully allocated. So let's clear it also when the allocation
has failed.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Link: https://lore.kernel.org/all/20251015141642.700170-1-hao.ge@linux.dev/
Cc: <stable@vger.kernel.org>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 13ae4491136a..a8fcc7e6f25a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2170,8 +2170,15 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	struct slabobj_ext *obj_exts;
 
 	obj_exts = slab_obj_exts(slab);
-	if (!obj_exts)
+	if (!obj_exts) {
+		/*
+		 * If obj_exts allocation failed, slab->obj_exts is set to
+		 * OBJEXTS_ALLOC_FAIL. In this case, we end up here and should
+		 * clear the flag.
+		 */
+		slab->obj_exts = 0;
 		return;
+	}
 
 	/*
 	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
-- 
2.51.0



