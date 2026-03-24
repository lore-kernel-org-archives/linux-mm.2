Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F1CCF532DD
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 05:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0CCA6B009F; Tue, 24 Mar 2026 01:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB81F6B009E; Tue, 24 Mar 2026 01:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE9F6B00A0; Tue, 24 Mar 2026 01:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8026B009F
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:44:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4093E1A1580
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 05:44:14 +0000 (UTC)
X-FDA: 84579866028.25.5CF31DA
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 132621C0006;
	Tue, 24 Mar 2026 05:44:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iB+BQ94t;
	spf=none (imf18.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774331052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=GlNYKkLvSaadM3QgBBGs1nZu/Q58WkldpMNA0wFeQveujjQ9U8otWGsG6RSzZ2h1NEbtOH
	c+oHqa771RVP6ji64jv8MBMs8iUri0cIZMRWFGFSQPQPolMPnv/iBlj0JC2hrB3Y9Mhz6o
	y9MrEaPalylyqN48PPDiABRJutIwlLs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=iB+BQ94t;
	spf=none (imf18.hostedemail.com: domain of BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4a75e1166b7f241dd976+8248+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774331052; a=rsa-sha256;
	cv=none;
	b=x8lRgqK1NfG6mchOFYjQXtiFfD7yl2w3ERnUdC5PzVxkcFSq8S7B/KvYtJNakaRa9j9AL4
	nCeUwK/NrwfLoPfQGXos7hJpueGW7SG99mk77weiVKCqvh4kU5aP2IQQjy0u1INZAYpNZQ
	bQ+CfrafXHPWldudUhiJx/imedUhtos=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=iB+BQ94t6POntYcGmZm0b2BevR
	BvndDgRFojdkEyZc9t1c7bzI0WM0Wj3Xm/EQnMgZcvsWtnRrb5CZSSr+S1wHMN4J6RDlnlTzauFSc
	wbzXnpHc4oVIe0+KQfcFXOE73yIM+4Mz/+SwYuXh2+593bv42/b1h/hPSkGHKTcmoUEf5BAKJyG5Y
	/HaVPYFMOOiDkgiGprR+3GmjWXItALuYDMHxVvNnAG90EIKrHeGw0bJF5eNaKxy7KzV3pzawj6oHo
	/3vfom51sBi1PgxgIPRPLhhwwSv2q7mRxU/sWgpbEWpV7p6dWXqEeq24ahPKXNH4o93FwcyozX6HA
	8HcEoumQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4uYh-00000000cD4-43Ak;
	Tue, 24 Mar 2026 05:44:07 +0000
Date: Mon, 23 Mar 2026 22:44:07 -0700
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
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 25/41] kvm: Use private inode list instead of
 i_private_list
Message-ID: <acIkp0M8NCZs7kNN@infradead.org>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-66-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320134100.20731-66-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 132621C0006
X-Stat-Signature: garr776fh5b8z8grqtar3hwra9m4xsyz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774331051-768620
X-HE-Meta: U2FsdGVkX19mUFCdOWkGwnlBDoYjt59Ad7hEqynkwZjyHB7V09WBmyviKEycxu4gf6ptek0a2PKNqip2m9dulDwrsgkG5gaVrtmcS5BGHQz8l2c3GIKkP4ttEAVjwUh1Lkaj8+ia746Wm9/jfYsM/rfjsGeSMF6maD+7TMo7Z4/5cHtoK2kZ3hZU7o6BeseqmiltW8deJwQGL5JRyL8U8CXDI7qAPCFG4B2JpfhpbiAKO1Mt8EKNzCDKo90Ldqq5mRxCmCR1m7qrwXW+V/9f7+4CMiryM2498p9diAGVvnv2/yL/Svnea93MGP0Mi3DekFqFPri+9Jf51ErSAafdxKiV+3LlOa35AMQHTk1ur2EOR+1SzOYrOIsDZz0Usb7ufjcbMjf7MTpLivcO7c+kLN2485t/XEKxxMJwvkD1n0SC2nSe67WL4Mo3tRuvaDL9unVPZx9uwY2Yh+ONZ/d08K1SLUU6Pe18r9i4oeBjtmxX89dXmyQuy3buedwj/cpCYY3h0ZG2Wd9PFUppdRUeQ4TuAtvwVU5kKMGO3QYJne0k4K9UItnYcvT4z3f8dVxxEr1OYe1NuLjKXquTnpuvUTBYujz9OfiOVXjgbgMci5LEz3E5BUKBRbp15N/8Z4x3hjRTPVNm8fhMtfyDmjUmQo5wxCEhE6dweYVQs1bKUecGJVmB2XILRpzh8LVeqHwEu4fojPcapNNsyMWgfv4pbU/FJptd5kG8scwgMNYF7jMR6EsCJSbhQu4H7NEpkbwzxoiys+mJOYCVvgrEGcREN4ySFkWcrvbsDFaR/MLlnqPGRaYVk95d1jXja54kTYUNbLoG/xrdLNoqPBT3psfrH5A55OCtfvTzTGwmFbwfPWkL2KuujAx+4XD5Jz2S2qnoVcxXfIknuTNizXzzZ9EnBwTF/r2EBl8YdwIW0vp3RBNtfVtrhDVRkBzM/zzJHmian3R6AQicEUk17J5OT+p
 4moctZgR
 ymCiyiP6XDlig0bD2QaYG9U5uJxIhi/YfT/0i7SwsQDU5p1Ig0IGAm0mw4W/e5edAVVnMVyI3NyaL41An9VvCsvEHNCj6f+yrUSk7gbV9Rle+WD73aX3hlYm15fGh8eH0LneDpmXFRhcCxxUQImcdS+nAfkY42Hl7Pv/1XguqwC1PIFmPqw5JMf1OaVBMvFQIOOZPcy8PKKeasVklH903Ja77fwUqvGbo6bU3y+TFUbwb4gXG1JccR4V1uPI1z5gCCI2hPMyU1J3mRjgPNFdo1cinMejfl8dqQPFTIHZSAm9TWG8qqrzwrlkvZwUxiAURjn85Au1MxRQ5H7gDKkkWoPOZeEHEgZQY7QwRFeH9azfL7tbwzojl+kADZybXmCZ3WMXsM1wsTu1X0qlsOZV/QexnB2Wj8Jdso8mQPO+OQ/DO0Nhlag3/QC9DaUfzQvmDuyITrIuju+GFUTr6qIah+3jbJNouqqqUdFXy+3LBrGWhzIFCbu0qzwQeOFi+jQjNVWQs5qFRluCfnFEaLk4se0nd4w2DL+dQLQSsds9WyUKiUJV6mSVyBkS3Iz3zOIUJ3UWN1yNfhJ0jVQ8WrnLZT8VIGH512adKUoXVCg/pguJbPDousZrvovv7qhnLBQ8pFSjZcjD98obBhZbtkiwQEryAarowb1Tg8BYukUmw9LzmyMhPDUVokY6SEOuE8KvKQ9QgOeVPG1KT2Th/KWpeEjdPKZ2fanv01DCWDDI/cewHNVCnAMnG6cQpZ2JQNq6HINxosNMXcDynLtovVEDRQNtp6wiWGJ7xpHxvUs8YyH8sTTHGAmVYhx8W9UEUvcOWTikMjopiTaaND2Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


