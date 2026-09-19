Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BC9AC982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:29:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBC66B0092; Sat, 19 Sep 2026 06:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AFF6B0093; Sat, 19 Sep 2026 06:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C84B6B0095; Sat, 19 Sep 2026 06:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2ECFC6B0092
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:29:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96FA5C0219
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:29:43 +0000 (UTC)
X-FDA: 85230140646.18.2035053
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id CDD81100002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:29:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=t3ObyEOH;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789813782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7VDCeAsJ2GjjHaIiTS2+Aqx9bChExliZfZyuB40wZfc=;
	b=q8W14/A/cNmb2We7sAWdYcj0ZcrheTkWiyAfzAz74GMVtZUAAGw0GSphpw+YhJDh/nPorS
	IfmEVv1AB6TNzqnprDWLGo2Aj91CkL0YsfSmVv3ZMrk9B4lkp6YdfwxqySWTxpIrWd4f9c
	fFxXxCn9P5Ri4y+tH+7AZyeMUkPtJCs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789813782;
	b=hKHBBxOlmT4ZzboEGsk93XUBQX3EViOOELel0Z7mIGdu4ndwx20QmERXVIelh4GryWapeo
	ww9dS2yoTAzC+M8iqebkvKCB7gL01XtI4v98iyQgc7aeCQQ13jSpCGyb8qnKSWbw7VTGwM
	ahLmOtBMwp8sgbuRJ8DGjHq/2+2OlDY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=t3ObyEOH;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf14.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C0176020C;
	Sat, 19 Sep 2026 10:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C271F000FF;
	Sat, 19 Sep 2026 10:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789813780;
	bh=7VDCeAsJ2GjjHaIiTS2+Aqx9bChExliZfZyuB40wZfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=t3ObyEOH+Q/ZSrDFHgA1orpgeeSp2dFDUB95vkDgkJwrOqZzJ5s+mXBrQ1xGbjk8i
	 cBQBqbljrVzDFvnYRWIM+eSPjBCzyR9IwPj8KNPitkLoqYlzrF+KSvTbR/Cf2euqsQ
	 Rp8sW3yoKxGdyWzvBSvN6sSnwTuK0K6dm+AKb2hk=
Date: Sat, 19 Sep 2026 11:27:44 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/gup: honour FOLL_PIN in NOMMU
 __get_user_pages_locked()
Message-ID: <2026091918-disparity-stifle-958a@gregkh>
References: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919-nommu_gup_pin-v3-1-3660a8851243@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CDD81100002
X-Stat-Signature: 6zbw18fkyxtna31w3t3oj1nrwh4ay35d
X-HE-Tag: 1789813781-331322
X-HE-Meta: U2FsdGVkX1/dhOxhz5dZmnpFFr7Soh7lpHHq6SYbarE0N74apaso02NSRFVSMGbNI1PeWNr40sTjzLxR47/ZYmZgF4IWmepBrbZWTv0tYtFIT5KF7W3zOCitCqzzkcDPuPvBCO+wZ9JCSpKbhMQ1X9RELPFZ+3OsWTv8chcN3JUbiuO+5rs1WWrrWfToom7oQk3FKxkEc+7M+BsfPazDNJNGEvBUOl77jDYmo4jZt79no/tzyVEOoGRebsGRXkQpNdtCqz1VqSfRCy4LZXyoT/EaHTog6vU0S5OJtxUEI5SB1Ba9exhUJynjfsmsub3R2O0dWoQmVtQNCVgAHB3ehq2kjFpgCvZGa9uazEeDKPb/NwY1iAC0GQ5L1CK7BaCRHjTIiaCdk/++RP2haoMpONTIxxWOcnxAXHc5jeg+yrRmKek06JIJer2AHs0kjOh6FhEKM5H8QxRaQ6pe0QbRIp/KJ/c2kgBksU+p5iqMqyAhZN0B8LMRYm+fvT9INL+3f1OKJcFb2YnHTIsjxvI+X0XJDrl/MxpSBuEHlxmr9lsK8d4TJjN2eIxtYwRI7yFhJOrC9P4WNrnhSWbS6SuW6zToqPDd2oYRpn0ow7abOWpGCRoVlCMUjBnCcezs7f4XmWBkK/mnA0D3ruUNxeD2ev4PFWT9jiMEFIOh4OKPr7vO2rgxYu53sHN6LaYuWrQXfcTUaq/ELxpcT9yqU6WCYcl/TxL5KCnYf9ia2Zdo7w2uXbBSBBkD3HTtkOvcI8paOm1k7C66sEo/zMm3lP5PLW2VARpxBu/2Tawpo9wZMJiPCzpjnQRS+Ig6yGLSS8L3O7vYZ7KGRHLutHDD34F9+D9VMrrmU6g5YpyLFZfjyydK9linwVWvDcv4be7wiKAMLWX3yN87QAbxnJW7dONLD2TGfHofT1pRrjQrTP6gvByRuUrQ+uqkqsiHx6dl/ejjzECtR2ui+U9SoNph8f4
 HrIt9MF3
 N/yJ/Sr9bBbpkDhDrrdm2cLs/ISF/wyrDNoXjxzBjNTnxBZyZLDpjXOHfZsx43RGYqqEO4pmufCnd0ZO4HuBLGWV9exO/paQ2SUU8ZAinlMpn2daz1VknfqxfRYdXz5njCS35QAHL4iFc1X0rs+oG7QwAEDis0nQnqA9zoyxHrvmEKM92hK4oyl4cd3pEZ8o0x3Pr6q1jCqiA4Ao/70BSwBgpO5Sef6cnE1Q3H5Hm8BSZSmkjBBjZtLKK6MdJEHhnyi4u55M0652n50IEM6chz3IHRkMiyDc4p3SpTsQ/8a5fB/vNE0GNpy4rBIhxvsp7CYwRs7oHPddyQqZuZmxEqdLlDHGatS/FmW209ZNcWOVZEr+/xK/FzeRmh86NODQcotF/mYDHc+pytBpIUx3dr08X3Euqg/P4xD1DE9Ld7SipSudt15twwcrutdfmKotyXGwiwIWmZhj9OYbGzICNSHE5JdRE18oQW7av6fcrJkTXGUPTX3oLJCU8fhwqC641KEstV4znyyV8CTlX7UD0O1hRiq2u5zBJhjEwE0RnzZMJNiN5pedLdL1ka0OS0YVhxS4AEReGDJA6QjKi1QBmwn6fQDFvoqBFT30NdTToCGAMtq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 12:04:36PM +0200, David Hildenbrand (arm) wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The !CONFIG_MMU implementation of __get_user_pages_locked() takes a bare
> get_page() reference for each page regardless of foll_flags:
> 	if (pages[i])
> 		get_page(pages[i]);
> 
> This is reached from pin_user_pages*() with FOLL_PIN set.
> unpin_user_page() is shared between MMU and NOMMU configurations and
> unconditionally calls gup_put_folio(..., FOLL_PIN), which subtracts
> GUP_PIN_COUNTING_BIAS (1024) from the folio refcount.
> 
> This means that pin adds 1, and then unpin will subtract 1024.
> 
> If a user maps a page (refcount 1), registers it 1023 times as an
> io_uring fixed buffer (1023 pin_user_pages calls -> refcount 1024), then
> unregisters: the first unpin_user_page subtracts 1024, refcount hits 0,
> the page is freed and returned to the buddy allocator.  The remaining
> 1022 unpins write into whatever was reallocated, and the user's VMA
> still maps the freed page (NOMMU has no MMU to invalidate it).
> Reallocating the page for an io_uring pbuf_ring then lets userspace
> corrupt the new owner's data through the stale mapping.
> 
> Use try_grab_folio() which adds GUP_PIN_COUNTING_BIAS for FOLL_PIN and 1
> for FOLL_GET, mirroring the CONFIG_MMU path so pin and unpin are
> symmetric. Keep supporting the traditional behavior where users specify
> a pages array but don't set FOLL_GET.
> 
> While at it, don't return NULL pointers in the page array,
> as this is really not expected for GUP users; instead, just fail and return
> -EFAULT.
> 
> [ david: support traditional behavior with no FOLL_GET, extend
>   description ]
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Reported-by: Anthropic
> Fixes: 3faa52c03f44 ("mm/gup: track FOLL_PIN pages")
> Assisted-by: gkh_clanker_t1000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> I added a best-guess fixes tag. Given that this has been around for a
> while ... and it's nommu, I think this is fine just going into the next
> merge window. In that case, I will pick this up myself. If we want this
> as a hotfix, Andrew please pick it up.

Which ever you feel is fine, as it's nommu, obviously not many care
about it, including me :)

thanks,

greg k-h

