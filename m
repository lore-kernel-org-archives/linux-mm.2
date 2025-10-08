Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9158CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 10:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ACB28E0020; Wed,  8 Oct 2025 06:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D878E0005; Wed,  8 Oct 2025 06:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E408E0020; Wed,  8 Oct 2025 06:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7F1B8E0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:28:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 715AAB9BAC
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:28:49 +0000 (UTC)
X-FDA: 83974573578.09.A66C746
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf28.hostedemail.com (Postfix) with ESMTP id 629CBC0007
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:28:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="K BzOQph";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=qxtypbvC;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759919327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8s9JwsgCp3XHvfocy4wxTpe9hcmn8+BULhzOHWqui6A=;
	b=l1NAXzxUnYtU81L+mqHhdeK4mBMc4kRrJTH9CRHCXDQzcDZDQRoHPebZ9jhETToD/x+bW6
	k4dx+KA3zXF8glBxEpGt5Q+FIhoS5qZifCokFudranbm02anDcupb8Dtv1WKi2rqrW7GXd
	tnuiFi72ppS7VoOgvyBlua7XRELUfK0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="K BzOQph";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=qxtypbvC;
	spf=pass (imf28.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759919327; a=rsa-sha256;
	cv=none;
	b=m6cIIv0pIkHjQxulc0eqy6WLdaLfBCndWl3AbPesNykpf2y4ni/TsLh8E0ihFMqkops0tb
	Hxt2jsEAFw46pjy5KsHfA1Z5FktKBPaVRg3m1rBzstabGD8gnIM7LOk2p48TF4Ahv7NhEB
	HKEFpdbEA9iBA0+vhhU6tdQ/54LnAFM=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 549C07A0199;
	Wed,  8 Oct 2025 06:28:46 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 08 Oct 2025 06:28:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759919326; x=
	1760005726; bh=8s9JwsgCp3XHvfocy4wxTpe9hcmn8+BULhzOHWqui6A=; b=K
	BzOQphOoeZLiw7TOjjmlGk6nQLgu+Gi/fX0/Seftx0oBYoWU7tndGQPI/WBhV6Lg
	0Pht51ip40jWSXJBIAYbxwCeBRNSIqmInhdgWQIOF0PbEe38nvTpc5Tu13jtsQaM
	A8xbwLSOo2m4dK0maQgmmrW9YQcOL1vumFgklw4wXV5KvjaUiAG2AXbWxkdFJurO
	JDKK4ea65M5nGZ16Iid+vnirZ6kXJRMxhzEzcNjPEAFWXiDLHN4dgkGQn3XCePhq
	e/wvP923bVbpcRGthAJyo4QYm0r+jibl3pAn2nSZGKfr/LT9lDBQAQCeL+5c0NBt
	qlh+y8uvqtObe2xI+AE4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759919326; x=1760005726; bh=8s9JwsgCp3XHvfocy4wxTpe9hcmn8+BULhz
	OHWqui6A=; b=qxtypbvCaMce7vvdfT8394eCBxgXivc12tZMpMndGyJ1Qztxe4Y
	UqTIi1V3y6Rvu7UT2XW/UdI/ER/9+vpQdlgnmZ0EByKQMQw6h5ZNpurSESAfCt7D
	QE/q3pI8kXV9kd1J/7ZsT2SmbCo5gq9gQOqOWskii35rfRE67pUDGCB2eY91IGhl
	Ggcw6sOwwgNvxDSDP8gSVWJR+AnvywLABNoRZCwCOptv+4OvCLWFy1EgayvFjE09
	PO2mVE3/GXp9hHi82IbuLZynSgjItMBFzIrFTkL/1Pi3iyIW/Yb/fP9HmzqM0utG
	WsGOkkAQgXM1qlppy9CKGDKWlvUtAkH2MmA==
X-ME-Sender: <xms:3TzmaAPkWcuFjSO0zURJMYpZ_qul2uY8Orjd9mxyCnyasI2mCK1Kzw>
    <xme:3TzmaKDIWVWG4dBgB_jFjXzBCEDA1YdacOMtJyyrCYWzy_ncvZ6iMr3wKGjVKVk7K
    WnUGKs9g0eUsS55kr5sg7otvsee1bOjqxSCE1PMq5fd3rLxWlK1O0k>
X-ME-Received: <xmr:3TzmaB4EGBH2_-CI-GoqXjywtnXfJetpTZuoBPl7cV8-L2x3WF6sMNCrvjURAw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddutdeftdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhephefhleekgedvfeffkefhteetjeffhfegffduieeuueekhfejkeeu
    geelhfekfedvnecuffhomhgrihhnpegrrhgthhgpihhmphhlvghmvghnthhspghflhhush
    hhpggutggrtghhvggpphgrghgvrdhmmhenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnh
    gspghrtghpthhtohepuddtpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehtohhr
    vhgrlhgusheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepfi
    hilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehmtghgrhhofheskhgv
    rhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhr
    gh
X-ME-Proxy: <xmx:3TzmaE4sl4OHaM3c8yxVyg9_bKsiGyP-CtoECDT4kQVQOQPYSDlRUQ>
    <xmx:3TzmaDRa1OhzGvsAR1I0q3VyJtgLfyK_pw-V5g429YZSbK_C0wzGZQ>
    <xmx:3TzmaM8w1-3blSi23ay6aagdQ5fEyfHfbXNpng7Hgee9WgeFVcGu2A>
    <xmx:3TzmaEaEyKSkMlc9BiJxkvVktn4ZsG1Fw4fqWvrRBfNJDNBobt2Xiw>
    <xmx:3jzmaFyehVO5ipMvNxbrHr-mINfi0cyr2Et4BljQDHZbty_Be-eAK5ml>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Oct 2025 06:28:45 -0400 (EDT)
Date: Wed, 8 Oct 2025 11:28:42 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <bbagpeesjg73emxpwkxnvaepcn5hjrsrabaamtth2m26khhppa@7hpwl2mk3mlc>
References: <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
 <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
 <CAHk-=wjDvkQ9H9kEv-wWKTzdBsnCWpwgnvkaknv4rjSdLErG0g@mail.gmail.com>
 <CAHk-=wiTqdaadro3ACg6vJWtazNn6sKyLuHHMn=1va2+DVPafw@mail.gmail.com>
 <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgzXWxG=PCmi_NQ6Z50_EXAL9vGHQSGMNAVkK4ooqOLiA@mail.gmail.com>
X-Stat-Signature: 8xr38wukc4b7xapn4nr1riwa35d5dz1g
X-Rspamd-Queue-Id: 629CBC0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759919327-293098
X-HE-Meta: U2FsdGVkX19yVwOq5URarKzGE2OuMkHmBiodhK4ydW4wS44FzIW3W6ye4BEs0lErkpjfCCg56o0GT/+KO6TUvIozDEzttziCDbxk9r86c6PjSxFQnSRDAN9Wry/Ble/d2jpfCTyp4xyZLv8qEIJAiEzJ1wGnPEANyZBUG4Fde5RnNvc/MukqM37a1/P3e3qsTroTik1776C2WowXs48rkUbJ46Hm5/1l9DE1bSB/D+qTQrQIIF8URKsLTzlsMP/tigFc0yR3yOd8mYeskpIMKoZ3X5jjKicuiYSEN9/Y3NWMlP6UddxERr46f6X0Y2D3AMQ1k4qEIRYGsO9vhCSSqKLG1MMuR/WzSROU/LLXrkXl3D8tXV9SXEzvi34Anru5PL5JB2DFkX8PhJaGrhqImN0sT8meAx4QKG0zmwB5aCXUW/v0cDWk/J1rS8xuy1LLkelRVWQVkwTjXEHVuIhaqFF/wHD878IkcK0UAqzWao1QIsDG/tbbH7Oi2YeFpo0juy21TFqY60TCNT8OAEUW5MaQGKYXNaPwDL6gllRvsheSyLVkXipixUfsme+pFWA68hUbtRiBO33Lsmfrys9E0nSp4OurdsfBj3xK44uPaU7Ps7LjHmUJCsM8wvcK52i+kJYuYjAxxh0etXbdaGMx1S5llYQa3EMX+Ol1oUD56Km/tQTeyT+AhsxAfVjp9Fj6CitfOODhFuzXBU4RCjQfyDRdwTSLMHEWz9ENH+NNosV6H+munKwY/EIaeXIfo7c3CVKKQtS9I0ANQhF/lZFCMTazS3yYVkYZ+oA+YzpChWzfucRRs8VJTpBVMHtLRuLjnR0UUJcyFlF52lVGDA+Yi5cCCtb9gPyrASlj5svMRI/wTJ2kRwzFNJ1DW91FAWtP8JHPSm5nm06j3cwFwYaXz60cs7Tom47aPW4Y4dW/YuPFN0NByfOGlxR6YcbooVGZjWYlYCg028Mp2D5bmXz
 fSCfyzSF
 iFKFm1rm08CG1q4mhV0z57QqiRJ5NMSFFetVgNah2MMDB/hQiZf/9AAlJ8wS6ayRLfMftjegiZPaoZNfi/tcVHhW+7REB8FbS7gm4NH/LHl2YMq4d3Zxcc/7AwexvG9qSJVKQw9Bx9bcT9f6In+gBs4qAVYumfJVR4NxP/hzLJB/rTTFbm1VXJanAs72ngGKpgoRSosZQ6UMEJyEflP72pocDX/J82LGP2a67rSGDab0bMzRF9eeboBf1HBjSIZvioyVkbhysvm8jzniQK0/bA4DOA53pk2IlH8Ec7ICHtzzZ5FlhnZ1p7/PuEe8MFASliPYmDlT6N0xvfii1/mtQcU5lrQu+b0SX/9PdnNzz718EoUGXxrAdlDqpWNhxi9Iqv7VpXgcjBekx5h84b2ZUb8e6DTUoB75OUX8ukRNAMd9yswpaBJExF4PU8t8DRCVzCT2OlH5D4gmRsLbBXf1iFYEQ8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 07, 2025 at 03:54:19PM -0700, Linus Torvalds wrote:
> On Tue, 7 Oct 2025 at 15:35, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But I think I'll try to boot it next. Wish me luck.
> 
> Bah. It boots - after you fix the stupid double increment of 'already_copied'.
> 
> I didn't remove the update inside the loop when I made it update it
> after the loop.
> 
> So here's the slightly fixed patch that actually does boot - and that
> I'm running right now. But I wouldn't call it exactly "tested".
> 
> Caveat patchor.

My take on the same is below.

The biggest difference is that I drop RCU lock between iterations. But
as you said, not sure if it is sensible. It allows page faults.

Other thing that I noticed that we don't do flush_dcache_folio() in fast
path. I bypassed fast path if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.

>  mm/filemap.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 60a7b9275741..ba11f018ca6b 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2792,20 +2792,37 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
>  	 * any compiler initialization would be pointless since this
>  	 * can fill it will garbage.
>  	 */
> -	if (iov_iter_count(iter) <= sizeof(area)) {
> +	if (iov_iter_count(iter) <= PAGE_SIZE) {

PAGE_SIZE is somewhat arbitrary here. We might want to see if we can do
full length (or until the first failure). But holding RCU read lock whole
time might not be a good idea in this case.

>  		size_t count = iov_iter_count(iter);
> +		size_t fast_read = 0;
>  
>  		/* Let's see if we can just do the read under RCU */
>  		rcu_read_lock();
> -		count = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, count);
> +		pagefault_disable();
> +		do {
> +			size_t copied = min(count, sizeof(area));
> +
> +			copied = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, copied);
> +			if (!copied)
> +				break;

filemap_fast_read() will only read short on EOF. So if it reads short we
don't need additional iterations.

> +			copied = copy_to_iter(area.buffer, copied, iter);
> +			if (!copied)
> +				break;
> +			fast_read += copied;
> +			iocb->ki_pos += copied;
> +			count -= copied;
> +		} while (count);
> +		pagefault_enable();
>  		rcu_read_unlock();
> -		if (count) {
> -			size_t copied = copy_to_iter(area.buffer, count, iter);
> -			if (unlikely(!copied))
> -				return already_read ? already_read : -EFAULT;
> -			ra->prev_pos = iocb->ki_pos += copied;
> +
> +		if (fast_read) {
> +			ra->prev_pos += fast_read;
> +			already_read += fast_read;
>  			file_accessed(filp);
> -			return copied + already_read;
> +
> +			/* All done? */
> +			if (!count)
> +				return already_read;
>  		}
>  	}
>  

diff --git a/mm/filemap.c b/mm/filemap.c
index d9fda3c3ae2c..6b9627cf47af 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2752,29 +2752,48 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
 
+	/* Don't bother with flush_dcache_folio() */
+	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+		goto slowpath;
+
 	/*
 	 * Try a quick lockless read into the 'area' union. Note that
 	 * this union is intentionally marked "__uninitialized", because
 	 * any compiler initialization would be pointless since this
 	 * can fill it will garbage.
 	 */
-	if (iov_iter_count(iter) <= sizeof(area)) {
-		size_t count = iov_iter_count(iter);
+	do {
+		size_t to_read, read, copied;
+
+		to_read = min(iov_iter_count(iter), sizeof(area));
 
 		/* Let's see if we can just do the read under RCU */
 		rcu_read_lock();
-		count = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, count);
+		read = filemap_fast_read(mapping, iocb->ki_pos, area.buffer, to_read);
 		rcu_read_unlock();
-		if (count) {
-			size_t copied = copy_to_iter(area.buffer, count, iter);
-			if (unlikely(!copied))
-				return already_read ? already_read : -EFAULT;
-			ra->prev_pos = iocb->ki_pos += copied;
-			file_accessed(filp);
-			return copied + already_read;
-		}
-	}
 
+		if (!read)
+			break;
+
+		copied = copy_to_iter(area.buffer, read, iter);
+
+		already_read += copied;
+		iocb->ki_pos += copied;
+		last_pos = iocb->ki_pos;
+
+		if (copied < read) {
+			error = -EFAULT;
+			goto out;
+		}
+
+		/* filemap_fast_read() only reads short at EOF: Stop. */
+		if (read != to_read)
+			goto out;
+	} while (iov_iter_count(iter));
+
+	if (!iov_iter_count(iter))
+		goto out;
+slowpath:
 	/*
 	 * This actually properly initializes the fbatch for the slow case
 	 */
@@ -2865,7 +2884,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		}
 		folio_batch_init(&area.fbatch);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
-
+out:
 	file_accessed(filp);
 	ra->prev_pos = last_pos;
 	return already_read ? already_read : error;
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

