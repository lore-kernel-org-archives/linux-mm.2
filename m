Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67848E92FDA
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 20:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2D26B0089; Mon, 29 Dec 2025 15:52:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89AF6B008A; Mon, 29 Dec 2025 15:52:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCDB36B008C; Mon, 29 Dec 2025 15:52:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AB85E6B0089
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:52:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 789EC593BA
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:52:44 +0000 (UTC)
X-FDA: 84273707448.03.E9E4100
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B9E65A0013
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 20:52:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UgX7+Akl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767041562; a=rsa-sha256;
	cv=none;
	b=OmPUg64zNZoy0NZb/TmvfUokcoMLVhRUcyEX/BnFgNkga4H5U6BJkUOeAGzEwk7wcPZtwJ
	A3uf6vkTqVaEXjhuGyPQouVE+Hzt19EDZui/6fieXS5uk89mL9RoZXFC6HSMeb7eIy9Olm
	1bUAduiAprLzxgaC7uFVxXMgt5riWlw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UgX7+Akl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767041562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFOfciBWxGED9ovPE7cH1JV9gALiFqQxu0wxUOdjvnE=;
	b=8O1SKLPpAvhGcIFSA0xTrIghXT4eJrfgckpnvrRxIO+MtbFAC63agH2D2UlO23QnfZhcb6
	JMXMoi8C2Tjp3IksKBqFx3GG+t5eKyf5EAGaXaSQE44YadpYxUvPBqSLPx/rqKHNg9p9PY
	U9lq2WFDLhyebnp7rDHRIUGiBj7uz2w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E3E6742A99;
	Mon, 29 Dec 2025 20:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5167C4CEF7;
	Mon, 29 Dec 2025 20:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767041561;
	bh=MwPgzvD78n3pW90vWtwAVJoET5+u4jzMiVKZ1kjYoMM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UgX7+AkltaYMgD/psdVzZtaRdtN4IQkW/L62pxQLIpOZU5+2igPik9iHaYIuXbpvn
	 lf+6ZtmgovxFo3WJ/g5L6uwhSXEko/5MDlib/U+xUEZlrqWeBeELPMqGTtB0NWebdA
	 tlL8FScMql/gqwNNxDZXkYeoNAFrKbJsZJTsgDAEQRI0MUx67zlDWAHtTzRHv0WN+v
	 hzH5NVYupexrRdVyfO1thgNLpV604PjbDfTz9Fcw3H+ZCPMkJKkNSeI8szZcV6vCbB
	 uvZe6Ewy0vj89rsxgYcrgjxOKXpkOLc6mUZlDGceI9K/HvTvMyM/1gaeLqKJGSU80z
	 d3ntCSsWSi/IQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alexander Graf <graf@amazon.com>,  Mike
 Rapoport <rppt@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kho: simplify page initialization in kho_restore_page()
In-Reply-To: <CA+CK2bBv2wpduYQF_fwzciH4HxZ6eFjwZMSpZwW0AC6KXL4msg@mail.gmail.com>
	(Pasha Tatashin's message of "Tue, 23 Dec 2025 12:49:39 -0500")
References: <20251223104448.195589-1-pratyush@kernel.org>
	<CA+CK2bBv2wpduYQF_fwzciH4HxZ6eFjwZMSpZwW0AC6KXL4msg@mail.gmail.com>
Date: Mon, 29 Dec 2025 21:52:37 +0100
Message-ID: <868qel9fje.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B9E65A0013
X-Rspamd-Server: rspam03
X-Stat-Signature: sw83o5rfdccfox785djpw5ukwscu5eoy
X-Rspam-User: 
X-HE-Tag: 1767041562-196822
X-HE-Meta: U2FsdGVkX19JtT177MHd9jKibSJJ3XG8msmdsrfE58JmFkjrG+wDJ51PmvkS7PD1/d6V4mkr5UFGtnVKqCvqgqjEZDaOXylFKcBnYjRXsnfbqEjyfuZhLd5783AbXIaL7oL4k9TOdOV5E4cfs6FKwTBfKoanUNR/mpMaHRInYYBvzerxDVxOU5W8PKEJeBV+vE1fpc4JfEENYIFZqhCpdDRgSnktG0BzbJ4dskMJcGLnQ4mM7OpFnl/KJmP7NAt8ZwG0yBi/V1P32NQRagKTfDojM4Xlje1PmP6nvvDASHAGdVuEFkjZNsY8vecBv0BA6CzCZQ5t5sEepJdKT+YnZ/5bH0rB9KU1D3rC9Yob5NnNn/2vi/hUhTVHu0lVuregeLXccAwo7JxrzT4/evI4npl0lJSUzdJcoLJY3iJPasL6GnTl+Qvt0iP3UMDktgO94gX3aMdSA1zXk1BycKfoIlAUS8aZwBVC6PLPzJ1URGRIj2+gkaxSN1g8UnZRieA8w29RR8T0WadHVKShogccanNPUAw0WwHuuzCPITHHNVx1QTxJQZzdQFrtyHyPYXAyGpLd+8RV3/k2r8aYIx4p0Y1oG5fIkehzksUqCzGT4AkqZ1BJB6EKHjEH9PEH0A1oewejkYYGTEsXahESUgW+jBsIph3lyxfGr4YV5i/BW4HEvoyAB60Gk5eY266mEufIlr66L+aDIrvmgudPqQcmWbg+oyz62t89DBl79Ox4nwQALBQcmO6RSwg5+VVO0/zFQ9fCqqXPihkE45hSYnzYPlQB8050PX3e05elHaE5JWU3vYjZQF5lY7kWYBrBvbqw1njrmfeJso3v+r670LuzGquWpIy4qZ/W3XQrelAc2g0KMG+dgnLAayEUacitA+nfB0HJpcZiCLdmpxSOoWcy97WWbRC1/Z4LXaSqTb/tbOb8QOZAs1RaeVrvABPVs1iVcOr+zgfjSQqTDB6tWpd
 15ef/8xK
 RHosa6aEy14DImvAaTb2w3HxPHAMfmyVSIePXH3bC3abRVXeKQmint06d15eTwe9QMPnqi3huYvK+C8/G7SiDoGBj9JaC4dukHRM/a6YyIKegVAf/3yka0BS63p9OmiP5JNKYPGKDE2himf0AS6RkszuUR+1N1fdOTHoyLf/onGa+Zl7J1F5I35Wwe2wBq2bbO7HyM+Qz/MFA8HtD/eHu+ppathkjsNqZpHsG4P6QThoBjSeX0XrieWd7G639c5PX1MQYa9doqzWUdtwaQAvvYGV9QrBWzvgBr9TG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23 2025, Pasha Tatashin wrote:

> On Tue, Dec 23, 2025 at 5:45=E2=80=AFAM Pratyush Yadav <pratyush@kernel.o=
rg> wrote:
>>
>> When restoring a page (from kho_restore_pages()) or folio (from
>> kho_restore_folio()), KHO must initialize the struct page. The
>> initialization differs slightly depending on if a folio is requested or
>> a set of 0-order pages is requested.
>>
>> Conceptually, it is quite simple to understand. When restoring 0-order
>> pages, each page gets a refcount of 1 and that's it. When restoring a
>> folio, head page gets a refcount of 1 and tail pages get 0.
>>
>> kho_restore_page() tries to combine the two separate initialization flow
>> into one piece of code. While it works fine, it is more complicated to
>> read than it needs to be. Make the code simpler by splitting the two
>> initalization paths into two separate functions. This improves
>> readability by clearly showing how each type must be initialized.
>>
>> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
>> ---
>>
>> Notes:
>>     This patch is a follow up from
>>     https://lore.kernel.org/linux-mm/86ms42mj44.fsf@kernel.org/
>>
>>  kernel/liveupdate/kexec_handover.c | 41 ++++++++++++++++++++----------
>>  1 file changed, 27 insertions(+), 14 deletions(-)
>>
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexe=
c_handover.c
>> index 2d9ce33c63dc..304c26fd5ee6 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -219,11 +219,33 @@ static int __kho_preserve_order(struct kho_mem_tra=
ck *track, unsigned long pfn,
>>         return 0;
>>  }
>>
>> +/* For physically contiguous 0-order pages. */
>> +static void kho_init_pages(struct page *page, unsigned int nr_pages)
>
> Here and in other places below, it is better for nr_pages to be
> unsigned long. This is consistent with other places in mm, where we
> have gradually moved on from int/unsigned int to unsigned long for
> npages (see gup.c for example). Otherwise, LGTM.

Thanks. Will do.

[...]

--=20
Regards,
Pratyush Yadav

