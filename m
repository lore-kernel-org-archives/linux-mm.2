Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC421FF5126
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 17:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD166B0005; Tue,  7 Apr 2026 13:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D496B0089; Tue,  7 Apr 2026 13:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BEB6B008A; Tue,  7 Apr 2026 13:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 705786B0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:23:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0129B5B8CE
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:23:56 +0000 (UTC)
X-FDA: 84632432514.26.0C53CE4
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2884780008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 17:23:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UKvx6zv3;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775582635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmV1J/GHikC7tT+phj84rdE9QRa2smYTRcGDKTZxJqE=;
	b=TMcPn3R0E+yeTQS9hP9SusZvLB9eabm4rx2gdaOFe/TaLMuPvW0mS9K3il0PS0cgtlBn7q
	DdMJEFR1X27zwm94OgNNJMi1OBnA/OepgSbFb+wrTNRIK0DLNBhVCQHYVPu9Nebw0MOzem
	/hfmbgE2wB+QfSHTccTLUUKfi0x//As=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775582635; a=rsa-sha256;
	cv=none;
	b=K9F1HGlpTNY48ew2v8VKBcof7vpCof1qMlR50+puArRXW3KdrZkuiBiA9IHgL2Ly867LM2
	J7Q3oMDh+ibOR05KctKntfzU/DtAOmlBiCkxwy97OvCr1w8W0Tt6BtPop6pRZkrBul6a1k
	yCIHB0Uf6Tsp0PUab4cDfn8Sk4LurdE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UKvx6zv3;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-41c0aae84e5so2861800fac.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 10:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775582634; x=1776187434; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UmV1J/GHikC7tT+phj84rdE9QRa2smYTRcGDKTZxJqE=;
        b=UKvx6zv3IJSFh/0bG+uCO+H9jwOOFSGIAFowTC0StB31J7Nt348Gfz7RPlfzomEr3F
         ZV/yjI5KSeqpPuUNpOnGyOrL4otxlo2VQgJyVXrRySaqFLKrOlECAhzbJU58X8ktpu9R
         OarzIq78zNra4IQun4fiA+TRPeuDIVOZI0JhXpH6Eobr3CCayxiP4b01cGnpZN7Mmx3r
         BW9Qom5o8mGXLDd4wW5qa2lb844wwm+ZYOQ0I8N5a9Rf38O/6SzxMHU4wHL2DKkJUkYD
         7YmbiI6QL01LQFyLnhh0/2itOTsMdGLHjAChjPhQ/8uW2dgGyuepeYPVEaxuUOVqKAoW
         bmCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775582634; x=1776187434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UmV1J/GHikC7tT+phj84rdE9QRa2smYTRcGDKTZxJqE=;
        b=g/9FWC1DrxRJgPl07/gYW3DKUbUyIgI817zERCKntBEl6x2CVZp7Bxj+8wk4ndLlTc
         w+1/NCJ6EvC+tftYqHagtZqTgtSovJHCGwTm3XzxOR/h++5cvTud3/jiW266wk/rFlTr
         XxA2t0vhKPMrNyLsiAhmsixd8fO7afRlvrlsE2/EhQlKip5vlzifaezaGKvj7Ag526ev
         1RMyCzVDZ/ah/0PvI8rQNQJ91iZYO/RPZvoJqD2Hpdr/qGQ30kLO4Cg2Cg9mLzN22ft6
         iNYQ5ntIm6g5GGHDlMhs/lurU19crC5N7blCcmsxcqHCFXYf1nt9pjpFrmd1kA9k55lO
         9xFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQxRhCO+SY1g93s+QQk+HXRD+G018lduUf8uuz/V05zodgLLY7QJm/V/FHUtQzA275XCUye06uIw==@kvack.org
X-Gm-Message-State: AOJu0YyXXv0C0CqTxndESVccD9BDhX5SocrOT5o+9l4BEh89i6xitfkJ
	gJkr0CmHm29BUIAjDt8AGX2ZAHlfGtfFJQGY977TSQMENWwWw/LIZks9
X-Gm-Gg: AeBDievwSd1zGoUMfmiIcgrSzd2uddkF3Pi32lTjgqWwkKSSDIIrkRNdB/QE4jeoyVu
	MDnpgsCLWONpe8TB5owuM/cOeSaHVXmnTxZRRBJsNJGFuzEVGoi8ZoOlJFrtOZbTGRxNw7peibJ
	RCK6IsVysiaVmecuw8XwBB+xKCVCMlv/rdMRwWZsf+8X09xU7Ove71WAJWKYj16+SqNxge6mBo2
	ai8OsvAOtTS4v6qic+wl/4VAp2I3Fo/ISRv8Wep1JGZlzbn0uaDx0C6LAueBmGxIPVL4lQwhnut
	WoyN5dvwhzdPQLJsJznrmDNlQ/MsynXYx+7ySAijR9hpXbkmCKkJ7y6sbjoluZ7+lLKCkNz9kYC
	LAGsbUFLE3VEOZNmnLr55Q6PWb72a9Sr4xUAcK2ZlYcjY5cwvkIeMzY+bNcIxJQgGm4GI3HYnbu
	LAOJCXrz+uyr5yeZnokJKy/pRjnec7f7Ci
X-Received: by 2002:a05:6870:9e8b:b0:422:e938:6b49 with SMTP id 586e51a60fabf-4231009bc3dmr10342207fac.38.1775582634032;
        Tue, 07 Apr 2026 10:23:54 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4235e32d9dfsm5891881fac.16.2026.04.07.10.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 10:23:53 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jackie Liu <liu.yun@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/mempolicy: Fix weighted interleave auto sysfs name
Date: Tue,  7 Apr 2026 10:23:50 -0700
Message-ID: <20260407172350.699577-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <adU6MOCggHJ3A-n8@gourry-fedora-PF4VCD3F>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: mhhimwrpe4fatokf61mtq5z6dkoo9gw1
X-Rspamd-Queue-Id: 2884780008
X-Rspam-User: 
X-HE-Tag: 1775582634-961336
X-HE-Meta: U2FsdGVkX1/TviZdsbEvQulwMA7D1d/WxjGnCIhJuCex2T3pmY4m5MLWfgE3KVdrVHaPky8yg3GlshjrdsJDkkMdHd+g2pX5pEM+wkpQbDgVjXcUVpnn12SBKWtWjrhbnB6HzkTgqiQDIgBgxU+hka+yPDrmEmrGJ0TEQFSJefpWzKaxrgy/Ckcw3ufx35pwPnTX1A3ZJD70ppXB/NNpUrrKc1gxMn7ZqTVTbdwDfxYFe8E1mO9gl3vEocXXCLK11AHuuFhoHP3BCWdiH8h1J5KzKk7NWgUFa3hMGDoxt2T4LHwUjVuGbIr9O0mLOddCt4PkpXNx/6Y45ebYl8rTlsnxjloNEDSxAO00dB7EoeYMDyJbhkrGi5hXMzPyqLfM8kBA7GyGWdeYSn86tgMYLfMUnJ3VcDsECDuuEQbOAEdV0zeHSR53A6GB/5SXFmijzFYBBy8xEKxpxr6N4CBFodqq0B6MR0ZyR+ZEt5LE0P/dtlHjYNNUQWjd9sZYBLLboOeYubFl8iKVGk5zu2mxXrjLATnoA5wONFw2R7qJbRLeueFdjl5fcm/SXAMqodnWlYJS3oSSd+3SsNPfXQpkT1aHdMeAdf8v06Z6xRvL+cVfzqNYh1u/OndqJSymu9NoaB9SN55FK+RPwKiyNj1kFWjyNz/nsoVtI1je+23KvJ/l86rKqwDiu3VPTR52eBxM9vR1OO9LQJIZ1XTS5bdi+AUTXcX3Wm4jSeNm6MplYRufreDFkk3Ha5gq/e/tU0ygv0Z0C7aq1+gKmkZZzu7gRsSYN2xO+jZBh3cAYUen2dZKQDoslmYuumxumPXLZMJgMHQbjG0cv4My0d7Y7TmqCOXuncX/JfRa1WAMjmMuGYQsmATAjkVE6VVGwo38xxQFYxtBEC9IMTrHPkG+9mcdY/cAhad70jyArGcX69v9zB3QA1bnF7obiApVi0+u82q9iVbZbc+uaF0t+651nQE
 JF2+/Vfk
 flacME5SY6Zksa+hZ+clM2jZMO+4qQvIMv07V+XjZxtu+bFBfbBcN3eqHwQPfBTpraWqh9IK7S06YHcA2kmMimL4wWOY7fXWcNHr5pf5CJ/9rh13ZYVEqfnXsVWABGx0Ok/QdHAWZ9AXmtmIP45V5l+ltfUKtIr1MzFehR9P9zCXI/RIjDu2UM1V3/BzpoWrs/3ASrBsCNixMPyIXn9XX1ifHX2EYqfTbZCBRJn2RxM1nX0NS6E9IhemeWtrZxaay5MYz+2803b0MtpPb+dYJGPODtM8yeGYOcIPOKCoT4LBepy0uvGsasFLOekSRRIz4iMcjLY2e3P8HjG22oQC4u7md6C1Oi+q0MwlAB8aaU2+OG7ybu6/sdhqiQj94P6fokMQjwx9A0rC/vEvN4m+yHxvsedrd608FHLCpaSLxDkvHz+H+xh+mJxdvD94V/s1ycxIo+IrKTLp2CKzYfgN9iZPk1tzlqC+fw/SBwHvT4ERxCntIo2NRGlAeCc9ipFzdkcHw3bW7b9Oz9IQoDrkF02axoExJS0IR3iIXySPD1GxP9uCT4lK64Dx3qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 7 Apr 2026 13:09:04 -0400 Gregory Price <gourry@gourry.net> wrote:

> On Tue, Apr 07, 2026 at 07:14:14AM -0700, Joshua Hahn wrote:
> > The __ATTR macro is a utility that makes defining kobj_attributes easier
> > by stringfying the name, verifying the mode, and setting the show/store
> > fields in a single initializer. It takes a raw token as the first value,
> > rather than a string, so that __ATTR family macros like __ATTR_RW can
> > token-paste it for inferring the _show / _store function names.
> > 
> > Commit e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")
> > used the __ATTR macro to define the "auto" sysfs for weighted
> > interleave. A few months later, commit 2fb6915fa22d ("compiler_types.h:
> > add "auto" as a macro for "__auto_type"") introduced a #define macro
> > which expanded auto into __auto_type.
> > 
> 

Hello Gregory, thanks for reviewing my patch!!

> Well that's really unfortunately.
> 
> Is this really the only "auto" in the entire sysfs structure?

Thankfully, it seems so:

$ rg "__ATTR\(auto"

mm/mempolicy.c
3786:   __ATTR(auto, 0664, weighted_interleave_auto_show,

arch/powerpc/platforms/pseries/power.c
44:     __ATTR(auto_poweron, 0644, auto_poweron_show, auto_poweron_store);

Although maybe it is more valuable to check any __ATTR family macro
for a macro as the first parameter.  In hindsight, I should have been more
wary of passing a keyword as a token.

[...snip...]

> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> 
> Maybe - 
> 
> Fixes: 2fb6915fa22d ("compiler_types.h: add "auto" as a macro for "__auto_type"")

I thought about adding a Fixes tag, decided against it because it's
purely cosmetic.

... but now that I think about it, I think this could break some workflows
for users who have automated writing to the auto sysfs file.

Maybe I should add a fixes tag for the patch that introduced the 
sysfs file instead? That is,

Fixes: e341f9c3c841 ("mm/mempolicy: Weighted Interleave Auto-tuning")

> Reviewed-by: Gregory Price <gourry@gourry.net>

Thanks again, Gregory!! I hope you have a great day : -)
Joshua

