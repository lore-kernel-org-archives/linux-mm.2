Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F288010BA45F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2F96B00B6; Fri, 27 Mar 2026 05:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3770C6B00B7; Fri, 27 Mar 2026 05:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288E86B00B8; Fri, 27 Mar 2026 05:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 107076B00B6
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:25:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1CAD8D8EC
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:25:32 +0000 (UTC)
X-FDA: 84591310104.22.607D074
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2729D80004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:25:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmaF744H;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WmaF744H;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774603531; a=rsa-sha256;
	cv=none;
	b=QoTATzX3bIPyecCkBR2Z6mZyIWAbhBuevanC9Bi4qKKXyK/oYROEiSu5ZKujBoIwTeHB6W
	vAgcJ2LHaDABc0CGI4VyHyut5gtqR1GcVkU/2LCUIeQZlKuXkRmP9P7V567ON9iaHYPIUa
	i1AhAzht7QKdT+us7yzfqVWDJFlAHHQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774603531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1ism79nJfn/cEtGypwqofF2VKU2iXSfP9bNn9U8VUM=;
	b=cJHBQaQaJxiAcxoRg+L3sckbjvxfwJWTdPpdyLF23ZHI2FVG9V9Ieaau7SX2Pz9KV/yBR8
	XV8EmhGyRQ6JtxvaPyNic7i87HoEx7x7OClEKWp1/Xh7/KxWz5p+OL77EX+WkubWytcTMy
	KtmdLey4jdg0mOkFvYcjoIlvMOmM1Ns=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B9F96133B;
	Fri, 27 Mar 2026 09:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7BEC19423;
	Fri, 27 Mar 2026 09:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774603530;
	bh=q1ism79nJfn/cEtGypwqofF2VKU2iXSfP9bNn9U8VUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WmaF744HVRFoUZuE9WelikX7CssORJvCcgjqvHAlHItCZonH1f5u3pjVqPu2pmNwp
	 0sOJELio9ATZHzGY1mVGObw+Tj+ohu4ZlzfgUHHShjnGHOR4dUZH1xacEXI3dnxcCp
	 EPLuQMpDGTQFJ6BT1KDFfyUJZB6B2Qsux4f40zQaPLLMtx14hJ4SV9M9QHDzNZ1Hmg
	 qS/wTO148ZrNsrmGjIVpE0dqOE0Hznelj+tzTWUKV8e/iMqwYv814Ef3aQMBHHZ8F+
	 WqEr18L/sAwg5B4z4KKGy9OErz7dmEjltoJtuBoYAp8fZcOBM+JhLzwbWduY4hEBwv
	 PVr5K0M6Wu7Wg==
Date: Fri, 27 Mar 2026 09:25:21 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, linux-mm@kvack.org, fvdl@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, 
	baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, maddy@linux.ibm.com, mpe@ellerman.id.au, 
	linuxppc-dev@lists.ozlabs.org, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [v3 00/24] mm: thp: lazy PTE page table allocation at PMD split
 time
Message-ID: <cf36f821-8285-4b9f-b1fd-e080292f4204@lucifer.local>
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <48d7c810-d219-4346-9e8b-d70243445a91@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d7c810-d219-4346-9e8b-d70243445a91@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2729D80004
X-Stat-Signature: 9sdyytxmgbd7rwtuxaquggbmmetkwuxw
X-Rspam-User: 
X-HE-Tag: 1774603530-883324
X-HE-Meta: U2FsdGVkX19ZpQW4BxZ3u+EJmQb3knEQcYpTNxoouNPMfBaI/P3Lt3EqbIwdZB2P3tSu8fKxoy8oPeSiWweRAB+3Vy7tVx9+ThQcidkAGrQK5qJgoKpu6GdTCyuHYwh0FbsjIgPAdud8b/I1XrElmFKPi6wpTQOamPZWPBFPuWhyU8ZDjvLttjqDCmnqpx3kr0USiUtpQMT2UqbxqCx1F3pbXCoLE6iccQYCHx8Flk9WiSihFbn9C0f7OOvXjYIvdqzcbxYmJGmkB1AQsmw0oTqYntSm4kpPyH3snFcj32jrH1DALbO0hVR8wHlc+078aR9J4oHKPScNtOFhvpgbYHxTamFLHPs59sN7uQY9rnPdHCfRF4wo5ut3GNBkTrVmgt2kIS8fg8ARSkRmC5q/5SOkl25Nu0sJ4kRu5CQx3C4q6YTyCI1p7i7aIE9qDzmSa4r5DXU5kaZ1MKN4YzHcMcsrOTfe49yuXso1i/QAvNcmmHcmM8Y+EExsxp1JXTx8IuHPAPzLA0d71Mt+85asxICE+XixIka0DZYRPEK1e4rTX0Cl7HMzj6Vs1RmZKefRQ7BvnrDiA+WrpWQ6CmYeRTfxKQqagITbPZGuF2sYYTxzDZApc4LLYJW5+9MySI9sQd7KTB2gDwWTrcFTnMujyplI8iHEjXRK6YiLflf56O8adj8VrGbUa2R63y+NBNzGZhkahQyLKBo+zLHXG/6IeDesF7gO3ZoNtKGTNWpYWCJdO+q7IXEI1iWEuTEkgBnD+EiCjk7veiK05frh6uE10s9Lhxh+q5RhcJlwEuRc8tLThewoxD4kP1epYfKUR7wVAEmasVdWLaK/kIDSh4XN1kVnxt3gHWGIF99PuEJrSCwE8lnff/8W2upt063/m4FHepM6YpUxCsh00IPx4f+xuiZ9xRXeZQVj36gNwC2vq2/iFI7y40gm6rj/DzUqFa4ddeSyl3GipDe0m9024lH
 7fooszOE
 +xmR8vqw8/AdoeT2n9tOhuhNtodK8TEHYionrLghKxQbGNAKLpE8Nx+jNZUTV1hvbvnn81A64UFmtiu8Ix4WOxm4EwY1Vbrt0KleLnh96f2bMfehdP3y1zMiq3xBEUCqaC9X5UqnjgzYbUOYzi+bAx/WkLjaF92FafgBgliux/IW+domTxmdowkkoXpdLyv44q+xFAr+KNbHsQWVVD1jylwQzkTL66UL+aAJOhGVZKvDppzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 09:51:31AM +0100, David Hildenbrand (Arm) wrote:
> >
> > RFC v2 -> v3: https://lore.kernel.org/all/de0dc7ec-7a8d-4b1a-a419-1d97d2e4d510@linux.dev/
>
> Note that we usually go from RFC to v1.
>
> I'll put this series on my review backlog, but it will take some time
> until I get to it (it won't make the next release either way :) ).

Yeah, please update to v1 from RFC because I'm looking at this and wondering
where v1, v2 was and why I didn't see them...

Generally I'd also advise un-RFC'ing a biiiig series IDEALLY be done early in a
merge window :)

We've pretty much shut the door to new series this cycle, but being so late in
the window at -rc5 would mean no way for this one anyway.

But in general it's going to be a rebase pain this, and I'd rather not see it
land in mm-unstable at this point, because that's supposed to be 'what's in the
next release' and it's stuff like this that leads to 'I am not sure what
mm-unstable represents any more' being a thing.

I think in an ideal world we'd ONLY see this in mm-new.

I wonder if we need some process for un-RFC'ing really, where somebody kinda
asks rather than it being a vibes thing as it is now (or a 'people don't reply
to my RFC' which yes I'm guilty of :)

Anyway this is more general points and not about you Usama, because - hey - all
this stuff is pretty unclear generally.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

