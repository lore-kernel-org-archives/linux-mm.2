Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E030DCC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 04:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821696B0088; Thu, 15 Oct 2026 00:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1586B008A; Thu, 15 Oct 2026 00:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3AB6B008C; Thu, 15 Oct 2026 00:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FF856B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 00:34:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AAC2A1C42B7
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:34:14 +0000 (UTC)
X-FDA: 85323593628.04.52F415B
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf03.hostedemail.com (Postfix) with ESMTP id 88E1020008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:34:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dhsEw5MK;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792038852;
	b=mEBsDld/gTHUXPd8EC4+9MExribL1SMR8kMxPuePOecDD+C+HDxn/SttQfv/EhfbixMsmm
	uhdaXTwjSI+yT64fFAx6Mxij77LjN7jCMFrTIJdFn57MMS8RmLhBVBVPUODpFxWLcggAFm
	/QnKE21wE9kvt/nkftwtWQK0HQSkTCg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dhsEw5MK;
	spf=pass (imf03.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792038852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuHIO3qVjKGH7gFz7JPZCc6o6MO4igxmSHN59B2FBnk=;
	b=Qr7GcOG9EBfM/aT5CoZMtIlMFrFqjd2T+ZMsurm4YCnfrTO/l4yc2yxSJWM+nIX/HIRLyE
	a81k9IBoL+EzjqR3LUVVyX0ORcShe6vESVbcO73yzS+62B7ekflufiioLxnlO3M+MFzdZr
	PEtbj+TKhQtwa0MaPRMhxxXgwztM5Aw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tyD77QsF1TpQDhIMjdBhY/MqpYw4DT/Qu2z80DaAtcI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792038850; v=1; x=1792643650;
 b=dhsEw5MKBBoGzTz2w+QQH1VHDCAyl4zXmQkATTHI09MQO24gtw3YEC2O5JR/3Z85P5ul1FUU
 H/KNCWTprdhB/RgHdWFZ1ul/Da31iu5WJNnNlh9NOxBkrjErN4CuSZB3UP/iU5tQqS1U+L7G8v1
 9IBheFIT97GPLhkjcIVWP8lg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b288e4c6ce06f05c;
	Thu, 15 Oct 2026 04:34:10 +0000
X-Mizu-Trace-ID: b288e4c6ce06f05c
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com
Subject: Re: [PATCH v5 1/9] mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Thu, 15 Oct 2026 12:34:04 +0800
Message-ID: <20261015043404.57470-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261014171145.3292736-2-kas@kernel.org>
References: <20261014171145.3292736-2-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eenbw8da3fughrmsrbw4onuygjo8js3t
X-Rspamd-Queue-Id: 88E1020008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792038852-764797
X-HE-Meta: U2FsdGVkX18xTyHJFLDiAIbfV9KFKtDKmd2Rg3d7mnoOVIfkFNwaibT4/awlXv2Z9Jr5MUFXagaAfj8315/G8Xx/XSAk3wAx5KfIMfFUKRNv9sxUx6qUE1yChKlUMjOt5M7SGu8Go4V49EUhiOVsyXHwh5pEO14pZaeF54hTrZHt0tOwA+kIbCJR8/JtLVFuAo1dtX7MtE3pzB1KvvAXAELDkMjBGV811ZdLfy6bfUYz9NlQcGC3VtKV5Po3wWpXQ2snsXl60stJoU8+8qLljwg3k1Ko/vm3w0M6z0IOzTfYHVJAdABzuOZGE1hfhcNywNnaCLY8IYE9Q0I0AlPUhP2BRUE0NfN3kIJrMhVZIRh7v4hY4x5fIl7VOmlNEG4fjhYvmh7RLTH+BeU1pzMClfz2splDsVCVapLiiK34qCxDliW0lX522Aq/pI/4UZ9SQRMgbsrIU3yevoZy1XOUP9ff6b+qDQvTeaNDYDQsdPkCzohB9rU85LZjS+H6n0OPPyHjseuH/BIPsNeU/zt8wOzRxUASjspqNNsqLC6sC25c4rXV/ZkYgWljshzZiCFOcuD1yHeF7AE/pAPTkq9XifTOKTryfBeZc5KUXkWAjukgutWolw6M5Yd94kcIRIKUzqknEHGcVapbeas5T9hmmJQHCh/iz33f05NNFOO+OqTR7b5uNpTm7LPF2kET0vdHKwNEm1kQMcGVMAf2PQ+/Ig5EH0jRPaprXgTuKIYM6Tv1ozWj0kNAOfR352+g5njNG/I3pD+8R4CfHKtACts3W/n+LgDNOkbwYNIh4AxC6pdjJyRClSZtXqLCAyoJ/h917tzowLyjRhEya3C1htNRzJg5YZ+2t+WoF3wApNB8g1jhHfeYzcLuJqyFO1N5NBq/OYeBNhNTakaf/bWvLi0XLci1d4cYhzSK609qPa0mASlyvhhgQLEjdAz5+zW063EC3HyzSsrvW7iMOOU0dFs
 XDCcr3xS
 ZyRWRoV/Xn+FPmaQL0bi3sv5wzTKgvjc+X+odpPKCGx7qy/GYws6IyijuD2Kc1GaPYSGRIso0p2vWWDhVB62XKG0TuFtfipt2sQbaiTpsMD6qo+NKczJn2MEgCAqjENYNWd03TqztmVMRLeNeNvFR6X6tHMFXTbFodBbPYxnyWoJazKiwpAFSt94z302/UumG8OtdAmi8v5of42Kv8NaqOtDfnFc5mV2FCMOSK/0uiIwMLNZGjWPwo566OgBP4vpWKg+CS2cu878i67hxL9AV51aY89OsRkyPl075dGlMwBNQyLJYkMvUn1qsnFuX9sPYfsseVDghHZSQ7lT7xzO5b375acTdnWfb9y49
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Oct 14, 2026 at 06:11:34PM +0100, Kiryl Shutsemau (Meta) wrote:
>madvise_collapse() holds an mmgrab() reference across its work. It is
>redundant. Every caller already holds mm_users:
>
> - madvise(2) works on current->mm, which lives as long as the task is in
>   the syscall;
> - process_madvise(2) reaches a remote mm through mm_access(), which takes
>   an mm_users reference and holds it until the syscall returns;
> - io_uring passes current->mm;
> - DAMON takes one with get_task_mm() and drops it after the call.
>
>Drop the mmgrab()/mmdrop() pair.
>
>Assisted-by: LLM
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

