Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67364606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=BulVXfD7
Received: by kanga.kvack.org (Postfix)
	id 6E4A06B05B6; Wed, 28 Oct 2026 22:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC586B05B7; Wed, 28 Oct 2026 22:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9B76B05B8; Wed, 28 Oct 2026 22:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 393756B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:16:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D773120234
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:16:55 +0000 (UTC)
X-FDA: 85374050790.26.0B0B8B0
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1F9C680002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:16:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=BulVXfD7;
	spf=pass (imf02.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793240214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9kc8yIzx2usw0N2+/yj9nIikY372WFees0PGb9Zlj0=;
	b=xbHU9TwHYpDPzYv5DbHvi8CQzsHd1j+26gGQRwVXhpu7hX6QTg1PrG8tqKDQOndCRxXPju
	0EZDN6rwqhC003fCCrKk5AP2j7Iw59QR9Cc2s7NpAV+hJUSf5a8EH/YANEuJ3GpIW1PPx2
	S5od1QHBNm+q8ewA8JUg//6/SM72B9s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=BulVXfD7;
	spf=pass (imf02.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793240214;
	b=zuLBgZvVjxDXFS0b9MrBf843lK+gegqootI0CzcpVR5nduK9rC+pTjharbPwp+0fmCaU+o
	430fGOwwcsveaNrsc9niezQa01FgBaQFw2Bip7dvXgT3DY0so/yiOVa1za2KWscgVoEJrs
	HJB1I921qpxx8a4tThtNU+aIA7PBQeY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=m9kc8yIzx2usw0N2+/yj9nIikY372WFees0PGb9Zlj0=; 
	b=BulVXfD773yLT3qc9u1NANNhJ98Vm6/aRxcwh5PfDZELbo1U/FSB2M/85ZgFhlhiBCV2IvuwAM+
	RvNJIsDMBW/NCmIYF/xef7aWde69p7ClT0iqQY7Lu0MjujY1pK8DLGdr5YwRbgqIID1pc8tLx/sQC
	Izh291VahFbHvOu6WEzhVy7BZOfCUnK5ylxT0cAbh9T4j+b6AlTNngiUvXcQvIrA+2rthRivGcZuB
	NNMsNYkt3FtQEZLRM/nlMsVyeOBmfcEjf2loV3mHj5UYVQ8drR+LgID2bwLDoSLvqe8gUgcburL8P
	tIjNocrWc2A34HmdV5jrxW9im4x2We6R30RQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xMFgy-00000008bSP-0k3I;
	Thu, 29 Oct 2026 10:16:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 29 Oct 2026 10:16:36 +0800
Date: Thu, 29 Oct 2026 10:16:36 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Liam R. Howlett (Google)" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>, Michal Hocko <mhocko@suse.com>,
	Baoquan He <bhe@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH 4/4] rhashtable: fix vmalloc() deadlock in atomic rehash
Message-ID: <auKshDXKQXt1kvjy@gondor.apana.org.au>
References: <20261028154218.1668182-1-liam@infradead.org>
 <20261028154218.1668182-5-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028154218.1668182-5-liam@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1F9C680002
X-Stat-Signature: 9pc48wdtpgp4r4jr7zeoied3kuxkq7ne
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793240212-500032
X-HE-Meta: U2FsdGVkX1+iJTADTppqz9mPzYZ1jBbRoGn2MsPoxF326+grsRC31BMI8tgHhNNHqmu3+0PLH8FFrrhiOH4wVakOYfgaVBB6YgI7h0uKOaPsB2pqIuVEOsFbdD9+DIxTCFwyVXWQmsN8IyI29Z0yvZgBvKyYWiYXgfUmDIDtOmk1emPak+q6rW/IejFQmEpLzNFm9anFHe2iLWTJMOyuHvH0xhd8/fGCI5eeX4QKsTxO1M61I1dreaocc8thTCH72dKU5ZSksLBK7VH84ml5LsuOB18BEXMEO7NPnN2HYWmgatz0QkTqdo0JftCZ1A1uQhgL2FZ/S1dpcqth3a/gJyV6FMzIUnCnk8KiFXtAFaqCuoc0bCgG846OTFPvkhHU0gvC1XViM730AGUE4jvbpRoT3Yb6H+86VSJoA5m5wyEk3NaOxsW/KvSZdjNND3hzw09tw+FWc27mzO1zU6bFf6XgnTA5pEW/VZViq3x6pkunBeXp8nz4mm08L9/Vo/z/0cYd3ObYSg8PSNV6tCJDSymeyssYm/yr/x6MRAjs758Z+lTu7JUZnDFVFa9qEWeQULL7CvugDYd0MPSzJq+esElt87VRuPncVb5IHPZL98V89tVe6EXfsOhNeJgU++299HkxIkjt6eCmgCxTyfE5ce0KVluJLHBrJd6UNwN+75yB4uYUqS/eE520WVl6UVsmarboXW/ip8RZt5VtnRRA1rxkmtybR8fvx9ilCIUdQ1xvyYgagmJpvqDkoYUgtKRnXKon24lxlTKY6Ld7e6BWVNwpyqSe2ChJWna+5WyNSp58Ogzk90dhT9Co+5xQTKsevrixORXbM2jEbPqiJOYv67Rey5Cx5IzC8Jp4GV7sas911204pdY9tRnaMMcFOK38kjWpgU5s8qSj1VHzqY07Kfjjmp3f5hUKlj7jOj7w0VHZLDYJMxZyarRnVuX7aXpdlW5v7R8TmX54vYqLJg1
 sBItbCHi
 uNgflLtOJoF6rpz4ULYU+sxPZa6+Ax1aAgffwEmvbj22q9OKiOu3PYu+8oYYgKYBih3gSBHwFhU5XHPvlroQMcJl05Me4qyOeGgLDIucF35gYF+tEZyZz9HJg4UzzPkxVTopq7wEsRQqpkSxwcLSW8+rc7rKnQse/xxT3Dpo2UN2UsI00I6WfRdmzkv69k6JcF/rGko5HJ7wF6xiJgctDAiz2MTUKdG7awJcQpugm5COlUUu8T3vHS/cAuii04QD9dawgMhUyND00Ywm3OoQkoEGLur5ZjFvFo3/DVczr0fmwvhqlswQmth98zyx7Q2QFBGBZizqlEltgpSwS0bLXn6m1FB1fr7sCXouynZ/cUCg7IfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 11:42:18AM -0400, Liam R. Howlett (Google) wrote:
>
> Below, one CPU adds an FDB entry for an RTM_NEWNEIGH netlink request,
> while another CPU is inside vmalloc() or vfree():
> 
>     RTM_NEWNEIGH                      vmalloc() or vfree()
>     ============                      ====================
>     spin_lock_bh(&br->hash_lock)
>                                       spin_lock(&vn->busy.lock)
>     rhashtable_insert_rehash()
>       kvmalloc(GFP_ATOMIC)
>         vmalloc()
>           spin_lock(&vn->busy.lock)
>             waits for the other CPU
>                                       softirq: a frame for the bridge
>                                         spin_lock(&br->hash_lock)
>                                           waits for RTM_NEWNEIGH

I think this is a fundamental bug in the kvmalloc non-blocking
support patch.  How can it be used at all if it is susceptible
to such dead-locks?

And if you can't use it safely why don't we just get rid of the
broken kvmalloc non-block path and have it always go to kmalloc
like it did before?
 
> Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")

BTW, rhashtable patches should be sent to linux-crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

