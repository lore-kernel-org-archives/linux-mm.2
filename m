Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2747E6B25B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 23:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108196B0005; Mon, 22 Dec 2025 18:21:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCF66B0089; Mon, 22 Dec 2025 18:21:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C326B008A; Mon, 22 Dec 2025 18:21:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E42936B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:21:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 866091603D8
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:21:24 +0000 (UTC)
X-FDA: 84248680488.11.5F9A932
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id DE1E0A0007
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:21:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aXe7FVYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766445683; a=rsa-sha256;
	cv=none;
	b=lBxZX8XFmlBHNt+XcnjjFfwhfdIkifwL3KwJHhWfbaLjZW9IfctFWv5AMcG+B3k+P9rqIX
	GONTuPQXrF1Jx0K0D81h3si36HIiWek1VknO4mn6cMWV9jqEPNmjXpF1Eb7u9tBxdfGaKN
	dSzuLyeJSDYiOVTHx9zXNSulg6fHZNk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aXe7FVYi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766445683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oF4mNRX4+646eKhm1rwVF7uE6pVow1It0I4U/zy8SA=;
	b=3uC6MSXOXrcedMIj7yqText+SX+6n9+LvU8gsbbSu3YLLirbik/Urvwt9qQSUzPVpIA7m2
	wUufw3gZhy7Tx+nGMrNsOJIOW07kuwqaVUjKMa/OSHHIZuUnlS3MWCo24bfVwuZHk03PXG
	e2J3hTP+0oWXMev8KUVMyH2fgLVt34E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA12C41815;
	Mon, 22 Dec 2025 23:21:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF51C4CEF1;
	Mon, 22 Dec 2025 23:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766445681;
	bh=AfPLPIAPUMIERCMsImUahHDBvM54AwOISAeBvFuxmYM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aXe7FVYi6NfpMW5sS7HfATIJ9ci/IdbSAeMbUgTyPiLlOwgzfELHJpwNg4uiHnEm0
	 Wp2Fh9zx8shAA/MJYRg5Vys+6xmjDk9ujklAUD1zNOIGmeGOSOfk7iL4GSAzowhLZu
	 HzNj1LuQjhAN+dKsdVlRfk6y4IgeI/8ZJB484GVBzlZdCD2fT3PNB3WdErxpcwvnDB
	 hBzVWU8YIM4h90x1rwc168ceMXao6MmkeWWyVOwvA62HR7YWOoPC7nYIdthQ+hzmUt
	 Qhhnqkzzd9WNiO9VQptVmyw6PZM/zNyDP4C0QXvjbZ0Hg6IslepgKVV8MnwBIm9ToZ
	 TZoYTuCM+dWiQ==
Date: Mon, 22 Dec 2025 15:21:21 -0800
From: Kees Cook <kees@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Christopher Bazley <chris.bazley.wg14@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: Re: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <202512221517.E1B039879E@keescook>
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
 <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
 <A17C0418-E304-43DF-A6AB-0F142D7B8764@kernel.org>
 <lo6fdczvfjb5q44euckxi5thjrply4wqk62ori4slz54ivdswj@3c234g733gzq>
 <202512101736.DE24BE89@keescook>
 <aUf6xwicMCxL28Yp@devuan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUf6xwicMCxL28Yp@devuan>
X-Rspamd-Queue-Id: DE1E0A0007
X-Rspamd-Server: rspam03
X-Stat-Signature: uyf86pn43jbg1ioxcsttr9ogukfg5ugo
X-Rspam-User: 
X-HE-Tag: 1766445682-410093
X-HE-Meta: U2FsdGVkX1/cfdEeaMv3z19L1Ut8gM9gUZGr4etbi2k97lOwUKiPRx+e1DUMbNAdkh2CfH65VRBfQsGiw1yIk56t/zonygjPLyk5Ka2zd+oJxgqTDUo+s8hlKEO66e6qYMg1l9j6h5upQGTWnFwX1HSEPMH2n3xu5R2ywMcWflsXdZUPPgGIsLCC8svYyuqelP2x7o5HfMGMnv1wHDVa25Tv3C9o+3c/gG5WgKca5Vg79AJj3RrIqqSg8lb76eAMA8eHLU/DPbr4BCllrrwRkk1ZRj+fImKhmY/6Ba8/E2K0ZqwIvdNnP/Rf6IqzhW9DTGR6X68Ui1VWnl5akzXZcBD+soPGsseU2NCmdcYuGmYyaXV6p172GJ5Ur0lTtkMCimTic+XBE58LenNOL00fqoK+r0oEwfARsEpUNlAcWH3822z3NoNMzIy9YFzj1GBVAC62qWlFY15iopK42FXdPnsV5M1V4C2Rmlh8DKZmQ9lFPXea3di1/G4qMEC1ecVyuDcv6TYWa4Xq68AgF6r+r6VLkRG6KUv1egiUGmV+FfAWBVlanepSZooarIlowf+9qtDpuByI7izgy9ONFjbK6onWVdfc724C4RlBRABPlUrdaUJzfXJAvoNQKfeqaJtJGM3gG9swWFkOqAJrBF4Ft/IRR00g0YZT2eIDCvBxmUckrBG09lnOH84KVrB64gBvn7aJdr1Uen4rAE32xew4VOJQq/Zjnd6hpukQIGTS96qt/ZpRojDufEsa9eoqT48VJpHnEjFZMZh2fUpgXNvDeoh8+unc1/jSlx/Ho+/5fpvl7U+50dVZ6SzFQ1thZj7YXGEjpQQ59ObhPk551PiPRv+NZJLJpBDHsieAZAHOLR4j94p5rE+S315Lg1lWofvhpnE9AHfSOMcOERnmu7suILDJQtSddHsJroXAVrngGtmLijQzSum27756keLkyOekkzAwGvzcexNY5w6PsD+
 vDEij07U
 np5+4n163njD2DkRyLAJI9oj4goq5+Ba+IYOM95wbDY9XAQvWD1NlTVvJyDl7Io02bG7M7szxsxT70COhtunaANd0WBhYezZB9ZvDq7dOY+wAwYBLaZzye+Swa+vep7MfpVVdTbPcFQptZR9wDzSdlwn/HWWSlOufX2gwZjVImiGXGitJcMfZ/jAoF8iQRcJb7gV5PRBJtqHsBOPZMD1f6WKxmLODRoIVekzcYK2PUfa6sylLTTwymvgx0xVo2Y7ui+xf/kwabcRAk6G2tYViadpMB3sc5o1nHwWi3ZKWlSSlCSdKaYADlW9+ZEgNzSTxnVIdbu0zqb21taRSrKhJ7Ndlg5OMabMyu0M/XneAspcNbKKkvQLRYk8blS+acEvQgNiYTQsnywhA7BBKF7JZB7l/SoiqKSR1/pPNnFr481/F0zg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 21, 2025 at 03:07:14PM +0100, Alejandro Colomar wrote:
> Hi Kees, Andrew,
> 
> On Wed, Dec 10, 2025 at 05:37:13PM -0800, Kees Cook wrote:
> > > > Are there other open-coded instances that could be replaced? This seems like a great task for a coccinelle script.
> > > 
> > > There are many, but I wanted to keep them out of this initial patch set,
> > > to make it easy to apply.  When this one is applied, I could work on a
> > > second round that replaces more of them with coccinelle.  This is just
> > > for showing that this is beneficial, and to make sure that you ask for
> > > more.  :)
> > > 
> > > Also, it's easier if there are few maintainers that would block an
> > > initial patch set.  If restrict the patch set to a few files, I don't
> > > have to deal with many of them.  Once I get used to this, I'll deal with
> > > all of them.
> > 
> > Sounds good!
> 
> Now that the first patch set has been merged, I'm working on a second
> round.
> 
> I've written a semantic patch:
> 
> 	$ cat src/spatch/array_end.sp 
> 	@@
> 	expression a;
> 	@@
> 
> 	- a + ARRAY_SIZE(a)
> 	+ ARRAY_END(a)
> 
> 	@@
> 	expression a;
> 	@@
> 
> 	- ARRAY_SIZE(a) + a
> 	+ ARRAY_END(a)

I think you can add parens which will be silently removed but gain you
the commutative behavior:

@@
expression a;
@@

- (ARRAY_SIZE(a) + a)
+ ARRAY_END(a)

I *think* that'll cover "a + ARRAY_SIZE(a)" too.

Anyway, looks good! You could send it directly to Linus at the end of
the next rc1, and he may take it. If not, you'll want to split the patch
up and send to subsystems after ARRAY_END is in Linus's tree. I use this
tool to split a large single patch into per-subsystem patches:
https://github.com/kees/kernel-tools/blob/trunk/split-on-maintainer

-- 
Kees Cook

