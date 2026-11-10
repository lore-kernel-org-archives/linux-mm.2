Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D04B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FofAtvAV
Received: by kanga.kvack.org (Postfix)
	id 4AB5D6B05C5; Tue, 10 Nov 2026 09:46:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482ED6B05C6; Tue, 10 Nov 2026 09:46:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C05C6B05C7; Tue, 10 Nov 2026 09:46:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 130346B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:46:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57DF41A093B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:46:21 +0000 (UTC)
X-FDA: 85419484962.09.765CA4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9075C140005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:46:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FofAtvAV;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794321979;
	b=iEl4OKpcBjUPtACcyS3RBCAQ5ZSQUE9Zreogm+92/jmMGj4t/uBB9/joAtxZVM00hNumis
	YA/d3yRQUO55fkEw0DjVX6wnE8UVchxsRd2wLG1a5Ui0ucI4DJYfwqc1o3+gRCmzqUFCRK
	8hZBmBJIWVy7dEiPAR4AebrEYgL4rWY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FofAtvAV;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794321979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLoC9w7FLeAk73lIU0r6bo/hbegniO3/ExA19wRJYXw=;
	b=z6mS8Lt3PiJ2BuC7mffsziEpAKnAu2itXse+UwILxKt0s2P/dRcox47WMuW/MYA2BbeCPl
	IY8VF65+/83+gSI5VK+W3vQNl/aUKObgCyWM3e0TcgDBf1wwUjZzX+ou3lsMjZdL9pnsaN
	QHcRz3xaJMxKMMWseEx7Y4w5bIR0sKk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 248BB61304;
	Tue, 10 Nov 2026 14:46:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D261F0089F;
	Tue, 10 Nov 2026 14:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794321978;
	bh=nLoC9w7FLeAk73lIU0r6bo/hbegniO3/ExA19wRJYXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FofAtvAV5FGZiUoSFkbbk5sTWq3SO46vWboyy9Ecd0e30yY+52pYN04uH66KHdd6W
	 InsApuHZ8nQrpvWXWlaVNXdSODQShpHfPET2fZdrf/1ul6GcldloP1Erntm96tPRO9
	 eT4jfv0fXjW2HGZf+QWOsNcgRIPOudnwYeOK34UuTVOI4T9uWTIMzp2/QXv8rY+Sdm
	 2gTfOnJA1FNJblOfKeO6Ts38SHM4lRUXdgfvM9cOGb8YO92ReOBXSJjBBdmKRhYeYG
	 b2rgzv3eHmdLYvj/KdBazB3n+W8Qo9+QrGl8i0oatdxJ2xolGyjCJxWLlbnRirE5fB
	 0C8xKqOrJ1Kdw==
Date: Tue, 10 Nov 2026 14:46:07 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: Gary Guo <gary@garyguo.net>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Suren Baghdasaryan <surenb@google.com>, 
	Danilo Krummrich <dakr@kernel.org>, =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, 
	Tamir Duberstein <tamird@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	Daniel Almeida <daniel.almeida@collabora.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Benno Lossin <lossin@kernel.org>
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Message-ID: <avMtGWbWyTE1dZTS@gremlin>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
 <323e1f32-4127-4121-a1d1-3a7e43ca5ce6@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <323e1f32-4127-4121-a1d1-3a7e43ca5ce6@linux.dev>
X-Stat-Signature: tfq1fw5soszssscrq7h6bj14pthb5oso
X-Rspamd-Queue-Id: 9075C140005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794321979-764020
X-HE-Meta: U2FsdGVkX19o5cFl2IxT/hjpZprwoh1c1o2DK8e/tBPHGUhP6q6BlxINf89a4dc0Uem+YEwpKpBCYMyc6wUnlifNzFgW2IVpfVKhWFOdTnasE/4tUeIHKK0lcRZy4gDb1apM29YYtVIM2sOTjcpy6TCm1N1LWrtEseAJSk+oayUmN5THpr1X39khEC60zOe0MMyClvnZu2EiiTCxjEemR5hpzoec5BcdKbSN7Sk2APSWIDzOwbllrj+qDkzo+v1J+DtxtckyavowfDTTKSXj3gwiwxKPBkZfcmzrt4C6X10SJCKN1IHGOqjOg5COi2FpTk5U74Bq6ycOUU2GhGcTB6K0Csx4o3Y4B5T9PXBjEGChUP7r4aJes5/IHWo8B8jj9ypz/psrIGIZF+CfZIXGiKFP90ZdVx6nmMryl+oWFD5RwyNMPz3Fp8qIqB7L2D0Bk8nlumW1AK022Ox9gsPxWXaY+s5PNO0UxR94SDPohKFwcUA1tTZ2BjUOUaogppOreZzbgTC1TI25G0sB7WUHiuANfZc/WvvwT1kqj3tpsPc/7kVE7czffEuEJR5AGx6CtCWW633Jknk0khHxP1vA+ApZm0DPpU2hE8x5K2BjLpDJ6n01q9kMdYda5cDMheuh1XUB4CWgsfOOchMCHQBSkCMuAAxe9sAVC95EuJYErfJlapGzhfH9BqZOSsDtdpaOpxWP8nwydQGHyRGEpKCVlDAVOEraI7gPi7I4r0YsD2td1Wl2DqXFVbaVtJkHnPHzdGK4lEXgTb96fRtzq5l1F8sO8ffEQMjC8IeZQYURLDA/9J/1dInWMJJ0CLK6zEPRRyk80syY7fYdFKN7xVpEBZOd+fIe0wEVbHSVxM/XZRZFN7bsXvTAmSEJ1tMvZgo6SBgL61mAAUHeSuSisUgSp8CkehAXlDxHvXCZe7LbdekNlMVxN6eQA6quXaY4rYxGlp8DnjKWQ3i4DuXTUO6
 vbKfXMNs
 NHx0aUzm3JKo8ZTHXur9UFDxz6Y/Gj0Q5GfJ+KIG07ip8ef+Pu+RG+A5vaPMOZyoqhxnyVPKCMb8DHCYlOwg717H/7gvxSKrkWyVnK4YJjzBZ5r8+9jD7OO/TQqRdWPginolFl+PghhHECd6+DqJNFSv5eMzummdB60lWO4hMOCKkt4eiqY6bMdKhuEU0pSC1Xmzxo6uMnJqH5kcvbpUuEyT9aB1qX5oeYhjXLMX8tbRmxvyj157K3t+q6m30m1OJd+Sh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 10:15:27PM +0800, Lance Yang wrote:
>
>
> On 2026/11/10 20:03, Lorenzo Stoakes (ARM) wrote:
> > Given the current throughput in the kernel resulting from AI-generated
> > series, I unfortunately lack the bandwidth to generally be able to offer
> > review except in those areas I maintain.
>
> yep, with the AI flood these days, inbox zero just isn't happening :(

Yup, this is purely an administrative thing really for me. Some hopes of
taming things.

I'll likely get involved reviewing other stuff _anyway_ when needed. Just
need to reduce the firehose a _bit_.

I am also now very busy with KVM which demands my attention in any case, so
is practical to pare things down a bit!

>
> > I have separated the patches into areas maintained by David, Andrew, and
> > Alice + Danilo, so each can take the patches relevant to the subsystems,
> > for convenience.
> >
> > Apologies for doing this, but given the current trends I'd like to do
> > something to make my inbox a little more manageable :)
> >
> > Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
> > appointment as co-maintainer there, I have no fear of needing to step in
> > there, and so would like to record my time in that role.
>
> Thanks, for real, you've done a ton for THP, and it shows :D

Thanks again you are too kind! :)

>
> Acked-by: Lance Yang <lance.yang@linux.dev>

--
Cheers, Lorenzo

