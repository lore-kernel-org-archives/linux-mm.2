Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B42C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109756B008C; Mon, 24 Aug 2026 08:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9E26B009B; Mon, 24 Aug 2026 08:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F126F6B00A2; Mon, 24 Aug 2026 08:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAAF46B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:10:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58ACE80109
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:10:30 +0000 (UTC)
X-FDA: 85136045820.04.0A066D9
Received: from flow-a2-smtp.messagingengine.com (flow-a2-smtp.messagingengine.com [103.168.172.137])
	by imf02.hostedemail.com (Postfix) with ESMTP id 55BAD80008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:10:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I xf8Oa9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OXgLEY2A;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787573428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BetWuGtES6FYCL43UJL392AYum+pn8KC95eoabgl+4=;
	b=CI+45quxvGo4Db19sTvT+yaWqLPbgXnjbVHgahufrHVazOq1jnjEYXlPLo7BolcksT+/yF
	306gNuBlRvlaEf6kMHVWTqm67TF0vuj6y/r5BqKwSW64tGm+38wsJxHWbgYQlv5L8HqYTy
	DkgN4bQKEBUdenhxOj0M3XH9mAKkqqo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="I xf8Oa9";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=OXgLEY2A;
	spf=pass (imf02.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.137 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787573428;
	b=arZdIJI3m5uGdsl7PDUUhDYRmk4S7itCZAodrGYkVqgCrw9r5ymY2h7I6h1OJQ18cD37rN
	DdYgkwfzwI6sn0sRHk+6mC3HpKJjLAOQm4UQ95MKOf4v1VGllVMsleLb2pmt5ERcgXTGZJ
	yAPBV/Iaw37ctL+UWgy+/x8VATHUj0M=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.phl.internal (Postfix) with ESMTP id B20B513801CB;
	Mon, 24 Aug 2026 08:10:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 24 Aug 2026 08:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1787573427; x=
	1787580627; bh=+BetWuGtES6FYCL43UJL392AYum+pn8KC95eoabgl+4=; b=I
	xf8Oa9CGDPitrXuxFpRTrNA/CUA4sLabnalrpbCnQQxYCTmD9GO+glAmL3vtkY6h
	QLXiD3Hj1AHISvBlFKZLIBGppjLCqHHxa07bdE0OVsc9UdQfjLpRqtDgAIg2U77O
	tnAjFSA8z7aiv1DX3PihtFYqDxukxvEiJRzMYdt/yqHRUHSNg34hpmIgnPsXgmLB
	4X6AvQ2DhwD5CAJeBoj+qKjwVkvuo2Y2S5QQLu9t+MuFoGwS+3YMn8Wmf8eX/yoB
	1dfdTWV5XJRG6HZYHyk440xfHYoDj0NQU8KajMbz+qkQHuQ4WGNutoAe4/XJ0KWj
	VB4HeMYa8p5b4eUKrj8lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787573427; x=1787580627; bh=+BetWuGtES6FYCL43UJL392AYum+pn8KC95
	eoabgl+4=; b=OXgLEY2A9FwIshfHHebpmoL+yx5E+ITZcbpOPAGV+NYLBq6GmXf
	tqbl6hT115nzi2LiraX2sQtMCAouB41P0K7ztgelcc30CIKxOKGVwAxPiXjRUNlJ
	hhvQtHoZ7b82sTa+OQShJFcW883gdd+bBjt+z72BQSwjHyAG2F8t05MSpSyDfFTx
	umE3vvEfytupD416/dNvaZNbpuhxdJZfuapJh3QE84YJp9eUWlceLyWw+qKvk0FO
	pvi5rxXEPfCMZWk+emR3FuYO46O0DPHX2xehfDIi49yLMcoTfSQGpQuasd+IW+cS
	jUsyRKtZHHukq9dy3yt4i6GTTeU2uI8eGoQ==
X-ME-Sender: <xms:sTSMakFevnMHez-TsqKHTsGyWanYrCxBrd4Lk3gnXCC-4OprI7Za_Q>
    <xme:sTSMatz_urE6iaOB-WyzJTICJtuu0FSjK67-8vMGykqbqeF5RseyorO3k10B-ziJp
    uOA0wmzDAMsSmRUj1jE8uAGKOKiRAZAYbfgN0hqzmvQA6VM2b1kgHws>
X-ME-Received: <xmr:sTSMavkusQFypit3V_l0slgntFw9tgm5BIRSseDwrXGQr2uX1oIjqPAgNAk>
X-ME-Proxy-Cause: dmFkZTFGxilWmuF3Gl8ZPZwxYmOPn0BEaIq9i7rD4Dd/1XrTGUj4VjY7hNztkoxXS7e9ZX
    YOYCvvo5OHvsSrHohvqkiiFE9sNB19lqguDTit2SqCzhTpIB4v7LIV83ME+lt1IbVb1ARD
    e2/EdAAQDqfcEuYGEcfG4q+pt7q0fC/FZ/Vwcmo58WjowQAHZApEtHoFu5aD3C7z71y8Gz
    zEBghY8bMP6bHVe/TUqSuv5AD/pO/LC3TsFeZXg8JGdhaszDVG/9i81PGz50gehDJn8PWC
    NP7q7ABVVUq2eZhbZ330aHp8uM7GSMXzZSNR0JpPHXuEnVRObiMpWpE0UIl/UvwHR+Qxbi
    LjgmsAooNDIMPFmX+m4464q6lesSjU7e/tnyt/a5TB9v/aGR+RPfNiUYCrz8UicH7kgOzK
    rHR16IBtYq47Sxs1gjnHLNodrByJ2R8drPfrlc2ftPLOOr7rvKPQ4DdbZS+7xYh0Vgmnhy
    2/0LjGGwEFpWBjeUFBtWudNveidd7/90j6jHovxDPLZQmyY1cg9CZb8dEfjrGJOgW7kIeE
    H3WCMtKx4SHKzby3wyJshdKRJKNjd82g4Qd9I7RaJWq3NJRPfHEKV0uSmPFjBWLRJF3o4N
    /YUfL4CmzBhuyh+mxcZu7/mHScQh79irYR2t9Svxs88/JmR08/JUxMStYqdA
X-ME-Proxy: <xmx:sTSMamHd21CAaMomXAUVBo-FgA5wNjmNhqpK2QhqUJt_H1qk4uX0Iw>
    <xmx:sTSMapvUfTPGmNUMJiknWiPNnSQ-SYLAuCW3ejG48vYb5PuKcs-jzw>
    <xmx:sTSMahkDBiv3DzcXCA9aoXsj6BChh_cqnCHBtR1t1s90pYwIxkXnng>
    <xmx:sTSMahza4TvNiccZORwLjRcEtq71ZdGd-U92dZ30euOc5yQZfOXlAQ>
    <xmx:szSMahs7409M3gBwcHW-k22zOB_yMvq_Ys9rNUlTLNp4mIiedxwAMkWn>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 08:10:24 -0400 (EDT)
Date: Mon, 24 Aug 2026 13:10:23 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jannh@google.com, willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, 
	mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
Message-ID: <aow0Z6mrG2esKpRZ@thinkstation>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
 <3113ac8b-c1ce-4577-9e93-449b70818918@kernel.org>
 <aobglSY5L1KoIqxF@thinkstation>
 <65433d1e-95ca-4434-828e-8f381d3384b1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65433d1e-95ca-4434-828e-8f381d3384b1@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 55BAD80008
X-Stat-Signature: 3gxh8984tc1fk5anw9c1d5ofunukq7eh
X-Rspam-User: 
X-HE-Tag: 1787573428-248182
X-HE-Meta: U2FsdGVkX1+UczcLRihjI7VeiQ2K5aTYbV49EzVg/jkTLJfQO8Zu8dF1JpWqN+FIUgYlnd5FqTiMG8MubyRfxzoMZKQhv6KYSoAdFyEHc1dkGJ/AwXluZZGAgqQUHld/6584fGQRDpAANS2uDJ5skRX2YDThcq40wC5ROGRkn5jnj13YiusNywEWcxMrcCGVwo9/c4/oLUuUccY4l123IVWDx+s1REvFT6Zv6gJdDZxWlsK2fnr7TRlORQSNtaBgbOXtGnqd3J7CipeWPJJ04zt0XgK94SkTQ6NpLqVtdzxetKbdJQTy82MhufSm7WMZYJhmg/U0cJmry80JVMvH0076uwT9GQx0gEoTmvzyWYjzanR1K0zzRedW17CGA96Rgqegeae+/zaiKnx3zkNJUzDFrF9NCDZq/W+/Lbt0rIKB45b4eErinhpLd0VFN8pcwUsOgJjoIM5yiuhc+cpcmZhNdDA8g/leEo++DyJKCeTXcGnNEyXSLEaU3b881vde/uWGZJcfeFFmbiZfZ3i7pcs5Z1V+Z2LB8/S2bnSIamiGVpaQ5s0+4D/TyqQzwxfjGEX04TolMgWFWDb4QQFfWjXQtjKdOSoDNqUNjH9N/8WcOMEHKFgHPc5b4O3RAppkKHN4UEDT3UcgWSufT/wYWRD88TGDzwNbvSjtxwyI1bIHZEYgHzsazjrGEBtTpM051kBytOBjM+0fdnCnnHZIjqshnXp5kO1bEkDKHxKvvFKeHdGXgetBRQbxWhHvjZ6RdlpKhHHqT8IALaoRR0YtlWjFbA/kg4ELPpLeFcsQPJqpnwp91U/jVKTIznSicbCmH3oyINvThhs5TyDK+FqVZBLXyB/DoKTeE7vq9KKX6/aESc/JRN8DxGDALjMsOCcmBX2pZ0Uf0h9LTFjasVYM9baJ9URV2AIEyTbmduxxPxne+gb/s61FD+G7Hnt0sXanHKHyAk5EtJ99jyplT+L
 lI7+GZxU
 4OKJeUeiJXeqMp2rH9vj/CMceAFGhWeMw7kcEz2NanTHXRXHnzgYUDE/0oOFThe00qSc5tpjY7iOvidhmcXlz3hYhNcdhHQn6HFBPue1g4FA5SZpas9iPOuWHGvy3o6NUxPGcPxmG0FgCM21oLhlBry2kxhF5n/WiJSxNGD7k55oTXbifXGmvBnTMLAzqByoDwXydYVW4qHJpflfVbfsxVHUeYZYd8dztc38tzQobWYYuD6lcGzi97I1HKm/X62raiD0Ndv+Tu3P7jcK4JOJuPCjz0F2rCv5fILxCd4n2wJde/ErDSpgSaEH+sG0ikotuSBqNnaI6VO0g8wniZ9fVpT0MLx+1GlT7og/EssdH/+Z5v3XjrXCp4tGpDQmXO80h+u42lnKFm3FhDrzncp6aIB2yInvZl1RwakTPh+sgoyNJOUJiP19M2cEXnGJqjyPahb4a6aWFae2F5lT1itdp/9Ou+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 01:47:54PM +0200, David Hildenbrand (Arm) wrote:
> On 8/20/26 13:11, Kiryl Shutsemau wrote:
> > On Wed, Aug 19, 2026 at 04:19:41PM +0200, David Hildenbrand (Arm) wrote:
> >> On 8/17/26 00:45, Kiryl Shutsemau wrote:
> >>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> >>>
> >>> Preparation for building the new collapse engine in its own file.  The
> >>> engine and khugepaged.c need to agree on what a collapse result is and
> >>> what state a scan carries.
> >>>
> >>> Move enum scan_result and struct collapse_control into a new
> >>> mm/collapse.h.
> >>>
> >>> No functional change intended.
> >>>
> >>> Assisted-by: Claude-Code:claude-opus-5
> >>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> >>> ---
> >>
> >> BTW, I'm wondering whether it would result in less churn (independent of the
> >> other changes) to
> >>
> >> a) Rename mm/khugeapged.c to mm/collapse.c
> >>
> >> b) Move stuff into mm/collapse.h that a new ...
> >>
> >> c) mm/khugapegd.c will need.
> > 
> > I went for a clean collapse.c on purpose: the engine is new code, and a
> > new file keeps it readable while both mechanisms are in the tree, with 28
> > as a plain delete from khugepaged.c.
> > 
> > Your shape is less churn, though, and it keeps blame: 29-35 move about
> > 1700 lines as add-and-delete today, and most of that would stay put, with
> > only the daemon -- mm_slot, the scan loop, sysfs -- extracted into a new
> > khugepaged.c.
> > 
> > If you prefer it that way, I can give it a try for v2.
> > 
> > The rename has to open the series, so it will collide with anything in
> > flight that touches khugepaged.c.
> > 
> 
> Kiryl, I have to ask, are you using AI to write your replies?

Yes. I use it check my claims and fix my grammar.

Why?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

