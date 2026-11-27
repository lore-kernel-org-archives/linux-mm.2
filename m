Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71CD606A689
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Eo16aKiJ
Received: by kanga.kvack.org (Postfix)
	id D11F96B05B8; Fri, 27 Nov 2026 17:08:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC2A76B05B9; Fri, 27 Nov 2026 17:08:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2726B05BA; Fri, 27 Nov 2026 17:08:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8F26B05B8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:08:41 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18A99404A3
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:08:41 +0000 (UTC)
X-FDA: 85482289242.25.D5C51AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7026620006
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:08:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eo16aKiJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795817319;
	b=4ml7CXO0ydxB3Loy3bbCUjnyC02pzp7wUoA8IrKUck9f4vn/Z0QPMCwVqJXu6Ka4rcV3FA
	WiFop2ySfVOYteLwP/k1YdA4/qGi8FhzB4L+tBJVEw2OkFLs0GXjhi8D0spmnq/qd77p8A
	Vca5o9Nc6EgscDQjt37Bcqk1gZemZe0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795817319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qim2wvS3GLpENphc0viA1C7S9Um1xXiICAsZWzouGmw=;
	b=Kc0rYCqjT61jsxVsMRIjlAnov2DV6XW59JptC10bDIW2iHnu1fM76fyXDFVOtopgHSpRVp
	QvrFHj/GX38lm2VLXQUfDMBhA3MRr1GpKF+izcAyjoGRKByrTnibGlczqOeaw9d2/EItAD
	KS7wQph7OLtUAKuIgXLHJyshqNDMbgw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Eo16aKiJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 9D58343A18;
	Fri, 27 Nov 2026 22:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C16D01F000C1;
	Fri, 27 Nov 2026 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795817318;
	bh=Qim2wvS3GLpENphc0viA1C7S9Um1xXiICAsZWzouGmw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Eo16aKiJ7grDNFCjfScqrd4kEpRnZo12pNtIsg5EyqWXflotScK0exfdbqe1GIM6Y
	 Z5prVEfvaIznrN6tK092KaJ8snI1ZguEO+UMWRdCFcd3k2aIuHnaLzk/1XQ/AEoU0k
	 dLT4s6oqIjIOYwQ+AavHCBqpAYFGroWtqt7K30SzDcI4wLYOPGLTHTRIRTYqOwyEtx
	 6WvT7k5p3VbTY0lSLMaQz4UVCT9NYsEUuFn2eib4CM5a0vNocdMxsp+OG/jg0psAGs
	 sdMrF8QYqlg6OcnF/PdxasMHbj7drAY5v76tMbj4kvvddH6e37YZj/x74iYJbgdZp8
	 8jQQXAu64tvQA==
Date: Sat, 28 Nov 2026 00:08:35 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Askar Safin <safinaskar@gmail.com>
Cc: aleksa@amutable.com, alex@amutable.com, alexei.starovoitov@gmail.com,
	arnd@arndb.de, bpf@vger.kernel.org, brauner@kernel.org,
	containers@lists.linux.dev, corbet@lwn.net, dhowells@redhat.com,
	ebiggers@kernel.org, giuseppe@scrivano.org, hughd@google.com,
	jack@suse.cz, jlayton@kernel.org, josef@toxicpanda.com,
	kees@kernel.org, kpsingh@kernel.org, lennart@poettering.net,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	luto@amacapital.net, neal@gompa.dev, oleg@redhat.com,
	paul@paul-moore.com, ptikhomirov@virtuozzo.com, sergeh@kernel.org,
	skhan@linuxfoundation.org, viro@zeniv.linux.org.uk,
	zygmunt.krynicki@canonical.com
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awn_Y7oI4ckfsjSv@kernel.org>
References: <awOQDOel_72Xwjm7@kernel.org>
 <20261127214103.542291-1-safinaskar@gmail.com>
 <awn-ioAuksHNV-Rc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awn-ioAuksHNV-Rc@kernel.org>
X-Stat-Signature: 379cjg5bc6ohjy99mbcinai7feds8xez
X-Rspamd-Queue-Id: 7026620006
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795817319-115698
X-HE-Meta: U2FsdGVkX1/ChJbcbKrV2veEDXsvuXUdCLIAT7TdF5sdOsTg8vXOPffXeEZAt/TPLuQG3q7dI2JxP0rXPMDVWRsu9scxY49SGVVn+ht0rtkmTfoUaZiujzsd+5e9wG9chM7uhPLBuHWcyoQbqqPCzD/eRC+7CWH4lWn+lnNZ5h0qEAhlTnEaR6pGTxZLNZEsTGLYJCfWov4lDrv6KvdH0P5JqIVwYWb//9pvAGF9RbLbQ69+dUv6jZa6EQAZSP7vDPmskGZsI+LNOZsrzcsgv05W9KiBuhnPzTa9OpSuRB/xeGCbJb12WUJ2MKLVimOZaJ5l5+7sVNSiT8SF3jAjhUqqx6k7VVt5NsJIs7+ZPjcDqfzmSON46qhgt7t9QTgOWp65jOsGAWxCEnrMN5+r1xqAOOgwkM/t3I6+sSSsh6k1o+b8iNX1IxuY5SbCNeM0P+qdwnB7vFfpukUjA6VUzea59+8HrvujfZaelTv9EMNlaqS74hP9zndAxIUGH19vt2bLXDCoju4qgoKlXjY/QW9hZwmy8oEoFoedpkB1p3zaI/WBrcXoXmQPzAK7xRk79JBHqOM9MGqDjx++rSEVu1Xgmyi/5Os9TTK5GGdpkCyHp17If8WWU4QPRp3YsA/0ec7zISsN1cuep1R4StXc7LwQ30HHIG6feAA/93qy5rRsCKLOpqs4M3jga/V9Y5kFw+xqpm1C29Jd2Nryn55mYYPeyFFvEZ+Tx7iIHdo3U8fQV5cFLr3mmvFzqDSOQlxTuhe4iQCM5dWaHeLscAqV89i/59sgUFskqcMPehO5px6XbXuzDFKjiz9X39ofgkZqjvDbboBz8ZRvkeStlaP3Kcg15qxoaGPJmGjrs80lQWmhhlNJlaaRvCPY6Ndl/xf3i3/fkgcnxcVF2CdJwbxFFUcgnWU3U/BS2O3jr0jwNThcF+PZbNljtNsgg70PUx6ux66HHBJexRNHZzsVNo3
 gezJDVtY
 lstkbA69d4zZMn0r7YMMJz9hzjhzHtddcLg1BCTl4wJqVoleUEAnkiv79TgMoUeoJBLMqwzL12xOv1uuW8fPcsvhepaBNurTqHjg0H/AmNyAlnrhD9WZSBLsMkbuUXhwIhmG1v+woIzphqGxK4M5O6n0o+EPZ5Wu0YkN1t8v/J1DHS3tUr7FEY7AmFL1QNwPhUVhQBdpvlMEq/ht7P6TSwNeEcy6IKrVNp71PH7IL2ffk3e6PE9tOtshRiQ4gmKhr+1B1XqszuBQitzXkCtl0BJ3LE+9drjBzf1xxrTbBdFQHiIL8+Tl76rFZCl41RrVcTBUn//pN76oVX6H3Ve9JjM1Tc/oUCiLeUnT/K9kh1mxJCvMd2P/vOXd+7eKKfvyhfyi2zz2bGxenaaQm/eLtV+pTfkdV4RpBSjkHq0RxI+2ZC0U+E5GmYh5GZlZS+9VkiWcLfzXlpVbn230y3jTwvx5uAXL3HD4itrTESmyyTzbrCCXA/W7o6NoW+POD1rfYN1gk7J7gJ0ml5+mdNzF2P/E7LTg73E6K5+TZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 28, 2026 at 12:05:03AM +0200, Jarkko Sakkinen wrote:
> On Sat, Nov 28, 2026 at 12:41:03AM +0300, Askar Safin wrote:
> > Jarkko Sakkinen <jarkko@kernel.org>:
> > > I personally think that "getting in" should not be a goal in the first
> > > place. I care more about that whaever gets in has a high bar of
> > > quality enough. It can be something different than this but
> > > when I read the LWN article about Cells I was alarmed enough
> > > so that I had to do this and prove my point.
> > 
> > I think that Bacik's patchset has better chances than yours.
> > I think so, because (as Bacik said) it was tested in Anthropic, and also
> > because Brauner reacted positively:
> > https://lore.kernel.org/all/20261021-zeitig-niemals-clubmitglieder-b3973fcebd38@brauner/ .
> > 
> > So I suggest reading Bacik's patchset and say what you don't like about it.
> > You will have chance to influence Bacik's proposal before it will be merged.
> 
> I've read it through and the way I'm seeing it is that it is overdoing,
> and has somewhat complicated life-cycle model tbh. I don't like it.
> 
> This could be of course wrong way to see things and I did this just
> to demonstrate that similar goals can be achieved with a relatively
> lightweight core. And this is also demonstrated with a Python daemon
> emulating Cells style containers (and alos relatively trivial SystemD
> wiring).
> 
> There's no reason to continue this for the time being as it
> demonstrates already how I see the world i.e., "I showed the
> code". It's up to whoever decides these what they do.

And even if Cells is the ultimate solution since I had thought about the
whole problem 1.5 years (mainly for my own entertainment but still) this
was the best way to unpurge all of that. Regardless, world became a
better place... New information arrived.

Br, Jarkko

