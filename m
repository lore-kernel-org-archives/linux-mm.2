Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28D7DCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C9A46B0005; Thu, 28 May 2026 07:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5534C6B0088; Thu, 28 May 2026 07:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442216B008A; Thu, 28 May 2026 07:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7B16B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:11:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5B9FA07E4
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:11:38 +0000 (UTC)
X-FDA: 84816563076.15.EFDE697
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F06EC0008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:11:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOtIqTs7;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779966697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ne5ApovZMbkOettABh46HNsZEAWwxelReJI++i/88Ow=;
	b=KPE8IwoAdxwFuqNaEfSHc6O68tu9Qo+UCAQPFBywZIaOIzkhG5hTjWFksQiRU5PiUiM9HJ
	LA8ivSHa0NH1xP26ghqLoAY6cYLPOK26ATurKsEN8H5CyhddMmGBPJReEgSLk11jbvdztj
	8qIE049cWKtlzgSPzPd/sakUfv/ALZY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOtIqTs7;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779966697; a=rsa-sha256;
	cv=none;
	b=STJXD+vY+KWEf0UBTjXHpZgodTwgxbCpSzVbcQ5qCRExeioVl6pmvEq1NNiL7Hfgo49P/h
	jRb8z8LjfN7LxWcxc4+6xqxz2jqYQ1OsZLsEFGVI0Y3GRLER7tLMG29jvE6QE3n2kObOZ6
	eo4LxtGe2jisSFuYBt9vcdRxJMiCtjg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61ACF439D1;
	Thu, 28 May 2026 11:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5561F000E9;
	Thu, 28 May 2026 11:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779966696;
	bh=ne5ApovZMbkOettABh46HNsZEAWwxelReJI++i/88Ow=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JOtIqTs7UeLBWdtsSWzM+GSBfqiIy4adGPClaPp0l0XYKtsM5StuRWFTvq7iveF/P
	 vvxmfRPg/ti2kC0n1H1QPtrSlOl4pINysNuWq8kX8F5crno1c0DlFVt1OeZcUtY7pJ
	 2z0elgZKMvESunPSiCZipFA/FJjzq4XbPEM0858XbZhS6U0kesX5V62bqmCZZg6HbS
	 lmaBqjjEP8vcAVjm0ceN8givCPZJhHepqCy3K6r9wCvc97IdsjwXUAL6PEa0nmHbAi
	 yZ+h+NZrRlKzZ0JgO2vMEm5u4Is1e3NwP7f/ADZSDgSlOfgERPekDe20moqvKDZXnR
	 UiscGPtsPQJrw==
Date: Thu, 28 May 2026 14:11:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Hongfu Li <lihongfu@kylinos.cn>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com,
	shuah@kernel.org, surenb@google.com, vbabka@kernel.org
Subject: Re: [PATCH v3 1/2] selftests/mm: refactor pkey test helpers and
 unify assertions
Message-ID: <ahgi4I3_hHZK4HdY@kernel.org>
References: <ahbWZJ2BbR8mmDd_@kernel.org>
 <20260528091300.2082967-1-lihongfu@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528091300.2082967-1-lihongfu@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F06EC0008
X-Stat-Signature: jq3am1y8xkizp31y7dt9iat88fg6w9xd
X-HE-Tag: 1779966697-545050
X-HE-Meta: U2FsdGVkX1+C7BBLT5Rtz+m9opauQckbvQIWvm+6VTp9usIKxcD5VZAJBzGa2HM08Dcdha9NCHt+Z/nYt8ukblI+FZoaRJLZrb2be1hgdfjIL4FBwGCdzz3Xmr5q0QQQcvncYF5KVPgrdSFtyFEpLUbG0ZkaZ9T//OEbRqcCoX3U1XrbVUDc1EMEKQvRABl8n0xUicjo0G6m8c0diTFgCr00qxrMg4KOLP6Gsr87SzrIXjpzwKu01odHjhHaSzpjmr3fKRWVkuMrSBpwJYdk0tZNQSst1ThiRJD4nnEnQVYquLCVunoA9RVmbW09Sbw5+O4e2WQLtWcXVKoe5fCU4QUFSjDVPJ2pEzSMFcPNPG5cMpAn2L1rW/iuFzUPjpErAJkmCR0jFK+awqHSNVPi2z6gUJrwGy8KuHmH8oIwVkQot6wA/5pT/KOIEJXbbbg8zpmYlWaH3c1ZEFjifBQsXwuXvDD7huP5LVzONkXKWQnRsBssS2PpLqrqu6L+fkZz6fxTYMPPxlt4DIzJMTCbSGxXBpQgUcPwKQBfbBAbeqA6jO4bhl5HOeqtajrPmZvc7xic1ke9Vo5MfAiZl76DJkgg1OwJKnT5edErA0QiC130u4HZxQurF8RYW6j7Ew0Yx2VMXWQH6v2Mrc7ZDJ4/kGisRu1Bi6WXNXlHYeaOnwVw+swT/XJjsJtk+hJ7W/kuPeL3Jw6LN/8rP4eBnGNw8gi19+HLYMVCgZ/HrOeQKVyT6eoZc7FCDww5APtgPegbaYK2nbaMzVrn8Yh+iczi7t0gi7cB1JrTA1c7zpRRlLSmLgbomalqkMjLOzBOtk9pq/7JDnu1WyMhCD1wtVQV4OyE8rvDw7AMT5KgANTnBUTi+J5lb0woBdPDqZL8t6ZkzuFPK3YIV62iYDBk8G4EavP1mHD1l6stj7TGRehJFXkxiDxgB7Tph/82JQZrIFmy8nzRv+rGK5n/7jFC64B
 XKufAYc2
 H4IfBtWV2X94HkT9uvyOxnKvqfneIYSxa+eJB7KTlyuPRBHUAaFoceAW/AkrPX/aPP9Hy20V8DyUIvmpp9zR8n0SlSfA36mGJbaLFFCdo45QFl1par0vVRFduezhbnN/9AardVAsiM/TaJ0Qi49LrT8R+2mX6phjGirWrME/s0byke0Momt6X5IDL3dWH9SMRdWBf95S7999ywcG+XHgaaJEsSCoE9v/UUaAM+vm4HgQJEogtgdCmiSD8dnW+O/8DXJOZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 05:13:00PM +0800, Hongfu Li wrote:
> Hi Mike,
> Thanks for the review comments.
> 
> > > Move shared tracing and assertion helpers to a common file, then
> > > convert the sighandler test to use pkey_assert() for consistent
> > > diagnostic output, and add per-test tracing around test execution.
> > 
> > This sounds like three patches to me.
> 
> Got it, should I split this into three individual patches?

Yes please.
 
> Best regards,
> Hongfu

-- 
Sincerely yours,
Mike.

