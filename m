Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0D52D26D97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 332916B0088; Mon, 12 Jan 2026 05:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0B16B0089; Mon, 12 Jan 2026 05:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C26F6B008A; Mon, 12 Jan 2026 05:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEB26B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:07:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C118114078C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:07:20 +0000 (UTC)
X-FDA: 84322884240.26.97B04E4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id CA5561C0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:07:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u2Q00Qc9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EFlyn43w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u2Q00Qc9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EFlyn43w;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768212438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnFkkYe24LjpncnRCCigWcgDMCgT7sT3u049O+11iAY=;
	b=d2IbgfqcdB3onzItE3DvRqIy2Yd5JpjoQdIuLwKgDYJ7o/8N3Cpo3Gdb6EteN4qiTAmQz0
	er6CRfXqATlfTu166rI5quLXiwa7L23w51DNgKnEgKnyOAcEV9FrgB2RNoFwXggtarCobw
	20Y2UeTdoy3W/ln8M1HsqqSFJ5ADtS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u2Q00Qc9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EFlyn43w;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u2Q00Qc9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EFlyn43w;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768212438; a=rsa-sha256;
	cv=none;
	b=Yafj6VVlmKCuoIjdFz5Kb93oXrIOM4UjOCs6snU4UatmIQENOkNbfD2C4JX0EqDqkgFISR
	RJTHDEtnz2HEl68lPHeUnaTjbw3M0a4yhM4rkSqsRzoL40WSbQ+RfCUllL94tyjrW/p4Z5
	pmBAR4/jTvNYwWIbGYnTzS0MhueCrSE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0D430337E3;
	Mon, 12 Jan 2026 10:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768212436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dnFkkYe24LjpncnRCCigWcgDMCgT7sT3u049O+11iAY=;
	b=u2Q00Qc9w6UYcYX+HbxFboRQ9ztDPj7SCkyjWeu8mnza+3V9s5dycSA9r/VV6SIg+5QACz
	z2t3nFiHSVlr2zzPmkWBSqLH6D4jchaU9stqhHh9k8poSQrcLojcY98hhLo9Dz9dbvThRR
	oUvzNqb9iRDhEHyuTrrkNBUqyMMCGmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768212436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dnFkkYe24LjpncnRCCigWcgDMCgT7sT3u049O+11iAY=;
	b=EFlyn43ws8OZytjW5ECJxRilGJbuaNVt/r3I81/7qC63ge+UYDiPi+vJ3LfEVS/J3Bwr9X
	o9x3VIzMq0er/HBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768212436; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dnFkkYe24LjpncnRCCigWcgDMCgT7sT3u049O+11iAY=;
	b=u2Q00Qc9w6UYcYX+HbxFboRQ9ztDPj7SCkyjWeu8mnza+3V9s5dycSA9r/VV6SIg+5QACz
	z2t3nFiHSVlr2zzPmkWBSqLH6D4jchaU9stqhHh9k8poSQrcLojcY98hhLo9Dz9dbvThRR
	oUvzNqb9iRDhEHyuTrrkNBUqyMMCGmc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768212436;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dnFkkYe24LjpncnRCCigWcgDMCgT7sT3u049O+11iAY=;
	b=EFlyn43ws8OZytjW5ECJxRilGJbuaNVt/r3I81/7qC63ge+UYDiPi+vJ3LfEVS/J3Bwr9X
	o9x3VIzMq0er/HBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F37C43EA67;
	Mon, 12 Jan 2026 10:07:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qx0eO9PHZGk+YQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 10:07:15 +0000
Message-ID: <1fc232e8-1fd2-4dde-8218-cc340a11633c@suse.cz>
Date: Mon, 12 Jan 2026 11:07:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka:b4/sheaves-for-all-rebased] [slab] 3c9d05a883:
 BUG_TestSlub_kfree_rcu_wq_destroy
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org
References: <202601121442.c530bed3-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202601121442.c530bed3-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 3czdp1r78zcgohp9j3usigjy9oaw4yho
X-Rspamd-Queue-Id: CA5561C0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768212437-144598
X-HE-Meta: U2FsdGVkX19py8sdJSkmK8YG7FVP0RPUnK+aEsJaKO4QZThEiUf1SQ3lNA5TMhoG5J5P4H54aZ4ga/5D5MRouKdkePJhZH/I2uVKnSQs45HwmLm3+N4FVf6hYT5vT8n4JCcDF3Cb08La5D5Eh8hXj89iByv1R/6XXe6hq+WNTrsQReqwtB/WnsAOAUFaGaQXcTyioowu1Z5xK9H4aFaSziBPTOZRsSTQWyui/12Oj8MQNSOQIG8hoz4BDKYyOUIoCmQ3975a3av+mgGbd5hP29JB9VOjF0LCN/ow7gY+NY+FhT2yOJ5IjZ+0Vn9T0b3KPR1hpAqRpieWJ6MI6TFh5s24U+X5uWbaqjvd68Ii8rbecT31yzJvLqYWMkzBt8HR34MwNE4YJFvb2IgZcRPAVlHOJvJGyHyHdfViVrbo8PoRgN+EMK3KYq4+NFXqaS52rvjXJraXaRslB+hmpP5/oZfzMWdZcBtW6/O97+Ei1c04w1tHv2mak2HcTPbCZH4eGbxo5MoqvibyYU7uGfUjVeNLsZjkca1jw1fTrGgdEWFoZF4uS+A2v8QGw889MY7amRYXvmVnOMMffuSArdZKzYBP46ORM6eXIs7gu61ATPk3EacSU2NU00ayXFQXJl0Poc/qXTwnMv/b76m1ecODZzLFtyhQPP65IQ3L4+L4ARPIHjwqmsHKqEzDeQC/TIdpkHXAx0g7atyOiSmGouIO9uQFcKrTWPGye5In97nyBzf4MIQFTNbVSlAZ0XFfrJdqFVwGEoJRD1dNoOt6I5j6QhiYbI6Mc5k4hEB13ta4NNaNTveQcKU4wNy9z3vQQsnxjxt7IZoxQkqB74kd22NMCXVGax4BEJibaviX7qV6HoO58WcABousOcN9cR6EOW7j1v8d4TjDfvdLlP1xYoUC3gkoBBGTS/h3jLsQ8LolgbaeE8u5EHQkOWEXeuD0LdnLXv+YEQcFJPn/IZgt+W8
 p5PiQYWK
 t7CVrSaWMYkgfhZ4WmqBUg9UqMl9LGbNAu/cFXn5VbMiuoSg2eLswhB3/WYygbS/DTddCD8O7yyqtk4qPpJ+FRU8rbtn8WCK2e4A6m0ifRvA2iYgzwE46WUFwA1tRQsgaHAS7X4BnnzeGxoe87Ua9R3DNwYpl8spB0UJSFszUd7Ws0cD6XjLKLuenqclO1bOiIfHLt2JeTsbydTNI/aFRT5uZbYELuPWN+eJ8/lMuuS0xfMwQW2RJt0+rKsLEU03PqjUA+P4e2MAQo2YO5VhP4byl7X7QG3R5i3BGyU+/4Xso/28vVajpuJnbjGbFlIguEVcXd7sHrkke1xXGX2Sg+/UVWgU4KE8Pup1FMcBVZ3KE0Aq/KiM5EM+pIe4mNUcq0s7I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 08:45, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG_TestSlub_kfree_rcu_wq_destroy" on:
> 
> commit: 3c9d05a88372eb667214035d903b5ea09be4459b ("slab: add sheaves to most caches")
> https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all-rebased
> 
> in testcase: kunit
> version: 
> with following parameters:
> 
> 	group: group-00
> 
> 
> 
> config: x86_64-rhel-9.4-kunit
> compiler: gcc-14
> test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 16G memory
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com
> 
> 
> 
> kern  :err   : [  137.071325] [   T4498]     # test_kfree_rcu: EXPECTATION FAILED at lib/tests/slub_kunit.c:182
> Expected 0 == slab_errors, but
> slab_errors == 2 (0x2)
> kern  :info  : [  137.076926] [   T4491]     not ok 4 test_kfree_rcu
> kern  :err   : [  137.133204] [   T2648] =============================================================================
> kern  :err   : [  137.146570] [   T2648] BUG TestSlub_kfree_rcu_wq_destroy (Tainted: G S  B            N ): Objects remaining on __kmem_cache_shutdown()
> kern  :err   : [  137.158349] [   T2648] -----------------------------------------------------------------------------
> 
> kern  :err   : [  137.169350] [   T2648] Object 0x00000000b072383a @offset=2240
> kern  :err   : [  137.174817] [   T2648] Slab 0x000000005fc4154e objects=128 used=1 fp=0x000000000b8c0d81 flags=0x17ffffc0000200(workingset|node=0|zone=2|lastcpupid=0x1fffff)
> kern  :warn  : [  137.188509] [   T2648] ------------[ cut here ]------------
> kern  :warn  : [  137.193801] [   T2648] WARNING: mm/slub.c:1248 at __slab_err+0x19/0x20, CPU#1: 0/2648
> kern  :warn  : [  137.202990] [   T2648] Modules linked in: slub_kunit linear_ranges binfmt_misc snd_hda_codec_intelhdmi snd_hda_codec_hdmi btrfs intel_rapl_msr intel_rapl_common blake2b x86_pkg_temp_thermal xor snd_hda_codec_alc269 raid6_pq intel_powerclamp snd_hda_scodec_component snd_hda_codec_realtek_lib coretemp i915 snd_hda_codec_generic sd_mod snd_hda_intel kvm_intel sg snd_hda_codec intel_gtt platform_profile snd_hda_core ttm drm_client_lib kvm dell_wmi snd_intel_dspcfg drm_buddy snd_intel_sdw_acpi dell_smbios drm_display_helper snd_hwdep dell_wmi_descriptor irqbypass ahci ghash_clmulni_intel sparse_keymap snd_pcm libahci mei_wdt cec rfkill rapl intel_cstate mei_me snd_timer dcdbas libata i2c_i801 snd drm_kms_helper i2c_smbus intel_uncore mei soundcore pcspkr lpc_ich video wmi fuse drm nfnetlink [last unloaded: mptcp_token_test]
> kern  :warn  : [  137.275019] [   T2648] CPU: 1 UID: 0 PID: 2648 Comm: kworker/u33:0 Tainted: G S  B            N  6.19.0-rc1-00005-g3c9d05a88372 #1 PREEMPT(voluntary)
> kern  :warn  : [  137.288184] [   T2648] Tainted: [S]=CPU_OUT_OF_SPEC, [B]=BAD_PAGE, [N]=TEST
> kern  :warn  : [  137.294860] [   T2648] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
> kern  :warn  : [  137.302746] [   T2648] Workqueue: test_kfree_rcu_destroy_wq cache_destroy_workfn [slub_kunit]
> kern  :warn  : [  137.310986] [   T2648] RIP: 0010:__slab_err (kbuild/src/consumer/mm/slub.c:1249)
> kern  :warn  : [  137.316370] [   T2648] Code: 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 e8 16 fd ff ff be 01 00 00 00 bf 05 00 00 00 e8 07 b8 2e 00 <0f> 0b c3 cc cc cc cc 44 89 e2 be 00 10 00 00 48 c7 c7 c0 12 bc 85

Thanks, found the root cause, which is a recent hotfix. Will make this part
of the series, but I don't think we need to send it as a hotfix because the
problem is only exposed when destroying cache with sheaves, and in the
mainline/stable kernels only maple node and vma caches have sheaves and are
never destroyed.

----8<----
From 9f77c1e5dac6ff2ace6513cbbb2a69ba58f3ab44 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 10:58:38 +0100
Subject: [PATCH] mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()

After we submit the rcu_free sheaves to call_rcu() we need to make sure
the rcu callbacks complete. kvfree_rcu_barrier() does that via
flush_all_rcu_sheaves() but kvfree_rcu_barrier_on_cache() doesn't. Fix
that.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601121442.c530bed3-lkp@intel.com
Fixes: 0f35040de593 ("mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction")
Cc: stable@vger.kernel.org
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index eed7ea556cb1..ee994ec7f251 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2133,8 +2133,11 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
-	if (s->cpu_sheaves)
+	if (s->cpu_sheaves) {
 		flush_rcu_sheaves_on_cache(s);
+		rcu_barrier();
+	}
+
 	/*
 	 * TODO: Introduce a version of __kvfree_rcu_barrier() that works
 	 * on a specific slab cache.
-- 
2.52.0




