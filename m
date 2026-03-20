Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C45AA1099B20
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F5A76B00DE; Fri, 20 Mar 2026 13:10:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6B46B00DF; Fri, 20 Mar 2026 13:10:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED7A86B00E3; Fri, 20 Mar 2026 13:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D70B26B00DE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:10:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 843395813C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:10:27 +0000 (UTC)
X-FDA: 84567080094.06.B41EF3D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A94C04000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:10:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bXKnbe/Z";
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774026625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m9gGuiyQLPdmvv2/7LJRMDUMWYouWFgZfsnWMBTd7W4=;
	b=RycxJmJHsMZ8hmx/tPkRQvA4HIZNL427Gfofsg2p8Nq9JwTUtJWZwHJFWK2kCtZOWCXEz7
	thksbZcV7V73D4NLkCim9GtI7ZVXZcQ+F70+RBu5mb3KuYSc8WWwpn3rf9yW3jyVrSesQD
	5BsRNeFB6F433YqhVNhivBxfzIRxqnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774026625; a=rsa-sha256;
	cv=none;
	b=gkqurNo9fEkbbZbl/rQ740NLbc8lJZzmPoVZb2ltCphWb1+qgoRvyksqy5hSKmiRuSHfMa
	9n3TLXuKmC+qh97aQHXjIrOtgsg2Ba0L9MzDgGnO/VyF6TPFW26t3bYfoDFScHdLcGwxXn
	7E0wRxtyDfbnjX2BxrmV2upaO+337lU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bXKnbe/Z";
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B220843249;
	Fri, 20 Mar 2026 17:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 920B9C19425;
	Fri, 20 Mar 2026 17:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774026624;
	bh=r+p0YZoMVI7AcM9fsFhpiDTl7RR8STO6srhIbYMdrEs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bXKnbe/ZTMZYKmKswyp7UUNW73CC8ocNdqBGJpBjO2IEcg9klGYzKBTbn7wS6145o
	 bDx6yp6E9EoRlfZ1nChN/6xzDyc02EPnVKbzAT5MkJBM1x9r0U7ISiFB9ZK42TeeEV
	 NPQS0N+PInTeLONogYKmUybb5i5U5KXxX1g3XFI6v4Zk+gmrInpHhro/V78ZwgDZBl
	 PDIKv//vs1fkzlQQJXNTgc0NCf5mfA5lg8S5iRTjU72SybGYa8zUxK1T+5C/DsgByO
	 n+gWOBmyWdE+bwHdB8VdEbJ4rsjPU2AaNHeRHUcpRTiT8ZcyJgwkIBZUDTaCXbxgBy
	 oLeo5Gj5w1IGw==
Message-ID: <e3ecf76a-4490-415d-9d52-dae478ad43d7@kernel.org>
Date: Fri, 20 Mar 2026 18:10:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/16] mm: various small mmap_prepare cleanups
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1773944114.git.ljs@kernel.org>
 <498a579bfbcbb8b0e4a9c39243b4454347f03a46.1773944114.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <498a579bfbcbb8b0e4a9c39243b4454347f03a46.1773944114.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 17jkqtgyu73emo13amguzmq7r96rjtb9
X-Rspamd-Queue-Id: A94C04000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1774026625-876991
X-HE-Meta: U2FsdGVkX18ihDmq9OFO7P0xmo0bcVN229gYXWfRn1Kz50JaoCeBLq1KZ+iAc0BcHPgzgu1ZOBW93ntYC/1xVO00cIPGrIXjm7alPPN3BCLBzpLxC+Qyq+58gv5YNeYctGPetud+WJWwq0UVqEtE1ZBtOhT2QGcEntDFK1IC4sW5jIDsNYppBzCpGLlKkp8zhBBlVGroGWsnxziXtorZ+caDJce1ypVJKMuCcfEh8LkYzv/PFfeVOiwjUFUaWhsCzGhDMoM1Q3K7UzhdM8by/fT1PX7auxSq39kIjvGh53O7JpNQfojT644sSbxkz/XePTqheSXF0K6VYnaOzG2lOeYoowbFRgYexgWCg4277PjFYl3rvz/VQdtJgKKl9U3YEh7FgQxC1+tBmyphdyFvfoqhNMohDsV8B3jAVfV4VTwQjMo8UoYYBJnv32X1UV6pkOu5GeINhvRdRbz9FqB49aE/NqBa0dcAqfDaratvmrAJlJ2u0R8vr0lB4v4ft0yfjwpPUw+6e9DIz/OE7Izy2htgw8eOmRNYRtsYbT/1jshwUBo/ZC1MzzD9rdWCA96KojudYJPurm0Rd8g0v3b7/GDI2K7MDYU1MxeUKtGsdYGdtYFd8m6wO9xPhwG5od2mxzj/u50xMW4mnyLYZnJjspR8HRoN4klpsRtMVVsC2uXBFVMbl3yxz6EvHHt23UYOFk1hR5aC0d3fve1aiQjjZuXJlXV4WcIPkGcRgfuMMDR6kQGZceKtpKuL/MRpKMygX4CZ/GY6hsJ0bZiWFy92wN+BvNRuiuXRLgIc83oOmcYjE1hKprnQM4yFPdCNZwilMnAGrFAtywUE5HgAbowwTBOboPKRZfa54m30JhAZt1/tixtDBLRch+L/i8+6PmBhKL1dkFPRPXdZt4a9wjDOUPiuTNo4xLEH4WEJjfcDELi5pyC/4LlxQuNZqbZm1UYRPikGZFkGhgrTEiDRJTu
 iooTEiT6
 6tZF9+fiw+IDS6PbJo0zU6P3qtJeElnTunWsmEl/GA5orVO9C3SoC1iAGkci84+6mrvjmlMQAHj3K+keoH3Z7gufgO+w2XS4uhCQbtbASn0qJ4fNeSEovsfGEF+oG3iGtWQiAf3DpLrto8FhcIPNGSTrgQbG43x931BXfIxXf2NwoyCsCaZvR/rcllwuPa8KR67eHCNlVCFH5iFNGOwELSKteaIZl6WsvpwM31G8wlbXlaxwvVsE9L7eDR1hcylf2LbRcfZe5KA/Zmcyt6QvIi6Gfn6XKBG6Xh2fqWnnNZno7fgCC6GLMKGYU9nmNVGFzLU0JqNXZZpYjRPYTeqlRYoDf4KXVd0/G4ccqKjbWZZDy50kyeYpKE32RA3/EOqbk0Q7/QGNc3mvrt1LnxXW0Z3yVBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:23, Lorenzo Stoakes (Oracle) wrote:
> Rather than passing arbitrary fields, pass a vm_area_desc pointer to mmap
> prepare functions to mmap prepare, and an action and vma pointer to mmap
> complete in order to put all the action-specific logic in the function
> actually doing the work.
> 
> Additionally, allow mmap prepare functions to return an error so we can
> error out as soon as possible if there is something logically incorrect in
> the input.
> 
> Update remap_pfn_range_prepare() to properly check the input range for the
> CoW case.
> 
> Also remove io_remap_pfn_range_complete(), as we can simply set up the
> fields correctly in io_remap_pfn_range_prepare() and use
> remap_pfn_range_complete() for this.
> 
> While we're here, make remap_pfn_range_prepare_vma() a little neater, and
> pass mmap_action directly to call_action_complete().
> 
> Then, update compat_vma_mmap() to perform its logic directly, as
> __compat_vma_map() is not used by anything so we don't need to export it.
> 
> Also update compat_vma_mmap() to use vfs_mmap_prepare() rather than
> calling the mmap_prepare op directly.
> 
> Finally, update the VMA userland tests to reflect the changes.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


