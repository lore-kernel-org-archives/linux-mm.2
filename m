Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5861ACCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 01:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C268E00D6; Mon,  3 Nov 2025 20:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FC0A8E0058; Mon,  3 Nov 2025 20:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB578E00D6; Mon,  3 Nov 2025 20:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46BF98E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:43:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB836C02E9
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:43:47 +0000 (UTC)
X-FDA: 84071228094.28.7A03ACB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4ED9B2000E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:43:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dY6b2MM6;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762220626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/dyn6nmohhI4MmC9nR9yAqBB4AN045O0WH/mgI5Uck=;
	b=M1JmF+KaAf1Ybk3P13HIS7sGiRB86vMmD5jIGvjaEAu3BkIMpI8IQiyhygSo03M3xpN8aV
	agJlqmHbYjgESsSEOpbvhigCYft0fZtXlIced3hMgRZ1DJtHJVXipJG8O0bk8WqByrYZCe
	ZaS94Sr9eKxCrixAy7kUROEE0jr9P5Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762220626; a=rsa-sha256;
	cv=none;
	b=g0yITYncQ4+HYfofofakvQ2YTzlBGlxN8bPyaRn5Srrwch8nZo9Vjzz34LM3ohATZCmheN
	MOirioRiY0E4OuqXaqMb10JveDWRRGBphWoGsD9+n31gFtXWgNM675FiOqe+ZsbCfrGYB5
	dpPCo/LRGHNVzFSixW88m4NWYfBnH1Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dY6b2MM6;
	spf=pass (imf13.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 389A940707;
	Tue,  4 Nov 2025 01:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0699BC4CEFD;
	Tue,  4 Nov 2025 01:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762220625;
	bh=BX0tUVsyY8ldvnds1/e/y6kgPKJqlyj2E8lWQ44dxfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dY6b2MM6lvQesY8UEelJfXc71chFYKuoyIOZKssRUSMQJxDm9jXPKotxE9/ABbFPu
	 XdSerDYLKzYzDqDQ6JtxN3d5froEQfTFFz5xPdBJiYV5fi7EtRoBao1e6KRqYwr3AY
	 4WLnVKWA2sLfmr9+9HcGjMrprpXu64yk6i9qhfJk1xH3AdHuzSaP7REg2SZctZwFBT
	 ziPcYiFBzusRmwzHTOosUeYKOg4gg5R34YL/8ezSb/+A5pYwNrmsMmzydnbJ1FjVaF
	 jXaQc0pHgng9HvscIjQuljf8jrhjAvtPL5qfzHDAlZO3QJ8dh49y79v1EdVD6oFICv
	 aPXmbZutFbm5Q==
Date: Mon, 3 Nov 2025 17:43:44 -0800
From: Kees Cook <kees@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 18/50] convert pstore
Message-ID: <202511031743.3F127F8@keescook>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-19-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251028004614.393374-19-viro@zeniv.linux.org.uk>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4ED9B2000E
X-Stat-Signature: k95zf4q86ooxkmg1yngqi7h1jynhqk7u
X-Rspam-User: 
X-HE-Tag: 1762220626-830
X-HE-Meta: U2FsdGVkX1878hHqcwXnzYAgnlY5kTLS1gHlCyhsK65SU5y5EfrZ6n8852A27L4v8LVNiFUGwvrzWmsJH5hv61AmM5XQoKDRqWAWo1U53pNdt8lI65T1th00IPcj+UkpSVCE/TXk+ouwymLgzuLIRY8oDikYrNWIiWyLG51pOpnla3AYu+TDGaJzKPI8rCS7iZCNXnRrRUicaXBK182A/ThjgC3G9KN3YPimun2W9J2NgQyq2LN492Kgyi+vn2q9UEAMJF+TKsXEr8J155OsjS8MxqQkXtsCxN4f10FVJlo3c2vkmiY+lTYPro+JE5NS0HPJKcDOnEUVPYLbBao7sNtPPUo5Dplo9ugDKU7Lu5c0OFxZwdCzdYOyksJcK/6Bp6q2syeTo+A2y52FRha/PLDiVNyw0uoANhWnrCmUlTMAJhelPHRsepTGCIKg/8l2vxmGu9MUInTWBVLjdE01fc1pu7pQItyuXKLyNasdizYVKcTszcSzUQOP3GFhIC/1L6CGB92B8Tmxq2InhR876A7J5SAkjGB2SvsOadNNnqMq7/c+4PbzgeWp7ofOpB9+dZEeU26x30PAK7J1uy4rmxsqD2HDCGDngwGLFzKaktuxw3xCVCjoO8rMh1rdldBUOY49W5ol1XTFkq6hFaGVS5jPqLCoPefnOSNwFl6G9pIqZ0FAm8GqLoI9fa+2T67wxJ5Y2Zmfe+uAjL2ubIKLrn6/zwr+7NmjAYBuC5uJEOd+GA69c5MRKVjOw3CIiMVWg0HwqyA1zGt2gHQps61yr5BgBunMUzTZCf++s2BTOunupmrlin1cfNY63vymiJ/Z8JQ3Y8dc69rlbbigK+33DRvDJOKeMJljaeCeD0wxvOy3xPXkU3IQDJljqdOwJJmW003/HKydcuhgr730aUDC0HIwrUyhoSsrN72BTEVQ0Bs4tXj4uwvRmuKidZB9MpysaRil0W3R5+N6n2D0i7V
 QmIY4OfF
 MvTbF070MRwgsZ1BiHUy8Kwwcpygv3y17Uq0fngGwY8JMELp7bBIlbONJzhiM7iwoyWGqZYjNM0NlMwlFpBLuJkmX7Vw2/EqzO0AUe0W5kESVn6QwBCRymb8VrtFbIWja7Up2yCAlz7xQQkyCACvfomMrsaMmzKW2Aob+NV4984K+1iOGgnq01neVTjWfGiUdAnW/oH0Wnio4eTOY9t01c3fh1MtX8N9u8Wt5ak5SbBQOj2JdfZeni3wBxNhvQqBu0Gnb1D+G4yAM+EB2lgWJ+j3h14gWbT8cCjvyhT9MnfV0ZzcD9YePCyW62E4CyVV4yCy2YWsoXS33EYtVKCGEH4jh6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 12:45:37AM +0000, Al Viro wrote:
> object creation by d_alloc_name()+d_add() in pstore_mkfile(), removal -
> via normal VFS codepaths (with ->unlink() using simple_unlink()) or
> in pstore_put_backend_records() via locked_recursive_removal()
> 
> Replace d_add() with d_make_persistent()+dput() - that's what really
> happens there.  The reference that goes into record->dentry is valid
> only until the unlink (and explicitly cleared by pstore_unlink()).
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks for the refactoring!

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

