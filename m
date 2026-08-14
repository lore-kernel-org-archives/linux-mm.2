Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4FAC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F336B06A6; Fri, 14 Aug 2026 08:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7573B6B06A7; Fri, 14 Aug 2026 08:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E416B06A8; Fri, 14 Aug 2026 08:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35A646B06A6
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:42:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC0991601B5
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:42:33 +0000 (UTC)
X-FDA: 85099838586.17.C9BDA19
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 08FB11C0008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:42:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nUuDRU+f;
	spf=pass (imf21.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786711352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1xE0YTQHVZ9zp3EgVOxgxpvZ7rS85ifpjNXTOUloYGM=;
	b=6dJgnmv/Ye1VDLDRFneyDvwIqOHDxkp+si6/wB7I6hvOWtGrZarXsYEX70KSxViHRv3MFN
	OOWdOO8au0DYMovVo5Ns2Q1ZFnzgZRgAR4PmojJ7mLED8IKW8Ms91DktMTAQYcwG3kbYbI
	Ejiztj3VaeuLC8seVpkYpj7N2wgXnQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786711352;
	b=hZhp4vGQpRJWldFuvs9ecWwq6eJwbXQ897X/tOYMoSze/im7LoGmshDAH37X+BRDtgTBbt
	9WMTMwzgaDHARZkQBNbTuBaQhVsfByQufQP8K381R4WuY4ov+Yw3TbzKH31VEHlFr+sFCw
	wEeuh+/EVwV+GYmz/pWlptftMlWUJpo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nUuDRU+f;
	spf=pass (imf21.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cacf197759so15015305ad.2
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 05:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786711351; x=1787316151; darn=kvack.org;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1xE0YTQHVZ9zp3EgVOxgxpvZ7rS85ifpjNXTOUloYGM=;
        b=nUuDRU+fxFpruc3v8NhTTvHX1he22VKhOa6e6tLDCVWc9EE3cqyh4DNjAYFEOWMXn8
         IpcmVKD0zefEMmox9emm+bUSqn9q37eFnjiTEzQIRz8ijkKFjoEEnk1C2JGiVUK6S9Pe
         8AjymhImfOH1rOUBTDrMILZ4M1juMDqDKgvuJPNycNhwGnA64QbVL/8dSEdUAIgUw1wC
         U6XitpEvfvtcN6ClTP/CLJaDBYNLoRUu2PjDJaQwifmN4g5WJ49aYcbK5OfMlWaY3+Iq
         8U1HibiWoUbp9AEBL21Fvmi1cnPmT6RgJCLiXDapFOAYa8cQXUAmU/0raYNAW9hy3E2C
         OH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786711351; x=1787316151;
        h=content-type:mime-version:user-agent:references:in-reply-to:subject
         :cc:to:from:message-id:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1xE0YTQHVZ9zp3EgVOxgxpvZ7rS85ifpjNXTOUloYGM=;
        b=pMj/4RPRJyytxFX4fwauES/2nuw93C3fJ47qASK7TrFUatWFz4saZ2P7CWya06mqVK
         /iyB6Qk3gUXhOHou1PoJUlohi1LGer9raNxUmOsdPL0E5ZqQv2NfMD+Nsaoz9d1H5F82
         4hSSb/MCyovQ12IHkEpJ7FtpTgCkuG2eXgnWJiHX3A2+DlAv/ePVrVdtCqSNpYT+Whra
         c2anF7PF2ITFCPMZnmTHk8DqcQ5/9xNuxvefAfZdSixGwsDafMh+shQH5ugdThRZ3wcm
         D+Ddw43q4Ib+RDzlpGVXRNafjldh2MCcRee9fgRhyF3vHhjy3GelMR6efD+WGOJJWePr
         ipJQ==
X-Gm-Message-State: AOJu0Yx9VBDv4NMukG3oG7bezUx+Uezdu9LKcD562W24YIhwzYB2TJlo
	IPv+B87POlO86OHXhcx+mG2aa+FN2ae7EIwtKX17RJ+1uHe+z87ODBOd
X-Gm-Gg: AR+sD12N0e8DLbgExfE7DynQhJA0RlaIyk1pCDxutKPsP400JGInrwxbXyV2VYpjNUk
	zyjxKNkhZIrz6mslP5+mNDTQLJBkZIz4yO/cVvxlLgufb2XdBJyWyxzWcPZe0lgb9T2rREI1TqW
	ZZ5CiZSoaZB8u3IhrFOPCJzbCBe8nLoFSuzlxV20M2rkwfXIcwmx6bJLoUcNZEp9px1FL4FZONx
	nOgw6ppQOgQ4gEHgCJSFuuBdE3tzKQ/ndobiPIh1zmQgsbL1JhBt+uD2Pqocv7VcFXqt56k2CJ0
	v/322V3uZfeLh5tIsGVFsQ2K9nlhdPVOmKVJR6GkGv3zMzNvcyvq2PAQXtP57y9i2qbxnH1Zky3
	SgESLVP37WCZ2rte9uomFRv91ny7GE1obZsB3mzI2pHGZ1K0ZVqGJRTJ1ojSx0Ii8RRHDCDj9KT
	RdU5Y2M1uGDdbqBSic0hQ0JLY9xBIIkVxY9DoF9vta8BDt8/v/Pjt6N3nUDuBkAwN9AdnvboBD+
	U30Qg6pHOso4B2hrw5UCPzib1PpLaChfhon20nZi2+P0AnALmkkP8nUCzQMEzV+2NvJOXqdKk/+
	g7BHqrz6jmRp/18RAgXeNg==
X-Received: by 2002:a17:903:98b:b0:2d3:14c6:2372 with SMTP id d9443c01a7336-2d3b080bf23mr71252825ad.1.1786711350587;
        Fri, 14 Aug 2026 05:42:30 -0700 (PDT)
Received: from mars.local.gmail.com (221x241x217x81.ap221.ftth.ucom.ne.jp. [221.241.217.81])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aeb27e40sm9037135ad.41.2026.08.14.05.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 05:42:30 -0700 (PDT)
Date: Fri, 14 Aug 2026 21:42:26 +0900
Message-ID: <m27blsrhzh.wl-thehajime@gmail.com>
From: Hajime Tazaki <thehajime@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-mm@kvack.org,
	geert@linux-m68k.org,
	daniel@thingy.jp,
	arnd@arndb.de,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to /dev/zero
In-Reply-To: <2026081355-remold-sterility-84f9@gregkh>
References: <20260813063401.1786548-1-thehajime@gmail.com>
	<20260813063401.1786548-4-thehajime@gmail.com>
	<2026081355-remold-sterility-84f9@gregkh>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/27.2 Mule/6.0
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: u8y1hbwouh3xktdmqxzs5ktt7xo5u44j
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08FB11C0008
X-HE-Tag: 1786711351-945063
X-HE-Meta: U2FsdGVkX1/onB4GJfHheYMV+LRJd5YyVKcvlKO78m4wI91/UM8M4a/ma0sWX//SPfQKcClF8wMxX9Ud9mDXw/nHfpzl5LAAVI+TAJm4YfxMRRvok8MdBq/KWfxNppjmOmGa+qLObVlSD6g0tUXSQ6AzlO5GHii4IwyTfsoyBnaBnKdodCtgqoZTat+hfUZ/1DIqUxLl0CyeeaN92pYpACwH9Tos0oQYzqSek2zX3gWyQOC2SqCKOOdUXvBIPc0gCD8Yt9gdVeju3X2wGTuiFij3xJpH2Gvj0n0EgV8fiZ+LvzZqhqzY8SPmM2HQcONonCtDKEg50y8zv7paql3z+4UbxkLYfgczqBo38e2K7ZFUU6yblSYZyHGn3kGqYy8Pw9qJQ85tc1B00U44SzekTMZl3UKaH8TYGXA4V1eNNN9SCkF5lu5F34KEGc5z4g9/mcyKsRWwBhhMqcOq/nWmxDlvyPv5w/5bPtMBThPT0HbZ5k2TunWbPtzchLzJkkmj0iaeGvMpwb9wKrSvBWt5b6UXbluza1LirWb16gwwBuVRK6fg5CkB+FGAGr+KJWoaKt0yx6PoZaYZ8ihlMP1i+r230gQY1MGcif1xYJJSnaPrsFCJjiSNRqOB44EGrkdKRh09bhM7cWYzWxybfnoi7W9XYC9X2XLt0K+glqUCX3ItRPrn3de/UrEGRb+juUXwMEAPIeUUSMa46YlhImVGVVi9QurqOCtV3fnRObcJoDNNsllN0o7JXRpQlGNc7FcAFbrUZh0Hw6RhFnkw+90EaguNg4AvNcjRoo+Qb1stkBP9zKoErbkkao2PS1jREjy8rGsqPA1ZdbgsLBCMiczEi1+6SnwjXBk1XBn/uCSuis6KmHPfqDmG67qHcQfl3Y90kMs0L0UGYE8Jjo9y6gmg0NjjCG68QbHFXkZz3VeSWbp2a+IF+lx+p64fmt3MhxtRmp/VKJGgkP1c9g2J/vA
 BskdaVDs
 aF58KCkIlgVdFkLj084s02xU75APij8Gypdzd4yOW9LjhoJlDh2jC5c7Q2fRqlBDCY1RUmW88nU/4jcQNn9J5xeeV1ikKsYfyaP+1KJeriU/GVdIUnYgSLIJZ18wJKjcPloirg1kfC9ar2PJvShFYqeX7OTvsr9+dJQWtZVy0TB/kVwikYzJ/qMV90gugvVyBtdhInLyZAlHdRRyCFUbwpE20GpVOfSaQLX/nwmj8niwSrcZzUKAbSMU3obC3hf+iqnyQRCSPdzEmy5WjJ37slULkaR/8iqbnCZYJLvRs33a3K+bYT3EdiWSHrwDVyBmknUTGSdioCb090OTxypOKoKGs87NAmukV91uH9i0TaQ2UDeEsx3EEEaIKcm5S5aDKEZu9JuXkrOfw55ZMRXakA8Jp+pT4OAuIi6PDEThboM22HwFNj4Iky3PKjFqnkDKH5nB4loIq33BArZOWcJx2QdKFQ2isrMJh8ti/Yx3D/QuyZCDYSbsWgpp4/AL8ZkgHhC4IZ5uT/VgNqhA9J0VD0UryCwx6lJNIDR0pHQuJKMR8w4Esoilve0+Ta+ezsXGpf41/gZQhsvbJtpZHWyQsDA0liOvOLUTNGBm2QKe8pLh45ZWWMD2k89O3Zx1zLSneEPDaFuGT6pozBq2dttC/mrlnV9osFJka54Y9cnYiPkC7ot/dCy2BeViPuL7eCI1gMfcQXorbTi3jtWTJqos2gtEX3dwXrwdh32aDAtDk7s6XR5Uf3KLceppNquOAR1mqQDoU4T1jwYUgTYZDdzMLH8AlXV8+JSctUfyRIb44+FhIIY2JnHQfJ+BeDkjBtrIQ8Iv/6JVJ3xBRPXA2bQIJbHb/deA/akc7Fphm/qNTkIo9w8wNwc43/Djglw2cB4E9EIiuq4A6niXsX3ZHK5yXWGDHEcApNyiYldAt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hello Greg,

thank you for your time to look at this patch.

On Thu, 13 Aug 2026 21:19:47 +0900,
Greg Kroah-Hartman wrote:
> 
> On Thu, Aug 13, 2026 at 03:33:58PM +0900, Hajime Tazaki wrote:
> > Upon a private file mapping request to /dev/zero, it calls
> > kernel_read() in do_mmap_private(), getting a failure with the message
> > like: "kernel reads not supported for file /dev/zero", which is because
> > zero_fops defined in drivers/char/mem.c has both .read and .read_iter
> > definitions.
> 
> Do you actually use a no-mmu system?

yes, and wish to use in future.

I'm going to make a long story short;

nommu kernel is originally for embedded devices but I wish to use for
virtualization.

I gave a talk to explain this motivation below (which you also had a
keynote remotely).  I'm not make a summary for this talk in this
email, but am happy to explain again if needed.

https://www.netdevconf.info/0x1A/sessions/talk/improving-debuggability-of-nommu-code-with-uml.html
https://speakerdeck.com/thehajime/nommu-uml-netdev-0x1a/

> > Even fixing this issue, the map request to /dev/zero works fine without
> > errors but the allocated vma isn't marked with anonymous because
> > mmap_zero_prepare() isn't called under nommu platform, resulting
> > vma_desc_set_anonymous() isn't called either.
> > 
> > This commit fixes those issues by:
> > 1) use vfs_iter_read() instead to avoid failure at kernel_read()
> > 2) calls .mmap_prepare on private mapping in do_mmap() so that required
> >    preparations are done even in private mapping.
> > 
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <liam@infradead.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Cc: linux-fsdevel@vger.kernel.org
> > Cc: linux-mm@kvack.org (open list:PAGE CACHE)
> > Fixes: 4d03e3cc5982 ("fs: don't allow kernel reads and writes without iter ops")
> 
> Given the age of this issue, I don't think anyone uses no-mmu systems
> anymore :(

I tend to agree; nommu systems does have less users than others.
but I believe this doesn't mean there are no users.

I should also explain more, but I found this issue via a Sashiko
review, which pointed me as a different comment, but when I tried to
reproduce that case pointed by the review, which is about the use of
check `vma->vm_file` v.s., `vma_is_anonymous(vma)`, I found that
/dev/zero is not able to map on nommu kernel.

https://sashiko.dev/#/patchset/20260710054648.924005-1-thehajime%40gmail.com
https://sashiko.dev/#/message/m2cxwvti7z.wl-thehajime%40gmail.com

The alternate path of open()=>read() of /dev/zero works fine as it
doesn't use kernel_read().


I also understand what you feel from the age of this issue (almost 6
years old), and that is exactly why I start implementing test cases in
kselftest, which is currently not able to run (even build) for nommu
platforms.  This series also includes the extension to kselftest
([4,5,6/6] patches are for that).


> > -	if (!file) {
> > +	/* private and file mapping will be marked anonymous later (do_mmap_private()).
> > +	 * and /dev/zero is marked by them at .mmap_prepare,
> > +	 * which should be _before_ this point.
> > +	 */
> 
> Wrong coding style for the comment, which is very typical of
> LLM-generated stuff.  Always rewrite the output of these tools to
> actually be sane.

this is my fault.

As I mentioned in the Assisted-by tag, I indeed used an AI review
system (which is cubic.dev), but I wrote this comment by my hand.

Because I thought this part is not easy to follow and felt that I need
additional explanation rather than just showing diff.

since checkpatch.pl doesn't complain this, I didn't carefully look at
the style of this comment block.

I will update this (as well as bunch of comments from Sashiko).

thanks,
-- Hajime

