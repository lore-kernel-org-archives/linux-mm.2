Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83EDCCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 16:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316B46B0088; Fri, 19 Jun 2026 12:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C7EF6B008A; Fri, 19 Jun 2026 12:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF0C6B008C; Fri, 19 Jun 2026 12:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E24636B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:37:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3EA65C2380
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:37:15 +0000 (UTC)
X-FDA: 84897217230.09.DF654A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7E3921C000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:37:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="p3ibT/lQ";
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781887033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6QWpGkczlLJ4MhLharJR+kH8PVfUFb7+AHhbZ0p+ahs=;
	b=5FMLSMGTbzjoC4rSmVnu1D4p9Q89WUl4HmTyESN2b04ayBoZcqh8PRS4LORN1MBkwwdDog
	B/f3snBIKpekgWWsVzI5BCOVq2z2LMRgHSQSyJq7TkYcO9TFbKbojwXESfQEdi5nZ8s5kX
	Q36T58JCIb7+MufV3EqRZH3FDWpAYmo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781887033;
	b=qcX4OnG2eF/luqqNEOtet1uCSvoR4XBhyXlkOLeCB9BxTHoMp+IrKUjS5uEjxBVKA+TJPz
	/0OMkeyAPvgKs7Q5DVMLsCMQFfFO5bPC2odkg2gMiQjJtnO2WhdBpZ5a7naSHDQxjD9lIl
	s55rzNWnlEeMoKFCTI+MktprVZbEFmU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="p3ibT/lQ";
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B90C1601E1;
	Fri, 19 Jun 2026 16:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398861F000E9;
	Fri, 19 Jun 2026 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781887032;
	bh=6QWpGkczlLJ4MhLharJR+kH8PVfUFb7+AHhbZ0p+ahs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=p3ibT/lQEk/afRPBx34FEst4eChNBV9X2Olts0xqKyHS/EesLk27aFgK5V60j6ymi
	 Q1n7X3lXqaUc4Jz2N1WKW4LU1lu+IenhMhuiUHoVpdSMV53kC2tz1cVWqNPhyQSdJ4
	 CZrKaFRe4HtMK5BLdXsLkkKMtpj2kPJnuXVhdGf4=
Date: Fri, 19 Jun 2026 09:37:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Frederick Mayle <fmayle@google.com>, Kalesh Singh
 <kaleshsingh@google.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara
 <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixses] Revert
 "mm: limit filemap_fault readahead to VMA boundaries"
Message-Id: <20260619093711.d0d37c9920b3a16394c356a6@linux-foundation.org>
In-Reply-To: <20260619112852.104213-1-ljs@kernel.org>
References: <20260619112852.104213-1-ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 7E3921C000C
X-Stat-Signature: msxdxi3h16ywr3mmc4upmcmurmjbkpif
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781887033-328541
X-HE-Meta: U2FsdGVkX1+w4K51qu/0hz9NyA8i++x5nvO1fLpv/sONdmEVDO/g8XSuzPzLNhXb8Q+XphEFzuGsKptALpiMXTZDUWLiAdLhcRgBquvh89+W/sCZjCDSKu4zIIohueQsfYFwsNX4RcysW/7BCuVHt0kYxNIVur2jxkVmnrzU7dKRL06UUwha/46hma3/wYOGbB20uusEnZ8Pjj237lecqOL8w20PvA09166wqgfnDM6FcZTqt1G9/6pHr/VTQwF/CDEzWOcPFi+1FHJl0ajngCI8xJzMQ/542NWUQ1wI7pxFv12Z29SUuCiFT5wJVpd0fQ3A7sTpEJaohxfo3ri+NFFwcUE07g3spdCRzlnAuW62uZJik3hFDDBc5KAZkqZ+DLrWPSeDqYX78r/i/lYx4zef7l0hk1L9RwXyjvS420nNoRORvmTmCYfszuHI+3WoJJJgswZnM69rZCgUYZR8FnRPjN/95ABDubsCXeeid/Ue8fOoj0oyN4D2WdoEfiMUe2esKNVcE5YWKttLVfgQ/BzqR0sN+aaqBryZ3MG2H6OTZnz+Ol9ilfPSXhCC92Q+mIxGDExU4p4UCYfICM8DSXny7PcRvGR8GxmD/GnT1s0gtQ5lnsVMhcRK1alFUryTRR0rXvHAfoyNj1llOUoAWQBcUZF+te+g41lAdMqCHTAQP/v27XvhrIjmehgXTCuQRxMb3QSnEgCVjuo++88zVOKBrahizCq9vKO+cKpaigOmHpk08CsLLjfKwyDihlGuVUXuJ5WiVUNd5XUNe6jPQP7IiVlw7eXMUNE1DrJqmi+sfoS56Mx5OuJDkKhT872O9si62CaycpKh/vzg/BfReRs2k7Kj8WLYJLvfY5wBx74f4c81iI97fZs7ObxkDL8YMFt+Mfkz8fVLFpEQeelGj2PuvDYd0mcOoZecPL4dBv2ncosQUi6X4jEI+iwhlUwcBok05Gt3dLAI4+nqXs4
 /ny2rKo1
 uT+fSw5GRUQDS25TZzfZbxsq4YirF08Aqil5lp5ELrDOi6AIxGiL52xNT/v+m0RdISzGRFiO7td43srz1AhPXSroNgOGce6stJpLFHgYy0Y/bX6jSfq/RQw7Uk7X6QqD+cqx29/7y77UdZkFOb/g9ggygV9ZRky1p7dIETL3iAJgdm4X8TzePK1qlK/UAFfmP2sVLf6ZaTYwESDZ1l5nH9oN+DEvb9w3GmQewFJuHl0xgC2h0ZoSMVPGa56Fg/aBVsxI7AABthIv4DBg8eMTXMKPJ9DpA+lAzQIpdLNnuGc1TGA9OUhMPh/1qZFHaJNeega/b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Jun 2026 12:28:51 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> 
> This patch caused a significant performance regression, so revert it, and
> we can determine whether the approach is sensible or not moving forwards,
> and if so how to avoid this.
> 
> There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
> PG_readahead on EOF"), care was taken to ensure that the revert retained the
> behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
> filemap_fault readahead to VMA boundaries") only.

I'm a little conflicted here.

7b32f64bc512 avoided readahead of "file pages outside the mapped
region", which is clearly desirable (arguably a bug fix?) and we care
about performance of executable mappings.  Whereas it isn't clear that
we care about whatever the heck that test case was doing.

IOW, the revert might make the kernel worse, overall.

If someone plans to get down and analyse that test case then come up
with a new version of 7b32f64bc512 then OK.  Is there such a person?

I'll park the revert in mm-unstable for now, but would prefer not to
rush it in until we better understand what's going on with that test
case and what can be done to address it.

