Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC84ACAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 12:26:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D029D8E0007; Fri, 26 Sep 2025 08:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA838E0001; Fri, 26 Sep 2025 08:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA20F8E0007; Fri, 26 Sep 2025 08:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7B588E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:26:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 481B358F94
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:26:00 +0000 (UTC)
X-FDA: 83931323280.21.74EE51E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 554BA40005
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:25:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qBPVxGlH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M+TQxEVW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qBPVxGlH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M+TQxEVW;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758889557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UnaqUPfT6F2SYdrHgWkuz0x4Dq1KFNAs2dZR1oVzZDE=;
	b=Ns9GE8BZf+S8+89E6vQoTd3j4cX6CO54uZf3sxJIn3MXvOGF51VnvIHuyYi2SJiHcbe++1
	kOWzlcfTp4i+rkrqt4IFpR+tWZLTa4xLmfzDW5l+mfdB9eLIgUEFk/oFDXOQkFIzn542rw
	7SbPLvwFWyzAoGt90LfeDfBhGd/MKZk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qBPVxGlH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M+TQxEVW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qBPVxGlH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=M+TQxEVW;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758889557; a=rsa-sha256;
	cv=none;
	b=07KMZTPD9ES6jbGP1Qsp9AKAg2CEeUyRFwxagt4iPszeXh1vV48TffzCK+SSIbhT6y8CJZ
	jArYmEYQ3XXro/H2n7iKoUf8+YYd416HS2vpoRhYIIdXEo5nwIs2v6TiU8UDL28iMdfI7/
	H4ZConR1Zlw6XLMmsdXl6JzhT3iI4V0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 82D0624197;
	Fri, 26 Sep 2025 12:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758889554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UnaqUPfT6F2SYdrHgWkuz0x4Dq1KFNAs2dZR1oVzZDE=;
	b=qBPVxGlHPo8TCCGuGdrWuLLwmoqNQq3LlAN9FjX387Kk600HWYsfFl2D8SiOSUxx7wVsI+
	FHc3/+pckjUe6qj0drOyJB09t8SgIy/8USeVYWt1GBk1NjLi/EXFQH4zssKKL0R4swEKl0
	3VtcQVx4ELMoST81T9Yd0hB43t/PHEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758889554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UnaqUPfT6F2SYdrHgWkuz0x4Dq1KFNAs2dZR1oVzZDE=;
	b=M+TQxEVWWLqSUelATLRh91o5KTQ54vgMUVEYO59QnNPCMh04Yam0iEQTVPI/zTR9T7CZW9
	lwl5GWPUNnufyKCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758889554; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UnaqUPfT6F2SYdrHgWkuz0x4Dq1KFNAs2dZR1oVzZDE=;
	b=qBPVxGlHPo8TCCGuGdrWuLLwmoqNQq3LlAN9FjX387Kk600HWYsfFl2D8SiOSUxx7wVsI+
	FHc3/+pckjUe6qj0drOyJB09t8SgIy/8USeVYWt1GBk1NjLi/EXFQH4zssKKL0R4swEKl0
	3VtcQVx4ELMoST81T9Yd0hB43t/PHEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758889554;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UnaqUPfT6F2SYdrHgWkuz0x4Dq1KFNAs2dZR1oVzZDE=;
	b=M+TQxEVWWLqSUelATLRh91o5KTQ54vgMUVEYO59QnNPCMh04Yam0iEQTVPI/zTR9T7CZW9
	lwl5GWPUNnufyKCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6D4081373E;
	Fri, 26 Sep 2025 12:25:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 35hXGlKG1mgnRAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 12:25:54 +0000
Message-ID: <7a3406c6-93da-42ee-a215-96ac0213fd4a@suse.cz>
Date: Fri, 26 Sep 2025 14:25:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [slab] db93cdd664:
 BUG:kernel_NULL_pointer_dereference,address
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>
Cc: kernel test robot <oliver.sang@intel.com>,
 Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
 oe-lkp@lists.linux.dev, kbuild test robot <lkp@intel.com>,
 kasan-dev <kasan-dev@googlegroups.com>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>
References: <202509171214.912d5ac-lkp@intel.com>
 <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
 <ead41e07-c476-4769-aeb6-5a9950737b98@suse.cz>
 <CAADnVQJYn9=GBZifobKzME-bJgrvbn=OtQJLbU+9xoyO69L8OA@mail.gmail.com>
 <ce3be467-4ff3-4165-a024-d6a3ed33ad0e@suse.cz>
 <CAJuCfpGLhJtO02V-Y+qmvzOqO2tH5+u7EzrCOA1K-57vPXhb+g@mail.gmail.com>
 <CAADnVQLPq=puz04wNCnUeSUeF2s1SwTUoQvzMWsHCVhjFcyBeg@mail.gmail.com>
 <CAJuCfpGA_YKuzHu0TM718LFHr92PyyKdD27yJVbtvfF=ZzNOfQ@mail.gmail.com>
 <CAADnVQKt5YVKiVHmoB7fZsuMuD=1+bMYvCNcO0+P3+5rq9JXVw@mail.gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAADnVQKt5YVKiVHmoB7fZsuMuD=1+bMYvCNcO0+P3+5rq9JXVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 554BA40005
X-Stat-Signature: wdqzxfp4yw8saymzhejqj38nekmstnb7
X-HE-Tag: 1758889557-784576
X-HE-Meta: U2FsdGVkX1/SFKBz+1Co9pml6Fxh5Z1AmW3tl5BsubPOze+S3+AhBE2cOHG7z4BS24FYLasWuWkmueecGKeranhqv3jZqvRj9og4J1W/mM3mEyd3eqMw61LQ+y/TBVCpWupDFcf2FWXjbNh8bX8dQxIPl5BsXVXeLQlvKZjw6f/mJloVyz8ZhxUyCYKFpK6wXr8bVBVlXFMnNpE00PENEI7Q+vz1p7KWPMxUL1kzT6liSDh1oYOiK1JQdlsXlEAuBXcc1wHo7YMAqgBG/Da3lNkzbl4NwYOD7x2/IC/o8U2iN2fJf89ZQYmpwnmDBrBuWSU+GoD7cYrCYRcFT3irdtIsAHhZmyYDIrMG7qilxkJ3cjPrZtjzysb32xE+hyzMzrhIR+gvb5tmG4qh3WJG0WwIxrO77DZoHkaHp1EDveajyKcuNoKpKiI52pGB6NVH8ZGPNeA0AI8xvDbKQgRWVBT9jvONufaW9P0IGgY9/HDarzB1cF9/gBg0w4siH3EC9F5HLPa3JyIhC+SGgcQEfIdvltudbcDuqa5HEPhawLizpL7O99EKFOH/IcWbGxFUIrJm3FMLwBrazlmDbA7jrji/gANgijVWIzo7iWz9YcsgKmZfFxxm2vZnbnJKR80sxArECeOiyl0eIgDdwmYnxZpEik/voyc91yVHkiHkIo9h3mZXm9Px6R+GE9bTh424oxo3OqNj236Yf6MsEcl6qrrTkmlMoKkyugS/8vj8mKH942G05DYXtCzCMkJwLRZKUEHPFAjo9KsU2eq09bAZFJ7ueLOcXRoMzQyy8iuXS24vcF1gVtYbxPKFQQcYKQngelW14WaCfzMHHfy4zDpvKMC0Ub6c0iCer9rMtOfoow6CwCHz/NME8Q+t/LwE9RITyColqm/T1CBc1rr8NzNFVlOMiCp5P0jSWwTc/X//z65EEuvvpbtLrRrJ9/k7J+kIILwxOBMT0QVKsdwdhLR
 zmm7dpSt
 lz44uBxZZpCpSRSe9hB2dbn3tvmeh+q42f2EwDW7ps0v3iGyyoWIpYiGzkbTuJJR88aMhM7KHOGzihI/DtXkFQFsb7eI55sPO9JMDLXkn8FpffTcOQfrTR0nlBPxAJa0hHwU8voO7cqJ9blzvNsxUA4mN3z1UIOB7zD87ARqFh6K/lxkC8vOePBG29VZubS5ProaamruM+65QfD/EgYZ1RJ/9UCrCCClbDORgerlAurOVSHOjm8dwJBIK55ekLsmyYIVTXCWaLkw01sUHL3hhLDRwHTi4FEnnk/mNDE8QgMv3HVToWm3Oisom46HAE/0QyNV1FTXxK8F9z//pMRKyNZFwjDtwUqdImKsZpGhFsMgnwV+NsQILgVKY/flABc5Vv+CekpSEMDoz9mZFYsnaRGQOgYLBoyz0sC/CAgxjorl1vaNt99+6YPus2hGKam+UIAIh6kdO3cfMvy4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/25 20:31, Alexei Starovoitov wrote:
> On Fri, Sep 19, 2025 at 8:01 AM Suren Baghdasaryan <surenb@google.com> wrote:
>>
>> >
>> > I would not. I think adding 'boot or not' logic to these two
>> > will muddy the waters and will make the whole slab/page_alloc/memcg
>> > logic and dependencies between them much harder to follow.
>> > I'd either add a comment to alloc_slab_obj_exts() explaining
>> > what may happen or add 'boot or not' check only there.
>> > imo this is a niche, rare and special.
>>
>> Ok, comment it is then.
>> Will you be sending a new version or Vlastimil will be including that
>> in his fixup?
> 
> Whichever way. I can, but so far Vlastimil phrasing of comments
> were much better than mine :) So I think he can fold what he prefers.

I'm adding this. Hopefully we'll be able to make sheaves the only percpu
caching layer in SLUB in the (near) future, and then requirement for
cmpxchg16b for allocations will be gone.

diff --git a/mm/slub.c b/mm/slub.c
index 9f1054f0b9ca..f9f7f3942074 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2089,6 +2089,13 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
        gfp &= ~OBJCGS_CLEAR_MASK;
        /* Prevent recursive extension vector allocation */
        gfp |= __GFP_NO_OBJ_EXT;
+
+       /*
+        * Note that allow_spin may be false during early boot and its
+        * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
+        * architectures with cmpxchg16b, early obj_exts will be missing for
+        * very early allocations on those.
+        */
        if (unlikely(!allow_spin)) {
                size_t sz = objects * sizeof(struct slabobj_ext);
 

