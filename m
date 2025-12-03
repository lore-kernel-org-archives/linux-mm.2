Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F71D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 07:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B08D6B0023; Wed,  3 Dec 2025 02:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A2B6B0024; Wed,  3 Dec 2025 02:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329C46B0027; Wed,  3 Dec 2025 02:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAAC6B0023
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:41:44 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C10851A04AB
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:41:38 +0000 (UTC)
X-FDA: 84177365076.14.894B3C8
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E38040002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:41:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L2TDn+GU;
	spf=pass (imf11.hostedemail.com: domain of jayarajpr@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=jayarajpr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764747697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hFFWTVyMhWXJQ/C6WV6hYZm9kA7qD91BTQGZ7JlBxhk=;
	b=W+FX9a8w0j9fAbSdfW68HyouD3ugP4FBLrwRYUyBktAu4iRvz0d0FBajspo3LqdftUO77a
	kWnL1HdDItZsTNFuPko+8nHqh9XeABEtVm9YkzL0maIokAhv2qE98hc3VVMOyQlkqE7JCb
	6fVeYcaN+0dmJyevXCJmZvqIYevMFRs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L2TDn+GU;
	spf=pass (imf11.hostedemail.com: domain of jayarajpr@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=jayarajpr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764747697; a=rsa-sha256;
	cv=none;
	b=MWgOG0CW6hGe2WHiiQC6cy6CSzzNImmWa6UVUVvR3nae2I0m1yd3SVkecfy0f0ZHqazex0
	l4KwO+vGtj5gvR9w39ys7ox2glCHRaf4zd9bjiyEudqQHR74hPl3TEsFvHm+Nt/2BnwAih
	Ou2tFg4lwmkQEYbjheVTULPD4+SzZ04=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso58660731cf.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 23:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764747696; x=1765352496; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hFFWTVyMhWXJQ/C6WV6hYZm9kA7qD91BTQGZ7JlBxhk=;
        b=L2TDn+GUQgUNK9+p7mERZoK39SvQNtauw86idu6zmFvLE2YzhqHtktaKbG7iXKmDsE
         GVhGBEDF3zu5YUx7Epoy0M4vs0Yrhbs+r11uh3GUaKmXmfbFIwaVMUQ6pEMF12PIzGPn
         fGs6U2sI0eXeBwoa5BvZkfPTasGVL4877ZXCPiXUUnCoavERTCc4ABM4/G26GM60lc1O
         3i7npsD7IJJF6YJaH/s4CVc5vxE09yKHbY4Qo4DfjUFsbrbsutV3/gPt2TH4QVG6CaU5
         2Urj+deoQlOAtnpg7OX7TVKyHL9WsFzDf+oR63XyJ+Av5CTbIMaYoA7RJqI4sHlPTKXv
         IlvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764747696; x=1765352496;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hFFWTVyMhWXJQ/C6WV6hYZm9kA7qD91BTQGZ7JlBxhk=;
        b=S7TsDeq158fRgaa+LTsDsWevJLPkTXzyeJdlpdFafYUQa9HBE2ckDW87yx6TIwntHS
         KmQrw9CkKn0EVgr7geuILU5+g26cE/5bUUiUP8Szp1mf3bqII/gNJXc2dOtqQHXKG1rL
         LG6/IGckWsuPtOSECmwGZiDCsfeqZFc9wDQjvDfZ+lWTFu9D0zE2pbJKQiqgos7XJqxR
         wsmdPV2cJJWJ5Tgx/+wTVC66IyrfNV9wNFWeuO0+ar3hmnTAdOLF4hGzSGh7wbfSrKcw
         KZvoqFlrxbQQFzbNM4InFkIz8Hf74zE1jUspaCgpngEfaGM1uAdPG8TirAHfKyQ/yHLb
         Xk4A==
X-Gm-Message-State: AOJu0YxU66JYPFiGZFBMuOTscoVtfZl1HRdkI9ILCPgeQGnRxAuz7U4F
	6tAn8gi+VJrBfxfR4s8UpApztEhpyy0tnGlkKkxfebfGbMjqgAxV4MDrCQ6kNDBOAnmlkEtjJ4h
	v7qtjTrHEO9L0IKathdtdalUehNjlGkcL1lUW
X-Gm-Gg: ASbGncsjHZANptxqQfGQV8kF2bWEh5VRE35gNXDrLh8w7GvkEvgzs5xB1t+0kelCp32
	3hQ/3lbwDF3ebWEvpRVY4H9KIqHkEwFWcf5SvsjwwoaFDk90hD+SmBtGwVMR2GoWK/dpBtviFQa
	p0lwc+Ep76jiXI9G4F5diM5vnpWej01RQNnhQpBu2oXQCctE6XfXxRBeohgfJOO2K2KX8UQLcz3
	6UIm7SAsZN/ob1/HiD3rPP2sYGjQTLvaGinjY+tnUCbm1IGM7Zhq+OnsrHnQ6jw/RJ3sIoz
X-Google-Smtp-Source: AGHT+IFpJ1AmDWn1xDt0BAhmQGSGeR+hOMYKWFqaMiDcI/nbcfXrN9sRNGC4JuSNK3ReRXKoEd3ygxvQZEjAnKkUdhs=
X-Received: by 2002:a05:622a:11cb:b0:4ee:1fbe:80de with SMTP id
 d75a77b69052e-4f01764fec3mr17210931cf.63.1764747695762; Tue, 02 Dec 2025
 23:41:35 -0800 (PST)
MIME-Version: 1.0
From: Jayaraj Rajappan <jayarajpr@gmail.com>
Date: Wed, 3 Dec 2025 13:11:24 +0530
X-Gm-Features: AWmQ_bkdz-Ubdw1REX0v1dsLqaaGMKlOeyuItYI1oBpnc56InezwULVUfLyZmlo
Message-ID: <CAEJW1wECyPh-wbgnnoOGY460ido=U2A3rPhF1FQAv7txed1-Rw@mail.gmail.com>
Subject: Calls to do_swap_page() from handle_pte_fault() on a system where
 swap is not configured
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 75x3ykzqyer14nhkx3q86811ar4fgxjj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E38040002
X-Rspamd-Server: rspam09
X-HE-Tag: 1764747696-605605
X-HE-Meta: U2FsdGVkX1+QMqjHBPg94snJTmicj2lPZgk+fxENHGlBQRc7t86jGzQ6OYuUdaratccX5hF4NchX/G+QRiYAhR+b4dGky6zhML1Ik+e9EcErUoH6KY9WRlUx/j7tq4Fle/8XgwumbeWbt9QJk6lfhn+AIWrgCQY83T+J9iF4dbCzaWBEuLcKc4flf46oLELO5wkjNPFWIQfrxFYDGM7wDyWTKxCpyjMrD54tvh4q21mjKy8l60h3AVHzibBr4M/cBrLJjiQ785Me/A5gebPkm2hhWi/zNAPu5RRTEKs40MZYLlUW5VzNgXfQsMsildkxGfkljjqEPPYTUz/AqbeQznH1VZws/6GSBOyAsvdqfLuBPVBG7CLHzqMtTEDqNzwffbtMsVmOxtkgE430v1KKt45zBKMMsNxy6x/IQHHQTSxZh/9sYdrRcfs2AJPuS4bINdBAcbotUdzYvCLvKj3ViBCu4WrolBBbNiP6L3TzzoVjI6Sa7BBi8oV9MYtmhWvgSFlItCXQPVONjV8xfkk2YYU/8aakykBrV1Z1GWPNmyvEcQeB0Y+ac7idgC6UFyvQD8Qs18rH/zbTZetacCsytX99Ok/kMcG1SjBGdvGfM6IId0tQS9mZ0tBVstaHoA78gOpRKxa0mhGfOfkSk4O/k4LYB9EiYMFRKaKLPXxvgn7cuQ3tyxit7WvovxZ3Ag0bvLiov1DJGrvQbREN+X/Na6GBuN/BYjLJSnHz0HFB+GLUCB2dYtV3ipyr8lYF4UP7a4vpNxGDBDzkSmsRivrcyV9SeFhbvPlVjMhqpz1wT+60xgVXs9VZReh61TKOWAiPM5UaPNHe5baOZa2v2CsVR5/0qmeE4+oV05QRVLr4BU7WibXrwImbn/pn85nKNQ/uCarFVnJ6xGDQhAIvw/tD0/9BQ29bicKSPi5j5mZtlQ1vcfxxeNJ+3sVq1AId+pnWlWDh0WEyW5qIAZehgXH
 6rEQjkgS
 waEU1JnfgnxOk1XUABzJG2Ne40Bpgz4j4Pg7S54pgNJdKX/K2OqGxTc/YAWN/oj7NA33H1BGsqa1Ew1lFrDqmtjmSyngA21ZlOSCSN8tfTzkV+uyeXWYDgcwjAHaa2vnYt0MR9n6Qm6P+QDvuR0fCxMi0HgL9+96sC/vx05YaQsya3i2EGfKV3YHOTnz+TDNCT7/hBCGD/Yx6KHItf6AR+eRpACtfEN6p1B3GEdBUJtmLPe3rMp0my3PA8NyrpkAQXofjW7Sl3LUsq1NoN49YBscoWNYM+95FeQal1Wkk6O1Io/AzA+28Qp3X+Dk3dJvq3UgIht0LOCmaoGIKdhMm74fN1tDN8hCNmZ/WoeBhvBmapG3f08XUylc2jHq+jAMLq/agWLC8ClfxzVs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000142, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On a system where swap is not configured, profiling using Linux "perf"
tool shows that do_swap_page() gets called from handle_pte_fault().
Kernel version is 5.14.0. HugePages are disabled on the system. Trying
to understand what could cause do_swap_page() to be called when there
is no swap configured on the system.

// kernel version
# uname -a
Linux houdini 5.14.0-570.17.1.el9_6.x86_64 #1 SMP PREEMPT_DYNAMIC Fri
May 23 22:47:01 UTC 2025 x86_64 x86_64 x86_64 GNU/Linux

// no swap device configured
# swapon --show
#

// dynamic tracepoint event configured on do_swap_page()
# perf list | grep do_swap_page
  probe:do_swap_page                                 [Tracepoint event]

  // couple of samples profiled via "perf" tool
  hbatch-bin    7301 [012]  7041.023668: probe:do_swap_page: (ffffffff89dae350)
        ffffffff89dae351 do_swap_page+0x1 ([kernel.kallsyms])
        ffffffff89db34ae __handle_mm_fault+0x2fe ([kernel.kallsyms])
        ffffffff89db38f9 handle_mm_fault+0xe9 ([kernel.kallsyms])
        ffffffff89a90ab4 do_user_addr_fault+0x154 ([kernel.kallsyms])
        ffffffff8a723d72 exc_page_fault+0x62 ([kernel.kallsyms])
        ffffffff8a800bb2 asm_exc_page_fault+0x22 ([kernel.kallsyms])
            7f6cca147faf UT_SparseMatrixELLT<float, false,
false>::multVecAndDotInternalPartial(UT_VectorT<float> const&,
UT_VectorT<float>&, double*, UT_JobInf>
                 2715da7 [unknown] ([unknown])

hbatch-bin    7247 [000]  7185.407376: probe:do_swap_page: (ffffffff89dae350)
        ffffffff89dae351 do_swap_page+0x1 ([kernel.kallsyms])
        ffffffff89db34ae __handle_mm_fault+0x2fe ([kernel.kallsyms])
        ffffffff89db38f9 handle_mm_fault+0xe9 ([kernel.kallsyms])
        ffffffff89a90ab4 do_user_addr_fault+0x154 ([kernel.kallsyms])
        ffffffff8a723d72 exc_page_fault+0x62 ([kernel.kallsyms])
        ffffffff8a800bb2 asm_exc_page_fault+0x22 ([kernel.kallsyms])
            7f6cb11b5c80 UT_PageArray<void, -1l, true, false, 10l,
long>::clearAndDestroy()+0x0
(/opt/hfs21.0.440/dsolib/libHoudiniGEO.so)
            7f6c8a357fc0 [unknown] ([unknown])
            7f6cb1140a30 GA_ATINumeric::~GA_ATINumeric()+0x0
(/opt/hfs21.0.440/dsolib/libHoudiniGEO.so)
        8310c08348fd8948 [unknown] ([unknown])

Regards,
Jayaraj

