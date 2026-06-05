Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1620CCD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CBDE6B0098; Fri,  5 Jun 2026 12:27:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A38F6B009D; Fri,  5 Jun 2026 12:27:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593A46B009E; Fri,  5 Jun 2026 12:27:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 497E66B0098
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:27:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EB9431613EE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:27:30 +0000 (UTC)
X-FDA: 84846389460.21.CB013F8
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id A04D740004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:27:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VSjiez7z;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2QDQNJjYqwPm+P0wBS/rB5uazpPW4+3idJB2lp6tmqM=;
	b=FTi2ZvNu6G/FrJpWIPo6++Q8PvIvoiy3lpKMqu6L3OdfjlrGbc+TrC8vZL5IH3HuwuVLhW
	u0FT0olxEnrCQz8h5ZJVhvSg/TnDUcvlG65KZ1uvKAMJt+bu9YQHoCX77QpksuA5tXx/iU
	jEKeutkK3F7XzmyaL40z/uJpXzqGBeo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=VSjiez7z;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780676848;
	b=30GHZWPjH6CKX7UdfdLJRndRrnW1Y/G5r+MQD8LXi1pKtbq/PfQYiyI3ZzlXbXK+2MLZqY
	w0sAKPX91Q5bKZP6tsP2iPhJSAyzSd4t8ZV4ioBnKZe2MvZ5yNz68rQ6EiTJ6wPKqtVyGb
	DRPG6vkGk1ifY7KwjdydvMrVshH1Soo=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-68e5f7c1131so3919061a12.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 09:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780676847; x=1781281647; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2QDQNJjYqwPm+P0wBS/rB5uazpPW4+3idJB2lp6tmqM=;
        b=VSjiez7z84fBtWrKmFeMsSlqf/zX9bgatRAOQXZ10t59lj/H4im0Mp9Pljx2IkPTQs
         VowZ8JbsHKcXIYmEs3DWZSOISaS4XPHXT8rK+Mq+ksfp30RZtQp7RCWgTsXLaXXYPCBX
         Iwzkz+tTXWbkIgvLTEPHrCsGBkK4J3WX/6nEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780676847; x=1781281647;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2QDQNJjYqwPm+P0wBS/rB5uazpPW4+3idJB2lp6tmqM=;
        b=g7I2/t2ufMcENn2lOVS7p9I2S8fASzQkNl/ECMr8Fj78gyJ3cOO0zvErUqhSOwADVs
         eD2TeZEpJmOHxyarWt2S7w6pHZ2lXEWNLPGuuRtgwMEwbP0Y5NFxuo45LqSQXCWiM+VO
         qLYNdXbnBo4iSBrqA3lo72BLMecyrdpFEGPa/pNLlMfNGMObUkizi7aZgpT/5Ov4MWXE
         v6b4salJy0WVkFbFAOQKJAv6JlOcN7rgzJT41ZBHb+fJslVFjxxoW6gVqcjTC40swiZs
         WsoeTiOUgiuIoRNBmpdJsmZEalOrG+PpYOPXj7Tr19fFGcRE6gofBB8p8cMIX79oRxdb
         7b+Q==
X-Forwarded-Encrypted: i=1; AFNElJ9hoVczMEN92lfDsw5RqECPKggq8L5d8pXBgk1MSvbGiHEy/WkI71sC2qBWW77mDIxHdtmgkpgAQQ==@kvack.org
X-Gm-Message-State: AOJu0YzYd/yS169c4FVNEo/lQDUUHbLVaY1xCpHvsD/9SK8OkiMi7brE
	V8yAyqsXYx8PgkaEPmgAuZf8XE2Mav3TFuhREJMswOXexyuW8Bk4lcH7oSGfq4njBhKILwaPGRk
	4o+HvAPgIeQ==
X-Gm-Gg: Acq92OE2QVAWEUOatJzQjsc7Y6l7NtqwwYTVg1xW+NReEH+7Lp2YCko9rsSJ+v+YPg1
	eNWK1VK7YWJM4aEb1NBhyHNDfpXSjfV4TbjjotUQf57qdHKq84TVasKrmfzcsn57lNzCmWlnZ+A
	azQGp8imqGiFcJAC9JeNeNZnxf7LvVRkUZdZyCru2WWOXOJE5DmGgH4IWC2mIMJpsrpIlLR6jsX
	M5BARS7+8g2I970lsqjhQU6VfyySjrKWNCZVGJrmBgmtXJd5iY7aq6NdmRYrTkjOO5UV9caJQMk
	4jYGMTVgPz+14SM1doyXyWHcPv3PwyKU4nfHOIDS9kbRsssXbY5dWb2fRZ9A2ipbbSxxCLero7y
	3h3KSVPn6yOLFNXbqFO3Sg8SmMBluu9dUSgY9e00nhrBX/OOwyMDMYSuf13cPz7SJDQVMN+dp1l
	GAyR0ImjKYFGjP+VVh8gbLV+Y1iJeKksrlU47HnQsn60XaETrPxoS7CNsU8sI17EuO+qSdrg3K1
	7VGXnjFkbs=
X-Received: by 2002:a17:907:abc:b0:beb:8c28:254 with SMTP id a640c23a62f3a-bf36d2c26e5mr173034366b.0.1780676846808;
        Fri, 05 Jun 2026 09:27:26 -0700 (PDT)
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com. [209.85.218.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0553040a7sm482800666b.50.2026.06.05.09.27.26
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 09:27:26 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bec423a5265so342278366b.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 09:27:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9mqB5T1Nx2hyZBcrDuIvSZXNjNzVpoLj7nkYdyt+ZE+4eJozMME25XQYs2sdzmBastg2iM6PMpHg==@kvack.org
X-Received: by 2002:a17:906:4fca:b0:bec:5264:ee9b with SMTP id
 a640c23a62f3a-bf372c2dbabmr257257066b.36.1780676845718; Fri, 05 Jun 2026
 09:27:25 -0700 (PDT)
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin> <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin> <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
 <87se71jps4.fsf@oldenburg.str.redhat.com> <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
In-Reply-To: <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 09:27:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=whMTq8_2rpYoZgoxVCwj=LsvfzHzPuwo-NcizT7J24MPQ@mail.gmail.com>
X-Gm-Features: AVVi8CcJjF0IzkUXs5jB8j5aKjJm1d1LQ0EBlpf4RydnYVXz3zkkVCs-hralHh4
Message-ID: <CAHk-=whMTq8_2rpYoZgoxVCwj=LsvfzHzPuwo-NcizT7J24MPQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Florian Weimer <fweimer@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>, Askar Safin <safinaskar@gmail.com>, metze@samba.org, 
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A04D740004
X-Stat-Signature: cz8qjx8wqjju5jcgc5pmcbgzm6uxtrcx
X-Rspam-User: 
X-HE-Tag: 1780676848-386556
X-HE-Meta: U2FsdGVkX1/IpS85o5LddhucMm0NnYgb3SBAxupI6KpVGC4j2wDlYUSzCH3A1rA5+0I+w5Hac6G29syXE+vfL+pPuHhsT4KtCi52iej5813gojWaVsF7Wgcwh6ouERpi00TozU1ncHOipgQhVxkMgCHzSOpswnufkWmg2dibpVIBmMTNT88uQtPCNwv20ZiOmV5nwG+WSdwIN7z2DvwceHeLDdUcD1Y8dTKeu6b1f7GDHicCV19JbyvbbvDdXJujp51OxHkOsK95grcO2e2Wy2yqi2FaMGtfxZM/0nAO+XItgH70TxbwpycKx7CZjW7Celqpk3qlwnjvBXtk+qhOOtDAvqMw7dy1foCE2aZkS2j4rjmIcPqwz9DwPWUS8fVgYUBnu4spDMRs2/7VURd8T+Dla+P1y7yGdaNlqX/pFJF5ZaovwMc6/5LlU6Jw7h3GRNpImnoTJy91McjYcmPKLzB52Lie1KQ0iBqs9ulaAs4pz7p3tQ4y0Gfmy+EwbDVbMoNOzB2baCv7sMqYaKSD5At+vx+pZHRBo/QqC9NbdpO8kHmbSbN8XQE8kn+wcCQ3uUoZw4Z+1EuuFr2mDHkkuvfTCI73uY6flJESLzMGVBJ4/EZ7rjofNdzNOpY2dlAR+QBCHNZRAaQ9PQd1VJk+HLCbyLSxdJcUiHGlCp9qa+b8OqvGHnBttHuWZo/dTSUUDjTVrP/+z8bOGI24MNkdrwitwrmxPE+aUUITZnAQYPSDJdatTXl0pdW+dBW5Kn0oN/pnKHm8tYE9NWxw2twIO4vEUC/XqazvNTZgoQmj9bN9rdyUz5JSSVZxDE91vO9JdKW/KAQ2iadFYRmUcmlkAOMHB0ZxXd/T4GT8lbNq2n7wbnst6KtUaxTrYMTAxbHyV/c8x//W+fVNN5HN8WWCdTroLpBNyaqWQu6SMkOfH5eFE0QHBIMTNjZikk7EAtLBiP6Ozw2AvqA8bPx06Vo
 dSeOPd3E
 qWT8JuRn759urAGQMFO/vE0SigOCxY6kfD/6XjyHZVKzFzPzWIycxzNNZc8xSI+6U0o8tSrDXRhxLIFgYqChiQpCrVdTt/qsfVaArG9h4/xGXyfHnXAyrDdFmkZr+dvlpsrsgp2Jj7VfyXWbOIMSOi2Evf1UyoAIo9Od1cUcEQRq0AT++IsRf2NJNOXL6bFVGUtwfG0S2WgegwsuG9Z5nfXRnjtumO0utCBckHvAZtc7VE1Tj+hYIvn0dbrYaGztm16A2qia7ENZQpDWEAdAQFCpYBuGQZUsXeQha7PFcH3gPLYsaWh8xFqnzMloitfy3tJwf1B28DwtP2Y5cAPz1V0r99tIlqvgyWVSbG/ie9fDAcfrld2JqQUUTns7DlxaItLx+7HQAWThvyprHEDuTaMAfiLpdxBkvvP3IfUYVO2vrGsE30JQi/rEEIfbk6ecE5fzsZzH3Jx28Au8ns0NusjYjDjeGQBTSWZ8YT/LdtNQSIld5KWJCuvWkSCU+Lgu8lOarQTI1tDUVNWAZNc61xSKIE0ow2HvRNf0JYB0YQxLYg02XA/mIvkDvVOQ5+oVg+DDSY4wFc7FzUdQL9jxUe+iH0M9iKAv92tXu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 at 08:54, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If it were to have the same issue that powerpc(*) had - that 'unsigned
> int' has to be passed to functions with well-defined high bits - that
> would be bad.
>
> And I'm pretty sure that clang doesn't do that.

It's perhaps worth nothing *why* it's horribly bad and why I think the
powerpc ABI is nasty: it means that *some* things are done in 32 bits,
but other things then expect the upper bits to always match.

It caused security issues, where user space would (for example) pass
in a 'int fd' what was value in the low bits, and then had interesting
upper bits.

The range check in the kernel would then compare fd to max_fds - using
a 32-bit unsigned compare - and see that it is all in range.

Then it would use the *exact same fd variable* to index into the fd
array, but the compiler would use the full 64-bit value for that array
dereference - without having ever checked those upper bits. And it had
passed the unmodified full 64-bit value around the whole time, all the
way from untrusted user space, and the kernel code all looked
"obviously correct" and had all the proper checks in place.

If you want to bleed out of your eyes, take a look at the rather
horrendous macros in <linux/syscalls.h> (and the sometimes even more
horrendous arch 'syscall_wrappers.h' files).

They deal with issues like this - and others - with some truly
inscrutable code. You have to be super-human to be able to read it,
but those wrappers are why we can then just do things like

   SYSCALL_DEFINE2(setregid, gid_t, rgid, gid_t, egid)

and it will generate not only infrastructure for tracing etc, but also
the code necessary to force clean up the types for the architecture.

                    Linus

