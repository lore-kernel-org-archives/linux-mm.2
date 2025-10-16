Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59395CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E5908E000A; Thu, 16 Oct 2025 13:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDB88E0002; Thu, 16 Oct 2025 13:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D3EE8E000A; Thu, 16 Oct 2025 13:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC318E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:06:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CFDDB90F7
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:06:37 +0000 (UTC)
X-FDA: 84004606434.27.FA0FFB7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF08318000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:06:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FXpcm/xg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yHAAefFe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FXpcm/xg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yHAAefFe;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760634395; a=rsa-sha256;
	cv=none;
	b=rTB6jQQ4cDB5EYGEGN9OTSd+XrfCEgDEYU3UHkiBIQeHJzZbvL9lNns9mVm38r7jsstS3z
	uNwSL9XcUnIB5/PrSUhJMP45VF2FJMdzZoMSuUORi0+1NQwAWgVPQR6y+9vef5sE/e7mt7
	cpUm/EK5DfkOG6QZfj07UyjJOoQTBzE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FXpcm/xg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yHAAefFe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="FXpcm/xg";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yHAAefFe;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760634395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tl311XYVAOn09pFWSpinVxhawpIQPj2GkLdiW8nSnMs=;
	b=omZTzPfXfhqXKYyCx99CUzdG48mhmfem3q22//0u1f/aAq3oPWlXTCOTRZ65fVTQ6SDw/F
	keUXWrq1H/N1CMPHsGQQKgV0kL9DT9y59SuS8lLdteo/FFcNT+t2LZCntTdYL4wAPtiXvO
	2/jTU38gH+uOGIdt8Kta6faVBdBJE44=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1B9741FBA7;
	Thu, 16 Oct 2025 17:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760634393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl311XYVAOn09pFWSpinVxhawpIQPj2GkLdiW8nSnMs=;
	b=FXpcm/xgGAymhCCPnMjdpSRkxQ/SrihP+XQ1vEQMudgIlG0HbT8gkCxAL5G0VJsdPzHNN/
	Jf4+aRwWfj1Ac8Vr3HTNxQqGhww69r+6Ul1ZiqlWiqnrNhDy3sK4JPxJXrneKgJyM+vDaH
	vVe/KkAmZB1e9oMin73OCM2HRHi7W14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760634393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl311XYVAOn09pFWSpinVxhawpIQPj2GkLdiW8nSnMs=;
	b=yHAAefFe/ReESZIvFbe/XHnmc3A2Fnug7abPcONYqdqjgNgbnmenOOtUmYxTF6wR7cAnRi
	LzH4T+2B8cjjbOBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760634393; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl311XYVAOn09pFWSpinVxhawpIQPj2GkLdiW8nSnMs=;
	b=FXpcm/xgGAymhCCPnMjdpSRkxQ/SrihP+XQ1vEQMudgIlG0HbT8gkCxAL5G0VJsdPzHNN/
	Jf4+aRwWfj1Ac8Vr3HTNxQqGhww69r+6Ul1ZiqlWiqnrNhDy3sK4JPxJXrneKgJyM+vDaH
	vVe/KkAmZB1e9oMin73OCM2HRHi7W14=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760634393;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tl311XYVAOn09pFWSpinVxhawpIQPj2GkLdiW8nSnMs=;
	b=yHAAefFe/ReESZIvFbe/XHnmc3A2Fnug7abPcONYqdqjgNgbnmenOOtUmYxTF6wR7cAnRi
	LzH4T+2B8cjjbOBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE8B01376E;
	Thu, 16 Oct 2025 17:06:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qp7oORgm8WhdHAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 16 Oct 2025 17:06:32 +0000
Message-ID: <80241934-7d4b-4196-80b5-713aa740edaa@suse.cz>
Date: Thu, 16 Oct 2025 19:06:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka:b4/sheaves-for-all] [slab] 16e7d1ea82:
 BUG:kernel_NULL_pointer_dereference,address
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org
References: <202510161341.61ccb50f-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202510161341.61ccb50f-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AF08318000A
X-Stat-Signature: ww974kfq8quadt5f99oz86z7et7b93xq
X-HE-Tag: 1760634394-813455
X-HE-Meta: U2FsdGVkX18F4kH0isyBrp1nA+iNi8JAXzZR018C7zRVZyYC57ClhezOTD8sx147AUsfSUBkkT4pGigMCTg3/WWv4V6TClN5Xy8+8GaBgo7sHI5nuJTHnDmB0nJ10S+1CYro0Grd/5rMRLMS5X47fuVpkJZKDNEGP50AdJwhzxQ8J1xE1jtcvClx6fzViwJnvhYknNk4vokT3OTuHuSy43F+kO+RuiFv8scFP4DAluF8BklfMglQSJaUyC2pQ4+k6+whHO1tIWnOHNU2N0wJJ3wqgu4zi2hdDbq3UgP9ZMMLQcNy3+PKHdrYP0JlDE63N8JI/M4fBCb7P4HtjqsBRzV9W2QkFzJrS1gtDYBQrK7z32VLNRp2DrhmWSmsPahGBysBotVNb2GcQenxnDnrKR3+yizSrgNmJzqe7SGxIyktfHqOr9OKGQYFjVCn6o5w6pu5/1JBVzH2C+Mng/nXz4VD6bNoNENMP8kDEhzrwX5/CXE8hd4yVJQWW3B9Or0QMUJ3kfyeGKIQmN/lKnCFiNScAxMKUITJFKrpT3j8x7acrtFVjdFvGWcxe5Wxc4sBV9PtaD51UcakTInmBc5E9/XLcSzuRfCETvLMTyshItRLPccRMQaUKAvO+pmT9ZwS48HwLdOBusRxx98gQ4CIPEacDUIFK7A9MGBUsx62NutRu63NZreaTiSNVTnWVt9SFqPFIhiID09Y/4TJfADZf2XNojj9xXi3jCfv0TsgAdrlHQL0NaJrfIJd56ZTXDAZSyqZDKBxAy461v1i+Z7IFQaVObS0L44ujbuUU4cqErEiI7Aemzk5jjYEt+VO8IUlLKZCd9IwPljZfekaCtv2C8hGu7jWqaw08OiHOvOjtszmv76vL5HIwc7JXF0fK5OCaXjOhmE9nmPHZ6Od9SDhfmKwIjlWCjZT+MmXLN/meEzlRMZwmyhoD7/lKrRpQ0RexljXwYsEHMmR+mtOz5G
 QD0YOtyB
 VNhBDG90i0kBm8lQ9U5QbjoQlRVedCI5cV9imvQ/J64VdvT+J2SI8cMc76nmUCjNHeDIqA9UkqzVB90JmW7jaiZgfxH8t3JFaGUD4USBagrnccUxmk+qSTFa/yIecBp3jPXTd2Ej6x1x7F0WGyiKZxIC/DMpp3rRbatMVoscmjC6IEuoIIZ0aLfbTmGK3j8x2OVbrCGTtkCMDBcqQXicbOdW+E1vjnznGRym4WgFYGeAPT2LLxxFiDZyYUcSBf+zFg1DuMSOyRVAu+SjVqSwhLpjzOrjlOVztTTVvxeEJWVPlQhw+1XQeyYKKoY8KsDbBexgGGiwDutksiF2OH8jo8EkKNOUYF1Q1c2QqxddNviOTOsCNGXK1cvJyL9hdv/ALQ1p9fExncqkr12i9ApnGAAz8ny6jL+DERv1p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/25 08:02, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG:kernel_NULL_pointer_dereference,address" on:
> 
> commit: 16e7d1ea820782b8335c2a52052e4a0d9ca0d4b0 ("slab: add sheaves to most caches")
> https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all
> 
> in testcase: boot
> 
> config: x86_64-randconfig-004-20251015
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
> | Closes: https://lore.kernel.org/oe-lkp/202510161341.61ccb50f-lkp@intel.com
> 

Thanks, most likely this, will update the branch.
----8<----
diff --git a/include/linux/slab.h b/include/linux/slab.h
index cf443f064a66..e42aa6a3d202 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -57,9 +57,7 @@ enum _slab_flag_bits {
 #endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
-#ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
-#endif
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -238,11 +236,7 @@ enum _slab_flag_bits {
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
 /* Slab created using create_boot_cache */
-#ifdef CONFIG_SLAB_OBJ_EXT
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
-#else
-#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
-#endif
 
 /*
  * ZERO_SIZE_PTR will be returned for zero sized kmalloc requests.


