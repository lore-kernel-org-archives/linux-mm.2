Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F03EC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 20:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226866B05C8; Thu, 13 Aug 2026 16:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE856B05C9; Thu, 13 Aug 2026 16:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F43B6B05CA; Thu, 13 Aug 2026 16:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB2406B05C8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:54:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FD2D1A02D4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:54:02 +0000 (UTC)
X-FDA: 85097448324.27.29A109D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA6D7140008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 20:54:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GwKLM8Ah;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786654440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv+D0N5s4pcZMvVyMfXVvuezcVPbWcTi4pVO4nUOFyw=;
	b=Dsaj5pCsbTcdCvCb7ro3ZRUlZdE52UG9iKK7AgtM2KZRzzZKFf1rmhekzGIR7qBJ9MptOU
	wwyf2v/NpBeZQbgIyjg1Qr0B9ki/o5zrJ/B3KWS8mKYCydKp41WeCYvRZQNrOSmoDhcv93
	KbHkJ/dtk0ZhSkwch45GCZKvbZdQ0DE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786654440;
	b=7mNxz8LPv4TFQ6m6vQPnXmsHGCow7Di4TYAE2WPseAm2LxdkVsaaKaH6K4nnKf7yXZ/VMT
	fjSUZykma8UOfm4g0/NZXmns+RCh7jmWNYT2InAUCPHDcyR1qsDt9CLvs5mapoZekQ9xEi
	SiccG15PcXWRPYtULqdSgzhZQMdW4LM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GwKLM8Ah;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18159600DA;
	Thu, 13 Aug 2026 20:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371391F000E9;
	Thu, 13 Aug 2026 20:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786654439;
	bh=Kv+D0N5s4pcZMvVyMfXVvuezcVPbWcTi4pVO4nUOFyw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GwKLM8Ahu9/jbn7Mg/CQfv4UCp2ocuusNZqw+AsW1lNmNRtwW5sS9VzYhIB3gWXjz
	 v+bDy4Vi/jF+CmeUQQW3tEJ1GS3U3xyHiNwmNQgop5YeN5w90nQOFh7mhkyUWAMKcz
	 ydlqNtgfHQHDsa851VQZcqDyOeHQLLXV78K0NmG8=
Date: Thu, 13 Aug 2026 13:53:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, Lorenzo Stoakes
 <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 5/7] mm/khugepaged: Refactor the PTE state checks
 into a helper
Message-Id: <20260813135358.89ae1bddf29e5e380b5a61dc@linux-foundation.org>
In-Reply-To: <2666af48-1e95-4f68-8978-90dc3f4832db@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
	<20260811-khugepaged_pte_refactor-v4-5-ddac39d61c4a@linux.dev>
	<f1371b4d-6e98-4699-8c1b-7612f6d70f02@kernel.org>
	<20260812123959.d4e31d68e8db85b9fd3981eb@linux-foundation.org>
	<3dd59ad8-2f00-4332-91f8-7871e8d60b02@kernel.org>
	<2666af48-1e95-4f68-8978-90dc3f4832db@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: hyarctemb3psaf53oujdrhsegqau6hqs
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AA6D7140008
X-HE-Tag: 1786654440-440726
X-HE-Meta: U2FsdGVkX1+X3NnQn5EChbxfGtH5ONR+pCdrbZEfC+xHnztel2PmIPSvxz6uW7UILS0ZNIYIaMzzdvQxVXI8+ln1+32GEQYwlsjf8r7EKzNnR34g/8Yao4gYaAQ60YGee4EKbvVbr5+lmbdnmSLuUFVEWAT0jSBKwdbGPmTZ0NtoAv5bYr9zVWUm6iUnFJz6iGAe5APv0C5rgAMnSPukYbTjjK2/9xSyot32zeuPBoFqBnsNvYZxB420mTpawL9t4WfFUkMKx4e68rwT2z0PhyOCZxs5lTLUfcB4HouzRE+P73sNMyTvBA7S9Nxukn5EF6MSKv3nVN+JTkAp/TjQ1qH55DH0Q2aVt4+xIYaS0sDeQCvZJIm4GWlSbJrZdO37+7F3p+CfPpApRQlp7ZtAchWpe+fi9Lg4lZgSLVvit6nSEu7AGYzwsJmicNy0hMGdoheDY6atBU8JtiFKer/MfIzFVmk4xfkFBUM5Flz6S3u9sxVYvLqRxEXJKOjeKH6serxFbRVXpu+Y2Gvgae8KUpqy4xZJnzpayPRzxs2SbW2RUbdyEhDlWep17ZW/anyzffK1KSJ/21JaGD5keA/dFXAI4Y10F3lhIOTOiSs1g1VGNl7pv+givt4K+5L1Nf6Feh+j3Thk0Wxh640dV7Mp8gfduVq4qGw/e5Z258lmKKleNSp63Gc4XuJ3D7c4JiKG/JD1ZSRrFBU6mvPz53AOGyJJLrYAd0rDEN+nHpLD5bNf7NI4E0FYR+4Dre4Qd0CPrxNk7SOGYHthXNbElUAGSzxRfBXU0bk0Ew6bc3OXYlKHSmI56/EqPdayiJ3IoAoQ2qQQF0S5fyMzGfeMCk/IezrhOTx3CFeX04jE69a4NWeb7p23G5jCInLdrHPcAaOkRs80Y0qJEbEWDAylVEogEPyruhX5N1hVigOg8yHeexJ9H4nN1TX0fJ+DCqj3i/nH2HA7Ps3zRRA7Fnl802S
 HJjV4+RZ
 c/TSD7ooJbBomab45dt0Hte4pNWSmJtTCbL0j3pBH9qMy306WdGXOl1CguMbt16V/ZPAGmiO2tKOADmAR1UcaFZKVG89EtRd7efCEtzWszsYCDYth28WC/dDobzv/X7TvpWHammXPI7Ifjmb1vej5Cs8BqM+PSlnrJlDwv3DM4S4svyNBrUP+eKqHO4OKaCFBlon3CXg2Cd/N2bGi1LvqS5kweWvP01hAmxdQnb/l5RbyGiN4fY5WwRwShvnOmPxVXg85
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 12 Aug 2026 20:12:56 -0600 "Nico Pache (Red Hat)" <nico.pache@linux.dev> wrote:

> >> This has been floating around since July 6, so it's never been
> >> fast-tracked!
> > 
> > That's not what I mean. Stuff must be reviewed. Review capacity is limited. Some
> > stuff gets de-prioritized and reviewed later.
> > 
> > I managed to review it now, but concluded that it needs more work.
> > 
> > Instead of reworking the patch now to squeeze it in just before the merge
> > window, better to resend this single patch for the next cycle.
> 
> I would be ok with pushing the 6 patches that are ready and leave this one for
> the next cycle!
> 
> @Andrew,
> 
> Can you please just drop this patch from the series. I will resubmit once i
> handle the feedback provided here.

Gone.

