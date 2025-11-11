Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD20CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BD778E0022; Tue, 11 Nov 2025 05:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96E3E8E0002; Tue, 11 Nov 2025 05:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85CD28E0022; Tue, 11 Nov 2025 05:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6FBDA8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:01:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38F4859215
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:01:24 +0000 (UTC)
X-FDA: 84097883688.06.04EFC50
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7CE622000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:01:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=MW8BXQRZ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762855282; a=rsa-sha256;
	cv=none;
	b=lh9keA9Jd5hUtMdrJoE+ncGc9SRUbVnUJZEYpaWVs7IuJgr7icyl9c9LQZZ1gzw42uXzgD
	gBJo0FBdM7Igk1oBi8owvT6ZKddfN9bM1lFWDUR5hlBAa3g6YbnWc+dzzOZ3dy0aXttFVH
	aMs72/04OSLH1eYiE5V9A8fK/aT89ts=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=MW8BXQRZ;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762855282;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqzMG8DZM/gvRBtNitIiPBI41Lv4Ew10vO1gkoA+Kjs=;
	b=P8vafYpX3Izj2Xz+e+wNpvJXUb54GwJ6FU90zygfRB6wNWPPyBoeKnRlpPbmzpOZoksD7i
	Y4xJOV/81BZzpMJQyO5wVAUo3rMsbPpvAgg2i/KAW8YCm+r8yfOPtinthiP9ptq3XKPFhY
	DOAytQW4aFRsILEMvXUERjaKWgF9w9A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mqzMG8DZM/gvRBtNitIiPBI41Lv4Ew10vO1gkoA+Kjs=; b=MW8BXQRZWfQCxSkVRaAW5RDNRv
	u1sda6MVQC9abOrzArDC8Tn/TJ0Lsnq3zSEIToxqDk+2Y3hn7b+eNYfnCIbwUlXCj2iIT2wjI/wew
	cBCjS6trY0nXW2EHN2fegFgCawQAJsMgikqLavler34mWIP1rQcTnw8A+1GdCExcvRmhNRc8KvMsv
	1qNOJzokl6uVp9Ybw0BL5rIhQ4k24h8BTs3yqMPybTjBAdjdlfD5wcYREFELha7wTjdS7t/GfB0pT
	gJRegxPM88TCv3SWy/DpaceAnnpzuoH08amxqHgXkDEMvxRFnhOFsiApuvBrXKnLF1ZZDYsq8fPYB
	xbQFpQFQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIlBb-0000000FeCe-2SRQ;
	Tue, 11 Nov 2025 10:01:15 +0000
Date: Tue, 11 Nov 2025 10:01:15 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Christian Brauner <brauner@kernel.org>
Cc: bot+bpf-ci@kernel.org, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v3 36/50] functionfs: switch to simple_remove_by_name()
Message-ID: <20251111100115.GU2441659@ZenIV>
References: <20251111065520.2847791-37-viro@zeniv.linux.org.uk>
 <20754dba9be498daeda5fe856e7276c9c91c271999320ae32331adb25a47cd4f@mail.kernel.org>
 <20251111092244.GS2441659@ZenIV>
 <20251111-verelendung-unpolitisch-1bdcd153611e@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111-verelendung-unpolitisch-1bdcd153611e@brauner>
X-Rspamd-Queue-Id: 7CE622000A
X-Rspamd-Server: rspam07
X-Stat-Signature: jjgsuh8sd8ts5saa8hpey9ub6fwk3dr1
X-Rspam-User: 
X-HE-Tag: 1762855282-288202
X-HE-Meta: U2FsdGVkX1/+NI0Oi9pn1jy/nrBTlCBRSsiiwAuLpDvkyUjtDDqs6nNFBxDEN4ENg7ZSKa7e841AEZDvkY7+V+T+Fpntc5iwNvzF/jxaG47LIdCo/Q94NNAdlc7f90riGcBiKFqy47yUfoMO8VRS/5Hv+GQp0TnN+Qw8NOi4msnZv1apWigI3rwryJNp1p+7dJjQqFjbV/nzB9KiQOoNjrIgS+5I59ay4lQOBXj3WhYe/9LJP21G2KpkcJn83aW8s2e2cwGuJYDkQg42r9ohcR0wr9x+SRmRw7GapoTORFWyXvUKKbTn5IYffIbOxeoop+gWynnCHUxtdKEwWwCmZ2BIDHm8KNn6eRugmYyXGWfxIqXKGDUcamLOCqNyDOvmyZXy8HLtaZX7Z9Nd97o4KEQVHQSvEiu7IJzh9QuOx4hmZwd6E1qbMjGNB3oG9ncqm08Dk836Lb97g6NVgG5hACEgxTMSCdsG2R4PLH86XXygaZ+nqteQy/fasFLeptAs9tm/HUEQAdvRfOi7GxD8HPKJQHlpyYnhLuyRKMo/rgIe9fQ0PJEo1OJC0xQKNLI+aRonYYS+2umeXlRLir5iUCRftZYrEie2+x8PmtAd18cuJ+g62zyx3js4tr+o/ysQ54twBIHYpj72BaxCJ2lhFg+CsGS4WH4FCPMTU1QkVDv4uxPUpY5sYJqN3qaewEhVO3jhleh5W+AZ2p8rCmVarw59c9toJgvGYpnF217XExmDQDl8jWRDaeyNmMQOmiLCfYgM5g9Ft6c/9fJboex9YNVIAdQqjkxC1XRK7fHwVm4C2WFba86h5P7dNv46LNHerW/HeSIPTLBl1WrYALz8/qrX5iYRxRg3COigem3d2PTfmhstJBDJbYw1HAt1WIJRwRH8AHdNb02/Rr/C0gp1kY2/PTapwtxcocZo9EdqOUZc5K8zJpmfB0y4H1njdHxPxP8PigivMT81M6v7PPQ
 g79o8REr
 WL+1LBLu+IfMvIHhlqggG9pAx2K9f7Ph5tg6XvKqVDOgUbzqs2MBmfftPSgTOA9wZe1gztJRA3pgI+5/0eCVgcn5bz5aWRFXDp9rQX5mSMBWNjadscxr+qGYli/YmPcd5do415+Uj1O7QD3CHbynjrxnbkdVmacD3NkPHuAQqZNF3yL1zjRzICVZI5cQdlAFhHTHk3ndwCxRcElJ7N1OdkGjE6763ModF1bhOunaFpa2gR29nZ4m09mqCzcp4D3t3qpjH/WTWtCpVz56ZKxaRRDLtI010kuUuK/8grNm8QTvXG4/oeDJmL1jY3v+eqooOE4yWAvIpEWYLE10fH+j1gt3Tef3XxHtBve1R15IjCAkiJLsle6AQ/saawKYXp9jLRK/YDCXvrQJGfPQMZfgmitnMjRMv9p4NsBIqD/mRLjUETr+3XrUPjCjFaLJ3QbohLWoy5VtK9pxyGwx5seAm+wXA53TZrV/CGqOW5F3g/pIbcDcStkYYq8pe9MT8/X78wSqRhny1WHXs4YCrGj2f2jRWiKmoH68wEsVUfO5xabDWoQ6OM/2ZNC3mQCjiuHpInukC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 10:30:22AM +0100, Christian Brauner wrote:

> > Incorrect.  The loop in question is
> 
> Are you aware that you're replying to a bot-generated email?

I am.  I couldn't care less about the bot, but there are intelligent
readers and the loop _is_ unidiomatic enough to trigger a WTF
reaction in those as well.  Sure, they can figure it out on their
own, but...

And yes, catching places that might smell fishy is one area where that
kind of bots can be genuinely useful - triage assistance, same as with
sparse/cc/etc. warnings.  With the same need to LART the cretins of
"The Most Holy Tool Makes Unhappy Noises - Must Appease It" variety,
of course...

