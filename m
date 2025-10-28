Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED055CCF9EA
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 23:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D80C8E0019; Tue, 28 Oct 2025 19:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AF988E0015; Tue, 28 Oct 2025 19:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED1B8E0019; Tue, 28 Oct 2025 19:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F18748E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 19:58:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A93861405F7
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:58:56 +0000 (UTC)
X-FDA: 84049191072.08.0074A5B
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf13.hostedemail.com (Postfix) with ESMTP id BA75420007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:58:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=PizEJo80;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf13.hostedemail.com: domain of paul@paul-moore.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761695934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/WE4n4TCb18hPsMXmSS/+ET4xqQfmAur/mQUYq6ibGY=;
	b=ge/i4MN2+luOgomx1p3XYpMRIPyzOO40W80y81OeaS57JRVxTp0fst7YZdARjijURr6jSg
	zJTbx9H206WjNxGf6jyE09q15D2lJgMVHQhnhCVJkS1j21Ek0PmneVTt9j82bnL6FznyBM
	/LKiA2K+FWwrleImXbYIYBnqrtm1dik=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=PizEJo80;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	spf=pass (imf13.hostedemail.com: domain of paul@paul-moore.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=paul@paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761695934; a=rsa-sha256;
	cv=none;
	b=h1uo6dTYyamccOkhYYx3W2mnVh/ADOzRncdjzFLx3HNUBiIhNcfQNNeYZltFW9pddxBlBP
	x3zuf9QHlj8hLIcuoV6CWWUfWQ9S5QIku3J7QeJYKHMdzOm1PC3VocIdvCuhJp4u2FqHon
	3hiO22jD/MsX4W12nBAbcy5iQShQ2rE=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-63c0c9a408aso10695174a12.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 16:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1761695933; x=1762300733; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/WE4n4TCb18hPsMXmSS/+ET4xqQfmAur/mQUYq6ibGY=;
        b=PizEJo80QskBD35aXMNs9eGwC8vM62ZQSp8lNixKhq1qWgdMa9H5FQzCBOKbXbAy+q
         q16FhktYrnFmAhFPcM+ikmTfsbNbpbZi1+3lHxt20js/UY2h8N2dm507h0INGd5DLyf/
         PUetIHCGk+DxpZrr+FTEeT9zoGxiwo/SxYortILVec6Kmyv+fRdwf1LNoID6z9EwDgSI
         S2IGBsG0YTQPEFohwCYn+qt7vA1QDXZFOgj3jTizyZd9jjEycLf3NZguhEPX5DnlJhYx
         rOn4xWnLnO3eni1UnFnu2rGmMp+ejUbgHXGMTt8ptDP59Sq0uCqxvdD67iNbeODPZMSD
         7Bww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761695933; x=1762300733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/WE4n4TCb18hPsMXmSS/+ET4xqQfmAur/mQUYq6ibGY=;
        b=S2FuNYH0o44404VOpl4xG08wTDczs3IIPqgDNLRs72H2kiGb7h9b5sDEIfy0ddvP9E
         M55UeWVBSmfjw0wl468lcH8aXVaNdBgD2VAwVxdUwKr2hVLQPi9slktvyUgqMkdIq6Q7
         UnXNTggsABCHIEClDmETl6yfEArzbAZbA7kA1N8+uuCzKek6C3veCWqTu0cf1OmVYjR9
         0xbFBsBsuc5KHaq7nQ3M0o/2R4wH9M2Qkr6UNgBF/N9D+citWi7ymqkoIfSCEp8Yxdov
         NUAJRyqvnUPKwVYKyAdDEOwDr62hYnQek/LCN89N7Q5yFjZ/k7zaCOY5ps2Wc20FAs9w
         qyVg==
X-Forwarded-Encrypted: i=1; AJvYcCUd115deufJ0U9GrfwI6K8W+PevgqKs+OXcKA7VjxtMaBGDBUVuqdGrqjTyaLggDg8tgQZKTn34kg==@kvack.org
X-Gm-Message-State: AOJu0YzOPM94AAaAwb5ho9bqpox82Ym/cJwGOCfUyBs/ASGa6vq88yLn
	Zi/vgv1TDiRmHHE/VsZyRYITqr2W/5RdezHrqVRe/AqT9bnqnc2icmdpDEZsskJGmyD0hbGi5XX
	nt0NTci+0CfqBH+2czokppe2yuPVHUXxMizb0FI7i
X-Gm-Gg: ASbGncupWbH0GxIMYvURv2iRP5nktE6jO1SkZ6iAx+BF3WCCgzngJ1vm/E1I7WC9yd6
	EZfzWlWpilcmAIL09w7iSw0GVs/UIy5PsP9Nm9/BQKLJ3MRV3fgzrDjOWyAZLFEwTuyULXYG8Jx
	GiXCq1jm1EQyml7dsVjxtyKaTbPR0o++D3L2nrSwXL5w/O3mazGchG5saXemB/sRtS53Z+2pabt
	3zST4eUxpJJFMWosXjOn6O6S7Ijc4nOC4NNoihCgEp6nLS75gaAd4uDIKaC
X-Google-Smtp-Source: AGHT+IHvIzFCAVsIe9KLnMzhe7HeHw161tWjaGF8dq9LK8mHTJ5LNBNsg03z1RN2kv4hUoIzYntUB79AzDiL37F2WAo=
X-Received: by 2002:a05:6402:50d0:b0:638:74dc:cf78 with SMTP id
 4fb4d7f45d1cf-64044380bd9mr816143a12.34.1761695932545; Tue, 28 Oct 2025
 16:58:52 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk> <20251028004614.393374-11-viro@zeniv.linux.org.uk>
In-Reply-To: <20251028004614.393374-11-viro@zeniv.linux.org.uk>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Oct 2025 19:58:33 -0400
X-Gm-Features: AWmQ_bnbOFuYYw7q6A3vKx1W9tiGVviHbdGsSFCW7Z6eJ8jFBd6mwoz2mbQdJG4
Message-ID: <CAHC9VhR4nO+TanWwz4R-RQijy9h5B2h6HuBDXxBNp0+kAE4Asw@mail.gmail.com>
Subject: Re: [PATCH v2 10/50] configfs, securityfs: kill_litter_super() not needed
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BA75420007
X-Rspamd-Server: rspam03
X-Stat-Signature: 5jqjmekqxs4jn1wr4yu5tmrbj13ydckr
X-HE-Tag: 1761695934-993046
X-HE-Meta: U2FsdGVkX1/x4WKL1Et8NCLSWAUQRR/8ngkg0gOoZRoo9UKkOeDHJhtOomZdRZfcwh7b8aBLEr1wZ6kJCQCqPdeBt1byUnWk1dRZeiNGe2HLhYFGwrKgEeY4tA1LcNRGKKzQmyHB6iXqJlfLU4BXy+9eGZ9fVpxoTzSlGtlDCvE5OdrE29xmCwZpaFTkZUw936YH/gmD1YAPr2tDMS5bpUibvKlSE4UfgFnfJIoHFlWrCFwD0j9Kq4Rl2SQr5iWMiYrpuNFedihEhjG1FeznUmwlI/S9RiPBYqgM01yWZssiZj5ExtuROQEJn1FuU7pMnAVhucGbmAjc4Qv5ddnDJIXec5nvpOZF93wraZnSm6245UPc+zNCm+yrAqQU8jgXLco/lLNNSixyvrvZoTeeKEEbe23gro31S3Mbd/ZBeIDnCQyFYrapBUH8UToP++FXgXfyQJOtjXFAt1ekk0erJjpNMxjzPlNlo9vxR68O9Fae60uaUUqXwz6b9C4X/moamtDRTSRUOa7GsvzFl4xmmTNfYG2s4iFv0OG4L5awyPxisC66R54/5TH5EMU34AToAnY6BiZ9SLF4CNEpyiAWYtX+T/VmYyzYpCYSQIIRau96dF/t+RaIlZ1EW8NFQ7crfgTVmCwJ5SAxVhdKJTN6rmwFk6PVXjlGUm+U0WCfcvC0QMjq6yhBbDgkh2CC3+1tnb01VI63r4qwtNrl6MmqSMHjOEGobVlCxwdPgDPaYRivdUecgGrKcZV3wdBQaNA0HltHGTB1nfkeFcJZ8skURVl5QRI6AV5cgEdLld0QcwNg0PCJdKNk2W09m2L0zIu7XeH4DdFy9H6NOpFxMCkTDKLlJb7FUaiHeKlo/6P9HUsoVdp7Dw+t5XE5ZbXxxJmx7nQlZX8j7s5h3ty7K3t9aGVu8kXu13DR1UAcAAbC1w1j2NfiSYRizzk2B0lIGb31pI/T7XoYS9/HUo6elLd
 ho7ZKzli
 HHh6mbb3Af1iBTROf1xRNffeLO0ACY99/JF8xrkRumBmCwdAnHZLSMt0IZpGwOqbHg2OWiyRS3nshqW8GuWNzX8a/No9rwNWne01pWxuFxWBxIh13z85R0dYp5EFrWxZTR95PiciOIthd6ebWwe3/1tlOVZw2MdJamCux3aTD6ui1LdKopeGFUBRrA+StyMeaTxxGEa/R6/ehgeFzJdfWWIfdSMRVU4KgPfG5YDMPsumEp4nT4TCwrefdJKpF2NTSljmReEQu45aVZFBPWnGJ46o51E8scVFDiGBqwnyZ+eEf8GpJYnCZ+QCXZykfSzrvttr/jxDBsEC82nofRwkPm9wRPmOlpQOIXRsB+JP1PwrzpZDQSw3mBMby63Iq4uU7FPvJJU9bst1QPsccBIrF1h1K4MfgzqlhQJf5ws+TVRmYaD/yAbKs4E5BwxoP4UXf/X42lLu/cKi40v8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 8:46=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> These are guaranteed to be empty by the time they are shut down;
> both are single-instance and there is an internal mount maintained
> for as long as there is any contents.
>
> Both have that internal mount pinned by every object in root.
>
> In other words, kill_litter_super() boils down to kill_anon_super()
> for those.
>
> Reviewed-by: Joel Becker <jlbec@evilplan.org>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/configfs/mount.c | 2 +-
>  security/inode.c    | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Acked-by: Paul Moore <paul@paul-moore> (LSM)

--=20
paul-moore.com

