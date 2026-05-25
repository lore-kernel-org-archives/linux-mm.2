Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7E4CCD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 15:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7586B008A; Mon, 25 May 2026 11:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 478186B008C; Mon, 25 May 2026 11:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E566B009B; Mon, 25 May 2026 11:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29BCA6B008A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:36:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A9FAD120127
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:36:05 +0000 (UTC)
X-FDA: 84806343090.22.957260C
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	by imf11.hostedemail.com (Postfix) with ESMTP id B3FF04000F
	for <linux-mm@kvack.org>; Mon, 25 May 2026 15:36:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=g2bcBDcj;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="u MqSjtf";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779723363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/z8wcQtqyiAzjZ3rldpoXVYMavh2GjncR8kmcwNQbbw=;
	b=m59kGeFccYkCxHyCycYniQOTvHJGLPq06lBbrPhAkiZI+XHXTLAI9UZTz8AaYVqxycPwqo
	L7AKAukUW4dB9p473h+0udvdWSQELlywtEYAzdYaRvNUm1zZE2Ki1knvJJkgS0/X0ouNyz
	cAOTW574l2q1Z4ui/3TnLOTebk7cOSg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=g2bcBDcj;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="u MqSjtf";
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.143 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779723363; a=rsa-sha256;
	cv=none;
	b=ja7j7PSBbTUPLkyUGz1503s9cOj3tJXP6AQ27FLGnQL2BatymVBQARHIVjxOhGqCleUTVV
	lFU66ycl1dOMJ/JbRrkiWkohRu8gDO6vQSoT8HZO2lSrGwtP0CsENkTX1EhbQrl5lqi2Ch
	Ep0AcS1YWALeErbQvOSmqfA2Tu2wuxc=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 9C3891300973;
	Mon, 25 May 2026 11:36:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Mon, 25 May 2026 11:36:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779723361; x=1779730561; bh=/z8wcQtqyiAzjZ3rldpoXVYMavh2Gjnc
	R8kmcwNQbbw=; b=g2bcBDcjtyuSlDgGqKESNqueo2kED4B8KIpXvOQl8WTCEGZr
	UmymP81CYj+kO6pyDK7xm7dFU3PxA8qYf6xJcFnL/786ABaNjbzxse92izi/y898
	jKlTbKaP4Z8L3U5fVUdiqwPE4DiV1u4HUFxOs566Jmms38QmeffgpfZ6VY4g9ZNZ
	tA4wBZJqIyOyapzR4EMYFv4uR09jNmD8hk6Eg9IRAs3ScDdsMdzbE1Su7Q3XJU7z
	taiRsNorzG3I1GaEwS3jiFUhBWv/Z67Y7ELeGDJWVsYRJFwPAny0zCMZXvrLmquS
	+ShcrtgBPsPwjIljoiXWoreJv0SqIbHlT0jssw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779723361; x=
	1779730561; bh=/z8wcQtqyiAzjZ3rldpoXVYMavh2GjncR8kmcwNQbbw=; b=u
	MqSjtf8V5FiQM70wcCRNVwoogYxkhFO3wh8XVE9G5ewYNRSVsoF885cjbb4COyN8
	+bbbWZrMAeiglHx0FAKICwo0P9epCWsS18CAbXCgIc7IU/d244dme7La0y9otXpE
	YtOMq67CANjgjbv0awArzXd1qMkxCKEDnYc+1dxxHKPOPngBWBwUuepMMMsk4yaS
	k5XYoD7Qp+I392RJEkBaPgsK0/OiJstGAu9zV8gpWX2Hs2iakBtX4L2cKo33QGOQ
	Z5gdT4iDq1lFK5/vO5NiMcKbON/rV4scZALq+ZfV+7rfFiGP+BHmbUk5byUtBDZz
	sNNLfv09Hq7qGbUr3Oo+A==
X-ME-Sender: <xms:YGwUaruXOIcT8XiAvdzk6TsP60JgP92VIy5X5-kc5AiyltRkCXTopA>
    <xme:YGwUak0lLHvMYa-o_mN96IPNiGL4Hjok7HdHyrmbERfJ0sk5bsR2MJGrqmflALfIJ
    ZDu_DVwCdMpRmfBiTkhs84trx1egoxlhum-TUiblY-fiqE7cGveww>
X-ME-Received: <xmr:YGwUapBVguWyJbI3T4Bsbry-xtBWn685oU9uOg75VnVA11BL8OPz6eerxkTwBQ>
X-ME-Proxy-Cause: dmFkZTFIo7qevfcZRkKkYg4AJgroQ60er5U9hP0PkiNilvpP646LWUxvbqRIWJPa6qUBT/
    q1bir7IUhm7NhIqRJFfsduPbs3QThEb70zjkB6WF8iLA1wrGrUkaKVDj+7NXDIaemdp3gS
    ce9FiFOKhFAw3hO7URfJdJyvtOTkVBX4m5Q2n5uPKPEL1b8omvm6vatEeoQkeCJPOQxOvy
    Ext2/b1kDK+McLE2qhtSWtkrLm+LvTcZRFdWtKjlRNamZaPOA6owaiP17rL5rdhCNgI06Z
    HPr7l934RX0s9JUYx1fmNIDLi1uwUcHMbcYXaeJf7+iOebUt7qgcx/VvqufCD6G2hPWnMm
    mF8Fo5Dtbvt6f7WbAR/DNbJnbY4wHLobPKDPFY0BqyHALjKTWYKRFKKEHMVeIloQ7Ar1Jc
    lbvceBdhk7+aEnaloHs5ZpozOcyLLdET4gdQAgpyyOVm0MP6zJdIZv66t0bpm+QQRs49Jx
    z60aY5lCzrkgfkN/u3NxvXpmdlCbUFEUIseSwjo+9Pr57sPIVC1toortyyKn9t8sewIYbJ
    i4FVyeCDO7f9Ay2b8OXoWTC5l5SV13EXDofOwKZjEbx5IyrJjRMTn6pZOoNfMj3cAT7UHD
    Bbb0uGU5wUhYHMol/dEP6qF/bRmh8Z9ZPbeKM+ORFr0UztFk6EHBOmjE1w3g
X-ME-Proxy: <xmx:YGwUauzX_Klu4tW9_W_Vexy86CgY3N80W38HR9Zf0hVBOwMhOrXMag>
    <xmx:YGwUapR2PRYU5nGD4tdlyffu-Jnnir3vmC0wcjj4r-rPaI34eiIjPg>
    <xmx:YGwUagdVgAKpeMa_EPyCPZDKt8uPnpnwSoroUSN4Ebie0N6faoSjNg>
    <xmx:YGwUam5lC0CA23FAwwTJy23uXGnidWdZnO-Iy1Y8WMltbMjayGxvJw>
    <xmx:YWwUarc_RtoyvlqzogMxJEv3QvyCKsNVHM8ji7zWbTxuNN4kRHwl_XkI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 11:35:58 -0400 (EDT)
Date: Mon, 25 May 2026 16:35:52 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: sashiko-reviews@lists.linux.dev
Cc: kvm@vger.kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, david@kernel.org, ljs@kernel.org, surenb@google.com, 
	vbabka@kernel.org, Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, 
	aarcange@redhat.com, sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v4 11/14] userfaultfd: add UFFD_FEATURE_RWP_ASYNC for
 async fault resolution
Message-ID: <ahRrpnq0ZaugOhfT@thinkstation>
References: <20260525113737.1942478-12-kas@kernel.org>
 <20260525123622.DEF511F000E9@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260525123622.DEF511F000E9@smtp.kernel.org>
X-Stat-Signature: 6kstgwk431auxdzquh84m3w1f3hh99us
X-Rspamd-Queue-Id: B3FF04000F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779723363-96355
X-HE-Meta: U2FsdGVkX19xcd003HRNiiKNHLA+qbSE6Sc7xt59t3RuXkrw0HsdOUEiRKDPrqjjiYLtcXLX0JSqJkW0dzob5YPIhMs1CtsVmkIdtazsOALy95jbWVZkctAez7TE18bRqotSisIamjIDDlXFaDcI5AagkSSQFDieEkpyAb3K9RhbTZJiajplvT4J8Rxgp7evKWCf22MuaruGBKvtl1Pu4uiGQ+zY0oyrYaPhjVFlyU2Ig9TDWZJNJjSGaMW43uR2OiQxrD926YxmPJDfh5W4xQ1ope8BJRwHHfoDDU+wGZ5wov9VFuHZ03wnQfS3GO/MZbXY1qhvok4dCmSdh3Bz9dvWgHfxs5NsTP7fU1vj9dnZHjtH0A8haEd82kB5dWFGYTQZWIeeJMBFJWW7nYh7iujWzUtZqR/abMG6Nh8w6SI8v8ODjLlkbdk+xpy640iyfOnJwyRv1QiAKSY5csfQfDTPKg6NvSxtsb9NyxcD2owr5ApVNYZ2fDoqvTpuS2RMtsqV6L1kBpkv9xys1wFGWfHmo5t4yeAKHO3zJQUXrcrMoLOKz+cg+zhf3jerarr0lrqm/sD6qiscY34HofJmWbVrykCwEeLDoUE4dASgWM2GSuohOX59yZdER9qjGSrEH72QZP4qzWrmaXfgoGZFInknrcSicJKBmaaUPhQhLkQe/191zSKsWqsHuAnew/neGwOVkeZW9T0eb4iXiyDNFpzAW45QhOFu2Cin/kN6RqN6jIrbWXmMpY9g3yW5GhyMCdwZ88JOFhwBY3xC15M86H8vppH5EuLduu5L07EGqRfuw5cOUTzmikx0iK720rywlJUjPO9rP7/fkq/qAFI+LEMtn+2mW/PaW5r7QKhDqDy9hPUt6im4Fy8zC5EQ3uZHMt9BtAIOZEmqMmDAa0QJ0FfdzS7Sp4Ui/FlfZhIzPDJCsVTpuYyuzSQu5KNjqxMz37SXUfnuJzG65jQ9Oo8
 D2LPBpKt
 m6jDo81yC8uNQMRE1568SYjOA2TqvH36c0SPyKsEjy0rENuEkBt4lKHqEpm+wEWVzjx9yRbVsQAPqNWhUlVj56JSNmfFlszL87lSridek+hsua0f9fvNkscWfYrnbPk0HN9SKeXknVkiSo9BDLc1zb5oiVSJZ0r98zm/ru4YcaCnWw0M3oHd7hKdMNsUS0mQjdS8rL2CNl3f9rpxBG9X8DKMhU9+xiy5ekhcYRe0JRchHkBHxu3CzPfd/aTaa0u/0N5tjZk1uC/QasZ5IeYt8u1RsjCgXa8W8Rufin44qw2vXlylE5gB9VkEcpBske6/cmQSW09QbnTKI3AJ8GFjW2c5yXTlOsZD0BNwFfrZ5iCIjoDNzEio42gR957A7Dhysii5kjAQq6fhilev07joxWO2qtpmJO8C+m+K0zZRig0sg5SRhkQzKqjV6q0+WJEAAJQYj9f9xgGiBsLFwsX434J4sZ4mhcpfTrtUsbFmW3/dk4ddzkgIzzsDBovbU8GYO7aesrUWHOY30evWA/MWYTHKocdOc4mdAqQvYoeBv0WjL/eq5lQbUxAvuSf47pNhP9Tx5qC3aXENzM/rFuurtuN0dTVSm9+0K+x1E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 12:36:22PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Asynchronous UFFD RWP resolution creates invalid
> clean+writable page table entries, violating the software invariant
> that writable PTEs must be dirty.

This is a false alarm. can_change_pte_writable() already handles the
dirty invariant: can_change_shared_pte_writable() requires
pte_dirty(pte) for shared mappings, and
can_change_private_pte_writable() only allows the upgrade for
PageAnonExclusive anon pages where dirty isn't required.

Plus pte_modify() preserves _PAGE_DIRTY via _PAGE_CHG_MASK.

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260525113737.1942478-1-kas@kernel.org?part=11

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

