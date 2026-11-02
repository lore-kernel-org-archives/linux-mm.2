Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5A7606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N6PSG5H8
Received: by kanga.kvack.org (Postfix)
	id 55CEF6B05BA; Mon,  2 Nov 2026 08:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533F76B05BB; Mon,  2 Nov 2026 08:58:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 470C66B05BC; Mon,  2 Nov 2026 08:58:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 250956B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:58:00 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2AAF12010B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:57:59 +0000 (UTC)
X-FDA: 85390332678.07.9C6E445
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 403F820002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:57:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6PSG5H8;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793627878;
	b=II6zvjFgwj5dtU85VC5guxVZiTe+tULCCaKwZwtf0eUtEcmtRJU2vnBrrpKhaYntAWD+Kd
	R+NeE0RUoqUEQy4Fe6c3+df2BUg+ymNhQbW/Vjl2EFPX7vZkTEnCXmSa2giIhE4Z8CWdl2
	Xv+xKAT4CE2wgNGEtTZQxNPQNTtyxlc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N6PSG5H8;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793627878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmrgtoxGAaP7jc9wRpc133vbyseqmlcWFNNve+yauqI=;
	b=amvtznpeltN0KLFgMoQdHOUlXm1rNkX0y3g80+QNyYB4S3VVbh3bDUnTQlRabIIyZW82XB
	a/bwMS0TQVqSTkpLCe2ki4+c7EMsIfcq2YTtc9F/65yZPgXFlkebczOYJ5q6K1RD7bNj2q
	nwFDNpi//MW+AY8kl6JZwavWLTUhbXI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABEB260220;
	Mon,  2 Nov 2026 13:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B001F00A1A;
	Mon,  2 Nov 2026 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793627877;
	bh=CmrgtoxGAaP7jc9wRpc133vbyseqmlcWFNNve+yauqI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=N6PSG5H8k2TyExe4ojxnbtU1l3+B92vzcVgG1TJZ3iqj1ooA1Z1rShwNOw6b8co/D
	 QIEKlpkqmib2nT6FsQRGDtXVAmskIbkCmN07Pj44Rvt/wyhHNAb/kLorvMuugt3hjw
	 SjQAlK1/aOI/4zCRRB2QwlMTlP+/vdJHUHQalKZYYS4uL3hSDUT3R1Wsr0/V2zpYbW
	 9HBSogUWxF76DEdF8b/d/j3l2jSfPmHXOwuv/m+NiyiBa8oTYlT4hF8xK94u6XEqux
	 8Mfj4aN+Cpt0a8wMhicaFkOZT5XK/XjX6kQQGmUDxRpWrKKPKtAhStf6tXKTSftBtc
	 q9BwK5UxDJUEQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Julia Lawall <julia.lawall@inria.fr>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Linux Memory Management List
 <linux-mm@kvack.org>,  "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
  Pratyush Yadav <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  oe-kbuild-all@lists.linux.de
Subject: Re: kernel/liveupdate/luo_file.c:558:5-13: ERROR: invalid reference
 to the index variable of the iterator on line 553 (fwd)
In-Reply-To: <a1b79e2b-e960-b6de-9139-fbbd13bfb2b3@inria.fr> (Julia Lawall's
	message of "Mon, 2 Nov 2026 00:20:41 +0100 (CET)")
References: <a1b79e2b-e960-b6de-9139-fbbd13bfb2b3@inria.fr>
Date: Mon, 02 Nov 2026 14:57:54 +0100
Message-ID: <2vxzecd3mj31.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: pxtyxjok9owmr954nzsmdwu789kdc9g8
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 403F820002
X-Rspam-User: 
X-HE-Tag: 1793627879-503047
X-HE-Meta: U2FsdGVkX1/A9J1SJ0gU4aMibSnwocXm7UuX/Cf8qrNaW5KCnf9Pgl8SO7/4H2Zm+mShZZk7uyFaUlOCQxniGaBUx07x+LIgy6/GA3UTSH0ikAtIkc0aOWTmNR5IbANN8ZO3pbnKY4se9daJMQJ31rfv9M/Bh8KST7VjsW1+VhhLIFaLPmzBbRlAMXD6n0lkz95bvS85GwkQgKZuz33vpKC3JqhHyoLwwkbTbpGewCc/YdfCa10NM526S1GkuAffWhRNeMjHcggAYz7YTR8FIdRRLNUrnQm/Kf5XbL8Xos4LsIg4m7TVgjqFUxxAUxA7pLcnDU9VtLi4tN40vdXPMDcW+vYlofphhDwoa+RZx/NOAiT+Puhl1aqD4omgdzSnxnec5EE5lqyrS1jqfO5sDyeZbNTZi69uR0GqQBrRhoazv3xhABQ7UwcFpZ/cCQ/YksI4mx0w01TH+eh3oKTDd69vp9/VjE4qFNkFSkC6FB2pM1JGFIJKYYPA+yitKt2mRNyRnCgQPmdCRWWxSW7/mha5yQgHvSxrRK+fPevfSambwYUBeT0OsRL30DiRE1xOx8O/i3TZHykB1YKwhhYwsVmDBwYTfrVFnBTJNw+De335ceBkG+1oS7OPCW8RHsyRbzWlCDOawEtqB5vKbZnn/HbBZrw78jjX7owPZzDamZk0Mr6yljh48DFUABO8I4lGn9bBnk4CBkcgw/Rm2xHJXz/AVojryjthdUEuJu8IdU3GxZSVrls8m48+UKSZNECM0yYoXAYfMEWV+4+oxOmFoc+jZ3vU0nFLB4ZI9Og70knKDINlsce0KV5KyA6Hj8AfReUxsm2bjtGEcaURMSNfbYfZ5N2RU/Vp94I1eC5ty0M7MnJjrMIoCXraJkkfB7m9EBVK2cfwsjECdwVvgQK9uFvfPFVXiAZa4rZJ6DQk7KoKqzArEwGTkFEeVPUvYMyEaxytUCMWaam3pjNY4xe
 qRuk2G4q
 kPUnN2WWVFo0mzH3m1mki4lo1zwCsDLp4Xwg+ezRIU3PxDwDID70KmdA6tNDgoXia0o3rf3CeKcP5kWXQrNmHIn30/iWifpZjuoGPa0kaQMf/ltJ57dOdk96e2H+be9HBPU98iEPjBf8CLjcYQxw/T6D0KvJk692ZtFjw5qBI6Jythg+vfHlk969hfA0paS5IA4qSAsc8C9GiSGRybC3nut43f9HyhCGQvlIMUrIdCR5sG62pswoEdVApyzK7uWXpUeKH13ecTOpx7jo/FukuPFTv4fN6S55FQPKS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Julia,

On Mon, Nov 02 2026, Julia Lawall wrote:

> luo_file may point to something random if the break in the
> list_for_each_entry is not taken.

This was fixed almost a year ago by b2135d1cb0e36 ("liveupdate:
luo_file: don't use invalid list iterator").

Perhaps check why the bot is looking at old commits?

[...]

-- 
Regards,
Pratyush Yadav

