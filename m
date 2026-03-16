Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E2FEF53D9B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2026B037B; Mon, 16 Mar 2026 17:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36FA86B037C; Mon, 16 Mar 2026 17:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227346B037D; Mon, 16 Mar 2026 17:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 123536B037B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:10:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7CA19C2086
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:10:10 +0000 (UTC)
X-FDA: 84553168980.10.8FF3195
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A3E020014
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:10:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vEZD/ogX";
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eoxj3io/quzMxGdB5JqTh5Z0Db28WSvYHgOTXomSdzQ=;
	b=io62hFAHqmz4yVNN1jc8u8Smttvg07xTDVb3k4MMbUAu4OOiA3whu2lNZG1+0A86iS2XUj
	T3FuuH1+Y/5GozfHvmEojEkPNzLmUwvN3xJbdoz6pdQG8f223p+kzi5qy6SAqpVuVKxhEv
	BaRciU4fC/4fR9j28EpHJsWL+nbha/8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="vEZD/ogX";
	spf=pass (imf13.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773695408; a=rsa-sha256;
	cv=pass;
	b=VfsE17WpqmiLQxTH7LJrlsOae0WGPPY7aN3gIrMseBEm63sfecm7vmGm4ArAIWGGoLLR5h
	yxRTO4Mrdg0rp9KlDU+fcBV23RYEBEk2mn62NwRziXhfvX9FXFUwgP+BqRF0TyvjFeshjb
	SW3VuiN6Y7VQtYSpatm4iG2E0UhclE8=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48569636800so24715e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:10:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773695405; cv=none;
        d=google.com; s=arc-20240605;
        b=kkzXNTXs2ZU50DWLlx1CwmU/88EwicumbaYSWMcdkqu4IZZ0DDhNI94j6kGXRlTsT2
         Dyeezorqbqarh9u0hDijtvF1ZSTh+AELaF0X8Urpjao8vdirtB529uBTOGa0HYnXAlLJ
         3wdASfPwY7Xizo2SPZbMC4UPXPAZUHCf+RzkYCIrQFhkAESBbuihmw34muQPv8gRnQ9l
         bSyvjm/fJWh6pnM9SiKCI6R+480n24T2dOrjbAt47UOe330Sfx1RQUFXFbOhLY/pfXSr
         kg0B2n6pe7XRGnMiF25Yz7HjQFhVXgXKsTneCyOQdNp0PvVkScaDtVFMQdMPBmOMfCMZ
         8RHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Eoxj3io/quzMxGdB5JqTh5Z0Db28WSvYHgOTXomSdzQ=;
        fh=Oo0qWPUSNcMn43ZDox0WvILvsTfCNdUzwwyiku1g5FQ=;
        b=lA6HNJxtuYj2si2Z+B0cNOw9veKbSVXLgVFqs+tqES7K3xOoBpZGfKXaoPGBPApuS+
         z3re1DsLn5QbDFt8xpyUs/QMZV827JiZKuy31tXaikxnnc2I5blsrcxmssOx5xEGpYZm
         q6zIbbU1sHGouLjyTcryFXgfTzgsrpdykc3Mx6CMrl7KsQByMN2T6hC3SJBTlpllYtx2
         uCDNepfFr5lVWCDW6yNNN6V66sgYxByk/b1hI4np5PR5QPzpz80LPcykoiGtERerFBNw
         d1rgiap328BSU4F1VV/+OCNqzu8OprUoqcgp/2VYpznAEnL1AUD5XzvDcM0lx7xUzT1Z
         8dVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773695405; x=1774300205; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eoxj3io/quzMxGdB5JqTh5Z0Db28WSvYHgOTXomSdzQ=;
        b=vEZD/ogXYDwFTvm87jKEgJ9bGr7hX6HXoe4AJGxyj2cdw/Qv3qYAjAMuerJ2vUR+RR
         P+I+jJgzx1MVjMA/bN02NwBjHG4q46IJvcBkF+iTpqnL5eqKHxXzbV9+VTdSdaMRj6G0
         eB5E3s35CEugv8w2i7GvAeu1ktSPklBYkzt14KbY8Sr8NRllEJqbsB6ow21wIaA07KmX
         GeygYl5K/JnRrbprFVvpKUmvVF2+OPna/B/ZGIb4l7NO0KXxwT3r5d0iJaC5IInykX6g
         jkc3MCrGxxzrvRtC2Pai7ufcs9/Ts9o0EymV/D3EifmU5SdC5AjiI1k90utWhEeJlKNr
         u6Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773695405; x=1774300205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Eoxj3io/quzMxGdB5JqTh5Z0Db28WSvYHgOTXomSdzQ=;
        b=fIxLnh1Md7ZAXT71vnMekFYB+WYBVeUq4PpZeZh7VMaxhJZDKdizFiWa+i1go0mzv6
         FUreklZX9emNL3e5k4UYML6D9BHYmLxBTXSlxLpbdK+wjcY+jJpmAy3AcKecneBwcQwG
         EzntF1SlCQHtfnpCRuEvgBK2VpGnSfGpgPt5dz4BhIMs7pL+p5rIiFoXC+F/jVTE8yhU
         h/EKQMfSHSggt7sAzAYcfyZBk3zLa8ppW4gEA5m1jV33H9CXp0hUc6In02ldmMw+i4i0
         GIpJtXW5b7MHO17XG5lQmrT8MOXgLBVSx6Q+k5w6zEecOEBGWARqo7KlPMPLqMkVvJY5
         mSdQ==
X-Forwarded-Encrypted: i=1; AJvYcCUT2RPFVkuI09Iaor5MtqxCiWCXa7RVGC6q+kXAJ9kMpuJ65444fC7aqyubYJXMh/XKsIActdNXrg==@kvack.org
X-Gm-Message-State: AOJu0YwCoMhD2e2jSxx/eIqppdg0ch89Oxwh2uk6zGwmYbBInsPGCYtJ
	4RADPOkSGn1bJd75BkjF6GIE4ZnAKEWsrAbCX9ASOxUYR3Yjlg2OzxCc1rnZWjpPvV0jK9Vx/fC
	Sduv6WJhJJiWREJBF625yNClLMCxqf+nJqi7E8Svo
X-Gm-Gg: ATEYQzwAUqfxqhqXU/EBGf8bXh6Im65prSRdB7hfHMIU5Hvw6iiaHcuZx1MmMm2K7RP
	POiMQJ4uB9n0aNgf8eC7V+w3+PwYZgFC7q3oDeVaBhzyb5uNylm1Nkme8EXGZMslHW4IXP6Mzdq
	yilI2ukGslu9QRiGv5Hj4H8eY8u7/6ljHrwSNTAbVzl/H3ndE0Zw/NMo4jYQMtnbZ7K3sfbTtNp
	hQ9hdNTCXLXEjz9wwezBuZHT3n+mj71QP+YWJWN9HzYjZPLICd/jPsLroi49zeXE0uIniTAJVlQ
	/BekQWl/kbGyPjsLCPrb67mWHMqGZBdCWDtG1Q==
X-Received: by 2002:a05:600c:378a:b0:485:2af4:9699 with SMTP id
 5b1f17b1804b1-485709990c4mr51435e9.3.1773695404853; Mon, 16 Mar 2026 14:10:04
 -0700 (PDT)
MIME-Version: 1.0
References: <20260212032111.408865-1-zhaoyang.huang@unisoc.com> <abhh3lKb6med1LSp@tiehlicka>
In-Reply-To: <abhh3lKb6med1LSp@tiehlicka>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Mon, 16 Mar 2026 14:09:52 -0700
X-Gm-Features: AaiRm51ZUa1oZA-6MK2v5WDq6MdxAhr0EIe-KoPiQ-uvQf3dTAjwft-gVKmzYDQ
Message-ID: <CABdmKX3NUZCq7kq5PGWOUs1Wmu+aT+EfeMpcRxD8PxiRe2si0w@mail.gmail.com>
Subject: Re: [PATCH] mm: remove '!root_reclaim' checking in should_abort_scan()
To: Michal Hocko <mhocko@suse.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Yu Zhao <yuzhao@google.com>, Rik van Riel <riel@surriel.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A3E020014
X-Rspamd-Server: rspam08
X-Stat-Signature: ft8afpfpm13ummfhqftewhcfmpm5j735
X-HE-Tag: 1773695408-486473
X-HE-Meta: U2FsdGVkX19WfXxE7NrzrnESO7Hi1Z7K1NqHu6MGemMb8jJfjWLTWW6Q9oX4CnTDOz0R5XLsgmYkOi+bfHafufg59D4QJxpOCwm95QoNfBkQTFz6anphy30q1OlAlrmRtDbbd1J46Qpw/kJB4C2VdRTK6PnxPyyped4yXOwa7txz3ajaaIBEufd7Q+yhSJO3zq2XLABXEUrNnu0EKy80Uz+QsbBYwFh2C7Wz0OBDK8dxWUkn3xdjXBVzXVEhTWRdTvVBNb/p436YTQX3491JSN4b74nIQvoD6Da4ibrIyhSiDZmwBfGNNqz33VSJEHA5nB84c28fzVsTLHFPqXYRSpjzPNw7IksVDal6Uy5+lq5AT2Y+AN4u9V3Lml0Gg5nYUX0RvnOUyiFHbwf3pPaorVIFwc1J3gg+Nl6yLH9CeAtQuI/w27lYShKOJ6Ymyl7/05YmFig3Uaucw0/zseFxPkGSEaM5Xv6kD/eNUJBD1WmgD1GSV4e+mcnFpAaR6UQrM0zEJjdbnZmK23YvkOL56CraEkCxK8fUH1C0IV2H7bhnEDmnu/NhW32rAR2gEWzF5Kk6dnT8Bs06GvZBvBaREpU34v9qTy3jfTZ3r7KaBANE89reuB1Nd1vMfBgjCC/N0E3FHHswB0vpkIfApzmL7ewjXthCNbgH99XwdLy9+fF3ufwqY2UvNlSV1LdS/bDvyvaZNvz7PwTPmN1Cl82ICTk/7eG6iNQmjl6ifaz8HctQ8ev7tjL7v83Rjqajpjueisa6Jm5wYJN81/urKuTWZB4rFLSr0NsRbf6swwe4jknYr3s15WxEZNnu9HdAEesN1/ODCQdnqhkEDNWju0YOAtRFiw/uc8jWPyO6p08vt0GRiu9HoH7Ree5VQqOu7T/sv0iENV49pLrQXgFh9741ekTJHS/DvnmHQPpFOXuD0zbg3CRAWtuCnFwmlmEJIdr9QEN6gTEt1M1c0eBJc2v
 ba4rR25J
 ClA0AypPrSJkisPorFsamN9qNwa61SyhJTUw1ubXYlBXA2LECgh65ht1YA8bYjEd0lMhw1J3ObL3225yMoks2mglORdE4CqBe3ZcTnksBHOrIxssX/J/rV11RWbJTdig1AX+e47auPoyIBAyHRXgbdLu94PPTstVRWTXeJ3hIodz/NVyn14om57//hP5L/s6YUPGu7sYW4wzXe5zXliJGs+gF0jApM5A477dkBLfpXJ8Y0pC5gwMhh8uwS5gihxUVyblzJ4/XNW7andrswSmHZacN428yr2m20K7lHein455FcO7xT+IS4VdhSgujnkpRnGrm/CEe+O8o5LMExDhmCgqrAs8d6XBEY5rIc1y6bdlXDyf1Ef5fTGYan6q8l35KD/2B927AZypOyHX2jdvwFG2OoWU3nPXoK4P8xFXgWSgKgnhSVaPB4YDTWoLuVFfudgI+GU+UaEfwcvMfLaoDjAcMBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 1:02=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrot=
e:
>
> On Thu 12-02-26 11:21:11, zhaoyang.huang wrote:
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > Nowadays, ANDROID system replaces madivse with memory.reclaim to implem=
ent
> > user space memory management which desires to reclaim a certain amount =
of
> > memcg's memory. However, oversized reclaiming and high latency are obse=
rved
> > as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> > when MGLRU enabled. Besides, this could also affect all none root_recla=
im
> > such as reclaim_high etc.
> > Since the commit 'b82b530740b9' ("mm: vmscan: restore incremental cgrou=
p
> > iteration") introduces sc->memcg_full_walk to limit the walk range of
> > mem_cgroup_iter and keep the fairness among the descendants of one memc=
g.
> > This commit would like to make single memcg's scanning more precised by
> > removing the criteria of 'if (!root_reclaim)' inside
> > should_abort_scan().
>
> This changelog, similar to its previous version is lacking details on
> what exactly is going on. How much over-reclaim are we talking about
> here? Is this MGLRU specific?

Hi Michal,

This came from https://lore.kernel.org/all/20260210054312.303129-1-zhaoyang=
.huang@unisoc.com/

Zhaoyang would have to provide numbers, but yes this is MGLRU specific.

> Why doesn't our standard over-reclaim
> protection work?

"there is no limitation over nr_reclaimed inside try_to_shrink_lruvec"
This means that for proactive reclaim the check for sc->nr_reclaimed
>=3D sc->nr_to_reclaim is skipped, because the !root_reclaim(sc)
condition is hit first. So we never abort based on the value of
sc->nr_reclaimed, which can lead to overreclaim.

For try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
!root_reclaim(sc) check was there for reclaim fairness, which was
necessary before commit 'b82b530740b9' ("mm: vmscan: restore
incremental cgroup iteration") because the fairness depended on
attempted proportional reclaim from every memcg under the target
memcg. However after commit 'b82b530740b9' there is no longer a need
to visit every memcg to ensure fairness, horray. The problem is for
large lruvecs, the lack of a check against sc->nr_to_reclaim inside
try_to_shrink_lruvec (caused by the continued presence of the
!root_reclaim(sc) check) can cause overreclaim. The non-MGLRU
implementation in shrink_lruvec already checks nr_reclaimed against
nr_to_reclaim.

Thanks,
T.J.

