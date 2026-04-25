Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D5FFF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 11:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0196B0005; Sat, 25 Apr 2026 07:36:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951026B008A; Sat, 25 Apr 2026 07:36:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866966B008C; Sat, 25 Apr 2026 07:36:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76D306B0005
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 07:36:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05966C0975
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 11:36:10 +0000 (UTC)
X-FDA: 84696874500.03.A30FDF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 523AF40002
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 11:36:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VnDWnThi;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777116968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=se+D9YsWCc9lUXfHZhB0Hfx+IKBLN9gbacYEJImk0Ks=;
	b=gLYTtQtHb0ciM3a3eTPQmXykocow16jTxcHq9Laz2skEIv6BJ6Mn6YxwGI9Kiruow7Niw6
	Vdaoa+hI467E1ZBXrs3HcO3PSYxw2ogqRzJq9TMGqgLt2HY+rjYx3733gX0TLPMZXiy7V5
	rfbtdCRd8qQo2Ys3v6dvZWhKVL4olXM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VnDWnThi;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777116968; a=rsa-sha256;
	cv=none;
	b=pvkOrtnVZ4u28OtamVztW7o/PeggLCgJerdq/kFsi0pBPgYBH+W1DThXPDRVB2Uc6RwbDt
	jFgsEl8WYnLcSGeuCe5a4ZahonwHo73jEpapKA+lLjGTbiowReJgxHOcZ/HhBgm1gsEBWU
	db2Jz34pvcZdppjD/evLh7UGPyiMSgc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BB1660052;
	Sat, 25 Apr 2026 11:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F8FC2BCB0;
	Sat, 25 Apr 2026 11:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777116967;
	bh=+hCqOamL0vTewGf5qbkEKRyELe5agUwAhP+vk48QZYA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VnDWnThi7x8C/ChyqkphLKT4CN2qhjn4bgVZRT3thU06/8VKJp4TXxTLKdd3W+/gI
	 lwBurUwV1KTJLClJZCp62a4VPQyRP74hQNi50rzs+q3ioi2wUC6M6N4Cy28yLlKsn/
	 tf044FWTbVqbl6W02n8H+OfPCTeQdT3tULq6Wgbg=
Date: Sat, 25 Apr 2026 04:36:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Lance Yang <lance.yang@linux.dev>,
 peterz@infradead.org, dave.hansen@intel.com, dave.hansen@linux.intel.com,
 ypodemsk@redhat.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
 arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com, roman.gushchin@linux.dev
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush
 sent them
Message-Id: <20260425043605.a3a1819fb219c649eab0f3a1@linux-foundation.org>
In-Reply-To: <872e752d-c7fa-4a75-a963-4e2f42ce468b@kernel.org>
References: <20260424062528.71951-1-lance.yang@linux.dev>
	<20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
	<aetw4aoABYj3keMh@plex>
	<20260424071533.d28ce90126f05e1c6fc1b740@linux-foundation.org>
	<80ab39c2-efb9-4a23-bd56-46d9bb4e41bb@kernel.org>
	<20260424073145.b990fe9b925da304508aad71@linux-foundation.org>
	<644e65dc-3d39-4137-b51f-51d953b67d50@kernel.org>
	<CAO9r8zN1pRfyC0Rh+UdW-Lsret=z3oveT3=gnZftX-Sr_ubyyQ@mail.gmail.com>
	<4e7699eb-e101-4a25-b585-79a777eb7cc2@kernel.org>
	<CAO9r8zO4eSiAK9U-ijzWJMK80XsK+LmFxGAG+nTo+tmK6aLfYA@mail.gmail.com>
	<872e752d-c7fa-4a75-a963-4e2f42ce468b@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4bis4xme1omd8uxrwt17b5dcrd61tsh8
X-Rspamd-Queue-Id: 523AF40002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777116968-577273
X-HE-Meta: U2FsdGVkX18F2KMf2wgWCJgo0FyDR014IFLCbf+hVnmdTTxE0cchXafch2cEBXiqpOczGr5kiHETPfnIH2//5dqq7ciZ29qeYcOzusL4Tu3Rr3Q84yCNWYktZlQWUmOFvNY3YrNnHl0CAdQYUlyaOYTUCftaW8BFNm4Qc2oaRvFl547bh2VTziqoDzW0tNQQwHkKLbVunRgoOfjB0Q/zsWE6msuB7NzdRGhby30eCaULBddaJLnxuAKOAUW8RCOfdBoPPXR/biDzMeZeRsuaen9sDpnwBGbp1JIqMdyky+92JNoN9qETqcucqsK4SPRto7eqPG78x+X94p8B7Wrg73rat7Bw5ADbnzNlwVWV1wP0mZYWlloctkasm3YM/SZ4uwdTAYtsbj3meE9NfEOYTXQ4FUDVJ5/Qf6p2My9xNVBpizSpBT8XvnNN7sdTX8PPPqDV450vk7pCDIWk6mx1/1XXP7yzmvIvLwDx0ubX1rUzGhGNsdn+TGBoBwLAIQgIXeY1ZKbqkD0VQC2A6W8zPaUN0d7omR/YVUbo3T0ujWk1RYpmmPCnvYYoMS+ezWHwFZCqppxpFGCETnG8bIEogUeL8pa5VIWZ7m+szCyX+Ow/mVCCzVxuMElrpMFAE1GsfBuRJgGwEc1LNGz9ACWgxQ3v3Ak0BQtke+UXkIJiutJHNjdkVaJXYLeiFnxF6QqF+VxgxFkQ5GyQPDAPtmGI4sZPHkIKIdRuXOVgJnAzhurSkld0j1H+AN+NPlH6inVmHwPgGEe/XHcRtPxFetZg4CKQHk+VtgqPxgxNzAHNk9FAfbttzXvX1nNcqn//cfxpjtETy67/8IkJZSXCKkT5dZS8I4D4RHnNGs7BjhIkGC5ph8mQKmDtuWF73M6tdEj53HJIdUNdH2BmhT2CS8GM/jbItnDJXs/jGynpHi5kR4qnViu5heRwhLmDEOWWsm9zp57/d/TYp28BEfwqMce
 W+7N67cR
 wDyCJF8tzQSAYfQb5y8ugjUV6OMZ8EtME/3SroZI8UknUIchEN72f5TuTf68zeAIKM7tv0WDUvntuGx2HftzpB5920J7/YkIm8+plJ416Igf9xk3IWNh8VJg0ktAymYTXi7aZnKmrBzUtfEmnnSNYsqoRUyg6+CvBwQlRD2+Ocm4yKQi7x3ONyM+iaHcoCsc/lTkzKo4Kb9iSqYLvBKLsNiOjS5m4b4bEEic4393gVx/txpsEXCT+uQcUwyT+dvwR8+LyLwZHFi0P7UJKE9muHCLw2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 25 Apr 2026 07:17:18 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> > The usefulness of the mailing list posting is that it makes it easier
> > to respond and discuss the review. Yes, what Zi did is great, but it
> > would be nice if contributors/reviewers didn't need to manually quote
> > Sashiko.
> 
> I think the most important part is the contributor side. A private posting is
> sufficient for that.

Thinking through how is this going to work out.

- contributor sends patchset

- akpm looks at the Sashiko scan and thinks "huh, we might be seeing
  a new version soon".

- Now what?  Maybe contributor doesn't like AI, maybe contributor
  thinks it was all nonsense.  But I don't know this!

  So I send the email "I see that Sashiko said stuff - can we expect
  a new version?".  Which is no improvement over what's happening now.


What I would like to have is some reasonably reliable and prompt means
by which we all learn contributor's views on the Sashiko scan. 

One way to bring this about might be to set suitable reply-to headers
in the Sashiko->contributor email, along with a few words asking
contributor to let everyone know the status.

But whatever - let's not overthink this.  To start somewhere, let's
send that private email, spend a few weeks evaluating then perhaps make
adjustments.

