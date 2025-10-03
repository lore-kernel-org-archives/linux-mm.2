Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72359CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEEE98E0015; Fri,  3 Oct 2025 10:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6888E0006; Fri,  3 Oct 2025 10:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADCB98E0015; Fri,  3 Oct 2025 10:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0598E0006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:41:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7190016019E
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:41:13 +0000 (UTC)
X-FDA: 83957065626.22.276F10B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 99A74140018
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:41:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KORQMTTA;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759502471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQxEIF4MDPKcIV3btWoh53nWWRElvX8cMJP1nz+7+KE=;
	b=kjKN96wqbwpivBa0z0yyWtyDPtdUX2uH9oI85HwTAHRsCWTkaOLE0cwZmaklDBH0uTDi8R
	ijTX2iFDXIan10YdHDnIdKc9tGKlRW2hbGKs/IkYOjtNT4U30co099JEU1GqIy/dFvfceH
	rlpMASlKvUznErXdjGDu1VBEi2EJwPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759502471; a=rsa-sha256;
	cv=none;
	b=UhD8stxEFvvrjjVcchuHpMzMMIGSiPGvaWM34sp6o7BsjFYyU12Kj2pDSGlHQfXTtyb6vi
	ZolFaY015YL1ZgoxSUVh5/KTSs6t8FmfzxHbHhsiD4/5hBd3P3jARyx9fTYjxfNjLj97iH
	EU6De0hxiU5BtdAEuD1WSqrvoEhbipA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KORQMTTA;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B74062169;
	Fri,  3 Oct 2025 14:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C42C4AF09;
	Fri,  3 Oct 2025 14:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759502470;
	bh=bx0s1P62xMVENFHKLMPJrGfBOUqIwhHXInCdciLOI28=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KORQMTTA6AcHihhNeZBMpdvPG328KT/QBsc7k8/i6xvDWHHScRI49w9VGuW73fmVp
	 oLgsO9ucicGSj4o5peNc1wnqCFRAcS3/Ztzvu+PqqfYPEf6RCTfyZOrbDvw6y13HCh
	 wmiYgRcd2Tmr+mzW9Hkv9zv1IMzSTvuclhL8F0fML0DjOXmEi+r3q47wP+TojwT7l9
	 Gd7CR26CeBVZVTFnmQv8yXmzer0pDU9CrF9KsSj37DmA6OXt1MgE14WO09w0WFiP3U
	 36JPC2mkQtImNHwgWJunNC+QSRBVCqRtqEOJ+f9ID7EMwRScTda7AzixkseJR6ZW1Y
	 rQFCTa7olILGg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id A9659F4006E;
	Fri,  3 Oct 2025 10:41:08 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 03 Oct 2025 10:41:08 -0400
X-ME-Sender: <xms:hODfaFzzNst2fJ9nsIh_4nXMRtdtOoU9q2tLBMH-xX9onZNA8WETbg>
    <xme:hODfaFYm4nMntXtyFLKI2ForkYnY6oSWBO1aW9LL0ZVkFmd6F5PVDbRTJKVajQIah
    X7V4J01XNzwyKbVSBrKc-N77IA4dmpaw5ve69U1Y_TvHeQlarsr9AA>
X-ME-Received: <xmr:hODfaNL02WtZI4ffI5vVcDxtjDtb_nOJESyrPu5hAAfWB0RmwuqdmC1ydr4qfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdekleduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeffefgteeljedtgfekiefguefgffdugeelueffgeehvddutdefgedvfeehudejgfen
    ucffohhmrghinhepshhtrghtrdhtohdpghhithhhuhgsrdgtohhmpdhrshhtrddqqddqmh
    hmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhi
    rhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeihe
    ehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhv
    rdhnrghmvgdpnhgspghrtghpthhtohepfedtpdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopegusehilhhvohhkhhhinhdrtghomhdprhgtphhtthhopegrkhhpmheslhhinhhu
    gidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepshhhihhkvghmvghngheshh
    hurgifvghitghlohhuugdrtghomhdprhgtphhtthhopehkrghsohhnghesthgvnhgtvghn
    thdrtghomhdprhgtphhtthhopehnphhhrghmtghssehgmhgrihhlrdgtohhmpdhrtghpth
    htohepsghhvgesrhgvughhrghtrdgtohhmpdhrtghpthhtohepsggrohhhuhgrsehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopegthhhrihhslheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprgigvghlrhgrshhmuhhsshgvnhesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:hODfaLwoTx8Y67Fv462ACMflW_iHLcmVlLOv36fgFtydz1owY5aKag>
    <xmx:hODfaFPutmKdVMde_Epn7Vd3zK9_XdjhZ2Jada17jn8RhABnYcgSEg>
    <xmx:hODfaPv-C8Dzp9gAPsbMvk3yFrtxiieBrO8glu-5jXgTK13pe1Jxsg>
    <xmx:hODfaC05BylUzwxUNzxABzaWlvVUIXl2UCeONM4m3uTWGE_X8kivtQ>
    <xmx:hODfaMDHgKrDZCbX4AnEAnKDt2PIiZibepNnOOpkj6PnRh5Vgvl1fCLz>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Oct 2025 10:41:07 -0400 (EDT)
Date: Fri, 3 Oct 2025 15:41:05 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm: skip folio_activate() for mlocked folios
Message-ID: <hnpzad4aehmp6ncgwhlinzx55z3zst5dlkhsjphpazccy5lzpv@hfj2eyewuplz>
References: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aN_bix3wDpwYPoVp@shell.ilvokhin.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99A74140018
X-Stat-Signature: 1uapch76mgtxn77z6wrdgh1yb6qhzgst
X-Rspam-User: 
X-HE-Tag: 1759502471-112544
X-HE-Meta: U2FsdGVkX1/PdFKf4ne8nY/vywSrad2w9rzJ+jZvsDH7763i9zb/DybmAr3hutZnQ58/oniCv2nyHw+OzEVrID93uzsl6risgMqc+ctdLm+cZdm2HlZBGdGcUFwm4B0otd8X9UoVb4h5XDCB4PShU3Xbiuv+1G0pDoYrP1hwHfQourkmktUqJe9E0LS1wSXiPv/fIY2rAul2RZHli6L/P65YND5IN9EoCCcr19KXqAK0mqRlvp8yeirLp+qIj9D8MLCy/qKQYwwhd7ff371PVRM3Q6yllQFeOxRUcH9eHr9S6TWMc38jfcJloXRHMaxxiFLGrJkqRsdy2CKNVU6CxMZP4iELY9yWTetXOrQDDTZ8EwTaA+m28QH0gAzXroDnDsTf815V51hrIcS7Py/v9hcoK5dd4RjooIMxkTI7Xzzv9gPJAYFB0UU0+Rln/dBGmiKMUxEbxG5t8CfNCDpPegkUlgZOVfVbtEWAd7f/jIQ8JssrSQIH1SAEOSD9RmIITSx1680TaN3jBjlrATZwYNHaUrYFZp/ktZ7I2koYOaq+y034G/REcg1BXbAG1fEJuCUAEeIsRw0f1k6RdWq6XT22utUkdsx7idk2vjwkpPW8ZvZafUdxoPCggxhNHbRNJ2PC25U8vNqEUeCDK0FuH+YlBKUkXmks6E9Dc6d38QBTLeOakdhiwQSF2IHdYP4fB4FznXUmLdY+W0ZfhjgyM7x398lefxlhmJ3oGyLeeZ0EA2mwQzDjCELBVy9F9v0QxSimyht99vWLtUZu5O1sGIAZHRntY1qLs18Lv/U8nS7WbK/aDU7/K3LmQbSa/5ejJpZqGJ530RMyWYS0EW0uZTVqwpJZqphoVFdI6aHJZ30HCsVIGW6kpWIsGShYxJyeT3CN55fOu79RiL7EQ91GumwTQ1qHiWdfH0pzsArwHdEALKn6sdMd93lzMXKfTsAncMMvhBfYiRAifgpm0cl
 f6x0npui
 vIMHj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 03, 2025 at 02:19:55PM +0000, Dmitry Ilvokhin wrote:
> __mlock_folio() should update stats, when lruvec_add_folio() is called,

The update of stats is incidental to moving to unevicable LRU. But okay.

> but if folio_test_clear_lru() check failed, then __mlock_folio() gives
> up early. From the other hand, folio_mark_accessed() calls
> folio_activate() which also calls folio_test_clear_lru() down the line.
> When folio_activate() successfully removed folio from LRU,
> __mlock_folio() will not update any stats, which will lead to inaccurate
> values in /proc/meminfo as well as cgroup memory.stat.
> 
> To prevent this case from happening also check for folio_test_mlocked()
> in folio_mark_accessed(). If folio is not yet marked as unevictable, but
> already marked as mlocked, then skip folio_activate() call to allow
> __mlock_folio() to make all necessary updates.
> 
> To observe the problem mmap() and mlock() big file and check Unevictable
> and Mlocked values from /proc/meminfo. On freshly booted system without
> any other mlocked memory we expect them to match or be quite close.
> 
> See below for more detailed reproduction steps. Source code of stat.c
> is available at [1].
> 
>   $ head -c 8G < /dev/urandom > /tmp/random.bin
> 
>   $ cc -pedantic -Wall -std=c99 stat.c -O3 -o /tmp/stat
>   $ /tmp/stat
>   Unevictable:     8389668 kB
>   Mlocked:         8389700 kB
> 
>   Need to run binary twice. Problem does not reproduce on the first run,
>   but always reproduces on the second run.
> 
>   $ /tmp/stat
>   Unevictable:     5374676 kB
>   Mlocked:         8389332 kB

I think it is worth starting with the problem statement.

I like to follow this pattern of commit messages:

<Background, if needed>

<Issue statement>

<Proposed solution>

> 
> [1]: https://gist.github.com/ilvokhin/e50c3d2ff5d9f70dcbb378c6695386dd
> 
> Co-developed-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>

Your Co-developed-by is missing. See submitting-patches.rst.

> ---
>  mm/swap.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index 2260dcd2775e..f682f070160b 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -469,6 +469,16 @@ void folio_mark_accessed(struct folio *folio)
>  		 * this list is never rotated or maintained, so marking an
>  		 * unevictable page accessed has no effect.
>  		 */
> +	} else if (folio_test_mlocked(folio)) {
> +		/*
> +		 * Pages that are mlocked, but not yet on unevictable LRU.
> +		 * They might be still in mlock_fbatch waiting to be processed
> +		 * and activating it here might interfere with
> +		 * mlock_folio_batch(). __mlock_folio() will fail
> +		 * folio_test_clear_lru() check and give up. It happens because
> +		 * __folio_batch_add_and_move() clears LRU flag, when adding
> +		 * folio to activate batch.
> +		 */
>  	} else if (!folio_test_active(folio)) {
>  		/*
>  		 * If the folio is on the LRU, queue it for activation via
> -- 
> 2.47.3
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

