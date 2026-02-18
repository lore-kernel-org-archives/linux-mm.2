Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E81CE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B50A6B0088; Wed, 18 Feb 2026 04:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4626C6B0089; Wed, 18 Feb 2026 04:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36EAE6B008A; Wed, 18 Feb 2026 04:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 218096B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:56:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4520160500
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:56:50 +0000 (UTC)
X-FDA: 84457123380.08.73600DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 010F780009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:56:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgQ128kW;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771408609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV122xeRA8ORVd49r6sP+klEaOhurM7yPuWmxhD8R8M=;
	b=OVAGdTl2UzFQ7hXQ5XPmNrq/yzdnYdEBsCDJGR427UTnOyuP1YuX9xDHE3VS7vgl6o8cSZ
	QlFhR71waL2rE+y/ytve5/3pTRz5ycbMRz6iwo+A2+LQqrfPjy2c698WqH8z0w8cKl5Wh0
	JoXtiURydy11ugiEqgHwuwE2YryYAvE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fgQ128kW;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771408609; a=rsa-sha256;
	cv=none;
	b=3VoQNcRgo1vlsJtTW38JTHD68iWZy+me+yPb9/SJTwXXQn1vyLD/+opPbba53lvvqFOARD
	rfHjzw3cj5gDxTZbr/u3H3Sj8MY38UpMIhU6D0AYk40LitraHD1JKeKYflefeo8VeEjiYc
	M+pYgr8P91bURT/Jkxty5NRtEZsQCfA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1687D416D5;
	Wed, 18 Feb 2026 09:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62380C19421;
	Wed, 18 Feb 2026 09:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771408608;
	bh=2M/oHwf738t/3QfICnitZIlKcPZTFwrhHKLEPVnncmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fgQ128kWu65YDpWegMGfZb53YMJOn37hIRSVFfGx+pX+XzlqcyAlnYaoU4+6+1DmR
	 RORpysuoN+2jc/iElKEHzTyrk0kzgPds9IeF8VxQJ+oNH9GOwItJ1Z3Oxdd7tUBcVN
	 gc5Nrt9uyY/DSO/rlnEeiwkHWl3ev1N5AM2HgxyK3ZUZYnYyxqmq25m1NcF14MNeOg
	 cCpyzWOtZJzVvtGzG8/VOLvy1VOmg3CHRMe8f06ebQMRHR55fCCvgN/TodM6lois0T
	 F2PEVMj7VwCi7XlgOy78HPknik2Fxg643Q0kw2U9PSjATb6snf0OTVTdqf2Er++Lkg
	 qhpQKFaFxakhg==
Date: Wed, 18 Feb 2026 10:56:42 +0100
From: Christian Brauner <brauner@kernel.org>
To: Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-nvme@lists.infradead.org, bpf@vger.kernel.org, lsf-pc@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: Re: LSF/MM/BPF: 2026: Call for Proposals
Message-ID: <20260218-haben-protokollieren-d4b5d2a1f8c9@brauner>
References: <20260110-lsfmm-2026-cfp-ae970765d60e@brauner>
 <20260119-bagger-desaster-e11c27458c49@brauner>
 <20260129-beidseitig-unwohl-9ae543e9f9f5@brauner>
 <20260216-ruhelosigkeit-umlegen-548e2a107686@brauner>
 <CAJpMwyg-3-Z=ZDC60Vn0s-8Z78VOPKYmvX9s=Nnvcoao4T5zbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJpMwyg-3-Z=ZDC60Vn0s-8Z78VOPKYmvX9s=Nnvcoao4T5zbg@mail.gmail.com>
X-Stat-Signature: dotcmrm8tbergq74sigy7mx8hejetc1k
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 010F780009
X-HE-Tag: 1771408608-489779
X-HE-Meta: U2FsdGVkX1+UnNIN847kPRKmLIuweBCSNPtF9IXFmnXYryFUOvuks0pQAbKD262BVVxHjPljpZvMwSZdXtDGEERfqQ05fp1+j+w8eWOp+J27BgD/HGqe9VpqOw88eiH6rRmenL8QEbVGkq2oizyQwSCI1OHwWd/hhTJP6q5zGT3CjwQ2z5FsiwpkK/1kAlHn3J2fm09BDNZR3NkLHU6PooLdeQMf4jaQOpg782be8xNmCbgFQU65CM8hCwCcIPbGckdPLtZPiLpT63CyxpHSIFc88fyIk/0s1PqEX2xieH6+l9alXQUnnoaPplBrQjNpt71sXJGx/t6XfX6Lrp4b0IVs5IjxXNMBBSCSQDlZqSityNVuwdhsJjO9ldEtBXJIk9k6qD+XhAkinXYaKbNVnd1nvx+7xZPQiI/X7quzS+ZOcZst3gDBsWvtPXpokpx5eWgViK7SIMq/UQnuQsRAAI/siDRezC2OP9VsOLJ42wQGSDJ/DfmNVv8tzT7U44kR6zQat7wWde8uAc71kv1Yq4mjTM/IOqrTNZo9Cvr9WfMJdzZu4Qra7q5H42mMadYAfhe95lhtzzJuZRuHYmL9I0v9mxFCgi8hwdjijzTYrS670A0cJEa/9xgF2jUJI1fztdusOuuUM6US1GvsQurDSrMWe5Rs5Fq5ToGk2FwXpnB5/UKA0HfEpd7LdseKFTFywT8iCgVHBOT1bNKK3E8WIpFVpxooB5imBUAaOzBaDBsJYPnQa7xKeIUX1y9kUYrFM1olBjkcmhlz4plIBqyE57AhEsp8KXLm7TsvETucRbPixn8RdXEAis+vmouhgnvPdVIIBN/XCKlGPTtYw+QFsIaDZ/k1glWdNoASfRK5si6Ynmjsszb9HngDoQk3+ZP4g/uvl7fADY+Jcl5axWFXHREoZrjfyfzeXniuPDa46HHJWROHOPwlS59FrXHTepDxBIEzUpHVeslOt3VRcy4
 8hGOdyhj
 M9uCWFJ662yNU0b88WKB4k4lXaf8feFEIOGSct+590mu57nThfO1QPeQ6LmFDQ7Hmk+jzitdInGHWnV5YJymKl0k97WwCQJxLlOZ9WQyRAnMkT0rZDFRqOLn1STvyUKi1eFS5HZphCFIqcVARCOtdCUEEyJztMHCdt2XW7RXW0Bt5jIKT+XL2zGZzJgt/Fp540BTZZf3VHJgiaJIrftCZA7HXgXEqa+Aj9pQkVm9kxyoPqIE3cF76TWSg/TWBxKugj63ZCBKiwZosgbK+40idDsFdIUjNiQ9/yZkrYZU3/zsEJojDFTf3GGuCRW8RxbU3QyAlMpBuexQEvUSHJCrCDgsMGvQ0pAA7/YTsdm4en1uYWlAS0yAoyQtBzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:37:19AM +0100, Haris Iqbal wrote:
> On Mon, Feb 16, 2026 at 3:28 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, Jan 29, 2026 at 05:13:52PM +0100, Christian Brauner wrote:
> > > On Mon, Jan 19, 2026 at 03:26:39PM +0100, Christian Brauner wrote:
> > > > > (1) Fill out the following Google form to request attendance and
> > > > >     suggest any topics for discussion:
> > > > >
> > > > >           https://forms.gle/hUgiEksr8CA1migCA
> > > > >
> > > > >     If advance notice is required for visa applications, please point
> > > > >     that out in your proposal or request to attend, and submit the topic
> > > > >     as soon as possible.
> >
> > This is (likely) the final reminder to put in your invitation request!
> > The invitation request form closes this Friday, 20th February.
> 
> Hello,
> 
> What is the announcement date for accepted topics and invitations?

We will very likely aim to get the initial batch of invitations out the
middle or end of February.

