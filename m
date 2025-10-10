Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93782CCD18A
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C946F8E0020; Fri, 10 Oct 2025 11:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44228E0003; Fri, 10 Oct 2025 11:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34498E0020; Fri, 10 Oct 2025 11:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9ADC48E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:11:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56E9F160323
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:11:00 +0000 (UTC)
X-FDA: 83982542280.13.646933F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F66C40013
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:10:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BoI9yJ5z;
	spf=pass (imf11.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760109058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FGCvzw6wkv09OYZ96nPfa02L2i4lW7mO0JFcPAot3lM=;
	b=N8Si/vkLTfEn8KTa9r48KFf8Oa6S7os62LDFGrdMaboMhomqeyFrGEYxWco8RXNZluqMkg
	gUgwQZtm3egKuKGZpBEbv3p05O/71g+dsdLLNd0m9xQ5ceYJ6zUdiWsPOoGxDhgV8VxW5J
	vyIxJx971Qlz8nTh6eXvaH62oN23X7I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760109058; a=rsa-sha256;
	cv=none;
	b=uWCDv21d8URzNjBRBaf/90UPBIudbGvWIopGagQG4bsBiYu1S58bcbqGC/Zs3Aj7dDflw4
	1ezm281OJa11zMS+PiaHRGYBKXwyN2MLsmOepCtkcqwv8JeU+e+Ca564C8VaYaQFRVBkqg
	ClAaoPGLeWMraIPxR+GeEsQmj4Bo+SE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BoI9yJ5z;
	spf=pass (imf11.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57D1243231;
	Fri, 10 Oct 2025 15:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFDFC4AF09;
	Fri, 10 Oct 2025 15:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760109057;
	bh=KEDbK+SNjMKMUuKWgcl44zDXGeQjspgRWfumF0EZ0sA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BoI9yJ5zMg+a2aiaAbFYUF0F4MKNSOR71aG2VTrbq/uTs252lAWstPRldgFYBotjZ
	 12mYLJLgRrVdvGHjaIHfgf/M63PVurTeeoxFLjZ03WDuH/cgjM+6pVXaj/IZ05HvSi
	 x8NocK9GBMlVXgZQIyMBQsnL0BTQIe4tAtzndRrb4XvBPXmCT/otdNRNTFvp1GtmaH
	 fzAoIRAj+aDkVGB1d2NhcVLJGCA03PbOi9IN6wrsTdpcYlaHL+Ml44bb8XHG3z/wtp
	 94J9aju6FhBWvySltROLZG87ge+9PGeWQQg7KMYvTOhIT3vdZig00EuPOdAYRywgMv
	 Rq/OjvBhwO5qQ==
Date: Fri, 10 Oct 2025 08:10:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Jakub Acs <acsjakub@amazon.de>, jhubbard@nvidia.com,
	akpm@linux-foundation.org, axelrasmussen@google.com,
	chengming.zhou@linux.dev, david@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, peterx@redhat.com,
	rust-for-linux@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH] mm: use enum for vm_flags
Message-ID: <20251010151056.GD6174@frogsfrogsfrogs>
References: <20251007162136.1885546-1-aliceryhl@google.com>
 <20251008125427.68735-1-acsjakub@amazon.de>
 <aOZj4Jeif1uYXAxZ@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aOZj4Jeif1uYXAxZ@google.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: h3rdeq1fxrmc5auiyrgjitdfs6g9ji6u
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F66C40013
X-HE-Tag: 1760109058-760072
X-HE-Meta: U2FsdGVkX19MWVXO9F2hGiIzd3dBTZCrz2/4CJNzhvdlyxIGuwj2IE7+jyz2VKgNER2c9TAAZuoWn+fLqiX3zzeaSAdMwUUg0xR4AI3YefPkgW9djVzTomrCUNdKKCliUvFR/Z3UGxTJ9U0aj4akn7jWMBw4zfvEEOWwiIgqtyLgMr66cyFvEmKM+fVFNlRgfAP9SLZFfKdW5CcCTMBdqs57CBIXrund+B++raOi68DH9bQQJ2nXdG61lZnVPW48ILZLlFTutjvl+pljsCc1i/I+BwSZNhyYfduw+rgezx7jJkB4xqvFlJfkWwHQO/A9OOPMl4fLyq0vxgILupRdO9VMJnivBqKpQCnkTohRBbGNq10oo4jyX1tOCmgJWMdvfoJdSCMY3Fmu2tQmSmoNrP43Ce7n5Q31q1tr6TFma9+yWiCblT7tyA/HNvCaL+zVmp21H3hKo3ivoL2Cm6oQARPegNVypDDiZXFo7SqyyDt5MZFq63166Dn0ZaUw+xgQxYxiVzOyp0/0wR56y6/kDt0s3RXCVx+PhzhIfqRNCbWsTNnOKrFxNdNoY6h9K7Mz92foQDAOOt70QDGAQ6Lpbyh4GvYn5dPZOarpTxUhfqZ+vCVYudsq8Xa+C7f7u30SMU9Kl6JvhPy7+LAZd3O0TPIl5T4RCvRsIb+GpPEaQeUngKk6LOhEC1E2beaLev7DAiSSxw7GyYSvt4Pi+Kh4NdE98skNL4k2ZUjCNfPOU0H1+0QFi1r9eB8NhT3zlsphoBrziL/1qJNDtf3qrQziJcJx7VHP7K4lNaxt/7XdGxf+QHZloQColrJw6yDNevhwYelvL2xk6WjEwjGWfBEhkcjpIK3P+2Br49HBloVqR+JqSpJ9NVi78Q5DsjwdKo0daDZEaNxOPkfkUiGvh1NVBXWTUE95HFuc8xRVDOTEL1MAF+3m9yKrMX5J9JOkG2Q8ByT0CW7WzpOpLieulwQ
 xc0KzFNh
 YLC1KxR8+k5vR4UR5d/QSBM9rRBIvws6teEoIDSaRTguCeduZgSVp8q8O9JSSS+YgmwBG7kyFMCYj79M9z/M5cC5uY+H25GgY3eoSugoH/oJHL85NnZ1uDrRWXhTgZniksiEGHOLFJmuISDNqi+SDQCqaPbdpL1IfnXoi8bR6CvR9ANEaa4Sq37JFPg9d69KMqysz1wMmMyDCRkK8V+h2tJQxAk2wizFg9q4CkDQAT3JHFEOmSvHt+XuwEC6qVqIonKy4cXhaf6ehl4LARreWhPefaNDg/F85yWPQetf06x+NvteLpZhCCiKFzXOlwUuZMUMLuctalT7/uNK1zYWGZzh77CzJsrjRe2T5dj8hadlrE1KQzoPvPLRiq0Wf6R5qAMybOOuTXJI8u5wa7fn79OB2Chs2rVWrgc+akqO2Qtu/+62qKIYMSJYjhNLua9RGysCJSBV8D6gSYlouvZCP6GR4hC9063spGUU8dYNwuI27812DZYrbsIV/Fk/2zD+BjK0nZWDcHykGmgHV3sTf0M89VoHg1Naa6HCpZwxX8gr4kAg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 01:15:12PM +0000, Alice Ryhl wrote:
> On Wed, Oct 08, 2025 at 12:54:27PM +0000, Jakub Acs wrote:
> > redefine VM_* flag constants with BIT()
> > 
> > Make VM_* flag constant definitions consistent - unify all to use BIT()
> > macro and define them within an enum.
> > 
> > The bindgen tool is better able to handle BIT(_) declarations when used
> > in an enum.
> > 
> > Also add enum definitions for tracepoints.
> > 
> > We have previously changed VM_MERGEABLE in a separate bugfix. This is a
> > follow-up to make all the VM_* flag constant definitions consistent, as
> > suggested by David in [1].
> > 
> > [1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/
> > 
> > Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: Xu Xin <xu.xin16@zte.com.cn>
> > Cc: Chengming Zhou <chengming.zhou@linux.dev>
> > Cc: Peter Xu <peterx@redhat.com>
> > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> > 
> > Hi Alice,
> > 
> > thanks for the patch, I squashed it in (should I add your signed-off-by
> > too?) and added the TRACE_DEFINE_ENUM calls pointed out by Derrick.
> 
> You could add this if you go with the enum approach:
> 
> Co-Developed-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> 
> > I have the following points to still address, though: 
> > 
> > - can the fact that we're not controlling the type of the values if
> >   using enum be a problem? (likely the indirect control we have through
> >   the highest value is good enough, but I'm not sure)
> 
> The compiler should pick the right integer type in this case.
> 
> > - where do TRACE_DEFINE_ENUM calls belong?
> >   I see them placed e.g. in include/trace/misc/nfs.h for nfs or
> >   arch/x86/kvm/mmu/mmutrace.h, but I don't see a corresponding file for
> >   mm.h - does this warrant creating a separate file for these
> >   definitions?
> > 
> > - with the need for TRACE_DEFINE_ENUM calls, do we still deem this
> >   to be a good trade-off? - isn't fixing all of these in
> >   rust/bindings/bindings_helper.h better?
> > 
> > @Derrick, can you point me to how to test for the issue you pointed out?
> 
> I'm not familiar with the TRACE_DEFINE_ENUM unfortunately.

rostedt already filled in the technical details, so I can supply an
example from code in XFS:

$ git grep -E '(XFS_REFC_DOMAIN_COW|XFS_REFC_DOMAIN_STRINGS)' fs/xfs/
fs/xfs/libxfs/xfs_refcount.c:118:               irec->rc_domain = XFS_REFC_DOMAIN_COW;
<snip>
fs/xfs/libxfs/xfs_types.h:164:  XFS_REFC_DOMAIN_COW,
fs/xfs/libxfs/xfs_types.h:167:#define XFS_REFC_DOMAIN_STRINGS \
fs/xfs/libxfs/xfs_types.h:169:  { XFS_REFC_DOMAIN_COW,          "cow" }
<snip>
fs/xfs/xfs_trace.h:1117:TRACE_DEFINE_ENUM(XFS_REFC_DOMAIN_COW);
fs/xfs/xfs_trace.h:3635:                  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),

XFS_REFC_DOMAIN_COW is part of an enumeration:

enum xfs_refc_domain {
	XFS_REFC_DOMAIN_SHARED = 0,
	XFS_REFC_DOMAIN_COW,
};

Which then has a string decoder macro defined for use in
__print_symbolic:

#define XFS_REFC_DOMAIN_STRINGS \
	{ XFS_REFC_DOMAIN_SHARED,	"shared" }, \
	{ XFS_REFC_DOMAIN_COW,		"cow" }

Note the TRACE_DEFINE_ENUM usage in the grep output.

Let's look at one of the tracepoints that uses XFS_REFC_DOMAIN_STRINGS.
The class is xfs_refcount_extent_class, so a relevant tracepoint is
xfs_refcount_get:

# cat /sys/kernel/tracing/events/xfs/xfs_refcount_get/format
name: xfs_refcount_get
ID: 1839
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;

        field:dev_t dev;        offset:8;       size:4; signed:0;
        field:enum xfs_group_type type; offset:12;      size:1; signed:0;
        field:xfs_agnumber_t agno;      offset:16;      size:4; signed:0;
        field:enum xfs_refc_domain domain;      offset:20;      size:4; signed:0;
        field:xfs_agblock_t startblock; offset:24;      size:4; signed:0;
        field:xfs_extlen_t blockcount;  offset:28;      size:4; signed:0;
        field:xfs_nlink_t refcount;     offset:32;      size:4; signed:0;

print fmt: "dev %d:%d %sno 0x%x dom %s gbno 0x%x fsbcount 0x%x refcount %u", ((unsigned int) ((REC->dev) >> 20)), ((unsigned int) ((REC->dev) & ((1U << 20) - 1))), __print_symbolic(REC->type, { 0, "ag" }, { 1, "rtg" }), REC->agno, __print_symbolic(REC->domain, { 0, "shared" }, { 1, "cow" }), REC->startblock, REC->blockcount, REC->refcount

Notice that the XFS_REFC_DOMAIN_* enumeration values have been
converted into their raw numeric form inside the __print_symbolic
construction so that they're ready for trace-cmd-report.

It's really helpful to have ftrace render bitfield and enumeration
"integers" into something human-readable, especially in filesystems
where there are a lot of those.

--D

> > +#ifndef CONFIG_MMU
> > +TRACE_DEFINE_ENUM(VM_MAYOVERLAY);
> > +#endif /* CONFIG_MMU */
> 
> Here I think you want:
> 
> #ifdef CONFIG_MMU
> TRACE_DEFINE_ENUM(VM_UFFD_MISSING);
> #else
> TRACE_DEFINE_ENUM(VM_MAYOVERLAY);
> #endif /* CONFIG_MMU */
> 
> > +TRACE_DEFINE_ENUM(VM_SOFTDIRTY);
> 
> Here I think you want:
> 
> #ifdef CONFIG_MEM_SOFT_DIRTY
> TRACE_DEFINE_ENUM(VM_SOFTDIRTY);
> #endif
> 
> Alice
> 

