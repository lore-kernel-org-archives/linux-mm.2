Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40F5C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 04:03:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766C46B0092; Wed,  8 Jul 2026 00:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717F26B0093; Wed,  8 Jul 2026 00:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606B76B0095; Wed,  8 Jul 2026 00:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 304546B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:03:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95187169143
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:03:41 +0000 (UTC)
X-FDA: 84964265442.07.393B894
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id A442040006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:03:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rDBmzqPr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783483419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5f9YSxVBCXgs70OHQgvPnqlSIpM0evs7erfFRXLGbl0=;
	b=7vl0bTpNkd7W7GO9VFaa/EqpyEeQps+MlFgSudMpeG9ZLO5aYM/uo9TsWCnk+kWJkZjoTY
	i5ABqwIL/r5Zudu1uOy5+Y3hRCIWAHh3PL158JP0A6SYovhsp1DrJzlolRAT1ROhhvOGxn
	/jdH7C5l5pNAb7yTxifutu8+i4n4FDs=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rDBmzqPr;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783483419;
	b=7sUv7xxbVrYkULpnPk6h8qfWuFL5hgnXZuixal1fgQiLLwLWOijmXyksN4TkM6CtwQ/UfI
	eaCOxD5kFylYMG1QRw1iw19JmwQMFHQTwWzuWCrULou7DKuAQR12gVltjNMocNUCEc0/I2
	mUF8dyLp9ePS9mBkUWhGTgC4ajOvqPs=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-472326ca506so118223f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 21:03:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783483418; cv=none;
        d=google.com; s=arc-20260327;
        b=iT3E2JRMnhTOw9VdWeq2bxzYdh14+BrqbvR5Ge3k5UC0nyVhcCAkoqrg7E0vte8Qd7
         9/0dL4kXFAJKwPE0P43uK9khKeseR96VNh0jMxqnT5VUF0ZZwWG6Pw4ncL4JTyF9uA/s
         DFLaWjmTNSDs/+pMiUCd8e+zB/EnCD+fCzU8XcdgJIPa60aT4fGvUm9jPr+86po4a8EZ
         yF1/W1l6M+Rb4sF8Pi/wDlcf0HRCfplRGKFo5w/OiCweLeGu9r2PzJ3jrrLMFqzSgsof
         c0pS/iqoVYunMK+gBDd0P6dPO/yvUTeuXTA+PjETWChhuQNMJUChv3eYFoL+un/8APT/
         HQ8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5f9YSxVBCXgs70OHQgvPnqlSIpM0evs7erfFRXLGbl0=;
        fh=ogRlBGkRiSd3wfPInP8qPPdH2LCvSGtYhpJIgTc3R0E=;
        b=neZd0W7Nei25gncunMD5lhw9xhuJuFUbxXEonDqY01i77LtmNCThfHCKq1BBpOiJ2q
         ABxyAPKiSOAzFRq+ff2AysMF+3vcvwwdfJpgV09EWQXV22EQkJRJ1wMtrgLhMy2pYzbz
         JDBgkDwh1mi0si8GUGofq5i1bY+EpfXaAnVxVf5ov/sfGs7gJV1knwxxw7B/q2Efaf/T
         Ywhc3uOsuMLPOooCbHC2VKiRSt66j68e2as4nkyEGEv9zDTkZ291A4RmmzUVAuMNL+Cl
         n8LFGS51FwMohFS1oEKPjgBSe9D9Ozgz7Fzc3ptucJti0LhZiGy9OgiRsjfR9E3v7gZr
         PlzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783483418; x=1784088218; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5f9YSxVBCXgs70OHQgvPnqlSIpM0evs7erfFRXLGbl0=;
        b=rDBmzqPrSH08+Zmo0oNBFYcT5pF4xFxBV4eohWnJs5zSK51k4GgEmiUQwUQV2+W8GG
         GIPrRqJdLkBBIN1Sh5DZ0AKsiMehFRUIL4zHmMYYveZFj2rlcxrjzcWFBSLTwLhPe23u
         IrLoDdi1vx/8Uw0L2HkxB8u9S39ICMp8JNrB6Fy0SsHZipfqkvjfR/Oh1rrvZSOehNys
         ir/7XZMLgDPcywpdCfRZRCAmyqGVF/D52GKY7O1nc2ac7AvaD0dVDMppSqQlTrDW3i7U
         0wZbGSScCc6gtLud4FGkCQIL94K9PL+C3/NksNRgTpvFlUHjlXAn/lU/c2cw1jt8hFZZ
         nsZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783483418; x=1784088218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5f9YSxVBCXgs70OHQgvPnqlSIpM0evs7erfFRXLGbl0=;
        b=bjWQwC2a+NG/heE2dsha+Uy+boRQAiNhm8ufZamKZ8IH9RlJqXThRA0Ol/swaHLe3s
         ITKqcoCqY1jNSLxRp7I6uDBRhkmJbx9OfKVlcdqx3Qt81b/wRbs3nnxwhOpvIeLMeLDq
         wXyZJx5OOfMfjDPNRee/elXBGyDRqdwwFN67uIDAjS4Xt2qlK37/0zTmIbxjJz2/g2Q5
         IGg1/cDnmJ+oJOqAROkrHoQctHFZJZq85odk/tAXS2D/DbthhguaHSN1ZBAZ9CogsNsf
         2BBgQx3amOXkzAdRxF9NPxNJIwtmiRutFngO2FPeLqbxIap8UFYKkMYV7CqEQfihZnJW
         Iy+Q==
X-Forwarded-Encrypted: i=1; AHgh+RqVa4YL/FCLOe0RPvqrRHKdqzqVkXrph1ydszBDcIOErsRHCInydzfJaMB/ctOZB9D+IVie02wupw==@kvack.org
X-Gm-Message-State: AOJu0YzXLlHPzqidXXcOFMd/FeY4RneOTpBSzirI75kIt0y2KrtX/QBY
	YuK1YSxL0d22upC9dI+Yjdj//IYq+hv/9YiOnq12/wooozZu/TFESe1PZS8aKeSf4OZWogi3cJ8
	igQWK1pTnToW9MFiO8BdBxoiWE7kc0C8=
X-Gm-Gg: AfdE7cmKlirMcpA7Ym1I3zk4AEysBmp0E3kF6PnSt4pRP0fl9e/LC+YuEhIz9Dl2XLu
	5vwJH0mYZBcHJ1nqW0eFVxMNPrvZuxrh6sGgTR4R8AhaMF9rkR45f0VBsKd+l0JTFB48gXLX6qn
	GZI1m2oVjD8KUb2XJ1HuFtQd6EITqfQD+7Yy8sZw+6Ywewdklc84uEdjBVJFv0IsZd+KcBqJvgO
	cjpugCsC3PcMmAoj0Fw4KZTYKLyfCA5ENLt9JScbOq9y21RY0d8NxmkE4RTRne9XDaX6RtIjMuQ
	htPLtyB2JFxEvewXSu/t8G9ZJeuTV3PX6YZrsWHUG4VKf3ZKXZ9Q
X-Received: by 2002:a05:6000:4012:b0:476:82c:b869 with SMTP id
 ffacd0b85a97d-47df076a515mr452916f8f.35.1783483418003; Tue, 07 Jul 2026
 21:03:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-1-joannelkoong@gmail.com> <20260707201735.4113107-2-joannelkoong@gmail.com>
In-Reply-To: <20260707201735.4113107-2-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 7 Jul 2026 21:03:25 -0700
X-Gm-Features: AVVi8Cc5sic8bM6HuFdDc_h_VTfdVOKdBzcATnohiXqX6fFTnY_WFqYD-vuZmp0
Message-ID: <CAJnrk1bmu3ibwiYk8C1PX2x-DZWhDYz7V=mSj=OAMeuVvVbNfA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: extend thp_underused() to mTHP folios
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org
Cc: usama.arif@linux.dev, alex@ghiti.fr, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A442040006
X-Stat-Signature: x1s7tryijyijregtdku4i531qoow1489
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783483419-32744
X-HE-Meta: U2FsdGVkX1+YKCj+Rxib3iXINHnVKe9C6QyAeXFRxMShpjMJ0bas4hBfPzHH1sMmwCnZRJP6j0edFrdcO6e+bUQfc1lhnjPEF86n/c4TCj8goZS8IdFpZzxVWMVnKWfIyLMnSFqXiPLLW1gdVsPYzLu0Rs4mkdCJQ9OXCoT3ytLdtjSbsBavlGc/fDtZEUgJ39dpip6NuLuB1KBEIAwoplPTr5qCPdU9znb9C/KVUkHV9VPdKeWWIFOVuEVe+2zqqXGIgPdQbn0j7C/9syrHwfo8ghYNMn90mlelhb6Y4VxeFv3PUxCx3Ps/bY87d6QfXAmq0iEF6NlqrptNT1JajV5+9xGFWjizA8VrP1OlJL/kU3u7K/RZfohz8Vig6cf1kIie1Qns7iF/kv6AdBCHeH2t3ZbCOdifuANPR1/WABmr2d50mifoWLrJ2AiLXZpz2WLf13a8qFvugJK09drvrnoaMwiR/vJrij2raZpenDVUuoU6kqqTnwRjiIz02f/i/HzYv9kKdTQvDro1JYa2heAvwI3Fa6KfBvYUSQxuYhZMFimWyBhpiXNCjsIizo5DeV94u2vFTTfmjyRaN8eOyntGWyAPAur8UlDpzmlCI5HqGZpv2YqAy/5psn8zXNg1A9uPPWjC73qfIlleF7X1aYvFsINObKEUVRZ6q2eBcbSch1CH5qL8cZDJuiUgYmAOLibMMsKnOuodVg5IRybl/B4Azm2LH43JL/nHEMVg8F/QvG3kBzeQ8tDfOoRBFchsDArkMUIkcBMuUutaWTk/xwgV+Fn1wzp6DXnpdbiqyiQ7bTngEWzKgS+a2g+2HT+aA4WEtbBFGssV4aExpBIdEsS3I0qopGwg9zcy1ufBEXk4/mQ2VXng6CZZSFspeCRNRrxY3gxkcJRM8c76sV/F3v/0w4PfvGiNRbeecUTD/PahSIf4btaKoWHPqMQwskYSWGO2ZbX9gJuqEAcc8dj
 Jcq9QVxW
 cI8D+ijFICx+aQZUKcYBjKzIb1PF7O07zsxCGohzv0AtiAuRHKGErrLsBSECprJUT1uTNOtgWwaCFSEEYEdjOrmqeB6OSlKvS7Rvl5zJbRDK8n2g5DTR23s5A0N1qC1Ygg1Svp9dhQcP5zoMdMTRrcZlzs2trOfV1WPpTjYNO5IeRXdwkZyXjL+usNiahHnQWTW7kgc6Xz2kYtE4mQY54CzoNvAAcRKWI7ST0O1mlAKg4eADqwZ+fV14HIxL7R0XyKhJSyA8H60e//lnwJwDIyMWuckgV/4fAR/VtykTzupw48xNU2XjW/l5zkdtkBUaOitAAvt9Co+SRMC28pZRLC6d3Cb7HMRSOAMO3N8yjpzkl/4AoTWDUkWdfYMOYjk+y6es+IaMNXDLJgTrG+oYkiHXB354sDH2M4+s7NpRKQH1rKUKuofsSg+NxuTCaVgEr2yhH2BSvF8xYZrVeanSV4nVhifS0NdbnJM8qGbjAhG+n/GaFJC8J9vPsyqiKcbq437r+08gzp1MGfSwt69NTete8/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 7, 2026 at 1:18=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> thp_underused() decides whether a large folio on the deferred split
> list is underused and should be split so that its zero subpages can be
> reclaimed. However, the logic in it only accounts for PMD-sized folios.
>
> As preparatory work for splitting underused mTHP folios, make the logic
> in thp_underused() compatible with mTHP-sized folios. This uses the
> existing khugepaged_max_ptes_none sysctl value and scales it
> proportionally to the size of the folio as the threshold for how many
> zero-filled pages a folio may contain before it's considered underused.
>
> This introduces no functional changes for PMD-size folios.
>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  mm/huge_memory.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c0892cc533a9..ea5c350b4818 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4413,24 +4413,28 @@ static unsigned long deferred_split_count(struct =
shrinker *shrink,
>  static bool thp_underused(struct folio *folio)
>  {
>         int num_zero_pages =3D 0, num_filled_pages =3D 0;
> +       int nr_pages =3D folio_nr_pages(folio);
> +       unsigned int max_ptes_none;
>         int i;
>
> -       if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> +       max_ptes_none =3D khugepaged_max_ptes_none * nr_pages / HPAGE_PMD=
_NR;
> +
> +       if (max_ptes_none >=3D nr_pages - 1)
>                 return false;

Andrew kindly directed me to a comment by Sashiko [1]:

"Does this scale calculation unintentionally disable underused splitting fo=
r
small mTHPs with valid sysctl settings?
Due to integer division truncation, max_ptes_none >=3D nr_pages - 1 can mat=
ch
configurations that aren't the sysctl sentinel (HPAGE_PMD_NR - 1).
...
Should the sentinel check remain against the raw
khugepaged_max_ptes_none value before scaling?"

Sashiko is right. I'll fix this up in v2 and keep the original
khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1 check on the raw
non-scaled value.

Thanks,
Joanne

[1] https://sashiko.dev/#/patchset/20260707201735.4113107-1-joannelkoong@gm=
ail.com

