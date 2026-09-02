Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79D36C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 00:37:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34E296B0088; Tue,  1 Sep 2026 20:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D82F6B008C; Tue,  1 Sep 2026 20:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0E66B0092; Tue,  1 Sep 2026 20:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DDF566B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:37:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52FD9C05D8
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:37:52 +0000 (UTC)
X-FDA: 85166959584.15.ED8EA0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7820F140008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:37:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D18Ag4xO;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788309470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OjQTWFjr3g8QuMQZtzxOAtJbr0dNvjLCHbenCSbYbk=;
	b=KCZgknYamPhiGWH9Kd0RPS1FPppYI35xVFJUtAdWZ2u4d+syZ27/89ZgzlwuqfWDV46Y75
	CgXsAYgn87Sfu4sSxiPGkABbAUOLUpK0mMgtfVomfPH2gqYSvzvyV0QdtbcCD03GA88NQ8
	ksCaDJZNf20KCD8InrNa2Uv/6TtzUkU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=D18Ag4xO;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788309470;
	b=FSQA5asmxApwsKk7YsMtOOXMD3xT1LcpMpjobmM+Ju+zP4MVDkYR8NHbg0S4eSWqepgdJI
	Gk1aif7gK22pvagdM5u9TI45BKBb/D/t5DfSL+NRpxq++3Cqgv7VgeSOaRH3llq4FeniC7
	HwwGdzvSWJIU4mhFgsEVgJgSUhKBho8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86EA64363C;
	Wed,  2 Sep 2026 00:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71E21F000E9;
	Wed,  2 Sep 2026 00:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788309469;
	bh=0OjQTWFjr3g8QuMQZtzxOAtJbr0dNvjLCHbenCSbYbk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=D18Ag4xO/VPxhMwPPvaK5e//nY7ZnAzaHe2I3hrFc9rIGQdajCtf6uRxkUe0XPIvx
	 UpqTskh2B8T5+rHVvLvdUqMGAT/xmmDg2JyCLr+aGr9m6e2IDRZkZF5/+HbU7PHq7j
	 hcf6v9JEbt6hj4bEDH/OpGoB81Bq4NRJWwLYiO4E=
Date: Tue, 1 Sep 2026 17:37:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Song Hu <husong@kylinos.cn>
Cc: linux-mm@kvack.org, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, Mina Almasry
 <almasrymina@google.com>
Subject: Re: [PATCH 2/2] selftests/mm: restore hidden hugetlb reservation
 scenarios
Message-Id: <20260901173748.fb7a442941102894a0c42baa@linux-foundation.org>
In-Reply-To: <20260714021630.1063823-1-husong@kylinos.cn>
References: <20260714021630.1063823-1-husong@kylinos.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4ss175joai98fnthani94fg95srsw1iw
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7820F140008
X-Rspam-User: 
X-HE-Tag: 1788309470-781269
X-HE-Meta: U2FsdGVkX1+NDQFmYCD0ufpJEKY+ehhe+ljuK0JNTJpPF/suz2i9OwmBi/mOTFBMRZoLFaumI1373qU5VhpCMDcqHzJaGOiIQU0VhbYZ77fOZ6eTs7cX1xavr6k9gQ/l/g9wCRCR5UfcAfBkXQmRpoWC6nPdxOmjNpj618OudTaiCBvYk7B/zbmEZkR0eDCkoxFAC36G+fCiwc4b/o7lIBzPqIpEGD8WKwwmTSD8aamV58DEzr/SKi2Ust5gajqI3m0qOtQvrlOsWNf5aQb56JpXXuWjxjliq3AqTUlXqr9kowv3OHTpyDkUzI/n/48m4coM+vDhBlv+Gz1z4K1XgwMH2wzwskzI8SKqydEcNjzDD31Lay8sYiVH0il2FtHL2TS+HhHdSwtFe/qQ1fw8vO/YRzoj1lE84n/V0eMey0c/8atyXoyhUJSfwQ9hUe3JtjylyLh07fgU4chrucl+ua3NOhGeR13QYWTqKISIZ8EtZNL+tyP20Dtu0Ny0JN11w6BzxEqbpkC9NjtbLzHiqXazu3319THaN/O+J20/+StjDJSIuYR6yGixsJKRlBpPj/QCUTPZ+toxZphaj86l8myi7+PNtmN4shRMySrB0tlLt9FQ2qsOe5foPJHvWkcSzzNsDSyGOchLo2kEtsYfbtiGaqV/t9y2L0W76d6C35+PIULineYV7nzGoJw2jU2dqtOMLQxfmAmIpEEjPsOThPS++B9y8GwWdUdsTO5ttQXDbg/SCGCmS+US/UinRC38uHVMXvoh44qfTQvXqknw8emlcCWKgqIj1sK2JH4v3BIk+8Sc5rPDrEb0qbb9W2r4DJeX9/gM22e8qVNuTYN46qtwlygTXZjf6K5/AOLSilT+8TvddEv7NgOYaXaxnMpHHDY2EL5JkTppPTL4LHxHSJJAb1rq6566qtYpXlXk+d2NnXN9q9WQRPy1ykRLSUKZg2tpVHPso0A5wE5dcTy
 bw5j605/
 1j1Md4l8kvexcjjm3H5Fo8HCTAPJiwMOE2HvNCIoSeCoiAwniCPCjc9IUmrUaNfnNEKbelTJtsY4+kXBgPpcTnEcdOKwt5PslFkv5B++vArt5yjdotonmbd0XDyv5UI2+uGhdtH6r8AHoDzySGtUlgfjLPPEhFhMieKo4AQJF+9H5N+caTXRs9fOo5r14AlGyBPjUpAOgSpG9WmHd5wCj11JfU59Hvyz/LIVnMR2DNdBVPkOm96A3V1en/CTMYoffR1qM8LbSEmBE4IdT9VhkrgyGa+H3eHsS62U5NF6zy2Lz0BT13EMCGAgGyZMw3UBad4rPe4eR1ohvBmGPTIqLIp66DzUG4Wn0FSayBnnV+CIOGTGROB+J5NeXQdsJl1abnNnM3bhFmaAP48jBjH+m1lG+gSnpm4xOj/jGY8Xbo/xIOgJFrcGwqWJyhlvacDiEBevShIbxPtaIb6Sh5b20K6s0Hz0XhVRWQlIt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 14 Jul 2026 10:16:30 +0800 Song Hu <husong@kylinos.cn> wrote:

> A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made
> the "more than reservation", "more than cgroup limit", and "multiple
> cgroups" scenarios unreachable, so they never ran.
> 
> Remove it so the first two run again.

OK.

> The third,
> run_multiple_cgroup_test(), is separately broken -- a backslash
> line-continuation breaks its local declarations and its hugetlb
> reservation accounting does not charge as expected -- and has never run
> in CI; skip it explicitly with a comment until fixed.

That's reasonable.  This code was added by Mina six years ago.  But
he's still around so let's bug him with a cc ;)

> Also correct two
> `[[ "$method" == 2"" ]]` typos (harmless empty-string concatenation)
> to plain `2`.

OK.



From: Song Hu <husong@kylinos.cn>
Subject: selftests/mm: restore hidden hugetlb reservation scenarios
Date: Tue, 14 Jul 2026 10:16:30 +0800

A stray 'continue' in the main loop of charge_reserved_hugetlb.sh made the
"more than reservation", "more than cgroup limit", and "multiple cgroups"
scenarios unreachable, so they never ran.

Remove it so the first two run again.  The third,
run_multiple_cgroup_test(), is separately broken -- a backslash
line-continuation breaks its local declarations and its hugetlb
reservation accounting does not charge as expected -- and has never run in
CI; skip it explicitly with a comment until fixed.  Also correct two `[[
"$method" == 2"" ]]` typos (harmless empty-string concatenation) to plain
`2`.

Link: https://lore.kernel.org/20260714021630.1063823-1-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mina Almasry <almasrymina@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/charge_reserved_hugetlb.sh |   14 +++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh~selftests-mm-restore-hidden-hugetlb-reservation-scenarios
+++ a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -439,11 +439,11 @@ for populate in "" "-o"; do
         fi
 
         # Skip populated shmem tests. Doesn't seem to be supported.
-        if [[ "$method" == 2"" ]] && [[ "$populate" == "-o" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$populate" == "-o" ]]; then
           continue
         fi
 
-        if [[ "$method" == 2"" ]] && [[ "$reserve" == "-n" ]]; then
+        if [[ "$method" == 2 ]] && [[ "$reserve" == "-n" ]]; then
           continue
         fi
 
@@ -496,7 +496,6 @@ for populate in "" "-o"; do
         echo 'PASS'
 
         cleanup
-        continue
         echo
         echo
         echo
@@ -530,6 +529,15 @@ for populate in "" "-o"; do
 
         cleanup
 
+        # The "multiple cgroups" scenario (run_multiple_cgroup_test) is
+        # multiply broken and has never run in CI: a backslash
+        # line-continuation breaks its local declarations, it passes
+        # reservation sizes in bytes rather than pages (unlike
+        # run_test), and its assertions compare page counts to byte
+        # values. Skip it until properly rewritten; the two scenarios
+        # above are restored by this change.
+        continue
+
         echo
         echo
         echo
_


