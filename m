Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A02CA5FF0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 10:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E92A6B0088; Mon,  5 Oct 2026 06:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299BE6B008C; Mon,  5 Oct 2026 06:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AFC16B0095; Mon,  5 Oct 2026 06:10:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3BA86B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:10:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 724821C0C4F
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:10:55 +0000 (UTC)
X-FDA: 85288154070.19.B12F7FC
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9AF83160005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:10:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bk84P27p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791195053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1WU93BRn6zCXOoz/61V2atK8qi7X3MY5yMsA+l4Fdc=;
	b=LMVmk5io4ngNjrVSY0XkaZzV9Psscmlrctl29q/pYQlF0b1ZPcvZAUdd6LYi9LFHp3kH/V
	CP4gm9sC9qCaXnndKFE9xi+vG82Bq60TQq+6ajHWHcVG5URTEnDXs32HOYbmFvrvI3Htwa
	PYiR0T4KdhpswQuxJrSQGGtQe19xR0M=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bk84P27p;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791195053;
	b=IkshXu6OWSOfmzMXTSBEzfLcZ+mXC9sHETRwntnxTr4MBEBo5Du8nyDtzVmb76bt4Yuw+2
	hoSzuHk2B4dseUQyQ+E4Cd8SfEdm+zZx9H5dZ1hfVK02EmItzyIOFBWKy8RdM5MFTBiXSR
	Yh64EKDvJhq+PoYEg+ULEO6SDhjeKak=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-85469b355ffso483113b3a.1
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 03:10:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791195052; x=1791799852; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=V1WU93BRn6zCXOoz/61V2atK8qi7X3MY5yMsA+l4Fdc=;
        b=Bk84P27pbrmdsKmwDgKQzaY34ExGoJ1uGXNpKs8S/JFlY4y5k1/myQcSp4C4fxqEPO
         FQUEL6IcTubbr9LbA/FwGFalhWpoZyxEtZ1SWiTDDtWF1D55MfikxBXoLq/fCAWrJGf6
         0084UcvbJ+TZSuka/uqts+OC6np6a+ucFAtHpZGwR5KP+sXrPXxNDsH6sXdRbpVa42xa
         rrCS7AuEuu6wvTQHtc9ZeHLlbrHmiSnQXKlmqlMMupnLw6fWx+sV/ENmX18B9Q8KdWnk
         g/jj3XN2InU+YWr9m85EYInYHdJF36e/N7JoLUf0OLxXZvXwcWf1eXfrJSklqdegkgEf
         hZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791195052; x=1791799852;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=V1WU93BRn6zCXOoz/61V2atK8qi7X3MY5yMsA+l4Fdc=;
        b=aqhNNIEqQIqKnprFchcOOi7NfvWfl4l5tsHiqUzn2BLooiWW+WymyEjALsatdvkxYn
         l8lNuOwCF84xKAgAmgX5nmNGZO+6DQI0Fb0AnKMwgUBEY5QJokhIxwBN2xsjK+unF2EN
         6+PK/HfeESHaOEE57yELInkGoU07+Un5d64HgNpqDGrO8cqgZck05P7M2Efki0iRLVFM
         cMKeRC1JwhvNVgdWnbPuj+XlNOUIMPnkrPlJ37K8msN0s1gn5LSMIjjSInJQs83mQBtc
         nfLoCExlKi58BzTPzUI8ZaUTi4uGFDwYrfky8iBS2R/ks2i7nehS2zQR7AaT4bQ0QjoH
         YSFg==
X-Forwarded-Encrypted: i=1; AKwUvBzQFsQqXLdXIQ01gtXcvb6czXmMT/fVf5g5XVGS67GFojVksXQAGBCR8Nvs3Ix9OsxLd5a1IUfa+A==@kvack.org
X-Gm-Message-State: AFuF++l+bM+VLAWwbJwKb5GZvSoH1TV2HnjEZlR4u3DPtnqKQQ+5FefO
	41mcinISVlT5eMEQCPuys3FXS5fAAuurCiXjltLhlIMPcWGSp7eAKF7Q
X-Gm-Gg: AYBFou2gL+iSKePDk3LR7ROnLhDat9wBJp+LZ4g86L3c/fkBdqUavOdAEZtzfuGsoLM
	Xpw7XAuXbHTfUW42qCf2SovdPNbuvZhcHub33Y8biQ4fwxQwJUsb/0VsTSNVLZ8fwSCHAAtwQqj
	wx92/MSriAfn4Q7O2ADqouzm93YzK+hzhpgQP+dzLGWAP+Y259bUREWVjH/CZywlxpULXfBt8V1
	Rp9avfpQnmIN8IimisKd7TwlqDh8FeyDpKQVaWjuFi5jYTh/3JPbbY8SgkIHBGIikugIvJKmYJe
	te2iiNzq9fMXZVXnkCxqlrQBucE2GhElB2IvQGBPu0TRy9f0KjK2A24wqOaj2fQyyg/ZB5Is0b8
	HCWYt27HcBLVg5HnQe13pRA3Go/FoHE0w60ChYfBYX1JD4wETXbJK01+yg3h1cdPXDZCqvnCP4Q
	q2sFLIncWt98au7JfTZ6NkF3+jSG8JQbqsVwr289xdCzxTxc/botbCvECHYXwISvnwjteTPEOQX
	Lw3WCxeIGtpmA==
X-Received: by 2002:a05:6a00:3d89:b0:88f:a337:2e31 with SMTP id d2e1a72fcca58-88fa3372f25mr674533b3a.12.1791195052202;
        Mon, 05 Oct 2026 03:10:52 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88b0ca7c6b7sm3219752b3a.44.2026.10.05.03.10.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 03:10:51 -0700 (PDT)
Date: Mon, 5 Oct 2026 18:10:45 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org, 
	ljs@kernel.org, roman.gushchin@linux.dev, dave@stgolabs.net, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: vmscan: don't count per-node proactive reclaim as
 memory pressure
Message-ID: <cec875e1-2afc-44bf-929d-b8f2b2a795f8@gmail.com>
References: <20261005062236.564210-1-vernon2gm@gmail.com>
 <20261004233615.df26e580c1bc916c7f3a23b2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261004233615.df26e580c1bc916c7f3a23b2@linux-foundation.org>
X-Stat-Signature: ume61s79efikbdcsweaa9cyzhmey3b4x
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9AF83160005
X-HE-Tag: 1791195053-912048
X-HE-Meta: U2FsdGVkX1+0SUEx6xoTz2/CGOi+fW4tU31JDBazu+aOUtyuFYqnUpODi9TiZNL+vkMkmICXQ8EGOoAV0Y6DDUHMgkNJo4BNU7JqtOORap9Yic/O447dMDs9NHPskcSe+qV2oMxqcbcv4E8rplcIBBu8S1N61YEH9i4QpNfOghDS2riSe9fsvZ5VvMe0GdhD1kdQH2IxwEwbmRTDyYwypGUCAcT3PO+BoLkLuNsfG7sr7drbpRbGpEr3DNNYMUGImyNHDPvOVC7IQm9OQyKRrXY9wsY7OseQXf0Rd49LaI+EIcKN08Fpy8uKMYPN4Edx+S6gwsyt+jzrOze6Ei1ONazBKPOHRit99QSMVEnpWzWHk4DKVVWV/7jv5ByT99O8ePRmW/RY9RQeD16/WpBXR4MBtT35MLLRx8D66wDe2P6fQ9reLO/SlnbTJ5kWmH3nrniAUAosgVKGgWeDYAcvX4f9tJ1e6ubhu0BxQf05/wUnuvPOoBBPu0U7Tlvr5RAKPj9QLRrFGI4Q5rNwjTcM5g7vdji75TWBXUNKbV6CHiUMl7scHQls3f9Sm1uhEMsH/KvqKWFIEY0j/BSkk353NRAb4hosE4GrfwtEIzl/8SEnlqyo6GxTUdiVc/cwF3z9jVtNWs7YdLy0gYgLDInURqM0i27ekB9u5rDD1gnHR1rQdOOLnjQroVxk4SeuTjZXBXp8IXv3+lh5eIKSJbtfhA5lJwkR0QXmpHuoGmbMbdqLUJVfPlfffIocSJXze+p/80zIfl6rtKnHj9cDKuE4h6BbfNdZ+T9ICCMIXmkC/IcQ5ylPwLFN9Jn8hXYA+xKTqLJVQycAx/SQ6IZvnx2c8WaqQwVibs23lCzaJCSUhJBU93L3/LI6juJwt1BGtP6oKWewNX7eALyVr/a1lYlmMmTfYWcxRHfRx9t7aihZhVvIkrTzzP8J7wzGWhkdN/H4Hy2XCsBTxXYBWM770zH
 xRBSzWHd
 acU0JtrlcrC6AXTEu4YQnDXwP3R4EnaRGnWj0zjh+8CeNiF23WpZwsAzQgrMPBGOAVM6N1z2KC5yTapDp9fhmRo08Pq09JKZkFtUjhsY/Fm3FM7XGbc0d4jkAgDz9n86olxQzovaXLK9aKvc/s4St9TClGkFZRwy1GIABLaw2s1hrhLIYsroLA5cCK15uCXB+p2C5lCF9J1xoamjwLlREijuoEmFnI3ZxeGa+Pd9yWGoroWEJEauiE272xeWFG/tjdJkGMkcfkdb2jFFETi5QF4UP2foPHAQgB3SBDWuFtQPwlbJgz+G9lpMXGbWxz6rxznvjKtJE8s+CcgvU/B8zYoINJGtcbwtHvUozLVdV/cR+JUN1vtmT/KRw+DMbdMnAaGBfeKkUkxrnjtJdD3pov9jGGYAR6O9gCjC+sSyTRpw3HtLggvkXB/ou0s9+5HMMzlrBCaaK7TlpTLKzwQOgKZKM32G+nj/wMOculWgQG6DIxi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 04, 2026 at 11:36:15PM -0700, Andrew Morton wrote:
> On Mon,  5 Oct 2026 14:22:36 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:
>
> > When the cgroup has no memory pressure at all, writing to
> > /sys/devices/system/nodeX/reclaim triggers proactive reclaim on
> > NUMA node, causing increase in the writer cgroup's memory PSI.
> >
> > Due to this reclaim is performed in the context of the write(),
> > accounted as memory pressure on the writer, like
> > commit e22c6ed90aa9 ("mm: memcontrol: don't count limit-setting reclaim
> > as memory pressure"). This is unexpected, the phenomenon resembling
> > senpai will appear again.
>
> What is this?

This is commit e22c6ed90aa9, which addresses a scenario mentioned in
memory limits of a cgroup, in detail as follows:

    Currently, this reclaim activity is accounted as memory pressure in the
    cgroup that the writer(!) belongs to.  This is unexpected.  It
    specifically causes problems for senpai
    (https://github.com/facebookincubator/senpai), which is an agent that
    routinely adjusts the memory limits and performs associated reclaim work
    in tens or even hundreds of cgroups running on the host.  The cgroup that
    senpai is running in itself will report elevated levels of memory
    pressure, even though it itself is under no memory shortage or any sort of
    distress.

This is just to explain that similar scenarios will continue to occur,
only this time it is for the /sys/devices/system/nodeX/reclaim knob.

--
Cheers,
Vernon

> > The Documentation/ABI/stable/sysfs-devices-node documentation also
> > notes that "This interface is equivalent to the memcg variant."
> >
> > This patch unifies the semantics of the memcg and node interfaces:
> > per-node proactive reclaim is no longer counted as memory pressure,
> > and the per-node proactive reclaim interface no longer produces
> > phantom pressure.
> >
> > I ran demo[1] that performs per-node proactive reclaim 10000 times
> > in qemu, writer cgroup memory.pressure as follows:
> >
> > without patch:
> >
> > some avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> > full avg10=31.53 avg60=13.42 avg300=3.31 total=10602985
> >
> > with patch:
> >
> > some avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
> > full avg10=9.59 avg60=3.41 avg300=0.81 total=2686221
>

