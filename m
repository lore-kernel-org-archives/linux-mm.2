Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B884FD375C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 18:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDAE46B0089; Wed, 25 Feb 2026 13:47:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E85576B008A; Wed, 25 Feb 2026 13:47:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D87FD6B008C; Wed, 25 Feb 2026 13:47:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3A196B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:47:11 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 748C2BAA9A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:47:11 +0000 (UTC)
X-FDA: 84483861462.19.DBCBFB9
Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	by imf28.hostedemail.com (Postfix) with ESMTP id 723E3C0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:47:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BeJ7hHcQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772045229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Am0QhYpweZev8nnkB2fwxkoFfdf13ydMbHaqe2oNmTA=;
	b=R6lgJZanZ83pg4mlDDeg7UfwO3UMgWdSA71gDDIa0deZ/m6Injz0F0qgzjunMy4JTeDgEy
	skSxDEgwJe0u0OR3zELaVhmBz4DtmHEW6xrGJCBQk9kFHgq7ECqSwm79zOvCqb+EUlcmtz
	QxchIqkTzPLvusUAzLmoAeCO9B+3sic=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772045229; a=rsa-sha256;
	cv=pass;
	b=YYtJ9jJmNJGACc3fzEGXCSxg3vVMmj8GSOOvTcN4NISlDmVk3OqfBEUi3CZdmTxrHyJiMW
	DfbR0eK05N/mdtYhSOu2j/LLvl6Ef9kczZHk4uSYcy0WqbU3z7PC+kXWL3QEJty++/PFN7
	/kY8bEg6E6/n9T2tDPVp0yZomKmt9Wc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BeJ7hHcQ;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.68 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-126ea4e9694so3913326c88.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:47:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772045228; cv=none;
        d=google.com; s=arc-20240605;
        b=EqHRGk0gCy8C6+qjD0heQG9tkGnF7/zhzabTL+UuEBTgPLICzuPNMNSxGgN0ASKChx
         J/DWCPMctlTtPNpgvT+GT7J13xj76wYCG/sdTo+X7Fj8q03hY4XJU+OZj4kh95f2l/ck
         UXf/QZSeXWat3XV5UdpaflX32bX0Cw3rBsgl9sVBmtD8nPA2r5piIegJmtqapYHxzesl
         vit1ATqlkUvJ+67dBxNl+xvrSilrN747sj6gWUOFwSDWcOxsFJmn6OpDDi9StUAdPvYR
         SS9/2Z1GnbhuVVxYKptcjxAq2zJLBNMRE7vhFVjORLr5SsnCOKfhPvCHP0CMxI4NXmKY
         xynw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Am0QhYpweZev8nnkB2fwxkoFfdf13ydMbHaqe2oNmTA=;
        fh=Gr7jJcHAhgzCvH5GuFhIYaSHwAKNnYW2IzXEi7ppnzI=;
        b=WSsfr2RAH3jic+ljJbir5KvdMuTuEcnzABCCXMjbSueCG8skfRQxCXCD+Pv6LcJqK3
         bBpnATulmrQzWc15U3/lub2Lg+VwHcpgayJ/T0tALmHDEhC99WVPfULWGMoC9pxhhA9f
         1ERXOnAaPohJHuDCmqQAst9RlLvGc7rfHRwRH1ra+12bNMMnaNxyYcRNpDJehFr4AzD7
         1XOGOQ+TZOE5zJdp6ydfqjVMAoBshznyfYwO9nD7X7XHGse7GTnV4RiRC5679s9kmfZm
         s8OLfUkRLTVdzLkOQ1XSDuc875ERNtFoQs8dLKUn+DY9lVoM4G2anylI87HOEduKN6Yh
         cQUQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772045228; x=1772650028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Am0QhYpweZev8nnkB2fwxkoFfdf13ydMbHaqe2oNmTA=;
        b=BeJ7hHcQquYPeYcpHC53lMFpJbXN0zTn6eIajhI7Jw2Pgxh5gNRCUL4REBQ0I0NImF
         5Iy7exNlGGAyZ2nbySa6YTWV0/Zqg/iWRhqOWExIixvpuFDZadd3JOErOiiQLbqL4wqh
         Xg4SqNE/ZnY06Rtp0XiDJgzTuztbRo3o6Ioq/VIpSKU82Qc0CSddjSSmiKfNl4zvg1xb
         9riOBifM/ZPB7zl18aCxWqkZzLRLUY+Fpq8cnWt4pxVyrOCbHkh6z8J1cXjVRB1SMJTV
         79KRtQ72YYcPEP/0gO9yw5p2MtqPSpnnHw6eD4zA3EXFAuXJ4LKIVYg3S/e3jJY4cGLL
         UgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772045228; x=1772650028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Am0QhYpweZev8nnkB2fwxkoFfdf13ydMbHaqe2oNmTA=;
        b=EtBZGgIsGYmULoaWvsJiNjM0g2Ta+2lI1yuXQPeq38Go6a238Cw2VHkUZtxx6TZpPy
         r7vr2oaFE5S2Uld6QQhGt93l89i8pzTvq3EoPAbEuI2sufEPnJap/D08OwPOavRQE3FK
         wSLVRfyc5auS/hRXF87JY440SSn9hhZujeCchmGhbJ45KK0/HrbjMxpWf5s14DoSLual
         R6qXtw/smQYjK8YnbXK73a03PRRqi47hHkuAWUZDex5ShlZYi4KQo6VziePNzMbQW9AY
         YSjjGzsWoiSP0dbjwh5wssqbiE6sgk/pErHmijOw/z3dKQc/c2OdIm8+AayJqiTkUKvq
         BlQA==
X-Forwarded-Encrypted: i=1; AJvYcCWN/94p3McGXo6CsG+MyU34GohcZMwSwzItYNkHgyF21VzGix6SQJyxoFEVtpNpowm6T15AhSGJdA==@kvack.org
X-Gm-Message-State: AOJu0YxxQLsUOg/5CoKNVnxjihdWhHDOmG3+EHNUCa5YeLyYW6EBwhpX
	WrRz0MEmu9gOHe7envItuC8zNI71BaEMd5ZEN+PQD4YCTdnAAIBkXrbRNnNDouV7DLeqVuHNLGI
	EAt+DZsJpGumgmjzmjzm2mMlc+ewTrg==
X-Gm-Gg: ATEYQzyah+qIFcbntPl7p0TXSklncuqnv00tnjMyHZ3wWmJY923cCTNYDPZdzzXvmcQ
	z7QyahsFRBRFcUjguG8/3Q6C+vI75WraribRPpSgsopN3Sb+dsasGH7Ib5hJmtUdRsKk2UyljCg
	BNJ5LgGssiQz/UgqolJpAsKebYu0Oo/4OPSyRySNuKhtIPBZXHEwpAPmXrPWqdEOwRv9mazbKgK
	em2IOnOj0zp7eqpvbYqV0dCPAA33cnWj99xa7f0SS300L22+qCgqIhMoAUT4Ee6CZpc8pbJ8A0V
	OCF7sRQ=
X-Received: by 2002:a05:7022:e1e:b0:124:8d7d:2d63 with SMTP id
 a92af1059eb24-1276ad37c89mr6990464c88.35.1772045228091; Wed, 25 Feb 2026
 10:47:08 -0800 (PST)
MIME-Version: 1.0
References: <20260223123232.12851-4-ravis.opensrc@gmail.com> <20260224042734.57666-1-sj@kernel.org>
In-Reply-To: <20260224042734.57666-1-sj@kernel.org>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Wed, 25 Feb 2026 10:46:56 -0800
X-Gm-Features: AaiRm52GeaS6tTlogoSqCwfrxu1fZdKPGoV3imvaN48s8SBy_zqky7K_ivWZz7o
Message-ID: <CALa+Y16T-yNPq75s_PWwEJAEZ=r1YVdd7AyRMA2DtS=BdkZ3-w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/4] mm/damon: add node_eligible_mem_bp and
 node_ineligible_mem_bp goal metrics
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: bczo5i4ktwhzyt39ypnj33yynswodixo
X-Rspamd-Queue-Id: 723E3C0007
X-Rspam-User: 
X-HE-Tag: 1772045229-823314
X-HE-Meta: U2FsdGVkX19ku40kSquTvh1VunIdVM7N3MIEDLfkkDnyMmB3X8eUDFDkdieBEfDzSvbMBsEJqhA1y4RN0xB8AYBEKIHA98z932q+uihL+wxO0ckBgu7iA9iUYHxMYpcjPopsFpf9UA/w7+NqqhkQVfVkP7WnnEkuxwIKwzaSO/zxkxC3N181koxlp9MB0eKQNx/26QRkTc943ranvIw/4dSsfrCZ53ywddeEaFzNi2pmDYZ4LUuPBc3TUNIsxzyLPbgy0kYY4ys5Hi1jk1XsnYVBIzkwXB1xlK6h8IVbV5n0LxjQDXH+C5A0Ua81mU/hIg75hRvegBd6PtkiGl3h0FSr9szjM/6WxD1h5CG/fZOXP/5GZA1i0L+1Ewdu9oXZjW9Okz/6QHlx1NaKhupI5YBR9IwUJIzPDDjZ+OV/sReI3uJFA88rUDiqXFHUNY9zZCH6P5viS6x1AimTw6YH22LD1YCXFob/fQPYmKQzqbzAusgbf/hegdqXpnCRBOGslsn6iCAyt/kfGX9lvGtpEPn0+qaVKk/JERdlmxVPchkpYN44yLBCQYbHxdMymBiFP/ORSbOO/4IGj9n1nUIq5Hb/PD5LJzVB+219Gm+929A+xCdHfrEPsTHK5iFDHQ60HKHQpdPss2ziSr71bjLEwf1ddK2Rlcd71dqGtkXvfXT8ZVM+aD7rvjrls+vidMXlSNV37X3xlmNPAL7sqYzElutwnD6mn9C4Ss+mWzAxyaaLRbTN7kGYW3D5lNMRfBDJu8b/qGCq+0c+Fl0mIoNohsx2rDKN5U1iuqvIs2llojvDrty6AYRRhp461D0sZlhXcFvpKAQnVHp82LhwiWxGR4X2miWLdyenZZXSiYG6exuffD9R9IEtbgnqYmBptjgvT7i+ATT8BhuibrneKppfGZCd8zPZFzyiYONh29JnBqiZPW5+casphrwneUkFAxZVwcJ7YvyyHoqFyR/RPM1
 i55EPttF
 Sss4cIbWZPE8FYpGmtG8iMabaf4PFDVXvYsFyNVRvH7H+EKfWMHttdS5u9YfgYjwF06ocD5x23aFJ+6AYIGyQ8fmVz04eO4mducMIX8cqq3zuG9GAgHhVc/644BTLwA1PbjWUrLrORqwmBl3eP2pFFYleKmlCrkI1NN/MB8EAVz9EvxZHTD1J02FvUBea+jUZHH49CNaVze9VWglEKj4eHN5g7y6iPAp2vXlzAAfD+Vn1O/uJE3R386F5NddSbFe0OScqUmIYa8EprvSMcrAFXxjc8HYFO5XxsTPH9FX1aAyrmF7tWL+6URWVuIydyShmL3E7gHzx798MTWPAMVstBKSvvAhTso2zdWYGJu7i+PNwhKMlZgfjF1B3mh5yfIMGnh1e+JiXqP4jcvGAaYBGmIIRo0TQ1/G90pvYPLWFoZQLWR4hJItHNR/0X3PUV9wCFuNLKgqGGceeiEVjlD7GocXuHvIkzEHP5R1UECfPAPPMWfr11gAux8jNXa/hHVef+sYxBP5/ldQNNvdUxXNUSktmwBdgBmwZmBFgvhiMVoVmb7Yc/EG1UJzynatjAMSs12WXaAfO7vRrc9hVCttP/URzIrxzWtiGkP5xNVPHw/x3u2c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 8:27=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Mon, 23 Feb 2026 12:32:31 +0000 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > Add new quota goal metrics for memory tiering that track scheme-eligibl=
e
> > (hot) memory distribution across NUMA nodes:
> >
> > - DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP: ratio of hot memory on a node
> > - DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP: ratio of hot memory NOT on a node
> >
> > These complementary metrics enable push-pull migration schemes that
> > maintain a target hot memory distribution. For example, to keep 30%
> > of hot memory on CXL node 1:
> >
> > - PUSH scheme (DRAM=E2=86=92CXL): node_eligible_mem_bp, nid=3D1, target=
=3D3000
> >   Activates when node 1 has less than 30% hot memory
> > - PULL scheme (CXL=E2=86=92DRAM): node_ineligible_mem_bp, nid=3D1, targ=
et=3D7000
> >   Activates when node 1 has more than 30% hot memory
> >
> > Together with the TEMPORAL goal tuner, the schemes converge to
> > equilibrium at the target distribution.
> >
> > The metrics use detected eligible bytes per node, calculated by summing
> > the size of regions that match the scheme's access pattern (size,
> > nr_accesses, age) on each NUMA node.
>
> Looks good in general!  I have some comments about trivials and the desig=
n
> below, though.
>

Thank you for the detailed review!

> >
> > Suggested-by: SeongJae Park <sj@kernel.org>
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > ---
> >  include/linux/damon.h    |   6 ++
> >  mm/damon/core.c          | 123 ++++++++++++++++++++++++++++++++++++++-
> >  mm/damon/sysfs-schemes.c |  10 ++++
> >  3 files changed, 137 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index ee2d0879c292..6df716533fbf 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -191,6 +191,8 @@ enum damos_action {
> >   * @DAMOS_QUOTA_NODE_MEM_FREE_BP:    MemFree ratio of a node.
> >   * @DAMOS_QUOTA_NODE_MEMCG_USED_BP:  MemUsed ratio of a node for a cgr=
oup.
> >   * @DAMOS_QUOTA_NODE_MEMCG_FREE_BP:  MemFree ratio of a node for a cgr=
oup.
> > + * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:        Scheme-eligible memory ra=
tio of a node.
> > + * @DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:      Scheme-ineligible memory =
ratio of a node.
>
> Nit.  Let's wrap the line for 80 columns limit.

Will fix it.

>
> >   * @DAMOS_QUOTA_ACTIVE_MEM_BP:               Active to total LRU memor=
y ratio.
> >   * @DAMOS_QUOTA_INACTIVE_MEM_BP:     Inactive to total LRU memory rati=
o.
> >   * @NR_DAMOS_QUOTA_GOAL_METRICS:     Number of DAMOS quota goal metric=
s.
> > @@ -204,6 +206,8 @@ enum damos_quota_goal_metric {
> >       DAMOS_QUOTA_NODE_MEM_FREE_BP,
> >       DAMOS_QUOTA_NODE_MEMCG_USED_BP,
> >       DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
> > +     DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> > +     DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
> >       DAMOS_QUOTA_ACTIVE_MEM_BP,
> >       DAMOS_QUOTA_INACTIVE_MEM_BP,
> >       NR_DAMOS_QUOTA_GOAL_METRICS,
> > @@ -555,6 +559,7 @@ struct damos_migrate_dests {
> >   * @ops_filters:     ops layer handling &struct damos_filter objects l=
ist.
> >   * @last_applied:    Last @action applied ops-managing entity.
> >   * @stat:            Statistics of this scheme.
> > + * @eligible_bytes_per_node: Scheme-eligible bytes per NUMA node.
> >   * @max_nr_snapshots:        Upper limit of nr_snapshots stat.
> >   * @list:            List head for siblings.
> >   *
> > @@ -644,6 +649,7 @@ struct damos {
> >       struct list_head ops_filters;
> >       void *last_applied;
> >       struct damos_stat stat;
> > +     unsigned long eligible_bytes_per_node[MAX_NUMNODES];
>
> I understand this could make it time-efficient.  That is, without this, y=
ou
> will need to iterate the regions for number of node_[in]eligible_mem_bp g=
oals
> per scheme.  By having this you need to iterate regions only once per sch=
eme.
> I'm bit worried about the increased size of 'struct damos', though.
>
> Do you think the overhead is really significant?  If not, what about maki=
ng it
> simply iterates the regions per goal, and add optimization later if it tu=
rns
> out really needs?
>

Got it. I'll change it to simply iterate regions per goal.

> If this optimization is really needed right now, I'd like it to at least =
be
> dynamically allocated, for only num_online_nodes() or num_possible_nodes(=
) at
> least.

Got it. If we ever need to implement the optimization, will follow the
dynamic allocation path.

>
> >       unsigned long max_nr_snapshots;
> >       struct list_head list;
> >  };
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index b438355ab54a..3e1cb850f067 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -2544,6 +2544,111 @@ static unsigned long damos_get_node_memcg_used_=
bp(
> >  }
> >  #endif
> >
> > +#ifdef CONFIG_NUMA
> > +/*
> > + * damos_scheme_uses_eligible_metrics() - Check if scheme uses eligibl=
e metrics.
> > + * @s: The scheme
> > + *
> > + * Returns true if any quota goal uses node_eligible_mem_bp or
> > + * node_ineligible_mem_bp metrics, which require eligible bytes calcul=
ation.
> > + */
> > +static bool damos_scheme_uses_eligible_metrics(struct damos *s)
> > +{
> > +     struct damos_quota_goal *goal;
> > +     struct damos_quota *quota =3D &s->quota;
> > +
> > +     damos_for_each_quota_goal(goal, quota) {
> > +             if (goal->metric =3D=3D DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP =
||
> > +                 goal->metric =3D=3D DAMOS_QUOTA_NODE_INELIGIBLE_MEM_B=
P)
> > +                     return true;
> > +     }
> > +     return false;
> > +}
> > +
> > +/*
> > + * damos_calc_eligible_bytes_per_node() - Calculate eligible bytes per=
 node.
> > + * @c: The DAMON context
> > + * @s: The scheme
> > + *
> > + * Calculates scheme-eligible bytes per NUMA node based on access patt=
ern
> > + * matching. A region is eligible if it matches the scheme's access pa=
ttern
> > + * (size, nr_accesses, age).
> > + */
> > +static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
> > +             struct damos *s)
> > +{
> > +     struct damon_target *t;
> > +     struct damon_region *r;
> > +     phys_addr_t paddr;
> > +     int nid;
> > +
> > +     memset(s->eligible_bytes_per_node, 0,
> > +                     sizeof(s->eligible_bytes_per_node));
> > +
> > +     damon_for_each_target(t, c) {
> > +             damon_for_each_region(r, t) {
> > +                     if (!__damos_valid_target(r, s))
> > +                             continue;
> > +                     paddr =3D (phys_addr_t)r->ar.start * c->addr_unit=
;
> > +                     nid =3D pfn_to_nid(PHYS_PFN(paddr));
> > +                     if (nid >=3D 0 && nid < MAX_NUMNODES)
> > +                             s->eligible_bytes_per_node[nid] +=3D
> > +                                     damon_sz_region(r) * c->addr_unit=
;
> > +             }
> > +     }
>
> Seems the above code assumes entire region will belong in the same node. =
 But
> the region might be laying over a nodes boundary.  In the case, miscalcul=
ations
> could happen.
>
> What about getting start/end addresses of the node, and checking the cros=
sing
> boundary case?

Got it. I'll add handling for regions that span node boundaries by
checking the node's address range and splitting the calculation accordingly=
.

>
> > +}
> > +
> > +static unsigned long damos_get_node_eligible_mem_bp(struct damos *s, i=
nt nid)
> > +{
> > +     unsigned long total_eligible =3D 0;
> > +     unsigned long node_eligible;
> > +     int n;
> > +
> > +     if (nid < 0 || nid >=3D MAX_NUMNODES)
> > +             return 0;
> > +
> > +     for_each_online_node(n)
> > +             total_eligible +=3D s->eligible_bytes_per_node[n];
> > +
> > +     if (!total_eligible)
> > +             return 0;
> > +
> > +     node_eligible =3D s->eligible_bytes_per_node[nid];
> > +
> > +     return mult_frac(node_eligible, 10000, total_eligible);
> > +}
> > +
> > +static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s,=
 int nid)
> > +{
> > +     unsigned long eligible_bp =3D damos_get_node_eligible_mem_bp(s, n=
id);
> > +
> > +     if (eligible_bp =3D=3D 0)
> > +             return 10000;
> > +
> > +     return 10000 - eligible_bp;
> > +}
> > +#else
> > +static bool damos_scheme_uses_eligible_metrics(struct damos *s)
> > +{
> > +     return false;
> > +}
> > +
> > +static void damos_calc_eligible_bytes_per_node(struct damon_ctx *c,
> > +             struct damos *s)
> > +{
> > +}
> > +
> > +static unsigned long damos_get_node_eligible_mem_bp(struct damos *s, i=
nt nid)
> > +{
> > +     return 0;
> > +}
> > +
> > +static unsigned long damos_get_node_ineligible_mem_bp(struct damos *s,=
 int nid)
> > +{
> > +     return 0;
> > +}
> > +#endif
> > +
> >  /*
> >   * Returns LRU-active or inactive memory to total LRU memory size rati=
o.
> >   */
> > @@ -2562,7 +2667,8 @@ static unsigned int damos_get_in_active_mem_bp(bo=
ol active_ratio)
> >       return mult_frac(inactive, 10000, total);
> >  }
> >
> > -static void damos_set_quota_goal_current_value(struct damos_quota_goal=
 *goal)
> > +static void damos_set_quota_goal_current_value(struct damos_quota_goal=
 *goal,
> > +             struct damos *s)
> >  {
> >       u64 now_psi_total;
> >
> > @@ -2584,6 +2690,14 @@ static void damos_set_quota_goal_current_value(s=
truct damos_quota_goal *goal)
> >       case DAMOS_QUOTA_NODE_MEMCG_FREE_BP:
> >               goal->current_value =3D damos_get_node_memcg_used_bp(goal=
);
> >               break;
> > +     case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> > +             goal->current_value =3D damos_get_node_eligible_mem_bp(s,
> > +                             goal->nid);
> > +             break;
> > +     case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
> > +             goal->current_value =3D damos_get_node_ineligible_mem_bp(=
s,
> > +                             goal->nid);
> > +             break;
> >       case DAMOS_QUOTA_ACTIVE_MEM_BP:
> >       case DAMOS_QUOTA_INACTIVE_MEM_BP:
> >               goal->current_value =3D damos_get_in_active_mem_bp(
> > @@ -2597,11 +2711,12 @@ static void damos_set_quota_goal_current_value(=
struct damos_quota_goal *goal)
> >  /* Return the highest score since it makes schemes least aggressive */
> >  static unsigned long damos_quota_score(struct damos_quota *quota)
> >  {
> > +     struct damos *s =3D container_of(quota, struct damos, quota);
>
> I'd prefer passing 's' from the caller.

Will change to pass 's' from the caller instead of using container_of().

>
> >       struct damos_quota_goal *goal;
> >       unsigned long highest_score =3D 0;
> >
> >       damos_for_each_quota_goal(goal, quota) {
> > -             damos_set_quota_goal_current_value(goal);
> > +             damos_set_quota_goal_current_value(goal, s);
> >               highest_score =3D max(highest_score,
> >                               mult_frac(goal->current_value, 10000,
> >                                       goal->target_value));
> > @@ -2693,6 +2808,10 @@ static void damos_adjust_quota(struct damon_ctx =
*c, struct damos *s)
> >       if (!quota->ms && !quota->sz && list_empty(&quota->goals))
> >               return;
> >
> > +     /* Calculate eligible bytes per node for quota goal metrics */
> > +     if (damos_scheme_uses_eligible_metrics(s))
> > +             damos_calc_eligible_bytes_per_node(c, s);
> > +
> >       /* First charge window */
> >       if (!quota->total_charged_sz && !quota->charged_from) {
> >               quota->charged_from =3D jiffies;
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index fe2e3b2db9e1..232b33f5cbfb 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> > @@ -1079,6 +1079,14 @@ struct damos_sysfs_qgoal_metric_name damos_sysfs=
_qgoal_metric_names[] =3D {
> >               .metric =3D DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
> >               .name =3D "node_memcg_free_bp",
> >       },
> > +     {
> > +             .metric =3D DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> > +             .name =3D "node_eligible_mem_bp",
> > +     },
> > +     {
> > +             .metric =3D DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP,
> > +             .name =3D "node_ineligible_mem_bp",
> > +     },
> >       {
> >               .metric =3D DAMOS_QUOTA_ACTIVE_MEM_BP,
> >               .name =3D "active_mem_bp",
> > @@ -2669,6 +2677,8 @@ static int damos_sysfs_add_quota_score(
> >                       break;
> >               case DAMOS_QUOTA_NODE_MEM_USED_BP:
> >               case DAMOS_QUOTA_NODE_MEM_FREE_BP:
> > +             case DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:
> > +             case DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP:
> >                       goal->nid =3D sysfs_goal->nid;
> >                       break;
> >               case DAMOS_QUOTA_NODE_MEMCG_USED_BP:
> > --
> > 2.43.0
>
> So, the overall concept and definition of the new goal metrics sound good=
 to
> me.  But I'd prefer having less optimized but simpler code, and nodes bou=
ndary
> crossing regions handling.
>

I'll prepare a v4 addressing all these points:
  1. Fix 80-column wrapping
  2. Remove eligible_bytes_per_node[] array, iterate regions per goal
instead
  3. Handle regions crossing node boundaries
  4. Pass scheme pointer from caller

I'm currently on a break and will send the updated patch after March
10th.

Thanks,
Ravi.
>
> Thanks,
> SJ

