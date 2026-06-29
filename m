Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4799C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 10:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64B86B0005; Mon, 29 Jun 2026 06:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B15586B0088; Mon, 29 Jun 2026 06:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05DA6B008A; Mon, 29 Jun 2026 06:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78C366B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:18:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EE4D31C3753
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:18:51 +0000 (UTC)
X-FDA: 84932551662.17.42A451E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 62E9420002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:18:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axQ5Zc0J;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782728330;
	b=v/oMKXxi8rIMjGVyTgAsIHogtHJxXTGdyriWtbhpvoA5bjhgAM9TDqLU2oCAvlTOW1Pc47
	NYqnvLscid8prx88M3qy7dmBYVEsnFUzg1L1zkoc54XkqRpGp7ooPP9uQoCESuHEbLcvj8
	jGIU/cl1GE1dx85jzIrCm+/rkGQjV0k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782728330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivsTlKL8t2sa3Xd4aeQHWdh8u0g345VIl9yyv7cZMv0=;
	b=T6T2TAeaTSzblyvi0FHe45SbaueWk1yYrIYw/Wrhu2fKU9wXdVDcC8kurPZ0hePRKg75Yc
	orIVIDtrnGRv0jmErcmXeqDLW5uLIys6jJHZdroOxUKlav8pDp9hY5sCKWM2ZLscM02Gns
	NBButgUgQODQYo8RI0E1tlBCrW1Y+8A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=axQ5Zc0J;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF50160008;
	Mon, 29 Jun 2026 10:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3093C1F000E9;
	Mon, 29 Jun 2026 10:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782728329;
	bh=ivsTlKL8t2sa3Xd4aeQHWdh8u0g345VIl9yyv7cZMv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=axQ5Zc0J9vYi9k/jOBkv8PCcCdS9IFiGiXU3IsJ0cv0tuag4z/frgMQaAb+j2nu1J
	 +21jDEyS2m4lNPjp2maI6Uy4dtO0aGErnNxVh3RVDMjz/7Zhy3ucHuJCyofOnj+gtx
	 2KPRfLCh81jCuaNMIKOGhh9jOIowgJvC/Ylx7noWIW+1rgmgO+Rzfneq6WasAcaQmg
	 phd38sWw6rHDPb10gpYjVSF5dFLtozEuVmQ/5oRZDhvNMn8Jsp0GRCehNiiF1ztHqi
	 MLjPTbIXbxKeJKxYcG+JqAnlRjpL4TQ7/r3W5pV7E7ohZ2q6wos640EaAW5eQ4+gvN
	 ld3EeE7EnPOeQ==
Date: Mon, 29 Jun 2026 11:18:41 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Imran Khan <imran.f.khan@oracle.com>, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo
 reads
Message-ID: <akJGeGx3rkiV5cE-@lucifer>
References: <20260604134245.1580287-1-imran.f.khan@oracle.com>
 <ajuED_MZRzDuE3tJ@lucifer>
 <20260628130853.7e20a6bba55ae1c6e90ec922@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260628130853.7e20a6bba55ae1c6e90ec922@linux-foundation.org>
X-Stat-Signature: 6pug7bbn7czsusm5bg371j15t3ctwu6x
X-Rspamd-Queue-Id: 62E9420002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782728330-217463
X-HE-Meta: U2FsdGVkX1/F5D1L6WSqBYQBEa6jFZ/cDTocrEWqHp4+abebpXQDas9KvE/Er0E/mZNh77JBmntRdXQQRMGRk7l6hDEFzc2grEGCNgPF5gVKGYdXu4/YtbvbngjnJJly26NADWq4BhN3wgKuK/JIUffYsU8UBlwm7UBq9lmqyq3Us2Y7nUvG8BXK0RZbnBXXSYCOroW3psiM7Sc0ULv9iK+WTp2I8UMVq/+xI9yNixk4lECTA5EeN7ecPknzTHE1t6wnbZo+ibgkE7pvSv2bIZnVjnB1liLjuXiF4vnSNNwI30ajGkOiCG8uyQy+sABdZQBtaEN/9M6J2wGAV0kGSjwVz8w5L+3BalaGU+y2ytBDJu+emOet7lg/xVDigG59Q81d7wk9SRut8nN1QLL5N35eJMuFkvdEtnSxmExeM/ZZ0xO5stwfskwkUIkZvVTFn3Rc9zUsK0hGmbSkEhpda2zKpZdCeG7gIpmMtzolEDbKatmDd9TUAh8mJViGQmBB6LCBfG/awJA5qsKtnjb9F7niVShy0pwCiMKtiSOIPe7w00QgJS9jlMxzzHVZyjjz0h9y/tfCc3kWpnvHNSH44CIl9QkXKvf6qZabE+SBXsxUnwe/ZHhq2wS0wJLaTmbh6DFyEzgrKCZMO8ElnZewC+rBGIgjmb7QmkARrX5nQoVpx7TP7zyfkoXRu6lz7Rn/XWXe8BpmZ29bwf595Ty7NWG8OlFeK1CsRA783SpIpB93Xv/6qgQJa8kdwamUAARREqafNh/Vh6QuuQv2Vadhm32cd+9HojCfPztPbl1tQaVZeZUwLNTI17EjO02aAzF77EtPgYaEf640RyiourdjwltICwjkjP9cetZWW/3MfSgQLsObt6Ch5JWy18ESSbjN1LEYyc8moue6FO68WcH4oWxpf54Yw6zsxg+1HgcARWPBEI7jX/k4+kLeOEyAtL5PSA0D5Z8PF/x/+LFW68e
 8oz5HdOA
 XPgEbZqUsMdAf/u7KfUb6/jmVZ8eBVD3bg4XlUXnbwBB5EEbIyM9gxImjc/nFc+W91bVaBE0tZjjzTsgRjktCtW7RFrz1IDTYxE/uESwmnRDhLhxlIcM93gZ+judqOElE+KYcl6T1JAC+PFn6+B4jqQuuOGhVQOMFqu1KSiCdjQVFHgzyp5cKOWN/iqBKn4WRdZiUGJbHcEX4eCifvWghgfYdPolOxRaEhmrmanXeTu/VcVJ610LkLH+KCb0+pfR4VIm8EfUq6++qg38O2C84/EgkUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 01:08:53PM -0700, Andrew Morton wrote:
> On Wed, 24 Jun 2026 08:16:50 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> > I think this one got missed last cycle? I don't see it in any mm- tree, and has
> > a bunch of tags.
>
> It arrived during -rc6 and isn't a bugfix so I put it in the "next
> -rc1" pile.
>
> > I guess Imran will need to resend it at -rc1?
>
> Got it now.  Thanks, all.

Ack thanks! :)

Cheers, Lorenzo

