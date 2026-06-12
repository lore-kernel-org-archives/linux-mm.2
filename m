Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D8ECD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 16:58:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEF16B0095; Fri, 12 Jun 2026 12:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178B36B0096; Fri, 12 Jun 2026 12:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067926B0099; Fri, 12 Jun 2026 12:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E97096B0095
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:58:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BE351C0E3A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:58:20 +0000 (UTC)
X-FDA: 84871868760.12.BD9F62E
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7D099180002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 16:58:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="d4/aM5/r";
	spf=pass (imf24.hostedemail.com: domain of 3qDosagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3qDosagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781283498;
	b=BumwlWG1twCuw3d/FtODz8DVxoosXFCoNIRRXthIHtJHMClefi2SSet10x5aSFE8oiDMgg
	4onzdm2EuZl39wTdJJ6Bqq8dhJEUKBvMaVWv1hwtkyls339IQGVMd59EyRETWHfPxw93nz
	JlqZN5zByMuapgr+ONQkOU8JaoUzCfc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="d4/aM5/r";
	spf=pass (imf24.hostedemail.com: domain of 3qDosagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3qDosagkKCCcWDUXQVDKXJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781283498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDX0q8phcP9mhqW5SB+yIq6adpUV680tO/gbdFTi4bg=;
	b=JPWhfoT6VrFGWRB+vBEYGlC+2v4TRUq4sIIkOAUWTLoK1Bcjo+qJsKrY0HnBH875Le7OqR
	f4OJ3tF8SbKR7YyqPzmR5tQAy6cTyp9MD/CEqfdllTlP40CM756n8jlfqyHtrZboFj/iry
	TpLdmolGYEldTpkrN4P/rAjZbiS9sf0=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6915567d194so963182a12.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781283497; x=1781888297; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pDX0q8phcP9mhqW5SB+yIq6adpUV680tO/gbdFTi4bg=;
        b=d4/aM5/rAhELmKYU7ctptp6BEd59AEjpZT8R9FmIP+MBobHyFV5UHgWIBE/eNvOim/
         vofCXnsIqLlQ433GQDq8rqaFM99PRQNJJ3avQ2gxfSNDvcoHKRFCIAv+NVYaRfj06fyn
         V+zLooVrxmMJefNwbFIh6/Y5F1yQD8gbM9OxnSAVcqvDKrmgWxehWCoU2mQcbfG3VNsZ
         bBbZzOui1yWc5kWgLxuIk2eghYw5snO2HgOn2IozFQKqhGspEAGZrDNdeTiAfW4NIhGo
         k8LX6WiTguJayW8zOBgO7dV6BxYR4q6JFY26lt/JRdCnNQRVF+U3JNfm+O4ZPsOcARZ/
         5ODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781283497; x=1781888297;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDX0q8phcP9mhqW5SB+yIq6adpUV680tO/gbdFTi4bg=;
        b=e3rYfMkrG5wlAXmlLKu6bpbVWWbMHvxf4jbuCAw5yY3pcuf0ALxV5X0cg5WMs/9sEu
         f0/6hX2PNj3A9LINIw7F+jmBqlvBsg1qq+BgeHDFp6dzt+IpJjywNsnB9qD3iNSjbGtT
         q7ryytLrr5M8Vpnb4nEJx3OmaTLL+YpIv0FZrNNrD9OJBq/3d1IGPpDXUYDU/i8JRr0n
         bB/WR7tzo/q5XWSeuarHVOp/1RBNf9DKMcCymEc9DJ5FKTBmj4RWLJmaYXJcz0AAFGHs
         jtgz3QfB6vIGmmz/+rzMFO7zC5X3dFucO9iYrnRu0v93T1uAv2Gh5IWdOJfdQCzMzLjr
         96Zw==
X-Forwarded-Encrypted: i=1; AFNElJ+KqOIwNhhfTkYOQSTM8ukFN/aEOFsdSJp9feLezFFvJ3nJThpmnXhC2iJJ/zjm4NCenu9IywvmZw==@kvack.org
X-Gm-Message-State: AOJu0Yw8y4h3MBvpF1gsEIbXiEQwyX+rsyzwUepG3AHWH3UCXYMfotj+
	J/b7gLqm/rolW5+yiqTAem4lEpkgedKpLFw9wPqCMTI2F/N/p4JuENny19NNwhBdY7MOwXvD1Nc
	9M5/tUSo2OA7UnA2FuQ==
X-Received: from edi8-n1.prod.google.com ([2002:a05:6402:3048:10b0:691:a21a:fec0])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5405:b0:68b:f026:f381 with SMTP id 4fb4d7f45d1cf-693787ed75bmr1752058a12.8.1781283496255;
 Fri, 12 Jun 2026 09:58:16 -0700 (PDT)
Date: Fri, 12 Jun 2026 16:58:15 +0000
In-Reply-To: <aiuu1QzAk_pkQKNV@kernel.org>
Mime-Version: 1.0
References: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
 <aiqso7rkpX6oMer7@kernel.org> <2vxzmrx1qjuf.fsf@kernel.org>
 <airGIioUmTtU9326@kernel.org> <air5ho0LOIEKVzRG@plex> <aiuu1QzAk_pkQKNV@kernel.org>
Message-ID: <9huzqzmbelw8.fsf@tarunix.c.googlers.com>
Subject: Re: [PATCH] mm/memfd_luo: validate serialized_data before conversion
From: tarunsahu@google.com
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7D099180002
X-Stat-Signature: y1pf1kwmupm6ip8fpmy8g5z1razg5sj9
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781283498-912333
X-HE-Meta: U2FsdGVkX19Se6lVDTHUL7m7gAOw0kMnL/gH+XEZ50OKy/HAup0ydYVLs9y2SbM+lPy5nR6PB0+o6dSJ5tMkZYOVLqkbSN+3ERrpF5Ulqo2esj8tWxzzfN3tIOC4WkXiqEcGWvU/c/YBU7EyMDUlGjHC8E9J/2Tn2Efx7PwUqKGdK+z7O+zxM90cwKcs9Uq1HO5VQ/CCx5t41TGRSaAyGLcIVBw7IXgSAsAp/MismSNzDbwyyKbEZ5Dmek5UVTdHQarJOmS0Ff51MIZIB+LJRjicHsHnc+ovXf4O8KqRjIDwJPVODGPQb9vVFq6/ZebeI9ApPGuie9EBFRItnuU9gifxvGo3tatOlNiHDDrI3xFW4cX5DSHzVbnOrkhZDZ2XgVTYc2DzjXcx/qrZoCZ0laVVuS6mB4GSk3+s104As6e3PqteZBo9oNib73YOYu8/xDQKD4eWz39oclt01MH1jSV26EWffk0lqH/eB2jjG1hcNrMg612ZfK1wM+e1kbot99h7jaFzwWruh2k8849FWx3p1aVk1sgPzznyecD8iliaZmb5umt4IYVIpF6S1mbphTUHg+Df2ghVrLxI6shysx0vUpxkeLn9fjGgs7ozDo/Ebzaiaj4VDDC+XqVf35PlDpmpuy1PnU512kLsaywUSSzX2Q2zDoj2ZBjyUPJNFg6ZyHIezZNdrqD5aQdKLw4u4SRGiWqLoYqAd3zWyePOPTUxCefpK/sLoMQB0+fCl3ZRIhVs7SZ1Ts60wn5XcT+SqtGMc+EKclhEm0Fzz394Z1qSGAYt1lNfKRCQD/SM5OsLhddnOiMehDU82K9mD2Ci1PZggeyZHd5z6RhFievykHa0qs9XTv8t7y+0Ez2oBy4CtyEVU7prKxDcbAkCUJYRFRLGY7gZEtonVmXHTAdKEm3bOjh3IzD2n771zHz3f53YcBoEsbmcKXswWvr9mvZLoHSBzukBUG71jlQ4xAb
 awMS7BhH
 p1wiCtOKv32btHlZK/UbAgvFg4XWdKFOPKpaqB+Aoc8Mg6rJq0zgr8A20aie51uf1uOOX9X83jfxliHK6KvpXEsX4PYDOHo8H+xMjO5wca0IrI39xcD5qiViA93Z1V8uWXAaI+siNBZwZ9SmIrxedYBngMQZ839OimwLVVp0Usb3vH/Gm5BYqSC7VrzIxe1H+8jDKZk7YGV4zGNYnjCLIeZxKkdCPW3wS/C1qLbNe+HAO/6Bq4yxKf0N7lN/Ddk/+QikmZOlezpYJ5uEK0ZSBlZyuPcz4jsdqZ+ZgOW3RyVjU7RNPr+uC4XxzqDWUsnDkrI8P9AVyyN6WbsQJPuWdl0op4vvyDxyRB0jCt1sYvUPVemEPr89xzC+zbjbPfkP18D88khWrPIVxOyK6/jRLj7HcHVpeOzoEWhegMP7RdjqvGCd0p2ECY91NnzTSOww2f8tjFXNUOPKZIfzLWOOuCqRcFD9oZCnwT3JgqDVVlsgRDwx/OxQJzcCdvDKXB9QNMnLM25UFXbMI6Wp7NET+yHNiLwolNcnfoUoZi13zTvUiLsUD5hUCDmQCnYcsacThx3e3rnwQacuRi4Z7b9WZFwCrh2goHKg4NWCOW7ncbp8/F7PDcmcJB20g5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mike Rapoport <rppt@kernel.org> writes:

> On Thu, Jun 11, 2026 at 06:11:13PM +0000, Pasha Tatashin wrote:
>> On 06-11 17:28, Mike Rapoport wrote:
>> > On Thu, Jun 11, 2026 at 03:37:12PM +0200, Pratyush Yadav wrote:
>> > > On Thu, Jun 11 2026, Mike Rapoport wrote:
>> > > 
>> > > > On Thu, Jun 11, 2026 at 10:30:03AM +0000, Tarun Sahu wrote:
>> > > >> In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
>> > > >> on args->serialized_data before checking if the physical address is valid.
>> > > >> Since physical address 0 does not map to virtual NULL (due to direct
>> > > >> mapping offsets), the subsequent check 'if (!ser)' was ineffective at
>> > > >> catching a missing serialized_data, leading to unsafe dereferences later.
>> > > >> 
>> > > >> Validate that args->serialized_data is non-zero before calling
>> > > >> phys_to_virt().
>> > > >> 
>> > > >> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
>> > > >> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
>> > > >> ---
>> > > >>  mm/memfd_luo.c | 10 ++++++----
>> > > >>  1 file changed, 6 insertions(+), 4 deletions(-)
>> > > >> 
>> > > >> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
>> > > >> index 59de210bee5f..10f3983b0060 100644
>> > > >> --- a/mm/memfd_luo.c
>> > > >> +++ b/mm/memfd_luo.c
>> > > >> @@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
>> > > >>  	if (args->retrieve_status)
>> > > >>  		return;
>> > > >>  
>> > > >> -	ser = phys_to_virt(args->serialized_data);
>> > > >> -	if (!ser)
>> > > >> +	if (!args->serialized_data)
>> > > >
>> > > > We really should make args->serialized_data a KHOSER_PTR
>> > > 
>> > > Hmm, that would also be a good idea. I suppose then it would be a better
>> > > to directly convert to using KHOSER_PTR() instead of this patch?
>> > 
>> > Makes sense.
>> 
>> I think we should systematically cover all  phys_to_virt  conversions 
>> and add  KOSHER_PTR() , instead of an ad-hoc approach of adding it as we 
>> go. So, let's take this patch and do a series where we properly convert 
>> everything and provide guidance for others to use going forward.
>
> It's too late for this patch for -rc1. So let's systematically convert all
> 4 or 5 direct phys_to_virt() conversions in the next cycle and be done with
> it.
>
> We have enough time to make it by -rc2.

I am already working on converitng them to use KHOSER_PTR. I have patch
ready, Will send soon after some testing.

~Tarun

>  
>> Pasha
>
> -- 
> Sincerely yours,
> Mike.

