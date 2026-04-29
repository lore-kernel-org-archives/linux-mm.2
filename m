Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81FDAFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32816B008A; Wed, 29 Apr 2026 02:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09F36B008C; Wed, 29 Apr 2026 02:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47146B0092; Wed, 29 Apr 2026 02:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C38F96B008A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:42:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 309DE1206F1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:42:06 +0000 (UTC)
X-FDA: 84710648652.19.B38CA12
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A42F118000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:42:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HhvS+AEi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777444924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5anGTXk/PsMhlOHri4Yu5fJKBgW4sb3Vyl+BDkX03wc=;
	b=Sn+ufI/leaa2tZYld7pNdCnn8Gm0xAGdGbIBgCVV8GxBl6Y02J3c0S+McS3OwS5r6pMy5q
	Obh8DqEa/OGdAy00/F0Lx/aZMpWc4/Y2wX3j4+UDhcQm31eq5MyzO1ZUqumst4cfpg4Ip7
	t2HM7HQxYrVBfnhFlLp6EyMwuJGEfrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777444924; a=rsa-sha256;
	cv=none;
	b=OXyjWwGSEyj5Lxddun/5dqnp/N78Hv/JpeyE3hJP2z3Y5hNRnr1RezOJgq/VTsZlnmgReU
	1SrD09J5yJtdYxcWfO9e8ayPzF9Kb4pK6x5H6QEboMMseEAnzWlpQTO7sRLiOvVylsCXkS
	MLCEn5EMLULHOFgGUGo+jrNopguy704=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HhvS+AEi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18E0661119;
	Wed, 29 Apr 2026 06:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD290C2BCB3;
	Wed, 29 Apr 2026 06:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777444923;
	bh=zWqxAlu/ucA1P6KiKmx97UoqK35wwC2a8fv/LnXOx3s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HhvS+AEidghosFxYFCxxdeYV2TD2EthsWHUQvkDvugahuv/aLZPyEa4k69YelJi0G
	 I/SpPotGYb+ehBYgUTx46f41fx74RXaOnHzFdU+4X0eoN0r3Mr+aKqFQuNdrdcF8wY
	 A5NuVmKiDBrwafYcy3JNTmA9W9gUmuGY9RzXnH73wGaOrbQbMc5rlCjxXM/a90eRje
	 +Xj3lD7I1TkhztOAjZhDhdffWkpa6SldLnbcXkgybnCK1+fT8xlAQG5NJp622XUyTt
	 /W4qb0W3bIJZOgs/AkYMlbki1qEA/7PRiIFP/DjXhJ2Ph96QHMRTEtjmf0zmd7QF4G
	 h0r1lNhnCgOUw==
Date: Wed, 29 Apr 2026 08:41:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alban Crequy <alban.crequy@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>, Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org, shuah@kernel.org,
	Usama Arif <usama.arif@linux.dev>,
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH v3 1/2] mm/process_vm_access: pidfd and nowait support
 for process_vm_readv/writev
Message-ID: <afGoMdq5vCKO8iaN@kernel.org>
References: <20260428122826.339550-1-alban.crequy@gmail.com>
 <20260428122826.339550-2-alban.crequy@gmail.com>
 <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: A42F118000D
X-Rspamd-Server: rspam04
X-Stat-Signature: ydcbo89mcth9kxpi45suaxbi4gry9sf5
X-HE-Tag: 1777444924-858588
X-HE-Meta: U2FsdGVkX1+XzPGeomZLdVLzYvn/FyuihAhPFOGVzUgzlBjXOBn5zwwR3BAG//3KAwQ2bc6ciMkdW9bIEnWjtTpm3oIsY+mF/GPt77f/AbhEMor16DdUaWgpVm3Z5/9Id3df939Pk3zjVCDdXRUpJ0vdXfxJHPzSti4any+TQ2eodx9IGNbwurgAo5cdflVtX589hMJ9+lvuDf6IhytCi2JiyjB+pqicFVd4jbb4XOE6wlCdcdJ6Ru8f5ExAN0z2nGos1aXrKvb02WoppVhHYmUUPoASAEWj20tWKWf2/KLfB6YNzXPaxnnLwIQGTRuDtOVM3tCaZvMErursxBLqFn1GgqColaFaxVYWwce/IZVqu0UK5rn3XYOfIoDjkqwWMupO1NZGsXSZxM4ZuZ/jGF/NyILOiIrcyNEHvXqf7JPebK0HMrjOPYdlRKXO3LenIV+SpJyMwoRwFZV+z/NmjNxow16BMFQfdxuw70ogIE9LQnCDlEmuB5XXx5LSjuBek9/WoKeoucMigha4+cie+hiBarOOuL/H1OnHS42Fo4TkMXTDM7pBeE8K/zumLZfigph3wwRagydXm8YNnqKADtN8fj+MgwQugAMQI31jG/L7qCNkiCi7Mx65Zjg+2XDSjryq4SyZBExihEuRt7itAlK2KQQUWBL9XwfSu1kP3rHZrSGYG/PWyvymGEgqEXIlnmIpuXwJqxYYGCfWii1cQeIwU78gp1LLFU9TbbjyfpVINOHZhFN1W15KwZLCtXvopP5bTWU5Sxo6sP/RoM6Wgze/sMvOMisCpOYDDukPTTzRTebYHn1V7injonoo1ZhOXQtEd2fMW6BqEAPIAXE2VKi/anptNi3OIKJ6CPGDdebbGNNo613OFfyOEmzh5U+zmRKJGItKnHQFU09dkQBXD6Qd/Cy4SO5bR4iAin49gYiWK1wABWU9Mzxe+PqP0E8Q2tYAdY9/l4OOvKoIcb6
 xQ+40X9I
 6iaL08CMsUJcWoqC5iGFnmJMZMVZUjgXqcCzqaDCIwj46XUOD9J1aHrd60nnphUsUe8YQGyGTAoXK1D4sabcqDY1WUVl+9tr4PlnEVjtRIeNHFw7ENQVRfasnRMR4YUJv56rKgnQarOgXQhhpb6dxBRlqicM+V3bRnYlwhw1FpRzbS9+OWG54M/pEXd+VK+n5OiUEhk8c6nBlMlnAYQLnu4l0qoEjO1Ryo4Jf4gAUcZ4dapGfaasPNnfNZIxK8rhQME5sx31xkeoblQ9OuQTcYZe8odnpzMNsqQhhUs3qIFyIBPMTanObVXAbBMUtIROMo+efEckGllu6HgCIsNunNcz9USRYGpqczJodCKTiVOXCwu7xJkqzK/dfk5bNjVwfKNHOsWCD7XVk6eY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 10:05:49PM +0200, David Hildenbrand (Arm) wrote:
> On 4/28/26 14:28, Alban Crequy wrote:
> > From: Alban Crequy <albancrequy@microsoft.com>
> > @@ -194,10 +202,18 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
> >  	}
> >  
> >  	/* Get process information */
> > -	task = find_get_task_by_vpid(pid);
> > -	if (!task) {
> > -		rc = -ESRCH;
> > -		goto free_proc_pages;
> > +	if (flags & PROCESS_VM_PIDFD) {
> > +		task = pidfd_get_task(pid, &f_flags);
> > +		if (IS_ERR(task)) {
> > +			rc = PTR_ERR(task);
> 
> This could return -EBADF or -ESRCH. We should document both in the man page. (or
> decide to always return -ESRCH, dunno)

I'm for documenting both in the man page to let userpsace see what went
wrong.

> -- 
> Cheers,
> David

-- 
Sincerely yours,
Mike.

