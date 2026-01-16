Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF4CC98302
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 22:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F284D6B0005; Fri, 16 Jan 2026 17:44:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB936B0088; Fri, 16 Jan 2026 17:44:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8476B0089; Fri, 16 Jan 2026 17:44:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC8C06B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:44:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A3B2C04AE
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:44:35 +0000 (UTC)
X-FDA: 84339307710.07.D333D39
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id B74B21C0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 22:44:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IIFxkaL4;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768603473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11Nj7eWLNRZ9XhYgmMX7W/gBKCpofxGl6wKHvV5UxJs=;
	b=7k3mYnqyyA++BR/HoWDnL8g9pgIPaHUAnEtA6RhgBltLBQn6GIpeir+XzxkjDG2fOCCCgM
	yt0g64Zm5eRYgpchjnn+jYwr5rg322E5Z21xeqOsPtguMo7QsL8qBnu713R7td7DgrM5ql
	n6vvKo1mBBwa0c7lIShRLkJHOs8qteI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768603473; a=rsa-sha256;
	cv=none;
	b=VF+0vke7AWyNMOhnsgyLafb8ihLvhH+B9jXogCogBJYpKWnEBIkJzgotlskGLy7ACi9Q/+
	VMdXC3Q+w8n3E5g2/SobHE8YTq8Lsz3ROBYfcGlsZQ6MyfUaHLQKo6KUQDJBD3zya00Q20
	ubRTeZKICqHmt3AV3xJCmQAKRHYfmxA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IIFxkaL4;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B72EA43494;
	Fri, 16 Jan 2026 22:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E2CC116C6;
	Fri, 16 Jan 2026 22:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768603472;
	bh=V/vsCp/WP5MKvU59Xj8vPlULcS7SaWctuXVxA9ZRu00=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IIFxkaL4iT061urusG+m7Y46mioPDUMhB0I/HHmAwx3f8pMvg9QnQ7f6S7h/cGdXj
	 jXezDgUAKRV8rDh8EuthlXcCxeFmrzk2V87AXHLZXGngXFGxV6fbTl8yk21j4coiFs
	 owadUP06S1qLUeqDEpHiODspXUuRAEBmC745NAB0=
Date: Fri, 16 Jan 2026 14:44:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, Linux
 Memory Management List <linux-mm@kvack.org>,
 maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org, Suren
 Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Geert Uytterhoeven
 <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, Christian Kujau
 <lists@nerdbynature.de>
Subject: Re: [PATCH 16/28] maple_tree: Start using maple copy node for
 destination
Message-Id: <20260116144431.f597298658fbfe5931e15cab@linux-foundation.org>
In-Reply-To: <xeipv5m2xxjfyhoqifdigymobmo5lnh6kqqloowbg4oiejqyp4@ns5iehb3kzof>
References: <20260115193647.1695937-17-Liam.Howlett@oracle.com>
	<202601161750.eDtUQiJr-lkp@intel.com>
	<xeipv5m2xxjfyhoqifdigymobmo5lnh6kqqloowbg4oiejqyp4@ns5iehb3kzof>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B74B21C0005
X-Rspam-User: 
X-Stat-Signature: tfta54azwdxo83m5g9q4qw63i1p8bnub
X-HE-Tag: 1768603473-168471
X-HE-Meta: U2FsdGVkX1/zCA7rYEq1ZBV5rRNFu6+qXAEMKE39tzxkzk+YCQ86Q8iSJ0BaKopYm4bHMDV0f/WOisIDcmpfiLGbqY6K2iEs3eOBKMC1bizueI4eWjs7JcnBU+BEYg9yWptQEgTCVSd7GhWV9Kqi9MwE166jeAM7MYJn9TUpzc8Gf2vnN+0vZa/tBaSW3j9v6+qbZAaR4h5fWEoyM4dgcIw2vCo8LUGAq5DlY4b/OtkVrvQiYD8BAe+iNwJzYLpIVyUT0FOVjupsuY6k8ovaTy+PJ/MrEdLgNu9O90SZuh4tnZb9hKOXPUqouIYaPmUxIK30YRPkV2mIdtnYmS078azuni2WCEr5cFisrqB7vx69Vjut1zNU6S9Mw4CuOhQGTw1+Lpfgd2K0XZg2NVTzke67kMunc8MB4kscJdENtjfMNK9E9dWtuMim6WA+FjsXhQssYFXkvfzriwfE4yPDGBFQ1NYcPAAJXeguX7A7kvSt8p/89Yvemyso5/HIvJqjEwAuF55Xesjg+IJosLM2FyrRbZ5TkW6IG452aI+cmUwiKQBbVCsgLgN3Ywis3sTYn3MTPIHoPLDCfmiWTBTovExAKOlDDcBpwrGzyqKyvE3LUkUjm09IKlg4edlOyHit8+phXAAck7t0n/Y0LgoAHAWttUxieY/hmBknKafRGvLrozOb8AcUGCFlc8RWuLMFV+hKh8gxiGmXzizHQMWYJ6dXGPIZfq5vBWWa/jjtgwWkRjkcO1xvQxkZX1Yf4ufWbmH7ZsmPrSRHGk3rVRmkBlg0K4FxyBIj7eiVlDV42Ri2qx45DjgSq8jyb/9BuPL0mfoSzX7xbiVRKXo/RNIDUpJjC34HSBgpksErTfInO/SjQpDZY0tbSIqGPVbhcD7QkI9wNEfgeeLzfZroKACuiap2jx5J5caTZCwFM+StSH5yFnrIX1Ebte7uMA4fg5EY83iZ7k3ofhIZaa2Rj6W
 8439g8NQ
 r2StSov2j682vdKKeU+wP7GLZa/H3UF6XktsgUJBTR8IUyFAFsfqcWXQazUDmW6l7EhHE4K+Uv84NgMj93JwCKPuWiObpjJtIltHiXgLVh/0aF7ngflXMUEa/kUpn81BovZ1d1XRv49mVprkdhahH6YwDdUPTyr+dlro4zBDoLok+88VuOGbwF8lWllSlPni6LHL7G48DM2XExTzHNLL4l64l3oCkBwWFBnIE924lSAm86z+kstGqJha1huct59atfdpCPoTpI/CN8lHtar7g/VgKcn4Pi2vzWqZmIWxljS1Tbf0uDhzB/9/N6tOIt94CDGuZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 16 Jan 2026 15:19:30 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:

> Fixing these in patch 16 means that future patches will need fixing.
> 
> I can either send you patches to fix up this and subsequent patches.  It
> might be better for me to respin the series?
> 
> Let me know what you think I should do here.
> 
> I'll also include a final patch to correct any other sparse warnings.

Regardless of the From:, a tremendously huge v1 patchset against critical
infrastructure at -rc5 got instaparked in my wait-and-see bucket, sorry ;)

A full resend would suit, thanks.


