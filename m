Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE68CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:12:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2C98E0001; Tue,  9 Sep 2025 16:12:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C836B0007; Tue,  9 Sep 2025 16:12:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 572888E0001; Tue,  9 Sep 2025 16:12:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47E5E6B0005
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:12:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1910B11ABCA
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:12:33 +0000 (UTC)
X-FDA: 83870809386.10.95ED8A2
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 472C71C0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:12:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=woqRKFBx;
	spf=pass (imf18.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBn9GjXNrzDpJNrr5pBWBsTy/Gh6alb/avcjcidp4mE=;
	b=rhLSDtqvoCF1tCl3fL07CoF1u9bSSlGtBs8KHYwPq9bfO8qpDB18kYtfhLCERzcPtlaY94
	nJSM77zVslFAUeOgRC20nMRTWpBlInZ3wAd9RvmsAzYtG1t7VEzBqQJvwtZkhpyn/pknXs
	6Q9ZRiL/1dd9gaWOTqrVYwJtUMGl2gA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=woqRKFBx;
	spf=pass (imf18.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448751; a=rsa-sha256;
	cv=none;
	b=VHj/uJd3T8XvsAknJV7hyb7gDbJyApBwI0s976tlARgfGkEZWnhP3+5LGWjVKGFWqBi32u
	bAvpb06npZOzCub+JG+9TGsTBbiZGq9zwYPbEFYK6tiBt0/UIekruRPrSSO6gvUxtN0SJn
	UnP9Wp64UBv9xJh/B/s74V74M9yCqxA=
Date: Tue, 9 Sep 2025 20:12:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757448749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pBn9GjXNrzDpJNrr5pBWBsTy/Gh6alb/avcjcidp4mE=;
	b=woqRKFBxcgHj7ikhJEUFQZ84FxwkgwaMweAFV0Eia1mMfVN50fpFnj32IE7GzPmF/d0yDX
	kFxoj4mNHUTJEZ5Lj2s7V2DlG4YV8XWARpnBTkxED/5ef0oWOB29Jrgsyx1KDoKfSPGUe5
	uIVw0vQ1QV+5OhPRqR7RHzOCA/82erU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>, 
	Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] mm: remove zpool
Message-ID: <f3ufcsjvvxhi5gzw2wglkpedgyyi6tiaje7em3tbxkzhklphvh@sv3dbo4yba5p>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <girukcvvzgbtkxt4aftfz3lw3glvf2qsof4mx6wf5perolck5n@vaxlrtaeuzw7>
 <dh74mr7bjtpzk7frviv6iqqno2u2b27p7jiagp2dtnsz2wrfhr@wlb5vqg4majs>
 <tbvushbdn7nzitey3uy6humdndd6247r4544ngqkds3cr447e6@prnla4edwxmk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tbvushbdn7nzitey3uy6humdndd6247r4544ngqkds3cr447e6@prnla4edwxmk>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 472C71C0007
X-Rspamd-Server: rspam05
X-Stat-Signature: caku3kiouor4czuaqye67py1byb6pxqt
X-Rspam-User: 
X-HE-Tag: 1757448751-269303
X-HE-Meta: U2FsdGVkX1815b0s12M3LMPWJa0brE5a95J6cv2lX6+v/yxce+9pqkPk2C9A5goB3OlLjaP5n+6NmaKD7ryfm3pbIEj7Yur6TSpBd2IMv5KGWAC4jJ47OEvhd0CUxihOntY2Fmcn7dYhy7cJWReYD+EEBDIDZDffAZMD+/VWHwPStQZep25hrS9o/Dzi9z2JdS+yjeTMg3Qc7PRZY+fHTVGnp0jPOou7ULsnMPwPsqPP2+NHI36VxJv2bPAcEwILA4fIR4ex5f16XUeFm6gkxPKp9rsDrrb7uYjSwfFYGK16jrXY0tP+4n8AMkKEG6fPJpWGBuj93JlavpT6R9ayCHbVcQNot330jeg+2IElLhcJ6r3YK1n91nLHHAR+KqKFUrk4PAO2W+R1HWGZj3fW6kc7UDF5ohRRIudPjWEz4pHE4i72iW8dTca3WdHKscUIq4kyJQGz+OjJUWFy0lH4SVF7pXb9e2gQaSsqOFs/LFS3RQnu3p0bCuq0wl0zg4FhpHTjoQhK3yx6yqgGsbAcVVAZ3gZeMRo43iumxibE+iy5ny0lTiRdeeixZiQi5CZ+dGct0Vizz/i1rkmF7GzYooJjk4sLuhwQvV5aGDH9OWFVF9KOmnhr+6GebQfe72pIfpc9R/0OLf3JxrFqirnubfAy+fAP6xLbSHjddaUre7Vdboas5MnrsUzNr+vdmcVAAu7Bt/rsb6+erIMXdbAMOtQ5tc2Uioeup4eh8rlvxSgpnHwFGbjywLDPAy5wbTQTZR92T/uVFgeocQiB1bfUUJvshMhdDIM4giOkcR00OqJ2P8IslOcNBmxk6ro+HpyeRN7QM8v5gtJrQ3p0ukbRS8mYilHm+DmQijwBEhzzyrd46L9hCxUWL6fLb1ogiF/csn5YLanGo9J2UwDImyWi0sJe9IOMdGfIiNbRdPvBYLzHzBPdI/EKiPHS0uNf9ESL8skMNc6RTVicZYU6qtZ
 rNpghJtV
 WZwUTwBKsL6mWLtN/P05wM8D3Faclog2Tw3yazHoLb9QxD/sH8tVbv24DexE2EjFfJpRtE87bdvzD8F4qaZxheQRqWl+ZwgpQTZVtWsXQTGvOFxXTup6QOHkUfJVn8ApK5f4GDYSnAXGu+yqWLOsjIM8omYLVa3fvV2uYE25/AOludg06g3I9WipYErVu4u1NbzcsWLyG3obRBoo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 09:18:01PM +0900, Sergey Senozhatsky wrote:
> On (25/09/06 14:25), Sergey Senozhatsky wrote:
> > On (25/09/05 19:57), Yosry Ahmed wrote:
> > > I think Android uses zram+zsmalloc with 16K pages. Perhaps Sergey could
> > > confirm.
> > 
> > I'm not working on android directly,
> > 
> > I can confirm that android uses zram+zsmalloc.  As of 16K pages, there
> > was a way to toggle 16k pages on android (via system settings), I don't
> > know if this is the default now.
> 
> While I don't know what zsmalloc struggles Vitaly is referring to in
> particular, off the top of my head, zsmalloc does memcpy()'s for objects
> that span multiple pages, when zsmalloc kmap()'s both physical pages and
> memcpy()'s chunks of the object into a provided buffer. With 16K pages
> we can have rather larger compressed objects, so those memcpy() are likely
> more visible.  Attacking this would be a good idea, I guess.

Yeah I personally think attacking whatever problems zsmalloc has with
16K pages is the way to go.

