Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D94ECC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 19:43:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEF56B0005; Sun, 28 Jun 2026 15:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5DA6B0088; Sun, 28 Jun 2026 15:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C62E6B008A; Sun, 28 Jun 2026 15:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C1796B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 15:43:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1EE68DEB4
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 19:43:07 +0000 (UTC)
X-FDA: 84930344814.28.684BE60
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB14FA0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 19:43:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z7MYXqpr;
	spf=pass (imf15.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782675785;
	b=wcscOf81bCU1N5U9sz+8miBzfwzZ71TyaXu/96Z1rm/tGnM/9tVEmmBS/i3uvV/aG6L5T7
	um8XnwRLx95KnZBUV3kNWTiRJTtB6Km/Mj3pmBi8gRwntG5oMGkOCDHm2/bW7fs9mQQzvW
	g8us+sShsGtf72Dl+XkD5t9WI9l8x1s=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782675785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sgTQGufte/kFeNOVSzxG7DktfuzYq2IzXzn4xMCT29E=;
	b=NvbIlCZEHRe96b3vQT93fvY8zlACRWHdXlobguX+pzscrHyfqAIMUjcr09f2Nkqz2zC9m2
	EKvr26gTNP+YaPpzv8hIzK8SqXxIB4pTBBf22AOheNXl3K7K8fjefTZR577zf3Mkq7bUrR
	mnR7Ii/k8mQaWZyJvWqUYpKFoup7BiI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Z7MYXqpr;
	spf=pass (imf15.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.44 as permitted sender) smtp.mailfrom=souravpanda@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aea7bce895so3480e87.0
        for <linux-mm@kvack.org>; Sun, 28 Jun 2026 12:43:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782675784; cv=none;
        d=google.com; s=arc-20260327;
        b=YZfjUYwQtDgNADWL8ZReeKT2efmpcWlGb01OOSsXznb3T3u6WH0rhXd+2oU5BN1IiL
         apYhC2mNyoUvleqt8NmRxVkZUP5cHZTq0OPgSa+1lMJNRafQqiu5gvokR4SK98rdZLGo
         EPUv/aHRzPRo9ZhgfTQBZ8EnOX2FxKQy5DEy650Lj4bN2J9uCWrwu65vGEXKltk/gZwp
         jSlBDyTK7v2b7jK2XHJYVu35gqVIOHM3CYbEQKdxEVUmdRkSUeVegxs0D7svaXoGQYqe
         GvtdnP8K82eYz1/NcSxrwRbJHDcWpw6rPRFb1pjaXXha/b0t6AXKqGjueAmXUcyjoyBO
         AUGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=sgTQGufte/kFeNOVSzxG7DktfuzYq2IzXzn4xMCT29E=;
        fh=3VWRoXfqCZaVmoa0Dc7YlWinbzB7MSxi4B6Oza5m2wc=;
        b=Wtrbt6lwd3M5YseLBzd0S28bl5W0EUF0beLCL3HIE3vn8VO5KjZjMwU0xeCXkOMU4x
         jpZerZVurXgp3YxW8efp0oVSVK9h+q/dSSHOAq+M9D4ZoYxbjGNEU6WODw2klU+aYb0/
         w7Ed+Ca8zCxd+t3TMKAB4E1/dedO78i6i2heebJ9oHSCWwMKphXYqYh2CsjFBRvPLQDJ
         dsY0lCXjfHdv53mAtKTZNzS3gChdZLMvhBCZ9ESEIs1dfzMLZD50Pmvatcgyfe67mh7x
         RyUE3FhEP46nUnC5g6h18rFJZJ+p7cJ+AMj3GvVp8Ea0uknTtk10FrDVQ5qtuw6O5+Ho
         52rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782675784; x=1783280584; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sgTQGufte/kFeNOVSzxG7DktfuzYq2IzXzn4xMCT29E=;
        b=Z7MYXqprT/jppwXxpnmoPmVRONP1mrSfNLSEAn7mVshqsEXWIa3QePgJfMxz22NUhe
         khIEsgugAbq9+4SwT5zKIMHd+cvQFZc9Wq5mufjn5ntDJN8sJCP1+i8/+9YbUbJvVJhg
         Ufx0cD6vLYFkypvybql/oikobacwQg3i+qgkaImFby0CeiIQjjE3JLfSqPv8YYQodkGA
         ozLuGIt/lZZt6oqhHDIZulNRJ66oEhITVOrUWyRZ5D4YpNJ068i1Qag1AYAUOW+k3Ey6
         sUpm4f7AC/00J7kND0XAfODXcSyax6/ZqjXjqr2jXfqlYCiirUwFcYyST7EtFMEyG5Sx
         BHnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782675784; x=1783280584;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sgTQGufte/kFeNOVSzxG7DktfuzYq2IzXzn4xMCT29E=;
        b=HzCtVc3ouPgAzRy0maVdMoO3ruxCjKnmXwrZc0GWk1D+tndURo5MrqzGV88dCFIVkm
         WEXzdby/8ECx9Ys0kY0bC4mVuZ3UKrzZ1iGAUbUvLeLe5tltFip+/j1uj6xhkNo+Fxo1
         9ulAUv5MVqUCTZU6VAJIeNbkOFCHxcmKAc6KMOHFUrdYEVtnHQcF6cHijsTFeI+Rt7O0
         hHmmDdNyCR7uhSXYOMbnBYYTfb0Hxfz4cBChtcP66wLq83CTkFmvmqbVGFY/oqortTef
         V3EoeuM+mgv80fAYmFQDFhKp41adySoHmyNKIS+Jzsnp7hcEcZjfs//nGelOifRRcwoH
         r2yA==
X-Forwarded-Encrypted: i=1; AHgh+Rp32kKH3yUkTbYvmNNYKApTmZyrZKdVLN6KtVUZSHJ44dR0Y+VAD0TtWs+etfhkoi0ZxcYp87hc8w==@kvack.org
X-Gm-Message-State: AOJu0YxuleAr//iEHPaB2E4mtTCyJtSxkn4KN71iM9fzl1RMblXqWquH
	3Jq0KOJEemWUAzVlc6EpzDdlytLO5PlsQqJ96No6T2iaelG6WY+N+JL5WZQb/nbPg3bAgJGxQ7j
	oeZfYmtDnLTeaq9gLntTVtYwCPstIt1bkqzZleZ0J
X-Gm-Gg: AfdE7cncSHbu7v6bBUznE5cS4bGjvyCOKEkZLPebiMqw5IB9cDKHJWgyuU/RBg5q16l
	fmEEnZ226kmSlm61gbqB76i2cbpG7A1vJax4lh30uzO8TSDpHnZ2B8c0TBpc5/46j6kAt/b66P4
	BeZ+VZct7tuRNot3oCa6Xbi8wC1FqgnmNREEijvcnV/dnvqzi9yQrojxAYJlKcWU8chhSgsYdLH
	UNIWBu2lpmfTJwF2lzsyohu7vRa1GAxIUQlZL7hJq9EhtHJ3q+VQd7DKnK+pkFupsBhV0LS9iyr
	jffAIA0VapGqNHws/zXfiyP8rLGKlfEBMaKa/OTXWsWv/WHy8KpxaQUsE1x8IvreLYc+/oLK
X-Received: by 2002:a05:6512:3f02:b0:5ae:b843:9470 with SMTP id
 2adb3069b0e04-5aeb84396cemr28836e87.5.1782675783566; Sun, 28 Jun 2026
 12:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260628190155.3655895-1-souravpanda@google.com> <20260628123854.862fd5d430894fe451b34323@linux-foundation.org>
In-Reply-To: <20260628123854.862fd5d430894fe451b34323@linux-foundation.org>
From: Sourav Panda <souravpanda@google.com>
Date: Sun, 28 Jun 2026 12:42:51 -0700
X-Gm-Features: AVVi8CfkW1YJArzD9OGfiVlTv007EX59wW5vFjmCMrZBLqdFmHQrWsJM1BEaXvc
Message-ID: <CANruzcRANsGS_aujEHBTySbFFT43cha34+iL9XpdZasBDsU3fg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/hugetlb_cma: support percentage-based hugetlb_cma reservation
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, 
	surenb@google.com, fvdl@google.com, gthelen@google.com, rientjes@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000d4e0a90655558ca7"
X-Rspam-User: 
X-Stat-Signature: xkkorhfor3sgsrbupaxxjoqsyx14ai5j
X-Rspamd-Queue-Id: CB14FA0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782675785-146347
X-HE-Meta: U2FsdGVkX19LNm9GKvA2eRZoIVhW5x9Vch/sql5RTvwbr3pyQKyI3c7kzyLGVJ47tsGcnOIIAsvOah1H8EEMa5ob+ySD5KxJ+JSlooBOl8UjgEYglKQQythBIPxfxgv7st7uU/ltwpfM88sW4TYMTyuinqB5hiDP6U25hN3snb/Sv8vawB0StzlXS8/nkpSOf5hQhOd7FTVBbtJ+L6IoaVaTd3q7wqlptBP/wTlruLsZlI002WBrgvlCLNMPy4lbYFf7ra8q45LK8mA+bOGPOyRlk4WDqebGadXa+Sbe5WEtZEACJprXdOQVQhxraqagEZbaxEfV/Flnf5eHVepICNToVZOcehfFPPTpc3yjP0ba6YU1kGY4pmxcBXwz4nGTpXZXX3Wr/lx2vgbJytDYFy05E5nW8Dv4aDjzcH5q/tHOdNVCJtJdfnrTgEuPBWOxsS6hZmrVUKvnhh0aM22vvDhnkfIDyDvIylwD3dXzn6b177aek9u6iS1PIZ43XW7GrzHmLQGg6N0SVE7R5FpZnXTD0YDKgH+UEdJJN7Q/vtHxi8iDJQWQjkf6+z6xI5GeqnxiUtIOgLFJNCWgOR5foNFBjuDRquKpByQm+Try/BAyHcow2AGoXiqqsIgB7YG5pm7BXBY9nNpOlYNTV22y2m1VW2n+Y6CmR8gcrfNw698PcGT/uEWeGNNj5Sc0edJlJ8YJq92ns/RwlbupGyIEvwrA3Vg80jERCrQzJYQ7oxxWNjn/Wmcla9L41q5kDudX3hNLqcJrMlX0D5VV2xtijFpuOn5Bl4n2Mvn1dDbJ2n5Y5yOSkJaWnD9P8i/4dXeEh7q9crDyKsTSv/iHmi/vWpALf5VELxUNzPNjVzQCofFpPfPZs0IjKW7aNy5TsMDOk1/OhWBQcSKZpmlGiMgxar52WabAxXrmYcoiY32EFKxLnS/vQDPFiz6zx5ltYpx0KMrN4pBolaHeumErMUx
 UF7Mzhfj
 AY+jaFnZoQinRl3SFFVpGEQ6R5RKiMhuVuT59CWycrfFPtlSIBZhUTwuKAkGgRmUrIrttroOlqBHQbGeSapTQepnLI+/O6m+ABR5IFXur7uJd+mFo8lKaIhcJoHdID0KRfXdTMzDdSuc4SC2W9mmW8Ii4vc2axSCRL48bDY8R6XjO+i9HQe8Xag8j3pFU72weJuplaowSWaKFSy9A5zbRuLZ/bZhIU9pAW/Cky4CZigE+3cZDvCoqQkx4OA1NoLfee5eAlJ7RsJQIe4+K3Xj4l/e0WPQWuyjExFusUejUV2GKF922K0UB6go42jDqw7MX47+xkQA70ipl8b3b/CvPmebG23B1fB7EY+KF2FGks6ksFjJWsjospcgP0b5xMetDlwV/43IWZ7uj7RccaDs0R+OngnhjpY7SHT3qFT24x3k3JZwqrGy0tqqX5GDs5FA1jtfD8nfSfLkKP7SXCTeyF30//ixghjS2spyFLCD9CMdaZddf+XFCyYwYyTPcE/Ic8Y0VgNIbcgDW07M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000d4e0a90655558ca7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 28, 2026 at 12:38=E2=80=AFPM Andrew Morton <akpm@linux-foundati=
on.org>
wrote:

> On Sun, 28 Jun 2026 19:01:55 +0000 Sourav Panda <souravpanda@google.com>
> wrote:
>
> > Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,
> > hugetlb_cma=3D2G or hugetlb_cma=3D0:1G,1:1G). This can be restrictive i=
n
> > heterogeneous environments or when deploying common kernel command line=
s
> > across machines with different memory capacities.
> >
> > Add support for percentage-based hugetlb_cma reservation (e.g.,
> > hugetlb_cma=3D20% or hugetlb_cma=3D0:20%,1:10%).
> >
> > The percentage is calculated against the total memory (for global
> > settings) or against the node-specific memory (for node-specific
> > settings) using memblock APIs during early boot.
>
> Thanks, I'll queue this for testing and additional review.
>

Thank you very much!


>
> There are a couple of pr_infos in this code, to give people an
> understanding of how the kernel has sized these things.  Would it make
> sense to enhance those, to help our operator to understand/confirm what
> effect the chosen percentage configuration had?
>

Absolutely, will add them!


>
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Closes:
> https://lore.kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp@intel.com=
/
>
> Robot found issues in the v1 patch.  This development-time info isn't
> something which we (at least, I) normally include in the permanent
> kernel record.
>

Gotcha! Thanks for the feedback :)

--000000000000d4e0a90655558ca7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Sun, Jun 28,=
 2026 at 12:38=E2=80=AFPM Andrew Morton &lt;<a href=3D"mailto:akpm@linux-fo=
undation.org">akpm@linux-foundation.org</a>&gt; wrote:<br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px so=
lid rgb(204,204,204);padding-left:1ex">On Sun, 28 Jun 2026 19:01:55 +0000 S=
ourav Panda &lt;<a href=3D"mailto:souravpanda@google.com" target=3D"_blank"=
>souravpanda@google.com</a>&gt; wrote:<br>
<br>
&gt; Currently, hugetlb_cma reservation only supports absolute sizes (e.g.,=
<br>
&gt; hugetlb_cma=3D2G or hugetlb_cma=3D0:1G,1:1G). This can be restrictive =
in<br>
&gt; heterogeneous environments or when deploying common kernel command lin=
es<br>
&gt; across machines with different memory capacities.<br>
&gt; <br>
&gt; Add support for percentage-based hugetlb_cma reservation (e.g.,<br>
&gt; hugetlb_cma=3D20% or hugetlb_cma=3D0:20%,1:10%).<br>
&gt; <br>
&gt; The percentage is calculated against the total memory (for global<br>
&gt; settings) or against the node-specific memory (for node-specific<br>
&gt; settings) using memblock APIs during early boot.<br>
<br>
Thanks, I&#39;ll queue this for testing and additional review.<br></blockqu=
ote><div><br></div><div>Thank you very much!</div><div>=C2=A0</div><blockqu=
ote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px=
 solid rgb(204,204,204);padding-left:1ex">
<br>
There are a couple of pr_infos in this code, to give people an<br>
understanding of how the kernel has sized these things.=C2=A0 Would it make=
<br>
sense to enhance those, to help our operator to understand/confirm what<br>
effect the chosen percentage configuration had?<br></blockquote><div><br></=
div><div>Absolutely, will add them!</div><div>=C2=A0</div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
<br>
&gt; Signed-off-by: Sourav Panda &lt;<a href=3D"mailto:souravpanda@google.c=
om" target=3D"_blank">souravpanda@google.com</a>&gt;<br>
&gt; Reported-by: kernel test robot &lt;<a href=3D"mailto:lkp@intel.com" ta=
rget=3D"_blank">lkp@intel.com</a>&gt;<br>
&gt; Closes: <a href=3D"https://lore.kernel.org/oe-kbuild-all/202606262023.=
IKUrn01I-lkp@intel.com/" rel=3D"noreferrer" target=3D"_blank">https://lore.=
kernel.org/oe-kbuild-all/202606262023.IKUrn01I-lkp@intel.com/</a><br>
<br>
Robot found issues in the v1 patch.=C2=A0 This development-time info isn&#3=
9;t<br>
something which we (at least, I) normally include in the permanent<br>
kernel record.<br></blockquote><div><br></div><div>Gotcha! Thanks for the f=
eedback :)=C2=A0=C2=A0</div></div></div>

--000000000000d4e0a90655558ca7--

