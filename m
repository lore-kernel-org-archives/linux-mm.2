Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62BF6FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 13:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF27F6B008C; Mon, 27 Apr 2026 09:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3596B0092; Mon, 27 Apr 2026 09:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96BF66B0093; Mon, 27 Apr 2026 09:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 859286B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:21:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 441DA401E8
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:21:42 +0000 (UTC)
X-FDA: 84704398044.07.25FE7FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 72EDE4000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 13:21:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jta2gwrx;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777296100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DDJQAomhpbgHmx0d0GWYjp7TvL8MP1DlQdQWbPxhNtI=;
	b=dwJXQH0LyFJvCF/9cSHFFWFRAeo/OykaN0EB5hHxhnhWZ6sKq86oDe8zmGzcHN1p68IrfY
	pk33RB5WZU61F4x9AkhgwsU+T0o3vHDT1AirXG+zeTKyXaQHzMihWwgaktDquR13/BxpAN
	UnTgwWI5PpTmCiiL132KQ1V8QYqcu4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777296100; a=rsa-sha256;
	cv=none;
	b=ZGqQiSjheCIdFKisyJmB/6kQjF04pCU2XtoFiU/aczH3nmlXulit8Z6dSPqdsoPwVSPCGd
	GHSnWt72v3+ZZTiC8t1Bip3LEqs+33xDHTbzuDh4BcbH7+kP+jBmOSVCAt0xOJYfJ7vfmp
	S8GzZFYU+2sHixFKL/xEbfAwgO+cdpQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Jta2gwrx;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D49740D61;
	Mon, 27 Apr 2026 13:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FD3C19425;
	Mon, 27 Apr 2026 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777296099;
	bh=avnmxeCZBiKgCC8aIsqG0WKzjB7wlRqMwF6cWUdd2Tc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Jta2gwrxlY2QHojSmCJf9P4jLAr70WOBILfb+lh+rXNGa1UpXXkr/VRPikeBQysMO
	 Qyf7w0lBec3pCEdMAYYTbC+r7EU253H8Gdz6eRUbgs/c+8a8UX7bEVATx5E8EtzFSB
	 lnSnmboxhJ65EPM4QNGcDg4UoEMKG2TB3SV/eN8M=
Date: Mon, 27 Apr 2026 06:21:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker
 <dalias@libc.org>, John Paul Adrian Glaubitz
 <glaubitz@physik.fu-berlin.de>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu
 <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa
 <jolsa@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel
 <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn
 <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, "Liam R. Howlett"
 <liam@infradead.org>, linux-sh@vger.kernel.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH 3/3] mm: remove page_mapped()
Message-Id: <20260427062137.48739e6fa6e550f1f0e8ff48@linux-foundation.org>
In-Reply-To: <20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
References: <20260427-page_mapped-v1-0-e89c3592c74c@kernel.org>
	<20260427-page_mapped-v1-3-e89c3592c74c@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 72EDE4000C
X-Rspamd-Server: rspam04
X-Stat-Signature: miz3qr7wxfhhb7syuy3twhkjycrftm4c
X-HE-Tag: 1777296100-598216
X-HE-Meta: U2FsdGVkX19/cdyDgXKRga7mv7yz16iRThAZw9N1ifWNnb1MKWE/y052VGNG9jdc0SIia+tAOc0nZHvzssoWg8I7QSvh/0FcXKHAIucDCH1McS+ffp+ZgDCg+mAuvcncTIKOokiTghGFN9UpzzIUAl/V0H+0c1iz4M5qI6vxeq1LWmPqtFOjh4SLsswGfm8Flqf1rCyYxYSDGh+Rv6DwJ09T47+jbEgmaawfPokteMH5H5fXAklAt3O5YKzuPHX9Waj7X54cX/Nu+/8lCdbPkfaOvqTqF1UaKtVJ2WGzgX55VhSPvKrS/3Gv/t1F0M0eRU8au+I1T3qRJxq4+w4C552xxH/C9fw1EpiqqZTdR+oG5gTWGGbsroZV04Wl36zLOWgPMLXditPTvwYkl/y273Ekzj3N/052/8TQFc59tTE5Rm1n7DSg3cbO5rvc7ZGaw1ZYmJKpeh13oWaa0SJ44AC3eeystlS8pO16ShU1eiEwouPCc55PC01TonJ5lPxzYxZWr5KWmyOaPNLI7hxxGzo0adtbboikaUq7ZErFgjK6zGR+ThFkglVmhJ4ZpBAW0tQUqztgCebPHd/jwEGjXTph7uZz3Wm36hykuoirbSHh/qA7yqT3rePuaPLhDPhsPfUFWnSP50OWB/BsNvW0bwBsPF/NgfBGtYqILMtey3rR7GUlOS18yEFxc3YBHitPZVH8L8EotEjuiABp3v2XwmJn+KNuuaJhaOlIk6GLXFhyIv5JwK3T4Z4lDNEiCmsGmw0hp4qWZ5wmI/QPsCysJkqVgFvjHA9lmGYV198uF8MOsMMhsN5u3ER/CQY2sL4/3gMdkQpC+Extov2jlX2ZiYDQKUgFOEetgfbAKOoKTE4jeu7RgjsbYCI1ej+cyEPvxHFrn/rP3kjeXP2/JFu+NnR78IUpeJSdE8mooQLPpJjS8z9v5xBCx8MVRSGrCC8AxzLEclajaiG0nqbmY8c
 59J9fcvb
 jqB5aHvnOb8Ga3KzL9iUED9ASIhMmHOa8YNEg77evxSBJTUYtzEiJehJD0L9zvN2uTZF3LWuXUI8BsLgwRrh0bYC+IuS2xHofDMqVwXNLPyQCnzoLUGun4Ogeb1ene+wNElwGihpBP7hPITqnDBt+ME0XLjlKNvF1APH1rxeB7M5GgYeH1FWP4VYtN1/2GneapQShuJfdOoZjT5DMf153mSYIDjBGR5y+MnP35jDgaUIAKkhrp+CkRhXoDoSmvkhdluQd3KiAhsCRyMcovXi3wU9bho9p93JAKVNJZ20vrwdZ2hC/VHEfbsMMvqn9pJFCK0Gql+UjC6ubqJl6dmyAy59+AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Apr 2026 13:43:16 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Let's replace the last user of page_mapped() by folio_mapped() so we
> can get rid of page_mapped().
> 
> Replace the remaining occurrences of page_mapped() in rmap documentation
> by folio_mapped().

This broke Breno's "mm/memory-failure: add panic option for
unrecoverable pages"
(https://lore.kernel.org/20260424-ecc_panic-v5-2-a35f4b50425c@debian.org),
which added a new page_mapped() call.  I made the below adjustment to
Breno's patch:

--- a/mm/memory-failure.c~mm-memory-failure-add-panic-option-for-unrecoverable-pages-fix
+++ a/mm/memory-failure.c
@@ -1353,7 +1353,7 @@ static bool panic_on_unrecoverable_mf(un
 		cpu_relax();
 		return page_count(p) == 0 &&
 		       !PageLRU(p) &&
-		       !page_mapped(p) &&
+		       !folio_mapped(page_folio(p)) &&
 		       !page_folio(p)->mapping &&
 		       !is_free_buddy_page(p);
 	default:
_


