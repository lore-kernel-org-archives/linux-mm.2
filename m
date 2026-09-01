Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FD4AC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:51:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6B56B0096; Tue,  1 Sep 2026 03:51:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967A96B00A2; Tue,  1 Sep 2026 03:51:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E126B00A3; Tue,  1 Sep 2026 03:51:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 680436B0096
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:51:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E83BA1A0374
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:51:06 +0000 (UTC)
X-FDA: 85164422532.16.0750331
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 36E54100005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:51:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQ0GEQ8E;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788249065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkHFo5jqNRtZpSpb5upRyJqdEeEG8yfdjwML22DaM2M=;
	b=YN9TudKSDJbZRmuDdX0RE/KlpvkXuXLkb+x6zWFcTiPwrdQpKwTPQ5iTaOnSguCb5jQDmC
	7W3dPFU8uvu9sQs7m+H4tfY8Ic03Ts2xIpJJ6bDwnqrn8hyIqnKvQeuAvMaEC2Bo10iOBR
	HG8ded3MFHjyWFuhPTjWEJZ9zfER5To=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788249065;
	b=aTo/nw26tommNuEZAAyw2VPlTODbKrHJgZvSw1IC/warRE2ArNLbMRRnWLH9qJzM9Pe8ll
	nkILNNlY+SH0XZXQzViBqMnZjY70dkdPcjRIHAZ7ZecQA7msMnNfwS1rot6D/8zD+56v5E
	mKX571BmkVzW3zvHK4MgFIZKy6XZefs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQ0GEQ8E;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AF0D412C3;
	Tue,  1 Sep 2026 07:51:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F701F000E9;
	Tue,  1 Sep 2026 07:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788249063;
	bh=NkHFo5jqNRtZpSpb5upRyJqdEeEG8yfdjwML22DaM2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LQ0GEQ8EMKL3wqbe5+vu6GY1oFduA/SMGO0TB8g9OLGcjSGjli45w4d7Mq+fNmByQ
	 0WMQXFqRUpexeT9oInsZH9wKpIB+oWkC3gp18c1g129s8KgGWG56d3AG0eICUelLNe
	 HXOF+a0wvdlgRD/ZFzINz/bPTOIukxYSPRYeKyA6+MDY+rztgT0gURiMerfsAXUkke
	 VUudVmj1Iydt7IX5Nvb+jsm/XIchV9exH7wM5IOkQCMsGfOnsG/PdVh7NwyzlnHTNe
	 4m7Oyd55v5xfhVZpCPXU6s0WkB9IdojlYsEDXfB9R8JF8Oz55k8M7RAYFop+oI7uuQ
	 F4Mf4QPFcAUjg==
Date: Tue, 1 Sep 2026 10:50:58 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: linux-mm@kvack.org, leitao@debian.org
Subject: Re: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: add underflow test
Message-ID: <apaD4v7JkV79MVgd@kernel.org>
References: <apGbO2QM35VZ8d7a@bender.morinfr.org>
 <apVC2D11bMz-QHic@kernel.org>
 <apW8KS4D6k8621Ca@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apW8KS4D6k8621Ca@bender.morinfr.org>
X-Stat-Signature: 8ppssxpefrprgsqs7b1n5qcn9ie65fzs
X-Rspamd-Queue-Id: 36E54100005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788249065-527018
X-HE-Meta: U2FsdGVkX1+EHoczRGMNLCn339SbrnHTuCUEo4lsG77KR+Fzu+S/UrNbTuGmI+NuBVI7DgoVB27LDwDhMvN4dYYCENM1R4q97COra31y4PlRBv6FcrY+QsthuBYa5iDFzhcy+JZvq+A744gE0juhyI144mluCGuC5dNk51/RKrHR8BbXiiAA6RxD1YDp6f7jPBPpHXT4ovuFUlNrg+RSfV5icYYRO9ozsQOWBMJ0h5y/0tIakVCB2uWwdMez0kx4/HtwVME4ao1SsNkUmLrud2qi0J2uvFufyo5AeyX9cxg77ZptAiOs2VacyxdopsrH0b4SE3LDAbQRGox6nVuvjoPbE3uQucvJFk4vu4fYmJZ5rc3GUvDs/At4P+4scmSDYSHCZnk0onxamoMzj4eiu1FuulhjJd6wWEhoYAmyl1R8/6YT94+2fq7AedIYCmmKCbtwgxq1pcY1rIt1z1lpnuUZp17Fury9JBSJrDQT5hJnX6fgFwbfnG2Q3yzmvswC4e8GsJftrsn8Qu+hYlxrCTjlyAi9ycrJgjp42TRMHxQwWtxTsvXfnfwUbXb70j9JgiACIVe3DWMpwz3EweNqOY608Rxrztv1BupilRK7e2ASnkQir0MF5gSsx9fNyGiJHnUt0BsLA5HwGMO53eK4au5rL96ULTfiQxYYEaa1S3JFsTqpLBBird9cVl1XN3FkT6C5a/mY1O17Q7qHZqUEMzMyDNJ6N9RZP7zXi2bwGGCaSyqL0zR8jwGJ6M3JBpgZIYSVFLZ0ViORY+5eU74Rf6qs9MR0vFGLs5EFMSaA1piG1+giCHnNkFDg8AUuaMszaOhZbkbzGnZwEBbMzwhRm8Xe7WpLpG6zG6urSpdlB5lTKm87wzczq/ZPrpoo0NLHpT4E/QU/cJmutUSsvqGNW3yX3ziJmzub6zr10yJM1pOfbX7w05scX4Bw0Aqk2IRyZxhu+DGrG6g9f/TF8ji
 iKuiOQ7r
 T8VzRNoruo1sUp6ho9lLMdxCacgRC8HV7y1dfg6NgkSzEcpgb0cm47bv23BnyA9ZCyjXPSR8IAhMmOjtm0S9na2LdlfN6sYhlU+Q7l2QFHllgnGDt+clJdfVoaNPqQRI7P+1agDJTPbVNrKeZBZZ7BqNlLWn+G9dJ0wm+EEDuxm7Rd5+MfEbFM4BFVbpXJaR8Ea9gsL/37NJubqRtk5nfn6K/fb3c5pAMQmKewS4aHYth8sqArgi0LmToCVLfYSaDfu5MkM4AxawvjVg1+C4s8Si69cA8cqWEhux8IVXGOdur8Lk4kapgF/RUbys5vP2LBLZAwL2Fzm4p54aUcd0loFgBbE+M3WOPCbJQoZ2u0wvr2mI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 07:38:49PM +0200, Guillaume Morin wrote:
> On 31 Aug 12:01, Mike Rapoport wrote:
> > > +		return;
> > > +	}
> > > +
> > > +	/* Parent */
> > > +	close(pipe_fds[0]);
> > > +
> > > +	/* First unmap, this will close the vma */
> > > +	if (munmap(huge_ptr, mmap_size) != 0) {
> > > +		kill(pid, SIGKILL);
> > > +		ksft_exit_fail_msg("munmap failed");
> > 
> > Won't this leave the child as a zombie?
> 
> It will, for a brief amount of time then re-parented to init which will
> wait(). Happy to add a waitpid() here but I was concerned it added more
> complexity for not much benefit (it's very very unlikely munmap will
> fail). Let me know.

Letting init reap the child is fine, but there are other issues with
killing the child without wait().

First, kill() deliverers the signal asynchronously, it may happen that the
parent exits before the child and calls _atexit() cleaunps that should restore
nr_hugepages. But since the child still holds the page the restore won't
work.

Right now this is somewhat neutralised because the child returns to main
and calls again for cleanup, but that in turn produces spurious output:

# Planned tests != run tests (3 != 1)
# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

The child should call _exit() to avoid going through ksft_finished() and
hugetlb restore callbacks.

And since you already have the pipe to synchronize the processes, maybe use
that pipe instead of kill?

You can also consider using goto err_cleanup instead of doing cleanup
inside if (err)
 
> > > +	}
> > > +	close(pipe_fds[1]);
> > > +	if (waitpid(pid, NULL, 0) <= 0)
> > > +		ksft_exit_fail_msg("write failed");

waitpid failed?

> > > +
> > > +	nr_reserved = hugetlb_nr_resv_pages(default_huge_page_size());
> > > +	if (nr_reserved == 0) {
> > > +		ksft_test_result_pass("After the child dies, HugePages_Rsvd is properly set to 0\n");
> > 
> > This makes this count the test as two, right? 
> 
> Yes, it checks both that there is no underflow but that the count is
> restorred as well. is that a problem? 
> 
> > And do you need to re-check what happens after the child exits if you
> > already detected the underflow?
> 
> Need is a strong word. It can be done either way really.
> 
> > 
> > > +	} else {
> > > +		ksft_exit_fail_msg("Unexpected HugePages_Rsvd=%ld after the child termination munmap, should be 0 or -1.  Repeat the test\n",
> > > +				   nr_reserved);
> > > +	}
> > > +}
> > > +
> > > +int main(void)
> > > +{
> > > +	ksft_print_header();
> > > +	ksft_set_plan(3);
> > 
> > The comment at the header implies we've added the second test, so they plan
> > should be bumped to 2.
> 
> So you're saying that every test function should only fail or pass once?

Not necessarily, but comment saying "setup a second test" and the
test_underflow() name imply that this is one test rather than two.
 
> -- 
> Guillaume Morin <guillaume@morinfr.org>
> 

-- 
Sincerely yours,
Mike.

