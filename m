Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA607EF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EF646B00AC; Wed,  4 Mar 2026 08:44:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558246B00B0; Wed,  4 Mar 2026 08:44:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426C06B00AC; Wed,  4 Mar 2026 08:44:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 262316B00AC
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:44:19 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DAB771A0531
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:44:18 +0000 (UTC)
X-FDA: 84508499796.10.4093B2A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 99A2A20003;
	Wed,  4 Mar 2026 13:44:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e26RPWy+;
	spf=none (imf13.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xF3nW5vCC+iyBfuzvDC1ioxG3TRa3zdtOomhQDNrMX4=;
	b=7sK0zQ1U3T+cBf69H1MsD2ij+GIMcJvcuFMPoEkabskfW0jQN4Ikasgj6s2zE6KqhtIFzj
	QC32ZSuT2NzuH3EV9+S3xcg0mXDnTG8IdSoXIfJeaFyk/+ECqClr5qYneL9eECprJpw9xr
	v+iOPnHLhm2NvqdH+qWhQLuv78LLsqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631857; a=rsa-sha256;
	cv=none;
	b=GjFYhpr801mrUqoEtG85VAS7c8mgVCN98Gb/+F0/1TUuFBSpfyTFVjX+OwuNnp6Yts5UHS
	KRUDrHNh8NDViVzOJb9hyZoPt82ZjBw9oJJ1yk51Nic3ffGdtkdAsFOyxCwri7o3BolPDm
	/4WCGqB/AeWQNqm44Eab/k5ZUdAWQMM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=e26RPWy+;
	spf=none (imf13.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xF3nW5vCC+iyBfuzvDC1ioxG3TRa3zdtOomhQDNrMX4=; b=e26RPWy+p372QzL+jnAnKcXN/M
	wiH2eMkftY9mJ4kH7/PqEDDLyQASUDxtKvKcZSJBsI9IapRavsleLku9Je4wUAoAl2On0zT2i710X
	yk25Dcr19xceiZLdFy76P7cxS7b0/cDxSsP9p25uPvGLL2d5K0b1kiNnOVl0VRntIQViwwQ/B47hF
	6Wzhu2fkE29yGMmhLkRrlOlptcw0CxSzXFA8lL7DderxkOUndrseIfKfSz1L5JPgHv6OgjklHpub+
	C9ZsHmyOyq5U+NSxcm+c3OxzDSkcPcBzsLsrZjbkT+Pbx6Uz+vjuzBQz7PhggUbwxiRgViLK665HL
	0tw8wkwA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmWK-0000000HGqK-2Rgh;
	Wed, 04 Mar 2026 13:44:12 +0000
Date: Wed, 4 Mar 2026 05:44:12 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 18/32] fs: Provide operation for fetching
 mapping_metadata_bhs
Message-ID: <aag3LLGJPNAYNeCU@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-50-jack@suse.cz>
 <aagxU5f1AI3y0wrw@infradead.org>
 <4ji4ihp7tzhxr35t2vgnswfskrjnsuo4eys4klblnor2b663pp@x3khuzh7cxhv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ji4ihp7tzhxr35t2vgnswfskrjnsuo4eys4klblnor2b663pp@x3khuzh7cxhv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99A2A20003
X-Stat-Signature: s1h3wt3h5g6ggz1dsqezs1tayjq1436m
X-HE-Tag: 1772631856-948255
X-HE-Meta: U2FsdGVkX18+gksDCAfCLaRKzL6rxGXFXs6ZzQVUmdzCQ/a/ucw0kSHLLfIncWX7PB6ZfMw5WvJ9r50WfKyNYhcMHJOm9sELvwAZCJMCePb0EYvMQUniiDuuM1n7uxmZWCDCf0h07DXDLSHc7NA8aw7uvpLLePaiLNlVJljajnu2joiL8FtcVDmBxLcuEx6LkYu97HpXmtr1HSRZtyWBVv9UWf9EP6GrFSdI46BL+hmxNNNPButIC+plLgG5Yzty9UrvZlRmZ9aZ6rfdgjiYN/JyhDoe77ohLAgTp4jT2btI0Q62cjl3JseD8/BpQWOKvVwhLrr6kqum/L/9sWXh9kOMP4VNbVkBsowPWWU2KuXvNxoQsoIRQh0bwyeXJH/LwMrMgVatKCiQ1LfLQQPFN0kerLYAIc7IboNEGQZpbcdN21/a5vMaMT7wBB1iTo5FsBLqJyrDnRg3Vw9AKXCevEnKHdhOrN4yUQjBVgJuVapGLSOLdx5xpYbvsoCUqTagsq15ap5BpnjJLbV4okQaAng5GxIipcQ1+65TaQrQJjk1p7XV8mEQ8F6euat3gj2xyeixi8NSBDhr1TsnoxigWMPNJ50fPDlZOr7mrVbwIVVJmqEQq0uIzULPqkGd2qJPS8ViV/d/9Txe+h1A0ZrlWx4Y9qkGA08lfFyER/YPPSYyN6DI2VSE4bgaCmD9VYmsdXEhaXCKCmeKUusJHTzpVRxAwSxx7DnX3bKvFK+y/MWW+nmOKrN6h1lfpzdzPRcZiFt9SIIydB37hNmcNdlnPLGfgB2+gQzaVSLG58Pke5pC2qi6Y5boTpn2CKqyQwZTAldzw6F1MgapmoRkuMQZR24QS+AyABLexgrTLF6LYUYdftZLUPje6lPXSgN88bFUlWP3WHA9FSeByH1mdEFi5wdFfTL417pW5FRNNXfvwtxuSYqfhEoT6cFe9Tepp55dTyKaQJUDKb9A0uS4DES
 qIX9xK85
 Pry5giTPXud59DAH/650AEvJDS5TMDu2CCN4fYRXufE8PBQGFjnQT9iKApP27U3ntOBzpqgfBaxLeBe9Vhoh+phOTkPMuDfHnIIsUTGAaFskMkNvF74JPuRIlFBwq3ihPIGEsuxjGb0uHIR7HMgzEIwiAmsRNrAFU/peH1wWCyStg+6DgIMEksjMGCC3Z2e0eWHOpd60nDfnUOR433zfdieD33zHsZ76z8JLEvArk3YEhrPWQb8t1savvwseL5moeVtC2W2kmFEJ8m3YgrcBzFxWN5M6qCcQ/7OibASwiri24hdfREwNd3H9XMULOwhet3Nl8fs0PHjvorRRPJBvCDEnptY+U/cBP+maHph999PkpFxZobjiFMQCe2erLbhRyKJ31fuO2eaqK9xvg3+/fDPFj3Fgli7eo7wai4fHnXoZstE/WpGpZNpQpWpbLS0XsfDXQFWAmRja/oTvBnWTEcKKAHzLoB83TqRTh0Ejkl9s7QCMATvP9VtxD7uzBnqN1Zj9BEZFPZmeWa1EOk6DIDl8vcDGW9dvmpgzK3OviS/QkD/rgujBNYfHvIMx+qRt4jBZZntgV6OuTJmaPiRwxkdrP1HI0rZ8ah7X2coE3FxDZybrIZyVIkZapLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 02:38:41PM +0100, Jan Kara wrote:
> I was looking into that. Passing these to sync_mapping_buffers(),
> invalidate_inode_buffers() is easy. Passing to mark_buffer_dirty_inode() is
> relatively tedious but doable. Where it gets difficult are calls like
> bforget() and most importantly try_to_free_buffers() on bdev mapping where
> you currently have no way to get to the mmb struct... We do have
> b_assoc_map pointer in buffer_head which we could switch to point to mmb
> instead but IO error handling on bhs needs to get to the mapping from bh so
> we'd then have to add address_space pointer to mmb for these uses. All in
> all it's doable but I've decided it isn't really worth it.

I guess a backpointer from the bh list to the mapping/inode would solve
all this?  Or am I missing something?


