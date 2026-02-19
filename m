Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B00FE9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 14:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD51D6B0088; Thu, 19 Feb 2026 09:32:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D836C6B0089; Thu, 19 Feb 2026 09:32:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB9876B008A; Thu, 19 Feb 2026 09:32:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B83186B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:32:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59EA5140592
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:32:48 +0000 (UTC)
X-FDA: 84461447616.08.8EBC7ED
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id 667A280007
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 14:32:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=DEZWVjL0;
	spf=pass (imf02.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771511566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIUfsf8JaxJ48qmG5xnIYm98ylX2DhnMOAxi5mf81Yg=;
	b=C3tiaRB5NycS3D3Wfn89rhPNXtG1SEXllBgBVBHzd11uz8SDMFhcXp2nBy2TFczz/PLwv4
	EWOrbePUv8Th0lfmczy4kttpDJoJUOTdeIZ6u2CQ91zwWRA6t/4LpjUhdsir/qy1kR1KAn
	j9WEKM7RtOhJKR5D+08LegtaA5nnz70=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771511566; a=rsa-sha256;
	cv=none;
	b=02+EZMtn2/qX1cWB36yA6e0yHta3OYqRQVMOFzCjgeaTQymtVxMyDWn+sPi6BgNOmW/Ixi
	sp+CISHRAKNBl/rLo15s4NGJCCbgkQz6OtlT7rsStI3nKKziQ151AAQpluiG34UKUumKY3
	4gcU0e6MYLQM8IE2AgFsf2hb9WuHibM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mit.edu header.s=outgoing header.b=DEZWVjL0;
	spf=pass (imf02.hostedemail.com: domain of tytso@mit.edu designates 18.9.28.11 as permitted sender) smtp.mailfrom=tytso@mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
Received: from macsyma.thunk.org (pool-173-48-113-47.bstnma.fios.verizon.net [173.48.113.47])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 61JEWgXE019467
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 09:32:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1771511565; bh=lIUfsf8JaxJ48qmG5xnIYm98ylX2DhnMOAxi5mf81Yg=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=DEZWVjL0xyfCBeyRW70yV9z+bT8dLBgE3Cr2B2R1FFbqVgTk3+cS79TVtarhMc2s9
	 y5zx36b7cGwjDDPIU1AWw8XobSbXIgAzVzvztzBkdZqcjFJNDQPiWezYsxlg+1EFp+
	 NAQuCoBvWIlevFLqB2dNFE6pFxImmljumqGA8fl4UQfqVke3xPXcQf6GsSGCmPKXmt
	 V4E5dQmrjeAAtwvTwwEDK9wAdOUwO6AYyEr05M2XZ20V4BpFkVWhICt9JfAkvDB29L
	 FNzhu9oZiB2WhB/N+ewidJlIJbLrRavHs4WbMGzOC0EMfOLieSFtmPS+RU1fyX5p0t
	 0rIcr3WomJl+Q==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id A4E16591BA5C; Thu, 19 Feb 2026 09:32:42 -0500 (EST)
Date: Thu, 19 Feb 2026 09:32:42 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc <lsf-pc@lists.linux-foundation.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Memory fragmentation with large block sizes
Message-ID: <20260219143242.GC69183@macsyma-wired.lan>
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
X-Rspamd-Server: rspam09
X-Stat-Signature: h83ykhfcnhcyoj5gkfmg43ugu9p479nz
X-Rspamd-Queue-Id: 667A280007
X-Rspam-User: 
X-HE-Tag: 1771511566-736468
X-HE-Meta: U2FsdGVkX190HL6N89/egwetQMvH95KE6qjKEPumVdOrXexhw2xfx9xFVSgbs96gJaisoVkY/Huefuu2nwy0Q1XuJJKyrWvyRv5Pnz1RhxfrOmCO6VRQ+f9QX5YYVPeG3RULP10yBwFiU7u/F5wj2m4bY5Cbpi/mhVDK2HeHe9Ezffbly3UCyeQ2DqDpmlR8knIOx6OARbrNnqm5Xet6FYyPDg8LEzZNMYw6vjQvsthmHXN+rptuylGlgIJwWG2B4h4feGV7Pk7MmrdDcE5GBIknx7nr+5+hNoeg9f+KjwKK0eEd4OJeTF5aD67nb83IMShDfTT4jBsVIV+1jeFGWATNJO2gw6uGiC4594XcjK4ibOGf0WWBOxBUKOQg/3e7M+WdkrqdSEBfxMrYprmwFa3Goa3fjnSWjX7i6s4RY7G/cYLwc3VnNp3FX7SGaqdPgFoB9wEfFgi3MFbIPBhuIlC99ZMq+mD+/8IViJRIMz7srWFot7h8W0/KYU5V/u2RH6hduGTdHgmypbg6lpk/x9bV3Q/G0ZW4r2b0zS1BSwSBp2sx1zYhx7259I72PgcnV0aVnWhviFBaYGmPZt9h5JmsNuvI6oAOOoofmCTUydRVKNSNgIcs9YkVMD5YLdid0qc+/NWnrD62/nXvbHIOIN//F+17a3wSe2tXmOlVxzHnDVJcT+WNzHByOikryjA6cn8b7vDdxKq3rBM2gYfxLYSE+p+z+ZnYVjypsyk1fzaE6ycCpbAmY02ke+zB9QsoBgUVMmKR5QiA+3N39AIe/sL5gi6FIsLAzFxwwQ7LlTq2GUXs4HMVR16wf/2lk9h4Q5VR1+lHUgYZSJFGwak9Lk3O00Zze2okUiv9NvMAJM++fXfCtLVkJy3PBUmj02yfz9Q9yI1Yl6o2UcQb/klKhtuqYBhQCTNybtSO6vpergTkFu5XDEPmyx1HG65Q4cAl1oa3t9L93t4uP2hZLBX
 Z2SS2Zpf
 QPY2ASevZ9TnNSnWwV8iT2bQdRMO7MYSiNqbDP04KznsJLmy4q9c/U/vpnKEM/G2YuRMqMvU5JQEpw15nwKjGVpsBGqir9k3y5qEQLHa0LNjEVYfb125wR9q7xacSDVzljHvMvuOCL5i6LfeVlw+OurdZzPU6gnkl+4jQ6D2Fa/Kni28TZNacrS7ZYNQ/XqN4pkGhQ0hoTJxFL06ta46Ikbn0Ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 10:54:48AM +0100, Hannes Reinecke wrote:
> Hi all,
> 
> I (together with the Czech Technical University) did some experiments trying
> to measure memory fragmentation with large block sizes.
> Testbed used was an nvme setup talking to a nvmet storage over
> the network.
> 
> Doing so raised some challenges:
> 
> - How do you _generate_ memory fragmentation? The MM subsystem is
>   precisely geared up to avoid it, so you would need to come up
>   with some idea how to defeat it. With the help from Willy I managed
>   to come up with something, but I really would like to discuss
>   what would be the best option here.

I'm trying to understand the goal of the experiment.  I'm guessing
that the goal was to see how much memory fragmentation would result
from using large block sizes with the control being to use, say, 4k
blocks.  Is that correct?

So I guess the question here is what are realstic workloads that
people would have in real world situations, so we can do the A-B
experiments to see what using LBS result in?

> - What is acceptable memory fragmentation? Are we good enough if the
>   measured fragmentation does not grow during the test runs?

I can think of two possible metrics.  The first is whether it results
in degradation of performance given certain real world workloads.

The second is whether given a particular memory pressure, the memory
fragmentation results in more jobs getting OOM killed.

	      	      	      	   	   - Ted

