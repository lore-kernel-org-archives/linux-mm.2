Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3576CC5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 07:47:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DF86B0095; Wed, 19 Aug 2026 03:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5C26B0098; Wed, 19 Aug 2026 03:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C323D6B009B; Wed, 19 Aug 2026 03:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB406B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 03:47:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF6FB40463
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:47:28 +0000 (UTC)
X-FDA: 85117238976.26.B6F5E4C
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1E7ED80009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:47:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UkUFSdjR;
	spf=pass (imf30.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787125647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CWkEyoxZps0PdiXw6wwCg4ciwx9ABuctTL6IGXUaTDg=;
	b=sLvBmiR6R4KNTXQlGYh7EvL2iDwEOq4wE8Ta5nNI8qLCtz0gX6s+Aee0ei6n4jMT0h0+Qg
	9f72JITQPO9TynsF1zG1vDf0CxwaC2EoyTo3Jmk1r6iRHKlLvTNd+eVYzjCWWzkgm11YBl
	Ym13YhNDv0kM7c4tuTbApW+eKyHepX8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787125647;
	b=gazt35KitEEXKaQUtyNB45d5+8Mu9LT80MQJ/qRIFDRF5P/neswW2DZ/MG3FXsISkFho6z
	Rwtg96sip7wqlO+zKDyQktp3fO33Xx/s/uinbUaX0vThNzXLX1/QMoyQu3TMphP5lR9lHa
	RPU3/KQCsAS11bMhjkjk001dbf0qd9Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UkUFSdjR;
	spf=pass (imf30.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-c9e7391839cso632386a12.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787125646; x=1787730446; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CWkEyoxZps0PdiXw6wwCg4ciwx9ABuctTL6IGXUaTDg=;
        b=UkUFSdjRdfWM8mQXI5KDSlMSbkyF7sjnxJAxRPAkqVx9xSQdqlZrA7KxHpAOpAxUI9
         PvNFEECV8clzcg4VR+3aeSBqkYN7aWjJ+yNAzGeYptSVLGx7m/6qc5jQHjM/+Q5MmWdW
         +ywfqFKIgavYT0nusnHl0uDFeAlUAocCeu1Zs8+YUxuDD1a34vSqDTC7ucoLIbKanXmT
         510YI48V4g8P5FznbH+yD4vRppQJCL26oL55dgHWecX1cOjEbcR9G09kQwLROJ5pRG5H
         4KmOMZaktb4iNGwNIvZfmTOpc7RwF2miPhMTWj2FUMMl46JU1IL/MZsoRcKYvnYWcI7i
         yVmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787125646; x=1787730446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CWkEyoxZps0PdiXw6wwCg4ciwx9ABuctTL6IGXUaTDg=;
        b=WLj7L8Tb9HyxfhMHw0B3e+/qnLinmGXu5b9ZDT3jtOuK0D3faBnG2e839IOw0Ovpr6
         IyJNDZ5NFH8PX6AIIdvC6vgRCLhXbO8KyO4xrX61Whbkqd12gHLCKHgLTWJohBEF5O/z
         MFj2s3l/C0x5gETauTqICze4Ltgu/DTwUQx04McPQ862Fz1F6vyiyI5RsHCjzwNJ9vC/
         2cu/y8GWSMMy1Z5jWQsUNPomB6ziYV5+YvbdNBLrvQPEVFULWUmW76w3E2vNAKsoV2HT
         weG+vzuSLPzi5vpFZBsxweYOlr4UTIzn+EFF4HMTqhcOogc5BLc6bOLzf4qacPM94y9a
         bivg==
X-Forwarded-Encrypted: i=1; AHgh+RojLH44CcpwlhtqO5IRY7iPD52C3Oba0XnRDUwpwpWqz4SXIGubSJlDtHVJwztL4z4wTRZuXzOYmA==@kvack.org
X-Gm-Message-State: AOJu0YxJiVE91n2YfvVEEuxscwiYYacDU3sZWiZuyDgb/TIwVQS7yDQb
	YEK48AeJp5lIq6LxSwv49acPoWQLRV8u+m3ii/mfm+g54To1zdAWXqtp
X-Gm-Gg: AR+sD128aqmVJa5h+sbkbQ0esXPpbar5NJi/EDFwvypWoOzdBj5G0P24iwKtDmDSYzy
	ZqwXcZso00vJxmELCva9xGn3PVMuO/+V7Erx56ZYmF/d/UQ5/OV63ba+UKBi0481p7Pmd/+gD/u
	UxEOSI9HkwLOXpcTgI6dinaCNbhLHIaJsytE/+aLV563GKObkoK6aeEMgxvKtvpBc5bfansNnTo
	ML0XqBAyxBus1pB9Ud8Dn9GHZIQ20++muIN4qOwziNYNKAqKY0H7q24KvO7M6FLa88dDAXFL2h6
	3L8p0WNO++1nbPJhQZtyJ6s7bwH/0R/OpTeLwczMorqj7XjdX12DIvQpPHUYm6K0qaJGbxEn4As
	EO0srjZgTMo75qnxhM7XhYVH334tNLVTOOnJ5yZzk4PPpSaKBogDK/DXALgtVzUNF/PGECOJSwN
	ifMg/kFURHlUfP/AMGq0WC86uWuPY8UoFBcUyTezBRXcApcLpeH3pSeRc65NTFjY3U4XmVG5Zz8
	7EKwbZHEjc=
X-Received: by 2002:a05:6300:4c:b0:3c3:88a5:83e4 with SMTP id adf61e73a8af0-3cd011b1b48mr6380483637.10.1787125645848;
        Wed, 19 Aug 2026 00:47:25 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bef77be3sm4151708eec.10.2026.08.19.00.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 00:47:25 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>,
	Yury Khrustalev <yury.khrustalev@arm.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Hemanth Selam <hemanth.selam@gmail.com>
Subject: Re: [PATCH] selftests/mm: remove the local PKEY_UNRESTRICTED fallback
Date: Wed, 19 Aug 2026 13:17:09 +0530
Message-ID: <20260819074709.1345730-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <aoRto6bT3Fv0jm7k@lucifer>
References: <20260818114945.1312987-1-hemanth.selam@gmail.com> <9e533fcd-c80f-42df-847c-c15c4e3a1a70@kernel.org> <aoRcdLGWaNhUFIPU@lucifer> <277db0f6-6161-4ff1-9540-7b1eb5f7924b@kernel.org> <aoRto6bT3Fv0jm7k@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xbb4aqz71ns5kn6oums8ohkztdjp4w45
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1E7ED80009
X-HE-Tag: 1787125646-67150
X-HE-Meta: U2FsdGVkX18lQqxPfyqEs51STyFu0Pj3haJ4p5Y8/WJnzhgIM6J0dmbBvys8wfrSWEAG+yQVV0tpPPkAsfbWkouJ2QLZ4Kg+0CskjutA7J6EFy3c9A77UqWI2zFw00nGeSOx9+6WfxcFJB5nB58t0W37Bc9U31uG5gHvC12aQR6zeCbcTB00bIbo3lRvaAAnSFwv6Ju14yP8uiFngXrHR9DTq8rURbhZONLm/Bbl2WabnUwaxLC/+Ebcz5BF3voS8+EpUcyZuQLWF+SC6QIsjA0/smxejGk9QvPuhcUtPf0synqKSPW9yfpnZ7NuEg7el7iaYfb9za0BQ7hucn3Yn3ZOL6yqIzRvktuY72Y+K+gePiGDAzWjcSGBwAiZAfPiuwH/xE7WlORHHc/8jENW4gKGNQtjxBqYdYJ10v29JUaoFf/n92al9+z98/Q7gPRfzTMoRi5ut84ASJhFJT0/I6R5MXj9VRD8FEJnylFuxZ4JwQEjNg7XlHJtPrFi8HSjmOg4tRhBJLjlSOCx2jN7KZZul/gfrwfuKVq+/sjz64q+Sh+Kdsnbg3moX10nhqLpS0zMD5Lf8MWLhgmgl/DDObJRjp+KyiF9Ek6b31i7J8KbwvAVRC9YqVX+cSVlgRWcsY+aMhG2k7aiNNDjqtsPagm9sumsMijHUeBWPoyfVyyaHRd1JIFMmR2G85SK3hpcQQm8At5pdxhHZotGU2XDJ28XT8Eluzkqkt2vjvwSxnjnTMJVIYYOcuWOX4gWOavFfL5HRfXZMPdOvKZEp48u/nwmmbug3C6b+EmITFkW7yI24fkqZoMBzF/HHplcpVdtb0SbvkX6bHyf5xHkYIeSG9H3+pv4zTyBOhNNEcojMr3fPaLoL95VeuMZNPsV/tCadaKw0FHgTKuynS296ls09y3jXPyAEhX5fzpEvf4jFtgpEJncreanHNwGNn0tTd/FkSU9c4Z5qjkItd1Yira
 ePSP2CfV
 2ZVZFwhUEiiEt8dF1d5w5KPFhPGRPEkEKi+psxz1HOVfuRuuNvQjbSDqjlrp+IW27UHCVSdj82OD5jk2vKN9CM2rZr/U8T87O5PzFevw0R1C+ku/hzBlvHXfILXOsjZhbWZUk/I1ICpi0I1gBKQRV1qSAgXYUv9lB99RaRCyJcdHsSfmH++ZBmk8gH7n8zqGzZm803ORL/4PVosedpeh1s55n8qBfTBIIgebN+y4LswdSF7F3QKK1lPwDwhldgBhT/8QlfmlTpAyJhVL9pUw3H3nvFNLshnb2hFV2lHhoxGeSBS2syqu21sxQZM1pxrN7gWRVeQhRR+6m9zccZGBAq8Zlj7AGG3YkNCEUQomIy+zf52j8ExJj7IVUYtMdeR2C7YQ4lah21ENTenikzoa7wMFPPnqLbDb9oEJ3rIGrU/mRHL3PlJ8ImD0PAyZioRj8yjZuoIrHXUEGokt6v7+o02UEzejGNH20p94ArLHzOEVL3PxZ2i7N93ivHvg9A3ZVf6Nn/3NZFNS7xhA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 02:36:00PM +0000, Lorenzo Stoakes (ARM) wrote:
> But it might be worth checking in this case to see whether the problem here
> is in fact that we need PKEY_UNRESTRICTED defined over there?
>
> Hemanth - could you check please?

Checked.  It is already defined over there:

  tools/include/uapi/asm-generic/mman-common.h:88:#define PKEY_UNRESTRICTED	0x0

and it does reach the mm selftests without "make headers", through
TOOLS_INCLUDES.  The path is not obvious, so for the record:

  pkey-helpers.h
    -> <linux/mman.h>           tools/include/uapi/linux/mman.h
      -> <asm/mman.h>           /usr/include/asm/mman.h
                                (tools/include/uapi/asm/mman.h does not exist)
        -> <asm-generic/mman.h> tools/include/uapi/asm-generic/mman.h
                                (-isystem puts it ahead of the system one)
          -> <asm-generic/mman-common-tools.h>
            -> <asm-generic/mman-common.h>	PKEY_UNRESTRICTED

I built the pkey tests with KHDR_INCLUDES pointing at an empty directory,
that is, as if "make headers" had never run.  They build, and cpp -dD
says:

  defined in: tools/include/uapi/asm-generic/mman-common.h

Pointing TOOLS_INCLUDES at an empty directory as well is what breaks it:

  pkey-helpers.h:188:30: error: 'PKEY_UNRESTRICTED' undeclared

So that is where the definition comes from, and dropping the local
#ifndef does not depend on "make headers" being run.

The one thing worth being aware of is that the redirection into
tools/include/uapi only happens because the system <asm/mman.h> includes
<asm-generic/mman.h>.

I had a look at the history you pointed at, thanks, that was the part I
had wrong.  If I read it right this is exactly the mechanism from commit
e076eaca5906 ("selftests: break the dependency upon local header
files"), which added TOOLS_INCLUDES to the mm selftests so they build
without "make headers".  So for this particular macro the value comes
from the in-tree snapshot rather than from whatever the build host has
installed, which is why it does not vary per system here.

That said, if you would still rather keep the #ifndef as a matter of
course, I have no objection to dropping the patch, the guard costs
nothing.  I mainly wanted to answer the question with something
measured rather than assumed.

> This is incorrect. We explicitly do not have this requirement in mm selftests,
> and they're often built without having to do this step and tooling has been
> provided _explicitly_ to allow for that, which is why this kind of thing exists
> right now.

You are right, the commit message was wrong on that point.  v2 drops
that paragraph and describes the above instead.

On the powerpc header David mentioned, I would rather leave
tools/testing/selftests/powerpc/include/pkeys.h alone.  It is not the
same construct: it is an unconditional

  #undef PKEY_UNRESTRICTED
  #define PKEY_UNRESTRICTED	0x0

next to other powerpc specific overrides such as PKEY_DISABLE_EXECUTE
0x4, and that header only includes <sys/mman.h>, never <linux/mman.h>.
A probe including just <sys/mman.h> does not find PKEY_UNRESTRICTED,
with or without TOOLS_INCLUDES, so the definition there is load bearing
and removing it would break the build.

Thanks,
Hemanth

