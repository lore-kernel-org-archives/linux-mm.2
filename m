Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066AECA5FED
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 16:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B7F6B0092; Sat,  3 Oct 2026 12:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C151A6B0093; Sat,  3 Oct 2026 12:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B04726B0095; Sat,  3 Oct 2026 12:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D5396B0092
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:31:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C24D1A09A9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:31:26 +0000 (UTC)
X-FDA: 85281855372.08.1F0D01C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7AF924000F
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 16:31:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UL5f2GXc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791045084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5e/KN/xUw7lArWbSdyarhZ1XThDnY18ob5T7lpmm0Lg=;
	b=VwB2qttB7r1nVmho1Mrh5jooIrQZ5iHLWWDXmbunqwFEHQqkIwn/W9VUhvmIGPl4pznhA9
	cA35G0V0ZDzNuqtvteq8QU3JNCf8TJ9MDQAvoB++95C+aLgT421akIf4t3Q8pvO65WG6Wz
	EEoYX5qojbxQr1fSg8s/w/bnEniVkGk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UL5f2GXc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791045084;
	b=Z7xGD5QDXDq1ugLU1iHGRTcBsG9VXfqzIh3C3cTStME6JGfwSzmguVOi5pZkwYSP49SjRe
	uktc2mX6cohFqt7dR0dWVu+qnw9JoZZocFbb8gC0G09iPmP6l0vYR0QVcDVrE9Jng/lD8+
	qFq/OL2PqhDtvw4nngEBwxMPO7iZp+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5B1460D82;
	Sat,  3 Oct 2026 16:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9153D1F0089B;
	Sat,  3 Oct 2026 16:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791045083;
	bh=5e/KN/xUw7lArWbSdyarhZ1XThDnY18ob5T7lpmm0Lg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UL5f2GXcsaUNO+Dla38WGrEPCA3dtkjUMAzxdJuDHF8S1eelSbizJcH4mKrykxXt8
	 zqUlqcp4q0GxEwsxowjB+M0ber7JoEgoWMGs6nyyV7PtSkRi7cMDH6G7Mi7+GMcP8G
	 Kei8bnTVVpahVpLfF8CrruSrc2aIQ/8VdPjPPnTDeZvv27maY/8JurP0q5BJPMKnWa
	 EAOXeTmf/5TiXMIfG3zWJg+VdH80A62WQG9y92TGVid+k9bSM/oT4UTlzWneWzdxgi
	 zHIh6osUjXjpsGm5BcCCv2m39/mzAICt+B1lyZAdTqI+bKl7rgFKBdre4lmBCxfRg9
	 nm+ElMSU6d5OA==
Date: Sat, 3 Oct 2026 17:31:18 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Ameer Hamza <ameer.hamza@truenas.com>
Cc: rppt@kernel.org, peterz@infradead.org, akpm@linux-foundation.org, 
	david@kernel.org, mingo@redhat.com, acme@kernel.org, namhyung@kernel.org, 
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	regressions@lists.linux.dev, stable@vger.kernel.org, 4ncienth@gmail.com, sashal@kernel.org, 
	alexander.motin@truenas.com, caleb.stjohn@truenas.com
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while
 perf record runs
Message-ID: <asEtt6OIJmBww-0T@gremlin>
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
 <asEllR7if-J3wteg@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asEllR7if-J3wteg@gremlin>
X-Stat-Signature: pshmzwu15563k9jbf57t7y7yohzxxo63
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7AF924000F
X-HE-Tag: 1791045084-720705
X-HE-Meta: U2FsdGVkX18dh30sybjVDUlhDedMqGMdA7prZ2y7K6v2acfiF4EIqMc2AwDwThE1qZKZg2ZKIcaaDqSFDpPkMtgieD7YrUbmPWr0HGRFV0Xc3ktE6MFM9AyImjyKOAYCcD5K8+BANZzP1YeF33cagzYd4lHnsFnJsm9apTs20wIAHJWMukGdYhAKbHLMPQzxKJQkjRIA23epXMIh0B9bYAxRi/yik1//KBjbL90/0j67b8geAT3sY49tziTFHH08Q9bWdbqRc5QCEP4w5e3yb8MERGFfbXxMnFVTZmKP9vmCrpG3T8prlwzNrXqtDsSXJhlmeODoc/vWdlNsSkoyNdHNA+9VoIMQkjGNewZcvDn7WL8TZp093YmKjnj9Tq/0GC5x/jEuKY+1pkUbRG9k2k/BW8ClLRucn/t0S+AKPbUjTElGYNjl2cvte3R4pbgWSFiR9XVF8oGhQSR3orOuHWUVnko27YBBSFO3E3mT6Pobta3IPGZbW9WQ5WFEGC/kA45e/Hr01rUUZVdS/+XnmMjOgPDB0B74OvdecW5sOSd5l4J4N4n0PWzMf/8Jh2opZVjPeBn5LQOTKMSY2RPBgwRCTum6ukhvNifL27eNbuV3Wo01CblpH777CaGLtXqN0q+5KokTRQ7vtjPfClZYDDZlGdRa8fY81rrXQmDKHTR3xSA9tf7mvnjGAlZh5Br9SmA50PtJcvgWSfLUbTL8yIdAGYits4Luem225ZS0S0rl/4eMlbtAgW7GJ18/ZVtlbVW/jTzosBYGyfvx3ldpr3Z0atVfe1YXa+aHvOAfzX0rNldzu5m8FRcPENvKqSy47xlV63o6NyxPVnUeMq1EYHlLUcsEynw/GgNTahY2iGfKNQSjzt1oKE8iiLDxWngewm9sFpVzXJVVI8DBjTydHyCYCRfZPXs2MBkxH3fyHgfRfFRmU0cOusCkRLOnpSTdukVJE7MbCP5bLZljnr+
 KZJhzSM1
 MNsKXqrwuG26TxG59zRaFcgPEetqwvlh/0Ce6avKuvEBAAW8Oo/LtrEMDF1wNA/GtR/ckDcXrOwtE49caQW4+2Ut9UnZiMLk+xhlbyAWqpxN9Trsp9paUaQP5l5eDpz/qFFfW27xIs6w4qoN6DJ3UE7EvioP9/KhczVC4D01sy6r/TRdvgKm6LT//FUoK7i3esBMPG+vfRUb9Fo68MRykeD6Gy20PXuRGbBG5xOHxfabDUD00PQmf1LtCRnVtYowsOLtiMGrvgXD22rKkLFNb5EIjg86y9SCurkESSn++HA2Fakv3rl43CA015t2IgZeARmNk9THTC6DkbSWznQfEGArqhw1t9QldrrQds3g/poSar4KZWO3E+sgfAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix for perf sent at
https://lore.kernel.org/linux-perf-users/20261003-perf-locked-vm-fix-v1-1-d214dcaf0d76@kernel.org/

I cc-d everybody on the thread also.

--
Cheers, Lorenzo

