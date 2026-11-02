Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0236B606D83C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 17:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=hCGUwl5E
Received: by kanga.kvack.org (Postfix)
	id 7334D6B05B2; Mon,  2 Nov 2026 12:27:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E3C66B05B3; Mon,  2 Nov 2026 12:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB1B6B05B4; Mon,  2 Nov 2026 12:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34D336B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:27:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B60F51401F7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:27:54 +0000 (UTC)
X-FDA: 85390861668.21.E3FF912
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id F009C1C000F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:27:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hCGUwl5E;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793640473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leKsCN/AW0CIMV0Z58FExykl0a+UkP/KW/e3nsnHLQM=;
	b=FBjWT8aFg52wIAOeK3EVBV3eAtTSIwpey2jn4cG72d9ttsBXwIn9owPMYGU48Qn1uChYVi
	gsnIpHt1FPAe3LFafaKD0D2Z+dBO/xW7YosexzoqBhorwTQ0kqjhLez1NsMSQ8jHCUht+a
	oRqJUUe7ySbLy+Q61i8PWHHb/Kw4HR4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793640473;
	b=pTDhRPSZgaKqNh44hnnO428AdhicRC1dIdlycfgTdaZwV50epIvhA3XUqdBf9fNOQIvxlh
	gjdKsMv3dONKpxZOV5vfrLltPR36en/fR2PvaM1bpyi7xjO3MFPC2r0Y0ONncvbe4wPwVM
	CinfN4LVBtJXianexy0NdNgGG5bYVO8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hCGUwl5E;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2198D60621;
	Mon,  2 Nov 2026 17:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D29A1F00A17;
	Mon,  2 Nov 2026 17:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793640471;
	bh=leKsCN/AW0CIMV0Z58FExykl0a+UkP/KW/e3nsnHLQM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hCGUwl5E2q8xC3fuwYjC4VbJ0KmGUnWBIucbBnmAQ1vd3ngEy7yXbM4BCpaxwfXNj
	 IhAZLA/WXHfX9ARMw69lYseQ7Vc5+vSFUh7v+FhlXPadvqEAr2T9l+RQI1sK8KSBM6
	 PseChT1NMSI3bz7QCXmm5cSTyDOiG6BIlu/XVPuQ=
Date: Mon, 2 Nov 2026 09:27:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara
 <jack@suse.cz>, David Hildenbrand <david@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Krystian Kaniewski
 <krystianmkaniewski@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/filemap: stop fault-around when the walk steps
 back
Message-Id: <20261102092750.e53073b2c7b872f9d70c0711@linux-foundation.org>
In-Reply-To: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
References: <20261031-jf-mm-filemap-map-pages-lower-bound-v2-1-21029744e589@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F009C1C000F
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: w5nubxnw3rf11geu67ne7sq7m4wy5z8z
X-Rspam-User: 
X-HE-Tag: 1793640472-951023
X-HE-Meta: U2FsdGVkX18T11nZOHEF6B6ggTbId+RzYFZSWzWYXMPl3kDu+UQfO6VqqkKH3eWkWMbPx2ZPEuIfKiFYyrCXEUFIWGchUV1pIEjXV4xoxvfLvS+hILS6/p2FjzDvwa0Z9IW+t/MGLStHYkStjQm6KKW22b+OW4matTCUJ/3qxJVtL+CwG1hOAWUTeqP5m0Ztt/x/Y/U9OdEZHVwQDJaDmi2/9G8EN+lccjt6hC7BNirOD2azgpLQARlv3WV08foBnyTTJokDmsRKrtd5/y337w0IYQkxCur7JGenNFSDBGL+adDgbIC9qugKS4kEyNPI+5Z1dhBpzEoA2tlS+VMNSMnH7xI00jovvFKg/MtREOT3Axx3rM4rldCPUBRbfZseh2nAivnBdfWMGXn2FTMOwAxif2gXdNRrSGKMaQ++S/vfQ0dlgaThCVUIPKfVi2sBZ/j3vZeu8xBwrhYUfVQNAHni0QzKdIcu+6IJfquSn0qCVQ3KgHloHFgzDBSmWdpA48MMYj557gbvOetCKyDRlm6QdmiUhIWqgun7BzUPsfmNDXUkcFv8rR2DbVei8VzsP+QpPplm6/u4KT1curALw9Q9JnjXXtrWdLPbtNCPUqHHxyp2BMoM58q0fu5yIHaCzYdpyqONQG3CAU51fZI8VF+XjhBOOO40xG2HU9Y1YAOJ83WMzajRbWcP807F2QIcdv7pXRnQJjN5YU67RRTmeN93z82V2TCmIFec9bRGjVIT6qPsjIpSN3prJ/SL9VQhfcWRsryEJBRBanpCQlif7QtN63BjDqYkzcavLsYbmqimV+WQopWjuyzWphxIIwk/srZSxwt0EONnsMypxTuLq9bf8nRprkaU8CH9rU3WeaF47dptWvOV6rjgI54JqTdbpbPBkJAs8ODZy1zvIQCFgLfKApLbRv8hnxOQsttWrGhQ5nZJYPOsnVxMUmLWusznzaF56zAUMJoDjB8+eeM
 d7oSwrSu
 dQrgbVEi3WMNi8OLehBlAH4rk0FZY6A89w2dwxjW012s56vuPvlKUIQKE3X2e0nTU38hjwrFBtr1C7DVPzPs1gVFyiaTg3/7vv++fKq1EqM9LZf4gnl46s1uEKmmO2K9oAsJflsQLXlATnzjYqOq4WG0KiRj74YdtVXUt0TO3b6awGku5am2zs28ee5Q25Q8WP72hhQr5AIVd/8VE6IA1g6EmKPSY61RVQv+ymX/S6UwQu3nel2Vf4Vp9kFNtjxcr0+TwOjKurrPhkrmNMoXBx3t2YF5P3zwEHl5PnAV+k8G2bK0sJFQGpSiKfhx9gQWmQEAr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 04:33:59 +0000 "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev> wrote:

> filemap_map_pages() can dereference a PTE pointer outside the page table
> it locked. KASAN has reported this as a use-after-free read [1]. The
> same path can also write out of bounds. When the stray entry reads as
> none, the fault-around loop maps a page there with set_pte_range().
> 
> Its fault-around loop walks the page cache and moves vmf->pte by the
> change in index. A lower index moves it back. xas_find() can step back
> to a lower index when a multi-index entry is split during the walk.
> 
> [1] fixes xas_find(), but the loop still relies on the walk never
> stepping back. Stop the fault-around when the walk steps back. ->fault()
> maps the faulting page if the loop did not.

Thanks.

Can I add your tested-by to [1]?

> Link: https://lore.kernel.org/20260904121301.200049-1-krystianmkaniewski@gmail.com [1]

"xarray: fix index jumping backwards in xas_find()".


