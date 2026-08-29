Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CBAC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 14:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD496B0088; Sat, 29 Aug 2026 10:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AE596B008A; Sat, 29 Aug 2026 10:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D756B008C; Sat, 29 Aug 2026 10:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E52E06B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:32:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77BDB12015F
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:32:33 +0000 (UTC)
X-FDA: 85154547786.10.D57CCAC
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 82AA940003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:32:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W03WoKmJ;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788013951;
	b=kguBjtq0dZDeqATmuFmPeOg5TiI0dpRli/4jpxovxvzTdBU+TmBsNjgiVBEle3tts69/fX
	7FvORbO5ay1wqO20tuiP3QOop5HHyXXIyTjGe179QBrsApbQ2fmDrFy40PLyFD6n6F8PRg
	QegI9llhCF68O3/IJCWk+Yekxb5aC8M=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788013951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hygF3KOg5K3j/SEn1AwfTDb0LJzxqqJ+rrQ/Ud785c=;
	b=lK38PhS8YvFdE8B0TyAS3asZyYrHf0HzVSpAg4YbRWua/+DMPAGqy2NDE+0HW5b+GyjDZZ
	g9/+nF8t8FK9lLLRjYN0FabwSxIcxnOZvpCIJWWgRF/2qMaCtV16PodaFLvPuuC+0KJ90m
	9Eks3KcTO1tUcIV9r2KVhZa7vNEHmc0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W03WoKmJ;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2531f453eeso321951366b.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:32:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788013950; cv=none;
        d=google.com; s=arc-20260327;
        b=mWa2NWObMFdHMPMZo42WDA8csjyNavYVbNHXEOQ4z9+3idyTb/0iWF4PcV+Ko8sDhn
         kUtCxBE7Uke0d8PN+fkBJWWxFLiKPD14n07TP1yNPiYakRwDj/qiRrwJ+RfvdBHKE+l/
         mMvNIq7T6Pt8mKnohIlvL9EqwXrTP3+aHuM2DHJM03QDjBHzXs8eCcdl/9d5UpqnyvKF
         4Nu9NDmPRdrIQ5l4S7rlWT2FMXZfdUp44lgfjlng0JLiTqDGuLKfiPY7icwc4AfKTyOY
         9ngDb+lZY7LcVjoIdTcpuVli7TP3o9v+o7utFLzPt9Az5wViuRJ8BH9h9MV7XiNMjx4o
         nz4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4hygF3KOg5K3j/SEn1AwfTDb0LJzxqqJ+rrQ/Ud785c=;
        fh=80R69JB7Y4KFgKR0XKMvv8hW/lenLHalPWVVAuKzvM8=;
        b=g/Cg+K/2Syad7qXs4z7PIm5BcK3CCkEJA8tc0zF41FHI3IlhMWgj2qVglnJdoOakaA
         6do78o//eWpuo/yhetrTyw7Rw3JzWFqceMIXMsjLtGx5xTFLK5QLmuokn5ISAr2MGEuf
         JzpLc5avCBxbWzJJQmEPEZe8vJHEZge+LNTbd16X7SW9v71ktGxeGPg1431BO0HiRB+F
         4a5rXjoxOaiLu3/tQe/XCEhi43lix5ymzWPycJLxfeQZ+B3TthSAq2cnuWquyx9IphqS
         mdtMc4SqJQ57/q/4hoMGATASIW7kzrBOe6P7qoC8BaD7Ewv9V46Kf6OZGLXT4cq3BN83
         0ivA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788013950; x=1788618750; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4hygF3KOg5K3j/SEn1AwfTDb0LJzxqqJ+rrQ/Ud785c=;
        b=W03WoKmJ4zl5Q30ao/0p7cUu51hWh/lLTEB8sJzPyLE21BH7tzEX8ngREcxvAdjL1I
         MqzRsXgWH3p5vzC6CcFJwRK3rNQps4TIqHKvBgYOMo1fbARCxa3FTuC27pmnnCtL2gOv
         F8Q2i1d2HRKTgvtmQx9vFOmswcWpVwrAX4THfHGbjlfrvRlrtbiXGmHBUuf7Zcr7I2FX
         odHoPn8MEOahzA8rS5P5qAsJW4e51WiWaysNxo8RAZOR2Ir0MZZXmNdpwdLkM39Rtsdf
         lRakAgmdxIHxBgZTAn9IPUSEW6G5ONaXY8cRkHCmT5Ar/0Ten3jFNZvqsKL411NkBKXU
         g9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788013950; x=1788618750;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4hygF3KOg5K3j/SEn1AwfTDb0LJzxqqJ+rrQ/Ud785c=;
        b=eoWuLU7HyUcKVinhvJgCvJmfBXjLaUfRNKuDWH/HPK3oip0ilyG7k0LLKJ75dIaAu+
         mEMgZVzBptOwEtfQ3MbC5Bls2bpghgbHk5VdyStO8QEx2rR6l6ALEet1uTyin8txQWBS
         4x6Qdm1Wbi6FKXm+vlEwY1kIuPJkTJSOd0SD+zIkVaaqffKyNtMkk5TSJMWO4fLj98mZ
         4GWIjYxIPsPybaxEwnDGJPH1ix9y93cqBTX41of1e1aPoiyz15WDTaUkKTH84mmajuij
         HSxXi2xlceHK1QYzKxTXs5MoGMyAqeMFlLLvKrWgDbFRDV1bK7raxWd8OuGnKJpzHUIl
         KtIQ==
X-Forwarded-Encrypted: i=1; AHgh+RorhZsyIX0SX3gBC/cixWPsOtZtgjk6hstAyOBCNS7Be+9sbRJWJ3kzT+ZykyWbhBcmHuVgn0TMpA==@kvack.org
X-Gm-Message-State: AFuF++kQbnLJeGH645bWRnHdaxjBoScC2GJDO5fHXlxJk/n+BJBjP5kw
	QEEE40ZUTusrSTwcvJNjNEU7NInegznTngHl43lXsQUqcQO0h19f9LaKITetWmmdAIbrYm8oVVf
	ywyWP1DUsBXoxekKLKeZ6Gs+pgErc9Fc=
X-Gm-Gg: AR+sD10AIhiXjtCGKyNKCSR0aVcX8p5RVA0Gjz2ygB7/FCYQq31GCmnF9SY/mRmtiI2
	o4Wn0bCS3h5Z7adrajAO3ySbxjVBE6YBURE7zzfSLlt/7rPZYpYtr/RTIf5/2qOfLrtKkJwAQwH
	iHxlxxMCkp0t6rXS5LyFOChYyQ1DN9BBK4IbRRfiunu+8ta11eOecyKtT9Jft0I5YBiH/pZis05
	HORg8sIIbGI8JqDvpg9PHK/56qjiEqapfs7othrMcAbq6eIahCRSFfULs5PodUhsYbcATD7457N
	xjq8xWYdDMJVv1Dmj387yVN89Xy9K8zFgJ4RtXX0vLPmdhF7Ybi57ackzzJaq5Dpxj7G/3TG0by
	JJA==
X-Received: by 2002:a17:906:99d0:b0:c25:6210:84e5 with SMTP id
 a640c23a62f3a-c256210a3f9mr776428566b.14.1788013949866; Sat, 29 Aug 2026
 07:32:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-5-d9f1c75549c8@tencent.com> <20260828052949.52874-1-lianux.mm@gmail.com>
In-Reply-To: <20260828052949.52874-1-lianux.mm@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 29 Aug 2026 22:31:53 +0800
X-Gm-Features: AcwNN1U1XN5oJYNoIA4DZfdB5v_IkrXwFftUeLIhH3MOVieiywGaW9p9wEVYMfA
Message-ID: <CAMgjq7DONqF_TZaxtez0fVzxyNdiAzMBikM2nKdQojRqX_n-rw@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] mm/mglru: use explicit tier range in read_ctrl_pos()
To: Lian Wang <lianux.mm@gmail.com>
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 82AA940003
X-Stat-Signature: cs66yg3jr6co6o5ifcx6ozb9u4ikhk1z
X-HE-Tag: 1788013951-768925
X-HE-Meta: U2FsdGVkX1+M+tNQTMyHbEMjLE0426zp+lhzqEUSfh4hT/cZlvOfMRNpO1dyLgvfLM0IKYyWa0Y4FesHnLYfalDnRCWheYot4ewT2rpiXQPjSqkycfXKVkqAnBkLd2Xu2Ax8CB3uw/e7NTqQemaD8GRE05y9jO/6NJcibwIs2lFr/H0K8Xg6YxuOZdqmce6n6eWdYj3EVFykq9Wk+dJq7zYj5mZh8R1i/7qKsjRGrDyuqVorKYSZxhKLmCZ4VxDsJODKzikBQ8/3CRLXNRmVZ0cU0sQQJDFPrY+Tao5IpF1ZLGNuSUG0gHeyV3uAPn/3QB7W7r2A+o7Pw68Pkqx7eXq3BIeAcatEwC1rJk1v8kKtjQGEVO6FOBRNMg1EV6gJNNIi0t+rrcO/rXL3QF2Z+PPTpDT6AbwAxJRWulmXj3TgKG2BKehEIWpREPDb6urClfkaPR33hNHlbGnhqgiHjXlFywNSY3QFNYIfBXKRxLLH/0QQ/013qxWFHKXDAid1sn5uRomjDR7aw+5bLFlNz2RVx4CF/5JGuhNUlvyGj5n987v0PIrd2SpsVppN4bUgfr15VzqCbAV5nYZ6QvVRADqTH2TDYnSuQ9nQtzhCNwZf2G3LSiP2wk53szRfCbNIZ/vgcL3BtpUOhSO9/hzU8uGy4/dA4rZm2dByfKgXqqXl7i462FaeQ3KoHp2JmcqRDA20VQ9T+Kc6tkHMLxAeBNXqMd5TWaP3+1s6Xo22PUgewMxi8nuRHBRQgkK+icQ+pkVvy5kywlGlNwHQNYPypyQSBMCLRjc/gY8NLUOdM8l53jWSNUWJ1zB//N1dBT09iKmg+dFr/oD052cCoMt6Bna/5mKy8SZitEk7ZvPGdCxl40+Y2kKpHqK1Tllkz/wHcpBR5M0kEC5LzKLOeLTTNR90zQynYWcdORi+sBDEwgc3zbtzOMc5dVJJRNBLeMPmiTAoLo4CMBfgoT39Cg9
 tRgl38pA
 DS70lmYZcNyncqVbBPde+XDnR/1wvFInKhph2/1lqkSzF+YT6WKF7qDV6kJ6HDFJ2ZUwf9Z/3hK13KE82yJv7mvhUPuE5Aq3sFvlquF/3IhReGLlDNtHgWNBj03j24prvUuFj46YqjCf/iSho+AVu/qfjU8+l6oPy8mEQaxz6kjNJ4B5/t8rqOcoK5G4L0dDHhH7Eh0XbqnbQ1ZiAh10xaOa7aPYkdUgSr4hzSySqz7yMAXAJx2NMGMJ+MHKwXiTPJph7cq1OSTcG5bhujdCbJ02NTxC7gsOcJUcx8hwX7HTMrKQeEjP6tLdj7oJQOAICZ5h32ul35PMuPvEgReUIAwZpLHcawWBR7taQga7c4Qgf+dHuKKtPIXCWuhQ8bBRaMBim2/Wp4imEt23HsJjn1jwm+m1cShfxyJW1RXzOTXVOuQB5SoodJ9n9eEGd+PweCFVWtN9N9lrhktLDqpzkhvPsh+mAzQ3lFh7y/dqxRqvF7pXVGELlx8UV3yYXEOF8Ku6ZZf2/QzuijdhdLatokyUSePtV2ys2wE7VEtnXzBtbJI1p86FztfWnRYIxiGOYo4FCk6cOJdpmBn5apj0OP55oa9zx5UO4w09P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 1:30=E2=80=AFPM Lian Wang <lianux.mm@gmail.com> wro=
te:
>
> Hi Kairui,
>
> > Replace it with explicit (tier_min, tier_max) parameters using a
> > closed [tier_min, tier_max] interval
>
> While touching read_ctrl_pos(), would it make sense to add:
>
>         lockdep_assert_held(&lruvec->lru_lock);

Hi Lian

Thanks for the suggestion. I don't think that's necessary, though.
Nothing will go wrong if the lock is not held, reporting warning is
kind of over react :)

