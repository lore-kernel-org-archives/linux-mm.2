Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB6DC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 06:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2DC76B0005; Mon, 29 Jun 2026 02:34:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB81C6B0088; Mon, 29 Jun 2026 02:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81946B008A; Mon, 29 Jun 2026 02:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88CB96B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:34:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02B2F167F30
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:34:28 +0000 (UTC)
X-FDA: 84931986258.22.0D23EFE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3092820004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:34:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dzo/ArmH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782714867;
	b=snm27Q9oN8xE6xht5hNWHuAgNCY6lUbqX+mBXt6bXDFS1aVANDueiYPDc9wA8/OP5aM5uU
	VAhOJwDte6/HF3l5qYB3C6/h09zOaCDAdnJMGQdjhc3mwc798uGbmqGe0z9MwpmZ8clr/0
	QjcyogiiSvO1c0Fh5QRAY69XAhnseW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782714867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MX/z12MjLsT4Z3j+vUrtc7TX8SrTwi+qnU6VCGNvZ4I=;
	b=u+zbBNFbmQNeAJyHujEcgRZmQGjnhlqhmWaAZQOAUyngPbtkq5a3GJxYKYgUbeNQ4VllVC
	6a1diM+9aTJAlt4F9nKrk8q6dpvyqaVCt8IKvVXQsxs69f8PdOQlx583foogD4raGbHfkV
	06iaBc0o2tqFUpVBgagYP5Fl1jaEtss=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dzo/ArmH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 474F341479;
	Mon, 29 Jun 2026 06:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10DB1F000E9;
	Mon, 29 Jun 2026 06:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782714866;
	bh=MX/z12MjLsT4Z3j+vUrtc7TX8SrTwi+qnU6VCGNvZ4I=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=dzo/ArmHjFGkLvdI4HvRtW9CmRmS1Cxxw4LIKN59uTxf0ZQZr3H6II6CK9ZpUJY1m
	 P6ngm4Uw2vlQVqpQEmEzc/Y2x2oOItDtA/0+IGcXMfuCnPLWOnjsOCqwTjk7QvBbor
	 XkvbqrRtAaDK7HiJFCApXQptRfD2BSQn315JQxq5jRoWax3Kme9GhfXvyV8Qxqro0j
	 /XInjVUjb2riqc9D6tmafETcKjXDJ4opN2/pJApMF+KVmHDNVTGXTew0dCf6MpibTx
	 ix/zLH6Kzsglng+YZC8+lRNX5ppzcSjbgkUMdu8oeLCJaaXjqg0Jzs7FV96j692BG5
	 GgiQ75K2sS/pQ==
Message-ID: <2dc7bb76-085f-49b8-835f-7f93ee75a47a@kernel.org>
Date: Mon, 29 Jun 2026 08:34:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: Fix brackets
To: Manuel Ebner <manuelebner@mailbox.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 "open list:HMM - Heterogeneous Memory Management" <linux-mm@kvack.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260627093258.31265-2-manuelebner@mailbox.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260627093258.31265-2-manuelebner@mailbox.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3092820004
X-Rspam-User: 
X-Stat-Signature: s4nxu489n8oikurz1ebm8akrambu66de
X-HE-Tag: 1782714867-688557
X-HE-Meta: U2FsdGVkX1+qpSJ67MFsaMvG8x0coDWU9o2DG9Bo6hYotCOpb6ZLc7hI5EbH4itm2C1FosKgPeIa7hT5L41oDbPsjICPYkvtmL+W1sXB3+WEsDlO/ephgYLKiWh/yiSVAh4UKnD0YdWmgIEgDcsQAcMdrwLO0PTCK93cLSkqfVCnTaoKqUwNm/wRX1XrbsAXou14U3xKdow0wQujduInaPZ3W/YTWLyFtHoFCnnuW+LLgYzrCUzzBVPDtsnUVCB1T9f4GBkPftQwJ+zLoXqJ2EErNsfOoif7z6bOJb4SwdarUaQwS1ey3bk6dwWVa/ol5psHkmYM5GH+4SpN+0JeJKrWPwG1SyzM6/aln8y3NAcCEjSTHlRSL3mWW5N02OTSGiFtXWx77hu0f/w+fN9UYipsz9boh+WVT55hvzrMGcSn+7C0fLGJGw2wUzF4txgaPtazpExOWx7opABI6/7h3qo5eBcxVLfsyxlmOSHcRNxyNIaMp/kAAodlbrhhXfAIRB+iScFQAy3to2An/5GgPmGlMop31vIkYOJ3rch0q6qJp/FB2eTcAjJrkoVgOaGGQ250JmfT+/QNLA14aXBqMVkyfDZbsqsutI/PBKtHOcuMwE67S5WGCmriUXBbEBcVNl+3hBl74rOasiwDgWnqh648ITqxOFCjOH3hfPchSiCWCpGQVfhlfF50+JJWHu7M3t9iwizLgwFHV/rOO2QnwrSmEcpdtE8S1RjJyNNXiUBdCE0ysiq6tRJvq7STHfV7D8W4mqP6PQAUupQazuIv4CFYPZrFaYw8KhbXIy5J+pmKFiG9IxMoK5ndAnwlDD5szxFSFJJiO1W/bH9AYT6ZFcSc+Er7OtTL9kVdrX8G8Fe+ATbgi97YOnlRIq/LzF2fdQ3KI47qq6DUtQFh3fkOCH0+x/1TzAxgBW9e3Tz3nuYkALRcBAC5BDAT6vsYB7Zjkdsx1I/ErwBytqyKBa7
 kUZpG1M7
 2ZaP0iPWb82LXnRIdcObo+1riK+Hc04pmf69luaIPKvB7acGmNe8Yl4zSuDPk9Z64kk4RZXFetprFk4j8owBLovCp2YS0QFShrE7yvGDRQuWn+yWySZEi8HeGMUjaugvXEsxFyU4NjSUVr6KLCF9qp3xqcSaPadS1X+QzS31HcvHk9oYHKjh/KPqjEpUFGso7InvG9hVWZF5dcBz304nK/BWH9TCpI80zy+TJoipF3Vcsfcq1/o0rr6Tjw2Co2fdn7m56EWjD1ogjgRQ5Yu041hN2pKgSA3+t2Hui0O9kVqGA+kM1gEDyiUa7mebhnnvBJM0a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/27/26 11:32, Manuel Ebner wrote:
> Remove unnecessary ')' and missing '('.

Insert empty line here.

> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>
> ---
>  Documentation/mm/hmm.rst           | 4 ++--
>  Documentation/mm/process_addrs.rst | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
> index 7d61b7a8b65b..54c461e7a143 100644
> --- a/Documentation/mm/hmm.rst
> +++ b/Documentation/mm/hmm.rst
> @@ -191,7 +191,7 @@ like a CPU page fault. The usage pattern is::
>        mmap_read_unlock(mm);
>  
>        take_lock(driver->update);
> -      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
> +      if (mmu_interval_read_retry(&ni, range.notifier_seq)) {

Adding missing ")"

>            release_lock(driver->update);
>            goto again;
>        }
> @@ -316,7 +316,7 @@ between device driver specific code and shared common code:
>     system memory and device private memory.
>  
>     One of the first steps migrate_vma_setup() does is to invalidate other
> -   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
> +   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and

Removing unnecessary "("

>     ``mmu_notifier_invalidate_range_end()`` calls around the page table
>     walks to fill in the ``args->src`` array with PFNs to be migrated.
>     The ``invalidate_range_start()`` callback is passed a
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index 851680ead45f..b391502fbfd6 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!free_pgtables`.
>  
>  Since it is assumed that all such steps have been taken, page table entries are
>  cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
> -:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
> +:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).

Adding missing ")".

So your patch description is not quite correct? :)

-- 
Cheers,

David

