Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4E7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE6A6B00B1; Tue, 30 Jun 2026 03:07:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95496B00B3; Tue, 30 Jun 2026 03:07:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3686B00B4; Tue, 30 Jun 2026 03:07:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 967EF6B00B1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:07:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 115981C2BA7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:07:17 +0000 (UTC)
X-FDA: 84935697714.23.ACEA78D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 412B0C000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:07:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8VSrwGd;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782803235;
	b=WZmAyIrjKtTdgYtwqeMKmsrERfMLr+/C0keqy9KSqxv5o6aJ+Utv0rp65HHTquaOLn/4u1
	oVcAQmPi3EhTnc0gbh6n10VRZGqwyOCH6u7JLRbOoK2/x4UZEa8nfrm5Ady0spS/ZSbG/U
	uiosxmqiXlP9XDTnfylcSd39lkJgK5E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782803235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDsCz5y+7w1jNDwo+8D2q4p3sHLHroeeuG4x4G+LvAA=;
	b=ps7qTWBluDG1SdAbxYYP49Wqp09r+HWT8z7vOdkpD4a3Hj52vymOh1Tpstgfga+E69GKzM
	TVQeLxJ3aW4kyA4aP+cAoOhLVFpwi1krjvDBSdLS0XDo32JsTt/5n0mdjHXS5fXeuZ3Qsl
	RVGbC1PV34HqYqMLu0vXdYraWIIUqbQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j8VSrwGd;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C7BF40666;
	Tue, 30 Jun 2026 07:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BB21F000E9;
	Tue, 30 Jun 2026 07:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782803234;
	bh=LDsCz5y+7w1jNDwo+8D2q4p3sHLHroeeuG4x4G+LvAA=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=j8VSrwGd0XX4/ITZJrTQG/z6cNW+/m2rNHXtEcXl77LvDTHlAwZLAPuErSz+p0Ui8
	 1bPrPROAZCvJFuT6lbPrjL22u6DcAJHFTsFIj0LbrERE7XtnnMueRb2DkFPWgR9INv
	 HyfRhkPO0Kqr/jTcGvwtXoj0w/UXWTyLCg396LLo/zrC/Re72cdS82PR35mHRrzvCh
	 uft/Il7/F8Zs4vCzpzRvFNMhyBxRLRy34mIkSjKjSqERiT3kc9x5JNEPCRD9i8h6s9
	 VEmgPH/Uc2NbnrSuw7uhb1k9HLHv9PF6jvPLTUCFsT3FqY5Pelesy83lL4cCwFhQcM
	 xo25TJFN6myoA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount
 idmap
From: Christian Brauner <brauner@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <akK4CRgiv9G29UiM@pedro-suse.lan>
References: <20260625153853.913949-1-pfalcato@suse.de>
 <s6mr3j7gew2cgerzrvqzenjctctrtnhvlynmcccxb24uszcauz@5iapd6wnbfxg>
 <20260629-sektor-gaben-gepokert-58db0a3528a3@brauner>
 <akK4CRgiv9G29UiM@pedro-suse.lan>
Date: Tue, 30 Jun 2026 09:07:08 +0200
Message-Id: <20260630-zerzausen-galaxie-gelackmeiert-faf65e3defc2@brauner>
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2435; i=brauner@kernel.org;
 h=from:subject:message-id; bh=jqOZxiKqWFL4dZin6A17Mr4lhTs3cQNmTdplb+0bYN0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ5Z8vt6lsgIrN1xQ2N2heOq5fPebDp8y6JM3Z7k1/O/
 7G955FVeUcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBE2M8y/C/JiNmzgWfF8v3t
 oal79uU23xStuXxHMmVN8cuoFgPR9a8Y/jszvdqm6GAscPTOxyjr2ydNU40KqozF/qY5GNvEPnD
 YwQYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: imrcntuqt47pwuqkho3gen6n6zfs7gyk
X-Rspamd-Queue-Id: 412B0C000C
X-Rspamd-Server: rspam06
X-HE-Tag: 1782803235-200000
X-HE-Meta: U2FsdGVkX19CxslEBQx1EKgyUhGLjrByojHllS8w+SaiKmkFecAd8SEWE7fE4jYdEtORwAwjm/qa40wvM3627sL404+K2zgDZHFGnjEXrNu0YaiDkw/ar+4Qx/P4T/paPaf3UcY9wQL2Y/UfC603Vd6uQ/XRekF/3UYrZkCluuFc40fcIuH7LMWwPgAxFdRCFUm2JRFeyF2TzFGc9ADzG0nX02dHVqjPuCVARmDCBm9l9VSztTtSFCh/5Bbns4oa3ZaseqJY1wT4uE3wMHGQ51HWOd5Re0Oo+mVmHh7Iv5x+SPSMAq48JbskCU7nMK3mUiKYGJFNFOSCM8GBxasuZNlA5bxZOWVC/4VYF8hs2n3fP6yLlo4E5LzRn8iasBcCnvGWfwwkf0pmxYYT0P0GpWWClqnPu3/qtDLNQYXR7MAuZk13ZatjwAj+nQOK4rVVdYIrkn1qI2lOWHRu2PBe/CDRDyuosW6I1kJ/InRy0yW02QYXsQjNsQjIsFdDj8cvR5euyRpdEKNBPJWmKM8q4k8bZ+0HkGGFpYvBECW88zKnunIbEGp4z70hh7CBCQpfCtEerfGEwBZ6WOwxhoC06dXsIZ30iQIkAijCa+Veu9hBp3CZ9C3ugtJOnDPgl7QRC2pUQKhp4UDnu5KV4PCB7fYFLuSX2wviI04gZRMU8zKmpu7U8MVf2/dqe/ldrZJdYsOlFDWp8QdIoHqIt9qzKuvhwt9W/Nn2OWjoxJX2H/wbHYKy63hyriSnCjOvzm59T375jscv4fcefrtYyLeH+2bWw090/DHhGX8d+3m8sU5i7C7pFncoOAuNgVWeIZbIl3H2OusBDN+SeX9GtQXxLqnFOcB1iApN3bVRl+qHvgoTDsnY/p0xEl08YFc52CktxE0vkOPsZrmOl6JLmjo2nQSkqB1mX4kW23rEdBottJl39rveAFaLZD58CpiBorMMIPbNOtAuQYN64nx3Sm2
 UvNSXBwO
 cCjb+64JHCJ/FwvkrceojqgcQHGwFg+p+G/rVKPZ5ZMf17QM6RJCKUJDwbxdVgGManclNMlffZs1ZemOqBymQYy9bXVOCRc0Qc/ZWhgwxUV+Zg19PeIXsjK74GrhqNjkNzJeqEZnQWtdOhPw8+/L9qdjP1F99Y1y1WYblrakpYA7vlfvurmIvHti6hz2FVYnlsnb+//ApukuYeqDa9h/oW2dtvRIJMMhYlQB9tR1VxXssKrXzh3wXjYaMiroPsirYaBZ9egvvKFXCWetntNAR7CxTA+gxiQpJ1OQNr+6a7qmQ9/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-29 19:30 +0100, Pedro Falcato wrote:
> On Mon, Jun 29, 2026 at 02:15:19PM +0200, Christian Brauner wrote:
> > On 2026-06-26 16:19:18+02:00, Jan Kara wrote:
> > > On Thu 25-06-26 16:38:53, Pedro Falcato wrote:
> > > 
> > > > Ever since idmapped mounts were introduced, inode ownership checks
> > > > (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> > > > done against the nop_mnt_idmap, which completely ignores the file's mount's
> > > > idmap. This results in odd edgecases like:
> > > > 
> > > > 1) mount/bind-mount with an idmap userA:userB:1
> > > > 2) userB runs an owner_or_capable() check on file that is owned by userA
> > > > on-disk/in-memory, but owned by userB after idmap translation
> > > > 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> > > > 
> > > > In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> > > > file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> > > > idmap internally, but it does not need to be the case on e.g a 0444 file
> > > > where even the owner itself doesn't have permissions to write to it.
> > > > 
> > > > Since this is clearly not trivial to get right, introduce a
> > > > file_owner_or_capable() that can carry the correct semantics, and switch
> > > > the various users in mm to it.
> > > > 
> > > > The issue was found by manual code inspection & an off-list discussion with
> > > > Jan Kara.
> > > > 
> > > > Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> > > 
> > > This looks good to me. I'm a bit curious why Christian initially (in 2021)
> > > used init_user_ns here instead of the file namespace... Anyway feel free to
> > > add:
> > 
> > Back when this was added only the do_mincore() codepath existed and that
> > was intentionally left unconverted because it exposes the cache
> > residency status. So it was effectively a massive side-channel.
> 
> Hmm. I'm not sure what you mean by this. Wouldn't it be more correct to respect
> the mount idmap (given that a mount-ns-capable user mounted it with an idmap for
> someone else, or itself) for mincore? Am I missing something? Or maybe I'm
> misunderstanding that paragraph.

TL;DR: It is unclear to me why mincore() would actually be used in
containers.


