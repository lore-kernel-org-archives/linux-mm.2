Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE71B103E166
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8C36B018C; Wed, 18 Mar 2026 07:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA9C96B018E; Wed, 18 Mar 2026 07:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBF516B018F; Wed, 18 Mar 2026 07:41:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A569B6B018C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:41:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41C4559E26
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:41:16 +0000 (UTC)
X-FDA: 84558992952.04.88E4B00
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C642B1C0003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:41:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qEzVkat+;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773834074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQ8MkqEsKrVdCQ9govDMyEZ0IN5SlmXcdUBBNXTui9E=;
	b=QqGNNyq1L0FTVd9wbsUYEwo5NlAfUnyhevxBu/m8aJZuXpEve5SDPV+gVTvE9m/DX3Ovj2
	Z0czyTpTHAaB/vuTEXk4m85DD6GsxVLEAZiR31IUeL8eBoXOmMNyt8rIuu4CU0PrIEhklC
	pIny2AGvwQJ73/YCv0ArS4LBOpounko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773834074; a=rsa-sha256;
	cv=none;
	b=oMpcKuNKJFvvJ/K+MxfCLbIXofThHVRT1XdkQKAaNFMWSxuh7qPMHiyG9SpTJZl7RiixyA
	nlMbNysH+VZEwV02mDacsq29B+lSRX9lM0gXmCJDN3TSa9Sf21mhUU8QMeAtBuB67FMPJy
	02ZHpbf6flAb3A4tf16r0rERcTK820I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qEzVkat+;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DA53600C4;
	Wed, 18 Mar 2026 11:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659B7C2BC9E;
	Wed, 18 Mar 2026 11:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773834073;
	bh=nQ8MkqEsKrVdCQ9govDMyEZ0IN5SlmXcdUBBNXTui9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qEzVkat+FFXzCyXvoV6eGzMGPuWW6u/V/Eji+qDjQfneEHEL5tSwpazkVdPYGvp8h
	 xHTdDwpihZRffG4+u/8XASLEhByyaxi8U6iiGDD/iKj2hBvTx5QWgcrUo230hTc5m8
	 JdxFLQl2C+XdV93NBevFhbS5shJW2qelm0hCzojuakn8vdsHXwT6k36s6Y57WMI5Pl
	 OgiiH6DnsdWu899M5a69kPnrtmWD66jPvFI7R4WSIuzi9KPcSpw+A4n8lixJ3N/KHs
	 qJEmDb2Y20VILWrqIsUtirpmyT+NNmDtKSqeSBsmzaJ7JNK4gxqm8YxvskZLgPdkwr
	 PRRZ3fzsmRY1g==
Date: Wed, 18 Mar 2026 11:41:11 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, 
	Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, riel@surriel.com, vbabka@kernel.org
Subject: Re: [BUG] WARNING in unlink_anon_vmas()
Message-ID: <64b4b6b6-dfe7-4873-9474-5ef980352fea@lucifer.local>
References: <CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com>
 <12501051-98d4-479a-8f10-547b2c08ad59@lucifer.local>
 <9f192045-f348-4341-8a45-867f4fd34a0b@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f192045-f348-4341-8a45-867f4fd34a0b@lucifer.local>
X-Stat-Signature: g94d9h8qx1wq3ecckis4kyshw9atzufy
X-Rspam-User: 
X-Rspamd-Queue-Id: C642B1C0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773834074-664776
X-HE-Meta: U2FsdGVkX19ILk/EBkS8EEad9MwWK+UxVQfFrEj1Lh/7MyLkoybpA2I33Ppk5e5TJXdyHl3OTaKW1bLVvpCYC1kSbjqFQ2/azhoPLX0srifmF1a153OnQiEiO4TYFPBDYa0JyoN6rQY1QS1Nwsg1uE9gqiBR1ECvGow6jIU8wYhwB+J3AYsVG4xyu7KvB0fB6kVDLaeVMVMzgEH+3jeaCFOdX7gax2wgY/xhi7nH0gGMTbCKJsOvBjnf2paTW/rlNmgr8pvTWm3qQvYcFcyVpKDHp9TjijyOpxVjmGCKiRv2LKBehLsxYu8hWsILiqzOYW1AfoAf84MsRSSm0yvUcx8rxwCMhkb+kV8mdkCt+FlST95jHwoZcv/DH+KjDOe2OHp1ySjmL14Z4ZXs3kDTVKm8JxR6wTqhDCq38XjS/+GZmViKxSL9okfms6/KUaoupbbVX3xVH61Kxg0mkKVmPlPZdVCa8eE5LVbbE2m9ZXZqw/nSUlG7J79ZsW6ib4fNWooJXb6hTmfPfQNQ1E18Xd/kctC0Oz4cMSDei3iy37AFVbO0V7nYXaiuZjGicoLUEI9S0HuhpGii+qY2wvnfSFZ3Q3RfYLEG5NC2AKfrCgW8NmodZdsZkYDf0ppvPLHA/qnIZxXyHOBtswzkjcm1cfO6dKSHaCZnaOpKIqJnqnTul99Pajm+20YWzURmBi8gdg9XewBp1E9LuY0O9h88yduR146ZCmzZDCWaZWFKoOstCNG2t6nosdWMn7VtXvpqAJcBhh85Wv53ng6KqOK4jjbQMDducTIdy2oxo2QQrabEmUzNVNlJuFZSm9K6XWr4m1K8jbp5dTZVZoTJrArmOmShRrKurRSibbIW+0D66eomMSqy0yv4D7kyjE0fSeHbr1+Cdijmhs/+FrP1qvfHOKOdLmYy1lS7yek15nJ12AL4YYFj2zy43g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 11:23:20AM +0000, Lorenzo Stoakes (Oracle) wrote:
> > On Wed, Mar 18, 2026 at 06:42:49PM +0800, Jiakai Xu wrote:
> > > If this turns out to be a real bug and there is anything I can do to help
> > > with fixing or testing, I am happy to do so. I hope this report is useful
> > > and sorry for any noise if it has already been addressed.
> >
>
> Do you happen to have a copy of the full dmesg output? Particularly looking
> for where the fault injections were made.
>
> Does this reliably repro for you consistently or is it now and again?
>
> If reliable repro, could you try it with the upstream tree also?
> e.g. https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/ at
> master?

Actually no need figured it out :)

Cheers, Lorenzo

