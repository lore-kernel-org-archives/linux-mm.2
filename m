Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60280CD8C88
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 13:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748CE6B0088; Sun,  7 Jun 2026 09:43:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F98A6B008A; Sun,  7 Jun 2026 09:43:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8D46B008C; Sun,  7 Jun 2026 09:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4536B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 09:43:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E27F412070A
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:43:13 +0000 (UTC)
X-FDA: 84853233066.16.64514AB
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0747A100002
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 13:43:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wx+6FTkY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780839792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1i1ZZY3NH0NksSKwhex65P8mcwZtC9iSbou0/cGuXtQ=;
	b=Tdt8qopuXaPzzbHCTYqeFylad2sskW8Hi5aNSNJmtyCoSZvOyJtsQkcKRaC2gXc6PPR2Cc
	RctuB8gP/z4WhBPXDm3jZXRE+hYwdjG+KU6hEDItteUFReBf8//0/fzDFujWTGWugaWnDx
	aQ6cmVZzZhGFwy5b50Rle8WmRI6XhaA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Wx+6FTkY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780839792;
	b=Aoj/AChFoZN+2/yPMyBLBcYMQmFNsJfb+rFSFAsGq1r3sIMfZR+G3uZBp0gx0MA8k9bMY4
	/3td1EH9hmQ3ylMCCWbLxKyP3H12cWEzVait9QC4o09fKVeW2zwWcnOan9AYYco9l0EKFa
	csoWI2PakTQflXphd3PnOG6vf2FXM7g=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9157b949fc7so410965385a.3
        for <linux-mm@kvack.org>; Sun, 07 Jun 2026 06:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780839791; x=1781444591; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1i1ZZY3NH0NksSKwhex65P8mcwZtC9iSbou0/cGuXtQ=;
        b=Wx+6FTkYPHJHNFhqwez2o7WZ6CDnjenMjopAlbShb/QOXsbeY2dtHME9hTHRKj8cfs
         3gAvDI6SDJQ8rqUwXvy1H6VHfuPXFSbt6A5BTrq6TE7bupN0vZ7eEMLnu6tW+2mw2Re8
         r4BnrHv05myAlNZhnk3u5h6+IL7qJGgdMVTe4c50QMks8NuYYhf9bNDr4Db/9C7sVOLf
         r9L7sd1lOOIlN6+XGqJg+B0Xx9eR1rb0HvgF+h6YND2maepvD+lbGsVdf40zcQVTfBCF
         KSeobexqFmJEnECvrgUR9eUOxagvAUKDtzTx2SoaNLnnY0W8cktmQ+MwLwxIKyLqZqVo
         NyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780839791; x=1781444591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1i1ZZY3NH0NksSKwhex65P8mcwZtC9iSbou0/cGuXtQ=;
        b=Fc1p10Q93kuASw4Tyhk4lC/BFfgz5gcVubPbT18Eiz5tZ+mB/LxIDHRcyiRF8GGIH+
         2bNgLfug3u1yZrDnsmyRK9zq8VkIlno3X1lbpMiRl5ZNEPdoAOlxaFadZQKCVC01AIhT
         t1GNrSrShsc90tVdLnMmmDs0mfN9EL5cV4cMlg1hLQB30NLNzcxR/jr2YxQJSqK2NKcC
         2jcOd2bf96DV2rhehEzkmcS9/EsKta+WOVRAHApl+BtMM0ui7/KmRs74g8BZ1dJ/CAyI
         45gGVLQwymK6z9KaJZt9d3hBr5tUMqswfP6aUxKxqvPrmL2BK417lz1qyQa8ZfAeQp0q
         TjwA==
X-Forwarded-Encrypted: i=1; AFNElJ+MdcDBdJkSofXcCsRzrFSZlnR1lr3fGAJx7kZvGASiOqnZ9DGGhybhcPpKzfOv6gaDJ0FiQMye7A==@kvack.org
X-Gm-Message-State: AOJu0YzMgVSWX7vrRJXfA2Fw+X9+2qf3M+AdTxtNiJGAxaLpUQ2PadCv
	DjD9sKruMgZIpYIq2xDrTGfokJksie0BhwRbLo6rSvrt5KPPDDVp/Zydhzwei1q55DU=
X-Gm-Gg: Acq92OG5x+rWi1HPCoNxt8KzVHauydQABZ6wCfh84GQf76amOfKJJ9GcUbmnja4j52L
	o381/hN3ahgGf7WXxdmkADL47emgaaMzzGxi7fqdOVUd4V3f1FsL2PJCT79PvwPTu6s8wUxmzxt
	e6FcVFzkjQNPMV3liQQIpNjOj6tJN1Ohn8sWtQ/07MO1JE25FvCKOCix+jZXe0qFlhfTs4N9TnS
	ptVf26armiue9mO226biHBibD6o5qAOBtW1L0HPMjR5buQMvDwTeNQNzjDLsxlnlB4ctN4rBBi6
	W7kx0R6wlpEEEBruM4uOz6dnaEwel81aoTYSFm4ca6O1P0D7MaaWZkLNyyB+YoDQq9WO0Epu5T3
	cujhjSIHrJXRjtNyaUE5RH3i+r39jbgc2CRTdT587pEvhzbQYMMYmLygbbvRpJHF27wOIotBVrC
	CnlDQ7IfRwpN4r60EN5Duac6hZtpSBAyzjajR7HBDwYU5MrPCbEmBwrg387jfNbg==
X-Received: by 2002:a05:620a:2990:b0:915:6e30:5bdf with SMTP id af79cd13be357-915a9cad06cmr1888383385a.19.1780839790896;
        Sun, 07 Jun 2026 06:43:10 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a40d566sm1415396285a.47.2026.06.07.06.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 06:43:10 -0700 (PDT)
Date: Sun, 7 Jun 2026 13:43:09 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org, jasonmiu@google.com, 
	linux-kernel@vger.kernel.org, corbet@lwn.net, ran.xiaokai@zte.com.cn, 
	kexec@lists.infradead.org, pratyush@kernel.org, graf@amazon.com
Subject: Re: [RFC v1 0/9] kho: granular compatibility and header decoupling
Message-ID: <aiVp5RlbWRz5VnPB@plex>
References: <20260605033235.717351-1-pasha.tatashin@soleen.com>
 <178083348872.1648214.17778188633648887952.b4-review@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178083348872.1648214.17778188633648887952.b4-review@b4>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p77nec34j9anhjqozeenjhgpg1zqbj4i
X-Rspamd-Queue-Id: 0747A100002
X-HE-Tag: 1780839791-962974
X-HE-Meta: U2FsdGVkX19dEhuQXV+S7UuGUXHQg6ZZsUNp1x+KL+v4YsDSi9mkOESwK+IgB9hu480jaRGylCV2GBIOTYismw+HTGkKcu78MRj1qqV8+sTAZYz/6XEciEMT8ndTeB99SeZ4wJ1YZUwP6I9Er3zSDR5QD9PfoZjOAG8mF1ETDF47QOH27bht+SBzHjuVXOVnvPV0CwYGorYXD2ZzxWfIk6XXuBwu/pTcvtWwFMYnTo0LX7rYA/HC+YsLhlxfYzs44fybr2EKXrzWsolTUXUGQH5OBwKfxfeJIyijdjU71soUgqnsqqHPWIRfbu9zD54ept+MOhRp5yHnDdWyHZyTv1jbY2Rd00G/RUERATIcyVxpatnruhtf7o0FBvn2BoJLoPu3xQ6eVq2V4P9wC/cFMzgYuklkmDDUnVEW18He3Q5FPlWYWuXk91bf4S/1Q9F6tOhzhoUBqxZTtGquIViyoeDum5Z6a+LqehHTK1yLTDJY5YJPJcJ+tv3rzpTUPh6BMdnnChF1fG5ODm1OAUYmBPQMimrq/8A5N/ZXPD3BiZrq3Jnj9AUgm2cBr/rK/h5ndtC4GV/pxKVNK3cXRyZ36G8Q5bxFrnuiyw8Fn613/QQqeNb/FBz6PToIPV3Tu9dfIX3eRwOdVvv6TE4/j0/2p3b0cbRi82yCsynSgbppPINdCs+39Jv9D63h8dY0YupV8qPv16cUDoKyE0IzY1YvDQ0/TEM4DxJb9DF0YX6RhO9EuaCm28OrcZb8gYhwjWj1Ft1bdMjq2/CC7afTX894hMIGJy6N2msP8rt55hq8uScqhJeavpyPNi9HIqhFudR2dxlAVveDHxLvcSSW3ect1XrcxcuSN4GMYe7E/O17CjJMEiy01s3fuq/Vij0SGBtjNBeEdhzC8+LzAWnzYNKYMEwdrFzIzc/RqBpQf/OlpjyiXxvdFT8Bf+V/4QAXiWOrrl1RQxaCRpfRfy6+DKh
 rRkZP2z9
 bLSW+o8BenmqqhQap8oQ+V3qoxS8OpKDy5PttJ1H3wjSqVOM5fYeeJrVrXrSXm7LWatxvtv7xQii+Nd2FSRTYV1rsTJL8qsgXW1IntK8mj62nEqSpKSa0syzM35s01T9nALbDZYXksN5MrecTAvLq98mpEFynO5NaDXDZI4k5w19nBmUhfIvv1TkbkeJEyiJo+Gm4KUtHbePo1Ca+GyFqfltMr8U8bFjj6TUusblKu4oJImE+G6oGR6gd4Wisu3uAyV27SEhGBE7kSDgTt1B5Pen8uARslI92fI0idFaGnjU1/4EbRAWp9RYp4Wi19+0XlHT8U8iUcdvcI0hfZlRJ895RKkhGm8PPefLENB9oVOY4Dq3EkWbfhPU1kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06-07 14:58, Mike Rapoport wrote:
> On Fri, 05 Jun 2026 03:32:26 +0000, Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> 
> Hi,
> 
> > [...]
> > data structure. Keeping all of this within the same `kexec_handover.c`
> > file, and also under the same global version, is no longer sustainable.
> > 
> > To address this, this series:
> > 1. Refactors and reorganizes the code by splitting out radix tree
> >    and vmalloc into separate files.
> 
> I'd keep vmalloc where it is, it's more of a memory preservation primitive
> rather than a data structure of it's own. The data structure it uses is an
> implementation detail.

kho vmalloc is absolutely a data structure. KHO core only provides the
basic handover mechanism (FDT nodes, physical memory ranges). vmalloc
is a structured representation on top of KHO, and should provide its own
versioned ABI.

If we change any of the vmalloc serialized structures (like kho_vmalloc,
kho_vmalloc_chunk, or kho_vmalloc_hdr), then vmalloc won't work and
compatibility will break.

Core KHO does not need vmalloc; nothing in kexec_handover.c uses it.

Instead, vmalloc has external customers:
- memfd (uses it to preserve serialized folio metadata)
- KHO test suite in lib/test_kho.c (uses it to preserve physical address arrays)

> Let's minimize the churn where possible for the sake of git blame and
> backports.

It is much better to do the right cleanups now while KHO is young. Once more
subsystems are added, this refactoring will be twice as hard. Modularizing the
code now guarantees a simpler, safer, and scalable design. Placing each data
structure in its own file gives us code that is easier to maintain, review, and
less prone to bugs.

> > 2. Moves and organizes internal and ABI headers into structured
> >    directories under include/linux/kho/ and include/linux/kho/abi/.
> >    Instead of cluttering include/linux/ with prefix-styled headers like
> >    kho_block.h or kho_radix_tree.h, we use the already existing
> >    include/linux/kho/ directory (e.g., kho/block.h and
> >    kho/radix_tree.h).
> 
> This looks to me like unnecessary churn.
> These all are bundled with KHO anyway, there is no header dependencies
> that justify small headers for each two functions and netiher
> linux/kexec_handover.h nor linux/kho/abi/kexec_handover.h are that long
> to start splitting them.

External users only need to include the headers they actually use. For
example, LUO shouldn't have to pull vmalloc or radix tree KHO
declarations, and memfd does not need block.

From a maintenance point of view, it is much easier to catch ABI
changes when the file with the appropriate version has been changed,
and most likely the version of that file should be updated. If a single
header contains compatibility versions for several different data
structures, it is easier to miss the correct version update.

Since we are splitting the source files (like kho_radix.c and
kho_vmalloc.c), the headers should logically follow the same
modularity.

> 
> > 3. Introduces a standard set of compatibility helpers in
> >    kho/abi/compat.h.
> > 4. Decouples the compatibility strings of individual KHO subsystems
> >    (radix tree, vmalloc, and block) from the global KHO version.
> >    This enables independent, granular compatibility versioning.
> 
> I agree that we should decouple versioning of these components from the
> global KHO versioning.
> Can't say I agree with the way you propose to do it.
> 
> I don't like that each user of a KHO component should include that
> component version in its own version string (or whatever it may become
> later).
> 
> It requires ABI headers update each time a user decides to add a new
> data structure and worse when there is a change to that data structure.
> It creates coupling of the data structure user with its particular
> version and just looks ugly IMHO.

It is actually the opposite.

If a user adds a new data structure, that new data structure will have
its own compatibility version. Instead of the current approach where
the global version string needs to be updated, only the new version
string would be added.

Also, if someone updates their code to use the new data structure, their
compatibility string is going to be updated anyway, as part of using
the data structure requires including the dependency in their
compatibility.


> Suppose we added new fields to vmalloc, but made the implementation of
> restore to be able to cope with both old and new versions. 
> How this would be reflected in memfd versioning?
> We'll add both versions of vmalloc to memfd version? And all other vmalloc
> users?

Backward compatibility is not in scope at the moment, but we can make
the version parsing more granular in the future.

Instead of a simple strncmp(), we can introduce a standard callback
interface for data structures. Each data structure implementation would
implement this interface, and we would pass the parsed version string
to the data-structure-specific version check.

> Or, say, we add support to kmalloc() and use it in kho_block.
> Then we'd have to add kmalloc() versioning to all kho_block users, right?

I was thinking about this. Since we don't have examples of data
structures depending on each other right now, I simply made sure
there are no duplicates in the compatibility strings.

If data structures have interdependencies in the future, we can easily
remove this uniqueness restriction. The users of block will still
include the block compatibility string (which automatically includes
kmalloc), and if user also depends on kmalloc, they will include it
as well.

> I think the versioning of each component should be handled by ->restore()
> of that component. If it sees an incompatible version in the preserved
> data, it returns an error. The versions can be stored e.g. in the base KHO
> fdt.

Hm, I think, checking compatibility inside ->restore() of each component may be
too late in the boot sequence.

By checking the composite compatibility strings upfront (before invoking
the actual restore/retrieve callbacks), we can guarantee that the entire
state configuration is fully compatible. If any mismatch is found, we
can cleanly abort the live update.

Additionally, keeping the versioning managed via composite strings on the
serialized data and registered handlers keeps the KHO core completely
decoupled from individual component ABIs, avoiding the need to bloat the
base KHO FDT with subsystem-specific versions.

> > 5. Adds a KUnit test suite to verify that the composite compatibility
> >    strings of different subsystems remain unique and sorted in
> >    alphabetical order, guaranteeing a consistent and predictable
> >    representation across configurations.
> 
> Without "composite compatibility strings" we don't need to care about
> them "remaining unique and sorted in alphabetical order".

These are not strict runtime requirements; they are simply there to enforce
code cleanliness and prevent human errors like accidental duplicates or
mismatched orders.

Even with a simple strncmp(), it works perfectly fine as long as the
strings match exactly. If the uniqueness or sorting constraints are too
strict, they can easily be removed.

In the future, we can transition to a more sophisticated version checker
that parses the composite string into individual subsystem version tokens
and verifies them one-by-one, rather than relying on a strict literal
strcmp() string comparison.

> The need for this test alone is already a red flag ;-)

I will remove test ;-)

