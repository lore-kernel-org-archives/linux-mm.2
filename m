Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E13CBC5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 14:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC8916B008C; Sun, 23 Aug 2026 10:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79DA6B0092; Sun, 23 Aug 2026 10:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1AD86B0095; Sun, 23 Aug 2026 10:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5636B008C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 10:30:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1D84FA32AB
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:30:22 +0000 (UTC)
X-FDA: 85132769484.24.50DCBEF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 87C672000C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:30:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaVTKTig;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787495420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TplePkvwxXwaIo8VD5LQPXlaM4B5k2qGrj3Fbwy9i/Y=;
	b=tVB4jL6428/JveRTxVwfAgWIe+Y9zPRb2Bmevp+vOt+rBOWi+uV74n0IjmkXBAuuV6OAN1
	YO3pF1dbzao0Ohh+G8NaeX6T5fpZDPT8RLoJJZeIsn377TrCPF6dCsEYD0fJan5PwyX9lO
	tTvz9H4tQIPekiA9y+yEsaQH1wjDutY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787495420;
	b=tCxOwftVNzOoDHEPtAPT41Nv/hGW/l8YVdEfodxExhk4HWw70vFyfG/aqcJ14n0/h4NeDo
	VRGNtARyuOE0S0JaSPDSqeEibpvDV3lFnEq3f1wviwsCSlUGG/qp8ZT7RTIYwUKCAe0lfg
	uarzwow2+08QGqrsnVtiOZVNit8QN1I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iaVTKTig;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D46960055;
	Sun, 23 Aug 2026 14:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201FB1F000E9;
	Sun, 23 Aug 2026 14:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787495418;
	bh=TplePkvwxXwaIo8VD5LQPXlaM4B5k2qGrj3Fbwy9i/Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iaVTKTigpTYRL3cvVH30nbiAFwLl6f2MDf1sQBKJMyNgwfanbvYVmxCUxSPMqZeWE
	 afAkfdTjNpfhH7E+keuUSbR4jKFb3TB6jQDS7//a1yUkrnm3jzT0PMGO7Pe/rJXqIW
	 VP6GgPfJOaUI0kUz6Fxf2TpBC4tPA68Zqa3f9plxf6t6zrWtWvjovkUIwmtIRgmdsg
	 RsMcCZCR+H6ClumRCi7QK1IVC47kUlqwDLEmvaDyXBhriu8alaVA6eGj7Z5Xl98n66
	 Nl/N4lTVC7Hhr5P9gcTFSMdnNtphrIyfWEQ6b6sGPvoRSKsFdwbnfjjsIzfsY3VNB5
	 koggEg3H/e9YA==
Date: Sun, 23 Aug 2026 17:30:12 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Hongfu Li <hongfu.li@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Hongfu Li <lihongfu@kylinos.cn>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memblock: simplify reserve_mem_init error handling
Message-ID: <aosD9E8ntZF1RLxz@kernel.org>
References: <20260821033230.55210-1-hongfu.li@linux.dev>
 <20260822032327.3548986-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260822032327.3548986-1-ekffu200098@gmail.com>
X-Rspam-User: 
X-Stat-Signature: dsx6wx5p163x651x56ow6z63em7gwwdi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87C672000C
X-HE-Tag: 1787495420-388951
X-HE-Meta: U2FsdGVkX18+c05WUbMktnTNgUzcLql1lQMqwa3q7pJPfzg59l4rk5fsgafAZObUy1fMS/mvbNYVckN3oS7g6+zdEaGbWwtGErepYPHZ4sKrNKpCQGnRllNKlI6dz5ufiHh8joGurPkU+mJamtHn1CY6ObQM6ZMp3c/ixlwlVfOnePFnt2K+tzArI192sr96hq4jfRYehHoNmOoDRi5qLkIGiQPelRv562o7qSxfl/QPd/ZIIWPxwz2y4tBdUW5GbD085HfwcL1Y+oZggaS2H/TX4zWS9ajiPKaAOvQKAbATKMylm7K/NUrE4W8/Pu4HmH/TrpThzs/p6yx9r7wTKiDYaA+dCzVblCFrkk2/LhUuFhNDYl71ATxAL6wAdZeQvVBzBvle8P3wBrwMHj3vtzH/S6rQ07qOZWvL0HYgmp3OmUJ6GSz/Pr4GMGl54BKAvd3c/i9wfnp1STIinlbP5bc4low+xIzEjQMTkoDqgYjD31gMyb1oukkKPd29a6FX5SKqOfz/uzh9wMnLrUE/Xqr9nXcwC/0ix6h6NHg7uRhDIXrJM59qeRj+5wDOX4j6Ry3odlOimuvNcHcThV4yY9KlWH4vjFOVBUDI94JmnpjyHcU9XBGie3ORMOVfUjrgVH+JWNLWnoCjwZQ8adMF5w8//0DSuFsvXlNWvn3+/MzISed4cUH5sLhmqrpz3W2BurimNhh6w9vx6Axk8qL0wXA3XHZffg/X3537faZwV7hNeCQymwM72oVlieaDjYiGFBQ3C+jkK6KIbdhKQJ3kAWmO77VtIg1Ltbkwy5jocgFE7+SYeIiAvUxVKIjRdLvir1SX5aTxO9w1qVmfT2Vxgbad3EJtA1xxbEdIDZyTVhWWGy3idQEgeq7PB3N8eruA0jZ3Vm/hccnbnH62qTkJhBvkJOf8O7Kfx+Z1sGPuI6CGcU5wqX9k65aDFmC6rYAhcrDBLGTZmtxlulrgYCW
 N7xBK6MV
 ZKN31GEtrXjD1SsZYHObmujy1b6Z9x/vXMYhIBMJ97VKrNDcm8rEcCNkFnLCQoDn25k1kTpyrF1JSfO1NvZ2+g03KVe9cAmHBhOWbCiYcMUUce7gjyUjxKkOsJMkdPMPtL1cn+nj8b0wM97xhTpbiV//rriWt4Ye7S79pB6gfWQLIYwnTZnw++wjEJ2lcOsEOMbGbf7Y4+JaaXqVpuvBjAJkSyJ2OudCbY5u2wK9D3Tb2RnbFSF0b8GzShTpCYHfdEdIkFo7HDdbPIJUspJdfYBfWXFGTngYWTpXWFU9J1ro67RWViT7PU/YH24gVMHMHinvOLYE5N1UeGN3GYxp+3Gc52izeAAONwpbg5NatdON+4K63w+PbTjP/HQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 22, 2026 at 12:23:23PM +0900, Sang-Heon Jeon wrote:
> On Fri, Aug 21, 2026 at 11:32:30AM +0800, Hongfu Li wrote:
> > Return prepare_kho_fdt() directly instead of assigning to a local and
> > returning it on both success and failure paths.
> 
> Thanks for the patch, but the same change was already posted [1].
> As mentioned in the cover letter, I can send it as a separate patch
> if needed.

Please send it as as separate patch, as Mark requested.

Hongfu, I'm planning take that one because he was the first.
 
> [1] https://lore.kernel.org/all/20260723184538.3888637-37-ekffu200098@gmail.com/
> 
> Best Regards,
> Sang-Heon Jeon

-- 
Sincerely yours,
Mike.

