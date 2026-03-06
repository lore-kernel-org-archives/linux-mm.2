Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8D55FCC076
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 22:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5DA76B0005; Fri,  6 Mar 2026 17:21:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E361C6B0089; Fri,  6 Mar 2026 17:21:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C286B008A; Fri,  6 Mar 2026 17:21:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C87E86B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:21:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A57B2140656
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 22:21:52 +0000 (UTC)
X-FDA: 84517061664.08.3BB3231
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 196482000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 22:21:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ut5nk3Wa;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772835711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqI/tU66YMc/8NEBFtANC+E3ke0onX2t3xQN5vQMn/8=;
	b=gQbBAQAom7VmS00lSy263McO/DrLodJMZrn7jWAaaVKaHaFF5dyDmneXPDQTBQ/OwdjvMu
	UeLwNEaaekL007rJBKSpnbFpuza4wW4OtvJHYXp4GwB7dEmI1qEUhEi7XtppuevT2jUJwq
	JFS1N136AR2C3DEK399sPwAchQouEIU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772835711; a=rsa-sha256;
	cv=none;
	b=E9v4u+EutyukRUSyTi7Nn2Vl2lg7uJtI99FrvdP0UzJEu7QaDLchFiXTv09OG1XmNa8Azy
	Zt/gmgl2fNSHfvSRXvLDqFFyy05Y+w6wTKBnxzInpi/x2MHj+7uF9Xk5DHvpzZHMDt7j4L
	b/FLoh+5gKmTmaF0VF6AXJaEGMTKYS8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ut5nk3Wa;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E72A64058F;
	Fri,  6 Mar 2026 22:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A11C4CEF7;
	Fri,  6 Mar 2026 22:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772835709;
	bh=bV1QSwGRDjvKEhTSPW1LplJ4jYX4s0PKhruk1J09GiE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ut5nk3WazFvH9wgHR2ZbxZZpTD0bTW2utubyiP5W6BRm8maFCmdz8FwTWhJ/rATNY
	 Z6kUnDQY/To8UJeZImQ91rLJ0BkNu2UO3F9xdkFiAaZIb9gfEquiFNNJqCD6fbhF+T
	 AP7+ChdVrn4jDW6aTIx8edVssGux8PtADmo8IEVY=
Date: Fri, 6 Mar 2026 14:21:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Axel Rasmussen
 <axelrasmussen@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 James Houghton <jthoughton@google.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin
 <kalyazin@amazon.com>, Oscar Salvador <osalvador@suse.de>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/15]  mm, kvm: allow uffd support in guest_memfd
Message-Id: <20260306142148.953267d97a085286d43e116d@linux-foundation.org>
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 196482000F
X-Stat-Signature: x55dqdouj1wecqqrzj835fpkff9hrf4w
X-Rspam-User: 
X-HE-Tag: 1772835710-121014
X-HE-Meta: U2FsdGVkX1+/rURuT61DpL0LsBExC/nRoRNc5oCsYyL/Drowwz5eAkMXkMHc66VnE44umom8gBEKsjEKvyoJkbTYpbKi9mP6YHCqR9vaD4DJo1xQzVw6SNCVu6QyyfjABa0YHIodDugDdwli+l73vrct7N4mJTLv8lgF/UFlteHvnss2XJVr+D3seOmAfC5nb+oTt5zmn3kmn1/1g70hXMVpw5FmmGIihGCYQPIdoB/Xh9b84xXr+MwF33louptCmthXyuDUJinI3IU670yrwX5Ot96/LEjWQN5HEIDS3scup1e7utS8GVmCM3coJOmd0jbZGo+jd6fWtiZ3KLeQDpYDjJjJ9pTnBtAq3/4yiGs6mVnLRNODGe5sWGcWvh+gGzUV/stbd9dtoFjPpCW4zykMXAXlpt6caEF4+OUtvDSnVZ+41eAgqAHgqjU50JCPdXYR04TriXFRyRG/AD8rv2yhzbcq2k+UmEFMEUvb2wOT1gi+1vZ7aOVRih946DjXHMUK/qz5YM9eWPHo226GPCIQH+1jcu+cXxrBOhLVpwmuXsd/T+unb80qZjWV0SVkSxKwHhDG/Yz0odOV2Um9JiFt8HGw6KvPo3Fsq3gRmjRIfSlvHRo3pT5UcuRfIT2wFoKtEGzVlRLLKV+zKbo5fPcQnSEuCYAUfnmy2RHhWHKsaY/UYgOWnLYdvPWgsZYqhwVeNuANSb6DWi0PjP9WOvJpALOxTy3lsdoAhYtwKdsIyfaBaA/p42kPbNTywkkRuJwOK6Dhzw+ibD2ffgZJv/q22s2A4xjj3aDFEcIBgohGHVujkB3x9bnwz7vXz/8Wo7kpgBL13xv1oPW7u5xtguFhgxccI+31LMlFd8sm3yOM65zYnAczjMBzJR49nsqgF/g4In4N7pIJnG7U6gErjOj1AhrNv+gm+kiQXAmMxJoQ3zJPyu7lsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Mar 2026 19:18:00 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> These patches enable support for userfaultfd in guest_memfd.

Thanks, Mike.  I'll get this into the pipeline for testing.

Review is a little patchy at this time but hopefully that will improve
over the next few weeks.

