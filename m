Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D37BC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 15:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00496B0099; Mon, 24 Aug 2026 11:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1106B009F; Mon, 24 Aug 2026 11:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA1A6B00A0; Mon, 24 Aug 2026 11:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6C46B0099
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:18:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D62EEA2A12
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:18:07 +0000 (UTC)
X-FDA: 85136518614.03.B00E682
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4912A40007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:18:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YaD5N428;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787584686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRkdCRDd5DGTw1XP8I1j8OznBs+VPl3xYajo68rzgCo=;
	b=Labd7Eba2z3F2trvGKOYOMVz3vlv2FmuC3GA1d2W/U85Y+layrSynpyCKiWxz8CRQLAL/W
	bpUOZtnOWnzmp5POds/7y74Hx19Q5l+5agwJm/jAmx1rAUuPrn8Io8MWiATDWDrukvwqaz
	o3bYZ13JXWG6pBrVELwtDZEoNh2++K8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787584686;
	b=WbPyMnmrvI1nX0NU1M15w66C8vXns7GthgqYps+ZHU3ooymMOXc88EKsTt2eH6QPBSW/Th
	pOh6LjrIVtux1hg/Vv3RG+XnUpGByEuncbQnvthEXeoVXW9AlaQxjDUOn3Q7CDvfEp7Bb3
	ruaA/7gdBqYipp2teb4vclMtwZHFOf4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YaD5N428;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7571D411A3;
	Mon, 24 Aug 2026 15:18:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1444B1F000E9;
	Mon, 24 Aug 2026 15:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787584685;
	bh=oRkdCRDd5DGTw1XP8I1j8OznBs+VPl3xYajo68rzgCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YaD5N428vJhzG9TRHwWbFwqPkU+r1GjapmvFLNPkboc0mWNWp/XdFzF+agImf+jgy
	 HJL45Wf1UVdWoAmK8l8LMIJ1stq2InmZRRC4Ths2Q6I+FhIuMIU1oFqCEFxjWf8RG1
	 dEQyleWxgK2bBIC0XcVZRq6aO/sIVRbX/x3zM8pvTbUdjCflNebuj6yU0x1w+/4PtI
	 qFhrRsDM873/xRwzVYyHdHN8c62aPLD0BzY+ypz6gNDoggREmj/qbAMhZX64KHUSuA
	 vCLvwpaYwuOt8DldunbkDqtdmxc6T8mBeCCuvZSqHGgF2YU9CBdJC2qIJK6Qp3h4lP
	 cGXOmJazvDtFA==
Date: Mon, 24 Aug 2026 18:18:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] memblock: remove conditional return with no effect
Message-ID: <aoxgqPLJVfP3e1D7@kernel.org>
References: <20260823154840.3793140-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823154840.3793140-1-ekffu200098@gmail.com>
X-Rspam-User: 
X-Stat-Signature: gt4id6cxky9r8ndooc6jepp8jrnxtntj
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4912A40007
X-HE-Tag: 1787584686-410895
X-HE-Meta: U2FsdGVkX184D2X+RAtNdJNVa2sS/ddWbGR/n/Uin/tufXRzVAnJLe1yAAovIBb3ywGv/HR+EovglPe3jUOHOFI4do09OzlKaNYEW/9lP8ejrc0POnCFSrK7CZQapWYbpBnEpcAuUGt3P7RO2J65qd9oL/4VsGOZLmWzxf/AhbMEb/3sM+9cT9SpFuyzhBSGcpl93GYNXNmHN3M2upVOprk1ljRcnQgp0RRyPQe5fEJWceXTzOFlHP1VTfqvRgn1WfT0XJwGYdJNhuBSghu5Ie6L98m2X1+dYsM5P1I0q7VFihTrBlAwMWYz7K/hd4vZqINidwp5NoPA9jTE4Qns9lSBvimksSggzSG/7SHo2AO+YpbdpJKKlj4UspA2IqeEhWP1uwv047Tumb98AQLv6fI4iVetiC9YR+kgNf3Ca6kKQfxIdUU0wiuhUG3NbHLgamUmBavzzZzt7Du9X9P83bRvN5x6vJgyV5mgho8HwvINq8sshh8F6pSOmRDDGcmW/fd/rKThGhlcML14heszrkmFQuzi5CbIHkFVYRNlvjEHpoWbmZqBNcko6EyFHFMwWGXfTSQ5OS7UVDPX+nmkFsBNbBmlAcClZl/y/c8HTbUWWnY5luvjwrq0TUYb3ldoxXICpriA3Izni9ZEa/xHoT+Ei1O0vcsfarGHD7oLP6bDerCRF6eqjh7giFT8Ek01WHAys3k//XyoxT3RsOPBDHQ/H01+0ZN/sZGRRnK55aGp4J38afzEZCanr8+yanjLhNebYHui4CENNLdQpL0wdjr9c7JZm/T7kTm9DPLJmpon76XaNyDRXojZEkHrxrxdMM+gEzX9207C42+H1JdtYMrdJZI3d43/RM3lLWzz34vhQ296XPYTkfDGwJNLLlnTBK+lZ9PQPBnKRogFB6R2jzYw9dA14paiiFXBOc2hDRlnhA52EmtmIEMA1X+iwZ0Yan6i1YcHTOjNwZVb/zb
 TzrXk7Nf
 7ffuB1bvUYNoDJUzazGaguFDzSVJMC+XamcrIzKdBTCpOfLo6but1/prGLZCnIr0Wlg73dBw3kwmw/dUnszrIijGUPPFXG18Fj5OuVLz9IbPaVRFFPK9DMGbmi/x7eYHiF8fXcU6wWhXm5BU4U/U1x51ZddU8wC9gfua40SwkhUSEyVI0o9tb6TE2YlaiXS0s3SyfLUsIXTZ/2+LOgJuETfwyxzCYLQONYjE/4Xgr3eMPn2dQZIFZH4NAt2fzXm4QT25YVaAK58oW+Q2GqUU767xRgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 12:48:38AM +0900, Sang-Heon Jeon wrote:
> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
> 
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

It's queued now and will appear in the memblock tree after the merge
window.


-- 
Sincerely yours,
Mike.

