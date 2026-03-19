Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11A50109023F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A58F6B050C; Thu, 19 Mar 2026 11:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D116B050E; Thu, 19 Mar 2026 11:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693386B050F; Thu, 19 Mar 2026 11:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 533756B050C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:27:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08E088BA1C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:27:02 +0000 (UTC)
X-FDA: 84563190684.05.727F5CB
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id D39DA18000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:26:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=ASntnKBE;
	spf=pass (imf16.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773934020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H747lVbjk5GJRNLP9W0vcB2yh4cZMTEHKBCflRyF5H4=;
	b=VeYye70xlg04qg59+1G20W2ZBLTnY19v+rUZ4A2ARHJibkCcfa3RWGv7seDJv1bEaWMtD4
	JlAPNjm8M8V7gCZVv/ujqtP5CB5WQlTKleYIYvnWa3LyAsPVnW8US3YPhsiz6RA2ChaEsP
	XcYKTLYW1QI3hwV4W/LYd+NAoAtHDZ4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=ASntnKBE;
	spf=pass (imf16.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773934020; a=rsa-sha256;
	cv=pass;
	b=Hgg3j0UtYNyviKvvPJhZGlc+oAsCZVacdJLyEtdY89oc8wHcj3A06XuyqNnGjf9dlmEDlJ
	83stXkaRsBxixWEdFzHO5RlUZQsulfBTRXljDk2XSDhIc24/Qyl+eea5GHOYup8/JUHWfw
	Hc+KNpEKGJziDi8SnGEG5vbf4RhJtJA=
ARC-Seal: i=1; a=rsa-sha256; t=1773934007; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=eT+WFR5pU1i4ufVby1vxETD1vvWHvvh29i3vyWyfP3ZGb/QfufO2B7/mASglRF9syX/+h2CHqsAkXkDIRaWueqK1QLj2p/nsBfYkh+fWrdjVsNGqpDzBuX41QJFZj/A9o52JXc4x/ny8TxIaeK6lCw76qaeExyt+apsAPrBWIKA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773934007; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=H747lVbjk5GJRNLP9W0vcB2yh4cZMTEHKBCflRyF5H4=; 
	b=QAu6wwK9AbYC7ztOw2Lzjj5Vq1HFqVlhxbTfa27+j5mNebHCzDHRoByx8zConZaUD3Zj6PL5Hhu1fFXv7UaAxk/qSOcMDYypIUBk6EjR9kAech8UAIZ7nmNoXrnYJBsWAk2wjDDsV+QcASqw+IYCqsl29xQlVop5svnttqxExns=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773934007;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=H747lVbjk5GJRNLP9W0vcB2yh4cZMTEHKBCflRyF5H4=;
	b=ASntnKBEg90anYoDtbkHthqrcCChXCV7oHSvpiIvgxjDNU8PH8o4TaKfjyzkO/Ba
	Ko2lwiVkZxHmiDwQCzLgR8zxcUKh7mOE/m0xCAuIEA1r0PtPh6U+sCouXXx151UiBUE
	33rjUtS6/dkb40AD0fYn7A5wjmg+jN0nTbcL15DM=
Received: by mx.zoho.eu with SMTPS id 1773934004932632.9143077698317;
	Thu, 19 Mar 2026 16:26:44 +0100 (CET)
Date: Thu, 19 Mar 2026 15:26:41 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_mm/damon/core=3A_document_d?=
 =?US-ASCII?Q?amos=5Fcommit=5Fdests=28=29_failure_semantics?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260319152434.87003-1-sj@kernel.org>
References:  <20260319152434.87003-1-sj@kernel.org>
Message-ID: <490DD03E-C66A-40FD-8008-C846350252BF@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Stat-Signature: x3d8uwpkxsdtkiaiuj7ejs5x875py4zb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D39DA18000B
X-HE-Tag: 1773934019-9555
X-HE-Meta: U2FsdGVkX18JjWn7c/ruw+APGy04LMzOg4u0VztIGEMbvOuK9oiphH1t6Pat5izL4xmxGOI5vFGT19uxrn5DgDqDGqggY2TiTNgeBvmkEMDdndUL9RD7N6l/mbun/bfsiIfVGF8TRTWQmurRYDguv8wDLqHlp9u51dFMKoq2/RvcPij3AAvbTBjBPznJPsuf69UCJkq7o63f7E2W+265J6G0mh/yus1UZfcit5uTV3F48FaE6FpH+Db77Z4uZKY2vxCg5N5sAxKbNnanjYXU0WvDn4T2s/bvK+p8r9vYfrgPN4BzfDGXAdpNPiaggp6aKARks7kxxjVgYjOI+sd6r45TGaw+sPcWz67Zwm9ksguiNuQYkId14xf2ttAcywa71Tm9yDAjj5MMxAt+Mew4haUoD5HlYnCERRrm28J44t3CYSLrIRKwZInnBnfvdTG8WBX7HtCa9Q3MFtIF1Aa5/uiVFZDnjdU/UtSSXXU50/AGyDkon1ZKox5BUN1PzKOAYeNc6EVDitsANHDYqEFHZm3b/EtZyFyD616SjQNbwnHTr2r99TBJ/vQddyj+Ja4klcBC2HgDiOY9jVpIw/pglFNsuuZp+R8f9Xd+u8HRrM/QuaPhUDizRDqQseZJlmK161cP9Ofs8EA+zYHcz8v8qrj0v2/QxDWjcrDqXOF+Wl+Oc3iUIb/H7wbit/0KpDov3KIhswapu+WN/cwCrLKb4S4iTgD6YgFJDKKbCK7YQvncmZC5b7D1SPRm00WEQparGaBBZQGqP/98D6URT60dBSifocjDoc9cg8Tm6fU0ItEYRqDH/7H6pugT7pdyAbNclUDLgdjQcB8xZJupw2JFmMv9NiHUSMwDdYduqCU7bWRlgSCP6ocEJRQ3dR8pJ4ddhKbfs743g0Lf2MtG3xOLxdtmwqU0j6F5c9rM2Vm8yWZH7FLUue6af4GlBy4JahxZFMPlOf/9RwfhGuJ0huv
 IoI0Jqp0
 /S+8oRzb95VfSpLD+vQJVaTfg5pk1mJh9HjxME3APAb1+a5v/vWZKvwPcigOTVZE29qgwRQe3VCFD2eBtZlLLuCoI7CKiDdCdbTkrQHrBiuujqFmGyCpsZc9ISE6uucrAxpDDEpQbKxoYCUMhQOCCa6HG0mzz8WZYZnG7TYdTXq4UZqqIbBbk5cqhLSNKOJjvp+dpYW9zVlHN7kpeEWqhTBsiWw0KGvabMca7kE6lyhM3aGkRw7AJiXRGax1zct/ts3Iuft52/J3ql/pNDphaQbqOFNZFeQaxLx5JErTdzOnwpKOuMm9wEDTiLLGnB2H9qg9FJdxVu+TQYDWPBnYwwPCEbYO24eLBTR/Vll1DuU3l6copIYYZv+/UYVGoNtXdPF7Hat/A7iCcr9GuQK22uP7/0j4E5PKORyKMAzaojZL69yF3NKEf4hUhjzlKdYeNTbIkyqLLLWLuNSCx+aAGFEPb6sLq3vSgXzL9xl+GqCaKEttdlh9O+ymdL/ArgQnWLJQPnbEZoW0ptOfL/8YBzIayK8FQsbA7mlbT2vUrAmil5+Qy19BNvEKscQk5w8aoaYSgcNEIsF3ccKdx0/yNBYGkwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 19 March 2026 15:24:33 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Thu, 19 Mar 2026 07:31:14 -0700 SeongJae Park <sj@kernel=2Eorg> wrote:
>
>> Hello Josh,
>>=20
>> On Thu, 19 Mar 2026 07:13:32 +0000 Josh Law <objecting@objecting=2Eorg>=
 wrote:
>[=2E=2E=2E]=20
>> And Sashiko comment [2]=2E  TL; DR: Good finding=2E  We aware the issue=
 and working
>> on the fix=2E  Nonetheless, that's out of the scope of this patch=2E
>>=20
>> : Does leaving dst in a torn-down state cause a NULL pointer dereferenc=
e in
>> : the background kdamond thread?
>[=2E=2E=2E]
>> Nice catch=2E  We actually figured out [3] this issue from the discussi=
on on
>> Josh's previous patch that motivated this one=2E  And I'm working on it=
=2E
>
>I just posted the patch:
>https://lore=2Ekernel=2Eorg/20260319145218=2E86197-1-sj@kernel=2Eorg
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Hello, this morning i found some big bugs in sysfs=2Ec, ill post the patch=
e(s) soon

