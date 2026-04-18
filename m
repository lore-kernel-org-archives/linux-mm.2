Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FE6BF99C73
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 09:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8396B01AA; Sat, 18 Apr 2026 05:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851CD6B01AE; Sat, 18 Apr 2026 05:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71A366B01B1; Sat, 18 Apr 2026 05:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6F36B01AA
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 05:11:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D2E813AFC4
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:11:51 +0000 (UTC)
X-FDA: 84671109222.30.249A00C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8C94920009
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 09:11:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEhQyFXT;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776503509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XrR0J6f/Ozigwen3EtXhgckW7YTfzkoFDQXYPRcQ9U=;
	b=r1i8Jrn5zMlLIKys2rBfLpDOHwKVbzIucNpM1+xsIBH+qOnLzb9XQWHneT8UoKAXGCeZ4n
	lSnjmrHYGkDESKq23lrSJtf7CD55jpJI326ijN5BKbA+mrp4WllqzCw0k83X2kMa6oJPLo
	8Xd8ucNdvmQCOMeJn14Eh1pvdATEGZ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776503509; a=rsa-sha256;
	cv=none;
	b=XMO1UydPZ7CBSWAw5tdVHsW5hnkaBCKHFBPEHJLiu6LJGt1N7uOv+S35hGcvcnqB9pyf00
	1kcqwoY1AYZJjKUPaJnIYkuZG+NrhytX2KbFeh1mVCS3Zkexw7+LDaFmm/lyHLB4cEcOzz
	HdqZ/pufavfNdl5mpeE6RQqlISw/WT4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eEhQyFXT;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DE28660138;
	Sat, 18 Apr 2026 09:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 445E3C19424;
	Sat, 18 Apr 2026 09:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776503508;
	bh=8XrR0J6f/Ozigwen3EtXhgckW7YTfzkoFDQXYPRcQ9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eEhQyFXTsw7IYl8v+r+InRT08KNOYYKUYrHoDxNFUUIF4Oj9epIUFOlpRnBFakm6B
	 495gUhZlSAvTNdYx8pU0EtwH6BTRD62Lct8aF632LTiAUl7WvK/qTAxyEBNeZx3+K/
	 dKiwXbhWB6Zj4Qi5MNqjLn6ryWuUzlifrQcP7hupzM9AznmV99n5Bq7ZAWzJKnbdAp
	 cNrC+V3tOjs8f/Iis086NT4I90Gt8uMVei3KJrM0oP/QIAGUBoTf6mKwXpc6iCH+21
	 /Orp8tGfGbY/sUxYW6cc28QalsG924tUb0ZIubdzlqoPX0xRbbtJZpknFKpk5UjIsJ
	 pwS4xZoXje4Vg==
Date: Sat, 18 Apr 2026 10:11:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nick Huang <sef1548@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] docs: Add overview and SLUB allocator sections to slab
 documentation
Message-ID: <aeNKDh8S6pXHqRFh@lucifer>
References: <20260418000635.17499-1-sef1548@gmail.com>
 <aeMQ36jFnCKmCSyA@casper.infradead.org>
 <CABZAGREDHwsXMm65_WxEn=v-zTv7_eVqQzQeCRqU2Gyc0aTETQ@mail.gmail.com>
 <CABZAGRGFpiiEr7Odd5an1+9Z+sX1C6QT2iadv-0hNhxGj8eEyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABZAGRGFpiiEr7Odd5an1+9Z+sX1C6QT2iadv-0hNhxGj8eEyg@mail.gmail.com>
X-Stat-Signature: bycqom7reicydj3r5ezzkkweopfxzhsw
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C94920009
X-Rspamd-Server: rspam05
X-HE-Tag: 1776503509-262719
X-HE-Meta: U2FsdGVkX1+lR94/cqt175Sxkx6uG/vYf+tvntlCi01SgoBOtbUGhiM909RF3nL4weai4OwlC5wAffqsVGq5ZAfUV/JHvuzOUbEyDK/6wToUPcfAwVNyoak59/8VCNFDMJKEFBtLk9CNPRe/ZEb63lA1m/3NdNDX6QqyqXDnUVLmljzAYKyT44TeJn6XuRQqGl+rxxn7QfSzgpReFzspIBBX6faT+/3GMHkvI6ihmcmGL/o/j+pgsxV/KHK2FTSJtO15430vXV6r6MvBxw4GKRMpwkqCBmiehuZ9VajqiOLC1FtcPCvZjIsG/PdUTAcRuBvM8kuy6Mcm/Tu+1yjBx28RY3a2DEr0mpCH2Ru5zdZ4azQzwhVgwrES7B41bbU7OJn4siVenDOk0xWYcdjkkZjyKpqZkWw5rCHfShKsJw5lKf/zsmDQ4DAApwjckkobd8QiR34nHVpU83pRUjJovI6nrxfLmQjfwmDRCLQ/KpnL/j9GvfLssXgrWR0JzNgELW44OqtbyDnM3ZLUdmsGE5kxdGJJ8Mc1mVuvCYEO7Qn1rlvNJyfpeTkIhKoAM9XrFL9PCSZjmEnfoL/QWqc6Hu0YJ9FZBDy4INrTjNJWT3qbDIuemN8SR2ykzG1hwRRemui/k234LONn9LsG9FONP79RPsdVScJqxz4aTQZO3IafIgEse0whdTDT2OCWWyNwo0SJZZwGx2BV6jpR9Chqn5EGvT3cyxFASK/oKXOtAyRrrh5wU8Hsnb0luxNHqctFTlUldNTn5L7gJrUGHMPrpwdnRVjI1BMZqJDv+CW7BHoDL7KlNCuUQiRP2xZJ+jyv2u3LbYZcwEjs8yHXuDubMobrPK+yNVkGeg9lGm9dWR3/L7y3CSfWqApGUEjdXXxOE+vhQb5tZ0jj9l/f4KfH/kSKIMZdTi2MloSetyN5jkAYA3kwq/aYeg8pRAytlE2gDGOllE6TAYCAtrYCjYw
 auIYE7Si
 2o/Dcnrep8guekiJSbwmLE8E/3VKjNQzrhTMtGlrPT4bq526SoS4/sBAbtsllnlqYanhAI5nU6968nd/s2gKklaiSgNKrtRpofYBEDysuiNthDhRC6922GyDma3RrcgBgYc2J+4nPOddzzS65wRAjspc8z/HrFnfG6QVqnsTH1D5RBPvvyQ0No2kq4P+QF58z12F5zXhK7fFUyBHBtzqiLvVpjv+xK0+jHlEf0alCr0HbzY+GeP/fJF5RFsqs86EGflpktZ3CnpzX0zWHHu4hJCmb3mnePPkMJpK9LTFiOsbjjIhjVgry73DMlOdXHpgPxHbn4CP7sPea4MRNlKplSkkS255gKZct9IvG0Lz0+K6Od/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 02:12:22PM +0800, Nick Huang wrote:
> Nick Huang <sef1548@gmail.com> 於 2026年4月18日週六 下午1:27寫道：
> >
> > Matthew Wilcox <willy@infradead.org> 於 2026年4月18日週六 下午1:04寫道：
> > >
> > > On Sat, Apr 18, 2026 at 12:06:19AM +0000, Nick Huang wrote:
> > > > - Add "Overview" section explaining the slab allocator's role and purpose
> > > > - Document the three main slab allocator implementations (SLAB, SLUB, SLOB)
> Hi Matthew Wilcox
> I will remove this sentence in the next version:
> “Document the three main slab allocator implementations (SLAB, SLUB, SLOB).”
> I’m not entirely sure I fully understand your point. If I’ve missed
> anything, please let me know what needs to be changed. Thank you.

No, please don't send any more revisions of this garbage, thanks.

