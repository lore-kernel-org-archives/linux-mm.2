Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D60CD8C8B
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 08:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E276B0005; Sat,  6 Jun 2026 04:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F3C6B008A; Sat,  6 Jun 2026 04:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0447D6B008C; Sat,  6 Jun 2026 04:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E867B6B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 04:12:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B472A0402
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 08:12:21 +0000 (UTC)
X-FDA: 84848770482.11.6427086
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A35971C000A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 08:12:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAjhzykw;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780733539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hb81cKk8ZcaRz8ybKR9zbQGjFY/W4p3t/TQe5KAtgrY=;
	b=P6IJuujDYsvSd4pOwt0zQgNJ/lFzLkj07yUkqcBx13Kol7rsZbu2COoLDrTATCLejxm761
	zVppTM8XbDIsAyI+eeT1XppZQC3PAu09W9m5UsrUtdgxPkhu2widBWf3nwYGa0RSXVloQ9
	78QPS0tkw16coF1I5AwCu7LFEV13K/c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780733539;
	b=VccE8Dgit6S5bB1+ZNDJyawakprE3TGx6goSk/z7QZym/X5g+ddRFSY23oBgBhqFDz+/IV
	A+/kx019MCkx4kV8lfOdi0HzivL4GfDGf0UIUKW0wth+KH9NsYvANUCgmcQRiPmxfzYnY7
	6E4RQsYJgFrHGEWNAfMAVcgd8CfqHBY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oAjhzykw;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12D33600AE;
	Sat,  6 Jun 2026 08:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B701F00893;
	Sat,  6 Jun 2026 08:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780733538;
	bh=Hb81cKk8ZcaRz8ybKR9zbQGjFY/W4p3t/TQe5KAtgrY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oAjhzykwaU253cFmil4zCN6AYlfqQp2dLxUH4gu/nMahHeu0g/Dkfydt+lTW10EVw
	 M7bsJCm+bMkL9wbN7HJYy4ytn/J1UrXMRHB7vId+zorBxMz//smUqBWppNhCpID8XD
	 OlVFwpASzaltdb1uGO3aT4dwLVQHt0PG2pKH8SMGGSrexlh6rM3L0M3iojWp0LkiIW
	 IqvS9r8yct3V5oG4IccL8WCLg2I9X2tPfsgsEeZEa4gO4hNYPT+ZiUY0qHXQzOI6gK
	 UWuc/PC4/s+0AqT5CvAtqa15gZ+Rhco0OjrMO4yuN5wL2BEYSMG3abBfSevZE9lmsH
	 Odz5K7xA7wW2w==
Date: Sat, 6 Jun 2026 09:12:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] fs/proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
Message-ID: <aiPWD6xZLg6g4DTO@lucifer>
References: <20260606015729.1837935-1-surenb@google.com>
 <20260606015729.1837935-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260606015729.1837935-2-surenb@google.com>
X-Rspamd-Queue-Id: A35971C000A
X-Rspam-User: 
X-Stat-Signature: okywjotdmhxhidra4omeckz6ncgfuwti
X-Rspamd-Server: rspam08
X-HE-Tag: 1780733539-107506
X-HE-Meta: U2FsdGVkX1/DziHtgukwLvWT7xPddNTdB4fvfQIwuaMBqX6scsFSSLg/sn/5PzdI7LUF2zNQB3nUVVVxnyTijDyMeMCpI0sO2Z165nj2YMoUCQsV3OZ0Fj17LMFL+qOZeS1yV00Ck2jxim4x0blhkGEXfGIdntjRkeAwdx4oKejBrgfAm8DyY9T6DlSWSSj4PwHtbZqAgggu3S77Ish+rIpF2YquCVP2vp/i6RLONkre16uUwSVQJUx8m1TN0iu8Sp39THhLBl85AywPJkE64+rf+8b5y5RXipolMAU6VI2mSeoiNSFoUU4TMXboangMDARaMxYdqoXAy9GGRDA1dAESa5KNNJNJJj93zSiCeXlHJ+qfk39Kp4eMcBmkBO8NgAAaIyg8ST/i9WetZuk6paPXg2RuJZ2YEC115mhwWGuqiGMVzhZkhkGs/VyyPlyvo2XTwUfV0IdPQW7Bnn+1JbUDyMX2xib+DUA+ncoeVpknAjgpIouTkgxTdrrrSYvRGc7g7sQxlr91rXt8WuISQ7XbOWv2FsvKGjDPn/PyPJYG9HBKtpW094BK4qs1GLlaHnP2kOZUWdwQ8ijG4Vk+X4cNcm9tzWvZYBPTLgoTLOee3lKmaPmJLJ2J+rxxeqk+gUWuMi0qB2ifVVyKgIQAZRCZuPIzH9j6cANx/QuxxsoZUdFs9cwVahm5/xMaK6EXGSsHc/D5yWuMVh4eXCt1SrfluFFsQdkvZbKxV0uWMTqXVmIoDiw+hLzS6Z/JT+niemP377AuSWnuR1e00gojemeXK2ACxYY8XvIK6x+MuwnIyd1QHoM9lJhlbnf7+/e6ozcjIBW7jD/+21/rldEOzgWWbE5TWAuK++fkRZHIlOMJa8t4D+yFU6oSyT31pk5NyxK6t9iX1eFAEzKfMDleQgMyxCZjIE/YtisHXQfi0bxtHaprPV/QAn7dXGY9p2YEmA49nFCKJL1HCRiJU0+
 YV1dMeoY
 u5hh137gaRkQPpCD3VdtZn3HaZ2E1VwL3si8lSXh3przAmioIW8+wfazRZ7mIaWIdCIVJxwCovRKHWd7MQnGQFtpi2lOIVUKSC86+7I39gfUVl7DNdgVaQ7Wlkwzzjtw2+WDkiT+8J1wzRZYbtifEKIaFWGShLkl63LaJET2N7ANnn8ElZr7rTRkrP4Elx9ezk6NsFFh4Y9ZqbVA9Tduw1jh3AA6HkcSlhl2kfxrg3UsPOWHglVE6jF4cyot0tp5STFiTCZoQDDh2bNvZ0F6CIeWGnsKd7MBc2AQRNApg321Ba6sgbeKUZK4gONAt3NhbxkH6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Will review separately)

Sorry to be a pain :) and I know it's a petty thing, but even for a 2 patch
series it's easier to handle if sent with patches in-reply-to a cover
letter :>) also makes it easier to track overall updates in cover letter
changelog.

Thanks, Lorenzo

