Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61597CAC5A0
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0C58E001B; Tue, 16 Sep 2025 10:55:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88C68E0002; Tue, 16 Sep 2025 10:55:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5428E001B; Tue, 16 Sep 2025 10:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DBA38E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:55:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 422351A0108
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:55:27 +0000 (UTC)
X-FDA: 83895411894.28.721EB78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id B083140013
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:55:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8BnDxmd;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758034525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R9lgwDHev4dU38X0FYweEhf88k8Y+x8k/AuD59Ougps=;
	b=hmWsPomWbQARG0lq+g3k7FAEwrOrpR/iXR682J0ltGD6WjS4Y3BnDctcPN1GBCI7MBbNhC
	II2SgZEuba+nL5DuK/jioJn3epg5eX01IN8jpRqmah7YRpNNjvqa9BHodI5dVkWVxtFh6/
	UGV97wmmvIF02uv99z2k0XUSNlQNY8Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F8BnDxmd;
	spf=pass (imf01.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758034525; a=rsa-sha256;
	cv=none;
	b=NIkcDo+H8WipRmZ+pUg7GmDd2cuI0tXO2UkyI5s8TKy1rreQ7Aty4C4kQXWGygSRMYbhLK
	3A25c5IS2RBSbFjabW9v0LejYLhwCD6zYm5nxJKjO3Aw844b0hSYCbCpk/mDpoQmUDcPr2
	bWRX3wWzNBfdq2q0sHg+z3RgJXh4Vg0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 11F01601AD;
	Tue, 16 Sep 2025 14:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12B7C4CEEB;
	Tue, 16 Sep 2025 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758034524;
	bh=+h0GgC3LWghF6oM5gQKsTZ5ZQF+Tvm787123O9K2VnI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=F8BnDxmdN1uLoWQamCkXCpbCbGajjH+Z+Eg8tkf1UcJKxqTTVmOev//JQa5hWNpwQ
	 i8HcFmF6APK2Li5miaU/G5IkGv+kmRhTGx+ussnfLk7X83mGUzB2bwKyvgUGg8cW/q
	 baII0v+rlbsJ2MwA1IYCgdvx+L6RRPiwlvJHlIts93SEPz8bytiW7lMKzjLSVjDuXW
	 PMWCX2Iv1vzFPsDTHZ+b135cCz/pXlvVTtbp8b1O2yccMTIyYK9VrmtEQ0aRldQv69
	 77xlzKdpRw3QPhyd18JUFu2d1oKDWMhgxpWtzgxjeSQYpXtFFeYOGSYfhjyMjKqLdu
	 50PtUC1KkbM3w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Changyuan Lyu <changyuanl@google.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Baoquan He <bhe@redhat.com>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Jason Gunthorpe <jgg@nvidia.com>,  Chris Li
 <chrisl@kernel.org>,  Jason Miu <jasonmiu@google.com>,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org
Subject: Re: [PATCH] kho: make sure folio being restored is actually from KHO
In-Reply-To: <aMl2H3BLpH3xFCOw@kernel.org>
References: <20250910153443.95049-1-pratyush@kernel.org>
	<aMl2H3BLpH3xFCOw@kernel.org>
Date: Tue, 16 Sep 2025 16:55:21 +0200
Message-ID: <mafs0h5x2h2g6.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: B083140013
X-Rspamd-Server: rspam05
X-Stat-Signature: pes1zybniutq4jc8bbdadwibj4okmnz3
X-Rspam-User: 
X-HE-Tag: 1758034525-243121
X-HE-Meta: U2FsdGVkX18mlkJB1hZSk3V5LKakqazK+uxdha9kmxVPzYEhsvinwJZyDpNALhZMsqJA+UGGI3lzgJfnV1H8iiYaXTDwC7EDT+ZEj0DrmLMdh9BrIHM7K1XHx8QkMnuSSXaLqohSOg8lX9nPDQCFQcGESKhVSGdP2Wp2234FkRb4f63s8FQ1PmRux6DC3ET4k9IM+GwODcMOYrMHz4ObWZ8EoalRE4ekbvaWCTJA7N6yu5+8bgkA1RIj3DBlDdLIQePzYh5toz1AFpC7/0hlVcQw1OHm7aG29MQ2aIiU+1s8wAjGTI1H9CBJJSa9AiZ4q0zNC7jy5kaoSHgn+UQvMXDa7YeaTaZoxr0eZg4xSfGoglUjbxntx8XqHec9kE/c36xlLKM/T5OTeIaOYjWfl4ojhe31tHZNxnsLBxINWfS3OfrFRtAEQNt/900l3eSf6YscuNDU+XpQdORd2frrRcwfyFsKTJCupTsmbvLiUaU/FBXMKC/G/GRQ00pFTYHBDp4NRb4Ba+Rzo2aCl7mX1VIUWpFiiy2p/eOFedkyxDh3aE4WEWWuqjUJQpEsMRiF8P2Nn4+vbIEOTrFZQTrTLxd8T387Fa6RV83vzrBBcYVAEYaQrIVwIzeD9m/9N5hvyjcN4C/Fbw6Zm+bCzOeq29up9cpV7AYITM8qTWXBuE8EXpkqXbkQIy6UVv7CyCgWaG/nq2ZyTn2TDRUEHwPOoDZBP+UdSKx7BIJsDdxc3c5ozwu8SBiV8j5fVML54h8w48ofjKlV/mbYbz4VjQu7Yh2nWB7rhPtvwFGheijPxFQyHrUukapC0Aq6k13CKsB5CaHX001k33QofIUPXNeUAH9C6jeClR01wt/ttUJI0vN/izeHhfOHx6skvnCWVMumxcTgyrbx9gI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16 2025, Mike Rapoport wrote:

> On Wed, Sep 10, 2025 at 05:34:40PM +0200, Pratyush Yadav wrote:
>> When restoring a folio using kho_restore_folio(), no sanity checks are
>> done to make sure the folio actually came from a kexec handover. The
>> caller is trusted to pass in the right address. If the caller has a bug
>> and passes in a wrong address, an in-use folio might be "restored" and
>> returned, causing all sorts of memory corruption.
>> 
>> Harden the folio restore logic by stashing in a magic number in
>> page->private along with the folio order. If the magic number does not
>> match, the folio won't be touched. page->private is an unsigned long.
>> The union kho_page_info splits it into two parts, with one holding the
>> order and the other holding the magic number.
>
> I think the sanity checks belongs to the core kho_restore_page() function
> and kho_restore_folio() should be a thin wrapper for that, at least until
> we'd need to allocate struct folio there.

Hmm, okay. I can do that for the next version.

-- 
Regards,
Pratyush Yadav

