Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDDECA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 16:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 086768E0003; Tue,  2 Sep 2025 12:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EC28E0001; Tue,  2 Sep 2025 12:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDDC68E0003; Tue,  2 Sep 2025 12:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCDE88E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:32:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8241516029B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:32:31 +0000 (UTC)
X-FDA: 83844853302.26.39660D9
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92A4A14000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:32:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LVKcO5rt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756830749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsW7p2Uvyz1I7BfjIGuq4MTBzhrF2WShjf0Carefykg=;
	b=J07C3QMCTig7wqtccOTR0egrU9VXnq5aDZUVAUSWFMhlWxA0Ptshda1Wem4EFJKX5IEv12
	g12ttirnP8+y0WdXIPxGVd4J61yh6j3/7Juln8WHbZVRIHIedD+kN+0sb2eeUBciAaixf5
	FuSjVtixHIgDy/qZ48T+hEQO8Z2gHZ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LVKcO5rt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756830749; a=rsa-sha256;
	cv=none;
	b=s6uPz1K9zswfBb4uDNNYbNPAt2Qb0U+czanO3JVs3mtaKujuuwJf6Jtzs21CJcMQeZw+HB
	scc6lYF0ekGh/zg57PhHbQINaoHGFASFg4YfI6Hgz4WIBM4FskNvvhKPh7zQLSq+oBditu
	IqgKhod3LI9Kb2eAH+Fu/vNS0eljuUA=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-61ed395ba46so60a12.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 09:32:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756830748; x=1757435548; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsW7p2Uvyz1I7BfjIGuq4MTBzhrF2WShjf0Carefykg=;
        b=LVKcO5rtY0iDAn04TEJVu3iQLIWo6vVU0oQgl4C06Z4MFxSUOg0oMPYLkCaXBZ8iMD
         L2bKYJONmCInbg+Al3cLfQqB4iNkv0WmvegIUnnpeBF4oADVr/noRMvxLjIETB7cMrWB
         5BxdJ/FUeqFQV6cA4zx4nda1nODzcCKUYMFTtRRa2pUwoaaAafvTIzOumpT2aLcopKmd
         4k+jEzOWGLKeIl80BWu3SPO3qHSBwIaRklOuSfwV+npDPs0Jjdm2HyRVXyxakxp32ItD
         oFgrQ8xY8toKOz+Uf+ItFr+YDDpKXdB1du1RLX2oemHc6Rz+zfFgpfVVxxVI6pbaqIx+
         SIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756830748; x=1757435548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsW7p2Uvyz1I7BfjIGuq4MTBzhrF2WShjf0Carefykg=;
        b=bu6iovzLJCfiG/E++JROm+pi43mbaAUb/YX4/Ni48OuXBx8kdOiB2lNesNpGNqTGWy
         +tN3MaM5tJTf9RoLojYFja4ymx/z8aUiVeyYb5C1PTrPf6/utGFQCf/s6Eot3hB1Qjn+
         IECP9LZQdVif7iu/yfElMDihxJ2wS2fRw8IXVJLI2o8dv3Sx22MpgV4AYoNLFzpCHsCb
         Siey+fm90E3GcviPwrFQIkFQX9SrjxixA9cC3CSE3tcjDNS45swQvPG8hqFSSSAs7ySi
         WM7Yw3Ma+Ob7toitEULJpbtAzia34WY4dGrAjXHxQvz+rfj0Hn2IKJR5GRdkUrDZWzp9
         QK/A==
X-Forwarded-Encrypted: i=1; AJvYcCWB9IALVE7Ak1bhqeihkTGdZedG9K2cQu5nBSnxdKFYT4WexXN50NnXX8XOm3QGA2rmMftZ6eHfZg==@kvack.org
X-Gm-Message-State: AOJu0YzDhT546ggPpAZtc4S3dBkT1oA7wsoGfwKEDw1iIFeJcvGX5S8j
	7r0KlcGJpy+uc8f8ylzUvMJyn4KCXZMhJ9CQwYmWdFJ7zWdFdB9taH9eSCwfYnH57OgkPeLRZQ3
	TSFFHBgpMRGI88QnDegiwifUBmMuAby5u1Z4GCa0Mo/88HNv+aap0Jpr3ZmY=
X-Gm-Gg: ASbGncvdw0Q6EZZsf1q76w+z7Sxer9s/FRF6SXcCGojk6oC9OH4JAdLhbsIknC+FlAP
	zUBoXiwwRYVMVUFuFCEidjiuDSpKHcI+xVgJeOMQhXdOBPsoJXD19j/QrAf0I+1NJfZoytemnm9
	0Vtf1nUJL2e5FKfbbnVUvKonf/EGr4sNgVsVb/ttJZXXhO7lCDLvWJwqQrDvdGtWSFBvCLiYu1q
	/6BzXpuSaMoTttMmBkJJOErJndJribgskxgmetX9bO3OZXlkM39iTAXZ+v4zYg=
X-Google-Smtp-Source: AGHT+IG5nuHKIxDgzjc2IG2vJz0lPVJszmpFhp/FyF1ix0dDLy0FE8hycNG4YX3ZSuTvGWwKRisG41UI+Rfm6oT7q7Y=
X-Received: by 2002:aa7:da99:0:b0:61e:c9ff:4c77 with SMTP id
 4fb4d7f45d1cf-61ec9ff4fdcmr65520a12.5.1756830747879; Tue, 02 Sep 2025
 09:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <20250226030129.530345-1-riel@surriel.com> <20250226030129.530345-2-riel@surriel.com>
 <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
In-Reply-To: <aLcQ3UCXXNcByW1O@gcabiddu-mobl.ger.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 2 Sep 2025 18:31:49 +0200
X-Gm-Features: Ac12FXzMWTBH_CWk_Rh7cxiHroX4fRD_rpNfwnRzz9Z2Q-oOvClTv0lTunEwjto
Message-ID: <CAG48ez2ck2QaxZ6G1Qrp9p0brFecrnf+KRc7Uk8c9kMJqSOswg@mail.gmail.com>
Subject: Re: [BUG] x86/mm: regression after 4a02ed8e1cc3
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Rik van Riel <riel@surriel.com>, x86@kernel.org, linux-kernel@vger.kernel.org, 
	bp@alien8.de, peterz@infradead.org, dave.hansen@linux.intel.com, 
	zhengqi.arch@bytedance.com, nadav.amit@gmail.com, thomas.lendacky@amd.com, 
	kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org, 
	jackmanb@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com, 
	Manali.Shukla@amd.com, mingo@kernel.org, Dave Hansen <dave.hansen@intel.com>, 
	baolu.lu@intel.com, david.guckian@intel.com, damian.muszynski@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 92A4A14000A
X-Stat-Signature: k3uqrqpnoqy33dbdr1qyhj7p5kffq9st
X-Rspam-User: 
X-HE-Tag: 1756830749-550434
X-HE-Meta: U2FsdGVkX19UkuAkjsdv32ekMza8EM8zL3Io36l2+XMi/Nd4QqMaEhdgb7tziUIIIdmqCCAtyc1YdU2OezxZKksOdXBCshG0wn6oEEkod1SwVeOzdOc/zJthp+ObqVkXe6xcHal+KVoRcR09+yottdLqp0MmY43srXUrTFEyjSJaz8OtqzKUGLUO7DBso0tRUHIScxPNzYfajkt6awcbUxF9G1b4JdCu9RoGisy5AnB5zxchpSaa2Yq+/IhVTEqq+aewOJRpGlkbf80rDRZWryNDP2MAx4ITDe9P2lFQ4uAErQZhkpmPTY0mFpq2epejytL0B54EPskh8GBQ4fCjggTo05oCxhQhsbE4CxiJb8ZPvUnJEGq0du3ygMnc4yupU93R+LodLXJP5/0Ls7f7q8TCweoPVHqcL0T6sNpgZMfUvziGN2BKqrqnq2U/agulEAOn3kyQ4p57Qf4Ni8+FJkbNQVtnmDDnMSQrLxpoLIEbwx2tAI41lejKjn3bh1zjed9Zp0atFsJx7QsAdO7iGJty/7k7dhaelzvDrZ/VhMMOxqtanlsUddZqCPGP/VHHdBv7oryNkSf3gZWTg2I69sf8ZLRHYIIoPUAdASlJyUpbhSBGSBbycfQ/cnTjqsiBU+IUpSVVcwEwE8ty9HhC5/akk7uMUxAMQQvj1h+vXmVjuCqhomSCw3dQfCmTAkw3pKPKfGvr2Q7o8By3eYKuwpnl/nPjoZ1RSykFsYp7pnKrO6ae9ID9OCIDN04CSHMhTR3rbj7Oqb2E6Tw+qLU6IZa84eAsU+kSfuiPtESCBAHiMlSfIAxjE7A02FwXSQ9fRMiON39AxCNQmaL/faAQg2uuM+8CttnUEBea3xlP6zkbW9MmCwDtWYKKRo6br4EMoot+21uWRUC694xLI4EwM5jB4hsJItrIiYpX5KK/AWeg8FwhKHtirl5S7IackhZYUHtDHmXukTJbWypFgHL
 y35MDgGi
 6lVPNV8DXxqzvz7ZnJoPx7r+nSonWAZhIRmOdYahLQmkPUo33jN37BKdqaZkFGtizQQwq/c0ko/09TwRHNN7W1ztT4H/508cbAY5/AWNXNhpD0Du0WEX+V8A7E0GgMkfRiQmYaKz22yOJmv9a3YFF6WCcg++/lSi7+aIyFycorvmeitpR/3BCWJOP/yU7Q/TojMzUJdZruS3qJCAh1Ze+aE9duwu/+H1OqgovF6wzSgJ/JbOOv6gyWgUJpdbZSIfXrwJeGfMXYG7qndy0bHgkX/z5Q+gmsr6TMH/v/4zmR3/8SjH+BfTfeANrdWREDJRL49nN5D0AnUj6Mj+ivoOM4aVk306T2vTrKIEG6m6EcF2pVdoZWR0ZdNO41w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 5:44=E2=80=AFPM Giovanni Cabiddu
<giovanni.cabiddu@intel.com> wrote:
> On Tue, Feb 25, 2025 at 10:00:36PM -0500, Rik van Riel wrote:
> > Reduce code duplication by consolidating the decision point
> > for whether to do individual invalidations or a full flush
> > inside get_flush_tlb_info.
> >
> > Signed-off-by: Rik van Riel <riel@surriel.com>
> > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > Tested-by: Michael Kelley <mhklinux@outlook.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Reviewed-by: Borislav Petkov (AMD) <bp@alien8.de>
> > ---
> After 4a02ed8e1cc3 ("x86/mm: Consolidate full flush threshold
> decision"), we've seen data corruption in DMAd buffers when testing SVA.

If it's not too much effort, you could try to see whether bumping
/sys/kernel/debug/x86/tlb_single_page_flush_ceiling to some relatively
large value (maybe something like 262144, which is 512*512) causes you
to see the same kind of issue before commit 4a02ed8e1cc3. (Note that
increasing tlb_single_page_flush_ceiling costs performance, and
putting an overly big value in there will probably make the system
completely unresponsive.)

