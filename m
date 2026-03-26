Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E21A10A88E0
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 16:14:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B156B0088; Thu, 26 Mar 2026 12:14:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B7C6B008A; Thu, 26 Mar 2026 12:14:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752266B008C; Thu, 26 Mar 2026 12:14:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 639CC6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:14:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F1BAF1A0E47
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:14:07 +0000 (UTC)
X-FDA: 84588710934.15.6ADADE9
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36347140010
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:14:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r7Lb9CDT;
	spf=pass (imf23.hostedemail.com: domain of 3TFvFaQgKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3TFvFaQgKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774541646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vsZ2lsO4ZAgsDEyROGW20rTvF4IM6Z4sTJGYSb+tHv4=;
	b=Baoxl5wwKmveeUz6OkkeZ//Cmb3fX4duJvXlgcqtw8s5WIkaClIupTYliCL8kExcXZsC4u
	3T1W6zUZb6Pr3uaLP4lC9zs5rk/mUJBddXhIE5s1yejGWdW45Y3+8uX7hcdDn8S7Sl2hQR
	MJpbpcnqQkGKi0ZzJfRBXLJGStuGFCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774541646; a=rsa-sha256;
	cv=none;
	b=vKLGXedSiy1UQj9+tlEjYCjnj1SiQqvH+cXfl3C14m3jK62Ub7g9uVL/uMXM3/e/0Zu9R3
	S7qxz6hY87IJYzF8lGkHlEsXx4fPhHo5mxFf1ief7KgKe3F4JNufLt5RTY681Z/nO8kteN
	POupVP1RZdO7T/FLRStPbdHaqPTGd/I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r7Lb9CDT;
	spf=pass (imf23.hostedemail.com: domain of 3TFvFaQgKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3TFvFaQgKCG0ULNVXLYMRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-439b3011be7so695661f8f.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774541644; x=1775146444; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vsZ2lsO4ZAgsDEyROGW20rTvF4IM6Z4sTJGYSb+tHv4=;
        b=r7Lb9CDTI1LhBs/0N0wLvrsThXf1Jy3pFQQe3swomsklCms7VFSN79JQ27Z3e3AGyN
         PAOfpC8IrWHpUtymfyazOZJiaJbaN2uFIZkyCEP1sCM7u7qqxFGxd4KP6ENmxRfY87+F
         TY9ct6sDXkGzNVSRDACNKxI6ZDYQF0Gizbjkjsm2XNGrx2DV8PSGvlW7wQr2aA7wybKm
         oFnNmDpu5slSWG5QKbwZ/cWeSMM75rzTyy+4VQi++R6GCIaaScaX/vRjvn5AfzQWZaOy
         Q324WdNc2YfXpLNeC3aGXonG0xSS0UxZFp77Fg+44Ff+tnm+Yqx8F9CKzDi3W98U9IeT
         alsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774541644; x=1775146444;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vsZ2lsO4ZAgsDEyROGW20rTvF4IM6Z4sTJGYSb+tHv4=;
        b=nbl5f9bb63NVXSzHSN2wpp0flFXObOZ1hXvMI4CkZsaJdvtzeXg30OCyAic3I41q5Z
         AZ+OV5hazJD+qS/G0ru9z3WLibQnpNxnNl0BSGqBEAitENf6N+pyGBl1aZLT6im/xUDr
         6ALBBEptO5uTassJSpJxUY/RAWD/W03i+meixk0FBQw8U9AokC6VWZboAPimKixUAdhe
         rv+BFD6YoWDUBhYoeGRLdW8XxE1J+FydrNfq1EbE/RVsH3L0RT8QWdisR8Jmr8edYwJG
         JvWetiMxfYQ4r8CfiBhtYNO2K1d7zrvJ4+H8KFfV9Djwoj1+FZo8lBCgR73UL93OZwJz
         sVbg==
X-Gm-Message-State: AOJu0YyryGtFQEC2SqzZxUbs8k3jI1lNL2DFmhp4xOC6rGJM4XRroQrt
	ibwrnKKsA2KsZo3C6t0PnntbrYyhxLAE8bJibjOr7x8au+5qvgMgnDX6GqyXeRc8L1GFfYxzuKY
	yt9uiordJVL91xw==
X-Received: from wrus17.prod.google.com ([2002:a5d:6a91:0:b0:43b:86e0:73aa])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:18a8:b0:439:fe98:20f9 with SMTP id ffacd0b85a97d-43b88a0fb14mr12063113f8f.27.1774541644163;
 Thu, 26 Mar 2026 09:14:04 -0700 (PDT)
Date: Thu, 26 Mar 2026 16:14:03 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-5-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com> <20260320-page_alloc-unmapped-v2-5-28bf1bd54f41@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DHCUIGX4URD0.1KCTEYDWLQWE0@google.com>
Subject: Re: [PATCH v2 05/22] mm: Add more flags for __apply_to_page_range()
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 36347140010
X-Stat-Signature: k5kg716zcwrxg38aikdnjgfmeiwa1iwk
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774541645-966185
X-HE-Meta: U2FsdGVkX19x5wtyEVDT3PFTcV0cinvrhOiyAu/TpeSTGN1kjCeVVZOofyiQYamwLYrasYDLHj7zG5J+P1KL1IREtWngOR2hGeEGMb3vvpP7ujuE68H38qcwKBspMc4VgiV0tTDau3bzVYT860xPO5kwYeRokzPj5Hzh8JsgapNHgtjVxdjbCnsozSQIN8PnGRdellLKtq/ByHDB82U9pLCpHgDvBD4mbnZMXdRxbcNtbrwiwALcXRBPI/tb/0bKx9R5D2na51mO/6Ifqzsun2gTdT0PNjCsigbHztpa8vPNZwSAClnIp/KSpsui/ISdXVzk/4dtFEL/xHvpkI0k26hq4FdCDHcUQBzSSdTIv9SGBWfZdwCcJTKVAcL05ahRgR2HgQUqmXE2f4/shGsiTNhLe4Q+wk2641flY4pDz5sffgxBHkqNLVIHLQglMWDPcTpnD+InWpo7jzl0tVmR8MHzTpKPOnOQrj6wn6QoZJp+2BA/96ioS6LtiTp2869SrNR+JeUy4Np3GBJj7V3B1dCLz2cufOTLx16cuRC0hRq9lDOke0wCRP7+GVfsaGgwviITkScXtLgVMYMh7zUs9qoDKOPosHhSgIxXOW5tZPQE6XFRCbyyW6V7AdBmVTgEVM6y3QTZVc4Igby7nJ8ZjTnz+9jj6Dq2lyInHE6hW6HKVTWUllVO8t0yjl8/ljQxg3B/fEIInxfVYM/iMVJiULgoEPD2MCksGzIO1kKhaL2dhHwBumpVF9EL/p9TVWpkdgc4yZFtgnJ27tZecWf6+1FXHdcCty9bY42EB6Vesvr/yfztkwdxwyspd5AgE+H3vjMnIDev4wQs02oJRbj64RbHxCmHkuXIOxAJahbsDI5uBmSXg3nw8KAp07ZnED4JagDRDxSHp456BpHdB7odn0T6OGV8T9lfXQ/332mSALaokGj4AstqT/MEqcuKwRYE9+MVBgOxp2b4DZKXHBd
 cTEVFRfi
 RX2sXrONtOJdRnYNQJXytD7c1he1AEWFSH4gkDVGUXKXmjRh+GEQbLiFscxap92Zp61QVzL3ETjYzwpcq/TKPvFmxQPycEGkiLJhLw1nTzk8uwJ0VqS8l6Crt39+AQvWcOdVns6xf0fzQjTwn0WIBH0k1j418cmFyo0aBOrXCtb7oF6b3HeyyKTl2OZMxb4x1dvN/s80vXgYaXjf6a4JCIgHjt7gLKBAJkNRtS8RTUBLh/IlqQeCYawq5sq9x833BfgpAdSviha6tgveHotPeF/6by/5FG9UcnJv5I6Rcx1Nv9a2hCCpnkQlNtlL1NvqFvPQYEu375b5g7CCzDv73rfnGmnoevTLW83jLIKSpvHuM3vej8oa7vwlLsVBCkboYntpLycr4JrDtFGgRYgp+1C7dCo/i+idlrZsJQ967iAH6e53U2smMRP+46SEAA3qkVLfqSVP8MOiYXhpEsL78RDEnucjwblw/miD5SHS6v6GN6m1d1RbXsGraNt1/fySvtrX897nbdT1JpxVY1SnBkJ/+H5apnr3DNACeVX81NmXh6RSv1n6uOwnaQ6ZnG4h9/KEc41qnF5iII6vIF7/r+sRB7alsXOGRMQoRLNphGMNJbDbnaVfXkGrk/Im1WU8qpR0yMIpKXhyGo+ekjzybmT9ZEEVUneOHaQZ566mbUTxGjSMjF4Y3N/JzywiujOTCw5naolnPJ0Yku62IUbuVbQyHhKMBjSzvYImwLc4ume/ZRXOQQexSf2alecQ40zA28POx+RBC6HaZwOsTJoiGRYe7Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking at the next AI review from [0]...

[0] https://sashiko.dev/#/patchset/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41%40google.com

I'll keep it short this time: the patch is complete rubbish. In case
anyone is reading this please skip it for now. The details of how this
is implemented are orthogonal to the rest of the patchset anyway.

