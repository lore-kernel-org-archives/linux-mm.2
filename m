Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82AAEE9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 01:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9DBD6B0088; Tue, 17 Feb 2026 20:05:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1AED6B0089; Tue, 17 Feb 2026 20:05:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D306B008A; Tue, 17 Feb 2026 20:05:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3206B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:05:05 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C56813AB70
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:05:05 +0000 (UTC)
X-FDA: 84455783370.18.7642F36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CEC5918000C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:05:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjahZ+Tn;
	spf=pass (imf24.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771376703; a=rsa-sha256;
	cv=none;
	b=LJxhMCiRGT77uOuF9zi1kPwtnmwz6Y+LokriImzkPbde9JH0XNXyDtH5Y05FlFym83gvpA
	ii1UJJmphRRKrW35Vc6DvTPfQf6R3/XTvA0muuS8U44tLrE3JMm756+VLMRAE38MF7LLVj
	2xAKM3XT6NO0mUvQAE8enXovdkeQU38=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GjahZ+Tn;
	spf=pass (imf24.hostedemail.com: domain of dgc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dgc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771376703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgSadJwRIIjm9QTK1gWkTg32HpRgLg2cZ04Hlj4E20Q=;
	b=xDyMgI1AUMtcLa+P/vfBj7vZnXyDo0gUNwL8XlIyYZRwGFhiG/OvWtjhUbhoUf+k6hN0vS
	iycyBzyJ32/HCYb0GyzuXODvFiuLaVACUWKLlI5ZMzcsmZDWUghE1vIe4VmkCQz4tm2N9b
	6BkbERXmmzwzuNtR0VxOJDPg0csbK8s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EEB9600AE;
	Wed, 18 Feb 2026 01:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40116C4CEF7;
	Wed, 18 Feb 2026 01:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771376702;
	bh=IsqEVzhEg6qsCM/MHOX/MCUhJ03tO51uDgjhXK3ZRNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjahZ+Tnj34RwerIUXUtIfq0dwbgYjpFesDdYoaXSQI9Yterjvxz1XuvI6BibwGjh
	 CZXMYjLYEMq1nPyoDDsC4Q0KZb3as1Da5/zYPKkZnIvrkZocbRhUqoEiBAkCnu8oWb
	 5SlgwDP2/9ywE5jjLaCX8Vl+OP0LasrdlsSRwYyYhHm7pW2tVZ6a3R/a8ksafmbxLg
	 jMy3THFxzS2u53AyYI8/Jpn5CBaMJEOjEiMLl1QxaoCF0UdEA+zEnDSkHJcPmnq7cH
	 oo6gyji/OGtE3g4CW3KNETatLFWwLbNB55tJv1RIx3uGUraIr+MVJ+QLWojBsyR3Ua
	 arIF2J1zJUGkw==
Date: Wed, 18 Feb 2026 12:04:43 +1100
From: Dave Chinner <dgc@kernel.org>
To: Andres Freund <andres@anarazel.de>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
	john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
	ritesh.list@gmail.com, Luis Chamberlain <mcgrof@kernel.org>,
	dchinner@redhat.com, Javier Gonzalez <javier.gonz@samsung.com>,
	gost.dev@samsung.com, tytso@mit.edu, p.raghav@samsung.com,
	vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZUQKx_C3-qyU4PJ@dread>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
 <wkczfczlmstoywbmgfrxzm6ko4frjsu65kvpwquzu7obrjcd3f@6gs5nsfivc6v>
 <4627056f-2ab9-4ff1-bca0-5d80f8f0bbab@linux.dev>
 <ignmsoluhway2yllepl2djcjjaukjijq3ejrlf4uuvh57ru7ur@njkzymuvzfqf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ignmsoluhway2yllepl2djcjjaukjijq3ejrlf4uuvh57ru7ur@njkzymuvzfqf>
X-Rspamd-Queue-Id: CEC5918000C
X-Stat-Signature: 51ombu4za89niu4rfgdrypb55yy1gpum
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771376703-870841
X-HE-Meta: U2FsdGVkX1+CwtI/3Ra/Byx+WPjP/cAcjfhBTlIxfTvOnj8HB8zLzxuf04rk2cT8BliiQLAGvmDIYx8BzxHR3WrqFsOr/7e92MdrQqeKQ+hMYf8h4hSSo6IAjeCdoo1QpUXlj2YkfbMw1EU9oAUDa3aRh+Nd3fQ9KMZ/dKSKvCNPlf8d33MQDdF/a02q3mVYw2YvXbyw6OWVyKvKI+8Oh04sV0tNEoNxY40uFSYP8x+clTLTHtVP1djHtcF+qr206SyqLh38gdlGrybS4MWFYAHP7oP0eaXHKI4VywdS1QSaqpwwHTEUg3UAaW4EdzirS8jOEOe2pzyq5TfI5f9nzWc8h7G7RRtCTg6026OA/8fsiNXteJV6xDnTnURiYRJGD89YBTNjyJ2BpWiLYMA4xdDalG6kND5TQ++e82D5qwot0/6szxBlsmrmJm6BcyrqHxPJU5bCjinhdD0leSA+XdUs92DINTEn5zr8PKh6UE9KzcjiybYPpCrMwcMNlwDW6cu3Rqq969qV4bMt4Ar/YvgpaOBaZ1tn2RFjOvmt/6Tkp0gE7LdPR/NUQHmDsksXlCZz38eOJmAUG25z1VrTx3/DvH3b7uEXicm0tE/F6RC79DERfGQ3l/M2GqoSkgpdM/wlgKYOieOdTo/TCstwl4rPqiEydThT6QnC1RLbMfH1EyAuIcJxVmSvrJ/wlrIY/K2TfZlierIM3oky5tRlDkj+YDyqthPAoAYczhMjzDW1h7K4U6Yi0dONYq7VXhLcV6nWCrC0lbTdExaS5H/OFY31Q+SOtB0eefeLtb3ay+2Zm5yDH9kp61Wq85ZHj9EH+rrswffGxpRjzQHzVvMHKsyHN83w79WMYqVigveM7ZlSd5E37CoYEYlpqim4B2QVuFriwgdDSuTtUIEdDQAMnGd6Bxi+yNGAOBiRs+37ZJHwadb9gHHg6GSO063erB4CCZeamGKm7vnS6W5Supa
 GFkUA4We
 dM/1bxk3CElMu+cGW2cgtxJpCGddYhDAtty2+pmYhyA04P/0vhtT51dzgrFjewknHcl5i/CFChLGSZnwkCRpcxlHYAYSn80sGmmgz9VrU/MMWLPq3Qc+lA1jpRjdwcKKl62CdsJ8fpD6c5+teRITYobQGpRgcurLnOws5J/a/xNZE00U7FjUHl7HLXZeESEdHfGhYkxFbkEmVdO65EmRpVbNEGZQ0w0fD1oEnqZCWoz9EBaG8THJrC2VBBkOGsE7RlXeBXwM6O8mUl3NoMHAjm87hrlgBz8W7rwhvSGmuvf8oqfH2vCFB9dhq86Or1J7PQHV43QFQJOzfZ24SGfrQ4kgfHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:21:20AM -0500, Andres Freund wrote:
> Hi,
> 
> On 2026-02-17 13:42:35 +0100, Pankaj Raghav wrote:
> > On 2/17/2026 1:06 PM, Jan Kara wrote:
> > > On Mon 16-02-26 10:45:40, Andres Freund wrote:
> > > > (*) As it turns out, it often seems to improves write throughput as well, if
> > > > writeback is triggered by memory pressure instead of SYNC_FILE_RANGE_WRITE,
> > > > linux seems to often trigger a lot more small random IO.
> > > > 
> > > > > So immediately writing them might be ok as long as we don't remove those
> > > > > pages from the page cache like we do in RWF_UNCACHED.
> > > > 
> > > > Yes, it might.  I actually often have wished for something like a
> > > > RWF_WRITEBACK flag...
> > > 
> > > I'd call it RWF_WRITETHROUGH but otherwise it makes sense.
> > > 
> > 
> > One naive question: semantically what will be the difference between
> > RWF_DSYNC and RWF_WRITETHROUGH?

None, except that RWF_DSYNC provides data integrity guarantees.

> > So RWF_DSYNC will be the sync version and
> > RWF_WRITETHOUGH will be an async version where we kick off writeback
> > immediately in the background and return?

No.

Write-through implies synchronous IO. i.e. that IO errors are
reported immediately to the caller, not reported on the next
operation on the file.

O_DSYNC integrity writes are, by definition, write-through
(synchronous) because they have to report physical IO completion
status to the caller. This is kinda how "synchronous" got associated
with data integrity in the first place.

DIO writes are also write-through - there is nowhere to store an IO
error for later reporting, so they must be executed synchronously to
be able to report IO errors to the caller.

Hence write-through generally implies synchronous IO, but it does
not imply any data integrity guarantees are provided for the IO.

If you want async RWF_WRITETHROUGH semantics, then the IO needs to
be issued through an async IO submission interface (i.e. AIO or
io_uring). In that case, the error status will be reported through
the AIO completion, just like for DIO writes.

IOWs, RWF_WRITETHROUGH should result in buffered writes displaying
identical IO semantics to DIO writes. In doing this, we then we only
need one IO path implementation per filesystem for all writethrough
IO (buffered or direct) and the only thing that differs is the folios
we attach to the bios.

> Besides sync vs async:
> 
> If the device has a volatile write cache, RWF_DSYNC will trigger flushes for
> the entire write cache or do FUA writes for just the RWF_DSYNC write.

Yes, that is exactly how the iomap DIO write path optimises
RWF_DSYNC writes. It's much harder to do this for buffered IO using
the generic buffered writeback paths and buffered writes never use
FUA writes.

i.e., using the iomap DIO path for RWF_WRITETHROUGH | RWF_DSYNC
would bring these significant performance optimisations to buffered
writes as well...

> Which
> wouldn't be needed for RWF_WRITETHROUGH, right?

Correct, there shouldn't be any data integrity guarantees associated
with plain RWF_WRITETHROUGH.

-Dave.
-- 
Dave Chinner
dgc@kernel.org

