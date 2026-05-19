Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784DCCD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51E56B0092; Mon, 18 May 2026 20:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D004C6B00C2; Mon, 18 May 2026 20:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16746B00C3; Mon, 18 May 2026 20:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF0586B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:45:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C4EBA00EC
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:45:47 +0000 (UTC)
X-FDA: 84782326734.07.4127625
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9EACC140005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:45:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EL01RY3P;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779151545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+RrnuFo2PKmJ5Gg+8jArtTsfwn/lqYsbwGaOICtbs+s=;
	b=TUAlia6snxYYMCj6ShJhWqa85pJaml9uE/8Ox9cQ2h4b4igGq5XPkfN9ewidPkORXH+yNE
	5Ez+5ULFcGq5U967TkIXEN5oD3r7Qcmq8dqGoLLRVpuw/FQO9MoZUwAHzUXitmd4eloSSE
	Hp1GvNK1xIo44gvQk5gFDA+cx2rZHZ8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EL01RY3P;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779151545; a=rsa-sha256;
	cv=none;
	b=bhVpMp5ZwKxCSBkipX78TDK+/SbbbNZOqKtx+574uhuPqHm36DIPysRwIL3ikUsSC1EpCE
	rgNO44q3vCmyMV2hnvAEoA5xX42oJrx/3HdEofUdFyC+sRqPXDzFLX4mVoakSqpw71028Y
	yyPVw62iWKt+PFLm4ma4tIhv0NnCwMY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 051D1600CB;
	Tue, 19 May 2026 00:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954B7C2BCB7;
	Tue, 19 May 2026 00:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779151544;
	bh=ki8yhdn7llRk4g0Kq6LtI5PPviYPxDkGQNJRCkKty0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EL01RY3PGeBxGh5imSgwpAxABdUA+2lJwWo6MKl4VmmJ+isKIVk6cukTnjduCoAMz
	 qnFiF/oOE8BhagrtdJkkBTyc5ahNVbb+jDFiXloI0WvHQO1S2FntkqSQFXEwI0Exuk
	 IMvtshuNmQ+q2ew9u04tLdC65yNvaMPDaWUOSFZY=
Date: Mon, 18 May 2026 17:45:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Song Liu <songliubraving@fb.com>, Chris Mason
 <clm@fb.com>, David Sterba <dsterba@suse.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara
 <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan
 <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, Luiz Capitulino
 <luizcap@redhat.com>, Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Liam Howlett <liam@infradead.org>, Mark Brown
 <broonie@kernel.org>, Peter Xu <peterx@redhat.com>, Li Wang
 <li.wang@linux.dev>, Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v6 00/14] Remove CONFIG_READ_ONLY_THP_FOR_FS and enable
 file THP for writable files
Message-Id: <20260518174543.eb80758a66e87631b3a4dd14@linux-foundation.org>
In-Reply-To: <0FB04D3E-489A-4ABF-BD04-EE735EAD6F25@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
	<20260518152116.840e926e9992d47c9b3e33c3@linux-foundation.org>
	<0FB04D3E-489A-4ABF-BD04-EE735EAD6F25@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EACC140005
X-Rspam-User: 
X-Stat-Signature: ciuegqb6n5jw6roya74xsniwpwudj5rz
X-HE-Tag: 1779151545-412706
X-HE-Meta: U2FsdGVkX1/W7C3reCP6IfY44I/F8ukbbAHJw1zky6LqfTvDIraYEaFMYEa6+u9iu8DgYt81kAms6A886LIlNVjJ67M/X/imYC96SagQ7KxJ+k2w9AkanOoXeIAzKViTefjBGkba1ddMBwPJGtg5MplrMHLdbNR6tPLqJpBz3wX43RRO9wISI059mJhuzSff3Bp0RcAFReiddndUGvyC9LqYcAQ8UKdmfCatvuhYtpTuis+HRpJUAeN3OUv60rfuFUZjHR0jIruxY0PA8Jxhhr5krz8zsB6IsTUKChch8fSAnxsLZCHAvezFxBVv7+5F568px8ZWsfhRYdVnHvAQWNk3B+SFUv0h4P6mIeS/KgrMunYdaAEOpbqQWlQInWXwX827Zmqa4Z1+NyphLvN7GprrZm/4SChxXxyChImkyqhHQfxS+xLRnjLjl8Ac1MxzAUJOdWi/LvyF/Bng4ClYZd4+5b+A9jmPfP2mcRcr3ukXIBxaGmnRQJZjSM1UVfnZ5ySptXcSdzLaQpnhM+YlmtqwN23w1GTt83fGfeANMcJetsHg5cti7eXn65lMhlbfFwvfVDZs7p/edtLEiT3UcwFNB4KAYMq5OdR2s/ieQ8o6r9iPKFrK1Ly1lZg/9B5Z7uoSvAV6ugc9fMRlFbSu0Uke7jVWcRVEmvOiIX0BUPboNPL+Sgf/nsAXihMmDatJYu5XTT9i5xJx/ZSQ6wjeM+IrMwoHkRMWhSLEgomebI9kYYyVw375PX9NYSEDSx9zQj+icjJBDnTxY8fQC4Dxc5t+SBU9hkHcSjgui70IVb20dQ9b2TOLpYNcAXOGV9TIKHybqwWBAi5wjL2+jLFgrWtbQLFy/57fMEh9gYhNuDW9r8U1CJhhk3JXMWPSJh9HOnmtysWxguM1YtLd88We+JtM1qamIgjQXiJu2CxfP6Ywcbp/rPl5r/U+b9QYhOVUr5dnl5l6VoYacetRBxb
 bv0hUQJo
 IgEW7+jawID7CJd9OBwHYB6hh7qYZsTnx0C4qUa9UNHFa8XwfhBgFgwPviAPBZU1fkf9lJ6mQI6xyfXdVEXsVGai5f9TbVjKmphbAexxr8/2jpOYFHGG/HgyYQ4YAcphmcMGU7eAilIMPIwbjwlbKhUQB2keVs8yaAPtxH0JrujcMAegdIGf+mIT/Q7sJtQzte6Hi56j/aexEbjYWokEpVSEb27fQtmTLBW6aYOijh5N3lvttMmEYp2V1S0BQiCsnkXVTiKrZHmgEbNNID14xu2O7gM3GcQe2N629yzWGTb8DBhF9lumXq4zPM6MKIHVvpVtvVPYQvrUOV2STkLTmQBDBZOXT41FzrdT7XWN1vfR9kkRFXtlckXnOAV2qJfaS6c6IQsff+nMUh3+2wvgsPg0q1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 07:39:07 +0800 Zi Yan <ziy@nvidia.com> wrote:

> On 19 May 2026, at 6:21, Andrew Morton wrote:
> 
> > On Sun, 17 May 2026 09:54:02 -0400 Zi Yan <ziy@nvidia.com> wrote:
> >
> >> Hi all,
> >>
> >> This patchset removes READ_ONLY_THP_FOR_FS Kconfig and enables creating
> >> file-backed THPs for FSes with large folio support (the supported orders
> >> need to include PMD_ORDER) by default, including for writable files.
> >
> > Cool.  Sashiko wasn't able to apply this (presumably because of Mike's
> > CI-friendly series).  I take it that the AI review from v5
> > (https://sashiko.dev/#/patchset/20260429152924.727124-1-ziy@nvidia.com)
> > was considered?
> >
> > Also, please check that the below were considered:
> >
> > https://lore.kernel.org/e9e61132-902a-445f-9c4c-4d405d164e70@kernel.org
> > https://lore.kernel.org/22831162-abe7-4498-9e81-7f5aa3526d00@kernel.org
> > https://lore.kernel.org/959238dd-2493-4d9c-ac35-6d04460a8239@kernel.org
> > https://lore.kernel.org/1895A67C-BB1F-49EA-ADC3-AA4F51A6ED57@nvidia.com
> >
> > https://lore.kernel.org/20260508074643.55548-1-lance.yang@linux.dev
> > https://lore.kernel.org/b8a3c3eb-f241-40fe-9121-4ae5a1097807@kernel.org
> >
> 
> I addressed all of them, except the second one and I will reply to the
> second one soon.

Great.

> >
> >> is an in-place replacement of V5 in mm-new. It affects Mike Rapoport's
> >> "make MM selftests more CI friendly", since "selftests/mm: khugepaged:
> >> use kselftest framework" needs to be updated. I updated it and put it at
> >> the end of this cover letter.
> >
> > Helpful, thanks.  It was a little complicated because your email client
> > messes with whitespace (it always has!), but I figured it out.
> 
> You mean tabs become whitespace? And does all my patches have the whitespace
> issue or the one I put at the bottom? I am trying to figure out the issue.
> BTW, All patches are sent via git send-email using mstmp and
> I copied the bottom one from git format-patch. I wonder which part went
> wrong.

Your regular patches are OK - but when you informally paste a patch
into the message body the tabs turn into whitespace.

You aren't the only one ;)   I usually don't comment...

