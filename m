Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2031125865
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:22:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A326B0005; Wed, 11 Mar 2026 14:22:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55BF16B0089; Wed, 11 Mar 2026 14:22:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477DA6B008A; Wed, 11 Mar 2026 14:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 387566B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:22:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B2F7C1903
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:22:02 +0000 (UTC)
X-FDA: 84534601284.01.D50C277
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 40E4B140012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:22:00 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ZTLDV5b;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773253320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K51mV8xHVRqL4ATdsOz9OcUdmjp6hVXN9X/Q1yzV1Ic=;
	b=A0xmBGE5aezdhzO14NFHof1GH4A7388CRWV92CcSSO17sXQPjQel588YNkOY8eJ7WtGGV4
	sCXIT65dwvGHNlKVulIKFHCaUfGg97822fiTkNF84pLomfs6GyLvZjaTamaamce4UFdGWa
	209Ym82Poy4vpwMAYQPmrNmRFN+exCk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773253320; a=rsa-sha256;
	cv=none;
	b=nON6MXGFJ1CwTS+9o+WpoCDS3byOtYPslEwp8kCY8G74hMgOGIKtzt0iyaAOuMKd0AtJ8Y
	CEXlvYaaiN/pY1W6wpfM835togcb/3bfNqwQ4Gkq9oJ1lZ1e/w2irCsS2RkptVr1XVi98L
	DWudCUqAh8GWRgmGz7Ef+B3EbTdWZRY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1ZTLDV5b;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 435C343EAD;
	Wed, 11 Mar 2026 18:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE1AC19421;
	Wed, 11 Mar 2026 18:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773253319;
	bh=uJL5nolgHMfKqwJE4prr8rQoMXwMjSQPaEOX8Cr/DgA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=1ZTLDV5bI+S0u+Qpa+2tMbyDnzC0XBuUpKTFw/hKMpA7av/Lc9SSd7LdpKpiYGvF8
	 P+YBWf/9Vfg7ajQCvBnae2oug3n/heE8ROBI7oPKqkMXzNAzNRc7J01Smyk1m5vShd
	 0nb3CRfu5aRYatJIefpkXMRzLnhmpvt1/HjZ5L7Q=
Date: Wed, 11 Mar 2026 11:21:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Mikulas Patocka
 <mpatocka@redhat.com>, linux-mm@kvack.org, Vishal Moola
 <vishal.moola@gmail.com>, Baoquan He <bhe@redhat.com>, LKML
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
Message-Id: <20260311112158.7e423b5d82b3c03ac327e572@linux-foundation.org>
In-Reply-To: <abFj8gwNrpv0qQsJ@tiehlicka>
References: <20260302114740.2668450-1-urezki@gmail.com>
	<20260302114740.2668450-2-urezki@gmail.com>
	<a8010888-ce49-9232-f132-338de8e18cee@redhat.com>
	<aaXcLRdhq0IyoNIG@tiehlicka>
	<20260310155914.9c03a9f4cc2f433fc741e222@linux-foundation.org>
	<abEq9eX3-7yeNHVB@pc636>
	<abFj8gwNrpv0qQsJ@tiehlicka>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 87p59i377aqzfa1w4nauni6471c5y5py
X-Rspam-User: 
X-Rspamd-Queue-Id: 40E4B140012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773253320-29587
X-HE-Meta: U2FsdGVkX1/DoSIjUko/v0vIlvohQRDlNCGDoUG1nzJA6xINUd7pP0VbwQ1j0v1/6rxaagmARLvCXW7Ec7BWNpFyEt8DE0e/rNw/rQforDfnjR9y/U2fppgZDLKjqcjd2qoQOttsVM/XjlNbHY6C/XTxW1NEOK8f/YFFkvN6Nanhwd2xOpmOWTi4kpTZKxwCZgaFgexNQQx854Hd/7GshvoCHjgssfHMdR9ZnNkpkreA9em+U+KWhJY23x1blJ754Qi1L238xCNaTN75dGoW1laiKuDqeGeGwT2ApFS+qay3/ddkL+DY/ER8qOqXtCYbfAslIz5XIMfdb9vyDaD6cmlQZi6Q0HzGIpx6yElMbu1bB5ykjGDzuFWOkuEu7dEBkJpBFlufRnlGaVj8wUaaZfGBVPaTayqEq3anaj9/ItxVV82/TGe5Jw56ov8iJPve7v9j6vja6Tid7OgtEAn9SUXz8U7s2VjXalW4k3uUBr9FcBZHKc5Hkh7DosUbOMDOJO0+Z56zXTn0NqWxIDF59dkgxL6TrJnFNNz57IUnkJyfbQNd0Gt26x2t9GWUv6zI+Q/A9bV6MeZQH4ckDS16EJKIRC2/xXXUGFBv7LIMXTqbuXhtFC4Us3CiGxD9mqeC1uh8zoTMw3F9+SK0NKcmJG7NoRDO9iU6S+7q9poFDsqOFrHO9hH6COu/I6q4DnAR+5C3KBkdFTpS2PJ7b5P8W1+PefSe7iAdM9Um6/dCVxoTONmxeTOp4zhA5RCMHX8JZoL1Rmjcp/24NKhCVJy/IZORfyDDmEpg5idgj0y+itLv+6zcr3mpbmgMOZIlcVvWc1rKCih6WHU3fhdIDFkDKpIAvBoB8kEDiq0Vu0KrhbZ8aPmnilGgiNooFT6fPufFFEXgt8wewihJ9I4XtKPcLULGXRNPLE/5mmXf9yB7Yy6Pzn7Fr2VR6rD9av2CE0JnHDeEfT+fpmWq3GOWRAi
 kuGVyB2f
 dJnoUPu6870UavIxTwQpWUcAbdCOcLZLloaj0tAVyWex2jzsSaPMwOHkrKFB9kcxyVFM9W2Uwx9nux0If5QAYRT3ZcmWQIpSKSjm2GLOZYoffdZwy1zWz9idRiHYVgR2rvcfCGQ1L2NHaFW8LDzAefNQxvKT+xIwmlrhdKn1IpLjM+Q/tEoB2VeeAaZHL9Wi87Waab89oQaIv4/Ao7S71JcQR3ktz9VxFOWJoksT/OdGqcaM4mEifCpTHV/HwecqUrNGND3QFU5odUoLEAssCnGSpXSast90q0nM7oefSI1y6ykFml1uhsimPCo5rqaDRCX/gtl+K0kZ3zRhpNuqfwS/AqciaaxQTU9cY91JWBALi8SDJeMb/Iju1jo4NJROjHIWaN27QMdI3ctPOYD+yStMeJUAnXfoolYoMTudmJWpV/I2D8WcNA3JCj5WI2IaHM9i+W3L0jydaxYvN2gXSYfFgOpB7UxU8J5Nt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026 13:45:38 +0100 Michal Hocko <mhocko@suse.com> wrote:

> > IMO, we should drop the patch as it is not complete and replace it by the
> 
> Yes, that patch is not really correct as it allows to trigger OOM killer
> during pte allocation.
>  
> > [PATCH] vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY
> > 
> > https://lore.kernel.org/lkml/20260302114740.2668450-2-urezki@gmail.com/
> 
> ack

OK, 

"mm/vmalloc: fix incorrect size reporting on allocation failure" and
"vmalloc: support __GFP_RETRY_MAYFAIL and __GFP_NORETRY"

have been in mm-new and mm-unstable for a week now.

