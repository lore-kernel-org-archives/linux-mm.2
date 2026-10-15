Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF34ECC6B30
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 02:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D068B6B0098; Wed, 14 Oct 2026 22:12:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDBB6B0099; Wed, 14 Oct 2026 22:12:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1AEC6B009B; Wed, 14 Oct 2026 22:12:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A47C66B0098
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:12:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37341120897
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:12:25 +0000 (UTC)
X-FDA: 85323236250.17.EAED44C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8593840009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:12:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=myVQQQc3;
	spf=pass (imf17.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792030343;
	b=nvjFrbShKBLVttXhuqIrSBH2s4gqGSpc5+9V3SAdngrJLBZWGbGig2F+TXltl+x37m96og
	6izZJ7H8vfshiTa+zNPagKDT3u6bI7SVAnkWFvLRFfGp5HnJuNr9GdMYsuFgH6cPa/muax
	oX7F/46RFfafneHeQvrnZE+GFZprTbA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=myVQQQc3;
	spf=pass (imf17.hostedemail.com: domain of jaegeuk@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792030343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMLHCJtJQPgffvNFPP52wXbusU89D1NMxKSfS6CjEcI=;
	b=r0/h/IAtNFTdo736K5ukViMOv66ABUIGUePXW5I/MA2c9Bk0B3XkD+8M/S9ljevqTHfTkf
	sz0NK/AqOcSijWgRNJEFFYJPa8JISPV6U1GPG2xVosSqghhjd/CC2zWB1w2kuJ01FN+gR1
	L5tey9YHpHHkd2F3/q8d/dJci+lBabo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D883042B7D;
	Thu, 15 Oct 2026 02:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 513E31F000C5;
	Thu, 15 Oct 2026 02:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792030341;
	bh=qMLHCJtJQPgffvNFPP52wXbusU89D1NMxKSfS6CjEcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=myVQQQc3AkWg8Rs99ajie+H/9mSd02rYHqEaBv/AwUu4bxrQw/ajPX05cuK2vfb3U
	 9oPNrlp1fwHzufh2gcwcRZwnLVRDqJTXbcoeCLSZLkfqNZkh0TVMKeWvoa1vfwI3pn
	 mI5AmxAxBwOVOvLJo8BOHVyfDTesd1sn/9XzDbkIndYFbvC8hsi2UIlQAiMUhbWzd2
	 QDiyZ1ziCBIoSXyhsuN8cyttqdmwwNMAXXSSGkI/+/ZhKNSy1kaPfDF2/FkeJm6b5T
	 Ck+VCoXrKFdMsRCKtsX7U+Qm0Up5ZfBj61t4pqM4Zl5fu1clA1HcJRy+84CsaQMptx
	 zRtE005Y9n36Q==
Date: Thu, 15 Oct 2026 02:12:19 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
	Pedro Falcato <pfalcato@suse.de>, Harry Yoo <harry@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <atA2g8OgpiNOiVL_@google.com>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as690Xcu7FxIDYjf@thinkpad>
 <CAHk-=wiak+h+d2tZ5W_MwRzatUP=hJKn7cpGjDxArG-gwgHLXg@mail.gmail.com>
 <as9-2cIuGuXwE2Oa@pedro-suse.tail5790ac.ts.net>
 <CAHk-=wgkoAuxNXga29nQ8w7GxdqR+4vPAUhPsbfp+gzKrb9EgA@mail.gmail.com>
 <CAHk-=whzkNzkBmCspHYd80D1Z=krDc4SgVC32=pJ5PtEgqSDrw@mail.gmail.com>
 <3c613725-406a-4506-b788-987a337b9771@app.fastmail.com>
 <CAHk-=wh+1Hz+3HJ8evmh=FKO1fCGiwuNTqArXEfe-tAJ6hDy0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wh+1Hz+3HJ8evmh=FKO1fCGiwuNTqArXEfe-tAJ6hDy0A@mail.gmail.com>
X-Stat-Signature: itcuhdpzudc9zekn5y8osane5y45surx
X-Rspamd-Queue-Id: 8593840009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792030343-922961
X-HE-Meta: U2FsdGVkX19TojJoMTZmu8OrloaKNgkiwtk7djJNzlBbj2nkHX+a4NCrLM9gkMKbT0da6c0Bkig8UNdqcu61bbG4k4kqa1tVSBmh9NsbfHpwPErKAfNR7AxdTkYK0iFevNkX3AGmHxc397vJUKpc2lFD9asqrH90VB1mgspj0yWjhm0OfoJAh/5g+t7/OcoKlAvljJVKvXEuMFvOVCXaXU85qY0QIPtAizi8eK/QuGnx880m4ATN6FOe4ZtXn7iF398ZSshQi0D3JR10j2x6Rm2XYdRxeudDuT7Ctm3COCZZgGntK8qGHZSDA5YdCI3RVYS6vxnqA+zK6WlWjxTtRohUcsInOxWq81mbaWaRlrIMrvW4H51BJQLndp14FRg14xpOEOlno+l5fWFRsnXGlLV768LqmsTiB8EH9IueYi5fX0bafXe63hQZVmPTmRl+l6bTsq+J+isHAVvzmCAqB9PclBXPAYu7sYwu8Ke3ynRw92PIkMrHQo6g4314AfzYX0taeb7uE1C58KJgMbW1ytvcnCWWoYLmzwwgaHMbwhqjGsqWlzV7cg49h/tydJaGJ6cxaZHLO2VYAskx0cJDdKbiYu8T/GS34GJvLkTYmfGP6KmCGEhELHrHhWDZjpjpjL0ILBxV4ZS1S9YxrBaMELfmk6U+8TAgKUwY0JfIJhNHy7Lt163kPKCRT7AIkBdor3fvxDnmpmbw0NpP6tBc5dvp1lk3StFsRSRdZX6ZMvEGtIC12zIY0zDmy8bPzRMDtdEo0tPqclTLOIgvm6V+5jiCZVC1Mkea889ALqbEdhrgj6aycig4qPMBfMBlUx5W+m3NCTddfJMF7xWN42VdQnVLhf10X+d1bkuiLCxojV2TBdT6wSOlcf5xeMjMR07eWrmAIx9hfAzYjlb+lDBEe7vamLeJ8/3DO5Y+1pQ3P7KGX1LNVXHyZAUD9mAhjt0fHt/F1B/2wWT4ylfkrgP
 Jajmlel9
 UUiNOYmLalmsuJf99Ta+FUzNboNZzaZlZJLG1wKYwErMx4aSzoJiAUJgT4IARkYr8b23Hpg3yVTzFTdebtn3e2S0c3EZlfYgeAkogehz+XHia4DJdg4tgN6telldPkoZCaI41ELovChHIkUWjymRZ34sn7iiCLml7g+cvMBegSdvjYa9I1q8jmluHZ/xV1NROJf2BGT97reaGg45rK7C2+ndpJ7I2DQ79TczweS4f+9OCdcaZ8JbRjm6FxyxEPOUWHbL7Vpe1Vf0AYwu0u1qEtoa04lG6Ja6jMNV/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14, Linus Torvalds wrote:
> On Wed, 14 Oct 2026 at 10:44, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > I already have it:
> 
> So that was my thinking too, but I have my notes (from the original
> truncage/hole punch patch) about mapping_exiting() being problematic
> due to f2fs playing games with it.
> 
> Now, that's probably just a f2fs bug waiting to happen independently
> of this. But the path is
> 
> ioctl(F2FS_IOC_START_ATOMIC_REPLACE) ->
>   f2fs_ioc_start_atomic_write() ->
>     truncate_inode_pages_final()
> 
> and that truncate_inode_pages_final() is the problem - it's what sets
> mapping_set_exiting() on a live inode.
> 
> I had this as a note for the original branch, and it became a
> non-issue with the change to the "set PG_rcu_free on hot pages in the
> read path" instead.
> 
> But your change makes it an issue again.
> 
> Now, I think f2fs really is just buggy here. Calling
> truncate_inode_pages_final() on something that is still live
> afterwards is wrong - because it's not "final". As far as I can tell,
> there may still be hundreds of active readers holding that fd open.

F2FS_IOC_START_ATOMIC_REPLACE was supposed to replace a heavy ATOMIC_FILE class
in Android, consisting of 1) creating a backup file, 2) write data to the file, 3)
fsync(), 4) rename(to original one), 5) fsync(dir).

Indeed, it's a bug that user can see zeros between F2FS_IOC_START_ATOMIC_REPLACE
and F2FS_IOC_COMMIT_ATOMIC_WRITE. I think we need to move the truncation path
into the commit phase and use truncate_inode_pages() instead.

> 
> I might be wrong. Adding Jaegeuk to the cc.
> 
>                  Linus

