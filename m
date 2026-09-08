Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75591C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 19:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1BC6B008A; Tue,  8 Sep 2026 15:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4526C6B008C; Tue,  8 Sep 2026 15:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 369556B0092; Tue,  8 Sep 2026 15:41:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF456B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:41:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A825440765
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:41:06 +0000 (UTC)
X-FDA: 85191613332.19.1B922B7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E557440008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 19:41:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JCnIX7pG;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788896465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMIyNwi4mOEbrPioPuMzsrrfZiDIVseBoMCefJk2aEQ=;
	b=MWrfC76KSO/ZqbtRDSBbTFI+c2KxjzV/yNrcM5hm0w+MFZ8GO14/Ftdp/7jWdzrh3MFRgQ
	38uailD/jDj/fEH8GWmY/BftkyjeKxRoklMasuQIX/iUxPV8qRq6k8xlHLOBD99HtpYu7c
	IbjjNqxjq+XNv5/BYjd95NQPRoJTGXY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788896465;
	b=UUoiGSGu7yQmSqmigvb0hXnGO+GGmK2wvGBrTlfPdZkT1pXZByrPX3ggpxOx7CaQY1V1KP
	+6ZD9oZtwhRvdiVz1PZ7dMYyOUCrc2hZB0fLk29uDwoZFuHD6npOzxPa/IZjimdQvXgaEB
	ZthmlYTc8A5aEZtd1oP1WGlSrVd4Go0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JCnIX7pG;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94221601DE;
	Tue,  8 Sep 2026 19:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BACC1F00A3A;
	Tue,  8 Sep 2026 19:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788896463;
	bh=JMIyNwi4mOEbrPioPuMzsrrfZiDIVseBoMCefJk2aEQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=JCnIX7pGgvk9cNWaMNZY3FOn+byzKD3xZYjCqrE/ydXMNjBtitB1WdqVWc+YdUdax
	 5HxL0Gf09cPK7vx/GnHTS9XAGIkZ3cBEA9Qr5OfLGRYskxvueM+Ndo3YQ78j90b6hO
	 ejyg8yqXbqWXqRn7uqX+PZjqQoZsoTqmXjQ2Q/34=
Date: Tue, 8 Sep 2026 12:41:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: david@kernel.org, ljs@kernel.org, rppt@kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 usama.anjum@arm.com, usama.arif@linux.dev, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org,
 mhocko@suse.com, ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v5 00/19] selftests/mm: improve khugepaged coverage
Message-Id: <20260908124102.4c874a8a63e50a1cc90e4bfc@linux-foundation.org>
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ygf9os6rmqs5yh3awuk9bn7mbbu8qm87
X-Rspam-User: 
X-Rspamd-Queue-Id: E557440008
X-Rspamd-Server: rspam03
X-HE-Tag: 1788896464-208130
X-HE-Meta: U2FsdGVkX18O9TU0Qd4O70uEx+bKjs3JPl68qYn0Ub0+yJT8v/NS3DfpEUQ/bE7lz7ItptnTUn81qTfuqlAvSXryWESlQEqd4/6DGrD2JPgEmo2nxwjiZRe6zH0bChHHiuOB+33RSXPfXdD3d5s21iLT6Fm2qGHO58EIgctdMbDRocQ5CdBqjqmguVMTYSxQjfoXfPO6QWk+Bvr02vV+RI8ESg82KMrkm4+nPp3aWlFWqfH+VHxNUDLcfoyGvKkDyEtqNf7NQQg/44icIPL6AchJFUsl1dwEbffzh6RPrWjDWb2/zBLXXF2kHJCFir5gELw2agpBZ3P/FfIe6+5L3LMnVMl/+iRa3I/qyO5rQa0AsrHdoLII20RvDmdcxDyVDeJOIjtXhk2Nhwo//FyPsGFyactpd6PhSZzzFk+uxBuefDnd1cLmAfAfjq5KEf4LzeWP+es0yaTfApMs1Br08phe4qd5th+XChB8/ZFNt3NfI84V96GUtzIbCGs4MMZ1ThzSxZ7Z9xDDHUQGBIgJ8DecQXozEI/e2/5J5N+plwwq1IIQqVOeMgufDw44USwbP6/jKgIonp829RpJBkSjPc5fn55BcYFTM9MUw0X6NgGI65PITwAJ5QMfz5EH19COiMJdKkRDp1g4lfs7QVilWSIPDI6msP64C233MUfwssWhyxg/yhWBqN8MoCrjFeCTgoESpIoLoNL/wtiPsNIw3nEBpajKGvcXGdIiV8dl1JsT9UPzxMjeBLxvSNcyhYmXLxTz1aLro0bPdH4k3X3ywB0YlcKcbUOasAvWzuDC2awZsvgwOtw7D6W1cz14LbrVseQOGB1Ucr2mYbWgm/asdno+3mqoPYsvm47ooKbFFUmoQ7pnNiHKdOTx9r0MIirfGf5LLo/EwL0WU+1t4rHCY0ABtU6w6eGyNu0A6impA5FUW99vB26KsqUpLHwSd6O1Oy5sviWGo5q7z+2ivnm
 skYtaaL+
 UFuSkymAFZRHq7+cRutcemVlqXqOGXXK/q7HB/DqSrnw513Nt6+bnUdPLBDFX72UJ8SviflE73rJ1VsJNJkF5p8U6mIArezLG++WrtQ2bk2YHh5NuqXkj2XH3CIY1/YgnwRBmj+CgkSTsQpTCHO+Mhva3ME/PLwMiQGhyaB96yYkqjfhQqILE8cSOrMGwe0m7ixfP+IMkUC8BbYdemi8SoUUeFgzTkXCMXyB2gKMekAiP0YcLsnJLKNwndhwVxRaStvXZR+V9KvnkjBN+LcmQqMsATgavl38K3vTYg1gWALAkhtKURKcoyIZcIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  8 Sep 2026 13:50:46 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> khugepaged collapses to mTHP orders since 7.2, and 7.3 added three
> selftest cases for it: the generic collapse cases run at one order named
> by -c, with the result detected by counting folios of that order.
> 
> That leaves the collapse path largely untested.  The suite does not run
> where a PMD is 512M.  A folio count cannot say where a collapse landed.
> Fixed sleeps cannot tell "not collapsed" from "not scanned yet".  And
> nothing exercises collapse under contention.
> 
> Close those gaps in order:

Added to mm-new, thanks.

Sashiko asked a few things:

	https://sashiko.dev/#/patchset/20260908125105.1510704-1-kirill@shutemov.name

