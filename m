Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98287CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 15:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97A08E000A; Tue, 11 Nov 2025 10:07:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F388E0002; Tue, 11 Nov 2025 10:07:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DABCC8E000A; Tue, 11 Nov 2025 10:07:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C92248E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:07:14 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74B1B16062B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:07:14 +0000 (UTC)
X-FDA: 84098654388.26.730402A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B2324140015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:07:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ekN5/IS1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762873632; a=rsa-sha256;
	cv=none;
	b=6J3bi4DLRLpg43ACscivOAJt47cV3DsO+a8E6xPXUiPdva0JxXRqIqeNldUDMDB9WXLqJX
	W3rsT4pTfGZEl2bPjy1dUCXfklPl7g4pk3sMc9SEaTziO0J3mjVFYZ0OisusDm+rvXrpKh
	usMG5jM6wYgzzSbhlbDRZQBWuigsrjk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ekN5/IS1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762873632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VebBs2rmpm86zq1aDYVYAQ1PajTruhyU3RKLChIN6Lw=;
	b=kfkhs3CgacXpch+l6ijnrccwUJPgOTT9PPsvICZRf5HyIC1M/odlt0KDlSe0FSQ8xV2HW0
	Zpi85HvH6FtsLsqS4cN4HnCh8aXQc9YDh1RsmEVD1dRoShMqx1aYCe4p5e0RI1FMFqBceD
	MTWtqQvzJFPPda0/tJdOyU1CIHWyYvE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B639E445E6;
	Tue, 11 Nov 2025 15:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EE2C16AAE;
	Tue, 11 Nov 2025 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762873631;
	bh=rlHZcBpWe3kzEeAH+SDvCuLpDVeld7J3UBzo44DCVEc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ekN5/IS1XAQbOzF2fQaQfGveWiZCAkhBeJC2SZvd/KKW4qzfDu8ocWpq1Xi44C8cy
	 h1qRz3zGTxdOoQu2fnDBWjCcaI3/VayjGrPKrrX7yFC40tzISd1iRjI0i/VoYY0x/B
	 f0KOG/wd98OA+6ZNo/tAhCVTFEC2/Yrm5LztmEW1sC3ZdT7YF/LnQ64ArE/1xOSIcj
	 a7OJyas5ld/LqP4WYoNpMFJYoELz5PYlEG1I5AFwzk+wOQryFMdBBwJLPkGSlAMn9H
	 sUPzn202D71ve+4Y3hYe4FHlAW/K0zW7VsbKv+U23LlqYOWruYR5sdjRGJFVlLRUhC
	 5bOAaWmfyIVvA==
Date: Tue, 11 Nov 2025 16:07:02 +0100
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, bpf@vger.kernel.org, bsegall@google.com, 
	david@redhat.com, dietmar.eggemann@arm.com, jack@suse.cz, jsavitz@redhat.com, 
	juri.lelli@redhat.com, kartikey406@gmail.com, kees@kernel.org, liam.howlett@oracle.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com
Subject: Re: [syzbot] [fs?] WARNING in nsproxy_ns_active_put
Message-ID: <20251111-gaspipeline-getippt-9b19b62f89d2@brauner>
References: <20251111-covern-deklamieren-ee89b7b4e502@brauner>
 <69133407.a70a0220.22f260.0138.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <69133407.a70a0220.22f260.0138.GAE@google.com>
X-Rspamd-Queue-Id: B2324140015
X-Rspamd-Server: rspam07
X-Stat-Signature: kdkuqngbqqy7mhy6pwsmjz4rtkfqpfpm
X-Rspam-User: 
X-HE-Tag: 1762873632-860496
X-HE-Meta: U2FsdGVkX1/zCsgCCuD0SPjdjGdHy7CuUWYNfuP0KgyUjH5qcvchFh1es9szWoQppHElHKm1vmwDl6TqgnJTQu0tcJSuqsZ3SHpgQxn/cdYwAswKzV3ykAZapA5QTWCg95qf7QR+ZHPbkFxVYjKNUVTuGhTG4mJJg/B+rUVONjXhxSB4ywmnF31Q1AXidbYbMhWMgcd0xwCePir1E/otDtZDYnGoxDrEHhrTg2pNtaoVcXifKWu6Cpbv68p6kOy1BhWv87b5+ojNz6+YTOn4mmsSdKVBbytQuf5q0hYBjkhpYxZHRW9FgLCto2LUXGTjlsBM5RPcMnfKVZ8Z0hZgsfF1N48dWdka3y19tDSobjo6DFzzRPUtCZzCNDtlabKjNr/ViwnwnkeXdGuPAHFOWzRz/JyOF59+9Zpp3QU0VfSDm5EYDu95Muf7XNWYhg7nPGW5+RrNDfaJ6z59IC2M9ZDaKyfJcZRVJt/r1/4qJGf0bIgplM/HlG+fcgQq5RK266tZOfn2W9zX9gwM7zbIIh2tLR1ZRN26ZzFTv9eWXKcIoQuMJG+geqgwtawC0EZwpT0akBkhuTmcltXRQuSPh9jdSFGP2IaLfnyWSqTtNjTCzwOuft6xvVQRCh7UGxfQwnDt2Mn8UA062ipNh+NlSSra0RJZVf0nUAu7fZqiFSSxwcnpP/yB98jMJeXy4Spmk/RuRjWTCe3tkoa3YOY2npi9fkKbDXG1Gm6zjDiF0aStk/V6G5QtjdoSO2RS61SP5o39Uh1FQhOQPMQdC9qOL8/h4pxoEz6r7+9RFuP7ZF2e+bjPh2pujZwLhpGGSIBRkGh2IlJT6gsvZDeZglPD7tkL16sVlFoor6xkCPJhCojGV5Bo3Wn8VvXJ0asgXuAEG9FmE/W0gC1V1QxjsVYepTahq4Yv9V9CBWSpXmVmVBHs/bxWpsVFWH9Ie8cvrl9C6WRQ+oQdAuCGsY/P6Yq
 n22YnwRy
 gmixa09j/CYgvZrmF6YXSNRL0hNcYZfOIKy+xKscNAQZpLTyzufMOxmCUC1vFy3JifQXFbfv8ruGQYYd0KKZ66e3ewSflcGDc39mWLAvC28tHRLOYiCqmwA3upOZcdPV9CaLx6DEaoZL1k6QaCCJIfG1g9rnxsRBDeVDTsoF/7su0L2Tkx0V2hRwrrZnYXCI7F+Dg4tLTH/FTdKCM9eYMH/EkETtskMKOOP2cuQhcECbK5JURxrwuHWuddtTi+tFe7fy1oOjG3YvrgcPQk5/7MteBznJq+YusriypBeg4v5W3MdCCMk1IZ+N7xuQBqaRZlBQalDQZUlRYfB1181V5MzuxbjoRWyi3OBQjTS+kEIeoDErEiWDw8wyrgiPGJTtyB9EnLwO3nZkSlwP3wMclAYJTwbQnwM3R4o7NXHxTnURgBl2Oz4+5zN521BpdQ4NrLvrdKlHUaBuU8cWG2G2r9UE5cFof0wxkQ1dnCdzJ9393inNV2sjjVQXQPo+E4ZIpoud5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 05:03:03AM -0800, syzbot wrote:
> Hello,
> 
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> WARNING in __ns_ref_active_put

#syz test: https://github.com/brauner/linux.git namespace-6.19

Groan, forgot the actual important bit after the cleanup:

  * Called from unshare. Unshare all the namespaces part of nsproxy.
  * On success, returns the new nsproxy.
@@ -338,7 +313,7 @@ static void put_nsset(struct nsset *nsset)
        if (nsset->fs && (flags & CLONE_NEWNS) && (flags & ~CLONE_NEWNS))
                free_fs_struct(nsset->fs);
        if (nsset->nsproxy)
-               free_nsproxy(nsset->nsproxy);
+               nsproxy_free(nsset->nsproxy);
 }


