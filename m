Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57278606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 00:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=t1nwqyHJ
Received: by kanga.kvack.org (Postfix)
	id 5AFCE6B05B4; Mon,  2 Nov 2026 19:23:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55F4F6B05B5; Mon,  2 Nov 2026 19:23:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475A76B05B6; Mon,  2 Nov 2026 19:23:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 23DC66B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:23:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 221B41A031B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:23:09 +0000 (UTC)
X-FDA: 85391908098.21.CD30579
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5C72AA0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:23:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1nwqyHJ;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793665387;
	b=2cJFeEdTZXyiBYQhaUBDlRfZWpaQZmzjKgEF6ap+KFlbluTmCZ0zm67RRGfvkTXlnpViht
	fiaAAyXaNlf3J8dLT1Q5+zM5IPHiwNkkrNMZF97n9dliMeiR72M4jDsOIeDmkdCfoFNo1B
	puJtG0hCO0aYZ0piM3rD5xwWMJCopuY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1nwqyHJ;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793665387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43GQKuF8gnWzeMixXIHR+gqzDOYo2CW1whq/gMMSMBU=;
	b=XFzGEUwycI9iHIFj9jPLsiIUVK7+FlsGwyA41Sgi7ecd8+yE5fyhx+Wv+JIFWhVDI1hkTO
	DbBJl/gx6uLwTBzqQ+owNRI+SVpJ9SOSphPri4zUa9EVMnqNZAGgqSkNSNeuDfBgpg5JZQ
	doDokBw27ycKFTcMd0P93jwOg/Wu8Ew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFF546020A;
	Tue,  3 Nov 2026 00:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B9FC1F00A02;
	Tue,  3 Nov 2026 00:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793665385;
	bh=43GQKuF8gnWzeMixXIHR+gqzDOYo2CW1whq/gMMSMBU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t1nwqyHJ9/PB3Pu8mlbhH+QgW8T8h2UH42XScBdEdhYy/NwJCYK5nsll4EyNe6sUt
	 LZSvhF6cMqpKA/wtqDwIrfh7NPzFceszEPqj481hJKQpALL9zUBAWyBJ4NnCksks6G
	 fuwujKkAWNlXn80RxjDNHRW/ZCskNJMxftbU0sWg=
Date: Mon, 2 Nov 2026 16:23:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, David Hildenbrand <david@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador
 <osalvador@suse.de>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm/mremap: fix accounting on a partial move
Message-Id: <20261102162304.c3585fc3fb88644118c152d7@linux-foundation.org>
In-Reply-To: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
References: <20261102-b4-mremap-pre-split-v2-0-d281dd11ad7d@toxicpanda.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ogxh9am5w88g1u6ysnhu8u49heyw9e89
X-Rspamd-Queue-Id: 5C72AA0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793665387-159694
X-HE-Meta: U2FsdGVkX18MIrbKl2uq/C4UzljF+lrIIFIEYbqgkgKlTSjW3SfhpmLj/LWp9PAQlNTOnFTKuM+Lcea9/S92mJKqBv3RxYtFETrQ8lMfzz2IMqqMflvdsEel+2ZM/rS9cHlZSu9joUHjhzCKDXWV8d8e/YrRcrFu4wee0Aj61wNj0cshGmyM6vg4VBEok9yGy3IyztjvdkN8gjWUHzGGdkXnsH9Fmd+5NxL0UNynsgEz9759EPUntCN/LArGhlfjgCaA95CueGDSUM54xSt9eI8XVNeB1+zetGII5gSsJ70+apPayK65Hao6UMjV+Q2DWsmfsKJ+3JQ9YQJVfwEPOjIK5e75nnSbCEtclnhRqsHGDGaIbBhpTupN1XarJ2Ur0lpvHxkqCYlN5W9rMs3ekG3fFH3A35BKBkTIalWB/X1x0QmSfevx5WXnaOKi+2Xs5hvqfnWHRE8mwICihtB9PndyjRhj+QAHcN2uxmTnc60fVorM/VWjSzKGYWC7v4uVJmKoTa2Sn6Q0iarIj+HikcJAMzIUu4+Pgc+BqOQfBUc5esUCumptmj1ueLxPp7bbYykKnvvP3e0n09RaHE/IuZlQcxWrwYql9QrfR9BC23w00Rs+f6w59GqxmnqvssiFINGrh7NEzj0/vNQx008m5KJhsiiCAVBVyUlnVHvbBz3ugq6cLykuUsqd34d+d75S1rBA4BVhf/enb5gzd3b1D4KbRxH1PkUVUxOXDMgBtjme6q7603xz+hmoV077ErRN2JsLSJLU38T+MfoIihktsJ5r9mj0MEVcpReWjrdfcSwtH7zZ+7XDm0o8Xp233XpJca+S+dgi5LWFL3fAVTHSqeU6LOc7QKLe1pQL18FC2HdsrOF7u/o0dl/jeDnrvnoh0ISaV/+wCAKsGpWMWhi7pLdH6jVEV91UyhCBYgCmcgYToehC1prrQVIbuXpAjhzcQ+tuWJejkq6WHPayR7+
 4y+i5hjk
 g4JenVi/bmiAkITp5MyTKG4Akliqa1wa87hutGjn+DGdUN4ajqF13J9jhs3akgk4m77NXOdhaEADoNSS6txMFxHWGsbRlIsK+wCsg8IYo/+q616js8wce2u1bVhgUPOftlUqgjVqt9Owj24gwxx7Rz69Jl1m0VYayx+QvfeZO/G+qsjbX9OhpSJOrSRSu5864uRwSOMGs+LOqKhArEcpBAtsfB4fAiUHFbEQcENgJnI2HMVjH1VpaVMPqGejKcNmbllJijTxnZDgNw0U2Kgm6VFnjbu7k/D28uwu9vd+vvIvW1S01VvazEYcctg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 23:45:56 +0000 Josef Bacik <josef@toxicpanda.com> wrote:

> I went through the callers of __split_vma() to see who can't cope with
> it failing, and mremap() is the bad one.  If you move part of a VMA we
> don't split it until the very end, when we unmap the old range.  By then
> the page tables have moved and there's nothing to go back to, so we fix
> up the accounting and return success with the old range still mapped.
> 
> Lorenzo recently added a way to split ahead of the move for the mlock()
> + MREMAP_DONTUNMAP case.  This series uses that for every move that
> unmaps its source, so a split that fails is reported before we've done
> anything.
> 
> Doing that turned up a real bug in hugetlb.  We take the reservation map
> away from the whole old VMA before the part that's moving is split off,
> so the parts that stay never give their reservations back.  That fix is
> the first patch so it can go to stable by itself, and the second patch
> is a selftest for it.
> 
> The next two fix the accounting for when the unmap at the end does fail,
> we either charged memory that was never accounted or lost track of the
> charge for the whole VMA.  That gets a lot harder to hit with the last
> patch but it's still possible.  There's also a test for an old size of
> 0, which nothing covered.

Thanks.

So we have two userspace-visible accounting fixups: htlb reservation
leak, Committed_AS if mremap's unmap failed.  Yes?

How come the first is cc:stable and the second is not?


