Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0869CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 20:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AB3D6B00BE; Mon, 18 Aug 2025 16:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 583116B00BF; Mon, 18 Aug 2025 16:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498AE6B00C0; Mon, 18 Aug 2025 16:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35FB06B00BE
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 16:33:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD9571D826C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:33:31 +0000 (UTC)
X-FDA: 83791028622.20.1886E57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id B54031A0002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:33:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QN2t7qCS;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755549209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ysk63aUoAjmutzOkQmAI1cJp9CGxAlDu/k3Xg9fXZTQ=;
	b=ZCQ829dbWWwwzX9LCDKE0whRiv/UKsF4O/KvMtRTyrp1xIOwr7bCZUceej2YXeqQvPghl6
	/9JPAKpq8oAEzlSW5cTIC3mzsJNZRa3CvbtbFO/7avaEmwynwC00/40/ejle6p/d69byK+
	pklZuasnhzm4Ys4XkwmTbqUw5islTbI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QN2t7qCS;
	spf=pass (imf19.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755549209; a=rsa-sha256;
	cv=none;
	b=JBEoM7jcS6X6XBTnhKEebfELgFTFuYjGSfIMjUkjfnWIVhK+7U9sC0OjKsbgLvBqbfNdXX
	ban2Ffi7u2LxXhxoonh2vd/8z9q+pIcjYlQOBjagH9cOyYUgVSiUwy5gSreuzX9m/TmeWz
	qRebIcSJ2L6zSRGquD+0KFetjkayPpk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 710A4451CB
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BEAC4CEF1
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755549208;
	bh=0grDu4TlIM6Bxz+SXpvxsWdWaHdxACyGKxQJCimpybU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QN2t7qCS/gTbPJAQ6E10ozYfTW6YlG+SQMFUsPdQzjUjQqJciMV+77iwtRyHBbLk4
	 O1TpCEY7YTVCCxt+XNQ8lDTp9izStZZdmljZUEzH2DfFrFZXKQHnr4EHrbwmgakhUI
	 tohDN7dTXI3ehzYKcPTBPdXPQLi0rHA8+ynnKcSJlIXHe4xXTEK4f+hEivM1j40th8
	 DFd2BlAXIITGmgqkrfo+6EkxVYxGV6bxW2hZk/zhVc+JZYHs6XXJLa+hthpWOfIFPd
	 l11DcOVHFB86fiy56/sGeoVfD/DiUPItrt2OLPd6ogWS1Ro2POzlVgOodTxccXNeqK
	 VSx2v+7+6nzEQ==
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-459fc779bc3so5745e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:33:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWO3cRAL6BQjxeZ3HiOsPysn7aHJtgZKCp/LmsQjSY/e4ejr7zhKVvSmJOY6dHO2vl9D35+Vz1NmA==@kvack.org
X-Gm-Message-State: AOJu0Yw6mJHnv3xGfuI2w+XucycrO7lzKd45cj9s8GrYQ1gfQLu6nq7n
	g/VqPpopd6lV7E9iizx/V7wdtocXGCbooZv9iwc9gvQPdojqtQfTgrftQTWtKYuL7vPcLA6O1eK
	1x0WNgPOjFTBfQ1IVONDGfPnFzaClej8LIEyAC4w0
X-Google-Smtp-Source: AGHT+IG4uVj8WtLu6RVGY+veaDWTkHp/2BauSJRgH5ZTzXihTTq7HI8p/iecvTt1+XFX4swuUe4k8TxGcn62xrRXS4A=
X-Received: by 2002:a05:600d:b:b0:442:feea:622d with SMTP id
 5b1f17b1804b1-45b43ac33b5mr10905e9.1.1755549207039; Mon, 18 Aug 2025 13:33:27
 -0700 (PDT)
MIME-Version: 1.0
References: <CAF8kJuPwfRVHpvNRr=1NT4z_3Pmr-1u4vfRYmkvh_Kh4uNGy9w@mail.gmail.com>
 <20250818181800.59827-1-sj@kernel.org>
In-Reply-To: <20250818181800.59827-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 18 Aug 2025 13:33:15 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMJzWzrZDzbXtjUsp7M4546pS7Cjgc8ksu4RcGW5_T+Zw@mail.gmail.com>
X-Gm-Features: Ac12FXxPf6XYh5boVgDdp9E8nhx0iNpxsxAH5CLfhy1_uFfxEY4eFGtmdDWkmmo
Message-ID: <CAF8kJuMJzWzrZDzbXtjUsp7M4546pS7Cjgc8ksu4RcGW5_T+Zw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B54031A0002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 6cns73azg7ef19admc1ttygz9yjfeo16
X-HE-Tag: 1755549209-141562
X-HE-Meta: U2FsdGVkX18UspuMmF1deZKy3+jf9pfCWR+XRik/fzGpuf6HCndbDhi6NJJ6PnxcsDWJ+jnek6Nf5QKIcoO1asxOR/igDhwyVpkoZPUWJHGQuZf5DbNYO1t+BVlf56Ekf9vR5b3iSfAVLlWsuOadmo0RK/EaRQLcX5tuvIgRxTPXm0kpp7UpJNBPLFFSHnda6oTng8p06+T+26ZsqRhGhTnnd4VdHFA/Mp0QAviGhegZNu0wI5Qo7nyjyGSKLv2z0vGZTaGJ/4MuOq0S4LUwlurqOuYiRlyGJFHPZS+e/nxYHPQi+NY1edMGteTPfKfOwmvbbyxGsh+J4maKvQEyNv40sbf9kR9ZMln9OJR3ipqNpOFSY1nlb6tYi4+dgWB0SBQKEGDTlnP+SPua/g2h9wAc5tvq4A9LiRjs9OpbWtDprwD6VPLRG60bHPUj0sLLvbu8xk2q1ETFxflMBpJtyJe9ETVzlZ53EcjPkU0e0LkjQCGOSIrUfp0wyRvm/5ttWP5cZVMMApl/35HKatMryIiAZtccHzLKqmeedrK1mR+xQhF9C0T4U7xxIfniRuuHyh7Y68es3N6qaHGloYGuUkZ0H35bh/TEWrtwnrb80HXDraYAD4rxRXbfvupwNfkA1i3M1+GYU9OHCMi0OcZF9nBEZiguL7K0gJDPj3FMs6Cjo7s/xbsNYhRIuDlhPuaDLyXVjWuFN+//9KGFChvZ2hWOWJSzNWhWD+LSCgLp1DUfsadncefvh90EjjK+YFwplBhyhwlXriivYYBNXrEgqs+XIi1sCbTnCip4noUBenLCJQZJQoPF/p57BmYTbjrX10r4qU5G4hxaswlpH96MNRwWQYIzPmq8C/odH/WND0C+sfE51rGu9DOa6ezBH2Dq1OlaKcpwpu9Ov9y4kWyZtJnVbeIBx2l7c3dGZHWupywhDQxvkd6rrYq8/XEqGkqwNoWUYSk9KeIbc+4BdMX
 PC0KCN3y
 hmLBQrNpUwtgeuvrPhQKICJOQd2SNn4Bjp5brXIqA7QfUEhz1/HaMK7uPz2gTZIwLeUWgGRuOSP/In/L+2DkNC6ZHO9ZPNl1CNOMh3wLtT4TLJdqZP6TT/jSBg0jvFa0Smx7olx8Z/sqwC+CfagcoMCxQtVu/EHRc/HU3yu333MriaTjUtyc3Wt0PyHW0WSa4Qx41rco3XSkLKPTb92gv7HFMXyHdA4xXdG7kgHx9mXfQsr6rVMx8BFDwnXwGfYaXvogIDzDP6o+8C3gvzmBxqxsPJRRKigFxBnbbK60NoyYmMe7ADwP9M9Vp+x6GZbSp5LfsEStmiN6CCi8jsopZegC1SWTFgqgNveuv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 11:18=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> On Fri, 15 Aug 2025 19:23:10 -0700 Chris Li <chrisl@kernel.org> wrote:
>
> > On Fri, Aug 15, 2025 at 5:14=E2=80=AFPM SeongJae Park <sj@kernel.org> w=
rote:
> > >
> > > Sounds good.  So in the next version (v4), I will drop compress_fail.=
  Instead,
> > > I will add two new counters, namely compress_engine_fail and the new =
atomic
> > > counter, say, stored_uncompressed_pages.  Please suggest better names=
 or
> > > correct me if I'm missing some of your points.
> >
> > Sounds great. As I suggest in my other email, if up to me,
> >
> > "crypto_compress_fail" and "stored_incompressible_pages"
>
> Nice names, thank you!  I'll send the next verison soon, following all yo=
ur
> suggestions[1] together.

Thanks, looking forward to it.

Chris

