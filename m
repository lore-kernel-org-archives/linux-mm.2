Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9882E606A322
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 17:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UJjjE+w/
Received: by kanga.kvack.org (Postfix)
	id B0A066B05B6; Mon, 26 Oct 2026 13:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1A06B05B7; Mon, 26 Oct 2026 13:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E246B05B8; Mon, 26 Oct 2026 13:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDCE6B05B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:26:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C75A9120843
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:26:28 +0000 (UTC)
X-FDA: 85365456456.14.183B87D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 26FFE40004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:26:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UJjjE+w/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793035587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0WoLkQVcDbSGumghdYohAdB7aedqeHVhzhgY1ziDNE=;
	b=VEDUzZoh+RcO//8rzzYgKDpi59n4Uy1dudlaB8Fxg1HQq7+KmcekUWDrE8igqJhO5FZ/Zk
	mUalwIgmnzd2Z2eAO8kgi0aH6uO953OjxDoCmNxoUe5MUfSdnIrZ4q+yS3PxrR2QZgnSRL
	MRj8BmcnSP1oFlqhllUNNUAateHuKWA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UJjjE+w/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793035587;
	b=epzhbkgvFTaH7/SUTbQBWwzw/sPhln2XSQiuGC0QngH8gcja49uHEW5HIRX0pTvyixILES
	o3BKwJG4CipAEKDEP/HhWmkpVB35TygM+8+r/q+uDxI6hfeHsVj1zsww8pCU7YlieP105s
	XaN6uPku/8pYzbNLlN/lmcnpJJj3TnI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3349F44020;
	Mon, 26 Oct 2026 17:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 715BA1F031E0;
	Mon, 26 Oct 2026 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793035586;
	bh=v0WoLkQVcDbSGumghdYohAdB7aedqeHVhzhgY1ziDNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UJjjE+w/YXLWI0UQBaYCVSGw3pw3SwVACw6Xl+vENBzMgcxNnqssVXl0whwdZzcFb
	 aC6PVbgiG6rlNIXffQ7/CSshM+uJ8wofvwoA1WQbx2twWv05gNKRg4zbsOownetahZ
	 gFqHdVAHaa3wyS6p0m6KygE/nIb9evXkgph0RHfLnSfIOwZgiTL9LSQdNGAF+1RSMl
	 IFjgRMmUPEb15cci+VVrTv/2t4ClbdIC5xeM+YipLCAN52E/YyYnQnty8bueg8Kjk8
	 V9EiWb/e5kJwlanYEdX4xzdWyceuMjAb6jV89DNZrgaxizTDfn/4TY6Ut2Hu0slW30
	 6xFiw0AichPIA==
Date: Mon, 26 Oct 2026 17:26:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix missed VMAs when reading
 /proc/PID/maps and friends
Message-ID: <at-M5hORjFt6aur4@gremlin>
References: <20261025-per_vma_maps-v1-1-c4eec45b9387@kernel.org>
 <at8-42OwXk2z6-HB@gremlin>
 <CAJuCfpFaxo06yHdVKsEEmFf9qoOYS0DbMvUuAZEhNfDe7dcwJA@mail.gmail.com>
 <8c5a8fb7-233e-4433-af45-b67cb2528b60@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c5a8fb7-233e-4433-af45-b67cb2528b60@kernel.org>
X-Rspamd-Queue-Id: 26FFE40004
X-Rspam-User: 
X-Stat-Signature: roxskj3uq9kw8ikmb7kojjasqtrezw3g
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793035587-16687
X-HE-Meta: U2FsdGVkX19e7ZCEby4UNogvKn4+tPjlWzhG/a8LPCpZcap8VfA3dWtRfW+/LtiDRin6d+sob52ApdUsyRv9qWO/84/PZWOqQDWSzmhLxPw8V3tbFERZHmgFnwSVq/N3YicOCFsXn6HJFiVgZpL10I3PpUK59koPGPnUe5ME16w9ZW7OYtsM0uD9ECHvV7gFoiOsuf62QKG+z7x+ERnIN+P3p+pKnvWbQ+hqtDU13mmdmwJl2N0CiMrpgFu/WZmTZmhm9xFWiNfpZ1+JJLSkS3YuSVeyj7cBAOgRzRb3KBiySUer9QbRtYNd6resmlFNW5zLxGqRaVSoH7I/obmNRjyeyilkMJKpwG2Io46j0RyKounBfv9mbx2nvm0FglKGG39eZk+FIg5v+tfvKSkCihhSD1OunuEImRJno13v17RI3Pu1KgsDS2Zz7VtMVIXyiBH9gRji8yUBK2H/cthaNx36LusRiHz/0bXF7e/3DRNzPQV/luGbqOgaMaxgtllog2lENLT9i67UlAyo4x5cizJhH7Ahj3Uf67Bo9cCxZGN3/V9rqzaHWdcAndQ9i3rvSG6CnwD3lcKNzNeEbwhQX/2CbJfS5ag57ep+CVGQCm5C4N615KlDLn3UIiklRilJJkSsLrU55igsyVAjYuKu7brRmlNMRPSzdGpYKtjJrZwgTIXLCrj0JFJ/n0QgwkfndUvb+4DEwOh/qep7zDtnCfnquSyN3j2vIpFMrudJhc/2XkqWiBLiKC1fpEc0mJ3f/eBP2//TBnJbXMzO2uJbXKB5ecCxbZ6oSNf+8uXnTrE0HtOAZp4c5crgK2RqRNwN0upMxLypDyqrccc9618c44anUV0AytKEirqs9JwhaY3+56s8LlbKidwzpdIU5lunjWM3biH2fgeIfuRJGQEYdlKj6H7DhTAmH5cDkWFBsgbWuQQJT7ij7Mh4cxTSfPLmt4x9Eo7Z7JOdhBO/2N5
 ZyOIk+hj
 ekU6pu0kjtIvsQiZGPGndWaiespOTJwYY9DJF98Jkt6DeYMKjysySXlwN+sf8/PcvtP6SkExaMfCkhnT4EUv/fbgpPBocWi7KQc2uKOi+Ipl4ajTaG2P7Hl1DIjPKsMeZzumr/FGnLZ65gcMkP2mFq89mbTzOnsh8td0GG72Sd4jxz9t8iOtFKSZi/8SYWxxeSrPLmjPAupIdhRlonJiQ08SRw2dJU6WDehJeA8+WsWJySpKRaSw+hFXsC7DWm4ceVOXC1v/0OsCMJNtUC0oqoH9920pwmaxaiZOhS4i3VvZpz98I7nXePIrjeM3W4A2Q7FJf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 06:19:18PM +0100, David Hildenbrand (Arm) wrote:
> >> +       /*
> >> +        * No lock was held since the last call, so the iterator's cached range
> >> +        * may no longer be valid. Always restart by address.
> >> +        *
> >> +        * The vma_range_is_empty() checks below avoid unnecessary mmap_lock
> >> +        * fallbacks.
> >> +        */
> >> +       vma_iter_set(vmi, from_addr);
> >
> > This is clearly simpler but this unconditional vmi reset is not ideal.
>
> Yes, exactly how I ended up where we am right now.
>
> I pref my current fix as something to backport that avoids performance changes.
>
> If you two disagree, please take it over and drag it over the finishing line in
> a timely manner.
>
> I wasted enough of my weekend with this over-enginered piece of software. (had
> to change one word before sending, can you guess which :P )

No problem, will take over.

--
Cheers, Lorenzo

