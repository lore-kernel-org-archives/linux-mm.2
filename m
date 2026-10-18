Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E2ECCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 20:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98C66B009B; Sun, 18 Oct 2026 16:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49366B009D; Sun, 18 Oct 2026 16:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F336B009E; Sun, 18 Oct 2026 16:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4EC26B009B
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 16:08:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B744A1C3D6B
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 20:08:18 +0000 (UTC)
X-FDA: 85336833876.25.2E006D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1578D4000B
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 20:08:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYrw+Arw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792354097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlkddqdAROiRGtBl43BIyKikWb29hcRgIJuoZ3xSrwQ=;
	b=sdL9ypZGbHnsVOIK6nkJKyKsTyctquQWxFzVCIYWStjaXNR+huxk6cqtfIJ/bm/n3374+B
	rYXZBWXz40TqgzcGJBu4INKZOBsSd+6vTPyVN0OVoo3voOGyHlg/Sp9NFsmhghMfnfrgJf
	K0ANrm0MbG/EOSrjQhNBj4B8jdfvLFA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYrw+Arw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792354097;
	b=ceoE+5F5vizS9yFdN6n1+VN1ic1fv61OZHZndMhI0AgZ4HHcyV2VXq7Rykf3Hr/Mke+Jp2
	+LeX1kBZVddULPE0L3gklJ45QL0P7g9hsswBL3CHp/WrzKIYixnHCM4eFiWt8qsCLYG41z
	YOnHE9UjWiGSk17WDy9mqxIzmO7mVAU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3475460D9D;
	Sun, 18 Oct 2026 20:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1341F000C4;
	Sun, 18 Oct 2026 20:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792354095;
	bh=tlkddqdAROiRGtBl43BIyKikWb29hcRgIJuoZ3xSrwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYrw+Arwcvzq/EsCN6eKmsckq5E/DoFzU+yS4r/hk6yMv5RzrlgBRCINUKu191WX9
	 Pk9TErECOu1oWqPRpJuEIu3WhpzXv8PFDIPZvU5kcXG7PnzbP2Gp4kqsm3GLYOp3A9
	 Nr2eOw1vJJNMBsLcm7g2lTwHIflnKbSdE06yaazATy/2u8+fKSy/81zLLzNwcL1lJ1
	 y/YGY8B1x/81en3l0oE4wpi9/YSVkR5lXhOgiZILdIlyDfNGAbrRARmKhzdMMxt9aY
	 ZKJAMrW13oeQe5yIcYMOSsHLYM0X/p6k2epZwzTjXj9mEEI2bFiZ4n3eF5G+MwUUSW
	 8MnJJ0PydVy3Q==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Randy Dunlap" <rdunlap@infradead.org>,
	"Shuah Khan" <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Sun, 18 Oct 2026 13:08:07 -0700
Message-ID: <20261018200808.379209-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-176355@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1578D4000B
X-Stat-Signature: eisy66bf1rdacibgeb3bjadox5djp5fp
X-Rspam-User: 
X-HE-Tag: 1792354096-517357
X-HE-Meta: U2FsdGVkX18U1DeRW3KRklD5OE5Py7Apve8xZyv7P6kb4fBZ53EVqPKibuYA1ph2OR1RAs7fCwC8MBfiuD3c8UWoWo8Xl8DUnU6bYc61yNW/EkpBuMojqSC77vhsb0hhxsf/m8s23DuVu7L7xGgsfOXBy8E1uY1SsOxjx1tyt3sOvQWqmEXQhTEbR3YkTEmvTNhbOnLloaJQ8BGl7pKHYNf/OOS0/vUXopBAe+76BFbOKH87DPJF6/SrdtEOJLBh/Dr7KXFR7w468hqECPWOFGkjXq23sWQA0Axq4VsUUS8/2wPaWrINnZ7MLD4EpEGGJH9nwtjnc2u6P/u7YXzm9Oy6vN5+AceIhed2VErgqw+citDItU1e6mH3DIJlxeza8ypnYle9kwCFmFVnE7sQXs18OT57JnYQVYf5uOytxCVg2i82FWQAGQjoWZpnEutEd0bjnV3zLlSVysJbfhaSybAOB0PMlcx6NWeuasI1u9jN9EXYg0wKZxtuz4lPBoG5uP26B+yI/j74rKVJgdjj59WyBYmOJuH8fV17ScnEr4PjpSAyct65yeNxpgBwthHwFh11AL7ScjYCXdwk5UHD+SWlZhLZlT9Rh78gT70koc/wpAb2HInBcamt0rCXwnIfpMSq9AZBmREfHtP7B38bD11KNDbxsgcaGbweF0dIbTaXT/KxVZaR61UlSlyLY4WNVrwoPOLsz1VQF42DKFazddt8uZA9hKbMtb6ymcNs7WWcL9uhdEPxtZ7M3HHDTZcAOC68iQskPEHRljwxe5Co4Pw+lLIJYtiTDkn7v69zO4ri07UxaaSloHBNdkB1f1LwuOiJui3SGc0oQ0BXvyxJ6qjGZDVtA+BZFixJlvjQZQ+uNo3d+bf7AT0TVwwBP1VzezuYo7/BGkCFOoo0JH9/ggMXOHIO/LwJ9/m6+XCND2udyWSVFqtVtpj8paTZJAkIgKzD5cTFgDtIXT9rZN4
 31U7j6lO
 IkR5sqQwEM2IAXck9mwsJX1NqVUjKkfpZIj+AfQjCdZdWtPVWrN+0FVEh3yeeRs/fBSH478YN5HuJE7fVr5gNZb/C9ROe+hcCYYnlGZzYILWV4ZJ/FOh/GW9vc2zkDQIvoi9DBuPKQXnopwNeHpdY/uuVUpFFDJlyPSqJ1cijoAip0oVABvkx/ucpvgJGXwE/C+KMWHKBAyAHe/W5kIaHuQdZEhuccGaLyT6CPO35YxPXSTEkDuqpe4kwvo7pIzKBIXXtbd7zRoYjDw/fIWSLViFO8pWy05asw2xm65FSir7G0lhupdNoboFeJY9y7jSBMMJYHqn+HWSipUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Oct 2026 19:58:01 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Medium] Docs/mm/damon: CPU cycle instruction sampling lacks target memory address
> --
> 
> commit a164f9ff38c8cd1963db3e0c7ea062dbc93135a3
> Author: SJ Park <sj@kernel.org>
> 
> Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
> 
> This patch documents the high-level design for DAMON's data attributes
> reporting infrastructure, including the damon_report_attrs() API and an
> example use case for per-CPU write-only monitoring using perf CPU cycles
> sampling.
> 
> > diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> > index a465e34bb1d9c..1e699e3f8a496 100644
> > --- a/Documentation/mm/damon/design.rst
> > +++ b/Documentation/mm/damon/design.rst
> > @@ -433,6 +433,50 @@ monitoring.
> >  Refer to the :ref:`admin guide <damon_usage_sysfs_probes>` to know how users
> >  can use the mode.
> >  
> > +Data Attributes Reporting
> > +~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [ ... ]
> 
> > +For example, per-CPUs write-only monitoring can be configured using this
> > +infrastructure like below.
> > +
> > +The user sets a report buffer and enable CPU instruction sampling report for
> > +the buffer.  DAMON will enable perf event counter for CPU cycles sampling.  The
> > +sampling callback will save the sampling time CPU instruction and the id of the
> > +CPU that was executing it, into the DAMON report buffer, using
> > +damon_report_attrs().  DAMON can automatically adjust the perf event sampling
> > +frequency to minimize old report drops due to the buffer size limit.
> > +
> > +The user further sets a DAMON probe.  The probe hits for a given DAMON region
> > +if a store instruction for a memory in the region that was executed from a
> > +given CPUs group exists in the report buffer.  As a result, the probe hit
> > +counts represent relative frequency of writes from a given CPUs group to a
> > +given memory region.
> 
> [Severity: Medium]
> In the Data Attributes Reporting section of Documentation/mm/damon/design.rst,
> how can the DAMON probe determine whether a sampled store instruction targeted
> a given DAMON memory region if the callback only saves the CPU instruction and
> CPU ID from a generic CPU cycles counter?
> 
> A sampled instruction (or instruction pointer) only encodes the opcode and
> register operands, not the effective virtual or physical data address being
> written. Saving only the instruction and executing CPU ID via
> damon_report_attrs() does not appear to provide the target memory address
> needed to match against a DAMON region when the probe inspects the buffer.
> 
> Even if the perf overflow callback attempted to resolve the target data
> address at NMI time, generic CPU cycle counter interrupts
> (PERF_COUNT_HW_CPU_CYCLES) are non-precise on out-of-order CPUs and suffer
> from skid. At NMI time, regs->ip typically points to a subsequent instruction
> rather than the instruction that caused the overflow, and the register values
> in struct pt_regs may already have been modified.
> 
> Furthermore, without hardware data-address sampling features (such as Intel
> PEBS, AMD IBS, or Arm SPE populating perf_sample_data->addr or phys_addr,
> which are scoped for Milestone 3), resolving the effective address from a raw
> instruction would require fetching instruction bytes in NMI context, running
> an architecture-specific instruction decoder and address-calculation emulator,
> and translating virtual addresses to physical addresses for paddr monitoring.
> 
> How is the target memory address intended to be obtained and matched to DAMON
> regions in Milestone 2 with generic CPU cycle sampling?

Good question.  damon_report_attr() will save the register contents and pid
into report, too.  And the probe in kdamond context will decode the instruction
and get the memory address.  For physical address, it will also do the page
table walk of the process of the pid.

> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261017195747.89961-1-sj@kernel.org?part=1


Thanks,
SJ

