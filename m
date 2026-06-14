Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4971ACD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598A86B00BB; Sun, 14 Jun 2026 08:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548726B00BC; Sun, 14 Jun 2026 08:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DD06B00BD; Sun, 14 Jun 2026 08:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3869E6B00BB
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:48:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAF17165496
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:48:25 +0000 (UTC)
X-FDA: 84878496570.02.4F35A87
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id ED0C6C000F
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:48:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qiTaX5FQ;
	spf=pass (imf10.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781441304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiuA0JHLa9l58ogicvE0m7CrCNTFlFcY4pqZqBKpS2I=;
	b=dAARnVXh05FUvmKGTL8BiFVmHInhanu1MGL+sD1gKQfYsWhBwk+5l0PUFsw8oOWfHscyaK
	fKYb6FZZ/aXJzCmihETOwmxnTXlFlxkQQCcPLOKPACnR5yeknTzy/EgmL6MeYYxBGlGXH2
	LIVH5pAi01Ob6aPqDhpXVzNlKKg2cAM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qiTaX5FQ;
	spf=pass (imf10.hostedemail.com: domain of praan@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781441304;
	b=CXhLhQcpojE4+KFOetK4N/OHX9KMTM+Zrc3pOyPi0Qkg1vRLRzKjA/VKJzSi1YjIef8TpM
	1Op/zA/t3gM9Jf9rUjbbv/1/Jlug2mfQjfK2yY9E5v/y4t8JtOyARZwJCHkFlSRrZsU5ks
	7e6fu8/IYcmr2LZqnFfUkDbFQrWntYw=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2bf22c18ad3so105375ad.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781441303; x=1782046103; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GiuA0JHLa9l58ogicvE0m7CrCNTFlFcY4pqZqBKpS2I=;
        b=qiTaX5FQRNFNOzKuEOfPd/fbG5mm6E5U32AuyiVc8y99jOT7pzF+Vaf2E8z+MwhO3p
         tlNsYV5yw+JKXURzHs6tCAK7KajIbabA7H20Ks1R+b1GAegj9InmI+k9vy+ikG7/VG2q
         WiATNlKNhrcMiyP2w623bm5qRuRoV079+SP8WGk0Cth83pthHXqR2pwGqhn9jX1EUv+Y
         POYQ4uALeowOkBHzUgfKBGuX/cc8rgSpTxOG4TqKd4RUhgB8kG3CuuYlXpsoS9g97K0D
         9OJCJvRvFYpXoSTkmwrRI7IwSljt17vIrEOmubne9a9u/9sQ4a1VZO+0/k0h7/jxAzMf
         tX2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781441303; x=1782046103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GiuA0JHLa9l58ogicvE0m7CrCNTFlFcY4pqZqBKpS2I=;
        b=sT38qCif9HMvkatNDZ7JgBMzxZ5aDgJCizhRGsfwfqD0osdyI8sPkjQEScK8pttKH5
         IIX87ZPGAFtZGVk5AXfq8nv/ckhyg/ZmpFzv7hFiLVhWl5Sk3oAxdzPaZO1j/+biMkPF
         ghIn8/cIWfXbtTXVy0VvbPG504V6HG3ZiQ+rhywjYtibZl+g1Ipu6yWmGxFvSnKj3o7U
         COko5TlS/D27vaYGfd0XtFVc3jSG7cHcuP/cNC7cu6hz38udeL1bUX/p1y1uO/wLGrBZ
         6x+ek890TPj9Uz5C+0oQTE1Fx+VcfWS/c8vcBzLa1cYSSJswnXC4I8uipVru/fx9zgQj
         oftA==
X-Forwarded-Encrypted: i=1; AFNElJ+frIFmEQo+EMV+hAmi6TfhmUEdKhTGktm8jVhORLlAS0wTXv7KLiDEmSsllu4bHdyMCXfAtPKv7w==@kvack.org
X-Gm-Message-State: AOJu0YxK0ohm2uK5dQnc84YfWDnZBYFKC8861P8i8QkJZGhmoKYvv2AI
	PIc7ZysPy8bbk2gdcEii7YsqBXjRuowYzkWUkS8XNlq6DlAoxC2EoVYmHGjFO948Yg==
X-Gm-Gg: Acq92OFJ3gW9NfZxJqNXDxPVXcCKCH8HPiyzI2jDAXLYfLimer74pTn/Uc2CISUsKab
	DcqBVMKy1dCesdJuHgPklkBh/wNXuOM5f8Juy4m8IXmdUefBR1kPfHjw7uYQGDtbW9I2XoEK8Dn
	Y2FmANyjfsorNrOiHefdD1A6cRxsQRWlK2j4X2yvKfOUkpmkyujCmJLi34geFi9Ney+RFJFJNf1
	lPCCGsbZn9CPLHGCui8XcPHOppMfCAHmq1ssR6RqX+yZsKF6BpNlg8NWZz/ei9yjJt64ibkfZqP
	88dnSo9hZAUE0Z8g9ysYYof5apCjY0Vf54hWlqRU3o/PQOPF1YwYF+qjxkjaHlDbPFm1gFFViaV
	wK4qPbkhYH2vW05rZPMJAq0Sdl3rbvJ1sxPC9ZU0XUglPA9s4IFg85rz3LScmHue+8TzDzbgomM
	NilTtNP2lgvwinX+8Xjp/xGxOscSJs3reEu/7rCK1UFTXEBlXptsjndtNCE1OH
X-Received: by 2002:a17:903:2ad0:b0:2bd:7e8e:ad56 with SMTP id d9443c01a7336-2c6650c0f1amr2373205ad.6.1781441302378;
        Sun, 14 Jun 2026 05:48:22 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c86651adc16sm6026664a12.31.2026.06.14.05.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 05:48:21 -0700 (PDT)
Date: Sun, 14 Jun 2026 12:48:16 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	David Matlack <dmatlack@google.com>, tarunsahu@google.com,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>,
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/1] liveupdate: luo_file: Add internal APIs for file
 preservation
Message-ID: <ai6jEE67rXInZy-w@google.com>
References: <20260613012521.835490-1-skhawaja@google.com>
 <20260613012521.835490-2-skhawaja@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613012521.835490-2-skhawaja@google.com>
X-Rspamd-Queue-Id: ED0C6C000F
X-Stat-Signature: aw8jjzuxndnbzs65j3iom9z8xhadffr3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781441303-147408
X-HE-Meta: U2FsdGVkX19DPCzwd1jGsljaXtZW7auTGVg2G+jvsQZ6kMqPVeJeHb2IzRB8IQx2G3bV8tpHQHqnNkIIwq4T5WVYdY8GU672rcepDL7SPMPR7w4fsbWawq+CSq1f+t5xRXnPP2uvbvsJaedJeH4XYYwjJC5t0cU+/o4BQK/ULPjdR42OCA//hEY21I1Bs7x6463U81ZX2U7K7prUmODfK/ifPcY1WWeSLRxj4A4PcJb37VG+Gmi8eHwCzUftSNrZeW1ehQgTgP/Gm2vZ8FjQZF0AYhZc+sm+Ym/auDHK9PWEEmR9ZDoWSRbJgjhoiXWIVNYnBW/V85yOQOCc0zHqSWD+stUZFs53HEyHKYWEbv+LCOyQG0go/0PyavkH6pY+FCaHJv+Rb0ocHKo2qqb9djIobm15Jx3lMezizL0/6BRMxbusl1BUqRVcuI0w0JzwPAk44LoUMW+aEw9/GsWY1VHwHxprKqT1cCQPOQH07+LeleY6qmSbGN0XMoqXQ6OnWJCooaJEOO2F2lsjtOQcOTA5cyvWem4MHmCzp5wIGzwpDjBUMECqZjUdfWEyOB5EpGf6/5hONbdrRUwld6ZuuPAly1T/ufkITqRr3nTctO+7GlSXwJexktZrVXMkWk5Xi+1FkB/Oig9uhZEZzmx2gX+I6K46mgUEfvGi/7/OeZ6S6S7XkAL1wWJ0+2GhelbDFOZFedU//L4NZVYPZMgYcYYIx9n9PN3+QVT3c6JbhVFauPzQTcSThn52Tucf8lK8rr2UZiRJEeb6dK06toGlqT8lTCcsw0ZOXdggBzgt4gXhaHaQUtGeNuYgasNDUf8/5dANLzZ2L7oFrNWf58WP+NurIs9CsIoxEzkWeN0O13qsmuM+Btc/Hv5lefLQBco7tNqAYpDqSt+e0Y9NQa7R/z7il+KwWFOC2ONoWkV5Q5LxGDRSXZG83t9lsg7HFCABM5cUYf2fcWeJpYWNFLr
 e7BAjV/G
 C/MIVftMVlzt50qmtwPkbvvJI4VBkCIjEBT3BuX8lRAcljVWY7GOvDwGTCvUbP0u0nRWlrimhVGGZj91frPOvRbOHcy2atl+qkfa1O097cAbHzyhhc4sKkKvsHym2/SE4l5oOZ0T8zixrBa+xN3D876sfoiQPrlcCkZTmUJbqtqAzaEvCeB4EsnZELA6xIhm7//ZFdcdQYakFZib+dlSh/4etAhsO0XUBhumIbNsChomrDIJ0QnNXcvZgWPu9Rh9hdFB7yfxSIZut1QDUHu3hS/ZTrfMRJ6D8NGHMqqd4A18E5hUdWe1uhLWd7e+j2mJEoxtI7nWmm6fM9BgrRzBoRZObGd/TAkgivF65zgoP4oPXdyimEUnstO8gNVs718wlKirxg0bOVyfA0s78+HrHMmDMmnt2w1ODCUzgqMefcQ9MPZ0ICa5PMgZbeZGJ7U/WXoLAq1k0c95QvbZBw/teLW2Ql/f6HFhpXHc7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 13, 2026 at 01:25:20AM +0000, Samiullah Khawaja wrote:
> From: Pasha Tatashin <pasha.tatashin@soleen.com>
> 
> Live update orchestrator file handlers depend on the preservation of
> other files. To make sure that the dependency is preserved, the file
> handlers needs to fetch the preservation token of the preserved
> dependency. Similarly during restore, a file handler wants to fetch the
> restored file of the dependency.
> 
> Add APIs that allows fetching token of dependency during preservation,
> and fetching the restored file dependency during restore.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
> ---
>  include/linux/liveupdate.h       | 21 ++++++++++
>  kernel/liveupdate/luo_file.c     | 69 ++++++++++++++++++++++++++++++++
>  kernel/liveupdate/luo_internal.h | 17 ++++++++
>  3 files changed, 107 insertions(+)
>
[...]
> +EXPORT_SYMBOL_GPL(liveupdate_get_token_outgoing);
> +
> +/**
> + * liveupdate_get_file_incoming - Retrieves a preserved file for in-kernel use.
> + * @s:      The incoming liveupdate session (restored from the previous kernel).
> + * @token:  The unique token identifying the file to retrieve.
> + * @filep:  On success, this will be populated with a pointer to the retrieved
> + *          'struct file'.
> + *
> + * Provides a kernel-internal API for other subsystems to retrieve their
> + * preserved files after a live update. This function is a simple wrapper
> + * around luo_retrieve_file(), allowing callers to find a file by its token.
> + *
> + * The caller receives a new reference to the file and must call fput() when it
> + * is no longer needed. The file's lifetime is managed by LUO and any userspace
> + * file descriptors.
> + *
> + * Context: It must be called with session mutex acquired of a restored session.
> + * Return: 0 on success. Returns -ENOENT if no file with the matching token is
> + *         found, or any other negative errno on failure.
> + */
> +int liveupdate_get_file_incoming(struct liveupdate_session *s, u64 token,
> +				 struct file **filep)
> +{
> +	return luo_retrieve_file(luo_file_set_from_session_locked(s),
> +				 token, filep);
> +}
> +EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);

Thanks for modifying the comment (as discussed in [1]). 
This looks good now, along with the EXPORT_SYMBOL_GPL.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

[1] https://lore.kernel.org/all/agr6yoyYYq2QFxjL@google.com/

