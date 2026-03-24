Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42081F532DE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EB06B00AB; Tue, 24 Mar 2026 01:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5ED6B00AE; Tue, 24 Mar 2026 01:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E4DD6B00AB; Tue, 24 Mar 2026 01:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0166B00AC
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:44:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3ED771615C1
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:44:50 +0000 (UTC)
X-FDA: 84579867540.14.4C83F15
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id EFD2FA000B;
	Tue, 24 Mar 2026 05:44:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dEGXd9XL;
	spf=none (imf25.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJSpyLlDxsX0ZK8TeLmNwhtIyO/N8+F7Fznx2ukIrjM=;
	b=TDYvrqreSOsJnjiK84qf3RhivQyfx3gibHUh8trFwnCxTWTDzePx+8UVvGJvn8Ev2qoi9B
	tOs306x4zFSGv9vL5uTqC8WxUDYCHVtJFusK7ssUcRDn7mPSy9d/rA9AF5qwkEdGoYXupB
	E2I7/W9AaA+ulamelYF1Bn6r8jnk0CI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dEGXd9XL;
	spf=none (imf25.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331088; a=rsa-sha256;
	cv=none;
	b=XxurCYbj17Z3p1+27ESDC570tQXzvw6i5hlDXmN1TvXJ0gVEz8G//abzJiOSkTUJZP2br4
	Nirmo/6Xr7eKS2GjwoBm1dXe18DhM+XHLaf2KEvFymuBpGTlFFLvOil6Hd4if9cfJeP0LJ
	+aph+ChYaGBkfkuC0PhpwRWwHESsl/c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=TJSpyLlDxsX0ZK8TeLmNwhtIyO/N8+F7Fznx2ukIrjM=; b=dEGXd9XLuMSNvA3shZW+Yw6uUz
	ljv7S2+TIsFyS4iakEw2OIJnajy67gH9ZTteJDB8uFEyCEuWHY7WCVrTGDrksamMb+F6fTrO4nyGL
	Nz1pFn5RvAFwlXp9EhfejJzhqMOC3FPE5q7A/JDLhmgXYw9Cgcdh9iAqIJmOjSpxv40BqHOhtu/n+
	Y8cm6DHlXB9Ij8LLNJRJ6wG7JWA7xvghX4JhXRumRIB9k6ZSRCwXneAicC8dUrI1XiHZf/03gt6gA
	TCH/CrHPaZr8eDGf3BygnAR3om49oI8lgXrHpKQ3FwoIMGcC6SV0BW9RgjhtAnGtSMidm6MxS1ifS
	OevD0W4g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uZI-00000000cHo-1CP3;
	Tue, 24 Mar 2026 05:44:44 +0000
Date: Mon, 23 Mar 2026 22:44:44 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
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
Subject: Re: [PATCH 27/41] fs: Fold fsync_buffers_list() into
 sync_mapping_buffers()
Message-ID: <acIkzIW07H1UUVvu@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-68-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-68-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EFD2FA000B
X-Stat-Signature: hu585j3ewo96ejz6ezigi8dw45bz4hjy
X-Rspam-User: 
X-HE-Tag: 1774331087-100072
X-HE-Meta: U2FsdGVkX18eWlpC6OKsFEt98gAkToYFWvfc44845RZxyDSBA40D4ulYvAJrB5qEuF7mMMrNUYlis0b1QRBNfuMhgPrIvnNI9f+KDgFyYkhM9wgibq0GTJnAoqKuttCXfztsR6OkrLomPxUh1RzgDJNEjlznNB9T1z3avx5aH8Bf/UkTHCqLXfId8DvnTrScfyqL4NUUguWuowM6k9tlAu15qT7G+HwWFX4tY/+LcC8tXrSaRpZNQM8s35j/sraW6WQdzYsVDv70/GgpCUFaDouAWMNAEcz4K4ADhW61l3+PU0+8Q8vJBT/umBimedBwhj2jc02jFHrXLzhbQEDQytt5KqOnQSUruAok5yQNZOvkbcawxTYQsyiT+UC3dMMp4Jh/eKjF1y2vz0D71lXQA1uyZ2VkWal29Wk80NcuGkvLrpMyqpnb+mg+dDAnktDtGbDx7mvpyMo1A2AcDefV8l2OKS8spNZr343TX0xtAle3u9WPQqCg6S7Ne5r5eE7RV7ShXWfdSz0qTEUEvk5gbBbko7+cCq7N72aPdBp7mpB/96b4UXwXVuTXt1rcex1OhpxgKQvN8sdNhsD+fs0k80NSQ85gfRzAHRVhn9ydX8VjaC83veq45bA3ufJ5bDB/9cv7RcNFCH59JCCXGGNmeo0quQh93SlHCO4IS8TnZX/hkj3iiEVQ3mN9/TY019e1COVzC3Iq+gUP/7jLzTBgpqyRr703h1WdCI7iUe1xm4yBEk3Bu3dz88Jke6Yq/yRPVsD50cWSI3Rw6GVCIpHtOSVw5Lep0ts2fzhmvyZa8qMjBwvctw4ftJ7vp8E1Bcd0nmbEXGfh+Pe6Mf4UKUrwwgakDOQPNcsqdMvZKuH1bUqukD7VReBfi+vyMOcqyLFugnAZ9A5D/KdUVzOJbpIWb1T4u+gP578romkHZ13Dgtum9jvtiRcZGTCwjs7nV3bUL3Il9/QRSENzPuRXmje
 zQsgUClx
 m63NQ0K3l1AFLGUIWfNQ1qKUYzQ1dPvWgl7plVYNVRrkRIqJra5TZxFAkEXF1h0GZ2Y5/5Sh7YNSCOKeYqOfHZXGuE1z8v+GjJIYo+EVu4a+jzJSM4FcqLhMsBFPXBAn7tCczopu9SyfrCum6g6APVfCMdAjvrqiTSXql3o93SfrPr+WuuyS5LtmaTyaMHNaSoBbJ7UV6fuSUQ2LY7oEtsVpqemcBOUPnx41AwHlFL9KTE1pNFJeFVL6sgks5XVMCSwkpX4e9miYFxlwaEIYl7aMoLEW7bQJRkDraVQvHS2yReL2wjYM1uXxeO3TMshCSgUrkLNDSODdE6niEEn41ImLMkX3k1V/DLvgq5YR3jYUDZeSIPZ04q4HkFrdumNm2p0T9jgBBg0zWAgIOo51lJ8JZRy4wRLxGSi0sCjEjr12ropdLp836xl25efWkICePGk31wIYrZyaBeThmAo1t8RpYchUB0JD2q3bl5wj7voJOXn/wL+YXGNjYOwW8tdA0azs/g5sgtrlvImdbnf++zmPlgO0AcynQ/gbsdOAU6wDB+AUwBTEVmryFSuMxbr5R+0Zqvtwp/thjkn66TQsrdMt1jSpLGY9N7GzIBF2/GuYzhMb55j6IZj2QQqKyiGfExqvFI4uKSoFb5Ew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
> -		get_bh(bh);
> -		mapping = bh->b_assoc_map;
> -		__remove_assoc_queue(bh);
> -		/* Avoid race with mark_buffer_dirty_inode() which does
> -		 * a lockless check and we rely on seeing the dirty bit */
> -		smp_mb();
> -		if (buffer_dirty(bh)) {
> -			list_add(&bh->b_assoc_buffers,
> -				 &mapping->i_private_list);
> -			bh->b_assoc_map = mapping;
> -		}
> -		spin_unlock(lock);
> -		wait_on_buffer(bh);
> -		if (!buffer_uptodate(bh))
> -			err = -EIO;
> -		brelse(bh);
> -		spin_lock(lock);
> -	}
> -	
> -	spin_unlock(lock);
> -	return err;
> -}
> -
>  /*
>   * Invalidate any and all dirty buffers on a given inode.  We are
>   * probably unmounting the fs, but that doesn't mean we have already
> -- 
> 2.51.0
> 
> 
---end quoted text---

