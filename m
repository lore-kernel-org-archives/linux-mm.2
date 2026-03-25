Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD67FFEA807
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 04:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7F3A6B0005; Wed, 25 Mar 2026 00:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30066B0089; Wed, 25 Mar 2026 00:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45E96B008A; Wed, 25 Mar 2026 00:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B85E16B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:27:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D174E0A3A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:27:01 +0000 (UTC)
X-FDA: 84583300242.05.E47394A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id AFE8740007
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:26:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IPnaDLGJ;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774412819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iJBOQguA8LMZKv10Bibv7DO61iuQkcG+E6PA//H8vYE=;
	b=rp5HQp7Q+tzYM69lsXnHIlw267IGRR6+QlWcNXdd9Ashs8au1FzUgGlgcHjX4fT1wh9DA/
	LjM4V/0PpSfKoQgf6+54y2ZTMMoTbfVZmW6uQkas+YayHCUs7UaiNmEc03to/2Md4jSR6a
	8N0BrJldG1CbhXp8jIKHVH/Pk11PTtg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IPnaDLGJ;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774412819; a=rsa-sha256;
	cv=none;
	b=e8J+aEgOtRBuUmNyjhTB3ZDHXj+pXNdPRPrutN57RvTR3nj6x1S4LUlkANsGgfsJyQ3bqO
	+TdXjb1zlfnbuDjdgL5RahaQUedVGVdJG/9hD/mMWnz9aiAwdJkv1d/9mCDAHrQzeu1Egx
	P1mC1agzscraeoRrvGKA3Torrbuyz6Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A83160127;
	Wed, 25 Mar 2026 04:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9272CC2BC9E;
	Wed, 25 Mar 2026 04:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774412818;
	bh=IPwqk6SASt6Y5QcfetNCYxTed8oJqjxL9aGx5lCMFkc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IPnaDLGJBoRuY/7WP63Me3fhrJm3K3ZTRwJrVzU2h8UR6rOtzHi5Ey9gkH6edlseW
	 tcv0W1ZF3AWpwnB5Wmd/1nMbXiHHi4U07znOzHdJ0DqV/iX5Y0AJQB+XyOqVxhXn2Q
	 LzH4zNAu9aiWqC2A4WbQBX4o0x7dnK9vu9NDe7QY=
Date: Tue, 24 Mar 2026 21:26:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Philip Li <philip.li@intel.com>
Cc: kernel test robot <lkp@intel.com>, Chengkaitao <chengkaitao@kylinos.cn>,
 <oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>,
 "Linux Memory Management List" <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-stable 72/140] arch/sparc/mm/init_64.c:2582:16:
 error: implicit declaration of function 'vmemmap_pgd_populate'; did you
 mean 'vmemmap_populate'?
Message-Id: <20260324212658.a267bb861af1dcbf119a1901@linux-foundation.org>
In-Reply-To: <acNdJ/q5tNB0nNjp@rli9-mobl>
References: <202603251147.CtgepAeH-lkp@intel.com>
	<20260324202754.6f29c4f6530ec7ea9d1f753d@linux-foundation.org>
	<acNdJ/q5tNB0nNjp@rli9-mobl>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFE8740007
X-Stat-Signature: jjezbh7oe549gh98rrddo7unjd1ah8aa
X-Rspam-User: 
X-HE-Tag: 1774412819-940428
X-HE-Meta: U2FsdGVkX1/MWEqCT8vEG0AgqEQxZPtAimlKLRKOKEpMJsXlt8ND9EUe+6xO1s+J10775QISEoOi9YSv0CBtwFo86PEj2FAUSWo8uzO40dbMgHkwIJWfJ7llA7N87n7hisZsMYi3iRu+1QaxUMQgo7JQTNtRvrQauK3ZB3D40yo2aHOxHQXHhVw+Pk0DR3lxfgxqTiax+PpAhIrAiNvQnRuJgCf+ND0WrndRrzLI2R9s8AneeEus9Gh7+0+uNShbcU39n4Yo0YeN7sc/Xd8/akqqtQujdGsCJgQomTqPfAY4fbKOmdeLJKWoaB9GaryoPdM2GTyb5bQN0al5/M0EM8NnX0G2nwhl2gIggAhz+VuRjb2ATIO4aAgYa36xkelQsOxd32T/cxW5BIOLaNUhDXJU99rvIkerdFRStq6Z+ph/HBZmdWs6kBG+moVQF8Oh/xnY73Cv9o7irUDbgwPTDDMpMldKb/9ARYaYsP6bNpkLsQO4j0I89ZjQDevpqCSMw7gN8Yg0pjlpBmIWGv80BOiKBnQclucA1ErBD9REKQdIIFwBi/ytVUxqyTWXbVMjxzei4zN5IXKEa5ekUfnobb4v0Tgrb9SK8l5pYNBZizVruo78EDyEzIM9z+ozD5SHMDbIFAZ1VWEiO+H6/04WAPBMenEm2n0pVRaOBLS5Ll60rSl9TryeiES/gD2WZIsQD1PUXazlMfpN/eS10zKxPXc72G3+Q8Q33aFxLXAIWGBjl9txranhzfCcMB8+F5Z+/zinkl87Rz5vZd5BHNuzqi9RLU1BBmggo/sHXfy/YesAbDo6FnBlXHEIeXQ6F+NMeJjkPdI0r+dQAolYAKIZMg5xS8xgnIAqvBbP5gZVNW6OSbE5xR6yMzN+8eYwsAVpsKrFXZsxPC78qsrz1XbmVM8i2kXfgQzQRyHRnQ4UUmYlLQvtXUclQBdu6GckquwrrabJwzmhxVbP11a2xjs
 nt/6Cexs
 7JYagyJWaUhVPihHQjzto6h2ewwnUrTb3LEID0sCTNhKvI1VBgD/6TfDOo02KC/omYzYpTKGndm3csHTjq23E6WNdKFFjqMRoTKYJpewHL41gWFeM9ICwR7tI32ZZbrfXqu3bBrtnfSax5/Ygel20crUo1x0EHQKNa3Tqkjxbz9ur8ZtACxQy4l4KQel4f18tIjdH6h7bHnVtDr0TCpbeKWZu3GjMCA7ufj1GxbVqbavhYmdY6aaCZtCz0o3WxEP2R2ZvzXbi2vIEYveT6Hz7aWPPY0Vf1BJBZw7S9U/0bQcdtMpY7O3mRu525R/TIBL1QjtkfF4zNVZ4JP4xqTBSeLDLpg/iteHwcORVcAGxdDDPKjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 11:57:27 +0800 Philip Li <philip.li@intel.com> wrote:

> > The coincidence is too great.  I assume Kernel Test Robot is somehow
> > treating the mm-stable differently from other branches?  Can we please
> > not do that?
> 
> Sorry for this "coincidence", the bot does treat all branches equally and
> there's no special handling of mm-stable. One possibility is the randconfig
> is just generated on 20260325 "sparc-randconfig-001-20260325", which is able
> to expose this issue for sparc arch.

huh, OK, thanks.  I was able to reproduce it with sparc64 defconfig.



