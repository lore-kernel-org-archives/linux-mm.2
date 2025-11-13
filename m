Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7E4CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34848E000C; Thu, 13 Nov 2025 00:23:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE50F8E0003; Thu, 13 Nov 2025 00:23:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB1D8E000C; Thu, 13 Nov 2025 00:23:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBDE28E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:23:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FF05C07D9
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:23:45 +0000 (UTC)
X-FDA: 84104441610.17.DE59DFB
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf09.hostedemail.com (Postfix) with ESMTP id 74D80140012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:23:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763011423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i4KsqcYsgbSpdppWewCWdbq4mJ9nnY6s6KHZeX8aNvI=;
	b=6UBbdam6k3buJGcLORg4Y4PbmcPb2+wAVGgJmWUF9/UjNjquTpO89Lss31HHoUHQxofU4J
	RbsOhJanW6spIWsPsUYh4BfvY47whWd+1eePFkai9xEQfYalEUfYqc/NweOu+vrDPNvvQM
	WzVcBJC3hSHfCQfr1kxIpbQEqLclhaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763011423; a=rsa-sha256;
	cv=none;
	b=EDj8vmCLhbzk3IelhBuB5ywCgXdo1Lm+cwyE/KSkK47Qo2HLzA/xT2AS+e7x4yS+4JVTOR
	46AQ5z9ClmqHYFwjkLGPMGA280YdgP6H2WNS/YiY9J3FmFpQ/SgZS9DRvj4sNbi2+RvHlc
	WKomp005tUnqhVDOUMQGI8NiKvaSi0c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 38EF96732A; Thu, 13 Nov 2025 06:23:37 +0100 (CET)
Date: Thu, 13 Nov 2025 06:23:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Christian Brauner <brauner@kernel.org>, djwong@kernel.org,
	ritesh.list@gmail.com, john.g.garry@oracle.com, tytso@mit.edu,
	willy@infradead.org, dchinner@redhat.com, hch@lst.de,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, jack@suse.cz, nilay@linux.ibm.com,
	martin.petersen@oracle.com, rostedt@goodmis.org, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/8] xfs: single block atomic writes for buffered IO
Message-ID: <20251113052337.GA28533@lst.de>
References: <cover.1762945505.git.ojaswin@linux.ibm.com> <aRUCqA_UpRftbgce@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRUCqA_UpRftbgce@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 74D80140012
X-Stat-Signature: hdisyrrj7xb7jp7noq5mmjcxqq4thrc3
X-HE-Tag: 1763011423-962954
X-HE-Meta: U2FsdGVkX19VGDU+LAbE5VA6ogtwKS1qZQe9krWxyQkGA/pk+cgzdMsTUFpVjLlh5+sc8n5BHg+s7XVfV3U7fXnUnAoa+x2DfFJhrQ6F9CktVv8wm3QJd/XWgVNdMIqyxj4O/5U79KRY4VdHxPYjtAHtUAbUupcI9VjiGxgGYv2c1TK8JvlZ3Jxgn8qP150NJEernStRn3kbRueqbKDpWyhmd/5eNCnIBSJt/5mdyTmF3AxvVjy8HHf/bNRUzwdtgibeQ0BPIhmr3w9xLoJHxrpx46HmhBN7cZGe0Zmar+foZHU2RgS3HwWH47OB4HjLMg3iVYR1To6oA6bo0ZOMVrCWbYo9w+BFx5alH5r/eE4va+XdEL0GwFILQbI72TPGyCiTOgvqrPV+7O64VSYB8yfSGVMPKHCZwVa//cctQWe7lW0UdssLoeWyuA/IK/IxGDT40Ym67ixThkktJOpXzNTUDPdZuNRp+XAY1wsoGCVhK8pOQk+X1EhQ8EZCvJY5cRc6gMXzb0cwr3i8bBh4YmwsJFtoJYnHIyAJXAbauIayTnMyx+v9qALIkfhT5LaM7Yd20MuCBxfQL9Bzv7Zzv2E5T/4xGcqKKp7vadSypJT/PW3JgCiTkgD8dsiVBmKDXhzElXwOr1zSowSKWO+fZ9G3tFO9b2q/kJafBb94StESj7iYUFCHtLbkYn6zEqjomtDO+r6LW32w5bxeJm2kgnyIjA/CYJfneJLGk0F4wqsLMi7eqA3sRBaUXPUklaAyB+PcJkwoDcwfdxx89SixC4W27TtIsnXkrkCgXnkKvVKaUvRZX5ByB1qOeU7oxdtTssNXDdqSu2Y2OByshHthLjiQG1KNneotR9aRyCIryPYqJp4l15Y87Be0pRG31hI7irXFTA6uLnqc55x7BEDdZGWQO9ffVC5DAgBb0LsKBeY9V91UOcSSTiUsxO0+bl4XHzfN7sw4MCgpNm8pFGV
 B2rq0Zx8
 nkpVA36TecHRlWtOPuVjKWwq0TwDYYphRjhqUPBj5Me5RNeVEisTqMt9R3UZ5OnuKWciBx1c5n6sGWao4Sa9z9E+jBF3t0+Bz5Z6sXGs4rIYxXRD1PZV2U6riAsKuGF5bxke5EE5NT7x1qVsQPGojgT7j8PxwFLXSIJRp8KpNw6q1zn8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 08:56:56AM +1100, Dave Chinner wrote:
> On Wed, Nov 12, 2025 at 04:36:03PM +0530, Ojaswin Mujoo wrote:
> > This patch adds support to perform single block RWF_ATOMIC writes for
> > iomap xfs buffered IO. This builds upon the inital RFC shared by John
> > Garry last year [1]. Most of the details are present in the respective 
> > commit messages but I'd mention some of the design points below:
> 
> What is the use case for this functionality? i.e. what is the
> reason for adding all this complexity?

Seconded.  The atomic code has a lot of complexity, and further mixing
it with buffered I/O makes this even worse.  We'd need a really important
use case to even consider it.

