Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDE39FC617E
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 18:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1DA6B008A; Sat,  3 Jan 2026 13:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365B86B008C; Sat,  3 Jan 2026 13:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2714A6B0092; Sat,  3 Jan 2026 13:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 145E36B008A
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 13:03:14 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C86CA13B327
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 18:03:13 +0000 (UTC)
X-FDA: 84291424266.06.2DA3BA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 24D831A001C
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 18:03:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CBuBU4gQ;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767463392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Y6YrkEvNRNoWi72KvnYWHt1isHW97aJTz9VSciybaE=;
	b=B5WxQkaUd7jRGtuSWAKVt52YcgLHWmKJxXLsxW7R2nsNa6rpVArQ9GbZpQX3pT2GapTmoW
	JG96I7UMl4muymhQQXNmZX3h4jSMfkCJ5tx2Wl66wfk33S03Um29j3rjuNo/N1VuKmTu7c
	763dRC3Qe4Bczl6Dvejmb+fu0ED7vUg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CBuBU4gQ;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767463392; a=rsa-sha256;
	cv=none;
	b=U5JoR1933pAtEBeyEDp2PNM5XLqRlTCaVTkvU0OW7NS9Fdwc+fZYk5P25UXHh1bDDNCxna
	2O/lzLlT6pFIQLnOLDWFs2xJOgc8g2qYWOIrjP9WVLsSVD+sMosoAM2qdpDqfdTLHR3ms7
	hSWdKcwKYAMXi9CoppAJ3iCJl1V69aQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6E83F60017;
	Sat,  3 Jan 2026 18:03:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E50C113D0;
	Sat,  3 Jan 2026 18:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767463391;
	bh=wjDin5AVThhZYNUvty8R27rS+ed9u1J/ub9S0aOSht8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CBuBU4gQ4AkZBrbUoPRDpNX7SRB7Jc7wspQPnrfo/ldXBoOBchIV8+zxKvHz6Ut6P
	 ec1XLPh2xj3CcWAkOZRDjJh0FDRR1pxWLJR7GUu2bA/k4V4kLq6phPh3HeBnn+9sIY
	 AuOljrHMMdIRPejyf0VkLJs8P40rfOcNbC5SEDIA=
Date: Sat, 3 Jan 2026 10:03:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: david@redhat.com, miklos@szeredi.hu, linux-mm@kvack.org,
 athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
Message-Id: <20260103100310.7181968cda53b14def0455b3@linux-foundation.org>
In-Reply-To: <20251215030043.1431306-2-joannelkoong@gmail.com>
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
	<20251215030043.1431306-2-joannelkoong@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24D831A001C
X-Stat-Signature: uzoo7t8be6b9gpazrs4ecnf63bysucoa
X-HE-Tag: 1767463391-385317
X-HE-Meta: U2FsdGVkX19OBZkZ7BsdzrMEwOOie1RxnqRzluAleuwcHoHBx5N7smRBovkylgI4B1rcb6DgvI0S0dkE6d3fghtCvhIc7db9aF0B33CKuXt5I1CE9nYGHfrHi6xlzeuZk5zhNzMYwLe9+8X81/G+2vxv7CATrzXdIldIX1citeyB5VkXw3n2dS7RXUP7QVdVnEbKZgE6UBkBok5KWCc83SuhQUBOWgjfnBiPP7Y3JL6tMapVo+EIBljytUX+vZKso+q603H7dmTRne3uAwn2rirpiXbZ6eFHnnAfEi2nLgJgvhA3zEEXHeTj79xnPhBEC7Dbe0Dc8IU4Ogsn2CH7K3gvn4P3gL2f05RuaVI5GISAFAExyY8noWStZ1yapgRqA//DWybAGnPA82CxYaFTmxkzLzkp9EoWtpi8kdBlN75kWVzf5vW7fBgZi9kEquK6p9XQtWJm2xaMUlHDsKVN9Qg27GoCXCtVl8VcSkJdVirQMZJFlYLF1DJKiF8Pxp++LpcJ39RsZrYyLUmTgyjl0veG38ja5pImK0p8d6O5t+kL2dimtUyjOvFDurVoG5ljJ/N4N4ZgegRKEArm3I6fOV/OM7SN3NYfCdy+0En2tIdmycJeeNBMWRC7R/t3fzKYKDVNI9pEgsIt1TqSa0Hx1Q5RqP0g9CDDsWBCmwS+zemZXjhlHHNRkE5jlbeTVvWqmZhOO4WkjgguIOyx6SN7YCi6S53Cj06feo4ADyxLUCWaVMCorYgrlaI+aiQ8z6mQvgunoRk+wtmE8YjR0U7Evb3ITAqUIm0kYy6mNKxZtXjmScthTG/z7OVgMYUcvfpAPNJ+XZM6SH6WIpqEwY7iRyirE8FEAIYzVv0tt0sUB/elQypBCf/EZfTcxjIHfi3estvFwJr/msjKw1+lLwXhJGEyuc94QaqoFhjbrbbpg4NTLM/5E/VlMA8abXJx39RrneTx5pVCPYpppX7TcMV
 sAECT7b/
 uK2Mr+DROm5qLVggYPJR7JhFvGUbDk2LML/jkXD+uSTXNNVQjaGfBnUvySmw4mirW3tw4jiwwf0nMs43lzNd8hyFVhILbdu0TUCq+VFWUn5VDWIBpBDJJrFxBfjxUAr7LSL7VLS0zFfpU/C5kjnCIU+0MaJ9FFZCTqAl5Lz3A89no3WPwbohSrIxqK/0KcXV8MIFGRXePErvsJhVQEIiD7ASGRkB2r9ZM028Q0Lz6eF7HjOkurrpXhpZ/5/lHxLa+bYSemk3enUeIsh7BBCRaAX5zoTwyO2Ikal0xE1OwwqsSyRMDWNc31C5KeEW88PNfW51i8RK+L0XhdkLM/x1KUnVxXTD+OqCOpQa66LPXg7n0jrBbIEWBfSrq9TGog+JuODACUvnbde1jM3oij8dpPfOCAPiZT6G9pADGN2NKLlaWc4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Dec 2025 19:00:43 -0800 Joanne Koong <joannelkoong@gmail.com> wr=
ote:

> Skip waiting on writeback for inodes that belong to mappings that do not
> have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
> mapping flag).
>=20
> This restores fuse back to prior behavior where syncs are no-ops. This
> is needed because otherwise, if a system is running a faulty fuse
> server that does not reply to issued write requests, this will cause
> wait_sb_inodes() to wait forever.
>=20
> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal =
rb tree")
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: J. Neusch=E4fer <j.neuschaefer@gmx.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
>
> ..
>
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *sb)
>  		 * do not have the mapping lock. Skip it here, wb completion
>  		 * will remove it.
>  		 */
> -		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> +		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> +		    mapping_no_data_integrity(mapping))
>  			continue;

It's not obvious why a no-data-integrity mapping would want to skip
writeback - what do these things have to do with each other?

So can we please have a v2 which has a comment here explaining this to the
reader?



