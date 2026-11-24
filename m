Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9209606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=INNJCb92
Received: by kanga.kvack.org (Postfix)
	id B3DF66B07A4; Tue, 24 Nov 2026 11:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15066B07A6; Tue, 24 Nov 2026 11:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52DC6B07A8; Tue, 24 Nov 2026 11:02:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7697C6B07A4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:02:55 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C81C680BB1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:02:54 +0000 (UTC)
X-FDA: 85470481068.26.676D857
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id D428D180010
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:02:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INNJCb92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795536172;
	b=Mp6ldmaRVyFFXNMCL7Plb59h+RKNfaf3k6nMEG5AF0VVm5GFhyjzFvxU0Z9KtF0FEYCNFw
	Z/2/qYMJto7J4EG0nhQaHUkym9DEfN7ZyliMnxBsY7RNXbdlxd094GdhV//5cnreg1mMgS
	00c4Ml9PRxZCeroePNE3FGn9c7hyXZY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AiZLtA/3YMgR6YZc3hcO/tiSfg7h3YiULHCkBE637o8=;
	b=MpTb/7gQBd6IT22uDnPYhfrAEpxIW4mpVRWkL4cxygj006VYCol9o9ryqBr7yZRTV/hhrf
	2O2ULMHPC1Jhjzm8YxRfWEk/3tsbmWnV50fNpvVk16WE89ggPo7D527fjXebQNSQxsEuYj
	UgoycI4QMcOEARs5J03UHJ+Hop6caNY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=INNJCb92;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4E2A960181;
	Tue, 24 Nov 2026 16:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318D11F000EB;
	Tue, 24 Nov 2026 16:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795536171;
	bh=AiZLtA/3YMgR6YZc3hcO/tiSfg7h3YiULHCkBE637o8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=INNJCb92BCPMoeQ/s4NhkF2nZaTJFjgvUpD5wG9n1i7TV4Aya9aB3wnFjILth/kJE
	 R4g8yiMCnb2oddKPa67H+BG5mL+LIB0C+bQPBnj1UcUvo0ZjT7N87oNYcIwZXryuSp
	 +mX9J1k9rKjaCt+m+C4D/ERKuXNw+lgo/x4VU+MxHur1JIjj8EaNdMnFbWwWpvspr5
	 l4sPkne+H308Ai/Zr3prs5rDdo/U5qoaGdeE/vLpDdjhNnZeJax0ixfEqhS0eiDTb3
	 My5Xpj2Hu/eQZUbDXEpV0nIHGVxFoCRNvqnPSyRHy5qkKGpMQnaVzdpG3hd2hlU2hY
	 yPp99kzZ6RUeg==
Date: Tue, 24 Nov 2026 18:02:45 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	mm-commits@vger.kernel.org
Subject: Re: Using In-reply-to: <patch posting> in mm-commits mails?
Message-ID: <awW1JUdzBHiL4Kuf@kernel.org>
References: <9ba54069-3dc4-422f-8cf6-f81cb806e999@kernel.org>
 <20261118212538.7e6f11f0553d548a03c9c456@linux-foundation.org>
 <b7474fd4-eb88-4472-9e8f-26ef6c646694@kernel.org>
 <8691815d-1c62-4519-907a-110b2d12b9b5@kernel.org>
 <7ebcd1fe-8a98-4c12-9508-0399570e6a6d@kernel.org>
 <f2dc7958-638d-45f8-845b-a35b50355988@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2dc7958-638d-45f8-845b-a35b50355988@kernel.org>
X-Rspamd-Queue-Id: D428D180010
X-Stat-Signature: yytajep489c3umapj1ftgn3jur6z88ws
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795536172-975195
X-HE-Meta: U2FsdGVkX1+r7pCS8SaoYhTzfmyInKJQ+45LQjQqTW8/bYJNs1bco5wl4l1pm5wbmkayw6Lsm9lG3/oFavvH9KC8v7Wc5UEYGgXQ9KdyYz+Xdxxk1fybvyEUEQudC3vvPl8IKeUzWiQkgatLzr/lKxO24YVWVRPD690df2VYOprUOjemQQiH8vWyhdKDEHjVpnPLjN0otAoGdrQ/ZwWgsMF25kp0AxDytoSqRQYnkDQ7pw/ZZDC2vWPTHw/tRh2HJQYFawAxlrhiYeiNsGQJ+0FuA5jPjUf29Od/ouRh7LZeM3i4KawC/jFFx84IQXDgsRAV+3MyCHz282+rzHc3B207gVUDsstbI+ussyW0tyCsOdFFpl3c7W+8ubGoa8P50kVwqbmRY1xz0dAR/t8uPufOj91W6thuoPYiBPj0BbtuEDyBSj9PJqYNzcpT7bPxIuUahnCSjhg18VqBM+pcyfKBYmJG9Vxy5gRZDLfqasBIwJxeQQPI6tjS9wN54VzEmStJ1uiUrAtT0dtYC6WyIZovDEv0HCwF/kT359aZRMsIzdrTfHX/LfVG073vIoX1bDyD0W4dfn1mhDhWFekOMqzjxzuu8sOigg28lnHkfg3OP2RcqoDZtIt41UyFnIWn7vZGl6fIyo7bNwb3jBRMJeIbwYZQ7I14NWYhp4Gx77TyQFkxBm+mIET5po9MM0eNtMGcNmvjzaopTKT+ztE/WvL8Z5PfSlSRXtEO1+Y+LQgDZgNMPY2CAF/vZ2nwB2NidZfhdJY1TNdNR6/Z7Dd9XDMIOO2/CFzmL7NXOTUVbU2KMFlP5CkIsZo9JR1BTsQGDp+DJVESbuEKIlm3owNmpgdaubJdmocxFCxhuCoavyAVokHxrKW+EaRXxG2qDIt9vJLmiYadBPyRIsjVGb8rA3CCpdwocb3nDr0ZBL03GpOaX3khEfLazC2FZkau9WQI1WXKVW5g1gENU6aon4e
 T4YtleLg
 1lphdpR3NcFSDaPyhqYuasBrxPGpJX6lcscV3LcyEd5UebepasZCQHtHudCxHtjhUWylUy52GU9rpKaLUZpF/v39OC62qkE6uPlYe5WhmItvRNFJvvhNWwTWIrs2+UBwOpl/pnvOvhhFI8BG0kmq41b4QdIbdhX11e1aAKQyBPZ/nBTPnfaPn06OZUGgaSDZwlMn9UYRJfPSiZlDMLCldTx9TfKnVLEbsAHqzJZaC1QnJf0r0UxPa8DHFKpWo+g33bmq5YrOK8gi0cXWJerDXMu1cuCH/cwayVhkoI0+suGfAMfniy2ZJH3k4FC23g5TeCZvFlIwDyu1l8mYsxaRhCpNLbx5A4MlofYIXxGccPf7ulUeVgQ/yW61GIeKiEbu/g1bZkvAk8oJfOrM4NEe3rVtvPeQUCaJxVE8tYoGFa2dfGp4FRIBlg+B8ofmc+W4JBnyJjI00nUpgUYge23hxTB9BKV/4277+t4Gzy6iDWZ2+vPt7VeMzoIjOJJWdZy4xcfn0Pp2Q07Qls2/cXKfHNxeaLC6BAteNY6apUN0/qsiaSRatD3IKoBAe0eda+MqEyPmw8k5Sm+adFWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 10:54:04AM +0100, David Hildenbrand (Arm) wrote:
> On 11/24/26 10:49, Vlastimil Babka (SUSE) wrote:
> > On 11/24/26 09:22, David Hildenbrand (Arm) wrote:
> >> On 11/19/26 11:07, Vlastimil Babka (SUSE) wrote:
> >>>
> >>> Seems it is, thanks a lot!
> >>>
> >>>
> >>> Yes "just to the original" is what I meant.
> >>>
> >>>
> >>> Yeah. After all, the same is true for lore.kernel.org :)
> >>
> >> I works but it makes b4 go nuts when I try to pick something that Andrew picked (too ;) ) early.
> > 
> > Hmm wonder if there's a way to make b4 filter those out, or we ask
> > Konstantin to add that way.
> 
> One has to use --single-message, but that won't work on multi-patch series.
> Maybe "-P 1-3" etc will work.

Not sure it'll still work with -M or -H though
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

