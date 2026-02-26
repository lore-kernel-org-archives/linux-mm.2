Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F7EAFC5913
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4D46B0088; Thu, 26 Feb 2026 04:53:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7827B6B0089; Thu, 26 Feb 2026 04:53:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E226B008A; Thu, 26 Feb 2026 04:53:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51EF36B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:53:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D896B8CB6C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:52:59 +0000 (UTC)
X-FDA: 84486144078.26.D5ABDA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4352914000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:52:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAgMlvIS;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772099578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxShKsIei25dizH99r60oStP4GhVLs8n7M7Kv2EdVPc=;
	b=YSJolmBUxyv85vgML9yfRDJ4JdY2QxqbpgXObPaXZfQDwvgD7uoexGSlWiRLHpjM+zIWq8
	cfQKojywv80o5HkKUyw5waF8LSl8Li290PsFyFG/O3nm+okX+aH+KUhKvUj6keGTgfyoxR
	NecbAwnBjK3fVHOvdUDleqQvGec0ba0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAgMlvIS;
	spf=pass (imf26.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772099578; a=rsa-sha256;
	cv=none;
	b=tV25pAIgfH0vAhXJkl/Qu+1+tZx06YKLVpjc7YWX2hrwhABNE4sFq3XU49bY4V52pRkHyL
	IPD4W8kqpWud4fh+E9AH8kbgrIUGAE/I+tjWhZ3MjoRXlWeQXmLjWLoG5zAreuti0F+KqP
	e60AJYVXLvq0lrxSmjv38nFNgc6HoFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B856D600AD;
	Thu, 26 Feb 2026 09:52:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11420C19423;
	Thu, 26 Feb 2026 09:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772099577;
	bh=oRmHQaNSX+wXkFe76gVo5+7Bo9bYKnvv46cgcsvJb10=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mAgMlvISORVF1EYhVLkn+sKzlVEnxolvUXx08BDYQeIbwcT2n0EYRbmVkNbJE0nti
	 6/LRZAF9u/wBGVAtsaQjG96aHoVVm26hlhDjn+nV7BaL1yS993rILF3QHxA58lPsQB
	 utEuEjb5IpEZNrvC9WoDWyv/4+cpxHmgEgKENTTmIOq6dVc7mBxz73uKMTdXvee/TY
	 0V+U16Hsa9Fz44Pf2gE2EJE8pymq4KlGXkWVYfPt0lBVTFiEVWs9CgJQ+njiDKY7Ht
	 rHAL3l5UUQS7hehctcVGNO7170qtbq7xqdexY7lUMsik8J9C33C9vP8ldpo52m8r7/
	 fk4UQNkj0XOyw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org,  akpm@linux-foundation.org,  david@redhat.com,
  lorenzo.stoakes@oracle.com,  Liam.Howlett@oracle.com,  vbabka@kernel.org,
  rppt@kernel.org,  graf@amazon.com,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  surenb@google.com,  mhocko@suse.com,
  urezki@gmail.com
Subject: Re: [PATCH v1 1/2] mm/vmalloc: export clear_vm_uninitialized_flag()
In-Reply-To: <20260225223857.1714801-2-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Wed, 25 Feb 2026 17:38:56 -0500")
References: <20260225223857.1714801-1-pasha.tatashin@soleen.com>
	<20260225223857.1714801-2-pasha.tatashin@soleen.com>
Date: Thu, 26 Feb 2026 10:52:53 +0100
Message-ID: <2vxzbjhbde6i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: 4352914000E
X-Rspamd-Server: rspam02
X-Stat-Signature: rib8wb1c9981xjkqsfoaaowys4f4ot6d
X-HE-Tag: 1772099578-844316
X-HE-Meta: U2FsdGVkX1/Ka5RLfqgPUyXFt/Evf3j4julMn+QNlrNAngYlq9x1O/a1gQJRx2KeZNU5dqeeMn//WhDFYhsrjwPMkHLRVnheSJkmRl9jriWc1GOXmlYv5yaNsxU+g3ssDSN2MaTeu7HToyvmHck/esi2pHQQR+XMWiukGPm0iUMlzS1q00xwh2g72t7pJPuEUeBg/nOweiwcmiID6opBm8nlOP8fsKmdzi24QrPKOpx/Kic1kDpBNctzNHqA1LX+uLEa9eTxF5DBzJgZhraVsLh7McYHhYMstOqv1bR9pDNJY2yzZW0pVs+eHDPbhMVAmCZQbFkRNledzNCnXZUEOeof+Pe+oWSonZfiXeNKkBgxHFHR6tnvNhgDq4MP8XZglFyVYnU++yUDdeyXfs8XsqgILObsNNRet/1D4osFELM+pakxvuOG4d0QFpo2CS/l6/D2WfNsXcY/zWE/qqp/ox+30gmBgGdeY7D/U9ARztG4ZYOe045qF2Nx3ZQxJ4gEp7Nl4wGk+cuVCokSBBatR43s3q94Tx44Ry0lwoDlhdzk8ZZwNpunFuOTReHcFqU8EI+XNeF/pqeorhu8rMVqdYLLZ6AyQWvMwf5JJipk/eC/HqNYI+CYTt+yDlr8SF0PgUo2X0ZUP1+AZyKcD+Hf5EF5d8jNgaFEVTMQDOwrmUanXyQOrohAwJiMgStXGzMkSrZetu7vf8FXQI8RhFIPM+HfmWIjH+C5byvE/K+AdKpki5MQphXiKKzCfvXjoIiQxuoh4QxZLF74szvY4s0ija7YgpQqAapEOPp/aflGCCa+/R+QgEK0B4ZxL4eEr9gQvi2Q4sg+XVwE7/7GmqEuWtLAYN+BkSYVpgy5PX+hAg+Og6r4gS9LPqJ8NmsRMUitfrL5X16yluVE7y/VEYwivg0gbCiPzND7MYhNAxJ8wugNdXwsMaLnAnyYirIB36X4TWJOPCAOMaDSMo7Kf1K
 rb8ywAT8
 W6DBALM0HGa6LzEKgCvbuZ2nDlwCMopItoOS2JT4zDovoNlfCqb4vZMpdto7IZMwZBpxdSfBSGZWEh6P/aSnWZPqFwFitkTNEjadtzTA2OlwOeVvNPDcz7l+em4bEiGa6yAAbwzkw6P4C/KFHdiQLofsZv3BHY0zp4LTpY6a6u4dhqMQC3aF2EHGvJuRc4gE43KpsvepqasSW3ZNF2LWlsW3yZDaRIr+3Zb5HDpPvD1bwlMYPRzmE6atR9kUJ/PYPdayqISb32fMeC1wwVSt5mi8rRb5X6r1L/Vhdhc+DR0896c0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25 2026, Pasha Tatashin wrote:

> Make clear_vm_uninitialized_flag() available to other parts of the
> kernel that need to manage vmalloc areas manually, such as KHO for
> restoring vmallocs.
>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>

Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

