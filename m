Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0116F3D5FE
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 11:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88BA6B008C; Sun, 29 Mar 2026 07:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B39936B0095; Sun, 29 Mar 2026 07:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28166B0096; Sun, 29 Mar 2026 07:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7006B008C
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:44:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAE5816023A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:44:27 +0000 (UTC)
X-FDA: 84598917774.20.84C0421
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1467620003
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:44:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ya9ly2qO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774784666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Csdueb260dLL4KAw0AfvdDf024yqqfeIAyjh7nn3RU=;
	b=UL4S+MIJj4iFf5VXcPvtxVP5TPpmRywDhJRjBI6ZQAULM5g8HXD6crY4FquMh8sOsNRRPD
	mE0W19yNVDy+8P+M4v0TV8ROeQPH5TdNZyQ54PWXyGAEGg96sMJRgHIIOKPanbjSLA6f45
	6314zp5BSVdo2UvnUjRUtsJosLrVjwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774784666; a=rsa-sha256;
	cv=none;
	b=JGc4jQ6EkaE361IU5uGNG+CRbHz+XkLeg3TalACNxiBWQUFVZ+GNuvUCtmRA+rL+RvS37m
	7rPxo6Xx88XrCBIHVXoTe7mcvsrsPBY0QWlhJox4Hey2hiLZzojTGBwfAwq341QGg31Z+A
	5+mNjImKWxHTAwSBFrKL2xlIO+t2IDE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ya9ly2qO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35da01fc0baso295481a91.2
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774784665; x=1775389465; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Csdueb260dLL4KAw0AfvdDf024yqqfeIAyjh7nn3RU=;
        b=Ya9ly2qOwVND7O6nYbfUTds4LZOhFlqiRmQBk4nsytYrdvFCNDrlhEvHvp/nG0poOr
         lWAGXXuYcu8DWCMhH8024jnSjFWEsPUzW5C1g51J8uPJTmC9ljjRMNEbWw2y0n2PHglB
         l8/ba/ZhUkT+FpL/lcHPKiDePehsCRKOsz5hItS+Cgd/4YfL+/gHC8Vj48Dq+Y+g3F4E
         3ki5HWK5aqCKyrT3TeHWEFPmZqH75b9fvPV8DgyWUHUAxMgLoA5fj366qzAxOmKAhXaz
         2qPZHBzMfA6ua12rA+ouirJ5q0ZbKe73qYZSQfojTpXvoHJFImlcPLOtN1X2DNFFauEX
         U8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774784665; x=1775389465;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Csdueb260dLL4KAw0AfvdDf024yqqfeIAyjh7nn3RU=;
        b=QBN4mAstC48NZfDSdhooIhJSdYO2DT9s0oRvt9U4y4Sq6kA85LXd/u/Hy9KXktPaR1
         W3AdcV8YZXtWmeqzjUe+hZvv+azKce3RT30JnBZr4C1DZ6Qx45lR6tvXZXlmVkCZA7dh
         LKRdGsqdTz0xMWVdknseZfd9ewRLe2lNduixlp8JkAc17f67FA17KJB1xmS2NpvUTVdT
         anvIyqcEFhC1ti/rRXiMf93z6P6y9QAS0Wv+QWfld4pK5ofRCz+J6RpNDszP6W+1TidD
         3OIUP5Zjd0iy5UMkwaOGNuYZjQDMwAWqAbioL1N+PKP0UvA8GYq/Gci8LgJqidrcbkTq
         OEog==
X-Forwarded-Encrypted: i=1; AJvYcCXL4MvngQaX+dAMOjNNSijkcUyv1noYgvJQQQxVX6Wwuuj7y/plZBmUcFoDJPmj+UpSbtcgiixPfg==@kvack.org
X-Gm-Message-State: AOJu0Yyjcl3etC4YoSOYZbu9OKfydlr4lt4SapfmVlQoWUP7xjZC+OAc
	ZGVTI5qkQUAoGNlBWYBPW7UBYt1Pk/ld9eLFtkuo5DYKSSYVkL7SdS1H
X-Gm-Gg: ATEYQzx6/au266jDUF8ORZkZEjSTdwLG1tDUG/3TVpgrRXUZskv4QwWUeGA9/ltaHdX
	DK1VbhImFIDc/SCL1au6Ds0uqKtJtMGQ/szRqjSA0j+3LmADdMpI9NPiyi9NfSoB9F2hCYJcRMM
	/0ZSX3MHiz2z9jaXXP+Cii5vqNsM1Y6/r3+95f5PcOzFqPP3TxeOKrLKQ8dmVQ02wFN+OqCOHF6
	SFe9/z+aBVz1cmGt79ijkyGYfmYlCUa1Jr+mX7wfmS9vex36jeuMrX5TGE1zPvfZdVudA438jGp
	bYSFM+iPCZXyB715pwqZ6G3tYP/s9qP0MPKnasy7BW70PypUkWU2wMrbcjhxMigPxJ/9R9/jXW0
	P9zZEhrHXLdk7y2FOqKz6iFDUMXq7ad921jArjxle+8LFYUwxSYI5ponijDZue0rI4VXYjDkDg7
	3TIrGX1/fVDTXbbtVTDcZLEiFewn/+BkhyMce4TV36wnhzvYaS52R07ScTsjranLm5uyPRro86l
	BOgVQ==
X-Received: by 2002:a17:90b:1e51:b0:35b:e4f8:7b3c with SMTP id 98e67ed59e1d1-35c2fffe870mr8867503a91.11.1774784664489;
        Sun, 29 Mar 2026 04:44:24 -0700 (PDT)
Received: from localhost.localdomain ([188.253.126.221])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c2d7df071sm3174591a91.0.2026.03.29.04.44.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 29 Mar 2026 04:44:23 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: lkp@intel.com
Cc: 21cnbao@gmail.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	bhe@redhat.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	nphamcs@gmail.com,
	oe-kbuild-all@lists.linux.dev,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com
Subject: Re: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Sun, 29 Mar 2026 19:44:18 +0800
Message-Id: <20260329114418.39732-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <202603291844.TWh2Ellp-lkp@intel.com>
References: <202603291844.TWh2Ellp-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1467620003
X-Stat-Signature: ac4qihy7erj65qaf4atskz8agix7saqy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774784665-510505
X-HE-Meta: U2FsdGVkX1/g/rSJEtNkV0UUGePncrqpkrguLt1yuu/fy8KLFkdeymznMG872+TH0SnqYZLr9SmspF/MjDOAj//nB77jytMuTpqHjobyFfr432RTri7gSDlDcNA8NgW3yQrxLB1MjWntVjcU9kqFVB9rlKWf1rymui+eC5ywfniLyocfF6a+wFKz4IP64d94OPxGYSAllfDRhwTiQlvp0ouFjW7XFTxVJmUNVCxyhSXNFiUfldoNVlPnadb26oQsr6ywoY7cq7V82LU0lZ7oSWUp4BHj2qbXzfuUgS4LonTcxSUB266e/Pnqifo0uPNTvv74fB88+Eme8DpXiDloT1aJd4WK2mKvSS/3AgxTC4D09tZTuToGPXQo2h+F3VaiE3EaDi9Ybl8z5E8b5UPcXpfp0YcyyIh1HtjtUdwMr8pg/xkH/HWVUf4mrB5iabpkCs3+x04HWGoWj4KwbYCuCA2xzBeRoKrlvrT/5MFNv+2cZE72NfsJTT5DIzh8ifPiXIJc6fz1kYqyRitEtbbkLp68bD2ZhqFT8tVQZvBpc3fU2p27n1OHvKdH4Ec6DFgxCYvCQKE6eNThR+PON+SWYw83QzPtLUqhSEdQ+Bte+nozSlkCFiOveiwEuqr/fRN7MGoj7Y//sW2E8MBoOWXxRCrDdUFjf6hU3Y3KSVaOzFvkTuXKtelKpE7FC4AO8ra5sOijneEPUTbvnwFSXReXjibAkfNASrdVTu0osdBkis3Cz/Im3iIrBCqcJ+m3qc2lXSRgBZQobqkZtgimL7ThNDj7+ce7WULNzNyE+e2h81PT3tLpSPr2Jebe5GDHEtl6EAONHWuRjE76ek/Lvlq2K8VJy3seM9bIfzOfn30b92LssHl41M8O+HLMsevlrcrKXsEbeDgveufWZuwVTXRNQ/tYVZ7urAqprz/9pECIv5knb2QpObzYC+Zu8w0ECYTKhETNgc9X+G+pkED4lHF
 5DGNjuhb
 /qn7cKoepnZOCLxHxtZOm2imj/Xx90ShK+vuduq5ZcxlIiGGuVGUyVacd+MIyaIsR5yAiZ5KX2tAqhRY3MSlG28UpSSuaz1StvDZo7SuuQjnefityaKzlgcsj6zfaK7BTpzlMUW8Dr6etOJqbiIwYZXd+LZftHkJWbu/pxeH9aHebMPbTWNFIFewY6xZapu3ZlS6NwqblWnwUjgDFWEnlzwnwghuPd5bGbjgK4AOcVReo1f/LHXbiL+raQRk8vO5ZtFLSsZOwUgvhrb8TF454cNPZfCjJji3INOK+mhqtMFCgrB6wbdiOXCAgxpsniTeHWEreLzNTiA1gnghdb2JLr7Wrv2gVKRqnA9bBax9mlQ4ACE9XGfS1iE4u01xLKkvdm5cqbW+/3wwRk1RwH6vmw5JBk1omJQM04rldl53iULXdrsiRGWavAN/MVSg6IFnkttce5M9wB9/vIEIITsCA648dMLd3peaXoF3P4xP0t27sktchUNpIbmYSBYITxlN1a8QItl0RFHcCzW1T/EvD7BQdrqkR3yPhPlsVi9655WThzsgYVjo7XwYYi4MP9JWocWDEB0V0Hf6vRbeEYihqJVEWGSHjhGKYsejhYQMscOk1vkyK9i20vWAW7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Mar 29, 2026 at 6:49 PM kernel test robot <lkp@intel.com> wrote:
>
> Hi Barry,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on akpm-mm/mm-everything]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Barry-Song/mm-swap-rename-mm-page_io-c-to-mm-swap_io-c/20260328-170852
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20260328075812.11060-3-21cnbao%40gmail.com
> patch subject: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
> config: arm-randconfig-001-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291844.TWh2Ellp-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 054e11d1a17e5ba88bb1a8ef32fad3346e80b186)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291844.TWh2Ellp-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603291844.TWh2Ellp-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> mm/zswap.c:1057:19: error: use of undeclared identifier 'sis'; did you mean 'si'?
>     1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
>          |                          ^~~
>          |                          si
>    include/linux/mmdebug.h:133:52: note: expanded from macro 'VM_WARN_ON_ONCE'
>      133 | #define VM_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
>          |                                                    ^~~~
>    include/linux/build_bug.h:30:63: note: expanded from macro 'BUILD_BUG_ON_INVALID'
>       30 | #define BUILD_BUG_ON_INVALID(e) ((void)(sizeof((__force long)(e))))
>          |                                                               ^
>    mm/zswap.c:995:27: note: 'si' declared here
>      995 |         struct swap_info_struct *si;
>          |                                  ^
>    mm/zswap.c:1057:32: error: use of undeclared identifier 'sis'; did you mean 'si'?
>     1057 |         VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
>          |                                       ^~~
>          |                                       si

Deeply sorry for the last-minute edit—I fat-fingered it.
It should be si, not sis. My sincere apologies.

diff --git a/mm/zswap.c b/mm/zswap.c
index 9bacb1733e1c..b60821758169 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1054,7 +1054,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
+	VM_WARN_ON_ONCE(!si->ops || !si->ops->write_folio);
 	si->ops->write_folio(si, folio, NULL);
 
 out:
-- 
Best Regards
Barry

