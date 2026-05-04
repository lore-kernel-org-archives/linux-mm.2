Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D06CD342F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 20:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608F86B0088; Mon,  4 May 2026 16:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B99A6B008A; Mon,  4 May 2026 16:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8986B008C; Mon,  4 May 2026 16:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 352436B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:32:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6D281402B3
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:32:45 +0000 (UTC)
X-FDA: 84730885890.27.154B94D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id 219EE80005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:32:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KSvaHFxL;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777926764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V8IJ0XLiNUSdII4ZYGeMeYsOXFzkpTWAB5nfUHMUTJQ=;
	b=Wu47A6jQHEXePazA/1Vq2OmROJWxXE6EeH5o+OMrZRHngr4wR4g5K1dYu+efSCEFVE2DsG
	lhc6+JVhCMZpthiikWSqrzKxk+SoeyrIivqxNBwkBxENdJEZN8PNmHe8rSOYh3u6AcUi3m
	LseqyKZZY63Lqvgk04Sjy/MOSSQIG1s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=KSvaHFxL;
	spf=none (imf02.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777926764; a=rsa-sha256;
	cv=none;
	b=D1kIDZYoeu92wxIBdjs1q/8hOqqAHgGH02/af+aMpbvkkMHzkJJEcZ2RHWIYrcAX6ZjDf/
	LVT/kYJoavzYYeFRko5FLYdnbUSXJMcria1Pwn9zFHy6OXWJYl6MLzpmOI6dBM2cBfpMB1
	OhZXlUBghcp3tI7eJ0LqeqWrv1/DGlw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=V8IJ0XLiNUSdII4ZYGeMeYsOXFzkpTWAB5nfUHMUTJQ=; b=KSvaHFxLwR6VTX9keDbXdE2hDJ
	LcU/HmUI1j+39WRIZKFG8wnm7lYCbZmxzflG8arBNkzQHxVjqaJ8VgIwfIn2g6l4XNjvHjbaLUJSi
	OySLEt8kXA+JbNl1MrRg8l6MwhlN5+3PUiKgbtNmIV9NiegVg2g2dddWmyKbYVd4LaSpss9pevlU1
	MugUXUuMYap1Me1DgPuj4KgL/rFPjgTeN3zwtPNAQple3ee3QIU4MmuyTUTdmkXaU2+IJsE3SeJ3/
	aO39NHoGMkR9bM7niMlhyYbgRb1vX+z9o3NauZ1GRnUDAFOsW6K5yYOa2oA+wdWXGezneRwWUWxlt
	ixg8n/5w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wJzy3-00000001TtN-0mDK;
	Mon, 04 May 2026 20:32:39 +0000
Date: Mon, 4 May 2026 21:32:38 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Wei-Lin Chang <weilin.chang@arm.com>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 1/2] Documentation: maple_tree: Point out constraint when
 using xa_{mk, to}_value
Message-ID: <afkCZkHcn58S3GLD@casper.infradead.org>
References: <20260504165746.1422057-1-weilin.chang@arm.com>
 <20260504165746.1422057-2-weilin.chang@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504165746.1422057-2-weilin.chang@arm.com>
X-Stat-Signature: 41jnj53rxfcyzh9d4bgmawarmo9hgw5z
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 219EE80005
X-Rspam-User: 
X-HE-Tag: 1777926762-237763
X-HE-Meta: U2FsdGVkX1/JjQKvqDBMZznjSRAXP0nu5pPMqJRbzSAZm8nv4mKP4M1vkTiNF0rsWglQPQ7l67FOVWiBDNQUBwwAolI5KsR/db7Z8rlYxEG0KI8dawTkT0jkrzQ/cjWpIa79EVoB/tH3tRwiM6QGlYj9wVH2BGyiceC8nFBjxojMeG2xGpr+y6IMbrHBKhH5KsfGaO9pGf/KiTjJgiBKkWQNESbS5uZOA1NAxWoVqPpXMxZyQknGCWzcU51IdcGrUpoDDOU3pveUMXWmpRYKgIA7sWrdzM+y4DdS4XvLut0YC0zXdW+HyOR3zKyVk3owERGpH7cfaIS6mTYYRcDQSdVLcZMkR8MwSJZZgunLX+sp6qM0JhKGjm7m68AjPvTyOBETr4THj0BJ9uUGgZlDcoqiO3ZR3XcFrY5H7J5fwiG3twQsR6dNHm0fyH7g/QNIrsTm4GZlTyvHynBh405HCyLDmnHexeIDsGshRklLu6U7yhbImMvBXmIIjjC4UGOr8+R5THU5CGRxh4nmJeUdxEwX23ZxoCZKiMaGsfvIom5/foKX8nzoUEtNtfKjJUx0lowjSZZLtlQvH3Ywg5eejYWR6mZeQvf1rHxK3B5oAjtYK70o6QUIovBKbe1r197jAR9Sy9P1Yq9KL4lJ92Mo1NtgyY3tRjS4i+o75Jb8eCAJoMcFYl/LQqs0J6Gf0RiaLE10bJx2fnWTNY5zK2RG6661o6MKzsX4QNU44rXCMYAsJbG9MyDO/zgB8892UHQnhD4qxUADh27fZZ0I/Dr0EID3tlL9pWPXC10CbbY2srBnsVBPLhaiHcxPeVrobOKwWGrWrfP7wMZU+toekcwmF4mYzLmQXTjHtxETVxnQ/KTZpdqdmDq91zAL8SkTtXwQrQjuDWrPrbMK/X5dOhiI5i4atlDMqyQmTymaIwpcZ7uHg5ASEvnLfGJssW2jtsIsc1cREDYp/kYIHeAQKCd
 SrCIKv99
 ZB7IsKRdW0zsh5WvSgExJX7+Mlc4PdklTQI1VfFS1Hs4E5Q3RVxXjezwxaaFdKRjv5x8zvJDXWdPFaBw7ebcxxPJuD3hwoX/ePUO/F58wQulu0+yt3UK/eG9Vczb7cs9ppH6Jc/hnHycobEqbs1Rjsx4PjECCoMfy6Fvvbxs6z9PePlI7gCtcIAwe0P3VR+N7+/wGCATvHIwnOYS0zwLZePlKKfrso/nVSEgB2tFPDC6b0Rs+Z2kyT2fDZyFdfgwV2Bp6DB4BQq+Eaj6KVATtgwvJc645KDL3XBVaIg2fwaw0id0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 05:57:45PM +0100, Wei-Lin Chang wrote:
> Using xa_{mk, to}_value when storing values loses the information of
> the top bit from the left shift, point that out in the doc.

I don't know if that's necessary ... it's obvious when looking at the
function:

static inline void *xa_mk_value(unsigned long v)
{
        WARN_ON((long)v < 0);
        return (void *)((v << 1) | 1);
}

and if you ignore it, you'll find out.  But if this needs to be
documented anywhere, it's in the kernel-doc for xa_mk_value()
and not in the maple tree docs.

