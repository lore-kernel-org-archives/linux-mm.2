Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDB4C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 19:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646066B008A; Fri,  7 Aug 2026 15:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F85F6B0092; Fri,  7 Aug 2026 15:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510C96B0093; Fri,  7 Aug 2026 15:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C87F6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:24:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD3191C0030
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:24:36 +0000 (UTC)
X-FDA: 85075450152.20.A35E3F5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id ED5462000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:24:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uu9B6lUA;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786130675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5VJq5U6kHiSqzhst885GpSUCCpzsCb9YiU+hs1onvSM=;
	b=nYuxglAS/+yNHwmBWiM9vg8djNcbMoTnDtHyKo28wIivmhjJ2bA10DKcBBwejSdcp21jpY
	MucPv6C+9DT0zZGNQ6rs7+5Yid1u26sjFuJB3gZ3KcVlNUEst9jCsHJbKUWlKvsOmucbFb
	v0SAGC4I/8f/yXmbsOuM+gLhk9K+fBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786130675;
	b=6fFtZtcPm8520M72fTySf6LgkIQjvAnZVPjJBxUD/XNm7RlgOCy/F9WERRmdebPLIK2oIL
	TZh/37tBgOvt8cHXSjs6svze3xFIc5+CFgkEzdf5WUSDAnsHIUqlWPlYqOIHkv0lQ6sohL
	MBZbblPDLeFPgSdBp6HZIduvkYDhXtU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uu9B6lUA;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5VJq5U6kHiSqzhst885GpSUCCpzsCb9YiU+hs1onvSM=; b=uu9B6lUAwjuXwUqqlvdDuKKqrq
	pI3UjvqqiWGtlV7Sqy/IAc5CUx/Dvjlp5qmp1RaEl4DKAR3f9bzKIzxqczdSsKSgQ34vm41NFVkez
	FxxirexrSzB4p6Bc/tKxsZOMD8dF6t9gKNnPgpk+bY+W1EYKp9lqjuqmEUjQbFjYHDWwWpiDGPU+4
	03K4N4jCACzz9nGGNt7miW2LuNYV31g6xaddGiZrM3gqGYcmEzM4XrbWR8qSjlx2ybn4CrDmOW3nf
	mMKLL6K+521nuxrubYaQGNJQl8cY2YPkBxZgZbMHSd0sxRnkGq71BJ2CtNYt+sgHlYevpR9C1E+qk
	oRo4urJQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wsQB8-00000008fY4-0dvt;
	Fri, 07 Aug 2026 19:24:26 +0000
Date: Fri, 7 Aug 2026 15:24:24 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	syzbot <syzbot+78a7af91b68fc6394771@syzkaller.appspotmail.com>, akpm@linux-foundation.org, jannh@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, pfalcato@suse.de, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in mas_nomem
Message-ID: <pipldkadm5oy4olwticdjqfjz4ccn7jfqo3tdle4n2b4jtfmiq@5ckyybqnyk4m>
References: <6a6c4f18.b1a781d0.210f9.001f.GAE@google.com>
 <6yf7k4fmg4tkbmli6t4qzrk2eiyuuynoc2oimbgaebught2yh5@dspb7xile3kj>
 <cad222c7-0ca2-47ba-a21d-1522384713c8@kernel.org>
 <20260805004619.GA28508@ziepe.ca>
 <5cf3542f-fca7-44d0-8a17-8aa316b1fb12@kernel.org>
 <hg73nwj6fdkqect6xzf34i7e4ki5izjyzb3lz6ery62sq3566k@i7tsboqhsdxd>
 <20260806154845.GF28508@ziepe.ca>
 <ulmrkvrqbxqvri33y2olv6x2xjahb3yuee5vcgaojlxhl75gxs@ihjkaias5kml>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ulmrkvrqbxqvri33y2olv6x2xjahb3yuee5vcgaojlxhl75gxs@ihjkaias5kml>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ED5462000F
X-Rspam-User: 
X-Stat-Signature: 7djqoqpgje3ckw877pzbrne3qkdqrfry
X-HE-Tag: 1786130672-589173
X-HE-Meta: U2FsdGVkX1/IiG/ConXB1fmO6u/K3npnENUnvdBxcwYYGjmdUVwWF0lK+9LYtpNaChgdTjtZ6f7na8ihfnTYXhVbPchudrhQkFPMPzZ0rOJQgOVJPJojeDXY4ADYJ4aV+ALv7WhzvUsJJvCU9bOWZhkI7NLHzFAuPCTr+kHCaGhSLQdqIq3OOfFe43xsARYDIeVLfYWiuGRoRVOT2/U0RXFS6h98M7dBKM2uDZiTF+rxJudNws2fRlzx1WuiRLIx7c1Q4hPoxyBXrWqy/DRynPSspcVe0WDABlDxo5oveucP++4mkaxGtEum+AMibkHaBkisWypmVsZmDKo6GoRvpmB9tpm7p+iZFA7TKXq0cscG6EdXyu7t2b+EEOc9F/3cH77Qwvfl8VQmbV0sM6xTD4JThzgksuXojs+7utzNgb23L3PshP8bGeULayLceAECiXTvuCT1n6lidJWT+iea+2nUltkeOgiCiMVqjmt27NrJo77uOcp0g2l1IaKmogF3NBUjwHrQ5lcXKjqWarpJv/+cZ3VDFfFHYn/UTK4YxxvmTBPsnrxGcGV6Aac7yUo4prOa2AW1CmLAdRtxPozQ4stD6mOMOs4ov+OvVTkJ7v0yTK5sZIzqBYIHMfB9rOGHkBuVKiPZkU+nPR1a/SMiYpRxQBaNHyYy55kaNpsCUVdKD1M2+PZzbTBBbVM2OaDfBkTNx4bGfNX3RM+DvXQIUzx4jWmY663DCgqpMi/iIN2oMjRvqNncgu6iR2Yc54VU61p+nIV4wtmmTdW/+34oPA7Z89M/ic/SYVuhLaLCS9gqBl3ufP5nszSsKZoh7mTdnpVEwiQ1GDcYjLDpuCNKLubcxxOj6z1pIN7rKhezATMqmLQ5r72JwYTI4Gn28Ny6G8zLANwx5WafT4pCV4qKaOcJIaFhwFsaIVH/SyHQiavstDqMLea7jHKX7u5J3C/72SXb+/qpF7hbNXtVvij
 1btSY7Dr
 GeHJQf7WzPmobmElKz9Q1aS9p2fSqyoxXlyPNRe1wZ184WvaVziMaK3iBty2H14xhSYxGDtwkFItWmK7Hy+BTQK2AN/bvt0LTMfiG/qTUIs81qay8NVv0Nd1SQ2u4uMHGPemINapEb9ZTelPnUVkE40ajzkbmdSQpjLqz2MX+ml+dp+VZLhKMUAhm8BZp3SnFZKDsxDipy8cmLPU21uQgu7FlVt8wZx27kHFXzi8InrsJ0lYVCWTvVOJAixwaz6XtB7IQRWCVzlDTUfI8UCmRwUtk2fQR2SE3pBt3xus7/LSo0CHgZ3iLQlhiqPoDj/9k7TuIiNizFf88Yg0xaW9e+F8M43+Y7XCCSihbGjD2FQW0M2gv/Fjd7vwaI1NN8BT7jCx1fTr0+z2GxQ7W6vUkIggq9a1Mr5K2nRWdOs+ZL6v7dvV2Zg0V6X3MAfVI12D7gUlyZzsAGxnhRz6h4qJq9w4Mdceg33Ai0Dsinr5NwYoP07nfgcAXzatlMBqdczTVdRpl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/07 09:19AM, Liam R. Howlett wrote:
> On 26/08/06 12:48PM, Jason Gunthorpe wrote:
> > On Thu, Aug 06, 2026 at 10:29:27AM -0400, Liam R. Howlett wrote:
> > 
> > > @@ -5609,8 +5612,7 @@ void *mas_store(struct ma_state *mas, void *entry)
> > >  		goto store;
> > >  
> > >  	mas_alloc_nodes(mas, GFP_NOWAIT);
> > > -	if (mas_is_err(mas))
> > > -		return NULL;
> > > +	mas_nomem(mas, GFP_KERNEL | __GFP_NOFAIL);
> > 
> > It still feels really weird to ignore the return code from mas_nomem..
> > 
> >  void mas_nomem_nofail() 
> 
> Sure, that's fair.
> 
> > 
> > ? and maybe it can have a WARN_ON
> 
> 
> The warning would never trigger.  If the allocation fails with nofail,
> then you'd never reach the warning.

Upon rereading my reply, I don't think it was clear what's going to
happen here.

If there's really no memory and no reserves, then we're going to panic
on trying to allocate.  So, even if I rewrite this to have a void
function to print a warning, it will never trigger, at that point why
have another function?  Are you looking to document what's happening in
the code with this?  If so, maybe a comment would be better.

Thanks,
Liam


