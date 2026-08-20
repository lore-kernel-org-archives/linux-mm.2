Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A394C5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 03:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DBF86B008C; Wed, 19 Aug 2026 23:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38DC56B0092; Wed, 19 Aug 2026 23:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A3796B0098; Wed, 19 Aug 2026 23:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F33796B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:02:25 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A0941C1A8D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:02:25 +0000 (UTC)
X-FDA: 85120149450.25.3F6A2F4
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 938EF80004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:02:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W7Azikh5;
	spf=pass (imf30.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787194943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b7Lcuraq/4CMmDj86N4LuGkDilC6+Z6Q+xTsr6qjIXM=;
	b=Oc8xV5FOpthiIUM/FXCtIiaebg3pf0yxddBCbuI/fdlLNPE5qa7qhLmIXul82jZZDoPfqc
	CrEqzIx2ymqkoOfjuRLGgAWcXUFH9N41zNyH45i1w3RbISY4ZVU9n63RzxMCW3E5VJG8c5
	U+6Mc+OPLvoWrmlY4LqhbZN8/q3y0Xg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W7Azikh5;
	spf=pass (imf30.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787194943;
	b=jEsK99Alt/PJkCoqZz9nbbcNtArcDHM5cNu8IdL/Egp3srN0PXhKVQ4zz1mMU29IL2wGS3
	3Ah7cqCGVyFi+2aNsISnydO/l0FotkS5CXfOe9d6d6uT6G72BHhl++5nT4XkAyOaSi6For
	9eF6tmooD4ogMftZtkJ9tN0teTEBhLc=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7ec3b429a3aso1285012a34.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 20:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787194942; x=1787799742; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :message-id:date:in-reply-to:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b7Lcuraq/4CMmDj86N4LuGkDilC6+Z6Q+xTsr6qjIXM=;
        b=W7Azikh5kfaIOadfgx8pOO+RIg4JRZGQtfnWu6P03umktADHawmwhJDgZtKg5zm+eF
         /NMWl8oUuMkEZEh1zwvInOQ1gWK+2CrVBku646WPOO+LeVY4xgCkG0ZjbPVO4Bjosrdl
         cCpoWO08wzfvjWmr7Kd51P+3sIZCe2zo7VU3z3WklOPuJsI9FwX8QATYgC4eTqqQ6lzU
         5Od+6YZGit8xPRkxoY7CnjcIiT7GYn7ED5/dcP3AUVRcTLheEUIMwtDLnsWPu3Nga7C/
         EzgNeSY2MqC6aI7vpWpfaTLBOCrWXxkBvIH5LacZay61TqQGPEsbh9p4AqiSIUn7NGBe
         B0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787194942; x=1787799742;
        h=content-transfer-encoding:content-type:mime-version:references
         :message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b7Lcuraq/4CMmDj86N4LuGkDilC6+Z6Q+xTsr6qjIXM=;
        b=iVkosUluQT3f5Zx2sRt/AGZWIEvL2OjSBP8u75DgdIdvQQCJ7cA7v1iSalxI1GKekh
         Rx0tClymdINT4rDSwAbuXpm6V6SkPJouOBiB4XoO3YQ7ekJ/F+mO+ggInx6/hGzurtxJ
         /BH6fJA+X6S5fB1V2Bu50gs7O/9qk8TjqWvblt1jt3xY+Zz5/YXeDZNl0PUCN2++Vk00
         Fcc7bjrzGKqi3xMxYdGbPz5Bh21HStTggbKIGapk1iw1GW9hHrF9/z7qh91YbxIZgcki
         A56p7vXhho2JG/aecxuM5YtqvytARy+G5k8nlNgXI9lTAsgfLPA/ux+CcQaqaFGsIQK9
         xGgQ==
X-Forwarded-Encrypted: i=1; AHgh+RrjzHxh4CYqhPpTsD1s7zahckBu01puMYb88mJik3/iP7T4NhCrInlzXmAJJFpZa91Gvbg3YBHNYA==@kvack.org
X-Gm-Message-State: AOJu0YzcQM76aQnGZebPsXP1Qd73KDohzKKtcRDUVxIHNqd3jHLHGEkK
	perxVi+mCBEnaQg9gTHVD3pEaErkN0gQjCr92PCeoFcEwUv1k6S2NS4lTcWdu2sC
X-Gm-Gg: AR+sD12kX4ePEvx+ncocJJndvq1DSwLxHhS0g2huNKMFjM7Z//NJq9e4hdhcPRhR+Kb
	khTW8p+I3PAjG75nw+oksBwaWd5daOi7M2KaRS39Lpbgy85SrbUWLf0rwndLb41nrrawYCaWcsO
	bX/3+1r4a6I8XvYeLZwrHiD9QEY9FRe0tgh85KFK8elkN1a9NbWcxEK9lpazXFllE1mUikdFhHu
	k2V0wfQvBrHPCopgJn1jjgMrquOC3mU1+9K5Xd1yhQ94uBr7gFsLMQ5u5tYf2VWijFgBZ0N6VJr
	6tjeXrbTSTwuDB5pCl6zZnhzwqwyFUy12ihod5EbeW0KV/nmvYp+6PzEjHwGs905KdDY/ztGHQp
	a1oz/q7/+8VQmAlzgsbbD9klt9WKGv2nMUzSW1tZty46tw/IjdMgItRuFOtVdghXpfRMiqZc8HN
	s3ljHFLaVbo/rQtai/x13nYOYH+h4If1r2uDvubLOmafVwk8/23LYu4BLiEDehJndPXf+qJwKKX
	kH0WD+WgnsHv+JHl5VypbStdCcvt9epo4u05bkwZA+M
X-Received: by 2002:a05:6820:217:b0:6ae:42c7:ef83 with SMTP id 006d021491bc7-6b13bdbf028mr9701164eaf.0.1787194942378;
        Wed, 19 Aug 2026 20:02:22 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef77be3sm11302733eec.10.2026.08.19.20.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 20:02:21 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Ritesh Harjani <riteshh@linux.ibm.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, ajd@linux.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [BUG] powerpc: userspace processes crash in ld64.so.2 when running recent linux-next kernels
In-Reply-To: <eff5c192-ed33-44e8-8834-fa5b4803f39b@kernel.org>
Date: Thu, 20 Aug 2026 08:13:22 +0530
Message-ID: <lda1jyut.ritesh.list@gmail.com>
References: <75419f88-eab9-444b-bf97-28a9765819ad@linux.ibm.com> <627c5c2f-a0b3-4fba-811f-7b4ed4c74dbb@linux.ibm.com> <eff5c192-ed33-44e8-8834-fa5b4803f39b@kernel.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 938EF80004
X-Stat-Signature: m19n3996etk1o7jom6k6arqaenqr9zd3
X-Rspam-User: 
X-HE-Tag: 1787194943-822832
X-HE-Meta: U2FsdGVkX18TsuWGdJIHMav9oSU2SOY69DDeZt6lIlicX46pClk10CTH0vdVnXjN/SwqgkZ/aN4tBFmfLohPcRF2GKr9ZqtZZejEszekysF+4J0PkiIC+/aG86MM0326+oMM5DgzC0VzL0AXk9XK/+C9Ib9fmnsTggvTEm+eBcCkBHMNYF2eaa1g1TyoVL/ESb8TODmWn+mFq0BmhN+G5za/M+hhOvHjcjWajuVE/xdlekyCs65by6zqSD4bEsxtCeW/91NDD0QcdnEdvKOjUi6Su7M7bf6C0ot0twQV3z3hiNRzDPn2assSz2eMJNJdGUX1ML6djR1+OWf5g3bpAopKHVKwebMxMCYikgl6x0L4/GGVr1lCt9k7tGt7NEl6ifakmg5vDx16EbMkVc9kS+mxyTnJWUr7y0bJMXdl22qGaWwgJX+BMQXJqASeIbItGoBmbeFD150f105/tv5MCoU4fqMXCCT6MO9J55I8mmAp6PlA/9umj0OaCnplX3njW+JP4tLAx1NzgFdolJfeLG9Ua7iO2hmSpqxEhC/LTG0z+ysFSMxrOH0/o13v472XFKJhyQxnQEh1JDWwrj/ybqKAOJcm60IhcyiqTLyUkumiNH4Nce7/ZK+ZLWwm8JOHDZgWsXx9ASWbJSZfZyRE/wf178TNe5raY8f4jZFm1eCaT7fJDuicJgbL/hOWfUW6IWj4/nYQ0VKnXQWfNszbihwpRc8fT2xy4mwdQYI3MaYlkw4ry0LmRfV93pwQ5ggbl25wSbeesp+SwWJ551S1fOcHV3X14fjq3ySN9HfbSR11hOQFWGCcoUGSVszdew3mPpvJ6KML0BoZBA5ddaV+qTF6irvxhppqxslloraGBQM4GA5MVb8PqFzteRfe60UWOl/hD132MYoWQmrxpVHWm2CBYjzR08mLH8LcPD2MLaCLgVDHuiPtj4Fbhx0zc701qxquij94/AenArJe2S+
 cqIHoEIq
 cBNt1mJ/98JodOoOcqbXdYISsiEQV2uyHaDqlaeqf2mKAwHqiMI4+IZs7anDbiShD/ttMIZZkI7Q/9KsUK0LhcGhL+vUegvXgXCZpxEyUF+pXymlJDbWpmN5hX28G/cS8OzcSmEhs71ldAPOIiIMsJs1gnYfCVljVvkSrVOdTlKQSKhnsV5IpmCcNEAcvwSJycYyw1xZxO6icOgdVfU3fZ+RnQnaSqAaot3R8Bsu2bPLpdH3CchEzTkYxuEED7w9DGl1ZriTIVPYKdGu/w3+2EObRzliPA3Q137+bRkwVGT+leyLlZ47deMSunvrQBW4lTivEOC36mIoKsjl4SPBtWKuGqQ9Y6YrH6rqZl9jW+3B6HZ/SeYBKQeJT8HQXOKjYS+pp7oBxlIXi/HfLlTShIl26JmrLVHVsMugmQnjnE7cUwv80MuZ/TaHiPGeWMFofGkA1CnUzifaSgdp0LoSP6Csgn0yEerl83MLnXCGZtgZolv2ooJWUN40gEB1m744olVp+DHJ/j6Tn0thAtOAz79HweCPBFlwmm8Np2/c6CHfwgV0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Christophe Leroy (CS GROUP)" <chleroy@kernel.org> writes:

> Le 11/08/2026 à 06:23, Venkat Rao Bagalkote a écrit :
>> 
>> As part of debugging and suggested by Maddy, I reverted the following 
>> commit:
>> 
>>    263e5159e00a ("powerpc: Fix exit_flags field placement in pt_regs for 
>> ptrace")
>> 
>> and rebuilt/booted linux-next with only that change reverted.
>> 
>> After booting the reverted kernel, I rebuilt the latest upstream kernel
>> using the same userspace and toolchain. The build completed
>> successfully and I did not observe any of the ld64.so.2 userspace
>> segfaults that were previously seen during kernel compilation.
>> 
>> Kernel used for testing:
>> 
>>    7.2.0-rc5-next-20260731-00001-g79d9c1ce90a9
>> 
>> Top of tree:
>> 
>>    commit 79d9c1ce90a9873422ca4d6d0124a1d1c10a098c
>>    Revert "powerpc: Fix exit_flags field placement in pt_regs for ptrace"
>> 
>> The upstream kernel build completed successfully:
>> 
>>    INSTALL /lib/modules/7.2.0-rc7/kernel/net/openvswitch/vport-gre.ko
>>    DEPMOD  /lib/modules/7.2.0-rc7
>>    INSTALL /boot
>> 
>> Based on this testing, reverting commit 263e5159e00a appears to
>> eliminate the random userspace crashes observed during kernel builds,
>> suggesting that the issue may be related to that change.
>
> But commit 263e5159e00a fixes commit d7a6797e0bc1 ("powerpc: add 
> exit_flags field in pt_regs"), by reverting commit 263e5159e00a you 
> re-introduce other bugs.
>
> It's a bit difficult to see what commit 263e5159e00a is doing exactly, 
> most of it is a revert of commit d7a6797e0bc1 but it does something 
> instead. Need to see what remains with both commits applied.
>

Looking at the diff - I had shared a diff internally with Venkat.
Thought of doing the same here too. This seems to be holding up for him
in his internal testing. I haven't fully gone through this path yet to
send an official patch - but hopefully will do that soon!

syscall_exit_prepare() record _TIF_RESTOREALL value in exit_result, but
if for some reason (e.g. like an interrupt pending), if we go via
syscall_exit_restart(), then we are returning ret from here and loosing
the _TIF_RESTOREALL value which was captured earlier. So instead I
believe we should return regs->exit_result from here.

I see that we were returning exit_result prior to the culprit patch.

diff --git a/arch/powerpc/kernel/interrupt.c b/arch/powerpc/kernel/interrupt.c
index 5b88bf72786c..bf167a41a820 100644
--- a/arch/powerpc/kernel/interrupt.c
+++ b/arch/powerpc/kernel/interrupt.c
@@ -175,7 +175,13 @@ notrace unsigned long syscall_exit_restart(unsigned long r3, struct pt_regs *reg
 	current_thread_info()->exit_flags &= ~_TIF_RESTOREALL;
 	regs->exit_result |= ret;

-	return ret;
+	return regs->exit_result;
 }
 #endif

-ritesh


