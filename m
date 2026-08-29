Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC5E5C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 04:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47946B008C; Sat, 29 Aug 2026 00:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF83F6B0092; Sat, 29 Aug 2026 00:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E2A6B0095; Sat, 29 Aug 2026 00:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2566B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:39:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBC03C0610
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:39:11 +0000 (UTC)
X-FDA: 85153052502.01.3197003
Received: from mta1.migadu.com (out-68.mta1.migadu.com [95.215.58.68])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC4E380003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:39:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obGKmCHZ;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787978350;
	b=ab81BV5C6qG0G0AH9wMymp2RbCJBBT490iuTIXnVmTPuXr0EV+wAaKKIjasSvo7VlUQ+Tp
	e8PrO2lowayntNc3xa8xrz9FGgb2ojyA/vBqK/NPqBh2/LvuS3MEIb0dRsms2LTEejtmZi
	KtljB24bmwiRLas75zrPbWs2gFt9D/8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=obGKmCHZ;
	spf=pass (imf30.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.68 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787978350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjBXgeDn6Wcd4jStH1R7v/NMp5ixkFmR2sDS+gJWsQk=;
	b=n66IEQDCkFWCFWg11xjdbKJ3pE1MF0ICwClpdfs5IfZ3HEGW2Hwa+2B7JxZlELGhHfh8lw
	9MvpU58mKhAKTlTIWLi/35Bf6MAxmqEvOmK8F0E01snH/q/N2KFULrQigJ9nM3vU7vZsYs
	jykjW5zGtlH3W2Fb2UTh9WxexgHNcn4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ccYXNPj/B/0WdxnMrSq4t7JSxTjFKYCzydgIEuIk/aQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787978348; v=1; x=1788583148;
 b=obGKmCHZiVoH5+A6EW2bEYuxIqk8Zh/HkST6tiGpCudUVwas26L9sP+soJ3jt2E7aNKw3uzT
 8IdgECzez38F0v7iiz+WnhtiztanmxbOFXxnDE4STTrvcglOlbkzbfAu0y7WrJBp5UbckfMoorQ
 JVJOg+FCBRbUeaMhwUMbwqKc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fa5da2c804325558;
	Sat, 29 Aug 2026 04:38:57 +0000
X-Mizu-Trace-ID: fa5da2c804325558
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: jthoughton@google.com,
	akpm@linux-foundation.org
Cc: lance.yang@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	shy828301@gmail.com,
	zokeefe@google.com,
	hughd@google.com,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: Don't install PMDs in uffd-minor-registered VMAs
Date: Sat, 29 Aug 2026 12:38:52 +0800
Message-Id: <20260829043852.45486-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
References: <CADrL8HVzfEXgE9OQfULhe6wh1kMMOALsYuCNOUkgBqtzk_LUVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: f5d3bky9rn77kqr8ssk5oeyukayww7g6
X-Rspamd-Queue-Id: CC4E380003
X-Rspamd-Server: rspam06
X-HE-Tag: 1787978349-206539
X-HE-Meta: U2FsdGVkX1+7MYNJ4MOakmXskTigvSzpn2EtLWNc3bbPphn/2ror8COziLt7VrsR395KRCkc4bAIRiyQNDTkUQpgPu+0nwHZuJZmBBefto5QefTKBdFuxedN83B7QyOGM+njbYAV8an5KM2mnR70CdIYGVdGZqsxhrimjr4fmRqgnxU2wFh5VpZ0c9+enhlNogiv/hVIhTjc2NXTikt041naf7AaO8Hsm+zs44ReStxyf73wtsA5MXRGNDmtI8Ll0OsY1qeuRMCtURYoSGlhOCBGwawCxNQTULJFbysmEewOzDJ42GZjwBi8HHUlE6xnolcNgLs2Xajk64TkNzxHH/WllSQcNBZv/k5R+ecZW6w3kKc979CUfB5tmxVpB1J18f5GqR1NjQ/AVgsKDGsT1NxVwER/Z+Q5Ifucdtmb9FFfNFPxd5w+nSgwnj9m8nvC6bI2yMzGPRoCcKf5FSWg7Nk1+Vc8jDy/xgaai1ltgWdUs0sPbEgZ+blvb00ZHsXAHCEAYwdkw+rsVcel2cpPCw6QimspGQ9eFcpSB3yMnGtbX0yd2t/whZUw/M93iFMVDRwPNBapZIm7gIW7flWHKuxstiO2znjjEuKLaqOP8g71oYcsSffS8GVWHNWGVhccF2KDgWPlCl4vjVdMrF5UAs/UaLNxD+s1rQdi4Q18pQzl4u/XFtpqqlEcDn+Ndr12jCqI4fOwJsQiJyMeUOKOk7V4D3Hmvd9oGckMSrCBWiY8lfWf0gd5Fico68e8HQqcQ2l95VW4mwyXyni+hR5cpRtUKzahwEC71OPBffROZudLr9vBPcTpf59cAdhVruORregDmwhjwReQpRqxiInmZYT3Tb4mog7ef8mtZ3vufsBxpF7kmV43FXtu4Gkz4wQfSbrYK4bwa9uUD0Cg2C6HdkSPn43PsDI5uFw3sA19TFmlHcfhqc2CVGVt0jE/EgShNi828BPAFZPVP1E1zfG
 PE7EYYRw
 +He5EoF7VDZj/iJcbHHg32+IftLDlbQt+lubj0t2ZgQtPdfzbGvZ4/hPpjC8kwKsqDfRExluJkh6mFci8EPMecU7Db6K2Y5wBMsXmpHkCWP1W9pp/R5Tu2O8hiduElZp0imaA75UIQyuI/K9rSr3g78c/elHEoMaJzExg8ZxI9sIlXFk63Wogve9L2RvW1YKKSbyQyholALZNjSxWx8eRfbhAkzpZ5x61VMK+zK7SiF4iTOw6ycQpHyKejFS+MjX/+nYigImOK+/eBMjCIIzyc44McsGzH2LNQdw7CsyA9hUAraLTIHXoURbUSiGDHE2e1kNs8WVJPf+rc07cSHHFIxFIGGACzy8GtPZb820wu+4Hw0N6Wbtc3jKi7SBT6qCcPrEiK6yqWPennIEGX6rRBtfkh6tQCM+3lxB5QLwy1kOo/pg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Aug 28, 2026 at 06:09:39PM -0700, James Houghton wrote:
>On Fri, Aug 28, 2026 at 5:33 PM Andrew Morton <akpm@linux-foundation.org> wrote:
[...]
>> Wondering what Lance tested.  Was he able to reproduce the bug?

Yes!

>I assume he just re-ran my repro, but yeah I'm not sure, heh. Lance,
>what did you test?

In general, I prefer to write my own reproducer from scratch, using
whatever approach works. That's what I did here.

On the parent, MADV_COLLAPSE installed a PMD, and a later
UFFDIO_CONTINUE failed with EEXIST. With v1 applied, MADV_COLLAPSE was
rejected and UFFDIO_CONTINUE succeeded when registration completed
before collapse.

I then extended the reproducer to register the VMA during the mmap lock
drop/reacquire window in collapse. With v1, a PMD was still installed,
and the later UFFDIO_CONTINUE again failed with EEXIST. Adding a
userfaultfd_minor() recheck after reacquiring the lock closed that race.

Before reviewing v2, let's go back to v1 [1] and settle the expected
semantics there first. The check depends on which policy we choose, so
I'd hold off on reviewing v2 until that is resolved :)

[1] https://lore.kernel.org/lkml/20260829041523.43008-1-lance.yang@linux.dev/

>> Sashiko might have found another race in there:
>>
>>         https://sashiko.dev/#/patchset/20260828222640.1638457-1-jthoughton@google.com
>
>Let me get back to you on this. Best case, I'll send another
>(separate) patch. :)

@James please don't send another revision or a separate patch for now.

Cheers, Lance

