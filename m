Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 704B8CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 08:06:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6BD58E000C; Wed, 17 Sep 2025 04:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B587F8E0001; Wed, 17 Sep 2025 04:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 031848E000C; Wed, 17 Sep 2025 04:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC43D8E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 04:03:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 92392140486
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:03:30 +0000 (UTC)
X-FDA: 83898002580.26.8136C05
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 29857A0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:03:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LnEjgxL2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UufgrTS2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LnEjgxL2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UufgrTS2;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758096208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+OplWbxohq2Y5jWPghR/7x7wh7443bAXi+C38uXRXQ8=;
	b=eGC0FzayETUCfFZitADhaAAyeoJVIq1Igdz/r6LzRmSlTTPVHdSyiU9W4EHYT5jpDPBPkO
	dg+ri/efd3mE/vWk7eORF9gyRBRqK+XFv49MCcqQOBDjdZvOi4stoux6BVTebDnFIN8TNn
	1In3vzKN0+3N3iNdEPli3p4gt4xPvm0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758096208; a=rsa-sha256;
	cv=none;
	b=c2WgZv2vzL9xTE8IJXcxvzVyxU2zxbsdbdd3Dvu2gfItQn4DntmtC4KIdKTayOriETyyBk
	5GBJWQxKodp8jaSy9z/TCqf3FsQWBBaDnVMZ5CzMrYmEAsNBRthvBo43hk/jCeOmZkhYBW
	gioLUx3FEkPw1sgJrvmL02CLa5/G5Jg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LnEjgxL2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UufgrTS2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LnEjgxL2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UufgrTS2;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6FFF91F76B;
	Wed, 17 Sep 2025 08:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758096206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+OplWbxohq2Y5jWPghR/7x7wh7443bAXi+C38uXRXQ8=;
	b=LnEjgxL2dk7r64wP6gI5VZgjT2edLR23JfgH+1KkPvSKqj02pgZoZ26lSZePXQ6oIIqK/3
	GE39hWQE7qfQnjLHBCrWJq/eUNowRWDPw9Ue8xtbG/ZqwbFjtWXh1o/heyJ0Bj8h5eF9Q7
	RMFwsRVoLzBKgX4hjjtYOZsfefiVRkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758096206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+OplWbxohq2Y5jWPghR/7x7wh7443bAXi+C38uXRXQ8=;
	b=UufgrTS2Z0++OXfaVTRU30pyY1KL18AeZvxgNOVPeT1UIPsbsNY7ysW7u84lDhRCgwNnGB
	jdGynzNmIXSSowCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758096206; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+OplWbxohq2Y5jWPghR/7x7wh7443bAXi+C38uXRXQ8=;
	b=LnEjgxL2dk7r64wP6gI5VZgjT2edLR23JfgH+1KkPvSKqj02pgZoZ26lSZePXQ6oIIqK/3
	GE39hWQE7qfQnjLHBCrWJq/eUNowRWDPw9Ue8xtbG/ZqwbFjtWXh1o/heyJ0Bj8h5eF9Q7
	RMFwsRVoLzBKgX4hjjtYOZsfefiVRkw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758096206;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+OplWbxohq2Y5jWPghR/7x7wh7443bAXi+C38uXRXQ8=;
	b=UufgrTS2Z0++OXfaVTRU30pyY1KL18AeZvxgNOVPeT1UIPsbsNY7ysW7u84lDhRCgwNnGB
	jdGynzNmIXSSowCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DEDD137C3;
	Wed, 17 Sep 2025 08:03:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id r/GZFk5rymgYfQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Sep 2025 08:03:26 +0000
Message-ID: <b7d4cf85-5c81-41e0-9b22-baa9a7e5a0c4@suse.cz>
Date: Wed, 17 Sep 2025 10:03:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linux-next:master] [slab] db93cdd664:
 BUG:kernel_NULL_pointer_dereference,address
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>,
 Alexei Starovoitov <ast@kernel.org>, Harry Yoo <harry.yoo@oracle.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, kasan-dev@googlegroups.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <202509171214.912d5ac-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202509171214.912d5ac-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 29857A0002
X-Stat-Signature: 8teerdrep9ho4o74umf6k43fh3t3bn6u
X-Rspam-User: 
X-HE-Tag: 1758096207-667858
X-HE-Meta: U2FsdGVkX1/G6Yl+iakxbRUumkKKKYMm/3x3Qt2AjAKIteuqJ62AJKjAaizPd1oq3eDpWEeHmahKVwACv/V9EBSH5GD0O23nx5OU/0psIPd4SOGaVGDzfixAPNXvtjOMIozwfI8KuUZ2saFqY4Lh02BI7/Dq9uh3YpnWlAFaxFuTpi10mimOyz3tKfCCBaX3g1azTmit6NrRK5ln6BHCkulTp6t2LENvCdQuu0E98KqzYlklbfSdnIK7+QmAt9siEuDtFo8chM1BV9TTf1oCp+Qt5nb8JgsF1SDHCVcvFHtAXlilmaRzZyI0HRAWUeuIGVf+nLEcHjxPk22WWCswmfTneam61+LXv7hx4clfSGZXwBsjDEgvpUu7bzogqNcvIbGbLTFYGIVsnPjheOB1B9svQbZQL2xzu9Vb8En1yju3O0IBu5qUY5q7ypFl1u2KoRLg1hOontLlh6GUMpB4D68ipXcYK/icSFoQmnwUkge/Kfzv6VpRskbgPo2EsQvXP/2BXjX+9g375WPi9LI6XOpHgUAeb7L576motHQdvOjx729f/2nte3259NQKIEQlPcmoXuSqtAYw19mPhWwnYtlrnTD7zP8j6u+GubV3l8kB15PVUcoapNt0R7c1XMVb1YDbXyCXRvPHNgj7PhjGLO4CLruovnPZAsH2SdmfKPxz0I2sqoFU759MighqI+T0BZivIcGwJeUL1Lu4I+uRRCcvSnXqMW7ptM/1x/5onCZknLxkKWz5KkRDFFtGBhfDj/FXn8lc+is9PfinaNSxhDVaMcFB3Bp9l3Hf9zgYdtvxGFhCJjWdhBQAGOmFQ90pz7i8JA3PGgx/e3NNxJQO0XcybbMjdRJRV3SfhgPjnfUqcIHnRWfcYt3dh9nDLuIMu8Z2On+GrR/wlsyHiB8DmxpTvn9TXShGnM1i06kNo/ZV9CHmdTw7yBeUKIpmyMFrhcn+D805JbG5lZ/BUzQ
 jRAAcZTy
 PfAhh7r3cQGwcuwt06JHmK/reeMGrFY87ZfofrNjKLfw/KlGxXp+Tharxm6HHwtifQRc5vl07mu2yI7WVsx+ly7BrhlWxiW0uh4ibpz31Y5mT9+wpLCYc59k3zgt/+iJsvZP0da2hyq40Uv+n6g7H45ucVTRWEENp8q65cJi///qKt5OQ8CHQfLiJOeNHoLTRcuiLC052CymLWt8JhBaeoj+E0jfRmZCTCGQQAecPvSJrzS9cerkWnq1SGcKJokvLIqxABfXk6YrB4/CzKsEj+FbCySI0nOcfsSOD51mnjqDvNQrWSFCxCbH7hmiMIFX3wBH6p/Iopag9h8mPItEaSaQuisl/5M8AXD/PMkyQkd5+4DTgpzHdx/R0KN6zzbpmxh1v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/25 07:01, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:
> 
> commit: db93cdd664fa02de9be883dd29343b21d8fc790f ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master
> 
> in testcase: boot
> 
> config: i386-randconfig-062-20250913
> compiler: clang-20
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202509171214.912d5ac-lkp@intel.com
> 
> 
> [    7.101117][    T0] BUG: kernel NULL pointer dereference, address: 00000010
> [    7.102290][    T0] #PF: supervisor read access in kernel mode
> [    7.103219][    T0] #PF: error_code(0x0000) - not-present page
> [    7.104161][    T0] *pde = 00000000
> [    7.104762][    T0] Thread overran stack, or stack corrupted

Note this.

> [    7.105726][    T0] Oops: Oops: 0000 [#1]
> [    7.106410][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G                T   6.17.0-rc3-00014-gdb93cdd664fa #1 NONE  40eff3b43e4f0000b061f2e660abd0b2911f31b1
> [    7.108712][    T0] Tainted: [T]=RANDSTRUCT
> [    7.109368][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [ 7.110952][ T0] EIP: kmalloc_nolock_noprof (mm/slub.c:5607) 

That's here.
if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))

dmesg already contains line "SLUB: HWalign=64, Order=0-3, MinObjects=0,
CPUs=1, Nodes=1" so all kmem caches are fully initialized, so doesn't look
like a bootstrap issue. Probably it's due to the stack overflow and not
actual bug on this line.

Because of that it's also unable to print the backtrace. But the only
kmallock_nolock usage for now is in slub itself, alloc_slab_obj_exts():

        /* Prevent recursive extension vector allocation */
        gfp |= __GFP_NO_OBJ_EXT;
        if (unlikely(!allow_spin)) {
                size_t sz = objects * sizeof(struct slabobj_ext);

                vec = kmalloc_nolock(sz, __GFP_ZERO, slab_nid(slab));
        } else {
                vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
                                   slab_nid(slab));
        }

Prevent recursive... hm? And we had stack overflow?
Also .config has CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y

So, this?
diff --git a/mm/slub.c b/mm/slub.c
index 837ee037abb5..c4f17ac6e4b6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2092,7 +2092,8 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	if (unlikely(!allow_spin)) {
 		size_t sz = objects * sizeof(struct slabobj_ext);
 
-		vec = kmalloc_nolock(sz, __GFP_ZERO, slab_nid(slab));
+		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
+				     slab_nid(slab));
 	} else {
 		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
 				   slab_nid(slab));
@@ -5591,7 +5592,8 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	bool can_retry = true;
 	void *ret = ERR_PTR(-EBUSY);
 
-	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO));
+	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
+				      __GFP_NO_OBJ_EXT));
 
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;


