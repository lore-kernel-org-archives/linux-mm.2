Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD471CAC5A0
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3788E0063; Wed, 17 Sep 2025 13:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AEC8E0002; Wed, 17 Sep 2025 13:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB07D8E0063; Wed, 17 Sep 2025 13:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB2FA8E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:10:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61223160635
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:10:39 +0000 (UTC)
X-FDA: 83899381398.06.54794B7
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 87429120007
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:10:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="p/AC2p0M";
	spf=pass (imf29.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758129037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=15u2gJ63Nvc+ryjb04blM2EZvX2JTQ7zkIDCOHZzkRg=;
	b=ltVVNTQXOWsPGWZ4YJ6Hi2REh2X1MqdGHfPLOhCLw0raJfbjccVHgteJaxG6hW9xgNiEr8
	NpegM3Y+C+sA3JvwLGF/ka9Wgqwb+riejZfW5+ljXO9EUQoxjQ3p4u8Gj2h1iDs/sGPeRx
	j1VUnoIZbNCZn65xzQ6c6wuijbr6lvs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="p/AC2p0M";
	spf=pass (imf29.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758129037; a=rsa-sha256;
	cv=none;
	b=faSjT6TDB5pcdXDVyRxqAduGimwx6ZDzjm/x0QViZRfwNgmiTH7bmFxeKbfqLT8L6GpYQR
	3fHTfknjT39oBSt206ZJQ2qg/JCUzb45YUiDyfBwOYd7XmwVv/2m4C514OnNtm6jeAGegd
	19rajj7Rq8OCMR9rNkA9ZNrISaarA/A=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2681645b7b6so5225ad.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758129036; x=1758733836; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15u2gJ63Nvc+ryjb04blM2EZvX2JTQ7zkIDCOHZzkRg=;
        b=p/AC2p0Mi5PichnRhADO8fxSg3pBUFVJaw+gj0UtQgJUwfMmRhTwyjwfrdfzgW1m83
         ekkooJgM8wabO49me7KvTEldueICir/4+p7lkGr7tcbxqEozdzfni1JGjEYx5sTz2gW+
         cCXbZuB6zVir27CC2k5jDPXqUIMO67pKkKhDFY6UU5F3tYjVgfgfITS6PB4+qAInQKyi
         V5Vh8g1y5cnTEvLMeK80F8gMOB3K1T5BWjwvcfbZT5NOCL8Vvig6hA2+um7EsE1sihA4
         N5YmgWusGmduEBuvGAIHco5Ekz5zmOEJnA+UclSB6J/WpvBbUDZqz0Fb+aTlhZf5SFHS
         0qlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758129036; x=1758733836;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=15u2gJ63Nvc+ryjb04blM2EZvX2JTQ7zkIDCOHZzkRg=;
        b=mNa5SOp+X8d+hb28y7HtFi6MBClX+rf690NJgS1iyet7HIkVICquZZlBVM0RPcxPKj
         iuKZQfyTdIJJC7PIdnn/6p3WO8sxadvyJAsoV8JDrF6hma5izoyQm/d2AwOQGHmXLB1w
         al+fR4zjXN3ptItVNe+54Pk25T1T6qxIh/ptWcx38P3GLbQsFeWuZUzIzkUjcSDsPZ2c
         h7kH/kV/WOOevw1L+KR/WE3ynEUA/FG2t48+DHibE4lJgnIblSD2ka/mG2KwMNH4bR16
         PXTDmqLjaxeO9qhqfUAnNulwYHXCOAWfPNGRI6zXeOYlExdxV1ZNgvoipRm5nupJ9hnC
         xf4A==
X-Forwarded-Encrypted: i=1; AJvYcCVInGDTvzqMKjntavHnmEpjeQnhTrCJPcIqG0zwNUYVPJ8+rFe40IdZiNpAZGVcXjUNlE+WAAUnEQ==@kvack.org
X-Gm-Message-State: AOJu0YzHz8TaVBarttdF1og2DX6Q/ahXgFqHAwAVhFJtQrYM7mQq950t
	aWjPhFomleNfSe2YuriraZNUspeCVZg2zKc5OsSeQ5olB5fb1V2wp0cz1+S3cj55IrG5AOTpSP1
	UCDo076In+/tUwOJgzlhhtLsD+vy/Uj7D1uuf+hU5
X-Gm-Gg: ASbGncuuNUIBCb1McEvSA5KE4VIajhAwZQyd3DoJAZav1tSrpmwY/XRw8CDHyM23BuU
	+14SLlg7WRxmEv+HtYb+lJ1QfcI4yWtqZRO4+34DNrkil4ppAGmJlPJJSR9hyQ9mXXcuXu/wRJt
	JI4zjiT842hGI898scjK9fVGLNOfGZOigVAlFB/e6Y9jIMRuIQyVBMonHcfOxqTeuqUlxZL1dR7
	zC5a2hYABj9mvUYtPd/39nzEJ2RKbsLiwDOBwr5tVNe
X-Google-Smtp-Source: AGHT+IFd4BAxZT/ufICRk+rEAu4Df/3LlVy7dl8wb8UYvf1Vkm7Wii7RkWbyYEbSSxpnLkv8kfjaHMhL5z1X210qqcg=
X-Received: by 2002:a17:902:d2c9:b0:266:b8a2:f605 with SMTP id
 d9443c01a7336-26808a2fc00mr4248005ad.3.1758129035969; Wed, 17 Sep 2025
 10:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
 <20250915163838.631445-4-kaleshsingh@google.com> <c6eacb69-86f5-4bdb-9c6b-04e3f7ef7c29@redhat.com>
In-Reply-To: <c6eacb69-86f5-4bdb-9c6b-04e3f7ef7c29@redhat.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 17 Sep 2025 10:10:24 -0700
X-Gm-Features: AS18NWB7v1zd5wRtV4XjcNUI2Kl7h_0nJ3bBXH5VRcSHiB0MqTNwu-jJe9fGDsw
Message-ID: <CAC_TJvcXzrxhWFWyE7QEgPVmEJbnfT1W=s4TdgPGGAgCpn=8Og@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] mm: introduce vma_count_remaining()
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de, 
	kernel-team@android.com, android-mm@google.com, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, 
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 87429120007
X-Stat-Signature: on1petzgn1579eyr8k5bqyrf7wfbqnn9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758129037-565166
X-HE-Meta: U2FsdGVkX18sMOKRrjFcc+rhPi+kg9djTdrYxuJfTAXPVdo/g3BuE3JzcVqehtUzgtaN3NuRJDdcXCLRupTIYQFKpLCm0lvuBJl6uuhnLIyL/WCCRCY0vP+xm2Pc1dxsTCNDqc0fid9Avham6pKPoEpjXssV1SyQRLHNIZ5Jw1lpKDlM4Unt3dQa1/POhUE58oiXkJrauEqfdi6frZqo3npY6D8mUIMDd1KMWXa32n+SQF8gyIkMztFo/5YI2c3oGcsrmvgDcnhBYOZHFE1EbyI0tedNXmOd2je3x6CUuaLm8kQwdt5MIw0DaQ+GTnmlyn9HEU8tEAVwUXZpv24mXGOeM0Yl9iIRn+q0bdC32Ybl5z6Nd/eRa82UylKIM5NvrsmDjp+3tajeiInxfgumtRjW3FrkcqzMlvXT53Wewgvo/8ZGBtKwrncvNVaAv070ZQXuH62uhTDYuOAFKGfyGVAEaJXhJoZ88QEncOIkWN0NfRHw6yvhanZFGtCq8HRk8D/z6CIWcscMBpvpItRfnX+jph9eYU1oNyfTTwkgZoNfJHzMxd0I2uw4kvdsVwt26TzSuOzq4UaU17LARZYcj3v08kQDszwGOjIvrYP0gy2GBqIGNrWqISmUnZMKmi1EMYRkPrBQAx27/pc13gJj7/mHcIK0jGYQrHdZR/v84mHwji40JGIAP/uI60JjuLrVtJ0D1JKrpE6TffJz39tcl6n6EucPlDhi2vfNgcdBU8koqmd5cL5zx9YzeARfIyg8VSVw/iRMH1JGrekCPmkN4j1O21vAt8VXn7nEJpYtUiIfplwJcZ9E4UInhyZ3Ny3RQ0JN0/Ukggee3qjIwOW2wJWI33Zk1J0jZl1z9hvaBXe+woUyjzu8HauLDJYVIrwQF1AEqX6xlE7JU3tlUtxo9yhQEE4l+jc5AdPWM4ROllIha4EnAj/Y/7+vf4RmuhS7qUNm7R5OZg9NCMYKNjn
 SYvcQMtR
 +b0N88SCQ+8IMlQXkGa6Yvq/d+8vvIiQveVQ6YnCeTGQhmC9p3C73d/xXKF4rRtL/Ih+4dTb2dKloSrQqroH6Zwwhsk55s2WwIbVbHWyse+n1LXqAZ1J/JkoelTYbeiMMw7HTXHOaYI3xH6tz+3KKeSwmUpR7IYeV/1uy3/FrFi2nTUne5kaePFO3XigmB96kzuHWeTy/ExuwGX5b378b5SqAzy8XWXbsTUN4P6n5YgD8nLlmpL8vpedx2CY0wHJbItZEl+Xwjkcp27UcUdFZV8jsEQEtE3xwuMsUdul+OvKbWnFMKOK2TJd9+gbvtT6z8GYWTEkHR5p1jzzOZVhkZ8vvixocVnAaB6Ti42un3TNW7PeinB6HZBX572CnM4uGcJHA/RuWNbw7tDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 6:38=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 15.09.25 18:36, Kalesh Singh wrote:
> > The checks against sysctl_max_map_count are open-coded in multiple
> > places. While simple checks are manageable, the logic in places like
> > mremap.c involves arithmetic with magic numbers that can be difficult
> > to reason about. e.g. ... >=3D sysctl_max_map_count - 3
> >
> > To improve readability and centralize the logic, introduce a new helper=
,
> > vma_count_remaining(). This function returns the VMA count headroom
> > available for a givine process.
>
> s/givine/given/
>
> s/process/mm/
>
> >
> > The most common case of checking for a single new VMA can be done with
> > the convenience helper has_vma_count_remaining():
> >
> >      if (!vma_count_remaining(mm))
> >
> > And the complex checks in mremap.c become clearer by expressing the
> > required capacity directly:
> >
> >      if (vma_count_remaining(mm) <  4)
> >
> > While a capacity-based function could be misused (e.g., with an
> > incorrect '<' vs '<=3D' comparison), the improved readability at the ca=
ll
> > sites makes such errors less likely than with the previous open-coded
> > arithmetic.
> >
> > As part of this change, sysctl_max_map_count is made static to
> > mm/mmap.c to improve encapsulation.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@redhat.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Pedro Falcato <pfalcato@suse.de>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
>
> [...]
>
> >       /*
> > @@ -1504,6 +1504,25 @@ struct vm_area_struct *_install_special_mapping(
> >   int sysctl_legacy_va_layout;
> >   #endif
> >
> > +static int sysctl_max_map_count __read_mostly =3D DEFAULT_MAX_MAP_COUN=
T;
> > +
> > +/**
> > + * vma_count_remaining - Determine available VMA slots
> > + * @mm: The memory descriptor for the process.
> > + *
> > + * Check how many more VMAs can be created for the given @mm
> > + * before hitting the sysctl_max_map_count limit.
> > + *
> > + * Return: The number of new VMAs the process can accommodate.
> > + */
> > +int vma_count_remaining(const struct mm_struct *mm)
> > +{
> > +     const int map_count =3D mm->map_count;
> > +     const int max_count =3D sysctl_max_map_count;
>
> If we worry about rare races (sysctl_max_map_count changing?) we should
> probably force a single read through READ_ONCE()?
>
> Otherwise one might trick vma_count_remaining() into returning a
> negative number I assume.

Agreed, I'll add the READ_ONCE when resending.

Thanks,
Kalesh

>
> > +
> > +     return (max_count > map_count) ? (max_count - map_count) : 0;
> > +}
>
> Nothing else jumped at me.
>
> Not sure what the buildbot complains about but I'm sure you'll figure it
> out :)
>
> --
> Cheers
>
> David / dhildenb
>

