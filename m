Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BB3F43832
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 533576B0088; Wed, 15 Apr 2026 11:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A636B0089; Wed, 15 Apr 2026 11:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448606B008C; Wed, 15 Apr 2026 11:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31A426B0088
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:26:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD357160519
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:26:44 +0000 (UTC)
X-FDA: 84661167528.16.A227BD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3D1981A0011
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:26:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+AeWokG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776266803; a=rsa-sha256;
	cv=none;
	b=hTZt/BZH6r2Y0RYRbxVSJDSTeCs1FU+jCLLKshA3/0JdBfgBRwosXIf840zMfilQ1Z6CkO
	cwFEVmMczYNRn8CRirVgZ3iYWJudAmb4xldHI3I4fC36KGWRjcfXrEUXr/+B1FhCL5wK6k
	3KiqwfWLqdfRt14QZ3hLdV3G4AjqkuE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L+AeWokG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776266803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uq9rr5frHUqvO/4+j5h17OR/YnWhAoug4n/Gn87TK0U=;
	b=3mlL9QOZgMa/Sfwj1b3YhB7PGk2hNAiDr1KTJpacl0XtbotAc+tp8idmsknPyRu+u6a8tl
	T19zjUYZ+ldvVGF3OuM5HceLhcSNtxu60/szN20rO216WF6SFGMJ6Lj1/Kn4iXFAKp2Gf1
	VWh6CaYQMGvHmNluK5IXseRjYkrZvPU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96B9260125;
	Wed, 15 Apr 2026 15:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE1FC2BCB0;
	Wed, 15 Apr 2026 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776266802;
	bh=xGKBplUfNTwIfUx1ToWl6ViqiUPi9OO2hAKBdFxJN8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L+AeWokGRrLG6FzvYhX1dd2PA2f/c986Hsq8WdFarRpaZq0uIz7pqJBAJdp4piuCF
	 XxK/IxC7RpG4QcYQMJiy3/yRVz5s1BJHrYr5oz3oYBe/WL+T0mz5/b9iWS+9RHTUXq
	 JTrnqp8zBURLH1gayPrKaoob2j6eDa50eJLfZW/bbAfx647yS9jBLMT6g4rb6jiHz9
	 +wK/qlrbbdwRFYeCmWdikLjRq4W4dD3ndh1L3nH+lT6EMXO5lZ7nZCcknj6oNFRxpV
	 yWR/qu/D2RJcXB1Up1CZw5HSNHbgR3zuWVuT8W7aazSHyetgwmk+nFTJr1nTfhVFOQ
	 SApD8hPIfaX3g==
Date: Wed, 15 Apr 2026 18:26:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dmatlack@google.com,
	pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH v4 04/11] liveupdate: Protect FLB lists with
 luo_register_rwlock
Message-ID: <ad-uLchf_LhmvUa_@kernel.org>
References: <20260413185127.128180-1-pasha.tatashin@soleen.com>
 <20260413185127.128180-5-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413185127.128180-5-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D1981A0011
X-Stat-Signature: mi7h4x5ta9zem4gc83ww7u4cjuer5fuq
X-HE-Tag: 1776266803-198305
X-HE-Meta: U2FsdGVkX1/mBbY8hGjyt2XSZ0M0I+v5F+fLTofddoi1hN1LCZ6DkT6ZEIvwt6RaD6K7FamCyDo0iMolht8N1aBdx1TZdzQlf6241JBW2Vv/QOXNzQ6mwklXFeGv0z/s7GiJS+aqMammVZhPCvRch/7GJqWZoaM2pzxC1CLvmM98yO9cp2Ex29WPX434Ps9cDZ809gs8za/lnTuAIqW23v1Nti5ZAC0h+Xc7lb/xCHeRAfTeDysSUwx9njF+1SbulhDfASat+B6c0hNHIgx3kTW3fR4m21vWWSzEti6FUbYHOptLUcA/hgRDsV68RVukyS+0kOb4WrFfurnxgXwkw2IGUDaQguR/iFBan/d0jDoYYtndIx3N/BCXF6gyHGiYbcV2sN4oXixgJZaXLgb6evXKRqoq8UewhwyvSJUtGrardJgLrwV4jsIE90gitYutSImKTMAXyuiQvfZ3TD/4Ql3NkeXTeSnBvi/Mds2scZFVexYZqbFJjlh4bV4VKy7HfKov/GwLHRdfneMRVZ6GrvPwhgqZ9tmXx2fB9peoxZpZiG/LC1RPh67pNxBLVzhhygAbaFG6dV18sB1amaq912SfOy/xpkKq65p+Kew7EhkjeqbKJXEJm94vylutRm4sXQigW3OYEydk+k6ZQ5ZZmsoYcyb8WY9NiUUuyIESXZhVltmwQ8U5cAWr9txQFGgLTiJpyYFLOsblHQMNzD4S8F6+ARGQtE60xCEbyQfQbaM1NLPhhAl3oG5p5D96DwDP+HWuh/XQgWWXiRiZnxIWNY8quAeVURVMBF3vPCiue7By2YgKyT/wUhbHZTtAEbCvgxquiMlKHL8bgd/zF0QUmpcibyeqN+c2DvFyE13Ak0HhjAry6otzGaQEQE9t429fS/GM+w2jiENXUMrjRT3w3+FGmEsKNUftKdS+7/INgAjiEnngBz5oRJWIEju4ajOCSK3Et2R4as21avXgTLe
 9Fu24OmK
 yoYSLhqfQeGMq7AG3EO2r8xuMQUbXuO74SmiRaGLQ9pD+gP3UrzcMdF7EhG9+KYUEfVxVowkzFBlAPVFi8nekjIvx3rN7ZkYdUjr+eTaIlsQUKWmGnY1TN3C9FeOuLNNwHIHPltieijyTB5K7gd3PnOjxZB+SrWzJiqdqkqaAJxZUCm0UFd0FbwdVZE0ILROuvYlQWgRPbIY8ILaWMx+se7SNeDoqOkTtiTdwDZZhrncc9MjtHuXjCuPBB2nLz1VdeLbJEbBC8a8DSvo7JOQ2Nuc/zQnyZP6gb0n+M+uAc81KWURurAlSY9q74OqxJQ5rJVBbAceKNkH2BcPgxytwo477JN+ySqwKkyu8SS+YpZabyWXeJo9PSxNTd8XlocIizAYy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 06:51:20PM +0000, Pasha Tatashin wrote:
> Because liveupdate FLB objects will soon drop their persistent module
> references when registered, list traversals must be protected against
> concurrent module unloading.
> 
> To provide this protection, utilize the global luo_register_rwlock.
> It protects the global registry of FLBs and the handler's specific
> list of FLB dependencies.
> 
> Read locks are used during concurrent list traversals (e.g., during
> preservation and serialization). Write locks are taken during registration
> and unregistration.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/liveupdate.h  |  1 +
>  kernel/liveupdate/luo_flb.c | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)

-- 
Sincerely yours,
Mike.

