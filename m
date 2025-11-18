Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70E7ECEE341
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A685A6B00A2; Tue, 18 Nov 2025 12:11:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19C56B00A5; Tue, 18 Nov 2025 12:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956B16B00A6; Tue, 18 Nov 2025 12:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 804BF6B00A2
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:11:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B44BC0151
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:11:32 +0000 (UTC)
X-FDA: 84124369224.21.AE6E9AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A16E120015
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:11:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q45YUTFm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763485890; a=rsa-sha256;
	cv=none;
	b=d498cpz5vgBECA63p2/lKMrDKrtmQm3lvUYamjd51oB4y7DlZ+8TTdI4d/f1ZIrKry09SG
	4cSa/Sb2t5OrrKxtq9FYnEm4aR3lApHfUaQwiuFJTxRkDbA0AhcV37zYeAypLK39BHd54p
	g3RKHs70ECpZcVKxTAO8tkT++Dlgkq4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q45YUTFm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763485890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAuXzOsPqw0m0YAW+RsjDAL9ltpp0Z9O6eBfwFHYa0s=;
	b=x8BU7kM9E5CLfpN6oznnVgNRq7BP8bnGTeIHwuF+c07K35O6cLzdHA6aBNoyxQFir6AINX
	f0ciUm42Zb5wZmcfmcNMLHcZf0i3Iw1gDlNxZfh0q4tFK7eT6m64lBO/5pLgBQWfbg/E+S
	VpnnLfK5iT7jHJlc2fABdOoQEKuHwLA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F259C60C08;
	Tue, 18 Nov 2025 17:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C666C2BCAF;
	Tue, 18 Nov 2025 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763485889;
	bh=5JkkdNYQ6lS2Vy4m/7JD+soJwbTsSsI1qxv44jf5Qxg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=q45YUTFmc2JS/qJay40kgKnFUmQ23dQg0nbzqsc4QhJBmpbi1vTPRw6OWwKG4BUcX
	 5BB5rsvuq3xfamLRyekbtfqb5Qq96QILIPWV9ShluHdJqk6L9RaKTwE07NTJBVpN6l
	 5/6dj8Q1ySwBu0wJdfpl/NMdhwU/fXYcZS/0AhE6+5SYEDR3kPJmeH+ya98T3ciyrH
	 asJ1TaOt7XbkJEtOe7PWaipWGFnIjO8gZEQOVRVgdx6Kkay1IA0WdBQhqgno8pkkKL
	 T22fiGxggOUmugSmDqvIFlJx8Qn6vRwPchjhMg7GDxxLmb+KfGjx0t0aiD+8qjyhm9
	 7+6cJWGnwV8LA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  akpm@linux-foundation.org,  bhe@redhat.com,  jasonmiu@google.com,
  arnd@arndb.de,  coxu@redhat.com,  dave@vasilevsky.ca,
  ebiggers@google.com,  graf@amazon.com,  kees@kernel.org,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org
Subject: Re: [PATCH v1 04/13] kho: Verify deserialization status and fix FDT
 alignment access
In-Reply-To: <CA+CK2bDfrx21=Aw3pwPn4=AKGVeh0O+sB5gp8rvh0fk8C_nsdw@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 18 Nov 2025 10:25:37 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-5-pasha.tatashin@soleen.com>
	<mafs0tsyw7e0a.fsf@kernel.org> <aRhJk_Glv2pX2dRo@kernel.org>
	<mafs0qztv4gw9.fsf@kernel.org>
	<CA+CK2bDfrx21=Aw3pwPn4=AKGVeh0O+sB5gp8rvh0fk8C_nsdw@mail.gmail.com>
Date: Tue, 18 Nov 2025 18:11:24 +0100
Message-ID: <mafs0a50j466b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A16E120015
X-Stat-Signature: pswk763durrty7c36ms4w1n3xueyce91
X-HE-Tag: 1763485890-888180
X-HE-Meta: U2FsdGVkX18pUw38DeHIXq034GCo+J/eesMJHf2bXMnLv9/hSf9fwmRvViy8+jURZmWjDKxwAqHrNDBHV4GZJvix6rFFEpvbqkNExThKqnj9gL42JQC2N7CAbtIbVuaddyVMQBog3D3173T72gVy1YXV+eJf6bR2WOL18ulAwPCB74ZG6ddDdNgJ+In5cNdnlm8Lhk33JPdaHeP2dh8PDnGzX77xR0fMk4yVT+9klewELqzqtNZqnebOR7RXXSZyzMLQIA5+1CKCBFXVATEeEJzVedY4J/a4ciN0HAU5bwKAOvAAjwW4qmCSiNkqSGRpn2dKg5+olxnZDxhEjIPWrP2m1WiVQnF+8G0DFCBYDggXCNeyyHpnHOOzFm0RA1A7Zyg1MN5zxyVcV/qVaE2iwH3+IxJok0VKCE1BYkYFcGXYNbp/n/NDwx1gyNjNug42MZZVVuJ8yf33yM2lWnrysDnOhp3rSl2eRhsXvB74lGcJtmXzDKv/OpoWeUqnfrdWOUjAvHDrUA64ZmrWw5NSWQTTf0CivO9a9B8eBxqM8SjQrS2DAcxKKdhdTnWmAXzKqwKq/yNMfB9Ogt7jHqKyYzmEU55uhSNPhLYpq6ZOj007SaOPlnc7pC/6Lg0m4e/U13qGdswUis4H19+XDuQV5ZJ/Yk+ypv5E9PYTGwPNull93hrb31TFXeZ7Ssxdd4qgb6kd/1kXB7M/ADka8Z0jamsFpmKsEt6oauHfTtLKQ+mlLHNIdI5g6gBeRfMM7pv47e8EnDphkJwoPOyGVQ2Ttk/Ggc0kQy9qiaJxcneXKHSTtGQzTnBig24f8UV07TT0Jh7RhlVC0HkEIephI88Vy+fU1eOXrKIlZr5rLQqnzp8UZEpZceMIF/m2xmH5+z00SuCUy2CCimqGPQbW9rCiCvWKkkh9qivJ0hCDLQQDGgHYZzFHbsi2ga2ZOKjDhny+b02+8VYt9ycdCqPa6fI
 ZXHe6Qrg
 rDbUoN5rdQo0RHohRGd86iqB/r2wlwhz8sM4U6fIspMD3RIKD8/nr98Qxik8mQt45YdOKIzwadix0/GVY9loiFg12auTXmmgyhO73CcHhFKZPuo5kWxVxuNgugViB7pWX97BOvj1dwbiuvRcyRI/Gw3DV6wR1bUkzYpdSnPeT+STbnZvihLf9gOmYntoHjTBsaxma
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18 2025, Pasha Tatashin wrote:

>> > This page is never freed, so adding it to zone managed pages or keeping it
>> > reserved does not change anything.
>>
>> In practice, sure. I still don't see a good reason to _not_ initialize
>> the page properly. It's not like it costs us much in terms of
>> performance or code complexity.
>>
>> Since kho_restore_folio() makes sure the folio was _actually_ preserved
>> from KHO, you have a safety check against previous kernel having a bug
>> and not preserving the FDT properly. And I get that the FDT has already
>> been used by this point, but at least you would have some known point to
>> catch this.
>
> The kho_alloc_preserve() API is different from kho_preserve_folio().
> With kho_preserve_folio(), memory is allocated and some time later is
> preserved, so there is a possibility for that memory to exist and be
> used where it is not preserved, therefore it is a crucial step for
> such memory to also do kho_restore_folio() before used. With
> kho_alloc_preserve(), when the memory exists it is always preserved;
> it is gurantee of this API. There is no reason to do
> kho_restore_folio() on such memory at all. It can be released back to
> the system via kho_free_restore()/kho_free_unpreserve().

Even for those I think there should be a kho_restore_mem() or something
similar (naming things is hard :/), so they go through the restore,
their struct page is properly initialized and accounted for, and
make sure the pages were actually preserved.

Using the memory without restoring it first should be the exception IMO.

-- 
Regards,
Pratyush Yadav

