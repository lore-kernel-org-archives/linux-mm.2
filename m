Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BEBBEA3F28
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 09:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7655A6B0005; Tue, 10 Feb 2026 04:07:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 709656B0088; Tue, 10 Feb 2026 04:07:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B366B0089; Tue, 10 Feb 2026 04:07:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 50B8D6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 04:07:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3E1358C3D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:07:15 +0000 (UTC)
X-FDA: 84427968030.11.ACFE8CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E8FF140003
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 09:07:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPxQMCc1;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770714434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+T9GF//tm/dl7SiaIFlUsECMPCSw1RHVIpsbpj+YYc=;
	b=D3sIFmyTaKLEnh4ZfOxIEcPHF1rz4x9LjF/DeGkOyQpIiz4tPLWtTxzD3Kmg8Z6mE/c2f8
	ChwER/FTnGjHL+O5j1sTrElp+PXswpJRskVtP7cyrfVDs5owSSogcqFS+a52Bgki3YJOI/
	dKRsPIbKjbXRT2rtdzWAMrEugqiQqzY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPxQMCc1;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770714434; a=rsa-sha256;
	cv=none;
	b=icJrBk4/vdqD6hKtRjzZSzW2QJtnlEIZ1OZGiG9DTgKYQSZ6++GTh7pYpxdROitgUatJwo
	4IdB7YCe0QwSW3SlYIAZm5jAQpK1sgaEbwXoDJCsQxi4modl76qyrGM9vsEeGJTGl5aPLC
	ri0wM1SPGixxC3GKGZxlCL7fyzjJ9Do=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 49D6060145;
	Tue, 10 Feb 2026 09:07:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BD3C116C6;
	Tue, 10 Feb 2026 09:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770714433;
	bh=lAXG0Rgm+i4NH9Jc7wCtX7xvfeM1vfyZOBrHykFqGH4=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=bPxQMCc1O43ryLDnlTuakH8NGDi09qnnjOKp83oJ5JlmLDxMSSnXqIzia4nDoGJCf
	 qdFhabzCpVA3Otb5sIx5yuMXykRa3Z+KxHHfUOXv5k+qbm/D6qJP0H8kr2+FlZ0J1G
	 kxjHny10Rh8emGRQeVY82P6q8AZNRQV8UcfxyQoIilIdhsKBfcKf6f5fZxkx4iP1kh
	 +2OEqXSFeeiPqzQYywnhLh0Sn1r5HT6qGMGuz11G8HrKMZus7t5AlV6bbFBDIR8W8d
	 v5wBv+Psua6g1muMbB+r/5NOTbSA5Bqm4GQqeQUtO9sZoYrzBZpev+q5R1004shpQN
	 eyGHAFtN51gFg==
Message-ID: <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org>
Date: Tue, 10 Feb 2026 10:07:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in
 do_anonymous_page
To: Wenchao Hao <haowenchao22@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260210043456.2137482-1-haowenchao22@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 89uzykab3n3reeen5h9jjjfmdzsrdtdb
X-Rspamd-Queue-Id: 3E8FF140003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770714434-732984
X-HE-Meta: U2FsdGVkX19GyrM+X0aVPyn5fSXH+F6uYXbyZGyFnPoEHJClCyKFjg1QqwJsnBoARIujMDUt21JIlwDfLGLWTLZVq6St5oFVuLVp/TLJXdNbpBGB7DFQ6JUW3C/+3W4GKyPJQ/QZBPsayhGEMEGsy7yu6WbZLi0+Y+y8vaOiXD/u7BlSGDQG89gtI86DFeMRn0FxnDSs6sSVkc+p8oSTPHLomUEtEzIjNXpTSZ6K/FpD66yd0C7uZFFPt/JOe41hEeyBNrRU6TqlKMf98+bdarLN0E6SFpI9lARl4LSTyqnx0ImR2ZThib5d58TBKaaM0CavPmCvMHjhzVPrWJJIe55YP1JcxsiJV1YwtWpU656N4HARReHX03MKI7rjgPh4QdmeTlAg8NYqybDltRKZPqfVr/nt9UJOohQ6k46071H20Iu6zFohAQmaaUfu27PUbDWt6yv1nE6fDr8EQ/0lNZfKh4iAcDqofHSComwTTzkGT8aqGZSglvxHMWGnnYCKAOGyIbXtmQza6Z7rYy9l9LBEwUanjFFt4VDxn43f1OeZfxtmz0ZIJBDIkMzJctT0z0OsWUd/2MC2MKitpAnREwkMKl4WOosVuNfdv+YkVVhylSPs/OEqgiusJe+yI1kyvejcUlUa2FohRZDQBo0xTSuLyqCHSoFuuYtek56iP1s2x9XzjRKYipbizQ5IfpfOUP5CtzJUJUerAKG+tYB+BrF+Ep7UyBkLom2hy6pL6SmJO+JK5EPNveiPzRij7cB8VuyS4GIbxoa+SRAaFAU9vznxP3ERn3MEhHpbATY7GEdZZD+/vqY+u7NbR3+jmNKU71R5KALV86bmgQ+Y5GURIg+OgXDRJWwItUg6vlSSdsve7Me89RvG8AQIfMKtQRP9nByzN/hFXtMk7FidZwlQXdld8pPFtH+AmIKEgstncMqtNQusgS94Xfmmv1zo+zfkYMhgWXV/VcNjq4HeVfC
 tafvunVC
 Zg8nHgacqly0vafPKA5V74qG2GeCLG2f8FXMV0Hnm4ZTgATwIgocPvHHQhKI7I3eK6WnECkPtfsnOaNRosyawYxHhXBj9N/BUzshRVHHub6u5UGkN+6Uz5IvXU+Ilf847Mp0TrwkgJXfZ1vDTV2S9yO9hiqWY/oq0a0/xmN01RcMbbKMPFOxQbJFN1+5FGf9+jP8N83XxzOwpfjRluMBVRLdMFxQuYt6cyaXaD6hrjN7QN5o/qXPPFELXJLBVZpvJ+CJI8RtZqmB69HIl6+zqqdjHUuaPUnvMTMuuw3niEBDicnPeepwVunO8Sd22hFurrmwPr9M1bf1YpCc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/10/26 05:34, Wenchao Hao wrote:
> When do_anonymous_page() creates mappings for huge pages, it currently sets
> the access bit for all mapped PTEs (Page Table Entries) by default.
> 
> This causes an issue where the Referenced field in /proc/pid/smaps cannot
> distinguish whether a page was actually accessed.

What is the use case that cares about that?

What we have right now is the exact same behavior as if you would get a 
PMD THP that has a single access+dirty bit at fault time.

Also, architectures that support transparent PTE coalescing will not be 
able to coalesce until all PTE bits are equal.

This level of imprecision is to be expected with large folios that only 
have a single access+dirty bit.

-- 
Cheers,

David

