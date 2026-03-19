Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF201090255
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C27B6B055D; Thu, 19 Mar 2026 12:56:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A1F6B055E; Thu, 19 Mar 2026 12:56:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7916B055F; Thu, 19 Mar 2026 12:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF8C36B055D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:56:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 74A24BA8F6
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:56:22 +0000 (UTC)
X-FDA: 84563415804.05.A03C0ED
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id CC89B1C0002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:56:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vQdBaC0Q;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773939380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCeA8gaapekYBXGTYyy6inc745Q+Z1LM+wKjknp8DGE=;
	b=Atim+lhBRFAR8yE0zfXupEoXlg7sdJwf5Ep5Ig6JFBNkaJQqXR/X3fMLCGOfM2Jz3VfBqb
	koKfYk7Xhc3Rm4tqSzuPvRCLnMW8xHvFfb8OKhZz0Mm5oo6Jl4U0ejMQ/ACAhK7safAx4T
	g7sAONudUSoGSGLvJK5n1KbmVidqHyg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vQdBaC0Q;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773939380; a=rsa-sha256;
	cv=none;
	b=2yqxLXBer24PGnJfw0MA+UUPfyS9Y9cYYmwf/FOkFpS2KHYxXhDmD0W68oMpyPRQEeavEC
	DRN56ooGrZ54gHZN+qDuNsICtzWiWNXBhU2IJ7l8puaQ734sMy5bQAhIunvyrcSm6mB6t+
	QRHCP4bQBXCwEnp8dHevHfJBvL92MR8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rCeA8gaapekYBXGTYyy6inc745Q+Z1LM+wKjknp8DGE=; b=vQdBaC0QVupOLntmdIDaZrn0Xg
	121fyQDxZ+Dio6hLHiv7v9o+AE8SMLj30MEUKRC6o3LdExnLhUrL8RKRW2YRllz5pXo86pKjobU5q
	rjKmS51loCTwT24MKISGl1Ng/eisEvfF5XTDBCMozkrHN91kAO2dvlfOi07rsG8tCeimlHIN7aTWY
	jjEq4HW+DuyOs7HXJTeEexZq44JURy3AXG2knfOdokqjmSBETN5nA8AMNnaI3NZcwFGIB6o32rngC
	IoFGb6NwQ1M/G2ZnMXPPSEiXHPnE/4ZWguUPBcWk59L3J/E+h9lBWCIoh9qrdJ4rGnrpFbfB7XtGs
	53mzPz8g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3GfL-00000006Osb-1cvh;
	Thu, 19 Mar 2026 16:56:11 +0000
Date: Thu, 19 Mar 2026 16:56:11 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm: Switch gfp_t to unsigned long
Message-ID: <abwqq28hWXMLqa5P@casper.infradead.org>
References: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319-gfp64-v1-0-2c73b8d42b7f@google.com>
X-Rspamd-Queue-Id: CC89B1C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: wkz58ns8subsfihj1gkpz3jcry7tp8y1
X-Rspam-User: 
X-HE-Tag: 1773939380-941184
X-HE-Meta: U2FsdGVkX1+4/MHgwADlppwpP3SE59ow7+mKu/NzdhYhRB8xNeLZgE5rsMkHcaHZv0oP6Fojk79j+jFqYrjhHDtG7XV80mhkf+XDAJgEvdc7zExGiGk0uuNkSL/aI4TzcoF3C1lQWG//GfqCz16+UfHF3+CGDbDo4V2RZDwqJkd+3OQ+9UYl+XyUYVg6+xDMnBv1arxykajRgn6I5bIC63p5+2MQuz0l5LKOspJoiXXdVM+TnEdabOCJiC/DVo2HyPEmJPcb6nFpM3AH6i0aXLpDCJIVMYe8eJiUmyOyZqfulfxG9x8DsO0ku0LcvpCGyETdSV7RRAeQKDRmZT3P5eUCUSZrE5b17IxfB6SV9RhtEKKACJki5GFPEGoc5Z5oSS4WNQ3FaRbGYuBHoguXeiTjUcsd5Hj+spg7Wiiju58KugsxLUdMr1FHLt58eU3p/dDSf4dC8QHB+9iJ4oOBopIZELvFX3Ikd12m+ey1K29mF7gGf5+/Ex/yCVEyZdvXKSUrXG15NrgcV+b/nkgnkLCFQ8527f6s06pXBs290+42A4Ul7oNJ80WRlHu3eJuBEBm52Z+YkL9cGFIn4vNmT76Q64vrwipyszKjO2BY2Xewyo4STyzOTIBe8+I66F2Rv80K6u26CNtATKbhn4o0ef1fQyDHEZxh+nvypJzSMYWVdj5xkob/LyavUdTLMArV2rhu0KEAMsFEU86DV+z/o+2LvzxFqSXnMK1r6iTl8O6m3TNX6CtULOATuS+HgFutqSaHuER9rHjoDsC4AHku895wSGJCzBzoosL9TaomHJ9AeY+pmAVxYroT3gv1lG/udvE+Oy/sx2pKtsiukKPCVqEqEKvt6kCcLW023mEhg98zznI7PYAg2ogGziE9khF0SnPsjXblGFSU+EgqUmWGrVXtCYGNos3zSatN1GaUwrSwfzpgEF8KPUz7u0I9MoXw6lHkC6b40tXeWlGwVsW
 QrKkmUKp
 E5utfQLb8tlVNiJD66zyoQr565ojMX2KFt4516h2joBO5DCjaB3Cas6lNWmbjcTjfKsR4ZOcLXODUCOnPS3Egq46/z7sPvPs6MgI6qmZiUWJH3DkfrqYAGbGF/Fgdv2nq2+6HXUhB5KodIVO1Et9Ysp1kyg9df3ofveVEpflAejzdeKdQtqE6oBaCURh+slQas7uarYcbk8TFqm6vXzEicL7EbPbZVAEKFJfIl9T+I0rDsNajV5brcj7DU+bppegtqsqnacawmnOl2BUiT4suhBqjxKIYagcm0Dw4FrBsgQNlx4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 04:03:23PM +0000, Brendan Jackman wrote:
> As pointed out by Vlastimil in [0], my proposal for __GFP_UNMAPPED is
> probably not needed for 32-bit. This offers a way out of the GFP flag
> scarcity so in preparation for this, flip gfp_t to be 64-bit on 64-bit
> machines, while leaving it 32-bit on 32-bit machines.

Ugh.  This grows struct xarray:

struct xarray {
        spinlock_t      xa_lock;
/* private: The rest of the data structure is not to be used directly. */
        gfp_t           xa_flags;
        void __rcu *    xa_head;
};

which grows a lot of key data structures.

It would probably have been good for you to have run pahole before/after
this change and diff the results.

Now, you're probably saying "But this makes no damn sense, why on earth
is xa_flags of type gfp_t?"  And the short answer is "because the radix
tree has a ridiculous API".  But you'll learn all about it with your
new patch in this series which converts xa_flags from being gfp_t to a
plain unsigned int ;-)

