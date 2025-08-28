Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45F2DCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76E556B0024; Thu, 28 Aug 2025 05:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EA58E0001; Thu, 28 Aug 2025 05:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E65D6B0093; Thu, 28 Aug 2025 05:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46C1D6B0092
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:21:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8144F13A516
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:21:00 +0000 (UTC)
X-FDA: 83825621880.03.1F8C7A6
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C0B240009
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:20:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h/HICCuZ";
	spf=pass (imf17.hostedemail.com: domain of 3eB-waAgKCMMsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3eB-waAgKCMMsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756372858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YM5qp7X76Rcedsuqy22c62bk9TbDWzDaDH8Yo5p7tbw=;
	b=WLdMTG16WacneGkoZgTUbrTv+EJaSGq1kH+OHiXuloQGlJ8E/2PtJ8EL6l/jaQh0Nomkzf
	SXKJQzaxhgqJ6h7sgZlNBTIISD8v5gGDS/DQ34l3pTQATfTkltrzDkvYub5rWuCfXlIfdu
	b87V3NZU8m3gnQ3WJmUjBu1FvKNe8YQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h/HICCuZ";
	spf=pass (imf17.hostedemail.com: domain of 3eB-waAgKCMMsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3eB-waAgKCMMsjltvjwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756372858; a=rsa-sha256;
	cv=none;
	b=pnfq8g+34fFYyYL9EOxg/Vz+yv0TPy9MkWr4uQPM1DiYDKSruUcG44+TwlgGe4EcNHXiW2
	paUFFUfrpSOMfjIzu4KWvYB7V57syuexpSofCoGzvUfXq0y414pXJQ5qyf3yrcmOAhVHdR
	J+3I3r7ixx6oOakSG+1wjjd1/F+0fJ8=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-61cd4c2c9b6so465469a12.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756372857; x=1756977657; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YM5qp7X76Rcedsuqy22c62bk9TbDWzDaDH8Yo5p7tbw=;
        b=h/HICCuZJFbxRjwXi3mSShGT4SdTGsHtSE2HIZKJTOAa1jOpZFXAQizW2p3kUSHVGn
         oFL7mA5VxoEXd9lTeK6YLsX2IIXtIZjWeo0sF6LMRbJO/32ro5Hsjh/sT3am6F1tZY1w
         Hb75qxWCPz6XGSMbbEX2T9el4nXW/UIfXArHNG21w6olMqnTO6TD73kIjJGtjaVRcZSx
         FXrv5y9qxzEICqNmC0KzTSR2Eg9CXzLH/EYHf7AnqnpPI1HZGfBSQ1+buEhtDzEdz8T9
         usj+Rsx4iXvwoLDE0g9iy13x9zl2geICG+RHNWOXVvKRvlzH/7vZfuqTyRhAVvOQa5ot
         6yRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756372857; x=1756977657;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YM5qp7X76Rcedsuqy22c62bk9TbDWzDaDH8Yo5p7tbw=;
        b=nK4GHXWTdr3jKp+EVW1tv98dz7yclZJ9RN3+w+nXFXCKgKMqMZ78K7ijMbiuiGwp4L
         017jZ47Wgot2TgEs+j+vNjsrN2MJHfyuFeIip4T9E9ka05YcgddlcnJhruxbjBu7vqwR
         qRZtPGZ8wPQHmZL6tXcE7R6L+D44tEq86veorxcmonwBeVNCJl1kPRltzi8ROq5do2DO
         0pJGGXxGH4OB8+8rZkqspSDJG0Am44+eojJm0b5iSbinBbsOsQAWCaQ8CCKe8tAIBxk+
         LUFPNFTFsWO7kbt8IsUcv6MUHDA62Gm9ChGheNcXUBc9NGp+h/Uj2e4huJ84yy4ILSwq
         OWIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXtIQkh3iwdWjrI7lHZUrBTxnWluCRfwug5Egfaspxeb9J3EwB5uT7azFW2cPQhKlVCTLk+dp3WA==@kvack.org
X-Gm-Message-State: AOJu0YwzdD/x9cgrRSpFKuC3kzFijMo382grNhl4oQ9UfS2aYol/8HjG
	RoFCpBReImP95fr4NSziwGFLAqULp8Et9EdFfZru+7EMS1D4r1OSsEG4CKSG/tn/Sntfc9CcwOj
	FAb8QTpWqIJ0SRg==
X-Google-Smtp-Source: AGHT+IFkVH92/Q0D0GIcS9KaxX1UP6vLGf0Qcpt1E1rUVYyfKDRramMD/6V/MybaQIecatsjMOq8RZHy36Ab2g==
X-Received: from edn13.prod.google.com ([2002:a05:6402:a0cd:b0:615:6482:748c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:358d:b0:61c:73cc:fb4b with SMTP id 4fb4d7f45d1cf-61c73ccfee1mr10144954a12.3.1756372856958;
 Thu, 28 Aug 2025 02:20:56 -0700 (PDT)
Date: Thu, 28 Aug 2025 09:20:56 +0000
In-Reply-To: <iucjeilrzonjldwizwkeo67ouo6o6nbqbnmlsyoua33737ekj4@uf4iekswazec>
Mime-Version: 1.0
References: <20250827-b4-vma-no-atomic-h-v1-0-5d3a94ae670f@google.com>
 <20250827-b4-vma-no-atomic-h-v1-2-5d3a94ae670f@google.com> <iucjeilrzonjldwizwkeo67ouo6o6nbqbnmlsyoua33737ekj4@uf4iekswazec>
X-Mailer: aerc 0.20.1
Message-ID: <DCDY7RAG4AN9.1192AMMUC2LMV@google.com>
Subject: Re: [PATCH 2/3] tools: testing: Use existing atomic.h for
 vma/radix-tree tests
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, <linux-kernel@vger.kernel.org>, 
	<maple-tree@lists.infradead.org>, <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ix46akya775dpb7k7u5e9mkeubwhq9nt
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C0B240009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756372858-486733
X-HE-Meta: U2FsdGVkX190XNR5iln2wwpezEFsCuK0qjV26g8qYLcvBRZ/iypy0XLCmymuOVCb0sI+EWM60IbdOxKh17cRR0Z4DJ7GXch3I59g4UzbmP/zs0TY47HP5Kf+vVisWadxYOKPza/OgrjeqlIO0aEVtbYOXLayXFrhbzTUHQ8X0UFei+dQtMqHCfDrNorNDmuMPJnhORtSqwamc5SYCc52GpEu9EhR6CEE61lpyoeth0dXVbkhEkTZd1r1AbDZ3cwtbmO2LRgJZ5I/zetEIW6tzqLIucAFGgn6Ok4/cJ7FZ7NQVDcJNjYzZ3r96LOtDxOMr92ze6gz0/YXRCVQlO/hzUzD5UojUPrJvP4C/3sEUyJbMHEOwVzBbOsJWLen09TAA+XD6b/xJ9o5HTJi07MvvXrth5lYGGeRyPVmBlx0oe+IuIoXCd0UhxnTYgrD4iuhlOrIu33SFyL5E1Ml8Lup1H6VhrUapGzC6b6JwfxWYOugOFMJObpewd4JSUao8elciUGavTwO+rQ7ir/5R2XRDl7FKqF29Q3l1FstZPYf2QHUPBZDCS8adeQtGiodAwo56mRbxjbNlWh18Ew67zWk7sXl3V6hOTFV/bVLgNIDu0U/vO505BX2vh1Dj/juOPx0WZYu137Ar3P3OsHfMC+gbF8L5uzHcxKMwgR8k6gUB0dXE/pFd+4rl6JsBoLbSuKyfOOP7dyyCcbQFA5vMI/gJS5ygWX0qA5qi97Jm+iqTV47IOfH5o9sv0ELLFjFn/+EDOvXhSYtU3xEyVFEPwZLTnm7zu1t14cfN6UM6aOsuPiSkSMPWDSNi12O/sVXLu5D/OEryUB6LFXtmXmdCuO07i7LLLezAIThexiQ6EIzACwWkbtyBxI01njqW5L+j5MnisEUs5u3vgQzzyTEgq0ZQ8rGtaRshemX8V2qk5hiUJ1OFh66qbbjgCN0qxTrHV6OO2y28e1zzcss96qPPgG
 wSxSQg+9
 4L5h0fkzrhrpTryEg95ksEDu8RvoCEk7M4MQabAs/TI60hpfKbke0mw9QURNi65eV2KkHTRRY84ysLywVhK4vLXwEByUMGPOjqLiknk/kmVhsBrffS9i6Syn+W8a4nT4vSi9x63b3Su5xhC5jFSSaeeLn5sZC9dUFfUpQghDkZLGMkaGbY6bAQ+o+ngCxq2xvJppvMuYUsvdju5x49fI/fW4dvT8IP60pVsHF+UjrR0GnDeVP4OtUQLuHErYzzHHT3JnVkK+BzBiHcSqZI1GCzjkGTdm6K5XnCRQaXC8yXz2juc56+pa8lhaeYCHaGqAvtw8KU7EyKhrh0/3z0ewsYQADwg2Ge4i9q0j/9xs+Ee+N6zj8+28cv3B1uFAlQN3EAuXpzk+1bJIChF99H58ST058nZmdJszqW4QBSwENRP9ppCWXb8tcGPFL+NZr4fbYqfaNt71zS4fKH04ZJI7wkV3Lr0kJnmiPCKuheXAo6NcIBnDoSmR1o7/CMeD1XVwYZhEmDngWStwLiHdgLqz4y/Dxth/LcY+Li4D72BppyZ08M8vimRoIIU3YEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Aug 28, 2025 at 1:05 AM UTC, Liam R. Howlett wrote:
> * Brendan Jackman <jackmanb@google.com> [250827 07:04]:
>> The shared userspace logic used for unit-testing radix-tree and VMA code
>> currently has its own replacements for atomics helpers. This is not
>> needed as the necessary APIs already have userspace implementations in
>> the tools tree. Switching over to that allows deleting a bit of code.
>> 
>> Note that the implementation is different; while the version being
>> deleted here is implemented using liburcu, the existing version in tools
>> uses either x86 asm or compiler builtins. It's assumed that both are
>> equally likely to be correct.
>> 
>> The tools tree's version of atomic_t is a struct type while the version
>> being deleted was just a typedef of an integer. This means it's no
>> longer valid to call __sync_bool_compare_and_swap() directly on it. One
>> option would be to just peek into the struct and call it on the field,
>> but it seems a little cleaner to just use the corresponding atomic.h
>> API. On non-x86 archs this is implemented using
>> __sync_val_compare_and_swap(). It's not clear why the old version uses
>> the bool variant instead of the generic "val" one, for now it's assumed
>> that this was a mistake.
>> 
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  tools/testing/shared/linux/maple_tree.h |  6 ++----
>                               ^^^^^
> Did you say radix-tree?
>
> I was going to accept this because I put my code in the same directory,
> but since you'll be respinning..

Yeah, it's only the maple tree tests specifically that are affected. Did
I understand correctly that you're asking me to reword the commit
messages to avoid confusion? If so, yep good idea will do.

