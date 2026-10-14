Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57AADCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A4F6B009E; Wed, 14 Oct 2026 09:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B1B6B009F; Wed, 14 Oct 2026 09:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6510E6B00A0; Wed, 14 Oct 2026 09:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 409EA6B009E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:20:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD22A804F6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:20:30 +0000 (UTC)
X-FDA: 85321291020.17.C713D6C
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf02.hostedemail.com (Postfix) with ESMTP id DBE408000E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:20:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YegQk/kl";
	spf=pass (imf02.hostedemail.com: domain of 3moHPagkKCDkoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3moHPagkKCDkoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791984028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4n9LUBp/94FrA7OEAIK6wGrf06ppdChh63JRq9nGxWk=;
	b=PXwdQMgER8sZ5TqYi27xVYllVuqJ6CpYgv7hVd/O6K22FsCC0Exrj6RSqqngCvdeaWlD/4
	mPm6uKY2dIW6mkpZ8KJAV9IY7EK2TorRcnJBNCurHpB09QKAhnlXPQKFaZPEP8fX9ahHDC
	hFbjw8tyPhra9OQuI/0YoSCXCvPSKiY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YegQk/kl";
	spf=pass (imf02.hostedemail.com: domain of 3moHPagkKCDkoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3moHPagkKCDkoVmpinVcpbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791984028;
	b=XBx2DdnEXB4XWxfX50IaBrgepGK16Firi6akH3eEwSz41UcB9R/qxZB/C+lN3K8iQlVICz
	r4TU9RiB/gwTI33+2NIZBd1n5B7/WxHfRPal0TQcR64BCfbJF0r6a1J0OleRT4JGb9xJx0
	gkwHmHe3dUa+KWCNW41bqdF2l8jth40=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b1abced3b4so995290a12.2
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791984027; x=1792588827; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4n9LUBp/94FrA7OEAIK6wGrf06ppdChh63JRq9nGxWk=;
        b=YegQk/klE3+BSmizB1X9trgnxh3Yht8bA3dky0awwooTlzjlq6cFQK5+riqF6FTm/i
         SQ1kVq0o/QfgxvAQxH01pnxKz3EGIVauxX0elCEiMAw2V9QfVCQzq7ltWYuhvW+i+6DF
         q8CLvDDtzf1xuE8jfOTif04fghrszSjOBNXKImKUeTtHKvNh+kl2cn7njSVz1johiPRv
         BT8PUzIqBtQtmzaCWiWA97hrijRDCFCPT4LBDF2v6eSX8EodnIzt6pVPsF9iXmUCT+cn
         5xrBfWMi+gYx4cKfhKK+8Qnm0u1czHNxr0/ysPxmPz3F1w3mahCvqxqZz7C0Q3g6KyxJ
         IF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791984027; x=1792588827;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4n9LUBp/94FrA7OEAIK6wGrf06ppdChh63JRq9nGxWk=;
        b=wrHo+JnBHJhWyTdzHmPx/vP6NjbQtCcXz8pc4ovFsBPZymCXJgKYWLeDYh0rwAMVFR
         c4T4U0G/qhjG4vrSr6dqJCWwLCOVejGYbD+SITrwICjIihNV3Y+bH6DEtlD55n8ZW4+F
         6zzbAlwOqBwFvVFTC2KM8Irzj9sENm6zq5Xiy3cTwnIkaWTvZaJisuN2XozSfSG16BCu
         II8NEJLKN0a1iXE/DPC4yEIiNptOzpUn5RdwrrdVwdpISqTGD/Mqo/DslvA0qXPQLcO3
         ffeSxwEdQphbvcxfTaAUWf9Z+35+rLckQWExG5uO7byEpLmTHsCPQp86zi+8Kt92s2yk
         f/7A==
X-Forwarded-Encrypted: i=1; AKwUvBwvZc5lkQY0hNZbkstcVzgtUJ01bJrhjEXS3d2mEYKnC0W2K+eA9yCV2jroKlHT3A6nWEsZ5FY8VA==@kvack.org
X-Gm-Message-State: AFq9FYIe/7jfV7VtFzMN+8jE1fD+jRJY/8dmbtMwnvf2waT3N/jHhFkf
	foqCfx0bVxZ9ZlICB75cPZ4UrhFvJWKsQswnnHSXbARjATkyYFDJOWERGZ5cnvWW+0xFMSqED+U
	OS/Rg4Qxi3GJ6009FWQ==
X-Received: from edcpr25.prod.google.com ([2002:a05:6402:c1d9:b0:6ae:21f4:c371])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:320c:b0:6b1:df89:7e11 with SMTP id 4fb4d7f45d1cf-6b1df899325mr5347239a12.36.1791984026642;
 Wed, 14 Oct 2026 06:20:26 -0700 (PDT)
Date: Wed, 14 Oct 2026 13:20:25 +0000
In-Reply-To: <2vxz7bjmkjeu.fsf@kernel.org>
Mime-Version: 1.0
References: <20260901180713.4185641-1-dmatlack@google.com> <2vxz7bjmkjeu.fsf@kernel.org>
Message-ID: <9huz7bjkmnae.fsf@tarunix.c.googlers.com>
Subject: Re: [RFC PATCH 0/5] liveupdate: LIVEUPDATE_SESSION_RETRIEVE_INTO_FD
From: tarunsahu@google.com
To: Pratyush Yadav <pratyush@kernel.org>, David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <shuah@kernel.org>, 
	Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBE408000E
X-Rspam-User: 
X-Stat-Signature: 1bob9izk559aefeu6zayja5ezfzqtwds
X-HE-Tag: 1791984028-839220
X-HE-Meta: U2FsdGVkX19vn4XhIn2ZFb1iexy6reLNHNlCbJNe3lJEPkseOro69dwd8jBlDhqkodLWoLeT+0sJxoPP4/AIH9ofGJXM9cMRsK1chh3/YyvZDhAhlif4zn3R0QcKVhV6saPoEpEL8XflkItMwYCUGVNj1LaxhhWtQNIOkZBpxcH5GhLo0nwO/HR19T7927x564D20QInXaKsdcdKSVxjVXm1uhyR8EiemiJdnGE+gmafLvWEsqoVT9cGUc/ZFZIghABWxoKu/+2LnqC2U0wS/QFtJHScG5GxdnX87G6aTjWwW3ozMeVOGb2ZlPbvFzighbQIFpY5nVrL7XS/Xsc54V0fu0MCdPKKTsxsJy2PoyAkm0YnEt0YGna9u6MX6onLt+vacYZ1ygU4o2PKeNdwqULQEpQZCeaHNzCv9Xc/DjpbY5F/YQq6Is1zkCSCEm54S7Ycsli5F3gwiMrAfpUOB8A4oz8ugo5Z32zk2hWy3iMrqNVt3ku05qs5NTEVTJ/Iqe5LsDAEvHVLySaDTWQUjV7e2snYXL2kphQuUqX0Jn7Ch7D+xXNh51bdIicaIspCLH+1ptpYniIiFl0aiFG+cC1cJkTtp3HPE6q9gtuxaD0c74IXbAvahaA2yDGQFvI8PEbdV5qzaeUp5fWY+sCPJ07UUX0FfQ4uJpt3S0nmcD9eCqpih5J8YFokoexO8giE7KiGlrn4oolcW6B6TzGQvcQbOlS9GLE5qwACXRUu0jTa8yMVF0qezrQYoxmVxvfUcCztKEEMIg0Uy9FJjBf0ZdJad2nT7ql/hpp4eempr6nzNedr7lIy3pLscX1pdw1qIm6ZuTkwX4xUiOkH8FzD3OmD1MsUGauy0t1E2eHvpRN/uDPZn4gKC6OdquV3Hg/lXd+JIdi7M5JPmW30PvOO2mcYMLqe2R5t9Fdgyn9Ywf+f9LLFzGOogo5WW+doEiMBTGaiTZeHcUBxRPsrkzr
 bNyHk0rh
 tg6Fj0LGBVnA5QbxOXew7z9qXeBY8OO/somfdyJoV7drMaZct5gOqkEFGGeN//he6U3blHLodI6fKvNuN4LYA9ZS6U3Mo+gQxXGp/6SCQlLkJGf7muMD3PPGwqqprt0ccu8O6GtEg7hBjskDnJuDf+PN7u8hapymVm3EQF9gsQUXb8vHM/sdePGUzVGwwpZ/ijyZ5BoqEb0G959CJys3P3vhY8+NfxMy6OvjQbqf9mlPWrX14FxGZk4x3/UZdlF/Z005Foy860A+lFOjI80w5IDzBP+VAD5ketxwdZ1jmPAKsBByp3uC1wKrYJoWow1ik1mDzLoqyOwxoXiCbLV38/2PL2rZPgm3XTgk9g3ixurPPRMZ7cReXmW4fQMU+IzkIAhtEp2sSbD0Mq3uwNibF+RQ23+Jb9uTtQg49QwzpPBW5a8vZg86Q62nvLw8PhOU7qrncJB4RIlt43RCkQmvZDbMeMrfCKDgfDbJ56/n5yGQIDII8uxmTpc8Bxa4ZdFre8FQWpGqYxi1Eeh8YhFB6X77ZcGwjTiw7d3RWSWmPmDqkuvcJFBf9xNK8lTlSFbegpiU964vwAXv2Q5EvMiaGTC0aOv6hgHpUSvNFqR5NEOyDufyTvfc/M/p9Yr8czAmOEArz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pratyush Yadav <pratyush@kernel.org> writes:

> Hi,
>
> On Tue, Sep 01 2026, David Matlack wrote:
>
>> This series adds support for LIVEUPDATE_SESSION_RETRIEVE_INTO_FD, a new
>> UAPI to enable preserved files to be restored into a userspace-provided
>> file instead of a kernel-allocated file, and uses this to support
>> preserving tmpfs files in-place without any changes to the LUO ABI.
>>
>> The Live Update Orchestrator (LUO) API currently explicitly returns a
>> new struct file for every preserved file during retrieve() (e.g. via
>> memfd_alloc_file()). This then forces userspace to use anonymous memfds
>> for all in-memory files it wants to preserve. This works reasonably well
>> for VM guest memory but does not work well for other types of files that
>> userspace may want to preserve (e.g. in-memory logs, binaries,
>> configuration files, etc.).
>>
>> Preserving entire tmpfs mounts in-place would require a large amount of
>> kernel support and would effectively make tmpfs an ABI, which is a
>> non-starter (or so I hear). Instead, we can delegate the reconstruction
>> of the tmpfs mounts (directory structure, permissions, etc.) post-kexec
>> to userspace. The kernel just needs to preserve the contents of tmpfs
>> files and provide userspace a mechanism to restore those contents back
>> into a specific file on the filesystem after the kexec. Hence,
>> LIVEUPDATE_SESSION_RETRIEVE_INTO_FD.
>
> Based on the discussion at LPC, we came to the conclusion that this is
> the path forward.
>
> Before reviewing the code, here's an idea that Pasha briefly brought up
> briefly at LPC, and I more or less agree. I'd like other opinions on
> this.
>
> Should we make the interface more generic by allowing userspace to pass
> extra arguments to PRESERVE_FD and RETRIEVE_FD? This effectively gives
> each file handler an additional uAPI of its own. The upside is that it
> would be more extensible and we should be able to accommodate more use
> cases with this. The memfd/shmem extra uAPI will take an optional target
> file to retrieve into.
>
> For example, the guest_memfd patches might use this to tell the KVM FD
> to retrieve the guest_memfd into. Of course, KVM needs to see if this
> makes sense (alternative being preserving the KVM FD too), but this is
> just an example of how it might be used. I think VFIO also does some
> workarounds by using an anon inode on retrieve. It perhaps might be
> useful there too, though I don't understand that problem well enough to
> talk in more detail.

I agree, While developing the guest_memfd preservation support, I also
felt the need of upgrading the preservation and retrieval ioctl to have
arguments which will make it flexible. And help decouple the VM
preservation and guest_memfd preservation. I would love to see where
this argument idea goes.

~Tarun
>
>>
>> An alternative approach to restoring data to a named file would be
>> supporting a zero-copy sendfile() that can be used to convert named
>> tmpfs files to/from memfds across the kexec. But this poses significant
>> challenges on the *preserve* side since the preserved file might still
>> be actively in use. The benefit of the retrieve-into approach introduced
>> in this series is that it does not require dealing with two different
>> files. There is only ever one file that owns the preserved memory.
>>
>> By leaving file and metadata allocation purely in the purview of
>> userspace, programs can create the target files where they want, with
>> the names and security permissions they desire, before directing the
>> kernel to restore the preserved folios into them.
>>
>> Currently, only tmpfs shmem files are allowed as valid target receptors.
>> Attempting to target populated files, or anything other than an empty
>> shmem file, will trigger -EINVAL. HugeTLBfs files could be supported in
>> the future.
>
> I suppose we should rename all the memfd_luo_* stuff to shmem_luo_*?
>
>>
>> The coding work for this series was done with assistance from Gemini. I
>> am not sure what is the latest recommendation is with respect to adding
>> Assisted-by tags, but I can add them when I send out the real patches if
>> this RFC looks acceptable.
>
> The latest guidelines per Documentation/process/coding-assistants.rst
> seem to be "Assisted-by: LLM".
>
> Although in _my_ opinion, I'd reckon most patches these days are
> assisted by an LLM. The code might not necessarily be generated by an
> LLM, but I think a large majority of developers use LLMs in some
> capacity during patch development. So "Assisted-by: LLM" doesn't add any
> value to me. Other people seem to find it useful, so please do feel free
> to add it to your patches.
>
> [...]
>
> -- 
> Regards,
> Pratyush Yadav

