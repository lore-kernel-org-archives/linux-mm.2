Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAACFC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 21:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7540C6B008C; Tue, 22 Sep 2026 17:07:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7051A6B0092; Tue, 22 Sep 2026 17:07:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61A676B0093; Tue, 22 Sep 2026 17:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 411086B008C
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:07:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C72171205F9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:07:26 +0000 (UTC)
X-FDA: 85242634092.16.8990E91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D85B94000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:07:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jTofcVmI;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790111245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tbyqPgrizLALVjg78yaFfJn0dQLz3gPA6d0TtceKcJg=;
	b=D+JiOkFhju9NWhCiYhdn+z6L4OYCpJdOoHC43bYVUUhtIAYiVRrtOKO8esW86hryRMUtcP
	ZsNwOBokrHg1QSTkiYG4l9Gs7Bw3jVmZJXLz7djR8S9cOR/+viiSaconkn4ad8GxsYQctB
	iVJYosX6tQY2opt4sO0D/oKjhsQdTF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790111245;
	b=rk9vHACugNZJRhQWrhk0QGzhX4gbXVfZp92rgngEEODzqNXoJ/+8ioLMkC4/GStZtwgXnE
	wmYJIWMylV4VuHO6svRWjLNZM0UHPpRZWi1EHFh3l1oQH62oYxZy1ELhXW9/XPe0G5gEgF
	5FJMUNsN7Q60/A+Ap74nbSnjHhru6zw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jTofcVmI;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01D5B44514
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD35A1F00893
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790111243;
	bh=tbyqPgrizLALVjg78yaFfJn0dQLz3gPA6d0TtceKcJg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jTofcVmISdXyCtYuw8zNFILbYNlT/3I/N33Wt0Df/YUBcucu6snDlL6RByPk0zwnp
	 ZpI005lJ82bt9YValXE9bNZ2d/TBjxRXMdAHNWODZuVhOdg2m2OjJTchO81FkodLIW
	 X7S5eEHyvykG/IoEJvD9TVltdQcCZseEoYPAYSKtqMJcV6uDbuRleDURazXE1n4kYl
	 tMrnA2zh+UxKZExguYZ3fJJaAFjY3tueAYKRnVEhXG3miiagZha2kpwbbuH+xX4RkY
	 ekxx2IvqklUpKeb5235MiWN8Qz5IT9hiPMWEhAWG3ZfPqmk3rzebzNAbek96vLh0r0
	 9tl0Gf/9qbr5w==
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109fafd7so25975685a.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:07:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxC4wZzZgSItQg5sLZ4he4/jHfLJOwTnJapW4xi3lKKKoA/TT6EBQuPfQJIask9xZ7Yh+C/Kk/VYA==@kvack.org
X-Gm-Message-State: AFuF++lO52aLG9BdSM5zmMoL7HN/TQh7olZNXplC7fe0kbva+kzumNZ9
	RmxiFy+ShCYj62uO38x5TVUX8xl1ypu57anxEEtfBTCgDaQqAlTxOSdbNhNySPEpe3eVPKngBth
	/eotk9YMpPjiegH0lGKNu0hhTGdIVo0M=
X-Received: by 2002:a05:620a:4890:b0:93b:d79e:18f5 with SMTP id
 af79cd13be357-93c2521b15cmr97007185a.56.1790111243168; Tue, 22 Sep 2026
 14:07:23 -0700 (PDT)
MIME-Version: 1.0
References: <aq1SrcniIRU-8f2W@gremlin> <20260922041522.1824249-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260922041522.1824249-1-zhangbo56@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 23 Sep 2026 05:07:11 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zXQyN5VGpSmw+WG7bTV=1U3vJLBy09RExgno7N0_uGNg@mail.gmail.com>
X-Gm-Features: AcwNN1VMMORmWIts8ug-qgXzRG3bcKARIjn5Ah3mZqgxIFlxKviS2mK6Lz2-vvk
Message-ID: <CAGsJ_4zXQyN5VGpSmw+WG7bTV=1U3vJLBy09RExgno7N0_uGNg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] mm: compaction: mTHP-friendly memory compaction
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: ljs@kernel.org, akpm@linux-foundation.org, vbabka@kernel.org, 
	david@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	liam@infradead.org, rppt@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, kasong@tencent.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, zhaonanzhe@xiaomi.com, 
	lipengfei28@xiaomi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: uniqn4t8dank3dj8kxw34rqqadm9y7dz
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D85B94000A
X-HE-Tag: 1790111244-146500
X-HE-Meta: U2FsdGVkX19NO/K3ZPrEzonYVYt+rUiv4DFioIlFWa9eR5WcdE4Y/YA03CxOCPhoWPkB9HdeRkK0xKhKsVPsKl5nEWPeNQmWVeknC9KHUrO83cBc775tjUYtY/H4BdLSpPry0WCQIhiWjunXtjdnxiAEzoVGUtV5KX0rSpWYiZJcLRqHTPhm7VbucrhzLN5HjTwIxZqH5VW+ay8/2vdTUokAYLNA7XWmSjn18E/rt1Z3R+sFjLZmz9ZE0p2b/MNWJTbA8bkP/a89rYKm5u0S9Oe42G/0W1F9ZqRTXrrpjPmYZ/HjN4wF3NPKjnKl1i+kf9Bp0N6zy5NAWNXDAlBAwQRaNGt6abJlQwqsmE1OyJhJ9Q6rKOKh+CdU3bZxcAcJI49V7KCfLElE6AF5uA4azzFPS24o20t6Iz1yqPHELl+uqWvp71d5vKitMvCGiPu+awYQ8azQNqzJ92spSq4dgCE0YCuXVvTnKTQ7zgD+obwgcOmWS6o6il0dVnP01hq76v2S7zN+0ZUKNSpmit89RXeBWiY/m0pd2rPKaYkURg/F7/frLTIFJgC69s0t6w13ml1gl21NDuK0VjLyimbUz9pZHCPQh2cH4GPvj3v8oGx3XtU4ugEgX8LU3OZ8kN8PYJVcGAmvSeSnEUdmJpodjzCKwObz2lLyS0a+lW2GKya5RquITkT92SbXShvrY4AiWMreN59FCTv3psXHHmtb3Xnb30UPPqeBKVQ2AQlVp3sRuZvc4uxtc9ZW++qoI276iumtJbvNW8JnKsDgljopH/K418bUChlibTxzmxKDkm0exlLrnZGfQxKcCNjTTeyUIGJRv7j8GXR4tBZO/cHQsLklMGa5XId4C9hQXiaLkBZ2d552f0vpdM7l3DREmabGCqfVVH7J31g9rr+X552Oh1TVr6bNbZwXA6gTS0ussEt3fJ+svyoYWiAcEsSVK1ddDCX+sMTOcgdpY9dVKbV
 tNjJxc1j
 FprxnKYe90IZxhizwGc+BNVGaKU5vEPp3fmbmMCupAYao2A/JvWZmM+8HOsAg6hXkrj4aQEjiRZFp0TFxOYxhWfGrlrSYjQJtSULiw+998H9+PFOOn1IZbrfUJnZV8qTt6SPsyujJw6YqY6lMDhLeyH5LbL9yURix7DqUW+qejJ7T4ultVNsWZN1MVuB8MqPpOyu4vfNKpQykCb2n459u0frm4voBIFzzoygMHL2F6zRyP+OUxsiYGKw0uFhB6t4RqFkgU+u5Er+gOPKW0NxXxIOkQKpT1kWYinT1+ar1JH+qOuIpbd9bEwiTPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 12:15=E2=80=AFPM Bo Zhang <zhangbo0325@gmail.com> w=
rote:
>
> Hi Lorenzo,
>
> Thanks for the note. Let me clarify the background of this series, both
> regarding the AI-assistance question and regarding the scope of the chang=
e.
>
> This work started as part of our exploration of 16KB mTHP for the Android
> scenario. The overall direction of making compaction lighter-weight and
> mTHP-aware came from offline discussions with David, who suggested this
> lightweight-compaction angle for small mTHP orders. So the size and scope
> of the series is not me diving in unguided as a newcomer: it follows his
> directional guidance. Barry then provided reviews and change suggestions
> throughout the iterations.
>
> On the AI-assistance side:
>
> - All the code was written by me, by hand. I understand each change and
>   take full responsibility for the patches.
>
> - The cover letter and some commit messages were polished with an LLM
>   after I wrote the initial drafts (to smooth the English). The technical
>   content, the design (jointly with Barry), and the analysis are mine.

Maybe Lorenzo can adjust the bot a little so that it doesn't trigger
an AI warning just because the changelog or commit message looks
AI-polished? Perhaps the AI detector could focus more on the code
changes instead?

Please have a little mercy on us non-native English speakers. :-)

Thanks
Barry

