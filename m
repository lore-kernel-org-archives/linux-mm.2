Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D329F483F8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 21:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1166B0089; Mon, 23 Mar 2026 17:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8946B008A; Mon, 23 Mar 2026 17:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF5B6B008C; Mon, 23 Mar 2026 17:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB6646B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:21:41 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BAD413C200
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:21:41 +0000 (UTC)
X-FDA: 84578599602.06.6BE8910
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7B0E1C0008
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:21:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/FYPNYh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774300899; a=rsa-sha256;
	cv=none;
	b=lswrIA3khvtmPwfEDtqofre3pb+IfTLU2KXB1IhBwxYL9tXhURy8hsjrFAVKLYBf4tBYf0
	97vFZMuIaEw2U91kFP2wC2rBCumv2dFi4Xo4TJhDEr/EDkcXcffwHo5oaPz52dOVdaBcyS
	NzhNjRQrI11JaATkLdoQp7Lq6qzua5k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/FYPNYh";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774300899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0HEUk1oPQMtCkKsk6maK97UsbKzlpyP+CD/kjWayS8=;
	b=eP5688gQ4vT1vuELEavpfY6p6F1LfJvMPrhpTO53qM1QJWj+7lJzFEco3obj722Qeyr/MO
	HhdQjk2eEWn3sR+02fbK2VBQ2+sZyOnJVvHPsSp55PXGXYz/8pQaaL9qpIbXGC2lLb0fKY
	Nj+HQM0g+y51z2sE9NKbMPRKCfyrteA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 87445443F1;
	Mon, 23 Mar 2026 21:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD2CC4CEF7;
	Mon, 23 Mar 2026 21:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774300898;
	bh=04FQMew05zNRTl9YF6JQB/WHdSB2fffkG+BUPcscUw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A/FYPNYhals6ENz1Ox2wRKyW9TL57KAfLjRpKUc/1hHqneXx0woVnhJQ7WEh19lx6
	 qxlatf7Ms1tUHtE9lNj3isEMDDKvfQZ8LjCyU47szC0BcPLqeIT5hkITD4ULoD+bo5
	 71zRtTumPiy1HOGFmwRdgH1rb+yai+RQKG/ef28/E5BFqFGiT4M/bysdG1JQRZcpN3
	 PxEs5sVkCbpgYNaH5hDVE33A4R7Xr1wMfVNDPDUis3mQUYxZV5Tf/LakCXxm/uwIhL
	 3J4ZrtKZiychGsj05yrepRmZdamPxG9AnKtI/lvIOPxIjXdnaqFSP0daKzJAYW0U8n
	 NiBciLy4xmCWQ==
Message-ID: <16117b49-d83d-4ceb-b85d-d117d6993ce1@kernel.org>
Date: Mon, 23 Mar 2026 22:21:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
To: Zi Yan <ziy@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
 <acGqbeSjktT4biku@casper.infradead.org>
 <9648838a-ada7-4983-99e3-d694e803e06b@kernel.org>
 <EA39EF46-4331-43AB-8602-D0A73E9C9C9B@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <EA39EF46-4331-43AB-8602-D0A73E9C9C9B@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7B0E1C0008
X-Stat-Signature: moo86b37cn4b9mkz3atf6yi7s4qqsgis
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774300899-735543
X-HE-Meta: U2FsdGVkX1/btmoQyo9J0qz/iGdOvsUn+n27rDoIcp1WsG+5WWFxl3gSYkBNzt22cu/JV/ZLomZZ6zW1ir7447/5QVSCkzdH4OzlIOQ0gM7gANRH+MqtaL4te0L3OfbEt44CV7dMRglyYkVC9cCbW50xmV+uZEwXLVbyFSIXAeYLasleo2G7uK1pL4lQF9R9z7hgp0aaw7T9k1nOxgJLI2SSt+GlT+Pvp5NCr+ThrCsm8gJh6mI/u9fvK4ciqL6uRQxgMRslQE5FOP6mckmjiGL7e59CWOcFNMeP79eROCSSsNv2AiK8iJfWiLdtu/9I5c/ySoVAZ12aLADz9d58sXVhQlc83iSy0xu6+xL9JvbBdFoKT9x3gcCNn0n4evom8R3N9aKmISXz/YQxet8xX2Lckgtm4+FmZs1+9gjH8poZuh9L07nMNLBlp469ni+YQIQMeg5UhCOFlnUfPpJbxH0LVaM8Kq1CA3UB8xaUZw7PVJQmBb6zeLuggpYD63oC54VmY6Xx97bCSOjptMy0TSw+odx7Ey5bKC3XP8m0npUgkk/8Oi9iGK9VTZci03SWl6gmRw2cD8AX7VedADRFZfNBPeMyeUYwECEqI++hyCrrQMnGeU/U3kKdZ3nN7k5dpd0KyVN9+ZipccIwINIfQd3ZD5jIeEfmEd9O4vAx+AaGuT3lFFjXK1/WUbenIJwg4EwNv9pbui+DZZhxQbKYquVe3AH1jOqtsHa4cpM4qdp78z2WCYnePUjWleiavnkSE/UmRQS0ETqFUOgkkZYxzzeugWGX9Dd/ITk7V4XDlJTk2aK+H5TVu9FQsQjMDWpt0p/6UYymvcxLOSKABbp/IfdmuyAt/FVj+9kr/1bEAh02N+d/XhepvuYQW5eK7Y+WScWYo+xG2jEjdxtl9Ui6SgpZPNHK6i0UG8FHlrCaKICByoFgFemBp9eLJEww1lPT9XlG/7hL+tgxNMS1asb
 H0xhBrfi
 w1apzcKfoa7LR1ScAFP+oW+CdpsecOhkZrNXZFsneZ3Wki9HX4pO6kkHT9J59EISYEOI7A18lXbix6+jVtTlob4GDte4mHxGxP1nnVoXvpJJRZvhfQ66wXXaSm2+z/gUyks8GjJZ+Xu4TIEmYhy82LqrK34PReAxkr4GgCr4AVUPNzwJzx1rhWTKMux554qT3bm0K/EDV7QQrNT6bnsllTAVNltPz7cX5TXEj7wv5j50PRgn7pzHcJBw9QvzNsRqjD+yLtcriLb9aV0410i2gBm0Z5j20gio43fRv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 22:11, Zi Yan wrote:
> On 23 Mar 2026, at 17:05, David Hildenbrand (Arm) wrote:
> 
>> On 3/23/26 22:02, Matthew Wilcox wrote:
>>>
>>> Not necessarily that lucky; if you set VM_HUGEPAGE,
>>> do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
>>> On busy database servers (and is there any other kind?), khugepaged
>>> takes too long to run and find opportunities to collapse text pages.
>>> Like, days.
>>
>> Yes, in particular given that the default khugepaged settings are awful.
>>
>>>
>>>
>>> I think the test needs to be:
>>>
>>> 	if (mapping_max_folio_order(mapping) >= PMD_ORDER)
> 
> This is very helpful, since I was thinking about using
> mapping_large_folio_support().
> 
>>>
>>> as there can be cases of filesystems which support up to, say, 64KiB,
>>> but not all the way up to 2MiB.  I disapprove of this situation, but
>>> this is where we are right now.
>>
>> Right, that's what I had in mind.
> 
> Does Nico’s mTHP support for khugepaged include changes to collapse_file()?
> That might change the above test.

At least not regarding adding support for other folio sizes. Baolin
(IIRC) had a version for shmem support, but that will come after Nico's
series was merged.

-- 
Cheers,

David

