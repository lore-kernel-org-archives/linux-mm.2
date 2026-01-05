Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C45CD0424
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 23:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CA16B008A; Mon,  5 Jan 2026 18:21:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11CD16B0093; Mon,  5 Jan 2026 18:21:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0260D6B0095; Mon,  5 Jan 2026 18:21:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E3C2A6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:21:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AB6057B93
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:21:14 +0000 (UTC)
X-FDA: 84299483268.22.0E48C25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 98E3920003
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 23:21:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JuG+BVVZ;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767655272; a=rsa-sha256;
	cv=none;
	b=GNbTVWP+p508slHFe9vuEStDZwyp5NSBpiNY/K07ohDvB4y8lPhTupGdazKmWQE9eE7Csg
	V/dQNd5GB1nEUitrwwWmmB8vPp1m3fs2FDg3Fzfsb4acPBt618czslnH2eBCD2EUup6Tya
	TYDkDpHpmMzAF668ZpYRtM8L0Fpg4TA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=JuG+BVVZ;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767655272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4Fh03GfyqDnr6R/Yk0MqkXrcxDN8h6BgULbs5go2T0=;
	b=LI3Bn4KJ8teHeb50MqiUxzfa6JN1p7UHRI4jOhjGGHYwkprJc9dJcsY1Nw92X8qgJRn1WC
	PhDdUzLmPuAxziiFfIGAwxCepG7QTxJJn7mQg7AGI621/llZ+ywiQFhgJ9hLsm/mLrkNUJ
	iyDrEOjp+zanjVhk8SlK41P1oUo6wMs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB2886011E;
	Mon,  5 Jan 2026 23:21:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C88C116D0;
	Mon,  5 Jan 2026 23:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767655271;
	bh=DJd1PYf9+LG+E2hOieXrVcjf2JpF41ohLEEqz7guBrY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JuG+BVVZ0gVdEKKaoG4eLJTOXCsg/xg3b66moKxrPd0Ajya85cBeozZW8ti6dwSBf
	 gwO/iQMv6oxg8JpIs0kCB+09Lfpw2J2PlDeX7pv4HvoLzGn402/HyLooJKQ15fXtVO
	 835rHAkLjpTQ3yzTK3RYp+4JzPQ267sPsymUblUw=
Date: Mon, 5 Jan 2026 15:21:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alex Deucher
 <alexander.deucher@amd.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, David Hildenbrand <david@redhat.com>,
 amd-gfx@lists.freedesktop.org, linux-mm@kvack.org, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 1/3] tools/testing/vma/vma_internal.h: provide
 fatal_signal_pending
Message-Id: <20260105152110.c3c90aae00096db3d472c02e@linux-foundation.org>
In-Reply-To: <18f7f4ff-67f8-4a39-b6c4-893bfbed4955@lucifer.local>
References: <45dd9b02-7867-6e5a-4a64-02c4d43c9b68@redhat.com>
	<18f7f4ff-67f8-4a39-b6c4-893bfbed4955@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 98E3920003
X-Rspamd-Server: rspam04
X-Stat-Signature: zwky7y4gf16byxitt4qq35ek8i64po9o
X-HE-Tag: 1767655272-73547
X-HE-Meta: U2FsdGVkX1/RWuZzO4AzA4RvRuAYyz9fvqkpbx+0fNFTgtJYh8Ighl9e17UBYpS/v9XvQ0HjRK48U4sOZ+JNYwlU0otacmvDyBhTl1FhgG+g/vGEiqx1aD/KcFzlhCBli3ihXW+VLP4MteXzW50J7SalzgIV0qr3zGlAMFA/mRHH2T83PF51f/T8hRyhivRBGeNRTopmNSg/3scZF7NAsOVsnqXmBkQ9CgaiwStWgbZYIpQesfkPPCnmDWYYjpGCSf6o46qqScg6negLTxUkLqWDvpXpbnonBLzw7RqcIh/55WSIz3xc8xIsTLyJ9phYbXFzjy8MaRXB1rK4sbFcZkLuCCHLZvF8muwscOMJ3nF12XUAncdhs+uumFitU/TsiYzYG1z/43Ls4GGN43xoWS0gtoIfQfLn0jwyy2LqM1oI+/kQPikvgb+RySiFZiNAr7ZxxvcsDrtYYgdgWouiI4SKedSm2hRxWX6ikjKQ0sp3PnPTZKiCrErBaBapXAK8mJFN+QOKddeaUItEx5+K6kHB13UFoumlzC0u7PCEj/EnaATFZYRSLrUQMwZ27NbGuj77JhnDHdJ94+3SDJJ6BpvUlQJSdXiasom+G0JTWPoWEOV74kQNcARMmJyxn1AHHwPJpAKCCgTkGJcvsTUoX2SDPnDbA7HaicI4szG775kAg1qT1y2+OKC/XsLuUqfrZ6LUCbu/NdQcKXCdYrKpSDUWPpcyyB6mCalZ6Jgsqt4DGbt5eSD2pe15xzVgLWeJ4cnzWlpbg8v2UerssdmRzSUIzXSimQW0XMp4Fbn2aEzVry+TpyNoLCRSlUS9dGhti2dhOb/C93zzid4GRoXulLUHvxvVgzPklsqwwwr3Ug3L1H8KVuza9oWtSZE3c1bTBFGgqSe+sQeQdBjaFpCIRkPMXcy5tPpvijzj+xZx03AJdeY/MrQek15QuDlRx9E7b+6UMf2HZxkSjzOuoMP
 o3ncIYXU
 AF+Vu6wg3hGvdVXAAIZ8pSmtyPaBedv5XhQd0VF41LHN/2ObqVRL0hgS4TJP3QsMdL7ZN8xUxY0FFBHsJw/bp9YRzFS1WtDrc2RnzNQrU9dFN/IMtnx85s56Gfj+b++9FSSBd3OuRy29abhKmMYJ7MIbS5pc6Lry3Dhm/z42LQRp02GDoLFhxDgPhKM0/BKz6ff+Llb25hoSWiG5Ygaz36bhDn9M1Y3zs67vsMaX4y5QLvsclY4URJof9llAaTuYX72gI3q48ecYMlay+2BUS2ieSnAsXC3b103042q4+TUt4WmYF3r8LxnxI6r09dV7zEy++O3HrIsy39X4TpIuh4dsBisxX1hzbAkazPonWTBph5I+tfeAmpol70Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 5 Jan 2026 12:18:59 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> On Sun, Jan 04, 2026 at 10:15:36PM +0100, Mikulas Patocka wrote:
> > Provide a dummy function fatal_signal_pending, because it will be used in
> > the following patch in the function mm_take_all_locks.
> >
> > This commit avoids a test failure when the following patch will be apllied.
> >
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > Cc: stable@vger.kernel.org
> 
> No, please don't cc stable. Also don't cc stable without a Fixes tag.
> 
> This isn't backportable given you now need to backport to 5.10, 5.15, 6.1, 6.6,
> 6.12, 6.17.
> 
> I'm not sure how Andrew deals with a mix of Cc: stable and not-cc-stable patches
> in a series, think he generally doesn't like,

Well they have different routes into mainline.  cc:stable stuff goes
into current -rc and non-cc:stable material goes into next -rc1.  They
land in different branches of mm.git.  So it's best to separate these
things.

otoh, if the fix isn't urgent (like this one) then it's OK to add
cc:stable material into next -rc1 - it'll get there eventually.

> but I'm not sure how exactly we
> are supposed to express order here otherwise. Andrew?

hm.  We could just fix the bug, then when that fix lands in mainline
and has a stable hash we could prepare selftests fixups with
Fixes:that.

I do feel that Fixes: is a bit of a misnomer.  I treat it as a message
from us to -stable maintainers:
Please-add-this-to-any-kernel-which-contains:

