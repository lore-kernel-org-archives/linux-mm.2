Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1030CC79FB0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 17:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33216B0088; Mon,  5 Jan 2026 12:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9D36B008A; Mon,  5 Jan 2026 12:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFA26B0092; Mon,  5 Jan 2026 12:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BEA156B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:50:35 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79B5C5760C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:50:35 +0000 (UTC)
X-FDA: 84298650030.24.33D5CDE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 088E04000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 17:50:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TswksJYL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767635433; a=rsa-sha256;
	cv=none;
	b=bMA1TAPTajI7IdQLndXSvClKgqfMb9aTEy60Xf/uEkr+TPIp6k2Nik1c3hSscn8K1Wiutl
	Tdwnbd5Nghfa7w0/YJi3t0jtbzfwXUSCLC4HRVpmkJ9aw2Lq2VBYAgptNQtww95DEzy+l7
	G2lFZ/dLlMb56Jl428g76taMRy/SrX0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TswksJYL;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767635433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZA6CCATP7JXSwymTybKgyWVLb5lZ4GvxujJNhyiHoZo=;
	b=qvcGCYpjBJ5pfacvYniEodo82ToxR7rFtlmXD+Dsq4lSUmwhof02xVIOzyaXxfzxe0LkTE
	NmHepiaYur5miawzPmIdFK/Ntu+6FoRELPCP3A+0PAHFdkGOH0mHTt7lgcTl1MI4ZSt5/6
	69WwZzIsSebs5DceqNyU6g60UrNH3Q8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZA6CCATP7JXSwymTybKgyWVLb5lZ4GvxujJNhyiHoZo=; b=TswksJYLzzNg6JK3+f7D3OaB6S
	K78OrwHa8T81zYzlxzrNc/7pl76PpINOOyBQ+eo0pTZRkFcYuoibOTsX9u8760nSPCziLrdBC4oXY
	01/iQ0ohvcw4Nismt8cEcfetwTRTqcA80PLJMrim21zKipB4n/lZthBc9IyH136xfzX0tnq0rMh4P
	mkOL+bjIfBBlY83Z+b8NaAe65bw1tXwho//MUrAbhJnLuI/vURhcDxf14QgoLwQABE6omhM4ZC1X1
	9D9k7cmdCzLdKWW20yGqcUsXxM6LIoOM/LMKvqQMPaVYosHTvo8t60s56HjNjurCi0hMUj1l46VPH
	aUxu0g1A==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcoip-0000000AhGL-3zfG;
	Mon, 05 Jan 2026 17:50:28 +0000
Date: Mon, 5 Jan 2026 17:50:27 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Brian Foster <bfoster@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Hugh Dickins <hughd@google.com>,
	syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
Message-ID: <aVv546gOBw8VT-U_@casper.infradead.org>
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
 <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
 <aVvDcEB583Yuolm_@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVvDcEB583Yuolm_@bfoster>
X-Rspamd-Queue-Id: 088E04000F
X-Stat-Signature: 67u4c7uturuh9qsxeu9s1frd5y7akwc8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767635432-684011
X-HE-Meta: U2FsdGVkX19lJGqsmIUfKRBhpLKeCdXCTAD18g6SzPoKUY+mCLQJt0CI2+b5RUA+l7A4ycZEhz4ouseKxNU+L20Dx3wd8z97cqPyV5piAgKg5kWUbq6+G0K65bYGpuEprOPKlW1kLs+f/oC6vqDi5MgKFn+PeQhVk1kxS3Jt2Zum9IMH7RVUOjWIpTRJLoi4z+f+rFurdpzWHTNi3z8G3RU5ChF8pTbAynGkQPQmqRJ0g6MZez1B7pv2+Y7PjMC0Xo1xbRVFw18l8WELfbTbD3wUMNmRT3wMOKe2XZIVtYUkhHXUc57Q3ck8LXOkV9yu1qAVrk5GqwE5V+YoBaKMBmG3Ju0AHcQCeOSyjpLF8DL8jyKZ0I5HO0zsnkim0Mk0IdaRV/FkdKSAJgso3fPp3cQdRFN0qjJNcIj13fOxJvX+SX284KbW/99CSgD239iLyLyvkp4OgpMihDqwgamoWYVcg8P/imjJn/n2kIe1wJuVn4qDtaE6c5dUrn6+hbarLuIMkGHSbM3M/VVp/4vKqe+8rF3WahmhGzMuBGoPgaAqV+Xi3sc/rUMG/19gB2XT5cY9gP/m2lXc4+rKeB6vAigX6p7mrm8mSEEHD1PbGPxYeHqDeswdqtip5rlkjlhge7Mnv1oQr2GVvyw7niBIeffj0hHkE9Xy4w+C5RnUKmzftv2VL3mU8HWqo+6bqST6VQE8aX4ZFJDrGR0YcqYeTcZsrPUpAoe8Afzly5W7Tucz7Pmod1lrRjdJRKmVQrMvAxp6XuyeZLb0p0RwjI7ArXhVxmK4+t42Ac3RhSK7Hem5dc8P42W+Io3e0bFkk9IAeMg8DC+hSMVsEovu81x9PjOlI6vBNibR2N2jixV30Th6HnAntjL19YKyq9m4dOeE+S8k3Xnl6uV67ql1XYrCw7NoaqP+MElgQkHyYu2UOG8VTDPthWi7XoCTR5sp81DOGSa9aM67w/HNq4J2iML
 EWmbbcuP
 nzYUu0p8XifKST8diAFyRl1buho0Rh6TdXxPIqV9SezNex8hAsce9CQj4IkHewmu6eC0m2JtbCmk7kR+2WxzlCN7ekkpbWqbcBiGUl+6aQJbfsiH8w327/SpUkArZ8R/c6T1j0Erb0sJoJJsNdTjgI3/VChKCQHyt8wO12AkrfY81zjJElou9ZSh+MMM7b9RaB4j4HO/CIMs2zlcdQL9kBE5GJ5Lh/5Hfu2d6plrN3030J5aR1fmyIdiIGRkQH7HY7TP0eQ/OgsW8LZPXWEhZIzEuOCH8HTe2eKsP8NNRoDxvVEzgax5kphGzh4f/yw4k8sjQ9RWXtnvoKOcJOjHpEBJoTyeRfyfDLl6Ff8jqxQrDYQo1K53Yo9VynZSFhQN8oWu2K4WLWoLg2LQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 08:58:08AM -0500, Brian Foster wrote:
> Also JFYI the post-eof swapout zeroing work (still pending) looks to me
> like it would cover the swapout time case [1]. That's just if you wanted
> to go that route here; creation time zeroing for the large symlink case
> seems reasonable enough to me as well.

I think we should merge your patch series instead.

