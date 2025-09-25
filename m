Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0088BCAC5BA
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F4E8E000C; Thu, 25 Sep 2025 14:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FD28E0001; Thu, 25 Sep 2025 14:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E1B8E000C; Thu, 25 Sep 2025 14:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1F98E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:31:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A8F79591DD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:31:26 +0000 (UTC)
X-FDA: 83928615372.07.5CD977D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id BAA4AC0016
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:31:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIaraepL;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758825084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XKbKkKeuiRsGTfz4DsfSh4Ypm7GbrZRpxmZ5WAmi9o=;
	b=l10NOXO+uypTnAEhCMCVSe5UqeBu5JwY+cmJ7njRAUwebZptPt47KC3Eu7BIYka4D9YAFA
	/Dt4zqAeSgO2fqabn635u6M/aV3BxgcrefvRRirL6Fb41qC/gCqzG/F/fpwh1+lNK3q7mv
	lc9ERsXCZEDRQoqwgA2OV5B5ZtJYMOU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vIaraepL;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758825084; a=rsa-sha256;
	cv=none;
	b=F2A9T5ExwTUO9s5Rt6W2Q4qKfW63EBM2Immvn3MTeU+OWeNazny2UVy4woXw3fYDAaC+g5
	3XZDOAYkRZswxRGHXxbekWkpbZtrJIlGbjF9wFUHRdKGvqJfs6g8T1rlLeeycabGtYwKwL
	rIncCtqMysOQ/22Hvj7pHbp1j8+DNfE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 25B06611E0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB997C113D0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758825083;
	bh=eH7Jke1MFZ9p/kAzSSfXnej5on7N11Odn96QlvlP6bM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=vIaraepLvp5WKFqRGAKV8k6YIURNLUQfkUziQGcdACfTAzuAV+pQtYAh1OSJdIEPQ
	 8ktasQd7t0rjza0Rd4TP5xhFeHP7eIW6etdpy41Vkt4iiWba1Y7BoNCsijkb4Zwsx8
	 rP6+HHu2K/MvUQ+m+BbwTI/QF80Ol+0qYTbrBes9NujM9kL2M/2d5vAlJ7Pnf+o6h5
	 Zuh3egaitxsIDkcSF7iiPURrjBECU3a5kpwcsQ3kJ1/QGBUYdObWGzUTU9xq9xzLr7
	 ifsbh/y5S+MqZHfAl0QoogTFJW5zz63xcZsE//jBhHC1++s7pkq5IZQ7gnEo/rpZKJ
	 Ge9+QPgqMJQsg==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-6348447d5easo198575d50.0
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 11:31:23 -0700 (PDT)
X-Gm-Message-State: AOJu0YzRBvYd5gjlF3B8D8MphhcKNMM7vGS/JzoNKB3sbQeMT9p4/feg
	5ZPugG7L0W4LlpmCQKukryg1txarhWGNsvIaqXdVpDeMADXIhs8DsYCukG8187ur1FpYkSJpmWL
	OimV9MNPa077yZCXE7fN5K6pkUTfSDoWXcWYXL6VTJQ==
X-Google-Smtp-Source: AGHT+IHtGubmSQQB2mLy1bepjDW1/vKA5uZdChGoF2qDjIZL/0CmuvZ+5BrBJxim0LL1K/gQe7xIrwbjz6M61rx9m0s=
X-Received: by 2002:a53:7212:0:b0:624:1660:ba01 with SMTP id
 956f58d0204a3-6361a82db92mr2817347d50.37.1758825079500; Thu, 25 Sep 2025
 11:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250924091746.146461-1-bhe@redhat.com> <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
 <CACePvbXz-JQoC40rLzxQe+dvXe9B59sz5kt0eWDUZosRmh3d8A@mail.gmail.com> <aNSlzHmwWWZhPK8K@MiWiFi-R3L-srv>
In-Reply-To: <aNSlzHmwWWZhPK8K@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 25 Sep 2025 11:31:07 -0700
X-Gmail-Original-Message-ID: <CACePvbU7s_JTsOCJQVttvutf6cnw2GjpQqENakze18+hDSPd0w@mail.gmail.com>
X-Gm-Features: AS18NWDjBR6NW54ts8KLw0-f5YiedWzcFxlWHwqk8BYd3RKA9BIFqxNx7Q8K1hU
Message-ID: <CACePvbU7s_JTsOCJQVttvutf6cnw2GjpQqENakze18+hDSPd0w@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	YoungJun Park <youngjun.park@lge.com>, Aaron Lu <aaron.lu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BAA4AC0016
X-Rspamd-Server: rspam05
X-Stat-Signature: cawaz4o9yioh9zn8cgs7kzqzsqaqyfkm
X-Rspam-User: 
X-HE-Tag: 1758825084-510698
X-HE-Meta: U2FsdGVkX1/dDS7vfQhwShcO8IyrEpfvOAi5IeeG6Uevowni6fe0HqrWU2DWBGAUSrJ39QoO2FaaHP9RDPaid6hF0fDFpdGN/Die53hqTwKNwBBRzfrPWi8fS9n/oEp9kjghWu21AoYpFTTPq6cnZtKpKqBbUAd043KmUSOMY+myZqFlfwa9iNOzD1mQcPWKtn2yoXofZ6W8uzdXbBXv9NEk9lJdX2AZaPSlMTb25hJkrTRVrMG+zpz0ZpB5v+XO1EBihMyTzFzVxrKsrz3UoGLy/HnmEVhtN+LXR84+/nOBiY22Bl/bnuiiZp9VnOK5Du3uKM4cSTNLtbz/STsjFGemxQVlYg2HSNx8++Xpb6sl02MTbJYoNFlyOqzm8A+NbEN0zACmFjBzD4S4dNEnvr/2hVbae3hWSRnJ3FBiIAWkknJXY8ASojMyaPP6Eqnk4ryHcaz5Gv1k5p2wC4Sfdp442Iz3NWWggnb8+ZoJYSENL9S9tLiaSCP1FwSZynm5dRo9PfPFjTncKrgnxvEKL5cCWGV0714SEo1FKBxGj4VjQtuFP78lEF50yAULpox2ue+A7RQzWB5g1M9EtTbHtkeASbKwBuprqO/6EUCnledERmS2n5wyrKBIJcYRqUkytJQ9a7vDRy5DSI7e4Qx387MORi/bbUfcealyz8muiCRWOODScbnzC5k82lBbQuJVW1HNOTxTp73fbQ/0WmbEYIripF/m/gZWTmFdZFxSBlHDBs33ixniTSPP0eaH9UKWItuABHZVPU1dwnllcblqC4O3ML3So3QkbgR537C33Jgkh6K56kB32LfJruivJgPpubhLR/iO9yPqIUnro7M/kvpH26XCWcwLIDAXZjAitB8V0/NbZKmdQjifSCMebobag6RR0OgIx6gl7Q85hSsEoHSv65r2i/rhPi/oAtMC1ts76Lc+YFyS6PGl6dNSjxOWvSOs2wI65EY1em824ea
 SoUwdBL5
 AYshx5BKOLMOYlJMYz2Mj5VxyPdH05ZN40lLaYMRTO5DxwyiFPOXVqvfc7k9HNNLKh6lB44hJWTLRHxmmYsArW4dHdB88kKgT+RVBqvduo0UlKdmcgF6zouDwrfuVCxzFRGv+XB3xQYfgIkg1/lGi0Gs6yC4J9uZ7PRTPabVEXfUJPiBigQeNbWGUe1MUfo2iwboaM+F+ZDSC7pT3vN7U/bw7Ol4X6k9hOL5mnJwWAIu71VWPeW/ZeEtqTh8kjePq9WRIU9cxsTEERYmOX/vHWSWq3g6z/ezaYNFWeztPOzAMTz8owcYPoPlDGLovSlPuZlmkcB1UCKHG/n0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 7:15=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 09/24/25 at 09:06am, Chris Li wrote:
> > On Wed, Sep 24, 2025 at 8:54=E2=80=AFAM Chris Li <chrisl@kernel.org> wr=
ote:
> >
> > BTW, I noticed you did not CC Aaron Lu who introduced  a2468cc9bfdf. I
> > CC him here and give him a chance to test it in his environment to
> > defend his patch. Please CC him on the next version if his email does
> > not bounce.
>
> Sure, definitely we should CC Aaron. Thanks a lot for noticing.

Hi Aaron,

If you are reading this, please let us know. e.g. If you need some
extra time to test it in your setup, that is totally understandable.
The patch might make sense back then. The new swap allocator
completely changed a lot of swap allocation behavior, so it is
possible the situation changed, we don't need to carry it any more.

Thanks

Chris

