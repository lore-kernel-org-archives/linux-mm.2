Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A073CC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 12:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CADF6B0095; Thu, 27 Aug 2026 08:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2826B0096; Thu, 27 Aug 2026 08:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B85C6B0098; Thu, 27 Aug 2026 08:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3096B0095
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:14:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D039340318
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:14:45 +0000 (UTC)
X-FDA: 85146942930.22.2FE6ED1
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3792C0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:14:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P7Cra28a;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787832883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSHnkXRfsNN4v3AaspGwGv41RH5tRYCNnIdkFoLAWqM=;
	b=6JoPU/PQZZVeulYHaK5KvuEu1YJQlj5Zt6HUkMdoE26UdxlQ98+cpC/4PyCHtHlhXuNO+x
	s6Z79amgVz5EuNqMLZWURn3EfmZgxLqtr1iSgajSYgrkogHEIUALCmxqOobxt7omIWg9Pg
	9DfuWgNqI8xQJK2hfYtxM95KrUQfqzw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787832883;
	b=aKQxwPiQBLiylJiPb2luy6PZqFHUzmcUOLVMZiF3mOU6ykL4ZNl+HVMvEf85tv5QKIybs5
	Emmc6SP0ImbabCNR8zs3tTjrLfsYH1ZnQKXVMa4x/oV3qYZZFyEEgcrgq7ai+qrlmvZ30a
	eUm2xxaj5Xb6hc+t+N7lDhv77JZ+X90=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=P7Cra28a;
	spf=pass (imf22.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-482e06fda73so200043f8f.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:14:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787832882; cv=none;
        d=google.com; s=arc-20260327;
        b=TwpkEEyarZguN/zXZ7dssfQGomXTiaW21hBW1l2/lKMXTkScW/0T1cAgKCwxG1Zh5Z
         W5lek7+1x+PNjt2a7DPcN/p0Tv5ukbetk1VFlfzV32zbZsVvXNtSh59a0+Poy6zlkwlT
         ZSbarrKf4E7KG7a76FE2DmSB2YiSwKMVRvyk6YXmB9xrPwUrFZpgKtOaXSt4/po0c7UE
         563fS/X02buJssQ1x/jXZ+72DWU79K++IVCLIRv5lt2Wqn6Hgkm0vZanxL4JJOVm4ozS
         SYsDaTXQv7qaa4BJmvyXj2vHIgi1MIuFQu/ACvmD0nB3IPGyiVGCq/+uAwiWeCtebBKg
         aNjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kSHnkXRfsNN4v3AaspGwGv41RH5tRYCNnIdkFoLAWqM=;
        fh=0L6K6hGjJs+tUBrrZpsGvQIb+TNJn22AF78QB2q0PsM=;
        b=bTWOOz94s3f371KH+KZ51Di4bIAfenmodLPV5qvIvC89uvqgV+1GlfCzExKZmy8QoU
         M4tAlepeRWZXj0GQJs6WKQdi5ejBAeuC0MZo4oxyaRsMOWO06tqhlWWeVC35/ioVTZoz
         5TmoaZCbkjyCtiWx7byAKA/zg2iPdBy+k3t+gtzK2KiqyBT6MaETNUCuN+3wIDrM8C1C
         r6hJSR0SyrjyGvhNWd3hYKXDgct3DZ9kIjhOV8E2rTCekxuF1aeFQjIGEFlDtzHvWzEY
         o2Fi6INJjIc0VxhLKUYK8K9vPIr8qajlCYwqL5WHmUCm94Yf5M0ASFlsLEL+FWe8yIRB
         fcSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787832882; x=1788437682; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kSHnkXRfsNN4v3AaspGwGv41RH5tRYCNnIdkFoLAWqM=;
        b=P7Cra28ab2zenI1wHb/FKqNNqTSbSjVlYDNoCb3TSoXb7785pSC0UQDzzspd+po0A/
         Vkf4swrLeyurH7kuf0tyuNUcSC89Gse7iYdwsPp5IJd+1zuZs+f3aL3I2no3RgiqcUSo
         APjW3XVUsAm07lzav4fQkTQN5JFfaILcqRc9UCZFtxGYb7L8wXCYylV+icFawF5bRnQK
         vloAIwtDgWy2VDxWbhYbc5d2APJn9SOccvT8xoUj5o1rMRzfmtEA9xzffrE/VvhiU2Gr
         Pd9uqT98Nopwaq/3fbq4sKIJT63VJaUtHwflk/+cgDrgZJoUUSzdVzleBBfx9Lo7K8/Z
         kgsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787832882; x=1788437682;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kSHnkXRfsNN4v3AaspGwGv41RH5tRYCNnIdkFoLAWqM=;
        b=eslrfJeKbka7bzWMXVJkmXlVElX4gFTh7yjVCetWa/H03gYlj1xIwTB677wbyvjrdf
         laAuZDBarI/X8ie9whQkI6A5kFWbI4gVVqlqca/tFSLhgbiXC2Bcs+7StlT12HvOi9Ys
         w8UnI+SLCEI4XJyrM2DXE6VdJyOCJE8macpeZ2SfmqrEsUyXB4heGJa+9hfqB5pGj3my
         42Sw86tbZ6rKyxpkrrOoNCpAl0bOowMCm+XFQb4oWzWPvAUz/jqj0Jc5RzNUWQeWV3tl
         YRKvVVut2CQ9b9w2HMDKilRsARd8i1l7TzLpWcFcwOW5+Z6IZ6gDqqIb9ADvOQq1vJjn
         DcFg==
X-Forwarded-Encrypted: i=1; AHgh+RrLhDUSqlAy1XhXqfqw+kdcJwP33jET1LsnT0OSDqjlqOo5+88apGN6U+gUmllky3vHPbQ/V5Pb9w==@kvack.org
X-Gm-Message-State: AFuF++nbZpc4+orF76sp1w5F07IzabRAbl0lDVl7B9HrnIH23m6SKtdT
	lE8TyIZalqcmD15vB1CXHB8CrsC98vrX5fHP5BcRDDQ+y9MZrBqPf0IsLb7qFVNZLO913635Is3
	qrFygDZRKJh2i7laLwcb8zfqAmtBeq8Y=
X-Gm-Gg: AR+sD11M9nKapQvec9lIel/cH1h2Ek4zbzlHOmFBp3ci/2vpKhwRWA/nKnojfGDjUSV
	CvI8GnUI5E2pl1ytZM05oIocX6U2LtWZotTQKdascJ2B9MejSVc1jhT9GGA5k91mMpvYldGpNMP
	4/xk84BcJ++MUZZ9IVSb/O6zUS33/cYlce2a2ytWILHlJuiJi1EWDJco+LAxouldFOjBLKf2i0P
	2KSatigWRJG/Albvn/ozR5Kpr1LyXKD0LvX68WKmkASVk1iMN2B9wWesGAbsz+ZWmoEZweR+iJa
	Q87LMzPOm3XMufm1r6agX/Auw3kZ+VaiZ1KDjvXfUmIWQjFTgnw1IDmT6SfGIf3o9HJg3r2FhvG
	qpV9+254Aeyssr8GO7YjJOr9kUhyYHg==
X-Received: by 2002:a05:6000:2886:b0:482:e0f3:462c with SMTP id
 ffacd0b85a97d-482ea41019amr5782070f8f.0.1787832881912; Thu, 27 Aug 2026
 05:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-3-baohua@kernel.org>
 <ao6tlwWNN1MH29w7@fedora> <CAGsJ_4zFRy8qMCSnxy7PnagBnh6eXCPXnaJs0=yT1Q2t-6w+gg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zFRy8qMCSnxy7PnagBnh6eXCPXnaJs0=yT1Q2t-6w+gg@mail.gmail.com>
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
Date: Thu, 27 Aug 2026 20:14:30 +0800
X-Gm-Features: AcwNN1VRDxQaMXGFlxpnlAsgE-z-Y_QLiiw6wTyrR2PnAK37aHbhASYXKu3N9ng
Message-ID: <CA+qSx6xY5cym5oSLrvmHyc9zuUB2TToFbDRgSOM8gXUG=1HWxw@mail.gmail.com>
Subject: Re: [PATCH 2/6] mm/mglru: batch update lrugen->protected in inc_min_seq()
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <baoquan.he@linux.dev>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	axelrasmussen@google.com, baolin.wang@linux.alibaba.com, 
	chenridong@xiaomi.com, david@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, lianux.mm@gmail.com, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8cm34mwqidg4qw3dcd3zrd7m5spe4r6y
X-Rspamd-Queue-Id: D3792C0009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787832883-104981
X-HE-Meta: U2FsdGVkX1+JeH8kOgbzPw5YbyA2ViAbcl2edRvmfyubltTHTTCH9cDkgrUl/VLSjNrqa88BsWsdOTWOX44kzMEsIEkcjxoEonFG8QOKkO91LyH+AJ4vYy+D+Q1WHKgHLo0RR4/fdLWLg/gVOBkfkXVdGj4RDjxKJVG/16qWPZm8el0pAbpIPnR6C/X/XGeIule5BoMZgMt9VMRH3VJsXvwtLG/S5IUqvV95QSLFgpUA/0ZPsbmFa1n/IwTGQk4lYEj4a9EY7iESzKhOaBHEH2WPkpNirJwcgBSTyhgOpyqIGixdm+Sx28tisjJygCo/IdXCbS3ES9MhGG7iymM9dtaZek4+osOjP3o8ze900aSmcvOdFzv6IlJEz2pK5oaXIFS6fUpJA7Qev+xxk64HOoLFYmOtyGKmS1ruk1dSPEJDYDMBGddvCRkZVCSg2+7fKy6CfZO6W3sb0v/U43eGN07E9hTT4PrfMcnFGJXzOFBJilM9VvDQ/zwk7DVfdVwC2lNyKnlbv0QkBcsGmkfWltwLnxs4VSFubXr2F08TI8k/JxMTbwrRX/13jXSSuc/PoSYOH1lfrLiNss/dd3b2MeTFjOVyyXJD/GaIBxiq6+1fKiVXbaqP4AXjhvk1b12JEGH0lZpZcaTVOB0J60wPMr4rROOln1GLoe/8YRSumQAoqRW8c2WCZsz3mLQCD6LXZxmfzJrtaGj4Mi7/wjSICKddfYS3r+YKaVIcdFoIouzBQnNVgJU3pkn1QfwZI2Cmxw+NED1zEPsqPDXR3DpGFcURm3gI15tohK6n6KhDK8e3Woh81dxoeQZhsX137R9OBl6PaDnAdqxpi9QBwDH9fkfqDsuiYxTUXWiwQTKUktlW79fpfXxKr4X+KTALyubAMegwZGeFagb9srkifKi2dyRbQqQxONbzd902mvof6qpC2L+0wmPcXNxMtM+i+mYKfyp8BxUB6T0hvdqnPQ4
 ILwVupXT
 LZ5y4Cjs7maO2ll7TizENQa/2lW/Qe8sCQQE/aqw4ry886S7mORHuCoisFFaGxkk4Uk0yQwzPT9m9YF0EEeIub2zGy8Y0MM2HgnT5h5ARaOeMtf65T3iOhLs5Y23GIp/0EeHv9pPFgRtZnOy/D6CA1ihYssuhZgVXJEOvkytdypi/hGNltjkH0SGXgIOJkfZ0K4f7a5tNbtDJnXn1Ta+Yo8Q1XgzQfbokB/1T5SxHIcNqh1OmVqHlEnDFqkGHkK48xhY6db8TQ5CqcmzuPAf7/VvK0SU+YTONgANvdur9A6wRl82IlOWy65elqlNj7xwjPr/iic3ikXLzZPW17UmUj6g0ncN+yleUjjMBY2VLiTTwcFu1pRkFlUTQ/1JSb9Yq51bWNI4V066h7OcMe1CTZ+WuIvQO/059cd9JkBP9vqv1le/wfi4EQ6XcKGiu50sQUlKEUPxQUutwkyAPuBhxOqgUbtCkOLUWJHdHJinDLUjsMpD5ilkoPjd8gMfHtonA0pJJ8XUYLetVeTGjPSr8dK/aIqt3/lHXOstl6d8cGAXcXGScLhpCoItGehOeR75OCevH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 1:09=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Wed, Aug 26, 2026 at 5:10=E2=80=AFPM Baoquan He <baoquan.he@linux.dev>=
 wrote:
> >
> > On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > > Avoid updating lrugen->protected with WRITE_ONCE() for each folio,
> > > which may prevent potential compiler optimizations. Accumulate the
> > > updates locally and apply them in a batch instead.
> >
> > Wondering how much efficiency this can bring, is there a number for thi=
s
> > standalone patch?
>
> This is a good question. I reverted the protection batching to check its
> impact:
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 996b48344ed0..c9a2fd9ad844 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3957,7 +3957,7 @@ static bool inc_min_seq(struct lruvec *lruvec,
> int type, int swappiness)
>         for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
>                 struct list_head *target_list =3D
> &lrugen->folios[target_gen][type][zone];
>                 struct list_head *head =3D &lrugen->folios[old_gen][type]=
[zone];
> -               unsigned long protected[MAX_NR_TIERS] =3D {}, delta =3D 0=
;
> +               unsigned long delta =3D 0;
>                 struct list_head *pos =3D head->next;
>                 struct list_head *batch_end =3D NULL;
>
> @@ -3984,7 +3984,8 @@ static bool inc_min_seq(struct lruvec *lruvec,
> int type, int swappiness)
>                                 if (refs + workingset !=3D
> BIT(LRU_REFS_WIDTH) + 1) {
>                                         int tier =3D
> lru_tier_from_refs(refs, workingset);
>
> -                                       protected[tier] +=3D nr_pages;
> +
> WRITE_ONCE(lrugen->protected[hist][type][tier],
> +
> lrugen->protected[hist][type][tier] + nr_pages);
>                                 }
>                         } else {
>                                 flush_lru_batch(head, &batch_end, target_=
list);
> @@ -3999,9 +4000,6 @@ static bool inc_min_seq(struct lruvec *lruvec,
> int type, int swappiness)
>                            lrugen->nr_pages[old_gen][type][zone] - delta)=
;
>                 WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
>                            lrugen->nr_pages[target_gen][type][zone] + del=
ta);
> -               for (int tier =3D 0; tier < MAX_NR_TIERS; tier++)
> -                       WRITE_ONCE(lrugen->protected[hist][type][tier],
> -                                  lrugen->protected[hist][type][tier]
> + protected[tier]);
>                 if (!remaining)
>                         return false;
>         }
>
>
> And I see:
>
> With protection batching:
>
> Running scope as unit: agetest.scope
> mmap: 0x7c4b1d200000, size: 512 MB
> memcg: 12893 (/system.slice/agetest.scope)
> aging generation 3 -> 103
> gen   3:    7.538 ms
> gen   4:    0.937 ms
> gen   5:    2.348 ms
> gen   6:    2.300 ms
> gen   7:    2.302 ms
> gen   8:    2.294 ms
> gen   9:    2.296 ms
> ...
> gen 100:    2.292 ms
> gen 101:    2.307 ms
> gen 102:    2.293 ms
> gen 103:    2.293 ms
>
> Total:   235.718 ms
> Average: 2.334 ms
>
> Without protection batching:
>
> Running scope as unit: agetest.scope
> mmap: 0x775682e00000, size: 512 MB
> memcg: 12823 (/system.slice/agetest.scope)
> aging generation 3 -> 103
> gen   3:    7.542 ms
> gen   4:    0.948 ms
> gen   5:    2.338 ms
> ...
> gen 101:    2.340 ms
> gen 102:    2.342 ms
> gen 103:    2.347 ms
>
> Total:   240.505 ms
> Average: 2.381 ms
>
> It=E2=80=99s 2.334 vs. 2.381, which is really minor.
>
> I=E2=80=99m curious to see what the data looks like on ARM. If there=E2=
=80=99s no
> significant difference, we may drop this patch in v2 to reduce the amount
> of code change.
>
> Xueyuan, since you=E2=80=99ve been testing this patchset on ARM[1], would=
 you mind
> checking this on ARM as well?
>

Hi Barry,

I reverted patch 2 and ran the test again on arm64, with THP=3Dnever
like yours:

  full series:  2.964 ms
  w/o patch 2:  2.996 ms

So it's 2.964 vs. 2.996, about 1.1% here too. Consistent with your
x86 data.

Thanks,
Xueyuan

> [1] https://lore.kernel.org/linux-mm/20260827035416.3012015-1-xueyuan.che=
n21@gmail.com/
>
> >
> > >
> > > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > > ---
> > >  mm/vmscan.c | 8 +++++---
> > >  1 file changed, 5 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 0d74fc00abd3..99ee3c833d54 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -3931,7 +3931,7 @@ static bool inc_min_seq(struct lruvec *lruvec, =
int type, int swappiness)
> > >       /* prevent cold/hot inversion if the type is evictable */
> > >       for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
> > >               struct list_head *head =3D &lrugen->folios[old_gen][typ=
e][zone];
> > > -             unsigned long delta =3D 0;
> > > +             unsigned long protected[MAX_NR_TIERS] =3D {}, delta =3D=
 0;
> > >
> > >               while (!list_empty(head)) {
> > >                       struct folio *folio =3D lru_to_folio(head);
> > > @@ -3953,8 +3953,7 @@ static bool inc_min_seq(struct lruvec *lruvec, =
int type, int swappiness)
> > >                       if (refs + workingset !=3D BIT(LRU_REFS_WIDTH) =
+ 1) {
> > >                               int tier =3D lru_tier_from_refs(refs, w=
orkingset);
> > >
> > > -                             WRITE_ONCE(lrugen->protected[hist][type=
][tier],
> > > -                                        lrugen->protected[hist][type=
][tier] + nr_pages);
> > > +                             protected[tier] +=3D nr_pages;
> > >                       }
> > >
> > >                       if (!--remaining)
> > > @@ -3964,6 +3963,9 @@ static bool inc_min_seq(struct lruvec *lruvec, =
int type, int swappiness)
> > >                          lrugen->nr_pages[old_gen][type][zone] - delt=
a);
> > >               WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> > >                          lrugen->nr_pages[target_gen][type][zone] + d=
elta);
> > > +             for (int tier =3D 0; tier < MAX_NR_TIERS; tier++)
> > > +                     WRITE_ONCE(lrugen->protected[hist][type][tier],
> > > +                                lrugen->protected[hist][type][tier] =
+ protected[tier]);
> > >               if (!remaining)
> > >                       return false;
> > >       }
> > > --
> > > 2.34.1
> > >
>
> Thanks
> Barry

