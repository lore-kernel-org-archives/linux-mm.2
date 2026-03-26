Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8322310A3D89
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9FD6B008C; Thu, 26 Mar 2026 08:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A8F6B0093; Thu, 26 Mar 2026 08:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80DA6B0095; Thu, 26 Mar 2026 08:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A76A86B008C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:29:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B2D18D016
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:29:17 +0000 (UTC)
X-FDA: 84588144354.24.2106CF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A29301C0017
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:29:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lViYXTLs;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lViYXTLs;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528155; a=rsa-sha256;
	cv=none;
	b=eunbhjaP8Hht3zlsUl9HgRRCExtetpfakPzRyzxTI9ZJvuWnAFjqXMaRvGFXBtlEysHaLK
	AUO4oDFQSZ8DpCKPicrRYW4hb2zzmCICPOS3x4UdoaSKvks5Kbc6QmlTqM6CxgkiGBiuS0
	rzvyCvelMN0NRvNxB24yjs7EFttIB3U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHQo2d6U6dnT2K4Z4sQ9LVYx+GRJP5LTDe0a0UuxG6A=;
	b=7T/y0fUt6nrfMOOQ6omdbXYNToR7MB7E+3G1TEoN/KArySmn1nM8kc3dy+9vMBDMWNita+
	VG/G0FNaksxbMrBPJyoQq38iH6vlWNeNmDg3HqGZSpYJoJkych573i9ktu3gCaULX2CFfj
	aKBThlUAbTcHWdCLXeQ/Gyd7Lo8VQU4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0BD1160123;
	Thu, 26 Mar 2026 12:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE70C116C6;
	Thu, 26 Mar 2026 12:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774528154;
	bh=MHQo2d6U6dnT2K4Z4sQ9LVYx+GRJP5LTDe0a0UuxG6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lViYXTLsqRu3Jc8wzyhmTZ5k5+60c0IW5OAeqZGUFl9nVp/UqWPsWrjb6SOm7dlrf
	 o1bH6m4Jx4eRmA5S7/8WYIe+b5c2qYtfJHVo363ORZyOFvWok5PMxuOr+FvqacktfV
	 MgvdX254htnWfi3MHldjJEGhp4ggMat6Qn7NfZrzFhAlSd8wmR/3fOclxOWDk5L4fA
	 grW9HhZ0BCHG/xBw6eK2996LSpmv2VUj3h4+ulAvmcQmdkvnCKckIWK2XRg8Mx3FvT
	 5I+zGjOJtjhqo15Mp9YP0l0kn0HtV4B0ttMlCYsi1ek1wQz/2J1G2xYKbYpKOBTUNT
	 uho4lWZZCwnGA==
Date: Thu, 26 Mar 2026 12:29:09 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Josh Law <objecting@objecting.org>, Josh Law <hlcj1234567@gmail.com>, 
	SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <kees@kernel.org>, 
	Greg KH <gregkh@linuxfoundation.org>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] mm/damon: introduce DAMON-based NUMA memory tiering
 module
Message-ID: <ae7dc7de-966e-4e04-bb55-318d97c61909@lucifer.local>
References: <20260326072737.341964-1-objecting@objecting.org>
 <cbd0aafa-bd45-4f4d-a2dd-440473657dba@lucifer.local>
 <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2cdda38-1007-41a7-a992-de953a088a08@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A29301C0017
X-Stat-Signature: 3upc49s8cnf6qbsrbqkayeuyydnogwsz
X-Rspam-User: 
X-HE-Tag: 1774528155-396037
X-HE-Meta: U2FsdGVkX1/IBhf2ydJ7YNXI3gtqiyWFVgSdo5xUT3hiHQj7/X+ZzpdaCCDQYEf+g3NgHmp1GFsOzqAMLJH0NfSMf09Mc6sp5icb9qIKZ1s8g/dQCJ7ydfRWwnBFX+AI4EHeM+rQVPbABNXKQwM5ue/GenSy8Hl2WMa9qWaPS4XL4gbiYFzU8sgcqKdhVPDUlK5iXbTZn4l5pLbEh586uanm5nfs1BBJtwCebSkg39B2IPdMFswmtmPjm1cyFUZtJa431ITm4ZVdb+FRf3dY+Ijtcj7oY28lGErjnox+2mFeORBx9E2x+4+z1fPq0eSt7/0yd7tTr2BBKjR1xjBJCJ0FhPFbGZLrrAtdtlxnFuNoKnDXVXuZSbFCohNtBSCxiFyVsYI8PuxfEknM/VL0E8DxCjsC8rKt6S5lTpq28l3mb6u3gMDp7YcsVMQGoXPXOrFo3rJQy3lDP13WUM4gnxJurTm9BaaLfzfmfUlObB24fe6l8Pa4JMN//RFDbHk89Otg2pHlT91Z8ZmUvCHLBZXx92uIBxhhh13Th2YC87H1WlMGs8ujgjuWrCiTo2MMGRoQ71b1/sdbdKGYFwJkMMJ6ZIVdibl05hpn3TsNaG2ba7X2ZMKCoG8SGUEAyGVC7eYiSc5/jWdpVrWtXM5yxB1HfjeK889/PhfiPnRbbRrfQCNdPmN4jjBofzOC7D0IFkRKFCQS9XLCG2pbFWt2ThDlN072Y+zvZXrIA2NZf2nPA0HYZy3IShO33d67qHjRvsIb6K7jmkrgW7NqKwX7FcEZJQ9yenePKUn50/sun5JligtY6ZOsU9czkZKq+G+xdQP7aVllbSYRMgoF5Uj3ItyWReqYGcdPNkPI+61RRpBSJfkKgB8UGDGZJfR99vqzt++56Lynq0+NrDeSjen46GC+kpHPKr6LW69ybEHMJkXmzZ+/Rlu95n+mZoWbfXMl++3sBDwfghibD6lLljF
 Kbxs63Xe
 J/jb89gvRLjIMGLNi2K2CmmcBbJoeFTPKgKHyXGXsBhTmcUB/X/HrnXtcbdVB6P/gfraTL3/AULLFOB3etk8zECs6WJPyQwgzzReJS4RBfH591SMowgneO3WiyNlJPaDX3MJQAmy5G9RatPO5mHtQomG0BvuoSQBabGrUO+SC61mLO8s9uhpqJEJlc8C2QKpRSvmJjMb4/+OHHVKUtdSveqNfm4cz4IXXGZf7tphENHYhIEEeYolgfEXbfO4bWyGgSk37QiKOyiKJC8Gz2hPmOVl7k2OWqnDbdVGuOT/Pna7Gd6IDRr6Wz3bEN0j0B54gkUJsdO92ReeVanZLzXVDJI93aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(+cc Christian as referencing his post)

On Thu, Mar 26, 2026 at 01:12:03PM +0100, Krzysztof Kozlowski wrote:
> On 26/03/2026 11:34, Lorenzo Stoakes (Oracle) wrote:
>
> Trimming context, I agree with everything said by Lorenzo, very detailed
> analysis.

Thanks!

[snip]

>
> This patch also targets NUMA which is quite unpopular setup for
> hobbyist. I don't have any NUMA around me for years... Even my build
> machines are not NUMA. How did you get one as a hobbyist?
>
> Also after looking at the code style in this patch, after "reviews" [1]
> and "acks" [2] (quotes on purpose) this account gave on various patches,
> let's look what was admitted 3 weeks ago:
>
> https://lore.kernel.org/all/f8772114-a495-409b-a590-a9b1d8ed1d41@gmail.com/
>
> > I'm learning this Linux system day by day
>
> So learning or adding serious code for MM for NUMA machines?
>
> > I own this device ...
>
> This is about Xilinx AXIS FIFO which is an FPGA IP core. No way you have
> it. It's not popular, no easy way to get it in common embedded boards.
>
> Even assuming if you have embedded FPGA device and work on it, the jump
> from embedded to NUMA is just stunning.
>
> Answering to reviewers with whatever confirmation they look for is also
> a warning sign of non-trustworthy behavior. Or rather behavior trying to
> get trust.
>
> [1]
> https://lore.kernel.org/all/D47F8215-FD08-45ED-AB01-0A5C48CD41DD@objecting.org/
>
> [2]
> https://lore.kernel.org/all/2F84DD09-2880-45E0-AA98-204F10848F85@objecting.org/
>
> Best regards,
> Krzysztof

Yeah this is really adding up to somebody abusing the kernel process. I think
'Josh Law' or any other pseudonym that can be traced back to whoever's behind
this should be banned from the mailing list altogether.

Also, as per Christian ([3]), it seems this guy was using the pseudonym
"techyguyperplexable".

There's a github with the same name ([4]), and that same user made a comment on an
openclaw issue relating to linking it to gemini ([5]).

So it seems likely he/she is likely using openclaw to fully automate this 'Josh
Law' user and we're speaking to a bot here.

(Screenshots have been taken for the (possibly inevitable) deleting that will
happen later.)

[3]:https://lore.kernel.org/all/20260313-halskette-annahme-94e782eb4ae4@brauner/
[4]:https://github.com/techyguyperplexable
[5]:https://github.com/openclaw/openclaw/issues/44134#issuecomment-4106247302

Cheers, Lorenzo

