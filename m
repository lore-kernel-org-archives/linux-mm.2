Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EF5EF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:42:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7D3D6B00A6; Wed,  4 Mar 2026 08:42:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B245A6B00A9; Wed,  4 Mar 2026 08:42:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989CB6B00A6; Wed,  4 Mar 2026 08:42:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74BD66B00A6
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:42:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FC38BA09B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:42:40 +0000 (UTC)
X-FDA: 84508495680.03.092A8C7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 29E6CC0002;
	Wed,  4 Mar 2026 13:42:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AIuiOEt4;
	spf=none (imf28.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKbslS42HEzdZOw7zPbvYkD46CkZrv82i3vagssvN6M=;
	b=IiHFcVMq7RN97QadTdR/KlTx01yS8bhDstclTzEPqVxyI0udzfN3aRdRC3df/TRQRx1eHK
	eq5kmxNw4L98pggWJovSwPdi1lbI5Nsx3jhUGaC2uUiV6VueMG6lJN3pds6TqqI7EuVgYJ
	Yjkd7OGE6I3rUbAAFtr58XrpVZJO8UY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631758; a=rsa-sha256;
	cv=none;
	b=QnvnVjKOk0u1EuidgSIntLdNIK8nbiyNbyf3IVwEJUZ1lNf3J2weGL1VCd65cOQv4ByKzB
	m4viVwNS0Cp0P6qjaCXZnt7SM209+m/74BgJTRht9pvMWOb91kqiMPucipJXSYjTgUcOYV
	HD26fJZzzLhxK0G5biQsHCeMdsbCZBA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AIuiOEt4;
	spf=none (imf28.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DKbslS42HEzdZOw7zPbvYkD46CkZrv82i3vagssvN6M=; b=AIuiOEt45JuHm/tFitR7YG4fTc
	9U4D54oGLMfswhEFp4xzd+HP6pIT+5bvqVMLBs2Z/JmkEjnEcWhxAGAmG6jgOTCvXFYwX3621GvjN
	LDgkLlPgvsEivdn67XU7/spbOJJkiOg4W0emwCxLnmpk1ZiGnf2zebopnSKISxCh05Dlx8S6/Vy+3
	p1Jjj2W31iRs9p9nl3iSk3HarZQx7i/lYryFavjj7JffWgLXQu2rZ2TxpwlcMBB7jaj79Sj1vZQaX
	kIKwRX2f6eH3HXj8Ux36TSWsUv64sDYYE0tSy/JeJWivTNZMVX6+V1Jd/PVVWGm8RVb5+SPvsxhOZ
	fsaoK0nw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmUj-0000000HGga-2UOC;
	Wed, 04 Mar 2026 13:42:33 +0000
Date: Wed, 4 Mar 2026 05:42:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 31/32] kvm: Use private inode list instead of
 i_private_list
Message-ID: <aag2yYtENaE3SFwF@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-63-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-63-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: f6u47pccmrpuk9mk7zqxm6499w38ohob
X-Rspamd-Queue-Id: 29E6CC0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772631757-630484
X-HE-Meta: U2FsdGVkX18/TYq4np+z7moescNW/AZ3vcb5K0uJZg22S04wqOfHjwGpDbUlIKPkS5bmf8JRNuvsilPOr21h47+ZbZR+kroaZQuGd7tOmD6huXsaiocGVl84+v3HYgiE2tJvclJiHF0doyuMCz2TLUJJM46Qv6hYAZy5Aujprl/a1vVAbndhcZntekaTnUrjEKTvovE2MfixvZfTNEUiUe/okZzdI4Bwv7bSWklt/Q6/8DX06+V9hqk0KnxgdDzHXAKpQ15mzCvEGV9VzgA2Qq4ZhhN4YPPKw30+CsK9v/HkeO7Id3gSMde4rgwzFmoxMfDS1W4XT4EEH/wmzbSuEuY3NL1UzBGcJCd6ph0kuCLUAIr4/5hTFkVJf4jHOK4EfOn4Po/i1sJU8N1qtnxY50p0Xht1UUC6CWz6/bgx8VMsSpxmko4veUF9V4lE9QkDcG3viZ7y7tkOKHKSrSVmDzBzT+Eqj+qdPpeeg0n9QptaypIn0CV/ve2cmiAwHzHUQ95MsuDulEWP65GjApj377+4q6YpAQG0xlmJ94b8bDOK9rSC4Wdvyhf1jR/W3aPm6wDMRBIy4BcY85YKUeU+/7qwdub1m6MjVwQXZ946RjJa9VG8Rn3i2oZ5W5CuEpn/P3jzSz2RTkc/8euTHMPkjM6Fv1gsq42feIl8pZcPp4JJgeWHbzeeTGUNSzvzsVwkMocNanYEnXZ68Sc/S1NIdhW2TUe8bL4shtYOYcQu3hEJiLTsptXhddJAo4QmIXVfDBCYXQGSoWZrSROf02LMZu81fBYeD7fBkSC46S3a30epeyeQuz6NeRNBZbXDng5HWfKc/jfAvNG1CFb8DHbBr7Nxbe0sIiGS+9/n+onK8XCCy18DSIRqutFxVUJoraycLEC76l6hO6OlLM6fMK6Sas13n9nLIst55E71YYFX+5Yc8LRn1mMqOu4keBE845LccV6ilyHeR+enQGgvp5X
 P++PO/3h
 Ok15s7Uhm4Inst6OHU3Hn9Ul8jkhmNJa1+zPc8ILVb4YJiJUTifE0TJaqpa+kCCgh+cOVYfaDic94DZag7ac+F1JuiHpQxXrJXjFRNldwl9IAsc0k4RmqhQuf3UYUyufZKNYOQpXy385/qpUz+/fN9IsK37McKACiu1db8rQHaL8/5AKJBbffdolHMDCgy2/04ixDyFGuWjoUymiIV6d3ILGBwu+ud8jWf7UPbdMTlgQ0ggKiSf/OYs+bhjaTp3SD7fHN2e/5AuVYt6EjMqPPtFNUcbNnNiJevz0pp939Fu9/JlRb/SKuFxbovNCTyh8dXBgC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:20AM +0100, Jan Kara wrote:
> Instead of using mapping->i_private_list use a list in private part of
> the inode.

Similarly here, I'd be this toward the front with all the other
switching from i_private_list to private members.


