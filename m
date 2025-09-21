Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AAF6CAC5A7
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 18:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368198E0007; Sun, 21 Sep 2025 14:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319AA8E0001; Sun, 21 Sep 2025 14:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207DE8E0007; Sun, 21 Sep 2025 14:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0868E8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 14:31:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C05D119467
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 18:31:52 +0000 (UTC)
X-FDA: 83914101264.02.7857AEF
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E103160004
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 18:31:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=ElSln1Wv;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758479510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5bmmxR03oGGFi4aRvD/c+yECGqZ+0Eg8A/9OXcVnoA=;
	b=4RSXBtUO/FKsum/404XeXrQd3w81OXiTTco5I9AWLsNFm0jhIQf+zfmx/J0eOUTB5uFYgU
	b8rqOYWS3oov7TVkxeNi8WL2d0SvTOoVZlhO03c5jRvRu/ldDu37/2KHzxNtwSjZyo6gz0
	g3ni9xTdhlq3QULGCxpxSDbyYGPbvDg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=ElSln1Wv;
	spf=pass (imf08.hostedemail.com: domain of paul@paul-moore.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758479510; a=rsa-sha256;
	cv=none;
	b=SjE8udXEWWqOv5wocenw1Gjkn5n0nS3QlBz3u/QICmpF9hTt4t40eBCoJEIFNdQpahvPRV
	TPzCEF3OpY91nrDTqI1TM39wlp+eDsRlQjOkqZCvTBGUekmfa0c0PG+F8+gyj/z8TfLSQX
	IMyqgLJJfXIxpas7IPVdmsUoV2lKPew=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2445806df50so28416175ad.1
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 11:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1758479509; x=1759084309; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5bmmxR03oGGFi4aRvD/c+yECGqZ+0Eg8A/9OXcVnoA=;
        b=ElSln1WvsEG4kjrQsYUDIlW1+ash/gOXyN/TLLugYtd0N5E7D4eOZRYinikSX/Jbjk
         gusOxFgyh81E6RR+VszQYOxUhPn4QDPy8YmkDyOozgPJaWB8epDwp3/LEWr1cpXrLAds
         ss+FjdOSFGQHhcXViw7chYv561+1mswDJWDYxIlXkUW66NJr+xevPefoTLsC4hg0p18C
         n46rEXv0IcVKWWKdnEu66GGOLo8FM2KfBIdiVw+JqIGSDk331At1cf5Am2r0GvRqyKpY
         PbDlxGZ4lC16JFRHHLWi3NYks8HQNv7d7jAs+b8TrOufOinoP4GMvQgV5j355XvcQWeC
         G64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758479509; x=1759084309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t5bmmxR03oGGFi4aRvD/c+yECGqZ+0Eg8A/9OXcVnoA=;
        b=tM8US1lo73cxAEdp1KxpSHDf8rly6f8crxYJtT2ppouaTqxoEjG/zuwnbGoDVMQuRA
         IQNK51ZrcC7M49axsTalzopvh46oDivUYaMdoPOX8+N6xMLlSuJwyERZ5iWlXsPi3IX8
         K1QPHgO7vYu4hvJahVWe5SCtHpUXRgdSHhBsDPHi3yKDZ91VGjeC9S+6L0ZSFZtiYQlS
         S41mvoOCxHESv/bxQZk1/Iln3JrIKcllPOIdHEnAnUnuqeWDOmVwBnJDpimiG6Vi4w/8
         T+ZWmuwLr9B4lKhIGo5Nc+lk97y2gcmLO8grDV7Xb90Yx3RpSNn6mNr7CTywkb6EcyrR
         jKAQ==
X-Forwarded-Encrypted: i=1; AJvYcCV9AXQsAlGzrN5ZVHdzsRAB4WvA9Va4rXog4QLBncshtAkJB99t6GAtk2mlYq6Ozj+wyi1vs3AfYw==@kvack.org
X-Gm-Message-State: AOJu0YyA82rEHJOt+pTMtD/AAYD+l3NR+NXjY36enQjgawBKqipU2AZj
	+2vBezGH17cn1BarhgDuaeW0aNDA1taUD+jwL7VDLM9jN7Eu9TtRIxHknK10quIRcXU2GUCkDU+
	LpbsuWG3BE80qvc57tDLBU2MxMU5AB2z2Zrs2pDQA
X-Gm-Gg: ASbGncv3jwqrjcuG6YmvRLVagi7y4FX25+zPr8i4jipfRd+9yneL8taZ7MxQRAfqoRn
	DJU4GO9WkG5OJAxOenRypsKMHSfJkm389YOe5NgBJl1bbB6dgUQGY/2sOrprX3sisTrXq88TrYc
	JD4usu40fIO7ey+UMOnC6XftFIp99de+11EAxsL0YMnIaX12fH4qruNjC9RIX22rFbabYxGYLIy
	UwVmko=
X-Google-Smtp-Source: AGHT+IEQBYu1bXA+JJzXZBhAMlECigDvK1kHg7kQq+Sl7o9CyFR7oQw+sV4XJfWKh2n/RmInuKKGYYsvyveVxhjLkuk=
X-Received: by 2002:a17:902:ccd2:b0:252:50ad:4e6f with SMTP id
 d9443c01a7336-269ba566603mr149763755ad.54.1758479509058; Sun, 21 Sep 2025
 11:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250918020434.1612137-1-tweek@google.com>
In-Reply-To: <20250918020434.1612137-1-tweek@google.com>
From: Paul Moore <paul@paul-moore.com>
Date: Sun, 21 Sep 2025 14:31:37 -0400
X-Gm-Features: AS18NWBRwEs0bbBucktCB8_dtchuI7OGkjeA7WSI3M2q-Aj3yGux_-_Cr5q3Pns
Message-ID: <CAHC9VhSbWJ-8tj5BxSTxznGO8zraKRSE31a+tqdfMHB53ef-MQ@mail.gmail.com>
Subject: Re: [PATCH v3] memfd,selinux: call security_inode_init_security_anon
To: =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Hugh Dickins <hughd@google.com>
Cc: James Morris <jmorris@namei.org>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Vander Stoep <jeffv@google.com>, Nick Kralevich <nnk@google.com>, Jeff Xu <jeffxu@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Isaac Manjarres <isaacmanjarres@google.com>, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5E103160004
X-Stat-Signature: 4sdgoodsrtgoht6bjstmcqfp6yyikp8m
X-HE-Tag: 1758479510-920183
X-HE-Meta: U2FsdGVkX18pM+tMBGkenJ6lmRqKo3AzQbzN8oKAVG/5TfGnnROlVri+ZuyeS7IEoZntgOjuunXUWbme5UtGn/rpV3euFW95oFK07l+/+NMR2ZNLjKUbLemtTal1hxkLLq7QxQxKX+HfWMXev9Le8MPew6i0+Grh+R6nTt2yz6MXQk03NGDW2rbY6hthn9bKnbvUDMr7L0crfPuGQ/oGQN1Kx07ENGJ76hh4rWApZ/eKxkTnarYEkvKxyvw63DDJJBR7CpYCR+kDHpA6ZRR1DNFWbDamWwlwnkJafGJcxTF5zTmBgbk0Coa7AGRGq83vWbVtgiSgRWP5aX6dzveq8qKZk6Z0bn1Rl0He2ioh4WU4VIjgf8T0y9e98icQhrCwbF8rfTiSTdsMaCINHWFnY/O18bJhT3CyGOqmOpcPtx0i9F+25T2333og/ESLectw1ZxZg9foqAuLZSaLs7BUfNEJ/f6NAwQ6hgyJZQWZXGQgJnzxzs49kvSZAvz5P8Y/KWOTjckIciO9M669prEh6MQ+BGPy//6rPEpglSukAB3RBBNxrWkBg7IGtx3K4oXjlxJ0Mqrwwo39RDjzFUbrb2jTP8RLmD80it/S3beP/3VBRlTzGQCFXioWI8xU42KU+ARnzYFow9t8rWjXA4uAaOu7/1cjv5ra4cCF7colvYEjHhOg9yVJIX+N1S3oxGjVejU0k26W1w18cxgC+iAjPB+s7VnATwJUGjFB6DJHcsRNhICHxeXiEIJCv2N2BG7Pmh9L4Ny9QLLipDrMSmpNUGvXpGR3EynyrKK3Gwj9BZQYd4L8AOPb0k/4+72oJG4NGrgWSNNTpHprHRGBgdJwi66Ot/sD8W1xKuJpHUY86+I0DyHbe7Si1wOW76Um6IyXTIHKMn4B6i1FPWztiyoATXO04NNe45+lCqSFIOWU1FI6IdDw0SV295KG1vLZrPuxdkFevVlVOatoIFhZGo4
 bpAE2JcA
 xAF/k4ORUveYlmgM32SW6PINE32vGdMj2PuLQhqHE0JU7mDa1Ec6wF+i/WRNmnlC9MjBQKqqsRaTzOoco48+SEJMAw7jO0y7OFbIFZ3NNoWRnT52DT8CvQUMRQ193meCjaairECjv6GP9lCV3NzGzcfHi4rxG6+i/PkriMDVa8nAWOgVfst3fd6BsKdcjfeupWFNasV/XFTTbNOLrbD28zhW5lC/tPvkSsf6Y/Fs4ADSBQm6iJlrxoFxUzyCDeS9nxdjJavLN9vEJvVznwsVhG+Mi5HDUCido+si+lqZDZapfjTXRJiPj2WrkNP54BJz6Lyjbq5fYCKQk5k/DvTz4RXFsvNo3/V9qzQq4NYcmDMneklbub9w3J5EeqXi4iW45OFmaGMiBJQGPqQwFhFhkKQ4PnILlaO6P9Q3p/55kAycZgXrtyaU4Dgfbv7yVecniBMeBkK2XS2JN4IAzjmmQBqHsHgCTDVMQ9czmmCl3mEGcfRQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:04=E2=80=AFPM Thi=C3=A9baud Weksteen <tweek@goog=
le.com> wrote:
>
> Prior to this change, no security hooks were called at the creation of a
> memfd file. It means that, for SELinux as an example, it will receive
> the default type of the filesystem that backs the in-memory inode. In
> most cases, that would be tmpfs, but if MFD_HUGETLB is passed, it will
> be hugetlbfs. Both can be considered implementation details of memfd.
>
> It also means that it is not possible to differentiate between a file
> coming from memfd_create and a file coming from a standard tmpfs mount
> point.
>
> Additionally, no permission is validated at creation, which differs from
> the similar memfd_secret syscall.
>
> Call security_inode_init_security_anon during creation. This ensures
> that the file is setup similarly to other anonymous inodes. On SELinux,
> it means that the file will receive the security context of its task.
>
> The ability to limit fexecve on memfd has been of interest to avoid
> potential pitfalls where /proc/self/exe or similar would be executed
> [1][2]. Reuse the "execute_no_trans" and "entrypoint" access vectors,
> similarly to the file class. These access vectors may not make sense for
> the existing "anon_inode" class. Therefore, define and assign a new
> class "memfd_file" to support such access vectors.
>
> Guard these changes behind a new policy capability named "memfd_class".
>
> [1] https://crbug.com/1305267
> [2] https://lore.kernel.org/lkml/20221215001205.51969-1-jeffxu@google.com=
/
>
> Signed-off-by: Thi=C3=A9baud Weksteen <tweek@google.com>
> ---
> Changes since v2:
> - Add WARN_ON when using unexpected class. Return -EACCES instead
>   of -EPERM
> - Remove extra new line
> - Rebase on selinux/dev
>
> Changes since v1:
> - Move test of class earlier in selinux_bprm_creds_for_exec
> - Remove duplicate call to security_transition_sid
>
> Changes since RFC:
> - Remove enum argument, simply compare the anon inode name
> - Introduce a policy capability for compatility
> - Add validation of class in selinux_bprm_creds_for_exec
>  include/linux/memfd.h                      |  2 ++
>  mm/memfd.c                                 | 14 ++++++++++--
>  security/selinux/hooks.c                   | 26 +++++++++++++++++-----
>  security/selinux/include/classmap.h        |  2 ++
>  security/selinux/include/policycap.h       |  1 +
>  security/selinux/include/policycap_names.h |  1 +
>  security/selinux/include/security.h        |  5 +++++
>  7 files changed, 44 insertions(+), 7 deletions(-)

Thanks Thi=C3=A9baud, I'm going to merge this into selinux/dev-staging now
with the plan to move it over to selinux/dev after the upcoming merge
window closes.

Hugh, since the changes between this patch and the v2 you ACK'd are
minimal and limited to the SELinux error handling code (see diff
below), I'm going to carry over your ACK, but if you have any concerns
or objections please let us know.

Thanks everyone!

--=20
paul-moore.com

